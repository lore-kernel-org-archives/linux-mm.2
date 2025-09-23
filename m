Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41377CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 00:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E148E0011; Mon, 22 Sep 2025 20:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEB08E0001; Mon, 22 Sep 2025 20:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5998E0011; Mon, 22 Sep 2025 20:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22BB88E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 20:53:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C52191602A2
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:53:47 +0000 (UTC)
X-FDA: 83918692494.12.50CDA55
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011017.outbound.protection.outlook.com [52.101.62.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id 501E7180003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:53:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kthWvZ6g;
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.62.17 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758588825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cnztExj7uCVzcewoN5toY9AioZIOheh+gcmvK/WnPm8=;
	b=LC2b+TiBgOQPuD4ohOpnUnW/P9O2fp1iKYvqhWQ8Y5lwM45YP7NcDVXIQ6vi+AIZT4jnvf
	9IZ6ggHwMc4XSZ5X5CAZJd7n9ixLBYU2lmRIQMO5f2ucQWuVIEVK7Auh0Sn92jecgl+ZZM
	MpEMRTQyzn1YT4hR9P5i8H3pl9b4Pus=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kthWvZ6g;
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.62.17 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758588825; a=rsa-sha256;
	cv=pass;
	b=VkTCsYu8Hs2Q/nHuhbkml+OTgolcejS8RwAMCMtv9LEhjAic6jplY3frIeDWaSucTM1F2i
	kB+0UDSQXjtIuswiGTxikkjGHM42+8GO6ziY3+wSPY/6/ChQxy3BbA3gS9v0t3KawlXble
	6IXaRt7FGaKhPnqTdqr2C4euFsTtifs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJw5q/ZxmAkhbJ9HnhI5qyVWPfhC4bVzY1Sk/5BOR5iCvwSe5x30CXcG5NugZ+BgIitzwJs/s4IlSBQx9wNpg/gB9ZbRCWLUd1cECY67CrdnlpGN0Xh6q60DfcBp2momjzoxY+SCyDrlSVCHA85KCU6yHyM0LN8i4J+kMmcdzzfHE5L4hrHBoOMCCLqTQeHXNLH4s4aHKrxBzpwivGfqzlr+TiZB3pcmJo9+iGkaircy1FsKEhmsKZCXe7Fc6CfYPUy6jqwgkq9gF29Pg3jThiDks6f7wJrcUiON5zE3DU/1hsE+yB6m651lDA7wuxqtXStMw8V/BHnYG/xbquH+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnztExj7uCVzcewoN5toY9AioZIOheh+gcmvK/WnPm8=;
 b=AXiQ56Zhc6r8BuQa6pwSo+6vRuqr0I+dI7svM8KkFhsvpRFoYw7ox4QrNr/aM/6eM0tYVqNgNfJctuQG0lfcxt6i6TtGR6iu/IGjXyjTq+F5xdGalOKocHyJPKxwN/hxJIgYIi7PH5hrldjmpCr499ppUzlHP2P8sMjRf58QgEg4+uJsOtBLwV1XetNWtzIlv4yCZUFrzx03fTCo9g8fqxf5Z98DImQlZvjvoBWOXSTG4KOV3C1OTHDg+5QimTTK3d5K0VXZyJU38leKAfnXLoVL1xtSjLz+7k9eH/b/JJSwIVsDy+VvJkAQf2IeFQJG9jSJz4rLAJwYrTypZpdW1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnztExj7uCVzcewoN5toY9AioZIOheh+gcmvK/WnPm8=;
 b=kthWvZ6gxDuMqRd22Yvn+bc/Tf+hmqTJAUaMinTt3Oqgx/1ya+ClLzdr+PNIxMvYdPHNdu7JB+a9MkWW09h0UA5EumZd+sf4s7EUgrkpUtqbMo2M7/zcv09ismo3YOyI1AVxCe3AwYgA03AWYPjGbhIw1XFC+KI4sxVWMP7MJFadpLHeax6mlh73aVL/xc1X42bMjUtGh9FDblWVWd0EqAUIw8WM5WabNq9X2AXOy5UUXAN4gfGpOqNXJUiGu2Wo1p/kqVATNikHpejotOdZtCFzpMmfvvLDfGcHBzRImaXBrKaFF/+9n/rmCeYDncnL9mssixFeEmVUDQoCVpwuow==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CH3PR12MB9283.namprd12.prod.outlook.com (2603:10b6:610:1cd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 00:53:40 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 00:53:40 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: Alistair Popple <apopple@nvidia.com>,
	Haiyue Wang <haiyuewa@163.com>,
	David Hildenbrand <david@redhat.com>,
	Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH] cramfs: Fix incorrect physical page address calculation
Date: Tue, 23 Sep 2025 10:53:33 +1000
Message-ID: <20250923005333.3165032-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P300CA0062.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::25) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CH3PR12MB9283:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c6e1dd-4136-48bb-c621-08ddfa3ba2c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EZwUUZlkc3ODO9EIXP20KmbFlmyfvul2pRqgVh115yPaSWuIhmkcD2jBNzcu?=
 =?us-ascii?Q?lNEhwM+068/HAp0xyhgdzgjmw+ckgNzBfx4FKv7hIVLiusLmkrL+j3MgPtfB?=
 =?us-ascii?Q?UB8Gwwcxa+86iPqEhjIaYDYARCECf1ldQ6yE4pEz4rfdHMJ/UoqemVe4HG0L?=
 =?us-ascii?Q?2GrqUShusg6GC99Yjw2P5QVl3LV8kQ/OKBiRb0/J2y5fLNvSAkFluwc2C932?=
 =?us-ascii?Q?ty8+xf5QWWi74ZdyKmSaLYewsu1qi4vcRQGHWoIq5SAaW56YdGWcmf54pnyX?=
 =?us-ascii?Q?PPNm9pzHLkEEgYWHFO41Z0Yr8vh+QLKvifDGyKLpfTLJpNisk/TCuevTBeqq?=
 =?us-ascii?Q?FOz3SRzVFkir5LMIc6y37oW5QDGvTnZFvp7UQB3C4wezq4/CUc05IsNcGjCn?=
 =?us-ascii?Q?018rSStLHXXUssTkWse87n8eUG12PDAkID4nHC5yFSIZfnWg8pdQsYbblFt0?=
 =?us-ascii?Q?oTNqNpnR+zbmwp4LRCh6/fP0VbutJWdvnoX5AW+HkNAnMukWE8NyoU80Yfzm?=
 =?us-ascii?Q?A4fSWqaVR5U0HN27jjUwDPQWm9IM56tx54ZrF8LK+2uAi/BlKAmeB1GGSwpS?=
 =?us-ascii?Q?gwKRKbbDyacPQOyuUcx9JEsqXPeKoNJPb7ydIC9gqjK0pDMOcChWzZ25RRGu?=
 =?us-ascii?Q?TbE94RyGspgIfZXfkddxlGmxqDWF6gluE1563jhWMXx0IOu7VWtGHIXg0SEj?=
 =?us-ascii?Q?RM8xWwqEsFCJnYGXcgWzHHLYurhilFa2g0UHgOmeL1YvnHrUYg0511RclhLu?=
 =?us-ascii?Q?IyW2Uzqesy8T0ptW98ATxjdbtuX5OxoH6Wt6s8bQ2rJpXu4XjnC4QG2ew/r2?=
 =?us-ascii?Q?lTkmM5KC+9+8/9G3Xp7XJq1ofkD348KX9YAQIDccl/Rwh8YEDRS/zEJ1OR+o?=
 =?us-ascii?Q?GYnmA4xucBDCd0ZIbukSpljSbqw210CdmRgDBW/y8hnsvSPn26FwVQgMfonl?=
 =?us-ascii?Q?G0tGwP3U+9xnoz0mTEKG6WI+6pfWDluXpNz+TRjjuR1LJQg/monn5OTjTFs/?=
 =?us-ascii?Q?AR46ecplm9UY20xh+RYctvvnWu9A+yTg81w0+BRKN8PD6Lwl6AEfndn6aF5G?=
 =?us-ascii?Q?a/jtU6HJSNh9tdx5wnjzeejwHfY17d20e8Qz1fyV4qFbMYuXSAfgtpD0ozZn?=
 =?us-ascii?Q?pa7S5nGud+OBntnsckPHjxVBAqZWv6Mm5pePw/M4BdXtTfQVpnEYoYmhRshV?=
 =?us-ascii?Q?Cn1T1XkUPxVFfvnWYrgFQOrZDKK7Hl3XUNl1wQAn4ix5fI4WizwA7nP2mv8b?=
 =?us-ascii?Q?u/aVxuhspQyBss76hMObtUvV94c9Qw01AKCBj6EsL+myndvavmpnHTFTUDY1?=
 =?us-ascii?Q?9cW8MX5+XDyE87JdmVAAScK1YTAaSDgL3HljermFbpLjWmuYseRT/KYEkanX?=
 =?us-ascii?Q?/btWA3y0zkMxqjrHk2QMlVGr9tl1EiTluT0jF8EBR7PIki8pjytsbjsWECMx?=
 =?us-ascii?Q?x6glMgSn1ao=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Or25mewMvtyJLRD6RHyRSfUeChnNVdxKHBlMQv44hICETSpogTN5t/YBojjw?=
 =?us-ascii?Q?yCVVcIfussDpwMDLCPqSnc1ubD2/8vz1fATp9LwMnyHiip5KGhCAee8qjcBS?=
 =?us-ascii?Q?qt12xYx2+CYeOJYaJd9F9S7NIHS2Lj4P7YvRANJJmq+qNKA4Oo+3RnzzSRFv?=
 =?us-ascii?Q?tQFutqQM8nveeqe3sH7ZR9RhWdn76aZqcIJ4FQ5db8qEPjxfWHJg+VacWVDh?=
 =?us-ascii?Q?rClxnMf5JhU+V86eWSznwfQIht46X3Uh/F2TrE7xEMx93ReyIZPEDcmHEUHn?=
 =?us-ascii?Q?gHUMRlhBA6HEqo5soow8nfG9ARCuTitjjgvKSGgEidXV2HcmhgDjRnTjDu+X?=
 =?us-ascii?Q?DCdgqdFP1rsJuQfmNNht7pAuDXqG2AifQaGeNaVqR+Z7VHcpncgWWHDuiLs/?=
 =?us-ascii?Q?4vCYEPn0U67DcoRyyUaJw1WMsLxPMz6DxaJ6AWmNiegPZD9XvYEVQeznVhbw?=
 =?us-ascii?Q?lyfq3uPunjTjziqO2oWioS8vrkqHsawhceD6eTR1fcBBQFgRRFW7B9seWOXG?=
 =?us-ascii?Q?54RA8q/BCgnKLutL+f+Mu79P4Ous8q06pg77c3oyXLPkLOc87ZKm/5lcnGDr?=
 =?us-ascii?Q?UHwL2D59SiNTpEA0X3lvHPbG5H7xcZWbHE7TBSS9Rntif+ftEjs6v2lTRnSm?=
 =?us-ascii?Q?DToqgJsmlCg9mmt1qu8f37/qdphbWKMC1x3Y+lE3rmMD3WXt/ZFOzBt9jyZa?=
 =?us-ascii?Q?4ZbhKvRZNF8zeAusi/qGYeg1aUTZWej8+wPMF3tHb4etMVfscLR7ylzm7Fhv?=
 =?us-ascii?Q?FcB2H7PJyRVoqU7KhLK7d3+Ph4taX3IyeM1wZ8fsYqcGJ4i/W9QWJCtWkjDQ?=
 =?us-ascii?Q?+cG/haN5VaCo5nJoAZrOa5KeAxO5ZI+mBIiYTZcWK66xXm0HlnlPN/Y+cMmn?=
 =?us-ascii?Q?NTIrHaF8udMdALcXLo6FxOnJdvAvnsKnn/Iwz4/LGz5zjD9qY7Buu01QTN+R?=
 =?us-ascii?Q?fvbnyTcaQ1rwxH4dU7SDMuk6/qvDehwG77gBAORT5Q0+tgiQy1E4rljdYcJt?=
 =?us-ascii?Q?XHgOJXd7CFMx/TD86DQ+l0UCBHOZbjKd8bll94FyEaOjWI7Qo4UC2o/MiAHq?=
 =?us-ascii?Q?AZ5MGhEr26gLIcy4c40FcgBWhw7G3L7iru5r5yFaRFb9PavDz5/4nz69s8if?=
 =?us-ascii?Q?8IY/4iX1LF8z9MmQbwfehuXtZJMlWnha9ovNoH1DpUUS9M6hY/YNrNlN9/jN?=
 =?us-ascii?Q?sDSBFpFsFLEPqZAzALksXBMfcUn7QvPZryV7Xzg9DJwdWrfkQa13WY4+xfD4?=
 =?us-ascii?Q?si6oKJJAkv9w3EZGbQTl9moyFF6QCFr8v6CekThSsNylisl6yZbsaE3bmm/4?=
 =?us-ascii?Q?6TRV200mKNGV/Q9/Bqi6QlWOOTNiTlcAoDzHYtVqv7QddcvBEGSLoNE9UKay?=
 =?us-ascii?Q?I6a/DepqlVDc3CgwCJgnrDv7a4cQpjccrRo0uambYDEE4MdKLt4CSckDsqsD?=
 =?us-ascii?Q?S87s7+8FV7OGma5Fd4ifC1/WJmT3At/fYg164nXF6PjNna9KlsM3p0A0RPN0?=
 =?us-ascii?Q?TzYqiXvulYGJwBma4OSjclOSSM6sP9mWUsxA0B77cGgPG+SdjbCqfqs+dMeT?=
 =?us-ascii?Q?ct9G1aIeNBSIX3bkRpqrufDBELlbuZI4Qdm2Fyh5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c6e1dd-4136-48bb-c621-08ddfa3ba2c1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 00:53:39.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PfO/MGXaTAac9+TP8P8ktMkHAR/U6UHC/qFdbUuWG7T5jmt4v/Dnnn0SIUbwMCsrTHardICqsGTAxvcApHkvzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9283
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 501E7180003
X-Stat-Signature: 6xgz3ofapmpskgkrdweu9enfh6b4zu54
X-HE-Tag: 1758588825-114239
X-HE-Meta: U2FsdGVkX18etdDHTUatGeIpl4wiIo3kEYMUkBpObKreHXBhgaQH4DSwARUgmINh2hmfjPg0lcsMWsgr3ZEu9IjDJfTmGZb+mxVIN8I6bjmLUi9DOjDuAxzpjz4tGYHpo0xyIgGKewKpr2a4p1ITs62grKEwpoKm7l/qP4ofFfp33HJHf6XoBBABuYUHzb7z5DX2B01CcOhNtVrE1IkaCfOt11BF3O6nE/RAqp1m9TO7N87neBNnaaMtFvT5oXWVSul5Z7di3YyP1q3GnfMMdQV7j0bIAvBq//eZYu+7+AfYI3zF/KRH5TMuIzVKakPbM/HIjJYe/dFNEIjSQ5mCoFsD3DHFrStN4zmE0vSFJfuyw3jR3zOh/mq76XlhTC1DI7oSjWRdQK5nPOQTDDKOexXxfx0dvEOqLF8fahL/wywmAcrWsgjGO5hvOz/N4tbAYJUzXnhphLU1FsM8jewIZELAH2kBXruAC8oB4E/yoHlZ8KmGgzxdX+UrYNiv86Ytxo7chno5Rqucv6BUjH70qvUl5b173Ru14igQtPDxPu4QPx1/SbYHjfpJeD53RbkMFVHSmBTLI6trgL+uHXuFDUYuLGF5+lZ5ZHTUDBFd3stxsn4J+JFUaUB3fS9CPiyhV0XCIk5q76rOZHTYEfMdhy356IM6EohHF/zjHGKAmrzHLLf0G9ZtDdZ/XLYEqyiIeJXNeWF4rrdDv3AKaB3zUQI460KXtmnDkX9D8mNX4Onfx7Tz6poKqPg10tOOzGTi/r4nAxAJoesZzYo/SeP/zJIQp2JOl1UZLjXq3DQe4AyKXsDv6bcx7aDCES6lNXfrlEtrGIAteHTxHzu4KsJm3LisjuInopars+llmTwhlRvzn0sCEptvN0eo0+Q3zpjMaJI19/P1GA5P1xW5rwYfjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
incorrectly replaced the pfn with the physical address when calling
vmf_insert_mixed(). Instead the phys_to_pfn_t() call should have been
replaced with PHYS_PFN().

Found by inspection after a similar issue was noted in fuse virtio_fs.

Fixes: 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
Signed-off-by: Alistair Popple <apopple@nvidia.com>

Cc: Haiyue Wang <haiyuewa@163.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
---
 fs/cramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index b002e9b734f9..56c8005b24a3 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -412,7 +412,7 @@ static int cramfs_physmem_mmap(struct file *file, struct vm_area_struct *vma)
 			vm_fault_t vmf;
 			unsigned long off = i * PAGE_SIZE;
 			vmf = vmf_insert_mixed(vma, vma->vm_start + off,
-					address + off);
+					PHYS_PFN(address + off));
 			if (vmf & VM_FAULT_ERROR)
 				ret = vm_fault_to_errno(vmf, 0);
 		}
-- 
2.50.1


