Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F298D61037
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 16:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226FC6B0005; Sat, 31 Jan 2026 11:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4106B0088; Sat, 31 Jan 2026 11:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6026B008A; Sat, 31 Jan 2026 11:43:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB5C56B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 11:43:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 763108B9A3
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 16:43:41 +0000 (UTC)
X-FDA: 84392830242.25.D4C3562
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66A6240007
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 16:43:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BYq4A/ip";
	spf=pass (imf04.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769877819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ttju5LlL5zdhb37KHUj0FM7pbym9mVVA43AsH5WDWBY=;
	b=27ZKbSCdQJ0SOKsCcI7piHeght92fwkuXbgSDUTBDgKC/L9Yg8KZiHBiNNrABN+lzSXtE5
	uCyl5O4784BPleou0sMj51/jWMod0WBSQoWhAs/ob1uiZ47eKyDGsnykYrqQPKXS+C6upV
	Xm14JqigcJ17tpCbFM8pUmi/ojBG41Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BYq4A/ip";
	spf=pass (imf04.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769877819; a=rsa-sha256;
	cv=none;
	b=k3drG5Iueuz1pxHDdvbzvhwS7Kc26Sk8XghAFEEwl03zcO9pKG9PmD9TbCiA0cIfu+CHye
	hGEKsneOou9YMHeIqeCwqiJJsZ9TUQ9JcSQ9pjwGahrCL+DabFajMdEIbFi/3pZWpfzL/h
	9kCkL/Zq+ckkGMrWcbXUvKvxFAXAuMk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44AFA444E2;
	Sat, 31 Jan 2026 16:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF55C4CEF1;
	Sat, 31 Jan 2026 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769877818;
	bh=3KsRMh2lSbZ0pMfa0RXuQSsgQEmLwpq0wiIfPG6cAFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BYq4A/ipaHf3dHpGjF0pF8iKcg5Kb6tWnuXulr75Yw55DTt54QEG3BYJRELJzgRtQ
	 Q2Iq8DK0oxTQiSktzhFIjJQ4gvu8k9iukFR61/Pna9On67EmC/omIPKsV7ZefvEhG3
	 UiQdc9twdYo7qqF4PyAfA5hHYp4ixPo2rS5twS6aUkKJB59Zi5j8mb8eO5f7LqilQv
	 n9mchh9on7iaP53F7zLvlfA6qllEJZ4tPI9yAHnQH+OufoY0CoIw7LJomL06Y25fgj
	 hJxnAPsvImekF4ULkLPQJJfH0tMUomBFj/Vv3Qj5g9AANMa3PvXMydXRWLCX3Qgqgi
	 L9u8F7+TM1hZA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id AAD7DF4007C;
	Sat, 31 Jan 2026 11:43:36 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 31 Jan 2026 11:43:36 -0500
X-ME-Sender: <xms:ODF-aS7fLp9NqI9O5kEN0lfRG7QIsLOhkxLUnsrrMnQ_GFZFj0Ntbw>
    <xme:ODF-aWRvFQ0S4Ea3xsokT4IlwaTtax6R7pzqH-61-_JdnBGysy8yb15Wm_O8T5O9h
    urpQYZfQWocDgbMOmqIEtABBk9stYUQy-2f6Wx4ASseAR_mkBt42q0>
X-ME-Received: <xmr:ODF-aXnlKunrZGPDNbW4hjgTNTb8gys5uWdLWnyF1nkK7niCzK-98H3KefKC0bmqDb-nSCitfB23nvuBVqJLc9a0Kkmw5hmq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujedvgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprgdr
    hhhinhgusghorhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehgrghrhiesghgrrh
    ihghhuohdrnhgvthdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtgho
    mhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
    dprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghp
    thhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghoqhhunhdrfh
    gvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghjohhrnhefpghghhesphhrohht
    ohhnmhgrihhlrdgtohhmpdhrtghpthhtoheplhhoshhsihhnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:ODF-aaSOYWbSj1OGZNm8fCIwn_BzmjJQy6VZN1JiqEKA7yjdpQ1OjQ>
    <xmx:ODF-aesYDIkwIhBDCvQGTzXwB6WHvc1LjqkCtq03GaCG3ZZPnMXbLg>
    <xmx:ODF-aT4x2C7uyY6Q6KW-H83nL9pi049yDYzzyzBULueZRmWP1nuC2g>
    <xmx:ODF-aZgbVrivNY_fJzfSmtB1XX8K2Bw5Ij6dQIzdlNX4VSifTTe3vg>
    <xmx:ODF-aVkfJnCYYZ5erED0jlnT85y7jEy9KTaZe5Vh_9aG89YWQq75d-kc>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Jan 2026 11:43:36 -0500 (EST)
Date: Sat, 31 Jan 2026 08:43:35 -0800
From: Boqun Feng <boqun@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
Message-ID: <aX4xNxsF5Qs0CTPW@tardis.local>
References: <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <-5tKAwUVrj6fo337a8NWsHQBepB07jKIVI-VafwW1zp0vsGTCkBTuI5nCBniftYJePZy8kb7bhWptJ2Gc_B-kQ==@protonmail.internalid>
 <aX0lcVngRcRwqgd5@tardis.local>
 <87pl6prkc6.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pl6prkc6.fsf@t14s.mail-host-address-is-not-set>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66A6240007
X-Stat-Signature: gy73wyq1osfibmj3h3bf71jedhq1fg36
X-Rspam-User: 
X-HE-Tag: 1769877819-320294
X-HE-Meta: U2FsdGVkX18541duyQal5VIIBTv2Urz4cN8VLkaoXTgz+kRli8Sg2KXqFGN3y5efIZDS5nlkZbry7OlfuwKDyAwmMS+W7dpqU3Z6TVXzk+W22HegLQm8QNXd3qSCLksESxUibcDreMZQJ8qy/W9KPOz7PSekDS9O7y4hEMi4D0b8BdyPT6emhPNun6IEOWvx/67tkqShRgx3r/YwIbIFtlakGpu+KCVY3c4tFnwOp/lNlh5Smu9obxftuRKpUEMWKJ5ACWmJwicEjfsTTJF9UkDQjeYR6rfWe+2F/Wxj7kPSKQyRZv7garvraDpWn4lCrE04IfW2dDthoelbLKaKr61wtqwrEIKuJVWjKumG/rgD3mS3OXilM5UUWo8EVPy9kfSYT/Nl5Q3hfFXiTYRssqVwm9XY9eIP1Wl+rwM3vUboyoZE+34pIOLFbuB8qQPCH41tFvWvHtZ9JDI6Lp52lGnfNywLuNDsqXRHCMNgnkINumIa137iqjk3LiJRaa8D8mGCLqBptSGDoPiMkQrClzZWA+8HOshpMA1IFzTDmf2E+qqtLDguRzDe3G93GxFGU0V1+yYm8Ntrhp9I4JFsoCQPLVrYSXA3CyNBBX3nYBbpmMQR0pftejJrd0F96uuzSkcHhgyj1gRnwhCi+22sTruKLdVd0JBHhofKLO6gwtRmXeEInCv6FrQHA0pEWXG1TanJuy4BVpWcKCXvoffSBuj9bL6qnKGg4KMJ4lhJRLULOUj1owuu+oumyo/ZlRoU4/8uoenDVyZ5MvwdbgolL98zRFi+QCrJ/tcYmX//L3sGcDSU0doy0DdxV4z3BdlCEGdRVRYslW+BcbAna0r2YgNIjhZAZdB0AsqQMau8fvsxPMzzYhbhcZSve14cMnRK0qXMDbVvzruGouUm6TV3I3Xs9xumKdCP0awRwrG9wEPRit/d9bX0dXzu1ynRVvGcsRyy0FtuVsnomzf2tlC
 TuaqtRjF
 MLb+cdB2qDDduOJ6+cneF+0BUxlVSI8q0Tn6SUxbJQfWM3I/1X71c6qv8AL7dTJPsttcKHdIGeC9CSMpL1rO64X8waceX1XCGd6ktpaoEr4h71GSFGtJ9zbEwT+FpFA8tMVVBgzhIfypos7Mt9FGaVEvLZ1QED6Aqe+L+QhMsz8rdFchX+NS9xF6ktVUDblRh5ICHSWt95H67yOitgXYxDcHhXdR7d4/lYCcsUNAUyzOL3qor+Jk7qGL+4jJjcAdQHI7gI4icoR6In9IuKB0KSpuKuv/Y3L658Q0CcZuT/n8JQxGP+VvtGsyQ8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 02:19:05PM +0100, Andreas Hindborg wrote:
[..]
> >
> > However, byte-wise atomic memcpy will be more defined without paying any
> > extra penalty.
> 
> Could you explain the additional penalty of `core::ptr::read_volatile`
> vs `kernel::sync::atomic::Atomic::load` with  relaxed ordering?
> 

I don't understand your question, so allow me to explain what I meant:
for the sake of discussion, let's assume we have both

	fn volatile_copy_memory(src: *mut u8, dst: *mut u8, count: usize)

and

	fn volatile_byte_wise_atomic_copy_memory(<same signature>, ordering: Ordering)

implemented. What I meant was to the best of my knowledge, when ordering
= Relaxed, these two would generate the exact same code because all the
architectures that I'm aware of have byte wise atomicity in the
load/store instructions. And compared to volatile_copy_memory(),
volatile_byte_wise_atomic_copy_memory() can bear the race with another
volatile_byte_wise_atomic_copy_memory() or any other atomic access
(meaning that's not a UB). So I'd prefer using that if we have it.

Regards,
Boqun

> 
> Best regards,
> Andreas Hindborg
> 
> 

