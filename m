Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED2B60A263C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MzR37AmC
Received: by kanga.kvack.org (Postfix)
	id 530176B05DF; Wed, 11 Nov 2026 04:38:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DFDA6B05E0; Wed, 11 Nov 2026 04:38:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6CA6B05E1; Wed, 11 Nov 2026 04:38:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD636B05DF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8F3A140236
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:20 +0000 (UTC)
X-FDA: 85422337560.03.E86EC6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F2C3940008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MzR37AmC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5p/q3+WMS3ls8L+KObTnHmV8zpLfczVrwuNUj9yKsvQ=;
	b=HG6ZdRleJrfXvqUf9bF42Xf3HrGpwSxwE/GjShXCkwfI9X2ziJKnxomQNwwvinCoD5atPx
	9qVZ+X4bH0Kon+3b03Z4UeIWdSlAAmDcK2WqGKfwWJjD0o/QmDyHaUp5fkZrfe84OOodcr
	7TvcSCXKPZS4DgDPXXUc5OcqM13ziQ0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MzR37AmC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389899;
	b=VtEY5q3e4h+6BAg3VJF/LmmTqWcphJ0e96rNxIZEaq1M8TACWPYGQges7/50gfhLmrS5ci
	kPoiDN+WuPVFODt9VtJuvR6qjWWlHaMWE6uW8gHLWrC6cmwLqvsSbT4+NpHJhxWFMMsSBX
	WwBTAqxlrEmzZLAa2gHKhDqGMp8IpnI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86650611A1;
	Wed, 11 Nov 2026 09:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79D91F00A06;
	Wed, 11 Nov 2026 09:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389898;
	bh=5p/q3+WMS3ls8L+KObTnHmV8zpLfczVrwuNUj9yKsvQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MzR37AmCszwGbQH+6B0ZwpFLoz/cN8Un+xeXNMhovJUZ/SghyRwpY2NP1NfcnmXLh
	 slCIxDons0PwXhP6IQbO5Q+NTv+dwJmdtafsQhv2LJQ9yRoNir8jp7il4Q8ob368ZI
	 9aiFYwL7b6Dy+Y4PfoVdvMIXAAZ9S53m/5DbrpZAEYZeAH0iBM+ofGCE5N6uY1b+wt
	 tnZCwTuG0BiN8pCnOH1DCNxPAT3lpCsEWgr8aoFBUVwOFbf4k+ewGTBFkTXceIRyTk
	 HZGac6UXuQfiCFRdcaCaEH3h8VpZjBmmr5tcc9D7AH0v8kK2vEsSfWudNIVhE3njf0
	 mOnTOJOWiAVRQ==
Message-ID: <d053c2b5-dc2b-4475-9832-db575e4b8cd5@kernel.org>
Date: Wed, 11 Nov 2026 10:38:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: only assert VMA locks if CONFIG_DEBUG_VM is set
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
 <20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2C3940008
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: afyq7aruim4jt61mh1jdz79c6e8zjnx7
X-HE-Tag: 1794389898-117783
X-HE-Meta: U2FsdGVkX19L7nTD4xmOS3rrl1SrDeMaytTcGXDO3UAf4kAfQEyuwJ3gEbXvKIROe5yiRRovn/0XO0BeHdRzMwaDM5CnoyRPHb6Y3zC3ZGBCpLLEe5L5ohbOw0mYyRv6yPrVjKOnJJyipgtgiCux/fhurxEXBlRWfxfYqlfydoPjbC4vOL57+5CsyiC6a+ISaIvRhr+Uijo+vBcjd5NWRPVS/mjZDX7U8kuS1Ehku40BDbk1m4kBlpbetmQKunoKH6u2bWkoIZhc6Y1/ze5tKRlQnpHgsR8Ehsqv8/BJcpqxDHmKgtoJIJtLOqoD08Tb22W7Me5azPrNZc4BttenNU85CyPf/XffnVSdZwSPoewWnDAvJAYkMF+fCX3pPLAVal7djqymPLjq72yGrQrYSr8M95Grdk04/ICTYs6zN4RweuShrlnU5JcofgKjwpYnRWmQuhrPhy0xRNgceNjxIFc1khlUmwEqnZ7c+jIJxMs6Svs+UP8sF4Nc4YJRtHWhAjtV/f4NvzznYkTQJsMzKEhUWF94pMFqaOqbrGeCsdcCP1zrQfQFB2rBtHFlF+J0wJKmBg432zHMV3vI9HxD4CebR2RX0QgpgUgpYcL5RVcldw+Umj5Mf5wFk8XsHf4izF/PFwoND5k1qbruDYe4g1BLCBdG+0UK759wI2bEg33mALwvW6ZCFjTeylFAPCNZY2W3v/h5TDQkDEJdPrdcWwck6VeCb+1GQ20j9MM5FFvlo5v2Xd17AQeOCiPVvxOez5NNfkZg0ejpgduLm5RkOgIJUo0bVoUgfcaiq3mfk+Afm58oUhGw2CwvnicRJfHuqhI+mXYsOUj4/PVlQ+nM1Rp8E81JbEfIz1v988fP/p7SLxWO2cE9iNwXV+0H9DcjxrJKn8idmlQuJKo2+Kw4S75CM/FjWKcWy7cZh4Cw80Aqq+LCwXra4TRjum9nVNq8my8BewYh6plbMIZAFgq
 RXAbO5M9
 f3rb+wt9PoXaPEsDpamraRi55QYwc9BOuaGyzdG6jUqU+b19XUd5wKYCIXn88xGZAw+3CftY1sIIVAGHGf/Afo9tB31Z+ONzlYRygaixTjysuDXrh22YrvouQhP4pi7FHX/Vzf8LRmmwVNv+8Nf80wZmVpcAoZiBvg6ARr+/KwQxCqbDHibRUBHi+O+PqOc2P+57QivwTC+VFm1lFVTdEnV/KJ9/1ql37uqhytjDA5xS5iAD4LqcLODyrlobrgf1lFF0n5Ke3TCB1omsZsP0dkfLWhfAJ7Etawchp/V6Yv1nkqHGN06jRodrq1gz7lpGUzSkSMFNwxqJa4JA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 17:57, Lorenzo Stoakes (ARM) wrote:
> Similar to the mmap lock asserts, we have also asserted VMA locks
> regardless of whether or not the kernel is a debug build or not.
> 
> Similarly, these are asserting basic assumptions about kernel code which
> should never assert in production code.
> 
> Since all such bugs are generally asserted using VM_WARN_ON_ONCE() or
> similar, it creates an odd and inconsistent situation where some
> programmatic asserts are only checked under CONFIG_DEBUG_VM and some are
> always checked.
> 
> Since the intent is the same as any VM_WARN_ON_ONCE() check, do not assert
> if CONFIG_DEBUG_VM is not set.
> 
> Implement by updating vma_assert_attached() and vma_assert_detached() to
> use VM_WARN_ON_ONCE() rather than WARN_ON_ONCE(), and gating
> vma_assert_[write_]locked() and vma_assert_can_modify() on CONFIG_DEBUG_VM.
> 
> nommu loses its CONFIG_LOCKDEP asserts if !CONFIG_DEBUG_VM in
> vma_assert_[write_]locked(), but this doesn't seem to be a problem.
> 
> In addition, there were already inconsistencies - vma_assert_write_locked()
> uses VM_WARN_ON_ONCE_VMA() and performs no actions if CONFIG_DEBUG_VM is
> not set, and vma_assert_locked() looked up vma->vm_refcnt but also only
> asserted if CONFIG_DEBUG_VM was set.
> 
> Therefore simply update these functions such that they're predicated on
> CONFIG_DEBUG_VM and update their kdoc descriptions accordingly.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/mmap_lock.h | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9367430ee53c..bada7a03ddf4 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -354,9 +354,14 @@ int vma_start_write_killable(struct vm_area_struct *vma)
>  /**
>   * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
>   * @vma: The VMA to assert.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
>  {
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
>  	if (!IS_ENABLED(CONFIG_MMU)) {
>  		mmap_assert_write_locked(vma->vm_mm);
>  		return;
> @@ -369,11 +374,16 @@ static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
>   * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
>   * lock and is not detached.
>   * @vma: The VMA to assert.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_locked(const struct vm_area_struct *vma)
>  {
>  	unsigned int refcnt;
>  
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
>  	if (!IS_ENABLED(CONFIG_MMU)) {
>  		mmap_assert_locked(vma->vm_mm);
>  		return;
> @@ -480,12 +490,12 @@ static inline void vma_assert_attached(struct vm_area_struct *vma)
>  	if (!IS_ENABLED(CONFIG_MMU))
>  		return;
>  
> -	WARN_ON_ONCE(!vma_is_attached(vma));
> +	VM_WARN_ON_ONCE(!vma_is_attached(vma));
>  }
>  
>  static inline void vma_assert_detached(struct vm_area_struct *vma)
>  {
> -	WARN_ON_ONCE(vma_is_attached(vma));
> +	VM_WARN_ON_ONCE(vma_is_attached(vma));
>  }
>  
>  static inline void vma_mark_attached(struct vm_area_struct *vma)
> @@ -549,6 +559,9 @@ struct vm_area_struct *lock_next_vma(struct vma_rcu_iter *rvmi,
>  
>  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
>  {
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
>  	if (vma_is_attached(vma))
>  		vma_assert_write_locked(vma);
>  }
> 


