Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8DDC5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054256B0095; Wed, 19 Aug 2026 12:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BFC6B0098; Wed, 19 Aug 2026 12:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C806B009B; Wed, 19 Aug 2026 12:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B71286B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:35:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 496341A0564
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:35:56 +0000 (UTC)
X-FDA: 85118570712.12.3E1A580
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1143F18000B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:35:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=c7N0m8t0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wsaFVQoM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pHjX4rIe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="JZhA/NsW";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787157354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yz2VOBZnDUX4tOf6vz3K3Pbv0gc4KxVhhgpUb8PRsnQ=;
	b=1+HW+G8Gn54cLpqY+ZzjjoKTwDgUb9eSmmvcI+seLOE010OX0kl/YWa7z7u/8OTnJvhpN5
	Jb2Oa2EA2AczihMA4UgLg6CPhAhkZeiavKnWc4Nl8wMTrWoKUhBsGZvvNWlwCzRmO5iu9a
	pF5eKWR0/AUhvwV9CmmwcnABJvQtrsE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=c7N0m8t0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wsaFVQoM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pHjX4rIe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="JZhA/NsW";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787157354;
	b=6P7rN+XpwHkPC7jMf1mY/qdDtUlDQtWupwftJ3ovZCOlsOg8NKsv8IwKKYFz8D7lFKeZ8t
	NOX096azHrQkJ+o29KMUvwsYinFKKpD3XmadGZclXD96useU9va4HhPQmUy+Q6l5mVavwW
	IZ3tWc/o6AFFVRHIwvQJvePgpmapmwM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 613433F02;
	Wed, 19 Aug 2026 16:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787157348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yz2VOBZnDUX4tOf6vz3K3Pbv0gc4KxVhhgpUb8PRsnQ=;
	b=c7N0m8t0A/TVypGMIr9WfJPoTCnCYLI5foGgtL7CysId3PJtOQTDqGFE5/Umf18rduLFnp
	mzkg7wL2+rCaZM41qyVuN6BB4jU8mOs0B/n3dnzfsRe05yVzVD1v7xFiqSt5Ecq82GLb73
	hQLRk0zi44nLhA+dIWWuu48mlODxmFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787157348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yz2VOBZnDUX4tOf6vz3K3Pbv0gc4KxVhhgpUb8PRsnQ=;
	b=wsaFVQoMkrvXaILgSQs/VsxYBJM/XD1pZyYSJ5BHe69V19DsW3SPyJHAY6WHuQ9GSoTiVj
	C6xTwWeeE28JTgBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787157344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yz2VOBZnDUX4tOf6vz3K3Pbv0gc4KxVhhgpUb8PRsnQ=;
	b=pHjX4rIeoqdIhD1189zAIBHsMy76AiyTWn0oQjEvMQNQzQXG00C0UMo4Cgj1kGzkoC+1oy
	mFspuBxjrnq8oCvQfLFt7PgEZnxET8D2qwq3CO8GYAlcTP5qRqTuz+mBz4EeDVAA/MxQGQ
	5QGklhAWrVAtaTCXIY5M0wkjp3e7bwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787157344;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yz2VOBZnDUX4tOf6vz3K3Pbv0gc4KxVhhgpUb8PRsnQ=;
	b=JZhA/NsWWEYDQIRQVH20BKkJlUTsBlhsgtFzGMT4xMFG8pbrc5BADdeMVD4A80AcePSTll
	ZrpjKg/kMNVnZ1CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F16842F81;
	Wed, 19 Aug 2026 16:35:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XgCuN17bhWrkBgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 19 Aug 2026 16:35:42 +0000
Date: Wed, 19 Aug 2026 17:35:41 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
References: <20260819101222.3732660-1-usama.arif@linux.dev>
 <aoWw_iKEDLjKL2jr@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoWw_iKEDLjKL2jr@thinkstation>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1143F18000B
X-Stat-Signature: fokx85q6r3m76et6d64wf7nrzhpfewd6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787157353-994893
X-HE-Meta: U2FsdGVkX191Vr408mq/riyr+GUB5QfKg11KJf2NpFEmOkcO1QqKpn8qoIHFiciYK1PFYAjyznJPgl+IrH2iRrxNt5ZwjmPca15TawFkalx28LzdMxtWR4zMwIMeoYuHYmNibyfAxSOfUqYQdlV3YV2Bl1bkOd7EGFV8wI45TrmqUBRLCNQ7Dh1b2LbK2IWYCZFTmkmiv8P7GSTQ/iX+fZpjkH0IHq22Vbcl+kPgiRPsadq/CUk+0Kiv1o8tk3dHcQxJVGb19x21qnfHkqRegC6WxDDBEwPfGU4Q0oeJgd1PNPJDpK9XEZ1t1dmLsTZ6y1J0tRHzIzhNOxjZMqTyXsGNZfvGyf5JMcYFFtY4nO6irE2YBripQG8RbasdAx6WmNpIBTJ8sfgNsM4aQ/Py62Llt59ZEOdTtezpCbQBwyStLyGUmyUf5kMrwzUQwjpmdrXpLeAS+C28aygjTuYgfuld//U1mb9qYmCSr6122lPBufyH1Vh+oDD7/XQc1LM7bzocclm0cOPexiFMEQOD6hSsqDxFZGhRJMSblDCIlP09EK1LTdI/kcLaKV2P80rTzNIbe/O9U5GCrDOhB+glf3nfZVr0cVUJuxSScY5wxODh96NLl41S5S8fYvvCekCXUenpuuz7nEDXPpub785waRYE93puLUyssltf4WHK1TFYuXgLwrjIfosIi/IXfeFIfNgtDZ1Hxl7qvjPTQfhSfgNdP9WuxPfJUVSr2tqGlVkzH6CY4Au9xuF91uwLoHz9tSoHNn4DKmNuwYNfsjzL875XUI1BJI4Npy+aFDnKQblfeY7Xj2+KHJ7309tKSOlzChsGuOShvvWFCKe59N5KHNS4JVsjqOmHQBwVH9wf5TMAdaep7CUIj0mtwu9acaLweVSMYYHV5GvPxW42tJC0AR3wAcY6lqlj8t7I+6hhj8pjUqchhP5iNnAyPfbAxpWXjw+DwPq9F7Jh0VtgEB4
 GsR26o2K
 A3WxEbjG2tbBritKRfGH4nU+jCHpEv4V21QLxL/iKRY/AntiiLurzsmr1r2uCUTDU9E5JSH8/pkyurbIAIkpfAIKwSkYBoA19JSnZ3FfkHxaMA6UDCj+V30oPIz8eoymdKtOZF++H3FQTW19wzQHJmUJogl3uzsRvZ9iCAz7SYsk94rnspHSYP1lgo2/RE6FWQ8mQ38Fk/VjCq0ocT05LdYVhVR2PWSsig50TtyXeR14hjuDCUghxY7tqrzhoYYvbCP3NqtaMjvbtIr3LPeyR8V/Sw2aYJ1+d8H3AbqIhLqlMui2tYIUvlKpwA+8q/ZWjKlSiG7bmbFj+aVV2F4lOdnwmow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 03:31:40PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
> > zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
> > file case, but not the dirty bit.  The pte path does propagate it, in
> > zap_present_folio_ptes() and so does the pmd split path, in
> > __split_huge_pmd_locked().
> > 
> > For most file mappings the omission is harmless, because writing to a
> > shared file mapping goes through page_mkwrite(), which dirties the
> > folio.  tmpfs is different: it has no page_mkwrite(), and
> > vma_wants_writenotify() is false for it, so a *read* fault on a
> > MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
> > do_read_fault() does not call fault_dirty_shared_page(), so subsequent
> > stores through that mapping set only the hardware dirty bit in the pmd
> > and never call folio_mark_dirty().
> >
> > A shmem folio allocated by a fault
> > is marked uptodate but not dirty (see the clear: block in
> > shmem_get_folio_gfp()), so PG_dirty is never set at all.
> > 
> > Unmapping such a folio - munmap(), or exit_mmap() when the process dies
> > - then loses the only record that it was written, because zap_huge_pmd()
> > drops the pmd without transferring the dirty bit.  Reclaim afterwards
> > sees a clean shmem folio: the whole swap-out block in
> > shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
> > pageout() is skipped and the folio falls into __remove_mapping().
> > There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
> > entry is created and __filemap_remove_folio(folio, NULL) simply empties
> > the i_pages slot.  The data is freed without ever being written to swap,
> > and the next fault on that index returns a freshly zeroed folio.
> > 
> > This is silent data loss for any process that keeps state in a
> > MAP_SHARED tmpfs segment across an unmap - for example a cache handed
> > from one process generation to the next through /dev/shm.  It requires
> > the folio to be PMD-mapped, so it only shows up once shmem THP is
> > enabled (which is what we did in Meta fleet and started noticing crashes);
> > with THP off the pte path transfers the dirty bit correctly.
> > It also only becomes visible when swap is enabled, because with no swap
> > device shmem folios (which are on the anon LRU) are not scanned by
> > reclaim at all, so the clean folio is never dropped.
> > 
> > Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
> > 2MB-backed region, write a known pattern through the resulting mapping,
> > munmap, force reclaim of the cgroup, then re-map and read back.  Without
> > this patch the region reads back as zeros and vmstat shows zswpout 0 -
> > the data was discarded rather than swapped.  With this patch the region
> > reads back correctly and the pages are swapped out as expected.  With
> > huge=never, or when the first touch is a write, the test passes either
> > way.
> 
> +Hugh.
> 
> Oopsie.
> 
> I'm confused why it took a decade to discover the bug...
> Maybe read ahead of write for shmem is too rare, I donno.
> 
> > 
> > Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> 
> This would be more precise: b5072380eb61 ("thp: support file pages in zap_huge_pmd()")
> 
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  mm/huge_memory.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index ced400f72d43a..afbb5974bd225 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> >  		add_mm_counter(mm, mm_counter_file(folio),
> >  			       -HPAGE_PMD_NR);
> >  
> > +		if (is_present && pmd_dirty(pmdval))
> > +			folio_mark_dirty(folio);
> 
> Unrelated to your patch, but noticed while looking at it: we drop the rmap
> here under the pmd lock, while the TLB flush is deferred to
> tlb_finish_mmu(). The pte path handles this with
> tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
> tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
> zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.
> 
> Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and
> do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
> folio_mkclean() can clean the folio while another CPU still stores through a
> stale TLB entry -- silently lost write, no PG_dirty left behind.

Where do you see page_mkwrite being called in the same path as do_set_pmd()?
Per my understanding of the code, this Should Not Happen, and it really Should
Not Happen for many, many reasons (write amplification being the main one).

Namely, see the comment in wp_huge_pmd():
	/* COW or write-notify handled on pte level: split pmd. */

if file huge pages get mapped writable, that's a bug.
 

-- 
Pedro

