Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8262DC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 19:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA29E6B00AF; Wed, 21 Jan 2026 14:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D796B00B0; Wed, 21 Jan 2026 14:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFADA6B00B1; Wed, 21 Jan 2026 14:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3F16B00AF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:03:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48B3F8CE8D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:03:43 +0000 (UTC)
X-FDA: 84356895126.26.48507B5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1922A0009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:03:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=daIUECt6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qnsPYJ34;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ps48yUo6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hbaHzRDy;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769022221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrMzqW5YGuDKPkpZJVNguF5+RS5LJEqkTsioRB+4hwU=;
	b=v+fuEiLeJOkh8Hs1Fi9v9jnFnkLS6S29lVmkib+2g+Ly5jmGo6ZKXA0Et2ugbdAEf+tkGg
	T1Ky8lzdNw3LhGK7up4rFyMPjYX+K83rpp+TrSdQsO8nvTmonYdQ7wxadGmkG0Kz9jKL6W
	LKFK+SNVwQI9jXLOJwemtI5Ql077nBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769022221; a=rsa-sha256;
	cv=none;
	b=EzXQ8vnK7ngzS+9/7tjkcvX1id/PTIeXzzAeovRPfLzQv4CvTboXooglLAe9XFGz29bAGD
	O7qb3GBkminxUbyqu6dwwAHa1I4MTQV+lmBYQZJC7P5FIWwfNJi9Jl5SO73BTPSR3DR3tG
	BPzfKPBFl54uLzDbV1BVwtdMqEki0+c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=daIUECt6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qnsPYJ34;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ps48yUo6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hbaHzRDy;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC68A5BD6D;
	Wed, 21 Jan 2026 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769022219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wrMzqW5YGuDKPkpZJVNguF5+RS5LJEqkTsioRB+4hwU=;
	b=daIUECt6IGzDNLpn43IzvijsxJAvINi2hzO0rphu0q/vG+yHmpRYkq/aUkCAB+3oa0MMFm
	1kswg1EhxSLThneqkVckY8e6Z0mOb/WaIBDwNqIr6umvuhF/40NvbUwtiSOr4lvE+gJpQP
	dKEC8Ku6N+h2E9OlFclPjeuekOIRAEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769022219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wrMzqW5YGuDKPkpZJVNguF5+RS5LJEqkTsioRB+4hwU=;
	b=qnsPYJ34//bTRq+kla8PLUsI2h9czlT36c/359vGJJmoLOQkllqoMlL3IxnXYIEUhUhU6y
	t+bWEyJPd47LwuAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769022218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wrMzqW5YGuDKPkpZJVNguF5+RS5LJEqkTsioRB+4hwU=;
	b=ps48yUo63eQnwp+CgitvCmZ3yteaGIEgZn6fmEK+8iEPYeS1D8PMlykKz3hfMV7l29vHDj
	cx+UyxYtxn94MZJOgNqqLd7XhwxvjfII/dWyTlmydzJ94yJrTPt64CplVAdory2CPQcrmw
	++0KsrB/NApblNyFC38RRLQP1GQtk48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769022218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wrMzqW5YGuDKPkpZJVNguF5+RS5LJEqkTsioRB+4hwU=;
	b=hbaHzRDy1lfW7FJpk39eHzpCiG4BUDFHpubzRjVUe8ksYJqYrh3rsbfNBD/JfJq8Qz9wiw
	tnHBwnY7WRJVufDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A0AA3EA63;
	Wed, 21 Jan 2026 19:03:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1W0+IwojcWm8dwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 19:03:38 +0000
Message-ID: <c3eefa5d-21fc-4a37-9b48-90701159baba@suse.cz>
Date: Wed, 21 Jan 2026 20:03:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/21] slab: remove struct kmem_cache_cpu
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-15-5595cb000772@suse.cz>
 <dxrm4m545d4pzxmxjve34qwxwlw4kbmuz3xwdhvjheyeosa6y7@2zezo6xejama>
 <6a814aef-7b81-4b9d-a0a5-39f7dd7daf3d@suse.cz>
 <CAJuCfpHRrFS3a8=x4shoNXHLtmvkFgV8xASsQL0-hiUBb-O1Kw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpHRrFS3a8=x4shoNXHLtmvkFgV8xASsQL0-hiUBb-O1Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A1922A0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4kqrn9n465cpmqxcy157mhwekkueihkb
X-HE-Tag: 1769022220-281976
X-HE-Meta: U2FsdGVkX1+m6tpVEdDweQVTcKsUZBljeISvk7TozQBD9+2SXTKHf7Kpc9/rkoZJ5K7nMy0gDBOcXgPGFToO6TXD5jHOi96P+i6Q262KVqT93ivXDSfZSNZ09wU+CLlU5KmX6LC5Srzn7zjOQaglU5UZpjsV3qCMYn0nGe5Gr/lVEKvbiWSHndDyHJYAwi5ro0QFmmkjPTj8mwmYhh3JMvHCKjasd3qaApDN2A/E1y0iEU/i0SoolTOj+461w8WTgWawKGgfvUwTiOQKHjUqu0UeD9zCUsBzkIqWOt6U0N3r9k4zLll+OBLZCoANj9Bq88t3u6GuktMGe+V0545E2peHUaBZmwtt6uJE7y0+M29BOU7dhhShpoVm2sxnPNCHNzrBOt/7MqKssr5gGhM8jB6vPegOH9PJdqNgkRj673cIjFcqfc20B46ZL5R0gjXIN6xm3IylfwUZhAWI7QtqaQ94LgjVc5jmmsMgSGRju9u0FUbTYVjz37E3KQAJ9eWWlBQGgFXnTn+KO4CpdsgG6251c6p4TXbqWGTTKIFWqYsmVkadirJA3GNYOC6JDxuV5TgElc5A5uu7GMJhti9QoPYfN8J6DnCoawjIzd0ISQIehWyrw6nuB68Y+MTPnAeN0adwWCewsAQFID60/OCrdr9Mr8ge6llBGMDPJiTyoyDYLPakHAFkkN0JNE2pIJrF9aYiVPPzsO37rHrkM8ZIBdGyanm+kNWOVi8qKOSAv7W7VA1MdZnbxpizDVswKaB9aujKT+xnamF4CFz26vn97+CWBnM4dFK4zzSRaTwM9a2F6ZH4J1e4jr1oQOFbFp5hp0fxACtLIGsrZjyaT/KeZA6uL5NARWESSqdbqaEs3Gd+U4fDwQMYyJJMp4q72cjWoDs4TKzfxze5cUw5TKju5vlqakvJGW09SezfH2kN0OC8NT+MHgHv6NoucBamRHZvkbTqX6KRAydrMyZ6bMv
 1euygeU1
 0oDtVVRkR3T3GY8Rtb8H0E0Qz0ZZykTVlbt57bwU9Iut1f8/3ajq9vL9DfTL3xCC9nNgcspxidTMthFvboL3FjT5a3QIm6a3Y0NIC/8qG6hoM11+vw0M2RUcIDQmKVXEFZUzNj59EmtKcncgoYjk/eX5XnLRj/LHpwSWhuA2p+NyjliFs9p+m8XYXL+k6D+8SUF2OFoogAPIRB22mNypD2woAjJTtInpiIHgswTxq3LsM2XxNuRyg81a/RrsMy0J6S0hnb46DCmKPXmPbglKh4xcqNNwyl6SFml+wdJxc+lS6QQJ4CCsFlmc8fKJv38m0rFLDlidx9SaUvwgiz7R2xRNNr4TL4jjiP9gV40J42Tt7YYjbi7Bl+d2XKw0L0TNy9dW2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 18:54, Suren Baghdasaryan wrote:
> On Wed, Jan 21, 2026 at 2:29 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 1/20/26 13:40, Hao Li wrote:
>> > On Fri, Jan 16, 2026 at 03:40:35PM +0100, Vlastimil Babka wrote:
>> >> @@ -3853,7 +3632,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
>> >>  }
>> >>
>> >>  /*
>> >> - * Flush cpu slab.
>> >> + * Flush percpu sheaves
>> >>   *
>> >>   * Called from CPU work handler with migration disabled.
>> >>   */
>> >> @@ -3868,8 +3647,6 @@ static void flush_cpu_slab(struct work_struct *w)
>> >
>> > Nit: Would it make sense to rename flush_cpu_slab to flush_cpu_sheaf for better
>> > clarity?
>>
>> OK
>>
>> > Other than that, looks good to me. Thanks.
>> >
>> > Reviewed-by: Hao Li <hao.li@linux.dev>
> 
> I noticed one hit on deactivate_slab in the comments after applying
> the entire patchset. Other than that LGTM.

Thanks, I'll remove it as part of "slab: remove defer_deactivate_slab()"
where it belongs.

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
>>
>> Thanks!
>>


