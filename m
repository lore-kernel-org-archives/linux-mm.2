Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4DCD39013
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 21:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425CF6B0005; Wed, 14 Jan 2026 16:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D43D6B0089; Wed, 14 Jan 2026 16:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257AF6B008A; Wed, 14 Jan 2026 16:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD206B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:16:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5B6CC0155
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:16:19 +0000 (UTC)
X-FDA: 84331827678.26.5B5CA49
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12FE3100004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:16:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RCewl4fO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X4f04Kso;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768425376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsBQqFti7aFDXfbjNnHHniYrVe2VYicKcOKWxhHUFh0=;
	b=Jq/AlfNEWCDIpio+mcpKpKbbWmkONgSoS60Bc5zHyQKxdIN1/g+guHU0kn6C0U5zSTd/SV
	O/w/ZNW4NwvPm4rzT9fCrt+8ukf+dFlw9cfQQm7d6P+bCkLDr+fOGd6Iro7MVHHqjZZ9OS
	tELFJe+g66UCp0v7aXDTP5jb4ODQE5Y=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RCewl4fO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X4f04Kso;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768425376; a=rsa-sha256;
	cv=pass;
	b=IIbw0XC4j+6yi8uEYEbCdC/JpmQwidrABOJ/JaePL8RGrq8HNZHTewq5tJHSy/cQRBn++S
	k+GhBPwYaFnhfyKndxptkRaBOOfMRUdik8xEN5s3Ori5VVa+aFrpW/yn76grUV7D/gbY77
	CsdEKb4U81nk22RKfUpRXpmBAfj3Iqc=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EI1A4M1940280;
	Wed, 14 Jan 2026 21:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SsBQqFti7aFDXfbjNnHHniYrVe2VYicKcOKWxhHUFh0=; b=
	RCewl4fOFs7CXZfZCkQNo5FqyB3GTveWMp6UaL/WS1LNUND7SuRy05geF08rXM1g
	ZANVsWBXxXNlZOIN9JtXd4BybO/xGLKWePzicVM/bdAqAh4v+LwNHGtTJCoZvVcc
	0yrYsrywjhK/HwOF859v3lzXCj7RvBVzXPsH9aqGx9Pt+oz978kIGd6Z2kvTbf7k
	ef9xNOslXjo5orVOYjNssrbaqeRY0CSPez/izvTGsyjj56vIiMSyWzzFyo+ousS8
	bHJ0OFCn3CmS7MbtsdJBT5naSM18aXahdXaQ2ulIVyx+iKkcnRQSKW0cSmXjuY+6
	qPMt1l/BOhFB6rSzmoLaXQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p39abk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 21:16:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EKjSpd008158;
	Wed, 14 Jan 2026 21:16:09 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7aads8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 21:16:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dx6bRemAEQpW0joQ5WKKCRgQO8ZYqMf78FueOCTm441kplyfJOY6rtsP1flA9ZtzLEd0sOL2HIUAipB2CKGwQM+L8Ahyn2S4PKBKUoKQCRwlccG7o/H0dqZrlklQnt01EcMLsQyVdXrrkinTX2KxkF+rhaqueCO3orzLzmchYdBnOKFioG8OMgCPnhb+nLI8Hpb5JlibFKQBQcie7RXh7TDFFhGj1Pqllc43iewD13235QW8tU1YjCwvNZPHjnHq3dQPdiqetzXOn+jh+4XKCJJ1QAoozQoK5Ez4T6GbIpUU5Ik9RAd3rY4I/sCuGBiwEhfddnt++l+Pc6P9wYOfLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SsBQqFti7aFDXfbjNnHHniYrVe2VYicKcOKWxhHUFh0=;
 b=HB92WfGkqZK9FYzpcFLcTwoC0sfsQSJOLbvwqkXhNs1YQocT0szqS7P+5llqV/EScWNdKourGs2iyWNkRMnfHuh+NwVvKrxzmOfoQgGZqdIIMKvjv/Hdjms8OsLNBm83Z6N/+v4/+z0onm9WchXn6M4VaRkBepe/dowEB1NavatnCH3dIAglIFOKqN30S8SVjqwLcp0fBlpbvrWoOhZBSBEEPikzznAUCIzDoly3V2955wt1PnV4LpXi99x+fkjYJphaJwWxHn5qJoEk3leHRgs4rj5atDPsnBtPs4C1wya+vQoYQiY6Co7fGCVGMRKFRpF4az7uZIS+W2kpyUS00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsBQqFti7aFDXfbjNnHHniYrVe2VYicKcOKWxhHUFh0=;
 b=X4f04KsoxINYvmOSwCphUhNCrdmrmHSXpjVU3mCN9vNPhkO7qQMpbiM+Baj/GDCpNKCKIhFZc2FSOcvLCHxRMRb79/8LaJb6OZVTFxUOoyPpR3vZ5EWsIU0EcyF6SZ8iPchr3uTkGlrZnn6Y4n1bdhi7teULZ/MeeZSHO9CcXrM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB4913.namprd10.prod.outlook.com (2603:10b6:208:307::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Wed, 14 Jan
 2026 21:16:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 21:16:05 +0000
Date: Wed, 14 Jan 2026 21:16:09 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        riel@surriel.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare /
 __vmf_anon_prepare
Message-ID: <23daf873-1e80-4e19-87d4-b9d54ff081a9@lucifer.local>
References: <6967c517.050a0220.150504.0007.GAE@google.com>
 <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
 <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
 <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com>
 <CAG48ez0q6ZXAk8D3frvXyeMsFDYfmY0sc=PkE6bRM8QP0gEVfg@mail.gmail.com>
 <CAG48ez3+t-uv88cUhG6=YfMyRVW5REi3-aaW3a_yXSZDK38_ow@mail.gmail.com>
 <96aec792-7d10-4dfa-bf35-cc94300f4d2b@lucifer.local>
 <CAG48ez28kdkX1imCj3rDYNTi9PKQBx9Cqf+N2Rg92o9BEdo9QA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez28kdkX1imCj3rDYNTi9PKQBx9Cqf+N2Rg92o9BEdo9QA@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0128.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: 71e40fed-a33e-4a63-aa1c-08de53b220cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUJDdkk1c0xVUEZCYWNqUm5LcC85b3V2Qkl5cmRoRkswZ3dBcmpqQWFkY0Ry?=
 =?utf-8?B?QytWcElCYkN4NFB0eXVVTWc1a0I4K01WUzFPVkZha2FsZGRYRW5yVml4eFhN?=
 =?utf-8?B?Y0h3WEw4SFl5YnpJSlVVWFFvY0grNHJBSWVnSklyZ3pWcUN5MUJydndldGc5?=
 =?utf-8?B?aE5hU092ZDVWRzMvT2JpMHViWmkycXZXckNIUTUrb0NrR25Eai9OWjdEdFdD?=
 =?utf-8?B?WnZxWC8wdVdqdE1rY0pDbzVlSkUzcHV0VEd1MkNsbHFFaUpUS3h5Zk1tVjBH?=
 =?utf-8?B?cGcvSDFSNnZjcW90eERSY3hTYTJXcm1rdnEzaXMwTWRmTHBpUnltWStydWYx?=
 =?utf-8?B?enZYTWFDK202Tnd1ZXpOcEk3cGhkNm1ObE1MUkI5RzBoRnYrM2hLU2FuZEVh?=
 =?utf-8?B?c1ZSOG9QSC9VSHUxWVBKOEpOd1RBYS9EejhnaDd6bFYweEYvKzFjMlREd2Fr?=
 =?utf-8?B?YjBpQmJuVzdpWmhEWUdVMHQ5UmhKMHZ2Rm9uV3o5Z3dVNXJaMjJxazk1UnRz?=
 =?utf-8?B?K0NDaStHc2dYZ1R5bTRqempPOTRsWmcrWEJhWWV3elB0MUtOSE1sOWFmY1Rs?=
 =?utf-8?B?V2ZhQ0lnMXlhUHlLRTIzODMxb1NCdjhoejR2aVVwYVpNS1gyTHk5UHBrY2ph?=
 =?utf-8?B?cGhSbkRzc2dQcDQ4b21iYkN5TjNrWHRuMFk3T05uOFFZUW1HaG9KVHlnckQv?=
 =?utf-8?B?MElOdHk2M0picXY5dkxrWGdyaGlQbFBMWWVJa0xhTFRxZTVEbTk2dksxNkxo?=
 =?utf-8?B?aWU2WXR2UkRXQnZ5ck9NSzl4TldOZnJycmQ2NWdQKy83Sldlczcrb3FPUVBq?=
 =?utf-8?B?OEo1aTNLK3NnYUdZZVhqS20wS0ZTcnNQcFh3dEdsTjk1THhYcjgzbW9TRW1B?=
 =?utf-8?B?VW4ySmNUdW9jWDB0TXFsazlqQlJJU1poc3NxNy95RnZReGRIdzEyMHZqNWRn?=
 =?utf-8?B?NTV2Mjh3eGlpaDNCUzlYU2RUYUtxQUxRbEp1Y0RwNGRMRUFrTmwrRXVLejhz?=
 =?utf-8?B?U2x2amJQeTRXR0VUNGlNZVlNaGdvanhPenZKTGl3UmZHMHlGcFhyc1cyMFhF?=
 =?utf-8?B?MFBjTG4xTnZHL2RjbE5Gdm0yNkZQMDEwTlNQZTFmdVVLWlhuU09XYlhycUsy?=
 =?utf-8?B?aHlHWlI2WUZJdytzNTU0RnYvY0JzQ2xDaWhBWldWdHcrWlRKZ3hFdWJwTGta?=
 =?utf-8?B?WGxIS0UySFNtVXk4TGJWaFV6RWxoWi90YytEdVlvTDR5SGprSzQxUmJrU1hY?=
 =?utf-8?B?SHhRQU5ydU05REczSzV2ZG8zMys2Mnkzc1J3NnIvTG1xMEEvajFuN0dxVVBP?=
 =?utf-8?B?Z2hsZmJyL3NsaUR3VGxVV0VSQkdnQzYyWDlDQ2dvK08vUnFtS1RGSTlRbGxR?=
 =?utf-8?B?WkkxbUdlNFBhNzRpT3pud3R4TlQ1OWlhTDdETnNYdkdpT3RxY2R3cjBvci9M?=
 =?utf-8?B?STg4YUlQU2phcWFXVTlkUGZvdFhLUUtjU0I2em5STkRkL3JHVG1uU1J0SHlT?=
 =?utf-8?B?TzhkQm5kQmVWcG5ZdHlDY2Zpdmkwc1NoOXBlNkVVMk9xeHVxOXl1MWhWcHow?=
 =?utf-8?B?QnpoamRzUkVmcy9VMnllWWxqaVJQdlB4eVdMN2xBSW5RVldkVnVmTllLUERJ?=
 =?utf-8?B?RmxKQzl6eG42dG1GQTRrc0NPSUY3OVloOHlwTlA2RWt6UnpNRDgwNmVEY2xD?=
 =?utf-8?B?OFVHQXd2SG1kZ3lyMHpLWUp1TlI0T0YzZDZibHFOeHBqeFAwWlpKNGtnWldr?=
 =?utf-8?B?UDloVjBIczd0Z2ZBQ2ZvVUtvQkFBU3h1NGJuVTRZNFVYVzNXaVlQS0NDNHJ4?=
 =?utf-8?B?R2NTRTdTU3FEMk8wOVFKWFhzSVlXeXBVakRkRUE2c0lSZ1VMQlBpZ1lyV20w?=
 =?utf-8?B?Z25WOUVpb0hwV1FVUEh0N0ZBRnFsVmtrcXM3NHdSaXV6V1A5THJyRVUzNHFt?=
 =?utf-8?B?TE1PTWRIUGhFWE14Q2FoMjhVanJSZ1R1Y00wSCtVTUsyNUhSSUxkZXoyMERv?=
 =?utf-8?B?R3lSZnhFUkVVVGxGUW5SMFVIVUdKVHExRjRwbEFTY3psNU4xNFNlTjQwRm9Z?=
 =?utf-8?Q?Cr90Oi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlFzVlQ3bGJRQ3k2ei9oNVVHVjJFcyt2eWJNaThFSUpjQUR0RTdoeVRUMDB6?=
 =?utf-8?B?MkV6UldkSlc1RWNlUnJlTmlPQS9zUjk2T3M1bVlCT1BqVHhDb1FmbU1wTUZI?=
 =?utf-8?B?MlpuV2RhQzJ3L2xZK25XbGYxN05ad2d0MVZic1NEKzNtWTJXNnlydFU4M2Qv?=
 =?utf-8?B?a2Y0Y1d3UjhBWEk2Ny9CcGFNOVZOY1puNWhpVHVNdG1xQkVLc2dpSU8ya29D?=
 =?utf-8?B?OXlxTEFpUThIeEx1SDE2Zk9UTG80YVNPcDViRlV4anhvdGcvTFdsZmJtUlhJ?=
 =?utf-8?B?aTZTSkg0azFQZTZuM1VBUDJ5dy8yR3JpTVdNdFFpNWt6MDFwc0x3N3F5VnNm?=
 =?utf-8?B?cVRRTGtIc0NLWXZmZ1VNbFhZZkNjNFNNZGoyNGR1SnlTMmgyVTU0TVpGclh3?=
 =?utf-8?B?bmlXTlcrbEV5M1JVTXg5VjhyUVl2aTd3dzJBQ25jQ3BnTU5zRUdHa0ZQR1ln?=
 =?utf-8?B?d3VpYkZteG9yR3B1Ukd4ckpad1NtcGMwQjE1U0VGV2xCR25Eb2N2Szh5U0VP?=
 =?utf-8?B?VkJIT2YrdGNzVEZaZko2L0hOcHVsdnVEYmZBcENXeXh0RmcyMS9ZZ0ZPd0Zs?=
 =?utf-8?B?RXlZeWNjMVpzell6b1F2UVVhSFNCTm52aEIzODU2b2lSSzNERkI2a1ptTkdV?=
 =?utf-8?B?NmZZMGF4MXhJVlJhRTk0U0wwaVAydU9Zdm5NanZVcjBWaHBxZU1lWC9HbFRR?=
 =?utf-8?B?dXBCcVhOOGtva3NOSS9vS0pNZ0t6YXc0bkVpNU0zcitZUmtNTlArM1ZvTUFu?=
 =?utf-8?B?UitzVU16aUN6NkJsQmRiQ1pmZXc2SStlVklORDRWTFlhZkpIcTE3VXZBNGI5?=
 =?utf-8?B?K2tPdlFpck1DYlNydStScGZYNHd6V1ZIWkF3WEt4cjkxZjN1aHp2MUhrTnJM?=
 =?utf-8?B?M0Ria2FxUzVJbU8xSytBVXhoemlyZkZibXRUS3VjTmRRcnFBNkNnLzBPTFN3?=
 =?utf-8?B?cHpVM1R1UGtYV0c4dHVFL2U5N3VFZWIzMmxMOHNpYTJCbXJHeGJrNjRKYndo?=
 =?utf-8?B?UHhFN3k0R0JwQ1ZjSGNlem5RSTJ0dE9PRXk1T0VBVktRbCt3WEg4UHorTVM1?=
 =?utf-8?B?anJJWWQ3QzA0NjgwM3ppYXp5YXFkWlV3Tk5MRDc0RXFGSFFzVmU3RnYzaTZE?=
 =?utf-8?B?bjl0SzlhT2wyNUhCVmhkL3Q3cTJYcUZjTzRZZXoyd1JBMmFSUHJwS1E3R2tX?=
 =?utf-8?B?S0lUZnVUaWZGNjNvSlRQUVVPT1ExNFB5SC9IOHM0QUxqcEo4UWFRZHhHTXBX?=
 =?utf-8?B?YlpyTHc4bXBteVFSbDZmSk9KMk40VFNTa1BIOHM1S0dJNHpURXlPZUQ0S1J5?=
 =?utf-8?B?UWt6Y09qY0xiQXhkMjdtTFk1RkN0alZkYXAreTdEbGYrenRwZGJoeVNnTzBO?=
 =?utf-8?B?SHBLWGN4NHVvS1dvL2hUekw4eXNXekdlL2JrWitlWm05aFpLT3FROTd0TkZK?=
 =?utf-8?B?aU9YM2NkTDVaTjIzNGU3T3dzZmhmaEhsakwrRStDMEo1enhMTEVBTWdub0lj?=
 =?utf-8?B?Ymk0VXFscHkvMmZoWDJXdXh6ZmhrNmp5aFY1WTNXdVlFY2pmNmR5V3psemtS?=
 =?utf-8?B?QXRVLzRlVWJuaU4zYkF4K1djUHRCaFBPdGJxalA0ZVlGcU9Fdy9GMlR1ZTRi?=
 =?utf-8?B?am53L2MxQnk3NlYrR1lyMTV5TVZsSnE5Z2U0MHZUYzNkaHB3aXJYcjU2STVN?=
 =?utf-8?B?c1RVcVNhbWdSelYzcVZLeE9rUnR4T3N2NkFINkhxazJpL1Erc2xMbllvRzY2?=
 =?utf-8?B?UHBQMklrbGZoeFE5UTFxQXgzbThQRUJrbC9LTkJaM1FTeHdBbEF3bDI4bHow?=
 =?utf-8?B?RmRzUUtpLzNaNkNabDFzNnZnR2NQdnpwczNJVlVVRjgzeEdubW0reVZiNUZC?=
 =?utf-8?B?aTRBSXFCSG9DR25Za2VmNS8wV3V1K3FNelk1K3BScUZubDRieU9hd2pYV1Vi?=
 =?utf-8?B?cE1uUVpzQ3VNSURqTWFVd3A4bGRDZGVNVWlJaGkwV2xoWGxNOCtJaUZ5WUFD?=
 =?utf-8?B?cWpJR2crV1krdk9HREpEZGNmZ2VlTzFmL3k5M1ZsakVwQzY5VlY4VnR1TXVM?=
 =?utf-8?B?aTRYSWl1ZTVNUkROYkJwbFpyb083NDRkak1sWGN3dlVPd1I1QmhWQSttRTJX?=
 =?utf-8?B?TUNTblBCQisyRjIxYUhJc0FOTmpOejIzalMyUGlaeW5SUzlRZDQrcDRHT1p1?=
 =?utf-8?B?WUw0VUNQWHV4eXh4VHNHM2lNeFYrTHB3UlZmS1BweDhlRXdOWDJZQmFoRVl0?=
 =?utf-8?B?bE5vVno4YUVqQ0k2Vmx5OTFYY01QQzltQVA4eG9HTGxIN2tQbHh6OFlkaVBv?=
 =?utf-8?B?ZUJmKzc1MmVtR0ppNngvMkh0ODRzeDBWZEVkditkTEZoUWRrSmJuREl1NmRa?=
 =?utf-8?Q?ZRPYI4c4Vw01bKrY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tT3cvkLQYoG4jZloBiyaHEAvIZJHNidpc5cv2/RcvRAdaKjLMHtExG4oMW8URNKR7GZ55LcxvB5ZtE0pfYVaF6DWppqSRQs+vBqtypcmcAExYlj9LLb7KY0lYQwpO4vt6sQ2PDfVMqXLnX03vTi5sJ+GpUcQzhZ9cf4n4D+Ac5qPPnB172Hcjc+2y9swTH1Z/NXxNIskh04ggHBSoQ7rGvjCea4HAn7s9tyHCDwuSy4dNzDf/R6lYamIHJfB96WsIYFLs/tj/SV4xmyWnozCFkf1I9+Sry6U8VQfwfQ7bMq1qUKSbIQtJNvoyYgDyyCv9PrufDk38UD/DOaHm3g9dMvEdOqa4f/jCrlvm6ISc1n5BwIFG76QcqlLD7BKfC/e82DZIXX68ixkrThOhh+jZ3gDBrw4rCdbxyzY/k0f0OCYkrpGSP1TlBprH2ERYt0bKIonTwuY+nblpiNGAgDaqTY6mQOSaUK4F84AeuuNxT5rBgLBwrMEqZ7MoyOb/2HuQO3pdGH6bdrZsqTcGEHVblKVnorDjUCeG6k669a2p+RJXNERpgKGV7kJ1UVTg2ErZJh+9c3eAcoLnQODT9CW5d7j4iNXKdY69q61EM9msWQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e40fed-a33e-4a63-aa1c-08de53b220cd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 21:16:05.5202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pkuxdh1zJ62A2SZNWNgmc+leSvzZKW3AR94ixH5UW3i2P+gJxIYyIOlZEiObolQtO4nWCgRwktjnqT1uAm4dSp5Gp6tnuepFcJ5WwrMC1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_06,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140174
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6968079a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=P-IC7800AAAA:8
 a=pGLkceISAAAA:8 a=hSkVLCK3AAAA:8 a=IC33No1jZWI0jZxw94cA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: sRtA63dvz8o4gd2Otu0h4XEmhlscPJUg
X-Proofpoint-GUID: sRtA63dvz8o4gd2Otu0h4XEmhlscPJUg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE3NCBTYWx0ZWRfX1Ibc65fTxxYp
 6myxAnHyLg52WIlPMuvwVFcHkFAuWZgAVFlvGwiIoLSlZPis7mqI8NoLrDE38Wvw9wNGR8fU46b
 Xppe7Xftbal2GXUSzVlAL3czwh5N/MB0+Pqnc5mrlhOhn5rcMs9x3QZsvppzoPy8y4QFY9tdmu/
 5otKxk4EUH4hXdLdy+fhD3vBjLTAPDZJs4IPR6bgm81ImTDa0EQbPa2tla1EwlvgQykmsbnTC0D
 hMBiBWpagwpf1im4htApMl4q4ySHqScpToiRrCL+1Q86jCnpDWsh4tjJb9IR9cnbk4ab0XXGvrC
 gRi+5iYbbWHT/kqEjQcR8mzwchrJPuENSwL2vNIPRK09koLA7bKWVo0vZz3+wt8oitAMeBzvcGd
 pNAQQLyVMyM9TV43rgRlhTj1Z33mq+hUDsFOpxHCcE5hz3NJvJG9KQRBLtETRaQVaMckHxdmyXy
 Hrk5xinCwXNbSxE5SMg==
X-Stat-Signature: ybwujmp1tgmp6gcuk13an35q34pz5sq1
X-Rspam-User: 
X-Rspamd-Queue-Id: 12FE3100004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768425375-851949
X-HE-Meta: U2FsdGVkX1+iypE9Dp4olIM0eSK42RDW7Tto7rfKRAPPGyf2WxlLKprEAs4Th3owH8WHlUS8YEbcLGrb5uJluZ1RaYkXX1IPqNEDezxyvaEkgpHk1uU2Y7g4fLEUPQu7bVCuhZg+ZiQ3P+ZOAFMJdLrDCCviFIlLa8MJut203jOkfX8qurOHcp/lDfFsVnYpfxaklW+lLKfI9XkNU9SFMvxJVniTe1U06V6HvKGktJhMhCK9niZgcFx9+b8MwzRDWELEIZr3HhdDabnaWkEDkvo7fDLPi6DVv0tL8MLkbE7aQB9PEGKSMulOgtCNg6+GbH2LqFs5MlnXkYf3jGiFyxmkH/VzATGpxmdZmcp79FT26O30FRGigNibGxyVeFQHFLtI0NJAX1qz/PZqqrNL6L5hw4ksL6SZnyhQ1HPEg/XhEI64+LWcymSYiWhg3QPbEe0LyPb1ll7q3F+I1uz1zSZkWu1BG5vEcdecusHU5jDf44RVPWl/qOe+XCwcBelZOiMxp529ekAwoVDe8Hp0BIQcT3PhpEEdsG/tKUUVxW2iPN6KnfJTzYP/VTaJZ0QTuxqRPg7+p0JrtK1S1eGqRFOPdoKd56A2XT/a3RkEQat8kzg/qJL5RtSK/UhF8JqToL5lHR7rNCFmTi24aFuNSBvOcA1LDR/Aa53llzQi604uc4VNEo+PcBcP6D8sNzx5GzDaSUZIR7HdO2f8ErJ34PlivzRCDS7ofWbp42c9BnBiFPv+NQ5p10fzZxB69zH6hsZAuNTsRhLUkLRxop/uvJVB9LIPHY2/POpRufczimiGA6sjGtyKPDJ58R9usWFSFaVqbJMYlvWL8GHx/5rDksTS1xLOVaSRZihXKdlbJhdkwUWsEDqNDoiL1oJbj/bRNKtuYWSNbzfzw3GDXFBCHylyLLN8EU94HdViQOktWASw4OQ2RnqtwUH7KcxbH+2RwCic9OrjH4OgCN9YW+9
 B9CCo5/5
 0cp3jbK7sY6At6voK5AW6ZUyq7fXbjQc6jejfyQZtrkauonC+rbbMDVCE2XiMUSA+/Q38GbSoJIHXB+KzjRDazEgLLZFfCKKBVFGe2K0IqiT6A/irTQtwIqVxC0vBovVtW+7boj2xcyUQpgA7mLPO4e+7yaU0gE5XBFxI+troizOnWQQELlMCJFL3T5MUGAkC/ITbercFdfKGRDTBAvTHOVkbvFrVHLvvy7gf8uYkBWZdL/kxfE34g/o4wiB64eCXIspHkDjNWtqQPh3CMdqwPaOuXLLIXhTn///953bws9kMlR3xNwvFQyEUXOK6YKyR2rj9uilHAatUexTXr8nvRCCaYFNEHDQHZmArxgvfigG/oItgl6j6VgwLWxmmX7jPIOQ7g+370i/2ceFXiPeYTkxRTKL/u9qX2id5v3vZHTCgopxxmpwTv5fQXg/0EI0PkeBePtZTtg0K/+zZWT3tlec5x+d7iFHFKt198in6iGWZcTlY3ubD14XSWGY1SgfJYkt+93MqYtJTs9283ZOD0KtoRYcszNdZ+3+y3erPDJr1WozyzFjMV9Ykt2IDH63nzbmQMgwox2qZYpl6AQgSgaPWSDjTDDFrvLEnLht7anBvBdsYxzkS+22JkkfkLNI5r7ynHNkkoClTUf75Edrq7FSqwRvkR/72MFglyuraG+Y+7Qs6cgkFKRxSHuEtgsZbKCwJmYaJ3XXVOQqA7MU/wotgvLtQz9nmV2golyBekm7UoSyk18hqt8BJ/Z/kJfj6vH99ULggEbfmb9yjBc1Um525IbNm8ZaEJ9xWptveYud2uAhkqLXV6JTO1J3JjjmqnKpjwv3oMdjNErTCS7ypEwvBEGrOTZaGtL6gtCVVfAx5+xQeNwXRpDErbAgTWutaq5wrH2sfw+CIF6RY2fwohKDGeFnnfdiAjh0ttwtdPws3NzkuVYkgEaXwvq/PxHjcC5NBwlxFB1FpqRoy+AxdjqftsjhC
 n4aSAXKj
 73gf52RMO/hCQVnXaXhTskBtLZJglIK9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:23:37PM +0100, Jann Horn wrote:
> On Wed, Jan 14, 2026 at 7:02 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Wed, Jan 14, 2026 at 06:48:37PM +0100, Jann Horn wrote:
> > > On Wed, Jan 14, 2026 at 6:29 PM Jann Horn <jannh@google.com> wrote:
> > > > On Wed, Jan 14, 2026 at 6:06 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > > On Wed, 14 Jan 2026 at 18:00, Jann Horn <jannh@google.com> wrote:
> > > > > > On Wed, Jan 14, 2026 at 5:43 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > > > > On Wed, 14 Jan 2026 at 17:32, syzbot
> > > > > > > <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
> > > > > > > > ==================================================================
> > > > > > > > BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
> > > > > > > >
> > > > > > > > write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
> > > > > > > >  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
> > > > > > > >  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
> > > > > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > > > > [...]
> > > > > > > > read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
> > > > > > > >  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
> > > > > > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > > > > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > > > > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > > > > > [...]
> > > > > > > >
> > > > > > > > value changed: 0x0000000000000000 -> 0xffff888104ecca28
> > > > > > > >
> > > > > > > > Reported by Kernel Concurrency Sanitizer on:
> > > > > > > > CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W           syzkaller #0 PREEMPT(voluntary)
> > > > > > > > Tainted: [W]=WARN
> > > > > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> > > > > > > > ==================================================================
> > > > > > >
> > > > > > > Hi Harry,
> > > > > > >
> > > > > > > I see you've been debugging:
> > > > > > > KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
> > > > > > > https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@google.com/T/
> > > > > > >
> > > > > > > Can that bug be caused by this data race?
> > > > > > > Below is an explanation by Gemini LLM as to why this race is harmful.
> > > > > > > Obviously take it with a grain of salt, but with my limited mm
> > > > > > > knowledge it does not look immediately wrong (re rmap invariant).
> > > > > > >
> > > > > > > However, now digging into details I see that this Lorenzo's patch
> > > > > > > also marked as fixing "KASAN: slab-use-after-free Read in
> > > > > > > folio_remove_rmap_ptes":
> > > > > > >
> > > > > > > mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
> > > > > > > https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com/T/
> > > > > > >
> > > > > > > So perhaps the race is still benign (or points to another issue?)
> > > > > > >
> > > > > > > Here is what LLM said about the race:
> > > > > > > -----
> > > > > > >
> > > > > > > The bug report is actionable and points to a harmful data race in the Linux
> > > > > > > kernel's memory management subsystem, specifically in the handling of
> > > > > > > anonymous `hugetlb` mappings.
> > > > > >
> > > > > > This data race is not specific to hugetlb at all, and it isn't caused
> > > > > > by any recent changes. It's a longstanding thing in core MM, but it's
> > > > > > pretty benign as far as I know.
> > > > > >
> > > > > > Fundamentally, the field vma->anon_vma can be read while only holding
> > > > > > the mmap lock in read mode; and it can concurrently be changed from
> > > > > > NULL to non-NULL.
> >
> > Well isn't that what the page_table_lock is for...?
>
> The page_table_lock prevents writer-writer data races, but not
> reader-writer data races. (It is only held by writers, not by
> readers.)

Right true, so what is important is does this matter :)

As far as faulting is concerned, we only care in so far as we'd become a
writer and then figure out we were raced anyway.

>
> > > > > >
> > > > > > One scenario to cause such a data race is to create a new anonymous
> > > > > > VMA, then trigger two concurrent page faults inside this VMA. Assume a
> > > > > > configuration with VMA locking disabled for simplicity, so that both
> > > > > > faults happen under the mmap lock in read mode. This will lead to two
> > > > > > concurrent calls to __vmf_anon_prepare()
> > > > > > (https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623),
> > > > > > both threads only holding the mmap_lock in read mode.
> > > > > > __vmf_anon_prepare() is essentially this (from
> > > > > > https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623,
> > > > > > with VMA locking code removed):
> > > > > >
> > > > > > vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> > > > > > {
> > > > > >         struct vm_area_struct *vma = vmf->vma;
> > > > > >         vm_fault_t ret = 0;
> > > > > >
> > > > > >         if (likely(vma->anon_vma))
> > > > > >                 return 0;
> > > > > >         [...]
> > > > > >         if (__anon_vma_prepare(vma))
> > > > > >                 ret = VM_FAULT_OOM;
> > > > > >         [...]
> > > > > >         return ret;
> > > > > > }
> > > > > >
> > > > > > int __anon_vma_prepare(struct vm_area_struct *vma)
> > > > > > {
> > > > > >         struct mm_struct *mm = vma->vm_mm;
> > > > > >         struct anon_vma *anon_vma, *allocated;
> > > > > >         struct anon_vma_chain *avc;
> > > > > >
> > > > > >         [...]
> > > > > >
> > > > > >         [... allocate stuff ...]
> > > > > >
> > > > > >         anon_vma_lock_write(anon_vma);
> > > > > >         /* page_table_lock to protect against threads */
> > > > > >         spin_lock(&mm->page_table_lock);
> > > > > >         if (likely(!vma->anon_vma)) {
> > > > > >                 vma->anon_vma = anon_vma;
> > > > > >                 [...]
> > > > > >         }
> > > > > >         spin_unlock(&mm->page_table_lock);
> > > > > >         anon_vma_unlock_write(anon_vma);
> > > > > >
> > > > > >         [... cleanup ...]
> > > > > >
> > > > > >         return 0;
> > > > > >
> > > > > >         [... error handling ...]
> > > > > > }
> > > > > >
> > > > > > So if one thread reaches the "vma->anon_vma = anon_vma" assignment
> > > > > > while the other thread is running the "if (likely(vma->anon_vma))"
> > > > > > check, you get a (AFAIK benign) data race.
> > > > >
> > > > > Thanks for checking, Jann.
> > > > >
> > > > > To double check"
> > > > >
> > > > > "vma->anon_vma = anon_vma" is done w/o store-release, so the lockless
> > > > > readers can't read anon_vma contents, is it correct? So none of them
> > > > > really reading anon_vma, right?
> > > >
> > > > I think you are right that this should be using store-release;
> > > > searching around, I also mentioned this in
> > > > <https://lore.kernel.org/all/CAG48ez0qsAM-dkOUDetmNBSK4typ5t_FvMvtGiB7wQsP-G1jVg@mail.gmail.com/>:
> > > >
> > > > | > +Note that there are some exceptions to this - the `anon_vma`
> > > > field is permitted
> > > > | > +to be written to under mmap read lock and is instead serialised
> > > > by the `struct
> > > > | > +mm_struct` field `page_table_lock`. In addition the `vm_mm` and all
> > > > |
> > > > | Hm, we really ought to add some smp_store_release() and READ_ONCE(),
> > > > | or something along those lines, around our ->anon_vma accesses...
> > > > | especially the "vma->anon_vma = anon_vma" assignment in
> > > > | __anon_vma_prepare() looks to me like, on architectures like arm64
> > > > | with write-write reordering, we could theoretically end up making a
> > > > | new anon_vma pointer visible to a concurrent page fault before the
> > > > | anon_vma has been initialized? Though I have no idea if that is
> > > > | practically possible, stuff would have to be reordered quite a bit for
> > > > | that to happen...

OK I'm confused how we can end up with an uninitialised anon_vma actually?

The write gets ordered before the initialisation, somehow?

	anon_vma = find_mergeable_anon_vma(vma);
	allocated = NULL;
	if (!anon_vma) {
		anon_vma = anon_vma_alloc();

WHICH IS (maybe inlined):
******************************
	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
	if (anon_vma) {
|-----------------------> ??
|		atomic_set(&anon_vma->refcount, 1);
|		anon_vma->num_children = 0;
|		anon_vma->num_active_vmas = 0;
|		anon_vma->parent = anon_vma;
|		/*
|		 * Initialise the anon_vma root to point to itself. If called
|		 * from fork, the root will be reset to the parents anon_vma.
|		 */
|		anon_vma->root = anon_vma;
|	}
|	return anon_vma;
|*****************************
|
|		anon_vma->num_children++; /* self-parent link for new root */
|		allocated = anon_vma;
|	}
|
|	anon_vma_lock_write(anon_vma);
|	/* page_table_lock to protect against threads */
|	spin_lock(&mm->page_table_lock);
|	if (likely(!vma->anon_vma)) {
|---------------vma->anon_vma = anon_vma;

Am I totally misunderstanding?

How likely is this?

Given the anon_vma_lock_write() and spin_lock() are we not avoiding this anyway?

> >
> > As far as the page fault is concerned it only really cares about whether it
> > exists or not, not whether it's initialised.
>
> Hmm, yeah, I'm not sure if anything in the page fault path actually
> directly accesses the anon_vma. The page fault path does eventually
> re-publish the anon_vma pointer with `WRITE_ONCE(folio->mapping,
> (struct address_space *) anon_vma)` in __folio_set_anon() though,
> which could then potentially allow a third thread to walk through
> folio->mapping and observe the uninitialized anon_vma...

But how would it be unintialised at that point?

See above.

>
> Looking at the situation on latest stable (v6.18.5), two racing faults
> on _adjacent_ anonymous VMAs could also end up with one thread writing
> ->anon_vma while the other thread executes reusable_anon_vma(),

	if (anon_vma_compatible(a, b)) {
		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);

		if (anon_vma && list_is_singular(&old->anon_vma_chain))
			return anon_vma;
	}

Hmm... again I don't see how we're finding a mergeable anon_vma in the
adjacent VMA which is somehow uninitialised?

> loading the pointer to that anon_vma and accessing its
> ->anon_vma_chain.

The VMA's anon_vma_chain you mean? anon_vma doesn't have that field.

Is it again based on the assumption that on some architectures we might see
a write of an allocated-but-not-initialised anon_vma?

But I also don't see how this is harmful anyway as anything that touches
anon_vma state meaningfully has to take the rmap lock anyway.

I may be missing things here?

>
> > The operations that check/modify fields within the anon_vma are protected by the
> > anon rmap lock (my recent series takes advantage of this to avoid holding that
> > lock during AVC allocation for instance).
> >
> > This lock also protects the interval tree.

I have recently reworked a lot of anon_vma and am focusing on it as an area
to address so am interested in exploring this on that basis.

Thanks, Lorenzo

