Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD63FF60D5
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93926B0095; Tue, 31 Mar 2026 03:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B056B0096; Tue, 31 Mar 2026 03:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981326B0098; Tue, 31 Mar 2026 03:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86F546B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:03:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16FE6140B0D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:03:18 +0000 (UTC)
X-FDA: 84605466876.18.E78B001
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77411140007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:03:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7BkWakY;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774940596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFF2P39HJu9lSnrzlWSWQmW/v4vKyAbxlPBbbriygfw=;
	b=ho0wZiRo9eRrOfl7yzwSULDypCQda74tmCixAvzRIDd8/xTNjy5jmXsPG9Js9kVnZy9F3o
	JyHQPzJK1hFKlSQnWtopSHx8wC4KW5j+yt9+8/rdnuq4bDA5T7jqhEdiV4GlEDzgWZvsdq
	Uin+rtINLZ5K2+0BipH89Kdv8mgDjvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774940596; a=rsa-sha256;
	cv=none;
	b=b1yxDNopBDWqiqj8fkSOUrNOJjBm7A60HI4H00jD2tUDnDufBS76GmKUTlUn2am1nOAXyn
	LnuVKmgeaY5Hi176Kx/rHXT/chHx5MjE/uk9CAwkD/z52/EGy1//Aa0fCveDwfyeOA4Juo
	oMXq3+x3CYAixudUoqCObef40Kl90j8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7BkWakY;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95B0860120;
	Tue, 31 Mar 2026 07:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBFBC19423;
	Tue, 31 Mar 2026 07:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774940595;
	bh=ic+S5YIOVZVio0bt8w8FKUddY4R5LxfMt3J8CL3Z2pY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z7BkWakYWogd1+dlacH+q+UQNww+wVXoAME49WY2cx7GjFabSYL49wrASs3mSyhuS
	 kohcpBLMxpJ5WYqZwsAj0+9fWIxhRXPfU9U9VuLRPS4gKM75uM3teIQ0Zu/kZU+ABC
	 4v9e//T8Mwif3OEvRMtktAYV3OgKazSPdCbPR5UmugDNGQa5WzOgd34W0Et+ie4AXp
	 hghn6Ww/zX7tgwUWfWXUGQCNcGRd3VD3++E6xV5ic0jzFd/qGOgPIotcfrq2jpmUcq
	 GEEnFWYaoiTh2dhBX+JEWgWG2JPNWGk0qGJ7GV3jBhIF2ijo3nwaUzhNvHgHp3vH0W
	 UIcnlpKA4zy3w==
Date: Tue, 31 Mar 2026 16:03:13 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <actxscYZGFiyvUcs@hyeyoo>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-3-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330101116.1117699-3-rppt@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: p4hreng9hp64w6gu5ea6u7ekssmxfiz5
X-Rspamd-Queue-Id: 77411140007
X-Rspam-User: 
X-HE-Tag: 1774940596-167350
X-HE-Meta: U2FsdGVkX18+e5KVWj6qPL/gqDrrB2N5KfRM35hC5WmYnQ32ERd4FSzX6ZjcnnCeJQ0nxC5sb9R5iLtDvTPkPXLkpoXhKMrE8SQnOmILG294mnYOY0YXIv5jZ6adOlZZONDKSQr4Lx8u+WsqrDpAQg1McrStMt341zvTp0yVPT+hoxM+4EPinPrI5c3HkO/yVVRcus29K5+IFSdUnBJMF1PJw1kvnnzuNSN6OrSmXTXuGWy+lorD7vj4fhHSfzY2n1oCkvDPJ1b1s3QW0L0hPbwVR00jKeOTj7tzOS3mWKNQ1fPq+UuSKVs+e5X+3JUyw+MnKCkUQmMqxDDDo8lO3rPPbvBdvCXOU4iA05UnNznHqP0Sd2/qSGDO+QEJAHk0XkdjSM29wEVKXdFjzaf+Rl8zseXqbLky2yqQA46ktI92Tpj7aM4rh1upzoEiVkC+Ms4OC8lkI/EPTRZfmtKsjrPYxl65sm7vjQsQCIteG10kTaBP9aMwGU07j2wOmUkbTENVrOCl9p27LMIqvs5tnj+VD9XIi8GuuPMBdKAEdk+H1YHuD5hI9sZ69GNwCEc6L5486Yzk5azXpoV8iNmb+9dR/fEzqI5AN8ISU9qwK/g3m4uJXRXxULnOprj8d4Raxz3gSp9HNCX9aMfsctgfE4VOzujUJ4XBdp6ZSHOOm2igfMVaBW7LSXN8pA4Fb8bPOVV82cEO+kS0jyZ0NVgUyX/FxdzGQEsfq9if5fVHtLfyGMCLleotGjAOLYIEZayG5SoiDMvZiw7AkxgwqIrs9+w7IwXZCoPzw9zCM7LSWAk57NRp0HLn1Mb67A2qoT+12dQiNy8opjxhCStQWhV1ny500u3UB+UuOkv4dFOMhQiv0Ape+mEXseSPGMH0VWniyy2AYCIVaiNS6z0R9XJTnRf7Cn6PAtroy813bBzNlDJrgaDyDZDS1w5430NLgQgxeIZ18pAETjLxfPlr52w
 ut53vCN5
 9JtExOF3EPVEsriP/vB9ml/dc9xJRC7rn6Qmr3ZW6dZHCdLMy0BzMHUgkGcJvvNxQfciwAgc1gJ+QtX6BYTOdktnIQSO7cpiaxCLErVI/Atd6Z+9aLpiCo1EavBCqlEvfVnNpWk1BBxXeRefwUSyyj5T/p5rLEMgwqqOMsW02t8Yhy+EByYN9JBti653GAHzuYM9F3B24Tk6DaWr3t1f6f6wJMF0qYywbEW6t7enYzi4moHWqguI3TtXIYfLmRPq3p349vq4GgiBbiC+VCkejII73uw/3Q1x7gP98ArHORjgpKGX+y1L+yXPiQm/Vrh30miN7mXqgP0zKaawMlbBEzBVTOF74RUCwFvB0OcsEw+2KpZzM+AiZmolnMn9K3rMgDHt0ZpeLsKBoI9UhhoB46r+vlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 01:11:03PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> mfill_atomic() passes a lot of parameters down to its callees.
> 
> Aggregate them all into mfill_state structure and pass this structure to
> functions that implement various UFFDIO_ commands.
> 
> Tracking the state in a structure will allow moving the code that retries
> copying of data for UFFDIO_COPY into mfill_atomic_pte_copy() and make the
> loop in mfill_atomic() identical for all UFFDIO operations on PTE-mapped
> memory.
> 
> The mfill_state definition is deliberately local to mm/userfaultfd.c,
> hence shmem_mfill_atomic_pte() is not updated.
> 
> [harry.yoo@oracle.com: properly initialize mfill_state.len to fix
>                        folio_add_new_anon_rmap() WARN]
> Link: https://lkml.kernel.org/r/abehBY7QakYF9bK4@hyeyoo
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/userfaultfd.c | 148 ++++++++++++++++++++++++++---------------------
>  1 file changed, 82 insertions(+), 66 deletions(-)
> 
> @@ -790,12 +804,14 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
>  		goto out_unlock;
>  
> -	while (src_addr < src_start + len) {
> -		pmd_t dst_pmdval;
> +	state.vma = dst_vma;

Oh wait, the lock leak was introduced in patch 2.
If there's an error between uffd_mfill_lock() and `state.vma = dst_vma`,
it remains unlocked.

Probably should have been fixed in 2, not patch 4...
Sorry didn't realize it earlier.

> -		VM_WARN_ON_ONCE(dst_addr >= dst_start + len);
> +	while (state.src_addr < src_start + len) {
> +		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
> +
> +		pmd_t dst_pmdval;
>  
> -		dst_pmd = mm_alloc_pmd(dst_mm, dst_addr);
> +		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
>  		if (unlikely(!dst_pmd)) {
>  			err = -ENOMEM;
>  			break;
> @@ -866,10 +882,10 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  
>  out_unlock:
>  	up_read(&ctx->map_changing_lock);
> -	uffd_mfill_unlock(dst_vma);
> +	uffd_mfill_unlock(state.vma);
>  out:
> -	if (folio)
> -		folio_put(folio);
> +	if (state.folio)
> +		folio_put(state.folio);

Sashiko raised a concern [2] that it the VMA might be unmapped and
a new mapping created as a uffd hugetlb vma and leak the folio by
going through

`if (is_vm_hugetlb_page(dst_vma))
        return mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
                                    src_start, len, flags);`

but it appears to be a false positive (to me) because

`if (atomic_read(&ctx->mmap_changing))` check should have detected unmapping
and free the folio?

[2] https://sashiko.dev/#/patchset/20260330101116.1117699-1-rppt%40kernel.org?patch=13671

>  	VM_WARN_ON_ONCE(copied < 0);
>  	VM_WARN_ON_ONCE(err > 0);
>  	VM_WARN_ON_ONCE(!copied && !err);

Otherwise looks correct to me.

-- 
Cheers,
Harry / Hyeonggon

