Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54162606C71D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=MePUV0PJ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tYPab8lG;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=MePUV0PJ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tYPab8lG
Received: by kanga.kvack.org (Postfix)
	id 7522B6B05B3; Thu, 12 Nov 2026 09:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701A06B05B6; Thu, 12 Nov 2026 09:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A24A6B05B7; Thu, 12 Nov 2026 09:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 366BB6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:06:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCC861C39C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:06:09 +0000 (UTC)
X-FDA: 85426641258.08.7B93E73
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id B22BB160017
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:06:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MePUV0PJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tYPab8lG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MePUV0PJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tYPab8lG;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d26nC76YLz1Hx0CSfgosaWHEU4xoea2lRNFaxDZwsTA=;
	b=JPpBC1QAK023ksG2odJjGLbASuSo6u+eeSgZqGFOnQB4BwG1eXWmuw5cTXRi9yjPkmBvZg
	wQZSaF3Bil9gvJPfLKN77wW6J8zCP7bHKCX79EzQkVDKNzuLXksXVyFdzS/zhtz7u6szxu
	z/+0eDm6iDoVC626BJOZl5vslkzdZyk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492368;
	b=8iC3a6h2TbejQmXFqJi2tcEBmuDsMnTXH5W/c3422gAQSvWkxwdpGl6+JYCYdbF45Wy/aX
	wuELAaQMQWGKfeMRIwrQjK3d8LZrIP9Wzqz5uC4s0PBnu96j3irKaLEzkn/Y/bOyouxknS
	+7yglKhOYD63k7PwK4GiortvE8Lu1pA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MePUV0PJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tYPab8lG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MePUV0PJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tYPab8lG;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F54321E32;
	Thu, 12 Nov 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794492366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d26nC76YLz1Hx0CSfgosaWHEU4xoea2lRNFaxDZwsTA=;
	b=MePUV0PJPVg6e87V3rI/oBHU/WVNpeN9fAmgxCGLxENx35oKrb0iEmR3T18rtLtVz1Vf+O
	1G6UmmBLJXvaA1WYhfqBFsQOBOJ7IA2iBvpEpvVmXn/Cmsa4Thr80o0Lq+TtDYhKs5Kyab
	qpmF+O8fmKXKFCYmnkRlnrBsSmTsSBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794492366;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d26nC76YLz1Hx0CSfgosaWHEU4xoea2lRNFaxDZwsTA=;
	b=tYPab8lGc7bR6d9kEE9FN38yDhbA+TLnfbS8qBFT3Rs/vxGIU/l099dpGQkmH3U6mcvPbG
	SX8CzvRsGMGv8qBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794492366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d26nC76YLz1Hx0CSfgosaWHEU4xoea2lRNFaxDZwsTA=;
	b=MePUV0PJPVg6e87V3rI/oBHU/WVNpeN9fAmgxCGLxENx35oKrb0iEmR3T18rtLtVz1Vf+O
	1G6UmmBLJXvaA1WYhfqBFsQOBOJ7IA2iBvpEpvVmXn/Cmsa4Thr80o0Lq+TtDYhKs5Kyab
	qpmF+O8fmKXKFCYmnkRlnrBsSmTsSBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794492366;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d26nC76YLz1Hx0CSfgosaWHEU4xoea2lRNFaxDZwsTA=;
	b=tYPab8lGc7bR6d9kEE9FN38yDhbA+TLnfbS8qBFT3Rs/vxGIU/l099dpGQkmH3U6mcvPbG
	SX8CzvRsGMGv8qBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DBA813432;
	Thu, 12 Nov 2026 14:06:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RScNEcrH9WqvKgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 14:06:02 +0000
Date: Thu, 12 Nov 2026 14:06:00 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/9] mm: limit pagecache folio refcount when mapping
 pages
Message-ID: <avXGtysfRk3uQpNu@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-1-318625d63a98@kernel.org>
 <avW0HGjF6wuqn12T@pedro-suse.tail5790ac.ts.net>
 <86206f64-fefa-4a13-95bc-eddf756eecc8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86206f64-fefa-4a13-95bc-eddf756eecc8@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Stat-Signature: egijknk13zkzeqmfpjpfp6sspqu75y54
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B22BB160017
X-HE-Tag: 1794492367-317568
X-HE-Meta: U2FsdGVkX18uIarZZupWJt9CkYfB+FkoLwKYgPbAK/+q2wzszJbPGFNsPABH7VtlZqvfWsjkgLHQ0V0eoOu3YHaILBcx6g0IybXqvy44FWmMdEGPlZF3Fupgak85K5gn6jmBa+K8IlghLBD2+i3hgSjwDjXBQEMx9tAbvNJSwJdmomWozktg9YID6Jz8UK5RYmfP91p25dgp+VMoyFJzfX5UT8gaeTUS55sdfWMGdtupd9gCsXkKQIISqmY1tyU6vAx76EVP0oPffBStkrG1Bx9jAyrCAE6qYxVOdT/kwOc167nTZbRoKsp0V7cH/z4qktiaoC72uulQjgJgmn1Cr4iLzZf9Cm8VNzTWG+6vHJtODzy+YglELZcNnhsLK2Mqheu7blu38JrpB7WJarPCSwxZ1kFINIzi3ovv0bb1IYSUzGEpFvb7AJFXzEbnbFXEANfLPWLxgq+LxRg/yNYYD8VJRqmEG4x0KhtjP31h2GdcBBP7a0/h/ND/qegFIa3FjASG6xtitBOEF0RWncmUEx4a2p/gBknZymqrwH5kzgDTnOaSql/Z/3VoFyUz8tQBYZC816S02XAGQl1Z1BEwMvghEia5bKCpSowQwwtlx+ZIHtwa5skD2pvuxUT9+80BILaHVFEJKwKeqvvMD5uF0B9/FrV86eW+7gNmUokrRpi72FnkVHqQeOwZ6SjNEtg3pgiIkuSEkhBiPu7Xfb30L+vwFVHUVeIDGhX8kAIy+Gc5Q2BeCPZZclFKU/y+HUM3p6fZn+YEddk0GJxDqqFgFQzb/bIYe9eOijQDl2/iwQ/K8ZTdokfuQeK6B1hulkZTc1cuDMGH2Ab+TDgOdq/3uKtNHVBwWJn7jiJ/64mGRIZYApsyFcTlmWJkvEFiR+bVpDVj7E8kg1j3hEhuYI6tddJ3cO/X8Q62ZrvCJcjL6cmVvxB7zi69ZuiVQDqOMyKU2S6ZbUWmKy5lUiG0qnL
 4QzoupDp
 TKlJafspe1xD4DKLlK6zQp06Jcm2Wl4VE20DQrdHgjjvbc/1ClE7NtCrH9CLFJ7+jyAEmn8dEaxHADwJSuPHSQuCc1I0jKZxzhY3er9vJ7OGI4K1nAjdZytjy3nxcMMCpa1ehNxTXiGugtjlt3xyo4RTUrUEJm0qqE8zfQS06Crlc/7sptfGv8meg9Zi1DuLUTHc+uhFGqGo21dNnVgHPWR+axFESlWChSGAWP2K6P2UiQI4HmJ6fqTDWW/Cj0oXD9WvpAjgHLApCr1E5nqQcuijUKJCElH3rG9HHSIlvNw0L/j8YEuDh9O4OhTSwHq5OxOXdx1GjmMSRcmVy3VevBmeRlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 02:16:33PM +0100, David Hildenbrand (Arm) wrote:
> > Mostly LGTM, with some comments:
> > 
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> 
> Thanks for the review, Pedro!
> 
> > 
> >> ---
> >>  include/linux/mm.h | 35 +++++++++++++++++++++++++++++++----
> >>  mm/filemap.c       |  6 ++++++
> >>  mm/huge_memory.c   | 29 +++++++++++++++++++++++++++--
> >>  mm/memory.c        | 33 +++++++++++++++++++++++++++++----
> >>  mm/migrate.c       | 11 +++++++++++
> >>  mm/userfaultfd.c   |  4 ++++
> >>  mm/util.c          | 18 ++++++++++++++++++
> >>  7 files changed, 126 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 4608540e40d46..439cfe446cea4 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -1626,6 +1626,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> >>  {
> >>  	struct mm_struct *mm = vma->vm_mm;
> >>  	pgtable_t pgtable = NULL;
> >> +	vm_fault_t ret = VM_FAULT_NOPAGE;
> >>  	spinlock_t *ptl;
> >>  	pmd_t entry;
> >>  
> >> @@ -1662,6 +1663,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> >>  		if (is_huge_zero_folio(fop.folio)) {
> >>  			entry = pmd_mkspecial(entry);
> >>  		} else {
> >> +			if (unlikely(folio_ref_count_over_limit(fop.folio))) {
> >> +				ret = VM_FAULT_SIGBUS;
> >> +				goto out_unlock;
> >> +			}
> >>  			folio_get(fop.folio);
> > 
> > I see you use this pattern often. Would it make sense to have a
> > bool folio_get_unless_overflow()?
> 
> I commented somewhere (in v2 I think) that I played with using
> folio_get_checked() from #2, but didn't quite like it so I discarded it as
> 
> (a) it cannot be used everywhere here, as I'd need more functions to add
> multiple references. next_uptodate_folio() also could use it as I would need yet
> another temporary helper for a try_get().
> 
> (b) these changes here are going to get reverted fairly soon once I change the
> way how mappings are refcounted (which is, unfortunately, not suitable for
> stable, otherwise I wouldn't be throwing in this temporary change in the first
> place)
> 
> So everything that is expected to stay in later patches uses the proper helper.

Alright.

> 
> [...]
> 
> >>  
> >> +		if (unlikely(folio_ref_count_over_limit(folio))) {
> >> +			/* Skip this PUD; it can be faulted in later. */
> >> +			ret = (dst_vma->vm_flags & VM_MIXEDMAP) ? -ENOMEM : 0;
> > 
> > A comment as to what's going on here with VM_MIXEDMAP would be useful. I guess
> > the idea is that faulting on a mixedmap later will not necessarily hand you the
> > exact same page fault result?
> 
> I can throw in a comment, yes.
> 
> [...]
> 
> >> +bool __folio_ref_count_over_limit(unsigned int ref_count)
> >> +{
> >> +	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
> >> +		return true;
> >> +	/* Background threads must not consume admin reserves. */
> >> +	if (current->flags & PF_KTHREAD)
> >> +		return true;
> >> +	/* Neither must interrupt contexts on behalf of the interrupted task. */
> >> +	if (!in_task())
> >> +		return true;
> >> +	/* Capability checks are not safe with IRQs disabled. */
> >> +	if (irqs_disabled())
> >> +		return true;
> >> +	/* Use the task's credentials, which filesystem overrides cannot change. */
> >> +	return !has_capability_noaudit(current, CAP_SYS_RESOURCE);
> >> +}
> > 
> > In case this function ever returns over limit, we probably want to log this
> > in the kernel log. If this function gets the folio you could even print
> > the problematic file offset/inode/filesystem/etc. Ratelimited of course.
> 
> You mean, if this function returns "true", right? Is printing always fine?
> (e.g., irqs disabled?)

Yes. As far as I know, it's always fine, even under NMI. But definitely fine
with IRQs disabled.

> 
> > 
> >> +EXPORT_SYMBOL_GPL(__folio_ref_count_over_limit);
> > 
> > I'm fairly sure this will break the build for a number of non-GPL drivers
> > when calling folio_get() with CONFIG_DEBUG_VM=y.
> 
> You mean, breaking OOT drivers, right? I can switch to EXPORT_SYMBOL if that's a
> concern.

I had the impression we had some stuff in-tree that isn't marked as GPL. But a quick
grep shows that everything is either GPL or dual-licensed.

In any case, yes, this will quite possibly break debug builds for people OOT.
I think folio_get() might be a bit too ubiquitous to do this to.

-- 
Pedro

