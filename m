Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77E1CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312986B0005; Mon, 11 May 2026 21:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E97C6B0088; Mon, 11 May 2026 21:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF356B008A; Mon, 11 May 2026 21:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12CD66B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:34:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95894120302
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:34:46 +0000 (UTC)
X-FDA: 84757048572.21.81CA34B
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5793180005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:34:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="AKAo/mY9";
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 40.107.201.14 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778549683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4YUCS+Y4aifMwMq3FUFZA9/YxuAsIghRgpEVusIJCM=;
	b=qM7ZyWAFQsvfZ5FbhJsdmq/MvzMWDQeE6IO3iQUQ9z9xoaH7NzzANiAUkzOvug9MWjQxlE
	cyL9xqXKLkhjH9f+i9yE0a02GWUVDwYAMgdwS3WgkGezLPqk+qI3GmnNdpuD2nM3S2tasg
	ZtWDEv0MSdqvsl88ZMX/lR68XiS5c/Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778549683; a=rsa-sha256;
	cv=pass;
	b=qH+EOB6aE/x3Cj5JRsp6oYzavSe7UjLj645H1vNjJuASwRgVwXP13k7DZDwyBvGcxNzjNO
	syh5yAVvhTCHpYVLEK+xA+EXMQ9XV+ETTHUxw/Pt60IRKSN/RnRjg0mLaR7L8hPGRgbLtW
	GDBqN7GNNs+2A5NktKBFZT6itCzgplA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="AKAo/mY9";
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 40.107.201.14 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KHfN/6wwG3uItcLwnHr5j4Gpqgr/AL2PVBztD3o40rW3x56r1jY6ishYP5n9pG+XGyvdE/ClFzmehYkFbBGJJwPRfiKC5TTHpvkCuX1hHOrOyDvuYJ8tDkEQxSHF1h7K2v0YJJKqMxph+vUjjlKCP/4fbyf9/L1kJ2yWRF/i3fIlMoQjJrDbpgG+jPzjbo0rYQH+beo+aFPo7CWi/V8hBp+OYsrAvk6J0EZBcRdA1Rc3MEa48XXg6boJ3WDscpLrB+SE/eUKzjNQmUeM7gTAk5wlVMBL/tlvkgh8X4jx10rkwYnFBGPc3pQaXCIHvG/3ZvzJKHCp4NL4xn+Ihr3Ncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4YUCS+Y4aifMwMq3FUFZA9/YxuAsIghRgpEVusIJCM=;
 b=u1R7ZoThz2i4y7FnebSuds8acbdUjEwgxU4dqX5BDOuaZSIqzHDKXcip2wADoxySN9hdt8VLB0OYV6PPhwOAESHbrEDD225QNUL/BZIwGS506tn4m9OGTk2ez5Ugk2sWxxguZ1/nzc2/PjOu1ps73yVV9Ch/kj/SuJxFbwAFTrIqagSygptqJBRo+Tm3x1EyWTxuCmsfLck5V0Rxnz74YZ5x54ZmH0GMQ+Dw5krsbsObnwiSRvgn1en4ABWxfc7DZyIUnhB7o4n/KW6LO4TfZMOuDXVgXsfJ/KpjN9L4WFFdF45HsD6pVlLijYEN5UgXgXrIAGWzys7HkAJcehLS6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4YUCS+Y4aifMwMq3FUFZA9/YxuAsIghRgpEVusIJCM=;
 b=AKAo/mY9795LGF0zfOVxSxl6pYveoHCTRi1WYjuoVWb5tGLMUuvFy4iRrB7zErCKwK3hf7tcCk1GqdQm7yfo0GZiOeBUyJ/HpC4uyM+ECyRlZLOuU2iXAsQgG+e+m0WWE4EXQSvrdVdmBiOXL+IxCV3fFOqthDdVSNJEJAIdeBLsw4T0lmnkKZu/Uk0fituFNIQQT1MrcyLSx9k8zNetVX7gcDQeF6aZiWrMG6ZnbT2YtLSaIx9VOijnTuJDFR0MLCeM/TwEg7NQb3QTa0dm8o+q+bh38gaA3NLq8A+TGB+fxzEPdaci3B/VEMwpR+lT5+729h9WIAm3iaOxpfqgDQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 BL3PR12MB6452.namprd12.prod.outlook.com (2603:10b6:208:3bb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 01:34:39 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 01:34:39 +0000
Date: Tue, 12 May 2026 11:34:34 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Souvik Banerjee <souvik@amlalabs.com>
Cc: djbw@kernel.org, david@kernel.org, willy@infradead.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
Message-ID: <agKC2kIxNWL_ObLA@nvdebian.thelocal>
References: <20260511214020.208939-1-souvik@amlalabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511214020.208939-1-souvik@amlalabs.com>
X-ClientProxiedBy: SY5P282CA0048.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::7) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|BL3PR12MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: c4e0329e-7974-4f2f-483c-08deafc6a1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|11063799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	H7nd6typKQ3gOW1slJCQI91M9CEeUeV86ERvUllgQhMmOEqpQx/IdIkN+zwcGilh/LPd3O3LUkGH6U1/RUMWayEGddgv5lGN3WSUbBKqVaT7YH8T05FDv7uUy8Cc5kvUkMZcupSdf6WGA3SRapZpcZo83N17PePYZMEY3rtmTPbi5QZzxP0uhN8T7rQNvTv/fzLDbFd/FLBvO1k++kaQBeBkUNnjXb/pQEw2oXTH8Nb+8FjeGFB70QdMKoSsoUIYQjN9bGPAiOuXutITK4N/IFz7ZV7MtFii5Ymk98NNLgkoGLyE59mWDVRtaECgJ/622jBkhf7+PKToLqTp6Ae0HMyZH2BDiqpqlIimlt4Gm0KS9/ePz5OoQkbBtg414ERajbYct21foDeNnVB8W0A9Bb7q8Gy5vR6oBI8VK6cIVdQjF9xGPUYRQ2yIFOdUNIAAAfHIRQS1cJURMsfRR7q+1oVwIZWsKj6gtAaFmzCbF2UArrzrS3RtZF2CL+iptm9Z5f+sMF68SENMPXKbrlbFcKUDm+VuI6pLkTFl6jyEaNPPnHzoj/mRO7yqApLR5MTxtmhfJMlsSZY3MEvK1to1Pfr3APotjwnklHLYBP58V9wBO4sugi1nIRG9mjT3KGS4hMYfBTkxk+eC622GGg8sCj3HiPMhTt7b1fx3waR2t2yBnP13x/6Kwq7tpcO3lBXJQOszbEGSDADzt+vm4CPWXg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(11063799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RdrQHnqdd8Kz4a7QT6JBWI7wdp+qF2AiY64f2m+d+/lBbsGq9Qr08Fcu7+HK?=
 =?us-ascii?Q?SEj/qIIurubuoIAltgwGKYyeLtHDUW3dfLRjtfa6MN3svTMeDkMYsf7i9X7k?=
 =?us-ascii?Q?k6mTepHjxA3pU9TptttrVMwbe4smn9AvLkLm/oIhsvj5IqplI+JR/hRjfBXh?=
 =?us-ascii?Q?HeBq9ADKduwVJ9Qyi7K2f6JZeXeVcO186WB5xh7uEClY4zG4obZlzKomMb8s?=
 =?us-ascii?Q?MRf2xyIReAfwDL24q+mKRdsCXE3XHbKy8hKKfGD8p1OZf4mMROpU1kuY8kjM?=
 =?us-ascii?Q?FyrYxX++A+zncirLr80GktcAsYXQaES2xxaxPnge/vh/D3adRS6JVw8ZzNh6?=
 =?us-ascii?Q?k7CmWU1tZxPu6fcKUXRKeDBxlKNiiD3L2hlkp+A4GFyebP+edVCy80oU4KNd?=
 =?us-ascii?Q?MhWXF3sMfPFglkNx+0cvr5cZqfTUBEyoYqice6AkrDNa9OJmwmHuMeOZ5RwI?=
 =?us-ascii?Q?+yiMvpKfP7RaBkbBYFmt3TqpYlg4IobwywKDQINy8n7b1kIa6gaXjqOA2aZe?=
 =?us-ascii?Q?lGS6xgnxWTDbxUhExNv0zyVtA2VLfOO8ELFhFnVfHwp0vndDaxzRZ7JYTo0G?=
 =?us-ascii?Q?gdxiNfGWe/ZRd1KS9nqfSfyPyU9vzm290MnRyvGaWiTBZwglRfSlatq1e/o6?=
 =?us-ascii?Q?cUESUXNgFnlJkDgrliyBjX+oF3CG6YlCcFk5AuJsf3PScOpS72TfT+XzB+2X?=
 =?us-ascii?Q?5qZHM+VInZsCLYCxl7nPq94XRmA/8XstVY8di+XjTiJ/Xbdtu0/cKVZ/T8NF?=
 =?us-ascii?Q?CEDmvytLK4Uku4iySJU/Ot/qc8weciNfW9wOsk/mZAmtMuTW+hGJfbQJisvc?=
 =?us-ascii?Q?c1BqfprUdbQh0uUzWUsNaZWIRmu9PuyIc13UMSS9y8oBPtIr24vZ5+t8WA6b?=
 =?us-ascii?Q?lc4um0l8RhzRFZD1c/zsggAIOvEHpqEIXfzJpbY4SRZBNgIQvtkcMN2qKdu7?=
 =?us-ascii?Q?kLJdExEavnUhasUkcVgw7XXxMkTo08kS24JDFD4pHqwL14yGIyiT9MBlg8yj?=
 =?us-ascii?Q?n19hGF2HQZQTI884ZxyrmixeIZ+xRNVG1VzoeTJ9OzQV+3PmgQUhpuRwO3vT?=
 =?us-ascii?Q?TetNhnN1NOjUn6Dg3q7ec1imw/7KCy8PBuDsuT3o99wyNwrVyW3IwShraYY+?=
 =?us-ascii?Q?r59wsa/0Bd3oIan9xNFl8lCUk28dTvOCZuOqPnag1zh6MoVYVPbniSJ44AvK?=
 =?us-ascii?Q?pppIRDlbDo0XeqsKrucDWVRsAsPL4qLkwxAPHkD/JkKkKp8Xh45hpdHxdGYA?=
 =?us-ascii?Q?hcd6TfbghChJm5KhFQmnce3tFeRE9fhGKkLM+WH6Gi6eM4vM/rk4OyAPUI7o?=
 =?us-ascii?Q?LBnDX/GhZajKff7WnhIBAP+5/2W8baTBJa8LgsJJMCrfZNvBcGyEla271nMY?=
 =?us-ascii?Q?c9sBWA/eu7eOxgQ4MuCsq5YxHaMsYXtaJHW82FEYLN0SHevTLVySeTiyhgEb?=
 =?us-ascii?Q?JKno7GON4M1NpdC7TgZkaePpx0cEkHRnGBl2h1JEVVcEp8aRnn2vwM2D6nVX?=
 =?us-ascii?Q?rmyH2EXc+yprYrII9dfSRyyWVbrGp3hcKXgYQju+XD5fDjOP2yCzyZVWyd4y?=
 =?us-ascii?Q?Jcmi5bhc9ejwnURf6PvkcvAGVTq2n4C3TEZasFU0sKvypl4jGgh33AJQwFyp?=
 =?us-ascii?Q?AZZYHCgdtMRWpzQJAsPU8l4sNeOxwspPFpx+68ctF+JY29Lpq/qaSO4zt/M9?=
 =?us-ascii?Q?DUWC/WCPoWH8Ne25zJn/xqXvPiMMKcl3CUgHh43rvZ4nCrykDIBJI82tMR6d?=
 =?us-ascii?Q?ffPopALBLQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e0329e-7974-4f2f-483c-08deafc6a1ef
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 01:34:39.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhQc6c/CaifZP9D8pN8AVxQbEqyPW4pZ+D5VX5ojF+xp9szNOFw6NvSdoGjPLuY1Pu8aNiGosiy6Ctqt7YvYJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6452
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5793180005
X-Rspam-User: 
X-Stat-Signature: fe9jqjzxh1kg5cdmmapg86ofzd57q5nh
X-HE-Tag: 1778549683-180365
X-HE-Meta: U2FsdGVkX19tAkXt1wLrw5yRBvFz2pn6xN+8z6kqkUG5oTT8AE+SBUUgcW4zelUDmILvfXv+j1FWtHQA+XIqydyBhFOIY7+kuu+8FpkNsVbqOUxTWFajWNu0zuaVSnA3hj7D6T24LdZaIT7/kapctcvI7xFWidOgx3AruMStxN4Saj3dswr6ML/b8QHs8toQEODJwNpcrSvy5l9y5eGxnQhNtXCIE0+AMirY74G+aIZMM2HST4agafHN8yNPXtxBHWjIKiRgwZHuQcn60belY0PrryTRdEZk495MF4k2QyCICfnHBmdqN6RyP+waKSpFdJP/jCCGXkE0ilibS8Khiwkao16pZWPbrzmCVEKTyWKXirFpqE1S5r5uVuD0NjZF3o1+7uyGTBcyHRbA0w5+aqZKJFGZcDGIGmMRE7s6glLoPgFsi4dmGUPIPfg6aJzn6j3w9C+ASiLRFrMglqv+sumJc96nHXp+azNUFGMCUxFBqBlq8kYdSZNIVYtXmCm2L4vBji1TIvc3v1yNeEQjEQfr6PwBEAYVvMhGY+sNcHyi6uYrIPX60UPkB82fgbuNpiG8A7OvEhFkuSkCCum4onp8OsbSAJGHRZZqi63CTDTPK4oAAE2gNjjaKk/Y9QhAgNpqx8W/o9BUgU//o9J/2nO1Nug0FHeuGQ8zP0g3nLba3kDzKcnRyLQ+24/wNXrXk87Z9jBKnmPYjPbk7+ivgD+aJXrX1tGkXHw7gnjKk+UeMdBLsK1MFv5PoEi+cjUM7cx+yTRAEdXQfXqqWKqMFULu24Lfrztm/iilm4E/H32Q3f93cy3hdM+SsugpoEzqnrmzOQgqWWqAnXACSLBuuGRVigr1P0T2UTjJsPTZst4YCKc8IyQCHfoSamDeN+7n+NEvcF1iBOzHHxBGFhq+kpipy3pGOxAQvCGaaEsFM2BtEThHHq7WLRWdjQ7g1iBBw4z+Qb5gK2WXeJaLf/d
 8xE1qC7l
 2TzMZ2Shai0iZ65CdGKtFPCWb2uj1FIOeS3kP8EPTGNaSYUbjZRXffBBhmGLWWRJ4syXfDQYqJstQNeJR1s1QonT5BHVyMIrLiHqdBkrer0X2pXMImh17omG7smLUqHSJhL1Ok9B4SM44VxFpZFwXHqX7wvvxzovfAyS7d2wXtFq9CoMCFa//Q9Z6j2Y4OK5k+j6a87B2Hpzfm4G0bYUFgIFWyHqaymvDp6O/o0ElbccB2EzzIXuzOk+rkgw+mpzFBHhMZ14sasdH6PHRUEcsJXsQllqkGSjYlcd99QbUAkUhFMDVgYwOnM735rTf+W7l6A8gh7M0kcNZLgWzNCot7sqWVGI55wi8QzPGFxppqDvjPgOlvLG3TC701sV+WZQ4Que5trAbxbeoBsQzuZOMO0WmhOABDtgNFUcAATPf79oDHNjkDH20GECXrRfJxNiu9U4jn9lS1jIdNGzY5132mJYhWotxIeC7LPhYafcjo0xbM7cCG9BNELjHKUvGHQ005W6xyCYbqevTZSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-12 at 07:40 +1000, Souvik Banerjee <souvik@amlalabs.com> wrote...
> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), which calls
> _compound_head() and performs READ_ONCE(page->compound_info) -- a real
> dereference of the struct page pointer derived from a bogus PFN
> extracted from the empty/zero XA value.
> 
> On systems where vmemmap covers all of RAM that dereference reads
> garbage and is harmless: the early return then discards the result.
> On virtio-pmem with altmap (vmemmap stored inside the device), only
> the real device PFN range is mapped, so the dereference triggers a
> kernel paging fault from the truncate / invalidate path and from the
> PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> freed:
> 
>   Unable to handle kernel paging request at
>   virtual address ffff_fdff_bf00_0008 (vmemmap region)
>   Call trace:
>    dax_disassociate_entry.isra.0+0x20/0x50
>    dax_iomap_pte_fault
>    dax_iomap_fault
>    erofs_dax_fault
> 
> Close the residual gap by moving the dax_to_folio() call after the
> zero/empty guard in both dax_associate_entry() and
> dax_disassociate_entry().  Apply the same treatment to dax_busy_page(),
> which has the identical pattern but was not touched by the prior fix.
> dax_associate_entry() is reachable with a zero entry via
> dax_insert_entry() -> dax_associate_entry(new_entry, ...), where
> new_entry can carry DAX_ZERO_PAGE (built by dax_make_entry() in
> dax_load_hole() / dax_pmd_load_hole()).  dax_disassociate_entry() and
> dax_busy_page() additionally see DAX_EMPTY entries created by
> grab_mapping_entry().
> 
> The remaining users of dax_to_folio() / dax_to_pfn() in fs/dax.c are
> either guarded or only reachable on real-PFN entries, so this exhausts
> the anti-pattern.

I did that too when reviewing v1 and your conclusion matches mine. So looks good
to me:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
> ---
> Changes in v2:
>   - Also fix dax_associate_entry() (Suggested-by: David Hildenbrand,
>     confirmed by Alistair Popple).  The same anti-pattern existed there:
>     dax_to_folio(entry) ran before the zero/empty guard.  new_entry on
>     that path can carry DAX_ZERO_PAGE via dax_load_hole() /
>     dax_pmd_load_hole(), so the dereference reads a struct page derived
>     from the zero-page PFN before the early return discards it.
>   - Audited remaining dax_to_folio() / dax_to_pfn() call sites in fs/dax.c;
>     no further instances of the pattern.
>   - Updated the page_folio() expansion in the commit message to refer to
>     the current field name (page->compound_info via _compound_head()).
> 
> v1: https://lore.kernel.org/all/20260501233933.2614302-1-souvik@amlalabs.com/
> 
>  fs/dax.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99..4bca6e2bc342 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  				unsigned long address, bool shared)
>  {
>  	unsigned long size = dax_entry_size(entry), index;
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return;
>  
> +	folio = dax_to_folio(entry);
>  	index = linear_page_index(vma, address & ~(size - 1));
>  	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
>  		if (folio->mapping)
> @@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>  				bool trunc)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return;
>  
> +	folio = dax_to_folio(entry);
>  	dax_folio_put(folio);
>  }
>  
>  static struct page *dax_busy_page(void *entry)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return NULL;
>  
> +	folio = dax_to_folio(entry);
>  	if (folio_ref_count(folio) - folio_mapcount(folio))
>  		return &folio->page;
>  	else
> -- 
> 2.51.1
> 
> 

