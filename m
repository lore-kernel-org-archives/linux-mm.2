Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8629D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 22:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEE86B0032; Fri, 28 Nov 2025 17:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6AA6B0093; Fri, 28 Nov 2025 17:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FFF6B0099; Fri, 28 Nov 2025 17:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6176B0032
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:20:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D87D2140768
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 22:20:18 +0000 (UTC)
X-FDA: 84161435316.14.6417B49
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 55798140015
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 22:20:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ShJekVWm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pMB3nSjD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764368415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxPkjWcsBRzTi9N/L2VNSQgAARBBtWNy1xjNOGpsmqo=;
	b=OI2Xdm3pODhg2+UFZYTEFFpa4iszmGFIyKx5zr04S5i3OV7zThvj+yGXUQOzkMdWndAoQ5
	55to6fvNAv8dPvKQdXj6FbAuUqLajwYvAk1JnV9GHncWDy3kEeEK1MbzHM4tRhXTiZYXlk
	DWnk3F/jkpyvcDV8v+vqbTh7y/u1NyM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ShJekVWm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pMB3nSjD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764368415; a=rsa-sha256;
	cv=pass;
	b=cj5OKKs9SYbXJeQR40HmTC/ilYem2h6gLGBe9BxBDrqyhPTxQcLn+ycc1E9NgIcA7i8iqv
	/kxv9LzxguwM0xYddi5H3qPzboFuIOQ255MpgC+zQ781ytgfPRqtWcFbxDYyVQxbd1RTkP
	rM6QECJ3laaKDmZgfK5UZReI0Ryxrgg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ASGv9li3815861;
	Fri, 28 Nov 2025 22:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KxPkjWcsBRzTi9N/L2VNSQgAARBBtWNy1xjNOGpsmqo=; b=
	ShJekVWmFidTdAbJDTIKa1m6SWMND1jrX9eNibOTTOeVj77eIZliBFfq//k28UZE
	4fck8uJNbilf6rPI6HOzWd9jyfXV73rPc8n24i+34QAslofzAD9S5Zf6JpREttUn
	Xl+5cBphp6lDd9rN98kDYryg2BipgwmAj4o+qAwTtq3QsyWjL5VwoPhzAGpGiwdx
	HJY3Z0NQKhoQ8quBbvcfi7RagVV9/GHJlqFRh8BrfgEH1IPJKcB+J40w5ju4P022
	gNOCFV+oUp9xab/QYfZvW9QVUuIa6p2hdSxubO2Xhb8Xtv8q12syb2C/ri1OT51I
	iEcZcbQIo9y6wOIouPf7jg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aq3j8h8wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 22:19:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ASJb81w030185;
	Fri, 28 Nov 2025 22:19:52 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010013.outbound.protection.outlook.com [52.101.85.13])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mh5a64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 22:19:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hpn8FOKnyMPmjKLDNVuKFTHrRCu5CtpNjmAJXvY8ye/xQHny/CRXWc2OkCY8Y2BPMbeKv8y5GgNSJrsFtKTvqV8uLynMHL6uXZRQeMR8YjkzTfcWgE0gOukFYV9WvaUgnzQJzSzXPCACbI45hBslJ1pkDC7uJ17aZG2O0E5/QC9AETfRmTGnLkKvNy1u/ZsOn0yTtW8tzrk7ginEmSo/LEKuUh7CoP3zFUr4ruRhzL1rD2kFHQ0uHRH3XsRwzkYR35Vg5o9Kt9dioEYn5DNarRmYLJ/ErwWZW9K1PfIE15nO6h4n6z+vDyE0csa7fX2Zf3JvGOKCKYhL2/h/IWh0hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxPkjWcsBRzTi9N/L2VNSQgAARBBtWNy1xjNOGpsmqo=;
 b=nS0SVDX3bpU6daQqtl7AlTQNbn/ECQGFFg+62vAItMGZuD1PZUQvgRyEU18bo0bJ6R6ABnyHOcANneB3H+usNfy2UgRWqdxdVnAyUVdcKKujlMqRSXM/v3eh7oR96JAPCCA+Fmyz3nKz8VQhNd8e09lj9q9WUpI7xYqLml27dMMbnENxxzYkV32F4m68MdwkJJ2eEaLDcEIlS4qE7f7+mepklaJZKgTtpBcD00Qfqbn6Y9X9vLNGRSnNr0zaUMsH+UskY++40zIBzR3Ap8qDRW7uoO9JDf/Hn51rwo6edZdKt9RzSZOt+Wt1gpQZKnutLO2gReBLAvw0Yuzl/J5PBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxPkjWcsBRzTi9N/L2VNSQgAARBBtWNy1xjNOGpsmqo=;
 b=pMB3nSjDcGMxiGMJVAcTIMA9DyhNzsSJ3Z0m3iRM4L2vtRjjlaePzI/RrOieFIIYrw8Pehc4DTzLPoPsV0L3ZxxzT/LTxHIkuHMoTMM6iYE5vOmy73F80iUpThAM7m7tfAX7vk6pLrCRseMNBkmI0knlhBNTFvJLFn0/eAl2L34=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 28 Nov
 2025 22:19:47 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9366.009; Fri, 28 Nov 2025
 22:19:46 +0000
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-2-ankur.a.arora@oracle.com>
 <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
 <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org>
 <87bjkq8s7a.fsf@oracle.com> <87tsyf58ro.fsf@oracle.com>
 <6d2605e8-409d-4b4a-9729-599dd2526b74@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>,
        "David Hildenbrand (Red Hat)"
 <david@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v9 1/7] treewide: provide a generic clear_user_page()
 variant
In-reply-to: <6d2605e8-409d-4b4a-9729-599dd2526b74@kernel.org>
Date: Fri, 28 Nov 2025 14:19:45 -0800
Message-ID: <87y0np4x6m.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR03CA0151.namprd03.prod.outlook.com
 (2603:10b6:303:8d::6) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 2424826d-08d2-4d96-ce5e-08de2ecc3ce9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sk42am5va04xUktrQ2pFR0t1cGp3dWFMdTNRUkNNMm5TcDlicXV6cjdBQ3Bk?=
 =?utf-8?B?S3dpRmQ1VnRzL2Roam5kOTlXVVEreWZZYVFGS0tFa0ZrMFBSUGZCUnZSYWZ3?=
 =?utf-8?B?UERxV3pXS1F6MDdxQXNjTUF4QkdzV04vZ2VJckI4UGRNVHNDYVE0WnArQ2Rn?=
 =?utf-8?B?eVFaR2RjNjBVd0FtN2RTWlVvSlVkM3ZCU3BDSGFUdytUVExJNmZ2Q1dnMHVI?=
 =?utf-8?B?VEtHYTJaQldoRVlCSlN0NWFzbTBDOENvWi9wWkZDRWNiaDJJZXo2SThnSUZN?=
 =?utf-8?B?ZUlGTDJyR1BWckhGQVQ3LzkxMnJUOWI3TWhacGxXaWFMRHp0T2VuaVkxMTBa?=
 =?utf-8?B?ZVhXeUxLM2lqUm5ZTkxmY1RBMlB4T1ZpdkFFclFVaWMxNVdqTHRtTTVpNlE5?=
 =?utf-8?B?dTJPUVdzR00yQkMrcnJnenZHcWZmUTJtM0x2Tld0K0FvR3FPMUdLKzRtWGZN?=
 =?utf-8?B?WTFTbnRJMmo0TlZld1ZEblQ4NERBYTFyaE9JdTB1RVIrck9qNEQzNXNJTm40?=
 =?utf-8?B?dXpVSHdjbFZnTlRvSURDNFFYcE1lV0pnRGV1aUprb0g1TGFaalhLSlRaQi9p?=
 =?utf-8?B?b2l0ZTl4VjRFdmxiK3hsazcxekFUd3ZnREJ4NnJaWmZGWEhzZllxeXNWVGxw?=
 =?utf-8?B?dmoxdGVmL0wwU2dBSmdMN3l4YStHNDE5b1Q5TWtSdHRiOWg4a2hmNDI5OUhH?=
 =?utf-8?B?eG10b0l4ZUxhR0JzWllJc2VaU0RNajBGS2Q5NUNHeW5sZkIzc1Y1QkJSRjQ4?=
 =?utf-8?B?QmlQVjJDREdTb2NUcVZodUNkOVJPMzA5SThpcTBpVVpUL2M1S0dzYndPUmxF?=
 =?utf-8?B?dFhzcWF4S0VlRmpCQ3ZkZmtEUU9jWkVlam9sVzlwRDhwcUh5cWNMMHZDay9z?=
 =?utf-8?B?ellsc2IvREw2d21DWDg5ZWFBNUJoVFFsMmVZTjg0b0l3TmdDdnB3dGx4UEpi?=
 =?utf-8?B?VEQyQkhVeThra04vbjFHZXFNN0tlaEx5NzRJbndtTzZ0SDNOVHFSY2JJMU1a?=
 =?utf-8?B?SnBsMFFuNjhWL0duSXk3anhnVWdQRTJXeEl1ZnpWUUp4OGZBVjZCYnI0aXd3?=
 =?utf-8?B?ZHJ1dHA3Qkd5MmpWL2ZVWlk2eUFuVjJ4bUZhaHZ6Z0YrMjBQR2FlMFR1VCtO?=
 =?utf-8?B?elViNWhyQWRISHRRcTczYzgramltUGI1Z3hTYlkzTzdDd3ZOSDRnVGJYdUNP?=
 =?utf-8?B?TXp3dmdGQzh0S0ZuK25rVGRxMWxmTTliaU9Oc212dFFUNFp6NkI0Y3dnSmxs?=
 =?utf-8?B?dUUydkFFeUl2eDFuczN5bE50UU1VcU9TNFVzSTllVDVMZHliU0lsYmlVWHda?=
 =?utf-8?B?bXRxOXp3dUxYM0FVSmorY1k4SGNHZGRzSHhXNzdMdHpNKzQvSFc1S0lCV2dm?=
 =?utf-8?B?dGJ1WlVzcWFWSUNrZEQwR3plUkZyRkZnR3JnUlN6RFQ0Ym5Ka0p5L0JlT3Jn?=
 =?utf-8?B?TzhRZWRBdlNWSnRiVGRvWXNWNzVnSmEwZlNpOWwvczBKUzc3aThnZ1RJYjd5?=
 =?utf-8?B?TUI2OXd3QUd1VXB2QkxUQkoyV2U5QUF6cmZKbGVJY0MvUzZBOThqQUg2SlpC?=
 =?utf-8?B?ckdEZTVNYk5FRHByY2pPL2thTE9RSnpCZVlxaU1rOHY0UzQ4cnl3SktOaUZ5?=
 =?utf-8?B?aDc0QzJrTVE4cXhuNGtNRGt1VVh6VTBvT08va0hwclFMQ0NwRXNjelF2UC96?=
 =?utf-8?B?UWxYak5HcHkxVjdkTWpScys0L2RxMUE2SUx6aVo2QzRMT2hCekFzbHpjczB4?=
 =?utf-8?B?MncwNThrTVJpbXE3a0N4a3oyMlhJanY5UXo2ZHNHN3FwNFY4WkcvOGNSMzlV?=
 =?utf-8?B?bTc4WFA2QkUxbGZqTi9yUmlHOEVYYzNCc2d1VS85NzE5RmZySzdPNGVEUVZk?=
 =?utf-8?B?SGdpU2pCNm51aitrMWdxMEcxdWwrTW9EektqWTlxT2NObFBBcjY0dWRlMkxt?=
 =?utf-8?Q?r0FcyxucyuHKnYWJLZxk2/QLbFw9Lw26?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHVqTFNDQWV5TC8vODdDdzVIWjY3NEd6YWxxcy9xdzB3dkN5U3dSTFFBdW41?=
 =?utf-8?B?cVVRR0RZUUk1WGhDTGdWaDlSSkMzL3JqbWNiQzcyWWNVWlhYMG4ydENXVHBU?=
 =?utf-8?B?Znk1TnZIdmNmRUZ1UVF0VEJ3Nnh6WU1oK2VPaWtNQ2lmS29qSDVvVXJXZzJ6?=
 =?utf-8?B?L1J5cEJ6Z2x5Z2FxY1NSdWcwVXRiSW8vbFIxcWNjMXlSUkFMbUhYR0puZTJp?=
 =?utf-8?B?TmNheWdKQjdqOWRIZXFzdmc2ek1YdEwxc3ZMNVlwQUI4T2hVb1dBSDA4SE5w?=
 =?utf-8?B?VFdob3JINlczbUJOc0Mvd1ozMmJmNDAzSlloR3R5ZVFoRDBFcSsxRnZkS3Av?=
 =?utf-8?B?dGtNcVk5dnFLTlRtSmdkdEtOdklMYTNkZDk0eGd4Z0RSc3pacjJ6SllwRXFO?=
 =?utf-8?B?Z3p0QXNkdEwyT3JhUHYzcWc3WjBYbklMN3hWUzJQRnltTzRMUzA0alFVYk9H?=
 =?utf-8?B?VjRiYmw1eDJzS2tHUnJwV0JjQUw4b1AwMVgxMzhINjg1NThQdVBNVTVjamJM?=
 =?utf-8?B?TzR6MDZZemxpWDlpTlN1bERWS25sdzA2TWZ2RXY3QmZoU0ZZRjRsYXZlM3lJ?=
 =?utf-8?B?RDhnaERrc0tyMVZ6WEhLcnJPbzY4TVA4S2JzcjFib3FmRDNPcVhVS3dxcU41?=
 =?utf-8?B?MGdnUkpQcVJIc25TNkVPSVRyRlpBTkJHd2p3U29nLzBtSDlXZmxPemVNQnRo?=
 =?utf-8?B?RGhrUHZQaGQ1TUJyM25JSTR3aCtLc01xcG50Z0RtRm1TU010REpGY3RyRWRm?=
 =?utf-8?B?c0dKUktXbG5BSXdOUTg3MUlITlo3L1l5enIwVTVHT0FIR0dTUks3d3RwdTZE?=
 =?utf-8?B?b2lmTTBLUVRaS3I2eGU4WFpkWUJxSnlUb2h4T2tLRTBvOUlueFFvOTQ5ckow?=
 =?utf-8?B?ZmtsaWl3UWNmQmR0bDdlem00bURpVHZwbzFqUDBGUDFTdjBUK0RIWTdXOG0y?=
 =?utf-8?B?WFZVK3h2dXZIcVlRa2gvTTZJNTUrMEh1N0Irc1VBVm9tNmZBYVBtb1NPWjhN?=
 =?utf-8?B?K1doUVdhWFAxR2dFODRvQzh4YkRjK2FXNVlCcFg3VG8rQkFoelpnR1BHcU9q?=
 =?utf-8?B?amdlNXVOZXRZMUY2emljTU5peVd4VmovZUorUGpNdG5YOCt3VG1SSDdaKzcz?=
 =?utf-8?B?OHpMTGs1K1FjWUdrWUZKdVQyNG1uZjBnVTNlRTkyb2NLWnA2L1UyM1Q1YTk5?=
 =?utf-8?B?Uys3Q0grM1lFa1JCb0tLMzY3Z3cxOWlUWFRGM1BjbC9KWU41ZjBhaWw1VlpK?=
 =?utf-8?B?N2lCSXNMVW8vY2VZL05CUEdSM3Frdm9nM3Y3aTIycHZ5Z2xvL1lwVU9vRGJ3?=
 =?utf-8?B?aWFUcUFQbDFSWWZSdWlPbElIRHhFZ1QzM3pNMXlzMWdJNDBkQUt6OC9kU0s1?=
 =?utf-8?B?QXlDT1ozWXVJQzJ0YlhUb09NeTV1Mjd5anY5TjhCbmJjNUR5L0MySE5kV2pz?=
 =?utf-8?B?VDh1NnFRSmFkWGFTdkZqVDZJZHphMTU5WjMvQWx0V1ltZzRCTnNwZTExckFt?=
 =?utf-8?B?angvYnRxK0ZiY29PMzcwTmFBZjFkeVZtRHVySmpzc2tkNUc0YmZIUi9XTEpz?=
 =?utf-8?B?QTVkSHlQZmlidHJvUmJqZWNDTytJOURGaERUSjlVWEVMK0N5c1dBbDdBRzFP?=
 =?utf-8?B?Zmc1R1JoV055MHhzMjNGYzFhc01vcGExK2R5ckxZRHVaMU13V0RibkVSTkRw?=
 =?utf-8?B?WTFWc2pFd083dm51ZjlsNlRoaXNxTGdtTUhmVUw1aTl5YlpEVjhmL2dyNkVQ?=
 =?utf-8?B?S1lOaDhzWkEwQlVEaE1NazlSTDViN0IyaTAwVWFod0JJTzJ2TGJ6Qms3UGtC?=
 =?utf-8?B?SThCSlpjcjc3Nm1iR1BraWw5cmk4Tld6bDZheVNhN015Rnk2d25Oelc4Z0pW?=
 =?utf-8?B?NDhDUGdSb1JFNFRqS2tpZkpoVGhDeGtDcWhndDBudXYrakNNUjBwM2tidVNX?=
 =?utf-8?B?dHZqMXNtd2pLWnIxcFI1c1hxRCs4bjBPamljdi9oZlIyVXdXTWZoUmRlSTlS?=
 =?utf-8?B?ZW9GS04vZUhQRnhMNktDMWhwbC9VdG14cXRycGtBT3kwUWVSaUdLY0NrdEhj?=
 =?utf-8?B?bWNhTXB5aXFtMmk3TnNWalJ3N1pRR0FIRDBSMFpvMnhHakJXdVNNck12T0dx?=
 =?utf-8?B?bHFNS0Iwb1dxcU5vcVozSCs5MHhNWlRWK0lyRVBlWlQrMk1VVVQ2NWs1bHg2?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XCaqboOldjyjse9kuKQhS4AYvAe7QPimPlUyuqTLS2pUw1ylDamfSTODWMbXPGk25GATohoD4DDAbFNM2W+lHIj7BVvYUC7v2VDzu8fBNgJkBupUcvBVHiTx2adamGvvHpejJ+aMyl9vuA2Epd9SNIv+ZgWRLwFeNbV5JuHPXfe9W0zG4gA4jtEwtxNLHnFBgSycWrrXQUUxilWcMc95OyWPhzgbI5Brd0ufJ2RSDYcDeLs3sWCOGc+bj+S3wbGbjXM+dip7JbuzmEP4BWLpEFbUTeUqNzWXO96JqqdctirsgQWbKY+er4TSvyAhN1YLqJ93YARF55CAiJ4zTIEljRvslKd6hgPGeWDYwH8ePMVS2xOJSQXjDU6mA0WsRcBwpG4qDkt1HDZPbhDk5lUVTr6priHiCbGLO8HR8GHa/Uzjcx4K5t3bxDj1O9qO8k4NxlMbeSMsogj0nQTfDGUEg5gtTF5SGC/ax8IY13xEXw4TSg+FQ2yLBwfdkUswEvhJIBEbmdmKjfsGh5uuhKYmzVZxz5U54PVez6o9nwF/EcCJbNzdT+W4PIsC2+eK0gxlwjL3D97z19bHI37cCqe0ub6nF6h0ht236zPntFPhYHk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2424826d-08d2-4d96-ce5e-08de2ecc3ce9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 22:19:46.4508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1N5PQQfS74kRkeFJji8Gx+Jt0cZZpzgphwb9cHeGwfHKmo5rTQkZM0U/rPMKRMunCNcKZ5LTt3jgLOKAdoBBy37DVo+0zGpnasVKqyTfis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511280166
X-Proofpoint-GUID: uTbfB2L47uQ7cW62LcMJsRjMDH7ixtUS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDE2NSBTYWx0ZWRfX8Hb7O9tjDYir
 fO9sLh5JAKOAgakmqvp3EcgBbLg9PYVJCgMPgKxXWBccDk0J/ytOMIZ2EIVwFGTk64WDK4FmfRw
 EUeGvXqebEiqFrncK721Zz+7pzEwaz8rYshY7CTrS4S2qs3yXYEWdtilM9ZYAAa24E1/H6d1wka
 6PUYlWoLOat8jq80XymZqVbHa4F0smMCLDXRa3Rj8Z5/hecLQEdjTFbiM20UHvR2nSeqIc55V0S
 icfFSxxwlKiGlyfh0WnDsh7lfonO2YviLeJTZoYaM7RzDJleoeV07z7aQKTvkpk/c5YQsVcgPsV
 ylfz46zjrqaXT1EIas4GFgDIzti0s9gL84Z+UvUoZBPAyb4xYGA3hVKNoTUcsMYArOiXJWmNEo+
 ROLvG+heN+9JBUBE2e4b9KuwdIySofqA2xZT5Xl0C7CBculkLUI=
X-Authority-Analysis: v=2.4 cv=JKA2csKb c=1 sm=1 tr=0 ts=692a2009 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=4SQLB1i8w6RP3WDb-SMA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: uTbfB2L47uQ7cW62LcMJsRjMDH7ixtUS
X-Rspamd-Queue-Id: 55798140015
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zoewsajm1azukkxzud5nmfn8w3xdfoh6
X-HE-Tag: 1764368415-947778
X-HE-Meta: U2FsdGVkX1/bbJqCh/skEaS6tM2KixZLt9zlFInSrG7SGOzNLu1lM8InoyCc9/x2ughX5ycNcQXBjCL/vohZyww29J+nmc2zZFaGH++3E602GuGHBsft6Y6w75ziFWmsM+CkTTGNVxTg9Sh26riEdGdg9RPdSQ7NJoQkgWbdeZnS5M79C6F4QVNPyj5uuQHzlMsbrKYw9dm+HB5Q5rv4Dfylddlu0F/iam0XMjI4AVmIaDa2o5bmVv26zE9nsWIE29jyaJ69AEViwaYMila3J6Yh4sUq08lR8gOmOrUZyYQKaOSN2zQlCia+wn2wV/wRDZJyKh6NMuy5DT3vtzdOHD+Ix7CHqSimTdN0kHt2QxBdAZpPocDu5K5Q9kft2rUg4ijAQrfJYqLCJveqgN07aQocY6BUR1oQqd7R+gOYmKkmTBRDiVoMvq4auKojlQuqRYP7DfO9WkrIVWhk4Ub6FJFJjl6xma6cdJI3zvaNlFxpC3eZYPFmNaR3MF8ke1QfqQonWmpM+q/+jfQ7FXKLegCoES48WX2vEYf3p/cESb9dggLOhYGXug7WGF4pxZ2LBqqUdc0tHWfXdi57AkXf2AuiP57YDFyODEsv+Rdh0waUwTynm3Hc84TugJoTqYxbfU+ii8t6qo2wDPV5JKpZG4bBjEm8DR+aaNwVNvtjdBVqyjMgy5hLgcrZf4QqOISjbplUyOzZtHYOkf0u3TQBjIWDrukh8E7REdnLe7mLc5gFm/kYS01SYUYgTpOWWM2i3LeQ2Gg1M/8p9S4HubZ8MAwR0tolZvD6JvnuKBQVEbyfZKF5nCx/tojpB4ejC8ceYQOYehx42FpZdqhipQWZ+UbG4U+nYAk+yYe0m7IuXGIO9788yv48V+3hRAHVXfyS3/ihn8EQUjmTrDL7WDH3YmMEyHsgYSY7wuCxDY9RL8r67+hTVefAK0LUyleKAoU8e/9knh9f2WVqs1JSntW
 de2xONPA
 F+7UrR9ZpU3Si/uORc/TLgfG/t7s/pdjIYeKvaTZy5olL5jN0rpEAYhglxKwfsX3IHGG3HTknfMIEsUarsUsM/CuWG9ZOvo8jInpdOoiDCALg5UeozdLBmvGGYvfgbSb11EpSMvIENyV/+c7cn0bwKRXtWVtG/GMte0QbeEvWyA2QayOW9/thMyqt4xF4F9Fmj8YJzs2nFaokRsaRrEktMyNTeMXxB/1PzYAtAzohpkEEZsHeb71cXqyZiYJA9srEb80Ta1zJEXypSJvg0z5LKaadXm5O1j/HZk43vvrANdMRPtb9D1Vu08hbyhlWtruVhw+mDPInMr28Ck6YHJm2oMJ1Qw4YM9KvotxxoOtnSxfGbkCV5UhHrYFjVt+emK34Zc1xEc4pvppSaHiVM/LDoVcJP0NUrN/qWZxVC6hY9XEhRMW2P6OtISRXtQVeysbT3cLUTLAERyWh42NGt8b04AImMKCsNMgMD7+eu/efwCLJpRBi4uleIlgTqURAQC7D/Itx6U08Z4yLaDt2rYbUTMh3Q91rg/az5rrJ4V/avexMMadE4QLnk0/nz8Sd0WHo5clPUnWdwdBB0A39e1YCw3RYgTXvY6wmEvZ8P3x0Anzw3/52skrhYBv7bvr+DXa16zngZ+zhucmpuLirWPZBE4syGL/aHe2nBeFyfc1UcWOpbwJUu8UoRb7l+53ZHnzpQwmns0QLnB5n5l4qW2Z6CAyu9nr+pgGAve1LJ7amOghchoyWFh7IdJEAqTcFiPoDKdlD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Christophe Leroy (CS GROUP) <chleroy@kernel.org> writes:

> Hi Ankur,
>
> Le 28/11/2025 =C3=A0 00:57, Ankur Arora a =C3=A9crit :
>> Ankur Arora <ankur.a.arora@oracle.com> writes:
>>
>> How about something like this for clear_user_page() (though maybe I
>> should be always defining clear_user_page() and not conditioning it on
>> the existence of the generic clear_user_highpage()):
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index abc20f9810fd..ca9d28aa29b2 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -197,6 +197,22 @@ static inline void invalidate_kernel_vmap_range(voi=
d *vaddr, int size)
>>   }
>>   #endif
>> +#if !defined(clear_user_page) && !defined(clear_user_highpage)
>> +/**
>> + * clear_user_page() - clear a page to be mapped to user space
>> + * @addr: the address of the page
>> + * @vaddr: the address of the user mapping
>> + * @page: the page
>> + *
>> + * The sole user of clear_user_page() is clear_user_highpage().
>> + * Define it if the arch does not and only if needed.
>> + */
>> +static inline void clear_user_page(void *addr, unsigned long vaddr, str=
uct page *page)
>> +{
>> +       clear_page(addr);
>> +}
>> +#endif
>
> WOuld be more obvious if you enclose that inside the same #ifdef as
> clear_user_highpage(), something like:

Yeah I was debating whether to do that or not.

> #ifndef clear_user_highpage
>
> #ifndef clear_user_page
> static inline void clear_user_page(void *addr, unsigned long vaddr, struc=
t page
> *page)
> {
> 	clear_page(addr);
> }
> #endif
>
> static inline void clear_user_highpage(struct page *page, unsigned long v=
addr)
> {
> 	void *addr =3D kmap_local_page(page);
> 	clear_user_page(addr, vaddr, page);
> 	kunmap_local(addr);
> }
> #endif

On second thoughts after the discussion below it's less confusing if I
didn't tie these two together:

 #ifndef clear_user_page
 static inline void clear_user_page(void *addr, unsigned long vaddr, struct=
 page *page)
 {
 	clear_page(addr);
 }
 #endif

 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long va=
ddr)
 {
 	void *addr =3D kmap_local_page(page);
 	clear_user_page(addr, vaddr, page);
 	kunmap_local(addr);
 }
 #endif

>> +
>>   /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page =
*/
>>   #ifndef clear_user_highpage
>>   static inline void clear_user_highpage(struct page *page, unsigned lon=
g vaddr)
>> And for clear_user_pages():
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index ca9d28aa29b2..b9b3cc76a91a 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -223,6 +223,35 @@ static inline void clear_user_highpage(struct page =
*page, unsigned long vaddr)
>>   }
>>   #endif
>> +/**
>> + * clear_user_pages() - clear a page range to be mapped to user space
>> + * @addr: start address
>> + * @vaddr: start address of the user mapping
>> + * @page: start page
>> + * @npages: number of pages
>> + *
>> + * Assumes that the region (@addr, +@npages) has been validated
>> + * already so this does no exception handling.
>> + */
>> +static inline void clear_user_pages(void *addr, unsigned long vaddr,
>> +               struct page *page, unsigned int npages)
>> +{
>> +#ifdef clear_user_page
>> +       do {
>> +               clear_user_page(addr, vaddr, page);
>> +               addr +=3D PAGE_SIZE;
>> +               vaddr +=3D PAGE_SIZE;
>> +               page++;
>> +       } while (--npages);
>> +#else
>> +       /*
>> +        * Prefer clear_pages() to allow for architectural optimizations
>> +        * when operations on contiguous page ranges.
>> +        */
>> +       clear_pages(addr, npages);
>> +#endif
>> +}
>
> Not sure to understand the logic. You say this is not expected to be over=
riden
> by architectures in the near future, then why do we need that ? Can't we =
do
> everything inside clear_user_highpages() for clarity ?

clear_user_page[s]() is semantically different enough from clear_user_highp=
ages()
that I don't think it makes sense to fuse the two.

For one thing, we would have to disentangle them again if/once CONFIG_HIGHM=
EM
goes away.

> At the time being clear_user_page() is used exclusively by clear_user_hig=
hpage()
> so I expect clear_user_page() to only exist when CONFIG_HIGHMEM is enable=
d. And

The generic clear_user_page() only exists if the generic clear_user_highpag=
e()
is defined. The arch might provide a clear_user_page() of its own (ex.
arm/sparc etc).

> in that case clear_user_highpages() doesn't call clear_user_pages() so at=
 the
> end only the else part remains, which is a simple call to clear_pages(). =
Why not
> just call clear_pages() directly from clear_user_highpages() and drop
> clear_user_pages() ?

For !HIGHMEM, the clear_user_pages() might be just clear_pages() or a
loop around an architecture specific clear_user_page().

--
ankur

