Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC24C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14886B00A7; Mon,  4 Aug 2025 11:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4F26B00AD; Mon,  4 Aug 2025 11:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C686B00AE; Mon,  4 Aug 2025 11:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A55F6B00A7
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:33:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49B4C1DCC8B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:33:38 +0000 (UTC)
X-FDA: 83739469716.07.1104435
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id B667118000F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:33:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wqpgoPxK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4/gAJ8Rh";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1CuIXsQU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c7OOTM4U;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754321616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cpecDgVmpKu0rGCxmXRXuJz/heKHFUxU0R7ay2Nsgw=;
	b=J2kCrbcEOkOW52pbsdPxrlTxwutWKvmGd3aFA8bvl7wdrGTVEP+OkQ7t0qguUbIcGgRvuJ
	NYHD6MbyLqLbEn9sBpRDpFZXpAAGe013ZAIya/6wO0pL7ncnvZy1IKQWumZH3L+qZXFhL+
	bknGKypcHus4EJkIN+W2zg9krHx891g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754321616; a=rsa-sha256;
	cv=none;
	b=FPIj7vkQAeo8wWyBnhqxTyxSg5sUNX5+K2JSxSoj3kJjI6CRC6aHtmoS/csoIDEIkQnsFW
	ob2l5IvmPoF/PQA31jsxhnTQ2MxDZPjlNZ86S6k6s9ajFaSRnkDiYwkfGlmVbamKoLhUCf
	li5Aj4rR9+AgSedYkq5kBXuoRn7DwGc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wqpgoPxK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4/gAJ8Rh";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1CuIXsQU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c7OOTM4U;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E392F1F46E;
	Mon,  4 Aug 2025 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754321614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0cpecDgVmpKu0rGCxmXRXuJz/heKHFUxU0R7ay2Nsgw=;
	b=wqpgoPxK7Kbb5dPmsQqcqVxwnYtu2jje5hwGJPn/qmh9/ixfeOn+xLTYSywDPWCQpcWhTf
	92mW40ohaLZBa9nnuGXVCVss17iQyEV0+dVv05IhIBoNkTTe7+0VZrIRCMPTjHGIPVvJyK
	HIvEtsJ74Fg+exWNciSzvQye1wiFqBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754321614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0cpecDgVmpKu0rGCxmXRXuJz/heKHFUxU0R7ay2Nsgw=;
	b=4/gAJ8Rhip9oP4LIMCEPj6LveSTeJOpi8JHMU9Pz5jXwsMjMDudGqaorYgWSdcGPMhGX9M
	6bQ9N5VIlkJtSODA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754321613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0cpecDgVmpKu0rGCxmXRXuJz/heKHFUxU0R7ay2Nsgw=;
	b=1CuIXsQU6LDqQ382s+MaKoOdFqZZG2R1UoxJ3cfdQxAq4Nu/3joUObC445zB8OFZ0rqwBP
	7/BTV66vicca10EeZ9zcRkJgJNQDTahdVb0dPcT20taKwWET3eYOHS8l0GXiV2XRhZjEQD
	R/x4zIMsuk17awl15EXeg/J/SL2mQbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754321613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0cpecDgVmpKu0rGCxmXRXuJz/heKHFUxU0R7ay2Nsgw=;
	b=c7OOTM4UPpxA/B4rhizfvgzBtC4tQdAKJt1kJatyIdm+DdZssyDNsYrlDSKW21nyMThPU4
	2kpQuhhiwAIyrMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C31BD13695;
	Mon,  4 Aug 2025 15:33:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XY1IL83SkGjIdwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 04 Aug 2025 15:33:33 +0000
Message-ID: <a12fc401-59bd-4005-b1f9-fcaa1f68f68b@suse.cz>
Date: Mon, 4 Aug 2025 17:33:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/nommu: convert kobjsize() to folios
Content-Language: en-US
To: Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, willy@infradead.org,
 jannh@google.com, pfalcato@suse.de, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, SeongJae Park <sj@kernel.org>
References: <20250804145117.3857308-1-sidhartha.kumar@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250804145117.3857308-1-sidhartha.kumar@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: icg43dtyqid4nweopcgkcyi987zjk4jx
X-Rspamd-Queue-Id: B667118000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754321615-733086
X-HE-Meta: U2FsdGVkX1/2vp2QBdJWSbxk0My0xSBcCX4aRz6uh4lRd78crdSbTasYeQ8YV+KWFVp4fxLas3EndonzL7yxCBWvuA/KTySOuGXpi4cgfzJSZf540UKD6BXgYa0wR/PwKOPW+ya1Wm3UOkR5Vog0cP+rGMuhX0ACPbU2EBBYVaXZL2Sfm3d5NATt1S7m3760cmCmkN37S1pCPpA1NPPJrbOdymvgEg+FwtJntsYDiVtbiEyv6V6eoPLusA4ytv65YoWUcYjDPfG0EE8hf4lcfjjES3BwabJ9poLj+8lx16QCyOsLG21uw20Y+f/fVzINro3plzHY9xbHKA7EJ4sTvI1KyuXNbUy8jKCR/BZaJmWQlkB+sxN6WMwNACqJQXSNYgwbCbWuh3H////rJne1pLpylRBQudNhZome7g7bUSHvYkE+rApeew1IsqNThQWfsYC/xGhDwvkAyOwsPT26hN7VEFcDFyRH2UU3cEruBVAwWxDIsVd+rDWkU08qGtWZ8jI0lqmz8fg48QXXNYswswEIxnzZiZQEeawUDzBdHvYUKUPsxciJngr6s66193Qfj+LOoGhaAWlnTUHvu9ha3/mzQGBYJiE4buf13fTGEUdlZ2ThW2265EvHnXvl6IOrlH0CY0DnsN2hxrOpiU6poDiEGg6jNqH6l9eY51JZAjCh4Ji8tBLj2XKAEydyVW0DX14qJP04JDs2Z5rXpfe6dHbm14dZTHTSK7KTtfc13icfQzZkbuMbtinMdPthJYisdVep/QYJoRz5GD77K21VOLgj8CNwvhMA2reyyIYS9hfweAe1zMD/RdIhr2Sv/ckBtzNlvjV18pjZGovYDkrkr7EcSr6RY6yo5DM5VJ3t2mqaUu/OVAFZllqBRl7oFbrFruZzJukO++Kz4OQIZP6rdt9rIySFMwjw23B0RNvrjRBPlmuLnknkOTqSRj0IQT6WFBR6Dm14A8bF8FcHOXM
 jCdC9F9j
 2OmvvA9S0SPxkjgWY9eK9aFBa5Uic1ZkqZUoCD+NVtTtsu/fljKhJUcK8JAUa7s0GnF2xdDgiAjiQL50DsTXfUmLF61jS/OtFqgraeH70hY8a4j1q8H3ToodNwB7+LJ0uOCmXHfY4xIXYBBivsnlrOrZ3OgeMpT+WKwXb2uUFBdWagtaJY4y5Nc9XFIKhei9xk96hMZ/UUfzcmFl9GSilWCE6n1l0bvthdnU5+UmUSRhWIY7GmvzvO3xqBf+JwDD2cMQFIENhNY/9QsxiB7R4qv9usxzEjkMRJK7JZSWAg+1tRD4z3XBgTchaHEPD0SnK4F3QUVS8zsmcP9E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/25 16:51, Sidhartha Kumar wrote:
> Simple folio conversion to remove a user of PageSlab() and
> PageCompound().
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

Ok a stupid question maybe... why does this code exists at all? AFAICS only
that fs/proc/task_nommu.c can report how much bytes the kernel objects take
for a task? That code seems to be from pre-git era. Does anyone care today?

> ---
> v1 -> v2:
> 	change "compound folio" to "large folio" in comment per SJ
> 
>  mm/nommu.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 07504d666d6a..75548fae28f7 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -64,7 +64,7 @@ const struct vm_operations_struct generic_file_vm_ops = {
>   */
>  unsigned int kobjsize(const void *objp)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  
>  	/*
>  	 * If the object we have should not have ksize performed on it,
> @@ -73,22 +73,22 @@ unsigned int kobjsize(const void *objp)
>  	if (!objp || !virt_addr_valid(objp))
>  		return 0;
>  
> -	page = virt_to_head_page(objp);
> +	folio = virt_to_folio(objp);
>  
>  	/*
>  	 * If the allocator sets PageSlab, we know the pointer came from
>  	 * kmalloc().
>  	 */
> -	if (PageSlab(page))
> +	if (folio_test_slab(folio))
>  		return ksize(objp);
>  
>  	/*
> -	 * If it's not a compound page, see if we have a matching VMA
> +	 * If it's not a large folio, see if we have a matching VMA
>  	 * region. This test is intentionally done in reverse order,
>  	 * so if there's no VMA, we still fall through and hand back
> -	 * PAGE_SIZE for 0-order pages.
> +	 * PAGE_SIZE for 0-order folios.
>  	 */
> -	if (!PageCompound(page)) {
> +	if (!folio_test_large(folio)) {
>  		struct vm_area_struct *vma;
>  
>  		vma = find_vma(current->mm, (unsigned long)objp);
> @@ -100,7 +100,7 @@ unsigned int kobjsize(const void *objp)
>  	 * The ksize() function is only guaranteed to work for pointers
>  	 * returned by kmalloc(). So handle arbitrary pointers here.
>  	 */
> -	return page_size(page);
> +	return folio_size(folio);
>  }
>  
>  void vfree(const void *addr)


