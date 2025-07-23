Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4BBC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2936B0183; Wed, 23 Jul 2025 14:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C566B0184; Wed, 23 Jul 2025 14:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28556B0185; Wed, 23 Jul 2025 14:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC4216B0183
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4126FB6380
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:46:04 +0000 (UTC)
X-FDA: 83696409048.16.DDC8C13
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21C3440005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:45:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1GtdYX+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Idq+Sxeu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753296360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qR+14lZpIE/CLtPoz538DOtlM9BK+6SSCoGxzXSPq78=;
	b=ccyOimz8yuCHR3CsWEsYSI8IXM3CXALumPcpqxxBw7jlKrFATQco3ewpu60jqnUJo+r7gj
	PP1Kr4kvl24S0P1lBqBQZNd0PmP3a+rKdYs6MMTTuPp/6bhuKi2lkpdeimstqjANetngsy
	PgpKkcdBHVJWXnquMOzMh3cGg07owjA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753296360; a=rsa-sha256;
	cv=pass;
	b=WmxzrLndyAWgGWa3Cg3g+kpQNwt7c5ETzD/jm28Jq5wZw2HOPJZx8GCOL1OCS6hBnlyhEh
	JD6HPS0kdorlbcIZ+vYoGyU4G5G/GxSQmgD9n0ohhGn5/Kfga3SNeycndpchkh5aiYXwth
	2CuVQ41oUB1GqcQ7c+BkWyqBbujYD+8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1GtdYX+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Idq+Sxeu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NHtvMA006932;
	Wed, 23 Jul 2025 18:45:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qR+14lZpIE/CLtPoz538DOtlM9BK+6SSCoGxzXSPq78=; b=
	L1GtdYX+Jy+MnQlOJex8h1LmJlUdE6aI1dqOuA3EZ1opWR3qiI3sp70nO9xNBw++
	lGrccKYCq0u46yn4WsXA0nj80qo8SaornxOEoClTGcsjA/20nTasVuq3nD6iILFC
	yzcjFOGItk9CDE7BNpyFvNeejY8UleG9zCajqqusBHox4S4D4kVvHihTP/jYUEut
	QPnVdJDdmmNCg0I+LnfNwej1C3VG5G6W+4jUWZpJ6OTPCAXdJP9NL9kUTJLoxeVv
	8/HYhDsJW0vedAA0bedg/3G51XFn9as9kIMgyu5XcmYIxoobgunw8XdKf4fmtI7H
	5T8BvN1yAFMnNZA1GYPdOg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805tx89bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 18:45:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NGuIT4031482;
	Wed, 23 Jul 2025 18:45:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801th90h3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 18:45:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VxuKNjBSPz8aMDkfjGvP1LX9KSMqfqYdXqGOVRX8ggHE7ZGjJ6W05AJzox0fBf8HFZ1FHUwqfvdoQUF3xA803tyjC4vKvsnvrts+UFHHafGLX0XMLs8ESzXNTNec93HgjRwHsT+Wc68Kts3F8whAG+fu7d3ZS9jEq94jNEWz53WrM2cjLYFffxKyDSYxn64sndQdgqcFJXbQigr4OoyXfJqUJT3MMQnqjTaalfLjz8R79Q0wJGjwtEGLLWzMCwIZKO66chnSd+sf+cenwwcV8kzh1viv0V3BTD8QohFKnFDjfw7u53FsPG3mh5l7gMXgj0jLyXjQOYAypQWmnUBb4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qR+14lZpIE/CLtPoz538DOtlM9BK+6SSCoGxzXSPq78=;
 b=jyyN1GqgMOHWzDJ7sfRi5DtpEPnxZ5Wvx1c/sP+zL14aGLPNejQK04P9QjbZ+daSSmG7KB8/W8vld1EDYnC4BDc4UeEjfM6KYFEjlH+mK4bG4EY40H2Ij0Fr93wYH9Pln1QJWO4fu3uBg9zcf9a5WhkgupiR3L90rO9VOotLUmCnywGIsOE1nH1UOntKoqe0vbBPZpZG2QZ8OwFVfvi8XTgNrAjjpE2TWFo16cpF1zGpUotPN+qhE3BYDDrqwLprfTtEZDivwzfKOzRFBQvSDYyrJ0VShKGETgXtjf4KKIP0sWDzX33skwLMTNO3Fcr4/LNdxoLiokcYxJbl2oBFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qR+14lZpIE/CLtPoz538DOtlM9BK+6SSCoGxzXSPq78=;
 b=Idq+SxeuKbYomnPb2DOQN3d/zGjSyN+60exmOWLTL/XYT4nSQU2RdkarSB0BGDoVpCh733E9a+ksrnjucCQQ818+bDXBKxJV+rdIDouce415aQ5TAgfTitXT2cz1mw8hZNa5a0aE5bfZi8A6Sy+k3YvWAi2ocks2CkIrQZ3E8gE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4166.namprd10.prod.outlook.com (2603:10b6:610:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 18:45:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 18:45:53 +0000
Date: Wed, 23 Jul 2025 19:45:51 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Message-ID: <3a233a85-3a94-422e-87be-591f93acbac7@lucifer.local>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <6df9812c-96a5-41be-8b0e-5fff95ec757c@lucifer.local>
 <CAG48ez1A17JC7Q35jmurY+Co0t_a78bPy9eRWRim7xJy9oLCvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1A17JC7Q35jmurY+Co0t_a78bPy9eRWRim7xJy9oLCvA@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0516.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4166:EE_
X-MS-Office365-Filtering-Correlation-Id: 65726e48-85ea-42e0-0c65-08ddca1926e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVNjaWxjbUE5dVRmMzhsVy9sa2lxUzVadVNZSHYyZ1I4WnRFeXplZE82NUk4?=
 =?utf-8?B?Q1dMQ3hpMWQ0dzhjUlNYWEdEMzM5Z2ZrNHEwOWI2UXVsS0N6Y1hEQndjaFY5?=
 =?utf-8?B?U1Z3Mjd2RGhHd1dzNDJTV0pQc3d6QkJCbiswbGF3YVJ5Um51cXAwRTl6QUc1?=
 =?utf-8?B?dHVmTGg3SEdMTlgrbk1QU2VTTllJeCtuaXluVnNmdzJ5NHdXeHB5ckRtb0Nz?=
 =?utf-8?B?bnZSSkZscHhuSlB6WE9FOUgvNHlSNm82VHRJRWdvQ3NodVMwSkxrYmpldE04?=
 =?utf-8?B?cEgvZUsyOC9tL2QrRHpGZ0wvSkJkM050bE5GUjhKUzA1ZjFDWmJRTU5OdzVI?=
 =?utf-8?B?dmZVRzBXREdMRjBNSWc1WXhORnBDcCt3bzFSSkM3K0JOVWVqSkFiS3hjV0Fz?=
 =?utf-8?B?K2IyVG5FcVUyak1Pank4eitSOHc1cWJFNk9SSGJ1Nm9CRHJxUm1jVDMyR0FG?=
 =?utf-8?B?enpUYXdTUE13SUdzUjRBRHJ6Sm04OGkxR01CQnltUWxBWTJaQk92Z0dXUmlF?=
 =?utf-8?B?SHJra2RHVGJKRFVvVjdwcWhqZDVmLytzK2RSWG42L0lKa1JjcUpOazdBVVlU?=
 =?utf-8?B?UkkzZUtGMVhPbzFvUzFHVkZpZE1MZDFrY01Nc0w3T3U1K2c0eFEvSnZnSDhv?=
 =?utf-8?B?K1lwdHNKemdDcmtueExmR28zODY1R3lsQTFMWmdIUjA1R2NmZ1ZJbFJmZW0x?=
 =?utf-8?B?cWx3RFRNbUJsRXdOU2ZwRWpVMDV1MXp1UlBMT0NaWEQ3OUxweFMrL21qMUVZ?=
 =?utf-8?B?cXExNjEvNDZ2cHkxWldySHd3K2lUMS9HZ1NqT3FLQytRc1FFZWVyT1RCNFNz?=
 =?utf-8?B?dnV1T2N6Si9zWC9NOWxnUzFTSU1SNm1Kb3FlNU1qbm45dzBFczJtOEFzSEFW?=
 =?utf-8?B?Tk5Fb2I5eno4S1ovUjRUanNQWGZkWjk4NEtOa2J3ZVQrblZFWVNYc2FTZWxM?=
 =?utf-8?B?dVA4dUFGUWVJNFNPRmhaTG9UeU5VRUo0NTBoVUtMOXEzdGYvQnM2TS9VR1RJ?=
 =?utf-8?B?bW1OeXJOdWREQU9Id0dGUTVTdXdYUGV6WklrS0ZGeE05YTZEUjUvbmE5bkha?=
 =?utf-8?B?ZTlSRWV5U2FSdmlVM1YrTTVlU1dQVUpvVk1YQjFNSUozNXZnRUo0K2lLN1Jo?=
 =?utf-8?B?U3pqdjlnKzlnaUgvaGFjZW1mUTZZQU4rOHRFYzVYc1pRSWhuREVzYzFZaEY3?=
 =?utf-8?B?NHpzSDVhb2dYNVl6SVRZbVFvV3FTbFpjcFFwV3E0bDRRSlFSNTYyaVBEQm9X?=
 =?utf-8?B?UlN6NmFWeHVqaDRsRkxMcWVHTDROcXhsSytyWG9lMzM4TGgvT0RaRjVhbXpT?=
 =?utf-8?B?RXhxbGNNVnRFL3ZhdnpUTm41ZjlCb3o5TkEwaU50NzBTNTNzdDBWTDg0OFhG?=
 =?utf-8?B?TTJyNWtPb1VhSzBmZkplY0JUd3d2N3ZyRGZYbXNuWFpuaTlTdWY3MDdlQ0Fs?=
 =?utf-8?B?bWJ2SjBrRk5ZTHJjalVMbEYzc1BhQzN4VHNVWUhxa0M2T1d6MzdqWjFqL28r?=
 =?utf-8?B?RVVwbW9WTThWTUZxVUxkR2pzK1d0U1FVaVdXcnV6UjFxaTRLeTFkbjFuYUcr?=
 =?utf-8?B?NGNLcG1Rdmk1ZDFic2w5YXUyamt4RjB3Z21NK0orNlhsd3Nsb2ZxM0xoRk11?=
 =?utf-8?B?MFlSaTdNaE5MWmxqelRsRTBLZE5xcGk0WkZnSThweUdGcXZ4ZERHcklaU2FH?=
 =?utf-8?B?eU0rZG8yRjZWVU1ySDdGSE5HOGVHWjhHaXE1WFBTOWZ0RWlaQTJJazIrZnAy?=
 =?utf-8?B?ZU0rTkRnRDllbVVwV1lRN0R6Z0w1YmVlRFQxdmRBTVgrY1dzMWxBTEh5S0Nm?=
 =?utf-8?B?cVFwM2R0RlN4bjc4UURHRGJSL3kvYjZ3YTVuY1ZiTmk4UVhtdU4reGh5V0Vh?=
 =?utf-8?B?SXNyR0h2Vmk3bWxZZXFrM2ZqR1lXZ3FlQXNwaVRYQitoUk5qcEo5VHUrNzZJ?=
 =?utf-8?Q?yzapAnAIT44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dE13WllxWC83S0FoQ1dSM2VJMkVrMVpkRWN6MlRNT0ltcmJwK2xCSWVkdnNM?=
 =?utf-8?B?SWdaVlM1ZzdhcWFUcHNCOVREK3Mwd2I2RjJMMGtqRmV5ZjZOOXk4UEJhVGla?=
 =?utf-8?B?V3VEZmdvbHpPR3Z4VEQ0TTFwOWFYQXdRT0dudzl3U1UrVkZUclpFdENkVkwy?=
 =?utf-8?B?RUdWV2ltQTNmTzV3WFNGbkgwYmI5Ukxja3Bick5TbkZxNU9ZWllHQXF3Wkpl?=
 =?utf-8?B?Z3BkVlVJaklidm9vNG5mTXQ5Q2lZQndWdUQxazRZakJ4MWRvaGFLT2psNDd5?=
 =?utf-8?B?TGFqaitaTWRDQVFhWkx4MHR6ODZIdFNEMFZZVDBhOTQ2UitldEtnMloyODlw?=
 =?utf-8?B?L2dtQWl0SkV2N1MxZzl0NC9HMzVMeEJOK29MTjJVeEZHNmQ1RHc5eGdHZ1A2?=
 =?utf-8?B?dm81L2lOenAxd0tRUUxKVEV1V0VkcFZ4Mmh5bThIdXZqcjh2VTFFM0Vxbjc5?=
 =?utf-8?B?TUZqZEdKQjhPL3VybTB1blZkanMvUUl2Z0FrOXE5cTN5d3gzUzNha3dDSkdz?=
 =?utf-8?B?WGtaVklEcTRWcTRlcXpKK2pHS3NXbkhNMWVXMWRhZXJGT3YyV2lNclgvcFdj?=
 =?utf-8?B?QlU2dFRneWdIUllzSEl1UXlDV1hPL0Z0VnN2c21CSnJxRFE5T3dnd1pUUVdY?=
 =?utf-8?B?Sy9SSzlWcEdid1NUb1VqclJ2YTdQcW0rQzdiYk1sbGxpazRUSU4wNDJHTHhV?=
 =?utf-8?B?RWM5YVhMU256WTdjSlB5VkVDaHBWbk1tZVNiakV5M0lEd1ZxZE5ZN3ZxMGpO?=
 =?utf-8?B?KzBJVlFGUFZuSDlqdnU1M0JzOVJMUzhWUWlTajJnQ3Zyd3ZjWlQ5RkNpTTdX?=
 =?utf-8?B?clVIWVpMRGh0Q2FCRndLbVJ3bklsWXZUdTZYbkVlRno1ZUhnZFM3U2l3NWY4?=
 =?utf-8?B?eGk4T3Z2V3EzMFU1MXlyUkxRNHp1OURwRC9ZSDJqdkdzSThUUU51YjQ1TnQv?=
 =?utf-8?B?TVFzOXU1MFRtZGpUcGJTVmF4TlJUSnFqS2ozNWgzay9Qa3FYU25nMFVTcEN4?=
 =?utf-8?B?aW5hKzVqbVdRRnpxQ2FIaHZPZ1JTSjV3U3M4WVJJZmVPSWtzdjlLQ2JpV05s?=
 =?utf-8?B?Wk1nend0VHJMVXgrcHJMVE5wQzVxTitWTDlOdVZUb2FBcjc5dFpuQ3EvR2JL?=
 =?utf-8?B?bVpsbjV3ZksyQlRMTzBMNHJrMkc5NzM5SjV0ajR5Z2o3SDBxd0Y5RzdKUnUw?=
 =?utf-8?B?WlY2b0d5bzNzcjZlMnZpcUJpLzlaZHcxYUswTVlBb0FjQzBPaWF5R0t5UWsw?=
 =?utf-8?B?MzhrZkpHL0Ixd3ljVmVSMmlyc3NZRm1OKzdobTFERllIaXJDYmpxRG4rVi9i?=
 =?utf-8?B?bmJ1YmNNalNnYlJrNmZMVjd3ekhHckFDbFd2Q1pySHhBRFB0UVNnMnczZ0ZS?=
 =?utf-8?B?MEU1aUNPUHF4M3VodlNWVGkvMnpQTlE1VVhKbWVlVVBTaVRRSnZXTEZxeFZm?=
 =?utf-8?B?R09zaGhZM0dNaHppL0sxR0VWTjlneTAraitsZUdScisxK0NxNHNweGxFVVAw?=
 =?utf-8?B?dXJVUzhmWHJPekFWbFZUVktsVHcrS2JzY3dhT1dXcFI4OUNlbUpVb3p6bkps?=
 =?utf-8?B?aDhETlF4NXFENit1TDR5alZmcFUyNWFJMmd4TkZGQlF0UHFHemlwcFhSRE1Y?=
 =?utf-8?B?bmUrbDRlWi82bEx2M25zamdVbkZvdi9CRDV6VzlYaC9ZRmhGWEZ2SzQ2TE1U?=
 =?utf-8?B?bXh4Zi9ZZ0NwMXNnUEJwbGlnaDB1blRqeWdNUlBuK3RCK2VUM1lRNHNwUWFN?=
 =?utf-8?B?V01wNzNrczUweVUzayt4UmFCcDgzQnR3YnVzUkN0V2w5S1RTTjRqeHdTNFRR?=
 =?utf-8?B?ZWUrT1ZoS2hnbE02L0hTUGJEdlRVU2dGdXRCTDU3S2lLVzJtWFhGbGowUk5P?=
 =?utf-8?B?M2xMRGdzSmxNaHgzQm5BdmU4V0N0bmpUdDNyVFBQaXgrM0Zja1dUZjB4RmU2?=
 =?utf-8?B?Vi9abGF1UWM3a3dXSVExSHdjOVIzdDNTK1g1d2RXcVdLTURMUWMwTEw0c09K?=
 =?utf-8?B?ZERuSXdYLzA2OHozTVJOSFVEbURyT0NDRlY4eVdXaWIxd1hFK2lnS3hlM2ZK?=
 =?utf-8?B?SUgvRDB4RXFqWEFhQVd6ak4yVzRoNGUwNlA4c0dWZ3FnRlljbFRXTkVWM1ho?=
 =?utf-8?B?THVPTm9mL1BwQkJVeGgxald6eFd0cnJobTVZUFpuYW1Fckk3TE1ocWNvcmdQ?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TVdjQX5c4raDsiQDpKOpFLHXgDsWgLpr2uK6S9CyEqn5/oViZoX+KMp5rXhKH3gqVCL3vHid+xqUiiQJDzPjYtTwSoWuCLWAHiPPXkZnS+qZsbJzQuZUSj+h2/8GBZ5g612oLKsH90UXHjjTLpNi8XOcYbHBKsJkwvpYO6RqzunLMRSejYZXtOu3IbH77AN2cMh8nt5biBIUFaO3p8X8GcrcVbd4VEqh996YNPaljiQ4ziAstGBtaq1YO4en4LxSUTncVAkEl9Ke71zbmSiMRDdPF0cp+bz1jP4+/QxwkYPrhA2fVdR/qKS3h3NFJ7U/Ugp2OPss0asfonvkioi8DNsTmJhBz3Uh6pACpi0yGZEmv0ktq7uFOzlGPfOYfFowAjh3zw6zTttGUKJAvAHUUKokafLFAP8HIKJNBwF4BC8U2bLx4AqRLBb+CPPkR0bsQ+b+YmuIETVIPbb8AU7GF+nZsydUKGm7g85bJoP9uzh0+V9QmMdjWTs0tEfbFK49S0Y4XefWXxxzYQzqaYC5H23z2IivMA160ByTAgJAUj/yBhjQKHmDWxSoEd75nbFo2/y2fc7C7L7Y/JMa6OEbpNB2TR7shaMrIb7Hn3gKm44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65726e48-85ea-42e0-0c65-08ddca1926e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:45:53.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TN5r9JUwvogtSM8ohdU4MSHBRr/2/h1zoEBePwOH6UHQpuSTtFpCPlU5GUyEwRF2BIh06jvE1tiT+5202MHbR2XE0cf7yIFRbkN8uqj2WWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230160
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDE2MCBTYWx0ZWRfX21VZH3BBEmXj
 U1jIXJA92zO1uS+flAyn2TP5UgIpbnGBoj+NbO57k7SeuNOAJJ6w3KwgltID2vHebS6TbERLyJD
 h6+aX+qjmH62zKdb5SYurxCssf1Vz3+zmtGf0IihmH1zb4FNz0es0stxYNoIZuW2yJT1ckhATqD
 24f4WVtNvwfDAoHDO0gFHhucOc3vj0+Ln/e0xeyzVhTjwL9lWb0I6p3jVXuGj0LSI/dI/QqAtuw
 7tKbNb7O1TiXnZ+hLdG5qlkwN2xUrvavtlJDLX/i+U4iNU2fnssRHIHa929H8e0bgavwriTij05
 zRdzPF8wsdN/M6lowBEYoh8U2AUmHCtGw+a+X/TwO0b91pXuWaan3v12o+yyKSoPAdCJ07qViQI
 OHCnPDBnk9urHQp4MCl05stBa8NT7zXye7SDArUpeRLCPgUTKy7Bv7BxO96cjIjI4RyjslOG
X-Proofpoint-GUID: nM66w9XE8s_r2RNSJJ8FIyHu7DG6TPLJ
X-Authority-Analysis: v=2.4 cv=IsYecK/g c=1 sm=1 tr=0 ts=68812de5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=rjq3qn5PsE02HhgjDZ4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: nM66w9XE8s_r2RNSJJ8FIyHu7DG6TPLJ
X-Stat-Signature: i4ikkhothh8gojocn6w38pd3mrbaikzd
X-Rspamd-Queue-Id: 21C3440005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753296359-290010
X-HE-Meta: U2FsdGVkX1//QSE/sPGvM2AWoq+2MuvJsaTNOlSghRNXf+jWTTLDsC5aKQ3VOO2BbfDmJlAOePNivEaGYa6mw9PJiDD7xI/4sUWOZ3ID7EHhZmzTt1bcivyb1wTIuBq17hOkFlgbMDB60R7PnNhbwwUCucodGWeNTiVnWPIYK/XsOu6jsAcUGS7DMRtYkA1yxnfAZTToU9bTjaIh6I0lYw3YIdOPtXMyQ+Dx0n4CKllXk5a6Td/Oza8jmWY56R3ny9E1RHm9AlfFX1QGG8Mnx45ySitb8QTT8wj59S3yKDMdYdSciHEHQoLgPM/Or+OkuiZsOgGRXQF4oITecPr9YnPyQ3URTlYk3+72+K3QC3NJXm5qeoPAUBfjBWGWpG1N95I0IjpsHDwrQS3oT4UH1NiA5BAiZGC966SqcGhYNbMX1KUYjwutxN2DjkAizjNe8FArTZfm1yz9e3kks6esjw+vVYxoH8YjyK245TGJ4BcuZx6Ghh3eow/Lb38Qj2HuzacUkLQOp/qyvDwUibQ2ejBX2MR1+508WR2wheSnOIDUmTFdSOaZwKwyO6Z0t/5tSKn0d1v8o/tHyQFNHNsv7jCZCk7AXstY36Tray7FiLoPqYQigohEj4Y3xHyHZLMPLeNc6DDSvzhNH05lXzZ3SNSOPLHa4F25sz9vgrlrCXQHll2huawQGiU+FbPOV5YwObiejj+zjOOX69AQnzhJi1fLZdYe+6UlRIRaUNwj9S8M6cINEGzoqY7+ONG37s+j13gZqNBxVM+Unc+24csXW0f0+qI14C9jdZkGBbXKFuc+x8tRRjmliJ68gLTdlw5NMXcoSMZDCjyDHLkO+FZo+Ov1OjSjsuzXSx+8PS62iE9ZRgA1Ai5cahN3Zv/BXkgqg2SJ9YUK5hSuB4j8UOIxXf7pAdCtTqT5oYXp4h3NaLV06tbd1JK21M5/QrDGZRZBFP6W4E8/9CpNZ7AAqFE
 uL4k9mqF
 75GOL8erQIrbkuh5hXS4HQAva5oZqtKm15qllDafwLtgYrgfNVlGJ7BEq6EB5oepjvPbcC7dnu9Z+V5/cJZ257/+P3zOzReZhum7nnRlk4qTlDxZYfwv5GdQxzMwTLWWgnvl8LZ7Z1W+v/HBzUipE+Zm1EWP0r2dRiARg9j1mBiaYNOtTe8P66lxRCXrO8OXXjkLO/oXxyO/X9J7eZKob1IRr3NHy6oKA/WQh/qLZhLBEubABENj79YjCUlAMcP7j7xulkkEWF4Q0UAADMAYeEMxRYPiCQPceQ+EIKV/3Kznym3DcE30OJA37ceOgjbaOc5HGsISTQm1XO5qmsolbnu7jwAH2eMqmXHOZ3FwAQKdAU/Q5fXYPuuQvvQTIZZ1JvFhac0tHXvnwPMAIJ37nsBnNuzYyPGKQcQKAhUCuuu9qsgcto9iND5GTuEbO95khxY+l8kuxxcf7Mjf2JRK0/8dCxI8rp94qB38c8GD5p6GjaeN2S+y+AHQcLC0FUtOlz8bv0AEvzOAonKlxTzvV1oCIr8rNxmYo3I7IY4BeGYRU1h6AbVgUd5zlN4C8fjBm6bjPmUPsVB8DxKSIZJFHknyXm8DCbgkfFSLjZDBpYmREfqUCD8mqoWbqUxJ46+v1cXhQ4OJaQmY6BvDVzf1S6d8aFyY42GrTa6MU67niKj0XjGB+CtQwVywVpfPPa1b13r3oNkmr3Z2ITWs3r6X80c5+mmpqcq85DosH0dUbAkMqIM2LfeBjG1l9fZfUYCmYbDw0X4SGapigFjw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 08:30:30PM +0200, Jann Horn wrote:
> On Wed, Jul 23, 2025 at 8:14 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Wed, Jul 23, 2025 at 06:26:53PM +0200, Jann Horn wrote:
> > > There's a racy UAF in `vma_refcount_put()` when called on the
> > > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > > without sufficient protection against concurrent object reuse:
> > >
> > > lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> > > rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> > > it can be recycled by another process. vma_start_read() then
> > > increments the vma->vm_refcnt (if it is in an acceptable range), and
> > > if this succeeds, vma_start_read() can return a reycled VMA. (As a
> > > sidenote, this goes against what the surrounding comments above
> > > vma_start_read() and in lock_vma_under_rcu() say - it would probably
> > > be cleaner to perform the vma->vm_mm check inside vma_start_read().)
> > >
> > > In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> > > will then detect the mismatching ->vm_mm pointer and drop the VMA
> > > through vma_end_read(), which calls vma_refcount_put().
> >
> > So in _correctly_ identifying the recycling, we then hit a problem. Fun!
> >
> > > vma_refcount_put() does this:
> > >
> > > ```
> > > static inline void vma_refcount_put(struct vm_area_struct *vma)
> > > {
> > >         /* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> > >         struct mm_struct *mm = vma->vm_mm;
> >
> > Are we at a point where we _should_ be looking at a VMA with vma->vm_mm ==
> > current->mm here?
>
> Well, you _hope_ to be looking at a VMA with vma->vm_mm==current->mm,
> but if you lose a race it is intentional that you can end up with
> another MM's VMA here.
>
> > Or can we not safely assume this?
>
> No.

What code paths lead to vma_refcount_put() with a foreign mm?

I mean maybe it's an unsafe assumption.

I realise we are doing stuff for _reasons_, but I sort of HATE that we have
put ourselves in a position where we might always see a recycled VMA and
rely on a very very complicated seqnum-based locking mechanism to make sure
this doesn't happen.

It feels like we've made ourselves a challenging bed and uncomfy bed...

>
> > Because if we can, can we not check for that here?
> >
> > Do we need to keep the old mm around to wake up waiters if we're happily
> > freeing it anyway?
>
> Well, we don't know if the MM has already been freed, or if it is
> still alive and well and has writers who are stuck waiting for our
> wakeup.

But the mm we're talking about here is some recycled one from another
thread?

Right so, we have:

'mm we meant to get' (which apparently can't be assumed to be current->mm)
'mm we actually got' (which may or may not be freed at any time)

The _meant to get_ one might have eternal waiters. Or might not even need
to be woken up.

I don't see why keeping the 'actually got' one around really helps us? Am I
missing something?

Or is this not the proposal?

>
> > If not, then surely we can just do this check, and not do the wake up if
> > false?
> >
> > I may be mising something or being stupid here so :P
> >
> > >         int oldcnt;
> > >
> > >         rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> > >         if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
> > >
> > >                 if (is_vma_writer_only(oldcnt - 1))
> > >                         rcuwait_wake_up(&mm->vma_writer_wait);
> > >         }
> > > }
> > > ```
> > >
> > > This is wrong: It implicitly assumes that the caller is keeping the
> > > VMA's mm alive, but in this scenario the caller has no relation to the
> > > VMA's mm, so the rcuwait_wake_up() can cause UAF.
> >
> > Oh yikes. Yikes yikes yikes.
> >
> > >
> > > In theory, this could happen to any multithreaded process where thread
> > > A is in the middle of pagefault handling while thread B is
> > > manipulating adjacent VMAs such that VMA merging frees the VMA looked
> > > up by thread A - but in practice, for UAF to actually happen, I think
> > > you need to at least hit three race windows in a row that are each on
> > > the order of a single memory access wide.
> >
> > Hmm ok this is confusing, below you reference threads by number with
> > letter=process, and here you say thread 'A' and "B'.
>
> Ah, yeah, sorry.
>
> > > The interleaving leading to UAF is the following, where threads A1 and
> > > A2 are part of one process and thread B1 is part of another process:
> >
> > Err but you refer to A1, A2, A3 below, should A3=B1?
>
> ... clearly I should have proofread this more carefully. Yes, A3 should be B1.
>
> >
> > > ```
> > > A1               A2               A3
> > > ==               ==               ==
> > > lock_vma_under_rcu
> > >   mas_walk
> > >                  <VMA modification removes the VMA>
> > >                                   mmap
> > >                                     <reallocate the VMA>
> > >   vma_start_read
> > >     READ_ONCE(vma->vm_lock_seq)
> > >     __refcount_inc_not_zero_limited_acquire
> > >                                   munmap
> >                                    ^
> >                                    |
> >                                    OK so here, we have unmapped and
> >                                    returned VMA to the slab so
> >                                    SLAB_TYPESAFE_BY_RCU may now result in
> >                                    you having a VMA with vma->vm_mm !=
> >                                    current->mm right?
>
> Yes. The VMA is unmapped and returned to the slab at the "<VMA
> modification removes the VMA>" in A2 above, and then reallocated when
> B1 does "mmap".
>
> > >                                     __vma_enter_locked
> > >                                       refcount_add_not_zero
> > >   vma_end_read
> > >     vma_refcount_put
> >       ^
> >       |
> >       Then here, we're grabbing process
> >       B's mm... whoops...
>
> Yeah.
>
> > >       __refcount_dec_and_test
> > >                                       rcuwait_wait_event
> > >                                     <finish operation>
> >                                       ^
> >                                       |
> >                                       Then here, the VMA is finally
> >                                       freed right?
>
> Yeah.
>
> > >       rcuwait_wake_up [UAF]
> >         ^
> >         |
> >         And then here we try to deref freed mm->vma_writer_wait
> >         and boom.
>
> Yeah.
>
> > > I'm not sure what the right fix is; I guess one approach would be to
> > > have a special version of vma_refcount_put() for cases where the VMA
> > > has been recycled by another MM that grabs an extra reference to the
> > > MM? But then dropping a reference to the MM afterwards might be a bit
> > > annoying and might require something like mmdrop_async()...
> >
> > This seems a bit convoluted... And I worry about us getting the refcount
> > stuff wrong somehow, we'd have to be very careful about this to avoid
> > leaking VMAs somehow...
>
> FWIW, the slow and boring solution would be to use wake_up_var() and
> wait_var_event(), but those might be too slow for this usecase.

I don't know what those are, but they seem like some general waiter/wake up
mechanism and yeah... the whole point of this VMA lock stuff is perf so
it's probably a no-go.

