Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FD8CFE520D
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947006B0005; Fri, 24 Apr 2026 07:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7FA6B0093; Fri, 24 Apr 2026 07:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6696B0095; Fri, 24 Apr 2026 07:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9676B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:37:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27BD38C3C5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:37:42 +0000 (UTC)
X-FDA: 84693249564.06.388D485
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6024180005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:37:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nzBIP5ab;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3c7Qw71SSXRyALDezXiZAQQzDzvW3kcDvUpY+1eQPs=;
	b=oEvnmq7/eQENmzjhaUXaJ0rGcK4b8jhq1rJL12waMz8rLgY4CnK+hDVM49z4pNaHOtWR6M
	qhCx1RUxfNQOzVvH58xUEvnlvcn+x/0v1XwZVxMXFG8cxvdulIgv3nYl1ZSlMwgcAE76Sh
	Hz3sGKeKA5Q3DR283Le5v+qZ/Y3FfZg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nzBIP5ab;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777030660; a=rsa-sha256;
	cv=none;
	b=b+hAu4yAfU8KXYJVysLXMM7ddp8VQTegHkM3IrUhnxERfvZIr9nGzClbeyUY5RZp9Q0YSi
	0+/3JFVqkS9tGMqWV6V55Yo66JLWatOT+nh7DdfjdF8Ij7sFFZS1bdi+Lrmg4W9CaiNyo7
	95acTyCFdg7Z3abu6BkQTYKHryxRMn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFDB54419B;
	Fri, 24 Apr 2026 11:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41103C2BCB2;
	Fri, 24 Apr 2026 11:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777030658;
	bh=pQAkkgwBTm0wMFjEsUuolfLk3Se7Aw+kEEZDfgUAj2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nzBIP5abjjPiZZKk8KmpEKOCx55UR2CcQo4kIqsUQXfA5UyKUBcFG6fL+eKBcY8h+
	 Z/IfrfmDAAZ1oTeJyQgyK7Tne3nUUZDa89ct2P6caB9rXKFqCCe4EcsScpHzDGFzeY
	 ZOr9zDzVzse/BEdiDRVjawbGvPPmtHFoHnJfkatWPHbyZr0JPu6QKpCbMJTeGj3Feh
	 ZyVyaI03ezjru7DS4fm2FbV7yfpGkqG79XotEA98ZaMGW//j2ekaeioZXvojXXT9g9
	 MVCJK/66fQqSt2ToUupcd7+2VDC/LsTQhO8gEr6GA/W3ei3jI14fr6IZXuhXPmP0Tg
	 G9IeHmtC0ynOQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 45D00F40068;
	Fri, 24 Apr 2026 07:37:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 24 Apr 2026 07:37:37 -0400
X-ME-Sender: <xms:AVbraWr5w8IN3pcVGoXPYYrMPDysCLNSoP-_ZN9t0HOo2Qko1JiDbg>
    <xme:AVbraT4POzjwfmz4bT4yoZElgbWGQUHeFUgunMRWU2Ng-pHHGGDRmMhmkiPRm26SJ
    sVpYz2SFbvKgtSkjzeY7zEIW244lEasDLHm0ADNoc4lJACEkWDdwWU>
X-ME-Received: <xmr:AVbraXbGXxDYOWhmrT7HaBaIytopftSXGzadskJ8-cynWYp8WJVqyh8cEZsWkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeileelfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekrodttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfffieehtdegkeelkeegkeeijefhieeitdevledujeeuteekgfetveejjeeiteek
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkh
    gvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeef
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrth
    drtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplh
    hjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvh
    gsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvght
    thesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:AVbraQq9zuliAnRVDPxVtBQJGJxFL_QUAhEOzsJ1QnuDy8699f1iyw>
    <xmx:AVbraY4lWjncW9FwD2xl5yl8EK0PYAnkDSbFag9Yr96vAKFnGgQudA>
    <xmx:AVbraVSwRkroFnFwWJ0ASMKYBKsCFLz4T3EDzFpRp6go0R1lLWqdLA>
    <xmx:AVbraQ2SpbTiy1zowaVMJ8EHvAfhpIeWkeiS40LSPhc1Gdn3NRXYIA>
    <xmx:AVbraU4lHgmjedtxDgLxYgfTvjFaJxZKG-9HWwH7MyOScA--VfxBgiGu>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 07:37:36 -0400 (EDT)
Date: Fri, 24 Apr 2026 12:37:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aetHWMZyEEIEzsJZ@thinkstation>
References: <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <17b0dc02-eee3-46d6-9afb-5f81a3a20216@kernel.org>
 <aep8tsYFfr_Xe54q@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aep8tsYFfr_Xe54q@x1.local>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E6024180005
X-Stat-Signature: qrexgojibeqi4ftoghhhi3fzq1mu1mwk
X-Rspam-User: 
X-HE-Tag: 1777030659-229124
X-HE-Meta: U2FsdGVkX1/QZpOMTEdyS0C/6RpeDbnui7sx60uqJDjW4pRfrIOaWpD+RwPVHXhWKn2KO3w6BLw7llUOAHfwED56hqYcyon24nw/Gorb21ns3K0sFOTRIXdRsXe/q+ElcfK1v5Bwp9N/UPeytdZ7zc/AADgd4swttMPo7cPl/JDIzUQuCMRx69fRTfI9OoJv+nPyUbEJxPciUHa69Fye4L8FDkfxcxQ77jkIPI8XS6md60kXyasCHOdLjOc0vMEk0ZSgLjO1K4V6r4UYyxytm3tOnVuKnUWsSa+OHKTG5J7OzjeFFvxDDQPZNT0JoF3hwVGo2e3xfkvmTivmf682s/uZxllP/D6d4qOC3Z3Z7DfyQcgAsGYE75Nlbf1JcvWmjM4MbSBwfjYGtv53PQi1VnEdMLhWtHAIF9IvsAp6GnM+clX7zNQWCAMLk2g0ivpM7P80BTusBPsBDjO6bhyChTc037iOFtqJfzTQ7JFOBX2G1QuXhwp7q4saYRhHHqi3bbboDI6IJMJdU8SpEfdQUdCiGrQ/6kYGYiBIxZ2H3CDbvmBnNTJteT80p6ETwuYvPPAa2kE0C0aPkRMXgH6Asp8lBc4WI9rVS89zE+z+BN7HPORuXwJFTHPfOAba+WljVnWs4MeHTtPT48tfu7olTHpxm5VpmcKPYlVyoj62CEtzEcgIOQ0jUCLkjMcxm4L750lNNQ/vDFQotV1c3XH2s2jfkbq6/HysLC1KU7f0EOar9egcJ7Z/miFNIijFW5RLGIAvdNg6yssVfu+6k8nUR3UOYHdkFCnkMNoct9IYOl6qN4W69VB35RKDowSpwWrzzEpWEkb/3pr8h9zXlKTt5FFVvZPTlVolM40j+bQ4VW0WZnY+EQFcgvSqb3nr3Cb7B3IbrA8puc/BacXwn9uQ53euRTSd1mDgAi733l3W4f8gDqOgAH60cHURAjuMnRHU+qtmInFfJWUUI3A5V0J
 dww5f4t3
 3Zb6I8Eus75BW07yU5aZGErGnkEuyaaw2hXhCPWGFBsKUGnnMwnVTvB6z/+oQ4wdw4pyAf3RaIICdJxJfbi64Us4OkgUGM2K0r7TKX3qDudvPtvi+4VbSoHDoekP2eAl/sWfwhfL2R/j63hRrBeueeEzOnBj8XMdipRTxNrO32WcbSKa3BLQ2malNOYZwuV2qEwCUWSkgGfVCq5qXTX7jwPVI5Ah1plZG/UGRcGYKLP6vxw538XVtnCjVyxejbTlEzsGLHwC0IRxFgAvZaCjSSb0X1FMNfTEfxFvxEH11e4rEKMtTfYjcxvnBxhw1CX7rjJN8BQKTxYNgrak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 04:10:30PM -0400, Peter Xu wrote:
> On Thu, Apr 23, 2026 at 09:25:30PM +0200, David Hildenbrand (Arm) wrote:
> > > 
> > > The other thing is, as I mentioned in the other email, I still don't know
> > > how the current RW protection would work for anonymous.  I don't yet think
> > > the user swapper can read the anon page with RW-protected pgtables.  So far
> > > my understanding is maybe you only care about shmem so it's fine, but it'll
> > > always be great to confirm with you.


That's true. We use vhost and therefore shmem in our setup.

One idea I had about how to make atomic eviction for anon is extending
process_vm_read() and process_madvise():

- Add a flag to process_vm_read() to bypass the protnone check on
  accessible (or only RWP?) VMAs.

- Allow process_madvise(MADV_DONTNEED) when the caller already has
  ptrace write access to the target.

The standing objection to remote DONTNEED has been "destructive", but
process_vm_writev() already lets a ptrace-capable caller overwrite
arbitrary anon with attacker-chosen content. DONTNEED is strictly
weaker — it zeroes, it does not inject — so the trust model is already
established.

> > I wonder if uffdio_move could be used for a swapper implementation instead?

I considered it. UFFDIO_MOVE can in principle relocate the cold folio
into a staging VMA inside the VMM, which then reads it and drops it.
The downside is the VMM has to maintain a second address range and
serialise eviction through it. A purpose-built primitive — something
like UFFDIO_EVICT that zaps the PTE and returns the folio contents
(optionally to an fd for io_uring) — seems cleaner.


> If RW is justified to be useful first, maybe.
> 
> I had a gut feeling Kirill's use case doesn't use anon at all, then if
> nobody needs it we can still decide to not support anon.
> 
> > 
> > If we ever have to read from a protnone page, maybe we could teach ptrace access
> > to do it, or have something that can read from prot_none areas -- like
> > uffdio_copy, which can write to prot-none areas.
> 
> Somethinig like swap_access() in my proposal can also partly achieve that.
> 
> https://lore.kernel.org/all/aYuad2k75iD9bnBE@x1.local/

A maccess()-style primitive that reads through PROT_NONE is a reasonable
building block and overlaps with part of what UFFDIO_EVICT would need.

> There, it was only about reading from swap so far, though.  But that one
> might be easier to be extended to read PROT_NONE and directly put data into
> buffer user specified (ps: in my local tree impl I named it maccess() to
> pair with mincore(), but it doesn't really matter; it doesn't even need to
> be a syscall..).
> 
> To me, the interfacing is not a major issue.  The major question I have is
> why RW protection can help in swap system impl when we already have uffd-wp.
> 
> So I want to make sure the use case can't be implemented by uffd-wp already.
> Because that's really what we might do for QEMU.

Race-free eviction can definitely be implemented with uffd-wp already.
But not proper working set discovery.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

