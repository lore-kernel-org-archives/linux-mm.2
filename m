Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 673EBEFB7E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84606B0088; Mon, 23 Feb 2026 21:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EC66B008A; Mon, 23 Feb 2026 21:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC05D6B0095; Mon, 23 Feb 2026 21:07:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 956A16B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:07:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F9F0B7E13
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:07:30 +0000 (UTC)
X-FDA: 84477713460.27.7A2E4AB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id D97CE1C000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:07:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pjc4nFYR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TAK7breL;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+6GkJYs0gpnTgJdpwnkMwTKFeX+W9UZMecVv4BC3Mg=;
	b=OY3FPraL/okhldCPdJ3E5aGdbhTVVNIX2miBlmPEnY/gvV4g9tSXNDhIPH+k22mzsTcqxn
	Psjoch3WxNlkJMOouQ3tNEeTB4VkSQVkyY9Pk/J7LygbM9lCaucslDFA5r//KFjKGsXyMv
	yi9XSIoiAPH5DjUP4MfATvrGGG3cCAo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771898847; a=rsa-sha256;
	cv=pass;
	b=XcW6VqE1p1rDz6rOwXPC1/G3JbM1q6nJmaj+gaJ9tqKymN66CBiStegGORW3zT9keNPlM1
	dCZSklh8DSvkqk5N4FMHUPYBw+ftf5aY7WR1Rhwj/2qwhU2D1xpP2mlPKjAW9l8+M1qg4v
	h6nM96kTwj1f7HkpVTS5FTZBKhYKN04=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pjc4nFYR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TAK7breL;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMxMk01962452;
	Tue, 24 Feb 2026 02:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7+6GkJYs0gpnTgJdpwnkMwTKFeX+W9UZMecVv4BC3Mg=; b=
	pjc4nFYRslV+x/3MVPykecFmAG8rFHVh7vTAiIwjWOS09crCG4dIiKRpo7LDMsb4
	wJBWlwuYiyuOyQDk8a+OZjjw6bG6U5yqIHWLXLyzYquYgIgYNLfTb93WV+J52hWv
	bmq1iY2Vcn4/qfofjIxJekEZi15lmAGa2w3ZNdFFlFkfKXyjv27PkWCK8ktK39tp
	I+gwQ611o8RAt+C0t6E8Y+BbHFhb1I7Nu9HhTY3f+oicdsMTvifPYeoC419agj/M
	zNJw/RsNAixtvGkp2rF8CGnzWIgyJvNKHZhINmgUaLY5OJHBYZqHfT1PG8n5dwbS
	eyHvM9ucsgkcEa5V5tVOxg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qbctc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 02:07:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61O1mjXc027804;
	Tue, 24 Feb 2026 02:07:18 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35e4qp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 02:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KxQxR8VlIIQUoYxxby+fYxL0gsjGSKd/hie0CjbocoEWIRMSF6ae/HUCHgZFhfku3Qr6L7RXxWY9Ex5uP4iDc/Wz0phzQlas29IouHXG3S+BZbDn8y49/mX3MEaRcUpu0pqAK0mfZ9ja+yLXheEpwedOfbXMSYpMiklZvUR8Lisbt0wTCGZwk9AK8/264Si8j+c/a0mgsgGZMgNqSyoSwCAoArDVrFb2S6c8JLvZF+ddZsH2KFsMXLgHpG9hOy2lFJw9F7wtKb978JFMQFey93hlqej1T65gWLkoEGHnFNRS/qhomCu0gYop6+mBg+CX0UJMmRD2WsldrTvMHA8RlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+6GkJYs0gpnTgJdpwnkMwTKFeX+W9UZMecVv4BC3Mg=;
 b=oIXC74ZQLH4vUJQ17BpJ/ypfc/5mOBa+TqtvWglaF1B4PBS3cbjjl/Hfp/JANOq+z3EhsyUuZwnrSO/TwcyJzq6ABHyUhgFlRVE9e9dtu+0P5k15IZBLroee8FuU8ge/iTrjU3olRJkWvqgNrli9COjgoSPJUpmJRXbP2FAafcjt+x+hAHT0sOfWoQevNpz4Lc5TntJRfKDt+0kXZTfWXdjK9sRuF7viutHv+UjYWkjmEGmuxcuB0FzHN1551hNUirYNq+39mNeamFhBiKO6PZJPyjjHaKBjoxn//IJHGCJDILZcSdTGu8TJVi9SeTHr+w6kxVIR05ih36q0nELSYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+6GkJYs0gpnTgJdpwnkMwTKFeX+W9UZMecVv4BC3Mg=;
 b=TAK7breLUB+AR2HjqIrm7OvVZbTT2HZ+/f+ZUqBkX6HZCpNIGbNsZPweRzzQXPcdCIFobKSpWPVmK99mPsEBmKICcREu+YPapAL8vGyy9qhTcjznTew8W7npCf+NhEYtJC7AW9FA5+IMwq0wYtvukQcrus2qGY0BGRG56pnIdiU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA3PR10MB7072.namprd10.prod.outlook.com (2603:10b6:806:31d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 02:07:14 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 02:07:14 +0000
Date: Tue, 24 Feb 2026 11:07:03 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, Carlos Maiolino <cem@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>, ojaswin@linux.ibm.com,
        Muchun Song <muchun.song@linux.dev>, Cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, surenb@google.com,
        Hao Li <hao.li@linux.dev>
Subject: Re: [next-20260216]NULL pointer dereference in drain_obj_stock()
 (RCU free path)
Message-ID: <aZ0Hx3DY-yM3XLc8@hyeyoo>
References: <ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com>
 <aZReMzl-S9KM_snh@nidhogg.toxiclabs.cc>
 <b4288fae-f805-42ff-a823-f6b66748ecfe@suse.cz>
 <ccdcd672-b5e1-45bc-86f3-791af553f0d8@linux.ibm.com>
 <aZrstwhqX6bSpjtz@hyeyoo>
 <aZuR6_Mm9uqt_6Fp@linux.dev>
 <aZuVgStlrvZ87duZ@linux.dev>
 <aZu9G9mVIVzSm6Ft@hyeyoo>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZu9G9mVIVzSm6Ft@hyeyoo>
X-ClientProxiedBy: SE2P216CA0192.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c5::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA3PR10MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: 28dc8f6d-f5d1-48fb-a931-08de73496d5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGt5bzgrVFhrMy9lQy9aNEVqeHNoM2txZGVFM0Q1dk80SkZINCtORld6bW9L?=
 =?utf-8?B?QUxYMnFxeS8rSjcrWlJyR2pkYm9vT2VheDkxeUtWeVdYTDVPMWZoMnZOUnVo?=
 =?utf-8?B?REZzd1FqdGhnNFZHVzkxNE1jZGpKdDRQWDJuS25neHhuSStzd0Y2V28rdkxy?=
 =?utf-8?B?ZWhrd3dGTDhJZS9SUndqT2doWFlrZ0FaazVkV0xUQWRidmg3T2hjVVBPYjRV?=
 =?utf-8?B?eTU5THYyd3FqUVV5ZzMwK0grL2JmUldwY1NUNk9ra3FyZ0Q5NDE5bEtRSS9B?=
 =?utf-8?B?cDlQZmswWWppSm8vcXBxSEcyZWRtaUxiaGMraSt4ZEhKR2NsZVR1QytkcmZU?=
 =?utf-8?B?MUV5bVVIOVNIaE1lM01kTS9iYThUN1ZpNThQcHlPNnc2VjJ4cERJZ3pnZVpN?=
 =?utf-8?B?T1ZlcVBkQWJDdmhJYkN5ZmQxV2xvTXh4L0VHbDJNWFNTdkhnSWFZVTdoQmoz?=
 =?utf-8?B?czV2NnBsMEhOM0JNSUlkd1o2dzFaanpGVFpKRjU5cWsyaUZtd2xoU01hMUJm?=
 =?utf-8?B?bWVDbkl4U0MvQWRaazZPVElIVEpMTzRsc2t6bGNHck0ydVRUYnB6cnlLekJa?=
 =?utf-8?B?UjdJWnk4RVMyZEt6ZTE5eWZORnVscHpld1lwK05pb0NxYXdxVC9jVm9UY1Jw?=
 =?utf-8?B?RWpqQkgra0dld1BPUzYrYXZvK2s0dzNlRGNvR3J1ZUNOL2JBektJOTBCM3lW?=
 =?utf-8?B?UEUwd0tIa285SktrSjRzQnpTVU5nekl0TXJucjAyV0hSd2t5WitWaGRXN3lM?=
 =?utf-8?B?MXY4VWw5UkVXNzNFSFJFTVloYW43SXphWWF1MW5GelZxdmMxZUI5QVdOQkNC?=
 =?utf-8?B?NkJ5RUR2RDZMdUVUbm9YSXBiQnk5c2I0SFdFNlN0QnhMak9OeUlpSEMzU1cz?=
 =?utf-8?B?THRCRUw0Qzduc1MwWGJqQU84aTlWdFRTU2xpeWFQOGZ5Yk9tN20wR0VKL2Qv?=
 =?utf-8?B?U2Y5VXJ5KzZIenZ5Tmo2WDNjaTY5bUdSb2NiR0Y4SXpMYk1yZVpKK1BwdHJR?=
 =?utf-8?B?aTNTR3BLRUI4dTA3dFdabW1SUlROazR4Uzh2aEZIdURHb2pmOHcwNlo3NEo5?=
 =?utf-8?B?aVlteVVZKzV1UlkyMXA4czY1cmphNnd0RkY1aEtYQkpuMGtUclIwQU1XVHZ3?=
 =?utf-8?B?WmZPeit0dExCSGF2TFBIWDZ3ZU5YWmJ2d1BreTJyTlIwRUV2V2w1bURMeDBw?=
 =?utf-8?B?cVNVRnRyaXlKdmpjZlo2dC95bHVVRjVUYXRyMHB3SW5BYlR0L2k4MkNRcFV5?=
 =?utf-8?B?MmpaVEI3VUxsMVJGNTBXVmdqWEFOQ04rcHNnWWZxVHUyZ1RwUzh5b0tCN1JE?=
 =?utf-8?B?dnF2VVY5RG9TVjRIbG5VNkJJcHd5OWJ6dDhHWm5SOFoydGdHYk80RlRoNlVY?=
 =?utf-8?B?UnBucEU5VExlOFJ5MzJiTnYvMVNOamg1amU3UFdpUWZwWXREK3Ixa0laMFF0?=
 =?utf-8?B?YW1ESlJUNmFMUDlFektjTjJWOFlYZ0NLanlSWXpGaFV3M3NvMmZtRGswdlFn?=
 =?utf-8?B?cit6ZGFSeDVza3JVN2hDOTAya1ZaM0VWT1V6T2Y3eU93dnBsWHBraWRjQ0pF?=
 =?utf-8?B?Q0VNaUQyekF6L1NrSzdFellRdmRQOXFBKzB5dklkMkJyWms1dDZob1lucGxr?=
 =?utf-8?B?cVFSRGMreGxRMjBSVnAyVHJhSDRYNGxLTS9tTExXV3lXOWtTVUR0MER5RjdD?=
 =?utf-8?B?SVpFaHh5OVEvbFk1TXZPQWhvRHR1YzZBSU5wZEtKUGFQRWV0Mkh1cy9CdG0x?=
 =?utf-8?B?RC9iNEpWSW8rdDd0U1ZjQjc1TDRkT2d1c0htMmFSVGI4OFRzRVVNb1pBQTFv?=
 =?utf-8?B?aUt3VnJ3SmR1L1hzdzRIYmovbVdhVUhERUR6U1h1OXJJYTlUb3lNTWJJb1Rh?=
 =?utf-8?B?NlFGUkxQMWlMMCtBWUUrZW9FOVYvd3psN3hFNDkxME82KzkvQmFyL1pSd2po?=
 =?utf-8?B?Z1dRN1crMDBNU2p1OGhGOEFROHVwMHl3eTJVbGc4N3J1NzBuR1g0WUEzUUlS?=
 =?utf-8?B?U05kT2t3andPLzBUanpOOTBpZ0hWZjNBbTRwN0VmVEhJMTRhdGxydlhzQjVS?=
 =?utf-8?B?Z1l4YjloZC9oU0VzT05aTTJ5Q1ZVUjNURHpXVHhaaGdvbTJIbVhmWDV3T2d5?=
 =?utf-8?Q?fXes=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzVDV3kybEVhekpRdjZIbDhDMjRpT0x0TVRYZ29hSHBwL05lSFBBQVk0eERX?=
 =?utf-8?B?amRVbmJueWJ4aDZWR3FoYkdqNW5TazNkT012WG5UcFBMOVI3aGhpb0dvd213?=
 =?utf-8?B?bHZHUmpQYnoxLzZyUUxoOXlDVzM2dG9LaHZYT1ZFQ3dvaml4ZlJ4eHU1OTQr?=
 =?utf-8?B?eVBFVHVRSGFDZjZXOHUra0o1WjBDSVpQQU4vNHdUVGU1SlR1YUJIYTdwNGw3?=
 =?utf-8?B?VHhmeXhLemRtdXdJN1owQXJlcUJLakNjbGttd3hpZHluTnYzTzNtcDRHYnBo?=
 =?utf-8?B?djNHMjZOalpFN2hLUXA0TW43Z3ZYL0VXR3VHZ2M3Qk1KbVlGdWVMZk5YTkdq?=
 =?utf-8?B?d0NzSGdYU1RjTUQwa0k2V0p5WHBIYjZrOEdzZ3VLR1lScVQ4ZGF2VnRacFZD?=
 =?utf-8?B?RXA2TS8vd3JGcWFzS0xZbHFUS2FiV1RHbG5GcmF1VTFaVFVTU0NXWkVVREZG?=
 =?utf-8?B?bGZLVlJrTE9hajdTN2M1R3BUUjF5dzNzQ1VHZHE0Rzd4NHZBbTc1cXdHTnRi?=
 =?utf-8?B?UUxSOEVFQmFqR2g4OHk5anVmZHlldkpFSmt2dnRBU1lnZWdZemUwK3V0V1Ny?=
 =?utf-8?B?aWUrT01xOUFOcTJTRXdOK3k2aUJFMU04WTZFcURLU3pmMVpadzZWTTBiQkFY?=
 =?utf-8?B?YmtHbEc1azJURGo4Ulo1UC9pOVppWmk0cEVxbTVjM3R4SCtQcEhLUUYydjZX?=
 =?utf-8?B?K0pGZTFNeUkrbVlNMGtTSUwzVTloWWorQ0U2S3RJYmlyZmVaLzFuSXVlUlcy?=
 =?utf-8?B?a09vTnlHZUFLZHBMZERSWXpwQzRUVzcwdDlvd245SEVTQmpvQUxwWXNlaHVs?=
 =?utf-8?B?RzhZcHdEaWJZK0JlVldESzAvRVNHaGZPKzVjUWErODFIZG1mSHk1NVdqMnVx?=
 =?utf-8?B?eUJzUnRxWTlKUFA2aHRPaWNoZ0N0QUtlR0dZeWV2dllHZ05yZVRkNjJsZmo2?=
 =?utf-8?B?ZmJ2K29OR0xhTWhobE1vRWUvMzlaVjFjQ25iN1lCQkFsRStoczFJVDBhQ2xU?=
 =?utf-8?B?ZldFOE1iL2hISGQwR2QvSXJvVTJZKzVFdzZ1aFJ6M0pDM05ucXNWeHBHTTJV?=
 =?utf-8?B?NGRId25RNzlCb1EzY2hXM3ZjL0FjdGZ4V3FvUTZ3VlNlcUZ3UlZIU1ZYOU5Q?=
 =?utf-8?B?VUhUR0oweVdPbUROTHBmQjIxWDZXNFltYzN0NktPdmtEZ1VMWkozN2x1K2Rq?=
 =?utf-8?B?SC80cHVvYlB0QVFEM28vSDNPK0xMdXNnSUlsZm5tQi9sQVlWYWtOR1A4Mm9v?=
 =?utf-8?B?YjFCS2Jydy9EbG5uaHZUTndIV00xZE5kZ0cxU3dFTDhNUXdmZmllVHdGTlR2?=
 =?utf-8?B?T0JhSGlDMGRrMW5KUUFmL2dPdURrdE9jdmtlVkZHaG41aFY1eUorZno0ODFR?=
 =?utf-8?B?Ry9GOWlianplWnNaVE9hNWI3SDBjSVdVTGxTeHU1d1lKYThoaXRDVy90Y2Ny?=
 =?utf-8?B?VlJHVEFYYStqcmd2SHJPZWxvcStOQVQxM3l6andKOTFpNm1DVXdnZnhYVFpG?=
 =?utf-8?B?OHY5Y3lFSFEvWWczOGxuNklDdG5acmR3RkRLUUVVYzlRTVRIUHNTUURMRkt6?=
 =?utf-8?B?ZlJtd3FrVGRGS3RnUitFOWZKdnpsV1BwODF5TWRmQ0xkVnNaMUxncXVsNGc4?=
 =?utf-8?B?K1ZLOG4rRFFFT2h2T0t3ZWdKbFZ2L0d5cGpsdjNHZG43Vm9WbC84ajFqWklj?=
 =?utf-8?B?M2JvbEZXdXQ5Y2lOcWtCRW5ISzlPYjZ1R1lUa0pQNTFTVWNTOEdXWVVuZFBK?=
 =?utf-8?B?TWdsdWlZcTM1SnMvYzFvdTd6L3lzeHN1ZVB4TVFjTjgrWHpMaGVGNmVqQWw0?=
 =?utf-8?B?UUdJdEtaM0dDK0l3RDVvNlVTa2QwelcvSm9mYmRLaldLYWV1L3AyNVU2MEVP?=
 =?utf-8?B?cXBEYndsZzYxRUV1cGVKcEhSVXpvRElzNVJ5RExlODFrWGZHS0dOYVRyenlC?=
 =?utf-8?B?T1ZXY1NWdjhjRUdzUzliR3dMbnZRcXkvTjl6MmxzM2xhWjdhZllVKzJKVGU3?=
 =?utf-8?B?RUNoK1NJWnE1bE1UQjlzQXRhZWN5bjdVckZxa3RDeFp2K1hWM2JRekVJL1BM?=
 =?utf-8?B?SEdFb0Q3bkx3dlF4TjFVclFMZ3ZtdUFPVmRuMENhbzM2VHhmMG1nMWx0RUFi?=
 =?utf-8?B?V1VlQ3FrVHRsMC81clpnZWxuYmtMS3ArdFNIaFhNVXpicWp0ODhpSEptSnFj?=
 =?utf-8?B?VnZBN3UyUUM5dzNLODBBSm5wWkRqSlBJU05qb0VLUkRmWVVlYlozNjhXYlVq?=
 =?utf-8?B?VDFyQmRoV1dvZWlGa1ZQKzhaZVBlQjIveVNSM2NlSE9uYXNHRDFmRlc4L2RG?=
 =?utf-8?B?U2tUL1A4aHpQUk5lTjE1SzVSc3A5QXZkODNoMFVHQmZPKytTeVhyQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sFW/OmfHQlzBmqYTYbXCkHuF/vt0yDWAW2o4L9DwvW+0yJn4/ZxJMQwzPgTIOCsjHQy4n24O190XAHtI6oIHnc68ozfJXvyutz+x3FUtnXSK8Attpu3A7KalfzVWloCGb28AtdhxQKYI3qYGLr0PKp22dlq+FEZmqSO3BCFIqCLr6vK7IvIRiPVwyHTT5n6iJTJrsBErfEDHRNeQL6edyUAMjbIh2q7zX1OtYr70u6uYL0q+5yY6fxijVQ427UlMlXDz4fqcqJv6mYVY5ZBQZu0z6l/CXoCGvhQHmSGqUWjDJIpYNPL3NgPAJKdy7gpaY3ud3Iz2wlJcBXsTZYzWnEXrWxyF5MzAg0q96G1kgfycWfRlOOVH3Icsxy9nxXG2g1tYyHGbnumm9iGgNgg1YYNYIL0YgGO0AJTJ1ZLMF1pzi+jSpCnwsER27wZ6oRTSYZqoIoDJRq4MBIft9XAvOJEJ7CQUM3Y96rg06nKSwgH/NfoxEQAYUxp0MEY14o/ppglxL4DkFZlavmHp1DwxgsaGWb4Cu7kG1uGkxP2xj0nfoms4CPYOJ/9zsXWEf9Z5th/1YrcZRDradnWzI9WXYm1qpr2jxcxuumxxiGZeL0M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28dc8f6d-f5d1-48fb-a931-08de73496d5f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 02:07:14.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63Dxis1YQ6t57h4xZ+r5lcCxN306Xtp5dch5cOAgqGwDFadi/7jaSG20pUcZIwqtzJMnFlKCwgm9k/1YsFO6Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7072
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_06,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240016
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDAxNiBTYWx0ZWRfX4bcmiQ2NfyZo
 9yw7uARN+VZR6jKxPxFOz0HLi8gsnXImK/7n3Kb4sCYDKFh++pl27yGa+BU0L7fJEnSp8/u0I+m
 chv8y6w6UVkbWuaxakMUn1rVDFAqB2EphTPDcoKU1kBOaDB7uhUy5jx4/loPa9WjzbrecZw9dfv
 ccxdPkrINzBzAFPuz/96VGSLn07I+ujZPqQnxmKE1519a60iM/MNjKmR47/PhHtssXVhuWFBCBe
 wze3sL8RFI9vWHueSkVgqruUY/Hm1EKmN2ec6mMN5YR5SnE1gFXqaC4taKq1Zoaueyj2a1bKsnf
 +UBk8ZpvkbReIIIni8FAgsBggYA7sJlR6jzd7gMZ439W8GQtB5DhogOd06G+87NmMXxrvS8UMoR
 oeNBz01DJjCRZY2ewOy9gCGzHoo4VtHSxExRZjdHUBIf6ViRwSWgDsQbTBofswzMTyClaOL52i5
 6wj/vTUNj8487Ygc6EYr0+P12xqpWkgrPL6gKtaE=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699d07d8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=_jihV_VIQ4hjoSwi_QEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: V4oy2eClh6sOp452kTBrtmc0Pcd9NH_8
X-Proofpoint-GUID: V4oy2eClh6sOp452kTBrtmc0Pcd9NH_8
X-Rspamd-Queue-Id: D97CE1C000E
X-Stat-Signature: 7xnmxuwhuzxegrpqfaq8dc9qr3y599fe
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771898846-931491
X-HE-Meta: U2FsdGVkX1/rB4HmwYqQCxaN9f+eNk4PDaepAdctvcMuSFAaB/PNMipaHfM0ZQYHMpfvW0604CR+EUMDebF3cOI4HFBLrXOS3yB5ugJ8IXWNxgyKly5VDTAjbwc/kuyaQUisafdlrnEyt0NVM380XKNBGbCWqV4/iV8sIXLRt3zIsLvrGhR8ImpL+bx+O4LOHPiWKKjPO8rD5l+D8ZMtKh/fzQeSkc/AvaDf2faiIeICsZzpNGIcVZ8u+fsyI7t+5Ok8DrWh9OtCgx2dHQwSgJyMHyDXQLS/XQy+4dIDh0uJ0+KZhP2okxSkdlZA2++OLljUqPjwoYx9f8NEReTsxAonkg1qP5Aj40sKFB7uYIL3+jvDM9elGQjTgw6qnXmWbmbtckYQnPfP6/aWorBNQ4xcV294Z8A9jVVT5w7SXBc9Jzvv3Qz3VYYc5OJkgn9UNfHb6HaUpxnJkT0FNsLiQGPj7GJN9U7IJhGAj+oIe7PnsZj/3VCZ6WuB4fBz2hA143uRWsKuw2AjAYNIFda/Oohq8gSTfdjneFC70ktQ0avkBoapu965WX+vHtFEEbbxL0C23ZVJoIxi7TYDzrUFkaiXgwm++LDjRHj4kJYZNN7LFi336iesGhy7T5uS4mijkRpylm3G85dHE2pDLFwHydT+Sfx6SueB8unkrp7V9g1soSdG1Mj/PiMmiq1aCb2pDkXeWsCTk/t7rvAPHuaMp+SD93t6fTUlD+oOdTfskjasxYR5j3G4v/lvXfX3KythqKliBPunWCze5653ShlnGUw+/HJ6SqE1J9xw3bBD2hwAu6oCuEw2mzqHeEhJPTGjvX98iKvVU5NWV6xe0sumXDyj9kSeKt5RGfpfMQZG2+Ut9af6l94z9QTH18xgMKJERQWqv2AgcOmX1Qxk/CcS6TUWrRukwNkghADs6feS2YhiH7D9PiYcvQ41WDXiC8nIAq1qPlOgqoNP7qQSCYv
 2no5M6SG
 wQ1GV54VoSQ5B8GPSw3e9XBh7KsVLExJFRG5rQI6LZJ59hBK4hnZauCnupmYXHfLm3mMPkItXP9DV9uDQ/AfATY8WxzmxiKIPdn8FCO8ouNrUfRSp0lL2P9fQ/Qt4ICgCx02/Xhuqb7HTbBabXaNqjyvnVrg+xm8K92Aj1KYi4Vo/+K8iq/zpKPv8WB1qe0WdOtLvrrDrFcCU8jzozOSlHigyvH9kZL4UGi5bXI4V+4ho80Q/Liya9otDub2K+uv+0oZJ4CmNjEl7ZTOwHgODL2XrXrJu5z/vOT/T5yKaNwX43GBB6dRgi4RWKD03pgkMtrX8onT/VSFJHGBQJjEXkW/4QXlxG4l27YA+gT4o9ve+PqwC6/veDeOJiO+xg4Jyw7megfk1wrW7LOI3W1LcAk2CH8ZrmD3Io/UW1fThn9t1GoigLmYRyi6wEPCrjot0MB3cLpbgOMFQedjnuP9MQl3UuPmoc6iWLwuZ7EflqAlofIeI2zxm+kM+Eu21gAtHE6CmpF6Neio/dKH5BwC5iu6aIbTMhN+sFyUggZlAP9mHZ3iqz89uu5X2ZiBmpKC75B29vBGLOQors/bEOCr5dyHM5NhkLCAJlX0Cks7X8ttBAXP0N92CPH5hzZRtDXodi27pLmiGVamFl9qVtFc24QyWD26xk43elTds/NiOvZuEspCQGwy+GxKkXqqK8vSX3MB9sjoQjX3RWfTmbqVQQEEDAJR7dMBgbgQ1ZeRKvkhJTNd0xWA3iBIltqs+hmFFNCUX3M8aULqXAMM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:36:11AM +0900, Harry Yoo wrote:
> On Sun, Feb 22, 2026 at 03:48:53PM -0800, Shakeel Butt wrote:
> > On Sun, Feb 22, 2026 at 03:36:46PM -0800, Shakeel Butt wrote:
> > I asked AI to debug this crash report along with a nudge towards to look for
> > stride corruption, it gave me the following output:

[...snip...]

> > ## CRITICAL: Memory Ordering Bug on PowerPC (Likely Root Cause)
> > 
> > ### The Problem
> > 
> > In `alloc_slab_obj_exts` (mm/slub.c lines 2199-2220), there is **NO memory barrier**
> > between the stride store and the obj_exts visibility via cmpxchg:
> 
> This is actually a good point.
>  
> > ```c
> > slab_set_stride(slab, sizeof(struct slabobj_ext));  // Store to stride (line 2199)
> >                                                      // NO MEMORY BARRIER HERE!
> > if (new_slab) {
> >     slab->obj_exts = new_exts;                       // Store to obj_exts (line 2207)
> > } else if (...) {
> > } else if (cmpxchg(&slab->obj_exts, ...) != ...) {   // Atomic on obj_exts (line 2220)
> >     goto retry;
> > }
> > ```
> >
> > ### Why This Crashes on PowerPC
> > 
> > PowerPC has a **weakly-ordered memory model**. Stores can be reordered and may not be
> > immediately visible to other processors. The cmpxchg provides a barrier AFTER it
> > executes, but the stride store BEFORE cmpxchg may not be visible when obj_exts becomes
> > visible.

I want to clarify one thing. The AI output is slightly incorrect;
cmpxchg() implies a full memory barrier when it succeeds and
(as it's a RMW operation that has a return value and is conditional)
stores cannot be reordered across a full memory barrier.

The reason why the ordering is not enforced is because read-side has no
barriers and the compiler or the CPU could reorder loads and read
slab->stride before slab->obj_exts.

> > **Race Scenario:**
> > 1. CPU A: `slab_set_stride(slab, 16)` (store to stride, in CPU A's store buffer)
> > 2. CPU A: `cmpxchg(&slab->obj_exts, 0, new_exts)` succeeds, obj_exts is now visible
> > 3. CPU B: Sees `obj_exts` is set (from step 2)
> > 4. CPU B: Reads `slab->stride` → **sees OLD value (0 or garbage)** due to reordering!
> > 5. CPU B: `slab_obj_ext` calculates `obj_exts + 0 * index = obj_exts` for ALL indices!
> > 6. **All objects appear to share the same obj_ext at offset 0**
> 
> Yes, that could actually happen, especially when the cache doesn't
> specify SLAB_ACCOUNT but allocate objects with __GFP_ACCOUNT set
> (e.g. xarray does that).
>
> With sheaves for all, objects can be in different CPUs' sheaves and they
> could try to allocate obj_exts and charge objects from the same slab.

-- 
Cheers,
Harry / Hyeonggon

