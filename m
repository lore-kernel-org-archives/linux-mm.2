Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEBB606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rMBFrXl3
Received: by kanga.kvack.org (Postfix)
	id D11026B05B7; Mon,  2 Nov 2026 22:16:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9106B05B8; Mon,  2 Nov 2026 22:16:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB116B05B9; Mon,  2 Nov 2026 22:16:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 987D56B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:16:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 938C0160317
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:16:13 +0000 (UTC)
X-FDA: 85392344226.01.827474A
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012028.outbound.protection.outlook.com [52.101.43.28])
	by imf30.hostedemail.com (Postfix) with ESMTP id C8C5A80003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:16:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rMBFrXl3;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793675771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PBp3KjHqZkMycqlnDembWGhSyeoJrMSFrKcxvRx9yM=;
	b=BRoreAzALCjMQJYgreS7SEasT0vM2t2gh8UcNbELLlkkZaMrQjnYwUJmWXblhmOQKzovQe
	+ES2wkHZMnKj0Vir3WF3Z1g0l0M723JMM5gTEVqD4UGgOiqC+7R0dH/9Sqs+Y5hHzGSWWb
	6eSqWtiv/fzhewNug3k3/2mI6xUSTek=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rMBFrXl3;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793675771;
	b=eXK5nRzLzOC78TehkFVghxGKm4ZtaZ2PJjAAbucL4amCZO/lkb2zQ5ugJZlW+o3Ta79bwk
	ljiR8Fk5rNIfSwOubBAI9tx4Gy8fUueAbi90Zeg7Lp6Xk7wOKRPtFeYsyL6yR26NP6H4H0
	1Yw2wCxPp1gjyHxf1fzNERRCb6dP6Xg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sWGOuuIpnC0zaQtIJODSJoJPAj5ebMyPlaiyiU7H3wRuZ4cGEHQrhAQvzk01L1/8Hg7+7yAYl9DUP+wKYsCLkd3zkCMyRq1oUlWw2uvUK7Gp1veHd8nPAGgSoMGrQ4xzixzwX4TDICTPmxE1mt4DAC2TVAzOtLlFliObo3wExUeoIHohMVXayDZ67jtGg72FGD/cxWT2DprTs/dCRozfs2mlm+3/sv0ABhTniDRHyfByDI+NBveXdXQvWya5D2Oxnbgh6Fykpds8wUczO7kl9BRvVnPw+MSPdkmIsxdxrFRCy/MCn2ypJ3KLWWx05OAM3f7XHukX1qlvgrE1hfQQ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PBp3KjHqZkMycqlnDembWGhSyeoJrMSFrKcxvRx9yM=;
 b=cA/0nsmTV5vTcZmzfIk8/fKFSh3yWRQPBeEAEgHFb//JildtpESFkcMqEVYV4mTooKReKGfG6bOpRXZ4m2ZuH090a2N3yDQXhUFstswMZklr/94SxeVirohaPelJjtrE8xx1qCHFP2bhIj9nkeWgqxofFquUnCzU24edgEGP3Z6BWem2zsy5EmT7IJCqgODtF2E6qen+wZMPAASp4nBwGRTtSAUvioRrSxxZkEoIUiP8X0Vek6Z63iE/TCPUR0nxsnIpHlXvrH3Fjn//fhQAcAp+eBiaDxYXUWlm2Q5+Nup7nBQJHa9VMTkREpucTshQ9jNLRaXkhM/EuJB4qSc3MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PBp3KjHqZkMycqlnDembWGhSyeoJrMSFrKcxvRx9yM=;
 b=rMBFrXl3YD7HUsFk3qiNdnMo2sf6Cd8gOXC0z8P0WIkJ1FV6caMrEYLWdRaEfp3CRESNd++HVvhidE/LWNWlbnRfSx5mRW2ooCWXTQdEXLyf0Lg0xJZ3zL+Ngx42h88fT4sxNf09nvrROWNRsiLaUt8t8nhUeqq8phd1W2A3Vk/EM3lhx6TZeZTOXbvqTAd4smvI5fWsAdiJqtvf81pBukkY80WpTvzIKhWmpaUU6d4sR+mw9w3MLuLwUf/TzLluPEbWRIRJOt7ySA/Gt0Bs9mxYLNu/ACPqO+4WpFS6jgubUuIlTm6ipI14PTkIN6R6Sld0jCtkVMtwAJBPmJI8hw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4091.namprd12.prod.outlook.com (2603:10b6:5:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:16:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:16:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:15:59 -0500
Message-Id: <DML8ZOGLGOY6.2KBZ8XOKBAU15@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v5 12/12] mm/mmzone: remove zonelist_node_idx()
Cc: <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
 <ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <kasong@tencent.com>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <baohua@kernel.org>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <baoquan.he@linux.dev>,
 <baolin.wang@linux.alibaba.com>, <rientjes@google.com>,
 <rostedt@goodmis.org>, <mhiramat@kernel.org>,
 <mathieu.desnoyers@efficios.com>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <ying.huang@linux.alibaba.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
 <nathan@kernel.org>, <ndesaulniers@google.com>, <morbo@google.com>,
 <justinstitt@google.com>, <Bessel.Wang@huawei.com>, <jiang.liu@huawei.com>,
 <mgorman@techsingularity.net>, <anshuman.khandual@arm.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>, <linux-mm@kvack.org>
X-Mailer: aerc 0.22.0
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-13-gourry@gourry.net>
In-Reply-To: <20261101021340.2251928-13-gourry@gourry.net>
X-ClientProxiedBy: YQ1P288CA0024.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4091:EE_
X-MS-Office365-Filtering-Correlation-Id: 677dfba0-e73a-49c1-2497-08df3958ca34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|22082099003|261102123227099003|18002099003|56012099006|261022075727099003|261021121427099003|11063799006|5023799004|4143699003|261028144727099003|261026140227099003|261026121527099003|261021123027099003|10067099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	VCMPRVBtlCPk1L0gJ414k14+9gHXczWLwLAo+Cm0+fUUxAug+kQxAvkHTiE+XwDcDUrBW4oFgLV4gHfqGadxgBJuF9Icaj3lgPkJSktxWUBZXS5lVGjuIHincnMXpu0xExBUCIs5L6MTIc3SCqQ+pX8qq7OnKlWTKbrqIvpD/jlEH3GGm4rF2AqKE4t6WsuGfhOUmJUU0mAt78MR18hHFLkX7lwKCDiS4CTQBG0BTiXQssQyqSDY+2fpWHs2NzNue5g/IqYeYwJ008skPnx86bajJdMg6xg4SkdHi6qQ2tfZ8NdVshqfQb3kVglK2BSraCvgw9RoR6RepB9CVW0w587ASK0zhPh7P7kTr68lAaxVo/zTZP90r7dZ1UES1jf0WKoRVx5I8aCOq4aKGnrgkEaZOtq+wqA6kczsadCgzCBC7c9Pr3IhtkA2SgIImHV11kiILkrSLmTVKFTMyaVKy2jgcTAumu+LQqmVmYhguzadWQEVeHOWC/Fl/z/hP59ayAkxsp7SsKRK9CfMuj80lIbHq2YTcwUKBdNUF/ZVp5r+SOID5hXxrY+TEyOxU2iapKPV28AEvD8TJ4GO2Rw87chMHRXM8//ZJgWwCwNiYUr6i086OuqSbH0xuwuegVyGtGt8UB2WKT2u0Lm/4EE4Aw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(22082099003)(261102123227099003)(18002099003)(56012099006)(261022075727099003)(261021121427099003)(11063799006)(5023799004)(4143699003)(261028144727099003)(261026140227099003)(261026121527099003)(261021123027099003)(10067099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3dERWpwY3NJK2lVZGxTNnM3TkxVQmhiK0JvRlcvalBuNzQwN2lKdmQzOHZZ?=
 =?utf-8?B?aWxreHRXV3NCaUsyRVdrQWpRc0FFaHFLUE96T2Q4RjNtZ3R5ZVkxNEk2eE5Y?=
 =?utf-8?B?QXVlbGlBbEpDWUJjeFVJN0lMQktTVU1ydW5QTFFsS2hadndjQSs3SDFxbUNl?=
 =?utf-8?B?ZmRDMEgrUGN5d25yWDFtTTdCU0pldGRBRFlQY0ttREtBK3hzOXc1ZXNqZElZ?=
 =?utf-8?B?Z0lyV2JHRktCN09ORm9jTG40RlhTSng0dEVMZlJqV1JMaGdCd05SdisvR1JB?=
 =?utf-8?B?a3dHdDlPcldSTFc0aWl2SHNwUTNpN0N4Zmt2RVkxMFZKRzZ1QnFodUxqdEsz?=
 =?utf-8?B?Q2hONTA2bkpUREtDaVJyOGVLNnJuaEI5WXFOUEp2NUhYMENvNG9hVFlOZFlM?=
 =?utf-8?B?TThneGVHalcrYUJZazFBK0F6VHUyK29maWhaV2hXN1QrdU56V2czeDc4aXhF?=
 =?utf-8?B?ZzgyaEx2VHF1T1RBNVFuVUo0SEc2c3UyMDVXTmpTVFlXbmdFejFyNEJyMFhG?=
 =?utf-8?B?Z1AvajZrZU82TitVNEtCaHhrVng5aGdZNS9Hd2ttRndXSWFUdVozRUpwLzV0?=
 =?utf-8?B?WC8vVEtDZnpBeXVlZUU3OFlIRXk1MStvSysrNFFEZ2lPNitWUGhXUmxOTSt3?=
 =?utf-8?B?UUtleFUzU1ZlZWl1ajJ2cCtlMC95T2haVkRXcWlkeVBhZzJqY3g4ZlU1OEtP?=
 =?utf-8?B?WDBDaWU3b3lDVURteFBUWld1K1JhZ0lRcGZOMDFySjVZeCtYWHcxT2owV2tN?=
 =?utf-8?B?Ti96MEtBdmR0dGFteGVmUEh2UHdwQUdKYUJPS3R0SEpSZjJaWkFYV3dFMEpT?=
 =?utf-8?B?b2I0UncvaWxCQVhYNG9ZZUExNFBRUjNMeko5aURZTWhkYVc3YnZ5NC9jTmda?=
 =?utf-8?B?aU1nZVdPUkNva3JYcVdWTjAxZEpMRGhGTVVhUTZrZGkxaWYrcTJLWWlMMmdr?=
 =?utf-8?B?c3BqUy9XVHBQU3M0VHdGcHByaGZiVjFTVVdUcnoxR25hc1pTQVViUFZ1OEZj?=
 =?utf-8?B?QlQwMTRBdUxrQnkyRG5EaW5yV0Y4Qi9NRVE2SWF6eUJUQmczRXFiTDVncW5Z?=
 =?utf-8?B?c0t1RG5NaGpTekoxVXZWc21lcEUxOWJTbnBBNDl6c2FKK2xoN2dnOXZGVDBF?=
 =?utf-8?B?Z1pnblZwYzFodWkxMkN0cnhwdjdiem1UUFYwdFh0azFJV0VadFBkKzlBT0pK?=
 =?utf-8?B?UUVaYUtoUjhwTU1DekFPMTdXV0pwaFlKVjlQTkd6Mk1MU0E0REpLbEllRWUy?=
 =?utf-8?B?ZDUzUkJLUzhTZ1REV1lCRkVqM2pyN1RqdFdMNnBEWHJTZnV3OUlaWS9FQ2lo?=
 =?utf-8?B?SzBZNzlEY3JGQWNwN3NVbzhybDVUR2dYR0Z6UHlVNitVK0FZdExPbTZ6Ym53?=
 =?utf-8?B?UzNoRXJPaUljYS8vazR4Snl1REhVU096TUpMb2VzRXprUjRaT1I5RVdFZ2Y5?=
 =?utf-8?B?QXVUbVVIWUZEYTNqekJDUVdRc3pTL29TaDUrUmc1VCs3R2pRWmhJU0tvZTkw?=
 =?utf-8?B?U1JyMFFsVk0wRnlqalBZMm1ZNjRTY21wN1drZFFoZk5FeWZEc1VGdmhNekQv?=
 =?utf-8?B?ZWRhMmFJZWFxUW9yeGVzZ3FGbFFlRWNzS2ZoWVNFWGtUNDhIRXFZZms4dW5U?=
 =?utf-8?B?N29zai9aemVhUUlxTGNta0wrUTVCOG9vaENsbWdab21lT1NhTjBUNWdjcVVS?=
 =?utf-8?B?Y1hFL0U3RU5MZmZocGJQazFmWXdtQU9NWDBjOXRtOW44d1lWZ3NNVHJLWHVZ?=
 =?utf-8?B?ZUgzbWJuV2I3WThOSmtPaVlUMUtaMWtIVlFWUHF2dDBJTzRaVDQ4RllldzZZ?=
 =?utf-8?B?enFOS044RndoVDhsT0hBenY4UFNyaWFMZlI5b1EwVVIzOFIvRFp6NXpIOEVo?=
 =?utf-8?B?MGMxaU9pQnZQV1ZQWWFGUkNOaUgyaXJoc2c0ejNIdmhhendqVTlsTlVXV1hT?=
 =?utf-8?B?SE92THMrRGRYMDNMMjc1bUw5MW40bitSMUZVQnpjQmxMV0JOSEZnb2ZOT3Ns?=
 =?utf-8?B?ZDR4eFR6bHdjVEpQdi9NNFFIRXExbkdtajRabkF4bVJ1a1dhVzdya01Xb1hO?=
 =?utf-8?B?SFBTdm9tLzViRkNLQ2p3eG4vZDl0VENpeTBXREV6aXdoOWNnWjhSTUFsQ2FI?=
 =?utf-8?B?K1ZoOUU3bEI2cjN2SkQvQUVNS2hsdXZHK3BiQTNrVGdYQ1NWNUpmeW9GTGFu?=
 =?utf-8?B?Y1htSzNCMDN0WStIK1VvTFJuQXlOc2Mzbmp6R0VBb3RGQndtQURWSXJWTktj?=
 =?utf-8?B?a3R4d2NML1k0RU90MzNCZUpkd3l4RlF2SEkzVUNXMVdHM3lyNWhNZWJFdUZP?=
 =?utf-8?Q?QvV+URilOkZjVTratR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 677dfba0-e73a-49c1-2497-08df3958ca34
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:16:02.3254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QaZReS6sb6DncmjD/lICWEhczqRi29nlMTpe7brDIKfzorGO+tGJ6T1vo4OYlTXd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4091
X-Stat-Signature: eww57ccqm149pu37dnx6ipex7y4dskbj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C8C5A80003
X-HE-Tag: 1793675770-136610
X-HE-Meta: U2FsdGVkX191WeYbbe3qzVt1TGvKG2Op8RDbHKSjxsEdDdE78YbF8IpNyzu3nfnen0MuHY52hTjMpB8B2L9WtKuybRZ3j/4o3mQ9x/qfg3xQWsa5gwjqycCcSnj3lvpp4Ji/RnPJ7uALxEsW4Fy7eJ6rmuLC5EKsRWkbHhS7XkmI7e01h0tB8Q/n4nTlL04y3ixXPfzCZeDh04QEIs1EeC8MMk+9gR7rlRW90ae84+MacR3FIsy2+Ez5ZxkPH/tVlo6zqTSSnpl3/qiopZmA1WvUZJalrirGNMsJ8CwuyAXEEKe0i2Yp6nIG7Mh6yPffxSW4VOPWN50+d2IHpqqXSzQRILJLTcxK4sNu0gEGXLEHFQw26rzJVHb6Gv1DyOgWb9/Q01IXWRUMW31aVxyeAzDT+2TchJspqjlBdo6Q4XgDOOoS1zEw5rM9w7WXSv3bO1S3lFVNJ4fB9yMaDJL+HEqY6ZJ3EEVnz9NF5+Y75qlHFc6Ynae/5P61vI3j0Vt1o71dvw0FQW8Zxu7Iu5O0hgQ2+IU2fGTHjQNZhoZaZAA5LEgrizSaCGvN/k/iYj2dGtQT7+bzlHAXccu+TVcjdmFNuscZ9FeRKLG5ETkFyQDqY5J+nnT+NjhSGqqI1CSqRrAm0JdcJ1UkMt0M0LBHDB4jG9I5zoOZPSYftDVVZpKvQCPt8MrFB2dUOHlrUcVnt4h1MY8DVNN8I+0bx7Fxg6td7P2CVQX16caQqnr5nJ1ngdWtsYpybKx1Z+5wh88O3u1aCBbsYhLyKpb5TOye/SjOjXXiKKyw95QJGX4gUEiq7shFaMDCUvIJiNXgjsvaI4gBo9/nCQzpEAh72a+nT1J0iVsZKIFLn282bspjD+CISDIecYSKo+O/vzunEgqcvrtWipH8u/tP+rnOD/5j25S5lgVx48/b72P7a5nRaN49P0NPuh0hEPtueMFm/Nzk7mi35PaX0HXq7fRG55u
 uQUSyMgF
 SmpcTLmEgFVnoJ/Qe6Tb5oDq/B6bCyaRPI7uSBmqgv8qqHfqheOlfVPcTNN9bSHmkU6jAtTWHaaU26N1NmUnEO2DbOED0i/UIP0pyoTJ/kTu2TIQlyqHke8AIVHPILqxs3DGMpYV5NL8VEPN1IjupfWNUQKGWugd4UZWu0jdV5AZrwHBg2GL93cWk+8zsK21KsEprY0jt+2yYikIzJK4KnhbF086mrVqDJCf9VrTbjXr7jo7XNYU3y8DNJpwKfkxeiNwYa65MoiZYtGw5Pg5yWfqqub5MVt8ey1rFzC9Z+cIaZVNS33nirjywSYzlrosbvckwB5ccV1+cyu8nKbpigtySjoAD9P52YOGmbdsO+kicWx/B42FzNvmj7IK5R3iHIWNAvcgqNb8u+FV3nShM6S+i+PF8bOPHUuoMQWgiaJJraGCcgyYn0vYZ2HcAb70+UnBcrhecV572qBWGWjFbWZLec6Xa42+Iinfu2FohQpTY4xXk+p6wklvQoq6AFb/mL65PWnlxMbIdUZblIzrSk8C3YiO/OEWQ0lpGGFWm9yzAN+rqz6j2p68uZfR1Yu9dhln+j7GYacPELhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 10:13 PM EDT, Gregory Price (Meta) wrote:
> zonelist_node_idx() looks like it returns a field of the zoneref, as
> zonelist_zone_idx() does, but it loads the zone from the slot again.
>
> Memory hotplug rewrites zonelists in place, so a caller that has already
> checked the slot can get a different zone, or the NULL terminator, from
> that second load.
>
> __next_zones_zonelist() and mempolicy_slab_node() had this bug.
>
> Remove the helper and open-code it in its two remaining callers, neither
> of which can race with a rebuild.  local_memory_node() runs either inside
> __build_all_zonelists() or during CPU bring-up, which holds
> cpu_hotplug_lock for write and so excludes mem_hotplug_begin().
>
> The lookup in mpol_misplaced() is unreachable: it needs a policy with
> MPOL_F_MOF but not MPOL_F_MORON, and nothing sets one without the other.
>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mmzone.h | 6 ------
>  mm/mempolicy.c         | 2 +-
>  mm/page_alloc.c        | 2 +-
>  3 files changed, 2 insertions(+), 8 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


