Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72693EB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3996B0005; Fri,  6 Feb 2026 04:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D8C6B0088; Fri,  6 Feb 2026 04:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9116B6B00A4; Fri,  6 Feb 2026 04:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 833266B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:40:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1463E1A07E6
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:40:59 +0000 (UTC)
X-FDA: 84413537838.20.0B1E903
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id BBE0B40002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:40:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YIzGA2qy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ahes/2SI";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YIzGA2qy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ahes/2SI";
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+q4ZQvZ4gJdNNSTCPhF2Nf1ItWDqCCaVH0OM2FYrvY=;
	b=d7TCo4+bdJzpxN2LCgszVfgB3EFPFerFWWOLbrxpq3Rkiy1QS+KCGmtyCrI5X1aXAIz/65
	Ju+UVhX4PZmkXuDEBJcC+1Yau4hOcld4NBIcOXKR5Daijh+UhI7O3Cz/gpwRv4ABb7JjF2
	/q67XTI30cEv6ZZDZX3cAW2HIaIMgKY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YIzGA2qy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ahes/2SI";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YIzGA2qy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ahes/2SI";
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770370857; a=rsa-sha256;
	cv=none;
	b=JmQbnUqHOfq7Vjlf7u1bf4kXuBPqf9bwx38pYGD9Fq7IAyDvv1FXTL5e9gGbDTCBTzEpTO
	I/ZeOt8Rxc0ZgL6xT25TkhC1h3QhKwlVZrDqtP3FhTAHq54xqSGo0nyTjA/XLQMHcOxhi4
	9WiST5wr8J3w4Ci0L5rIV6GNHfm6x88=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 95DD55BCE0;
	Fri,  6 Feb 2026 09:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770370854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c+q4ZQvZ4gJdNNSTCPhF2Nf1ItWDqCCaVH0OM2FYrvY=;
	b=YIzGA2qy04hKxVhViNd1zmH/aUHxDzWoXeJGHj7DJUXMeaWU187P89wyyJQTlRUOcLbJLc
	vel/oKtAZKVQz4Sx9fKO9cc1KrFlX/k8+IxuEN8ngq47tjgTG6sEYwgDflcbccFiDPct+W
	zVy9HNFUCvm/u2WQ2POFjQcBFa2ivEY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770370854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c+q4ZQvZ4gJdNNSTCPhF2Nf1ItWDqCCaVH0OM2FYrvY=;
	b=Ahes/2SIBNNJGNcNqpKP1+WbqkWuSAqMZwy+/djFEN5q+XPbboDRDnU3Bgc8m6WLDKxjoH
	aK/fI88fqERXptAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770370854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c+q4ZQvZ4gJdNNSTCPhF2Nf1ItWDqCCaVH0OM2FYrvY=;
	b=YIzGA2qy04hKxVhViNd1zmH/aUHxDzWoXeJGHj7DJUXMeaWU187P89wyyJQTlRUOcLbJLc
	vel/oKtAZKVQz4Sx9fKO9cc1KrFlX/k8+IxuEN8ngq47tjgTG6sEYwgDflcbccFiDPct+W
	zVy9HNFUCvm/u2WQ2POFjQcBFa2ivEY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770370854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c+q4ZQvZ4gJdNNSTCPhF2Nf1ItWDqCCaVH0OM2FYrvY=;
	b=Ahes/2SIBNNJGNcNqpKP1+WbqkWuSAqMZwy+/djFEN5q+XPbboDRDnU3Bgc8m6WLDKxjoH
	aK/fI88fqERXptAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 787583EA63;
	Fri,  6 Feb 2026 09:40:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v99JHCa3hWnDfAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 06 Feb 2026 09:40:54 +0000
Message-ID: <67ebb9f2-b383-4b68-949e-239d8c7b18f0@suse.cz>
Date: Fri, 6 Feb 2026 10:40:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: let need_slab_obj_exts() return false if
 SLAB_NO_OBJ_EXT is set
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260205120709.425719-1-hao.li@linux.dev>
 <aYU7l6P2ikKvnrWT@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYU7l6P2ikKvnrWT@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BBE0B40002
X-Stat-Signature: iy814u58whzp4c73kcmu9738aekbb4p1
X-Rspam-User: 
X-HE-Tag: 1770370856-869288
X-HE-Meta: U2FsdGVkX1/pessLiiXP/ytnRCaadbEjpFK0HEsK6fkWzlZNqY7M5ndYKs06hv5dVHWCsSez/OPloobj3+TH67ZVtTSI8NRCjYyYQrxsd0YkfNb7jA6/iSkF2+VrpdjYuXWU+m6n+Tk8gwX9NiKiJSWNxS/PGpPIgGkm8V5m4reQbSI/i32+BEOJJRFU1yQXKBV1uZYhTxN6KuEyXg1hwdNIUEg1+LxCkHfwBjcc9UzgP1+0dm9519ZN7aFcitjxa9B4uENRE8I0J3TrHok+ZTQSOmjQ+jvS4Fpx3EcaABGHHy8BkxHJXLmYP/p4hx1+VIz5rPSn9KnGCTtvxymh4eIJPCtUrW+7PwKex+G55Cofx3xPfE7W6qN66o2fG6W7wDc0HtvWRuf6k2SUarwVvXDMZuEDj5/HOQS7LBII6xA8vkOurPN/w9ZiRkZZWNY0BhmUwjugSfesa0pYzX6/pkJC3nkYJnsoLnVIXj7y/vGlcqFSKt0FcxLDkUqVwXGTHGj+0jEq60kDByTJRditUfEAhyBxWfafdQulWsgQWsuGh1xB4Zd6RSw5+f3HaVgB06aFUE2oc8j3xJUrhWuPVzObs5P/4JEc/sKs7aMa/Yh3boSrNg1u6yIxrRBd6DKa4GILxMO8KZIZ7RYJ1U7OcyLx/NpmbY/4KQkjdlQId0dP1jw/y+YBQNCx2iwPjQPL+mtohgiwJTTZpWE3QRHbEbE1JPDndP30/h/4fN3QpOjmWg503wl+8xqKIVICjbpRb33cvDV3g8CKs3a9KZWiKRT1Za/Tuuox7K7xgp4Nar4BN8m416NJaW3675qG4v1og6Ormdd/OlY2Awg6T9vbBqeuhma/AZJVTNctHup+bU0KpDJ/2RIhSxjVrtfE34sQHlwAKcpwEdAb8c11DXWW1IjcJnTtlP1cCv5d9kMwWtQ7AB8WORIzolcMQ8lY7Ez0pWbHtsARPbVMi/EQj7o
 P77cYRLO
 D8kVpRgquoOqh2yw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 01:53, Harry Yoo wrote:
> On Thu, Feb 05, 2026 at 08:07:23PM +0800, Hao Li wrote:
>> SLAB_NO_OBJ_EXT is set for boot caches, but need_slab_obj_exts() doesn't
>> check this flag. We should return false unconditionally when
>> SLAB_NO_OBJ_EXT is set.
>> 
>> Signed-off-by: Hao Li <hao.li@linux.dev>
>> ---
> 
> Looks reasonable to me,
> Acked-by: Harry Yoo <harry.yoo@oracle.com>

Thanks, added to slab/for-7.0/obj_metadata
I think it doesn't change anything at the moment? But a correct thing to do.

> Thanks!
> 
>>  mm/slub.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 865047eaf02b..3b1402e1c39d 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -901,6 +901,9 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
>>   */
>>  static inline bool need_slab_obj_exts(struct kmem_cache *s)
>>  {
>> +	if (s->flags & SLAB_NO_OBJ_EXT)
>> +		return false;
>> +
>>  	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
>>  		return true;
>>  
> 


