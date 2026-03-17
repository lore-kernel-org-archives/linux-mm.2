Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702B9FED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48186B0098; Tue, 17 Mar 2026 13:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A200F6B00A3; Tue, 17 Mar 2026 13:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CE26B00AE; Tue, 17 Mar 2026 13:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84AC66B0098
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:09:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2310157F1F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:09:01 +0000 (UTC)
X-FDA: 84556190082.07.49DB24C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7681FC0010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:08:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=usGdVw0r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773767339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7w1fJ33Hzq0Ot7xj/FF2bs3alCoXurkOGhF0sTTfb0=;
	b=TpJwCuHXJVND4xaxhytNNebuBz0K7EGHDNyZ7kFN4y/vVdF+w+wDtoOWB8EqGLLC/3eYTu
	onEtlx1+uGtiUXL51NB+/pEdfcKuUjOCGj2n7SKxI5bGJ0A1YMShF2j4r/joAcFPteeRDi
	iBCXX6bGtza6w+e2Rf/n3mifPB9S25Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=usGdVw0r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773767339; a=rsa-sha256;
	cv=none;
	b=c96xn4rjTBtkMbw1UkfoEsEwTJD4HgfreL55B/pHAv0kuyJxOcOEV89K/8PKbhOPWiAmb2
	fv+6zhDOLLQJOW6WqprVY4LAii3UlNQ43WK7xy/dHcm3f6SCOeUlSDwhsHZhZABIrjcE/0
	/vEdr0ZIbsQCjdD8n7i9yhtw6Jvfb60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8EC560008;
	Tue, 17 Mar 2026 17:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EE0C4CEF7;
	Tue, 17 Mar 2026 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773767338;
	bh=x9BTIGZzr3hc80r0W62D2cj+dgKrooZSBRROfEEbIcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=usGdVw0rP3j+0LhJLU2epl98cNaZ0uScq4rblM4OenxjiW4jGQLxs7eu0wjSl+qDp
	 0BoZnqlw2iM2xjT8ez+Sz6+/GMpISO6VRiC1kebcQxPbdcucPUZpSMsXsNF3eKJBI3
	 MsWHdF0pfJCUXkfymaY9R9xYdco82zqx/oJ8aV7MZeaxGBQfL2KML3lqZ54bCEXa6R
	 lsobOAFjVonT7uvMfKqCbAep7/1NY/zehfITw2nD+ycbFiMjW2Wl8wH+g6tPc0kXVZ
	 lxyLfxzmWVokRGmA8fBRg+pdSAFWIUyrvUf49oDch52dan6BWM/+POkfM+3GG/z3yU
	 iBAkk79KaA4aQ==
Date: Tue, 17 Mar 2026 17:08:56 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 09/13] mm/khugepaged: introduce
 collapse_allowable_orders helper function
Message-ID: <0f8d6387-8ab1-4175-aa5d-667c7176fa05@lucifer.local>
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032542.233891-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226032542.233891-1-npache@redhat.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7681FC0010
X-Stat-Signature: oho4idjhgipxhmh5hb3kgqbonkwbzgqb
X-Rspam-User: 
X-HE-Tag: 1773767339-955317
X-HE-Meta: U2FsdGVkX19Y6Wnb+ViWqZWa0VwobpgRHJ9h7qI/V1TY3K8sJQRkszNnlmfus5BQ70CmfRuVxd/m8dZgRxY4fgqYECcO9bQVDQutnAsL99Wz2RkucU30G8DFrCNNxLbl50lNAvgAdhORAGDYesM+P5KLwjfopB1gSNvdbtIRaPYSCgmnhgR6o/TRCYFWzx0n0sp8/Ky+i2DHO0SaacUcqdz6Xlmf8epR/wCdEDXOrugFsJ+GSZxvbxaGRQWItKbSUFzuoXLiTcNCsepedDEgeq8bHhMWF0HCGprWyBE8KYR5DG1DT8D5SDSu+Ce3UCPb5pLte1Z0P0rCvw6M7F8uE6MkCSEDKTTbZxq5JAs/139D6Cl8j3CnZ5mN8BD9LYGSMDQUzMzatl20WeJ56An7ZPxTOm+7ctEBlV/YlDwFRTpwXuNJNynmdUGhCtqw1TrGtD6pwP85Ih3Sm/9AoqrD5VynMqc1Ie9FL/OUXPjXVduB9OI8hUYyksENMowIGiTaklxkAC+PlywYDV6B+ZXhhVUDqi09Psr4o1KvC0GZPMERqcL20y+NlFr3I0RZ0vi7CdE1sMEO1Pb7DHIBE4ppTcCaikCc/X8Rdm4lZhf7SviypqNJI9rn0aPS6kVkD3SEFyvT1yIQW1bO5MoLrLhGrpeoHz3CsHGxC2hqXzl20WZQHQtB5U30+WCwKLxEMlk5tD1jc5pLMYHjX65ZXg77/X6/7woCzqHJOw7SJaz7idXJH9Xer9rSk0gU5dhmRYFRGlJO5dTl5hWZFzvgHPC917J83BA1Aw+3GY2d0O0WAcQZrzJhGZQ+aIUpXNxsPoBFcoDF7ASuszMYHHmRG5cWc1TDu1OBvS/LOXPW03hkLsKe9Et3tRK2CQYwmAHwPn5F3tuSdiXT5XWPn+822OXt1jmlCKryTIs9zXXwxMoaduomEbi5Wc9bIzq2z+kzpvbLMQTbpx8xigqL5jNtFwP
 OfzZ8YOc
 FbYo2GxzzKtRHQSAHCtXLNmSrKab00Z1uQ2xVAzET5ycgAuRrADCccW9ILaEMVwHl+qVG/i11ARIpY6faIdHar+sulo0w9FQMVbnXaT9vc8ElTuWS5TNXKFg8RBuKwWTPibfJug7MqpZ2zTpVwJ9sPvoKeeBXOK/YCRav4WYZTXOH35tMPhd/t661rZd/FyHjnd7Dc/kT1422X4VdnBoEkndIrFJ0QgpfXQT09OzjkD8nCbOXWUfwwjl9CbJFUaEjJ1TQyLj0raz+HbcqXWAfoGe4ShSjQ2KTZJLJP8puK3eo/ROEZIOakAjRlp4gd58NtGKtPnQY2Valkks0gEJPUkJpc1E2Xl9NZ23oY5ctBZZakuE4nrO4/UTmwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 08:25:42PM -0700, Nico Pache wrote:
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
>  mm/khugepaged.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2e66d660ee8e..2fdfb6d42cf9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -486,12 +486,22 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
>  	return -EINVAL;
>  }
>
> +/* Check what orders are allowed based on the vma and collapse type */
> +static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> +			vm_flags_t vm_flags, bool is_khugepaged)

You're always passing vma->vm_flags, maybe just pass vma and you can grab
vma->vm_flags?

Really it would be better for it to be &vma->flags, but probably best to wait
for me to do a follow up VMA flags series for that.

> +{
> +	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> +	unsigned long orders = BIT(HPAGE_PMD_ORDER);

Const?

Also not sure if we decided BIT() was right here or not :P For me fine though.

> +
> +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> +}
> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>  	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))

I agree with David, let's pass through the enum value please :)

>  			__khugepaged_enter(vma->vm_mm);
>  	}
>  }
> @@ -2637,7 +2647,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>  			progress++;
>  			break;
>  		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/true)) {
>  			progress++;
>  			continue;
>  		}
> @@ -2949,7 +2959,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
>
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> +	if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/false))
>  		return -EINVAL;
>
>  	cc = kmalloc_obj(*cc);
> --
> 2.53.0
>

Cheers, Lorenzo

