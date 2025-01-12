/*
 * Copyright© 2000 - 2021 SuperMap Software Co.Ltd. All rights reserved.
 * This program are made available under the terms of the Apache License, Version 2.0
 * which accompanies this distribution and is available at http://www.apache.org/licenses/LICENSE-2.0.html.
*/
package com.supermap.gaf.authority.service.impl;

import com.supermap.gaf.authority.commontype.AuthResourceModule;
import com.supermap.gaf.authority.dao.AuthResourceModuleQueryMapper;
import com.supermap.gaf.authority.service.AuthResourceModuleQueryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author zhm
 * @date:2021/3/25
 * 模块服务类
 */
@Service
public class AuthResourceModuleQueryServiceImpl implements AuthResourceModuleQueryService {
    @Autowired
    private AuthResourceModuleQueryMapper authResourceModuleQueryMapper;

    /**
     * id查询模块
     *
     * @return
     */
    @Override
    public AuthResourceModule getById(String resourceModuleId) {
        return authResourceModuleQueryMapper.select(resourceModuleId);
    }

}
