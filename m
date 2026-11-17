Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F23606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Po2hNBbv
Received: by kanga.kvack.org (Postfix)
	id 954E76B05B5; Tue, 17 Nov 2026 12:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904ED6B05B6; Tue, 17 Nov 2026 12:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F49B6B05B7; Tue, 17 Nov 2026 12:30:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57F4C6B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:30:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC9E0160530
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:30:10 +0000 (UTC)
X-FDA: 85445299380.07.B7DEBA9
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id 19372A0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:30:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Po2hNBbv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794936608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aALfBnHCZOzfuylqdTOHOun8tGX3lrLnramFxzlcGnk=;
	b=x3t10jxtMvRkhUrop+Mzi8wfQQPSI6v2HHeF9ItfAzeBekLWoFm9EsSbh7EOL75WvwMbf5
	pqwK9cb5sdA9+VY0G5GE3rGFiokN42PhfHLD02cbtN+iYoLlSsBb2yvDAWYs9gOQPx70ft
	5hkfB5bd+L0Gx55fVxr4kLoYosL4m9I=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Po2hNBbv;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794936608;
	b=Vw2TFJhnZdZSdbylZR50W1MgZUQ74yA0UddPARRIzGBVq9i8GxCka5eAAw0essWw8X+wtK
	znA3xjzAunaX7r4bEt5X6CMfmcytBSGi1CytKJ4R+vx9QgXJLhQihKgGvlMGeqVDFkSdnr
	06QFkE/OuaB6JrpLJZ1zHY0cgfs4IJA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pMuBg13PqPnDBSHEo93wgmSekhpIwiH6ABeq+dAQh56ogZE5OO6l9myAdL+zD6YlO5veb/EqogiiDopU6K6GdDw4bmKukfNZRs42f5mrpP+FtTQ5t4SrRu0b/OOr9+5bv216fhdDZsVH2/AmTzgjhZsEss4GkFyS/sTh/b9UU0rDvmP9AFe96oAIqlXtRxMxWD9a8TM4xqaq/yduAl4zMt/GWeQSAubUEYBFm29pT4k2mDkkgjdfJtqST81Au6jP6a8AG3Y3dl09QMcJKZWfl94m/zvEzi6pXY7y7eX9nyidiyfQHdSI2lGXV7LtPU1f9v8asqnrQcu19seejOK1oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aALfBnHCZOzfuylqdTOHOun8tGX3lrLnramFxzlcGnk=;
 b=ERNuKLJVFxYX0BERegE5h7o+kQf/vVYdoVpKbEPYehcXIl5xkmDC9K2R07Jy+NNgg8Xx9P5AL9YuWSe5NyvkxGXdDh8ToFLO6TXAcV5gGvJVpoO5pzcWINY5SrPfJTbg5SKQyjZlaRh3E+gXfUVayYzJ7NgNBxrDI6t5ZARVCipok2pMnJB9vox3fmp5M6qAJYP7OTYIny2GGPXgkRmzn425WjlSw/xFSFK+YL7b3p8z0oouVEvZCLs+9l8vRsLXzKT6dpXCDaG6Nv2FHRfaXXCyDZmkpg6urbAZeGAt8gXL5p/nMKGgyjyxbEdA5zjUxZngPcxYKKCVGB/MCL/+ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aALfBnHCZOzfuylqdTOHOun8tGX3lrLnramFxzlcGnk=;
 b=Po2hNBbvUt8uVljy0kMdqNSstA3QhI1UT3ylrGRhsseyOVyEtrCacunCpwf3y415Xgg+f5v8Nk/5JHHLZKP/nMRKhi/h6Yb6UzjjEvp33EmQ4TTlt+e5rRUc/nDPSZxEOf0LnM6B1IiLGcSCa3GtC8Jq3q5wgvFaUeRGjrTeVPdqWHfbCg0ESKIuzr2gM5ZeHvkHZGzxQz+cdAQAfwWWpBqQFaoKr6eYOCpWbiP+yale8ukCAEEf5z4WF6SGKLTeHpuf5xesxr2iCvpYeOigymPZSasuGCpHh9W+k16YsWlHxwjIwAIwp24zTJVQWmlFuU5lEI8rIN2nkt1wBck1aA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS7PR12MB6311.namprd12.prod.outlook.com (2603:10b6:8:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Tue, 17 Nov
 2026 17:29:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 17:29:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/compaction: do not skip the free scanner's periodic
 lock drop
Date: Tue, 17 Nov 2026 12:29:50 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <94C597F1-DFEB-41BD-ADD1-A6DA0A9875D2@nvidia.com>
In-Reply-To: <20261116125746.2897395-1-kas@kernel.org>
References: <20261116125746.2897395-1-kas@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:208:23b::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS7PR12MB6311:EE_
X-MS-Office365-Filtering-Correlation-Id: 29724617-e81e-410a-e162-08df44d063eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|18002099003|22082099003|11063799006|56012099006|261102123227099003|261021121427099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	nXSt+5+udoMWXS1aXcHo9nUhvRD5g7H+IpCHSoYDCPiQAfyqXzmAffKv2UTCP71VIQsAsLrIaxvlLlSXOtBzAODcDAZbal8H40HtpGRdIgfXPFDdINXldconFJkN9RgB2FpOxyaSAh+nuUMRb7vihwZJZu94UDZ/zwTOI336gDPJOlcg35rJAZSZqcSuP523ddk/bspDRX6gH1ZZa3XnGb6gs4+oo/Y/md9+fRJrAFkhVN1u1MFe4IIiZiY+kQFyenz5lQPwrn6i3M0rc3mVx5+7VXmkCgH+WMxDvUgkm7xK8zfmp1k+gcVRJtZZP+0NgX1tWY0RbSIPZ9gc10GGdeTmxEGyQ6ejQoy960igZ4g8tox5DluqOq7pkAgBBH738iJ+P7hqBBZEtfclidPadsAP2Q2/0iRlfT9kY9exZsd12cqLsqwj99ipQX9bKh1Gkbro6H63KOk11I+7fkzCKkJg/VDPB/S7e5L2+FC2k7+5o6xIyBx3ZC3LdHwu2PDVO7X8O8LvUGVEyOH70nP5Vd50mMhoBphM8JLnkechup0WrEGzylBdqM3TXWuafUYNLWn2l1yVTU0+RQaAjBXIeTdfCfV8m+Fa0sc5RUTqzKxu4ZtZOLY0LXLECXthcfmjlutLxKjyiQqpoyMBmGNY4r0CoSO9Qp1RJyqpPPgVuBk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(261102123227099003)(261021121427099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gZOMzmOMCVtig9I9VLfH/vrec977pqrychAFkqZMFKCo86UoXWrXdCwjCobg?=
 =?us-ascii?Q?naCcp6aLIDfkFLa1fXGMP+FWUBeU6FXDWzvmQx1Oh+UY2jpUcgZnfYoSgiSg?=
 =?us-ascii?Q?AQb9Io5L/JpOyi+f5olGQj6DOYG7RzNGBYWPzGsOVsUV5xl1b7cJM3aoXVyD?=
 =?us-ascii?Q?YPvNec4tbqWTUks0tFDK2o7TA2N4mH+rMonxS4bcgGI3nQXVl7MAzgmH0mt0?=
 =?us-ascii?Q?khDXskhAzsNKPIozOdvJiJZt9KL4IDJI0M+t40OrxhePLJSTjRkoQcexxsox?=
 =?us-ascii?Q?u5I+9EoLxzpcJAWxZIhk3n7QVdkcWQg/eX+SbZaoEgV2jnNuO8l/9SqiyID7?=
 =?us-ascii?Q?83Q0MSTTH9cBLLuVE0McjE/vXBCeUr/XfShxzBN3SuuXgmHXotf+reR2d1u4?=
 =?us-ascii?Q?SoJBJ67cQuimEyUHPQdPz1fleM+P3wKzmGuXFyumNUe8dzo1HBv9efQ84Dvf?=
 =?us-ascii?Q?8JJPviav7/XCcnrMrMxqH8+aH5r3GJ0ud7CDuCLEQQIkV0C75KS/l8hvqr7U?=
 =?us-ascii?Q?WcrZtPq3gyP/vJ7x8WosDOjzyXqJWlBxBpbF1DIO3QlaEpF5YFAXG8sJ/+oC?=
 =?us-ascii?Q?U4i9Qp53SUn32ugNor/8NS1JCFowl1U5MoDhYpQ7ffIeuA4yw1wW0QOofffR?=
 =?us-ascii?Q?X0vbqgcQxb9FXB375N/evsn5Y5EJK2KGAw5Tmxjr1map8TOYkk6uDkYgbngr?=
 =?us-ascii?Q?y4WEut3/Cr+Bt7hpJTrBFYgODLqHPuBPHvS0ORDQisd57veFLqyDlb1O0a8a?=
 =?us-ascii?Q?jJb7dgGnk8wiKenYaLMhF6EjAaxjQHlR91bUOehNQbafmb6l31EuxRHenczw?=
 =?us-ascii?Q?OJkdYyA+ZA/Q1KN5H5KO52lMGKbtr84OLJqqBUiV7d3tj0zSyUjd1YjZVeJW?=
 =?us-ascii?Q?R/bT0Fvdtz5ABF+pmc8t6Atp5RSpyFFqL03yiiTGL2kbIik0ERmgOLNLvnKo?=
 =?us-ascii?Q?FBydkfCpVFmMGr6Uk9NcjXA2BQi5MSc87AhZY8wRLSSj8yCAgO9tAi8vj+QG?=
 =?us-ascii?Q?A+rr98gzcCO4oGccPpWUCm3dqjddxwfVaxzzJIrc8EeFYQY4jPgMefPzvOiG?=
 =?us-ascii?Q?iZt1SqRFanX2ILE5uHPV7GiPUrGhs8o/tpkiy7jS1uhRhoJFX/6r/fz5m1l9?=
 =?us-ascii?Q?m1LPwX4mVopaXyHcetYoZqLZ7T73MZXOyTmx6VMDI1n7IeQiylsFjhRBUzQB?=
 =?us-ascii?Q?2tTjtdjqhBomdSx7QrA92J6x0Ck5QIy6wZDtZnPQ1LDt9xhk0f2M4Vq2C4a9?=
 =?us-ascii?Q?s4e9ppD7/+MmwP4jPBRfTzIK+5cWUhl4xWI/6fPo0dwoW3QLfla2uVfBEInm?=
 =?us-ascii?Q?5Wz2YwjIkzsUuyECe8kEmDXEZbNPdHKqj/FlQOGTqxGmAXLlg4UVBjtPbVia?=
 =?us-ascii?Q?G8ChiZBX4atOGT2Pc4HRU25qFVOOwTlfRsjziUCL1B++TdWa8vyVA9XYpEca?=
 =?us-ascii?Q?/+ZYUsRd/NDwtwsM3a5sJlJUo3lBGxCOm2PdxT1Z5r816u5u8lnU4n5VFGWY?=
 =?us-ascii?Q?6WEWm9edWZBMeZ2zwdePnSwcxb0duidBPMPOFV6DNgnzjf6oGhsCLi1S8Lqa?=
 =?us-ascii?Q?WFFd2wAIb+ho4YrdH/OKzzjxYokLz9p5kVRJk8Ky+s8XGNbqadFN9aYZYIGN?=
 =?us-ascii?Q?PqNP4Dm/8NemAYD1MQGfwq/JZtaTUTJUSFJenxe7NTec/zJtYEPpYeMwaMbG?=
 =?us-ascii?Q?3L5rovXkSS5wuzga9qP6NR1Uw7hl43aucZjWFI2wk7/Ux7Xk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29724617-e81e-410a-e162-08df44d063eb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:29:53.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QA7IEWMMQ3QWQkNbTvnl9/NjcxxnGpjOUvsnSgjeqmLz4gL6afs/aZJRpyPdRH/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6311
X-Stat-Signature: zndgf968bojm9dorqozrjqem9nwxkkcr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 19372A0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794936607-332952
X-HE-Meta: U2FsdGVkX19H4gZuiVi4DygDTV0S2sNHazJKL9P88QUy1fVrcN9zRFegN+N9P7LoCS56vD3qPp7esWQWnrEhkXBIHXf/sCAooF5Z4tjWMdH3+nXAt1sTLEpHFAHnxvGVFP0Mof0o1tNGeVPpUE6aWcDhBtHccJUmtm6k/Ul4IhVdgK8jd3w6ZR2lLvYfjs0+sZ1pEoNdTdXbtTqnXY7yzVJ4WxVgaCp1bZkv7sDgdfAn1Itaybnfx+cCdjE60hLgMAihRg4fzAJ6hItn0d1MA0twCFPJ94dKEgluCjo4hePBWejdvS/PrGIfz20ibydYkFhonEH++oXVV+25koB619+L/PaO4zqSx3ohwaUDttMhvMqxTfDLtkozCWQQSpgAUxBE3UlQSB1OjL1yXN7F7PAJKVZ32emew5mEp2IkG+z0qz1DxPiPV8K3FL0hD7E4LMQ1kels55OD21T2As4t0dbW83tuZ9XRqa6AegrEtMz20gykybV5XVB5l6tLqAZY/T6dGsYatiHYiBnGffA2dDdADfNq/qefBlUcuStlkVbBcfmbj9fUrcVMtiPV0tMkgzGgIum6u0slEEKVM7JwIhrdpZ7Qtxmje0lfDvPCuVSqnvXIrcYlRxBMEQvvqtpkVOcF7G65+dHLLzqhla1/N1FBdgZSIfed1cmpSVvWBvZOvdYnv9G8yOCfNL9lDRrxe123q9dLQDmrBlj9Mq0AwoKhzFqq7QaSfFMSsIyuhayShCTYocdHYLPLUXCPWMsf8M3NUOzsejaS0l5+RQekKZ6tUYBpR66BpNI++Owi3n5I6oX8EULJzqBvoxqxpTThh2V2KIHM4XYdmGTn0HnIgv5kPeLRiZbvJML0gIwwfaNzToVnsOqD+UObh5bnbGj4nBYkDSx8tpGhLQn6n5HDE8p5nQHPH7IztHDlfaZ/TvTLf2mdEiMs7EBGSGTAE9lw4tShkBo9dtljmb14lk8
 cIgHHAMA
 grElxBYBKhD8hC/tmm5ZVKrxxxssb9Y9K4mJ43scF9C4P97V9hIWgmi6tPp0EjokdCFnLnPbeDxCqS9mhRo0utG8Jtx79XtKXSnnGDcKGsMqFYaa0HYT3Lhf1o+ZcPMAoNeARxL9mgIBgxBF29VFOogPcYUT1el4TzW3gt30fBCSPlWpkzmemfzMq01rwqgfUT9GYx0WxBHeqHnSfItkVWPlnNuWe+PMGSnhWQSlibCIWJsE7XDyo1YRVH3ZMRpbx8n35oqL3CZeOqrnLfq2/mRW05shsdsgDQB9QqUFogqCQHnQr1kVgPJMVpWMT2K76kMdO8QInLe3u2yvpGcZFd7mVInitq9TPUuLY0tySIu2UPUqQGEU3p9zD3mjwBy6lpS2uLDspgPVYpu5pNBfFMZCtL/38b0xzt5AO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16 Nov 2026, at 7:57, Kiryl Shutsemau (Meta) wrote:

> isolate_freepages_block() drops zone->lock, checks for a fatal signal
> and calls cond_resched() at every pfn that is a multiple of
> COMPACT_CLUSTER_MAX.
>
> With a stride above one, the scan steps over a compound page, or over a
> high-order free page it has just isolated, to a pfn that is not a
> multiple of the stride.  From there it never reaches a multiple of
> COMPACT_CLUSTER_MAX, so the rest of the pageblock is scanned without the
> check, possibly with zone->lock held and interrupts off.
>
> Count probes instead, and check every COMPACT_CLUSTER_MAX of them.

Makes sense. The loop is working on one page (regardless of its order)
at a time.

>
> Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/compaction.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

