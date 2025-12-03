Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4726FD1CDAB
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566EF6B0027; Wed,  3 Dec 2025 18:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517786B002C; Wed,  3 Dec 2025 18:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF0A6B0031; Wed,  3 Dec 2025 18:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3D56B0027
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:48:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C957C140803
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:48:58 +0000 (UTC)
X-FDA: 84179802756.06.A67163C
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010059.outbound.protection.outlook.com [52.101.46.59])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1CFFA000F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:48:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=rRlx7xPY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.46.59 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764805735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ar43r4y+MzRQwYTx9xB9dTnCj9DNuoVarzpPyTxnQdo=;
	b=TlaFiGMQQSWFQBjN8ELe5jkDJeTqFQcLye+vullkBmjuiwUQJT5K0q+J/SR62sVD6fMzG+
	SLaHbj2AlKmyEbRG3MrmJ2gTgI0TKNYkcofgvzjizwfyZjjZblPQdiCJl0DQnfMsQK5rL9
	t1771LI/wAWliq2On1QwgMrVTaPDHbk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764805735; a=rsa-sha256;
	cv=pass;
	b=ld2gJSNS6OMovyvDuXxzj7eaipOAdWWgDASsq2lHFgwrfqrrVm9NX2gIolLpQUf6DBbPY+
	cy2ozNAskA97uDMAcH9A7hC1VEKT83B2qpdP6Qwg4CCnzthPWd06YglJW2Ku4JrdS+OMZC
	nhj6xpNxxGFvlGpeTr3UEb7xMxFu1+E=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=rRlx7xPY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.46.59 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZdE19deJWBdEv5YYlPtGKURjGzBggyaw0HtJelBD3OWTbk1qiW0r6BaZU6u+3upKIZiloc9JCCiHbnf3v1jVnohzi7odRYJPHPVDiQmXUSb9Ak8G7/eJOS1M00H1zDlc3eMH+3psEZUn7j4FkilMVq2seZIkSEUT+T5tofhYpphbqo0s0+sgmcW2v4vSOZReFZMZeYQMR877R23TYDt6PgTTTEwwEHVYAhRDSoPdchqag9MVKoDDj7wP4xSTICLlO0Gro3EhapoZRdZ5WAWvmP5rfknmEOkYt6IWuV+7QhaA1XjfJzfQ9Nfy3zpY1iVNsrS4Oe9KHJOiV8NilAXv/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar43r4y+MzRQwYTx9xB9dTnCj9DNuoVarzpPyTxnQdo=;
 b=rmmmCJAIgWLnJJiozDKQyWv2TNY0dXYdIBUH5dNhymIRQRhb23E0fiM+6bVEqEa+SlnNUjA1g2AfYoNOQooGnNn5YM3vkj2ftWoKCF2uP7CN78TJ8asq7EWehi/JGNeK74zI4xmpgj8hHuHLXdZF+elFEej/HKok5Q+8Cb4Z1N8owkEscE6QKgnQwxAtYNSrn4GXoiGwJZIpUUvQGWO+QSe2EYUiSKqbKxscC8A/vS9Xc2f6hdzLmHzz4JYz0qPXV562Q0uhw6IXVFTwrY7obs319EwvA6UhuF+mCtYEM8kNaC/3dJwQIUezgoE3Ud84TaJDBpz5edmftoPfftmByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ar43r4y+MzRQwYTx9xB9dTnCj9DNuoVarzpPyTxnQdo=;
 b=rRlx7xPYgVlPdWPBSFk+VLxRlO2WqMu4MihqbqgUJSqHX4zaVlIgsTKJ3GZ/zdqF11nG0xXj6B+H++0h5ySFTVJCaF7UoVSi0qtn2KnNHEHtRYy7zfRwkQs+3Foq3wqtvAuQGG3JVdcyiVC1CDUdz9m+zuvdASZrQiJ7IV+qMxo=
Received: from CH5PR03CA0019.namprd03.prod.outlook.com (2603:10b6:610:1f1::27)
 by MW3PR12MB4396.namprd12.prod.outlook.com (2603:10b6:303:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 23:48:51 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::83) by CH5PR03CA0019.outlook.office365.com
 (2603:10b6:610:1f1::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Wed, 3
 Dec 2025 23:48:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Wed, 3 Dec 2025 23:48:50 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 3 Dec
 2025 17:48:50 -0600
Date: Wed, 3 Dec 2025 17:48:20 -0600
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251203234820.jzzmrqxjeyt5w6gf@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <CAGtprH8gznGJ6VObk8aShBn_XnhwDoUzyzTkaDAe+MyiNsJ-NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8gznGJ6VObk8aShBn_XnhwDoUzyzTkaDAe+MyiNsJ-NA@mail.gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|MW3PR12MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: cd8c533a-c0a3-4bdb-95a1-08de32c682a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHJjc1JGVVhwZXpJWkI4SkRRKzhJZ2YyM3pNSGJkYjNkbVh2ZnpuMVYxUDBN?=
 =?utf-8?B?c3RDeEswUUlBM2ZyYVBUTnNSMTN4R2FOSzc1aFRyOE5nQUhKTzFIUzY2NzJO?=
 =?utf-8?B?RnBZYjJHZitsbkVPSmpQN29PV0RqRTBkbGtGVDQ0THZBMDloeVNqUm5uZHox?=
 =?utf-8?B?V0JnVzlUMVRuUHdnOC93UW9sdjF2NUdsQ2RieVpncENyK1pXck5DVis3OFBa?=
 =?utf-8?B?ZHhQeGVyZ3QwdUFTYlE2ZExyS3A0eVlMNlVuQlhNSGFEck84SDF3bEtoQVAv?=
 =?utf-8?B?L0lFYWVLNkIyNnhuUDFCM2JSalBuanByV2JWcGxYdDQ3QzdsZURJWnNMSTUw?=
 =?utf-8?B?NHdHT0xud3R0Q2NjSWN2M3BKbWFHOEgwQk8zdXlEcTVabVV6cnNHZFZSSFZ4?=
 =?utf-8?B?Sk4zZllJSHZxN2l2NThpaEY3L3NST3lsUWtxekdXWmlWaytOSWRZWXZTVWlL?=
 =?utf-8?B?b1JKeTY0Z3IwYlhpY3g1ZHI4TEk5VlJLYi9BTW9UUGJDOXBseDZMVFBnNHdT?=
 =?utf-8?B?WVV6RWJLbEtYT2F1dVk3aWlWWDFCWlQ0ZEhjbEhXd1dyalhKMUlUM0dSTlMz?=
 =?utf-8?B?MDJ2U3A5Mk5WeDQ3K1lTVTU2RklhcFdEbUFXMnE4L25RVFZoclBTSjAvTmJS?=
 =?utf-8?B?NTZlVC96UjBHYkdSWnVNY0FYNW5Uemx6Y2tYK0lzaFlIMVV3MTBybFBDQ2xN?=
 =?utf-8?B?YTBJM2Y1cUxRNGg1ckpGQVZ6d1E1UEVMaGluYnlvaTVJaXdBaTJVZUd0SE9P?=
 =?utf-8?B?Tm00aUJ6c0VPN1E4d1FZa3plWVcySHcvcmhHSjBjYTYzNXIzMFA3dDdLTWRL?=
 =?utf-8?B?ZmpMSlJrV2gyakpMUlRlL1ZVRW1uWWtacGNMOHR0dUJNcXR0SlVQbytYR3lo?=
 =?utf-8?B?endaUFhzMFRvZCtSbmZnMXFHczhSOE1RNW1Rb0d4NVpDYU1LL09BUWI5Yzl2?=
 =?utf-8?B?RTVXVmlwOGl3STJ0cyttTkJtUTNsWVV5QWpxaThHNW4rcTV6TVpxWllGWGJR?=
 =?utf-8?B?SU5yRGJqSkFSaVE1cjFSY25yT3B5aWRkalZCUURHZEkzZ3NiR1pNb1B4RnQ2?=
 =?utf-8?B?TTJISUhZWDUwZG45S1d0UmQxNXVkeS9iajZuek5CcmIwSW93aHJGVlpiOTZi?=
 =?utf-8?B?ekl4bGJsdS9BeEJUOUY0Qk81L3hrbHRQSVJGRmIwUC9MY0djMEpTNEZZWHN5?=
 =?utf-8?B?SUtidUMxbGtxa0JESm9MQkozQkFWYUllS1llbFlSbjV0NVE2SjQ2YldSUlRw?=
 =?utf-8?B?Y2tPWkF4b21JcVMvQWVWSTdjdXdzZklqSEE5QUhqL1VIQURnWS9Va2tHNXJi?=
 =?utf-8?B?elVvakQyaEd5MzRRUW9OOWc2ekE3OWlYRzVDNXgvUVdxcEJ0OEE1dUZvSCtP?=
 =?utf-8?B?aUNXRmFPeHdjUm80ZkJBdU01MXFSbS9sZjFmR3ErMDZaY2llMW5RaXlnZENF?=
 =?utf-8?B?UnlhbTU5aTB0OWlJY05hSWFjRlpLNmNUZU52enBocU5hQWZwWVQ0dU0yZDhz?=
 =?utf-8?B?Ty9NeXRRNjdGdHhrVDFVSjBnVjYwTG1TZHVUamYvSFd2Z2tNWlhhdmlzTHBC?=
 =?utf-8?B?eFJ2eGxMeXVML1RFMVlYakQvRzlzV25jVXNha3o1VkdNYnpORlk2MHNFQUZG?=
 =?utf-8?B?dUlQQnBoOUxhWXVFWXFUd1NYNkpDR2ZYa2xtaC82b3VTczZBQ3FlaTk3aEJ5?=
 =?utf-8?B?bFltQlV3b0hFK2V6NnJDR3grZ0p3SzROMmtFeDBOa2R5NG9HZGtWRUQ5Yjcv?=
 =?utf-8?B?Yjh1UVE4ejZCcjU1OFZhek9SQTdGZnRBY0hUMGpkUUdQVW1Sbkc0alg4RGIz?=
 =?utf-8?B?UllLNUY3OE1ybWNxYlpxL1JRaUdacFZ4ZzFURDh3dTN4RmVwc3RuUjgzcjY3?=
 =?utf-8?B?dTByQk5IcE1TeFRxVXhSN3U0akRRVGQxVDVaNVZtQ09QY0FCUFl0VVdNWnNq?=
 =?utf-8?B?dk9jNFQwODF1NHFOZWRVcHdsQ0pRcHYvbVhrK0FkcDJwS2VJUmMrcnA0SW44?=
 =?utf-8?B?cGxTRDZZc3g4WEh2NzFrOGFQakFHWnBERUc4TVNYQ29UclhJZXhRZkJldWIz?=
 =?utf-8?B?YWlZbDNWR2NEV3dXMmVUY3NrM1AwZ256Vm9LWnlIV1B4WFAwOHJoaTFpSDl2?=
 =?utf-8?Q?trksuKdTYW8A40+a9WN+3rkjN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 23:48:50.9358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8c533a-c0a3-4bdb-95a1-08de32c682a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4396
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1CFFA000F
X-Stat-Signature: n1wwm89zr1p7qc1m53d93s9pytber6pe
X-HE-Tag: 1764805735-944912
X-HE-Meta: U2FsdGVkX19QnJu6GxX/VjQMIxG20ip+zrAzehtxBvaO9oivLyFHbi79If6s89W3kAYY4RfFgC8td8UtzYIqvCOk7JjVjdcKIQM53Pbi/dAd0YA+pMXYNSxb3AY1f9jBB1BFO4fPcqTiTB2RIcVvGcJjTTo7xBPSRMCn2wQnWe3tGaSbKJj9KZ6YIn94vf8bNNzTr2srIS+j+2Mma+U8lMTkF43lA4jIb7N4YUurghgFGmIkn28/JztLUtsMsVOa2Fncg4bCog0A4b1a+KQIv9UGPttGZiXDFGUzjrOd/Buh0ZCfILqbpDn3MR6qyYt+t33gOgdteEPvDwxJ4jI/NdfdM/SUUkeRjpicwZIcxOpRvXR+dq6Xd7LrUm17Pyal3Rv3ByUGidJW/rb1a7l4XSqhdA9klsGltzuFwGGQaIhM71rsmInZ5MkICPmI2j1WTL7zt/vswpGh+wUyHWFw7qWtPLgIJE9yu7w5tqHbxcKefzLF+Cfw2noseAdZLIhiFdb8PPXFZUc1lxwZcSCAFuKT7qMHQax0hibFBIygEo6SG/dG69U+dT9qWMqXNvbxUr0Q0wSw5yuWq3CyOh2pYBUvdkrhYY6cYDkyIc8ZEDyZyamwoPq4yWD1Mpcl0POPgz7DsW8aZ/q3r9R/p2rwljpTnZkatdfxJ9+E2VCU6tdQ876yAonmDOOjJ4ZUBNhMTE9l3EXzz/L4FQyJinCIAAyCWP8zFbjzT3BL51B0pPBLPXEnyuH5bYKmqi3MrMgzWFxRDNgXf/ArLWcDRjgkBZo50mcDrI9JgCpLUx4fKvQS3/Nz9YUuM9QAeSFaIvmZOEHkY8cB5rvmUJ72huEfLbLPUD+6hsfWPOb7ACNDhXmYcHT5BAERpjOcrtYSAFkRGwXCFD7FRABKIR13Ib/t2T0og09caBYF624oRKoc5Z0jYMBlwzKcRYHYh2EjqeHaahDu0yfKvFIwnzIbW3R
 qV8F6Tbc
 1MVbzgUe1Z7VwnAW3agcovh8TA2PXX9+voFktJ6bkhO3CY25qaL/r0kU9ZmWd88VlAVNjirKbbKPy/7OzeKFV04t9mWpGRQbg874bzW2BAAMgvUPM/uQx5DBFCZ6K1MPd79IvnVxuovTNFl8i5/S9yN6JtfUDkeA2hzA2O0Y8xyxBpwQ6y6fsw7PCX2fOZy8dgz1sAK5ZtBYOIFwjb5X+q+CnAn/cUTDF9CaDA96+iDShUbguGhUJDZ7qvREu0sVhLhMmKt/CNSICg42w7T+sq+B6I05wuv6+RNoAQXpkXDtGhITQP7alFPfO1/vL4U04O1n2t1ZuQlcGaXpNpSx8rRb44GCKA70Bw0E4/vbVqGeWfz/DFddjVj8wZw03htyDyEtK3dOADBC8DI5TzV/EWDBV6Z899YJ0eKrWzxe6iHx07T/ftnCykS7o4kCSOA5n0Dc1PM1tt16Avxz6mgveFPV/7q1L8XTpKJXG0qS7YhiluYBss93x7weTUinm4/9x8d16IpkwLWOx1Yg6bA3r7x2xFk+iPHhr96YchqUSZu2KzqEiNUpaFosgsaLuCw+H0cV/GVvwNl6F4hOgVTmZQTWQt2FcNA3DmzJrxDO8wnSd/+R+f9YoMpregz1E/gYxnFAETP2k5l5QxLdh52vjiezzPInOPDo0wOhz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 05:44:31PM -0800, Vishal Annapurve wrote:
> On Fri, Nov 21, 2025 at 5:02 AM Michael Roth <michael.roth@amd.com> wrote:
> >
> > >
> > > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > >
> > > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > > per 4KB while removing the max_order from post_populate() parameters, as done
> > > in Sean's sketch patch [1]?
> >
> > That's an option too, but SNP can make use of 2MB pages in the
> > post-populate callback so I don't want to shut the door on that option
> > just yet if it's not too much of a pain to work in. Given the guest BIOS
> > lives primarily in 1 or 2 of these 2MB regions the benefits might be
> > worthwhile, and SNP doesn't have a post-post-populate promotion path
> > like TDX (at least, not one that would help much for guest boot times)
> 
> Given the small initial payload size, do you really think optimizing
> for setting up huge page-aligned RMP entries is worthwhile?

Missed this reply earlier.

It could be, but would probably be worthwhile to do some performance
analysis before considering that so we can simplify in the meantime.

> The code becomes somewhat complex when trying to get this scenario
> working and IIUC it depends on userspace-passed initial payload
> regions aligning to the huge page size. What happens if userspace
> tries to trigger snp_launch_update() for two unaligned regions within
> the same huge page?

We'd need to gate the order that we pass to post-populate callback
according to each individual call. For 2MB pages we'd end up with
4K behavior. For 1GB pages, there's some potential of using 2MB
order for each region if gpa/dst/len are aligned, but without the
buddy-style 1G->2M-4K splitting stuff, we'd likely need to split
to 4K at some point and then the 2MB RMP entry would get PSMASH'd
to 4K anyway. But maybe the 1GB could remain intact for long enough
to get through a decent portion of OVMF boot before we end up
creating a mixed range... not sure.

But yes, this also seems like functionality that's premature to
prep for, so just locking it in at 4K is probably best for now.

-Mike

> 
> What Sean suggested earlier[1] seems relatively simpler to maintain.
> 
> [1] https://lore.kernel.org/kvm/aHEwT4X0RcfZzHlt@google.com/
> 
> >
> > Thanks,
> >
> > Mike

