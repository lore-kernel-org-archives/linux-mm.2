Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F37C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B846B008A; Fri, 25 Jul 2025 10:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C2D6B008C; Fri, 25 Jul 2025 10:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F39F6B0092; Fri, 25 Jul 2025 10:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB0A6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:11:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0E71113A4B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:11:08 +0000 (UTC)
X-FDA: 83702973816.26.7841D4D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 08F592000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:11:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D0Y1usdc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="WHJVb/Al";
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753452665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxzBlfSpE8oLXT/1xJZSZVr3lBccDuXX9Yil0K/BrF8=;
	b=0gDyJbWeBKOUNVC6oxLlhlbsUl3h7slxkXZaPWEa8XyTA+VEuV6y7ON2rbttKyfJ9fRGiu
	Z2/fsjmCr2pIg2EyjwOjo1FvBM0YWLSc2X+IgQiCffQB8Qhnkg0MSylWUM3dOl9Q2cmi7X
	//+o2o70irGmWoCBWsBhT8Aqx7wB0Vg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D0Y1usdc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="WHJVb/Al";
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753452665; a=rsa-sha256;
	cv=pass;
	b=LPAQ34YzAcgaLDS1ZKMWYBbi3XjpoBeBqb21GIs0XSBGBNBNzBo/8mCoMHQmIzY4HjstNI
	GT/yD545qFeumMCkOt2iOMQ+VoXBVGOBMHx8jFHdmFXcG00FtPTvHZg2cc5/Sl9mk5hOvK
	SKN7YJxDxH9dT3A2qlmO1IeDwhvo9VQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PDftJ8017985;
	Fri, 25 Jul 2025 14:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fxzBlfSpE8oLXT/1xJ
	ZSZVr3lBccDuXX9Yil0K/BrF8=; b=D0Y1usdcyFw97IApR0K7KGjSKPLGmNRn5I
	RwbbfdW+dKE6GVqMdeOH2LG6bYX97gSG5yj4d/CoC2DgmXjtKvoR0DPnWHc8WMYs
	n3Oq4qBBIyrB4WsdwtulE0GDr4grVjZ9gyr2octSeyeyhPgGiR/qtqdWLl6xjgZ0
	W2czFyzL+0gS4jt9ozAXfgFzyWjChdgV0pC3dhkl3vA59MaWzD1E3ibpB1USWOzi
	2P9lvdYQSshjlikyMvXlInqertSQ9pSNP1xwdcRx3zVQa7kF68eBMtUFE8161034
	WgOrXWNglCaUttVbBAyC3en4dSHxzH62UDjNHdexSsSANxTiiGRA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jh4nt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 14:11:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PCHmgg038445;
	Fri, 25 Jul 2025 14:11:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801td5tq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 14:11:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y8EKDLY223KAsb9sC11sOSUqQMzwakmqIXvpTQI1HHSj7eUSKtuXpoCMtcWUUyykRyg0BFv5rM0g2uvWWqusyBcn577UsFzA9M+xJVG6tW4ZtmF6jj+Oow4L4p1QMCXLRA/42Hmm0kDmdU8IiU28BfRjSgFhtKA8/8lSohQLesp9X7Vt+ZzKoKbL198IVcQEFvINDKkzg6p6+nvuaqQV8Xe4lgmqRSiRmUckTSvBqcFdbXyq/JrG1OAoayuWAIMk4xMhrz4QW4FBuxSVvpedh6RYjYe1EjrC3r30/NNAYAlJRS4QSVt6vKLj13TzbCmj9X9mMxI6KlFHEsW9TYhD8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxzBlfSpE8oLXT/1xJZSZVr3lBccDuXX9Yil0K/BrF8=;
 b=wz+EaLcyrqxpaYB8cUqm9X+UuDriZhWmw1X5NjtZ86cQ+EwFRj9X9o3Vtyk+EUNHsz2ScsNZND8vwXZCCHUcyabopaRAPXmPzNO/7K28nRsTrdi9QShUhCuOwQc2iH9g0BDpttXEVE17as5+8lFZ6htLWym9TPg6ILy+QmAQKmJQinCkM8023Apgblp8CpSovMBIDRWJnuNPbrFbcIQDaChv9kQOtmwuMO9vLYcImg0XrrLyFR4GQTYXr/CabVawTIocq8NPonsKDY+06TcEjbr/IBeXqLlFs4kWz6nUMYKbCizWgwnDqXbdBZ63t9bUW2wq3SNVfVt3KUk0HtppRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxzBlfSpE8oLXT/1xJZSZVr3lBccDuXX9Yil0K/BrF8=;
 b=WHJVb/AlS4+yPnwSG1bpKsCpkuMDwp6t5RLuvRwmZax774OLtv5E2IrJ5jJslDtRhFDhay7P+fYPqbc8cudH8F1ONoFkQ/cVtohox+IhTIWxvCDOz6GcA2HBMAWlL49sjN0Jh7+VzYo/1cv//sv2CFJqIfoc+37Im35JUcq0x8c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5146.namprd10.prod.outlook.com (2603:10b6:610:c3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Fri, 25 Jul
 2025 14:10:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 14:10:57 +0000
Date: Fri, 25 Jul 2025 15:10:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
Message-ID: <3a2810ed-74b5-4822-b3e1-bcaa97eec264@lucifer.local>
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local>
 <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
 <50502c3b-903f-4018-b796-4a158f939593@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50502c3b-903f-4018-b796-4a158f939593@lucifer.local>
X-ClientProxiedBy: LO4P265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5146:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca84ffb-db69-459d-fc38-08ddcb8513b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KnDDlb9s0/fXe1g69KpSU5OdtdmWWqmgWk1CgCA9K9FW8GCMm+NQIXqUIEOh?=
 =?us-ascii?Q?C6IzNsrDZvqUpahzzBVcglc3Q2+gIQ1cWXQnEFltpkBo7dGx1NshtVhqEpu2?=
 =?us-ascii?Q?suIDwm3ENWRH5+f3L5D4z+KW78pKpW6QrLkBMnJWgaj8xD5kYXNjm41iJRsJ?=
 =?us-ascii?Q?CuqFVCf0DJIy8ukmcBQrt7CamFkNI8OEGH3QJ4KgkhVuQ4dYXTuYRdSQH+GK?=
 =?us-ascii?Q?2NIpZezZtkRzU5Y9NDu+gJmuJwWBpDFNsK0nv6OV4+AnmreYqGglOD62LL+g?=
 =?us-ascii?Q?PFv8Gx0RicZ+btN8j1qyhRHOsSBVGAcA907YjZsSbg7YZEUOm8M246SkPuZy?=
 =?us-ascii?Q?k6tGu8Do14KHzZrKKL6wR2xSMFTLE3WcgKEpgG8btzWaxJjXZ+pfGADtyzSX?=
 =?us-ascii?Q?ydnW8ATlHlJ2eVCIx7xga+Avw4Jkr1xFWCsTTLwwn+C88vOe/ALAjhkKBpuR?=
 =?us-ascii?Q?rQeyszFQQrZrILe9z+M8CjpnHXyuwJh1QouwsxEOPAU6cYCVxs8+4H4Pfpyq?=
 =?us-ascii?Q?CU52U8aCQyveA6hjcMrZy433X0PvkHBDV6o7tsG9BLx/CPIpWRW9Wb3+1hZ2?=
 =?us-ascii?Q?zdcSn5lbMnkeEdh4vkpw/ocZ+hxgdaTQ1YORvimLQNKcyLVDT9p/Klfb7bfm?=
 =?us-ascii?Q?hH77Il35Df3MnbgfvyCKCCm5Y8fyjo5/SsfKjlKYsPApaVOk9Xq1l+rzzMMd?=
 =?us-ascii?Q?qxK9GP/dKM9v4hPG8sqO2GVNEu0nyGXbgJeVblO/SSt0ODu9Pgu2B6JeG8fz?=
 =?us-ascii?Q?7iyTUn+Kt/113YUnjCBS1z0kaZq3RYyqCtR5A59vCLTaRhUvUKq8Ugyaa7yC?=
 =?us-ascii?Q?n3vvZDyJcazk7goBW4qi3qyYHjLiUrS51cAg9XPpuy2fU2JffbjKbmd7ARRo?=
 =?us-ascii?Q?5m97ymoJGiePHxI3wSGex9SHMIfnRdBQ4rAHJiDOn/+EnuvdLhpc/eRCXDI+?=
 =?us-ascii?Q?Ipk23KmY/LcJysOEFIrrWDPfNR6qfOOZ7zyyW7r9/TEEmCtNiveUxwL1WSsZ?=
 =?us-ascii?Q?RFNlSk3hTesN8hTp/9hgo1I67gDZLBkqfpCqwES/mg8+IA2CAGAgzCw/U8gP?=
 =?us-ascii?Q?P14HLoMGyQyr9zm5zTWkHlGdl4YJpQx7487tgSwoQTI3CF2D6p+5WvpP/9NJ?=
 =?us-ascii?Q?lIRZqtFfTi1HZahrfcAsH8v5cMdYgxD8wogjilD9LbBomWznaTVk3dAcehVX?=
 =?us-ascii?Q?tRUqVeHfyfy2NGeTSVlgYh7flTQEA67pfaL5K1J1nBCXdJ9eWVrCn0J1wynC?=
 =?us-ascii?Q?Vu1uqlCngPb60sBzCTL9sJ8sd4gkwMEvA9FM4HA8fIYk6zJI1O8X7ilCbIjJ?=
 =?us-ascii?Q?8CA4OFBqZ0HwegY9VE/3/ZgTmSU6xF77zqGHbDzMR7FlkTS5NeWB5Y6ojxWX?=
 =?us-ascii?Q?mKEyuimvx5nKqEU5bgkF4p6fLjoptCcEu6XzABvVuxckmIE6xAzUBjmacsRL?=
 =?us-ascii?Q?c5yxHiQzuto=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dQeN8Sq3L9js6Yniqi2IjBOAl7XyvxGanJ+4dXsW9pwt85Sth6OS7sh8GZCS?=
 =?us-ascii?Q?+6tfjsuTY/ZuBwO7xasIEdt/5SKqMYYAsRBvxtN1T5rvtTmYPH06I5ZELjGl?=
 =?us-ascii?Q?a2BaPJykvf5PTS+WzKUxjcEFsBTyNFucvEOmmfAYLzAQARlHiiSeWfDq1J77?=
 =?us-ascii?Q?mhhPkZ9JMycDS6DHZ/JD0zpzj4y5T05Hlu4PDrPewrr0lvhGXXp6ddiCLS5j?=
 =?us-ascii?Q?PRJ0orLxKu7lw3jwHGytnkEpiR6gFD5sdqMqbVU3hcTB51Ie/bDnBTlFhMrs?=
 =?us-ascii?Q?aDRrPfRY/47vVdLru2T8zOXAtzPX/cSA7CtVL3dgxbxOg2ib+BkcLw6aI73B?=
 =?us-ascii?Q?xqTUduX2057MVXcGryAU31+fLHtivDP36HbF4StZ6EQpaqqvLWyGDy3ToeB5?=
 =?us-ascii?Q?6IcQuzDviIwUnxo/TW+ZMcm8edIJaZeDwOYbUm7b7jA6Zb8ruSCmXLOe6ONF?=
 =?us-ascii?Q?B7jZTu9Cd4Y2KAlDjspn5THki9kkg62ENr9o5D2nGsGatxpT+VqSh3H7NhR3?=
 =?us-ascii?Q?Y1un8p1tYx9TzhlO0bWthiJjfpHVIANJoTd9mCMsYdAvwklWm++pPDDImFEY?=
 =?us-ascii?Q?71R2/ik32MycP7M0zdWJ5L8PrV+0sMUONQ4LfUTQmDRm68qrKKpCsoX/4c/l?=
 =?us-ascii?Q?o8xAm311r1lYKCfyn1HhIFfKlafZzD1iNshwhzPhXj85FoxkSsEz7RQdt91o?=
 =?us-ascii?Q?VpWNeC2GjkM7B30B1tsaNT4G2U8SHi47NAFD+CnsKv3S+CNhrJ5J3UNvpHBk?=
 =?us-ascii?Q?DbnRF/h7WucZl0InGOUMbGKSnwkSQtwxiT7bNUm+kFYiC1IY+VRPf06FoTJ5?=
 =?us-ascii?Q?nK7+LPW45UZ+4iovOLyj6O4JsKMuyAp0R7rstCi7kg2+Op+aV/4V6aosn7YQ?=
 =?us-ascii?Q?H6OORbxLPtVrHPqIZ3NLCj39qM8Bv3NCRK+oM0AsdE/ZOS8jbWponI7OGQ16?=
 =?us-ascii?Q?3366Gowl/Tb3wWwFXD068xuVC3gM5s9/TTfDDWZvdf+IrRgBkacoOZnT41Hf?=
 =?us-ascii?Q?M+m6oGyxjy1oCbjTO8s1sPzq3PlmtWWlFA+Xef4CwVKF9ubbHuZMiRbQN3IX?=
 =?us-ascii?Q?LG6shit+dhqCQFR96ofnRlhU6Q86nIb4PWPdnHFGmZleeF+1+Vo3j/q0IkUF?=
 =?us-ascii?Q?vqdzPJmY7uYj2JEDtLEEYFC4AxRITotXYO/5scoMyK6hElK6GMH2AYEwNmvw?=
 =?us-ascii?Q?tccRRxcP268Z/n0ind3o3IQqv0NxHvtoU9vbgc5s5whLpEbw1IgzjNuxi74m?=
 =?us-ascii?Q?+nyP096SuoySl/5DGT3EiaiVgovEiYd5b7f5KVRHkTTPOEdN4BRtDIqBbTMe?=
 =?us-ascii?Q?d9a1l6fvUwJ2V3VB23KBX6BbdIAAoDWbZs4CC/iq4HzXLu4c2Kx1DKmUGA1W?=
 =?us-ascii?Q?zh6q8IyfrtKhvaWJlJDqEQtnkNBXM9cnFC38nS+gyCLdbaq6jd9xJgdIakv1?=
 =?us-ascii?Q?rTIA0cAvzpqGC5JL7JYa4rmIcVoliCG0hrOZejKB61+8upiJDm0Dr0vpaqib?=
 =?us-ascii?Q?N3HakXleS4yRCgPCbTJg20wX+qfMCCp6zd/GcdqSrtv8sz6KkZOOtfjTrbAa?=
 =?us-ascii?Q?SdtqkIMNYl8HoIOTsP0u05M3hQRGuEfZH6drj6w5fWdXkIPmTao46sUzMnXT?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GmJy24rShC7NOx/W81SBeIGxpH8f1bpd04+Vm8oQAeO31JHSRVdrFXXTolnSVynrECpN0519gCKgIhmit4HMw7w9ZLOIpOec0Qhxdes65AgQmWrIDIV7T4GESgujbzXmgWz8hRW8EHLF0y6QuXjftKUjzXjYJs2EyLUdR18B0xJovk6FSpaqxFMO/cJu99SRWXcsunNtyR2JdrU3uIi0VV6/lJzeKkmyhgpDTJi3V0wmo2z/GFrRCW2TrvNnFtJTP75ZyCO5956XyjpS0uhwYw+boqzPfCEszbaLqAwzI3reNthq9QNsWnfIuFTPbakG5b2ti7u7EB5d9J5qvlOzjlvpHeuKscgZ0JAkIy8qJ4ZrgQ35KWHmOHvF+CEqLwPSQCNkpxvGigNDMMXhjYDlBK77dsRmaU3vJCUJm8eW/CErAbadn61SxgaHncQOyDq+mWAX2msKsz4uR737VL7dh5SKJ7CRpPkk0AQtgMtBejsPsu5yl2rWXQpCjeJCVUaZMPsIjC+e2cJQXWenC4z3zvVEU5En776jgvRybiFyQFKnDuqccVc5PhSIlU0f1tH18oYTEpBKNv/2dg9QOARndCO5lnJX4H++aMF18pa7tyo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca84ffb-db69-459d-fc38-08ddcb8513b3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 14:10:57.8757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVszCjPeCM9EzXiiKzqOuoB2OqKFCQa5RwEKsCaXHKEfO5LRXJCnEoUL5FHiSHlSN6kwCmGilE2WimU2GN6TTvL1UDPepqJ88QpI2Xn3OHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=959
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDEyMSBTYWx0ZWRfX+3qhiT5vrBkf
 7rWK1aFESItgN69hvZ3ihljwMxruJ7HN8ORFaSU+kXyVxXSZpJaZCnln4Gmw6nhW7vOEdrNUF+o
 aoFzXQj/mNti1pTyvSVUDl6hLC+yQAR5gQH5Q3N4zZ1xFFkiIlhl6yqRXCMhKMRdqTAKoD4S4x5
 d/cphpG+PcYsC1uyPEXMjO9MEgdosrmGBz3q1IOGMZylFcm07y/XQ73EwgUZyKsT+paf7i+fy3B
 mkbRdJ7Se+QulaW0kjdROlyHZxD0Jqx1hPCfO/ZgLhVmgfvzHjl0dUmyugagNeoyAZ5IlCgawkb
 AjfWYulfsiDlIZrHHOLSNcBfccPfSrYZmcBaysaB2VDBTGWA/9S1KR5LmwMaLG/BiR+Vvp8GZrX
 rx66S4Faa5VBWTOS5z8Xd5Jf2HHYdHBtFLEwvQEsRGnl5Lv9Ocn75WEEWpNYnc1EpEBbB3F6
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=68839075 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=rt3iihxSpWfSVDxq28AA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: 59S5A9A_Ogz_DCeBbAZG7GP5KQP2fbYy
X-Proofpoint-GUID: 59S5A9A_Ogz_DCeBbAZG7GP5KQP2fbYy
X-Stat-Signature: r5b8dh4wza7dtppei1w7pju7yju54r95
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08F592000E
X-Rspam-User: 
X-HE-Tag: 1753452664-966353
X-HE-Meta: U2FsdGVkX18/ZzyQvhr9PywouR0cBozfDgaFbWY/rdRrZu2JNANu1tlb0Gum0AZhoKseBWcOipB62IBTiMzvmBIXZ5/VifiEDN84SWQRutNWusd0386O2zbJKlgMJkSEvv/BzFY15HQjuK+lodXmK25sX2T7tNcDn4/Nb9wdugz6Qwf04ygiFb7VwcMQFpei1zOPBUIZupYq6yl9J9S6wW/cDQnKa/YMrRl4+8jRRJ/gGeYJ6mbPrPom8iXSGXHj0fOFxP0mZABhot93uZzBlnPXhH2haYwUf7RtFJ/kQPFhSnRr+AzrFVsebR7i9UHhP/OPoExxV2XB0lsfWHLIAj2vQ8BEk/aAgTb7H2Np8xUBUfi7Z/eLT3Ge9za2uvovdGj4o4jhZJcciXsS8vP3vtPoWU2BAgOEK0+SmTO+OjuOeGtlMIkumcPzqp3i8lj5yYFzVTakHvrGPr18Fz9tGHQ/w95feRl40KN0elB2HnbitTEOkQNr9LiXwA5RRadOl++od5BrCPPekC8gHZxHzhmdaAJXaAFhev+PSkljDeKBcKKKKXqCbSp4B3hoMLCuKziVNE1Oy/x18O+tJLuV3JnIYR3tctE1Pu1N65r4DolGjljrvzXJuXEPr84YoCKW1shmAlQefHBfNIicqyQTuAW5o1ncn2egYFL4o7L1SKeXgQjGh4hF33MzzQ8L7KIKFGiHOR9FU8KpObKgSZCF0P6JfQbZirhUkuA/Vfk9XmSSZCcCNzuRa7nlPZXliPAXh9hHL7aI81SYSjfeo6XWe0EjZullZL+DlDI1emHX/wybuYtXEgaK/hI27ED1snuVUPeTvpxa2f/nqV5AxzW2yDNU3Ybh5mMeaPiHk26QhMwkdedylnUkT+uoha0TnjHRLJUsZCY/eRCKWBq28d9dFZq2i3iiu3tE6SHBw3aweji1UdsbEUas51gvZGeG9G3h99q8i5ema9cZdywgkyS
 YBnHiveA
 KHc2YlHNG18zP62XGuADMbAkJPXQF6GAjwBgo9Z8Jm31r1VxnbvnVlAzvKsrPIzOcQHNIEN4sUDMHH/Cm1Va/PWOUSJTt/9acQh2LobwGoBsp1JQo/J4oytDeyzNYrQ6ZKLmE2XFQG5t9YjeIxDDQzKsBaXP2KkK3c0D6OIw31P1EWioknEGZ/JqckJ3veuMWZYjT5HaqS14S/Fz87Qe2Gpjs+sPu4YFCJ1u3F+dH/M9wpnNCoC8XOdMYOUZX8K1cqgxwJ51CIDP12z8dUeK9vDMeLF3xTSLDeG+AxqCf6M6Vhw6nxUZT73MS1SGrBUBJorBJmM7BQoL+EUxko05ILMa+EcdtOVCMuxpNZs2BfBEJkEeHKMiityCMi7Y6r3Cg8huBL8+RkH9GwnnAw2tf+grJe95dny8oH2Bh+CvkyYtmGD9YYtOQF1IvT/M6slcvGpGonnb4GoMhQtE9NCd5vinWl76qIcAJxpmSRDNi9OzCGnRLhR8F5WDmzEjv8JtiAsjNiVNf3hpekwE0uzoGcyvH5LiK8qw7uDwYSrr9s4s9ldKif1Rr47CQhvB8c3nO+Z1rMofiXC8KQnO0QR1UGoZm15ETD1dJ0ld32ceKXBSI4s3wRTKpLCN2xCMITcuWd0RDK7F/aOvcwg7doHdWCTbgEwL3phnNWjMGwhFfauYuD4DAsx4wlONXot9FsWVVEsda89AvVk6/62DciCfEaWkad3xP6tCAVix7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I went checking for this but was blind obviously since didn't find, Vlasta
asked off-list about why anon_vma's are allocated SLAB_TYPESAFE_BY_RCU.

I notice as well folio_get_anon_vma() is _tricky_:

/*
 * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
 *
 * Since there is no serialization what so ever against folio_remove_rmap_*()
 * the best this function can do is return a refcount increased anon_vma
 * that might have been relevant to this page.
 *
 * The page might have been remapped to a different anon_vma or the anon_vma
 * returned may already be freed (and even reused).
 *
 * In case it was remapped to a different anon_vma, the new anon_vma will be a
 * child of the old anon_vma, and the anon_vma lifetime rules will therefore
 * ensure that any anon_vma obtained from the page will still be valid for as
 * long as we observe page_mapped() [ hence all those page_mapped() tests ].
 *
 * All users of this function must be very careful when walking the anon_vma
 * chain and verify that the page in question is indeed mapped in it
 * [ something equivalent to page_mapped_in_vma() ].
 *
 * Since anon_vma's slab is SLAB_TYPESAFE_BY_RCU and we know from
 * folio_remove_rmap_*() that the anon_vma pointer from page->mapping is valid
 * if there is a mapcount, we can dereference the anon_vma after observing
 * those.

^--- this seems particularly pertinent...

 *
 * NOTE: the caller should normally hold folio lock when calling this.  If
 * not, the caller needs to double check the anon_vma didn't change after
 * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
 * concurrently without folio lock protection). See folio_lock_anon_vma_read()
 * which has already covered that, and comment above remap_pages().
 */

Suspicious...

