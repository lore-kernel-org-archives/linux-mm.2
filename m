Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EB5CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1284E8E0006; Wed,  3 Sep 2025 09:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100A18E0001; Wed,  3 Sep 2025 09:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F303D8E0006; Wed,  3 Sep 2025 09:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E25A48E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:26:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92C2F86355
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:26:25 +0000 (UTC)
X-FDA: 83848013130.11.BC2F7CC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 138711C0014
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:26:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EFLW9LB3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MJvlW3jz;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756905982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+w/DPPjEcc3fxQj8dSPToK3lGF5vi5mLZw5yu8q+WU=;
	b=fQQlPNXnQ7ZDZeq0/t53ywhe/ZtQJfClsxLL7R1ttZ8EFkfoyoRTMuNxfsYo8ek9yh13oc
	iPG5Vj9efUVEpcEgaPahypkBPT9nQkQnRTMp52YHG9vHk4h4DBLiHHtlTLqevakD4w+cxB
	ogw2/MT7ACn0Oqgrf6b3gZQx8QGr7So=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756905982; a=rsa-sha256;
	cv=pass;
	b=RgWuhcg7hGrPYDfwNKtDz/ow9iBEHxa7kF+wi55Yi8Cj14gP2WfrDWReJg3cTrpjrERgl6
	obPOfwlLPimgh3HEKaWH2FuZADniysd9h+T894sEOwJ8poSssKCU2U8+o+DQvpKybQPJEW
	ypH6jKZzBrjMrJfIcbKBfEWbQZkxgDU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EFLW9LB3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MJvlW3jz;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5839NA7S009042;
	Wed, 3 Sep 2025 13:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3+w/DPPjEcc3fxQj8d
	SPToK3lGF5vi5mLZw5yu8q+WU=; b=EFLW9LB39Kd53dtBjlO2lk3hdO8tRzBwz7
	NWW6VlqqO/qN4kfwSGM9ubbPZZWObsxD6+3YmhJ6PqlEQ3aDyO+bQmetaUBGzAkD
	EvQYpUg7s9VSJ50iCTNCqbvAzuMF1cCqyMjDnyQRPs9OCmOLnDG9f8uAjvF2oitb
	Nm+zarVH5ukANXjGnLnjdGpXiOpb3tnb18sA7tfaI2aZ7IpzBt2h6Oj6jEC7rD0Y
	xG1cNlULmeLbw0rBs6E7I5MTBQjLG0yFGhhgViAvy7d66yIzNPpAalNIkPz00hHm
	hobIhJnpu9QGpD42Glq1hcUyA/3Ykf2Pol6f0RZWLXoE08KmHIVg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmneasc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 13:26:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583BafjB036219;
	Wed, 3 Sep 2025 13:26:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrab990-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 13:26:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bI7YtSEspo+zYk6SSaDmRC0CCQK4SxDHuOvT/RTE8fv3h6N7fZFKNL4qFbylE2iWYPd5kX34mZVwG06IXnNSjvsTPhOAR1GdKmO7WWeCkCBVxuxWybZIL6mihjTB0PdcLpT6m/dNwunSLj14KSX2LnpKg7n1IJ0McqklHDotuzsaoCdXQvFJXAi2J2ozzIf+NY1eTK5yGgpo5+RIGf12aIjaWDDldtnodloisKjVJC8gXO6d5opZiGkgp4R2MW8EzYDx+Hnpziz6I8IooyISabJsi5/o8Cq9ku8G7pTg+w7t3wSPC8rCtwqhjepQ8tL9JYmRxHcYXIKdbmEMkputog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+w/DPPjEcc3fxQj8dSPToK3lGF5vi5mLZw5yu8q+WU=;
 b=PtU4okqlJgj3dKdQg/yVamGZsGth0JyHaheqIYTTKVDQGYIz43KbSfazSweAWkgVNGWpx/2gseDWBlryhHb6g2lLhg5ee8nKCL1u8JuRnFUD3/JvN0+6qIyqZZg00g1DcSHlIiiYdGtaFSJpE45A/IMso1wYV24HcZrXAF9i3a1UTwo4aPAwZAjrZxXbkR6hcZybsQh6an8rvZQr1njUGh49RxwQ1+TjBt8QqUDIRYmCJya1Gmlsb4NoKvtVWJkAftP8mhHNmkxy8Je/R5+Xlg1PHtPLPsqYkuY45PvWRkDnRoSAT6lZ/GYeAbGQ4lelws5IHxUH6RrctLtFcgEVqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+w/DPPjEcc3fxQj8dSPToK3lGF5vi5mLZw5yu8q+WU=;
 b=MJvlW3jzPqvfhrvWALIch/mWzcK/qP8laAaaa1C51zsmJ1paQgB02TgsiZyaUL7gGfXnVn5Wl/XSrgDJ0Zc/Mr22U0zcUm4lIR00nmfN0ZO2eu0VseNtUQGRc3HdlbpTNgsmt3MT4uaIsBe6Vx/XPdv+vZ2Cpcxy+CvCQCt+Bjg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB8103.namprd10.prod.outlook.com (2603:10b6:8:1f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 13:26:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 13:26:05 +0000
Date: Wed, 3 Sep 2025 14:26:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org,
        willy@infradead.org, hughd@google.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
Message-ID: <e37bc789-cb53-4df5-8297-3be146d2b620@lucifer.local>
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903054635.19949-2-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903054635.19949-2-dev.jain@arm.com>
X-ClientProxiedBy: LO3P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB8103:EE_
X-MS-Office365-Filtering-Correlation-Id: efbc4dcb-27aa-45bb-d9d4-08ddeaed6f9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ydFtw/nNP46Aetpt189jhH8VlCgqBPGWL04rlNm207pRVRK6HAgjtfaK1sXt?=
 =?us-ascii?Q?tdO7Vz21FtZW17rs+4U03DzvCOVUBV4zboD4TWT9B8Lbk47ybJzckWy+QhdG?=
 =?us-ascii?Q?EzeVou5xwdkYMYHmAi19JPGQjzTEU6qerpzA4D5ejMDAY+4ELslhgZ2St1Uk?=
 =?us-ascii?Q?xy5i0Y2u56CN1aNsvedi9w2mlaMneykKKI115ARiOR4myD0mRmfg7jzMpoqV?=
 =?us-ascii?Q?72J/arlW8i5mK5eJOkZTVO+azsGGkpdY4vNt1m+jYI/RbmEAnxGMYSbF3unK?=
 =?us-ascii?Q?EIZgL3Bpi9RQ4n+gDCtIojzrcUs63Cw8PRfk+HTJlaAUw1a0QOvKs+c194aU?=
 =?us-ascii?Q?oEDAuUxkNHmbSBy3LtRRIc6myjoEjhrw9eFcKreAjAIfJ6NfxJaOqccMdUQK?=
 =?us-ascii?Q?/w8AQca/wRuj8dCnuOodogJX/EbBPTseENQxs6Q9wlsGG9qsOHLYL5+NYB+M?=
 =?us-ascii?Q?IdxHTqQJd7Y04RBgN7MiEgxWCqOnvLJe5+FsfkZ8WaId4pwZTL3KHFnSDCtB?=
 =?us-ascii?Q?E2Os1bVYngAMzhVP1Qxn7XAfr9bpr1zd+0Oeys2euC0gxq2irnCiy4NMp4vU?=
 =?us-ascii?Q?B0YwYiiULOhKdeEMrApvFo1fJNdV1H+GK6hsgvUh0kFunViCp6QFsli78dIz?=
 =?us-ascii?Q?jUOlP0mNDTgzYl4IV+++EMwazGWt2GbBEfsD9EMh7V9vm+VMWmbrfloWxodV?=
 =?us-ascii?Q?Tx86RW79Nk0HvAPDa1QHJifZprWeclAftPYLdaJXEENx3dt1stxS/tEFmrLd?=
 =?us-ascii?Q?G31CEevuA4lpxfEzyCvbuBbMu/P+/nJZTEmbLW6zbS29iM66pA9WWVlxGyRr?=
 =?us-ascii?Q?yl9m3soLCOpUpP6Mbloj5RB6lB8rL/zfU/yxY0s+WzRiYbD80apwgDYCzfZg?=
 =?us-ascii?Q?wSo5MSbKc84IESodgkdb60j/ognW+tg0tNNFSuyijz8mR+obuH3irwrLz3b0?=
 =?us-ascii?Q?mCPMHxrswNqJFI4AIojzw8Mj7Ayhcu+ghotyycVTK9bwbLa6uQYKWth6KrC8?=
 =?us-ascii?Q?4AcHbfDsbCepYqfUZ3xTJhsX+F1oQbKU64iY+8lqWL4Frlu/toYlqaH8fXly?=
 =?us-ascii?Q?IPQTB3ON2kFB5RGhtqXa1sU/Dhx1ON+UEt/VNjeZa7gv9bO/a4h7tKqu3cOb?=
 =?us-ascii?Q?z0muYn7gvDhT+Cj9N8JKMKIwOG8Y8GUFRFP6UHruMYMCiCUwGE/FjMicXLEG?=
 =?us-ascii?Q?kJb+Maodd9Vx3yFj1izn3vEVi1zRTTaXoC9IIdU8qxlDm8cMAKvVASxl2s4q?=
 =?us-ascii?Q?/hLcXI1/TkdIW4jQ+2tyHPp7a8Rchkxuc4Mi7NrMJAwx9CAUQouAfSk59w2Z?=
 =?us-ascii?Q?onjT5P/nUKt8AIxrFMlhjd1GSQXUjfRbg2pajqc8mhHlUAUb8DYao+k0KtcK?=
 =?us-ascii?Q?EijGXC0t028uTE49WfkyoM0hKYyfG4XR7XyKSZv/Q4kzKdOfI4brVbshahCG?=
 =?us-ascii?Q?ijvuJPn1MSg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/1FbESZzII/LlU+VJZftPtweqNuFqUuvOaW73K0FTHeo8BC+5Frwf8qlPssp?=
 =?us-ascii?Q?PP5UKE3KV8VL6EDFfHD9tFjNi2UksM5kAR//3+slE2pHTGdD5hZx10DCVmL+?=
 =?us-ascii?Q?jXyzzFQ4J4pnVDLYiSbrNw8D9++bGGKp5u+he9RJyUGIf3yvFdxN2P+vQKdI?=
 =?us-ascii?Q?F3rRoIKuPf1xylJ3EKInKiqOq6gDV3W1ktdX2AXzTCqpa9nAnaw22KASGxsA?=
 =?us-ascii?Q?BAoVi3wvtoXkj8DeZUbXmO/fdGPC5STbnJCctNSM6jYloVbOO2TtiVUpMJK5?=
 =?us-ascii?Q?nkSt9ivK53q0KmwH6MkH3vYdnL304q3KfFitC1+WcqoLv9I4QCLsxNYvDRDl?=
 =?us-ascii?Q?5tZRimXCUgZKdJxRySKnIrrVYWCMFYVjWeqrcI3deO6ubjCnQb6oaUptMiSJ?=
 =?us-ascii?Q?hp7x0LX0GsGDXFEGU5oxnoQNGUB73nBZ0tSsU/J7LemjQqRLCkq8nKvH4X3L?=
 =?us-ascii?Q?hPcHulGRtdhfe+rRPwyzH9Xo3+HdFWlfa0JA6ZX+FBzQPahX56JN/XMwjlxE?=
 =?us-ascii?Q?ZEF1DMfLd3W3cFFRWUj/mCgSOJGl5lHP0gU3c5i7gGkAFPC654i5s35nYqG/?=
 =?us-ascii?Q?CV3T7r+GCEAuewWo5NC0n0d/6uFRyPtMtucJ7UvU8HFGrXV7sH8IGDZRPGOi?=
 =?us-ascii?Q?oGFr4LOVmMYyX0S8xhFj0jZox9kKkBlBdITSI+FItE3/+OX3GcW96iOLsSIl?=
 =?us-ascii?Q?nUVfDq3tJuvLUjpLs9sh3aYf7uh2zrK2aTAAu1k9udT96cEwwZybEZm7VVo2?=
 =?us-ascii?Q?BtyNe8Ap0B90EUlcBDOTZHmnGf1AiIdlDoCrpMRciVBNK2aisXQIZCFbYtvr?=
 =?us-ascii?Q?84e79kuO8CHAoRTERmLC2jQRPM/Iw48pgqmiTqgLqu39kiBd6WAGdXQFej66?=
 =?us-ascii?Q?9Sb3mTgVmNtXnfi7tW8ki2tO6FXATCRZOyJlpy9wuMVEqFY7C8BOCDxmGprq?=
 =?us-ascii?Q?+rzPf4IVFfTgTYGC/HEsYXacQEL02B8OMVs/80ol5JNGqFmwTE3A/Z+8eOXN?=
 =?us-ascii?Q?a9r3khupAPCbiWJ9YzmdgBPAOEnJaYsic/BkFq84MIaz7/lmh5tgqn/3ULHO?=
 =?us-ascii?Q?Nm14KlRl/+OVkDhLwQX40GA+oQ+bo10SOg4hw+FK2THdsGgWSg4Xij4noREk?=
 =?us-ascii?Q?Ps0onvvGI1qk9HKIsgQ8378BJN2Smx+0iIVOylIX4piqWnTBHhuRdSCIjVZF?=
 =?us-ascii?Q?MOt9zsLbW4eePhYiTVDc3iUTalqnOK9L4l2wkvi27fdcY4IrVxddmNjQiqF2?=
 =?us-ascii?Q?Sbr/oloyUUBuArFy4oPXc/wtDh9CYPyQQsVwV8HQwG+DqTYTLGTFtrha5ej0?=
 =?us-ascii?Q?bjI6bfEFjH9u8L33wsWYsIe83ybS2Pg6xqYBZi7CR+2HGKasQ9S0iJw/l5OI?=
 =?us-ascii?Q?wLUUDwrjD5fTpbvsH72XB4ylxoOkpdd2qkYR5RGKVRKAWcD2CRvN39w9UazR?=
 =?us-ascii?Q?i8ytxL6XXznvOvoNpIbnCCOlX4uCwqxCTh2/Z2/Mn2hPMwpnjyNQUWO/W479?=
 =?us-ascii?Q?MIwm2HmBmIkv7HJdWzEzrPYX+uumhhLcF444XxFpPPpIvLmRp6foeYDyvp0t?=
 =?us-ascii?Q?1ZIjkz78GtrQO25N2TfPZnG/HF+5Kf0e7GKmgWmdTcUk4BLnzk6IuQY8h/UG?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l4itdrQiKUyinqovM/PEwlLFWftwhaCW5amsXv29DF5ggfW5rkIVJMkbMk/p5x3jdtLLGPQppIdZ1XEThPzmsz6PFUGp8Jj+3TY8w6HMefo6rc1H9EOjpg06iDqV6P4ARFqiCiUMO70ZHo5KCIvHr64eN+1gTuQf97DeoXiMS67oAHjzLoP61QtfWMXDPtv3sQ6h4J0iWDmON2+s9rQ7PXgaMj236xi46WNPziXKCVIl/uW6aU/PU/Mi1884NzxgaP9S92PMYTv9aoqKdtg9iCG99lmAOTooj+Jj0ZhQh2zQhSEXN25vax19m5zYJqjjl1TEMWIIeTwZ0F7qIVdh8ZzlCFrhLjpNLYlli3IMFczyQjIxJJ6Ud2C+dn/blP8CNZgHi+hCH2WMfQWPJTsxZvd9xZnKFLNEbgug4Wo1x0SQqflnuKIWFb3Nb5yAWlFsSAm/pbgWHJYujbGH/hXiMPeTDQKddnWUdxG+a49/QfAhDJSMui/KEnpbcf9FwWRZ9cKK0J2TXbOk9NpAPx73H1nw9nqqVcwrvesM6yJ5YuRlRaqco9LRn+mvEwDgahOgsm+w6bjjVMrAU23tR/SW0Y72LN5s58dHb+ddo5OKrmo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efbc4dcb-27aa-45bb-d9d4-08ddeaed6f9b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 13:26:05.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rxkwg164O6VAA4b1pFVPoyDoD/z73fFqj2g82pgqQIBfZN5t1vlenOiz7c09jglJIjaOMv+zoFFEMkIxGDenfc7UWbs9myh5DPlhIzCy1Gc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_07,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=829 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030135
X-Proofpoint-GUID: k4OzBQCGpmn33l4B0oLw6G07hjiFgrAN
X-Proofpoint-ORIG-GUID: k4OzBQCGpmn33l4B0oLw6G07hjiFgrAN
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b841f0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=R9vLcmxkAU607GsSxoEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX1WmyMVqGBe6d
 vN1tjdemG8o3SluwlA0dq5mYx/DR3jAxiT8wg3xp3zW8s2z2fspPHnZluKF94zimeRk9Bn+mVXJ
 88ye53WfwuPFEWnZnWeJAcGn4b2/Ub1MJhSBIwcDAzjx5+KHWxJ5rw8a96amHH35pAJ4f8vuGSJ
 EQeYwv6RQzkLoGdY/iBUrnsk5rrjjbqGt6Mb/toPvW+d/7h2pbu1dTQBT4eLlSsgRSVdw8LXyFb
 IdNIn/+HZRIUZ7lPtLoEku8xO1evIdkVqDBaxsXmtuVsWWD9TtuJMVFtflBCZn754tKnXNokmYN
 +buvakUu+nqQ94ZHy+oDru27mcol1ISrVEN4TLYDBsplmVgky2/GyAHr+GFSTPCDN/LdoIRET8M
 iNdc1Lgs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 138711C0014
X-Stat-Signature: 6jfnuhsbj51cw7nqaxtc64p3jcwxrhpm
X-HE-Tag: 1756905981-676410
X-HE-Meta: U2FsdGVkX1+oI5kGMZNYKYrPoU9RxaT09gQqyJgfU8HpqEKqpHoxLYiavR8C+eim6eRJqfhmzZhQV/yl+xFVzu8CnsphEjVmQK20+9k1ir3LmFryOeobeDQRKk+oGlOHutXOT0hvxA40+PaG30gQIY7pZBHnhLD0gLrksTO7XnGwxL0Jxoxcd45UZwOOzQdVoTdD9yFGiPvMNuWibfYm8sP16FscO5N5jnA6ba2LPmoug9J+MQLTOO5HQweZ54vMeCh24519jXwvGiqiZbmMKzfFkIFrsx30kNfy0AyYL7Vccra6qaJ3qMxihItm9Af8DkL/NBr8vjoPX3iQoQ6OCQZO89x+CsgkMMaYj+0uBksPbJSzJ6pND5IjpGuVxujVnS8ZkYY6u8aWXM57r9ekOp3RwRPeTmaTYt9r8ndlJYzqFZghxmkV6fc+v+ThwtMKhh7dby7OOpRpUGjOWBpT+K2V9qaymzIc7ZWC3r81Q4kWjo+j48boNcuGYznNBOsNpvGfjn5bLFoIYE1egEkD1ODkRRipB2+mhvvvtZZNITogJOSTgvERMG+oMTzeBD+SLiOTT9WuXRotgW3Pe+QkgumGbr2sRh3GOHy7mqNddT+DQGSEB5U96WmO3ITV55+FXOIOa2oMgqAwmpcApCycsr9PfiwtjPnnES9Xm+gHi5ScbB3Iii5yxi3W3Z4vf/haaUmrk+7sc69rKBhBT+5P9DWFS643m9vNgS+SUD86KtHPW8TqqoKmW7R6RJOmAz53jpuUUOSZ+EZT3H4N8S/80vRht348SFxJn7rDkJoV8vo7qmFllmL/4WnFtMWj0f+8IUXMn3a1PY5in3t4jyU9uCDBuo+H5PzT5EnXvT0ZdzFOa/Pm3T6A0/XiGtQARHaCDufdE5w0saDEi0uqJ3Qf694folMXO6Tj9l7MTfLeN/7lxR5c4c2GPMkYIsd99gGob1xuytN38k2zA2vrypn
 2yXnA5AA
 CTkO6QVHZtO2smWvOD0PzqnSmvd9YcFWNZnt6Y9StfD3lYzBN/X2tkHO+NFKsOh9PeiemL6272JXtTgYO4hxahv/+7YCCUtr1vmMFzH7U5U6odalOJmCOT5e6Y5FEL/QUFdFjRa3+bJJDjq1u5m5vA5c87vRVaShn0ktNgbDJYxG9FRxagtM2wPPOlOMVVIz4OhURzxOuthfoQNa9lBqHBrEfUG9Gm/8Ie/jO0urfN76YRfqzbdO6rVT1sQPi42sPmDafSKlD5T8AypQuyJ9Go+8DTbRsdQwxSuBeO3a0zw1inkRY1ev4t4DYXYqhpbItsHJXsSgS0uy+B/eGxG7NBOv04F0oLYdmo2xE4P/y/b36Vs6JJLwEqOoE42RSrwXxSqPmFLR5du1PUiPukRR7Dcvqs5wL5iovnzVuZmzIPUDpiQpruShnPy7foQKPf1y0LVfhncLJQy1r7+QH56q+Rawej7PXVAU4PfF3jRj6DYoK0DkSsCNBtxFh9W4RTWoRScvSm4nzPglHNHNXKAyEfhNhKGtt5ZyLp9L7G6t90QP3tb2Qou9vOvTJi6kj3mqMsDZ4sxSMRVlnyE7JG/nd5VonFDaGDkSRwWpSp32C/ozb7x7zAsAD3QLu+WP2eMQIGZvRo++kWfOz0EuEp8UZGwnBvKoxn7kQ86zdmaRc4HoV1TKa8ZtMJtTd3tZUGKbAlkXRr4jSoLGpzrhOjJx02S85BEoutCcxToFMNBA5ql5npH93FS6DD5mEndq7udeHwAihSncUXENGv1I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I know it's a small thing, and subjective, but really would prefer a cover
letter to a 2/2 replying to a 1/2 :P

But others may disagree, just a small trivial plea :>)

Cheers, Lorenzo

