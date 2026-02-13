Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB1CEDF173
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1CB6B0005; Fri, 13 Feb 2026 10:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24FC46B0088; Fri, 13 Feb 2026 10:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131AA6B008A; Fri, 13 Feb 2026 10:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 001C46B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:45:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4997D160515
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:45:26 +0000 (UTC)
X-FDA: 84439857852.09.432AA53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 35E284000F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:45:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l3MM4zxv;
	spf=pass (imf11.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770997524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGmKZWNtIS9ERU6bcSUv7HtDJWFDT/GuOYhCFfjMzp4=;
	b=1a+0ksXrq8bI0xzsTTXhdgd2l8cMhAr8N1s0YzSMTz3v2C1hyF7AmNrygjt1wvAId4+kwo
	isR2TyCQl9hRf/J3OBvc1StmqQkv2+pIgpUBUKJ+qM8XhiHOxClt787aZsxb7Kci/9FlTH
	B9pLsW9xX1iu6oMrnlehq4bmddBzsw0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l3MM4zxv;
	spf=pass (imf11.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770997524; a=rsa-sha256;
	cv=none;
	b=ZFHIVvrTkbpzV3kVp24fcCmbtTzknIsr6bhRUMh5jZAjmmi2wOcg3grgRGoTPaFV2UUyyD
	L8xtH0G+tATvcnLynRisz4MFzH7bX+R3ArxLvsb0MXPY5eYMMtGQvX1RRqxadITPrc3QzB
	tgbaOkQMqF7Cxmhati/BKkDpVOJ/ioY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A7226132E;
	Fri, 13 Feb 2026 15:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E770C4AF09;
	Fri, 13 Feb 2026 15:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997522;
	bh=fuTx15yFTxhe4W7/BhW2RKNzR0Hi3SfXJnorfKREQ2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l3MM4zxv0MiTo2wKJ2i2NRNGrE/BCDraT1jV4ykLKDU2yJSucCYFxF6c4xQ9DCb1V
	 jWw2yPJVNWXwq1VZt1cNEm3IWoDS6EMBApo6cHQ8EljV7u10ScG1bh7yN+MfQ8fVIA
	 iuHzWSQEYmn16Ey+cf9n7xypHJkH0945tOC7ly5HsI6CUM2AkLtVYTnA6oWfuWxoq9
	 WJhs7XOOEzfXN4XlaFzlFk7m6K6DpzdHiFRVAg17QJas4qo7gM8ql7VbJ14H/v61Qj
	 9WEfbADg16d7YeRQGDWTUvoEBQqgjCuAvNHKSbUVRR9iTf5UrjCa+gWG4CoCHGYFUr
	 4tgaERAk0YbWg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5574DF4006D;
	Fri, 13 Feb 2026 10:45:21 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 13 Feb 2026 10:45:21 -0500
X-ME-Sender: <xms:EUePaY1KvQ4JLY5gmtQg1EFdqHnBHLkmQYx7y3_8kUKOrpTGSKIX3Q>
    <xme:EUePaUcDqrn25Lg23j85d7w_pP-YFObnZfkYF8EQ7E9ZJGar87fSdQtWuYpzsHZnk
    5pR4KacO0pUX9BAJbuZ_EHtS9GgKX5cI3f8Af_OcTfoo33WXARPtw>
X-ME-Received: <xmr:EUePaaLuf__dT1BHzdPzOOyox4eFyAfCLlQKHk9bNpQSrF8b2aMWaxckBcaLfzr2_hSDlGBf8BlIWN4TX9jmezgDgA3sLp2J>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ehkeeijeeggeehkeehtddthfdtgfejueefleeutdefjeegvefhhffgueeiteekfeenucff
    ohhmrghinhepohhpvghnqdhsthgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhs
    ohhnrghlihhthidqudeijedtleekgeejuddqudejjeekheehhedvqdgsohhquhhnpeepkh
    gvrhhnvghlrdhorhhgsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepudelpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopehpvghtvghriiesihhnfhhrrgguvggrugdr
    ohhrghdprhgtphhtthhopegrrdhhihhnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhho
    rhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirg
    hmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehojhgvuggrsehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegsohhquhhnrdhfvghnghesghhmrghilhdrtg
    homhdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvth
X-ME-Proxy: <xmx:EUePaaHdLDclBdO7klwUFy4R70iYRyeIP9AuXIesLeN_ms_q7n3hZg>
    <xmx:EUePaR4NS9Ho_VOpJ8PS4cUlKTMXu2gAQMdhWoflzs2772DQbG9Sng>
    <xmx:EUePaV3nSLss3CIbLXyVt7nG4EVheKzWDlVNjpv1zKHejqFUN4vWNQ>
    <xmx:EUePadhik9-Jbu1xdhvU6wB-_-xh9zACzcPooyk-2qDENPCpbGoMEQ>
    <xmx:EUePaRReZTDK5S5mHAWUiURtVaqRz8LnbwcwJmEJHM-Mdt8E7LSYVPFa>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 10:45:20 -0500 (EST)
Date: Fri, 13 Feb 2026 07:45:19 -0800
From: Boqun Feng <boqun@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <aY9HD7nH5A-DtgmR@tardis.local>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026021311-shorten-veal-532c@gregkh>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35E284000F
X-Stat-Signature: pu4o4ojpxajt3z1jnuk3uodsw81k76y5
X-Rspam-User: 
X-HE-Tag: 1770997524-457234
X-HE-Meta: U2FsdGVkX19+69dgQy+s/OFg6y15o3mcBjQ6dkxP9vzSn9qgqL3ZdveYr30UKmdiJj9gpTRLj/d/K/somA/RyIyvHiUqaV/Z216nOtasrEQ9wLe5E8S9TIkmR4lQVwF3JTlkqG8kqHPuLmIoCMH5nsYr3DxterMxHvKI8OTg0RkhNexj4Mf6HIQJM0gMWFVE1/PkAE2XXGGCGu1/6HzufkLm5NpHjYLsH0ueFRaFsB/mN6dSAC9DJ28wJRGLFQ9whLx99y4goNd6HiuUPCwP7fZmxGu8VziFjlDoxUVfWRTbFeJ9EXOJQQI3UIxYiy5xUKDD4FJOwFj/Zgi+dmEQDcl0H2km8afohoCCi9h2lEECV9YCNW29K1Tk7fk1vx0E8Wd3PENAEC5tMIo6Yr4mFXla5gmh0pBuAvRxUQz28Dq93FMn7vQH5LvT4Gem9Ghde/GcdMEgQ6+Dlo7QHO5jiDDgOdTbFjnXc1T1qTfJNnBAU6/bY7iF11QMTp8NZHjUiWAxxtClHXqfduSt89nrMKZytv89XqJl3rQY3v8Sk2FFCmdQVSno26cEAXabBXllipVFVr7UOWHNHAbbLQdePOOo3JbSNQVyZQ2wLS6l7N3GpzYmmEah2VEhEnv2/bNhxgy86zRZcQiF1kxI3i0q2g2pDy2yzWMupJnPTiiORVlmeWqS5Yd8vFFfnPCZNgG9ANcPhJ4XuA4v44qFgxRPAI5rmHegAXJMDhgfhJ0Ga9fMFq7CLlJNE6iD78j+JrWrpab+FbAymI8AVfXmoQKLzNnw9z/zdMEBCclzySaDdcs1k/q0kgtawGUUHXZqxT5UuEDx7yz1CiaU1F7uukFTFK3DYmFrlSjeC6aoUewb7/YhZoUEPGhkkTQDehj+P5ZDXnMWfO70bWLaiXpzLPtWEjvCJWaOpKoPMRShGphVtgFDKh+XDGjOUhJH5cmMV7BP7QpGP4MNxfhdOak+AI6
 d3Vrc6Cy
 wdgFbGsUlBnewZxpaGoIEX9Ry3Vm2NGrLdlINpk63lWgwsN6cAk1w2i7T4m62uBSTgYZZm0Is7PO/HY7GvK4/gnSQNQIcaFZCzB6Y+O7B7e5H5C9NaBeh6leDoVfn0g0+V+1DDItJL5CqvqUtODh6JLfgHnpQmJuXpWByAve2r5dJtLBiDhZsHZiKQbiPjWKG3qT/mOCFpnUcTDAeq324Cfg0rUGl34kqt047hDxjObCGeg6zSzuaeuqucr5Godx3xkdpCy1PQg3m49YJPwTwfZxLKv3MYQf2y4AKmcLdmyYdEeCnmWftmV+CN1kcf45DPh3t1sYp3G+4LEJyPkeqK61N/Bgr4gOOkw93LoZOfLy82GiKXYYQoYn/COAWqQA4h6hHFjs1B/sMRbV3SzTqB+ENAJqRlerTqXjL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 04:34:04PM +0100, Greg KH wrote:
> On Fri, Feb 13, 2026 at 03:26:08PM +0100, Peter Zijlstra wrote:
> > On Fri, Feb 13, 2026 at 03:13:01PM +0100, Andreas Hindborg wrote:
> > 
> > > C uses memcpy as seen in `bio_copy_data_iter` [1] and in the null_blk
> > > driver [2].
> > 
> > Right. And that is *fine*.
> > 

Yes, that's fine because memcpy() in C is volatile and per-byte atomic.

> > > Rust has `core::ptr::copy` and `core::ptr::copy_nonoverlapping`. I was
> > > informed these are not safe to use if source or destination may incur
> > > data races, and that we need an operation that is volatile or byte-wise
> > > atomic [3].
> > 
> > Safe how? It should just copy N bytes. Whatever it thinks those bytes
> > are.
> > 
> > Nothing can guard against concurrent modification. If there is, you get
> > to keep the pieces. Pretending anything else is delusional.
> > 
> > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > to be 'BBBB'. The resulting copy can be any combination of
> > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > 

The idea is if using Rust's own `core::ptr::copy()` or
`core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
not semantically guaranteed atomic per byte (i.e. tearing can happen at
bit level, because they are not designed for using in case of data
races, and there is no defined asm implementation of them, compilers can
do anything).

> > No byte wise volatile barrier using nonsense is going to make this any
> > better.

It's byte-wise atomic [1], which should be guaranteed using asm to
implement, hence at least at byte level, they are atomic (and volatile
in our case).

[1]: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p1478r5.html

> > 
> 
> I'm with Peter, just call memcpy() like the C code does, and you will be
> "fine" (with a note that "fine" better include checking the data really

We are. See v3, we actually use `memcpy()` for the copy (as I already
pointed out, Andreas made a mistake in this version), it's just
because it's per-byte atomic. What this "byte-wise atomic" does is
clearing things out.

Regards,
Boqun

> is what you think it is if you are going to do anything based on it and
> not just pass it off to the hardware.)
> 
> thanks,
> 
> greg k-h

