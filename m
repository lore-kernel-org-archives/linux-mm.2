Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8516CCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39558E0008; Wed, 10 Sep 2025 10:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10658E0001; Wed, 10 Sep 2025 10:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFFB8E0008; Wed, 10 Sep 2025 10:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2BB8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:01:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4137BC0961
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:01:37 +0000 (UTC)
X-FDA: 83873503434.14.E839260
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 605F3180004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:01:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PMlOUSBh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3MkAMdbU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H9K59wOQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="prNzXBC/";
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757512894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zw0FMft16/nnVfQssoK6US7TJHuMCoRRfNpNnr6nf5I=;
	b=OuGYjHZe1vlxiIWidk61gzML+YWGuRDEb1u+/L62ahaR18EdJ0V6faV/wGl1KLWTrC+s/3
	7hWUADcWKOGbpx4EaUK66NziiIhEMrTxV16NSIxWdNy52GO7LD5gNiJZnc9ezduBhI2/fp
	+0vnHHO3qEl5MrcU4a7Nsb9eqxwZEqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757512894; a=rsa-sha256;
	cv=none;
	b=wve2SRXSxPm0WqJ6YxVz+lU8S5l6Z8IA1N7C/TzAMRITpYYHEBiKWklp18oxFI6emES0pk
	XIjY5G++7jrN6MZut10g4pGv6CUZdRAiBwzcsEnr+lBVFrw2nzehrcZBzHHlLW50eq7rOW
	Mn8+6xWn9gWiaQi3uLb+FtkqvqyNVmY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PMlOUSBh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3MkAMdbU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H9K59wOQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="prNzXBC/";
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 50FEF2067B;
	Wed, 10 Sep 2025 14:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757512890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zw0FMft16/nnVfQssoK6US7TJHuMCoRRfNpNnr6nf5I=;
	b=PMlOUSBhQhE/E3/Zm+9/+VzNCY5oAFij3jAWqVWE/GJafuQ0CftjXSaMm6Ww4X0G5TSWxi
	W4oQiTBHAtmDRWVyTaasS2w5moxlXK2a6umqHU+rr+PIKasvy9aZ3qT4fQzLy0znB3AZ0B
	SSccmBbzYx/2Gc2/tFTvTERFTYWqcdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757512890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zw0FMft16/nnVfQssoK6US7TJHuMCoRRfNpNnr6nf5I=;
	b=3MkAMdbUSN2ftCXIGcK7BZqL7m8TFcnXWGWPNK/tY+Z2kpuFKFNDcTWuPwK7F6XYzwzKAw
	0jXzHR/geWePxLCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757512889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zw0FMft16/nnVfQssoK6US7TJHuMCoRRfNpNnr6nf5I=;
	b=H9K59wOQfbiijknIpDkSJmBBxWv1KQDsytA3bheKYMPeaDcdb96a8PoZXKgronll5qHgxG
	hfMPNg0s6mFYeWalTs8tCPap1a41AUEdAEnz5mJB/3g5LgV9wJe8H40A4w7Ra7jSeJKyVs
	2uUHa13l65zptGqCxqb6JkRAvBcUqDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757512889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zw0FMft16/nnVfQssoK6US7TJHuMCoRRfNpNnr6nf5I=;
	b=prNzXBC/y5CAlHmID3fnW3TIImg25TbxQ/OqXYuRv1OuyRyI//uhU3h5P4K/YFthMOppdY
	ACi+RfrnYwsoXhBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3FBE013310;
	Wed, 10 Sep 2025 14:01:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vc0+D7mEwWiXGgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 14:01:29 +0000
Message-ID: <bc6aa6fe-84ac-40b3-81e8-4522300007d4@suse.cz>
Date: Wed, 10 Sep 2025 16:01:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/22] mm: Constify compound_order() and page_size()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@redhat.com>
References: <20250910115507.1991829-1-willy@infradead.org>
 <20250910115507.1991829-6-willy@infradead.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250910115507.1991829-6-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zu8fg4ynakw5k9dhztt5hgfedr9iriqx
X-Rspam-User: 
X-Rspamd-Queue-Id: 605F3180004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757512892-831177
X-HE-Meta: U2FsdGVkX1/fU18A2pue0Xjz6cEIwKoHzlYBnLFYnXDlgoyf58aVuwuxnZHvY2qFBB+kYCX/VdTTSKKxRu8xAg1F0yxU18s4c8CV2RRuHczpp+WOq4cB61Mk9vQjR0FXC564nEjzt4MtsdhWsmHv604+t6gsRZAT/Kb/mFPIn5ix83KNY7Gbjzn94z/raFCPEN1jNOXQndUXVskLQV4aawUYJr2hTqBU3sF06SJw5tjTwoNupZbzYkhrUx3f7BpXQT4Q2TtSPL+hL9yDKHVIC/Rh0ZSJXMwphxAAAonsh565NvixT1zAGeoQHvvjTWZhnIADEfalTYrp4u7DjlXuwykJFh4RZOX5nYL4wRub6d6RA0Ga8brgsQSK/OOctLAXaEQ+LICh9VRtxUNw1Rilbzvn8ksWzQGrzr8pxBk4epeQDPAWjpRuhX/8ZtAtRSvlGtd7yOnWaevlENamDOSXuvNo8VKtr9xb5UaSRAOTMmLPqhyB+FJdGITB99wHNaCfsEWqkq8flwDZWPP89tn4tNbm5jUNVKsuEagD3opBGY35fjIFo6G/1CUkBNeAePaIktUdeQKu+YYJWqHyqJjwqHTxbKboL09/Bz/BacT2VfjiKoSseMOhRozhcRbuUCUQlpeIVejDgijKJUWo1agW6x+AUw8sOkPmQt6tqKahYTSCQboxbLLh1DLmpKfd4B9BFmkA5RsmB5hcXvgsd6pqDGFCKWAZB+ZgEpbeu3I+PyOHQGGkbLW29g/xW1f6bQ9E3Kxr19Cpzk7w5O5Pn9Lmu/kwvTPhgEjhKqSDUxlVe8e/dhAxutVQMn+/TX+CrHLBgPBYXPqU7QXbNFOGFMmUfNr8DrM248s/i00DFnmpL581mAvOxIYMG2Q9yg+L/7Evyys0iVyUjTmz/7UBSYk+1oneXRxdfxGQwd5OaEThT3wNHEtCGJQ159k9QWDH1oZNUaBMK3FDqX9BwA0JXf5
 KiONUA+f
 wyWXhJoiewF8JpjPhtrtgxCPIuToVrF/QllttegV6tsxkjzLOBCg7hb3hfvRe/Zb8YFQJUl6xpFZfUeFaX+Q8Kzj+hrhxTwuGiF9gbAHG9gV92b0qrmkEtxCeynoUz6bZ/ZF7e7Dxir0PLlVe1Aj2ptbaSesnepAPFEycynOz1tgtk/22T3V8CDGb9n729fTuPTB6YTw/yCQr0cSRCNUNQoC3v3hMI7YFm2N2/HImCVq1sQuE16wbwo4HUPNphUKqoVV8n8VAQcFC6/aPrDFHKgUvTJiPj0UuhSFIFkTrljwP2JkqJjKa7AvIISmhiRsAMpZix41xlpUtmAg9S+u9lgfy5aV46itYJogLeicR5WA8ruUYAo+jOhMquzGGeF/0S2/PFcVNul5HbamQLHXJ2KBb/t6eQN8j+ICKnsNwUMaan+2buO0WrCIXQ2sPKgrGaObUc16JHlsmx+aN66XyCsKHJx4xgDOXvrKv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 13:54, Matthew Wilcox (Oracle) wrote:
> These functions do not modify their arguments.  Telling the compiler
> this may improve code generation, and allows us to pass const arguments
> from other functions.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/mm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a6bfa46937a8..38b3d7b06d01 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1036,9 +1036,9 @@ static inline long folio_large_nr_pages(const struct folio *folio)
>   * set before the order is initialised, or this may be a tail page.
>   * See compaction.c for some good examples.
>   */
> -static inline unsigned int compound_order(struct page *page)
> +static inline unsigned int compound_order(const struct page *page)
>  {
> -	struct folio *folio = (struct folio *)page;
> +	const struct folio *folio = (struct folio *)page;
>  
>  	if (!test_bit(PG_head, &folio->flags.f))
>  		return 0;
> @@ -1256,7 +1256,7 @@ int folio_mc_copy(struct folio *dst, struct folio *src);
>  unsigned long nr_free_buffer_pages(void);
>  
>  /* Returns the number of bytes in this potentially compound page. */
> -static inline unsigned long page_size(struct page *page)
> +static inline unsigned long page_size(const struct page *page)
>  {
>  	return PAGE_SIZE << compound_order(page);
>  }


