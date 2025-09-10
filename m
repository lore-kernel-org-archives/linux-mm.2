Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC349CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073FE8E0017; Wed, 10 Sep 2025 11:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C4A8E0005; Wed, 10 Sep 2025 11:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C2F8E0017; Wed, 10 Sep 2025 11:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D60738E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:56:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 755DE52E2B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:56:00 +0000 (UTC)
X-FDA: 83873791680.11.6A3B2D1
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	by imf12.hostedemail.com (Postfix) with ESMTP id B594840006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:55:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O75m8XPE;
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.65 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757519757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecNQJ8L9OxyjeVCtUGHLNP/hxHpCw7UcmTPbPIc+ph0=;
	b=xOQW6yXBCxgi4TOvMCcnta0GL+o+X/9sdAotJTRYhdh0lneJjn70M48qKtDN3TtrIXmqIu
	tlY2PA9QYyOF+qrVPCKjKYg0/nuvpG928VTTAXVJLRbDXJ/v0VZAfppeFXUZieIpxjdv5t
	k5UTRn2DSVNYX6pq9IvAGTxqfLN0IKE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757519757; a=rsa-sha256;
	cv=pass;
	b=ME3FyPXkBTqcLguWZSc8CT+uuSicLCcc2qGeAVQ0QFycFnIjXie1fa3oQdtVP4EouVwqwk
	XovIjarnV1W4zGmVXf6B8NXVLV3ChYvsOhiLeglGVGepwBhPiXOfyatBBaVBawK6GDeLDc
	JdK4NAnPlpSjuvWECfPul1DgGz226Jc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O75m8XPE;
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.65 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/aN/Ap3BHV6pJYwkwKXah7d5/hNMWYKSuLS+rhBZbyspHJk2vDbVi44QxsPJTsq2QO/9aF+dzs1sg8zAuaNFbdMwyq2HGet1JPA3zHMaNzaZxfNV1PyAkBcMAQyxsQbugtsrQIG5ENDdf1zVCLoUR++fM6RUCD2jYX25CZwwwzUs3YnM46yI1Gwpej1ApPcgpxp3N3WNXI+FtWPiYYvCRwlDlbtMuiCM9wIxyGN1IQlLnktW+hziXwsmP+6vs7JnvcVzwT6/50x/iLBPealQtdNq4asnB1zKFskEp5UFo5FgMLe5f0mSM8l2p36QFMK/ZIstZfpdIH5VBcyqpfmhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecNQJ8L9OxyjeVCtUGHLNP/hxHpCw7UcmTPbPIc+ph0=;
 b=bdHEQMw3VBf7TN7duta9Z/NSavtwLJOEaQJvCNfFw4lXZnBI28h5Y9e6tpYpiPqVJJ7RYPxnKejCxqRXv3qoEmLn7Nz29LUKI9bHTwlkssX6xsP58HDIrmNzey0GJWbemy3WfaRe15dRF5LHS4uYurqU6mShQ94+WTYYDpY3u0WyA9Gz3ztyZ4oG3q+7mIoimqhhvCO2osUviTWfMgAwMYbDpZrhUh9KkMJJORnYHSdGPfmg7ka7UKFpI9Qi6LB196vNC9pCNXING3r0TWyBP7R1Pb6Z45d9JEaAlxZsDgKzGS9ziePmjZyH2Eow2Qu9FcBXkF24FbXoVZCgxhrEDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecNQJ8L9OxyjeVCtUGHLNP/hxHpCw7UcmTPbPIc+ph0=;
 b=O75m8XPEjYwsRxkE4yHRG/dRu4DAvll5fI9FCbND64IXOZA91f3dbByjYind70N2JC5Fu9i8ZjxCbPFgxoTbU+JiL/8hbt2iEflOYInhrukcnE0bEb7hSNKxHSP0oRGSxIgeb/W92AwXezaOwvUY53maxnO2N8GNeoFCxM/G+w4UhxesUpacsgX6OqbW6ibDnvXE9emV5nQ/L+o3lIHJ5AGYaVydBMlqf07f1Puwnqqbzf+qccOqGKtgDO0UyPJlRoMJuzKkal/TNqAArRh8RXkA/nno5xzZ4ESCU+KztOd5GyZsuL51GBMHucLk1ayF96Oyzw8yLDKCrKb6sTKGpA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB9513.namprd12.prod.outlook.com (2603:10b6:806:45c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 15:55:49 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 15:55:48 +0000
Date: Wed, 10 Sep 2025 12:55:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pratyush Yadav <me@yadavpratyush.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>, Jason Miu <jasonmiu@google.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] kho: make sure folio being restored is actually from KHO
Message-ID: <20250910155546.GB922064@nvidia.com>
References: <20250910153443.95049-1-pratyush@kernel.org>
 <aMGc-ExhkqwAyY_C@casper.infradead.org>
 <mafs08qimjoez.fsf@yadavpratyush.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs08qimjoez.fsf@yadavpratyush.com>
X-ClientProxiedBy: YT1PR01CA0146.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::25) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB9513:EE_
X-MS-Office365-Filtering-Correlation-Id: c8507a99-ff1a-4c50-d87e-08ddf0828267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HHJxuWHqfmlvIp0e8jETj5LZWHi4K/ShZtdBGzjQLLd5HPLX3kGEBY5jfytR?=
 =?us-ascii?Q?2VKi3FRcevOiEZkX78nk5PsUFgp38iwrl8Jt/teKu4zM+ab2ghHXmdZCEEsc?=
 =?us-ascii?Q?AWC8/6R9By3p9if29zF8PY7hOCvZWG4GFaHi+rdvTyetRibA88RVUmCtr7Cj?=
 =?us-ascii?Q?fEhKQUJ71yPtxC7aPRIJHABLirz5VRTteRVK5kg02681F7alnd/P/ctAXYpk?=
 =?us-ascii?Q?nsWdr4pSvhMAwwD5ssWCac0F4WWZxlLX8lwRpkJWToSgdxBEFpY7HtzL8dji?=
 =?us-ascii?Q?2wAuKSB5qJyuVwHu31dZYiG+of/QD3K0bWnLVAzoUYIqDgdtVLv8I7CJvQw6?=
 =?us-ascii?Q?Igwhb8XzX9aRE3Xlm02etiB2Ie+A3lzWosn9Q5j3mBisPu1kIbF3xfwXcJ5l?=
 =?us-ascii?Q?zrUbzlw1tO7SnYwlk53gYJ4qzkp4xFAVKXOVCI+mN/tU6tBIOE046SaPS+go?=
 =?us-ascii?Q?H7r1wLRH8AWKcLXFVw1n3kuxWNnTvj/apsw80AyWkJYkPCfuUozx6iMnpVaE?=
 =?us-ascii?Q?/9fHHAt5mllxZtKqsdQpTX6e2icCGs7ckw9at3xc4++N16viCCfgOnwJ9eU8?=
 =?us-ascii?Q?+v6zyFRzaSH+hCLXRWCDTsWpuO450Jsy1RQGqHrmYXAxw+dDCZ4VkC7flws6?=
 =?us-ascii?Q?udwRA8+MiYQfjusn5GR/+feJ/Hs1tR8eHzsr+EuHPmjzLo1O3N2Wpt0eXLUi?=
 =?us-ascii?Q?mUkPehOsQXO92eiSa05eIn6la1RD0LQ9aDZoQmOgdEOgOEvXHHsDClt4XdN/?=
 =?us-ascii?Q?L+bXjjdOg5VYjaxFeEGA+3urALPybb/D9I8eUGCC3se6lQ6sMiB+PSdY77Fj?=
 =?us-ascii?Q?fj0nmxf7yRqapeZr0lGvmDw6wa0GuGLZmNCfxd6r8Ny8N7Sr+P71JXBhnB22?=
 =?us-ascii?Q?96fgF8kL1RMXGqY0mfa8lKznPpf3pleB1kDyiGD3RlaQUPr/bVic4kFwGGlB?=
 =?us-ascii?Q?9+FuA+rSGG4Xr41GRt2jyf2rOIrDihJfeKKVylBopx9jn9e5zb8er5iIKEg0?=
 =?us-ascii?Q?ObJDIRq4LZeUMRG1agcEIROHjvZQOUBNBWzQXWj9zj9nU3gU6+E+RZL/DKs8?=
 =?us-ascii?Q?ZBoOIpHdI02bXDDhwjaS+Ly9rXGoDPfJ1QGMCz6ja25a7uZU1AiQBpclPgYK?=
 =?us-ascii?Q?XlZ8TxR7DkyO2hqj4GB09cxZ4Z658yRm3Z0KzPTrvPAz1d+omdNKaqjLKoZE?=
 =?us-ascii?Q?YCiswhQuBTnTcs5vMOymoq6Q5bmIpuDS1LCJL0jW+Lf6Uqju8Z5syuilActb?=
 =?us-ascii?Q?7fEAf4l8ch3wjZ+8roU/GF4hia7B9XiuzttC+zvnPs8uIV0RSqYjkTNf5HYZ?=
 =?us-ascii?Q?YZPzglzqv4o8pS0Bg1zyS1+fchZf2Lw1l24xxHMaAI7Bj35er6HfmzoXaeTV?=
 =?us-ascii?Q?tCEJKmqZeoLLiuaXEdUY35PaXnWSUyNrYGZoBfgpUnvrxSa3PwzRdWnonxbF?=
 =?us-ascii?Q?l0L04OuVXRg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Oa9x2sqs2y8BofV9H7oBFyi+kFbvfBqpQk5RA1NxT3Z5jDGVI/Wa1TxelPrN?=
 =?us-ascii?Q?1GOo6MQCNCpEfl7kJFQ/9QNxsWce9mh7+2bstWxX7o15hwPL9BObGw7sjvDe?=
 =?us-ascii?Q?9SQlmHpUzTWpMm4/HRLGHwPeHRMcJif0NCL6Xpud+NVEHPlQSefzZ7ZqYMvh?=
 =?us-ascii?Q?u9TeKvfpISr6OU8HTqL/1ghsqTe4PW0l+VB/++KSrnGG93LERDZsywRvDeie?=
 =?us-ascii?Q?3WsR/LeqD1zGXfWDh2o03AFM0EfJJ5P+PosMZt72RpUM8l52VD7CHX3fI/qQ?=
 =?us-ascii?Q?wXUkHYaTX4F0Sv8guUClPHwwOx0/tRADCCEJcxOk0RMyYEZBIVLvmcKkugN5?=
 =?us-ascii?Q?WLA9A6Uioj2Ka9eb91eVw2Ryeg1RkOz3tJfH8h3uZ+TYDXztfcedzv15Jm7x?=
 =?us-ascii?Q?YF+cU/ch41659XPb8QzFSkVI4EzyNqLW9fSToAC93ivxncV4Kmj7sHDk9dpu?=
 =?us-ascii?Q?FKWOryYRVAOm8aosW1S0gD4f5l9OuL7V4gQhdC6hbddb17BFOiPDV57Skqho?=
 =?us-ascii?Q?Xq351xuh9At59krRwWWc9LApnZVMHwO3+b9MOUkSyUS7gd1Qr0eVQPn5WbIC?=
 =?us-ascii?Q?IH8J8QoMyLaqB4/IJ9zjl9SkfNF1uQ0GSB47pfOPL5cF/YA+XZO6fzfSOV5E?=
 =?us-ascii?Q?ltSEE8KI1AxUVJwp3rBAB32BHY0jsigFfx8h36f4F/+2ThPJfy8xR29deZGz?=
 =?us-ascii?Q?MKV90OHkfulPqMY4vYEC/Vus9obpnet/pAl8Gr+rQS91hsUAP/hrELeiYaY7?=
 =?us-ascii?Q?t45w5tnk7zJ9Mbwx2mZyO0OBFTvgxoNoXR6wma+vZP93a0CcS9zxikklgcOw?=
 =?us-ascii?Q?AkRJub4lTtiGUM2IjJR/MJHqIcM78SNMy9DYhQA8UVEkN1NOlEFklDrKC/jF?=
 =?us-ascii?Q?gKu5sJFcaFV6fiyDQkTjgYM32TcgMILZ2TtN4sBE44yqIs7tp8MN0EmnjzK4?=
 =?us-ascii?Q?IlFKSYhGbi2nst01OJJAuN5imcfysGFvmdM74vhUjUuAQYS9AcAhSGQX8X8t?=
 =?us-ascii?Q?qZsJZ3nWJ48mNOcLkW25piZtNC1ZYOolrZRLhfIxSc2344Leh9i/XipsWHHO?=
 =?us-ascii?Q?vjIpC3EmRyD3iQ6cYoj3AtNMyM4150JyvJQn/yjnQXkhqcRs0F2lSoxDIjEd?=
 =?us-ascii?Q?Xbr/6ir7tOPcW6AZOgkojZjcRAWu3LcaP7Kiym6tEsWZSQCF+o6LCEatgp7n?=
 =?us-ascii?Q?kn8/yMKZHrwFtXQWxy5O4Xl5P8HqWdCNo0L7eqW7PFHBZO4iMnjwpPX3iOlD?=
 =?us-ascii?Q?LRYR5plPN31a6cgPn/2XvSSQtvqAFEMuwybn7Y+D5beceuDhQUYMIaBtYkNz?=
 =?us-ascii?Q?8a+bfd5jRU05z30ICXT/ztN5Awb96pkiCi726iPh0sXFb4LtecCcqXjh77+s?=
 =?us-ascii?Q?5xce2d9ZCehTVoGswaeoyr/WmbdqsE52JlRjEH2275wcxyjsU78wc33q916G?=
 =?us-ascii?Q?QSnfFuR81ydY+mLMzNTuBevVL3P5cOP6QeF0ofjkhg2UXSeW9VnfWhqRMuhm?=
 =?us-ascii?Q?eVYP3V/+4Gwd5dq0vWUcz0ZDvqXVOzZNUVVtUPb12bSIDxDXgZZquFhdYWYv?=
 =?us-ascii?Q?TTG/1yYNOcczdMC32Dk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8507a99-ff1a-4c50-d87e-08ddf0828267
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 15:55:48.2058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WkNeXBh2gzC1m+p3UUelpPsnRmb1I9ty0dWTY6xx4XvTkkvnWL7oyIjTb9RY2Imm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9513
X-Rspamd-Queue-Id: B594840006
X-Stat-Signature: 3dhxorbxa3jr8ikbwejamz3fcfkozbze
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757519757-539154
X-HE-Meta: U2FsdGVkX1+78c25fIOSt63xgQV6r3CY1HErQ8Rg7GLK5DC0wla8vXAaKnIkhZY1oN5TNO7B2HsuRTajzp6j64FLGC/Qnm9qozjODmcNVCm+XsFJuxez/tRpz+iOATWLCJdQCp6tdZlBI0mNCmu+06DTXv08xhNKPFdha5rIW9D7tBDePFXenLl7jTSEf4GId6wJtpmidY6G6+1xKKBz41glZYa0eJT9nd8oqQi41pEGaTI+KQpbFNI4EQTjhEdtkyr+04i18TUgVgOQiHMwmQSItQBh7u0AFPPNwvQpiubgraYsU+gsO8E03W7R5Eq1fh+IfOvi+EEoGjzvpguNdPwic0ZE3LLvgWi6y8I1KK33HkpEHIpBNPuNEwGzM6K247cgKO5oAbARBDnI2I0cnZKgZnVWEbeIujHJmChOL5CTwJcZlVTsyeIRgAvDjFwMuHnDUfvU1cqQALR5qoeN7+0Sqz35aC5p7KZPsealt46giH+8W9q6TE8ZIkaryXQNyqPI5AcUcMn/y4V41UvV/9sbQKyRM3COXZssdhMmJpqTHf0Ez1HL/pm/b1cE/+TE85W6/fHBvaPovN760KMKWzipq8240ddl0G/Urd/aBH9FdPron8MSUFvP2XKmKCn0f0menHsjqNQA+khkHaP0gnpFY676ayUIg1rLNl6ky5WepkgGlMY74EJw97NxkWQD/5qKt8y7k0XVIrpSGNeiHiTtn5AYRaXH9Wb4S6VklaFtIi6oWoRpbsNvDBN47rujUEjelGi4z/QhMjT4VMsRRrAqH3IZGb2atiGTpxoohzkuNpDJ/tkTrRN8q+KFziF4Wx8hCBjGzUUyeT1LQilw0c+oKa9FUJyeM7eDOVRSz+XMJ50Xc7txCz+zRx99kyz1rf6jDfPr6lGP0mQfljIRJ4i1gud4aLEG5frgf/v3mE4LaBoqiUZ9+FZImYndR+oudlAUankI6XezEFivqZw
 E/J1DdZy
 ORp5TqQoUdYdPAhqWZj/KgkxY5Xn+QCUzHt2EAV4mPeb78DflFOk9WsiEvUhg6vue/KuZLp8EMnQxHI7VHpIEncxuklF2w95uw8gZZFx/fe3sJsbrAvYb5qKqNM7xk/pufDY90OtVfYprMSTtWJY54P0W3Z7/6D6mW/rAiJCATmtLGpGA3sWlsVmp7u6e7I0sdQjZ9a0HggAodqH/prLJLy3YgQn4p1DPywuUAPldmBdGMhdnE9p6cJNhxAD4b1SnS7CD+JInLl1UfW+u3Yl7xJvmeffiHvIjaKIXCcVqmJB2X3epoUP4Lv0TgOVErbxtEIa8hMqKi6PyqPW26bMqO5vNB+Er8D4dFFLSIUhB0m13xpydOpkBfXBy9SiBydbn/MPGBMlJT75DqWpR9uyfbkF0JaIWGwSZVkQibk9GoG1x+7bwy6tbgsRGeNYmqALcxPOrI399YFmAU7TiWFh5nK9tjK7DArqljP/yPvkm7UioRFt1gHTTTBzXIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 05:52:04PM +0200, Pratyush Yadav wrote:
> On Wed, Sep 10 2025, Matthew Wilcox wrote:
> 
> > On Wed, Sep 10, 2025 at 05:34:40PM +0200, Pratyush Yadav wrote:
> >> +#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
> >> +
> >> +/*
> >> + * KHO uses page->private, which is an unsigned long, to store page metadata.
> >> + * Use it to store both the magic and the order.
> >> + */
> >> +union kho_page_info {
> >> +	unsigned long page_private;
> >> +	struct {
> >> +		unsigned int order;
> >> +		unsigned int magic;
> >> +	};
> >
> > KHO is only supported on 64-bit?
> 
> Yes. Currently only x86_64 and ARM64. It is mainly for hypervisor live
> update so there isn't much reason to support it on 32-bit platforms.

Presumably this will eventually change to use some special coding on the memdesc
pointer?

> >> @@ -210,16 +226,16 @@ static void kho_restore_page(struct page *page, unsigned int order)
> >>  struct folio *kho_restore_folio(phys_addr_t phys)
> >>  {
> >>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> >> -	unsigned long order;
> >> +	union kho_page_info info;
> >>  
> >>  	if (!page)
> >>  		return NULL;
> >>  
> >> -	order = page->private;
> >> -	if (order > MAX_PAGE_ORDER)
> >> +	info.page_private = page->private;
> >> +	if (info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER)

All the impossible checks shoudl be WARN_ON()

> >>  		return NULL;
> >>  
> >> -	kho_restore_page(page, order);
> >> +	kho_restore_page(page, info.order);
> >>  	return page_folio(page);
> >
> > This all looks very confused.  Before your patch as well as after it.
> > I don't see anything in the current KHO code that requires the
> > phys_addr_t to be order-aligned.
> 
> Right, good point. I can send that as a follow up patch. But I think
> this patch stands on its own without that fix too.

Maybe it is worth adding some KHO_DEBUG kconfig to protect some of
these extra checks?

phys should be pfn_valid, phys should be aligned, the page should be
in the right state, order should be valid, etc. All worth checking.

Jason

