Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA9F109E535
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 01:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD576B0005; Wed, 25 Mar 2026 21:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E1C6B0088; Wed, 25 Mar 2026 21:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136526B0089; Wed, 25 Mar 2026 21:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00B9E6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:53:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D14A1A0B82
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:53:34 +0000 (UTC)
X-FDA: 84586542348.09.2133648
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013057.outbound.protection.outlook.com [40.93.196.57])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7CB7C0002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:53:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a7VGNaqw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774490011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exxEFcTXABMAr1IcgFaio6wCiJfSUoC2tq3oiMMsHmc=;
	b=RBeB6lg1LdU61yVsG/QQLBvDDDHY0IdBxmaLhtbb6GqPBioi8jEhEuP65UKC+Tj85AKutv
	tJr5z9CIZjUPz8SiMV3V5suk+E4UpapJg3z0cxsPEyCzGY6bkQka4Qv376Vr3uqQqR/kZQ
	MUOoHAYCmbDTUAjQH5IF3suzE04folY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774490011; a=rsa-sha256;
	cv=pass;
	b=nkw2wG9n8E1An480aRV1cdXz5e6zwr9Ne8ADVk+lhULDM/dvUtAQ5tjQLNbSYwz9xULRoX
	CFmmyUaqf9tCY3jY4ktRIam0/gkwW5A6N5E29KitEUkJdgUdr2hl59mM6SZ54MdmyksypZ
	rf9h9mN0uJNqU3PIhLpBJ3vWhGoAcrs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a7VGNaqw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZuRiCdlp8EKfFAIHm3Yo9uBapAN0LeCfVeY2ZhVc5iU0qTk2ioq3z+r86PDT52n2Y09UHy37JGkt0UppYZ2qedXKi0tZK3ou5m0bRS6ouIbXwB9CN/pVpLiInp+Dsvdeus50iF2TAqYCpJJ1T85k8JtFSRjsByf78gIjM9QbBj8/bTPGD047H2H4QZC9Rtxh0mmblj83wRklay8P22YJR1lkhkf+IzsEDOuQUI99mPtRrW6FUy52w7HZ00tOpOuKzh58qpqa8zvBwnEx3kncSogqVHXnLzg9ed3elJV0fN6MpGtx1Pp25Fue0oqpkMQ7GwexSAD8y1s0bESX5K7dVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exxEFcTXABMAr1IcgFaio6wCiJfSUoC2tq3oiMMsHmc=;
 b=TqHM9rFbDGDcIntOtM+DJj+SybL9oOfuNHWZkhq7xoD5FFowwr0sytDHvRy+BQJZkLB2thGiOobBKx/03ugXHgTTeU1C8iUmkbgZgNQBghFsKZTvFU/ediyxDmZM0CzkuJMdyv/mNQyWNCqyy5pdpPpD1E2TeFDO3GPWq43TC7XxDyOzH3reMvnM5Ls8s3Tmqa2xkJAiej+z0XUOzOxglULAXeKLM5go/ydeoMOrGzC5oENKcJTPZNtsGIe3aKO7wlRt/Cf/cRt0R+GjM2JLRoTVUs+bluTG3d33VqgxUQQAFJmg0q90BjAsCbfbbLiJk5x6qX5e2WEbkbasVnrtUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exxEFcTXABMAr1IcgFaio6wCiJfSUoC2tq3oiMMsHmc=;
 b=a7VGNaqwxxtESRyQQ7rvAKORhsYsZbfR48sLGZ75YpwUkgv+zmOWl0fh7oazXiQsUWgPwVuB70CRlsDtSvsW3Xj6vIQK0rREMFDe2jAKdxafRXmtByx553P8aKV9nQeDprLtzxfa9bu5lpZJei6HbrIDUOrGBg5n67CpFgJ02K51F8b9uBGiHK2lQK6H3qAzw7FDlrUV6Ct2vby0xDM6jCXlqWoQafkkCSmlAtNVdwUFeuoKJ557VmVS+FHP/+aU2AjWBWEJQ3Tf8O9uNDR8CZdfc1na1inGJ2/9m1R1uHiLZ37N3lpTAR6mMNlINcS9pUfLjE7g48vCNh0YJMAu1Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Thu, 26 Mar 2026 01:53:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Thu, 26 Mar 2026
 01:53:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Wed, 25 Mar 2026 21:53:22 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <B1437C8C-8827-4588-B42C-147392251983@nvidia.com>
In-Reply-To: <20260325184731.791eda3b81cee4ad3f3ec17e@linux-foundation.org>
References: <20260323163717.184107-1-ziy@nvidia.com>
 <20260325184731.791eda3b81cee4ad3f3ec17e@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0445.namprd03.prod.outlook.com
 (2603:10b6:610:10e::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL3PR12MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 23c7454c-3d1a-41ab-6219-08de8ada77a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SkO+wAf6xhE6uD+uyckvSK9ao2hp1Aawl3+jy9nVG6liWsijRY9rdx76cMZXYj4DLBqzg3RBh4aXu3Ds5eJI1x+elkSWMMAIxOLZt5MY5mpcX7UMPe2VtgwGs7Bwu5aGS2ZkWBICAQSiBbQmw6909ElFZ/tfFBFDzzN24lX57P0yR00QDoV3FtdeVkO5ggt90MvePjENWSePfdJfiQcubs45ObIlH/+E39uiPFTfAf9fQakI3VpYPf0jfBHXZuYbPaSv5uFVNGKgmjiPpjhapeZcXRQSpnILcMMFxi0LqZFz9khzr90o8G6C3i/gf79xEz55x/+pqaai26lfiINRKo9Z54w8yxNwDmPgEJfousMGDwJqg2fnXw1lSCQiinaaHSE9QQsDhByKKvObzq5VrWDnJY5A9GgK29OIVjESPsZGIZtb+lx9VkSrlAiAaF1sVjoiK0GF06Po/Q2RxWk7aeIxXkk1R19rHdKJh5vv1MUwLfJc0y0UPRyPJx3/kJWxSRySvqM3loYsGFTRwaBQFlylWuPN9eAHoEtBPYefEEt5fgWuCD5MhrdaJZaEVCmLFP8leW7PYwcdxbz/UV23GPZJNH5Zi0tVhJ+tqzvC5IBb+t8zgkCR/TCMecyyeO5w16KdgZblphNMYLJ0f3lpikbPIbACo3PY5mJr+ENo514RsXccaAhFqksjrI+11+0tTmvfWFJ082MAV78spB/gikC8Z/5HDkMaCaQ4nO0KlUY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mCTWJaTWJqk+Q76cSMQL8Pee+j2ObKC2fD3gFKZsSnTCh0KQ+v35Pc0+9ZW6?=
 =?us-ascii?Q?sOTdAjjybDsn94Sc1h5ZmvkhV8bkEpFhoiaoRxCf/JpeXFFnDZeyaYeVC4Rl?=
 =?us-ascii?Q?bxCH/gOlwkmzxK3skEQhIttAeMgKeV6qX5Jy2YVT72GrEEmY1o5cX6rMlHuF?=
 =?us-ascii?Q?5p1KlkIB6yPsX6piezchLMBdMOiNL9YrfijNvc5r727MBOdsD9jeCkhNEUgv?=
 =?us-ascii?Q?XwqvQs2s6jKBQ54YQ+wVfIuaOojzvNe5ylF7OZxTGdJpMVA8Qh9PForqva+8?=
 =?us-ascii?Q?8HGqRlGjCHS2HISUHfzVznPZat6IeBXH/LHthMwrG5ZYD0DYciKpm87FDVIB?=
 =?us-ascii?Q?MSga++lhulDnXbxWbuYzdkkWV21ZAic4puZsrHvkY64GiK9zvy5/3K/ApsQN?=
 =?us-ascii?Q?qRL68k6zumN43CI0DfosDI9usY8DNwp6yfN5de3RdxaRmclFpYOs3/VIm8cA?=
 =?us-ascii?Q?zJOSKjZhEt/afrLD+lj+aeXXNolph4qIg2AdbwA/N7vN3Wez0OU3OEGhcDfw?=
 =?us-ascii?Q?yauolZ5V+d2r5by0xhUbUDIIZzeU6Lqrf0//e+BGCgTYetXAS13yHzkyYshY?=
 =?us-ascii?Q?evNxJfyUbXt/slz1kZFn3laogz/LOHmSaUvCZkvSOcj7k8SzwfwmkeDhE+fc?=
 =?us-ascii?Q?5R9kJtxwpJBdyS0B8LmHpCUrM11sW0QCZAQWHFQ/9zvtvfXMRu8YKlXhha6w?=
 =?us-ascii?Q?zbPpK3QuRCIwqDnjD8wZPG7SUkRX5ZaIovriqnS6GSCbpGvsZzgsxdhPdC26?=
 =?us-ascii?Q?n5ssLF9x1UvlA4Vg94RbnFcq4jSjl3MspIcfuyU89rMFni/qIXGmx5tHwhkf?=
 =?us-ascii?Q?jaceMiM32WRMZauHXD1bykaaE0+ckuFwvFCgov8HDo4OLZsXvUl2InlVT55I?=
 =?us-ascii?Q?vYoMR7gHa9CRa5vvsrVf0NhVcgZkhzTbkeLkVKanI1ymq8w2VpNxB38no2pA?=
 =?us-ascii?Q?y1V/yjhTn7hUNoAhfkPl0zEGFlAFL2vIZWFLQLuJWtYwt2iZ94BnBnQX9sI9?=
 =?us-ascii?Q?T7aLW/Y28Gme/4KXLyteskqukv5bP9O3gDB9LK1WOw8Hk16hea1uhEeKXYia?=
 =?us-ascii?Q?4PZbVqIqo2QOsKl/oKbEYNLRBD87fJqJCmCAZoAlY6WHYQbq/Lupnu710GSI?=
 =?us-ascii?Q?eX4kB+RNvzPB1JDEeDgmcbD4XWQVnuSDAahqf6kQtrZ/e+f4jBIwHbh4bFlL?=
 =?us-ascii?Q?l5dK9ExXYmkX9WU+LSzJNGNCwbrUdn4l7XILBucbJ0xbjCIKZ0WY/o9HxOQZ?=
 =?us-ascii?Q?FXLaoDSRyEiEqRgDaKo5j773hIzD1qLokLSyAfEQSO8mqQLfNM7y1bjVI7aA?=
 =?us-ascii?Q?j5Wv9vtSADVLqHBUEKqucFEqyLuY+LyC7/Sd/hBqxGSQP1mal7BGKW7cMZjo?=
 =?us-ascii?Q?btGtyyVSuxZlJPRDSJ0hxrdEJKGFu501nNkPpTbM23BRpZBhEeHD8c0V/bjb?=
 =?us-ascii?Q?Al9qLuN5JSkgwnqlrrKU16PsEqxGdwxk6xRs9y4KZwW2pHRE7VHgrONrrnmK?=
 =?us-ascii?Q?Duqx/X1nWqx433c0+F7SKWCbOWzUl1fHwcyYB4EwLAb1gEHF1JCTSm6zhKRQ?=
 =?us-ascii?Q?jOOgVFY0K3I+g0VkZqtGTguBKvjGrTBYdvGGXMyTftf5jLn8VuPgn/MJI6pN?=
 =?us-ascii?Q?M1QglocBfd8T0kLTNGRMtM/FGGVCXvfMWxTwJWkC93brY7RRB20N6Equo++G?=
 =?us-ascii?Q?Kh+7lTEaKjePcM6DYMa8QAoPa7oVZGrw3x7z3FoqY0mNaMr4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c7454c-3d1a-41ab-6219-08de8ada77a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 01:53:24.9523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcjGuiQVSiDWDYGFvwiKkvw7GPy/1dm5U1fENaw1VDCrhltgc51mC98xuzPy43lt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476
X-Rspamd-Server: rspam12
X-Stat-Signature: easgd7aywycej4g3bnbprd6ymekpxj7r
X-Rspamd-Queue-Id: A7CB7C0002
X-Rspam-User: 
X-HE-Tag: 1774490011-93727
X-HE-Meta: U2FsdGVkX181S7cHwZBNQlqHY25INt4b2e77O/97lmq/dXDY0SBoTHt07Q5Xujd4HwhGu1pkMkFTf08TtvYU3gXQOyEo/MVPFw79pqNqNARWhRtilUQ6oi3Cgth/MlatKBkEvsKemKNHhXojLolQr2ifMDVLp889vmWMcmUgdMi8dONiJf2bowvfkl5+u1QZWc/FNt0URytS/4825CsnNKSb3SCzu6Rs5vZyRMgxvIAfm9FixfY59LgAMCTiRd9l0j+QnbladZe90evYqGOWCl1BqVnF5aRteCqsQflgw5HlwIv7SvE+7v5S8gOHnqduDKAVnzFBzmBGzQdvvaKpzyQpENrCQeOV56GK60peP7MOtfD1+EJC2eLwtfXTIz4G56MiKA8UYVDVrfnPXsTL20joGpTUgBKRT+N5zZPtL2U8ViuH1aqPVwIBd/cFkczSS8JxRPlymMQUmACls5gmoCjqD2UWcvYXaFSoPbgOt7L80677tc/qABZHOvtu9L37U6aLvvoW/VaACsu+EwLDYhwmwqikZ5hIcQ6bmc6D6eQVlhJKam/l1cS10Nmx5zmfTHZp7UjmqdCEbMgowras/Ovlgw2rUkW7iPdLzd4wU/9GDs6Hochis5VdaKQOlfYlOlsncAa3YVzSU6edqurw1nGGl3JbPYp4I3S8RhpmfQSRJ7TvSxTsSni1ELRTxC5vOa/uJMIAJNKNYo/N5f1OEm0S7SAjP20TCR9dVKB0Ioqrg5ck35OVpyWIWNbFWRpizDivDh6Y5BFP98YheWU38R29zJzgsstHUDa2Pz/NpAGo2FmbvGD6B58sWsjdso+3z40SrHCzUXoswcXOwIRV2JilPPThx/ep0Ec+0mKshiDRrYMiFyJn0+Q9fWnx2Xe/l62TUWCsSF3FrUrTH2wOM9YPjfzEah5YgVYkACIugtSmN7v+7I/qo6oG+BWDbJ1TRPNDCKpwVW2ltxCyBKO
 S4LkUsj/
 VI0PwinU/y0k5JpsQbYQQ2ROIYcPWHQDzvg8Q/nAI4WekaTBXcWlE9mH3ruEgOYmKdCO6EWsq0g4ASUqmHwMGU0mNk1YZxP+fIUFjc98YMgr1x1C2TI3RYAZavo2RnAn8IF+nqF6t8jnWxi5DCFeDhzuNDM5Z2p6uHNmGBXhgLSRSupBVEIEit7D5FQMvJUzjaTEtiAcCdVGVuBjNa1/M4PhiJcOFF1K6PcH0LEeLBTsiMFGqX6FE+B7srIpub2OBilKOFmtNhVL2eShFyKYdcHOBCXwxS2X8gMKj5rBAQDxtXvuEBJiNW4ANJ+tapitBuswQvnyF9pPMObDUEgL4Wf9qUYVjsaN+aRpL7IZ/ATnuBq9+BwfsZkaHFappyBf3YUL4pq9rK+D5oA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Mar 2026, at 21:47, Andrew Morton wrote:

> On Mon, 23 Mar 2026 12:37:17 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> The added folio_split_race_test is a modified C port of the race condition
>> test from [1]. The test creates shmem huge pages, where the main thread
>> punches holes in the shmem to cause folio_split() in the kernel and
>> a set of 16 threads reads the shmem to cause filemap_get_entry() in the
>> kernel. filemap_get_entry() reads the folio and xarray split by
>> folio_split() locklessly. The original test[2] is written in rust and uses
>> memfd (shmem backed). This C port uses shmem directly and use a single
>> process.
>>
>> Note: the initial rust to C conversion is done by Cursor.
>
> Thanks for the poke, I did indeed miss this.
>
> I'll toss the previous version and its three -fixes.  {lease check that
> those -fixes were incorporated here.
>
Thanks.

> Here's how v5 alters mm.git.  It's quite a large update.

Explanations are below.

>
>
>  tools/testing/selftests/mm/folio_split_race_test.c |   95 +++++------
>  1 file changed, 44 insertions(+), 51 deletions(-)
>
> --- a/tools/testing/selftests/mm/folio_split_race_test.c~a
> +++ a/tools/testing/selftests/mm/folio_split_race_test.c
> @@ -44,8 +44,8 @@ uint64_t pmd_pagesize;
>  /* Shared control block: control reading threads and record stats */
>  struct shared_ctl {
>  	atomic_uint_fast32_t stop;
> -	atomic_size_t reader_failures;
> -	atomic_size_t reader_verified;
> +	atomic_uint_fast64_t reader_failures;
> +	atomic_uint_fast64_t reader_verified;

I changed all size_t to uint64_t to match the existing uint64_t. This
atomic type change matches size_t to uint64_t.

>  	pthread_barrier_t barrier;
>  };
>
> @@ -59,7 +59,7 @@ static void fill_page(unsigned char *bas
>  }
>
>  /* Returns true if valid, false if corrupted. */
> -static bool check_page(unsigned char *base, size_t page_idx)
> +static bool check_page(unsigned char *base, uint64_t page_idx)
>  {
>  	unsigned char *page_ptr = base + page_idx * page_size;
>  	uint64_t expected_idx = (uint64_t)page_idx;
> @@ -68,7 +68,7 @@ static bool check_page(unsigned char *ba
>  	memcpy(&got_idx, page_ptr, 8);
>
>  	if (got_idx != expected_idx) {
> -		size_t off;
> +		uint64_t off;
>  		int all_zero = 1;
>
>  		for (off = 0; off < page_size; off++) {
> @@ -78,15 +78,19 @@ static bool check_page(unsigned char *ba
>  			}
>  		}
>  		if (all_zero) {
> -			ksft_print_msg(
> -				"CORRUPTED: page %zu (huge page %" PRIu64 ") is ALL ZEROS\n",
> -				page_idx,
> -				(page_idx * page_size) / pmd_pagesize);
> +			ksft_print_msg("CORRUPTED: page %" PRIu64
> +				       " (huge page %" PRIu64
> +				       ") is ALL ZEROS\n",
> +				       page_idx,
> +				       (page_idx * page_size) / pmd_pagesize);
>  		} else {
> -			ksft_print_msg(
> -				"CORRUPTED: page %zu (huge page %" PRIu64 "): expected idx %zu, got %" PRIu64 "\n",
> -				page_idx, (page_idx * page_size) / pmd_pagesize,
> -				page_idx, got_idx);
> +			ksft_print_msg("CORRUPTED: page %" PRIu64
> +				       " (huge page %" PRIu64
> +				       "): expected idx %" PRIu64
> +				       ", got %" PRIu64 "\n",
> +				       page_idx,
> +				       (page_idx * page_size) / pmd_pagesize,
> +				       page_idx, got_idx);

The above two are printf format change from %zu to PRIu64 for size_t -> uint64_t
change. Code is reformatted as well.

>  		}
>  		return false;
>  	}
> @@ -97,8 +101,8 @@ struct reader_arg {
>  	unsigned char *base;
>  	struct shared_ctl *ctl;
>  	int tid;
> -	atomic_size_t *failures;
> -	atomic_size_t *verified;
> +	atomic_uint_fast64_t *failures;
> +	atomic_uint_fast64_t *verified;
>  };
>
>  static void *reader_thread(void *arg)
> @@ -107,9 +111,9 @@ static void *reader_thread(void *arg)
>  	unsigned char *base = ra->base;
>  	struct shared_ctl *ctl = ra->ctl;
>  	int tid = ra->tid;
> -	atomic_size_t *failures = ra->failures;
> -	atomic_size_t *verified = ra->verified;
> -	size_t page_idx;
> +	atomic_uint_fast64_t *failures = ra->failures;
> +	atomic_uint_fast64_t *verified = ra->verified;
> +	uint64_t page_idx;
>
>  	pthread_barrier_wait(&ctl->barrier);
>
> @@ -154,14 +158,14 @@ static void create_readers(pthread_t *th
>  }
>
>  /* Run a single iteration. Returns total number of corrupted pages. */
> -static size_t run_iteration(void)
> +static uint64_t run_iteration(void)
>  {
> -	size_t reader_failures, reader_verified;
> +	uint64_t reader_failures, reader_verified;
>  	struct reader_arg args[NUM_READER_THREADS];
>  	pthread_t threads[NUM_READER_THREADS];
>  	unsigned char *mmap_base;
>  	struct shared_ctl ctl;
> -	size_t i;
> +	uint64_t i;
>
>  	memset(&ctl, 0, sizeof(struct shared_ctl));
>
> @@ -195,7 +199,7 @@ static size_t run_iteration(void)
>  		if (madvise(mmap_base + i * page_size,
>  			    PUNCH_SIZE_FACTOR * page_size, MADV_REMOVE) != 0) {
>  			ksft_exit_fail_msg(
> -				"madvise(MADV_REMOVE) failed on page %zu: %d\n",
> +				"madvise(MADV_REMOVE) failed on page %" PRIu64 ": %d\n",
>  				i, errno);
>  		}
>
> @@ -214,7 +218,7 @@ static size_t run_iteration(void)
>  	reader_verified = atomic_load_explicit(&ctl.reader_verified,
>  					       memory_order_acquire);
>  	if (reader_failures)
> -		ksft_print_msg("Child: %zu pages verified, %zu failures\n",
> +		ksft_print_msg("Child: %" PRIu64 " pages verified, %" PRIu64 " failures\n",
>  			       reader_verified, reader_failures);
>
>  	munmap(mmap_base, FILE_SIZE);
> @@ -242,13 +246,15 @@ static void thp_settings_cleanup(void)
>  int main(void)
>  {
>  	struct thp_settings current_settings;
> -	bool failed = false;
> -	size_t failures;
> -	size_t iter;
> +	uint64_t corrupted_pages;
> +	uint64_t iter;

The above changes are all about size_t to uint64_t change and related
printf format change.

>
>  	ksft_print_header();
>
> -	if (!thp_is_enabled())
> +	page_size = getpagesize();
> +	pmd_pagesize = read_pmd_pagesize();
> +
> +	if (!thp_available() || !pmd_pagesize)
>  		ksft_exit_skip("Transparent Hugepages not available\n");

This addresses David's comment on thp_is_enable() vs thp_available()
and pmd_pagesize can be zero when THP is not available.

>
>  	if (geteuid() != 0)
> @@ -268,37 +274,24 @@ int main(void)
>
>  	ksft_set_plan(1);
>
> -	page_size = getpagesize();
> -	pmd_pagesize = read_pmd_pagesize();
> -
>  	ksft_print_msg("folio split race test\n");
> -	ksft_print_msg("===================================================\n");
> -	ksft_print_msg("Shmem size:       %" PRIu64 " MiB\n", FILE_SIZE / 1024 / 1024);
> -	ksft_print_msg("Total pages:     %" PRIu64 "\n", TOTAL_PAGES);
> -	ksft_print_msg("Child readers:   %d\n", NUM_READER_THREADS);
> -	ksft_print_msg("Punching every %dth to %dth page\n", PUNCH_INTERVAL,
> -		       PUNCH_INTERVAL + PUNCH_SIZE_FACTOR);
> -	ksft_print_msg("Iterations:      %d\n", NUM_ITERATIONS);

Removed based on David's feedback.

> -
> -	for (iter = 1; iter <= NUM_ITERATIONS; iter++) {
> -		failures = run_iteration();
> -		if (failures > 0) {
> -			failed = true;
> -			ksft_print_msg(
> -				"FAILED on iteration %zu: %zu pages corrupted by MADV_REMOVE!\n",
> -				iter, failures);
> +
> +	for (iter = 0; iter < NUM_ITERATIONS; iter++) {
> +		corrupted_pages = run_iteration();
> +		if (corrupted_pages > 0)
>  			break;
> -		}
>  	}
>
> -	if (failed) {
> -		ksft_test_result_fail("Test failed\n");
> -		ksft_exit_fail();
> -	} else {
> +	if (iter < NUM_ITERATIONS)
> +		ksft_test_result_fail("FAILED on iteration %" PRIu64
> +				      ": %" PRIu64
> +				      " pages corrupted by MADV_REMOVE!\n",
> +				      iter, corrupted_pages);
> +	else
>  		ksft_test_result_pass("All %d iterations passed\n",
>  				      NUM_ITERATIONS);
> -		ksft_exit_pass();
> -	}
> +
> +	ksft_exit(iter == NUM_ITERATIONS);

Simplification based on David's feedback. No function change.

>
>  	return 0;
>  }
> _


--
Best Regards,
Yan, Zi

