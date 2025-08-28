Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93648C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB158E0027; Thu, 28 Aug 2025 10:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2FB8E0006; Thu, 28 Aug 2025 10:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9368E0027; Thu, 28 Aug 2025 10:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67508E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:30:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A4921A0215
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:30:45 +0000 (UTC)
X-FDA: 83826402450.19.C5E1EFA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id F2D7FC0018
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:30:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TiaksBK2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vv1DokT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TiaksBK2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vv1DokT;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756391443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRuuHCoLWwYVBQEW2UDz60bE1l/PW8wxhu/LxdEPMjE=;
	b=S4J/novyWw8alOOurSIOjGBMQcy1RqKpjxPt2NbX2y/M5UEmP/VCC2gCz5dGjU23qGoVsx
	IKQJJfw8bmQ4bXbtyHuZC30VAy2Lu1PduaJcrFAqRppQ1HlCbk1QLi38nDXfkKiEf/oG5Z
	+uWjWTmXMeN3kjQfQn1sCj0mtkJiuZk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TiaksBK2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vv1DokT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TiaksBK2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0vv1DokT;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756391443; a=rsa-sha256;
	cv=none;
	b=XdBe4k55Enwfhj1Mo2vXA7d/CEgJIVxJ88c2V1XpqjnZ6tjAg6Ot9of13cwWnopAzJF4DJ
	2YoWfv6WF28NV3VOAsXgksOM4cHQ2YImZPyIOTlDaC++E1iRzvSgeMwU9UQpETHez4Es3B
	NbfK5Hdqb21S853jPWmS44vwIXJrg3A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4A16F33895;
	Thu, 28 Aug 2025 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756391441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LRuuHCoLWwYVBQEW2UDz60bE1l/PW8wxhu/LxdEPMjE=;
	b=TiaksBK2Iso0XoO5Wc9+xCKVSkNGR7euxpUK3hFQj4QLxHQUkDvwQMsOxkhMjdKpeGCXPv
	X0QXCRrYH0gzVj3ad/Cjx7WtJvlp+9hU7ybqh8wKza9bnbygfCXifDs5dfcvizgeBVztvK
	rCjQbybCNt1O0XAsKxDm29zUVc7wXNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756391441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LRuuHCoLWwYVBQEW2UDz60bE1l/PW8wxhu/LxdEPMjE=;
	b=0vv1DokTxWHWRE2UdBhHRnIc97oM92EM9+5SZ2U4fjSt0S0q50GdzIcGVc+dCXQym8nF8w
	bPsHhvC0F3fwB8DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756391441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LRuuHCoLWwYVBQEW2UDz60bE1l/PW8wxhu/LxdEPMjE=;
	b=TiaksBK2Iso0XoO5Wc9+xCKVSkNGR7euxpUK3hFQj4QLxHQUkDvwQMsOxkhMjdKpeGCXPv
	X0QXCRrYH0gzVj3ad/Cjx7WtJvlp+9hU7ybqh8wKza9bnbygfCXifDs5dfcvizgeBVztvK
	rCjQbybCNt1O0XAsKxDm29zUVc7wXNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756391441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LRuuHCoLWwYVBQEW2UDz60bE1l/PW8wxhu/LxdEPMjE=;
	b=0vv1DokTxWHWRE2UdBhHRnIc97oM92EM9+5SZ2U4fjSt0S0q50GdzIcGVc+dCXQym8nF8w
	bPsHhvC0F3fwB8DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B7311368B;
	Thu, 28 Aug 2025 14:30:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fSotCRFosGhRIwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 14:30:41 +0000
Message-ID: <5f88a029-b783-4a47-ac7f-9e1ed6605229@suse.cz>
Date: Thu, 28 Aug 2025 16:30:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mremap: fix regression in vrm->new_addr check
Content-Language: en-US
To: Carlos Llamas <cmllamas@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, "open list:MEMORY MAPPING" <linux-mm@kvack.org>
References: <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
 <20250828142657.770502-1-cmllamas@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250828142657.770502-1-cmllamas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F2D7FC0018
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cnqadoqnsqorzcro8d876uzffxu4qw7z
X-HE-Tag: 1756391442-173944
X-HE-Meta: U2FsdGVkX19zsloSOjEKLwgJGFQjgzrclQfozh7tUXNCIjAD/1RXRHZAC20DXm1+qPX5LkR0B7q+iEjPD5ikNlJuZDq0Qw0SobC6cNVaKuuN1QKus8xxDy8oB9VgPFLi7gRvhJKQ9TjM9a3bmLf83xh7WhvKIHdhll+iyWh3ZST50NIqW8TcWGABX5T2duKuktJn9jqMvjHxnkWnuZzxYqD0nEW2Tr7ltxWV5BGwADS0g7P7KT0Yioa9tUGCD2jEPOQlnLN5ZNKAQwolSHVQuDJxoviHYa+g9ArdF8J2KoKP9E1VKt+zR1uJw317xs/s+SkbElvKK3/qWtGc3KaDFfm0I+Q3/GuUQigbCXpT8Q5m3Z5eKRjo0cQXsiaFb1dHiX3THG/H5JEja6MIH9N1GW3iCpqxRB6MnrHHkRG6PiYb78pTl+2tz2joZxo+XR9A0xE5cnQhXX65QPmN9y8ITJmMheIGnCa2VQK8E9lLhAYXghqe8CkbNz3w3NA3i5v78PaEuQVRAkR0gmi8V1TqrghEBvyPYeBWcC/VwnF0PRvEvg2TGe/qkOW06nvHHSBlAuAuY9CpTJWifXupRgsx165u3MYJyW+hYb50h9ivfkYBTj9py1FR+5wI5iCexBNYZnp4Ex+JLOCGNqcwms/tCaLjAmbMp7w++fMEM3rwWiuKXnLlHMpVSdrXJ1pPFoBdA/wsujwfRb3wcg8j+K/mzIyY0ihQEyMjv8Dy336UoZHPV3TmDHuoCmgLqsTvW4mq0qwhX1b+eSZKqZuuyntqX7I/pHJbkVWFxlOFHlQV+VclmNbD96hGTaTmjwqLohAz4DZzVB2Zys16E2Dt3wvW6Tt/uMLhgoaborsB09ms4H7gPVeSh4K+cHMNpd2qmGVE/vpNUJDxjrCNnY5gLbCW+pMSyKV1bOlRhL0fDT+FA0teeWNHik37QvwXC3YP9xbj2ralBqXQJXjP+W/rzzw
 RufYUWV1
 AyE281m6JqMhobqHjCqCt6WnGhEvxm0XUmjncFvf0ottNODiF535JWWN8YTWd1uMS8oDRuFNeXg4sK0g8WHHl7ve8olu7rkDwzHA5uXNVWGs8GvTH9Zs2clfPlNhB1wgjVVqaVSpEdZL6hamTAuGH/f9nrc5o4XgvS5k+g4LfD0y7/dbDCoJJTiw0W7PMXffJDiA114ufvrGN79tNza3THhJ/7/E6laJ+hTBgmq9GfwAJ9hIV6PNnWJ2MiDISjkAYy2RjTwLqraSVBQIyqLEomF1+K9rsUha94v9khMuoChdgJ4ktjBkSdR93rTxFbAVopS6otQ/KHoeIY9yYKdV01XjwnZ1R1re4HoBPKcJxeu8GpJ8jmhyhUxKNIcxXG5Hv3GeTTCmGuIbS/Ub+YpJ0BovkQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 16:26, Carlos Llamas wrote:
> Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
> checks") moved the sanity check for vrm->new_addr from mremap_to() to
> check_mremap_params().
> 
> However, this caused a regression as vrm->new_addr is now checked even
> when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
> case, vrm->new_addr can be garbage and create unexpected failures.
> 
> Fix this by moving the new_addr check after the vrm_implies_new_addr()
> guard. This ensures that the new_addr is only checked when the user has
> specified one explicitly.
> 
> Cc: stable@vger.kernel.org

Not necessary, but for mm-hotfixes please, Andrew.

> Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> v2:
>  - split out vrm->new_len into individual checks
>  - cc stable, collect tags
> 
> v1:
> https://lore.kernel.org/all/20250828032653.521314-1-cmllamas@google.com/
> 
>  mm/mremap.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e618a706aff5..35de0a7b910e 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1774,15 +1774,18 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
>  	if (!vrm->new_len)
>  		return -EINVAL;
>  
> -	/* Is the new length or address silly? */
> -	if (vrm->new_len > TASK_SIZE ||
> -	    vrm->new_addr > TASK_SIZE - vrm->new_len)
> +	/* Is the new length silly? */
> +	if (vrm->new_len > TASK_SIZE)
>  		return -EINVAL;
>  
>  	/* Remainder of checks are for cases with specific new_addr. */
>  	if (!vrm_implies_new_addr(vrm))
>  		return 0;
>  
> +	/* Is the new address silly? */
> +	if (vrm->new_addr > TASK_SIZE - vrm->new_len)
> +		return -EINVAL;
> +
>  	/* The new address must be page-aligned. */
>  	if (offset_in_page(vrm->new_addr))
>  		return -EINVAL;


