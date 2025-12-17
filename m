Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1C0D65C49
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ECFF6B0089; Wed, 17 Dec 2025 08:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8006B008A; Wed, 17 Dec 2025 08:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA1D6B008C; Wed, 17 Dec 2025 08:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD756B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:49:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E55EF8B881
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:49:40 +0000 (UTC)
X-FDA: 84229095720.01.8AE39BE
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020091.outbound.protection.outlook.com [52.101.196.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C7BCC0004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:49:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="ikJ+AU/8";
	spf=pass (imf10.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.91 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765979378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOvb2i3bC21NvxgvnVtF3soBO/28ZJycHhcmaw2D/FI=;
	b=Exd3ETMmXOW0Vfwz0K6txyIHd1MBdfZqHrWbrmfo9AXX9Tw9n8EpzwptKyFQPusIAlIWhm
	mdg8d+4fcQBTkm5MM5a0Py9gI5B7HfAFH++MpbRvgqNmm7CP+HJyE0wd1tTJBbtaKukkPR
	kv7RJKgfaAZeUhiHGhKnP4y4h/SgV3Y=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="ikJ+AU/8";
	spf=pass (imf10.hostedemail.com: domain of gary@garyguo.net designates 52.101.196.91 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765979378; a=rsa-sha256;
	cv=pass;
	b=onOvUa4NtoA1US8WTEmCGNezFZKQvKebo6AqMRituAntuIYPpowbKwp4uDErBjMl6OI+pS
	sR+0qu5NeErg5nwmxhZhv2s/SH5dilNgHee+R07LvGUk38wAgMmpNtEQ5IPYjSHgVWwbVT
	e0Oc6D84RL4g+sjnQ0Ub9Fh9htanswI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zEex9m+xcvbQq6n/39f0ICIfD+kMhy679usRfQqTQ3kBcgc9Aujj3u7ZXhAL2PKaKz/DegKmgSCfSZV4diFKhwDjHNQAPSnOB7jIbUwcHCgnypEPkXKBECRZlV2fI+o/8H+87YD+ZvgivjuA4RN9oEt/wIE/759no2AJzoHJR/zj/kZ0NWpBETeGMQTjLHtZ2ASe2uYkK+f9QWjemM6KX7oJ3NXi4ir24pRay27sIK5Tp0GzJf9cbK4GdAGAXqg6g6zdmjkOosEPZiPTCvielayIxH1yiYRcN2BPVQGYF5BfT+lWtdXaUKVTAaJfnnYJGUQ9gu6EVotU09kVAZnXMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOvb2i3bC21NvxgvnVtF3soBO/28ZJycHhcmaw2D/FI=;
 b=b8S72EBX0uTKaDPCgPZUny5UCAUiRHhRRB+b5aZvD4syzd7CLUz6ZDCYSnrOdvS4tFBvzcfWMdsFKp4c7WUnC5B1lZkxGWLIH1YJGX04RwCz5rst8c/OsQPI9+Y1x+wI8L/FuCbvELDGJkfvEAmKHQrCtkKptCx5itfSMQgT8XH2puLqoc3u0YNm4mb46dwX2gBivFzE38aTVUfjbFHTmZlrWyirNtRUXJG3F1kHAYGOdqfFa/h4TEyQJuwPzqenDjnQYbhHw8YAGk9yrIy/fZN7r780FG1LMtJky0Tr8/IG1efUiqScQno9QZ205q5fL8OPCz/Gnyqq8pyDUnPVYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOvb2i3bC21NvxgvnVtF3soBO/28ZJycHhcmaw2D/FI=;
 b=ikJ+AU/8OuBA2hnNi4H2aNmWZp6Y9N8GWD86PcrnlguIomBPtQJl1N6tePmWgdmmN+5Y7pnZaGA/TK7QH2zNjretXf5s4FCuartPc+CPspl5nx1iyfIb1Ai7TSCZkcrrGcilVzbP/HWsmi4zJ+DnXYoag+AOLA5Wbk9u6FyKlac=
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LOVP265MB8573.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 13:49:34 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1d18:b0bb:b18e:594b]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1d18:b0bb:b18e:594b%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 13:49:34 +0000
Date: Wed, 17 Dec 2025 13:49:31 +0000
From: Gary Guo <gary@garyguo.net>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Andrew Ballance <andrewjballance@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, "=?UTF-8?B?QmrDtnJu?= Roy Baron"
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas
 Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] rust: maple_tree: rcu_read_lock() in destructor to
 silence lockdep
Message-ID: <20251217134931.60601faf.gary@garyguo.net>
In-Reply-To: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com>
References: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::11) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LOVP265MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: 525369d1-681c-4b15-be26-08de3d731c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?stv0d/XIYSt8sP5WX89CLbBijLyxfck94kmSJi+l6XEquMuxyblh8o4zWKJ8?=
 =?us-ascii?Q?85aq15zK14htuOt9s3T2opJV5g+w+ZaN9Z4JG/j7dgd76ldT8inU9AZdtdu0?=
 =?us-ascii?Q?BKlRXZ1DXHzhYFWIkOYhxw8/UWSLM4Qtom7CPjZcxaYNj83zVFonMInt7Huf?=
 =?us-ascii?Q?wJGcFum64LjmhJp/1MiwQFoYKhocGo4r7O+M+WMFXwzQKiorQ3c+bjM4BraL?=
 =?us-ascii?Q?rstwfCV/LJl1ct4D3nvkhUP/A5y4rys5ci5XKcQc5fStCMZ2yfLuR0mtlfhs?=
 =?us-ascii?Q?GXoMH6DsZvvu316WRmRLEhX8eNAIrnP2H0ICEXq3UAvj8X9pKUkKL5iSdtnC?=
 =?us-ascii?Q?1aaPGGabkvjY3HwrPVb0Dhse8AZ73usQ3TfFplaFrn6Pc0/A8aEqlitwp+Qd?=
 =?us-ascii?Q?h3ZUulklw8EwS8B6QsX79R9f7mqgOuwkTHqWWjw6JzH3Np/ZfhFr465cEzvm?=
 =?us-ascii?Q?YOaa4ycBuLz8wCrx/F8U2zr6ONjzRBTfWbVNEdJGqE97nPJy128nkOzU49hq?=
 =?us-ascii?Q?cda+1wRG+5tW2pwqwMAg8cMYNvS+6XvuG/P3qE2fPoLP9UBHj0fsX1hWwEiH?=
 =?us-ascii?Q?1sYNbeJIGRM3FnKJksdbGC7LeMwzvxyOW8RvwC15G0sJNjt/pi6MUjvfbmXT?=
 =?us-ascii?Q?XBTO4DEDGFGQ32E3gyWVvuayV8vfJYRnf55tOCUk0wBaVmVs3/+wB7qQtT6+?=
 =?us-ascii?Q?RGF8xjrGo2eXexg4BV/pc16GXcvMmMXiYQ/6O3ePZdYpZ39vb/cZKszmFNud?=
 =?us-ascii?Q?E1Tfdq304dZMoNMor96Lukl97AM7f6Ay52eS/uA6xNWRMSgx9HcP0wK5tK7y?=
 =?us-ascii?Q?BbsWXVxXhxiWOujXjZPv1oibgZHMveUQn9tDIjXlZf4ijIeHYqMfOnd1rpYl?=
 =?us-ascii?Q?L3xDG4aOPq8+dKlTMeXs/7mbW67jM+zMbY5pz830OZigtGASV89kwYZVzCYk?=
 =?us-ascii?Q?leKx+fSxDPWqwczx0W8kri4k/wVJOaTa378+m7C3VJwo68vVHB2dGglg/ppo?=
 =?us-ascii?Q?eEpU5dVjjfc3oVRVx59/Mc4XxVhFUv6i2JMBRBOaxPCwN3pzP8uKo5cJ5uME?=
 =?us-ascii?Q?rCTtDWywOHfEGtwcDO0yvFzjeqe5PosUbkzmyKkDdSbFKwhXBkI2iGnFG36f?=
 =?us-ascii?Q?sVtJe0InbIQAOrAMLt4EnSlMiNbj7WGFyupnnLEIfQsPQQ0FBQ2C59QV7jQh?=
 =?us-ascii?Q?ZNV9Pf4ijaO62O8ca7cwlQ9hIvsl3+kPOHbUxN9LwK+dGO4QfYu5fGv66bP8?=
 =?us-ascii?Q?26w5jaboUqjM3EdVTzqd3AmoQfFq+9MqNLG9AFtwyJRP2pO49LyCwgqS+jE8?=
 =?us-ascii?Q?veDHBYeO9UkIQR+KnPi6me0WDz5/PeNoNjs2UPk6rxWGjb49iywL+Nq7yDWj?=
 =?us-ascii?Q?7RcIASQmtWZWzQm3EdSa3s8IlJWZFQU/uZN2xhezWoghjrlDwA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tlWJQCgulRybbOpbpDzy3440Bg00cVWdpfL6T0Gy9ybA8heuHTaVILG8qqvL?=
 =?us-ascii?Q?V5I8zxLsQfdpi7jCbrTHDsFDUWoaVjL6gvTmKyZ06TvM1yW9X+7xSnPsCD8y?=
 =?us-ascii?Q?DMacZbkZADCApqQmWo8FPAs4s8zSQGeP7jI43SJPuhKtJDpVgUTYLm6/RhoP?=
 =?us-ascii?Q?rzq1K867lra8bh0EpDTeoI8g+IqjQLCRP/Lex2VIcQZAVdL4+D6CZQtBMuyo?=
 =?us-ascii?Q?8pJg65d+atTV3KWO8Isgd3Nuf/MbAJACaS3Y+1t30RHalCAIlw5Ae7AWtRJC?=
 =?us-ascii?Q?Eboute2XALz9v0FXeAmrZ+y6NUdW11sW1zU43+G6SP/6rQgQy0XcWU7YYMjn?=
 =?us-ascii?Q?fKQUlOmRbYzWFQapfnOykmJMl53izDRLf5LmoEYPIWuYB3iUjk82scd1BAM/?=
 =?us-ascii?Q?n5BfXeZNc3XVrYq4zaKc/9MjaIzvDwC73irCDbD2cmQ6BDYnfH506IGIj6fm?=
 =?us-ascii?Q?xlGygx6w1asZdZsK3J606iWLVhZXGTfMBy2DbDjvmepLY6fNW8ud9MQwbdfN?=
 =?us-ascii?Q?EwuLLQAFzFBvfsyI/Ral8zjA6SPsF1uZE0arAs1iI208C9VwRAR0sNmoOjKR?=
 =?us-ascii?Q?ETFUkabVG5fTx2LhfxgDtpfGkFTx0X8x1hvZrNKy3YhRzzZ5I6lpFXf/M3y1?=
 =?us-ascii?Q?Sw5GRBvWAaQqNwr/QS7QycKuhfRno/cM0ebftIVz70+7YZ8gZTV+slxJE/61?=
 =?us-ascii?Q?E4w7VjGL8xY43wXEMqwsJhud43ifXzMmPZVIwsemN39yv7raE7VaX12lvpIk?=
 =?us-ascii?Q?WlfBvKmxGtt3eLjBQZuOl2JMBhmbf7VtGN4dRWgYfoq5nZ6ere3sEFnralCl?=
 =?us-ascii?Q?dEMyPFvsgAXkHvahkQBBUr1/nn4nce2rPttmBfm6+533pNjvupbJpzLcodgU?=
 =?us-ascii?Q?nmTWxnwY1j2pHnc3YnMc8cibG/0VakSdnDiK7nsa+Qu69ZoqRxZFrjPN4P93?=
 =?us-ascii?Q?nThpblZbC4VIEFcD5SvTkdUHRfdnjHzboa711Q4MvqZIhxrIoG5m320B5vW9?=
 =?us-ascii?Q?dUizoq4lNGqj1CiirtPY4+V6WVkSycvYHU219XUd9coxoIeOreO6G05i/4X1?=
 =?us-ascii?Q?qkQDoem5n1S7f6CefvsmbPAElamCK0NIBVurBP/R/1zUnhVMOVtkF2CvDnio?=
 =?us-ascii?Q?grycZ93lIUBsou+HJ1dOx1KU0LxMP7aPbB3f19vqbKgQUV56zzIzvRD3X3r0?=
 =?us-ascii?Q?0OoBvLP5kJYXjIPeO9WgpxCjpbi3C3peCG2czDqn1viVozPFs1i9EV6Lq6+8?=
 =?us-ascii?Q?E5f9MZ7XIEMf0SSt6rUKYGdUIU4de5oRkqyMStEwApNe0Yp+VQcqNauQ1Abt?=
 =?us-ascii?Q?28ni4IFT+8dk1KRBqNeFkwNbk6jLqqahPW3yjH6DFgaB5arGd6KZId363z/7?=
 =?us-ascii?Q?mLD9/d4FtLXrqL9ZV8E/fmI8Hj0wyis7IG4o3vHKQNGcBxJ0D7xPKXCehwv6?=
 =?us-ascii?Q?7B1X9W8rRIMb+bkBBmj4r9Mp1MrVxJkbLmPGCyy6it+h4gUbnacVVTLFgw6M?=
 =?us-ascii?Q?2VdYbUrPUl+gcLTp2wXorxIX6JdI6nq7NzFvZMn7Lt/O7tI/r6gBma4Z1eOp?=
 =?us-ascii?Q?aOCnfKDDR3AJ32SDGe91InbHo2QJYX4kyaqYRxPE?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 525369d1-681c-4b15-be26-08de3d731c77
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 13:49:34.2837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TebowF03l823oS2iDPdX5uY2SQziZGzib6q4eVymofzGFixmoll3iy3D+63pAPVY//MZFARCHJElibmnjqb5ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOVP265MB8573
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C7BCC0004
X-Stat-Signature: aao9wo81cxd3ksucpiuzq744opuxuir6
X-HE-Tag: 1765979377-556962
X-HE-Meta: U2FsdGVkX1+xI0BXbUbZA/PeaN4Ea0xRQLRxU+uhbEdWkg71Hd+Rnpguzh45fOxxJ84SFl+dej3H6VF3LVBMiOgpCcHEUZQBC5ZZWDQx5q55dgrlrxlJBQwoqbBwvwSSFvxlPUOqQ/PdWV++LQkwbjOc1n64zGwvWoskUNpWlC9jcNM7yw6dxgq005S2+Nlu0Utb2rlGe16tNYx0IKo+CcUD+aEmys6PTp2qrkR8JnwHnxPkw7c3Ar31XoUtxcMplyQI9xTvaLbngCy7J1yGUxt6hYxxm3BJaAVz/shhoPgKmmNgIXjwlTXOPf4K+h0WWJJura5S3VVSXUwq2bkAoT6CYYP4BdjmENcASxc384VWkUV5UF62LpXCRjGRWjfPjNXdfQ+AA3ytuGq2bUkto096HhYxwdIj/DFJwVGw2s7beGX+rfi7b2jMJdI9Gzcghws9MA1jkm6zskhDJT9XleFliO22dj23L5gD42GOBX5hvjwXHGaoFXW6woglXNTjGLQcJrQO6KAmNk8O5cTOG+Ky74KYDRAv1d4rUcoON9ZjS+BD28XvNU+gBNDdZGylGlpuRXrTvdx/PJxkAqYbUp9JuH8E5c/G4uiskDOyeOC9d2sZFzH4sp82Tt8HCBGm8NA7WJoHuqLdVpiZh+PJ9rxOTs0khSIgqd8p5vA7ywnDk5A0g7MqKn63IVmPt1hFPV3TiDusHKbRIh1zG7B+EU6FfB7Z5cGL2vdfoD0MMp/t9rnWN6iyjLeGGcKcd/rAyOxrdcbztH+wt6QKq9Vah7tG4QyzYVaIzcJdD7OIMWK94OL3eek59I9n/7SIXtqCg775lrow4Ey3MJr7lE16ENsPJjHBckE4AX2N0r1xd5ZA66sI6Q7xTLu2F9cggNGkKlzV9FocjU4oQ4IWR5sBvNvNG5eqpfoEh2AQLSdTlc6U2TeSPPh9nv+euDgXL4R8ypRBOw8safNR5RJB0bK
 zKQ/CC1i
 cVUfL2jTIIWtONb/FjjHNYKAFYD5uY/jy2psQx2AFQRfEwVHPqcG2OpkXalrPL/DPPhMXNi3IMqFjFj8HvHDtEU7oVpm0LGPBvyfFzAORWQrISgT3cQtNNNuwbEO1ArA9ahaIGfnuwt1JhMqnze987Rx4pcL57kODXZ0bTlrze8BcM0kNVQCDtolI0N+XXy+ED4Bic+Io9BIX1SDHoVVoGfqkzbAl61rnwrZvt2bYS1K01SSb1L7p4Ii+S3jk+cvG0KminvQ6sPNcA8FKqnFymfySgNQtWlBTS8ftXJgo7PkuAH4HncCOIxaaHz2b91MokLR6VKt31EL5X8d7vvXCRbhsUmk3aeMbn21KU9U3NJ+rnn0jY+RqhH7DC0j+iqbf3gbLB6TWzU/u7HZoKe5HlRKp2gvlGxNUrX2vcQNfYWl3VxhBVC8mo9vmSfP/zQJ9VPu5X4G9c+W2btcE6G4B+rkzCyM8xjcgxWcJawm7mQvH52t4qIDh13Gl3y/wpku45WONFpdc3FPBzQ2cuT5WiUwRifVYRpbwb8AMv/Dpl5/KxltI6BtihtgpMg3omJe1BoL5BFMzgm05wIMPZ+0vw+y1YT7FZkNOxiwljMzyi9W/1dbl6v8q1eCm5Qze5pVmB149Xf44b49tb9n7QizZ2NMwcDHE6pEAKhuCl3H/on3e/28gCfGnk+JKtcDnMYGEhzspeJnr3cDb1fnfpQ3hvdNGfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 13:10:37 +0000
Alice Ryhl <aliceryhl@google.com> wrote:

> When running the Rust maple tree kunit tests with lockdep, you may
> trigger a warning that looks like this:
> 
> 	lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
> 
> 	other info that might help us debug this:
> 
> 	rcu_scheduler_active = 2, debug_locks = 1
> 	no locks held by kunit_try_catch/344.
> 
> 	stack backtrace:
> 	CPU: 3 UID: 0 PID: 344 Comm: kunit_try_catch Tainted: G                 N  6.19.0-rc1+ #2 NONE
> 	Tainted: [N]=TEST
> 	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> 	Call Trace:
> 	 <TASK>
> 	 dump_stack_lvl+0x71/0x90
> 	 lockdep_rcu_suspicious+0x150/0x190
> 	 mas_start+0x104/0x150
> 	 mas_find+0x179/0x240
> 	 _RINvNtCs5QSdWC790r4_4core3ptr13drop_in_placeINtNtCs1cdwasc6FUb_6kernel10maple_tree9MapleTreeINtNtNtBL_5alloc4kbox3BoxlNtNtB1x_9allocator7KmallocEEECsgxAQYCfdR72_25doctests_kernel_generated+0xaf/0x130
> 	 rust_doctest_kernel_maple_tree_rs_0+0x600/0x6b0
> 	 ? lock_release+0xeb/0x2a0
> 	 ? kunit_try_catch_run+0x210/0x210
> 	 kunit_try_run_case+0x74/0x160
> 	 ? kunit_try_catch_run+0x210/0x210
> 	 kunit_generic_run_threadfn_adapter+0x12/0x30
> 	 kthread+0x21c/0x230
> 	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> 	 ret_from_fork+0x16c/0x270
> 	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> 	 ret_from_fork_asm+0x11/0x20
> 	 </TASK>
> 
> This is because the destructor of maple tree calls mas_find() without
> taking rcu_read_lock() or the spinlock. Doing that is actually ok in
> this case since the destructor has exclusive access to the entire maple
> tree, but it triggers a lockdep warning. To fix that, take the rcu read
> lock.
> 
> In the future, it's possible that memory reclaim could gain a feature
> where it reallocates entries in maple trees even if no user-code is
> touching it. If that feature is added, then this use of rcu read lock
> would become load-bearing, so I did not make it conditional on lockdep.
> 
> We have to repeatedly take and release rcu because the destructor of T
> might perform operations that sleep.
> 
> Reported-by: Andreas Hindborg <a.hindborg@kernel.org>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/x/topic/x/near/564215108
> Fixes: da939ef4c494 ("rust: maple_tree: add MapleTree")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
> Intended for the same tree as any other maple tree patch. (I believe
> that's Andrew Morton's tree.)
> ---
>  rust/kernel/maple_tree.rs | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index e72eec56bf5772ada09239f47748cd649212d8b0..265d6396a78a17886c8b5a3ebe7ba39ccc354add 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -265,7 +265,16 @@ unsafe fn free_all_entries(self: Pin<&mut Self>) {
>          loop {
>              // This uses the raw accessor because we're destroying pointers without removing them
>              // from the maple tree, which is only valid because this is the destructor.
> -            let ptr = ma_state.mas_find_raw(usize::MAX);
> +            //
> +            // Take the rcu lock because mas_find_raw() requires that you hold either the spinlock
> +            // or the rcu read lock. This is only really required if memory reclaim might
> +            // reallocate entries in the tree, as we otherwise have exclusive access. That feature
> +            // doesn't exist yet, so for now, taking the rcu lock only serves the purpose of
> +            // silencing lockdep.
> +            let ptr = {
> +                let _rcu = kernel::sync::rcu::Guard::new();
> +                ma_state.mas_find_raw(usize::MAX)
> +            };
>              if ptr.is_null() {
>                  break;
>              }
> 
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20251217-maple-drop-rcu-dfe72fb5f49e
> 
> Best regards,


