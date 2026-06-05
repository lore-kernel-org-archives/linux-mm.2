Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7595ACD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 19:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938AE6B00A4; Fri,  5 Jun 2026 15:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA066B00A5; Fri,  5 Jun 2026 15:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1D76B00A6; Fri,  5 Jun 2026 15:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF5E6B00A4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:03:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBF7FC158A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:03:44 +0000 (UTC)
X-FDA: 84846783168.21.7C86283
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA22616000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:03:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TtjpzMzd;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780686222;
	b=mXASbtyh/4CDv9lK/RGmqD/Uh8/NM0Htxv6t84/gz4Vkopw+wctWSlTTYzfC8TgoWRt9uW
	kQwHXNVrTn1OyLuhy0Ys1uSCjN/HClfD5tu/+faLexI663/iSJdE3xTwWtq10Soxv7bWD1
	DUQQ/Ys1MbmlRd8r7OZa87fejFAGcMo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TtjpzMzd;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780686222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5Zt1lYz8476Up6o6xsCXIvYzDKxz+lEH8ny8OlgWVU=;
	b=tZ85lEuxnnB7xJ5HGLx5yYPlfHuGtYaOmvvTAnDTGmHpcMiMVukwLVaKrgJQu/t1OlenC0
	yzON8jNJrEXVoqjBkOVPDGRHkqo35v6zw3HLarqZStgnBQMjAm/LoP9CcvJ15qAzsB4bkn
	mc95Yeu/Zjp/1mOWhHrdx3u/zMk+ybw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fucx7M0MhzXzxLMLBD5vLgrzlpSa4UNkPxafBmY6Dl/A3xGoXKpoBHKLg6ygji+xAiZ/beVJyRz2OnwunN4YmNrkvtpEFV0zmm2iZ+k6RaF/YJRYFeBI+F54bQT4Yf+SdF2oEPClF9XquvR35bG+Ep8yT4fkIwv5x4lVJbKNLo+BFqzMEzu0HjRjwGwiyUTJ9s9EP+b3Dqb5F3cKFwfMtOBgpG7gGDqw38ytDhT16XZHOH/fR12j3ZXJWCqRQjfCC0TXvicLkQo2kscO6l7tdlFGxW5ojRCJs+tXWnFebSv0NIMnd2LDptv86o1gbsDcAXiUmmMPS0dNPdGSKTU4lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5Zt1lYz8476Up6o6xsCXIvYzDKxz+lEH8ny8OlgWVU=;
 b=EkT/5tlNdtM82RVmLcnD0nfFF5q2NX+LQygaTnCUZmf2H4CmO5n1f92aqvfZlWRnVn6jKXzvAngF7Ys74bf1xr2tHEiJedX0TOHqnbE4DWq9audw6W1lkT/3HV39Vo/aPqOVGBf8RDeVScb5cca+54+dkgLUfI/Y2q/KmqC1xeymfhSsW4QsnE1aA6C6jCc0uHLWq7goJd3PtM6ZeFMd16tGzns2XOfZB8KkUiq9Be66cIb3Hqa2WVv4ftHJGOLNA7PuMx4ROXwfjnzYCJb2NZRODvg9C5CzhkhCmAk6pKydRxjmvxLDvdt0l3Ba+rHf4V7NMLE3vK5daMdy0rd2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5Zt1lYz8476Up6o6xsCXIvYzDKxz+lEH8ny8OlgWVU=;
 b=TtjpzMzdIr3gmleYjDJLa12FrK2MDRMkpUvX12hvboDKVQlyxyToJ977xEIQDQ71N500Xo/73eyYtmL4TZEpZRIMLwidzqLGAARM2x6KNgrepWk5ObiDUkTxqqQRuwdec4+ITg57VR7j2NMa86/4HdT8ZxgO3YNFRp3d2GdiQwIY/FuspSHrTU/nE5tlFkwLjbYXoSszKdjTgbm8nQ0XiK1xGWsjcvaTAUrN6/6PxL6civp8iRybkOQvpg/oPOd8YHgHXOQExTLfViA2k18iyH9G/o5qPOttqE8NYw0rJNcqOGQEgynPpOL3s0P9+n7+1nez134L5O4aM4LRn2EbBw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW6PR12MB7069.namprd12.prod.outlook.com (2603:10b6:303:238::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 19:03:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 19:03:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 04/14] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
Date: Fri, 05 Jun 2026 15:03:16 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <89D0DDA6-9712-4DB3-AB8C-B632857BD281@nvidia.com>
In-Reply-To: <20260605161422.213817-5-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-5-npache@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW6PR12MB7069:EE_
X-MS-Office365-Filtering-Correlation-Id: 40fee859-1826-437e-2e43-08dec335240e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799006|4143699003|3023799007|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/r2iWY3zE1VZOHiO+fVXs5g/f9EI4hAvKx2s+TqwwI3bF0hWpGf8FXyGQxGkplgGSRNOhiBJex9vj/JsI0rYn8zPG2BV5LyZMAlJ9p5rJI4/OscAC4SxkCqZWreVCVlEXFO1j792IBpPh/1q2aVGeF27riUrFe7Mc6m0igzHMl+mcFuPLwILg5n2W2Bif6F2OKlp1gfwCC25uGMoAfeW/GE4WKzAtBmKT1sadFjuVPU9p4hR2bvfjzGZu9hm4E+bf+d3q3Qw+YnvCtp0gNOzFZwLBg3zXsm414Q8b3Vy27B44zQuupe8aQViKOK3ze/pUikUcbuVvpC5o/ET9qXrGaw6BaHLc5qttPnYQwytKqE30iyYOabZHy+1AQwVGtN4dTw7Mjo2jfhrAcBh/0HZ0/AdbMxuR3iFQVS0nmXoMWjwl4bwdkEXPiV1IkI3iSNXW9Y3m3gpIhUezigVeLl1FxUCQToxNee7R+Rw4FUER/q1mCylbIxIdCVewQSKwsPGLdcizIpx9eH3/8mjuzEElIpCi5KfMRGc8Y5azZlesuyQPcieX1P2jvzifOWBUneoxK767GN1qavJutOQXvPTV2+nfc0aQ0p+XCBNvCKXD93LcQ2ZjMRU7RJp1Sm8UDVLfTO1i6Bfld5HiSIHfYM3oPoX0GCG23ZZzOrZJsB+ph4EBU4ZdTD+tMGJA6i8S53H5wVKOUJXjXuBnvEpf8PfGA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799006)(4143699003)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lmIiCDwiyhA9HJuL3Xlu2N6lE7atA1P1l2eDOWiWf6+RHcwEzdtwowQihtIm?=
 =?us-ascii?Q?kxl6VWfkh0ZGpepfyIobZBmRApSi/Ah5PH3aeWhx0LxBGez1wFDaXFXuEb/E?=
 =?us-ascii?Q?lWm9fz1sy1AT9pXY0uo/Y2BeXR5TZPtoPO9J1oDb501cKTxx+wCstQb5DGQK?=
 =?us-ascii?Q?hJP3TXax6UAhNZ6PPG4etH9LXtZD/y+OMuYdmPxx/R7I8YIUo4p3F69lIbat?=
 =?us-ascii?Q?UGNTEazRblW1KxNyV9uhRCylsOw62zdkjgtObwOWk2itiZHmOq2f4kR7WAeE?=
 =?us-ascii?Q?zXEEvhK+DtHrWSG4kCSmlfjA64jzYps54IqwMd+RPrEjjDvyTG6MGcfpzqbM?=
 =?us-ascii?Q?YN7U77VCca2eHNU8aQAhZA7bAMDUphhM7ILyZ7Hd/DFpimvsuTjRzUWH42vu?=
 =?us-ascii?Q?P/CHgymrEnCPiA+vOkeIEw68lUCt5YMmVCj6ziygNRIppH1caNqgRMhlnAhi?=
 =?us-ascii?Q?Oa5jbH9s2+M5a6Lrdb6IxQmlg6LAuvVU+O2zMd/HzdiLg8OxdZQAcuejWyIs?=
 =?us-ascii?Q?TkvvxPXJZCNbQdvus03IzGHBtHLAl2kRA60/tKi+6tNA81Iuh7UZR+GybHDZ?=
 =?us-ascii?Q?L1+7V63uikN8wqoeWeU9eqdds/ZQunDxOBldHr7cMCrvC2lr27f181UqVwCE?=
 =?us-ascii?Q?D0vjvHmuSeKTd2xGwsg9TWzD0zhryNZ3YFApzAkimFtCz+aBDkOSBX4y6sPd?=
 =?us-ascii?Q?la/NMaaV+rBdvhaan+JAnAjI/2DF8RjaWN+9m8LkGZNHWSY2Bv/IczLuHS34?=
 =?us-ascii?Q?geQQ2udG1e3S1WoFbcOxbuz3yZVWBBC4+mn4esr5zRO7wHz6egYoxIdEzuzi?=
 =?us-ascii?Q?xV7IGhkeYGASLcmU5HnmH0xi1iGM5HgPc7KPKp5RhcSpvlqIZklpJYb0DyxH?=
 =?us-ascii?Q?v4Gh/Rf4lPao7Ght+s7w0lERcLxUk6yr8CCF1+3D7D0QjuNs1Js5nG6V37jx?=
 =?us-ascii?Q?SsiQBeZd4QGU7ZnSeX8e02tXC10tA3PSZ99e9Cnu36BX4dlRoHG18GuJE3f0?=
 =?us-ascii?Q?n+hySkJDerK/XbTiG9v7cOhAMeXOUSb+3xp35UdBGfI8JKXvzRmm+GIAQuPp?=
 =?us-ascii?Q?DSZ6W3mSpg0ELYRZzmWVf81S45lLHaNvdzvHGI0b4SCqlwRgTJQaHEULtk3N?=
 =?us-ascii?Q?57waJ2NA86+yDgjUFANc4XnDvWtZxinKUGbZ/WwEDbe5IhK1MfkRALmD3YnO?=
 =?us-ascii?Q?j/afZeMT6T1wOdMWaoXoyyRhs7iJgOhWRq6Ul/Sh1AOV7t2kVQlDEeKM9Eqt?=
 =?us-ascii?Q?xwUFMrjM0DfsP1g/r+SdAEpBW6fAhXSVS0GFZzn6Irx1GQgB2kwHiUJbwv4R?=
 =?us-ascii?Q?ziLXTFa8nzXR5jllzZG0C8M5QZ03/TtzB67m0M7Xg2qiSS0M8h9gQxhEEO4J?=
 =?us-ascii?Q?hRuLgEjxXp6izDqd+wz5t60cBsjsYBPk0hwUP/WVkq3otBxjwoH+9DKudzOk?=
 =?us-ascii?Q?3G6gkd4yDhm7/Qj7KvG6RL5DDIiMhj0G63tanwy9LhTJcbqp6oUuUR+V5u5t?=
 =?us-ascii?Q?KUYJOqiZRdNy+89lPQo59/NR3WcGWSK3Tzk9jneabBNzlw3WTRrwFUSnSeBx?=
 =?us-ascii?Q?tNU/NavBikU9AygGsUsjgVkSYTjCO6JeKYGY6EXCcZF/SCMzL9RaGYVqyPmr?=
 =?us-ascii?Q?Yxc/MPqTwC9OgHyNyO1VSQsXLg88gUywSyR8WREhQ81gnUWieaDFM58dtP3I?=
 =?us-ascii?Q?4pIHvf1+A3WQqaZUQHz5pIqxcdsZzYqhw3ybZWZecWBRE0Jv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40fee859-1826-437e-2e43-08dec335240e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 19:03:34.0011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ToqjogQKfgJn4dd8z/tPnuhNwQHbIUaAEVy2GGegn3eJe9f4w/M9GJYw4XnqsgRD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7069
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA22616000D
X-Rspam-User: 
X-Stat-Signature: umcnarfpbeisnpiqrnnb5wypxn6tpdrh
X-HE-Tag: 1780686221-372824
X-HE-Meta: U2FsdGVkX19gYF2An5gpEBdQOYpIMmovF7EJbN3yVW4Nr9hGN+LpazQxPRDm4rvKSJKXUUJnuoyHsiqi5++d2nHCgpWrS/t0n0AhHSmWHQGQDLPM4Tdhn8SNCDNEgD/t2v4IaKcuLK3mTMPxEKMv4WwBqoG7nt+m+geZGR3cIVsl9CrY6ICfxorkso6usaakwehVnannbe+UZJyimN2RcECFUPdVavH6gL3zMpUMaQaeL/7N5H7RA9kZMQs3H7gI/gW4N6LOhUJKX3r6q+LeJ7BEbRMuVdA65f0U47kipO+wZivg8f1QRGjosd5lut+X1spDEkBFRM61+mhbBhSGfynDJMbm63qseBTezoV3e4ZE5ZdfX2f+G1baU47xe2+w43t/24b+8++FbeepyOHgaaJd4WIxTd+Q8jq3afT+2/5r0VLsIvJ6q3EJR2bOV27D3wGdiCjwAogas+LNWYwIqsdvITttD8uncObwuwpKLO8+tlFrPGwPq0BKiiw4qscrvKYu5eQzYrAJenCOqyJHD7n9G83K1gwI0ZLYUWlSS5u4veLQ7X7APBBYf2b0HDQ7B4PkFPnZwbQVkihEy+UGpqjw9pWT/Cd8/WZXLK6cVxjysyRCLEw2130joQZKV0pepMC0e5WcOwcNhZLyKGk7esZaRbB+KBBO/B35YNQjaYbSzQYmaw1VMLAmNK2Sa6Y1NofApTWsHs0YVD4BDKQoGiBXBHPDl821dxgE598TnU6Cc/ctJ6VWn8h9/ThHkacb7F82KJUDVXT8jOYLvectowMuRbbvZPoMK6tZa9y4vhHhHxfaMYgr370t44iNYAZGF6vKboC6xks3b8SWwd4r2kq0YD6CzI06KDI6wrUZNN7xwXh7XxuVMPV5mX7I/C+A09pPIVGabjLQpxB1F/vdcnKp5Qn8JEhgDk33mlKYNriN6Bl5GArRDENher2ZdgTQV8yuqWPZpxP1hdKYYms
 KzmL9szC
 /2dFOfIzf59YYJwaeyDNFKODhZsdBItN4sEN+2Chf0iiawpH9R6cS6JPxA/SzSURSRrIbCg4/8BZPkswzR28d2GnydnI+299xPnGirCwYb8xw7l/SpLc1kzWCUOIX0q+dTupQlfsze4QThgdoQlmgvvBNTaVtPdLGPW35YfxBl6jD6Ekr1IBRg13KcHX0P6Nq4MZfHNbUVN7fCGytKWsLIG9y9HQ01dQ4PKJehwQVNGzvEoRWIYXYzd+HYlEKDW8x2lAsFrat0GBaFLiJCRqxcoZ7XMTTWJ2wIK5z9iUk277VyaIhX+eco1cHHUwy8umX4nGiuHX8PncldFaiZOo4ig2HgchEu9K6fpVqG1WHjY06SXxIWo7V7DS//R6wDe6T98AIaGP4rL3+1ml9QcCXQRVLDhi2HXZGBZG2x90xhdBVl5ZFkhUzwYc8wzzhBea7rKi03rqsNNNwv4sfnQ9D4J/i4tvgAFJ/VzfGUAA+iHB/CksbdNKGbR7ZxyvtMcdIut/NbfvPlR8SdgLDDd/3+dvTRwMigeko0PBISw4NZ3qZ79bYSTmISbA3iQsPnug2z1cMlPB0UlLSAqLpKxGUcxnXodQ2Rc8qCWTXO5e/GwV5WnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Jun 2026, at 12:14, Nico Pache wrote:

> generalize the order of the __collapse_huge_page_* and collapse_max_*
> functions to support future mTHP collapse.
>
> The current mechanism for determining collapse with the
> khugepaged_max_ptes_none value is not designed with mTHP in mind. This
> raises a key design issue: if we support user defined max_pte_none valu=
es
> (even those scaled by order), a collapse of a lower order can introduce=
s
> an feedback loop, or "creep", when max_ptes_none is set to a value grea=
ter
> than HPAGE_PMD_NR / 2. [1]
>
> With this configuration, a successful collapse to order N will populate=

> enough pages to satisfy the collapse condition on order N+1 on the next=

> scan. This leads to unnecessary work and memory churn.
>
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes: [2]
>
> - max_ptes_none=3D0: never collapses if it encounters an empty PTE or a=
 PTE
>   that maps the shared zeropage. Consequently, no memory bloat.
> - max_ptes_none=3D511 (on 4k pagesz): Always collapse to the highest
>   available mTHP order.
>
> This removes the possibility of "creep", and a warning will be emitted =
if
> any non-supported max_ptes_none value is configured with mTHP enabled.
> Any intermediate value will default mTHP collapse to max_ptes_none=3D0.=

>
> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> shared or swapped entry.
>
> No functional changes in this patch; however it defines future behavior=

> for mTHP collapse.
>
> [1] - https://lore.kernel.org/all/e46ab3ab-a3d7-4fb7-9970-d0704bd5d05a@=
arm.com
> [2] - https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@=
redhat.com
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 126 +++++++++++++++++++++++++++++++++++-------------=

>  1 file changed, 93 insertions(+), 33 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

