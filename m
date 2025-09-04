Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C80CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 19:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DC78E000A; Thu,  4 Sep 2025 15:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E168E0003; Thu,  4 Sep 2025 15:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF6D8E000A; Thu,  4 Sep 2025 15:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29DFC8E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:12:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E71DD1DDF1A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:12:03 +0000 (UTC)
X-FDA: 83852512926.28.94DD3F9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77497160004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:12:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VzA0JUTv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jLzhWWVM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757013120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEmfmtMZBgYHQzNiQrd4PA0dm0L4wwUbfGDDGG5t8bA=;
	b=xs9sBwK3pWqXkuytvdwsT3Wbjdbf+hdPDyDo+YQ7yyHIWmcL6N3M1HLum/xG/WLP3w/G7k
	ZGWngQ2bCL6hrLPxigKROnGSbTI4Sb3WkCwa/TlEIxV9GLjqTowJ9dxmI4jCdBsvXIUiFR
	azC55yYMsGPCwlnjYYr+thUY1eCVLGA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VzA0JUTv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jLzhWWVM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757013120; a=rsa-sha256;
	cv=pass;
	b=pxDROjFYzLG0zwBihI/k69+v7dal3sJqHab/nW3Egh9No9UhTVPiUjCwF66PUxGlAXpSYy
	uw5tyx9OLVNSLd3yP+x3IAU65JyMCDk1PX8in4EXh4qnLEt02frxE5PkyTfdyP4hBlHEE+
	uALiSAKXXjxzIYYEUz/QTZh8xwwW+/4=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584J4evB031855;
	Thu, 4 Sep 2025 19:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JEmfmtMZBgYHQzNiQrd4PA0dm0L4wwUbfGDDGG5t8bA=; b=
	VzA0JUTv/tmDyejbAqzQOcFEp6t3vyV5x120U1heSmpEK6JLe3R0sTRO6mnEyQEm
	RhsprZvegXpaW+wk6mRlaGgqspC/V2am9tsgmC1zdWah6diEGnMqG7uuzuayrU9c
	G0p6MMDQcLfXQsNki+M7W30yajgFBnXseUOGYyzyr2qFWiYBmnDA89t07HdQOPMt
	uB9DSSAQcOLSTgiQs3fWSPZd4F5mZI8++rKmqTi0nfTsLgtr5cIRHgQpVLSuq5Qa
	UvGqg5alwIAocqcfPkxKoBP12ydsqDUMw1oEwycUU0d3JRTv47ghc6R7ZgigaV9/
	TgUj7KB/a0F7G8dGDu+Tmg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ygkvg0j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 19:11:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584HdRas040710;
	Thu, 4 Sep 2025 19:11:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbntqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 19:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/xgkHCfoHMoSPOfnxT7l85jWac+HNI42tb6WQKyETSvyrTHHSVFG+CDHh0Qrxkf8dU5WqP/gb4p7hhATdRoKw9V3S9lOw8iWvYfhsdzqpEhkIjlsP+eafwFJW2r+IZHuwtQZQaHEgiLu+a++ddPjlNbkntbyMQEN6+8Ds/RmZhXQ7HYBSrmu0e6F0Qx/8Hb15XxSLUqMHwYKanj/Dr2D7HjcTfmOTpZG2lWz1521lPesYsTSEriSI6c5itLeN4kqIF/QGpkvip4sn2RHvnsuslX/xD07iUHERfzIPnAjRijkDO8iqYxfE5dKOIHnStZVJLo3O3blEg3SVYVwt52aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEmfmtMZBgYHQzNiQrd4PA0dm0L4wwUbfGDDGG5t8bA=;
 b=sFIFdSz30aILQYagbSYWU79XfEPI8TYkjsrUpAIH+sbNJ2ULQ9WsjrXclIiJl3gaxGcLFydZdgLZHgFjDUb/QgN7CbLIWeHIQAhwcE4WIKS3RKnsV6Yw7GzCwvzYphQFz0Yt2Gz3PQjsVbE7/VYbFjM5F7/oAJdErH1T7FLmN6W85jyYFuYBWuHuWCiXCnSzReE/Me+B3ZTPkV0Psxftzj90Ck1fC5ldbblhRpoCYzFM922UuaG4sFAq4Op/YYy8fnjho5hNJOIQVrxJ1ms8guiWcDpB0rZS4kc3nBxHX/dtTgYSg9+amiJsCgqMlymHKF9rsefejb53e8WubU7Wbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEmfmtMZBgYHQzNiQrd4PA0dm0L4wwUbfGDDGG5t8bA=;
 b=jLzhWWVMNkf0QV26+JHHs/0+BSSKmYS+tk5wyo1mBabk7nmMwyJVD99IwyiGUomH/4b2oKPlQl+s4JHbgg8j/K8qHLOxa0z7MLKw6iNZPw9IiRlMlM0+K60IyHkAUfU+iQ+VXMItMJjN+Ejh4YloA6PtY1WwSaaGsq9LwUu3RjU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6369.namprd10.prod.outlook.com (2603:10b6:303:1ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 19:11:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 19:11:50 +0000
Date: Thu, 4 Sep 2025 15:11:46 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kalesh Singh <kaleshsingh@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        akpm@linux-foundation.org, minchan@kernel.org, kernel-team@android.com,
        android-mm@google.com, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <e3lsreaj3gpqgt6l32edvyjbiscekyezhosaew3lgu4xvbwmsv@2bfpvwtl4bpe>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, minchan@kernel.org, 
	kernel-team@android.com, android-mm@google.com, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
 <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
 <84aad392-3bff-4f98-b612-5e9a046edb36@redhat.com>
 <CAC_TJvc=5=iS8gCumJWqH5eF4XufFSogqtWHJmiH5WBN1A6gng@mail.gmail.com>
 <4chxl7uxr4exy2z2dcshxla3c5nzzo2tbnelsbbky7pdzrih6a@hzfnpbenfmub>
 <8e1881b8-3867-4cea-b03e-50c05ed8148d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8e1881b8-3867-4cea-b03e-50c05ed8148d@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQZPR01CA0069.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: b223bc0b-c36d-45b2-d70a-08ddebe6e6a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S21rWTdKenYxYk1vaHZld05hQkUxbVMzNnlKMkVsUlhyTDkwYktMdFR1aC9X?=
 =?utf-8?B?VWpoM2dSeUxCdzNEWGhmenQrUVlTSlhsZURkNDRxMnlNcW83SmtZdE4zV2hh?=
 =?utf-8?B?My96TVlnY3NPMElmR2hJYXFSbmRLVmVvSDVIMXY1WmV6dmN3NEcxb1ZqRGJ6?=
 =?utf-8?B?RmRvSUJ4R3ZjaXVBMWprVzd5eTBXbkhTdmVqdWErUng5Yzd4MjE1SE9SUkV3?=
 =?utf-8?B?UTgzQ3pIVFRqMFJJVFJid01KSWkzM2IxYTBOWndKN1J1eXZDM3Brd2czM0dK?=
 =?utf-8?B?NDBPQmxJdGhFOTNBNDVRK1JWR2FhYzJoNjVVR0k2cWVEc056TlZnSkM0OEcy?=
 =?utf-8?B?ejRwb3ZZQ3JLOXdEa0ZHejhIdi9nejFLUXNEclZkTTEwRGlmbWFZQ0dmTXdz?=
 =?utf-8?B?QjltN3JjWGltSG1GeTZJdXc1WHlhMW4vL0tvaER0Z0xBcFBCenQ0U2NWSmJR?=
 =?utf-8?B?UCt3aTVCV0g0MG5Ycis0TzkzKy9ZN1dvL3JqZUYxR0NndEZzR2hRcUhRRXR4?=
 =?utf-8?B?cE1ya1Zwem84emRmc21SODJSR05HTStXQ3Z2MXRUYzMrck5YL0pQS1BIdU14?=
 =?utf-8?B?aEFXVGhsMllCeHFZR29pWE5NeWM0YXdUeEhMd2Y0SVpySzZ6alVtV3NQOVRi?=
 =?utf-8?B?QnZWaHNhMnZJOTdpWWJ2REdLWU9DbjFCdy94djRmMGlmcXNCSUJEQlI0K0Ju?=
 =?utf-8?B?VHV5QWZ0Z2M5SnRXeFltM25TTDNlNnNmaDBBMjdDVE80VlQrZ1gxcGYvbCtj?=
 =?utf-8?B?TWR0WkJCamU5RXZ4cGpMWXhaVWhCenRIMlJuRmxyYmNFRmw1elNWZ2s3dnlM?=
 =?utf-8?B?L0k0SVYwMDN3UzBsQzBlWGFybnhUaGhRUzJmWk8xSGNSR2R3REhvTXNGMnY5?=
 =?utf-8?B?N1ZxbU12eXZaNUJ1d0ZTT1h1U0JqSFJRQU1nT1FSUEpiU242SHllZmFSaVFJ?=
 =?utf-8?B?WndZQjFuTjh0eGordmdwTGVlQUVOaHJadlJ2RENRQ1ZzejNIbzFCd3NXQVFH?=
 =?utf-8?B?WjNjeTRLWkR4YThqbGhld1hLOWgwb1JWMkJNcUVHYVJUdDI2K0V0dU5vU20v?=
 =?utf-8?B?QkhyS1J3aGlKalhOQUN0SDNMdFMwTWNMMTFON3k3dzg1RU9KR3hIcUZVVEJo?=
 =?utf-8?B?ZFpVeUxFeEZhd0ZhTS9XV3l4MkMzNThab3E2cnlobUNxTHRpUTZmR3VUWmpr?=
 =?utf-8?B?cUVJL1RsbHJ5L2hIdmZxenRZcGw1cEpXUVFPM0Fxek01blZyV01WWnhoNXZp?=
 =?utf-8?B?My9Wd1lvaWdFTFJ2U1RYR09JOVRlYWhsZGpsUTI0aU9LRXE0ZWoxK2lwNE5x?=
 =?utf-8?B?QnlXaDRZRzJ1WHRvL2hReWh0eTJaRjZlMEtiNU81bC9ndVphVTlNaEc4WHdX?=
 =?utf-8?B?ekI2djNBUkdmTmxFa0xYRXY2bHd1MVJqN1JSdjhTNlFCd2ROVnZBQm80WUQ2?=
 =?utf-8?B?MmNOd0tKUGVUcEFneTJKWG1jREFYVlJOY2RvcG1LRUZrZ2lyME4wajVDQUVp?=
 =?utf-8?B?eGJDQTVPMnk3UmhYbEpLbjhKU3BLZ2xxbVc4b0s0OVdmaDk2ZlJZWWQ2dy9j?=
 =?utf-8?B?SmE4cXR5VHpxRlBpdlhoVnhqME5PWHJQRjlweW5MOS9sbHFuRFNqNlZEd1Ra?=
 =?utf-8?B?RWtWYkdPeTBjK3I1NkdKeGM3Umc5bElMWTZkVGE1WDRXc1B5UXl1SjBuQjNy?=
 =?utf-8?B?YnV5dkF0RnlLT05xYlV4Q0hhM0E4OCt4eDdsR2grbHI0cFZxZTNmMDhuMWdt?=
 =?utf-8?B?cGNaNkgwYWdLNFlUU2VJWjVUS1cvZEppVUpsR05Jdk1uNkRRUklLNU1xc1Rv?=
 =?utf-8?B?bTJYTHFjZlVxNk1MbUV5ZnVmQTBpTjQyUWF6ajFnRXRabHRCN0h5SmtTTXRz?=
 =?utf-8?B?dGFFa3NkUVFiNlNTUGFraEFWdFpMQ1h2TmpMSVRCYStJbDlJUGVPK25Vb0Ja?=
 =?utf-8?Q?ET7fYCj1z7k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVhLcnVPdER0MnVMT1JYdElDMzkwTjVYS1BDWW45SzZrZHBpcmtXYzFTL3Fr?=
 =?utf-8?B?aDVDR3hwbTJFZnNJMXVRcE9VRCtTdkR1MVdQK2NnTTZpL1VJUldyeTlES2xQ?=
 =?utf-8?B?enpQR0dZZ21OMTl6NE9SbndzQkQvR0xFdVFRWm1rdUdpTWZuZ3Y1WEVHS1Jt?=
 =?utf-8?B?SDdqdm1hSEdMQTlCNGZ4aXh2OVJRVXJ0WXc2VmNOeDVMaUJab2UzODRYN0x6?=
 =?utf-8?B?ZTBWSEwzV1lQWWpiZDRrS1FHcWZzWTkrcmIxNVpjOGhtWHErSjRnZUx6UUFK?=
 =?utf-8?B?dHJmWmx4bysyWDVweHBNVVhHSXM1VlpWNG8wNFd6VTRQcmJMOHY5Y1l6d3Uv?=
 =?utf-8?B?L09BZzlJMFJuSE5MZm9majhMYXFQbEFWNjJYNEcwMnUwVzcyeHFTMWdmb3ZU?=
 =?utf-8?B?Wk93YlYzaytBRXdhUVdrVjBoMk04MTl2T0dQekdmV2dzcHhkUjQvVDRhLyto?=
 =?utf-8?B?TkFZdHJOSzk3blIraUdkVDVkV2lPZE5zNnYrcGUvVnNkeGxtRWN2TmdDaXJT?=
 =?utf-8?B?bTF2S0dDWTBHdFIwdXRQTTlHQjUzb0praFBBYU5WNXNsbndmMlBac0JmR3BP?=
 =?utf-8?B?aW83aW5BcVZxR29kK0hHN0lJTWhVYUluTWRzZVBFWC9RN1Y0UG00QTNXVHVW?=
 =?utf-8?B?V3AzdjB5YzJ3UzVacEc1YUN4RjFJWU5oU1lkTndRVjNlamhhS2tjbDhZWG1x?=
 =?utf-8?B?cHRxK3ZSL2pkb3NMMDRiVVIxVHdadEhqcXVKMjRkL2c1SXVHbXRncDI2WE9s?=
 =?utf-8?B?MnU1dk1qbTZBNFlaaXdScG1PVXNHMWNPZ3p0d1JFTExlY1diYjZGQUxvWHV5?=
 =?utf-8?B?c3VpeDAzSFI4cTRGaHdzREM0VEIrYU4rNlJseHBTTWpjcGtSR2xaZEtISzdt?=
 =?utf-8?B?clhQOFhJYVlaaytaRzdWTGw3ZFhXM2drUHdkbHhEQUlhLzlzS0ZsVjVrdDJC?=
 =?utf-8?B?WFdma01CM0ZCZEs1K1ZFV1V4NEdMUEtqWnVmZjV1MGhsMHQyM003dkVjV0lh?=
 =?utf-8?B?eEdWOTFlbmkzZTE5cGhKT2ZsSnpwMng1azkwREt5Ri81Q2hTOGtmSHluci9H?=
 =?utf-8?B?YXpwZDV0bDRoVzBQRlU1WG1RY1pYVGRMdmpQN1dxSUM5UFVNSUZEY0c4YUhW?=
 =?utf-8?B?Z3g2R3hXeEdNVzM0VjV3TGxpWmpaTm9haWhHeVdRNHYrVDNsL09SdER1V3or?=
 =?utf-8?B?UlZwalBkcXdDeXlYSUpyQVYrMnQ5OWk1aStyU05xdlVOOGNRY1F0WE9OOXRS?=
 =?utf-8?B?RWxRYjJpYkpnWnFKc0w3U1Yva2M3aCtOdWpKb1gvSE12MzhBSE9sZWZlODJv?=
 =?utf-8?B?QW9ySmJzRlQvaVQvZEZiYWluL2x1c0gvbW5oaW5OWEMyYStvTkUxWnoxUEI3?=
 =?utf-8?B?K0t5dDBvdTF3YVp5dDV4N202OWNXY1ZEWjdEM2hpckhtQkExU2hOMVNWQWhp?=
 =?utf-8?B?allUeUh1a3IxTTBGUkxuOFN2MTJMbk1qSzRVK0pwbzdpTG9QNXNMb2JYVHBG?=
 =?utf-8?B?eDlpUmRwMGlIa3dVMHM1YzdCaGtoQkFVZFdVY2xmM0h6T0k3QisySTBueEth?=
 =?utf-8?B?UFZSVzNtRElwRWdCUEdUVzdqbVRMZ0Z5aTVEaWFMVDVLVkZ1NklSQjhOOFBk?=
 =?utf-8?B?aWE3RW9TeFhBMzhaTVpsbDRESG9vWjFkdTEySEFYL3RKZGt5UGExMWtmVFN6?=
 =?utf-8?B?RlR6WHhycXU3T0E0MDJkQ3Bxai9hTW5qQk9rZ1RWWTg5U0haQTR3T3pzcmF6?=
 =?utf-8?B?cm5JTXUxbFBtMDJ3OEJaak5oN2ZaYVBvRUdaODJ3YmtpMmxiaDhsY0xucmVS?=
 =?utf-8?B?QXc2UkxrYVFMMWdKMEZkcnE3RVFXeE9PSVpqdUJSS0hCVVdHNlF1b25pUGFZ?=
 =?utf-8?B?WWFiejFGSXNveS9QUFoyam93RFZUNnY3Rmc3YVZkZUdZWXFKVDF2ZFpwZ05w?=
 =?utf-8?B?cDAxcGIxaURKRmFzV0lrUHdSdktBaVdpUndqKzRSM3c3WTJuOTNlemVuMW0x?=
 =?utf-8?B?V1g5TDd2d0VDb1BlWjIvN3FmQjVRaWxVTldsdGhBQUp6SXJ0cWdlSkhBdSts?=
 =?utf-8?B?MlFPdW9pTzQybHdEU2M2RnJDaVoydkhOS20xYm4rcUtPZFJtbTNpU0orYUdp?=
 =?utf-8?Q?rrgO366U/H9L6O8YuQVobhb7T?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iYgU3ZsmWunR9d9vnTskba8EauNNTdSNET4hi4egS4m/Vg8P4HeYTGLVRfazQwXyPmFOkhmPGvoKVpbEAn37iIj5jmj2Uyqz/a7tPDqwPh8A4A8CZnrbWL6JvsUf1EsC8YXkUH1GHFZRUuH53wlEmw7+qDxcjiVbDJKIgNQehOmOS+R1d4c1bbx0T6n3BlcTDmh+DhrqCg9FLLF/YwlOJbFmwadHQlPVOg1ctrh/W4ZJUQ0ojJoE2/RoGFQ9xrhEd0IRcYEjuQ6pCgWP7RFed/7/faCvpjlfT0+IIxGLBGK1XCN/ILFGa2jJTS9kZ5wX3g6tfk7NPAnGXJ6/o39QBLDvR15NOQ2tsjz5ngSpnhwPMpOMzqqH9aYxVNbZxzKQ5sYLEPomoAqeZ6FTqgtgA1KWS1IY2qH9zVGwlmCGiueF9QhMUy7jQyMYL30XkXToLXNlMuqw7DDtdEcu33Po5Ju4jLi6htYF9ly/kbz+t2JFgAN07CuBHX9Ugnuev5PN1U5rCO94yvg6bkyfTiLgNZC2+7E1rRvsCZT44LxWYeMmV2X4ayoMY8p4bvBVT/2Vo8bHChoali0LJ/wgxqps8Xd2E3Gr9BK1WdspheiC39g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b223bc0b-c36d-45b2-d70a-08ddebe6e6a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 19:11:50.2507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQnSHXnqGVYKs+RBsUHX8K9jP/Ww4kTswomIL/YHcRX2MXnlbpRnX8zu54DiiRSY3T4oWdmPjuzH7hAnrpLVjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040189
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE4OCBTYWx0ZWRfX/WSt2/ixmEGi
 wR6Bw8PWxi47fApZ5pKAA55Gg4mfDhxEQ6gC1uCNfDSjcn3eWt5+++WSXOhuG8Iz62DwL3a4u7T
 AINhztJyUy11ekrVKYULCAUlZrbGKbwd+VhRrsznmP7hdHHAo3oT3cuN+8M2NUWEzRaMDFz2bXw
 Rskg/ASSjzD1b2q/WBGjD1OrL/iakdefbCepxXhcfhYkzSW4UTri8P7lhZ/bSVnrbhShx81PlXG
 jJns5q3YdAs/w5W/huG6L9wC8eLHVknutxZBoU8cJueMbqd1OHeN80GrfNYpdKu+BmHWIOfWzLZ
 PQXn6+n6nc2AtZVWQWI5mAMjCozP6vNNagBrofgwpzm9dPDsGn0GZPr1uE66U6A5i7odDlXxkOI
 HY+TJ3/r
X-Authority-Analysis: v=2.4 cv=L6sdQ/T8 c=1 sm=1 tr=0 ts=68b9e47b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8
 a=jMfA0WQcgnyDwYLyNj8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: LqsH1lh4KAEI1qtmPI9OuynI5lxBo36z
X-Proofpoint-ORIG-GUID: LqsH1lh4KAEI1qtmPI9OuynI5lxBo36z
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77497160004
X-Stat-Signature: 3azuzto5f6gpzwt6fm7f5thr1j5j51di
X-Rspam-User: 
X-HE-Tag: 1757013120-736348
X-HE-Meta: U2FsdGVkX1+sfkWoQuvSnRjNLPMRpo4I7BBY1HFG2gu1Nad+CB8S3R2yCavVBcPXq3ibwFXbfqQIq9lL/aj1VBl0/dVMD5Hw19o6R0j/QWbEtrMo5W4Zaz6E2LwrrILKmrydCwbF3KgfzIKfw+Kk+XblBdjUBHpJPXiE2Ah5x3Gniks6EgxMPJguV5TM3ofrnxZ9qi1+1QXBDAickC/3xkDf+u8NqhGKvYl01zwsLZB1ZhcGnkXng1aNZvWNGlgAkAOJ4/1o+hyNb1crZ10pvPxQQCSLjbStvVwZNbWGa2+RDy5GGyXhYxetWksEUgA/kuy8+SgWYDWdw+SYsokyEqJxjv/IpLBERws4Cy4Ctyih+cOuNqMSIetjWSB/qKGUww/A0U6ybVHaKVZkR/nOgosc34IynCOJ8oxChjl1UYlRjzSEmBC425wUni51Szq6zmovx4TI8nE9b9NragtANGNywzggAzcwt0cGWjUWdAMsBb92lAzWptuyOJMsqCI3GWte/Sfe3oAeX92W/ew5oIr1nHl0jUz8yzk7uEwsmDAAAILBvVmRulkxbNIs6Qlb1+6PfdwCw02Fy5/TBXWxYMPc/xnbVaE8sL/BRJB2e89eAFk3btJPlPOaC+1K31EgH/JmZYCdTgiGntTB2bToKOM30/FqDgexO1vtI0bC8iBM4LvOuH/di4KAmEc5ATPijYIZrw3EKRAyvCYq7W40iFduX0eQ2fV2hvc+JmaTrrAPfjghf48iGF4w+ttR8ocNuUcWLPQ6Bqcq7Pk8Ktuy7bnAy0gNEPUjKHagJZJdjpTcsos/uGW/rZGlrQSm8CFOO7EwJYg4SztqfQr3u/RInv/99vNXZWxMRX7vnkl8m5dV7x5kc7yZ3LbEXeSdtWCc9noFNPuGxqUu1tuQCm5ivSNBShVkoHh7hX3YJ817C/WgF3AeA1PjqauheIifc5FkmlUEhLWwR4hvAb6MyQe
 7O/6C+5I
 YTvybwUfEaySU2boe+Pg20y0EZ592Vy81LCpy34QluFwoSBr00U0sOECSeIrd878JqRCOotJq1UuMRbDfW6wFEzrMrHB3obeXKlA+LKSs3zJdam68WgZxP6fLF9zaAaZtdtFH0EjfNumaTqyIcNwn+A1CYOYWO2faxFQEhlNV4q/6jwmrVJkqNwlFmO3rG/ESn8wQld53SFHix5WLB3RIoi6g3X8vqIQJH7UtP2HhZRDw9DthxGHXn1nhH0wlzC/kVpat2wbGlEymnjGlQ0seP2yGvVqXhuQeUa5wayL2jHeiblAn2s84L5Am9GhOb8JqJFcA0PiD9Ts4TQ+pd0A4QEbB8fbs4+V/I0/5741fABMN0CpS5Fnx2MX4QW3zmPeRznO3Cs65qZRvfPQ/ZaO663uupJn3tkZoLOkhN+ZIC3og0AcwMVLW64mInyxv9X56gNiRoAFk85GhVwKg/JrxR06Mqq3TqnzswRWijOdLLdE57+33GpCo3HjpVaT+YFHTonTHFlsoHPFNzWu1ZPq5zHK1mmFkyYIkRMMpPaqx8/63mvVyMg43K1KQ2ZSZ0wGLWfFEujg5q8bvYXmFFq5wfNu5sND7DKNgyDtym1SC8Uis2X00+x+FtkX1yVMl8Y+qEddQNFunxPwmRXyYKLPBjpdnPNkor31I5I31uO9dbfYlbMI395uJo+8z/lz1LcsqIh0n3ACAIuFYMbtt/XArwCuWXyDdj0krlkJm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250904 15:02]:
> On 04.09.25 20:49, Liam R. Howlett wrote:
> > * Kalesh Singh <kaleshsingh@google.com> [250904 13:51]:
> > > On Thu, Sep 4, 2025 at 10:42=E2=80=AFAM David Hildenbrand <david@redh=
at.com> wrote:
> > > >=20
> > > > On 04.09.25 19:33, Lorenzo Stoakes wrote:
> > > > > On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
> > > > > > > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > > > > > > index e618a706aff5..793fad58302c 100644
> > > > > > > > --- a/mm/mremap.c
> > > > > > > > +++ b/mm/mremap.c
> > > > > > > > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(st=
ruct vma_remap_struct *vrm)
> > > > > > > >      * We'd prefer to avoid failure later on in do_munmap:
> > > > > > > >      * which may split one vma into three before unmapping.
> > > > > > > >      */
> > > > > > > > -  if (current->mm->map_count >=3D sysctl_max_map_count - 3=
)
> > > > > > > > +  if (exceeds_max_map_count(current->mm, 4))
> > > > > > > >             return -ENOMEM;
> > > > > > >=20
> > > > > > > In my version this would be:
> > > > > > >=20
> > > > > > >      if (map_count_capacity(current->mm) < 4)
> > > > > > >              return -ENOMEM;
> > > > > > >=20
> > > > > >=20
> > > > > > Someone could write map_count_capacity(current->mm) <=3D 4 and =
reintroduce
> > > > > > what this is trying to solve.  And with the way it is written i=
n this
> > > > > > patch, someone could pass in the wrong number.
> > > > >=20
> > > > > Right, but I think 'capacity' is pretty clear here, if the caller=
 does something
> > > > > silly then that's on them...
> > > > >=20
> > > > > >=20
> > > > > > I'm not sure this is worth doing.  There are places we allow th=
e count
> > > > > > to go higher.
> > > > >=20
> > > > > ...But yeah, it's kinda borderline as to how useful this is.
> > > > >=20
> > > > > I _do_ however like the 'put map count in one place statically' r=
ather than
> > > > > having a global, so a minimal version of this could be to just ha=
ve a helper
> > > > > function that gets the sysctl_max_map_count, e.g.:
> > > > >=20
> > > > > if (current->mm->mmap_count >=3D max_map_count() - 3)
> > > >=20
> > > > I enjoy seeing sysctl_max_map_count hidden. But map_count_capacity(=
) is
> > > > even more readable, so I like it.
> > > >=20
> > > > I don't complete like the "capacity" term, but I cannot think of
> > > > something better right now. Maybe something around "free" or
> > > > "remaining", not sure.
> > > >=20
> > > > I also don't completely like "map_count" (I know, I know, we call i=
t
> > > > like that in structures), because it reminds me of the mapcount ...
> > > > talking somehow about "vmas" would be quite clear.
> > >=20
> > > Thanks David, my original implementation started with vma_limit() :).
> > > Maybe something like vma_count_remaining() ?
> >=20
> > Yes, reducing this confusion would very much be helpful.  In fact, if
> > you put it in its own function we could change the actual name with
> > lower impact.  map_count vs mapcount is annoying.
> >=20
> > vma_headroom() ?
> > additional_vma_space() ?
>=20
> VMA space might be interpreted as VA space.

Fair enough.

>=20
> I think basing it on "vma_count" would be good.
>=20
> vma_count_capacity()
>=20
> vma_count_headroom()
>=20
> vma_count_remaining()

headroom or remaining have my vote as the clearest.

>=20
> vma_count_avail()
>=20
> vma_count_left()
>=20

