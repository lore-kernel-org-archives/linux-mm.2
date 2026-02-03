Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B7CAE87823
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816BF6B00A9; Tue,  3 Feb 2026 08:08:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4006B00AA; Tue,  3 Feb 2026 08:08:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5676B00AB; Tue,  3 Feb 2026 08:08:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 511B96B00A9
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:08:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B36C1B1C09
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:08:04 +0000 (UTC)
X-FDA: 84403173288.04.328E50C
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010046.outbound.protection.outlook.com [52.101.85.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id EE4D11C0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:08:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kQM3wqiA;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770124081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHaSaUQa8jBA1zCP/UbVW3JoEwphWiYQ25e52J6ldk8=;
	b=j1h5IjBvKEkR2a2q2p+iSyxwPmACmOaGsnFDbGV42e7idLwv/AD2U+zaYQOPRxHdqjDj04
	Z/MSFzK7AEwsWqNnhiSnzUZoxubp1e8KHf4akqk8HHrmVYgW4QRheG25ADlLXwyBbg+0DD
	2gF4zjAonep7xREY1jpKmciBibxsMg4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kQM3wqiA;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770124081; a=rsa-sha256;
	cv=pass;
	b=hvoT4jl09FYfLfaYib2XtTEcNxjAQPjPYpTaXaq0/ww0B09rjf9OSSnfrV8mORC/xKxmUd
	CqyDTzu60LRBdj4Y4wS3J5cVAn4f1LhJTMU5rG6XSR+fIuqFrSaWN0t7V/OvUpKXfijHy1
	jGeVBH9EA2p8b7NAe19LBcpO8XSR4VQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dOc5QUsQUAgCI7YW6Y7ilOeoj9n6z/XvvthCp9B5ymXQezwzZbU54j9Nlh7RZCKVhZVAWi3OzOyzu8NGAcaXpgsJ3bNa7bVYnBGSgyXL1Y6IAf71LZxJg786uUp1E+rmW1tdK1V5Qc4fbtPK248uWpw3l0I0xYYZ+vyMYWAgJdcdXR8ANkIgxLIRl+3XzJqOs/WmFLtQdAo4dmt3S06+mSQp/WgXCO9FL+Yj6bi5KHWMjpLJcm2TgGzMvwGP3089q08R5pj1wvjpn3oG70CHpwPpsx4cmkrcfRGxbL8yfE5rvSLAGiiF7/c7C0R0riUHyJg1SyFx9wuBXeptriHLQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHaSaUQa8jBA1zCP/UbVW3JoEwphWiYQ25e52J6ldk8=;
 b=ZbuDKofct8OHS9Q/XXSvEjy1X837w4afe46JVlbsTuqZb1bjsXXXFe/N2jVGgT6ZYgYbZr7Q1u2Oh+VgF5fjZaniGVGntZmjZHyAWVd2QKNfc4FCxv5TnLKetGVd+EEXuaI2NyRRgxsTtamV/iVVXo/YJzX4fAbSCloGV8PbNoKKqwBzfDR+g6Xa+SS57Zxr64JXHNpUXZJLY1vBja70dD9zSU9qiRD0cpv0iTRKNzhH+cinj7zhJFNscokgUB+IAHwTjLemUfToqa1g9KWF/ZHrUizr9DDYvGCK5XOSlWZJS+QX7y7SZcXZTR1sld08Rx/CMGs8io1esALx+sQyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHaSaUQa8jBA1zCP/UbVW3JoEwphWiYQ25e52J6ldk8=;
 b=kQM3wqiABKCk9RHy+QuIS21Hd20zhq1wh75T2Umz/VeARZ8vaxsYE2MeFnBxYjFFbZdHlHFtm2+fxq1/PPP71hhWKnv6wYqSVGS2S2xjYt5LQjovvhUHZU7GzQ6tZe1s/gtgX0JEc2+o+GNRZysyKYsiDewyASJU6AHOZQQhW3pQY+xJ8Qs5U66cJfSQ3LEHQohPfUoZ0CIgj5LmwWBXz5t1Xr6NLCIEhVNNXLRQY3fkiBc7K7e0WF/CPHw7Xx5I17H3TaMWd0DCgmq9caywk1b7mzSNhhOeusyuILcRhS+KISHzSdvbAv31su4eoYEgTLO6vpFYQ1i38+E6e0so/A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9323.namprd12.prod.outlook.com (2603:10b6:8:1b3::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Tue, 3 Feb 2026 13:07:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 13:07:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Gavin Guo <gavinguo@igalia.com>, david@kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
Date: Tue, 03 Feb 2026 08:07:49 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <3172E2A7-EA3E-4F68-8067-96D72AE5D2C7@nvidia.com>
In-Reply-To: <20260203130427.n2td43cb275ybi7j@master>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
 <20260201020950.p6aygkkiy4hxbi5r@master>
 <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
 <08f0f26b-8a53-4903-a9dc-16f571b5cfee@igalia.com>
 <4D8CC775-A86C-4D80-ADB3-6F5CD0FF9330@nvidia.com>
 <20260203000035.opgq74myrja54zir@master>
 <EF19148C-5365-4D00-AF21-B0D71E799740@nvidia.com>
 <20260203130427.n2td43cb275ybi7j@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR16CA0018.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9323:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d5baecc-3208-4e73-1a06-08de63253e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OaCuI8leLoQV05FoQIigoQx5MPFo4xt6yzSc+xLwyLgaIN/KbXrJs5fjValC?=
 =?us-ascii?Q?Am47C+Km/l+UHdQqU04wkyKO697DCNIRrgC9jhfrLxfYUgPrOBqnE7LhfF16?=
 =?us-ascii?Q?T1CD/lLrfXq4ETcs9fStmwjyYSWKTWW+E8F3be+K+nT/XlgJvuJJy+TI4bXf?=
 =?us-ascii?Q?belglcHcc2MZyAD/32TDLyjbAuhQkfPWPliH+JnOoXFGq1FsPrKjrATz2CaF?=
 =?us-ascii?Q?JEnX4QaUwyoyW3clM9EfRGD9uSk3Cg90eUbneB52nIUdHL6Pq92X+MUjUQ0W?=
 =?us-ascii?Q?8zzMjz+ew5R6Ss3qqs5dlSQ7XKISIbL4Y+uGXZfRBWxEaNZPTDmwwVkrgyif?=
 =?us-ascii?Q?2bQVWmgNoglPRpgdS7rWM8mZPwXN5O0ZTGOMFNPNYNR+eMw+wC3Dug2FrRql?=
 =?us-ascii?Q?HqZ5GBX70Yrs7PkGQ6QBgJ5f0sn6AOG5j6+NrbwjrUb5ViUxXf7PUBF6ZLSA?=
 =?us-ascii?Q?Rs/jYMyJsIiARU/1YP+LLZ5tjf/D+FAo0PUKxPRvAFqRJDbiDaWjZGXWPuto?=
 =?us-ascii?Q?5fkmWNJrI0i6+TwrOpDubnJd5nD4lAOUATJ6mYfeP7c7MI8q+mKIZsST99Jm?=
 =?us-ascii?Q?89Kygx/OXjq7imEnJTu8J6A9Qby+FDmV/nDDbgEmQN4RJaaIT0OrIqzVv2pf?=
 =?us-ascii?Q?5v4fSa03ZIB/kotGhNkV9yEuXwjNt8LFFjDF2x3OjLBd36Ni9fcIIgaEJLHg?=
 =?us-ascii?Q?9aH5tcVby4PdgRLYFZrCfZq9smygB1pKTyZ+IUj0dLhAh8YHR2AhEDyouoqk?=
 =?us-ascii?Q?tyU6sIsOamoaFEXZ+n4Oqjwo0+gIwIPyU7RRluCrQrzzO6Q/TUVEwEnbVVh0?=
 =?us-ascii?Q?wd7ej+vyh77YXABBQoxoZeN8fkzA/80UJlU7E1X1UAUZZt3gyrbHIFGrIB4h?=
 =?us-ascii?Q?XgaCBalvVMwOpfyqDN7SDmE6wI+vFxSiz2VmFbDO6HakM4wwcS4NJiOzbMw6?=
 =?us-ascii?Q?2fUXSJJfq34eN9ZIjPobOE216CiiEsqmYe6ncGjBzngye+VuEEhOSbCMF+c/?=
 =?us-ascii?Q?4q/8RiI3ysMhOJ8VoLyI0jlltVexE6JHVrjq3DqhLe0+lYnmB231kCdX+UBd?=
 =?us-ascii?Q?vDZQfSAh6/CD/xZ6JjcMKHCmViYJVC+UDY74OxuOHJ9y7//0L2kDegUTxTRJ?=
 =?us-ascii?Q?DvKylcbw5KxD0FNKOmQRc1msTRki7OeJLL2B3WV7JXxmckiKm+H3T5nCJPIf?=
 =?us-ascii?Q?lA1r6lJ+/p9MGziijq3H2MapGIo9pl7XtQzU446TcDvKPtCHamiTqoIdZSuw?=
 =?us-ascii?Q?g1PR9A748hr/cexV6VhtRLTxdiesiWitNaoI6XwR8CBTzdqMwGWBl52GwkSO?=
 =?us-ascii?Q?eym75QpMQ6U49+Li4eRiVuUDflEvXWgAXqtpnWkSejcB0es333dSZ4YVE7aC?=
 =?us-ascii?Q?Zy1LHo45Q6YLtFZyZwdbPDT5Zl2/wRjey+8Nyudmj0BDZ2Ya9L2VUeYaZM3A?=
 =?us-ascii?Q?qIqlDTtbyIkYrJazXhHgQN5EC6bt/heejKzTZ1WUKXSON7ezTCq0d+zGUQf1?=
 =?us-ascii?Q?TnsCifRmU+z/BkF6eEcRG8xpEYwU3aILNnZzAzg6iDC8Si03CPyASYyQDPVl?=
 =?us-ascii?Q?mbWnzU1t5LLKock11Gw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CmCuLR13DL/wVepZt9BxHE6Caj1aBheitjXhCALsyFax+ROxFpXLDYOEth+s?=
 =?us-ascii?Q?arNpf5xOFlJ7AmbfmTQdFxoniM1zkjCzP4BU/W0rsOIxy5zoV32Il/oot9KS?=
 =?us-ascii?Q?G+GFoV1fxumQt6hv5c4MRjHMl1BALIv3K3XIx1BvK+/eCJA0S7rm/uR5SSvz?=
 =?us-ascii?Q?X/JiiVH8imTeARLIxsHW4HLkHdTkeO9Zhl7enj2RN65k7EhJ380uggj3lLfP?=
 =?us-ascii?Q?vDg4EOzFDCg6AwhmI4VNkFyDTu/1Nf/h8yket53o4L1X/BsD0AyZ/10B0Pt3?=
 =?us-ascii?Q?DEMX7Aelj/cgcjwtHVxDa5kRVXYVCFTPndV1jcVHrnf9FRSp4UzpbC/6G72n?=
 =?us-ascii?Q?rLFwAzMWDk78lvZI7oPPDMDVTeDijT2hpjEhVAor936nRzp8WcEslYV1YnUA?=
 =?us-ascii?Q?D+FbQ4SJCvQG1QJBCLvZuGfk/7y9poFDLm7Pdc8M9bfm0mxEX1Q6ei9vIoyV?=
 =?us-ascii?Q?JEyeLtMxLhiMT2wb37gd5rw4l8a9fyDqUBrN0KXJ3WXWovAQVa+7KYhvJlyO?=
 =?us-ascii?Q?NENjxqjdWpj2OBJJMGvmdpM1X2RfARNcpOUe/nrBqrdVxzAbIZR6JtvtFS2H?=
 =?us-ascii?Q?cU9tyggsQPo8KIBOuuwe81MR1LJU8U99XrkoFmvoez1hlZ/XFKhdvIcEzGLn?=
 =?us-ascii?Q?axGp0lOECAaogpy7mjUZCRjZonp4jma27jfxx+npJIxMgnifCIPvxodhYFFr?=
 =?us-ascii?Q?TBOt+lBuqCMjxXEfT5asBcmYrNYnl8BR0K64P03GEY8x+3RGfHOCibWFaz06?=
 =?us-ascii?Q?75Xl729nbugjViU88FJZu4XP4JCvqqktTNj7OThNJViOLu0IvVnWThH7JVxB?=
 =?us-ascii?Q?jvtpWAR9cz7OUPOBYvNFaVi8wwc9btjo6YDXkABqQjXAs4x+tgVpUgeO8/UC?=
 =?us-ascii?Q?mzfHufas2R6odXm1mAStOPCVE6Z6hG665lq3OSUYkNis/5yt289GP/iH7jJK?=
 =?us-ascii?Q?lVBEPI5EMGye6TRxUtoZVtynJiCFvubimbXHSjbgnmIxaeXO0/iWYVbGMluC?=
 =?us-ascii?Q?RUidpxvrl87r22od99ZNWRxmwS3YL3Qbe7TNzllWoH+huqwAe3Bu3qA4FcMk?=
 =?us-ascii?Q?Ls91lUkngDnCF/L/T12byXxkgPyJSDUK+2XPSwUkbhT4hkUNY9D1RAYrSKcg?=
 =?us-ascii?Q?XBiP9y81Rf7+ft1ABbBIVebBI6XbS/qg7iFPyt4T1323Sr1fjjag0Mo//BK3?=
 =?us-ascii?Q?QwSbTRZ3ivLDLZ65aHZ0558L0KnnjohXRjfDpaQhdd9iT2cAXaHHbWAI/SO8?=
 =?us-ascii?Q?+nAUcyUYqehMY2W9yH5YWbdT8mlotjpkNlNhT/obGW79um9qNOAXxR69Nxj4?=
 =?us-ascii?Q?9BnrShPLewvhyNPzsgT/1o7Uiz2lIoJotCb3rjMJpAlSiPCO9ETUZr0EXR0A?=
 =?us-ascii?Q?28VTPqwLlzMuAL/sQYLjmcTKqe78QwJg90bAU3zQKtzIY/MGbM7W+A7JVrNE?=
 =?us-ascii?Q?ebQoHXmpUaS2dl0NFeAw+kAzbqwjycIDSrHeYPc13GTolJb+OfMpoQclijND?=
 =?us-ascii?Q?GUuaa9NKoLNawt+g3n4tSAdy9RCBsYkGl4SNUk6L7c2KUIlzkqt7PBg82J8K?=
 =?us-ascii?Q?TOHWn5Fl+jU0q/pIbL+EZEX1LgTbJl5B3j/G3KdOedjsrm+If0VIBbsiNJTz?=
 =?us-ascii?Q?vZhRuXVXMLhnM3iirLwnud23UCvFo2UlenOYWY5JPxLp2LayiUNgj/uNfNUT?=
 =?us-ascii?Q?M48zGdE0+stV8Mvf6rzhnXiAjmrZ2+smOxQRufAhSwLDnxLc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5baecc-3208-4e73-1a06-08de63253e40
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 13:07:54.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KK/azDZbBnfdDQDBqcQJVeZtLLaz1Rd+86o4j1umsyksOlXN7TtdqAN2kENS7lD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9323
X-Rspamd-Server: rspam12
X-Stat-Signature: ei9nxsn3w71p3ajffmz679jgzr9wf7cr
X-Rspamd-Queue-Id: EE4D11C0005
X-Rspam-User: 
X-HE-Tag: 1770124080-323276
X-HE-Meta: U2FsdGVkX1/+Qzpz+qtXjoEOU0o6XbKjf0E/OCqA/kKW4v9bzXXbK3GAEH4lMB6P0y0QenLP+G/J0WS3/C5VJWUWI0WI2RvJLZcp/AgjTtSHUHmjRwSoqk3Gx3mD4XrETGRFq9efwMee2S0dRJtHsVVOsLh4pByDPk6kvruyPdPI/nmMswCIFx2qnXgjK5L87dzHzDQuSCH1n58bf6VMOAoq1qNHnmAchS6mLjCHmLlNT2d28gr7U+ZwsP6QJOJMjLoY2QLJxu50tvumm8TznmKG1mcL/Eyz4KawQwe4cxMN19uhZJjD6QTZ9MvleYE7CeKEUWg8PMJJeLRHfAW+iBW5LBb/FpNCdfMG7HH0AYQqC1c9254OOAgdFSLA7fgb1otzQC0Dn47pfyWggwEN1lt9VQYnKzRTzgncK2fQZ5WHogYix6VY1VlCaxH7XfpITUhfheybICjHo3NCsl7+fCIqKjT2gSSLP5RuGqBUiJCuhH/SJZPy3mOyCD/WiKRSDu+N8W2eFI8o710RRuuC0AJn7+osZeKffbWPrGBhjrlEpfqXYmgIIwQSGuafywkJFcrYMOk0vKykcn9Cqa2crj611nhStg5RxOErqSXN0PGUZJO31HTka6pDXBU4H7k0CMNj+fptGik39yS0iDQsKenUvpeZKktlsSQ+EyO13c/4arx/PMU3zkskewu/ngUNwwV0iV5iU1oIUlgJr9YqoNPf9I0lOC/SbV5cd/p80H7AnqjYm4dWPh5KaxYY/pTpqyDwqpvMNibXAEbu5nAAfI17hYLIZlA/UJjkZHzWUXMeyCib+G3pSajLHthoXUhZh3Tv5vt0bhus+NawLI3NHjTzBHeV/ZZgE+G37mFpRsIIz4ul/07Araxd6YI2tA4TXHPvhP1Hx9TGAqJTAr2SpCvWdYbdJ05/UWuhb0XPf69TeGAq4Q9PkcgSGgK2SIYckA4luoGDV38Btb0nBRj
 bDqobkoD
 bAS15r5xweVysO4JILYQl6qnyW8lx7kQVrPocy3DH8VcVjMO/9D0qFcNfvD6DbgJyvP5Im99kCmtubAYuNV2orT51mQJvYqfo0NKeyldykY8e3PzMrqZBz+7pgCBfovWrS9MWGqhbXq5FXziFl4lKn76l3eGNzECsrtg0AXmRENzy8X3gtLVTjdGfwxewU0uvNTQrDGnkC9TSUl6g+lQMEzSAhGOw+OGZyEb5wu3do8Cnrwb0C75QhQd7TCW42+k6dmzNo8uOTW2x9JNodToVNmSMZxKxB+oFtqTx3Pi6RoyByVySctldABaB+d/E9g5xc72XmXNKTR8ZJwbAPbEFWYWp8eDtH47/rKywFOmjXGu/s+bhIebgbW/Q0OnnE2TXaHnaM5gryS/Vp1ggFfsaogVZH1WeBpomI88ocTZqzhtPHzueOZlAtRUUCE2BCPnQHij1/iLkTtq79HAjmUPUj8tpxKDAeWMSDokT21rA6KbN8qNtbr05wMH/AJpJmCt1yxXHRmOrknTe5s1VLE04MNCU9DCD89VMJz8hgc+v1kkt5bGhNb7GE4gFY4nyLfjEsfXP4C7CHkys73V80O6asgNuoeOmPLfBVpWCoO5c76Wq64+Mm8vyFTWDCYmmbeQD43fS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Feb 2026, at 8:04, Wei Yang wrote:

> On Mon, Feb 02, 2026 at 07:07:12PM -0500, Zi Yan wrote:
>> On 2 Feb 2026, at 19:00, Wei Yang wrote:
>>
>>> On Sun, Feb 01, 2026 at 09:20:35AM -0500, Zi Yan wrote:
>>>> On 1 Feb 2026, at 8:04, Gavin Guo wrote:
>>>>
>>>>> On 2/1/26 11:39, Zi Yan wrote:
>>>>>> On 31 Jan 2026, at 21:09, Wei Yang wrote:
>>>>>>
>>>>>>> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>>>>>>>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>>>>>>>
>>>>>>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one=
() and
>>>>>>>>> split_huge_pmd_locked()") return false unconditionally after
>>>>>>>>> split_huge_pmd_locked() which may fail early during try_to_migr=
ate() for
>>>>>>>>> shared thp. This will lead to unexpected folio split failure.
>>>>>>>>>
>>>>>>>>> One way to reproduce:
>>>>>>>>>
>>>>>>>>>      Create an anonymous thp range and fork 512 children, so we=
 have a
>>>>>>>>>      thp shared mapped in 513 processes. Then trigger folio spl=
it with
>>>>>>>>>      /sys/kernel/debug/split_huge_pages debugfs to split the th=
p folio to
>>>>>>>>>      order 0.
>>>>>>>>>
>>>>>>>>> Without the above commit, we can successfully split to order 0.=

>>>>>>>>> With the above commit, the folio is still a large folio.
>>>>>>>>>
>>>>>>>>> The reason is the above commit return false after split pmd
>>>>>>>>> unconditionally in the first process and break try_to_migrate()=
=2E
>>>>>>>>
>>>>>>>> The reasoning looks good to me.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> The tricky thing in above reproduce method is current debugfs i=
nterface
>>>>>>>>> leverage function split_huge_pages_pid(), which will iterate th=
e whole
>>>>>>>>> pmd range and do folio split on each base page address. This me=
ans it
>>>>>>>>> will try 512 times, and each time split one pmd from pmd mapped=
 to pte
>>>>>>>>> mapped thp. If there are less than 512 shared mapped process,
>>>>>>>>> the folio is still split successfully at last. But in real worl=
d, we
>>>>>>>>> usually try it for once.
>>>>>>>>>
>>>>>>>>> This patch fixes this by removing the unconditional false retur=
n after
>>>>>>>>> split_huge_pmd_locked(). Later, we may introduce a true fail ea=
rly if
>>>>>>>>> split_huge_pmd_locked() does fail.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one=
() and split_huge_pmd_locked()")
>>>>>>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>>>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>>> ---
>>>>>>>>>   mm/rmap.c | 1 -
>>>>>>>>>   1 file changed, 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>>>> index 618df3385c8b..eed971568d65 100644
>>>>>>>>> --- a/mm/rmap.c
>>>>>>>>> +++ b/mm/rmap.c
>>>>>>>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct fol=
io *folio, struct vm_area_struct *vma,
>>>>>>>>>   			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>>>>>   				split_huge_pmd_locked(vma, pvmw.address,
>>>>>>>>>   						      pvmw.pmd, true);
>>>>>>>>> -				ret =3D false;
>>>>>>>>>   				page_vma_mapped_walk_done(&pvmw);
>>>>>>>>>   				break;
>>>>>>>>>   			}
>>>>>>>>
>>>>>>>> How about the patch below? It matches the pattern of set_pmd_mig=
ration_entry() below.
>>>>>>>> Basically, continue if the operation is successful, break otherw=
ise.
>>>>>>>>
>>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>>> index 618df3385c8b..83cc9d98533e 100644
>>>>>>>> --- a/mm/rmap.c
>>>>>>>> +++ b/mm/rmap.c
>>>>>>>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct foli=
o *folio, struct vm_area_struct *vma,
>>>>>>>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>>>> 				split_huge_pmd_locked(vma, pvmw.address,
>>>>>>>> 						      pvmw.pmd, true);
>>>>>>>> -				ret =3D false;
>>>>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>>>>> -				break;
>>>>>>>> +				continue;
>>>>>>>> 			}
>>>>>>>
>>>>>>> Per my understanding if @freeze is trur, split_huge_pmd_locked() =
may "fail" as
>>>>>>> the comment says:
>>>>>>>
>>>>>>> 		 * Without "freeze", we'll simply split the PMD, propagating th=
e
>>>>>>> 		 * PageAnonExclusive() flag for each PTE by setting it for
>>>>>>> 		 * each subpage -- no need to (temporarily) clear.
>>>>>>> 		 *
>>>>>>> 		 * With "freeze" we want to replace mapped pages by
>>>>>>> 		 * migration entries right away. This is only possible if we
>>>>>>> 		 * managed to clear PageAnonExclusive() -- see
>>>>>>> 		 * set_pmd_migration_entry().
>>>>>>> 		 *
>>>>>>> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
>>>>>>> 		 * only and let try_to_migrate_one() fail later.
>>>>>>>
>>>>>>> While currently we don't return the status of split_huge_pmd_lock=
ed() to
>>>>>>> indicate whether it does replaced PMD with migration entries succ=
essfully. So
>>>>>>> we are not sure this operation succeed.
>>>>>>
>>>>>> This is the right reasoning. This means to properly handle it, spl=
it_huge_pmd_locked()
>>>>>> needs to return whether it inserts migration entries or not when f=
reeze is true.
>>>>>>
>>>>>>>
>>>>>>> Another difference from set_pmd_migration_entry() is split_huge_p=
md_locked()
>>>>>>> would change the page table from PMD mapped to PTE mapped.
>>>>>>> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw-=
>pte), but I
>>>>>>> am not sure this is what we expected. For example, in try_to_unma=
p_one(), we
>>>>>>> use page_vma_mapped_walk_restart() after pmd splitted.
>>>>>>>
>>>>>>> So I prefer just remove the "ret =3D false" for a fix. Not sure t=
his is
>>>>>>> reasonable to you.
>>>>>>>
>>>>>>> I am thinking two things after this fix:
>>>>>>>
>>>>>>>    * add one similar test in selftests
>>>>>>>    * let split_huge_pmd_locked() return value to indicate freeze =
is degrade to
>>>>>>>      !freeze, and fail early on try_to_migrate() like the thp mig=
ration branch
>>>>>>>
>>>>>>> Look forward your opinion on whether it worth to do it.
>>>>>>
>>>>>> This is not the right fix, neither was mine above. Because before =
commit 60fbb14396d5,
>>>>>> the code handles PAE properly. If PAE is cleared, PMD is split int=
o PTEs and each
>>>>>> PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns=
 false,
>>>>>> and try_to_migrate_one() returns true. If PAE is not cleared, PMD =
is split into PTEs
>>>>>> and each PTE is not a migration entry, inside while (page_vma_mapp=
ed_walk(&pvmw)),
>>>>>> PAE will be attempted to get cleared again and it will fail again,=
 leading to
>>>>>> try_to_migrate_one() returns false. After commit 60fbb14396d5, no =
matter PAE is
>>>>>> cleared or not, try_to_migrate_one() always returns false. It caus=
es folio split
>>>>>> failures for shared PMD THPs.
>>>>>>
>>>>>> Now with your fix (and mine above), no matter PAE is cleared or no=
t, try_to_migrate_one()
>>>>>> always returns true. It just flips the code to a different issue. =
So the proper fix
>>>>>> is to let split_huge_pmd_locked() returns whether it inserts migra=
tion entries or not
>>>>>> and do the same pattern as THP migration code path.
>>>>>
>>>>> How about aligning with the try_to_unmap_one()? The behavior would =
be the same before applying the commit 60fbb14396d5:
>>>>>
>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>> index 7b9879ef442d..0c96f0883013 100644
>>>>> --- a/mm/rmap.c
>>>>> +++ b/mm/rmap.c
>>>>> @@ -2333,9 +2333,9 @@ static bool try_to_migrate_one(struct folio *=
folio, struct vm_area_struct *vma,
>>>>>                         if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>                                 split_huge_pmd_locked(vma, pvmw.add=
ress,
>>>>>                                                       pvmw.pmd, tru=
e);
>>>>> -                               ret =3D false;
>>>>> -                               page_vma_mapped_walk_done(&pvmw);
>>>>> -                               break;
>>>>> +                               flags &=3D ~TTU_SPLIT_HUGE_PMD;
>>>>> +                               page_vma_mapped_walk_restart(&pvmw)=
;
>>>>> +                               continue;
>>>>>                         }
>>>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>>>                         pmdval =3D pmdp_get(pvmw.pmd);
>>>>
>>>> Yes, it works and definitely needs a comment like "After split_huge_=
pmd_locked(), restart
>>>> the walk to detect PageAnonExclusive handling failure in __split_hug=
e_pmd_locked()".
>>>> The change is good for backporting, but an additional patch to fix i=
t properly by adding
>>>> a return value to split_huge_pmd_locked() is also necessary.
>>>>
>>>
>>> If my understanding is correct, this approach is good for backporting=
=2E
>>>
>>> And yes, we could further improve it by return a value to indicate wh=
ether
>>> split_huge_pmd_locked() do split to migration entry.
>>>
>>> Thanks both for your thoughtful inputs.
>>
>> Are you going to send two patches in a series, one is the above fix wi=
th a comment
>> and the other changes split_huge_pmd_locked() to return a value?
>>
>
> Hmm... as the above fix is supposed to be cc stable and backported, I t=
hink
> separate them is the correct process. And for the return value of

Right. Andrew prefer this way. You can send the fix first and send the re=
factor
patch after the fix is picked up by Andrew.

> split_huge_pmd_locked(), I will take another look at all the call place=
s. Are
> you ok with this?
>
> Well, do you think we need to wait for David's comment? If not, I will =
prepare
> the v2 fix with the above change.

You answered my question. There should be no issue with existing code.

Thanks.


Best Regards,
Yan, Zi

