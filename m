Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D3CEF06E2
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 10:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8266B0089; Sun,  8 Feb 2026 05:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B6B6B0092; Sun,  8 Feb 2026 05:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62AF06B0093; Sun,  8 Feb 2026 05:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 522E56B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 05:01:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3B841403EC
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 10:01:24 +0000 (UTC)
X-FDA: 84420846888.25.4F8CE78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 48CA3C0002
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 10:01:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgFdGLof;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770544883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClpyO/GPbvJe8H2ZyQt+JjvTWv5zp5oUSHgFUkJFP5U=;
	b=YBvsEBCj/Qx+pGUV7sUgBE4Gly9VxQsP2MVdAHTf3u0unnpmjL1y1Q/8a5SLU1cmTkazP0
	VOSyOhUIM1ZQlie7z5ZHy2fnghk/aGZ3Lf51visJPCJclTUrwZTaftMnfB0hjSoea2m4w7
	AAZxwIVMg6hhrgpR2sGeA3tDyZ5n174=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgFdGLof;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770544883; a=rsa-sha256;
	cv=none;
	b=UbgrTWjXhQjp1ffr/30GXYUsiD+zAlqLoTb08es48LJIgmVo6597HLU5KFzqpp5rWWoA7b
	Pz+HxoVHPQGHXfB0qImjSib9LcoPaJdR6H1MwxsKwMSCnCxzz7Iy/O9S0W24GJvQlSx8bi
	bogoTlz9KcLoPKczSYKOwUXRlzXhHH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9727060054;
	Sun,  8 Feb 2026 10:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39F8C116C6;
	Sun,  8 Feb 2026 10:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770544882;
	bh=rMGNaelkKWjBrekHcrcLc5HycHIOWDJuUOdPyJVDSSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TgFdGLof+tmo3Mj4L9Gb66C9SS7fU49Gd2AzwvukepuD9QHDDu8KMd78N6J9OvpKL
	 c2mJQ8C+OHvTBHIZdFrGbTUFKjZbZTKwGOwqXcZyV9A65IIffW35AixZ2rBLIWSdp5
	 k7/W0+4HzUMGc/IyGMqlGe0OyyXpPYyg8W0lVp8C5AXJLjsT9ErEYCCwzdMzdiCZDR
	 4JivQvU4OmGEWAugGh3eZrqCQElyXDba0/rGJOvuSJXpyoipevE4b860k5fPLI0quK
	 RNrMyEJiHsyxU9wE0ykLnfVmdajrtzzxPNJ8hHfrn51RzL6D/NIw+kLVKmn7ieSjTM
	 QuurWg+ZbX6Pg==
Date: Sun, 8 Feb 2026 12:01:11 +0200
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
Subject: Re: [PATCH RFC 05/17] userfaultfd: retry copying with locks dropped
 in mfill_atomic_pte_copy()
Message-ID: <aYhe55zEqvuyng8z@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-6-rppt@kernel.org>
 <aYEVxD_vY-qimMNL@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEVxD_vY-qimMNL@x1.local>
X-Stat-Signature: dcpscm5r6eccosy1j1qnc96ai8npe5bu
X-Rspamd-Queue-Id: 48CA3C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770544883-454645
X-HE-Meta: U2FsdGVkX1/YC+UzL2PVzSlzSM+Pdp263mYhnPI/amCqJaRDIiVQvywId3US7Pz/wa/subbSEXGeNGL9WEmOTyOapvHgmMpXnZJNgut2Fsv9bJPNdQxx3Q1OUH2MpIlOqwmZovnDVcb8huqpm09dTIilOHxo8mK+T0ghP53/M6sD45465g1xHAsZImn2BQMx2q4T7XrBQ+k3xz47G6HFjgRtlJ2tKaa/UgqhU7Toi/dQHaRU+n651avh4zIYwcN8AY+yK9/K78fWoYi6zqUL6+BePXWOxxm9Zps1HbeP8XxP594N80mgPML2ucifpZUtKJc+DhsrWDMRrZDxrGPzmzFpsH03hiZdMwOAHVaaXbseQ4wFch9cw3+fCBLSyUNHy/zp1cdSLuRa23PL4dNee2AsMa+YftNv7vOecIC22tw649HGmX5kSWx9CFkW7yzJ9sQMppcF4XEKZ6H/eWBQ7+749g2VCkpTuYtk9UWIn+ETBBs/saA6rqkXltxc/2984hC24pzeiTHs4vRM5OeZGi1AWCgVVnL+fFbVHtPPcn4a3Iy9mG9pUB88KcJfaRp/KANXEDlr03fG3zXACzfTGkgqsiPojBoMyLnZQ1xRRVD82LYK8MDVVNpLKKsLKVx9PKic9BYWo02oCmSHJ3Ws1a8UstrNurBED7/p5AnxpfzZ5F247Fh56X2kDHCHNb4xEsGKY1iUyOMxkCG5c0sfpsqQKrIPyUP1juL14SwFN6Buw9M3eXa+Av63T84aNM5uVjCKjeLzfR3bBcHNqKp2OGC0seqP9yS2FEgZh63pyv9Y8uFoANKS+bqZNJecE0c2PDVwFm0CNjS9hAisI/OiIMsujNiYsjf/ytlbL2rVacp1GreZAx68kBhN5B9NnIlRqJZt7q++Sk7qye/DoAqzoy4AjNM71rwsfWKrFKKzkJXxKtV5uwI/gww6qAe/SBc6U2Z2b/afuVkGWa+IoeD
 UoPO4A+t
 12JZlrijF0LFLqnKTMYqM48H71kI/k05kqsnL376za4ZAkG29wSm/cSaNAZo7+twcHpNi1SA/SV6arl+1+m31te26nHdB8MvzJKhCZ1o2/eQNVu7Dw8Y68DtgLB5iONO/vT3pEMUlXZmzCPaFlBvBMxwdNnJErXVuJ7su+1evTzOvKHIS6l74nGnC3ibQfvAjOY9CnJN6JEtr8c3ral5duyrU+i0RTxC/8SyBPJV42o79KiuoW/rkogYz6m0UzAzWon6ja+tiNUVODUiEMoCeaUgvhKhw8wqracVOFj3aMoIa4Ps5XQXnlLHjRDbZmVZW9vZeRURSdhn3qPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 04:23:16PM -0500, Peter Xu wrote:
> Hi, Mike,
> 
> On Tue, Jan 27, 2026 at 09:29:24PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Implementation of UFFDIO_COPY for anonymous memory might fail to copy
> > data data from userspace buffer when the destination VMA is locked
> > (either with mm_lock or with per-VMA lock).
> > 
> > In that case, mfill_atomic() releases the locks, retries copying the
> > data with locks dropped and then re-locks the destination VMA and
> > re-establishes PMD.
> > 
> > Since this retry-reget dance is only relevant for UFFDIO_COPY and it
> > never happens for other UFFDIO_ operations, make it a part of
> > mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for
> > anonymous memory.
> > 
> > shmem implementation will be updated later and the loop in
> > mfill_atomic() will be adjusted afterwards.
> 
> Thanks for the refactoring.  Looks good to me in general, only some
> nitpicks inline.
> 
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 70 +++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 46 insertions(+), 24 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 45d8f04aaf4f..01a2b898fa40 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -404,35 +404,57 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> >  	return ret;
> >  }
> >  
> > +static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> > +{
> > +	unsigned long src_addr = state->src_addr;
> > +	void *kaddr;
> > +	int err;
> > +
> > +	/* retry copying with mm_lock dropped */
> > +	mfill_put_vma(state);
> > +
> > +	kaddr = kmap_local_folio(folio, 0);
> > +	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
> > +	kunmap_local(kaddr);
> > +	if (unlikely(err))
> > +		return -EFAULT;
> > +
> > +	flush_dcache_folio(folio);
> > +
> > +	/* reget VMA and PMD, they could change underneath us */
> > +	err = mfill_get_vma(state);
> > +	if (err)
> > +		return err;
> > +
> > +	err = mfill_get_pmd(state);
> > +	if (err)
> > +		return err;
> > +
> > +	return 0;
> > +}
> > +
> >  static int mfill_atomic_pte_copy(struct mfill_state *state)
> >  {
> > -	struct vm_area_struct *dst_vma = state->vma;
> >  	unsigned long dst_addr = state->dst_addr;
> >  	unsigned long src_addr = state->src_addr;
> >  	uffd_flags_t flags = state->flags;
> > -	pmd_t *dst_pmd = state->pmd;
> >  	struct folio *folio;
> >  	int ret;
> >  
> > -	if (!state->folio) {
> > -		ret = -ENOMEM;
> > -		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
> > -					dst_addr);
> > -		if (!folio)
> > -			goto out;
> > +	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
> > +	if (!folio)
> > +		return -ENOMEM;
> >  
> > -		ret = mfill_copy_folio_locked(folio, src_addr);
> > +	ret = -ENOMEM;
> > +	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
> > +		goto out_release;
> >  
> > +	ret = mfill_copy_folio_locked(folio, src_addr);
> > +	if (unlikely(ret)) {
> >  		/* fallback to copy_from_user outside mmap_lock */
> > -		if (unlikely(ret)) {
> > -			ret = -ENOENT;
> > -			state->folio = folio;
> > -			/* don't free the page */
> > -			goto out;
> > -		}
> > -	} else {
> > -		folio = state->folio;
> > -		state->folio = NULL;
> > +		ret = mfill_copy_folio_retry(state, folio);
> 
> Yes, I agree this should work and should avoid the previous ENOENT
> processing that might be hard to follow.  It'll move the complexity into
> mfill_state though (e.g., now it's unknown on the vma lock state after this
> function returns..), but I guess it's fine.

When this function returns success VMA is locked. If the function fails it
does not matter if the VMA is locked.
I'll add some comments.
 
> > +		if (ret)
> > +			goto out_release;
> >  	}
> >  
> >  	/*
> > @@ -442,17 +464,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
> >  	 */
> >  	__folio_mark_uptodate(folio);
> 
> Since success path should make sure vma lock held when reaching here, but
> now with mfill_copy_folio_retry()'s presence it's not as clear as before,
> maybe we add an assertion for that here before installing ptes?  No strong
> feelings.

I'll add comments.
 
> >  
> > -	ret = -ENOMEM;
> > -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> > -		goto out_release;
> > -
> > -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> > +	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
> >  				       &folio->page, true, flags);
> >  	if (ret)
> >  		goto out_release;
> >  out:
> >  	return ret;
> >  out_release:
> > +	/* Don't return -ENOENT so that our caller won't retry */
> > +	if (ret == -ENOENT)
> > +		ret = -EFAULT;
> 
> I recall the code removed is the only path that can return ENOENT?  Then
> maybe this line isn't needed?

I didn't want to audit all potential errors and this is a temporal safety
measure to avoid breaking biscection. This is anyway removed in the
following patches.
 
> >  	folio_put(folio);
> >  	goto out;
> >  }
> > @@ -907,7 +928,8 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  			break;
> >  	}
> >  
> > -	mfill_put_vma(&state);
> > +	if (state.vma)
> 
> I wonder if we should move this check into mfill_put_vma() directly, it
> might be overlooked if we'll put_vma in other paths otherwise.

Yeah, I'll check this.

-- 
Sincerely yours,
Mike.

