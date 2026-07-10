Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4A3C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A086B0088; Fri, 10 Jul 2026 08:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701B16B008A; Fri, 10 Jul 2026 08:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6DB6B008C; Fri, 10 Jul 2026 08:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 277B96B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:27:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB1338E1B6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:27:09 +0000 (UTC)
X-FDA: 84972791778.02.AED5C38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB3CB1A0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:27:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtVtZoIi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783686427;
	b=F/7yjGSnp7864yy6057rj7ZBKY9SIZBgDfvonpZq/UC1VBCbJqWZhYdAQHZEnzkZcS0wdQ
	RjmDOyN/mLSGB4WOVGRCyLsjycGXZO+Pl5iPDFye3o2P9OoYA8W6E9ewOMt0HGh0rIcj1F
	JedP8iKwNSiiTTuSZ4g7KgNc2DZXtuM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtVtZoIi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783686427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ypxRfNLnrRbcOYdU8qDjI8Qh1P9nHjhWrBxd9cALA8=;
	b=XV/Dg9xmrIhL4B3OyCwEC00+wD9TJFzj1gNVl5XbCeetZw/QtcXw/tfm6QPdjL1cTGGKe0
	CEc3y1TdM5sexm1Tso6W4qJgBpt8qZk3oJCMCjo6GuVJyl19qN2ns1HSCFfLcT1CtRvy3Y
	2RnDkaA06GUfBRxzgx7n7x9ftOhr2Bs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13E5D40744;
	Fri, 10 Jul 2026 12:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0818B1F00A3A;
	Fri, 10 Jul 2026 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783686427;
	bh=/ypxRfNLnrRbcOYdU8qDjI8Qh1P9nHjhWrBxd9cALA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PtVtZoIiLcXM8Xwok01zK/TGjKUGKi5pzWBWnXqJnSB70YSBwBB+HoJfqMaAEyzed
	 ZxzZecjRsGfUsqT4RKtjdaT0Jrn7c7C6kL/8lDFGgVgDX+9tlcS4tSShmVN9uximhT
	 UZ4lCYvIc3vI5QaeNpDHons1+VgnPABRgNQ4cI92IsyLzclmI758QEcoCY220Z8idi
	 5J70yoThivFvlV24a8cIEHqg6Gi3lL5DdmY8dDQtAjVPgKWRC/0qCRy0YGj/eKLJ5G
	 A9Zaald245pxVj2ndBHq3CiuKRqdmUmo4wRvJbigaesAJfJTGasDnvbeGs8k60dD/D
	 DIMFssxnNG7vA==
Message-ID: <00467fbf-0360-47be-94bc-d1456323e5a1@kernel.org>
Date: Fri, 10 Jul 2026 14:27:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/rmap: add anon folio unmap dispatcher
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-6-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710055915.638659-6-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CB3CB1A0005
X-Rspam-User: 
X-Stat-Signature: ic4h64yjr8mc6gujmqc7wza3bku8wyug
X-Rspamd-Server: rspam03
X-HE-Tag: 1783686427-421314
X-HE-Meta: U2FsdGVkX1/UHJFteq4t93C/hDLCfoxfw4rusBZzdjJcEBUJ7tLvVbJpjuhczaMDJLAOZXuB7os76/CxeY0Q4qMg4jBnNsYHABvkU8acLyxK3iySthqebXZikSNxLOr6OY4+8SrocfpnzSQXAjNr30xS2fH444X9s4ZAAA0Ivv9mU8hh+QN/PVp/8RR9uOVsA4ennOsE/r1veKRgJeqiOsNe8jclI4JAgFeVFbtepK71paPqG+CA2m4/Vh3BpnAMwG+/XUlp/VUnFs010QTnVxuvNEC91Qp+3QoyssE5TdhvSN7epd33V0u4I+sOTomeH0QPexZIYNPEGuPWbjTHPeF8GaI7zKwXb9SjKgbdZdGY6frQ8XoRGVwG974seGE9TpLOPA52T0k7Z9g9d0c4XbV4LlZsZuRcyamAovv76nN6/bMiu18EibgIbiyd31zjdc9XuGljC6yWeceGGAJLHl8GB5TaP+gxCtcsg2R71C0YNCXfpzAx1jOZTdCP7EppVFFPvYwjZiZmDuSiZtHrZAzg0eRE99bXPfOQ4lwhN+6ENu0C1TTwzYLFsUw1yfyGkBd9wimgedUsb+KHetDGwK5InmRZ8p3TlHbaIUoapnHtJlENqSzkBL5ZJuifTvtGarmCe5zCCsf5tYH8VF0X5XXucclEAKIa77ZEooH1nwFSInQTItnOKoEix1ZuRU0nDXXcLOqkbutfZrEOV8rKgnJXW9TOk2T3hHoW/8Npfm96DYOds+yj59Ca3NQC7js8ufCbY6RXDM91h3TqtErvkDlgNZZ5K1TdSVCNh7lZ9A4ZzYXrncw90Bg2qfPGYbShHuPBIjbAS0wVp3G8b4BD9fKrsfq7rJYL7+mC0vf2ydaHXG1BAw/5gUcfrDNGgCD3/KJPmHnuNjTM/nAHCRJUg8qp+3CJvGmwxxtpgKNxE+p+2k4zYX4LvOhyzUu+2PdRbOX9wzymD6oGc4JoCyl
 J+BaJ3EW
 DSgOqn22LtEoW0nyHq+/6shn16G9+vqvRwHCR/PAl1APlF0fl+GWzg2gLQcW3bT4+4yc3t9JjCKaZ+PE150b1kMniwUORDv4KRudllEhcebHswrrPwmpaqdceQoWhPUWDSq5j8vJ8F6aVyWTSZdeJM3GkWT+PmkSoXIK9/CIyY7bVOwuXsHsIJFx3hVCGDpUjA39SBXaXtvj0ijmdqtqLT6AdiGEDKFezXTe9zlopjtyGnjkGwiFDzpQbjYiG5jQ23bqHUgc9a9lbpoXC/hdOtDQKvdCyDjaW/AjOZRf4UNFYCPFFoPtbbM3nvRypCmiC/PqLcf8P7fZqWgio85hegXoJqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 07:59, Dev Jain wrote:
> Add ttu_anon_folio() as the common entry point for anonymous folio
> unmapping. It dispatches to the lazyfree or swapbacked helper as
> appropriate.
> 
> Keep restoration of cleared PTEs in the caller, where the PTEs were
> removed.
> 
> No functional change intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 47 +++++++++++++++++++++++++----------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 68459f23f5c0a..55aa3ff8bf216 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2172,6 +2172,28 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>  	return true;
>  }
>  
> +static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
> +		struct page *page, unsigned long address, pte_t *ptep,
> +		pte_t pteval, unsigned long nr_pages)
> +{
> +	/*
> +	 * Store the swap location in the pte.
> +	 * See handle_pte_fault() ...
> +	 */
> +	if (unlikely(folio_test_swapbacked(folio) !=
> +			folio_test_swapcache(folio))) {
> +		WARN_ON_ONCE(1);

Can't you directly do

if (WARN_ON_ONCE(...))
	return false;

That even implies the unlikely() :)

> +		return false;
> +	}
> +
> +	if (!folio_test_swapbacked(folio))
> +		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
> +
> +	/* nr_pages > 1 not supported yet */
> +	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,

LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

