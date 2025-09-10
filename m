Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF4ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8AC28E0001; Wed, 10 Sep 2025 02:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62B06B0011; Wed, 10 Sep 2025 02:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9787E8E0001; Wed, 10 Sep 2025 02:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85DA36B000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 143F1C061E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:46:27 +0000 (UTC)
X-FDA: 83872406814.11.4268F40
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id B4E2240002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:46:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=go5DBxfn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yrjWjHnm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QViWeyT9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1wRNwhZZ;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757486784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0SWlXWK9IoyrtqaxCrVuElAesP0OmdLAfgcptXBJGo=;
	b=yhizGCoC7Kcz8vXznPWfwVTOC+c7ZRWHp/gua820oYY+YhaejOH11Q2ufCMgh5DytU2L6k
	2AwiK9DLWA7nhzAwtUWR1Uqx7YZ5kjgU3UNM28g/cqN+1sNbB4G+evoBMegbu26ddIkzmA
	crmM94CoVRYLuIhhMtSRCzUoccDQhmc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=go5DBxfn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yrjWjHnm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QViWeyT9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1wRNwhZZ;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757486784; a=rsa-sha256;
	cv=none;
	b=QVZ+M6nzcj4nUrJ0D4TQDXjiuSd2JYcXtoWn4UhWPlLJSppZfOcr2y6sw0sGymG4rAuUdF
	MEJPus8Ka1x2BnYiSXrdUv4KxIyVe3LVeKX8jX2TGYjLizMIYKiRUs6uoiznJKJK+JJbwE
	wGQkFzyDxboA95zKWvlwHzZBoCQ70w8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE229336D2;
	Wed, 10 Sep 2025 06:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757486782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p0SWlXWK9IoyrtqaxCrVuElAesP0OmdLAfgcptXBJGo=;
	b=go5DBxfnUciK8DNc6Kw+BHvxTCNLZhVXWl769n8CgfPDb3GK/Ly9TKNIKxbz9wsBO2avr/
	nZf/VQkz6XR0Tx3fX0FrESjbiEjAjuUG+XDomkY5V16WITFzdHnJVySLP5RLCsMuMM3YI3
	z4pIuSqkvKyxbR7MJDnoMFzjZgAxcDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757486782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p0SWlXWK9IoyrtqaxCrVuElAesP0OmdLAfgcptXBJGo=;
	b=yrjWjHnmXioONkhUoxK4mVQJHjajK+6GUCKK63hqPUxIBYj3LclaSe2gfF8j0izaHqMRgu
	WSM5VEaOj2ThHBCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757486781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p0SWlXWK9IoyrtqaxCrVuElAesP0OmdLAfgcptXBJGo=;
	b=QViWeyT9DgvWUvcT4QsDQk/0YxRq22xm5Gr2ajBWLnbDlzkbAnrZegT0wixoAw4Pj3gj0k
	3ImmPBEeHbtWsvNaaC2JdlMLMDxy/KHQqT1pl75TlPb8IieTdAMQf+P0I6l9JZGAF2veuZ
	inBTrOyCVEE5499Bxh6UDP/bX2omajw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757486781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p0SWlXWK9IoyrtqaxCrVuElAesP0OmdLAfgcptXBJGo=;
	b=1wRNwhZZBp7geP79OL2o/1+FYiwDMkHHacc2fu7a8KIoIe7PS5zTxGifoghAMR41z0DiOS
	kD+La3IIsPIxcEDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5FFB13301;
	Wed, 10 Sep 2025 06:46:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0jAILL0ewWhrDQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 06:46:21 +0000
Message-ID: <f8127c0c-9de5-4430-ade4-45df78862d28@suse.cz>
Date: Wed, 10 Sep 2025 08:46:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: Refactor note_cmpxchg_failure for better
 readability
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, Harry Yoo <harry.yoo@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250909013307.1093853-1-ye.liu@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250909013307.1093853-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: ag56kce64rs7181nxq3ddtocgmeaq4id
X-Rspam-User: 
X-Rspamd-Queue-Id: B4E2240002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757486783-424047
X-HE-Meta: U2FsdGVkX19icUqP56UiZ8mTBgA79Ul96WO9Nv1MqZYWSHgqHLfNJeR51p18ZIhBIfJM9W2TsnJ80o+RkR4GG3iClRERNUFf9TbAzdA+RnAI+JUDbzbA9yFh9b0D4cVjdL5ti+lCGQVY0pSub39WEqanZF6VNJfSTdQm+KUOaNDsQzKliF0w6q8SWHbt+i7jJpR5n6ix77QOd/6JR4GKfoFp7w7IlvZ6fhKnOvnhesFR/+wYQ5wIERHNxUUlIZaXacmBxrKRyGmRG6qvtuxeBNjbfK4+lvwGGbHbDnk6kMPPMhRS6gHgZL5MMDglopxHMzhG6FbQ31FLyJPGuEqEsfbJoKnrWx/s9WIJqL4gN7Fh4qdst2dunPkvDkgc7IWHSjhnsq+2YErwxDZsCJM4vlI962tQy/mpBOpA+9yPgG52M5FxY/gV4Kqf9kEAGov24EZxvV/Abw3qIc8zmDLtr+QVSHeYzc4BV9BUO2273CXd6XhVG0PP1xYbmCUXn0g/ZdahfToxveuBFU/Xg+BuQVkfWfy2r+sibx+pe3ud3RLpNohpgQUSPowWsXo2wQsQnQ8FAuFt4LSRwHMD6Kq6IIbQ6WFFqh8+D3GRpU1omgTHhYLY7RelxgFAeJYEyRWzX8WBUuOaxFd3PRrXB7iweFo1Ep+LgsidMkRRJ26MHqQc9mewBPO8P+XLJiUZ1UMqLRwI6PvOg9hfoAsYiXazSjpuAOU/zjAyQzR76t/lbAh4EdVGH9Gm8lPoC6YoBjDQ/RVLmILo+zXlTcctnePjECkra+6ol3PNeGMdjXeia7lEKbOR4cn0oRl4wyn2vyGGWvNu4jJetcmWW75bXiDWlftBtAwzT9iuVYt3lxeDUUQkaQZAFe8lhpKd2ff305HYIg9VMrQHgFODXOX9wezq2LfinkuvEU7hozPIeZREieLEc28oTyDT/jOvil3lAEILisxnKqxc3jfDmCpiQqN
 wOfAlAUg
 yU8opHOlaVku5+86cQzMbApw2i/C4SnGLxxL0Lcsremzz6zNk98/FdTE9+1O7rAkpH2loL351lt4+P+c+WsmUd289T3WZoEPG4JjGd72BEuLzGyB+4Cj9inMHw4PEi8FWm1ktMpgXqklQz5wmURL2ZPNea4CTrXeRgtfu9rlN2o4w9Z9MZnlC32Z1LjX7kO8ggi/lwSMwUF0qy/0RL+HkeHOrPkuILh9OPaPegHQXMNBlpk2t5pfPjJQ4AQbFCb0d1zCfjs71P/UWu7nYgvvp0lbSRU/sU2t7UCMybLI8OPXJ4b7iyXRHWKYyoAXJvtuxNgCeUVkhPOtneBAUBIBPYXACUxQk6EQx/dOCh1asnEETEtTX2f9ntdZuJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/25 03:33, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Use IS_ENABLED() and standard if-else to make the code clearer.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>

Thanks, added to slab/for-next

> 
> ---
> Changes in v3:
> - Add "---" in front of the change log.
> Changes in v2:
> - Insert newline after && as it's more than 80 columns.
> ---
>  mm/slub.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224..5711d6d29a3f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3064,18 +3064,17 @@ static inline void note_cmpxchg_failure(const char *n,
>  
>  	pr_info("%s %s: cmpxchg redo ", n, s->name);
>  
> -#ifdef CONFIG_PREEMPTION
> -	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
> +	if (IS_ENABLED(CONFIG_PREEMPTION) &&
> +	    tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
>  		pr_warn("due to cpu change %d -> %d\n",
>  			tid_to_cpu(tid), tid_to_cpu(actual_tid));
> -	else
> -#endif
> -	if (tid_to_event(tid) != tid_to_event(actual_tid))
> +	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
>  		pr_warn("due to cpu running other code. Event %ld->%ld\n",
>  			tid_to_event(tid), tid_to_event(actual_tid));
> -	else
> +	} else {
>  		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
>  			actual_tid, tid, next_tid(tid));
> +	}
>  #endif
>  	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
>  }


