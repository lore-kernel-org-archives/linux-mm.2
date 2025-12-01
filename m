Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953AED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 16:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEF56B000C; Mon,  1 Dec 2025 11:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF396B000E; Mon,  1 Dec 2025 11:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FE56B0010; Mon,  1 Dec 2025 11:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFC936B000C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:01:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26597131A1E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:01:37 +0000 (UTC)
X-FDA: 84171367434.25.DB044DE
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021124.outbound.protection.outlook.com [52.101.95.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B6E880029
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:01:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=CR91mVdp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.124 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764604894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+Xh0NjmWd6LoBGtG7p8ix71BjVu1+hkOimissFZr6Y=;
	b=XoD+vW3qp0F/VBxrc26RrPJU/csR4yry6Jsx8/Dk+DuxvKH6Dc0gcw4gj4nG1GWYswLMjt
	pvgYrdXOH2WuhBI8DkL+6NJazNtTZZra0I7u77WI8L2ehf6bPm6gug/kJewzaRa+zrCGh8
	vYlhTYg+xa05eCNsRcMPW+Vi2Xg23DU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764604894; a=rsa-sha256;
	cv=pass;
	b=EkQYkb6hPJKYtcHKSYAqkWkx+uBmAobicj7r9vesk2l6GWYRarVa+F0OXifnhMbrKosDZh
	kvKKgqBGuaQuLHjjb4WEYrq/7ljWYgqPC1KyemUCtgCkFrSuUPSHLPMZ8SXQCisMR0w+Qt
	2ZofSAm9i/1JItrBqN1XESK8ytEAMyo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=CR91mVdp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.124 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tk239u5kUrnEgGX2LGGbhTSTo1thYlO9L5EdRf4vaSm574At2jnV2EkyBrBmhJ70uCtAseZgrKQV6r3ulUIToobPzvX6g5QK8wOA76LD5rb90H3A4M2JX4mQlZZtsPH0D8EM+mjYUkXoV35bUZxh1P7uHaqiWcpUstYRxX2zdFMJUmUd9hX/iXhU+9+6H7QydZ5OVIcvVTRgCuW+2yERz5VZ6a455qdlw0dyjsWjo7nPHAc6Enbrt8oHJDYLNKv4xG7AENATS2MwuqT6b084XcNbiTNJdE7dBA3WetEQ3SHwjQux5mi9qXuKl2ubb2dPO4B/AfWZcD1jBSLtJlrYhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+Xh0NjmWd6LoBGtG7p8ix71BjVu1+hkOimissFZr6Y=;
 b=h3uSNG2IWofQRUlUMOJcbQ1IUDgTa3UxepyCnOeO0zphNKvMkkTPwfulq1fR5kuSm2Fvq5wHeYRw7LJxKJPNqaw9n/6ijqk2KC13vmswqd38X8SIzTs9QAICzFZa1VEzpkmkiagQUbrW/W32hG+x65DoBr8fc2qYG7a0JXcZcBk/vYFn4+yqJvkz8a1gEXxUuapyakWH/ehM3N7J02RhZSlDJARlS4z2KFjcIYbBS3PhT8DEtmtdc66rsIcmuh6KGynMUF/gkTFRdqphwAlKBznpJpSZFW1JGeoHq7a9VzYfDmyWtYn2nWhE4vMtrtOvl3Dx96EtTD3PpkVBy2xwug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+Xh0NjmWd6LoBGtG7p8ix71BjVu1+hkOimissFZr6Y=;
 b=CR91mVdplPYLhvVnbqad7cfe2QefkefEqhlU+S9vQfw7FbxkmrYfOaWnxIIuNbBgDRJsnQUXWxfdaCUxxe6qoluuJp/No0Yn1KcFWYLc+E7MCSfgSK2a8Ik+ONtA+4rST/Px02XO8ZjMwHYulN5a+QilffOjuW98TMHOIR3ZCU8=
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO2P265MB2990.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:178::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 16:01:30 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 16:01:30 +0000
Date: Mon, 1 Dec 2025 16:00:30 +0000
From: Gary Guo <gary@garyguo.net>
To: Oliver Mangold <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, =?UTF-8?B?QmrDtnJu?= Roy Baron
 <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin
 <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira
 Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth
 Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?=
 <kwilczynski@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn
 <sergeh@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v13 2/4] rust: `AlwaysRefCounted` is renamed to
 `RefCounted`.
Message-ID: <20251201160030.6956a834.gary@garyguo.net>
In-Reply-To: <20251117-unique-ref-v13-2-b5b243df1250@pm.me>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
	<20251117-unique-ref-v13-2-b5b243df1250@pm.me>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0377.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::29) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO2P265MB2990:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e51919-53af-4fc6-0ee7-08de30f2e3ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dQS4zknpLWJ8bvw2F0czGUuMXLjr5FTeTK72rr9fe21KqE7FkAfcqHqUl6J8?=
 =?us-ascii?Q?ppMsjEVYuQIFG9PjCF7N9sZNQxQESKue3T2ZM7w3P6zYUaqLpBz6onwUkid2?=
 =?us-ascii?Q?J0G9BRHtv3kKfzoZGBKhGRj09HVM5L1HHfMUdEY4ZyolxljXuxObaDObeOHD?=
 =?us-ascii?Q?bqV0ZnOwN3GndVad54Qsw6KvzozYBhAK0+e01qrRwcAVa9vmpY8RlHEBygEz?=
 =?us-ascii?Q?JlMqBK8W5/FizFS5QRfgJ544dNYK/ojFp7fRgN0eINDnoBlgqFAZ9Rdmy/nz?=
 =?us-ascii?Q?tZpFANsK57/0dLoqzgfCbk6h6wApqCwx4ZAO6iUKJAumnCE6i0Ujb6/p6V1w?=
 =?us-ascii?Q?yOiI2MszoqtWkfIHwOKD41HC1HcmjWjE+laEzFhUNHlYgHSTuBCYq8U6LWNb?=
 =?us-ascii?Q?Gvedu3sI3Z3/W19pRsPXxKjQLrK04wknG5IeYk7Piinzf8HLn9aNvnNkJLEW?=
 =?us-ascii?Q?U2xihCg68npxeWtSEg8bfqffFtibGdM2eNuPbkBhwBgLpQOZ6qTDDspflXvR?=
 =?us-ascii?Q?B9pZaX5PLUyGdSMIxW/wi2lvh1J642qDX9G5QZlZBw/bkNP04u3/XEpFiFJV?=
 =?us-ascii?Q?QGstGMOn/wnhCYwpKCc5b47dbD2ZkhwQXAaElWO2dpQN9aURXsPzNs42rdiB?=
 =?us-ascii?Q?Pfwb7xmDwgNPxWm8xLemkIPeo3RelxOfC5cvov5QsfQYOTSV1Me9O65P6aTP?=
 =?us-ascii?Q?6ybS3dVedl8M19mlc7zsmAP49JnIXHYQc6XdeR1j9z0UaEDEuwIi42XQt+qU?=
 =?us-ascii?Q?h+9leDZoFYyb+pc+N4W/ries9ukdZtp+KsFPnG2+DpN2kf8KBLqcdP8Hoc/K?=
 =?us-ascii?Q?vI4wCU4Rr17PPxthqVyUeI1nYQQoDFPeD4Blno+5cFCM+668uPystxvmOfmT?=
 =?us-ascii?Q?O97PJ8ayn9WaGYWuSgSorTDYl770Hc7htjvrRbIb5fROaOji8e9GQhyz5N8q?=
 =?us-ascii?Q?/6zf1qfIBxgEj8iTjBoCO3WKC4curHzZENEMQKiPh7xVyeyokeKxQJmJEOAp?=
 =?us-ascii?Q?K/KEpa+WFDn9r2/3wKnnytFjh8FrfJxo2a03g0tD5r92X33AnTMKQYxyedCo?=
 =?us-ascii?Q?/Y+CFYVGqAjuAYbFbimMUeV/iEQThU/FLmdShNS2lf1jSQEese6hDMX7PpSM?=
 =?us-ascii?Q?bW6zK/+ehlyFhG3OY8FCGN+w+jgpgUDXzc/0EQ+6qSNP910WroACPgSRW38E?=
 =?us-ascii?Q?1O8AxWkPPLSDDE/uQYA4YzSLvvw6PvlqTlMAsCRJWOWzcF/vXisYVfoh9IkN?=
 =?us-ascii?Q?K2erMLHVYOzfaHykpMX7VQCgAPEIpnZvDju46/A/im41th6p5Bj4fiTvzF07?=
 =?us-ascii?Q?I1eXeYIoSewjqM9scc3UTWMeZ/gHMzrMim9xz/LyUHzD3hzJjVEyZtzSv9pl?=
 =?us-ascii?Q?mFmCHq+GyMDX5mpWWq5UHYqm2zUerycwr2F6bqkPOX6z3YpHu29ubMUcZiWy?=
 =?us-ascii?Q?ZcdHq8gnyGYSuJJxvzektrCIOuM/BDrN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BeIkBVgVFmyYBSY0ouJA59JWpsYsOhhsOVti14eUmwLpEw88qfiP0a8/3ZUy?=
 =?us-ascii?Q?0dcwHRySrmrCYszC7SLadViLVMo0nw64ZvDZoKoQfqnlw16kHbi+PRt7j8E1?=
 =?us-ascii?Q?XGHVE09a5L8lOlX1kBjnXhnVyuJLtjQDi9HYuCpjotd2P03AeByx5PAineg3?=
 =?us-ascii?Q?8S5HG+5C4hDFlW48pULFalk0mRf2e6kcJs9gqRva0BlXgyY20CkrobGDHGDc?=
 =?us-ascii?Q?PmbLjFA+96FxQVXy8jzfi2/RlBhAls8MCQPpZhr0FFZ2KeKgc+evqwLXPhP1?=
 =?us-ascii?Q?C/D6TU3I6P8lB0e/FvCwhYp4HwOWDQfz6DPNX/NTD7bXwGSyFhY8bCqR4jVs?=
 =?us-ascii?Q?S+0HicXHKU/xpVP0G3rQsunNndGfaSipGCQhWvZ6H9fnHVKYuwSKtbJWsXWV?=
 =?us-ascii?Q?mz4jGnYo0I1mEI7TXXnUiqAbZrI7we8yK/kV5dqiu0feR0owr40Y9T5m49xK?=
 =?us-ascii?Q?NUId0MWrrtNdm/jW4jCqk46aIFEjwwoOKmBlp7QpsYQGbe8mY/MTKcLqV2OU?=
 =?us-ascii?Q?pvJTY2ekxfjGYE6JSIDxUC4knP3c9NgseXGMADPhypB1hf462cf/wzSoAsN9?=
 =?us-ascii?Q?dHPziajcoyJeMctkpwrXQjDkiBSedGUz9VJH84L8q3mIxEPaAbOAlWi0p2UV?=
 =?us-ascii?Q?82Vn4o17WXgDUS+qAKu3m91ltYs2WZOtz1UKEzwk0dud0CrvIAPkarUm3Yw0?=
 =?us-ascii?Q?CdnDZtLThu1tESE4Y6nntkfwrHlf+apxzPj7Sa6E8OJkVOqtNzZsO/kt9U+p?=
 =?us-ascii?Q?WOOwXgxH1c5xjsph1dpK3OvUUpVMea6oEgkrsYiBQ2UVhfhGW+bdOrQ8NLtO?=
 =?us-ascii?Q?JamCPPfBLe3NASLDf7Xn+vpbJHOgO9PmGnxirnyDOCAchQ4YCfTAGmSV1vnz?=
 =?us-ascii?Q?qNC19r9jCtNNNNwq6gaXqrLStkqu2eiIXrFELCah6mAcue0umo4ud4cfs9Ku?=
 =?us-ascii?Q?OTbALvJXFkm+L+Ulq1dDbcouBrHGV17mpmY7IE3erB7CfImfheR8oX+e2IdI?=
 =?us-ascii?Q?M74xAL3JJ1X/O1EyhVgQRKeLbZQBEoSCWE63s+H29GjWRrRmZiuRmHt30iMC?=
 =?us-ascii?Q?s+HgyNHtl9wQpOmr5kok/l+DkABfKlwCPxZJ2sBojMKmY8clABXhYtPqHmyW?=
 =?us-ascii?Q?4sJtgNHli1VvWV9hBoaEkDd6C73qRdL045LN0ROMr7MiUEwMNZz8+IE03gpF?=
 =?us-ascii?Q?3tRfuBzZzo0wRaq5+8LQHMZEmgsAqSclGUl2d1J4O9ICuWqXsYEFBhChlvTe?=
 =?us-ascii?Q?Y8OugfOagC4tnFrpYNaqsn22NOn/RcBU2zvYOTsN8TjiC9IyBbYeQtpdn+n5?=
 =?us-ascii?Q?DQjp5iGC0+J0syPleFIGjANPyNbQonIjwM30flLlM/nXl1sDIgSEX66szVx3?=
 =?us-ascii?Q?+Rq0zNUcQ1y17gNMJDhdmzsBUdrb3M0vZOBxfmtAKGqa4CHFRt5NdzZEHhuo?=
 =?us-ascii?Q?E2IQIILOPUkgr2GXyVU+YogdeNzE2w8W6wVbLuSR4IPcEqpoBJgrZG32D6zd?=
 =?us-ascii?Q?DJDih6WnJIOeMtq/3GuH6/9RvyjwR1LAJPMV5hpIFsqDVj6OzXZnKl+mVhWS?=
 =?us-ascii?Q?cevr0r1y6lZPTVRMXoU1R/5CnVSZ31kkjICO4a4I0GPxtWNXpS4hC7BZbpOz?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e51919-53af-4fc6-0ee7-08de30f2e3ff
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 16:01:29.9920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSBYlATzlV0k8QEuECqafBYn5mtP2v+zqpTk5UNMbi/XIC3rBwrLDIl+trrx/+WBoVu3zRtye6HWBCKlvan8CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB2990
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B6E880029
X-Stat-Signature: fdk6kme91mmr75675zutky9oq4nxx1qw
X-HE-Tag: 1764604893-810543
X-HE-Meta: U2FsdGVkX1/6cHfEC72FUKKuP5rjriuuk2sDEUzsIcMVr+d+3lZDciskpyPZrOoKpOkcW6RbKPKsm7DS49da7dM5cWgsBi34PF0K63Y5PsLHek3lODjr83Go2XS4fGLS8Z2CxwdjmftU3X4n1/kVzGhs2R/g+yoCEq6cNx3FmZU26kgrRys8RFVauTN8OlqE5ialDvAebL2KDfKFgYnsumceohSpMimjs413fM//veefs6SD8CUZy+PkWfIKXMhGt2pokL7P1++v36zn4bmjbpgLdfNHERoLjshC2A3Xui2a190wi+czw8qUzSZ04x1JHQOdvGyTgg/94myjJCZdEuVQXO7InF3dGNxWZIx8beeNCc4spHb70Z553lCOro3PUqGcjZDuDnhDCJzA5WesKK5YE37y42k2wm3Mw/LpLU9QIrL4Vc7ljaEfsqWDJrX6ieye0f7dgYmKa4K8JDh0Dyjb4AISx94/EK/gLtnvN0eLgH4th/VJ61mlAsdJqRphVWK8PzWDjMSOtpLeCaMPNNao5tY5Wm2ERMhHjpmgZ19CYiQ2FXqfIzl76zo1XEw8y++cBJrteBKbVhnbVFDtw3VVio6K+DfYKvwOhg/wkRsuT9AfE8jCiwrtUula+J5UJjqYjrsS7rNYEXzJ/1CAqSwoN2rd1HoK3WgpSK7CxmGVN/gjT2DXuLx5xQWmQ/xjLB3sjR8SnfoFPLjOdlw3NkAqa4JYcZomoiKp8QFbdnCtWGKWTWeqXjj61Vlp4LMPDWlXnZkaiuwSnwACn9T8smAlpyMOZrQJ1R+spzKsvMa/zg4GhGMyiXEAnYeVh4eNOyoZAUd+VxyeoDdpGtM/pJq6DjaMA8BrmlMEv75zhfIS9lmSiT+Ee3JidzlJZDptBpWEivyAR5XsPcB+4TK9xo0/ZCj1Uw3BSeIF5TJMSfGKCF56C7Y/VCatJQgD5/Y8AkT0djBfeEbHlAbDrJB
 hxxKvm06
 aXHnMGW+c7rbS0sdd4ihTnmnvLbZ4T5bT6SXR6WpUBhulSDJFT2V3TT3hz7ytwgesquxR5txImjvrtnKN+BbnImlQ5cpbljHjAD+dCNNEdNsRIh/Rv5v0BctBd9N2MyWAIioRrkOJ/TZ8hq9M2Cv6cTYJbbjLhMIZS3DvA8IGt5If3eIGiMarAgNLCeCycF4u4vPlVudbxdDdJ0GCJsRCSNg2hffh2QfloznW1YN2jFET4XHNITGELGycwWi8BEGmk0R9y41vmlr1Hfk6b0mC1B3z8pM4umZY/S8iOM/PngtmdyFbDhl4H9xWt0FpcfiqNj0Bid9i5QGEVyiLDnbnLDWGQlrxtRhuwtCfKw5k/acAgGOSL5vohVl01FvqniQsTvRwFZSbJN01Sxik38P7WhtmZ6Mc4oZ0SSDZsWfkUIxcqLgwdIGlFs5iVTZh26VnKHR4nah6CKqSkSUj7IsFPnIUpHE/JXKzqWFidlDHTbdSJzsHa8HZDpsbX+SOM7pbKS26ssvUt1ZZXXHu9qYIft5axtRx6OIZplhj85F+me4CrcONxiO+GOd+/A3YQZ/i5Io1BmX5n3WIGxM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 10:07:57 +0000
Oliver Mangold <oliver.mangold@pm.me> wrote:

> `AlwaysRefCounted` will become a marker trait to indicate that it is
> allowed to obtain an `ARef<T>` from a `&T`, which cannot be allowed for
> types which are also Ownable.

The message needs a rationale for making the change rather than relying
on the reader to deduce so.

For example:

	There are types where it may both be referenced counted in some
	cases and owned in other. In such cases, obtaining `ARef<T>`
	from `&T` would be unsound as it allows creation of `ARef<T>`
	copy from `&Owned<T>`.

	Therefore, we split `AlwaysRefCounted` into `RefCounted` (which
	`ARef<T>` would require) and a marker trait to indicate that
	the type is always reference counted (and not `Ownable`) so the
	`&T` -> `ARef<T>` conversion is possible.

Best,
Gary

> 
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/auxiliary.rs        |  7 +++++-
>  rust/kernel/block/mq/request.rs | 15 +++++++------
>  rust/kernel/cred.rs             | 13 ++++++++++--
>  rust/kernel/device.rs           | 13 ++++++++----
>  rust/kernel/device/property.rs  |  7 +++++-
>  rust/kernel/drm/device.rs       | 10 ++++++---
>  rust/kernel/drm/gem/mod.rs      | 10 ++++++---
>  rust/kernel/fs/file.rs          | 16 ++++++++++----
>  rust/kernel/mm.rs               | 15 +++++++++----
>  rust/kernel/mm/mmput_async.rs   |  9 ++++++--
>  rust/kernel/opp.rs              | 10 ++++++---
>  rust/kernel/owned.rs            |  2 +-
>  rust/kernel/pci.rs              | 10 ++++++---
>  rust/kernel/pid_namespace.rs    | 12 +++++++++--
>  rust/kernel/platform.rs         |  7 +++++-
>  rust/kernel/sync/aref.rs        | 47 ++++++++++++++++++++++++++---------------
>  rust/kernel/task.rs             | 10 ++++++---
>  rust/kernel/types.rs            |  2 +-
>  18 files changed, 154 insertions(+), 61 deletions(-)

