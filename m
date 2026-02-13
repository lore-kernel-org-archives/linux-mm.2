Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC644EDF176
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082F16B0005; Fri, 13 Feb 2026 10:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030946B0088; Fri, 13 Feb 2026 10:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EBD6B008A; Fri, 13 Feb 2026 10:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D58A26B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:59:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C6FA14058A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:59:00 +0000 (UTC)
X-FDA: 84439892040.23.0B456B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2150180009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:58:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=nuGspXNl;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770998338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXT6Mv4L6tiF9gW9oDexcj7b6fZxeqz8KBU0TMRcCYo=;
	b=oqeObc8EjJSxbh3XpWaCQWY7WG/9oTAW0nG8mxZi/dDSUH64vHW0AkJIIPy9f/2ttXOtvY
	rt2LPl2zhlRGYtyjdTGTPnOUxauMJB91hC/V0z0ZFoLNrUWHAGEEiK+e2D8CR7I1SKuHY0
	2NIhW0sV7/JAj/btiSpcip3qjA75FSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770998338; a=rsa-sha256;
	cv=none;
	b=jVK2WfN30/c3w24/xdWjBleEhg/4bMdzW1z2dhdEl+2ZjAkJwg4FqUb+SOdfXI0M5MLJPf
	RGtAJwY1t6aN3wkJB4tNi34iYIsX8dxyqugZT6i8ZKmMUg9MQsrbq3cZbGMkrzbaWpVN/e
	MIXUsjiFve2rBS0ucHTzLZHyqPQy8jM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=nuGspXNl;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0798B6001A;
	Fri, 13 Feb 2026 15:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3083BC116C6;
	Fri, 13 Feb 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770998337;
	bh=rS3uQKruYn5xMp4W6xkGEzUFoQUuS95ZgMsB6z8EJJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nuGspXNl5QtW1RDbpCeV70r18D2R/Qpb2j7Y3E7STlPudOv5+oFQOBRcCGScX5srb
	 s+q3hxoEaHoMcRWndgCot9AH71ybpaQ1cm2oqu5U+FBn0nH2sEA0vNBxjOlRHIJ291
	 JBoBETTmxdN4ZSgDVJcusWztbxBAcoqODP09IUgI=
Date: Fri, 13 Feb 2026 16:58:54 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Boqun Feng <boqun@kernel.org>
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
Message-ID: <2026021326-stark-coastline-c5bc@gregkh>
References: <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY9HD7nH5A-DtgmR@tardis.local>
X-Rspamd-Queue-Id: B2150180009
X-Stat-Signature: wbcq589arhunyk75j5dzf757f1z8bxsf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770998338-156359
X-HE-Meta: U2FsdGVkX1/g++/HrTyOwf2ohhpSj8/Qpn9mHAthp2Hc//CWv0jJdjI2m6vRIo4kvsNPWQtIafcUyIi+K/X0PtgG+URerWEHEvwivcgHiWpaQvwjLNUGYq0AuL0i4/bbJYfYJiT4BOxWQEzfgqVgQC4Mna7Cz11g/kcac3bJEqJGfdPBwN57TvFs3AkfHFcq04zgRlqwyW04EtboA3prcilA+D0A2kMBvPKix8hT6HFn95qcDX7KEpOed+T+6wBpsJ5OIyRVQNhGPC0jp+V78KfnyRj4AXl1ro22VQV5fnPZCoFznHAJRAMzZUGlRT7zvxPBzkR8R4YOle94x/RjKBiX2WdQVHv1rUQcQNLuAzWFCt07jYvhX8PukU24IGZ5uT3axadsDG9RawuW4+J/5yK7PLhKSblNSuXjC5/25iZfC4ioPOG7EAtJl34yYgBTmyegy91+L8BgxymJCWmZOkICtJF0ibpEdlVsu031NikqeWo+6x0T1XKyY8TI6stzbh5tcMXhm47K4kO/IGgYSt8nVlho9/5tLgHa30ysCYgLKTZC86QKYXMR83Ujl/GrvowNEC7enasEd6jvA+GxiR5k/whLqbh9fRXq8MIvLahuMLGMA7siR2BhSyXcy/TwpONlxV/Q9OUYfFFO5wHvajlVFX3bnSHqRvl6cARm/ID2o5vx8i7g2x6TCKUEnmWHb6Wh1Qcxpe8698H3+oKHeXpTZ7/80Z1hsib72RDKHokYP28zIC6GGP4axKGUlpPsUcRXo1JGrrFmsY4oQDDGrx0xt1k68FGx2e/wudzomo81jvmm+BRv+0065sXoipeQV8JvWrY7hxZ0bvMXdpClL20pEd81csCjNQWYQa/ZEJnRgNnnRgjwD4HiZV9gaj+wHSayuHuyCQYCXkIwjRexZf35DuWZSmi0gI5AOS3HHQL3Hnnb4M1NP9AKKfk8cT+Z162EWsYnmoYCRemGgKU
 WKLsvBey
 BcUMy1aV1NATAaWOrhX1ELsEoc16P9yi9Jopq/qqGmDtde8zk+THuBq2YHU62GsTq0iKbY3Mcmcd5DPAQI79xw46A/Gzxnlr8k707v+IVzRdMepbb21eUi/Q6bhw51eMYkXFAyB8s3gawNXYy8++Q+T/R27fjwgaqPOILwCr4HB4aU0saWGh9RKsHNXL/Ov2KibPylZXN5xZKTH44p/oj4rfNF2N++4cA1f/7yEi4ncvkYFH/Is4mxBe+EYo2dMh47k+/uzHA3vy/7wJZ5By2pr26ACEdreymPN6pV/+UwPeWk3n9k1/K79RAv6AtUQgbMdyBPVvF+NMGYVvFa/PGt5BEpMDliQQ8SASl6/7GlTwPslpxzEDQwb01vfYiVMbBBQU8cv1FQ6de7bSL+UWPWx+FZk53qMtYc/oLQXQTuwFR1t79+JMitAI803GtyqIOWkM63LLGs8FN6vjNZAF0NmndQ1u4PKD/Rivwv05/kGHP/jsDVjS0GXteNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 07:45:19AM -0800, Boqun Feng wrote:
> On Fri, Feb 13, 2026 at 04:34:04PM +0100, Greg KH wrote:
> > On Fri, Feb 13, 2026 at 03:26:08PM +0100, Peter Zijlstra wrote:
> > > On Fri, Feb 13, 2026 at 03:13:01PM +0100, Andreas Hindborg wrote:
> > > 
> > > > C uses memcpy as seen in `bio_copy_data_iter` [1] and in the null_blk
> > > > driver [2].
> > > 
> > > Right. And that is *fine*.
> > > 
> 
> Yes, that's fine because memcpy() in C is volatile and per-byte atomic.
> 
> > > > Rust has `core::ptr::copy` and `core::ptr::copy_nonoverlapping`. I was
> > > > informed these are not safe to use if source or destination may incur
> > > > data races, and that we need an operation that is volatile or byte-wise
> > > > atomic [3].
> > > 
> > > Safe how? It should just copy N bytes. Whatever it thinks those bytes
> > > are.
> > > 
> > > Nothing can guard against concurrent modification. If there is, you get
> > > to keep the pieces. Pretending anything else is delusional.
> > > 
> > > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > > to be 'BBBB'. The resulting copy can be any combination of
> > > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > > 
> 
> The idea is if using Rust's own `core::ptr::copy()` or
> `core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
> not semantically guaranteed atomic per byte (i.e. tearing can happen at
> bit level, because they are not designed for using in case of data
> races, and there is no defined asm implementation of them, compilers can
> do anything).

Then why not just call the proper, in-kernel, arch specific, patched and
tested to the end-of-the-earth, memcpy()?

> > > No byte wise volatile barrier using nonsense is going to make this any
> > > better.
> 
> It's byte-wise atomic [1], which should be guaranteed using asm to
> implement, hence at least at byte level, they are atomic (and volatile
> in our case).
> 
> [1]: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p1478r5.html

Again, just use memcpy() please.

> > > 
> > 
> > I'm with Peter, just call memcpy() like the C code does, and you will be
> > "fine" (with a note that "fine" better include checking the data really
> 
> We are. See v3, we actually use `memcpy()` for the copy (as I already
> pointed out, Andreas made a mistake in this version), it's just
> because it's per-byte atomic. What this "byte-wise atomic" does is
> clearing things out.

clear what out?  It shouldn't need anything special for a memcpy.

thanks,

greg k-h

