Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A550C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2144F6B00A9; Wed,  1 Jul 2026 12:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5086B00AC; Wed,  1 Jul 2026 12:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5206B00AD; Wed,  1 Jul 2026 12:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C69126B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:56:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 509F612044E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:56:42 +0000 (UTC)
X-FDA: 84940811844.26.5BF867C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 79E9240008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:56:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IFHkk/gg";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782925000;
	b=IONrpnu1XC2zsAUmTzW86xXTJr9N3aNTlSkw2f5Er25bXfUh5AvEaf3i6Mn+gnwOZJAhQi
	xTNAcCts3w0mV11M8i/UcJAwRxRcVpFxImX/VfgoIcfGajmNAyOTN08nf5aSSclFWb6M9f
	em+0FBpZ3JhVavn7Ek+2H9U9DCgZAnU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782925000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVimfh9ma7IjwVtqLkOayOmSpFAJVVDO3q0L4tXhqoM=;
	b=V8wW6KENkHbTGR+3FsYcxrQrLH3Sg55jxDUfscj5gJqeC0Nh3iJv5QW8bTFoa+vygqMX2M
	p+nV+CL8gDJQKdqRjIg2Y1pelvJfQnH6X6s8sVdF11TwTA5geIK6O/WOkPnbJ0bm0vvy36
	oJUh1+MnfggGy7vPZcnSNKgPw7nJjzU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IFHkk/gg";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10E5B6001D;
	Wed,  1 Jul 2026 16:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C35C1F00A3A;
	Wed,  1 Jul 2026 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782924999;
	bh=MVimfh9ma7IjwVtqLkOayOmSpFAJVVDO3q0L4tXhqoM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IFHkk/gg0byfxsIlJha3EeHE2/TMP5GhSKfD/MiamrsSzQ4Kpv+OOt8w8xrZHwcz2
	 pLdArcQApNo3cvWjUKx8pGssj1CyNh/CMGUEcnNMbwa65VO68/zORS/6Beowdh+1rB
	 YQdsmiqttXa366xAn3U71SIbVYQK7kuNEMf9udviiK4kF4h/Xzt3MxyIGr2gpMut8T
	 CH2Ngkh3n4IPv+9rcxp+9gLQNV66OTYOQFCLEWLqaezl2+8LiHws2fwJqGgoQb2HIz
	 7Svp43Vg+LK67WbJOywLeMxf41vszHXh7+WWoSrYjsCdDogUwP8Uu26C7hMqdsrPRw
	 BlvCqIjBEIi8g==
Message-ID: <157838aa-1518-46b5-8734-feab2c42ee2a@kernel.org>
Date: Wed, 1 Jul 2026 18:56:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: extract mm_prepare_for_swap_entries() helper
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630164143.1595669-3-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630164143.1595669-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79E9240008
X-Stat-Signature: 7w9fax17g7o81qjqreajkamoscdstcy6
X-HE-Tag: 1782925000-791039
X-HE-Meta: U2FsdGVkX18h19neZFH0ZFdOhoTKOaBx4lzitastBd6DDa2Hxq3cqaCbBff+uLZzTkybsIfvHYH2gxr+YJLCjChnhRylYCiNiDYP+lGrTl3OCm2HhjA6pdN3pR+hT7tag3kxu9DIdlgZrGXQ0c8HsVx2Y0ele/oPah/4v9MWMIs2BAcheNRLtxEdGL8e84kim0AzIbNZn1//lMeoJusoJDmPHYceaLftH9vSUdc2sqtn11ZTDHWErLgxX3dW0OgCXDi9Ro1Ekw897XQ2Jdha8v41+0hAdjFu2BqysTeMjjyr+nUHb52fTNRlxPv28lNE+32yuuXg+OqAMZhn1M+6yL1tdeD7bQePliyBjtm2/wH1y/Nt+QxgcTmxazsKD+1dISBmfNceuGFYgSJYaECRiyBx85QGrqXPD8yqxA8ceRKX9StHFEGvZhMXHAC3uQ1EL2OgjmQoK6G0GT0cCLi92dtsj2XoiEq/9OLC6vs0dRMgBPeI1AORUtRi8J76V74lELEgKQzfTCvZMIOJhUNMp8HBIXG1parn/OXtDylWr/9dgRH9rJMXJuDUg5xXw4B16C4wfYtcKtpxCiCE3oOqeNEel15R9+7ov5ruN0p9o25U8sVyx1HULN8pZ76oLWAUFDRi1FL2BJGra0WIXnlhQhzZHkpofGkNii8QYUIuufpoFpGhwMRcISXRa6k40yAkPFRqGy8rlxLvZUmKj6Gbf+bcAYrGAhRxWCSu4PBPlPj1UDTPqcJPDi2NnmR2vbhrm1rA66yOKvYcVhAExoshU76/56fYbD5MnHT31hljfd3rsttxhfDUDM5SckqIn0tIxJNeRwzFV9V5jJltiIw3yte+Cn4pYh5WmRJz/6nZFd8YcO9hdC32msBuomLM0gmWzm1xqQqOrIN7fQ7lfMuTKFnsEjh3epXJMR3UN2Yw/HsjvrsdfFTZuqNHHLEcJKb7nYLH8GAJCR10B1reuEv
 WtdQcLsu
 dLv9VhLQ9sygVDV5YhW4YjF7qgTSvyqS+4fhQz5hyRwV2Q3z2CGtriQEVFDCs1cMRKlJK5HR+Zs0ezblCvxKJYwdoYjZIhShWrtfcrbkQWq+aOfhH+g2LGGUY5GN5fMTTbmlC6Q17qawYvQGoSglPGE1rfHnBnzy4pY/vm13Gq9I698C86m59hAVLIY8kOOr+f2siLMhTlrNiF2cRcru2FvxSoaCvE2iqasmrYvrSV6hqjXlvx1Eq4dR1kR37lAbuZpTwjKwLW3F8Xw+VUw8QH7nxsicx0XZdeWTQPzPxrQeCh4tybyUoqr4B9q/X+x+OkzGhWuuKMcXip4biIGE8PTaeXgP1u403ENio8+6RWO9jU2t0vOsGi/sPwm1dLA7E8msWMOEdUQZ0v520+HJUKeUBWydOD0G0DV+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 18:34, Usama Arif wrote:
> When a swap entry is installed in a page table, the mm must be added
> to init_mm.mmlist so that swapoff can find and unuse its swap entries.
> This double-checked locking pattern is currently open-coded in
> try_to_unmap_one() and copy_nonpresent_pte().
> 
> Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
> both callers so it can be reused by upcoming PMD-level swap entry code
> paths that also need to register the mm with swapoff.
> 
> copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather
> than &init_mm.mmlist, but the insertion point is irrelevant, mmlist
> is a circular list and swapoff walks it entirely from init_mm.mmlist,
> so only membership matters, not position.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/internal.h | 13 +++++++++++++
>  mm/memory.c   |  9 +--------
>  mm/rmap.c     |  7 +------
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 8e0df3d1c6f9..0e3db9451e5c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1956,4 +1956,17 @@ static inline int get_sysctl_max_map_count(void)
>  bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
>  		   unsigned long npages);
>  
> +/*
> + * Ensure @mm is on the init_mm.mmlist so swapoff can find it.
> + */

Comment fits into a single line and I don't think we need it (function name is
self-explaining enough).

> +static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
> +{
> +	if (list_empty(&mm->mmlist)) {
> +		spin_lock(&mmlist_lock);
> +		if (list_empty(&mm->mmlist))
> +			list_add(&mm->mmlist, &init_mm.mmlist);
> +		spin_unlock(&mmlist_lock);
> +	}
> +}
> +

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

