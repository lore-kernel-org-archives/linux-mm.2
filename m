Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E0CDCD98D5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E156B00A2; Thu, 11 Jun 2026 12:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1396F6B00A5; Thu, 11 Jun 2026 12:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DEB6B00A2; Thu, 11 Jun 2026 12:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC8DC6B00A4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E8091A073F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:08 +0000 (UTC)
X-FDA: 84868148736.27.5CBA982
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011058.outbound.protection.outlook.com [52.101.65.58])
	by imf18.hostedemail.com (Postfix) with ESMTP id 799B81C000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=TqfICdAv;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194925;
	b=u7xIOIdjhE/FxQM8duzQHVTpAv/ML46UUKjcUbRhsZ50BSoz1RWUpAuUPAJpPzPsWPUBhh
	clZarZIDPVGazeEvuljNFwwS6a1gP1FvDqQDS1x1OcuhkXsMmNqYkLdvqFS5y0VZWPh/1h
	bUA3J2WMGkpHp4lst8FT9Heit/EkWFY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=TqfICdAv;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kagR7UfO41iF3RqDVYf2P79DXvuzmMWy/Ts1AZzTCW0=;
	b=Hx/kWImNsi6OIddVjx/HXxTqD1zJpFDpfJ131APvW4JuBi7sLJpY6GHNLAw5U5cMuUwVrX
	RHETe/nSvI65+Lee67HZE/UqC97J78dRMnqdt9S1mCzLLoK+3TKWPiBFSyfC/jVDujtfj8
	qJYSUILzWb7gTJo7ZRiuTDLbMgxL3MY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5tiErPcGonDgUXfwP0FFElZPN9GLSG6fU4ifxuDh0EV2gi9DcoP1UUmAENeKOVFX9qy65y+3JwhUTNWZDpa0Qo+4o33m3xfLil0b/fMgdSDvgedn86ZIRpYsV5IokpxvJrYAwide/NReG5nHEpq/FIHfEK7J32jYmVzZPdpqjGN7cSKSTk+grYmrpgNa/8sh7AnCsI2AwG78Ml/H5PP11HoKKDSKhZBYJRw527HSu5PWYV6ralCrUraDEBoPbADzUsHo6jxORAjm+Fa/TxyJPRefGKMPGpRqtJyLTyzgFOVBV2Lz6ovG8JlpCvqlLaY/FldHh4jp12zy/qmtjOYIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kagR7UfO41iF3RqDVYf2P79DXvuzmMWy/Ts1AZzTCW0=;
 b=H1ofMIpOxtXuwUDcKOBmUUbF8hMDdLuWXDSq+Qs2MBbjKggW5X7RYdzZ/AYaxxVcVmfn/tGs45WFIuAbr21v7g1NoFDw5XGJN+Tu5ZGzn1g6ikxCnage8fHzjg9gNgR53/fa+iT/+ktsIs+11ffjRFcQdifzf5af1QpjZzd94c2D2M26Hw9cv65ewR0YPA8fv3yD84SuxUIRuCPo3W+mowIqY/Nycgukc0JI/6m/GWwG+GhP7+W/fvlFSQ1kI2NGgMGr2UKKAWEgtZxks6rhuJIZ6ltiL85yn/XZkioID1zXxz6cGLPRVylY6PGUtsp3/oNR1vbMleqT2blFTdtU7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kagR7UfO41iF3RqDVYf2P79DXvuzmMWy/Ts1AZzTCW0=;
 b=TqfICdAvbB2hfL5C6UctJTH9KoUr4G5K5Z/S/jr52zWLdMAGWL3jeK2/VZ5d39Cr56V3EZlgCtU1sO4pFkohlpZ9/1xyY9Q3ush6xiVb8FIbnIWQKOsS2sCxwxVXDko3mFnnsaS4osjz+VMqLfEwU+H51U9mhkV/5o1OruUnd12Wy4TM3xQrVaSSFHq1EXD48lvahgsHqqmuLP4gO+bKnFTVXDjMZZ2MZygzQ5QbSETmU7G7E6T7qrsgBhn8wGj6aAY2TIBxDYqeieTTYwPQX82e5lt0JiBk+SqtClORVn64RUVOueEsU/NRerWRVVSEYvdB5BpVxrhpKyudVuUoeA==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:55 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:55 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:12 +0200
Subject: [RFC PATCH v2 10/14] selftests/kcov_dataflow: add eight_args_c
 test module
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-10-0a261da3987c@est.tech>
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
In-Reply-To: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
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
 Shuah Khan <skhan@linuxfoundation.org>, 
 Yunseong Kim <yunseong.kim@est.tech>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
 rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=8533;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=jZKeC0Has3ofQqUTkW5vtr3NRu/MvfbrqTtH9SDaq7s=;
 b=XIQYYhybnI3x412KoJNkPQudKdN34PzqhMFenKUAFhpqA9X9DJXPZf2W4b7ZSM4ZkDawoso6Z
 4X/tjHZWcmzCZXVRv+KrASFcrZaexfsMKZz0Kcz/bvsiGqeiB2J3JMs
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV3PEPF0001DBFF.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::31a) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: fb96c94a-4b23-434a-0d85-08dec7d58db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|5023799004|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dJwd1AdMrQ9dvlhONfc81x6Kf2g158M+a1c6jePabjsjoppYqq/XuH8c8Yjs2KoC5+cJGuzm51di9IBfqZRxUgRu4QXlOlxNVVPusHkI8FchLMCcq+TwMHeOSQXGeuxO6rYFANKyX91HHCpr35jCOSd7kMyl0T0M7v676HmVCvmCSRpl5ElTRZziAhXzo2K8PydbVZOu+aY+uJYMeI3lxw/McTLQnVLnMdf3vMLs/67XW/be0zM0ggLbA7UZvxGAWTVhpQaOZtv9mwLp/70fphmu5Y93ibp8UWzjWetF51rXGyGIJKxX/1baOXtAGlQuEzAthqc7ZU7gJSEhcRSpzOMoMZnYTFRu70zGrxAiL/83WO2+S8A9RqLOLZXiP+ELoKgY+vPn7pTmpb1s+GWaXrALXEAmfq6CBpec9/R2bVb2FYG62z+TrQehb49QbJOjA0NCyMW4JNiBFFmrvSDTTXSRbElJSPYg4mySrs821ljZP9RaTfWEmzP4bquNvpcCwkibxn2r1GNSTvIG38MGTeGqBiQ9VLFPtJUrcz6/hEwh5pyGV1cl5ZXaFQYVibl5D1PvJL6Up5onDp/EPR1EsoCcWqthGDJLMIdPAnuFcHNCylnsdCjtQJpm/m670WvuUmjcp///OOuEmovk/M/b3ahBcdkaWp1wlxbOsl9EFIk9kbFHuhfObJ8A7s6FT7MHFyU8oSkzOObRGAb/UKgM0rBfIGChIdY2/PrUJ6VooHa7TUYHxphhADq+rY4cuxvZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(5023799004)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ei95RmtCMzdoLytVa3pzL0FnaUI3ZzM3SDJ5ekpPVy9tTmh5WVdhSkdOTTc0?=
 =?utf-8?B?ZmN1emVUK2N4NFE5OVdYbTZ3VGJqVE93VWdZNUR4ZmFSdzQ3MzJVWmk4ZXlY?=
 =?utf-8?B?c3dqa2p1encwdk5zVU9jV3p3WlRNRGY2cExxYUdid0Y1MllmRjJkY25mWG01?=
 =?utf-8?B?WlpicjVVWkNzeENjQ1NiQ2luRXlwdS8rR0kyU3VLY1paSndvbXd2Q1BoMDNr?=
 =?utf-8?B?eHk5OUlnSENFWnFPSkpXYWE3VGxPZFhTYVFzUG4zYjVkU0FYT2FoSzIvaWVS?=
 =?utf-8?B?bmY1cTVkbFA0NGtnS1dHaXViWjN3YWFBWDN3c2dsUnRJdGpRQjF2RHkwWGd1?=
 =?utf-8?B?ekR3dVhlblhEV1E2SEZFaEJjM0ZiVjlRRDUvSUYzbnZVbU9FUkxrWE5kL2N1?=
 =?utf-8?B?NWpUZTN0YVV3UnZHRTFodXptV1pqb2lPc2Nva3ZjSjNSWm5COVFUb1QyK3Y0?=
 =?utf-8?B?c2w3d01ONnMrcGh2YUpYTkI4VHRnRXBCSEU0bVlGV21TMm9kMC9SSUJFZTJF?=
 =?utf-8?B?MUIvK0lNVU9QWlgxM0VtTHBnVEQzaTk5OWlTVGlwclZmZEJVMnhzOGpZeUlT?=
 =?utf-8?B?QlBmbU9aVHhiMS9zY2UwanlNcDNvYk5zYWQrWXlCS3lWNElWS3k0aldiZ0Vq?=
 =?utf-8?B?Qk1CWXJmRzltanZiSWlsVk1Kb1pBMEdmUkdOUUdMdUl0ekVjazNod1haZ0NV?=
 =?utf-8?B?WnVaYk83ZXAxN1ZqZEFvVGVENmdQUGhpUVVwdkNsc1puUi85dm0wN0MvWUFP?=
 =?utf-8?B?K0Q3bHcySy9QcUxLNm05aTJQQlpXM2xXczJuSTJuOHgxckxLVVZOb0JlSFJy?=
 =?utf-8?B?MXlwZ0VxTktWb2NCSTZhMUJFOEpVK3hkZUt0alJvM1FtWG9qdW8vVUNyWXBY?=
 =?utf-8?B?c2NzWmpvVHo5UUVHOHZHRHNMdWhoV05tTWhaQ29kbG1VMGpmVXlxbzAwNnN6?=
 =?utf-8?B?dmtyNHN5RVFQbFp1U0JPeVcvUnB2dUxuSmFtTHcydjdWcVRpMVkvSGlxY1J5?=
 =?utf-8?B?YlZsb0tFdWpzODl1ait5blc0N1F0TkVDam03bmI1U1g2Q29EamRoZXRIYkla?=
 =?utf-8?B?RzdzYXQxOE9iQ0ZZUlNqSUZLSU1NQnRMNlNWYW9sVk5PRzd5aWE2L20zUUV1?=
 =?utf-8?B?ZHpLZmNZcHdhdzVWVHhvMllSa05BcTNKMCtRYVd1bU5OdExoL1VobmY0Q1N6?=
 =?utf-8?B?YlBYWU9tU1NoOVNyRi9ncG95cWJrQVlnY2xMcGI5enpxcUVyOElvTW5WSE5a?=
 =?utf-8?B?cUk5MlJmS2pDdFE0dTdUalVnbEwwM2p6Q1JFa2ZtWnFjNkNCZS9uZEkxS1lz?=
 =?utf-8?B?WVRzdFhwYWlJSGRkbysyeTE5M0t4OTJWVjNEN3JjdTV5Zm1lejNDNGtMRHl2?=
 =?utf-8?B?c3NJd1B0N1ROMjdNOFNXQUNHMldCVFduQTh4aWhaWVNFcUZXbjNiZEIrcHFr?=
 =?utf-8?B?c25GdXRZOVFwRUNOSnVLVXFzR3ZNV0djZXRWZHhaMVhGMFJYRTlHV3Y1U2tK?=
 =?utf-8?B?emtBM0NLNHJwMXcrcUp6azBicWVyK2RzZmxYdzZWdzhQOEU2bVFPMGkyaW1S?=
 =?utf-8?B?SkNyb3l5dCs5UjVJak51VFFFa2lhWGFsU0NnWUczbGRkQjZoNWhuTmJWRkFj?=
 =?utf-8?B?cGk3UG94TVJXV3FSYzlZYk5WdE1IZTNhMGUzMG03SE9ZUE9iQkdxNkFxczNL?=
 =?utf-8?B?VVo2dHB2anJlbEpUYTZoSUNjb0NlODJHcDZHTE9sUUxMWG5jUzZZVE9JR3Nr?=
 =?utf-8?B?VGVCcTdYcUUzT2MxdDdBUEV4U0xzaGNUK1pxZHF3Tk42NGdGaHU1WHJwdEMr?=
 =?utf-8?B?Z3BqZUc3ZW5pRmFkMStHeU40VGgvM1pYMXRqRFM5dThjeWRIZHNlU2tIUmNh?=
 =?utf-8?B?L3pKNmVYZERreE8wbFM3SjY0Y1NaK29EN3Y4QkROWVNNUmsrTDNHVW1jNE1X?=
 =?utf-8?B?c2VwQkx6cjMzMzJ5dm5uTjlTd2U3YzhLWDJZN2hvWVlXZGx2aXFGbkl5NmdH?=
 =?utf-8?B?eERSQ0c5WUNLc1RxdlloMHhRTk9DY2JJTVJINGdYYXZZRFl0LzQ3K2thbTJo?=
 =?utf-8?B?Qk1rTUw4VmYraktBODJnVzZySzRJSmcrYXRURXFuYVltSnh3cWlSUUN4NzRH?=
 =?utf-8?B?bnkwdGlGc1Y1SHNVbVYzYlJLWmh1MTR3SFBkbWhVWjVXYm9qS0dCNnJoQ3dj?=
 =?utf-8?B?VmEwSkkzL1JRY2hkTGtWbGdFeDBzQWd6TmlOQ3hWTGlrbkFOazFpR0I4eGZ1?=
 =?utf-8?B?czI0NHZaZWJPRFlYR2xmQityVkFUc3dpVXMya2xLdEgzTzNvV1V5VVBnSnho?=
 =?utf-8?B?QytKTUF5ZUtwUlBZQjlqSkNjWWxpckwrUGtkY05DSElNSTJDSmgrQT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: fb96c94a-4b23-434a-0d85-08dec7d58db7
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:55.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KeJJnYhZAezz/nHYAyhK0rlZSZtSUbhr9SH/gttirIE5MGODHoBL/aCKG3L5ebkV276Aw0HOGVX2BQOMMZ9vJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Queue-Id: 799B81C000E
X-Stat-Signature: wut4qtgzbcjomw5ik4qytikk3ypt4pm1
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781194925-867103
X-HE-Meta: U2FsdGVkX1/tmagXv2XcpYcAdktKfSLUXr2LvNsVd6s4sGblILKfLukxDBB+ZiXQ/eIyUGlAuLdZYuvRqDzAAVGwKhlVew4v14j6HUl3zyrXhgsLV4wSzLOMdBtm6t5YTBwbG9Nmx1JWRXHtmby25X4n3gG6P9sTZqLnAeIsoVVJBxz3hiyJHD/aGGkzXUobsaG0NmayZisJ4USPcSQ2tkNR7YQ+6CA0JwCavSTbIVFWTTSEtiumbwd71gq98Z9sa/gvEFXGKVmeUDMjyRGYCsr0KyPFFViYKCwO0UWurXlGbiu/5csuGxQaAXOVIqlRHwJOkcTCiZsmcXIIefyEqckOq1kLYTmzFRKudtpT7Xg9bYq8fuhOHdCHpS5xDbZC0cIJU1qnAJ9/EtiUZ03H/HOm/6+E3HMMuq2IdlqA195nGPNX1kcvKLE2nB4NFVI1gjPQGxLh8SXZD+PlYH+wiqX6+YaRW2AVAaAF+jzhkWYkok7v6O9Peoc0+degqG+oZT0OhQcIeSYEW71MMpFt00ro5YKug7Z5DRogE/ISXjPvATyTi0GG1DwLlyV96nR8lVxJAleLqjeBZuEiEgaUtwHbjJaiDNSCeiED9UKiPknrg0SLABbI+x/NMu7k1F5K0k5BjHSEUhYj1pRcPgy7QQgpZmtn9uo59YsfYPhPJEdJl4zMz3EM4EcX9cZiV+Ti9wd54rbuLKwEWV0caBseBC0cNj+pXu2zJjf5VF9uOq2gTCYcfpC6Gr6X0dLFiVP6waUwsEhKrNZy+JV7w2ESIBBxXaDFDWQZIij8U8QnCic7oypYef4eiZZ6sdYxY2lsUlT1SHDt+ZEKdiTBEyZBu3QcO5l/u9DHT+xbBov5TxROIOvCw1tPYPmJ8D9C21UJ3GRLyKLFBlGZ8EEw8XQD3v/CGx9Cr2AkDtLqVyA4LfzKF5JBqoSp23+ev7kxl1dsOTyLDEot42noNxpJo5V
 cqHZQ17Q
 yCiu64omtvFKrQMxYdIxC3kYypvKKgOsQSmlBEmDdRSUkdZTZJDjf0Mjs1z5WZ6J3DFKhfJdIdcjJNSa2yILDMiSvNJzSAj6Kpk1UNx/WjmAnJbo6/pnM176rcCtsFDgmBatQMFL11X5GBPeHU2EKho/jXDhlb70565JQy4XfA0ZQXNed3j41LCkqMsWLMkO2xVDd/IpxqbiDwhfs4lLMe5jJkKdf0lEidTOwK+zczg4CDY5u8EDIFVf2ihj+oxIaPaNaPrmX3WJA5H4w+D3eZSCC8Jp82v+mmqWzV0xD4pKjd9/LTkyExQgGdJtXHja/YAclLzkqZWZOkM60qGxXL+BUxcHvjvdyAKJ2+2QMYIlA61EWiYiHKdRVyTBmVZh2q9mypN1T0qJA9Ih3QQ3Iff3fE4JKWxQkP/Knw500dGc+W3NX3E3aLDrRcvnZSj+IpbBTK6YLFm7SLLWOwktBw3Ho2u2WjnQTKWC5jQ1x4EiLppopfpynfeGbz1CaU4MjIJa5FiL3NUOfWuqzahGv7HXq3v/i9kwkQWlMdUDeYCjcRMG9vXwrks2qQKO40p8L+PmFBwb2OTNFLqTxcjCYedXEcYFvUhbeTwoPdGUf0sVnChtsl24KmhH+XSk7EueZ1X84n7ROAGZq2accphPLOvLfgOqoboYK0Z607Et5UX9lr00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

C module exercising 1-8 argument functions plus struct pointer.
Verifies register-passed (1-6) and stack-passed (7-8) arguments.

Test:

  make LLVM=1 CC=clang \
    M=tools/testing/selftests/kcov_dataflow/eight_args_c modules
  vng --user root --exec \
    "python3 tools/testing/selftests/kcov_dataflow/trigger-view.py \
      eight_args_c -C 8 --ko \
      tools/testing/selftests/kcov_dataflow/eight_args_c/eight_args_c.ko"

Result:

  # Loaded eight_args_c
  # Captured 6195 words
  # 578 records
  # showing 65 records with context=8 around eight_args_c

  vfs_write(0x0)
  0x0 = full_proxy_write()
  full_proxy_write(0x0, 0x1, 0x0)
  0x8200080 = __debugfs_file_get()
  __debugfs_file_get(0x0)
  0x0 = __debugfs_file_get()
  0x0 = trigger_write [eight_args_c]()
  trigger_write [eight_args_c](0x0, 0x1, 0x0)
    df_func2 [eight_args_c](0x11, 0x22)
    0x33 = df_func2 [eight_args_c]()
    df_func3 [eight_args_c](0x11, 0x22, 0x33)
    0x66 = df_func3 [eight_args_c]()
    df_func4 [eight_args_c](0x11, 0x22, 0x33, 0x44)
    0xaa = df_func4 [eight_args_c]()
    df_func5 [eight_args_c](0x11, 0x22, 0x33, 0x44, 0x55)
    0xff = df_func5 [eight_args_c]()
    df_func6 [eight_args_c](0x11, 0x22, 0x33, 0x44, 0x55, 0x66)
    0x165 = df_func6 [eight_args_c]()
    df_func7 [eight_args_c](0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77)
    0x1dc = df_func7 [eight_args_c]()
    df_func8 [eight_args_c](0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88)
    0x264 = df_func8 [eight_args_c]()
    df_func_struct [eight_args_c](0xaaaa)
    0x16665 = df_func_struct [eight_args_c]()
  0x1 = trigger_write [eight_args_c]()
  0x1 = full_proxy_write()
  0x1 = vfs_write()
  0x1 = ksys_write()
  0x1 = __x64_sys_write()
  0x0 = fpregs_assert_state_consistent()
  0xba5748 = __x64_sys_close()
  file_close_fd(0x4)
  0x0 = file_close_fd()

Cc: Alexander Potapenko <glider@google.com>
Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Link: https://github.com/yskzalloc/kcov-dataflow/actions
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 tools/testing/selftests/kcov_dataflow/Makefile     |  1 +
 tools/testing/selftests/kcov_dataflow/README.rst   |  6 ++
 .../selftests/kcov_dataflow/eight_args_c/Makefile  |  3 +
 .../kcov_dataflow/eight_args_c/eight_args_c.c      | 95 ++++++++++++++++++++++
 .../selftests/kcov_dataflow/run_eight_args_c.sh    | 35 ++++++++
 5 files changed, 140 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/Makefile b/tools/testing/selftests/kcov_dataflow/Makefile
index b9fc1c5f0104..3a42c54e954d 100644
--- a/tools/testing/selftests/kcov_dataflow/Makefile
+++ b/tools/testing/selftests/kcov_dataflow/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_GEN_PROGS := user_ioctl/user_ioctl
+TEST_PROGS := run_eight_args_c.sh
 include ../lib.mk
diff --git a/tools/testing/selftests/kcov_dataflow/README.rst b/tools/testing/selftests/kcov_dataflow/README.rst
index 8b650a62acb1..e93b4e573504 100644
--- a/tools/testing/selftests/kcov_dataflow/README.rst
+++ b/tools/testing/selftests/kcov_dataflow/README.rst
@@ -35,3 +35,9 @@ trigger-view.py
 
         python3 trigger-view.py <module_name>
         python3 trigger-view.py <module_name> --raw
+
+eight_args_c/
+    C module with 1-8 argument functions + struct pointer::
+
+        make LLVM=1 CC=clang M=tools/testing/selftests/kcov_dataflow/eight_args_c modules
+        python3 trigger-view.py eight_args_c
diff --git a/tools/testing/selftests/kcov_dataflow/eight_args_c/Makefile b/tools/testing/selftests/kcov_dataflow/eight_args_c/Makefile
new file mode 100644
index 000000000000..aad45c7e3863
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_args_c/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-m := eight_args_c.o
+KCOV_DATAFLOW_eight_args_c.o := y
diff --git a/tools/testing/selftests/kcov_dataflow/eight_args_c/eight_args_c.c b/tools/testing/selftests/kcov_dataflow/eight_args_c/eight_args_c.c
new file mode 100644
index 000000000000..09fbbbf8d14b
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_args_c/eight_args_c.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * eight_args_c.c - Verify kcov_dataflow captures 1-8 argument functions.
+ *
+ * Write to /sys/kernel/debug/kcov_dataflow_test/trigger to invoke all
+ * eight functions and a struct-pointer function. Use with the
+ * kcov_dataflow selftest to verify correct capture of register-passed
+ * (1-6) and stack-passed (7-8) arguments on x86_64.
+ */
+#include <linux/module.h>
+#include <linux/debugfs.h>
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KCOV dataflow 8-argument stress test");
+
+struct pair {
+	u32 x;
+	u32 y;
+};
+
+/* Prototypes */
+u64 df_func1(u64 a1);
+u64 df_func2(u64 a1, u64 a2);
+u64 df_func3(u64 a1, u64 a2, u64 a3);
+u64 df_func4(u64 a1, u64 a2, u64 a3, u64 a4);
+u64 df_func5(u64 a1, u64 a2, u64 a3, u64 a4, u64 a5);
+u64 df_func6(u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6);
+u64 df_func7(u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6, u64 a7);
+u64 df_func8(u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6, u64 a7,
+	     u64 a8);
+u64 df_func_struct(struct pair *p);
+
+/* Implementations - noinline ensures trace callbacks are emitted */
+#define DEF_FUNC(name, ret_expr, ...)				\
+noinline u64 name(__VA_ARGS__) { return (ret_expr); }		\
+EXPORT_SYMBOL(name)
+
+DEF_FUNC(df_func1, a1, u64 a1);
+DEF_FUNC(df_func2, a1 + a2, u64 a1, u64 a2);
+DEF_FUNC(df_func3, a1 + a2 + a3, u64 a1, u64 a2, u64 a3);
+DEF_FUNC(df_func4, a1 + a2 + a3 + a4, u64 a1, u64 a2, u64 a3, u64 a4);
+DEF_FUNC(df_func5, a1 + a2 + a3 + a4 + a5,
+	 u64 a1, u64 a2, u64 a3, u64 a4, u64 a5);
+DEF_FUNC(df_func6, a1 + a2 + a3 + a4 + a5 + a6,
+	 u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6);
+DEF_FUNC(df_func7, a1 + a2 + a3 + a4 + a5 + a6 + a7,
+	 u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6, u64 a7);
+DEF_FUNC(df_func8, a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8,
+	 u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6, u64 a7, u64 a8);
+
+noinline u64 df_func_struct(struct pair *p)
+{
+	return (u64)p->x + (u64)p->y;
+}
+EXPORT_SYMBOL(df_func_struct);
+
+static struct dentry *test_dir;
+
+static ssize_t trigger_write(struct file *f, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct pair p = { .x = 0xAAAA, .y = 0xBBBB };
+	volatile u64 sum = 0;
+
+	sum += df_func1(0x11);
+	sum += df_func2(0x11, 0x22);
+	sum += df_func3(0x11, 0x22, 0x33);
+	sum += df_func4(0x11, 0x22, 0x33, 0x44);
+	sum += df_func5(0x11, 0x22, 0x33, 0x44, 0x55);
+	sum += df_func6(0x11, 0x22, 0x33, 0x44, 0x55, 0x66);
+	sum += df_func7(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77);
+	sum += df_func8(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88);
+	sum += df_func_struct(&p);
+
+	return count;
+}
+
+static const struct file_operations trigger_fops = {
+	.write = trigger_write,
+};
+
+static int __init eight_args_init(void)
+{
+	test_dir = debugfs_create_dir("kcov_dataflow_test", NULL);
+	debugfs_create_file("trigger", 0200, test_dir, NULL, &trigger_fops);
+	return 0;
+}
+
+static void __exit eight_args_exit(void)
+{
+	debugfs_remove_recursive(test_dir);
+}
+
+module_init(eight_args_init);
+module_exit(eight_args_exit);
diff --git a/tools/testing/selftests/kcov_dataflow/run_eight_args_c.sh b/tools/testing/selftests/kcov_dataflow/run_eight_args_c.sh
new file mode 100755
index 000000000000..d24092e920ff
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/run_eight_args_c.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Test eight_args_c module capture via kcov_dataflow
+DIR="$(dirname "$0")"
+KO="$DIR/eight_args_c/eight_args_c.ko"
+
+if [ ! -f "$KO" ]; then
+	echo "SKIP: $KO not found"
+	echo "Build: make LLVM=1 CC=clang M=...eight_args_c modules"
+	exit 4  # kselftest SKIP
+fi
+
+if [ ! -e /sys/kernel/debug/kcov_dataflow ]; then
+	echo "SKIP: kcov_dataflow not available"
+	exit 4
+fi
+
+OUTPUT=$(python3 "$DIR/trigger-view.py" eight_args_c --ko "$KO" --raw 2>&1)
+RC=$?
+
+if [ $RC -ne 0 ]; then
+	echo "FAIL: trigger-and-view exited with $RC"
+	echo "$OUTPUT"
+	exit 1
+fi
+
+RECORDS=$(echo "$OUTPUT" | grep -c "^\[ENTRY\]\|^\[RET")
+if [ "$RECORDS" -gt 0 ]; then
+	echo "PASS: captured $RECORDS records from eight_args_c"
+	exit 0
+else
+	echo "FAIL: no records captured"
+	echo "$OUTPUT"
+	exit 1
+fi

-- 
2.43.0


