Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA57CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5976B009F; Tue, 16 Jun 2026 16:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9864A6B00A1; Tue, 16 Jun 2026 16:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E706B00A2; Tue, 16 Jun 2026 16:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD136B009F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:42:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3E3014025C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:14 +0000 (UTC)
X-FDA: 84886948188.23.3587401
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022127.outbound.protection.outlook.com [52.101.96.127])
	by imf11.hostedemail.com (Postfix) with ESMTP id DC2F64000B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=H67cCqWL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.127 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05saV88BDRnUt9+HfuLvy8ZXpd1g6jM9K8StEk8oE1A=;
	b=fGAJ9NyPxs0dyLNMAgpvkaXylFhoE3Y4AmIEQnkUgrCgxiCVgsnrAc3BGY8R+lVtPqMena
	AZWg/ssU2WmheusbI+p0ajB1sNKVek7HJxCYjc3VIhwUdumazBRQXgwpjnh5Aq4lTdIPyj
	dfmqWMFd339HXhieusFdvftXOUg4zAM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=H67cCqWL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.127 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781642532;
	b=0QP5k52NCV9bQ6buvFO6wVtQFFciosZrq9uGPkwnzM4yOuWg5nCITkhMVEXZGdppJ/ONF7
	1BftT0cRWvI5kDDePzun6k4L9Wl562jl6R4Li51mYfkzZWoDowrUgy0KGnHDLl9GvfHMer
	GdBuqIhRSsV5VZtrJ0QMqCfEAxg7cBI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FmRHdxkPyv5SRV5ZWrhVNAK/92s5AHpn0jrbGnv8lNWZZzP3KwLUXcQJKKkAut6ZQz8GpAVrXcvRVjDkTQ0nZKCjdeOdAKBwqNCGGpmMSQnl/3ctkSGHTgKPuE7ylID6NhsmLkaXOTWizZyJ1CtRYRUuRXMuhHZVng3Ib7HMc5aid9hvrFFRn6V7r52pHhJ6opKQEe8qs4fByc/q10+tPx1oRqGvPP/wEWeh5uG2OGmTlkJoIM1reXyv6tMr/pPabTN9Ekk5CuofRok5MT0FuF2VxpOiBfAbJg2B6DpCW/NU/e+3/OCiUcf2NGXOou+An4hUjn20LoIwp1wgExKFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05saV88BDRnUt9+HfuLvy8ZXpd1g6jM9K8StEk8oE1A=;
 b=MDOw3lWC6gg73GwSyDRNizTCqVdoRgzXFyBT755giNXCHeeHW0RO9mahNN9aBbqeKaYtD+18SNHdheglzkT3hmxGbrMYfAJojL5xvIxxN+uM9OA7JV3izr0c9Nn3h78gbQ0a7LJbp5eBa2JI88LEEFIYoA1ocyLjuIKTUBDwtPvWp0ciezyd0k3U0d6QkUGwzdLq9sw9Kv73Fb60UyUEe3X7n5CSbHOZYOiNWdoo/XyMzxQ54FvakK/bBesRRqlb7BQX7nKgJT+j+HU/d6B0er1wUzsDosK9IIwuV4Cd9Z/gic0eOPWVAAQ8Ba/VjdLiN3FwVHc46MKonG0o3Sl6tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05saV88BDRnUt9+HfuLvy8ZXpd1g6jM9K8StEk8oE1A=;
 b=H67cCqWLhRDwANSCiRzjilOdsCQcR/sTKLk2j6JNwv8YJXwuNTawGQKWbwGwn1LbVdUNc/TXGszK5fYuhJnvq0Cu9xs/bwSIPOdkNwDoST592B36Ur7u91ko7ejhE7oSvn10a1w1MH+1Yc6ogTFIAcIehPOf5ph6uj5+7oTxVhU=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LOAP265MB8506.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:471::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 11:52:11 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 11:52:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Jun 2026 12:52:10 +0100
Message-Id: <DJAGAMNJ043Q.3597PYV2YD6CI@garyguo.net>
Subject: Re: [PATCH v17 01/10] rust: alloc: add `KBox::into_non_null`
From: "Gary Guo" <gary@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross"
 <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Dave Ertman"
 <david.m.ertman@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Serge
 Hallyn" <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Viresh Kumar" <vireshk@kernel.org>,
 "Nishanth Menon" <nm@ti.com>, "Stephen Boyd" <sboyd@kernel.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, =?utf-8?q?Krzysztof_Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Igor
 Korotin" <igor.korotin@linux.dev>, "Pavel Tikhomirov"
 <ptikhomirov@virtuozzo.com>
Cc: <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-pci@vger.kernel.org>, <driver-core@lists.linux.dev>
X-Mailer: aerc 0.21.0
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
 <20260604-unique-ref-v17-1-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-1-7b4c3d2930b9@kernel.org>
X-ClientProxiedBy: LO4P265CA0275.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::11) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LOAP265MB8506:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cf5de7c-008e-4a5e-3331-08decb9db35b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|23010399003|376014|1800799024|10070799003|921020|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Q9/HIh9CMNXG8bgye913HrVSETxYwEONTy8Z/yhiyWt3kNDjyRUUuiWWIYqAohPJ4W/QpGezELO1zhe27ksNHgtK1XjDO6KTi56dq8cgr4SjpwPGKebh9r7fr3XFG1ghsseuJ5dHJ2OfSEOzM1oYmF9uM8UCpd9jf8OuIhBp4gUqp3QqZCzz6HvhSMvlilFHZ+AkjstoJl2Dq+xpMPVMxbkBMjQFF1OBJD7yzlSbh72u9NJIKxHf9vMAlS8HCiKnqeebzdG7fheb//gh1FmiqUFPjr/sfaWrwVwGxkySELgUYcjUbJZfXcLZyrmjbF/vVH1Mr23QIWnyBecxV0erEW0rNSWF7iPu4MrGQO27gKx972Rr+93Poh5s5vEUpMos96rF7m4y5e4JAxqiz/InFWihRq7yhUnMferkOCiHTZY7oHAPiVQjFn15hhYpWPqpCFoi5pV7KMdZq+gTA4oLqLqu35xVwtygR8KwcJ8D5W7kyDSlOOIAA6map2xOPXgKO0fFxzlbK2R8IuvrkIatA0LQuG2GLupz90qUxfLpVucWbUcB7eaZCsL+q+imC7Gewyb0/GFFTgsr9pHhu035V6RJreHPg2RVfqkApdmQ/FU7VrgWOHtLZ4ZS2caXgXj36sA8dA1kymcfI3xhWN9iZPU5RrFewI2DX+IskZZTZbTm63xQW5Mw3+DqgXepT7k3lWBQ2SAkCe5qppbE+40Z2E3n3r9wsHmXzv8IZijS620=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(23010399003)(376014)(1800799024)(10070799003)(921020)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTc5YnFhZ3c4VU1vUzIvZjRCOVlQTENCczBaV3BEWDVST25TZERHaGltbStt?=
 =?utf-8?B?WHRVRURibWFCWEJIS041azE1UTRsaDdGSm9ReTFuZ3V1WTdvV0Y1aUFZZXQy?=
 =?utf-8?B?TzFrd01qbEJLZFJuT0hmcU1sZkNVZlFWQkVzUUozMDVWSVVDV2FYUDRwZjBz?=
 =?utf-8?B?VFVlRlFtakRLeERmVHN2eUlFRWxLT1ZueE42d3RneGZWb2RDdVcwNGNMZnNm?=
 =?utf-8?B?S1Vya21OWDlmOXJVbFJsZzFoOWY4NXUxNzhZREF4UDgyTVNnOXp1R3V4MGIy?=
 =?utf-8?B?b0x0ZlBKVFFKNUE0Ukc4UCtrTm9UcVZrbnJ2bkxQNUcrOVBNYU1kK0FRcE1S?=
 =?utf-8?B?Q20zeFN3VzRoNkROOEd0N1MwbWordEtSTDdudTgyWHdwbmJsZ2I0c2VEWE1o?=
 =?utf-8?B?enNWZkQxZVUzTGN6NmszenJCVXduemRSUmp6QzdHVHJocTB4ZU9yMGtoTmlh?=
 =?utf-8?B?dG83T0ZXaUI1VzY3ZW1ONkNtdFQ0bHZSN3dPR01MZFZVRE5tUDN4MEVMNkhL?=
 =?utf-8?B?UjhDeEVZejNLODRUQUQzTVgyeEpjY2s0SXJQdzhjSlUra3pZRThCNVF6Y2gz?=
 =?utf-8?B?cmxNM0ROUTRsUjRDdHZjc0FlVjcyMEZ3d05NdlMyZUZadjRTWDVHOTJhQzhO?=
 =?utf-8?B?QzlYSStBZ2cyZXNJSzZWbTQ4VGl4SHNrOWh0bDI0M21lL1dPaURXY0dLUjBh?=
 =?utf-8?B?UE5lTGJOVkRxdG1DNjJYSUYrQWpDTXlSaUxCNGFhNlhzMzVpNHp0K282cnJx?=
 =?utf-8?B?Qk9ONmpBU1Y3d1d1d09wMmFRdzBKKzRjbFFIZmh4S0NCeTE4WmcwL0tMYWFy?=
 =?utf-8?B?NVRpRjJVYitXV0h5Vyt2d3d0aFp2aWtGc2hKdDlxU1pYRFJjSEhMVTBDRmZl?=
 =?utf-8?B?MmpQUUNlamJRbXVYSSswYkFIbTA4SmxaTnhLYVA2NHcrVE5XSmhFN2FYMlQ4?=
 =?utf-8?B?REVHQnRpKzYrbGtscGs4R3ZSaEJQQmdsNlZPY2JVcU1sMWprMTVDZldjcFh3?=
 =?utf-8?B?VnhXZ1AyRGlabXFod3NiVGtlWDNDd3lhZCt1V3huSjFsK05CZTBDZmxHNGVT?=
 =?utf-8?B?UXdhektZRUNPOWJUWVkrNVNRcC9UK2lJN3lCSkN1MHZOVnZ0b2pENTdBYkZ3?=
 =?utf-8?B?UEFFa3FvenlWWVUyRDNmYUx1aVpmM2twMkF0U09LbXV5WWpUbjluNnNzdU05?=
 =?utf-8?B?RmdNV3dyUFBrZW5Nd1VyemwzUm9zRXFNRFZ2SitqY1VrV29PR0RjWnVNOGg2?=
 =?utf-8?B?azMzb2lBbDlOVkd2Q3VPL1VReUduVTQ4dTMrb3JabkVpUDVjVGFiNjVIWUhW?=
 =?utf-8?B?MGJPUnh1VzVCUXZNM2FWWldSQWs0TDdIaVoxSGhYcEJhMThLSkVFemdTc3BT?=
 =?utf-8?B?SDlVMjNVT2s2dHEwaFZ0TnU3bkR5WGk0VmdKUTJzYVdySkJkUlNSSzVWSEI3?=
 =?utf-8?B?cm5sZnR1d0hialplVkp6K3dDdlN4QWJwWkp5WTJlL09XcFB2c0lidW1hVVJO?=
 =?utf-8?B?d0FPL0x2Qm44T0kvanF3WitoWlVkWlpOR3FISklDQ1dlak9GVWthSFRJdER3?=
 =?utf-8?B?N1dhRzhoZjR1TGRSTHo3bktmWGxVR21vbGRramY3THFsRE9YUjdkWTdvRmpT?=
 =?utf-8?B?L0RtcmpXOFkzNmxCYXZYNStzK2RIMkRWcjYvL3M1YXcvSEpUUVN2ZEhoeHNM?=
 =?utf-8?B?TUhZY3hwNDdzRWZ5ZUkyMWU5NDN5KytLS0tPdGJxOFhGbkVUOCtTSjljQ0Zu?=
 =?utf-8?B?dFFpSE03UE9hbVpRQ1MvTlJYWklra0hnbmk3UVA0MXROMjZ1Z1hZWWtGNDkz?=
 =?utf-8?B?aC9ka21qeDNmSm5maTF4b255dHlLK0c5bWxORHFWWVJDQmNlVXpqNHFvWVdO?=
 =?utf-8?B?djBpdHVUaEJxbFJZZmQyQWk1RlM5UlBGU1I1ZloxdTlHc3ZtTXdtVWEzakd0?=
 =?utf-8?B?MTN1SUI5WGtyUGM2SEtJNmFVdi9WRGdtUkFvWVN4TjA3TTlrazA1dWtDSXZD?=
 =?utf-8?B?T0dJUFZLNCtjYUJpeDFYeXVwV0VkK0NVOFN1RmZrVkJBVm9ZTFgzRktRZDFo?=
 =?utf-8?B?SFd2QzgzMDhzd28vKzB4c0ZUcFRVVlMxNGhQd3loTnZaQ3RtR0wyaStHQmh5?=
 =?utf-8?B?UFFtM2NrWitmUklBbjJiTVV2a1hyemdoNEFNUUNOemVPSGpuZHZZQmFNdDA5?=
 =?utf-8?B?eHhHWjRSdWJTdVhDWjRWQUxhUjVSd0JaSVNwWjhwWTFMeEFaUlBDOEJFMk15?=
 =?utf-8?B?RGV1RlZXNjVrenl3eDZRNllRTFo5bnZSMmRpS25YcUcwb1I4NTl6V0lhZE1n?=
 =?utf-8?B?WGk2TzlqSmZOdmdiRE1iSU0vbmpURWNQWjZSaDljL0EyVzVreFZTQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cf5de7c-008e-4a5e-3331-08decb9db35b
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 11:52:11.4018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b2/lLAwZTO9LPC+egOCtIhkRBn/Xob7jYnVIP5JoWWVWOoPhqJkZerjA8A30pohqPaNYVqGNbH1NHsnuLBbxpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOAP265MB8506
X-Rspamd-Queue-Id: DC2F64000B
X-Stat-Signature: 1pphc8mjp5g5noxsoqn1nrdjw8ca5n9x
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781642531-275767
X-HE-Meta: U2FsdGVkX1/IXwdWnh6RsUIhdE3NNq5qjG9U9/nL+LwFPTF+gekClEtUXfIHtquby6Ld5DSGkYwoxqpXkuFrsXqy83aLm66H/G3N0igUpZ0AUGQ8ru5UD+LWSlSZXoa5SS/8B644jbyzMzEOSwwgwBB+WW/WOKID6p/WDhGKUw0lltzarlK8QbBjZLDyQgz97Vyc6TwUNHg+NNq40tozNx8GRzYGSEVOSkoBI0eAt35MPun8Y0NVel5KiSBJnwUa+bcMkzOpzAGwGvatoA/48fLGduSdYYZYGYYDQk/osjaFsil45IhN4eqAF+d0OzWu7tlSQSL6k5uj4iUbDoWr/pBob4Tf40OStTpWxMQTdKUtjhs27bkfjKjjO0l941NjuinY0oq8GBfzu5RESuxweVIoNYJIN9hwlVuqqCGWRvCPQw/AxFHI0O4omjt9MUa46glYQEp3Xpdbxbc7eIo0eEyRFXSZZicotVc8Bo2t3jrTVcT50/qmHNFWy9+mBmYtgVWF1Io5sg3C1squ8yElnMQ6M/ZB9ZeAKAIOTbJZt/B1nz/cRX9w0RK9qTkrsWA5tJq305z4PdIAm5W1IsWch+uZvdgiFV9wlz3e0RnBQFA1otYcObqGrFbCm7c2gLt/ZQ82eNZSmYURvthZPhkFSK3P+nK/TVgFiaTvJbyfcYssOc3l06IbjWQQwCzu+r7ki5welTTsLkajBKNN3+N/eI7IYGpCk5JQdl2ErWscM5pUA5tarVgX9ENZUbUxamyaPgFDlqMXaggIu9ObmMELnFcRefjsVVXgvUH6i8VAFsoA6EkAHZ+MNLhsqxqqjkYu9dX4m2JWbbXP/TMdJnvBXx2Ymbbo/kDJZkgm5EXCD2utXozKSiQgoB9uA7egezAyJwAD3qGuWi3/46jSJ9jJ3Qsdyq5DOVIIni9lYYiyNuI00NuW+fpgi6hk/asP24DJT/ZRqBZj6sibJANotTz
 jvqljokV
 vDWgaRut1j4xPrtZqzmgwG5KCCk5N6r9goxK6felKrmNozHZJflw+3hfOKP374wkJZYo0QT7XgLtdaMO3Bo7XJQdotuUzmJf76dZVQDn5ocKeNzc8ihv76EDIaI622nlu0Ghngkwb6v1c3vnkqj1onlz8Sp5D9aQz23FPUY1i8Qb9yVAEHjrHSKG6YMTj26LBshestXYz5NVBxYpCXk3z+Q1HNYsascZZ78sy5qaesv1PsHYOscE/hJZ8Ue3OAe5Ns8RLdT96z6lyAg35xl0m7DfnGcYFTXPYSGMBd3N9f0c/2f23r2GuN+v+NXZXAmZpad/KplH4SW3Lt/e2ZHtaz17dO35TyEd56z9oloO4OyC1z5IkhbGzVcEvcJexeb+d0zOqx003RWveeLPzNFWnqGlIxBK/WqGTFWVGcBqQrT4g2kBTE0qWzw8fFTndUVSrFKPNPTjKMAyM/Ac5/DHZ9h1sQdDXQr/pJcwJ3vKQ/+jdi9gIBS0I5AIduNWfgsoKXgqIvDUq1xuuLBZLfLunRyEmFLjslLFPQ0yfqe9M3OMtEjWvdZvLyPBzBeNzsaiduFVIbEWRk8yJI1rr6yIyDo3SICfNVtDd8Ys0+qeIqJTC2mxwYXWes4rXzu317IS7o0IW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 4, 2026 at 9:11 PM BST, Andreas Hindborg wrote:
> Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
> is a convenience wrapper around `Self::into_raw` for callers that need
> a `NonNull` pointer rather than a raw pointer.
>=20
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/kernel/alloc/kbox.rs | 9 +++++++++
>  1 file changed, 9 insertions(+)


