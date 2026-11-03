Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A96606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gs6jq1lg
Received: by kanga.kvack.org (Postfix)
	id 768D96B05B6; Mon,  2 Nov 2026 22:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A506B05B7; Mon,  2 Nov 2026 22:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3B66B05B8; Mon,  2 Nov 2026 22:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E04D6B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:14:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9694DA7CB5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:14:38 +0000 (UTC)
X-FDA: 85392340236.18.2FF45C5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011033.outbound.protection.outlook.com [52.101.57.33])
	by imf03.hostedemail.com (Postfix) with ESMTP id B9EE420002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:14:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gs6jq1lg;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793675675;
	b=C3Nxo1lB1gISFFGBT/4Mq6E3xxNvymca7CxFcj6ijMGJXTl/a0m9j3CYYUY32VaHauwAM4
	6McIb0Zu0mN15WIsvxT1WcJ/ASY7H6BXAszNhYogSKZelt8DTHahCYefdbe6PUYfgYegui
	fACsX6WmJ7ctYTB2mZeQPm4/HTE5gz4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gs6jq1lg;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793675675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAlS0DrCFzk7gfiQ1hWrD7yFKZhAJOM7sv8lP2IxrM8=;
	b=nFgIiIuBZBuTfEMPBxEy6j5nN4UAhLPIGVorzWUODKBIvu7qsGXmJy+kpiz3TarZdSC7s5
	hFahwkoI3Rcg6XQYJiLe8j0xHP+3gewlFDIa8Xv31OvK018aXkTjKHtPJbDj7fj33RHM/r
	JatV1QPNpKg/7Gn2JE1WH/G2ABHMGvI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TchhckvrdssiajG7CPR168K6931QXJlUfybvf3YIsHNYZMnUnqjO2KlQAXPlovulWeIudlv8BHVfoZ0irQVsj1lU5IGlvtWgMQMIanbkrFeYqXjVgZ1IZ3sU2dPjVEx22m1bIp3Mx4igH8sCNYifOeusdfm5MZFfbplaXBXxbiQ3ro6V8O+EpUkjvTX9B4fWUdh1uHCPLqE6Gf215KBLtAG+LvYySqEo5KriISXuoXPxgdLLQUY8dM6r9Y5Q1anek8vH0QJw3Q6/YQ7Ms1EPWypwGp2WXt7YAaBlatRcKdYfzu5REPXd/YgXECA368T9wozFTqsVPtpdjP4pOohgZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAlS0DrCFzk7gfiQ1hWrD7yFKZhAJOM7sv8lP2IxrM8=;
 b=SUiJTwoPN0UqSWHNSG89jkVrCxOdnpRr9GEuGOSxEloxsSN04TDegdACbE/+MEIlw2TjJAu3V+yDvH/PA3t8E6Z4siURj/9m8918iLz4oiWF4wBqZRhWYo8AXShqsc4d+vtY1My9X1K2/7PlhsBcqQBi/nEJz9qyKz729y7Xfgy086DFsigaiOy1jVFX0dp9vTiYmuSLcH1SLjmLMi/bozBk/zMYqVDwMLKVYiGoqDAIBkgkEqrHMoHEWUNEdme74JV+FMAyklnY5JJv+gehlmuyxziZbMI9m+UqO+L0/rOXUyB+trFFcvtHpKCAdAjM7on0w8wlxxmAYpkfb368fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAlS0DrCFzk7gfiQ1hWrD7yFKZhAJOM7sv8lP2IxrM8=;
 b=gs6jq1lg/Ds4nx/pUUiumWuNuh/EQzGKbMoPfYdjKgfocK2a4K9JpeKIiBgblpOj5m7AAI3lxe42P9Sm4XC7wbya/VtIBrMnUQvQwmhX+OV0UYxaXe2+Oqu99h75oLCLRYHBJuoamDpRqGSKj4ckcjpOtuxfsrqhTogDn/8l2bu2puTVpB1/W/eB9MR8sa6Z7tqf/pQoLay28crA2n2ZHv7HIqMJlZPFLB/iNA4TaxLwA2dgGSa3x0TcVAKpXPLg0o28kiUUpUSqB5zxbcUNAEAIWeZ99fSFA9NprccB/ubvUpAcTSbAbrI5VAmz/hoEWU8uaU0EndnHs45WhOsn7Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4091.namprd12.prod.outlook.com (2603:10b6:5:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:14:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:14:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:14:23 -0500
Message-Id: <DML8YG815Y5N.3B989H9E5UEX0@nvidia.com>
Subject: Re: [PATCH v5 11/12] mm/mempolicy: read the zoneref slot once in
 mempolicy_slab_node()
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
 <mgorman@techsingularity.net>, <anshuman.khandual@arm.com>,
 <stable@vger.kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-12-gourry@gourry.net>
In-Reply-To: <20261101021340.2251928-12-gourry@gourry.net>
X-ClientProxiedBy: CH2PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:610:52::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4091:EE_
X-MS-Office365-Filtering-Correlation-Id: e568e0f8-e1d7-48a5-671b-08df39589137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|22082099003|261102123227099003|18002099003|56012099006|261021121427099003|11063799006|5023799004|4143699003|261028144727099003|261026140227099003|261009223027099003|261026121527099003|261021123027099003|10067099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	7+QStXOSZq9oJ3DE4tIUgX5efQKBxUggumKEl2DrNmxLYyrFsXoqEbkLxBGcP+DvyLS1wbfsotpWTqskGnlH47AKOHJlW0n5fPZLYwFTJ3AFoX7qtXb7HASktNBDGh1pilwl/BMkIDvkWWcaA+s/IdlZ8IorDPtAip/+Fssc12wfn+VFHjxQQ2pRXk4rvfFI6HrAtGeLCNBBduljZeQpgy07jZpT5jWOXTKXgwxS5IGC4n6+UmwukQpfMu0933xfaZ9lssELRVCP0z+x/VwJU/X099ERv7pJXFbInmoHWuEnhKgHTK1Ovm/+2jz9YWELksbCQEDm7Yhe3MN7SeM8GRcP7GPT/KjI8UMbTEim7js9Wbc7GbAhwBYgwho7SPn/3o3C+AtoN1ldNXyLPxSY1iW7m9hQ3OUF4bSzBxPYO+G7xUjFUyWaZO+opPCBF1/YNo2O71aruMjO/BpXf46Z51GOMU1yN9zdotD31ScItjdTbOeQRJzJecgQ+JonNbYq06f2WVWAO9Hk67z5DbsKPaRCBKN8PUivhIS8X2n/H8bRAfJdaxiwUHS7xOLKIDQlt+Gej/6KaRgvUP3Fec2zta3h+mIHoLWLFDOAp39WBLT+ZRDLJ5SPLIH9SY+J7sVnCLpKafu14+0MLsDThetSIkCeEonL9Paw9D79xeFFb4c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(22082099003)(261102123227099003)(18002099003)(56012099006)(261021121427099003)(11063799006)(5023799004)(4143699003)(261028144727099003)(261026140227099003)(261009223027099003)(261026121527099003)(261021123027099003)(10067099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1NzM0dQZnd5aDRBS2IweGNsSHB2OExNQVUzb0dtSFZvYmNQNGQxN0VXYTBp?=
 =?utf-8?B?R21QR2twZkJjdWJMQlhLMC9vNnErVzdWUjhjQnoxRmZaTHVacUdPTGE0VFIr?=
 =?utf-8?B?c0ovZVpISWlOWUpSSFhwWWxockE4VXBJV2Z6T2dVMGNCc2VaUW4wVVJvL0JO?=
 =?utf-8?B?VmNWZDRwYWZZQk1VZVVXVUl0S1pKcHc3QWFmVnVVNXAvemxUTlJxTVU2NVNy?=
 =?utf-8?B?STRFdWhnUnNXdmtXNnJkK2liVHhPd3JFdngrQXh5RHFwNSs0ZEZnUTVUTVpB?=
 =?utf-8?B?TE1kcGxucHhDbnRERTZPb1dqZmZ1MHlMc2sxQlp5YkZycGc0bmRmR2t0L3Nk?=
 =?utf-8?B?K0ZqbEpXZk9VQTVvVTY0VWk2cnNHRWdFTDZRNHhMOTE3eE5qeS9xUVNtbnBT?=
 =?utf-8?B?bFpWQVJxUndHVUljK3AvbjFFbWp6M241UjVkR3dpRHV0V1NZTW1Vakxib2xU?=
 =?utf-8?B?ZHVYOU1xSDZoM0tXZWpxWllDNWhKeHFERWh5dFN0Q0xXZlJMcExDcVBZcWNX?=
 =?utf-8?B?UXZrWElob2FhcUR4ZGRMQ0lLM01FV21rbXAzTHVEV1YwNFU2cTU0TnI5Nmda?=
 =?utf-8?B?QzR1Q1Z3S2JNMVg0L2ZtRlVIZ0hibmFKeUpqV1ZNT3NCWFFBYWFuMGUySW1j?=
 =?utf-8?B?NGYyK09QWWZWc2dsNnhEczJXaWQ2eHRURUpYU1RsRlFVU2JiNk1LSWc0NmRo?=
 =?utf-8?B?QW02REs1MldWWVhsbTlSWGR6T0tXV05nYzhXRlZXb2Z1cGl1K2R4V2dZUG5Y?=
 =?utf-8?B?a1hITklIZ0hGMElRUUNaZURWWUtDODBSVStCYytSUm9Yc0lCTWVBTjYxY1R4?=
 =?utf-8?B?KzYycjJqUnBoRlRWdmRCYi9KNEVHbzFQTndPcis1TVFOeGZ0ZTdzWnlzMWdG?=
 =?utf-8?B?STJsQnJGMWEwZUxTUVpxZU1TTDZJWTdFZHBWUlEzU1JXcjllS2pndE1vVW44?=
 =?utf-8?B?K0F1b2pzL1F3ZVFTOVBrS1BGMEU1YXVXSURjeFdyNEJOQnpZL3ZjMnlJN2Nt?=
 =?utf-8?B?MUw4VjI4b0VVeHF1NFpGdUxjcEZNUkRkU3FyZDBYN1NKS2hFTnFUb0JrZGpv?=
 =?utf-8?B?QXpoUVlBc2h0TEVuTjJ6T0lKSFpGZTgrNGRzT05kQjdCK3JqYzl0a2FkZlo2?=
 =?utf-8?B?Rjk0L0hBOTExTWoyV1hjdUFBbE41OXRiYlY5bm1YV2daQy9BMTMxeTVDL0c4?=
 =?utf-8?B?SVFVUGdXRFN1TlYycHFSclAyQ3l0K09GWk9TdGp5N0xMV3ZrcDFzUFJNTHBV?=
 =?utf-8?B?cWhpNFliVHlqK1hHM2k3SEhQbEJvUW1yelNCa0JGSDVjaEJFY1R1dUVTdE1M?=
 =?utf-8?B?S29ncmt1RjdnUGE3d1hyMGF6RkRJdDBEWEl1NDJNS1BsTEtYSGRDM3pRTUFq?=
 =?utf-8?B?WE1ER2FBbmd3TDc5aVE5NmpDcGZxVUI3ZE15MmUxSmVCZ3ZqNjFzYVYwVjdm?=
 =?utf-8?B?N0Y2NXB1WnFUUlUzR1M3QWsra0FocGxIOUQ2R2JhSDZqajNMQVVUeTFJT3hz?=
 =?utf-8?B?MjJvcFVhTDRVVUF4V2RSR29BNW03RGxaU0ZTd2FyYkRZZ2hwaDR0M2podHZS?=
 =?utf-8?B?aERJbXIxMVRYRWFHR2JHbG5meCtJRTRuODV0UnhhbmFhekRyL05xOXlPWUVT?=
 =?utf-8?B?N3BWUFBWWHVNbnVCeVFxNFlwRUF0RXJNbzMxN2dvSFdNOGRKR3ZGT01zUDhy?=
 =?utf-8?B?VVEyNmVIL0xoT0NPYmFHMUp4K2psVXB3MktrK1dqRUVtUVBEUVRkUGJVekFp?=
 =?utf-8?B?dENkUGQ1a0JtbDRSblUrdFJqTzNiN1REMG9XRXpYQ3FvQ1hXS1RXeHFSUG11?=
 =?utf-8?B?Q3FYU0lJNUNLek5jMGt0NHBPRGpBK2c0TE4xNGdsKzIzb2JLZXBsS3IvQ1hj?=
 =?utf-8?B?VDhnN08vZDJQd2dYYk5pOXBORG42VEpldU5yVm9ackZuOXBUWTNxeVNIY0cr?=
 =?utf-8?B?dUl3UTlkVVQ5b3dqMDlyY2RpQnJKZW1iQ3FwU2NQMkVWaTYrR1pRRUoyWGp3?=
 =?utf-8?B?NDJxZ2ZLeThzY3FOY2lpT3FwZG5IU1E3Q25YQTZZV1Q3eWk5ZWxaUVhSSGN3?=
 =?utf-8?B?SkNidjl1NWVqcEFNVGd5UnIxZ0l2YUhja0NuZmF0U0xtSUtpSk9sZnpTOGdS?=
 =?utf-8?B?SXFqT2w4WGZoVncrOUdxVSt1L2Y2dlRORzBBR01URXIzeWZsc2dPcnpta05J?=
 =?utf-8?B?YW5zQnpFcm1PRmFmSmV3T3doVTlGendKWDFzTUw3OGRrUjFlQ3FKeEVsUVRN?=
 =?utf-8?B?eDZNK0hrVVRjZlV0cEVCdlJGZGV3enFQa1VuMkpFQ1ZiNlJjeVlDQ0RUdVlk?=
 =?utf-8?Q?Jjz2mdx2Q60Yi9NarM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e568e0f8-e1d7-48a5-671b-08df39589137
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:14:26.7162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdPZzeqCHqQJwiJwdsiKY/KAY54G24o52NLOEN6gWskRw147pp+WF5Z9OgYRDiYU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4091
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9EE420002
X-Stat-Signature: o1kisreatwjwydmsk95ps6ow338brrwf
X-Rspam-User: 
X-HE-Tag: 1793675675-986789
X-HE-Meta: U2FsdGVkX1//bjWkpDg47QTP6h9D1hku+65/sE6dNrnuYfOW+sOPsYX3Ksoo9S/w7XMiGHYzrwpRc2c3jIVFiihOno+ezbNKB+mYNzkOrrvxdK640GIt3j+5LfufI6EmXmgfyBRNNMPT4te2nfrJlk+RQmKOFdLZ3cZgIqop0VZk8eWJjmTC1D/SQvFloD3ySw+uvubjwjVl586fnbBpWIVnEgaa1fkgc1VxNURCTD2tv6D6UrSoxK9pGzTjKgxdHwOfmmJAc6GRPteQEk2ygZ/fSU69DBGOXRcO48iyShJXaZ3aUuOhS9s4C7jbGRxPjKv8GM3yOYhmc9JRTI9APAsXH8gp3d6eHfKc08qdKrEslCfJldYNwjmk4YkcnQTyk7KCRh5IHAd/bpbDUtf/xw67PDlGlDuK+uKFda113oWrFNgEiDXCN43g8xHWPL/O0qG7JxKGh42g9Tjbkjg/UUTm+d1mFQoQPnG356dK9bkHUaL2OoFirVo+bpT/zSGZzvvDqbsmD6lTzRNL1TpJLji2TpKQO+h+/zTb9F8OvIHFa2OSmvQ2L6lf4zSw4sjh749ffnBCdmWZmIdhuoo6lrr+PBgWWrqigCm4NQchVUygee7zjZGacXTdlcatSPCNb4SRyzmSqBvwy5WiYDs6akeIMZx6EBna8BIImiE/bVTYI8GoLdTlkKKmp4HJEfplx0r7EWilkK/TfEuz/h58p+IZ7gjM0Jk9pO1c2BOCSx+I2dEeunH6zcedcdS19tX4BwnNHoZ6nUbZ0XsKvy2XR67yXpRfBEJPCZkzr+cs6QKqbnZYHUb/lEfVx0IDHEzQhqktskh3ckz3/Jy8EBUaEclySxd2UsGupBqN8Qs4O/aCP4JYO4n5MUYYYnWy/bWf9AeP744Dd+5LWbLMEZUR8K597Ac5hsS5fS/1gRRbPw4EoMHA47h07QhXQLG3aXDbLYHJLyhP1EFSYWmG9vW
 pObMw0hr
 FLgim63FXJQ51zDxgK5Ppk1mWKxartcqaYUUBdUpgbKhkVEnibYkjEmPF416XYU2fSmFSoAkKQ+xv+p+GAfy2QzA83b0gTGcYz96XkWJXIQhr+ryJorjdkPwha1/CKtvdTy81PaIrnDX4Iv68cwWrA0ulmIcRfAs8dwrQeB6XOE68WP5roVYV1Zkbp4seF9koMKcdLgwE+VuJZrP1+IYyj7s/0o14hVWLSWyRePwIDICU3iLjxH1tpcEGnCRfyKgsNGPN7cWFLaFQ+DbP2vZXAK9CoLY6PCV/suy5Q9Pd5ta1WLHdqprss+92RUn4Bipc+1ukTe34+LTT1L7HIkmxWSGqciA/9FWjbylHuu7hfibGBd/mg3DSdMnooVA6d3q6+GxZM6BjWim7wue4HDlHo6sGxQOf9uHx2zFKq9wwMmlMV4wsDCstN8BdnfQdhvNU2hCy/lMuompoaabiuzpKU3JmcRbg9nRG8pc3QNXnuWe6SrKHnwwIooT/hA/fJNnTT4t5Dsdxg3pPMMBnhDlQP4Ga1kAWEdR1CqUASFEVkXSJwLf6ZM63flS5ARDejrlbZHZsk0oPtvyMR89I7jmuEwGglRD5aov9fJPt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 10:13 PM EDT, Gregory Price (Meta) wrote:
> For a bind or preferred-many policy, mempolicy_slab_node() tests the
> first matching slot's zone for NULL, then reads the slot again to look
> up the zone's node. Offlining a zone's last block rebuilds the
> zonelists in place, so the second read can return the terminator:
>
>   CPU 0                             CPU 1
>   mempolicy_slab_node()
>     zonelist_zone(slot 4)
>       =3D node 2 NORMAL
>                                     offline_pages()
>                                       build_all_zonelists()
>                                         slot 4 =3D NULL
>     zonelist_node_idx(slot 4)
>       zone_to_nid(NULL)
>
> Current GCC merges the two reads, but nothing requires it. With
> mm/mempolicy.o built with -fno-inline -fno-ipa-sra, holding a bound
> task's slab_strict_numa allocation between the reads while a movable
> block earlier in the zonelist goes offline oopses every time:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000060
>   RIP: 0010:zone_to_nid+0x0/0x10
>   Call Trace:
>    kmem_cache_alloc_noprof+0x294/0x610
>    do_getname+0x34/0x230
>
> mempolicy_slab_node() and zonelist_node_idx() are tail calls here, so
> neither appears in the trace.
>
> Read the slot once and use that zone.
>
> Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_=
zonelists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/mempolicy.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


