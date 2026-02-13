Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06933EEA84E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544466B0005; Fri, 13 Feb 2026 11:42:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1AE6B0088; Fri, 13 Feb 2026 11:42:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3EA6B008A; Fri, 13 Feb 2026 11:42:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCA86B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:42:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4F841C5B9
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:42:39 +0000 (UTC)
X-FDA: 84440002038.26.1FF72DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1076C0013
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:42:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOG+1kXs;
	spf=pass (imf22.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771000957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFr392gGrNDf2CmIKxo3U6khqffQiHdHIP0jdAd7jAg=;
	b=rwB0V6HTqnzahmVf+VVvawSLLdUxuwxowKH9HN+tnQSQYPsw6LmGzpWkPc9/vkEf2ytkp4
	1qZ9CHUDkmcNYa75Jls8vMYdy51AYsXCwuAeIriAgCO37tBkWQhnY0LSzFwdAvQjn90Xcc
	edIlLCvLd20gg19JCHD7wmlcI6f3fBc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOG+1kXs;
	spf=pass (imf22.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771000957; a=rsa-sha256;
	cv=none;
	b=uWth2hK0ZmYBGhZbg86iG4Qznb5yqupriIYxih1INWo3CWN/iiGOA1sVI1jQ2L9O+6DqOW
	fbaXFDDlFpJPK8Ne3NPfAEmqqLmcle+PYf5FlxrubQQ1v43kPsVbCrmflPPSgCk7qKlVhv
	OSYTTewBGFfuDVsXbOJgKeZ1fMswCJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2A9161330;
	Fri, 13 Feb 2026 16:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A127C19425;
	Fri, 13 Feb 2026 16:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771000956;
	bh=D2uPJCqU8beDKZ5LlRiC3yWLBv/9WvcYMPwKbnCeMmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gOG+1kXsjHq0JaqZqfkakBAKG+9KRzBvZfnVMSx7r7MNI7q+85Ai5rfVHaurK0Qgf
	 FpFokRlTuRWh9///2q441SKD+qVPhbagovAwUyfczIVDSLmGfs0j0Ck6q3PkU7CbMS
	 BsZjK/hjbW6BLk3uRVX3eA16ZcAkLjlJtL1EmR0nwD6UmEFlPAUYWxziYjbysCZLi5
	 +Q8g23sZnzWfAOb5pxzhJIEV+9B+SOToeBdbkjt/fleps0XnoH8QgwLYjh68pWn+o6
	 fh4uTvOS7Wd+xpyDj5UV3Bor8feiWG2vuiBrzbYINaU7huvBiDJe16JY3UH8oChvPL
	 9P5Y4WIno1E2g==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 33986F4006E;
	Fri, 13 Feb 2026 11:42:35 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 13 Feb 2026 11:42:35 -0500
X-ME-Sender: <xms:e1SPaTpjauIxaBYDHfuMWKw_wNdYxjnXMl8Y-EasyKmKcjtebZjKmg>
    <xme:e1SPaZkaLwspUe4u2Vsvrnkv4MWPyhVRtl5H4N1DeAUZyAAbG1KxgjII4rVRinJ4a
    MkjBSy1y-KA72B8UD4fvYls3AzWpolk2i20rdMEiybisJX7dDZv8g>
X-ME-Received: <xmr:e1SPaWVl4QqsibD_vAkuuO-YwcNETuQOnkqOP0EozLyVX1j1KGAD0hS4Lt6Cm6eVkpyafAd5nXFIY5r6owJaCSmNkjip3FtE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphgv
    thgvrhiisehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheprgdrhhhinhgusghorh
    hgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhl
    vgdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvg
    drtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhm
    pdhrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghoqh
    hunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepghgrrhihsehgrghrhihg
    uhhordhnvghtpdhrtghpthhtohepsghjohhrnhefpghghhesphhrohhtohhnmhgrihhlrd
    gtohhm
X-ME-Proxy: <xmx:e1SPadTC0lTvER7xSsrApy1MHnZClXItrE2auteeAz94dtxSwZDjmA>
    <xmx:e1SPaRAf9_jyW8HeWkrDcgEXHldLG22NAIzzllSwRpGcb2ciiaa6dg>
    <xmx:e1SPaYQ1CSd-CcfvztZWUGpVhmhQTaCfNh8TIPkKhjkeLP4iUc7Itw>
    <xmx:e1SPabSAT_0md2MUA7R8T7k3kX8VXYGTvQowPBoWm7yE69JTYiVfPg>
    <xmx:e1SPaeIbhmg0Xuyvp5918E25dFmNwq11PxAaITj_K7d3uoT1GV-b9qxn>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 11:42:34 -0500 (EST)
Date: Fri, 13 Feb 2026 08:42:33 -0800
From: Boqun Feng <boqun@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <aY9UedlaCmagVmzh@tardis.local>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam11
X-Stat-Signature: 6nx6t7i13epq6fn9w563mon4ncjdmbsu
X-Rspam-User: 
X-Rspamd-Queue-Id: A1076C0013
X-HE-Tag: 1771000957-357430
X-HE-Meta: U2FsdGVkX19eF8cz4VMdV11JCNtUSHoYMqrb7nGuOxkYcAvz4b7Wbk/QKlek02CbsQCysf9IW9/dzaBSneDKU14DIYrzutA/Eg+AZ8lae2rDWPoEpmJgPVNSzazFHSjRhzR7Ejm3gczlrz+bG8+WRLtyn825bbb1EOSq1eKw/nFbVRaJysJFsgVWN1vcxwZQwqwIDnbb/fnWmoBXkTXQoQc/KDx/wx668eWV8qxv9dYDUYQOD04hDlKL26BB0TM7FRR0Ba8u29YvKJy9cBVYgCrhejeEAbS6dLGqHaTSfIhKToXFYpLfDNOhtSbjrT+lB+AXfKfW7lxge9UmLgVCfneSGkY1dAZFhn7iMgmBNTqNuX+cCC32fwGLfhZ1JtXLS0PCuAuTo8nIY4cXuOLEryUgsZYiZaXE7Q0JqvI79y9sMh62ubCyxCtlRnG+/PWpUqksFd81eoUlTmr0w5HV0Rbv2PpDJmmHCwPyJdIcxWMYitCoO3+lOD6NTxr8/us85+jF1eLs25y+DN2MyrWZIHA1D+90ZVZcufk5Gpukd/x9FtmMAi9zk7MJNhojxf+hvOX90gB0GNL1KVw4C025TCQnENJtE52Jevexa5NKN218zA8gNOVmNxYz/Ht3kE+iYSyqyHooR8dBB1U7KBZKCDFtWQwP7BJvd2nsLlSTEk7Vs1zE0eknadlnvNkd7PjDlb6BW/BpzUWEJpJ/RknRlDbWLaS8qnQL5aQ5O5EfDgkFn+UBByDgTxULQcJI6NFIrO778Vpb6cFUm8v+za/mz1DKjIrbOld8tlmyNvbzG9+aFow/iOVUJb0e+jJElC0Fdm2dkgQ5QlVCPEtpScq47b8BNojktfLGqD79JTAP888jj4Tt4RGHRcNermGWhvmMUc6RPRbLc3nEbho6AsepjpgzuHpG3FWB/HqhB1MpCUXcb74zXcaHDUyz1VO6mpmdCthEO7iqW3dsQvkXl08
 6Y6DK17L
 E+Mmlvh4a5PRldfptSnwvMzdH0w5s22P+kLmATYYzQvLVCuVb1iiUkZTkWOjwRrWCp3uorS7ZCgMZcdfvUM7KkPwTRqBqBSfFBHHsk9mn6fyMIqnOabtC8kvRM4OkIyGMV4gm7KpzybTrANMHyipwHAHVAAideWeOp4Z7db0uriasevRCtb43o6oB1gmmkLz8Ncjf9B5PDh0jmFxoP/p1gL1MsfJVvEm0JQ5rz1/Uylufo0kBZ+zGPcGEbWxPvjq45qe7Aq3Tl+U8WUR2keWOjop/PAnx+n14WM8XWc6HJY4N0spo/ZyPntWW1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 12:28:37PM +0100, Peter Zijlstra wrote:
> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> > When copying data from buffers that are mapped to user space, it is
> > impossible to guarantee absence of concurrent memory operations on those
> > buffers. Copying data to/from `Page` from/to these buffers would be
> > undefined behavior if no special considerations are made.
> > 
> > Add methods on `Page` to read and write the contents using byte-wise atomic
> > operations.
> > 
> > Also improve clarity by specifying additional requirements on
> > `read_raw`/`write_raw` methods regarding concurrent operations on involved
> > buffers.
> 
> 
> > +    /// - Callers must ensure that this call does not race with a write to the source page that
> > +    ///   overlaps with this read.
> 
> Yeah, but per the bit above, its user mapped, you *CANNOT* ensure this.
> 

First, this safety requirement is actually incorrect, because of the
user mapped case you mentioned. I believe Andreas put it to prevent
others from racing with memcpy(), e.g.

	(I'm flipping the read/write here between normal access and
	memcpy, but it's the same)

	CPU 0				CPU 1
	=====				=====
	let ptr: *mut i32 = ..; // a pointer to a 32 bit integer
					let x = 42;

					memcpy(ptr, &raw x);
	let v = *ptr; // <- the result of this is UB because of data
		      // race.

it's data race in C as well:

	CPU 0				CPU 1
	=====				=====
	int *ptr = ..;			int x = 42;
				
	int r0 = *ptr;			memcpy(ptr, &x);

But this is already covered by the previous safety requirement on "no
data races". Hence this safety requirement is redundant and incorrect to
me as well.

> And same comment as for v2, none of this makes sense. Byte loads are not
> magically atomic. And they don't actually fix anything.
> 

The problem that byte-wise atomic memcpy "solves" is the normal C
standard memcpy() and Rust's `core::ptr::copy()` cannot race with other
memory accesses. We didn't have our problem in our C memcpy(), because
it's implemented in a way that at byte level, they are atomic, i.e. you
cannot observe a teared byte.

(Note, the atomic part is indeed not necessary if you only need to
memcpy() a user mapped memory, but in Andreas use case, I believe the
same code is shared between "copying from user mapped memory" scenario
and "copying from in-kernel memory" scenario, for latter we need both
sides to be byte-wise atomic to avoid data races)

Of course, it's not magical on its own:

* when racing with in-kernel accesses, the other accesses need to be
  atomic or it's a read on the location the bytewise_atomic is reading
  from.

* when racing with external accesses (for example, userspace), the 
  kernel code needs to deal with whatever the userspace can do.

Regards,
Boqun

> NAK

