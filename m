Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CDE9CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34B906B0188; Tue, 26 Aug 2025 05:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC8B6B0189; Tue, 26 Aug 2025 05:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3BB6B018A; Tue, 26 Aug 2025 05:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0E96B0188
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:32:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E42B847D7
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:32:38 +0000 (UTC)
X-FDA: 83818393596.13.E0D2836
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 240781C000F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:32:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uEWElARM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rGS8ra4W;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uEWElARM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rGS8ra4W;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756200756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S34knrkcg5bsPBEx/gfFkm6ib/YQpvSLU+ZhmToqIvk=;
	b=fPi/ykeiQ4cA51YTACpHZdp0z+cGzdX1HUq2QtIlFdhXxQyPizN2KmQDIljHa/rai6sI8Z
	HM8uGsZbB7VhA3t5uWXFkd9RRIpo3KHfbHZOtle5P2wTdZiZuhR1ZlDyDC7y7AxD6jBSWy
	HbNa5K252gNuKK4ZbTgTJ8nw26oPVBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756200756; a=rsa-sha256;
	cv=none;
	b=AjsdcKxLKkvn76goG9k8+B12tC/M5K/NCHkRWKNtr1feNcybRCj8FtAI0PiPvU88hQmpZ5
	u+U+zl4l38LcucPRUkCg+uBx2tFgTZHjybGBVd7kAlbw2o+FlTKbUbaZFRE1bRzsFz3bKY
	H1xSaXwlKLgW0HYMA6NKiZjb8Ok/9os=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uEWElARM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rGS8ra4W;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uEWElARM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rGS8ra4W;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 693621F787;
	Tue, 26 Aug 2025 09:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756200754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S34knrkcg5bsPBEx/gfFkm6ib/YQpvSLU+ZhmToqIvk=;
	b=uEWElARMQzfohbUNTeatvr54YNru6LNyZX3DnHEFbhE+nQIw/Q36xcXiA5TnxnHn/vXTjS
	orveWKaQd+NYNu0yrK1bqrL/imwCgLEmZ8oinit/U95ujZ0QFHqEOTpka3MgK0d62XDN5K
	qP/OZRW8NBiI4pZWeLm4EyU8C5fUuz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756200754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S34knrkcg5bsPBEx/gfFkm6ib/YQpvSLU+ZhmToqIvk=;
	b=rGS8ra4WiP7HyVpJLi/GiNTGeh4sQ6HTLErSqn077/0teQsjD537TlVRRvLxzFdRa9E4Xh
	yLK3GXjvdlzuPeCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756200754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S34knrkcg5bsPBEx/gfFkm6ib/YQpvSLU+ZhmToqIvk=;
	b=uEWElARMQzfohbUNTeatvr54YNru6LNyZX3DnHEFbhE+nQIw/Q36xcXiA5TnxnHn/vXTjS
	orveWKaQd+NYNu0yrK1bqrL/imwCgLEmZ8oinit/U95ujZ0QFHqEOTpka3MgK0d62XDN5K
	qP/OZRW8NBiI4pZWeLm4EyU8C5fUuz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756200754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S34knrkcg5bsPBEx/gfFkm6ib/YQpvSLU+ZhmToqIvk=;
	b=rGS8ra4WiP7HyVpJLi/GiNTGeh4sQ6HTLErSqn077/0teQsjD537TlVRRvLxzFdRa9E4Xh
	yLK3GXjvdlzuPeCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5240513479;
	Tue, 26 Aug 2025 09:32:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ige+EzJ/rWiVYgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 26 Aug 2025 09:32:34 +0000
Message-ID: <711d539d-da4b-4f77-9be6-ca11b6fa5162@suse.cz>
Date: Tue, 26 Aug 2025 11:32:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/14] tools: Add testing support for changes to rcu
 and slab for sheaves
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-5-b792cd830f5d@suse.cz>
 <CAJuCfpHR=hceuAcnaCr3Hg-3mknvsmYy7jSScA8SATn7iwoN_w@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpHR=hceuAcnaCr3Hg-3mknvsmYy7jSScA8SATn7iwoN_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 240781C000F
X-Stat-Signature: 4s7jnir1iosocgpqm71zdr568dthask9
X-Rspam-User: 
X-HE-Tag: 1756200755-373786
X-HE-Meta: U2FsdGVkX183eb/kR1KoA4q8Jn5hhodYhjavey6m6bFeO03uMStnqQAPN1D1WrQRhZlTN8B2R4kmPESbVzyL3GK+citTAdpgFvw1aYP6x3Q1d57o7IMUZuW856cmwgUnlY2Du0BXG789IXoYg2jq+gqUyWbqz1MwkLugXbUssNkLPhJjRJljcEvRvIUxRMc4DHKGebC3zkVXXjjl7tjk5H8DNbvOP+rHgF3wXf0MWf+dlNe2ZHXq9RjKisPJu+vdBPyji1fAE2zKp9YZtfVJMBj+xCtcUwQFTXiYsvB1O4dyUnAKIcz0OqpP4EpIyl3nLfGrXvk/XSi44LswJqCxA7voox9bgAx8WyLczg3FdGWexnwEY3wuARL8eSbmPLFeKJZVye3eq6LoLybQj7bsTAiaS8QvbkWu30nmrbseMlpdzpyj3wvvUQQ4ZoRc/Lg7hO285UKGGo9Vfo5lyKHFCS5GYKNqBIr9UefBKwvjFe0qeFKMZBDO/IZdcRfadFMP8cKAtom96ZCT9JapAt9uIGczk6lZDeCqn1xECyD1e95bm9CEGG2up9PT5hmxrGtwl3QWTH6/k+Eom5eeRsehKaBY6rWWWXXReFx/ct8wgFvqyx70D1S1DDH6GiKJNtzLCxvMpKq8T6VwUzRDR0WV2RQUT304MMclM4Vwus6DuGBqDbwC+GbtSbC4f+GYypk1m1hTKOuQoV9NX/QqaMjSDmPK9iehaL3+rq4c76iYpc8TJd1bt0a0Xasdf9GY5Yml8PU3pzjJ+fWatdq0cOnsZk4MpZU9LW6/d3t5WRHVr7pGjKMpsdtKgUj1RmrNDKfhdS+5vY+ty9QsZt/iqRPquDV1f6gzSq9ITGdieEYlmcNEJEVhxy+/i8joM7AnIlwtOLDNHLGk3IK0QENZpM1n8Gd493CBxHlGkNKjlc1vCazI1IthtZ3WJ5R9Uq3NiCXFrM6STTrgONuaWbVBFcp
 taTpJpLv
 90kO0eh1jrWAdKH2TkRQJb34OOcwoSgq+7eOZi9WxeGoa3/fE0oZ+Rs1Arqs5hbVoSJpGZpgPtiLELFDbjNu5fQpJjOT+Vs7sDj7k3Vgp1AVvetAiXnKGQmObb8XYAyc4S4JH6nqUSLp2SuBCiATsradinhgSix372pOh6WSCe02ljxXKkVDX8g41lq8vz8hO+XOqn5Y2fN2IvwJGCjrWDxPNNDGxubV5TkOlD9Q/dXOacEb02M3qS5j1dXm8ImAcLaziU5+1ZelsLEsJdc62bUs3DgJwdHPPZbkmzRynlD4YFbDMPoSnJqZRR9ACMICOO5wj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/25 18:28, Suren Baghdasaryan wrote:
>> diff --git a/tools/testing/shared/linux/rcupdate.h b/tools/testing/shared/linux/rcupdate.h
>> index fed468fb0c78db6f33fb1900c7110ab5f3c19c65..c95e2f0bbd93798e544d7d34e0823ed68414f924 100644
>> --- a/tools/testing/shared/linux/rcupdate.h
>> +++ b/tools/testing/shared/linux/rcupdate.h
>> @@ -9,4 +9,26 @@
>>  #define rcu_dereference_check(p, cond) rcu_dereference(p)
>>  #define RCU_INIT_POINTER(p, v) do { (p) = (v); } while (0)
>>
>> +void kmem_cache_free_active(void *objp);
>> +static unsigned long kfree_cb_offset = 0;
>> +
>> +static inline void kfree_rcu_cb(struct rcu_head *head)
>> +{
>> +       void *objp = (void *) ((unsigned long)head - kfree_cb_offset);
>> +
>> +       kmem_cache_free_active(objp);
>> +}
>> +
>> +#ifndef offsetof
>> +#define offsetof(TYPE, MEMBER) __builtin_offsetof(TYPE, MEMBER)
>> +#endif
>> +
> 
> We need a comment here that concurrent kfree_rcu() calls are not
> supported because they would override each other's kfree_cb_offset.

I think it's a bit more complex and related to the commit log sentence "This
only works with one kmem_cache, and only the first one used.". The first
call to kfree_rcu sets kfree_cb_offset (but what if the rhv offset is
actually 0?) so the others won't update it. So concurrent calls will work as
far as from the same cache thus same offset. But I'd like Liam's
confirmation and the comment text, if possible :)

> Kinda obvious but I think unusual limitations should be explicitly
> called out.
> 
>> +#define kfree_rcu(ptr, rhv)                                            \
>> +do {                                                                   \
>> +       if (!kfree_cb_offset)                                           \
>> +               kfree_cb_offset = offsetof(typeof(*(ptr)), rhv);        \
>> +                                                                       \
>> +       call_rcu(&ptr->rhv, kfree_rcu_cb);                              \
>> +} while (0)
> 
> Any specific reason kfree_rcu() is a macro and not a static inline function?

Think it's needed for the typeof() to work. The kernel's kfree_rcu() is
similar in this aspect.

>> +
>>  #endif
>>
>> --
>> 2.50.1
>>


