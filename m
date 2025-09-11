Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184A1CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 19:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1188E0007; Thu, 11 Sep 2025 15:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A88C8E0001; Thu, 11 Sep 2025 15:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FC28E0007; Thu, 11 Sep 2025 15:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 426018E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:39:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E39BE1A050F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:39:18 +0000 (UTC)
X-FDA: 83877983196.10.9558B5C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63D2A160002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:39:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MaUSaKcu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X5wNulvL;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757619555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyNq/m+Jrc13tOzg75jZDHA3s827mFeET5CIqW4+QR4=;
	b=ZLnYKDrUSY/S6Vi4DSm5UCCHMtH1ShoI+QdKQAk8seX0KFJaUSyxenmi2LmXwupX+aU/8V
	/gHwifaZYv6nt197CBiseFzBnXcii2jvyreuxf7qMzFz+GjEdetr+LVrgB1KHo3Z2dZn3b
	DCK0aCJrXir7fSTENHNvnTOAU6npNEY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MaUSaKcu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X5wNulvL;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757619555; a=rsa-sha256;
	cv=pass;
	b=x9nzi9O3QOETP1EhD0g7YKFXxhZi7pk1O8Dy6umzuHlRBwg/6OsL9/3vXGpABg++1dHfPn
	dU73KK6HdfBDPN0PdJ+Pv2gsOt5e3bY+BVeDG1gGkGEsQkVb3JxiPxd1TBC87Q64m1F9d+
	7/mlTBQezCmm3kYoAgXgYacT1/5KMlA=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BHBkrP028441;
	Thu, 11 Sep 2025 19:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eyNq/m+Jrc13tOzg75
	jZDHA3s827mFeET5CIqW4+QR4=; b=MaUSaKcu+GMKuOO7jov+f9enEnW6Rpquvm
	Sp/Lh7dKl2m/FzcfgSU02QHeoBArjA4vuzLzVcOfMDAjFobBt0XT4yD/BxT1eUSq
	/rVKVD8h8mcMowBBFBWKnIozIcOHjO5dyg/4N1vQ4iKAQlHLyxsq826qWrZ9oGQi
	ngxF8Y2sLZDvyj7SRv7JCC9S8KL3q7CEtuQxDqeNYo/8MlPL+LunweSfmakWY2aQ
	8z6/kamypi+js0o405jXnI4C1r/1E+KqjIUdMnlyuKAdaFp9gg3X8MkUfKDvM5LA
	K0npRwFm89nHp62FhYQTfJLwpaZlFIACJrBc81+CBA82CgmES94Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pef15h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 19:39:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BIPMP6038731;
	Thu, 11 Sep 2025 19:39:08 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012003.outbound.protection.outlook.com [40.107.209.3])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdcwvh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 19:39:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y0XZ75olkc/iHyYrcezvRDiqReekEPmn0BXZDoFcZGV8KyDGLPmlmQ9zPloDsqOq1N+5PtA0OPPQzey7SaoFJljLabFn4/jsYcEzsOPr6PELTeeovzwr4igEg2JPTvbbiWvu7F+EAtgDdw20JpThlZZMeS+Td+R9KhcF7S7jNSUltkJo94M89BhzdMq/uaLTW4454Jtyqlom6LU4vRuB87CfRRFFjVbcJXu7PrdsvZwsCr1dDuxBMTWz9HfyHIFf1ZNouNToYPMN4+qm5CUC0Unyg7MTeRWI7nFbBehycDQ9B48yqSKLBUcHdevLqcG+7sh9jHQ5yMKrzOKJlbIS6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyNq/m+Jrc13tOzg75jZDHA3s827mFeET5CIqW4+QR4=;
 b=iWZY5r9blU3AmfnSiUjTK1pT/mTMDDeB9/AQUs1/GK9qC8obBntZlJxf8BDX0CkkqH0EfQZ4K2TAxYeGuezkM3LHgLcutz07iptthChXnFUWn6IN0PZcs2nDOR+Q/CK74Xg2dlgRUPVjRpC13uFfNnGtnkz46t8ThSZKfkqdSaclb61npUwsnX3IEcToqkxhgbnbxdMPogOusCpCgvB2MhWow/UEvJWR7tdioSb0IADW0hEEDw2sXP8YUJOMi47jwXo3MJXCz3Aiil7UR7RoqDil/pSUjjDMF/d4dFFLJ5jIfTP+FmdBv+tFgqaKLZehctgb1Q3DjtFgvE3mypWKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyNq/m+Jrc13tOzg75jZDHA3s827mFeET5CIqW4+QR4=;
 b=X5wNulvLs1YYo61i9HlCiGxK2ovALAeUX936VyZXUTZIfLsG2+sAkbOI4KzlmNPptT820BWxJMtC21g8hStTufkqeJuKRnmuAw+BGr7xoaJ7MNurR51VrrRAl34n6pza3dsHq+3TlQe+bQ8sVNjMv4gaWudFAsCK6MUnt4ewf00=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 19:39:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 19:39:04 +0000
Date: Thu, 11 Sep 2025 20:39:02 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, David Hildenbrand <david@redhat.com>,
        Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
        SeongJae Park <sj@kernel.org>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <d507dc89-e6b0-4360-bc77-1a8bf74b9134@lucifer.local>
References: <20250908044950.311548-1-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908044950.311548-1-lokeshgidra@google.com>
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4584:EE_
X-MS-Office365-Filtering-Correlation-Id: a86188bd-8e04-41fc-d886-08ddf16addd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wdviums3NhTpbGRVaxWWNXae7JewIyr9ukTB+EV5CU9dzkyiIF+1Tli0V2+Y?=
 =?us-ascii?Q?11SO/Lse96MbUTIYf5/qMfpIzCqIsuMA2J83G0Zo4QSZAg2hk0UYM+9aFuO/?=
 =?us-ascii?Q?ebIsa0p06ZitFa4fFTtNXELhrZHUcnKuutYm5e+P329Ro7VgiyBGBcvFp89s?=
 =?us-ascii?Q?baF/L+Y9cYJggRWgV/ff7w+xD3sV5Yp8Gtks4NfLdni3F6aGl0REvSGOn8qu?=
 =?us-ascii?Q?VxMQ2yQDptAz82SV/p5ofBfZfrE/En59o7YhgmxFzvMDL0ajpkS2smujwOFD?=
 =?us-ascii?Q?my1dgeK54bbMHpyTX+QsbHlOLJZivDmKpy1sIorjbKnPpIaIcjijPm+5qNGh?=
 =?us-ascii?Q?ftRJjqgw9vJ18F1jSsbGd/8rnJTbVDCI9XtBVcICrbhJ+M1Pw5ZbsaaY3Xf+?=
 =?us-ascii?Q?SNmhIbUlOFKNopLD0lNG6TvXrq46+uyxs06LQULiByRtJCvGyDu31diANoT9?=
 =?us-ascii?Q?LgLujayL+L2LPNTo4RwQMX4LsZfVZJNJt5GaK2I6rew5vrJaKvYXTF6c1m6S?=
 =?us-ascii?Q?ggfBy1ngaPVNX17e6hEq+O7t1pNHLV0B41LBwP8hhObJR+pPTAL6T8rGheRE?=
 =?us-ascii?Q?MFX4MH0c0+4HeykvpAIYNFdEFP9bPPJ6ktnm8dQGuXCxEciGCBb70nHO2Itl?=
 =?us-ascii?Q?jhkareKMhnf5lmzhGybxnAiVqmLhBsUXFOr2WfuX49EuqEUD90NLngwBDd3h?=
 =?us-ascii?Q?3pATSFW6EasZe4Txnh6NfdGbINKdwO9bI1xC7R6FPebtV5sQk+jpgee/FTtg?=
 =?us-ascii?Q?3pQB+TFK0NC+lM3wtwLw4DVhWlTH/gNLpWOEfsuHTeB6Pb7Cp+3N44zfp61L?=
 =?us-ascii?Q?Ig89eOUNhszh8qoXUj6/i2ofwe8RpoZChXGZ6TEvBPnIvZzmDp7ZBBUop5Xm?=
 =?us-ascii?Q?pr/jagzrDpPMdSKrlEKvPdqOh+ATZwVat557IBSbn0/2G/1bDyeK801OMWWe?=
 =?us-ascii?Q?BtxXcFX36mmt47etOjyONQrUxPPLBA6DrhLLFjuzzQFS07ejyWbR+ibv4nN2?=
 =?us-ascii?Q?T4+xxn1CzUauCQ7ppz/mUvqXcN2Owq1Fnz7qwMn1ZM5h7k/k8LU4MVMSLye2?=
 =?us-ascii?Q?D4eccWEkRAMWuWbi1iy6QOiUn/kbGCEsjPRljTWQfuLY9ZFVmHwXTZHbSZ1c?=
 =?us-ascii?Q?QoRB0ThbbEUPRUZUPDB89xzVjr1fdTMoGG+Ktgnkg6i3RhdHtYAqLsg+uL1J?=
 =?us-ascii?Q?xj7Gcu1gnhz+VRfJoUWOm5lD/0+U4MsgUctHOYRltH9T158/Zxlv/ASFDVVJ?=
 =?us-ascii?Q?TRcLXBfNBzNwd2ZGB9QXGiAuH4K0WodNxcu1zwTiqfwqEf83fFWXEwnhFsPS?=
 =?us-ascii?Q?GYI2x/kSw4VOFLTeU2tqCg+AGAAifJTQTWL4YBL8dNE7UWxUM0RBhGuLq6tW?=
 =?us-ascii?Q?94WYaNV5LU7234uKhW75A99seDy3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OrDDKVHyoggOUL1IbJAmuqIWiVyFn9qoKuEMvVu9EdlRH4TuJ+7odPqyoVYk?=
 =?us-ascii?Q?XPcbGepH6POpYM8ypVR/9ZhGhzD559LU4wGSJWuuKp0pdVwOxWotQgfqh6pU?=
 =?us-ascii?Q?oL+GtMbYRvqzaxOb9uGg2f565Pp6BQEk+6R3eMg0rK+4etfKCjhThr7jPReQ?=
 =?us-ascii?Q?oV2sJ2gx0HVvYokpq18Am46Hn0S6M1x+LCU0VmZgrQgMloaCPsBw4MYfRcbS?=
 =?us-ascii?Q?c2kPlFSZrDD0uK2fGdL9xNCXVc4dM4nClRUagtWRVRZnpudpe43VNj/WbXXo?=
 =?us-ascii?Q?iKKhfqAcYJNc1HFzVec7+3T7Z2/mSe01BS35exbjv3L8cKjb1Ynf+33jMSg9?=
 =?us-ascii?Q?sXR3dQJK0vLkYVWZg65ofp2NTXgFyFsITHmq85hBAvbKK08+YfsArak377nQ?=
 =?us-ascii?Q?oYYV4ZEx1o+yKk0xGxmNwULsioMwFHhccaCuZZ4yaK1f/iMvOzUwk+htrwNb?=
 =?us-ascii?Q?djEB8B+Y7ji0ftuvc2Eli5RUDL7uD3weY2DcqBjy3GmljUAITOsHV9IZsOrI?=
 =?us-ascii?Q?e42VvOn2buwhj3sF84sSGdjLFVsA5ydDhWwKX97DW3u8JvUT4iG0n22SVBJG?=
 =?us-ascii?Q?UWNC1xCNJ0Bf48RWj+eM0Sh5a+OzfxryYg5LOjYOvMh0y5LDd+xZ3yJlY5fR?=
 =?us-ascii?Q?AYRycdolquggTe+0JbpiQIwvEzb7ZOXbcC+INN+CU5Qlj+n3aAJ5j002TK11?=
 =?us-ascii?Q?+BFEvCjJyozJ8UGyKImgRQlx+x1+PLl4BeVtvaRvHdjWkpJwxcJhAXaFMPFC?=
 =?us-ascii?Q?jn3AriySlI4Db+Tyh18UiR/KNQ8HdR8PPhzR6Pj/Xgn/5NW8GwELPoFl7Gk+?=
 =?us-ascii?Q?PGHdl6GU5+aLvB1XAIvvzziGJWI48O6WiLNHviDSC26wMKrubnzcW3l8ZGv8?=
 =?us-ascii?Q?skRvcLW3dWHXwBI2uGD4IQ/Ig6FzubY6FNJMXEZDeuvUHWux44O1KdMbGJs5?=
 =?us-ascii?Q?HObzxS/H21UG9CbrBYPbSIetOZwRGSAsQcLg9YnFYn6/Bm5SJtiv19OEuGZz?=
 =?us-ascii?Q?4ipESwUQIcI4CMQlMTgh5yMf18FiTQzwKyw9F2jmB3Axg4tSmxsOWPu/0nMH?=
 =?us-ascii?Q?A9IIo1Jg7/NTfNAPOFW8YfSQHboXKaBgzli+r2ha3bh+10yzKzcqjDJnBHpb?=
 =?us-ascii?Q?mOkCsyzoAEWn4XKDxwQtmycxYw+qF1EYpwBSUBENS1idTjEuaG9IEgWvXMTb?=
 =?us-ascii?Q?ooZnJ/Ox4Y8jX2FN0DMB0B2DMZuAXgZ3UxOIwAlkUZpoT1yOfRbXSGcNR5Hg?=
 =?us-ascii?Q?3RO1JBJ7kFRzO26+2L8HoBuda+KNTScFCS4hBHpbzqrtuZfYEPJbHU4cvK3F?=
 =?us-ascii?Q?e9E6iTX2RqeclSwu564zYEQXrETvwC7M2YsbNjekAL70vkD4rj0npcXN26ij?=
 =?us-ascii?Q?QaMXAZR1KH5TSppbNKQh0K0fmaX9cKuNC6ceqs4XxWMxddLuJ4i13Bb6rvRF?=
 =?us-ascii?Q?LNu91rXL+hIDS9G2tfaXl7eeG5BgQRvtg8koRLnlDs81Ne7h1xOKRl0F+TU6?=
 =?us-ascii?Q?uXUgHdhB+evEvL8xigdVenHCI6Oms+Epal/vbq72yuagXSyGWdp5oEjapjEH?=
 =?us-ascii?Q?vOQt4g0tfJuKAQ4XW1PiRE99VUzrkDbuwnBkZVs8GJN5a/jpzbU8XhtOSrGm?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CtTNFl/7/jWiRlAlJb2lX9zRUtCanbdnaO/s0GYUPjEOYFk6sEgLBa3cY6dcLyib8l5gpaevp+/gAKiagYIuCbkBGqjAaZMEF/sSMsIRpKUVCEobKs8LK7NJGBwZrtYrH8HTsEudcAMZ9baNc3Jvs3BO3Ys7Eu7ii6XMi4UQ/+s5gZu3T9aPDJtuAf5ZDw99LBcdPp167ODPC23J4krsE5oMO39QuMptAaHsvxnCrRMKtNUqxSCqahUkNeGlfmJlQ0M/bTsp+svit5fN4FHj3pfZZVYQfg/bU0vvcQpeBiFthlWyyewXlqikCxlJhD7Q9wp4wb1kXRICOJ13UAbzBMnRH/dp5tNR4Zai3jNF9c9jBV0hO6iLAhtyHIralg2+VYvRk4E7VsUXoQO5gQXJfprty0oYi/hhlbStuF+DVL/9TI32HVyzMshcAHqwmvVUZNlv5VY4MljKrIqoqrlqq8PhhqprsiaRgsomSuB9r+TDS4LwyI1Ai6A/vibI099LuaFwlfGbbaB2H4tYbJ6ud7ZymNsM2D7VurL7/ohwVXTlhyulqEHnjPHY+uvPolXHLJEJoO7nJszCAqmNuctKY0y5nxVmAaXd+v9o3QB8H2E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a86188bd-8e04-41fc-d886-08ddf16addd8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 19:39:04.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPzjoG9PDqGTOF4ab7HgGRUAqLMOyRZ8PbnghDcCAIn0HWmfBC1aZWbo8yl1+MkNsxQvF0v7zYVNax8ASErSI29dTzEnBRTBDDnoU3RANeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110176
X-Proofpoint-GUID: noDpK_XesycqHW5fw6h9lDXgt85VWzFg
X-Proofpoint-ORIG-GUID: noDpK_XesycqHW5fw6h9lDXgt85VWzFg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX1uK0Guikc7jR
 EmgscsCjxkvrR8DldbhF6jTGueaIsPKY8y5QhUSHBOr+jPe4unJQOxNs0L7/iu2SqZCDazeDWz1
 AiZlM/HidYeEGwM0U7BVRAxgQGj3pfLLENA2dHhfFXRQnilMr9qckN/44K0oIjvX+CW4xEe6Q0U
 DdaNcyafRulI/ZEHmzmyD3f3GLhqlL+hIdPRAi0rQe/6JTUVhK64MVS3OV4E1qqLnbJavItov0W
 /bGCjYXyAnIwiFTGJ3E26bY8MCmgKzk9AugnG8R1+arLgUiT0XDxi1IQ8OZFYvYHzksXAQ9H3/8
 JcH8+j+Ncu5lP0LE8jWkzKa6ZUTfxAvYud6bdSY1EQKLSiWo+wDpVkX082EEDAZTECYFtv9+sNP
 8cQ4QhzfqPehAVgo5EJbZdVdxVZErw==
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c3255d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=7uVWMHL4QOLue78uxzAA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Rspamd-Queue-Id: 63D2A160002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6cmuaeyczx91zqzdyzqkgdfnhjwc5sjb
X-HE-Tag: 1757619555-632757
X-HE-Meta: U2FsdGVkX1/amfmzY/66nCrlOppMg5oEPX3Mc+kAUdzfbm+TWiOdM91axFHz1ixpXRoVjAxaujOmjDAIiS2w++fR/XfOp1SFoQmM8nvzP0UQZDZvORDEMQGCOHappZyuLazjVO4fv4j99fEj45wnW9iBid6oyEZZdkg8XVDjqcbFyO9dPnLep4SSBP3dT0JOGTuZ+euvUiJfnS1M98ZomTeY8Xk4zWtdfBFSzmjb84uqZBJCxwE3Fgt8vRmH1DocYcJnno+QvjFmHVz4VcN5N/ITH4aAjxyucUmD936G1cFcL1pQp0R2KKc59JsJEmZpLC4V46tnJ4WsE8S5WWPdMFpapmN59IHMU06uOXqwJN91EU91XOL4Xl6I/9yJ32iMwu+nTxB46YoTJXKMFC8bXy0OFGL/GM5qGbLK0B/JefTzbTneAmXJb03NoRyr3TDq48ydvbRcspK8/GeYlINmq1k1/ciO2y6clTBbqYNdhMh65t+dlir6xHvO9z36hXiqOLBFAW8UbKoJuAUO11DT0te7RPvUiDGLLAokmFYhvEm+BlCX5Lrhha26OEe+AZFy/mi8GJ9P06ZyL6Wxgms9+2amOQ/QMKXfMJWEWHtHUtYbnxUPoUHU72cXuG3JatJ8ya3KXmTskKhL1TYqHWQdWEQWJymw0Whb7GkyLxVPFqwpYM96G9tkNURKEmX+YBM/56MEH2kjGtG6zSmhD3bV7yZbyz5QDthtnXIbOTHHlxaLhy2kVEjpHXPqyCrbqgHU05VsgKVBaWrMUQO+FYVCqu6ipacA/oSrDFJZVFYZgcQlGm2ynZVNtjKmycys15Gxertw3uGF7WNTWMByZs6suWJeMC/DpRFY2hp8GtsCOCj5ehtxUXSXi1YAobX0YjtmlhA6PoxXuj9GKCiCbZeVz1HIdc/1ecZrlk3SwWqXRXUB0f4NP9rkS7TaPABXSyg6aBdWOqyHpMW79Ncf30T
 3vsm8vTN
 iVKLDqTaCSjAuJnfyFZ3N9wX9anpL6P1Gje/qTLA/gPs62MskHpq586SpesbRqmWKAaPQrrxCcauWsKOn1NQeXg+4mLu+c1iR9r1+5PZ3c7rXzaZY7oUSGMY3EG4obQguW2Zv8uoPL1SbmUa56dxxWPaAQlPx7CFh0j0SAc0dZa3PFN1yWQ7Hunpoyf2ADo8q0ySUSuzGXHxO1Tw6M1tyd9OKwxwsUjumtal+KujcNM3TZU71F2fY1qlljOfMVdFxuFlQRg4E9AOT0jM6/kxCw96TYw+ntrsXskihp3WarPeY0ff2mIpQoxdtf3F7Vzv9AbVpCoa+g7uFDD9Wn50xh2NmNFUJ6si5C8Iox0i+eGtlIAvlYzXIKATaygLJhFhuTMNXX5qcOlZHDI50nF2KLdT+fSJ099/BtlyLRKYrIt/KEf2Z3hzaZEQ0QcqlbWpKcbjm3D8/6y61f3Y5ljh90/8FOBFLwOOrWPfAiFvqnPNYJSoKw/OHK8rPThRQEiWAa2CqWQTek9jZb8KdpTqtNPvlp0AFCYp8wgpyHL7wKwdCLRxqDkxPjflq/xGrvV+u/icOlTkQtpLbfZ6d7UOPMGR0JLI8srLeIU0q1VTI4iKvwqaEU5vjkuBLRIzNMGKoOyo0Jte2m2J28xExTLD8r4SmlHWifbN+10j5uUcrNoR8P1TZavwyijeePJ1Ff87cfIImlXvE8XhGQrvAazuNY5Cdn2aGecxBz5eMp/emLUAiCrxHH/er3ZduGmWlgzqg21pp+YRhgZXGdwlfbva89lfuyEyrTCUH3Yfjsu3jWboIs4/ZPEXAnrq8u9zH0VuDOeJluHoGuJtusK7+N/IuvlVsWPk9FcwV7WEsl/0SEnNUfn4IgdvY92eU1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please please please use a cover letter if there's more than 1 patch :)

I really dislike the 2/2 replying to the 1/2.

On Sun, Sep 07, 2025 at 09:49:49PM -0700, Lokesh Gidra wrote:
> Prior discussion about this can be found at [1].
>
> rmap_walk() requires all folios, except non-KSM anon, to be locked. This
> implies that when threads update folio->mapping to an anon_vma with
> different root (currently only done by UFFDIO MOVE), they have to

I said this on the discussion thread, but can we please stop dancing around
and acting as if this isn't an entirely uffd-specific patch please :)

Let's very explicitly say that's why we're doing this.

> serialize against rmap_walk() with write-lock on the anon_vma, hurting
> scalability. Furthermore, this necessitates rechecking anon_vma when
> pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).

THis is really quite confusing, you're compressing far too much information
into a single sentence.

Let's reword this to make it clearer like:

	Userfaultfd has a scaling issue with its UFFDIO_MOVE operation, an
	operation that is heavily used in android [insert reason why].

	The issue arises because UFFDIO_MOVE updates folio->mapping to an
	anon_vma with a different root. It acquires the folio lock to do
	so, but this is insufficient, because rmap_walk() has a mode in
	which a folio lock need not be acquired, exclusive to non-KSM
	anonymous folios.

	This means that UFFDIO_MOVE has to acquire the anon_vma write lock
	of the root anon_vma belonging to the folio it wishes to move.

	This has resulted in scalability issues due to contention between
	[insert contention information]. We have observed:

	[ insert some data to back this up ]

	This patch resolves the issue by removing this exception. This is
	less problematic than it might seem, as the only caller which
	utilises this mode is shrink_active_list().

Something like this is _a lot_ clearer I think.

>
> This can be simplified quite a bit by ensuring that rmap_walk() is
> always called on locked folios. Among the few callers of rmap_walk() on
> unlocked anon folios, shrink_active_list()->folio_referenced() is the
> only performance critical one.

Let's please not call this a simplification, I mean yes we simplify the
code per se, but we're fundamentally changing the locking logic.

Let's explicitly say that.

Also I find it odd that you say shrink_active_list()->folio_referenced() is
'performance critical', I mean if so, surely this series is broken then?

I'd delete that, the entire basis of this being ok is that it's _not_
performance critical to make this change.

>
> shrink_active_list() doesn't act differently depending on what
> folio_referenced() returns for an anon folio. So returning 1 when it
> is contended, like in case of other folio types, wouldn't have any
> negative impact.

I think this is a little unclear. I mean it very much _does_ behave
differently if it returns 0. So better to say it treats folio_referenced()
as a boolean, so if the folio_referenced() call returns an incorrect
referenced count while still indicating it is referenced that's fine.

>
> Furthermore, as David pointed out in the previous discussion [2], this
> could potentially only affect R/O pages after fork as PG_anon_exclusive
> is not set. But, such folios are already isolated (prior to calling
> folio_referenced()) by grabbing a reference and clearing LRU, so
> do_wp_page()->wp_can_reuse_anon_folio() would not reuse such folios
> anyways.

I think this needs to be expanded too, this is still very unclear.

I think clearer to explicitly expand upon this, like e.g.:

	"Of course we now take a lock where we wouldn't previously have
	done so. In the past would have had a major impact in causing a CoW
	write fault to copy a page in do_wp_page(), since commit
	09854ba94c6a ("mm: do_wp_page() simplification") caused a failure
	to obtain a folio lock to result in a copy even if one wasn't
	necessary.

	However, since commit 6c287605fd56 ("mm: remember exclusively
	mapped anonymous pages with PG_anon_exclusive"), and the
	introduction of the folio anon exclusive flag, this issue is
	significantly mitigated.

	The only case remaining that we might worry about from this
	perspective is that of read-only folios immediately after fork
	where the anon exclusive bit will not have been set yet.

	We note however in the case of read-only just-forked folios that
	wp_can_reuse_anon_folio() will notice the raised reference count
	established by shrink_active_list() via isolate_lru_folios() and
	refuse to reuse in any case, so this will in fact have no impact -
	the folio lock is ultimately immaterial here.

	All-in-all it appears that there is little opportunity for
	meaningful negative impact from this change".

And now, having said all of that, you can talk about simplification,
something like:

	"As a result of changing our approach to locking, we can remove all
	the code that took steps to acuqire an anon_vma write lock instead
	of a folio lock. This results in a significant simplification of
	the code."

:)

>
> [1] https://lore.kernel.org/all/CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com/
> [2] https://lore.kernel.org/all/dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com/
>
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Harry Yoo <harry.yoo@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> CC: SeongJae Park <sj@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---
>  mm/damon/ops-common.c | 16 ++++------------
>  mm/page_idle.c        |  8 ++------
>  mm/rmap.c             | 40 ++++++++++------------------------------
>  3 files changed, 16 insertions(+), 48 deletions(-)
>
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 998c5180a603..f61d6dde13dc 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
>  		.rmap_one = damon_folio_mkold_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>  		folio_set_idle(folio);
>  		return;
>  	}
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return;
>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>
>  }
>
> @@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
>  		.rmap_one = damon_folio_young_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>  		if (folio_test_idle(folio))
> @@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
>  			return true;
>  	}
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return false;
>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);

Oh wow damon did this too... Are we sure we caught all such cases? Have you
checked carefully?

Hate that we've open-coded this all over the place.

>
>  	return accessed;
>  }
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index a82b340dc204..9bf573d22e87 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -101,19 +101,15 @@ static void page_idle_clear_pte_refs(struct folio *folio)
>  		.rmap_one = page_idle_clear_pte_refs_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
>  		return;
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return;

And more open-coding here, god. Horrid. It's quite nice to attack this actually.

>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>  }
>
>  static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 34333ae3bd80..fc53f31434f4 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -489,17 +489,15 @@ void __init anon_vma_init(void)
>   * if there is a mapcount, we can dereference the anon_vma after observing
>   * those.
>   *
> - * NOTE: the caller should normally hold folio lock when calling this.  If
> - * not, the caller needs to double check the anon_vma didn't change after
> - * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
> - * concurrently without folio lock protection). See folio_lock_anon_vma_read()
> - * which has already covered that, and comment above remap_pages().
> + * NOTE: the caller should hold folio lock when calling this.
>   */
>  struct anon_vma *folio_get_anon_vma(const struct folio *folio)
>  {
>  	struct anon_vma *anon_vma = NULL;
>  	unsigned long anon_mapping;
>
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
>  	rcu_read_lock();
>  	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
>  	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> @@ -546,7 +544,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	struct anon_vma *root_anon_vma;
>  	unsigned long anon_mapping;
>
> -retry:
>  	rcu_read_lock();
>  	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
>  	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> @@ -557,17 +554,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
>  	root_anon_vma = READ_ONCE(anon_vma->root);
>  	if (down_read_trylock(&root_anon_vma->rwsem)) {
> -		/*
> -		 * folio_move_anon_rmap() might have changed the anon_vma as we
> -		 * might not hold the folio lock here.
> -		 */
> -		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> -			     anon_mapping)) {
> -			up_read(&root_anon_vma->rwsem);
> -			rcu_read_unlock();
> -			goto retry;
> -		}
> -
>  		/*
>  		 * If the folio is still mapped, then this anon_vma is still
>  		 * its anon_vma, and holding the mutex ensures that it will
> @@ -602,18 +588,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	rcu_read_unlock();
>  	anon_vma_lock_read(anon_vma);
>
> -	/*
> -	 * folio_move_anon_rmap() might have changed the anon_vma as we might
> -	 * not hold the folio lock here.
> -	 */
> -	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> -		     anon_mapping)) {
> -		anon_vma_unlock_read(anon_vma);
> -		put_anon_vma(anon_vma);
> -		anon_vma = NULL;
> -		goto retry;
> -	}
> -
>  	if (atomic_dec_and_test(&anon_vma->refcount)) {
>  		/*
>  		 * Oops, we held the last refcount, release the lock
> @@ -1005,7 +979,7 @@ int folio_referenced(struct folio *folio, int is_locked,
>  	if (!folio_raw_mapping(folio))
>  		return 0;
>
> -	if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> +	if (!is_locked) {
>  		we_locked = folio_trylock(folio);
>  		if (!we_locked)
>  			return 1;
> @@ -2815,6 +2789,12 @@ static void rmap_walk_anon(struct folio *folio,
>  	pgoff_t pgoff_start, pgoff_end;
>  	struct anon_vma_chain *avc;
>
> +	/*
> +	 * The folio lock ensures that folio->mapping can be changed under us to

Can't? :)

> +	 * an anon_vma with different root, like UFFDIO MOVE.

Not a fan of this 'like UFFDIO_MOVE'. I mean here I think we should just
drop that bit.

> +	 */
> +	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);

PLEASE do not add BUG_ON(), checkpatch.pl will warn you on this and it's
not something we do these days pretty much ever. VM_WARN_ON_ONCE_FOLIO()
please.

> +
>  	if (locked) {
>  		anon_vma = folio_anon_vma(folio);
>  		/* anon_vma disappear under us? */
>
> base-commit: b024763926d2726978dff6588b81877d000159c1
> --
> 2.51.0.355.g5224444f11-goog
>
>

Cheers, Lorenzo

