Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1ADED2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE566B0417; Tue, 20 Jan 2026 09:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5FC6B041C; Tue, 20 Jan 2026 09:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF38A6B041D; Tue, 20 Jan 2026 09:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB89C6B0417
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:01:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F1ACC2034
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:01:28 +0000 (UTC)
X-FDA: 84352504656.24.1A51899
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id B34BF140019
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:01:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF9TNIp7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2GxwD/W9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF9TNIp7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2GxwD/W9";
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WB/QAIhLT30gDx+iBsgOOPnda3Hx0tMddPYYIhfYYOA=;
	b=UKiE84HQuMiytMZkA0ZuHRh98qOiZZlHw/3Pk2xBhRebcI+A3CBNImXJiVcUAEaDUqwN6y
	9x+lT0hCkcQVYuWXxdLSFWAUx6zh4T1oUo5KTGsOBMz4PEh+wa+UqCLaAb3Su8w2aemCKi
	CSt2aYqS+pZJmif++ynWdZfW43JRGjc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF9TNIp7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2GxwD/W9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF9TNIp7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2GxwD/W9";
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917686; a=rsa-sha256;
	cv=none;
	b=N6dXCE6syi/r+iCnvZqzU6nBnOUtgV+u5ojD9BSzpACkzCQuBqvGhc7NIck7cyYLaIgZUq
	pVKylOPewoYLx3EjVliBVKuSxgInOxnA3iur+wIL/nnP49/BYo6GTxeF/f0YhJhM0lTLsT
	jx7OjKvnLOPr5pEQ1im6EIvG32TNUgA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CAF9337D0;
	Tue, 20 Jan 2026 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768917683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WB/QAIhLT30gDx+iBsgOOPnda3Hx0tMddPYYIhfYYOA=;
	b=QF9TNIp7cpmu/rXWlGlQdyofxy8eqMnoupjgmIAkpL78b/S1s4FFSu8wDVwu26fAJyWLP9
	Pn/Zkt/rpy3SRT1kUvkkFLK4S/E0vM1tg/xlQTMZH664HVKhXSnkIeSUHbwgpYtW9BcSRO
	Lf/msVv40yhL/zY1HsH91Yeeg038wkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768917683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WB/QAIhLT30gDx+iBsgOOPnda3Hx0tMddPYYIhfYYOA=;
	b=2GxwD/W9SNxf7x2i61kshj3kQvNwvD/njJP5TLYqNWSKekQs58CC0JsqQI4AklMYtMDXF+
	kiNLM6Rm0Zpcw9Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768917683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WB/QAIhLT30gDx+iBsgOOPnda3Hx0tMddPYYIhfYYOA=;
	b=QF9TNIp7cpmu/rXWlGlQdyofxy8eqMnoupjgmIAkpL78b/S1s4FFSu8wDVwu26fAJyWLP9
	Pn/Zkt/rpy3SRT1kUvkkFLK4S/E0vM1tg/xlQTMZH664HVKhXSnkIeSUHbwgpYtW9BcSRO
	Lf/msVv40yhL/zY1HsH91Yeeg038wkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768917683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WB/QAIhLT30gDx+iBsgOOPnda3Hx0tMddPYYIhfYYOA=;
	b=2GxwD/W9SNxf7x2i61kshj3kQvNwvD/njJP5TLYqNWSKekQs58CC0JsqQI4AklMYtMDXF+
	kiNLM6Rm0Zpcw9Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F8E03EA63;
	Tue, 20 Jan 2026 14:01:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ixu5FbOKb2kuRAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 20 Jan 2026 14:01:23 +0000
Message-ID: <efd02f1f-b09b-4786-aa55-aa366f58442f@suse.cz>
Date: Tue, 20 Jan 2026 15:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: replace cache_from_obj() with inline checks
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Eric Dumazet <edumazet@google.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
 <imazcyfzfkxofsnriyp5wa5v6yzszozljircucw2tgj6zex2ee@ytew6wy4kkh6>
 <8bd3c3e8-9865-4467-86d5-17d891f6f21b@suse.cz>
 <vyhpr6lq5rb6qgkshksg26a5ns5gd5ryqu46pqx2z5twy2gzlx@t4xaze2lhoen>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <vyhpr6lq5rb6qgkshksg26a5ns5gd5ryqu46pqx2z5twy2gzlx@t4xaze2lhoen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: cdjedsb8myqjzp75ukz7hf4y3gb8hp5u
X-Rspamd-Queue-Id: B34BF140019
X-Rspamd-Server: rspam04
X-HE-Tag: 1768917685-605711
X-HE-Meta: U2FsdGVkX19H3rz5ewW9SmntLYjPSC0cfrMQGSYyUzvKY75VI/FKzRq+qtEaaymm/ubLIvBX2PHUplBw3vEap5BRXfPeopruqoBrAxS7yOLUEKRElBkKrF5ewc9rRvFv5bU/9XsBAx7h98axMTkmEgfkges2MFD6DMzIuv4Oiud7q3O3DCz+SxZju7JyygK/EORsaHvhC2vJyG22PXZzG8aRHHy8wt/o3gM8IVvko3OfR+Zs+UdKGCKK2HwTjYOsaFfKXEUnFbSOAYJyjQm4/MKuzXVzBRcOiICmvzBZ4eKpvWtzNjsmbuN9r7ZMWh6OVBAf66hKHtFHOnjL17OXTAb8dfF2FdUGadP12uMs7+zC9KmxGbbSVeMHiQgaRUGkI1mfIA533rOQpKHW/VtmjT4rMW0exfYUDGtec2nM3IrYOXlmJAamBTHTyzKgIDTtZSezcNN/5MOUs/Q/ITbHbs0GQ2dkCQHfZYd3qqOgFiFJ+fzyzjgY2wVDPW0CxC03jkHvLvnlpDbSNNn1w/jWrupeyyXsg2cs07rk8N15vv8bImAQSqvv8JgZPCLi+K7jrW0jGQx00dpSe1RwovkMdsUrPRdIxlyzoSYCgAa51GmAFZriyhazHNgth5Z38DYl2JG80KlkWji9d1JLUgjLB+dBF7qg3Ta4wsQpEB+2CE3Jw9eQoDOAsZenljPWSK7yCD1qlalcWyO1LHAA5GxeOuQRcQvjyMfk73prTkMw7XvED252vEftRvMcpesOgcrV4uAdUr2TDq2fyKYOmS6mJkYJoTEiIhdjYX8Hlr8ZvM0LEPHKfh2hh13P0fFQXJsG5yEvCNm/XOTouduQ0Yjn+kmxdKBppGLYLJ4g83PZQvdpkmsTduGXdSJ9d1MWX1UfyG3Z34+rRHZV+X28Tjhw55uwtUhZAllnhr2Piqr9QFEHWEZC7ClbbAs/uRe20e9/yzl1ftQmGMSVcimzCmH
 dBlaeqlA
 bBluglrk+7PPRkre1f+18CE6gRNbRJDnFysfD1E8pdKSe/HbfPotSn9ZzQsoPvcVQf+wt3bMM+vSK86kqsR8P6MOXHg5PuW/kgdUKZaP3mAsfkWftneCZfwH+oVYjM5gclZrqRO4IUnjEeSctbIX2zalxJAhtedNbKg4Aq6pUBa6KEMD8Woy3JR9URcO9KD0k58u0/24FefFdQtWwKl2N0QH85+RHb1OxFRbvFhSgPj0hRGG+0Kd5BkPZxJG5JX0u6MJSVCnSRWnAUuYMTdwXYoLJ1GnUzq92GvIi2vwYCeOY03hrorVb0R1coNi9YhR92tkT6a0n/9G3LJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 14:56, Hao Li wrote:
> On Tue, Jan 20, 2026 at 01:55:09PM +0100, Vlastimil Babka wrote:
>> On 1/20/26 12:57, Hao Li wrote:
>> 
>> >> @@ -6774,11 +6770,21 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
>> >>   */
>> >>  void kmem_cache_free(struct kmem_cache *s, void *x)
>> >>  {
>> >> -	s = cache_from_obj(s, x);
>> >> -	if (!s)
>> >> -		return;
>> >> +	struct slab *slab;
>> >> +
>> >> +	slab = virt_to_slab(x);
>> >> +
>> >> +	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) ||
>> >> +	    kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
>> >> +
>> >> +		if (unlikely(!slab || (slab->slab_cache != s))) {
>> >> +			warn_free_bad_obj(s, x);
>> > 
>> > Just to make sure I'm understanding correctly, are we intentionally not
>> > releasing the object x in this case? Thanks.
>> 
>> Yes, it means something went wrong so it's better not to do anything.
> 
> Got it, that makes sense - thanks!
> 
>> That was true before this patch as well.
> 
> I'm still not entirely sure I follow. I read the original code, and it seems
> like it retrieved the real cache from the object and released the object into
> that correct cache. Did I misunderstand something?

You're right, I misread it as returning NULL, but that was only on
virt_to_slab() failure. So that's a change, but I believe a proper one. But
I'll mention it in the changelog and the comment. Thanks!




