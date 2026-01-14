Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32268D31A06
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7908E6B008A; Tue, 13 Jan 2026 21:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DE56B008C; Tue, 13 Jan 2026 21:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6165A6B0092; Tue, 13 Jan 2026 21:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 533276B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:49:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2C971A0347
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:49:29 +0000 (UTC)
X-FDA: 84329038458.11.F98831F
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010034.outbound.protection.outlook.com [52.101.46.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1464A100004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:49:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RWI7BkNJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768358967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ubkq18txsBSruBc5HujTx6i26zxVEhMR/r+wAwrvZa4=;
	b=gTC4qbj7jAaLLSrWU2j82+MKG8ROdTHjLv98HZq9FUxocy8b1MokjOkn3itYed7bx/mlyT
	iAwHr4ePNaKiOgrFEzbzc+mSthmJW/VIVGAaqCwCefaoYG7UWB7Td3DcBOJDY2xTOz0HG/
	TouUS/44e1RYv5L+40lKsGFUlx52Xjo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RWI7BkNJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768358967; a=rsa-sha256;
	cv=pass;
	b=FzaC9B/64nfiM5ki4QBDEISFe6VfJP5F31vEAhqakM2wpSt3dW5LqluQ2rpVcaWqGgOdGo
	DkhL8agg8CK4gqf1vQVuS1kLWqb26lJMnMa820HpOwCI/wt/0gQ1vAG/eS73U5jcr4TmEe
	InwpupTMLUsXhlIh1PiOw8BHwhGLXSg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZMnHSA6VRllJnQgohYrSPSHpbKc+1RtLyStB967UYuUwb50qCLSZj2Dx6RT89JDyKeI4Xtbm9bRnvDKmPri30NA7UDf1FnYqjjeweFyNZSg6HFa59F1yGo48o1J47yRg5/PiCn3KXIkjTobI3t82EE7Q9kr0nYObdneI80JBPzfT9HcpPDKmMVl1S8SFJjoqrDL54fW0dCdry2OydvRmGxOSa/Lsi8m3Kz8KtzBsO3hC7BACMww9IRDH26QItlyVR38eclk2h4oEi/hTfRwnawtg3rJnNnjfFEzvEfeu4WnHs3vaUYMbbf9SDT91kTEwmJOqy5M6glbliPpLPbh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ubkq18txsBSruBc5HujTx6i26zxVEhMR/r+wAwrvZa4=;
 b=tTHCZ5Ui4DzQ9n+IRieoK5ns49zkIiCGg1XbssTnB4xrF5r3w9tLp8uD43xiqR+r7refVFHm1BAJg1Ub5Y7Jxfdx3A08aVXugue07hZMVVpmIDjMYgtU21vOZxzDYPZc9B6FPwybTiYmS9ZgEAJBzgCuo3g3mwO8PEzgkBgNjA1ULbwHhAWN63kLj5X2ysjagClvFU0ITzeGZ/gyOK5CCnGrfXKfxL/b12pQ6ALZy+wGXnrQkjINnjFRTpPEVMYaLKPI3pW4qrrD+AuUSjj6jeU5Ysbv1NRTxEgeP7U3YD9Si2kQaForqgVJbAiQ8jmFbKitzwKdPsh+SRAOv/oaqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubkq18txsBSruBc5HujTx6i26zxVEhMR/r+wAwrvZa4=;
 b=RWI7BkNJ+SCreiAOjyq8LelFHtnnq3paljDu49NYYEJIOBh9er9ZEsNCTLN4zUyXRwDJQNK/F6wc9bm313caDxdHvjjzQ4eYPmrWGErGuF5kXu8hDnYPAXpuWKrQo+UR9A6tda0yJXSvBkp8r4ZHkV/BvfC+Q4sid5vOZYx9Pk+QaOffjbb4FulXBu33RKmG/bolTK5OtL9rluEpvBhjtS9LBh2jU+qbOqVyyhq0pq2qV/OnaIJESwP7j4GDcXPkDFWWIz5x3MA/Uf9SAcSxHHSc1kjOpJnR/0NyIwtHeCAIQ8z/NNg2sIEwtY2baca/i9/tPnsbqV/Rt07KuCKfeA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6930.namprd12.prod.outlook.com (2603:10b6:806:262::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.4; Wed, 14 Jan 2026 02:49:22 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 02:49:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org,
 willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
Subject: Re: [PATCH v13 mm-new 05/16] khugepaged: introduce is_mthp_order
 helper
Date: Tue, 13 Jan 2026 21:49:19 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <8676CDC6-02E7-4676-A619-C9E776751C13@nvidia.com>
In-Reply-To: <CAA1CXcC9YsOKbsvyZpgOwLdE938VBcPUrLyF97uN024uM2uiPA@mail.gmail.com>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-6-npache@redhat.com>
 <CCE3840A-A46A-4F33-8412-FC55161A6D6C@nvidia.com>
 <CAA1CXcC9YsOKbsvyZpgOwLdE938VBcPUrLyF97uN024uM2uiPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:208:52c::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6930:EE_
X-MS-Office365-Filtering-Correlation-Id: a44bd720-0410-4454-666e-08de5317858b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWlXMW1jbkYybXdVUnFjYlhSU3ViZ0g3bVZubE9CZUJOQTBNLzRVT25BcCtZ?=
 =?utf-8?B?L1lhWDhLbDZJcHEwZFVIUWl6WkxhUytDR3FMUC83RjdPaGxkQzlwR2dlNmE4?=
 =?utf-8?B?aXRMSmdzc21URUw0dTRDc3AwY2szekhOM0NIenNJYXVsWWorVWhSOHhKOHRM?=
 =?utf-8?B?UjlUZEpNYzBuSDlNUmZvaSs5aEt6T1NhSHlSM29OYStLM3IvVW1OaVZma2Q1?=
 =?utf-8?B?WGxST2QzaFAyUENjcHF2OWtORWUyM1diTHlDeEgwVmh6bVNLSzkzRk5Yckts?=
 =?utf-8?B?U0gxUE12RExYdEZFUDkrbVlDSUN0d1l0MDJRdFl6NEV2SCtVMTFZRHNNUE40?=
 =?utf-8?B?U0FjUGp4Y3g5dVdvVFh3WlBYS0phVU14dXd5UzJIUW9vblRUTnlmN1VSNXNt?=
 =?utf-8?B?b2FLNHlHd2tpeDlpRURNd2p5dEY3TngzODlzY1prb2hhWGhyaUN4YVI0R3Zn?=
 =?utf-8?B?cXRFbWs4dmNCN1RqZGNsNDEzdkZCL2ZNVkdVQWtLMjROeDNNZ2tWeU9uZExT?=
 =?utf-8?B?RlJFY3JlTVEyME1uNW1vbE03a1dNVnFiVHNkRmpQZjJGYWZCWTN3SDJreitx?=
 =?utf-8?B?UGd2VTRFYTJSRjBKaTdGRUdPYUhNRE9jNzczUkJiWFpEWTRVT1dFZk1GakV2?=
 =?utf-8?B?U3IvS2ZmcDIrVW5iZ3ZoYXhISThiU2R6U2F5T00rRlg2NEZhRUR3MkRkNU05?=
 =?utf-8?B?TU5PaE5MK3A0bDBzd0creW1ZYjl4Y2lQVXNYa1RQKzR1cjN5d0MxMlo0MWxx?=
 =?utf-8?B?cHREWjJhQ2dRbVdLR3JXK1NMbmNMaFVpZXVETDlzYktLMmtQTUpMRURyZ0Zp?=
 =?utf-8?B?b1RLYit2WTVIQVBsVHM2dnVjUWxuRHFCT3lqYlBuWllEVjlraCt1ZmVpZzE3?=
 =?utf-8?B?bjV6TUhXV1RJREN0L29neTRuSWw3S0ZNOGRiTmRKLzV3NEZaT2Uva1FkNkFp?=
 =?utf-8?B?cEp1SFpLWEpubjB6TXJ6dVdDMFdkTXg2aEg0NmF3L3V4RjVJSWJuWUpNQWVQ?=
 =?utf-8?B?TlIxQnVnT3FuR29iS3hsWWRLdHpxMUtzRUNqZTltVklLM3RWUzhOcUVtQU1B?=
 =?utf-8?B?eTdMUG8zZk1IZkRIanVNZ09ONDBqVlR5alNEb1Y2bHBXT2Izd29pajlEVkdp?=
 =?utf-8?B?aDNJMHBBcWFRc0xkeGJPS296bDRqbnFzeG5KTmRkR09pYWo0OCttSCs3MGdL?=
 =?utf-8?B?MHRMaGFKcVl3VlQ5OXlIR3ZEZGhBSGV0RUFlRXo2VWVTejdJdFlXRE9aOXRH?=
 =?utf-8?B?cHVvakpOZnlRMXJDazNpdXdEaXRPTVk5SXVSdzgvSWZrczJTRnVvaTg5MThq?=
 =?utf-8?B?UnJhNG14czFkY3VVNC84a2trRWF5Q2lQVHVTTm9rUWdCRkFhZzBCZG5kNDdv?=
 =?utf-8?B?QWpRcENnYXRCMW81emtCYzR2NnNKZU5XSFdJaXNOK210cXJvempvMFJrcm9C?=
 =?utf-8?B?VkFqdTB2aXlGVWhWLzFydDBsTE96RFl4U1NWa0hydHQ5K1AwUmFxTHF3NTM4?=
 =?utf-8?B?TWJOYmNwTjVlV0RycFozSGszRlF5bU5ObXphejhtb01MSHl6MkNyN2FsVlFt?=
 =?utf-8?B?TXBHdVdtVW83RHpDeldpT2dlWUJmNFpUbjhrWlVVVEVnY2UyVUhrYUpFdU9W?=
 =?utf-8?B?WDJpMkV0S3ZxcGhYdTJwUjdnNVZwUExKSC9xWXlEMHV3dFROVnlaUEtWbG01?=
 =?utf-8?B?S3ZZZDRNZTlaQ3lZWjEvOWZ3bHh0cnlVa2N0NHFBSE9aY3p3SlBXVzQ3Qnlw?=
 =?utf-8?B?bVZLcWdpbTd4K3h3dUhQNysyZFFMcHhzMXM2WnJEYWNUYXdKa2R0eFZJVWhI?=
 =?utf-8?B?ZTdwaUZmVkcrZFdwZm90WGorVUFqU2pTZVlHbTZ6UGZvNDdRbks0b0dtU01x?=
 =?utf-8?B?SzJsbUhxNnRYVmFsa2lia3BWR3BFSStxYkxrS2k5eU1yR1FwcmRNN09VMUZl?=
 =?utf-8?Q?sIL07dsaq0x08rZtC4q9lRCJ1hjJy3+1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnpWWUZQWEc3cmptOHpZVmxZSWR0UzhBN3NRRTFIcC9yenErZk9lNnFaRGUv?=
 =?utf-8?B?UitXeW5kTkk2TFUvSGc4SEdML1oxeUt5QjV1OGIzY08vVHdXem1IYXBOdWhx?=
 =?utf-8?B?S09IUGFIalFDSEdiNDhXcXVNN1VpTFQyKytOcU1jN3hWYU16MEhTaUdudU92?=
 =?utf-8?B?Z3A5OGtaOWhwRmlKdkZtaUI1cVRsb2ljUjFzbm5BemRCamtjUDRDdzNZdURx?=
 =?utf-8?B?U3RIMlZSLzFnSU9iNkVyVDZMMTJvT3JQVXUzeDFZL0FncUlKZDgwd2E5a0xR?=
 =?utf-8?B?MURXbzl5Z2ZvSlVLRDNCakZPeHpheG1OK20reDdxTURpU0xHdGlaak45eUhK?=
 =?utf-8?B?SUVocjUyYTRjb2swYVlHT3J6RWtpNUNHcFh1WkFiY1oyajlTck1IVVg3TzlY?=
 =?utf-8?B?RElQSWV1aWhLN0VMbXJNZ2NpOWcrTE5yRGRLM0RFT0lnQ0pIR2txU3k5Z2J6?=
 =?utf-8?B?N3g2Q3NVVXhIOTl2MC9QbEJaaTI4cWpkRDVZcEFyMC93azYvSm5QaUVaUDFa?=
 =?utf-8?B?NkJ6MTVuRy90N3FLSzZxeEJIMUc1Sk5ZMlZXZkU0UFdzNXJES0UzME9SZXFI?=
 =?utf-8?B?d25lY3Q3cHdrb2FDU0liZ2NGZU93dHI4cVEzSFBkY0UzRHRiTUhyUFl1WXYv?=
 =?utf-8?B?dHBQN09sOStJdGMreW9kMjBGeWkvckFCVlVwSndPVW1lRXRIclQvakRhVTRh?=
 =?utf-8?B?Z2l5ZGw5eVpCc3BoRUFLVVg4VE51WlYrWUNjOFZIR2Z5Rk9aSUxqY0pYZ1lV?=
 =?utf-8?B?bWxoV3J1ZnBYMWNqb0hPRHVZMzhUd3BJaksvNzFOZFBiUHF2QW1aaVIyaFNu?=
 =?utf-8?B?WXZwL0NnZ2NyVTJPMEllbVh1b1JrUUxOTzdDck8wN1BqUUdPaFVlZnNFc3VV?=
 =?utf-8?B?T2xNcFRMK0ZtSUFCV1FhU3J5TWRoUVBYMDdqTWVTdDBwR2I0RURUNG9IT3o4?=
 =?utf-8?B?RzhzWEU0UG1BNmZSejFkSXRKQUJXTmNLUUprM3luWVBTb2RUREs0Z3BRR3dP?=
 =?utf-8?B?aU00UmNlcm5yNnB6MjIvVnRFN1FXWUpCUXZrMWxzalhaODdXeUNQdEd0bVdv?=
 =?utf-8?B?VEhYSTZkdXJVTm85cXJVaFVvSGN5SXlvTzFZZnVTUkd0WjJBdjV0Q1U0Q3k3?=
 =?utf-8?B?MFFFM0t6bVpnSncwRG5KN2FySWMzTU9MQmRJRnYrZmlTS2lqSmtydFpaaTBY?=
 =?utf-8?B?ci9tblNpeEgyZ0xtdGFYajZ6d2FLemRBeG5odFNweWVZSmt0REcyR1Njd0dx?=
 =?utf-8?B?ekdCZkcvUEtRTGN3b25HcUR6WkxrUXdWV2NCVjJ3cUNBaVlMYzg3OHhjZTZZ?=
 =?utf-8?B?Mk5QbXBLZDMrbU9YNnM4a3dadzVtaldGdllnc0ZtUGVFTmFOSTY2RzlkQ1RV?=
 =?utf-8?B?OFd6ODFrejBGQlRVaWxzK0h1YXQ0UFhjOTNpSmNndFVwamhsMjR1R1hyaisy?=
 =?utf-8?B?OGIvQzFlMEZ5YW9jWVNYYmwvK2VEalRFcExrV0RBRGtRM2tVL0ZjRlpUT3ky?=
 =?utf-8?B?d1l3YmdoS241NHI4czFyOGQvaDBXYngrVDlsOXlVRnBxN3FWc2VSaEhwNWRh?=
 =?utf-8?B?aGVESHlkMmhQY1dsOStrdE9JRTBsdUxUT2RvWi9xa3gzZzNPNzVuMFFyZ0JH?=
 =?utf-8?B?M2ZzWDJZLy9UYjRmbVQwbUNuUUlvZkdvMEpiTXp0OHN0VXduY05CY0xXaXhR?=
 =?utf-8?B?Ymo5SitBZzRrazNoS3ZKRnoyV3VhbkxMcHpSQmNWLzZuTnpLM1BZNmRBSWgv?=
 =?utf-8?B?RG1ZcjlVeTdYNUNGQzNiUXVTeng4N1BuSERHVTNMZWNYeHQvb1BxQkZ1cTFD?=
 =?utf-8?B?akh6WC9TekI2amtvcytqNzVnVWNtaXh3YVZDamQzOTZiOFNOV3lCS011TlVy?=
 =?utf-8?B?MWMyM3Z2QVVJaDl5ZEEvT3hEV1lPY0RFc0FSSmlxSUozY043MDZSMkxtZ2RR?=
 =?utf-8?B?b1EzRnE3ZjVMVk5ZNEhqNzZiVlNLWFkwRFJWMEFzbkZJOTFlUXFrVWtkWjdq?=
 =?utf-8?B?Sk03WW8yMmJzU3JvUTc0SlZLUnRhMkZ0VHluTFVWWkZKaVNjM1JjUjBWM3BT?=
 =?utf-8?B?d3l5T3o0SXA3aWRjTzlUSEg5eEl3Nkl3S0F2b2FYVjNaaEV0SExXL0FNdGEx?=
 =?utf-8?B?RjQ5aWs5Z0VNeGxrRzExam13VUprNjVzenBNL0ZiWkt2L3NjKzNwZ21JTHVW?=
 =?utf-8?B?KytMYzF5NXpKenZ6YWdraDZiQy9ocVlVWjdpWjhsOXRRWElYa3J1cGFQbEVC?=
 =?utf-8?B?cXEzb3BTQXlLakhaRkNsZ1l3bVA5VFZDa2czUXlBNWJwZG8yRU5sR2pPbUNU?=
 =?utf-8?Q?ZSOS87cLppayx+jaWF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a44bd720-0410-4454-666e-08de5317858b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 02:49:22.4284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWMJjSkRBkb2+z2Fybx/g8XIG3+8z7VzQ0gRX+cGex5sOFm5NHIjAgeP8ndlxJcY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6930
X-Rspam-User: 
X-Stat-Signature: d3u3xw6ex3mqw8ao1hxrfbjx3rjeh5yr
X-Rspamd-Queue-Id: 1464A100004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768358966-985443
X-HE-Meta: U2FsdGVkX1+wtxwHbfCZK94XP8A6Aju728yOKS/1+MLpEHbVdKngndUpWY+UNGQdH70730Lc7gpdjLTixa0UW2SudMRLre3lwSbrFo2xoME4YbsuUab9v8YxWdUDcCwNKy4hl2InndZdv1/1plWzIvEW9dqmwqOITVYBC7O/vY5q/bXIQpQZItyvlW6hT8qX+UjbHw39EDiS5DnqGoY8oLzJRyVWF8VBT76G4Xt+9FFaZnMcH1wdd6hFMMK9RPCYqJI9XJmU1IMZFvtib99NqUhisYW4cwD3gqVIoGB1QpMEq3LS1kd6409dzD+Xx4uE8orFVwjvJ3+hju3KTCXGEO+j2Oq1GdecLgCcD0DTyZcAnjjTEogJsjOFrrmxcSLTQ8f3hhhOiQMc/n36/AOGOqGHhe8LDmuzk8NpGAMqp+nXqwSIRy33hESlBjuHJ0IWXTFk0alTiEubOyK1zi/IpQoW/dee6WazI7BmY+9MI9pEWwJ9WRnEUIeXkH2PHeJMxi5+h8owUw5CoNtl0DLpLN+aeA9jlOVEPmT9LowfP0vv/s6fSB4EtPEdniL1Ftz/73GPcDO3KTh/X38Ofs6E7LYGYQUaswiOggz3WwUBIfEzx6qmDdzrxiKD3SDcKPa6BV1Tfvp3CRoNRjSQdCQxZRA8QD6LUwhMHI3l2H36RtpASLU9IDJRqATksearRiP/t1Hj3P16IwBXS4G/Db6zM9Y2vzfK01bu2rshY305UgPglpwBfaWIvcK7fRSL2oNyGX3HGWIJme7ujvlJOjPY9QNIVGph866Dhq4dsb6zV7guoj1AS0umttIIxiyYyS5yiMlpYyusatNEB9K6avIiUjkshCkz5AZhIoGyAu0jdPAd8/jo9nxpDAAOOIoFMSI9LccxPPgpAdOZ3RDJkrZ9pRaiqYPvmX8cOYPMcSX7DyWo64ScFrZ7VS2tK+wTANM6u7SSMQsV0/6x/kLO1+V
 lFycpGOv
 xWCF5IV21Wzy/+98HzWZDEc20iIVn2at1cC4W6vLAQjs+jn2G8nh8F8IMADUTC+mFPguz+DP/o5tP3myfMRtIWhfEIAwIN+b7HzPGn0LLsbjgaD8SmS10g4aQw/YtJtoeDR/qtBeunPSS76cMRD1K7ma23DoNyA4BvvKfGTv38Tn2SkyF+rm87zlM4vPDxdWSk2z/6Sf3NRGSK9i9iohJtpEqi+82JbswFKtjJlOCyzIF1i71TLU2iNUWtfQhzUbf09Ph6uwzvwrKBhayBqE2eCSMzRYf8ouHWehkuqVY/+GVtnhqUodwRYsnu8TmAwm68pnAma/xW+lslmLLhIZfBhGOw/TuK9WvpXG6HjLDKnu2R0Pq3mN7w4tSIk+G9TWGbhBYpU/Zd4WB8IcBAkgXDiGFp4mZ0KkgeiB+jbd1vOzwBU65BJpU3cTL4/RxyL5J7IZKba+x+TfkDC5FoL07Ae7Vw8986fdL7nQT5+FryyRYs1BixW8xQamdaxR4s+sbtmi+D1PSDnmFyeb4JUdiBaevwAHUYJDklWiTDI+gpjLUSgY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Jan 2026, at 21:38, Nico Pache wrote:

> On Tue, Dec 2, 2025 at 8:13 PM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 1 Dec 2025, at 12:46, Nico Pache wrote:
>>
>>> In order to add mTHP support, we will often be checking if a given order
>>> is a mTHP or PMD order. Lets create a simple helper function to keep the
>>> code clean and readable.
>>>
>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>  mm/khugepaged.c | 9 +++++++--
>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 8599c7fa112e..9c041141b2e3 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -338,6 +338,11 @@ static bool pte_none_or_zero(pte_t pte)
>>>       return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
>>>  }
>>>
>>> +static bool is_mthp_order(unsigned int order)
>>> +{
>>> +     return order != HPAGE_PMD_ORDER;
>>> +}
>>> +
>>
>> The code at the bottom of __folio_split() in mm/huge_memory.c
>> can use this helper.
>>
>> The code in deferred_split_folio() uses folio_test_pmd_mappable()
>> instead of order == HPAGE_PMD_ORDER, but the code can be changed
>> to use the helper.
>
> static inline bool folio_test_pmd_mappable(struct folio *folio)
> {
> return folio_order(folio) >= HPAGE_PMD_ORDER;
> }
>
> Should we make the is_mthp_order() check all orders that are less than
> HPAGE_PMD_ORDER.
>
> ie)
>
> +static bool is_mthp_order(unsigned int order)
> +{
> +     return order < HPAGE_PMD_ORDER;
> }
>
> This way it's true to its mTHP nature being smaller than the PMD.

I am not sure. It really depends on in the future whether we call
> 9 order (can be mapped by multiple PMDs) large folio mTHP or not.
My current feeling is that THP is a legacy name for PMD THP and
any other large folios are mTHP. So your current definition of
is_mthp_order() looks right to me. This is just my feeling and
I am open to other opinions.

folio_test_pmd_mappable() is different, since as long as a folio's
order is greater than HPAGE_PMD_ORDER, it indeed can be mapped
by PMDs.

--
Best Regards,
Yan, Zi

