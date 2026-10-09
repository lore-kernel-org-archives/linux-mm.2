Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B17CCA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 08:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB016B008A; Fri,  9 Oct 2026 04:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C696B008C; Fri,  9 Oct 2026 04:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C736B0092; Fri,  9 Oct 2026 04:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEC6C6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:41:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94AA4A6653
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:41:27 +0000 (UTC)
X-FDA: 85302443814.23.C71F603
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6428DC0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:41:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791535285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lY/UkVyO7TlE8Pkq8dBJi8n2CXg92CJMf1OzgLUi588=;
	b=rWOA7NF82D03M0Zh8QAXX+HBuEJFCAumwvEd80LSpnWdUFee5nRbLZSx93Kbah9dEnIxcZ
	TG727dBvq3TcwmWora3/qyo3PgVr2oHvFvPLPUCDz3uvxyRGcMCucCLhWyz/xA5emb+zEd
	CiUQtG3OSUaegXREO97nMa9KLtOEs1w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791535285;
	b=7aoKzSaDinUrLmv4C2dpd1K4n5pfoeGc0R2ID1fsMPZoVeBwN4P6ZpO8HZpnxd0eDUum84
	PPsWNvTUwkRSMfOMjyb/6hPMHdnALUxyaToF1XjdwdGhpgad99amrfeW1W9Fi2WIKAdYVt
	esTqMBpoOJyTqflbkb5JCqGLkbqvZc0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DDF9C21BB2;
	Fri,  9 Oct 2026 08:41:23 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 010E11326D;
	Fri,  9 Oct 2026 08:41:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C4YwMLKoyGpkJgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 09 Oct 2026 08:41:22 +0000
Date: Fri, 9 Oct 2026 09:41:21 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Ayush Ranjan <ayushr@modal.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-ID: <asigKktcrSY80A_2@pedro-suse.tail5790ac.ts.net>
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
 <20260925053027.1998394-1-ayushr@modal.com>
 <20260925065013.3682431-1-ayushr@modal.com>
 <20261003033107.1488699-1-ayushr@modal.com>
 <20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
 <fyswoh7wpxzlbnjjanggjd2jz6yispmeirhwjl3wzi57nacddb@bjkb6kxyfcal>
 <fbb046b9-be48-42d8-96b3-7e554484b625@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbb046b9-be48-42d8-96b3-7e554484b625@linux.alibaba.com>
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Queue-Id: 6428DC0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: r9ryccqwc7uhxk5uhumpdcfobmjq6oag
X-HE-Tag: 1791535285-64786
X-HE-Meta: U2FsdGVkX1/bLqKFBqaWSH4iw1tOPdXMv9pYznfd3vK80UmiOH1AwEnj56coyzdJ3bf8C+ZV6AyWNC8JmsIRtJRPfj3qnQOmroD/rfLoBHoHkBcE3Oe4KGj+S2E6eZf/gjL405a3Nb/yMZiwhRlL6phseKAWncuI1lGmLVcDipYhKBmyrTLaDbXipj9WOI5qWSysWmYOmYHt5Ri5ZztjRj/fSwkkq1kAAdabb6d5y0GNnm/L9SrlHRzKR3cypidaRGxDcX7ObIcPUYf7hD7QWcA9+yQvtQmXp4vSgTmCgxMFfQgFecUeHGSg/4t58UPioUyE86JdVvrFwmnGiF3il3JvTU5jp/DutIdE3YYiBUr7EcNf5U0LAUXA/boTn98X/NVeEYhH5LhKuAYW8MVVJ1WWq1h3pHL8jNpxP1UrPRFkNDTRhcehmkeiadjvM+UdXz4ouGRMBO2NRCiwMTnMW4upumecP9zX9Ph1hK9Mls7LtvIDCGr64BZxXQh87BgyccDnlYSQ7jD5iH4WDieugvV8/odnErM43WdPNNypbm25kCW9gVWI/KsxRjA6koutnfFFH9uncc+OXhQi7Mvvzz8Bnv5fCw5BYTq/VAOvQdWdR3qZ1K/JDN2KzIBfeKKn12p5uyA+1qeUafiFK40wKtsg+K6WhMOOi4+nPj04vRQpQWzGN2rx9toTB1U7j2vUSIQoPEvblE7sUfgxlVmoqeX9OzOh/hxQzUUfMlv3F3oRX3wMjRJdzhmiD9RGhCpPQNGGDSQzF8LmvCAX3vxpT6YiJkySXuSaVvjVCzD0RnikYu/wKSklHmxoEYmV7H4AcYpJ9QaXLrGloGKKARHHXSSt8yI+DIXO8PWTt6l/b4NBlD5whWtnpuJMfWkCKNSWbY6vWM9TOiYbhBiMbaqm2lsjEuz3pHOyxKQ2WPD9OTsdNIg8Z9wdLlFX1XgNBWL2EnPOueGPQwYesowFXpN
 13VVTIsc
 I/3084BA3Vg+fuU4V4JBVeWQ1a5ItPItli8OMu3jVB9TTGWkVR5MGxvYM1tFfUk2DngH6y6gu7etKNNc8nsIqkROdF8OeaT+BVFQyayYL7gja/IhMOpNHpTaFFdcxqLjzs0PyHcpW5ZKClGLcT77r4dMMrg7gmvfLVcJyNsHrzyobtdIQMIzhWSD5VY3kYIy+9+wEVHba2/aw509sMv1dN5LE30hT60lCN/9Q3ZL2bNJUOpBeUfls5YuWGJQjkCXoPn4uBdBiWPEiz7cA71wYr71j6OGUEg2pOY3zb7RufU5T0e4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 02:46:18PM +0800, Baolin Wang wrote:
> 
> 
> On 10/8/26 5:24 PM, Jan Kara wrote:
> > On Sun 04-10-26 22:28:31, Andrew Morton wrote:
> > > On Sat,  3 Oct 2026 03:31:03 +0000 Ayush Ranjan <ayushr@modal.com> wrote:
> > > > Gentle ping on this. The reproducer in my previous mail [1] triggers
> > > > "Bad page cache ... still mapped when deleted" on 6.18.46 within a
> > > > couple of minutes on a 128-CPU bare-metal box, with no fork() and no
> > > > gVisor involved.
> > > > 
> > > > We continue to hit this in production at low frequency, so I am happy
> > > > to test patches or collect more data if that would help.
> > > > 
> > > 
> > > fwiw I made gpt and gemini argue about this for a while and ended up
> > > with the below.
> > 
> > Worth a try I guess. Let's see :)
> > 
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Subject: mm: shmem: serialize fault-around against hole punching
> > > Date: Sun Oct 4 09:05:31 PM PDT 2026
> > > 
> > > shmem uses filemap_map_pages() for fault-around.  Unlike shmem_fault(),
> > > filemap_map_pages() does not participate in shmem's fallocate exclusion
> > > protocol.
> > > 
> > > During a partial hole punch of a large shmem folio, the folio can be split
> > > and the resulting smaller folios can remain temporarily visible in the page
> > > cache while shmem_undo_range() restarts its walk.  Fault-around can then map
> > > one of those folios again before the hole-punch path removes it.
> > > 
> > > shmem_undo_range() may subsequently delete that folio from the page cache
> > > despite the new userspace mapping.  This can trigger "still mapped when
> > > deleted" warnings and leave stale mappings or inconsistent RSS/page-table
> > > accounting behind.
> > 
> > So this part of explanation is either incomplete or wrong in my opinion.
> > Yes, shmem_undo_range() calls truncate_inode_partial_folio() which can
> > split a large folio. Yes, filemap_map_pages() can map those pages back into
> > page tables. But how "shmem_undo_range() may subsequently delete that folio
> > from the page cache despite the new userspace mapping" happens is unclear
> > to me. After splitting a folio, shmem_undo_range() will restart and find the
> > newly split (and mapped) folios and calls truncate_inode_folio() to get rid
> > of them. Now truncate_inode_folio() calls truncate_cleanup_folio() which
> > does:
> > 
> >          if (folio_mapped(folio))
> >                  unmap_mapping_folio(folio);
> > 
> > so the mapping is reliably removed under folio lock. Can you perhaps push
> > your agents further to explain in more detail how this "still mapped when
> > deleted" happens in their opinion?
> 
> Good point and I think you are right.
> 
> Yesterday I quickly reproduced the issue with Ayush's reproducer, and I got
> the following crash info. From the dump message, we can see that
> truncate_inode_folio() is really trying to remove mapped folios, which is
> incorrect.
> 
> I also quickly tried Andrew's patch, and the issue no longer reproduces, so
> I initially thought that was the root cause. But after your reminder, I now
> believe Andrew's patch merely workaround the issue rather than fixing the
> actual root cause.
> 
> Today I'm going to re-analyze the race with the reproducer (thanks Ayush).
> 
> After analysis, I believe the race exists between truncation and
> MADV_DONTNEED, and shmem's fault_around() merely makes the issue easier to
> reproduce. Since MADV_DONTNEED synchronously releases the pagetable page
> before calling tlb_flush_rmaps(), this could cause another thread's
> truncation to skip zap_pte_range() but still observe the folio's mapcount as
> non-zero. A possible race scenario is as follows:
> 
> CPU 0				CPU 1
> 				madvise_dontneed_single_vma
> shmem_fallocate			......
>   ......			  zap_pte_range
>   truncate_inode_folio		    zap_empty_pte_table(pmd clear)		
>     unmap_mapping_folio		
>     ......
>       zap_pmd_range(saw pmd none)
>     filemap_remove_folio
>        BUG_ON(folio_mapped)
> 				    tlb_flush_rmaps

Thanks for the investigation!

So, I think I understand the problem (rmap walks race PTE zapping, which no
longer serializes on the PTE lock), but I don't understand your solution at
all.
> 
> Based on the above race analysis, I made the following fix that uses the PMD
> lock synchronously to prevent this race, and the issue no longer reproduces.
> I will clean it up and send out a formal patch.
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6a8e7772b8d6..2039ada99b64 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather
> *tlb,
>                 }
>         } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
> 
> +       add_mm_rss_vec(mm, rss);
> +       lazy_mmu_mode_disable();
> +
> +       /* Do the actual TLB flush before dropping ptl */
> +       if (force_flush) {
> +               tlb_flush_mmu_tlbonly(tlb);
> +               tlb_flush_rmaps(tlb, vma);
> +       }
> +
>         /*
>          * Fast path: try to hold the pmd lock and unmap the PTE page.
>          *
> @@ -2046,15 +2055,6 @@ static unsigned long zap_pte_range(struct mmu_gather
> *tlb,
>          */
>         if (can_reclaim_pt && direct_reclaim && addr == end)
>                 direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
> -
> -       add_mm_rss_vec(mm, rss);
> -       lazy_mmu_mode_disable();
> -
> -       /* Do the actual TLB flush before dropping ptl */
> -       if (force_flush) {
> -               tlb_flush_mmu_tlbonly(tlb);
> -               tlb_flush_rmaps(tlb, vma);
> -       }
>         pte_unmap_unlock(start_pte, ptl);

Namely, why moving this hunk of code up there makes any difference.
I suppose it's subtly changing memory order, but it's not immediate
in any way why this is correct.

What you really need (I think) is a happens-before relationship between
the rmap changes and the PMD zapping. Something like:

diff --git a/mm/memory.c b/mm/memory.c
index 330cde31bf8b..17cdd48fff27 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2108,6 +2108,13 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
                        sync_with_folio_pmd_zap(tlb->mm, pmd);
                }
                if (pmd_none(*pmd)) {
+                       /*
+                        * Pairs with tlb_flush_rmaps() in PTE zapping.
+                        * Possibly skipping a page table (due to PTE zapping)
+                        * needs to enforce ordering between the rmap changes
+                        * and the PMD getting cleared.
+                        */
+                       smp_rmb();
                        addr = next;
                        continue;
                }
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 9f353f0e2ef4..47b25c42bf77 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -89,6 +89,10 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
        tlb_flush_rmap_batch(&tlb->local, vma);
        if (tlb->active != &tlb->local)
                tlb_flush_rmap_batch(tlb->active, vma);
+       /*
+        * rmap changes need to be observed before e.g PTEs get zapped.
+        */
+       smp_wmb();
        tlb->delayed_rmap = 0;
 }
 #endif

On top of your diff. Where the smp_wmb() is perhaps not required: I suppose TLB flushing
works as a sort of memory barrier itself on most/all architectures.
Either way, we have to document and fix expectations around this code.

> 
>         /*
> @@ -2103,7 +2103,6 @@ static inline unsigned long zap_pmd_range(struct
> mmu_gather *tlb,
>                         }
>                         /* fall through */
>                 } else if (details && details->single_folio &&
> -                          folio_test_pmd_mappable(details->single_folio) &&

Why?

-- 
Pedro

