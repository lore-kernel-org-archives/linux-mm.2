Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF004FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4AC6B0088; Mon,  4 May 2026 04:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5866B008A; Mon,  4 May 2026 04:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB546B008C; Mon,  4 May 2026 04:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF9D56B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:10:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A20981C0279
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:10:53 +0000 (UTC)
X-FDA: 84729016386.03.C28D67F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CC746C0007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:10:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fW6xkc3x;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777882251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnhjAsyGqaMS+nDOkVBy1Azw9IJWD29jmkAyVAHi4eY=;
	b=oohv7KDUGjgy+ehfZNSwIg7N7pG79jv3Zz7Fe/pzYFK55ze9LFLcFI1zAj0rVpepzkv7Cj
	1nbYcZw1RRX1LoT9HpU/MhpdmTL882PCSfFx5gcIHbjGGSwKAWQGksYVr4QDUGZHlgSxVo
	pB2/jWA8TTSdV8r5HB6ZjXXCRP29SSE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fW6xkc3x;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777882251; a=rsa-sha256;
	cv=none;
	b=Xgo0SA+J7RVDl8x9zjk9FRSOMELGRm0etwA3iQv/ou7UXtiCNM0vRFKOkPwi5NfFn27f/f
	9WiM8LsUiACWmEHLePhM58Ew6GdsHDfB0IrY/xE0sT1dyJ6ZAHfeW1o1zhJlaPSydYhdaS
	Re/zU4r+UVPedS242R+6HTJ8C5paJWI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35177600C3;
	Mon,  4 May 2026 08:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0949EC2BCB9;
	Mon,  4 May 2026 08:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777882250;
	bh=fnhjAsyGqaMS+nDOkVBy1Azw9IJWD29jmkAyVAHi4eY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fW6xkc3xup7yyrmcOJrvfbxr79ZZlv7g8mO1Gc+4w0PrCqL/q1I3Rv9r1deb92GLg
	 NeRqC8hWuQRN6JcRBLW5KIRhvr9zRhdBWvM6xAcNS3R3z0bISyPsisBizfXK/NuQl+
	 npTpPhiWizUVKmBAg9y4hRMlnKOEwXOFEKxG6I3dl3xLILwdISynyo2e70sTgi/Plv
	 XZ7dyDVdNs8aN+bEzy2+yrOcg5cB1yDv6Rk582nFoIIcfkBop4/iSM3p7dnpUL9usj
	 04Saxn05XMA4hrGdlZktGB1PWV7BFHgZfMuPsWCmHwR6UuolQeBNgBj/9/+MyPopg7
	 UUwYwOX/iyDvA==
Date: Mon, 4 May 2026 09:10:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Chris Li <chriscli@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
 [RESEND]
Message-ID: <afhSYrGf4nL53_s9@lucifer>
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
 <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com>
 <2dab0995-ee80-47f7-a25c-fd54b4b649a6@lucifer.local>
 <CAGsJ_4wdsMca64zYJ8-K1-APFUNQTAaxfNG-JxaVZTuzV+KJqA@mail.gmail.com>
 <926d7e26-4f13-4e70-a392-1111de27f700@lucifer.local>
 <CAGsJ_4za9WM8=-60OVKraOw8KLCgb+CcJfiKixuFsMxUWQ2nzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4za9WM8=-60OVKraOw8KLCgb+CcJfiKixuFsMxUWQ2nzQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC746C0007
X-Rspam-User: 
X-Stat-Signature: c7odiqiqzydzki6ti75zth7mwtpodbj3
X-HE-Tag: 1777882251-760481
X-HE-Meta: U2FsdGVkX1+zj5+1w/ct+Ef9uUtEa41GFYqf03aqGB1JqxGc3nfNUaExc2gxJ7bxo4KZabLPMHtSAj/epAhAV5GKH16KRAw1VL17SmeGFF84pV1J6Z0l67wvdIvtbucFwJdGeKuhit4jqGrfyQCN0dTU+icJa6sBmCoQgYFX+jL/pJT6ShQbO+ne3bajZQE5Qq4L00umsVjQmyDttlJuiYE/OQppwB/z86rmwY/5/IPTHf+sVNMGml1tGbHfhVpGjrstoiJ55/S9BcErwtb83rUmIBF32nsMrqAW8JYjuksPX1nJR5cswh0Z1HdvSlpdBP/1sedl+mLoW7XDwVb+D9TDYH+STOQ9PVqcH0GgsilbJUhXuAQMikA4YRxjJLpxnIDcubzlhBVPb9brxbGXLe0yTmAaOgDDCdRduMtlw63UdVYlt3PKd2D8tU2CizGeUA+FxzmtubS6tgHFs+1xFiE9oMcT6lkoosUfKCSt+cJqp93yx4TA0A4GZeYEmRg7hxqOKkY2UTSOB1PedSNY2UurW1fad8PnohLxgvU4UZmUnPzOUUjxl5YqP8hZdCTdna+6MlHcmDEQH7EVnjI6t0w5IOc9TWTTNZVY7eLDzjJdqhhqQTeyO8pk28PG/zdsaH91oHnvNlcmPHtkUgjM79EA+d/GdpK9QJCbgwg8s2dU+VupIHf1qL+u9b8cnxfWUb7pGpv7joEB7yMgD6cAOp1NWdx4jGS49kxYu8lC1+fXW6ptTCtyiKasnBYMwuYKNFYZv4DE1FoBG+5ENwBanFbt9XilH1kyJzYcEDUgxdKhK7DJXvFUH8xX6tcxoYWiPeR3VWMeUhT58xhNIRCycgmVnzF37GzVdEnwTlRp9Eol9JfN9GBvq/kwyTrbogtf6hYsHj9ydwaCW+aA6dZ+v6ikIPIoakTy85rNrcNL8jN9bxY5sWhrmVL9S3EBntCzRROa4UOriG7z2lcngY2
 Q9XRgai0
 LKnQtOyxHjecSY10CjLCmbTWX9leaYGUZxccIt6aX3FWE7WV9xwEMu+deXxN2mCpZon1VZfSw/1meWoUmdosievZVzs7HIwbUNNAuZ7d+a+Q9UsTGa9wJ3tGDkwv07fFbnBtiiJJIn/VERINoG361/jTngE5quLXoAHd9rJbOHUHleuCx7Y/P14e2kmUfPsC2IjaHLS8JQw5FISNnlngDW/pgLq4i5fSfiewfnnrfWNRuvA9MFBv/878WWklqBX+W/hWsNsUCWlNMiUij5cmYukCc4uJUJqZAsdrKjW9PKxyoGkEVpHM/XSsy/rP8D2/rQ6J0/SiCnH0X3+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry my email is a mess lately, finally catching up after a month or so...

On Fri, Apr 03, 2026 at 05:49:10AM +0800, Barry Song wrote:
> >
> > Umm, memory is not preserved across an exec() :) so it works fine with that.
> >
> > vfork() is CLONE_VM so the mm is shared and everything works fine.
>
> My question is whether we can reuse the process tree, similar to
> walk_tg_tree_from(). With some flags in mm_struct, it might be

That's an interesting bit of code thanks for pointing me at that :)

> possible to distinguish whether an mm_struct was copied from the
> parent or created by a new exec.

In the new exec case there's no copying right? You're always overwriting the mm?


> > Well you're missing stuff there, the folio would have to be non-anon exclusive
> > (which is rare). Yes it'd find the new VMA, then traverse, and find the folio
> > does not match, and traverse children.
> >
> > rmap walks _always_ allow for you walking VMAs that a folio does not belong
> > to.
>
> I understand that we can check whether the folio belongs to the new
> VMA, but I’m curious whether this will occur more frequently in practice
> after the change. In the rmap case, I assume the original A’s folio
> anon_vma would be detached from process B once B unmaps and then maps
> a new VMA, so we wouldn’t search B anymore—is that correct?

In both cases folio_move_anon_rmap() changes folio->mapping. In the anon_vma
case, it moves it to the 'leaf' anon_vma, in the Cow context case it moves it to
the leaf cow context.

For CoW context we stop looking past the first CoW context if
!folio_maybe_mapped_shared().

So the usual situation will incur just the same amount of walking (but some edge
cases might be slower yes)

>
> >
> > For instance, with anon_vma, if you CoW a bunch of folios to child process VMAs,
> > the non-CoW'd folio will _still_ traverse all of that uselessly.
> >
> > In any case, this isn't a common case.
> >
> > However note that if a folio _becomes_ anon exclusive, it switches its 'root'
> > cow context to the one associated with the mm which it became exclusive to.
> >
>
> Agreed. I’m curious about the case of A’s folio, whose VMA has been
> completely replaced in B after the unmap and map. In the old anon_vma
> case, we wouldn’t search B anymore, but now we’ll need to check B's
> vm_pgoff since it covers the folio’s address—is that correct?

It's anon exclusive so we wouldn't bother looking past the first CoW context
level.

If it was shared we might do a useless work, yes. But again I think a rare case.


> > > If we have multiple remaps for multiple VMAs within one mm_struct,
> > > will we end up traversing all the dynamic arrays for any folio that
> > > might be located in a VMA that has been remapped?
> >
> > Yup. But there aren't all that many, and it's all under RCU so :)
> >
> > That part of the search should be quick, parts of the search involving page
> > tables, less so.
> >
> > Also I need to figure out how to maintain stabilisation without an rmap lock, an
> > ongoing open problem in all this.
> >
> > In the end, as the original mail said, I may conclude _this_ approach is
> > unworkable and come up with an alternative that's more conventional.
>
> I’m genuinely interested in the new approach. If you have the code, I’d be
> happy to read, test, and work on it.

I've posted on the thread, but it's very much a proof of concept and
stabilisation is currently broken so it's not in a testable state YET. But you
can see the rough shape of it now:

https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git?h=project%2Fcow-context

>
> >
> > BUT. Doing it this way saves 30x the amount of kernel allocated memory. I tried
> > a heavy load case and it was very substantial. That's not to be sniffed at.
> >
> > In any case, all of this is going to be _very_ driven by metrics. How slow is
> > it, how much overhead does it actually produce, is it workable, are the
> > trade-offs right, etc.
> >
> > It's an exploration rather than a fait accompli.
>
> Right now, I’m still at the stage of trying to understand the details of
> your new approach and would like to learn more—so I might have quite a
> few naive questions :-)

No problem, you will never ask anything more naive than what I might ask and I
may very well have made some very naive mistakes so :) health to discuss it I
think!

>
> Thanks
> Barry

Cheers, Lorenzo

