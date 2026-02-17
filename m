Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B1AE68151
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FA16B0005; Tue, 17 Feb 2026 04:37:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617246B0089; Tue, 17 Feb 2026 04:37:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CA96B008A; Tue, 17 Feb 2026 04:37:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F68A6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:37:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79BED140150
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:37:51 +0000 (UTC)
X-FDA: 84453446742.28.1BC0897
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B26E80016
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:37:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lmJidZlQ;
	spf=pass (imf30.hostedemail.com: domain of 36zaUaQkKCPwepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=36zaUaQkKCPwepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771321069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDpmvLwb82PE3bqd5qS4FeiDIo1F2mrGhUa/vVUAn98=;
	b=Q2kYA198gI5DzWHJ/29mzcLqYYIW1ghr0aoHCWCF7o1HAGNNTh2cGY06CBYKTFSirUTB1F
	aOOnIF91SLmMcD5KbbhRcMquEUGk6c1yPOvs42T7flb1ZXG4nobMTBjZJXboXEan2pEvL9
	Zp/10LO5Hv7h6FXzauFzz3/hJdWTgiM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lmJidZlQ;
	spf=pass (imf30.hostedemail.com: domain of 36zaUaQkKCPwepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=36zaUaQkKCPwepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771321069; a=rsa-sha256;
	cv=none;
	b=URxHtrCQ7Ih8PyXixVoQ7SYzKB5PgitTb+OjpueHE5AbBuMn3jwBRqzSz17DEW/mfKY570
	e4snXt6vWWqnFXlHHy0jaZ/Ra8R22+GrPmKb5MfArB13GnNaU8v54dUGG/vbrdX8QIs0t+
	BYDpBxD0B0laM+N0To3NYUV7XkEt1NU=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b885979bfa9so337732266b.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 01:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771321068; x=1771925868; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VDpmvLwb82PE3bqd5qS4FeiDIo1F2mrGhUa/vVUAn98=;
        b=lmJidZlQmwJy4DcVlF4vKymL/00wUDUx8ZnX5gteiiSsk2gWxo/IPtHa36tEBeycbu
         iTt6paoBgdTp8fCK7ZOBc9Yn1rd6tr9hDaStjpezy2l/xLk8pFiqjvs+HXmUjNnQJCit
         UlLXTykhQn/87k7gaJdU6V63nzYwIV8NRsOllwjjxL8AxHHLGv3WM1hiesU97PWC5u8C
         GaaRob7kbT685cScJUepZvqnOSI6ClLrJTgsI7Fb0Bb2cxRmUdoLBQ80h33d6tEYAB/e
         8DlPnmTTbwTbC/Azqzg4rrDXU0sCEjwRL1xCoQIzyHNsuRTADSEPADBLzSLHox+ZnQnD
         JITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771321068; x=1771925868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDpmvLwb82PE3bqd5qS4FeiDIo1F2mrGhUa/vVUAn98=;
        b=DVyi5RhjhZqQGjRBFNvyvLCV4cs0sbfcRshky1dW/CgECVKgA3EAqSZPRu3J26KiE4
         8tubIXoEVYOOhgw4nZ215IVTmjZV1vLZkmJaRJjFo5cCO9FA8wX1VGZCi9jc0kkhNyjU
         g9wZIz8JaQy8b+jVDXFcHdPhmxkbdo16wQj60hxhqdP8Fn5Ik4ilrIdelLYQb2qsvNK6
         QcPrnms8HHpx58mhaE4Qr9bwiNN2K4CeC22XSLV/uDm2vUhiLpcGwhJLqxTSPMBEEeAT
         EvLDddgbFMZ4JVTiDCEsUovcNKJDXoQ3nEqw68h9nUDx6rSq5oR7evCFopxsVlvjHEv4
         QxKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ8z1W/yYoaVYgzZJHAxZFmiiOW7apVraHw8rt7AxqGAaAyAn+4SD6qq7zmj2+F6hgFQLbvw8xUQ==@kvack.org
X-Gm-Message-State: AOJu0YwCzeX49qDQCmJnFA9igZwcMQp0Kdhyd5x4f/tLeql/Q95nuQ1m
	SvSPsQ95GTRFI4sm00pEL8mGcTx5jWeu+btEeb3iBoMeEjad/QEuUNmrKDsv1nrCUg5mvifd2NX
	0xrSHV/MQl2MCOonE+A==
X-Received: from ejbfw19.prod.google.com ([2002:a17:906:c953:b0:b8e:fadf:2a18])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9808:b0:b8f:79bc:b0e4 with SMTP id a640c23a62f3a-b8fb452e6bbmr730399066b.53.1771321067874;
 Tue, 17 Feb 2026 01:37:47 -0800 (PST)
Date: Tue, 17 Feb 2026 09:37:46 +0000
In-Reply-To: <20260217092343.GN1395416@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <2026021343-germicide-baritone-efe8@gregkh> <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh> <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh> <aY9HD7nH5A-DtgmR@tardis.local>
 <20260217091723.GU1395266@noisy.programming.kicks-ass.net> <20260217092343.GN1395416@noisy.programming.kicks-ass.net>
Message-ID: <aZQ26gDRdeTpmLRI@google.com>
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: kb3qz837i7smnx9ueq3ygyejwysgj9wd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B26E80016
X-HE-Tag: 1771321069-134028
X-HE-Meta: U2FsdGVkX18ynKvjB7PaYY3Ki9m9hJ21rFBkrC0gUCSqG+uspZ/LaY5AHcs6V/JkHMo6OTE7Kvap+m9vzf/zPnEv4kR1S5N/0/FwrKi0WVr2ZbIPssPHAfrKL9Xni1kv3lRoMY3usDd57SiDNiypRQ36LSAx0WLiqAqRRk0fYYTTBq6G9IYYrfPbdEM8jXchl5Rv00gdCMohVK81KTpmN7ovf8aARuUg4BCxQKYt0PZWDgOkfKnjIAwfNknPDJbT9k4sY2Y+H88rSTJ4mmYydL/CgsUMy9hfM2Qi8BxsbrLAFYyXtfefD38s6i9AwqO2VuZNPm9pWCBEx9bcDypNBLVPoHrK7WQXePo3cXaiEvoq8sgHeY19hM4bxgTKCU9SmeZPRPhb3WTT6IGFag2m1UhlZX5C9cPhacgXk69LeRIEI9XDuKCC9IAVevLsRgBScycR22tr8DLPMxr2/hgPhUM0gL2slNBEWgNIVi98oDmtxdzMnXI2Np+ykFw2ZcO9oSna3yB0CRW1gULoJtztlyA+XbcttiFDi218gli4SW0f0oY1Ao9Lj64c/tGYTqUaVWqWxpqJcwy9wWjuHTgcdo1zJrGoJ+ftROmlHVedSDeadYD+GNueD2sH9ZJ2YXZDnS/IidzjMoIwKD5YpHaQsWPdeBWGjYk+FgMPxVjIRYx8y485trJT5bDsN2KQYxgxysRbh79u9vb+r/cAKPcmbq2s6HXYYe2agPtY42Lxx7kbnABgoKZ90PiYi6mzOLzcYJrlI3Bogiv62mhbjPXhyZmfZHqY+XCuySnHxGUVvOot1L3cSGF0l7RijuvPegdmMJJf7bxScxIKz0nlHRIXr2qQhGpFJw4J7mWKLCMIb+GCRZVAxfWDp4U20qE8Lc+ob9AiO/3HfCOfeCB6ZN2dItkwrZoQWyp+4w9HO7rhI1UgOsvVsA0xdGK3SGk+3C4hYMZQmKEtCAvlL5++FrY
 F1H0Oqfj
 mowH6RG+XLfKm9/KKzCdLUyJu2wa6VFUAEK2KsVW6Z1H7KDX6MZ0rpm3PHd0tPz+1IHLUEixZ5IFrNFdnS7m6wHbFw6KTfGqhERUR2Yfn4OVhGeZUWO7dhXq9gtgVIZ2uoQmumFsHoLIwAbNT2aHnefxIpe6XftpFhXdwyr4zTvDu24Cndxm/aElGdudg7hINMun8lO23/IO+3HMRCrjBjQG/J0XaP1Kp9v6jWFpS7uJHDwP3gMDW8aBsQeKkE6iA6Ducxs0omSOcrHPyiMjYQdjyPWPCBnRZkDSsqbJ40SAEINd9fKNahCjzSD3puVDOutScHnu4DhthJU76WfsAbgdnjLZAMB/K6SeBzaCI7Nz8tx28APfYmb5eyNI/CPJCPidZQ7Y7ZpwvzckJbQzMiiEiKQbCNwbdDmiTalq0cs6YWhqTjb1HUlvzRWScUSDhkWrp6DXBNFfW7r+m3qzhFh5IJabxd4tmfBzUcLp2AIkXRjzUYLZKu6oS36cnx9K6nCeMUfFR/cJWXZSdVErnkPaRVuXS5S029D/bXucU0KgoBC5mpqtztiHMkIXYIQc5npX2l9OadThHQQ6PLCi5jw8uk9kzGFff0NfdT0qP7cft+EwN3DAsCl989mLpCt8VZ2o483qip+IYo7hgiax114IT38CrpsmEXwgOJz3bwybg6ao0JmUlaPeh8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:23:43AM +0100, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 10:17:23AM +0100, Peter Zijlstra wrote:
> > On Fri, Feb 13, 2026 at 07:45:19AM -0800, Boqun Feng wrote:
> > 
> > > > > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > > > > to be 'BBBB'. The resulting copy can be any combination of
> > > > > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > > > > 
> > > 
> > > The idea is if using Rust's own `core::ptr::copy()` or
> > > `core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
> > > not semantically guaranteed atomic per byte (i.e. tearing can happen at
> > > bit level, because they are not designed for using in case of data
> > > races, and there is no defined asm implementation of them, compilers can
> > > do anything).
> > 
> > How the heck would they do out-of-thin-air? Any memcpy() implementation
> > that can cause that is insane and broken.
> > 
> > Compilers are broken crap if they do this.
> 
> If rust core code can cause this, I stand by my earlier position that we
> should not want that anywhere near the kernel. There is a reason our C
> code is free standing.
> 
> So fix Rust to not be broken or take it out.

It can cause this to exactly the same extent as C can, and that's why
you all came up with READ_ONCE() and similar.

Rust's copy_nonoverlapping() might not call memcpy() if it's a small
fixed amount of bytes. E.g. a copy_nonoverlapping() of 8 bytes might
just emit a movq instruction or any other way the compiler can come up
with to copy 8 bytes. Like C compilers, that includes emitting more than
one read, for the same reasons as why C might emit multiple reads for a
single read when READ_ONCE() is not used.

After all, this logic all comes from LLVM which clang and rustc share.

Alice

