Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D050CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0916B0005; Tue, 12 May 2026 13:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990F16B008A; Tue, 12 May 2026 13:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A73D6B008C; Tue, 12 May 2026 13:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74B906B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:29:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2279A16051D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:29:16 +0000 (UTC)
X-FDA: 84759453912.28.68F7A4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88E4940008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:29:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fCP36D6h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778606954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysTuomnEOVe05ZiF3FVO4/YhCPncGlANScRzM9wb2pA=;
	b=HyJ91XvnmrVVUr+RPt7RoROZp6JLJzZvQA6JcPLmcDf+XqNm35Lz9xFsw8x7RuIFf+GkHe
	mIgd9MiWOHnAwILQQHmSNPxzVELm7Q7B4WfLHW65UGGaWXG3xduceP9UtMgGYUych3r3Q9
	TKLcxogJR63FhJI3NaZkmdjfy2euRf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778606954; a=rsa-sha256;
	cv=none;
	b=amWGBf16l9/pavCSLQwtAk7JvSPiFXIJuSdQm1pJq0+cLXnGH3FKeSeyUQTM8mBICARqw3
	nkZfsZuUkxFE8X8t9XhnWQSP2ARhF1qrVERrPCTu6cjQsez0dFkH7L9ZHxLuupTfie07U+
	ziz0pvNgfEznbBPT2yg/H9erqD1DVos=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fCP36D6h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F011760120;
	Tue, 12 May 2026 17:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4FBC2BCB0;
	Tue, 12 May 2026 17:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778606953;
	bh=MSjMy5bmTzDizOb+S9K6KUopbtT/uS4r6RDPEY3RoL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fCP36D6hGBoyDeRJn/Dc1qzoW9BtL6Ojle5dETY8KsAJvmYKrQYVDOd5WXHLNHV7C
	 4Eod8bk+3W+Q70RCUd3tzETjDsNitvvnW+5Cg82IhFOYpCmDxj7Rr7ccrmK2IRNc+t
	 5IaZS3UIEbEafkUCWfZptmDD3+FTDp2Nj/PCzybHGcZ3ebmTPI/Gs+09wqGexreFkL
	 7H0ReV35a+jcmVhvUl+jFMkBHS22NO/4vKhC+HT2hILD4350RqMyY7DlzrSbZZcsWu
	 O2wj3nQwjt3cD/hKEh5TONcnwywnwAtzzmadmQU44xkaxP3ex2wV94BnHwbjEm3iov
	 CFAEFin2mdUeA==
Date: Tue, 12 May 2026 20:29:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 09/14] mm/userfaultfd: add RWP fault delivery and
 expose UFFDIO_REGISTER_MODE_RWP
Message-ID: <agNjXmuEHSaWKrv9@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <454b3381cb7ead65291b2d7e24c0bff62e55c41b.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <454b3381cb7ead65291b2d7e24c0bff62e55c41b.1778254670.git.kas@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 88E4940008
X-Stat-Signature: troqe6fyo1nieshxig9ouhqyfgx56pmh
X-Rspam-User: 
X-HE-Tag: 1778606954-143823
X-HE-Meta: U2FsdGVkX19448X9U92pFoaiNdeklN7xlF3ZNoGK97tZfKD6cEB3JEOBZ7LIf9SBkal+Vry3hl5jwgw7TzRO6FOHudE6ucvgw4GAmeUlOJgt2vlymmoMaqRNtE/5okAW4qV/wlf+/ntZP8r0+4Xf8NyA73rrgaCxEkiyOl2NhO5tm3Tk6dNRNyvOklP6qLWlte9FX5uxCg88hw7aCHfxAWhESolp5RYCC4rSjgABlm0j/cVFd0vQIvk+/UBC3tiW+1EsAHBEXMvU/3nX3TjotM/Auc0jO44rWEyLA190q7Gn8+mDwr/E0SHL/HMGbxByuNwGl92OFfsEs4piM/OpZO3BzAactwXWTxgD52SETMWIRvg1wOJfP6+ZUv7rp0IzCQuHfveeHKZ2dNRp54cLfxkk6Y/aomHctQFRU6AZ+M/wqxidvH5D/WXqDKBkUeHn1PBu3Gz6nhOSOEpPpB6c+UYM2hGFWxnEmWJ3qfa8djDruOuLQ00Mvff1TUrWrf15Up1lNS0IUMpOvwGllX+5c86YYxalTJenCobCeSVtvOK0cbhvNo9/nczzheJqY93FfZcO+rx1emSh+hYKSjzzmIrby2/I0L/LZnTxCO+/4gpKJy4AJKqkhxyukEXCndOopf6KvtPevkb069ZysiZ2gvUMXYB/PQ3wMzIIR3WsrDWfl8RaZpATqYJ6U4A1sDt9kCRu12WJ2IzvjGnb6bHtMEqHd2Utx4h4Tr1bAqJNsm5IguqZ4BRMiXE12MD6VScRKPkpj05RUbYKtemsfqjO9DY3eIB/jworK0GTBVAPOOsiNIhC5JrufYGr6uVQEfkavewkvtCjzflmAth++pue9Wjof2T/YQYsFc7SlKCe1Tf5j+EtpIHzHhHw94Aj6LoVqnwbhQF873Oo4aZlKTCOifpdPOy5qn+cPLu1PGbdN+qDXW8PkFbmaYk/U/IE8bGlWarG1qfJwDQHkptPFsN
 j9PjZKFs
 RXgTTu+h5bbUlxX3rGJUF3MkwXV5oAtnRzOtWhLxZi41Ki0SJul66d1Gc8HZzPSZ4BWrQnxSLYjADpAq9lvxMQKQBn2acLyZPGEy6Y8oZdz+PmK3dBDn0/L0KH/w63rrXODeaW1iZ6mYpJ9DBU4sqU/USkOpX0LU7vAnvoCo4C6v/NnKHUU9nQEDzn5+oozlGuApCOsPxnqox9bwMiRy14Vd8RLnBwq6Cu51v8kzg5fGM+drP6YlRUklZzfM/2fds3lM8Ty3PZcLug+j2ry4U8SqA7Hih2Y8e9sG0cGMAd+N0Cl4xEcs55eVEPEfCeDBQztVOswmjpYGsmuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:21PM +0100, Kiryl Shutsemau (Meta) wrote:
> Wire the fault side of read-write protection tracking and turn the
> userspace interface on.
> 
> An RWP-protected PTE is PAGE_NONE with the uffd bit set. The
> PROT_NONE triggers a fault on any access; the uffd bit distinguishes
> it from plain mprotect(PROT_NONE) or NUMA hinting.
> 
> Fault dispatch, per level:
> 
>   PTE     handle_pte_fault()    -> do_uffd_rwp()
>   PMD     __handle_mm_fault()   -> do_huge_pmd_uffd_rwp()
>   hugetlb hugetlb_fault()       -> hugetlb_handle_userfault()
> 
> The RWP branches gate on userfaultfd_pte_rwp() / userfaultfd_huge_pmd_rwp()
> (VM_UFFD_RWP plus the uffd bit) and fall through to do_numa_page() /
> do_huge_pmd_numa_page() otherwise. Each delivers a
> UFFD_PAGEFAULT_FLAG_RWP message through handle_userfault(); the handler
> resolves it with UFFDIO_RWPROTECT clearing MODE_RWP.
> 
> userfaultfd_must_wait() and userfaultfd_huge_must_wait() add matching
> protnone+uffd waiters so sync-mode fault handlers block correctly.
> 
> Expose the UAPI:
> 
>   UFFDIO_REGISTER_MODE_RWP   -> UFFD_API_REGISTER_MODES
>   UFFD_FEATURE_RWP           -> UFFD_API_FEATURES
>   _UFFDIO_RWPROTECT          -> UFFD_API_RANGE_IOCTLS
>                                 UFFD_API_RANGE_IOCTLS_BASIC
> 
> UFFD_FEATURE_RWP is masked out at UFFDIO_API time when PROT_NONE is
> not available or VM_UFFD_RWP aliases VM_NONE (32-bit), so userspace
> never sees an advertised-but-broken feature.
> 
> Works on anonymous, shmem, and hugetlb memory.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

A small nit below, other than that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> @@ -347,6 +359,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>  	 */
>  	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
>  		goto out;
> +	/*
> +	 * PTE is still RW-protected (protnone with uffd bit), wait for
> +	 * userspace to resolve. Plain PROT_NONE without the marker is not
> +	 * an RWP fault.
> +	 */
> +	if (pte_protnone(ptent) && pte_uffd(ptent) &&
> +	    (reason & VM_UFFD_RWP))

Nit: this fits even in 80-chars line

> +		goto out;
>  
>  	ret = false;
>  out:

-- 
Sincerely yours,
Mike.

