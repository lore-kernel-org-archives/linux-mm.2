Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DBB109B47A
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E69C6B0098; Tue, 31 Mar 2026 10:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEA86B0099; Tue, 31 Mar 2026 10:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D51B6B009B; Tue, 31 Mar 2026 10:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEA06B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:32:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD60214023E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:32:42 +0000 (UTC)
X-FDA: 84606599364.11.A509BF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 46DB34000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:32:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zck+Jne5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774967561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmDtWV5n1kIOuiA64o05Qh8QH/Tu/KN0eS4fkgEpCX8=;
	b=QY5jD4YW6Jfa4XBS33Jzg7JQoQ85rYEEsBDGKRHYszEQYN/95kpaebunVwiTuMyBRiyKXc
	38Vq9W2BlQoY8FbRs7NH8rgSxf9IZ+PNnMVylXMrqVcmOsWbQR4v+6jbEDfCd0Merbxhu7
	l2RuP1Hsl0n8+BVrgxdAFQWcQr96GIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774967561; a=rsa-sha256;
	cv=none;
	b=fNL43d7grN5vWCXz5FpWAgZVjzokYHHDKlnhUmx/zyIzZwxpg5c+g1pbWl8kKsyYRCNpwa
	NRYRB/wUOwFuL9zhqvXxol5PFhsWprh6ueJI/9IWlQ0iMRmQKuWT6xjoDE9N9UEZs6afeS
	jUgzXmBHxt8Fq2hkPiREkzb6EhVt5i8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zck+Jne5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D9D260128;
	Tue, 31 Mar 2026 14:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CCCC19424;
	Tue, 31 Mar 2026 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774967560;
	bh=eCcZFLBMKfzOLFrTMyw6/QPJblN9ZaXUah2YenOiatQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zck+Jne5EuclgGsxonpXVSJJaoN10ildftuLrZuUiFKQeHmChX1y7iFUOzhIn0915
	 3beBBAYGThwIgQD9OF23CIYHAXoaY1EMDIQ5+LQlMvBkKJuFSFufIfhSxwkbT8xysl
	 pT1ZNVdwzR79WKuUktdBRdvoXyNu0BxDpt7zALp2cZ/bPbxkM6i4pf/V7SXdtJ8XFw
	 rP777dipQdkTEK10hyfpevVhB+dLfoI3xl8f/vDZxjHUpuHu5cF79a+EmdKyW5n4FC
	 fqoF67FQusrW3nObktdTNu2kjRDxZoTKqHUKOtv8qXptagyfoPAkCy4S98/M8PSW0Y
	 wAagqRHHVbs3w==
Date: Tue, 31 Mar 2026 17:32:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 02/15] userfaultfd: introduce struct mfill_state
Message-ID: <acva_NKf7T5rbIC8@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-3-rppt@kernel.org>
 <actxscYZGFiyvUcs@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <actxscYZGFiyvUcs@hyeyoo>
X-Rspamd-Queue-Id: 46DB34000F
X-Stat-Signature: hb3wzzu1xxqqaesmy8f3ouhunfahhdzh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774967561-103212
X-HE-Meta: U2FsdGVkX1+A9qCQyltgyIzTEjX9rJjoCFBrYdfFCHfTu4CPwLHJGRsFYh5ON200iJK3DLfmmUs96oIzrPpiT8fgxYvKXz8VQOfDs3JmyIUayEHq6z1Kcy3VZXX/+ZcIMGr+eApgzoXTiDVSaNNVDWNkc/O7QrExf31QHKRnMsnnkGRci/61tYZUxYepSaX7t+aJKgT5//fwmQlphjKjZokOHj9boUYRMidQqpzrxGrs6gVgRz94sH7QVHA/A5nvIVcISsiAirCikWcyv94meAV2f667P2MBxTPcA4hDEtpdMnV8bP1VgL45gftsnkNltBo3K2qeFvCRvtdRDxEUmSKrNAF95/RIMwHS+5r2F3hDxV4L/8CR7HrQ0+hlWzysZkbwEfbqkIE/lRAXM/5Ox8EtYHARJEVTfEIj7kMMlQrGUREGSuU1eWuJNFSj3+y5Pk4y2LRFEShaua1a2VXT0i3qt6EnJZ4bCQ2arO49mq5hyUhj3I34WH51Q8Efh/ORL0b92R408stZKZaYZdbzCijbuEMXmN7DcJb4uLGSaZCvbguJG8USqgOlKtxGQqHshzKj2GKtFdimgmIWXBhrIJvnDrqhh8O83AF6Mh0VEptxHuUETSTWhWrs0qxz4vB/gpAdZ2CBAA9rxWrgmzhvvlchzIc6h7dm+ORTGJjEv+EMqivBKHCIjTBDf3ILdnL1hQOo2Stg6+dTfabhjck7JucdNDt+ogoadrDJwtIqqVfKNvj8yRcUG90Xt0fxNkgRFyWjcRZbucV5UGmW0oY/jjPJmm8zn7KSljltDFS1V5bAOq77noEQZACoIuFgTBc13I5amvEUayWZquiLtEON9qeBgCPrLhGu9HwGVh6vweJOdBvwbHRY+UNYT10XQBr686ieziNrXi2pL4wp4qqAduIyvzhj/NeHl0EsZ4QRMki9tHJnj+MXPV8T9/gnDnTUF1CEwZ59TcQFDc7erUO
 umrcs0cW
 Ea6TU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Tue, Mar 31, 2026 at 04:03:13PM +0900, Harry Yoo (Oracle) wrote:
> On Mon, Mar 30, 2026 at 01:11:03PM +0300, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > mfill_atomic() passes a lot of parameters down to its callees.
> > 
> > Aggregate them all into mfill_state structure and pass this structure to
> > functions that implement various UFFDIO_ commands.
> > 
> > Tracking the state in a structure will allow moving the code that retries
> > copying of data for UFFDIO_COPY into mfill_atomic_pte_copy() and make the
> > loop in mfill_atomic() identical for all UFFDIO operations on PTE-mapped
> > memory.
> > 
> > The mfill_state definition is deliberately local to mm/userfaultfd.c,
> > hence shmem_mfill_atomic_pte() is not updated.
> > 
> > [harry.yoo@oracle.com: properly initialize mfill_state.len to fix
> >                        folio_add_new_anon_rmap() WARN]
> > Link: https://lkml.kernel.org/r/abehBY7QakYF9bK4@hyeyoo
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> >  mm/userfaultfd.c | 148 ++++++++++++++++++++++++++---------------------
> >  1 file changed, 82 insertions(+), 66 deletions(-)
> > 
> > @@ -790,12 +804,14 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> >  		goto out_unlock;
> >  
> > -	while (src_addr < src_start + len) {
> > -		pmd_t dst_pmdval;
> > +	state.vma = dst_vma;
> 
> Oh wait, the lock leak was introduced in patch 2.

Lock leak was introduced in patch 4 that moved getting the vma.
Patch 2 missed the assignment of state.len and introduced an issue with
bound checks.

> If there's an error between uffd_mfill_lock() and `state.vma = dst_vma`,
> it remains unlocked.
> 
> Probably should have been fixed in 2, not patch 4...
> Sorry didn't realize it earlier.
> 
> > -		VM_WARN_ON_ONCE(dst_addr >= dst_start + len);
> > +	while (state.src_addr < src_start + len) {
> > +		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
> > +
> > +		pmd_t dst_pmdval;
> >  
> > -		dst_pmd = mm_alloc_pmd(dst_mm, dst_addr);
> > +		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
> >  		if (unlikely(!dst_pmd)) {
> >  			err = -ENOMEM;
> >  			break;
> > @@ -866,10 +882,10 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  
> >  out_unlock:
> >  	up_read(&ctx->map_changing_lock);
> > -	uffd_mfill_unlock(dst_vma);
> > +	uffd_mfill_unlock(state.vma);
> >  out:
> > -	if (folio)
> > -		folio_put(folio);
> > +	if (state.folio)
> > +		folio_put(state.folio);
> 
> Sashiko raised a concern [2] that it the VMA might be unmapped and
> a new mapping created as a uffd hugetlb vma and leak the folio by
> going through
> 
> `if (is_vm_hugetlb_page(dst_vma))
>         return mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
>                                     src_start, len, flags);`
> 
> but it appears to be a false positive (to me) because
> 
> `if (atomic_read(&ctx->mmap_changing))` check should have detected unmapping
> and free the folio?

I think it's real, and it's there more or less from the beginning, although
nobody hit it yet :)

Before retrying the copy we drop all the locks, so if the copy is really
long the old mapping can be wiped and a new mapping can be created instead.

There's already a v4 of a patch that attempts to solve this:

https://lore.kernel.org/all/20260331134158.622084-1-devnexen@gmail.com
 
> [2] https://sashiko.dev/#/patchset/20260330101116.1117699-1-rppt%40kernel.org?patch=13671
> 
> >  	VM_WARN_ON_ONCE(copied < 0);
> >  	VM_WARN_ON_ONCE(err > 0);
> >  	VM_WARN_ON_ONCE(!copied && !err);
> 
> Otherwise looks correct to me.
> 
> -- 
> Cheers,
> Harry / Hyeonggon

-- 
Sincerely yours,
Mike.

