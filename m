Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40610FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3C96B0088; Tue, 10 Mar 2026 15:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2909C6B0089; Tue, 10 Mar 2026 15:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1483E6B008A; Tue, 10 Mar 2026 15:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D92E26B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:47:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82D651C30F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:47:25 +0000 (UTC)
X-FDA: 84531187650.27.2D74C2D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id D5B1B40004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:47:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="VssnrKS/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q75JetxV;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773172042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPy/fr9e4RL1jJY2VPkTeS9+i5m6Xj96VZycPZzQxFE=;
	b=k7ADghGjn6ecW9JPL1/N/CbEkGso+2f8AOBcfmn77l0PBbeUh6INkhhjU4pfhN6sj+t9vA
	u1D/tJ43NYsJ4DQYQ0us08hLDGoqXOopUTafbupgQ/43kd6KO8do4Xa8Uy7KOJM2V9YRC9
	Oh7AoDYnTxNE8Lbt4y+QftRMvxxEWhI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773172042; a=rsa-sha256;
	cv=pass;
	b=1aYrF8eWIX3CbQrOvtS29lra44hEp5Cj81f8xNvsFL6Mi5vgb/tng7vaJ0yVCH2LpPFN6u
	e4N1MaSsGuko4unnjex/+SgJGlR4PM+HPzSLKxnzhAMSuiVbIlIBDwknAd9i9ZuGJm/l2g
	pjEgWJXyOhEYx0dGfI1nzpBV4p8JkMY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="VssnrKS/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q75JetxV;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AJ28ep2773105;
	Tue, 10 Mar 2026 19:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MPy/fr9e4RL1jJY2VPkTeS9+i5m6Xj96VZycPZzQxFE=; b=
	VssnrKS/DWIgbNiNtQjKpPBLjhaRYSRq8YqpCi05i+6N19UQIc/4i0nSZqZls4kg
	aKGabgPsEt2OKJGGHVPstE/TGSko7tYP9XAda954CtnOY+rmrraDQY1PG22KEQEw
	cQ+pGUCm9MlfMbmyxvA4GFdRCCidL3c+9adALuxY8/MhUTHg4T+jx3xusiKjRFMB
	az45anj/BGfBnL7NJPqU/ZuFIUt5peQW4WOhzO6At5ITgZmzKvVDmNkR2tKBo1vG
	RgYLDAOHgvcFtdyYzOIh4LoT+itNx1nwh9x6TnLY0VlUPTaY0nAesJgNOH7zIUHn
	BqsSHT1FcMaK7JC9/2Xcnw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csjnukjsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 19:47:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AI4qfr020388;
	Tue, 10 Mar 2026 19:47:16 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafek64d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 19:47:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rol6xYmMRe1cO29mK4kZMhKyNNV3PdSd6e3w2QKwoIiCYr/8QenJMfxyESXCpI5B5yv4J413BVZDe4l+6fQrIdEh0WeOorHQpZQStmgo2ZIX5xSMqchKax1T9RhsdtphDECd8Jm4sLlSp6N58NIXnAJjMGuHIN6ycOCtiA3ngWhHSk7J2cMEFl7K5RHlvGmPgWGDDWijHYwNOjGsE6St1c/53Rpx1xXdlLwxsenkC9H9FDNI5uPe8oo/o5AgfFyEiPIgj3brMh5Qy8ZwJYgois3+4mPrUkeUz8r3Lt6IrnCU84JYK7IMcl9JrUa2jDI1TCBWD2z5xi9/nbukMzTN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPy/fr9e4RL1jJY2VPkTeS9+i5m6Xj96VZycPZzQxFE=;
 b=AVu0DGeTx9jV4BMgmU7XfttxhvkR+AV0dNM2QsXJ+LONNqxdFnlu8skyDk6p3KeFtY5zf2SCLhzamtrnV3N7ihMY973Mf38G58jGOqsGItAToy6gJSF2v7IfjsU8mYRCv9gUoa8iHxgLirQZ7edS7IT25qyGWbstN9F/Yipn0mjLbcJ+yItIdZq2hSbtmK5gN8lMpntBgV8We7xz34Qc1+gyBX8qxhjoMBms3OTyXLlrSNnv8M8id+i9o7eOI0sBZqNhLxAPTlENVI6dV94Vd/vc49RDlBvTqcez30WTRAxfYW+PURmsFojcLzM8/McBjksj9ITuJhwuBZfWpnM0Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPy/fr9e4RL1jJY2VPkTeS9+i5m6Xj96VZycPZzQxFE=;
 b=q75JetxVTqwRKR2ZCuE1tATHj1+CiRex8aN1yNU3vih2mNFeYhl3GhAY3rYKc6a99o/WvleCUdKZsX6VPivAsBz/LSoOobjD6/P1mLHlEh8MWiuU6sdlAIG5Lkdw5WKe/VZQpPU7JBZIAIojDA5Xr5gLPSaS/U8Sdq3nuUgrVm8=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DM4PR10MB6814.namprd10.prod.outlook.com (2603:10b6:8:10a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.25; Tue, 10 Mar 2026 19:47:11 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 19:47:10 +0000
Message-ID: <12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
Date: Tue, 10 Mar 2026 12:47:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
To: Jianhui Zhou <jianhuizzzzz@gmail.com>,
        Muchun Song
 <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>, SeongJae Park <sj@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Sidhartha Kumar
 <sidhartha.kumar@oracle.com>,
        Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260310110526.335749-1-jianhuizzzzz@gmail.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260310110526.335749-1-jianhuizzzzz@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::11) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DM4PR10MB6814:EE_
X-MS-Office365-Filtering-Correlation-Id: 69170765-f0f2-4ab8-ba80-08de7eddd155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|56012099003|22082099003|7142099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	G7MolAhr0B17RS1FDD0P0tlZwSIOjXbaEf6P/rNghCmfaKqwW1ggi5N0/6h78pe8t7ZdMIhDVRKnVgvoyyA8qebY7cqXa/YoWOVm7t0hmHvcvuCBHh3uLwqg8kC2vYIEWX7gJ9w5uMKaahiXI9z7by+ggllVR6Sxog/zAkWqFSo+v9M6YSBGIQ7qJShXF502e8UNu1ZfOP8T2alXwvrcTrbldW+bouQTpNnrsiUhFMBaKmCv50fGvgSx/nlLVmgN8NAXpMD60NnfVX1Ayyr+bGB+ylgHT0JRtmCa0Mt7Pm8bMkFfto2Lq32w9uKxF1sEnLEPtH2z5xolPHgSn/eKwV2jDcQ+XRFvmITpDqaporQ+Hx+psA0okhKDmqZmfkL+96BXLasLe/gibOdcHrCph2Kw3F2N3wtZnq7TBSQXP4VFtE5o5BA+DztJNQ/Z4OlX+6wonTBeO2KmxdQtZ1JTpdjaSAMzX4mbwVX0ttDfHraYNyU+lngmwuZj6azWm4AnxNwgJqrjx+zhBsco6w0g0fA9+qEhufJVGcU8qyRAtnyIfv8r0MohX0LzP2GOJ5INQB8HpkfAt0KRWxfSgSopI9i+IFbTarFfJzAHCSCEbVoaH2ruS6m4bly9RsRsbDd5an7+aqfcudTKrQ5VeyjueJ82mz1/Vb19ItcCONca64B5qzNv5sp9wilynepAu7hz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(56012099003)(22082099003)(7142099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE5kcDdZSVNmYXBoQkRJTFJ4VFBqT3NjYVlsbGpNV3RSZUdQUVZ5bkJWbFBn?=
 =?utf-8?B?QUhCbHZCSlFOZ1JFbXRBV0x1TnNWVVBtWDBBOUd3T3l5d25FZFNlNWFkSEhH?=
 =?utf-8?B?Q2xWNVVZc0FaVUEvK3ZkVEN3TTVBN3l4aGRDMzU5alM5SXdWSVJMWFVjQjdk?=
 =?utf-8?B?bW1pWXgwTE1Wc3hZK0wyK1g3Sno0OWFUL2hrRTExRTVnRWg0RjBFTDFHdVYw?=
 =?utf-8?B?bEFud3RoZCt2UzJtMnNYL1ZYMVFQSWJaMjNRR1VPWHdYQU1ZakExaWcvTnpr?=
 =?utf-8?B?ZHR2dDFMZVJ0M2ZyREZBdHF5d2U4Ulg0UjVBV1FZMHN1cFpKK1ljY0RQcTVi?=
 =?utf-8?B?ZjdodzNGUDI5SENmZGFIWkc0N1Fnc0UxQlJ6THZnK2NjOFBlREhYYjBwV3c0?=
 =?utf-8?B?azJlaUVFZzZ5M1pURlVnZDY3VXVQQ1R0YVNoS2NveThGRytOcldtamJQZGdr?=
 =?utf-8?B?MHpJSGpzMFQva3dFTXkycTVOUjE0aFpESURjdzlEcTZXbjkyNkFHa25yREhV?=
 =?utf-8?B?Q0Qzc05uUGEvRWVpR3lGTFNURG54dk5ncU80L2hwbTN3M0x5RmxQd091R2Nz?=
 =?utf-8?B?NnJQM2l3dXhrVm1UT1JpbmNDeElZdXBaNzl2S1ZvWmZqSmt6RlV4ekRDQWxK?=
 =?utf-8?B?TG5NQnZTWlVHWGlYWkZzbEcvdjZKUTBienBidGNqMWpzRGFpU3I3REtKVnJI?=
 =?utf-8?B?MXlUYUZrVlV5cnlaTjZsK1JEaThrT1Vvd21ReXYycEp3SzR6ZGhjeWJ1aGtL?=
 =?utf-8?B?WW1UanlxbnZIZGd2cVU2WmNSTkdYYjM2WEM4QTMzQm9DTmg5Slk3QitFVkFS?=
 =?utf-8?B?QmxkVk1VcUc5bzdrWjJ4MXladmhGVGFSVXBMY2pLYUtzakxnOE9jNUppc0FW?=
 =?utf-8?B?d2NWZmtZc0tMVnlVR3dLNHN5Q29FeHNlMEVLcitnTFpVN3V0UmJwbnV4NllT?=
 =?utf-8?B?cERXYlVIcVEweGNpVld6UnV5S2dCeVo0TGlvT0JiWC9LSEFSQzFScUhEbnN6?=
 =?utf-8?B?VU1vOXlxNFp4TlhXeWFON0ZYS09EZ01rNGtqdEVmazJ1SXlITTZLZjlIMUYw?=
 =?utf-8?B?TG9qRlVSMWRkbkZWVGg5dGxFZDBZSDZ4YXErY3gyR1VUS1lodm1NWko4aVZR?=
 =?utf-8?B?dWJUOUUwOGs5K2hxaFAyYXI0VmVRMmtTT0ZOZ1B1NFVDRy9ZcEpaZDQ1OHgx?=
 =?utf-8?B?ZVBuR2NObXROK056T1k3ckRmYmtRdHErcTRnN2xZRTUrWGYxOEU4QllRZEFz?=
 =?utf-8?B?MExvU3ZodGM5ODIyZHRRc2Fud08rZVVtTmdYK2VUMFYzd3NzQkJGaFEwRllC?=
 =?utf-8?B?MjV2SkRHbCs1YlA2cjlEeThqYWhFWEtGYkhYZVlWUjQvOVVRWE5KNFA4emFH?=
 =?utf-8?B?ZktmQWEzUEhBNGpBdi9JK3ZYYmtONnlKR2hPMnhwU2dxYUFaV09xQ2hNK21I?=
 =?utf-8?B?eWx4S0RpSFdKcUlDZ3kvUW83Q0VRWklPZ1NIV2RJRkZmMGNsaDd0SmlpNjhO?=
 =?utf-8?B?U0htdVcwQWlJaW05a2Z6dExHUGRKTThZY3NTZCtqbXJxNWt0R3VINWs1N2I0?=
 =?utf-8?B?Z1d4OUJVT3JTbU5CVjdNcnZWVWh0Y1BySUczbXNQaWVXYmpaZWhKUWh4QlpM?=
 =?utf-8?B?cDhiKzVON1FOZm9oRkJaYVRxYk1EUHFpWGttbDBKSktlSDNCTUY0a0pWbW1R?=
 =?utf-8?B?WmZVSDIzL1NQb1RNQ3VLYStkRFZiakUrSHpvOUVpK09uUFJCcldXZ0VaMlhN?=
 =?utf-8?B?N2h2c0lJeE1lSkxkNXBocTVubktvc3BvY0NHWVRWZ042b1ZjL21VK2o2a2hP?=
 =?utf-8?B?UjRYS0ZKdzFBRFhPSHdYRHBoRy9palVsNHhXU3FkT0lvTnFpRmw3Z2h4T2RC?=
 =?utf-8?B?c1QwZXpkVzBRQ0N2dzVWQzNpNkVNN2M2WGNYR2h1K0dWbUxNYzlmOVBENjlL?=
 =?utf-8?B?Z3FRczRTZXZ0bHI3cjRDUDF6aHZKT2FIR1ZqU042SE8vOU5XUXRQb3h3ZTZi?=
 =?utf-8?B?ZkZIRnpiMWpYaXBzWTJ6QitaTXhjSzQyTlY5QXdMYmk0d0k5aTdnYnNQUmRS?=
 =?utf-8?B?ejM0UzZYQ3I5cS9yVWVwY0o0M25uNktPbml2N3pTUGxJWElUczZvYS9nd3dr?=
 =?utf-8?B?T2tESXplZnhYYXJRWEJZY3U3TFhjL21vTG50eW5FeXN1a2dGMXpvMFREcXFj?=
 =?utf-8?B?Z2ZjUk9wREFqNGFpYW5SeVpDTTJ2eThaYUlZbXRBNEx4YllwWERyT2kwcm8v?=
 =?utf-8?B?T3NpRjBJOTNCQ0tsaVFyVXovK0I5NTk3S0RubTMwenFpd1lXczlXMVhWOG1v?=
 =?utf-8?B?Wjk2bUJaN0tYVk5mU2VBQ0h2YkxRcjJOZ081S1lKVk1mVU9aZ3c4dz09?=
X-Exchange-RoutingPolicyChecked:
	sr6gjiTd7YoB668Ig6Hhdi1EJMdyLfRSuUkmz53nWH6cnzngTEBq57/zbQpFoblWHqObOhNFQKTmJ2kQZjRKGdgSLdJEfcdMHgLoWs86TAbjzDme38hAtKHls2tveiWsIKfkf4CPx7sji0BC3x866oUb0ZGKAl038cxAREIW9I+zO5weKr9xKppFBSbvUJOxhWorXgq3RSunJVsGMZVV71heaaeTK3Y9JTjiD34cppPgbueCTOhtAjhgF7hgMB4IRK5kHBTewjCV92JIo/GxFKGvCBuRo20zCLUAfD4lCdPQ2lWYcwS+pV8BwFOjlDiaOgU4/e+LJRTt9ePJ4/NatA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8pwPVxfxAehs/WassfRIZptKVTQgKX1DgMVAtdr0nRPNLzYDobyj8A117c0CGu1/OYpW8K4Bdb1U8aoDBtN6FR4qSfs5y/NP9xNPKWDbbIpPMWKAB9Pk0xBUkw3FNYiG5XPaZh9S6olpGU4vZOjs0gb/Fsp2DFD44sFl1+YurjnmFchQKQFQS/z6FedpFLkNkIE51OhbbFcBoGmLyVRLDRxvYx1s/V9ssM8Ejbc+VTS24VmPr72PQDanWeyRhAwmKdpTXGPycFFVBI2t/NBOaxwTRwGMvjMrLpCliYZION5O+zOppGbxC7bKBYzLMBu6r/wk3syN1eVW97H7ICDjh03C4f9PM8QGoJgGO3rLd0QXwWWWsCZf/1Lym+EEdfQlqjCzhP/+F5i+GaYP32b2HLZMulbXlWnc3qx3mW0zT2Z1fwN+S8PUXL+ptxe6hsTRQh7Knkq/s9LXMWjrktNSZPCcR/NYqHiZEDznoZbS7eKgAIlQQIY9mrjZZDsXYI2lF63QqOWJNXZydCM89XeEid5ngqWl6I1DviqhSrooc6Lgbxq2rwkrL04JNpT61gn6MwMNZlhWdPd+mgVDSoUSngFpIFspqrohKtbPj44gI14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69170765-f0f2-4ab8-ba80-08de7eddd155
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 19:47:09.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODuUA/WiRRlQ5STpORFLkwM7lS069eXuL5UOEcedS5KNun12vxpYD0PZHWHRKWfL2RGgveYui3KHJMjkNNAjog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100172
X-Proofpoint-GUID: 6B34uem0Gwbe_0LB3q8Z7KTU7-oYobzf
X-Authority-Analysis: v=2.4 cv=c7WmgB9l c=1 sm=1 tr=0 ts=69b07545 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=edf1wS77AAAA:8
 a=hSkVLCK3AAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=21I3-wm7vnqh_PgTALQA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 cc=ntf
 awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3MyBTYWx0ZWRfXyyGFk48Xikkg
 QXzF6VXWVBH4EDzPnNaRdhXqt86H+16qhwmtBN4rVcs0fWFJvsxPVGql3aXlVLPY8ekRqJwTYSa
 7+S3RE1ziQYVHzU6+WmiPjvCoCXsqIS6uNED2WvPwzx5rxWZKXGxMJeZO4+qe4xnye31OhFhgvK
 stSkrK5EFQ1gWcLa+H2qYukTwiTu7iLF26rbsWEcOFSoIzfwSk5kKI7hruLiQeAWKj5MxFPKMu0
 VGsqpp8BF//DoUKup74xYP/ZTmWxsaDhUMfFx8byMzng5GvfPwN0p8cOVqO/oJ5M9oeIwhKikoh
 rwT4I9qjCEKxelT/qini7Lq82jO1O9U8/IQg8mLXqmFj4Z8GlZlLL0pX6z+XcVCr9KBcNuKdVmG
 1msWj4z9RQ7isNB2D+jCr5dPjk47IjpqcREkVdZxefvR2tDMTb20yltyyH8cI2OmoJ/0OKB47FP
 2AohhCbx5DqLpwB4BggbCSOnok20/v+JxjCKyFcw=
X-Proofpoint-ORIG-GUID: 6B34uem0Gwbe_0LB3q8Z7KTU7-oYobzf
X-Stat-Signature: qgf1omrarnkqka55rpmyksekukbqi8jx
X-Rspam-User: 
X-Rspamd-Queue-Id: D5B1B40004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773172041-736288
X-HE-Meta: U2FsdGVkX18q9DX1pDi/V/CNkzQZQimuMY5m1w/fd4LhElY5IbjPugnWJyyS30TJC28vKPU2IiE7HBuHX62ljgoQ+P1X0Z+1J5n2rTlBVsN5DvSRL3gGm14Xp5VJilxE6ZC8kABOApvWYrZBtzSBjDgiVIdDYjVokByfsSrJQcA9mgCyBYvgcykPKCn11uWqlU48d2KvAFoxyWcy2HVaDtN1ykrxTz3tq6kNvRRLerncDjva1t/CiwXpEHsQTKbOOt3QioUROpIl3UUxxI6Me6ClmBrbSIXcAK4d0SEZCacIKpcAUAqDuPrM/e6WTdfOmCA6XgB+HPChDbL8dD95PvOXrJqhtqAsRB4U8NXJX5sFXf3EDjJR6USEzpuFJi6JLI+Ov1XUHqc/csDgfyHmqxNbQFckqbHvi+zfzuq1Hg0qqSeNtV9PYI2+JoDrdcNK2O2bGu+DnKOkEGdEVIYkXGU6fIOlNpVQazYhzHdHx2Uk9e5ZaepsboMxiX74dxQDsRLJv4dyBMkLlr8aXh0kZLNa6nmvfF6gIdeJ0crE2rOvUYeqhdd/xXM24iavyGL/N8BkExMpm/tTeAj30SwTy/voHPCySQhBrO6Wd+4+jM6umSAiUeJZxLIRCDuFg1reBS51MHwo76YpDRUCOLDraionE9NfQxF2v9bpQ3EAzNFqyLoB8tdwEHjnJgmPxp8SXUWU0UdmXqKZwkQMd39hwqBX5Ezvb7QA0YpNVGgW8WWDuyHewzNuid2zI1VrdI/DcMPX/zkRjZmM/eDAKAEh3azGJzlEJRGfJNHL2IIy3OcbmV4CJBN8oPCJ/wR0wb4YSqMCOUJNzGeUWhFNOAfYY1br4IQ4A8CWH2ixQw3a4tBKoLau9ofi6UPvNbuyXggyrdU1CAzhhhVLdO8cDmyB5PLNc0AJD0+rst0xWbK/SH9cPunQ9e6AAb39FWmU+pgzcQvauTcvNMf7a3zf8A8
 dolynhCD
 ait7Pillgbk5cYzOqSS4FxIECRXdH0t0WIo5yN5lc6rLrnaLuOOf7IHV70B3lbEKWG8BZlclD0AWv8CB5BepYz7acH0Z6h/r5zRwJ67GeC95GfjLIjANfZMJVq5SrwDJbvsw/2jk9odmDQ7oNRFtSip3IQ8dG0yjkDcCFxfPpOob98434gHmMr+FBULmFULwEp6pA/dgmuuAYCVKdIwYLi78A43uKrEoJ8R8UWTvVAYdtM9equU1GjAGrMIaYfJzJM+11vToYprU07T+lCtqKX1DTgUuYpQdBiHlqj8PcwhLmLdvHZL4Y6UJ9pWFWsD4t8spyGsNNKSINrtWhV/Ppnla4iDvFzG58TxXho1Q3IIhus7SQxPWJ39ybGEp0vDRQWq1b1aM8qX2ZdiAlO8EC518ZSxr905RMrVe3vFvi67Hl3Bzk4Ultqq8EnIfcFOqxd4SG0Fa/mHNm6x9+04373HtEK0rrC3Zuk++7Jf9yrj/Ee2A6QpQAkUBeOQEFFNigXesNttDW9kbw8WAYmCjs9JIuFcSDsTTfZ0xDgxdcayfRtVTQrOLDwtU/I1tEgoF4yF2bsVnYwyD6q6atFKXcW7E59zQZ6nP8Pf7Ro5Sx138rFa2O9fkzNBNCu7sltkv8kL0q9cqPEwDHtxj0ruCa3l8CtTLoj+pMF/aHQc6NUnaKAUcZWDggBPOmEbhwDCETmzRE41u+1n97S7dnenW8xKcCZdcK84yFv+8iBYS6frhdTyQE2GbodCIGpY5pzx/jSKZvxnWrRunFejp8j6ACldO002bm6oA8Q/uTC0SeGp0DLpGD4OMndrdRT8c3UHRve1QR2r98YaHvRpIPdMFYp0U4BJEOYRrEAnjIbaBoAV9U3ZU3h2EG8rbI5ToTjtaBvMf/7/sWHbXx+PI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/10/2026 4:05 AM, Jianhui Zhou wrote:
> In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
> returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> expects the index in huge page units. This mismatch means that different
> addresses within the same huge page can produce different hash values,
> leading to the use of different mutexes for the same huge page. This can
> cause races between faulting threads, which can corrupt the reservation
> map and trigger the BUG_ON in resv_map_release().
> 
> Fix this by introducing hugetlb_linear_page_index(), which returns the
> page index in huge page granularity, and using it in place of
> linear_page_index().
> 
> Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
> Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
> ---
> v4:
> - Introduce hugetlb_linear_page_index() instead of exposing
>    vma_hugecache_offset(); call hstate_vma() internally to simplify
>    the API (David Hildenbrand)
> 
> v3:
> - Fix Fixes tag to a08c7193e4f1 (Hugh Dickins)
> 
> v2:
> - Remove unnecessary !CONFIG_HUGETLB_PAGE stub for vma_hugecache_offset()
>    (Peter Xu, SeongJae Park)
> 
>   include/linux/hugetlb.h | 17 +++++++++++++++++
>   mm/userfaultfd.c        |  2 +-
>   2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 65910437be1c..67d4f0924646 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -796,6 +796,23 @@ static inline unsigned huge_page_shift(struct hstate *h)
>   	return h->order + PAGE_SHIFT;
>   }
>   
> +/**
> + * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
> + *				 page size granularity.
> + * @vma: the hugetlb VMA
> + * @address: the virtual address within the VMA
> + *
> + * Return: the page offset within the mapping in huge page units.
> + */
> +static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
> +		unsigned long address)
> +{
> +	struct hstate *h = hstate_vma(vma);
> +
> +	return ((address - vma->vm_start) >> huge_page_shift(h)) +
> +		(vma->vm_pgoff >> huge_page_order(h));
> +}
> +
>   static inline bool order_is_gigantic(unsigned int order)
>   {
>   	return order > MAX_PAGE_ORDER;
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 927086bb4a3c..5590989e18c7 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -573,7 +573,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>   		 * in the case of shared pmds.  fault mutex prevents
>   		 * races with other faulting threads.
>   		 */
> -		idx = linear_page_index(dst_vma, dst_addr);
> +		idx = hugetlb_linear_page_index(dst_vma, dst_addr);

Just wondering whether making the shift explicit here instead of 
introducing another hugetlb helper might be sufficient?

     idx >>= huge_page_order(hstate_vma(vma));

I mean huge_page_order() is already explicitly called in several places 
outside hugetlb.


>   		mapping = dst_vma->vm_file->f_mapping;
>   		hash = hugetlb_fault_mutex_hash(mapping, idx);
>   		mutex_lock(&hugetlb_fault_mutex_table[hash]);

thanks,
-jane

