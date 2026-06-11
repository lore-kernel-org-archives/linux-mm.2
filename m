Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA0CCD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30156B00A0; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07E16B00A1; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5A66B00A2; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2AFE6B00A0
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73128140719
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:05 +0000 (UTC)
X-FDA: 84868148610.04.ABD77BD
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011058.outbound.protection.outlook.com [52.101.65.58])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C37E1C000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=O1xUle1T;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781194922;
	b=ng3LYb+GzR8DpZVl0Gi25wpYybWX4fb8zaZOOMNdrKNWIk2bZWN0UN55pQKmRES34utNsT
	RgKFKkxaPaZ1GcOcea6LMK/nPsInEhu2n4GOagVzNkesOkoTNN6Pp6mcfEI+lTbSAPgWL6
	VNWud3nTE3drrrVcMqiQKafb3k1F45w=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=O1xUle1T;
	spf=pass (imf18.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.65.58 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoENOFMq92qTwczbiLwgprmQTz8BLW620KOHwffPRLk=;
	b=8RnFdMaF9Elw2X9r79xDevCnLG+Pn+iCRkfMc8m4gW+yEpxWf7qTG/Ow2JkhWJu/JDQjuq
	vFOMrispC6BJ0rXc5zd9djJQ0rEbef+/IMlT6EYzDsvoP0Johh/gxMeItosw+TM8ONjxm8
	0ErUgFBxMjY0qPhlci0w4GNdhAEUjlo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oE3lQLUhvmDg57HK+upRRAySE+qBeVJaN4UNbbU3BsqAYBjuS3NHA1ehDn/h+SFWchsy4FFTB902+RH5S5/gy/7o4rkcegd/7O4bA1p0ln5OeljaO1rDRKB+MYp8rpL/A69BGg1zrDeO3tJGTxrGEakpOiScJvXtWSEACV0L/9851G7t/Nl2LZ9u2KBn85ZcQ+X8Qre6Dd1GlxYWyPodjOlTdRzO4JbiSyAnm41x/Px+DtVb7S/SUsOap9n5QXVnRj4Eo4FlKxZ1PaEkx69zDMhw+tnHEfbkRkXp6L7UznbxW2o7Onf7mFLf3OFLv9LQzqpiw+TJup54pdCSKG1fLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HoENOFMq92qTwczbiLwgprmQTz8BLW620KOHwffPRLk=;
 b=FZhXI5leHAZb9s3c+URZt3wQppfM6ezvRK3hq2N0TD6jBBu11aAn5wVSrIzO2b9LVYWIOYAO9t5ekbeAv+YtskGEqWhuQ0JmZUxJP1BLv/GUnASgvg+sVT7ChoLns1kedkZzCb35rDTU/ZWL+08m4AymqguptoHB6Bw6wJX11Bhiuu7lyO/I4dO7HG1sXV0OCpGJrMtg9DNDjqXHP8/WniB4h8SDtUXPIuwDZ6dqZM46q2uzXDB37NhcwTRPITIf/T8ccUnhW2SiuQJVliJ7U8gFmV9peG1Qm+F0Q3a/Mi2OVjx/t43tgI/HrcwXwfqd4y/AeH6Qm2T//WlwqzgmRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoENOFMq92qTwczbiLwgprmQTz8BLW620KOHwffPRLk=;
 b=O1xUle1TTk7+l73YcZcTsatYptpYP5PJQzYZYscx74GH4mX0XvVKHAWf1SR4CoVHRjvtThp5EOte0F8c8OJoA2AAiXgRAtFaDQVDdF+hc7ol1QVdPlb4vCYg7LUK5aHCQxVvmDApj/FBLv3s2Fmq61hCBDOSOV9N9fgWCV+HRQ0gqcf+HP8japctY/nQjOF1zAcxenRtlazIvnIAmaz+MZ993VUr0GQ8s/McUyEZASXdcj/9VCfYo9PyIWpaV1pP+BZ7e9QrfycsNIINyQse515SM4qfsMVZuzJR8LqfEyqRBO9q9PM3bhB1Wx3h6znDSCqjxFObxgnxT3eg65soOA==
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2a5::24)
 by PAWP189MB2829.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:468::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 16:21:52 +0000
Received: from DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471]) by DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 ([fe80::2af4:a981:db81:d471%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 16:21:52 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Thu, 11 Jun 2026 18:21:10 +0200
Subject: [RFC PATCH v2 08/14] selftests/kcov_dataflow: add trigger-view.py
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-b4-kcov-dataflow-v2-v2-8-0a261da3987c@est.tech>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781194895; l=13901;
 i=yunseong.kim@est.tech; s=20260426; h=from:subject:message-id;
 bh=uKDYnpB8BwFaTgVadpzgWc+JDjhfCuwUY8/JIB0IobY=;
 b=MJ+pxNM0hyDV00H+eS5JXNTGMaBudcXB/KrtkQygYEPcv/YjIQS6azSDdSx7mR0HYcs4USdjb
 xZYjOhZ4WclAUpk2oh8earMYXFXS+QrgswaFBo8HTqyIMNg7P61r11b
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=1nBUX92cvTaavYG1+MR073D+XMKhdOciBZcnf6h6qEo=
X-ClientProxiedBy: GV2PEPF00023985.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::36b) To DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2a5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1754:EE_|PAWP189MB2829:EE_
X-MS-Office365-Filtering-Correlation-Id: 6448ddd8-50e0-419a-f028-08dec7d58bc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|921020|56012099006|11063799006|5023799004|3023799007|6133799003|9063799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lsGmbgDnFuyfk7xcUxN2TU+I7jAfM1g2ZEYhOcpBmptpQNLmlmswaMWJnacupOvWi50GpKrdl7DrtMX6QkvtJLmyNyvWD5rIwyzo3dqjrJCDaTqsCPi6OpDYdud4MKcQYXPegCQaC7XI+5/+pVCmeYQrH7PIp4ryFYr7E3MOrDwVzfl9rzKUK5UYDXp58k+u2jVajnqchumf3lqglRqAiS8107IzPSVBWplVOA8ZEc4GMfvMPpL3Sc/24E5u5RFhNMTzWFzSLJsC0H1BuCBkYt9iutxlYhQQIacOX1HP69N/AOgoLlt7wcYx/C7Xrp/1I2XZB+GDyke/qb3eFRNJiL0Z8kh1dBifEdIDZuk+9IBcrszQp1X2nQ6MZYqknrLK/SrzA82naM0qFMmJvVGl5K5GUAz6RPlH7a8ui58GJVVp5pLy97NhGeQc/+ZDJmR6vwupCtuJNwqXSiM5dP76cslwQhYjfB9YRSAtpYKWq+XoJKkkVA1+sz5OK7mBp/lguiY5Lt/1b7SUOk55mbiKjpFWvv2yB9Y5eFK64+h3B0gXF6VVzPDyShI/kzx0r1s2X44ZDfBLRkl1nwvd2ui2/feSfhxrfVybzhFBQI+LCnzG37h2Yz0UhArv1EW/95zIOVGx9I/TIay6aUJfwTxvqIUX/ZKd+pU7eqKD9yaVEk3FMya/eIhmpfMmpknuJD/FtHngKCW/iyYEP5GQ3Hr1BifWNXoVjJAHmnHt4sfh6ImffgR1BfNd9gRR6XHzXpZj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1754.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(5023799004)(3023799007)(6133799003)(9063799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlNTeWhKNUFBMXV6eU9NSGdQRnVvNUtWTDNlQ1dUY1hXVXhYTXd5cHkxWWQ0?=
 =?utf-8?B?TVB4NEdzSUl6THpSUGFIU2I1ZVdIYllCUlRwY1RZbFRYV25jcHNWQjkwYnFm?=
 =?utf-8?B?VEdoNGprSUt6TjJXeGRKRTVjK1NaN0VETGEwejE4c2Y2S1Y0RCtSdHZxclpH?=
 =?utf-8?B?YzhYTmJvZ0xzeDVMMFJhMTNmbDl3UkZxK3BoRmlWNTVTUTJKZWNwK09pV2Nq?=
 =?utf-8?B?WFc2T3paN2pyb2tKeS9yZ0tFZ2pyZGVpc29GQy9XQXlxOEgyQnhOV3Z4NUVQ?=
 =?utf-8?B?dWZlZmk1NTYrOERjVWU1VGdyM3I0TXdzNEZRRjVLbmZ2b1Z2Q1VQd21QWng0?=
 =?utf-8?B?MkZVRzVxOG1FL0F3ODJyNkFCYU9OUWRNRzhxS0JyZmdMR0tYaDhKclpLM3R1?=
 =?utf-8?B?OFBZSjB1aU40R0U0eE9wRUZFNXRrd0Rlcjc4RFZPZERYenZOdG5FTnhXTUcv?=
 =?utf-8?B?eTIvTGRnWERVV1VpUDFBSDVlc1NEczZpaS9KS2daZEFybDRsSFJsRnEzcGpi?=
 =?utf-8?B?NHlFYUMxalgxaWlDWkRhNXJTbFBJa1Q4WWk2UzgvK3YvSWNTcGlTR0J4N1lv?=
 =?utf-8?B?a1NTWlZ2VXpXTTZYSlhwNHkrZ2lNdkh6VEV2ZEczcEJhNXkwUDBmQWlkUzE3?=
 =?utf-8?B?bFRyU3phRmFuNWVrMmc4Vm8wTmJBSnAvU1o2SjBmcW5NNTdsL3NSSTU5Sk9K?=
 =?utf-8?B?NHZhSEZBWGdrSEQrQVNHc2RqZVpSRjdFUThVZXdHVmNXNkVYREhCOFc4U0dt?=
 =?utf-8?B?SFZlNUxoSkdReDlIZmh6RmZyNmxZZk9SNmZUWWJueTZtMFd6bWtJcUQwSmZt?=
 =?utf-8?B?TlFMd2tGR0xLNFZIaC93RnkwOVcrWGpuTko0dWJtZHY4QnR0dE1lWmlWaURr?=
 =?utf-8?B?bzYzYTl4dTNHNWxkRE5nUW43b1NTbW55VC9XbTJuYi9pelNUK1pNdzBxd2N6?=
 =?utf-8?B?VWhKSlZIYTJQam9lOTFiYWZuOGNIV3lqeEM0Q2FBNWpCNy9pODhlTmF5VGdY?=
 =?utf-8?B?OFJSU3g1dm5rQnY4YkZhWENuZmpqZGN2aHovSGdpWlc3c2pUTXAxbi9LRUJw?=
 =?utf-8?B?UjR0T3BWenRpWkxaZ2g3eWE2OVVqUk1FejQ3YlY0QWp0cElkQndyc0VyU2t3?=
 =?utf-8?B?NG16RXNtREkzNjlkUEpSUklLWUxBQWRuQ2VhTks3ZkZSKy82ekw3dGQxeHB6?=
 =?utf-8?B?S1VrWXpBZnZkcDFXc3BOUFVNeGlQMSs0S0NhOGl3dllmQWNET05objV0RTN5?=
 =?utf-8?B?NEo0MU0wYUdsM041WE5lc1FFQ2pBbFpFRFMxK0kzcW0zeG9XTUpwYTdGRXc5?=
 =?utf-8?B?WUZabWV1Sk1yS1YxeWJBQkxwOGlTVHdJSm94anNuQjlCMDR4aElKMWJPbThi?=
 =?utf-8?B?c1ZGckFjYWtBOElVdGJPWXAzbmNGbVhYQW5INmNhWEp3cE1QWTdmaWMrRWZQ?=
 =?utf-8?B?NlRwaW0xM1VpdHdPY2I3R3NGa2Z4RVJacjk0Q2dUcVlnM2c0Mnh2TnlsYWRR?=
 =?utf-8?B?emlHVDVMWDZtdUZWbWF6SVR3SEJGZHZNQ0xNNUJGSzk3NzdHd0hyOE1QbUwy?=
 =?utf-8?B?eVV1SHRQUGtrTk5hQnU0eHJCNHJlZzdwbksrd2ZSdXBhRmR5SE9jMUdxbXBy?=
 =?utf-8?B?OWI1dHpnVkw5Q09zQXI1dHMxYzVOUk5HNUJSQVg3MENkL0VBQnJRbnUzWFhw?=
 =?utf-8?B?Q003T1d4SXF2UnVVamx1cXp2WnFoczROTjJYdmtlZU93VW1wNlRHUmw2NFc2?=
 =?utf-8?B?cldNUW9nemg1WGJ4bVJDOVRBRFJadENocEh2OGJsNVgrV2tweXZudXozMnli?=
 =?utf-8?B?ZWNpYWw2QndWYWRabEdEYUJFYnk1cTVlNnlhWk1lcUhzVGRaR05xeW56R1BN?=
 =?utf-8?B?aC9GZUhmN2QzcTJMbC84ZkQvNm42S20rZXRXNHBBMUxYWVZTeVdDcXA2clZD?=
 =?utf-8?B?MjMxTHBzaVdNZUVZT3JXOGlIc1hKNW9lM3FBNGs5QVZpMmJGbHVNVFlwd09z?=
 =?utf-8?B?REJmUzc2SGkzdCtoMjgzTlgzbmZ6c05zWXl1bGtUU1YvOFZYcUxHR1hzcE4x?=
 =?utf-8?B?TzYyN21KSG85aHFhaVZFaEpLVDRqcXRvTWp0OGZ2U29XMCsrMGVQZllJZFIw?=
 =?utf-8?B?cDdVTm42MFczRk9oYVU1b2xRZTd4am9ha2dzRG9CSlF1RlMrTkY1RFp3VUVB?=
 =?utf-8?B?Y2NjYitYczd6SmZpOHRFYTFsL1JiNi8zWHJqRUlHTVFPTVJxNU9DaFRWN0sw?=
 =?utf-8?B?RHAvYmMrbWI0L1lEbUJRSlM4V203RDhlU3Q5bVJPVnBqMk5Hb3RoclovYm1w?=
 =?utf-8?B?TnpDZmlJZlVKQ05wc3VTNWZJSUVSK2VOSmlVb21aSU1mY3ZJUEN1QT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 6448ddd8-50e0-419a-f028-08dec7d58bc7
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1754.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 16:21:52.1334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/OWa3q+SFFqrYLZMKBhQ0hQMEqffvHXHhChT9Zgf8uQcUbK/S9jpFt1oFewZ0qIKnhdnt6J6tRmqBSeN+g8VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2829
X-Rspamd-Queue-Id: 6C37E1C000A
X-Stat-Signature: aorf9131thargtah1a7dhgxywws4j9q7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781194922-566349
X-HE-Meta: U2FsdGVkX18oBUYb9xVniA5jaN/eQwdS3zEJZY/RHeNeoTmgttAYPxEV3NUI0ajjn9CdlSViTkOYC2tLi1U78nBE9gMsDQa1Dffvg7pMV9nLXHvDHWfhu+8Zu8acmp0hYv1xK0mTcI3imz3r+fz0STECgf61UYf8knAFFqaeS1nUuiGKOeOD6W5G+awDxU4IE6eWKWAFsXvX/xL72GE676HfEl0lTcRpa+jko5zOi0QUEyB7863IIwpM9cDXpa5noel4NqJYQAvaRYHjfT80s42v7mR8J3n8D6cRfx2eJcpCECKx2gDYZ5G5L/XJnla/MiTvh+hnlwzzsuRi3mrJHuHa1CayOaxB6BsMMaRXxFT1m2jc/otuqSxr/8SxSN0ZypX2SXFP53PEykjX1AAfrgtRn8vPoHkLdnm3CuUsCLRVa5fMXLrNtAXe/ovIecr1d/apX9U29pJtpdMsa41z3BxRlR2ctaPIrXf/gSMUicsY9FQOoNg20Aj3yhpF4Pf5mk8ftSEDP0bEW19V23f9MocoUUouprvb5iwGwzSljRRQKuqMrCR49fyNq2MxqOx2HhcTt9gCTL6wHzIKTBoYywwnnFjp8cSDD2OS/jlU2wHIiq4SFTa1ekM5hUD7ATR1BqVsJbSoDo4l9UkhUXybZayBXj6ZymZuAwXF6c9+Al7ZSSaWAYQTrF6T4WMsIBdKfytD0+f3fz01tOKAD9wIGtVRLXQer+nlCQl5XZUG0zoexmlHtqptkZV57h6+TOifVdNrlX9zotwzE7ZPjdxziMHgFTF9OYq3a6D5RMczDWGsDnmxoZfLVZngn+3PZbV97RuOiyUm+dhrWjQzDHFgwDt39ieYqOod9Yn4MzWWqsenyO95QMDs4sEmfQZYcXgrijrzskfLdsIo3HCkJqGSnOVU/nMTQo2ZxLndlb1U7eYO2ivNQxwfOGStK1/k9M0WAGpjqbZqD8nvevnFum6
 la8/0WeY
 C53qM+0iDPkRzst+gW0YHkHA1lFUHMVCRBmild6u4E5YgkWpYFCeYH9LPNgKOxBpsVjZAbWtk7i7PWrgC5lBTL6LA8li8IAso7iolu/CNvd8WUucKTL3Kji05NiyckYrg09VhwgJx3AWSxjldEmhqeCrieQt+rsztCBDASkErOhtrSPaBKiSgfDSo4RomS9UcWFV5kD/oY+ypiVoPNxa166JP3FG1S1qJE1zvZeh2IFt5tJFqN+0GoGkFKgsCiCDvV71x8U2rXxEvJItp/6IvD497jBd+SzKdTrJhd8J6FyfqPZPvcakGhWmY1sjLQGKITwJZcppmlkocEU/WK4fjmtf8PKBLJ45CLhpU70S2wMMpRjiCDK8jI1/w1B3vSp7ETH85tT4Z26clUJcDoJ3A5awe0t/2ZxO7KUpcynoq+qiMtGTjmHo/Zy+A8gggJ3+KAzmes/wErBMvi8AphTYlYO6+y3zkteVA+LBU1jKwvE9IqyJsteTalW+gtX1n+TlUcR7bdMPdOCp/sLFwU5rfanjIsTc9pIl9Ako6ZUyFqMwuO6zVxRc/f+FR7Yy5Y05lBNE0M1pjS/k/lAwPVibs1oOg3OE8jElv3HnRk+oKjLwkSu73ZWQfM6HwjkiJ3dbOMcVsSDNjrBqa0A37Dp/tCXgfQrdFAct2Va9RW6KW7X7HEts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a Python script that loads a test module, triggers its debugfs
entry with kcov_dataflow recording active, then pretty-prints captured
records as a nested call tree with kallsyms symbol resolution.

Features:
- 8MB ring buffer (1M u64 words) for INSTRUMENT_ALL kernels
- Enable recording after module load, before trigger (avoids VFS noise)
- Variable-length record parsing using header-encoded field count
- Module-only filtering via kallsyms symbol lookup
- --context/-C N: show N records before/after each module function call
- --raw: print raw records instead of call tree
- Architecture-aware syscall numbers (x86_64 and arm64)

Usage:

  python3 trigger-view.py eight_args_c \
    --ko eight_args_c/eight_args_c.ko

  python3 trigger-view.py eight_args_rust \
    --ko eight_args_rust/eight_args_rust.ko

  python3 trigger-view.py rust_ffi_contract \
    --ko rust_ffi_contract/rust_ffi_contract.ko

Cc: Alexander Potapenko <glider@google.com>
Assisted-by: Claude:claude-opus-4-6 [kiro-chat]
Link: https://github.com/yskzalloc/kcov-dataflow/actions
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 .../selftests/kcov_dataflow/trigger-view.py        | 377 +++++++++++++++++++++
 1 file changed, 377 insertions(+)

diff --git a/tools/testing/selftests/kcov_dataflow/trigger-view.py b/tools/testing/selftests/kcov_dataflow/trigger-view.py
new file mode 100755
index 000000000000..a3274e472dc1
--- /dev/null
+++ b/tools/testing/selftests/kcov_dataflow/trigger-view.py
@@ -0,0 +1,377 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+"""
+trigger-view.py - Load a module with kcov_dataflow
+recording active, then pretty-print captured records.
+
+Usage:
+    python3 trigger-view.py eight_args_c
+    python3 trigger-view.py rust_ffi_contract
+    python3 trigger-view.py eight_args_c --raw
+
+The script:
+  1. Opens /sys/kernel/debug/kcov_dataflow
+  2. Inits and mmaps the buffer
+  3. Enables recording for this process
+  4. Loads the module via finit_module() -- init runs in our context
+  5. Disables recording
+  6. Unloads the module
+  7. Parses and prints captured records with kallsyms resolution
+"""
+import os
+import sys
+import struct
+import ctypes
+import ctypes.util
+import argparse
+import fcntl
+
+# Constants
+DF_TYPE_ENTRY = 0xE
+DF_TYPE_RET = 0xF
+MAGIC_BAD = 0xBADADD85
+BUF_SIZE = 1048576  # 1M words = 8MB
+
+# Ioctl numbers
+def _IOR(t, nr, size):
+    return (2 << 30) | (ord(t) << 8) | nr | (size << 16)
+
+def _IO(t, nr):
+    return (ord(t) << 8) | nr
+
+KCOV_DF_INIT_TRACK = _IOR('d', 1, 8)
+KCOV_DF_ENABLE = _IO('d', 100)
+KCOV_DF_DISABLE = _IO('d', 101)
+
+# syscall numbers (x86_64)
+import platform
+_machine = platform.machine()
+if _machine == "aarch64":
+    SYS_FINIT_MODULE = 273
+    SYS_DELETE_MODULE = 106
+else:  # x86_64
+    SYS_FINIT_MODULE = 313
+    SYS_DELETE_MODULE = 176
+
+SELFTEST_DIR = os.path.dirname(os.path.abspath(__file__))
+
+
+def load_kallsyms():
+    """Load kernel symbols for PC resolution."""
+    syms = []
+    try:
+        with open("/proc/kallsyms") as f:
+            for line in f:
+                parts = line.split()
+                if len(parts) >= 3:
+                    addr = int(parts[0], 16)
+                    name = parts[2]
+                    mod = parts[3].strip("[]") if len(parts) > 3 else ""
+                    syms.append((addr, name, mod))
+    except (PermissionError, FileNotFoundError):
+        pass
+    syms.sort()
+    return syms
+
+
+def symbolize(pc, syms):
+    """Find nearest symbol <= pc."""
+    if not syms:
+        return f"0x{pc:x}"
+    lo, hi = 0, len(syms) - 1
+    while lo < hi:
+        mid = (lo + hi + 1) // 2
+        if syms[mid][0] <= pc:
+            lo = mid
+        else:
+            hi = mid - 1
+    addr, name, mod = syms[lo]
+    if addr > pc:
+        return f"0x{pc:x}"
+    offset = pc - addr
+    if mod:
+        return f"{name}+0x{offset:x} [{mod}]" if offset else f"{name} [{mod}]"
+    return f"{name}+0x{offset:x}" if offset else name
+
+
+def format_val(v):
+    """Format a captured value."""
+    if v == MAGIC_BAD:
+        return "FAULT"
+    if v == 0:
+        return "0x0"
+    return f"0x{v:x}"
+
+
+def find_module(name):
+    """Find the .ko file for the given test name."""
+    ko_path = os.path.join(SELFTEST_DIR, name, f"{name}_mod.ko")
+    if os.path.exists(ko_path):
+        return ko_path
+    # Try without _mod suffix
+    ko_path = os.path.join(SELFTEST_DIR, name, f"{name}.ko")
+    if os.path.exists(ko_path):
+        return ko_path
+    # Search for any .ko in the directory
+    mod_dir = os.path.join(SELFTEST_DIR, name)
+    if os.path.isdir(mod_dir):
+        for f in os.listdir(mod_dir):
+            if f.endswith(".ko"):
+                return os.path.join(mod_dir, f)
+    return None
+
+
+def finit_module(ko_path):
+    """Load a kernel module via finit_module syscall."""
+    libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
+    fd = os.open(ko_path, os.O_RDONLY)
+    ret = libc.syscall(SYS_FINIT_MODULE, fd, b"", 0)
+    os.close(fd)
+    if ret != 0:
+        errno = ctypes.get_errno()
+        raise OSError(errno, f"finit_module({ko_path}): {os.strerror(errno)}")
+
+
+def delete_module(name):
+    """Unload a kernel module."""
+    libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
+    ret = libc.syscall(SYS_DELETE_MODULE, name.encode(), 0)
+    if ret != 0:
+        errno = ctypes.get_errno()
+        raise OSError(errno, f"delete_module({name}): {os.strerror(errno)}")
+
+
+def parse_records(buf, total_words):
+    """Parse the ring buffer into a list of records."""
+    records = []
+    pos = 1
+    while pos + 3 <= total_words and pos < BUF_SIZE:
+        hdr = buf[pos]
+
+        # Valid headers fit in 32 bits (upper 32 must be zero)
+        if hdr >> 32:
+            pos += 1
+            continue
+
+        rtype = (hdr >> 28) & 0xF
+
+        if rtype not in (DF_TYPE_ENTRY, DF_TYPE_RET):
+            pos += 1
+            continue
+
+        pc = buf[pos + 1]
+        meta = buf[pos + 2]
+        seq = hdr & 0x00FFFFFF
+        num_vals = (hdr >> 24) & 0xF
+        if num_vals == 0:
+            num_vals = 1
+
+        # Valid records always have a non-zero PC (kernel text address)
+        if pc == 0:
+            pos += 1
+            continue
+
+        val = buf[pos + 3] if pos + 3 < BUF_SIZE else 0
+        records.append({
+            "type": rtype,
+            "seq": seq,
+            "pc": pc,
+            "meta": meta,
+            "val": val,
+        })
+        pos += 3 + num_vals
+    return records
+
+
+def print_raw(records, syms):
+    """Print records in raw format."""
+    for r in records:
+        sym = symbolize(r["pc"], syms)
+        t = "ENTRY" if r["type"] == DF_TYPE_ENTRY else "RET  "
+        arg_idx = (r["meta"] >> 56) & 0xFF
+        size = (r["meta"] >> 48) & 0xFF
+        print(f"[{t}] seq={r['seq']:3d} {sym} "
+              f"arg[{arg_idx}]({size}) = {format_val(r['val'])}")
+
+
+def print_tree(records, syms):
+    """Print records as indented call tree matching converted.txt format."""
+    depth = 0
+    # Group consecutive ENTRY records by PC to collect all args
+    i = 0
+    while i < len(records):
+        r = records[i]
+        sym = symbolize(r["pc"], syms)
+
+        if r["type"] == DF_TYPE_ENTRY:
+            # Collect all args for this call (same PC, consecutive entries)
+            args = []
+            pc = r["pc"]
+            while i < len(records) and records[i]["type"] == DF_TYPE_ENTRY \
+                    and records[i]["pc"] == pc:
+                args.append(format_val(records[i]["val"]))
+                i += 1
+            indent = "  " * depth
+            print(f"{indent}{sym}({', '.join(args)})")
+            depth += 1
+        else:
+            depth = max(0, depth - 1)
+            indent = "  " * depth
+            print(f"{indent}{format_val(r['val'])} = {sym}()")
+            i += 1
+
+
+def main():
+    parser = argparse.ArgumentParser(
+        description="Load a test module with kcov_dataflow and view records")
+    parser.add_argument("module", help="Test module name (e.g. eight_args_c)")
+    parser.add_argument("--raw", action="store_true",
+                        help="Print raw records instead of tree")
+    parser.add_argument("--ko", help="Explicit path to .ko file")
+    parser.add_argument("--context", "-C", type=int, default=0,
+                        help="Show N lines before/after each module record")
+    args = parser.parse_args()
+
+    # Find module
+    if args.ko:
+        ko_path = args.ko
+    else:
+        ko_path = find_module(args.module)
+    if not ko_path or not os.path.exists(ko_path):
+        print(f"Cannot find module for '{args.module}'", file=sys.stderr)
+        print(f"Build it first: make LLVM=1 CC=clang "
+              f"M=tools/testing/selftests/kcov_dataflow/{args.module} modules",
+              file=sys.stderr)
+        sys.exit(1)
+
+    # Open kcov_dataflow
+    # Ensure kallsyms shows real addresses
+    try:
+        with open("/proc/sys/kernel/kptr_restrict", "w") as f:
+            f.write("0")
+    except (PermissionError, FileNotFoundError):
+        pass
+
+    try:
+        df_fd = os.open("/sys/kernel/debug/kcov_dataflow", os.O_RDWR)
+    except OSError as e:
+        print(f"Cannot open kcov_dataflow: {e}", file=sys.stderr)
+        sys.exit(1)
+
+    # Init + mmap
+    fcntl.ioctl(df_fd, KCOV_DF_INIT_TRACK, BUF_SIZE)
+    libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
+    libc.mmap.restype = ctypes.c_void_p
+    libc.mmap.argtypes = [
+        ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int,
+        ctypes.c_int, ctypes.c_int, ctypes.c_long
+    ]
+    buf_ptr = libc.mmap(None, BUF_SIZE * 8, 0x3, 0x01, df_fd, 0)
+    if buf_ptr == ctypes.c_void_p(-1).value:
+        print("mmap failed", file=sys.stderr)
+        sys.exit(1)
+    buf = (ctypes.c_uint64 * BUF_SIZE).from_address(buf_ptr)
+
+    # Load module first (generates noise with INSTRUMENT_ALL)
+    mod_name = os.path.basename(ko_path).replace(".ko", "")
+    try:
+        finit_module(ko_path)
+        print(f"# Loaded {mod_name}")
+    except OSError as e:
+        print(f"Failed to load module: {e}", file=sys.stderr)
+        sys.exit(1)
+
+    # Get module .text address for PC filtering
+    mod_text_start = 0
+    try:
+        with open(f"/sys/module/{mod_name}/sections/.text") as f:
+            mod_text_start = int(f.read().strip(), 16)
+    except (FileNotFoundError, ValueError, PermissionError):
+        pass
+
+    # Enable recording AFTER load, BEFORE trigger (avoids VFS/loader noise)
+    fcntl.ioctl(df_fd, KCOV_DF_ENABLE, 0)
+    buf[0] = 0
+
+    # Trigger the module's debugfs file to invoke test functions
+    trigger_paths = [
+        f"/sys/kernel/debug/kcov_dataflow_test/trigger",
+        f"/sys/kernel/debug/kcov_dataflow_test/rust_ffi_trigger",
+        f"/sys/kernel/debug/trigger_rust",
+        f"/sys/kernel/debug/{mod_name}/trigger",
+    ]
+    for tp in trigger_paths:
+        try:
+            with open(tp, "w") as f:
+                f.write("1")
+            break
+        except (FileNotFoundError, PermissionError):
+            continue
+
+    fcntl.ioctl(df_fd, KCOV_DF_DISABLE, 0)
+
+    # Read kallsyms while module is still loaded (symbols available)
+    syms = load_kallsyms()
+
+    # Unload
+    try:
+        delete_module(mod_name)
+    except OSError:
+        pass
+
+    # Parse and display
+    total = int(buf[0])
+    print(f"# Captured {total} words")
+    records = parse_records(buf, total)
+    print(f"# {len(records)} records")
+
+    # Filter to module records using kallsyms
+    # Build set of module symbol addresses for fast lookup
+    mod_syms = set()
+    for addr, name, mod in syms:
+        if mod == mod_name and addr != 0:
+            mod_syms.add(addr)
+
+    def is_module_pc(pc):
+        """Check if PC belongs to mod_name via kallsyms."""
+        if mod_syms:
+            # Binary search: find nearest symbol <= pc, check module
+            lo, hi = 0, len(syms) - 1
+            while lo < hi:
+                mid = (lo + hi + 1) // 2
+                if syms[mid][0] <= pc:
+                    lo = mid
+                else:
+                    hi = mid - 1
+            return syms[lo][2] == mod_name
+        # Fallback: if no module symbols (kptr_restrict), use .text start
+        return mod_text_start and pc >= mod_text_start
+
+    if syms or mod_text_start:
+        if args.context > 0:
+            module_indices = set()
+            for i, r in enumerate(records):
+                if is_module_pc(r["pc"]):
+                    for j in range(max(0, i - args.context),
+                                   min(len(records), i + args.context + 1)):
+                        module_indices.add(j)
+            records = [records[i] for i in sorted(module_indices)]
+            print(f"# showing {len(records)} records with context={args.context} "
+                  f"around {mod_name}\n")
+        else:
+            module_records = [r for r in records if is_module_pc(r["pc"])]
+            print(f"# {len(module_records)} from {mod_name}\n")
+            records = module_records
+    else:
+        print("")
+
+    if args.raw:
+        print_raw(records, syms)
+    else:
+        print_tree(records, syms)
+
+    os.close(df_fd)
+
+
+if __name__ == "__main__":
+    main()

-- 
2.43.0


