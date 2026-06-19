Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60FEDCDB471
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED096B0088; Fri, 19 Jun 2026 08:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4A86B008A; Fri, 19 Jun 2026 08:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5606B008C; Fri, 19 Jun 2026 08:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE9546B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:27:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4783F1A03DE
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:27:19 +0000 (UTC)
X-FDA: 84896587398.12.BDBB39F
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011009.outbound.protection.outlook.com [52.101.62.9])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5F0451C0006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:27:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=glAaK5Vj;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781872036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VnEks0WNVj3t8BFpvim8TLSt2t8akQg5i36/S7HEWw=;
	b=ypdaIsWcg1wa1GXl+VhJNODaOfI/68VLV3yGmZrLeBTzSplGWKHRGn4kJbrB32cXdP6QLA
	R76Qpb1GgHOmbeLdlTdPWgJSejK9AEMNBl6TgXJnI0/TK4BcmMNGqQhkOJccfUl6U+/Nk3
	yfqk4Z8xQLcgjD+dfd8fcCe6sUly2Nk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=glAaK5Vj;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781872036;
	b=YKoVHOMiP5CARlJADftj8J6Y6Dqq7bvJ30OYq2kn/YRenXAY9iEGo4Erp+NG9nPp4L1kMM
	BdOZi/4YLZcs5bpabiH0x3eUyrYNM+g3mkZXDy6yIRsZbK2V0+puIb10wryK8ijLUPn+tC
	PhwaneDhKk1OMV8lxJNNcAhzh085N6U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C0YAMzJTwfht+cGCuK8Aeg9xzA7rdnIVaK9jUXSXNcE5mIQQklfWllEZS/LW6biahTg98ehNepSMfSUNC/+hQ93IixGdyjSus1ka35mqOThlTf68clo9zhqQ3yi954+UJmeYzVVqYYz8wVKNT7QsT5zWHshTt+Y6T0h2ZO5trvgkNSswoQvfPh2kw6peI2Xa9m9Q3KGQe4WVnhzC/TRUag0OG3o+1HF4oIEKjmXQk3+yft/bDFTA/TcrXnRNE3N3fVbkaLW/aLa7P1Ff2+02/mtapgK3xKwRUq02KkUMpZvH89IphIQooLg1UcI2Z18m9IKOAF832t//yv2BWz9r/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VnEks0WNVj3t8BFpvim8TLSt2t8akQg5i36/S7HEWw=;
 b=B3dPa5KMU/jd+uUrz2MCsXQivINrqkx9RQ8YK62Gkb2ZgV3UHHDjrQItrfy5+4UqWVm0P+2+M62wJsg+d0VNsE6pD81RyYF567LBblmvXZjNk+/u0E7aRdPaBhqdidI8N6OPS6ZSQszDD2a8+dQxD4XEbY+8F2kp/dLO0/kYTLQn5FmlV1T2ebVAGliGDKLQ0gPGryPZV0Uj/SA4xYPSKl6BErZ1KAHndsJKYpxJvYfCwfDnj9IxSUlgT4doVgoYtagsSKdYRrpWqaxi9Oax/btP7atkNbkUjTyOLkn2yVyqSPYb/+uBt3z5W40tO89O7oYNdeHeHKdDBIf6mcJxJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VnEks0WNVj3t8BFpvim8TLSt2t8akQg5i36/S7HEWw=;
 b=glAaK5Vjm4Z/S2J3cqUWQxbtpk2ixqEvNsYoETqK2B1WTA/VUeC4IMWt+YcI1jxCVY8PDpm6FUXmm8/XWxZjjg5WOwA+uo9QVFflHMWM2EoctDjnqDEHzhrFiQXRO1NOkY9iAqmeRwDqgtKSmIf05WM1aK6Myc6iBDKqn6Gjs6xyZ5iI35jx0d/LdKaNyYpAnrdAv+PczPnqWzFOgqk7k4pE7q4bL0qkyPYCMCTWwBMHO0x8R/tQ7nYaQt/eTJnWxk8umDomc1WJiFqvJydO8bH62mDmuQUaewIT1cD8ESR7JRBtpEc0l4hKM1wyPHXWPFM1IOC+8bK2+bsHAZvvLg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PPFD4454CAA9.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 12:27:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Fri, 19 Jun 2026
 12:27:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 08:27:11 -0400
Message-Id: <DJD0X2R79SVW.1XM7FV4REYCHS@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Brendan Jackman" <brendan.jackman@linux.dev>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
X-Mailer: aerc 0.21.0
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
 <DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
 <DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
In-Reply-To: <DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
X-ClientProxiedBy: MN2PR15CA0058.namprd15.prod.outlook.com
 (2603:10b6:208:237::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PPFD4454CAA9:EE_
X-MS-Office365-Filtering-Correlation-Id: 78a59467-074a-4f7f-898f-08decdfe16f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/71pK1cB8U4ombi5jpg7j9Qa4XEQm9IdG3HTFOvJb/yHqMO8BTG4+bjZnCmHHdayZJUSyNFVAV1FxvRWeTEFbdxQvccqK9IIxHNEdImiihy19SkdJ5Pj7RDhAxyczjUN2BDfwwi0p4R2Pd6/X/zMQxInFFVMJ3GGzTC0fl6GEExtPiLwA/UhfJgR9g8/hKSsfrIwUT3cO02UclttsUrDhNxn488wTejxPbOICguKj9AYlttL8iWr6qz/JqTe8anLa/9iJsOLY8bhXoAE6gCippC7ITAHgxGJnMTG2X7kAqChbkqw8tf2yrAL3F4yUGg2nKmmQqs0cciMxVYaXgwjs8n2B02Y+hO7fHofAe2O4enOLXnoYzsDfZbZRRUnxZayZ/S3eX6JR0RY82xeJGIWMJyCaGvtdANK9DaMv6uw0XHBrlJ25CeXL+/dHwAzvYA73k1gNiRLebbBS34CZP3tRK897DaFfBL0z++yHuVs2ZizsFiZTp24Ek/iL9B7JOINnP5KiRs7S6Q06+PRsqgfLsWJdqZ6RWPGwEmRIwdV8QGcRObBDBcR3GiMoQTP5z2vgtt40iSZeHl/wqvOan8qZpH/5celq+pPkh8r+4DBhmqoAyQd7Dzhs0Fp6Dir0sC6JJgTi65y414x7XPrIW556w6Sm0yDi8Qy6D9R/Fx0+Cc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emRXT3V5Mmt2eGhiSnJ6TjkwaTgzTEo5TnVKYm5kYkZGWCtXczA5bkp0Sy90?=
 =?utf-8?B?NFM1blIxbDBHVnc0SUdsMWh5c2hLT29iMmpRYUxDT25rOHgwaWJxUHExSXQr?=
 =?utf-8?B?aXI0Zy9QMVZvRTljb3NRVHAzQVpXZE45UkNYN2F3VXVNdk1oWDdQWlJrMFJW?=
 =?utf-8?B?REtOWmEvUnplM3FnMFVXVU42bWF3dXUxelVGSmZrTWdEN2dRQXNrdDl6SUFQ?=
 =?utf-8?B?SzQwcWNkUGFBcG9oOVg3cnc5T09WTm1DNkNRWWZZUkVlVyswaHlCakFRWkp4?=
 =?utf-8?B?Vzl3MzB3Z3dUYm4wazI1cDlscDVGS1k3OThJdHlaV2JBOHNEQkpHM1FjcnFV?=
 =?utf-8?B?eXZJUVlhUi9GM1ZDWS96QVFFa2xIM1hTM053REJpMktNOFpJWjJyNHg2dndi?=
 =?utf-8?B?MDkwa09ZMTBBaEZCMnR2S05YRUUvSE5TQThvbmRvSk5lanAzSTM3MDRwSE9n?=
 =?utf-8?B?OFlzSzFySVRsSXpCYzBZUGd4aHB3RnJIUjV3RThrZDVJa3RFQ3A0N3BFZ2ZM?=
 =?utf-8?B?QUVWRk96ZldnQXAxQ0lOY2R0ZVZoaEJlc1A0YWw1UVdBNWw0Vlo3REZWRGwv?=
 =?utf-8?B?SE9zWWNGNW12T3YxbTlURjNVQ1c1b1dHTHBHeDNXVlNpdDQ4dXR5RWhWMnda?=
 =?utf-8?B?d2hSKzREOU5BUUs5YkhKZW5rMHZlcjhRbzRYSEtmdjdBc3Y5ZE9NdFdNNUly?=
 =?utf-8?B?VzBRazlMa3B2WjczeW0zTHF0cWp1cmRhSWtKV05XbEZQbXpYWGxINXRBWFZT?=
 =?utf-8?B?Nzg4RVE5OU10WXozQUVYTkNwMENlNWl2RnpjSmtobmhRKzUxUGNoa0Z6TUtQ?=
 =?utf-8?B?R1RLSWltdWtLWXllWXRyMDlSS2dxdmhhcVpBTXBoZW1CaHp6VUYzSml0dDVE?=
 =?utf-8?B?TGQ3NTRzWGtWSFdibjBMRG15N24ydzdGSS9iRGhPOHRQb1I5dkNXbmEzazB6?=
 =?utf-8?B?RHhhVGlJcUFUbUJRTlByK3loZEVicWhiRUxnQjRRNi9LeG9XRHJkeHh1LzlJ?=
 =?utf-8?B?V053NEsvYm1qZ3VDbnZNRWt3ZWdWeC9YU001MENOM2pReGl5eXVKT1ZXTTRZ?=
 =?utf-8?B?UTBFS24xSUJvSjd6bFRCbDhWQ2hCSXJRNU52M0FUQ2tjdlNBeXVYcDhWZVlE?=
 =?utf-8?B?WVFiTytscEJmN0U5T21YaHdvNGt1bHVxeE1SK093cVMvNDZGdHhESW1nQnM2?=
 =?utf-8?B?ZW5KYjJNRkZ1N0JsMDFreXBoRGlmMStUdEw1YlVDUlRUWXBrSW1wazNQZkRF?=
 =?utf-8?B?a1dVS0REVEN4aU4rZENCUlIzMURGWTNvM0tMNzZ4alN5TExOTkVZNWk2NFVN?=
 =?utf-8?B?cDU4NlB4THJncnJYeGZaTTlpVzhmVHQwQ3kwNnNTU2FhRUVHK3BSa1BRNkJr?=
 =?utf-8?B?czNOamZIRlBqdUtWS1lSSlpkVTY5YXRoeUJvaHVyMHcraVpCaTYxZjBJb2My?=
 =?utf-8?B?UUV3ZUF2alJzQkN0d1d0RjlqUFNhdWp4NmZQaFBNV2NSYmtPWjRFNU1FWXdr?=
 =?utf-8?B?cSs0S0NDTXI0QnRmTjVNSzd1UmRweDdwN2JXQWxwNU1aWU00TUd3SDA0QzRh?=
 =?utf-8?B?OTBjWlV0R2Yxb202ZkFqUUZpL20xaVlnQUYrY3BGV2ZnZW9rZzhsQXIyVnZS?=
 =?utf-8?B?Qm02QXFtOENYRzlJN0U2TEMvYnRBUWlnV3FjZVAzTGp0THpmUDFHc0pKYVBW?=
 =?utf-8?B?SVNLaGRaWCtOQU01Y0VsTFcyUjk2NERwRTNLT2MzVzZWV3ZxaWlvaGdoOTdK?=
 =?utf-8?B?K3Zrb0FsejhPSzdTcVQ4cmI5V1NKUjlLMis5RjAzMzRvbzR4T3ZQVU1tZkZ6?=
 =?utf-8?B?ZnJZYTdqMVlLSGZUcEFMcHloSFZJcVZSRy92NjBlalROQ1lLZTd5VG4vdzls?=
 =?utf-8?B?TXUrVG55aGxKbkRsVVVRenIwWmhqOWF3WlozSW1oeEJ6S3JVS2dYaFpaV29r?=
 =?utf-8?B?RnRubGRvSEZkZlpJdks0VDhEVHpyaWo1cnFWMWozK25jVkJST05QWVorRXB0?=
 =?utf-8?B?bzVoYUFpTFkxOHB4eWY3ZVM2bHc3T2RnMko4QzhGUmFweHhwbTBMYjVXUS9T?=
 =?utf-8?B?WFpJVVpxQ21xcHBKRHM0M0tRdk8vUTg3OXFHd2drUWN0VFlpaEUzV1ErU2NW?=
 =?utf-8?B?dFE3VE8xcE1mMkJxUUdQcjUzSkVlb1E0VnEzbmZXRjEwajgvYnQxaTA2VkNT?=
 =?utf-8?B?NGVYZGZ1RmZlTC9JM0ZpUFFHYUdVc05NbDZpZ2I1QmkvU1JTRXZzWkFiNVBv?=
 =?utf-8?B?SCswck5wRGpmZEZkY2dCdm1XUWIvT2RMYXNJQ0RZZUd2K3VrUU0wbUZDN2ph?=
 =?utf-8?Q?riKZxFcypFwhd5BTJU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a59467-074a-4f7f-898f-08decdfe16f9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 12:27:12.5435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YL0U7ZT5X5SdsSA7I5JYmgvcj0TurRtQuj+QOzjcXGfEX8GyHv+qiLcM7aZAW6KX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFD4454CAA9
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F0451C0006
X-Rspam-User: 
X-Stat-Signature: f1z44jo6kr7jhawxzbjyiy1bjubr88uz
X-HE-Tag: 1781872036-667701
X-HE-Meta: U2FsdGVkX19vtGEYsxGavdpJVnfeIUEQz7knLqty6K1M6zDNJ5lIZhLWL9XxwIPFFj/e8qyc5r9/8oT7qxSBsrQWUbwyYAii+UR+y8F+kreRPSuzjobwxhhYWG8XiQXnf2NkvbdY9wo2zocAzXaLGfDGeFYY4kaG30W0iqflcFvc2/8C3cMNMo7RsqVul7S4z8tECadUgNb6ksxNA0KY4olT/ExnJUsx2bAPJrMkDTA36nFDdXUVfWkCPpNoyPIGBAyahRU/hfaV3T/ZJs3/ML5qrD2LX0kc6Ni9psWIk1865+5sLf93DtXCwsIv5PhDWpLMRSz4YeucupoziGKcr+rsTV/whPqG5gox7/URyQ/6/m88AQDgG4Q7gk4CxftzLyyFnT3W9KUWvVpVwy+y1AgMKNcxHlcskO2fpFvswBwQzyeMBeOVVFXBsuCA6X5QvbQxMXlqIxboHn3kYRCaiD353exVP4Bjyflh2dB/TY++/ZNscZ+bwao11u4R1Go88S6miYwhv23IlbMd66bW2hMrkCzQU9SFjkSGm4EiewLiEPKpes4owvAd5RVU8hfds6o7ajJvmEYr3gAcbX6pcEXw9hette5+isclH0iIXTAXbzguftRctDXsT72binq+YKodBFrIxwSiFTA/bC+RueKVH4gE4kkc47TDm3aVQ0/nA5S0/lJv9pEKzXMuzU5qaUpeJ+Ev0Q1KF5aaGdA6rwmWOZOIRqfNAWEmnOEq/xYNgiuLlINwA3sS6aSQUhgmCcsTip0blMYbkfCa6JTBIntjm8i7N5yUSILnsHV2dTa7Ll7l18n4bDCZRLJ+r1aMucyDsH2gb9/QRj08DWBCTInJI/tkiT63bR8YojHgHGoPwaZmZlqnlr9OhCHAX63emkJWqePiXXO1BxfzAXUAZ8D5bSty6hrvjdmyjuZ438ETCpnOvosiSpEumm2zVM8O3DAy2m86iFoydIAC2hN
 HaKYT2N+
 ax+96nXNzQwS5+zpm89+Hna/0PcSkc56MbueJRiSbV6TjyeUrq8vFmcDEmHvDVCns/32WTmohphsuKbxem1gp4DYdbh+vdghc+QtR8mSSkO6sYXLPPE4FiHImvoOI796H6xQuaVJeDufDutr4/krX+UjPGv5hudVCjmymBH5KUKyslU9mTmP/h/kHych7CLr7zUsz/5pwHH8VbhH6hRCjD0cZ/t14PhfimJuaIlxPfvPiROSlXIJq/GAXK1EzlMattieGfeW56ro/6vJi+Qf1Tbe3weB1cNr23QW2WkCRNUGhXcRrMbfOdmN1tiyJFnMcY8YrSnmYugQnQXJEVIkuz/wx525jHYBIgRFzoTIX2FQvkrhfqJ3TvR+DUTxxq6nNebN47H9SlNEt2E2AY0vl3SR/0inhTKphZCPzf45Nv87zcEc+yVVis4nApyY+7aeXFjTfq1TU6kAmSVZtHD88AKe3vfluarCknDjpkU+Ott7UPhYZG/WiU0dM5PlXF0JhswZFkMsRIKgoZzZAIBQjbfzrHL634TbTaowbRFii2otTI/LAZ2csBSCti8jw5QSRByADbQokWSkRcm095i76ExjUhNgUlQPZZGrWhQzuPg36vds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 19, 2026 at 7:53 AM EDT, Brendan Jackman wrote:
> On Mon Jun 15, 2026 at 10:59 AM UTC, Brendan Jackman wrote: > On Mon Jun =
15, 2026 at 10:54 AM UTC, Brendan Jackman wrote:
>>
>>>
>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>> ---
>>> Changes in v2:
>>> - Updated alloc_flags_nofragment() too.
>>> - Link to v1: https://lore.kernel.org/r/20260612-gfp-pessimisation-v1-1=
-936eb04202e7@google.com
>>
>> Sigh, maybe one day I'll send a patch without immediately following up
>> with a "oops, I forgot to ...". But today is not that day.
>>
>> Forgot to add these tags from the v1:
>>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Gregory Price <gourry@gourry.net>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>>
>> Thanks everyone for the prompt reviews.
>
> Hi Andrew,
>
> This one didn't make it into any of the latest mm-* branches, is
> anything blocked here?

It is in the quiet period, no patch will be picked up until -rc1 is
out. If yours is not picked up then, feel free to resend it.

--=20
Best Regards,
Yan, Zi


