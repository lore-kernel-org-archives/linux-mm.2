Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA40E606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ou4o6cs7
Received: by kanga.kvack.org (Postfix)
	id C35746B05B9; Mon, 23 Nov 2026 12:20:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D6C6B05BA; Mon, 23 Nov 2026 12:20:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B241C6B05BB; Mon, 23 Nov 2026 12:20:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBA56B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:20:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C961160804
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:20:42 +0000 (UTC)
X-FDA: 85467048324.17.616286B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4A3CB1C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:20:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ou4o6cs7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795454440;
	b=8rTv8vBMOj/xJiQYMnGFgy0GXrv+wuyF8wIXZz6FwrxErxBPpBL2vVdYOR8+lk75YudcZz
	sqW9kVSC37TFRNGVEoOcy+ZdDPDGbw5nVMpiOqHXKTRnM4hXkHWxTMHnNoI66TaAiqNEFe
	MdPOZhnROG6GK/oTm5xUtAg0OT1vI2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIMG3GuotDWafza35SJT3j9PzXDW+c0cLhrovo6/hu4=;
	b=8Bav1qGsYZzyIyF8aoHbATIK3ROh2DdOg6n94Jn98Do7EYogf54obGOIgNjzePRMgZ39gZ
	70Z+/cFGXng9bDQwVgyhuuGIA0EmPQ6/yv4aNPWcINtZDMhoJYquvSKBPmgKzAzx05tICs
	o57hVFbczIcfoVAxBEit9vaqOdEVpRo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ou4o6cs7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A9E443D69;
	Mon, 23 Nov 2026 17:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12201F000D2;
	Mon, 23 Nov 2026 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795454439;
	bh=cIMG3GuotDWafza35SJT3j9PzXDW+c0cLhrovo6/hu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ou4o6cs7SWT8jjNrRrYjJhEUt0jj/4mPU0LuSDBtgg3QQoEUyrthXCncjCJYqjSvv
	 CgOdMJM6dUIJWzEElfWSiW+dmbqti8sfrqORheD3Nn/+esjuBCmU/IESFQ66DcjIRj
	 P6Htxk55smefV1SBgrt3Yz4jea+CHM5ndo+U1wVDy3Gv3NuaYdlkUIJxFAOBqChKqk
	 mXGEEkoglH25k10nr0rFfAY5exXbT5xIpA4643WuWkriuGEIW6K9L/lLT2kUdlM6Iy
	 0L+/0jy3HpThuW8qHLW2ss68S39npAuZXI56L0o0tIoyH9E7VeGzpq/II5znXzhGtP
	 t/I1CpQxyiqhA==
Date: Mon, 23 Nov 2026 17:20:28 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/5] mm: don't PTE-batch a swap-in of a folio with a
 hardware-poisoned page
Message-ID: <awR1zpKGgJrZQQPx@gremlin>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
 <20261123163301.1568240-3-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123163301.1568240-3-usama.arif@linux.dev>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A3CB1C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1dfqdmgkxdwkcpu7crpapn4dnp9ukt3e
X-HE-Tag: 1795454440-21785
X-HE-Meta: U2FsdGVkX18XSp5trU1326lcZsIj4KT/da5+UstYlmKgpRjEnpk2df0/nKa/fVBP3UZPaR2ANl1QoYJdvY3E0FeHP1A8HRJV0R0kkIocWbsczpJlD62/B6ajEHXS2OrqZMp8AAb/p5gaZlx4isq+zBT3DbQbJhp9tHyaP6nth+s1ids7s736QxKbGEiV8CX+VOvzWQcLOWa0D9nGxvb5LIXaTbmTKRPE8CcR/X1UxhVGgmzn1lxGRuPTPrt3gzyiaO8Gc2bBaJYCmJqiiXcX2GNRZHB0AaiLYJ9//0y9XA6WRKdHhcvR9LwE3O+TkXtSOptojd4LAKiiukZ0SUeYTKwkl86eLx+JSdkPiu0FeWtffIxe2eEgV8UP9kQfJm6RtXBVjZCmh9MphDbD1X1LnCgoBv6Jram5oFNYOpgO0uiNQ/6Ws1orYgVxNpncGlFhldL8j1M3FSM+XXOqULKT1jr6sdp25Uk3l9bdM8IKhFJqaI52hzk4aqjuIA97VlVnDflTRYpOfValavYo0UVlkiykH4ZNbabwiAoIp0z1Rp97hA2vDWGyJzB9COKHD0bJJLfrQhWyMYfkmlw6xnGYqoLZvVTAiOs+3e0fTqau8irw+QebAByuICnyiPB0Hq77dL6AIvC5DvBMS4Adg40v38g0W7c80/uvQMv12vYM10RpEoa0znFGDbXBB5DPYSnBQ3Pf1YjSwdqAAjg+oYjtIJt/bSgEJpd+Moh8OLJKwJBWYND2bdx7vkxw1fOjX59H0SLcj3V/qus+SAtCwWOrl1Q7tWnYobDgFC3a7FIGTdm1fWYLJOkmfnAMdQJbNwTF3z5g7hpfv94CQhgI7VhwLd0PiRBqOpqSri1D4YsXdHuM1NuVbuHytbky9VABR1mXxfpP9cHJL65uNuByu9QvELti3+8UCa8dDZSK7t6lm78oHokcL1IoVLqq4BawknCVqCosYnB9ic14Dve9A4O
 lrgXmyi8
 WlplBQ6h5Q5vh82/h99hILdA+iR9675JO7vZeHztr8LbfoT+9V8QahWLupauhg8K2o1t9mZfmB3hqASYt+wmSII9vAToQSgZlmwpmZKurTUVtxGT3QC96CYFvqYJs3ZRsLwliygh2SBachZX2gCGP+9GyY0CNxD/aRFpNzElAco13Av+QNCSnXrDSHIVFBWPNLFrVZ0+ISei9jNX3D39QmyFjsdwULYXytJHUtwpCqhi9z5WXz+7a+tPnF2UVUfSxeDruuHgPwaDatejjKPksU0HCd+C4HfDR3OK7volrIsaYbxj/NHM7z8YctvoIhA7BpBQL5UepRzZM8Y+rd/GZo1gbGcbXN40s2cdKbmXINu8/Oe1evYXcn9bPRtjr/IRbUEAKz1opE3Pnj4wYnXnODbrSbyU/juvUmmvMbqwM9fDVDb3cM1HCsw6RMW5g3YL8C7xSsT5r+x3Nnmc7mbH7FuTAHK/usGL8wC1DRnEwBEcqW+ALrJppOqX463es+zntQBvr1MA9EQ+XRVXwMBeU3WSd5GXAe4Q0i+D2VQ63gPgyYswxXd5Msrd/2jiCInQmhgTsQTybm//cnRCrNHdtHak1bEm2Qrbw32VU7d4iQpVIsv8BDUq7y6YiFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 08:32:08AM -0800, Usama Arif wrote:
> do_swap_page() checks PageHWPoison() on the faulting page, but the
> large-folio batching path then maps the rest of the folio without
> looking at its other pages. A poisoned page that is not the one being
> faulted gets mapped anyway, and the fault that would have reported it
> never happens.
>
> Skip batching for such an anon folio and let each page take its own
> fault, where the existing check catches it. do_set_pmd() already backs
> off the same way.
>
> Leave a freshly read folio alone: it is not anon yet and can only be
> mapped as a whole, and falling back would free it with the poisoned
> page still in it, which the retried fault can then get back from the
> page allocator.
>
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Neat! I didn't even know about that function :)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 282266dd5e5dfa..d7b200e00bce17 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5194,6 +5194,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		pte_t *folio_ptep;
>  		pte_t folio_pte;
>
> +		/* A poisoned page in the folio must take its own fault. */
> +		if (folio_test_anon(folio) &&
> +		    folio_contain_hwpoisoned_page(folio))
> +			goto check_folio;
> +
>  		folio_pte_range(folio, vma, address, idx, &folio_start,
>  				&folio_end);
>  		if (unlikely((folio_end - folio_start) >> PAGE_SHIFT != nr))
> --
> 2.53.1-Meta
>

--
Cheers, Lorenzo

