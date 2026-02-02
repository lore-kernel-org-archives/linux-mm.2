Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6BDE7FDE2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 21:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7AAD6B0005; Mon,  2 Feb 2026 16:23:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E282B6B0088; Mon,  2 Feb 2026 16:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39786B0089; Mon,  2 Feb 2026 16:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2FD16B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:23:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E51F580CB
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:23:26 +0000 (UTC)
X-FDA: 84400792812.16.73E888C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04027180009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:23:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MIDUg233;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770067404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAkCddEGgJt8HRpnmblWaVWehXrqOQRfOa3v8YeWJbE=;
	b=I2ClS9HxkUMmIaXBwmkaWLLSNdft3ZbjTEhgSn58RMn/y5ayBst9u72AQLQaMSYAiPYmm5
	tYgScBgZenbNcJl0utTMlv7lomeURcwnQFLtP3ImJ9OUW39NFFRX4w90CTNwuWu9n73jRg
	6jGe+TUYO9YgdN2AqgZOGjAjFTH4OP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770067404; a=rsa-sha256;
	cv=none;
	b=pkDOPzEi50eQsa31zLrcQxZyEqHKxmEp9/p6xRLxwXNTp8qRp4npx8OqBiMDureVcQXoWX
	NCfBvE4KYde3mg456DAMw0rkhC4ZuzUw4ZD4wawRDxzD30LE9dsNa+al04XrYQ0CYGQuvI
	x8+AgdFwkScY9WaCllP+QnO8tPUEXW8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MIDUg233;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770067403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TAkCddEGgJt8HRpnmblWaVWehXrqOQRfOa3v8YeWJbE=;
	b=MIDUg233Jox8hSC9XwCr43H3D2mUCg0bTp3qhs4HVu/EzGtdG7+SwrqLZ6Uzphz8I7rRmD
	9Yd018UsP+et6wmQrkxg6Lqb5UZgWjzO+v2Ljtsop/5XwIrZubiab4dsAhZJFlr3iwlu5A
	qTmlC4o2InHfwaD0X4t24pPJRStGJUE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-opEU2HsGOsOF6QCyMjs4Dw-1; Mon, 02 Feb 2026 16:23:22 -0500
X-MC-Unique: opEU2HsGOsOF6QCyMjs4Dw-1
X-Mimecast-MFC-AGG-ID: opEU2HsGOsOF6QCyMjs4Dw_1770067401
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-503810dba87so271209641cf.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 13:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770067401; x=1770672201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TAkCddEGgJt8HRpnmblWaVWehXrqOQRfOa3v8YeWJbE=;
        b=tHHBKI/biB4pedCgZ9oS1n84Lw+gU4JhTQoebNnqdBge9JS5XuhZlKmAOoArd8wC/r
         kXQD57w4MLptue633tZmb+GaYlDbafW1kva9CZgwv1kuSMRWBcb9JVGckyxBBhCde4yF
         PUyshzV0cDqQi/d5qmWflFtS4bjdrYpNXiQvv/shHGcVBF7dhTIX7oq0rUfCpSjTGsAs
         hhBpLDokJYAPfVCNGW6RJOKCEihu97gHwDmq4hY+64hzgTdYChCVUlwFeuH4RfLmWpFG
         qVBx1w8yvRcIRrjtKWlwoDZVbUNeLVV52/99nj77T0yrk3N4QIDbFvSNSlmFbkm6WggJ
         Bxww==
X-Gm-Message-State: AOJu0YxMJAHPJAjmSGb8ixMJ6Eq6bx8wFAz95VXrnLpaTxBkUE+gKZ6q
	0dKp0XwtWwQmf8KywN18LnjhYmhzSrctcfNnQN99sy8xK5pVzi8WvuT3wwcH/wzQv3tC6L2r38Y
	9FT+N8P4L78G5+3wvP4o0o488y1U2bgb68jxRJqerYdK7T+WKaI/X
X-Gm-Gg: AZuq6aKyXC7PDKdLM/l9pNEl7B8YtQDGj/YM0t3yL8sGoImZTJ9ncyUsFU6D9DBeDFn
	XALtCHYGDMlNx367/wriOTH+A/lmZ9EXWF6f3xd/ocbyvru+FLuVsBh3wz5CFEd/DhEw4v8bi6m
	1T5S8pm6zd9pr/NeKxgudqK7+t+L5ZstUr4BZVyZJzTTM7LpwW9S4mRNlTjTs4wYrpRDujzcxu1
	SQJFH0NRC/3SxRIHHY7ZEqSG1MN2QurokEWDGdgEF6zWbvktkK0/68FvwwsbXUmL4T8WM+v8yWV
	GAREZT6/2HwdrMwxtWSn167E8kK7yrHW4KWDJw1bYJM+ZAzYbuiFdOtBhavh9iBz35NlBtlAiVu
	3u1s=
X-Received: by 2002:ac8:7e8f:0:b0:501:49f9:7488 with SMTP id d75a77b69052e-505d228ac65mr175015101cf.49.1770067400569;
        Mon, 02 Feb 2026 13:23:20 -0800 (PST)
X-Received: by 2002:ac8:7e8f:0:b0:501:49f9:7488 with SMTP id d75a77b69052e-505d228ac65mr175014571cf.49.1770067399931;
        Mon, 02 Feb 2026 13:23:19 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d2847asm1309038885a.34.2026.02.02.13.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:23:19 -0800 (PST)
Date: Mon, 2 Feb 2026 16:23:16 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <aYEVxD_vY-qimMNL@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-6-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260127192936.1250096-6-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cmPkijGGlgYEFtOJqMu-rR0AloMCY8tGseFEUGFWeLY_1770067401
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 04027180009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9bzd6fz8iy8nqka819wd6ekz1q16eqfu
X-HE-Tag: 1770067403-361668
X-HE-Meta: U2FsdGVkX191rhP0IlQzn+4G/bUmNNIKDZaXMdM9zy2i7ZwXmxXXKBs+pu/ScxNsx2O+3/6bxtpXhU9vjhtt+hj/Nr6mtdOzJsfLt4/FxsWx4Iaq/b7mqwr4+Z1PMR8ecMPJ8WVtF1gk0Yp4LRixlMjco/nE2f9gzWE8ZRWkHq3gGg5noV9eaBVFCfhJEsW4+YIRRRilamgkBsxfoqgUW9NedtBjLpnxUXmFaPQfbr1rfbuvl/FdpbMiMWAvCv28GltVIcaLk7JoSq84nVLVEpvw4IM3PY4S4HJUGtIFnN6wAJOBCAJgJSdlwAZOFhyyjsrHLp9GubWvjBEA8bwa1HoFVEXPHjmd1HUOjuQou79PsVb/fun8FFJP0HVhpt/O1wbYPtCcaM1/kvXCjtvaE4cWERruDfyEeLKrVT4gr+CF/HP/cDi1ziXBmJ1nrRqeGga61MTQKe7R9bcRuNzJ5LluWdOFp9gBXSBp2dMJLl+oXeR4jaH91bYtH1Fflb2+LDPsQwIlayYnrvj0n4wNHlG9m1hsrHvSKM36nHGq5r0VFfFYm6Pwd7vYWgQBhaRuKQlg17Q0DfOUxfkcKQGGc/Cmak5GjBTv8CxeHnaxKGKGPyumK62IFbhn4NioXwCEn4d6Efz1IUtzx2eA30ogOkNhEuMrFGGjUmBJkf/f9jSSeo4U1yjaqxxN7Y9vupwfCf4OHM8jO22dWrFikKHEBK83aK4e0w1zVTPhtvnZp+ia1z5bi82nZRA31b/a9skAYmB0dRYSA9wG9m/Dkevx9KIr/jAoRvQx7JA52cmdQghjSdudGKXH9A3/837QjdQq2HO8cRdi07/FFkBzipxVnn7nUR8ot5TUOb081lXDGnZuWsQLbUWhuoiOJs8WvcFphXQyAAtDp1qjlZp8Wov0gPUm5nF3X7In7cjRWCwHpAHPSqDYtHXWa7TyWIetSdRbuu0NXNgpK+PUwRam4ou
 uVF85p3G
 4hS16xdvGeVVpakR4y2CpLWgXIHpzmqe9XmZ+E1hHRbg35kcMAv2S9Tl73oO3dkW+B/3ZN22YOeMx1d2kctZ+Bd/O8Vc4PMUlfrLwPjtYQ/ii5OD3ep+fyrq01v47VvRWkQKRBDrNW7JcMWQCjYTMFygagCw32uCVmYwJDj4bhZ8G9AKTYfQaQIjXFanSLkeWmN/88SmnyxeV4GHaGLcJHprhs4VFg9C+T4aYciMalXUhk3VFIeOadbK7nqVbKZIYIjRadDQLrsmvg+8OAvM6Oy2w2XHfXuTJ7gGJ8DUV5DIRD0Y17ARjJ1IU6Y6mk1b0EBZIvkRRgA3KyFjx+qy/ptPz9oBtwfi7IZNj+aNc9h/3Umt1jQd6dKJlLh55m8bdBLhZ7OLqMIbzYKiSZfkT4ChOaraRayvMzEntsSfqiz9jhgzIFbZzs2amAy6j1M+GS/3fTDS8kYqCGcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Mike,

On Tue, Jan 27, 2026 at 09:29:24PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Implementation of UFFDIO_COPY for anonymous memory might fail to copy
> data data from userspace buffer when the destination VMA is locked
> (either with mm_lock or with per-VMA lock).
> 
> In that case, mfill_atomic() releases the locks, retries copying the
> data with locks dropped and then re-locks the destination VMA and
> re-establishes PMD.
> 
> Since this retry-reget dance is only relevant for UFFDIO_COPY and it
> never happens for other UFFDIO_ operations, make it a part of
> mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for
> anonymous memory.
> 
> shmem implementation will be updated later and the loop in
> mfill_atomic() will be adjusted afterwards.

Thanks for the refactoring.  Looks good to me in general, only some
nitpicks inline.

> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 70 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 46 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 45d8f04aaf4f..01a2b898fa40 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -404,35 +404,57 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>  
> +static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> +{
> +	unsigned long src_addr = state->src_addr;
> +	void *kaddr;
> +	int err;
> +
> +	/* retry copying with mm_lock dropped */
> +	mfill_put_vma(state);
> +
> +	kaddr = kmap_local_folio(folio, 0);
> +	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
> +	kunmap_local(kaddr);
> +	if (unlikely(err))
> +		return -EFAULT;
> +
> +	flush_dcache_folio(folio);
> +
> +	/* reget VMA and PMD, they could change underneath us */
> +	err = mfill_get_vma(state);
> +	if (err)
> +		return err;
> +
> +	err = mfill_get_pmd(state);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
>  static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
> -	struct vm_area_struct *dst_vma = state->vma;
>  	unsigned long dst_addr = state->dst_addr;
>  	unsigned long src_addr = state->src_addr;
>  	uffd_flags_t flags = state->flags;
> -	pmd_t *dst_pmd = state->pmd;
>  	struct folio *folio;
>  	int ret;
>  
> -	if (!state->folio) {
> -		ret = -ENOMEM;
> -		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
> -					dst_addr);
> -		if (!folio)
> -			goto out;
> +	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
> +	if (!folio)
> +		return -ENOMEM;
>  
> -		ret = mfill_copy_folio_locked(folio, src_addr);
> +	ret = -ENOMEM;
> +	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
> +		goto out_release;
>  
> +	ret = mfill_copy_folio_locked(folio, src_addr);
> +	if (unlikely(ret)) {
>  		/* fallback to copy_from_user outside mmap_lock */
> -		if (unlikely(ret)) {
> -			ret = -ENOENT;
> -			state->folio = folio;
> -			/* don't free the page */
> -			goto out;
> -		}
> -	} else {
> -		folio = state->folio;
> -		state->folio = NULL;
> +		ret = mfill_copy_folio_retry(state, folio);

Yes, I agree this should work and should avoid the previous ENOENT
processing that might be hard to follow.  It'll move the complexity into
mfill_state though (e.g., now it's unknown on the vma lock state after this
function returns..), but I guess it's fine.

> +		if (ret)
> +			goto out_release;
>  	}
>  
>  	/*
> @@ -442,17 +464,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
>  	 */
>  	__folio_mark_uptodate(folio);

Since success path should make sure vma lock held when reaching here, but
now with mfill_copy_folio_retry()'s presence it's not as clear as before,
maybe we add an assertion for that here before installing ptes?  No strong
feelings.

>  
> -	ret = -ENOMEM;
> -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> -		goto out_release;
> -
> -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> +	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
>  				       &folio->page, true, flags);
>  	if (ret)
>  		goto out_release;
>  out:
>  	return ret;
>  out_release:
> +	/* Don't return -ENOENT so that our caller won't retry */
> +	if (ret == -ENOENT)
> +		ret = -EFAULT;

I recall the code removed is the only path that can return ENOENT?  Then
maybe this line isn't needed?

>  	folio_put(folio);
>  	goto out;
>  }
> @@ -907,7 +928,8 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  			break;
>  	}
>  
> -	mfill_put_vma(&state);
> +	if (state.vma)

I wonder if we should move this check into mfill_put_vma() directly, it
might be overlooked if we'll put_vma in other paths otherwise.

> +		mfill_put_vma(&state);
>  out:
>  	if (state.folio)
>  		folio_put(state.folio);
> -- 
> 2.51.0
> 

-- 
Peter Xu


