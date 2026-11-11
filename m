Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33013606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EknY/VKN
Received: by kanga.kvack.org (Postfix)
	id 5C1646B05B8; Wed, 11 Nov 2026 04:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571AF6B05BC; Wed, 11 Nov 2026 04:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460286B05C3; Wed, 11 Nov 2026 04:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26E596B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:32:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA3658023D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:32:00 +0000 (UTC)
X-FDA: 85422321600.26.0C0B2E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D8592140007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:31:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EknY/VKN";
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u758KHAU32PODMlS6tG046G0kAihUmhpRxPra1+3skM=;
	b=dlEUH3TfbEQ22c0sEy9du3nTv8nqr/nS4AqyL2qOEiAeLt/wt1pWVk9LaZOFW2+CY1xv2o
	hnH7AWAzwbUTsR5M5lWhha6VeJuZsWgbR+6KvRmoj01WafdWOZqi5P1QAb4fWyvhCBjfCF
	wAABkrBIoiG+xrp/+VC7pZatMg26BrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389519;
	b=dhe1D4UAHWU8+dqpwNbvX7g19U2s5NYLJlDYclngpmWiyqMWIIGq87wmqLuiMMNCbFAVEz
	ETh1x6nsJBrz89qgnQu0TzDXcaAcnZhVmBfuW0PjBWjYq+obUCKL9ANVp299PIphJDjuve
	0ycdWH9oaTMGp2tx4Rwevn4DIOuEq3M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EknY/VKN";
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C161438DE;
	Wed, 11 Nov 2026 09:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442531F00A05;
	Wed, 11 Nov 2026 09:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389517;
	bh=u758KHAU32PODMlS6tG046G0kAihUmhpRxPra1+3skM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EknY/VKNU6eFA8uwFtk8+psA0CHt0OgX5+D8T7S2I0GL9PblfvtRCOWrm+9NhOpnU
	 I3Q8J59PNi8RkBtLHxX9juiU3U8jabKTIb17+ybbjlYDcap11rJxEqygA/p1LF5ryO
	 UOhTDkT1SaODVRS45ScdPaDF6iik6/dk4Bl+UGJx6zQh2SdnJ3pjKQZMePcmBgpxvq
	 R0Pu6TUF0NhgMX9xWeeSduRtiNvHMOxchBTdJsy5/J6yeVmbrp8k4kfQ9MS3J7Lbt0
	 GVa3OtUULfvUAH2Odx8oHt+AEWw2VeyZry0zy8yhv7HP5CpdXZoqQYuDWdMwlfaPGA
	 TxWZzuyTh4xXg==
Message-ID: <be5a0fa0-6299-4ccc-b9bf-adba7fca0208@kernel.org>
Date: Wed, 11 Nov 2026 10:31:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Lance Yang <lance.yang@linux.dev>, "David Hildenbrand (Arm)"
 <david@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Seunghyun An <san55@wisc.edu>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9oqtmebs1jiwwd19gprnibfpjc63fyhm
X-Rspamd-Queue-Id: D8592140007
X-Rspam-User: 
X-HE-Tag: 1794389518-418551
X-HE-Meta: U2FsdGVkX1/AIrYahb3Qq4mUoif2Z672nIMmpwjGvEkTAGAwxXpUpIRKBbxAprpJOAHe3G9G+yszqJ3zkX3qrz5NxHCltrIPnwfdDbCeTexSi6G0jeDJ5Fqfs9EOjLYxGxWE0YDx00jdMY2o71tKV6aU1EiV3I0y39z5YMFEFjVZG9Lg4iPOVKkiAIJ7jEWea1oAKvRwyXMgF8omONIvsOMOtxFsGVa17i8xp+/HBh8oq1VVP8PFwB0mU+ryVn56xCXoU5D4RHfeVMU0XubUdu9DhNGYGN5RW4dd6YeEdUOuUTjVc/nHO2r5Vdo8tVyWQkNLM1S+3W6t2DFbcsne3Xs1jAKf8AL4l6srjsjF/CR51vKjtVjkdUIJ53LwC8Zef4kI1z35yoU5fuFuLzxT7+eJlIp2PLaUg/WpLMPUezMPuMImhU4rySeFXyr+kJk+/h/L0LXVoQ4TvZaETM2JmNXUM1tzBSdH/tJZQ9VebqH0o3r6cWs4Y/Id/VQ3yg3LWsSrKTMykUo5UmlqZHI9EC97ENPfD+QFr0k3bS/OO8hDvbvTcFhev9w8V2shJiunNwhO657KsIghMhcnRXgc+rZ15ouH0N07XUx/YE2ke1UKcODTxPZHTQacP1VR05uuT7r3UmQonSRDfnQ3wGXz5j+pOlR7QYvZ8FlRm/ZoYnWJP9Qkountqzf7FQhv9KFcZ5HSexT8A+R0gOXSrQO7o8+xdiUGYMebLpX0QK0rT0IkRdw57rHB0511AqMsRGy7Xr5Pahg4y0cR7V0x0Uzz7Bi+mIbRVjkxNlmSPccVg1zZigIp5oUbrarfPlTwLJNo7QGNZwYppG3q9u9PIzSI78tvKD4EzUdRyEVD+sGlZ1pA9V14cObJpLIEBWje3L5O1e35lD66ClpTuHMzQ/fS2LgyPaU8+v7X4mzh26GWWwp3xThi3X5YesBJsFyNm88rLsVVDdUBtGgje9+JGTB
 b7ql2Vsb
 WBY3UEAZzkf1/vTER2wczxL9NO2/aVJc7zBz85eOu7CtC0+6Q0l1vtVLXFIr4h7yjfLvnXB4w3ZOEuDnzr6sWRfJZokGrV8ao/eWh51B1fLJfBpEGbCqGKde+1xF0Qaas/e01kr3yqvAyJM2llQXYr7qjrlvd6odvs5dOD4019ng44gnAu0qZKfu/fv3aNqldqsso4lIqh5SEJoRFV2geT1sfsELIJknk05vmS2nx+agrr+2Bc13lGmWdXdzDw5ebGLWgB3GemYOn9pPCx0P6IeVZ6Sr5KjbnrDtVQYqgo3CgC+c33EEUPJRs1y4ptQGWKJC7qr77v1LGy9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 16:10, Lorenzo Stoakes (ARM) wrote:
> I introduced commit 17fd82c3abe0 ("mm/vma: add and use
> vma_assert_stabilised()") with the intent of picking up programmatic bugs
> when debugging mm code, but kept the general practice of asserting even
> when CONFIG_DEBUG_VM is not set in line with existing code.
> 
> However, it turns out doing so can cause performance regressions,
> especially when asserted in vma_has_anon_rmap() which is referenced in a
> number of hotpaths.
> 
> Since the intent was always a debug-only assertion, explicitly check for
> CONFIG_DEBUG_VM and do not assert if it isn't set.
> 
> Really all of the assert paths need to be predicated on this, but start
> with this one only, out of caution.
> 
> Additionally, since a detached VMA is trivially stabilised (nothing to
> stabilise against), check for this case at the outset, and update
> vma_has_anon_rmap() to not explicitly need to check for this.
> 
> This also, importantly, avoids reading any VMA fields if CONFIG_DEBUG_VM is
> not set.
> 
> Target the commit which introduced vma_has_anon_rmap() for the fix, as this
> is where the issue started manifesting in practice.
> 
> Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
> Reported-by: Seunghyun An <san55@wisc.edu>
> Closes: https://lore.kernel.org/linux-mm/20261110000002.1834454-1-san55@wisc.edu/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> Note that vma_is_anon_rmap() was introduced in 7.4, so no need for a cc: stable,
> just needs to be sent to Linus as a hotfix. Thanks!
> ---
>  include/linux/mmap_lock.h | 19 ++++++++++++++-----
>  mm/vma.h                  |  3 +--
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9ccbbcbd7aca..9c3a9c6525c1 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -408,6 +408,11 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
>  	vma_assert_write_locked(vma);
>  }
>  
> +static inline bool vma_is_attached(const struct vm_area_struct *vma)
> +{
> +	return refcount_read(&vma->vm_refcnt);
> +}
> +
>  /**
>   * vma_assert_stabilised() - assert that this VMA cannot be changed from
>   * underneath us either by having a VMA or mmap lock held.
> @@ -418,9 +423,18 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
>   *
>   * With lockdep disabled we may sometimes race with other threads acquiring the
>   * mmap read lock simultaneous with our VMA read lock.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
>  {
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
> +	/* Detached VMAs are trivially stabilised. */
> +	if (!vma_is_attached(vma))
> +		return;
> +
>  	/*
>  	 * If another thread owns an mmap lock, it may go away at any time, and
>  	 * thus is no guarantee of stability.
> @@ -454,11 +468,6 @@ static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
>  	vma_assert_locked(vma);
>  }
>  
> -static inline bool vma_is_attached(const struct vm_area_struct *vma)
> -{
> -	return refcount_read(&vma->vm_refcnt);
> -}
> -
>  /*
>   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
>   * assertions should be made either under mmap_write_lock or when the object
> diff --git a/mm/vma.h b/mm/vma.h
> index 3fc3b47a954b..05300badd70b 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -278,8 +278,7 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
>   */
>  static inline bool vma_has_anon_rmap(const struct vm_area_struct *vma)
>  {
> -	if (vma_is_attached(vma))
> -		vma_assert_stabilised(vma);
> +	vma_assert_stabilised(vma);
>  	/* KCSAN gets confused about the optimistic check. Silence it. */
>  	return data_race(vma->anon_vma);
>  }
> 
> ---
> base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
> change-id: 20261110-vma-fixup-debug-asserts-2d327fe27f8c
> 
> Cheers,


