Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36542CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AFAE8E000E; Mon, 10 Nov 2025 03:53:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DFE8E0002; Mon, 10 Nov 2025 03:53:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C3E8E000E; Mon, 10 Nov 2025 03:53:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60C3A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:53:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18CDE4CAAD
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:53:42 +0000 (UTC)
X-FDA: 84094084284.23.73C0DA9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9FC5B4000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:53:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HeaEcVZW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BMX9bJVA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dh0EguRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S1w9JFlP;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762764820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhVGXXl82HA74C7MBfa4J8WEYKtUPGSE84qDiektqPs=;
	b=5u0gWZGg5a7pW+7fx4wWPkhq5ic81ClKx+36CrYkx6dlhD6S6tlDcgmONt2CtU8JfIC2al
	cUvkt/f9nZA/t0+80JIyua97PZZaYPv+CcXDzTMcnDzYGhLBfrLzSJdZHsPEElktbjdCJ4
	Go/4zs8Va7baj/U2SlNVXXFx5vtyMQY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HeaEcVZW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BMX9bJVA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dh0EguRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S1w9JFlP;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762764820; a=rsa-sha256;
	cv=none;
	b=ctDfjX/S+R4jwqfb28QeWjEOBClEnziZRKkglqxkj+K9jWwvaECyBHCuBMdY0ouyxoOXxE
	NONY/ffNLNBWrcF8QBz2IJJmuuaoT7pZ3xfG5JSYIUuBRWOUiHIuQGnnSZwPSpoOUfflnp
	+/iq2lPvshqd5PC7zfxJM9ti+2IT0kI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8E9F1F399;
	Mon, 10 Nov 2025 08:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762764818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KhVGXXl82HA74C7MBfa4J8WEYKtUPGSE84qDiektqPs=;
	b=HeaEcVZWPmhyP07OZdkA1LCc8+GyEblamiy30/X92AvCU37Qdi5HjumXVJw1tzqA5y1khK
	4UrRmuFiZAlvSdpxL3oZLWzYAGJGBm3TyX2BY5Kq1TN2AWxk4KZCci4aIbo00VzAeSqlb5
	Dz+4yiEmAp76qmwJJZFLTOoC6XuFDcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762764818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KhVGXXl82HA74C7MBfa4J8WEYKtUPGSE84qDiektqPs=;
	b=BMX9bJVAXlf80cwNa2Me8Y8oIGZkVGa375flp5UMmdp28uPmX4OOQtc6fFpGlW4L20DXT5
	BM+rPP2YTkGh6fCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762764817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KhVGXXl82HA74C7MBfa4J8WEYKtUPGSE84qDiektqPs=;
	b=Dh0EguRoSSDR9MGAZeI2PxlGkax2JYYakxzunVGBJh2OsvD5KpaJ9NDLLswvkJJ9UyvlR5
	7u+9P+lKUfncy2QJwHSy4lcnnA5oQofh76KpmiRpAlMPlvhnA8+jENRsO2Ahg81HlF4InQ
	VQ5Mz0TE0gSAGQU/owSzPqwR3r0Nfgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762764817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KhVGXXl82HA74C7MBfa4J8WEYKtUPGSE84qDiektqPs=;
	b=S1w9JFlPp6jK++XeYlLt4YGq4rDiDKZeSsNb4DyUfRkwNG6Fz2NBXLQ13XLMirNna82yeL
	toDE9K8GdZxDv6AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADB5013BCB;
	Mon, 10 Nov 2025 08:53:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2oJ+KBGoEWlFRwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 10 Nov 2025 08:53:37 +0000
Message-ID: <cff1f137-06dd-4045-942a-b5e56a63f47d@suse.cz>
Date: Mon, 10 Nov 2025 09:53:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: vmstat: correct the comment above
 preempt_disable_nested()
Content-Language: en-US
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <20251110084437.46701-1-qi.zheng@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251110084437.46701-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9FC5B4000E
X-Stat-Signature: fk7atjm4wm5j8j1g91ixdro839uunkc9
X-Rspam-User: 
X-HE-Tag: 1762764819-399679
X-HE-Meta: U2FsdGVkX19dZalv+u7M1TxEnrew4HVRHiXwvOfkttcacvYDWs9vr3P9wy/+xq8iCCkAFwBjTXM1FnKMiY8PYXHenHL/0jQhJ7Xc589SEhhB4Rqtfz2yT/Z0mgpYNMNkLcZyWeMI2raCuwRTrWdnlMLyOx0xcVb6NrqQr+8u7fYW4Pc0zDgpd+f+xjM1t869NZ4AFtFziCk6GksxdvP6CmPApFoCeZmTRCIA4jznlh3VMdza7hhNQptPXCbYe/tvb1GaB/zcB4HOaPY+twGDyfFzfertEk6Qpg0oBdk7y52HXTfo/JtN4MdvMfIsVVLL2i7LYCCSRip+onv5YUmxeLRJDjOub6lFG7D/+wgWj9SXNzJYt9e9hbiUGOXUTOydTxoKlGdVqZe2FyRsRN4TLpPwNzOjuOTAezeQDRqpPuUYrdIm1VKWxZ6FqCompqtFWb2kFSKdnBLx6A3JgmTXes7/IHCQS3kl387g3pzu0ZA/zrTqcw8wF8Muw2Yz2n9LYx5hBnf6JHPIVqLLh1z+91FLvVB5t5tuXI8wKWybbq7ebuL+zgTrhYch+YI8uAaoxDUuXCDvHZ6wVeTeNm9khsRDnFGPcPImFqbu4gYvr+ya1zRiY69dNu/29Vrd46Z0AfJYIxrjJ9ir3atZ+Q9moIqc6QebdTSqV0XUunBDV6Zujn6aB2/p+DCtLvBSZHv1XveSUS0h1fYwD2ARoujRaHsTDDFSVUTVj6UNIZB6oJ+676yn0ZlMgMsjykQ6vF0Ktjy4hKxWCabnET9W/npsf4yyLYJrp3q6P4r6Ktmd/DYwmXX1Ln6ZeKRsNZkq4WnmK6Z6sTmWPBFghJo75gtehvVE2Ls5wyiyOLqGan2gu5C8IZAeuRvYb5Ystetgom+Fq5/WycUgaKDDvFO9jeCxEtEWVp+1B71MVWUpGfV1RRcmkYaNyVMSgpLP52AdKITTiFVPOCPRTVGZbQgz7q4
 EDAC/rsq
 ADLgxv1wzYr407d4X9TL9wyIFwdn1RYui4KkkOYKhuBX/5461v48rjXk+Duo9BAhnIuLp0iPIODFBijyKoXCvQwbhDCzUHQySAqLWKn9pc4jUmPknnd+wU4zsY7ePTlYS1J3OnbC/XHgbI42HIfbTCe0//BNTO/T40Lfytf54qMfCmR09V8hRf4HEuGpCJz/oanwyCETC+Wkj88DEUNFr28ToJ8ELE9WaIHfaaOmCvqaLI5r/t9dnaWFXtftdMhYpl728aXPJkqDTUplKk61gBsEDplZAd4VXsOfFqbbnW2DCFg223y+63h0h/4H0rdzbFEEtI9MM91PiQ76oFeGnkpCPqYZyYy5thmd/SSLnFbHSsyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 09:44, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The comment explaining why these parts use preempt_disable_nested() is in
> __mod_zone_page_state(), not in __mod_node_page_state(), so we should see
> __mod_zone_page_state(). Just correct it.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/vmstat.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index b53b07aa29e81..65de88cdf40e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -392,7 +392,7 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  		delta >>= PAGE_SHIFT;
>  	}
>  
> -	/* See __mod_node_page_state */
> +	/* See __mod_zone_page_state() */
>  	preempt_disable_nested();
>  
>  	x = delta + __this_cpu_read(*p);
> @@ -438,7 +438,7 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
>  	s8 __percpu *p = pcp->vm_stat_diff + item;
>  	s8 v, t;
>  
> -	/* See __mod_node_page_state */
> +	/* See __mod_zone_page_state() */
>  	preempt_disable_nested();
>  
>  	v = __this_cpu_inc_return(*p);
> @@ -461,7 +461,7 @@ void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>  
>  	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
>  
> -	/* See __mod_node_page_state */
> +	/* See __mod_zone_page_state() */
>  	preempt_disable_nested();
>  
>  	v = __this_cpu_inc_return(*p);
> @@ -494,7 +494,7 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
>  	s8 __percpu *p = pcp->vm_stat_diff + item;
>  	s8 v, t;
>  
> -	/* See __mod_node_page_state */
> +	/* See __mod_zone_page_state() */
>  	preempt_disable_nested();
>  
>  	v = __this_cpu_dec_return(*p);
> @@ -517,7 +517,7 @@ void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
>  
>  	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
>  
> -	/* See __mod_node_page_state */
> +	/* See __mod_zone_page_state() */
>  	preempt_disable_nested();
>  
>  	v = __this_cpu_dec_return(*p);


