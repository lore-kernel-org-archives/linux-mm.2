Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85809F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDDE6B0005; Mon,  9 Mar 2026 11:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C496B0089; Mon,  9 Mar 2026 11:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709066B008A; Mon,  9 Mar 2026 11:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3376B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDB5B14022D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:54:32 +0000 (UTC)
X-FDA: 84526971984.18.66E49A5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 61B1D180006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:54:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HM5Ie6cT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fcVPfBa4;
	spf=pass (imf24.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773071669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIL4zV6vBvoN2OpM+kvkUT/Dsrs2s3mqH5wBnleeA4A=;
	b=f3RdoXgz+eGFCEFfwiACAJpKNryNZ/lSliQ0oH2AAk4ybnxJwcPDOQUjktqmIJRjeJlxfI
	NtsVw5hXPzQrj2XmJfDSVjKDpiQL22qSAZx9Xi6C885eTa+LIY3ZlW7QB8/+F+UPFi6u+6
	/KzYUL0wXtWkodFx7FuE+kCd++hqVDs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HM5Ie6cT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fcVPfBa4;
	spf=pass (imf24.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773071669; a=rsa-sha256;
	cv=pass;
	b=cCQIAPFT16m0ZFa0ODWlv4Yzz6XKdaiXkZsDK1X2+mH99Du0VyRmIkjMwxaszZDhhyTu+Q
	BD7H0rXX8bLAyHqaI1roYR/B8jsvRWAuIO7Nb+k9lIF1/Zd8RyIw3GV+PTwoGjDoGaE564
	DTXYvIZtUGXgU5UeM7QbojG+QP4ijyE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6298vcS13294483;
	Mon, 9 Mar 2026 15:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YIL4zV6vBvoN2OpM+kvkUT/Dsrs2s3mqH5wBnleeA4A=; b=
	HM5Ie6cTzSirqmI2IMfbI1ruAeOWlUsMyGPZ+A0K5oWzl1kWhf/4nKRE65PoLuSN
	pB76+l9Py5nRqphwMwSbWi/Pj653wPiPGw995JYera7b31r48nek7Ax89/tKkilk
	Mmk6wX5LCAGhNrQKbGGTKSmAu+GoiJH2sIHheDXWALv5btA6dopu96v2iTkLMFEz
	Xrs5m354nE4hlhW8GMNF+ktblXBgktvyjreIPkQaRFdiZiiuXYa3lK0COHI4VXv2
	uz9pr6PmkoQyYli/q3iueBZner9imjoGJQ0Yb+hfB3+xH43oHC3DXShKUQXr8Rpb
	N8x2eP88227fiRN1HD9urg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmdkh6dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 15:54:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 629ESgoN039680;
	Mon, 9 Mar 2026 15:54:19 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013036.outbound.protection.outlook.com [40.93.196.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf8weqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Mar 2026 15:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sk2VweWMtBNjCkALZfmYNWQs2O50CDHzqGbkoR/3F/VCN34o9LZQcn3TdIiYFg/CRQto3yWWFL/xQ7mRlPGA2KqMOxN8Dba+ZZHsNk0DMxnTAkhzjiDo9pejmeqNBbBURIZQI6KyVm5XX71dggqJ4qiFyxjs/hh7azynHSvWejSWwW+9UAFLCs0nqrryT2J48ae48iOYNPD5fenW4ypKO8WU0GFgJdU4XrdxnnZk3mpF39NhtE9/leWynKveT9Zm4rQ45nCfQHSLOQ3PQ+0d0eVOWsWHfPxkacBk9hIJ6rGVLA3l0Nhy9N11FXIv+K2zVJJWjKIPAMWfItXVVh9niA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YIL4zV6vBvoN2OpM+kvkUT/Dsrs2s3mqH5wBnleeA4A=;
 b=O5rdm7+bu2Qy9NuTVGyCeT7ybJuQ6D8mjf12NG1ymQvqbHJRB9gSv9hicmcGTjZGQPTv1/mBDN9hw34NyEDKKzGJaIxdUbOb33/W2Acov9Ry9WaPQzd/NcogLwD+rHZMpKIipTtHd9Olu8v58FSrsl7jK5U9gRtKNLaI5cFEqBE2Ci39IIBjD5Yz8fTdqg1nWN8sgR8mBfFf3e/MyTlcuoiUbA0Ko3Mo8LHYpHhO4+Nvo+qJXB8YbgaYXosGIg+HSBoAwCotL9Fp/+fsRSmrSY3iP6Hy/YbD+wShrJLwJmUkl+UszXPgF44vEU0h6I+yoOVyVDTet6Er5xFvtHiE+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIL4zV6vBvoN2OpM+kvkUT/Dsrs2s3mqH5wBnleeA4A=;
 b=fcVPfBa4aBxw3wO6uI1UAKxUrO+hTy02lu4jPiqf5xtaNiS1vzdtbAB9O1RamDAbBtQzJpH2v4XgcxzN+RSbeEGrhCCk3VfM2y9OArgRY/hJZ39sPmCn0AJqH02InTeh9SLo3JUbrUAOC76NXSLVQoH8a3ZryxrTIfIeAfouMX8=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by LV3PR10MB7962.namprd10.prod.outlook.com (2603:10b6:408:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Mon, 9 Mar
 2026 15:54:14 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 15:54:12 +0000
Message-ID: <d34313c9-4584-42af-b9dc-bddbcb67766e@oracle.com>
Date: Mon, 9 Mar 2026 08:54:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
 <53d66564-0596-45aa-b639-e2ea15356ae9@lucifer.local>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <53d66564-0596-45aa-b639-e2ea15356ae9@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:52f::26) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|LV3PR10MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 17454e28-4e81-49e5-26ba-08de7df41bdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	eG8EiChtLudQCgX5zEEgwFBDlEUNpTTjc+fePKjcMr8NiCVF8u36+ZtxPxOcPYnCCmcoDE9w8XAghqdZb9dHrSdtMm+RJVmJBPY0jgS31zXvq3VoxrvUx5C7Gdz32/lFgMS70FZx7qmCVva4ptAHnTlA2uBOmCNX9rw1HcpI/DdF25kGMyX1Pnmvha8hBhOorjZTY6350+zs9rSCFd3zFFbEpJ1+1q3xQb67nSs72atIsR4NW1hGfAdlvowz6mbK05MsrYPg43+TMiMKA/8CRDcSk9P8Nc8c/6OzS0L7gwFeFzkmu8DVl1DvaMVdETQ3MoGo6NXCbaynNgdTYVg37DVef2HFOj+WR3jC47ebBt1KukOPCdgYI2rMCKJ0PgWdeswRmSsr9zCAVWzHaq6U6pAItmWlGcqgwrN1OUvhVrwz0kff7CiJr4M9v+Oemop12S4z8DV5KMuhQs/SjIfGzq5q4TAyz+GVqtnmYt4YhdBgo1GxdKCKqc1mHhuhCdMAbRuLuYuTj26PO/8Umf3RN2L22B+2pD3nw0LnVJ9JYejj28GAbT5DMaCry9pzeodFro0rRnBRUNWelzy0Tk43efdqFVagp9r3b9a+/ZEVF91/HRhj3IpBu8o8XlpLxZRYw32THSOG0z5n6v3oAFUYwP6ONLYBj0dNXKDMlch07NySfp8F+/n6iLJm5wiazBjMhEyFBTW9sDz3L/qqChW+aiX4+b98oa143bd2rfPnbwQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2dwUENWdDlDYUNEWHdwaTFMdGpKa3RQR21xYi9wWFRPYTQ2Z2lQQWhOZ2R2?=
 =?utf-8?B?RTdaVGVsZ2hLbFRTdU9hMTBzcTZpeExRSlpCUzZZcTQ2bk9vcFVXbm9FZFZ0?=
 =?utf-8?B?dVNJa29reFVkVWFhbW5hWUZ3WXRidTFhU20xeDQvM0lzUldtN2Zib0w1bTdt?=
 =?utf-8?B?bVdPWmIwOFFSZ3UyM3hyb1EvbjNxZTdteHlDeHAxc0JRd0VvVnFwUW9QM0dy?=
 =?utf-8?B?K1V2dXgvKzFsOFQxS0VaNFY4dWh1bFVram9YeW9Wb29SZW13Z010RVdSNkxv?=
 =?utf-8?B?LzduU0FTSGlFUHk1dmVhaHR3bDlYaVozVUZQYkREKzFxckVqMWdPdkxFSWR1?=
 =?utf-8?B?cXg2SkhiR2VkM0lqU0pHRUd1V3B2anU5N25YdEkzTjB3M0YxY1ZMdllxVVNK?=
 =?utf-8?B?dXlHNnc4U2NvN25DaFVtUVVyUmYrdnVmMmVENWtsczM5a1ZiaGdnbjdhMzQ4?=
 =?utf-8?B?bTErcDZZWFl0ODJrQ2dUMUxWV2tSaWpsMitHbHNZa3hyR3g0UiszMHVyZFoy?=
 =?utf-8?B?emlNejFxNStTaDR3VStBUnB2WkhhZyt3WFB1emdqVzVZd09hV0dseVdWTTNo?=
 =?utf-8?B?ZEYrMHd2U0JqNXZkNTBWYWIvbUJEd1lSdHQ2MVY5QUVQT095cjVTQWVqcW90?=
 =?utf-8?B?V0pidDZCTjc2UUZEY25vSTJ4cEZjS08xUmdNemRRaW9tWkhiUWszODZJTUt2?=
 =?utf-8?B?eHVpT1pWVnhWWkZoamt6LzFLZ09rOFFzOGpzTWg2S2orM2VoYWhianY3aDZU?=
 =?utf-8?B?QVJYT21NR2hhUXdOSWdXMWU4TU94SVBqa3ZSZXVHc1N0NEJGbUVKSHJFYWta?=
 =?utf-8?B?TUdqZ0FsazNnOW1Jc2wzeFMrZ0t4ZjRISnF4amkxcGxxZ3VFREM4NjlhR0hP?=
 =?utf-8?B?cXNnVTZSbjFFMUNxVW9aUmx6RDVDTTFWbDBFMERxajhpcllLNnlEQ3FMdTNa?=
 =?utf-8?B?a2tqU1ZlNmFRbmZRdFZtSGRDc2JXZEFkWC84UUx4Q1lEa3Voc1ZyQm03QkJa?=
 =?utf-8?B?UmZpOE82elNudURyYjljcVVyemNQMFBEblB2SW9zYm1HWUJjMWZVMTFTK05N?=
 =?utf-8?B?M1FGdzNvLzhIRzhUWU1aYmJOSldQQTgvb0V4MzhjR05yZVlnQ2RMTXRBQjVB?=
 =?utf-8?B?cmFFWFkvbXVMbnVRMGhJUGRvTU80dUk2SFdLSUhBTGw4VTdCZE1XMTU1SlNw?=
 =?utf-8?B?TnQvYlBCdGdwSENucVJ4YTZaem9pOWl3TVprUVBsdGJVa3JBU3JJQUg1Qi9n?=
 =?utf-8?B?RExJdTFGSUJSTTkwVmtjYWFqTmVRSjl4ZzNuQjhKL09rWC95Uml0V3hxQjV2?=
 =?utf-8?B?U1F4NTM4cWlTWkhOSTc0SDc3UDhRWnZLUnpLTUhtM2Q5d1F1NzdFaGorSjVq?=
 =?utf-8?B?a2RJQVloeC9PVktSVE9rQWFKY2VqdUN0VER1NGNTSEt5VWt2NStRL0lzVGFx?=
 =?utf-8?B?MHF6N3FuY0x3dndDUkl1eHQwT3doYmJLbHpoRGlOdUtDbE1KNzFtV1JuUUhV?=
 =?utf-8?B?SnpGSm95WndRZndXWS9WVnFjUVovSW82S1l6RzNYWkxMaFJXeG1wcnhWc0t2?=
 =?utf-8?B?TlB3M3drYlBHRUNnVU9LWng3MjcrSzBoMHZkckxHdDBsYVhicWZWUFJMaGdI?=
 =?utf-8?B?WU5QNmU1d1cyZTJuYVBBak5BcXhya2kwWmRtYjZDKzkyQ1l0VGpoK3RudEE3?=
 =?utf-8?B?cFM1Q3JFQlVUZnc0Y0hWbU1EcUJDL240YXZhR3dmVmdZVm9JNmtxSEp6Mlpp?=
 =?utf-8?B?OUp4WjA2U0hObFdwYlh3Yyt0cEQ1aWZoQ3RkMDJwQ0NLYURTMndNeW43Zks0?=
 =?utf-8?B?eTRZYk41M3J4MTZqdFQ2bEtDbHg4R1BmM0JhV0NHeUdVMlFCNExaVjU4SDhz?=
 =?utf-8?B?M1A4Z29aczBIUk1LL0JuL3VLZ2RHL082NE1GekE0MFMyelFHQU1wU2xlMWxo?=
 =?utf-8?B?blQ2ek1UcWd4b3p1NDAvaHdYRWgva1lmV0N2c3FNdmxta1kxdWIzV1I5OVRD?=
 =?utf-8?B?cFMwb1hCVjRpOTN3MXFJdmg4VzNMc01xeGNRQ3h1NGU2WXhGdmdibGsrNEx3?=
 =?utf-8?B?dFpBb1NJb0pSc3FhOTBuMEZqRzlETmtUTDFhOFNSNThMMi9ncU9nNDdzcjZm?=
 =?utf-8?B?ZGkrWlpRd2ppVCtiUFhqSFZSN0N5Wi96cEdqanFyTTdiL0Ftayt2cHlEZ1Jm?=
 =?utf-8?B?bVBENHhJdEd5a3h2RGhBQUdadmkzMktrMlpSaC9mVjZ4YVFSU3RQUzk2d1ZE?=
 =?utf-8?B?UzJWNlk4WUoxTFY5VVdLUjRtOC9CVERDVlUzUVlRcUZjKzdJZ0kzMDY5UzFG?=
 =?utf-8?B?T3dFTEhBN0ZOaCs5SHRTbVJmcllTcmFvbmJpNGczYkRmRU1qWFlIK1g3anNk?=
 =?utf-8?Q?nAK7Gm6AqEvGVyLQ=3D?=
X-Exchange-RoutingPolicyChecked:
	ZhKyKCh6wb/0zhWTlnkOtDHdaWVADO6PSz+YOp6080QdHrszQ8SAaLClTr5txeaTxmIkJGs/uA2tB9B9d+SZIHPZMU8No46YwcQ7myHI/3bj/2659WsMAKE6yekYu+agvdhDz28OwFs6ZJnsD8xGs6Jmq5rhZFQhxSPeFzofu8Lr0yWDV8TPHSV4UHvv292ZQD3P3AD328mZYVwgwjv+6MmEDheUPNAuGY9/8g2G8dhfXLAjegJ3QRIZMXOWXxuuftkv0ted5HLdQrjXw+1FdnA2KseoYN4m23ap5cKVJwcMMRl37vZ/bzRhmIKhczeP4qVTG8/fA/FoXMDr/dFqJA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3AgK+vuuZU6GfKDHj6ZeP4+q2V6tb+KqLBXI8dVgoKPrZlU0RwSO4ui3SFoi6U+BE4CmhVcIfAmtsAkT/3Har9GeugfxUxAAT0hfDLoR/sYPlEJ3LO2NFfgTjHpJQbNJTYB4+PcIf2L9FQjCfKfGdzCWEvpHndcOfjVyn1iF33sgoKB8mfb3nFFjdjOsXV6zV4GMlghHfpYFPhHx33zwfzvR8JUIh3EZSAQk2o7z4vrEzbCCPWkS98GfRrJ18kMQPT3fTrdnR38RfsBqVlIV8EziS+0cNGyLIYladTFNx1zDcj9JONDwuptw+/lCaLcCbneoiKJ0WEg7vsNYsEWWAL8TxaGv+i6KGn/LEZf/mqfzMfvX8iMIsdrAq1DjIdvT6acNTBktYyJt6XAti6ooTa4K8B5PzwavDCbI7t4q7e4B4OB/X1LA5dA8QWJlMDBqTvQoxo15eGTMBQ3v2ZJSQGDz8KjAZQjzX97nt9YhBO7/GVFo7LYjm9uIf85ST7JMHvHsPoBnzn/9itxYKSFZHRH8zApOQmgby3TLHmhRJqYlx3Bj3qKb/M2PSKm27Rs9g4ShRrVIIf8XDW6EuNLW0BVU0QVjKrO6CSsIKQQYsGg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17454e28-4e81-49e5-26ba-08de7df41bdf
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 15:54:12.8458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gIiVfYAER15iA1df2Jc6lRFySHred8UfgzDb4pmluhjIDHYQhedPG2j58WSPiBfOZPNoLagaQ8BYUZq1/2zDu6SjD2veKF7UDGt7Ox5J6eY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603090143
X-Authority-Analysis: v=2.4 cv=MuBfKmae c=1 sm=1 tr=0 ts=69aeed2d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8
 a=ZWTDRVq3nMvfi437NgQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 4An7NmaXybZNBaxG1MitgY7_vH6KvOuK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE0MyBTYWx0ZWRfX+M5Ib0oPbuAL
 P1f9H7WES++QJRzxsLUO94AfH+LKqeSFlkNT9x+YlXWjqIil0KUk226UQ7ul4ts8y7M8TMpbGwL
 mwkfrawIJG2u+UfX1wSwjOytQ+b49r6GPvVuDmzhzlGOL1+FdfWKCuMBOoJN2LZbIdla8tEyb5f
 gDDdtbokS3Dz2xywpQ7LCzOOx+fW1qeiRol7dNrNu+yUoEB4IWK/O4vnk3IoPS/6YcTUwHAulPK
 8FRtAzmD8BKNAJmIuCwXbKZvT/wqm/jAO0dfnXmQgEeOjumsNgOKehs+JQJd0PtGgH7gEVxAZIs
 ZkKCx5/lntMJcv9xneoCncrsWDY7kQsxtwmnyz6Kc4yM6rrt8JjivDrqmWrIkEmJ+uKpdfurDl5
 vXhxkSiNnJ1K0QvWbdBqx/MhXJhejRmWjSINk+DWunWJVV5U9wu1FuUhFYkJ+T3n8Ef7LIHBQLD
 sO9ips6MUOAKhUBSTkg==
X-Proofpoint-GUID: 4An7NmaXybZNBaxG1MitgY7_vH6KvOuK
X-Rspamd-Queue-Id: 61B1D180006
X-Stat-Signature: er6i89a1ejizpgfqipj3jiepm6iyydxz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773071669-517965
X-HE-Meta: U2FsdGVkX18Aw6+gevRQ8myMDi0MXjbNTINlXEQK3b56wkyiKiWeILKLbfNO7cx8ktnDf4EDvmoLOiTEPJmWYPzzLcR+aTrxCwMUN5g2cQlF2hyugbm4h27OhSyTXUadkJQscjgHXp8oaKEuh2pR2qrestUhE/qn2linmKCfxcbKgr26gO+CgAq34rMBCy9EYmEH1o3Loox+YLRYDU/uzPtj1pguWeUx2AmR1hdhGHC4UiWGn0oDSuCvOusmHpFsIoxI+m8yHXwpji4hRls2JygBQbEcQ0l2JBN1a2tNopL/BTmmKINb+l2apAoWSB/z1RMRV34kChOZLsJYm4do/XpBJ31vB/ZoLve4XP8h+1tzNVPQsxsRVA2oRyd+45yb4+hjawgKftaMIJYOoOOgcxTwTYtH6OoIrDKYGMu0aKJRAUDeWr32RPb3tBexAeiNMZlyOUVSRNMMjZi3QTzPla39C1i2iX+NRb9Wy3f0CO8sXziotJ3A61NjQrZqY+mhZs3mBLpmViEKMichdD8GQubCoy7jfshWgIK9ESQ/L7ee9jkHqnl2fa9+eLApuQNVgDO20ymKN6nlk10eFy8xU0D781j8wCLvclANELfEWtYWqbt4SqyjT3AAdmrvqXDl/pyS8TZZkFtY9whg0ELRVS1CEnBEoAFLhaejkqW1cyMw8/BzcfU39c/6H5l+U/ifxTHDwaHiZH2K4BhIT71C+3LsB4qJxqZybKil2pK/KowOWjqkUm4g0vFtJt8K0/4F0/Di4ntc78moWXHlo7KsWcYMjXPD1QbuvyfIvmZIvodZaIazCpYR9/TgyCZCOnYLZNqH+vkyZtVe5g2++l7EwX15PhtevU0GHDQ2DsStl02wnRmVzg5+K0kH0JCXX8U5f2w8f7WgNNGCKZFPLW2w+iRtToARuXZSzVOkdQyJlXgAabSp7QhvSsjdVKjnu1kEKMn5TsipMzPvb0Rb0PV
 iXQWAGEH
 OSwRX4HqWmORjQYtMt4Qcb3ZcRjK6H0hpCxCWsUtnQ+wDAUG8qoaLgaS6IFeMwS+ILdRkNMpFTIxOPAoMPakeGPPBgLiCFyAXUoE9681TN7FjEK1lsf8z3RqfnkwOkuthqDkDHzhfw4zYKFFrh96LmX3g5us8pN36Y/u8Cj/VtHhJcOxnxQKNfJRC4kwOWncNyf4Yn1tiQcK35Qu/5Bl6VaccAVtwCDB3PbeBO9wi9hbZ2DV5Q5OXsfHob0xLJsUPvJWOYN1NosAExIPuJG6CYxo3pIByAjqW61nyaoF5xMebwT4VBirE06nNDQobf/WW4p/bNzxhiWo156vt/LW6/VuvUFpFuODIp/rbH8GWdkpbetZ4tm1LGzQWzqx80G9JfiHwAnyM12cu0xN6oJIjXy/WIWjhv1hd4A0aWEm1CeLo5i5aI1/gRFVpcpz4KOwizDIfr/csGGUtBmxOejT/qBhxqazV2cvCfCP6fCJiflJpFk2haLRQdcOAYzqlvzXNDJ6UYbWmpRtUvp3E3ILlny5Vpse6hSxIR099JkkXiCuZIHdwZEXLDIstkPoykfMzx9LgT0h3g9XttqY5TYr/MzIiKG6En2VQS+OIBklcsw7VFnRSQaozDUGo764j+0PkzkwhSvKYEt3o1l9mb0/1pST4dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/9/26 7:28 AM, Lorenzo Stoakes (Oracle) wrote:
> -cc old mail (this is going to take some time to propagate I realise :P)
>
> On Fri, Mar 06, 2026 at 12:45:50PM -0800, Anthony Yznaga wrote:
>> Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
>> to the check in mlock_fixup(). However, they will be locked indirectly
>> if they are created after mlockall(MCL_FUTURE).
> You need to add more details here.
>
> For e.g.: 'in apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set,
> the current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
> applied to it. Therefore, in __mmap_complete(), extend the test for VM_SPECIAL
> to include a test for VM_DROPPABLE'.
>
> Do you have a test that can check for this? It'd be good to have a regression
> test to assert that it now behaves correctly.
>
> You could extend either tools/testing/selftests/mm/mlock2-tests.c or
> droppable.c?
>
> It's worth mentioning that mlockall(MCL_ONFAULT) is handled too, as
> VM_LOCKONFAULT is always set with VM_LOCKED (the only difference being that,
> when trying to fault in memory for VM_LOCKED ranges, gup exits early in
> populate_vma_page_range() which has an explicit test for VM_LOCKONFAULT) , and
> apply_mlockall_flags() will invoke mlock_fixup() which already has the
> VM_DROPPABLE check.

I'll add a more detail commit message, and look at adding a test.


>
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Do we want to cc: stable here?

I don't think so? It seems unlikely to be hit in practice, but I 
couldn't say for sure.

Anthony

>
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>> ---
>>   include/linux/mm.h | 3 +++
>>   mm/mlock.c         | 4 ++--
>>   mm/vma.c           | 2 +-
>>   3 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 5be3d8a8f806..bb830574d112 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -574,6 +574,9 @@ enum {
>>   /* This mask represents all the VMA flag bits used by mlock */
>>   #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>>
>> +/* This mask prevents VMAs from being mlock'd */
>> +#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
>> +
> It'd be preferable to not use the legacy VMA flags implementation, but if we're
> backporting I guess... However there's only one place you need to update, the
> other already manually checks droppable, and it'd make my life easier for the
> VMA flags conversions to not define a flag like this also :)
>
>>   /* These flags can be updated atomically via VMA/mmap read lock. */
>>   #define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
>>
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index 2f699c3497a5..fd35c1e88c4c 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -472,9 +472,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>>   	int ret = 0;
>>   	vm_flags_t oldflags = vma->vm_flags;
>>
>> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>> +	if (newflags == oldflags || (oldflags & VM_NO_MLOCK_MASK) ||
>>   	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
>> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
>> +	    vma_is_dax(vma) || vma_is_secretmem(vma))
> This obviously wouldn't be necessary without adding a new VM_xxx...
>
>>   		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>>   		goto out;
>>
>> diff --git a/mm/vma.c b/mm/vma.c
>> index be64f781a3aa..1334622e4a03 100644
>> --- a/mm/vma.c
>> +++ b/mm/vma.c
>> @@ -2589,7 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>>
>>   	vm_stat_account(mm, vma->vm_flags, map->pglen);
>>   	if (vm_flags & VM_LOCKED) {
>> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
>> +		if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
> For backport maybe just put an additional vm_flags & VM_DROPPABLE here?
>
>>   					is_vm_hugetlb_page(vma) ||
>>   					vma == get_gate_vma(mm))
>>   			vm_flags_clear(vma, VM_LOCKED_MASK);
>> --
>> 2.47.3
>>
> Though I saw David suggested something different so that also addresses my review here :)
>
> Cheers, Lorenzo

