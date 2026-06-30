Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF8BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451A46B00A9; Mon, 29 Jun 2026 21:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBC86B00B1; Mon, 29 Jun 2026 21:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2572D6B00B4; Mon, 29 Jun 2026 21:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB2C46B00A9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:58:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73E4F16622B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:58:58 +0000 (UTC)
X-FDA: 84934920756.28.6CC266F
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8373B140003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:58:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KUgnU7Dh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782784735;
	b=dnzcQ2HNkVSPN3loXQtlbcVro9J3VtaYxY5ZalJxB8uog+O5gAsvfn5ItMJKTcrKH0zEss
	g0HsYl93q9MfdBRrMDleQDcGV5zqaLDIbdGexq0Ay3iwSBqaxt0GrhD/l1CvV0D9xGB3Pn
	fzLg5gSH//GpjYbqiVS1WmqKbvnsrWM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgOzn7wscYWbRcMg1eufbF3m0DIayiO5M34zrNzFKDU=;
	b=J1TMpS3nIUu2AZsNwPkRSVipwKOTZ4I/xohXvhs/ZLloDjJdw6XWAAnmqONj2UM6lHAwGc
	quwNc62Kwm8ThQeaITkEfiJRu+rQerjHlMrE1dvsEFJHiVXVhzvX+ZtXGcMnqw0imAo8Ln
	wsEGmKlsKwXYdzydKj3hwT0CfzKprQ8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KUgnU7Dh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n929WxwgcZ76HZ12XrH2zJJ5sMiFM/Y1T+2oaDOxi6ChWb7T8bJsD/2DbX6U5O9LldgQQM5YWt2PH1CPuJA8Kdy76/EGay3Ys6VnLeFkOaUroaUMpH9uelMY2allaC8FV8x3sgmdkM8TEe5/esHOZ2lWXdEcD4W+39ePiLnBvmPaEmVMQnG2SNBG/kjypLT02FHBTsTYRfSyFMLq8IyPNcrVJQGbDOCEjO6VZpKsGsOlBpbF5ZEPiU9rC8vHiBKYyCJXGBlB5hB3QYce0GYGX+R+WFvVUeQrBqNa12m6eKs1eBxs4Iv0taax4K62NBzaHANmpm9Lggwyqj+I/12O5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgOzn7wscYWbRcMg1eufbF3m0DIayiO5M34zrNzFKDU=;
 b=KaUBmXhFj7ok2+zeSnnS2oAAzjtQwT+1tyHfqngrwwViDhEuvC4R3TP5OAGJj1RIgNtQuo4SktZ6Hhx1fkjNAYbz8pdwc3VQb+uXQS1C3T3hNgQ/ir70z1yoU/bjCGvaMikj2NMYHK7vSMYctMD20iVaHCI5SscpDp9TaIUMTp+eJnmEDv24hOFK5urwxWYmT/T4d/qZmWMJf3NSljeMniP5A0ZdnDTYuAj1byVqBSeHEvR8w3Ts/8GCa1gbL7KErEh4Wfsec2MJUyE+ri/fWCZDjDKcCV5712/UeCFp+oZo7VdDgqpIoO9GC8lFzcV+ka9Guq0RsV/B8S7horI1wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgOzn7wscYWbRcMg1eufbF3m0DIayiO5M34zrNzFKDU=;
 b=KUgnU7DhTW47p34K9OgXECWAP99Ck8SUjatYX8MM0/AzvR7Dw9L33dbSaYZsrxo0X9UdGmAEpD6oPLybFiTNNkpPsFsl59A6H4bgd4OeonU7Ut9gwbqwjO+jZGCRhm1++USb3yQJXkJHvyq1uyt8duPxmTT3K2xfqt+DjzvMmj8kWg6+UXpwfy2+46ohc/ck1yJ0QF9r0hShWUwAoyJgEY4N5l2e2AmJyLlscNeoe6X60bQbwYNyGDmXdaWVzElEPZrOzs1TKfPecUAQ/zQETcCKk4/uhfCgbQFMp89I4k/TTwUUm8f+U4pY+k+vMSArslqiYkK5mWO5rJNy2AiDkg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5722.namprd12.prod.outlook.com (2603:10b6:8:5d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 01:58:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 01:58:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2026 21:58:48 -0400
Message-Id: <DJM0FXNR6JM1.3ONT2E8UKBA61@nvidia.com>
Subject: Re: [PATCH v3 2/7] mm/page_owner: add MR_NEVER to enum
 migrate_reason and use it for last_migrate_reason
Cc: "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <jackmanb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu"
 <mhiramat@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260630015331.147174-1-ye.liu@linux.dev>
 <20260630015331.147174-3-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-3-ye.liu@linux.dev>
X-ClientProxiedBy: YQZPR01CA0191.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aff0181-ca60-4986-027b-08ded64b2113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|22082099003|11063799006|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Kkezu5meIb6AggIhZexCDCScAMfNybSlWbiyBbHpIPo7HApS5ZZ5BYWWyezEOdmGkJCqf1zcogBqMcFJhqxScTCgr40IQV5qgtCUxRZEXr6XbG+3aAtBuUVTrxQX4WF5Qziue3uPRTI4PB1OlIu0atfHVWuBIrmcBEihdgWhwYxV96c18fnzCaOXnfUQPMR9RawYgPEh64bxpmsQ1zo8oKpXGF3Q/GHfwSS3oIItlLeilztXjvdXfHXtUXw2G9wHoQ4cKXGvOZZpuHrmn3Qu7HS2durxJKXSDFWwiE4Qy6PLkRbQjf5k4J/089NtGheWFpY1O+TqVmJMq33A7LJlh7ecGrRwme1hUHd7dRkWMbb1QwALx2HMrgLzgQXIQXUO0E2x9Qs3YvHZ7Ik/FZUGMJslpSdCUiAgkP8C5tWI/1qeC9v+6CnOvQSutxXiMRqWEDVZg/7TDrI2qjtxGl/gTd8yWSxMqdlXx0WwjvpiTevPLUpL+ppi6l1qjcwIml23Bw02f1Pb1DrGWCuTme6LJM2snOBu9Yqn9QCPawA2rm1hrtHr+6i3q79xh9H6Vn5lB5a21PsIFbAfyKW7ILfBBxtcNJLA37AhJksAOeg1CRHSWnv9lVFUxsfrOxM4nfgHIHsfrQ6QDY/8lGgUfCJgFi/4dk4/UvyLHU31vIotrUE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(11063799006)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjFmUVg2SGo4bWRicGZ1UE50Vkx3aTcrOGppTWN1d3BRUU5mdjdDWUN6VzNw?=
 =?utf-8?B?TDhqWm03UWE1UDl4bE5odE1kYXoxUWFpMjg0RCtNMzMvaE5keWVLMEI1Ymk3?=
 =?utf-8?B?SzVXUWdkNm4xZVBFcTRlNG5RMFo1VWtJTXV0RjA1Rit6b0lEdzlIQ0dYL3FD?=
 =?utf-8?B?L01PcWNhMVVxMTZORElQNytkdXpMV29nTDFONGJLQit3UEhjU3Nna1hsS3VT?=
 =?utf-8?B?WmtaSG5uNEJrS21NUGdMME10NzlJZmZaRkVzNDZtVEswd3VkU0IrY1hDTkI5?=
 =?utf-8?B?SDJydkVUTmkxK20rSG1rYlp1MHF1aFhMSnYrTmRiZDdqTERjQmppV1BaQzRP?=
 =?utf-8?B?Ti9jQnRwT3NLdGs2ank2bkNBellCYXhaYVFjRlo4Mm9KbnZhUWEzeGFLTU5r?=
 =?utf-8?B?anBieGVJSklGbEp2bXIydXM0TTQ0Z1ZLY0RMZnhuQ2tDRlF0aXpBMEw3NGpN?=
 =?utf-8?B?bFhNazRWVkc4RFhPSXpIdE43RStYamZFVk5DVFdZM1BRdWFDb0NyV2ZTWDc4?=
 =?utf-8?B?QkRrL0wyanpHbUJEVWg0RFVJS0hzZHlhUGIwY09NWDcyaUYxY09BK1ZlbVY1?=
 =?utf-8?B?M2tvd0U3aFdyWWt6SjJPeUJncEp5eE5nbFFXaXVCdGh2blpWa2JIMC9FUytD?=
 =?utf-8?B?WGc2UjVSL0pMei82ekJkTU1FN2QzcUZLekx5KzcwaVNNdVRxMnQ1dW1BYWI1?=
 =?utf-8?B?NjdpRjlWMVgxMW50bFZITTZmeGZaVDQrNDk1bmttQ0tFdE9vU2djNjZZRnZL?=
 =?utf-8?B?Zm12Q3pPeUhJMnZwQjJpTnJVK3JITnp0ZnJxOUpUSTRiazVTUU5KRzh1NlQy?=
 =?utf-8?B?V3pUdUZVbUxxeHVVWDEwdFhONHBMTGlWR1FGaVpZMzZTOWtEbkxWbTRFNWxv?=
 =?utf-8?B?azVQRmdWWndNMk9IVUhoY0prekIxOVhibVl5NXJyVVF6bWFSU0FpOENMWkpG?=
 =?utf-8?B?SUVPaDJXTk9EMS9jY0U0WExqREVwekU2M2tjOEFQTzJKNFZnZ2MvRG96YVRY?=
 =?utf-8?B?eW1wYUowS0dXZzhsdk9QRUNmTkY4cmRXRUU0ZFlqMnVUZ0lZdVBONEx2UGJR?=
 =?utf-8?B?dTBEelcyUEFBU1dobmsvMVlId1hEQ0tVeGZaSm81S0Z6blhlbHJjZEY0ekxm?=
 =?utf-8?B?d1NHS3pUOUxWZGRHdFhqdjNjKzI1T1IxNVJDcEVxRnBhcUdzbkVjZGU4d2I0?=
 =?utf-8?B?ZURKNkwrUzNwNmNnVEh5Y3FjNnFvR0dVOWZKOStwVDArSGtPSjRKTnhXZmZq?=
 =?utf-8?B?UFhsam5yYzZzN2tVZjFqaEg0S3ZoU2Y3WjdTQzJMSEpScE9jMVQ2bERzN0w4?=
 =?utf-8?B?aERxcld5ZEp0aS9mMXJHSW5VK3RtVDB3VzYyblEwczM3ODhYeWo0MkdmSzZ3?=
 =?utf-8?B?NUsyWnJUZEtlMC9pd3phUElJMWNUc2ZFeU9FenFwbU01MkhaMHhlditZWXZR?=
 =?utf-8?B?UjNNZ1Vvc1pneHM2VWZkUFZKVm5qaWVJREQxQjliKzlsc01FS1QyTDJLZk91?=
 =?utf-8?B?YmVBWTM5TjdzcWRXUFhJMXEvUmg5OUxJUitZZ0ZPR3duUHp4TXZhRjZLdUVv?=
 =?utf-8?B?bVNYZ3NBeEhUME9UdzRrSXBITkpZdmZYd0RTZkFROFN3eXZadTJ0NVZTa0t2?=
 =?utf-8?B?VE1RM3NoR05WSExSbTRXRGw2VW5Kcm5FOE1vRnVIMEwrMnY3bzVQQlR2ZTYv?=
 =?utf-8?B?Z1hrbHprUGYxWmlMVTBOb3UwOTBzSDFud251VDE4ZlN2TWNtTkJSdkVFS0VU?=
 =?utf-8?B?bWZndmhnTVRsMWxCYWhaYWVlYklMTDIyNVFhOEZrYkNxMGxwVnE3cTJHZEU0?=
 =?utf-8?B?VXRjSlp1SERoN08yTzRRTlB4WGpEZlZBTkV1UEZ0bDdaaFVYQjJ0cHBIc0dU?=
 =?utf-8?B?bkI3VG5RTmJibGNtK3FTcEZzemdYUmJKcTJTeFYrWkg5RXF5RnhZQW5qNW9y?=
 =?utf-8?B?Uk5zaHNCNFYzeGhRQURWRUpqYUptZ3lmNkRCOG8vZlZSS0Q0aTdxNDB6Q3Fo?=
 =?utf-8?B?ZytZRkRhZUlEeWxTK1Z6NnlWVm9XSHhJTys5ZDBTanpXWTJtR3REcjhGZXlO?=
 =?utf-8?B?d253VWthQ3FuYzY2NGpOVVRyN0R6bTQ4R2tpcEhHT3M0ZFNZdk9Mc25seElE?=
 =?utf-8?B?U2FrS2ZiUXNPR1dyeVo4SXRLcUdUaVlONG13ZDhqYWttc2ZGQ0pKeGRoVmRk?=
 =?utf-8?B?ODRFcGREbjJ5d054NTlpbklWWEh5VmRudzUyWVEyeUZ4NTN6UDNvcTVUemtn?=
 =?utf-8?B?RVVMZXVUUllnRDB5MmVCZmRXQXhzV1Y3a3JoUnA4cmRtUlN6UGQwMDlDbmtq?=
 =?utf-8?Q?TFdMajXrfcByy24fAd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aff0181-ca60-4986-027b-08ded64b2113
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 01:58:50.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rSA53bdlZ0ge9Behi25cEOJNXDp2yWgpjLjZ0t1zO0PwQNQReN1rrkiWSd9QAlC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5722
X-Stat-Signature: rz5kx9xo8su3mptbjp9bzqxchnztqnrs
X-Rspamd-Queue-Id: 8373B140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782784735-911391
X-HE-Meta: U2FsdGVkX1858eZ3H7yfu5pd6FxXkW5fmT98h3AqV97tLf4VDzFVJZIlQSlJ8zyqcTSBSYGIZCP4WE6Cx91/uG6FyAZgbgr64ijeudosrP67qSkg4MveMSeAEftSE69qmoPH7tsgsPTws21naZUFRIHrOa/CWQ97jQmvvlNRk/37jIbndyeBg4OIj6bKx8ufwUGvTX2BgornuWcPw0QpuwnTNUKnl5Tpuj2zNFaGoZiGvZSm6HQ6weZ+uD5dYee771ZYrgaZ+B1i8s+Se+hPvdw6IGMiLTrGpL3asgaRliQkH1OQfIZ0Q9y8zWv5uKzAQqZyPgJlsm4KFpWle4oT+Ok0URqygBX2mzlmvqsCEOm9BQ21hdjPk3MWtFbbf+D25+70mWfL6MlAyXVLO2OA0mGZhM+RTcYS0Ry0iX4SULaMyfSkQ4R+mPkzDdQ+BsZtufoh1THD/wGQ5DnSY7z1FmJ8fC+kuJvx37CU8vMSE+WKudQB0n1AQvAKiDQbtlaP+L2dXC/dFWQqLjybavX/XDXp23QE1LDnT9MdGuJqMtKc5vpPQFgvZYEuRM7xVxRvf43V58dPDA8BRyqPL2nFlsX4DiDqH6u5mV3aSs2JBmejSeE+lTOzhFZOISDhVhYuqgPbO+dDs8pc0ENwC/wmMHA8PvZDUq70gfjl7kkNmOsZ3j3s9z70L7Pis/U72n2KD62FKsj+mKhURxGZr9BqmR7UPHev7kM+DfqYuFBhS6IFcBPzrF+FhnPT6mFMtEk5LNDRMuvimWToLD4TyJlJ3Vxdlb8WpNAieEa0JIHBk8wiAR/M/2YLcgbnEExsTZ+xGxrYMXR0Iv8btUy+/rd/wmR1OdtHHksl9j9IsdFWqbmQXhocMACwpqbjIxW7kL6KA6d5HnE5zueDq5goACtSZGBS42jy+29xCrEWbrdkYqOJfzehxebrENdTMdEJATDzFtDcE5PE4CXkbKbfUak
 nRbjTebF
 rAyr1KcWbG4vNaq9busHfjrnmzigLdXU2rAwER1akR+zpF1lC3yly7R0yaoeM6IoX+vdRTUdBG/90l2m9xqhMOmIbtP56LAGY/4ZiwqkMVpXjDjTehALia5agOMaOwuuFMfo1ik4ThJcglX9ozZY1VtdT5q2G4ZX18EAsETFhD3013sV0QV2Q1yP6aRLly4AsdhM32H+Y7Z16aAbz1tuz54Bc+48Moz0XBGhMvgeLPxTgZgJcXwIeexsBxIdMGAg3hA08k6eHOC+J1/6BuLNjBQLqb2isKXijtowkAEdQ8Aa/te7g1Bn+tMr1W+gkIbTdXiGMX3ol8IZ0fJMyLH8/P7pUaEIKiKz1aAXeSdq3ry0WNMvnCIzPxZ/th+UnyS0NMVaWNMkmOTXFOngFQmjaNxi+AmZC0qrWCgcrZFeTp0HOx1AVWUZPLTnowbH8/90oULRNNiCUKEwKqr/G7keCKQW+Jn6l4skvjTo+uiAMFoSGypz7OvUUG7ENonuKvYPiruCFr2G/Arx7fy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 9:53 PM EDT, Ye Liu wrote:
> The last_migrate_reason field uses -1 as a sentinel value to mean "no
> migration has happened".  Replace the four bare -1 occurrences by
> adding a proper MR_NEVER member to enum migrate_reason, defining a
> corresponding "never_migrated" string in the MIGRATE_REASON trace
> macro, and removing the local MIGRATE_REASON_NONE define.
>
> No functional change.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  include/linux/migrate_mode.h   | 1 +
>  include/trace/events/migrate.h | 3 ++-
>  mm/page_owner.c                | 8 ++++----
>  3 files changed, 7 insertions(+), 5 deletions(-)
>

LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


