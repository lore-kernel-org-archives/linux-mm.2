Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A823F0182F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998E06B0005; Fri,  6 Mar 2026 07:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946896B0089; Fri,  6 Mar 2026 07:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8283B6B008A; Fri,  6 Mar 2026 07:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 714F56B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:17:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1ABA8C216F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:17:09 +0000 (UTC)
X-FDA: 84515537778.29.0EF97DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 51BA8140015
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:17:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JE9hl+xg;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772799427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BV8fC1T//HdeySruETzb+RJ8scMYDvmvtEN6cwp8Bkc=;
	b=pHpXPKB93gUULB+ziexeGPRPH6PVZb3svf5Nziqg3PaOc4V60Wl/A3Vk0NJhWtDjpq/ZNv
	P5pGJxGdHJGTf89uwp/4mChOKVIQ9yx94pqzRfO/Wbv13G/ck65jtQ99aslRPVIc2tR81e
	0JyHs8KfJpcgKyA3MgI8n1bfS5uYKrM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JE9hl+xg;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772799427; a=rsa-sha256;
	cv=none;
	b=FDEvgKiUoSSDUXr6fYmi1kSgmepxy5H8m7uMlJ2C/ad/2zcXR9ZrILcxfi7n9g5gOh63WF
	3ADwA+1b67ax8A21KeLoWqS6iLegZxGK5YR/9/Nd6UAYF+Y66hydMfUlf+f4+UBEBFE4tB
	GFtGKZBKt1Ef/X/gsMjU5we2KV1c46Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 516C242A97;
	Fri,  6 Mar 2026 12:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9601AC4CEF7;
	Fri,  6 Mar 2026 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772799426;
	bh=E50Nei4wvO5acKQ5WAuR9y8yrxBw8Jw9n6m//WAfpNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JE9hl+xgT0bTGi+BM5jUSHSxJhmfXyDYuZyy882H8pwaPVW4rs91GqXsOlDdNYt5q
	 M4CYD21uXiIoE80aCpIXZWa8pvS6BpzRhby5F3zlbgDBohqfN8gLvqI1ZzEKj9Sq8O
	 1GA8U2yXsayzOcXwk/z9rDzRougLhaH2sFQZ/lImuHVanVDszwy6gcpcLHaEn0JF34
	 5MRb84nwU6hkVV8bxr42O43gDIOYuZx7PoAczRQyQjOzRXl+pydnhhFnDCu0OWdTD3
	 GeXNhxm0JknludP4ZgMHI0L5kkBWpm7KDg9wTx0PM6ikXJpjNR7e3ecgYQUbTFzh7m
	 tM4T4pFHUGsng==
Date: Fri, 6 Mar 2026 12:17:03 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 06/16] mm/oom_kill: factor out zapping of VMA into
 zap_vma_for_reaping()
Message-ID: <d92e21ff-50cd-485b-8f48-621e8ae1b169@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-7-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-7-david@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51BA8140015
X-Stat-Signature: izea6qs5i98o5jhi1qepg8c6hc6tkqkd
X-Rspam-User: 
X-HE-Tag: 1772799427-144778
X-HE-Meta: U2FsdGVkX1/LE0oCGHvKcZy7YnRnk5AKj0NHby4jmjFP3h+Ml6VSkPvSSw1r9x1bmImUDLFp1PWCxv3dnAnSyyq+FRSfc5Z5Yes7lIgMNC/dxC6d0auGDYBCNqXarrdyo0K7Rkv23YU8blui0pdZXnE4fiHnqyU+Gu/p5cpJ4n470Q5uA7CtfEMT51a4UPL6QAZ3pMMYhCSVjIr3mtwTXD2QLYrss4GXKQlW5rqJv2V15WK9mjDWqZOo/Vp/tHUPUgCJG5PGcw88AIdfhcJ35QFh+6U3tVCRRko1emateL5aQYuodW6XNkoURpJuTiE1rVYcl0YpgdJ31An9wIMEKRBXcDwWIYoBiCQKqYI4SykpOjWBXZs6SvY99XAmn4A1Ex6ffOFju6pNyS3Bx6VlXQiL9+7FErMkufSauArrp+UPKEX9jh8YZl3F3jlAy+Z3oLOaB8HmkS+ftefvFnue/Up0UwQbBixIFN7RecNazfyqu6aFLMt78d4WdadSFYkX/GXzVAOvtFIjKrBtHOw1k6DVMpCoBb7PiyDM+Q1z3q2oAfrDx5I045ooxRiK85apgJD2Sg2hxAC9uKAwcRHeLTJ9GBOL4heWEWZnQkusIRyOrV3TMT6YiBRuRr2eQ8VLRtmJbFzCLfytXmUwa49owVJWRmZp6PcHNNPgu6rDq+dV92xp2TJ8+0zVvERRdN0G80d4J8GoiSd/wA1vVZ6WyV3YQhbEbygOZ4/941ru0Z6fTzL5iV+BMMxY+l6FfZ6v65OnIKE2awNtdfV8zI+/x3HXBHECbLjng+We3kmyDH79II8gdkJWzx6bn3uYWJZWY0ZZG53ZoBpP3KnvfmHGU8Kr8OQbtiZgcVFvvNwiR+M6eH8h+GZosWEnQx0CiDwU+zjG9JuR1AeEZEs3Qhpqmr2Ytl3N3WfzFDjmmhH7P4vmtjGCKbYknmdsVDeNolB+Thvy1yMMh8gTdtdeChL
 mTLxrmq+
 H4Ib6jQpDqcvS1f7Z2NMver2h42ouEHFAtVc4lU7lwlGkBEaejHpvUwn7yC9O3noFCTpriLZjBkhDsehU/VyGFb8ueU+JhoMVLS9d+RcIO+Gw+Zb8h5vAXiFSSnfwW6eJSMnofwsZATk3qCn8kRAKh7lQ1g0OnLxBLcuVLcDzDbY7GeFBawT/IZ6jbLFhCv8JIVn5j8gX8KyRugoAxXVS05ZyoeyuRxsZtEZ8pZdNfRmt8pq/jsRbAgJfLQUMY0N1Pbpq3TxOy6wvZoOrEO1417dyY53R9f+INP6+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:37PM +0100, David Hildenbrand (Arm) wrote:
> Let's factor it out so we can turn unmap_page_range() into a static
> function instead, and so oom reaping has a clean interface to call.
>
> Note that hugetlb is not supported, because it would require a bunch of
> hugetlb-specific further actions (see zap_page_range_single_batched()).

Ugh gawd. Hugetlb.

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Seems reasonable, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/internal.h |  5 +----
>  mm/memory.c   | 36 ++++++++++++++++++++++++++++++++----
>  mm/oom_kill.c | 15 +--------------
>  3 files changed, 34 insertions(+), 22 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 39ab37bb0e1d..df9190f7db0e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -536,13 +536,10 @@ static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
>  }
>
>  struct zap_details;
> -void unmap_page_range(struct mmu_gather *tlb,
> -			     struct vm_area_struct *vma,
> -			     unsigned long addr, unsigned long end,
> -			     struct zap_details *details);
>  void zap_page_range_single_batched(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, unsigned long addr,
>  		unsigned long size, struct zap_details *details);
> +int zap_vma_for_reaping(struct vm_area_struct *vma);
>  int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
>  			   gfp_t gfp);
>
> diff --git a/mm/memory.c b/mm/memory.c
> index e4154f03feac..621f38ae1425 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2054,10 +2054,9 @@ static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
>  	return addr;
>  }
>
> -void unmap_page_range(struct mmu_gather *tlb,
> -			     struct vm_area_struct *vma,
> -			     unsigned long addr, unsigned long end,
> -			     struct zap_details *details)
> +static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> +		unsigned long addr, unsigned long end,
> +		struct zap_details *details)
>  {
>  	pgd_t *pgd;
>  	unsigned long next;
> @@ -2115,6 +2114,35 @@ static void unmap_single_vma(struct mmu_gather *tlb,
>  	}
>  }
>
> +/**
> + * zap_vma_for_reaping - zap all page table entries in the vma without blocking
> + * @vma: The vma to zap.
> + *
> + * Zap all page table entries in the vma without blocking for use by the oom
> + * killer. Hugetlb vmas are not supported.
> + *
> + * Returns: 0 on success, -EBUSY if we would have to block.
> + */
> +int zap_vma_for_reaping(struct vm_area_struct *vma)
> +{
> +	struct mmu_notifier_range range;
> +	struct mmu_gather tlb;
> +
> +	VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
> +
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
> +				vma->vm_start, vma->vm_end);
> +	tlb_gather_mmu(&tlb, vma->vm_mm);
> +	if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
> +		tlb_finish_mmu(&tlb);
> +		return -EBUSY;
> +	}
> +	unmap_page_range(&tlb, vma, range.start, range.end, NULL);
> +	mmu_notifier_invalidate_range_end(&range);
> +	tlb_finish_mmu(&tlb);
> +	return 0;
> +}
> +
>  /**
>   * unmap_vmas - unmap a range of memory covered by a list of vma's
>   * @tlb: address of the caller's struct mmu_gather
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 0ba56fcd10d5..54b7a8fe5136 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -548,21 +548,8 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  		 * count elevated without a good reason.
>  		 */
>  		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
> -			struct mmu_notifier_range range;
> -			struct mmu_gather tlb;
> -
> -			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
> -						mm, vma->vm_start,
> -						vma->vm_end);
> -			tlb_gather_mmu(&tlb, mm);
> -			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
> -				tlb_finish_mmu(&tlb);
> +			if (zap_vma_for_reaping(vma))
>  				ret = false;
> -				continue;
> -			}
> -			unmap_page_range(&tlb, vma, range.start, range.end, NULL);
> -			mmu_notifier_invalidate_range_end(&range);
> -			tlb_finish_mmu(&tlb);
>  		}
>  	}
>
> --
> 2.43.0
>

