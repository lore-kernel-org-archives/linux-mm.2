Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3139C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47D16B0093; Thu, 17 Sep 2026 23:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8F36B0095; Thu, 17 Sep 2026 23:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7596B0098; Thu, 17 Sep 2026 23:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62EB56B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:13:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C94D16055B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:13:11 +0000 (UTC)
X-FDA: 85225411782.16.7B3EAB6
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf11.hostedemail.com (Postfix) with ESMTP id 993F340007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:13:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wDZm8kop;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.234 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789701189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnKgH12rIQjJaBvAg5EGDVVRZjrGbFrjvdaF1m1X+pw=;
	b=jbmnU15DXAEnum0xt1HXcvQJtyUrZhBSOLN3JBi62THOuNhQjuZm2H7otzK+3tD7VV1R43
	sV/iH7hH8ouMiFaqfd7W064lFApE9BTnDpDTSYjMVqwIYNpxt3scObskadMgKPOTtc9lK5
	uIaI/ebCUj7sOPQ8sZlDN28ERMoc9/4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789701189;
	b=6scojABkS51s1IK2iZ4lx/57hirxyMDw9jHaJZLgFaeF4TCzwlWwGjtAkSfzfQx+ZZqejn
	5eCtHdXprXbcmMdugIVU4wLdbaHyPsszPz3MZXEFYe9fd3SZGtYndTe6+5JgyfFZRgzzKk
	XbEs8X8LlIcuLCFcjbXlJQHGjoMvRkc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wDZm8kop;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.234 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-5329fc7b325so1557081cf.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:13:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789701189; cv=none;
        d=google.com; s=arc-20260327;
        b=Rg3pIqvhTXBFaEM7JnpCgUlDmDjGWk55C2PDkpbKO4dO76LSdwGPb1OJfOSfqZAqwS
         iXoj+0x859AjZr9xWca8rWZ9sI/T41EFIJ+p2KPNn6ZcqOGvkVG5rSURql1cjcOXUum1
         3u6lotim8T8NXF7fze/VeRAGnPWhW/BpE97wOg+rj49pacBCeijjIbn6bdtkuHHS/BM3
         S26x9w8yM+ZGZwQT/PYf9Zp4DZgLgfBSncS2ipIhBoLQcRg38yb4WTjO9LnN7Pbd87iQ
         R1MhfcNbC3vPnuLsePx2DyzX0nei73+eLD5h198uWE/sVesb4RXShm4km1qLdRFSAh2v
         UmPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=HnKgH12rIQjJaBvAg5EGDVVRZjrGbFrjvdaF1m1X+pw=;
        fh=Wk7QRmFns9naeiYbMJTgiWBp55LTwuw7Za4s6ECMVbE=;
        b=rUvPtX3U63eKtH74FV98SI4oZ/WJQKNgvSrBmzBhu1ilMUZIxAaxnkIE26Ia3RDkr/
         sI42dPP1h4BQbm5h8v1AYRaQPu8J03XAj6vVWvk5ZWxr7yLBLQWJcmsqtC/0z2bhdglE
         XMyBfJQ9yAPotOBBCpPYLqOH7Bu8ehy9Morx6sqgmUiO2aV9g7dQeYp8Wtd5VoHU1XhJ
         mg0a3GZPvIfS+76D6u6smUlKSuw/mjvpWKyjEO96FL62oCj43vPqLY8xF0bHossygnAe
         W90Tjb88G/zaSGhS4cDeKN8YSTxWhh3UD9U/lANTs8cjlLSPCyEtYORXBB+SHV9U0gIo
         5QGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789701189; x=1790305989; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HnKgH12rIQjJaBvAg5EGDVVRZjrGbFrjvdaF1m1X+pw=;
        b=wDZm8kopbhujNoj8HA/j95Swr8n2Y8Tq/ZfCQnq8mm0zTNgtkSDLnyewqUmDqy6MAF
         NtCMyIS5dLsFogFsPtvOE4rdpDuNGb7qfrPZBUw8t3OgurrEg+j+pyYNRYVvyZDDTiiN
         fug1Dv6J9LEP/lCsH6iSMahlwEtGMQxrQuA3QrKAzMiOgj2j6yEJD+31rQkeDXdQlKYN
         9o8WDjIeTNLDm3RUTq9E3zODpj9NWtN/iNfk/Y/PleizeKl1UOxJ8+Kw2cF4ALcwtp6x
         gEKrSihfQCW2hWRDvPI65qBHWJDK9ADWxZM9fzjmLAiZHOy3rok6pXVeS4sLCLT1U1dE
         YupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789701189; x=1790305989;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HnKgH12rIQjJaBvAg5EGDVVRZjrGbFrjvdaF1m1X+pw=;
        b=H6wx4KcFKDpXmQAInvg0kcNJc6k4Y6i2E9IG49EA78qj+GR5Jfgt4mtF5mom2PQ1da
         t133sVfx+8PW/VZiiDKFlC2BSqeQ6jzQ5OAVOdseBurjJZ0CWsFIteCHD6C2d4sech0L
         QMupcGgiZbDNPZKBCS6jUh8yQqGfYEoVrvqUFXPRjWA8/RWRh71OVYR66bOOHBoMP3ue
         SYph30NL3E5OxCLSpl+bhcqcg3taEDgwwJkBY+ffLX3GQISheAYebY8lB6207oGbw+v3
         Fsru4kOb+9SK6JvfgALtB3eHEq8p6mLLuovjcpO8dodxJr1Aa2FdyGvZ8nEc2zGnF+Yn
         efng==
X-Forwarded-Encrypted: i=1; AKwUvByZeNAYfIUavZyHZwuBMcBWS307zYnKkq/7DUGmCbynI8czCKJ6AyRUH/mVKGi6C5MIbktzzSm6Hg==@kvack.org
X-Gm-Message-State: AFuF++n7zMalIIg8IYCb+QPzbdIgc1TkhpYsB8HNOhXGph03bchOb8dV
	Nkt8bpgdo8g3cU1I2XTuVKf3KlXd+QlhspJhEpks8OMaH2qFcbfbunl8CaDG4beOzi8bo8M4sbR
	aCpiD3vy3nuBZLOMap5wpZr8HbplpeLAtIiFHZtZZ
X-Gm-Gg: AYBFou2OZm8tlTgQLrThEpffRcWuc7t2uRl2WzqSj+re5DUSQGflmEf7r93bwul8SVi
	DY1D0n/OXKgUGG9MvgHAciJ/Vk/A9hlgwTzS9HPWWL+8nS+nAIucu1fOuyRTHlr1Z+6GFsV71JM
	WQYxiFxP2tJqFrVZIzskamfEKMORWBFZrdpnZU+0+WMmah3W+rwxT+dQ1s4TzqmMkcdB7hqQ/GA
	Di0DEAsFWcnenlb9ndK23DwFrITF44e31kaQe27/538+gInTWzBXGLYXnsUAukJ9xw1sdtQalud
	4YX/rNt3qyfxWEz7rsRfSA1w3l9MB1HtP5KuYJ3sHSwyeWBPMl5d1fb8TQIIJGGHP+0p+lgundg
	UPz+RFLEdKg==
X-Received: by 2002:a05:622a:2615:b0:531:17a1:7576 with SMTP id
 d75a77b69052e-5329e4a3d42mr19288491cf.52.1789701187201; Thu, 17 Sep 2026
 20:13:07 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 20:13:06 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 20:13:06 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260916-hugetlb-subpool-always-track-used-v3-4-38aae9b5ccdd@google.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
 <20260916-hugetlb-subpool-always-track-used-v3-4-38aae9b5ccdd@google.com>
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 20:13:06 -0700
X-Gm-Features: AcwNN1UxtUl99q4k3Xb2wmimX9em7-sbEcOm7MskCUYsrn1OIK-ISFMFvyN52wA
Message-ID: <CAEvNRgFgCdWBrMLZ7wxAgVwyQhrfHj_0UY4++zS4n30psgkGxQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] mm: hugetlb: Avoid re-allocating global
 reservations on region add failure
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, Alex Shi <alexs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
	jthoughton@google.com, rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 993F340007
X-Stat-Signature: bj5useh1wzax8b8q5hpophxop7ercq4n
X-HE-Tag: 1789701189-594557
X-HE-Meta: U2FsdGVkX1+VzNL7TmMMQ5liWyZl3l1sl+TXz09jVlJtvjZVyPhPL1DGBZNSYDwuvAA3drnYoCVTXdOmPiZz1YkMWiIGg9QEUCOP0dVAXY1yp5/9mLG9ync0u4pBT6bxVEHPVIP+8xLP6/KsphYVazSz8BjNPWmk26DCRhNPwTUr4FzM2ImyZKmDhTl9uuwlj2Cai9upoefGws1fugz7KO+LuTfUWYGxNlMEF7xNUAyrpZNZA/m4YkVmuX5Z/BdBO8tBxtrwitT3GNrqU1NBtdqWPSQtgCCHD4Qk+d61subK970Nw/gtF12zfVHYVG9AyW39sgbmzw1N5zqYfY03nsluBHu67O6S0zu6Vnsvv18PPE829F+LVgV0xLa2Iwcr4QYzAmiQbkAxl7swpvbwuQnuXlMtRrWtp5cYMYkte0Y+yuOUjvDeMUJGZQRYC5OHbBn7rGfQcRa9VsndKNu5ROcI0vdP9Ua3uD9ot+06CpnfQoUHrd/kHsyDpj2bLhxVewbIvw6SSqAtfMPGjnd+iRxRDXpu6X2sjY5H0XWUwvMaDhZ2rmtZpKo//GachV+jxKXDZ3pUcQxZwgbFMkfqT3d9Ph+4EQ2hALBBN2gHLRtMpVli6aUhtl42pYr+zMz3ZE087EjhCEIHujiNz86Ngm69IN33TbwYGyNmbDEjvoPrqjN9tPmHTWhterBKb1WB1DqRgnwrcHshuUpFoWpT52k4AWYw3XFqHP4fvkzfeftFlyN/NQcR83P2JkfgeO09Szz1CuMKrjVdmxcBVc5y2Na0y3XmMXZaqN7mugIx0++8jF59RvM1X/5SEEpfIileSNhEcRlVae4YxH58hMaZ5MW2547yGfCX88iAPUz0IQ0JHBrupa2U423bYrngka6fhEJrpWQKt0U6vMkUEFIB1FLezJDYcsOw3m/eBtx1jcqJnXeYJGPVH9ugi4wUVvFpcqYNCz3tLvhPwvkTEjA
 LXnfEr9W
 Hf6K+jJMHVL8Rhkkjc5WR5FDMfHE6363GIYAk2o+s/sT9YpQH3yYcH0Ea9rUVJ754E7e8pNhEfjw60v2HauGbs1SsLmQj3Z+zkv8OfK8GrHr9u2/xfNQF3CvWmBk8ARTnXWYloM0LNlxWzJqbOrrDc62+46y+R9jJpXUZKxFh7RzJymKBwg/jGuMm6e41+RJ4JQlXL8c4OO3WqVipXtJmA76zLMcvawahX1M92kZ4lO5W6m1gzhhZOFLTPLOkWTCBPP5xUEHRyB+jVSnJQary638j01j0qef5B6IUmFFBEqnpUZttv+qWdxntL9mrgXRe4t8jCUBDMDabu+6/96xiNYBn0R7pwFOcRuBZa+yT6Nblf+S9giDBpqAFzHjUdL5TiPoUP5TKkx+Ygj9Za6nqtnsAbvP5JXxcynmLuQ80Li2Hfqa8pzwTMhKBhFJDTZ4B6zh2oM1CaySoiYwSanHQAgR/MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> When reserving huge pages for a shared mapping, reservations are first
> requested from the subpool, and any remainder is accounted in global
> reservations. When adding the file region entries fails later in the
> process, the reservation attempt must be rolled back.
>
> Previously, this error path explicitly dropped the global reservations
> that were just acquired before jumping to the cleanup label. The cleanup
> label then returned the pages to the subpool. If concurrent activity in
> the subpool allowed the subpool to absorb more reservations upon return
> than it supplied initially, the cleanup label calculated a positive
> difference and attempted to allocate new global reservations from scratch.
>
> This premature release was completely unnecessary because all requested
> pages were already backed globally: partly by the mount guarantee and
> partly by the global reservations just acquired. Prematurely dissolving
> those reservations forced the cleanup path to attempt fresh buddy
> allocations that could fail under memory pressure.
>
> Instead, track the number of global reservations actually accounted so
> far. In the cleanup label, subtract the already-accounted amount from the
> difference between requested and returned reservations. This ensures
> that when global reservations were already acquired, the adjustment is
> purely non-positive, dropping excess reservations without ever attempting
> fresh allocations.
>

If there are no other issues, Andrew could you please add this for me?

Fixes: 0db9d74ed884 ("hugetlb: disable region_add file_region coalescing")

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/hugetlb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6589b188cf657..ee1ba9ded0ec7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6678,6 +6678,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	struct hugepage_subpool *spool = subpool_inode(inode);
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
> +	long gbl_resv_accounted = 0;
>  	long regions_needed = 0;
>  	long gbl_resv_get;
>  	long gbl_resv_put;
> @@ -6768,6 +6769,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	err = hugetlb_acct_memory(h, gbl_resv_get);
>  	if (err < 0)
>  		goto out_put_pages;
> +	gbl_resv_accounted = gbl_resv_get;
>
>  	/*
>  	 * Account for the reservations made. Shared mappings record regions
> @@ -6784,7 +6786,6 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
>
>  		if (unlikely(add < 0)) {
> -			hugetlb_acct_memory(h, -gbl_resv_get);
>  			err = add;
>  			goto out_put_pages;
>  		} else if (unlikely(chg > add)) {
> @@ -6826,9 +6827,10 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * There may be a difference between the number of
>  	 * reservations to consume and the number to restore now if
>  	 * there are multiple threads interacting with the subpool -
> -	 * restore the difference.
> +	 * restore the difference, taking into account any global
> +	 * reservations already acquired.
>  	 */
> -	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put - gbl_resv_accounted);
>

Sashiko:

This is a pre-existing issue, but does this error path ignore the return
value of a potentially positive allocation request?

If hugepage_subpool_get_pages() returns gbl_resv_get > 0, and the initial
hugetlb_acct_memory(h, gbl_resv_get) fails with -ENOMEM, the code jumps
to out_put_pages where gbl_resv_accounted remains 0.

When hugepage_subpool_put_pages(spool, chg) is called just before this
block, concurrent thread activity freeing subpool pages could replenish
rsv_hpages to meet min_hpages, returning gbl_resv_put < gbl_resv_get.

Then hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put - 0) is called
with a positive delta, attempting a fresh global allocation. If this
allocation fails with -ENOMEM, the return value is ignored.

Could this permanently over-credit the subpool's rsv_hpages with global
reservations that were never actually acquired, bypassing the global
pool check later and causing resv_huge_pages to underflow? Unprivileged
userspace repeatedly mmap-ing and unmapping hugetlb regions under memory
pressure might trigger this.

Ackerley:

Summary here is that if hugetlb_acct_memory() fails, since the return
value is ignored, there could be unfixed global issues.

Sashiko also pointed this same thing out on patch 2 and 3.

This is a common pattern on cleanup paths, where the return value is
ignored.

I think the fix here would be as described in [1], to flip the
reservation tracking to track an available page count directly, but
that's for another patch series :)

[1] https://lore.kernel.org/all/CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com/

>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>
> --
> 2.55.0.1082.g2b9226bbc0-goog

