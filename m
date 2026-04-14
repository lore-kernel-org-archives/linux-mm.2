Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4B3F9D0DA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7F26B0088; Tue, 14 Apr 2026 13:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0692D6B0089; Tue, 14 Apr 2026 13:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0886B0092; Tue, 14 Apr 2026 13:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB06C6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:08:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75A1D139276
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:08:59 +0000 (UTC)
X-FDA: 84657796398.28.1B0E4D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 54D8A1A0007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:08:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9JME4SK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776186537; a=rsa-sha256;
	cv=none;
	b=b4rVMlG83MrobbkkFbWkHS1YM2fN1TctQifAiSqu/+HybCTRh9Jjps6OkAp7QUv0DsTUt9
	vcY3HpE8ete1CN6ieM7QUxSQU4GRBjsyqwQ2DnqE/PPDlm/h1qAeXm7MoUZcnPnFA9Jjmn
	YrNC0+0iYzUjpirhz4ccxXjPAdFKwKo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9JME4SK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776186537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJRRlf+W6ne68PwOrMuCMZR8Hg9Tfp1cvLdH5wBJaK4=;
	b=GYgVhCOefePVHAcmCRVi/9k9I4LVJvd9j8XSQyBoklShU5Uqo1ZZOGbB1wxMm5hB4oUOwF
	8nvmG4Za1BV0Lyb55M43xEqQ0riBAV1PEib8s6ax6LRyyHfkTrHftQ5npI1KuS1qj4V5wi
	XSrZYwD4bhaxdeRcVRKn1njB0kBb0QU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F87042B8A;
	Tue, 14 Apr 2026 17:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621BAC19425;
	Tue, 14 Apr 2026 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776186536;
	bh=lY453RX44XTTijXgcD4/68oGGZh9i3h/OJ7n5a/GWCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L9JME4SKocoX0IMhmlHkJJ4CQ8hoNCcqL4GB7WmwUvNaRGpFuo+Qjh459rDgHpHo+
	 zvNmZxXqb24eARm6FCiUKvqQRHhznUOJYNxVNqog9PwwL0qEdtdRpwTdpkeZjAs4+5
	 JwB8ImtxpWwvlBKo1myMhTDOzv5FB5gFfxMBwG7KzMDYKDcZeyEv2sGfQfXUjOp43k
	 cdsbLQrMq39OGjaJlSFagWQGsWZB7Y+rB0zjuDYpFv4xKbnm+GefsWhxZSC+9ZQJqe
	 N/97CfefbRQw7a2Yrh/w9BpFFuD5PF/AGgUYZfpB18P8a02DGZNVg3NgLpgc25O6Ty
	 KOMwJoxGT3jSw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8C69FF40068;
	Tue, 14 Apr 2026 13:08:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 14 Apr 2026 13:08:54 -0400
X-ME-Sender: <xms:pnTeaQmLG9t6qa3ZW6ayk6yh91cIQtUng0jt-yAAsSd6_36m0eyg8w>
    <xme:pnTeabT6Ic7G1IyFxqV0XWZymi9S6Ls3MlocSFq2Cy0BCLK1ry_U00QR2puhYK96x
    KJ4tRoJSLWdna53zDxdOb4tAqNLDQYxBc9Co4xqh6x0ruEOu1dUqhA>
X-ME-Received: <xmr:pnTeaSMMPlJju5y0M4zMCt3becLX0m3LjXujYuz8JoXyF2AdbuUMPSuYyiYkog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudejvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpedvgfdtffejheffleegffetffehkeekteeiheefkeehueejfefhiefhhfdvheeihfen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgv
    shhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeegge
    ejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhn
    sggprhgtphhtthhopeegtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphgvth
    gvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhho
    uhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhpphht
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtoh
    hmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnh
    hvihguihgrrdgtohhm
X-ME-Proxy: <xmx:pnTeaVm8nSBwwzP2sjjkOFZ-FrMo08HgCYElnWaEJjk8kV2OY0TIqQ>
    <xmx:pnTeab-Q4K6SfrNXkq5MKQxSIFWWCb5pBCYijkoX8UIr3qTVlWUpZQ>
    <xmx:pnTeaSDiatwTb6x-Kc3OBlZ6soFjgSEAEbsCXqTL_SQRor5WqUOqXQ>
    <xmx:pnTeaQj4vVipxSChMMzwijHcAIfsmiAZcEbdgniTE5s1L9PtmTO-Tw>
    <xmx:pnTeaWMAyuBorncANJklQ_LNIMqJTPdr87xxnnUhBDt2n63IiOXQ3v8X>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 13:08:52 -0400 (EDT)
Date: Tue, 14 Apr 2026 18:08:48 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <ad5hAVuRwa_0VNPf@thinkstation>
References: <20260414142354.1465950-1-kas@kernel.org>
 <ad5dIUpAMs4MuBvV@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5dIUpAMs4MuBvV@x1.local>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 54D8A1A0007
X-Stat-Signature: daah1919jwtw3wdnz1b3h3c9aiwptone
X-HE-Tag: 1776186537-846375
X-HE-Meta: U2FsdGVkX1+9fzozEUcUNYp7aD0S7cFsLNce76htgWPqzDrwbk4WrCoV7IIrXpvXjGRawGslcz+Gi/PoaBjU3xTHnpkrtEaB62XafvvNGEFweS37nIZ9JE3hD3LkHY7Hq5CFrm12zfBaGZX/aKH8ua3pLlBExMjmAPECzhAUTPcLYdGgvkQA0DLskFL40KIqbXugWhsxjCrYGcLerI9kh5D7Xl4OXHA2ciAjKm5UCRvxIlYtfyG21l0EKJN4X0SQmkIe1q9/wir8636tqKuIgqp9DBN69U+ijmKKwgIzxpE9bDHnBoZLF2C2EMJ4IXutiGfrYKlh7W8NnjXduF+UtS7b2wwaAzLOWFI0A75a6a5kBNoxyaFBgPwmVyKY1XO9q6U+5EcXjwW8r89mTl3ag+AZgn05Nwr+JA3HAsj5v6n0w/Hjkne4ZCcn1O7vq/bEOWBKO+62u0wHWwqJm4qRUTsRP6RN0QcQVXcN7SwIB+pdUQmS9rNG53KOz7FyRV1zjXD0IZ2OExV3jxFoeP2SkKlychZ0XC/nM2rJdU+QMqLc5nfoaig/ftabYEjpiXpM/ib8RPjaEk8YvdfIVG0wTI0zYSOugH9cXwoDTdwkfWaNjmSdQRFYf9MKLTib9lj6K5ksMvuXmX4PPsuvAXlThryUPKpMPnsdGGDB1TPvzmQdAaSSqGWaJM2ZYu2Vuo9CIBYVheEQF2x4FGIWlkWZN9hSq046h7djf4/Q/m3cDqtGRLFdBEA4hpuSpKC4nO6rRhhEECeQgsQ+n6j5yBZlQoUZmL7H7caoeXK/uC994TYFqCiz58KfUmDA6oUoAYlMG3P6j8/jmxzzp1zieR8pa4ruSDsIRZYx/3Vx9YQEtiAQbDBy2fj+iSH/Yb5RMMMJf39mhtXpMCYedWt1kNMdfbPdmLIlpkcg3kqdJkI+CXP2PSFrqgKZnA/AtP2kbhCgFd4JfjW6apebvJszOul
 Mj0cYIty
 k0uJRQmmu7ky4+o8M9kZJj+TB2QtasJUe+unyzO0vr/7BpveBi5qpsFyxPCkykteqHJvH8xs48IYdJBrh3t2stWeQj9RHhNBpZ/QltadFAdXWk/k+NW0SdGnI7Ax2Q4+95Vt7Z2huj9mgze/a8Yn1eKl5WkWZnEdZYL+fkBaC9KtEWVJbAuAXORVreKNGLyuvRQlduspJfDl3FlON0Jo8EWcyTG4a+XuvFhE57EGAI2dPsqwtparzepLOhf3njpfDptEFSrXH1m/cat06nu/cJAuspJXwERZMzeHjAXvfbDy7Ca+WP1UEpRJ2MGkqIjJIQZcPjgE21bY6ifQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:28:33AM -0400, Peter Xu wrote:
> Hi, Kiryl,
> 
> On Tue, Apr 14, 2026 at 03:23:34PM +0100, Kiryl Shutsemau (Meta) wrote:
> > This series adds userfaultfd support for tracking the working set of
> > VM guest memory, enabling VMMs to identify cold pages and evict them
> > to tiered or remote storage.
> 
> Thanks for sharing this work, it looks very interesting to me.
> 
> Personally I am also looking at some kind of VMM memtiering issues.  I'm
> not sure if you saw my lsfmm proposal, it mentioned the challenge we're
> facing, it's slightly different but still a bit relevant:
> 
> https://lore.kernel.org/all/aYuad2k75iD9bnBE@x1.local/

Thanks will read up. I didn't follow userfultfd work until recently.

> Unfortunately, that proposal was rejected upstream.

Sorry about that. We can chat about in hall track, if you are there :)

> > == VMM Workflow ==
> 
> AFAIU, this workflow provides two functionalities:
> 
> > 
> >     UFFDIO_DEACTIVATE(all)            -- async, no vCPU stalls
> >     sleep(interval)
> >     PAGEMAP_SCAN                      -- find cold pages
> 
> Until here it's only about page hotness tracking.  I am curious whether you
> evaluated idle page tracking.  Is it because of perf overheads on rmap?

I didn't gave idle page tracking much thought. I needed uffd faults to
serialize reclaim against memory accesses. If use it for one thing we
can as well try to use it for tracking as well. And it seems to be
fitting together nicely with sync/async mode flipping.

> To
> me, your solution (until here.. on the hotness sampling) reads more like a
> more efficient way to do idle page tracking but only per-mm, not per-folio.
> 
> That will also be something I would like to benefit if QEMU will decide to
> do full userspace swap.  I think that's our last resort, I'll likely start
> with something that makes QEMU work together with Linux on swapping
> (e.g. we're happy to make MGLRU or any reclaim logic that Linux mm
> currently uses, as long as efficient) then QEMU only cares about the rest,
> which is what the migration problem is about.
> 
> The other issue about idle page tracking to us is, I believe MGLRU
> currently doesn't work well with it (due to ignoring IDLE bits) where the
> old LRU algo works.  I'm not sure how much you evaluated above, so it'll be
> great to share from that perspective too.  I also mentioned some of these
> challenges in the lsfmm proposal link above.
> 
> >     UFFDIO_SET_MODE(sync)             -- block faults for eviction
> >     pwrite + MADV_DONTNEED cold pages -- safe, faults block
> >     UFFDIO_SET_MODE(async)            -- resume tracking
> 
> These operations are the 2nd function.  It's, IMHO, a full userspace swap
> system based on userfaultfd.

Right. And we want to decide where to put cold pages from userspace. 

> Have you thought about directly relying on userfaultfd-wp to do this work?
> The relevant question is, why do we need to block guest reads on pages
> being evicted by the userapp?  Can we still allow that to happen, which
> seems to be more efficient?  IIUC, only writes / updates matters in such
> swap system.

But we do care about about read accesses. We don't want to swap out
pages that got read-touched. And we cannot in practice switch to WP mode
after PAGEMAP_SCAN: it would require a lot of UFFDIO_WRITEPROTECT calls
with TLB flushing each.

With my approach switching tracking and reclaiming is single bit flip
under mmap lock.

> Also, I'm not sure if you're aware of LLNL's umap library:
> 
> https://github.com/llnl/umap
> 
> That implemnted the swap system using userfaultfd wr-protect mode only, so
> no new kernel API needed.

Will look into it. Thanks.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

