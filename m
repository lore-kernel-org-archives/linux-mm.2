Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9570E6B274
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 11:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0556B0005; Tue, 23 Dec 2025 06:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E666B0089; Tue, 23 Dec 2025 06:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89B06B008A; Tue, 23 Dec 2025 06:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2F056B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:57:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85B121DF8C1
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:57:35 +0000 (UTC)
X-FDA: 84250586070.05.1B5A6B8
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021091.outbound.protection.outlook.com [52.101.95.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C9D540002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:57:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=GeIX4C3b;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.91 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766491052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiTWYycyDx8A5kBs5qprEkRZJkxJa4rHlB3TgQ+7k9E=;
	b=SJzkxweIbuZwQN/NfX53qclGxaI4+MmpvoXl4IJxT6uU5frBfFnI2rw/CAz1VRRlEP/UON
	O7odEciq2+05bz1UQCnA2uSHF0at15j0hfW1ZD88ZPmsHiByC4yR4aStUC4rSJMC8TFfeM
	UofpYF1k1uEmynlVgcJPyVIc3y+SqLI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766491052; a=rsa-sha256;
	cv=pass;
	b=poMJFwoAm93k1oMvyCrOigcAfZoBLeJ9GnuXebocNe61MkBhvjs/bWR/9uWsWv7FMWLu/4
	oiDZU0kGlWBdXcBvty3nSux2Pig5E8aefpYOg77s5dyGAQ8liTIgpCqEMT07e6BxwznKBd
	/5H/cS9PqNDRIPs9ks4D2N8jNZLlUFQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=GeIX4C3b;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.91 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBABs1UbQKyFSzWcUaXhz3xAOEXm1EROiyUOlQwXiJmmKA1eNtZZFN38comh6sWJjA5z6P5fd0nRe32iuUvIOe6u/Rm+x0b9mEtIEnel3N0kPiATDZAUMR7nvOIyAieTHdRNeAYBgASkN06NURjJ+VTPU+NgMTxgSZ7oBRVctut34qmTm9hcLCXoMGXKKysNI04zlcV+5PwQ9oo53FXaoDBOt0SyIuDyOtYrEUW0kraAi+iIcR90cklUd7+6gntUsnwmhrymgMyDY9ojowDqmz3HeaKbIKqZj2OhDXTE//+sDTn/4JburqtGJGpv5Zv8fp5aBEEnogOuqNN0ZpjI7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiTWYycyDx8A5kBs5qprEkRZJkxJa4rHlB3TgQ+7k9E=;
 b=uHOh7DCOQ7OnBhJASSJIM7+46X6GERl4g3/EjQbxgne1edIGqacCy21y7Z8UiLG235QzY2fLLql2z1ITJAOUvesIIiH9fPoJXD6gYbmICljg5StaYk6S+zgp76U0KhukoP+x/bpiRkN0ymOFMVS0di1GeH3ZgQiv1tsISGjeyDmOD2HwGvPBxjKxpQWImKCEK/OXGG6QAPydorUNNv/Tdngu6iERrWu5zjZdWj9S+W1f/L5tz/Iab70WX9ULVMHnKPQGK+LRZMH+7rVtFwdU89BMk0S2NOLmJS0aOHOgj3KoEiRJ7PT7RcEjWUeqEjr2J1017l4SKw57SurnseDVLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiTWYycyDx8A5kBs5qprEkRZJkxJa4rHlB3TgQ+7k9E=;
 b=GeIX4C3bzDWTpRaKIoCkLOInecfaAffYl5HhMN8ZajBPqujMsB04Bl/TfM9JIDjD60GyFCyYmkpIecI9rg6GJh39enRj0+bIIBPwvU+5gweFllLDQAknykpZS+bW08PhWGoxtxBbZpXuZfktYLXVKwkfwbXbD/hg08jIMf5alKY=
Received: from CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:27c::13)
 by LOBP265MB8416.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:46e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Tue, 23 Dec
 2025 11:57:28 +0000
Received: from CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 ([fe80::a825:7b26:a82f:d041]) by CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 ([fe80::a825:7b26:a82f:d041%6]) with mapi id 15.20.9456.008; Tue, 23 Dec 2025
 11:57:28 +0000
Date: Tue, 23 Dec 2025 11:57:26 +0000
From: Gary Guo <gary@garyguo.net>
To: Kari Argillander <kari.argillander@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Dirk Behme <dirk.behme@de.bosch.com>,
 Alexandre Courbot <acourbot@nvidia.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: Simplify overflow check using
 checked_add()
Message-ID: <20251223115726.621bfa38.gary@garyguo.net>
In-Reply-To: <20251223-rust-page-check-v2-1-fba3dbdde1d8@gmail.com>
References: <20251223-rust-page-check-v2-1-fba3dbdde1d8@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0499.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::18) To CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:27c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CW1P265MB8877:EE_|LOBP265MB8416:EE_
X-MS-Office365-Filtering-Correlation-Id: b42e875f-198b-4d49-8641-08de421a7216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?35lH76q64Cqb5qy9YtfDkvJXlajL4qbm0VjOS2jrXaQkIddWuEv/m6MLA7rx?=
 =?us-ascii?Q?VDrnzloViTYexzHfOyXkOF0qw7FBCqps8adv0RIA046mVkdt72khIO2WmDws?=
 =?us-ascii?Q?xzWw9rGJzhKIpxn8dFBFdQpLtYEwYOZnlI0eCj5DRahYtmcv847kAeNYAjzE?=
 =?us-ascii?Q?fWiEpSIggwxz6MBH1AU5wCx8VgmBFKMNpMkG1kZHp7oJko1hAwETxeDWjRgw?=
 =?us-ascii?Q?CQPRGfr14hkdseDE5/1WMUAWlzezO6qt9ul+S749MdGEv04oUhUEBobu6NqH?=
 =?us-ascii?Q?KmIDGAmH+KsXicfXVWbkFmQlZNLXLaIS79nan9yIvWQEiivP+KJYyh21CM1I?=
 =?us-ascii?Q?UNIKSQLZtbAMg5cnKMYCTStEjodjOVBfos3qnxCGU0xugCnrtaEcAg93/Qug?=
 =?us-ascii?Q?zp6W0AwIEeiBMkR37WaZbq1l7IfUsrytiJgDUaMF4Wa5MHCSBChLR7rMDa3j?=
 =?us-ascii?Q?Ooyt2CFciUfB4mhKpqZWvf0lDkzoaFQOxCtfTPN84B1f4lBngN1PBhfIRP81?=
 =?us-ascii?Q?2QrppzNdw1zuoffLMGepdk0JGrhRyHerlvGk+sws48qTuncaKdTOuHF6igzK?=
 =?us-ascii?Q?1ga9nz9gsBOoUD2IEre4JO8K+s6dIlXjbAmBzmRWso6CPevGFX8TgD5ZAOsV?=
 =?us-ascii?Q?rMLU5iGOvQ09Mo0nqJ3wS5o+xzjPVUaYv5bWADafJClKjbEZ9q0WyZrfd1qR?=
 =?us-ascii?Q?NC6mwMpv31mbT9cFDA5UbM5mwyyY1D+m+x4IIQarSq/xRyTIVeVyeiHeuL+6?=
 =?us-ascii?Q?8S7WmoTPnuj5DPAbzdru806x9trC4wG5GRUafjybS0Y5abP7RNglPIoM94pI?=
 =?us-ascii?Q?b1c3sycsZa1ZbcRP+Xx1zJfP8ifMlrRgkgRTg9D/T23x+f4oweW6LXPYBBl7?=
 =?us-ascii?Q?YJK8T4a+w0zTLH376kHDcC8+xp0AKLPbB1iftiIs7KBukYA20rPn2SlP4izA?=
 =?us-ascii?Q?RuOicybhi2hD5mVWDThOJRUe75EiGkH8NxhuGPHlC1ao0ue95kSU9mzeXYxt?=
 =?us-ascii?Q?1h4XWnX+UKs988tqMJhlERSDdpy7jljuXmcSsSK0cMgUiUXGPdxGlxrv1gw8?=
 =?us-ascii?Q?X0omj4n5PteOOYxFKoXguqJNFQjeqZJafv+SWqrovhzxOvOQWVrLkiDixfrq?=
 =?us-ascii?Q?m6Mnizx/HP8romN3BXrhTCcShlk8ytbSJn7u2jTffw6n9xS18tdD/ActMvO0?=
 =?us-ascii?Q?KXBwVKYFyRwiAFtsBG8rfPvR3S1Ov0LvoSIwiwlA3Oo5LYMpfNKze+I44TZ1?=
 =?us-ascii?Q?0TgzL1K9csUhC0I8ZmKes2hf6NW8OzqqhQkkB9SpN6muT/T9odIFedTI/ice?=
 =?us-ascii?Q?Y62BGNbLwCn10gczF7G5661uospTYlD5iES1godpueNcPef3AVEGBCBVgEFm?=
 =?us-ascii?Q?XP2IpKnAqgpOnRUF5GqC1u1B1vrSZrocB78l9YYkYIt7uJKVzK0Uq/t9lUS1?=
 =?us-ascii?Q?3zOU+BxVzBl1SauwE1uFddOmTL0SYvY4K7L12nXjh1wgEfoUwALwJg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(7416014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+litAeNgOJ0FYFV5d2M6Nc95++KhKfHtrk7h/C6eSdzOoDLut28y0eqRvp5T?=
 =?us-ascii?Q?U45hGCn+aMPSv12tU37Bly3LZroeSmHWt6aSVJ8ys6LnqDQb4+cFNUtWk3m2?=
 =?us-ascii?Q?23cKzZYOUom2De10dhPJVTULDQY9rBBY9fSX/6mPMs6HijaNnQFzZsYQsotI?=
 =?us-ascii?Q?QEL8cq13YVrpZIF6nJLBPjIyTou2nVqrHRJxQIIUCKQkIaHq9856xOrqTUVz?=
 =?us-ascii?Q?h68raIkGzZHsm+4D+0+ladEVbJ/Qio/MJnVxtLb6kC7MeCsZG51Ns7alphRg?=
 =?us-ascii?Q?lHFixI6uihr8d1IyDA+cenUL2Z6xWuFRAl8WZyXRWe7Swux5JXp9YUn/5Nfh?=
 =?us-ascii?Q?ObTbfN9FNcbeqqYVkTLaH9az3+ewwxG/b8YkMm+/PFs7WuXdapwSnj98ZSpP?=
 =?us-ascii?Q?p9EoshVH237+0Gudw2yVSrR9nBwxj0/gYniWz1WHP0syuq0OKvHtxpSJiZlb?=
 =?us-ascii?Q?0fSi+FQuDm9SUfhse4kw6QNlN2f/hQbzCsITMd1X+ufL9ZE6O26fl6bLQaFm?=
 =?us-ascii?Q?VOpvFAd1HCzj1bzDf5xM6w9lOTUEA7jcYLosohsAV5vaLWfXKDKVvcjRC4L6?=
 =?us-ascii?Q?Abv3dPJTNlUmcGcVk0R3PDbbtR5f9pobyZGvhH3MMqjErveow1BLEOtPcTIq?=
 =?us-ascii?Q?P3FCifCzVyiupnv4GF4n4wxAZ9dOE7359w4LDHW6piHxrN48AgMtMY2zCHZr?=
 =?us-ascii?Q?sTXthyTaBJPEwHfv3sioDsxjdhl8GFKO9pjgXAHVSgEIFRJPET18KdAcnsi5?=
 =?us-ascii?Q?pIAqaIcrMUhuPNMYVO4VMYS7qNOJMQoaJ5vte13DLgl/G2Nzwk9Ul//kaC5q?=
 =?us-ascii?Q?QKnd2qg7fT3KO8W1EWuXw3ITIw4k0CSMyJwKSUAi6rwfI27SRsYI75Ui0mmZ?=
 =?us-ascii?Q?a2bb4qLRpTti6v8zIkp/U4w4wapLbZ0MhNixbJIO+S27dhiV6fghxQW4Cui4?=
 =?us-ascii?Q?+Mgdg1/XeEGmnHKPV8dQilkZGF8hkbII4uCVlPX80OMr0HgVt1FQnPzgAFym?=
 =?us-ascii?Q?h7ppbn2XZHV0uMeAISbbIWD81IASeutLXh9TvAL5TLNWN0aVO1RqOepQooQX?=
 =?us-ascii?Q?VvNwMmvzgVxIrXyXjzEWt2SGi2fqhRq/M52zJiPzSl7C8Y+AOhY9QAoXO6bh?=
 =?us-ascii?Q?lT2XJE1v9+1hdO5FzpPjAMnZTONJKE2GZgnuhfWK7I80GO3m9MK3/wO7lWX2?=
 =?us-ascii?Q?job7vu2DBu4NkrO5WfcHsdKfCf9weDn1K9Tl55e/faQKV6lhtxA965WhvtNZ?=
 =?us-ascii?Q?IAW0J7mS96ua4+d2mb1DPoeGtXYwwKQJRa/7BQUiQC2BQXq+bxtaEIvn3KqH?=
 =?us-ascii?Q?k7MvHIXF9/zSuSiev0gPkMenDMLh2vUBp1EwLTVnlveRjzSH5jzBYN+NacQJ?=
 =?us-ascii?Q?vE5yXBG96xKEsrE86cSyhDkrKQrDvAZAj+BancUBEoZVAyMAuLGW2gfnUjzp?=
 =?us-ascii?Q?IKqQHacSJXqI0KaTe+oSKDs8/upDBVhENwv52OGaYMc2QQrxmolIScm9p9/v?=
 =?us-ascii?Q?smPabxtLqE2+bdoYNlXff9b8oUup6sVsMV/keRFiqDseuj2Yn0kwPD1sK8Gt?=
 =?us-ascii?Q?OEyChFThYEWE5MMVNh/DajCjBFHgUhQ8X9jKCwq27chsLCA/4M7XJoXZLbCb?=
 =?us-ascii?Q?JCn7oEimprlvaZOkbbfSd5v0nMnb7OchJsFioWPpPuuT1UUWZMJXfX6lcKqp?=
 =?us-ascii?Q?tN2vVwV4mniuNDFhr2yqB1RfSPEBySBnaTUbwFOY8NYHxkZnEpx4FknUVYrA?=
 =?us-ascii?Q?yGc4GZvF5g=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: b42e875f-198b-4d49-8641-08de421a7216
X-MS-Exchange-CrossTenant-AuthSource: CW1P265MB8877.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 11:57:28.4937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mp3tTzFSzLFyl3udiYKXqrXOd+2yJmOurxSKUnsW1nKvb8mBUuJL/CdqLyJ93npkhmSlP6a3VqwLIMpB7cTkvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOBP265MB8416
X-Stat-Signature: ay31xbyoen8tio7dykwah8nihg1b45ze
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C9D540002
X-Rspam-User: 
X-HE-Tag: 1766491052-666092
X-HE-Meta: U2FsdGVkX1+ded2LcISU4ynhilzUYiz6S8kYw6zPdQiDwh/BGtTqIx0aKFSXVNCwI01h8QD2BfiHeNf2C4EkLqFz2Fcxi2gDiZyRbvzMgK2mrDSSDHol/3AaigOyzGFzDk/pD2PVpRpsFpRL5kQklmF6C+Q3axYj1BX0sbZ7dCoBNUe/AA3JSRIxXLJEX+QdEu541/XMHn8GsTjyS3BcT88cGLHkf7wdqcI+sj8/l1ECaHjv6L2ZSzoLGNtrTrwZNfpao9j+vI8/51XvrDqt/nTIeshEPn/6KZ153iACoeNLdt3oj68VajItlR35pfKOjCNtqtWW8N6jfX/n0gYITVLjCatF9NdFx6dulYHe37Qum1iCdqsfxGCpmBYPLsybn6gjMd9M68nXWZ006dSUCCxCowfPyBIs2WVs9iF/dr7uPmahPc6qvpHNj9mTlt68fGaQHrccIZXv9qDXovrigouDAOGuubyxTzY5kv4xUBFrtrE5RFSj04c34TunwHdt9cqtEYl6BsTOfWGxsGQQEvvbuu5pFlcEQIRZAmPzquVCaTcUEULmDN37DphX0S8omBZmpqDttFqHCc3sYSmXSH2Esp1DrwDimpp4tCmLJuNTnXwSH4nixNZV0yG+BtTiXtD0/lpbQG76q4YFAuKuD6oCcd1BhWFgHTsyHen74Dcp7hH+byQZfFfpSL0qq/0zP+FMwAz2QkNi9BTHZqaMTfLdu6rGpjlR1BuA1aZfCSa94jkOLijQJCtTpoMK2nNnMOKG9Ox+IhREacPmzKz+5bLVU8/172XOro2m98qcMOz7Tmbcf1QUMIn+BKm/6SiTp/yWx/MBso3ibYw95dM7S+AdGvQ1HAurCKq2Y0ZvjDf7HFO15ZyCHF4VfQD5AruM2G6ib6JMRvVZLdx+bvf/V8nT0HAVLHrgF213CV2Wez15KNUQUS1SojGuym4DIDrN6n7EZRvuBoIKv7SNXet
 90iS6ZGX
 8dx5fSVLIrKcXARIxHFHURGvtn2uCHaL9EGde8+2fmGSl2NNgABRJJ9cPltFaprgvnWTNXCIdIjtSy+nnHMruRDslJyTn2+hm5PFI6wqJQ35++/Jy0B0x0ITA8NbXXzHeLTHM8n6XGwwahhIL0I3bGJbsk7sdY11qSoP3XKE4bRUdR8i3zq70lJc+HmvkuQin8Xxpr9Hd3NwqmTMPdr5+uNAD78Lp22xlnm/I/zZw37OXFNdxAHEkH1KYQQ6iX2LEG3+F0bQWfuXiKILDVy/9FG1wjlP+0HU+FdgDI3bRe/1lt2SRd+PFMx+2KpRWVdpFlgXchr1QguvKJYRGGBEhrihK2AxQ0SwflQtqCCk7caVI3wMRRLARWY0qezy4Pj3U3sC/hPriCn+ZqaHzqJ2+TsDEGSnoCzSYDUvsKYV3ppivvD9vSrQLQlActR3km35GSYaWoYbI4xIBw310t/glLKMZ9Ny13CNz7MDeaQTM+dl3I1bgg0lRE9/a0oQYkRwUEyHP/8fK7WN3Hl5OT+AaPbcSTLeonPeCZTOFFSajnXbAlM1WJU6TpaohXp9ZmG2FOfE7OgZv5QPAMkHZa/sRsNC3/LafZST+MD9rI2zJS44moqHDfZjUrpFPwwsXQpXeBJZ+jgmNtg2SuxI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 12:06:17 +0200
Kari Argillander <kari.argillander@gmail.com> wrote:

> Replace the explicit bounds comparisons with a single checked_add()-based
> range check. This avoids redundant comparisons, makes the overflow case
> explicit, and results in simpler generated code (checked with godbolt
> for x86).
> 
> No functional change intended.
> 
> Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
> ---
> Changes in v2:
> - Added MSVR todo (Dirk Behme)
> - Link to v1: https://lore.kernel.org/r/20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com
> ---
>  rust/kernel/page.rs | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 432fc0297d4a..cd2af7e4c357 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -239,17 +239,16 @@ fn with_pointer_into_page<T>(
>          len: usize,
>          f: impl FnOnce(*mut u8) -> Result<T>,
>      ) -> Result<T> {
> -        let bounds_ok = off <= PAGE_SIZE && len <= PAGE_SIZE && (off + len) <= PAGE_SIZE;
> -
> -        if bounds_ok {
> -            self.with_page_mapped(move |page_addr| {
> -                // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
> -                // result in a pointer that is in bounds or one off the end of the page.
> -                f(unsafe { page_addr.add(off) })
> -            })
> -        } else {
> -            Err(EINVAL)
> +        // TODO: Replace `map_or` with `is_none_or` once the MSRV is >= 1.82.

I was about to suggest just enable the feature gate, but turns out it was
only added in 1.81. That's a fast one to stabilize!

Reviewed-by: Gary Guo <gary@garyguo.net>

Best,
Gary

> +        if off.checked_add(len).map_or(true, |end| end > PAGE_SIZE) {
> +            return Err(EINVAL);
>          }
> +
> +        self.with_page_mapped(move |page_addr| {
> +            // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
> +            // result in a pointer that is in bounds or one off the end of the page.
> +            f(unsafe { page_addr.add(off) })
> +        })
>      }
>  
>      /// Maps the page and reads from it into the given buffer.
> 
> ---
> base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
> change-id: 20251219-rust-page-check-819ccc39c53a
> 
> Best regards,


