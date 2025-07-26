Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01117C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 15:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681066B008A; Sat, 26 Jul 2025 11:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631FE6B008C; Sat, 26 Jul 2025 11:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9A86B0092; Sat, 26 Jul 2025 11:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6536B008A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 11:50:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FE321A0AC1
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 15:50:28 +0000 (UTC)
X-FDA: 83706852936.16.F8D03F1
Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021085.outbound.protection.outlook.com [52.101.100.85])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF93B120002
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 15:50:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="Uo+/d+LQ";
	spf=pass (imf29.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.85 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753545025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytHTFknUpfOwh2UivRZEvcOG8i6S/tGf+DWuY00ygmQ=;
	b=YqxCid4GEUwqRXvobA2t4qPbrtED4Vi++JXscjGMOzXjPzd8pL6B/HztwbGVjscbOdDjnY
	MtBu8+cepkDXxQyzbhtqCFadvXdIftCYK7RpfhksSbjmigwZUmzV6+AZ7sKJJNl7wy3Os3
	6CrVfcBwvr2AargTPmyoo1xvygdTZg4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753545025; a=rsa-sha256;
	cv=pass;
	b=zabbg3GJsLVK/vvGrwZjNS7dRni/1JvJOgl/+I1yUmhSs4sQRINbY0WNRRTMiFtCAcB+lr
	pjW8FVuB0JB0gM/j/2YDAeSQg2JXS1RS2/BIWvau53p1lF9Cr99A6JAtgELMthPHUB4U3n
	pUVy7pGbZ+lm04ClRgN39Sv5fNpQzrE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="Uo+/d+LQ";
	spf=pass (imf29.hostedemail.com: domain of gary@garyguo.net designates 52.101.100.85 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHcNPEMlPge8TubxDtzq4CgxiRX4Fi4msyHwwbi6W681iZTl9JRyQBRMcooWiQNXo2zb3KWlV2WOnmlFKHw4RZg0Wfe2gGeF5NqeKflTY3nNBW6d1QeJBo0V9xgSRVL9XhD4O4/EivGNzitVvkBHOO6423d3tTE4tsEKRrvxPseD5aXai6oXOtjtBjehRefd34t3C7tAD6cZ9LH+WWR2zN/+h0rsHr+s0CZkY1gb2JgMirEqm8Dt8zYWBUm2W/0spZJrYN+ZoFXN+6V4HrggxyEJtrDAPE8R2ZRMV6l42uhenpTDtxybQgHfqMxbMy+w0uW3dNFb+7MSNbvUm//Ugw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytHTFknUpfOwh2UivRZEvcOG8i6S/tGf+DWuY00ygmQ=;
 b=dEGzhNe2lWHEriir3G+3ZwA+3fPGwjkgGYeTGH682Czyr8nFh+iWWRTrWG12y2MkXCeM1JMpc4RqbHcgU4Ng6URVWWWtPuKbKgfIezbrZuJQp3QVTuH35KTm/N3xcdBfJIp+IJOo1kPT4EU2cj86RsNyEaMQCGUXmOD6NfttpHbhhCcloazji2Fhg2hTrWAryvTbMYbdEq87LiOp8oW5vfsH+IWTIYrZXNc3IC48DGCDa0c7TgyFSb2SwcvZrjqgF23Uc+5RZ3ciXljTchiEByz6Ih1PRDABFw4syFLxY3m2ip5n/Fe74M6N9sPVpu1ssc2Wt3qtan5DzsVT5jx5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytHTFknUpfOwh2UivRZEvcOG8i6S/tGf+DWuY00ygmQ=;
 b=Uo+/d+LQPv5dWyOn5RriTUYAYNyd0EX0tgyAb5+RbZHX6OicE3ptTb/1xwtfbchp2AW0G3PtD+x+WSGWHC9fby0pPaSvLMALimpmcPCQwYB0HJwWpv/PvmRhFgRy/d8rFxOstNfJo0ntnNzNr5TklLmKsK/TFz5z7kvxiR7Q4MA=
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO9P265MB7475.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:3a0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Sat, 26 Jul
 2025 15:50:22 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%4]) with mapi id 15.20.8964.024; Sat, 26 Jul 2025
 15:50:22 +0000
Date: Sat, 26 Jul 2025 16:50:20 +0100
From: Gary Guo <gary@garyguo.net>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Andrew Ballance
 <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, "
 =?UTF-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
Message-ID: <20250726165020.46880c31.gary@garyguo.net>
In-Reply-To: <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
	<20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0319.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::19) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO9P265MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: e634dc82-d01e-4458-e16e-08ddcc5c211f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kdJ8+DVP9ee9OMJs/3TsUM12COujCrMPxs3x2Jw58zahjY9oSU2c5wnRV/YL?=
 =?us-ascii?Q?LDFXvKt3iw9uhKtX1R5S4SDv5VL/rdkAJXp0Lvq/wgRejiMtcUCtRD/cyDSu?=
 =?us-ascii?Q?6estirCXqBuIxG0uB/0oUygVz0my0zwexaxXYxjn1FwQnDXnAbs54mH+q2Wk?=
 =?us-ascii?Q?FSUePDJ6sk8Wi+KEaU0d7UcslaxXZaQkzCDcuYJqwE7ZauI6LiCASLuoZBBV?=
 =?us-ascii?Q?CHntPAeEn9qmggiAM+5G89hREomIw78VcuX+zhHpgU9ZTj3FCNoZIsyvoWaQ?=
 =?us-ascii?Q?VPsgkA6kRGvi//sDgclvi8dSPGe82MSsti7cX/QOySTOpsoqUawO2nhVu6o8?=
 =?us-ascii?Q?uCe+dq9RpJqcXiO/R3Lv5c+f/d/q26mWqe/QLjoK3OedEzyJEqAFFZcLCRN1?=
 =?us-ascii?Q?yNIUBNEDVgPE3lLr1ttUOmt31emjj9gm8AEEw90LAxI4dOdpSxFf9KAf1Tco?=
 =?us-ascii?Q?1VqvZRi1vLDA11Jesae92FG4B978zrPUkOf75/krOOLyzZ+MC0PPyNLQhumG?=
 =?us-ascii?Q?iHwJFUNWiNY1SZCSb5f3y4Ax2YtbE6/qetZ8LaBAmB7DUjqOWGFvmRjTFXDj?=
 =?us-ascii?Q?qs3isBxgkEinZYPpuJUX6wuNnTnSz0ru7DjNw8Z/c98yEy0ShWbzpa6tV7Mz?=
 =?us-ascii?Q?gc9cAbj0mz0zEqIMGsbtGPeRhQ9/Z0uvcU9vw4mHBx4DuVTOqda1hhJGYnKn?=
 =?us-ascii?Q?v4dTKGGvtpMcIRlX2tHKSEbG+nuYg6pFeKtxc/kjCGF21jzZpEPj3d73x7dQ?=
 =?us-ascii?Q?vJUj5aaMDHpv8xDQJqcie4eRyQclQL3JxXrCcZj3iyByoFN/AoVVCBs1u0Wr?=
 =?us-ascii?Q?BCuFbZUNR1GL7uQ1CtjaYfd6WfIoDtJ/lNxWyQAsLF6zaWQzvnKjVf1+pBDY?=
 =?us-ascii?Q?hkeR73FmveBWsIqJb0Kh8G+xI032QrZStwgY+8BRXzu9dyfXb+KoKhKEOPFl?=
 =?us-ascii?Q?R5+JcSMMnmkRjwMpRzjZz+LYlZuYHXFIq4mYbVyN0XlwmD4BBK50EJFw3nJX?=
 =?us-ascii?Q?kJaVq5hQEhBzxQkIrnfy321uMDmWhVLHmUfq7VoolESc4ibAzFI5RpZfB6K0?=
 =?us-ascii?Q?nSMIkCxLL0b3+CuaCzww/1EDHW/+OnZC5AChBSTyh6Xf8LtsQsuivf6hYK3j?=
 =?us-ascii?Q?heWbMahBvRd0eZowgrMU6zRx2+3YSuO3mXoAGcFbgvXJDVVTiGfxI8wOBIkN?=
 =?us-ascii?Q?nBCk9xNPmpVIooe0Z26/w2q9Ou2DF4OgEp8HizG89iHEjEHsL3iCReC0/ZXk?=
 =?us-ascii?Q?fRhFHOxZ3xeR9CNJzkSUOagPMTQ3eUR01OorZPYPpwLW4LxazpxzChXTX88x?=
 =?us-ascii?Q?MwR0TlfYOrJ7s7CKmnCyEYu/oOHtVFJdE8Z2lNfB6SREXFiarstQYrySRGxc?=
 =?us-ascii?Q?diAnya6hvk0zrPmWp7clKmt4GxZic7R/g7NgeXUU7s9D60Nm46/9VvDY3iHB?=
 =?us-ascii?Q?TJBI4Ijq4l0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V+oaDqI8O3iVOegBVXCy5yWEkOTv2vVjNzBehbWYxPCZuFsOlG8giZVF4N2Q?=
 =?us-ascii?Q?X9PWGrQ34zaIG3MZ8WOiwhqFCYEebZMiiOkOosJjzchqZNckue0YM0rlYlba?=
 =?us-ascii?Q?ElKVHYZEEjxvg1AfhoywKNnZFXEwFArF94TbUAFILax3sqBwy+tmKmllWtwh?=
 =?us-ascii?Q?//Vnps1mMhWXHlAd0KFojFtL67VRAQbJpTTZfEBOFT9awNM022onvhrPZuyN?=
 =?us-ascii?Q?1XNRTVNMavpABiohO/RNUkWmdy1iY5pw92EkRXUDki5jZ90lFlc4+4rF+5dD?=
 =?us-ascii?Q?Ee8J6HuwDKUipKKr/QWMsVN06KW7+pzG0s7v8F4HVK/5tHQHURNW4wOYLVo/?=
 =?us-ascii?Q?XAc5CCU/U6jONsWjArFtEe4xNx/2S0y6QOdQCIDRnu8G/qw6Nl6Nf8ciFoaX?=
 =?us-ascii?Q?hkKTASEIjX45hkDTnP8FPxY0etAnmvNDOfeoMzidvfVPY+mMPiL/lp09nzvR?=
 =?us-ascii?Q?gd4RNDyPhBDUtXmK7ctY7MoNcDigA3+vqPDr5Mo7ytreIcp7oqtsI+TL7bJl?=
 =?us-ascii?Q?aN1Xg03+qcYtAAKJ0d/tiUE3wPBaeijXCR1A6nXl6KLJqBPHom+VN+2fJPvr?=
 =?us-ascii?Q?nPw295Ag8YEesMtor/SVCsT5hBgVEy8hF2IPopKk/TiFTK9k5Xry2WQKhgYe?=
 =?us-ascii?Q?vC5XiE6xfJUFQlj+X6tMpplRul2CLFLYQfUMtkS7fmIhvhqT8O+rkmWtqHL2?=
 =?us-ascii?Q?wFdYGaZb3DVE2dTE2mWNHE9hxrr5q1V6cmdXSijwUvGTmn9f490zaCgkAWIw?=
 =?us-ascii?Q?oYgYJ5gTJJrQIzNn86V/pK3w2kPkmpriP2F/u+lq+8HnYff5KFUilpcCUj1N?=
 =?us-ascii?Q?5rRjF1FyRq345Y8mVWzyEFKc3fX7HSRpbabtLQiWAsSe0IPr154DtJ1nLjYo?=
 =?us-ascii?Q?O1Q/mWE/pqL86S5aylgVgmbORbOFrpMMHoQD9G9eP2TL7/do6GU0VvWSAuKu?=
 =?us-ascii?Q?gDk6r17K5k5pTPeTWl7RoHkUyJjqNz2OieV5yIIqXkeOyowRclYnGZsOgg6C?=
 =?us-ascii?Q?+jBcka3iMwYm4r5pChzhaW4Z8ALejYN8/TALSc9oQ3M4EqLlzjFPvFRaK6OR?=
 =?us-ascii?Q?DJ/GJHW7N6+iwXps7EfnC8BSfTDMtcMHIdiAZi+2JHfLPZmqSP+3Fl7rWxas?=
 =?us-ascii?Q?bslQFp6ecOm+7x7E7WAAZ/BmSIpwgKPFGQTFeilXlDE2vs5Ht+1qQ2XIC95S?=
 =?us-ascii?Q?oIM2SrBfDk7Fm8104ORkPVlB5u1WEeulckyWwvwQ6MT4vhVdYyEkWStXt5sb?=
 =?us-ascii?Q?XHTqxApOJ+i3KgHSPNbtRzF2CoowZ/UvQ/4p+YqujPyi+5IvKn/O9leQ2USq?=
 =?us-ascii?Q?aaG1tEiJBHa2jfatS8WgTemTXbCIFWPv8YbbsBEAyUsswD31BG/SglC452az?=
 =?us-ascii?Q?Z2aOB6oX7pTyJOIRRHA4oaOEqiD/SzJklAoun9OKOvtKTCf2VBsRLr7E+Wdo?=
 =?us-ascii?Q?f+KBW49geBeqNSmVC4A+FPPWnpJhvMJxMKIloXm1c4ANzyrygRDTWTUNk/bx?=
 =?us-ascii?Q?tM50qrEyOP4T9/JT6MSY8fFjJWG8NHdakqEMtA338KcEor3wmwpuCZELOVd0?=
 =?us-ascii?Q?DAYvehpEGyUZrf5jOy/Z2vZTTbxOyZEEL3ZNBo0YhG5SnEPQWIviObJxY3O5?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: e634dc82-d01e-4458-e16e-08ddcc5c211f
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2025 15:50:22.2804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8z2k3C1kQT/4il6Y90vz1onpyRRjDyxsJOkFMetm8Tts/ztDO5PQVIPbJZBm2Tf166kprSzHC5Y2nuSd0oPfQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO9P265MB7475
X-Rspamd-Queue-Id: CF93B120002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 8dra86pe7wwauoigkn6gtt35giodk1ce
X-HE-Tag: 1753545025-387398
X-HE-Meta: U2FsdGVkX1+3S7CSnebMHiLpJ+f39qhUDP+j/bu4iOGpC/h5Q9WTyg0VKyC5NhLXyXLdPBnfg1MR50slLnHZsiMfzQcMTnm+fgG2lB+IvrPOPySDpajpzy5zx5OXhYsHq4rWCUJRTv5ApdM0s8EpoKQa5r6b1uIxxTc8FhFb1/j8zz+yX0eAx295WEZmTFZxS39vQHQotlwDokLlQ2jR75Q5A4eF5cQqoZE0D+2qkhqsqfL4T0ChMMyaV3Ig7590NC62rtdmoy3YgnSQXN5SqHKhPerMkJoHRvnDUzH0nDQHb5qFz1aK6ZobcuRtSOS4jEc9eSIPh+PsyW84gkNtOKXSTwfdCBvE2TgoS3Y2rMiF6SELGzpNJvLY4XX+R1b8BeQfMt1+DcIR0SxJ+gFst63lbvgYBxFTFPv0almnkZsIhRWWu87e6vVEyxyNPtNqv3cL0L/0Rp5YVZy3aXIjDQ0UxALd7OGh+cuLgkwEpKU21HTnPWgDcot7H6ux9RIJgU8l2bPN9n2y5Ewv5LSLpV+NBbbTp6TLIYSVjQW0+3bFeYUtfD/P9qfNstDbLYZZGe1KgdbJcay1Ari/ax66kW832dI9opQeXWNk0Cmvy6fvsza2c5V/9QSz1RtPYvpIKAori5XZHu8HTQKmLk8SZ9QUIbLYGsw02WfWMcoT6rTa6UWD3eNOf+Esuf8rPGBKiyiTrD6XhxNyYLlxjNIYc7zzf8A6F62OF7584wIdM3tDJ7TTwpzBa4H0ffycSqPqe5sgZnuKfLTK+7qXaIQkY5uTWlifcvlzTiX2zr4DNg8hg2/Gxqeosk1Og37XQF/7i9DwOxMNer03UsTtAeziEg9P8HZTFWlFj0U9hrOj4QZyHl3k6nAYPbiSbnjj+x15XUhuk6kIjcDqkFyuwYGci8PNrkQXXa+SO43Z+PDqKi9JR/ITv2TckVx77yr6nEFUrgb7HfRld07CCz7mryx
 j6TQe02+
 gySRCOPy2Teogs5HupSi2wTXiDQmkxU9fqTHJAI+ESCWKDYAf11NkRbFdmQ+ouqr4hphxFMsp5wNBSWTNF6JBjFJVl7fu5WUSK+y4gmcZYqlVnZfWjH4uWk6iRLklFQeZKwC/4yTZKZ0Vk1gLP+EiXYFUGP/tqgpzfIO0ENZEZeQQcz3/mgEFSqa4I/sbKs0JW4RAo+dA9HyCO1m5NbUHm01ouzLjZxB5wKaiXNJ7dtmxejWUi8VtIjAlQRAx0r1Wc/cV5eLezH2JN+NIk1jgoXqmg98e7Tu2ntx9ONuDZEgWhkwoulr19RRtJZVX42YB0PMgxJ5Dje2odGH95chNGddNHMmvnlmu6M6FErq3MNeuNU0Q1Y4h7ZVQ4MVEqDUVh6nEtPrmLiyIJASxjc9HGnBPUL9nBMirDESj9QgswtZEpK7InrQh6Y28XS74D3XYUMpZOQOQWIR5VIga1LI5A3+yvsyu+bAbe1I5grxaeTKpcxW9xfFnonOvzK56tdWlM34DzcI+WFbKw70EQIVLv3u3/eLOg9v8zCIDJ/i9NZqhXPbD5gCOQOleZz/rVHShXUwMJnVuuqxS+cY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Jul 2025 13:23:23 +0000
Alice Ryhl <aliceryhl@google.com> wrote:

> To load a value, one must be careful to hold the lock while accessing
> it. To enable this, we add a lock() method so that you can perform
> operations on the value before the spinlock is released.
> 
> Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/maple_tree.rs | 94 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
> 
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d5752b4f5337fb6277182d1 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
>          unsafe { T::try_from_foreign(ret) }
>      }
>  
> +    /// Lock the internal spinlock.
> +    #[inline]
> +    pub fn lock(&self) -> MapleLock<'_, T> {
> +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> +        unsafe { bindings::spin_lock(self.ma_lock()) };
> +
> +        // INVARIANT: We just took the spinlock.
> +        MapleLock(self)
> +    }
> +
> +    #[inline]
> +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> +        // SAFETY: This pointer offset operation stays in-bounds.
> +        let lock = unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock };
> +        lock.cast()
> +    }

Could this return `&SpinLock<()>` using `Lock::from_raw`?

I guess it has the drawback of having `MapleLock` needing to store
`ma_lock` pointer but the guard is usually just all on stack and
inlined so it probably won't make a difference?

This way you remove `unsafe` from `lock` and gets a free `drop`.

> +
>      /// Free all `T` instances in this tree.
>      ///
>      /// # Safety
> @@ -248,6 +265,83 @@ fn drop(mut self: Pin<&mut Self>) {
>      }
>  }
>  
> +/// A reference to a [`MapleTree`] that owns the inner lock.
> +///
> +/// # Invariants
> +///
> +/// This guard owns the inner spinlock.
> +pub struct MapleLock<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
> +
> +impl<'tree, T: ForeignOwnable> Drop for MapleLock<'tree, T> {
> +    #[inline]
> +    fn drop(&mut self) {
> +        // SAFETY: By the type invariants, we hold this spinlock.
> +        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
> +    }
> +}

