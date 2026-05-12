Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDA1CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9026B008A; Tue, 12 May 2026 04:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0496B0092; Tue, 12 May 2026 04:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6386B0093; Tue, 12 May 2026 04:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 884046B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:42:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 315A516040A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:42:23 +0000 (UTC)
X-FDA: 84758126166.06.65D0B8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 57007A0009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:42:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aXarLmuQ;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778575341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18XV/SdfXX7GOCPZaWOB9pZs+RMhfLeXJanxl60tAYY=;
	b=lmnQd2lr3Wt9E4G1NttxbWmDxx0JYD++0D52f5Nqm1wMoU0142gCPPt0RmHvq3p3KREaip
	qK/kocJ5T8bAI5V6onfOIL4zDnepPILvUrm/w1f4TG05ykBmp5jqFTeWBFusLLsUvAz8At
	EU2k/CiHUxYrMHkWWIPYx78ewyb8ufc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aXarLmuQ;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778575341; a=rsa-sha256;
	cv=none;
	b=QSntDyTXpt9Op/RWCe9d9YiNhVqbVM3h9dutCWfzOBshOYgNvQTzqJVeLe1unMkRl34TmO
	I0OsrtABMOBbeL4o/H2cH9Gipp2twSreKPz4XAlrMyheYGesgGgkKYX3IBK0ffb5JL6GyT
	9DffpyvATSX723W++O+dkzQgV9UOguY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 403144214F;
	Tue, 12 May 2026 08:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AD5C2BCB0;
	Tue, 12 May 2026 08:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778575340;
	bh=ljMVN0mSJd0KTMjrcegOkqI698VOfIwxmfgsHJ7qRXc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aXarLmuQ5ZFeOPSU6FhyRT4yq+oRCm5H7/kGva7h7c7LxWbIU9kmR6BUDWhapDUzH
	 FDOPx1WtzILPuT68FbOg95T+Le8esLE8B4CuCGLvXh7IUSCWolvsrnNIdEVCNUA3GS
	 HmGFWvPQw4rtOPuWuuvejg41lAKu/JAP65G+JcK9ufm6scgCxP+KCoTAwOIMgtiEx4
	 E7ijKwL9qJTTVpAnq7cTeyd4VqVa2xoJPEZuclth0mKK/EViKcX7Ek9Ds5LzGKisO7
	 JqO3VwtI/KRB75BnyN1Lrure/YkgfeeHIeAC75tZP64qgkpEivZLjyA7WNLweI4LmH
	 9aX3zDFYIbKeQ==
Message-ID: <563bb216-c270-4711-adda-b91484af40dc@kernel.org>
Date: Tue, 12 May 2026 10:42:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/hmm: Add hmm_range_fault_unlockable() for mmap
 lock-drop support
To: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
 kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, longli@microsoft.com, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, shuah@kernel.org, skhan@linuxfoundation.org,
 surenb@google.com, vbabka@kernel.org, wei.liu@kernel.org
Cc: linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <177759840859.221039.13065406062747296947.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <177759840859.221039.13065406062747296947.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57007A0009
X-Rspamd-Server: rspam06
X-Stat-Signature: 67out81r4sjyia7hqw57grhrtkrhfnod
X-HE-Tag: 1778575341-349205
X-HE-Meta: U2FsdGVkX19yc/Mq8VNJTlH5GAeoaKWuiZuPoSSowW924tuVpi6JfCATyr/7pMIpzOBZnqaDg1ZBeiW5UsoY+kzXcatjnDiWno4wqmQjWlvmqp2wL8xNRndP8nkCsSjfQ2/Xj03sL9u/1Rra7HgFnJXqp4gBFSV/XRUvqo3ueEacDUdHv9xrl38SvsHd2AA878hiJYRb+1xG9pmi/5n76V9fkv7Ey7Q2tMbXwogpNovsDZRAJmk5nN9K4eFTrRqfpwoe7ktooM8tyuOChFaseJQypWR1ZNjAY+LO1/CwGMil+2cGLNA9+4vy2D2Om4ccVCcpfvHeq9aZ4pH0e2ynt6/v1RswQlWqPwB7XiRr9rNdxseK2vx0kfvWH/6yx5x6aU2pfK99szJdiDaSnr6vr2vluNynyUcxUoPz5fpnu3v1ElddezNBVF3hNrlSqPjgPaCcF5p1k3wig2aWTWb8HoUCn4oxbuZ+jDq4GmllXd1g6F6QVqavbdCibaI2o4+be9kSFej3qXoy50HlM07xG9HY62Pwyz3G2Ir/fzUJPgPd7lM0ckOiiPsZD4ySKH8QXdSoy50W1Z6hrJPPuJpbjPRX+05XR22wacbfeMrEK5Tl0V4NjbXXs87aOYRKRDNLssLkA60kZZ53hLEmzhK1Qd/2Fj4u8D4cGVu3hh3TCGi36/UOKUopLvRJfTx5VCe8r/m3PyYK7UYRfqVs1ZeCn7V3BVu8IiqMUCL84r2Wc21l+k4tIOVFT4UsQS/C76GuwbkNQB0DBIDLL1Aikc/w6wJq21NrHv6mY1s0oDLL2nR5AgZIgYiYDjgj0V++PjrIa2h1u8xjYZhYqknFY0M0vQARVxQprehWTjTAUdcKbo8D0MKcttNseUHxiPc4Q6+y74d6u9VgDs5AAx7N2Wi3NRe1hwejCPRAsSAiZ+nTZm0867CL+WO3jU37rGXal/0A1sfjYS0IMuTaaVotfUJ
 0HQbOQ9Z
 t8/ldMg1P3pTnAhizrJ5Pi0OM5063lVbUlgIe7ZPqDJf4s5icfx15gTtl9ez3wvCzagDeb1uKt4r8j5vgr1VzgSQFJPw+27PI8esNDY9ZrYLjFt04iCRpzY3hom+BNpg4+SMzHLV5I+Dy0ZkDc7B8gfNFT7XSdD1quT/nxAMlQ+xwW9jU60eo/+FZ3Ugf6Euo985OqLeoRohno5cpkWQF3L0WvBanMLQLksXNSI4z3H8EHQ/8/gY2XZ+aptlReU5g8tHbRzE4LdyJpTOXWtRtAt6wXKbfS9qhwaqqFXAzOyhDAw5PQnU6k42Org==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +	for (; addr < end; addr += PAGE_SIZE) {
> +		vm_fault_t ret;
> +
> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> +
> +		if (ret & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)) {
> +			/*
> +			 * The mmap lock has been dropped by the fault handler.
> +			 * Record the failing address and signal lock-drop to
> +			 * the caller.
> +			 */
> +			*hmm_vma_walk->locked = 0;
> +			hmm_vma_walk->last = addr;
> +			return -EAGAIN;


Okay, so we'll return straight from hmm_vma_fault() to
hmm_vma_handle_pte()/hmm_vma_walk_pmd() -> walk_page_range() machinery.

Hopefully we don't refer to the MM/VMA on any path there? It would be nicer if
the hmm_vma_fault() could be called by the caller of walk_page_range(), but
that's tricky I guess, as hmm_vma_fault() consumes the walk structure and
requires the vma in there.


Note: am I wrong, or is hmm_vma_fault() really always called with
required_fault=true?

> +		}
> +
> +		if (ret & VM_FAULT_ERROR)
>  			return -EFAULT;
> +	}
>  	return -EBUSY;
>  }
>  
> @@ -566,6 +585,17 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
>  	if (required_fault) {
>  		int ret;
>  
> +		/*
> +		 * Faulting hugetlb pages on the unlockable path is not
> +		 * supported. The walk framework holds hugetlb_vma_lock_read
> +		 * which must be dropped before handle_mm_fault, but if the
> +		 * mmap lock is also dropped (VM_FAULT_RETRY), the vma may
> +		 * be freed and the walk framework's unconditional unlock
> +		 * becomes a use-after-free.
> +		 */
> +		if (hmm_vma_walk->locked)
> +			return -EFAULT;

Just because it's unlockable doesn't mean that you must unlock. Can't this be
kept working as is, just simulating here as if it would not be unlockable?


-- 
Cheers,

David

