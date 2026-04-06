Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 678BFE9D814
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 01:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144D86B0088; Sun,  5 Apr 2026 21:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFC26B0089; Sun,  5 Apr 2026 21:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FC46B008A; Sun,  5 Apr 2026 21:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEEA96B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:54:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79D4FE0276
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:54:25 +0000 (UTC)
X-FDA: 84626461290.26.0276DFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0EB27C000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:54:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pCp/eFA1";
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775440464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7i0m5IAXL06rNchShDJiw5fum4CPgk9sAr2TZM0AJs=;
	b=ib/O6902xMukpEAWhSK7cxPAvwiU36Vb8TjNRxJV3aD2e+CLU+SbenjhqwckVr+5LkG7c0
	KLdFjE1tk8a4ZnXwoL/+sC+0Caor0EV+tgI+5N0eU2w64jIx2i29Vrk8Vm0n7nzr2GvEMX
	ChKNKKkgf1c9o5Eo3VOX8X3kJ/Ea6so=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775440464; a=rsa-sha256;
	cv=none;
	b=d6ecPeFXjej4QC8MznrlHn0DwtocpM3yNL3db+T5Dw83I/uc4LShuFmEUVOONonWmhZS8Y
	LJ1kg8vqy7DxRNf0xK2MtC2jKBabm/Gsz6mv1INtKc6CBZTmcYFk9ggFWyG2bmGATqzHjk
	B9CO7LAvgFAmHUGxNv/fZay7zQFhEKA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pCp/eFA1";
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23A40600AC;
	Mon,  6 Apr 2026 01:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73543C116C6;
	Mon,  6 Apr 2026 01:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775440462;
	bh=i3tkyONMstJd7/bB4kFhKh47p0J+DD4A0sqUFsz1AKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pCp/eFA19HIS+NAFw7U11vCNfNTYBCc+LISNDwQwpselRC0UaA21FrMIuos8xo9cV
	 4kfOJuZ8biK/kakJnm2xHEos8e0XArbBzRUKqQZ8+/KhYZwFUa185NiHdCyMTWggum
	 e/yvAZzxSkAD6BLjhaLU2RzvoybgovlPurAQeMR1qUFNSaS/Fc7fBsWdceSk9rWIC6
	 4tKWCWRh16r8TAS1dKdtnd7ZjreW8tCsgDYjcP4PEYkXtO3fsM+NGB8a3Og/llrpjE
	 CmxfE1GwW0Inqg4Lmz1ynYR3Hl13kLFkBlTLJR11PNm0oWfYxBHj2ieORA8GqYDakE
	 h1Kmk6mfhBaag==
Date: Mon, 6 Apr 2026 10:54:20 +0900
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
Subject: Re: [PATCH v4 05/15] userfaultfd: retry copying with locks dropped
 in mfill_atomic_pte_copy()
Message-ID: <adMSTB35f-ki15fj@hyeyoo>
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-6-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402041156.1377214-6-rppt@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: cmuui9bze8pf8pwr8qg8pkw3s6snykdd
X-Rspamd-Queue-Id: 0EB27C000A
X-Rspam-User: 
X-HE-Tag: 1775440463-362562
X-HE-Meta: U2FsdGVkX19psX++DmxE+IvMi+WIAg6iQnhB1EbipoM6RhFQMU/As9mcwwtfKIUXcrveNX1K9bS5jkD5cy6mf324VKh+hkqSiAuQBf/Qe6A/rYG/QO9NBrFFWbWrwpRqTGnaIECCPR/qiZ3yHjCjBNkl9a7/j8pvzfZjGgEYd7xv1xSChEKZFNcufnlCM+//JEAsttlpaWy3dQvmCTM4aQ/GUs5LDI9EPLgzpGLGK84VEjLaguFuPHE+fEnvhIZ7Y2U9RCPVvemRe3kP584PhimoOntrcaOCVdxrCRs1a5gVnM5rghYKgO2fP0yMp+9JIyaK89JpgMWQJt4f+KyTqknV5PisPb5ZIFCQ0R/yqiFoYSszIEn2f9eILD3uyOJqiKt1aaEVfVoRLam/EjfvHUdxmxEQ0CqP8tj1OnweLRafLc+JDRSZ8cFm8caBLEFYT+pC7RSNsX1nOsGOmJaP87RBgyjELM2PBJxaL+SRx4ZgIf1WIew7h5gXInxT5uQgjHiybq7uiWp1Kz4Wg2eqmsuGh5OckK1XuE3m2Y0jIRora5ykxsvbnjH0+gF2Bg8QNbMEhwLLQQOP64dC+QSEh90qbugfxqyUpq9ueo5XAbp1umN3FmzYPn4lHt2O7/pewiZyF8rDcVHuyiakHTiyWQ7488yYPbof6metvSQ65wSwmB4kNeHv32HM38bW8/+6G1wa9RgtE5oYwkK0LeVQcKIjkBwlP/3l/njX20uUuOYZ7n/DBtNpGze17zggOWOE/WjxDk5k161wtoG0TzWxq3FMwYY2pAiaIPi+VkA7iYwvEH2jDq7JCQwdXAc3SnrSWEdAGjHfM+CiDv6OY73RZargX77t8mEvSHS+ex+yw3UMYds5UCkRx4+KSElESKxfRSDLfHv0uGzeLPCo/azKrBf70q0SFrAmtKoleulNOISnwL+FkIoGOn12c3hXCTaomx2GfTWvp6JXOf/N73o
 BjUfwrcu
 sdv+g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 07:11:46AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Implementation of UFFDIO_COPY for anonymous memory might fail to copy data
> from userspace buffer when the destination VMA is locked (either with
> mm_lock or with per-VMA lock).
> 
> In that case, mfill_atomic() releases the locks, retries copying the data
> with locks dropped and then re-locks the destination VMA and
> re-establishes PMD.
> 
> Since this retry-reget dance is only relevant for UFFDIO_COPY and it never
> happens for other UFFDIO_ operations, make it a part of
> mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for anonymous
> memory.
> 
> As a temporal safety measure to avoid breaking biscection
> mfill_atomic_pte_copy() makes sure to never return -ENOENT so that the
> loop in mfill_atomic() won't retry copiyng outside of mmap_lock.  This is
> removed later when shmem implementation will be updated later and the loop
> in mfill_atomic() will be adjusted.
> 
> [akpm@linux-foundation.org: update mfill_copy_folio_retry()]
>   Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
> Link: https://lkml.kernel.org/r/20260306171815.3160826-6-rppt@kernel.org
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

>  mm/userfaultfd.c | 75 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 51 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index c6a38db45343..82e1a3255e1e 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -405,35 +405,63 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
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
> -		/* fallback to copy_from_user outside mmap_lock */
> -		if (unlikely(ret)) {
> -			ret = -ENOENT;
> -			state->folio = folio;
> -			/* don't free the page */
> -			goto out;
> -		}
> -	} else {
> -		folio = state->folio;
> -		state->folio = NULL;
> +	ret = mfill_copy_folio_locked(folio, src_addr);
> +	if (unlikely(ret)) {
> +		/*
> +		 * Fallback to copy_from_user outside mmap_lock.
> +		 * If retry is successful, mfill_copy_folio_locked() returns
> +		 * with locks retaken by mfill_get_vma().

nit: mfill_copy_folio_locked() -> mfill_copy_folio_retry();

> +		 * If there was an error, we must mfill_put_vma() anyway and it
> +		 * will take care of unlocking if needed.
> +		 */
> +		ret = mfill_copy_folio_retry(state, folio);
> +		if (ret)
> +			goto out_release;
>  	}
>  
>  	/*

-- 
Cheers,
Harry / Hyeonggon

