Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3C1F55437
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381E76B0089; Tue, 24 Feb 2026 21:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C4F6B008A; Tue, 24 Feb 2026 21:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204766B008C; Tue, 24 Feb 2026 21:20:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10BF46B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:20:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB75F8B7E4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:13 +0000 (UTC)
X-FDA: 84481374306.04.B302E3D
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC8FFC0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y13mfUq3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771986011; a=rsa-sha256;
	cv=pass;
	b=VfGMqX/yYg6jyy2OXAyBTZ40Br+AVo8++ls10o9liaZBdW+wIhdIlrD2vhuHjO0WaQG4ko
	h3j0Uo/S2WcJuBPg7KCP1iO40U5S21Yid4bVGWn36mJpKwkgW8PpOY10OLuO582mxfwb7J
	T8dwVjTIdeUellfnxP2m8IHFqumsedg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y13mfUq3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771986011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3Eso+uChTNM8CSmK20TyYNPEJvV1oV/lUMLWAMxi1I=;
	b=Q3lz0hhowbBYOcoVEGgsVQlL2BuL/L5Jj7kYm+1JdSKazGKx2HsB/O51ZHwqC/MqSLFFBZ
	4xH2kBlikdKgmP3Nan71kVCteJtpBvGXDO3wN2TdgE/mJ/+Btbj7n5HHmA/RvXwMfl9gMr
	6uMtIyb9yv7o4tTpY+ghTdbZMXP1j/s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQyEbRbQiZ8Ia2c/RI272c+DhrOJnAxglf6AwgdJHMbF7jGeWaKMod7KLwQRA6Fnh/ERgKf+XpbW2BIykzimKv2WS9953r8ujA/gyG9YUqKT652y2xTJ1p3G4c+/tMvzHi4DzfdrianJscrjO7InaXeArAxiUXjXuG4v8V4cOILBT2fkzTgiMV4YPAqjbZti62ef0tmlR61QvnlfklXQRY+D6G6QCmqls02bU8RT4Fk+mEQKvOO12pD9bPFekDV+zW/07sAbZc/NWXKx1GPh4tYYYLHmXKIgRhzgO0q4aIjLbHpUG6Thr7Sq3KkrUyLg+c/nc14JhZeI7AW/zUML2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3Eso+uChTNM8CSmK20TyYNPEJvV1oV/lUMLWAMxi1I=;
 b=M4GwSIvAFRlkh/+cOEHhtJDcB6qKSOkjvT60o55UizhpOtT/a8VphpRbVN/N8J7YczjM+7y73eILwHmlifhqibJQruEeaGsdeD8896kCIxzOZFZrH2BIM40OkLrqI7u3W5r0IZVCOwrykzU0lkcmBHUCeIOzd6xVVLI8/MrU+s8t6pU3fMzwN116RYlM+A6TVo2mqjXPBfyUoWRS7jCFzMfX+aMmbLKoI5e+Mu/HPKSMpoJf1y+PE6lsxrl3bzG9FcWDpJBwuphOysi6rC+8se8LbILgJ9RtdmWBQSjvl/wfBOys1VS3v8YdXMPomp70HSunRF87vWhnk9fWnjeVaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3Eso+uChTNM8CSmK20TyYNPEJvV1oV/lUMLWAMxi1I=;
 b=Y13mfUq3bJs2I1oN7L8PYQXSTcRvO9ySSt83z+72lSkdFCqZTepWoldPKkNo1Qdz9Xis5ocbFZzSQrRLFa/mBduS4oF0+L3F0o6VBbFCFlt1pD5kjhCgPTkhbD3SIdO7Ac1YY6seSvCCy0xMj94egMatZMcxqGass7HJd+yoXH9/DjClw2UUhEp5yHYwvhB+0nE+IgxGrn0YL+cbxtjuCiAS0ugCUWvhZjmKEg03YhJIyUEBCxgFVEiegpMhUJgcHMHU3+kTWwCt7yRzS3Z6D5hwf1ekeWxhVtjTIjI5AH6hTt4wkAK+ZACo/lusYS0FWJmaKqQOTdnp+0n56OUhwg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6805.namprd12.prod.outlook.com (2603:10b6:a03:44f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.14; Wed, 25 Feb 2026 02:20:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 02:20:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Zi Yan <ziy@nvidia.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 Ron Economos <re@w6rz.net>
Subject: Re: [PATCH] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
Date: Tue, 24 Feb 2026 21:19:56 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <EA1FA78A-B972-4B04-BDEB-B16C2E538D53@nvidia.com>
In-Reply-To: <20260224213946.2328419-1-ziy@nvidia.com>
References: <20260224213946.2328419-1-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: d4e1e893-5396-431f-b6d1-08de74146286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xjfJz+MZR9wmI/N9WwSlDdXr5MwhDYFwzafP6ForUepI6Q1cE+1gnRPWqeok?=
 =?us-ascii?Q?C3sMHHj3yQnnbFNioEejpK+/OsG65kEew3k/xuwb0hYAhacrGLHiFYOzxgss?=
 =?us-ascii?Q?mrN7mSVdy3PextrTlrHACHveGeJ6dxLA+GwYGRHM7rCXq9iEQLD/DbNWB6PB?=
 =?us-ascii?Q?MEHYIfBCVyema5Se7E7L/+UTAOg6ahJtPNU+9fSr/GrH/ImCpShtRLUbDp6L?=
 =?us-ascii?Q?teOXIkNfUW3TTWy0JKXwpUFSYkJcCvtVzYDFKOwieua1jbCmJEnknxQcbBo0?=
 =?us-ascii?Q?4ppTS41ymUclaJ6/UIKERPgQOxj6TGR4wjz+3QzZiyevHotLOnuMevZQNGKz?=
 =?us-ascii?Q?heHqzT1Rg2f/F8YJ5FGUdsEhNHwzf4mhpN8NAHnGMdt0IdWaxbteTtxOHsMA?=
 =?us-ascii?Q?RjIVPMbKUFN7Nu8JhHIh70PBMN9czxQCGqcfs8wK/mQ1kFD5YXRWL5cYQQzj?=
 =?us-ascii?Q?+abwYXzrBYT7mDAEgfHdGAscQwm2D49k8tks2aKwyQhGiEWmmcpVa0rlHJj/?=
 =?us-ascii?Q?jQo6wEB7lpYmjYXBbq6UTNbkOVbw4H7Ai8Xn5y7e+Mvx4dTayWrEVdAbVQF/?=
 =?us-ascii?Q?mMDHnq+8vRRupN6qZZvgRWkJNUmPcQZM9tlWYKmV/Vjv7l+waxLSFmQKDYc0?=
 =?us-ascii?Q?+Gt0n4I7nGw+BkXNRJ6v0kJhzI/66oWj/ZoO0y7uxwnlNW9+rI8mA/LFp0MD?=
 =?us-ascii?Q?+Tj7Kwm7SBax2vD0YDH9k2m4UphyZ7U5Cqr5MNqn1A4zKq6RWsZxvBNL94yz?=
 =?us-ascii?Q?T7roz2/MFrFK5lmIc3wF4nRWFKz3hl8A+50ZRnY+5c4wtBooYs81tXqIukxz?=
 =?us-ascii?Q?FfPhIGYRyGZBLodhTlfddhvGCISoR24YPvejjC/lFiN9pHABdubEXgCMCUJL?=
 =?us-ascii?Q?GZqDaKuAEZDNMFRwaBMc0AKWn/YpeWk0VH1urCogqE4xb0+yiBD2kyd1eIuf?=
 =?us-ascii?Q?VgWtIKOc60fFoCg/isNp5xnmFkc1w5D5vFyAQ9UGtxnq80rZ+9D37TzIKlXu?=
 =?us-ascii?Q?Cb5TnaRqQdBcBJp+8R/hwqBhHC5qXmxRU2YAPlbPznRP5k17vsgXC8jbeHMT?=
 =?us-ascii?Q?XPNWhFJPREjeXDhgVXRjKVt+QkyCaN0qZRYHiqfPclnfS+tY59phylsXLfuG?=
 =?us-ascii?Q?Ny/ojrtBNhi4javi2UctTLZ7ocrD6zZmTueIH1ONc+RN0aThb4TjKU18Mrqa?=
 =?us-ascii?Q?d7JoeuTZnhhfI3Rq5F/HV8KEZC9n3qL5tFE4UeZFYXDJt2/peyNcblV6MXa5?=
 =?us-ascii?Q?FFb7besNb0kKzBY8iz64dmBJBwupMHf1w5P3zYdnBfhi2th/z3eWRkVtWsrp?=
 =?us-ascii?Q?3rXJJLXer5S2wUOsoWQgFmRSu1rtKZsccWrYOpthgrjq38z0KCUpNC3d6cjM?=
 =?us-ascii?Q?ht2pZ1B/C1bZ9Q3HMkOIT85HME7c0onYlGNUg5rsoHu89fSOT1dyBl3Df5dX?=
 =?us-ascii?Q?KtXYR8thi83y0SMy67BC1LVqpl4AsOkep1nOrCNnjPNcCx+Opq0h8gVK0JlV?=
 =?us-ascii?Q?KdC0nolH5yeSXciZDYylxh3xiW/w0MKCe3I2Ami3sv2X4d/e9KKhPxSuH/4U?=
 =?us-ascii?Q?Wl0XWGM4rsKaSxBRzPI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zWhZrC/gm7zNHfD56B5RddOW917gDhDJggfxzefdlXdeCCBxqTvjeFAQBwEv?=
 =?us-ascii?Q?B6u2CZpkgjMHlBk5ffqtfS4/VZgyc5+7M8bjstRTa0QnT9eVNnYWiLG0xzZz?=
 =?us-ascii?Q?s81qpbluRfGhZyL/o7VvZs7PN8YD2Gm8E+T6A8W0uvaCU4B3bT3jVyEOxjCc?=
 =?us-ascii?Q?a90fkshZx2R1j0IECeYC/hUpM+V70Xas2gfp/iLq+9CM8gs0HEGBOZRnKCPA?=
 =?us-ascii?Q?ChorAYbKR3wIJYdxWfVHtpYeaBa5GyQdQl5qW7NXuJfnpArQwJ+LVrBu8vT2?=
 =?us-ascii?Q?xMDR5SZv6UmQCd4CDlMcn0sD+I7dJhR/8l/tLvjDYL/w5AUu+2RJL2MW2T+w?=
 =?us-ascii?Q?pSMEshmwlak0UjQZbOAEkxqSG0qPm1u61T98F1PsOQ2SKjGOfaWvm0fPKh/Q?=
 =?us-ascii?Q?KTXg5tp0nNwmF26qRbcU8+aBSq0LkU+RSI53bkySVNhefJrfD8FjBr56CpRy?=
 =?us-ascii?Q?q2NJJ3GxQMhJDWTPgnlrkGRlnFeRbNdKJ7SqHYHE5SHk9SjUElrz/eogUHEQ?=
 =?us-ascii?Q?AeFvsXtYcAKauMMyrOLfdWrAzRvCRDBDRfkOk+kw4S7RU8YbiLR33lakfDl5?=
 =?us-ascii?Q?7TB0OLBlxBII7Cb6UY3h+Q4nZjZZu9FqNaS4flgchHnrOHIBmKuZQ24vAe93?=
 =?us-ascii?Q?usrBhEiQSW06pQu1/c5cftW0vY89XbtW2TqMCvrh9w7zbvfnpOoVil/QaJ4N?=
 =?us-ascii?Q?ZpdxIklygT8567orRzGSEdOjDRZQbIo5kA4hg2zsR3uS97leIAa21KqivX5G?=
 =?us-ascii?Q?bV64GLj4Lh7QqUJw+/AgAEoitJP7d1eTY3IjyvEeYBryaHuxdkkyUf0Ds/pV?=
 =?us-ascii?Q?eJ2xMumcyo1b8eOwRajrl0y07sISZZEnxhnCNL4czuSP7uWM+VzdGrQMRxh6?=
 =?us-ascii?Q?1Tk1ao06cBTS4xhSUtoy3U5PrcNR4W3xtu+pj7JuqqVa6tDvnT6+cNgzrLM9?=
 =?us-ascii?Q?cVnDCfa3SG2zJLvkPcfHG7XBk757UTE/efYS8PGeHrNaV0RNcirrAzWETWDt?=
 =?us-ascii?Q?KjEK9B+CkPemvrQLz9xWUIOU/u0zh6Gam85ajuS5NVOgRHs3/eSbrP5b3OLK?=
 =?us-ascii?Q?ajFsXtjxjRy10uTQtE57LuVCiqtG79Ls4xL05u5/+WXcL13Raj6GM99nkk+Q?=
 =?us-ascii?Q?dyRhwpS+rFvOk0nAySvHuvYzWQ8bTo8Dp690g//4LyZOQweGP8LibQLS4wgw?=
 =?us-ascii?Q?N/64Q6xOJS3ZPbCupisDJzIeC/jGU6zEP7oyeZmne3cTTEqiU6834MN+2ng1?=
 =?us-ascii?Q?9CLguxrso2OLFffjAHp2/9kSXdEADUkq24dozF9jfsSB7WRggEQpAbN3hOpj?=
 =?us-ascii?Q?DcDovqNiNKJsat+xhGBuziJWAcrejFQsxAb73Wf3DWu6XLJKoOpQsG5BYdkQ?=
 =?us-ascii?Q?BE5GMJpyLxagCHzkEgixcAIB+Pqo+PeZ8i0Q2JftatcsCsXWxOK5fTkDqV17?=
 =?us-ascii?Q?+2jHGnf9OW4ueUItwX9VUE/SVGHotIqoaqzQaHcjyNJcmAiMhX1bsuc4Ia02?=
 =?us-ascii?Q?eWhmkQt3kdDfC36I/Z9i5cF5+r+GR/u8qMRbIW7BdWILZ+VJ2F2sZuQs1Yef?=
 =?us-ascii?Q?zzUM/N6Wsm9nGauJyfgp9OSpKEd0woOIMSQeD7k4A0UQ/0P4VIlUU6Mflhsx?=
 =?us-ascii?Q?Xztz5KkBVzv4QOBTXLqUTwDx8HfoxG8zyafeH4mmJ2hUigO5A5AKKQBZTJyL?=
 =?us-ascii?Q?KIjVSnsg0QBy4lY0WUMDcNokEdeEZx5ltXCnDmk3xn+FV5Xe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e1e893-5396-431f-b6d1-08de74146286
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 02:20:03.5336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hp/WeGIK2dYGuEFX6qlvnZeU/V3iHCMUpi+IkQLfRHlk2fsbvg3KEEBJ6gydbUx/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6805
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC8FFC0005
X-Stat-Signature: m78hrzngrpk5c8wiunqsbo1yorb6em5u
X-HE-Tag: 1771986010-937650
X-HE-Meta: U2FsdGVkX1/HpSVKk2873+xiSGaEcc6KY/2DTljOtcDlIQl0OgxcfVTfLtEJUHHmhHECuCBV/WF+/RMfeq4jF/yTRCA1PabA/TWelhVrn6OqSU/RqE43XddoBWK/y9CembYGO6M/KZh1tff34UhBUBi5VERJ+Eg69iXWErVVdshkbWM+WA0bTQcJ3e4j08DfEQLPartvyHpvZUwbMWiOeGOWGrcYS/rfgP4vSoGjAWtyQJHabaClfVSCR9FsY9lJNRxYDsx4UX0FiBIZOk4DCAEERP7qm33rMnJ1GDW/wU0oRW8vqqd32BzHTpokN1u4RqDo9bY6DcMflsRsT2k8u5avt8aBMjrpn+GD9GlPPpfaA6IbVBMaKzJX5+y8ZS1ZsKchRGAbKd15duUJejGH9LQCXjOPqkpffnQniYTTABwuI/7aChIwE63I504k99f4ie4BEEtbpE4yaN+lFzdt7/qEWMadrJnm81T3tmMSbGmTQjz/kDvBSMOxCAX4Uc8auX3fKTyEq/A0c0A4xd4VnHdpl0yl+tOoXfCF/bmcQMHvGyKoUknoW5lk8kqwkU5+wZcLYnXCKgC6JRLZqOiHdg5hwOsEsij6J3k0EUmTS5VvXznb2uZozCz0v9VEREcrirNTbhsTilvjE08pijuWb9if8rMq7MFvxB0xMZjKEiWgXCUWagZ2rSCKU51NzOvtnzT3AXzHmMUkUOzWqpjzdPvC9t8xexOY2SJF5a/x7QXVAMp+BavHusWB6K7VvrZZBsiuu9BawDMBFARRUyq9UyGETJNA/d1/OZ6cJJwkmciiMF8RkmjVHGnMtx+HratkIM62wnRA9GRhpYjVOIh7tbE7YHlqoNfa5O/h1/4C9WikcaQLVw1rolP6w5Sa8Q6AIGD3GZynGWCUcPCHr8iRM0VMHETmc04qpd8uXs1r0DRIWfAkOE7orRh7XHJ/to9fcMdzJV9y8avXGybz1aV
 ZzSvXVNI
 KtsgZp2t0FCnXZtOBhUCrVSkjDGP/w1jJ32Mpq6mzfrGYBwgS2rDgR4ySChs2dDD9emkpaHvDuH+/C0d6PsZM2GhrIr3XhQw/oFXjyityxcixxPa6EN9VGN+bARcQ8ldvdAjwtcJbPVY6un8FhSKhWnwDVMS7LSv2dzFH1FbLmIkxEBz1WwUJM6QfQc20G4DiXq+63cM/Z9zJjfVI5ZyfQqyMyvVNJtdlSHTxMMzgKSXpzvRWl3nS7RQY6nCputJKQXPtq54gGtBMtXakXQDiLb+6KN2yP80MtwnOgZ8cxffyoQr/yr3OG39T0ZX15OoYXW4fDYS0GrRKnTH7vHlLRejbyTj7B3ZscCZGzqIkt1X6bXiwu+9ZiysTWGDSeNBf27qNxRygIHi1jg2Qwm4m9+IY7IP8pDPQaYrg1e5qiCCv6/XKETRe72Zwkk5OpMeWW5qCvv6tmn34FLj/iIpjP3JpP25D7WCq9T7OHJr10L9F5N9OesclkHgx4355QYnudSuL/hEbS2cY8EFEAt9xFwHBYTzPGUtULaD0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 16:39, Zi Yan wrote:

> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any state=
ment
> with side effect inside it is incorrect. Move put_page_testzero() out a=
nd
> check its return value in VM_WARN_ON. Add __maybe_unused to the return
> value for when CONFIG_DEBUG_VM is not set.
>
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada88=
5@w6rz.net/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> Alternatively, we can use WARN_ON instead. Let me know.
>
>  mm/cma.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>

Kefeng suggested a better solution[1]. Will update this one soon.

[1] https://lore.kernel.org/all/4b219cd0-9391-4edb-83c0-b6a1c60d0790@huaw=
ei.com

Best Regards,
Yan, Zi

