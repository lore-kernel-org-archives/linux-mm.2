Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B618D1F9D5
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69816B002A; Thu,  4 Dec 2025 07:39:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41586B002B; Thu,  4 Dec 2025 07:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F616B002C; Thu,  4 Dec 2025 07:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984666B002A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:39:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45785140131
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:39:16 +0000 (UTC)
X-FDA: 84181743912.08.47B3154
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0808BC0004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:39:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GplumZ8R;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764851954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89lu85i9iy0uktaUJpKiLn2xYKgVihXHfm6nPHuJVes=;
	b=bWmbx8bh6FtIxwDh29goyp8VTIYdpcAzdf/CiwmTHOkqJCKv1YtiUXBYE6vV1B1anUHoNB
	YhV8KszIL8ZvDP6y+LpNTZ4hauX6muqDYRcUj7m3qtBAgxpbc4T1V/2P8Urmwsz/nBcPu5
	vAKCAbqc2WUPXnUCu1/LwiyrX9HMW/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764851954; a=rsa-sha256;
	cv=none;
	b=omPG0WhvXTynjHS0nI8lc1IytaRfuGGJX99H4ZoQNmAzQjYSWDFi2/fo14Ajm3K0j9Ktuk
	kSJtnN7bA/Rx9ItRs2qgOq3lwHKc1XNNwFa1dBOI40BDw51UKbh4X4VXfR/woIef5h/Lgv
	RAXWdJgAciKST4KGBAtRyd4ubRM5vYI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GplumZ8R;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=89lu85i9iy0uktaUJpKiLn2xYKgVihXHfm6nPHuJVes=; b=GplumZ8RG+7r6/RPRCpIzWalST
	NTK1VlmdgSv0o+Os8U5TzCte9QhrImE8ky577kp1+pdEzf2iGrChGjDqxoyy/0vpTHDXW6R358Y9v
	4s9he+SA95cAcvXPvfP0YBsWkdxh0OLAIa4ikICD1C0FM1/6YmeS3FnRMnDkvQ903kDIFoZLEjGcp
	critL25nfa75jdtZxsYk6dpxMjznn1ANNnAC9Ogdkx8FUpBItwRRjQD0bFgXGIIjXqqlNXTcUgBjk
	Ky9P+0Q88jUy3RAcc358iN4ZHT3zQHEAuAbNqWod1N2S9oE+SwhJGOJtsxAOvpKdBk3IC30t+MUo2
	ndsqrLVA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR8bz-00000004BHZ-3Shg;
	Thu, 04 Dec 2025 12:39:08 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C5A3D3004F8; Thu, 04 Dec 2025 13:39:06 +0100 (CET)
Date: Thu, 4 Dec 2025 13:39:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Antoni Boucher <bouanto@zoho.com>,
	Emilio Cobos =?iso-8859-1?Q?=C1lvarez?= <emilio@crisal.io>,
	Arthur Cohen <arthur.cohen@embecosm.com>,
	Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
Message-ID: <20251204123906.GL2528459@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
 <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com>
 <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
 <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0808BC0004
X-Stat-Signature: y9sot6jspme43wymfpqobcifh1t9q7sz
X-HE-Tag: 1764851953-536567
X-HE-Meta: U2FsdGVkX1+awuhwEFlZt0sZxJyUxhOgKCP4pYC6SHkdd3HwWgfGc9TsdmtTONPCZH7AvG5qiIauitsVjeAxalOpCx7yo2pZvyIy8828I3RU9c5cPDbxLBpx/mKVaiCubUKCE12dp0opVWTJa0U97YNt6JXzbzAtLflH/5qG1De6IN1cRcEpEBR4ZdvniV8TJVk4PaGuyvFL4U0bN+IfLmXHTmOFzVd/Z76lxkG4DTqFNwqgB2uz9hcUXqdIn5V2UAS+LoNnE28kYSVNbXXA0FpQVMAnxxEsNTPhSqD4x+TEOFtt9IeO/+GR9pQkn/iGsBcLuN1b0rflMKR5nWwOW4+5ZZQCk9/AW9H/HYsOCPzPel4EyE93RgFBx5K4+hIXRPc/6PCsKa0gqanJYhZIHBza9wmA+rZlgAERw0vpvfNncUWpqrhLeuDiZaivgshzPy6VqvgTL51HW9VmU/Wnok4yPiFNjPRWj1IJu/DIWTM0TsNhBNHyEwcO9FrwMApEufkSV1OuWNnqszHXlYiGPdnYWq1gSeCaLmI1OABoh5aRqlJdwaFIwT5Yw+BnsqXs9m/SfCZBYxWZ/BwZvB+rUZdzXptiF4agc3eJBEcdPplvszF1kjAviulcYZEX4C61IzhivQjsV1LbjcBiHHpJ6pdRxlWhUTvUsl/t/Q9ofupO+DSxw+TVfSqYsVUp5zvhizvlzu705UcxAaoFLFkgGJPFOBfyoOSJW0FieWav1baV6r+zOy6ud4C9PqUddHw7TSJn4T5lJQtl9OZBV0QXh2iLnBKOsm75n0vFZvcEZ8XWNjvCF5CMQVPLIAk8tGFr8zjxtEvYxHuWEDBcED97dmfFQcXs61sHumMfWSUEUcJ0mjOAIkOuOnJ6Pt33GcPvwNNSO+door503qZPRYfvh6YSLSCQ9hD23FqqPA2RbVyRnz4nqZX3loCgOj0PSB2ufZi0Hvsh00hb/FPlEzy
 GIfUg3V2
 v42Pp7ldcJ65kdHIB+ApEKVEixYkSqs7cx65cGq1UFN53leWVQ3sEYtd4ToPdgPuNEghAT381BOcEDbVjGHindV3VW/mimCNji5SWamxbIuqyoBrRsxfo3i+wiat8sYbmJJmAg+GqOjNYUOyp4KuDZBTdVfaank5T/pjjAzBl5oluo6Itjsq9wZCTQo812u0pqakcCr1d1I7FJJb/s7imFu8F0P+maLv3u5ypSIFVhsQjJRkLgRTzhqzzsMgAGNNg3F/h0SP8iaCFZnSgRe4cKjQ3xNQvYcP7TsDgZxbPYHEB0AfrDQcAlxI+n8V92h2JO4bYxLAanh9nIXx2ivcMv7q7JjvqK//puJRmhgj0EdIC9NmAcQD/ygJvog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 12:57:31PM +0100, Miguel Ojeda wrote:
> On Thu, Dec 4, 2025 at 12:11 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Right. Earlier I also proposed using libclang to parse the C header and
> > inject that. This might be a little simpler, in that..
> 
> Yeah, that would be closer to the `bindgen` route in that `libclang`
> gets already involved.
> 
> > ... if you build rustc against libclang they are necessarily from the
> > same LLVM build.
> 
> So currently there are 3 "LLVMs" that get involved:
> 
>   - The one Clang uses (in LLVM=1 builds).

Well, being on Debian, I'm more likely to be using LLVM=-22 (or whatever
actual version is required, 22 just being the latest shipped by Debian
at this point in time).

>   - The one `rustc` uses (the LLVM backend).
>   - The one `bindgen` uses (via libclang).

These are not necessarily the same? That is, is not bindgen part of the
rustc project and so would be built against the same LLVM?

> If that is all done within `rustc` (so no `bindgen`), then there may
> still be `rustc` vs. Clang mismatches, which are harder to resolve in
> the Rust side at least (it is easier to pick another Clang version to
> match).
> 
> For those using builds from distros, that shouldn't be a problem.
> Others using external `rustc` builds, e.g. from `rustup` (e.g. for
> testing different Rust versions) it would be harder.

Make rust part of LLVM and get them all built and distributed
together... such that LLVM=-23 will get me a coherent set of tools.

/me runs like crazeh ;-)

> There is also the question about GCC. A deeper integration into
> `rustc` would ideally need to have a way (perhaps depending on the
> backend picked?) to support GCC builds properly (to read the header
> and flags as expected, as you mention).

Right, so the backend that spits out C could obviously just pass through
any C headers. But otherwise, inlining C headers (and inline functions)
would be something that is independent of the C files. At the end of the
day all that really matters is the architecture C ABI.

That is, if rustc inlines a C function from a header, it doesn't matter
it used libclang to do so, even if the C files are then compiled with
GCC.

> And finally there is the question of what GCC Rust would do in such a
> case. Things have substantially changed on the GCC Rust in the last
> years, and they are now closer to build the kernel, thus I think their
> side of things is getting important to consider too.
> 
> Cc'ing Emilio (`bindgen`), Antoni (GCC backend) and Arthur (GCC Rust)
> so that they are in the loop -- context at:

Right, so clearly GCC has the capability to parse C headers :-) So I
would imagine their Rust front-end would be able to hand off C headers
and get back IR much like LLVM based projects can using libclang.



