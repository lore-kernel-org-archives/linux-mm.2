Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7716D609D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 17:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5586B0088; Tue, 16 Dec 2025 12:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CDD6B008A; Tue, 16 Dec 2025 12:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2A86B008C; Tue, 16 Dec 2025 12:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED4816B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:20:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A10811A0795
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:20:15 +0000 (UTC)
X-FDA: 84225997590.26.2349C44
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	by imf26.hostedemail.com (Postfix) with ESMTP id CECE6140006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:20:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RFc2CqMF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765905613; a=rsa-sha256;
	cv=pass;
	b=rHZyfFdQEoAQpUa7nC5Z9xx5PmPVYu9Bnj5hH+WS23X9xzvDdfPnH5zuI7mkQx0p0GiWF9
	aVyytXMCdLC2r71RkgNUNEFikSs/U9hX+s3DQrE6y7RZBt74csD4riNrhtLJ/IwvugBC4A
	3v25oRTdlZSfzpzWotVpBenvdxbyj8c=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RFc2CqMF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765905612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4n2TcPeYVyUbPP62zVjEJFr8PXwqDjl6ufMcY3LIRg=;
	b=C2dCl/MJENnC8BAzFyU0yR1iVNMSaPqIcZiBfK6+n0rSVSPHQqaJsGfHMZ5ixkSpoxHEH/
	BIeWQpVk6dY5z1zjvnPtjmMYnuw+902gq6VKQ1O6JSlg4xtLBbN+L+FR2h2qFS3LRtGln4
	On8GpyICe9vSmdF5b9cS02+fl52ZYdA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUn7Q8KkNmiU2Z2o9Sf/vM4loor2LpiXi/TaAXQbPc6Kao6GV+k5xPjU+eEgy2BzdzEQ10GQKxosviiBEFtHRNg5/YvCXHixELqza47h2FTG64p8qh0YdhNwbSGL+TjLOXGe49KpMmd45NRdb3pGXpifsczMqN8f4jxFRzBRwzF+2lL5JObQV3rpKe1t1opd6iR+yUFa5YQlFYJugU+qJ4Z5p6wi3d+jjQfBS4ok7Au0TdDF/7op0RGWy4MSxHUahj4pFy4SauTecPxr5SLQyoJceO3OinZfgkO3QT4TgzlD4d/BVKXOHTw67CKSYTtZjLMvrQBm8ZMTHnG8jxgASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4n2TcPeYVyUbPP62zVjEJFr8PXwqDjl6ufMcY3LIRg=;
 b=prI+Z1/hPfrZEpVWWl3LYPHN7G2QuMvdGbY3sY9Mvs8JQplkfm264bHDiAL3uV3Xaw4jqNS0EcewkDK3RZCcU1q8r99QAF4nNE86lb8H46KY9BSMtjTRxnFVZQuxD5eI7eH7qUbPSJd16YARepYNrZCFlEPzsKQsWFnZnVJ1OrIrP/Nn/w9DLeG28W49eTICLM9h5EKsDmV6PUNdAWHPp5RYQxgE8hO98kQJgX4V5Hm26DDf3rAAG0Ql87OyZB/vojgF3Uh3agLgeTpcx0qIhxNZZGOI87h4SO5kzvpOyv9/dMPsP1XHyz4yC5GlaNboxWvMBQGK+KosD5JZwa9T3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4n2TcPeYVyUbPP62zVjEJFr8PXwqDjl6ufMcY3LIRg=;
 b=RFc2CqMF+B/+tpJ9BY2Xe/V6LPGgRBU1cf1ixUdIpgqpR0vJBZwW9ak8W1527HqUraRWuDRBQ5MxagoQbk20hPykFddhixP6sObye3IuIGoJAckUP/jT1H5hQnL0qLPLgNRY5iVi5y6i7J5p92Blp6uO2rpB2N7Xy1Ij+SjtJyThKzNYTNP9Tm98XAXY0BK/TLJyg03jOn+AU9uu2AeVtkg6yodKovpCcRQhAYsoWeAyYBLbx17q2BFo5DkT9m7H8treHVqP24AsX0O8X50rRaI2TTM9VSQd65yRwLwpD1GEve/N44ZkrXFXDvjE1e6q5QMgQxtp3YMFC+7djuA0Yg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7795.namprd12.prod.outlook.com (2603:10b6:510:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Tue, 16 Dec
 2025 17:20:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 17:20:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 4/6] mm: page_alloc: add
 alloc_contig_frozen_{range,pages}()
Date: Tue, 16 Dec 2025 12:20:04 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D90F7769-F3A8-4234-A9CE-F97BC48CCACE@nvidia.com>
In-Reply-To: <20251216114844.2126250-5-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0332.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 8858d5fb-1e78-497e-32a3-08de3cc75b7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kPgnqIXCvEzyKbKEC8ojqpD2VlMf7J68dDr/bibGF/vzPvUJrYIUIBVKWhEP?=
 =?us-ascii?Q?ZKPlPp+9LONReJZ8+xvo8SUhWuoQgZkT4IOQNyrpsodWYs1uWVpUOgF+1X8b?=
 =?us-ascii?Q?55hnN+srxi8wl21tKN9XuoyOzdNS10f/XjwT604l1npq0WL28nfKPNn4kKpK?=
 =?us-ascii?Q?YEbx0MdqGXMuEwXzOW6I2TEE/hUh0QSVOQTnsld3OAx3PPKLdZC/nCJ082RM?=
 =?us-ascii?Q?tALjm3EqeqYzSr16gE4OOJqGa7Tll60GWWnYyTVkhsFWLW5pFlGLTrOCC+Mv?=
 =?us-ascii?Q?bVJP5/LfIuYPmR4mE1d5KojW6BgEIxkn/mb2M5SIjZyXqhSDnu6iy/Fr6s2V?=
 =?us-ascii?Q?e3ckeBNHOsVXGArt+QAgY+j3DiytoITlWowGpKZkW64xKKLwOeBaJKmPEwim?=
 =?us-ascii?Q?Rr/6woSBNKsbwAaT2r/nFZ6FMeePHS4YBJxC8WQhF01LjO2gGFAo2dB9xqWn?=
 =?us-ascii?Q?SlM0nVbtgkH6Ak5PCxw18oQxmI2brNDGth1QD/OYBApgO+qwkqoe89CZkn/f?=
 =?us-ascii?Q?T7JKDWtykzTTBFGeD/BbEzO1i4+s7lM8+iqjbS0GkuokukEBC4+e8LEiPQ/T?=
 =?us-ascii?Q?maBas0GJlxaBSbWP+gh1vZXLOgcQ7myHzisq9zAsiMUzh+Dq3x6bame8C7DP?=
 =?us-ascii?Q?572X2UQHJX3FEB8PF5TcV0yHU9iSkI3XTBKmrjwmL5g2uXFB7eS1Zi2caRFR?=
 =?us-ascii?Q?VdMOkQ1aX8BgQ4iw0XOPLgAGx98SzUyAWcaCIb87UnYv4pHceENRFn2Q1mPb?=
 =?us-ascii?Q?468c/DRnesyWEsjIhGpYNAs8YsjeqoQ6beTPObyTzi88zriUpN0DvgU1wWFk?=
 =?us-ascii?Q?+JuKCxN/BgmgBT+6/2e87gNPmXbk2v1l1tX+FvZEsy1VW6knvqZgOdycCiES?=
 =?us-ascii?Q?+776u6Ovou5KLWF3F+pzwcpIDR7GfuUPC5s/e39WJs8z+WsgR5adkEmu30rO?=
 =?us-ascii?Q?O2uuT+vyOiumRRnUY4JTcoKgpoyJhgilYlIG7CuNkrt2wab9j8kqx6+VpRiM?=
 =?us-ascii?Q?12MlLreG9cEBJR5KOzNfzuGgaQT0bfcHKg7+rUuMth392mlmbnQPicVzfSSR?=
 =?us-ascii?Q?QaXfa58EUZyviK4Gw5BVPxcKHLww1dOkI1gdDRfvvK1I8ZiRQ7WWC1KR/gwz?=
 =?us-ascii?Q?eTeJktaiIqwDMKfUxlv7mA0TPZwWomFUFvjrVZK8yqaucWuU4TgtMuMzPz1z?=
 =?us-ascii?Q?SaQVns7+JJXX+4Z2DKdiCn66mL/91iSMpjqYtJvIyYmbP7oW4IdIMJt9jOzT?=
 =?us-ascii?Q?xU4JE0UrFTfL8rY5PyOx2JX3mtqVlykoG+aqfHeEd15imAgVpopb+822bMc4?=
 =?us-ascii?Q?zHyuF4q1elwpzi/8B/8hRBJvtXCALzaf+HYBGEre2AACNJev9FqaKHSWptkn?=
 =?us-ascii?Q?waHZrjnULZtuoKmJiKPkp2qB23sKe63gt6+/sxe3t6ouIDO84nmTFDwbZks2?=
 =?us-ascii?Q?x5uTKSbW6KDdIC7oUX3GF+xQe12JU8Ta?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?faZEtopp/Sg4YdKNmPJAMM/35laF45S9Dfcda1F6ACjDHFKOJeMlqoGiF5Tc?=
 =?us-ascii?Q?4cf04zNQ5IXdd2erB7vTSQYpUZ/cBem5q4lxFL1efI48SMSci399gJv0fi90?=
 =?us-ascii?Q?k1wYNHyv/nLV5k6voL1a97rX8+jv1W1oo0awoCvLUuUixuJzLEqSQENeoOt3?=
 =?us-ascii?Q?QS5RKLc31bYvz3Y4ai9Ffwf97WWoLCiWGAHXzjkLR2z0HL3pwjMzK3a+QKru?=
 =?us-ascii?Q?5iiXkBTfITZlswbKdb1tpD98H0kxpMhlb1+pmLI582FultBTHEhsBSDq9NEr?=
 =?us-ascii?Q?nfvgKR+ZPJTSyvmaO8r9ggPdzfrrIfkgVAPW0aOEAXDN2AWS0tGgtYGLXsuz?=
 =?us-ascii?Q?YHx+AfcEVdBpcyNlm3M9O7K1LkUxw5dfxUYoZAt4sD3Jp4iX1qng5adUJZ3G?=
 =?us-ascii?Q?T/KyJI6r/u/xK0xjZOhBVBy9YT8oyerpm4YNrewf8kGZHJI2sHD8X4Bg1L1g?=
 =?us-ascii?Q?aCAcojAEuVAyveS1MSmTdm513Bifr3TweBCjGCmLxdEGk3FF/ZRszrO+TJMw?=
 =?us-ascii?Q?m4HVaibZk18Bhb0rdv51wz35OD1A1xSRDH36dsxKBVavCL7/+P7dtomYIPtV?=
 =?us-ascii?Q?+lCeZQe+ueaAPtPx3sEJpjLQVrVQZcIKUogIsQ8XhJUQWJDUGFc8d62FzrYW?=
 =?us-ascii?Q?I/qxR+4NF9FxmmwXdV61yrZCIZOeGz+gjeMNPDvbrWwWlwwvrf6RVV3LMu88?=
 =?us-ascii?Q?nVPfUyGCupRLFTed12+sT8uS3dLU6Yr0aL2Vnu1uO0D8xEpI57NdHvWsW3Lx?=
 =?us-ascii?Q?6Z0laJ0H/ztipJ98kqLHWuDm7EXgufHJe/7Cf5bkrymp7EjpfSvJdMJvY/GA?=
 =?us-ascii?Q?d6cmz6gsKnn521xtuesox0BOwIpfeQ9kE9pD6Lz5NVCBZbLaHh3XWtEvovKp?=
 =?us-ascii?Q?HEnMEL02PjwymnVdCfJkFRfnS7waCkQgIBE17TNLHdk5fnRz3kDWTF7xzmnr?=
 =?us-ascii?Q?/KBeIjev0noSyzNkSmlEUxp9fSwRpeoQ2euAo2tcIjOy72zKL1Ae3J/pLmw3?=
 =?us-ascii?Q?ai0Dv2yk3RFrIr9fRSm662aqNJSa0AaORYkDJMgwloM4/3QjFOIyVL+YwVi4?=
 =?us-ascii?Q?JGiYHvsOWvxkPTbDUniZaOvcFpVnZMBs/HrViEJhHA7980EzcCWFJjNpBg65?=
 =?us-ascii?Q?WGd9JuRMdw411XEdOjgYiw17rU6TIqY9aAM/J7X6pRyzfyDEH6b6sKN7xCvq?=
 =?us-ascii?Q?3Qco2/5nz2NCG2cq+2fON/DgjWlh769m28m/tC3GMcWFoRPqhcb+yOXt2x9F?=
 =?us-ascii?Q?Ht8ojPVvTc+fVkp0oaCJDDJp9yAk5zYlCUuB0KwyLK8UXJlgZ9/6FOcf3aAs?=
 =?us-ascii?Q?YcXPRV1mTCwhmuyik4oXQvAXjZSr/GeKICwImox9GFOK6NtGsAopDrIr3PTW?=
 =?us-ascii?Q?i68QQJC1Fx19STlXosZRwlmdLJ/QWH7QWsWNF1oIb4lIB7t/JsLib+dZ+Aga?=
 =?us-ascii?Q?u3Xg0VWhumCb7VnQ/N9QNEcvl5GV/t4gCloBNp5QJxbA/+yEwP3V5Cv8go4h?=
 =?us-ascii?Q?yvjxWCJrggoZjaiuqj4OPH/Jl4xeQMnW3F3lj+aYt1VU+94tpukWxct5tH1v?=
 =?us-ascii?Q?hdqJpN8dg1WcaR3D6qs6K05S302+1+hYP8wn68oN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8858d5fb-1e78-497e-32a3-08de3cc75b7a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 17:20:06.5609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVyfLKwe0OxmSabbikefjqJp8s6A35cAzBVIPHZ8josqtV62yZToYuLAev6bWojM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7795
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CECE6140006
X-Stat-Signature: qpi9rcheusqf1kj9tyk4yo8wj5zgfqdp
X-HE-Tag: 1765905612-857443
X-HE-Meta: U2FsdGVkX1+2ZmDi0BmZTq/DP3S38neXX2jN76HdMzgWc75V2AW3Nj+//1tld/m3IUm7ER3VGU0OIeXRVtaDTzqDjyyqS+H0ChqD3JT1zMP7zTAQtfue4uJvbySk3M7N+cLqEb3bs3rubvCsWJZE1mZ1AHqifH55vON5kYqRfnophpr9HEJsapw14TY9UhrIrWG51sAZ433UyayXx/RWENJ1z447yH8voLHHJBH5hEXms+lhDAvMZkb4955GiNRl//VlU6CPdWeGRm/6cZtuohNa5whdgfBFKvHyMFS34vj/QhPo8nKqLYRG3A3CbzfqNMjnu6I/S2HWDSW12UX5lEZ1FpGYdRG9+VDaY/6tsTnlkPwvSZuypgm9wqFfzLRk6+mcXMfIfma8fXWiqhLtCGrJd6di0ABc85G/UVmcT75R8nCPTL+OYl24ZhQj2HCxNQ+rcdYg20YzxuHwkjsdYt0AjvcNnwX07bNIc7ZK+5XvCD4uFhG49/wT4s3XNUkftmMCW7L+oaDK8PALM5NMjzrlJZAy7YYxsNePu1HKfaASg3DxXPieS/9lrda2vtRzfK2RYKbvTX+oh04vISKVBmcr5tnOglsEoTPsxGicIYbOCnjYClofM/luScXkyxxhe5fT1hfuqsrjPiD/6p1q3gJpALoUEj6KiLcbqv+ZS+JwVVtE4dZmdXktdUlPmDiim3bi7nPItu58ELUkbBUKes1g3uFuQOWexcKCoMGSyHYlHryO0BnP/0ktiGrtfZ2pO1t+F1Z1IA01/jzBFKhhvbxh6wXK4xtNkYd8JocIMRyT9+lHQRfqW4YAWIYOk69NoZuR/Hv/WIF38viN/SaUSf6ivmxYV7ULHbCRCY7vz5MsaA/YeFSaBIzIRGErGY+FBNpxTPfLCwqxoznypsHRJ69HbMd3lXJumD+Alr3TthbnD2jgqT9CRC4yBCAo3yRiI7SH0OxtF8FOkp43vlb
 F7aIvYmi
 KAfOauooOrYuOruFlpAy6d0LqSAEczWhhE/wntQWAxCH85Xse3Pr2Emou1/NdAXBITwIyDjZEzXockvJVT+PQP/jbbuRktAVYj8KYfKx5h5B4SMm1maO3nP0b1JJgX8hYWcqw8xc+qStUHli+17XvJU0+xZ1861IX47b/tf3SFdS1Bvt+T15o0L3BCOXf4sGSibNcNpKtzNmkIjDqE1vHHYgkEnY3S5B+0ZfqaCDCHCScXg5trsglgrPB9WLavfER4vGquf8gyOvjBJ4Zcr3GgdxYqZcvF3ffCffWWtPrechQZWN23manY8eUGkf+hzYkJqsQelQSvaH1YzcYKmvNCqe4jP2D+iL4tecgd19geU5EZo3htlTmDOVLoBIh9f5DkkAlxVQRjq4tQx8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:48, Kefeng Wang wrote:

> In order to allocate given range of pages or allocate compound
> pages without incrementing their refcount, adding two new helper
> alloc_contig_frozen_{range,pages}() which may be beneficial
> to some users (eg hugetlb).
>
> The new alloc_contig_{range,pages} only take !__GFP_COMP gfp now,
> and the free_contig_range() is refactored to only free non-compound
> pages, the only caller to free compound pages in cma_free_folio() is
> changed accordingly, and the free_contig_frozen_range() is provided
> to match the alloc_contig_frozen_range(), which is used to free
> frozen pages.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/gfp.h |  52 +++++--------
>  mm/cma.c            |  15 ++--
>  mm/hugetlb.c        |   9 ++-
>  mm/internal.h       |  13 ++++
>  mm/page_alloc.c     | 183 ++++++++++++++++++++++++++++++++------------
>  5 files changed, 184 insertions(+), 88 deletions(-)
>

<snip>

> diff --git a/mm/internal.h b/mm/internal.h
> index e430da900430..75f624236ff8 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -513,6 +513,19 @@ static inline void set_page_refcounted(struct page *page)
>  	set_page_count(page, 1);
>  }
>
> +static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
> +{
> +	unsigned long pfn = page_to_pfn(page);
> +
> +	if (PageHead(page)) {
> +		set_page_refcounted(page);
> +		return;
> +	}

This looks fragile, since if a tail page is passed, the refcount will be wrong.
But I see you remove this part in the next patch. It might be OK as a temporary
step.

> +
> +	for (; nr_pages--; pfn++)
> +		set_page_refcounted(pfn_to_page(pfn));
> +}
> +
>  /*
>   * Return true if a folio needs ->release_folio() calling upon it.
>   */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index aa30d4436296..a7fc83bf806f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c

<snip>

>
> +static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	for (; nr_pages--; pfn++)
> +		free_frozen_pages(pfn_to_page(pfn), 0);
> +}
> +

Is it possible to use pageblock_order to speed this up?
And can it be moved before free_contig_frozen_range() for a easy read?

<snip>

> +
> +/**
> + * free_contig_frozen_range() -- free the contiguous range of frozen pages
> + * @pfn:	start PFN to free
> + * @nr_pages:	Number of contiguous frozen pages to free
> + *
> + * This can be used to free the allocated compound/non-compound frozen pages.
> + */
> +void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
> +{
> +	struct page *first_page = pfn_to_page(pfn);
> +	const unsigned int order = ilog2(nr_pages);

Maybe WARN_ON_ONCE(first_page != compound_head(first_page) and return
immediately here to catch a tail page.

> +
> +	if (PageHead(first_page)) {
> +		WARN_ON_ONCE(order != compound_order(first_page));
> +		free_frozen_pages(first_page, order);
>  		return;
>  	}
>
> -	for (; nr_pages--; pfn++) {
> -		struct page *page = pfn_to_page(pfn);
> +	__free_contig_frozen_range(pfn, nr_pages);
> +}
> +EXPORT_SYMBOL(free_contig_frozen_range);
> +

Best Regards,
Yan, Zi

