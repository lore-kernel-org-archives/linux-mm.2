Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FBCC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 00:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB986B008A; Mon,  7 Sep 2026 20:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CEB6B008C; Mon,  7 Sep 2026 20:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D196B0092; Mon,  7 Sep 2026 20:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 618906B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:15:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0F511202DB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:15:01 +0000 (UTC)
X-FDA: 85188674802.20.1A31DA4
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011004.outbound.protection.outlook.com [40.107.208.4])
	by imf11.hostedemail.com (Postfix) with ESMTP id D28D640004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:14:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fnuoIqTB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788826499;
	b=5AJNMWb8CJjITBNjmqn5sSn8oGk7ppe8K1PD0PpUHwGt4ObSoHMTGnIN4TXKK7QcjSCXu5
	D1zp8rouW6UEuTWpyEKQr6jebls9koEqKM/g7HOm7aI8LkBQwyvKnpRmWLOeLDNWd/bBxE
	vYyfo3LSBmJRh7PFl7y/uUzbkkftdmM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fnuoIqTB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788826499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olZ7rzC1+DAwEgAsHgkBMGNCpzpm6qm2TQ2J8FB9DBA=;
	b=19Xp2Z3q557TpnBo5LPXyJa84ZiyXB35BgznpdA4ibUkxrkyRHoWpRMGRS0qdFxQBwewOB
	L3Adt1f1p7xWpXyEIrzPFcrhU2RlLl4ndH9DRxpqp01FLsaWLbv14j7qnhftj3gBRDWAkq
	nrHcWo83MMuiQ824hYW4G4sqsYKTv0o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9ZaJace3srPyNWd6jac1lBwCu86Sn3gv7a2NEEVJ4k2PAdrI4SQMd2XFf+8+SRrvNqwt39QorPaqL8n/9MxfAAkcCjqvOBy2+KUU3xbcfx/qo3C9HqQ/TyBMFbL8dSI01GDeWslUq5UDF28kKMw+A1tc+ZexjuC59RsJwxdbv30KmNYHAzcAZnsRBIgrUdX+rtX5DJavKleI7M5evTy2kN7G0eyvnyHF0S1bHE/cA859gSUP6QVRiZ/+SSW/9K+Zv+dz+HuFWoLiXrqUepCYhDpcHb0XAu1klSabRvspSq+HYgAdvUcQlE0Du1IYNJ+3fIesebrhihhNN64BquUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olZ7rzC1+DAwEgAsHgkBMGNCpzpm6qm2TQ2J8FB9DBA=;
 b=mqwTKXDt5zcsLD2b/+PT8cE1xS0XFtx58o8giqDVWhF4cGDn1xNKsQGqsU0W21ce6hy9ZSMl5HcvUsz4MJNub+SGWoYLZXnZZYGOS3dz5kXWdgKmyULKQAUzKoq7fmaa0pOj/046xrxX+DOCS4G7tSIIYFJEs/X1tWtV22I5ZFZNgWVpnDlk1H11XFsUGpsCHvzfygxH7kZo02hSGjP3ynEknLrzITpNH6hOwelaBzBB7rA0yvR8rBbofmiTP5g6Khu9ZmzYAfHcMpprdcyCixgNur9F+4gla8Z617bAG1h7qSxmaWDjgzeLkQVvEaBjeVu8sx554Df6mdkacuTtnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olZ7rzC1+DAwEgAsHgkBMGNCpzpm6qm2TQ2J8FB9DBA=;
 b=fnuoIqTB3bnf+pFGSs4xJmenNi9Qc68xymxbFOF9Vg6mnvWZqYaQULJ1KgObDQ60sa/+zwski6Gwk9fSLKVeQhoGnDdhmArkEfMuULPGYpC7H4qda5K9/Tmfx1IETngzKubDjaLq5yJ1sBZfqfDPbnZ2YCZcOHcflN3LY6Jy9iv/3Vyas3rSrMm6Ho/GAFMFaCWr3iIzr8x07xZN0xlmLK78vtV6KA/bWG1HKJndmGkOpunjEJ5Xas+EE91zTkBYpPB5EeOTJhLcemWxjCsjsx8f9087uM8u7NCtMoOuvtCcmTz134YMojfJ0IPAk7hyzThB8MAnUdS5hVYHrebiLw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH1PPF711010B62.namprd12.prod.outlook.com (2603:10b6:61f:fc00::614) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 00:14:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 00:14:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Sep 2026 20:14:45 -0400
Message-Id: <DL9I2ENHO8WT.2THUK1IVTIS8D@nvidia.com>
Subject: Re: [PATCH] mm/memory: fix hugetlb_zap_begin() call in
 zap_vma_range_batched()
Cc: "Liam R. Howlett" <liam@infradead.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Michal Hocko"
 <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
To: "Andrew Morton" <akpm@linux-foundation.org>, "SJ Park" <sj@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260904000028.149656-1-sj@kernel.org>
 <20260903173540.e8f660dcaf083946417cba3e@linux-foundation.org>
In-Reply-To: <20260903173540.e8f660dcaf083946417cba3e@linux-foundation.org>
X-ClientProxiedBy: YQBPR0101CA0185.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH1PPF711010B62:EE_
X-MS-Office365-Filtering-Correlation-Id: 2adcb982-5505-4330-dbe3-08df0d3e30ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|13003099007|6133799003|10067099003|4143699003|11063799006|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	k/O64/t3u9r0UjYfITXO57RT5gsGdg96m8KV9ZJazCtqG4uRoLUsJumnIjyoFakENawfZuJC7CnZzniZOqZPKqQmBH+oCyqw27QtdJ7DrVbfhdsBIBO4VR0DnUVvbxVtWYqWHmcnZoANtN6gcJFvBcFo0cCvXyg2x7pXOVBEfgdQgz1jbsNJIUZdBvBa/jQkPucDQuHx8UNNTb+aLxuvEFk3Ezqds9/T+0I332PAp7SrA6OWBaBojI1sZC2sd8nJQ/UyKF7BQCbtJ7okU3L0E2Ndj+Jw9ZFDOsO+MEh4/uF4TAtUb1B/dqE7AgpS7ldmmPPqsfmt/4n5ZJSlv+C02bWyg96628cRCq0Tew3VV/e8+rRZVOYbFsNCe+hteHYOGozbu+nxKgxt7vbe06DpUCWTMhLQF30faC0lRx7aPWMv/t9zzXXVsbjsvykPtsRjBoIj6uFPqNPGhWaSK97Rc+cU/fkKh7Q67ZXFpzRR7tNE+J9+0OIOLfnjdrjOhPV5zzrHrs/rdiAIO/GCCuMMF+523A3fy2hlAFWSSzb1YWBz7egnunDPdxNX/xE7VnI5+CJG9HSx8efizFZR+08Rzy0WA/vs4F6Rei0GqdVxjvtTc/vNLa+qkUWFVhW1YNF24l+ux/Ny+q+iauu7+SCLN53cnw80Vzp9MmDGte8m+X4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(13003099007)(6133799003)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlRwSEpaMjZzN2h5LzdqclU4YlJXVkxCZ3hQQXV5NlczaEZZVW9KOFJnSFlt?=
 =?utf-8?B?Uzh0YnM5cXF6emtwVit1NzRFYkFDV25mUDFQaWJRU3hzWWtHMzk4WGtMa1dB?=
 =?utf-8?B?SFVMVzVHSzIvNTJ0Mlh5dkJ5ano3ZitKTU5NWlJVNU9CQk9PdnhpREJKaHlk?=
 =?utf-8?B?Q29MWFcwWEkwSVBmRFV6MFZRcFdidGQ1a1ROUzVDaTcwREZ4RjcvL3pWeGRZ?=
 =?utf-8?B?amdQVHlwM1prSVJSMzEwYTRtL1FmUVlOREVDbTRsKzBOdDJiL1RzNEM4Zm11?=
 =?utf-8?B?N05RVzFIRXZyem1UUG80Z2Z6ZG9maExkaE5rR1Z2d1QwTnUweFIxbU10dC93?=
 =?utf-8?B?eW9vSzFyMkFYNWJJcDhwa3E0ZnZCR2pZYUJBV2YyWXMxMUxFejh5cTNvRERG?=
 =?utf-8?B?YXFxVWtHTTg0cm03bE5qYkNVeGxrUmdnZWlCUlByaFRaZzRmNjdMcjJJZC9j?=
 =?utf-8?B?ZFl1OEgyZlZZSit3bnc0cmc3M3E3QndiYWlSVjgxN2trbTFndXJNVS9ROGYv?=
 =?utf-8?B?cjFCUzArR3ZTMDZjaDFGMFQ1bXRhMk00VUNKVHVzdnhrOHdvSzJJb0VQTFM3?=
 =?utf-8?B?dkJsS3dtR21keGwwc1pzcnl3YVFCT2s2a05IRElzcjRCOEJVUW1nSGMvdjlz?=
 =?utf-8?B?R0R3QkJsMm5YbVEyaTFJekpGUC9mUmttajRTUTN1NUhFTnFNNmdqUVU0L3la?=
 =?utf-8?B?Ulh5RXpSMEpBUmdiTysxVjExdVNPSi9weWh6R0l0cWpnN2VwK0VNNDh0V1JO?=
 =?utf-8?B?cElTSTdmbXE5MDhHajdHbU1UaW4zVkpMZ0NnR2FXUFE4VGxpdkN5MGZNQlpu?=
 =?utf-8?B?S1c0THVndkJ1OXV2eU9zU0IyaGlJemZnOXhnd1J1Z1R4YUFVa3I4eDJ4N2E2?=
 =?utf-8?B?Ymk4Q25nekI4NEo3cFlmWkx1dndNa3E5b2ZJZUE1ZWFiZ1pBZlljR09hTTAz?=
 =?utf-8?B?UjZXUmJ6SXRSbHBwY3FLWUgxVzh0RUdJbEtEMU5nTXJGdzJIMy9zUmhZVk9V?=
 =?utf-8?B?T2xvK0dIYWdiRm1hdmVjVmt0Rk9rM1E3NFh3UE1LV3lEM1pmMGhCYTlxdVNU?=
 =?utf-8?B?cisxUlZpRXRaTmpmVkJ2VkVSRlJvWnFVL1l6OHhJd1B2T0pDK1Y3ZnR1d2Q3?=
 =?utf-8?B?NHNMUkM2d1loMk9ManlkcmxzV0VaWFljVHRoZFJuVTFHdHZybE9FZUt3bFZY?=
 =?utf-8?B?MWQwS0RkQzBHeVhnd085Yi9aTFZpcXkyb2xOd3Y3SzRpNUtzWTF5WEVIZ3VS?=
 =?utf-8?B?RmJ2Y2lEZHZrMDhNSmlSdUx1K2gzYXg2Z0NqSnFOZWhZM3J0bEtDOXE3T1ox?=
 =?utf-8?B?R25zVVg0dEFTT2I3cUtUZkpncmljdXBYMmh6Q01UL1BZWFg5dVFEQTNoRDhE?=
 =?utf-8?B?czlPZ0JSYjJ3Rk9KVzhJOHVxZDA5TkdlSXJURVBuWDM5djBuZVIxTkxENVN4?=
 =?utf-8?B?UTZkdTl5akxtejdGOXN2Wkk5QnhFTnZNMlArYjQrVDluSGtpdWZJWStCN0k4?=
 =?utf-8?B?YWJWczBIUm10NThqS2F1NXMwR2p5bWZHVXFydUprTUxHMldLYy9OZFlnajRN?=
 =?utf-8?B?d0pqMnFiZzRuY29NQWVYTWtrMDdYTXc3S1lYS09iSzk3ZVl1ajhicHI2dHpJ?=
 =?utf-8?B?cHU1MlFVVDloYmR1S0RDTm83NXcxaDJDRVhUL21OSy8xS1h2ODFxZFN3MVg2?=
 =?utf-8?B?NDRhalJNdmlZa0w4N3B6L0xLc1dGSmxqS3A1UWdYQzlqWXRybFJRV2hlNUtO?=
 =?utf-8?B?OUNJRkdKYVJsUnFSa09SU2pCT2NzOUsxQ01BU0o4V2NhNWNacHZnMG1kSTdP?=
 =?utf-8?B?ZkwwVDBucStxUDVuNDhHalh4aTBXa3ovSUVVWTJmTFdxZytUSTZ1ZVlNY1Ji?=
 =?utf-8?B?RW5GbThncE9xMWY4WUpJa2NKZjExMDFBZ3lOSTdaVXZpbURWc0dqcEt0SXdl?=
 =?utf-8?B?d0NsbGZVYWZNUGNrR09Gb25FZkN3YkY1bUV5OWNVVkExYlUyNUNhdTRha2pS?=
 =?utf-8?B?UmNIbGl3MFZnZ0FxdHNEZFE4SExqeWc3VHR0MmNFdXlIK2pvSjJuTDFMek9W?=
 =?utf-8?B?aHJaUVE2TDV2U0dwdXE0VkM2UDBzSDRhZWVQU3RIVEl3MlJzK3RSaGFsTHdG?=
 =?utf-8?B?NlJrWk94QXRmWW5MSExSOExTM0VOdTMvaHJVVGJ1S1h5L0E3dHo0SCs4bmZY?=
 =?utf-8?B?SUJSL1R6U0FsZDZhbkZubkp0SVRrMTkxMjI3dmgzNmd6d3JzUmVlclJLL2hV?=
 =?utf-8?B?eFl1dHFUS3NaOEliT2Q3RlpFekdIbmZ3VU8raFBHbE5GQTIxaVMwTytpSnBT?=
 =?utf-8?Q?k9XumwaAn39gCuPeEY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2adcb982-5505-4330-dbe3-08df0d3e30ce
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 00:14:46.9269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uROv7amomAg9nuWnMAy31DjO1RzJNrV3gogvoxZpIlM8LrNZ5XV+vFEFX6SffLfM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF711010B62
X-Rspam-User: 
X-Stat-Signature: qmpgzeqozubnsp1dbmug3oo3kncjth4h
X-Rspamd-Queue-Id: D28D640004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788826498-799382
X-HE-Meta: U2FsdGVkX1/yxIHcdMo52s12RShef5mwboGh0CNhz9oXLo4dVnzYzYhbodfRhJcQlR/+oTH9jqkf+G9JHhOupUZ1Hhqe3DcZhWx2nY2OQBDrx6s0BTrRCNL81l7g32uCnWsHKEXt8FlScVwPlD+lxNP4gYIMWtGNqVrxEJlb/imRn6lvg4LsaMgZKHnw2REd7viuRxbb9KrtvuqZd52cWSgNF4Ki7ayHZm11YoIhNP6T+76y3DD3dHkSMUPPzB1cOUMKk7Clay2BrfTqL35e6ZgJ0TQnqAJg8ESwidlJ3aGm3PRoMfcpEBAL9OVXPLR3t6IRzyN6Yi/o2SMooCpQ9suzkHwCyj0+kHTc8YbeWh3VDxdqH9r+lQJhXomwHrZl/b5TBa1s/CJmufXmG7BNq5UqwN+rsUJmzLS3gYXmRnwCn31l0dVbcaUcM9SkEyW+xQKbAz+XXwCs5RjVTUlbpZb6j+No1uC5suuzz3lXHEjPgMnLFBvHW9hhQLhG6lmjjiRTOJeaTczEUQgyns102hvOxy2Ip2eUxI/RhHo9hHnssjV2pxWRfOPOtux1zTu/+iBatpwSKewxhhNP/xQ8nSRJQ0HnpWJ22xD5lNu5K3k557aDDJZYVWRuVyAXzH2o1GNLb82IU+eytQ8/sK2gsUvdIPQTT4LpFGR4JSdvhB9m4ALOexSRyQJzD8Agc3h2V8iLfzo0vEG2bSug045Jlin1We4IHZODf15N48M0x4tt59nocKMTmAwWwatGsKn3kQPxHvzpZPMw6KyhrxYeag5l7BxBSbJdGKnMCcFtX4x4n4PmNsQ1zQIUwqt9/UFN+wOhmM1Chr5tldYjbVH2rcuoUTUjNeMUsPQ/tBbmPdpf9dBKWYCTE5Ev84TEki6ASINOpXuss3JTXWHUNQnElB5ixFvfNyHHjuR6+Oq+g1C9N2rt3JOQCnlWLVuQr/puVnm1iN+lkV+7yCEEZXv
 NgeCgtVf
 1K27ZJv24wheF6KAzfJeAJRRgsTL0z8eVaROYhOKC7OlkntY/sgMVddeOP2ocHvNlkkj4PiMh2o35KvxT/hR58JGN4OaNVMrb8h9Q10LzHmpG207iQLdGmfybTJhGVZCn8zr0O1iIAj81HYQc6TMFQ/+rS9thm9/qKU6oioMNk//ZH+43fdN7z0t4hF8SQZjFlhcY0vMwoxrmM1yaN83HYZ/QFYlJklKsGcEo6+BVXmgOFB14I6jQjfbP2dVBqmm84Y2g7cPCIgwJcbqkDEWYJcGqMHXoRjhlfyi7pp30REAKDT8C+ssi/GgLNuIVe8s1JymJuVraUgUq23c/AO7QlyYQmFeeZH9skUvcpsEfu9KblkvXwJh4UGTPYH3pdtvnigAX2xp3QWbA5lQ9ti99Od7jDGs5iGCdUGPVd6tll3OuFOBdTl8itO+tw2MgF3u77ZkQs2eB2xeTKuGRVWL7UIMNh8HY7sBBAKqe3xx4mnsbUlkBJlSNCv7WkDs5xPwN8/+bzXJX0grfMfYfYwI24RFqW2js5YKaGo6gZc4BskqfY8b/CVzkFiKXmDud0fXLVGwF+QhfJX9t0jcNX3oM9CT8c6ogEvswgfvz7MF1hFYhk9Vb/kUCM547bXCZ5gLz77D96VW50t3H5KHim6ZpeeBzkXTsitisB2ZkTOT5OqnVuLtDNshSfPYUzxQLLNEQGnGDX3z3Di7dfvcne9pQeJKywpD+okVQcXI0gHoirng/jN6lmU3s/WDTafHD5gl30yhCjGpLdZiIsTYTsBfuV5tejevZiJ1mU3bEpkxiRPUgdFczjj1a5XCGahyh1NXwnkh6yjxnW68JWWUyS3OFyz3bvGT/f3KC2kHClbW7/eaoDfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 3, 2026 at 8:35 PM EDT, Andrew Morton wrote:
> On Thu,  3 Sep 2026 17:00:26 -0700 SJ Park <sj@kernel.org> wrote:
>
>> Commit f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during
>> final unmap") added zap_details parameter to hugetlb_zap_begin().  But
>> the hugetlb_zap_begin() call in zap_vma_range_batched() is not updated.
>> As a result, build fails as below.  Fix it.
>>=20
>>   CC      mm/memory.o
>> .../mm/memory.c: In function =E2=80=98zap_vma_range_batched=E2=80=99:
>> .../mm/memory.c:2308:9: error: too few arguments to function =E2=80=98hu=
getlb_zap_begin=E2=80=99
>>  2308 |         hugetlb_zap_begin(vma, &range.start, &range.end);
>>       |         ^~~~~~~~~~~~~~~~~
>> In file included from .../mm/memory.c:48:
>> .../include/linux/hugetlb.h:253:20: note: declared here
>>   253 | static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
>>       |                    ^~~~~~~~~~~~~~~~~
>
> You cleverly pulled during the ten-minute-window after I'd pushed this
> out in order to pull it onto my build-test-machine.
>
> There's probably a smarter way of doing this, not sure what though.
>
> It doesn't happen often - I usually only need to push/pull the quilt
> patches (25-new).
>
>> /* TODO: move below to commentary */
>>=20
>> I didn't read the broken commit in depth.  This fix is only
>> build-tested.  I wanted to report the issue with this as a temporal fix,
>> but the broken commit doesn't have Link: tag.  So directly posting this
>> temporal and not very well verified fix first.
>
> Yeah, this is possible fix for
> https://syzkaller.appspot.com/bug?extid=3Dbd6aaf99e8443d8a9034 which I
> had chatgpt create for me.  It's in limbo at present until I figure out
> what to do with it.  Actually I'll hide it from others while figuring-out
> happens.
>
>
>
> For the morbidly curious.  It's really only a 2-line change, plus a bunch
> of changes to pass the zap_details down to  __hugetlb_zap_begin().
>
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/hugetlb: don't lock private resv_map during final unmap
>
> Replacing a private hugetlb mapping can trigger a lockdep circular
> locking warning and, if the corresponding reclaim, NBD and socket paths
> run concurrently, can deadlock userspace tasks.
>
> The mmap path holds mmap_lock for write while removing an overlapping
> mapping and then reaches:
>
>   unmap_vmas()
>     hugetlb_zap_begin()
>       hugetlb_vma_lock_write()
>         resv_map->rw_sema
>
> This establishes the lock ordering:
>
>   mmap_lock -> resv_map->rw_sema
>
> Lockdep already knows about a transitive dependency in the other
> direction.  In full, the relevant part of the dependency graph is:
>
>   resv_map->rw_sema
>     -> fs_reclaim
>     -> q->q_usage_counter
>     -> q->elevator_lock
>     -> set->srcu
>     -> cmd->lock
>     -> nsock->tx_lock
>     -> sk_lock-AF_INET6
>     -> mmap_lock
>
> The resv_map->rw_sema -> fs_reclaim edge can be established by a
> private hugetlb fault.  The fault holds the private VMA lock for read
> and huge_pte_alloc() can allocate page-table memory with reclaim
> enabled.  The middle of the chain comes from the block and NBD paths,
> while sk_lock-AF_INET6 -> mmap_lock can be established when an IPv6
> send copies from userspace while holding the socket lock and faults on
> the user buffer.
>
> Consequently, lockdep summarizes the relevant reverse path as:
>
>   resv_map->rw_sema -> sk_lock-AF_INET6 -> mmap_lock
>
> This is a transitive lockdep dependency, not a single call stack
> holding all three locks.
>
> Commit bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private
> VMAs") made hugetlb_vma_lock_write() acquire resv_map->rw_sema for
> private hugetlb mappings.  That lock is needed for partial zaps such as
> MADV_DONTNEED.  It keeps a concurrent fault from running after the PTE
> has been cleared but before the hugepage has actually been returned to
> the pool, which could otherwise result in an unexpected SIGBUS when the
> hugepage pool is fully allocated.
>
> That serialization is unnecessary when the VMA is being finally
> unmapped.  mmap_lock prevents a concurrent fault from entering a VMA
> which is being removed, and private VMAs do not participate in hugetlb
> PMD sharing.
>
> Pass the zap details to hugetlb_zap_begin() so that it can distinguish
> a final unmap.  For final unmaps, continue taking the hugetlb VMA lock
> for shareable mappings, where it protects PMD sharing and the lifetime
> of the VMA lock, but do not take resv_map->rw_sema for a private
> mapping.  Likewise, do not attempt to release the private reservation
> map lock from hugetlb_zap_end().
>
> Non-final zaps continue taking resv_map->rw_sema, preserving the
> MADV_DONTNEED versus page-fault serialization for which private hugetlb
> VMA locking was introduced.
>
> Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs"=
)
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: syzbot+bd6aaf99e8443d8a9034@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dbd6aaf99e8443d8a9034
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Jane Chu <jane.chu@oracle.com>
> Assisted-by: ChatGPT <chatgpt@openai.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/hugetlb.h |    8 +++++---
>  mm/hugetlb.c            |   16 ++++++++++++++--
>  mm/memory.c             |    4 ++--
>  3 files changed, 21 insertions(+), 7 deletions(-)
>

hugetlb-madvise got stuck because of this. Reverting the patch fixed the
issue.

From proc stack, it points to __hugetlb_zap_begin+0xf5/0x210, which
corresponds to __hugetlb_zap_begin at mm/hugetlb.c:5436 in mm-new.

--=20
Best Regards,
Yan, Zi


