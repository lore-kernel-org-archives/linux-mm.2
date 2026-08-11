Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6C6C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59A56B007B; Tue, 11 Aug 2026 07:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30816B008A; Tue, 11 Aug 2026 07:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B474F6B008C; Tue, 11 Aug 2026 07:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4666B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:46:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24CBEA03EC
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:46:10 +0000 (UTC)
X-FDA: 85088810100.05.BB651A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93AE7C0009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:46:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0LQyHrX;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786448768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPWu49UAIquK0mooC3SczFQJQjb35cm1cGYD8ZnZLE4=;
	b=JuH/Ob9WmZl7rrl7BzoxLD5pmnbfZxB510kBpK7NG7N2sQayBG0a8yAB5wgr29HipQB5is
	h6+9Zxs+d/nrugM0aC+93AIWACwYdayVpaNDPsnY9WzB2pel6lqODNDRIJYEdckwH23d6J
	2DPXZl5dAoeOVO95WtfEKH4lT6H+v6c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0LQyHrX;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786448768;
	b=73Ak5kmLxj6v55X7ZhWYnt76Ds32rNfXjJLOES5lwxeJOSjpwQizM0u2FTbFz2KPoWrhei
	WI5FXa+4RcjJnl+RNzqhdLK3hzsyiwUdsJbPrRTuIVBPgCZVmMZwjhN0AHkBrqePocqVX5
	MxWfXdDENrSgFo9hbZFsMAhIapbOCws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C75D600AF;
	Tue, 11 Aug 2026 11:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2181F000E9;
	Tue, 11 Aug 2026 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786448767;
	bh=DPWu49UAIquK0mooC3SczFQJQjb35cm1cGYD8ZnZLE4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O0LQyHrX7jsyiG7KPdckuEvwsfNlhx8xvShxfdUKVqKOcPbsU9FWpM/0A6krX+tqb
	 LfECnN8Wssqbv5zYLvv72Pz/NuosWDlm/dvO1kT5i6FhI1746RG7E4r4yLunDR33FR
	 OTUNLVptVP3N0JQyGR509ecmhh8wKLI1yFpaZwKsTDDyUrsj8SVpiJeSK6kePHFucu
	 PmmAVOysWwyLgp4JtWpPv1lSrKDVsiTLHAF+tywocuQ1BndcjSFlQ4PRQ5k/FusNOS
	 93gezADSJsjA5xDIUF6uw1QZy3fiI2LjKDZP6xDpg1eBaZ84dTMntOZLYGpVPZ6Uhr
	 PorPSesmrdlMQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  graf@amazon.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kexec@lists.infradead.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 2/2] kho: unwind restored pages on
 kho_restore_vmalloc error
In-Reply-To: <20260807075128.542806-3-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Fri, 7 Aug 2026 15:51:28 +0800")
References: <20260807075128.542806-1-duanchenghao@kylinos.cn>
	<20260807075128.542806-3-duanchenghao@kylinos.cn>
Date: Tue, 11 Aug 2026 13:46:04 +0200
Message-ID: <2vxzcxvo518j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93AE7C0009
X-Stat-Signature: 11871bithyd8o8mknycpskkyeg94cpai
X-HE-Tag: 1786448768-286925
X-HE-Meta: U2FsdGVkX19TfF6eOaxTccCqcg/G6NiXUNfvti/Oc7QWdBxO3cque/wm6+pI8m1jccbhcjzsxUKK03tEZHEIIRxk3y95VZBPBYU9RwP0lohtNcYSZI3aPRs3nYOaOv1tXIhTCxeDqP5Mch7CUgMyCcvBXeCuIrBk02p8oy8ktxXuavofTmEnY2LXQgZG60fA3sg/a+Bv/hoC4yRtz7YhFWc8zAJQCpchHC4LgeeFqaK0bXm+9OpjiZtsqZDwj8Q/SH0hQRTM1HgNQSvHb12ZoWqZvweQdGkhW95zxqN0GYMKFoX0OuA92Dq64uO28ot0AcbMsypXtIFQbHGUDuBH15s9kYH5t9BZjrGz6neLwxOZ8EDhQ6v06D8CdNsNhhubjdfXXDgo1pJ0u5UF50dv4vgcftPRQFCTL6YZxLOfhuN9vyqI/t1h01XDd5AwYpHlWNtWdm/rATsNYN0bdk+rlsKEIM5MTfvV8WqWx1SCwIMsj/uQpYI4Z0SS3/zqCJZYBbgjoBgEIA7D9fGSMobH6aqlcrKwmLgzi2QZRs96laduEtAQF79Q+Z+wiCavLB4N8KaGGpgwsENQu+Tsur0hIACHfk7wTKTn/XCz771E6KvMcjofv+J2iNLBFdkTwG1xQMsSOs/GsXDYu4OoZ3ng6rdE5r/E03M4wbetf4OSEeFQPDs3vpWr1aT/jHFsYU0YKvIZe90/68QdiS68PocEVankcp08gU7Tuy17nng8haLEeyhmtNjtU2cibWAH0s/YZgRZ77Jsqzh0Lv8BS/Wy0NHaUbHLL/2/exZwzigWOIbuOwgJFQ1w0xHowWU5d9XJR2D+m/pml7tYvYVHdxpzeLdmdX98aLMScGERWh3IonFz48b2Lj3uk7TP/YmZUTosR2CjOQZo3VhprHBqv85/81+eDtrap7baR0Pqv01oo7xjgw1y3R+ja8GYEF2jil5kVPvKbpXcEks/oe7JB9a
 WDr0paNK
 fWzS6cC06eygus5CmFRF96QvCe5ls1hyXhGZNO7eOWOldpjF7h67OaS8SiyKsKhmvQZM284FgsPoaI+35tn97UNjXofsHEOai/I4xMPyuT0qUpPAaEn8V/Kxe2rg96uf3LAcRoXueu9CU3gTAbuNB7b8iA6Yo/klOpuXwVTljGtRR5g9wWrDt8w1L30n7w3k3xYri1ZTcj/N7jN7eebyPbXOX5JeTPTQb7f0Bjkyvv5FMFeiHnrt/orUWnAzQ54CzgGQXFNrNz86ASkI+wxBnNCQ0bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07 2026, Chenghao Duan wrote:

> In kho_restore_vmalloc(), when kho_restore_pages() succeeds, the
> recovered pages are handed to the buddy allocator (via
> adjust_managed_page_count()). If any later step (e.g.
> __get_vm_area_node() or vmap_pages_range()) fails, the original error
> path only called kvfree(pages), leaking those folio pages.
>
> Fix by tracking how many folio groups have been restored with
> restored_idx. On any failure, use err_unwind_restored to walk
> restored_idx backwards and return each folio group to the buddy via
> __free_pages() before freeing the pages array.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  kernel/liveupdate/kexec_handover.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index ba03ff5baa9e..ed35405f59ab 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1161,6 +1161,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  	struct vm_struct *area;
>  	struct page **pages;
>  	unsigned int idx = 0;
> +	unsigned int restored_idx = 0;
>  	int err;
>  
>  	vm_flags = kho_flags_to_vmalloc(preservation->flags);
> @@ -1183,11 +1184,11 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  			phys_addr_t phys = chunk->phys[i];
>  
>  			if (idx + contig_pages > total_pages)
> -				goto err_free_pages_array;
> +				goto err_unwind_restored;
>  
>  			page = kho_restore_pages(phys, contig_pages);
>  			if (!page)
> -				goto err_free_pages_array;
> +				goto err_unwind_restored;
>  
>  			for (int j = 0; j < contig_pages; j++)
>  				pages[idx++] = page + j;
> @@ -1195,13 +1196,14 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  
>  		page = kho_restore_pages(virt_to_phys(chunk), 1);
>  		if (!page)
> -			goto err_free_pages_array;
> +			goto err_unwind_restored;
> +		restored_idx = idx;
>  		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
>  		__free_page(page);
>  	}
>  
>  	if (idx != total_pages)
> -		goto err_free_pages_array;
> +		goto err_unwind_restored;
>  
>  	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
>  				  vm_flags | VM_UNINITIALIZED,
> @@ -1209,7 +1211,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  				  NUMA_NO_NODE, GFP_KERNEL,
>  				  __builtin_return_address(0));
>  	if (!area)
> -		goto err_free_pages_array;
> +		goto err_unwind_restored;
>  
>  	addr = (unsigned long)area->addr;
>  	size = get_vm_area_size(area);
> @@ -1231,7 +1233,16 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  
>  err_free_vm_area:
>  	free_vm_area(area);
> -err_free_pages_array:
> +err_unwind_restored:
> +	/*
> +	 * Pages already restored via kho_restore_pages() have been given to
> +	 * the buddy allocator (via adjust_managed_page_count()). Return them
> +	 * to the buddy so that failure leaves the system in a clean state.
> +	 */
> +	while (restored_idx > 0) {
> +		restored_idx -= contig_pages;
> +		__free_pages(pages[restored_idx], order);
> +	}

This looks wrong. These are 0-order pages. You can't free them at order.

I sent a patch to do exactly this a while ago [0]. At the time it was
rejected with the below argument.

    Hm, I am not sure if KHO should be responsible for freeing the
    restored pages. We don't know the content of those pages, and what
    they are used for. They could be used by a hypervisor or a device.
    Therefore, it may be better to keep them leaked, and let the caller
    decide what to do next: i.e., boot into a maintenance mode, crash the
    kernel, or allow the leak until the next reboot.

Although thinking about this again, why would any device or hypervisor
use vmalloc buffers? They should only be used for metadata. So perhaps
we take another look at my patch? Pasha, what do you think?

[0] https://lore.kernel.org/all/20251118181811.47336-1-pratyush@kernel.org/

>  	kvfree(pages);
>  	return NULL;
>  }

-- 
Regards,
Pratyush Yadav

