Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4737FED2CA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80F56B0098; Thu, 12 Mar 2026 00:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E0E6B0099; Thu, 12 Mar 2026 00:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4546B009B; Thu, 12 Mar 2026 00:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B90E06B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:12:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F6C31CC8A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:12:27 +0000 (UTC)
X-FDA: 84536089134.15.4741456
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id CAB15140010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:12:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fpGkfGX0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=z9F8lhAD;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAjHcR6sFhUKOXI/Fi+ldjI05nfo5FN9G9knVJHb8LE=;
	b=hDnoKuTMGrHyk6lCYiVfThhPbypuXNHcaibbsPyG2X/XotfbQiMH3DbJQ8GoWdmZ4nMR3f
	kDX+YTDF8iC9v8TXY65rup43ORwJJO2dYfvXy8s84/gupK3ZVzGrtApr0WhtYeAus1AGxH
	SSt6EDRG5B+s0BRPrsm82KxRi2Ae0xg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fpGkfGX0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=z9F8lhAD;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773288744; a=rsa-sha256;
	cv=pass;
	b=wBQQNB2fTVIV57axF4xTlSaXAHBL9phCLm+duIZ4oC8ryfEqgmnUXXfINPNV6T8Zq4yCLY
	oYu4XG62+diZPG8xnnCvbIA3Tb2kkZY6P6655eyOl2jVgJZihJ5KcRDJrMHuQokAPV7W2L
	lRrKqrLpTWp+LdrgUpGQ9sNDb9KZJhQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMO7JV3489965;
	Thu, 12 Mar 2026 04:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oAjHcR6sFhUKOXI/Fi
	+ldjI05nfo5FN9G9knVJHb8LE=; b=fpGkfGX0d5l9/y8UUpUK4jK7C2FGFdzyz4
	yjRKSRZbatBXGhYFQVZGAbWYzYziIiL8i3newzYTwijYPxusGiqsQCZorx9ZWP4C
	lBYbbKZEPNzVsgZMG+2J0dXE4uMucdR6kc5dN11Mzjs/3eCfBfs9mq24AlOSr7QG
	TWY1K6vyVMNPOpuOEqiX92dD0ZB8ONiCqnL5Ed0rr/SdTyPe8Z7MVuoJAZgl18V1
	IL0Sac14SdDtuW6nKH+Vx+1fTUIEBzpeVlG8mdOYjDLAkj3ffeFS837WTJ3MIB95
	ZlAuWbCMoVJtVBPi/Tev89It4W1oxuXdW+sZVZ78vm11dbItvBMg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4fg7d0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 04:12:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62C20kE7022287;
	Thu, 12 Mar 2026 04:12:09 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5jr3hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 04:12:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WENilFbNK9KdEo5FTLZvHQ1kCYCsRp2KZ9Fzgl7Ox+yADK+ry+ZHMn8f9rA2o84jSgR3w72Xhl9i+VY8qK5uAn1CfFE1I8pmrLgDtgRp7fz9hhEH6Ix+q6RtChnfYD+FlX42t357F6SEmOInlr9srakZgIPJEU/2sK6a6SR7BMi8up5kiHo9cejMwbwtIXDvSSJ2T7obKmfcACFuvL5zIGeVUC3P/W78hTf9xWtPQl+uvfUtz7KNNXIpq2KbzrZKVJ+58+8eslO+y8ERGbHImOZKRLJ79QJgX/V7x7Zw/eJ4QiB79AT0eStLHDPKS9LvAqgoYGiyhGjXTSmJkh3iCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oAjHcR6sFhUKOXI/Fi+ldjI05nfo5FN9G9knVJHb8LE=;
 b=zWDCAFDsEvmZfAZvUpy2UvA2QQ4+S8NwYF2TUByDWkmqstUmyipfDXNd3jZxKJjE4wzBlxnWN/Bs/esbg0JYP9OSaqN0NwRtiZW9KP58PXBOg41wnLeSAdtuQP+8xapAx8f/A6a9aJHuoCb6rSp7nO3Xio6cOQyy2MoxBhrb62DYuHiS1Kpffs8ZHbNUhfaP7jQgEkSt+GsOUsFix+0WP5M+44VnuMjO1N9qGtZoWKSOilNw9bCmOck7kEZQUw/ONGpYVX7qTuP1hgKvImmA2+ugjEShTTubUWva0SlRYsESQ+wHE1xzdrsSN18SyoyLx0s6wzpi0/M5ZLkNwQF5+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAjHcR6sFhUKOXI/Fi+ldjI05nfo5FN9G9knVJHb8LE=;
 b=z9F8lhADvtvW1wso1P2HdA+ZVe85J/p8qiAMhljVUBP6N7TQCg8QnZEmGk+fXANgMPJWiIl/Kz4JKzlLwOQi3jYPtOu+MFhod1sI877olr2fy5jXk6tSHTjZ5T8KG5c4VcELTFBC90Nyv1BkOXTSkVPw41wgyoPXhUUvYtsBOzs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM4PR10MB7402.namprd10.prod.outlook.com (2603:10b6:8:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Thu, 12 Mar
 2026 04:12:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 04:12:06 +0000
Date: Thu, 12 Mar 2026 13:11:56 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        Hao Li <hao.li@linux.dev>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <abI9DKxuwl_4Gasj@hyeyoo>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
 <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org>
 <aapeVb_L5zohWRRe@hyeyoo>
 <d5cd4eb4-1703-41af-9c71-842ae33edbdf@kernel.org>
 <aaqq7YmUcOht3GWH@fedora>
 <abDA9UrJBT1wXh22@hyeyoo>
 <abFA17ZmsW6RgcYI@fedora>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abFA17ZmsW6RgcYI@fedora>
X-ClientProxiedBy: SL2P216CA0179.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM4PR10MB7402:EE_
X-MS-Office365-Filtering-Correlation-Id: 70ff047c-e491-4da7-4416-08de7fed85c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	iKsB3hmVO/N5+l9RDJ1t5kfqIqQ8UhaZ494eDDBmCWYoU6bLFXnffuhwzThOYSBzEsJaC3+KHcQSQ062iC6fRZiy50PtNQtj2Io1VHhoojhIQdyRiSmzhCxWg9ebQ+/1hRO/uk6Qlt39lAjuRNJVp1WtR2rVf/fEOgxHAIc74m/P1sEcSTfBZj/De+Gv6v5En0Q0c15G601424epmmzSTxTwVqtcYntcClwE3LjVs18T4f8DfzuQGIAsM574De94ojjootmHaDEfAWlq2Tw9hTDZOkwKOnMFIJf2jMFfpTCJeG2iYoE0aRSwIV3FqZ9XYABIYeO+vNOsvea6O9XuF+/4YWPEQSMqyBwwXW4qzUriivOzH24V3ZrYKuv83UxppIARA9hr76/h+Gwdpk3HD+mgSOtL0D24WnEgVU0cXse+bWgpvbR6W6NcNfiuK3aOfaRHNrgq8+ZdOXWZ4p7zDN3sYt3vapH0rax5SYP4Emv6peIPWMaHxOhlCrJ1Ht0pQuvua1HzzbCZS73WKCvWI8ml3IpP7efAOerSgmtcLRspPAzFp5OsKT29Fcjv3M562qM59AP6FVRB3USNIFNj9obkWzKhdHT2Eh9vvLT8F0/5lhhyE60NC6L/J27Mt+flFz6z7Y6LHVKmSC2lCIRXLUb0AUFOUQ3ATgwfWNG76jHtzYaZNot5R6osNckQqYioJrA6okFJQpdFbaGcG96jnPcPhN90+6Rep9/q3NL5s6A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AaDVJCXHkEGf5+ToY96gviYNwfrf/uPzCX1bSHayCpGHHTQw+W04pSB0aB4e?=
 =?us-ascii?Q?/OetS/tRkSu1jTRT/EaafVaFCOINZiS08VXEOnd/7nBunqa76trRJStqcdt7?=
 =?us-ascii?Q?kkeg8bs4NLeFvRxQuHzP70JbXoOnvfPFtz02azQIu+x1u/5SQC1CGBO1CYxu?=
 =?us-ascii?Q?SlQ4zJ+NwhWwGDluA3HNLdalt9kChuLvZkVmhXoN+M4myC7tTCwyoFnIAhY4?=
 =?us-ascii?Q?9TS7WH1Hr7vhx5PMvZ4ypkdgcpKFrmeG9O4pB7UuM90c7/l3j9buf+9ea9py?=
 =?us-ascii?Q?ss17F89JqTm2NxmtBIuFE4IJxNjP7NwgflWI2/y+GGYVKYZnN/NSmMRMbIv0?=
 =?us-ascii?Q?VIYm33vKgTbQZpCM5tGLyxfKKEkp8buXh5PDVuezP9xKWRfr5jlUmb2NKRxV?=
 =?us-ascii?Q?ZS6efSsv5P90CBJkkYwNYCzKk2OuIMqN9fLMOR1rMac2b+BxU1FhxHTv4+2C?=
 =?us-ascii?Q?dkwYWYAtQTIgMVsTie+4E3jmvoW9Q8rc53dpLvm/4X7O8DFvFKL5RP/KhQmt?=
 =?us-ascii?Q?LLOXeswUkkTSFyh4fqiNg4v2HRBFhteqHhtnmKwYfLL0PR3tIq36oU96Sk5z?=
 =?us-ascii?Q?SAYJMQrUa+JI9OqvkiaFj+7S2kV1rWmzuCq1llMcM6AYw2HynMEKPiWir+At?=
 =?us-ascii?Q?9OaR6fUYX4POAuFtElqX9b1sfm6/DtDIgMVEfXtbwXE8Dm0JwrFdXxJpumuL?=
 =?us-ascii?Q?jNUE98sGbyYQmr6hAY6CchjsPmm/WRwfoAHTZpwPrJLSUKfwB+H90R/l75hT?=
 =?us-ascii?Q?12Zv9HhJYUVxrUd1IrUCK8mFd32kWy+fNguMqRxm/zAMXhsSTH0w+nFvSYym?=
 =?us-ascii?Q?RWK1XEgiRE0V1BQfz0A+WXtGrCdB1IRkMMPFv276wxGxqIbbMc4iaqUO37bL?=
 =?us-ascii?Q?JKxHAoUgOYDpr0L+7txwVtB5CpJtDAoB0MSouOb74+2pZpt1ZzYjMzlRwVhW?=
 =?us-ascii?Q?wK3GvYG8unAcIRFuWSzROwJlIG+ELB0/ZmcpbftQJtjvot08F+sgbHBdoCfM?=
 =?us-ascii?Q?ptFQv9kdcg/7MUxRtyHwUdQflsAkpJLSRPi5I8F5tiMrkfA1xmhC7uEdkZvz?=
 =?us-ascii?Q?tUe8/MVJTylsYoCSgWOGWvaCyNkQcvzV8vEe45cob/F55xlGwDNcP4suGubU?=
 =?us-ascii?Q?135DFxj6Rb6h/gquJDPfGZen8tjE3X8LBrdmGHMS6CEiygD1pKRXE155exKl?=
 =?us-ascii?Q?cmIKp24+2AsLN37X8a0kPcalXlupt1Pmp7dVf6Yy6mTmr2zj5swZtE8kWudO?=
 =?us-ascii?Q?WGvbZnYzxQCDV5ydn3pv+rO35JNp4C9QBHP8/5rhGI0tKqxGJl+H22gTc7Lj?=
 =?us-ascii?Q?/HrQma44sUPYayYeNI7oVth0985QjKVips4ndWOeIKMPBhoZkwhZUy3MZK3f?=
 =?us-ascii?Q?1bgmBSjPgLfhhtafdVxqXBpz8cwbe95v1G6YYjelVk1c79NYIV+nn/BG6jBJ?=
 =?us-ascii?Q?k0lIP0TqMPLl3Ko/ihWYR+ggCZVGxDulaaLwhxe0cem+1r022NEs56g/A+3Y?=
 =?us-ascii?Q?P2E4mAnwfxqDHVco/wAZSfaQ7ibrWE0Ggg7s614HtFfY/qleXROv0MwkbRfS?=
 =?us-ascii?Q?6cuDhXTGAXpjDF+L9SNEGfy25ti50WoVRr0LgMatX/J/B1f0CXITuqic89eQ?=
 =?us-ascii?Q?QFDu9kYqV1rZxd5HLC7j8bGyFWyOlpEmWkppdtPmAgyswpxc0gsjQbvY0eUz?=
 =?us-ascii?Q?h0FBK2zF2C1HvmKIPzxpiDkrIrb9aiU/hZE0MXB2yLC+x6dqrf30AELdpe7O?=
 =?us-ascii?Q?ahEnmbDJVQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	tqRy9X7tIXdgRLcZwLDVYPywvtIOQqVsg0aZVQyYrUUnHhRHxQFmU/Jz7/oKoz+nziXq46Nk6Gp0So25NtjI260KhLJHOgSNsTjqSQwRaR7eYG54vKKg4IRzn3wZY52cryK4wmZQAcE/m6ha2K2maZFWLxWNn1pX5a+0E0FqcuI1DidXLDeSjp30a3JhNJdoWMtXG6KspTObPuuUvLNiJCaHlRh7f1pynHAwS9AGaKz5JCFClB//ZK6xq5U7zQ79un2TbrAvdzTNiSMyApzR8Z7LU8GhbA2w77UymNKKlRVVqMejZLr0wBkqbBls0NwP+Oie5NnnILXMlR9GPjib9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	65PFmum3jzbFCL/Mi2ky1zk9nK8aTfyjnm7gfBzsiCclVwnum2HvffuLE/BJ3kmP+ZuvDu6Rr0jCDV+S8ceX7W8JEj+kZLV9M0XkgR16a5SeLB56j/Eis5H5WXy3wMp49bYzPDVYzFgtWK9ltozX8cT8nUqnpzMyFtDQ7EaxjM+7c2c7mxxFYsBWRsTPdsd+uIE0+RVrhqqcmYH9oLazDQVYLv7gAv2XEfw3Rc5baifB13vzmV2ih5ggqlBtE9UFnp0CWzuVXuCPG26IFaY4kgvpXvPMfx/kqxWibsmJtgN8FA48+x7Bq8dH66T+IVF+a4fgYB34j+d5rRewHQJdo+F67vv9g/nYSDf9nIGnhrYTcnRo7hIctPFwBqoE2VntJDnBVBvcat0zbScGEQv57lRQ5y0ELTCdy85dwXj9IseAm84zdC7nSFb3cnS61PLtBEo01C1c+kOkYSUvtOxtUhrmHMeedpwJ7wZEBxVPwA/gg28jqCVK+02aLjM17nGlpz4MJLQp7uXiYG9ctpZYs4bnlXUUqB8pj9lHQx4hsYm428pVkQY0IzPvLuRZjNaNm0UM1dUSXm6Use6NHPJtDz0Q8agGXEQqW/GJ4bOdZJw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ff047c-e491-4da7-4416-08de7fed85c8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 04:12:06.4804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPu+wVqvCv77KVNVnw6FcpS038Tk6zjOJ/XWydJCPPUWpC3wiiQsQMM3lmNAt6x2MbicCNvZ5OKfzu2ZhcM3+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603120030
X-Authority-Analysis: v=2.4 cv=c/qmgB9l c=1 sm=1 tr=0 ts=69b23d1a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=tB-0ulGQXFfuB8gCrJgA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12271
X-Proofpoint-GUID: 3Tu6FqujGSggpBwOKSjzQwSGN4PC9kGl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDAzMCBTYWx0ZWRfXy382hqwEfsu9
 VzTzV/RaF1JNw5DSaO1MegGsWgoNgjQ6j4KN0pIS7tFL3YxTxZNnunOyRALU64s/eJElVdkbpwl
 VN1rgVNVZ+IwrCqV8l+zj0A9U79zsMppIPV+7pynqCpWWOBKQkepllIt0WSXrfx0Tj0/hjqOQ+9
 vEbpAJbbtPHR68I0ig0u7ZrDGSeqdhOynQtXY+1yOSB5ENqRKqisIbJ+0sQR5Uv4buo/whNRWxQ
 g8mpgnHFHrpeCSnd6+i/l2t6r5svaSTUwgUsGgyZZuA6tbnBmH8m+VKTKcxRQpoWk+Tt9xGdE0m
 S1i18OErXLGwmcbsUdLls6N9CygIsn/4YUcoAlE0iEzG4jZQQruPTJCZLD560MALYNz6suQbuh9
 xUKZk7hrgiKl8gjR80GOfnHvuVgqyZdwKl6/5AhE3dN7jhWwnkstbNgyhNDfb+I7NZCd9PqwK6e
 Sb4MzdgChEsd3Hy60AVdnl+Ji3cEnhhFIMZbJHc8=
X-Proofpoint-ORIG-GUID: 3Tu6FqujGSggpBwOKSjzQwSGN4PC9kGl
X-Rspamd-Queue-Id: CAB15140010
X-Stat-Signature: 5yui9yyugg3otqq7rnkguwn9cfxqx55x
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773288743-578530
X-HE-Meta: U2FsdGVkX1/ZZVqIcsy7bAdp/muNlSlL6S7RX/eWvCq5oWedCMd6BvqeW8DY8NdPoWSj2AXISc6gsrZTUXVyWEHJgLxYABNaK7n2Z5IL9b6+mUk0n0ie6AP9vhXSVpUukhSYNyq3DM/5d3hkJpyBTbfPYeBzP1LnP/q2welBZcHzlMdeVTl5kTYic7GCtWi9UJwjaynVc5yX3AXbjygdlzpFrmPQSF/xgCDBolLKCikh4qs6g7tvITe3XmiBJZEIa3+uAdV1p6svhUuiVhDyPkCTMKu58Yroy4UIVzlLrW1aMAX4OoGRXb4CmA49onCqkwvfg//v8dQxYJyuIceiWyNC8bxOlTLXhA8GsiuZ0Wns/vjNTFE1jtuwCG0Pnt2c1DplntCIxIWX+uy3W5FXYQcyG3f08Y/jCy6o3HdSpnPjW/qZFky0WaEm7J+IFiJAcwxxhYHW2ggFUxsShAD/U/B6lBm6T+wQRSBRmxCQc9oBxxjvOF0fsNxv9h4h4B4SEtKuZx58JIU7KAbNxW4ECGe0O9MIz56rdnSpWEgxvCEbcdN69Wd3n9htmwEg68BL+aoDZJRjrCHWEQja9Q/aXCnoNah4gFh9u8PY922SIhn1uqH9LF8t4/Jm/vnPZ83SGxPP2GKfnek9EPjCrDY9SCks3fZuLkVqHx3xx/iesfy//7/ZD6hGAF8xZ9Z29u6vK20K9PQ3LPhCBuucp9L+vNpCakkNPWL+OC8lVqEeF5NQ35q0iciEkuo0PNJfdmlV/lwwcFXk3vb5Gms5VFoogiSILBjS5hYHdqLD/7brsDZb0MhGTBS/o3VwfBM1Nb/9MH8z2KFQml/geGVWEb+QWQ3HQ1LIAliNwlu3Q066FFWtzbpg3dDS9/PPWiZ3NVwGn1kBa8RDoIgZ8osVDEMtFxQ2GRmoTI8kgnjwiHLOOMVo1VXB3TCCYfSkODBZ7dZ3VEf7/kCP64xJ5ZLVzOF
 0JcV3PCV
 4MwHTRjd3kEBF3l5M5EdUqL5NSGdPCOVaCdRuyBL8Uof7kRGuIEY9kd/e7EC7AcUb22d9uaAHZb6U7tPM1n5/QiPcAYZIrojKHSTU7FtJxwLVT06FP9hBXJbIPHkJnicTWeDuWtGVlZ+lQN3NhqV7MJxLy/71cusVmaC8qg1adDDKj7Sj9r3/3jKzGlCFxqKB9+nY9ok+AJB1/kzrU95pgYokMW0+j2W2obMgxSppP4B/QeOk+ljJk4PaMoT8kdoZGcaFaW5CLFlsy5CioOYSKYfwJwIQJJvwJet+5iir4iYYV9nLp0jwctxmOBcRkDoJHc2BEu+xs/STjMwM0TmwZit8fpgtG5VnDVHufSic/88kYmrTd4yELrenS98y+jrJrM3Sf3bHakUVfsilMGLL/szcNnZwqMUNI51Zm8VEaRDlrYGV6ddtoOUHQF2tzoc56A3c/vZx+i8pL+T8QDhYo6sUlNbbzlGujBvarZNVwaoKx1ZzK6EC15HX0d0X6OeyeVirjKxfd3O9dveZJCyamiotVfg+AuWIGtGwQY1vdjC2zHD/Xwz+LI9BbUWDB3hJTgxFvXTQCA81ArvFyZ3FEeI0a0XJaaazXhz3ne0n0mzEPvS4Yky53B/PfPmMB6qs6qWLelRqW56EKFNFNkY2OzQocUwKiDTih9W8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 06:15:51PM +0800, Ming Lei wrote:
> On Wed, Mar 11, 2026 at 10:10:13AM +0900, Harry Yoo wrote:
> > Hi Ming, thanks a lot for helping testing!
> > 
> > The stats look quite fine to me, but we're still seeing suboptimal IOPS.
> > 
> > > - slab stat on patched `815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next`
> > 
> > Does that doesn't include Vlastimil's (fb1091febd66 mm/slab: allow sheaf
> > refill if blocking is not allowed)?
> 
> No, because fb1091febd66 isn't included into `815c8e35511d Merge branch
> 'slab/for-7.0/sheaves'.

Ok. But the "mm/slab: allow sheaf refill if blocking is not allowed"
would impact the performance, so let's not forget to include that.

> > Next time when testing it, could you please test on top of 7.0-rc3 w/
> > the memoryless node patch (w/ the delta above) applied?
> 
> IOPS is same between `815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next`
> and 7.0-rc3 with the two patches.

Thanks!

> IMO, it should be more easier to compare & investigate by focusing on
> 815c8e35511d, given there is only 41 patches between v6.19-rc5 and
> commit 815c8e35511d.

I was thinking that there might be another regression involved here
but yeah, apparently it's not...

> > Also, let us check a few things...
> > 
> > 1) Does bumping up sheaf capacity change the slab stats & IOPS?
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 0c906fefc31b..5207279417e2 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7611,13 +7611,13 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
> >  	 * should result in similar lock contention (barn or list_lock)
> >  	 */
> >  	if (s->size >= PAGE_SIZE)
> > -		capacity = 4;
> > +		capacity = 6;
> >  	else if (s->size >= 1024)
> > -		capacity = 12;
> > +		capacity = 24;
> >  	else if (s->size >= 256)
> > -		capacity = 26;
> > +		capacity = 52;
> >  	else
> > -		capacity = 60;
> > +		capacity = 120;
> >  
> >  	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
> >  	size = struct_size_t(struct slab_sheaf, objects, capacity);
> 
> IOPS can be increased from 24M to 29M with this patch, against 7.0-rc3 with
> Vlastimil's today patchset.

Oh, thanks!

Could you please try to keep increasing the numbers until the
performance stops improving?

It might or might not reach the original performance,
but that would be good to know.

> > 2) Is there any change in NUMA locality between v6.19 vs. v7.0-rc3 (patched)?
> >    (e.g., measured via
> >     perf stat -e node-loads,node-load-misses,node-stores,node-store-misses)
> 
> root@tomsrv:~/temp/mm/7.0-rc3/patched# perf stat -a -e node-loads,node-load-misses,node-stores,node-store-misses
> Error:
> No supported events found.
> The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (node-loads).
> "dmesg | grep -i perf" may provide additional information.
> 
> Looks the events are not supported on AMD Zen4 machine.

Ouch.

> > 3) It's quite strange that blk_mq_sched_bio_merge() completely
> >    disappeared in v7.0-rc2 profile [1] . Is there any change
> >    in read/write io merge rate? (/proc/diskstats) between v6.19 and
> >    v7.0-rc3?
> 
> It isn't strange.
> 
> Because IOPS drops to 13M on v7.0-rc2 from 34M on v6.19-rc5, so blk_mq_sched_bio_merge
> can't be shown obviously, which code path is run for each bio(IO).
> 
> It is one totally random READ IO, and IO merge shouldn't happen.

I missed that point. Thanks!

-- 
Cheers,
Harry / Hyeonggon

