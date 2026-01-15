Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05FCD41159
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533366B00A5; Thu, 15 Jan 2026 05:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCEB6B00A8; Thu, 15 Jan 2026 05:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D9F6B00AA; Thu, 15 Jan 2026 05:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26AE66B00A5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:11:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9E101602B2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:11:20 +0000 (UTC)
X-FDA: 84333780720.30.E6F8893
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24323100003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:11:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lWUu2Tbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtkAr0qa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lWUu2Tbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtkAr0qa;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768471878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgS+YfLmxtAaHSdATGA5HBi4gCQegNTgh7ni6TZTR30=;
	b=Xc3Ph7fN12yzEbGFLC8EcaJBezVJJPN1pG5hBizcJSqs1FGSb8cWGLpBNYeczexlurSsK3
	0HZ5Y6TmUBdigNnZn4wk99k1uErNAIZam+LIVS3EpRP8pNX2ml43Tx8SwtYf5STyUfwdoE
	DFe5yyFRAhlsJh4yM7jS7by7xTLTxRY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lWUu2Tbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtkAr0qa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lWUu2Tbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtkAr0qa;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768471878; a=rsa-sha256;
	cv=none;
	b=KQ99At56Dmarb7Xa0SDgHQD3Mk/5uEdJSzpcp0OsMdSAR4UqHxp4GqdLvhNA1WNYM1hxpG
	I2PcYdcgZmS2CqfVWA7MlXCKOA4oeCSWQiM6En1X8PrTtVTdN99c+Ucc1r0ueTOmzTCVTN
	J6byxQIcV8Bkr928P+UfsTzt4DK3aYw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 80B715BCEB;
	Thu, 15 Jan 2026 10:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768471876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cgS+YfLmxtAaHSdATGA5HBi4gCQegNTgh7ni6TZTR30=;
	b=lWUu2TbeZY6RbZ01DhcVeFrmvAsySDFDk0yGL7KxxRgj7H0omhhsI5oH21/J5Ky4XfZ/Ul
	e22VJxJfZ25vUJjcg3TkLNMpoRoao8jCZUKbDJt9/iwes9Hf+Lj9E55A2tv2nUo9/lgMDu
	SYg8PyiOPyZ0yFy5wSQK46fqzRQVY5c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768471876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cgS+YfLmxtAaHSdATGA5HBi4gCQegNTgh7ni6TZTR30=;
	b=JtkAr0qaXG5Lhs4NEaVJnny1x36VnIMUXEApK8+cQDbTaGfyiovtrcYUdgOTSj4pWSD/3F
	rhc3IX4yTzW6XEDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768471876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cgS+YfLmxtAaHSdATGA5HBi4gCQegNTgh7ni6TZTR30=;
	b=lWUu2TbeZY6RbZ01DhcVeFrmvAsySDFDk0yGL7KxxRgj7H0omhhsI5oH21/J5Ky4XfZ/Ul
	e22VJxJfZ25vUJjcg3TkLNMpoRoao8jCZUKbDJt9/iwes9Hf+Lj9E55A2tv2nUo9/lgMDu
	SYg8PyiOPyZ0yFy5wSQK46fqzRQVY5c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768471876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cgS+YfLmxtAaHSdATGA5HBi4gCQegNTgh7ni6TZTR30=;
	b=JtkAr0qaXG5Lhs4NEaVJnny1x36VnIMUXEApK8+cQDbTaGfyiovtrcYUdgOTSj4pWSD/3F
	rhc3IX4yTzW6XEDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6164D3EA63;
	Thu, 15 Jan 2026 10:11:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zbt1F0S9aGkJdQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 10:11:16 +0000
Message-ID: <66de652b-3c0d-4ad7-a23e-2a46e862edd7@suse.cz>
Date: Thu, 15 Jan 2026 11:11:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 05/20] slab: introduce percpu sheaves bootstrap
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-5-98225cfb50cf@suse.cz>
 <leaboap7yhlnvuxnxvqtl5kazbseimfq3efwfhaon74glfmmc3@paib6qlfee3i>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <leaboap7yhlnvuxnxvqtl5kazbseimfq3efwfhaon74glfmmc3@paib6qlfee3i>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: dejpz4ctnu9cjy9khoga8nufs7or1mhp
X-Rspam-User: 
X-Rspamd-Queue-Id: 24323100003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768471877-336483
X-HE-Meta: U2FsdGVkX19RCm6bEAgIl6zdWZgE/reuNFipA0mXOOnz5z8Xgzjx5yNNYW07EQo2vY725ibNMHLv7SsDghrUCvCm3icT7ngGA+RwqVTUySkcZUPTU0vwbCEEN17zvfMODsnqRO/ywWEn7e1Yod4f1LERoJ12YTErIlbYQQhkTdVnlDuNjBWQDqtPXoqA/+NDR5pR6qxqX+Q5mqxIODaSuNa5XIg9dQMIFEt8tOzQld/XphWApxdIDfIxB9eGUFq78UpP9CVr0zz4Ntb0nyoK7pcajr61aCtmKkNbR8EnM7JKjEPAhee90R0woWX9F2B/eowlQ/pTo0mHotE2qx6Ey48H/8VZX3IHrpA9CSTHrHgs+hRMilLpq/SwER3Euo3XDN+ixWbWowwm+f/Drsp3mPuiDGmEmKMlfm/rmYvCqtNp1ajiV5k3OFOjt+AqeV+XRIB01+rPNujL/JBEfW/vJHAA8RXnKYqPWsaaUTU6WBkEPOvPNp3NqI/boD+GFKQCKeZU1R5leHeXq4tuCq5x/Gs6NIHuydprMlDsL1PaDZkTj2DdelmQxheKSdI6mCtM+scQnDzMJy6eolfiB2DrRdQWM8KB1JnKW6AVeWXnnfJtksItcSWXo6Hfm0pEgeYSh9CgnWIckNRshJWJ5VxmwkEThakyaD/1VF7BcBkvjfkHUS9XofiGBc0EtIkTYf/IEBMBfdwpnhrwdMXiUbhTXWkWPdXiFgKxlxHzoSoe8/QV2yBcxgGeUZ5W8EWj/xynXaATdAwkuAO78hMPx61vHHGU5CeHzr9U9uDlhU9g1eopnKwHT0Y3cbJjsSGNlPcpNeTE6dzhA0ILjM+sm0edCIn6Q0FgVyt83Bl58AuFF8wsT1gsOVITUzWt9cAGaYz/v4lEfvNuVa7wO1Nd8/dl89un4AF0y12nYZBNSmavqbVJNR+27xvQqbA+7keEoA/oiGhu488MF2SWqF+4aog
 uuEy3RzE
 Q8/+1GxnNU13mcKqhs9/Naf0/zrKooPhEmKme0oBZa/2f02PJK813jylgEv9WevrfQO9y1L67vQI0pjV+1K8AJAqzIhEo5+FIMj84fCJcYtqd65fK81WGh57pzkHQ6jrIOgfrg7dPeUW2KiHcMJgH+N/+AZSUJHOK6wsy/OxbJndYj9mUMLYU2rmi6pE9MfdCPd8h3TUx05RScgeqSXddT5oSdBUQFIvCUenAEi0aRsmo2ohI8tUh/18sMbe8pgrEVs2YJV4TakmHXa8/DD1OwFmd7v4Wq5m+WKmA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 13:49, Hao Li wrote:
> On Mon, Jan 12, 2026 at 04:16:59PM +0100, Vlastimil Babka wrote:
>> @@ -8641,12 +8690,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>>  
>>  	set_cpu_partial(s);
>>  
>> -	if (s->sheaf_capacity) {
>> -		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
>> -		if (!s->cpu_sheaves) {
>> -			err = -ENOMEM;
>> -			goto out;
>> -		}
>> +	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
> 
> Since we allocate cpu_sheaves for all SLUB caches, the "if (!s->cpu_sheaves)"
> condition in has_pcs_used() should be always false in practice (unless I'm
> misunderstanding something). Would it make sense to change it to "if
> (!s->sheaf_capacity)" instead?

Right.

> Also, while trying to understand the difference between checking s->cpu_sheaves
> vs s->sheaf_capacity, I noticed that most occurrences of "if (s->cpu_sheaves)"
> (except the one in __kmem_cache_release) could be expressed as "if
> (s->sheaf_capacity)" as well.
> 
> And Perhaps we could introduce a small helper around "if (s->sheaf_capacity)" to
> make the intent a bit more explicit.

Good idea, will do. Thanks!



