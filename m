Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54C8E68143
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 08:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A744B6B0005; Tue, 17 Feb 2026 03:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A5F6B0089; Tue, 17 Feb 2026 03:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949456B008A; Tue, 17 Feb 2026 03:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7BF6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 03:55:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E6945E200
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:55:51 +0000 (UTC)
X-FDA: 84453340902.21.7A29701
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 51C794000A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:55:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HKohuVAw;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771318549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2+3Zb5XQH5ae/EQUG7mNscXyFKybqQMMxQyoHn58Ik=;
	b=O5/meC+W3rNXGNA3rF1SDPzXCbfrYa6bohyo2kvAzWkJuh8en4SNYks+O97yxa3XOIvRCP
	vBYavX6xqRWY7NB8mvB9h2fEjXbLa+jZtr3+J6UllsYfzOmHqCKpDmyj0MijuYhIfC748q
	Mfitndtw7vJDTVEvtvMCzaFRVIuymAM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=HKohuVAw;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771318549; a=rsa-sha256;
	cv=none;
	b=qt8Wx+wH43L0oV4xfqbPowh5559kbbxGbKiuAyp1nYVocAyq62Ehz3qV0wZJKG9jnE83mP
	fidiUCnjrsF0zynPNHXiFybzlmloHTIE7AZKvBiEp8SuQZmN/7hbYDOSpyj2EB3OgBaZPc
	9oyFY97XJelUD08Vmj+8LnMT4IXwh8c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s2+3Zb5XQH5ae/EQUG7mNscXyFKybqQMMxQyoHn58Ik=; b=HKohuVAwwQEKJz7VTHhgEQD02z
	yDbz69X6P+iqHiN0CJ66dtLQ3ddF3XjqDOBd900Humu8XQN5rlR1hcyTeDl+ybdaIUEcG9LPrulZG
	Nds6OtqTXqXV1rTdF2cxQiQXKeFHaUg2Bjtlz7X7c5jphT5F9sHkJAG4lWLEZXY1LyEl/NQKMt1Aw
	uqS1hwO/l/1v7Op1TAKyumf1SuQEXPT6CCNEl2f7PlZC9hl/vW6B1bQDUW+dqIfO/nAotr2DZjtR4
	5eShrDtkjku9LtugQCs7gp3u5fQIodW4geQKK/ZNa3OvfBmRFUIaiRdTlLOua9N5ysHZCJB9iYADE
	2nkGqA/g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsGru-0000000FcUe-3wth;
	Tue, 17 Feb 2026 08:55:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BC83C300CDE; Tue, 17 Feb 2026 09:55:41 +0100 (CET)
Date: Tue, 17 Feb 2026 09:55:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
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
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217085541.GS1395266@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aY9i8rbvnxdOA9DV@tardis.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY9i8rbvnxdOA9DV@tardis.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: 51C794000A
X-Rspamd-Server: rspam07
X-Stat-Signature: guygnrtjrjo7jkiieww76ga7sochq3g7
X-HE-Tag: 1771318548-338805
X-HE-Meta: U2FsdGVkX1/O+lUSxlnas552qxk3fkTsYJWdFG4KV2Ng9MDck6dT+uPQGEqEyaFoSzSWcRK5Kt0+9kwqENKpTWDNJAAiqDq7V1CJdA4Y951Wb0TPYMPZj67IwnXKpH6bbyADmciara5lgOvsKERG9BwhlmzyKGsl1ddiAjFOgRGM9VZvYoWrb6r6xIrekDbabazw7oV2r3pZ4NsbmgXtjb+5fVV26Y3ddQtEb/FcgNAYbccjyzn9BlSCWtSmvsTAOo3Y9ieiFoRFAldiBu+8wuyDA/t2vU6SldubpulQdzQcrGT+6MYPDpaH8lonsaJ0ehB2rTTxxR6WvADvjc+gPmI0qR9s/Ep3pfpmAk7oQ7BcIxVc3Cc3oJKz/dm9qLQ+CpvtnHFq9NrLaE7nDWBTaA13cP7bdKQQLfwxBXlR+z3w0TuiwXXRxBWoGy0S8RPnrrbOZRihLc8BIeycyxKRp6cyM5afgfgH/q4P4eSgIf5PsyyepKljAmQYHyyL+K3z7MUWEIZWEkYHeWWKTM/xTDvqa64WyiEcnZSsBbBgcBsVqehe9VW1nnTzEAeAvoScuE0GhHj6IHN17b1RgyuwNKmazZ5se8S7eg8csFSWxiNmtHLeFwOewk6HAq2RTR+vkI8kqYdYIpqEjb61KhZSX/siCbSaGS3ZD4nh2Pgii5BmLEfRzMGuOCTILENUG+EZBAg0nB2youEXzcZhJO6+7RY9JoZ4vPTMK8B4iGHS6qHWuTfkgTAUY/K49RLmRo043+UmGVtZHYDBwxdDkOmnIliL8XF8NVlXtdg2vgDt9Xft4tS2x2JSYv/VvAJCgJvmhIm0G+MB2fo0N0xtKFk85n1uIpRTh3dMPZU8EhO5Etacg8/Of1zpQNtpUBNXtr9jPCuc+QlygBj1GR4ZCSnbdctc89Sp/hsx6C50q3Ik6KIkG7mNh5ai9wa2KC9BzHcR0F51lS/ML1Cya13tY/v
 hLwQIkVR
 1uCoFL16YbliQXgQad7w8Wu+RvVlfAMLaD70w+HgZ7bhJKLjQo+yDJgF5RRcXK6/FVoPE81K3XzaDpQ/V/wvCRfZE7IA51w4m5a8U14WDQzU3BjilBmioM2y6DgVDLB6W2+uE5O3hifa43Vby/IFKNFeFZqa0/Uc5W4NJq/35PwgdsmaMn23xudgdcdPJ2/TGelXEOgZ2VXLsBys+n+fVxbOI0HnFxPmq43ANepAOZvqehMUymG77EYugy/I0IBfGj+vL7hRY145QhJgFrT7GzYHlpO70r1i+mLhr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 09:44:18AM -0800, Boqun Feng wrote:
> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> [...]
> > diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
> > index 4aebeacb961a2..8ab20126a88cf 100644
> > --- a/rust/kernel/sync/atomic.rs
> > +++ b/rust/kernel/sync/atomic.rs
> > @@ -560,3 +560,35 @@ pub fn fetch_add<Rhs, Ordering: ordering::Ordering>(&self, v: Rhs, _: Ordering)
> >          unsafe { from_repr(ret) }
> >      }
> >  }
> > +
> > +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
> > +///
> 
> Given Greg and Peter's feedback, I think it's better to call out why we
> need `atomic_per_byte_memcpy()` and why we use bindings::memcpy() to
> implement it. How about a paragraph as follow:
> 
> /// This is the concurrent-safe version of `core::ptr::copy()` (the
> /// counterpart of standard C's `memcpy()`). Because of the atomicity at
> /// byte level, when racing with another concurrent atomic access (or
> /// a normal read races with an atomic read) or an external access (from
> /// DMA or userspace), the behavior of this function is defined:
> /// copying memory at the (at least) byte granularity.
> ///
> /// Implementation note: it's currently implemented by kernel's
> /// `memcpy()`, because kernel's `memcpy()` is implemented in a way that
> /// byte-wise atomic memory load/store instructions are used.
> 
> And probably we make it a separate patch for this
> atomic_per_byte_memcpy().
> 
> Thoughts?

Its still not making sense; an no kernel memcpy() does not necessarily
use byte wise copy. And please stop talking about 'atomic' here. There
are no atomic ops used (and atomic ops will fundamentally not help).

Seriously, none of this makes *ANY* sense.

Yes we have racing copies. And yes that is 'tricky'. But there is no
magic fix. Nor does it matter.

You copy 'n' bytes (in any way you like, preferably the fastest, that's
all that really matters), and then you get to go validate that the
content makes sense, like always when you get something from userspace.
Must not trust userspace.

So even if there was no concurrency, and your copy is 'perfect' you
*STILL* must not trust it. So the presence of concurrency matters not.
It is just another way userspace can serve you bad values, nothing more,
nothing less.



