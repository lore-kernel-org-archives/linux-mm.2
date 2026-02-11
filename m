Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB3FEA812E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1AE76B0005; Wed, 11 Feb 2026 05:11:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EE46B0089; Wed, 11 Feb 2026 05:11:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C4D6B008A; Wed, 11 Feb 2026 05:11:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82A9C6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:11:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16504160310
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:11:36 +0000 (UTC)
X-FDA: 84431758992.20.6EA4D2A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9177D1A000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:11:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0ELd9rp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3kfR7uDB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0ELd9rp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3kfR7uDB;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770804694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nruCXAx74WveJM2K/8+k0Dm+0X0usQHifZgTPdJV990=;
	b=M5EPSNItSf+hLzqHO90aAJFNGY09oQ01AL+/Sw/gF4DyuNoCYe2SG6TMlK262sOLyBupp2
	SUQYBmBj6TyLNh0kh7poE4mhtshZKOZaKnxvtNBpUvR7+BLxuIpoOBf2ufVcBCKJ1PKcHQ
	GZw15qW0EpFRYHcMPHMOnjmGvhg9Gdg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0ELd9rp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3kfR7uDB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T0ELd9rp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3kfR7uDB;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770804694; a=rsa-sha256;
	cv=none;
	b=SNB31CHJPFtgHSvSew9IbJnwLIlYUwZMSkFid49wAeqm69C7RqPH0ZUUeYTk8fF7fL3gKy
	DPX2yHZXfyMRBG03sDGzmYuVt1mkH/VtFIJt6CRCJ3Gre+Zefo+V7d97iLglxGvIpPgIA5
	U2xRH+w5SzCps5tzMv1QoQbM5IKBVag=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AEC213E714;
	Wed, 11 Feb 2026 10:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770804691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nruCXAx74WveJM2K/8+k0Dm+0X0usQHifZgTPdJV990=;
	b=T0ELd9rp3GeVuj4TLdR3dr/hNb0Cika9yzBgRs0FhiSWSc1MqQAnL97RrY4vOwPUe2vk7I
	i8LRVFFyq//INL2tUz0svYT+yDeB8UMWTAXYhOJeUmKub3ubxVRg0j+o4+X5aZdFMrFsx2
	RsZJHaYUr9Yo2a31l+htisFCRymCH50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770804691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nruCXAx74WveJM2K/8+k0Dm+0X0usQHifZgTPdJV990=;
	b=3kfR7uDB3xl6HUy45/FpCoJY0wRcFUNW+QVuq26A6tfrURWVGS+PtqpD5CklnjcKYrVyci
	o6e6rzNfZUyDu7Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770804691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nruCXAx74WveJM2K/8+k0Dm+0X0usQHifZgTPdJV990=;
	b=T0ELd9rp3GeVuj4TLdR3dr/hNb0Cika9yzBgRs0FhiSWSc1MqQAnL97RrY4vOwPUe2vk7I
	i8LRVFFyq//INL2tUz0svYT+yDeB8UMWTAXYhOJeUmKub3ubxVRg0j+o4+X5aZdFMrFsx2
	RsZJHaYUr9Yo2a31l+htisFCRymCH50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770804691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nruCXAx74WveJM2K/8+k0Dm+0X0usQHifZgTPdJV990=;
	b=3kfR7uDB3xl6HUy45/FpCoJY0wRcFUNW+QVuq26A6tfrURWVGS+PtqpD5CklnjcKYrVyci
	o6e6rzNfZUyDu7Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3CBE93EA62;
	Wed, 11 Feb 2026 10:11:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jH8IDtNVjGkKbQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 11 Feb 2026 10:11:31 +0000
Message-ID: <183f1ce7-d45f-49cf-8dec-570a7e11dc9f@suse.cz>
Date: Wed, 11 Feb 2026 11:11:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: introduce a new page type for page pool in page
 type
Content-Language: en-US
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20260210114712.55072-1-byungchul@sk.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260210114712.55072-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 8rdrfuyjja5qhxyipyxqtf3ii11mso4x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9177D1A000D
X-HE-Tag: 1770804693-282807
X-HE-Meta: U2FsdGVkX1+09g32OeqYf0j7tIPVvPpsRGS/fNj+G2Fi6je3iOj7iTcESaKWuMp1FCvIw48oIljOlCNXddPhQaVtbCNr27W9lSExf7uHknIjFvahYKO0onDayv78c//pGo8Iw/v8j9yN4qa9OEnEmiWbZeeZRZjDN0J89+dS/IyUyqqBgpQp2XjJ4mYWDz3gJ59veX8WYgYrxi7I1qF6aXg8kWyOarJT9Ft+4qgTN5ePDn5jyQ/NSxyitFwKw7uupyzQuTJs/08GzEla3px+geFkl/riUcIhRJ0+nsJGlBu+TMkFeQyVrjUIicdgp4fQJCp1qEs0NJ5XQ7Je94RpQS6nv+ITtHWyWT+foFDbhoOfeeGsimzl9D3bLs0ckk6beOYwj1Bqs8wH6XUvoXElUVK8P0IMXz8kG6L287m10p9c8cCnBj/mJ1HENa1IXtU1gxX5c/o9piUlHUiFXZA4ldDVnjgkKnHaWtvjRQOzvkGX+yotbJT6qHphY22YbTwWaCGIwd2ewun27kypRIv65O8Hn8IdwNYmwOhM1dggTJHwpHMklfzzHhQRvWscEH33k09O6D+AoiINt+hjL7AC2nptfau7Ef4ctbVWsM7sSgtHbb2lvUU/vU8trGf44tgK33FTVyQX5jWcVqgLiQDfIC4ai9xkdKY1WiT0Qg1jUeDKBKCutcCEvNnTLI338FDy9dXsBTUO2WlcYPQdrknd82muwni77Ee2dbFksEUcRoXU8mXbe0w4ZpqkcRo6iLT6n1GuBiS6fDK/QsPc+WxRqwEM83quQbSWPCkLl8pG/Grdd28rAA4s6hgHOQ7+xi9o5/O1Kz43Y7Qi2oULnkvTQWat45DCxXWoo9ccyHWNun/xOkHBvX6EOegJ4f1ySjT+1rLeFf/b+5WxVCHKHfO64Z9zPXMpbhMy5wzJuoGPdrF2NGYQekleaXcoqafqXsRygFX8noYcG9bRMIrD4Co
 ABvkykVx
 hHkSWLprIIMq1QFpp7nnMG0BbhqsWrOpbqIXvbgutYQvVhBdfntpjKpNo6cXIO3/J98uK+lkY3kTwusWoeyEQim6y8c1TPGBQBCGYTtLSa8NyB5Z7tZZBdAfHGTTQuMha9xZZfE33uUnwJQxlalruhEuHLYhXfvcafJulvAML3aMj/bYS1KiIoqIbLuoXX8OTLKX+0NLXZgNHzCjgHfN2g6b2iOn3NNlIyVveAGD550UNpZQVyvapSPkcqYrviGCPt27ZG2TfnCJrlEWkUfKBseQnPoeZ0JJ/VnRJo6MPziY9IvJzFaIPDfGY45SNXyYrhoRyxmU3Ad997aB0RV6a83RyDrUfM5Sz8sYLbFA/kb5H7rtctlGoUAcu5FLPRK86o7gdE3LO+OzWpHJMeknp4sm3DsNH+XmfVX0lztmuLjYssLN5/Ijg3mOMA15p8WELoFDPXbQi47Zy+AJ5D6N4ceL2nZkrDAd9/z3mdaRwuE87WQBJ32qnDxSpZDKlGi9wbMMUXfY2BRGDnN3oTESztM51yd+mjxctK4+thO1e3w89vOhv3T4zuvxTbWgD4/ov9DU4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 12:47, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.
> 
> This work was inspired by the following link:
> 
>   https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on the free path.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> The following 'Acked-by's were given only for mm part:
> 
>   Acked-by: David Hildenbrand <david@redhat.com>
>   Acked-by: Zi Yan <ziy@nvidia.com>

Also for the mm parts:

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks.

