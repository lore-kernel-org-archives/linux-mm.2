Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E44E9A023
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3BA66B0088; Tue, 17 Feb 2026 12:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25BD6B0089; Tue, 17 Feb 2026 12:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D287C6B008A; Tue, 17 Feb 2026 12:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0B7E6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:32:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5264014022E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:32:29 +0000 (UTC)
X-FDA: 84454642818.08.E463E7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5EB66100011
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:32:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cKsgWeNG;
	spf=pass (imf14.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771349547; a=rsa-sha256;
	cv=none;
	b=l9Eb1l6yWYldr7EOHy4QL0caLx1jcNwAZGcY5d7sZuhLeXaq1vAsGGYV5ly+zCXLvl+G+P
	ITeXwREpWOcXgrcrmoDmaP3TogY32rqoBzP0PcVMMGOJwPxKB9nqZ4aCIknk8Rl8F30BEW
	wHbfq6ncklQDkD/MafZb/er6MrUWVd4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cKsgWeNG;
	spf=pass (imf14.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771349547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3E5JYQ6mI7CWn4zDhzLhDe5994vI+/Py3jXfrDPLtno=;
	b=aM5nafnILgS2cdiISPFc7qSalFJ46HFdQVpTGrkN/5O/aTn68wbMV4uTpzXuH1ITBv7E6U
	bpGtX9+2w9RqRWRUlyuc3nZYKHPW8RVm5o0pnATkGy5iGfRDwh8sA8UvLDy0yAU41dSY0r
	SKr8l5Co+EOYjuTyR+nkTN24SplpaPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B351460053;
	Tue, 17 Feb 2026 17:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D95C19421;
	Tue, 17 Feb 2026 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771349546;
	bh=7ufRdIJ+xM8yNQqtxvRZquQZfSq7MslrO2i2CMxqlQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cKsgWeNGApcX5qS4qzqG5IsIHWTq0HmxRlKSob2x0tm6sqKXGi9d+unZPM8ZDe1gH
	 18ZPjpHfzgBxBeayCiI0Kpqx0MfDkSlXqmwKlXP17Nb+PkjX4XZ3Q4EpaCW32EWZQS
	 21LMN5fb+P8cKRw7AzFsQl+pJuSZeHdT5B0SpgrgD9SRMGl9/iOck2s4K6NrLKbzxB
	 4ZDvyS5TY0j53h/LEc/bguRaChUBTQZQBMOLCOVMgw2wDLQorQHVVXHSsmQxxpqjLz
	 +Lb6R21yXC5o2+o4Vhjjx8XGdwkZI7hoaTowp0QMz8lAkSH8U81YfnJ7ygkqWUIIs6
	 gVqav9Gc65r6w==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 102B1F40068;
	Tue, 17 Feb 2026 12:32:25 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 17 Feb 2026 12:32:25 -0500
X-ME-Sender: <xms:KaaUaftM7y0kQk5RLmXKqUpZ9ugJVadwA2UwwFHP0efGBEm5i5XGRg>
    <xme:KaaUacYHtngNJkjwDnCK6rjM1nGokudKlqoYcD-w2Pq2_fL5elqfAVHCpwhqhFu9B
    MOU9WeyJmclB9pNP1su3SAt_eMbhTk_NvCaTowz1S6XRmARn3_arg>
X-ME-Received: <xmr:KaaUaY7P5pH3JIgbKXpHdh8Ja2fnrACEp0MsOdhdOxlF5Pyiaht0otEsfH9BF2Ni4LBEZd5TV8lyn-aCxsBd9Z47Phc5BPVo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddtfeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghl
    ihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprgdrhhhinhgusghorh
    hgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghs
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrg
    gtlhgvrdgtohhmpdhrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepghgrrh
    ihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepsghjohhrnhefpghghhesphhrohht
    ohhnmhgrihhlrdgtohhmpdhrtghpthhtoheplhhoshhsihhnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:KaaUaUnMTRuzjUnA6JP_I7-7Ywen6IEGrC7hACEPZc8qV4TATaD_pQ>
    <xmx:KaaUaeFDtTNbsqxIfcyDIJR2UsYq99v0qgdoqtNelO5JSf6L6GtnsQ>
    <xmx:KaaUaYGovi0OVa7M1OrOeK7gmr1h25eT5XAUFnDerdIMm_bIfOOR3Q>
    <xmx:KaaUaW3EHEUL6BSRc8LGgL7nvqK94NJRnXg-bgFGcLX8gxH__o4tOQ>
    <xmx:KaaUaacnUELcKbO7DHlOk0k9LxAAP4wHyz18D-2w6evyiKudh9BTth4h>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 12:32:24 -0500 (EST)
Date: Tue, 17 Feb 2026 09:32:23 -0800
From: Boqun Feng <boqun@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <aZSmJ-1xSnqE9aqI@tardis.local>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aZRY9HthKwVJrAf1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRY9HthKwVJrAf1@google.com>
X-Rspamd-Queue-Id: 5EB66100011
X-Stat-Signature: heuygfqgy6q5ymuh816yaw59hrz3q33e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771349547-538031
X-HE-Meta: U2FsdGVkX1+0dRyarwzOH6ibWKR6hfkJGlAsDEq9AjzDwWIXnZSId8uXVztaOFf4UpyBbI55b4agUN0ApYULVCp2tiE3GaluUEU0DJN4TxCJpEXO1MoEWGdx5AlTa5N0z06UBVk6gQlH9/ZnmGBWIDtBYkGcJ0UaTkXCJthe02okmOh9Jk1gBD6IveFEI+hml/mOE0awIFWxYV7xcxiLd3fCmreTy9cujsaJ2i2dkSxBB+tiF/k0/qhKVJOkS0Un0+nw3xWXrELKWqHeABnR9aDXHRISxs0RfAf7o7PkSPeI/5Jr5kttOQgwB8JRxyTbhd3NsAfKuocJHxJhkTmOrrx6p2XoIcBjSVU5fuvz5WBqOSAmrm9tDTVzSZu7zT+HYTq0n0j0RwHb/EkvF4mf0+Zt4UeRhvIZQC7ZvMtD2JSl7OH0/ZZG0EHFeb3cIeR3QOYRXnqsmAAJSjjWzM84gtEqYUnH2CdGUQ/C1vrEuhYV30pp93AZkhvQwYa1J3dTWW7OX/FE9MVOKgHcGO3FuOLJ7VOWxOCNmpq6ay/I4gt3R3aiCCC/FXvilB3lrw3XFI2n2Go9JoMbY0pWA2jBgXtNlnIyfR2LERjeVzwAbvDWjuF80OMUuRrOFGNM+12l0Xfu3zu9TRTbZyMoAl43vAgQ3AvysUzhuWLxICXNZYoL+B9HfpLuP97mz1klnxqk39S3bT/em0Mvkw3Nn0tKEK6TzqG1QCDJJIOiY+0yDbkJJAv+gnCZpgW5s9FIoKECgFNC9BJQned7EhYBkGiTNBGgDBcQuV95Q72RZAZspfk+jDJ1COKm4Y2ofL6GzRV9tkLuXOF1G34gxpL/tDcYByCEHF4loQObNrXWr2t6h59chu9RmNoParxwIEFJIIeQ4Mqr8zaUVoS6ahpEcRbV9wGQxLhgngYBMBGnC0wlQ9/0x1k3pknj5JvJutvrxaFnn9jqoZfv8PfV8VLn01W
 LZyzpGiz
 lWArc0Tm2+RKjPNN1E/ZGk+o2uP0yuTyZqOBd0WgN/8xphiTbufJHrLRFwsvQzX7053BzIYUrCt89RC04aGqZT8pbVKPezz0QGm/bdkBNSpYaL7yosYNiPTgOdbTbx/3TWJL5suA34mqmKvNhL6XfvYsYwexZA/0q0RLAvf/hHvIFfpjHQq6XONkCdR5Cvpgqbcbn4GYGwPsOmumctLTMy9Las2O2nFKwxe4VBM8YzfwDxJaFcxy5J3PY9gbx+6q1Z64BQjHYgKvQLyRrQCtPxY5xEPsAz+pmOYAFezFyTCNwvzKA1aU0iPOZGAoFYaruxfThBz+AfJhjv10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:03:00PM +0000, Alice Ryhl wrote:
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
> > 
> > Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> 
> > +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
> > +///
> > +/// This copy operation is volatile.
> > +///
> > +/// # Safety
> > +///
> > +/// Callers must ensure that:
> > +///
> > +/// - `src` is valid for reads for `len` bytes for the duration of the call.
> > +/// - `dst` is valid for writes for `len` bytes for the duration of the call.
> > +/// - For the duration of the call, other accesses to the areas described by `src`, `dst` and `len`,
> > +///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
> > +///   function. Note that if all other accesses are atomic, then this safety requirement is
> > +///   trivially fulfilled.
> > +///
> > +/// [`LKMM`]: srctree/tools/memory-model
> > +pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
> > +    // SAFETY: By the safety requirements of this function, the following operation will not:
> > +    //  - Trap.
> > +    //  - Invalidate any reference invariants.
> > +    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
> > +    //    operation and all operations by the Rust AM to the involved memory areas use byte-wise
> > +    //    atomic semantics.
> > +    unsafe {
> > +        bindings::memcpy(
> > +            dst.cast::<kernel::ffi::c_void>(),
> > +            src.cast::<kernel::ffi::c_void>(),
> > +            len,
> 
> Are we sure that LLVM will not say "memcpy is a special function name, I
> know what it means" and optimize this like a non-atomic memcpy?
> 
> I think we should consider using the
> 
> 	std::intrinsics::volatile_copy_nonoverlapping_memory
> 

But two racing volatile_copy_nonoverlapping_memory()s are still data
race hence UB, no?

Regards,
Boqun

> intrinsic until Rust stabilizes a built-in atomic per-byte memcpy. Yes I
> know the intrinsic is unstable, but we should at least ask the Rust
> folks about it. They are plausibly ok with this particular usage.
> 
> Alice

