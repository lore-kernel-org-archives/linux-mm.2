Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86EDAF8FA7B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE976B009B; Tue, 21 Apr 2026 09:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F846B009D; Tue, 21 Apr 2026 09:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6ECE6B009E; Tue, 21 Apr 2026 09:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A683B6B009B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:44:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F2F113C331
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:44:42 +0000 (UTC)
X-FDA: 84682683204.15.6778B98
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011010.outbound.protection.outlook.com [52.101.57.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3946C40008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:44:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YNyr+3OH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776779079; a=rsa-sha256;
	cv=pass;
	b=kKQs8L2jsfyBz6H5VZwvGmxcP7wjFGMZ49WLkHN8RS+LMba4gdwWwSqMYawCKoW3f56u9P
	fG2TmJbGlx24zSByTpBwoTXunGtbWFze6xlx1qs1WYcDplQ77/b8jena0L8KwklxD7LGpD
	r3jpg5o1Rym7v5gvgzs6oD8jIaAtQLo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YNyr+3OH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776779079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8per9CtWf294bZgx5VfsypfghfAVypIq/ZMXqCcwZs=;
	b=FAp+7rBV1VBiq7N/tVjlW8DD8Gbt5fReohwZf4AboY9j4y+v8xxPZYoVwuFHH2zrmwoyVi
	4okwNcY0D3WGgHGXRlqO3wfMsZKm4S58qSZMpQouZjD6ZPq0hiLCkQY7N62vvlgn1QsQno
	zXgXGbQDZ1JV9GL3f/LLtIhFFS7QMpA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NzDZWpCtGrQGrGX1l0Yat/U0uOodEtW+abPa9ryJ9N7aaQdqlzsmRaEMarJsChrLJgVrFCmkuFc0T9w1+NnCzNm3S77P5sgQPqPDFCoCBh56zOhyxyIupIluSwztlZ6hHKLmwehu8TE/z3Hff6ZbtkAbHoF6yIT/Ylg6cMZ7+PfgqOf74i80SPtRzlPrPj6Do43Qz9w9A6MuXj2yya+PDNzvWi/eGvmcRp9aPWvMFO1PYuVRvpYAWL+0Zindnm0HqHmYnGbP3Gk8gE8rH+QeVFtdhHklsh2rypBsMdMfry5RRJaD39jOq2XmfJ+ouBSd0JTWXSk+VjMydEZxHkYZZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8per9CtWf294bZgx5VfsypfghfAVypIq/ZMXqCcwZs=;
 b=yz0npqd4Xmm+WTYs9va5uwvFAUoaUTtXc5EufvaKec2wkFazJTa5BgoHzkKBvVTpMNeSAi8b/xYrL/OfNQDJ82HeDBG30tjuUqblh2LKMy1VFYPyJ944ZxxZGRSA+anzdT05uBJ32IgleT/2P+YrGfSB2+/i716ybiqDP9EbzUl0Hi8lYwfjdqrr8Y4xRLvksuYykk/EmVp6il4un3jd0AD1rDelZXMT/cgZ0zltmG7GKqx4+2LRIjH3/I1jFloMeuSMjJQKqWgYqtBYK3HK48SZ54EjHgiSViys0PeuwtbloyP4CjjlOt30XWVM/HcPAYBiPJDgLlbzfQ+fMrm9yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8per9CtWf294bZgx5VfsypfghfAVypIq/ZMXqCcwZs=;
 b=YNyr+3OHQTaK60pIrwzd/fV84H1A6+I5E1Dob0zkY+Ns6RXeNLFaJukUzVAUXdNoQagoykXcflstse+c6o9X+WCh2E3zodVSvV+0T/f2s5S3Ni88oLEbI59lWp7B1lrXv5f8KgQBnseuJY5u3qpl2mucr0x6Sq/WZ1j84ibDT5WkVJvqiOueE1OLk/TtrvlTNHBfNAag07QcRi3lTzkUlNlgIiXFDyt5WAWgavOFLKpDiPEdy2pbUOH9H46n8bMjYc40CYRuCpe9RnvxScEEQxfLdibqDUGg0GlzfpX1qzlNz6AJEDrcBFcoZtZlgFWVcbyMEbBh7z6ySN+fwwR/+Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ5PPFABE38415D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Tue, 21 Apr
 2026 13:44:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 13:44:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Hrushikesh Salunke <hsalunke@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
Subject: Re: [PATCH v2] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
Date: Tue, 21 Apr 2026 09:44:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <C22AEA85-4EF6-458C-A735-9F7E48934C83@nvidia.com>
In-Reply-To: <20260421042451.76918-1-hsalunke@amd.com>
References: <20260421042451.76918-1-hsalunke@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ5PPFABE38415D:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fd237ef-a57d-4039-98e6-08de9fac1c69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	coKuikibFVo/Hjh0oFI8PNp1X4ZLuCW2bCZRlqt9BsxHjnGQmSJQ2QYnI+OWgJtRtO69GhzQ9RB47JxtDkeOSrgxia07tpE9YiIojqNZGbjcvyrMKEzwMB87o2VX2d+R//Lq5WChl2z0jIRvDK93DpZveivaAe4j0EdKTrGcbmsuk1ngs2xUgtVT6g0GrIesnVpudfKkig86Ajhu6DVe7TExsMofEaCCzhIg9ifUOZnqHVaBfhzDtXbagbdUVCfDWInoArvg75I6F2DC5FsyyQDHducm7GEmQGJfH+oqe3c3IBvoQQ3LJ+MqCXn64EAe0a5ucQ2vAUGc2KOybzfGy4vRiXpeoM1qIsco1Prv3AQzwjQLnP4fToqhLfhKT9CZUTMZgy7iyA5ECqBR+MNYN9gGALwQQPP1K4+lYOzQddcujq1YvOvjwS23/oyaB42VIQbjLcalS/whAb5XqSxWOTrCD+kk1O20rzi3WGR4OdqegncBxcIH8hVXJFbDbMAYIerb9tZSW2JEsjRnP7ZyDJtBQ6ehnav9YPpOfy1Jsl0HUXsOFfrkvur4ENyiib0F6s/egyJIGgnuSi42aYRqmOlocyvyiv89L3kzx6sD5F7UHuNu6SLH7HpmsHuWcDCkOQRPipUidxqX7HB7UffD00uJEj1VUWsMTYoKz9uPCBk8QqHF4+7XAJ/iZki5mqh2MG9kOzTukpXKhGbWL0vtE/2PWUSUDmH27uMGpwSFifw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uVDqTtGOUANcTO/dp3H8OxMAz1D72bIQsYIn2BZIGyda31yQQPh760UtkdqO?=
 =?us-ascii?Q?2pvk9dp2VZk0UIMMPTh/wS3kVNXa8zAY4b3nzGN5NOr2kIEe+cd27YiDkzGK?=
 =?us-ascii?Q?VS/pMCQbWlCd+GA+FIZZjkCNbYJhCyeRGmuXFHFwTp/EaTq9PaLxsEBaCBus?=
 =?us-ascii?Q?naLs7IQgFwZE5KjB5iM+ScgogOoP0eyxwU27k8Ikuo30QAu84OfqC06OJ+YY?=
 =?us-ascii?Q?h9wzjLGj39UlCtULwxtTvEpbSYEnydE5g8tB1aE22QQ6a6nt4/OLrmboasO1?=
 =?us-ascii?Q?PZnkQqEpCck/RxiCM6uZj1efgbizVwsTUlbr1/DvhrjNLaXUZDqS9ays0//P?=
 =?us-ascii?Q?G9N/3IduvksfJoa+zOxpzZMXb5mIieDGx61EjdVcraCE6cL4koo5CJAN4gaJ?=
 =?us-ascii?Q?QaYGDaCDxuLf1rf3y5McX4x3u4NnLLcUynFazSZmYERUqaPUfSD/7zAZShTV?=
 =?us-ascii?Q?H+cHDrXAFRsocdnyxDe4f/J7FAnRfvBp5gnm6T2ofTIsZBQmllo+KoUpzEbo?=
 =?us-ascii?Q?WBmaREWOdPIdDoJ679j5boEz78gnK9W7KldRuUqsaY/OgvfTWv7LiR2y6ERe?=
 =?us-ascii?Q?g8MSFel10Mv/3HINYS96HQLKggPR5vqMd048YD1UB1ZLQWbTovT33+70++DE?=
 =?us-ascii?Q?gMpSyfuA86Sku4CH5rIXFsMpJ+PCNNH4/hBboU2AAcg4P/83YJy7/IfFeASN?=
 =?us-ascii?Q?Itwfi8ewZ1LHPXJ/78VSrsN0PbzDXpMcYKhkqFVxQkqm6ATPSznUDEzPaFgm?=
 =?us-ascii?Q?Y0NNqRdTohlbNj1BmTXlK184qpayel7TtYeMWIlKT8lsM+vaW8jOmAn6Hz57?=
 =?us-ascii?Q?0KcSRlFHVtoSW0b8IRPtyvq/DgmCtFpwx0nbqfsCTimG27AGBxB7qwZ2Ukhv?=
 =?us-ascii?Q?ilnvgBynJ+QhsSxdKTBu8jvRLSSgkCW2z5UJlqhjX57Lr2Vd5Xeccc3osxYA?=
 =?us-ascii?Q?iUCXV/VeAXBcYy+uExGP94QxQ+Np1bZKFK6dY9QLHGV6EDbvoVhPXGN5x1Lk?=
 =?us-ascii?Q?ErgNotZLM/Ws6GJvCoDKxqkkeWtwFT1bjFAqrxigKeRG1g8asdtoGDGz7cZL?=
 =?us-ascii?Q?ARyyLtLG7MzUbIMZI8c8h8M405/GLxpKmoC8lmnPiJAG8RMiXKR15r6MJTpG?=
 =?us-ascii?Q?ZDHA09Mm4gS6vCytQ2KPY6JDFHd+Wc8B/qWYlSTQEt7RJ51xi14SsMx0FQPY?=
 =?us-ascii?Q?p/gffeP7MOQWKou7W/bE6VV3HamDZcxfWqE3dbFJ5Ytu9YLFkWXklJ0GHAHN?=
 =?us-ascii?Q?sdl6cs3rxlUM8fpCVSki6F9Nz8ZDDnCHREkFgv9kn6Q9C2MhHahQmY2HdSQm?=
 =?us-ascii?Q?ELPJjCAZSMu8Z/KjXfi2D9KwzZqEfYy/vXbtUUHK60p1k0jXmjs/k3sCTRMu?=
 =?us-ascii?Q?5THk0BiDVJPnNwhnAni33P7+jPyhZd8e7U4XKtEFvXSfAMkXSdAjR4QHu3EW?=
 =?us-ascii?Q?waB1PFb/6s1gxiSI2WmONbWknzWrp074b5DevMBNb6vtk2acGYGDRndIgkle?=
 =?us-ascii?Q?wTSkbghMsb4bvCNnDUqwbzxnUlIOpfhSwcOofsSv5kwNzOU+wtiAbPWwdS52?=
 =?us-ascii?Q?xEYbJOCJKV22SsVNr5NAmAtK6mrYgAKqpMragMC8joW6lZoNvN1frZhwMEYc?=
 =?us-ascii?Q?QnmKhpl+zAhmgV0bPTyQ8mQ6BjPGK+GzvMiE1X9Ww1/ry2TBJC1ecl61Uf6b?=
 =?us-ascii?Q?aAoNyQskAOdiZbu20etO21UkNjC3Hc2NCNRIhHHEN+1qil7E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd237ef-a57d-4039-98e6-08de9fac1c69
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 13:44:29.4595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHIIiLPTNX5ZGqut08DOWZYu0asS/O6fql9nsY9EjPztYmEqEZpKKdEsP4BLuPAO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFABE38415D
X-Rspamd-Server: rspam10
X-Stat-Signature: pxwbfxtmtpopmmzbmsffd5nqao4dw6yz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3946C40008
X-HE-Tag: 1776779078-961909
X-HE-Meta: U2FsdGVkX19EpCGSQBXcyzPjvq90NYzfoFrmTBHHvDbX5kE/XpVLQcX+Cxlblu0Ln1TzD0cdf886BcLL0iYrAwVRc59U61YbwHPpxvz6tBocIYWYF2o80yteY/nCxUL6uCj6JKXWVJa7q4R+YTabigzZkd04YbMDgzczoqvXQfmBIBxtC+YkvECXBHXkZUJisL1ZJB7VZhZ3lRU9F4O96kaGGSpZwjEVm1AMvxACHXK2/ucWMps5qCd1d5O+7cmxP02SgFadOixE0Pnpn69OLH+6RHK8q42QpVPCvuu+jrYlfjNOSFaO8Y8/gPgmM96GhF878QJ2nyYjrKp4tYfXWTz2CEbaKhTm0HJXVcZ/7sUb9ITWbCG4JNwdX555hKCInPWU3LPh8FBA4RGcQb9tyDGwTlp5n6okce1wMIoMh3fKB6hXUG5SMDYBanflNDvohRyl8p74nP4SMETP2/MWc0tnrTbHeBsu8yBrG2zD4XE95NHSbkBfUPzeBgYRm9grIQKUfnLVzQiJJZ0IG8rQekTMnv0PiIJaonkM5RPbIDevstVSIbAxqdPWFCG4DBRckSB3uEr9kxA1Y/wjbhRdlKSo0HHrWd7puy8FhoefZHexJJj3FdY8ur10LIZg16M1V6qZiCezT1gJrhwuJj0QXqTnv19GR0ApRdEwYZieVb0EYvZWNrRwMTETAeu/WJ4OZiXcd9LwR8eDWUtwrmp6LCJgsCKYzhmBKYcjgOfYGlSXByyB6SZFwNhPvTmMqBKDESDwCMGKwxwqS9xN7vtsVTl9PrdjCaMY32AZ3vWGIBpPg0njXlF4qGaMe10XDw2+c/qHRZPbEaSpqEPlyx59Q9QEtf5fPu1olgqUMuA/1t9Am8lUA05Yb0PDPvL+DUSbs66Z5M1lO/Re3W8nRKdHNFG7eYSHv8kBKEC4HxNK2Jw2bIgDOc3u7HG8Fp6m7NqjnlGr+1e70ZCvI7EvWkf
 tkux7NLT
 RHuUr3pXEsi0et4F0r7jSHQuGhk5L1jDbIsEDtICZG6qBGaBwjSXz/p5sSh8MhyxEwjdR2aW99EZevZfnEDsa9NtOz27bNlLgUu96VOmY+c++qJeyikwNlA8bKgUoGInEiqbBIDaoibhstdrFfWYaYTxytVffBRd3fwmVx+SSjFJE6sSfCVnqq4mmUHW3WC3nznHVBVmjzoozZGehDjXs+aW/ARoES/3pIWmqThAubjbPiwdAWoggMVLt1FiywG71jR5iGgnUxQPo1JmfJv1AjhfNLzUppZw8uCFA7UWOOn0pMK3yC6sp7c301JpaQpXqVCN1nbgw7k2mJFHGkLe+wsjpLZ4lQ7P3ySx3QunLDNzs4STK/q48u68lDOtkFBRYrlUTNnK1RiTkl3TPI6cPi6MYvGcoAXE8Mz+Bxn8a+6yMYnO6ML7b85YzUfNxk+OHC8tx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Apr 2026, at 0:24, Hrushikesh Salunke wrote:

> When init_on_alloc is enabled, kernel_init_pages() clears every page
> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
> kmap_local_page()/kunmap_local() overhead and prevents the architecture
> clearing primitive from operating on contiguous ranges.
>
> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
> clearing helper that calls clear_pages() for the full contiguous range
> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
> a single invocation of the arch clearing primitive across the entire
> allocation. The HIGHMEM path falls back to per-page clearing since
> those pages require kmap.
>
> Use it in kernel_init_pages() to replace the per-page loop.
>
> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>
>   Before: 0.445s
>   After:  0.166s  (-62.7%, 2.68x faster)
>
> Kernel time (sys) reduction per workload with init_on_alloc=1:
>
>   Workload            Before       After       Change
>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>
> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
> ---
> base commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
>
> v1: https://lore.kernel.org/all/20260408092441.435133-1-hsalunke@amd.com/
>
> Changes since v1:
> - Dropped cond_resched() and PROCESS_PAGES_NON_PREEMPT_BATCH as
>   kernel_init_pages() runs inside the page allocator and can be
>   called from atomic context, making cond_resched() unsafe. The
>   original code never had a cond_resched() here, and the
>   performance gain comes from batching, not rescheduling.
>
> - Moved the !HIGHMEM/HIGHMEM branching into a new
>   clear_highpages_kasan_tagged() helper in highmem.h, per David's
>   suggestion.
>
>  include/linux/highmem.h | 12 ++++++++++++
>  mm/page_alloc.c         |  5 +----
>  2 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index af03db851a1d..ad0f42d06ce6 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -345,6 +345,18 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>  	kunmap_local(kaddr);
>  }
>
> +static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
> +{
> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
> +		clear_pages(kasan_reset_tag(page_address(page)), numpages);

kasan_reset_tag() here removes the tag from page address, so that
clear_pages() can use the right kaddr. I thought each page needs
a kasan_reset_tag(). No need to respond here, as I am reading
the code and trying to understand how it works.

Acked-by: Zi Yan <ziy@nvidia.com>


> +	} else {
> +		int i;
> +
> +		for (i = 0; i < numpages; i++)
> +			clear_highpage_kasan_tagged(page + i);
> +	}
> +}
> +
>  #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
>
>  /* Return false to let people know we did not initialize the pages */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b1c5430cad4e..1aaf7f839ff4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1220,12 +1220,9 @@ static inline bool should_skip_kasan_poison(struct page *page)
>
>  static void kernel_init_pages(struct page *page, int numpages)
>  {
> -	int i;
> -
>  	/* s390's use of memset() could override KASAN redzones. */
>  	kasan_disable_current();
> -	for (i = 0; i < numpages; i++)
> -		clear_highpage_kasan_tagged(page + i);
> +	clear_highpages_kasan_tagged(page, numpages);
>  	kasan_enable_current();
>  }
>
> -- 
> 2.43.0


Best Regards,
Yan, Zi

