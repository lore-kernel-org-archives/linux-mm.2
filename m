Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0EEC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5CD86B009F; Wed,  6 Aug 2025 16:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D446B00A1; Wed,  6 Aug 2025 16:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87346B00A2; Wed,  6 Aug 2025 16:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2BBE6B009F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:05:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A6141406B1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:05:52 +0000 (UTC)
X-FDA: 83747413344.01.3547515
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDDF31C0005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:05:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Y2CPeTY/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tFI7zs+8;
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754510749; a=rsa-sha256;
	cv=pass;
	b=wq5huWfTu7hACxZ6rh58Q4CPTcEggpr5PIAiMYk72hkNc8PEkvS/HpYXLy7altied/U3Yj
	V/9FpqT1eOh446N53+UPOSfY0ZsU4+3QEM16x5fZS83GspdAP/mO99MQhrfDz+nSiwyPTY
	MtZEKjUZYPFOrXvlGFLC8XNkHP0CCng=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Y2CPeTY/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tFI7zs+8;
	spf=pass (imf20.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754510749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmIdxBr1kJUZRuFR/AIfciK58VxJP0fj4pDzzdggxG8=;
	b=lgr6NHYA8x/1pKWEdabsiOX2vzTc3myxp+OIZn8j1qjD4004U1qO9seO8R/1Qaozg2PXMi
	Fb2c/t0Tjyd+zfAmwFQexPv9UxHwYQh7Aa8PxSAiTbmRW9cBSWUafQeLcnnHArCYAvooS4
	mV8HBGz/NIw85msf5vPZ1XhvdVHhFnQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576GRQLC026038;
	Wed, 6 Aug 2025 20:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BmIdxBr1kJUZRuFR/AIfciK58VxJP0fj4pDzzdggxG8=; b=
	Y2CPeTY/ooojJpzJGmSlsrxlIVcn2POfIHPVwSLLYbtmSAak6Jc2zcyeyLedzuqt
	Yoml3oiezFMXkRAHKTYTKNpxs6OhUrWyfjV1w1Ffj2P9GGkKpH2+Ne3UMWehwhS8
	U9n1S7ioMoXneq/1SerCb3y+6pP3BHtAfMEjBfdzJQS+yz8dZWYy+jminUKTf2sF
	jm4hg6wKeZIn+i+ExCPyJhJiHc92+ZQ8KvUJqmKN1ocQs/zl2XWUh23mh2OLISaY
	INK4/BZQLLi27Mew/djGJQJZGcqWeV9nNGhVwV/Y3as8hEZ/f/dKMM4zO8AFYMSn
	gnqaZ2kwWgqsmWB0dMz5bA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg2kdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:05:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576JcIRn005692;
	Wed, 6 Aug 2025 20:05:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwxgqg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:05:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=biPBjIgIAbUbtd7jkUbAC0Ir6ZvRsS7Q6RCq2HX5zr/7AWiRbepiK8wgkcTovyY+90rJQVmyoe1cSEutvE4O/PNYiMf9bu1lg0vUfcUUvFWQ+DaLFSIE7mythv0RjAaaUlF1Cj05XZL6NO/Mds1eydcJ7Jf2ltv7pwjMXpd2xgQhXE9RNiMqiYgumvY6f5FMSVaPZ8B9jRtRm2TN2omYsoWbbCj3jSpW0/y5sLMMg3KvipmSYVpXRqnwpKICN0q0eg7yZvxTgGyb55Owxttbb1/i1DXqXnXoQDmP8hkVJlJvx192Kq01b1vlzIBJSE5sq6q2IPt8AF1AHll3MyA4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmIdxBr1kJUZRuFR/AIfciK58VxJP0fj4pDzzdggxG8=;
 b=dLynWAd57fb/K97mwfj+/6YuyVuHBi39Jnuj1o5BKJFvhbRUFT33zU1ETjCB/MNzpr0w6MzSPh/2KIGJB57b3zVme54ByO9bvN9s8s924vKDzdaeHIgXtzPdRPnqQ9VAbD+HskWL4wK9tQnmfUC+jkloE3f3ahM8uPLAaL8sv/9ictuubaiGThuBOtko6SdjWucuVd7oNGs2t478QPiFj+cdUR3oHszMIlzJYQo+SVvUrs0LSJkgXfM3OBD3eeLmkWkscs6HatNRaJ+F154/7LkBhMUfpv5Wdn08jdoc/y86c1KplXZtv1r9idJX77hp0kxMGTZKlNhSHLnRwafheg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmIdxBr1kJUZRuFR/AIfciK58VxJP0fj4pDzzdggxG8=;
 b=tFI7zs+8RUBQL4qfWZ3z3KUCinXnvwbDjO2+2Fwn01urf8SjrIf9qSZ4su8DxIXijcBzLOAUn0zQOsDe5oXNLYuPZvohz+XmXp+oL08UV7SJPOfJAKtVOK1rulW5WZzy2guDMXxrUQeFaw6Wb8XccrWyhz1Ou1vhP69i/DGlv24=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA1PR10MB5996.namprd10.prod.outlook.com (2603:10b6:208:3ec::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 20:05:35 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Wed, 6 Aug 2025
 20:05:35 +0000
Message-ID: <1daf68a1-71cf-448f-921c-83ebf61e1fae@oracle.com>
Date: Wed, 6 Aug 2025 13:05:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm: hugetlb: directly pass order when allocate a
 hugetlb folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-5-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250802073107.2787975-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:408:141::35) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA1PR10MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e48f012-acd0-4f3e-7230-08ddd5249ae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0RiR0N5eG11eURvZWswSDBmTUtvQnRpTndWMi8xN21kQ0YzK3d5dXlhclps?=
 =?utf-8?B?K3Y5RVBZOTVlTnY0S0pHY2l2SnZmOGNGM0hvRnIrRlNlQkVKWlVmVXY3SENT?=
 =?utf-8?B?SDZJNFdFTjNERXBEZ01LNE9sZDF1cFB4NUoya1BrbFl1aXBwSjVTT2FXUXh3?=
 =?utf-8?B?MDhUYUVRNWJXOWdrYjI1SmhHZEhWWlRzK1RlWkNPTEI3SGlwQXJIeit0OHZx?=
 =?utf-8?B?QUVGdGxwd05EcEY5UWZ2SXU5dHdYV2N0eFY1Sk5zeW45NHhvL3hreURrZW82?=
 =?utf-8?B?WWxEc2RHNUxJR2JaQ3ZQSlRYQi9UWTRHSGNmN2NLS3RxM2ptWktMa0QxdHBu?=
 =?utf-8?B?RWs1dG9hT3YzZ3cvMVZKQmhYaHFDME9adWlNTzJJcktlMFFuVWducTBvNnFS?=
 =?utf-8?B?UkhDUk1kaEZidGRsa3BZNzFyc2pmc2xCbTRUNkw4MGZHM2k4Wm1MUWdXOHJF?=
 =?utf-8?B?cGJDbHJtc091M0dNRTJ2Ni9rZkxZUFpFdkduZHRDY25xNUdTMktJWngzUWhW?=
 =?utf-8?B?cUVUM0g1K0JROE0rZys4WE0vUlBySUxCZTBkNW9SNFZqOVR2aHpwQWdnNjBX?=
 =?utf-8?B?ajl0Vng5eS8rY01EZW9ldk11NTY4Y2J6dWU1N1k5VmxWUnlnbzV1cDV1YXRt?=
 =?utf-8?B?akwyMXozVTR3dGQ4THdsS2N6d3hsWlZmNm1Qd2cxeTM0VzR5NS9CV0tqV3hY?=
 =?utf-8?B?Q3hOU2lmWGd3WUgwRjh0YnNLMmVYbkV3SlZoN3dnWmZuUTRMcTVVYWFpdElL?=
 =?utf-8?B?V3pBNGZPTldKSjY3c1d5ZnJXU2JPY0hNbnRFNEVuMTdGVVFCTXp0amt4ZXFr?=
 =?utf-8?B?RnZha2VrRFN0VUttN3RiNWRqRzAwRW5saGM5eFZaQ0EvRGM1L2FXT1p3djdW?=
 =?utf-8?B?WUR0aG9raDF1RlRyVnlvMDRSTWQvdCtsaDlGRnZMWHhpdS94T3pocGEwcFo4?=
 =?utf-8?B?dkt6bC9ZdklKMEVnazN1UmYzYUg1YjF6K3VCMjdXandEOXhOcEpsb0JqMGNq?=
 =?utf-8?B?MkdPbCsvdGQ5TzFxY2o3aUtnc3BYNlpEbm9qK1grNzE0MWZBM2RDYm1leDdC?=
 =?utf-8?B?NG53N25sSlBJWGJ0QkVTUHloYXg2NzdVZjBBY25DYVgybUw5N2VkZ29JNnU3?=
 =?utf-8?B?K0F4cWl5dTNFY0J6ZG16bEt2aDRIbzA2WGhTMFU2UXRwRWN1TFhkeE5SQjc0?=
 =?utf-8?B?bW9YZVJKODhUbkNnQmw3VFV2TGZZRWtSeTNyUWxiQ3ZjRXFZUjBJQmVnUGJH?=
 =?utf-8?B?TkpUVVB3YzRzdG1tQVhuQWNTRnVFRDNRSXpaMEgxMTZZc0xBZmdXck4rMEl0?=
 =?utf-8?B?alRiWXlpMlEwR2M4b2xOS0ltVEtIWTdwNTFSNzk1SXMyNTNyeHQzSkZwK2ts?=
 =?utf-8?B?UjMvcXZDQ2YzSnAzeXJzL3ZMVnhsVy9GRTV5YnB5ODlpb2J4R1ZjcmFmK3Vh?=
 =?utf-8?B?bVZ5b2o1QVliRmRMTzdWdDc3eGNEeW5xMmZKdzhkU1R5YmZWTHpWakRpeENz?=
 =?utf-8?B?MUlVeFM2Q2NZcGE1Qkl0UGEzcUd2SjM1all6Q3FYYUxXWDVyNGdyay9BTm42?=
 =?utf-8?B?RWpjZkFhSzNRK05ucGZieTd3UHl2VTNnd045ZlhMN0p3T0k3bWU4czdsUFdD?=
 =?utf-8?B?ZEQwRkNOV3hpbnpQbUo0Z0V4RU1qVmk4Y1BOZ0N2bk9ydjZPTUVVMHN3UStj?=
 =?utf-8?B?a3FEMUhHRllpMDJ1NXpuRUsvY1B4czFvOVVHOHF1OGhMaVg3U0o2UlJWSWFB?=
 =?utf-8?B?RCtGSGEyRnlMSmhCOVVHZVZCL3k5L0s1U2FHeG9lNXp5cmVzZHJGZEFYY04y?=
 =?utf-8?B?bkVIOVJ0Z2VqNG9Fd1NWczRzMlEzcE5VSTJjODUxT1hHU0g1NW9hUi9PcHho?=
 =?utf-8?B?c1lGaHRHQnBQR1FYaXZJUnV5VFFjajUxaFdHaWUyVmozU2hQbm8wQUJZS2FG?=
 =?utf-8?Q?BlbZw/ULE68=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVVqZVF6NmI3Z3dERklSd0JUL3pjQUQrL1JFVllqVTA5RHd1YmNXc1lnWlp2?=
 =?utf-8?B?alYvV0VvN1BBa1dGWjJIVndnUGtMaktLeGJNbmdDbTA1VmRSVGN6STYxS1FY?=
 =?utf-8?B?UUMyV0RETGZWemhCNXBpSjg4ZjdtbjFQMFU5czQ3NHFnc1J2bzhkMk5WTTR0?=
 =?utf-8?B?bHI2Yy9CU0hqMExiYkFCdm9SVkozaktiZzZFOS9vckdiZHEyclJRN0JSeUY3?=
 =?utf-8?B?aGZ3ZTltNHpQTjRZdnJGL1BMazBYelhzamRKYXc3SFEzRWRvMmN3Y1JsZTQ2?=
 =?utf-8?B?U2tIeDQ1TTlSS2JYRDlkZFA4N1VXY0VpYU1Zd25RUWxCOEpUVVFYaHdkOVlz?=
 =?utf-8?B?cElsODBLb2xIWjVvMHluWmJ5Z0wxbFRZM2tYcEpMR2xvd052eVJURG8wQWs2?=
 =?utf-8?B?M0FCeUhscE9uODBualpaenBFS1JBb2NMNERhODZtS3Y4Y1djdTliSGtGMlVq?=
 =?utf-8?B?b0p3Tm9ueTRXaWRxWTFYeDhLaTJXY2JveWZSN1JpOUQ3RCt0Z1g1cWVBd1o1?=
 =?utf-8?B?Wit0dHlyS01XdUJ3cG1ubUlxTkJNNnhwNUlWUDNlQnhmK2hIMzNRcStqaFlK?=
 =?utf-8?B?M0Eyd0JRdXI2Ym0wMTUrZ0pxc2RDZTVxdVM4WlBnQmh3RWlTa3JQWlBEV016?=
 =?utf-8?B?SE1mVWhlUVR4bjRaVlV5ditoWEtQSUE5ME9RS05kcStzRlBNTXlNTXdmbjY0?=
 =?utf-8?B?TXpSakh1MUREVG56NHBZNTlzNTdQZWpSMkI0TUl4K3NQcUhFcE14NVljVlVQ?=
 =?utf-8?B?MExPcTlRbXZiZHBuSHZIRFFwVUxhMExKYUtndXRUYWlYWWNNRGU5VHI2MjRm?=
 =?utf-8?B?OVZnN0ttTW00dDJ5SlNRNkdpWE9vM2NreDA1US9yTk9SVVRHRDJqZGlqZlo3?=
 =?utf-8?B?T0R6Vnk1SUlLQU5WZ0NMLzBQa1NwbkJudDlIYlNWWVBpZHFGV280ZVlnLzdF?=
 =?utf-8?B?aWFRRC9hT1FOenZqNEhGU0ZTd0g2bkkrbUxxcHdCdHRsZHdsZnJ0anVpZ0o3?=
 =?utf-8?B?WEVJejNrUThUYnhUUEZ5M1RtWkQ4bWFKT09BRE9XVno0bFZTSnN6bElOU0g5?=
 =?utf-8?B?ZEpuR3c1dzJTMEpDMDFIK1FscUU4R0FabXJsZVJJRStJUVNhM1lkMzhNRHgv?=
 =?utf-8?B?RXpVLzFiYXZNanRxRlFDZHJaS3dmTDc0STkyYnRGeFRiVSt2blpYNDhKRllH?=
 =?utf-8?B?c2l3WGZjbHBuRVg4WGpXcXJjNjYxbUYwYXRnb1Vza1Rpd3NERTJqZFZ4S3Ny?=
 =?utf-8?B?Yldjb2pTbU1zeFIzN2dPRVNsRjJvY1BES2RRaDE4a1hJTkhqWFZENTQ4bXBH?=
 =?utf-8?B?YnRYL2tlOWV5MmQyYTZjTnRlRUY4VVRxUUZFaXVEb2JqQ2tKZyt5RHhOS2tR?=
 =?utf-8?B?S1VXQ1BJT2xrWUk5UkZZbEF3alQxQmJVZlV6eU9BWC9EZkoyekpLRjBpbXlo?=
 =?utf-8?B?NjRDalRHTHNxU1Z5aXNJS1BSUmJEYklyOFk2ZnVFUEVCYWRVNXBFejdwSGtV?=
 =?utf-8?B?WURJQ1lTS0g2RWcvZ3hub2lXdkN0cU5KcFlyQVMvMFJvWC9kVUNvYzNxUkNt?=
 =?utf-8?B?UFo0UVBKMHEzTGVpbUhndVlyR014VEJqSlZzNmU3dmtMWWl4b1ZncTdaRlhE?=
 =?utf-8?B?TXFEdW12WlRzOWxzSEc3ZEZVSXluNlBjRi91UUFwSTFNdGJzRDlDR0QzM2gw?=
 =?utf-8?B?UFVTeFcvZjY1c1Zxam5vcWdiUXM4ZEhZWUJxWVlvb2lQNW9VZE1XbHdRYWRX?=
 =?utf-8?B?TWhXOXFsUHZqVWViM3RpUlA3Z3VnK3Z1Uy8xTTFrWERWb0RrSGExQlJUTHBX?=
 =?utf-8?B?bkRVUmhMcm1PRmYvSEVLTWZPMjhhMXhOdHBLNytKZE91MGIxU1Y0NThkOWV4?=
 =?utf-8?B?TUpkOFkvRXhmZlBITjhSS0t0MllIT1EzL2lYTzExVWg3NldZMG5ub3orR0N6?=
 =?utf-8?B?UmxQRlZoNXhDMUV2WTBxM1B0Q3Y0WUh1WEpUNnhKZFBhWXlaOVVka0xSa1dM?=
 =?utf-8?B?MkZXSEViWFhvWWFGbXMyR3JiMUpGd0xyS2pnK25DbVF1c2w4T1labGRqQi9Y?=
 =?utf-8?B?NWpTdmlqSE9jV2lqaTdobjVEUG4xaEVFWGp6UkVuMUNGUEZRZi80RE5HWDFV?=
 =?utf-8?Q?2OvFCIAvN1fWgkrPYcEfRVI5D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rTGqmRza/H73EdLUdkd7VBBIQb5K/AdI1MKdIr8UErIdqjnsRjdHvMElDCVtuKUBpb2ONczMQ5nOHZl09C/tGIUNDWh87seQtImSVl8O5kMVEWqa2jmCg389jo/OmxL5hMXjTTJ4xf+wldV4unOCTsBaeVnu/GPX42qGuIbGUg6f4fP34n5MfrQ0nEKYtJs9q+KfNhaNOym2FsNiQ1GgAdty+io8PNM9/Sz2MCrn/aWKoHeQt0rnEXkoLIfjRXwxeR7LgdWgTPniXolQTXXcXk1mmbFqZoyj44ZalUPcCIrhZMsZZ3VeZHttwlgkD4V5p1WQK3n4Lu+aQBqepoUahqwBtUQsoGn7ZIa2Jgw+hdQqhxlIhFEeuoyNir3hK6YHcP6z78zqBFkIA8rSa+/ZLRq55b9tqlSNVjZAnH/T7GcsUwAgeHFOunb3+Pn3fyOXtpJQVPC4fzJozwD6lXoopuRl4ZWGVIn/0K7zeTSg28BnTboa/QWHQtV2VE/p8OzYT3uGRBdmzGm3Xa2YKTbWBOX/DGev6ZmIh/a9mMIh/3GxLDZaiJQtNmM7ATo2iYgFvKktnMov/UE1ZFdzT5P4h9hiLHKMHqAvGeRU9/jYx+w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e48f012-acd0-4f3e-7230-08ddd5249ae1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:05:35.1822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/9uYWz738aHCAnY+X17XqBjlTH0iBKzmgIpvNwdbG5YoSewrC3VtSx961uKhAABeC5AMgQaVTnqRXo/Z1I0fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5996
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060136
X-Proofpoint-ORIG-GUID: bPVy2j2TKJCWEZ-bKFhek0IBUF7H-eX_
X-Proofpoint-GUID: bPVy2j2TKJCWEZ-bKFhek0IBUF7H-eX_
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=6893b594 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=LDFJHRcXdElZQuq7yIsA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEzNSBTYWx0ZWRfX/UPDrPYAb09a
 35LN287au6gDenuEI/5/4rY6L1lUJx3249tUeY0AyReq7oPRO/4d/ZN42pWBaT7gIqwj2aa+wM5
 AYqJpqMMcdMTD9K+xZQ9rEmnaBZrHy5eoz/W2QDwstKWuyGNUDcOD6RulfBWQpuxZl9yFZgNT1z
 ysaPt1jJSTwO73Uu5euAgzHkQuodhBiMrRRw1WP8rmQDnnKYEMWoU/hH05OgQPXO2Chlrud0zrx
 o3B9X80N+fuL3tCs5wPM+ep4Z9PhAYCDdEcWDGsghVGlyGOvYcfHJ663YrGEGf/XUvypPzKGiYh
 iRzw1hup/fq5oJetYMxN8k4/UQmuLrekAsSKu8nxcTICzB/PO5JVIavRysWc3IsiiPJETqHsk6q
 RJesJzws3fuqvrGoRyyk6ctInwNBFly1hubSYqBXkG/cNtGXm0aiZTgoTu7w7McGRVTZtiQg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BDDF31C0005
X-Stat-Signature: kozx9yqpfcn1odq9ooyephxpcgnmbycy
X-HE-Tag: 1754510748-369735
X-HE-Meta: U2FsdGVkX1/x0PqJ84yMeQ2JUArOMrLgqRcZrRyUgnwwSPkntklyWsf4EC/Jk/CwPg1m4yJRWkf5zb5ol3ikC36cNIN0KXiB62uMu0e/+nXO0cayIbmMhLb15dJTjmUpu6KSuSMe4z5C36klWSFyjQsqU8mIsegAEPgNDTxpR5/g82KsHeXgdjnLV3g/UoX3Mx5D7Go77fikh056IrYAuCQWAYlPBa7PnQZdv63vUwXnFCKZaQaxxUVtqQ5e1MnQ2JoFK+zM0qTBRDtdVJ37a/ZfS2KfI2/PUkVj3LrY8T/81HxZA11X/vo3YjxrvaS/Vi5CPKqJkwv0yDyS0Qot3CYOkJVgk90oea0KHb20voxD7JLEQsGd0aciDT4pDjQCXnMsDgj1dV5qNv+98xrjJsyYsLiKbRSeUBLgx+Hp1SlFWmmcwqdwtUxa+++bxF1IlJgdrXqDSNn8WstonstH4G3JZO35uc13c1anoBu01yrAuMwP+tBthofAbqs5CnjbyTAJFsPcqRCRfRjjyqX42A3Me5F+J2DexCdmR6H1pnCT0t+QpUP7cDjt/Jjvg89C6e32xtwD1aZ93tGgEbARx41lWIBqexn0dm1BC702R29ZADHrzBaVVXz642bIhvhLy/DvpY1WtVjYA1sM8OzhaktxHyukvlf8lcELNusonA4Z6fNB0+n1Yi0ecBETof9n/lKocsKi02AJ8gpkeG+xlIIs2VEzJoovDksZijHq2SAGrl6UXyzdWlS7g4BVD+1aRBzLfjpwqHRDBvDdnrzuP3IiiqY0eoIAYQ363oKUNXrjPrhIEDE8ZM8MNevzH/+W1KRgsIykdD296Xm3webTFzaUBRTIYNtm1aC75nbgSAhPDaHjf0PG/ArYNhIk7tECpupi4kFmGLAz35iYFvcJejfnqsXfqbncAO0rsl3AonOOTLCkJupvCPm/DCLt9a8n6EqlSVcMpcUKY9VKDZM
 WXttIsQa
 EsMEHoICgMe5E8RYitl8ine3+GpxcLGaD567goXOjOBPNo3h7+KFhzWU03p8TRu9PL6Ld+iU3Oa2syeYNcjKTndHZi5axK9JkSHb//4liVR0NTFbMSgYOe0kKhfYgRCqEVvnpuEtBCRTleXEyqkEKzPMGhWnsedUEm1wIa+Kr8As9tj42N/NB9yRrsTaNDAWnm+ch7fgU7P+FbhfkVvD45ahPHpllhgvMPfsMD2O/IDAQraBldYD0wNIIu+cumux2hz/ld7eB/p4i4aWPqExfDuepwsV3/kdYVjJECST5OqfE78/UTE7PNuRKWFZDYnLaZsqD85cDgeEtkPQO74UlMna8CdM8aNu52Tjb/IKpwWiHCFspwNatwRNyeM+Har2IBUmoDuh3J7nzpb4iF9Dw9rMiyhy0xDPBgu0D49KlLTSWMJ4McdA47mo4+MgdOhpPrV3l21qAzPw/e6ixKz69nFKOfsgBM4rhIR5aYr13LrkfztgyqK7TTOspXymCz4HXlM78Tbna94QbcphKcvYsgKXFlrqt1gD9mWmoguCVZHZowO5LeXYI5OUlw5djOv/9PjNo1EzG5gtw9a+pxV+iz1nsiSdOekJxhsBW9AC+ElhJjWyaKcJZwAsQgVE0z0YTXwTwwUc//yJ8DV0LxMarMgDT3XRLvWG26+bNILq+8e7oDtMRTuTP5LT/95FD8+YXZi7YvwQPRdi289cY7EaxrBa2K6UiTN/yFDn/ar5UteUxeVJQOhsCLqpsFi5nikj/VwIP1TvdXs8EX6BlViGasx9Avg2bW4NDIxPcyuEcpnVJ3Iy2AmSQUg3lRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/2/2025 12:31 AM, Kefeng Wang wrote:
> Use order instead of struct hstate to remove huge_page_order() call
> from all hugetlb folio allocation.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/hugetlb.c     | 27 +++++++++++++--------------
>   mm/hugetlb_cma.c |  3 +--
>   mm/hugetlb_cma.h |  6 +++---
>   3 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 436403fb0bed..e174a9269f52 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
>   
>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>   #ifdef CONFIG_CONTIG_ALLOC
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>   		int nid, nodemask_t *nodemask)
>   {
>   	struct folio *folio;
> -	int order = huge_page_order(h);
>   	bool retried = false;
>   
>   	if (nid == NUMA_NO_NODE)
>   		nid = numa_mem_id();
>   retry:
> -	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
> +	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>   	if (!folio) {
>   		if (hugetlb_cma_exclusive_alloc())
>   			return NULL;
> @@ -1506,16 +1505,16 @@ static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
>   }
>   
>   #else /* !CONFIG_CONTIG_ALLOC */
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
> -					int nid, nodemask_t *nodemask)
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
> +					  nodemask_t *nodemask)
>   {
>   	return NULL;
>   }
>   #endif /* CONFIG_CONTIG_ALLOC */
>   
>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
> -static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
> -					int nid, nodemask_t *nodemask)
> +static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
> +					  nodemask_t *nodemask)
>   {
>   	return NULL;
>   }
> @@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
>   	return NULL;
>   }
>   
> -static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
> -		gfp_t gfp_mask, int nid, nodemask_t *nmask,
> -		nodemask_t *node_alloc_noretry)
> +static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
> +		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
>   {
> -	int order = huge_page_order(h);
>   	struct folio *folio;
>   	bool alloc_try_hard = true;
>   
> @@ -1977,11 +1974,13 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   		nodemask_t *node_alloc_noretry)
>   {
>   	struct folio *folio;
> +	int order = huge_page_order(h);
>   
> -	if (hstate_is_gigantic(h))
> -		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
> +	if (order > MAX_PAGE_ORDER)
> +		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);

But hstate_is_gigantic() has two definitions depends on whether 
CONFIG_HUGETLB_PAGE is selected.

>   	else
> -		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_alloc_noretry);
> +		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
> +						  node_alloc_noretry);
>   	if (folio)
>   		init_new_hugetlb_folio(h, folio);
>   	return folio;
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index f58ef4969e7a..e8e4dc7182d5 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio *folio)
>   }
>   
>   
> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>   				      int nid, nodemask_t *nodemask)
>   {
>   	int node;
> -	int order = huge_page_order(h);
>   	struct folio *folio = NULL;
>   
>   	if (hugetlb_cma[nid])
> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
> index f7d7fb9880a2..2c2ec8a7e134 100644
> --- a/mm/hugetlb_cma.h
> +++ b/mm/hugetlb_cma.h
> @@ -4,7 +4,7 @@
>   
>   #ifdef CONFIG_CMA
>   void hugetlb_cma_free_folio(struct folio *folio);
> -struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
> +struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>   				      int nid, nodemask_t *nodemask);
>   struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
>   						    bool node_exact);
> @@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_folio(struct folio *folio)
>   {
>   }
>   
> -static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
> -	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
> +static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
> +		int nid, nodemask_t *nodemask)
>   {
>   	return NULL;
>   }
The rest look okay.
thanks,
-jane


