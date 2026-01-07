Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6F3D0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7780D6B0092; Wed,  7 Jan 2026 15:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7263C6B0093; Wed,  7 Jan 2026 15:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD016B0095; Wed,  7 Jan 2026 15:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486996B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:54:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9BF158384
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:54:14 +0000 (UTC)
X-FDA: 84306370428.06.1257F49
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013018.outbound.protection.outlook.com [40.93.196.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id 228014000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:54:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uYn6Zpxp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.18 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767819252; a=rsa-sha256;
	cv=pass;
	b=2vgK0QmQzDoCMt6A1fd/AbpLaScVTVdpIY91+TwZauxCUWGsMWaAuYJUoSVpJwYXv610K7
	pFmBgHcv4o5VlI6ZuZMOxhlXJxskhj/Yw7QcsX1z8NfzKb34LR+GkMO0IJAn5g5XPxJpks
	y5Cx3Nc/DMHIzpbN/nfbFANR3XhydPU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uYn6Zpxp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.18 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767819252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bg/+TeXfpGaelqWXlfi2WyIE54OghyTP7ekZYKuGuvY=;
	b=gKNoBnckr3RCNhPDn18yj9N57DIhu32R/la0O9YbjRk4ez+iz+hl4SE5aNdcGo0nZP98ba
	J4Uwmxx9uMtpwqJFEx3GR8MdhN5nsZ7J+rtvoHEu0IzDiS49CkSGeZ7E6zk306l6qfE3TG
	blaaqySRD4kRh3cSG6Ce7vt29098mnE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oBRP/ZBAJYnGJMDYQXpy/FypIkrjtEa0wlSPmJ7NQI7Sft21ETmvVCRwm9FnN4g8gD/bVik4mvMxK3RmYcGIMZx6eE/r3adBT6JCGS5MV95j1ZYcBuejmS4FooD9090aC98NF4IgGnPk9igsMC5nlprzw2qPXOJZv7zfysJHKFX3VzblmUvffYji5RfuGSuAjrKnM95ITFBOt+yB3bHz70np4+uuDfMWv59wW/OxfcZLIvsyyolwNz692qNMbYdFTXX8NY2p+72NN4XPxtYPqLFxKwwCXNVJwYjJMZwLdFMlYdGMdSUxo6Hm1yuEDzjeXDTotNcWyYFIbFc4xlJvBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bg/+TeXfpGaelqWXlfi2WyIE54OghyTP7ekZYKuGuvY=;
 b=TkqGSsyv8Sq9VOY/FGLYqXcO7AebmBK5hXV0tJ+CCkziuUa1HXc/vSxk5Ntic/B2duNOKvVKNsCcmfKOcZwDApxRBiiNcqgU2f+V3Tn7ZywQ4HK5kW0dLsuF8+zCzeM/4bkQbBSePCIU6d1wqCNfAqR0VcJ/9ajLfWBQr/Z0pkFRDvQ9/1Us0n8/55eDAWUMtDXO1UPzfWPTPsK0p0YOJyWJ/6UzR/7RTpnlSIKHNsGEOGpU1U5EL6Owv7YeVNDKN4IzqK+gqXdRCCSyNnbT7wjmSIJ37LPNfu2LZby8revJVLQ2YcdpVz8ScQDEjnMfJdPVMlNj/QR/Ga4PvVW/kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bg/+TeXfpGaelqWXlfi2WyIE54OghyTP7ekZYKuGuvY=;
 b=uYn6ZpxpoQKQAhE1YvSYwKljqRQjhtPvO+X7Vun1OiqPFQgGAJ+dNOajGq3Y1vj513hw86s88jk+Zdnn15g509fk0HWB12imZYhwKq0XSGtcHtLZC08I04O2wKtzwGwurCvSpQmCfW0UK7AvckAy3Fo/2ipBc2kCrtX6xc8zPPoUEv3nRF8RCQpljpihxSPuZ78/pCBb7ynfvnV6Ow4RfDIPCFYHE1+ri5uczquLjgp184cr2Ahwg0YODXmKDEySmJWI/IzpjbGxQ0rJKLmt+5HzDUI6gZnpqluQlEd66gfW1uk7kvWVmZy2iuFumZzyXoBQQTSMfV5h9WUJzf3Qkw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM3PR12MB9414.namprd12.prod.outlook.com (2603:10b6:0:47::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 20:54:05 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 20:54:05 +0000
Date: Wed, 7 Jan 2026 16:54:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org,
	balbirs@nvidia.com, matthew.brost@intel.com,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
	lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
	airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
	mpenttil@redhat.com, willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org,
	Felix.Kuehling@amd.com
Subject: Re: [PATCH v2 00/11] Remove device private pages from physical
 address space
Message-ID: <20260107205404.GI293394@nvidia.com>
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107120608.5ccd2cc7e4227d2e80028bd9@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107120608.5ccd2cc7e4227d2e80028bd9@linux-foundation.org>
X-ClientProxiedBy: BLAPR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:208:32a::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM3PR12MB9414:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e9ffa15-abb3-4d2c-6de6-08de4e2ee509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6o9KcxXnCK3SikQTHuHdPKNboUWlMyd+jjbPumtmLKQDMsnfzQu+1Hw4nE4k?=
 =?us-ascii?Q?XN0/+LW5RkIkfbUy+Tesz9hmBqdO5fFO4lmWgT9pdlLpvy1+qvKIROMWf2n7?=
 =?us-ascii?Q?tLTa/1N3AzgYjftqkFwwcg0IlBD52W6a0apg1hxxU3ZCe6MQtg+CnHa9U05+?=
 =?us-ascii?Q?Hh7bAl1ezQkczcoBzjgYXLSaI3FnmsI8e0Cr/1bEjfZQK9QAKDX1sgD3hXJ9?=
 =?us-ascii?Q?DCjtLaymD5yZhtk6xz8u2YjxRbxfPcsXn/1vFDte+XYjSo5hVJMSsWOlh+wQ?=
 =?us-ascii?Q?RiBQc2AiEmZWgtCd8ZuiKb/aYgeM3Z9Pzz52Q0zfldWk1zYH7i0Qh9SJKNgF?=
 =?us-ascii?Q?BXhR7sBqH+Yj4hRn2tql7XsrIo2IJK9VnQSECBSjJ8R5DS+dqUW5E2kZXVfy?=
 =?us-ascii?Q?TtTA3TJ5u5ohIM/7BcDQLFnXgBq61wHvMuIsIhHpi+qnZxsmP1LFR/qRBas3?=
 =?us-ascii?Q?FCVj+kNZEJYgVhWWk8dqCKGyJmMza9p/+Pft13FPiRNLCJ+wn9IP5eg/MNEA?=
 =?us-ascii?Q?IdS0JQchjf0XtJywn49Grn7gbqFAUdYNsW7bd3rk9CeoGQiFjwiPJfeWlOMm?=
 =?us-ascii?Q?cLa+AXzR9ghR2XP2M+ME7jj/Eyci223GTY9ayen6hRqkSLm5Yn9H3/DJJhyP?=
 =?us-ascii?Q?AYfgHllI3g0sRTJtltQEXiZQZ6Ehvp3l8CiZ3qcob/FxGAX/xvL222/0KbZW?=
 =?us-ascii?Q?TyhZS8k66TSCeA10HHvoFOB1uTLxsqfo26+arplL9eRKxwgVIvD7VuBbkYpm?=
 =?us-ascii?Q?YWYNPV3yPDM0Bg/x7Do6QXQaFzzPXSVHaILRmW0NSSW4X7AKdtW/H9WE8bPY?=
 =?us-ascii?Q?7+ip98jaTO3Hs5PxPYwrtkoGHl7F+tHoDJLIs7MJ1iUnIe+uTobfvrjrJHBh?=
 =?us-ascii?Q?MckIDTvHzGflkQMhgSf+WxQgUkDqlO82dSAI/hMnDeit7i+55loNGdQrARhH?=
 =?us-ascii?Q?A7L6ahRTGQnw4QOLQmzADcBU1QHha6FNX86YMhKa7aWaECYeEyOxAwE8T1sl?=
 =?us-ascii?Q?EG6V6PoGNj7jv2NcAmGvzrw7zWfIM1FcbrINfcyhkpTNhFq2GkpBadFWI3eE?=
 =?us-ascii?Q?Z/4GPG5fRw0lekHSJaLTDgMDNyXsJaWPUKacwN+wEWy5EkWgj8CqCkyCexJK?=
 =?us-ascii?Q?hQjiWCM16BU/UI7DlfAHqQHpSbhnAM/abszEeHoCrhrHY8tSQUJ+jWR+66FC?=
 =?us-ascii?Q?RnT835RZE4GEye3vckKUy/YpELMgAkQ6gj+It67cFSkhV+BxJKgc0hOC6WxD?=
 =?us-ascii?Q?be+f9lpq2rpmIQWvvvGYgDqi9UOOf3pM8V6HTn/CzVq5CPGxOVsotfInDzhU?=
 =?us-ascii?Q?sLYNoXZXQUpa8QJ6moXoWWNYvxDQ1UbnjQdEVYJgpbCcGCJyfI6qfHibfkXj?=
 =?us-ascii?Q?AuITjOqhxauuvlTd4jhNq0jbkAUnWB2lqUmvDzz3pfAdQ3TycFaGhgr7bAw9?=
 =?us-ascii?Q?maFz5noza9M9KvsfUzPsztR1LpM7y8Cj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eOPPs13Yk4l5ydwfFLssFlVkchbx1ESFVjpFTv4dLsI7XUafVLDBzKqmu25F?=
 =?us-ascii?Q?atl2rIpUZ9f/9vNX1pF8s0igrmiKQM89U8Imgck3CVE7rkhdEuEzmjR0Eqa4?=
 =?us-ascii?Q?awIXR3xW7fvDnptPk/Iof82OAzgPWSe5MFoxNWNRywFbAGIBFRc8kY9PaZ6D?=
 =?us-ascii?Q?lV88NOqrWOFUudRuow29UAxxg5owU2rebAi9aM01yznvFd7aWgIlJEJlUOvl?=
 =?us-ascii?Q?5sCSX4rMXH9uY/c8DK3NgOUm/bkczqT+RcxrJzRuu5lOQb/y93UrCV7+zIfJ?=
 =?us-ascii?Q?/U0fANE1lnRa5qFmfZzJanCLIc8HvSWN15cAd/bl/u4aV/iVhu3y2vd6GSwi?=
 =?us-ascii?Q?fgr92D7ZRuqS3JzutUHfV7tAxL5gPbV5lmvS4W4PONyHosRKU+kf6FgbvKXa?=
 =?us-ascii?Q?IyP/hUxYOJpvO7zmbK0kxuQniqEuyYC3FzcioJrZA+I2s9/63a2hXld6BJev?=
 =?us-ascii?Q?yi16ELdCS/6tsMLARjs9sObqcKiNQPcWsmGWrbe81uXpOpMviOKGpcxQvfRk?=
 =?us-ascii?Q?evIxrVFpqL1vAjXhac1zCn1JE39sLmW4FQg33Ck03/kAKUJ8G6bMNeYreXpR?=
 =?us-ascii?Q?TJFz2RWxU87zVAO5F3lqeX3Ynq87AYdlalmkHxF2ec6g58MftMzh+0lJ6lDB?=
 =?us-ascii?Q?FWZbbU/zHqPXteDq2CMLqbm42DXWN9pTFD/KzOXwSguDTyfx/W5s+XIltq79?=
 =?us-ascii?Q?09Brdf89ViQRj8Q9/DcF6qIptDmglVocEw3Y5OdJwe2SIMhW+/9+C4udIl0c?=
 =?us-ascii?Q?KMxzZtD6QtATIJXboVyQI3mgGeQW5Vzx62sOaYayfztrRtyw04GmHaKYKAIm?=
 =?us-ascii?Q?yNkzTHXnLGFYJgP8k0W/sVwx56bCkA+lsLGGVuKhx+zLTE5ZSkrCja6ZkUEj?=
 =?us-ascii?Q?pwRMGKgrj3qiSRSy4pIWWmBBQ3lpj6OnL5c5e4rgQh8vB5eRslMzTF8eGqoY?=
 =?us-ascii?Q?aw90ZCn/FEmtpCJH4qTfbRUzf7Iz8Zyd64/KoWLGs08M/w7Fqiwbse3nn5mq?=
 =?us-ascii?Q?zfZgTPNWN/dzghHrOku/mpXe80db05x61mIQslcolnulMldeycV2Mi7iUsB3?=
 =?us-ascii?Q?1QxRC4avbb1rHHf/xYHX0Tge5XTnkJPBFkiKz0BuIG3qGgieb+IPrAbCo0iv?=
 =?us-ascii?Q?1wvvlfLUIPC2FdNwUZr1AHYGHVUtroqask/7fWjNmNlvbvmr2wLjymufTqga?=
 =?us-ascii?Q?wusEJjgdAhnVdXMem8UOrFTgWjHBDnTLnF5yzUhNPnpxcT/svF6QaNALejjJ?=
 =?us-ascii?Q?VICqkW9jdWFwcNlYVKzZjDoLiS0gZhmGpOHKHcXE4OupmLnwqF+OrKrEkdLl?=
 =?us-ascii?Q?awpuePS55pxRXc81yFVgGsMNOxlkiE64qcWrPvFse/pVQ9ZQQN3+fcqT4SX9?=
 =?us-ascii?Q?/YB+HCVFOK/D1Tio42UsEOUmzL4oIo+EpkZv7QWYNihgDWcb/BBs5H5iOn2P?=
 =?us-ascii?Q?tHwXXChAYH++rFlwFMm8X4wmat67QdIBSIbcCYHNWjbaZAIg/NI51dqA7ztb?=
 =?us-ascii?Q?uEqRGBPzf+1RLzLZVwUE9sV40CIXIz8x874XtAgX208XJ0JfoJKSFh8/WA+0?=
 =?us-ascii?Q?NS6y1vreQ8BmD4QbLyFhYeJb30DY7LPCXdtBXL6X7bCA18yBwC3ZsTsln7UL?=
 =?us-ascii?Q?9WI51vjxp9timizOoCjRNA8dhLNhxU5JCnSzPmKpd/8WcuJ6fsk6WKAqYzi/?=
 =?us-ascii?Q?vn4g89zXikutap4c1810thxTlxt5IuiMGpyc4bLE3iAf78Ks21da4+LBY2H9?=
 =?us-ascii?Q?VqklkMbFqg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9ffa15-abb3-4d2c-6de6-08de4e2ee509
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 20:54:05.3701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4o0C8uj7Jy4xeNwzhu98tRrbtEq8eHjo4FmvJ+RJg0wuT9MKcnuGG8TQddIoloD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9414
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 228014000E
X-Stat-Signature: 3sg8gr9enuhr7h13zeodq64h3otphwx8
X-Rspam-User: 
X-HE-Tag: 1767819251-552619
X-HE-Meta: U2FsdGVkX1+AMtzejSQ06jKcnQvWweb6Tw14cf96XcbQU2hUEG0KnsDBNuEJcRePPjxZ1eBQzZW/o5egAyp+G42Y/9A47B0q4KUvXWan4YnaR4W4zQ/HXn6sGzvlT/dtO4rCnHtndgSUmWDNAVKC8fym4nEGPfvKOB/biPFG+HUuU7kqr1dwSA3oZkyIR6V4D88iCGZ6OgYd7WaAnzl7HQCNQyWxvVjEnAaZoiUjI5cBk39WS59bpx0Op+eodgMPPUiqnKfF2sQ7XsgUx5QTE/PHOQ7DS894ow4tH9NefKoCMu3FoXdtT/SI8+yTqUSBiwbpAtymHMYCY4brYNKlWZW9N4FwwFPK6A5vQywDR302cyDrZj4OjBqF8tdggeKbhjcUeOrSXubrD59kLyTTKATneMpFLVMYXM4Cv+LI5XYaiwEo9kZNFFgBpNLPM+i83JId7guWOuzxQw75IaELEfL+Mqtvm5JRI3mi2rsgLY/puXwPACxdLJRtDk0YPjNL6E2xEpJpx29yXdZwPs2u45aU8GdRVy3YEbvHEmAOXKbEMJdZGyakSKRq7O99rSOE98sR9/W8Vn1pm0/0Z8tG33gS1idoQwvxwY/vXrfN3IZSo2iSCbGHbo+4D9gQhnidqibcQkIKOR4JyTlHf4ESgIAIETP3an9HJc8/FCycnt8T77NVQyRqpFkrJyJ5JrPvlOS6CVMLS4NtXIM/wOhDhNQ/maAPa+qWH4t4tQzuAD+QBWiiiyzcwnIpMNPAVCbbLBe57DHDEMSdBGN/GsvboIwXYiHVxSR+zOArLzyprTUXglEXaeAToDRbOCPk07lPj6H66sr69NMGeNdkuq03PgHI4CehoS6WNx/spoyR49tyFmNIRi3JKQOlpUmSbVLQ4YpFqIMIVlbxKOE6AqwQ1I4gVnSw5fU7A08aIJoAmpi7ONp/RGnH908/20KODTOq2so8h6qxgzfMY/kZI3c
 BCkclAEU
 UQbo4JkJ7rdrpudpgexKF31fjvKjOmgZEe5+oDXTJkdJE3yyGISNi62w/gV3xkcTz4TJYdsCu8ySMS7sCYEuD7ZpX0AZSYMkFq5Pq2gyaiCD1cjAXLa+/+YMG9rimAsecl5STGcCpqX0r+LdCp5UcBbB3YF6hqmqU02/k9zs6D7tTQMvEib1NoITPeIwOXSg5px/pEhtChx4NP7K7J8hUWG5FgnJC2DqVL+7fNa3a3s7Hkv88u9UEBWxsHgSCzjVhBJ5IDBg+xNV2/mmLuWNBd2nGhiLykYJF2+nPXCkXML71m6b4i5y4Wj+/76++O6IB91jOAKj7RYtU9bypIegwZcRUvXlHafihn/VbQWHvcSxfjMhxwGQhgLP8YKIKDAl4mc0mIPbe6LiLGe1vVwEbddBttw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 12:06:08PM -0800, Andrew Morton wrote:

> >   2) Attempting to add the device private pages to the linear map at
> >      addresses beyond the actual physical memory causes issues on
> >      architectures like aarch64  - meaning the feature does not work there [0].
> 
> Can you better help us understand the seriousness of these problems? 
> How much are our users really hurting from this?

We think it is pretty serious, in the future HW support sense, as it
means real systems being built do not work :)

Also Willy and others were cheering this work on at LPC. I think the
possible followup to move DEVICE_PRIVATE from struct page and reduce
the memory allocation would be well celebrated.

The Intel Xe and AMD GPU teams are the two drivers most important to
be testing this as they consume the feature.

Jason

