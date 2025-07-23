Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC170C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 15:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9446B00E7; Wed, 23 Jul 2025 11:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1156B00E8; Wed, 23 Jul 2025 11:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F676B00E9; Wed, 23 Jul 2025 11:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18B486B00E7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:12:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B79C9C012B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:12:30 +0000 (UTC)
X-FDA: 83695870860.05.2AEB83D
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013019.outbound.protection.outlook.com [52.101.83.19])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADF2E1C0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:12:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M28nKjuK;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M28nKjuK;
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.83.19 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753283547; a=rsa-sha256;
	cv=pass;
	b=do1d9S64WjNzeVRoqvEb6dguVnmIcfpY1imahq85ClsVx/oC5qh/DNkqZWR5D4ywSpx8AW
	Kgz42j4I39Zmj9yUO1VTNOYUvYa68HRBJOsi/24tHP64OK8v4mzbV2cLlZkHlr1PQRtlSb
	+RN7Vf+RdembQ2zK72DjwUZtgJhdVRY=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M28nKjuK;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M28nKjuK;
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.83.19 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753283547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYJ7XRS67wIC2OEShP5HSljWdroKSvXXMfS5X17zWSU=;
	b=d4OC6WHTBJSCgSOYWtISMl6InupqDMmgbSGZ8USvevp4Nm8tFE87fw/E9iuRWZEBK6C1ed
	TbEvH+RIggo51zLUUmo7nGvKO2XBU9W8TuQPK6bNodrjW7HoS5N+g+2RPYvFSCkuQ6ij98
	DyRvDkm0m4khp3w6VJC1QJP3w5KtVH0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xQaf6EgVxQEuOXjPMPd7AI5hPZdYpNZDFsxfyPLCPf3xXsSzb2Omm7N0KAeA8/+J3K64OcWicVKINuCnvywJKSb3QaZXjyMbvrimyfLCWlRDDKtI7w5n625UyLgx/4dKI6Hpw1VWj+CRx0hU4cz3fvxKVSlr+Mo2tDG8zrH1dY4ze17iGXiZzOOhHjcA1lD057RrMJFxMeBEgBG6R/P7Ht1tQKP+jgRToDIP6PMUMMfHjbulnChz35acUOW130brAfuIBjVZCeTdABTkkYRcmZMv03cmCPKg7s0iO3y1YjA8fSPF5JUfiBKTH7peZO3Q9VVkHm/YNw3+UHIvp0Eybw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYJ7XRS67wIC2OEShP5HSljWdroKSvXXMfS5X17zWSU=;
 b=ECPIaVXUkUhFvGm0p/6GAEWaid4rYNmbmmImU7v0W8LtYYhNt3G32VxfT81jsGhGIVyGF723jsKsATMD1+WnGDXYIFC30ABCpU9gJXrQTx/BIcbgXLE+2jVVRwWXThc7farJz9dVG1dcS4rb3Vbsu73NJFMLr5OIBPcxuuEA+rQhScKD1Jqq1XFjLB7Nro7LQcPlVupphjNqdGMAuUSkwPS1fNbLjiSoUOdnlhpxGjY1nrFGwqaEYlCprIpV1YemPQn9s1mto21rrs5dLGMMNXFeK/lVA4dlAMGRUmLutgn0TBEcC0DqKJ6TOhHAlxFv7ZNc/eAMf19UyfNeFqoVCg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYJ7XRS67wIC2OEShP5HSljWdroKSvXXMfS5X17zWSU=;
 b=M28nKjuKb8hgqRxhgNe6CXMggtUni4CsMsKBwWssrp0tohl0kl7TJWX5jnCe5bFoRTZTmCJ17+a2/4Yi+QF58gO//B7u+iriRCqOq0Ixcv+a6z2ybQMCmgjIgzxxOX2g1rZlW/+X2SyOo9+ajkjJnic5qT/3xwCYNVsq7pKTET4=
Received: from AS4P250CA0015.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::14)
 by DB9PR08MB6571.eurprd08.prod.outlook.com (2603:10a6:10:25b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 15:12:23 +0000
Received: from AMS1EPF0000004B.eurprd04.prod.outlook.com
 (2603:10a6:20b:5df:cafe::94) by AS4P250CA0015.outlook.office365.com
 (2603:10a6:20b:5df::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.22 via Frontend Transport; Wed,
 23 Jul 2025 15:12:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004B.mail.protection.outlook.com (10.167.16.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.20
 via Frontend Transport; Wed, 23 Jul 2025 15:12:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nm7kLIeKaO/mFpFxFE8GQW8Wkza6BD5ngetYzK8RXov5Hv/q4Fe5ne0ZNwutVVwS30dkpIpqsn9zypg6Gtie8zyiTZp3Jzr2w0DZCUx5nzRj3oPO0pRZEgXQioJCcr5fXmsPh9MwJnBsRnScvK8nrasn/sbPCzJa4Y2on4/XcAkukSrZD4fAjIeoBKBHs6RAYczHM9InQhr18FCYtVvQju+zUx0u2yjmN3JESi1C5yt7KHmQiCakd3wzn0kh+DUZlfo74SnPmYddN3Z6AAFeSM1F2cCCkYTtWG67DuTayHXNYNTKKFRpu1k4ZtV4RPE0JQJSyDMYUya6ZX35VRd3mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYJ7XRS67wIC2OEShP5HSljWdroKSvXXMfS5X17zWSU=;
 b=oHnzGcdqhuOWbzgnEbfftCrE3YZirUfKgFBQbhB+RQpuUUzEbnbiXnIhpjMR7NaGYQcfi9csG83cuLy7cZ3p4vONv3ZYh/B64iOl4FYlvpuDmHdzle+I2a2mMX31drAZbJB6OkEYr0T0m3zCD+crBRl+UnvHvaT8EZzd37YhrtAQz/6ofl9139TD006SaZLINvRPZTQnrtAUkW093C7BLQFp99EEZ72JOOwEqLhvN4oSzyF0AFlpPhKvA7AwEXVwUFDuBPyK00lzVTKUvfXj3T/ZpZYKl7COe1qj1qjMkOPipWmHx+OXG0+9566rST+LI1Gh2sEBWggLfyJdfwYUUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYJ7XRS67wIC2OEShP5HSljWdroKSvXXMfS5X17zWSU=;
 b=M28nKjuKb8hgqRxhgNe6CXMggtUni4CsMsKBwWssrp0tohl0kl7TJWX5jnCe5bFoRTZTmCJ17+a2/4Yi+QF58gO//B7u+iriRCqOq0Ixcv+a6z2ybQMCmgjIgzxxOX2g1rZlW/+X2SyOo9+ajkjJnic5qT/3xwCYNVsq7pKTET4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS2PR08MB8695.eurprd08.prod.outlook.com (2603:10a6:20b:55e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 15:11:49 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 15:11:49 +0000
Message-ID: <79433fb7-597f-40f2-ad66-9cb9b84ff2bd@arm.com>
Date: Wed, 23 Jul 2025 20:41:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing mm_slot.h file THP section
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:177::11) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS2PR08MB8695:EE_|AMS1EPF0000004B:EE_|DB9PR08MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: ad40d933-7cdd-484b-2a3b-08ddc9fb52ee
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TWZOb01pdHpiM3p5RHhETWk3ZkkrMUE2aSsrUXIzNXJPblZWQ1FuQ1E2T0pZ?=
 =?utf-8?B?aVFiOWhiQnJHeEhUc0hNcU5mSEpEcFU5SkxpSjQ4aHpudmZvVVp2TEhSNWRE?=
 =?utf-8?B?U2k3RW0vTGplaHdnLy9CUzFaeWFlYmJQRGE3T0Zqa3pPUk5OZCszSDN1M1Rz?=
 =?utf-8?B?WThVOXJScDVlZUM5YW1tUTltZ3E0bzJFUElMY3RDbUJkVzhSQXZDeUNiWjR3?=
 =?utf-8?B?WjI5RkVuSE5zVWFwZXQ1YVFhMUFKSndsMnh4ZkJZYmxDSjBFa05Qenl1d3JI?=
 =?utf-8?B?alNheU1kbzUvVXBjOVBNa1dtRSszY2x6UWg2UE9GdEFtU1Y3MnhKbm9aSGlT?=
 =?utf-8?B?b3l4eU96cEhSQ0lhM1BKRTdqRUQ0cXoybnlJVm1aYXhWRDQ0c0drWU1TUU5J?=
 =?utf-8?B?Y3hJaFIvVDlLMFMzNEJ3Z0Nva0pNdUN1aGZVYVhXNHRyNWU1ZVZnWldnYk5v?=
 =?utf-8?B?R0MvRm9ROUZ4aHIzNXBITklLUVpPRjE5TEllRTlZS1dIKzJ0WkIyWGl2ZFhl?=
 =?utf-8?B?YjZRRXZ0OGVsVU9VZTNKd1BkYitRWWd3ZVBOeXBXQUZBckk3MzNUaVpQei9n?=
 =?utf-8?B?cHl6OXltN3d0VTNhL2tUeE4wQ2Z3emZPMXlCck5FKzVZZWJtR0poNG1ZcWI2?=
 =?utf-8?B?UVBIcWwwMmdkdTAxNk5KTGRxQUJtZ2V6T0t3VmJPcURTdEJHY1FKWlhmUWVu?=
 =?utf-8?B?bTZuRkkvNXoyTjdmM21HL29KVlAwMXRoZ0JLTE5mWHdsN1NrVjB3WS9WYU01?=
 =?utf-8?B?Z0ZsOXpyR2pYQU5mR0sxNXo3cnRmaVdnRG8wY3FwVm1zM1cycW1UbWZTbDRH?=
 =?utf-8?B?bktXVXJhNktLSkp0akpVYmVRQ1JpUExBMCs5WWpBVk85WTNNSG00YmtkSDVn?=
 =?utf-8?B?VzJCWlIxVFJVSVA2MjNMaWZaTzQxYURLaitISUtVQnBySnFYYlRUZ3dPU21E?=
 =?utf-8?B?aHBMQnIyRzhJcmhvUlNIeERuQ0k4K2ZUYVFZdGk5aURmem1wQkpiVGhXcHNq?=
 =?utf-8?B?K0VmNnBudzZmL1RkQzQzQXRFcU5KSjBIa28wN3NPS2l1UGZ5aFVvZngyYUtu?=
 =?utf-8?B?bXZtNGRyZ25JZGZWTEpPNWtzMTVPdVJSUWtMemtwQ0tROEZ5eGQ5UHdjalB3?=
 =?utf-8?B?MzI1S1FVYitVZkZOQzZGUldvRkNDdXExMnEzSXZyTytjUldKb2IybFdVUjBl?=
 =?utf-8?B?cndZRFUvTWdRbFBWdFptWEp6eFl0bmlHcXM3Z3YvU0xuSjdiOGZ4MCttNnNU?=
 =?utf-8?B?LzNkSzVIVnJZdzNpaG9LQVBZQXhnWmVua3ZHc2c2aEVMODlWalpXS1U4bHVy?=
 =?utf-8?B?VVFSNjhpcEwrOFFBNEN1UnpoOWg2T3F2OWlWQXVyZzNWZkRLV2tJMENWNlpy?=
 =?utf-8?B?ZG0za1EvQ2kxcllPNlNyVHBJeXhENkVDWm1NVmIrUUpZN1FNcC9YVER0M2F6?=
 =?utf-8?B?bXJXaGtFa3ZyeW11YjcwS054MXZkY1I0bGsxY3h3ZkluUmR3MTRXRVVZN3Ju?=
 =?utf-8?B?bnIwUjZKaVVyUUErRGF6Y1JQK21YN21GckJWcXVxWHhOQTRpbUZDNS83djVB?=
 =?utf-8?B?NStFWEhFYlltd2lET2dSMEd3Zk9zZCtSOHFTLzdHSDhoNXZHTm5VN0Zkd2Jh?=
 =?utf-8?B?YXR4TjZkM29ObVJyU3dwQ0hxQVhNOTd1VlFSdzJ2ZDV4dVVJRStrZTYxbGFt?=
 =?utf-8?B?QkZEME1DQjJ5b0dOMkN3aDF1NndjN3Z0bkJwOURiL2Y5OXJWVHl3VDhoOThU?=
 =?utf-8?B?ai8wNXY5aVVFM1ppMDdOYTEvZjRMYWVyS0UraHNHdFVTdFlnRGNHRi9rL0ZB?=
 =?utf-8?B?d0puL1phQUhOdEozTDJhS1lJeERKME1mMlpnbTkzNEh1OWd0QmxKamk2Skxo?=
 =?utf-8?B?SHhwWndyNEx3UUxQcjN6T3gyQzZ1Tk5IWnJCWWI5amErWW5YT1BFbFR1MTNt?=
 =?utf-8?Q?in/ekg4mUeo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8695
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ecc8dde8-f770-4202-a57c-08ddc9fb3f0a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|7416014|376014|36860700013|82310400026|35042699022|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnBlTXhsalBUSjR5VDl2OFdyZVRDVURGcEd0RzV0azBvRnd6eVVyL1VQR1Er?=
 =?utf-8?B?V3I5SHYvbGRaVEJnT3ZQUmNLMkpqYjYyY3lBY2RhSk9jblVqdUE5QmFwcjdw?=
 =?utf-8?B?TElYNDVvWWpmdUpJMHVWKzhGQUZnUy9wSDJ1WThkNjN6V0pUV3BUVEVldmtR?=
 =?utf-8?B?clBGS0xpYXo0OTBONzE2S1UwWS9LRmlnVmdxQzdtWE43dGQwaUdWcHhBU2li?=
 =?utf-8?B?WDN6YWNveFlWeE83enR2aDFGUzlZS2pyeUxRUEdWdmtNTXdiWE5yakFzTHYx?=
 =?utf-8?B?YkVVZTB3TVJxbUdBdTZtb21DTG1obmVLK1NDYlh2ZTgxcmN6NnZPemtlNGtL?=
 =?utf-8?B?andtejY5dDZyRjZnR3dNOUdYVm5MUmpieVhPSmEvRGIrS3JNOHRTVWF3YUxV?=
 =?utf-8?B?Z0J1QnJtRGRGZDRqcXdGOFl3UkxoUTNRVGErSTBzU0RTU0lkN2VJSnNGNFJ6?=
 =?utf-8?B?eFRSb21QTkpheUVGYUZQUEJVRldQOE82L015VzI3QVBFclNLV0tpNko0NlNl?=
 =?utf-8?B?RzQyZWtKb2tqeTZUUWxjbHJKeWx6T3ZHTmlCVVBXbjRKbDhJMVRtQTJ0Z0FC?=
 =?utf-8?B?QjBKRGlia25rZEN5QTFGSEpCQjBWOXJKalh2RnhSc1FiNTB3TldJdWt5Z1FT?=
 =?utf-8?B?cWJBQ1FHMFp3UW1kdmZzY1FTSWpoekJzRHlsU0pFcFJTTmwrUjdzbHZEZSto?=
 =?utf-8?B?UjFEQ2lBTENvK2ZYZFpoNHNGNGtJZWI4YTBtSnNIWUZNdXlwOTdrWlFwdkFx?=
 =?utf-8?B?OTdXWHdHQmowV2xZSjR1WEhFQk5WZHlCMm9GdmhMMHUxd1lRUy9NNGJXb0N4?=
 =?utf-8?B?VW9NdUY2bGJQVWtTUHF1Rndhd3BhS2RwaE9oWW9pN1pKZzE0VW0xL05WT2Ri?=
 =?utf-8?B?QU45MXJacDNoSWZUOGt0VjJhcEIxL1lSaDB3S0JOM0ZJMGZNcE41cWxsQnFn?=
 =?utf-8?B?UkJ3Z2cxM1IyOXV3cDhGMXBZYVQxWGxud3gxQUxZQ2ZVeXhuNTlBTGxINlpx?=
 =?utf-8?B?blNlMWZ4cmlBWDZHMWNHSTYxWTRENklOL2tYMlI0ekV2RmxyQ2VMQ3ZteEJS?=
 =?utf-8?B?WHMyUlJHRWZnUFN4a1dSbFBIK1hielZDZDdTSlJxRk5OenJmdVRJcFB6QmVm?=
 =?utf-8?B?cGVOYjdyeVJHYTJsUXo3RExybHhSZFp4VTMzeDhib21qZWZyYzdHRTFpMUVl?=
 =?utf-8?B?TWp4VjRuckhLNnRQTHFFamF5UzhlYnNJSUN5RmZQamhhQXAwNC96WkhCbWxV?=
 =?utf-8?B?WFk2eU8rSTNQRkIwMEE5TUdrNlhwcDZDTGpTSDlEOFBEWUpYcFJ6OEJvbGc4?=
 =?utf-8?B?UGsrVzVDOVdOZXcvQm9YdW45MUtzMVl1VWR0SDVSV1UvSCt4WUJqeXZtUjBI?=
 =?utf-8?B?OEl1QTRaOS9kaXBMODBoVXRNN3NQRXVRVUpSdEJ2R0Z4RWFmZ3RLdDI2WldE?=
 =?utf-8?B?NTRYZHhqbzNMQnV0MmZGdW9CR293R24rR0VqRXdlRXQyZW9UbkFJN0dvZW9M?=
 =?utf-8?B?TzRnZDd4czhKMkNSMUV4SDFvdlNXY0E4V1dXRVNPeVRUbnRGZEFQSEh4ejNa?=
 =?utf-8?B?VXRVNHplYmVGT1FrUExVcnRhQlZNWVZrYXg1S1BtRkRWZXlzTmQrS0FIRTl4?=
 =?utf-8?B?V3dxaFRkR1pFSjFVeHJyL08rN3VXVjU1eUZkeXM2aXoydUZuVlU4ZnhUWXdj?=
 =?utf-8?B?STlDV2lRVlhIUTZOVXlEeFg0azRlUStTNEY3a2VGM2RZLzNzZDVwM0wvcVB1?=
 =?utf-8?B?c2szNmIvQ2xNcHhjNmI3dUZJTlJOL24yeXZ5S2tHZlBIY1RJWEVDcVRyUCtl?=
 =?utf-8?B?cUphcUZ1MnlCaEZ1Q2QvYWg0UFEySjFmWDE1MTlUU2N0RG5TZWduSkJMVDd4?=
 =?utf-8?B?dHE4dGpRVFVkMnJEMlFSMmxxeTBNWWE4VERtaGZkSFVRZ3R5WlErak1aVXVL?=
 =?utf-8?B?OTlDdXZPZW5majRIN2FSV1ZYdlo0VlpNZ3dZWlFVRTVtZ01HdTY4TVpCY1A5?=
 =?utf-8?B?OFNtN0hIODEyc3hYZkVHY1R6MXBoSDkrQnB5aUZLd09VTzhMWkRMeDJBVmNW?=
 =?utf-8?Q?v9uA7H?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(7416014)(376014)(36860700013)(82310400026)(35042699022)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 15:12:22.0815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad40d933-7cdd-484b-2a3b-08ddc9fb52ee
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6571
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ADF2E1C0005
X-Stat-Signature: w4hynbxfh8rzdz3qup13rdndaxbiqa7n
X-HE-Tag: 1753283546-657913
X-HE-Meta: U2FsdGVkX18hr7pp9ydv8I9+DDZ0sKfqXafIJGyZIqphs3YLmQqmmkdwL5U25IdGQM3A42aQ2KTaVZkUcEqAb2fgblNfmDBDz0eGNcbvJBsm5bPlj/iw5CPFAcG19MkRm1vKF/7Fq6I5oAJQ7el0PzRkoasQV4Tfn8d7miiVo8Y1X+fAJwcLQiPGKVZOeU7FoJBfJsm5UD3COFRV+NcqmULiARVdOAtdJNIpy+R73bD7rE32mF/dKJn15yAxZuYtzIvOauXmAo8ZK9p+TadjnUMVJgeUExSwOkXe7ODWBh5cKP0UlQPUNDoChMeGMitwCdsFR64NQWFQNZf3mJbHPislQxwuyGjEWVNkQcN75HfAmV76efPJzb7qh63RnxAWgineVwAynxayI1kRy/PDzQy6maNt4Zqv9/8DXuu2F3NLarpgn+yFpVKKoBXMNOAS0lgMvCar4okYJvXUNs6qbAr2D/U8lumBPCWyHA91XyS1SRewnokYYvN8pwMxu0FbjiX8T3oQvb6GOYUn8ENkZARcjF2LZt0WEqZbOntVh3jM9gimqicKNCSK9qPe6YHRBaJD/xcj0ALbMYVF/ZSdNnwEFKE3mnUsw65W7VtsqJ51YaWXnUk+bSQHYGLkEKXKVzHcJAPwZMqB53Km1KkvgxY7T8TC5bBzGOkqkVde2Dc9fLCYqVvYJtYs8o835b2wuTEPbh+oICms2N4j1BwIsKZ4xUjSj2RTmdi1oJl9E0CjvjksoYb5NzSWfllvdpiW4GvRCoSIWl9OiMsokwfXT0dyIfcMipKEGflEmQxo5lZhpLnh/KvbEs3Q15XTh4S738qhEzAbqSdcUGA0g8T0oM6dZsq//cNxo4C7q/FzDQZY1WXhet8C4Jm8rdst2RDqGGOxwwhRG5rQCEmaI3kGgb3DX/Ve+IsdG/tgVkjka8+ZWxsuw8JaHdQBMY87+gvVQxJqGdqBc2HomAImn1k
 zqo7ony+
 7UD9B7lrNrNbQOEJAcLf+Rx8Mfnn7groQG02yyLb3Es5JJqi/msLGN1V9YhaPt6MGOB//UcCjslR5rgOtUqp+CSCMKVyBFqdWMYTT+gXue9+4biJMiz+sQjNU+6FgHzBCSxYGxPcEANGVt72OK1Q9VHyu5fKQWJSkiREOLwafus4BOf3mRwWCU4V5S+lPNAadjwWQ7EWQQmWHZlLWIvHFBVgiZ6ouNDX5RrMOuWJ7xTIsBcT1//sNDLxLvZ0Ji72OUohoSud36a3jpJqajC4YksRvRTTfVdoIU5TvEW96jMDo9yriB1Qlz+7W1pxfcQKI0IUBZgFAPmeo0sl+sjB8OyhRnXMFEmNFZn9yyW4J8hWzm7X4oPXIdTYcam0NatJQxP5ex57xF239s/gDihgPItx0EIGIV0t6I8q13XoaOOqlJgh4jNOm14fQFUKvPIo37uJpjYKI8FatuFuUlWaZaVI3YTvEShONOLbdpjHhTsklALG72TA/QtGSIpBIbLT6lrsWZWzUUDEqs7IVBykHhxtKRYgsxoLTPYiRdAMo52J/0qLzGO2xreLKay4v4LGYRflixW/P9CpSz3jXgk9o6Gtkp10h6Da7QcqszWRi6cgIxkRhE+G+fW+Udo6YspiYGL+SpaK91EUNmWQDc232vA6ArWIBeM51hw/kkYrX5gUwJowRhNCrgwVSIKJ7y9h6S8Na
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/07/25 10:49 pm, Lorenzo Stoakes wrote:
> This seems to be the most appropriate place for this file.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   

Acked-by: Dev Jain <dev.jain@arm.com>


