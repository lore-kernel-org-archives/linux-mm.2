Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B65606A8AB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gJlFM33D;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LisWq/Fp;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gJlFM33D;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LisWq/Fp
Received: by kanga.kvack.org (Postfix)
	id 991766B00EF; Thu, 12 Nov 2026 09:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942636B05B4; Thu, 12 Nov 2026 09:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3056B05B5; Thu, 12 Nov 2026 09:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 497D26B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF8D91405D4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:01:08 +0000 (UTC)
X-FDA: 85426628616.04.99BC4D9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8940780010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:01:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gJlFM33D;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="LisWq/Fp";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gJlFM33D;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="LisWq/Fp";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492066;
	b=ac+aeByAA0Xi7dz8LADU+Kr45PbTkM6XnieQm/mTo5tOMMLt8GTjYthrfkaHj9f9aLppkk
	IoiMvYnJMYXAuGPO9uz9c2QLQhiORwpp4PWkkjkI+0AjEREKcRo5IUQmlK9C+lPMsO8yax
	pprBzG8yDZ+CFC3Q6oqk8yV6vgVSXK0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTNMIFQg7vEsr/bVsx6max9Hp2mlrFDIwp0Z0arBhBY=;
	b=XcrY/C0n0zS0bYt0/H0gIvC94/BDn/Pb4RU9+2nI0ueebIneOJlMRJKvqXU1JuHwanGh9R
	IUfYPkyIfrffVyZmbk1w9mmp+F9Rh9uikZuS8hKb1i0ADO6/rXb5JRaw7YFXKg2itolOhA
	Gd6dYIJfBgKtFFAgpjJoCsltkeNkYgI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gJlFM33D;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="LisWq/Fp";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gJlFM33D;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="LisWq/Fp";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0DD6A21E32;
	Thu, 12 Nov 2026 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794492065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WTNMIFQg7vEsr/bVsx6max9Hp2mlrFDIwp0Z0arBhBY=;
	b=gJlFM33DOlLsXo/fMz8rj/qpJNd1/LAfw06dbMqIfLoc4IuQh9/RzMXaHgeNvRN5r4o0B4
	DgqDCnXzADpLagRmMbfxO/HW+Bg9xItuDkWUO82GFfItmNejFrXZhBUW2oHpytiyUlvPP+
	TNvMTYoYQXGAiLUv3uBgb7s2eQv/WNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794492065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WTNMIFQg7vEsr/bVsx6max9Hp2mlrFDIwp0Z0arBhBY=;
	b=LisWq/Fpj8SqT6u2xIBros+39GjGe1Tr75xCt4eKCv/fmjYu3CJDOJW1YNVOTyGrVDIuJq
	vZrJ+kiUtvHXFUCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794492065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WTNMIFQg7vEsr/bVsx6max9Hp2mlrFDIwp0Z0arBhBY=;
	b=gJlFM33DOlLsXo/fMz8rj/qpJNd1/LAfw06dbMqIfLoc4IuQh9/RzMXaHgeNvRN5r4o0B4
	DgqDCnXzADpLagRmMbfxO/HW+Bg9xItuDkWUO82GFfItmNejFrXZhBUW2oHpytiyUlvPP+
	TNvMTYoYQXGAiLUv3uBgb7s2eQv/WNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794492065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WTNMIFQg7vEsr/bVsx6max9Hp2mlrFDIwp0Z0arBhBY=;
	b=LisWq/Fpj8SqT6u2xIBros+39GjGe1Tr75xCt4eKCv/fmjYu3CJDOJW1YNVOTyGrVDIuJq
	vZrJ+kiUtvHXFUCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F9A4134A0;
	Thu, 12 Nov 2026 14:01:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M0T5C53G9WrPJQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 14:01:01 +0000
Date: Thu, 12 Nov 2026 14:00:59 +0000
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
	iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/9] mm: limit pagecache folio refcount when splicing
 into pipes
Message-ID: <avXFlI_5fhUvFyct@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-2-318625d63a98@kernel.org>
 <avW3v-oLxcHXXNQD@pedro-suse.tail5790ac.ts.net>
 <4ae22b7a-c160-4003-a029-8a20381d196f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ae22b7a-c160-4003-a029-8a20381d196f@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Queue-Id: 8940780010
X-Rspamd-Server: rspam12
X-Stat-Signature: 8ofs7136atwibqqezfzss5kos1o7x7br
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794492066-515823
X-HE-Meta: U2FsdGVkX18Hd/jo3a5N1jo9NjQxSBFVIv7qEwT0T7XvtkNNa+3cs3zHtSYkgqkz6GZU+EwWqUbxqCJkilVzDGm8hX46gDKWuslJNgmJ0sj0OqVNYYgzAHwFXWvR2PqnD3i6jC1RceZ72yiqKha309k0QZ7QMlfsdUrlZPVvfPT0hEoE2z+NtrXZPZRBrz27F4THZ6mAcf03efMVeAgO9spcpeQ1SXXLSnYr5dApAJOzlrYjjGycCM58WuuYV99Lu8FpaUjyitDH3q6DUKaVab93SJqd+J5/xOCYhvGD2ksQgynz5cKzL4egM5DHnMJOJ/grSCVjjLTzDUgzxQ3KQIWIzrjsF1b3hs5XnvKmrHw+WXjiujfSn+nJWFpAADSxtt+nVNFZJdh+oj1FBECeL4pw/b6hxIAfk99rDTbFF+ivn4VUdIGdyHRg+M6bDI2tyP4Yx88/+7D4c+dEUZ6Ew3b2TSedmEk1yTduvHODW+XrPZjOrWSboDshng9AZM0zxeDRKeU0vlbHjUv5psFBA94UxnxjqvjBwWgT+9/p4gxoh6Ieya0jDqhC6iy4ZCdBsHXJVCZVYgfxgZ8Mw76X2o6D+AmMo7re0dQBewgPXtr1hSvfo4YisHnwqdE/V7gHNAcClhjgI1L6tmoQl4RVBoZ32Oc8rGkwbsLNnR/BXLUjeC3gjtS/aWWr4NnBHMsCIo4//dlPw+MlZRwiBZb9tbbBQZ4Ww2SOT9fpgoqTLvxcbRt0qij7hwEnuUfWlqED7+j2ccj23k1IXtnKXw27jopklGA5pC/1A+XPXrj5QtskMxgi2Nof8eS72R0PSVyY9paR5jIaHJbdaCqyB4PV7lm3Od9AYbj+RvWhF1BmIjAKMj79yOMf8RJ/Uc4z0YluILmIZHCdA4a10yEH3hWC7vsMvOyfU9MnlPufvQ1x0NfgbW+C3yBDCln7W7NNkvSf09o5a6waTKOv+S1RAxB
 t+qp8ikq
 /y34M/WHvaxrPNhMb6I+JPjwdhPfR+aOTrZF7zDVksOBs+3x/uCIE2GKIpOm01IZHlwTbzPf79rr5yQxRvPKGmyPjUQOjEgdJJ55lLveGREnfCewlCuuXN8js4G17F+rD8o0Ua4/UtaHSpj7gmZttf67Ni2Jlj2uYAZ+NvOyGodg3nPCS9qIUrA+RYwAwJD5AMsR2ckQcisu9xanExjR98qasocMDOW54zpsuxBHP9fHicaiJ1bAXRw1ohjDooZqBGNkZjmsm5KSZ1bp4Mq4xxH4qYmk90lzQ9oHVIexNQT/nv4eRGCgw3bv5YHr9a+joehegUQzZh7oTtLZvEPDvDJ+t8t0Oxp57K46o648AJ8iGGyZ75sa5ej60neTq7EhQvYFWppdE02i1MhUT6nOKaHDML7jiGLXh3VWO2h5x0Xl9k9P2Oniv+4hur0uHERFLQ0R534sKC7gX2U8+YJzXbqNiSz/x866ezCQ38l+dS+w7vwpJp/d7zAtmaalntl+XZH/FddAHcm4z10J6CByN4nD8Lr8lrGt1UE3S9CC0Qp7i2BY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 02:24:09PM +0100, David Hildenbrand (Arm) wrote:
> On 11/12/26 14:09, Pedro Falcato wrote:
> > On Tue, Nov 10, 2026 at 09:35:42PM +0100, David Hildenbrand (Arm) wrote:
> >> Similar to mapping pagecache folios into page tables, let's reject
> >> additional references when splicing folios into a pipe if the refcount
> >> is at its limit, similar to how we handle it during GUP.
> >>
> >> This will prevent more cases of possible folio refcount overflows with
> >> large pagecache folios.
> >>
> >> Introduce folio_get_checked() for checked reference acquisition when
> >> the caller already holds a reference. It warns and fails on a non-positive
> >> refcount and rejects additional references at the limit.
> >>
> >> Use folio_get_checked() in splice_folio_into_pipe() and
> >> fuse_ref_folio(), returning -EFAULT on failure, like we already do for
> >> pipe-buffer duplication. Similarly, make try_get_page() use it instead.
> >>
> >> Likely try_get_page() should be renamed (or removed) later, as it doesn't
> >> match the folio_try_get() semantics and is confusing.
> >>
> >> If we hit the limit after splicing some data, return the number of bytes
> >> already spliced. Teach the callers to handle errors, and stop
> >> filemap_splice_read() if we only spliced part of a folio, so we don't
> >> skip ahead to the next folio.
> >>
> >> The check in try_get_page() also covers pipe-buffer duplication by tee()
> >> and partial pipe-to-pipe splicing.
> >>
> >> Note that we deliberately will not fall back to the slow path of copying
> >> the folio, particularly as the folio might have an invalid refcount. If
> >> it is ever really required, we can revisit.
> >>
> >> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> >> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> >> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >> ---
> 
> [...]
> >> index 0f6d57432a7e5..e6e73e37f3ea4 100644
> >> --- a/mm/filemap.c
> >> +++ b/mm/filemap.c
> >> @@ -3047,10 +3047,11 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
> >>  EXPORT_SYMBOL(generic_file_read_iter);
> >>  
> >>  /*
> >> - * Splice subpages from a folio into a pipe.
> >> + * Splice subpages from a folio into a pipe. Return the number of bytes spliced,
> >> + * or -EFAULT if we cannot splice from the folio.
> > 
> > -EFAULT is a weird error code to return from splice, et al.
> 
> We might be able to use ETOOMANYREFS (have to check if that could confuse
> callers), but IMHO EFAULT is good enough.
> 
> What would be your suggestion?

ETOOMANYREFS I think is good, also EBUSY, EMLINK (though this would be weird)
or even a generic -EIO.

> 
> > 
> >>   */
> >> -size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
> >> -			      struct folio *folio, loff_t fpos, size_t size)
> >> +ssize_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
> >> +			       struct folio *folio, loff_t fpos, size_t size)
> >>  {
> >>  	struct page *page;
> >>  	size_t spliced = 0, offset = offset_in_folio(folio, fpos);
> >> @@ -3063,13 +3064,15 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
> >>  		struct pipe_buffer *buf = pipe_head_buf(pipe);
> >>  		size_t part = min_t(size_t, PAGE_SIZE - offset, size - spliced);
> >>  
> >> +		if (!folio_get_checked(folio))
> >> +			return spliced ? spliced : -EFAULT;
> > 			return spliced ?: -EFAULT;
> > 
> > I don't know if there's much kernel code out there doing this, but I like
> > the trick :)
> 
> There are a couple of thousands, but yes, one doesn't encounter it that often.
> 
> > 
> >> +
> >>  		*buf = (struct pipe_buffer) {
> >>  			.ops	= &page_cache_pipe_buf_ops,
> >>  			.page	= page,
> >>  			.offset	= offset,
> >>  			.len	= part,
> >>  		};
> >> -		folio_get(folio);
> >>  		pipe->head++;
> >>  		page++;
> >>  		spliced += part;
> >> @@ -3094,9 +3097,10 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
> >>   * Return: On success, the number of bytes read will be returned and *@ppos
> >>   * will be updated if appropriate; 0 will be returned if there is no more data
> >>   * to be read; -EAGAIN will be returned if the pipe had no space, and some
> >> - * other negative error code will be returned on error.  A short read may occur
> >> - * if the pipe has insufficient space, we reach the end of the data or we hit a
> >> - * hole.
> >> + * other negative error code will be returned on error; -EFAULT will be returned
> >> + * if acquiring a folio reference fails and no data has been spliced.
> >> + * A short read may occur if the pipe has insufficient space, we reach the
> >> + * end of the data, hit a hole or hit a folio refcount limit.
> >>   */
> >>  ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
> >>  			    struct pipe_inode_info *pipe,
> >> @@ -3154,7 +3158,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
> >>  
> >>  		for (i = 0; i < folio_batch_count(&fbatch); i++) {
> >>  			struct folio *folio = fbatch.folios[i];
> >> -			size_t n;
> >> +			ssize_t n;
> >>  
> >>  			if (folio_pos(folio) >= end_offset)
> >>  				goto out;
> >> @@ -3170,13 +3174,15 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
> >>  
> >>  			n = min_t(loff_t, len, isize - *ppos);
> >>  			n = splice_folio_into_pipe(pipe, folio, *ppos, n);
> >> -			if (!n)
> >> +			if (n <= 0) {
> >> +				error = n;
> >>  				goto out;
> >> +			}
> >>  			len -= n;
> >>  			total_spliced += n;
> >>  			*ppos += n;
> >>  			in->f_ra.prev_pos = *ppos;
> >> -			if (pipe_is_full(pipe))
> >> +			if (pipe_is_full(pipe) || *ppos < folio_next_pos(folio))
> > 
> > I'm confused. Why does this need to be done here?
> >  
> 
> I have above:
> 
> "stop filemap_splice_read() if we only spliced part of a folio, so we don't
> skip ahead to the next folio"

Yes, but is this a separate fix? A folio could be partially spliced previously
as well, no?

> 
> Thanks a lot for the review!

You're welcome! :)

FWIW, you can add my

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

to whatever comes out of these nits :)

-- 
Pedro

