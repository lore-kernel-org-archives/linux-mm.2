Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D3ED74965
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A736B0088; Fri, 19 Dec 2025 03:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2436B0089; Fri, 19 Dec 2025 03:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E986B008A; Fri, 19 Dec 2025 03:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31BE06B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:42:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA9C8602E0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:42:25 +0000 (UTC)
X-FDA: 84235579050.18.CB6F8AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 27D4A40002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:42:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skWdYr6L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766133744; a=rsa-sha256;
	cv=none;
	b=HKbO7OyXUTzNMOZzOH/gdp9JiN+SODdCHzksoJ51A8a9dQvqJDdszeciGP9nMq24/j6qOL
	qH9NRPXKDPOM4DMzCPHS/5IP1kDr6U1cTj6QCq3/xdD2e7DZtjimxtdlfBosrBaMxHypHw
	r+2qIaA3bWsGsKzw6FuQOSoURidvihc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skWdYr6L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766133744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hCT4wjyj5+fMkqcJpe94XokFEHMYSmNZI5ReOoz8Cs=;
	b=QCE172W4YJGcL576seeUn/crK0mrrhdPDMitxiqAa6s3EU4jbG14qKMBsINsB+1nXHDUM9
	3Ezu6Ic1HTF9iV9367qVQTjx2pEmg8bnRBPeU8wO2+GzJjAGgMdSdbri5Q/ScmZRkxB8Jc
	rqB+9fFpnlpyCKHy0eSnRYsvtabMrMc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 108504387D;
	Fri, 19 Dec 2025 08:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871A9C4CEF1;
	Fri, 19 Dec 2025 08:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766133742;
	bh=BWoymR/P1tEaCYbA+6x3wLoQnAtu2UPZdgax6L4PcC8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=skWdYr6LtTEra/hEJKSRki4oTiaVMYJJp1E1cQJDgFd5/TER6asBGVlGh3eeiSKc2
	 LNiq4vVCt345S4CoRaZjVlB+/k+vylJTmUTyL8dTk66CamK4lqZBOagGdhILd86n6W
	 3Vr4Y2HufoSSg77k8mIwUROQI8C7Z0/QnAOyLqyg01hDYQ+DOTgDfT8TBEuQqV15Nd
	 Ny5047KxgiXOX6dzRlOT+OZoLj8pofxB7WoYvn92uOhMmWcZQsh65VWq1MT/Tsxj6Y
	 3iaW699Mxu9iYVBdi7G6lmezEOJ5YNQ2t/ev1BprX1hS/LlY04KJV3XLVvDIIY5pDd
	 J9CweEgDtf4ow==
Message-ID: <4c2027d3-2665-42e0-8cfa-712b1d8f8870@kernel.org>
Date: Fri, 19 Dec 2025 09:42:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: bail out do_swap_page() when no PTE table exist
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, hanchuanhua@oppo.com, v-songbaohua@oppo.com
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
 <20251216075943.29593-2-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216075943.29593-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27D4A40002
X-Stat-Signature: 6fiust61qwawdixb3wzjinig8bnw5kgr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766133743-958541
X-HE-Meta: U2FsdGVkX18Kl80CNf/rBgDimqq/I7DDxvZknXFX1nzSabFfUts4Eby4b+8kZ7g48uW2E3htnEzpK3JqaB7gFoizfwaefRGjspc+6jd32VFN86q8z7hvKmaEUlnXdv0VNZmjypf49giCiaaCV/IjSh9STC1Kd1TeAHb8dwAjI39YynqFOdbYdri3W7uBtucUzADBfSRTTaOGriLpuEuvtWUlSgA1PRFvAjLiMFPx/8I4hO4Gk+YQ0Djmx9P+v03QLRtYeMNu6p8DgNV189gRC7xhRHi7QdMVtYUTswTnSuuDp84sKn6vm3/2y4LBiTlIR515k6JRueCTKfXmMYP2feqVGPV/Mr8TTm5rJnHHjQEKukQt1CwuqWKCPVcNeq+h/hIAITK9SI4eJ2ccsUk4dxplMQcpPv3cavUsJWbBU/JTo/+Jv+8MHae6QwzKCxC9qUedisCS9qP9qCNFd+/8RtZ6QWE8qUb+VpxGcXgNnmAjE1LBXaFBsyJSdUtmQbpnNzzeVb3jeZ+WoMAJWeFJNy+Ms9eL4fPMichJbcy61FjO0i4YQ5NmyPyCya8CzMWO/SyXVjVTy+4RRJ2zT8bsjmoDTH0qSSzwnUhliYYPBCc8IKl5MYyqo2oGvqCchmlyFvqrvfVRyb+5ytSUpivUZ6xz78Te9jkBjkOpyxqv7+nDs1K9GuI7hD8TNn/XjGWr1G+Iae0WDGy5IErSTA9cCe1ZoHDDZo4bYwUmrvZxpHPw++qE222plfyuiRFg3IpMdumpbxF0VJ1bODOgN/h0RmmJ1EI7aqoNLRnHeSJ2Y8umQl40ugm5psBgUHzGPZ0NZ8GI6vYGm4fQ2KKLx7p8ox2+xzoTPhEEV0ujgPNguPhWz0WnU58zp/pTvsqYLzg0X3+uGysjOyB3HS6ikUL5ScuycyJnlDRGcvYfTS/1xWZYro+AoxPBAmJfPH3WXlN2ZxaXza2iAOrp3usM9KF
 75mdUoxd
 pbxaWw8dz1IeQWsUc3GXA5OkuNDOE16P8wD7VmDQawj1LWPEuivMbYn9Yi3o6Dqmk1n0aI/H/LWQB57P2XVx7AEjzm/JE8NVGs9ZKez1YfjoKpQoNsTe41QreGKJOFwY4ZE8LpXItkLEjh07wtgWwl97x1z93btq90c+i1dyw0MKB1y6kzJx5dfmVpVofWawRAZ6hFcwAdRbJG22ev+QnHl/97dQyjLVECxeUDFBMp4iiW9FAYb7r5xvkCunR1TxzAXOqalEAs2OmBlAtSBi1jxkYaCg6ZB3J1gcWBOIT3HMVcVNyAl5HIOyzUELqHrjpWlYbaC8xBTggVWmr2sn21TzmK+vaF+gBw5oaV8LKhRYov1IYmSLRrM0S2z2Whose0j6FTHd4gX49azlDKqTu5PxRsV/Kw1qNTHn4Luvn+PJ2I/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 08:59, Wei Yang wrote:
> The alloc_swap_folio() function scans the PTE table to determine the
> potential size (order) of the folio content to be swapped in.
> 
> Currently, if the call to pte_offset_map_lock() returns NULL, it
> indicates that no PTE table exists for that range. Despite this, the
> code proceeds to allocate an order-0 folio and continues the swap-in
> process. This is unnecessary if the required table is absent.
> 
> This commit modifies the logic to immediately bail out of the swap-in
> process when the PTE table is missing (i.e., pte_offset_map_lock()
> returns NULL). This ensures we do not attempt to continue swapping when
> the page table structure is incomplete or changed, preventing
> unnecessary work.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Chuanhua Han <hanchuanhua@oppo.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> ---
>   mm/memory.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2a55edc48a65..1b8ef4f0ea60 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4566,7 +4566,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>   	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>   				  vmf->address & PMD_MASK, &ptl);
>   	if (unlikely(!pte))
> -		goto fallback;
> +		return ERR_PTR(-EAGAIN);
>   
>   	/*
>   	 * For do_swap_page, find the highest order where the aligned range is
> @@ -4709,6 +4709,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>   		    __swap_count(entry) == 1) {
>   			/* skip swapcache */
>   			folio = alloc_swap_folio(vmf);
> +			if (IS_ERR(folio))
> +				goto out;
>   			if (folio) {
>   				__folio_set_locked(folio);
>   				__folio_set_swapbacked(folio);

How would we be able to even trigger this?

Trigger a swap fault with concurrent MADV_DONTNEED and concurrent page 
table reclaim.

Is that really something we should be worrying about?

-- 
Cheers

David

