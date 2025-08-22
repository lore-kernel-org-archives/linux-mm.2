Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2260CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 10:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62D26B01A9; Fri, 22 Aug 2025 06:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39836B01AA; Fri, 22 Aug 2025 06:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01336B01AB; Fri, 22 Aug 2025 06:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A916C6B01A9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:23:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A12B83D76
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:23:28 +0000 (UTC)
X-FDA: 83804006496.18.2DFC711
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id D60DD2000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:23:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hANaDJHB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hJpcTLLy;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755858205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11mAfafIoH0UwJmaOyAEiYly7c4T605fIYz1Qw1XhuY=;
	b=1pW5sGQk5KD9Ed59aWcAax5/bL0Bor4GKcG/JiohY0uoUJyHAE0Bj4HhX3av1ofynVmWe5
	YNi6RaO70Q2CKtxwJ9rd/avcXImvY7apPhXIlG5ripByO1wrgUMjcM/iXyLMIRmsOJ/1d4
	VWK4qfvZkOOCUT9is+fc70X1bYrRccY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hANaDJHB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hJpcTLLy;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755858205; a=rsa-sha256;
	cv=pass;
	b=E49KXSMJKLAMtSY/HzgI5LrVu/YKSGz0oeDAXNTKrv2bgBK7aF2IQYHKZI4ZstSGc1dhGs
	oAA4QX+LSk8FrtpEF8Gw3p3TQO5wnq6qiSm7dmY06FDUgVU5tt6TLvDdDSSyh6JAwsLzrc
	Gjt2bXHM2o8CVYU7LxA1TNoTdNBq7WE=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57M9iwMF024109;
	Fri, 22 Aug 2025 10:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=11mAfafIoH0UwJmaOyAEiYly7c4T605fIYz1Qw1XhuY=; b=
	hANaDJHBodJ62O5gvCJpnCcl14NtcPcibbxbxGk+zkZYpqIUxh5VBlUSPxdecWwq
	dSSHn+v2NhvmtaIpf6ra5QEcxN0H74T6Zi0zobyP3Owp8luaLmIZj/e5Lm0nPkzK
	cOMPzECQ2izAObg3PChpJwWDDvCAujOJiz0+jVX9egrdGBqA2GrnVj5URQ+Nj9GI
	FixvmC/jQvcjOs8cLv1qEPUP4icZ3X/lR7D9ysmgPQy7saI2XP99QgonOcp4JRmM
	rkcoMbiFHMqXJuPUTowd/bil/IRFLvY4UCTMW+up8QwncBWYcfk29sgr5fvHTXKA
	3E+qH0LSrQM1l36+ExijTQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0trwfce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:21:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57M8ae4M027022;
	Fri, 22 Aug 2025 10:21:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3synnab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ANyPU+44tjLX4UxGqVzNRx9Ulkq5pHCueCzOWZ7tJF+eqKlVYNG6kPulL7TITXRNloWQciq76j+2Ph1xs+ZpbIIzbGK9TiK4RzpS5momf780MWQ64oocv4FX9lsceClLVWhdp5qayLqGBxa6d5iEZewtH2Lyp1n8a8oTOTILRonAeV+DepAu8Wk9u2BrrMWE1+jo1bq3SqkYR8CyAaV7130Qd+MQgdy9l35NOF9vVt38Nqmsg2kcQDp9wbZkyl2dTt/eCJMCuz82Xa+BNTUsiwy7pWElP0PyjEOb/JzNZgm8UxYZbLRUsvxjUWZ1imdXLK5d+vw1P3odyY8kvIQhdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11mAfafIoH0UwJmaOyAEiYly7c4T605fIYz1Qw1XhuY=;
 b=aDC30HKc3YLuyLt7LnURp4GgDU7mb3LevtMi9eNQ8FkE1ax+6hYyvGNuxDdNdaW/1urI3Yjnq3gtYMJXZQseTgkqzBziXlOq51Q8Cx4rNblnf3lZDwUvdyFk2f2o1nZ9FVw050DDDwfCXyJpcwwcxxaT+Lr7fCHV+CHt5uO13ubVYY+lfISM7fBumk+bWBxstgKCzxJVqCy4odGb+ix1PMN4VGCTgavsNRl1dVMGgQzm2AjOnKfxf6CJoWsI8sPNllF1tOWId3moZpPT37a2yhvrciT5C3os3HfKKD1R2hKxnClLPY2uXRADdxWc86ZI0YMm5m1lIONpCG8A6sn2LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11mAfafIoH0UwJmaOyAEiYly7c4T605fIYz1Qw1XhuY=;
 b=hJpcTLLyTVNs6rTK4N+FxZ2pZ9t3Ak51EMCTUip+x1Z3d51hWuaLNACyCOdYWuP60lbBD7WMXEWC1UWrSiAcjidMYOerTjrZf46UwJMQ7B5Vq3qv9I1xxSqNz3imEBWu8IcrM+v69it4bwGvTONlKR0w5d4LsKK3CbyMiytI/Mo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4757.namprd10.prod.outlook.com (2603:10b6:510:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 10:21:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 10:21:48 +0000
Date: Fri, 22 Aug 2025 11:21:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 02/13] introduce collapse_single_pmd to unify
 khugepaged and madvise_collapse
Message-ID: <d8932d68-1c43-479e-8167-6ab7b1b92cb6@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-3-npache@redhat.com>
 <248d57e5-8cd5-408b-a6c8-970df6876b6c@lucifer.local>
 <CAA1CXcC-7MudjF06JaJQUvKkNh4vPHTTeoMDBE-devotyFXjkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcC-7MudjF06JaJQUvKkNh4vPHTTeoMDBE-devotyFXjkA@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0039.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4757:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f8a1b72-a29c-4eda-4dcd-08dde165b3e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGlPSFU3RW5aQnZjcFZlakE5aXN3Ym5LRUdUTCt6QnloT2wvZzF3RE9kcXQ4?=
 =?utf-8?B?WUtZTXMvcnprTWttNkduTHRlQ21Ec1ZXalpJcjdaUGlnQk9tWHE4bzc0UzlP?=
 =?utf-8?B?RTRMSmNNVENqeEJrRXB4dXAyRU1TdXM2S3RkaXFZcjM5SzFXR3JlcXNFYXNz?=
 =?utf-8?B?MFNuWjJxNDZjRHo0REppaHRnaFhteHRPeThWOXgxMEJWcUh5ZFJuQ3orN0wx?=
 =?utf-8?B?RGU5ZEZYRVd3bkE0ai9JQUlaQ1JsRDQ2aG1WWDRoNjZPcCtlSzNRVXhpeGN0?=
 =?utf-8?B?MzBEd1huUG1VZloxckFwVmNzSEgvWHNON0lhd3lQSHBBZnlGdG5yU0cxditX?=
 =?utf-8?B?dnAzMEJNUjE4OWp2dDlLTFZ2U0NuVTVOdUFoeXBVTDI2OEtKN3c4NjBxbUFi?=
 =?utf-8?B?bnhKdVMvRkFYQUtrWFF3aEZ3Q0xaQ2VwbEVuWlNMS2Q2SzF3dWo5Mlo4UU9Y?=
 =?utf-8?B?dHBBNGFHWDJFNElzV0FLL0d6UkVQNU9Cbmlpb085L2czcW95aTh4eWIwTS9s?=
 =?utf-8?B?UHNxazRLajhpekxOZk9jdjFVdkQwQXYxV1RYeXhZekZQQzVoVkQ3L2FtVjIr?=
 =?utf-8?B?TDZCYVhCNnprVTI5R2E3ZzVoL2duNytwWlhCamNIT0g1ZGo0MDBaYXFyMFh0?=
 =?utf-8?B?WW02WURPOWhrYzQ5NGpLMElLQjhtWnBndHdPajk1REtteTRkYWdWcTZORWM0?=
 =?utf-8?B?KzZJSU92a3o5L0w5ZkREdEhxc2NoQmVGRThTUmJxM24yOVdxeS8vSGhjWFZs?=
 =?utf-8?B?Ny9NWjVGSW0zTHdpU0JoQTA1WDdVT1pYS1daTEVVYW9NclFNcktRNVNQb3px?=
 =?utf-8?B?YVM2U2FrZDNCbXl0SHpqMFJ3RzhhelVzbmFxMmEwNXJla0psZms0VW8xQXJp?=
 =?utf-8?B?dkpzYVM2ckI5WTFjQ1V6VERLajBRTUc4d3czU0tVdEdicVdJR0lhMHdEa3d4?=
 =?utf-8?B?VnI2UnROMmE1blJtZUg1YXNmeFBMMDJRUkRtaUlqY2U1QVJjNGRWVm82enpy?=
 =?utf-8?B?dVBmV0hzZUd5N1NNMU92WVVpWTcvRHlNTXVoeVFoN1dIK2VQNGtFYVBaWFcz?=
 =?utf-8?B?bnBrY3hERlo2SWdQRHkyNUV6N3N3V3cwQjBRVlZzTTZhNjAvL3JyaExJS0Fp?=
 =?utf-8?B?MHpGcDlMazBuUTRlV25rUHlUdmYvU3RCWkJSOWpXYjRzTGlpTnFxOHlCVS9z?=
 =?utf-8?B?Ty8xQXhJdnNzSUxZWFI5QVRiN2pOVXZIMnVaMkZKaDUrQnNVa21IbGh2QkFj?=
 =?utf-8?B?a1lleXBoZjV3R0dURzU2bXlVWUhzSDdpMkwwajdZKzFxUUJtdkhWdk9UUjJt?=
 =?utf-8?B?RzE3Vmo3ZFUrRURrWUQ0L01lNFZTRkFsUEN2OHVBVEp4c3pNdWxkU2xXWWFM?=
 =?utf-8?B?SlJ5a1FPeHJyeDR2Z3BOUU9HZExIVDc5ZWdtelhtSXVYU3BCZXZqaktieFQ4?=
 =?utf-8?B?Yms1bUZrdE5yL05FNW5CR1VJKzNpb0VzdjcyNzM3TFoxaG5WSkNOK0Jaci8v?=
 =?utf-8?B?WHZkN0s5c01HT0ZjaEFUdW5HdVJPanB0QlM5OTl5TkZDN2FwcUhucnkrMGg3?=
 =?utf-8?B?d215WXBrTW9jeHJ1NHo0Si8xQnlycWt4TEFaVWdrSUVMQjI4NGo4cVR0U3pB?=
 =?utf-8?B?UFdxbTVIamlieVQ5WlFxaTcxdEl3dExJQXViQk84dnFndTlKT0kwd0FKVVRC?=
 =?utf-8?B?VXptTG5zZHNVUjJNTS9oaWhrNXA0RUFteFBJdWNyYUx3ejJhRnhXM1ZKeDZm?=
 =?utf-8?B?bk5RTkt1UmVpUm1kbHNJSEhCc25Ca2Ura3ZVVm5GTC9JS0owNlZWNjJBcXBY?=
 =?utf-8?B?UlNtTHB0UUZiWFpvL2RZZDhwbkFXemF3eWpOWUZkaTh0OTV2TUg0YXlTQUdU?=
 =?utf-8?B?VlpveUpEd3JhMU9vcXR1VVpqenFzR0pIaUZzYmxTUkNRb29jcW1hbGNOWXR1?=
 =?utf-8?Q?h4yjA6qYx8A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sy81MUtOTkR6NWFUaHdPYXZQazBrZk41L3NLQlduNmhhM3Uwb1UxZ1lvckFk?=
 =?utf-8?B?NHJZTW5oVkFWaHNPV1M0UDdjY1FFNVRWTjNoSW5ZT2NGNjM0NVVSdml6L3Bh?=
 =?utf-8?B?Wm9VVmtQdlVLRndlNWk1bklUb0g0eHkvMTdVVjhBOXpIVzdBelhhbmN0YTND?=
 =?utf-8?B?Ry9FNERiU3hNWkFLSHhwVVBoT2FlZ001UENBMGdBSEg2U2J3cnZCYTZVZ3Jj?=
 =?utf-8?B?TExYYUFqOWpqTmxXcDFUOGdZakMrRmNsYzgyQkhUOUc4T21qek1tTU9razBE?=
 =?utf-8?B?Y3BqMndtQThRSnEzTlpscVVkK2hONTJHWXdkRG5udkJwbWdTRGl2VnA2NFdI?=
 =?utf-8?B?dUJTcEg5UTlCbElURFZCclRqL3BtWms2eXp5L0JZZWNZNXI3SXhZdDdGQUFh?=
 =?utf-8?B?MEFxblRsMW9DcVNDbk9XcTdYa3JWQVllQVpnMS9odGhMd0pIMUFqaE5TbWdT?=
 =?utf-8?B?MUcybzAyWUZEZWhWaFgzUE1yckloMktBNzNXVzhEVU5CMUx6MHVRYjRQQitO?=
 =?utf-8?B?aml1TG95R1phY2JYTndBa3JyTUh2OFZxNDFaSTdNd25yeXREUGRSWkxURGM0?=
 =?utf-8?B?WE5YSkd3UFRLUTBtSGZFRGRiL3VTU0JoeENablg4V1U0Rlk1Z04wUVpLM2xp?=
 =?utf-8?B?QnJIWHRuQ0VhaWFlelBaZG5XMUwrVm5vTHhLa2ZWdEE4SDJtNnhDY2V0MlFI?=
 =?utf-8?B?Q3N6aTlLazBkdE8xU3hRTHpYTEgzd3pvMjJDVzZOWTZDeFRkYjg1SmtkNUVj?=
 =?utf-8?B?ZEsrWGpSc01qTFpZVnZyZXpWeU90S0VLMWIrYVU5T3N5NUJHVU1WVG9vRU1B?=
 =?utf-8?B?Q0JOU3BFMnRHVzV1ZkppMWJYNzk3ZE5oMXBTQ1dHNXVMYmdCV1pVOU0xUlI1?=
 =?utf-8?B?VDdBam9zYVYzMUQ1a3duakhYMEpldkdCYjVWa3lpek1xVkhaWjRJMkwzM0pI?=
 =?utf-8?B?MlVTTk5WeHdxV2NST3lUSUZDaFBxYmtabk5ta0JhdnFpTFV6d1E0NW5wOUFH?=
 =?utf-8?B?Z2s3c2owMlhpckliQmQxcVV0MktkMWhobzIzbElVSUI1RERkMWR4U0FDN3Jk?=
 =?utf-8?B?Y2svdEpGSWVnVkxqQlBFWGkzQ01lYzF5VlRFbzFHWjdUSm9icXo2c2xaRFNX?=
 =?utf-8?B?dm4rRWZlb0ZqSHVRK1dBN05XeWlWVWZGSHEwZzJmSnk2US9UWWdmZDE2em1s?=
 =?utf-8?B?eEZaN0FnMjdFNEUySzJhc01lOGJ4Q1ZSYlRLbDRRaTcrVis5UVkvSFBvcTZo?=
 =?utf-8?B?bXZHclRDV1IvYzVBZnVQZDNkMUNjelFNVzlhRys2MkhHZ29kY1FHaVRyeEts?=
 =?utf-8?B?d0ZNdGtvWE5yTGx0bWpldTFVV0tPVHA0d1NvcUFYNm9NSXl5V2FqenRNZk9B?=
 =?utf-8?B?SWxTNlNHM3BtM2xvaDV2RUNFZ3VTQzNERVRUWnB5bmZ1bEgyZzV0c3lGaUZR?=
 =?utf-8?B?b3Uwc3hXTHdWNlBGMTR2WVo0aCt3Uk5vY3B6cDA5dVp1OHc4czJFYlhsWFQy?=
 =?utf-8?B?cHlvejRiWmtCZVc4Y1lPU2duY2NDQlJUU3BjQU9DOU15eWpyeWJYUXJabWN5?=
 =?utf-8?B?SlRBNkZBY01sbkovdDdTMTVJeVJKNklqaTY5aWxnWnFvckM3YTZQUXdROHNw?=
 =?utf-8?B?NUlSM1dpcTZyZHpnTENtZ0hrakkwSGRSdU1xQkQyM1hYWUlSY25xdm9VdlpM?=
 =?utf-8?B?WHpyMkFpRGpaSlphT1AyM01tYkpFS2gwQTRuYmViU2svaFM1UU5YZ25xa1JR?=
 =?utf-8?B?Si8xbGp0WjVNNjEya2hJTkZWTkFla1JGeWxzV3pPeVlxdkcrakZyZGpZSDZF?=
 =?utf-8?B?ekZVMnU2SVgrM01wR1BaamFubnNkanpHMjkwOWJVL0Y1ZFdYUTNaTVF5bGVa?=
 =?utf-8?B?QzA5T0RpR0pBTDJjbjBISlA5ZkYrTGtvc2Y3Um5CbllrcDNSanFOclBFYW1V?=
 =?utf-8?B?M0lHSjBoaEVrNVFJODBvb2N1S1ZCNFN2cU5FMEN1eTJIWk1nT1JKYUFRNlBS?=
 =?utf-8?B?MmhrNVdnejdzc3Roekt5WlpRVXRYdWpzNStVN0Z1blBQWE1ZSFFHZGlZcDBh?=
 =?utf-8?B?aXJyckRXT1RhWk5PRm5jMGZ4SVBQZ1ZpS2xEZlpETFk5MlRxNWlacXJUaFpW?=
 =?utf-8?B?alRsUmRWQXNCM0VIenVvMW9sYURUaVREdkUyWTZteGNUS3VRWmpvZEtuSTk0?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	erj5DfRmTOez43GWHD3sCRS1jfi6OcpakdG17NYnbUVq5V8QehUzYxVlbSS2Jkdj2IX2vC4wu7KWg4/I5iMTZtX4t3LsLs8YbXFWS/kHS7lhdSoh0DCelBJ3ZNd5hXecmMOeC8mm/N70zqv4MInkWwffuiL4hA+ov86phhDMz+oYfv2OLpmFzf0AAZsfXCuQU9yLdv8mX70UsdX5wGiv9gi94ogzn9WK4xMkFFC/oehO2wPVDUzMM3YlUq9XWnCQuujFCoRsbZ1Zq53YHUkJAVW8Lom/8T80cujV44JFGL0D+N6VZpoqsD2XIvOq4uHsmpFNAwHEr1hSXOJG5NKBPq2yhE+0YlX6tqTgGvclJztUhAmNYlu4l6zxY1dTNHdg9MmR/s8kJ0B9A5l5TWH3a5QP35l55nSl+om99SC2Ghuy8v/9UedqxazhfbhTlE9G6XfLhCqV0JSIDWru5OxtVE8Vglj2T7+h9EASEl2Jc9HXDR9G/Sz+sM+JxKA4E8kDu8f2KlmL1xTmyJdiZ7Aet14iN3PBtv6YNjxKtvQS385oQZGLlSzHThV6q3iGy+vndGfmjYAP28dwqnzJpXUWplLIrOVfqCi9NY5HSQkMa/o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8a1b72-a29c-4eda-4dcd-08dde165b3e1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 10:21:48.4729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kIwxpID5wWWKI5sJTbyMyL8Cn+u7t252UIcYWk0xlWY9DGiCtqKIb9mzTCWPJdX5WQ+ULgGok2ImXMCdgdelJ7sFNxJOLz2I+6XrlvEOwGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508220097
X-Proofpoint-ORIG-GUID: 6hv2-DWRlttFuFXcJnXJYooKWYsBJXXG
X-Proofpoint-GUID: 6hv2-DWRlttFuFXcJnXJYooKWYsBJXXG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX97ZfaBoLfHnU
 qADlO4MjeApzsORmzAi805aiZ4FcOVOuJwXOPt4SyBUorMRUAzedQeuhuexnfceo8hNvb1Q2tBX
 dQOhujuFcRxFzvkMDZo9QDAnmrImJvg+Nm436XzEfWn++yYtAE/cQ/gfzPVIt2bdMEDpay7E8Wy
 aTp9jCLkUFezJIaQHFw+AQV8kYqZcKxcqvaWyJ5YNzh3srrLJmjaQRwBZTNY1Yki4JTX1QjiQIx
 GMJRsL3v/Xtb/JsvQWesD2HifTZlqhq5RxXgr9NBGPWdx+Bf/jsl9NYBT8UUGso2eV19prtMwpq
 Y76bMTdjcRdM/1tuOtOZZgvWfxiw89nEdB+/pD3uLJD1Nbv83PRdjkOU/5EC4caslrxIWtAaHjf
 AfIh5hmZecMVX9s5viow76oT4CAw7g==
X-Authority-Analysis: v=2.4 cv=Qp4HHVyd c=1 sm=1 tr=0 ts=68a844c1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=SRrdq9N9AAAA:8
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=9FmBLv2-W-RIL3hxg7kA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D60DD2000B
X-Stat-Signature: 3w5qzdfm4mhqfhgo9kbpr5kqxjkgfytw
X-Rspam-User: 
X-HE-Tag: 1755858204-420003
X-HE-Meta: U2FsdGVkX1+sNtLnL71tTlNoCNCu19xjEFPSQexQpJPaKIy+WBsomQWbRDcJpP8Ur8vKvu6wUvunvVNOL2yZo32v2J2FgEmWd1eKEOGFkY6i/IAvfphUT+MaNFAmlYiY+kUGxot3s7crlRE1wZt4UW4f/loFIaSunuf5wEW1+v4fPZqW+Ay51pKWYq6sg2mGpFP9WYcKmjuGkalWbf0lJ/9wikpw9vqHejlfw3KS5QRBjzu1MG/WJYkmQFxzRg8nT02RgxUCPZXQRhrm/atkVrKbGtk2ZGNBNfp50CarvXNTUsgQRGvSH+BVZrCrkB4YVVeXuPbxnA1lVV3mhUI9FgwgRdWpq1dvI8ck2TF9IpJQviw3iIYh8h/mHVvxhXeIdiOhZf0La800YX6ugMCK4Pc/yEqdqK+exeHKhsUjfZTiZdT+JcPk6ex8phoYopIaGdBYA+638PupGfdSCYBZCCkBh3swZN/xfWbELTsIPHNdpXAdHgl0ahMb9dIZGWjblW4LWPWC4hQGGrQumvc/kxyHBShcyrj+QtzoqtQhmxl2ocRkAXBWx7WKAVyr7RN07iMbzHLQq/6O5mXWdn7++coW+QprWrFOQQfpAgM2ePe5hkwWMwiAPxtzYBN4nbS40eSacWs8/+sQG0tLxGlnOjM2jc3OhVx1iHUKExcRhfxznbZgTEGOCWiYB8Nstrb6Bb4ZasY+67SEfwdFqSw1AhrjRtsz5eZcWrJQk8cgOCZxFtmX3KWXgal9s+BIyK2pwPcqwXuGAaOjffO0DOz0B5KIF5K1UgeCkLkcmegudmk8uuc1dW/Ein4JCc9/2ozc5pdfkmSHXRdfCKL7xWXo81BGZNolO+/Mt+es4rGPNWTCG+wIzMo2C8yZiIdl1vg7xZD4SPTT7fBKnKGHH3ILFRf55wyabs7twA3LwV3m+O25zQQWiL4I/V4dV4AZ70oLNQgNyWJqfCixas8vkwj
 7ZCO2y7p
 uedKXlybriprPPxBKwrHJ3bsWJxBm5N6emoCdInvO7gR8CBN5q8+HR/RqH1PgPlwtVvbyfe7Rrb0w8adeiE1NP1yL3UHEnSTOa/3LCD3JrhDC7BF2rOjkBNj+DU0HuDKzst/9hs9lxNEhln6MCsWdK3VXinGk/kinGy0GF/rVmWmREmG/JZpTexRVHGzEW3ZM1iDC9jrzezA9i23RVqUOOHuD7l1gkg3l4XiVb0hrgSYtA6Pvb/h0NPJ63oFZlzIDnDW6bbCTcJFwl4md866FpWkBp+2INyb6MVOjI5+GGRxW7NA8myzlKG0gQkCFLA0CDQQEbIgL2Mc1I1b50JPpOdqDmnON61vwFLRMsFLgDyJ+8lWD5TsALc9AGqIMBs/GS5MSNi27oEx5n+HwN5Un1/YLGCP1Vjm2utAEmRyeagPF3ybUysZVM8CTyTxmB74Hxv/xhU4umsX0ueU8mDFmBIJWtUE390PkN+2tuiDhostIBNUGuoTSi3Czr/zGIjeKze6xC0YOiLTW+Qbi6hB588B/39Zr6w4ObBXKaUEsV6V4WjJeXrNAwZU/CKoDnnp9EVyvlNh3RxY4gufmZESOXfSUhVCNJgKNqJDQaVMM/PSXa2Sz2tuDjtMe5raIxPUX0UOmUEgDKUjmpxYz4vuvfX+j5u6x2yinEsA0fbPg+1Q5dXJ8c6q6v9F7vGIzIIRtifGOpPoycxqXuYnpL0ckF1Akgb8pQycC4pkQczj8FGQsbm/+wXzBhokwdwkhwROl+K9rxRvpdRnboDAdE4ZvhPbtLjyFhuosB2+iFS0RztA9Ldsl7MrLaB5dq7FMBbB2Pk25ayGdt+HI/7nZjro2q/9OUu5Zzac/Nk2bElj3pYAZpVilhhQOcZr0W7ushTZB50NqdZuGwl4LNivGEFQZtmYsz5JLU5fHbPFY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 10:35:57AM -0600, Nico Pache wrote:
> On Wed, Aug 20, 2025 at 5:22 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Tue, Aug 19, 2025 at 07:41:54AM -0600, Nico Pache wrote:
> > > The khugepaged daemon and madvise_collapse have two different
> > > implementations that do almost the same thing.
> > >
> > > Create collapse_single_pmd to increase code reuse and create an entry
> > > point to these two users.
> > >
> > > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > > collapse_single_pmd function. This introduces a minor behavioral change
> > > that is most likely an undiscovered bug. The current implementation of
> > > khugepaged tests collapse_test_exit_or_disable before calling
> > > collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> > > case. By unifying these two callers madvise_collapse now also performs
> > > this check.
> > >
> > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> > >  mm/khugepaged.c | 94 ++++++++++++++++++++++++++-----------------------
> > >  1 file changed, 49 insertions(+), 45 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 0e7bbadf03ee..b7b98aebb670 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -2382,6 +2382,50 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> > >       return result;
> > >  }
> > >
> > > +/*
> > > + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> > > + * the results.
> > > + */
> > > +static int collapse_single_pmd(unsigned long addr,
> > > +                             struct vm_area_struct *vma, bool *mmap_locked,
> > > +                             struct collapse_control *cc)
> > > +{
> > > +     int result = SCAN_FAIL;
> >
> > You assign result in all branches, so this can be uninitialised.
> ack, thanks.
> >
> > > +     struct mm_struct *mm = vma->vm_mm;
> > > +
> > > +     if (!vma_is_anonymous(vma)) {
> > > +             struct file *file = get_file(vma->vm_file);
> > > +             pgoff_t pgoff = linear_page_index(vma, addr);
> > > +
> > > +             mmap_read_unlock(mm);
> > > +             *mmap_locked = false;
> > > +             result = collapse_scan_file(mm, addr, file, pgoff, cc);
> > > +             fput(file);
> > > +             if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
> > > +                     mmap_read_lock(mm);
> > > +                     *mmap_locked = true;
> > > +                     if (collapse_test_exit_or_disable(mm)) {
> > > +                             mmap_read_unlock(mm);
> > > +                             *mmap_locked = false;
> > > +                             result = SCAN_ANY_PROCESS;
> > > +                             goto end;
> >
> > Don't love that in e.g. collapse_scan_mm_slot() we are using the mmap lock being
> > disabled as in effect an error code.
> >
> > Is SCAN_ANY_PROCESS correct here? Because in collapse_scan_mm_slot() you'd
> > previously:
> https://lore.kernel.org/lkml/a881ed65-351a-469f-b625-a3066d0f1d5c@linux.alibaba.com/
> Baolin brought up a good point a while back that if
> collapse_test_exit_or_disable returns true we will be breaking out of
> the loop and should change the return value to indicate this. So to
> combine the madvise breakout and the scan_slot breakout we drop the
> lock and return SCAN_ANY_PROCESS.

Let's document in commit msg, as Liam's pointed out it's really important to
track things, and part of that as well is detailing in the commit message what
you're doing + why.

With the THP code being as 'organically grown' as it is shall we say :) it's
even more mportant to be specific.

> >
> >         if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> >                 mmap_read_lock(mm);
> >                 if (collapse_test_exit_or_disable(mm))
> >                         goto breakouterloop;
> >                 ...
> >         }
> >
> > But now you're setting result = SCAN_ANY_PROCESS rather than
> > SCAN_PTE_MAPPED_HUGEPAGE in this instance?
> >
> > You don't mention that you're changing this, or at least explicitly enough,
> > the commit message should state that you're changing this and explain why
> > it's ok.
> I do state it but perhaps I need to be more verbose! I will update the
> message to state we are also changing the result value too.

Thanks!

> >
> > This whole file is horrid, and it's kinda an aside, but I really wish we
> > had some comment going through each of the scan_result cases and explaining
> > what each one meant.
> Yeah its been a huge pain to have to investigate what everything is
> supposed to mean, and I often have to go searching to confirm things.
> include/trace/events/huge_memory.h has a "good" summary of them
> >
> > Also I think:
> >
> >         return SCAN_ANY_PROCESS;
> >
> > Is better than:
> >
> >         result = SCAN_ANY_PROCESS;
> >         goto end;
> I agree! I will change that :)
> >         ...
> > end:
> >         return result;
> >
> > > +                     }
> > > +                     result = collapse_pte_mapped_thp(mm, addr,
> > > +                                                      !cc->is_khugepaged);
> >
> > Hm another change here, in the original code in collapse_scan_mm_slot()
> > this is:
> >
> >         *result = collapse_pte_mapped_thp(mm,
> >                 khugepaged_scan.address, false);
> >
> > Presumably collapse_scan_mm_slot() is only ever invoked with
> > cc->is_khugepaged?
> Correct, but the madvise_collapse calls this with true, hence why it
> now depends on the is_khugepaged variable. No functional change here.
> >
> > Maybe worth adding a VM_WARN_ON_ONCE(!cc->is_khugepaged) at the top of
> > collapse_scan_mm_slot() to assert this (and other places where your change
> > assumes this to be the case).
> Ok I will investigate doing that but it would take a huge mistake to
> hit that assertion.
> >
> >
> > > +                     if (result == SCAN_PMD_MAPPED)
> > > +                             result = SCAN_SUCCEED;
> > > +                     mmap_read_unlock(mm);
> > > +                     *mmap_locked = false;
> > > +             }
> > > +     } else {
> > > +             result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> > > +     }
> > > +     if (cc->is_khugepaged && result == SCAN_SUCCEED)
> > > +             ++khugepaged_pages_collapsed;
> >
> > Similarly, presumably because collapse_scan_mm_slot() only ever invoked
> > khugepaged case this didn't have the cc->is_khugepaged check?
> Correct, we only increment this when its khugepaged, so we need to
> guard it so madvise collapse wont increment this.

You know what I'm going to say :) commit message please!

> >
> > > +end:
> > > +     return result;
> > > +}
> >
> > There's a LOT of nesting going on here, I think we can simplify this a
> > lot. If we make the change I noted above re: returning SCAN_ANY_PROCESS< we
> > can move the end label up a bit and avoid a ton of nesting, e.g.:
> Ah I like this much more, I will try to implement/test it.
> >
> > static int collapse_single_pmd(unsigned long addr,
> >                                 struct vm_area_struct *vma, bool *mmap_locked,
> >                                 struct collapse_control *cc)
> > {
> >         struct mm_struct *mm = vma->vm_mm;
> >         struct file *file;
> >         pgoff_t pgoff;
> >         int result;
> >
> >         if (vma_is_anonymous(vma)) {
> >                 result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> >                 goto end:
> >         }
> >
> >         file = get_file(vma->vm_file);
> >         pgoff = linear_page_index(vma, addr);
> >
> >         mmap_read_unlock(mm);
> >         *mmap_locked = false;
> >         result = collapse_scan_file(mm, addr, file, pgoff, cc);
> >         fput(file);
> >         if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> >                 goto end;
> >
> >         mmap_read_lock(mm);
> >         *mmap_locked = true;
> >         if (collapse_test_exit_or_disable(mm)) {
> >                 mmap_read_unlock(mm);
> >                 *mmap_locked = false;
> >                 return SCAN_ANY_PROCESS;
> >         }
> >         result = collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
> >         if (result == SCAN_PMD_MAPPED)
> >                 result = SCAN_SUCCEED;
> >         mmap_read_unlock(mm);
> >         *mmap_locked = false;
> >
> > end:
> >         if (cc->is_khugepaged && result == SCAN_SUCCEED)
> >                 ++khugepaged_pages_collapsed;
> >
> >         return result;
> > }
> >
> > (untested, thrown together so do double check!)

This suggested refactoring work for you?

> >
> > > +
> > >  static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
> > >                                           struct collapse_control *cc)
> > >       __releases(&khugepaged_mm_lock)
> > > @@ -2455,34 +2499,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
> > >                       VM_BUG_ON(khugepaged_scan.address < hstart ||
> > >                                 khugepaged_scan.address + HPAGE_PMD_SIZE >
> > >                                 hend);
> > > -                     if (!vma_is_anonymous(vma)) {
> > > -                             struct file *file = get_file(vma->vm_file);
> > > -                             pgoff_t pgoff = linear_page_index(vma,
> > > -                                             khugepaged_scan.address);
> > > -
> > > -                             mmap_read_unlock(mm);
> > > -                             mmap_locked = false;
> > > -                             *result = collapse_scan_file(mm,
> > > -                                     khugepaged_scan.address, file, pgoff, cc);
> > > -                             fput(file);
> > > -                             if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> > > -                                     mmap_read_lock(mm);
> > > -                                     if (collapse_test_exit_or_disable(mm))
> > > -                                             goto breakouterloop;
> > > -                                     *result = collapse_pte_mapped_thp(mm,
> > > -                                             khugepaged_scan.address, false);
> > > -                                     if (*result == SCAN_PMD_MAPPED)
> > > -                                             *result = SCAN_SUCCEED;
> > > -                                     mmap_read_unlock(mm);
> > > -                             }
> > > -                     } else {
> > > -                             *result = collapse_scan_pmd(mm, vma,
> > > -                                     khugepaged_scan.address, &mmap_locked, cc);
> > > -                     }
> > > -
> > > -                     if (*result == SCAN_SUCCEED)
> > > -                             ++khugepaged_pages_collapsed;
> > >
> > > +                     *result = collapse_single_pmd(khugepaged_scan.address,
> > > +                                                     vma, &mmap_locked, cc);
> > >                       /* move to next address */
> > >                       khugepaged_scan.address += HPAGE_PMD_SIZE;
> > >                       progress += HPAGE_PMD_NR;
> > > @@ -2799,34 +2818,19 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> > >               mmap_assert_locked(mm);
> > >               memset(cc->node_load, 0, sizeof(cc->node_load));
> > >               nodes_clear(cc->alloc_nmask);
> > > -             if (!vma_is_anonymous(vma)) {
> > > -                     struct file *file = get_file(vma->vm_file);
> > > -                     pgoff_t pgoff = linear_page_index(vma, addr);
> > >
> > > -                     mmap_read_unlock(mm);
> > > -                     mmap_locked = false;
> > > -                     result = collapse_scan_file(mm, addr, file, pgoff, cc);
> > > -                     fput(file);
> > > -             } else {
> > > -                     result = collapse_scan_pmd(mm, vma, addr,
> > > -                                                &mmap_locked, cc);
> > > -             }
> > > +             result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> > > +
> >
> > Ack the fact you noted the behaviour change re:
> > collapse_test_exit_or_disable() that seems fine.
> >
> > >               if (!mmap_locked)
> > >                       *lock_dropped = true;
> > >
> > > -handle_result:
> > >               switch (result) {
> > >               case SCAN_SUCCEED:
> > >               case SCAN_PMD_MAPPED:
> > >                       ++thps;
> > >                       break;
> > > -             case SCAN_PTE_MAPPED_HUGEPAGE:
> > > -                     BUG_ON(mmap_locked);
> > > -                     mmap_read_lock(mm);
> > > -                     result = collapse_pte_mapped_thp(mm, addr, true);
> > > -                     mmap_read_unlock(mm);
> > > -                     goto handle_result;
> >
> > One thing that differs with new code her is we filter SCAN_PMD_MAPPED to
> > SCAN_SUCCEED.
> >
> > I was about to say 'but ++thps - is this correct' but now I realise this
> > was looping back on itself with a goto to do just that... ugh ye gads.
> >
> > Anwyay that's fine because it doesn't change anything.
> >
> > Re: switch statement in general, again would be good to always have each
> > scan possibility in switch statements, but perhaps given so many not
> > practical :)
>
> Yeah it may be worth investigating for future changes I have for
> khugepaged (including the new switch statement I implement later and
> you commented on)

Ack yeah this can be one for the future!

> >
> > (that way the compiler warns on missing a newly added enum val)
> >
> > >               /* Whitelisted set of results where continuing OK */
> > > +             case SCAN_PTE_MAPPED_HUGEPAGE:
> > >               case SCAN_PMD_NULL:
> > >               case SCAN_PTE_NON_PRESENT:
> > >               case SCAN_PTE_UFFD_WP:
> > > --
>
> Thanks for the review :)

No probs, to underline as well - the critique is to make sure we get this right,
my aim here is to get your series landed in as good a form as possible :)

>
> -- Nico
> > > 2.50.1
> > >
> >
>

Cheers, Lorenzo

