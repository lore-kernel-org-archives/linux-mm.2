Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 023CAC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17306B0092; Thu, 10 Sep 2026 10:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8456B0093; Thu, 10 Sep 2026 10:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8FFC6B0095; Thu, 10 Sep 2026 10:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92B136B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:02:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23503160552
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:02:59 +0000 (UTC)
X-FDA: 85198018878.23.52BAC44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42948160014
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:02:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fA2x/ub3";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789048977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qj7jerQrIGn+60nnavoJTceZpIvkRfaJD46i+mDcQ4k=;
	b=r87v2XV3WhPkT8YdNBp+4Z6NjPdgcz8jjMz0+tSZQupbj3gOXX7i9vg0HmV4RNiFczTfzT
	RKO27lQHxJdFj0TUqNy1pVzNa/jThhzrpNHMoAtNMzbImREiYQTRhLnQlvI9elb3P+2GXE
	nP7HG+yP/kzqpU8HZEJO7D2q9L31hEk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fA2x/ub3";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789048977;
	b=HC3jvXKEg8/oDI94H4EH8vWljFciMObx8oJVafew0Ga2u5Sylw2wIeHgm9K4EajafP9JF9
	3hhESBT3FvAk71AB6KcZ6pb01KY51Sk0axIpLkx7ZmmqDGYP+2vXM/NaQ5leQDaNu02Sev
	pYCNbYDDOqACRxxEizSQKQ0bf++X1hY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6748343E4C;
	Thu, 10 Sep 2026 14:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BB01F00899;
	Thu, 10 Sep 2026 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789048976;
	bh=Qj7jerQrIGn+60nnavoJTceZpIvkRfaJD46i+mDcQ4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fA2x/ub3LYfGaIOregLfIXJPVcmYC7hAkDtUCKcAdCRS0QPrURkadHTHdMm/1fTyn
	 zTBFoqftDYUE6bdM2VNXsSADqAQ7ymuRz8BBrqlC3Vbzc7xzFy9r09pCdObupSaLMz
	 P7e5VmCwBULqN5PprSOoP/xt27w159ha0e67YOhFK7sNSwgvnVDeH9pdOC/gU1sk0P
	 29L/IjWnH04bauvPl590zCvm4iQBV3l8hFdeulzAw3yIQye2cQpXDzwsgKAez9oe1Y
	 C8kt+nmb3SdVtrrVGVPiiz1EVgRjh4LHtaUctDFh+7GGooCY6MBRlSN4wTALPo7CYD
	 wIKyEW5mIV52g==
Message-ID: <7d779a3e-0c12-42fc-91e1-fe53ae2dc641@kernel.org>
Date: Thu, 10 Sep 2026 16:02:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: implement and use vma_anon_tracked(), silence
 KCSAN
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
References: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42948160014
X-Stat-Signature: b8fcoq4oaotjyofgr1aquknezqzrabbz
X-Rspam-User: 
X-HE-Tag: 1789048977-352055
X-HE-Meta: U2FsdGVkX1+X308NkQIOOcgY4sM497z3pbld9Zeu66ygj4HhEq9c/jA0V5blft3+zqfrTmchTYiUfFiqe5wh6/weRl03qdnR7EqmYSFhtjhUmj01M5kJBS10hQ1uIpTT7Cdr5WJqntnCM7G/Vztsmzvcam4pQYaYWW39QOmS3GLqO3mEf40XC1xq80SldUc79Oo5vTcSPKkUHDksDLE7yM8ZgNB316SM0prKu86RWPBAHJAGi5mig3EHL/1WWAP5ZXAgPcDvAHxZcsHv72OgTUWAyVZVT4HjZOfIBgaxf/ySaovEuCCerkb09MYvLE3Ee7NeWvtW4wsaiy89wts8YoxWh0RXd+yVJ12voJFYN7Er3ax+a2MtCuAFDIr/H8ofHj5w6xBCLH2c/k8V9enrZSDZFzTS9HZkZZySjvemOJOkZbcBnPlW3DRVMNxR22oRWJ/yB/XJTPtWal3376IUKUw7KLDm3oVtfVkOBRWGX0TfDFgHOetUob1PsJRtUjGvc84Wk3AJgZVN2JI0bgGCHyz9T4/CN5uWXpbdY61PUYGAt24h5uPP3KjyUyRYI4hdFd9h1Pwlqo03MvUFB7vPZyeFj0+FQ8pPhaA+cmN9XXaP3lvxO0l0JH47HDhmXG9t/1XioYAsRrrVPhxGxhZC6ZR7crZBYENqdR8LPLNVDSxYksRasbaARSUL75iPoINczUfsOntLBbWVdnxIQTuQcM6rNcf7vqV8Kt7eSJFozZ9wEtyekEDz8DqoKEECQeNAPdjqnsEKQjy1sJ6uBqMqDbJ92DEl+CSrRUPkwIxK306/q8nD/uhJq0BkYz9ZSP7yNMfkYL2DIZgQEMWcfjOxzjgW7CBWhRdjlHO75q5iUkwbIR4ZzLTCcjGXe3tgcuNqEzIExOwbLduUQgf3h5ReWvqMqqmCZ1MxD376IDUqUE6mGg8hsAIoAiPpj0zuULVGnF+T8frn8uUAbD1n8HE
 tJHBGoGM
 cpPx2e4j7N49RZ17fuDSiXsNJ7pQzFVCgjYTMv7zPUqQTt///kklyX4avBarlBXIwl0uqIdg44RjBo3QLCZulw4jxZnOrNjmvQDXZGBxVRQVk7i85E2M2dU0U8MAg8XOflCU+Vtn762ddUDwv9IdiFKCn2GdMSj8gABBf+LO/dn58tAnMlvn81D+O+obbKcdJYWSIWAEupnIWUMjQXdfQERuhCUpZFdUEFZ5Met/B/NsE53BvLrBLRLlTfHzV96Gm0AU7hknHAEubEuTOdCQm5t6J2GhrPTjiYwEfweWpsnI5Kp9rWrIawAZzlLFJQS9b2W/ultaVggJKRQbqqZxFVQ11GREUgX6F24REaLgP3Hb0I4kGNb/RCILzc2Niv1xkcqY0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 15:18, Lorenzo Stoakes (ARM) wrote:
> Provide a function to abstract the common task of checking whether
> a VMA is faulted in or not.
> 
> A VMA or mmap lock must be held when calling this function. For an attached
> VMA the transitions between unfaulted/faulted state are:
> 
>        Transition        |              VMA/mmap Lock state
>  ------------------------|-----------------------------------------------
>    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
>    faulted to unfaulted  | write lock
> 

Still using the faulted/unfaulted terminology above is subotimal but I don't
mind too much as long as the code is easy to grasp :)

> So vma_anon_tracked() never provides a false positive (the lock precludes
> it), but if only a read lock is held, a negative result must be re-checked
> with mm->page_table_lock held.
> 
> Detached VMAs cannot be concurrently manipulated as they are removed from
> the maple tree so require no guarantees.
> 
> Use data_race() to silence KCSAN about non-existent data races between
> concurrent vma->anon_vma read/write on optimistic fault tests.
> 
> Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
> dependants.
> 
> Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
> preparation callers which test vma->anon_vma directly to use
> vma_anon_tracked() instead.
> 
> Note that the lockless read in reusable_anon_vma() is doing more than
> checking whether the VMA is faulted - it is returning the anon_vma to be
> used on fault, so this check is not altered.
> 
> There is one odd one out - file_backed_vma_is_retractable() - which holds
> neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
> 
> Therefore just add a comment to explain why the direct vma->anon_vma check
> is required.
> 
> Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> v2:
> - Renamed vma_is_faulted() to vma_anon_tracked() as per David.
> 
> v1:
> https://lore.kernel.org/r/20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org
> ---



> index dd66c6ad5af1..40669bec953c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -264,7 +264,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	 * Allow page fault since anon_vma may be not initialized until
>  	 * the first page fault.

Do we directly want to fix up such comments to not talk about "anon_vma" but
instead of the abstraction?

Not immediately sure how to rephrase, but I guess the goal would be to avoid the
term "anon_vma" and least outside of core-rmap/anon_vma code.

[...]

>  		/* KSM folios don't reach here because of the !anon_vma check */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 01e7b6b046b6..9f9cd6657360 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2705,7 +2705,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
>  	if (check_stable_address_space(mm))
>  		goto unlock;
>  	for_each_vma(vmi, vma) {
> -		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
> +		if (vma_anon_tracked(vma) && !is_vm_hugetlb_page(vma)) {
>  			ret = unuse_vma(vma, type);
>  			if (ret)
>  				break;

[...]

> +/**
> + * vma_anon_tracked() - is @vma tracked by an anon_vma?
> + * @vma: The VMA to be checked.
> + *
> + * A VMA or mmap lock must be held.

I would document here what the implication is: if untracked, there cannot be any
anon folios, if tracked, there might. Some callers of this function (e.g., ksm,
swapfile) want to know exactly that: could there be any anon folio in there such
that they have to provess the VMA.

-- 
Cheers,

David

