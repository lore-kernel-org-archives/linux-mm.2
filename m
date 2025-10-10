Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586D0CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 12:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6608E000A; Fri, 10 Oct 2025 08:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD888E0003; Fri, 10 Oct 2025 08:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC9B8E000A; Fri, 10 Oct 2025 08:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 879448E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:48:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 377B01602CD
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:48:50 +0000 (UTC)
X-FDA: 83982184020.15.389CE17
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id E64D3A0007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:48:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cw+mD3lQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X7LVzkzU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cw+mD3lQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X7LVzkzU;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760100528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DWhJpAvXNt4nGU+zHS2kg0wKNnrOVaGhcDqNB9SnGw=;
	b=aceUfYBT4IIUpmXdEKqhU/gjYGngPVuaMuO8id9IRZsxp/QeCSARQjrvRduEQwhnLDNzXv
	lEozqfVJs+UAPGL75reYzFWGTl4phSea4Nr/TVtMGKn/XEK84gJfj2ipOsZdaUVEEdaq0Z
	JysPDao3lXwEbvTMzkVtWH32Qkk6260=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760100528; a=rsa-sha256;
	cv=none;
	b=HFpZ4BfJZ/btADJBZaG0ePRZsSmiT0caOyeKzFwBpYvV26OYTQ5xRc7lWo3SEbJo28BkQh
	S5IN2m+eIxox1uajncUYDTdnjjPKnLh+nI0jA3emYKjmJErcMwf0eqDF15f2oQAVmKEvtC
	3AjaCEvY9NUmiuc/QpCuEouPP9Z/Gvk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cw+mD3lQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X7LVzkzU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cw+mD3lQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X7LVzkzU;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C14C21286;
	Fri, 10 Oct 2025 12:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760100526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2DWhJpAvXNt4nGU+zHS2kg0wKNnrOVaGhcDqNB9SnGw=;
	b=Cw+mD3lQSfjtcU67FOtqzm5CefE22ZmxqJmO4CNuHknEKRL9PVnsL2xXPHc8z6CDU/imkF
	St1Dzjoxn+nh+nHIbVoWbeTCxVNszJI5Sm6px/YOffWq6gvBgH3YYbMFgk1sxukB8uBkqU
	rw/8DQwIs482W5EBay7Wd5oGn3Q/OWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760100526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2DWhJpAvXNt4nGU+zHS2kg0wKNnrOVaGhcDqNB9SnGw=;
	b=X7LVzkzUlRR5FaQmTI+inzg/5S0RNFQviraVnjRA/Vb436LZfNyajmiwNEofTAeeK4OxII
	zLpVFDD9RgjpRGCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760100526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2DWhJpAvXNt4nGU+zHS2kg0wKNnrOVaGhcDqNB9SnGw=;
	b=Cw+mD3lQSfjtcU67FOtqzm5CefE22ZmxqJmO4CNuHknEKRL9PVnsL2xXPHc8z6CDU/imkF
	St1Dzjoxn+nh+nHIbVoWbeTCxVNszJI5Sm6px/YOffWq6gvBgH3YYbMFgk1sxukB8uBkqU
	rw/8DQwIs482W5EBay7Wd5oGn3Q/OWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760100526;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2DWhJpAvXNt4nGU+zHS2kg0wKNnrOVaGhcDqNB9SnGw=;
	b=X7LVzkzUlRR5FaQmTI+inzg/5S0RNFQviraVnjRA/Vb436LZfNyajmiwNEofTAeeK4OxII
	zLpVFDD9RgjpRGCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 428AE13A40;
	Fri, 10 Oct 2025 12:48:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XkbGD64A6WgeNwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 10 Oct 2025 12:48:46 +0000
Message-ID: <63bbcf0d-5a02-4eba-8fc1-680eeb4e09cb@suse.cz>
Date: Fri, 10 Oct 2025 14:48:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm/page_alloc: Batch page freeing in
 decay_pcp_high
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Kiryl Shutsemau <kirill@shutemov.name>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
 <20251002204636.4016712-3-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251002204636.4016712-3-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E64D3A0007
X-Rspamd-Server: rspam02
X-Stat-Signature: g59wnar1mtmr6um6behgbryhtpeiauta
X-HE-Tag: 1760100527-867627
X-HE-Meta: U2FsdGVkX1/8Tk3qo9vh60jkeDWvbzn/qYWTRCZPF6PNExHxj0vXqvJu3Ae7Pq1Oi03b7k7nRmogyLjZgqocOKfBZlnFaCHljWzqmy0N2TxCZ9Pjlz3WhNiDrNeL8BAu+HusgCNXoGAhEh83Q3fDr2l4JmAse0ElxfY8kXUpoCb7STM/bSGbM5nrMmdk3FGhBAliusyZfhzZ4Y/lDoLhnlSLQoz17tT9R3jLzV4Os+MUBP6ybZeZjIpk1NzrlXxIz7lFXXQ02jeWIPO2GgmsQMIausLObbb2spF2od1/IDljkRySArcSa5u4c13kUypeQLBqBERmi4UwKk2HIrqZ4bEQ7e5Gl8bMfmcRU3K1ygGbCagYA6vMtElIYz48wXLp7JgzHCOU2+s/egpf905+YzBuFbojDWRLhnOEEAe8wVpW7F6MAab1XHek+6bqVGB5Tq644NpPXwL7VgKom5psmyyzHMQO6OHMx4Anw5qrI9sSYlxoVprehnN8GVlBAfHssdL41wjMEyENsEPXSq9u/U0AZtZpmP9wkc3DnLF/W7DJOdhcuWCk2RA9KD+ni70Gqqv6uh/4PjnlIBeP4FHjYTbww197BOdc/GHKTrS1/1sk+8xx1oKv/5qmFFpymKRP0hcdZ1TcniCrocDxt1udstbYTVoqJl8Fmd7GBVeJioKj7MJjxXiMJw2YGUhls8K7H9wfm926GCg0laKMJaeEVV9Bxp4aAFLbiTvBDjhrskyDIf9E9WJ9WM4+D41vpI7P0JDdkX7agAuAUiSr2gcuEhUqdWeIYseaWOAWOGTdwSxr+O9HGO/Ib6kaZJ7dKBBmRLT1L8brL3Iteo7X0QEpxAMUOwCg730OQYnpjFk7wmlhRD0AfRHA8q8kMHZAsjGqieuoXj4JqDLac/7xww+ySYlU13hozacWtuSEIF0OG2oI022J/1B+fFfNFsIcc3P8dncVEQbLMpOq+9IOyzC
 gnV4SkYM
 xosP/lRw+viMI02A4lCGM9PVyarE35cKBgJbe3ooZQoW+dR/Mis70Rogo/N811qrULdE5xtPomPv+dM7JobqO4tKy0pJKvaogWAyKs8N5eGFmQ8ZT7YIQIUkRPvDy2I0X2/kaT6AlpNBN95bYAkgMh/0PcPGz6TINOOtlw8tqiAHp4FmWvgbSwfBKrM+xd2fxEQgVy+OOyE4P+PMux1C88gkugWtGKrEbIABCz0NM7Cc8iGQ/ejfjwvr0idQuWU8N17SpuLQsIT0NyJnJU5oc+y39CjMj1clNujsr9as/KCIfefpI8cbSiqbeOV4Jjx2FPgtsplUTMhESEgOt5uOzzN6F0TOpQbWrDDpO0KHbV3ESRZEFzASsFNOONoteLrKqx33WWKmjCGo/pHD7gjFGW7DRWd1awrs24wpgEddiVRrE8Uu44SelCiI4MVchRznRaPVJeZHQZIzQCUW8uKmUwwwA44RdyTQa7RFoOZzDFqrGNHHYJ9xEeoZZcqkYvsqvfOq4IX3ehkjt5CMZgtU0Wvpj36dF+4QqIcWuLrYFs7uQXkzC4lUn+6QdpO+kmZywar9A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 22:46, Joshua Hahn wrote:
> It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot.
> When this happens, we should perform batching to ensure that
> free_pcppages_bulk isn't called with too many pages to free at once and
> starve out other threads that need the pcp lock.

... or the zone lock.

> Since we are still only freeing the difference between the initial
> pcp->count and pcp->high values, there should be no change to how many
> pages are freed.
> 
> Suggested-by: Chris Mason <clm@fb.com>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b9fc357d2d48..f525f197c5fd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2559,7 +2559,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>   */
>  bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
>  {
> -	int high_min, to_drain, batch;
> +	int high_min, to_drain, to_drain_batched, batch;
>  	bool todo = false;
>  
>  	high_min = READ_ONCE(pcp->high_min);
> @@ -2577,11 +2577,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
>  	}
>  
>  	to_drain = pcp->count - pcp->high;
> -	if (to_drain > 0) {
> +	while (to_drain > 0) {
> +		to_drain_batched = min(to_drain, batch);
>  		spin_lock(&pcp->lock);
> -		free_pcppages_bulk(zone, to_drain, pcp, 0);
> +		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
>  		spin_unlock(&pcp->lock);
>  		todo = true;
> +
> +		to_drain -= to_drain_batched;
>  	}
>  
>  	return todo;


