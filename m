Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CAB9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021116B008A; Fri, 10 Jul 2026 08:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A7C6B009E; Fri, 10 Jul 2026 08:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2BC06B009F; Fri, 10 Jul 2026 08:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEE7F6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:07:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EA5440461
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:07:32 +0000 (UTC)
X-FDA: 84972742344.27.0459233
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E08BC0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:07:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LIIkB8KI;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685250;
	b=eAb3DJiuQfBdhR1wYyEGYlyxbOBNdKKJE8Vj7aUhbgssTPjAJpRBIySaZFVrV973gYTGQO
	Zpphb4ljltcUl/bLp1Z7gd3MmTO5EQkUGxMTjd/fCmyLeeWljUAbIjH/aDct2PgfO+Cez2
	sSApU0ZoYvhHRpA/EAVi3J+fzLMDRIQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LIIkB8KI;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAv2/2M4yX2fjc5Qw6c2pxO6oxabzVLlay/XuFKe7zc=;
	b=2P82TNNZuZ3uz/JVDO3HJbgvpd9szvnuGRMAtv9YZMEbbVaTDu/nY6OhloprnStoYVm8iz
	HdSqsZuA4gBj+Eqg/tNsnWXiYi4rXzdQKoLc2aVKvwLdidW/AqFn57vyllD6NQzce9YulW
	dWFnKg4p3S0CCdBTdWeOzx75bC+u+Sc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 715F94164C;
	Fri, 10 Jul 2026 12:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5285B1F000E9;
	Fri, 10 Jul 2026 12:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783685249;
	bh=dAv2/2M4yX2fjc5Qw6c2pxO6oxabzVLlay/XuFKe7zc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LIIkB8KIQjNPRB2swohnc/L3zBYDf6fwwp4eEIK0Vi65rxROayQaadbR6icpZNHs8
	 RPdVgo4f4uIOGRzAgtOeWXr4/63fA6gFp0cKEwPx8jr6grEZ3aFk7SyBJ8dQgKIjBG
	 hFUFvNFEkhGwplFyo0uWvVlWFWdOvcmkosfPkQnmpXfloigce4/4QBmnQRZlJeNGkO
	 9fQ0RS3rTqIP7NsroVCPOw4y7u+k43Hp5uiHfQcJsBvTHgqv9AEVE5NmZ+/NnDXx8Z
	 J2Q72hkQeoChdDT54eLpX/4BiupYya873pnZaAc5JVkd1hkkaRihP/R5gQ74hPu858
	 wywGKaEOzgM7Q==
Message-ID: <1bd96ae4-f59d-4103-a700-f9478e88c05b@kernel.org>
Date: Fri, 10 Jul 2026 14:07:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: mincore: remove special handling for VM_PFNMAP
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-2-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710120052.103886-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E08BC0004
X-Stat-Signature: q1uisrd1mrct57f48joq5z5ud4qqkpu1
X-HE-Tag: 1783685250-211808
X-HE-Meta: U2FsdGVkX18FNi2zzFuxKzIyz2lvEywnUlapZQ3gP/SllGzOSmyQ69ee5cm70yeVlVYUCkGFS87+2fu8GZ0OVYDX1Umb3R7bgKyxAYTaClGeuajasiiQJamJfv0ixkAutk/pDIHlhYgx/HgGhJnLZsVf2opIf7jXpFXbKR1bayoFMUR1B6hakWP9UaYGVW4dtWDvp8zWocgpCzxw/g+KgZsZEgTFOEuYVgf6sNvzSARA+MUGbvSEDswcao+3xdVhAEF96JGcHbFze3vbAd4h5chNv8caWSmqkLYEy72D1k6Z9EYBjEaKIg8c26rF/UO/ahr64fpUsvTUks0j3/DtOMMXsZvGy+MZX6gWcyxPddOxjyyijPOS0Kz43BpaCP3ufX1onyXmmG18tqwsyX7m3Ra0w64Lqi8+lesVBec/vhDfwbOufGnD24UZ0H1ajKDg/w0eJj/lpdBdG4ahYTxPP4LKDjqvjDOv0d4dwbejw8Gph9M80+8PoOvM8g8C7lsibq2d7jWZzhNx3GkBtmZGJGf8fvAsV/5JUTyIMNAuDsw5lJfr2dh21xTc5Kfk/mopjS+tW4XbunIzfZvFCMm1XicIfHfG1JeIFJpX8a02GLDCBSLTQkuFFv5Q0t2fHpRhwdggwkfOIiQuzhtjyFRcq86BC2QZrG16/uUbNdjPougxC8D5d54VoSW0npU5HWmZALX+JtdCG4U+p3WMy6QJiEGXRoBq6iM+uOxG6cjmsWtAAaalcRugxpwKkrVXLY+26x5Y5xYVLGwwaehTrd8UkkGBwtGdYBSJdkxaWchQNG4vUcXhkaWQeJwvVPu/0LxKHJL8m6t+bvosDdOdO7IDbAz8iyPEzrQ9xo8orx2PIbQ5AMyEW1hB9CRvSvnZCoYoOQdXoaBMgjcWqnKF12xcklXf77IVqLYiSwSIab4qD3vTw+4h1UcSvvr+TeqUTHTXWfM0dIXVQy9z38vj56k
 YY61lbvk
 mcsr4TwgR/f2qlHHeybTTVrkxJpiXfSl5U96gpqj33TTtHXdn2QyOZY2I6mxhumgIG+PGIyNrZsE/wzT2RGr45WJ4cPltKcH2SHXDu/m9K9BWtTDqml8zip/rR6lLUrqd8Fs6eXDCNA14YdkjXlZQiKXjbpTd0cbFJ2qspwT683w+N6bb1Heuymbi5a8U3FQMUmmcI5WMsMMbLQ/5763eLAx409AlDWcw9uxPaurzHsKFt/xq/LH26QU9cqCG9Ct540pQFJWbiAhrm81q9DQuCadCXYADonKhL9CeCSzVGAcGVfdJtDcdjjHHni5DZZ2z5bRCSkhn1M+UBCRZxjrIZx4YRjbVM8vymgi1CiWx3ckDMi2JZqNUCyGEceKqV3KKm0PB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 14:00, Kefeng Wang wrote:
> As David pointed out, "it’s hard to believe that someone depends
> on pages in VM_PFNMAP to *not* be present", so remove the historical
> behavior that always reports VM_PFNMAP pages as non-resident.
> Instead, make them now reported as resident by checking the
> VMA_PFNMAP_BIT, simplifying the code.
> 
> Link: https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 53b982803771..0eb832ee0a30 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -219,7 +219,7 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
>  {
>  	if (vma_is_anonymous(vma))
>  		return true;
> -	if (!vma->vm_file)
> +	if (!vma->vm_file || vma_test(vma, VMA_PFNMAP_BIT))
>  		return false;
>  	/*
>  	 * Reveal pagecache information only for non-anonymous mappings that
> @@ -259,14 +259,6 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>  		return pages;
>  	}
>  
> -	/*
> -	 * mincore historically reports PFNMAP mappings as non-resident.
> -	 */
> -	if (vma->vm_flags & VM_PFNMAP) {
> -		__mincore_unmapped_range(addr, end, vma, vec);
> -		return (end - addr) >> PAGE_SHIFT;
> -	}
> -
>  	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
>  	if (err < 0)
>  		return err;


What about MAP_PRIVATE PFN mappings with anonymous pages in there that could
have migration entries?

I'd assume that we'd want to scan the thing and simply mark present ptes as ...
present.

-- 
Cheers,

David

