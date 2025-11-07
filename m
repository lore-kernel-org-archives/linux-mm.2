Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C898CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3A48E000B; Fri,  7 Nov 2025 05:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9ABA8E0002; Fri,  7 Nov 2025 05:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9624B8E000B; Fri,  7 Nov 2025 05:11:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84A088E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:11:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1939188AA1
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:11:11 +0000 (UTC)
X-FDA: 84083393142.24.443C21B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id B6B83A000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:11:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V6WwEu5p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Zl2tMz4G;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762510267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7okJVBoTTmEJbkhGvI+L7mVNF2AIhh/Ht1KOaW3uX4=;
	b=iDnHW68kMCFEkx9vwMhR7WugIq2PI3QYH2rBBXABLVcCPOTbd4mUoyQta+mKjUjgCeCOQZ
	DrSfDgEGnOupp4Ixd3GFe/6Etg8qp48dRNJpQnm1nF+11eESb/CueWR9pMbfofx3jgXrp5
	ltNJFfI55504+qiEK2rMyU5p3k4a4qs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762510267; a=rsa-sha256;
	cv=pass;
	b=i2TfvuZRnBJ3dGO7UMuptvxfa+XxaKEZapNhNjO0jkMtVXHu9AeSJJEAAB9nicNk6Tqc9N
	ecf3Pbmn/3Ku53FJ24pdmLcW7HgG94h7iLt2y8cucU0cSs441FYC+efqenEnzQK1wVDQt7
	2/qyvrMI1lnnv3fmRbgSMKWB9EnZvJ8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V6WwEu5p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Zl2tMz4G;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A78uVq3008408;
	Fri, 7 Nov 2025 10:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a7okJVBoTTmEJbkhGv
	I+L7mVNF2AIhh/Ht1KOaW3uX4=; b=V6WwEu5payInMsLHM+4MCwj+wiPKLjbyMa
	47wKeXQC3oTQCXoxu5Zp+eusKIfqbws6wEcEMYgEPQ/OFTN3UqoDiCSwD8HLvyQ8
	sotiN4847nI/4ixxSU8VWvE/roXrMobLRVpx/i3F3hsKMvjpcEY+7enRSEijRdgq
	qDorLqNmUmOm6pu7faf1nrRT9J+3nHtp5mWP1xrHt3R0CEYjvGnLR+q7puaTZWuI
	wVmHCN3oMGICoPJ0pCm0TaJTlPvqSvBoAIbeUZxflzfXbUUeMggEsJOcOqn65wZO
	SKwHLrG6KH4mk0A4qulDIsco6ZFFv5vD1vkcvt0u3JgXaiSSSdOw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yprhhw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 10:10:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A77wLVp039448;
	Fri, 7 Nov 2025 10:10:57 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011063.outbound.protection.outlook.com [52.101.52.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ndanq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 10:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AaI3SK0LTflC06MvTnneF48TnQhdBvEF5J7G30XAS5vw5kbHlOZHlHmI4f7Qiw+w9nIJH9pnRhUXisFOaP4GFHPpKv90OCWXzZcyKnKHC8UTiioTQbSTew/1Y2AaxTgJXnTwbQQmoMKah1SJU3DeBOYfNN+fbQspVv9v2wxfhWKjIbwXkPNQhBqJdukOFjJBknooF3bxpBLASzDV2iEoCJZP4p9aHMGtsjfOqqSfKAXw0UZZFH9b5JQa0OUUtAQARN4NT2cF02CYIh1SytgmbKk3qHQqm7Xn/Do8m9bpPFnVSpfK/JcbQ3ZgkABsfPqQij2xYfuy8qTqrv3wmpDBXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7okJVBoTTmEJbkhGvI+L7mVNF2AIhh/Ht1KOaW3uX4=;
 b=eu/SmnD41YJRv7YtKQCxjhkipFRcEfTJhJoNGaY9ZD6jgekmnkdgplHTwhfyL186WEao8+f4r1q+GgffnzFiqkLPhjyQGl9v6o4kMmRLKl7lWaQ9HxC7rqxw8ZFIplnL+8YPMpl5Rzy4bNkAaUfLqpZkhETRDgNhRtGE0p2Ivk9Nl8AkFn4lEZTK3kRVpzNlGuOoky+qnta3poRnerY9uZJaU7mixnR2aVswvNDH67ZrfaZIiRneBTKm6HPRY7sTU5MqW7NybPnlBszj8WYb+xNarU81NCbbcy5yOXKx1BblhAOMMMAraLi4gXnwyqAcyJq775MGfeDrrwboe2kadQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7okJVBoTTmEJbkhGvI+L7mVNF2AIhh/Ht1KOaW3uX4=;
 b=Zl2tMz4G0vlTq2FiwLxrqyB4YhNQfdwyYTGRVhBrmPF89EXCPBsC3Iy8Tb68jtbwTI3xCUwKWZvklNCETNyFJxD2IOpFZzc+qfvX+a47tO8cgiLGCm0tr/VVBE8Y+xnbfiGpOubd92Ck5jRheCJYHrm90MmY6gdvkIKx7pbw4JY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6296.namprd10.prod.outlook.com (2603:10b6:806:253::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Fri, 7 Nov
 2025 10:10:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 10:10:54 +0000
Date: Fri, 7 Nov 2025 10:10:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Cc: "Garg, Shivank" <shivankg@amd.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        zokeefe@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
Message-ID: <671d07a0-0041-4825-9e6e-978907cb4d29@lucifer.local>
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
 <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
 <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
 <43a8c8a6-388b-4c73-9a62-ee57dfb9ba5a@lucifer.local>
 <77a54f63-f5da-42a2-b24d-5c8a0f41d1e6@gmail.com>
 <0b84865c-5b23-4be6-9902-af9d5e63c182@amd.com>
 <0e616478-96d4-41e9-b6c1-fa641c36fba3@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e616478-96d4-41e9-b6c1-fa641c36fba3@gmail.com>
X-ClientProxiedBy: LO4P123CA0212.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 94fa66c0-9109-4abe-b670-08de1de5efac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eupGBJYcAZbS/niuEB/rvOhTXMKNKYUNpqRh0/nqe6yJaUpG6y8ou+qH+Eul?=
 =?us-ascii?Q?nyCp5FlfAp32MVeL5//rlwCXGjRGWAjrwmBWWRsxueGNvEgr6QCAkv9RAXtO?=
 =?us-ascii?Q?6SiW56pJmoEj4vN553BkZ5dE1wvqGbtR5LiZomw2m9TDvNfCG1BJKBnXuRYt?=
 =?us-ascii?Q?9rgpee8Injaye3GY40QNSwRKe84vq4uxsU04MxJUVHJBT8AadR8VpX/d14Tm?=
 =?us-ascii?Q?WEsqzcDER3Tn2VFC74EWbeG8Wg+R29UQyyxVfHERYIa9hxNXLS+ZlXXiH6b7?=
 =?us-ascii?Q?druIXhuvPGZt06ZhxeHLnkr9QTbR6m4D50NTTylL6nje5VKhyg4z0d8ctjtk?=
 =?us-ascii?Q?NdpnUZ4GPmgQPf2MQ8+AeAXNIPpiI587sd6VP8z/Ihl3JQQgLgMLoS8buakp?=
 =?us-ascii?Q?htEOU8UMwhG8vGPq8YJPGSd46KV0+sBkdm1wo3vf4sSMcMs5A+MMaKRkS1jf?=
 =?us-ascii?Q?03ukR4s185pa1G10T96V4Xp3MSrZXviSbYAUXDPrVKSh+YpXbSNybVDZBFt9?=
 =?us-ascii?Q?/KhPQW7qBlR/EzxPYy6MFkIj8aJcBQbBLtXVGAH4ZOmKFR5I2kyWEceaUAVg?=
 =?us-ascii?Q?+EK6irpDWG5oCPI9Zx/SZCvx4uLT2tT067FOlwcUdWwfv6v7zVxT2AR8RRoG?=
 =?us-ascii?Q?jqjvqwsIntQrA7GOW7/s+gSjuw0PQdtiMJF4X0LJIxCsnwbO9Q8ayQalL6yX?=
 =?us-ascii?Q?OYBUKmcQnVkwAP0B75hAXIJG3R6OevsTqG4xdxt76euYr3VawZQrJpvq8Tne?=
 =?us-ascii?Q?F7OuERURO8B6Hj5ytZHsAW7ePiVNrYRZ/PoK+COkNX2FvmML4DhrBZqMb0Ri?=
 =?us-ascii?Q?4+4O5K6n2DQqG9FgEFSOHy8HHQW6OLrmdvMssAAdGTMCaizLsrmwdPmNTjya?=
 =?us-ascii?Q?FgO1MZBsu5V5+HPTRHJ3hXsBkerJrH8G1SYcqqZFWaoNst9Sxi6C2CjeTk+2?=
 =?us-ascii?Q?pSUysNLKceEQOYkzZv5as6NdRf21M5X5kgjPpZUkjlR5duXEk1cYKzbm868/?=
 =?us-ascii?Q?KjiqGKD+N9gGM3XONT8vWdDCuATG+szU6y0gASQdYsus7pbSjBCxyS+XPCNO?=
 =?us-ascii?Q?7tGrVP/Z8BdlnOHYyd/lGYcxNGKE11sqQ468vFDY4NOx/HYDCABKXDbOzO8B?=
 =?us-ascii?Q?N7+LsUa7bZoyMBseRNNgOgSw1AuIe13GGAiEyUzYDkh39Ti5ho62v6tuN3lN?=
 =?us-ascii?Q?+1oKAA2ij0sQFNnbGgHZiLrynSsrS/xB/EebvFBO2dbl3+nWHiqMkYiLWvxB?=
 =?us-ascii?Q?ce11oax2nkOFoSuiEZ5xFJhURHbjRMg8jTpZThqvQDy+87xMJ+UIf3JMWyzF?=
 =?us-ascii?Q?mEH2Cq0IQrcBmxqQvIpSTUvzVyk7NY4nk+8Ls/ScAhufpm1urMqjhRdWymre?=
 =?us-ascii?Q?s6j/0f+30YosRMrsAAGUbjStfKlSHDPhbdee169ijdhJx9p/R4iAUnQYSyyf?=
 =?us-ascii?Q?iUahALMY+R/AtEWR6P1SizIt6++1vxC6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U83vji2pWUnZ/0TXTIIl3xti4+7mmHvdKnGn+aHMVR5bGXCMlD02z3AnqUmX?=
 =?us-ascii?Q?wDmNZFV+wWQ3X6TtcVDWXNOatT5wVfsJqsyk4Lv+UJqcbSeH0sliVpgKcXch?=
 =?us-ascii?Q?RjnF38sOT6NW4tMbQY1Z3pyDO7SxIiv8OQvxz7wvvIgmJxUwHfc05rWb9+t8?=
 =?us-ascii?Q?mCUyPXJn+z8GYW0cA4Vn9Zs1Nm9uiGJedanmhnrUf/UpjNckm95L3qhZRgd9?=
 =?us-ascii?Q?vdxNInFi7UHp26pmNXbsafCRPjZM22DQfwiID8OVB08TYmZ9FdoS5CFG3mO7?=
 =?us-ascii?Q?XDrhKvQ9pfLWecekLpx3H/4wW6MjU+njsY6ENW+B6EumvevFyhenDnHqMndo?=
 =?us-ascii?Q?MiNIwhkmxMrNs5FhIH0T7hMbD2d8eIhHsZU3zXXAffaSdeG7i/HOa6aZDov7?=
 =?us-ascii?Q?DkvK0K/6Opidomzp6JKwPFX+FVttmyQ3/SgNXMgsod+gpV3rud0vdiyw641u?=
 =?us-ascii?Q?uEMXKmduUCyQhWGKzehj/9j1BiDbPT9YOucEb9jRLuE8D97o40GuIyFxAsYk?=
 =?us-ascii?Q?718gYDDeIPeLKrjS2UhWKAE2vmfVHtKhswfYb2w76//lPV5IAHlnZKhesk0v?=
 =?us-ascii?Q?FD8IRlxyiMcfKdEpijOJ2IKdPpgvVgghMJRMpSoJzwkCN49si+eNNYOSam0m?=
 =?us-ascii?Q?t6ikTa+aTaCpIHCIIUXlOiK8td1BRd3/uHbyd0OoSDC6kmqfp4fVXMTrBcYh?=
 =?us-ascii?Q?53VAevGbLAd62fTpy0kSktgwPWXinse8wJhWbkwShY5h9P2R2TMzGmku5j2Q?=
 =?us-ascii?Q?tZflYEWFSymh/89VmUL1BOUhTmK40YQipzh7HuyZerW1pPA0yFwv856h9yJb?=
 =?us-ascii?Q?NBhrz11E+1c2ZFHwkTuqSxVDt8ISb/S8KHxYf4zZWB1Lq3dFLFYpPX1+e86F?=
 =?us-ascii?Q?QpiqH9eRByDoa4GwwHMPdMUVkbzGvuuzLLAKMwnmlNwtSOK9kdqu+Cp+eG4E?=
 =?us-ascii?Q?y61rQzaOVth1TWROYJByiihHsNSaZS1ifatpbU+QfyA6yuKhti5A5ouIhOTM?=
 =?us-ascii?Q?21hgdztBeUmQyP4BTXzwJCE/bu4X7TZNc6uN2oW3tUn0VvfooJpgCFwCm34X?=
 =?us-ascii?Q?odmsuGFw9T+g+AXFgUmZGO+YVzEa5VXF7xUkLiNeKurY0JtC0l2+EwPrauvw?=
 =?us-ascii?Q?1n/ixxOezUzDpNvHaYXn3qRZmQTNmrECr8e3/m7zhpE9OtlkzqgBIIokFdwA?=
 =?us-ascii?Q?3bkljA/V38wpwm5a4fWOyLIMS1XKFWLgHtueAFGNHmr6aOzUm5yEesaMXxoJ?=
 =?us-ascii?Q?Em5KFav/gAhObNPtIWWvjFLlkhC/R62z9NL+2T0enFmlo+aWOsivEy8IiNde?=
 =?us-ascii?Q?lZPrlNRJ5P3Yjg4MYr6xyK+IfS7WLxnvfnl17OYQHuhr9Iu2aukgLEruFjM9?=
 =?us-ascii?Q?X3fY4uDt+rl/8pNmFxDy0MUwdZqRRlDCMUGzaHhJtHfvnf4LeNId1Lkjv5a6?=
 =?us-ascii?Q?fNutly/kYWcPa8sRjvbuJ3+tMI4SFFncF7g9Nq4rZV5WRA1Zwk2Ggq1pTwLC?=
 =?us-ascii?Q?cptfIYfoPA3v29vES+wxqKgrLLCKudZE7qQjeehCLQ79H7cGUBVA+LJXwYD3?=
 =?us-ascii?Q?u+8QZLq53IlMHf3HpRvHkH2L55uwWLMQ4flnmj0Hb0mtC6NS/mlWbSP96VLr?=
 =?us-ascii?Q?3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rmzdU7WkH+MSm0k8afpt+g+TFtLCA3L7DSp2BfUUpcHwmSP+AFF0lOO2gChJvpFvEjuu5nRZ1YSfQSuh28AFI0YCXkvGgVNsfLOmqfQBkhYm9h7UspbxlPolvWlCXV286Om/FmBcuzL+035cPS7AQ6eNWLLe8JL847jIeiXfTQtAYjgxXqkC8nmwHHR32KwSPAE7v1XGiqhOOsaVRUZ6YduPSPvPAD4O27n0lSuytSNCQLAq7ccGTsQ98M1FXwt1pdMhEP0MYuQH0zBFAGZdGVk8pJ8LzEO9FOqCipqAW/wqJdp9+EkLhCObCgbZStguhI+fCEUVXNQba3Rf8vQBiVoDkIk3IcOEJQnC51OWqmT9wFuSi+JYxVMnkJ8cjg5XYggOg+ig4c5HzqXD3YhqDt0EwIROwYy1Wior1AufOdyWECxrHGGE2l22BThXByyGrhoOauwFwwmC4LOajlzehqQS2cKbiv678okT62+vlhnHGQ7a/knrMOP0mk0siSOD9zdWrlKi3OakBcrCjD3zi0lQ2ra5F08pUtVOIC0aicVZfIKh5wOd6v1rA6r7YOsanstdhc/JxeF2Y8fPs61eJF2y8mlbLypPlTMXh4FgwDQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fa66c0-9109-4abe-b670-08de1de5efac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 10:10:53.9530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTS55fTka49/Xb5Cw7QUJLdtDejQXutWVb1SQWAMgpyALhg5cQO06oWGfkzP+Pm+R4R+qgsLE0AtlWauMXe1pIESUsln6brssRCbDPbkGUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=740 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070081
X-Authority-Analysis: v=2.4 cv=fe+gCkQF c=1 sm=1 tr=0 ts=690dc5b2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=DMEIo-l9ndPevZZYed0A:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: DlXDqDDckZ4Q6qSVKgB4MCAbK3RliAfw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzNCBTYWx0ZWRfX8+zu9dpbxfTd
 kIbI91er99qzjeCWX42mNvYp+7tVOUN8TTKEU2NmmrZpKNL+zrQXE/hwDlJjvXmIh5/sIHoI95G
 t9oo12Bz27fSr7dG/9kcmd72AaZhm4DNvaqsH2gijraIUHqeDFwqPq6JHRZVXKy9ntYtxAPReLk
 x2IJmPB+84ljCp7R4H9acHhgG3ihXDp6e3D4xwowoFh3kcJAQyxDloxJ7AEM5O8+dFfo3NEl2Hb
 hz4m9jEvO6yaXbVBD+g0epex6sLD3J0SuvWemRXBRDtzmognGBWDZERFAHvGgeoQhSkOe1lheig
 xXXyOVpQUnMkSHvarvLBfDHh+gQ1Gmg2pxTUFh5JdTmqjT9UeuyXyRQQTrEd+W0BlWptj2AxOT/
 fePOtj27wy0rRA/lDHGsD6XPV5d6RQ==
X-Proofpoint-GUID: DlXDqDDckZ4Q6qSVKgB4MCAbK3RliAfw
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B6B83A000B
X-Stat-Signature: qbqufbat93e5mkq34ms6e9tfot6c5h44
X-HE-Tag: 1762510267-885249
X-HE-Meta: U2FsdGVkX19DsTPbrFtbHArNu9vSs9wyZmm5vnIhoBaZwPx067AhQPnvoSNCn2FE3dWIaC3n2MW5qfigT5g/I2JB7C2Tl70bs2OfKt7HxwNWflj4vQfIkk+ezd3zlGEB0AfbTZYR7wF5UoxcLjiBvi95qPimirPMfWse54qyQ1baeFuzMY786AStEFPMT+GcvBl354rxepZxW1uZvolMm+2JzAm4xWWuy9ewCqne99IB0TnC9kahF7QL1ggDVUyi3WDT1nynuNywoJO9GCvIN3uUux0HxWXGtGdHIAzYnaP9YmTlEZg15cpzUjkjYLZi4sM3gCtjobaEPGRhgWnNOTsigYAfY5ok+OJ216/UzWPa4ZeApcT5+6OzAuKljjt8yUncoyKie3VWpP1qnnzAkjeSsiWrGMF3zT3UP+loRd2UZwmI8NqSTxZOc9tZ2YIPWYuKazjhpriHJCU9Lm+AVBJGs4KXuaBN1IfNecZVfPXPmIJhnBm8N21HaeTmNMQSISCA7yDKc+9zr9ue2XnNXwZcAC+AsS8YsplaEUi1KUY/Q3ncF+w2kyOT88tmKbpiTnz1raiMwh2VKeDvW5D86Q+TYisD4wtYAtRXHG5KTWVak8KDhGfrnHLdQbbwsa2i0SAbdatoKysjLaZio4qeFl5pJ7qUu33jhtx3YotCWUXvc97/PiQVDeup5Q7wdms7JXgx9TixsK+1KYEN0BXVauZzVVbhA5AzMFAGcH9n8fS1OeuN8rp+TGP2iDdmIdii8rWbZ4SSH1ELcVcsGS8P21rXsenv6WtBNgd7UDHofM5bCjAy97h/WdFKTwp+5Sfy8MtBJ4eOXXOjbjenryrX0M79wCdnGSL7kXrc+xF9zq7qaSbKSy9AfSsoOWC1TTpUIRGzBk5yJ4lach9z3rACxHG5WFYW81Gbr+AwQW0owBREpf2U8H1Jd0DVgV2TjBHbpl/wv7LgtbTbHPBm/HH
 iS4/HNW6
 k7zR4y4ew3XaKJtTkT8OvKJBfFZHGtFTWvxJ6gtKOWo62IpM9p6zNbR/MnkoHfzTcj7x+9R/tjcrWBrH7uk0BYkkazSCX2A4qEVTH63JpPxyLfcI5YMT3pI8bipKc77xyRdxMdKlqrZ73xxuLBXZUVEb65CV6RZjbnUbLzTQznFYAwAAdK0AY/jBz7PnkU47atNkPP+C1FFWFKMMvjiw9eODYS6WBBXxghopOAMAvJN4P2Uo7Iw4S88N9uFzdnjNyQ4urtqDNkx8xR8N92nD3vUw2k/m//b/l9Ke+OTZcKvCWArt005nNlm7aaXPPeXSdiIahas5uC0cbQ53TluAjqkh5kAFQFQlqIfYsOFXRpP6n11CzCjrRtSpL9lymPUns+EsgCHYfzCbH9LvjSwgsM2XK5xJ04h9SxjWImmjxX/FMB9K/ZpIeVclz0pegEPAlPA+zAyuuVVAz9iPtXAKIeYQQf7hJugrPbGcbDYDV22/sB7XuhvvT9pAcuEcyJHSVAatO5XETotAw4ODqpqz8PFIugAVEXPSFpRsRtTOL+i+6CokL1dvWjMNqObcnrdXFbE3Fl6ZGrk8IT4M9Yi7TRx++BtCWnOGRhcDib9HoHEfr2uyB27Y+cdBdHWbSymega4040oOsKPe7bnu7cqWCAMYwDkGp+nWyWAtH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 10:12:02AM +0100, David Hildenbrand (Red Hat) wrote:
>
> >
> > 5. Yes, I'm calling madvise(MADV_COLLAPSE) on the text portion of the executable, using the address
> >     range obtained from /proc/self/maps. IIUC, this should benefit applications by reducing ITLB pressure.
> >
> > I agree with the suggestions to either Return EAGAIN instead of EINVAL or At minimum, document the
> > EINVAL return for dirty pages. I'm happy to work on a patch.
>
> Of course, we could detect that we are in MADV_COLLAPSE and simply writeback ourselves. After all,
> user space asked for a collapse, and it's not khugepaged that will simple revisit it later.
>
> I did something similar in
>
> commit ab73b29efd36f8916c6cc9954e912c4723c9a1b0
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri May 16 14:39:46 2025 +0200
>
>     s390/uv: Improve splitting of large folios that cannot be split while dirty
>     Currently, starting a PV VM on an iomap-based filesystem with large
>     folio support, such as XFS, will not work. We'll be stuck in
>     unpack_one()->gmap_make_secure(), because we can't seem to make progress
>     splitting the large folio.
>
> Where I effectively use filemap_write_and_wait_range().
>
> It could be used early to writeback the whole range to collapse once, possibly.

I agree, let's just do a sync flush unconditionally and fix this that way.

This is simpler than I thought, the key bit of information is that we have
freshly written the executable so it sits in the page cache but dirty.

Thanks, Lorenzo

