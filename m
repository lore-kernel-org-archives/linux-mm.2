Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41616CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A719B6B008A; Mon,  8 Jun 2026 12:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22006B008C; Mon,  8 Jun 2026 12:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA066B0092; Mon,  8 Jun 2026 12:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 792966B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:30:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1F58401D9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:30:09 +0000 (UTC)
X-FDA: 84857282538.12.02C2119
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id C27CE40015
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:30:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=naPJxCHA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780936207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neH++zn0YCzgXJslGpLBw45mRE+DzvoCIusY0pznlx8=;
	b=uqdC09PiXlhZEJEoYOUSHZecPcXWKAwBrf+V96LJztoQjv+nFb7YRM12+4sG2JAejZW8Wc
	bbJ2Nd7cnNG/4kVqIgi2GHzTNldS8o5MpiofOYoRLjAo2i+N8arg20fAb4OZTWhXxpQsvG
	9EFqsoIEDA1n1F8/MxDyya+GSrKdcZQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=naPJxCHA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780936207;
	b=iWijpevwJrxltze5bzr1MtjpehpK4NwT1LRyUlt/vbjBUfZ3S0c5vdPgawYxEIGxepYVqk
	mOBkLeN+aVL8GL6KZNwI8cwf9osH+5j8n7raaboAUpj5x4R988VxS5FhpHr8q2BEQLVzdH
	aljC4O0+WXCoVTYIz+TnjME0NfVJ9b8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tbOcJd0sFtV0w4/j4i7XCRYXUA0gRaTh8DYRkvx2Yb44DCNUBFmdLwuWL/BrzErvk2gURgzlenaHQr2fRUproL4NMO9iC1W9kVdnv5xynQh+76YkHkRZvoXWQOdU6MwRoBikngluabFzHHv1rV4zdW/oVLJCp++odB4P36ZEA82rDuUNjXob44EdNhzftLD/falatTyAv2llxskG+4HE0kAF5Tqs1hsbcpKY6dsGsIlS8FBg2gSs/w3V/Pl6YQSz1uiCV+vtOdwSTYEPbMhYNdFueL11Ny2p/5Zr87ZDMQvqXcags8r/b9d5cXEuZXZBJi8R2uYfUMNfWHKw96Rrpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neH++zn0YCzgXJslGpLBw45mRE+DzvoCIusY0pznlx8=;
 b=Ppdt7EA/1ihvVE9C8syT2hlr8y4fokBV/mTGCBeOQiena6GHwGU5fV/t0yFUSq0djWFEDW3JS08xBx9Xz2tybWzDcD2/iUBAuhaBNXYXrjTYTAMDG1umkVDAYapLf8Lx79OKmLzbNb5+xxQWBMJddE7QHW0f0ZjOVDxOJGox0R2v+AedQuIcz5YSLVr1rt1lOsC0zVxs2TkROkWvoE8gd5qC6GLmhKNNHAipBqre2IvVooVC+kJC5i2HmOVt2BtVxOrzgEJ3nQptVerKHRK0wcc3RJxs6htcjlrGe/BcLen+Yc0Fr151yErSS2rKDd9j+uKfoW9fmAmTXM3skzPJWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neH++zn0YCzgXJslGpLBw45mRE+DzvoCIusY0pznlx8=;
 b=naPJxCHA8jzs02NMbxP91bLpavQXZLjB8FUSxmDldFdJgNwWkrA8bbG/HnfphC2DGrKmSie9zxbqgt+FXfDx9Ln1nmOBEA4jE/JMj3Xn42k+0miOx3ZL7qYjxoU23cVB6zywEXfDwFkKlmCrcoTApDN+Me3A2ZgMmQENIZX55QnaRlxWGU8fFNKEnrPLa/aeQEE2NZ6sVXckNP4i7ubtXuT2T30wsxLKu9pIrWcHeCBmI51idayrIeiZmVHt9Z9+2ZjZ+y0Ztxt/0LpWMBovqn70185SMy/bwFLY5aKsgFagrLke8lDKb1r2A59KM0u2BYrvLevdxfhXhjawd1mwWg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB9255.namprd12.prod.outlook.com (2603:10b6:510:30c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 16:29:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 16:29:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Alexandra Diupina <adiupina@astralinux.ru>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org, Jinjiang Tu <tujinjiang@huawei.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Luis Chamberalin <mcgrof@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Michal Hocko <mhocko@kernel.org>, Pankaj Raghav <kernel@pankajraghav.com>
Subject: Re: [PATCH v2 6.1] mm/memory_hotplug: fix hwpoisoned large folio
 handling in do_migrate_range()
Date: Mon, 08 Jun 2026 12:29:52 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <A307CF74-4099-4FCA-96C5-0902F9E52F3E@nvidia.com>
In-Reply-To: <20260605190756.20413-1-adiupina@astralinux.ru>
References: <20260605190756.20413-1-adiupina@astralinux.ru>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB9255:EE_
X-MS-Office365-Filtering-Correlation-Id: 43495849-5f84-4343-d524-08dec57b2ddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	z3EYUSgen1taNUcXJs2ZoNMYZSXoLRKliCDQhKGlwx8Etkm2f+fu4Lg6/Y/fIvyUdbeojOGWQ9VJRhsEQ5roeoF6vzW2uAOyzbx4ePdmyBT3zuKnOuZqRlW5CujXMj6o/lFbVnxQq9MKtkT4x/HtXWWk2nDNvB1jV71jztjR256K6IPyyo77pciTaXG8tJ1Z6e6Myo/vrYFKJ4i5BOtpXtrIwqfHE7DXqTMMxrC2Gx6eOxZAD51IZWRNq/VEdyuLv7ivPzVgMcacLphLc+Nxi98+kc2xjQLH7DaP2RFzpYkeupJt+5MgGBNfTFlFf+2s0pZm9CHW0uxgYnh0inQSDLzfmcW66uz2F0rtzgXPMRGAqkiqBKBkb0LJ9kpPOp3kLsC39tYWpApAOrKKjsT1WReEQm8e+pz2u/HvDwbZjREHIxVDEDzfKLRlPb3K+ZoOrAqyWHukKOFGsLRe0bP4tmYvXajgp9LLnIVatA1Vogr/x18lvlguqQ/VEc3l/iMD0x3fXthjLOS/YcXsTJTXSpPBtSZSgmXp/l6SbZlCGZHYj8BGiX93L3VIzcbOgRrnRstGQcj5/u9ma08vdO06QSvhtP609sONhruJjLW57yikPLKvzDckJzkmG4lsxPXTl24NdCYvGAsIWXUZcVtBkzl7rVXXxX7T/oA1O9CcvcDlqLSFUGjXDrnbF+eHXPfH+Zdz8AVfqXB7NlYQY0rlYQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0GkJOt9Cdwl/arocWcb/W6XlbfD9Fvlqpt9z/ACoF7mznyTvD3q8s51F122u?=
 =?us-ascii?Q?K3fQgyIda6G2KoayXVynTt1hoh6EQaqd0QKtu2PxCzDPdtUdptt4Bl7CBnIB?=
 =?us-ascii?Q?5qTMvh/tFEMp8UIqct4oUfshGL7CRcyRT+EuSK9mvlXr2QzLEeTacRDBVmEM?=
 =?us-ascii?Q?i28V0dsl+9KjMpbVj/Vcvlr6sFwSjNMcY7G5gH4V6gZhpuohIc1SZEZuoDiE?=
 =?us-ascii?Q?QN6eMstSjFfLXMl3dImERpZLrgR5zgAUwzkkK/BAqs3kJAA96SWbZwQOSLQx?=
 =?us-ascii?Q?BPwiPzTHFou670CLqdYa8vSFFHe7DrhuR6FuLQ1PlQmYkPeR0AKINIDAFW8c?=
 =?us-ascii?Q?4bXUT5m/QSpcZ80VZuhwAJoGLlU4R2Zp3q4ANqyGlAIZhY+RVn4fCFTmvcDv?=
 =?us-ascii?Q?ZH5Rc39BvS62L6hb/diI8pFTI0WOyo+Tu5W8ifQi8oabg4nMCdt3atNvR/s7?=
 =?us-ascii?Q?2SvTmMQru+n2/TQ6X5whRUSirjy0/+ASrCGwu1GusHezXvxglEoafw86Zjz/?=
 =?us-ascii?Q?DVZLuw6V7iLgXxfwsnwGZaGXztD3x24BySi/IHRBw+VwKFPmn4cg3IuZq073?=
 =?us-ascii?Q?hZkCDDcn71LzXTMNzdfvgEfI4BDotvvi58ioQWG78W7QTo2w8Z7mPvFdBL4b?=
 =?us-ascii?Q?ga3cDJEfPJ4FbrOFqGDGYP5xwnc9KPnRq26Oa9Zz7qPghSA+/j0zqiClafnV?=
 =?us-ascii?Q?Y136Jydzdmarwv/xEUBS3+pT4SbLNZoIF6R4vnPKdOcJP2vhHI7PN/m1jx2k?=
 =?us-ascii?Q?JuXDEXBncB0nuN9xf8dfhaKnlvM+KjOZHN8H/3BHIBdKSMVVIgCDcFYSPhte?=
 =?us-ascii?Q?V98pqrt1WNyqq/rGvZEY7dD+Zd0bE8Kcu2F8i3HMcqJWaATtby8v2kOVWDF8?=
 =?us-ascii?Q?OxeptLHk7SLJehF++D4zU+42+0Xw4u1FIcPTkrKktKKNaMRJUyhc2VMX0N+5?=
 =?us-ascii?Q?XhOEWDG+UHcD+I6qOy5wSQSZ3w/Rz2XzGUOoSWPxyprwy0DzL+xOyCGoYB2D?=
 =?us-ascii?Q?5RfFabQ34v1WtaTURaoCCXy1WgdrGe5OGjFIw46zKPF6KXfjq/fodSZhi967?=
 =?us-ascii?Q?WSsJuVFZjMB+W6uBkOSa20kC9l2QY7Eh938oo64PioSyH3FFD3khYfa/qG98?=
 =?us-ascii?Q?n1ivCVW2g0WfkrhhiNGkaikQOJ55TcJBduQWESDwqP6UnE5qk3IAiPAhh2eI?=
 =?us-ascii?Q?bDtUj/twNZaYW8nkexMuyLdSjYPrBWIxZqOS4XAXArZxQ1nkbmsZJQHvhOiw?=
 =?us-ascii?Q?r38UztzqyduIAs/UkdKIWnZcYTWNoun/GU9vsQC7fMRZ3AwnpQ91EtRr7oyJ?=
 =?us-ascii?Q?vaFfY3v1MnnH5v4pulWf8eDtXQlzOQKLZ8NlQ2uFOgycD6CquBCeeeV24dJv?=
 =?us-ascii?Q?5buoCrlFNEcwzjEGQxkwf2/bvDkog8FgIOTu0n5Wsd4742mrL6WK7Aw347zc?=
 =?us-ascii?Q?zD38hlch8WK5Oi03HU8wHiS7cdYDBOLHz+NXcnmp1KgmIbJN9diiqbH/sik/?=
 =?us-ascii?Q?13qx4FGaJsntggcSpo1VbYLA/1XbjADcCvEQ64n5UKdQJRX3N3ej8qGAmIzC?=
 =?us-ascii?Q?mYd7pWijokjtJuVMevtt522oTGWz0JvuOOtxCv4vguBvtncKetFYlP8EEjQm?=
 =?us-ascii?Q?VKumQeJKXpYpiBggvIl0D55P4WFRw91LmQyV5C/gj5VLDTCmCGGKRxso9LlQ?=
 =?us-ascii?Q?qg0ZVqGeHbmp9KBzKsTMmW1DGei/nkSSBz6A7aWhzuWyv5+x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43495849-5f84-4343-d524-08dec57b2ddf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 16:29:57.5703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAVIygKRrxOC1EPlrK2xQZCEsh4+bLYhWGMLEuZx+eOj36cAwYDFXTmmuxo6abu2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9255
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C27CE40015
X-Stat-Signature: 3qfczfemzpwi195ii3mgm5ryks896m8j
X-Rspam-User: 
X-HE-Tag: 1780936206-83850
X-HE-Meta: U2FsdGVkX1+yJQhjcLvOdgp/oUioIkX2HJUZB9l47mReZjgzVgXAGgrVoQqKrxoM6TaM67u+gSqX/6sD/d33n+9U5r9DR8p2+uhyy/u+F362TuGhyoY9TTQV/+FxZIgIJqi7wTi1fCtqYnt0vILC0tcpb/mBHqSWsr1LJO+OuapxLlM63ULfWp58OE79ebsWvxUCvnO2PBdoaP/MLt9/Xm+KGqswfF+pIBNHezdZ/w+BX14g7ni38zVxveCjIj53aVPxlUGbazM5IRxcBaMDlfowwWrekpp/a4xWmvqZOwCWBlKspjEvcRXJIWOUqO91IS1QSj5GFxkW45EyMIlo8qyLLuPIBtTzutwm+35EDc+NQIkr95cXfGb1jSz8j6EY3fRrTvkb+ABkPXfw8d2Y/+f2dGO5SqFWEybzupkTorEy2RxT39dIL0wrkcri+Rh+4OwcLTgkhGShZJHIbNPQrXFqgZ4GcbSuYDEy/GP5M3+pXRobHL2AzcKHczgD7HV5JNOpUWaMoFALgTGgELVzYksFIoHIR26hQafYoco2jgxDLloT1N7EEegL93UO3XDi4bE5WSKgLpzRfwsMuB8HJK1dkm1wI4aKvjA5ye/u/ooKVFAp7r+60quzcD7wjGvW5nW/AC7AL54/3kyyVgZ3l7+0isWyJY2zfLe60g9cEHHRkJHI/56uJbwG8+7ajR5XSe6QvEKETmEMrmFA0PFgrvX14xO6MFmc4AEwBn0kkG569nWpKk/HKYiMQymof6Ee8tMpsUH9jrTUNSLxH1dJxeKFs3CgWVsl/KnomEAmocBIcmHHRcKHOmcMB35jap+2PeUbL8NEtv+g5YYLhMPSIRsZ3VYh9uUMigbqrJXvKjRRORUOQNbNyRQ8B2c5z2h2VS5K1GYLULO2AwD0mqAiCkuwAA9etqsiKUgADKmLYAHfqX3M5XbaRTySnd/35Gu620YaMui+0EetNgQSHhF
 cv1Xp4cp
 ErS3yL+HxHz4tDzyxZvRq1/Sm+Y7iSfc/Kz8W7z/CSvDYVtrXscJmehzEUmVzWzt+sQiP8+AD/iqlVoomXSqjIKBN0Lri6yeyNGyYZuBJ3kztWignEvkN5NUhksh2tVGMVufsBnpC67STPyr3iMR7TZCiN0M3f3EEN6N8N44YSFzfyE1R3JBO4mgv1A8PmJFplNfv4U7dqJN+hdLCxlAju3AVHXhT12VslvLF3HPNjAIq+UPO2ZJykJsC75EdtY0pKusGwdgzS+sQZvofcY5xEx48HHqBm2/k2TnjWpMmVNrEQ0etpCldFu3CoEdk+zUsd0T7k5uqN9104FmTV9MpTM88lqg83b3Y3NDigfVTcipRb64CM9wsFW2QLgo/R+lPQfKAM4ERwdvATJNMQM63fn2xmZSRHADb89+TsD01Zjd5UZFrzzBMIXu7RmpeIkCJJyGwmeKxKtpFzTsME9sDY63N0CJAhSSns6DcEiEqNCU29ywlBdYMuu6k/8KfK6rSF/3IbkJiQJQJFr/Y75UdDjcG8x6lN2av+Le4F2VAo48t4wGjjlq5SzZIvDrg83aBpeJJiMrvgzd/K1L1LTe1LOHurxFUaI3fR7vMl04MI5Yndo/MPXbhq9v3afKBx7crgzF0Vp2lqAAFkJ1V2milH7omMTRMQm/12sH9kjg//1nylShL1UV3Aucuh8XDP68Cpnxz/qoCwj5jBKbCvRD0v2M0uQsme54lodfO7y+7q1+lRI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Jun 2026, at 15:07, Alexandra Diupina wrote:

> From: Jinjiang Tu <tujinjiang@huawei.com>
>
> commit 397f6d14f9c370e4910e6885294c340f39dedbf5 upstream.
>
> In do_migrate_range(), the hwpoisoned folio may be large folio, which
> can't be handled by unmap_poisoned_folio().
>
> I can reproduce this issue in qemu after adding delay in memory_failure()
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> RIP: 0010:try_to_unmap_one+0x16a/0xfc0
>   <TASK>
>   rmap_walk_anon+0xda/0x1f0
>   try_to_unmap+0x78/0x80
>   ? __pfx_try_to_unmap_one+0x10/0x10
>   ? __pfx_folio_not_mapped+0x10/0x10
>   ? __pfx_folio_lock_anon_vma_read+0x10/0x10
>   unmap_poisoned_folio+0x60/0x140
>   do_migrate_range+0x4d1/0x600
>   ? slab_memory_callback+0x6a/0x190
>   ? notifier_call_chain+0x56/0xb0
>   offline_pages+0x3e6/0x460
>   memory_subsys_offline+0x130/0x1f0
>   device_offline+0xba/0x110
>   acpi_bus_offline+0xb7/0x130
>   acpi_scan_hot_remove+0x77/0x290
>   acpi_device_hotplug+0x1e0/0x240
>   acpi_hotplug_work_fn+0x1a/0x30
>   process_one_work+0x186/0x340
>
> Besides, do_migrate_range() may be called between memory_failure set
> hwpoison flag and isolate the folio from lru, so remove WARN_ON(). In other
> places, unmap_poisoned_folio() is called when the folio is isolated, obey
> it in do_migrate_range() too.
>
> [david@redhat.com: don't abort offlining, fixed typo, add comment]
> Link: https://lkml.kernel.org/r/3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com
> Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Luis Chamberalin <mcgrof@kernel.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pankaj Raghav <kernel@pankajraghav.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [ Alexandra: replace "goto put_folio" with "continue" ]
> Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
> ---
> v2: replace "goto put_folio" in the original patch with "continue"
>  mm/memory_hotplug.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index c8cc2f63c3ea..536478e688a0 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1654,8 +1654,14 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>  		 * the unmap as the catch all safety net).
>  		 */
>  		if (PageHWPoison(page)) {
> -			if (WARN_ON(folio_test_lru(folio)))
> -				folio_isolate_lru(folio);
> +			/*
> +			 * unmap_poisoned_folio() cannot handle large folios
> +			 * in all cases yet.
> +			 */
> +			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> +				continue;
> +			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
> +				continue;
>  			if (folio_mapped(folio)) {
>  				folio_lock(folio);
>  				try_to_unmap(folio, TTU_IGNORE_MLOCK);
> -- 
> 2.30.2

The changes look good to me. My above ack tag applies here too.

Best Regards,
Yan, Zi

