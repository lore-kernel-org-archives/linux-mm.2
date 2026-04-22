Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B62EF9EDC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 12:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5FD6B0088; Wed, 22 Apr 2026 08:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6772D6B008A; Wed, 22 Apr 2026 08:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E866B008C; Wed, 22 Apr 2026 08:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDC86B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:30:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E439F1B6B52
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:30:31 +0000 (UTC)
X-FDA: 84686125062.29.B354A03
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010021.outbound.protection.outlook.com [52.101.84.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23A6C180006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:30:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=brNeWUie;
	dkim=pass header.d=arm.com header.s=selector1 header.b=brNeWUie;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1776861028; a=rsa-sha256;
	cv=pass;
	b=y+BIBMft+ZTFZlTWck0vzyhrUObbXSK3zH0AfNmFRflvrANUslIarZrDgyouRFkhlCsDUY
	dfgcMSSV4+RblH4ODxKYjA3U250c2Q5M2t3UDWcE/pt+FIiWTnmkIDclYtn+gtcRTE8Tj2
	zPcTavrq4VdP2tPa76IEuC3hxsHT5qc=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=brNeWUie;
	dkim=pass header.d=arm.com header.s=selector1 header.b=brNeWUie;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776861028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhPGY05YyERVYaky1RS8ltZNZE9FL86zce6ssfJ/Ldc=;
	b=QLo5RhHRLFxw9iseGxmqCtEP1rclp0zprCkjQ9P+JxShYIcjGN3lFHy25iUeLf85jjnQQg
	Vr6cRyFd/cvfl4ywL5w9hJx+GHj8VHpXYp8ZOmSlBkrjrlRbNeCEvI5bgRUzuToR6u1z3J
	N4246h1jeTvjJjOiSknT+tQXJFT3sG0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aAuBJ4Na3dvncqdNOtiQLKn6Iw6U4b4oauR2i0ezVAO0H1f98B9wMcKdWW+bC9CbI/OHpsxABvniTcDCXbVjsq/B5RnoDhDCSa+705lPj7v7j4ziW14pN3cqzuU7mMFyzpqX0Rpt/K6nTEFOg24ZFlFSWUAIh9HNZepoX1buhX71dgBoQ9ZelCf3psPuRK/iQa9dQi/BVeSHBdyl8wjknxx9+xjesCViyp6rUPEbntiFfsIYRBMV2uj5hD1qp/pSIuH+x+yTR8NzgRTXbec3CcaavwMagvQ6r1W+PzqdTANKC/y6YxnZzkdKlaSII4RImizllAMa1ecN3XULKbMxCA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhPGY05YyERVYaky1RS8ltZNZE9FL86zce6ssfJ/Ldc=;
 b=GN17SPIpLSdREdxEvdqmQ2KDqyv3l1CRJJ97E9zgwde8puOwmxCUARHJGSaswXuRLH1CTFwsCsXI3GN0YeCjHGrQMN5tQuNKXSWE6z8ceqy/mTTpmwiQiofBFBV9pF54EeoRV3XGGhUjUyQaRhOy9iPF9vt3bLrZnd1CkJs6vkRq3X7b+TOS9RJJ5sVRVUEFZqkGcrrcHo0R1M6OeeN/Bp31TZ86NrNGeGKWo8BMRZgvi+xOZqc0ifB3IKPN8x5cp+0suTyDg3paYOu4iMBvB1Zz5EB3ygHVEGbduXVXSzRSQNpYD6Gs1gk+fUOQGH6Tv8rx4+JSkprRVoYqBOdNIg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhPGY05YyERVYaky1RS8ltZNZE9FL86zce6ssfJ/Ldc=;
 b=brNeWUie6HM67eeqjp4QFPRPkuGI/Ye4SYiUt71E7gsn3OfT2yrHGa4NiWYi8XsulJXbSrrpF7GG4lYYuTv93WKPXnOAcjFHCoJnHNTvy8Uos6f00zo0lmtytdDuKA7qJLp2hy1BjDVPxgLq7WpXLWI8djk+sQb1HqPlH1d01co=
Received: from DU7P250CA0001.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::23)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 12:30:10 +0000
Received: from DB5PEPF00014B9F.eurprd02.prod.outlook.com
 (2603:10a6:10:54f:cafe::b) by DU7P250CA0001.outlook.office365.com
 (2603:10a6:10:54f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 12:30:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9F.mail.protection.outlook.com (10.167.8.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Wed, 22 Apr 2026 12:30:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGUmqIRdtQLW2Bntz0YJl+tRRTTjzwwzQH2GcTJHDgLj3b3NNA3kTYBZFuTHHUog1H4wK6rNJORlFHej4BOltajc1fMfYpcvubBHgL79LNJmjZinLdJbrmj3bfVl+axriQy9fGl5tR26wKDLjs97zZSNzLA0FCKXaQCKLozoeHgUpax7opdaE+yCmLVNKF1f/y0WQGAKB4DtL/M5nfNM3qrwavMFUzAYdx1sfKq/IPZ/PxzQexATDDvDP+HpaoZWvwrOwwZqBGIYLAlrtZLtUjgTY8VTYWk0uHLI3YAz21WFaFOPGgQzw65HJLTebToRQr8A+MZSeun92gH2/mapDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhPGY05YyERVYaky1RS8ltZNZE9FL86zce6ssfJ/Ldc=;
 b=IC6rOen9qJ60hNw4i2uKn+NhxkHUNVnAQ/AcwuaZGcwVPCLUn2HLsmbe1Aw+Wqgmljp6r85I8eE8LR1CENHSDXPSr8uVEs3/wZFVh5r1WeMvv/q3UaPTN03oDwLdZKMuIUnSgIDWD6qS7IYkpS+T3Yv0VquWfZ6Usl6X0B4ZTZnuxFTggNBQgSalJ0gUrNF7MoYMNU4fXUmlYMfSqptxyKqvGt3Wtv7IEUdN//BBf4zqvF9oDcCO0D6BJblOiA+N5bNICdu6uLtEIpnTiEY+2+DXS1sAJvMXL8x37Ow3R6XQZZE/DGVm+YA37JCg+iJ5yQYt9PA3Vg/KCf4GW6kmNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhPGY05YyERVYaky1RS8ltZNZE9FL86zce6ssfJ/Ldc=;
 b=brNeWUie6HM67eeqjp4QFPRPkuGI/Ye4SYiUt71E7gsn3OfT2yrHGa4NiWYi8XsulJXbSrrpF7GG4lYYuTv93WKPXnOAcjFHCoJnHNTvy8Uos6f00zo0lmtytdDuKA7qJLp2hy1BjDVPxgLq7WpXLWI8djk+sQb1HqPlH1d01co=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PA4PR08MB6288.eurprd08.prod.outlook.com (2603:10a6:102:f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Wed, 22 Apr
 2026 12:29:07 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 12:29:07 +0000
Message-ID: <815a3c24-f1a9-4a3d-a7c5-eae80621bbab@arm.com>
Date: Wed, 22 Apr 2026 17:58:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/53] selftests/mm: hugetlb-vmemmap: use kselftest
 framework
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-9-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260418105539.1261536-9-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0041.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:175::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PA4PR08MB6288:EE_|DB5PEPF00014B9F:EE_|DU5PR08MB10466:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e29199a-8148-4017-cb7f-08dea06ae552
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 vK4uEBWZZqy4Jcxxj5RKo5tn92LBUgjf0bFY01PaN2hIYE7y2aPMWn3inGgc1DxgynpjGdasr6EiDbcDNfQnuSqw2HUFrlf8/T1ov2PjXHcgaj03hXmn8yw1zCYPruueBryavsfBKMxBFRUGH9Hl42bKgpjnX30HITyNcJJ8y2pPjhSp3Bfcrpv6wSTUB9dQRD8uYvzXlMaat1Ap149gCaJkboQQUk3oA2yijj9GNLBkLhhR7V5HLtttuexpnPkBM5Y1tqLJ7Nlm1Yvyid+oUVA3HpW2ckOtL5VJJ9aglTdCYQiz8JfJXB+SQ+r99Acjk1VTV2CEQniJXn7Es3R69Xed4oimixxqYWCFSVrGhOP1s+nDcUvPD9U8BFH11b3ARSOu2JdMpCaCGprMJk7JIbIfjyFBb0g5JN+xMm8GAq4dwDPFZQ5tEf6qaLBLFcWb5/w/JZW1o+l4Wq3BqMpWInXSEFtMoNWzYNy0+wHSIv+ar0CRYF/6SK42/7aPgx/WuxfknXcEzdVf56MwmDSPDFyACdr8owGpBocTBUAB9STSdZU5VwRJlQw1X3nTwJ2iaMPS+nuczPhgNHUOSrWa1Y+4YNeb8dZ2BgYCjcxZLV7itR5xGSPVIJ1scJL9yrKEGvRR35twpkbhSeI69h/aHwclT2TkryF065FDppdySu+VeZSCe1m0BaKvngbpOcpLbHVqTQVgCCsfnnfBxaQtaY3DpMW519Em6z2tsL8cALw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 NXloo45Ua429H/1GJqvHVE5wlRLGKWXC++1vgSVjd/p3NP1b6s9IJ/Rsr7gEiQYslPlZuLFyrFV6J82i1GFnNeVoPc/Fr7bPye00bygV5dASqCEdpjF/ZY4txKZO+YpvfAh7n5P9vNnOml+jKJEU/JEiQCzlWDD5i9EKAWMHP2L69bKvd4d5kkCGC+wPWur5pzGp97IziGy2zBQYjXd0Efb/zqnob3eaZoqyzzgq4EvrcKtobFJLiAkzn/XxJ8uJzAcbx2p6HN7mKIsjCN5hf1f2SFp64lpY8gclK7ZnlzSfjDvC95MaluDR8mzDYUbi3jQIqX1DYLruJuUEXI1arw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6288
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f8afcfe8-4ef6-4ab4-50b8-08dea06abf6d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|82310400026|36860700016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tywGEIN/DZ9Ug9eFx9OgaCCgykdLtM+93WFg9MlQ7+iO2hDe1tj3LIazGholQi72TcxoelfdTUPYaubgWWIkOlxfp06dtCL/V90nZW/B1GUmk5wBiaTNDsAEtiC2uUaS9oJPiIjGdb/fZMRcBR9gv1E4fJseFsvMoHt7jZ8ojBw4eHj7W2vjkDLd5VfJUYkO3sUkpr7HdTiiUkI9WyVp9lc8we2UVw5P5IvxZRUSZbLFwvJaRM7waUI0YRPBgZiGzZ7KEnbVVRMLRc2fcaB1kT2ltocW1ON0SPBX5VvHcUeCUemyak4XdQBvUF8gZyUP4dJS6c04gWpaeBbTUViOKDFG5Ma6GEWrpj7O2Loo8yNP2epTvZC+LDN6dV0zuUG5QTzt2CLGfqGllIgfNEA2JfloQM3+DT8yUc6Df2QyPCSTlpaVYjHHLNVZNv1qf67K5W0IpevwYGlkeVeqomfjM5vuGli2ticGcRlWYqotwbDTyEmYDFaJ5felX3JI2lT/JKulqVg2aWcZkrv0aS0KwNY5OIuMk80SFgiq/3nz7mXP30qEX1jzY/a7gPiKjCr1F9sBHA3vVNcjg5uzJIjpjdNdoSFCjpANu34p3OXUGVHekLamreqWle42xXKymKNVsdVKrRkp5d7C5oiZk2ytdmjLf6rIp81lf83DQSjYnMVvrkv4xssO9RLg9mNmRafZXkCalApLTjRZVof2HGO5UDlsGfM1cXE3pmLOWnRR8tKQF7seg3brRnynjJSk/4nWwup9aYRwEk9jH9tCy/yqZg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(82310400026)(36860700016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XXvCAjYw8ArMLixOs+NxR1gqmWYpe1JHTC2gNAU8fcFAa/aZZL5zfK19lH1t6h6DrB6xaNpNjzpAR3voEti2xJASNju6AREIUPi+g1jv1gVnzMJOl0LkLy3j+bg8HPm86uv83WUPSuOwhuLyREvCzt8dt1XHWxerbGFccHuUYJRWOuVH4hX4BQtSNrSkiXNBqfsXzlsHLEYYW6z+D7WImMvQ/oXT6rciD/yK8NYNFcGOXvxFgz8kVZ56EZj/DD6DOYiUxb9HsbpFoFQSuhnS3nsx6Ir0Bk7tA2qB+6lKjS+qhh2yKSr1hocGmHHU3npj92yz2VuCIMr8fi6aoL4vvSojqoECyblIPiiULMhwPjemaSZVvHfyXxwXjEP4aZrpLZjDBlE9r4sB6M4z0+lfCtJli2XiPa1faur5VNBIzsKCZh3Z0g5nHuTkXzC9lBSw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 12:30:10.6586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e29199a-8148-4017-cb7f-08dea06ae552
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-Rspamd-Server: rspam10
X-Stat-Signature: fqu9fp18odfr1aowmd5akdc1r3uncz1o
X-Rspam-User: 
X-Rspamd-Queue-Id: 23A6C180006
X-HE-Tag: 1776861025-485904
X-HE-Meta: U2FsdGVkX19bXKXj3cBfqDdnwqYLk4hsv8hhQOUrsx5b7pRGx+xb/nUUU5cpIElT5t/fRKUA5WeZnnYzloK9vKR7tNjwaxNu1LaCvvTVj0wSBahcGvebvLZJlHkdMri3BATKXYGO1vQ7aqxHuv3H0cUSB/KJwp6YI61tdWzZfhTRK/hgHF28CK/moYobMnFCPKhS6aWSc2jlH8Lw+Y9a69fVyUbaa7JOBmqwTKKtME1HHzkMbt44jhiwMK523LllWFR2TsmpczSzkMKfVVfyomF5ldYiOj75d8iLZv690Its868+PUdbPN3xn/dFInZta4xiW4N2rIy71qxSpNsIvUoqSo2gcBdKKuWYAGcGvfLcVRfOC4UzblM1fmIJoJ1xOSys66nJsNUCruhCLMAiVEtuvUAdaVii9YXDejRFDd11WHJ/fm+Uu/SgWbqzNZtKA8ZjT9H9KJ3hSN4tJ7sqxDtziyX4KYRQtmjm0YC3O5xIQrhqTsNY2BoT3vzgtS4deR7kdj1Vbua3Vsg5uZQIB0E+YM86Fun04gWeBcQtg4+pnpVnKvTWS3CWYZyNsCE1IFIN0vhSMOwQ9yXZFTXlsesQAU60F7FQnym3cJ3GjC6ahCm8O0sJ6Dk+6Ofd0gx34+Oq1g+x37lAAxczNvehrEdgOqlzIEPKyMNqdmQB4wbahK/hc/I7dsOng0LB6wWxyqadb5ZnM+/a8cgUQ4dL6O5LXTScJOfO/W9lrgWXL5tntBv1SjicMEhEKsx+e1sH5G1Cn7PZDX/q8gnnXCfFxSyBY1FL8MehXAjPVEi53eUQ3yxnlCT1JeFIKOYYWZx2rK81VQJZxiBwswrkRHX+/pxNLSgCcY5BilSNNgGij7jaZD49G3yqTtVPOWoIOwumQKq7VG0/otFLB+NRCsDbCuldwHs7HxQdvwhZ8alZkxJww7yDHffH0OwQTt5r/3oMlz8i+B03I87WreiGJY4
 KND8Vi6h
 ls9MbO+Vj/sYnl3AV4eeFpuv/Xx0ifEajvPq6KPMYg2TXL+J0JF9EjAb6PW62QkZdPOWoGUIDeNXqPhcgpR22FKrsScLhaAEoTr1eOyC0W5nYCeAd4/Rz9DNUC/YVacQ9WJNHHg5Q1jLf6SbkFaDSKg5oUKzeaPUunuhmp7UHFTku3IK5cVQH2DiRC3CEfmEYmNTAJfDQJGcvE/pX0CC/XqK/oLwgJcjkCLmHkb1rFPSnIcpT0kpaaLZzpyUBxwtY5W7x1EOIExyf1ixGEDwzn/dkGeZw63hKmxKasK7Jl8sk5n9iOX9pg8eVkdTfpAWkOLxI+Aq+yUGUSsIpmk0hskfzTRauaWcOn/v+dFS2eRX+DByTW+s2HXsHaF+TPbr4Sp9LxzR37TjwSTAb/JBxtrRwOilfuCCGcOgZu8Sy8xllsagK0xty20SHxeMrdH+WOgUxB3bobVLefU3wwnFcar/TntG2QMS9c04aAfLTdCoKJfU8RjEwAs1fKdMbj9BMemHD9HLRqeFhv3H1tMuuJyqIc64POfUNvr4woDxh8Zg6ME8OPFFr9morawZqRDn0hwHWZy2n4SwvcQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert hugetlb-vmemmap test to use kselftest framework for reporting
> and tracking successful and failing runs.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. The patch
correctly formats the output according to KTAP format with no change in
results.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/hugetlb-vmemmap.c | 42 +++++++++-----------
>  1 file changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> index df366a4d1b92..485a6978b40f 100644
> --- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> @@ -63,7 +63,7 @@ static int check_page_flags(unsigned long pfn)
>  	read(fd, &pageflags, sizeof(pageflags));
>  	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
>  		close(fd);
> -		printf("Head page flags (%lx) is invalid\n", pageflags);
> +		ksft_print_msg("Head page flags (%lx) is invalid\n", pageflags);
>  		return -1;
>  	}
>  
> @@ -77,7 +77,7 @@ static int check_page_flags(unsigned long pfn)
>  		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
>  		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
>  			close(fd);
> -			printf("Tail page flags (%lx) is invalid\n", pageflags);
> +			ksft_print_msg("Tail page flags (%lx) is invalid\n", pageflags);
>  			return -1;
>  		}
>  	}
> @@ -91,44 +91,38 @@ int main(int argc, char **argv)
>  {
>  	void *addr;
>  	unsigned long pfn;
> +	int ret;
> +
> +	ksft_print_header();
> +	ksft_set_plan(1);
>  
>  	pagesize  = psize();
>  	maplength = default_huge_page_size();
> -	if (!maplength) {
> -		printf("Unable to determine huge page size\n");
> -		exit(1);
> -	}
> +	if (!maplength)
> +		ksft_exit_skip("Unable to determine huge page size\n");
>  
>  	addr = mmap(NULL, maplength, PROT_READ | PROT_WRITE,
>  			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>  
>  	/* Trigger allocation of HugeTLB page. */
>  	write_bytes(addr, maplength);
>  
>  	pfn = virt_to_pfn(addr);
>  	if (pfn == -1UL) {
> +		ksft_perror("virt_to_pfn");
>  		munmap(addr, maplength);
> -		perror("virt_to_pfn");
> -		exit(1);
> +		ksft_exit_fail();
>  	}
>  
> -	printf("Returned address is %p whose pfn is %lx\n", addr, pfn);
> +	ksft_print_msg("Returned address is %p whose pfn is %lx\n", addr, pfn);
>  
> -	if (check_page_flags(pfn) < 0) {
> -		munmap(addr, maplength);
> -		perror("check_page_flags");
> -		exit(1);
> -	}
> +	ret = check_page_flags(pfn);
>  
> -	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
> -	if (munmap(addr, maplength)) {
> -		perror("munmap");
> -		exit(1);
> -	}
> +	if (munmap(addr, maplength))
> +		ksft_exit_fail_perror("munmap");
>  
> -	return 0;
> +	ksft_test_result(!ret, "HugeTLB vmemmap page flags\n");
> +	ksft_finished();
>  }


