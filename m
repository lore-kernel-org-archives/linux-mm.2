Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7A6E7FDF0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 21:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1F46B0088; Mon,  2 Feb 2026 16:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0486B0089; Mon,  2 Feb 2026 16:49:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D6E6B008A; Mon,  2 Feb 2026 16:49:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A42B06B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:49:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D49B713A486
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:49:18 +0000 (UTC)
X-FDA: 84400857996.28.99923E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8314C80004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:49:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dC9PfV2S;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770068956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5FHEvnvdTlqMH7yVdF7d/M75bDKDwBnGXhGmTp6Y0Q=;
	b=2GF4cN3iXww62sCFQ8FB5i+RFz4uyIzvk7OaAXWON8UuEx3eWXYx6a9XeSVKo5VZmwowJC
	MsQRa8JIdkV7p9htXMwk151NAN3QB6gZ5FXzTAKx6yaV2wYSOu6FO9NIfWAHZdVqTxMNsW
	6cEW7QHAl7Ezw+pp3GnVLWPWRnOPFPk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dC9PfV2S;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770068956; a=rsa-sha256;
	cv=none;
	b=XufFhDhOCIpNPrDvCgbcnLi9sIBRwbDFQzAOap7V2ZnR+ohSfrCw4gRP0dXto33yAQnHb0
	oQ7DkhCi+Q7LdBobNEaoUxiXih8C+GdNSwePMMt8IF321xey6I4cDbXf5NT0/H6C6a1Aor
	m5ZPwIqmQYQvAZZEW2kM+EqkQQ8sao0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770068955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g5FHEvnvdTlqMH7yVdF7d/M75bDKDwBnGXhGmTp6Y0Q=;
	b=dC9PfV2S23NzRDLslGa0rn8B/iyYqPnNZCuJ3pui6BnkRF/xDyNRBr/1Zr6beN6D2R3MoW
	JtLpDWvX7PRsi0DJyffXtUQPiHynms8IzHXMsFZW/8xfzs/rbpkW7rzrXkbDiFHQb3KrGk
	np2g0P3sKdveqBp/WVy8Ucn0UR/DgB8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-JrORWuSfPn2ui_W0tuwhUQ-1; Mon, 02 Feb 2026 16:49:13 -0500
X-MC-Unique: JrORWuSfPn2ui_W0tuwhUQ-1
X-Mimecast-MFC-AGG-ID: JrORWuSfPn2ui_W0tuwhUQ_1770068952
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5019f8a18cdso164951731cf.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 13:49:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770068952; x=1770673752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5FHEvnvdTlqMH7yVdF7d/M75bDKDwBnGXhGmTp6Y0Q=;
        b=ku8E/xJaN1EY34yYir3IVtmWrWHuRPbO9tk01jgRIddkg1n+zdLXebMUuX/rnQ5aiu
         pFE6KWcokBvQLgJZzHblwAkDe6c//tU6dqblBGgIF7QdeQpjvUSl24Fz9FwF9qMEqxb+
         2Z0DQfadT1GShJm2Inlkyw0Ay1oBetUD9OmR+0UccE0bwycpvXFLFn7nbNI3H4nVW2+t
         h5DcqRoeToZnfiX6HVf8j4Iy/hQUkXR/RYhza0WPZHwv+QGXVQ8ZYFCz2Wt9w/PHlPGh
         Dr7RpEqYPGqfMcqhVGxty8xNOudT22mqqnv6elXrBOLm/dY+DfEOTVXqTwJuPaOnVUNF
         tErw==
X-Gm-Message-State: AOJu0YxNn8JNVm/bKtLRck6dVKWVNfeQLdOmmZMT1+gHbE5QstiKkMnk
	bFFb376Y1c6BTqAFZoyMbikU9w3aVvyrLQzIsXVXu3EK6q9zJv1TssdKDFX0eFwjkQETyp5ELol
	2hFqbowLMBY8z5hPxlCsQ/UEefHhDT4K0W/8+N0DunfIVfqCPAeQ1
X-Gm-Gg: AZuq6aLOJ3bCImjGRHrjiXFEBdWP5shVbwP+MHoiRbMCTr+T2ohEOM4k7Mi05tcUHVZ
	K5Aje3/dngXkDj96X0nIhA4PwkhjP/OjS6kM7WY56p8hqn9LNJGUN+2sr1cg+u68UwdkeX06wf9
	eQA9znDSWJ9+IAkPq+zleSEIbr7jqNO6B4KQDaz5SRX2zTjjgk04ixkxnvREbG5d0IQbVB2NtSE
	W8azui3dswRz/v2q54Z1+6wb6HeyOw20TQ71AXZqDM3aGM7rMZle0TX299tZk1zpT7HaLnYujyM
	foL95tbDeIqEbYFVz6aIBcT4EjTMl4oAdZNJVZucJVc0lMqzXR/wt1zC36pjal5PiijZefadvqg
	556g=
X-Received: by 2002:ac8:5a92:0:b0:502:aff1:5689 with SMTP id d75a77b69052e-505d2152eb7mr156388341cf.7.1770068952328;
        Mon, 02 Feb 2026 13:49:12 -0800 (PST)
X-Received: by 2002:ac8:5a92:0:b0:502:aff1:5689 with SMTP id d75a77b69052e-505d2152eb7mr156388151cf.7.1770068951834;
        Mon, 02 Feb 2026 13:49:11 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337bbbd2csm114145581cf.25.2026.02.02.13.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:49:11 -0800 (PST)
Date: Mon, 2 Feb 2026 16:49:09 -0500
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
Subject: Re: [PATCH RFC 04/17] userfaultfd: introduce mfill_get_vma() and
 mfill_put_vma()
Message-ID: <aYEb1RlGWBJWKXNg@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-5-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260127192936.1250096-5-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lN_4j9PK5WFWwfm-rJEXbK0-lXP8SS_Y1M4So3WEENE_1770068952
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: zgaf89u46e3obphz8jc94q8brb3haz76
X-Rspamd-Queue-Id: 8314C80004
X-Rspam-User: 
X-HE-Tag: 1770068956-139292
X-HE-Meta: U2FsdGVkX1/s484dnM+IgUwf75txVG324n3ayRNRkY2KaOqs2yn1Gx7eBh779tCjwmqaSu5dqSqOw+clxqC/r+4Av+lMUG2jBKRZR9+lkl7dVStRn82atN9BD/nUkQAmetqcZ+gAAz0CpBoAQPrwwLMp6rxQZeLwkyQomSY3TWeIh0eJ8v6Q+BKdKFPRiaaR97uiU2Ah4AbFAz8IjAUrgRq5gZPUsngNXtZbcFWpsg0wCNwb3JbXUUEY1KzcTSuS518UniEMHgnMDfywalOUkCRmCW/n/PWSJQZHrRtmZ/kTRfcyuOdT8ffUaRjuN+hPyXfMx//Wbkn2KeWZX4Nmp1fRHhEUg6Jf4vy4ewJIMGHlWjstxtW4f5YiqJ8ul52Qyt7ZWaVZTC/1K8L8QJUb7l22qyPZ8QhvlywhTWk4jLYof/ooY7kPy3sBSOzQhDVjcJRNVj7C2rkJM7Hc+ailZ1eIzx+azr5mlLx/05NYabIDlOInQa4Zmk/dcrp8TZRmXwQt2zc8PyNlWyMOufKD69NETdp6tG79+lyastomimIBKET3pOzEL2rZypXupucmLk0FYRHAfUsOyUXE8R9q7YC46I+5lwUSxJGAsf9dn+uNb/w+030387SagG/1m+ID1Kt52kttjYe2P2jXIh0gBAQnTpAuqNpLwXTh3dilfCIbba9qOR7Wyd6CeK8yPp4OtXnqLi8grpF59+PZwFdEHZa4ws+RVA4rN15RIACkokOXGXIaN54le56PPOcplxNfwMBMiZKKqtknGHDg9jIVZvY70xU4cp3H/cKzslZwJbG+l4jsYM/WN33YrE+mmC4q4JqwSN1FYvtGvwlnq+JKixvT3pcBMythZaVTSSn329T0v2asG5LEkGT1wG9MLFZYlyV8Om4Qqa3ON7fApWsnpOXi4AcWZpF9853Zl4guMM/FxbrPf00ExRtKtFdRWo4ceARZxc1ozt9IxyXvQp5
 9C6aP3mJ
 MKJUASL3Rcd76eXAqU82p8E9AgI+A+7KRWTvDBd/QNHVMLUMKLKmcimGzC8jWuxhMeG39+Nl7t0xbyVOEuxUY2BaM13sLv4I+7Ie6pArmQbZxzbV1Q8hPcKENdXduK/I+pOxrkPR76L/WFkNnc9eP50En50kgex/2zxhnN4antDcm8eygTSul7gQ0Osa47dryfYmMBhilu/SkSM87VbLUagnBIwB6KFEtNTylt9htyfMTF3jROq249GzPU7MehAcjwgF9kFWwL+IWbfXlAXIpgyL9ledIbgCESAORxfA1UvcL3BqEjxlI1BwAPbhGQKl0RqEhuWur563dyM39/3U5BAYFQAx3nGx3twhOb3/XMEwNc2hoZrkzinQPHSoJ4CwW1KR7Kkz4AQNRrJ8wG0M30oSsNFNDosId/bux4xdEseEQmHTx1z+uOAvlT+AtH3liuf50LA/4Me0By/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Mike,

On Tue, Jan 27, 2026 at 09:29:23PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Split the code that finds, locks and verifies VMA from mfill_atomic()
> into a helper function.
> 
> This function will be used later during refactoring of
> mfill_atomic_pte_copy().
> 
> Add a counterpart mfill_put_vma() helper that unlocks the VMA and
> releases map_changing_lock.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 124 ++++++++++++++++++++++++++++-------------------
>  1 file changed, 73 insertions(+), 51 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 9dd285b13f3b..45d8f04aaf4f 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -157,6 +157,73 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
>  }
>  #endif
>  
> +static void mfill_put_vma(struct mfill_state *state)
> +{
> +	up_read(&state->ctx->map_changing_lock);
> +	uffd_mfill_unlock(state->vma);
> +	state->vma = NULL;
> +}
> +
> +static int mfill_get_vma(struct mfill_state *state)
> +{
> +	struct userfaultfd_ctx *ctx = state->ctx;
> +	uffd_flags_t flags = state->flags;
> +	struct vm_area_struct *dst_vma;
> +	int err;
> +
> +	/*
> +	 * Make sure the vma is not shared, that the dst range is
> +	 * both valid and fully within a single existing vma.
> +	 */
> +	dst_vma = uffd_mfill_lock(ctx->mm, state->dst_start, state->len);
> +	if (IS_ERR(dst_vma))
> +		return PTR_ERR(dst_vma);
> +
> +	/*
> +	 * If memory mappings are changing because of non-cooperative
> +	 * operation (e.g. mremap) running in parallel, bail out and
> +	 * request the user to retry later
> +	 */
> +	down_read(&ctx->map_changing_lock);
> +	err = -EAGAIN;
> +	if (atomic_read(&ctx->mmap_changing))
> +		goto out_unlock;
> +
> +	err = -EINVAL;
> +
> +	/*
> +	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
> +	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
> +	 */
> +	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
> +	    dst_vma->vm_flags & VM_SHARED))
> +		goto out_unlock;
> +
> +	/*
> +	 * validate 'mode' now that we know the dst_vma: don't allow
> +	 * a wrprotect copy if the userfaultfd didn't register as WP.
> +	 */
> +	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> +		goto out_unlock;
> +
> +	if (is_vm_hugetlb_page(dst_vma))
> +		goto out;
> +
> +	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> +		goto out_unlock;
> +	if (!vma_is_shmem(dst_vma) &&
> +	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> +		goto out_unlock;

IMHO it's a bit weird to check for vma permissions in a get_vma() function.

Also, in the follow up patch it'll be also reused in
mfill_copy_folio_retry() which doesn't need to check vma permission.

Maybe we can introduce mfill_vma_check() for these two checks? Then we can
also drop the slightly weird is_vm_hugetlb_page() check (and "out" label)
above.

> +
> +out:
> +	state->vma = dst_vma;
> +	return 0;
> +
> +out_unlock:
> +	mfill_put_vma(state);
> +	return err;
> +}
> +
>  static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
>  {
>  	pgd_t *pgd;
> @@ -768,8 +835,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  		.src_addr = src_start,
>  		.dst_addr = dst_start,
>  	};
> -	struct mm_struct *dst_mm = ctx->mm;
> -	struct vm_area_struct *dst_vma;
>  	long copied = 0;
>  	ssize_t err;
>  
> @@ -784,57 +849,17 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
>  
>  retry:
> -	/*
> -	 * Make sure the vma is not shared, that the dst range is
> -	 * both valid and fully within a single existing vma.
> -	 */
> -	dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);
> -	if (IS_ERR(dst_vma)) {
> -		err = PTR_ERR(dst_vma);
> +	err = mfill_get_vma(&state);
> +	if (err)
>  		goto out;
> -	}
> -
> -	/*
> -	 * If memory mappings are changing because of non-cooperative
> -	 * operation (e.g. mremap) running in parallel, bail out and
> -	 * request the user to retry later
> -	 */
> -	down_read(&ctx->map_changing_lock);
> -	err = -EAGAIN;
> -	if (atomic_read(&ctx->mmap_changing))
> -		goto out_unlock;
> -
> -	err = -EINVAL;
> -	/*
> -	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
> -	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
> -	 */
> -	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
> -	    dst_vma->vm_flags & VM_SHARED))
> -		goto out_unlock;
> -
> -	/*
> -	 * validate 'mode' now that we know the dst_vma: don't allow
> -	 * a wrprotect copy if the userfaultfd didn't register as WP.
> -	 */
> -	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> -		goto out_unlock;
>  
>  	/*
>  	 * If this is a HUGETLB vma, pass off to appropriate routine
>  	 */
> -	if (is_vm_hugetlb_page(dst_vma))
> -		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
> +	if (is_vm_hugetlb_page(state.vma))
> +		return  mfill_atomic_hugetlb(ctx, state.vma, dst_start,
>  					     src_start, len, flags);
>  
> -	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> -		goto out_unlock;
> -	if (!vma_is_shmem(dst_vma) &&
> -	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> -		goto out_unlock;
> -
> -	state.vma = dst_vma;
> -
>  	while (state.src_addr < src_start + len) {
>  		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
>  
> @@ -853,8 +878,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  		if (unlikely(err == -ENOENT)) {
>  			void *kaddr;
>  
> -			up_read(&ctx->map_changing_lock);
> -			uffd_mfill_unlock(state.vma);
> +			mfill_put_vma(&state);
>  			VM_WARN_ON_ONCE(!state.folio);
>  
>  			kaddr = kmap_local_folio(state.folio, 0);
> @@ -883,9 +907,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  			break;
>  	}
>  
> -out_unlock:
> -	up_read(&ctx->map_changing_lock);
> -	uffd_mfill_unlock(state.vma);
> +	mfill_put_vma(&state);
>  out:
>  	if (state.folio)
>  		folio_put(state.folio);
> -- 
> 2.51.0
> 

-- 
Peter Xu


