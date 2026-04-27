Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBFBFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD906B009E; Mon, 27 Apr 2026 16:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15D846B009F; Mon, 27 Apr 2026 16:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41806B00A0; Mon, 27 Apr 2026 16:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E15E96B009E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:25:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADE331202C7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:25:21 +0000 (UTC)
X-FDA: 84705465642.14.F99FCDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ECB671C0003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:25:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gkxKUB71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuqEfNC9STi0a42y/qCfYZKty2/XnTez6/LZXP9j1Fg=;
	b=1HntZjvadXfM7macaY7qJwxNt2hJX4KJPNR3iKsxl+yQ+25wGVMRM+r9YLpxOru7xt77e7
	RnzFOqkHPsGgq7qcRkauGz5uYDw2EKW6LFwwyc67iJEnVonv4PAPTeZVzIRURtt9Th+6rW
	qKFMSJoSwPzcvN+qEF6e1z3LsO2ooOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321520; a=rsa-sha256;
	cv=none;
	b=WRYdQzQHeLoypY7XakKqalg1XnHa886/3eaHVb9zS+h4E39JcjuOqeS39UwOAcdfC1s+WG
	fQs84LiSmXyUQDcnsEDZwIPZqYkgjenDeQxzj5ffq/4JHoj10PxqP1+YmBp+2RmamipRHF
	sOn/DifKf/q7NMWXs6lec14vCNpXhAw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gkxKUB71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 685D460138;
	Mon, 27 Apr 2026 20:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF12C19425;
	Mon, 27 Apr 2026 20:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321519;
	bh=wZ62JJbJbBFYxmz4nXsEdURZ9ZvZQcCgwl8lIq3rVHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gkxKUB71RDl0C8Txlx3EhD82nFBtJoCkuZlpTFV1lUNcqsSh8sMHSpg9Gd2zDckOX
	 d57E0mKovidPdCFENazaUlbeAwBZzgv6VWMK4AyLbVsRZ31Ky1K0r1lo8HN83yFxFP
	 i5YUdGj4UPCvbyv14v45UZO72SJn+Tq40WipfZVuxjJbQ/X0vysEoxqBKYqq9rBuDN
	 jvpMIXGkqcYdvy9jGQ7rpQWMfjUc4Dsd8Wm6tHbTfcBWjXy/IDMCDd4wOFM2/1RUnU
	 HbYmg7WocFt5sWdAoDVRF9or3z5fNBwhHIBblyV35zwihyDmmm1YU9+O2iFTbzliLT
	 zlb7HcaNpqRUQ==
Message-ID: <5564e170-d052-4445-9914-70bfd852d3b1@kernel.org>
Date: Mon, 27 Apr 2026 22:24:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v16 09/13] mm/khugepaged: introduce
 collapse_allowable_orders helper function
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260419185750.260784-1-npache@redhat.com>
 <20260419185750.260784-10-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260419185750.260784-10-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ECB671C0003
X-Rspamd-Server: rspam04
X-Stat-Signature: kmpcoyhsp6c8r7imnez6tm8e49wjr4eb
X-HE-Tag: 1777321519-378299
X-HE-Meta: U2FsdGVkX19Ynk5B8T4yXyhsL6spTka+i0+z+CYQ3Ypyz2XXpP3WxBy9HCuz0s1bt0mxwIgt8eLyJn0ZGQFL39jNJFf6QvcA+rMGF6bNwPvtdXL+hNDP2slm1t0wdUawqjcTEZX5X51yrsSkm04ZbYWzI3fColb0PpKqwKt1Z154r8GEWZ+acz5WzQRTo8CWY4uFLhhcRSuPKdky/rgZWBZWLvmXtM6Ry2nJQFW5UKuzk6vAC6q27ZaoVFElf19hIrKhp+eRcy1Ybyckk7mDpDAdWhXUO6xtXrOlEEaiTwTmZl5sImjmsk88ed9ASlP9bhp76N+C5ihZg9+DFuEk30vHkm49VsHLwceWogmv3WQFg68dk1EEZXA98C7p54T+/n7qpBJ3srMfZakrEbu6HEveci8tQITniwIErVzPYj0KD/LepNwqSrHap5LNe5/OZeFF8MdV7xYlJ42hKwOxEB3wo0U7AFdcRnwzrnpOM3Gi5h4SDLVsPLlWFaYJBRRUPTpFukx7RKc7iAhzaUYBMVn3/bzPhJb2Z4EgqF5z6Ic9qn+o62Pj1Zcx6UJTP+j/iavdT2b+im651Q/+YCyRUH5yOeubX3EfDnCfKFa58G1y6l27TZdyhSKzd+AxkZ5SpZhwRe9/8Gun61vad/ONrGO1IXbWweR57zw9KApfgUZJ4CaC4uWi4E+spRfOoc+XYEE3hqZGf0KvDryNoLd9caQ4V+kqQLq5OzycxqxJwv3JWr4XH+RDr2x5i0knsyp9OQybmLnlKq/qvrIjpdhsw9hc0/z3Q7LF4lcfzcQjqaoahGwNs2yb2oct3uUJ9MJn0KRsmUzofRAIgQcFfvDPj0psyNGTK7uH5A97OQmFW54OxzLnhKykMj8CI4SZy8A5CLkpFXRFnPHUYfsBblDsI7CnxEHiCkbT2b2f2hgvJJaWWNash58BAdb6L3HLfctML67bf9KwTQ7eDCNGQYn
 Ie6wNIlj
 EMN/Ij3jDt8qf8E6wOPrO86aa1ElnqC3ZCQM/spdEQkGp3HjNwwVqtC0MsRbLeRdLTVlYh20iDMkdnUKjqSDAYfsa1/HjIO9RUQV1YZMA8YeL8494d3aydte6UOo1lM+/che/cS3hH6OpLo6ZCI+avAC7QgwsITLSkRqvMrVkLj/Dy7MQs1NHM5eoXDR4RoGQIxQO7XeTPVh/nliawfPLOLfr/hGJT9VGKtVJQdLr8OOctvWtIFpSDrRnO9LgqzAd5h+7mLe3FyhSLjfPFf82Ly6gX7oPaTCck8u0hl3G73BChX5joBiUkqpB1wYemGoS5Gyx4RIRqBo+xT7FLIGJ9vqyXvjMjYMNqkHLNP0d1eCpO48D97PeB57mYERk32KfjaMVD4gbWXywYgQrluJ6TVat6pN7WrbkhbPkqXy/nv2PDd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 20:57, Nico Pache wrote:
> Add collapse_allowable_orders() to generalize THP order eligibility. The
> function determines which THP orders are permitted based on collapse
> context (khugepaged vs madv_collapse).
> 
> This consolidates collapse configuration logic and provides a clean
> interface for future mTHP collapse support where the orders may be
> different.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---


[...]

>  	cc = kmalloc_obj(*cc);
> diff --git a/mm/vma.c b/mm/vma.c
> index 377321b48734..c0398fb597b3 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -989,7 +989,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  		goto abort;
>  
>  	vma_set_flags_mask(vmg->target, sticky_flags);
> -	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> +	khugepaged_enter_vma(vmg->target);
>  	vmg->state = VMA_MERGE_SUCCESS;
>  	return vmg->target;
>  
> @@ -1110,7 +1110,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  	 * following VMA if we have VMAs on both sides.
>  	 */
>  	if (vmg->target && !vma_expand(vmg)) {
> -		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> +		khugepaged_enter_vma(vmg->target);
>  		vmg->state = VMA_MERGE_SUCCESS;
>  		return vmg->target;
>  	}
> @@ -2589,7 +2589,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	 * call covers the non-merge case.
>  	 */
>  	if (!vma_is_anonymous(vma))
> -		khugepaged_enter_vma(vma, map->vm_flags);
> +		khugepaged_enter_vma(vma);
>  	*vmap = vma;

Are you sure that in all cases, vma->vm_flags already corresponds to
vmg->vm_flags / map->vm_flags?


That's a change that makes this patch unnecessary hard to follow, in particular,
because it's not documented in the patch description.

If you think the change is fine, you should better move that into a separate
cleanup patch where you only drop the flags parameter from  khugepaged_enter_vma().

-- 
Cheers,

David

