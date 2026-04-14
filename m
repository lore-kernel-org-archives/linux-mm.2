Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10676ED7B93
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762F86B0088; Tue, 14 Apr 2026 06:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713A76B008A; Tue, 14 Apr 2026 06:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602B16B0092; Tue, 14 Apr 2026 06:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 507426B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:03:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF176E396A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:03:58 +0000 (UTC)
X-FDA: 84656725356.29.5314B22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 113091C000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:03:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rthLquy6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776161037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ln567bhFpCAbkP2sLpyoq+fMICZKkzC5Fs4cdsaf4o=;
	b=D9Ilv8InWM0CizMc1Ybp4kXeWMn3swJ5OFle41nMgtMsEu2Jsq4wksG0/RQ9h3NI1w/5Ie
	jr8i/D8IRFnljPdHA9FPJvHdEj0u7ulIzjLnV0orQpkWx5RTXuNDoTA4zMRx+7HnxOyciE
	Hna1a3kvp6uxU08fVASBKUaejpGSbfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776161037; a=rsa-sha256;
	cv=none;
	b=PgfVL0uJy9C4raqgh1BnBewj0y2wy1gM2aPMeQtGVXN178XFKrus7ChXUP6xfir4Z06BwU
	k84jj4W75z86NI/kBa1yySwMIQgtIzEYLSvin5ZN+tBo+o8+ARvF4xM7BqoayWSvEhIkxz
	7CAgbaGrSsSAqqwP3VwTCMo7jsvna+8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rthLquy6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F3A043C0B;
	Tue, 14 Apr 2026 10:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73F6C19425;
	Tue, 14 Apr 2026 10:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776161035;
	bh=d7Ka3ZwFK5TaT/G34YVREMh7Kh+Pq8BGRtgE7VObM7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rthLquy6W53yHNuN+7q251v/1l3BpGX8+ooM+J87fE6F/2U/akcUF5t4rjtORXFrZ
	 DKPMipf2EzngqgemkhGuBy3Y6RM+mqf0Ic3LI6F9XIMLL4BpnvGwDCJBZBJayqxQSa
	 jga+QaOC1AOb3IVj9B39Vt5yDe+1oW/d4EYqw2oAl55C32ia/DicbvzE+FbAvY3Ud1
	 xCu6dH0d6aDE/4X7BEI4b2TcUtKbqPmYx/6a46hBeQDt9kpLGth+D1P8s729tCl9ey
	 +CArWDiBpPVZV5In/nuaYU1JxYYp12wk97GGwyOjKteNdsXQi70YOH4lkb8PXrvQsU
	 FWlRam0asLlPQ==
Message-ID: <2c0c00aa-7fb2-4d7b-90b3-0309c13468ce@kernel.org>
Date: Tue, 14 Apr 2026 12:03:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix double unlock
To: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260413211559.20969-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260413211559.20969-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 113091C000A
X-Stat-Signature: 858cw3ajpw3m7cfhyruifx6i1z5k7saj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776161036-608064
X-HE-Meta: U2FsdGVkX1+JAxvnFZxrOwiUgwY38H/ynS0FHCWxIlHARgGT1QzRMWf8CXV8h09D9Vcji1scVz350dQDemQ+WV1B0iwU3/2ujSuagouCNQikbcnqdfbHJS9UM03laS+30PzlLHg91DOIQFofmtV244oAga2d6fxl6GGYtOM3AgK30bY1jT4JTthWJFmEhcAg3xPpb779XAhm9dH68BhNJF6MyRGN/IP2L/x2xe1GNW/ew9VutLCFCvgwvUBNKSO/4P5Bi3qU5TCRi8vgYwV9RmYFeJIQ+nTsQ/7iE5rkGqOCw/H7+8fhZSDbvkX+yKFm6mj4ArVbyJIpCV0c06scJxubxsYf4Cfj8rGurjgKPBu8yu6easC0LrpsUb63rGP+ktGdczridpA8PCaj2wGn+JN4gS2gBq7omn9cmu6+bjDYqf0oF5Sv81IiwgITLdG6PjRFdju0R+M+mbFk4/Flb9TZFRAK/J/Y6Do9tc75HfkeDUHqBmLfefGYxsYblUoN4Iv00cyJmzkxyoOuafvL+D5Up8xAqaV7rs6CmZ/y/iNxPhuJivcJMoJAOzaRySxecJCE7pFSAA6p4Ftk02yWRXHt52ZINFpDsi0QpH2fdD88elk1WlRrzRhRmCVAdI1VcxK0ZJoIuYnYJhzfjZDtwm4YGnwuolcrQr3Ai1vNkVT1LdARBzyXp0U8tkm1jDtMmYajwT+N23Zdar9J1leYmaJDxwGPznPDtfibH+MRpgMgBryBQfxYogqTpSRzqJGlQRKxH3srLUpW7rbwAvEhPN6c5Bxp6ELCOYn9WxKt75wBAK2gySTYvE11Bxfu4TJxBUmMEzWkPLWbGEqoBw8yPXvLz18jaFLm/jv0bwtKIgCp4qzGwX/Hj7S/k5Rb+K3XQPuH7g4k28bvvw6lDgvVkteFVhL3xAJRn0X5ADYO1agRMlo2rVBhY1tSyCCsusA7VoyGiTCFvgNFnJTdxAC
 ANnuvT3k
 XS9qmEHJzAqrBFxWSCT38RHkknRmw2k0I5hpP+tKqCeH/gce6NDrN3W+eWLtMUO29XDJNz5pWovp6D6LiapNfj6Ov3QddHtNErOkX2ucwVEgqMf7OlXL7/L8WjYoAMHDjY6h+GpJ0ls0zvL0oxPGaj/o4/Da54t2OmzmQFtRmAYdAPzZcOcocysBjaGC8OgoFbXBJRGcIyUeFDzIKlY78/TcchNU6JFSv1UpfiSNmnDU3eyXjU3rkWlOcRZzXp3PYXFbZxNOcGh+w9fQYkE+b/WmytKozBEnQypqQ6pHeBc4c/8yWEopx0uYkPM0QoVhmF0CJC5Vz09pPpL/9YPOk7O/AAaYk0R7Hx3mosw/PwtqYhNddAQ2TNpTayY2RpCpwsYFgJoHK8Rkf+NjOECNkRe+oDv+vdXTTd3cQQPELa3EfgVUMieozDzFoWDQ6vbWQyeW3llF0x086dZMRKxrpCF5Wg2XeY0bhg85ZD2uVlfwnAz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 23:15, Sunny Patel wrote:
> migrate_vma_collect_huge_pmd() calls spin_unlock(ptl) after
> softleaf_entry_wait_on_locked(), which already releases the ptl.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 8079676c8f1f..7eb2f87ea39d 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  
>  		if (softleaf_is_migration(entry)) {
>  			softleaf_entry_wait_on_locked(entry, ptl);
> -			spin_unlock(ptl);
>  			return -EAGAIN;
>  		}
>  

As raised by Matthew, the entire code block is dead code:

https://lore.kernel.org/linux-mm/20260212014611.416695-1-dave@stgolabs.net/

And I even Ack'ed it /facepalm

So we should take that (cleanup) patch instead. Thanks!

-- 
Cheers,

David

