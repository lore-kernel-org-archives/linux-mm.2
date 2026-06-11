Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE28BCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4455E6B00AA; Thu, 11 Jun 2026 12:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C3B6B00A9; Thu, 11 Jun 2026 12:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD636B00AA; Thu, 11 Jun 2026 12:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18BB96B00A8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B97D6120768
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:14 +0000 (UTC)
X-FDA: 84868148988.04.B8C6BD4
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011058.outbound.protection.outlook.com [52.101.65.58])
	by imf18.hostedemail.com (Postfix) with ESMTP id B6F3E1C000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=pnOWWgPT;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194931;
	b=c3taqomnWLtlcg52aUYNQuxD7YwzX5XCyoJrgs7deMrbHRc4oaNLRGJEY1pc+pO3W81BPk
	4ruMpcQTpcgT8oR8MiZhpvNN2jqwKkzRnDQPt6BOsBK0q73/cWvgccsPLX624dPWncNQaS
	pk62kD4/vv4YAdyMiJ0q5BuUvde15wA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=pnOWWgPT;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWpBGa9Bxt7VzvS8PLudFJQTc3v2XROBC4kSRu7VSAg=;
	b=XFLAIWKUGINgKCAt0768cWW05z4nlkCkOkJmUp5N/VOECxWkyDzZIStUOe1JI10pNUFDC1
	dcImpLsJ2uzB1cU798Q6ivOtT2wK+/d2VPJYMVXH46ooGmiMpBlvpdhxI20vjAvPJGPdZV
	tm6ChqkoTFFKSPE6cuPxf8DOlPZ//8o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fNCCw8gDHe8R68nVJ17p8+ZeDW3zPrjKG2QrqCpVKIyzZBhQXwoYDKKJC20BMdXf91t6efOl+xdsW4rk4XJ/6h92XzZ21z3THpXHMq6Khp5ZS6xEUdUOwQNxAjbqJenshr4dbGGuySXJvELv7lkfKDSWfCdd/p8XfVZD/aB1BBdRIFtn8EEB8NZ5VHQcpzyJduH9DVGDcLvYsdn8dGxKiocDbsObYovZg9PE54kXylHQDvQd16vIkNFraSZQH5J57ZjtIkl7mgW6pwKHhgEbned3H9BEPNHMWJjsmPbpD5ryDGUoCgo3jNkPaqKQYygubIPRJGUc9W5Lfw7dbbksew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWpBGa9Bxt7VzvS8PLudFJQTc3v2XROBC4kSRu7VSAg=;
 b=Q6XoAD8NFfj6o0SELYOU9XzlI8YPUZ+YXV3ncSWW7cc96vsMXHgi3JFDY8XJk2spn32GjmNQuf0wbamL2bkT5DUDbUnH1rQFFj+tg+SOgtiM1IQoxbxJ9IBwHX5g+h3CZGZDTGUdofyC7pZjafMSt7/NicFtMtfWm5Qf5kd2r/WbrjPjydzCryUFiVrIfdOYBKIRON4T0beIEn5uCcI16uaJNici0Mr1Yyyy+WVlvnfNOKp6n6tgj/nFHSJYVwhSouxaH6a5s8/B0WsVARDKW9qVflVjhOOx8MP9YeGUZMQw0f6/FCbx5zLih0L9jHQyh448MFBSGiUqWN2pI0de6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWpBGa9Bxt7VzvS8PLudFJQTc3v2XROBC4kSRu7VSAg=;
 b=pnOWWgPTf+QA6HQPdViPLCWKPIcOToU7hlSV7f+lVkImoSAkdHNTrWspZDjlS8ZjcNq1dyWCWyE7HqSwzQ8Ha7t6HqAGmXZVHnGHuG9bgs6eRApTpfrcXRsCjsLOaGR40TG//bZopvT7ESOe+zymv/2HuaNapUGFbgFS9DTozt/6i2CJqp/YzXAInX+OMG9eBIhyMYb94gQscP+fNAWMNTM7TTTJHqSEzW/C3w2R2V1MazxtJI5RrBwoLhmT5Z4TBAD/hcNyZ14G/sNwBXI61BUK7ZGXNVVNRt0rfGE3BvEqrluMNh6JZx2nh9SqbJjbN34jmm0tlUo3V+BRLvR6+g==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:22:01 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:22:01 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:16 +0200
Subject: [RFC PATCH v2 14/14] Documentation: add kcov-dataflow.rst
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-14-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=12496;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=/QO7d0pbLHh6PDXLjjWzFubgN6kPyE0jU7Dr92rYdGY=;
 b=djzukwNo+OmamenYPu+h1hlnGM1Q1eKpTy7Lkob/n535yCIsP008ubTTkjqdJErql5jBJKLXt
 bu5itSDzg1QD35LNTmLWyNBOiQ5/KekYTC3Zl71uCLU8/+s3oEr4j/S
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GVX0EPF0005F693.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::13c) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ee207c-d882-45a0-49df-08dec7d59150
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7kXpKgAZ2npSI+Vazsj9EPVIK4hAdklIQvqjUVvI9iBAVabc2hw66gqmrzuXzDgx9a7aYOPpdVisxuVYpHkYqcposTqfluv1/DLn47lafC8Bums+9IS7UO7Hk1GZIBOLJ4oeUO67QNU/u1ZdSiFwMJFC6ULbG0oTDFmGx+wy71jkm9hS/8Qr1S3iPFha9FkZBKfSB+1e5UI57KZ1cKcPV/YQ5mEN062NZfA3HhsUSn/sULr5K5R7zKaPGYRHQhEx+tIcp6RC/W7dnX+mn9ZJWbkNctGnb85IAv3o9TwIhjJ/i714/wjUXQbayIfLT9yGgQaQEYiKysJtsjwuS47lgWwze5WlO/7gdsJtVpqBbtBBke+SzHaVho5lI7NhCDuUcOvs1Jey+1/BK8e2KVpViE75HkGg5lSm+/uCsRLQipEOY4sbTYsNivkJpo71NRt8YJkDzSxjT9MB+fcNVFzBT5HoDMMpJBcZgshorKB1PSpBs5r9Uds4k2143Ibfm5/491YsDGiTmDuifC9V7iO48jUrvTRYpTC5yYgdSv95BfvIuddxB3ata4P2ymwmq69M1IPQF3qIXeveuf76M1wvjU2h/ShUjZkKzSlUFr76c7k0BDn7p6Ql9v24sM59a3eiAlFhDDmOdQZykCWjFotM7eQdD+OKQKhzdj5CRZ6t1dKP85s4ThhPEKSml8mvTnuq0Fr+PBZ3mlHNn5cMfaL0GesrxacY76atYKwgRd98Xyo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGtyUmNJYmxSbDBabzl4WFlvYTFITFRhOXVkRHdFcDNoS2grbDM5bjk3a1pu?=
 =?utf-8?B?ZkxBQVFCUFNtcmF3NzZ4NmNHZ2dtSGRMOEhCRHJmb1VQZzVqMnB3OVVJMUxG?=
 =?utf-8?B?Qm9YSG4xaDU0T2daOFpwN1lWT0g0WFdvQnRCUnpCN21IY01SODlEL1dIT29m?=
 =?utf-8?B?U1Nla2VQOS9FRkh3K3lDNUVQSFdzMTJHMzJ4dUMvbFczRTFmM1FOY0U0enlJ?=
 =?utf-8?B?Y1Y1dU9ReXNpSXJRUVRLUGwydWZ5UmVFU05kQXpXSHN2Q29lUG5jRk4vV0cy?=
 =?utf-8?B?dGtvdm9GOU5ydVRFRDNud2thVkRFbVQyWWZocitOVnlxcFZvUnFjcDVwZ2hE?=
 =?utf-8?B?RUJibzhnZDJRbCtBM2JCV0V3Zzk0VEkwUU5LRGp0WDF3RFRLbUhZRGFicXBj?=
 =?utf-8?B?aEhDbElza2VvNFJzVWRtRjdQK3lUV2dzRDV4NStTVHFSVHpIU2V6eEVhd1Rl?=
 =?utf-8?B?MUV6TFJwbzFQZjJrdnRCZGlSVWR6RmppSzN5cytjbEVNZVBVSmZHZlduSjRY?=
 =?utf-8?B?eEhOeDdIdGUwNWRlV0FIWUpGZlg5a1pPbjZJWUdQVmVZMlYweE5kN2xyRGV3?=
 =?utf-8?B?eEtyWDNuTkZBWnI0eFQwN2tGY1ZZTXNKQVhaeDBGMk9JN2xYYmZ4ZlRJdWxK?=
 =?utf-8?B?a2pCbTJZYmIzZVFTYW92YUhNQS9TcnY1UEdITEtQYWVpaFpBemZuMVphdU5O?=
 =?utf-8?B?YWVzcWR3dHVSdjZKVGlKWVlTYTBKMGtBRkl6Yi9neWl4VlY4NW9QMjRRL3Ir?=
 =?utf-8?B?SlVkM0x5aWt5NURVQXYzbjlvUmZvUzBReWUzc3R2cUVxU0toVzFmVi94K094?=
 =?utf-8?B?ZUhWNFlMTlRxcm5idDA3b2dRMDhIbndqL2N6aFBxWXd1d3pKTFZiQTZDNWds?=
 =?utf-8?B?dnZmUHRBUnBKV01UdjZUeUlDUVRpQjFibUpCRDJoa0lUbGVmemRFTGF6NHQ1?=
 =?utf-8?B?ODYyak0vUjZib05OMkZlS3dUMmZzZGhMdllWNElabDM3bkpoY3RLalhMSVRE?=
 =?utf-8?B?SVBycVo3S3JyajE0b3pqS1Rucnk1aGFtWWZvRXMzUHNwUFYwZlVaeXpKMXlt?=
 =?utf-8?B?MDdOaWVLbkJFaXN1QTFVaWJjSnVLZFhOdC9xdnNVdTNQdERxUWtsZGdmRjBy?=
 =?utf-8?B?anY0eGxaL1lQVXZTMUlQM0RjNnM0dElZV0hoMmtlU2Z5L1cveVFvbjc0UGZN?=
 =?utf-8?B?N3ZXTTMxdFRpbGRmUi9DVXVuSmxRRm9ucWxndXJuTUpQVXh6Ui93L2lWeVZY?=
 =?utf-8?B?NUVSMkl4aTZjWnE4RjFjeUcrZVBqUGl0YW9tL0NISGxJZmJORzNobjRXam9j?=
 =?utf-8?B?ckpJelMrbUI1YXczNVZRV2NlYyt5YjNDbExCbG9RUTVVeS9NSm1ObTZiTmtB?=
 =?utf-8?B?YkRnUUN5RWFyL3M0SkdDMmxFeVczTmZWRTZ6MG95empUN3llZS9nM2Ivc3pq?=
 =?utf-8?B?d2VLdjQ0M252WTlsTUE2eStIV3NmUHhyd0VNWFV0QldwSGtGQTYvYXQzaC82?=
 =?utf-8?B?RkkyVW9YMDhOTnlxaVhaekhNU0hoZlJmcjhqOGcwcDBXd0lPemtqTjhTanQ3?=
 =?utf-8?B?QmJmZi9YZytxa3BJNmRVYlBhYllGZEZROXZNYUdVYkZSL0FHTE1nQ2VXN2o0?=
 =?utf-8?B?UGZwUWZvSThMUjFWaU50NzhlaFBvY1dRMy8zeG5GVUx4eU5pUnI3QWtqUThZ?=
 =?utf-8?B?bWRaVHk3L0owa0xqK3g2NVJYblF6NE44TmZWc2NlTUtQbE1FcE1ZdDYrejNH?=
 =?utf-8?B?UUJxNW5SaWV0OUlKWklEMVFuMFE3RmJ3aU96a01naXlSVjIxTFhMZnV3cDFF?=
 =?utf-8?B?YUlSR3VDcGRmUllJdHdBeG5XZUVkc2NYQnVzeGFQaUFRcVhCbDlhWmdWY2cx?=
 =?utf-8?B?ZEsxc0h3YlFIdGNVMW1wY3lNN0hpZmRBcmFIcnp1L1NEOXNZdG1WaG51amZt?=
 =?utf-8?B?WG9TcFE0U1hDRFRKdWVickFKZEVDR2cvZTRsYnBCek4yS2tGMGd0SmFDVzgy?=
 =?utf-8?B?Tk83bUlsSUMvWmNjUktLQnNUMW1YSGdSMElvZ1g1SFNpN2RoRGJQWldsa2Rs?=
 =?utf-8?B?ckhOMDh1amgrM09hd2lYRUF4eUR0dWl0NmZ1TlM0UEd0ZkxwWHIvT0JVdnd1?=
 =?utf-8?B?K2g3ZHFJSjc4TFVtY3QrNXErcE16THF0a1dDd2lDeFRnWk5ReklSU2dBc3Q4?=
 =?utf-8?B?VXExZ1E1WlFYeWwrQjJ2aTNvSWpHcTVDM0ZjdFdlbFZoUExUWjJ6THdHVTZO?=
 =?utf-8?B?V05JTW9PbzFQUi9sVGpGU0x1QzhCNzdYblZNSndCVmlrbVFldWZkNTNTRG9S?=
 =?utf-8?B?TDJMN1UrbmNMaCtvbWxBNmlBM1RQWTJrMkxyL0JMamNWK1ZRaVJIQT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ee207c-d882-45a0-49df-08dec7d59150
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:22:01.4854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lz2tdGPdgSR3llAbP75jWb9xs33EXLwlqly9t6QAo6TjkOwDtLWWpChFjGL+Hpgf+CZ0qBI0gCqqJdK4eLOVAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Queue-Id: B6F3E1C000C
X-Stat-Signature: 98qemngoosnsq58psosouxnfeyewcckm
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781194931-904653
X-HE-Meta: U2FsdGVkX1+PAjU2h8rb8vXfR097SlJGPcXftMPlHPCLaRe/LC6izkf0FpcRf4i6n7KIQcPu/rjLOFarbmww8niT0srNYc3OhbA3fdpLeM1whLvlyw5xkCKtCrEfCPFLeR4VMfJFnVLb4QCs0CYBIwdFsnQ+5nEOgbtfRbdT/Z8nkeiEDQTBFqeCJKGBk9Ir9WgXv5tr8vdlAdQ/6WyQKieRB8zTZzYXQSrshb1hgfzR/cvH89Gll56y+/wUBdwyFDyqryV4yAq2dGju3gZkNm5+WSg0WHPbLsybTAO576hFUW+HSPWl3CG/XNp7Z+5uUC4ybWeNRVBpxJg8o37lc85ttynYQY78VzYiPJfSP4/CRKatKDL277QmIfhaUBKxWstxYYzh0dTOv+oSWI2U9DIoK+cKYtAAUkEnxzLJAAu5xpik1cHUv21UdYHXuBu7PzsscAFpRDcn9RHBOum9xPM95jopdV+ne5lK0KwX2WyW4fWBopCI1x9KgcsURVuzyjibkLlKMb7L4VPM0B/smxK1X2bS3hMQ97HEwe2vwiZRAhfopTZVJt6oiPRxQaomvoMXqx/98Y78EbJfJ+Ke87zlB51JxfPNVfYdvURQtNNEyKq+13BQv6RGHvltbzhMI8nbbZCvtYl8hjucTPlup0Dd9OdEYnTW73S771jkVxslKnA+BGaKJWL+V/xe6gS83RHHvOJo6iJolkL3nuBmrlRdEKa3zLq1i1Z1JhpNSGLzpzPWiONagKkgSaUwFKEy7gkEsYnO70qSSwP4vSpBFJDZv8FLdS3DAg47g88xguzpcscw3fGD/+8gbx0ur4qeC+ZbrHl6gPYu6hEcd8XhfTI2BIlCN1LLC7XKnHEJbVUYRPizcXsQHgKCPEI1KNi5ZRZ1JAGZtYZ/A+itLVLiME0tlvFG3QaxZutsd9Wg28dOLtppNJcFls995toJncxZoPCHEc/dy/I86zwNo6P
 HXNhB6dU
 Bm7Td2U+emHeolZhmjVXLySBsyRK7LFntjSFMMPmI3DTP/Yb5jITtv+xLfo9qAJbUx7mE0BoxIv3GQrwvx5DrPGhY0HrjwL1vLWA6XQgDGU53YkmTJ2WOQpcwYCVaYf/AKYNG47ZJuVrNEnfrQdt+6yCWlMTB1yks0ITCawEBgW4rfP0XTRNtV6nM7NQDVwKPzUR+eJdG8q0Ph9mo8/ZkRwnAYZyfj0aaj1XPR4HM2dx2exz5wP48fDv8PkcyODibYdRUEaADbIfQCeiMprC5tLUrUgqOADsOiqRJBJWAzwRfAUgpVlAIP8yKCu2nMgqOu9GuOWK+M6jDv9GcNMqiGsK34qJUvsQYpiYaBL+p7y+iVY6BiagT/LP3kFXWdm8rUXgNg0o2fy6zNjGw48BmxjVd39S+DNAORQ27RyMvaw/XT4B61llHEKv9bLvmHW8B5Nmr1bx0WZ2ftqFckhuow9D10p7uXEvfGrhxaAPZAQYMQddXiNlsqiFduvpghHgtyyKzvhIwvH9kRoqz60VKABrThgzgI/FdI+R3sh+ywxAuPQH+ushqyl3gCFASujrwAQe8N8Cm+2wVf/WVfHCid4aEOw506MYQQaLP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the KCOV-Dataflow subsystem covering:
- Prerequisites and Kconfig options
- Per-module and per-directory instrumentation
- Data collection example with buffer parsing
- Ring buffer TLV record format
- Safety properties
- Ioctl interface reference
- Compatibility with legacy KCOV
- Rust module support via post-compilation pipeline
- Fork/child process tracing pattern

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 Documentation/dev-tools/index.rst              |   1 +
 Documentation/dev-tools/kcov-dataflow.rst      | 321 +++++++++++++++++++++++++
 tools/testing/selftests/kcov_dataflow/Makefile |   2 +-
 3 files changed, 323 insertions(+), 1 deletion(-)

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 59cbb77b33ff..541c58cc65ea 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -24,6 +24,7 @@ Documentation/process/debugging/index.rst
    context-analysis
    sparse
    kcov
+   kcov-dataflow
    gcov
    kasan
    kmsan
diff --git a/Documentation/dev-tools/kcov-dataflow.rst b/Documentation/dev-tools/kcov-dataflow.rst
new file mode 100644
index 000000000000..603c83946d12
--- /dev/null
+++ b/Documentation/dev-tools/kcov-dataflow.rst
@@ -0,0 +1,321 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow: function argument and return value extraction
+=============================================================
+
+KCOV-Dataflow captures function arguments and return values, including
+automatic struct field decomposition, at instrumented kernel function
+boundaries. It provides per-task, lock-free ring buffers accessible via
+``mmap()``, enabling data-flow-aware fuzzing and post-mortem contract
+verification.
+
+Unlike KCOV's ``trace-pc`` which reports *which* code executed,
+KCOV-Dataflow reports *what values* were passed and returned. This is
+a completely separate device from ``/sys/kernel/debug/kcov``.
+
+Prerequisites
+-------------
+
+KCOV-Dataflow requires Clang/LLVM with the ``trace-args`` and
+``trace-ret`` SanitizerCoverage extensions. Standard (unpatched)
+compilers will not expose these Kconfig options.
+
+To enable KCOV-Dataflow, configure the kernel with::
+
+        CONFIG_KCOV=y
+        CONFIG_KCOV_DATAFLOW_ARGS=y
+        CONFIG_KCOV_DATAFLOW_RET=y
+
+Optional: instrument the entire kernel (significant overhead)::
+
+        CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=y
+
+Coverage data becomes accessible once debugfs is mounted::
+
+        mount -t debugfs none /sys/kernel/debug
+
+Per-module instrumentation
+--------------------------
+
+To instrument a specific module, add to its Makefile::
+
+        KCOV_DATAFLOW_my_module.o := y
+
+For example, to instrument the Android binder driver::
+
+        # drivers/android/Makefile
+        KCOV_DATAFLOW_binder.o := y
+        KCOV_DATAFLOW_binder_alloc.o := y
+
+To instrument an entire directory, set the variable without a filename::
+
+        # fs/Makefile
+        KCOV_DATAFLOW := y
+
+The build system automatically adds the required compiler flags
+(``-fsanitize-coverage=trace-args,trace-ret``). Debug info is provided
+by ``CONFIG_DEBUG_INFO`` which is a Kconfig dependency.
+
+Data collection
+---------------
+
+The following program demonstrates how to collect function argument and
+return value data for a single syscall:
+
+.. code-block:: c
+
+    #include <stdio.h>
+    #include <stdint.h>
+    #include <stdlib.h>
+    #include <sys/types.h>
+    #include <sys/ioctl.h>
+    #include <sys/mman.h>
+    #include <unistd.h>
+    #include <fcntl.h>
+
+    #define KCOV_DF_INIT_TRACE  _IOR('d', 1, unsigned long)
+    #define KCOV_DF_ENABLE      _IO('d', 100)
+    #define KCOV_DF_DISABLE     _IO('d', 101)
+    #define BUF_SIZE            (1 << 20)  /* 1M words = 8MB */
+
+    int main(void)
+    {
+        int fd;
+        uint64_t *buf, n, i;
+
+        fd = open("/sys/kernel/debug/kcov_dataflow", O_RDWR);
+        if (fd == -1)
+            perror("open"), exit(1);
+
+        /* Allocate buffer (size in u64 words). */
+        if (ioctl(fd, KCOV_DF_INIT_TRACE, BUF_SIZE))
+            perror("ioctl(INIT)"), exit(1);
+
+        /* Map the buffer into user space. */
+        buf = (uint64_t *)mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+                               PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+        if (buf == MAP_FAILED)
+            perror("mmap"), exit(1);
+
+        /* Enable data-flow collection for this task. */
+        if (ioctl(fd, KCOV_DF_ENABLE, 0))
+            perror("ioctl(ENABLE)"), exit(1);
+
+        /* Reset counter. */
+        __atomic_store_n(&buf[0], 0, __ATOMIC_RELAXED);
+
+        /* === Trigger syscall(s) here === */
+        read(-1, NULL, 0);
+
+        /* Read how many words were written. */
+        n = __atomic_load_n(&buf[0], __ATOMIC_RELAXED);
+
+        /* Parse TLV records. */
+        i = 1;
+        while (i + 3 < n) {
+            uint64_t type_seq = buf[i];
+            uint64_t pc       = buf[i + 1];
+            uint64_t meta     = buf[i + 2];
+            uint32_t type     = (type_seq >> 28) & 0xF;
+            uint32_t num_vals = (type_seq >> 24) & 0xF;
+            uint32_t seq      = type_seq & 0x00FFFFFF;
+            uint32_t arg_idx  = (meta >> 56) & 0xFF;
+            uint32_t size     = (meta >> 48) & 0xFF;
+
+            if (type_seq >> 32 || (type != 0xE && type != 0xF)) {
+                i++;
+                continue;
+            }
+            if (!num_vals)
+                num_vals = 1;
+
+            printf("[%s] seq=%u pc=0x%lx arg_idx=%u size=%u val=0x%lx\n",
+                   type == 0xE ? "ENTRY" : "RET",
+                   seq, pc, arg_idx, size, buf[i + 3]);
+            i += 3 + num_vals;
+        }
+
+        if (ioctl(fd, KCOV_DF_DISABLE, 0))
+            perror("ioctl(DISABLE)"), exit(1);
+
+        munmap(buf, BUF_SIZE * sizeof(uint64_t));
+        close(fd);
+        return 0;
+    }
+
+Ring buffer format
+------------------
+
+The buffer is an array of ``u64`` words::
+
+        buf[0]: atomic counter -- total words written
+
+Each record occupies 3 + N words:
+
+.. list-table::
+   :header-rows: 1
+
+   * - Offset
+     - Field
+     - Description
+   * - 0
+     - type_and_seq
+     - bits[31:28] = 0xE (entry) or 0xF (return), bits[27:24] = num_vals,
+       bits[23:0] = sequence number
+   * - 1
+     - pc
+     - Instrumented function address
+   * - 2
+     - meta
+     - bits[63:56] = arg_idx (0 for return), bits[55:48] = size in bytes,
+       bits[47:0] = raw pointer value
+   * - 3..N
+     - field_val[0..N]
+     - Struct field values or single scalar
+
+Magic values:
+
+- ``0xBADADD85``: field read failed (pointer was invalid/freed/poisoned)
+
+Safety
+------
+
+- Callbacks are ``notrace``, ``__no_sanitize_coverage``, ``noinline``
+  to prevent recursion.
+- All pointer reads use ``copy_from_kernel_nofault()`` -- survives
+  freed, poisoned, or unmapped memory.
+- An ``in_task()`` guard rejects calls from hardirq/softirq/NMI context,
+  preventing reentrant buffer corruption.
+- No ``printk`` or allocation in the data path.
+- When not enabled for a task, overhead is a single boolean check.
+
+Ioctl interface
+---------------
+
+.. list-table::
+   :header-rows: 1
+
+   * - Command
+     - Value
+     - Description
+   * - KCOV_DF_INIT_TRACK
+     - ``_IOR('d', 1, unsigned long)``
+     - Allocate buffer (size in u64 words)
+   * - KCOV_DF_ENABLE
+     - ``_IO('d', 100)``
+     - Start collection for current task
+   * - KCOV_DF_DISABLE
+     - ``_IO('d', 101)``
+     - Stop collection
+
+Compatibility
+-------------
+
+KCOV-Dataflow is completely independent from legacy KCOV:
+
+- Separate device: ``/sys/kernel/debug/kcov_dataflow``
+- Separate ioctl namespace (``'d'`` vs ``'c'``)
+- Separate per-task buffer
+- Both can be used simultaneously without interference
+- syzkaller and other KCOV users are unaffected
+
+Rust module support
+-------------------
+
+Rust kernel modules are supported via a post-compilation pipeline::
+
+        rustc --emit=llvm-ir -g module.rs
+        opt -passes=sancov-module \
+            -sanitizer-coverage-trace-args \
+            -sanitizer-coverage-trace-ret module.ll -S -o module_inst.ll
+        llc -filetype=obj module_inst.ll -o module.o
+
+Selftests
+---------
+
+Automated tests and visualization tools are in
+``tools/testing/selftests/kcov_dataflow/``::
+
+        # Automated ioctl interface test (TAP output):
+        make -C tools/testing/selftests/kcov_dataflow
+        vng --user root --exec \
+          tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl
+
+        # Load a test module and view captured records:
+        make LLVM=1 CC=clang M=tools/testing/selftests/kcov_dataflow/eight_args_c modules
+        vng --user root --exec \
+          "python3 tools/testing/selftests/kcov_dataflow/trigger-view.py \
+            eight_args_c -C 8 --ko \
+            tools/testing/selftests/kcov_dataflow/eight_args_c/eight_args_c.ko"
+
+        # Binderfs ioctl capture test (requires CONFIG_ANDROID_BINDER_IPC):
+        make -C tools/testing/selftests/kcov_dataflow/binderfs
+        vng --user root --exec \
+          tools/testing/selftests/kcov_dataflow/binderfs/binderfs_test
+
+See ``tools/testing/selftests/kcov_dataflow/README.rst`` for details.
+
+Tracing child processes
+-----------------------
+
+KCOV-Dataflow is per-task: after ``fork()``, the child does not inherit
+the enabled state. To trace child processes, re-enable on the inherited
+file descriptor in the child before ``exec()``. The ``mmap``'d buffer is
+shared (``MAP_SHARED``), so both parent and child write to the same ring
+buffer atomically.
+
+.. code-block:: c
+
+    #include <stdio.h>
+    #include <stdint.h>
+    #include <stdlib.h>
+    #include <sys/ioctl.h>
+    #include <sys/mman.h>
+    #include <sys/wait.h>
+    #include <unistd.h>
+    #include <fcntl.h>
+
+    #define KCOV_DF_INIT_TRACE  _IOR('d', 1, unsigned long)
+    #define KCOV_DF_ENABLE      _IO('d', 100)
+    #define KCOV_DF_DISABLE     _IO('d', 101)
+    #define BUF_SIZE            (1 << 20)
+
+    int main(int argc, char **argv)
+    {
+        int fd = open("/sys/kernel/debug/kcov_dataflow", O_RDWR);
+        ioctl(fd, KCOV_DF_INIT_TRACE, BUF_SIZE);
+        uint64_t *buf = mmap(NULL, BUF_SIZE * 8,
+                             PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+
+        /* Enable for parent task. */
+        ioctl(fd, KCOV_DF_ENABLE, 0);
+        __atomic_store_n(&buf[0], 0, __ATOMIC_RELAXED);
+
+        pid_t pid = fork();
+        if (pid == 0) {
+            /*
+             * Child: re-enable on inherited fd.
+             * The shared mmap buffer receives records from both tasks.
+             */
+            ioctl(fd, KCOV_DF_ENABLE, 0);
+            execvp(argv[1], &argv[1]);
+            _exit(1);
+        }
+
+        waitpid(pid, NULL, 0);
+        ioctl(fd, KCOV_DF_DISABLE, 0);
+
+        uint64_t n = __atomic_load_n(&buf[0], __ATOMIC_RELAXED);
+        printf("Captured %lu words from parent + child\n", n);
+
+        munmap(buf, BUF_SIZE * 8);
+        close(fd);
+        return 0;
+    }
+
+Note: the child's ``ioctl(fd, KCOV_DF_ENABLE)`` will fail if the parent
+has not yet called ``KCOV_DF_DISABLE``, because only one task can be
+associated with a descriptor at a time. For true multi-process tracing,
+open a separate ``kcov_dataflow`` fd per child, or disable in the parent
+before the child enables (as shown above -- the parent is blocked in
+``waitpid`` so it generates no records during that time anyway).
diff --git a/tools/testing/selftests/kcov_dataflow/Makefile b/tools/testing/selftests/kcov_dataflow/Makefile
index 6412c90edfa1..9691b41ffd3e 100644
--- a/tools/testing/selftests/kcov_dataflow/Makefile
+++ b/tools/testing/selftests/kcov_dataflow/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_GEN_PROGS := user_ioctl/user_ioctl
-TEST_PROGS := run_eight_args_c.sh run_rust_ffi_contract.sh
+TEST_PROGS := run_eight_args_c.sh run_eight_args_rust.sh run_rust_ffi_contract.sh
 include ../lib.mk

-- 
2.43.0


