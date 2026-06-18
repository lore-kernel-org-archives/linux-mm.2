Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00AF0CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 19:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9174B6B0088; Thu, 18 Jun 2026 15:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0196B008A; Thu, 18 Jun 2026 15:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791B76B008C; Thu, 18 Jun 2026 15:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 499096B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:08:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C37841C15E5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 19:08:34 +0000 (UTC)
X-FDA: 84893969748.02.815D48C
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC3BE1C0010
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 19:08:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hoX5kAiT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781809712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Naq+rnMyF9C8xmgLJHp//VJ9JlPKaC4QfAzJScDZzCc=;
	b=YpiSS4dnjw7gXDBYhkCiSpgk04dGPT3aDvF3Xyjq7M/6sTc5mHhIQ9aMyuqxzXF63o4Kd3
	SAwgs99dnHUPWqeFK3O6WzRuPzQyPSmo3JqhJjttYNb9HrWTG0WpPo2pfYRVvK4tJgvtju
	rUZIrx1zlUR37CcltPZLMZsxtDOcivc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hoX5kAiT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781809712;
	b=Opc6W93++gU/cMkMjSfns69EAAMZIlGBU4Hsx1uz5BdiWMEipTQZ/V3YMvusCLzdmPVWiX
	CyBdKG+H+XSRCbkjhLWfi66vN4TdMnOpXbhFc9GINjR98SNAHPnTHOTC7UetrYuX97plwc
	24nQcxthX4sy1Z4+FBU8GYtBMDntx5k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NhTXxzBid7hDDg2T7e2zwccqiRFdNCutJmXVFZLpgU2icGQ4VPeFlqCYSfixFMYD796vWSecZRsb02kcdg+7Ksudea/kyCjGYJPCjeeWUL/NsNheixwxyLIyIuc4ldY8bYFlXgbYrMhTHr33UxyKqe1KubWZmXiueFi9FgILbvDO+ygzvWu7lXT8811YyTYtVEa230KuqNrkzB9aBA2z+MxMMfBxFcSWkfQzRkFzF9g5mwCH9wDwQwO6mxSazI1ERNP6e3PwP44mll2ogJDSKa73vuej1iGbMwdNt5rJQbhDh143CGXgd5KHa62Ma9KQLY8rs1vpbhVR7VpQJmxOHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Naq+rnMyF9C8xmgLJHp//VJ9JlPKaC4QfAzJScDZzCc=;
 b=WRPaw7OnxkJWw9LBLInxc6viqALER5aq/KSEHufJfubkryENGvIr80zJtRBiGEZ2GBVLsRY/69jPzbqvgFS9a1Nldyv8tnNvA8d6VkoO0rlevdhnjR+X2FNbdta81GOQcJFSVVMj2uW67R1hbEiAdBTD4WZSc269bMvw/4to1/qQrhCxsG34C6JR8XiYexM3++MkvqYIiru7vo0D9d2LlrZ7vGuAzgUX1TQeX+AvuA42z/CDraS5XopLArAiJNlIRGKJQrsLKGi+MeL1j4I3ZY9n4T2Io4kS4GJG7KMwwgiJpU+hNo7xrCnxszVCQ3PZtn21ZVnuw/oTdDZzlZWI7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Naq+rnMyF9C8xmgLJHp//VJ9JlPKaC4QfAzJScDZzCc=;
 b=hoX5kAiTc6ttj6GNutMcLzADWiMgJEURXsjOHQa7TXwme4RQc0uJap/ZqwRb+TKqAIbG0t9kQTZ7+gNt5UpOtAZfK9j3zPS5pl/5oAhhagQgK5x+1a+9pW0Bi26looYGfHtZU+s5S1cta/xH+evEcs7EcJBbYB3N5tblOm47TWd+P+mniKczQ3ePyWXWopWYpvsXtnMxD839tgmQJcKTi0Y+m+mCuIIEuGzTA38VTWtFGVDJmXo1rrvL/rYaD1arDk99/rIckiD8LGJR+r2mCXlhjJT+dXWH9UGEn6VXXEFYd2BNCcN7X1TQwVY9KS/T8Pg+bZzhO4F8S145IxpfGQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 19:08:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Thu, 18 Jun 2026
 19:08:25 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 18 Jun 2026 15:08:24 -0400
Message-Id: <DJCETPZ3QL60.25Q56MHKLO0O0@nvidia.com>
Subject: Re: [PATCH] mm/page_alloc: don't build vm_numa_stat_key if
 CONFIG_NUMA=n
Cc: <srv_ts003@codethink.com>
To: "Ben Dooks" <ben.dooks@codethink.co.uk>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <jackmanb@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
In-Reply-To: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
X-ClientProxiedBy: BLAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:36e::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4192:EE_
X-MS-Office365-Filtering-Correlation-Id: 084a2423-aa8b-494b-b3e7-08decd6cf900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	dpk0tqVwcA3pdaF0foi99mFs1XXFBVMs4+cSxWDm2/JhIt8fxD0bqO+nsHIEkPVF9SaRK0CLT/FLUaLtdm8miUMr3bz6BN0mT4zf3/bfOtdcPBerHBdoU6ZCX24cB0oGz8fSY0ZHKJKBxC78yMs7ZGHjw9roC/KGUiVrG8f71zT775tX6bcl5Bb6K3V9h4oYxy28QUvfsm8YBKWORaT6Wmv9bZ+MmKx+54gjz2cwn9haN6pzd3ZZkys9/ongu8nZXHWtJ1CaOFX1UDMMB50iga+MwQ/J84o0YZX1tyCux6SitLAws8T5O1ub+QcRV63MTYkW7QgXFSz2sVDpTCTIQBmtF6CF/VhoLism6k8BWpW0W03gr5Vg9QHaT+aHSMB1bZK88riPj9moIl0z1mPR3dqJnHzb4NhXw1j3ezIJHG+n0K65lUHV2rrDdOkc0b18pF2RQNg2zY2/G/bLbcDnX6fY81FVFx58PshJ9V5E6bHLBF7Baxp2XglOS08SRJFvDDczuZaOoU6VA/f8V3G/mEBoRETz5SMwd2VYtp6szW4C4fgRzLcoYekRxU1j6oI3YZ9FFvFWhScMkdjz4JrOrsVUfMiOe5UnHtOWh0+sdFP6L17OvkNL4eW2XwApqzXraAVI+7tjgxXXbF18cy4rmisgsxoSMbrj/hdQzqsIPklMSCaLKAlZD6Horty3bhZgYjVUl9/PEyc/DTXeSZqvogt/7ccArccOUGxmLF2DBNA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWNGZ2FRN3lQL3I2ZHhiTXFFNVJVL0kxQW4xdWFoWDJYSFUzbXlXWUhJeWpl?=
 =?utf-8?B?aFNrR2cvejRDREZyam1PbHd5cC83L3lxczduK2VyUGZXUW9qbHhFY1lJRWtG?=
 =?utf-8?B?ZDE2Z2hmcUhMTEFXbzFhU3ByajhLRzdhSHNtRnhMWVV6RlVFaHJGTzhvVGU4?=
 =?utf-8?B?MmYySWhZY1JEZjVieXV5ZkdMVEx3ZDBPeG03UVlQWVl3OTN1OTYwVUlDMHhp?=
 =?utf-8?B?RDhLTHNraW13V2pEc1lmeU4zV2w1NlJ2S2oyVkdkaHcxTjlUemNFdnVJMGhY?=
 =?utf-8?B?bXVPcjBOMGwwbVc4YisxV3BEd1Z6d0xrM2QydWx6UUdqSDlFekxabXg0U1Bp?=
 =?utf-8?B?eGNRVmxQbUtqOVRMY01OdmFDZSs4K1VQeDZoZXJSbWltTXEydmhmakkxUmVl?=
 =?utf-8?B?eFo2NERaVThPYzJpOUJhTlFFRHJrb2lBalR1RWdGMTVBb3AwYlBldk5zSmF5?=
 =?utf-8?B?cEtORUlMSDFzS3EzbHZhMmtZdWRKUFVEV3h3OXRTVW5XOTFVWUZmb3psNjVy?=
 =?utf-8?B?VWxkYW9wOWtZWTVSSEdxK3Nzb0svblB5SEdsdXdlNUFhRU9JdHNQQkQrek9O?=
 =?utf-8?B?Wk43NTd4OWVESHZlU3duUkpXWC9FRzUwWlBwcjdXQUhJUDhBS0p0WlVFdnZW?=
 =?utf-8?B?T0UrN0FuRkFEa2JxQUJITzlOQkpTNklla2F4a2plVWhIUVlsRXYwOHVtS2Zo?=
 =?utf-8?B?ZGl1QzM3RVNoN1BlSXcwUHZUeXhMaWZoWHJuU2tLVVFpSzI2TzAwSm1FL09v?=
 =?utf-8?B?aEtrQU9RbTRudTZ2VzFSalUyS0E2OWhhS0lPOTJFSVdodlFaN0lyZTE0dm1r?=
 =?utf-8?B?OTlKMUZnR2tEdUhuRGU5RW1BdGlBd1dUeGFSU3NGYWpZTVovQ3FPdVJ6T1l3?=
 =?utf-8?B?dldXSnFycDhQSUtzbWpCQlJBNk1LWWZlR0JyRkVwaEhBaFpBWjhwajhWTU40?=
 =?utf-8?B?Ui81VzZwOEV0YWtWTFR4cXhXWDQ0cFBkeFJ3dk9ZTXJxdkVKcU1VcmxrTTJ3?=
 =?utf-8?B?d05xMkRsQ2xDTUlsWEc3M3hIdEtNK3AwaDhSMlBnK3UvWGVrVmJvblJpdFJK?=
 =?utf-8?B?VWhOMVA2NjhFUjl0dGhmUkdGZ281dW9DL1Z0bGFGY0g5TmRQK21qYVJScUdz?=
 =?utf-8?B?VHh0SmNWR2cvRUpFSTVoSUpTZ2ErS2EzQkpnMm80TDQ0aDRkWFJOa3FTdVNN?=
 =?utf-8?B?VkpSNVl6U2FzUUY2bmFkMXJZbUN6TVB2Y0hRRzB6QVBMY3FINDNNbVhVOXp0?=
 =?utf-8?B?clJtWnI0ZUpQRkc0MjNvWUhQRnB6b2ZXL3hFWmdMUTZwZll1VXNhQmJaU1pW?=
 =?utf-8?B?MW5MNUJ6Q1VWZWEzK2Yzd1RvU1BIb2Q2TThnNWxyV1FMNmFqYUllVzQwMk9p?=
 =?utf-8?B?YzZsVnVjUUd5UXAvbE94WTU0L3V6VTJzbTB4Tk9VTWtNL3ZCOUFmcmszNVdk?=
 =?utf-8?B?SDBQMEd6YWo3eUhDY04vOFZJNTBMdklkNVUyQ3Q3SENEMk9paUk0ODg2Z3R2?=
 =?utf-8?B?TmNRQXI4TnFzenFoTWx0SWlEN2pyNDdHUlloVk9PbTJyWmszRVo4M3cxNFFq?=
 =?utf-8?B?MENvbHBUTHBmK1VUSWVYZ3NvMmpMMlVtWWdwQTV6L0dSWVZadjRRMG5oUHVl?=
 =?utf-8?B?T29pbUUzZ0Y0c1YvK0V5UGJabWg2Mnc4ZjRoWTIwNTgrY2xYK3cxdnBCeExn?=
 =?utf-8?B?SU9JQUNZZzQ4WlVNanZJZHhGa3J4QjRVTXpTbS83MitEODNDU2tQSzMvazBT?=
 =?utf-8?B?U0QyNlQvZjBYeVVyNzczVy8ydFJVRm8vVTl2VDd1OEJqa2JiTGxOd1dhWUJj?=
 =?utf-8?B?djRtOVJWK0tEQmRUN3lwcHhJdndwQ1N5NTVSYityMGkrQ2J3cEh4YjNyRUli?=
 =?utf-8?B?dDhoU0pVNEw5ZVRSN3dvVUJWVVhrN3V4cUJZUFA2Tk1TWTlCOEFQcXBTbUps?=
 =?utf-8?B?bXN0TTlDQ094eVM4Yk5YRHlkNkZOWEJVb0pHSlYyTU9ValU3RnZVTVBQTjNY?=
 =?utf-8?B?M3ZuQk5OVktFVWxBbU81NXZhYVBSTzFleXAwcVNQYWlpdzVTdHhyOGo5ZWR0?=
 =?utf-8?B?V29kZ2wvMHc2T25SMlZBTUhrdC9nUUR4RU9uZ1p1c2tPVm03QlViMzl6VHZP?=
 =?utf-8?B?Rkl6YnIxMUhYUEtOcHRpS2pGbW11RmhUVFFTZ2tjeWlmTlVvMHlrOE05TUxx?=
 =?utf-8?B?Rm9MWjVOaVIwcVV3cnVFSjRRVm5oSEVqTm92RWNTL3RIY3RqQzRvZ0JHK0lI?=
 =?utf-8?B?S0VSbXNBT3JmVGQxZFBBZkpFVHlYT1E1OWdXV1BpVE5UOVJYQTg1S3FxZ291?=
 =?utf-8?Q?bTp9IDqxT/JuCw+wuH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 084a2423-aa8b-494b-b3e7-08decd6cf900
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 19:08:25.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ssp/o26SCpKrQ8wH248ss7zSkQ5QaeHdC/10JB6OLdlJiqSqTARbxPxbSCgM0tF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4192
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DC3BE1C0010
X-Stat-Signature: erzxbirf877md37k6e1kcrupofts48zu
X-Rspam-User: 
X-HE-Tag: 1781809711-856115
X-HE-Meta: U2FsdGVkX1/mJcn/VqEvQ+8kUqf028BpB+OFCqGV8F6D4Gmzlql45yUhEXiGsPILP60n1BM2IiXqqJxe5ZJ9QA84mWH4ENnPokXux5oMxM/ZT89Q/7V0FJETcbBoJg2WWZYUaANJKcV6sMj14B899+mSy6iV7fEVu+0CC0w+4a0cBKaRrWiMJLxg/+CvNXO/zYlOiVyOSmFjvrzYjyQjseVCo4UYnOp5P+XrDhwlPSldPIRwXYidpayHJdVpwWO3CDCBVbB/fYS8wzjbCpBGDCLmNuWvvUthyQ4LXchckq6bb4JzXYTWcDwO6igKZD5B3JnVK94A8d9FFQl7MVxVjCT3cq8Qzxo/ovuZPzM45JqWOjDCn7QrK/818yZAN/Cliof9PLtY49TeE14yI5BgXh7NBRmIGTr4uGvPqwvQu4BWjYKQb+foQ//VDI0UstlKmBeGJ6girdvj5jS7yZbjcYEW1z3HiCNtQ9mF1M6ULPzJyOSAC+xeXOlFu3Ignl972DV+4msyeb4s2rYOTgrPvmJeLj0//fBVCJ9FlsxkjI8wdbT60B1Uebl5SYb9bEZcopx0rMUHZOT+wvsIU891V8Vzp6ypjolTwKpcEBt4CECYuOxITEGF3vP9EBsU1WPWUkv57CIW4U1LxPckhuumQDd73STN4ttzsiPqtp8v18JESNvacFMhAFIr3DOmVKibp+qTWKKlbMgDCisjmXn0qqBP7mjo8fsSDxGtYwk+hGUlLolRrgNgAnjNZ6X4vwJ7YE/cTXsfR8he8zdRFm9RZjXh+LG3mobHCBwEySTjKQxuFvsZ1OwNaZl9idzCaHCbU6zc8LX9voyjOVAcWDhzrHISKcgjWlU8jv5qp65lagphIUkdWYpmSDB7E70hbKEpERsNl8h6eVwb+NBIovz6vIcC3oj21MIWzWBW0L4VsglUedf7IRJHxoyHmDZX8SN5wnqMtESRVtFHWN0p5Na
 wqkQfiRY
 lV/mtvuThjVmuaPjOY2BKQl6aU0D7MtrBnz6lAhlWnPZOSMTk9Fqdg4f203fsgv3J7YMzqDMLipdreSuXKn4LIXvFCMd8gtBTO2U/H60D2yeJUDP/tS8nZS7tkkmoA4mKbY1NTYVTOMuuJHjM3YJHDXERWOoALYiFCrLqCvnJW9HXBCae9WnvQHtBZZbIUxfsQ9J+d0XruHzPZwP4sLFlXtSfTWwCWowJmMYR8Kan1VDXttm1wdJ044nb0GWC7WPR5pSGROGPYPXhJRef3fpbTtL8GquclM2xNJvGdxJr+JncjNUvKbmGk75b42kKvYKYT+I9EAtkIvxgletXj8VbFHGk7nwRMdcTQzAwPDpcHthyp55Cioiqv+PtS4JJyg2nfrBTzkeOnl2HOxN00vQMgPdH2y4NVJbITrowVZH7JFcPE2VtNeNTEkKNm2TZC7SAEqVO54BXmsk3cbHdSCyemx0UvIZinwVNwCKADR+xgxPIb5OkgNcAfVqkZuEtsddZaNaYVzIv4sZ8kXe0hp1jQwdVZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 18, 2026 at 6:06 AM EDT, Ben Dooks wrote:
> The vm_numa_stat_key is only exported if CONFIG_NUMA is set,
> so avoid the following warning by guarding it in an #ifdef
> on CONFIG_NUMA:
>
> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declare=
d. Should it be static?
>
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>

LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


