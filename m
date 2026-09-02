Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B3BC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607006B00B8; Wed,  2 Sep 2026 12:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592BD6B00BD; Wed,  2 Sep 2026 12:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3952D6B00B8; Wed,  2 Sep 2026 12:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFB386B00B9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74CDE1402A3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:24 +0000 (UTC)
X-FDA: 85169359968.21.310A03B
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010067.outbound.protection.outlook.com [52.101.69.67])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5CA6840003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=c2GQoREf;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPIX9iiYBYCIRiH+JnZSCFumTbSHl+RkgmkIK9kXT34=;
	b=TIHiIt1ZNcHfZNtt8R/CLi3PzsuYo69YHGwAPgZ3BTBHPjRLJrrTO/TWHUOwue0DE8xGyF
	B5sgsA90OA05/gYlNn91W59cx8x5zmVohAgwfUQ0QEcvULHz3/V3/QKJxKiCR0VaJzywDO
	xcdqVJKR8pH/9bZdO6NPkrJDzOxh4nA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366621;
	b=JC0evSztGRiHnk+f4jHy5bX717bbKk2XXZ/uOQ1+1aRKs8LDNMRJJoB5ueQgzQb18ym8jD
	AWn5mZOunuEK20S+HDH8qBUyX2EMeuIH3PLSEngNCm6zdor3D19YKvqxIcyQ9GmBnnwmD1
	xmwtzWkhcKaj9GOGZrW+VtGxhgoEjQo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=c2GQoREf;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kuE4XZ//BD9HQpRPt5bTZLrZt0KG43Xlbu7I3H02ck6yE+X/HKatO7AIEv0lm+qpGz9+OyV4nAU1KyeidHlcofqiNcHb2/tjOd2byMTpB20KsSsoJSupsYFeOCzTwQf0CIcmmQd6gkdjTahbxqWk5/37HlP2uQvYZ+oTgHwelR67tJlI3Z0rgeGdVX36B36xaoq8TBVYfWni7PkzvwqpMi3LdDAWl1zdGpcKKVXLRmpdy3yfpdXEjKmLgWswml1I6+V2DIgUTZeLo02Kglp5KaLSIJefCmuChiRmIaqGohv9utq8Y3dQDuUhpjuqJQffW27dYp3y6q3bqmU8hs6QbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPIX9iiYBYCIRiH+JnZSCFumTbSHl+RkgmkIK9kXT34=;
 b=bQqlwU8R10F3G90UgpWyn32uOWEvaYTWM27nc/BigVs5FXcAIJjz1Ri7krFjMgI0nV+QzKm8Z/d+tgU3Y1E1flBC5mlHh1GNdqO34Vz1x22F0AuhP6lAWu3jWozIDOz/HNry0srcC/PqXQwhAguCpNnkXYrAtoExjdmqqfVvnW/dhLAereOhYSMYUOjbKp/u/IlTSewUATrdZ7Z6bKZnm/kszroYEsxQ7cvxCgnRU5HDvTygdrZDoeeli4cquBb3MZMfPNe24zPukAXW3SF0Ptlob1spf3Dnwk2BYhFcn3ii5MpNKNkME43a6zCvIDugVSnJdamUSXce9nnTi6SqNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPIX9iiYBYCIRiH+JnZSCFumTbSHl+RkgmkIK9kXT34=;
 b=c2GQoREfdGVd9p/NTwqqCUqAYBdOgJdWggVw9Er6pt/1zOd96mjqePIa974cR7kiyeX7K/hrJr6I2GYdIGkaydNT8CCbctQvOVaWINfl/6KArsNRUNZverW1JUBTcEV23DqBHQRpuA2E3hXSE359NYdhZai9O7gL24FwkVyendWPqsyTmQy8nyhoWB1iAd3ByOzHE3W0wMfIwDhmD55pGbyfwGyPnlrq4k6ZPxhsuQyrsqRE4rwF3eR+f7quAfNYbs7qCIduJo0goZ9vb4aDDe5PI5b3NT6C/ojlp2Lg671a11jMS8EVFuQ3+9OILX+Vm6wBAxQb5z8l5dPPazJdHQ==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by BESP189MB3209.EURP189.PROD.OUTLOOK.COM (2603:10a6:b10:f4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Wed, 2 Sep
 2026 16:30:08 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:30:08 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Wed, 02 Sep 2026 18:29:38 +0200
Subject: [PATCH RFC v3 5/8] selftests/kcov_dataflow: add binderfs selftest
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-5-824609f279f5@est.tech>
References: <20260902-b4-kcov-dataflow-rfc-v3-v3-0-824609f279f5@est.tech>
In-Reply-To: <20260902-b4-kcov-dataflow-rfc-v3-v3-0-824609f279f5@est.tech>
To: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kbuild@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, llvm@lists.linux.dev, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Marco Elver <elver@google.com>, 
 Nikita Popov <nikic@php.net>, Matt Arsenault <arsenm2@gmail.com>, 
 Justin Stitt <justinstitt@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, Yunseong Kim <yunseong.kim@est.tech>, 
 Yunseong Kim <ysk@kzalloc.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=7994;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=2j790ogdr1HzkZ6NTDWczOZJLsnVEgjQog2ryxzpx9Y=;
 b=t9dFfII43eg4tYZfy6YY5tMG5t2Ixu2SrPDorHAjV9ZLb/LdpNClnAgg8kq+AH76HMOEjYsK0
 A8vvEwJE3xCBg1WHemM/qXWpYMeglUtgfWhQkFn3b0Ri/ir3yhf+9lz
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: AU2P273CA0098.AREP273.PROD.OUTLOOK.COM
 (2603:1086:200:6c::11) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|BESP189MB3209:EE_
X-MS-Office365-Filtering-Correlation-Id: 83c72ff9-f7e0-493c-9445-08df090f73d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|366016|376014|22082099003|18002099003|11063799006|6133799003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	gk8t/Qa5QTrs05LEWB8fwY0WVV4i7hswSV+jfRThBCIAZMEceYraunskruJh+7uuyv7TsgCb/r1k4L8C5eDxHXruLnqxQ2BHiDuFOjh1tPoVNzpj7Ef8Wwd6eT7/Yp10PYS3oNn+HnlA3ygAs6XfordXcbrvflow2VDl0evDbE0yM/9xO4stSofTQWP8PpwhntcX5DyZMkuVErl7xfxQ8cnCBpKMWM25EUX4lLlOIJqNP2eTnoocEjiM9RTi3JMmD9wYHO/UIXhiBOHG1Pzvdp/6cCZy2w81BA/KB0ngciHzcDgWhgGIt7EeDPhpA6C5h4osnS5katd2wuiwphPR51GU+XKDYGUPlgzNaN5LNzrjEinqwr5gKf+oNKdOLGUsIgo/4A5q5aqyCPLi1QfELyFRytFekAGUSk/gRthXl5gAM8NNksPOm6Abj5C1sdhv0VE5FjJdDE54iJ7OVYCWpRq8AkHZAk6SseFzWksHAgzzTwLc1qzMw39udCS833A4zn1CrUlFzVwGuhaOg2jGe/wuOoGEH8whvAZmJSDzCVPtk+gKsogoDRABkYezVJ/XWutIX91rjDu9CtpwrBeGjtMK3sCQ7IE5x8b7P3/etH5300jUT5GVG0An/JGfwoyrasvPC81CBvn5jV/7lRrTPVtIJ7yoQRjk4jq1HGc6ECw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(366016)(376014)(22082099003)(18002099003)(11063799006)(6133799003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djJjblZrZUZFbk9NQWRxTGszMjNuQnNzUzRtbEZ2aStPUFRBY3k1ZGZ6Tzdo?=
 =?utf-8?B?V241aEhHbmprNkpHR09Ec0RBd1I1TFRRM2RJZ0h4eUdiZVEwNmlSYmdBTGVW?=
 =?utf-8?B?UjB1V1I1NUFMSUIvb3RRT3RrNG5nU0xvc0h0VFZhM1ZFOUhORlNUd2tGaDBm?=
 =?utf-8?B?eXorTDZNeGJvM3BOZXdWQ1d0RVYzZjB5Wm5uMG1GZGM2UFF1YzBiaDNOZi9U?=
 =?utf-8?B?SG1QVWVXeURJYjVUNUh3K2xpZnFlalliUDlsd3hqdmhUVytRQXVNd0l2OGZ5?=
 =?utf-8?B?TDZDN0tRdEdNNCs4WHIwSmo0RW55T2M2STJlNlhiTlhuNkJ6WHFIYzVjd2NR?=
 =?utf-8?B?ZGZPWjQ2RkVGVm0ybjE5bnFEYW9BMTU4QVFXSmZHK2x2Vy9VSjNoUEVmcHAw?=
 =?utf-8?B?RDh3eWltLzh6bVZ3QUVocTh1V3BDQXE0RDNpVk9KbUM5aEZMa0pFVDdpbTdT?=
 =?utf-8?B?SE14REZZTGFjeTRoWHBpdVhYalZPaU1Ya0NLMnY3Nk9YMXZiU0Ftb2JKRDJO?=
 =?utf-8?B?WVdwNzBBY1ludERqSy9sQ0xHSkwxSGNkd1daL3A5NkVlS0tHdWZpMjJvQ1lN?=
 =?utf-8?B?aStScG01ZmQ2TFFsT3NTb0NpQk1URWRESG15T3N2QlJZeWpVY1c1S0pSSXNu?=
 =?utf-8?B?cXpzOWx5UjZMVFlFU0k0UGVXT3F5dWl3bzBhN1BUbkpGbTNlQ0tobzRYQ0Vh?=
 =?utf-8?B?dnIxdld5NWRWd2ZTWFFuT1cwSDd6cHMvWHZGQUVsTW9lanNpNFUzWDQ1RVlF?=
 =?utf-8?B?Ujg5MXU5bmhNWE05TWI4dlRPSE45NjJrazU1elVFYm9QUmF3d1l1L2F0R0FL?=
 =?utf-8?B?R1VsSElyYlQxTnZIV2JXejVUemQxTldFamljQjJ2cURZWDY4N0UyLzVLUmhI?=
 =?utf-8?B?Si9neG15QndFRmtaemJNQjlPRHZxL3kzbDM3aysrU3pFWEtUTlJzOUIzcmFl?=
 =?utf-8?B?UmZOQW0rRTJmT296STkySit0QTdidW81a2lFMEZ5aVlzeTA2cm1tRlBVQkRx?=
 =?utf-8?B?N1JzTmlwSnJ1MmU5cG1PVnBFRlVqODVWc1ltM2J0ZTd0SFpwNEIrb1VOMnB3?=
 =?utf-8?B?S3M5RGxkWkY5cHFONWQ3QzBRVDBjOG00a3ZWSjQ5cTkxUGR0VWFqYmpUK0Rt?=
 =?utf-8?B?MU16bUxmakpYN2VsOVFXSDJxZHNwdjVEbzJFK01hK2JCVzJzTDRKd2lZdXU0?=
 =?utf-8?B?bmRrelRRR2hFZjZMTUQ2OG5MMk5zNXFNQTVlVjRhOGZldDBrS0ZsblZ5UHVQ?=
 =?utf-8?B?TCtPK2xEZ214NE9DSnNFeWxYUVRIKzdtL3QxQ1ZyTm9SWnRvZXBkQ2N0ZGRo?=
 =?utf-8?B?WmZ2di9kM29rcFpaWDZlVEFhd1lmdVlLZFRaaCtBMEhhbm5Mc2lNSUYzb1d1?=
 =?utf-8?B?bWI2ZW1nS05qOWhaMXBzZ3B2cTE4ZmU1Ujk0eS84a2ZSRElOcEZGUVdOdWVC?=
 =?utf-8?B?MnNQL29id3FyL3U2RDhxN0VpcUlGa1NpaGhWem9Nb1E5M1NoYlBDc28vRVRz?=
 =?utf-8?B?L1c2U3BqVlVQNWQwVGtwM044NEl1Q1d5dXNKNDdMdDhOUHhuZzJaSFRNTm9W?=
 =?utf-8?B?RkVtWkpEQklHUGF3ZSs3QWpJTWduN3NKMndaS3AxOVpuTnhoeVJ3djJUUDFo?=
 =?utf-8?B?czNMRlV6ZDBLaEZvNG1EUXV4VnhVWTVyalBiOS9tN2kzMWNNODhUTC80SnNa?=
 =?utf-8?B?WERaTmxGNXhnblB5TFA2ZEdOVUREcGprRFI3ZnhQVEk1WGl1VTNpcG9VaUlT?=
 =?utf-8?B?MDgxRVpVc0p3ejZpLy9RWWM1TWxnblBFMGFpOGx5RFRMb2hldzQ4TWxQVURK?=
 =?utf-8?B?WW5mQUZ2YmtOM0h3VDJ5WkJkYmRVNlcvaXQrTkpFWXRVRWlDZStFNS9jU0xH?=
 =?utf-8?B?djZJenMza2lmbnplZzZ2Wm1VTjI5SGdFa2NzUjMyeHNvSTZiK1dpZEtLUHJZ?=
 =?utf-8?B?VDJCNzNMSWRNejBpOCtkaXlQK3VWb0oxV2h0cUNub3NmeGxscjlRcWtpWEdZ?=
 =?utf-8?B?dWM4Wm8xVXhmUkpLYVdRNDdBRGVhYzJTWnlJRDZYOFMvNDgyTS94USt1N0xK?=
 =?utf-8?B?VVQ4UzJRbmZ6aFE1QjRJNUl6MXZTL3J6RXVCL253RFhrU3U0ejVsN0xscDV4?=
 =?utf-8?B?OUt0UC8vMHFFQTFNOHdwaWpQNm4xclVORytac253MlREaUlFcm9SYy9HZTVv?=
 =?utf-8?B?SkF6UjdSME5jVkUzTmNkSys5QkJWYWNaY1lxeVZXVlZSOWE4MkV6Q2R2MEF2?=
 =?utf-8?B?V2xxSDV6T0JxVWhFeE1xSUoxdTk2b2Nnc2Fsc3UvQVpCaTIvdTk2TE1CT1g5?=
 =?utf-8?B?L2Y3dkRlRjlHenZvaldBZkhjd1UxZFJocEZSTlVweWtBR0hWU0ljQT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 83c72ff9-f7e0-493c-9445-08df090f73d5
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:30:08.4291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYRb5fhTu7hgop19OFwO8jOjMQ9yccXIGxQivLEoMSF/LowVYMpLA4dPluVyelFtPF81YX++BFYwujVeVi3dAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BESP189MB3209
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CA6840003
X-Stat-Signature: q3g43xkrbey761g3aqiut4ypyf8sys8o
X-HE-Tag: 1788366621-181978
X-HE-Meta: U2FsdGVkX18kg1klEOIrtOQ3YuYKSmGyGq69OtTBCXdDmRXCjWDtB+a0GkhCDBnZPncaUTwKz8J9UUU+vSsDAeKUmWeyiu25t69tFgd40pIQgJQla1WQeGUnH+Qqmwu7uaP//IwhBPLSr49nc5r9aJ6O8s84XJNm8oPDX3KS4wWXQqNbJ3t2EMkkKCgk6m4RycuHEeBLg6IaRgkUI3nsrNNMNvin3RXEuZCMb6DF+CV9nHsXRgg6a1UBNqiN0XqYrwbCMUIQVs/MzVdYoJPThVPrrcfELtI8Iw0as+wWMOA4kdc2UJV35db2CBVEdbH49uCUGFR6/Aje6aJvHpgachK19i3wjqH+cqrJ3AwDOrjQZGNtiT4Ev5W07ng1mGjpHoBa1BGuBMmphJVY6OSjq2jdpTRqOnkQPYuiQjS+RH3IzfRunfPVPM2t7I1oSf16Cm9hLRaRRHZcTn5Ucs5w9eoWsk0pWbaFdXZlSt4yfbohFz0ZpRt8AHTkanGuKf4gimv5A3UOUJr3kTbXdjSYWU6SMAMXdEybcf9YMLUNyjJcTc255VetfxUZN6XboI8bP6wPWlCZ/vljYT5ZfNP6X8EEprKLw8Vgtyshn/Vvub/XnVceAPax5ymWMv7EINsnwGE90uArLB/mGmIDQapby48UWpJRTvqHu9qnB4eh/o0jj4OzYpoIhaLnwrvULkKknkJOq78cUIhPBxbeVQt3Nw0HFnJSQInDK6Dat8rHyq0WcyPO6CzUYigJmpsbNUgKtUFiy+6ArAQQqAtLOPV5fsNvSStSKdkZ/wE/bS6ZGL95mXAXtAzmbOSGf+12sWVhAEWHbMlMMmCQ1j8wUMkvL0/hDWoehx8HcXSeX2Q8vvKteMeGkzNjplrCUOF8bRbPi5s229YhfOUdvUUuPCJMoRHrIfoKKEOMMeUI+mjsajgZpVTBSyBudasjwzOuekq21M78TKP6RWDUMDTHNL1
 JPFsZjec
 4RKQokHj3JqQ1UUELMWzM+ovWBzqqAK77wt7oTvyqD1FmJLDS8NSAvTKXyjy7IPi6dm1piXC1ctfLQLD9mS8V2HfZuAC/+KhmBECfJS+1ZpXvdwoU3uOe7lSEYJiV1mwxL7nqind2iFJ3V46nQsGNLkIGA0W3VOcXGiMKwYrbVLbrZTrhjyMlbHOU1ycEI3GGLUCNk84a1f1ajbJ2GT6VYEhZVXrRIV8S7We5tP1TaiMLprMiQ60l1ZYAucqu5vSGCKNv1axMf8ACADT1kHvKrUQSe5w6fjd/Qp9KsSHAgzJLAIeT+t8uCwHBmCqN50/nsau2ERAqD+FIL+cDBEYcTYeaOwi4q86UN9fjaQwlLGl215VgrQ1DGlaPbnXPcBVTSlCXMPFald8mSHB/UFBKazsZ4XBoQe6JQJNu576E5t6omY/23JwhhdND0DrpxKFGXl3JNAflM06t5JwaDbxGdGb01T/q6fMpnjJxOO9/UXxXjttZpj9OyKMF2vo8mirnpyE7qEVdqm6LLu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kselftest that exercises the binder driver through binderfs with
kcov_dataflow recording active, checking that argument records are
captured at real driver ioctl boundaries rather than in a purpose-built
module.

The test mounts binderfs, creates a device with BINDER_CTL_ADD, enables
recording, and issues BINDER_VERSION and BINDER_SET_MAX_THREADS. It then
walks the buffer: every record must carry a known type (ENTRY/RET, or CMP
when comparisons are interleaved) and at least one value word, the walk
must end exactly at area[0], and at least one ENTRY/RET record must have
been produced.

It needs binder instrumented, i.e. KCOV_DATAFLOW := y in
drivers/android/Makefile or CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=y, and
SKIPs cleanly when binderfs is unavailable.

Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 .../selftests/kcov_dataflow/binderfs/Makefile      |   5 +
 .../selftests/kcov_dataflow/binderfs/README.rst    |  13 ++
 .../kcov_dataflow/binderfs/binderfs_test.c         | 195 +++++++++++++++++++++
 3 files changed, 213 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/binderfs/Makefile b/tools/testing/selftests/kcov_dataflow/binderfs/Makefile
new file mode 100644
index 000000000000..b35de6264992
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/binderfs/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+# Standalone build of the binderfs test: make -C tools/testing/selftests/kcov_dataflow/binderfs
+TEST_GEN_PROGS := binderfs_test
+CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
+include ../../lib.mk
diff --git a/tools/testing/selftests/kcov_dataflow/binderfs/README.rst b/tools/testing/selftests/kcov_dataflow/binderfs/README.rst
new file mode 100644
index 000000000000..7fcdce1955c1
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/binderfs/README.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests: binderfs
+=================================
+
+Exercises the binder driver via binderfs with kcov_dataflow recording
+active and verifies that argument records are captured at the binder
+ioctl boundaries. Needs CONFIG_ANDROID_BINDERFS=y and binder instrumented
+(``KCOV_DATAFLOW := y`` in drivers/android/Makefile or
+CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=y); SKIPs without binderfs::
+
+  make -C tools/testing/selftests TARGETS=kcov_dataflow
+  tools/testing/selftests/kcov_dataflow/binderfs/binderfs_test
diff --git a/tools/testing/selftests/kcov_dataflow/binderfs/binderfs_test.c b/tools/testing/selftests/kcov_dataflow/binderfs/binderfs_test.c
new file mode 100644
index 000000000000..650798e09b20
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/binderfs/binderfs_test.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * binderfs selftest for kcov_dataflow
+ *
+ * Exercises the binder driver via binderfs with kcov_dataflow recording
+ * active, then verifies that function argument records were captured at
+ * binder ioctl boundaries.
+ *
+ * Requires: CONFIG_ANDROID_BINDER_IPC=y (or _RUST), CONFIG_ANDROID_BINDERFS=y
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <linux/android/binder.h>
+#include <linux/android/binderfs.h>
+#include <linux/kcov_dataflow.h>
+
+
+#define BUF_SIZE	(1 << 20)
+#define BINDERFS_PATH	"/tmp/binderfs_test"
+#define BINDER_DEV	BINDERFS_PATH "/my_binder"
+
+static int setup_binderfs(void)
+{
+	struct binderfs_device dev = {};
+
+	mkdir(BINDERFS_PATH, 0755);
+
+	if (mount("binder", BINDERFS_PATH, "binder", 0, NULL)) {
+		if (errno == ENODEV || errno == ENOENT) {
+			printf("SKIP: binderfs not available\n");
+			return -1;
+		}
+		perror("mount binderfs");
+		return -1;
+	}
+
+	/* Create a binder device via BINDER_CTL_ADD ioctl */
+	int ctl_fd;
+
+	ctl_fd = open(BINDERFS_PATH "/binder-control", O_RDONLY);
+	if (ctl_fd < 0) {
+		perror("open binder-control");
+		umount(BINDERFS_PATH);
+		return -1;
+	}
+
+	strcpy(dev.name, "my_binder");
+	if (ioctl(ctl_fd, BINDER_CTL_ADD, &dev) && errno != EEXIST) {
+		perror("BINDER_CTL_ADD");
+		close(ctl_fd);
+		umount(BINDERFS_PATH);
+		return -1;
+	}
+	close(ctl_fd);
+	return 0;
+}
+
+static void cleanup_binderfs(void)
+{
+	umount(BINDERFS_PATH);
+	rmdir(BINDERFS_PATH);
+}
+
+int main(void)
+{
+	uint64_t *buf;
+	int df_fd, binder_fd;
+	uint64_t total;
+	int valid = 0;
+
+	printf("TAP version 13\n");
+	printf("1..3\n");
+
+	/* Setup binderfs */
+	if (setup_binderfs()) {
+		printf("ok 1 # SKIP binderfs not available\n");
+		printf("ok 2 # SKIP\n");
+		printf("ok 3 # SKIP\n");
+		return 0;
+	}
+
+	/* Open kcov_dataflow */
+	df_fd = open("/sys/kernel/debug/kcov_dataflow", O_RDWR);
+	if (df_fd < 0) {
+		printf("not ok 1 cannot open kcov_dataflow\n");
+		cleanup_binderfs();
+		return 1;
+	}
+
+	if (ioctl(df_fd, KCOV_DF_INIT_TRACK, BUF_SIZE)) {
+		printf("not ok 1 INIT_TRACK failed\n");
+		close(df_fd);
+		cleanup_binderfs();
+		return 1;
+	}
+
+	buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+		   PROT_READ | PROT_WRITE, MAP_SHARED, df_fd, 0);
+	if (buf == MAP_FAILED) {
+		printf("not ok 1 mmap failed\n");
+		close(df_fd);
+		cleanup_binderfs();
+		return 1;
+	}
+
+	printf("ok 1 kcov_dataflow.binderfs_setup\n");
+
+	/* Open binder device */
+	binder_fd = open(BINDER_DEV, O_RDWR | O_CLOEXEC);
+	if (binder_fd < 0) {
+		printf("not ok 2 cannot open %s: %s\n", BINDER_DEV,
+		       strerror(errno));
+		munmap(buf, BUF_SIZE * sizeof(uint64_t));
+		close(df_fd);
+		cleanup_binderfs();
+		return 1;
+	}
+
+	/* Enable recording and exercise binder ioctls */
+	ioctl(df_fd, KCOV_DF_ENABLE, 0);
+	__atomic_store_n(&buf[0], 0, __ATOMIC_RELAXED);
+
+	/* BINDER_VERSION - simple ioctl that exercises the binder path */
+	struct binder_version ver = {};
+
+	ioctl(binder_fd, BINDER_VERSION, &ver);
+
+	/* BINDER_SET_MAX_THREADS */
+	uint32_t max_threads = 4;
+
+	ioctl(binder_fd, BINDER_SET_MAX_THREADS, &max_threads);
+
+	ioctl(df_fd, KCOV_DF_DISABLE, 0);
+
+	total = __atomic_load_n(&buf[0], __ATOMIC_RELAXED);
+	close(binder_fd);
+
+	if (total > 0)
+		printf("ok 2 kcov_dataflow.binderfs_captured # %lu words\n",
+		       (unsigned long)total);
+	else
+		printf("not ok 2 kcov_dataflow.binderfs_captured # 0 words\n");
+
+	/*
+	 * Walk the records: every header must carry a known type and at least
+	 * one value word, the walk must end exactly at area[0], and at least one
+	 * ENTRY/RET record must come from the binder ioctls (CMP records are
+	 * interleaved with CONFIG_KCOV_ENABLE_COMPARISONS=y).
+	 */
+	if (total <= BUF_SIZE - 1) {
+		uint64_t pos = 1, end = 1 + total;
+		unsigned long nargs = 0;
+
+		while (pos + KCOV_DF_RECORD_HDR_WORDS <= end) {
+			uint64_t hdr = buf[pos];
+			uint32_t type = KCOV_DF_HDR_TYPE(hdr);
+			uint32_t nvals = KCOV_DF_HDR_NVALS(hdr);
+
+			if (nvals < 1 || (type != KCOV_DF_TYPE_ENTRY &&
+					  type != KCOV_DF_TYPE_RET &&
+					  type != KCOV_DF_TYPE_CMP))
+				break;
+			if (type != KCOV_DF_TYPE_CMP)
+				nargs++;
+			pos += KCOV_DF_RECORD_WORDS(nvals);
+		}
+		if (pos == end && nargs > 0)
+			valid = 1;
+		else
+			printf("# walk stopped at word %lu of %lu, %lu ENTRY/RET records\n",
+			       (unsigned long)pos, (unsigned long)end, nargs);
+	}
+
+	if (valid)
+		printf("ok 3 kcov_dataflow.binderfs_valid_records\n");
+	else
+		printf("not ok 3 kcov_dataflow.binderfs_valid_records\n");
+
+	printf("# Totals: pass:%d fail:%d skip:0\n",
+	       valid ? 3 : 2, valid ? 0 : 1);
+
+	munmap(buf, BUF_SIZE * sizeof(uint64_t));
+	close(df_fd);
+	cleanup_binderfs();
+	return valid ? 0 : 1;
+}

-- 
2.47.3


