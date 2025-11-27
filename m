Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EC4D10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CB96B002A; Thu, 27 Nov 2025 00:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64836B002B; Thu, 27 Nov 2025 00:30:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C056B002C; Thu, 27 Nov 2025 00:30:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C04106B002A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:30:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 746891A08D9
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:30:28 +0000 (UTC)
X-FDA: 84155261736.25.5F7D658
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED2DE180013
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:30:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kw576Z2h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=w24qCSwH;
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764221425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lN6uyMkcW/7ZpCFVTXT4frWaUm2thealz6oZQxxaka4=;
	b=1DVakQQB2a8JM2DVpPO53hoQMH0HV2AEMEWeGNnQazaLD69jCL2UlRBror28aZmxBek8XW
	iQbKyF41LJmQlqncG2IwRFjuO2kHNMd9xYJBIVDd6M/c5dkCJXdIe8yW+AVj0d/aEJzYL1
	XP2DaMHf/Hm/7LzYBaa4rjPcIUeiU68=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kw576Z2h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=w24qCSwH;
	spf=pass (imf16.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764221425; a=rsa-sha256;
	cv=pass;
	b=BD8u4yBfLN9gIoeavz2Uvjx0pUmuBDUxgcM+dLbUwhOsMPiQ0vFT3KnbgPS/d1MhY3P1nH
	t7K5+OSKHcoE7QYfV3syTvu6RiegrPAMjYK/+RpgIrBuhrIGkBwbap6GpWWU7nvMFU75d6
	vg+H6l5/J0G6HsIW1Xy+xs/r7uZafsk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR1O0Gb4041016;
	Thu, 27 Nov 2025 05:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lN6uyMkcW/7ZpCFVTXT4frWaUm2thealz6oZQxxaka4=; b=
	kw576Z2hOH4bYirQmcywr+Wmu66H2IImn53gXALx3ZQBccTzheMx0MhJPsq5JGNR
	dazU/Zn3vj3AWVoVb47VMR47T3UgSdLXq47fHSotZya38emM6abfSvcJ7rCmCfzd
	kG41H0lxDPpBBl20LQfPrYNq3/X2RVvt6Bow2Nzw4DNkfWE+6KYS/+jz8onep6qb
	ammuLoP6pugdYkaMU4BO6Huuyeos+UNt6ifU+wTsGLBtFNaSjFOM44U9cqLqsp/Q
	83wkU2N1aLAONUrnUgKijys1kXZEarD2bzZwdzhFP2Zh0hpm7Sg3Q+mG4GtGOV/P
	Q+jxiDn4HHKO9OCl6wKy1w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8d36rtu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 05:29:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AR4GHd0032077;
	Thu, 27 Nov 2025 05:29:49 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbvgd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 05:29:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MzvMy6LlVADYb/SDWKnhKqh273TtEwEZB3q3DyLSBKkHnCLKrcdExjJExd2inNfAiGxrc0LK5efzR0VPY7fIzMLjAum4w9bPpTu728TKB8kcs4i8pPho5lRolyGdERoWcvVBbYZZ/DJkm0mDQqx9efSFZTQXu8qW2xLNkie0gY/EQwjVxL8MRYjccy+MgMCDJNMXmOuKqzH7f1hYw2RxDTjHGKPwxRqupjalj1EzJvTTqECvy8YHzKGm4p/phRPCrDldkJ1FEtYkKJW09YpUjfTZu8r8Wx2K3+p0iGhZT+FyBNKyt0Mz6ZmpnFLhfw6cDpJZbfPCUYKOWFYmWVTTQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lN6uyMkcW/7ZpCFVTXT4frWaUm2thealz6oZQxxaka4=;
 b=keBlZ7/o+tD74gc4ETse6zoDYhOhH578bn2EjV9WCXzs+CL6f2VITsLrLre1MsT5sJo+ux4P0TIzqF61AqzlScRsbr1x8JnpqYVFPRBRzgXQnuffnR7TEAC1eGGAcg5EV+RlLr4OR+Fq5YzCJnXo/JHrhqhMOZ5Sy8c9BGMW9wpOEcshPboXnuEafA6cn2injOxw1ppDg8J2G72S3Bg1fUvEzDC50G8gKRjDM4J3gsXRHTnUog7k9j3yhCToQAelpPDcjNGSRJu6cfC62ndF4oyyib1cNrhON/qXX/VF4c7rAfq8VSQehvdEdiLm/JwPYuWegmQ9RVuNntuTILFMEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lN6uyMkcW/7ZpCFVTXT4frWaUm2thealz6oZQxxaka4=;
 b=w24qCSwHJUHmGCvZO1bMD+YCtPueH2bf2RpLx+28hgYM7C8deJ27isC3N312b7SdhQoTO/J+W1rGt6vDxjXKpJNBToBAZXGbAJS9GBnizMSF6pRTRi49IGuJ0yzUCERpuVSPMPYDlPslHSFi9TWq6OL+tXbDN3z85pW9HOudQg0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB4576.namprd10.prod.outlook.com (2603:10b6:a03:2ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Thu, 27 Nov
 2025 05:29:46 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 05:29:46 +0000
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-5-ankur.a.arora@oracle.com>
 <CAGudoHFgDEEBgQK5PrEUAJsb=iFpsT5OJ8+7W8PV0CGNePR4JQ@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v9 4/7] x86/mm: Simplify clear_page_*
In-reply-to: <CAGudoHFgDEEBgQK5PrEUAJsb=iFpsT5OJ8+7W8PV0CGNePR4JQ@mail.gmail.com>
Date: Wed, 26 Nov 2025 21:28:26 -0800
Message-ID: <87ikew6o3p.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:303:b6::16) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB4576:EE_
X-MS-Office365-Filtering-Correlation-Id: fad2c3c2-5123-4731-4da0-08de2d75fa28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eklCcmFNNUtGRE12Mk1GcDh6WXBkcmdFZWVwRnM0R01wcUpONUVaMXJpdVJl?=
 =?utf-8?B?QkpuUGthakJZbWY0aTdFKzQ4emNITkxaMTU4ZEJQdkR0SVFjUFJUQTBQbks1?=
 =?utf-8?B?V3RMNUV1VHpwNmxxMmM1TkhvcEpQVm9wUWt1Zzk5Qk9rcExqK3hhWU1oSU9O?=
 =?utf-8?B?cnpLb09kZ2lwMEh0bE14WXlNS29xVTJHOTBsUFY3OW9pUlN3ZTErT1lxT2FI?=
 =?utf-8?B?QlAxNWx6TDFDMnJWZzBNTUo0OGZqWnErWEI4VUhHekNwNzdEckR2V2tnZFhZ?=
 =?utf-8?B?Q0lNWWNKdlNEd0tZOVNKVkY5TkE3SWkyWUhuUEF0TlRIem5PSFh6SDFaNzNu?=
 =?utf-8?B?MmlWNDJNa09OeGNoR3lLL0VlTzZyTUtGMTlLRE04WmdPOW9MTXpMRXVTWDhl?=
 =?utf-8?B?cmtnMGE3ZTJ5L1plRVRBd1NJanpiU1lJdWFDWWhWMzJ2T0NMZzNPdFFkanpS?=
 =?utf-8?B?Q2t0cVl5N1lVekdLVUpLdGFzcjc3NXR2NXRMNENnM3hpSDZNVkxtL3oycXN2?=
 =?utf-8?B?ZmN1ZlptaU9Bd2VLOEV6S1p3cDVPN0lXcVUwcDNsTVk1QjNFRWpvaGRYd2lZ?=
 =?utf-8?B?T29KUjljZ0hPLzRCVGVpb09XUG1UenRiLzNqUzZ6Z2dtSUwrMWZoZ0srWlBT?=
 =?utf-8?B?dFVlN1F5UXlINVVNa21qZ1BhUFRXWUF1K0o3SUR4UzAvVlZQTHRpNEg1dFpJ?=
 =?utf-8?B?aHQzdWZRUzdhaWVHM1NzYlF1SHA0YklDUDVoRmFsMW9YK0cwV0NZUFVXb0RT?=
 =?utf-8?B?bXRPaCswa3c3Mmc0NnlGZzRvTTRYUEs5TFE5UWliSUk3bjRLT1ZHdkxaNnM4?=
 =?utf-8?B?R0x2Z25DZjQzM3RWRjE2Tjh6ekwyVi9jTEo5Tk1uSytqQWtsM01QeEtlVUNS?=
 =?utf-8?B?ZGJ5MFdWVGs2WTl5ckcxUVpmY0JJWE1Jalo3SVNObFFPNmFpb2ZWdS9JVitS?=
 =?utf-8?B?WnBrcGNTVFo2a25OUDJlY2hLVjJRUkJFU1d1b1ZJbFh5T0JxbkJTalBVbmZC?=
 =?utf-8?B?ZUpLTE1xNGJ0VDlMd0pLaThqc3ZLMUJjR01uVWtYMEZna1FTY3VXU055UUpv?=
 =?utf-8?B?RkZ5dWdLYzdsYjZBM0FSall2SVU5RmtzNjhtUmJsVGVHRERRdTY1NHdTM3po?=
 =?utf-8?B?RUNWVkxRNC93bFhyYTZ3ajlhbmRhL2NjSC9CS0lXbWloRVJDazdIQ0NMVlVG?=
 =?utf-8?B?d01lTGxjWStOVnl4WVdXZ0M0YXp6QVhMYW1TbEswRGQxQStPSlFqNjEyTW80?=
 =?utf-8?B?Sng5dDljZEdhWGJFQTV5OGpnbU16cWFtNmsxVkkzUko5Vyt0a01EUDgzWVNQ?=
 =?utf-8?B?enJkY3hTdlRlWGVWaVcxcmVIVmFCRjl0SHVLYWhqdkovVW5TMW5FN0VlVVhl?=
 =?utf-8?B?NGw3L01GUlVkWGJwM0pSNXdFY1lKclNLenZ2K0hXcWZ4d3FtNEV6RjdOQmsr?=
 =?utf-8?B?bWI2TXdGZXBXYmt6bHFqb1R1ejIrL09CaFNIRVdnSlFQTzVYYUVUTU1iS1h4?=
 =?utf-8?B?UWtIT0xNWlZUUGVrRzExR3JvSDhwVG81VXBoZHpDZjZhajNabHdaazBYUE40?=
 =?utf-8?B?WnIxZ0FWNFVVbkIwb05kSGFRQ2V1STE3VnQ4RXQ0QkJ4bk4yenhVdmFldWRX?=
 =?utf-8?B?ZXdVZFl2VU12aFkvdmJ2bDBXcTFuMTZTZ3VLR1hFdVBWVWJMNmthVkdhS0lU?=
 =?utf-8?B?akRCUkUrU1lKbk5lMkNSNFp2RHRlbjd2akJ0dWlHUXN4c3RybW53dU1vMDkr?=
 =?utf-8?B?QldnUFdjNWJwNjhjRUhxWUV4bFUwVWh2azcyMjB5NzFkejVnby8zN2JYNzFl?=
 =?utf-8?B?V2w1dHM0SnhTczJ3NHVlajVxdWRPMTc5c3JjMUJCZzBjaHdqeHNkV3BLNDhx?=
 =?utf-8?B?TWxyVklxYmRkeU5McVhJSk9XZElicnV3YXdaMU5WQ2thN1QwbmFtQU4vMWVF?=
 =?utf-8?Q?j/3RchpqdI193nvMv67yTTSJaI0wZGhD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1hYamFZY2QzN0krdklaSGp6ajJnSzRsWEZRcXpQV25FRzREY2k2Vm40djE5?=
 =?utf-8?B?STA1cjVaUXRISmc5Yzk4T2Uzd2p4ZFBkaFN4VTB2eTZWeEF0SE5TUzFRM1lw?=
 =?utf-8?B?dU9XdnJ0akNncURmenRxcFU5SUZ2YmxQSnoyNTg0aXZWUmpFMFVhWVd0dGxt?=
 =?utf-8?B?WHYvT1lGSldRcS9haHFLcTQrWGd3UHpPUm42c2VaeTdoM1VvTTNkNEpxZ2t0?=
 =?utf-8?B?QlB5c1hmcGRzWjhZeStvSzZ6cXU1b1o4ZDVXUEs3RFZUQXZ6ay9JaklKaFl1?=
 =?utf-8?B?ZFBzL2RXRGp4QjBBNDdwTkp5dlVOZzM1UGhxRktvLytGTXM0VjgwcDRyU1BM?=
 =?utf-8?B?eUtmUGw2dEFKZW5HNFNxUzhvNHo1aXMwaGk3ZmtiTlA3NHpFKzEwUlcyK3Vw?=
 =?utf-8?B?alcxcW5GMTdUOCt6V05ad2pMT2VlTzlwUHlIdWpCM3R1RldPSXRZMW1TUU5I?=
 =?utf-8?B?dGpXbEYzS0VmSkdsa2ZubVgvWkg5OEJ2a1VENXhFd0xxL0Vsd1JBTFBkdFA3?=
 =?utf-8?B?eWsraGtsTThTbGdmRVRhR0xkUGg2Z3IvQ0hpbGZsNzdXMVJtNnd1NC9GWVdI?=
 =?utf-8?B?L3VQdzZNQnhFNThUckxrMFNpUWRoV3d2NDZaaXVUMGpmUklxNExXeVptR0xn?=
 =?utf-8?B?a3dJWTA5MjN6UTdoTDFPd1lUUi8yYTlvbFZpVk4wVmRvNXRxcHVNbDEwRTNt?=
 =?utf-8?B?WVRyVEFIazU2SW1BWUxHUW1JMnZ6V3huVFBWQWg2WmlvRVJoeGlrcXhhcWRy?=
 =?utf-8?B?ZUxuNFFIdGo5dEZ6dUR3Z2tKUFplZkF4ZnhpVHVIWUxDWExrbUVHY2FBK2lK?=
 =?utf-8?B?TGRlUmZFbmZYTE40SkNrZ095aDJpdk9WUUhqQ24vc0I5enlGbnlzd2ZDOGt6?=
 =?utf-8?B?SnowNDRSTTd0MnZzQnJkYjdVM0pXVWZidzBCQjljTE4vT1lZekJTSkpaV2h1?=
 =?utf-8?B?V0d4UHhiQXFvRUQrMXZOd01nN1k4eGVnNCtVZE1XcUlRYXMwUkRDWk9YWUhi?=
 =?utf-8?B?NzQwQmJrTFF3Mm4rdTNHNFZBYTJIb0V4bnFEMHJyUXdEL2c5RkNhTUZ3RDdF?=
 =?utf-8?B?azgvSDUwUVJPQUpWN2RCTlRkK25OUktqSG04WHBRZDNsQkY0NXJWczhvTjl5?=
 =?utf-8?B?dkNMTlgzVlFXOHp1UWd0dlVIdDN6Y3JPTTREQVNiVDU2U25FSmk3WEI4Zmdu?=
 =?utf-8?B?NHpiSlhIbkRUeERrZzM5V1oySmh1UXJRVmtFcE9yVTkvNS9pK2NNRTdseWdu?=
 =?utf-8?B?dzhZNGh3MTNrNWF5cVU2THNMcFkyVEdVRUlZakE1Wm12MGlvQi9hNXZlbjRV?=
 =?utf-8?B?RG9KaHBhcXFhbFM3VmlyK2pxa3IrRnZ4YkdIdE82TTM0TlRSY09tQ05WcTkv?=
 =?utf-8?B?TmZlOWJYZU9VYm4vNEJ2ZldFWmZLdUtJZ1V4dUI5d3poRlhyWURzRkFiTlBH?=
 =?utf-8?B?Q1JwWk14c0x1TmtqMVBYQllvdFdNcVVwTnBtcm9maXhvcXNKR1UxdGRiYUNq?=
 =?utf-8?B?M1JoY0RFZ1B0R1JzTE5UT2xkS1YzZERZem9xb0FKVVpUem1nWHlJTzRraENn?=
 =?utf-8?B?TEFFd21WWUdDbndOMmI5MnZMT2lHWFJubVRRcFVCUGNyUVZ5NXJlUEsvRG94?=
 =?utf-8?B?VkhiNzBnR0NKN0FRRXBTcVhXVnJZZlJJUEJ0SzhTUFYyVkcvSG5OdCtMWHVC?=
 =?utf-8?B?SVV4V1NQbXN3STkzd0lGUmIvdW54cWRYTG9TU253WUtHRU9ucG9IZ2piVmNa?=
 =?utf-8?B?SjNkendIaFFWSXV0bWs1V0RJY01DSmM5KzZXZFBmcHBndUUvSlZyZHdUNmRC?=
 =?utf-8?B?RmlKRzJ2b1V6ZFpnSEFhSjc1dzg1N2MxZXhSek52aGRWc1laM1VaZkpQalRX?=
 =?utf-8?B?YXFxWUhWU1h2K05oa05NZktNQVd4aTlIakdWb2ZhaStlektpZ3NBZ3dlQ284?=
 =?utf-8?B?U2xjSWU1ejBTYWhSUUp0ci81Q1NibGVyWG1RM3cybWlHdTdHdldMeXBMTlo5?=
 =?utf-8?B?RVl5SUdjVnZySWUrams2SCtiKzh4NjUxVjZ6cVF6S0dHRVNCSEhHOS9PdVp0?=
 =?utf-8?B?UzNSbTU2dElnL0kzZFhiZkhtajZzdVFyQmp3RFNNMWI5cjh5azZWOG9sSEpG?=
 =?utf-8?B?TTFYdnFZR2hxL0trcElReCswTkszQTgxZjFJQ2lhUEtERnR0czZ5YWhKT01y?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q2gAHlkNAUaT/KvbbmOmHqCsnoEATT9+Ar0knQW9kwvgdRQsfdV2dZwx8OMX9OQBF3MNom88z1zISCxSgeJsuQ2mEMzneEw5lMdx3YGYXoPIQaaSz/sWKbT44Zl0bstSgqV0D6FvQ4+iJuHr7kTXp+SXDkGCUsE7aJ/N9gDJ9oeHK5n9HBfe/Cp0EUCk2LPSrMokIi/Q5mRS7eP93UzhYRl3YKw73hYuCiWXapP3fqdMaRc5STBSY5v1zne2t+WGjRhPmLxRj7yz2ZkLd9Ya4pcGGBaC0VqraTlkpNWrKQsiz/RpOG7okQmJeYTPowUn/BPGXFVYF6exe2eIAeeLnIjJ9geKf+QpQlcAXH3NBkTOdkTL3XxaiR+pw4X89qSQJzY+jtBQ3lH6OjDHf6zK9IGCOwxex0aOrutu+Oe8aWARdH8QEmG8dyudOMujJMrDmnncqTXLbKGwCZfY8vHFFZELzWYyQmcI+z1+p9uGj8yhyzflaYmMiCxyTLrZ+p6xjl4XeUJxM1lUNVZgpQh4BS/zY2YHzxSXLRt7ZuPz4qiqwx9yGAhGjRE5R0v+sLkxxqLIKb8JGMk8pGisg9IHLDr4i/01ZdBpKN0iArWX3mY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad2c3c2-5123-4731-4da0-08de2d75fa28
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 05:29:46.6662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzeIPrawf5AUBWGSAhVWFV9d+B1BXnjZIZACdoYzM0Rmt7bzmasdwPkSl+tNnd9ZhrAqFeAP/r9AMv7PU2o2XG8taUS5Y39oTitdDi1XLCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511270041
X-Authority-Analysis: v=2.4 cv=QPJlhwLL c=1 sm=1 tr=0 ts=6927e1ce b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=V570mO7CeqgZfI8DPu4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0-tVIe-un7h2q6OdaXroMsRzdAXboXsW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA0MCBTYWx0ZWRfXw74352NOqkJZ
 fOcn3wiUe33Ka+BSSz/HhpgrhRq4a9uK8Du65BEnUiiqpsmX9bvZ4SjTjJ6nMW965img2WVQANy
 wpM7l1KJwGEMi7RoEb/X71YEW+laWSveKdEvxFtiEJHRTZYgPAHsQYEfBdg+BE7cF4sV7YHGQGE
 I/jVGz7BVs9taL/K1sbmaj2OVX/TNHTl4+loxvopR2vVuRWA7bEDfwciUXrrVo10QTq4BFJvXAW
 m9a78DEs6wjeQuV4yzvfeBB9utGY7dVzk5eRX75pdPUCPTZLCP7GHE/anGQW8zQHBur1K7ntRqt
 mzz3blV5QDuRF1+9ejdcDdAMUizcWY3PTqtMksmBAH0RomqvcPn7ePKVqSBQUi9L09nt5+Z2gT2
 2UH7Ohd1Ucu7+3SBGpKABWZXK52r+A==
X-Proofpoint-ORIG-GUID: 0-tVIe-un7h2q6OdaXroMsRzdAXboXsW
X-Rspamd-Queue-Id: ED2DE180013
X-Rspamd-Server: rspam02
X-Stat-Signature: 3q1mqre6ss4jwhyjwgmcp9ftgjpzb5rs
X-Rspam-User: 
X-HE-Tag: 1764221424-979272
X-HE-Meta: U2FsdGVkX1+4kWwMwqYBi2caUGmH7DRlwYxfeEYyujDkVoftOV98lVNBawjRfRt1JR81MHwZBv51aygRHjXeeHjiIQYidN9NM56jcOdV2sbo1r+3PgsB3Iqnff7BV9SIACDPvmxOLaj7JiqRisORj5+nSsZG8QQdbFuPTuY/xCWiTsOhO24iDB7RUD5ImfsC8ZzYO9mt4qrfWpGAd90mf9vKS6Njfi+c47JYcrTPqu+Ixcinp04ly/9JIWAxzhCZQaI8lWh13wT4XD+OqG1uGwe5wPXC1XWCERhT/Lduo/pfGHg7ZBiaeYS01rDAEhHAUUowUQS/NeO8AKWQ78ijwn36Zd72PLFqJWI71G6Rx2s2+pKn9S4a/eekaUbXVZhi+Bfb8Esh1k3GMsACvOIc0cc7izhwav6ChxPQ+wIiXHZffEkjNZhyFLd3ar7L6b4TRr3DhSeDAOqefefiIwi1+EejZtXKitV3rOS4wvhIxzRSa15D79j28+AOx0wKP7UTfkAd6Z1QFMaxxnHwKvSGvbyXsPsTtjbE8Ss3Y6AWbZJVycvrRJdrHo/FIWKSGmsmkGghVFautJz5a6q/+4BmuaUFhOjsySQghHPztETpB0XL0DWtzn7dhh8X2x0E0JQhjNwK9LisG6AsEi07Ixx6XylO7ryGE2gvIdHZo3Drr5lszs6Zq2z3ho7SHrYbl4rzL6Uwk1bgN387lUo+3EEu9PiledUdmCg5dib2DeaawnOoLn8J1v3MkPN7+333RzpO3rmYBmptnJqk3fXZz5qD2S9TGyQcjdjrxylKnzJm+NaU3W2EIBmStHaYJcCfSQpkf4EMe++F5FdKFHEs0nmXbV2xR657azod1TvNlNL95cp4omiP1/jg4qilzO4TBneuKgB/mFm6lTCd8Rsl7reujswL0CDV/1lmm4D2ga2SnEdJaQEuVuKC2S+QLYMvxb3MlSDhCp1oc3RJs/iyl/H
 boQm8Cl/
 9il+/AWW+XlZ7s4/pj40mGsIhemMa7fwd9JtYw5S5O+7HSTihXp39LyShjQVN3HoHU5GEiC6FFDso8TtWrz/sjPoOX+/pte5Eio7yrknAr4uV2pKGQ8P/8J5Ezva+sGkzjrr2U0bbAeP8zD+mXX+gQfzL9Y5vgURVBCoQ4EHi7YJOkQSLeahw5fv2ptnj30T5SJ8emkc+lfbvuENczqVXfcBpXFnTr78PvMKqDEdSNj1gTzqLpkT4GHonxfsMceH+nJjKgq+x5avEmkEk51g+7uDnCY8ucJbTuWoNgPuySnxQqzB1l0Qs+SVceETbQk89xCpfzHfRZKNicXr0z8YlmGqdqvCbYAXInsV82aeqZABkVFS5ELM3T0czb2TBuQU2XlgoeOZ4pQyjMso7lDCIubN4fAxXdYBwJk9emQuB8518P1CcH7k8iWzn525goCWN+z4UBv/brYRxiKfUiepJ+zBdC8Iw+45P/qoJbFBKMD7jTuU0NxMv1e7KTi4iIie6xHQM6Bq7FBU4Us8IbVww4xxVwK28Z8K0ojrdMOgYV54JV3WFv8CRSaPZr2a5+KqYKEFURddIkDvvRpqE5FsDIKc3CA/C6PiUp4V3LmVOzgIu19fpiiX3GNauTbCWMgck1gcm27jlFKWLTekAsY9ax6xe5sIpjnEXAAVAt8ZrZV9xglNdi3tTr4PTVOJTbxu9rBYQdOOZgIODbmrpkE+rncjYBp1YbzLHdBbk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Mateusz Guzik <mjguzik@gmail.com> writes:

> On Fri, Nov 21, 2025 at 9:24=E2=80=AFPM Ankur Arora <ankur.a.arora@oracle=
.com> wrote:
>> + * Switch between three implementations of page clearing based on CPU
>> + * capabilities:
>> + *
>> + *  - __clear_pages_unrolled(): the oldest, slowest and universally
>> + *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
>> + *    to write a 64-byte cacheline in each loop iteration.
>> + *
>> + *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
>> + *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
>> + *    trusted. The instruction writes 8-byte per REP iteration but
>> + *    CPUs can internally batch these together and do larger writes.
>> + *
>> + *  - "REP; STOSB": CPUs that enumerate 'ERMS' have an improved STOS
>> + *    implementation that is less picky about alignment and where
>> + *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
>> + *    at a time.)
>> + *
>
> I think this is somewhat odd commentary in this context.
>
> Note about "crummy REP implementations" should be in description of
> __clear_pages_unrolled as it justifies its existence (I think the
> routine would be best whacked btw, but I'm not going to argue about it
> in this thread).
> Description of STOSQ notes the CPU can do more than 8 bytes at a time,
> while description of STOSB claim does not make such a clarification.
> At the same time the note about less picky about alignment makes no
> significance in the context of page clearing as they are, well, page
> aligned.

Good point. I'll rework the comment a little bit to align things better
(maybe reusing some of what you suggest below).

> There is a fucky real-world problem with ERMS worth noting: there are
> hypervisor setups out there which *hide* the bit by default (no
> really, see Proxmox for example -- you get a bare bones pre-ERMS
> cpuid)
>
> With all this in mind, modulo poor grammar on my end, I would suggest
> something like this:
>
> <quote>
> There are 3 variants implemented:
> - REP; STOSB: used if the CPU supports "Enhanced REP MOVSB/STOSB" (aka
> ERMS), which is true for majority of microarchitectures today
> - REP; STOSQ: fallback if the ERMS bit is not present
> - __clear_pages_unrolled: code for CPUs which are determined to have
> poor REP support, only concerns long obsolete uarchs.
>
> Warnings: some hypervisors are configured to expose a very limited set
> of capabilites in the guest, fitering out ERMS even if present. As
> such the STOSQ variant is still in active use on some setups even when
> hardware does not need it.
> </quote>

The last bit is useful context though maybe some of it fits better in
the commit message.

Thanks
ankur

