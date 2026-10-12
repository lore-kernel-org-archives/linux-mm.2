Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B7BCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8832F6B008A; Mon, 12 Oct 2026 11:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CA06B0098; Mon, 12 Oct 2026 11:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD286B009B; Mon, 12 Oct 2026 11:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8196B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:20:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBBC2C0EE6
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:20:24 +0000 (UTC)
X-FDA: 85314335568.28.AD78927
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	by imf04.hostedemail.com (Postfix) with ESMTP id BACBB40007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:20:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qNtEQzO6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.48.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791818421;
	b=unpIDO8uWHKShVsdXWdOYTFkkHwrRjgnTWkVRbsAGtTRHjMDBkG/ng/Efo1kKFnWUBdrTr
	5qaQVeHzU7oPKRv7vmN+dcTk07B5B0VGTDa/PFKlFJU6C9EZP/Ldb3hB1qClA8a+u6+8ib
	W9icmPFnDCcMjSlzJ6OMc31prYoSzO4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qNtEQzO6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.48.63 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791818421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwWjK8bL7nlLqc7Ibsl+Wu/067/YdKesdP6h9KOsf7Q=;
	b=UfhCjBYToc9aC0tCqg627j/eF/mZLwO5fsmp8rbryLUoAYWfX+hpTuaH1OlEkavC79j9dB
	QV66UM7q3QFfQHu6Ck5N+aVUtEEfBhaLUgW6AyM61EKeugjsdPnwV30W7FuIbgHolIApvc
	BfTVlkJPnJgGRHAwyQTjgv/pgKHrwqs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qFWrINMBCu3tvhcJWUqT6fuUAz95q8GCKwhw+YIayg3l8Qkg0ERN3eMMHd1RbEYk86ipISuSSUwkaKL/F82iQ1iiOWwLNO+cloP4iPyQaSX/Cf1svDDB/WpDcT1eteUwaKqcbY388OHZksPcxBjlASFN1d462jiePTjVTHvj5EG4O6EAIswpvM33idNlKHHYpxs+4GA6fgkhAeW9RFD9Z5NUgzN9tysk6Wp3hrabM2/zojZ+pJWqr/ELZEjsFbDoeh5lk0LYUNNrmDVmaqJBg9tnLRMz8wJH2ri24pAI+7vMbgoi3Wx/nf8/zXtJJgW+VJ73AG4C5YEAlkRXUawvqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwWjK8bL7nlLqc7Ibsl+Wu/067/YdKesdP6h9KOsf7Q=;
 b=rBo+9Q4+J70d8CyqAHCFmwNmML/0GSTRWijp8RcevfMncrxDzaFjSQn9IqggEVfFc6l5GrdLhZNmFSHnKczwbzUPqder1AGf9dlM0ilzwfLn0EC6pDKLSZXavVvzPewMhShsprz1newyqPKLsHgzn5F5WN/8B4p7gy6Fr1nPQTNDBOr+rvY5jM1nbLUZ8PiA/VgSO604XvzJnEPKFavzFywxvKqXWCqBg6JvvSf7s+irdfH66m0eEDsHi0Jm/w79gX+AqHqt1CfWxUSZtOPssDcCE9etVWK7miDfMKJRnuAJ7L2Vzhk/r988Q1Yt92u/UxNBE3rRJH/Hna5QPlig/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwWjK8bL7nlLqc7Ibsl+Wu/067/YdKesdP6h9KOsf7Q=;
 b=qNtEQzO6DJNqHzvkV49FxaQoZ8F0MESOsUafDLRUWBxpCgjR+7btnOWtJkuA8MGFjhX+9bMifXfOTJ4/wVJK3qpxJyTBxPF6BTUIi9zlvNTNwWGTB5MgYpICdLDicFoT7lpnE3ok2RRO9oEbznr5BDbKLyTKgpX/gAHOrBONhr2lP/u7NKIV56IbAZKLEz+AifxRROtSInR3uPqkw+18NTJwko/BiEKfvPlZa2Eh90PphrtYfVGMJV9Ws0qSwuIZZegI58SdVVmpKZ3mBTtI6/neqWzIkv3ixNXlVrmq/ip1aOtHqt6IF8fleh6FSvLPIBO11CXrm29klAfA6/xpUg==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by LV5PR12MB9825.namprd12.prod.outlook.com (2603:10b6:408:2ff::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 15:20:16 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0496.015; Mon, 12 Oct 2026
 15:20:16 +0000
Date: Mon, 12 Oct 2026 11:20:15 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v3 2/3] rust: add a wrapper for the `nr_online_nodes` C
 function
Message-ID: <asz6r8sJ4PzYEPdl@yury>
References: <20260929-cpu-helpers-v3-0-e968ce5ee613@kernel.org>
 <20260929-cpu-helpers-v3-2-e968ce5ee613@kernel.org>
 <CANiq72moeX-F-XkOWewwSEJHX6F5j+7NxNis7qhPU4aDOFRRpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72moeX-F-XkOWewwSEJHX6F5j+7NxNis7qhPU4aDOFRRpA@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0615.namprd03.prod.outlook.com
 (2603:10b6:408:106::20) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|LV5PR12MB9825:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc5c58c-ef66-42be-3bec-08df287451e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|23010399003|4143699003|11063799006|56012099006|18002099003|22082099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	/cqFiIwA4b19gB52HSpTxac19kpUvM0MRg9398By8KMcvppjaMplm2XG0PmLI5I/izPpmN6m6pMUq7FrwN0UQf1A+PcH1tbRW+jCelsFfWKGJ5MUuJr+blcBZq5xzianWA+4SEdBSp3tRk8wyt64+fDARD2jbfIZNz+TJPU1T3Mc4RMswgq5aaTh/V0AH+r72VZJzO+A39gY6k/Q233IgAz6loRQwtlNcWJ6HnUsm3P3kpTv20ki7gYC0ot0YUKEULFixf3DxC1k0Z/GaN6E4e+KyTRyv195DKq5iTcfpbwTe3eICF7GEsFQ7siE+M4R1H4mZNhRIXmX6xUF/3kwuVxb1Nuo3nokedaKvNK/A02ZiBKYn5pYitcIrvvVc1Al0cipzWHTrAOtgHEqD5L8IankMSOTiBQQ39PANfV7nmvRqN0pj2JrA94BfCl4a4fqDfzB76IEW0dlnwv4K2/eFrqXmZsTvEJEFgItXXLlyune2eNON9lYP4vbAPSIhtBIryo8SsTHG4cR9GT6laq30q72Qw+5KzGjb0l1QZZm9uNgDsyZZZ/7w9ZajRRwM7Inv7/mcDdkEnEpRkhx6JRtKq1Pk0qsT22YtJ4XaUPrz4/Uq2S2O9u2jopszQgveL1v8xLa9twGs7sLZXjSocFZKnuiP7Osw6zgKXtg0EU55qI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzFVbFpUbmRESHFPcVVEUXNZN0xJUTZnZzAyS1BUazZXb3pHZDY5ZllvWXg1?=
 =?utf-8?B?Z3EyNmRQUTRyT1JUTGhPMHZQY3NFbXRHVHpMM0JMQmdSY1lYUFBCV3c2YytX?=
 =?utf-8?B?bXFXbVNGL045c2krVEJXMDVvOUQ3UjlYL21TMlpoV3dJdEhSa0JrcGNKVWI3?=
 =?utf-8?B?Rko2eFVyUkxVWXhSS29ESnBtVHR0aDlmWjR6S2VuN2o2bmFieWcwTTZsSkFr?=
 =?utf-8?B?bTR2blBRVmhTemxoWkNCQ2VvVGpzUHl3K3lKSzBJa3dyL3p1c1EwdkFTQndD?=
 =?utf-8?B?Z2dOTUkxUFVubTJkK0tDMVB3elZkbW1YcGFuUWx2Y3Fhejg4OWtlZnFYMGE2?=
 =?utf-8?B?SEdTdmVVbWcrSFB3SVRITDFFZ2doT1RGa3VieW1TOHVnVEE2czlHWFlpdHVp?=
 =?utf-8?B?c0lCUkZMSlZBU05mdXpHbWVGUkw0c1MzdzN1MXk4OSthTHZ1aTlCa1hPR3NM?=
 =?utf-8?B?Z3NueGtKT1hObnJPR1YvdEg0SWVpa3NvY1RXOXk5ZGVyR082U3ArS2lZek5v?=
 =?utf-8?B?Z2FUcXUxbTZqMEdZaWJQU1d1dUE0a0xiUVp2eDRtVUdXU3JHWElLVHQzUVA1?=
 =?utf-8?B?OFZyWkdoVHNnR3FOQThmYkV5dHhXMFQ2c0Nuc1BuWlI2TkRDaXM0amsxa1J3?=
 =?utf-8?B?QmdBL1BRYm5tNDcvOVBSUUVuVy9xeEJiWENaN0dPQlNibzJOVXpHL2xNNkEw?=
 =?utf-8?B?ZHBsZHgxSUFIWVFMamNSQVhvd1pvUlA2NlIvVnlRNTNwVlFJV0IvbG0rT1hY?=
 =?utf-8?B?M1FDL2R6RDZlLyt6SEtzNnhvbk12L2MxYktmY3AwWi9TSnRaaEdDOHhKNjRE?=
 =?utf-8?B?b2czeVpBbzVFK3ZZeXV3K1lGMW93VEJ5YnFRMjJrSEFSS3gwcEYvbEIwbXRs?=
 =?utf-8?B?VlZ4dW5HRnhqWkF5ZlIrSkhEeVY3VkFwdXVobk5QbWErRFRSa25Cai81RW94?=
 =?utf-8?B?QnpSQ2o4SCtlcUVNSllMWExKVi9IOVYwNktsbmVjOW9DWUVYNVJGWVlrSlVl?=
 =?utf-8?B?dmR3WDZpdmZnWFl5RXJhUHQyYVBGbWJKMzlRRlZlY1N1UmtURUlIeGpNK05l?=
 =?utf-8?B?Y3RHNlVNNnQyR0lnRnFKWk0xSjIwTTJLcTNOeFpCa1RnUkF3amE0ajlkOGp5?=
 =?utf-8?B?bEdUVGFnNjB6RkpQNGo2ZEozZlRWWnpMcXVTdHRPeDBaTGJhai9uemdMa2Jv?=
 =?utf-8?B?YlRHRWZteE9FUGoyOElKV28wWUllRFc2NjlNcWtMV25HbEk0YnZLTnZmdHZR?=
 =?utf-8?B?TDdHVnJQMHJHMDRXMGNFcnlqWXNQaWxJY1lwT2xPb1NVNjE2RW5PTld2UGFu?=
 =?utf-8?B?elhHVFNBSnFYWTBlK2FseUNsZExuNWR0amY5WTB1bXBQbFkxcEZPcnJldW4z?=
 =?utf-8?B?dlRmZjVWYVVHMnNLZXdqaHJVL0Q5MGoxUXg2NjVJS2NNNitSZGlTNDBNWDlz?=
 =?utf-8?B?RUNUQldSaHNnWUplTm1INXFSZW95Rk9Ta3VzSGxxZ1lxNlN3MEUyd3NtSFE0?=
 =?utf-8?B?RHZvNTFJay96UDVVckFOeDR6UXkxQzJhT2RhbVVvSUNPQWJJcEZ2NDg4WkNw?=
 =?utf-8?B?TUI3bHpLQ2ZOaDhvYVNxU0FNMHJvdDNiRXlLMFN1VUJMSXdvMzBHaXFPL0pa?=
 =?utf-8?B?YXowVEw5b2JzYjhJYjY5UGFrNDMzWXAvTmUxQ09DaFdra0RxR3liSDFIV05r?=
 =?utf-8?B?UDQzWFVPRDdYMkYyUXdtdkh1RGw4QXdtUHFoSVNCUlQyM0l4dWF0VFBWOGVO?=
 =?utf-8?B?L3pkY21jOGJFSmdJcmRjZmQ3K3lTVm11bS8vcVprZVh0YUs5VWdxYkJ4QXhB?=
 =?utf-8?B?NU5YODV0TU9NN2NTSDFCeTJzcUI0a2sxSG81cGcveUhic213QTllM0RxQloz?=
 =?utf-8?B?dWZ4Qkd4TEJYVUJwb2duSmNZd2xLVE9rL0xFVGxRTEpFVFNRbi95azNaK1lx?=
 =?utf-8?B?NnQzU3pERlpGSGtINytXeDdvam11WVFTeFpaNms2cE9NeDkvNmc4T3NYWUdL?=
 =?utf-8?B?S3J2cEJnVUlRY0ZabWRwY25CcUJkVytUN3B2SjBaSjZ4dW1uYXB2aUpRRTc2?=
 =?utf-8?B?NHRWYUpiU2NlNVlkK0dNemE0S04zNVVjVjVROFRudDM1b0VyeEZIWnMyalVL?=
 =?utf-8?B?THVGU3dxWmlTYk9SV3B1MnAwMmZJRUJtSmQvNDJoRW9JMUJCVmxrNUEzZzBB?=
 =?utf-8?B?aTNkWUloUjcyWnhSNVFJTnBUQzM1SmZaVzJiR2RQbVNOTVlrNHo3Y1Bkbnp2?=
 =?utf-8?B?UzdNYVgzUGovckk3UlBlTzFPSzVrL3cvRjFrMHk2VUs0aUtoYy9MK3BYeE44?=
 =?utf-8?B?QlRHK1NRWDMrMGNEQUVma2UrbkpMMHJoM1RFQTBRUzFhOGNTUnRGK2xPN0l0?=
 =?utf-8?Q?QMGnXBii5G7itOAyHDBZRCLpa8X4FjNwxKkb+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc5c58c-ef66-42be-3bec-08df287451e7
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 15:20:16.7158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghiM3d/6h//1/0h+7/2PUrqWX7AWkxG8TJlnmebG9TfSuOXTn2JDae84Klz3yXNfmEf5VGfNNE+gxNnooT06aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9825
X-Stat-Signature: sip1t4k7hijzktku3t9irrx3hae16jdo
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BACBB40007
X-HE-Tag: 1791818421-589322
X-HE-Meta: U2FsdGVkX18cxMJUReOenNI883erNOIhX7l5i8TTwEngaPRkQRxOk8i7ehEjlpG8mMMZ/R6Pfa3xRDRYnwYkqo8CG+jghZzKoqo/7SG71w2EahKtYv8mQUVYDGEXkU94+5RO4WnDy+yldm2qhJW2hKmPnX+0RrKjQW6g4g4t3GBDZvzzvtWnYjqmDSgc/Xx8/M0L38X/5ATMUQMrR+eBORzsxpLDwmCkp5euAaKSZSYFqwyWdnA0Rgo/BMJydMLRI6unUhVeTNcOa/5/gofddblg4aUhixNd5NEM35s2NkoqyrmA6OHEvSPz1ohSm769odN6zjm2mZzD/bo+ZZr2mxATZt54emCAsrWkQJpPO/nekE+UwJCEhyC0fr1tC+4PB+s/7/mh5UJmi0QlAf4VVN3a1ZC31QzWuWq5TOsbnwWK/l/Q2UzHohGe7h0rzcRaOoN5SQR2FYb4Mwk84tgjyqi6xaleZdOBeETUfP0RM9rYkJlNHTPTdZ5gRMZIjEcfQwI29A8bjWMGkNcq4DpdPCXEwo+ZNp537pW0JmAeabl9WrGljPBe27Nxa7hCAkYge+83dp4v2TVll7T//ylGP06ZKerWGvU+eZ8z8ZjkkT8VM6tbvcLh1YhCHr+0+Olj6ZyXuzPT2G9MERceZLHv4LMSKYyqZO4HSCDpF4iLCf7gAp04GVUbMwN0bEr4K8fpvJobjGSEyEyJtJRMN8PtM23X93G1slbSigOSQ37wTsyERR5zfeheEgq/+nvvXA6TIv4CkK17LDC0kqOm0/F7fu6PGfnBnfXRgi8NZ1KWPERoAEHag7yRQ1L3SKyliHZci011+b5G/HKJ95M0kx34qaILTfn0UWwRVmS+VACBaKy5YuRuSYOYs2C48s+Ku7pok9a2sv87BA0lAI8FdjkUkeVS2HdvV8miKeXZK11XIfxpGVGYycq5v1EY0uF0fwbz7g35nQZrUaVGlemLGZL
 wMDQ9YuO
 /XDS+icXBUZJFNByqY0TFg8PVEhUpJRKiOtDzt4e9e0WoOeHTmGMqcBNrHQddiJw1nbI97kdfjOErBdGshUtlkwikrFARwDrN006ro2CO7x3bMlnBpaYjs5k517hqYZ4PUEuMqW9/J1h6OJq4U0cGrV0vwuFDwFzlvMQsq7kLCwqbB+TRFHcCJFynPsDZkyFKs+04m6fyfkn30Q0B2tt2S/NKLY0NtN+u/IEkKYymYYFN3R6gqsu1kFYZGLzUUnhdewpkhgErYZX+kfM8f+047/jWCVb4O1DapikUqaGh+henvmREa8LEPnc2hAs1WfoQPzntnyeR7qnzHTlKiuQZWFI1/IRe5YSC0/qWFjmQMBtVT00LhjTIlgTIFpNielL59Y/kXqgRfbfejWWYb/np8+5d7RluFWQbbQhNj4NDQs3XNhZjrmtfd0Fwt8nepzg0o2XAXPXzA1DMK5Zulm0n66vh5upkPQX65pAAVuC73gbAADHA/hNbpCNFk5mqsX7MYxR1v4T9bGwm2H4hKk+LIQp8u0NcRXkOPFtNC85lHbnwDLHkMHoiSjuFaqZjy6hZ0WEkA75hHUeWdWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 05:04:35PM +0200, Miguel Ojeda wrote:
> On Tue, Sep 29, 2026 at 7:58 PM Andreas Hindborg <a.hindborg@kernel.org> wrote:
> >
> > +//! NUMA topology utilities.
> > +//!
> > +//! C header: [`include/linux/nodemask.h`](srctree/include/linux/nodemask.h)
> 
> Cc'ing Yury and Rasmus since it refers to this file.

Thanks, Miguel.
 
> `page_alloc.c` also has the definition of the variable in the
> `MAX_NUMNODES > 1` case, so I guess the MM page alloc folks should
> also be Cc'd -- doing it too here.
> 
> In any case, I am happy to pick this one up if they are OK with it.

Let me walk through the series. If everything is OK, I'll take it
myself.

