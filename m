Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B356EC9832F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 16:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8CE6B0005; Sat, 17 Jan 2026 11:46:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886826B0088; Sat, 17 Jan 2026 11:46:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713786B0089; Sat, 17 Jan 2026 11:46:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB8D6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 11:46:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7BB459000
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 16:46:20 +0000 (UTC)
X-FDA: 84342033720.09.CA97FA2
Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022139.outbound.protection.outlook.com [52.101.101.139])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0D698180003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 16:46:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=AMEHoirg;
	spf=pass (imf06.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.139 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768668378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hq5s/LOsqIE1ks8m7CEkkgpeMm+ZX7wXRfUhr62MMk8=;
	b=tw07a6vv66IRjYrxbLVZg/mkGUfYmUueAdGWPc1AuER7TFZkLvJTsDGff09skgywKgCVOS
	amm/efgjSWUs9waZTSUCik44/20AqCxQQX0T0rwtPBYaDcnzPppriWNpBK7gvhSKrY7pgt
	Lnh60HlMMmz/6hk3lTMakXT6hoha8pg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=AMEHoirg;
	spf=pass (imf06.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.139 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768668378; a=rsa-sha256;
	cv=pass;
	b=7pG7BhCs4Kzo6r9F/UjXegfnEoN9TlwEeKgnqQgKqcfMnsptDoYYmGCUz9o9zrUeK/pd1N
	MzMf2Jyqc98Cv0byHcGoGDmEFJtQ7w9GXssJ9nZKuup1sdnW0nC/wRY3Z3jw464QyBlMpV
	U5wyMIqCgtF+MxyeKPvQhZot7GBNiEw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OXZLiSuhSy1YwC2tVAWxv5haW6DF/Zs8HxhoIHZqF6AfeTtNyUPVxTgYPJNuAskLaHsPm1Q0ogr68WxlmYQDWc9fDK65KgRs1x2ug0Hs8WvCY4RhuI9n0SWDYGocpUcx68KcsloAIDrvYLXvHZvlll0Dax6Pb9qoT7adDhqRNhkT1i29wZWwuEqbZjKtui0+RDiCuE4dfh4muPHO15HJT4aZLZXd/CCziJyfbLTkIILiLQuMUmkp6u3taW2gdwme/zygKEn7r+OwyEclOLTjIsci2+1xzQ3d/0SMnIrTGQFhNcRDKWxVjwKaj02oQy127PMOQ4mTHNE3R4+sL1BlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hq5s/LOsqIE1ks8m7CEkkgpeMm+ZX7wXRfUhr62MMk8=;
 b=LP0LgZMdIYcuKRNFvNBdJebw5CsWFkUi0pIzI6w5XOmDkkiHAqWixK8FEnJgAwiafo8tECuzAHfI9LTih9T87rxWmaOsezGeSneeNRWCP38GwbItpkWx/rpYldMIYRG9pbApSLJxTkmc9h8lHjl8uYbB7uUu2BjjTTwegbsxzAO/JG7rL6THuIyRR9kQTNJ7kxAWzbV0cGFVxJ9xCN+QJgaqURhV/UeEMrMoSqGWttifN3QgDjqiruV2gYHfFmtfWmNUF2hU09uKoTgYOa9GmvUa9+y7poF1nPORqN2CFSPJltxap9GF6keb+29EsuzPOd8ac7SMWt+RIeMUgXnlvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hq5s/LOsqIE1ks8m7CEkkgpeMm+ZX7wXRfUhr62MMk8=;
 b=AMEHoirgQ6WTMOQwrGt7ry1obVkSEpJk/1QHb1qcKLmhKBGCfqX18/miHmCutIiePqM7qyYVRebg+LQJvfcmjjojK/MJHX5uI7x4k9bqHruquhL6mdD+DVB3cnWd9G4pGt++1684noEIaxHHi6IHbsM6nHyKza/7Pw0wm4Kjw2U=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO4P265MB6350.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Sat, 17 Jan
 2026 16:46:14 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9520.009; Sat, 17 Jan 2026
 16:46:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Jan 2026 16:46:12 +0000
Message-Id: <DFR0M1EO7KHO.2SQJO7S2NXC3P@garyguo.net>
From: "Gary Guo" <gary@garyguo.net>
To: "Boqun Feng" <boqun.feng@gmail.com>, "Alice Ryhl" <aliceryhl@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Gary Guo" <gary@garyguo.net>, "Miguel Ojeda"
 <ojeda@kernel.org>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>, "Frederic Weisbecker"
 <frederic@kernel.org>, "Neeraj Upadhyay" <neeraj.upadhyay@kernel.org>,
 "Joel Fernandes" <joelagnelf@nvidia.com>, "Josh Triplett"
 <josh@joshtriplett.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, "Lai Jiangshan" <jiangshanlai@gmail.com>,
 "Zqiang" <qiang.zhang@linux.dev>, "Andrew Ballance"
 <andrewjballance@gmail.com>, <linux-kernel@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <rcu@vger.kernel.org>,
 <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 0/2] rcu box container for Rust + maple tree
 load_rcu
X-Mailer: aerc 0.21.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local> <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local> <aWuKlR4a-VJhBeWj@tardis-2.local>
 <aWuOtUa0mPDrnbke@google.com> <aWuXHkGZlMvr0uxD@tardis-2.local>
 <aWutQuJAaBXG2JY1@tardis-2.local>
In-Reply-To: <aWutQuJAaBXG2JY1@tardis-2.local>
X-ClientProxiedBy: LO4P123CA0108.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::23) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO4P265MB6350:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab56a88-1da6-497a-1656-08de55e7ed47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cW9LN2o2eGFsYU9aOHhiOE9qelJLSi8yN2syendNV0hNNTFlNG1WMG1tRnV3?=
 =?utf-8?B?U1dLSmV0YmhkQTNESnFHRWRhYkZFS1FBN1RUNUpIV2RvWTN4cSsvOGkyUzlB?=
 =?utf-8?B?bEhuU2xXMlJMSk9yTG5NMWJJbEdac3p3TG1BelFhenhjYS9CYVc2Yk52VnI1?=
 =?utf-8?B?ZmxWRTFhbjZvYndYTFhQM2hZK25OQU5kOWRnREtHL3QrZUUvRDhMVVVBcnVx?=
 =?utf-8?B?cW8xbkhEanlBYWlZRml4SmJGQXNnRWVDMnZ5bEZXSWdLaTZKRW4xTmErcldH?=
 =?utf-8?B?ZnZOVUI1emxwbVZheTdNcjdnaTAwbkRYend1NTR6M09DZlZTcU9LSG8yVFgw?=
 =?utf-8?B?dXU4RzJWL0Z3MFF6WFJaSTJKeEU1eFJSQndLSSs0TVM2OFQwbTlzcGtlczFD?=
 =?utf-8?B?NzV5TmJKYTNmODQ2cFBBdDZFK3FEODcyei84a3M2eDFJTFY1b3dnV1c1QUli?=
 =?utf-8?B?KzM5Um9DMGNsTGQ5NzBISGhaYlh1bWhmeWdsM1RSYU1kdDh5TFFsL2NETVZK?=
 =?utf-8?B?Qk5OK2N2a1lMNS81SXhHem1Rd1BBTGtlZDdHTS9pMmtvbDNYQXNLc1hFMEpa?=
 =?utf-8?B?cEx5WFFLSWovZWtqczkzL1dZY2gzaHU3NTJDR3Jma2ZCU2RYNU1Ybks3SlpC?=
 =?utf-8?B?d2hjdmVlRU9vTndHRXM1MVRIUU1YNmJaUFZtTFR4UkE1ZVNpZlFhQ1RMSVda?=
 =?utf-8?B?U2JGemVaQnJzTWlVeHZoU3lLbWVac3hncUdsMnJNQTc0Q1k4SHZIMEFaWUp0?=
 =?utf-8?B?V29pdHh1djBXL1BpZHRUeFBlaDhiZHhza0IxQWdpT1hpSWltcDA2UGZ6ZXpo?=
 =?utf-8?B?b1dQMDJ3NU9HNk8zUjFrRDhKT3N3blppYzVSUFUxaXppclRoNHErSG9sOCtx?=
 =?utf-8?B?Nys0aWh4U2ViVU9ieHI1UnJxNitaUkxvcCszS3dhZmVnY2k1Y05TczR6OE8w?=
 =?utf-8?B?dHliT0l4azgxcjJydnVBYjU5TVp3YzVIL3FWQmZwOHpFRVNlb2xrYmc2S1Nk?=
 =?utf-8?B?dmI3dFJ4YzMxcHpxaUViTzRHajlFbVNFODZ3SXhaVXRSZDVRQTJNZE9RYmdZ?=
 =?utf-8?B?R09uNmhDR0VSY0pBaXVlTmYxQzMwUmoxU1dKYjd1RUxrbldrM2FrTmRPWVlN?=
 =?utf-8?B?REQ4Zmp1Vk1ldERROHZMMWtMb3ZUR0pUVVdJOHhiZThhVHlPYnlGbXlvTm05?=
 =?utf-8?B?ODdYRTZ2Yzg4b2pWdjkyZWRaV1RZZzRGVXFuZEdrek5zcUZYSGViWUZwRmph?=
 =?utf-8?B?U1QzYUNXQnE0RlNmTWdBdnljS2J5QmFyTlNHN0ZnblhpciswTTN4djIxNzV4?=
 =?utf-8?B?YjJQSkkzT0RlVkZxdXdJVnBqeWh4Y2owWWt1a09YYUUzVDVISHJ5N1lhbEFJ?=
 =?utf-8?B?NGhWRy9LeTNKNzE5ZkQ0YXcrSkJ2NEN3ZCtTU2lRNnZ5cEpTRXk0Qmd4MjVU?=
 =?utf-8?B?N0ZvUmY4Q2hoMXhBLzVlOEJMUmozcVlvSjlvMUZuOWlscy94QjNyU3NoWmYv?=
 =?utf-8?B?dkVyYUlKVVM4VE1ZSDdkditLYXRxU0FuL1RNSEVIbDVQbm03ZkxWNmdNRlJs?=
 =?utf-8?B?TlZxUmVVZUVUc056YzZkUHBDZjZzYTZBQmN2QWNSaGxOMzB3MnVjZHQvam8v?=
 =?utf-8?B?OWxJcnowc09FOHBJTzMwZjdOWEhPc2EvYVVDYWd6cVFmMWJvU0s4ZDB6MUxB?=
 =?utf-8?B?Snd4WjZkNGpDNTQwSEczUDFpQlh0UjQrUXFrRW14Nm5LNjY3QTlGdkhrMlZs?=
 =?utf-8?B?d1hyNzZybXpYZlMzemE3b1NTWE90ajQvU0FUSFB5MXNqVFhzM2M4YnVoSmls?=
 =?utf-8?B?VXJLQ2ZJeEdPekFkSWZTREJ2d0orRnBBYkk0Z1hpTGlyaU5NcDgzYkorWHBJ?=
 =?utf-8?B?V2szSTlNcFVCck5tNlN5Q0ppZHVjM1UveFVGUGVGSllJMmdka2pTMnQ1SkVE?=
 =?utf-8?B?VG1hZUhINDB0OC83clo0NzE0TkpaUUNLcmVrUUVjanhtb0NtSXVpNk1qZmdI?=
 =?utf-8?B?OUFTTEZETVlrUGF1V3BHU3lrbDhWTElOa3djYVkwYmlndzhhSDNMMWFIbzdD?=
 =?utf-8?B?b1hwYzVuSjBmKzlhdzczcWVWSTRzbXREaFNSL3VYdGNoZnJDVXB0YXFmbUxB?=
 =?utf-8?Q?CQNE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVM4aWFZeGxaQUdySHpROEQ4Q1FvT041R0VXMVdNM0RldW9FQWI4MnVMT3RP?=
 =?utf-8?B?b3dCenNlNFVJSjEwNHF6cFdBNkFNUWJiQlQ1UGNXTmprMzNPNEtuOWc2cFV1?=
 =?utf-8?B?VklkT0hLb3Vha1k0dW0zaVVhcER1YmVlOS9WcHcvN1lCcFNYNFkzL2ExblB5?=
 =?utf-8?B?cE4vVkZBZHdlWFFqc1ZCeVZROVNGQm1La2pTczVYWFlKS0hBVHhNY0h0S0g5?=
 =?utf-8?B?a2hwSDZtaDhlakJoa0RVRjV6SzJZY1N6bWJRbHl2aDN2L0gzNGlPbUpYdlRO?=
 =?utf-8?B?VktOVTJuMENoWHVsTmxQYzBJbnFyOVZlbmIwR1dYek5WVGlDdnhwUzl1d3ZW?=
 =?utf-8?B?WWJtaVFqL2ZUdUIyanNpMThWN2tpVVFqbUdpMng2Z1pUSHRldmpRSUlVTWx1?=
 =?utf-8?B?Sm1Rd1UvYnRnemdYRi9XRi9qMlVpc1JpM0Z3a3hEQWF3SWxNeVVkeVJuN0pE?=
 =?utf-8?B?cDVtQWVjdEFYZHpyeU1hczhDUmViS05wam1CSGFTQnRUdEN3NThtZFFTbHRn?=
 =?utf-8?B?MXdTT09mU1g2M055blRtMnUrME9iRCsxS2FnNlpIQlo0c2R6VWRHSDVUcDVs?=
 =?utf-8?B?T0hWdFFLZWhnZE9LU0ZUVXQ1MzlZVzc1Y1dnVi9iVkJrS3h3WWtmQVR2Q0Q4?=
 =?utf-8?B?MXoxYkkzclRuOXNuVmxSSjYzckN6YnVQSGk5SmtiTCtYa2cwM3BIK1p5SFdj?=
 =?utf-8?B?dmI2aEs0cWM4VWpMNUJkLzRkRHpsZHhvd0t2clF5Q0h5RG9VZS9vMWxkYmwy?=
 =?utf-8?B?UEN1RnVMWk9sVzkwLzNlSEFtSllyYlpHdzFoVVVBVVZ3RmVzLytFZG1jYTJl?=
 =?utf-8?B?U1NubDZ0T09IOEVJU1ovekZMMm1oMVdYNEZEcEkvc2RqWDdROGJEalFsaUpz?=
 =?utf-8?B?QkxpK3ROeWg5NTJ4M3RDaTRmamJsUWVYRWxRemdsVFdHUXNRdlBPSXFsb01P?=
 =?utf-8?B?dVdnVER6MHZqdXBXKzI2REF2UHBpYmhqbEMybWMvbnNWT1JhVmVBZTRkcjM5?=
 =?utf-8?B?aEVIbERjaG9UMHlFUmpDTGlnN0NhcU1XRWdBS1FwY284aHpscDl3UGNEa0Vj?=
 =?utf-8?B?bzhxSWF5b3BHamNiOGRiWUhWMkpaanl5UThDTXhiSGhtMHpXdjNrU2ttb2RQ?=
 =?utf-8?B?RzlBelppYzlFQXlxSDU3REQ1aFg4UlJud1ljdTBIVzM2RzZRY2pTWTJRM2Ey?=
 =?utf-8?B?TXI2Uk9ON2dMck5hZXlVZ1pNZ1l2Wm5rQitnNWN6dThTRDlyeEg2QnZwbVJB?=
 =?utf-8?B?YnIwcWZXNVFYK0lSUldtVWpBeXpiSWJVeTRqNC82OHJDTXA4NGpqZGxkOFFr?=
 =?utf-8?B?T3FjSzNtdXpUT0hnWStGUlRzMDlTMVZSYlNvNUliQXNLQUJSOHBJTzczcWJs?=
 =?utf-8?B?cVFWV1ZzWkpoRHNVY2dXUmxtU3J1bmJxdXJCbkoyUlMwTFR5T2hKdnYwQ1Bt?=
 =?utf-8?B?QXhFVlU3azFlenRkY1IzazNtOUgya013WlVEUlNlK2FOczhCUlF3WExnb0lQ?=
 =?utf-8?B?WnQrMWxsM3VxdHZIQ25WU2Y5ajk5NlVpeWhUR00zL2Jtd3ZPU29lQXpIRlJG?=
 =?utf-8?B?Qk5ya0FrTmlmaFBSQi9WL0lreXdqdHY2NWJrRFZHVEZWZGQxdDBjOTYwWWRw?=
 =?utf-8?B?VUJnbmtOcmNMZUJ4MitBT2Z3QkhEem5UTkZQQUZoUjJXZTNGeWtNSm5ybUFp?=
 =?utf-8?B?c3FSQ0VNVDAyUmZRSlRDSjduekZORlpFY3NSai9RZ2IwbGV2TGllUmM3WUR0?=
 =?utf-8?B?eFJVWld6aGFFTTN6dEh3QVNRK2NEV1R3Z3lVcndTS0EwZjJJcEIvbmFvUncr?=
 =?utf-8?B?UGRSU3JnM0ZEZ1o5V3lGNjhHVnI5UXN0S0pPZkdQTHVWWm1GdXF0UWV2UzU1?=
 =?utf-8?B?dWJQcHh4SVdCSW9GVHBNYTVxQU84RThsM2dpT1VtM2hKK2hDSUg5Y2lsK0hV?=
 =?utf-8?B?bDViR2djZXpaN0RQUzNubkNDdmVZaXFLUDBuYjU2YVNDNmZhTUM1cWFhUkpq?=
 =?utf-8?B?Z3NVMDExNndSd2NhS2Nid0IwYW1OVndxQy8zNlpUNXZmMjNCcUVDeUNDOGFl?=
 =?utf-8?B?cDNHUUZtaGRCOVlJbkVZcm9vZForS2RRcTMvMSs2aW9KSzhHaEVOVDNCckIv?=
 =?utf-8?B?MG9QT054aGNMSWRxa0ZDZVRyektQcjN6Y3MyRzFUYTl6Q2l0RDM0R0JCalhy?=
 =?utf-8?B?RjZLUHZSVUJiLzhDTHp3WGJMcTdlYVNRSjhhWlJRbG1JVThudTBsUTFmazFF?=
 =?utf-8?B?cCtKNkM2d01uSmltZkZaTTZrUHV5V0g4QUlWVkdxdzBlQThJOWlidnk3UFJ5?=
 =?utf-8?B?QXJGd25kcWlaTjJsaUZ1M3hYdHNqNk1QTklwZm43UUszOFdGZXJyMXI4c2pF?=
 =?utf-8?Q?bo9XPejP0eZmSXo2Ld1RzT8Adk68RliWKWMyU?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab56a88-1da6-497a-1656-08de55e7ed47
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2026 16:46:14.0807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDpkXvXfqf6fQhVIx8XsD2N6+AB2NpG1Uof2VGO9CTzQ9q4fminIRtwQN6JupSQk3E7xAWB+njX3DBKjQH04MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P265MB6350
X-Stat-Signature: wipdxi9jqgwkbbqi8614zu64pseycdu9
X-Rspamd-Queue-Id: 0D698180003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768668377-368614
X-HE-Meta: U2FsdGVkX1/BCIjYQ49tGJseP6yqGYw3T/EzeiGCDciDRz/n0dXQ2Smq4JkNnDcqtp7PbNaFSZZWIdL6Xl7CdnSZmZHd9ctMMdbXSwXkYbCBjeNnsEdpR7bHsNkZi5MRrxz3Id1a9aT4auVCrWKHU7OaoC+S92Q3ofHSu8Y01GiTKKMU8MJhWjadCKIfWuIOhyHgcqUTF29Cz/ugdCiK7FNIHnK2HcJxgfR4aFdFQvobz1JujpBIO3C6W0WG1wyUqer+oQp5IbLho6jr4nmrB51TVGw++SvjxVScxE20aYbISx4LuLtKH1ONlI9lSb/TGbICxlx1vpTji0YuxZ6Y7keb7613PX4QxqgwyJ4jphVso2Eq4Zry+bqmns75+l0grVlegup0VHpz0aoUgS6XAbQFzzPRAmNmX5owNGkplh6yt6ChK7Wb7UHqxOBG4x6hzs888anVSH10u6EXCFFnu9f3pRp7SnRnqtThph3LtiT2qcJAmjJsHG9rJ6fSKcq6XLkKOrdcbVE9V6/3SOeJsHg/GntApouTR+H2And5lUkVOa1uOl9wCnUfmzhp/eGYHDuriI/BcdlGWxZ223yFYt2H2xJtDxOSblTJQzdm1dqv0iq1O96KVeoQINFsFcDT/eMufmSzvfT4Fb2GRE6b3OYE+4VOfd7XXLH07HF1hVLvsLSKOxrnf1grFwjh6ZZtvfVimVtW0hQTj5PnvNMAqwQfnz0t9pko4eQZ/B8A3sLjJIliNF2NIpYqSKhHVhGXN6Mq43OLy0cYARPj8eLy4gLCO8YRsppdp6yuFe2VbL8t/jCpnNzR6NMf5zZsGjSiUvGp/DB2JzUNTs0L/5t/DsMe6f75kOb9JeVRBwYnlv/WQqRsVFKe7DsvS7Lol7h5F73vhAtYlUonnW2kKr1mfkH21Sqs+nxOb2DNEa9jh4X1kVczCsFTShHEaeX2nBRp/luwzUiIEGNa6U/NE8N
 Xqq6etHr
 mDijXOofZT2oIipg9x/lbUdIHl1eFszDg72pVZVpYK/1ac1jQ1M+scafzzvKr+aUoM8V/odH6L8DFgfzZpbRHoHMDv/GTFS2EOMh0E8guyxpBAvbk0L2Cjd+onQy/z96LMFPsZKfOVV5QEepCik9rmUhzWiKdtPrM19NBwWAmiUi5wwtKsr8fZzD3LCsuZZKWgtP4TS+kf9puz0TZCU49s84Py3SgosDhfYJmiNNQODqvbZO1jsvhc/CW//eN1JD2J6Scj7FzydDgtpHarTGwFS1I3wRJbNJLDTIXrmb8/Z9a4S6REV4SjWw0UeulLtaiuw9ctddL3G1QnTPIdALKFo8ksFJ77ExJYUHfkc5Tw43IrzsY5p+at9MQpxbi0yMtPPIJZQT82AqhfXsK8yUY9SR6o0aPCGBOor64mYdR9vkiGGn7O1oiCwJQy7RmaCyM+A/dUcWwxcYoa7GsnLGQRuaMR1hmrGblfdB2cXAZRpfXPiM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Jan 17, 2026 at 3:39 PM GMT, Boqun Feng wrote:
> On Sat, Jan 17, 2026 at 10:05:18PM +0800, Boqun Feng wrote:
>> On Sat, Jan 17, 2026 at 01:29:25PM +0000, Alice Ryhl wrote:
>> > On Sat, Jan 17, 2026 at 09:11:49PM +0800, Boqun Feng wrote:
>> > > In Rcu + RcuOld design, RcuBox is just a Box
>> > > because these two pointer types handle reclaim + accesses.
>> >=20
>> > How would that work? Dropping my RcuBox<_> must use kfree_rcu() or
>> > synchronize_rcu() or it is unsound. So it can't just be a Box.
>> >=20
>>=20
>> RcuOld<P: ForeignOwnable> will call synchronize_rcu() before dropping
>> `P`. And I think we can have an asynchronous drop pointer type like
>> `RcuOld<P, Async>` that requires `P` is a type like `Box<HasRcuHead>`,
>
> One blocker on that is Drop impls cannot be specialized. We probably
> need a different pointer type like RcuOldAsync...

I won't be too worried on this apsect, you could just branch on a const in =
the
drop function.

Alternatively, we can have a method like this

impl<T: HasRcuHead> RcuOld<Box<T>> {
    fn drop_async(self) {
        // do call_rcu
    }
}

Best,
Gary

