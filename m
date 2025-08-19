Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DB0CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558FE8E004B; Tue, 19 Aug 2025 10:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509DC8E0007; Tue, 19 Aug 2025 10:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA828E004B; Tue, 19 Aug 2025 10:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3218E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:59:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFA59160173
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:59:48 +0000 (UTC)
X-FDA: 83793816456.02.BF4AC80
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7654EC0009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:59:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YVO7AxFh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aT+ukoHO;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755615585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m17iSQs0/kT8rKrHIUOADi+EQ6iqT0ClPzOwcG8o3cA=;
	b=VzLkgLXNo9WX19Ydg+zRbGUnXGXerpFguR0TenOUotlzopaUG1f2/T2sgNXP7AMaEs1kqo
	uFqby3xXQQqT87lITzDDqo31plBitSfvO3VYfV7ReGIo4ko1VPsDlhWUFI8Vhjylq5jwVW
	N/GRm9IXilN+jbkSqCaC8+huspe9w3U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755615585; a=rsa-sha256;
	cv=pass;
	b=o8GeDmB/gI39ix1metOE38BqEnnjjo956GYAq/LtorvPG3FyPUanmHYfd4EwvDAjXoH99I
	zEVdKbZ3YOPOfYFCU5+13F5pDSQAoh1X3hvAGr3D6jXVfbjfx90MDSeZpOxQRJpui293K0
	Wma6RPa+/0QEqlBrg3G2k8scL1VUYFA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YVO7AxFh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aT+ukoHO;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JDiuXH013867;
	Tue, 19 Aug 2025 14:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=m17iSQs0/kT8rKrHIU
	OADi+EQ6iqT0ClPzOwcG8o3cA=; b=YVO7AxFhCiMulSQPnu16pHevLJpxIS4GW2
	LuBBodTbNKD7fBawdU6DBBLNwkCrdpqBsAkpGII6TuLH/z8FH0jLqITVWi1jHtaP
	es+GijZQjtSXtvojTrR9DQvAK8EKyncpYSEXb3OO+SnFJYr8Gc+kp9rux+iYZv3H
	ccp5+PIgH3HKMzF1nfXGWBS+tIbo5KPzvwB14KOSJEzQWBqxq3IG2Jp+2k7QPOjp
	bGnxzhIzRuquS7DWZBOk3dL+gwgTy1xVcvHUknTcPTIP1XsrsMhLv+S7M5kKXz7k
	zjnGCR7CnYClDa9q7IhfRKd9YL+Yw/4RMn99AlrwpZp/x91D/8Tg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jj1e5jyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 14:59:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JEuEP0003450;
	Tue, 19 Aug 2025 14:59:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jgeaj5u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 14:59:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dt5vH0hZt77NfX3tv0wT8ZyGgWJ9ghj2hHe06Cp9bZS9+qn901isoYk8QBzY4UJXUFzade5yn8DG4jASOZyvL+hTQkrt5sUqi2n0UxFz4N90tN2Zfx3im1B0UbMKu0kFi9lI/DgSmYVIszK3nLcd5HmHnuhbGOaiDLaR8BbInBXmTbPKmN8qHlO7+xHQIf1NUgFSlp6u2AfUF2fLHGlWN9WQjdzJV2elR/Nuu0a/IGkHAarTWF/9kLqVQe1ik8n8ZMz2dC33mFJzAXfuuwo/R8xoloJWzvyXihnVxpLvkUuEU7f8VTPg/OIRAJpwIloesckU9LReikeFLPrz4VmT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m17iSQs0/kT8rKrHIUOADi+EQ6iqT0ClPzOwcG8o3cA=;
 b=U8oahXpinIJjutYwEtKFfMJrOS4LpIjdvauu8/gtyEhZOJIuIUtxZCQaDEYvBqA1MvPFyFgUmlWU+wvfcmXCfCGLTepKsyW/Qkx9QgqV5yqeAFpeC2nKVkzxZqCc+dQVnn52E7zIQ2VWMq4w8PIxx9LyOSUuntT+DUXnZDJPJKX7olAeo7axq5BHfjfvsCwgd0lK4/S9k7ZIgzImUGXhESYNC51vqrWFuIw/i/XZp+BMUaVxR3iInrEUXAxidGI5nUUGlXj7nSKvzA9YPpJxCwZ5frowTHGuQEUDY0O0D7cR3YvWZ+h0KPjWcdPC78by549m4CbZOAOBd9lUYkPI8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m17iSQs0/kT8rKrHIUOADi+EQ6iqT0ClPzOwcG8o3cA=;
 b=aT+ukoHO6iJE93qfeHFCv8aXP20xpEBxoCbpAKQR5pSgZhuk7zayZ9hOBOFOm93fSJD7bUVIKDcEkSNnFnlriuFDz70iq4AZPfR7xGcMRb7tp5soT2aU8353TgmpgvKvAWwE+ndcY/gknjoF8uu0lz8sdEH+QQe+acxQwU3bVo0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV8PR10MB7798.namprd10.prod.outlook.com (2603:10b6:408:1f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 14:59:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9031.024; Tue, 19 Aug 2025
 14:59:36 +0000
Date: Tue, 19 Aug 2025 23:59:29 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com,
        stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v1] mm/mremap: fix WARN with uffd that has remap events
 disabled
Message-ID: <aKSRUZ_AwnMpw4xy@harry>
References: <20250818175358.1184757-1-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818175358.1184757-1-david@redhat.com>
X-ClientProxiedBy: SEWP216CA0039.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV8PR10MB7798:EE_
X-MS-Office365-Filtering-Correlation-Id: 575a6fca-d628-4712-b715-08dddf310397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vH/nY2svyDMQelaLMSz8TzVridgWVAk3Ck5eM79sENWq3PSpPG73M6D3+NjC?=
 =?us-ascii?Q?c8S64aN3pLjAQBnsAfqwgg86hb9zVYOp5+9C//AXYbEp0/uI1PGVZo7WsImA?=
 =?us-ascii?Q?jbr0B5y/oVbZXUKuUtmQ9Yo2HazAJgrgrC+CzcRJUYxlD6+R/XLqlimPK54d?=
 =?us-ascii?Q?T/tayxR5rL3LK0FG5+hewLGOR6HEB/rmHAENxRS5TKbMECihBzuSWBv4Nl7L?=
 =?us-ascii?Q?hGOlEG1bnwFQuUFzsTDLnR/2Zj3j2dUxH/LybyV++Y8p0G0SYwhgkgNvjytk?=
 =?us-ascii?Q?x3keowkMuf8K3D8MSplHOUs2j6h9uxm8PgnbIPpPH+GEEuehAe6GAn+nop4u?=
 =?us-ascii?Q?QKd04VnBtOpvDXuSIoXKez+BCUHQpsEJYklnsouCJAYnLQJQCUSK1ID11dqR?=
 =?us-ascii?Q?FGytmctc9jxdCyo99NuOQyRB2hBcOw7MCnv85we4dgJFias0JLFvMPvNAoo6?=
 =?us-ascii?Q?hj6wnOTZ4iY6pa3WMUgVdlosd2P1y9bIswO+kb+vKeAd2UqLU0/oF7avAb02?=
 =?us-ascii?Q?yls4imL/Q9sKRp5QD1nMgWy2lDCS6k0j/pXmJLU6RautbyJZz4pZNedzjHuP?=
 =?us-ascii?Q?fweVFOYeyI3Drw9taDTfMMp4NBHR3umKd4d7Tg42IicKNGG1EVw0VWWHicea?=
 =?us-ascii?Q?cv0cH/60FXeMzCGSA715xC2SHMaIN3yJ7QYVKc7mSNU2URDKPh4Ibs9gFqTx?=
 =?us-ascii?Q?KaXtkOOJSO1CcfMBZcksd7wF52m5vw6yQrikTOQBU/Nx5LO88AuUBrltwuu4?=
 =?us-ascii?Q?FKkNWlnJgbeKYQ0voLQJUjZx3bGTstyu924sAK5aulmWby08dGgJonB1J99w?=
 =?us-ascii?Q?n7wbmDv3NIeiFvVzw5zCiOZEx7p9YtkJvqw1TwY7JYQUMdHBa0fpk5p0hCDH?=
 =?us-ascii?Q?XyNiM/5F3+ayhPXukTZggAS9VljYQCtItwpqXhhBRJvTW4X+kBL0Qit3H4RO?=
 =?us-ascii?Q?GBeKtMDYOJyJwz/JYvgeTlR1s4CP6Bsd4derCykgeZeGhDec3T4oE/YWA46f?=
 =?us-ascii?Q?16C9YwharnS3eqf89Ws6/b7sO0bvmfWsrNLzv26rW52l7/lo3jIwiNKptAVV?=
 =?us-ascii?Q?naKvssR37vqgsSz0xtWx3LU6I3RO69I8Kle9LujS+uuy15VchTXpcs8fNdPr?=
 =?us-ascii?Q?7ytRDAEK4f75fWWwjd2gbdbNbC/wsW7IJHA6r3rFPcWAFRvXkDt2Ea2ot3/u?=
 =?us-ascii?Q?AoeIAb9/SGK+Rhcu23OBk0UDSdqfaiF6iAH1/mQivl5kNCpIOGJMmJMqyJRe?=
 =?us-ascii?Q?ZOndNTCFG2/VgOF5yroqOL3OBIQSCqIFmbuwizXZGm5aH4m+Z78jomJPpv+j?=
 =?us-ascii?Q?lMa7R4xKw3wWVuFVp2pMSiR5rmqHwLCiLj7uhqBZ22JU5H4bbnM8DIj5p8sw?=
 =?us-ascii?Q?FM4ghIqxVUdJO5IjC3a0qXspUHB4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?frvtLA3T+jBtrGdKUeRhFcrtSbUjfgLQ5X4MWPiQb8GgnArrbBI8xKpaITEH?=
 =?us-ascii?Q?Ohsk9MxD2Cf7caJLAk6dfTNeJM/zj859MHlF4waZMjPoYZWid97JtiArk3FU?=
 =?us-ascii?Q?3i26uqmghSLIccpHmGoX6UXQnm+CJXu9v2VlqJi1sTBHnh8UchgSFqZ+YVB+?=
 =?us-ascii?Q?ffn4LRD3eyCuwynmLQwBRRclZC8/68nKZZLkT7U3pKomkYDa3c34AqppEify?=
 =?us-ascii?Q?bXyxBcgZ0m32Kd5q1G4ehVGAgw0kJZcB1zGTh+5LlalQfFTTY0MRTLTBHsTM?=
 =?us-ascii?Q?vGOmpUWK2eUUT6bTFytlaGC8FTO5yx0nnL1YQMtU1dwt6BKDS78GTnK5myyK?=
 =?us-ascii?Q?k7CtRqRf71RfaZR9SZJGXQEiYhvJlTAdLypdpW/t9TYZ0i6WLr9Ec1b/xF+C?=
 =?us-ascii?Q?3zNs9YYqBZ3eSlc5SjgvXbo/jHflI0ab8MkpfYhzeoWnE+mH08Ltxh0fXDY8?=
 =?us-ascii?Q?HeIfHx/VZxQuGWOh726Cb5A/9fJKGK+4VtD/aNgdC/t+oKThfgkGZN2tbBbm?=
 =?us-ascii?Q?mE28h91oQNJiKZhKJjc+B+MvJLUH7ElKF23aw3UW1oAbOQJNzZKNCvr7SRWQ?=
 =?us-ascii?Q?1om3S0hrlWlA/k7eP31g7H5z+YjZBxwXHS9kS6wEaOmH51pesfOvDhvHV9Ev?=
 =?us-ascii?Q?7s9nPEAhSRbRNfx2CJNq75FpmPl8eJsBfETu+S+OsnWoUVjC5XuOKx/6WKiG?=
 =?us-ascii?Q?Jo5hUPPA43ecDKYU3PNstQpEEtf8Hm1epU43DNU5+BWeLnzVYnnZ0otwnv2S?=
 =?us-ascii?Q?5jlTKdkofQ0aIJuwq6jzjGhG6bNKsEQ4l9hEOQVGqb+aSDhuJhW2QnOT0m0E?=
 =?us-ascii?Q?pCsLhCrh2YvT+zbjXU5KIrLDz1eb5QHI7jrdNc7z1cHukFDXeoAjm/wTP3E9?=
 =?us-ascii?Q?QLyZGKN3cUPub1EICf5Ye+Sl84he7ie5CHagcKRl2PV2k6TDMBHuP6hMkUYS?=
 =?us-ascii?Q?WxBo/RA52OeOKQrMSVwpbuw68lOZ/heIP+yIF13yrafxQ1WywniBIrf5lBM4?=
 =?us-ascii?Q?sEtgsTdL4Oe/11P8IpMN6fkPLT8zL2J1WLeYRXAqaFPaq1kEreLyAjKwTrnH?=
 =?us-ascii?Q?YhQBUWBdvyxbxtqsOIloc6SgoY94gOx98TOlPE9VqJzqV3hkIip/oY6aiin6?=
 =?us-ascii?Q?Ix8IVcleoTBDyC5PVwsl3PS6uVK2roTBS2sJlsqPxjEqQv+0Se/aFRtqmBq1?=
 =?us-ascii?Q?SnMZBKqLhVMuewLw4aWtquzP8uLSiMNF4k4zOzMMKSViq6+MJtJYx9+zm4l7?=
 =?us-ascii?Q?dX+fKye6CLYAIrCB5+nCCPfag3av+CGIEm9yKGxTPF5rtVlBf8eJ2UJInLG0?=
 =?us-ascii?Q?DEVtZC0gr0bN7mnDBXt+d+MfZd7+79WgWylB9d9JaPOEVUZ/4AADXaokx2Uj?=
 =?us-ascii?Q?4M8JmsS/MbV0vPWlPttlEBkK2JkPCxttT8L33WRAFqz2P0dxMHZpEMpOwXn3?=
 =?us-ascii?Q?ds2+KXBhN3AeFtd2tHni381NzsKrW7nOt7VDRsW+8FhZBzu+oJNCQEA4nY13?=
 =?us-ascii?Q?1jt14+VA86NDDT1tuYcZUKsRyG5ja5axbcAd7kdufUy3bRN7nnIxSoab9NF7?=
 =?us-ascii?Q?O3JvJ2oU9+5HKVxF3xpbTt8cXCyIenw0dmtRdo74?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+QjnZr/Ak3GoGlhkJE8EQOQyXxhXUUDmFxDZwdKKW9ACDyHKWTZ7nnh6nLSjybP4EzxDNENXr542ncX+R+011b2OvPsFtU1LNXQ5LrnjSwW/SIpxJPUEmHj4IqrN/Qq5p5Hgi0x7oL+2s626eWKD+VtTXNz3Qx3mij13jXCqmJTBn/EDBoF4RXu11ROJA2o+oNSH48dL8UI4luJ9PRDj9kA1q5LGP13DDhYXsGtvRxhzP5xH3A4bg0rKbO1IAGVQBP8Ed0wLCK2rQ9bmeKfh4K/gI+bGGg6cCio4y5TfcDXJlc2llGntQZZzjbVHGKPo2lhpXML2Lfv+6Q8CfC1WYxQ9UdK9GuLiPvhqnCth0IeLwCElcCSzzIm0BOt/KD+SK8cHW/6A0iyIQ8zJSfp+R/SGO9+IB3+PhW5YrpfXawtvbH/ZRDXaSdAHc4/OohLxYoG9abt9JlURpOyqEKtFDGexKzs1iyWy7opkE+Njmmb8QCY8UGx0Cz7tvhFn7rUaTW+mQ6Xs7Q/lkqaHtp56JK5WoGjJbMIbertE0YjH1qy+1uWiKLQNlHD4Xtjnjxb7cjvozFcGjR1WUzp0xnigSFTrYK/FY9L84b9u9bNscwo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575a6fca-d628-4712-b715-08dddf310397
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 14:59:36.6259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWRZ9tCEkfOd0+iKjSof6GxXqxDK+SZL5XZuCFIwtkAqKebMxoaWxm5jWLxBhvbHYzlr2AF3j8tCdum+NXVHXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190140
X-Proofpoint-GUID: 2h9_JwNX9eXauPSdk5fRGLedMPt-XAf-
X-Authority-Analysis: v=2.4 cv=dN2mmPZb c=1 sm=1 tr=0 ts=68a4915c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=hSkVLCK3AAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=j7-1BgRk78S91jMsn-gA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDEzOSBTYWx0ZWRfX1fWhc0rNkiyw
 b7o7su5gNbDFyXk/y1r4EV/KI3UyhuIfg0xiz84cSSdmStHfzmcRDfIZliggVxLXilrSfQ3Ligi
 CwqjWGhLDzCPFBGupPzCbvX2+6PeYN97pWFG0vdp1oZhMy3oWs5RzKeI2o0p3LZ1gCt4MszM1gm
 FdVJonKbkgpfkLg+IOFy6ag5fTr5MjmxUGEPWGV8z0Ow0UL71qaltj+eAXAuTFQUUsgbW6wT67M
 AXmIzPYwqPkCax5O/fs2QLdyf6rXY+RBqYrrrSduD1ik3coEPnPxgL80hmD07Egfftau2CNYABb
 hXbUyEO3LuVX1tfgyDCQzrfXgBP1OQY9q6CoG8OIpah4b2jGMXtcZO7dCpO/p4HtK9LSNVpy08L
 uKW3MEvY+p1fdI19lP9/th9BJyfBsRo5KqoOkxzK6bnFd62lVHbbP4yMogUTf+BWFtzoggd+
X-Proofpoint-ORIG-GUID: 2h9_JwNX9eXauPSdk5fRGLedMPt-XAf-
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7654EC0009
X-Stat-Signature: tj6i5tyj8g5yzzqnrrkj1ax6wbd157my
X-HE-Tag: 1755615585-177533
X-HE-Meta: U2FsdGVkX1/TFFGc2DeN8Su6sBxvuvQFck5tdrQkHsuZ+lhus6Yh2PxKXKLMY3ou276qK/UShaRCfrL7NKRII5xqobH6um1MRuJb7v3QK1TXLYXRgdpW3xY0sbWWR7oJgJijTF2VltdAPb2Em1zDSGLDc16XgZrcsXQyF0ayoO5v0dYNw2tJcXncCjLBE2kVvDNPatOs7nzcHjcRYjh2ylt5sGX+wUAzK+/CPD+50q3adYPvZfAzYwc3RZzJl78/xqyfWNafuM0PyoFbfpCf47PL8wEWwBlmVOTyQKfvDdEp6jPdqpBJ3xsQdhEQeZoRdjXWUe8mmtszFzi0l5hj29gQwdX/bSxhcTaQvlGtbGUXtG/ewBCXwJI6M3PCgg+bBoNEZB3XHQorJJtjmn6HtBNOW+7YIYDWIzuWNStoAdyVz0XD4lA40IVtz6NHW2GIwj7nzquNNxGWkfS0/2VGEvqg2P4CZvAvVppTOp4TKZ5TAPu1AYD3uFPMbPz6uRQf8AhnZjZgKohmNgre3I4hj9ufd2MLn+fxNgZvBsvY3MkHvhw/dRlrNzqYmY58RvL8ZhyTK/ooVbYvJ1dAyzJBpGzbKKRogx0buqzhbQws3a+fXu/ajkhJ2aNF3FTNAbtEpWA2WufLIX/++Fwyc828mS30H2sScSY4gHsb3q2m0/isg72RgOScwzP/KqJu6LdFZ4s/7hbvJaIwl5N4fPiQenash9laEWvBMNU5djTXGohp0bt0blziRk/34PA5WX2G1weOoz4Nwyjp+wwY0D2rSHR5ylqnQZxm6sBo2h3+b+mzBQd86NzXdP2QqzWoXpQOhTTa2hTsxUexUuFqu0M35NwG208ODgvchzR7VlU1v0lCJrKYQFEUfa2DeE1Zjt2A3Xs5w6nc+AQZbEpyNV7xImA8og4tmDo2A6vC2kCpCr6Sv0WgAmVxBsiZ+vZ6xWj62UTdRhQEQARNOtBArl/
 SM12Hfim
 gVz28CRUEyXMjHQgvivzQ/TkdmktFlAK3dxMn7QuFLvK6FzXJ5a/XSk5D2IXDsL5jJn3lC2sguYu8B4u90u6spOhjYcEnfYTxNRCQAMERBT+yxFgmYvtUkn6ZKecdcl7ueeJGtCNFVqLPahjOdRRTBPUMWOZnP8fAJMlniMSpevYqppIf48bV0/BevIz9ZHOzcjQLcabMqqtwXVZJYuXByHvDp69qWkL7d8KnWtw0Qm6reLLFUt2WCtDix0dSIpP9VcXFAsT3rqeOKtTVH3n2sl68IoqwQz1LtpZYF324+ogU3pmK5J5A5tgcfI2b/2N0296jK6Bj6a1XpNuAZ2LgLk46lU7ZLAMVo9N6DqKB8P6tIXTIizVoUiiT2QRjlF/g/LAtUxG/txJ9styuJi5RT+bpmqjhAY5BVYTjeggmOLOd1RnKHYYeanjPhtx7z7phx08BH1nW8r/XSpaq3nGlE264rJlnPMrVsbSIzbQUpREc5endF6UzGVhvhD41hSbGU5RmQvgDBIFm1bVHZHyDr9QGaSzQyU6Pj6dfNQuQufiB+UNE99C6PVfxgZKagifMIRloLGI3WdKQbOAcUIbTq4E9LFpSW8VriJQylCGHBweWf5zyW3UCNgAvgstJf91E1ecOVMm1vRbNk7xBGKScs+4ALOJT5zgn+JW/xWz76Xk8saicduFknfRMga9LqRIdwqsFsBvz0E0cF+itjddONQqb3F9R5DSRekaAK4TPA6K4hGMwIo6zUeNAwOZpS8rK4j5kgn20SehX0b+uiDrmX/c+yDOLoCNQBaE5TAxnQkq3UVAJBp6CO3ZuLR98m1DDmzf9rHLgxk2GBurzMdNX5x20Y0eGK/YmPTMN8mpc9fZhPTljOgcqhiGvlBE01NnFULmZ+wytJuYe1DBZy3ANs6sxhFF8DgKi3BaajuyWP30Qnzzs6Mf0xJCG1t9ZDeRGvoQuW3HFsr72pOxf5R47TODPYQSC
 JgLaGlOw
 XZReezNnko21DcfCZLLP28DnwRuoM380AGtrb6eSbKC5P3fnQlJ1Uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 07:53:58PM +0200, David Hildenbrand wrote:
> Registering userfaultd on a VMA that spans at least one PMD and then
> mremap()'ing that VMA can trigger a WARN when recovering from a failed
> page table move due to a page table allocation error.
> 
> The code ends up doing the right thing (recurse, avoiding moving actual
> page tables), but triggering that WARN is unpleasant:
> 
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
> WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Modules linked in:
> CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
> RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
> RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
> Code: ...
> RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
> RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
> RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
> FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
>  move_vma+0x548/0x1780 mm/mremap.c:1282
>  mremap_to+0x1b7/0x450 mm/mremap.c:1406
>  do_mremap+0xfad/0x1f80 mm/mremap.c:1921
>  __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f00d0b8ebe9
> Code: ...
> RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
> RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
> RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
>  </TASK>
> 
> The underlying issue is that we recurse during the original page table
> move, but not during the recovery move.
> 
> Fix it by checking for both VMAs and performing the check before the
> pmd_none() sanity check.
> 
> Add a new helper where we perform+document that check for the PMD and
> PUD level.
> 
> Thanks to Harry for bisecting.
> 
> Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
> Closes: https://lkml.kernel.org/r/689bb893.050a0220.7f033.013a.GAE@google.com 
> Fixes: 0cef0bb836e ("mm: clear uffd-wp PTE/PMD state on mremap()")
> Cc: <stable@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

Awesome, I confirmed that this indeeded fixed the original issue.

Tested-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

> Once this is queued, I'll send a patch to perform a
> userfaultfd_wp() check, to skip any uffd VMAs that don't mess with uffd-wp.
> 
> ---
>  mm/mremap.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 9afa8cd524f5f..87849af6682a7 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -323,6 +323,25 @@ static inline bool arch_supports_page_table_move(void)
>  }
>  #endif
>  
> +static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
> +{
> +	/*
> +	 * If we are moving a VMA that has uffd-wp registered but with
> +	 * remap events disabled (new VMA will not be registered with uffd), we
> +	 * need to ensure that the uffd-wp state is cleared from all pgtables.
> +	 * This means recursing into lower page tables in move_page_tables().
> +	 *
> +	 * We might get called with VMAs reversed when recovering from a
> +	 * failed page table move. In that case, the
> +	 * "old"-but-actually-"originally new" VMA during recovery will not have
> +	 * a uffd context. Recursing into lower page tables during the original
> +	 * move but not during the recovery move will cause trouble, because we
> +	 * run into already-existing page tables. So check both VMAs.
> +	 */
> +	return !vma_has_uffd_without_event_remap(pmc->old) &&
> +	       !vma_has_uffd_without_event_remap(pmc->new);
> +}
> +
>  #ifdef CONFIG_HAVE_MOVE_PMD
>  static bool move_normal_pmd(struct pagetable_move_control *pmc,
>  			pmd_t *old_pmd, pmd_t *new_pmd)
> @@ -335,6 +354,8 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
>  
>  	if (!arch_supports_page_table_move())
>  		return false;
> +	if (!uffd_supports_page_table_move(pmc))
> +		return false;
>  	/*
>  	 * The destination pmd shouldn't be established, free_pgtables()
>  	 * should have released it.
> @@ -361,15 +382,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
>  	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
>  		return false;
>  
> -	/* If this pmd belongs to a uffd vma with remap events disabled, we need
> -	 * to ensure that the uffd-wp state is cleared from all pgtables. This
> -	 * means recursing into lower page tables in move_page_tables(), and we
> -	 * can reuse the existing code if we simply treat the entry as "not
> -	 * moved".
> -	 */
> -	if (vma_has_uffd_without_event_remap(vma))
> -		return false;
> -
>  	/*
>  	 * We don't have to worry about the ordering of src and dst
>  	 * ptlocks because exclusive mmap_lock prevents deadlock.
> @@ -418,6 +430,8 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
>  
>  	if (!arch_supports_page_table_move())
>  		return false;
> +	if (!uffd_supports_page_table_move(pmc))
> +		return false;
>  	/*
>  	 * The destination pud shouldn't be established, free_pgtables()
>  	 * should have released it.
> @@ -425,15 +439,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
>  	if (WARN_ON_ONCE(!pud_none(*new_pud)))
>  		return false;
>  
> -	/* If this pud belongs to a uffd vma with remap events disabled, we need
> -	 * to ensure that the uffd-wp state is cleared from all pgtables. This
> -	 * means recursing into lower page tables in move_page_tables(), and we
> -	 * can reuse the existing code if we simply treat the entry as "not
> -	 * moved".
> -	 */
> -	if (vma_has_uffd_without_event_remap(vma))
> -		return false;
> -
>  	/*
>  	 * We don't have to worry about the ordering of src and dst
>  	 * ptlocks because exclusive mmap_lock prevents deadlock.
> 
> base-commit: dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> -- 
> 2.50.1
> 

