Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E5D3C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CDF76B0088; Wed, 16 Sep 2026 02:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378B66B008C; Wed, 16 Sep 2026 02:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267916B0092; Wed, 16 Sep 2026 02:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0686E6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:33:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C2F91605CA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:33:53 +0000 (UTC)
X-FDA: 85218659946.12.F3A953F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D4A051C0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:33:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QlrS4v6/";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789540431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OPREws8MXPltghU8R5rvn0z5vmy47E4maC36zCSjimk=;
	b=wD2grswEPpneh2TNxOixEfyFbkLfb9fDjRAFH2rQBVv5I21A//DwJeofja4iu4lOPzO3R0
	Mk/lf2vx0030f+sMgNayMrHzwA1yU1mYB9HY8HRWADurY1iiGs1Ke+8dSQ4VJAGyqyMqYn
	MnaE+d+qh1XtlfxKixI+XhK1zMrEQOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789540431;
	b=Wn2nmwselfAFZcfh4nbuJOZavkI3WnM11xtDL+Yh8ls0+jKNhCwe+mrVO3aTPL/nKEZhL7
	sEvLCBE3Njszhnl8mdt142pSY88aJt1Q1zwojYKE5pNHy92AwXO5PSjRRZLVl24SIVCx+g
	EJ1eV4c6mDp1e+IZ1CHhZF/qV4nrrK0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QlrS4v6/";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6762060008;
	Wed, 16 Sep 2026 06:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0D81F000FF;
	Wed, 16 Sep 2026 06:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789540431;
	bh=OPREws8MXPltghU8R5rvn0z5vmy47E4maC36zCSjimk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QlrS4v6/BNtJvq/01glTCj2gMMusPuT6T7E7M8qV7tOGdVgvxUPc8sOtCoGkoPVa/
	 OAuzVtlXMKEsdbT4IhJPlN5d6WRElGF+nM9Zebwe+y+TLB/k5UVLsT+NLveeZujjX6
	 gbmBvkWeCwHsH199vGFqvmkQpirTKfhvvJ2EaGZrPdb3jgGV2XZPzW4eSS8hz/wLd6
	 VpUsfw7+r2fyrvj7IDi6uTHogDLlLxi6JKtIvs+duM9TRhUcNzbxQqWYch73kMBZqj
	 Sfyfd73RkKIfC18ssYs97S3JUyX8gvmwREHg5GKGpbtKm6nrqQvKaChNw1J0oadXdd
	 sFKI2qoWLNqag==
Message-ID: <9da6298e-485a-41af-a42f-7dd05c571125@kernel.org>
Date: Wed, 16 Sep 2026 08:33:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3] mm: mincore: use per-vma lock during page table
 walk
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>
References: <20260916043153.2631696-1-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916043153.2631696-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D4A051C0004
X-Stat-Signature: jytn9mtww4rqw6d4j39zig73kjabpndz
X-Rspam-User: 
X-HE-Tag: 1789540431-380022
X-HE-Meta: U2FsdGVkX18NTS5RErJrufp7Lsw/UIxQUAOvWGbo8YyNWkoufF3B6jX80x3tn7SCAYSmfPejZlJQfFmg8emZqc3e7H63FPgOQ+6HRd69or/3KT4XYTyOLY6GVnY1cQEgcUd0ktsjzK7aJEewmEZ1e8gCllkWNM8aa4D5T/vRLmji7nUE0J5vAg6zQ4vlPchKqTtgyiJWX6PQ7eIwaCvAk38phakFo0EEMRzX6aC50WGuHR9P91Qu2ACHeBcMWzxmKMACutF1nMGgPHSiTXNgKXIkvffzf/OJe9NduLMAWuw5txnXYB9fGuRD+q7j2/ZlU3NihxiiXvMHHOdpwpKS1yZzyFh5Ln0vITQJHOfiQJiY/beqpfrXbPlUPQTc7BmBhyOcgXLDWqE9ZNWFyLIQrYQRiKvu61E7iA4v18VrfIAh5ognjcyWQzeDdok49/BdtIvptd2W/Y646noOzNWHEpSlgYJ1sejrTGOB3W7VB5mbQ2fTML8K2KGlVaeQKsQjDhyIdtHP/TY1AEn60XDIV827i47YfpnPEVEi+OWuNJBHGyIAVajWKlWugQzFEO2vg4n7OyxYrEQ+tM++Cv2wZjxcQFE4GeDhcOau25gozhIhP3vTvhH42iOqvnpuUtnH+VjsxzTNMF2A4x46afnkITCxOn5ldQNVR2co70W5I5NCvvP/9m7I82KhLTLD5ebTOCh5PX5236dAoM5enPswuATrI9NyZ/fm7ulC/3G3cI+gdUPb9w4l2O9oelMhi2WMjXZmW2qYPBJp/PLZ8JRvgb/rUrUwB/sKdrQZDMzzZdL5nY3jwHrJ4stz1kWvsdYyf2aEUg7EiEQdoNNWzbB8YYir10xRFWjDCyPBq61ofmYhUoIGZZ4FxSvKyEknq3XrXR9mwtAUDgs00ysIpUxJ6Ujo7LVp0tR1Dz6zV0Lma7123volWXWWxzIiouVl452k7x/TqotFut22wQzDJuj
 Lv+GDytL
 LOh0cJ745UEeZvfAdyHalKS4amdgrZRoas5VFwJpfShYrae9eS4RTZAT2hBH/JYeNGqNgwENubYdK7EzW8IlHx/rMSgvsJ6cB1gbDKN15ogu7Vz3YBAqPcQ0VJsiEfCm2RJ96WgKMl6s7BbRNDE6sJQwLrhnB6kd/iIMVtKyYpRXHT1TpHmIX8UipanbeCehlOBvmbKyoNsgUaNMwaxmJsA9kSBM8o5+nNBVuIaKABrKeL2fX94VPBifqS6Hx2+q7dBleoVJeTEDVZxImP6ZHtZZuiTCPIGuq+wCsIG2uQOQmyxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 06:31, Kefeng Wang wrote:
> do_mincore() performs a read-only, per-VMA residency query,
> making it a good candidate for per-VMA locking. Convert it
> to acquire the per-VMA lock, thereby reducing contention on
> the per-MM mmap_lock.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
> v3:
> - add vma_assert_locked, update changelog/comment, per David

It likely was Lorenzo :)

> - Add RB 
> v2, (RESEND):
> - using new vma_start_read_unlocked() API, suggestted by Pedro Falcato
> v1:
> - https://lore.kernel.org/linux-mm/20260701144047.3786939-2-wangkefeng.wang@huawei.com/
> 
>  mm/mincore.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index c086836bc4bc..0fe50f8a7e62 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -235,24 +235,22 @@ static const struct mm_walk_ops mincore_walk_ops = {
>  	.pmd_entry		= mincore_pte_range,
>  	.pte_hole		= mincore_unmapped_range,
>  	.hugetlb_entry		= mincore_hugetlb,
> -	.walk_lock		= PGWALK_RDLOCK,
> +	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
>  };
>  
>  /*
>   * Do a chunk of "sys_mincore()". We've already checked
> - * all the arguments, we hold the mmap semaphore: we should
> + * all the arguments, we hold the VMA read lock: we should
>   * just return the amount of info we're asked for.
>   */
> -static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
> +static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long pages, unsigned char *vec)
>  {
> -	struct vm_area_struct *vma;
> -	unsigned long end;
> +	unsigned long end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>  	int err;
>  
> -	vma = vma_lookup(current->mm, addr);
> -	if (!vma)
> -		return -ENOMEM;
> -	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
> +	vma_assert_locked(vma);

I think Lorenzo asked whether we should do that. But the walk_page_vma() further
below would already verify that due to PGWALK_VMA_RDLOCK_VERIFY (see
process_vma_walk_lock) so not sure if that's really required here.

AFAIKS, everything we do in mincore_pte_range() should be compatible with the
VMA lock, including the swap and pagecache handling.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

