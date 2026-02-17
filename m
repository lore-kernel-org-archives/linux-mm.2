Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A3FE909DF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9138D6B0088; Tue, 17 Feb 2026 12:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1796B0089; Tue, 17 Feb 2026 12:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6656B008A; Tue, 17 Feb 2026 12:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 698086B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:10:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D6E51A02C5
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:10:48 +0000 (UTC)
X-FDA: 84454588176.16.CCED381
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 03010160002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:10:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PIsJ85L/";
	spf=pass (imf08.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771348246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCOCRQbDJsC6xNV9XXJ0oHJuRNatHA+oUOcfnlzUhgY=;
	b=P8EONQhnj2+RPa2e1EU8/GWnaH6X8zLZOrwT/YmdyjBLvk1mu7E2d3BWdo7Eyats0YhDW7
	DAB0rZdghOdfqaWDnw6U+mh28wAFRlbBe8CnM2h+ummdLk+8JYOZU6s+csLfQw4+gwSs+p
	cBIY4KbolPE3x7R7u9qWCEj69eEWklQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PIsJ85L/";
	spf=pass (imf08.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771348246; a=rsa-sha256;
	cv=none;
	b=MpD6xU84TAFmwGLgFnZ9CjoZ/BT7MI0mF/WrXOEqEPLW5LpbLd1gTAEzEj/chZfgd0u6pb
	veMSRBZR5+8LZKdighpZQCEnHWcq52pKqnPPdTsjucT5PxZbQNrkR3pu4DcafdGB3b4H30
	ogZnFIHMlzrnBqBFmX8+WDTPeHnvunY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5206860053;
	Tue, 17 Feb 2026 17:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C37C19421;
	Tue, 17 Feb 2026 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771348245;
	bh=hn8f2VPe13u0Qw57SnqTcYuvXQRECKkPuiiq0cXvlY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PIsJ85L/5KL75nrc2etlzYUb1bmmIvPowNmehrkM2ZdwrysO5LHhH2+tsaK8KWOFr
	 8wI2EilYnvyiLz1KDZPfgm3xuzkw9PUT99cu82WVUr02FlXCAuj058BTfghbk3s27U
	 zcFW6LTjDNfQRWIvOX/KQdaaF7bGaP7pGVhcbkj2Yw+7hnz9gSqgL142Nw9bFDhhaB
	 OcaToutV11e4dDFvhAoBpaMA96YiXPyX8wULm7nTkygj/yVbggRgvTgPtAVHP3rVTu
	 2qFRlO0vc9xN7skNaJXe05xDT7MORcFnDeb/Wrc7hCUOvubrFkeePPVb/xFpX522PA
	 DpHCwE/HHuDXA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id CAA78F40068;
	Tue, 17 Feb 2026 12:10:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 17 Feb 2026 12:10:43 -0500
X-ME-Sender: <xms:E6GUaQwE0UxHITFNrJWToppchBvFFbDP7muRCrba3E6H8Y8kS14PAA>
    <xme:E6GUaQNA9urkljEsxNaLKqBYjd6b1gXvKmVYgY7pnLqHK4BG5KjWCWDpKWghSUiFN
    z0MMGp9iUdum_0387sHoKzF_SNfy4KfsncfqZcJcpz50FehU-Ai9w>
X-ME-Received: <xmr:E6GUaYePAaiMKzJaY37ySeNqNnKskRYhFYGNSJQM7Xcf6XAe9bPcIhMwS10gjkTvdJxAT4eViTqj48AMLW84Gk0Tgg5eIVFJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddtfedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihi
    lhhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnh
    gvthdprhgtphhtthhopehpvghtvghriiesihhnfhhrrgguvggrugdrohhrghdprhgtphht
    thhopegrrdhhihhnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghlih
    gtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshht
    ohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvth
    htsehorhgrtghlvgdrtghomhdprhgtphhtthhopehojhgvuggrsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegsohhquhhnrdhfvghnghesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:E6GUaU4_t3SW360-BXEJVynNndz6LjeLkttnD9l_K-Fjk2Rw9HP6vg>
    <xmx:E6GUaQK7jWHqI-ap2s60d3zcP7jIm92Na4HI4MGTZM-yHs_KXjgoDg>
    <xmx:E6GUaY4HXZ7qfCLaQTKaBXZcjwMwynAdQVg8sZJcqh4UhfdQUCnAeA>
    <xmx:E6GUafbq7GcDT4jklfpnUj6eCE-eIxk_QpVvJgi0CHC6_sl6eH0jtg>
    <xmx:E6GUafyl22vRbhyP1u4n47wktRj4eEtqZlHAddjF5OQlE5qYWGBc4qKR>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 12:10:42 -0500 (EST)
Date: Tue, 17 Feb 2026 09:10:42 -0800
From: Boqun Feng <boqun@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Peter Zijlstra <peterz@infradead.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <aZShEW2b9-71r18I@tardis.local>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aY9i8rbvnxdOA9DV@tardis.local>
 <20260217085541.GS1395266@noisy.programming.kicks-ass.net>
 <102c86dd6fb1a907b7138a437dee00dc@garyguo.net>
 <aZRHJ22UtG1YeBMj@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRHJ22UtG1YeBMj@willie-the-truck>
X-Stat-Signature: di5f7gf7khue6wrz6ixprnnkjhxqf19r
X-Rspam-User: 
X-Rspamd-Queue-Id: 03010160002
X-Rspamd-Server: rspam01
X-HE-Tag: 1771348245-141676
X-HE-Meta: U2FsdGVkX18XrakekmYc96pOO9szjhgdgUG2lIVSoSXUHIyt/K3OcO85actHTa+ZYWQDHyq08+eaLV8Sk0FWkQs9Wp8U3uLyReuFIIMoyKbvFBHM/vWpPkp0ru8TeLMGOROU9erEVTy8tF5eIcN0utvgqONid901WMfE0a9QyDRPA8BC5txQPXHZG1Th9i4B2bnKqoYD4f6/4ya1BuYKuhHtRpZPnnmhBWn2vrS+TQBZtndzZW6TcoDPUl4ngeH9R3CdHeW2nILhvxQeR5m4O1okxKEXadwdmSLw7CYUYHO2yT4Ym7oK7lpkG8075ignEfxyc0xaeCBcKi6DpfrHHaXg6RwbWGOQdZ9EGbFm6eHJzIalus+1DwPIt9OzlLeZCwmvtj4d3zFvf6/ElKd3q04U4fpuMvc5kkWEQ4FPytDKOlH8z969iOCa5N01Yt8qjLoIZVLfoxugY8g357eC+XdUf7MlvviU7ngBFP/3DVoCG7gVsjH2xIHlgw/WynBEDI8RgktawucZdLzPOJ8430F0wWAvhP2uy7IkIMMqCRPhbkzJeOn4YmifpRvaUQ6yVpycD9IUiUb2j7MOHr6yIQLCdY8l13hwGcJuhBBaWYd0OhmebQ25d3aetriU8w8RWbzVJWYNzi4WC7GoKqDVvCHtkV1dCstIK5zQ5h3XBKgKFfRF/Ng20ACD7sHA0LbeVqMA/Ee0h29Bp8Mihc36OjIYHswojxDeLSyLOBkVZv3vvlfTfyb1pkd9JzQtlhoN7irXuzuzZlu+s+r3BS16U3scUZWW82WbTkfWAgNVPWds6e1U+CBgGtN/GBMwlRQCFJCFQam5tkaatoMS6lMlpOAQNynlgPuFtQXz6LVS9GoEtGyeyTas/1SnvYlzRCZ9fSmDIzkiIRydiVXvCJcYLm+BxIGn4mGGO/YXLaD+AA8dHmGuqyTu6V0gURPlDslH84ZTYRvbvoqK7xUHbP2
 ha2OdS7Y
 VX1M4G8X2u/emEchZWo8ljAFdk8xouQtVtNYesR4ok+wIrSQxReTbe3co2TSR3zzwETy1qsRJuW6mDEM/mteWx062bU/esaGmUCUlFlY13ZKoaaT/qJLf75qWTs2VJzRAcmmd6RdkDZ+bF1bdLB8h8guwBX0UnC+ebOfRYd1qZyF4zlcKdKqy1yDlRYsgjq7s1hmtO8chxgk40i5bGERW8VzMjMSFq1j2S8tEXWweyZFKFgYkOFtauDcTliv9P31Ki1o1qW1PbA1MVpxdCUF/8cW2/EzvnNXPhditbmY7iexKp+1arwM05DoxPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:47:03AM +0000, Will Deacon wrote:
> On Tue, Feb 17, 2026 at 09:42:37AM +0000, Gary Guo wrote:
> > On 2026-02-17 08:55, Peter Zijlstra wrote:
> > > On Fri, Feb 13, 2026 at 09:44:18AM -0800, Boqun Feng wrote:
> > >> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> > >> [...]
> > >> > diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
> > >> > index 4aebeacb961a2..8ab20126a88cf 100644
> > >> > --- a/rust/kernel/sync/atomic.rs
> > >> > +++ b/rust/kernel/sync/atomic.rs
> > >> > @@ -560,3 +560,35 @@ pub fn fetch_add<Rhs, Ordering: ordering::Ordering>(&self, v: Rhs, _: Ordering)
> > >> >          unsafe { from_repr(ret) }
> > >> >      }
> > >> >  }
> > >> > +
> > >> > +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
> > >> > +///
> > >> 
> > >> Given Greg and Peter's feedback, I think it's better to call out why we
> > >> need `atomic_per_byte_memcpy()` and why we use bindings::memcpy() to
> > >> implement it. How about a paragraph as follow:
> > >> 
> > >> /// This is the concurrent-safe version of `core::ptr::copy()` (the
> > >> /// counterpart of standard C's `memcpy()`). Because of the atomicity at
> > >> /// byte level, when racing with another concurrent atomic access (or
> > >> /// a normal read races with an atomic read) or an external access (from
> > >> /// DMA or userspace), the behavior of this function is defined:
> > >> /// copying memory at the (at least) byte granularity.
> > >> ///
> > >> /// Implementation note: it's currently implemented by kernel's
> > >> /// `memcpy()`, because kernel's `memcpy()` is implemented in a way that
> > >> /// byte-wise atomic memory load/store instructions are used.
> > >> 
> > >> And probably we make it a separate patch for this
> > >> atomic_per_byte_memcpy().
> > >> 
> > >> Thoughts?
> > > 
> > > Its still not making sense; an no kernel memcpy() does not necessarily
> > > use byte wise copy. And please stop talking about 'atomic' here. There
> > > are no atomic ops used (and atomic ops will fundamentally not help).
> > 
> > Byte-wise atomicity means that the guaranteed atomicity is per-byte, not that
> > the copying is per byte. The copying size and order can be arbitrary.
> 
> Curious, but how would you implement a memcpy that _isn't_ "atomic" by
> that definition? Are you worried about accessing bytes multiple times,
> or losing dependency ordering, or something else?
> 

We are worried about two racing memcpy()s end up being data race and
that's undefined behavior. And "atomic" is the key word in C (and Rust)
to "lift" normal accesses to non-data-race, for example:

	thread 1		thread 2
	--------		--------
    	*a = 1;			r1 = *a;

is data race, and 

	thread 1		thread 2
	--------		--------
    	atomic_store(a,1);	r1 = atomic_load(a);

is not.

In memcpy() case, since we don't need the whole copy to be a single
atomic operation, so as long as the atomicity is guaranteed at byte
level (larger is fine because 2byte atomic is still byte atomic), it
should be sufficient as a concurrent-safe memcpy().

So either we want to live in a world where

"concurrent normal accesses with at least one being write are data race
therefore UBs, use the corresponding atomic API in this case and handle
the data carefully with concurrent accesses in mind".

or we want to live in a world where

"concurrent normal accesses with at least one being write are data race
therefore UBs, but there are 17 and more API which are technically UBs,
but they are not considered as UBs in kernel, use them"

To me, having a atomic_bytewise_memcpy() at least clear things out about
what is actually needed (at the very minimal) to have a concurrent-safe
memcpy(). Moving forward, since the concept has been already somehow
proposed to C/C++, it's likely to be standardized (we can push it from
the kernel end as well) so we don't need to implement a concurrent-safe
memcpy() for all architectures on our own.

Hope this makes some sense ;-)

Regards,
Boqun

> This all feels like playing tricks to placate the type system for
> something that isn't actually a problem in practice. But I think I'm
> probably at least as confused as Peter :)
> 

> Will

