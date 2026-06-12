Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8A3CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD606B008C; Fri, 12 Jun 2026 03:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D3B6B0092; Fri, 12 Jun 2026 03:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B866B0093; Fri, 12 Jun 2026 03:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 445056B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:25:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4AA61A071D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:25:44 +0000 (UTC)
X-FDA: 84870425808.03.EF44AB3
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011024.outbound.protection.outlook.com [40.107.130.24])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9DFD160007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:25:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=TdMh7g7F;
	spf=pass (imf08.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.130.24 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781249142;
	b=J7BUtA4Acm7cv37wnywyAX0DTMTE6NsnqUORm3iQFG2ULuMi1lX7Bvra68gPo8WYOUJHfi
	N05PDg8lk0tWZlS35s+WDbq7/VA0CRjoSIKr5M+/p4Nu0bycaG0Nl9XCs98j4SNMsikJAM
	QDtK2VSTBqGhDGijM/E+ony08rG7I0o=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=TdMh7g7F;
	spf=pass (imf08.hostedemail.com: domain of yunseong.kim@est.tech designates 40.107.130.24 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781249141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZ6zLbpasBSAFDksbflrBfGNYz6Ch8g0O5luPLqhreI=;
	b=44kfgK6a6sGrSaCQ0ZBxp+XXjPjcAwxPhG9EpBhN2/EdK2shVdGCWnFEu+2R4knNK9knGf
	3YcbMJoXMAv3WAXVqzgJ5VlVh7//bPyNtUrchxXZHeKgriXBiRTqbgnWIX0i01fOKjStQS
	EakWCRkudJvuaBAJyYOFHarvSSik38Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DzBVklcJJK8xwe1jgmpP/qw4A0eI8Ojydpjw9OlFaSeCY01M759HRIFwsUXXh1hwzs/HuilSU20I1I80KJPzbG3GkLrNO2oHKFdid2jzUgqXoeY1Dpygal7P804h8WwdsXe+EkGQxwaYYrHAAtU0TBiCyfTGJfnrP0ITRc/+5b+meBAjQUOQuZ/+ZmDcztu9t9Zoet64k72nbu59UytsOSwC8RIYXLSJHms9XQUaIOeu5+nj/une7854sp8129DxD7mxDXM+BoPYUKMPtb6CgG1Ktbh4rmZWAzvWclfu+SpADzIvroEGRlBmzq+Pk+rStrVgitfZlqEzCkx8GCH8Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZ6zLbpasBSAFDksbflrBfGNYz6Ch8g0O5luPLqhreI=;
 b=SwQMQeYt3ryQjjLRMblstKwnWV/S+xLXbEm0QQciQs+34s4PgAIgLcL9GCNuDnJ0wQblVAhQFDyomIFPdtvWUGhpM+PJNpQS8l2UB3XZP2GWRfu+al9MOtB6/jLiaHNvdPxYNZ849CEPgVvlYEGGPLQuOtPwAqw5MaC5Bog9+8ChBLT4W9rw5CmtvB9q0UktKkEJHSBp+G+ut5VRWjvt5FLV3MA/fQhmmT1vW46F6iTDTgGYQFAY1U8ecgy+C2QPsQVrXiQ6bLYjDNA19otvb4wqHG2hBrLizhweY66JGdlTQJLAH/U5fI4oOEf3cAuX2Lb7SRocCM/uPGWli23i3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZ6zLbpasBSAFDksbflrBfGNYz6Ch8g0O5luPLqhreI=;
 b=TdMh7g7FKvHlyiz/HJC9+rbuFnyz3x6DhdyphKzO/gIOToDFvfjQuJIzfiI4q+fvi8i8MGh25kR8Ui75cjrRw3br/WK1IDD+K4zchNT2HuzAzySH+X+ZEvVwy6k/SWkGb0uRUCdSRRKO9NAFmdCS/2PXwBrqZEjxng6Zc0GksFi0P2VJ4cyXre961ZH7Zuq8prvwsMqSgWNtmW08OQBN6Lrrxsyq/TssFkhGobJTz4w+vIqVTFABK1slJxS4Y6A5VYX2VV16IlpZgvu0YZlX+kTLbsIDD/9fTB/OFwp+OoZa0ZnbjSGWgVI2qmRL7UE6NiFFcVnwybUH06um0TfszA==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by DU0P189MB2475.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:423::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 07:25:36 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%7]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 07:25:36 +0000
Message-ID: <5fa7a528-a4c5-4fdb-9a17-1b0992e955b3@est.tech>
Date: Fri, 12 Jun 2026 09:25:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/14] kcov: fix INIT_TRACK race in kcov_dataflow
To: Alexander Potapenko <glider@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org,
 linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>,
 sashiko-bot <sashiko-bot@kernel.org>
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
 <20260611-b4-kcov-dataflow-v2-v2-2-0a261da3987c@est.tech>
 <CAG_fn=V1+_xLgCZgdLnT7Y-muRO0CXkrNKkC8AzrqzWoL4eR8w@mail.gmail.com>
From: Yunseong Kim <yunseong.kim@est.tech>
Content-Language: en-US
In-Reply-To: <CAG_fn=V1+_xLgCZgdLnT7Y-muRO0CXkrNKkC8AzrqzWoL4eR8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: GV2PEPF0001A333.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::68e) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|DU0P189MB2475:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d591984-178d-4d83-04c0-08dec853cbae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Z2fIeGHVYHEBExwAe1TX2b6iOk93HjxpyOk4dahmbyIPGPQHm6xOan66KWiQn1BSgOlj6vmMxejTrnTaMwVEjaZgpgrmSlhrm/mJDT5Y/XWWzlPXP5ByqiqiCFYhDsu/2SqSQQFJGq2bsLiU2xxaxEbzLPxpKus8buZEIx2LS8q0hsAkrg5dGoaKbMcvKbH1gjaZ5bSooQqTUgw4dEpSiF1KVOdIIrJ18W7YnHhS/AMDcgd6ihQCX/bNqP2f7IlpSSb6hZHBRhxMQfvzsY3RZ0UcCVgEKD7CW3AsWgiEw8I5pd4i1//7e3bEgn0YVgf819yxQ2wcIz4k7JKvbjJ5yFRKoU+d3SF31wwEeoFlUPyGnW7GmnID/ETltxCTCcel1BK6y0XGQyXgdnQlakp3fHeQcDKqwzMtyVPV2gphu5Nvtc6ewAjhn9BfPkKgA6h2U/+EuHH0VlcGlXmf0K1z4eBDxsZdbYoNe4bI3qZ1FsbGvnQIK3biYO7xXBDthVzGoHudAa4EA5YctZE/SBDmbqhjrB6L7VHMzKe7ySVNIJWuXvMUhhUZAyAGgwQjQqjtZsQsErwWrEe2Bu2zLdS8mCmg/QONDFqC/85ep8Rxr4sqK+lST/+BTkWfmwvxVXzn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzRQQkpDZWZnOHhadW1rRnpqc2x5cm40Q2ZFRVZhVVR2a0dseGYzd2NXZVhC?=
 =?utf-8?B?U0EwV081eWUrVnhOeGcrYlMxRG80QkVhcE1NTFl5cEQvU25OTThFRUhJSWNt?=
 =?utf-8?B?VUFIeXVWMUZxWFkvNEdUVWo3aTd6Nm5PYkxCVHpMM004U1hHekI4SDIvWjRh?=
 =?utf-8?B?ZFhOZW80VUtPc0p2TVZ1NGpCUi9yNm81TUxYK09xemJxV3RWSzhXT2FNemZn?=
 =?utf-8?B?RENVaXd2OUd1QVZWeFF1enNCQjlBTnJzNk9TZ05iSXA1aFozZzFWalVNUkp5?=
 =?utf-8?B?Q0hjVmxDamVRS1JNRWw3L0VNeUdDM29JT1pFa21sNE84N2tSZ21uUEZ6Zy9R?=
 =?utf-8?B?SUN4U2Rtd0xtbU5vZ0R0aHpxQThiNE1qTzNLd05KSjcwRmltZ1NrUkNCdUJq?=
 =?utf-8?B?VDBOSUUyYmwwNE5WeUZBaTB4RnNVMTMxcE5sUlEzbU5GcU5YTUJzMzZQUWZG?=
 =?utf-8?B?ZG0veDJ3YXVsMS93YVRNQTFXU1lRVEgyR2kyVnpPZGxUbXNSUi9mV3graUgz?=
 =?utf-8?B?d256aUNUeWNyMGlBTTd3TmJNejkxM0J0Z1IzTTFzUElKR2ZZUTROcjhhc0xT?=
 =?utf-8?B?TzNLa2UxS2VJWExHVFpucDU0d1F2YmlDMTdFSWRFb3h0Y2hZR205OGZwa2VS?=
 =?utf-8?B?WHFxZ0drK1o3SWRLd3h3aElBT0VVZUVzVE9uNFJHYm81MkZjdGlYOFZlZEdB?=
 =?utf-8?B?c1pLR3JHUnFuOFlCS0U1azJsbE0ycDJiYmdXMENacjFoRzF0N1JocVYvd2J4?=
 =?utf-8?B?TlJRZ3gzQ0laNHZybUFmeTJlS1daWExTTkM4R1dWWkk2K00xM0hSMExCUFly?=
 =?utf-8?B?V0oyS0hPSFloZHBHUlhqS0xXUWM0Q1lpbnRHTVptdHJiY1YxMzJ5QWl2cWRr?=
 =?utf-8?B?VzhxK0FhUmtEcjVLT0tUSFQ5aXpzc0JMa0tPMjkxUU5jMlY1b2lMakpSb2Zp?=
 =?utf-8?B?UUtsOHdIdmlaRW9RdStNeWZNWUloVWtaQXZFRXNJV0VEZjZheWFHZTYyczdW?=
 =?utf-8?B?bXdGTm4xdmtZMHZrWWtnR2s4WWd4c2JiVHBrZDhRc1VBTWlZNnBWVCtZV2NR?=
 =?utf-8?B?MGNQYWZtcTRIaW9MalJoZDdXQ3RYdzFpalJNMVRKbHcyczJmdDh5NW9NRzQ0?=
 =?utf-8?B?dzBmd2JHblNGcjVpM3J1aTJlbkF6T1JCRGVCOE1sWWloVVV2dTdFcW50NGNT?=
 =?utf-8?B?KzA2VkRQcnNGWklQL1R0a0tRakx5bzBaQ3NrckZOdUFaVXZFeTJPREFzbnRX?=
 =?utf-8?B?akgwT0VIUGhMV3FEcnZzME1FKzZuRFBiMkZkNGJBZzRWQ2RXckNObU1nWlJZ?=
 =?utf-8?B?VjZhTng4UVRTczJEOG1GZ3U3RnlISmphUSthb05Pcm9OZnpnOWdZYXZIZ096?=
 =?utf-8?B?My9jOXVZVUxyRTBKTEhDdjhiUEs0clQxcGVjaWRITEZ1UEVuRXhBN2pQaUJw?=
 =?utf-8?B?ZjRNbytCSnNZZ1RlQlhFKzBGUUZvVkRuMnZBamtMaWh0Z1RRazV4TU41bUJy?=
 =?utf-8?B?akRIWE1XcnNNY1hMaUJsTG9CclpLM1A3bHlwMm0rTm1YaDVzSVpMekdWZ1pN?=
 =?utf-8?B?eVlpM3NodGEzQVUrL1VqOFRWL3lSRHl1b1JUZ0FaRlJrM0RhS0dlWFJKR3Vp?=
 =?utf-8?B?M21iQ25HdUUxSTYxYmppOUI5c00wbnRHWnFaNi9uWWpFWWZ3QStIbEJJTjlO?=
 =?utf-8?B?QzlCdzl6OGR5b2NiN1lCNWlkYStXOXo5QklpQ0FUSC9wMjNRb0ZRMXhGUUNj?=
 =?utf-8?B?YnFpclRWV1RIWXB0UDZUZWk4QVJmUG5nanVhOFFPM29JTTJ3UjRRcXhIN09N?=
 =?utf-8?B?TWpNSXgyTVlwNmFZWFVaSnV4K0FRQ3MxN1lzVThwK0R0ZUNMS0hib1hUZms0?=
 =?utf-8?B?bVpHa3VvcGMzTFVkbGJqM0F0NGlVYWZBb3dzT0cwcytMN1B2by9zakp0TzRr?=
 =?utf-8?B?NmhMam5kay9pb09ZNHVlNUdEVXRCQmprNVgvSGlIT2xTN0x5RFMyUWVkdHE4?=
 =?utf-8?B?YUp4cnNGMS9sVjVVdCswUitYZHNPRGwwRFNsbGtVTTVtQlpVOWpPMS94ckow?=
 =?utf-8?B?NDErUWkwUG1oc0hzcDR1K1c1ZVB2bGpmNTdnemt0N0dTVlEyUlpmN0VpL0Vi?=
 =?utf-8?B?QXZLcXpzSVloMmQxZno3M011d215RHRyZE1ZeXVCVFRFbllwc0lUY2x5cmp4?=
 =?utf-8?B?bEVQdFVXUVk0VWhTSTZhZFZ4MFBobDRLWnd6K3djNWdoc1lRQlZqR2tZYld1?=
 =?utf-8?B?R1dEVkE5RU5xUmx4Vnc0TEpRZWJUMWhwdHJ5ajhLbUVvZU5tMHFYYmZoenlL?=
 =?utf-8?B?MjRGZVowMUxzdFJRUWpNYndsY3hjV3F4NnNJaTJGdWFMUEIyV3Zldz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d591984-178d-4d83-04c0-08dec853cbae
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 07:25:35.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: veRiqRjFVgf5yS1rnbv83DuPtSOp6bQubQdYXMz3p/Ml0LPpPSloqBUl+EunFQU5diqOA1+0BrcTI+HF8L57iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P189MB2475
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9DFD160007
X-Rspam-User: 
X-Stat-Signature: psgtbpdoxu5zyei4sbyk9xjxa7nejsay
X-HE-Tag: 1781249141-913796
X-HE-Meta: U2FsdGVkX1/dmzSaO1Cz0o4YRroaWZIiqdGcCCXGxNd2ods03oHERAlAkb/O17W31IPXrD8oanUX3KuIwqwnAYfl/Np2qPOWYU2r5Jof8LD65fKzCohZ3QzgHjFo1eQOEGU3EKUaIssI1PronpYrMv+Q0a/G9b8j4IRpiG1O2vbfWrd+ytshydUiuvUn+jxqMOfQD3qdl0ZBsQ7cdRdm3o5A4u3yUbkG+SZX3S/V3z1FWwhTZoUpe5mjC104pJWPZPnIEXdPmSjon4knmo7guLysG9bWTpxxc0eG1NarrAfEuLmA0xJ3qju6ruEQ8UadsPcMbhRb6uj6ydeF9OO81EBRDyKbBG8I2C63lDl+tHz25IqdrSBFqpKw8P6wpd4JwnPZ9ob1Qi9Df0Jb/7kF+FRMUaoPDAnypE65lJdofEIC7U2hg+Bg4G754H5h3oOtV4fdX3VgS9AvIbqCnKRu6ASZxrm1YESFr0iWH1nhohUO4wpgWKBRyc1jYpXOxPcwt3nm4bWNQNA5i/2vx1eatKjLBJcsFOjtpF4SLiRNAqF17BNDCpJQ0aR4rmnLeuY2yfWMvUNSPcE661Ht0DD4zB8Cx61K9ZmTB3cq2JNF5xV7pEG2ns7YPTbxq6mbUQaxh8CFESAmtkQWeot58tNLL3KwpwS1y8lU/p5m3OXZKvPdcFEA3TjhsO6hMT8M7M8n4Qx2UfoXMgvt3TMp5Ik6ddawARuDrUbKG2bNaPOYcS9JgVMGuf/9np1Ritv8Iq53smN320aPzTyY14ck6vIo4/g7AMPBNzysA07vxgMqu9mLH/wbnTzRdesOvrNsGS7ktDIkp9YxxsWBBuPViWkjFUTx3f1tgE6ufoGIoiaA2S81Iol2wQb9iNh8OSlJRpIS38HLHuD0/E+aT0c5VybdeaiRiohzLnIUzRm/ZVT3GaKq22zBIDomYB2Gud0oENGOtE/Qt6lxDCGj+Cb4jHX
 d6/p1LkU
 n5iM6lrxzhoEDZMCdSiEmDEkbXvgNjl95pVOwpmZ9U/3+bRYHpKrNcZ+niyRWWZA0Qmf4LK34EDk3r8tyjOV9JT0cg/e939yaRNG5q7+xISp/OdoHkyHnzIl7lxai+mqmrMzHIHBNdhX0VoC6SlxAMwiOjdVxe0ys2O/uNWwEY8D9ui2ZV7FA2n3CR9m+gBcPLfGDAQ6p0cwce5gel7E5x16unfJgKR06YkCxIS4+WHLvhnavcjFdpJlrZ9Pvg8ArZEWuwTuKRqAWrHpUBCSCiP8QcgZ35JLQSjYRQ4pExfEuPrzbsJp5Vj1f+fZZoDDpvKD0yYZ1Li/zdenY090Aa+gnSv6ytj2l7lNAd9k1T5NeoijRAijS+PSGSuWeWIK/VGpX9E8Udh5gsv0BHVyhpf9ydIuoX/A8oNqJpwF9ORepWZ1cVOi6CRlSmfwRVlXdhCwUUEEMj9UrHgQ8S0KIcVTbigkz6mmmBMJdTyVBs8xPMb+Hl4cYRYp/2rpJETbGVXZEgJdmHKI3t3bP9TYuRI7VAJrSbU2EPOfIaormw6lO/qjbke08a5Ds4hpf1e7xgVVzdVUA5KcFkJeeIYX+I5UVeMhEVwkHT2+BKRjckvMNwxPE4UKtb8371oRT9CMLsxaiJXr5k67XY6Td/8z9t3GMJwleQrxIQly0RXJEVEO1d9H4KGDAndQDlRBGp2h3LWgxiIGtSUyPzoIWmCBa5e3A9kaLvuXSRaKOAYxWU2V6184BF4VYbaYo28d6ApGm+i+UCuek9J55DdKxWqEkqWJvwlcUcff7O9dA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

> On Thu, Jun 11, 2026 at 6:21 PM Yunseong Kim <yunseong.kim@est.tech> wrote:
>>
>> [snip...]
>> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
>> Closes: https://sashiko.dev/#/patchset/20260603-kcov-dataflow-next-20260603-v2-0-fee0939de2c4%40est.tech
>> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> 
> Can we please avoid this?
> kcov_dataflow.c is being introduced in the same series, there is no
> need to send a buggy commit and a follow-up fix - just squash the two
> together and note the changes after Signed-off-by: separated by a
> triple dash.

Thank you for your guide. I'll remove it in the next patch set.

Best regards,
Yunseong

