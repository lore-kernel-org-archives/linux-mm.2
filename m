Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186DCE63F11
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 20:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3C36B00A8; Sun, 15 Feb 2026 15:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0513B6B00A9; Sun, 15 Feb 2026 15:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC98C6B00AB; Sun, 15 Feb 2026 15:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB3676B00A8
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 15:11:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B92F13C009
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:45:18 +0000 (UTC)
X-FDA: 84447417516.02.E6AC0B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B053120012
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:45:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BG+JR1Dy;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771177516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhUEBdNMB+2oojblmVUteZDfEmdnPWnoqtn3OWIqyYM=;
	b=NuYojmZy4x6P9TymSn/jZ+v7LgKCmepYOSvG5V6LbY76eyoKIH62Y5YS3qD6E5MlzPWCe+
	xUSkYWzRSlsfDwH0tdil3sYeQ+MuFTsjevzqgFMT4y+wU4g7wvYOtXCsNq9ePSVdRPSdUU
	CJVb30kQOGfDIptXJGZhunfsL9l5ySA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771177516; a=rsa-sha256;
	cv=none;
	b=o+2wYog/+21C+kAYOhZX4e8QJ+/JWDaZssYQv431q888HmHFCTq47Em7OZpm71nStgvt/G
	t5jBA4S3iYAQCCW0/eeVxLnCSAskKeEVGDhmAJksrDTQwn9QKPCAQ+AeV6PYLnsKfwKKC4
	rZykldvH8pjgtX1fuQmbAW4xjTNyUD8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BG+JR1Dy;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A34D43660;
	Sun, 15 Feb 2026 17:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7335BC4CEF7;
	Sun, 15 Feb 2026 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177515;
	bh=8+vsibyilKDKEZUlnlJrlviFTSx+hiIe6MQ75WXS7Rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BG+JR1Dyi5VqlUUTMQf5o+IiWg/T2f3iM50oVhUC5iCYomQGcsnmguUIxywRlub2p
	 egB1quc0DK4f9M6/YLQTkMXWoMuBxZURAiXTZJqY4zFmhsg0k951pvj6wr8eH9F8wU
	 AM5JBmF6GY00arsIj/PxFJgo7GvSr9q2JubVLEHPAeo7A8BtVruoSMUZ7BFkzRhuog
	 Ex2bquQwk1LKEv9t0ST+8RVfYCe9ouxUlpG0FOs2qowxphlyDvx+mfSzVM+KgqcIxV
	 mUUtlI+5N1rCjkyk4hN+zdv8vjrFDLhhO5ln9E5kcqJad0eDxPxQ4gCLobLT56qZZr
	 ODkw7iWdblQ1w==
Date: Sun, 15 Feb 2026 19:45:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <aZIGIH9--qOamaMe@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
 <aYIzCuh8cjd09zrP@x1.local>
 <aYhm_4difwN5XXxe@kernel.org>
 <aYzf-hS4pUY9ulss@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYzf-hS4pUY9ulss@x1.local>
X-Rspamd-Queue-Id: 4B053120012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: htcqwxm38cin36i4cqjcqwewj7ccz1xj
X-HE-Tag: 1771177516-947763
X-HE-Meta: U2FsdGVkX18mTAeXis3t/IiQGUEbtsYEOjKi87YCmQLK1ldX59duzBlohH91BAVOA5jfmMZNUJcxIPN934Esa/AMPt4oOCv94C/8n8c3iYmvztdWukGaTNsYbB0WsZrkAiaXvDRwJmXVD55/0ZI14qke2zPvidi+BWlD73FGB3HKL4dhuQoXPCHcSWFZbULzy/10nAnoaJIEKQTsOIpW/iPvMgp8EX50cIPwNr5HBZcHCY94DK2dKqCbbnNCtjQhm1OgwxCihRKkSOlhVqMdvRH5zAQnl/WG5EvIUtJNgc0ts8RnOEEt4XsIHo3BqmKOGG9h3Wk+UR23WH6+eiQIfVPSREsUW5yzuht9o2o1q+GHggzJeNTOj9NI/K3BVIGTyqU//vztpaEesQMBtaKes2ggR8DE6gPUJ35Q7QABQTGQ1mN/wRgKho2lliJXs67oHHuLk1f376LTF+ICDr68Z/CGZpNiw715CXc7DAhcTNGgkRYzFRsMcCYiWFkOOe8Ckf53TowHgAL1NNhdAjE4gVlSAZLNLtPBhzQVyy7KnBIk8v8nu+ZAw2bSWwCM747W7NuKfzlHd7mcyojjj2n0LPyPGr7obQLoY9ctsvnc/wyMBUFwABPhuZuULByCr6fEULho7jWOZ5mJnj7QQdXLANdMAjruIGTJyuJPfp8MQvLjQD9ggdJx/wfAAwBLNcYdbjlqpyENgzhbsvaHqIrx0vIm487w57/PUCaNWO/3IKDAgXVYzlQy3v6yV3Y/TyY3MPoNaExBE6v0xr0GLxnR3UMBeVorwm2joV4S3UenLP/8PhNB71xgXjeMq4tb7DyKjcVn4oveC1Y+SuoZOB/8rRohE1TcF5K9Gm5l/VyzIIJCVfDSBpYPobkrhN+4k4x5u4qgaKwo3HIFqslvTLO9b+9/znmGkkt3KAuGiSusiB4tsWDZO80uDyL36YE5u0pqX/swPsbZAyIXOVCD8rn
 dsXrUwIU
 5KWcykWzDbamVFbLl0KbCvwyrAeruN255P9LHkdb5Bs4hZvTEODEIzbO8Vx4qFs6SorIsJM4s2zgpyutWs7pVovDvEOUuzjYTeKMMNYvXkY9uPZJB/U8y5qiox9s8wOcKRJjsvXfvtKpBUllLYXoHa0hZ2feDC2nN3tO1lUjPPU8u+Q+snEKJGAByxizG3PU5L52G8AuprWuLlHiqIspHQt8O36kUPXQMjbrNY5gDbdxuoyxFSoUyctAOaiuzjvnjxdb136DDKUQYMeKg1SJy8zb2QF6Ak2KVH1bgjbIBMqv49rc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 03:00:58PM -0500, Peter Xu wrote:
> On Sun, Feb 08, 2026 at 12:35:43PM +0200, Mike Rapoport wrote:
> > > > +static void shmem_mfill_filemap_remove(struct folio *folio,
> > > > +				       struct vm_area_struct *vma)
> > > > +{
> > > > +	struct inode *inode = file_inode(vma->vm_file);
> > > > +
> > > > +	filemap_remove_folio(folio);
> > > > +	shmem_recalc_inode(inode, 0, 0);
> > > >  	folio_unlock(folio);
> > > > -	folio_put(folio);
> > > > -out_unacct_blocks:
> > > > -	shmem_inode_unacct_blocks(inode, 1);
> > > 
> > > This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?
> > 
> > This is handled by shmem_recalc_inode(inode, 0, 0).
> 
> IIUC shmem_recalc_inode() only does the fixup of shmem_inode_info over
> possiblly changing inode->i_mapping->nrpages.  It's not for reverting the
> accounting in the failure paths here.
> 
> OTOH, we still need to maintain accounting for the rest things with
> correctly invoke shmem_inode_unacct_blocks().  One thing we can try is
> testing this series against either shmem quota support (since 2023, IIUC
> it's relevant to "quota" mount option), or max_blocks accountings (IIUC,
> "size" mount option), etc.  Any of those should reflect a difference if my
> understanding is correct.
> 
> So IIUC we still need the unacct_blocks(), please kindly help double check.

I followed shmem_get_folio_gfp() error handling, and unless I missed
something we should have the same sequence with uffd.

In shmem_mfill_filemap_add() we increment both i_mapping->nrpages and
info->alloced in shmem_add_to_page_cache() and 
shmem_recalc_inode(inode, 1, 0) respectively.

Then in shmem_filemap_remove() the call to filemap_remove_folio()
decrements i_mapping->nrpages and shmem_recalc_inode(inode, 0, 0) will see
freed=1 and will call shmem_inode_unacct_blocks().
 
> Thanks,
> 
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

