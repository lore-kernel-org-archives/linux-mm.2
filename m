Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1213606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fjnurTtP
Received: by kanga.kvack.org (Postfix)
	id CFD966B05B3; Mon, 16 Nov 2026 11:50:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEDD6B05B4; Mon, 16 Nov 2026 11:50:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76716B05B5; Mon, 16 Nov 2026 11:50:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6F26B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:50:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A1A1C0193
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:50:08 +0000 (UTC)
X-FDA: 85441569696.27.9278C6E
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011003.outbound.protection.outlook.com [52.101.57.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3FA5210000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:50:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fjnurTtP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794847805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9ikCO6i2e+I+cF9pVcl3zDzxQUnxzZXdQisWorEuf4=;
	b=sfGm51DiH2bwZnqSMN/ODBufo2uTmypUUYb0MvJXgrfHzkGHhtgywNS2lNvaTvCIjygwYz
	HKO5WsOvWE6D1J7LNSU8/3J33CzjHRGEx5g7GpDSpJfSuydWbD3g6YDLDUtF+WAFTgyEEc
	LLwyonWnWJBRCTX6r4hzz5tvzDoEJmo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fjnurTtP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794847805;
	b=spJygVeHs+EK2tYN6YpiPnY5gJTOx5kzD/7ZC8FigafKby2gkmbxQh+7F2k0FCqHfYZCsw
	aNvtewDiTgE7+Lw6ppG206Y+l8iVodthI/ovxJthkkjAkrMTw5EkhMgOySCPtQPvpNL/8v
	3cWBe+uTyjynThe03AGkeHiZJ2+BDMo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2e77Ij8iyM+IrX/QlfiiGfF2YJ1I+aXwOcuGCmh13hmS9IUpGzRSKJsCgWYJKF6rBJpvoZU2cIoVbwfcwRqqLAU+PliukYZw60C787dirCzEKm+FJeQU4xuhibUEut6N2ueQf7x+vawI0HVTYv3HsT32V7AFf9qB2qnwkaVXfhjOUEKmKcCZe/ZrWzNbfu88QpIUrN1DeeeMeR0lk2uWcMpy7Y5zW2zQWsgYm32eofbmbO7T7Cq52vyu2fbU2Xq2zR4JsK5W1n9k+jfnmhC4LtPcsO33YvDR0CRoRUm5fD2UZNmu0cleSlNjT6KCC2Wmw4v+ytSZw1a1uIbXxGpJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9ikCO6i2e+I+cF9pVcl3zDzxQUnxzZXdQisWorEuf4=;
 b=QLKhLa9KurafV8LRcEAwE9s7zQ5dJ1zkimufkDAm+Vlx+bWYWsQV8EGv5SnkHpyKFMSivpUigs9V2VSKXeBAT+Y+9vHynRsxNmmvnCILCFChCugxzZ7rHOLeggdN4U+aSjJV7ofkrsv5Nk1nHRYnnsrpSTf69yNP9V1+rHLkLr6arTBzMPBHumNq1o4D6U2pu1pV/cxL5dgH3kqdXB4g89kDiDJ+xIfqJPnzhiV1UQOMO74WRBQaAMq5A3F9KHjNkxqmq78LXaeOWSOgClyNapLbovtIvxteQ0mqGu0w9hYOqkOndfkiH91noVqkp/epM7qo+gZbTb/Rr1wHMc0SQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9ikCO6i2e+I+cF9pVcl3zDzxQUnxzZXdQisWorEuf4=;
 b=fjnurTtP4ydMRwaZ3DFb/NDw0vSxq4wuV3TAgS7t5vJSJVIZIQOLTt2Oo01QZEETb0kA4qma3RZix7YNEEhateJmavA9UwW1aegHoiHkwrplSvWKfQjG8wGsFT9ATSnFFS/NJKdBjR0UPJRvNpSj/H5/kAVTizR95tRBeBxRqa+XXbCf5YhhwjfigzAwz3ajrTq3fabM6VBfcSN9esZJYK8SYnO5+reUA3E1ktmKewhKRvWLhiqgZBMgSSi1J2XVPYAKUC6JTNWks3HvLYm0c4wNnU+0O2KRlk3Oz3Lvoc5Qy9e3WzX4+VjYpr4XDy/sxil29paW5iLrQNtmI+/bOw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB999298.namprd12.prod.outlook.com (2603:10b6:510:40b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 16:50:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 16:50:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mempolicy: merge adjacent shared policy ranges
Date: Mon, 16 Nov 2026 11:49:57 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <A43DE178-DC38-456C-BCE7-3846A01AFA60@nvidia.com>
In-Reply-To: <20261113-mempolicy_limit-v1-1-16688b2644dc@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-1-16688b2644dc@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB999298:EE_
X-MS-Office365-Filtering-Correlation-Id: aa5f87a2-d194-47f4-bea6-08df4401a6bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|6133799003|4143699003|11063799006|56012099006|261102123227099003|261028144727099003|261026140227099003|261022105027099003|261021121427099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	L+8L7bTRIpMrwtwm7XvPLVdtOYbV8fFWQUl+oycgbC2zHh3EZ+quy+XQIg17qCCW58xsrk10lQ3cgigtWwc1eVSISJmsZ+9RDbtWaOUPlTtidc18zvaqAp+ivQhX6tNrnzs4QGA5ndfL1zWXp6hMPqiroeP86dylSN2rDCW8Rz5cCbE/ecP588ycOoMsodBiht47va6gGeQAP9e0g/vh66b5xGOtwKgNXRw+zCI2ExfZMVk7GiWvKpVCU6F/AVLJri+Ump528MZBzHSgI+1iMGVemOMEocVGiSGMJJDLxJsM2TeZioMKp8OPjh+k9ioWteczCUQDJI8LFgB0lrhHxe+b6gW6XGyvL9WBqStdJVUrSSmw9CrKcz23bjOmhKI7rNuDlTGRE7XI5Xt35U7FLtVPkdoxA5qedFPxa5l7oVMHtnr1ugo6BL2+YnE41LlqPGJB5HLiqUFZyLbtvfVFKL7CSAdsRrgDuFXBv7GkJMe/SZGjDpTTMDJ8SXbV8PEQlj4dSFtU1/B53XGKgcTNtnIs/r2QGvf9FuOugp8AKTE2mH76k8ZY4Qx10N0Aj5hkWeJCf3OAM5vSvjforkIpm3nOUFJyGKpOeK0YBDHhA42OGpTp5nMizJZ3dPMHBipwCsR6HH1TaLQIgzMItJxEWfqaOFVeBMXsRBwutorhLNc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(6133799003)(4143699003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261022105027099003)(261021121427099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qj4/9AR1ZCJo++VtgyhmJ/7dwHdaSFVADCftuySzz9e2foYNOp00ouDCW0QO?=
 =?us-ascii?Q?ka8JtOkAM3gj66K2Kh5QFr/pMf7l5M5ejE9BbDkr+VVBCTIv8bZnQeDP+b83?=
 =?us-ascii?Q?zwut8xFR55xLnI8jcXnfeoxNL8F4lRkoefz71z0QPXaM3e/eFZgHMeoXPKjx?=
 =?us-ascii?Q?GEFhIecy9dlUdt/+1dY8QzHe8pbYehj9hNIqskr5FdfbHtC1DIDC2kOwOR+x?=
 =?us-ascii?Q?XFoNVtrhzP3WJqddXCYCilVqwlObWWsVHfL6affWfDMo9ch9mY/0cI4fFTFa?=
 =?us-ascii?Q?DRDhjTb2nlOM/jrp2V6sGvHKyvJ2ao3B3bLRPj7bakag6QjQbxZm5zZj1TXe?=
 =?us-ascii?Q?AUq3IOsar/j8ykRW3rjr+TmBFHEltA9rxlu3eDJwligPVMxYSi3RE9eP9eQm?=
 =?us-ascii?Q?slhRWaF1th3HppQkQenuycQXnjXKnGOupXkc64Cqgs2xKLR/HayhsPRcqIGs?=
 =?us-ascii?Q?SPB06u8X9wq/WEyR1OKcpsk/Kir1Xc0FE3D1Su+4YI0sS2Zs/vzBOzhXwoq3?=
 =?us-ascii?Q?OQl0H1pf7V5ukXeuJ475AuKPDR/hLlYBxkUwS0zll+upEt2z4pVS7FyM6Su1?=
 =?us-ascii?Q?k6nqHiD5acApGA63xFULTrdqeC4okKx6+d2Wj0kcI6YZ6Lxc77hUeE6sJ/ei?=
 =?us-ascii?Q?15kZVUU+eNxlQ5yCQTtbXeXMaW2ctofFmquuwgMV8U8aYSYTlBaPDz5P5nIx?=
 =?us-ascii?Q?8cFR1YjgZt34SiK+I9RqkM1ZPA6lsJJtrIbydhqWVmnWOD2Weo9tmL05RiRl?=
 =?us-ascii?Q?faoPG7/IH3aiBzWFHdAUr+aiJoacVui5JdG7YD3B9UKeDCkvjvfUDeYu+Ojh?=
 =?us-ascii?Q?mgMpXKq1gpIz+BC5OLZ4dZecVBRzH1bFRuo2xIVKQ69Dg44BxPHXm8K9Ls5i?=
 =?us-ascii?Q?AaNw62DAbVzeUEW9XGvNOy6gC53BmEf0xfBzcOonMXaB+wDKUL99biTWhfJ8?=
 =?us-ascii?Q?Hfp8gB67uw1JG8KHy/N4A04X3dZdOMmL2o3BorjqJibRpS5V9QjwgEv6+F7n?=
 =?us-ascii?Q?5WaYAAyjvzS1c9miTbEMx2yehURhgtJRlmZm55vG9smPDsC0VLNjlYfAWPeb?=
 =?us-ascii?Q?x5XqrmabpP6oB4/L2bcNRsMtjTnpGM4d5oDrs3YxEUOLVj3koFSuJ+VJHBMK?=
 =?us-ascii?Q?fNmTxsANOeguDVimhK9Vwd7JGvBmgXXehmf/DQbaS4Pu6Xjy9LNYrf2c+51g?=
 =?us-ascii?Q?vlU4qPRN+3Ea7WFfFczyRA+uJKLBL31mI5NbrDLYnKm0B9L2U40gZfDMvX64?=
 =?us-ascii?Q?v8Nm5BB24p6LMUNQAmkeqWz1g830RI0fOdR3W6pkdCrsDySZx4Ad+n7wjT5E?=
 =?us-ascii?Q?a4xauGpSbdF1lS/QagCJ8CfjJCUfM91S2KMdnedhKTKhrIxL9oIJmebHvOB1?=
 =?us-ascii?Q?EwDVvnmn8NmDUSMEeON9MXlolqRfJ9d7EqNDbiCfaWiZ2mT25Nzf6zttcmyr?=
 =?us-ascii?Q?mzIhQ1yVID40/uiIgEqPs7SOI6MenApcO9s9fciqv7uw4vJ3QDSa/6TGye+w?=
 =?us-ascii?Q?j4agWwg80bcqgAj9sW3Atxpg6pWcy/Yg3dpwGfqa5XOVxygiXd2+QI95iamQ?=
 =?us-ascii?Q?6x/Htdb40qdi8S2LMbv7AazI/rznLTtU13Rj2+8auIdf+emqEPpZC/8kQny8?=
 =?us-ascii?Q?CBpw76hEw/Zjme3Hhwm5eRwMRb7flbvbBVthhGW7wTbbM368U3ev31cA0OSJ?=
 =?us-ascii?Q?Q73iPWEmPvUKk/YTElUsjLc24M04oGKFpOybuckrsyt/uwR/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5f87a2-d194-47f4-bea6-08df4401a6bf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 16:49:59.4283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5xpRCaTuPlB46Dgr4/0x/2fqODlqA3Y66sdxZqTsjpyegTlsluHc1chqiiN2Acrn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB999298
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3FA5210000C
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mjwxnum3hogforci3g9npeq68hsa4773
X-Rspam-User: 
X-HE-Tag: 1794847805-954130
X-HE-Meta: U2FsdGVkX18DD2iwlhHYI443H5Lof9t6SQ/tDe9kOTuVQAW7Z/w5c5x2Ef6MXvMepzVX0seFmeHQy7/IpgZYRy0Kpd9ZP4JyzdAMW6wPwiKW6pGGoPYFtt6ITDl6J1JVPrNhU3jZL7DsVW5ZbY7sUkXgEOYYSTKkkKNaqWGHPcT83lncV0WZeKdH86eSOYLV77nEyVIZqH6gv87QVQPCLbhVOi2R52rMjogkj06yNextFl6th31tJ8C3F59DXqWqwvUIe84dEjOrkWbZoRsHYBE+PUSYAhBHjnu51nLadlpp1CY6by6gxEx1CtpaU4W+HXc+9QQDQ1VKUwFMBVKw4euYov1OzaaaRPs9pnwYDffHiTg115YjB783vIFfOiQo/3gZIu5Zui4BfWavX4mkIoZmpjWd339Vg+hGlamFXRJQCyB9OTUSD5iC6mZwRjwGTAdir3zrXuDZKe1ppI7U2E+xBBH58Y+O/xHm0BJVQo1HdKK3aHU+X4hQ2sHL4gB0Ql92uBJVSQP7brLJQtCu6zUAraqYxEFiFq6sDY/bTI/lmgpQTOHAMiOAgjZ06c1NSl9ainTbX/W59inEoHsEyy19mflS+zrRRrDZXkMfXE4EXiIZBjiT5sLMXPl602eQg4OtWUjkWBcOmODnwFrvYSLQoDFCgAAf6sumqiOREMWruHPuCrOMGph/O5GFH2+DkHMSRLkqo8WDRCcyA9u6xpp020gdJIVxBaFSz4qcIofydQcBmTLYDxJ04FEcs+7P7ZE9dzDaTj47+3YLTZbngacF+5QOf5CuOWrOj82eTRfKecTD/HlC5YEXi7l/f2J7AWXpHHYd9PlMfUJ1UmcI3c9iOpfehhosLIAC940vH4tM7qbYRCQsNRncvxJZCtGd+pgAH6sXdNz9VUKcw8FKc3iYGX176CiUKR11G4pMaavhOpFRuCVlLp2Qe8AEHMcoXuaEsLCT8EbqmyYdq/t
 V2eaLaWs
 Ky1ZY1r597L+U5He0fVje41jbYCdS7NOpzYFzy1Jsy9zLEwzUbN0x+dg5gfokQ7olF56kpgT5DopO8hJpSJKpYKItRANGKnd29+Kgtp6Axs2GWjODo5p105IffgjF2hRc4MGqf8ZJvW60IN6VSJxm2A6BgdvlqQ3MnbRmTimlefEYsCjfpN1RdCMOh+ILzt3DWTFk9d1p6vvUTKbqzteIby8Oxv7mkIqStXsmEU8NRaTNdRhS/E/z+WvukTU1z3/MM7bkWg/pTyn/xUw1LkWSAz0+FO3bpb7hy781P8lEa66PsnFrKSAPWTnziyVEKSkgMW9SdK66THjZRJGv9B9KdOjvrfol2YmbdxOYdHqB4AqBbzX3zYMpnQqmjhShwVwOHTC4l7R6TRDl9ng2hBEy97PPUTjqWhMkFlY+KzkjyBX4IP8fpBfq6qvs+SWR4+nYGfgjJ6fhLmcaZcz1Vg7TQTbeK6hSo+Zt/pU4vfNKNneZefg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 13 Nov 2026, at 16:36, David Hildenbrand (Arm) wrote:

> Shared policies can retain separate tree nodes for adjacent ranges with
> identical policies. This can create unnecessary policy ranges especially
> when individual VMAs cover individual file ranges, and user space sets
> the policy on these VMAs independently.
>
> Extend the existing replacement handling to merge ranges with equal policy
> at either boundary. The existing replacement loop will then remove the old
> nodes and installs a single node for the combined range. This also avoids
> splitting an existing node when setting the same policy on a subrange.
>
> Extending either boundary rules out splitting an existing node, so the
> allocation retry can only occur with the originally requested range.
>
> This change will make it easier to cap the number of shared policy
> ranges per inode.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/mempolicy.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
Makes sense to me.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

