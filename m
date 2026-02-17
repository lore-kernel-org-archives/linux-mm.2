Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C908E68155
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C6F6B0005; Tue, 17 Feb 2026 05:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523FF6B0089; Tue, 17 Feb 2026 05:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FED6B008A; Tue, 17 Feb 2026 05:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5966B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:01:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C23EC8DAB6
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:28 +0000 (UTC)
X-FDA: 84453506256.18.E15BF11
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 80E8510000E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PSOuY7Cb;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771322487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDO90/Nbb5ATEcXTmAm7N3mdJ4ah9wS2hMPSN/20Z9g=;
	b=kgQ3OdhGSH/59MfUFLNeMijvyDJKNnaipNCYQM6kBdp1o4ORV6oi7BxCVyw9UaKcbaiUIX
	DdwNwo+W/HqPwSj8C9jMfcG1r4fIsN2SH9RVS0VOtxvKrEIKNtA91F+wUI70kx2ivqAoqc
	kf/PHeTJEthM1XXoHg9XCJkYyJTDlJA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PSOuY7Cb;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771322487; a=rsa-sha256;
	cv=none;
	b=EJtUAffAzFcqpu9Oj9k430sBl5YhmmUdbHI/Rh2qx+aHl4MI8WSMjzJe1d/hThsbhHYLmh
	yHEMlC8JnsRjN5T6EKxyRZ+g899HHZOB8CunUr3vdykRmAOFAut0fHJAN+6uFNwQ2IAhkB
	ygs96dsifIy9v+FPM/495ZTd5ulgVCM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aDO90/Nbb5ATEcXTmAm7N3mdJ4ah9wS2hMPSN/20Z9g=; b=PSOuY7CbUA5Uc9VIJZ9/xiAj78
	Z+3TeMtKfmeGKuwl29E89Lh4ClI3JkJBvEHzSFo87fc/O07kA30ufwucn+HpK1wUswiOlRRl+Ieyk
	QT95GJIiazRc7iL61eEiS87CiOVQjL0prJYaRoU4R+WZVf863eSw1HALJsgKSiM5kCLNchmNscpnC
	RhdKBtXVWZWjCb6KkDCIxefTetrU7L3pjuKOANynqK9HGZnxjgsoiQSMHUDIHtdRlbofKuuAFIFv8
	z8tSUC1PZOzWkCGwHQQrdMlg6OtygGHN988xQaW+5n06m01nFzDZxUCVnmMPErpxUOJs2yskXpyFt
	lmf+VXPw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsHtR-00000004FxK-2Xwz;
	Tue, 17 Feb 2026 10:01:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1A271300CDE; Tue, 17 Feb 2026 11:01:21 +0100 (CET)
Date: Tue, 17 Feb 2026 11:01:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
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
Message-ID: <20260217100121.GW1395266@noisy.programming.kicks-ass.net>
References: <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <20260217091723.GU1395266@noisy.programming.kicks-ass.net>
 <20260217092343.GN1395416@noisy.programming.kicks-ass.net>
 <aZQ26gDRdeTpmLRI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZQ26gDRdeTpmLRI@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 80E8510000E
X-Rspamd-Server: rspam07
X-Stat-Signature: zgwcj8ebw8zoho66bhoiwb7rxq7m8srp
X-HE-Tag: 1771322486-326941
X-HE-Meta: U2FsdGVkX183JfP1iK9fI8j8asCn1f8IgUxUm3nO/deR6H3G0STF8lj0aSuURkUTTQ00lX+EhE0K3SEymivqEdObLc6H/KP8EPNz9aK8CLtVw2u4OyajlLwLh+2KMackT+A2LZdVbs7JYS6Py1l2XbUVYfx95LeOelJuy9fgzGDO2rn5oagLxfpTasgx2dMYb19sSv3gMGMD3UP/xy0+nsWAMJfccXYsaJ9pjsfyvmiBRR0E23VYx/ChWmqhaz3Wji19OuYDXtlwSxH6W2Pqnbl4FlaATwl0B9pItGnq/L6iKFo2F3Kcy5zSlP6WK7mghbHIA4I6pKc+ARKB8keLPBa3JW0HB9E6XhiDh+4hu3DE84fB+9cbhEJbdXGI6H0g2II4+9Hr9b5bssz6xmQjxE0s1ekxWYtHkXV6jNNP8b8MQ5h/eIb1DNVnJbHUir46jHLPrUhYrZGp6vV/f7UtxLOAm4fsHmVG1pXYr1khlXd9v9Jrn0Fpnnggdaec/SZFzgvViCnY2RC4v00bBkW2cbtQbRzkHF8Omqvff7XJ9QXcelkhNJ4cvP68izCdotSDWZJ6Fp5OBBtHrS7GheS8TmLMthbqaF7GMX7omtvKRrZBHVNXY5VtQSdUMEm8AP01cmvfBIhTEK6AxKkfJuG/kv3iDzGSbeAo7a2VHhdWpTDYkXh0H1phKCbHGF/OKu3FHhBFn0Z6BBL+yZbocgDnx3jyhbT/AuNCgEY3Lhf61OV8U3qt+aBtdB7Ksn1LYugVnrlKey5znA/fTLUMaj7NkxML6f9STnZKmddAtiDeGce45xLgS223zEabzX6qubDfNDBNDUXPp2JHDjrBTApz3Tq3mh8G/0MyH+GpcwLYokJS9fVi5vzKpFAA4kieopWOpsPEnnnb5kTeHFHxjUpLZqQihN2YJonE6J9s3DjXywx9u/ifenM5G7VhQvquSNSlHGu8oIRIaheewA3WWHt
 OLICwHNJ
 qGMyVCS6LFwXbwkRstqAB2VE2aaGE79+f4V4n847NCxuyMnBeZ/1Zir4iQTgoNUWR9Cu2ZYPCmTU22hM+vaTA1NWmj+YrmEYg6JTIJ91/1wKsTHnkXquvLHviFTIueMQFFbWlVWpddZjXfJfNcKWl0nt1DG8SCXZ7TH/B5sQHhv5TOGJTZO61D0oFEFVjHsPTE1Qds8EmADjPG0JnLkVWAN3wjMNg7jUlBgGbelXflUuWIzvGCOavDVCrMNg8/csHsCdM7VTvyvBsXlqcau4VPueiPjGTWH+pT47S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 09:37:46AM +0000, Alice Ryhl wrote:
> On Tue, Feb 17, 2026 at 10:23:43AM +0100, Peter Zijlstra wrote:
> > On Tue, Feb 17, 2026 at 10:17:23AM +0100, Peter Zijlstra wrote:
> > > On Fri, Feb 13, 2026 at 07:45:19AM -0800, Boqun Feng wrote:
> > > 
> > > > > > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > > > > > to be 'BBBB'. The resulting copy can be any combination of
> > > > > > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > > > > > 
> > > > 
> > > > The idea is if using Rust's own `core::ptr::copy()` or
> > > > `core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
> > > > not semantically guaranteed atomic per byte (i.e. tearing can happen at
> > > > bit level, because they are not designed for using in case of data
> > > > races, and there is no defined asm implementation of them, compilers can
> > > > do anything).
> > > 
> > > How the heck would they do out-of-thin-air? Any memcpy() implementation
> > > that can cause that is insane and broken.
> > > 
> > > Compilers are broken crap if they do this.
> > 
> > If rust core code can cause this, I stand by my earlier position that we
> > should not want that anywhere near the kernel. There is a reason our C
> > code is free standing.
> > 
> > So fix Rust to not be broken or take it out.
> 
> It can cause this to exactly the same extent as C can, and that's why
> you all came up with READ_ONCE() and similar.

So READ_ONCE() was mostly about inhibiting the compiler from re-loading
the value. We later added the no-tearing thing.

> Rust's copy_nonoverlapping() might not call memcpy() if it's a small
> fixed amount of bytes. E.g. a copy_nonoverlapping() of 8 bytes might
> just emit a movq instruction or any other way the compiler can come up
> with to copy 8 bytes. Like C compilers, that includes emitting more than
> one read, for the same reasons as why C might emit multiple reads for a
> single read when READ_ONCE() is not used.
> 
> After all, this logic all comes from LLVM which clang and rustc share.

Right, compiler is allowed to write code instead of emit memcpy() call.
But that code had better not be silly.

And since the C thing isn't silly, why would the Rust thing be silly?

