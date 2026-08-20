Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2246C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731706B0095; Thu, 20 Aug 2026 14:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708DF6B009B; Thu, 20 Aug 2026 14:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F97C6B009D; Thu, 20 Aug 2026 14:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 284356B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:16:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A93741C0C87
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:16:20 +0000 (UTC)
X-FDA: 85122452520.04.3B8FDEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D837318000D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:16:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OmApUQTy;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787249779;
	b=Z6tUiKTBluHQiYtqBs5j+uTYBIFqqJEGblq02ysIVHEdpvsWhQ8vbJozpSFrOu5QVf6tEl
	WZ+2gCCCg1jaiOa1dNhhnQYpeTW4xjEjYHX6op2MQRn4VXf9+mBYOkmPBsPMjSgSLAlSL2
	wfmD7fuIojxwT8CUQRS9OP8i/IzpERc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OmApUQTy;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787249779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qzXwSGRzxXf3Jyr1Li0HuCFQ/7f8KQjrL120t1/X8o=;
	b=JVRevgCERKZ5loewaSY2wN3jbF/vUXIP1eRcKi6BhEUS3NAFD8UZ91rvyxKMLICm10/YRq
	6F897sm3ANrNHt4V8i35vpn8P9ICZENTUftECTOcriHm4szb73ss1wZvMksK+MzpLtLtk7
	pxiXIsuF7nQS84D4WTXxd8CeswUOIOY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02B2140989;
	Thu, 20 Aug 2026 18:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126BE1F000E9;
	Thu, 20 Aug 2026 18:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787249777;
	bh=1qzXwSGRzxXf3Jyr1Li0HuCFQ/7f8KQjrL120t1/X8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OmApUQTy2/X8U2UCuK4noYx54xutL+aqvVshtWwIDIG637qlVRcWR31STHsM1nr8A
	 AsOgkZ7iVvWRFnlBvhJsNtT4OL38pvn9saS+tXz0388CxnSm6CxDvxbzgA0zNKFBTG
	 wj96dr0nonXho6K9Wm0t5rZCMuiLVPcz1EbOaKKgWtqZS2L0S40YbVJE9QURVMEW/Z
	 +Mn0CuaYK7+FnA9bNS25q9PWegwOkW1Dtl+2LX6xN6A9JSQ7b8oHHj7OBBNEjDvp7W
	 sebiPerZO/zOahgTo+0sUs5y2a+Y4ea4w0bTruySB3BbiJ7GGKvmiODELNlNaoXyWw
	 728MBcHmvIdqg==
Message-ID: <d4d83ba5-d9b2-436f-b85f-d0b05008bcf2@kernel.org>
Date: Thu, 20 Aug 2026 20:16:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3] mm/cma: don't release CMA pages still in use
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260811132045.5f114772@fangorn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811132045.5f114772@fangorn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D837318000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5yuzcajaq6476b9s4bk55o53gamppu4d
X-HE-Tag: 1787249778-194448
X-HE-Meta: U2FsdGVkX1+V6lUfDij8dkt0wM03lTcQFZD80aX/BF67LnMjxtr+xPT3CtMsjQM3ig/93wWvRqD11fDalMAYs6uD5edxlcd5qRTub0L/UGM8yWd9QB+Nkm/7m8X1x1iOJwk5P7P49PS2EuGPTMaMaH84QaY1Y9oNbcZmNDdm93HqZQnw0apsv1MQeTnaA5tiqkcqRaskBo/udXcMQpN8Rc2NGUmIva1vB6h0QiUpMy3fytU0cWnnR5POkvUlaBBsZvF1ge6shmSOTlGmrAZ7hOuzrRmV2LxeFpqHrOWtTd0mOTGwbzVWunpVGXaptRAdQFU21XXDW7TzKf8UPNulNytR9EV5qx3abtCUF4cBmj042hZhq8dMmb8scHHxTgv63qpvPssLs/Za9x4wCMRDDQoTF0wxiiHMXIwMfz+LbV+TcwUOHsPoPuEEhbhlV+iHHVudq082DAlUu1iSLyi4vWjsNQt8nx6oYFX+jJVIkKYZPwVnSpbmwbEMO2atazK0yoWcBXzUgPX1lgUrHqDRPEnbm9LtunSliOc3QpLd4VKTHreW8XAnJSFNmK23/ycDE4qTf15urW4LjLA+iEn5LOCymW56DX+ViVHARBCOiW4h66+7RaOOQhdc1cSvjSbE6EaT0VYNcbNDFMnh1ZbM3c3RHKJxYObIUaxgNsvBMj5Tzt47rYm5HeGo1jXHUVWUTLutl94uW1upq2RPRCOKBUBc3eG+INdY1487QLaLL3nnygmInJq/zKbsX2ugsjoG2W5MsmchlNxngWuG1Cz8s4pJTesEVjGgyIyVWs95nUCkw0hdiYhAkW52M7IHQiyN53Gw4fbUXaPOCjy+ib55cjDwJCcCOMxTfgniMNrUfkxNtcRnzdUnSt+OJXhNJ/oW3D72MIF7tIstm3+Fxuzr7Y9NkI2anzpn2faNIFFh0DplmvHT4ZmfdYQnrDGTxEvS+inh9h7SPIP7vW1ISYk
 OGTMBrfS
 YbMiiZRgZkE/uBBjOLnwXi9299XXN2MALgxFzAS2dMA5IKWjFPjk0kA7iu2kfyTNIjTy6ezD+dF5Cc7JZR7e48H+xKRBeZUpkRwzfpP+JZpJIQwttW+gpymuMZhgey04mxUuoc7xAL0uJauRux7mAZJFlcF50g8lrVUf13AYApswav9Iwl/m1UhKgQRjK0Hq8Aksw38MNCYFNjl/ChCqHXQJy8+vp1vC466dGrGlWgXNONEFrXukRtXUfo6sbVwKKNWxMpWeKS1QaD98F/MjTOqg+79UoBcvhQx4nlIi9kkkeSa5KG97LTZJHwDAQWOyYf5U4TFm/0U7ULniVM5VUqn0jRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 19:20, Rik van Riel wrote:
> When a driver calls dma_free_contiguous() before quiescing DMA, the
> page still has a reference from the device. put_page_testzero() there
> returns false, WARN fires, but the code proceeds to
> free_contig_frozen_range() putting a live page onto buddy and clearing
> the bitmap. A subsequent allocation can hand the same PFN to a new
> owner while the original holder still references it.
> 
> A concurrent put_page() that drops the last reference between the
> testzero loop and free_contig_frozen_range() can double-queue the page
> via page->lru, corrupting buddy lists.
> 
> Avoid the corruption by not freeing a CMA region if any of the
> pages inside are still in use.
> 
> Make it explicit in the warning that the driver allowed a leak.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Link: https://lore.kernel.org/linux-mm/20260809210608.06b5ccb9@fangorn/ [v1]
> Link: https://lore.kernel.org/linux-mm/20260810122737.030f8452@fangorn/ [v2]
> Cc: stable@vger.kernel.org

As discussed, I don't like stable here. Fixes is debatable (code was more robust
before 9bda131c6093).

Code that actually triggers this is the problematic code, this here is rather
making the code more robust for buggy drivers.

> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
> v3:
>  - simplify things by simply leaking the CMA range, drivers should not
>    call cma_release() while the space is still in use (David Hildenbrand)
> 
>  mm/cma.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index a13ce4999b39..c1425f25c39b 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1018,7 +1018,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  		 unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> -	unsigned long ret = 0;
> +	unsigned long leaked = 0;
>  	unsigned long i, pfn;
>  
>  	cmr = find_cma_memrange(cma, pages, count);
> @@ -1027,9 +1027,12 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  
>  	pfn = page_to_pfn(pages);
>  	for (i = 0; i < count; i++, pfn++)
> -		ret += !put_page_testzero(pfn_to_page(pfn));
> +		leaked += !put_page_testzero(pfn_to_page(pfn));
>  
> -	WARN(ret, "%lu pages are still in use!\n", ret);
> +	if (leaked) {
> +		WARN(1, "%lu pages are still in use, not freeing CMA region!\n", leaked);
> +		return true;
> +	}
>  
>  	__cma_release_frozen(cma, cmr, pages, count);
>  

Okay, that will leave the frozen and the CMA bits remains set.

It's a bit inconsistent, because pages the buggy driver will release later will
end up in the buddy, whereby pages we just freed will not end up in the buddy.

We could consider the following instead:

	leaked += !page_ref_freeze(pfn_to_page(pfn), 1);

(I hope I got that conditional right)

Then we will just consistently leak all pages (keeping them allocated with a
refcount of 1).

Oh, and it nicely matches the "__cma_release_frozen" terminology later ;)

(on a related note, the code in general looks a bit shaky regarding speculative
references, but we saw no reports so far ... it will all get clearer once more
code is converted to use frozen pages so we won't even run into this)

-- 
Cheers,

David

