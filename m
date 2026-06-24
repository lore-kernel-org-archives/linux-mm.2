Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C736BCDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C0E6B00B8; Wed, 24 Jun 2026 10:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC3C6B00BA; Wed, 24 Jun 2026 10:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A971D6B00BB; Wed, 24 Jun 2026 10:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF6E6B00B8
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:59:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01414C17DE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:59:05 +0000 (UTC)
X-FDA: 84915113892.08.3ABE9D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20F2A180006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:59:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or1meLht;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313144;
	b=gLS2qF7FC2NRs/1vy1fUzn4Yl+lL041L7jP2DJ/HDKCcKFog6y4WvN9DNtLJjwFY5dbNZt
	BAq73lP/JR4bN946ksFXG2mpvKJJCMLexAWuYMyNKXab7p7wuqnsQuyc5nkLbwKZM8uyJK
	FmixsBT7EHe8orsvIK7+s9f0xp5ZN1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7Zra2DC/SjAzfu14QInVXQE1b9FL7wyAOkZas/Tzpo=;
	b=gDnOgA/S41LsVS6BybPEzqrd1Us+FMMSc6EucP9Sbb/+7i4Hm6QfN4GSyIczf4RXcxO9ZX
	XyoDWPQr/O043wk63hNwk9fD1d+h+QPbgZI47j7Z5RXQFw1ZTQ2rnlrtouvdyVPBHriz+s
	W4UwjhrvVNkyNBEX9SixbHITse0KQNQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or1meLht;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5332243921;
	Wed, 24 Jun 2026 14:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13511F000E9;
	Wed, 24 Jun 2026 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313143;
	bh=A7Zra2DC/SjAzfu14QInVXQE1b9FL7wyAOkZas/Tzpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=or1meLhtDcCuNkUq36sAapMVjJdTDs4HJxfOQqEFdBpVvFlCHH+AomXPIXsmCnK2z
	 pq0ey6DIp/5q23UtD4xXezg382Y++9bRkl0BLB0vP3YR6nOe1lbdLh6SXfs3kGdmPY
	 cJC5ttYdxg9sNHh+nXfTYoLLl+LNb6hjl15GWrIoWRGY+o3BupGa1gPujhMEYb9DZN
	 vkKVCiGzsYMBlqcy93yS5/n3s9fcHDrfJB6GLEk2iqFy3LHLRA3IcOgPyVsxMRX7sI
	 803nztF9X1IxroKsWrcUUMTPMUfiakrjph90GS8vN+h9WtbSQV6CeAqIi+ScZbMzQM
	 CqHGVYzWmsSvg==
Message-ID: <3523f142-778c-4efd-9675-3c68b33e7e3d@kernel.org>
Date: Wed, 24 Jun 2026 16:58:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com
Cc: chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, chrisl@kernel.org, baohua@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624075700.751467-1-alex@ghiti.fr>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260624075700.751467-1-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20F2A180006
X-Stat-Signature: exn7dutdah7ffewxdeax98a6rqbgyda9
X-HE-Tag: 1782313143-283726
X-HE-Meta: U2FsdGVkX1+cG1c1He+whNL6EBcc2koIHyzFWgmI5se6OjVtdJhlhBdW36NrMDRxo5sKpweLgXkLBd98qq98tWaPtFWTSPBZtbH6F9vzL/h9R+coKJREvIdklR26PJ71RgW/duij/PLcm50RJZnQcsGehnjkkJjNmciJowV4rGgPCwt0lKTHdoIPd7F+db3aEHAaBHYBWT3lgXhf7K5SxdgqRXhemlImF/D3VsTqGEPFxYIMBQ59KPgJ7XzH2qV2590FhBealmmBjIDJ4ZBnhjzsDs3Noje2n0Q7IebhpUTeEt3Ga1x7gHZDVe0bl9LgoG5T45AnO2ZHJdJKikdpemWS6MsLLv0LqXYarSDbCzMwZk2TQTIhSu/Rs01oBopf8q0gqd2aW+a7DQbyuf7ILOn9fOUNFpJMn/VYNCcUwZ08MfAYyEaPAraAtyLBDgOwXEjQ6n5weXgORwaI3L20QeoUZnJVxHgBP1iqSM6lo3STB8SJDhuYv7PSrPf9CpUDG2n4eHpur0xIO0kCPF9cxAQFkr7oqisg1L9mAe34LNp1cKU4kysfR9dZK0w2ww3Ln2RTImQ32q/7swuCyow8x8y0Lry0v50kvzlTY0QqhLJtfyXYcFgf0XkDjDZTzfDsXzXzwhm+Nirs6D2CzehIT//RjjXLvFvb2Gz7FCnNrvsB754qg3ws4d1WmSSrFRSHGgZwijL5ek+xIbQVFn9tCHxjrOzr697dtqcIRVmb26PCzCUtixft8mgWqaGmDXvz+6VDxFhQwMAhHosATHJ31E1raQmEhQ9zs2Gov56jVf7uZ/bOzqULOqf3BFLhoaGdAD1g4Nsbl8jQBjzuK3xXFK58MtZBTdifEGcN9QdyTj3Y6bihEdAJUBL4zVfN9BOnEPn9cq5niRz49RuR0UGm0t7TsObk0cU7kBofgK50ZxsszQnr8zxmgiQEELeIUhcAYEHd+pk6/0Fo9KbLCC3
 N8An7j5p
 mhN1XWKtkvoNDivKhr8UbQpNZk0xHXT6JwZ6wKkr++nVw8Hrr0Egw8FkgKFUdqFMYC9Yg6oLgbA3TvX2ZsqlgHV4QhRWo866Knq2pgv/oyXGQPfIXym3/qfRPFkzqPCkYXqh0yQw6bMFyQA+M/NBpGdCPGFd7ZoQnW+CM83zQGrNSxDXZ9W01lLMYldh1kfRZgVQGwC3/n1N24WjFU3rZWHKZD7bwNlqkko/FGtQgy+R1aNVktg12ceM/quAcHn1Pa/F7oYYB/INyqxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 09:55, Alexandre Ghiti wrote:
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
> 
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
> 
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
> off, on Sapphire Rapids and 3 iterations.
> 
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
> 
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
> 
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
> 
> Bypassing swap readahead for zswap therefore makes sense.
> 
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---

[...]

>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..5aa1ea9eb48a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	if (folio)
>  		swap_update_readahead(folio, vma, vmf->address);
>  	if (!folio) {
> -		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
> -		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
> +		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
> +		    zswap_present_test(entry))

This should really be abstracted into a reasonably-named helper that can live in
swap code.

-- 
Cheers,

David

