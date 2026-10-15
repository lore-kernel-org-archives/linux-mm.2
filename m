Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9062CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C556B0095; Thu, 15 Oct 2026 11:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854316B0096; Thu, 15 Oct 2026 11:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742CD6B0098; Thu, 15 Oct 2026 11:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4909D6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:11:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5AA4809ED
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:11:37 +0000 (UTC)
X-FDA: 85325199834.05.A199920
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023079.outbound.protection.outlook.com [52.101.72.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id A6AB1100006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:11:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=ezv+YuMw;
	spf=pass (imf14.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.72.79 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792077094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYtmxCUvqp7uAvIv65C6YeNlBqcz3P1dGgtePsETCxY=;
	b=AVdLLQ0DV6YWYFB81gqbFMUQoCWBd9xRRDU/s3AMyKgDGmW/8pEgVqqYrOdtd09GQy6vYC
	1hxjDhZeEWv0+ioCq0SQlU7tkw+eOEPRQfUvZt7hezv9ogsineX4E6ZOIb90DUjRLEspNa
	7F+qZnQ1y5m3Lr9U2XW7rVpm4mEvqd4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792077094;
	b=xa7OAniVhGxz5Ob0KfV9pTmzKMxJWoaRhAtklzimtHENnm+VqmTEod7FUCcdd2aJYPfXda
	F0qZjv6O/Vr2w9yNZ8SX/WBCtEhESUwjgHjM4jkqbT8pqLt4oIyvNN/McK+J8KdtG5qRD2
	KWkhLwmDy0Vki+23NPeiWzXPL+lNCO0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=ezv+YuMw;
	spf=pass (imf14.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.72.79 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nd1954fhu6c9m0x/D0IOt+l4pRQdxwDCG27TnScIi5PPYRpo9g89HctoYJX2CDqrD7EbrH6SDKZO7DCFxflLP9OjHJYFPWvHCsW6ET19pjfzwjymKX4tK4KjcXdlYPAJ6Q+GO/qGjr+xgkK5iJwX1erZsVgN3My0PogbCuWreYc1QPavjX8pAhUjINrI0N6CKjyO4t7x9dSqUgJWoQEXUHwmSEdGQCnpZNjPnhJoDo36CihQrWAuRx7WxrRUrCm3ZONPcP4AWsJMxNXYCHo/IEwPIjX0kDjXWzVAgYYxZd3StwNAQJq/HAFrcs7SrUoEmg3WLsPEP/nEZ+ua+5FWKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYtmxCUvqp7uAvIv65C6YeNlBqcz3P1dGgtePsETCxY=;
 b=iPfYfsWRlQreraOFuYIYwFDy6rcG2iw1nFqS2DI2wg35DruAW9XH7Nq7HA1inPAL31Gk03XwgCo8n6Mo+VVgUp/xa4pmt7vbWulqc4HSAECNO+F3WbPhtOpSlzfUQKMKIx/g6BLfRBMxTSm1R68z2ZsMC6UPYOkt1WcYXSdX/H/qSbw5ms8t8du/WRTmbGZPmtg6jl6WGe3FokAtE25/qxTSCpsVozakndg+PrH+MKtdApOPckOQUaHIgmwCeg6BKgIaOiOYPv8n/o0ucIR22WkB1prVnFZINFTR/YLoymjNvDkcULByoH8K/OKBhFejxw2b/i7/6O4oi++sLilNLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYtmxCUvqp7uAvIv65C6YeNlBqcz3P1dGgtePsETCxY=;
 b=ezv+YuMwT8q9ycf90JrU3ZuFUhaXKa+wKXV4/UCyLSYAnnYdl/Wju1c5S9HQdJ7QYuXoWCLrUx2t/5IZi0fJuGFXC1mtPLFBM176bNCe7umX/VAYfleDlOLMQOR1+w5Zzo7BfMreIo5+Hj4hT8uV5xvyVfzF2RbXPCXV09rBHCK4lAfr9Dih/LbjZc/ifr2BS4WcNWNAueuE5XeANWqgPD7ZMMYmWCozrnI64CuqslgqNAiCkSfCK5eEAUUrLHfcPp5giYNMzS8QdVl5VWjmJc8fo9NqQsZgajHz1YHSS/YX1G1+YS7h/YnzDlCV0jZcsC4DGZNoyeMPAJU+bPmWUw==
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1f4::5)
 by DB9P192MB1898.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:39d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 15:11:21 +0000
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c]) by AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 15:11:21 +0000
From: Florian Schmaus <florian.schmaus@codasip.com>
Date: Thu, 15 Oct 2026 17:11:17 +0200
Subject: [PATCH 3/3] maple_tree: add a test for destroying RCU-mode trees
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-maple-tree-fix-slab-corruption-v1-3-160d97f7304c@codasip.com>
References: <20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com>
In-Reply-To: <20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, Florian Schmaus <florian.schmaus@codasip.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2703;
 i=florian.schmaus@codasip.com; h=from:subject:message-id;
 bh=jgFsBitOSMzywJzgXX82rl/KgRE7CrKNpxpS5oG39ak=;
 b=owGbwMvMwMWoZLn8xddWhSDG02pJDFkX3opEfOyffsGxMeo0L7+06+6UxtKiV/WTd920eMM/f
 TNv+8z4Tsb1LAyMXAwzxRRZppeyzrdSvPMw+8nvdTCDWJlApkiLNDAAAQsDX25iXqmRjpGeqbah
 niGQoWMUD5HTY9DILC4uTS3STSsocsjLL0ksyczPK9bLL0jNK0gv0EvLTCvJyMgvKk4FGqGXl1p
 iaW5uamBq6WbsaGTo4uxqaObkauLm5OhqZGRs6WjuauFmamFqZGBqxMDFKQBzDVcf+1/J4yf3Nx
 3WbV672f1c9jT9rUqs07J1ItrFS37WOizX2Gfe1vLP/0RYu9fH/Ej56RVL6gK0VWZzzO6O8J21m
 EnNyNWndN21tzERJyJ/ro2fOe3BPX6LhZKm51VmiSyW1/687ZndbVXeuAs6J2cHZD2+vX1pWIjc
 iWtd+53tfi6fK8xgHTYnjj3loLvBLSn7xqj3jY39G3P6G6deOlqxb5O1+82OImWpXQ7xO+qWbdn
 yY4VajvYzp1XPRGs+CbSsi3m3pu7gSvUNzKv8YhTbhI8EF7XWnCqVS5xynMlkxQ8e7bm7vNy+y+
 6IW7TmV+83c7V1H496TfS3Ur9yMIzT6HGQUA7LVHWvU1I7suICXgMA
X-Developer-Key: i=florian.schmaus@codasip.com; a=openpgp;
 fpr=1357B01865B2503C18453D208CAC2A9678548E35
X-ClientProxiedBy: FR2P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::7) To AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:1f4::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P192MB0983:EE_|DB9P192MB1898:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8f6798-c5b2-4c9c-a1a7-08df2ace91f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|23010399003|56012099006|261009223027099003|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xDFlXRrDCAK2x0EYSLH9RBjTgxoiGNzkaxg0D47tNAKyO8tFCcT9GxpeIaP3T5i/KZ3x6dQ6DEb8nJ4duoPaQe5pR1Y2Nnpw3xyslMrqdML/rUVciR5e4NJjQheV9lNVqdI/rLQ8PoOMjEf1BpwKpwPO/3Lgcn3qm5uX7qA9HA60H828uCxigSwdC4c4oa6EU1WyLCE9hBIx9KDQegIz+IwvJN/2pJdrnQISbMjSx7WdT59eWlZvo2RhP1aft3m7b8fjHuTFpua2q7Ko9KS9r1tFPlOBBPJwLheo+T0mBBS6cEp8hpItir4UsnC2GcZjH8yO9VyMSbplvcMVf1IlIt0gn4fbmaI2XbfJKfTQEu3xldCGhIM62JenZYy+l8Dd2Rj6/4AtpBEOwhrhc51eojm+5MHpTCHhIVbLnWmLS7lyZ2AHts4c0JbDEPjMEA7dG3h3TRCrsq681m0YjvhPCBjcOr+cxAUGyPOCOH0XBmw8ocFPrDkGTkd2dHlVMj6UMQxTlFS5LkLIbZLDc7UIlHdNTGxSPSqe0k9vK9WgHOpS3pgM8X5rDPUtTLodpMg1RUoPsW7/tmlSfTEyCmHxh+lTOMesp+ICgGw3tA4xviCy3f3bYiQroETMjxoEzZlEU7lvfX+xH7Bs2bfkPHS14lBTRuSOSuJuD2BObWeAERI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P192MB0983.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(23010399003)(56012099006)(261009223027099003)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUpqVXdHV1BDcTNRMDZ4UnNabktvbXpWaVdWWUpKeEtESjczMkxid3pvSnY5?=
 =?utf-8?B?TFYra2xkT1c4UWo4Zkl5akVlZFd1Q1pPMXBlYkxFeWhkZUV4VjNxRktSTVpK?=
 =?utf-8?B?SmtqYm02Q3F5d2g3L2pEZTI4T29YZDJMSEhXeVpuTTJEb2prYkdNVzkxVTYv?=
 =?utf-8?B?YUJMeSt5M0hPN202ekptZ013OWNLQ0NrS3ErZnBLYWdoNitQZHZQNzA0K3dB?=
 =?utf-8?B?M1M4TnJ3NUs1NnM4bnRxUTlvSzk0ZDdXOUZMenUvVkcwRiswSkNqVmlSMFdu?=
 =?utf-8?B?d3pVYVl1dEdSVVhBTzlDazN6SFN6cVpyTlJrcFIreEFEcHJyVDBhUnFzQnZl?=
 =?utf-8?B?V0ZydmtKZ1B0RHQ1VFpUVWRFVzIyT2JkTVloVU12WTJTNHRVT01VNk0weS9a?=
 =?utf-8?B?MElIRjhOZ3RTeXhuUmxzODFIdUprUHgvdkIyemZ5dnhGV0tJeHJ6Z3NrWW02?=
 =?utf-8?B?RDZrVnFxdzNLcE1GMy8wQmVaRGl3WDFFVG5iRTh3YXhXcGpXYnUyQ3A1SnY3?=
 =?utf-8?B?bEhiaWNESHpBbTVJaEJnbFcyVkphOTVEUUp0UDQxNGZKUmJ0YXhlNm1NWmFh?=
 =?utf-8?B?YW5HbEs1QlBoRVZ1aWF3TWVZbHJEUitHYmhIYXBuNUxTRm9KSWVpdnQxcjNI?=
 =?utf-8?B?eFV1YXBrWXJqUjhVRW43WmdlYTliOXJqclltMEthQU02NnhSNzhDY3ZMQzRa?=
 =?utf-8?B?M3Z2QjMydFNqbmZselVrVkZTSy9UQ0xhZE1ad1hhTkozbFBobm1ranYxdXZC?=
 =?utf-8?B?UkFxMUFMaGZINW5ZWXJEVTRPYzRLY1JwYVF0QmdYVFVkaDIxZEVaTnM5eWFr?=
 =?utf-8?B?cFdWQ1c4em03ekovcitJTTVxSm02RFl2N0t2ejBPV1NBRDBxemI0UVI4Zyt5?=
 =?utf-8?B?SFVmeUtVb3FiNmI3UktnbnBVaXJ4U0xKSGVxN25HbCtHcjBxdnkyT2NmR2lU?=
 =?utf-8?B?Q0lkYmZ2Q0Z2aGJGczZtMDgwb0MrcFRJWi8rVGFmaUZwVW5jN3k0Qk9aL0Fn?=
 =?utf-8?B?RC91YlUweUMyNFRtaFY0SXQ3dGk3ZkxqdUs2dTkxZkF5alFlS1BnWEdIWHdl?=
 =?utf-8?B?RTJ3WGNWdDNGTEdUTGUxeTZMSEhVRFJ3SkFoQWF4TSt1ejlKK1VTaUxLYU5Q?=
 =?utf-8?B?WXZWWGRwQS9YeTVNbExlSk1hNktIZk1JRlBQVW9oOW9lejZHNDFZVEUyU1U0?=
 =?utf-8?B?UFpHQmc4aUtHL0xVM3duOWp2QnhzK1YxZ1d1L0paNDFndFA5U2VKZzQ5SzJT?=
 =?utf-8?B?cUJzdm8wMnVqTUpuK0hHNk01WCtQLzlBTXRVSWh0azZkRmF4VGc0RGZJaHFZ?=
 =?utf-8?B?eVlIRjdwb0VHY3ZWOGxoVVBrRFVoSzR4TUxlNWNJTEYwNDdkYldqNDJQMGsv?=
 =?utf-8?B?dDBsS1l3ZG1TSlFoREE3OWpTZE10RWluK2JtS2NBUW9nRjlYREVjS3QyM0tD?=
 =?utf-8?B?Um51WWxucmExWGsvWEd0TEdjRUZNazRubUNHQXNxVWd0WkVUa2Y1Nlp5V3Ns?=
 =?utf-8?B?TVQ1YSs2VXVPUkhZT3BGQzBRekQvSEIxVWhPelBRUDIwMDNGc1ZMSGJMU1dt?=
 =?utf-8?B?b0h2UEdNR2JXbGZlZU1iZDJOSGxXamp1Rm1vNHpZbWU1Y0NIMENUUmtWTnd6?=
 =?utf-8?B?Q2hXSXc3Ti9ha3Z0VHpMTXNJWVRSNGVZdE5lQkZodmlUQlF1amhhc3R0VmJh?=
 =?utf-8?B?a3QxVnBxTWR5b3ZqZDZhWEc1TXBxY2dnbzhEYndVdGJqcHVFMzNiSldRY2ZD?=
 =?utf-8?B?T1B6c2xNMkJqVWZNcjlwQUpBUHpmNFdtUXc3V2U2ckFkT1ZIbEh3bzFHVEpZ?=
 =?utf-8?B?dUJxN3ZkTWh1WWlPUFZaYytzdGgrUGdOTXNheTc2NXhZNjFYbmpZWTBzVUgx?=
 =?utf-8?B?WXFuSW9LaWhMU2lxNCt1SXlGV09ja29Sa3BEajVSeVdKV3JJWmptNjNZZHVS?=
 =?utf-8?B?UWVyNWRVU3I1YlQwZjJjSFhiUW1KVDVwRVhrZVdOSnBqQkNPUXRnTklON2p5?=
 =?utf-8?B?ejk1dmJYUFI1ck4xRllYaWxqOWZGU2o2ZFAwQUxYRTJNNWhtUnV5RjNsMVBk?=
 =?utf-8?B?Nlc0cG1VcmdaSms1TnF3aGhEbFYyNm1rMytDaEZzNmw4RktYa09jZ2RzcXBo?=
 =?utf-8?B?OXpDQUlEeUJnK05SdUhpZWRmamZ2Qm5BVzZRNm5LUGVidHFXVG5qaWVQVWdI?=
 =?utf-8?B?NUVFZGlTbFhuNG0xeWdTdmVydlFuRXcxazBvZ2orN09vSXh5bUZuVS9EL0R3?=
 =?utf-8?B?WkthcmtWUStPdndIazVnMzM2Unc0U0tNRTRtSTdBYit0NmxKV2dPUTNzK2hF?=
 =?utf-8?B?Z2phc3pHSXRIZW9vVWxFZVJGUjk2OFJIdXdWZHVkc0YxYmJOc1lUenYvY3dZ?=
 =?utf-8?Q?yjqnFLAHFFphvT7DWYDUOEGyabfkpLe6FkGblKuGmrIIW?=
X-MS-Exchange-AntiSpam-MessageData-1: leXRRq1saYRC/sgDNccy5tUwmcjBhzCSybo=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8f6798-c5b2-4c9c-a1a7-08df2ace91f7
X-MS-Exchange-CrossTenant-AuthSource: AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 15:11:21.4004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8J4hnpMmpJ1k6A3imR8AKzXnMJrjJ8EL/ThV/oANyZ+bayUrLlyuPtJnTiR5ZAK1SybE16aO/l5vj4T4XJ3x1Br0Ebr0zzmuvqcmRcrykQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P192MB1898
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6AB1100006
X-Rspam-User: 
X-Stat-Signature: mjymcyfg8nn6utqt3htkqjukptwwr6pp
X-HE-Tag: 1792077094-123712
X-HE-Meta: U2FsdGVkX18LBkNneXaz3kmfoPGoZk6hWCPuUZ+PmL4wS1Ui7sHXzmZ1snumCRt2q/xJSOxZhxe/HPfyUfodcQ/xfB+oT5+B2p4MD+xfqnakF2uD3UQUUei3tAVk0mn8to+SpUzoaVXGuPtluw5wwlOxf5uaEYqdZX0dVpmCNU6gAbIqbui72wYV6rnpszCbhTuYXR9FfByae5TdaNe3BkpdQbwCVMgNPpK0qc5QCCijNuq0/I9oQQAIAOQl+6lgOOc+G5x2yzw2aQJONIAY5ISOjF+rCSCfbooOpzr+y6/GrkvFjsgfO8iXk0r5YsXBKAX+msC7skogPaE+k0hekUBsD//+DpsGp/zFPUTrUnRoRpt5NZ3IKaKCjrWoOZzgQBUmoRbA2MdP6O/1iMujsMYdK3MxwiomdQkSUza9MKKOkAjdD96+2gxCqWNB84SPGIFXM2ihPKdpFEnrtBZv7yiOCjYmC5ml1al+vN2rcH0/85/FGC69xoxqTHBtWV3132y8EP01bToqJfmt2ro1aXKKo3KanUNghrj5KSGplZgMS/Ay3jBruIrSol8bn7/h5mP0Ybe95vtnhAp9ErFaJ4UHPVymWYUMfrLdD6qLlSZtDLiqmRDSjM+OhudsAEQgjU3v5Hh9nTiVguTNrMJiPx1BGy62SyP79yQk9yyn7fyBESkLiW9fXZ26I0z+FccAigTw8w2XOqE2p9+shAFMUW2c1m7Bl9d3eA4xDVTGKVwv4p9ntnUDpXFbC3Gf5gJXxgCzaDkvK+DkduwRo1g3jcsOuLwZys9eMcpBMHh0qWeAHcpk+/DtxBXbLPgPpfH1B5CBehGahc3/aNlmXQmkhnAV6BSa300uA/kO1+zRWy8YzdrhzfIs10c0gnIMGS0XJuEI3OlgRhFSw+VZNJU25ezOviET7Voiz8O4XGguayu1pcSp6NQ4SRUZXJ+qXRELK5KtBjTwH2dtak51Tus
 o23IPb4z
 FHw+QWOy2AGjH2q4K8eIxF+Q7VzpIw9rOz+/RmhfZcKfpPEG1jAGHv3DyYYW9JS2ukGj2Cw197j5WaDkGBwkvwN4vkNgfFCOjkL7H5GbZGY6w5xRqxoxZ9W6aMSXwmufhMmbB/EVGQapDnI8ZNLf26ejZGugF7F2sLSr4TyGYQvF0uEYEDs+PbVDOtknLflxEhiDs1AZIXr9klToihYnCx7hiKAbgtnW6KoVuwpJ+g4RR2dLUPqNnPSI6+rTiwZMPQOuwPNyCRG4FmeAP+IN+aSaAhtUx1WCz897brFIpWOKRnyN9mHXg57M6A4rKNMs4f8i+hdtwhxDP4FvqOjwj4tqoQHkILii+QBiJhXgNSg6f4hdrykmyVjYhzaIisHOJLsFkugRHwN1QVUrJhXK+DzLUUs5SGv/PePAO5Xk3kTGrggzVzl7UJZXxtw8QCw9nTm89VfVd1ceIcNqg7KW9teJYRzmKDlsMgu/ZV0i8q/W3n+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Destroying an RCU-mode tree that is not an allocation tree defers freeing
its nodes to mt_free_walk(). This path had two bugs, both caused by the
metadata that a maple_range_64 node may keep in its last slot:

- mt_destroy_walk() took the last child of a full node for metadata and
  corrupted it.
- mt_free_walk() took the metadata of a node with 15 children for a child
  and dereferenced it.

Add check_rcu_destroy(), which builds RCU-mode trees with 120 ranges
(a full root) and 2768 ranges (height 4, where a non-root internal node
has 15 children), then destroys them and waits for the RCU callbacks.

The second case crashes without its fix. The first one corrupts memory
silently and needs KASAN, or ASan in the userspace test harness, to be
detected.

Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
---
 lib/test_maple_tree.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index b9367c61e8b5..aea62269810b 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -286,6 +286,36 @@ static noinline void __init check_seq(struct maple_tree *mt, unsigned long max,
 #endif
 }
 
+/*
+ * Destroy RCU-mode trees that are not allocation trees, so that the nodes are
+ * freed by mt_free_walk() from an RCU callback.  With the ranges and gaps
+ * stored below, the sizes give the tree shapes (on 64-bit) that used to break
+ * this path:
+ *
+ * - 120 ranges: a full root.  mt_destroy_walk() took its last child for
+ *   metadata and zeroed part of the child pointer.
+ * - 2768 ranges: height 4, and a non-root internal node has 15 children.
+ *   mt_free_walk() took the metadata in its last slot for a child.
+ *
+ * Without its fix, the first case corrupts memory silently and is only
+ * detected with KASAN, or with ASan in the userspace test harness.
+ */
+static noinline void __init check_rcu_destroy(struct maple_tree *mt)
+{
+	unsigned long sizes[] = { 120, 2768 };
+	unsigned long i, j;
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		mt_init_flags(mt, MT_FLAGS_USE_RCU);
+		for (j = 0; j < sizes[i]; j++)
+			MT_BUG_ON(mt, mtree_store_range(mt, j * 10, j * 10 + 5,
+							xa_mk_value(j),
+							GFP_KERNEL));
+		mtree_destroy(mt);
+		rcu_barrier();
+	}
+}
+
 static noinline void __init check_lb_not_empty(struct maple_tree *mt)
 {
 	unsigned long i, j;
@@ -3804,6 +3834,8 @@ static int __init maple_tree_seed(void)
 	check_mas_store_gfp(&tree);
 	mtree_destroy(&tree);
 
+	check_rcu_destroy(&tree);
+
 	/* Test ranges (store and insert) */
 	mt_init_flags(&tree, 0);
 	check_ranges(&tree);

-- 
2.55.0


