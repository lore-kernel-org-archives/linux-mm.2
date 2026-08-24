Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF8EFC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2656B0092; Mon, 24 Aug 2026 15:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952B86B009B; Mon, 24 Aug 2026 15:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A6E6B009D; Mon, 24 Aug 2026 15:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 506DD6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:51:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9E7CA30BE
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:51:54 +0000 (UTC)
X-FDA: 85137208548.25.151193F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id DCBE82000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:51:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ap0Oft8o;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.41 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787601112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvg2RTtQCtdBbskKEVsVJfD3U1Br9Yr6hyHXBVPYfF0=;
	b=q+dheT46SM5FDOXfwBgW2F0h567dEjVk3Uv0bTlv8mjEREsABs+Ua46yACurs2moAnoeVw
	jJd5PldXWP/mh2MhU+JtNNb812lhk+BWBRK/61ympcGBJwqDEmTB7R69KBDF356zjI126W
	c2xlImbICp00+yMWswvrh5i2bIvBf5E=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ap0Oft8o;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.52.41 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787601112;
	b=OJeZ3YV6+NfVretKVGtTowghKlkFDlKWSxlh3XPPSMUMfsnq53RL9mVNifgXLNikdIu80H
	HVlliWqOexwEhnKPnH8Q1b0sDwLK3viW0G4wegmA5HM0iAXgyX0sgn8QrHFAnTFACnyTvB
	fRwpiQz2LAIy4BNWZfG/f7faO7UbGfQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCHZesVBBYWEGRHHeizKIGXmjA1KncH03wGxW4GjkVMKQ/IeGkhOV/CjpPFWDVZp72lal8I/c/07NqhLSzXueOwF4Xo1IeVjCDjdTWblQS8cj2ATrcDjoqMHPQfqqkKObkcg8b1NWyCzg/0VJpu67O6hMVgd+CsRJ9dd7I4yI+hWujlR1QLrhhWiRxH1VyT1QhE7kQBRYS/4NKXQgUqGgYZeaUnwBeD/YQ+Ydu5u9L1IUJE9FJpfDqqCWZRQcdNb6D2m1cVM2QQ6IyrqtoC0J5VC/J76bml/M8rBLtuK4BxIc7B8EdQtnqCXe7cgwKMfvWDeknsTi9lijU4How+dsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvg2RTtQCtdBbskKEVsVJfD3U1Br9Yr6hyHXBVPYfF0=;
 b=y2iQemj3Xg62duyrUQ+w6XxY0b0srtcesj8Mbd5DSSaczawQY+7bnjWphin1DfAZByh5x+E7rV1sC2zpnNBndKMs4OLGkfnHnu6AoHOGwMOPbY/SlHGSHhcBXPD+r0Lgf8XZMZMikhS8t4dmWVGAP7g7yTByYyFkORAOojCSQ+7vWlfSmIhLDXrQ57Ve8dUUw1qsDVlAgXSWsWWFy2WmTOjCNg+GJg/VPeM32G1f04Zu/+KzBWFrcy8UFe0X6+RmYqUpLT6qitWz5OF6pwsECKmadNe/NzUvqB8H5PIWYfOkRw94oTQqN/PSMS9ylAZ5i3LIPgX5445XuiGdpE1RVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvg2RTtQCtdBbskKEVsVJfD3U1Br9Yr6hyHXBVPYfF0=;
 b=ap0Oft8oueXl/nD4DRfyrDF8zoWudreHGowyYOyE0ZpSAw/PKSmgWxjHPUi8wMFe2Ax/s1mXPhRN5ysEjnSAHepOHpdUPrQnfbD2xQcn4/EozR5ClJG19IAax9RGDBzJOImh5z7uO64Tzx/ZVUS9xkHEejdGpMsCH9NCgJgpRLJJgjxncYlV5DYyz0iN0cg4bVbibIgr5dcIxyM+J2dPxxGBT7Od957LH2ZY6c9VsyPNWHNfMchVnG6VlmwMWpmkjwZMII1Q+I9S+EZmk9MgBvdiGSosAf7q1nQU21/HIG4+wUUjG70KwiSGRhaQV07qAhPUq9wI/bGKH5lhL0bD6Q==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CYXPR12MB9426.namprd12.prod.outlook.com (2603:10b6:930:e3::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.12; Mon, 24 Aug 2026 19:51:44 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 19:51:44 +0000
Message-ID: <764f2f23-09ba-4203-a304-94c0fba32db7@nvidia.com>
Date: Mon, 24 Aug 2026 12:51:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
 Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
 Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
 Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
 <aoye694JQLwUuqxC@casper.infradead.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <aoye694JQLwUuqxC@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::16) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CYXPR12MB9426:EE_
X-MS-Office365-Filtering-Correlation-Id: 72342217-00f0-4608-e333-08df0219202d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	YMmCNJTHsBSB+aBNGZtZKSuAD4/MMMceD+W9oMutsI4nCnG5rUIbh1/mNfEv9bukLzXxpWPmYK8Wqyz/17ET69srWN+/Gfb7u5KKawXu4HUYmd39kbWMuMS3YWFFxMmw+kJaOQ6goRGv4YAqR3LDSiNU7IqPT0KdR+ORRo1tYXs2YMa2Y0cmoXJp0rMhEji4SFIlEtiuxKaOOoBnId9fUiBnx4kxX0ZBk/tJbHxyNucCH9OOJB7xdEma0CvyHH+6gBK5Qt8CQtF6fsi+mosEntiiIjc6LUfqLxvbOChScMUK6gTwLQyuaQZAoLz8F93NqP5w7txjvGd+sGM4j1ytMwI1V4idx4KzT1ZojANMVmKMk1MHlOzLhVxv+kZz5TLKkEQ39J29OnT8ffbDofwVUQNOFJH+yfoTwks3zsBSSea5n4nddXV2UnOZQeQ3QdhhTzR6P+m3Dua6/NR5wXEFU45zdZro/qsX3zTDRlMfueYGc9V8MCKiH8f0DW5H+iz0YX8PLslbpsoFwDKMzRHiGPtwKqOXN3LMZ4ATmysjsCtsXjBT7GuxyrZwapDx+lf7MTvRQV3Wf6YMftGa6lZMQJIgQ36Uolc5w+2VVmwXMT1TBPnU11D7zwT1pERkk1nirWpjE5pALBDcYj3EtZA/UsQMXCZ05T1mFCAWtrWv/mw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ck9SSlN6TGFoaCtrZlJRUXBPTG00eGhGSFVzeUt4RU4yS1BFTkV2VnM4enFL?=
 =?utf-8?B?aWMvNDFYeURNcE9yNWdjSGt1WmRDRWlYRW44NzMrYXFvMFMxUGRhM1JnUW5v?=
 =?utf-8?B?TmNRMmdKUGpBUmNaQUlyeUkya3lvdXNUT2w4cEhIRm9ZVGtYQzIzdU5oUXdl?=
 =?utf-8?B?bmd0b215elprZTk2eElQK1dGQjNKS0ZjUHlQc1ZFelRDd0k0N1UyY3k4MkNt?=
 =?utf-8?B?SmFrSXYyQWtiL25aaE9rM3VVQWhPLzhHYjd5ak9pVTVFdWFnRVIvTG1rTERt?=
 =?utf-8?B?U3paWlpkajVhVXdsNndQWnRIK3Y1MG41cFdzQ1lqaVRvODJJTDBWM1A5WUQ3?=
 =?utf-8?B?d0VnaWJlT3JFTnZxbU1DRjl6eXY5WXZGcm1WMzZibkV1NkQrcXFVMGE5STU2?=
 =?utf-8?B?Rk1iWko0Sk93RjQ2NVlPZGNCc2w5N0NOOGZKOGVXTlVnbDFKR0Fqd0tlTDM0?=
 =?utf-8?B?ZmFETEZnQzFtNUxoU05vd1ZzalZ6LzVJc3Y1eG1yc2tacGc2Tkx5WTBUeUZN?=
 =?utf-8?B?aFhLVXpzYi9oOTVpdVFUWGlkekxaVHBUL1JRUkxrODdjVTZncTRsdUFlMXJF?=
 =?utf-8?B?Y0xJMFh4SFk4WW9VZ2lHQWs0T09uQ1BNSWxLR1BFS0x1ajNiZUxVeWk0R3hy?=
 =?utf-8?B?TUNTREtIRlEzbkZMTEFlTXhIcEhUVGN6OXl5NUtCUzFlVWxmSmM5NDQzcGRk?=
 =?utf-8?B?SldBT284M0tGVjlmcE5vZXlQd081V3ZSTUZ3OURKK0NiMkZ3ZDhyMlVXSWNs?=
 =?utf-8?B?Wk9rTGZuZ3I2dWxjUlh1QWk0NjdFQlRraSt4Y3U2Z0c1Z1JEUmVFeVZwMTlR?=
 =?utf-8?B?ZHFnY1MxTEdIMFExMWpXNjVoUkF6Rm8xOWxrQ3MwUDBmc1pQL2dnaHByUmtM?=
 =?utf-8?B?YzFsWUZRRjQ0OWFxaktlelI4REdwbm55ajRrRzZNMXRHMEZEZFRmZ1Z6V1pk?=
 =?utf-8?B?TlVJaHhaTHpXQnlTNnNHRy9kQTFxRzhuM0ljaUZTdUVEVlNuZGdpOGd0K3lu?=
 =?utf-8?B?aFdTWjdqZ3c2a2xMeG5lWjFqbzVaRitndFQ2SXRmS09PYUJYMnYwL0JkZHdy?=
 =?utf-8?B?YWx5Z1hIWHhIQmRsWTZjSnZTTzRZWDlYY2gvVWxFMDhOdjZmOEQvWEJOMTB2?=
 =?utf-8?B?Q2xoWDkrQzFYR0R1SUNjdXRRNFZ0SHNyYlhJSDRsL1Z0NUF3RXlDbE9uMk9S?=
 =?utf-8?B?dzFFTW9qbVVGd3c3RjJ5RCtOWEY5RG51NVprSXpiSGxQR3NxU0lyZnpVbTN6?=
 =?utf-8?B?bU9ESTluSi8xOUlUMWRxQURtT0dDUVlETVdYSFNjUEF2OTlxcjY4Wk04blE3?=
 =?utf-8?B?MVJ3RWJOdmttNWJnTHVBSlM3ZlBUSWxIdjJKZlNVL1NIUkRRK29waUs2QlMy?=
 =?utf-8?B?NWhDVTRsTVZVL3Eva3ZpZnhBTnBUNmpRclQzdHhWcklQeTJOemJDZHdjVzFz?=
 =?utf-8?B?amIwOTlpV0ptMmpHUzVWUGxLNG5VcDJVcVNrSTlSWEFMSm5ITS9kUUdDdjV6?=
 =?utf-8?B?U29GSWVRazVSbExudlkwWU5zT0NUVUY4NjlsdU54bk5YbWo1K2txNEhJbVlL?=
 =?utf-8?B?VGliRU1kR2lMOFdUY3NDbWphL2w3WUJPMFJXVDJ4RXlHYzRPQURraHdWK0xZ?=
 =?utf-8?B?QnY1bWpzZG1sblhzVjZndERJcDBGbWZZQ1Y5dW1GVlFxUHNMeVFvL3h0RjVh?=
 =?utf-8?B?VGVQR3BkS3dGazRhVU1waG5ma05SM2lyaWJlem9FZm1LL2tjMHpRZ1BpQ2w1?=
 =?utf-8?B?MGR5SVpEMlZkcFBGR1ljSnlsM3ZnNU9xdklDZk9vTm9OUm9wUkVTOHNSZXp6?=
 =?utf-8?B?YjVZVDJKOURuUzBDcTgvNVZlRGFRQkZiTFNjRGxmNnp3QXd0Sk9WNTNJcnA1?=
 =?utf-8?B?cTU0aWFvOGpES25yRmN0eUJ0dDVEOFhxd3RFY1ZTY1ZVL0hzdjFKejZJQjYw?=
 =?utf-8?B?ZzIwTEJVM0Y2cXBZYlZIYVpPT2JUempIc1I0UnBjQXU2TmRMQjV1WUs0cWVp?=
 =?utf-8?B?SzBuclZINk5JSjNvaklhTERDWEFDZGZsQ1llSFZHMUx5aGpBTlBUTlN6cllp?=
 =?utf-8?B?Z0RnL1dQRHJOSnRWalNOa2UzNkthQ3Y1V0E0a2Y0UkdaSE9aMTNmM2w3THdM?=
 =?utf-8?B?V3Z5V2VnU3NpVTNlQkE1NVF4Z09uQTdmWU9oRWs1RE1QMzdFQ3hFaC9iOHFO?=
 =?utf-8?B?Mk9jMzJrdEkxRHBzMWhuNXRPVm5mY1grY0JUcXFwc1dxVGRwdVVmWmJWK3d3?=
 =?utf-8?B?RHM5czhaMExqdTdiQ2tUZWtPZno1WWJEeFlEUzBGNjNvZ1pCMlltdkM5blJu?=
 =?utf-8?B?QXlHZXMzb2ZuaktHcElBNXRPMDFzQ1lLM1V4VTYva3JuM0VSSkhxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72342217-00f0-4608-e333-08df0219202d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 19:51:44.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HabcLUL0dW4GoZvsceuLK4QdgBU36vBMxzsFdwD4j29vT/bWu6NBYa1fjGktG2Q8V8ykbbPLe6HTstdRA3wxVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9426
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCBE82000C
X-Stat-Signature: t7iw6psx59pihhr7eyaxojty8npa3hdu
X-Rspam-User: 
X-HE-Tag: 1787601111-316401
X-HE-Meta: U2FsdGVkX1/wXbyenaL/IGVUXIoNbz6FYCh0v9HIXxMh9OU+AviwSCgU1kvaBhvSblcCQ81bruXlOeAFfsBHj1WnlGbT5fHL9RcLidE3nfheyOuCATdom/5+Y0iSvVyTtvjonnp5W4Z9EgQ5h3gCFCi8GclWfN6iEVeh97esY6TK0jfHtBEHzc4HLv2BNJP+6n+0rZif/COwKM+sZBiIv3u2FNsjwsMTDN7BcC4Mo13bvBe4XKB4cKbOxZa6VFjq1VvcFIL7GBog03WM1fvLRRbROpN5pmJH5ZPpwV3v7vv6xOcbweezFaAU5wpwBJF/5X9VU0WvpSW7u3M2CmMGaoIXIWnVatP5I/XKPUGQGyHPUepykMHCkgs6YOUqEAT+okVOY61aii6DBSeGR9Bu5MSI6q4QDVb+kl9jOFaNGOWNHID5qgSs9ag+JroP3btpWMh8FjwT/lBrvRMC1Eq6MX5TAYhXUAwaRfnLOS1gMX1VX0eb2oh5cBMcF1YyeHb7H8OErykz8iqFvuNi+pSvL4JLtQGzUphfXRIDk5FoXaKxF5W3CthN8QTjPx2+ZNjYgzlPIz9aCaLoA4DuDKY2Cf5LW4wMxlBLmnLnfIK6FvV44krNbFGpTrtsXbcQhjlienGBd4aRv23KBp4OjvseuJ0s57DeXMM763L1TI1y3FQJGrm02UL+wcXrsZFqPflNFwBJGyVawsWX2mubdgSj5Fj7Q2rHAZJGSNb97kIt0EK/xSrgummUiMn+BHknIDaSllpci2XrB8zSFZ1pf9oc8wRn+uHT6M7H6REzFdzSMLCS/W/NB86PB3Iit7GbtFMSrBAC8XJqD6vXPU91DgzTTUwxW/8Qu5kcrGgOsdtcFxU5bGcX7acr8gT37eL+s4boDRGc0fYmSgwa+xB2fvnn6Yox78ExFYQ7kbn3JCc6GIeDeMbcKzhTG2XoO/tmGzEvL7BaxAVThSw/NfFf1BJ
 VfWYTyvR
 TPeCGSc6i+sGxaNcVHt5T5dqByJpaE3ZV/TgASUT2oFIFEgmYlx4NtY4mddOqkSYbtHAcQvbF0j3kgy1y9i2Vohxyl9eNs/VGo282pdWocy7uZrYhrGbZyGbY4jin7S6n6oYaUpCOyXEYDlSBg9rnAMG0BbPBPGnyEy68laqilGrjV8QNHXBQ9gd3Ikwl+T7ZByjHrc4mjlfQAQ/m6b4NBSCwg3CY9iTHELyG9IK3t6aWI3IcyrgW3oW+N+WHSz4d9E8W4dJ+/wDxrYqGuVYX9rWrKT+YtkKa0K1o5bg0VlntE+Ma9rPlwy0JzhFs4Zk/WfU2+yn8QshjMzv+JfXBiZ0gZtK9t3gAn/7eb9zUxhAC4guTEtILkseEK3ur9piVMpEH0hMIy8JdOCwlIp/lsAFIq+tKxHGpA79WUZiQGlPdhxN+/t4wr1dhbZaQAXLG4/wnPJhu1DW/NP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 12:43 PM, Matthew Wilcox wrote:
> On Mon, Aug 24, 2026 at 12:25:42PM -0700, John Hubbard wrote:
>>> My proposal is this:
>>>
>>>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>>>    If it's true, do the writeback, but retain/recreate whatever data
>>>    structures you need in order to write the folio again; behave as if
>>>    ->page_mkdirty() had been called again for each page in the folio is
>>>    marked as dirty.
>>
>> Yes, that would work nicely.
>>
>>>  - The MM behaves similarly; we do not clear the writeback flag for
>>>    folio_maybe_dma_pinned().
>>>
>>> This will have the effect of writing pinned folios back every time the
>>> inode is scheduled for writeback.  But since we have no idea whether
>>> the folio is actually dirty (because the GUP user won't tell us),
>>> this is the correct behaviour.
>>>
>>> I'm probably missing some stuff here.  Let me know.
>>
>> OK, so working through the end of the pinning, I think it still is
>> correct: device finishes writing to pinned memory, device driver
>> unpins the memory but the page has been left marked dirty the whole

oh, I just thought of a minor hole that we need to fill: how to mark the
page dirty in the first place, in the absence of mark_[page|folio]_dirty()?

Under this new scheme, we will need to pin first, then mark dirty, to
set up. The filesystem can't do everything, because even if it were to
call page_mkdirty(), a writeback could clear that before the page gets
pinned.

Then teardown is simply to unpin, as discussed already.

>> time and still is, so the next writeback still does the writeback,
>> but this time sees no pins and so it marks the page clean.
> 
> Excellent!  By the way, what would you think to this?
> 
> @@ -2717,7 +2719,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
>          * Here, for that overflow case, use the sign bit to count a little
>          * bit higher via unsigned math, and thus still get an accurate result.
>          */
> -       return ((unsigned int)folio_ref_count(folio)) >=
> +       mapcount = folio_mapcount(folio);
> +       return (folio_ref_count(folio) - mapcount) >=

As long as the math works: need to not underflow. I guess mapcount is
always less than refcount, so OK.

So it *seems* correct to me, fwiw. :)

>                 GUP_PIN_COUNTING_BIAS;
>  }
> 
> 
> It should improve the accuracy of folio_maybe_dma_pinned() for folios
> which are mapped many, many times (eg a page of libc).  I'm a little
> concerned about races turning that number negative since we don't
> necessarily have the folio locked at that point.

thanks,
-- 
John Hubbard


