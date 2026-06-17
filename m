Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4D4CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D536B0005; Wed, 17 Jun 2026 09:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEF56B0088; Wed, 17 Jun 2026 09:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8376B008C; Wed, 17 Jun 2026 09:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C32456B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:25:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EEAE40451
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:25:14 +0000 (UTC)
X-FDA: 84889475748.13.123DD91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 81BF540006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:25:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIvMcLUx;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rP9vqOfat9j3sSJpWmjfcwca53+/kNhJYcxVsUA7txM=;
	b=wItKpO80uoKNrnnOb0pfC/YH9u9eRzsCXwcAIYhikvF/w0wp4uIs7qDy6gBvjOtKNeeJph
	q4LVMw9FCno2JU21vmEASm28prFFuNbsO0MttStrWzPVbso6HWbtuyLy6DseoBIkwCmIIP
	zW3qfw77VWJyNddz6Hfj+0L4/2FzgNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781702712;
	b=tmFR8D+3WRDaQRVWh/VJsDkyjsf6TMEVoE8XVEYsPHvHTGv4RwWSIk4LjyW1d2+w4+u9WX
	3miuo1FjpRXCfYTM6zvWc7aZgQ6NkKfQBdx6Jvfleb9AW5pfX94+CdHIgvjDBiASb7o9II
	QIWRN5OAICDGPk0GgqvMwEJKUisLlqA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIvMcLUx;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA01E600AA;
	Wed, 17 Jun 2026 13:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC1C1F000E9;
	Wed, 17 Jun 2026 13:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781702711;
	bh=rP9vqOfat9j3sSJpWmjfcwca53+/kNhJYcxVsUA7txM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IIvMcLUxWj5v4nGYPlCpNoSHynZMFZ0ycglnjXDEXKhUBS4s3Eqj0RJkmuW3ccDVt
	 BVm/fwe7UOqkCOCYJZy5/mwMjGL0MtFs9UMCqvRxM2DVoEsSVFxeTpQSr4tSRJlTil
	 Y+A0tpxxsQ5/OOpmxgd1spylgoLNyMBF6ofcYN4V1LFOZgMkAP+Ypilp3EFK6pzl4U
	 TvZ1Ihk6JU6mOGdKVJYV+I7R/fTgogy9g2IBisZ5SLhYithNPW2JPmBRag1H0XWz5X
	 7rLuhBpFvycO0JMYCvVazB6/JKpMtnZJpIgBv3AR3bdpBscRte0eVJihiP9uY+824Z
	 c4uoFgGQsLWhw==
Message-ID: <6fa17e01-8aa1-4597-a1e0-fa8d95eb0407@kernel.org>
Date: Wed, 17 Jun 2026 15:25:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: mprotect: use walk_page_range_vma() in
 mprotect_fixup()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 81BF540006
X-Stat-Signature: ck44unxogqr4hnnyh837wj15sqbusfjg
X-HE-Tag: 1781702712-515905
X-HE-Meta: U2FsdGVkX1/DzwSg3JKd2eXevuwYIi9DMcq3xRvj+C1kkvULr3sbGwoau409aAMmr4ezgHxSyMtn30B+4fwOLj+cjpQednfIOPJG/bTUJCozVDS0ahNpeRsjzbvkNXe3GN1ickuZY2+zv1bcfXj3ufNjh7ipbabxo630fZFNp30VOEy3bIIkc+h6kdcz5U7rzJJFlfdF7W819Mg4eY2UJx0LldBlFCyCLNkRVYzXooE/WvwiwtfF6r+to1y64x1HXntu9BHYjSUItm3piNboteJpAtos59g9IGdcydMqP/mympXC4bSBE2xn1LB6ql08Z8mShcun0cDN/MNLRW028omIMVCNRqX8Iqtk6pWDm/I52LJ6f4GJfQK2CWe/YLsOKDOEgBWh9fvBcCTz6jogfJ5lQuyWG9wQ2ScHp/QLMNa8FLUAwfS5uLyJMlwVAR0Zicb5UomZcWHd/IzKO7pKSrgb+sZLWRIKLdK7adddboPJL06Pqai8JbypEVMxpy9nRre+hlcxJ6LTPDD/hnrr9e6uluYdz/oYEHqeGP9dbqTkHmatIUPFp/TBn5iFNlyu+SzpvWpV+j/QgqLfAl2ML8/DtEymmG2MEwswXETHVjK4pAcyg2Th0yPkc9eViy20oasK0E2hJYVJ0EFdLlhoBCpGxDfrlu6coTir8yhdLn6be698sOV4C9yasLlVjMnPb70WC/z4BllNwMYijUrBhjjF2lPoR8c0PWL3KyAFakOCLbw+FDO94l1UEAQUw9NLYRY3fjD4FLYOt/VUjnA4Qj/O5lClNvM4YBc+mPmVuElmcA52zWXNFOv1ac8AgpIGueRr6D/hflL1s4lNO+QaYcCv9zhOYnafAKe4S5dN53ri3ZqHhbH/D4MYwhsiOPzBIXTWWYMI/jKBl/DpNmSfPbZArZ9XdADYmu5RNM+7sddHgvnPHQ/wzF/TYMKwIX7LUUgfIfPoECqzH49qzMP
 4HOUEVqN
 S92v5aWBJazEN/2TXTrVS/b6X0xuWGAEKkNpZ0pWrA9Tg1FvbpCkxTCMPxPz3K5+dQGVz4tZookwAlyjQ9wSI/SPxKaiVEHFNl/XnW+uvc8iL1CDofiRow6ZA7fAbCJ/fiD1atpi+uMssry6eGVfFZx59jmyF+TymQs9UFuvr9M7t9NlkgSLto6PpnZ3yjWSeiH8l43Q1LhPazOcFmBzzUTlWUe4PzQmi4AEruQ0Bx4A16gPQoafnHoY9gsjBrKuDwYwHwAjsswVjFRXLlXVJYojliMe2tJBnhkq8BWInqnFvKqpVE3g5BJfKghVKsq8zO4f7EADnEcvFSoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 10:26, Kefeng Wang wrote:
> In mprotect_fixup(), the PROT_NONE PFN permission check uses
> walk_page_range() to walk the page table. Fortunately, the caller
> always passes start/end that falls within a single VMA, the
> do_mprotect_pkey() iterates per-VMA via for_each_vma_range(),
> and setup_arg_pages() passes the whole VMA.
> 
> Note, walk_page_test() isn't called in walk_page_range_vma(),
> however, prot_none_test() in prot_none_walk_ops always return 0,
> so it's safely replace walk_page_range() with walk_page_range_vma()
> to eliminates an unnecessary find_vma() lookup.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mprotect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028c..d26e09862daa 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -753,7 +753,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
>  		pgprot_t new_pgprot = vm_get_page_prot(newflags);
>  
> -		error = walk_page_range(current->mm, start, end,
> +		error = walk_page_range_vma(vma, start, end,
>  				&prot_none_walk_ops, &new_pgprot);
>  		if (error)
>  			return error;

As Sashiko says, prot_none_test() seems unnecessary now.

Apart from that, LGTM.

-- 
Cheers,

David

