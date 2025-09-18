Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945ADCAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08288E010B; Thu, 18 Sep 2025 09:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB89E8E0093; Thu, 18 Sep 2025 09:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C596E8E010B; Thu, 18 Sep 2025 09:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC8D88E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:15:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73C1311855B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:15:21 +0000 (UTC)
X-FDA: 83902417242.30.30D3646
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 33181C000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:15:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DeKYHdB/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ODoOjcrx;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vg5K1EOoeYuGb+ojCjNDspWqP6uPvuKu0Oq4+ZIihcY=;
	b=uWbFbHfBVb6jBmCRWWxSrsyCpLLOG0IxI9UGQv4+laBUs8VbO+LoxcePN/tBbjZWm7o9Co
	6nmU8jEo0WzIMf8b7VV2TguLsujqh06CZIYFdBqZHb5l5S44lImn++5fkEVTJF8lefSV2/
	/Oh6gphdBRUj96GpZVSaAyZbRzLDnFk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DeKYHdB/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ODoOjcrx;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758201318; a=rsa-sha256;
	cv=pass;
	b=8YmS4A0d6+2wJJLGcXPRNGP535+tb32BNLemqLzvX7yK0TqP7U7U5MKk5QepsKjJDMFGXa
	hPo2pL4J+SdnGvrLYz5liAxPc615aWNBaOb91Qlz2ctyXieMDSFEdJG/WCYOc/JsLZlNjE
	DeiQgEp4KvLAbgCIuaVZRXkP1yw5HDk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fuI6002526;
	Thu, 18 Sep 2025 13:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vg5K1EOoeYuGb+ojCj
	NDspWqP6uPvuKu0Oq4+ZIihcY=; b=DeKYHdB/z6C28J+6O0nZKku8MDp4ulC+tG
	wGO81cRlu/l64lTL2w7JLegF2vf+UsACs78XjmJblwmM6GoOhK0GH5kuRhzkHdYa
	a0pnNzGrDqj3phqjx3NXJCREzEodaCYKqf9IrOEiahh8KjBOxkrJO3qBPfcUAYQF
	0qNoOfqjg4FQoL4tXQbAwQ0doTXcmKCqg+YIzTuQ9zm6v/AEXQoHVLz8XM2Erw+N
	Pj0mFGJgJ9sYJQVQSB2JB9o2efa0omsCDhPwJA7KUdYlKzoH6FzUqUyK1UUt6AYQ
	abCD0AtVvZw11znqDs3m/Oi65Al8HAlSRO3lLvZRdmvAeQpTOWjw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx93dag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:15:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58ICW7O0028839;
	Thu, 18 Sep 2025 13:15:10 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2f41xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:15:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWzaxVr4UisPijCpj6gGEUcF2Ah06XTVHv4pxaz10xSrPsmWzZ0I7qdZ5VxTiTJ9vmtYafh88rDtrfJeSj/P4xwSn4jB6UdpZ6XLFZbjHBnygHBRk30EPL7N5mBaL9EsA7fvLSZAE3bfq8S8qoZA737E5fC58Kr6VHOO/R7wtEcbpH6r3r5niGexliUQbE8RwPu9YbZr4Pgf5IUC5yXqEWXOOePOUxf48DRQ9+QSbhGnmKKWjRZsFpeSXZ8gkkiLGAvrnlFrQVoxhisLlWHqHtPR8ZBBm/4Ig0A9zUqG55DY+g2bjbz9TcbGICdE9MSNJbMsbpef0vPWH9vTKRHknw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vg5K1EOoeYuGb+ojCjNDspWqP6uPvuKu0Oq4+ZIihcY=;
 b=qAWJ49T3FJRQcY7CxE3mL0uxoPsiYbs0YcQ2fCpl4rrQaRqzOAJHMdBEqK7TO7s49M3UrAPWsPTa1Kj1FEM1g1L+n+ls1woPKWLhfAMaqoYqobQlL/Ae87MRMxsfCBlmPi8Q+oXgnQfCkOtea/IjE9QvepeVPVKsLwDN/AA18kEwxAPGpaaeys8I1AMNsrmzkYfQEB4QM27qJnnw1qCp9gE35xp6MImmr9zSu1ZRdQzO+hrmdTNWU2QJFXIZ04hpA1k6vXWtcP5Vn7BuhVzoaT5vrW8mqEUSic6n1+itF1ssDJ41bOSZjPV1FGS8uULIqIeolBRoPS520hrLjHqowA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vg5K1EOoeYuGb+ojCjNDspWqP6uPvuKu0Oq4+ZIihcY=;
 b=ODoOjcrxVQkFAhLfb5YbyamfxITIg6h9RupRQxec7Vv3FGXZUeI3snBZL3bkEQYJpVmLrJh6O5QayAi/n97zEKaLUgzmUsUU7KWRXwFnCvD4Og0USjpMJ3ANbo5VzshuO2d5ksHDvITP27A4nmbM0pKSZLmgTTMjrSJvslJfRk4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7127.namprd10.prod.outlook.com (2603:10b6:8:df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 13:15:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 13:15:04 +0000
Date: Thu, 18 Sep 2025 14:14:59 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH 0/2] mm: Improve mlock tracking for large folios
Message-ID: <c6f77375-a442-4d54-b3eb-c6acdd375f4b@lucifer.local>
References: <20250918112157.410172-1-kirill@shutemov.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918112157.410172-1-kirill@shutemov.name>
X-ClientProxiedBy: LO4P265CA0189.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7127:EE_
X-MS-Office365-Filtering-Correlation-Id: 342c795e-39e3-40e9-3d90-08ddf6b561da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UokY0l+b9TST6zTF2m5mpilUvEgf+3n+2iZQcvOKs2srO1IHYUM07RcbqR4B?=
 =?us-ascii?Q?kBkvJiOfq+ILy+1Ck61xdyMeY0vDSHOus7oJ/xZeo/x1k654zZcRiK1NMmC1?=
 =?us-ascii?Q?DZafAiEl9nBTsmCjStdpNizrPS4xPNuTi57f78IlsoqF6ALlSSjh1yJfZRtV?=
 =?us-ascii?Q?PLih1hCoyoSWILrpjtW8MYbI3f7wYjoPjY/YuonhnxXLaoCdRwvv25II7pGU?=
 =?us-ascii?Q?+++i8XJ7lIdvQd8IpY3GNRshsabVlPhB89xQZcK5paeBIviQy7QKX1q0gCfa?=
 =?us-ascii?Q?lAQq3In1Bqrc7hwouX7K0gIIVFb4h7GVnaK+ngRJKb+vVcmdxmyOgcW8PFg2?=
 =?us-ascii?Q?jF2JjAPvvtpwMSIz7zQ6vn4uWhH/y0mXkmSXOxvjAH3e9JytB+HBSIhYkoV5?=
 =?us-ascii?Q?mgbSIl2EhT+uAsaHUp2PIpAfkJgOjlLY1sn1umkjRa+AtJpoPgOo2lCzuwJa?=
 =?us-ascii?Q?p6UISmewmhuBi6lbvPwy/5V1IC6BN1XyBMPHfJjMW8X3SMKWF7u4t1LHPDaM?=
 =?us-ascii?Q?X+x5LQxOkfu//NE2gIbKQL13fiGjCFPFZ/DyIMXXhb6QeXs5ruCA5XM2CJSd?=
 =?us-ascii?Q?gH94/P+xO4+3BL04+UI+eu1GLRY743hjUg1azkHdMfDN5XGVYPCS4HiEoWYH?=
 =?us-ascii?Q?QF5qARaGo/DP0DLFWloyRZqnmHbecE3BqcDLHOgNtcq0lxSw80a3APropqZV?=
 =?us-ascii?Q?w7W2zLVfbo2PNKiXoj0TA2wFxFzMgEje8Dk61hX5JXJ1VqHRD9siK4IgoVWX?=
 =?us-ascii?Q?jYz/JAJAdzovfxy+WjFkUB8jO7NvHyKV+BgJ5uWi5Asfox5Ri3SY9Pp4LA4P?=
 =?us-ascii?Q?vGGYX0Zwr10ZH3OkP0ZSe0FhEqtISVOPBU09PuDJfyZwHTJw257hvibsnyzv?=
 =?us-ascii?Q?pLVr3mIk+bX+PcoGgGHGAUbmLwFaxIumWnkmJHAwGmqzvNg4VgJJINQiaLLJ?=
 =?us-ascii?Q?IFUjCACq/sXL4+lEOQx9WZ0/BkiLcQ1hYldIpKBNXNEk55O1w9Npwj/RGzvY?=
 =?us-ascii?Q?P/apdu1dNrEzjOlZoQStpMlWeo5bzSA3F6MpyWsfVZrXnCnHtN3Fkmua6Byv?=
 =?us-ascii?Q?yk49pWoVfXO9EGI3lH9WLpWKM+DDInY3Dp6iJKD8gDzQqKZhCYVSe3jmFv5y?=
 =?us-ascii?Q?M8fzy3TfUf3B1QN+YpTO/rIwcaD56OxIJxNZFpsBrqts9v0e5tWlVtSnQv8f?=
 =?us-ascii?Q?SUG/9msbUk8V+yIDXyA372qPbKbHOnfu6r3nZSpwwORIZi6zNLsg9XQHxsqM?=
 =?us-ascii?Q?rkWBPEBRx0Zf069gIK+W5pbLL+Q2RRGhfeyu77O8uU4Vx0Y9zzYq4Z/cXqaN?=
 =?us-ascii?Q?jNgRIOLKun/yHTWqgbMVK5Eb0e9g7j508ECc2XM2ylJotjtZc5PzAc/wo45J?=
 =?us-ascii?Q?3KnEZ8Bsz+Siko8j9yR68esjJiXj4ap9Zf3IiDFiNS1TWCugwQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ItDFI5rOPHgqS6iYa0Oq6W7dBn5ro6WkSbdnu28WOmrH4tM3a1TJoMdGrf5K?=
 =?us-ascii?Q?QZ0CwyIPZQcfre3BwTr2bd8JXc0xK0wLFqlk0X1bJADklbVxomPLE+e7c2oW?=
 =?us-ascii?Q?BqyZQ/xhkPkkDquoYHs9z2hcWNU1sgbtW/SvQf8y3qz75jsinnwCXhvXoKQx?=
 =?us-ascii?Q?rDAVFPaWHSDUedu6EgIi8/SngV9g6H5letQbGeTIo6fFQ6aLK1P+hfECO+sE?=
 =?us-ascii?Q?sAf/FnNo4Je8jpaWDOWA1xerOMqm+4CXlXIIq0HQ8Nc7I3jByP+hOWo50pHg?=
 =?us-ascii?Q?WJfd+i6f/Bg1QVKAuxNbuTUGutLPdrRgrd6n9QR1R/ShF5yDwhOkPI9fdBrX?=
 =?us-ascii?Q?iXt6JlNjM5GhJG3Vnq7qpLtCIf0LFK6pNNnYhyqvnIw2xvAEzGwNaq7LAppI?=
 =?us-ascii?Q?2kRul5SbbZCZ8Jbn0gFOs9vLBbKjhJpw6oZRy+5tvwgTiwDLiGCMF/W12a0z?=
 =?us-ascii?Q?mWapxUBz5EJ0Lle3uwBpuYuUyrP+0kzQkP5pqtI2Vl0F4bTnZcla49rbzaX/?=
 =?us-ascii?Q?AeidZJuUP2RWuaotVDiQF9q0lZge6CLXyVrIB3sy7il3fpQoFNfRasaOHqzE?=
 =?us-ascii?Q?TlHJ/h9vbK+g0N8XewZJum0kE1MOG98crTWHalWh/xPhjDcM2ukhLUNtrNRp?=
 =?us-ascii?Q?u1T4jm/d1/S9g13UNXAMstweZF7l/s5lRxA30nL+3GIS4YX5BOe1du/XpUCi?=
 =?us-ascii?Q?uNTjJ21LGccNpWugZD63yYrq4jLHDRqIEiRHO06CTiIwWRHQxgMB9fYStjej?=
 =?us-ascii?Q?ej7ZL20CtYlLn+MGxlGzxpzVQBWp/tmj8M2UE+kmx7dMsNLrOQWTdP2ffgaM?=
 =?us-ascii?Q?ure1cS5zCNRg4xVlDBPAiU03/ZCiajUZ5RLk080kskZ+NC8pLgHiXhunuDPl?=
 =?us-ascii?Q?gSgMoZOQQh2/yrB50pBa4UbjjS0prjKVCiQ80yECj+beAB5TRnqc3jczETu7?=
 =?us-ascii?Q?8MXkUUpTGZicz+eVO8gw0Ek+hatcKeP3R84+1U9BWAQ4aEJh5CNai7RfIvwp?=
 =?us-ascii?Q?ZqkwB040qE1pI+yewUS2sx0VdM3VZhOGJnEeH8xLLratqxWpMMTWs9OHmw99?=
 =?us-ascii?Q?OtsTITF8Px7VtpB9YDEqkHpFCuJfOnKGEE724EKe0MDoKJjjNXkrYVt9v7KE?=
 =?us-ascii?Q?5pMvaOnyU9xfjEXj0hjW0LnhcLW6r/ggnkLa5mc5LgvGqAt+LrHwiP9tU5Gi?=
 =?us-ascii?Q?MZSqqGNNk2CszP2qBBRbINF2JTs6KDZGmcZG5Mg5dUY2+e+DYKk0y2WfJdP1?=
 =?us-ascii?Q?NiqBGERlKGejRiydaPaGFnbThAoIctI/Sml5MucFg2vnvyaHTFfoIi+OJcHh?=
 =?us-ascii?Q?yRMeojoOWuLL2FosG2NTHnXRzziILJ9glu4rV3pWIq72a1Sbpv5ayxRkTQ/t?=
 =?us-ascii?Q?x17jt59GqH39B7h9QWiyZbGPqpcJAwFHyPCKNfNgkDMjmyYayjNS/PWxG9H7?=
 =?us-ascii?Q?u56XIB5UvygFAP1C21t8rNjtGRBmMAtp2CtdFJTHG9nJKjlw7Yd0618ydL4v?=
 =?us-ascii?Q?OHCR2/2zHeNCCXFxZvKaSsNyLM9+or24i9A6KRKvS9RFJCtF7xZTClYkFtj9?=
 =?us-ascii?Q?YLn0ajW/IcfKG89QmnBBl9TcN/Hoc3cFjOhn1tl4lEcggs5U3QSP2gqUEOC+?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UagThUbwTnxplyQfjrKa0Zpm6INwT/k+VuNH/mZtBocOCbSP5zrrOoGYUaqSOoAfJqTWUEuESe7z52Qnx8b90UhgFl4vJAr4CCj+3WSfX3rmGrSEqz+XPGqKM2Y7baAuIdbMSVDeG+a5iXC66tXz6z19TRcaLUcahJfnH8162t4oie/weHP4nDJg0SB9JcCOBxShbGjFIRozYvU+zZpiYjf7+3AWPZlTeoaGqksvQhtTnGun0zeYjP0rz2NcyPEtlg3ZZR5WXyNKEyyIMqajD4FCj3abkyCdu5rRaKGm0oAFx8PFwoEeOKtwPF0KsbWsPer7CKIBxc0TJ56K1QJgHLQX57GgBBfYcpPL4CI2StrgIbtpc7hNC4gvCIaNPWP9yr29cX+FEpX8YCkZyQh9NTD6o9C/CQTbjY8iyKCj7mAnxwLy5gh7Q0ShOTrxTSZxLg8F3qFgs/4S5wTua32++SAYDbyy79OJqWOcFtYeSmC3EdUzTU+lgyei99SXbTDF2kJkBG771VYhqLr3NNLldaJclVKEQAAW9v5PU1w2jbxVhIXGjlMO/+NP9NWMdtJEhIGPCXE+Zmzkxb/nUZmTS2BBcI96cdsr5K1wHLSZ5t0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342c795e-39e3-40e9-3d90-08ddf6b561da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 13:15:04.8263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ww7mb6cOU4mtndCTWaaDUlMV01fykx3ZPszITb8ilfynGZ1jk+rL5RHxq8ELBKDw862p7yT8ixo07uhnGzPrEjknqWAcJWo87TtYC8gqDo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7127
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=894 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180123
X-Proofpoint-ORIG-GUID: pt8ARlJ_Szn3AjSW25kCqidjNLk34Hw1
X-Proofpoint-GUID: pt8ARlJ_Szn3AjSW25kCqidjNLk34Hw1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXx+uSPXZMCdBq
 mH/G+tBIGZLsFpBk2vOVCcJNcyu4IZrDCm+9fa0zFFgfYDMUMjPS1WHkLAWpPLpGLM/KCzsaKla
 8kzNIfCHhzqc9dCvMZM4UmG61nYFcsyvDEpY8/aUYnRBAeeatoylnFilUR8Lm6Q27ou71XZDhGn
 hvmadOublGgiH9wwhBUlXwlnhlSD51uzi3u5qNoFkVoPpK2QNL0UPVxOTeAVU7PjvDhh0xqGrTc
 PuYV/jFqmy5EXm8SGEbAPmjZdC1Q8e1YrxVWG2CLR7/D7P7pS+LSzKFWtq8pLTIFnC6TKFCXy5b
 lcOkKwxUfUSaejjAhCDO7wSFY9OO3eJk8Kqs3s3YJD4psSWjxYyXsGC341mF6NDuP6hsHx4xI4y
 10yBcqgP
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68cc05df cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=0kGgKBmrKo0Vx7MTTEYA:9
 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 33181C000D
X-Stat-Signature: xmtjxqzgohefqs16586czg7yky6pgrw4
X-HE-Tag: 1758201317-432100
X-HE-Meta: U2FsdGVkX1/zItnCK7do18kGaboEU6SKPH8tC08foXqha5pgHS5o3IdOc9P945+/ZfX92nfheTkqdK7ks/6dA8Y2a5gSQofp7IeEUX6tywlrWycPy+irwjKHeQTdgIGLLv5bzGqx55svOhNWITK8Xi0PEnBRbmiR5l4eq0zVhz1cOAYLayoHWTJJglHR3YHa0KsW+N28C2Mc0r8KRIBf0kE9sc3cKu7nlBLHAkmGkhbEcNv+v/xPBdIx8n0/v+jP3Csu7fhhLQDk+5puEj4XgaThxQNwflP+iJtEgTPpYOtjPDBue5F0tWslu3Pu3XbET1vehnE6+13rurIQt+UQjXZVX6AAfcMVP+sx4V3JwAIf6couR/dNha+5MPk7lp3Gc24MvZOJegnJ1eNr3NxxJlUEzC7f2q5NrdWflcYHMc8lwX5e8f8fLDcnYtuOMxsm8Z/tdVOykzOEMtQBesbismr2MzSA5K56bjB3P5NcNWN94EOd80XAviP/O8VRuAX7lBA2nVzwjow57Gclm0kz90PUzE77V9iGUkHtb6KxKplIKwK9QhZRaOiHmtf4rbXOHzh9/SqrzngSRvNBhiylHGoJv1HxEv5/zW7RMMy51ax+dXcDs+/37vUCGMH7TozlFiyWhaDhQCD4K5jjLo9PqJMN2NCvqrAxQ/CmyInuiroKMciiwQDKVVV3sDvfgCZ4nuxNhlN54HSFTzRShUEGhIyVpqTkG9wEv+7H1hTEHvAVdQ2BXqJiOnj4Tm+bGuP5FBgm4EoqH6Ykf00H8Gby5GS14HZmp4M58hxf6EVVA6GTrq2jFTK3te3qnSe/m7iBMWlYDz9wQS/VhdniavyKRJMQ6r+AQ/YVImDQFFXck81Efn4EjPumB7xJui4NqGFuarScYnIckeNeVWOitEQ10rG/e5CaCydoG7zEHyVKzrBxMmaFTRAsxfQDMjqAZn4dhMJiJDBJjJcbh46osf4
 0kftbhui
 13RU84BRY6d2tAJJMFSziRK+dDFMRyjamGJRX4IaDu4oD/ulDl2OuXgom3EjRyHf5Q27OqD08NM3j84IKe1Rq56zosjxycDTCI8FkzqpujqeRmJbNUiHjl7e3sTOf9VDGizy6e6sTm4RACWf6xkiyu24FsoLIRN0xaw8D7V0AB4Mf27+pSEtfSH14BboBuGeP0m5QrAcmsobArt81m3ZFs7cdfQXWepAM689NVuyMeSK8q7vKFW3j4/u16+jSLUxXLaqswH66StsVI4a6irnvl6aatbb97e8kQByzC8nwrvlvaew8Qfcn4577z/b8pr70rLAC/M50IgMxfbIKoJt8LBQJMpt8vrVCQOTsOoQJePyTZmwS1ZfQOopTDP3fQGWTSj5LZpQPPxDSroczmoxV0tgvDT7U1FxsioRhMNOYyOWuAUZFCmv2YF7CZQf5jhwOB7bvZEBdzKcRPSmoe7pRcismjJkeYXcPvHtTuACLIVv7OM/MSSksjyRFRMH3YGzQKbK6Pbe4cxeHsHt9s44kKKGDiCtdKew3Oj0SJ6Qfw/9Um1Veyy+RPYt1Qwgo9MmT9L9dheODCVx6+NUNfWnZHvNY1kcBtIn80wxL74pJESVnuXBlaqDWkrYU0hdwd73zAjvvOLkz9CPTF9FoM2OYgorEKkgw1IDpvycrofmwQXk6GxlO1QUMnao+wUFVwJSz4o2X/ZrJwV+VUMs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 12:21:55PM +0100, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
>
> We do not mlock large folios on adding them to rmap deferring until
> relaim. It leads to substantial undercount of Mlocked in /proc/meminfo.
>
> This patchset improves the situation by mlocking large folios fully
> mapped to the VMA.
>
> Partially mapped large folios are still not accounted, but it brings
> meminfo value closer to the truth and makes it useful.
>
> Kiryl Shutsemau (2):
>   mm/fault: Try to map the entire file folio in finish_fault()

I feel like you need to speak more about this change in the cover letter.

>   mm/rmap: Improve mlock tracking for large folios
>
>  mm/memory.c |  9 ++-------
>  mm/rmap.c   | 13 ++++---------
>  2 files changed, 6 insertions(+), 16 deletions(-)
>
> --
> 2.50.1
>

FYI I compile tested each comit, mm self test tested blah blah + all
looking good. So just about Baolin's input really for 1/2.

