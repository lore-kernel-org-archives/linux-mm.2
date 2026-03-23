Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10253F4610D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36286B0005; Mon, 23 Mar 2026 09:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6D46B0088; Mon, 23 Mar 2026 09:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5AE6B0089; Mon, 23 Mar 2026 09:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA6906B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:13:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 483F61A0B6E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:13:22 +0000 (UTC)
X-FDA: 84577369044.10.757DA39
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020137.outbound.protection.outlook.com [52.101.195.137])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5DCE24000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:13:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=z7ow+m+x;
	spf=pass (imf11.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.137 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774271599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlCbzBoIfrdJR1CbU5uEeHQyXoDtlYgPeLEAaEyHdeg=;
	b=5IAvPvb32wNS+pHbrZawcFDqAgIJ65RWni+wPAanuwoNa2vGWy7PhRS8qE8SA1feFuU2pg
	MeYRTMHFYe+j++JzhbXim66VI+pPy7sbCF51BpBCsmYmIAe107LK3zNLHkZApbZSDxb6dA
	nh4g18bRcHZ9ITGb/EncCJ+xSdM/cG4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=z7ow+m+x;
	spf=pass (imf11.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.137 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774271599; a=rsa-sha256;
	cv=pass;
	b=ktDqqsdvtfIU0E5R3OmphNxrlFNjyOZW8FGXEZX98GvgM1AWdGguN+/roq+436Py29LQTS
	mwQbDluKFag2FM2+jIstPHGMQaTZuGt/fjdK27pj8gIoLyjuNpQ1bsfAXZtJWydRvWdH3C
	3PTGORMspeAmcL4zAmglKhnWIi77kIs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gUzZ3ZF7r4vVn2OYaOaX651xZVkCswwo3ZEQmSFIexnHH23tPrO+S/RyV5sq7tRvI0bvyxL/NLTiZm1flWe6NdPBaVAEYLRjxXBbCXC/xing5WafPqtzK8L6Y71Szw9iBIaOewkI1pIGjvg1ariLWZL9j/6woGN50O3gP3cdznpNCmS9bhOlZyjBGdg5xmoWLVsYKuPxgR0t1JTS3UcVLEpEJvCnLWXkb4WW3OzaN00Khu/VW5K3FFrTm+1FmaH/sQZL4HDCvnAuSSj1xeEgJIO82Ql1us8kVKmZW0aS3PQcHqguzGkxLLvAbBGAzRRmcc80J9g8u+il8BgZ/pKSlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlCbzBoIfrdJR1CbU5uEeHQyXoDtlYgPeLEAaEyHdeg=;
 b=X8bc/SU1bDK0GKAc0McSDgF5pBkxh6v3wcWD2Wo75UwiulsjX28wQI3LblyBKxlJ3swF+qCh8696ZJyGBzEOkz+qBP6JazDKbPqo/rHXPrGsllS23P77rcPZTMkdoTmr79zzSssQvBAen0FxP1wDOayhujIeS7+5Bt1PRKRQ1zpsspTzIrlVL13uK+2wcI0YLySO41pSY28WFwh8CQLKY2vkHzzb7B9hUcxn8yjnOXFK/dHuwQCRlwJq1ncOvVYT6sENCeu6QyM9BUajs087DpJmQrpSv4tjpU9afKqakEll/3Amd12uFfJ5n2hEee/E2b7s22tHpdTriwU0K1DqaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlCbzBoIfrdJR1CbU5uEeHQyXoDtlYgPeLEAaEyHdeg=;
 b=z7ow+m+xdGlA0PqABBEan86U4D5xfIhTsJOGDwqXhIFs8+BqoZ0chSRcB8hJ5sdlwY0w0It/S02n14OWoK08Y0XXU8u3vaat4kkK1+wqrHQPrXazVpowO8otFlbvyE5U3aEdiWC6NU7GnSt4BdHah6cGOJWEhBaSD3D5ENJRTiI=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO3P265MB2412.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 13:13:15 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 13:13:15 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Mar 2026 13:13:14 +0000
Message-Id: <DHA6SE9EMEQF.1PKVHEG18I5FS@garyguo.net>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, <a.hindborg@kernel.org>,
 <acourbot@nvidia.com>, <akpm@linux-foundation.org>, <aliceryhl@google.com>,
 <anton.ivanov@cambridgegreys.com>, <bjorn3_gh@protonmail.com>,
 <boqun.feng@gmail.com>, <dakr@kernel.org>, <david@davidgow.net>,
 <gary@garyguo.net>, <johannes@sipsolutions.net>, <justinstitt@google.com>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kbuild@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-um@lists.infradead.org>, <linux@armlinux.org.uk>,
 <llvm@lists.linux.dev>, <lossin@kernel.org>, <mark.rutland@arm.com>,
 <mmaurer@google.com>, <morbo@google.com>, <nathan@kernel.org>,
 <nick.desaulniers+lkml@gmail.com>, <nicolas.schier@linux.dev>,
 <nsc@kernel.org>, <peterz@infradead.org>, <richard@nod.at>,
 <rust-for-linux@vger.kernel.org>, <tmgross@umich.edu>, <urezki@gmail.com>,
 <will@kernel.org>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
From: "Gary Guo" <gary@garyguo.net>
To: "Andrew Lunn" <andrew@lunn.ch>, "Miguel Ojeda"
 <miguel.ojeda.sandonis@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch>
 <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
 <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch>
In-Reply-To: <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch>
X-ClientProxiedBy: LO4P302CA0005.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::13) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO3P265MB2412:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a8913c6-9d7b-42db-a4d4-08de88ddf1a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dQss4JqdVYJ6Sg1snzZZSMh/0y8t/831k7Uefopl6UeFlW3pocKm0H4mw5eG4AXg8EEvV3T5qQRIYzrgl1OjGE/aXCCLIZ1d1yLMtzBw0/SsK0QtO7Wzp/2Q+AISrz7Uawww2C8QG9H3xlYU8jdPALEwYxOB4XIATEssSSGSLc2vIYbbEI3tCYHABUbWdSABnnF3djmMYWng85d3QAiKdqiyd3LgA0iRQo6cpdo0t9qnR68MMkccl2pnq0x0CpkMlVnI8L4aCCZTXD0gF0nbNJn4QIDmpUSUTx6oT6HWMaLS/x8wvGgZTNc8lw2tFKi+en0fokgke9SRMZFFKbIeiEuG5ZTlSlGu06MU4hnCgOjIfEJKjth1QqAbAq9nOd/AaHJhg06f5W7u6w5OGKxEpe4uD/5/bFMmDe7RLhBzY5xuWGqA9ZYQAGXQEu4TvGqTv1V9/KFR7jCpyBadTxVkzbbhxQJtBINOGOdhsy2/WHIH6W9pULUjFmDTujgznv1mbN3JXQCLC6gkX0U+7byFcj4XmFDz4j7zCeoI7iftUzSlzNOyyJzbL17y8Strh3o1yZxEkRo/Vm15gTBp/tYHToZYbKfsDD7NS/0L5pCa3tOOduTTCauuRDEJp/AZwTKoUq7W9OHdWAhmtIe4UfGLNxynRAEPxjBE/S8PsGSVsulE+YZK1lVrQcHIIGF+soDbU+Xapx8YKgQEXaBYjdS2goVm1x3+QbtUeqrN1ep1TZY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHcrYlN6QmFuRUp3QXJoWFVXeHJPMEY1MkFjZTJZTHk5VDArRGV2WW5iY3dR?=
 =?utf-8?B?RGpKQzdGRmxKNUQ4V2pqNXlsVU5ySVdPdlB6Qk9RbTJBZ3ozL3JlM0k1UW5Q?=
 =?utf-8?B?SHNlUUp1dzUwODJKRUExQTVURUhTbGxEaHJOcFdob3duY0Y2Zy9yTDh5a2tX?=
 =?utf-8?B?UEdHc08vMmhvOHhBS3FPOGdFU3VZRjF3bkxOZlRSZGxsVkVZbEY5alhESEx2?=
 =?utf-8?B?bWJscHdScjVPc0g4UDF1OXJORkRGb1hJaHd0bHhCdGkxRG15dUd3ZEFqN1pl?=
 =?utf-8?B?MzlWTVlCRW1yQ0NmWnk5b3lwaG9ySk4xK2Fhb1RrZGQwRHUrSlFzTmNBbUw1?=
 =?utf-8?B?NjRJWWZRaWNndlRwT3QvTnc1clZST3FXMjRhMTI2d00xaWdyWDVwZzdvK0hM?=
 =?utf-8?B?OFJzUUhBUnRLQmlOVThnQ2FhNW5sUEgrUUl4UHVaMWF4Sm45YnFEekZ0T3Vv?=
 =?utf-8?B?ekJMZXE0cmtFakVaMWdZMlRyb1FvRm5QekRISStYTUlBVHFULzZlV3ZVYUlY?=
 =?utf-8?B?V3FuZVVnTHhKZmNuUTZITUxnWWU3eWxvRHRzWnd3Qmh5U28ySVdIalFxRUNn?=
 =?utf-8?B?VmRiVHUvNFdKd0hkYlJYbjAwOVc4Mnk2dkZ6ZWFMTHIzanh5M1pjb3RpVVFO?=
 =?utf-8?B?UmxBN2E4MkZ1bHR5MDdkQ0NmTTVrOStCYk83dXVhV1dRenl2VHNkb2N3Uml1?=
 =?utf-8?B?a281L01KaXE0UmFwZU1idXRrYXUzQVhUaityOUg5bUwvck1aYzhNR1VySUJu?=
 =?utf-8?B?YnJwalBwdHoxeWY2V3ZheXUyOEFFSnRVTm1YZmZVY1Q5NTBtQ0tJMXcxS1Z2?=
 =?utf-8?B?T0lIMW5odzVLL2lFVmE0NTRXYnZCZWFHVmlnZDNVNzM3M0dyWVlLbmRyTUJV?=
 =?utf-8?B?WUNLYW5GdHpiMzlDOG9nWG0rYVZyU2JRYTV0VlF4STIxOHRwaUZvSUcyZ3lr?=
 =?utf-8?B?ZUpPbFBGMEVoNWZjMW4zZHRFZ2dLc2h5WlRZOGZwYS95YSsvM1czV3NDakFL?=
 =?utf-8?B?dEFaYWpIYzZEQ1VNd2RQN2t5S28vVG5va2dQdEcrcjNUVk1DRXV6ejQrWjFw?=
 =?utf-8?B?SlVLNlhtcGZvOGVJNzRHS3pYK09JTmt2UjltcUpsc2RxNmZoZ2sya2l0Y0FS?=
 =?utf-8?B?TUVBOXIwODZScklaTU9reWdmejVKYXUrYVZZOTRSYysvUkFiRFI5cXhnTDBq?=
 =?utf-8?B?UHhwbXZRMStuWUx3VFR5YnFGSDRYRlhuRG0yZGNJbVBGUkNVWlVtRjVzUGZv?=
 =?utf-8?B?SUtveExYV1NsTW9FOTNrbTBkVnBicUYrUldQclZyNjVJb1RLYVZvckJHdkJk?=
 =?utf-8?B?cDhoZk9CcUt1L242UFMrN2JYYktSSHkxRlM4amtCdG91eEdrNkJJUVkvRjht?=
 =?utf-8?B?UXMveVQ1STl0MWUrdnJvWFBWSXZPYjV6S1Vsc1dnYVdjQXNZdGVWQ0ZnRER5?=
 =?utf-8?B?QVZFVTJkc0JZNy90c3dsTFJvd05TaEpHYUx4cVh0bm1jQy9PK3h4ZDNnS1hp?=
 =?utf-8?B?SkU1K0xSMDBDYXVlN1MrUWJGcUZBOC9TeE5PL2QwWVNuaGxCaFVtODNsbkRu?=
 =?utf-8?B?am1tZksrckRaWFF0Q1VjS29kMUxqZTBqOE9QWmNibnltZmg2NSt0cWYvckJX?=
 =?utf-8?B?bklXQU9wUUFud09FVVUvek5HRTBZQkN4OVI5UkJqeS9nckJsSXRLZlpPREJF?=
 =?utf-8?B?Z3ZEYVhKb0lSWWFYSDV6WDdvaWVZS1pTTGhNWE5CZ2hMcnU1a3d6TG5pZy9i?=
 =?utf-8?B?YWpId2JmQks2VWNiQ01weXM3VkNyZGQ0QWJWZ1NtUFpJb0RZVlQrSHB1T3Ba?=
 =?utf-8?B?enI3OW9Na3YxSUVPUU1uMURUaVVOc0dNM0hRWUJBY09pWjRlSmNnTGFXcXli?=
 =?utf-8?B?ZDV1SlVseGRnR1ZxTTNtT1pPVm11U2wvelQ0d0dYdHlXSDB0WmFrRXJodHNp?=
 =?utf-8?B?OU0vQXBPTUxBUTBmUkVJK2t3UVQrbnBZaDJXRU56ZTZCTjZIL2V6Sk90TS9L?=
 =?utf-8?B?ME5LRTJXN0s3WXByL3ZsNGI0RkE0ZHg3SjRsSmFRRGZvNlhYMWYvaGRTMGM1?=
 =?utf-8?B?VkpobUpFamdkbTNENDh1aUx3TDFlVDNUTXpvRFFCY0t1WFZaaVNYY3praFNC?=
 =?utf-8?B?VTArbHA4eHdVbVorQ0NuVVBPenlHam9lRWZVc3FtV0tXSzFDcGZuM2FIWENF?=
 =?utf-8?B?Rk9abE1jcmI2TnlhdS9ldVBHa1JxczduN0Q3aG92TXB4OS9DUTI0Q2RLNDU2?=
 =?utf-8?B?d2k3WGxJNTJnaEc0OWdvOUtma3NKVnArRnJDa0pJSWkyTTVoMTJ5eUUvUW1Q?=
 =?utf-8?B?SjYyUXlrb3l4ZEwreEFhVmozdE5IdGM3eHlPOWRvSU5XWHFvWXFnUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a8913c6-9d7b-42db-a4d4-08de88ddf1a2
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 13:13:15.7286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Xbz2PQdgvOnGrh1ueRGByQLcQFhQG61QmiwlyCCQdj0t39Ei5ap+R0k5bFvkn2dJOuKY79o8puTzBK1WCFDMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P265MB2412
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5DCE24000C
X-Stat-Signature: bo336k4zpwehh6t374foxoepujfgbgxk
X-Rspam-User: 
X-HE-Tag: 1774271599-158401
X-HE-Meta: U2FsdGVkX1+W0tdbr9mXZowW7TZgEkbw8gAFsMDQ7S1XH/Bok6Zwk0yBOQZOEcUfCnwlBpEhhkt3913MwlzozZ9GWLD5u884+nZNaRq+IHlh6jLvD1hfV2QaXTx5s2nwtkFNFDrzJwGvrHG75mwpUxO974OXpMMcPPkbJjE5Hr0541pV8IlD58JF1SkBgBx8YK0aoKSEAqBK9EuhFdSR+XlO/LQxCjMVZPOKGVntNMENOSBmvHhmf5K4MyfjtqtlyiyxE1ksmj0iuGse27BiSUgTjys6bY0BVNXgZM3gkQ71oVNOZm47lG1APdgQ9Dx9PAhX9VgUHGTGEP3wV5TYwV2C6EEm2wdoDs1sR6mLHqzSRRJgVxNIqYgof3PxsH+sv513E45/E7GNqsK3y+cBqEBJc8PXrbK8wLKBHcCKX3pFcLKECs8s8rPEWR65Q145PWKWrgcgmB5EEr+pPrWk5a08tq2i8qFCkKBI++31A8DDL0dYJxR9uv1/zPj0QRn8UnpLv5utuJRP4Xs5hjYNZCyvK5sCHqDjKLBpiMrdNCtVYIrdU82ScPN0cmnDLiaSOfBrQOXtA7lOymVW5YJmVNvI5TEvk+BcC5gtVxPOf4M3Ll++/6hvFaP60ja1sNE6DpAPwK9dGyidEF3+uusOkMxfj/IA8pvfj9IYPECgG2mkO3SNcZVwOkb04hGNkmpArZfKZGI2jCCU8MOi9Du2BOjKtGE8RbxGtzhhsaaddnPkwhCPt1h+/C7iUQ3ssdtyVcdqlNKqk6KZxTzEggEtpW0+oSl9Xyke3WQ81aoTiaY8WMAMC+gh+OrDanDZT39FgcY3f4x3DHyt5Wha8LU2XMobNMvCC1rxASdg2E6I/p8V5Y1LdrhU9yOCAXPglsl+2d6RpeCg45UMPWXBZW50z96YYekP24xsE3UxaKgWxAQ+wYd5ehjRE4bCLsUxrxVGhHM93vo24l3/OwhzFED
 aOmdq0Th
 Uq/dZSf9oB86+MV5GpTbY1rQMZHQDWg2WVkJYNwiA4hLuxD7WXgIJvY4aSDGxKG6qBhLjx9CE+Vu58v2hKfT2p9lpp5Itb0bMRJixw+ht4sEzUmsB1KKDHU0/TAx+bwfk61D+yCpbMfPM6sSgPINO82XQMX2h162L06DlRpHUzhWz8mgQv70Da9pGokkoQDFKpPxdK+sGsRiliiiNpWK+NAJUY8u0SLQKC0RXMahKpVcZ8DyaMAHXRoTvYTAjGJX05hlkIpB7+qEWI+lcBO3M0zqdhvPdk7QkVNiyADNVzeGziFSYmPz83RDC7cNtJtALAIksvVsbEdLuh9yfUEfb7YfyhrB3CQGmHuS8VlpUBDohQC23tLqM2aNbwOd3UIoEgw2S38adpbEQHRthj2GVrZnTxyqMjxKwtPd/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Mar 23, 2026 at 12:54 PM GMT, Andrew Lunn wrote:
> On Mon, Mar 23, 2026 at 04:24:59AM +0100, Miguel Ojeda wrote:
>> On Mon, Mar 23, 2026 at 4:04=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wro=
te:
>> >
>> > Rust is already fragmented, because it does not support all
>> > architectures. Do we really want to make it even more fragmented by
>> > having some bindings only work on a subset of the subset of
>> > architectures?
>>=20
>> That is not the case. The `depends on` is not about putting them on
>> abstractions, but on this experimental build feature, which is gated
>> on `EXPERT` to begin with, because it uses a fairly exotic approach
>> involving LLVM bitcode, which carries potential pitfalls, like the
>> mismatches on the target string like one of the commit messages
>> mentions, and possibly others.
>
> I'm not sure i follow this.
>
> Maybe i should ask a different question.
>
> You said:
>
>> we
>> may want to start simple with x86_64 and arm64 or similar first.
>
> The current proposed code for netlink needs this feature, because it
> needs access to inline C functions. Is the implication, following a
> chain of dependencies, that netlink would only build on x86_64 and
> arm64?
>
> If you want netlink on um, arm32, riscv, loongarch you would need a
> different implementation of the binding?

It doesn't need this feature to build and function. It'll just be a bit slo=
wer
because inlining from C to Rust won't happen.

>
> And a completely different question. Are there other work in progress
> solutions to allow the use of inline C functions? For networking, in
> particularly MAC and protocol code, anything which needs to access a
> struct sk_buf, a solution to this problem will be required. Do you see
> this "fairly exotic approach" as just a sort term bridge until some
> other "boring approach" is ready?

The actually inlining itself is not exotic, it's exactly same as LTO, just =
in
smaller scale. Although, the way we do it is probably somewhat uncommon due=
 all
the constraints that the kernel has (mostly due to loadable modules, so we
cannot perform a global LTO and thus need custom handling of LLVM bitcode).

Best,
Gary

