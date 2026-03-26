Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 406AB10AB808
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 19:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8157E6B0005; Thu, 26 Mar 2026 15:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C67A6B0089; Thu, 26 Mar 2026 15:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B55B6B008A; Thu, 26 Mar 2026 15:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A60D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:16:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A57B2BDEAA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:16:12 +0000 (UTC)
X-FDA: 84589169784.22.1208337
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4FD961C0004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:16:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=heYFtTcT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dGJKJTj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=heYFtTcT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dGJKJTj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774552570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0NbDm8sagJWivXfmEO6jIG8gF17/iZfDl2XnEm6e1I=;
	b=PUHzqpie68+9EdCpaU85iGG/ZS+tbNX5YeYRnY5KpYd54d/DY893Urd+sw9biwzdFNARs7
	Qm2pcRGmWQJQXA6BqOYnL0fQmm1RaG8V+qYmEzGRmsHs5aK7mw9PBQuycV4EStkcb4uBkj
	qn43OmQWH5EDpJ9kcijk2PPgViY+qH0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774552570; a=rsa-sha256;
	cv=none;
	b=3lTzdFvBzaxKfshd2ZhIaa7JQuL5mSBxCYvln/1o5okNQgsz7Xwxn3KkWCRz7utvMFFc3D
	ZXD9lQ5nvz6QTHDDUw2+29Puw7z/AyW0YRXjMgSwkeqRqZnKv6CQ95qxokL430MeeuaNPP
	MZ7qjOjy2vgZtE+74iGrs2h3CFoHUvI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=heYFtTcT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dGJKJTj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=heYFtTcT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0dGJKJTj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AA56A4D2E0;
	Thu, 26 Mar 2026 19:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774552568; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B0NbDm8sagJWivXfmEO6jIG8gF17/iZfDl2XnEm6e1I=;
	b=heYFtTcT6JppGXGa3o5gocTipUKt8/yAvzZ63BnHcvLNPZ+G50GPIdrndDeCfev63J2seZ
	EUwHZ9Tyz3SL0ME2XwEaU1cUHhjrEWNNOjAeNrop+6s3B8XYSLZMcJ3z1fRL6RqMO4za4s
	82zZCw+Yq+2Hq97xbteAuhMHxjsN8y4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774552568;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B0NbDm8sagJWivXfmEO6jIG8gF17/iZfDl2XnEm6e1I=;
	b=0dGJKJTjS6j9TAbaFDxJIlSYwxPIgxZ8Zis7ILt8c7OJOv9zsWnmYpQ4/ffU/Fmsicw1Xo
	Kl7tOFOE8PAjn4BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774552568; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B0NbDm8sagJWivXfmEO6jIG8gF17/iZfDl2XnEm6e1I=;
	b=heYFtTcT6JppGXGa3o5gocTipUKt8/yAvzZ63BnHcvLNPZ+G50GPIdrndDeCfev63J2seZ
	EUwHZ9Tyz3SL0ME2XwEaU1cUHhjrEWNNOjAeNrop+6s3B8XYSLZMcJ3z1fRL6RqMO4za4s
	82zZCw+Yq+2Hq97xbteAuhMHxjsN8y4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774552568;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B0NbDm8sagJWivXfmEO6jIG8gF17/iZfDl2XnEm6e1I=;
	b=0dGJKJTjS6j9TAbaFDxJIlSYwxPIgxZ8Zis7ILt8c7OJOv9zsWnmYpQ4/ffU/Fmsicw1Xo
	Kl7tOFOE8PAjn4BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A14874A0A3;
	Thu, 26 Mar 2026 19:16:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id erZ6I/eFxWl1UwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 26 Mar 2026 19:16:07 +0000
Date: Thu, 26 Mar 2026 19:16:05 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com, 
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	baolin.wang@linux.alibaba.com, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Message-ID: <bnukmnuxxuhdfeasjz33miemgr7w35c4aa6pqdmgupx7oxmeeb@gozgc3yxhcdd>
References: <20260326162611.693539-1-gourry@gourry.net>
 <jm5rmcwiauy2fn6fvj6cjowiu2dudjndhhlcd2tm275ibmos5i@dwxwchbs24ko>
 <acV83cdc9ZfNk8Xh@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acV83cdc9ZfNk8Xh@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 4FD961C0004
X-Stat-Signature: 363c37e3kqnwr4qm3mtzpfxbajsumirf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774552570-239113
X-HE-Meta: U2FsdGVkX1+KzJOVAO9vPx2YFfp+JLWY/mqiFvcgeKbPAE1gEMSMuvppxIq0j9m0t3GB1FZW3eF6Yn8FueQzclZynm/C2O2N7BOEITJxEmt1/oLyOn5aiwN706WH/HLQW/u1K/GhJLMfxMVtSI0RGwSKd1BHyBk9FDjdnSlpdIp9pvHfALr8QGRu0HctR29J9CTHu5GqWUrRh7ljGT271LLUEHZHM2x1rPa/z+ldmn8evil3JQKlfIOFsZ6J1Skqq/V3bmbNjo27cIR4ODRopwRBA2NeYDwYpg+aIaj+HMgcJUFKBUqjlZtwflgnZmb+b2nXeMIj/W1gqstnD0nJs6zAanuA69dCEcQmkx/p82mbDBrcV6dktsrY9+5b0QT9M5gIqug23jlNpv9NO+vP6f+y7TLvyq95ec8IbNTM+YCnDcYYD4jx0Ekm2SzPcVypd2vmzhYss8wgeR2prksPe16pUzg/8vM2nF6TnPrDypnUxDeiXwcvwkz22hFy9pE2L1TebCt2kQtoV/2ADGaSuB5vMZ9or+2M4V8aFovInOelfdiJjPOUzpzXTajSbzXtxIrYcQK3VljN9Ol0u+kBTsUT3R9loNzUaK+XLffZx2X5rpX/uM70PSDeNxqHX57SvHmvyjxIl1W/V/v3ZNh3u6rFcTvi2v413mjksJ8X6xz46T1NjBAE9z1ID+yPgAoJdHoWS4f3nwXu3x8yKe9AqUQvI5prl6/LA3w9Bdp//fkNzAyYGveMJtPltKyMhg2gAlRcVDrHTgXtt9DJk3WUc02LSyewnXkmdnUh/7oPyBwczsmM2B8bjIN+dIrJKjLkXDnnDm2GNnmAa3E6eDZV5twTc9JVa/MacwbHx3hapy798+MHSl2KiukkB+XQr2KPaRFOG2QUyv+H1yrUo3p4D2iY130YufehhoeKc27Ky45o9QTrGEEymx7zoWA69xlTYH6yxR9wZcKidSSqMoK
 Y6Upgt3j
 sg2zAShfAZU5bunbirxt0zNCFM0t849qT155UQt3tbBN1++t8WZxVCzcguQoog50/T2xKmMEOgvc9WfoVFP4Q0EkEF1SADQdKvPYXfihP1Uj9kZZJUQqi/sSmfQGwir/KEG8xLeveQfpGPXoGnT6hBbOKHKpJexcAnRorr9pcp9AL2VTpriJn42I6lTcn3Z7Yu93RqiNDqmuptKuH69zj1FWH3ot/OafF2cAeV7pK9LqWrUfoiKSb0u/pggoUqtfC92jFZ5HuzOnzcbDzEqial/1j8YzMtRc4DhAPq9SG08UeylUgeb0nzhQnovdPj+zP560FPX4WiOnLP3PYx7/WPRJRamNqBE2tY8Tl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 01:37:17PM -0500, Gregory Price wrote:
> On Thu, Mar 26, 2026 at 05:07:42PM +0000, Pedro Falcato wrote:
> > > Two races allow PTEs to be re-installed for a folio that fallocate
> > > is about to remove from page cache:
> > 
> > Hmm, I don't see how your patch fixes anything.
> > 
> 
> after looking at your comments below i realized race 2 actually requires
> the fork as well, which means they're both essentially variations of the
> same race, so hopefully i can simplify the change log.

Well, then I don't see how changing shmem_fault() & map_mages() fixes fork.

> 
> > >   fallocate              fault-around           fork
> > >   --------               ------------           ----
> > >   set i_private
> > >   unmap_mapping_range()
> > >   # zaps PTEs
> > >                        filemap_map_pages()
> > >                         # re-maps folio!
> > >                                               dup_mmap()
> > >                                               # child VMA
> > >                                               # in tree
> > >   shmem_undo_range()
> > >     lock folio
> > >     unmap_mapping_folio()
>                   ^^^ i_mmap_lock_read held, iterates VMAs
> > 	spin_lock(ptl);
>                   ^^^ child VMA's PTL
> > >     # child VMA:
> > >     #   no PTE, skip
> > 	spin_unlock(ptl);
>                     ^^^ child VMA done, iterator moves on
> 		        it will not re-visit the child.
> 
> > >                                             copy_page_range()
> >                                                spin_lock(dst_ptl);
>                                                    ^ Child PTL
> > 					       spin_lock(src_ptl);
>                                                    ^ Parent PTL
> > 						/* does not copy PTE. either
> > 						 * we find a zapped PTE, or unmap_mapping_folio()
> > 						 * finds two mappings instead of one. */
> 
> At this point, unmap_mapping_folio only processed the child VMA
> (no PTE, skip). The parent PTE *has not* been zapped.
> 
> copy_page_range() acquires src_ptl (parent) and reads a present PTE,
> and boom copies it to child.

Sure, but can child - parent happen when traversing the i_mmap tree? I don't
think so? (in mm/mmap.c)
	/* insert tmp into the share list, just after mpnt */
	vma_interval_tree_insert_after(tmp, mpnt,
			&mapping->i_mmap);

The function itself is somewhat straightforward - find the leftmost node at the
right of 'prev' (our parent) and link ourselves. So an in-order traversal should
always go parent - child. Unless there's some awful tree rotation that can
happen and screw us in the meanwhile.

> 
> When it reaches the parent VMA next, it zaps the parent PTE,
> but the child PTE (just installed) survives.  
> 
> > > 
> > > Fix both races with invalidate_lock.
> > > 
> > 
> > I don't see what you're seeing? Note that both map_pages and fault()
> > take the folio lock (map_pages does a trylock) to exclude against truncate
> > as well.
> > 
> 
> The folio lock serializes map_pages/fault against truncate - but the
> race isn't between those two. It's between truncate's unmap walk and
> fork's copy_page_range - and copy_page_range doesn't take folio lock.

If we observe everything parent - child, there is no way this is broken - if
fork observes the parent pte set, zap will have to observe parent *and* child,
since they hold the corresponding pte locks, and traversal is done in order.
If fork observes the parent pte as none, zap will have already traversed the
parent, and as such there will be no additional mapping of the folio.

If this is broken, then every filesystem out there using filemap_fault() and
filemap_fault_around() has to be broken, and I hope that's not true :p

_If_ there is indeed breakage here regarding tree rotations, I would suggest:

diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..7b4e39063d67 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1833,12 +1833,12 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
                        vma_interval_tree_insert_after(tmp, mpnt,
                                        &mapping->i_mmap);
                        flush_dcache_mmap_unlock(mapping);
-                       i_mmap_unlock_write(mapping);
                }
 
                if (!(tmp->vm_flags & VM_WIPEONFORK))
                        retval = copy_page_range(tmp, mpnt);
-
+               if (file)
+                       i_mmap_unlock_write(mapping);
                if (retval) {
                        mpnt = vma_next(&vmi);
                        goto loop_out;


which should protect against concurrent rmap.

-- 
Pedro

