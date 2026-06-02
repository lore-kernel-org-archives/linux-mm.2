Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF3BCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 14:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043506B0005; Tue,  2 Jun 2026 10:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01AC16B0088; Tue,  2 Jun 2026 10:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B8B6B008C; Tue,  2 Jun 2026 10:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4FA46B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:40:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86A401A08AB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:40:33 +0000 (UTC)
X-FDA: 84835233546.08.3E79E87
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id A68611C0018
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:40:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MPPVYuiS;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780411230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ngsXpA9FuIr24rYVE+VwuWVf/2qnrgpZQFTbi4iEOY=;
	b=gQNxbNniLwRb7Ixz+NL7aX8zs2Xj/72oImWXn+MJ8QpAvpXCm+g7V4Dgs4vojmInsDk9Eg
	ADlck/9YXRsJFxQesmif6M5j61FBoiRWSqdMUwOw8i4LL2cdg8sAl0Q6TOetOxXcmgoQfi
	zjNpZeDRuphR3miIq1skkMOibjeL1R0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MPPVYuiS;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780411230;
	b=XuOs7J40aHU5WAiLFZB6cYM/AfZ1p+ppEGxY3F4t9jH2yyDP3m915zf9oh/rh13Bf/NgD9
	srwcyftlwe8/9GRjI9/CmBEIJSB2Q8VqWiRnCIrxzEZ0yEl3HB8ojP8CF8dtqhs2kPGq9U
	OSloKXRYrAc+D/AjsHRo8E3f44Ocz4k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkEe/YbAANfEmIkhWRFXQP8LRO+Lobznx3FZgy0xO/InLd0lM3UoSlTWs62F9KA/T+bwDYzjv5g6G459HdHlkb+Ccj7HjwNFqkIXoXy4KuFYUjEVLMH/v0fiLRMf1EFT0QWSvR3hkZtfj6Fe28Vp6I6b1IRoY1pQZr4Cq9Qo6ydhjgp408CBevH+tZ0pmfKdIE6IMlAD2OwYkaxhPUKz9aqHvEuCrf8Db4Fr3+c5UfaLvBgodgqaEcgBcX/Sl/oONq3YU/bWv9ML5H1FQUvPU27+2oYZq2zrpiqLZTJl1lxiuK7UQt1PW5b09rH4QOW6GniolJ//CYuMuC94VGu9vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ngsXpA9FuIr24rYVE+VwuWVf/2qnrgpZQFTbi4iEOY=;
 b=qdSk7PhRSx7u8EW3M8gzdwUiUhv2IOMxLmWRizpmlb7Czi1f6wyGibZixgsUAkD0x8skHAuFk7y5R7WPwO3KURwXgf2B/w3DQtxvwz4wZL/d9Q3PVRXpN+RAdWl1PSKbUzqjRn1aDvnmusq668k1NGBPYw0UUKGdjF3+3jFm9/KIkJbOhqTMvtsOjaG4V2n/Qm1zQGcVieyYfV7LGuXP6oBckHDu1sZGDqbR0T6pv8k+LemXkAvQ05rl7cKPvih6yT6oNxXiLEzy4rdyTYnuBzhCTcpfVfDY1DkkZV2NzYt5hmaC1B/T9BSSo60himxFyFhcV98WrVd1dBevD1SQHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ngsXpA9FuIr24rYVE+VwuWVf/2qnrgpZQFTbi4iEOY=;
 b=MPPVYuiS+3pXQktlqR5eSSn9vlFTtrHhfGL4NCWpNj6FYjtd/UF7EXTkDSavHmy1f/sK2vc4do+JV6JxBl/y4cj+dn1t3PWLPAY3CmQfmk36aFgkapoVLDQbq4ofKVILN7f/DM0voFcQ3VnFJFEgHz4XXm8pq82OHYyxLMN0lyv/bNo9wfK/EDOYh6EMvRnxWp/Pee6lWUrkYXWn0/jFnMUAYX9vAF0RgAwQHRHpdiUSdj9HZW8Xef1vruHesUZtvWBa0LC/XjHn3wbewM7fbN6kS6J0AGyXx2LVjEa5CNu+CwOmb3Vjn20P7DAQy6N/O3bgzMeL1dcxBH9ciXeEwg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8850.namprd12.prod.outlook.com (2603:10b6:610:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Tue, 2 Jun 2026
 14:40:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0071.014; Tue, 2 Jun 2026
 14:40:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 SeongJae Park <sj@kernel.org>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Date: Tue, 02 Jun 2026 10:40:16 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <263FB5F0-AA3C-4885-86E2-9EDB030A0CDF@nvidia.com>
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
References: <20260601083044.57132-1-ljs@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:23a::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: 1443bbd2-c863-424f-2d54-08dec0b4de89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|6133799003|56012099006|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	ySm2+p6wLwdA3Ayp29L/fbedKfwiK3clD5MsbkOM4AvPKUbb0S+ZJjNetH5v2HGQhv37DY8XnO2TuE24v+dbhb20TKE6ucLLuKLfsi3Wty17qM00uYetUV1gtQsPogodMJncUcdpo+LXoPb8t8aF6QGMP9MkyPMViJv71oc5CV8Oj/CCQO8EbGBCrkg31fA+Q7MNVaGgnTePXJ1EVhuG736nDN0LrGCnYhHWt1542Z+NaeN3wMn30YnAeGDPpFnM8bGQhDFHh72sEkUMjHFbuQO5HcDmfs2mDWUJaL1TBRRR4RITyUiA7L/B/P0itNJS554p8o7zogH9aqM7pwfZIPHxCJOaoVFmI9lou7G/2tjhPXsbX8xxPNMeeaobWgq6/8S1Xl87GFn3p2KVXLza0CNSLPCDKTF0EhaCMXVzUgj/36xrKSa7+bNZkU3DWGwfRC0aOvS0zdAUX53dYAgP9XUvq3MkJgXJFhsptyh59Mo9FIRGD+/41XHlh2ZCTR1s0V5CgYFtih5Rfr7zWTG7KbyHoXXQ9VEzeotJX6vPW2pJVNJu7kUbv9bfwQAaBLBMEfgw/e87vwrjsx0ZVhWeTJAXyrC/Jat/Wokago0YNNUwGm/DYJikUfUZKOm1YSLs/VyRL4LCTadJJEd5u91H51bH+Hsnm3i6fUuiZFo/2BwbKnDcthPK0XzkZTtk59O8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(56012099006)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xn1aixkG5ZCBxkvJRBWzfsQ7u9njOpuYNO5bjQB4ORnqDVYiVSdwmKDsqxcF?=
 =?us-ascii?Q?fpn2FodR5zboZ0Sed0MZ9JHxnECpKQAju+tvVwRcyWhXB4+EPHzU8LGDzNXA?=
 =?us-ascii?Q?1TxelIYWhYVoq93Xc4goKXNmpp0g3eHrjaOuijrppegWQ0l0makiIpNW0lgR?=
 =?us-ascii?Q?XcnZcr1+8foybnhoNYsFCoMKwxMt1NlFCmA4tAdYK9WpbBEMUs5a1QwXpnFk?=
 =?us-ascii?Q?4ar32AkMWKVsNAk9H7wUHISLGaVJY4a2+jmgKg8ZrHbdQWl0aI6+HAJfivGG?=
 =?us-ascii?Q?imAtWvRvgXFzDUAkpmPKRTUmk3GFTHHGcxRRG7tWufRiCb/9Y/RGOxw314xa?=
 =?us-ascii?Q?8cj2U0xHcU6ATxDhWf5gxqmM4+Ae68Dc97XojgxBQPJegbw1k7zKBRJAkkO1?=
 =?us-ascii?Q?1o7mGLA3czSCOhqXuIsnJM7wrigBRgcP/Xx8FgrGDDdH1xxdcayUvASZsuPu?=
 =?us-ascii?Q?kclR3lYx+bDDuSKKJHng9WhQTdNMtgrZ96gZoSipsERgz25nk2zxFbuF6yHN?=
 =?us-ascii?Q?cud2WCKLrb/i327XwbTg1GeEDoXKzRKTGJkbWeynbB2Q+Fgd6mLa81AHbVBb?=
 =?us-ascii?Q?vO3i0GpUCQbTdHThAc2aQBxBs4hl5cE6XsBYnXvs+zpCyHw3DBb3Sn5kB8U/?=
 =?us-ascii?Q?AuLaXeZpJfzyMo9yGWFBjxzD3ytgwKqRMoV7RqORjvTDfh0YM9CeQDGpUOBA?=
 =?us-ascii?Q?5ikrv0+4fkgFBUmNdiqBtVeD96PGyAoS8x2WJOkyRpdscS5EM3sype1B4bXU?=
 =?us-ascii?Q?Tmg5nk3GCCipr43Po5TpipB0jCiFQRxNQ3y0BLmGRE40Yg2Olt6+CcMgBZSK?=
 =?us-ascii?Q?KR8cCcQR8/SnBC5eq/m12+Gk21bI0wpPju8oix7p+mVrJ420X+KXdGsxIpGz?=
 =?us-ascii?Q?68Hc05PrT3dU1LmvwUJnRAWWbFPSia44LBnaGsXTSk8dVHZbqXmOZUUWkj3i?=
 =?us-ascii?Q?lodQxiUlgRAC+Phio+K/aD7VzSgRbAMyZwYBJWQWsZqgBkeilqyoT4ijxZwZ?=
 =?us-ascii?Q?QbHSDG7k3IYY0Lh0VhCDXYLAbWsK599oUyr3l1bT37lgvPYECwYujUtoylEG?=
 =?us-ascii?Q?8wGcC29Ql0aI0S/n9Wr3MNERBCwHtErFlTZ77V8OEaauxogfaSySE9GeN+NX?=
 =?us-ascii?Q?PLZqG+GIk2ujmalHOgmk6Mx6JyI6pYIzJW6nrK7MDnzQAxuC3x7X+dUK0B1e?=
 =?us-ascii?Q?5pzBbtipHnYmJ3fOiOj2XJD3fcAr2NxcoUSazUJNJcYqHfZ+/CnO/2LDW39v?=
 =?us-ascii?Q?tMMrXNJhlC25TdHTPduPESRT6jljwCRKJusqEiFBJShniN60YX/u8kIye9if?=
 =?us-ascii?Q?OwjzKNnY2KdVl2g2Q23JqZx+c/a0C9Hn1uS7ETdb5nZhBC4GRrbotrOXcq1s?=
 =?us-ascii?Q?lH4rh7H9Gv5yLujdhmZuHj2MR82MhEH/A3UGyUBW3iCih2g+JPVDNA1RzfEp?=
 =?us-ascii?Q?BcAK69A5eXWR8fmq/9XmE+Syif95yYMvROAsnR9AsPPlv4nyEEgi07/bv8n2?=
 =?us-ascii?Q?Trzsh4iDQZhXkX1i5dsASFWKvlK49TnO3Nm0qnT0XKKoDn6bRoLLrn4OH2vU?=
 =?us-ascii?Q?IQvDwdQJ5mAu1SgsufuK2AtrBYrfrn0ERvjG7FEpu8fnqlAPbkCQWzUHH+4i?=
 =?us-ascii?Q?5ydhguKVjFdmirYqzRxNr3QO9cxaS0h18xF7WOcUH+eCGo9V3EhKW9/leoFC?=
 =?us-ascii?Q?c7kcqOMyCTRUvbgSOGA4C6gRtfdIcpTdYZZwsPzy3yKQHO33?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1443bbd2-c863-424f-2d54-08dec0b4de89
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 14:40:19.5014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrRtVmyRRcmRohJAxxKs1dlVKVgnq73rGTAru45yc7AFltaZOGJlO8DK/hbZ+x82
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8850
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A68611C0018
X-Stat-Signature: 53uih78yejjkx6xiukzf4onck5111p3t
X-Rspam-User: 
X-HE-Tag: 1780411230-992070
X-HE-Meta: U2FsdGVkX1/J3SpedPhatxrVLl52pd8ddqIQa6dzMCFV6PpKpXT1SODiFL9gyhgWlHn8ZvqTV1o7d9hNOo+dUkXf3pLbFEucnJ8rVwoVABahC/2OkuDBGDZ6RuYqRCMWc9lz6QLYo2ou/25w7uCJtrxfJ8Rsxv6UyvZytEk2COlDoyice36A4GuBDCLO5Yr6GgSKwxnyY3lJkg8vnxqxP6k6IMzXeoljG8rtBj3l0Tizu1VjypsaDWc3y4cEL1w7W/Rjg/v9kdvmgvyQ7p2dDB+TL6KFM1Ir38b6ZvkE7TELtUGT8vuuS79Tf9N2aztSweJsp6GKuELfe/qQg8UQL318kxAaikhxWDn+Rm9L025dRTafKhdTjomh56YeX5juiJLJ5lksEp9M0Ukwy1awkUQFXs06rfjnDRW72H7xk+OKjcPytMVs4ZxPV0dUXfTPMBQv5OHx9oFysEdOEmIfoGErSfOjOgDmXZ1CfY98IXhnQBPaRF/asFiO3TXBei+0Ryc7U/lYoBX72fjsqvV2YuLRhNTPXo0Z4lXdSugtCUUMcQ33Dz1VE0h4NFQPCfzH7Jiauk756hU9fUNUUsNq/9SlUoRHXGpVyEU2jJf7S9YsqSmeY54u3DpBarWP8xcupoSnMQngnm8+qL/9+i2sGluDchaRlB4PMssv0JFByN5KyyvAa8LvLnNlYpESMkUh9riMKuN1JmenYhT10WyUW4IxdEGpuUShH3AMy5lm1mLczUbcSeyV9+/xat9ZA0j3BXQBRP8wm9r0RSq7/fqaqMDFJGc4/5Esc1FNuDASHNV3Txix1uOC93cjQMxVNt5vmPqZ6Gg1XqlsbqxdHD0msaD0FUS4b9H7HK90BkPweHSojTHSRJ7N8YIOGJvGvNGXFazQ1lkEulc4e4P17s9M5YdT31Hq/28o8BPrk1b7PPXIvZ8eut9No7P2yNmZRM27zhxdNfOp/QbSIwbKBqK
 372irzrT
 7SKVzYISWY2vduNtn3rBCY3apP8dZisAOcwDt2gWQSVJeNOf39x+fHUfFN9NgaW+w6r4M4Nb1Wb0BHWZZD9Myi11ZGDskn1dTi63Wkt3mvM+sn1znUqTyIR+f0Cxo5S8bYbP1mi9mZ4m229oUVJ578QawmxAAD2uzRuDsqHLrEM4AL4nKZsI+46HL/oA7EVyuEEXOwSAHKfXcpM56uMmVbnFFH2SH6UWUbCrwjP14cBVMjah7TY9u92/Lv1df0RHNQSkPq91Cu9h2cbuWn0cq1h3daES+NrD9gDL2eXhnsUNp2WGxr7soVgmd/LjFnuGQrEbyM8YW+bf415Ms8lnsuCMUjI41toidJhPobiH2J9WohGncywjEuom88caxsfR4x2cE8WXPULuhG4nDbIwGh7XJ+aCXq6l6mCQ+8cHFYxxzvdmvEXdMVYzT4TEU0TDIhZILDqEXnvS1bIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Jun 2026, at 4:30, Lorenzo Stoakes wrote:

> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") updated set_pmd_migration_entry() to use
> pmdp_huge_get_and_clear() in the softleaf case, but made no further
> adjustments to the function itself.
>
> Therefore this function continues to incorrectly use pmd_write(),
> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> migration entry should be marked writable, softdirty or uffd-wp
> respectively.
>
> Whilst all are incorrect, the most problematic of these is pmd_write(),=
 as
> this can lead to corrupted rmap state.
>
> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> pmd_write() on a softleaf will return the softdirty state encoded in th=
e
> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
>
> This was observed when running the hmm.hmm_device_private.anon_write_ch=
ild
> selftest:
>
> 1. The test faults in a range then migrates it such that a device-priva=
te
>    THP range is established.
>
> 2. The parent then migrates it to a device-private writable PMD entry w=
hose
>    folio is entirely AnonExclusive with entire_mapcount=3D1, softdirty =
set
>    (accidentally correct write state).
>
> 3. The parent forks and the PMD entries are set to device-private read =
only
>    entries, entire_mapcount=3D2, softdirty still set.
>
> 4. [BUG] The child writes to the range then migrates to RAM - intending=
 to
>    install non-writable migration entries - but replacing parent and ch=
ild
>    PMD mappings with WRITABLE entries due to misinterpreting the softdi=
rty
>    bit.
>
> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>    set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() f=
or
>    both parent and child, which are therefore AnonExclusive.
>
> 6. [SPLAT] Child sets migrated folio entire_mapcount=3D1, parent sets
>    entire_mapcount=3D2 and we end up with an AnonExclusive folio with
>    entire_mapcount=3D2! Assert fires in __folio_add_anon_rmap():
>
> 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
> 				 folio_entire_mapcount(folio) > 1 &&
> 				 PageAnonExclusive(cur_page), folio)
>
> This patch fixes the issue by correctly referencing the softleaf entry
> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry()=
=2E
>
> It also only updates A/D flags if the entry is present as these are
> otherwise not meaningful for a softleaf entry.
>
> This patch also flips the if (!present) { ... } else { ... } logic in
> set_pmd_migration_entry() so it is easier to understand, and adds some
> comments to make things clearer.
>
> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zo=
ne
> device private THP test infrastructure") which first exposes this bug a=
s it
> was the commit that permitted test_hmm to generate the test.
>
> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration suppor=
t
> device-private entries") is the commit that actually enabled this
> behaviour.

Thanks for the detailed explanation.
>
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device=
-private entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 12 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bf9b480bb3b0..79463c709c98 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4982,7 +4982,7 @@ int set_pmd_migration_entry(struct page_vma_mappe=
d_walk *pvmw,
>  	struct vm_area_struct *vma =3D pvmw->vma;
>  	struct mm_struct *mm =3D vma->vm_mm;
>  	unsigned long address =3D pvmw->address;
> -	bool anon_exclusive;
> +	bool anon_exclusive, present, writable, softdirty, uffd_wp;
>  	pmd_t pmdval;
>  	swp_entry_t entry;
>  	pmd_t pmdswp;
> @@ -4990,12 +4990,26 @@ int set_pmd_migration_entry(struct page_vma_map=
ped_walk *pvmw,
>  	if (!(pvmw->pmd && !pvmw->pte))
>  		return 0;
>
> -	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> -	if (unlikely(!pmd_present(*pvmw->pmd)))
> -		pmdval =3D pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> -	else
> +	present =3D pmd_present(*pvmw->pmd);
> +	if (likely(present)) {
> +		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> +
>  		pmdval =3D pmdp_invalidate(vma, address, pvmw->pmd);
>
> +		writable =3D pmd_write(pmdval);
> +		softdirty =3D pmd_soft_dirty(pmdval);
> +		uffd_wp =3D pmd_uffd_wp(pmdval);
> +	} else {
> +		softleaf_t old_entry;
> +
> +		pmdval =3D pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> +		old_entry =3D softleaf_from_pmd(pmdval);
> +
> +		writable =3D softleaf_is_device_private_write(old_entry);

Just to make sure I get it. This means the only possible writable
non present/softleaf entry is device private writable. There is
writable migration entry, but since we are setting a migration entry
here, that should not be possible.

The patch LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

