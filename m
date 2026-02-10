Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66494EB26F5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781F86B0088; Tue, 10 Feb 2026 13:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CDE6B0089; Tue, 10 Feb 2026 13:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3E16B008A; Tue, 10 Feb 2026 13:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48EAD6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:16:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9F851B3A3B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:16:58 +0000 (UTC)
X-FDA: 84429353316.22.FEC7F2C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80CD2100013
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:16:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=anaBMy+F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TMFSmIS2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770747415; a=rsa-sha256;
	cv=pass;
	b=evKoin0wD04HA1LVVpxP5Cq9kau6kPf8+ADgIlPiY4aQPisRAG1GUUp2soaaYmJ9HujRy3
	mAr+4lq0FyuePpB/gMoxb1MBREDmtej68GpZclRyQltVg5s3RMUbbz1maU1cNZssGpcE8m
	EZ816l5Eso9XWdCgFJ0A1nvxQB1tlhw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=anaBMy+F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TMFSmIS2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770747415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGHzko8XxXghxVAmtHtERnD5iHm5ZgkcFwYcP1kEHBA=;
	b=Xdm/+eiJFABeAKif6vpuCtEaphVI7fVrzHgGRhVF/Yh1FbkD9rCgd4aiIi9lIkNles+Rj2
	AfWT1V1NUqbtz6PN8DOMgxGRzEzL13k3Vyr3gQw708W06WrW9R+g2Ui5eHHA+7rBHrTnQ9
	IKeWC+G8RHwkb3G9EbFXBfHhDtjX0vo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9vJLr3998033;
	Tue, 10 Feb 2026 18:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mGHzko8XxXghxVAmtH
	tERnD5iHm5ZgkcFwYcP1kEHBA=; b=anaBMy+FZRFt7S42paJD7D8xz/TM6IQtQX
	qdfYq6AS0jeB78pnjvzjQ31g0pz9zbvxS0mu9murTCEBu0R7aCneURtW0abpFNZV
	pjgYyzfbEmOEk86kxdrOtfa9u5xTUJUEmcYyvbv+bYWUl2x3vSREhNIu2cKYnxVw
	Jsus41TifPQfZ05ftgwj/xLTN3kGkGLi+6yvAfJ6P1+DofwtlklSzP1bi5H5IAVb
	IrdRz8YgAPgXrnrFMVkPvAio4S2VTjoeWP5McZUfbCwjTWU3aVyyNWnKKDk2rVp2
	Hm/yhTuoBlytZmhbwxNc4KVG8O/WCxfZWXL89bRNvmyLWJjKJeSA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp4kk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 18:16:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AIDfJv030223;
	Tue, 10 Feb 2026 18:16:36 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013067.outbound.protection.outlook.com [40.107.201.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8228ctaj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 18:16:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jbH4SU1JHkRC6Ae8hKZmIrQ0S+VGwgZJklXk0YxTyKHCXp8mhKRr4gJf4HrB0nECTuU8xqe/a/bDr0Rj2xoDKQt8tWrOpxWOBf4gAsNFJPOIXb+AnyEgAerXh5cZEhEV2nSWcR3gFEtbjlBS0tsaL/42J3KrfDAvnesdel0Z59kWAAQwYvwHOJ4YDB++XVdEaq91BuAruOw7qGmNO6mVrWdvb6sFfSPcYt43ICOh3Z711/7UsRfYTCqBhoVGawzOWGeDhdxhbzPbG3sN18gw7nLt2f7G/tEt8ji2Ck25zD3XGpZ/VU+PCGW8QCrvkk5nQ2baw3Yl07KRA8rhyTdkgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGHzko8XxXghxVAmtHtERnD5iHm5ZgkcFwYcP1kEHBA=;
 b=gXUARPdVIWwCZgS06Ob44KUkKLYj/wCO8eAx/rxak5QfQJlnJnaGk4ChyeWrFpwl6ZYDNLVB6dpHFXsuK1d57C7JKbc1YdsnE0K4YIOjhiuI6XxuViXFt3C52QnIZJw0gKoQrI/Yo8jK6tHrSNiiLczoI2DCj2ZgWDrnzH0mj8Kdsw920P1H9pocvunj+liNe69oRVsjXGHE2q/DzaWyyCMSlzLGXXgtlp6oVW+8BQhX0hsmwu0EhB/eCK32O7GOAs56joRcBijGboRxPUHtQbfiqwg6JOowVNNYS57/6a3Z4e7N16ChMLybhC65wv+QTGupRTVQkTRdfO4FEmbBKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGHzko8XxXghxVAmtHtERnD5iHm5ZgkcFwYcP1kEHBA=;
 b=TMFSmIS29TfwpaaYCSEJWRRF/CqAyoBBsOwLw3eCo6iGMYBx3jL3BkaQohV4cUeBZP1UZs6Uo/I1PF0lE0en55UqpA1PKuQxjt6q06vlocNaYxVTkRxJgGwtsjXtJbks8OlItKqHZm8LQHY1qbv5llvw2ax5Vi0Oghl5Yw88/DY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH0PR10MB4844.namprd10.prod.outlook.com (2603:10b6:610:c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 18:16:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 18:16:30 +0000
Date: Tue, 10 Feb 2026 18:16:26 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
Message-ID: <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT2PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH0PR10MB4844:EE_
X-MS-Office365-Filtering-Correlation-Id: 38c9703b-554b-4c4f-23f9-08de68d08362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XNThK9k+MxCoDc9t4c4Tg3TkR6RAI43X07AbAeZUD4/DYvBW1e9pa1WBxCNM?=
 =?us-ascii?Q?M+Hpdq/sg+aAODtNqx3wGAtR/wyZG4frdMFzt6uk2YZEJCN1ooaMxF5PeEB7?=
 =?us-ascii?Q?hgrP3m4Ts5BdAS33JY6XNICw37Rt2D4wsKECxTg5R7hXBLMpPNeUl7dNashh?=
 =?us-ascii?Q?IZ1q3/1GCgL24qs3cDKvVUP4+vL0yFHRfBrFS6rN8kdlgN0cB/G3RJgirS2J?=
 =?us-ascii?Q?cZ/2Va5Y7+VeJjwBQdF9Wv/GJtGpIPef08jsnGRGfkyM6K/OfbOni/si365K?=
 =?us-ascii?Q?8sKmPU1hcl1DiUSBzYm8b/EJKEAssj8oB2QNIWfGNj2BDG7iwuPoJURy0dP1?=
 =?us-ascii?Q?8q1bGC0DHGmHeYhHcEVZFG/VcOha73kFbDQgIP+X0+HQaq5TDJJW95cTHhWv?=
 =?us-ascii?Q?J3oEx8ZotLWUc47mfxYZTgdRBQmGVt6N49ndrWdXPoBhI+Z/xjcaUFuAwjjJ?=
 =?us-ascii?Q?mNUlvud8dEVwXVTgUgzZXoG9dmbGSrphZgfmhNW9AJTG4TU7OUYweABWPXE4?=
 =?us-ascii?Q?6xuBERa2WPiEl9gNkojDhkTgLvFsXHWKZOdORhVmK2jGHEgIdQGHJ5QYMMsU?=
 =?us-ascii?Q?sAnJ/FVcAuIPk+4CdnEw3oedxYg3WIWNd7RxEHxSuqPr6l/Ez6l8NmK4XStF?=
 =?us-ascii?Q?1X9S9daykpYzeoM+vK3cquzzQHvEUko1OemjZURBapT45PV94FPGGA/p5d6B?=
 =?us-ascii?Q?rx9cmAiCJBMDsH6zoyMw7R7RpKhhTFhZn6JfQU8K065p8PMEchaX/DSQfDNL?=
 =?us-ascii?Q?zk27EoQuoiLePwDkcsd1YiZcOpnfDoEOrdan6HXZGTjBmFK4GC40YbIO7G1g?=
 =?us-ascii?Q?n3WCW6xH6jRZb80egAj9Q9ofVjfNVeZMxbBm8E5j2DkU3KbTX2GzIkuAn1WS?=
 =?us-ascii?Q?BRpY1eICI7yg27Ee5BgJNm5mXdkqN5l2NkBV9feLC2o2littiTKqtUPG76Ok?=
 =?us-ascii?Q?zneYIaK22586aOcEORiZzkZD0fDA7O3HexJRVCHbIOTH46EmYzYe1K5CB+Ws?=
 =?us-ascii?Q?qzR+ttm0XqH4xWgYnZdRzDce6qSB2odiMch9nFI1Fb35HAnjN348GIyqB2U3?=
 =?us-ascii?Q?Fpbfdy3rODTSRaRErajHhoc8W8qdk7S/POJcnr+liLzo1HyW95cJLUoRzcGq?=
 =?us-ascii?Q?GlDQ8IG8s510r3quxP/Gn3t5tftVSrF5RsWdwhsQSoGb9/I7fyok3JOkCybb?=
 =?us-ascii?Q?F4fUVUePdjtduIu45bFVElgk9CE6tY8HFdHSOuOyCYEc8yoTcFv4cEny5c0d?=
 =?us-ascii?Q?mYv8DQZcBw0kHHVRPSe5h47TT2tyUldCisewvTW6K2k8n6fZwXCGAO0vp0Z4?=
 =?us-ascii?Q?TwhDm1Lb8Y3LL1WI56yBr2IEsDPriBN6N5OH7hNzEqX6x0oW33uPkNBXTU3i?=
 =?us-ascii?Q?aI0c84knsZQTq1apG2rSA/Q6perCQz3zkw5Bv77C7qp7rXijyMq/E0b9g0t5?=
 =?us-ascii?Q?Ff5L0v51DO/49rOCWGSUe00HZb6EPz1/gZc7nILcf03jrAfQmqR69RWISh2Y?=
 =?us-ascii?Q?BlRfjuLzYzi6rpB5xs+wsG3LS88P8bAQ5zzsDKA/l5yby4kGV3OG7wM2nh1p?=
 =?us-ascii?Q?pS7gadpaAp/SMXRcFbE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WxklP/4AVxdnzojgF0x0PIO1cdzi2yZ3w826f3HuuR2pTS9QwdUOIqKyLLIn?=
 =?us-ascii?Q?0fwaFX1lEjGsVKve5V90NL9eArWBFB1M8tztRp5MjTY9BH9l65p4xQ+2/Rci?=
 =?us-ascii?Q?5t7HxxshcfoeY3T1msDFKEyLp6mULyxbA98vS9oqgjartfHR7fAemk8rkbiH?=
 =?us-ascii?Q?6xrGdtxQXy7lu3lLzHJWGhm10+OdNepmyYE6lzVWqMCEFqs1Qdt7mK4ZnR0I?=
 =?us-ascii?Q?h45S3nxptvdoEZtmwRuHaStH/fMJnQa8JJr5bTpBxd7QzNZfit8rdgbxaVtH?=
 =?us-ascii?Q?y6PN+nceTvdKRb8fxZDX5csc1Khdz0JVjS5BuDbO0YT94So0YzeoaSGqQNuM?=
 =?us-ascii?Q?sqaarX0smwuAt99F8QVTHv21tMrOolNALpMAWMngqtX8vX3mTNEKa6528kpi?=
 =?us-ascii?Q?NPFfWaqvHr07b96JZNk5OmNvtAM2E6v+/n9n3EEm2AtbdKMh18fdX1CeGcro?=
 =?us-ascii?Q?4eLxsw6UFBCnLWRBdZ71PStZlmjmQInmL9FnOeor0V+EPdMW0zKXo9txa9FZ?=
 =?us-ascii?Q?46A708ZN4GyQ6cmlE5w6lW/nrfFQjqAqVWxsYSutgKAlZNoktMprscpdeh36?=
 =?us-ascii?Q?HnrXUkiRA0Lj7gslSJxzwQVkhwQJ5jr5Cl4cd8hVOKFlbQOKwI4u+G9q8ili?=
 =?us-ascii?Q?3/1m5RGbtsAAxMul79SQUihMoVnYIuorZkx8ZKM3Z+wDmmySRLEl8HHF/sF/?=
 =?us-ascii?Q?zaniET1GLkmWtXvoxqzM+TsncTNaFmKBir4lD1G9bhRRIvZ3Ppj8/INj42vU?=
 =?us-ascii?Q?5oW4RDqee9B9MTJafTbyiCoshxW+aNDuGhoRKzimVFsuC544J5Wz2v71j8pi?=
 =?us-ascii?Q?s39uY/l6fdWh70Ixnd4UvQNAQda0jf67A4TTckHzHy5BkoXJZ7BBgikhn3hJ?=
 =?us-ascii?Q?8Ri9GRpDqOb+SMg+TQrFOIF4MbytNGy241AIo8H+949uNRscSropxInQWC+j?=
 =?us-ascii?Q?zhAFXCyagVMEsv3tvvVUyqjTZpaSFQzUF7SkaC45HhvJbSPptvnaf4zMnDcu?=
 =?us-ascii?Q?LTqk2FclcfkTX9qY7GTvWPvKtyfYV+PuZ++oQ9NcZd4Baxsad92S4bJeD+pa?=
 =?us-ascii?Q?gDMqnfawO0poLIcei9SU8N5s5Z+a8DFuyA1UH0ZQdvGieLKJaVjxgxv+Oa7F?=
 =?us-ascii?Q?LQy7HXbIJ5wr1ezNzAKNdcHebJ8nTua+PokjzINbL9ZCEmPp5onBRXIUuIj5?=
 =?us-ascii?Q?nHK4+Jsyqvjsx2jMlm3SxNcPWAvO6LOzLlWCExCn6E9FN2Y3TEd7w9iLWftE?=
 =?us-ascii?Q?FUPpYgqyhXeRB0BhMtom3XLC1wTghVCmHMHih2Cb7F+KAxtELZn505IE64ki?=
 =?us-ascii?Q?QhcZEMoaMjCCV3iRIVdBCWaP9AzjznzDIvQDPc/0Xm74yiouVzdb9OyYDM2C?=
 =?us-ascii?Q?o5ZUjScSl/aqPXwyYxHhcCe+cSESdHbAwoa+HBmjkrEhuYcuVe0rCSINAg9B?=
 =?us-ascii?Q?nv/YxYuxS9jj+Eskw0yFZOiwfuenditjgwc9M1RWkkuq1oDoHSDJHvvroZuC?=
 =?us-ascii?Q?j7w/WbtkQPNDle/JI+8oCU7PDEKo3tr/rf6UsL+yr/nqaxru/nwuWfxzOLwa?=
 =?us-ascii?Q?JPsvCzxlLpdHfTNJJbwhvuxIP2WqdSmkS3vIAbiW+uTfg/jKK53f8Rp4pYxJ?=
 =?us-ascii?Q?IOdPuHHthxtfKr/zQ2vmha3Iw+9YS93qBudP3lw6ECUN7qmqmemjsquscEoa?=
 =?us-ascii?Q?hwDefUO3ON10CkKbSAuBxZSjJiRMbSBdpnjKQ5ecnukMBknQjKR27NCFT9dL?=
 =?us-ascii?Q?WMBpv76CvA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l2545VMnP2CgkXnt98QzBgviHTad8wEXXOQ0b7eZifGiKElTvU0BcR4cax3nA6vZ4cmHV45FxZ+0LSlPqc92hEh4SkTEg+ZNiuY11ODZkjR0S2p4IwfdQIS0V7B6hmCqJiFV5PygAgmmoZG4djfKV5KiaYMO5cHngjp2HnOjl8DFTiNRuhBCmE+S9C187ro0LYNMlQhbXeV5KoWlJoo0Tu6EyTelTgX6V/lQoObCR4u6rFkJ5/NN5DutHwE7ePaBlgNYP6HfSeOqFbZAQu/kgFBz+BKu8os/ekataUXC3mvp+5GpeqWdrMWSCfp2BL3M5TPWNYXy0W4bYNKvvxiGTKb2/J/E35CN85RX9OYCSLh0hle/J2N29L9UYnr93hYU/0b/hxYOyM3EFboy3f6rsn2WTX1U/LrhlILboxzcdsE+AJD9t4SXb37+gp/ynC+D36r2fzzyy8ok7DDGA5D9DDqV/pe0RF5kxVEFq11Luwnw3SGOvq1qnqXkFHwABwoRoE3SisocE6dk4MvLf3xfFxLMNuV2J4YX7e9FvIkXrbPFAnxx26VIQnxecn4yidkAo18T59TCsgAZ3NwLK7BQRGb33coGsXc9pTaGBPB4hiA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c9703b-554b-4c4f-23f9-08de68d08362
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 18:16:30.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qg8MU4uIUw37R8s/BrNr1Cr09dgIFY4YmBmR8s4DVSkXbd1W0Kou6onquLwrMTtwL/GjNt3fcltwCCt6n36f7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4844
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_02,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE1MiBTYWx0ZWRfX/1Cvtx2F8ICU
 V9wU/JCF9w9iy38nEntDt1e9EUcbuwXe40KzZbgDrJ9PPE0rwZQQOrqJO4HNzJ9N+I4Lkfqq7ro
 dF/xqjGa/gjTDle5Pwutlw3syW1lYQlOgOyeatYOHS31VinhjC56QOr5B3EoSAGGrXu9RXHL3NK
 83F2A7x018GIE3qtsKEQH5AxLlZzyfCMx4ERxGLozXYr4aTG4UAZYogaNFOcMz7jJYifbHCYHE/
 flGKI2gs4e5+81c6pbPBATNHRTRrsLEyXLB959g75EdocuRVVxq47rnbAgTQLT7yR2weuXbf9Tb
 xibFiu32o1aiJwgm/EZAxQz+Kh58tqRgPqyKjuSXp25k7Q1Gd9Spx+cNrKVGdn9UPwXjS0N6ZOJ
 rwjkSP1Y5XmYPmNgSUiWXSUw7RxU1qG0QBd/Dwy7Pcb3pQJJfkQ1YiA+taujt9Z77xiopm0YHSJ
 WEtLAMJUJeDzB4w+VaA==
X-Proofpoint-GUID: MS-ArYCXOA0yReAAQko3tDXYuBQnbREH
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=698b7605 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=USwm_9gEGrBugK2Svk0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: MS-ArYCXOA0yReAAQko3tDXYuBQnbREH
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 80CD2100013
X-Stat-Signature: p9cx6z97wcr5jk5kxbfc1u989nfp8dp9
X-HE-Tag: 1770747415-333339
X-HE-Meta: U2FsdGVkX1/Qzt5a15WDDwLv9TkYGU/A+CsnEehdV2oRJ+0ZQJSva7hvHcnjxQzCYmid+pW37OEIRwoA1x5VMGWr35tQNN4Dqcj5pgP8Md7VZZcJ8owGT45K9cFE4HYLj8xLXg6295uSH5X8ddsRsnXgsCNeRAhUKJgiNPliq38qCVdFM+8yQCW00SBEEWTMJi3si8nXzT3oR3awSpR41JeRkjpoi7DbudaM8uh0Uvz8gQhqVcEg0OPDNhx51maTle6EaFZ/EaGFLd6jQOUkLfcrRipPMmAKrkNH3H+E0p5uv4xTFe8TbaLTlCuldo3SdnNLJYxIu2pghq7XARs5WT1M2NTwdPbwsKyQyLQvj2I4of7zvI0V/QTbS0VOZwANInaHj93G4IfxlNW5ZFozWCK81Qq2wh13dc6lVbwA3mkpJhtR2t/0jO45khMURxOVrieKZ+eBAkwMZ0GodTF2PZdQDVYdQ1sipF9dbOxwQ6QMxG23xf205sNK7wuZPEVxQYLwfMlH7WmZXILN5NS4uG6JgyG5p4ELKAi90M+WQvCsPk2/j1OiKO56+qRydfpOT7YVZvjERZw6DNWJZoMwQHgxYdqq15G+E0b+7yQDIN3aexji+3QgnH8uFK1LW4NX8o8V4RF1OQ3IlSWNIxZKIOwZWiYAbiG8dX0vAcnTUIT2DSaXQV2vQQaxCE0Upv7YOOF2+G+pkzbaCxK/W/fqItjjx4qRGF5lJ52AVJMmRMtN2pM1UVdTWpa/QSJOEcLTFB6XH77lDlyeDoq6iPIooIdEEYCAYrcMQuAAvEsc/3MRIQxLCaDxeEBBTMItjrTCaCoIqo/+sj27LjihYiAedV7xc8c1Pbi70kbP1piaqVv0eWppFZUjvMhXtm33pT02rtx7CGkdjsCF+qhR3/vySyGYvwkqmNY78kJpJcVicTDVplMmcTFOTGvL3uP1INe/MIHrxO7lK3W0vpVh1VS
 mqLGlZ66
 07LSqOvLlnaPW8c2yZ4aPGJCQAY4sjeifk0ox9kPOsjyHTIERy8DelT07BQ2yhHr8e+UClct5u3YLT5e/iE8KMf5cPLLtkGTHSJXNdh5gt/0d++I9WsgA2eVx8mfPY4zg1MKE7OfQBHldPJAmuDOt4giG76queKAGB+lll2fKicua+LrEs+Kg+OEzJb43UipDI+4DKK6nyn6Xet7uay3Xhd5HVbPWENGNieYg1mRxOjamnuwH9tSdQeTr5BRA8wJgzTjijjyobwCgt6dAjk5JB0j6r8C8r+dBdw8gbvM0WEPcOL94KDT08GKwxTqEkKFptQPX+3Pd12cnzVuONBCSQRCZ0CyR9f9WmcMwXSy5tJ6nQMfEv/iyxQIgxGCFMmFcnHFT6a0SwLI2us4sZlNdCmf+F16Z0jx/9pGnZyVdmKlPBOewbqAP7uBh3J10itjx0YMmgjpPk+TfLBwZz05EPlEWaiu6IkQ0BGg/GwFZ8goYio3bzhkM9ldp3QgqeFbatA+4u92QKN2oHCeETiTRSWytSPS2jZFmFJDl01EPPLx9Y4ILFRyLzy1w9NUHtAebcMJ0r9EUNy98Pjuk/TXiqRBK77BnALCgMLt787rOz2F7KZfs3KSiDD9RElLE/RjOUqKFjWqwsqsdwQxOR7nuUZyn24lBFoMdKA+8XLp74ABFe3ewP2T4bsK70dJNqvz8iQDaSYtgbdDlncRs0np0HgMpoV5Se4+8QtqWAuiJxTXuZAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andreas Hindborg <a.hindborg@kernel.org> [260209 14:39]:
> Replace the call to `xa_load` with `xas_load` in `Guard::load`. The
> `xa_load` function takes the RCU lock internally, which we do not need,
> since the `Guard` already holds an exclusive lock on the `XArray`. The
> `xas_load` function operates on `xa_state` and assumes the required locks
> are already held.
> 
> This change also removes the `#[expect(dead_code)]` annotation from
> `XArrayState` and its constructor, as they are now in use.

I don't understand the locking here.

You are saying that, since you hold the xarray write lock, you won't be
taking the rcu read lock, but then you change the api of load?  That
seems wrong to me.

Any readers of the api that calls load will now need to hold the rcu
read lock externally.  If you're doing this, then you should indicate
that is necessary in the function name, like the C side does.  Otherwise
you are limiting the users to the advanced API, aren't you?

Or are you saying that xarray can only be used if you hold the exclusive
lock, which is now a read and write lock?

> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/xarray.rs | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index d1246ec114898..eadddafb180ec 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -215,10 +215,8 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
>      where
>          F: FnOnce(NonNull<c_void>) -> U,
>      {
> -        // SAFETY: `self.xa.xa` is always valid by the type invariant.
> -        let ptr = unsafe { bindings::xa_load(self.xa.xa.get(), index) };
> -        let ptr = NonNull::new(ptr.cast())?;
> -        Some(f(ptr))
> +        let mut state = XArrayState::new(self, index);
> +        Some(f(state.load()?))
>      }
>  
>      /// Checks if the XArray contains an element at the specified index.
> @@ -327,7 +325,6 @@ pub fn store(
>  /// # Invariants
>  ///
>  /// - `state` is always a valid `bindings::xa_state`.
> -#[expect(dead_code)]
>  pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
>      /// Holds a reference to the lock guard to ensure the lock is not dropped
>      /// while `Self` is live.
> @@ -336,7 +333,6 @@ pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
>  }
>  
>  impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
> -    #[expect(dead_code)]
>      fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
>          let ptr = access.xa.xa.get();
>          // INVARIANT: We initialize `self.state` to a valid value below.
> @@ -356,6 +352,13 @@ fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
>              },
>          }
>      }
> +
> +    fn load(&mut self) -> Option<NonNull<c_void>> {
> +        // SAFETY: `state.state` is always valid by the type invariant of
> +        // `XArrayState and we hold the xarray lock`.
> +        let ptr = unsafe { bindings::xas_load(&raw mut self.state) };
> +        NonNull::new(ptr.cast())
> +    }
>  }
>  
>  // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
> 
> -- 
> 2.51.2
> 
> 
> 

