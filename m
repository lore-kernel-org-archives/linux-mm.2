Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85930D1118B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59BB6B0092; Wed, 26 Nov 2025 11:59:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A726B009B; Wed, 26 Nov 2025 11:59:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7C26B0092; Wed, 26 Nov 2025 11:59:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6A66B0092
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:59:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 543C613B963
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:59:14 +0000 (UTC)
X-FDA: 84153368628.11.472ADF3
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011009.outbound.protection.outlook.com [40.93.194.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C5E118000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:59:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YanLIyx1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764176351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybTKFCtyy9SeatZByL3QeTW4OO0ojjhBj1vvHELIUnA=;
	b=ESNyaIsA56iG/JKpdPjuV6NeLFLfH0SudiDvmY7JPt26Qg1bOPpUfsnzhAMFArSVqFCq74
	XYoUtGgaF+afHLg/wOQdtXp2POKcxvhplL0Th0Ys/1/yc4mweJNl2huOLzMW/V4WdnQpXp
	uYQPiWkVcd6gLM7hzUAaCLGwwJe9T7A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764176351; a=rsa-sha256;
	cv=pass;
	b=7liZs+tPUD3HHEO7bUbHv4OQNN4kDy3oTsXHdBGN44YuKsBILOyw12ckNSNXspgMVy4sn7
	wYI5tsIK3i1SzqqTJfNCcv5K9PbEB2TN3PVUiTsOnPqhil704gt3k9C2Iv32wrdJR+MRwd
	gyDIZPdUBYd2aNO8kPtpjFJHMPZYQnc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YanLIyx1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xaz50GocLFFXaS3Sq7kQkM8dxU/DUy5dRMfR4C1zpwoxx7LSzY8q/aQ+a8uaeT4+bqF81mh8m07vUcYewg0WjaLFIjZxH+mH252Cr50cjoXk5UbQcS2nZmrh346XDQ9yLm0LwqpshCxyjN/tWIOVzO//lCYnzKEKi6kecXbEao3XZFdm6W55J1VUbozi/1NJ7rGDWUhEbPw0SQfy0d4OeRbaGtI6I32mzkJCBdAIBmeHrgh77p78YF5phKnQIYEkv3acFVGJtmXOBuqOAwyJTkAWqkIXmQft8AQNRSxaBGgq+UvehfcY7TSP9f4BIw21xVpjBUUKwLVSxkmOLJoR4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybTKFCtyy9SeatZByL3QeTW4OO0ojjhBj1vvHELIUnA=;
 b=VVqNL7mUSvAYfEE6CWDOOU9pDibLRx8VkKDOFWqCekQwJXhGXim70McfgpX4CWlGzMT9s6nJVplJ12ohNuuwotOlCzT3oZXzy5jh/xWGmsWN6uiOsADYi688YbpklpMzWqsSqA6Dck6Vfu6kjYE7z58Fq7+xaEsqVYhyz5skqQLmEMG5ugQ6yuqynhnmEGrsQMCcTlY/gZrdxH3LZwqrBkwxVgIkQPcwe+9Zd8e/8gf7jJnUI8hLr3ZqWjJIHUlaRIqGKyNpchd3u/KlWHYX2F1yPoSCupu7Ad6QKRNnrMJ59ESGELMRJMf4O3bT2ZqbpwOB7rWZNzmHlQgpgsqNAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybTKFCtyy9SeatZByL3QeTW4OO0ojjhBj1vvHELIUnA=;
 b=YanLIyx1Mu1gJJz4KeQhDoETd8sclzH6V21LaxJqw3y/ioeiS0O+aX1sz21dJC3fPSkPUuRVIeCr/kFw6tv0Vkx1UwZWWQlGNzhXQo0vRjhAt0u/8fazlSB3Jmuwb46MwnoZ3HfaTkusq0R5fdysOIOREtsCpkyLKvOOOjnzbsLnp5TyjnkkoGZeSuxFvExsFBr9Ko/1AZfMIP+eiv0lTxZpcde9E47MgW21t0IXrb63eCza5c/0L57XELL9AnNOH85JnRipvB8NpGn2Vhkh1l9hVe0xwEHMF6FPoAqcan5ykU+1WfrzQDDkItBUuQdYyIR6UvB1duAfcjBJcEzQ1Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB4055.namprd12.prod.outlook.com (2603:10b6:610:78::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.11; Wed, 26 Nov 2025 16:59:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 16:59:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
Date: Wed, 26 Nov 2025 11:59:02 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <65F47450-2658-42E7-ADDA-DF6E24066AFF@nvidia.com>
In-Reply-To: <46d5090c-a6c5-41de-91c4-dacac58e1f9b@kernel.org>
References: <20251126035008.1919461-1-ziy@nvidia.com>
 <20251126035008.1919461-2-ziy@nvidia.com>
 <46d5090c-a6c5-41de-91c4-dacac58e1f9b@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR20CA0048.namprd20.prod.outlook.com
 (2603:10b6:208:235::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB4055:EE_
X-MS-Office365-Filtering-Correlation-Id: a36cda71-d68a-4bbc-bb35-08de2d0d1c1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XiHuh1+c3qvx3oDN50VoJVWbjourTzfLS9VPxOAvjwIph76KdcgOIU7hg1zn?=
 =?us-ascii?Q?8e1PyMhW4lSDRc5I+VzCnHA41/VjrqvWNEFIJ3xh4NwjodMDp/5UfLgXkZB0?=
 =?us-ascii?Q?eEtADYbIfjgJPTjyJ5hbYSEnRLglySGlfPJ7ZX8ves8OcbSrXQ0HTE3nwHMZ?=
 =?us-ascii?Q?IYY+MlsWJ6Ul+eiYaDZNj+Q/WCL4hEZAxakJEwl89mkelLLuLz9RcrhfEGmx?=
 =?us-ascii?Q?LGlf2cb6lX+N/THCZEskfgc+yw+nMBCzvfQX+8456joiozz/aSq2HaysSVe/?=
 =?us-ascii?Q?xk0TOf9ewZEjXbhChj+d6Ub1XoQzSKBxmN/nO9zwvBMr8VrPxSOKCyNnJQUk?=
 =?us-ascii?Q?9G2xJbsvrvR1PsWfFNJ2zOHmc6OUxoKGxFaHHNhIqQ2JdqlTd+DPCbdLz+ZO?=
 =?us-ascii?Q?pqZb0S37XMZz2Pem7ulwUcJhVOTJqM4w2GOmRQOGZym5NJb8PDGkfL7VuDv3?=
 =?us-ascii?Q?6yu8IdYi5wEOGpFhMB8qAaQwI8TtFZLhHvtELAq/J9ZNdW9c6Zh243WXjnU9?=
 =?us-ascii?Q?OAxRVfTOeK5B8h6ZwS80KkBJ16A9JV6nEgTuQjGxYGUkZD/JpoSPpitHlPmA?=
 =?us-ascii?Q?iCcey9rCM4oPSFYONHn/E+5UxxRs45pEeqbZkLaVkKuhFPQeS9RkbxxnCdlI?=
 =?us-ascii?Q?aSsFVviIBakPamLS5Myk+e+C8Q+0Zx/hVgR8LuKHkDO1ktK1I6CuR6KvqkK9?=
 =?us-ascii?Q?9PY7TTTZWe7vTxk2Q8N16xlvvkHobqePwNmkyl31DuF7Ok2c1S6KIhy+dO1Q?=
 =?us-ascii?Q?2QBtYeoBjSYG2/Q6hKQzc987Js9OWrJtjI3cTbXExyWC7H9QURSs1f4IrZes?=
 =?us-ascii?Q?+amn+etXm3FK9abwGn7xdR0jTru9VFDNfoBUZ1infBSNR7l8qzZRPY6ExfSv?=
 =?us-ascii?Q?BhDI9d29inyVOsMxpMwa2d9AvmJTwTl4whv8tcHHSncyiZYSJdvHSzJOPLRW?=
 =?us-ascii?Q?xOM+r6EkS64zD6w0I3QVDf0imA+5SI8lyNpsP2FP3tmw+MECdXsnWlccsXP0?=
 =?us-ascii?Q?5fNuOAdf45g3miU+kShRQrgh4FahSMTYaVm9LI8XEIWi5n//c5ejPWaHnz5p?=
 =?us-ascii?Q?8Djk2ucoXvW2SXtUVEhPZLJoHPrli5IIAsVVzGHkD8+dkXJWDXe5HJTquk+N?=
 =?us-ascii?Q?oM7LUWZfLqodUXsqF4m/STonixEfwT69aT4WYm+e3eQrXXz7CRGBmR8JO8SB?=
 =?us-ascii?Q?nC74ckwvN1Ea2sVl2PwVLjUjiYyDNLM+iXeeS8nIvKChxWfMQcjRsCcgHdCY?=
 =?us-ascii?Q?NqjrpgqcO2eTTPEqGnJRUWAHJH6Jy8fgmH3mDu/AM7w0J/Gly25/AF/43yS4?=
 =?us-ascii?Q?uYSsKtBVhAe8Fz1duHCVIF1Ff7T/IG+Ryx0q7hPeL2LdAPByeriHRgQAMpaT?=
 =?us-ascii?Q?PfSb0jEubHcs2lKCfLY27fKw8VOwXaEYR/AXqEMYs6Lcc9PBaOEPkeVmWCD4?=
 =?us-ascii?Q?LtqDjhw4QzeBMNVB1OutGXDb+AiMPjRi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VnCeBgfza4o7w7mZWAl3+IvylibXYysEzcuprpHlWHHsTjjICHzwck6fyloD?=
 =?us-ascii?Q?BLjyQwOdW2yyhroKYptN7xEFxpsJzsz7ieKjasOe9RekkjAaKbkGRWOPoVBD?=
 =?us-ascii?Q?cFnRKxbZSdhgMU4L63gdouDj43t5n25jqvjYvMRgWNvWk/QrAoXBnZENbArh?=
 =?us-ascii?Q?zP3x17nVj2C6w23cV/Kr9eh/sLZHua0FEg0G3ogbBxF1RSzNSNdB4WsOWJEQ?=
 =?us-ascii?Q?Vi1TT32Fqm7E4K7c/H7pvJ02tZwshDP3ZODocmxB+2sThFZ9UA1YtuwGbgnZ?=
 =?us-ascii?Q?A0nuD3sMP+JnUJP92ZWQCglqoqoCssYevraNpglorr5TLFnnqLAIL3hCUb6o?=
 =?us-ascii?Q?xS0ubCqAYOx5MdciGeHFNtscKbvuBLKAbawMOmpUz7xG8uKzTwv99WA0B+VY?=
 =?us-ascii?Q?yHUUkUPY5GR4bC6PNUbMutTzqdAsk7AdrP8Qe/22bgiLxT5MfVFySa9upkJv?=
 =?us-ascii?Q?Wxk54IUFxGH9Uy5AqdiOOKI/StjxSfYA9SsvAN2+taqbivXxWcO54ICMweFQ?=
 =?us-ascii?Q?jxib8MVwO6ZEm39vI3sKEmPKI/EqRsxYeTaA1DRKtA6t8rz70c9o4IEDjZZb?=
 =?us-ascii?Q?7QlIT+6XSjPdrwoAPFsbquM7YUqBBOSstBRTrOd9TL4LTQGacMaHPGDAuIID?=
 =?us-ascii?Q?m1Gx/9Gud9YN70wxjhNezg1BQi8nDk8wZnNYnPF/MHFYCEvyM9niLlwIgcGg?=
 =?us-ascii?Q?lcz2NvyibpdpISYfSq0gx4Zw7f+ju4l4HRdRsRibPHDzyluZo9gleJyhZDeU?=
 =?us-ascii?Q?7dWAsi/GTOL66RLj0OxWgGO0krCZmVNq99PWfr1b15bi1DQ18wvS/is+/tYm?=
 =?us-ascii?Q?fYy9KbgAHQ01RtMWQval9GeSv3cyfHhL9MgiU6jNnB98CAFWh8ZR9YCf8gQQ?=
 =?us-ascii?Q?u1cwxHyYMZDbY4Z3rNCgkwGIayE2wUko49uvO/FL4HsLpvpIPsLQExPTCapH?=
 =?us-ascii?Q?HaHGqNaXwnfHigUTZ7XFrtPjxzXy8Oz6BPDmtXL9lCj+NdDtcN8F8A0vYL/6?=
 =?us-ascii?Q?hcR7l3Zb/sgpvfOu6Bpilw09+L+zeCXUEm6p3JwNNUtfHKLpROTBxJMToCug?=
 =?us-ascii?Q?ZbldnG5pKdDcIKmpOTDa4egL9nVZ+PcitSCNe6q9fiWxt9o04MANpFxWbcF9?=
 =?us-ascii?Q?ZIPbhkbhwLWItDx1SkQjLmmHUv5qGgj0xdRX6m73+3aObWzg1WUZ2TPIr2Gv?=
 =?us-ascii?Q?kl/wZz//wsK0vTWrwWonnae0SNEmAML5uEsZy/791JtK3xwKZQ0yEGQ4r3DB?=
 =?us-ascii?Q?gnUQFFrb2ryJmNH3ZYZ+lWHr3VTGefaAqr2n/WovMn2VYvSN8bdidx8v0ycX?=
 =?us-ascii?Q?OyXZbITP6N9MSioT4dD6c+hq/JvLajNerCir3WVvdfeRqa4gVA19knB5yB1L?=
 =?us-ascii?Q?wr3zH8Qa8fT1gYuzumDnaaeKtnC+zpN0Zc8o5Jz7RZoXlhRQhLsZ8SNJjnfO?=
 =?us-ascii?Q?dObFXDBViGSnGs+o5BVcE1smny5B46ry2ytghcvw+0SU4/cJBnz/d6JhsndG?=
 =?us-ascii?Q?nsQ1lo1TGhyp4WZbtvKx9bwTK5EeWO382GTwTFW9/yW4heb2kmcwj4rcjhE1?=
 =?us-ascii?Q?41m8ncZJCm8LPb9Y7M4zHII6G+v9vMdv5dCZUlY/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a36cda71-d68a-4bbc-bb35-08de2d0d1c1f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:59:06.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O6twg/v3po+NT2bCu+p48PLKfW7YwrbROUnJ4n8oiKZKmEAl0EwGcThzY83hstg5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4055
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C5E118000C
X-Stat-Signature: x5grd4y7758qp1efczyuxi3ooqgtx6nn
X-HE-Tag: 1764176351-121098
X-HE-Meta: U2FsdGVkX1/GiVH5F/ZyPFBgx6EYjLyu/jXu00J1EP+gRoZH2c0jDwngB6KwPOw66UIGwwHZWIgz+pdbkyPQ/ZqMVAt2xNGEPdMJsPHrMtbf1GIcZrRYn2InChrnH2bRq/c8WuWFwpeaOt6RyX/pArXSWn8gwWIxIVtLerzGKvm3x2ohQY+EyoLj0mwcivtN6SED9mVmlZdD6S2NZHymdiA69vFahukrOEbPRZ6NQuvO/FEUcfebh2kniIO6UiLhk5NDFI8Z880DLmzKbYuYelXc6l36xA4BJsx3uKgA2iSZJzRWx4NrgvXMwvvVbYrFNOK2Y5ipFqlku4XF0FRir59VCrDg7fXfN4UwVEeOWVFSPxIGvQPdwORjihBxVozUbz6lHc7aiOxGbzdU50+8+TMua67eFl6eijvze68ng/hp8JJ0P3vdmhXGO1CdDOAMByMlYOA1Rl16PuToOZZTuorbd+wekgeittMZSMBcBDnCWB8hy7XgEunO75b7DYRUX1ZsNEnj5TLqGGpEK61W5GFkX8c1eePYAXQKivM7ycjHn95wAS0TdKXLpf7KELDWUWk0Zja9HO/kGmjOjMlBhc7zn88cnBVMKtTD53Teh3VT1F3/2tjA4lMYyA/NcUnNpfNOJ0cp88YPjMtPMdMumYE/kIr5wGWoN7VmBba+683imhideSz31GcpMd9RFXNOJJz72thC0T7Jg3x9a+YsJGNWWX9JKUV4fH5fao2MuI8cwNPlcAQIU2mtoBviJYaWQgkVyCtJLg0z/oqt6gU5cKAOsFHp/8r3Mi9VTWYsitd/LkuagguXgvJqzbvCfBZXMarS3nRMw4YHJU1EOcKN5YfE2pGj9WjnAXYhXRf/0oQhaOfnpx5RgRIDQJiiy/G7R3DGS+T0WkeZ8d96NURzHmWRlWnYWcEee/qokRrFkJ6Ahw7iDC3h6lmtlH0Lv8xpo6TQpkHaV+/onzIrBOB
 YkLDOyjy
 ceKjgMfeqp7yg59U+wnEaSk1EuNsBRQ7U9Urz4CvYeVWl4xBJK/aIl8X0FhBaTghmxFIgwO1lSvwuWaaTzHK1A/+KyALk6I11r5GMJAuHVTQVlDwx4xb5BNvbVNQNrIcL8st5q3hKvX0zlmpe4p79Zi5m06LqlVO7V2kPtLp/Y9eaHfT5jgCVVebHmWMqH8t+57HXuKRwP780Yb3rY5hsw0vSl3CAMD5qYuX/qwa+5R9+VZ6HiPFSoyFgNrfCBoHOMveerf8jDEvPALtJpHNqNaJiCXXCmrkfYDz/vmI4WJUw2GviZ4XFnNgfwyG0ONtu2quOpsNsmoZGC2TLPIDVXOd1y9VxhtBI6UiSYl/3n/+Pqssb4BXPZqDnYr37GUavW4fU3ZG2zyBRSkMTSs2kYZCFjxx1OSSH9b5qUwyyGFB7F0uBiCFrd3mefPvsGyPyNL9G8ar28Vh3QADGkWbaYyakwybrsK2OA2T4lvZhN1sV78HTvHGOMrXcRCeYEYg4B3sb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Nov 2025, at 4:54, David Hildenbrand (Red Hat) wrote:

>> -	/*
>> -	 * Folios that just got truncated cannot get split. Signal to the
>> -	 * caller that there was a race.
>> -	 *
>> -	 * TODO: this will also currently refuse shmem folios that are in th=
e
>> -	 * swapcache.
>> -	 */
>> -	if (!is_anon && !folio->mapping)
>> -		return -EBUSY;
>> -
>>   	if (new_order >=3D old_order)
>>   		return -EINVAL;
>>  -	if (!folio_split_supported(folio, new_order, split_type, /* warn =3D=
 */ true))
>> -		return -EINVAL;
>> -
>> -	is_hzp =3D is_huge_zero_folio(folio);
>> -	if (is_hzp) {
>> -		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");=

>> -		return -EBUSY;
>
> As we are changing that case to a VM_WARN_ONCE(), is there some path wh=
ere we might trigger that?

Based on the git history, this check is added for injecting errors
to huge zero folio and triggering memory failure handling.

>
> I'm wondering about the split_huge_pages_all() function in particular. =
I guess the "!folio_test_lru(folio)" would protect us?

I think so.
>
> Apart from that LGTM
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>

Thanks.


Best Regards,
Yan, Zi

