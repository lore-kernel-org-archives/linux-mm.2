Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74946D1268E
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 14:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985BD6B0012; Wed,  3 Dec 2025 09:33:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95CCE6B0023; Wed,  3 Dec 2025 09:33:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BDC6B0024; Wed,  3 Dec 2025 09:33:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFA56B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:33:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 252981405D8
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:33:20 +0000 (UTC)
X-FDA: 84178402560.05.632BB55
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020134.outbound.protection.outlook.com [52.101.195.134])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18885180010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:33:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Tyn55U87;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.134 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764772397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2RNJy5g75k/yH+/lmInzQToBBwILHLfxTZooVLuZbII=;
	b=VX+j6U7gePk9r+Rae6Rj137rrMuivj/lpISXea0ZineQ9zAOParzIsWbz8z0BvGmPvta8N
	Z0mlRyfZ4giUJS5AOXSDWkBeV6VK6WTe+p20EKGxa785P8Eo3Hoh8uXfbkmjsN726IttrS
	PIrHGDW23oC6yNTU+qTrnTkzeBQExZs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Tyn55U87;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.134 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764772397; a=rsa-sha256;
	cv=pass;
	b=MgQIkRdXUoW3lK+nK6GcYbze6LSCznAPxKPy664wt9CM+ChgdVLsa2hgw12T7KtjgdMf1N
	4TsaSgfcTSp9n5HTn5OwWBkr16Ud/8/WFt52MvjOMfg7QofANgRRVVvVkcm9RdTwYTfKLU
	1dBIOVg/Ks6kCEVxSi0aRSMMr4nnrvk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0NRSwTvEeKriBepoRDW0oZuBWNjB3DjmrWZxWY8u/WPCAy534KeVfvRM/hc0g1UJTz2Id5c6WgXF5611vSThi0pmsUBXRBDccmB8GMkjgOF+yqz3artUAGHIA8SL7mSDgoJixQ7eDKt1z0dlFvmD0giLkko3Y8N28+6VU9PwrdSJm2HsPjxPgDucnnrZyaes7PXlncNa+zV6JF82hRHl2XhH9ixfE6playjXvNL9ufF63OeX6IuBdd/f8mRKqYkrngdDUUp1e/2dUCADEmJduE575v8/mt8AuaZhVPfclANeTgG4lbk6TH3O0zwpCqfVWAnNrqdT3Ywow57T3njWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RNJy5g75k/yH+/lmInzQToBBwILHLfxTZooVLuZbII=;
 b=RKM7MqlXOaAbuXGzcON7Qdzp7Yn7BDimSRmSiJO3rYK1U0UpyVAMUsxM88AymboiA0DOzr545g5s+pdvBaouspH7yovRD6ucqhOzj/dByxJ3wmZl8/hbbXOAy2/eGX/ZAsiiCCLVPQruEhl+nEJoAFo/LXy8h3eXpWiI8z8ngo/FVXvqH2d7krKVsMHF79mevKhs2gavGf92DTL3Ejx/c1YY5H6UHMW2erSJQG5BhUFyKOpOd84n+SxzwuVciHwHJRL57/TLQhS5a4Oyup974jMYKTEeQ0e1WTEJYTfanQLv4aGV+BtbovEceHZWJ8ivFgKgvCSX+L0XN+yEXsOagw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RNJy5g75k/yH+/lmInzQToBBwILHLfxTZooVLuZbII=;
 b=Tyn55U87HhpyiSZD1z91h3YYk7GKFDNY7KVMgjq7DKAsXfs0MgFTTuZ6ZpGLI2W0MHkeXHaoSHsfhOulphpVNH8RyOW3LwfeL3T6JtFj68s+nkWDe8wEsX8wl/gHGDIwUTB7LWohZB5HnGKhzHOze/HTBh0/7fshmFgQCyCUoMU=
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LOYP265MB1840.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 14:33:12 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%6]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 14:33:12 +0000
Date: Wed, 3 Dec 2025 14:33:05 +0000
From: Gary Guo <gary@garyguo.net>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Boqun
 Feng <boqun.feng@gmail.com>, Elle Rhumsaa <elle@weathered-steel.dev>,
 Carlos Llamas <cmllamas@google.com>, Yury Norov <yury.norov@gmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org,
 FUJITA Tomonori <fujita.tomonori@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Michael Turquette <mturquette@baylibre.com>, Stephen
 Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org, Benno Lossin
 <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner
 <tglx@linutronix.de>, "Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar
 <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org, Paul Moore
 <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>,
 linux-security-module@vger.kernel.org, Daniel Almeida
 <daniel.almeida@collabora.com>, Abdiel Janulgue
 <abdiel.janulgue@gmail.com>, Robin Murphy <robin.murphy@arm.com>, Lyude
 Paul <lyude@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>,
 David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
 linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Ballance
 <andrewjballance@gmail.com>, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>,
 devicetree@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Krzysztof
 =?UTF-8?B?V2lsY3p5xYRza2k=?=" <kwilczynski@kernel.org>,
 linux-pci@vger.kernel.org, Remo Senekowitsch <remo@buenzli.dev>, "Paul E.
 McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org, Will Deacon
 <will@kernel.org>, Fiona Behrens <me@kloenk.dev>, Liam Girdwood
 <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Ingo Molnar
 <mingo@redhat.com>, Waiman Long <longman@redhat.com>, Mitchell Levy
 <levymitchell0@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz
 <jstultz@google.com>, linux-usb@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Matthew Wilcox
 <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>
Subject: Re: [PATCH 00/46] Allow inlining C helpers into Rust when using LTO
Message-ID: <20251203143305.591cd0da.gary@garyguo.net>
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0061.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::7) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LOYP265MB1840:EE_
X-MS-Office365-Filtering-Correlation-Id: acbf5439-7581-44f6-714b-08de3278e331
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UJrfARac/ujsBb15GuVEoZR5AGfjo7H+g4EF39E9aORarwyuQssx/c5Vdw5p?=
 =?us-ascii?Q?fKve5noEhpOOBMp7d7JqUdZ6jDTY8lM/9hZ5iDZDBk87t3l2P6O1knClbiYX?=
 =?us-ascii?Q?x4AKfn1ZQcD0EF3Sl8zWmhs6s/Oleq062DbkKOHjwCeafOOMBTPDXVfzdMWN?=
 =?us-ascii?Q?N2UQUuoWNj+ll9MypGDWtSWckNq9ioOgx9YCVcrkyW81xGa3RKgrhuvmgWN6?=
 =?us-ascii?Q?dx5NkaviRcAbkhir5pbztXiBRdRtlOYNoqnKzSAozz7T0r142W++KjuVbjUf?=
 =?us-ascii?Q?zyRaHLHgb+Vg/VVtRc1e6+Qimsl9z19727igH8Ae3NJlnyTUQ86Bk/uKC6Aj?=
 =?us-ascii?Q?2bf/sWYZKBMACJDWD+o/mHwnbaOSOvRoOc8PZzwerxo9ESVsuCsjwtowFi32?=
 =?us-ascii?Q?Tg9gjs2tuSkdI2FphxopmKuSSTBg6QhYqUlE7bFWK4A9x1S6ak0oS8W2bm0Y?=
 =?us-ascii?Q?2AfXo7egN6WQ0Wh0tvZ+hAVadsLN+AubY1Litp9sMWmVOUsmApBk28P6YED0?=
 =?us-ascii?Q?6RbSIFzVwslTnPo6uYeAAGJzCMIrmUo/kv8D6waH1C/ACNPKXQPTin/p8Fio?=
 =?us-ascii?Q?1/EJixEv1oE6q0/mefPk+4BATdi4OZkjFHPiDv+gyGZoMNwiJ85lW8hTyVNy?=
 =?us-ascii?Q?+gScMEzHzzKG2PLyfoXbwf2dSQLdI6lDU4Vu6+5oFL5D9n7KdJTp/044esCb?=
 =?us-ascii?Q?ZHJZ/MoYX9DvdJFv8QBplLBZidivOGvhN2eujFY/cD+/7euWh62eTxbls+hb?=
 =?us-ascii?Q?8QI76//QRSnGShpH3itFaRvoJiSN4bJ+TAyth7N/fWPLRofamQZiaJOmYF06?=
 =?us-ascii?Q?4JxkMQ4N43mnFwGGNfqU1DbpqvWYveX70jeHOsYeeTfTPP8szfO8i5rJX0/B?=
 =?us-ascii?Q?Mz9gty5w0avCcsB2ymksw7qa4GsI0LHK10gVTSXiP3J1LsX1JfQ38hjwACcX?=
 =?us-ascii?Q?Cgmv7kykfc8xaKkpNndqiSbiUDk73fkXWAQjmZJnhiwnQmGHwKtJhQjVNT2B?=
 =?us-ascii?Q?/gK2GwO81H4WT3pz7nZeuMd87fbbgxfHDa9lxvpTCAI0dTab553n4ByY4Puw?=
 =?us-ascii?Q?hPvIf3cbTEVx+C9QT3vRRps65l18rJ1hhW1ADKK2MWUn5Wb9AxRZ7gel5I3I?=
 =?us-ascii?Q?qrj5gcDJEUq8es6wmxfX8+nmxAn3zu0hv14PEO6QtJPwcOIQd1+GhDk8+7fo?=
 =?us-ascii?Q?GTVOUMBIxxxH1lV9NkaxJ+Oqo8esZcLO50H/mUCZ9+NkcTSssNwbN49LI1xu?=
 =?us-ascii?Q?J2+GGMIwIfC7YCNCtKNLKUdAU9cTLzdYyJd0cfLeui6SJG1DeUSrIMjQvW3J?=
 =?us-ascii?Q?kvD1g/PIT8X8cvOV62qZ9Uc5GGRLY59M3NBF6NozC4kme9qwg4PvfmeFtUHY?=
 =?us-ascii?Q?/u7vKQOBSqweg2EdL20aezhS7uaW/jWiJyQbsc3JrqQ/1h6U7zCHAJ7uzFb2?=
 =?us-ascii?Q?yJf6N14z5Cs6Hq2ZNwOVLFk7ilJ/zzED?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(7416014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aSDALWRyH6rBkXxsbpB4Y/5XOm/Bce5/DXVBbWJ1n6Di3wnox2Ngvn9vQCAI?=
 =?us-ascii?Q?Y5A/5vENvJ8dX4qzav8O/ktGU6eMGd7Qqy/lcczgT3Z7awwxz1K8KNrGzY/O?=
 =?us-ascii?Q?5rDSyN7Eg1OeQ71nEL2zwTHEIBySAxYpeubVrfL87ampUcDzdbCvjSPMBN5i?=
 =?us-ascii?Q?m6IT2Snr7COf6DDaS0U8dBOI3jzYi262nJRmAZagEheMDb0//hONUIkgJll0?=
 =?us-ascii?Q?S3GYzqydR1DmgQ7QrkzfTOXhS9qrBylxJzETHgrOiHBHi2K0IHlPAI6kFcEU?=
 =?us-ascii?Q?0AkeoLqnIEot8pHEsdJzul3hdEBY0XYcw0uFpfHIqdW0QvOhkXVO1znF2DuN?=
 =?us-ascii?Q?stnxBj68oP7UrXprCATa8v9x831lUCLaAWfNTPzBdzlfMsxXnjg3zqis06V3?=
 =?us-ascii?Q?rLTkqzG1d6uEdj7Cq2TsFKm2rHji1B1dMSO0+c5Bdw9uG73cawkyenwW52PN?=
 =?us-ascii?Q?iYaXyEe5QItQ2rTjSung3fkLhAl5STLqDZrpYcQSO7ZCBzgtsk57Bs6AWpNj?=
 =?us-ascii?Q?Jlm+srnD05VHUMvTbE6bMxoAIHzoYBW9XQ1NHYl9uwtZv9Nc+/l72qlDz73E?=
 =?us-ascii?Q?21znhRhYmszGDJjMw+5SmMzXFEga7X3OvVrBBAT90vH5M6rC4B4L94LBCtYb?=
 =?us-ascii?Q?ff5hJxMRPN6LmYFgSiHBPcH54/Lq+aAmcVPFtQVa9wXeVz64u1q99G4tOzjF?=
 =?us-ascii?Q?YF+LY1Bu8mxizc2MeS+/VSLBVuJ2ur60t2FTe3p8QCJB8+anw/F8y9D8wZDZ?=
 =?us-ascii?Q?AlaU1dO6xsM+d0OKTzH1g5i+LRc7fu/WguQbCIMuPxwIpk3hsq2L/etVDTYG?=
 =?us-ascii?Q?j1DRe9RM+1m0B6rGCojtvH0Z/y88WYKsrVrNcU0b5VbIW4mIr7eHyOy/RaG9?=
 =?us-ascii?Q?+5VTE/7wBNSFfAGU/+HDhIWJeW4lsV0z7X+hgsaD53VpCSqfbb2FFF23WGra?=
 =?us-ascii?Q?bksKZt8s2Q1O5WlSDPH1v5qGLp4OwXgW6rGx8Hv3L+xAW5g70fUoehS56HXk?=
 =?us-ascii?Q?sVRpSY47BDZAKaABAjA0qaNhzf0o4yM0PF0Dx2jemfUAqiN/PApQij0Ah6U5?=
 =?us-ascii?Q?kq8T6+ERfhm6cw+Aob4ejY0jLb8R7SSvueKnag4yKWLUlQVtrnRCexkmtUsz?=
 =?us-ascii?Q?uLvS6ZUCjALqmIvz+L17dairZPqR58MltO7vXZMEbd0N6rHfSbn5Pgy5JBVX?=
 =?us-ascii?Q?kvGj9IUdOIEya7I2GVfhvQMe05cU+yzRODk3egh+zDRKzagX6f0KuMom8/wP?=
 =?us-ascii?Q?v5e9UV0Li3Y9eYNpC7qyqlUuRI35WBswUafowEy6uWtR9FYoKAyZPiimcFRe?=
 =?us-ascii?Q?lArz2tswt3FM0SGVQ9LK6cBndm5G8jxF7CNhPjBoj7gCy+6rt6ULJQj2gvVt?=
 =?us-ascii?Q?FfZHOcO7d6ha2EX0n+WxDDTwt/ojJ0TgYb40zc/y/nq0+RJwqGsG6DXu/ovO?=
 =?us-ascii?Q?wLv5pIa3cyRweBtIgRQ42ZQcuM/NLPGU0aeyeXqMaQfNDZGDJHQJV/nl77V5?=
 =?us-ascii?Q?NIfeoheuxVKaUpvGliJ16RymPhfb1NfGyl+TBpRSoy8kGaRIUSWU/OONleH+?=
 =?us-ascii?Q?2zN0NHddUbOPyZpFzVRSjrwrn5ENJIm9SE/0OKpV?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: acbf5439-7581-44f6-714b-08de3278e331
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 14:33:12.4245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRn8asrDjyKwtwsik1jzQleEnuEzRZTwLmfWOvRYRylEJIyTWkKHLwjoHQRbbwXGtved8UjQZlzwVCNooUFMmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP265MB1840
X-Rspamd-Queue-Id: 18885180010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: c7yqgsh4fzma16ogx3x3pxg7zxfdo4sm
X-HE-Tag: 1764772396-8587
X-HE-Meta: U2FsdGVkX19fscXkDPna+PdTaYsiZCfRR7PZD1jwrRs/YyIHUXXwFkX5rU7pPH241Vt4A6+Eqb7S/lhGRmrgfgPMf0inD/Z8LzxKQjEuurn0I3i6ey+8suSzTDp4cL+K1mCTyVa7j7GRu71IKqjoJktv7cv7SJ9TonLOTSjlZOl4kSSRm7G/RdpKLgmXw2zDuxKctLkjTpJX3N6kEipUcYRFW1eOCOYE8mm01V6JFhJN9zQIMsKTFWeotCf2mjkF0hyESwhe5+iALaZJL8MxjwSl4lyk8ZJIowiIWDgjbac6LKUeW3jF2f1r4XGfQOXCVMm0bEOxyyyIYtv1WyAfxsANbHxPg5FwRlmNpNs+LImbLEK/vSw8bh/L0oXdD0GQeV0BE8iktdhdfa9DTabBU0II2vy41n6QXrk2SaJxaZrT4KMNgq+yXI4UIku0zrHi9JjWopvEfWKLWLjUMzXENvUkjt1l63NESRsTahfr/Ny6DuU3UGHbF2Hd4KiU8Ni9+dzgRC9t1ufUhEjirmV3Lx+wryvv3wWqEyCXTyDJwD7YX1b9b7Gnm/qXiCqvtTnArH08HNz5+Ojq8lAvn/otpBRpgppwdlzfELMXypG94vkqHqs7Q1PBxy9HuAYR2EAa+4vrEjg/vTPkr5r7kvj6ysOa92HdFNG5xyjRQkDZBEv9h3LhJzxxer7EIz/jed2DyxeKRFZLIj0Pamv88uzADiGXCbF+PRIhEo6VLnpRrcdxswOvek/pseTLQKuWEV/h852UYOICFrbXl6WI5NdLEICp8c+k42TWVtuUQQhn7FSZAOxEwOsbqCGN4z6vHwfcGwKCKlkvmq99k6XpvAqeUzGsQY0QaL6CqMBRkah4R+BNnJVWMTz4tiI+MtKKYYSQaCaXpovlqpbRmrsDg+tzQvprL3jolhvU3xI8g5bvB5G7Ls6Lmhv/lT1UPnIwR9wTWD+CHMuc9t3HrdoiwL6
 7ZMxvG9e
 5xuFPbJALCsJJBXO0nzIhoOV4dnY4Eq+6jnM0CmNuedK8dDiifSNmetaU26ybgspWVvxLdVqcHx91/bU54ZfSbQNTGdN757pX8aPxsUZf7yD6wsv6qi5sUdPu+g8h/vz74l2tOtcj9mwExwT9PP0zYZ5mpPHltlsGBcyuSqIh4ZNV3zv8cvJTnXn+H/t+yjcY+thAvCvjf9PVj/iZWSk0q3NyPwCNsaD5+x06vVzlhiOFZEzoul0Hi0aRs8VDTTBd/QdJ5JkPrWi/aZIzzfN5EKROE/j9ToaNZSqSlUHmvspXNG2olBlNkNJ42dcYXbW77kz9iijCpnLIWN+aA/RiduTGnNTWVuVahg7cE8zXNF9FUUls7t4yPfiOxgtyQF4lkZit0ZPNuiO6BXzFWi+/aB7CHPTDdxTyrvGtRtCu6WgvhhyBu8MaWWiVtxZzBXUlAL76+FmUg/mH+oZVVaI2HIfQlXzhmlgbVN7z8p1V6lGTLGF5mpIgKM3hasgBEczA550iYTWK5d4H5R1AeKK0j9ISbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Dec 2025 19:37:24 +0000
Alice Ryhl <aliceryhl@google.com> wrote:

> This patch series adds __rust_helper to every single rust helper. The
> patches do not depend on each other, so maintainers please go ahead and
> pick up any patches relevant to your subsystem! Or provide your Acked-by
> so that Miguel can pick them up.
> 
> These changes were generated by adding __rust_helper and running
> ClangFormat. Unrelated formatting changes were removed manually.
> 
> Why is __rust_helper needed?
> ============================
> 
> Currently, C helpers cannot be inlined into Rust even when using LTO
> because LLVM detects slightly different options on the codegen units.
> 
> * LLVM doesn't want to inline functions compiled with
>   `-fno-delete-null-pointer-checks` with code compiled without. The C
>   CGUs all have this enabled and Rust CGUs don't. Inlining is okay since
>   this is one of the hardening features that does not change the ABI,
>   and we shouldn't have null pointer dereferences in these helpers.
> 
> * LLVM doesn't want to inline functions with different list of builtins. C
>   side has `-fno-builtin-wcslen`; `wcslen` is not a Rust builtin, so
>   they should be compatible, but LLVM does not perform inlining due to
>   attributes mismatch.
> 
> * clang and Rust doesn't have the exact target string. Clang generates
>   `+cmov,+cx8,+fxsr` but Rust doesn't enable them (in fact, Rust will
>   complain if `-Ctarget-feature=+cmov,+cx8,+fxsr` is used). x86-64
>   always enable these features, so they are in fact the same target
>   string, but LLVM doesn't understand this and so inlining is inhibited.
>   This can be bypassed with `--ignore-tti-inline-compatible`, but this
>   is a hidden option.
> 
> (This analysis was written by Gary Guo.)
> 
> How is this fixed?
> ==================
> 
> To fix this we need to add __always_inline to all helpers when compiling
> with LTO. However, it should not be added when running bindgen as
> bindgen will ignore functions marked inline. To achieve this, we are
> using a #define called __rust_helper that is defined differently
> depending on whether bindgen is running or not.
> 
> Note that __rust_helper is currently always #defined to nothing.
> Changing it to __always_inline will happen separately in another patch
> series.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Alice Ryhl (46):
>       rust: auxiliary: add __rust_helper to helpers
>       rust: barrier: add __rust_helper to helpers
>       rust: binder: add __rust_helper to helpers
>       rust: bitmap: add __rust_helper to helpers
>       rust: bitops: add __rust_helper to helpers
>       rust: blk: add __rust_helper to helpers
>       rust: bug: add __rust_helper to helpers
>       rust: clk: add __rust_helper to helpers
>       rust: completion: add __rust_helper to helpers
>       rust: cpu: add __rust_helper to helpers
>       rust: cpufreq: add __rust_helper to helpers
>       rust: cpumask: add __rust_helper to helpers
>       rust: cred: add __rust_helper to helpers
>       rust: device: add __rust_helper to helpers
>       rust: dma: add __rust_helper to helpers
>       rust: drm: add __rust_helper to helpers
>       rust: err: add __rust_helper to helpers
>       rust: fs: add __rust_helper to helpers
>       rust: io: add __rust_helper to helpers
>       rust: irq: add __rust_helper to helpers
>       rust: jump_label: add __rust_helper to helpers
>       rust: kunit: add __rust_helper to helpers
>       rust: maple_tree: add __rust_helper to helpers
>       rust: mm: add __rust_helper to helpers
>       rust: of: add __rust_helper to helpers
>       rust: pci: add __rust_helper to helpers
>       rust: pid_namespace: add __rust_helper to helpers
>       rust: platform: add __rust_helper to helpers
>       rust: poll: add __rust_helper to helpers
>       rust: processor: add __rust_helper to helpers
>       rust: property: add __rust_helper to helpers
>       rust: rbtree: add __rust_helper to helpers
>       rust: rcu: add __rust_helper to helpers
>       rust: refcount: add __rust_helper to helpers
>       rust: regulator: add __rust_helper to helpers
>       rust: scatterlist: add __rust_helper to helpers
>       rust: security: add __rust_helper to helpers
>       rust: slab: add __rust_helper to helpers
>       rust: sync: add __rust_helper to helpers
>       rust: task: add __rust_helper to helpers
>       rust: time: add __rust_helper to helpers
>       rust: uaccess: add __rust_helper to helpers
>       rust: usb: add __rust_helper to helpers
>       rust: wait: add __rust_helper to helpers
>       rust: workqueue: add __rust_helper to helpers
>       rust: xarray: add __rust_helper to helpers

Thansk for sending this Alice! With this series in first, my series for
inlining helpers should be much easier to apply.

For the whole series:

Reviewed-by: Gary Guo <gary@garyguo.net>

Best,
Gary


> 
>  rust/helpers/auxiliary.c     |  6 +++--
>  rust/helpers/barrier.c       |  6 ++---
>  rust/helpers/binder.c        | 13 ++++-----
>  rust/helpers/bitmap.c        |  6 +++--
>  rust/helpers/bitops.c        | 11 +++++---
>  rust/helpers/blk.c           |  4 +--
>  rust/helpers/bug.c           |  4 +--
>  rust/helpers/build_bug.c     |  2 +-
>  rust/helpers/clk.c           | 24 +++++++++--------
>  rust/helpers/completion.c    |  2 +-
>  rust/helpers/cpu.c           |  2 +-
>  rust/helpers/cpufreq.c       |  3 ++-
>  rust/helpers/cpumask.c       | 32 +++++++++++++---------
>  rust/helpers/cred.c          |  4 +--
>  rust/helpers/device.c        | 16 +++++------
>  rust/helpers/dma.c           | 15 ++++++-----
>  rust/helpers/drm.c           |  7 ++---
>  rust/helpers/err.c           |  6 ++---
>  rust/helpers/fs.c            |  2 +-
>  rust/helpers/io.c            | 64 +++++++++++++++++++++++---------------------
>  rust/helpers/irq.c           |  6 +++--
>  rust/helpers/jump_label.c    |  2 +-
>  rust/helpers/kunit.c         |  2 +-
>  rust/helpers/maple_tree.c    |  3 ++-
>  rust/helpers/mm.c            | 20 +++++++-------
>  rust/helpers/mutex.c         | 13 ++++-----
>  rust/helpers/of.c            |  2 +-
>  rust/helpers/page.c          |  9 ++++---
>  rust/helpers/pci.c           | 13 +++++----
>  rust/helpers/pid_namespace.c |  8 +++---
>  rust/helpers/platform.c      |  2 +-
>  rust/helpers/poll.c          |  5 ++--
>  rust/helpers/processor.c     |  2 +-
>  rust/helpers/property.c      |  2 +-
>  rust/helpers/rbtree.c        |  5 ++--
>  rust/helpers/rcu.c           |  4 +--
>  rust/helpers/refcount.c      | 10 +++----
>  rust/helpers/regulator.c     | 24 ++++++++++-------
>  rust/helpers/scatterlist.c   | 12 +++++----
>  rust/helpers/security.c      | 26 ++++++++++--------
>  rust/helpers/signal.c        |  2 +-
>  rust/helpers/slab.c          | 14 +++++-----
>  rust/helpers/spinlock.c      | 13 ++++-----
>  rust/helpers/sync.c          |  4 +--
>  rust/helpers/task.c          | 24 ++++++++---------
>  rust/helpers/time.c          | 12 ++++-----
>  rust/helpers/uaccess.c       |  8 +++---
>  rust/helpers/usb.c           |  3 ++-
>  rust/helpers/vmalloc.c       |  7 ++---
>  rust/helpers/wait.c          |  2 +-
>  rust/helpers/workqueue.c     |  8 +++---
>  rust/helpers/xarray.c        | 10 +++----
>  52 files changed, 280 insertions(+), 226 deletions(-)
> ---
> base-commit: 54e3eae855629702c566bd2e130d9f40e7f35bde
> change-id: 20251202-define-rust-helper-f7b531813007
> 
> Best regards,


