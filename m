Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74032CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975BC6B009D; Thu, 11 Jun 2026 12:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950B86B009E; Thu, 11 Jun 2026 12:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A4A6B009F; Thu, 11 Jun 2026 12:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74B576B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 381F91A0754
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:02 +0000 (UTC)
X-FDA: 84868148484.30.0C9DE09
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2CEEB40013
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:21:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=HNETnNJu;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/Z9buftd28jxr/zK/940oKb0JuRI9nUYB8vwv5I+Lo=;
	b=aaOqSC0UcB0B4dAem8wZK6S2B5h+u3feSiZgTx1elgXFd0Jxwp9Uh84cDok5wwL9H1XWug
	3on1rFnnCW1mq3t7mJd+Ft55y7bIyh2evKv5Nz4J7tVXxQcLW1zEVy1XfQZsom3Jni7evh
	wxsEzbqfMFNOx7GAj9VAtyNh/D/jWZs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=HNETnNJu;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.66.68 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194919;
	b=6lMxHkd7Ec+fc79I18gZITVAQFgVnvU9SD43PmB3Dohwk2yvCmxnUgo5zON21wzSJo8vDY
	JYycuyJIHL8M5/OzC51mFVJALTW1PK2+bnZLmkG8p2h9wXq2FF2SrRC+B8HU7w0o+PNt6v
	cQ8z2ePTuAM2uCRxrUX/Oxo68Jlc/tU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=foNZ5i5EmWGDUnKlDs6u+RoyJFADnL8G8lW5OA5pFrP3LCRCmJAZzs2Csu7rqqc27bjnjG63sr7WSEvpjMGgJn77Kx8JwDmQPfLL3SlmkQDLrrnOlx55u8WUoEh+4+A6P12CeEmq8VQtA02hTaM6YvUpz9hlOx0ON5jUgDpda+KwGJCg7e7fM1ZlQYxpqm1Hfvw07BDqkJWVlhzp3HPgTeXEBPjEvRDlFDXs8ohezyZX5F0M7UbBPnF1Vq65btvoAN7JtowkFJi5wzGkOBm5YN4t+C8/8IjTgpgGMtWAP04CgGIEdkOkIfCed6N7St8aoPAvTXBzrpJFcIzRiL6OZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/Z9buftd28jxr/zK/940oKb0JuRI9nUYB8vwv5I+Lo=;
 b=liDRIAzpvvzIYuKEDI7Q7cGEH4bj2gwwvwTsJFJt6fZGObrpJNgjtSs9ON3zJEQ8/IHoqEoR6cxBz5sqx3YwVwUlMpUycfoyYsY36aWVH9Q5qz+2M/BLD01pL+O4jii/qLQs/HiaJq8styG6VZLLAZ2/FR03G8urfqde7hosTv06sQ5DdROkVzJtWSylBN5iXs+faXJvOxwZ4FGf0Q/bFwYYq7MRzKVy3/btNRFl0O+PgdKDOIPL6cM+M3wWxeMTzn3wpm4GXXaHpjmRm+FAxYUujkzZf1I5BsnKkwVtimKj9yAIf+X6Jn8PGtWKUDOECDbi3mluYK6OKezjw5McLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/Z9buftd28jxr/zK/940oKb0JuRI9nUYB8vwv5I+Lo=;
 b=HNETnNJuKrtTMU61bry43x57VDPSytbXH02qlBqDUnLeFN8gjz9BTTP7db7QOYhU9WIM6w72+xZa1vxcOIh+YToN7PaMi+VGkCp7namOXShypxy8RJB7PSXH8HeIqFhgF+p6vu3DucLHFEFh2XWW2+dqs5OIaHpmR6sTvrfNPR1R9GJBhOdzjvhA+5nQfM5D18ZHQfKqMYVkeFCcHhLAFxhtnHxhQuDxV+1ls1vmBYUDDfUKEYuSLU5sNAzg43mAUW3gF4dVgMc7lvQZgRVKBQpW+5MQJXIvktBxcZ/ABU7UZ+S2l0YV2kadJvskVBH+fIihGjgY1MRf7Sy+3ufUMw==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:48 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:48 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:08 +0200
Subject: [RFC PATCH v2 06/14] kcov: clean up dataflow state on task exit
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-6-0a261da3987c@est.tech>
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
 Yeoreum Yun <yeoreum.yun@arm.com>, sashiko-bot <sashiko-bot@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=2400;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=Sl6u6AvdCIQIiG26Yfl2mpNG0w7ezgkO/1XDtS722aE=;
 b=+Kzb3ovU+beuHUv8M53MW3+pE00ij6W4GaFOkOymP0rlQbqr/UhgAjnK29kP/TquBrQIY/ay9
 eCCBeM9sEtcCBomWEne+Hj8+6lxSdwnH+tjJ6BozULhBfL4JDDddJ1P
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV3PEPF0001DBFC.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::317) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: efe2062d-e52f-4ed3-e82b-08dec7d589bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	quvWXfSxMSEUvFFbyZiJ+PaJ5VeCRCRT3cMqFCIB7Hlss0el7GQ62VJGs4ODW5BhhPvLqdPpDRW7gTGwFAZjZs2OVMaDGsbHMXOceMYA/po33bh30c6ICGS2VclxopDUoTnzlVYHptivdICxMw0LrM6Zad+C3R6VS89JhQ+4TTC3A9NZSeMQsXaa0EWmdQR/n45OYZVhgufg1sU0ES6yAZfZnCzHr7KPVdaviwS9/psdZY2gdyuF1q0t2frUXO8KApk2uL31fOCz2M8WHAeTzRKAl5WTM0EwTwdxb6OcNaSkuFVKXXw2Tz1Z4gObLCmlKFLxGf+Za28ivmd8j90Rud2E6jUJEpYb1+2kzatEr6wwihbok8JdivtleFnNSRJcl7fmHLYsYAu7r7HJ5pklDbiBt8GuFFrIEyvMDm8NVL7QGczy4osXCNzUKCOkdrVfyqGEreUBaSx7n5WJsgrxSl2k3EU89Cvm8ui8hbRRFn7itpikqUC/rL+Z9h8VA/xuJYcnDq7d6eS19J+X6XGukIQs5lJ2iYCmNRrWQfvL7tB4ug0smgE1ogPSJgrtAAi5ZrEd2nYKI0j2rtXvm5xrGkPn15UypKhYK7jQnce3Ce3HRGO7PpB3VLVbpb511+q/zd5MgJ6JcZ9/MOCbM6xhVHeUiQu9ItNWuBuRG18WqcFp07sBlzv75IelQiS6yq1v
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkJ5UGpBY0wwK3VTRVMxOExTZzlaWHlUS3dXcmEvQ1lsTFVKbmdnUmV1d2lP?=
 =?utf-8?B?UVF6Ly9ydnU1SnpVUlZ2VkRaM0F4ZU1oRE9nNGMzcEl4d01ObTM1MURpSjV2?=
 =?utf-8?B?alV1a25QUFh0YzNTdnAyMnFITzFJOUhoSVFiWGREV3ZxMi9sMmtNVzFMRWRM?=
 =?utf-8?B?ZUM0VWplNENycVg2ODd4UzhuTWl2Z0h5dlVPT21QL0haV01MSzVDRk50dWJw?=
 =?utf-8?B?eUhLNTVBS2FBem5HeFdCbURNVFduYkhzVDZ3cDBodjhzTU91VjRzWXlYOUw4?=
 =?utf-8?B?T0Q3bHRueGYvVy95SnAwNHFZVi9JazJVUXUxZGFTMTdkSGZyM2pGUmVQY1Mz?=
 =?utf-8?B?WTFrN3MyN0FtMUFWWkpac3FsdnJCdFpJREFDK2ovQXFGd3lnTkd2eGJaOGxE?=
 =?utf-8?B?ZFQyaHUrUzlvR05hQU54b1JKQnB5Nm5XUDJLMTEvRGZaZFY3ZXNiWVhDVEFq?=
 =?utf-8?B?cUpvMXgzSWV3OU5Ia0ZkWVBXL0RucEZ0eGplbVRMQ1V2djIyNkFaTUlNWHJq?=
 =?utf-8?B?aWFTWGpHNTdXYkphMDhnS0ROVitQZis1QnQrNmk0UWhGY0owUDI2aTU3d0JG?=
 =?utf-8?B?UjBwVkNCMXBEbVBjd2VzWFFMcVRpZFZnazJMdkN2MWVHMXdyTzY2VVBaWCtj?=
 =?utf-8?B?TER6K1hKTm9pc0tCRTZEbU5qWkh1TVpLaU52NlUrYk0rRWk4ZmZVTnpUb2I5?=
 =?utf-8?B?YWpzbS9pYWd1QldIVWxPY0VwZW56UlZQWEhBR2xsNmUrZHU4MGtmR3dqeXZr?=
 =?utf-8?B?RW5oRm1zMXE4bFcxdDJVMDlNaWZxRnpuR2RqdzZxSEc0alFvVjJXUjlYSlJG?=
 =?utf-8?B?VGovUzRQQkMvQ1hwQTVnS2pYa01sM1JoRkZnOTVndk51VDFQYTBVd0hWcFBX?=
 =?utf-8?B?d0FZR0ZsL29ueGIzL1pGNkRGai9raTlEeGJpS01hai9EWUN1bWg0VXQzSUMz?=
 =?utf-8?B?MUJmMG9sOXhMQlY0NitzZzJ2dUJyV3JSd3hZRDZzTytMWlp3dEdRd0ZKKzFV?=
 =?utf-8?B?ZmFGTjZzWXBlWU5kK3UxMXJIaVlhUjE0ckJrY1RpTDdMMUtHOGgrS2h3dnJM?=
 =?utf-8?B?Z1ZXLzhGTDJwd20xMGVvUFFTbGJwbGp4Z1RNM1NuS2RPZldwUUtIRFJibWR2?=
 =?utf-8?B?UlVwQlViNnlaVUVkOVdING1UazFDVVRMSlkyWFZGbWNzM2ZySGt0amNKb1px?=
 =?utf-8?B?L2laN0NNajFKdS9xT3hDVnhoclYwZTBvMUtDanBTc05XY1g5VktSTkJOV0oz?=
 =?utf-8?B?RWd4K3FCc1QyZFZkdHJOMlAyUTQxeEorRS9neGlwM3UzVHgwaExiYjJ1M013?=
 =?utf-8?B?dnVzc3VJRmZJaFBidWFRVzVDWVJNVjIyb1JlTU9DTlVLd3lBV1pzMW5vWW1l?=
 =?utf-8?B?WlZ5aVRwRWNoZys3TmNCMzJUdkJKOFhvTFo5aGdoeHMzd0ovR0E3WVEwQWJo?=
 =?utf-8?B?aCtBYmloMXRVSlk2TGVkb0RFMjNDOHI3SDU4ZEVhS0tXTkxTTHFXT045TVZt?=
 =?utf-8?B?NmpDZktaVnUvemsyc2h3SlVBTjZpeTgxMXQ4MHhkNEpheHk4eDcreFdIL2Jy?=
 =?utf-8?B?N2J4a2c5NjQvZCtUd29xSm1kNW5Pd3VkQ1gxT29sS0hqM2w4K0V1VTcwaGEv?=
 =?utf-8?B?enkyNFgrbE02T3JON1UzNDFGTzMvSmJqbHRrZWoyK1ExZUloQWNzdVdDaklW?=
 =?utf-8?B?RDZ1TWpwR3JTc1RPQlJlWWljdFpObzBRdTRrdlg3Q0ZmN091TXVpakNDTkpY?=
 =?utf-8?B?Rk9SSzloMzBDQW43NiszK1kzMk5vdE1zUDhta0NnN05XNVBpam4vb3pGb2Vv?=
 =?utf-8?B?RnpGVENnZjV1c3lBM3c5bThudUtHSkF3ZVhkV3Rsb2p6TkIxVVBNVXZFZ0o4?=
 =?utf-8?B?WVByWXdWY1YwUGhXQklROVJqaUlLSnU2MEY5TmdIdUJYRlJIY2pOMFpUTGVl?=
 =?utf-8?B?aDBZNkpWYzEzVloyeFl0L005WmoySmZSbXU1THdlNDVLTzdmWGhDbi9sWW4r?=
 =?utf-8?B?MnBKVGZod1poM053Q0puaWVlV2wxNlJveFlSSkw1ODdFZmNnMWxzc3RPUXlx?=
 =?utf-8?B?WjdSZzNOcmhXb05seFFlR1hLU3RDS3ZEbTdLbEZ6YXd1aUZMVUNadlN2RGRz?=
 =?utf-8?B?Vjk4TGZOc3NTdHdxRHo5dElmckZKSE92cHllNjRhbGozNmI1NXV0U2xPMTdW?=
 =?utf-8?B?SU9Yd1VSRHVyMm5XajR3VTNQcVkrZXpGVnhpYUFGSWZ6SGN6aWpCa1QwVS8x?=
 =?utf-8?B?RE9UME94RUw0T1I4RE4wc3c3VUlFZlZzVHlISEZsaDBsY2REZG5MZ3pLbzRv?=
 =?utf-8?B?MmJJelBKZXRjUXFhVW9sdnE4Wk10M3FGNkNxOE9oR0N6R1h4elpjdz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: efe2062d-e52f-4ed3-e82b-08dec7d589bf
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:48.7614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8IT8/Ect7M88fT2bAQx96ioqggdeYYhW17VSDRUM7HE4RyDzs/l4bj/KOTYLPz9KmGFA8wYX9dokCPhoyNk8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: h4oyp1yfwwooo5g9qk541psyw4nmn86q
X-Rspamd-Queue-Id: 2CEEB40013
X-HE-Tag: 1781194919-482322
X-HE-Meta: U2FsdGVkX1/PBOZuOP5JltSU1Hc5Fr87lqny7X1ZSGfwUno4mVhN4rM9nkxqQ3EmKlgcLpUJAy2yetw2zDjcY9IOHNu1xN1Mmp+Wbmxf5uiC2SPRisjFJ+ZODVR2trS3+cg+crnwdaacKaWsZmVzDJxt490mHaOpbGFHjRtMD9kMOgILulDpk0LyiWAeLHTR/nt9hQH+Qk22MYr60TklviAYGmqJQYH34bKChpXLQtdkeDIDFKnXFl5pAi6T5pXehs7KrAOU+NBF0pnxcfc22l7QrTsnEGqB1biqoQ/C8WRy+Wkn74eP1SL2XCobmNyKKNJD2gF61yIULVpfJnUGn9JtoW1YIEU7n1TVmgZECQ3VRZtLryEGOxorIh5F5SYYrOmCwMKTTBDtv3h7uo4wtjE2vwgewWHhw27k9EDdQQ5Wbg+mPG81r31u9fHTIdxo/iv6L6EUgxcKo9cFQwqoS5564+Lnd8GScb/YlM6Mahg9Zgb16WzfK1igA8FMxmn5QTOBdjdyf0F5FraL0+gkrHhgBW+WqG1flaiN0hTjcr/Q/Dyvc0KxCFYwzHqjV7xdLLBcHlUz1Bq6+cmwhTQKAVuHG3eRaPTY3XY4SJ59ZTK+z2lCLjIr7BdVOOJQ4If6r6BbDR6EgFm93jyzSjb9T+//Tw1If8LezRTvbz3hW7MVCnG+k/SRZuq/F42uawTqPFpFiE+leSImKHhej2EPHNgvsYIkxtPgETZJIdKkUt87wXY9gVtAZ6YRc5aUCFCOXkmZ8RT+MgwvrYaxr+5NP47Goc0cDukQKXqTZNaU0Y82wtYQBLza5+tmpcJM4yjRIEgcmWWjNdvDzZtzNDmS8z0NTl+j34/+vigm6/ScV/IZSHEEM9RQEbo2Hiu/zVvdNzbT5aaRhMz9Jm92r8QR7DZ2x49/JVn1IIxpzOF7gkpDzER8fsXjPQDRBsd/eo6az0e8UuCjmDtajXNBgfF
 oVjB1xPG
 5S3rY4qj6rrMxcss7KjgOexBKQSzApLiu7xWXgYp7nH3WyWRYEEmyhbuEIIEE+xQ3hS/nYxlUwqjqyx4FLfA9E8D+RccMYwvSks0ntbggFMDqfjVXkHQ8lhEz/tYup6YxapOPIG9sPIk+Dm4KCxJ3XTFIXp88vNaugEjIcIIlcDEbeAQkYSWbh04Ttnsydb55bz17ZQI80DGSRFJlNIws9EEhLEB39iLiIiNr1sHda0s62vY+xmU4tzOR8zT2cvRGxBubJ1XheZnIjtaBJOypiTidpeYr4LVg4A1l3HOW7ZD2XwRXs4Lz4X4O7k4szKj8FlPiutTqr2f+N+SMYLdUP5hQO0wslaSne8xj+G5u0YImqd9LIATVj6gC9o2PpoZsyylw45Rye40RP//XEy0ipE97tgOEWURcJwa5PY+5aNHVSvs3GXOHXGdTlB0Lwh2t1QwzKt+d8Jt00GAKecH9kB3ZeT6PXQ14RZJgKQ5OYsQzs8uUaFzarvP7xyCaWKpcxJYoe1SxJOxF18Xp5oVGnIwI7ZHjOBqInJygmCrREmsWQUP4BcUoWQTqO0F1yWXzZysBahAyOCT1MT3LzcrmsiX1EieCkGU4v/mj3kBV6S/bJjyDpWp5mFK2IftwEsVY3jAMWoy3a6eAt5f6g57cwYX7sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a task exits without calling KCOV_DF_DISABLE, the kcov_df_enabled
flag and area pointer remain set on the freed task_struct. If that
memory is reallocated, subsequent writes could corrupt arbitrary memory.

Add kcov_dataflow_task_exit() which clears the dataflow fields, called
from kernel/exit.c alongside kcov_task_exit(). This matches how
kcov_task_exit() cleans up the legacy kcov state.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260603-kcov-dataflow-next-20260603-v2-0-fee0939de2c4%40est.tech
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 include/linux/kcov.h   |  2 ++
 kernel/exit.c          |  1 +
 kernel/kcov_dataflow.c | 11 +++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/linux/kcov.h b/include/linux/kcov.h
index e9822b02982b..07d7823e5d6f 100644
--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -30,8 +30,10 @@ void kcov_task_exit(struct task_struct *t);
 
 #if defined(CONFIG_KCOV_DATAFLOW_ARGS) || defined(CONFIG_KCOV_DATAFLOW_RET)
 void kcov_dataflow_task_init(struct task_struct *t);
+void kcov_dataflow_task_exit(struct task_struct *t);
 #else
 static inline void kcov_dataflow_task_init(struct task_struct *t) {}
+static inline void kcov_dataflow_task_exit(struct task_struct *t) {}
 #endif
 
 #define kcov_prepare_switch(t)			\
diff --git a/kernel/exit.c b/kernel/exit.c
index 1056422bc101..af2314500791 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -935,6 +935,7 @@ void __noreturn do_exit(long code)
 		kthread_do_exit(kthread, code);
 
 	kcov_task_exit(tsk);
+	kcov_dataflow_task_exit(tsk);
 	kmsan_task_exit(tsk);
 
 	synchronize_group_exit(tsk, code);
diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
index 7cfe2495275a..df037b7e90eb 100644
--- a/kernel/kcov_dataflow.c
+++ b/kernel/kcov_dataflow.c
@@ -196,6 +196,17 @@ void kcov_dataflow_task_init(struct task_struct *t)
 	t->kcov_df_enabled = false;
 }
 
+/* Called from kernel/exit.c to clear state on task exit. */
+void kcov_dataflow_task_exit(struct task_struct *t)
+{
+	if (t->kcov_df_enabled) {
+		t->kcov_df_enabled = false;
+		barrier();
+		t->kcov_df_area = NULL;
+		t->kcov_df_size = 0;
+	}
+}
+
 /* File operations for /sys/kernel/debug/kcov_dataflow */
 
 static int kcov_df_open(struct inode *inode, struct file *filep)

-- 
2.43.0


