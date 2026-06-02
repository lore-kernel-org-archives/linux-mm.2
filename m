Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5785CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCB36B008A; Tue,  2 Jun 2026 13:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4346B008C; Tue,  2 Jun 2026 13:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3346B0092; Tue,  2 Jun 2026 13:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C11F76B008A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:46:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63F35140A40
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:46:41 +0000 (UTC)
X-FDA: 84835702602.14.AE21C80
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5705F1C000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:46:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nK22Too0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="BzM/vvSp";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k1DfIejH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ilnX90mN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780422399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuMw0XP6ELPe+cm6ErdVU/bLeUkouF/KNF0MaMkAslk=;
	b=DfT7HbsV+KUaTU11F+eFmlNMKuQz+T5RFo0wzUYfsqzZwo0R0cJG0bxIWOF7cYNRXFpHKM
	uDGaCnJbKdm5hsv0THa2pXAzrlxRALpczFFG7N6hENp6JoAPiUWZGFX7s5Re7EFWObtPG0
	QK1IPPmULi7ORMP72HryfoGXBn5ells=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nK22Too0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="BzM/vvSp";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k1DfIejH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ilnX90mN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780422399;
	b=lFIB8mGU2wvy/PAc2VFpvKJrbX2rNXsVdca6gkuFcE4F/2oZu6dQCaPkJOSznXey/rkTV3
	PPxuC1sElYCItgTxyH6DNv4Wfl7Q6oh95xu1EIwk9jLNpLh0eAiMNSuJX55hgl1ayBSFPr
	EZGKQo6dHjn/cBG+yBVlutT1a60UP38=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC1C66B23F;
	Tue,  2 Jun 2026 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780422398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuMw0XP6ELPe+cm6ErdVU/bLeUkouF/KNF0MaMkAslk=;
	b=nK22Too0AOrBD1x0yqMvCNHtXGpYGbXIQIh+9JuUbolbu13rClZ7cEQwCVBEpCxAkz2+lR
	k4xJpxwuKski9CsGzogPozU0Fisoo8I7swxmWrj/TH9ywRAzy1VqTzhEkbivRWptnob7Qd
	50Bew2HN5IOFfjFmh+m2e2yGhmOFj3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780422398;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuMw0XP6ELPe+cm6ErdVU/bLeUkouF/KNF0MaMkAslk=;
	b=BzM/vvSp8Wf+nGps5rztT0j5NRDpOX38AkDy6Sp3Zw5XOy1fO3Q84wm7WW2uhp9lEYqFKJ
	SLqNDJisMJ7wdJAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780422397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuMw0XP6ELPe+cm6ErdVU/bLeUkouF/KNF0MaMkAslk=;
	b=k1DfIejHfWIM44A9nh6+tWNpezMinj8qDvSYvYf5YznRvrhQowYoRTECcUp5tJEJJnbdwl
	J/Q1ECVuYdqwqEzdI7HfuOmr12HLti8Qq3Y+q3QNck8POi3mmK1sWBVM04B12afvzmrppV
	7NEuoUfOeSnKqbL4oXabunIqOFzlksM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780422397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuMw0XP6ELPe+cm6ErdVU/bLeUkouF/KNF0MaMkAslk=;
	b=ilnX90mNyOgzvxbmB+RGPk4idEuuUy+9VUNbLgKyXZ6tuGm0J27Xbi0tNjRfS6TVhIVsdK
	N2jYntLd7bomCuCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3AFC779A7;
	Tue,  2 Jun 2026 17:46:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /eemI/sWH2oCNAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 17:46:35 +0000
Date: Tue, 2 Jun 2026 18:46:33 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: willy@infradead.org, jack@suse.cz, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	r@hev.cc, Andrew Donnellan <andrew+kernel@donnellan.id.au>, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org, 
	kevin.brodsky@arm.com, lance.yang@linux.dev, "Liam R. Howlett" <liam@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
Message-ID: <ah8UmnLyUOKflNz3@pedro-suse>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
 <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
 <ahmSolHvUChl-3vM@pedro-suse.lan>
 <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
X-Rspamd-Queue-Id: 5705F1C000F
X-Rspam-User: 
X-Stat-Signature: zahoymqmngcydk4yti7grdpm55tbz9th
X-Rspamd-Server: rspam09
X-HE-Tag: 1780422399-787595
X-HE-Meta: U2FsdGVkX18GGCzP7iSMDv00eZo2yWCmRs/VpzA/xADSlpxjiT2Gbga0aiPAKp0Lsvb3rVKg7JbTSHYqLANjS+IIlPYdXdfV7CL0fzT5wqEBJcTlEpsElSwpgjjWCvEYUQaHts0LIUTNg8ZiZO4uMvWyxriB1mGrJE6hCN8sMvNN3dyaFiSe4eG54UxZwfBMgFy7P15vgyOg0gsWowd22xny4rI/a0Ly7PINxC8+o1LVzuUrlvYsfp+6Jt7lpmTMp2KJdcYWGEbP4dk6/AiVsBx0V1axZXZENt0FdVHRxIcB82LkzY0cCNufb+R6cLppk3mp1cDAoGdWMy/RemdFeqpYQbdBfHW4+1iqSqT5OYe+yrxvTw4+MxInAPk/FxyUE18436bPAZzCb+XxdababETst64UTANYDUe7o5Qu4quMzJbsqG4njsXEmuOAQgouKqu5R8lMOXb4N2zVpKtZf4QoWPCZ5ZrbMw0ITTyneX9hKL8gDkA/h+ooogX9v2gzLjZAq61aGxCtrCwr2Tyn9h0JZyy40EF+AvNsQVyHnNmGmTRM/vuCiQpyiNd5NhbVh37BkMWxnRL89MrXOZkLawhNOjBTacNR+v7s27+TImCMUaouShcvjpyuRtZ6yKko8z9ouzX24BxbEXlBjSiT3Fzvu2NLzI4Xdc9IGv2XX85IP3Pmvm0mTsePCwa2DXdOe7pin5ngwYdBsVpsNUBc1leqEp1QnsZeA7rS7jS8b2Hf4ZXhIej/NPGaeCa+YsHNgHjvDmAQwddX8rsUJ8PpvNLIYdJWcSTMwpPxCr6Nblo86jKzY1Aj4F5Aj5ifUj2Rsn01kHDpoQR2NSjJYQbaMteQ5OujvjWyvl6go7EQI3Uo0iGbgNjyQ4Zb6AaqnPphlWVBy9eCExlMOsU6QzSYpLFUbF/VOLDKoBi+66DCKrrO3fcHZ05Q2hw28RzhoDVPH8H0kr4Lfx0Vvi9fo25
 zblG+QvR
 fasObylNvcGpgLpenZKxnIAjDCpvu8mxbirwsLkBOQY0SveabteVwtaOSBq/6Or973mpEpv+Z0JGZmnjN1WWwEvQPjwo0WnSsxbjiHGZXWzRkUxNg272MEft3RRQXs5Vw1MOObKGigpQPiJJt9lsoOBiF0mH/anvvn7KT4UA5S0yv9qxjAuCuQtgB7yer1GQrjQxqZLZOYCgkgpl12aE6a1+BPaebK5xAcvYyg7qLu2K/3agbK9DCxLFY/+Luavm/yp7WOEf7+dGJmTKgK9pdV9qWE+IhPcNeC3Qiu/E0lOvG7NmKcQRJ4x2ZnlgrJQE3JzOqjrADy0ss/4h5dYBuK2SfQos8pwtcVybfn10x1fhD3Qwrq7k7VY/q6ZtknQr0LPWeE5xrSpxmVntit0VQGUdtbRXZjTdyiKO35ADnru26nZG0cZrHLIoXtc94Nfc5ObfmtWsiniqjxbKHYlejqW3xLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 03:11:54PM +0100, Usama Arif wrote:
> 
> 
> On 29/05/2026 14:40, Pedro Falcato wrote:
> > On Fri, May 29, 2026 at 01:19:03PM +0100, Usama Arif wrote:
> >>
> >>
> >> On 29/05/2026 11:01, Pedro Falcato wrote:
> >>> On Thu, May 28, 2026 at 09:55:20AM -0700, Usama Arif wrote:
> >>>> The force_thp_readahead path in do_sync_mmap_readahead() is gated on
> >>>> HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
> >>>> HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
> >>>> exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
> >>>> VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
> >>>> mmap readahead path even when the mapping supports useful large folios.
> >>>>
> >>>> Keep the existing PMD-sized behavior when HPAGE_PMD_ORDER fits in the
> >>>> page cache. When it does not, enable forced readahead for mappings that
> >>>> support large folios and request an order capped by both
> >>>> mapping_max_folio_order(mapping) and 2MB.
> >>>>
> >>>> 2MB is chosen as the cap because it matches the PMD size on x86_64
> >>>> and on arm64 with 4K or 16K base pages, so the size/memory-pressure
> >>>
> >>> 16K base page size's PMDs should be 32M, no? Am I misunderstanding what
> >>> you mean here?
> >>>
> >>
> >> Yes, should have just said 4K. Messed up when rewriting the commit
> >> message. Andrew Thanks for merging in mm-new, would it be possible
> >> to remove "or 16K" from the commit message. I can send a new revision
> >> as well if that is easier and preferred.
> >>
> >>>> tradeoff for folios of that size is already well understood. On arm64
> >>>> with a 64K base page size, 2MB is also the contiguous-PTE (contpte)
> >>>> block size, so the resulting folios coalesce into a single TLB entry
> >>>> and reduce TLB pressure on the readahead path.
> >>>>
> >>>> The final allocation order may still be clamped by page_cache_ra_order()
> >>>> to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
> >>>> on such configurations a large-folio readahead request instead of
> >>>> dropping back to base-page readahead.
> >>>>
> >>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >>>> ---
> >>>>  mm/filemap.c | 27 +++++++++++++++++++--------
> >>>>  1 file changed, 19 insertions(+), 8 deletions(-)
> >>>>
> >>>> diff --git a/mm/filemap.c b/mm/filemap.c
> >>>> index a16b33e0fc71..bfb891d9da1f 100644
> >>>> --- a/mm/filemap.c
> >>>> +++ b/mm/filemap.c
> >>>> @@ -3312,14 +3312,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >>>>  	struct file *fpin = NULL;
> >>>>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
> >>>>  	bool force_thp_readahead = false;
> >>>> +	unsigned int thp_order = 0;
> >>>>  	unsigned short mmap_miss;
> >>>>  
> >>>>  	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
> >>>>  
> >>>>  	/* Use the readahead code, even if readahead is disabled */
> >>>> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> >>>> -	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> >>>> -		force_thp_readahead = true;
> >>>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
> >>>> +		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
> >>>> +			force_thp_readahead = true;
> >>>> +			thp_order = HPAGE_PMD_ORDER;
> >>>> +		} else if (mapping_large_folio_support(mapping)) {
> >>>> +			force_thp_readahead = true;
> >>>> +			thp_order = min_t(unsigned int,
> >>>> +					  mapping_max_folio_order(mapping),
> >>>> +					  get_order(SZ_2M));
> >>>
> >>> This looks somewhat arbitrary to me (as does the old logic). It seems more
> >>> natural (correct?) to do this:
> >>>
> >>> 	if (THP_ENABLED && (vm_flags & VM_HUGEPAGE)) {
> >>> 		if (mapping_large_folio_support(mapping)) {
> >>> 			force_thp_readahead = true;
> >>> 			/*
> >>> 			 * Cap THP readahead to either the max folio order the
> >>> 			 * mapping supports, or the max order the page cache
> >>> 			 * supports (useless to try more), or the hugepage PMD
> >>> 			 * order (CPU can't benefit from larger).
> >>> 			 */
> >>> 			thp_order = min3(mapping_max_folio_order(mapping),
> >>> 					MAX_PAGECACHE_ORDER, HPAGE_PMD_ORDER);
> >>> 		}
> >>> 	}
> >>>
> >>
> >> So this can result in extreme memory pressure. For example, on 64K base page size,
> >> with HPAGE_PMD_ORDER = 13 (512M) and MAX_PAGECACHE_ORDER = 11 (128M), this will evaluate
> >> THP order to 128M. I think Jan mentioned in previous versions that there are already
> >> reports of high memory pressure due to large file folios, and we are seeing this
> >> in our fleet as well with xfs.
> >>
> >> I chose 2M cap as that is what most (not all) architectures which currently support this
> >> hugepage code flow are currently used to, and on archs + base page size combination which
> >> just evaluate this code to base page, for example 64K base page size, it will provide a
> >> performance uplift without causing excessive memory pressure.
> > 
> > For what it's worth, memory pressure is still a problem even on 2MB folios. But
> > yes, I understand.
> > 
> > For what it's worth, I don't think it's such a big issue in this case - you're
> > asking for THPs, and you're getting them - though maybe not efficiently because
> > these aren't at the PMD level. But this is also true for e.g x86 where an
> > an order-3 folio or order-7 folio are completely useless for the hardware, since
> > there is no mTHP to speak of (and, with that, you also lose PG_active and
> > PG_reference precision as you only keep one of each for each folio, amongst
> > other tradeoffs).
> > 
> 
> So there is hardware TLB coalescing on almost every new AMD CPU, I believe it is
> at 32kB, and we would benefit from that. On top of that, we would reduce pagefaults.

(just addressing this, because everything else was addressed in some other ways
and I'm just going through my email backlog; my apologies for the delay)

AMD's TLB coalescing feature requires (as far as I know) A and D bits to match
for every PTE in the cluster. Which means you need to effectively touch every
page in that 32KB cluster (that was then later reduced to 16KB in zen3 if I'm
not mistaken). And as soon as you write to one of them, the D bit gets set and
the TLB entry needs to be torn down. So it's usefulness is unfortunately
limited.

But yes, we do reduce page faults. Though I have to wonder how much that matters
in a world where we have fault-around.

-- 
Pedro

