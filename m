Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567D0F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3C76B0005; Fri,  6 Mar 2026 08:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691F86B0089; Fri,  6 Mar 2026 08:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E4B6B008A; Fri,  6 Mar 2026 08:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44A0C6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:26:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D56CAC1ECC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:26:00 +0000 (UTC)
X-FDA: 84515711280.05.C519489
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EAB1140019
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:25:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+rWmYyq;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772803559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LFhEDz+8fbvJWmaugKgIjBYARs432xMAbsmDyA1By8=;
	b=s1rKOEree+yeY6E3fM/cglWJca8OfBimQIa1+I0YUr2+6nKwQgbl922NC962hr+wS10J2C
	i6lLBfRw2wY1yRW19eU9k84exmhM56T5kwUrYJDtNso6lgwztrUXDAH1bPvaE4zzU3Fmbp
	3PhLv/YL0DG6wJihOF3R6n3tteO/QvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772803559; a=rsa-sha256;
	cv=none;
	b=5a9qMDkCzshxHFzudy3msZohZ885iImjWe3XQFT/HV/3o3/ya3sncs68EvZvsHuFgcDA8K
	e2shdnjwc/EXdWq20gRwybi6v9egoBRKDNB+/mrZU7ZlQGzzE9J8By1L2zAbhYuUBd609Y
	kGALBjcD7MzS/HuqAR5nSZ9nmktHWT8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+rWmYyq;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7418D60127;
	Fri,  6 Mar 2026 13:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2742DC2BC86;
	Fri,  6 Mar 2026 13:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772803558;
	bh=VU30iKH+h/qW7CEQKlKOIowLeYhmlgQ/q/0Y/mYCK3U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V+rWmYyqOSRcqABxv0QWdLshlJpYgu7fEwgb64B0fTA/c6pgG8MG/w+ZcKT0/BuWP
	 PXHroR3YWS3vqI4BXdgO/PxHbkyiiDZx4CmTzeiMilwaV9zEePGKlT7F+TKuzNdFq6
	 v2AJAZCJG5oFbUGQE7dJAZb6p4yLwKqLyUPcFhQnI/04TmuuPHAC8Dlx12mvsL1UE+
	 2la+iQcxibbkBOTCIH3s+84DEkiaAmThXEppa4VEG3WIhzOKk8/fe/f2f7DQvpp676
	 uLIpdNki57hG3MPr5ty1Pt4afb+h9Ntc6yYqShkM0PHnlXPALS6pVO+pdo3KeYSU62
	 7t2ssBVeagtzQ==
Message-ID: <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
Date: Fri, 6 Mar 2026 14:25:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to
 mm.h
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-2-david@kernel.org>
 <833950ef-e01d-4914-b5f9-bc1f6261b184@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <833950ef-e01d-4914-b5f9-bc1f6261b184@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1EAB1140019
X-Stat-Signature: u8rxed4qhhy5xxdjkfn718xjf4mdommh
X-Rspam-User: 
X-HE-Tag: 1772803558-624120
X-HE-Meta: U2FsdGVkX18SlogAw+NmBOUu29rusZBjrJsa5PIDGYzO6VPHFnM+I0oqDr837NH6HnOBR3B6X7UELLF/YuAq4fJC/BW98W+WImdTkuJsWUFe6WZylHD9gcJkDti1PzhmSjjEN8XdG24u/uEuA8Q2aVUD1BzNi/kMP4XYLYtpmsRDwiCjEOnSbBII9xmvdMlCYIlJChuuwRr6OrkdMRptWZemSzYdz/giWQySP9cravYVgK8eEyiHfIryUVgocgiwn4dgHx5gHqad17sSLkkV9iCWE/O/yhuWG2MrwFswNDAVSD/GLC+Is5PbPPmpTVAqSalAwaRi0evJTnM77YOodb5ukXbvwRRikWcNEUkwAxh8lMwjFlyLYFjrDt2iP1F3UEWFCGK9HTqNb83jnul1DdHzaod2c6ZzxSmQ5jjFIkyHemGN3wx0RHgku1dIH0PtJ3+iKTbUS43sdf1JCvYogRzFsBMBbBjyuUp2Ta07s+0XxVBQpQ4Oc+UHhnrcpxNmQQMWtdziX0WCcRcVg0iIOQituEN0cv3NaWCNj25db34yumJJb2+Xep7g28P6h1etIhwdRi7ij+v84lrJxQi1aacUG0GNSJVzwDNox7Ur844DTCng0f0ruYsB0/BQaDzbyhwnWceFgBGmAXmSaCEL2NVnZl1Y5Aq/n3Plp5qmqHIsvGtgnFdYsoeKwh1UA5vdSuSfQlYXKVfopfEu2L3vbsWHJUr7h3T1SbsiO8zI0s5i+Nw3B0m0gvo17Y4K1Ve6O8kosJ9QcoTk07RZ9mxt8yIneXh/rrLcaany06I01nGUGD29OTVk3MRsTFDEua8rc5G+VmXOEAFqzBfg5oesUZBUYeGzpUnkeZmymbkwo8+eaLdqNPTCNLeANm+kuwbvzyWPQ1AIQ96n8iOTBnNXoQdSlN38G9r1isnRfYhHzRsTgXU75SOxMZIy9aRNUDTgWl1QdLwiZZb+gHzJ/+D
 gb6sbBQ+
 i0F3KiL1OfyDj/mo5x1AFnZ5INxa9KQ6YgW36L203vsorIZ0g5ey8uRVj/x1FUnuBVGzzM5/EUshTaXwNY2AWQhT32dMUDh+kC4xz4H+ytZLl/jcwtA/rc+ijPIc71/OOjRxSjNOHOQC/lYYFcuHiz4F0h607qkgQ931ikHuMOLAVLMQxk4ghPUPPMHjjhm154TgLZ1yJjO9QxCB5x33sbHUFlcoXL7mxJWumqQOrq84BKVyOrzluHphCTSx6/U+Rc/7MBFmf2l72ExC6rWeRXuZJleiOelYbtL8aNaaV8OhbW8vr/ydHtJ4iDIBQKU0mVyM5fE+0X+mAi7wdxhgzQNTwV9F4UJWNmZ2R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 12:07, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 06, 2026 at 11:15:57AM +0100, David Hildenbrand (Arm) wrote:
>> In the past, only hugetlb had special "vma_kernel_pagesize()"
>> requirements, so it provided its own implementation.
>>
>> In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
>> vm_operations_struct") we generalized that approach by providing a
>> vm_ops->pagesize() callback to be used by device-dax.
>>
>> Once device-dax started using that callback in commit c1d53b92b95c
>> ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
>> it was missed that CONFIG_DEV_DAX does not depend on hugetlb support.
>>
>> So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
>> would not pick up that value.
>>
>> Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
>> implementation. While at it, improve the kerneldoc a bit.
>>
>> Ideally, we'd move vma_mmu_pagesize() as well to the header. However,
>> its __weak symbol might be overwritten by a PPC variant in hugetlb code.
>> So let's leave it in there for now, as it really only matters for some
>> hugetlb oddities.
>>
>> This was found by code inspection.
>>
>> Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> LGTM, but you need to fix up VMA tests, I attach a patch below to do this. Will
> this resolved:

Thanks!

I assume that should go into patch #2 instead?

> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>


[...]

> ---
>  tools/testing/vma/include/dup.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index 3078ff1487d3..65b1030a7fdf 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1318,3 +1318,10 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
>  	swap(vma->vm_file, file);
>  	fput(file);
>  }
> +
> +static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> +{
> +	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
> +		return vma->vm_ops->pagesize(vma);
> +	return PAGE_SIZE;

Should we just KIS and use PAGE_SIZE for the test?

-- 
Cheers,

David

