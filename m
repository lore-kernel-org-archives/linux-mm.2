Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC27C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D326B0092; Fri, 11 Sep 2026 08:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A81B6B0093; Fri, 11 Sep 2026 08:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62FD6B0095; Fri, 11 Sep 2026 08:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9D1F6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:30:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AFF91A016B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:30:09 +0000 (UTC)
X-FDA: 85201413738.07.D0D2F8A
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022098.outbound.protection.outlook.com [52.101.96.98])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2039D40012
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:30:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=tKdiAz4m;
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.98 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789129806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKx55TsVGCAnYI4/46u4ZKV25DVYLk7MlbLMi/as7OU=;
	b=GkWP7nQwaXqJAVyKl2jrksVYLFwlp1HHnNVQDf5ZGhk36BCKk2VtENSWYgyBJ+qlLQSJqo
	w1Pz4IT27xMI3za9bNWNW6vjo25rFOaGWbm1GmS/BxCacP7sIVoTV8UjouR4m+E6DcUlOb
	ZZl9XbDwx/4dfdvu9mycQYVWR5jazCg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789129806;
	b=3ijEgsaadP1+xcJxOItZqWYnV68LhaTxs6uwnF3ruTL7iUwP2uh/sEDIWm4rN4hVToSIUM
	r2v2IhUp/Pv0zaiveyGMHoOrSqo0VFayKT12qZa52x63hofUb+CB0ACcSBxpKysnmylJV6
	lN4rLo1LnopfAH441PQTsWgdFW/qNqE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=tKdiAz4m;
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.98 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvIJI0/uljN/7NISqbqEDOCp79s+l29mZDOtAtzLgLdki7zSfFlLCDfIUVSM8BIYtAyPCTRGTzfTCM71pp0okVazRrQ16S1ub3BHfMQPzEbkqS2eyM2+0sAh43SjZl5xGVoxjuqr4Izj4HnDAMvFbGeKtlgLirr3Z/l9KXAwq+PSgWlAzuPeatlu9lI+ev8KBGs8gBxqxXMGq1OmU3m48eg/ggo1SXW4zw1qfzRH98bXur3tj5xTyvbz3YT6XZy1lO5Nv/q6Yls8GoSachnC0RWHDI+84XHn/QnSw9S5sEKj3q1oSC20gs7SijHIHMcPpzwjlPnaZyApEU74OuPjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKx55TsVGCAnYI4/46u4ZKV25DVYLk7MlbLMi/as7OU=;
 b=NbJ4G6p9WCmxaurUq8QL+hIpBrXS97mcwGDvddmXCfq+FlbRpqvtq54CsgVYla+BbrPsXW2tAqVFpqVdAThOCSqfYelqgO1KjxRJUbUxCbJ4nvjchpcav4n2XqgXYcbZE3eZPXNbff0CBLCj/apvFkX+f4t8D4rVLBjXrYFs2mfNd+AqWOYNT4xnwVd35TZPAR2rlFS8qlN7uANo2R2KXpoL7HZYPj6GPul5Bfb5mkQtlmIXPdOmp9TGkAae7K1KYRsyPtZP1wctMIDDxvK1jbizBbG0PCgdc/bINiLr80Rmwy9WNkrImYPR/hFfsMH1YRyt6UGCvb0K1q3arSviXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKx55TsVGCAnYI4/46u4ZKV25DVYLk7MlbLMi/as7OU=;
 b=tKdiAz4mEfYh0P0zazu2tNZHtP3G3dk4Xrjf6Bf5qyFbKzgEnajrNtW27iT4q1kO614uJEtPjeRQOC4X0u2mcIojrmNjWngoN/FXueiUsmN38J5io5LD9Fj5dyxLz4LgbvnbvXsmLIyEv6GzfaREsFgat8Z+vGoGufjx0jksqnQ=
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by CWLP265MB7039.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1ff::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 12:29:58 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 12:29:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Sep 2026 13:29:57 +0100
Message-Id: <DLCHKYBQ3WF1.B8YPUTAKNM7@garyguo.net>
Subject: Re: [PATCH v21 4/9] rust: rename `AlwaysRefCounted` to
 `RefCounted`.
From: "Gary Guo" <gary@garyguo.net>
To: "Alice Ryhl" <aliceryhl@google.com>, "Andreas Hindborg"
 <a.hindborg@kernel.org>
Cc: "Danilo Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>,
 "Alexandre Courbot" <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?=
 <work@onurozkan.dev>, "Lyude Paul" <lyude@redhat.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?=
 <arve@android.com>, "Todd Kjos" <tkjos@android.com>, "Christian Brauner"
 <brauner@kernel.org>, "Carlos Llamas" <cmllamas@google.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Dave Ertman" <david.m.ertman@intel.com>,
 "Leon Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>,
 "Serge Hallyn" <sergeh@kernel.org>, "David Airlie" <airlied@gmail.com>,
 "Simona Vetter" <simona@ffwll.ch>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin@linux.dev>, "Viresh Kumar" <vireshk@kernel.org>, "Nishanth
 Menon" <nm@ti.com>, "Stephen Boyd" <sboyd@kernel.org>, "Bjorn Helgaas"
 <bhelgaas@google.com>, =?utf-8?q?Krzysztof_Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
 "Michal Wilczynski" <m.wilczynski@samsung.com>, "Ira Weiny"
 <iweiny@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 "Philipp Stanner" <phasta@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <driver-core@lists.linux.dev>, <linux-block@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
 <linux-pci@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
 <linux-usb@vger.kernel.org>, "Oliver Mangold" <oliver.mangold@pm.me>,
 "Viresh Kumar" <viresh.kumar@linaro.org>
X-Mailer: aerc 0.22.0
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
 <20260910-unique-ref-v21-4-e83257373062@kernel.org>
 <CAH5fLghUQW5urTfLCCDT4BhuqoFVoLUAG46TS-SxaS37bJcgWQ@mail.gmail.com>
In-Reply-To: <CAH5fLghUQW5urTfLCCDT4BhuqoFVoLUAG46TS-SxaS37bJcgWQ@mail.gmail.com>
X-ClientProxiedBy: LO6P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::9) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|CWLP265MB7039:EE_
X-MS-Office365-Filtering-Correlation-Id: 1188c31b-b420-48f8-771c-08df100064a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|56012099006|6133799003|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RfhjpylTvaZ9jKzhImUGyjo2QOI8rxjN3Lwzcr92g6QuAgR5g1tsnqbPeRdU72yaWRPPP+pFHfjdYqlxWicJ4WiLePCzkUqaBN0sd0e7gC+1Yqug7ETQYnC3JfKqoTWHWFMsU/fJCDkr+tUmcQlFDvmZwDSqFMC54kYwFJ99LdSCglEg4urZqfgsXu9Thcim0UlTNpGE1FxUDNK6xZ/tuznMt9+ok9XJn1hdxvA2bhgD396KZKth8XvYrgVSwtm6YV17rYXg7S2ZdMM5Kf89ZauR6MGOYk2QLv6iuPqqWqL9XKebhCnkWXDisfUfootiwX2wTTxQepo4+QWLXlbutnxXAgAabhj0ZH+OLmMH1ArId/Y2pyDKmbmo0ZcaodacKgG9r+morrfh/ccIpexhTcsHZPEQj48cuRROXNB6rbx3lCee2SWB++BXgqV7jjbyN37SMKCf+dGFEhsQBBHGpF4zjkLjy9SxIoIce6rBiCRQbSMA6IkD+8GiJUhNaq6nInXkNCUm9BZ47geLDuXpGh4pG/afsxjiyQQjfqNRknBedCzAsUEKxA8NaQfew3ZNAmBRXUR84JWVaxYUl8tj8b9tjtEvEh8KFLnQKUosseVwdcVQR41AGLNGCY2BkVfiy43/BhbbxdVEUyxjGc7VrxZ7Lp8TkBJDBnAflwBk4gw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(56012099006)(6133799003)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGc4SkdFMVdja2RuYVJkd1YxWm1FL0RCSjN1aEp1ODI1cG1Oc2lMWlhsVWxC?=
 =?utf-8?B?OVlvSFJ2QjZvRFE1TDlZWW9DSnhqbzBIWTZIQjRrMHc2RUExb0xwdHMxMGM4?=
 =?utf-8?B?eEo5ZjBzVld1VytkQW9mZnFHcXBEd1NwOVpCOXBxNm5EaWQ1Sm1BRVVDQXBD?=
 =?utf-8?B?WlBvMVhabUkybDhwS1U1bzBpQTliam41MHJEWnRvZHRNREtuZ2xnWXNLUWo1?=
 =?utf-8?B?ZWZGYzJUTFJndm9LRGFpNHlPTm9EVWVudWN4V0pHSXkybEZiODQrU0RWVWU3?=
 =?utf-8?B?TWlBbzV1SFF5ZUszZzMySEdadldmdlJsNjQ3L2I5NG9QYlVOdFFmZlNQRldD?=
 =?utf-8?B?R3IyRTE4RnRNa1VNOUZiTnhPNlN2biswQ1BwZ1NxdFM3dmZ1T3BiOWNoak9s?=
 =?utf-8?B?Y0Z6ajEzNVA3UWxFclZqTkFLM2RqcGgrTzZyMnZTQWZDTkVqZ3hFdHZNemZL?=
 =?utf-8?B?Q01La3VMajJUdDJnYWxSRWdscFFPaFJjRklMeVZtRGlGS1RXNWVqaDcrUjVW?=
 =?utf-8?B?TjBMdkJWMXdvTm1uaVVjcWF0OVllU05UVU9iWXJ6TUNzbHN4ekZXYklKakdj?=
 =?utf-8?B?MkFMK3gxRm01VzJTMWcxdUNSUjVnNWZDSHNoaUJiKzBhUzl6TXJhMHJHUzA2?=
 =?utf-8?B?UXJTSWQzcWk2VWJ6Rm9MQzQ1K3EwUTU2Q1MvNFRqb1ZYaEdJS2JLLzVkNDV2?=
 =?utf-8?B?Q2lqQjJTQXp4SDJBay84cHUyT3JjZ3hUWkFrMmZQcWNVS0ZRTnJRbDd6K00v?=
 =?utf-8?B?M1QxdjVOcTByaUJUaXpWTm9JeUJ2R28ydG1GVzA1ZTJMZzh0RStiaHpCMWNH?=
 =?utf-8?B?cHB0ZlVpZ08xSnJIY2Q5OFp1czNnRVBCaWxtYXcwTkhxZ0FiK3I2WHNsYTJm?=
 =?utf-8?B?am9ZQjA0czE3cnhtbzlDNlR3M0ZRL1JoY1lrUXl4bFF1cFZXcUNyWUNIQnJ6?=
 =?utf-8?B?WWNubVcwVkFtQytuRGpQMmFmV0drWGhsMmgwYm8zOGYzSUJMNEx4elpLVFho?=
 =?utf-8?B?R0p6aUZzSlRrQUtsdUhtVjUySXQ5aWxlZlFpYy9IUGcxcGY0L2ltZEVBaEpR?=
 =?utf-8?B?VUVLOW9NWHhKbW9kd3YvV0QxWUVZTEdQbE1YZTVDSktYRTZ3T1Vrd3EwTVRq?=
 =?utf-8?B?dlpOcGlSQ3VvZ0RaZStuMXBjYWxzVFZ4N1B5YTMzRm5xa0tKTmhxajBtL3hp?=
 =?utf-8?B?M2owMmdyRTdZcFFwa3dyY1ZPcEx5YmUySXYxaW05eEdYZjBHamJmeXJLd3dY?=
 =?utf-8?B?QytCWW5ndU9ocUEwNzF1SC9YMUF5WGpPTHFzR2RxUlBaMkQ1dTZtRDVKUXRK?=
 =?utf-8?B?bDE0OXpYcjlPTWVyL2tQUFdIMkxDeGQ5bnIyVmxIMXVYSlZJZ2pSMHE1VTBB?=
 =?utf-8?B?TkxSOVJNMzNtOE5UWkdPclh3alFHYzE1akFTS0VPREZ3QjI2dE5hTCtWM29U?=
 =?utf-8?B?TXpPMEphQ3JRY3JEWmZoazJQQVJtd1RzWWhKdXNmVWloYTd2Z0psd0lBWUJz?=
 =?utf-8?B?bkhpLzZ0MXBoRU5Hc2ppbnpwM2oxZ1dudDBjbXpNVkZYd01QYmJHN2RETHc4?=
 =?utf-8?B?anVIalRrcnE2a29lWm80cHlWVG54eVM4Z0xuWGx1M1pCK2M1S1VIOGFLRVNN?=
 =?utf-8?B?eXJWakw3MHVYbkJhWm1Ibi9mVFdvc0lid2xrV3I5dzVSL3RNNTJuVW9lR0FK?=
 =?utf-8?B?Nmg4VHhBcXg4OFBwaDRSZzkyeU1ZWnZPd3hLM3MwamsyNFI4bjZNQ05iM2dv?=
 =?utf-8?B?YnZWV3UwbktXZGZmNVh4NHVNV3U5ZW1DaVBKS3QyN2ZzWlpGTzNUUStrYTd3?=
 =?utf-8?B?c1E1ZGxUTDUwa3ZXWG81Z3FOSThjcEY1cXV2OTNyVDdna1ZaUVlNa2t1OVlr?=
 =?utf-8?B?M2lwakRkZ2VoTG1SV2tSUHo1b0tWWmlIQjU5UG1OTXRSS29PcjhMc205b2k2?=
 =?utf-8?B?YTNEcmV4dko3YkZTM0Qrb3NBN2dMZjFMODl1UUZ0OVNJOVllbTdTc2RpMzlG?=
 =?utf-8?B?Sm5VSnZMclo3clAxT1RyN1V3d05QaWRjZHQzZU1selNYT1dPbHpnckVlUWtX?=
 =?utf-8?B?MXpOVXFDS2RMbDBvcHZOT01HVkE2c1JsMjdHZW43QmNiMlBDZStaRU5wVjho?=
 =?utf-8?B?bXppcW9EVHdRYm5rZkZwaXJNWU9uc1N3NDA0MThkQmFTMGl2cW1KT1Z5Q2Nt?=
 =?utf-8?B?alM2M3JXNDRzU1FEVFVnQU82allBeGFDUVFFZEx5UmY5cUhCa3JMd0lNOFY5?=
 =?utf-8?B?dHpLK0hybWVPWVhjdDEwOFdKQXU2SzVyUHE4MEFMQjNxelFlTXpoczRvbkdK?=
 =?utf-8?Q?0gTlrZQZYHgChetszZ?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 1188c31b-b420-48f8-771c-08df100064a5
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 12:29:58.6001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b0okIR6rYLMN6MXvV3IS4z+JjDgMUB8UcnSGh3mvV8u5UaD7Bp+PnDn6RzQngw+nrTVLI+7+Ue58B+xXbcVT+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB7039
X-Stat-Signature: 5ne63t7s64uk93fedj47m4u6sta6jfhp
X-Rspam-User: 
X-Rspamd-Queue-Id: 2039D40012
X-Rspamd-Server: rspam03
X-HE-Tag: 1789129805-369843
X-HE-Meta: U2FsdGVkX18oQo9w8QLrb8moGXWmsF1pTTmUKlvXC7vBIIaCdc5Gk7/A+glIqdT6vphYlhVYiRJgrLJPqYK5ZZ5+13Y6ICST5AiENIu+oqTzCCUrAxTjqOwOVfVjJ3K+uve3XkjNFg0LWvS9AlJrvFj5EFcdZkvdSViq7t5LMT9oozRsWGEhWRH5lRQHwonquPJTPJ8YeFHUrzXo6hcQOBspNIet3yBB9o+6ufuSstpAu8GIj4jtvLgZw2dRjSj6rJv3tGjoGbULqv4VUiSodzninXPpYIgGgdiaPScCszeNxzcQmaRqDDjG8gnhkFAv50jxOMOfhNevUQG/ESsNZXMrjz4HaMHEZYuljz9WzJNULM1bYZiPwgVtgd81yHGrXDj5cmwk3eUt5NHWzGBoCOM5TQvUa4pfKih4AY1j1kc93ZIWIwWDiLyo8HOf8UiFZl9wh60pSsZMbPbwzf0786ZMOr2KO90tbgPG79OFv0PdTQAaJKSGnjCFSOmqXbY7kOeff0Vca5I5l+KmLUW/vTmMD3/mgKjXz2i9V/sNOstZoZYYwadM3eSljQrD51YxDfH6FZJ2MtKWA17biIOLALH60cCHqQG/bQ3tB7ZmDE7YdJh41nqO9cvNy+seB9/yv8WVyxl4O38oVU0P7/XcvRTMKWtXLN+JW6PJE52As19X8RatVBrIG6AOIveOICopS1PO859qfhhviyVRkcnRxIErgw+A2wp+Qn6R1b0zbXVRqIPstic+RARBOpSRkFUSIqh8oFioz7/fNhICpP/937TvpDzn6zK6SbD+qvhMEWi/XCPq9bPUIpCld3hAwnpx/HTNcODYFLbzWWef/seVnU0dyQ+G4Jq16i6dceQowLw6Rem3aPXlCMXv7l3Ai+VknpkqEbo8hLUhvdng+8BdWMFYUWGG55vKb7mQjM/dcT1apDhf2gwUpI8r3N/JQUSjW0885HGKPz/MNv8onBx
 F8XExH5q
 tpnkcL4L0eqdvBsytEeABcCraqQFX0JPZD7bM/SbyxtU5AwIwHJKcVknRG6pdlJAyC35EEEIliKoHeL0UDQBrywOKbMN5qK54CcZvMfPhc5le4lA0uhxxBnhfLLJSGNjmx8mI6XYG+AD3jjIUi+gSFlvWA52Ty9bsBhNWNFpwLT986eFWzFW3QDau86QFTPLbUMhVITXMqnPKviLuwuGS1Lj9nTa+QJgKnnR52aMWh6NQ/g5EO/rNH74Nq90WhlC8cK9XRu6IWyNULTxcDVUPkVLppidK3GhoqK+qnkGwRfWUr/JYBSobJkBZem1yIrwveYyrNFXcB1kK0BczGw6pPTfSKxqLWkPqD3eZu0aSF5WEiJIMjYOcZgB+ywDMuuTBU1UTOB+16HKM9dGlHFoyMpkDpRpNbg5mh5uYrtcUZkttpqvTzTQSyO8ldmrzwjxaLKeTczDjtpLHJwaQvm/vYLNElCDXclxGvwqDmXb6iP9I+X8ZvnGGRZjAgF+N1pdue8sgy8zACp5ymlpm9hph4CJIZabmtiM6pyivpicwLpzwVLA2kpPi8ijlb43AJyA3Ye2sn4XzmDifpgdflVKNd+tL+HcgTLe35xnJQ77DHDjyWiC0IZ23SK6cNEa0HSQCk0zrFLZHpX8VzjtRUd8aw6BevZxqCID8Bzp1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 11, 2026 at 10:08 AM BST, Alice Ryhl wrote:
> On Thu, Sep 10, 2026 at 11:01=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
>>
>> From: Oliver Mangold <oliver.mangold@pm.me>
>>
>> There are types where it may both be reference counted in some cases and
>> owned in others. In such cases, obtaining `ARef<T>` from `&T` would be
>> unsound as it allows creation of `ARef<T>` copy from `&Owned<T>`.
>>
>> Therefore, we split `AlwaysRefCounted` into `RefCounted` (which `ARef<T>=
`
>> would require) and a marker trait to indicate that the type is always
>> reference counted (and not `Ownable`) so the `&T` -> `ARef<T>` conversio=
n
>> is possible.
>>
>> - Rename `AlwaysRefCounted` to `RefCounted`.
>> - Add a new unsafe trait `AlwaysRefCounted`.
>> - Implement the new trait `AlwaysRefCounted` for the newly renamed
>>   `RefCounted` implementations. This leaves functionality of existing
>>   implementers of `AlwaysRefCounted` intact.
>>
>> Suggested-by: Alice Ryhl <aliceryhl@google.com>
>> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> [ Andreas: Updated commit message and rebase on rust-next (7.2) ]
>> Acked-by: Igor Korotin <igor.korotin.linux@gmail.com>
>> Acked-by: Danilo Krummrich <dakr@kernel.org>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> Reviewed-by: Gary Guo <gary@garyguo.net>
>> Assisted-by: LLM
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> This has a lot of safety comments of the form "This does not implement
> Ownable, *therefore* it can implement AlwaysRefcounted". But I think
> the safety comment should instead explain that it's okay to create an
> ARef<_> from an &_ for this type. The fact that Ownable is not
> implemented is not sufficient argument.
>
> Alice

Yeah, I think for types that currently implement `AlwaysRefCounted` and doe=
s not
have a new `Ownable` form, it should keep saying that "this is always refer=
ence
counted".

Best,
Gary


