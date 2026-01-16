Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20296D4A619
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C5D6B0089; Fri, 16 Jan 2026 04:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D9B6B008A; Fri, 16 Jan 2026 04:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355BD6B008C; Fri, 16 Jan 2026 04:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22BE26B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:49:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFFAF1405BD
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:49:11 +0000 (UTC)
X-FDA: 84337353702.04.171DAAC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4C9E880005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:49:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lpLDzlrv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fls4bJy7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768556948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tst20ppchh6S7HXJJf9LnORG5uiNzakQ/M+v1+hc/0M=;
	b=xQpLkaOaIVSOyPY7UHW23XgezSkaqvkw6noJ0Kr/Zts5Za0CFcojvNfr7jELLnN1mL1nhX
	hHug/M8wChzK0/8sNf1WsGaYgZbE9e+52yJuAJxlPBedtUbFjlh2dvJIVaFo3tZ5osnjRm
	uVlyqynfYnkb4OcXUSKT8X9XsXPt6V0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lpLDzlrv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fls4bJy7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768556948; a=rsa-sha256;
	cv=pass;
	b=IV8mLy25WHUexHZ3ZYd0Nq9arhFi63moEHyTCH6SZPdgexv2rYEYppz6zmcIB0MCZ6hRj9
	N151fuGgw3YWjIpgkKs3mcIm5edzGJKSMaynd/FXiAZ450ZnOfWI6iHBRBEeSMzVno9JQy
	UCtUeMq8OHSEsYYZEjnDNsrGljq4IyI=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNUBc1796696;
	Fri, 16 Jan 2026 09:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tst20ppchh6S7HXJJf
	9LnORG5uiNzakQ/M+v1+hc/0M=; b=lpLDzlrv5dhF+6gYbhsBuQV+22MB7JwyXL
	zsxUMkxSRvEDOOkGlj/fuIe2rtAyM2IW9S8Xq0/WZr5s6+ytzrardJ6pie4fPiU0
	EXtZeTcs+cPrJ+HQ86mwoM0t4E7oUS+ccNQtmiv2hFvoBpDtGTLXwGTiW8HoS/VA
	3Z+admEWdAfHFAgmXUaFmsW+kPtiGUz8zmKNLv4IxqoAd08m6mKnB0yYjY0Us9CS
	q16bUcG22HnkBZKospWhtNqotl+I4l1uSpDWb22DQSZl2ahbjO7oLHEq85UgwCEq
	h8VHG1PHcJQI9Os1bCZxhRTs0Qc6t07Jp3RX1TonP9LyfPpThrXA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgspnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 09:48:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G7M0dY028706;
	Fri, 16 Jan 2026 09:48:56 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010000.outbound.protection.outlook.com [52.101.61.0])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7cpj1d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 09:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4XMi3DwGwqnAoQIu2KGR/q2uaTYkiR++drPOuj9t+3IlVMdIHGcdfvwoAFBB9169LEB8IuDCTSgFfC8iw68SFxbzEm+fc/IgXFrZgt7u/ekDUugZBbPJCwvlfqCuiVhWRqWFYT7LFtWz9gHyZ+KcyVprdN18e4tbexFFDnmEknW2ndR8voJ1hjfatGCJGDbh4DP8j+sF6fsvBesYDWyBpT9w4nG5JHSbaurP1Fwt8BGeh+F1vYZDtYdw9VYNHjTPuOP/+S4TqfWCVLMPBk5mrdHG4ht1LKvnBPCEGH9SPCBczjQcqMvta6u2HSd88cA8lhc3svzAGvfV+LI3uirOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tst20ppchh6S7HXJJf9LnORG5uiNzakQ/M+v1+hc/0M=;
 b=FZBLoRbf6EBGwl878JyTtvlsEafuGH2jHL5rbSfPocOAayjtvwE0LeEYolVw4be2lPPEN74KTq4LPgRla2p3dx0cSiv81oeTWv2nQzXliDW1mTsF4ISaoWrg+0LhBz/PirKEW1R8q8q8mwHe9EDIPgqOsy8kq7JhygFGWHwIok26GYfhFOKQqXfGEkrWgju9/l9PDyeXLk0mVFnB/ot7qABkjIEl3/BTBunm+Rqs+9AQc8Sf93cU5b3LF6042eVwtuCz/bCVBu3D0gCg2lYCMZ2sios5HX+SCWC7HCaHZ/EB8fg3J9l36gcYgJ24D3nf4ypVSjC1NDlPzZCcQ3MV3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tst20ppchh6S7HXJJf9LnORG5uiNzakQ/M+v1+hc/0M=;
 b=fls4bJy796EXCeMe0jRKeqPb1WTFJPnEYSlcRsPS6knYMHZX9c7d5v4L7BC14Hysu5W6WAwThFbfM/BpHFdjH1bjkPrhqAGbEk6ts2v9jCk7l9wKpCaXwDa5YEZy8yg5f8vOZMSNwnyhg3up09g/9Ir3QCpDmyYimICYCuJzmpM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ5PPF136884A98.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 09:48:53 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 09:48:52 +0000
Date: Fri, 16 Jan 2026 09:48:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
        weixugc@google.com, david@kernel.org, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        ryan.roberts@arm.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
Message-ID: <15e2a0d8-e8f1-488c-8fce-c0a2a5182086@lucifer.local>
References: <20260116082721.275178-1-dev.jain@arm.com>
 <343f8462-44fd-4190-9fe2-8120b5403269@lucifer.local>
 <4b784eef-e874-45a6-828a-4fc2acab6fb7@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b784eef-e874-45a6-828a-4fc2acab6fb7@arm.com>
X-ClientProxiedBy: LO4P265CA0095.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ5PPF136884A98:EE_
X-MS-Office365-Filtering-Correlation-Id: ba41c308-ba15-4dff-f1c9-08de54e4752a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?raih9lsXL1CAK9bw7gZCjwBaZBz3dlzQXWx0/w2ly+Jkr0hayULUObBSuPfy?=
 =?us-ascii?Q?MzF1bSHlG702QYW1dccIzmNsD6cjLjPOFjcpcF14N9atMYwPijjp6PyfyVKL?=
 =?us-ascii?Q?k1iwAkxFLTR0Q3RPNsMqlprMq0C8Pg317pVpLHtL8/mZ1fR49h1+4v0CrKJK?=
 =?us-ascii?Q?QFX89JjAXxX5UF8jJSCy1KXnL7XLolFSwG4pw5bA6GyMtzWagGVO7A7wwkh0?=
 =?us-ascii?Q?WEzwm8iqQ3o9d7Js4TvD+scVP7h+iSoxEleqkfS/HYsrUQmh1QJRd3lnBdV+?=
 =?us-ascii?Q?64K8pVhoRhivOSe7fasBCljHJTPDkQp6C4u8G5sF0t5lByEifEDAmUkJnWU1?=
 =?us-ascii?Q?HhQJ4qz2ZhE4CL27Q1FT3FX8N44N+hw7zIMxucOYgGEgE6j8XZk73/8bxdwB?=
 =?us-ascii?Q?ccJhqnRo7GOqEN9kKPYCyBZFPI4b9apezTuGkELHNoa2Z4KZocqkTk9BUTAb?=
 =?us-ascii?Q?aWAsfdTWOJYzWVdJCEUlbXTH3OnGyOrrMBZA8C9UurALKR1rHIJDmglwSSkr?=
 =?us-ascii?Q?jM0hTnoOLSl7AAZ/L7iWDP3NyAdfIPNta/7F+t28AVp2VJWoNiyZQUtxoog+?=
 =?us-ascii?Q?ByofvA+b1f3dO7jYSz2cSCpBW3QNcJRQe7glUOxytj+vEdzjGFr6zUpqHhuz?=
 =?us-ascii?Q?N0gjqy04qmNdV3xa7GoOXgYOB7Gg1ivOPbcS9/S3tRIR4oog4YqpYRZ9bPKl?=
 =?us-ascii?Q?VLoYKTD4ByGOC/xTYyMzSSkN1nPzOCCxfGpAm2nEv+nKv2vs4vCFaFmLidd+?=
 =?us-ascii?Q?rV8TEaesExrhzTMXI/yjVB4DaFTNobk/DFJQFginf4aGrCX7ZylslQgmExq9?=
 =?us-ascii?Q?WXnOouj19fLD+pDqJVu53Ty2FZfgxeT638PKV7TLUwKAQbApbI6RQwXzlZAX?=
 =?us-ascii?Q?TsvNlRJWy57pr3ySOwxZ2gbFGjMFlhgrZWsdtXNPESwAjhTx7ZDyuAa2FBR3?=
 =?us-ascii?Q?ChqYhb4VnO67HSjSVOfDSNlg1M4lI8du5kKBqFs6BjsfiwzdQ3U7na58LDyV?=
 =?us-ascii?Q?F6rKweokt6N/1dyd4kB4kW6OezdRz4bf7HwOVLGYGtzjbON24MD+R0uquRLM?=
 =?us-ascii?Q?2sFdDMyXWncy/F5+AOVtsXkxUBvdbPDVt36FJKSYbcj8H4THPHc+juni9sTG?=
 =?us-ascii?Q?Ddn2NudETxFHZAvl6KX9NfSfb+i5ao+4cPYs72Po3KAY474nWyZkI5C0X7XR?=
 =?us-ascii?Q?oSBrXfLjSxdcqhzPqsz/tp9tKIUtYXmKuzFQO4rV7qiAhuF2zTc8W7bhrp0O?=
 =?us-ascii?Q?zU/y+Nz3LdOJ5+0CMtVuE1OsEjcZIfZg04c6AyzjMxk2BqrtG/xIaJXVQzP6?=
 =?us-ascii?Q?P1vhgbe8LUOepbflgrsvZZC7zvNeoUoUmI8HiN9X89Oc/r9oUJvTh981O9hn?=
 =?us-ascii?Q?//MkjCx0vntMwXikQsRHJ5FKXgPWsfsixfB8e9iW58sMfDZJDDVsoJ/BuGiC?=
 =?us-ascii?Q?Z20112PJj3tcoqOa2OD3bMag7WdhST4Qth5JHFDyiBbDsgz28Gv1bB1AdCVY?=
 =?us-ascii?Q?oZ8jDix1XqgTkTtDFgUEdoMK9OLxEvQerMGHFx/yckxzF5e6dQ/u1Se0PzxD?=
 =?us-ascii?Q?URWmCZ70APqG3pGwd8I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U4CEybFCgUKw4eqhr5f+LNgTESSPmsP9BslOWwNnuVOaS3Yt9vS5g00H/QpW?=
 =?us-ascii?Q?qDG+qfh4U4khgNmLF2bNBv5zAK2sQ01GTJCWJiqWS492n5SH/VGoEDzl6A7P?=
 =?us-ascii?Q?nvtKvFuLB3hzNGf8svfB/Ft0hEiFOZ1Bini9QYPgG8IOwtAf7oaHIIw2c1YU?=
 =?us-ascii?Q?qivF+89LKk7szjUCUfFcIz3H6yNHRNhXbcbeNRtn2WhdA5H6K1nQ/YVHELTc?=
 =?us-ascii?Q?qTufq0yeozQ7fEV7MVYLJVJLlqz6+UV6r/Ef9Eissze35nboOmE4rFYHA9ed?=
 =?us-ascii?Q?hUOQEwXwrx5ft4i6487VN/P8TmpQtvCza3r2BRpG/OjTjpFTgjAAntGtJQ+j?=
 =?us-ascii?Q?wH7T6j59boaLI3BRCKBiw5nAzxQf5e58GJ3gnyH3YsgV36Yhcru7uMRbz8qp?=
 =?us-ascii?Q?TX28pMjeuiOj4wpNHjYuycNKcGFfRl0tF65Z+TG8exWpbEZgumrM1bNDuaNF?=
 =?us-ascii?Q?hwKM1ZApkfkkTkvy+U83uSqQ/v/aOOrWYmy/no4LKdrqvaPibfBFD5glhDlf?=
 =?us-ascii?Q?XZBYKCJCfz7KkjST0oUGqEESCefOHxcI3xNAenRpS1J5rZ3qQGHUqsHosUFN?=
 =?us-ascii?Q?DWM01lS4tL38Igk+RhXDN+FoA7iwr771TfGE8+n1FPd4u0m0b4OmCJpylPLp?=
 =?us-ascii?Q?Oy8bDS80VHGnkfWjMi+Wy7vx2fE/8rEM1Ro68JlAdITnmURZk2pGBxdVdrB9?=
 =?us-ascii?Q?7W8qjMKV2bcSOYCNBjI3brKpDWk0qFIf1Fz+hGd+vkSfg5BvL6wsR/aVeDjs?=
 =?us-ascii?Q?XOaHnQ+6U+VMmH4auzQCExtiHsJqCM3slBkJBXloBcoIxZOlhzJZFBr1M6Vc?=
 =?us-ascii?Q?hecC4PwwbvCqBx2f36i0mlvuIKHO3uk4GBaG9b92VPjedL7Ks8n/4vw9htw5?=
 =?us-ascii?Q?usTbSa1NlZHAwCoeABFRCzY1P0MG3NinkXzG6t4tvow0LdOHf6z4HFWD2yve?=
 =?us-ascii?Q?8W6l1A53Xq59Ygwo2vFkd66Z4nDsYAnErMKlP2zXsQwLjMMN2Es4N0AoARcX?=
 =?us-ascii?Q?s2PcnVf9L0e4W1B05ZEB0jvAsp3bHTx+L32x7pNT6QBJt8TdK06pI9t1Vt2O?=
 =?us-ascii?Q?OFfX5+aPkw4l82Xpf2MW2ji7qimxOvyZnOTR4rm5AXO6sXBRWjKds/Azt5nQ?=
 =?us-ascii?Q?SNw25khnaUhLXNBi0+Cdxesxs5MBO4YGo54fsO+WJC+b+hQ7m78Kz73/ah3s?=
 =?us-ascii?Q?uETd8S3LnE6FDJWfEx6kJNe0mo4aIYO81LeyqRu2URy0i3ZzLvSfohs6AMfo?=
 =?us-ascii?Q?lkxv3XaamL1tQPA83orJwDH8ijqoEQ/QzJ4PqSNu2a9QgR8Z/uwwSFvHmNN4?=
 =?us-ascii?Q?hGyJdlTDFU25bD1huoo5zbpeKaKbTJ0FBFo0GUzRoVlMfzTTzPEmz9AgIosf?=
 =?us-ascii?Q?/dT9UoMLaI04bTj64D0jRJG3fJC/j4Ip48dAVaWuQU0CznRBmmVzo+B22sRu?=
 =?us-ascii?Q?NXxi189kod5G0tp4UJZZsUibQBC9vbamVWnqPdrWgtrO4I5cdPg8UjLPvGjb?=
 =?us-ascii?Q?ukaMrvQChUchw3grirrzyQaB3wWk5tfMbJRNwnoR3f+9XRW2sM+8JKrLeH4F?=
 =?us-ascii?Q?PWVW22y1k5UI3Zzjmf3lLx6ulHQr0/xCJJg4bC+cr+zyAOAY0GsyxpIbET91?=
 =?us-ascii?Q?Usaa9EGhVzQDPejd4c0sHEAdxCDanm/hEN6k5TDyKKhJb6q/6gACRmEIXP7a?=
 =?us-ascii?Q?1GFNrwP0AHV+QKZNSz4WGfJjzDGRfbnOjuIwIi00LpgQH0DbX+d0EnXZ4YxP?=
 =?us-ascii?Q?G8UnwupulssWEehOw6lVjHbICwLo5vM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WAyrTXfOU6gnyHUfM0RS5GmUzB764jhTlupZrFVziMUp2CERS7l6BQ4T9ALJLF/VVXfLqB0Zsm1gxIqhTgyJULvAroLH2mWLWwBV5Wr1plZsSHT5f36yj6PEKBrrOTAukDK2Yu2Porjqr3sVvYVBRjdVeMWP3K0+YFZs8GTgjGntFLGB7luCJmdayPH3pteaiN4s2Vyc2eFFKc2RqzEW942MABZwuMIUh08rtqkdmkpUD/oGRJND//NRgfBi+SygKRDqrePAwx6qH55IYnZRfm75pSgrfoZgPNWLG1Oc3gnahKov+d2hz0maJwaKaymkuqqpUSXiytJkb5ljJzmCE5nXFxKRyTJ2T3q9eiXSMjoSoqal9u2mGtpLrUWbt8ZGEQMScmQMS3CBaz67gSAYurdUelUqqoiH65nS4ruhS0C/ul1E1bQ4z+0xpsSGU2t1rrKz9ZfJbUPInpcWfGK+FoipGmFRTzRFvLQB2nCnAuqkZ2FNLPYasD79hcWQWRgxSN9QUdplWN7yy7OG0Hgg87d+AtE/0QtBAnBeZyZUYkACEy3L3yPLGFKNeHI2aTVzdw7MRPsdUMX/dNiA6Mu4CshP6efNIkz6ZfoOphGZYYQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba41c308-ba15-4dff-f1c9-08de54e4752a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 09:48:52.8990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gF0dEHkThQHfLg8g4qvAvi8Z6kK1YCsVSNgSAyakPpvGX+453s7Bs2Je8pbXQec5gSGKSTEOqURkVFtMbIkTyQHc7MT2DmiWtBwWPOHAV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF136884A98
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=842 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160072
X-Proofpoint-GUID: 4uUb04FNQMrtFaj0uoDm9L_7HWa5iXY5
X-Proofpoint-ORIG-GUID: 4uUb04FNQMrtFaj0uoDm9L_7HWa5iXY5
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=696a0989 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=OvTyHfLIVdKgSXx7AFwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3MiBTYWx0ZWRfX8unu7qMOROVl
 IpWQY0HiJt5aXnIfuGPMjEYSeUF7Dyvi5AzkLLwAQEvOQHu9ar45e6ENFPYYsp2jV9DMUoylWiG
 DNs2fBf2SiiW1TqnsMYqO23TnYEKKnonkT6mqeIaqL38rsj+19eZp46zz0qEZu2Nhit1bgaDh2z
 2JwRHuB1dEwF+QVLP09WCcMJkV/u2elrpgL62iyZBEgfCjAEB4T4v6j3WVi4eJHBrOJWLf3i443
 WXpSpnXfNvB0wPX+QHiRU2vPxSGYglgXEEuzOXcRO1eL2h4GkKYXhucmj5EAtvY2EzaRjYuWzSn
 FZrzIo7Yitb5H0kRFJE+5X3ZNDE9/8C3GAux2/akI5+kVNtkq5WeSSQUJRJBhpiVRQHap11z8Tu
 CXBXaQQViZz8fKbfjgKK6ReS0j63EpKdDPAWMkToTmYVipRNp089AYAcrL11zKhWuAQrgqa+a0H
 lTA0xwRQWBODDtf5J+g==
X-Rspam-User: 
X-Stat-Signature: owny76b41ndiuwbhj3gio5jbcdfwm9w1
X-Rspamd-Queue-Id: 4C9E880005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768556948-129352
X-HE-Meta: U2FsdGVkX1+O0t86BY6hbyFFRTtGDJ3bF1Dpvt9/qQD2A4g2aYx0TD4VyUsJwfT12pJPiUJp0mD7bSk654NRJpMybw7rTfmAKdI8tQOvZXiEunQ93JoI/meyk986TvK//SHSdY9slMXSZLqLiMBQM19XUY6mbkcugsjP6refmeep162pGdaKRmkmHmrVkKd41nnwksn3+y83WFoJI9CLOFTs+aueNJHKZD3IoM/Qa2WarVX+z3VSNRsSL9jT2G9agwUVI/Sv1DiOAPOJYu2pBko5Y8TF7GRnGn7ac3UI6fT0DLGKvfgvd04A11ncFx5yMSHrh1010qInKkUB//q4ESONDA8tjZ9bWbxV28jJRNvnnDTMIhed0c3KTmxxvUloCedoqlFPzE470eeKnM/XTANdvVgHvS104JG7zrNvQDv9UalUisOVhouS7vPA8BkEPXrn+4/dFinZZtV0IHfpwMWTHqP2wpNzlEXhhFmyAWXer3w6izhsDzZzoSKkhHAtEb4Q+R7BsN1gHzk1LBmugAilxr0mziNgFVHPaFAwLGjU4kAYN5oh4Rzb4XK81jsL5DzU3jZ6cPxbD55IjnDLNdrdn1jZneOxapIz8AGfvAfQWhcpsrHdedWNZLW6tx6rYmb0QimRtPZ4Ebys49/LXJ+w9A2yKFb8vOx/0cq5tdKL5kcbxr5QXxZZt6jGqC2ol4tc7lEiMEmWXqK0byQrmq8ZJ3szaE2+8mZHGjs1ixlQEPDS8kL0lB7NdQsM1AqtRZqdgj3dm5Z1euJFlR7mew1yyA6a2kYKKGUxEHqEzLZpCRzTwqEP7ItqdGE0iqhBxfzUykAsO0w0DAa1th1h3LhW7+IeTzwbAkx+F/ikPlg1VahRXuvAmRMZ55lkXVyZ0WmkxQa6bCA0jk5NHnN9zsvrda+g20FmQDpnuFP8LwCHXzBRby/yKzUrtqeDVZtYw+6K/W1fXWwSO7inGv6
 UPHOO6co
 Z7zum0nMCcq/6776lMk2gh7On4lArJx0VrmQ3nuLWAj1EzTSLjTrPok/88Y0alXPUCYmikfTvdDoRJV3hwD/5C+VV1z0RU47UIuKJfH5gJwZ3gkGc0ccxwkCsZKgUspwL4Vk2zfnOvSsMSlzo+R/ORsv3++AapWVAkrj/EWIQwTn70Tj2d23eDo3eNFI0kO9GQooXc5mBEZDsadt+MlucwYTyZ7hU5Xla8RYE5TLNW0CB1ioVPmM6GaVAxK34RAsRu4idEcqucMAmqnLaJkcSf0sdGQDDnlZX7O39APHoB5MnxwhwkuzygLankHh2yvy4gSNu/8M7Z3ghUZNuzzZc5nQIjYTuS1s1+Bs90W+htE3tvwexXPtsYpzkgm6BvwpJSYfzH1/ydLTbVedn3bFH7LG+pftRMVxFgkPJEyuMgyDexphBV42Jn8zntAnyfBQEpwEQFT+d3KyE7vs3d2FAcpwMAB9tMuoWwcGgbM+8vbwkDtb+7IWFXZ6TruFWIj11MAviULQDwW2BHWQXICZsngd+Ohse+IX/yvicqV1e5qlViKP+IhZ/eOpLHzjrF1w469EsKldThw2Vytbi5tJ3ikg5lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:10:23PM +0530, Dev Jain wrote:
>
> On 16/01/26 2:09 pm, Lorenzo Stoakes wrote:
> I saw that the last comment on that series was more than a week back, so best
> thought to just do a folded fix on top of it - and I had formed the impression
> (from the conversations on list) that akpm prefers fixes over respins : )
>
> If a respin is preferred here then I am fine by that.
>

Generally we prefer fix-patches, sent in reply to the patch being altered and
sent by the series author.

Sending a patch with a Fixes: tag is never the correct way to fixup a patch
unless they're upstream or unchangeably-bound-for-upstream with a commit hash
that will be the same in Linus's tree.

You can by all means suggest a patch to an author by replying to the broken
patch, but then it's up to them whether to take it. Also then the courteous way
is to raise the issue in that reply and say something like 'it seems that the
below fixes the issue, can you check it?' or something like this.

But the correct course is to the respond to the series in all cases like this.

Thanks, Lorenzo

