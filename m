Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C54F8A145
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B896B0005; Thu, 16 Apr 2026 04:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BC86B008A; Thu, 16 Apr 2026 04:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4E56B008C; Thu, 16 Apr 2026 04:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0BF6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:57:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E4448C32B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:57:17 +0000 (UTC)
X-FDA: 84663814914.15.D1CF9EE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id E5E7A40002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:57:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lNFk25tG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="nWxDY/8W";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lNFk25tG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="nWxDY/8W";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776329835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Itbd4wP5e0LBwcEW8IWdSyTKJ027dOJH3Fuc12rHyM=;
	b=XF93YgxOuUM/lbbPbB0khMrKWxlwUV9sJ5KT5vou6MySY/Xnk6Z1qpqEFe02cI8rfAMRG3
	oMPEdm4JdZwJnHMToA3NbFwnOpkBuEHglLDYgTvuOKypYePb126UFxXpqVahTWb4dXcmSv
	LdpXRVpPJB0kD7OQhqtYiwL8MrEM8Ys=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lNFk25tG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="nWxDY/8W";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lNFk25tG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="nWxDY/8W";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776329835; a=rsa-sha256;
	cv=none;
	b=kWofIfLBREpeFK0t1JK7kautfIs3wDXawl5L1/x+gDzg6zAKQf7ml/zqnfx4ckrAcMGVfC
	lYnvgPL0XmFpZqiA8m6HLLeoSwKAdH41iW3tppvANmdrhflTxgwzrrt/4zucKrcTJ3iWi7
	PrY4sqm5vk0YDj1dvTYt6R9EdydA4ek=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2144A6A949;
	Thu, 16 Apr 2026 08:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776329833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Itbd4wP5e0LBwcEW8IWdSyTKJ027dOJH3Fuc12rHyM=;
	b=lNFk25tGutojyAp1e7mM30lClGPjPEeoPQ4bdnMvWgG9a+jHmZz/GyPLSD1xjNaGu9Pa1i
	k2nZtK6sGcYi+uiZcJC6eATVg073lFQXfer+YOPdgGfmJeFExKGBPdKyAQPOyZcQMw9mo9
	9T/ramakBWoAF1+j7sKXLL39e0P4MXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776329833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Itbd4wP5e0LBwcEW8IWdSyTKJ027dOJH3Fuc12rHyM=;
	b=nWxDY/8W0F68feQUmmzLfvCsFjCSAPRe+F5q5K3ZOFN66+he3iRXvc6Mn67AD6OEzC2NBw
	X//6/abRMucOqzAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776329833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Itbd4wP5e0LBwcEW8IWdSyTKJ027dOJH3Fuc12rHyM=;
	b=lNFk25tGutojyAp1e7mM30lClGPjPEeoPQ4bdnMvWgG9a+jHmZz/GyPLSD1xjNaGu9Pa1i
	k2nZtK6sGcYi+uiZcJC6eATVg073lFQXfer+YOPdgGfmJeFExKGBPdKyAQPOyZcQMw9mo9
	9T/ramakBWoAF1+j7sKXLL39e0P4MXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776329833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Itbd4wP5e0LBwcEW8IWdSyTKJ027dOJH3Fuc12rHyM=;
	b=nWxDY/8W0F68feQUmmzLfvCsFjCSAPRe+F5q5K3ZOFN66+he3iRXvc6Mn67AD6OEzC2NBw
	X//6/abRMucOqzAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC0834BE97;
	Thu, 16 Apr 2026 08:57:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ptTbJ2ik4GmBSgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 16 Apr 2026 08:57:12 +0000
Date: Thu, 16 Apr 2026 10:57:03 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 5/7] mm: Make /proc/pid/smaps use the new generic
 pagewalk API
Message-ID: <aeCkX5gT5akiQnE0@localhost.localdomain>
References: <20260412174244.133715-6-osalvador@suse.de>
 <20260413141801.1465873-1-usama.arif@linux.dev>
 <adz-SRhS7H50fWXY@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adz-SRhS7H50fWXY@localhost.localdomain>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5E7A40002
X-Stat-Signature: uuoe9uq7aibk8rkuiswh7ep9ub5ke3mf
X-Rspam-User: 
X-HE-Tag: 1776329834-701171
X-HE-Meta: U2FsdGVkX1+/YaKBgqpP2lVfypZFmm37DMm3z2MFxLJTgfs1XVRc0HH0Py4YLOtVyzH1a98SkruMfgjlTD94oxxnTg7wC6DDmoBsXsaMGdiCdwKwFzW5Rs6LkRwBRzPWnOwh6AjGyyoyANagPf6AgV7TCW7lXZPV/BtAm6oYAJEq/ZBYMRcp+XvV+ZWj3soaIWK7mH9s++xQDGH+JC6VM6k0bTPQ0VnbdbHsiz+Sdp/lXZums3avpao7tfVsdEBsM3C6q37H/JO6u1GJEyX6ilDSO9yogoBUBgujsN37nLWnAO1d/SGoj3yBg/gKMp42O53EGTIqrtws7Dtk0k2PqqHz+xh91iEKzgrjfWkIGMFK9u24FC05I5/SsxkBUJoITZHbeEAaouRH8wY0mPoM05aVjkxHf0HWIbuSMinw+TQ/a8T/sW2Sa6h4pC1wT6k76mqAAqefKfTIvrIyMEACX+Fdcx7r6bEp77NazGnolAcmP3kekUMS1UNkb9HSC7BIB6FMFfKC29Yz5cluqm78aKWyJQIPXFCfgGFzTyPsvbmTqAbMEU5EJbALYKVhrk6otyr3v3MAqF4crhmLhGJBi6ACBwe9+pHbxu+pK1IQatZfYL+N6n86zHIh3qRES8cFrAqGWUrwtGR5K3zBr4eh8B5NgJQKWW0C5otdTor4vctv59z+zKFlS+MdHwKxFrf+FJzR0+tYNwJh0txte14K/8slcpoNJVE8BXB+vOhtjjqJUPBhAiFqAhojbMgxDt/JwC3tJlJ1qdiOGBZZrBHeJlKekrY+U1lWWyHCQagyFHls1164UnK8P6YWn/fPUQ1snQaFITiT29pIAZeGGMsrCdduB0b9TvNSPRvWQFy+KKlHgxvXbNCiO4JfmDv92yvRxF6G4KuW/zw7iKC4vP8ZOZGkWylzDrx1j6oYgEZ9139L6FFWldtBHX/bQiou1ALeO+aaHmRXNp2MfuTKYlG
 fWfbUmuX
 tzsFzwaqHqZYuWsyvEzi8GuBGh09d9RnFX3dqWGZ4UZhPo5aInLCqHEbKfsK6qqEfGmn9EmGPfiTKc1NNhwjOe6jUUAfQu+oRCa1QSxhARhVXmGxR3bkl6V5l+sJfth63Tzz7Qtd3UHHcx3wYV7Okm/bnY3vnJQPSe68qVtEmPKXwuhBXd5JAo7dv0KovkYnSJk7JDljcJa1icnBRar89MwBy73R55ItJwdrVy9gvrTC4cFbId6V0xyr9ox3GJYfemmXTq6EYR+VmCr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 04:31:37PM +0200, Oscar Salvador wrote:
> On Mon, Apr 13, 2026 at 07:18:00AM -0700, Usama Arif wrote:
>  
> > The old smap_gather_stats had special handling for shmem swap
> > accounting.  For shared or readonly shmem mappings it used
> > shmem_swap_usage() to efficiently account swapped-out shmem pages.
> > For private writable shmem mappings it used smaps_pte_hole() via
> > smaps_shmem_walk_ops to call shmem_partial_swap_usage() for each
> > PTE hole.
> > 
> > The new code removes all of this.  The pt_range_walk API does not
> > have pte_hole callbacks, so shmem pages that are swapped out (and
> > thus have no PTE) would not be counted in the Swap field of smaps?
> 
> Yes, sorry, that is one of those parts which is incomplete.
> I am already working on that offline, but did not have the time to
> prepare it for this one.

So, I implemented it, quick test show it works:

--- fs/proc/task_mmu.c	2026-04-16 10:54:54.440974482 +0200
+++ task_mmu.c	2026-04-16 10:53:36.465147406 +0200
@@ -1105,13 +1105,38 @@
 	enum pt_range_walk_type type;
 	pt_type_flags_t flags = PT_TYPE_ALL;

-	if (!start)
-		start = vma->vm_start;
+	if (start >= vma->vm_end)
+		return;

 	flags &= ~(PT_TYPE_NONE|PT_TYPE_PFN);

+	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
+		/*
+		 * For shared or readonly shmem mappings we know that all
+		 * swapped out pages belong to the shmem object, and we can
+		 * obtain the swap value much more efficiently. For private
+		 * writable mappings, we might have COW pages that are
+		 * not affected by the parent swapped out pages of the shmem
+		 * object, so we have to distinguish them during the page walk.
+		 * Unless we know that the shmem object (or the part mapped by
+		 * our VMA) has no swapped out pages at all.
+		 */
+		unsigned long shmem_swapped = shmem_swap_usage(vma);
+
+		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
+		    !(vma->vm_flags & VM_WRITE))) {
+			mss->swap += shmem_swapped;
+		} else {
+			flags |= PT_TYPE_NONE;
+		}
+	}
+
+	if (!start)
+		start = vma->vm_start;
+
 	type = pt_range_walk_start(&ptw, vma, start, vma->vm_end, flags);
 	while (type != PTW_DONE) {
+		unsigned long curr_addr = ptw.curr_addr;
 		bool locked = !!(vma->vm_flags & VM_LOCKED);
 		bool compound = false, account = false;
 		unsigned long swap_size;
@@ -1168,6 +1193,17 @@
 				mss->swap_pss += (u64)swap_size << PSS_SHIFT;
 			}
 			break;
+		case PTW_NONE:
+#ifdef CONFIG_SHMEM
+			unsigned long addr = ptw.curr_addr;
+			unsigned long end = ptw.next_addr;
+
+			if (ptw.level == PTW_PMD_LEVEL || ptw.level PTW_PTE_LEVEL)
+				mss->swap += shmem_partial_swap_usage(vma->vm_file->f_mapping,
+							      linear_page_index(vma, addr),
+							      linear_page_index(vma, end));
+#endif
+			break;
 		default:
 			/* Ooops */
 			break;

 

-- 
Oscar Salvador
SUSE Labs

