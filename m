Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015A8CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666D96B0098; Thu, 11 Jun 2026 12:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616DC6B009B; Thu, 11 Jun 2026 12:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505DA6B0099; Thu, 11 Jun 2026 12:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42AE66B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:21:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04AB3C1CB1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:56 +0000 (UTC)
X-FDA: 84868148232.19.AE04ED9
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 20FCA40002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=APusSClx;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gUwCp5AgFOtQROqvKz+0UcZEedw4/fv9Nv5OBc/iCA=;
	b=j3D4hThLohzRMdshVOHo5vJJdcbR+Dxueb+7PWC874tvBFcWhz6GgSbnF5evlynLaXQMNH
	q9lA6DFfS9kNRxzwuomE4NLdPVM2Ajcz3RlhvIwXGvoGMslJhZyOZ7uEWHIxarl9zCnJ8y
	+lNhN6Dk5ncg+W+s08SkNF0bM08AyrM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=APusSClx;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194913;
	b=D8wCLtu7PAlndAK4wLk4lq4q9brKud8yfrB5adPw2EHzUqNgaP5HMmJmDYAJUUsHFBQOU0
	Vj+SAcWPe/cuXfZxgDezXGVwZYSbLj+le0l577eE2X6e7/VQf6NWVbxG9hK2DeCkujcWmO
	xiGv65aHh26KyPVQUoVfHVivOROBxlk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQoCvJn0Yo59gfHHQYI9tTHZcWo4o7hksjj/6o+haDlfCg4OJEYMLiReaX16cYGFrKGtxbXeY2TYyEmUP5RJPW506zdwekdNSbWMo/dmdzZnrXRyZP3wN9Ig8vfHO4hoyRDK6RjKOvg2ctciYV/49Td8qyOMdK+4qJ+fyNDvsyIJsi7Qk27UJ5wuLczn23QLpmofIYtSGvdrr2f+5bjg458f0PO+7n+XSgS2Ms/NOmEjsR+1iYUQRDKTjtB63LKBZfwtcnAqjL6or/GJSAW69i7f8U7R8oSkRT22sWyxpLke/qS2TIouwNcnxP2g8EhCeIDYRX+NcCYhzsnGEkrRZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gUwCp5AgFOtQROqvKz+0UcZEedw4/fv9Nv5OBc/iCA=;
 b=qiJk3kGQ2Qm7ta1sbgDdlkjcnItoMLJ7bjr/u1rf2vkS/HH5z04DM+3F0fawV3p+IJt3Bdx9vhKSBbG0jUzDtL+ZYtYm4OnqYG0sJINcGPPrMAeDpmLJi53zvHuL+HMIn7mDW+qYhwcHEA2yaWYFMIf3kIu/zrIfYs/YEnaIlj2BrEJcsKBU2aFDx5blIQlyUtmv/HyxkmefHIBjUnu7S/cY8n6PjrL57g1SfkEoltYsYL37Hq+ocjwQk595/6XojvdKW8q8hc5Rf0Z/kV/WocfLaUU5tPgWjUa4n98zJToB8Dfx0dXIFAU8qJqyJaaMzR5ylCWkj05LzN95+FNExw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gUwCp5AgFOtQROqvKz+0UcZEedw4/fv9Nv5OBc/iCA=;
 b=APusSClx8BrHI9O0fGbskQhuQhRNqQlik7I7H50CcDq9S9fFk2cu27PbbA4/9yttiR1llYtjfITdIPAftb2ktrYXRw1QyvCd/RlGCQd42KJjNwzvGRvxYa+UGWs+5cAutZgxdXwypWiYTm3EnKEXWWwFYw1s7pXnGVk3QSLOy2AB5z8gyWkzMbj0tCGa1EOQBKh35xB5nCSbCkkt7sVJsjCqbLPH3M56dPgmyXe6xYO/L70yZ7xbzbtP+Wx34cD1GDMZz48sibsRqX/RtluYiBzklhx79TGQZZXXRx+ouONbP8hyNYDFGvt8YsyevN8XbJWUYD36ACSZqnuJfiVfZg==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:44 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:44 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:05 +0200
Subject: [RFC PATCH v2 03/14] kcov: add barriers to recursion guard in
 kcov_df_write
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-3-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=1194;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=DtTK/AwDIMCe6OV/j0JPVlnaNajVItLVDATu96GAQ40=;
 b=6s4thnbvxtn6G6L9s8cAEalXqwxmJVxfMkv2yjMZhMZC2zLywFqsPTA4LZ6bJUxdqXa9GaJjV
 uoV33ShugW1C4iEe2uRkNob9F+OczQFeFnWF6Oy1aFmItngDpMJZTtC
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV3PEPF0001DBB5.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::6f4) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: bb0c2c64-c500-4586-17a9-08dec7d586ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4+E/3FCMz5pzjomtdNxEd5uqo1C7kxe2wN687gJ+aULvUy3l2uiz0jpyIZZlwgvGJcmjeujMMmyZ4A1TwJiPG+pcamTDtgPDq2oEWkWYoIsX8pFV+K8VnUtpBP/0uXbnUMvF0swNSkNf9dnOToPvMI21jS+yaJJEvNWOo5J8JL5PVXsRSl1Q4MBYa2zb9htlPKGgrIOZ3SglQP94P4wHspPW8lnTw+CaYhR9eLDlzpGwkNR64Mt67B9tpstP32PEFaL01RMTs6AeIF8PEpA8+63Dks8HJq391tiVk4sotG7hxURJ3phWjMN16cyQRHOGSgslv5PTYp7kXmJ5FW55Mg6XzqMVoniHgpC/bFx+hWwY/Cx+cVkCwCMtD3wZ1CPgsMhQmVcX3jLFE+W8ywxnoIKsWp1o9zcNjzh1ZrFQ0h+QpNaEd+C0T92RmpM4VMrWb3Y7nAxLeB5UDb47chkpCGoP99/gHOl47MhcjsbU3AyojhDHbG1s1LYC8m9ds3nGWdAk/EqbL/tHmQ93EbAzI4FQ4dvtg4u95ueFNq/cOTN6wy1VJcgU+mcGFZYMznHYmGv2dFOzMtWhZZ65J83HLuMGb8Oicep4FS0RkEqU7dMTFtOzhIaNa6g2gjt3VbRm+XfG4k4hdUGbCMzGH0iGrKZdp0bg6XivDjo0Oei7Ffl9Gh/3705ggYv5bjI72O1brTecZNnxCUdWyU4aN0+hLZ3BBR1HM5LPG6wA3cfOlo8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlNNS1ZzWm8rYk0zNzQyV3NBMkZZdjhubzRKMU9mbzdhUFBLa1dmYWpYV2pI?=
 =?utf-8?B?TklQaXgza2lFeWFWNDkxajZpekFvNVJOa1ZISjlBUHg3ZlpmODFlRGpKUExj?=
 =?utf-8?B?Q3pmbnNzYnYvMml1YVVTbkozOWM4Tms1VG53dzVoUmExU0xWQVZFSlZ4RDRW?=
 =?utf-8?B?SDFqb1lEK2Y3TVFYYkUrQ0dnSzVUM09wQWpIcWNjYndBLzhjelJUM013RHRW?=
 =?utf-8?B?alhsQjFIYmMraUEvN1diaXA5cmUxUWp2WkpSYlRQK0ZXRG9hV09mejgxa0cv?=
 =?utf-8?B?UnpUV3JBTDF0UEJ1SGgvUEllMVNLY3NpM1FJd1FnM3YxaFkyOUZuNlJuRVVH?=
 =?utf-8?B?MDQ3VnZhMkVyNjMyOU40TmQ2Zjc3cXdjTjJQMXRFNG11Uk9iaXhNQ1hKNUJ0?=
 =?utf-8?B?NFlHaDBIeUgvSzZITHFOcmRPSVRLbmNQQlNvZWxkV0pKNkR6NlB5UkFVZ21k?=
 =?utf-8?B?QkpwN085d09iUzdRWHNXcnZYeXZlampkcVlWNDJBWFk5VUM0d0lTUGZvam5Y?=
 =?utf-8?B?eXhEWjJTSmxBd1JUMldqZHo0a3Q1eTJEenFQMGdqbmRubGhEako2QjhkczJu?=
 =?utf-8?B?Ulh0VTdhRk1hZDE1NWVxbUFjWmZZd0UyRDVobG5FcXVwYjdHcW84MUk5djZV?=
 =?utf-8?B?TnJFVkc2MkVGbmJtMDgzQUtUbWdYbXNqdGwxZnhlL3JhZ2xETm40eFl6aU9Z?=
 =?utf-8?B?L2lFVWRNWVk0NTR1YzBXemNaSWVHaU1nRFVkYUM3czQzOEpRSzhvcEVPRDc3?=
 =?utf-8?B?ZGIrUnU0WTB1dU1RS0hqNDd0ZHpiWWpiazN4djBIYzdTellISjl4Q09maytp?=
 =?utf-8?B?MDhVQUJJaFZ4K3BVbGVVRG1NVkYzZEd6cGxmc2o4NmhCWjU2MUR0dkVyUzJM?=
 =?utf-8?B?V2JCTnNGNEl3aEdua2Q5TW9FU2hMN3paalJyMUVnSk9Od0RwSUJ4cVRQUGVQ?=
 =?utf-8?B?RVBLeStSZmJBMFNEcElBTVpHVUdLNS9qaW55aHYzNzkyOXZTajFuOHhlYTBV?=
 =?utf-8?B?aUNIRys1V29yNlR2U1diRVNzNWxrTlZIUytOMUw2dXFZNDZBNzF0bEtCZGFH?=
 =?utf-8?B?V083amxpbmUwOUJQU2xjM3hDVVo1ZWY1TTg3WnB4dDdWaUFINjlDdkNCSmZV?=
 =?utf-8?B?N2FqZjdwQnl0a3ZXV3RLK0ZCYTlqME51VS9MMllQSXlXNzh1c0VpL2ZMa0t2?=
 =?utf-8?B?Q0MrejVtODFGYmNNcHRRcjJhTkdrdHA1QUVWazRHMHNROU0vcjNVWCtURzcr?=
 =?utf-8?B?UXFvcVhETEZoZFdvdUhCTnphWlp1Mnk1SFNjcW5ua0dndUttakJrSmN6K1pj?=
 =?utf-8?B?OUlkS2pjTXl5ZzdHeDVjVnZuNjhMZXdRZXBHVmx5b1hXNXBoY1ZxWGNnam5k?=
 =?utf-8?B?ZTlnS2oyWFNyRzRrbU1MMXJJNGtqUXdyb3pNRFNlYVZqS0tQMDJHd3g4KzhJ?=
 =?utf-8?B?cSs3WTRtNmhLWXJaeGNNOWdCYkcyZjVmOEVWZ21ZaWNna0tOQjYzd0o1QTJY?=
 =?utf-8?B?R3lwbDZCMjZUU2ZDRUZUMmZhT1hkYkRMNzUxRm56R1UwYXUwZWMwRUVHeHRL?=
 =?utf-8?B?MFB1U3g0YVRvRXo2d09kbFZwR2w5M3ZJY2JaanRVSVBWYnlwWWEwMndzdDZK?=
 =?utf-8?B?bnJvdVFzZEU3YU9lM01JcVlKSUZKSG5oYnZBNUoweXJmd2h6Q1BOems3eHFZ?=
 =?utf-8?B?eWdlbXEzcmxTT0k5R3FlSDJGcWVsV0FOUEswR1FHS25VRGZHRHlnbVFUR2Jv?=
 =?utf-8?B?U1lmZjB5ZStqbU0zbjN6eFl6Mmo5ZGc0S3FueFpCMDNsNitmZkNWdnIwOXUz?=
 =?utf-8?B?ZTZ2bmxVKzloUGpOc2Vpd1EybkozV2ZrbndDUjlkcDhNWDI4NlJ6N0FnNEV3?=
 =?utf-8?B?d0hsTlN5Yyt1WkdkdUw1T2xTZkZ1YndRVHpFTjBoRndoSTVaRm1rTXBybEpu?=
 =?utf-8?B?U2ZEcTFEbVM2czhqZ3JPYTZIOXVtbWIwcW1zdFBNSXprNnN1cGEvK2RYK1Fy?=
 =?utf-8?B?WEVVZ3lkWG5BLzlpVjQvbHR5OGFYUVV2eWRMYzVqRitYR21PYmdTNW5idTVv?=
 =?utf-8?B?Q3RLaFF4ZExXMTkvL3ROK1pHbTV2ODJEVzg4NDVpNzZmS3lvUXR2RmNTVHU0?=
 =?utf-8?B?clVKd3BnT3ppc2lNN3BtZ2l0NHpNL3ZBc0pvOWdWSFZmY1djOVhPdC94M0ow?=
 =?utf-8?B?M3p1bUpuNXVDYWJtUVZqcEgzSWk3RE8zbzg4OEluM2dodWE3SEk2M2VwMFJi?=
 =?utf-8?B?VGVUVFJXOUJ3S3M4alRPS1JFdEl3ZmxFYy91d01OVG9sWDE1aHV3R1RXbUpq?=
 =?utf-8?B?cUg1OHJUa3l3NkJ4MzkyaUZGL0M5Y2JNTFZ1MU9qWFdiaEs1dS9XUT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0c2c64-c500-4586-17a9-08dec7d586ff
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:44.1288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1qX/VqvLp0hOuaaRSQ9kFtX/64Miy6C1fD8ab1CUCzPTW9T3YBYAJhbxNHUAiHErzAG+bNBU1x81vVCn2BsMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q7f6cuqytcr8y1zcm745bppr7q35sxaa
X-Rspamd-Queue-Id: 20FCA40002
X-HE-Tag: 1781194913-748848
X-HE-Meta: U2FsdGVkX18OnCxc0XCnDkdcsi0AbROH1jR4c3lxFkboDO1gWc7vMQ2DYlPZ1T+QBywr5HCorX4AeR+SQNiG3gA+cwbtG2sNFL7NYvQuV3+LmocDf/bHp9UHe1lQpc8u55WkhS1INhBJrtSguh4W2Dx7StZR9X4Cu/H4ojQp2Bki5ymo5Nz5dlMFZuz8ELY4YCop/kFZ9m67AF5e7w9GEyA0ogBwJ0+MQWzLbk4a/z+N4BVgL3zym8W/f9hUyQ1xLDYnJFR5BhNRJGwYkD355DP+0hJU0FIbzK0KOYtKUina39l4vZOe1k0pjc4h/v0ocEVus1fgGwdfcf7z3G4D4xQpD63NFT6pYKlR4Fe0+FUh7YqnWkSrZzEyHInfshFBslChfmhun93x/mCjzkYXbnK+ROJl/OVi45aN3JkFSU4n42zIMN9OxClkKaYLxdp4kWv0h/w1Jyt0RicmePlv0tOuMUEjT3eemAbd12KI7zNUA7u6ezxFlRzxfNYHYpsmq7GwxK9mJCE/T7Ig8PPkCkPtjYPe0DdxPPCpdHQx7GZJmtVKFjAvd8uPk8PHIfyfSoCoUXQdY8qnYXKaPYCgwMsKHMzr5KH1HlpyXYc5BI3pg74LgremNTUK4O+PxktNWzncUY6keOioWycxWo3myL3pP1s3AOPVl+tOf5LZjzA1hQzeuFWWTInfKQSfthLFBuJU1ptHRXOeoMTYJFlPTJmSVzSaP4XCezzVqyTWHFcwu5mJCq5R+nGz0aUrfioD8yNINc01Ssi+a+5AYcOwH56UlwANFCb1JiXoW8TYCxjY/virNT0bfkV5ql2XFZ5ovntg/ihObnJ8sxxmmB+SZXBXMlR87vkhs3ScU6xhW2cI6LrWUCCQ89ldfAfmdldv69dbvrgmnb05FarFo875UUa1k2rGZl3CehTShoiAILpTPTpmdHOzY5idgUuLRXlqWdpYzC2smBsRw3E+AIH
 v4sToSvL
 SlLbuuATjKMRfL8hWYUYps6UU4pYRwPqVpeWnZe0KucYcsGVOPkOtU6zjt73cYtAyVKf674assJy+bESoSgGA7geaPmUPKQrN2lxyieXbhgxYfvQCktb7NNUeeYy2ILdVyLU+VzN9dWZyjDYMTAXpAs33arSDPpvG/SzCJ97ieFT2OiWUSo6o8GvBgEhyrFNgkhX1uoT0RTRP5ZWgKHg0HuNw2WRG8J+Cth2Pig64A+EXvWdVDiFZCzX/3mV3eGvod7pAHelbITvm1obwl/6LIuNYk8wWOYcn/LgDQIY6eojszhkh8RRheNZDaAnUYC7HFHrkKCwjnUt0rBqiQTHR1eEzL+WIflalV43lrKqeHHU3LHznM6Xfll1k6NYAlW7H0VS/AieehtmJpNTvZq0G0akLh/jbJdL+bi/xzXR8PZN8x350yWgjau6m8JgFdtXWjQD7MCfEaTZzUsZnurCSI46ITHG1WjIcogquZFwZmu6uF0LstOGMoD6fpYYpqS2UMth0yf5Qt3fAU7wfrErJWziisLa7nFwGcgj/Ox/cYTdNk74cPp0wEuag1rKy8yYvUhaE7s1hchQlfm0/0+KupqFaeMdk5CNx9+3cBKwR387SuIHYcPlhcUb3YtSQ38+KIcqdIbxjj4gXfgum0c93veZHI41tuDCsIDSQQRgijN3FiaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The recursion guard (bit-31 of kcov_df_seq) prevents reentry when
copy_from_kernel_nofault() or other called functions are instrumented
with INSTRUMENT_ALL. Without compiler barriers, the guard set/clear
can be reordered relative to the function body, making the protection
ineffective under optimization.

Add barrier() after setting the guard and before clearing it, ensuring
the compiler does not move instrumented operations outside the guarded
region.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 kernel/kcov_dataflow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
index df7e8bf70bfa..5248293280d5 100644
--- a/kernel/kcov_dataflow.c
+++ b/kernel/kcov_dataflow.c
@@ -86,6 +86,7 @@ kcov_df_write(u64 type_marker, u64 pc, u64 meta, void *ptr,
 	if (t->kcov_df_seq & (1U << 31))
 		return;
 	t->kcov_df_seq |= (1U << 31);
+	barrier();
 
 	area = (u64 *)t->kcov_df_area;
 	if (!area)
@@ -147,6 +148,7 @@ kcov_df_write(u64 type_marker, u64 pc, u64 meta, void *ptr,
 		}
 	}
 out:
+	barrier();
 	t->kcov_df_seq &= ~(1U << 31);
 }
 

-- 
2.43.0


