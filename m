Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEA7CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5FCF6B0088; Thu, 30 Apr 2026 12:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37376B008A; Thu, 30 Apr 2026 12:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26876B008C; Thu, 30 Apr 2026 12:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2DF56B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:33:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C363B1C5AC9
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:18:25 +0000 (UTC)
X-FDA: 84715578612.02.B0D6827
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012028.outbound.protection.outlook.com [52.101.43.28])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9341B18000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:18:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ArT3CvjN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777562302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3HlJPLreTlG0sSeaa+rZN6Z+/L7ShrKEMAI5c/b1DA=;
	b=orjxUVqKQLPhtdlY6VHB+mGE24nlPlT/cL9uLldITqk887KYx+uFEUxl0Uj4Hv22lBdAKg
	kpqd3bj0uVyDFc7YC+byRlmM9Oxc4YiF5OPEnYfEPvtMamfI4PoKrpimmcSbp8S3RybkyC
	VggbL/Dylsn41SCBaM3Ry2PeNyB5TXU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777562302; a=rsa-sha256;
	cv=pass;
	b=n2yohFWLADLnDRyyNRbGoQzj602CxIUvEDkqbSf0lpXQ7IbrBWQlm18QBiBlAseeH3YrEZ
	e4F7nku8IAWtkgXyHT2pR0M8VeWd4T4mnZzTTGOExHD7O+xipw/zW+DyW9dq4g0C88QcIP
	6ZBGcdI+wrvNGQNbN9pIibE0VTu7xt8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ArT3CvjN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+QGQ9QNnpNsQIy8cRurSbeEMTnSJq4AHFLm2lNyD/PUmKfLAyQgnpdPGQ6Cpd3MikmIse7WXs2OGWOc7mtL6YBFE529ToKSU5mRRTWAICbGQ2JcICd+AUsZPT/u73QFtQPSnI8gHP/e66xeQWDCDoHSrSju/VMgPWbxE2MmvXZpXyqtGExubc7QMJ2Ru5lYe6tUTowafeezv4YWhC5u8KqL1Kg4uQLy78CoPzILa+wTR7dTOWFSpdWI9Y3lLfgzTQZvhwsVwJhw5nZzcX9Cd8f5yURb6qkNkIjjnwGuHtnjid9jXR83wmjybJNkpk8VSFVDWrN3HTw0vCCg91Vgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3HlJPLreTlG0sSeaa+rZN6Z+/L7ShrKEMAI5c/b1DA=;
 b=yTgdLkGICEjV2GXfxhl/OhAHNxjLo9/c9TFEtERyLS9Wnz8Rbm/s3GGzje7DNgLyvkdS1sXBQ+XVM1Kw/dMbxRfUDWb6s4m8nsvWtNShbfKLJMG4E4xY1vcmah8/k0460yXhbAgAJ446OCbpoWiheDEHpQDmZCsMqnNQPDux+gnMQKsKG5l3O8pIJLiHD/aQbKG6TeNnAxPdugWKSwKeuC21DAar3H8dYowwyBE5xLGl3Ay5AVM6k06R/sJPDVQV41X9j5tu1TxrA+ZYl9cCla54a2JKuPckeBhgaW2uzKzZQ1H8pKt7xMEgTF6aXlf5rLBTT0zTRz63DxQh5sLYYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3HlJPLreTlG0sSeaa+rZN6Z+/L7ShrKEMAI5c/b1DA=;
 b=ArT3CvjN8m7TvQ7tus14GYsmgnilrSJ8rUc0e81E5mcVPzATO81YqJAVF/0wlfbqczsR/Hxu0q7SaI+1SNDt0vYx+r4RBNxBlLUPImT26p0fBUDJEDCB/AUvclDHJr09On0KFteI8AKAVTARgIr3+dtUcNkOTinnJOmjWwVrBI1UPO668wZAIms0yBPdWh2dTeImu1m+TyuVp0pfR8e+5TathwZzI0Yzs0y/BmcYCDI6Qi1ef5Y0q0yz0MIAyfyZXGxRnIAgDc2dXPnoJMG5zz4AutWeNYHX5aLkVNiSG+Pb3lp1BkO+aGEcv2wbIRXVI65rW2M+Y6NL/jDrKKh3yw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.22; Thu, 30 Apr 2026 15:18:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 15:18:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio
 collapse for writable files
Date: Thu, 30 Apr 2026 11:18:09 -0400
X-Mailer: MailMate (2.0r6292)
Message-ID: <CFECCB44-EEEA-4D3F-A505-3BA2C564C107@nvidia.com>
In-Reply-To: <20260429153538.727855-9-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-9-ziy@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0143.namprd02.prod.outlook.com
 (2603:10b6:5:332::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV2PR12MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a52495-aab3-41c6-8de4-08dea6cbb1df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pbtETsOVx6sxX/MJpWH7JWVPozroNPHTRqA/BbegrqjDLB7hqWG7Kq3rkrMwiDlTXwgki2zTAzA2jqmxcURMv4COlAEfqK7166z+7mSsM6FY/r7pE9NEOnqX+lgrmxdYq5T5IpQKQ7vz9wiiqumCmND7RVOJ/UZGcZP+yJ3w7B1yGyP4/mnoQzShsNLf0H9FFC8kzfShf82ZXLfoxV3RK31qdGrryfR8Kijnd8nme6ImdmoiVPCCwg6+yn2BIHGT0yXnxzxZ9CcQU61ZC4+fzejdf8ejj8zipkljA89vnVcnogjLGBtbJH2k99dc+bRT084JTLpvfeJcHL2N25uV4hWpOS1OC2txMJH/95sgmTkkh9TSS+V1lngECTMxXEp/A4LmdAPvknNVLjW6tFXgB5NdQbuaPy7RrpT1F4HmT9fXqQ7QZWcrHMJI1y2vzmXUGKaTHwT9SLbTa5P7QKGiHMKQkxmjHDIRhjRzGu0g4+61Hm3vILoMJ6X5zaOymZywpp2PvTmzQ51hCmHTLH1I4wWrtN8LThz31BZeQ/9yRvV+70GXib2L3+htSFg6c8pDCRgr/ZRkqxTu01FWjr4JB9FOSmkEGWNP9T5isbwaXNlhR6ViLJEhwAvcgd3FWYoLfSGz1DlWcIQMnw3fIFjlONJy246cCIEjDVdWDBV7Iw0F0Bps5OdBz/9fXTRvRf0fL9/NPP8HxRtM4cTtXx566uQsehCdTsp7K6H0fuCHkbA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTK+oWkglfa2KIAvRYxnDFsQQQ8WnF2dQuaHVPQNQK6nlKw5mic05t5a6CVI?=
 =?us-ascii?Q?Ue0//BmeJgT90kHZAgRG4Mtrs5yOBH6oT/AlMAE1rz2pcjQ8EnD/uQdeMjT2?=
 =?us-ascii?Q?/Lqn0jgP1Zmnaf8nvCujuBUNl0R3M7FOE3sLahUk6Z4AMHOOsc1K2eDMOGPb?=
 =?us-ascii?Q?SOt4ZCRclWUBSDjduwCca7DJOdPe0SLFikqFljDUvqMyjGps/dmWRVk40l2Z?=
 =?us-ascii?Q?OhNJTX9U6AbOU2OjQiDtGarse5yZelfPgNfWMXOvUFaXnpWdWAJZ7psG+cUR?=
 =?us-ascii?Q?0AZno6NjiLevS9xfs5FlsQuccRU1e7uxD+eTdN9Cuys2K+ja98gLR3f6CkR6?=
 =?us-ascii?Q?YfhESNMsA6fZa1z6YzrWT0jCuge68VbJPf+Jp8tc14itPh+0c+f7vO2QQWtV?=
 =?us-ascii?Q?E5JrLmsjMdXklUEbr8MqynAh+AntGkGJboZIjSHaDAsTKtoKQM1hpuZB85YT?=
 =?us-ascii?Q?jXNrpSLeemhiB/yU2kKbtUEbJxkU5hGgtreDRC/SYx/3qvBeBbuzNvsoU7Mz?=
 =?us-ascii?Q?T0z4d/rvo6BYOSansSN4bXP7chSdPT+59/EexuhSFNiO5/qsBXBck6tikKuT?=
 =?us-ascii?Q?6Nvnl6UoRAjqUl59k9jQLg7kcarzh8P3Pb+QWlFJG37jbInsAjACrcrU1ZO6?=
 =?us-ascii?Q?3EvglqJcc7B333hgKgkCL/2Lb5j9dm12wOo5brM9XcJweWP0k8+kbVCEXkjI?=
 =?us-ascii?Q?S8JBRUwlxCU3BQQDFbwEKlsuDIeqn1F5lwZkp8HuUlJ/QwIkPs/KMNlfv6mO?=
 =?us-ascii?Q?3eq88XUZldaLYRooP+XmD1dBrJFNSDQscDGXsTjNmYagCt5hQsh5WTrILxgz?=
 =?us-ascii?Q?Tuq999SdUpNrZxPUyYwdUzziTp5vda3Klmk0LLfL5VxNq3OB6XEgJ/bKQVUu?=
 =?us-ascii?Q?NGBz1IkCT7/AWal4r+e+h/Q1wFWeqfpCWbwWaZKzrRttQrCMcN4ubt2IACfO?=
 =?us-ascii?Q?ojmwst152jrXOOUGsrYvoMfNN6Ca+P8e6PZNHSLoafbu2i4ynpW3mlq77lG7?=
 =?us-ascii?Q?U77hERx0BlXSCKfsfnbvaUoc78RC5DtLogAGgQMbuXirEQaWfEYeHw2YFs91?=
 =?us-ascii?Q?dvSq1zFDPbD4jRaqBuUWQsVg8MbH67s8xpxJMr1ownx8DyCM7FuGwqtxC4ws?=
 =?us-ascii?Q?Ed2vgV/A4l8PZE0L6yFV4eUJoA9hAdXWEK59xYz+YjDPNUO+1b5gd1HMsknB?=
 =?us-ascii?Q?CDIPgE+gU37+YMvkGnGVfb7F2CnYw5xun5pVl6Fj0yIszNKC8+FVKoEoop1+?=
 =?us-ascii?Q?rwfZs+scWI16jna52iy85JepjESOBIhvYbHwhnEdxpaRa/MKsxNLH51j0jFB?=
 =?us-ascii?Q?XgCr7hppf05Gwk7LimVU4+ZeSSt+H9GaJ/pmmDR0ITX5sgLXibVZ0qFZcQtB?=
 =?us-ascii?Q?YLnKKtn4nGIQReu0vOl0TdeExkX48mCfNJ4NYUric4afRrYiscNMYvGXCNhd?=
 =?us-ascii?Q?oBKb1HZkhggU/IExwWnz0CRVHgFpeg+F0qhu9ofp2ZA4fn6ZYnfoPoRfNPOY?=
 =?us-ascii?Q?/seM60PV/f5rDxhvLndBonafZNTsOL8duAKpf06r1bd9jbMGjXC9S0nh/uo2?=
 =?us-ascii?Q?5ej+e/7VUDMNRKR5Kzoavp1rW0i84TJEn4RDSfQ5RGdI0Efcf44ytGKFFjYI?=
 =?us-ascii?Q?hdEcuYhuN6ux2LhvpIScXAeF5R8Ol34rXBlqFcWPC2ogwx3j4HIrD/P+dGl/?=
 =?us-ascii?Q?JznVAEiAStomUhpiCTgtuwdkSjjWr4gr/p1fG4VIgFq3W2sw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a52495-aab3-41c6-8de4-08dea6cbb1df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:18:12.7229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuIXbZRb7qbrrq+H4yF8bLuJsBalzVYvdcTriIgB4qNPhnO3aBPR/cRtUlDIJXDR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9341B18000D
X-Stat-Signature: 91akejyjgae5tptmzhezz8eh79a9f3pf
X-Rspam-User: 
X-HE-Tag: 1777562297-658949
X-HE-Meta: U2FsdGVkX19aPfsRYV3W7ePXT4yoGYK2sNweJkza7M/PZJbuu3ELcNCwoIrnHF/fZJtgJH7ahyhFuY1jPSdWGQeWcdzRA0l0he1UoBsUkCdWUl92/bkcuLqI0LHgN4fxcXxfg+OzBVhDBqlyQbaPy7GBlnxMD1zmtFbBrIbB97/4h0KbPhmrow/oVijS5llJCj0271GVk8NZv8GnMRZSBJG0WNjWd7T8Tss2aI77KCaA+Y03PDPbzRDGIPeOU5iIwh8UpLvTI8FgwqANG4b31lwnPCSqK37QSfQ65kFU1AjYLtV2IhAdz5Fe0bMHHqOxPiHC6xAGoyUBevxm0TnLDydHEJsyFSf0i3M6GkipkQ0XailWwh3c3YWV7nQ2NB5hvSH2LANOD98qj+/gPk7/RqQtvfEvyN1DhwY59kdh+pbw6dc3yxt7DGlV2MKmqAFdTyEfr8QeljoxNdmESEJjweV7wFHiC2rDg2RXAI3EuEGiYVXtEEbQGia6c+zaDpl9Qho1eu4Afo980EpNcsHWctCN77M9bnt1BXkZ3Sgpd+XwNRN9EJBwjLyJP+ThRPAi0ZiYK38LvaV0vg39kmPxBEUf+FjZHLLU6+6NDBRh/1bC+sSwi2Zq+yu7hEGlwfU2cBRllZINVL9a+2TKdssnOBPz8JXB20mVta77svQLkCtOB2WRfnofZsf//Kc4/pWgKNM7g17wZx1wrakqtYZOd75y+xntU82JmBZIgMtW2wfkwAZO5jNYE6oskh2eYbCYbvoOtN8eG6v6Qx1jMWwmB6G3NtNJIjkez099z/A0YblHSHS757+KnoTFhATfjezbBcLPrQ/O1K9pkH95OVi47/8lWMrA6Lfvccf6xKPB/INjw9d3IcHNvnLbxA/Z8cQKzWQBiqQJNKsQl06WhklVDI9WjFsOiuo+O333WGqTcJxqvBHawuB7tpFv0HxWsyodys5B/lgnBnpOXyAxm6Q
 gcmOhrVb
 i13YxLd07xhOK3Sq8a6BL2iRF5U2BEjm8f/dcuPchRGmdivn0Kalnxq4M9uQZSnRJOheaHPY7ucWpnIE/Ef1IHQ2YdpIhJSkK7iadHp9l/dRagA1TVYxZUcIqMYD5iyblgMiD/9loYUqwo7lPowF2kvrFoNAwO5WJq/nLwHqQk8baLIXN0rRn+gjsfAkNCnSzYCaCpwhgmH84suXnldGyeetOSFWfMVc9KOuw8Jw/JJDeM25AKWYlsYYHObpeaAOgGcdri6gsFORtIeO1LHZ6l/7hr3/xN+ff/TRDzNuzh33MW17/iZZMgzwBHnXLXMa7N8LIWfCdy5cCHu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Apr 2026, at 11:35, Zi Yan wrote:

> collapse_file() is capable of collapsing pagecache folios from writable
> files to PMD folios. Now enable clean pagecache folio collapse in addition
> to read-only pagecache folio collapse by removing the
> inode_is_open_for_write() from file_thp_enabled() and only performing
> filemap_flush() if the file is read-only.
>
> This means userspace needs to explicitly flush the content of pagecache
> folios before khugepaged can collapse the folios, or use
> madvise(MADV_COLLAPSE), which does the flush in the retry. The reason is
> that blindly enabling dirty pagecache folio from writable files collapse
> makes khugepaged flush these folios all the time. It is undesirable to
> cause system level pagecache flushes.
>
> To properly support dirty pagecache folio collapse, filemap_flush() needs
> to be avoided. Potentially, merging associated buffer instead of dropping
> it with filemap_release_folio() might be needed.
>
> NOTE: this breaks khugepaged selftests for writable file pagecache
> collapse, which is set to fail all the time. The next commit fix it.

Sashiko:

Is it acceptable to intentionally break the selftests in this commit? Each
commit should be self-contained and not knowingly introduce test regressions,
as this breaks bisectability.

Answer:

I am fine with squashing patch 14 into this one, but it is unlikely anyone
gets a kernel at exact this commit.


Best Regards,
Yan, Zi

