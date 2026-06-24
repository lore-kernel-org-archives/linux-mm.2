Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDB0CDE001
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4926B0088; Wed, 24 Jun 2026 11:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACAC6B008A; Wed, 24 Jun 2026 11:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D406B008C; Wed, 24 Jun 2026 11:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B12B6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:20:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05BC48DA0B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:20:43 +0000 (UTC)
X-FDA: 84915168366.24.1C88CD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A07AC0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:20:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mm2XNn6G;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782314441;
	b=spSWWshsRl0I2M/oWjb9zFj7tgqmMqn9vb79ClpdypSNlmR4cAxNyorA+ENqvSxQAOLjeW
	BhWq8w8r2lMKM3LVRTMOgVC8F4T+rTVTUj3PSNdxxeD9HiUuUlkINK5p7bX0rrefZvBJ5Y
	/glyc3T8f6IB+PEazuhqVhXKcCjb5cY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782314441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efQMV+ObH4Xjhw+WllJ7d6yyrO9Tj2kt3l4QfajSRoY=;
	b=02FGX2JgCd1RWfrBe7FCgGNhf0rfzjvmfCbjTbhnwsGjLsq56P5O7gRfzgbW2iOaSW/7I8
	jI5Y9o1b+XMB5X8h45ERwY8QLI8UZ8NstmXkhxZJTzjEAh7Bi2/JyDlr350fE1Rl8jpME5
	73gYzHR4ywbagMEzECqN5tnPkx2AOeU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mm2XNn6G;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F55860216;
	Wed, 24 Jun 2026 15:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE651F00A3A;
	Wed, 24 Jun 2026 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782314440;
	bh=efQMV+ObH4Xjhw+WllJ7d6yyrO9Tj2kt3l4QfajSRoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mm2XNn6GEwo6DS5U+5/kDiaWDRX+Jf71CxInavjjzYelnAJHVb9WiB6kvJwqO8+aB
	 cfAIk0b58Yob/QA1ilbKxfTgGPM1k38jsGI5shkgb0WsZQEogI8iXXivH0yLq2c2WK
	 oXXRCkXE1+WTmkiu4CH+BVAXq/bHiBPSMruD0sCtDDjSfsqHWdLgu+XegVRA8p60mP
	 1p5b09jaMzfSgl9Zvpg2I/USuM6EGEj5synRTnIqYIlTyC8iMgBhcyYFu2oFVkwA8s
	 ktSVKf7Zb8SvzOrYtvTvqg7SoJcbhLkju76HfTkzXN0HuFfvV/cu5TfEyLhsYvmU7Y
	 a4v3vmkhEPBEw==
Message-ID: <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
Date: Wed, 24 Jun 2026 17:20:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev,
 kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
 shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com,
 Kairui Song <ryncsn@gmail.com>
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-5-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623231635.43086-5-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1hs836ym115zjuboh359umzunrt9bcdk
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A07AC0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782314441-570307
X-HE-Meta: U2FsdGVkX1+mEqU6UNyX6CR95PoTuGxQB3gd/coUabvLrbk+RwKbQCYJMLCoxCr1TuoR71C/+0zUTqh0jsO8/Qnd1r9wpFMjXM/vgpNTWMfFlx3SaN8BFA4ImVP9ODBcU2TkNu2I7zCYaUcLhymL1PItC9P8DulRv+hKt2JtIMH396Q4FGp0w/jfss/MSG1NEYbpIHfgqof6ktyK/ov2tuRsNhUwes1VVD7Cum1XmNXYy5LRZB9zaOv9l56e2Uw1bsGRQ7MUA2E4IRFiENW/hPXhjA+djoTbzVQpBNoK5tzSoYPTRobe2ZQuqmGHoULqkQiRSzfFQRwYaLd+iDijxPQIn2WkaGXKDzv2IrpYmicLL2aD2bxxXMDBOriR2t2qMUhA+j7Ff2GSDmPUs/be/JEQCVg1jKyEFb+5AqyPBj9hV/YWhN28j6SSAXnkKc8C47KdXREAyubJpvIxqEnSGW75jfLvfk9UJ+4XaIPXwoe33GbfvU967HjgWn8TDsgRa9jQRLBnpO1VPlHpkEpUBZxtDwebPM5m7Z8OjvT0Qq+YcG/DHUEpN5b13vslpt5gW01wxgQr/R4aASNLSwN7vBwBtO+hmzL8nRg+QHOjONnmSClUgdh4owWOPCdLQlnw05pI/ZqQqQ5qfJL1QFfCGhtGd1SC+mlGGATfgoHmnRBaSGn1lWyGLtu1vvBEAILqPGCv2E99d5q34QkUOZHCYqM7qufpdReKIKaI0D6RWySleQceFGE8bt80Sz4kwwhPp9V8zCykilVdaP/Jc/+rt4a5XaH0Ry6f06JJZ0EcZcz+B3DMj3Qyec32LT3Sj38kvrpASFMuP7PaZPrxE7YNh16MwekQJIlKU1yuLr2cp7v+vReM44GD1JwPWB6Jayj5atzVLed6ZQo9d5cnjArs+N83lKLKgBW1yYNFQbDAAt3qIzrbI6iXxZ5pQr6FVNLmkHjABtMhI7LO1pBwAn4
 a+6sGC4D
 VPOYeLq/T9VTH7SYml90ZAr5s28YD+E6AJ1GLPSoeT3piXhkx2711BdKNWyi1NlY4jBN7jvJDJ04ACJD2Lx7idYaUo1QGb3uZtRGNVGsAwVcnJEUsNGcBFV7LY+SJDuNOsSH0+KjRDUSQDAwckooIE3PzrI8M7FZtwXSwKdif3KCoeGHJCaIvoPB5AzKq6niJBM3mWhheyIKAsnTjbMJU0YI47EqmeIo3o8TkOUkFcMmZPLjHe2vy7xfbCGcYjWZEuqm2G87JbmIwMygT6d7fm3jAXAEKklZghae1udEkuOy/GKkTyUXVe0zumeoRcBd6qq2ZU/QAeG5+fYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> Originally, we unconditionally called lru_add_drain() for write
> swap-in page faults. This might drop the reference held by the per-CPU
> LRU cache if the folio happened to reside there. However, there was no
> guarantee that the folio was actually cached on the current CPU.
> 
> Now that lru_add_drain() has been removed, we have lost one
> opportunity to drop a reference held by the LRU cache. We could
> instead incorporate that possibility into the condition evaluated by
> should_try_to_free_swap().
> 
> Suggested-by: Kairui Song <ryncsn@gmail.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2983a6baf474..14577c67c61a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5087,8 +5087,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	 * Remove the swap entry and conditionally try to free up the swapcache.
>  	 * Do it after mapping, so raced page faults will likely see the folio
>  	 * in swap cache and wait on the folio lock.
> +	 * Assume non-LRU folios may be queued in the LRU cache, which contributes
> +	 * an additional reference to the folio.
>  	 */
> -	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
> +	if (should_try_to_free_swap(si, folio, vma, nr_pages +
> +			!folio_test_lru(folio), vmf->flags))
>  		folio_free_swap(folio);
>  
>  	folio_unlock(folio);

Hm, in wp_can_reuse_anon_folio() we'll try dropping the swapcache ourselves.

So I wonder if we still need that handling ("If we want to map a page that's in
the swapcache writable, we ...") at all?


Ahh, I see the problem now:

commit 4b34f1d82c6549837b2061096dea249e881a4495
Author: Kairui Song <kasong@tencent.com>
Date:   Sat Dec 20 03:43:35 2025 +0800

    mm, swap: free the swap cache after folio is mapped

    Currently, we remove the folio from the swap cache and free the swap cache
    before mapping the PTE.  To reduce repeated faults due to parallel swapins
    of the same PTE, change it to remove the folio from the swap cache after
    it is mapped.  So new faults from the swap PTE will be much more likely to
    see the folio in the swap cache and wait on it.

    This does not eliminate all swapin races: an ongoing swapin fault may
    still see an empty swap cache.  That's harmless, as the PTE is changed
    before the swap cache is cleared, so it will just return and not trigger
    any repeated faults.  This does help to reduce the chance.


That changed that behavior such that we *must* now always fallback to do_wp_page().

What a mess (I didn't ack)

-- 
Cheers,

David

