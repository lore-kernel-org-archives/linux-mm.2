Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4801606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bBKMZjqP
Received: by kanga.kvack.org (Postfix)
	id F2CA06B05BD; Thu, 12 Nov 2026 11:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04886B05BE; Thu, 12 Nov 2026 11:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D376B05BF; Thu, 12 Nov 2026 11:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B686B6B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:22:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAB411A069C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:22:54 +0000 (UTC)
X-FDA: 85426985868.30.6F65CBB
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5EA651A000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:22:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bBKMZjqP;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794500571;
	b=HWpOC59T4UQWoyO/HS/0b/CJv23wGh9MB/2acqYyFQ1UlllOVIsKWqqSiP7q2HaVm3cbAq
	oPlVXC5v2/SfKfTy/HZELheVZfyu4Nspni7n3jICkNGjioUvfav1WjInH0gSjtfTPYqN9l
	BmqZ1lHthOVQqIbRT11f2otrndndzNo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bBKMZjqP;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79rcoSt8s5Y+EgIGO9Ymf5+bH+zeCuM9e526bzHMD+0=;
	b=MkvqcoB6QFty1dOYtIC7YjGum/c2KQJZ2sWXj1cPv328wOKYLPFF0g1FY9PSoAD2Gs4Rfv
	ghRtaz1BRhJY/crSRskO58GxAnFjLf//hbMHI79dTRmfmdZqslkHwrSD75PagQ1v0CGMBk
	VlYJ10I8pCFPVw4VaDeXeOY2g2+WtmE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFGAvcYR5GNO8SEKnGUj9gTw9Hlb62xLhtdvV0xyc+butUqhmLKz9shGlwGFVDgUWTfBDhplynqIGNMoIngSDb6DArb5341at0qd+HMusXoizJ2y4U1+9YUSt2dcIYIaajxPczOyJoxcgqViblrgLmcIslSTmSSKUwGZKFKcyJYW7VElt5DhxP6J9ajFJ5hcfqSj3VRM68XRLyxk0Ucc5jfNOQ/5gvICIvYS3YiKCR1RvX4uxWSUtbQntQsdxnD4kPMrQeZRMp6NE16hMFyScRJPzW1sajRzNBt86nxVLdZOhQLhs6OFN8349CKovzsdMpcGaKRE4NK6Jk2ulfE91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79rcoSt8s5Y+EgIGO9Ymf5+bH+zeCuM9e526bzHMD+0=;
 b=DQorXj25dDKbt3DIR+IZwsq3fuTKqVMiC0DKMzqnFAcb5UKy41TUvfs+n7d3l2ZOW72ytBoaX3crabfaarsHOsra9wx58lWV5ga4d6XVt+ruXu0206Rbeb2aa2dlvkCw4NlDykzX9FL//ZI5RuTTOBBnlqFwdeOpv8BYERf1UBXwWIZM6tlALkz3VKVfbbLvlVx7uvQ1easnvyl1a/5nOG+JEyRPShzTVDB6H0sHVG5zY3ducbRntd2C3bAj5m7O/v1k66Qkr6dWSsdq2g9cl4Ab/lPMFGknQDh0CgnFkN3S9nQ9NbTkw9HD8PxeF32zAx3YXGddastlCmQLmEpf+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79rcoSt8s5Y+EgIGO9Ymf5+bH+zeCuM9e526bzHMD+0=;
 b=bBKMZjqPfc0mP2dZgl667e947V+8O0fxquzUO8aE8iJP8WPEZdNuWs+Ko8vFRtLYvxk7YxlTXfI6yPmo8IV1974OH+3GHuMJZX+JKlO3kMRWDYxSwr9z8vqP22W21csM3eCkuAcaDHiKbxxmuPgAAHlJTnEO/lScQtPZubxr8S3woe2wsxQf3rMGwrESYnsJFWw+DtRSCw8odZ1p78hfxLkkFfXvY4RT2/1JeLgsvM0MhJqKcBcPKoJS9KWseuIiZztLnHKkefU/ZuzkQJ4myEKzKGKzTAxEj2OawXXQ23PU5AZOsfxrD5vtH5bi6wOMzDIxD1FzAuUx6gZ60NDTpQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6544.namprd12.prod.outlook.com (2603:10b6:8:8d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.13; Thu, 12 Nov 2026 16:22:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 16:22:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Gregory Price <gourry@gourry.net>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Date: Thu, 12 Nov 2026 11:22:39 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <C5C863CC-A524-4CA1-B76E-0FA22B166DB6@nvidia.com>
In-Reply-To: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
References: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: YT4P288CA0080.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bdeba6a-1377-4f94-4407-08df40d92ce8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|18002099003|22082099003|3023799007|11063799006|261009223027099003|56012099006|10067099003|261022105027099003|261026140227099003|261021121427099003|261022075727099003|261021123027099003|261102123227099003|261028144727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	B+Jqi8Wckx5PGme2GoHowqcOn96p3+Av6CYFRNxWkuuTiQWGFNIsZ+ozYtED0qSgnXvkpccRFLIL2QOf0OHvubPA2yYU8uc4oBdRRr2F3b0SH2xzqSDbNndblnpuR3PV7Oxa/bGlUSJGUI5oGdn+/sPjNywCRFFCBAx9RWwIfwEhCapfp7ZAndQdw668O2TgkrA/2A/SkC0v4UWBqtVuA/2Dh6fLfp6pOo+FulN4jQZjjg6hiOvQxLYswPbA1WsbBjcC9L20rpmCtOcgt1jR5ZOuIGtwn+o6W5r05VoRQObewYakYRzclSkSF9Sq6LRFgCi02pTfSmyKU7uksYYpvvA45zAbUyAXyADCpT8Hj2C9Bh1W0hhHTZK4IK9M9HRfQ/We5UZ5d4v7FihpHoUqEEixhuxwDFlifOcd1hVQR6wIh6cUdO24lmIljONOimy6xdZVAOvDyj/2IN7O9foCno1eZXX4Bi4HzjR9ylNi/JVrt2T4DqT1N7Yt68wIVKoNSEd/4nEam8yfhHdhVELBKpj3pH0zpgeONBHRV1K0s6xH0w/ZYTzwQR2aoHAhv5jy2MiWcofyzp7uO3riFpj5h2PFcDB9wN9qB/ndoTth3+ICD9dqDPvZqlWrCUVAujIku5nZY8AF6er8OxCDzeuEbMFU5JD7zqfia38Wr66jRFs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(18002099003)(22082099003)(3023799007)(11063799006)(261009223027099003)(56012099006)(10067099003)(261022105027099003)(261026140227099003)(261021121427099003)(261022075727099003)(261021123027099003)(261102123227099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eyEVxSZPrOmYIZ9EWPrnlZ8gRMLYuAqrrpPd6jD8F2WTyeF0xge+d0T3EXj4?=
 =?us-ascii?Q?gotVniNA2K+m5D2NHFI+6vjoss3KwATYIKyH5dYhCQsOkKYJFt6ORVkaAUhq?=
 =?us-ascii?Q?k/sW7B7DBeCXjaHeThlhhnmYkoS+Fen7xJmaMFTQg3Htbc0WqYAGnCIX6mob?=
 =?us-ascii?Q?uX/gJDfav13zOyf1j78PGLgTzzc6brNN4Fidzu/7eR1HA2VLD27YurEAnprG?=
 =?us-ascii?Q?n/llWkGb4ZH9RaM5KH1sF27tEVxvemAUGQVTx2RpPWlYv5MMsvwlapb43yxw?=
 =?us-ascii?Q?3FU28zUyXdIaAbW8OQU8y8uXp9zZayf6roeS4Yqb9cAqqlQv+1K6ibnUNJVG?=
 =?us-ascii?Q?fkQCfCxQr1T7NifDtzN+xnU9n8jFSyVT3smkTbMhCsaYMndKXqsxmP8YzlQS?=
 =?us-ascii?Q?6/69jffZv1VRhDZEe5Za8WS/PujrZwpwuwSmuRuNiYWD06UrkYQg1K/yJbYf?=
 =?us-ascii?Q?B2orc9ExpFlwoWSbN0uuCcWYvZDYKj1MNCf8c/+XaqYmsx+57CLUU/6GpSzo?=
 =?us-ascii?Q?0LkYV998Q1pPpfY19CyUk/PD3uzrfDyK1bHHpbAxtUuy7HYFA9mzXRyoeY6V?=
 =?us-ascii?Q?vOhNEIRq6YvybDe0oDtlGI3UYRhH7ReTG6GCrUp1T8JsgW5VhF0Y1J7Jh9zZ?=
 =?us-ascii?Q?8PX7cpJmIRDQIKRGfTho1PML/Gk+BgwkA/Gsd1rNl1KH0XCyChzlFNfbFL7d?=
 =?us-ascii?Q?jLsn3Lc89AYEQ4fLqCmGNz/iJ0gkPf9zlodmNsmrhMR/SBaDWaC5XlilAJql?=
 =?us-ascii?Q?j8/rOo6YJbv6BIjBUQ1yqLrMYgv4OPpHgRr8YgthLgqDZb3qDQm3gcS63WMy?=
 =?us-ascii?Q?e7vFDhc5sDnT1qhHNTArcqSGJscdAMOcEsxFnLvFCf7XWuHus/UCM5B+W2Wq?=
 =?us-ascii?Q?uDOwMF/v2Ok+kP3m1qMJJkFEqHflKyzytkGsLxPAQwL+dvi5BPvmzG4iTY+Y?=
 =?us-ascii?Q?zlHQnXUdfa5bHV8scT0CmcMcWWwU19HgHzS0NxTWv18gdZFlr3cctCV+gS9A?=
 =?us-ascii?Q?NoNAlslReMPCfKSdDxCM3c5t2ZUIXhNIr7CXQMC86XxKC0hsQ9bWwYtyom2r?=
 =?us-ascii?Q?vxgRN/N00bJdC5OjfplNgT/J3t30xlOygIxcNNtGFGooedWKLrBzxXRBpaB1?=
 =?us-ascii?Q?hMtPsy2VMW9mtuXUZdewVCx/0VVTl7BmMMZnXseSBWWx0cthoWXvkNAVlcj9?=
 =?us-ascii?Q?pkOvpKfgKZNtHrQ2MMN2RbGnpmAKSMZ+9ke9lNKorVW6XczeINCcPRgcRbcf?=
 =?us-ascii?Q?uMjYAQMKVxQusZAk0ez068jN7lDCc9g2Ok5W5vXodFSKcpTFaAWuwkvaxqKn?=
 =?us-ascii?Q?SyNp7eOl1pkP9UQlpAy6y41UlfISkynRETL1kq2vcV2JRAgY+RvfVIIgeFp+?=
 =?us-ascii?Q?bEuncXNezgTEhNBBuxIaxtcUT8bjQB/+OrNolvWMOVcSQSFmjIUYTAUau3Dp?=
 =?us-ascii?Q?SraHw2mqq6C2P+cykAqQ/lhn1JNEwVJyRz6PCTLJRh5jClNNzZXHt55BRLfO?=
 =?us-ascii?Q?Aa8uXxRaCO6YIxWe25QM13TV0PXvqC7YjVii28tQwXJSlwf2xzUWiku21uC1?=
 =?us-ascii?Q?7OkBTUhweGKAl95Z20rDL7CWg0jufWMWhlGgCPIQnoMr2lV1AT4K4T33DVAE?=
 =?us-ascii?Q?d4LVEmbqNLjoEAfWWTIDOr/btfKEZx+UYMIvcyE/vjL6JBg8N4jaaQMYgkak?=
 =?us-ascii?Q?s47tF+mUAS1UV/9mOwVw+3lp6B2m2YyGOMbfIPTpZdeN1k9u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdeba6a-1377-4f94-4407-08df40d92ce8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 16:22:41.7710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2dR/8kwrLABCoqgI2mtGSO0DAK+uEhBScQihxE6mUpoOh0gxtphMuro2wRF7gg32
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6544
X-Stat-Signature: ukmiarmzhm1kap6eczfmkchq39xwtcwu
X-Rspamd-Queue-Id: 5EA651A000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794500571-474272
X-HE-Meta: U2FsdGVkX197NOK2WileuYsOUrmwtFncoLL7kr0D0Zvch0NEMy9nBYP+OIEhbg+h/nf4EVXWNHlYE3nKqn1W/m1Yu0Fr3llYsRBaboH7X4Pc8zb0GaMK4AsjhqZWZza4+JgVVQDaF1ejm/a8f7tlYL78aMIib3mHdy1/AzDvHW7UkJxO2DvwjSHn7h7eTPVxlZ7xlmI6ozkMfBXl6TSRAw4bvN1Pu1cqlw3Kd4zNxkCouz+82MJTJPMrmJ0zTehkrVKbAf0867GT7WwSy27DHcLx429N2xVcd1p+55ZWZJW4qJC30y+pwBjqWG3k7BJhqEEO2lOFmwGd/LsLO1O+P3ifApHJRHfnnj/xfdwsGaza8rxoFbtS+0hvz2aiLi3aBJ2T6DYcKfkpe5OuYOtNx8qx5dSqJqbQsPqoKyc7CjRTfWeEIDEjqtinDnbdUl1YNZ2DOOKs9ucMH54q/C+cF/0LAU0XKEOy4KZtCXZnJsZOgr75Lxm79GrmGVlpzWyXzi8KtzbrcQUbvmvSIbIo+ZkW5tjUkHw/Mol+2Cse/WGJ99VtTR1Iej8e0ZHkVFnjM4a18ALR0gsJAYek3+2w8RwLUOcy/4U19SFwOkNMsQV3hx4NezVsHV1AmTnyj//nED6BGstQV+GU5vq4AqSjBFpNsM54M2XQMhpeeNNIIJ24kGScuJ/cXW0FXRZSfPZ9dyP2wwoZX3VbMB3Rl3KXQS7QE8GawNGfrI47Y5D+ykVTdvAcW4xCh7m+JL/HDmJKgosW2Az2MxeWnWw+QPk1Nssu3W/fNGVDUOco+mFWLtxSePOM8q5aQmC3R+gEfSslko/Af1Pm6roZkLMEvcwYGZqRJXlF1XZrZ8F3Iux75IgDrUjOVOFQaKdHDz8697YTeLiNwT3llfxGmcziAz/yEUJUgvHi8f+6+w4Z9KDqSMh9N6IeUBFNZT3Ewycake93Nl+1UB2X6x6Bh0bPwIZ
 KSUhPcGn
 h4rv5eZ97kOzhWe0aYV5tyIjS+AY77+d/zffFthPDtcwTs0F5JrmUOahY2a+eoKamvRTcXcfKXfh/ha+onXRl6QOJNVV2VSY/f3bVkldLKpD+v1w0uQ6jEjxsA8lJrNy/3Abqnf0oBQseKK0hzbfBPxksGJiLUkmeDXLcd1HxPcyI0sVrBA6FWqV9GIJHvTxTKVTW/rdvXV0sPP6Y8MHDSSSCaaaiDE8PnqAkfVFyiKO/GbDlQcUKgqr6x8nQObK9vRMqC8dc7VNYcKk0mMvOimrWXWCxmr2HFfo+koRYIjzeMo6LV0XkizgaRnFpVbXAeVc102K84P8wwdpha/PJp+sTzrCOqV7Bfo0Nm5k3G3iwrdbKnDw0RMswJH7teSPcwh6nyv4tPoa1FOvpxOv5cZk6WjSTvPdzADxc+UPMsDuHbAGb9kzMRvQ22b4w/FWC81CGWOSeMjlWp19yZwC0dmkKPdcouv0+mpOEymtMKmcpoZRgXLWVHCXHv1cdcX0p6WqXpZ9kUuJxkOB2obM5VS34n1qqyTTZlxYCtzjrNnYbMWXInPYizOh0LQoGPFuKJARt8H2YwuSvAIchXyh6QtrKhhShnARpkzGPYm+sBwUq5U3x6FEAMXHSpUoBWOeSQHLbfrk0k9XDg7hCb0umYoulVSSc8In+DR0A1rwyfG7AL6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10 Nov 2026, at 17:44, Joshua Hahn wrote:

> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node with an
> active kswapd on the first pass through the zonelist, so unrestricted
> allocations don't immediately consume the memory kswapd is freeing.
>
> But kswapd is also woken for high-order requests. With THP defrag set to
> defer, each THP fault that fails on a fragmented node wakes kswapd at
> PMD order. kswapd reclaims a batch, wakes kcompactd, and sleeps until
> the next failed fault, so it stays awake much of the time even on a node
> with plenty of free order-0 memory. This means those order-0 allocations
> get directed elsewhere.
>
> This was observed on some Meta production workloads running on 2-NUMA
> systems, where processes with a preference for node0 allocations
> continuously allocated order-0 pages on node1, despite node0 having
> hundreds of GB of free memory.
>
> Only skip a zone with an active kswapd if it is also below kswapd's
> target watermark.
>
> On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
> and defrag=defer, I ran a process that prefers allocating on node0.
> With a fragmented node0:
> - Before the patch, 68% of pages were served from node0
> - After the patch, 100% of pages were served from node0
>
> One remaining gap is that since this uses kswapd's own threshold,
> unrestricted allocations can take what kswapd frees above the target
> watermark. The current code already lets such allocations drain from the
> high to the low watermark while kswapd sleeps.
>
> One potential solution, as hinted by Johannes in the discussion from the
> original fix [1] is to add some kind of fudge factor (for instance,
> wmark_pages + high_wmark_pages - low_wmark_pages).
>
> But in tests that I ran in a VM where the allocation demand outpaces
> kswapd, about 4% more pages landed on the busy node and kswapd reclaimed
> about 15% more, but kswapd still finished and slept. So let's hold off
> on the fudge factor until it becomes an observable issue in workloads.
>
> [1] https://lore.kernel.org/linux-mm/20251001164131.GB1597553@cmpxchg.org/
>
> Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")
> Suggested-by: Daniel Hodges <hodgesd@meta.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
> v1 --> v2:
> - Added a Fixes tag and separated this from the other cleanup patches
> - Check zone_watermark_fast with no flag to match the call in
>   pgdat_balanced().
> - Calculates mark outside the zone_watermark_fast check to match the
>   style for the other zone checks.
> - Wordsmithing commit message to explain the unaddressed gap.
> - Yes, this is ugly. I have another series to clean this code up but
>   I wanted this to be a feature-minimal patch so that it could be
>   easily backported. Things will be much prettier once those are landed.
>
>  mm/page_alloc.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

