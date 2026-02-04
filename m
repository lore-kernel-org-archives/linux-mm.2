Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B920E9D417
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACC626B00A2; Wed,  4 Feb 2026 11:55:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FCF6B00A3; Wed,  4 Feb 2026 11:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961AA6B00A4; Wed,  4 Feb 2026 11:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8049D6B00A2
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:55:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41A658AAC9
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:55:32 +0000 (UTC)
X-FDA: 84407375304.19.970429B
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021128.outbound.protection.outlook.com [52.101.100.128])
	by imf28.hostedemail.com (Postfix) with ESMTP id 71B62C0002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:55:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=nf6NThav;
	spf=pass (imf28.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.128 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770224129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3GtvJisYUaeXU+VSgjH7Wjs1n662gxUkzVIVITWg8M=;
	b=BAoqkTeO3dueSGdt4KCj7HJ+JMTTLaGHjaJcktDm+34jJcvIhReOqxjGUwCbzMC/xxnHv2
	VzZRR6Z9TfKdE3RJZqCzOBylU10nNoF5w42mJDHENo6OIy2sGmwmg+t5rqDcgnjilCagbB
	UiQ3MibHdSZBWurE+dTbSK6X+fULFpM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=nf6NThav;
	spf=pass (imf28.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.128 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770224129; a=rsa-sha256;
	cv=pass;
	b=F1dMhY6t7emCwc11zp1+B98l8A6olufI1ZV07mLBWXyVFkJ8nUng+rl37qPZZS09YjJ9JS
	n/OK157ZU9GdK+QE7mnib84nYEHxR9qhH0haw67GBc/+Be4U8xGPn1JV2GJBj+1CdIUKeD
	tkT9IXmTckBW9b6VJNZJkH/KbUoBKME=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JrzluGkuSy6If2owxworGDtFFn/GUlb7Ij8y3WsxZPxyPgP+SVIMbc9wkhvijxzAUIOrSAC9lgqe4wvaMbehqoNDcZi+HiaBuIh6rvKViK+ZC4XFr6OrNQintvd0oqzc8I25U4NsZwHRocaTw4WzfGrnxtWMF7fiTu1cZmN6UBrFzv26ndPp+bxhPKMctrmGs+XAq2BHs8LMPHwz/RPcmD0iY5KQCqFgsYUXQQWrVrUXdAEu1PrQWDG/hyGpfc7ObIPLa9GYfQFqBPpkywG+jA84munirRU/CPk+TIuY4rEDRvsrX5x4jeIzYq1kZ8mzSiASCCkua0oYBZzHLdeXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3GtvJisYUaeXU+VSgjH7Wjs1n662gxUkzVIVITWg8M=;
 b=xpfm304iDBugGyi6ANZFoJgiyMxhXF3odJ7+uyoad7mpn+hkVo2cWshZwMJ6p9BgVuXpR/4cTbwiaSNbZj2cn/rKCH1Gzy9rmVApaB3lFYQkhhYO4BG+Mnj+HkfLDokCPMdlMGIEOQOE4VkD++nDXnxYsHJu9MIX+Vg6UcYrchZ+I+/xjBp/lpifRcRzOySerHzAAKrSSJdzwnUwmlMgVqhu/Hbkvhw+AsF7Bh4QsIgIEWUhoLnJUIsWtClIBs/rETc/AQgaLPwUir/IL+ahOjMWgFOQiFaZxpSKPNAShyGDgyzZW0ZFas0wPlpzTFlSFfM+WKOAZMM8gHYMs0OQwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3GtvJisYUaeXU+VSgjH7Wjs1n662gxUkzVIVITWg8M=;
 b=nf6NThavl6KRnXeEqgeh4UZSDudNikRGAhp4/pMRJyEfB5KSSVTvZctJJ8q7cGVdoNbo6EjJ6nBLTWyevvtYqTwsmZR1eTjW9rjKex+NJzYQ0VTskGtNOMi/NWQ37MayeGOX3tRCzBCdcdoapOWRmSH3RBgoXNiuKnGgVc5zvWM=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LOYP265MB2128.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:111::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Wed, 4 Feb
 2026 16:55:25 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 16:55:25 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Feb 2026 16:55:24 +0000
Message-Id: <DG6C2VV8D15R.2DEPKS467SJ6F@garyguo.net>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Dave Ertman"
 <david.m.ertman@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Serge
 Hallyn" <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin.linux@gmail.com>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Viresh Kumar" <vireshk@kernel.org>, "Nishanth Menon" <nm@ti.com>, "Stephen
 Boyd" <sboyd@kernel.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-pci@vger.kernel.org>, "Asahi Lina" <lina+kernel@asahilina.net>
Subject: Re: [PATCH v14 1/9] rust: types: Add Ownable/Owned types
From: "Gary Guo" <gary@garyguo.net>
To: "Danilo Krummrich" <dakr@kernel.org>, "Andreas Hindborg"
 <a.hindborg@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
 <20260204-unique-ref-v14-1-17cb29ebacbb@kernel.org>
 <7uftlTZxNVxMw7VNqETbf9dBIWLrQ1Px16pM3qnAcc6FPgQj-ERdWfAACc5aDSAdeHM5lLTdSBZYkcOIgu7mWA==@protonmail.internalid> <DG6AIA0QK77C.EKG7X4NBEJ00@kernel.org> <87fr7gpk6d.fsf@t14s.mail-host-address-is-not-set> <DG6BWC5SOHUG.2K1ZXGYNVB69V@kernel.org>
In-Reply-To: <DG6BWC5SOHUG.2K1ZXGYNVB69V@kernel.org>
X-ClientProxiedBy: LO4P265CA0037.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::11) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LOYP265MB2128:EE_
X-MS-Office365-Filtering-Correlation-Id: d1d4121e-995f-4ed2-2111-08de640e311f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2Fyd0lOamNhTVZraEpxMy9rVWN3bTd2STBVWFRwWFRnZGUvTEtXRkhZQitx?=
 =?utf-8?B?aGROVE1yS1htdnEramdKcWUwZ3Z0UUQvSGR6RDRjekdENVhOalRJamc2M2dL?=
 =?utf-8?B?cUN6eFVzcEJ6Z25CWDlGUG1kY3llRWc0WEw2MDBnQ3g0alVEQ0pPbDcvUm91?=
 =?utf-8?B?UlA1VTQ3Rno4YzZHdHdhUUZIc3EvVGVyQWNsTEJSVU92Ykxsei9LaFBwOWZU?=
 =?utf-8?B?NzlSTzJEeEp5dmRlRUNoRUhJbUhmQXNkNFZCU3NRTGtJdmpHUnlWQXFtZXh0?=
 =?utf-8?B?UFpudFpLZUFSdFA4aDJ5aG0rWWRVaS9TeGNxVUp3NkZjWFQ3dGk4VnpsRFRk?=
 =?utf-8?B?aFZUSzZtdW9Id29BeWdlTVJTVHFjWTVSNHpCTm42ZUdWTGl5dFhkVnBEOTB6?=
 =?utf-8?B?c014eTI5V2JnQ0VaKzlZb3RyaHExRnZ3VHZ6UmlGMkhxbkgzNUlGQ24xczhO?=
 =?utf-8?B?TzNyOFZTNkRyUmRkekdzdDRxcGYxZW9QSU9nZFhVbVh1WHdtbHNjWm1tcUJP?=
 =?utf-8?B?d3YzN2wreVkyVk81WVo0YnpuSjRsU0QwV2o3eHJ0T1BMa3J2RWJSeldJZDRh?=
 =?utf-8?B?QkJkVnZuRXYvb1BuTWFzdndSL3Fxb1ZyYVZNTjFZZERoeVpDUXIxREtZVmZa?=
 =?utf-8?B?clFzNWZPSWtlTVhPNnZwRHBKdjgzbFg1TEx4ZlE1MnRJelZTK0RtbXcrWTBO?=
 =?utf-8?B?cFpyL0ZVZmw4cXBvM2lNby9QWmZRVS9HVHphVXRpYXVWWGhsVW5oSVRSZFdt?=
 =?utf-8?B?K0ttd1ZXcGJ5Zk5HcmF3M1cyTmw5M0NRV3pSb3NQNW41L3Vtb2ZhOVNoQkl6?=
 =?utf-8?B?anNGQkJNdlVUTGFrcE95bGdTQUJnbjVSbmgvdFBMeDZ2NVVaclE3Y0Y4OXc2?=
 =?utf-8?B?c1drV1BjUkNZeDFiQktNenljTTE5QUJUWHltMmt5V0paWDZ0bkFmdlVWVE5E?=
 =?utf-8?B?bVlDYkl2d3oyZDRQNTBydW8rd2RJTlNNaVQvaWdOS1BwcHMwT25NdVJuelRi?=
 =?utf-8?B?QkVPWkExbEErSkVXV25wcnNEMzZ0dm1OdnU2Vm9VbW5lR3Q0VzhpS015QjVn?=
 =?utf-8?B?VGtibGN2RlJrVm9uYml4aUU2ZkdtOXcxR2pCaFMxRHVNSUdvUU5CSWxFNndz?=
 =?utf-8?B?TFJRL1lLa04rY1hpUjRRbVAvTnVNWEJ4VFV2N2dPU3VMSnBlLzZ2MWZQcHZD?=
 =?utf-8?B?Sng1NzlHNzd4dStENDhHbExoSGRzSkVWR3paN2ZuU0F6L24wRlRidVh0WHVZ?=
 =?utf-8?B?TEd1UGRrTUhXQ3AzZUczLzJvTVlDVk9xNXE5R3NQc1FNYkdrZzdJeWg3ZlpE?=
 =?utf-8?B?Qko4azRDdjRvWjR3QU13UnByQW4zRjdSRXdpSTh1WXlPdHd5Rk8waTRIdGJD?=
 =?utf-8?B?cUdwTmRyZDFXdytObHZhUzhKcHBCOFRjTi8rRUNyS29XRmFyZnBvZUZWNXZ1?=
 =?utf-8?B?MGFjVlo1Q2ZibVYrT3JpL1kzMWljVWVSeklRY1Jaa3ZGOURsTjJ3c0JtMmE4?=
 =?utf-8?B?SHJCWEFXNWlHR1o1NnUyR1RuVDltSnJnUTZQWktpVkU3d0gxK2gzYkhHT0ZO?=
 =?utf-8?B?RFJNWXpEUjFXQ0d5WTIyejg3bGNWZTV1WEszeFg1SmVWNVRWTmZ5cjkveEUy?=
 =?utf-8?B?TUp4UUU5K3dkU0xSNitrK3UxcGJDYjc1SnoxRnBjNjAzTjJLWlJsWTkzZ3Jv?=
 =?utf-8?B?MlR0UnV5aXdUODRPdkUvd3J0Rkg4WFNjZVBFalJIbmZ4Q1JmSTJqL1QrUWJq?=
 =?utf-8?B?b09qZnRUZm4zMDVOUENCd0FDVDZzQzJHL1MrZ2RtbWhJdVpzVnN0NU5HSDlr?=
 =?utf-8?B?R2gwRUU4MWQ0V0tkMkU5TXVLWGlXWXB6VTF4RW5vQkxUQ0h1SDhSSkUzU2FQ?=
 =?utf-8?B?SkJicmJuSTc2aGNGYnVhMGlOaitBakFRSjFGQ3NmVGdoWUdkWkpWNEFKOW5E?=
 =?utf-8?B?SjQ0VkN1aHJCbnorMklvNEkxZ3dJeXFlNmhnbjFvRjhycWxIV3RMOVFyUDNN?=
 =?utf-8?B?R0JSRG9PYnRJeUU5TktqZnRSejA3a3FVN3IzQ1pOdWZ3Zk5Id05KMTRFNTJh?=
 =?utf-8?B?bDZRd0drczg5aWN2WE5qcDIrVG4yc1ZGcDM1Z1FwaUFxUzBhYm9oN3BObnY2?=
 =?utf-8?Q?/AsU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkVhTlNMOGJvRmI3M0d6bDd0TVBURjhld3RJK015WnZrYXEyK3hueXRRTldi?=
 =?utf-8?B?NWVCbjM2RElxM1g2SUxLeWxKaGNNUTFOVHBQVXBMMnBNM2xNNHV2OGFSQjlM?=
 =?utf-8?B?RURJNEhLVEgreTNRVkprK0lIY2xpY3Urb1N3RE01VHBYb1FQZ0ZEdXlsUWFu?=
 =?utf-8?B?NHVWUUlTWWhkSXJ4c1RraTBtUlp4ZjNaM2dWdGJKemFJVUFnM1lWQnh6bnJD?=
 =?utf-8?B?RmpUUGkveWdHQTEwWXdNaEwrLzQ5WkJxR1d0N2xGTEhUM2VrT1hpcWp6Snpl?=
 =?utf-8?B?bHliaExuZ29Zek1HSnZPMkR0bWpGVnJEUEJaTmUxckNPTExOU3k5UGhqWDNV?=
 =?utf-8?B?SkhlTE9KelZneE16MTJ5TXNCUXpZdER1bGRtWDd5a0NwVTdnQzl1REtGaUM5?=
 =?utf-8?B?WUtVakNvdGd2dDQ5dzlFSnlIMVlXNnUrU2FDZVhzd1pzT0lqU21EakpnaUpl?=
 =?utf-8?B?Vjl1bXdsRlQ0YnlZR1l2R25hWHBweHFETUFZUlBicFh4UTh5OGlEb1ZFYTkw?=
 =?utf-8?B?MlFoaENwL1cwd0QxaGVEVkZxa0YzeElQeGFoNExzOWEwZlBZOHczWXFvSEha?=
 =?utf-8?B?OWRkYmYxOGQyWkpUNmFWR01WNzFhVzBxNzRPeXlvOC9PVWlBekRod2hTam9W?=
 =?utf-8?B?NEVyOXNrZFNqVTIxcFBHRjZFbTBsS1pvbjdpWm5lRldlWkR2Y255dnkvZUc4?=
 =?utf-8?B?MXl0TmtVZmlPZ1pkRGRpRkJ2L2VHQ3RPaW53dzVnaG9Pa2N2b0JIRkhFRHA5?=
 =?utf-8?B?TjVzZ2o3OFhGaE1HM1FKRWpUcTVka3pRWlBrQVFkbDczRXoxK3R4bFlQdFhw?=
 =?utf-8?B?bG1iaS9tRTFuYzZGNW1uL240Q0xtN1k2T2lMaTZBWG9DTkN4YXQrU2ZSQUZN?=
 =?utf-8?B?UC9KME02RzRKTXBMNW5JTk9jQXlNcE9UWDZTT1dVS1ZJY085UW0rVzRpOTVp?=
 =?utf-8?B?cllXMVV4Q2pta1M3WGxyazdQWm5xdXk3UjN3dVQ0aVU3dGRhdEU2WERPVElN?=
 =?utf-8?B?WHBZdjdlaXBjSWpZS3NCTTh0TWZHMWdPWXpFeVk2ZGlzUm1YV3dpekNHdUF6?=
 =?utf-8?B?M1VrWHNhd24wU2JMWXJLY0YvUlVzaVJ4bE1Oc3ExdHB0UGEvVzVUa0tIYm9S?=
 =?utf-8?B?QW5UeDFoUkIrdE5oekh0c09YR2NOVnAwNHlYcEFTamMvV0w4OENqU3pSQjZY?=
 =?utf-8?B?UXAwdlpkU1dZcUhuN1N1dmd1MC8vaElhMDhqUWcyL3MySURQMys4TXMweUtl?=
 =?utf-8?B?ZURqRXR6KzdtRTBwdS9ubXdOaWlXOHhoOERQbmE2eSs5cXFCa3Z1M3VzYmd0?=
 =?utf-8?B?elFrUXQyN052Njh2Q0hDR1FLTnAyVGpxYUpMNHBaWjY4VERzMk5RREJkSWpR?=
 =?utf-8?B?dCtwcjU1OFk0UjQ2ZU9tYmN4dlBuZ2dRVG1WS3A1akJDblAwOHRQVnhYMmlr?=
 =?utf-8?B?NHFiZ3gvR1pReXBhWEM3am1DaW5hZ2xTUjVtbXFBZGxyVDZjYWVoRkZlVzlz?=
 =?utf-8?B?VzVDSXVkdkRMd0tlc1dHTjR1NXliODJBc1YxSi9EeU43b3kvNEJFbU9ySUQ3?=
 =?utf-8?B?M1pmdmh0MDBlZVVYTytTcVArQ2Q0d2xtNjBZNjhWZHRNOThBZDNhM2o2dnZC?=
 =?utf-8?B?M0l3SzIxN2NRNE9WZGhqMklMdGxSUWQvRzYvcktBMGJ4dys3UFVrRE1wUVRO?=
 =?utf-8?B?b2xGOW1hUmp6R0hId2FpVEdLSjBDZWo2eC8xa3hLb1V4MVZqT21oQmxBSExk?=
 =?utf-8?B?Zy8wWWg4S053Y0ZpTjJZOWw1VjNlWUFrRjVGaWJHazVHSDJpa0JaVjN5b3kw?=
 =?utf-8?B?Q0JqVE9sdjVVbzdnZnhTOHNMOEREeHFJNHdHc3c2TTd0OXZua29rSkM2YTFY?=
 =?utf-8?B?c3ZxNnJ0K2x6enRFU29MQmVpNnlYbFI2K1lydzIvRGxKRkpvc2pOWmF0ckFl?=
 =?utf-8?B?WE9BMnpXZ1NFWGRnR216VHFkRndxajNXT2JybW84bGQzY1RhYXBuZTBkbHpL?=
 =?utf-8?B?VlRhV2wzZm5QMHJBK0RBT25aNUxvTG15Q21nUE50MGRlVVZ1MTJPSEsvbldF?=
 =?utf-8?B?UVZZNHU3M2k2Ryt5ZDlVTFRLVDhsd1FONjF1ckM1Mzd3MEVxc1RENTlpT1hj?=
 =?utf-8?B?MTRON1FYM1BnWGxVQVEwNmhETHhDU2JtUm03N2RzVzNCZjNCZE9DbHZ4QkVH?=
 =?utf-8?B?Yk15RHkxZTQ5bDFjWFhnVEVWWmdrbDEwSTcvL3czbnh0SjErclgwS1FhMi9r?=
 =?utf-8?B?M2trak1oN2VMN1ZaVlBJQnZabTUxTHdrbmZiaWgwSWRjd0JvZ3F3ZjJPRVV1?=
 =?utf-8?B?WWF3Q2Z3VSs0KytXNkRWa3I1UFRONkRaSlNJaVZjSG5UcFBwODdOdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d4121e-995f-4ed2-2111-08de640e311f
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 16:55:25.0262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQnVLIoh0jm+w9Dp2ZA0ra1AQxUgN71SfFjXnCifMCPJSdfO2d9Dh+VvepLHWTCt5PELtMebQshI1Q7JaVCDbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP265MB2128
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71B62C0002
X-Stat-Signature: teymittm9jnx6mwr5im7wjj66qt147dj
X-Rspam-User: 
X-HE-Tag: 1770224129-381434
X-HE-Meta: U2FsdGVkX19Tzfcx61dmizVnFw1jkaH+9QHgspLi6sRltdWWqASP07/qDk/myumclthvzpHkNX1B8x0T0rUj+XLdmgBH8kMqLdZrynYzeGm8fa+b6ceppPLhHwl1Tr/Dq2sj+SOGmu91Kp8maNBURgIwLuTnbpCtDe2ay8tx1fxHoihZf8LeFA6jT2DxfDuMILSukuT7CQadHoQl15wDDLMivVabJMQYs8UoqCTRh7BDwFnrtaZEQs17VadnfgBMojG3dWfJB8D4XPqYsd9vVfWIFkzXHF6svmbH2X+8Yj4e7X14ONmY0zAa8DJu92K3tQTCH3X6G4GVlIyz1LG+80CrwPK6sUMsHrUy2biw5wjTrDob23LaQzWl0ShGhOB+fTnUHxErKk8Nv6+DbrK7K8ua1z44nKpn3ERGOLUkigqFX19vG1is6kTUii83tXdSjb8cfPfHdGjv3oTlx4dN09cDVFkbWQVlY8RBOjpYGmKhE/ToUqUHsz7vhyx7YhgGHkiEzObQMsZUQhNJ+A+nk5ocS/Ybz9srNT19HY0eZmYJ/tEMjdOcRNEtrDyzrB7d2mQsOup4TkbC0iEQ8Y8Ay//uzVbWssToNk6g0Wk7cC+o9dr5ShydvqhxToF+KQCSIKCr8S6NOMpcx0yGumb7urvUevYYHU2c+NmyawyurzwCgbTPU+WCG6CDotlVUri8DF5gX0XIaoP+T7nv1e8jnkBkfZPxLYvReNF1zLBFtnZ29cL/ecMMMDQFm8temKB4gg/dlF8+l4jF5Qpv1Vo7f0hRi94cFjJlLuHWVHv0w4/Kl41MjZPtB+YxZ+o3TPVAVaX+tqa3daL7DXkJLahqjxQI4ORf5ObWtoLq1I9cw2kbIrgi0qldJLp07WgMSOl2Y17oHStS8PAoR2u1zb21pALylZ8NnKCJs48ArkH5VODpVc4VcFvf7HTulig5L53ZdVF9U6rO0qnD1UL2Frw
 fSeRCDK6
 71caDyCKq7iWsieQ10qP1uajoJfolcg5uQHceqtjibk5Hl30ghVpJwWaNT2WPywQ8VbivcT1cS9zkhf9TBn6mfanvR36AatZWhla2XqxmxISY0o0eunVG55aPQxbddi7M1IxZD6pMydJiYYA7H6QC6qEn270hdHj7wPJ5FSldEeSE0zOLA/eXKLbYkYLETiFsb2U08Twb7N/xFOy43AStgxPCipBll3zuJynr7Xk/LzuE3FLj2Sgp9SrQ0BzJ8BFGtGoEfYHaaDjTSTL+7rB2e2uY4DwnWpYw40E/z5tU4jzFTLaADCZb0Qs9Z1ZkRZ+t2tA6FDvSNECQSstetGesbfNMOuRI+912l8nUzxa/KCmfbC0phTtWEj5EW+2MNHIt1QyDdD/YkBGU1D0GYyudRfgyHjM1bYdd7mWJOvsoyeoZXCWVNj6O+PCGzr8I7NqocjGNZlgBVvbJss4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 4, 2026 at 4:46 PM GMT, Danilo Krummrich wrote:
> On Wed Feb 4, 2026 at 5:06 PM CET, Andreas Hindborg wrote:
>> It is my understanding that the SoB needs confirmation from the author
>> if the code was changed. I changed the code and did not want to bother
>> the original author, because it is my understanding they do not wish to
>> be contacted. I did not want to misrepresent the original author, and so
>> I did not change the "From:" line.
>
> Frankly, I don't know what's the correct thing to do in this case; maybe =
the
> correct thing is to just keep the SoB, but list all the changes that have=
 been
> made.
>
> Technically, the same thing is common practice when maintainers (includin=
g
> myself) apply (minor) changes to a patch when applying them to their tree=
.
>
>> How would you prefer to account for the work by Abdiel and Boqun?
>
> I mean, I don't have a preference and if I would have one, it wouldn't be
> relevant. :) I just wanted to bring it up since the very first version wa=
s sent
> by the two of them. So, I think we should just ask.

It looks to me that they're independent works, there're very clear differen=
ce
between the two patches. Lina's patch closely follows the ARef design, and =
it
looks it also takes into account the dropck (by having `PhantomData`) and h=
ave
send/sync considerations.

Best,
Gary

