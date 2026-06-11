Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D79CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72336B00A5; Thu, 11 Jun 2026 12:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EA46B00A6; Thu, 11 Jun 2026 12:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7066B00A6; Thu, 11 Jun 2026 12:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3A36B00A3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 466111C27B8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:11 +0000 (UTC)
X-FDA: 84868148862.26.0B18477
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 572A640006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=z6nIDQJJ;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXxDoiqFPBn7Gh8AwleiDDC8ndob1oNAc/f88nP72Uw=;
	b=lENw0TW7/kEfXO/BJw5yT6xLYgGfgYbjybGW1xGf3Cl/VQWXJonH+U4RHFGdIQHgSiTBnw
	mgKrt4jNIk4acUcObzZWMj3ivWS6SPWKGgFlPE7Lz0oSR127ej0LWsK6cMUMSFLpmu6/hc
	d3MZGz/48TVs2bRyG3XBFPdlXrHUqXI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=z6nIDQJJ;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194928;
	b=YO9QbY9H2Ph7b8T9dct35r79W+ZlK1BR3i7aJpZRwttT/z6PrM9lWAG2W3QTBEErnEAYFt
	JBLVvGgEh7RpUNXeHj4TNAtXvlbXbX0uwFxKxVyiSx7JNU1VV81473th2k89vsrTjGmqqK
	LrdsY6qrro1MZ1NFz18NPD5z2eeau6U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ImbpPvCvG3XRJv2KTuLQyU6cXnz/bfaOXhM8BkG3i67HHUUQ0+SI9GPO7q2Nv+2yLi6OLY9oZg318QTicPJwtpONtSJkmRC5acG2GnnxeGJvkhRrWMIHY+oGdL2H2apthjA29XSpMggjNj3ZabEOF/pdCGcskzxqRkvYl/hOlKsVK1MJQBIeC9hDZ0XC3C60GYrb6rVv3S0RbFs92mvjdRSJvs9cNlq7a49+L3Cxy1kjcKraFAT0Che94TAQ5qc0NWwwE7+Ari2brN2NegcfSNTvsC0AUwcVmkC8k/3NHVM6n/w4VRXDrAKdvwGRfsslVGNDA5Gc1jnRSub0Cbt//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXxDoiqFPBn7Gh8AwleiDDC8ndob1oNAc/f88nP72Uw=;
 b=SNodKEq1mu/oGpLcX7vgVeAlYCR1bt3Jtxz21iKxWMExgavo2iRYlBJvSDSjbA4KYZD5OK3Pr8Vz1kp+mOn3l6YH981ffnaUrVt8Z9Yi6sOze71l0IN3UUsNvgCFwt2bT1oQr5rYzXEAnXbgZ/eABCMzikflZBaGd7jEgY2Zi/6e7ur8AhdN37kL/zWH5ZFBUr73wZV9C9skjyzYZvr75tWT72xpM0yAkcdQxO1elw78AuoYj5+HwlnWJKapCe8/3kZeeJboPObqlKl8I6O9uu+YteBMxto9Witm/v/j34GxyqtjzvW2DHZ/XNCV9HM/qq8U/xfUpanyILPhsm0MOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXxDoiqFPBn7Gh8AwleiDDC8ndob1oNAc/f88nP72Uw=;
 b=z6nIDQJJ6ZfusYVwyBvGjumkJ5UQvyJCmNeHdIvXB2ZK3P0WkJMxF+J3v6ci/WT+NkH+3NXA6PHNDfjUR1siYRl0/EVV8R5SBnl0tO9zq5rxoJtiJdQMMgH0UOuth7Z6bZBiiEPf72pYbdnNu7kbjV33OzxJ6dzH7ZmnNw326JlWeJZLZ5tk6Gwu1muRg8y9SYcUOO/nwVkai89ZXOJWAqmUo3drtgj1Q/CB4R7Tb4bszxC2CfWUDHLfiAATXbtBNxbd+5fLBVagQ2ZaI76tup53dEdCCMUfKkIhed7v4NtT440hB4PZgMM29cCCKQaF2eKc4oaNL5MKNAp7j5pvQw==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:57 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:57 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:13 +0200
Subject: [RFC PATCH v2 11/14] selftests/kcov_dataflow: add eight_args_rust
 test module
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-11-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=9294;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=++Ocp69V2+ssWb+8fcntzlFH2d9U7HbUzkJAMdwtirc=;
 b=XFUAXMnfJ4atgczymD9v9L2GOcegffbVHv196KyruS1AeYxDKaWBg+VY2XLLsstyTjLNOrzDP
 xhYNsOsroEdDKOA5rN6R4wpZNeLmfX/LnKXlkP8T4mTHcOJ/S+dPY9k
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV3PEPF0001DBEF.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::31c) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: cb125fa1-66cd-4f61-59fc-08dec7d58ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|5023799004|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8eR2uqVI0e1ZUCI+OSN9Qqgv7FklNAl4e7fZoioOI07xny7OLmw21AK3veRJq+Ow9apZYCGMiY0cbUfAFWH8AJWEkGCZC2JB224fW9Kvdbm6CU4uSEkpbk3Pf1N9X8T6Yw19h9XbJeR+qYulv1NSza3wT6pZnCJgGca330qJqH4XjsHT3h3/oIpwjeErPGcBRMqo3k7WptQG3v4dcMH2LakuUSB4rEdOI703RCHVKiNr/gouCF8oSlbp/fZ5KC8E6mHLvN08bPA1dkNJDCh1B4n7TJxAO6dTh0GB4cAmFZ8vaLWNf/85nkeik0AVKZ7mIjeg4xgXsQjqNfdpBJjQi/hYRgg50VreZa68lPDdddrZiGLvwYp+sZpUOgWVfSipDls5uC3Ou5j68TikW4uolsP+Ti5YQk6zj0uaeejJKV0j+oFpBl/s+IznX4JocOP0Edp/iSJ6oSIgYLPShL1Wd2283kAb7Pd9TqPsrbVgBRjx/6f7xo5cd87h+jwsbaJxfyru9j3T81TpEWQ0VZuIJNu5yl7Nlf50fu9yzHVfp/UgqENzrij1vABs9uBM1vBZ+/Yb3YNEdL3pGNI4bStOpB0rp58Pae391Cv7WtmKMHDBDG0X/HRZCSrAyFs9V3pDeMU5p3CuxRAJJYMDNFh0dwqqYAdRhbWkYUwCYjMtXDL2IrOALiRihd6dxP9NQf5F6talMfmQRABtIGMzDpoezrfuM/Q+EOzwuRFmnriDx5vibjIxPqWtafPJ23HI/WAo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(5023799004)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXdhWUIrMHExRkZtWE45RFpYdFJCT1lnOEh3WlAwZUZ3Znhwbm1DRDJNWDUw?=
 =?utf-8?B?Sk1Fai9kOG1DUG1lMXhCSE5aM0lqL01mSjQ4U1VTbG4zRjlCblhEdGlyeG5L?=
 =?utf-8?B?amdkWUM0L092RGVqK0pKOWQrdE54MmVUVnpTWXpCS3lPS1ZQVDZ4Wlcza2Z1?=
 =?utf-8?B?UkZ5eENWelY0d0Y0bkJTUG1oSGVJa1U3ZHRrSzdtS2NjdXVRSjNsMFFKb2Rn?=
 =?utf-8?B?R1dtdks2QWJUMldJeFQzOC9TQzZBWXlEVTl2ZWdINHV6U3hPbWZQRGdRTHhQ?=
 =?utf-8?B?YTRjemFRL0N2MUxOOWFSdS9lNWtVYi8xd0lYZFlBV0luMUlFRkIvYTlVTm5Y?=
 =?utf-8?B?aU9DVyt3alI4bWE5NDBqdmhMWUpDUUN6WHk4bFlKbG1EajFiYjcrS3hvY1A1?=
 =?utf-8?B?ZmdLa1Bnb1Eycy9YZHZvMG1wZi9NR3ovUW5Md0NudW1zc1Z6YUw5alNCWVFh?=
 =?utf-8?B?YWlRT3pHNWlYRVZoWFVNTUxFL0ZxVmM1enVvZklERmNTYm5RZGIrTmtwV1NO?=
 =?utf-8?B?eHEyQ1FubVVPZDF3QXpkcDNjaEVsbWloZ3hmWElzUHJXcFkwY3VzekpIMFYw?=
 =?utf-8?B?RHVQR0tTZTF0bDFFcWJtOERESzlLd0JpU0hrOXIvSXV3Z1RYREdiNnFkZkM1?=
 =?utf-8?B?d2xKeXdlS1IyZzVKUk15NE51cDE4T0o0MHBJZWhjT2tJWU1oRmhBODFrMU1z?=
 =?utf-8?B?eTFhUTBRWldlQUl5L3hpSlRKbzBQZ0M1TzRSSHQ0eUlrMk9PNUprQ1FaL2Vz?=
 =?utf-8?B?K3dCejlVWXMra0FRalVnRE5GSVBSWWRBZEtud01pYnNhZEJ4UDVnTHl6b0VF?=
 =?utf-8?B?WTlCNVd4aGtkakNJc0xvMHd1QmFGdzc3dENyZnF6QXBGdU80SGE0UkUzQ2Rr?=
 =?utf-8?B?ZEVyajJpaGpRUVBhUk1YeHBRU3ZuY2tlQStJZGo1TWJuK3RLRlUxWUFIMzJs?=
 =?utf-8?B?MHFxWm9CWnZ2Z0JiR29IQ3JrNURLZ2w0cnFFQ0Mya3p2MW04WVowL2pJQitC?=
 =?utf-8?B?dnNJMWJqR0pFUHdlZ0dYTU9rbXdKSVY3WDFDUk53ZjdWK3JKaklMMFJEM0VC?=
 =?utf-8?B?dWRzQWRTdlpoM0NINklzK1dmK2o2SVNQTlBqVTBQTnNIV2JrbkhtM1JydGJG?=
 =?utf-8?B?RGNrcllweCticzBnRVNLck4zVkZRbUZzT0dTWVFFNjNWWmRaVExra1JXNHJE?=
 =?utf-8?B?Q0RrbGduOXNaNlZydmNzcVFlUG51M2pZaXdmSDRSQjYzMDN4WExDRlc5Y2RG?=
 =?utf-8?B?Ykd3d1hvOHp2S3hMYnE5cnluMHJxamltdlZ5QzVDN01OcU50YmdwSmR4Z1hz?=
 =?utf-8?B?bVdoa0RrYmY1a1RsWVloWXN1azJBTFQxMFNiN1ZhcjN0TS82UXIxcUpheXky?=
 =?utf-8?B?cmZ6bDNraEZad2ttZkYyeWZkMzcycFlQQW4wcE9XQ0QzNnpFSG5mUFhDSERu?=
 =?utf-8?B?MmNoK2tQTGdSSFhqREthbE9lbG12MzlDMVVNSWl3YmxjeVE0TkdtSWM2NkpT?=
 =?utf-8?B?ckhXZFBkZC9ZZWNUNXlqQzQvS2FsMEo0cFNyTkZMSjBxaThqQjErdG4zWnVY?=
 =?utf-8?B?eEVCZXJEUitIMTNKb2tnR1A5ZlRZbDkwZnhiV0JPQ1dLalZ2NUR3YkN5Nmpa?=
 =?utf-8?B?R0NVWE5vSnJTcFFPNmp5emhJOG9oM2VtbnM2dytxaHFBa0VFR2dRR1RUTWk0?=
 =?utf-8?B?M05YWkpTUlVoSkpEUkF1NHpyR3I1MEhXbVliYUpienhlb1hhaTdCckcrMk41?=
 =?utf-8?B?emU2M1VxK3ZPdHkvMjcrZHp6Q1A2M0tDZmIwVXVnWGF1cGdMaVI1UTlRdmZN?=
 =?utf-8?B?b0grbXhUQVNwSitUL3ZUMTlDemVnbFIvR05kbmJpd1pJaVZ2N1JadE50WFE5?=
 =?utf-8?B?QzZiK053b2FNRGZUd3pyY0xlRTY3bGh4bTZGNERpc01pVjhvUGZpL1Y0MDV5?=
 =?utf-8?B?NUpYTDZCK2oxOWR2cDZUR1htcSt1cXo3R1FIb09BZlVrejRQYkVlakYyTUly?=
 =?utf-8?B?dWtTd1kvbVpNa0RiOHFMSEQ5ekhVZzcrblk5S284SEN0Q1ordFhqbUZQQWox?=
 =?utf-8?B?THFLclRTNUo0eFBIMkNQNEcvVjZYZGZRbjZiekVuZWRkQlhhUjRVdjlPYXl1?=
 =?utf-8?B?Y09aS0dtTndVSE1yWUMrN3RVWW0zOHpySllwNlNKYWxqKzhtenp4aFlpNU5I?=
 =?utf-8?B?TXJtWGtQeXpkTGtZYlRqN3JSd1BIU1FzR1VRMS9qcmZJZEtNdXF3SEdyUmxq?=
 =?utf-8?B?aExFcnFZWEthZGdvQ1BiNzVrOWlDTkU5NHJOZnpLdFFqZnJSMUFDTHR2bk15?=
 =?utf-8?B?VUpiL09pSWhnUnpsc3N2YzkvTTNsaGJjWDVTSE8rd0pYSEMvTWZhdz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: cb125fa1-66cd-4f61-59fc-08dec7d58ea4
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:57.0034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ORcy8baJS9d+Btne4efmhzSCMbEV98QyTNuOKFYcIJlq4hGRpaicwreC6LCgPhZu8I7Pc6mzvdMw+JgtuEwbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q3kd9t55tg411psxabkac9qyg5j5w4tg
X-Rspamd-Queue-Id: 572A640006
X-HE-Tag: 1781194928-160601
X-HE-Meta: U2FsdGVkX1/7bxl53VV6DbOCIh0NQ550+1ErDUxDAv7ZNrJvat2aDka9NifAIKoImj9qGGG0fdRnkSk8inVy15lJ7UFWhAez2XQRWZMu+t1CNT8xZLC+ifqdzmUqfslWRRtUwS/2oO4iReAQIkGgH0TdZKQnDtCWexcI0rRahsIOg2HjS4GbXdMlKMapWhHF8L2mN1mGfPfxhmC29q7llRa6RHJVlQlVFe6Emh+oxkHJS+UH+Cj9peXaKaifMYuPDPvMSyzPDxDLITRor/+Mk5nsgmkAEH9iJk/dWsEWQVKP/MGm+h3lpfgzeMoA9PnPcpHsUd4IryU+1Sl+cXF81Zso4EkAPEzrElUaG5kNegCAVdcdOaMVJS8dBQyJ+dgLuMp5OyZrWltDKQqWpswv5VJnVfyA9tPw9dnkDvDdOo6jEGAkkFltQPp/aj7PUVryFkPvcmfZJ48CFv/cuZlNlzzZ9gqOqkO8CHfW0r3RDrwc3WRXOXNZif9a2Lk6Dhs9svX3jtrbb4EejAZ6LiO+It55f7FwK7GEbpQ9Daeru/j/e3Wjwa+4vzXTClP3MMEMrWdfXCQLG2Qz4mVk1kjfIFa4Muyu7lAdiYZ+Z0jBU/VWpFYed79VqYwXN3y00aCYwENdgsdEnm0nbC8/NryYf7q5KohLyL0QqYfExM4vFcGOPBXceblVE0hkKp/yXVg9Zvk4XTu9LdHLifd8whpsqMbKvAnAlrEJELKRu0tClcfL7U6OeUH1FqC46jBvOhzAFydNfJ2qx3+2qvUa+as9lP5vbSxnrAV7hBEMFLrMP7WpQWY7HkWs4EOaEZzA7j92mmqz/hvYM8ISckBDN0TtP/1Khp5ViYt1RIW4BeSePIA/5gLlyAJnZYE9imxA2haazL7byV1RCDylM1NZ6i11nwwkJwNaoAcIIbRHoQUe2IlCUw+h/fo4XVRJavKNEqBzU+zMzMMfN/v1TGuhtic
 Wgm8GvPG
 tBZ7ojjK39Bynrt7cOGdtyyH/oSsRuzMN3TnDQPeHFIXHEXxJbJa3omExOxXGDKUeyUCpsmihfRXKs+7Apq31gPRzNP3hkPnjkJRsAS1VO7P+RTb+aSwlrS7unFendNJrrRQ9eY2D2wmzdsjpSF8DCNSke2M3LGj5lxSwUdBAczDPq/0DgCKILtpMAsCuVY8Ajz9yz5bBAdIJBqB9dJm0QbGB1BwZDroAffNHj74I9Ct0I081f9n2Hx2WxWEm0EJS5x2cAKosFHvnQpp4AwwtevKg+LHQPhK9ZvPAd67hbzHEYD62IqlcOfjBiQz+LuzvVwsgxG955Z8M/32AMGnlQA3xlB+K1gpQ1JFPU7RGgwMAYlUhYu9AmqFtAMqaEkFcXWJUQXPGVXKY2EIK9XJlM273xtKpR8ZtwAHCorj4R4uUXIr8B/CFbR42DKXn/Os4ULR4IwCxp4e+s5g5FFwaA5M6M/pDpKe7/ulvVUSro0Of/iXixYvJPNypHS4UMyA6WHewj28omwx7n+PRYKQKttHdSX9nvBdpNuu0SAI96TJS/iJ8hLJmpdDvTX+FKYiiaRlLYs2Qn6/TO6ZohwCO3tMSfMb8Ujv6mh6zmj1g2xB/JW7Fu6JnGgiRcrwWoPT60LWeE8u481z0+6pDkOH8dvXlW17DKldRXlRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rust module exercising 1-8 argument functions plus struct pointer.
Verifies register-passed (1-6) and stack-passed (7-8) arguments.

Test:

  make LLVM=1 CC=clang RUSTC=$RUSTC RUST_LIB_SRC=$RUST_LIB_SRC \
    M=tools/testing/selftests/kcov_dataflow/eight_args_rust modules
  vng --user root --exec \
    "python3 tools/testing/selftests/kcov_dataflow/trigger-view.py \
      eight_args_rust -C 8 --ko \
      tools/testing/selftests/kcov_dataflow/eight_args_rust/eight_args_rust.ko"

Result:

  ksys_write(0x0, 0x1)
    fdget_pos(0x4)
    0xffff891481d2bc00 = fdget_pos()
  0x0 = vfs_write()
  vfs_write(0x0, 0x1, 0x0)
  0x0 = _RNvCs3p16QzTwthP_15eight_args_rust13write_handler [eight_args_rust]()
  _RNvCs3p16QzTwthP_15eight_args_rust13write_handler [eight_args_rust](0x0, 0x1, 0x0)
    rdf_func2 [eight_args_rust](0x11, 0x22)
    0x33 = rdf_func2 [eight_args_rust]()
    rdf_func3 [eight_args_rust](0x11, 0x22, 0x33)
    0x66 = rdf_func3 [eight_args_rust]()
    rdf_func4 [eight_args_rust](0x11, 0x22, 0x33, 0x44)
    0xaa = rdf_func4 [eight_args_rust]()
    rdf_func5 [eight_args_rust](0x11, 0x22, 0x33, 0x44, 0x55)
    0xff = rdf_func5 [eight_args_rust]()
    rdf_func6 [eight_args_rust](0x11, 0x22, 0x33, 0x44, 0x55, 0x66)
    0x165 = rdf_func6 [eight_args_rust]()
    rdf_func7 [eight_args_rust](0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77)
    0x1dc = rdf_func7 [eight_args_rust]()
    rdf_func8 [eight_args_rust](0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88)
    0x264 = rdf_func8 [eight_args_rust]()
    rdf_func_struct [eight_args_rust](0xaaaa)
    0x16665 = rdf_func_struct [eight_args_rust]()
  0x1 = _RNvCs3p16QzTwthP_15eight_args_rust13write_handler [eight_args_rust]()
  0x1 = vfs_write()
  0x1 = ksys_write()
  0x1 = __x64_sys_write()
  0x0 = fpregs_assert_state_consistent()
  0xba5748 = __x64_sys_close()
  file_close_fd(0x4)
  0x0 = file_close_fd()
  0x0 = filp_flush()

Cc: Alexander Potapenko <glider@google.com>
Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Link: https://github.com/yskzalloc/kcov-dataflow/actions
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 tools/testing/selftests/kcov_dataflow/README.rst   |   7 +
 .../kcov_dataflow/eight_args_rust/Makefile         |   3 +
 .../eight_args_rust/eight_args_rust.rs             | 143 +++++++++++++++++++++
 .../selftests/kcov_dataflow/run_eight_args_rust.sh |  35 +++++
 4 files changed, 188 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/README.rst b/tools/testing/selftests/kcov_dataflow/README.rst
index e93b4e573504..61a41f3bd596 100644
--- a/tools/testing/selftests/kcov_dataflow/README.rst
+++ b/tools/testing/selftests/kcov_dataflow/README.rst
@@ -41,3 +41,10 @@ eight_args_c/
 
         make LLVM=1 CC=clang M=tools/testing/selftests/kcov_dataflow/eight_args_c modules
         python3 trigger-view.py eight_args_c
+
+eight_args_rust/
+    Rust equivalent of eight_args_c. Captures arguments at -O2 where
+    drgn/vmcore cannot. Requires CONFIG_RUST::
+
+        make LLVM=1 CC=clang M=tools/testing/selftests/kcov_dataflow/eight_args_rust modules
+        python3 trigger-view.py eight_args_rust
diff --git a/tools/testing/selftests/kcov_dataflow/eight_args_rust/Makefile b/tools/testing/selftests/kcov_dataflow/eight_args_rust/Makefile
new file mode 100644
index 000000000000..c1e9ea2c5622
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_args_rust/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-m := eight_args_rust.o
+KCOV_DATAFLOW_eight_args_rust.o := y
diff --git a/tools/testing/selftests/kcov_dataflow/eight_args_rust/eight_args_rust.rs b/tools/testing/selftests/kcov_dataflow/eight_args_rust/eight_args_rust.rs
new file mode 100644
index 000000000000..3026265cda97
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/eight_args_rust/eight_args_rust.rs
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Verify kcov_dataflow captures 1-8 argument Rust functions at -O2.
+//!
+//! This is the Rust equivalent of eight_args_c. Since rustc elides DWARF
+//! variable locations at -O2, drgn/vmcore cannot observe these arguments.
+//! kcov_dataflow captures them via the post-compilation pipeline.
+//!
+//! Write to /sys/kernel/debug/kcov_dataflow_test/trigger_rust to invoke.
+
+#![allow(missing_docs)]
+
+use kernel::prelude::*;
+use kernel::c_str;
+
+module! {
+    type: EightArgsRust,
+    name: "eight_args_rust",
+    authors: ["kcov-dataflow"],
+    description: "1-8 arg Rust verification for kcov_dataflow",
+    license: "GPL",
+}
+
+#[repr(C)]
+pub struct Pair {
+    pub x: u32,
+    pub y: u32,
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func1(a1: u64) -> u64 { a1 }
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func2(a1: u64, a2: u64) -> u64 { a1 + a2 }
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func3(a1: u64, a2: u64, a3: u64) -> u64 {
+    a1 + a2 + a3
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func4(a1: u64, a2: u64, a3: u64, a4: u64) -> u64 {
+    a1 + a2 + a3 + a4
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func5(a1: u64, a2: u64, a3: u64, a4: u64, a5: u64) -> u64 {
+    a1 + a2 + a3 + a4 + a5
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func6(
+    a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64,
+) -> u64 {
+    a1 + a2 + a3 + a4 + a5 + a6
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func7(
+    a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64,
+) -> u64 {
+    a1 + a2 + a3 + a4 + a5 + a6 + a7
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func8(
+    a1: u64, a2: u64, a3: u64, a4: u64, a5: u64, a6: u64, a7: u64, a8: u64,
+) -> u64 {
+    a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8
+}
+
+#[no_mangle]
+#[inline(never)]
+pub extern "C" fn rdf_func_struct(p: *const Pair) -> u64 {
+    unsafe { (*p).x as u64 + (*p).y as u64 }
+}
+
+unsafe extern "C" fn write_handler(
+    _file: *mut kernel::bindings::file,
+    _buf: *const core::ffi::c_char,
+    count: usize,
+    _ppos: *mut kernel::bindings::loff_t,
+) -> kernel::ffi::c_long {
+    let p = Pair { x: 0xAAAA, y: 0xBBBB };
+
+    let mut sum: u64 = 0;
+    sum = sum.wrapping_add(rdf_func1(0x11));
+    sum = sum.wrapping_add(rdf_func2(0x11, 0x22));
+    sum = sum.wrapping_add(rdf_func3(0x11, 0x22, 0x33));
+    sum = sum.wrapping_add(rdf_func4(0x11, 0x22, 0x33, 0x44));
+    sum = sum.wrapping_add(rdf_func5(0x11, 0x22, 0x33, 0x44, 0x55));
+    sum = sum.wrapping_add(rdf_func6(0x11, 0x22, 0x33, 0x44, 0x55, 0x66));
+    sum = sum.wrapping_add(rdf_func7(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77));
+    sum = sum.wrapping_add(rdf_func8(0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88));
+    sum = sum.wrapping_add(rdf_func_struct(&p as *const Pair));
+    core::hint::black_box(sum);
+
+    count as kernel::ffi::c_long
+}
+
+#[repr(transparent)]
+struct SyncFops(kernel::bindings::file_operations);
+unsafe impl Sync for SyncFops {}
+
+static FOPS: SyncFops = SyncFops(kernel::bindings::file_operations {
+    write: Some(unsafe { core::mem::transmute(write_handler as *const ()) }),
+    ..unsafe { core::mem::zeroed() }
+});
+
+struct EightArgsRust {
+    d: *mut kernel::bindings::dentry,
+}
+
+impl kernel::Module for EightArgsRust {
+    fn init(_module: &'static ThisModule) -> Result<Self> {
+        let d = unsafe {
+            kernel::bindings::debugfs_create_file_unsafe(
+                c_str!("trigger_rust").as_char_ptr(),
+                0o222,
+                core::ptr::null_mut(),
+                core::ptr::null_mut(),
+                &FOPS.0,
+            )
+        };
+        Ok(Self { d })
+    }
+}
+
+impl Drop for EightArgsRust {
+    fn drop(&mut self) {
+        unsafe { kernel::bindings::debugfs_remove(self.d) };
+    }
+}
+
+unsafe impl Send for EightArgsRust {}
+unsafe impl Sync for EightArgsRust {}
diff --git a/tools/testing/selftests/kcov_dataflow/run_eight_args_rust.sh b/tools/testing/selftests/kcov_dataflow/run_eight_args_rust.sh
new file mode 100755
index 000000000000..c5f11866e19d
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/run_eight_args_rust.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Test eight_args_rust module capture via kcov_dataflow
+DIR="$(dirname "$0")"
+KO="$DIR/eight_args_rust/eight_args_rust.ko"
+
+if [ ! -f "$KO" ]; then
+	echo "SKIP: $KO not found"
+	echo "Build: make LLVM=1 CC=clang RUSTC=\$RUSTC M=...eight_args_rust modules""
+	exit 4  # kselftest SKIP
+fi
+
+if [ ! -e /sys/kernel/debug/kcov_dataflow ]; then
+	echo "SKIP: kcov_dataflow not available"
+	exit 4
+fi
+
+OUTPUT=$(python3 "$DIR/trigger-view.py" eight_args_rust --ko "$KO" --raw 2>&1)
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
+	echo "PASS: captured $RECORDS records from eight_args_rust"
+	exit 0
+else
+	echo "FAIL: no records captured"
+	echo "$OUTPUT"
+	exit 1
+fi

-- 
2.43.0


