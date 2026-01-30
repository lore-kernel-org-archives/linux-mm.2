Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB675E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9FD6B0093; Fri, 30 Jan 2026 16:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917326B0095; Fri, 30 Jan 2026 16:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1466B0096; Fri, 30 Jan 2026 16:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 426A86B0095
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09D2DC2909
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:30 +0000 (UTC)
X-FDA: 84389848620.20.8C64CF2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CC7B20020
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=daVAtDFb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Mc1V5h/+";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806826; a=rsa-sha256;
	cv=pass;
	b=HRmI0qjwyva2VFY2WxcqgdV716YUSuaH7x/m/OYHLQEKaG3Rm4K79CiuIpOXGTLAXS/7zs
	U9Mdtm5f3Mkg1Z876Bjx2gb+3v/dUokTFppaFbcrXzDXjt6+7fWszIEEokV/17ep+pYbnJ
	esvQ/J0Mi2w94k0mhGgekpGq68Vaq0s=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=daVAtDFb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Mc1V5h/+";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=;
	b=kvzuPbcU8RuyldHw4Ei+PI+3Mvk5Vg2OZJ/6ZWgCYsPCo2OLJ9TZ3hIuEuy+6eKz6RjVGq
	ZOxNE3mZo6QVwPBuD3FXw29ra3WaF0APPEQGqmw+fEGxumKBYgYmB3QmZFTvbqkJn6UKoG
	sZ2AcC0guzt0NM5Xcz7IVNoQQQq3Sk0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKE3Vf4029215;
	Fri, 30 Jan 2026 21:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=; b=
	daVAtDFbQDQ2OhaehDQ5RPyWed7dwOwvdjyqgl0kKU/+vI9vGSWV33+cQAOV09d7
	A+IKMo9MGyCTNpagITKwMWJuBOLPnxX+26tXpxSG+qWQbJIBqEqLB9q8SOfU7ucg
	GIBgJPk/AcTVcOCYWS6JzAumfpXfdWTaXrPG1KAcUPUHD09OXsDf+dQgIWEcDhj4
	la86hM+OVknsfiJHVjek8npFJtTNk1ULJOiFeDOdztbgMJR0/qUY9ZOCDBf+zHiT
	G9C+oEzW/AE16yX/4752OhDA8PKEMB9V05v7t9UqrT0EEN0K8reGGxHgH1wLMvYB
	f4yE1JjmTUgAuCNvDqY4Rg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10668cex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJkq9S010432;
	Fri, 30 Jan 2026 21:00:06 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010036.outbound.protection.outlook.com [52.101.61.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe6d7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jpqPFDlxHBxfcemBYLQ7HLPGqyO+EnCskJQdtc4ukqLYykiCaV0XZj9cMQS6qAakL8AGGSH2/NkPX7+aH3w3Gedwl6fkR52of2b6g1BVO2EUJfXQ57lnhFv4wn6+D7hXCaDYfBvQ9mX7IkWuGIGdtYcLcQNjMiEnPf1wOVFdSfVbcEEHJzm+Ys57siHKj6aFU4CTY814EUrG38KQWUCz8zA2+LO7BXPRUByJtoD3Ol9sGmgqLBeMXRjnExvarbDsvWHjZY334LGk4A/qwT2Z3o9WtVa/AzNZ9WKDKzA4ex0KYYyiBaFJ09dXZnCX086eumVCrI+v7htcL3UbPr1SPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=;
 b=OZugpBjrd4XY5YpglyfBfYgHj1ZiA5omWSo0CONhHqWRFOjln6WbxP+ftMzRMJVOuEGkDX/CiE7CxOJh0RUS2aMbhrMuvcTRsoVcXHLrYnVoAkyzToU0qig0H+jiJYTkXuoR7+36SxH91aD7nQZorMBawkT5RGwDJfPC91zpJKYpNIyVzqwN8WNRqnQnciOz1LbKAbqdh/Ydm7m58N02INDnLWBDWnHsYWjgzvwepRF2DyxGuhA67EsHzXxBMTO3odyJAkdurqxINljikP0BQwrlgn8izJUpcd9wMr8G2csG+ToTXpvVq70+MEiqbf4sHCsQd7jfRIJP8lB9IB6lNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=;
 b=Mc1V5h/+eoZmKzAfEqpnlGEjppfPg0fEL3gzn+gp8ccRNbreuRusVbAyGi4p79dS0PPKsFB/PQODgQxXvYk0wGduiK0WevAE98j+2LjLPgUDlPj4/GBVVLKkPQn7ZjXsKCjf+zXllxIO0G8Mq56MFvTrr+FIsqJTbCZa6NYEDHA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 20:59:59 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 20:59:59 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 02/30] maple_tree: Move mas_spanning_rebalance loop to function
Date: Fri, 30 Jan 2026 15:59:07 -0500
Message-ID: <20260130205935.2559335-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0081.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: b6bffa4d-0671-4b79-9a11-08de604287d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iWsoMHQsyhe/96v4nGw41iNAZD4KTpz1NUzK/cUsLOyjV8V6Q3QQCvQXiiYy?=
 =?us-ascii?Q?Hut90WvzCs7pLYN+8mJ4BBLm7IHPrR4fh14MAu8eeUmUNNY7eiDfqIO1/8DT?=
 =?us-ascii?Q?N/AM1Rfrl9FOQVoxWvZP8KShVGzUreNHziSPZizD+YfOGoCz6z3BwNOAyyF5?=
 =?us-ascii?Q?hW3AZNy4PXpE2gAyECQhFlRxa47YLpIPuiEbOJIQUHEc79kUXo2i1FSK4tBF?=
 =?us-ascii?Q?ugkNbhgK7wc9ExoPL+FyWwOJ8PRhoBbZNercgMhoGq5706caajF7fFDyl7mN?=
 =?us-ascii?Q?uDu6KHjOp21XwEvTYedYYv3BWcH2pfH9gcOtJsFiYM+BL9m+wAUbFZ4q2rYE?=
 =?us-ascii?Q?Uw5XnkCdP0f6cmIKMt3tV2YmbNU/J554MYOz8uDPKBEDi8R6/GxypFf/Cqgr?=
 =?us-ascii?Q?NlAkCu7NOmzMaoGjNAFDshC0khhyDDI5iWMZwngQdxDgjA8dBLGP8jKMGWeb?=
 =?us-ascii?Q?uQOzu9ydOuD+N2hqDAYTMmv0avek9bLiM8pu7E9lO9qPtjxUoyYNXzSwj7fy?=
 =?us-ascii?Q?eCXGKOpUPwPKULWdnaPGwntIRwW/wmXLzV9O7Rl79bUJ917mNP1Sas82lkfr?=
 =?us-ascii?Q?U6x0FudvqKFsbB8PdbvG/tBa2/lks20j8MDKN3F6itRdLGnlFm+M60MwPeI2?=
 =?us-ascii?Q?0g9e/bLnFWiMsgaXSVZPM3OjLbgbU8a7xqj4/zChU20OxVwOBzmciU9JbaWC?=
 =?us-ascii?Q?CtHHgDmWYClrjqewhObmA+a55Ti5huUTCLFeoxf8JC5bVuL1q6h8c0mSSSyE?=
 =?us-ascii?Q?YAeq+q6PEVyt5bCTDbj3BIqPgZqdGcgzaBVd/c9c8BnCbX9D4TxUNj0xYEVn?=
 =?us-ascii?Q?VpUmcJohfN1lEF4q4cml+gQ6Htwl9P5v+3dpgdluctm0wPw2xclORBfBeWkT?=
 =?us-ascii?Q?6KJMpmmHn2YJQnmnDJfY/VrnhDhD4vxftPrRxYDJwV4ZV9vPEIet52gdIblV?=
 =?us-ascii?Q?GBwLA646BmH5/RUl40WCIMfe1GqfHC1mWYNk/Q2JUmtxFml8JvKOAJmeB4i3?=
 =?us-ascii?Q?re7BXJkyann0UJLs/z3HkH4kgqjavGwboGF0JnusmFIEIwBM120cQ6SKYydE?=
 =?us-ascii?Q?ZP3SiQvQGtI19WgFoKpDrxtk/59lYzo7jSXaDTAzbj1s965LAeMSVwApD6yg?=
 =?us-ascii?Q?97sopGXAuqOfk6o7jAy8xlkaQ33bAqa/JZP7xl6mDtunGNHBxRGw65Otoya8?=
 =?us-ascii?Q?5E6YdJC+SVjT6Jx+4YiXTsT9jfSY/y+sozg0YN3T92kKPA4C4HAuVEM4K/tE?=
 =?us-ascii?Q?V7BSa4xOCgL+hYYruq5bK14YfoJ1EucDgJCbpG1Hl8UN7CN3ziHN3d3/jA/D?=
 =?us-ascii?Q?/RYp1bhQeSBgJj3BbRrz+x4TiItxiHeg9bOYUNVfLQ7wdBYyZjVQfGeRUBxK?=
 =?us-ascii?Q?Te7sU3v/5tK4ki/rNs+6kUbjRXs2smrw/vniHv22CStirkJ4DSEs1PTETG9l?=
 =?us-ascii?Q?5mEL4rT/jP7RdoBE2NzGAeeCoYpTOAxvIvs+Fo0nbN9UOdQXXY23uEw63Ym1?=
 =?us-ascii?Q?nrto/evBxvntuXNUSBgn5JczXCET0sytky+2rER6nejmagSzETtgUFxS0b0u?=
 =?us-ascii?Q?mHnQuClgimY0V2cpTsM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qDbrsy1hVOsh3qQMS4rxEHHu8zMcBmZCK3g1cbr5IlUIMiUxvh22fAo4ZVKb?=
 =?us-ascii?Q?YhkinMK5rOfgOz3HciVPFKR2NlHkceT494dh8yO9FFCM241GD6Kb3E2h6Ayw?=
 =?us-ascii?Q?eIpT8y1DLJ9A+tsnaBjtq+WKhlDg/PntFLxNS7/oXhkoi0dlDMT2V7NGJa/Z?=
 =?us-ascii?Q?d73Se4Tmjditgk8wZJP7L02YXdU4iei2GWg47V0fX613Etxw+hmZ/A4Fca1V?=
 =?us-ascii?Q?knJqxARtksyqszecNoj8WqFmTna7mcaLif9OMWsAoVxHczfgYPJtf1KM84el?=
 =?us-ascii?Q?z3QmxlgdsXnOELyY1xv6mzPfkWJeWFDxl+CJH/nRfZIjwQchNa+3xiATRTUR?=
 =?us-ascii?Q?/8Haql8nhX1rIidUYSdrB9judIN9XWamXNTjWBDJeJ+wy5USZvyJ6edPeSqR?=
 =?us-ascii?Q?wd2ETUnilJBzVwS0nA3mJhZLLQ1xOfIMxWL4TZ4hwm2FYmnv33sbuo1Mg1h+?=
 =?us-ascii?Q?PTU8K4B0Ym3HNPRYNv/VYUz6a0d0A8hFXGpQLO36TUuIWpZSz1cSJ53enEpG?=
 =?us-ascii?Q?RA6cnS3qhrmSa9ZE4OKd7+DoppKGvrP9fWo5cpx4AlFufsbgKsw+N/piv9tj?=
 =?us-ascii?Q?iewcLz6sz0CCylkj/gSQpGVUPd725CbuKXHrs3mtotLa5rXfK6mQBN/uBGNe?=
 =?us-ascii?Q?1fUj4b7pPymOJkXi7XRTaO+t4xwXbaVonWBnt7VyMRrxGZkFF+6847EPzEsu?=
 =?us-ascii?Q?gev07QoA+SzZ130HMMc8YZ/2HhRzYrpx56B/OMUp5WwCrhUB8st4eTpcgBPS?=
 =?us-ascii?Q?QVQj7qelbUR5bY9ijCsNTGXTbD4o7ZNoWr+ZhE95NeGY14eSu3HrPBAw2Mhl?=
 =?us-ascii?Q?b9H8eCAYMtP4VxOg86Y299kvzc38ybqtmEI9V9UBx7WwHaNcRIq1QJ0Eg3Mu?=
 =?us-ascii?Q?msxj2g9GQFifrXMYDMlvJ0ix6FMfDe/ogezdVDx0ld/1maGouFxWL2BESZ+i?=
 =?us-ascii?Q?wsP1gDbdMprn9m3nCp37H+bW+TpYGxdQEGx4iahLhgevC+wFuYWJAzkVpwTv?=
 =?us-ascii?Q?374bB+r3DhDe3avGkIyBD3CrbWsGGswtq2Me/z/ekEoSavPODoveWBeuGvol?=
 =?us-ascii?Q?Hh9RVRbx8rJQ4/eFrPnWUXkozMrC/yRSf5IFRzvYhgpuwgRPRxD5MsEjiYkY?=
 =?us-ascii?Q?NzLToLuxwn3vyF9+auPmjfQiRPD2Ov8gsEl3fPC9etyvNezPkmbdEXm1M4wD?=
 =?us-ascii?Q?m4hKX6cKNneyddB3zrYjGXtNUGEeRt6muMRlhA5TbdxndKIwYlf3A7xkaynM?=
 =?us-ascii?Q?/VbyTAG6RycDIFWs+rXAXq9mWhfYVKes/jereQpDz3Rk+Irtj4F+BpZU8JY3?=
 =?us-ascii?Q?pyMu2XxrBIUJVaOz7Cof73kNd3f8wX1pp2EdgInEXa63x2rPyXt0IfxZnMM9?=
 =?us-ascii?Q?cpso4rYwwpFv2C7nEO/SVGWc8uZ7U2LLWZlmtXSel9lTrL9V0lWiYXdWWAcW?=
 =?us-ascii?Q?zF3IXbLXDO8kjNKNOWDShTCOR0aAlYeyHDgmikaulJ+5ZNqS7u2K0bp0cggI?=
 =?us-ascii?Q?METQhKWDtPnei4iFM3iK/SXd9hKk49MAYMxdsdT4spYjwi/fQOXpDgLXxxrh?=
 =?us-ascii?Q?W8Gj+9Bat/kl2tQ1N+kB7/W+ZdbVC3N7tQPMmpU0mVh6ccJkBRMi7GEdSMbV?=
 =?us-ascii?Q?XNYoM1jxtm+jrOeGjeqzioKcm+8x4ur28qYKUVr36+EuvRu1AdQFrFYoG8Du?=
 =?us-ascii?Q?lPp6jP1JVk4vgbqNA2A2e/TroQJFYjdf/iLTkIu9GmPaMDmGFu046O2wTBLv?=
 =?us-ascii?Q?x3y1J9amow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w3LfaRyQX/FbF35RyzcjujiFyOWkkLponl511M/1F08dk1r1OHVVHNOyZk9u7rrrESWox/QBXi2jicwZKnubaaeURVpRzXsho/Qg/7sF9/HtFdVdG8B4dFbXlUDLvvJ8JFsX8Lz3SyGYkjhwtwExI5SH7i9JzZYMqoIoffvfvDBo4Lp0nn7OgCq5T4zgSRSosoIwYEeOklXl3y1Oi5/7hlxyVbkLx9AGetbAxKL7BENrmLKpMl7SGZqpG0TwvZU4PBUlRNnk3QUskCMjsI5NAPWViJqIv+PX45xeTTALPMYPhUEXrw5epM7w219v+fseJ/ROY32OTFLob4KTFM1O+HjlVQlo4NLgw+y37T74lN03mZBVBcom90juMnvF6CvimxA/XekYFg0oEoFbaSSWguT5lvn5FiNmqpiGcGfepQSDdXezfecuCafW6hXaFK8hqOTXIV18rL8EjTXAlNOr1tKq/MVy5EC7SVpORPmLXnYKNkahklLeun0gmdCn7rNnuDWvxB4AuTsKj3oVOXoOEyc6hDzkCDX1nC54l9TLj3zKgQz35ZLnoNvmgWOMPE8ZtpTK7Be1nnkMfKWR/3xylEgy65muNcp7E/fC+kys/kM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bffa4d-0671-4b79-9a11-08de604287d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 20:59:59.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AXVtSVbn4ZQ1t+wb4BqeMnGl9+qFlcmggGuopFzpz+F5hg3gy6umV9k3by1mCLqdXk0uLEGFDyRc7l3uihc7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfX3QsCeEPgnW1L
 mip3Pfl0GopEyLpiHrkE08ObBtfTbxJynOh83XFsJFeG30v0OoP0YGd9oUYX1TmCeOQO8/N4xxL
 f8G63HJDM/MbtAObjECNdJBFLiijTeYElH4Ij8mZDgqBpns+RakNctQ78X1vo+quiufDvzEdIRT
 zXFBWn1iXp8B84gzwAlMnOkcOfv9qpbWbGwV3sgTRzKfygSw/iCZq53HitkgsgdjukILglCYWyS
 luzU1P/bTz5L+DeyppDPON71EOQ8kMH+K+4arGf/GtB2doPJ69cms4y3eN/ruayaBLU/1moABsr
 NibQdlPw29V6GIbRWf5LV26dja58A5AsZnWYpZzRB4/0yrdjGpYbiJcdGDg9H+WaoH3oXJWNA3g
 nu0MjMglH4zKh9TRyWYmaJI5A/H/JzsDZjcxLVfqYxtDJ4Bu8wvSzy8sg+lTdr5Aq3cqr7LdBlq
 4jnoBsaSqWWGud/qRNg==
X-Proofpoint-ORIG-GUID: hn6NqjPHL9hIREfChkW0558AfZ0-vU7K
X-Authority-Analysis: v=2.4 cv=EebFgfmC c=1 sm=1 tr=0 ts=697d1bd8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=KfpCAqERy7lSuQKxsjcA:9
X-Proofpoint-GUID: hn6NqjPHL9hIREfChkW0558AfZ0-vU7K
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9CC7B20020
X-Stat-Signature: eo8am3erue5amjfjzmqh7jn9z5hny37a
X-HE-Tag: 1769806826-786896
X-HE-Meta: U2FsdGVkX18RFPEg1U6s1cdjogVl4Dqt3TRRWBvZCnuThjQSOvtd380gzWJsBHFnEuY/xqaG2ygw7ANObmqXCn7anHRbiUT20KFMmO+ne3EKHOM1VNBax3QytGskXnzHKtvRht7TN1x6dRezYKwxnLhP6aSBP51XY//aghq/6KxL1Izy9HSOGv7wYOn0/etaC7tT6/MWYeA7aBoVh2oZcuZ6b0kxd8lwTTrZr10veYwkuV+oUEpB2FFcqbM3HnetQFQrNqficCxGdfK9mRmQBqgq0Ikp1V+0ggZ0RAG31Bo1BhnobFgY341sxJ716wuhgNj2sYFH1pSQf391GhSL5Yp1f4tHAFrqH/0+Sx4nj6iyy3953nc9TrZubGzTuAkmouQbzZYA0KfDL3uw1JYlmVL0b09+MnSRvNQxlDHF7rvHXjHhIETlBCxjmmmWQOSTkaZSE8eCYodV6kDtJYjAjLjra1xIGRMe7/bszRQDQYf/Nj9kIpFy88Zor/7EoCTrMMAEswJJCJrr/3qCwNc5XTqqmBf//lBZ8XzNxuNAXG5YnrgQf/szn22G4Xpnded0fUh3/ynJWio0KHE1qe9du8g5vF9FRArMVd2M+xroL9uoS073JXlrJY/sx5khF4WNk3AjhAqjJUgptSyb5JuWvUHwEYY9jFEYWv7BHqwHeYnBg6pCMvKWWyOWgnW/+lYyXiZ7ixg9tlk0FSyGUp8lshZbdjItcPp/PQy6YyE/Cg4CqIxH+0v3XxM+KN8q31BKG0n8pVFXnH/YlLfIXKXI1qz5HwIBNZyGqPkqYncEv+Kt3PyVo54vPDleqvLmkYbWzASd7i2M8u5Hwd2rqzdoQzUSUinQqzuTKzOiOkwEuHOoU/doCIF+f0XjEKBpWOurS27ANZzm3OGo3cPxd0iGF1vaVAPCOaSMLCFK1iX+QqPktoLa7+KY7Pu6xtoL3U09tNzZo1Q47cb1D+fEktM
 NscXzz2V
 iOV83ouq2EpZUUr7ohbxmzx/RtMEebrtzgi65p0apf5IFO4Vyg8bWb7B+m3q+4Zj+YoqGRdzZVUOOie/8Q97xFX8SIkitDI/9mczH3Din+y24atbnEVlHOcv9qXCveHVfK4+Yke/KXMQelTbAwdrmYH/+NfyAP+Kb+z0Ux+o/kMQtCVfqarnK41qslZDCo5UNvQxBSjkaoUsCvFCLKtz53crV9SxqgKCplUpPhZ4ZZQEEink0srFEcMwXS66IBcMiVRrdY5B8spux673vDYTVk6hssrQ3NyVu35mLwrUNipfteL9ORtkBkVrQu7w0floEGOv819yZmYPcmUg6a+W4hy896u3rGSlwgu2bvIXB7zmGls8EQRMNJeEsr+g9WHmiGmnfbQTn5fOli/b8ibIlQVHPhiVtJGk+2C8wPUI5krxKk8YGZG5Qs0g7TU+Qv1cIslbZhdhw0wNzkt7+Zwggl3Q9RLsGcLqipzZGj+uedEVl+yYX3YZ6UcdhdP4c6oVVpFIglQqa1P2kwwqVtZvP1K/KfmAy78QvBwf8i1Khpbb3XBezDKd3TeeNEpvC5cJBDTpvKFDWqQlYk6WoJTyef9nRRly3DeC9z8oBUDiDVNn+FCmhOq81WCl8XEENgxEgC37vzKnjI/TCrqeVIJtvB9LwuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the loop over the tree levels to its own function.

No intended functional changes.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 108 +++++++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 50 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0e0158ee7ba55..70ad474e6ed14 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2595,49 +2595,16 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
-/*
- * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
- * @mas: The starting maple state
- * @mast: The maple_subtree_state, keeps track of 4 maple states.
- * @count: The estimated count of iterations needed.
- *
- * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
- * is hit.  First @b_node is split into two entries which are inserted into the
- * next iteration of the loop.  @b_node is returned populated with the final
- * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
- * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
- * to account of what has been copied into the new sub-tree.  The update of
- * orig_l_mas->last is used in mas_consume to find the slots that will need to
- * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
- * the new sub-tree in case the sub-tree becomes the full tree.
- */
-static void mas_spanning_rebalance(struct ma_state *mas,
+static void mas_spanning_rebalance_loop(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
+
 	unsigned char split, mid_split;
 	unsigned char slot = 0;
 	unsigned char new_height = 0; /* used if node is a new root */
 	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
 	struct maple_enode *old_enode;
 
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
-
 	/*
 	 * Each level of the tree is examined and balanced, pushing data to the left or
 	 * right, or rebalancing against left or right nodes is employed to avoid
@@ -2672,10 +2639,10 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 		mast_ascend(mast);
 		mast_combine_cp_left(mast);
-		l_mas.offset = mast->bn->b_end;
-		mab_set_b_end(mast->bn, &l_mas, left);
-		mab_set_b_end(mast->bn, &m_mas, middle);
-		mab_set_b_end(mast->bn, &r_mas, right);
+		mast->l->offset = mast->bn->b_end;
+		mab_set_b_end(mast->bn, mast->l, left);
+		mab_set_b_end(mast->bn, mast->m, middle);
+		mab_set_b_end(mast->bn, mast->r, right);
 
 		/* Copy anything necessary out of the right node. */
 		mast_combine_cp_right(mast);
@@ -2708,17 +2675,17 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 			count++;
 	}
 
-	l_mas.node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+	mast->l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
 				mte_node_type(mast->orig_l->node));
 
-	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, &l_mas, true);
+	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
 	new_height++;
-	mas_set_parent(mas, left, l_mas.node, slot);
+	mas_set_parent(mas, left, mast->l->node, slot);
 	if (middle)
-		mas_set_parent(mas, middle, l_mas.node, ++slot);
+		mas_set_parent(mas, middle, mast->l->node, ++slot);
 
 	if (right)
-		mas_set_parent(mas, right, l_mas.node, ++slot);
+		mas_set_parent(mas, right, mast->l->node, ++slot);
 
 	if (mas_is_root_limits(mast->l)) {
 new_root:
@@ -2726,20 +2693,61 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 		while (!mte_is_root(mast->orig_l->node))
 			mast_ascend(mast);
 	} else {
-		mas_mn(&l_mas)->parent = mas_mn(mast->orig_l)->parent;
+		mas_mn(mast->l)->parent = mas_mn(mast->orig_l)->parent;
 	}
 
 	old_enode = mast->orig_l->node;
-	mas->depth = l_mas.depth;
-	mas->node = l_mas.node;
-	mas->min = l_mas.min;
-	mas->max = l_mas.max;
-	mas->offset = l_mas.offset;
+	mas->depth = mast->l->depth;
+	mas->node = mast->l->node;
+	mas->min = mast->l->min;
+	mas->max = mast->l->max;
+	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
 	return;
 }
 
+/*
+ * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
+ * @mas: The starting maple state
+ * @mast: The maple_subtree_state, keeps track of 4 maple states.
+ * @count: The estimated count of iterations needed.
+ *
+ * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
+ * is hit.  First @b_node is split into two entries which are inserted into the
+ * next iteration of the loop.  @b_node is returned populated with the final
+ * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
+ * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
+ * to account of what has been copied into the new sub-tree.  The update of
+ * orig_l_mas->last is used in mas_consume to find the slots that will need to
+ * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
+ * the new sub-tree in case the sub-tree becomes the full tree.
+ */
+static void mas_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char count)
+{
+
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, count);
+}
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
-- 
2.47.3


