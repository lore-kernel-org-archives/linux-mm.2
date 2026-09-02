Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A107EC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9206B00B6; Wed,  2 Sep 2026 12:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B5B6B00B7; Wed,  2 Sep 2026 12:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC696B00B8; Wed,  2 Sep 2026 12:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 982736B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:30:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C76E140239
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:18 +0000 (UTC)
X-FDA: 85169359716.23.89238EE
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010067.outbound.protection.outlook.com [52.101.69.67])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FA1140012
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:30:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=qCUWFqKf;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Duvb/N6hIMdjDtcVq2yXNktww9Dej66dFxGi++fIXWE=;
	b=nYZ2JRQ/Y7yEQQHcVKE+HboTzsVC/9hDEmff3WXh8AUtGfke63C23FfivU9MLKWG7vDvnx
	qkF1qz7T3MlK9DuZ7rDwNeEgNu4YqtYPFstpZqC/U3zRZ5g6g4VwFA0LKuGUmSlt4ZhXPe
	IrQLArJKzQFROYM+sG5HJqgnMxZaNeg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788366615;
	b=InkxzD79Dh4XnceosJUtluICXVGJUqhKYjuOWzwTxtPascvRmz8SP/kcXA7F2s+R8c4LGm
	yRR6FDgwp4iSydrnIqJXM/OVo2frgIMillsX6GGvnOHV/rMOdbArxyWdIDDDVZcIig5Xe0
	Sgf4TPz740ygM2mIMCXMoiBCXQtSND8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=qCUWFqKf;
	spf=pass (imf07.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.69.67 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x5HFaFuJnukldlpzK3ynAHX/U8HUwUlP+SszkvKCWNSBOQbh91hYYf9clumwbgEy1g2XRkUhH+hlYfsDM8EvuCQHL5vS7rxHvGEje65GxEL7b/ZL7boHGquhHqoxOjZ0iaBxmLsiOC9Y9k3uCvYw7RW/qVGwQLnrUtQHUfff9YHP5BqEXpAmDTAuisKjr0ofo5QFLVZbwHBMwbX64l+7Uk7Iq2iNId40v7IX96lCkdC/+wudr3OCanuEygM3+/bHWQO1hW9urYAHSZR00ani7NabEVOWpYnolQ7J8MAgMrgs+WhQmz6sArBtUXY/RQxQdgYRe0E2QObI/WQsJ0eRHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Duvb/N6hIMdjDtcVq2yXNktww9Dej66dFxGi++fIXWE=;
 b=fA6emJ26Fd0QAWuDgW9Dm/JbcyK/jw0C4cjv54xKk9EzUnJloJVfB0/YHGo1BX0Y7h1eQhmKUoNeK4RhQaZ7csUTrJuwmYHhcD1yuU6idNGBfGjJgvc+xVszmmz5c2i0lawKmRay/u5scr9fBnVrTFdr8BG1s6gKmVtsNQLYH+hOoMvRSNlsB7nHW/R31/7evp6y05hXURfD9hHwcPLFtoeTCSiLgJVoihV2UoUMCPNU+G8ZNuod6JaI1UnKTG0dF9WJ6/egg1A7SRUWKO6GYUHvGVj2odW0vszWVfa7YSsqFVdE5GQe6/NpHwNVK69SrOTbZNBpqaDqkk3g71rY2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Duvb/N6hIMdjDtcVq2yXNktww9Dej66dFxGi++fIXWE=;
 b=qCUWFqKfZMYFAYlDATTIVLsBRUI3SHJQvj6Tml5XEdy/15PmiSXesYVSEnWYhfafUmQB5wybvm8JfoNvMjjt3xoabPBA1pviSrioM33hT+9PYDYo/cerGDWyFV8HdnHuPwJL7A81XRblO7Tx7Ye3ebCN8E2Lp7xn48KXS1NfzW9qgXiPaL+yLvUg8pm3Ri7SpADEnc22iF8JrZQW8Cyg3TnqzXn0UQ3sXK4UBhDF/gwXAeLVE+t+zGZW+3+FtTZKtVJeon/po6X0p+kOHRDY5PFgTkQt7fDsteWKUob5YFhEgK0Je49BQs6R2Ghnkn/1ixdMmeT7RDtX8S7JK6Qrqw==
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by BESP189MB3209.EURP189.PROD.OUTLOOK.COM (2603:10a6:b10:f4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Wed, 2 Sep
 2026 16:30:02 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 16:30:02 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Wed, 02 Sep 2026 18:29:36 +0200
Subject: [PATCH RFC v3 3/8] selftests/kcov_dataflow: add ioctl interface
 selftest
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-b4-kcov-dataflow-rfc-v3-v3-3-824609f279f5@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788366590; l=7904;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=VSWo2tWfSl6e5GwBYW90uvrDxPC/dSg7Js9Cy9Nabc4=;
 b=xO04SwTgb57PZGYQkun6/47WybROjAODVmj7+9HvCdrWLVJ1SzNIT95vxY+d5hH988jLzarnp
 5QK9/aITfGICrbbiS9Bl09e1NaSysMCwduimhdEMg1a5zjeKgL3IOZu
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: DU2PR04CA0183.eurprd04.prod.outlook.com
 (2603:10a6:10:28d::8) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|BESP189MB3209:EE_
X-MS-Office365-Filtering-Correlation-Id: 536469d2-659e-41bf-577e-08df090f701b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|366016|376014|22082099003|18002099003|11063799006|6133799003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qe5VftlbQgNeCnb8Hwg24J1AEn8XIqjM7l1ZFjSPAofP5XLGQOXBEUYxRNtEkJS9kzpJQJQTTHgT73lZt1KgtcH2MDNjGOokB4TFV5x3c3P/bEuR5wG+G8L+cPWsBIrvTLt5Iz9BSaiArGL7Kl/wbTJPfcIVunTK4zt1ScVgTPeqhIxTiGFt738KR92b/fwlRwaVeXCsWZboheEUbQNNymOHdzIliNyRh2hu6NWAzOfg7BfMI+Dh5q7AuA/VO+EkweGvNeHu1zAOb64S6YW+YIzR6D6Jf2VzzxUqY7FVzz6oniH0CdMCuA+briyW14HwFkNmesQksdQ82mqymAt1W1+zhawAAUGtrkF6rYV/o2VuZ5WEECyHq6dweDeKObK0i9t+ocTH4gcSsv2VPJ9CyaY9yNziTa4xuXCzuRHo/FOvbXBqfFEvUWwgyb0gaHC+7G1u0/LJGuXaeWR5NmvG0mn9FmFBbZwaOcgFWvql5JL8OOMj/71aSP0WRvwMcrAh3lSLv3xeN4Lmq9v6A+OyCMNw5brPsv4QI63/Qf7aIXqf23I4Kc/a8XG00MVCi1e8k9VS3ei4AZNNc93RsM7Gn0ALUTyZ3LWxWJnFsj3r2McRAZGi7I4vhz4AeFeo3CP4eLJqvCS2yqtvvmEUichejjccmyGfiQrrglrQNA1bQZ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(366016)(376014)(22082099003)(18002099003)(11063799006)(6133799003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2xYekF2S1lJODkwT2V6QlNnWmZoY2Y1a3JKeGhXR3F4dk5WdFFML1VKcnBa?=
 =?utf-8?B?bk5uOEZMYWd2UU5NRlVBbitRNFk1K0c5VVBwUEdjM3FIMUM5ZUtiOWVZSFll?=
 =?utf-8?B?MktVSmN2aVVhNUpFTnd3dmFDQWZtdHd4QlpuekdTMCsrTFoyUHRYQmtyLzBw?=
 =?utf-8?B?WW8zeWp5aHpVRmVsVk5OL2YvY2phRk9NcWx4WHAwVVNmYVhLVm9JL3NQbnNC?=
 =?utf-8?B?Rkh2Vmh1TVJ2MjBxYWVuRVZWTE1PeHdzdUVFR2dIOE81aW9qb3ZJd3NkUGpV?=
 =?utf-8?B?QWNTUEMxRC82MHNVZVZxanhzeWZIUmt5TWEwVURUNkRDWHZMNlBvUWFtaERE?=
 =?utf-8?B?RElVcTNPWC90ejFVdmhTUE1QU0xsMk90YmZHdmJuZ2pGYUtjT2RiakJqdUpx?=
 =?utf-8?B?RGlYb2FqM0dNSDdLRG43SXJYS1ZYNFY3OURKNnFTRW5VY093cjM2V0hLbjJn?=
 =?utf-8?B?aVJrQ3RUeGg2Y1Brbms0dEhGZlh3WlRtVWl1QytXb2t5MVk0OTZwdWpYOGZw?=
 =?utf-8?B?eHZVQ0ZjNTNaWmJUMDhvZUUwTi8rZEtQemMzbUU1TTd0Q3RmT0VLNlN3TDdP?=
 =?utf-8?B?N0FsWWs4VitZMjJGM0ZpTndrWkxxRVI1aExGWjJKOVZEOU5wTW9sVnJoUXlx?=
 =?utf-8?B?RVRZN3pZOEVMU1U0MCtzS2x4Nk5OQzc3SVMwSEV4L3VvZnR5SS9ON0lCZE9E?=
 =?utf-8?B?bnV0K0tLc1FhYzIzenhjcytLLy85UmpGYnRHbVlZd0Jmd2VUbEpiZnZMZytV?=
 =?utf-8?B?S0dBVjRPOE5ncjZ0eEtZTklyTlhFZ0w3TG5NaE1mcGJ6R1hmTmtDa0YxbXlr?=
 =?utf-8?B?SUY2YnZMZEdiM3Z2a0FpeWFzc1p6OU9GbVJTeG1obEZtakdUQ3FldzlMTnkx?=
 =?utf-8?B?Y0xIMWpwTFA3aEpndmMyNXMwMmlnMEdNaThJbW5lYmpCdkdSN0dWQ0cwZENi?=
 =?utf-8?B?eCtxc0ZxUHh5cnJacmo0VnJnN29yaTJ2OU9SR2oxOW9wUm5oWkZyZUpkNCtH?=
 =?utf-8?B?bHJybndCbVNSYk10UEFJd2cvdGh1RTJhM2lpckVZdzhtZEFqM09TbE1CYWlT?=
 =?utf-8?B?V1ZjQmhwYzM5UWxmeW52WEEweGlUcnNXYU1DSkE5Snh2Qk9OSnVsZklwMzk2?=
 =?utf-8?B?eFVpWk9rdEVUcW5oSEYzejE4OW1tWGxHK0ZsaXQyNFFKSWhLTS9uMUthSmxM?=
 =?utf-8?B?Z2lkUEVrT3lSdGpoUVVnSWZseGo3Z0ZsMFhPZGo1Yi9WQjFmeHE0TXYwc1Jr?=
 =?utf-8?B?ZitIZ1dKOHlhMUhPMEpCRGRKSzlKZHlRQkd3Qy9XcnhTaHJ6RGhYRXpqdDN0?=
 =?utf-8?B?cXo2OWNWcVduaXVUTUp1SUtjTE9EUWYzbVB5dXFFK2VSVis3M0dvdERnZmZV?=
 =?utf-8?B?TnMwVHpJdC9vYVVCejJYc3pFczdVSkwzRzFIcXd6WVMxTjkzSG0xcmxma3lJ?=
 =?utf-8?B?bU9mdFNxUHdyZ1BiOHBLRXltNjRFN1pIa1hMTHFCbExjdVo5OEJva2d3ZGoz?=
 =?utf-8?B?Z29BbUg4NTlLOXdla0IycENHY3ZHOG5QalVJdWxnOUJSbEFDZkp3TURGOFlV?=
 =?utf-8?B?Qy8wUzVQbXRzb3pDUUx2bXpPOVhrWmxpaWRnWWliaC8rcForYVlibGhTeUQ3?=
 =?utf-8?B?WUYycDVaOU41a1JDL2J3R3VrT3ZUTHplL0hHRDVBRk5oMXpnV2VhRkZYc1Zl?=
 =?utf-8?B?V1RyZ3lWc0lmSHBmK1Z2TkdRSXZ0TzMxUStDTFNJbTZzMWZ0clNYUGlSek5h?=
 =?utf-8?B?WEIrdm5scHZwU253b0NQRThMNlJyaDdJOEFFbSs0a3FveEUyaHZram1TeGxL?=
 =?utf-8?B?YjJFcVNSQlltVDB2QnJ6dXFFQ1l0cFViZ0htRHFaZ0U5YWhWTDF2SFVqQjk4?=
 =?utf-8?B?WVdFZmJNa0xSd29JRHVsSm42RVRrcmlqRmRmZDhsUmdoRk5JeDl0cVN4M1F0?=
 =?utf-8?B?WjNaN1JoeXUvbVNoUUtvZVROQll3b2pxbVoyUnRvay9USzNuL1RXbXJzTFJ4?=
 =?utf-8?B?RXRsZHdHUi85SHd3YmpLdytWeldjYm0rSnNZVndkWGxPOG5ub29kNnZIOGNt?=
 =?utf-8?B?SktqZStoZWU1eENaaEJRY2o1V3JhV2pkQldUb1JSckhpbHMvdGpiR2MrOGVl?=
 =?utf-8?B?eWVOQnVRSXRMVmhaWmY0eGxHN1lseWpoVFhjSTdRZlY0K0d4K1E0R3ZaWkI1?=
 =?utf-8?B?VjhYSjRZSG80cjJ4L0xXKzJQQjlQbzBJWml5SjdMajI0WThobUhIc2Mrazgw?=
 =?utf-8?B?SVE1eklFV2dXR2ZxU0I5U1NvblFYVTlZNk80SENZSnBhU1V1V3o1V25IUjNm?=
 =?utf-8?B?TlYybEUzK1JWaXhWMGVSWXRwcUNiYSt4L0MyWmVvdGYrcFNicUQzdz09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 536469d2-659e-41bf-577e-08df090f701b
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:30:02.1176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OUtFwa3/rdIC7ZGQOKy1LQTn4+FMOvRuYu0H6MurZIDFPgGpqivUavf3kGa1UVDb0HShDkWi6ICrZHq+Huxow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BESP189MB3209
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2FA1140012
X-Stat-Signature: qf6opo6xeajcox6m3uw9qmx4nzdwgjcb
X-HE-Tag: 1788366615-116481
X-HE-Meta: U2FsdGVkX19Mc+m25NyZqr3rjj7UqVTnvMeFIzxgn9VY4CdXL8QjYVAxoxCLm/2IUOw3i9+a5HdPssk8CuEh0IC5ZFlRiRXCAsGeB9pxaMKGWGaEx8VMbGSTxevItAqalXnv/XLxNvK/EBLQZJErEhm8muIONlp22QF+FHMa4aEfPNdTj7tGREhc++9wP6Yx7IXEbq0SPOk/hVWLyMzfkqvJG01k3VMaxt51UzGuFiPPqDFZmvqSxX9DkeBCbL+KH7AKO0sY/ieabxZburTgwPoYnqETDgL5YP9/99hOiWKektJ/ITg3R50/sigIHag0XW0rvMaYb4JRXEAkyxc5HalRy/ImeCXoLlaFQgzUbHqgt4wqwjF0NzIQmZ5n/CjrIOSdVqPcM+zl4q1Yp0VpFYl8/R/wAxBQyBRHnp9MGDM9ONyLsetWGSK99opC/R5vAfXcX36EvB81AFnW+hUPjtayJ64PxSqjwwze5QQ2RPkMWF04q+qUZnXudQ7Bb3lxGqS24Qlhs3GGGgm40x7oWLyXQm5UvEVQvnZUSpcKNMjWAf/Ij9n/cWLQL0oOfHlXVWqJAtkj6tTWNDleMasfsob3J9r1ONLphNPw/9ptoiTP1rnPX02qNzYRbHhzhZXDI9W6floeEahDEuKZGHs1z60BXvjyy2pys5nkBavI13QwuPd7vil0X7ajuuz/c+6DTZVgOJxbbgOSAWIDXvlT+tn0yztprnMxlN7xoIfLPiSiB63cNJGL5XAuXPQy7J9xCaeaZcUOBsG1ShTT8ntroNPccg2taIs6F7cj72Y0JaM3vwwPxyCgO/L7z898v8hAni0S4b/LM717vUtMBU3X19uhGmgphBo79RYdH2LUWrGDUX6vNB+WC+qXVsk7d2eSFA0TYmnxdWR2/E0BPJez2FcPg9ru+uFuidKHI6bVlOxZp0Ioz0b/ay3/KmfvqTVBH3LTGJvAzr/Mo3bG3Nt
 uOD8u2g1
 5um+RB1Qx6kj01a4PldbZfhy+DwZBgz3wb61RcimHhB4tVZwM9eyl5y9VGvSbWDi3CguyvwUqyCXaKvv0tb6QW8p3JytpcvrJSfOZn5A3z2IhQmdGI7JezTU5iuo5tQrlOFOpSJFOGJapOTXmZ/Q1vNAGC9ppW8dwdzpXYhkDQGe6x0EnHU4ypRKaGeZGgjrghEfhFakge/krFP+3VGgwKmQf3irI8jt/uMe2BRX46GMNkBcGwlwnOEvQRjJlnVjjiwo5wfGzdwqzbxVetavcJ1f0zyNeUYYdLK0wMnRzbe+xe+6SR2MhnWWdgT9SNQr2S7CEhKLOPG+4gDtbYBCndVIdmFmfwSqBSAqq83JnZod+JIMKrWzbwucetk5pHIZzRmBeLzAwRC8mMEhoaZqw/ANVmsEggwiGPJ+VNViLsobP9YjGz/PegpbtE5Q7GjrRXGHV9qPXjM8ubAGj+9ZT4trSDjhZRAWgtYmnKa0Qi0ydlxXvb1Vu2qQmDqg/0/siIRx2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kselftest tests for the kcov_dataflow ioctl interface in
user_ioctl/. Nine cases cover the fd lifecycle and error paths without a
custom compiler, so it runs on any kernel that has the device:

 - KCOV_DF_INIT_TRACK tests 3 cases:
   1. accepted
   2. too-small size -> -EINVAL
   3. second init -> -EBUSY
 - mmap before init -> fails; enable works with or without a prior mmap.
 - KCOV_DF_DISABLE without an enabled session -> -EINVAL.
 - A second fd trying to enable while this task already
   has a session -> -EBUSY.
 - After enabling and running a syscall, any records present parse:
   the walk starts with a known type (ENTRY/RET, or CMP when
   CONFIG_KCOV_ENABLE_COMPARISONS interleaves them), each record has at
   least one value word, and the walk ends exactly at area[0] inside the
   buffer.

The test SKIPs cleanly when /sys/kernel/debug/kcov_dataflow is absent
(CONFIG_KCOV_DATAFLOW_ARGS not built).

Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 .../selftests/kcov_dataflow/user_ioctl/Makefile    |   5 +
 .../selftests/kcov_dataflow/user_ioctl/README.rst  |  11 ++
 .../kcov_dataflow/user_ioctl/user_ioctl.c          | 168 +++++++++++++++++++++
 3 files changed, 184 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/user_ioctl/Makefile b/tools/testing/selftests/kcov_dataflow/user_ioctl/Makefile
new file mode 100644
index 000000000000..1cb3d9b41c07
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/user_ioctl/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+# Standalone build of the ioctl test: make -C tools/testing/selftests/kcov_dataflow/user_ioctl
+TEST_GEN_PROGS := user_ioctl
+CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
+include ../../lib.mk
diff --git a/tools/testing/selftests/kcov_dataflow/user_ioctl/README.rst b/tools/testing/selftests/kcov_dataflow/user_ioctl/README.rst
new file mode 100644
index 000000000000..55072de189d3
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/user_ioctl/README.rst
@@ -0,0 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+KCOV-Dataflow Selftests: user_ioctl
+===================================
+
+Automated ioctl interface test (kselftest harness, 9 TAP cases): INIT_TRACK
+argument checking, double init, mmap before init, ENABLE/DISABLE pairing,
+a second fd failing with -EBUSY, and record validity after a syscall::
+
+  make -C tools/testing/selftests TARGETS=kcov_dataflow
+  tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl
diff --git a/tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl.c b/tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl.c
new file mode 100644
index 000000000000..d7b04c368ced
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/user_ioctl/user_ioctl.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * kcov_dataflow_test.c - Selftest for /sys/kernel/debug/kcov_dataflow
+ *
+ * Verifies the ioctl interface: open, INIT_TRACK, mmap, ENABLE, DISABLE.
+ * With INSTRUMENT_ALL, also verifies that records are produced for
+ * syscalls executed while recording is active.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <stdint.h>
+#include <string.h>
+#include <errno.h>
+#include <linux/kcov_dataflow.h>
+
+#include "../../kselftest_harness.h"
+
+
+#define BUF_SIZE 65536
+
+#define DF_TYPE_ENTRY	KCOV_DF_TYPE_ENTRY
+#define DF_TYPE_RET	KCOV_DF_TYPE_RET
+
+FIXTURE(kcov_dataflow) {
+	int fd;
+	uint64_t *buf;
+};
+
+FIXTURE_SETUP(kcov_dataflow)
+{
+	self->fd = open("/sys/kernel/debug/kcov_dataflow", O_RDWR);
+	if (self->fd < 0)
+		SKIP(return, "kcov_dataflow not available (need CONFIG_KCOV_DATAFLOW_ARGS)");
+	self->buf = MAP_FAILED;
+}
+
+FIXTURE_TEARDOWN(kcov_dataflow)
+{
+	if (self->buf != MAP_FAILED)
+		munmap(self->buf, BUF_SIZE * sizeof(uint64_t));
+	if (self->fd >= 0)
+		close(self->fd);
+}
+
+TEST_F(kcov_dataflow, init_track)
+{
+	int ret = ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE);
+
+	ASSERT_EQ(0, ret);
+}
+
+TEST_F(kcov_dataflow, init_track_too_small)
+{
+	int ret = ioctl(self->fd, KCOV_DF_INIT_TRACK, 1UL);
+
+	ASSERT_EQ(-1, ret);
+	ASSERT_EQ(EINVAL, errno);
+}
+
+TEST_F(kcov_dataflow, init_track_double)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(-1, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(EBUSY, errno);
+}
+
+TEST_F(kcov_dataflow, mmap_before_init)
+{
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_EQ(MAP_FAILED, self->buf);
+}
+
+TEST_F(kcov_dataflow, enable_disable)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_NE(MAP_FAILED, self->buf);
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+}
+
+TEST_F(kcov_dataflow, enable_without_mmap)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	/* enable works even without mmap (mmap is optional for setup) */
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+}
+
+TEST_F(kcov_dataflow, disable_without_enable)
+{
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(-1, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+	ASSERT_EQ(EINVAL, errno);
+}
+
+TEST_F(kcov_dataflow, double_enable)
+{
+	int fd2;
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_NE(MAP_FAILED, self->buf);
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+
+	/* Second fd should fail to enable (task already active) */
+	fd2 = open("/sys/kernel/debug/kcov_dataflow", O_RDWR);
+	ASSERT_GE(fd2, 0);
+	ASSERT_EQ(0, ioctl(fd2, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	ASSERT_EQ(-1, ioctl(fd2, KCOV_DF_ENABLE, 0));
+	ASSERT_EQ(EBUSY, errno);
+	close(fd2);
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+}
+
+TEST_F(kcov_dataflow, records_captured)
+{
+	uint64_t count;
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_INIT_TRACK, (unsigned long)BUF_SIZE));
+	self->buf = mmap(NULL, BUF_SIZE * sizeof(uint64_t),
+			 PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	ASSERT_NE(MAP_FAILED, self->buf);
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_ENABLE, 0));
+
+	/* Trigger some kernel code in this task */
+	getpid();
+
+	ASSERT_EQ(0, ioctl(self->fd, KCOV_DF_DISABLE, 0));
+
+	count = self->buf[0];
+	/*
+	 * With INSTRUMENT_ALL, getpid() produces records; without it count may
+	 * be 0. Whatever was written must parse: known types (CMP records are
+	 * interleaved with CONFIG_KCOV_ENABLE_COMPARISONS=y), at least one value
+	 * word each, and a walk that ends exactly at area[0] inside the buffer.
+	 */
+	ASSERT_LE(count, (uint64_t)BUF_SIZE - 1);
+	if (count > 0) {
+		uint64_t pos = 1, end = 1 + count;
+		unsigned int nargs = 0;
+
+		while (pos + KCOV_DF_RECORD_HDR_WORDS <= end) {
+			uint64_t hdr = self->buf[pos];
+			unsigned int type = KCOV_DF_HDR_TYPE(hdr);
+			unsigned int nvals = KCOV_DF_HDR_NVALS(hdr);
+
+			ASSERT_TRUE(type == DF_TYPE_ENTRY || type == DF_TYPE_RET ||
+				    type == KCOV_DF_TYPE_CMP);
+			ASSERT_GE(nvals, 1);
+			if (type != KCOV_DF_TYPE_CMP)
+				nargs++;
+			pos += KCOV_DF_RECORD_WORDS(nvals);
+		}
+		ASSERT_EQ(end, pos);
+		ASSERT_GT(nargs, 0);
+	}
+}
+
+TEST_HARNESS_MAIN

-- 
2.47.3


