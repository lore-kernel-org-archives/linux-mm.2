Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA3ACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A2E8E004C; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12108E0048; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2A78E004C; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80C1A8E004B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57EDC1A0392
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:47:04 +0000 (UTC)
X-FDA: 83800588368.11.7894B39
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB70516000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:47:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nLv1fZO0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="sFtP/TAs";
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XY45Th75JEu3LOmKB5B+6yAfRp4rktLun9t87BL2Pks=;
	b=li/2jA3TcfHFFpYacdbTAvROJQGbuhDqtB7q1mgPrT/ypXN/3QzBcpfAzk0KDaqML+Pd5c
	giBw2frxYmoA2td14uPiemMQIq6YJWzlP/fMbvTF9atjCKCFMY+MVVik8M0riIgYEoSt8P
	u1qbeRYBPPMSqI2UAa4Lc7V8gYU3j3I=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nLv1fZO0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="sFtP/TAs";
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755776821; a=rsa-sha256;
	cv=pass;
	b=v1ePVGgPfcr5QJwYdtOdbnZuK0uEUHV8L+nNnahRKMNPyJRw5Tcxj9B6qJbykcGaTz6h+R
	CJVYSs79wcEA2gZ/FaTFWvSDUMgxafsmFTHlu/ws69V1kGCdkkxPd7KUIsLk/ZJoyZEiAF
	QoIglZTFmTSCJXcFgMpMjCEWqVmnngM=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LBfMEN018310;
	Thu, 21 Aug 2025 11:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XY45Th75JEu3LOmKB5
	B+6yAfRp4rktLun9t87BL2Pks=; b=nLv1fZO0HY2QFc0aHk/YTD3w6nQFSFGC+3
	EgFxtNYNgc8jc3iUnp8pAuKD21piHbjlxIGnxlqOuSmArrWolpMCdtVrReLQznlJ
	H73LUP0JxNsNvNKjxOf0edanmJp8lJSa774j6m/ddVx1bmGAxAuKBiNFGeaupYfv
	aHZSq/mk7Z/Tya2rADW0UaXhn1OSvA5JltZRxNnRU3nXsLifNoF+zZe5qK9sRMX1
	8HD/P5BJMaVYR/9jwi7TsM5H+HV+HGgnkXQRpmxqbQirR8Tm1LFYW/Oge59pZQ7c
	6rIx3D43dkSj0uLAX5Z87oC3IX2W16tuqbdC3rlxF3WuZIVQQqOw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr38s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 11:46:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57L9qVtQ039559;
	Thu, 21 Aug 2025 11:46:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3ryub5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 11:46:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IP5o3v+rPgj2utAlG86Fmif74cKJ+gU54nLvLGpJjY+IOw8Zui5BDGVO75tIM8YMKhsmC030nNMCSOHH3DOjeHX4s4jlvXuB2mObZWYusVH+3El5jB8xZaCPlIyII8lLVLmLLzmog/HUYsrIBH9EJo2Gp51c5JILzRMZEv9GYzjlOKx9tW+TMXs7BEN62ZC84ZEwqk6LG3Y3He1r90v+SXJ73McwzY9A/T/ab91WItIFYPAIcCwKmIkRz42dEPGgHxAeamhB0PU/9sOsOFS4QkCtgZU8h0qVnZqCU1vaBsK56s0+EIEaOt78pe+1BkfT2dRhlKbP2dSFBBX6NjM/5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XY45Th75JEu3LOmKB5B+6yAfRp4rktLun9t87BL2Pks=;
 b=khAO+RGKoIljE2Ik7cd+JJZfQLR5FkeJvGBUmR3x6EO03DO2yRa41jrtMK1dAYpjvmVMyrP77RGV6QZwSXjzLZd/nC4DCFnL0qNoZEn2Scuk+UPrR6z3rVRf0Mq5W5mcdy88quuDDvAH9Ny685p97XSMW4DQiqNxf+LP1HOwEeh13hTIZoH2o8LfHdcTFH6gtTmdFm0YfTFUj3H3pISTWK207CPC8fvrtqt1zuyy7jF+6aq9jgNmz8g82UP5z3Bb4radsfmSN+ajTYGzfJ7fKsJFTY5SPuVak9OnP03l2C3dWb0ER0M9F5q3IhXALT0JkhfquSjTjIk5+8ioDhsGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XY45Th75JEu3LOmKB5B+6yAfRp4rktLun9t87BL2Pks=;
 b=sFtP/TAszgtpyhiyiQIp62oMgnWMuHTkEbq5ZbghLLaxNmJw9waSRpOr9NQwozsHbn+9yp2hfgpU/oAqiE5CFbAW2u815In2u8HIOxJgXwN0+MGjSrPO850BU6N7FsIUsHKZqP42muE54nHaUopKo+jQwguV/IoU5Zt38d9iGo4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6091.namprd10.prod.outlook.com (2603:10b6:208:3b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 11:46:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 11:46:17 +0000
Date: Thu, 21 Aug 2025 12:46:14 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, andreyknvl@gmail.com,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        apopple@nvidia.com, ardb@kernel.org, arnd@arndb.de, bp@alien8.de,
        cl@gentwo.org, dave.hansen@linux.intel.com, david@redhat.com,
        dennis@kernel.org, dev.jain@arm.com, dvyukov@google.com,
        glider@google.com, gwan-gyeong.mun@intel.com, hpa@zyccr.com,
        jane.chu@oracle.com, jgross@suse.de, jhubbard@nvidia.com,
        joao.m.martins@oracle.com, joro@8bytes.org, kas@kernel.org,
        kevin.brodsky@arm.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        maobibo@loongson.cn, mhocko@suse.com, mingo@redhat.com,
        osalvador@suse.de, peterx@redhat.com, peterz@infradead.org,
        rppt@kernel.org, ryabinin.a.a@gmail.com, ryan.roberts@arm.com,
        stable@vger.kernel.org, surenb@google.com, tglx@linutronix.de,
        thuth@redhat.com, tj@kernel.org, urezki@gmail.com, vbabka@suse.cz,
        vincenzo.frascino@arm.com, x86@kernel.org, zhengqi.arch@bytedance.com
Subject: Re: [PATCH] mm: fix KASAN build error due to p*d_populate_kernel()
Message-ID: <331840cc-c045-4652-b1e9-24253bb994a5@lucifer.local>
References: <20250818020206.4517-3-harry.yoo@oracle.com>
 <20250821093542.37844-1-harry.yoo@oracle.com>
 <60f006dd-3bdc-4418-b996-e1d31ec0eded@lucifer.local>
 <aKb3_jilvwq_gOkf@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKb3_jilvwq_gOkf@hyeyoo>
X-ClientProxiedBy: MM0P280CA0054.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d639d6-f005-4a7f-9b08-08dde0a8572a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Cth2TwFcULOW+6F5qggFPWMAMAlqhPKX4P+IdTlXl+9PeTQ7I5HWH6kCUWUE?=
 =?us-ascii?Q?UiMlzJScN9UzhgROlSrbNcDcU6nn0ptv08Tq4lwxXqbQ+YVcXncs3Mf+Pf2k?=
 =?us-ascii?Q?B6UnSCfWjzayvOrfHo9O4Ldu0rPzDXqCkOojZFIqBsiU5goypbRGZSummkvq?=
 =?us-ascii?Q?cs4XYxVbBz9HU3cRHWbLK82knOKV15mjxZxK3fdC12k8jQxCibSxRPpXoTRT?=
 =?us-ascii?Q?UU0slq8tvgYfykoEVqi+xsyaspZTlvuFiX5FFUQGfgAiBiP9pJqt393DM28M?=
 =?us-ascii?Q?RMPzIOgXs0VB5ru5McqhMaxaMqrFWF969D8beudtTsHq4ia4Tbjf0lgxzbuq?=
 =?us-ascii?Q?4zDUlt9s05raGh3M2O0g5WNsFl+S+/4TwnZVfouEtuvs1RuKqZiQc/5Df5PX?=
 =?us-ascii?Q?AaKrz3qurn8+yhwNQnziIBrnNZ7oJWaywhnaIvc8TgsKtrr3q/FHfoulpx4O?=
 =?us-ascii?Q?3XBu0+wPpg+qRys639spTuQ72nRub14VOViPjCLHPj14pl/KoL0DQhAc7dTx?=
 =?us-ascii?Q?YrbRzHz3gegsiNhYOqWsyR+xPm/85kQ9qZXZ3QPv/ejnDkTgAdfiThv2k4WW?=
 =?us-ascii?Q?eBvZ8SZGwUieyQIAE9S4QN0dPVNvSOismv9D1YcOC1R1oy+kMr3cqguROz3f?=
 =?us-ascii?Q?48lStRK31xEn11J7rwUV8O0oa99CebpX2naEMI4OzYv6KwOkF9gG0MSV3sPz?=
 =?us-ascii?Q?JpnVpjvVxQrYSdkWjk5by3UJA0VkHoD/30/7YIatM8Kp2StLFUXicVvSSAD2?=
 =?us-ascii?Q?Ittzdrl+EcYFt73dze7cH2fRiNdFgJH9iLZHiID1c8njIQFMViWDTyqmG7Tz?=
 =?us-ascii?Q?SFt2KGC7Wy4YDvVZVT+DZVsClr3rFNDk4kRYYzUAZ/11XyQiyBcJDfiAjaPb?=
 =?us-ascii?Q?tPcTf4O7NLMGSloPtyHv/06oEsp7vWvqSUzHGeCtB/1TIj/AXdCYXmlrLW7R?=
 =?us-ascii?Q?GjT+uG6RCA0IR0hIBOSTVy3OASY5CIQZfPvgENpmOftPooW0CPlZDgxq1h4u?=
 =?us-ascii?Q?uRSSnwnTPzmcQsKM/qv7peaZo9T8zk/zHRr2xZrQ+tnBI1xW9nNO/+W5XYx9?=
 =?us-ascii?Q?NATUVrI4vuZNqJRcOTIxowYDQ38l82FpfXtLhKCD73CowakzDFjTXwNoNXzg?=
 =?us-ascii?Q?AY9CZnvfmrWcYpiltyeUs6bpUmLPBkSUJOJ6QDGD3Q1EFwu+VU+RCBUstGy+?=
 =?us-ascii?Q?OcRNgfIkI0eqzydfZlYdgwSa37+fm9krBTTRh8d1CG5s5fYugKK5chAo+88O?=
 =?us-ascii?Q?8xsOW5zxmARSyvQDhj1FZBNyVTBRc2byu9e0LdIatnLwEs2Qsqkvd3T36rSb?=
 =?us-ascii?Q?JjGBxkwmU8ND9q/07l+wBmR86YuTJtaBind0sei9yLby0UpOgEFdTpJO43Oe?=
 =?us-ascii?Q?c7InHNnitFDMEkJwpfL5myWhG+b4PW98PHIjj01SJ0G9no2GnlnS/FRw6/Wc?=
 =?us-ascii?Q?lV3+uTFXifo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rCYjwlSNNJokIM5nmu+UFhcPq8+7VEnRkdJRpnkdcnrYDKdShFGRpLuLlJqp?=
 =?us-ascii?Q?pd2fi0QxXE1FUyQNw13lcVU3mHGZ+kJ5NejEhdjO7j3IUUrFyIzeEiUVyS4d?=
 =?us-ascii?Q?v4VXFxzSiu3PTC4pTX2Kx/gs3fFPHs2K4b8z4tni1llwh5jWHd2HX8nyF7c6?=
 =?us-ascii?Q?zhq2VCXQfDoy6H5EqAAE98R07gyYEPg6GBN/OCLvj6vMceLtqUyIE2zZnWL8?=
 =?us-ascii?Q?9C5JvpKgrVpHYh3Qe8C3TNmhji9jaNLFRazecqPINcJJmCx3eHl1XR6l2rIt?=
 =?us-ascii?Q?zxTZsKA0EAZ3WFKj/NTsRIQhhN7md9mYi4glBlID8elKFqqG0cT9zOgr/IXz?=
 =?us-ascii?Q?tDUTSTctF10i7z3N8AQFON+1rqZ/489Ge/bSha50LoRmAjd72oPZSdWSVjbU?=
 =?us-ascii?Q?AXdArIy6jAsR4GRjM3986gE7f2LAnYLTiOI7bEUlPYuDwZg+pY8TCmCKm3Vr?=
 =?us-ascii?Q?ZWnFvMuozVGMXEUvbGOyYAksZwJWE6i44bxOg2ouTJ0hCR1VynAbqnCTxaYN?=
 =?us-ascii?Q?jodFRyn1n/r3tpziHY7MzRSyGa1WNdnIaUS8M6HCy2+ItvnoV5gHKKd1s8I0?=
 =?us-ascii?Q?u3vilOXQA0VBBiglcsPxTvu5qw8q0voWVCgRmT42ImOh29aesJ5dgdt3ahYs?=
 =?us-ascii?Q?DcKUeX+AKCMpTIBD3tB6C0Ct9XRXfldWV8dqWzhj5wr6+TkXkGktGIwuqVsv?=
 =?us-ascii?Q?2jRhfhOSQx8Wz9hhioWPiU4bctwBsyViXyduRviGGFIz3uhxMmBrwrh4a/jm?=
 =?us-ascii?Q?nlAeB79ckoL9tHlUrjCEVIAHrmS9frb+jYBSPXgHbqmduy2y7AZYlgh0TOW7?=
 =?us-ascii?Q?B/iP05iMNWh/HkaJmsCWzu1xyyykpZHuVicGLEDGi/mHYAv8MInA1d9R97XT?=
 =?us-ascii?Q?vKJPWqMAxCPheK9KVJ57z8Yh/xX2FxcQ9Xvn/RVpyAzxMjHtevsHyiz9feaA?=
 =?us-ascii?Q?t9KLcD1rRdzN8VSZ96M5+sLqc0C2LEk6LWQHQqsl01K5hYkrBWTJnt4xQzjn?=
 =?us-ascii?Q?ysBcyGhtseOtFcNL46As/VqHTUPBACeLngN6D56wClCuLw1fHyF23xIShu72?=
 =?us-ascii?Q?V6CzE/iF5x6K6eum4RIyozyltMuFCoHMKufPg9gTP0XagkPZAHE9IAip7GPf?=
 =?us-ascii?Q?x9wJBodhnsqys/bRW7dNPSgDxQr9q+9g+BObTw5aDQ4Esj3A8IsiniDKN9nR?=
 =?us-ascii?Q?bR49PjcGsSxRwfVSkvOnm2dlCCKKEcJ/VRzxcoOyCjtolcXYOvu/totLghPt?=
 =?us-ascii?Q?7COXKmXYHECzu0t/5Ktztxff7DHA/SvnnzTQ3ajaLcQAp+zz47QsmM6PbEy2?=
 =?us-ascii?Q?KgA8iOO+/AMyKNtWPRWHdXsHvCZO90qpONghIYWGy9yGqeEM/ghgVtR2mIlV?=
 =?us-ascii?Q?D3Rc1/yA47VDGDAk1ub5CB3Pun6Mtvfn44rx4xFYG+QhtUAdhaO+ByK3p4Q0?=
 =?us-ascii?Q?ZQjwnYOoq2fGf5WLs7sCMwLvUGTzqCJlhSFKvUm11EpYyECNQ47Yxoe7bHYp?=
 =?us-ascii?Q?IhU6LQzWJRso6PhX/JJ2vYyQn+AQDa0lqlxUAzevP6w7cd5c5lq188EbK8Yl?=
 =?us-ascii?Q?EMyWFsAPe1wWgemKLZsaBYas9DhvACxWHJDu2i4wjSyjkFZm4iI2w7HWICxB?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PIwvMucxwos9rh9UHKCpErGfIOPg6QDVd2Uyt8+WHsVIt/8hzn7rah3t/jFR28A3WityAAFtqRgblQviDd75kO6ChkETtf2z5qHKvr0a89YnC8l8jQiKzcjSPtQmB7GeNZ6tnXghrjb7HWKq6Lq6NiZ5U3d2OviKs3XMG1a4fDAdflfTwWkX/zB895U8LvpSqGniXTtju2THi891KL/DTRugd6dNLxhNZDJ3nw9hABC4bEyEEVaKEfelHXRXOakE/p+q2qYYyCUGenWtZb02oXXrnsNJrTWLZuTaH4qnGxLZ9BTSAkPFLMZSjm7FzdpWguAQhbUKOhCx43SZ3xqn+rRsIaiFG/MDUHOkgSZIl3JjZYseB+3KkEJ9WopstmT0h82YnPyeokXTWb6ayVI2+uaHY3ZucHSbsR/552peSfbxwEqhSx90BSCefjGHBTCDwWtXO/tvI8cPo/mkVXmJOrXEtXgVFKDb0ANuUoKITWE6QSDhIlqRzj2RTcs0ZaMLwQcqW9dvfeKKWtCCVUQSqjgzhXZtp3+QtIkWjDBSauVGjSDjQhjSd3FHheTTjhB8cpzVrcQFvNVL7FNyUoQlkkRXU5EIG2OtWo7bAnpIkMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d639d6-f005-4a7f-9b08-08dde0a8572a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 11:46:17.8939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzY2wVCdz7agTR5HEAZGUtVSXPqLFkBSUL0y6q9sbgAO18Xyb8cRqd4WymT5tK2cQYoOQCYXJBnQw34UQXqAsjLv70sDz7lKk/X7bqHZCS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6091
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210094
X-Proofpoint-GUID: 0rhrQTk3sCqaI2UAN34L4oSXzj8RmxvC
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a70710 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=88408ZpHlHyaFS4QUzQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 0rhrQTk3sCqaI2UAN34L4oSXzj8RmxvC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXxCVhe/+kMYmc
 FEjX4jUxgqUhav0DoQ7Xu16n/lBUYg5vW06X2IQngNdlGVTx7JN8KZ3zCtkY4OItnpcytgcS442
 hL5XdcA92Ka+/IKIMR32BdzXws+Qa6BtwubISGcyd5Cb1SWBaSCWJ+ujoLpXJ7o2bAzZXF3meRp
 A178Rjkv9hZhufMcwK9hDBX2jJ55IgLCf2BDNTE/Y9bMCI2fKtpJPp7BYlCYXlnNQWoj/iyLVKN
 BsBo4g4guL9Xw4AgZiXdmwWbebx1Tg5Hnu4IESJQCJRd/c/HUr8DSGTdmLcPnpYo72Wkd2KzLNP
 UcZtq0eMP1a7XZw8jfRrIQ88V+/FCI8Z3eOPMsI3vGbOJhOtGY/ZhCI+J6xEpy6BbhiYXlEqESx
 076CiepGCHNs16K4ikSiCn/zdOiLXQ==
X-Stat-Signature: tjyuczyfrj19kij99ptn6kj9c9y9q41x
X-Rspam-User: 
X-Rspamd-Queue-Id: CB70516000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1755776820-291570
X-HE-Meta: U2FsdGVkX1+4Obi2dwqEH3Hp2eemrMO1kWbjC7k+qgvYON/zaP6c7RI5syQCbcNGrt4E0LFyTBB+pqh+isHY5D47R2npKj2RkslY6Hja71fcTAL56HXTpIsUAFyg2bBvIZQTLns2I4aV1XehEqUW933PNO4CdNGNR3LvxjAgTADTwYZ+F79sbEoPDAwU6ynEdxh3gYWCBZh1b87+31s7VqD9nYU/Ab61Acxsy+VPkoL1RmZDAuWQfNiDpiytnZbXgfeuIUhja9isptdK/yQ1YTyqu2bumorVkodcTQtPTplbaqcZ/Eew8B7Sd7KgLGC/jbLed2rbo9DMwa+olzh4Dc8EtwOwNjubdX4fMLu34Cckq10oLrqbqmcRJkKUJT78/pfPZtO60mjz3wPAwOvS73U7mtcFwBusYy1/J0/3hy1NT84/pH665kxkCvuHukna9nShh3EKgcfq2S6fSQL6RepStI973iJO+YUQmSxlZaGXA80eAJnDXgDBSosYRZuY616LZRGqujKiKD3s+w8EZsddDVTXZaHvNzDkZ22t8izAoiEKkFXpkKHlRWHtFwojBjEnabZDhjBK04ukbY2N3YeDh7kXXhMrpb48fulCX/EmnLDULl0NrXCHknVBXfVTSAhFy1KJ5GD3wKj3D2+fwm+KshcsP2mVs6k/BBjdYNT7dvZ+a9zBVAJ5y03evifS6OR/DAk4Vwf0MtPy/icnhO69bW2sED8T7Sv1J5/FGRFk5lFVj44qumNdHboCY4v2yfUXOp/iMM+QB164207tiwlR3PJz2N+3BXVzHzoZ2zQZYoeuo1CqNdrHm9hxN9he1FspQEfp5q/rXPK9mH7yDx27t84ph6z/XtkhbQ2CxqFT5nIMwd9H6XyrsI3PqHUy7fPpEQH39URQf2OihkJuFlJXqv/UBrmFe1pgq3QQDTiwon3MJ7i+ZrWpbIYYK6c1HshYF7B1F3Dh9H2g7bX
 /mYWm3q2
 u8JpkO5TlZTj9J9VephZvLjrWHTGgWtFZtRVDRxxg+H6T2hi0z7SlyPjeA07wHpEG+yvQ0tS7158uGiwWrYmKC/OY1Pnun3U6V9VxjeRYcF53sKl3QQFKgkXvCKN9zj5cxzgT4IkNlqH6/ZJXSPk3mRw4lwJbF8LpCVtqAjxaIPYWtTEEscU2AfRMYehPXkcuw/NtjthfWLGbunSGTO1c3xjBPXF05JQjKMti3pZm8bQwKc/kDm/xrz4x4IAvbiKirkb8sHep8ich0yJQO785xH80WMD9nIwKC7znkJcKZfbRWSIJeIxTysB8+QjpJYPNsfbZVojhfz629OMtywd0Pdt1ClzTuOQIRZg5d/y34t5ZH128AyEXlS03OatRP8ifbCT4aP4xQWM5RYWpw8TP3KT5KiFyp79gps7yg+mE3kxB3r69ZjIM6qnIIAtljzR/PmpnXLnzxUpabgdG9IenHWMsO+b8jLSQaaP4Fe9LU1qxlFasT6WHDyVtmAT4fd92KNNqAFENWwbVhQaKhAUoVUzpSOJrzLvpZlbwqb+a5+N0JXiEcln10XPLjTcP/VnDaWyb/bg3eVTSpewVtciSjLQv+mJTZIAYD1wZDLHNg5zgUlVYgKK0nfvE38ssyqBjsKqu1NS0qxuEIsQLUrXY3waK9ayQoCm3DKqVgoYcowvLsmyxzZIEhJFwQ0ZIMMx7Z9lyylYEqJ0EW9zAw87corybC94iKiupeRvvTEsU0mmQCdvjpmyYPmey/bDovGzzKhahR87Yv8krix+xPb5BRfEE+iz36EXzA2cvLuOuU+l1YYL7eGR47jtH9pFLREnec2XfQatmHS7Al9xNkOBrMIWWNvl/iZ4zm1yi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 07:42:06PM +0900, Harry Yoo wrote:
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> >
> > This looks good, other than the nit below re: a comment, I think when we
> > are doing this kind of thing it's necessary to spell out plainly why
> > exactly we're doing it because it's not obvious at first glance.
>
> Good point, will do:
>
> /*
>  * {pgd,p4d}_populate_kernel() are defined as macros to allow
>  * compile-time optimization based on the configured page table levels.
>  * Without this, linking may fail because callers (e.g., KASAN) may rely
>  * on calls to these functions being optimized away when passing symbols
>  * that exist only for certain page table levels.
>  */

Thanks LGTM!

