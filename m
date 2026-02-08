Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC52EF06E2
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 10:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233316B0089; Sun,  8 Feb 2026 05:23:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6936B0092; Sun,  8 Feb 2026 05:23:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8E26B0093; Sun,  8 Feb 2026 05:23:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEB426B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 05:23:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 802C414054A
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 10:23:05 +0000 (UTC)
X-FDA: 84420901530.10.0134782
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9A67100005
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 10:23:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hFIlpYuV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770546183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9EksYV9/lRgzN5hUhPRpNXuRskPBsHzGvJwBmB1B2A=;
	b=mHqulqnOUBivzyWe0Mc026tdRFoO+Vy59dF8mBcsg/lan77dA6HGYTcNJvBLM3ZlQ2Q7dd
	zdRMKN3rpXkCFU9dr4J28fergMgFcsaR1kDXAwJ4BDGertIitReSAWbAaotF/jNT9DtT0n
	VkYkxKNs2XQ+pPp9F/VDnscbbwQLDuE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770546183; a=rsa-sha256;
	cv=none;
	b=wIsxH6gPwl0SRxXaku99+8SKrlUSuDUMZxc836B30A7PtO00vcgDdjRV39jCWfrItkWC0G
	t+4/CjbnosuulFK6GZfGEHSxl8k6ZQhSxS8fNBK4dcQ+aowzeUp07IMTYxRGlnqEgoBkjx
	NXyF6rU1IyHKdm96mGGcADAarLazXf4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hFIlpYuV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DCDE60054;
	Sun,  8 Feb 2026 10:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001AFC4CEF7;
	Sun,  8 Feb 2026 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770546183;
	bh=X40rdyS6Y6fl2CRiDiW77eJoxxt8y+6p1hMAAnDEfLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hFIlpYuV5D2Emx0Q2sDypBVW+AhWi8fSuO40+NXrjL28KqRmx6A6QX5FXeeOTE2lp
	 6vMssip5iI0KL66gFswfQfau4ZitOqeDjeJPa5ij89+dq4dttWgDU68XSnzlha4G9f
	 LTAWMWKeN1Z54We7+CPufJwweWX/BWwB+W/BOGIgIDkmowaq+fRqHccfv5EgbnMUUr
	 IEeSng43gd7rVXZgTs/6sXTfjTo0xIdTvGOXB2DRzi2krxzvdH8dqRYbYcOmrYKZu0
	 JiSwbNAXpr6U01oLDpnksOIAJDuhD6t0mXS6fR4uz+MuX72J1xltL3Z2pLZXcGmATE
	 /Uj7w4dxYwc2w==
Date: Sun, 8 Feb 2026 12:22:52 +0200
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
Subject: Re: [PATCH RFC 09/17] userfaultfd: introduce
 vm_uffd_ops->alloc_folio()
Message-ID: <aYhj_H2X141wU3oF@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-10-rppt@kernel.org>
 <aYEhgA1dY0biVYb8@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEhgA1dY0biVYb8@x1.local>
X-Rspamd-Queue-Id: E9A67100005
X-Stat-Signature: kadur418hpgztgsxaq8uofghequeiqja
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770546183-807860
X-HE-Meta: U2FsdGVkX197N9F5zHa/Y4jT2Gz+k/8yrUfhhOTfmI8uKiac7jr6kOHRgnUAsgy0QoriVHEnTKlwydVxK1Y90hWVwM/fy1hfWVacgO7+0AXAJdqPza4mWkvvWXZK24fwPv0i9itrcmHAevlnIACjHKTNX0I0scl1VptEivERkwlLRv3AeG+1Xbx5+cotMjfOurV8NbPQs6fgO6VZcwY0GH2lSJvFNuUDCwOI3fPCsGygBaNRrz8oIo6IWlAULUlFWyd+bmEukYx1YTxBx7yOYzi8AFWLdQV64ljwv0QQKSzIrYzfuBc7b0uVwxWIoRP6WOtTOUpK6Fn62TMJE4P/0WpkdcXSlC8chNT5IHkGMjQtXRyei3kh9BkFjdnMyf3hBCFpjWRqqjsIAHRXa9dbY1FtliZC0XKBOIU8+YNzlAvtlxqVaNaT1TFxUxP+uX20l7v0vJZWxzooZwNV0gLUz4GD+FlLtsYH1jk8kE1qpTBjUI0VYiSqSXYZY+KqJqETpdPYZhL9zv8UIH3bPpjAsaAD/KdVBV7EY16ikBA+cfqZf4Z2TMeJjsnlvtXTckXI1sPfuz2bw1uGeTLfdt1Qi9JQEBQQYZ099sL7LfVXN/az6SrHYZywlTxj66g7dJucVIFQyPhWEw1mFlNGvqu10vNVG+6hFdIzGYyysXRlNK01ZSk3CTURGYVi93Wmsi/aVTPA6h+rt7al92DQq/3ys1MxnsFu4Iie91jz1ACRS4K/olsE+d1BLFfuxF9XTz+f1jxWP52PhyXHibN2NfaZldO18eR6ntyulHesl9QjXPHi4ZHLikLYMR++b5ZjwB0aKd/CDh9iDKS7AFSnO6OeFEDsjl+XAFDDntUPXtEhuXZkHQjKl0l4n2L47hvYWIx8bVA8dbpJrK3SZFqpkDDzevyRRxWSTDK/Q580I5Sr02tWBi/o9PGbF/ygqYPMWw86fXWSXdP4Vya2aiZbkDP
 EiZJF+Vr
 YmekL6gL73hUawQMLl9xiu2RWeahaRJ/QdIAVoNfxuuPhTOchc2YKOHEa3iw0IcrupprbpXAIQk1jBtzh6eOy1ZSXoZ5O3kVtwaksuXsZcqWWrx/VR/Sqe8Q+4JDnGQ0DhWGX0RMtB6mm4ij3YT0ZDPQtan8MPBxVbGv8y1CMWaHsDWr1npVkdOaQhmnQWNZuqkkU/oWPeHgeJ6mmsVP0VGnMM0OBs+RqkLaXFaHObQiu+ILiRKIsUt3GmBr5RK0+As/KhQBF0LtdckogDGF3c3DtLFMkzpSEsS2TGG88WNBo44Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 05:13:20PM -0500, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:28PM +0200, Mike Rapoport wrote:
> 
> [...]
> 
> > -static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> > -					 struct vm_area_struct *dst_vma,
> > -					 unsigned long dst_addr)
> > +static int mfill_atomic_pte_copy(struct mfill_state *state)
> >  {
> > -	struct folio *folio;
> > -	int ret = -ENOMEM;
> > -
> > -	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> > -	if (!folio)
> > -		return ret;
> > -
> > -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> > -		goto out_put;
> > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> >  
> > -	/*
> > -	 * The memory barrier inside __folio_mark_uptodate makes sure that
> > -	 * zeroing out the folio become visible before mapping the page
> > -	 * using set_pte_at(). See do_anonymous_page().
> > -	 */
> > -	__folio_mark_uptodate(folio);
> > +	return __mfill_atomic_pte(state, ops);
> > +}
> >  
> > -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> > -				       &folio->page, true, 0);
> > -	if (ret)
> > -		goto out_put;
> > +static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> > +{
> > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> >  
> > -	return 0;
> > -out_put:
> > -	folio_put(folio);
> > -	return ret;
> > +	return __mfill_atomic_pte(state, ops);
> >  }
> >  
> >  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> > @@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> >  	int ret;
> >  
> >  	if (mm_forbids_zeropage(dst_vma->vm_mm))
> > -		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
> > +		return mfill_atomic_pte_zeroed_folio(state);
> 
> After this patch, mfill_atomic_pte_zeroed_folio() should be 100% the same
> impl with mfill_atomic_pte_copy(), so IIUC we can drop it.

It will be slightly different after the next patch to emphasize that
copying into MAP_PRIVATE actually creates anonymous memory.
 
> >  	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
> >  					 dst_vma->vm_page_prot));
> > -- 
> > 2.51.0
> > 
> 
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

