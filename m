Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFF4C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16B86B007B; Fri,  8 Aug 2025 05:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDBF6B0088; Fri,  8 Aug 2025 05:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5516B0089; Fri,  8 Aug 2025 05:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC8D36B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:50:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79CCEBF135
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:50:55 +0000 (UTC)
X-FDA: 83753121270.02.CE0F9A1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 28CCB1A0004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:50:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zx45Vg0O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fZlkDQst;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754646652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXTDJ5ugWHr5W07hPrBXtZ/TZII2ohGUSYuAWB5IsXk=;
	b=F0VdUBR+MwpQicBAP+5tos4l9ga8OzsxlJKoHV7Ebrv0iY1bq9Qf6XIg6fXWWzUPDkwdk5
	MBnm98ZxdcxlSf4gfOzjPa0YUsXDOSgc4M/RyKCMySlm3C6VFkms0seTJEYHy9ss5ACeDM
	MB4HLVJtL1cak6XJvCsil4r5grZfgAQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754646652; a=rsa-sha256;
	cv=pass;
	b=DRrs/locLkHUK0ZdYMcBZFqisM2vtw1MAty52wDPj/02gf5a/V7v0XOVMl2P2qKbAJVOWQ
	54Xzi7Jpu3UusS1EYUJKpp6YSfUJG2tysT2nRE85/+RR63gTv3g6ENjS3/L8xWRw/QgJM9
	tTYrzNU7fDBCwrXLXct34EzodJ5Qz90=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zx45Vg0O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fZlkDQst;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5786YdRf015244;
	Fri, 8 Aug 2025 09:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YXTDJ5ugWHr5W07hPr
	BXtZ/TZII2ohGUSYuAWB5IsXk=; b=Zx45Vg0O9BauLLgr0R2xFNU5b0JvrBGaKf
	RYntnwnuVNCOuCmZGfWxaBWquFn38axJe373a93yfaNclQwNkRsdC+niOGFd4mZu
	l/FZLz4+7h0O/3q2hjqrq6jHkud+Ak2ou7cVOdquxXn2jA4E3D1fqTGLngdgRkBK
	lBXttMZOm8vFH76l+Ej3n46jkd7VU3e/jsozjneRHlRxfZHv9DXs5nxFR49S7556
	bNvdSsR2fJcBMs+lcgR4ujr2TVC8sQOBYE9ELY0tc0ZOMgMxRlbG0Uz9c2Wbvc2h
	fw20L3xk32+SUAYFMHpiT20JVKEhjEdstJCmMAlS8/Kzi9UJb9QA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve5xtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 09:50:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5788ah4E032139;
	Fri, 8 Aug 2025 09:50:45 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwt335j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 09:50:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jme33jw09AbJORv8MEMGZ+UEOerBnr5Sb4jWJhlQxdPx1OsRUDSnwx9ut2r9+O2xMyRFuPyGTApR7D/B83OxvVwMtPqEjkYnT4k7oaTqAFI8DAHqhqIGv4p5zp/KxpWCb+WUCkQo+N8FhZGFYoRc19w2Qzn7sDo4eF/qHSkaTIgb7j9FSUGerRXTUotk8nD0rGACfjmxlvxfoo/SBGV1zCO20t8sEpaE6ug8VRB1kn8XTjzuo/XAvJokpG4bU8Oc8VLpwwoaESNGsNIOG2er6zrTvwxzNsKhaKXk8ByqQ9+LL9TnHmEcn4p4dO+S1eKaCS9Zlv1BDR/Uy8HU/7Inzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXTDJ5ugWHr5W07hPrBXtZ/TZII2ohGUSYuAWB5IsXk=;
 b=v9UUeLKMu3ZiTA9Z+AvJ6FYQTZ1PWYdyAhCuIpsFV9mfW9fLXYYoSEpFz2KpJRIAF+rS9kYzbPkPPN5c8AHlF4SB0jH9x1Gf68kQ8XJTmfoDNWRsN7SYHbTMlDNZonPSpczWl1+qAlFST8vGOOz97qa6WJo/iMMv9vBJykRZZNKwrdHbzFXRXByVzS1BNscv11A393ILWW/QCpk6D80ZgOoYVgLC/KLAM+VUtV5AeGZAATqhFAPUzxPkfTSmPuxXlR76ksvaxFo0MWX+VdJ5vbDzOp0COgvVRRw6MyHPGntI56xLan2GAwgvWeLkd8NONWpj1hWkhYRPalkDOQ+YBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXTDJ5ugWHr5W07hPrBXtZ/TZII2ohGUSYuAWB5IsXk=;
 b=fZlkDQstA8Pq8gUhh4YfyOt4f6oGCFipjyhmIZePPh1y28E/VYNi4n8CCJXp80tHB0I3vpqJyEK0f958zAqV7cZqqBn5jwXanabQIdAPfyg50idfwdYhw14GuH8dItcgTluxdGzYqkelLsT8ayeIFRrQYYlZV0jYpiG5cCfluhI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7086.namprd10.prod.outlook.com (2603:10b6:510:269::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Fri, 8 Aug
 2025 09:50:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 09:50:42 +0000
Date: Fri, 8 Aug 2025 10:50:39 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <65dbee91-6f09-4bf2-ad5f-00ac1119c2e1@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
 <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
 <303b1764-6471-421f-b4c3-6a2585cee2ae@arm.com>
 <b0d257a4-a37d-41da-92f9-4d1c0a11c30c@redhat.com>
 <8391c672-1123-4499-8d28-a731f2d88a9e@arm.com>
 <20cc4429-58a2-43f9-87e5-959980d7ba5e@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20cc4429-58a2-43f9-87e5-959980d7ba5e@arm.com>
X-ClientProxiedBy: MM0P280CA0064.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e32468d-beef-4d52-520e-08ddd66109dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?28dqgd4ribU9nZ14gSUy0aln249SkP1rDiXbsDGOa4xkzVNHVrynqQP5v0a6?=
 =?us-ascii?Q?auutDPylyC4nwl93vAGGpLCGa0Gx7yp7WOwqd6yglFQT21DaWB/a/lQDQrOz?=
 =?us-ascii?Q?omPLaO1Z9oLDdBKAO/GYxKYYK7nJRO5WiekqfXjxof/pwbHCWdXhBcAj616D?=
 =?us-ascii?Q?u6n3yhMJzB3p25zrcTWWZe5ZfZDOamNuoDUhQrA0yRgw8lurGRO2RNxKFSaK?=
 =?us-ascii?Q?kxz5lp0RfAimvwBeE5pw3POhFWddHnB1EpYUdEGL2Zq7c2DyRJpwO0MRaxpV?=
 =?us-ascii?Q?mDxruGchSUx28zwk3QV3ziWNSy1dlPo+bBBLrCtKBWspRKsAAnuzGwAz8NuS?=
 =?us-ascii?Q?rjCYcbzASKrwumF8ZJ1glXqcfIPji6E6P03e7zsSVcsnKCq2Kb7hDRUfzZZC?=
 =?us-ascii?Q?L/ENFuFZmbeXbBQLJlroxG9UiGZKEAUbP0kEExDb2dFO6IyDLyPAirtIK/a9?=
 =?us-ascii?Q?WvaoEw7y+ssmmKf5tsuAotQyumwcKKfUPtbfR0AnkuEUb6ge4EbiNM9XI4D8?=
 =?us-ascii?Q?kZSUgouatZ4ZgJ91zcGGsvo38viExgEZL0eocB623RnyTSEKKMtdyQ4gz2gp?=
 =?us-ascii?Q?ReNSK4gysMFdpYo9eaZMPMag4h7NZmzD4n9cGVsHS41dQcOKKzJw33+Fd70j?=
 =?us-ascii?Q?pLpQUL9TcrVAA1E5Yq2hXQCZObR7GMl7Xlj9hitIxisx0PEWaKp4FX8a5NRi?=
 =?us-ascii?Q?36009iqcXumAnAgo//gtJL+5kXZSiMRZ7vj8uRkmj1QlrnDEUlS/+M/nuz/i?=
 =?us-ascii?Q?0V6jmV7s3ATOGPf7h0tzHehp1Zr0KnKhDzBPWJVMiK04dJ1G14mfI4kr2ZwH?=
 =?us-ascii?Q?tYzXImJt9jXrCuF84tfBk6bqEpi3+6NWZoCEdoChVObXMj7umxyaR3gFyS8w?=
 =?us-ascii?Q?jZ7B4flFsMjXlxi2Ik8g6go95SBYLEwoWWq/rceaVTVFaT4TAiXLdtW/1KY/?=
 =?us-ascii?Q?BK2DXaFLN3pQX1mwL5kc8rgO9fKrIYEegUK7k2HosjgF9Z0kvBW6ZGNrjfey?=
 =?us-ascii?Q?3jzftbwspQipQtMjp1ORMkV/gP8JY8g2jCjgMG3ziIS2ChAB0zuUpBgR/Pad?=
 =?us-ascii?Q?FOkdyV9ej20faaCJP6on76vk1FkH81So474Dik6stdqmw7szeehjkJ0FT5B9?=
 =?us-ascii?Q?8bPfSbEYsyK5/omOi6yiEuriqqVKmCh+JsCXDSG4oV/vZtGnJLFJkLrzSGx0?=
 =?us-ascii?Q?G3wLLyBs5XfiSpMDRKAthrlvHQWTxodFdQaL4dSAwS8eHUlGLSv9+jBBqUAF?=
 =?us-ascii?Q?+BRRXMAz6HjDO05Vn1S9cDzl6jmuoo6+8aX98VDysRL0QAli3ssFHIxFm7Yj?=
 =?us-ascii?Q?10wekc9ncVfOy6fNaQ6SbTi6qOP56ZdDj68nhugUmljAJeEDGHAL9VWOunPp?=
 =?us-ascii?Q?yGRGclHaiXe4eY4KTeM8wQfkvlfvMrEDw5VmtO+w/ndByTNiEojFFd4f7q2/?=
 =?us-ascii?Q?Bk69RMXiYz8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VlB8A/mU9jT3TBoSiT8HtEALlogG8mmT5UD9PbMbsic4Yd/KSKkBCuOaVJ/F?=
 =?us-ascii?Q?81VxKTG/j7F7jj31VsuekO/VVC1osxUXF5oSEN1Gm5SL8TiMKtcmb0dFgLqr?=
 =?us-ascii?Q?XjVHKoQH6q+sve0XJOvv9zUzpPeWbzlfY0mNT/ZYE0uAfwayjWZ0zrQ07dtI?=
 =?us-ascii?Q?CyW4ZvFlQm8Zqw/Tj+87PzhGLiyq2fUoxPf4LquQDZmBHDyN5GwT63KEA8I4?=
 =?us-ascii?Q?WcFvMU8atMRhTtQIlAifv/ab8rOcQ7PHGhd8uGwxqRtiWeX7kGgBmvP3LShE?=
 =?us-ascii?Q?XTGkEo1frxk4q5QlUBoloInBqIhLQJy5seApQvLZmRmFpr2MrswWC/193/9o?=
 =?us-ascii?Q?Gi9uo9hOBRTkP2w3D4y99MPQ4Xsuyg2+ecFypE3IQ7dbEBbhid+6k68iGW+K?=
 =?us-ascii?Q?vlTSxW5H5B6lhCPbt06I1+4tER7GJ+F8PC6e4wZg6Wh7Dgymm2LPCggPJdCo?=
 =?us-ascii?Q?bq/3GoQec6mZfpO7PXOygz/NwEFeJ5vEcg/nMjC+uXbvlNiFoO8PVa3R0ggX?=
 =?us-ascii?Q?LF0LRVRJzkjDOR+vWkVpim6uXiaAuJgzKApTa2vcYCeP8g1+ra2TZCRsQ3ZT?=
 =?us-ascii?Q?9vmjT5zpx5dg7Lqf1pAIwfWd7LqeT9S3J7WqI0ejefqVXUqCCWs59ELXJ+Ry?=
 =?us-ascii?Q?HL7Ey+ZcuI/rzx394rOBmPO8XkE1naAQar7aW4xNcS5wweWCYvcoBsAwi+X6?=
 =?us-ascii?Q?0eng8GMn9i1g6Tz8jSRvFgb/kdXqNrN7SNJwR+qb994SM+EJbU9JS0fq4Arb?=
 =?us-ascii?Q?kHh9hLyr5upogBcT3/9A/aAsVewlL1YbU8kMOMRpYcXHA9lqUywLg3k2gS/p?=
 =?us-ascii?Q?XXe7lVD7wAgtEOivCYG2aE7E5l5sKM2Sv3QB/AbDvOLCujVpApqCy2v7BP9D?=
 =?us-ascii?Q?FfenFgsUM8kFRUKuhwMBqOobgVWKXSZXy2RTBhK6qHneF8vIBql8Z+z+jI3N?=
 =?us-ascii?Q?UlVxOww3a1RUi8USBZtBJW9LJwFcS4BM6DiNt0lVIp4DW5rfy+R7mqHmzwyp?=
 =?us-ascii?Q?BKXl6Wkl6raKqvna8QkyIygrDH7N0EMiSdIxvqLdi0/KZljujHVNp9f+80sa?=
 =?us-ascii?Q?BHKDBx7eQXjziAnS+RZJDBJ3k2EC+8dv31oPQgm0cNOVKBSPrkNXPcaFGedk?=
 =?us-ascii?Q?Y7H6KPwwYKJFQUQyxVLxzJn+MgAScIcQxkdThdR7wpHsTCoQTC81nc7IgCE8?=
 =?us-ascii?Q?NPMBlkfFhmR5CZl8xGut9NQn14scpQHmERNkB7VTmtdU7yYsEfqpecuYqTc4?=
 =?us-ascii?Q?+H5eyWeNoSVfbzvN2qXTIDfnd4px5NZO31Q3VmKysc/pDynj5IZD/NY+ryUg?=
 =?us-ascii?Q?SrQNRy2wu4UUPjoJDRpjJWzwncLQR5MBHTZbG6DF6rD4SnuKJQAwiAm4VAeW?=
 =?us-ascii?Q?oZz+7xVojfTxo9B/Kx4VNdTy/0LWbPYjAijvVj5vIqdkq32ZHQAy5ltYQf1l?=
 =?us-ascii?Q?iq2JKgn+BvI+3tbbB0f9x7PXNB1ZwTZ3MJ42f8H5vhgwmTZd0PPHOaVNK8+E?=
 =?us-ascii?Q?Wd+rSbrQU4YvPbcCZoud3C/l/4WkmYAOzRAVycRn9K3hYCLT4GdoqfWPmMOE?=
 =?us-ascii?Q?UGszYwvQWC/cVMC7v4uvPkUADsOnwkDVv1gCxxoRkgWto5sUxaznvJluA8y0?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	61whDFsuW343F0c7lSEwdpiPLATtupMalWu0bummXc76MtNB88JdUaNrtgKqCvrjXNNGsDi31rhlwk4tfDA6NS2AeZK6qJRb6Q9EFaHYmig3ZZzK20EXjT7q8bbJUn0UApDEzB1jkSUcdUlEB7r2RVTKHUd3RoVdGyot2IqDLWMYT80xUbNCW92JAy50F+F2LXviOyerjK+hCTpK0Jcb2MSqQ74zWERwIGwR85fD1mHlzl6zziHmi8KQYI+4BPHEhC25hczfp2VzXv8JbvZ0Xar654xP47lmBMjIA1J9FdCDRX61G+O0SQQAACMFtOf9tBK6txehA0Lg2HbnNArwffAeNBBnlZwisnnuBXIQg/xmRM3Nhr8EydEoicNIz8nUCHp8GegpUEV9CTc2B/6wTEL+wx/MpI3ASAkhHckP+Lhaiv5xi2rJ4Zlk0QlvO3prol7uffTJANyL8qk2V0s/B7bSDF6ALK+0ZYfmgTMXNleSYi2fSdR2bPmHIjEHodft0UtiOgh7c824MpwvgnpizqRuIWMknrtxvPMPIaZNHyrbUtH67RXAT485hN9UHX/bJNi6TH+IUrxje8J7MVtwSb7EM8jrqMUr8xizmlctUHo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e32468d-beef-4d52-520e-08ddd66109dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 09:50:42.2694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1D+mTvHQ+VcHI3zM6uwDishd75pVb66Ph36ziCeOlJ81RhJ59I7JVvOO1dkxHd8d5oUF7yZA2BaNJc6Smc/9fkxWtjkejuJaIscrQCwoho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_02,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=816
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508080080
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDA4MCBTYWx0ZWRfX5EERM/a+3c5Z
 +JxijavHql7dYjz0IS/IuZ57Ux5Y4cjdQa2LlE2rqbQPpRes8D8+mi2P434JhWLwNvozeowsNUN
 Zt35IdP5tAn1vDQHR7I9OmL6jJ9eb9fT4arNqStM9atYNhp5N/Cz2dGS+APhGfNhD/YXKzV1+no
 zmlPStPE471iMCSMS2GyBtMVlq+4T1GiUHEYV0y8yeAuTGn8VxWibTxhaRVcUcZl8xwkmb+50tp
 RfbpOJqtbzaUWiT3lShFTmpf98KhDBFhOTig3cCcqswiVDpxk0ZgoU+t11l4sA3GNf28LdizBMf
 JgY/h0iH/aad5wztWg3yhnsXL5hTXU974aQ2WUzwIud58yjwq0yGlAG5XO0/ipstYaSTSWNxVcv
 wOU13Rftk9BrVWtydG7eCrKzMLp+TFTOnPi18q1xWiEmg/4cbDN+xEOHVwzjsO1BeV+OpaFo
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=6895c876 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Mu58CKwKYmu5RTtqKFsA:9
 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: oLPzALxD1ecdp2BzibPA3ANi5FM8b--4
X-Proofpoint-GUID: oLPzALxD1ecdp2BzibPA3ANi5FM8b--4
X-Rspamd-Queue-Id: 28CCB1A0004
X-Stat-Signature: sbru7e6khihorzj95opc4j4yadwumfdg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754646651-240151
X-HE-Meta: U2FsdGVkX19jpn5XRZbAlYd+JAfXgKqslVdNdxlj1JqkKbdUyBA6udnEaWnh2KwO2C/dkAf8otE47NFLDM8Hh1GswQ7YXLFXtzKWJA2dgC+qbr83xBVYjCTAqXD8OiXTfEFCac0EgcQvEP3YDGtlDzNxgQNtnFrkDkm4cUYMDBQAzhRF5tPk5KPWZRxy1GkTxB7cRF1VPfs925RmhZ3ydHCwWThlMSsnmE/uOqlKBhgHf8M5JbJ7l1TFXhQUrk9Y0sTfIobnrEqyy8sFfmlEMwAEkMDLOQHJ1lWz28b2/i8Ow0z/otXmhFtzbAG5kHub5ibdOMo6c8Q8lUSRCCpc4Y1MNLd8fCEPIk7maj2NWNJG0Wxvx8Rh5MtwuxqlIpsgJRbkY7Sxxc8tvtcYz/fM2SWo4+YoxlVVyFyQAKkgB1TmNslG/sBUaGb4iAcUxBFHQ9gOqMbfWSiI3xFtlP2z/K+w8y3elBK6twAhS+Lq99wHkmnijcKJw7wB18zuTYJ7OdnKFQXR+YCV2lrN6aOFtJURI2nVcDKjIJuV8m3P/sVB42yxZmWlRlH7ENiDoV23zboA5CSSr/6CJRcptMLUcKV/g9HAmtEd1nClpeu67xabAndg/ab9HvK4FWcYPHrYyDItw/yj88VQylPiMj60OM/m0hd9Pf08OdSeD6j3avB09A8vbhaesQhUr3CLq+B4KYxbBxd1/QE3/UAq34AdeQUprrYke9VdzleZFH0Axkq6qGELCzAvpGiHRJEMPm2Io9Nc0s8Ugl2ov1QReEt5LmgYue8sAiSMdNqsqKiR0XmCXjfzEzCrtGB9Vb7gedHLT4Ms0jw17vrePbfXu8WJzhZmh1vHcoCsvI9FjziK+wodHRvKL9xJCmFWIdJgCYwnQhOFUALHlKU036/fTKkUsiaD+iBnchzRa5u8DKiVyR96XRINmHo9N8LOJpwKmc8fYWpj/8rpKStFmpYb15n
 MYY3sjUJ
 h3BJcB+eF+tgHPJ9cmpJwaLkupQ0KK7FiqpKJSjqB/jgw8AH7EK/9nljF2aF8x6lH1hkledLEyVQqX173pfGIc4ZvlU96fwzFkv2JocorL5whjOxl1b5kVzK6zydtqwhT0u9bUm5GOhYvukZMlryUPhrlXEKqnfbEpTOqAeCZZD1qP6Hz3fT8vrvoFDRqc7ejdC1BEFAzZ/uTNOIsEB5UV3wpYYGocAsS7L5w/uZio4tJJxnn3GLsUOdW5BJmeCX/Rbv7EMtAi0w0C6PeLN7/LZxgNnAHs/9iO8lQTotxbDf/Yi6Dk1tNsWoI/M/J5ol2USWGWw0iMwOKiV0l0Ac5lvaiQp73PrOezlCTxjP9rdRgWQvNwCyAgZfN46Mmm/Svef59D2g59CsZjCnV8T9pbNFIySuR0JL6unNXD7R5t1hKh0UqR5ZeyjsUWVlW/1QCsWCbYORxPoMdfo0nEQq25lNQHWMUKEK1HwkUZwt2AYKo5cXgbRor5OroUfs4CjwQLA7ymSofsVXWPRogN0kvsyO5pZqqMkHARzJ1bnbW+FEcOAPuj6oOQo1Ohvgtc+4uQfjJLtkYFMirvmqk6aYyzy1TFJMyN7TCYtlMRNQxphsSSHuqiQA36n4t64eJcJEPryJQ0lRKDk0aGskLxHJy5kKAOCv8oONkxRG8uX57c+lRPZGUvoq/iIORqifcK/Bg/1MYiD3dvWTvf3J/jJaFT5/3sY0Cp5SCVVnwfsooNULKXe0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 02:14:08PM +0530, Dev Jain wrote:
>
> On 08/08/25 1:26 pm, Ryan Roberts wrote:
> > ACK; Dev, perhaps you can take another look at this and work up a patch to more
> > agressively avoid vm_normal_folio() for mprotect?
>
> Yup I'll investigate this in a few weeks time perhaps - try to use pte_batch_hint(),
> and when we have to unconditionally retrieve the folio, then use that instead.
>
> I'll also look into whether even for arm64, there is any use in retrieving
> the folio at all - the only benefit we get is to batch across contig blocks, but I don't
> think there are any atomic operations (refcount/mapcount manipulation) which will be saved.
> By batching across a single contig block we save on ptep_get calls and TLBIs, which was
> our objective.

Ah nice, if we only ever need to consider a single contig block this makes life
a lot easier I think.

