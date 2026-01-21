Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65623C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9F86B0005; Wed, 21 Jan 2026 08:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57676B0088; Wed, 21 Jan 2026 08:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D7C6B008A; Wed, 21 Jan 2026 08:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5A96B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:56:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C08C160361
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:56:46 +0000 (UTC)
X-FDA: 84356121612.24.6E3C493
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9DEAF40003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:56:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RLeqqG3F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/hedZwf9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tFX5PEb0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pr1DDvzP;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769003804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9wHHlvguHOFteeiwaIUOv2HvVMORPBkdi/Fa31GaTI=;
	b=Mp7hl1zdTY8CzHhD/skEsDScZm8W5/PyAJQsDKWkRG4pjwEJ0SkAuatc/5NHyabsRcEi59
	viqVEoNeRuOTNX6own7t8BhppoCYLMtm0pSG1YQf2NEgtAMqoW1c2BVryfq1W0Cb1d6/hU
	1eJdWULmBBo5PG3qVgKTZ0ia9d5N6mQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RLeqqG3F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/hedZwf9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tFX5PEb0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Pr1DDvzP;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769003804; a=rsa-sha256;
	cv=none;
	b=Ae4xz83h5snczNsM/PFKwDIYPHYUBU0JrXZ5dfxqgCqi51gORJP+FRn6vBsSQ0r/FCAXMj
	v/5oxWyuE06e5lhYnf03BoS7W8LuK9SF/U28V9P69F9zueo0GBbWhFzF8jgAlM13pBcY22
	gv/XtecUMSQGmUPJd9viPMTdy0Qja5U=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED0035BD00;
	Wed, 21 Jan 2026 13:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769003802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F9wHHlvguHOFteeiwaIUOv2HvVMORPBkdi/Fa31GaTI=;
	b=RLeqqG3FBu6iZC5J6AXcjT3gpOi4hVC60z2SRmK6G5CxsQcvua/dBW64jgUGq7aonh16qK
	6ENSDG2mHm4udJlnU1yVlrIts/rY8xKO6OQXhuSt+L49HlFuv+Mt/aOXrnkaHohnlRC5jH
	u1EZ/kdpx5a59/4v48H5cPOZyhx3X3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769003802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F9wHHlvguHOFteeiwaIUOv2HvVMORPBkdi/Fa31GaTI=;
	b=/hedZwf9JmybVlrUnQGLtQkauKdrOaQO/RaqMOwGU6sjq6PbjeeAKOq3v/g9w2MrKkTLdc
	qSxnI/VV8yLe5yAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769003801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F9wHHlvguHOFteeiwaIUOv2HvVMORPBkdi/Fa31GaTI=;
	b=tFX5PEb0xwPq3xl9IpsMuEp1+4qM7jgjeO7GQT4/vqUckuMkWlNSguNxybo/MHdWB1Xq4o
	h5Wiq9SiI5b6HRD0HPWhMx8arPtKwmOggt/YNlmdBrYwJdqLWSpDdAEF0MbeXPbFTv7ptw
	pCUH9FulIR9iBLS0Szb9tJiWOGVWWg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769003801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F9wHHlvguHOFteeiwaIUOv2HvVMORPBkdi/Fa31GaTI=;
	b=Pr1DDvzPVHUpSzqTkWGz/NhLXRVPZzyJ0YJ/GuJKa49oAwc+wlSzv5nYZN1tDGULxL1c1T
	w8pPNaWz7JtOs1Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA82A3EA63;
	Wed, 21 Jan 2026 13:56:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mixHLBnbcGkTSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 13:56:41 +0000
Message-ID: <c6ba66a3-0346-40c3-a27e-5528f30fc782@suse.cz>
Date: Wed, 21 Jan 2026 14:56:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/21] slab: remove cpu (partial) slabs usage from
 allocation paths
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-10-5595cb000772@suse.cz>
 <CAJuCfpEEUs98yCiNA=QOPY6Qk7=QhSBF+gqPn5a+B+bYbQwvsQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpEEUs98yCiNA=QOPY6Qk7=QhSBF+gqPn5a+B+bYbQwvsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DEAF40003
X-Rspamd-Server: rspam11
X-Stat-Signature: ncwh9gyqh4nsbneocxji1ie8gji5wmef
X-HE-Tag: 1769003803-619998
X-HE-Meta: U2FsdGVkX18qtIc3ZN3YA7XsLTnZs+wyuTdf2Qd5wQfDsKj2uQj7SINIaMe0yhtrcrzJ5qgCXLWfbR5oFySOM5STIzcFUcLfZhaBqNgVHAR5r0sI4JSx83yFQF52UtiJBcD/xEz+EhUopSVWoOlLRIATDFdqdh7eYkcuskvBW+2qUZCeI9fGYGYIlIG6dP/crxlJhV/xU2wFhTsm5tN6aAH5OidJShHBpJy0yVJ6SHxTGbnec7UYYZflpysHe6p+wnjuCZmIxrDCCuI5LCOlqiB+PTG5aobjQCurGkDQBPXpSg3h8rwmY/c32suiM1k3+2d3URaGkp3bRMo2enKNp/BTM7ff1LroslmxMbX08eswVjkvuqUQOQJRfYsjLZR3ForfUvRKO2vAeuIZN72/i/1RwDiSgyN3TWmZW0jO5BENp1j+05RnfHiXZyEfKgPpIEF1ONkUBIEhXfvyZLu7kBdXlLrfWP5lvd3k2QBJTaZTlzVLzawN/dyef3uCi/sLn1YuhqOLkt06KYxA5Vo7YRX25aL/48XB0su75b2imVJX+aaKuRg/HkhuT/4y2w+kRz/WNUv6almngabjCdX3J0hSFfgIz/PukfROGpCCuVK0wxn929TpwbvtOjckoU91+VeGRVgEMfsw1dY4MPMbnGWNh+b3gHFin9em2VAKWvYzVnO9bQvnee4FnsbOUAcoT6qSuhvq3Xo6+VVmDw3eMjNSLSek9XCk2Pik5sAsdTAKqxGpBcd+cu+syrz2pwmdQaqVwDW+j1Kg/1gBTYXkyLz4DZt6Ga6NspDfVQ88LDDJctHovFm7FS4aycJWJsX779xRrf3d+QbhD9K900AV486KSXtZGRlVu6u6xjdOIeS2cOde1kMnJDb+5Ux/qMKijNuK+Df+Uw5kWs1rYYYmFKMGVnbMO5uTZ9NrSsOlj1Z3jOgxYDTvVeci+7GsS4hhxd1syww9sQVeTCUP/2w
 ye9LndSl
 sIKXC8sJMltwe/pAc7PDWT1CtxP39H0GOxNy6fsnAAoFJhzD4YOJGkafGhj+BiafyyVxKvE6pQV8yHbGTFA+CsankFMfe7yTrP41V4SwoLM5Dq5/Nim6Xzf4Rw4AL3UrcMd0QHQ07+7xpG3z44fiwuzzGOioJ6Nbg11++qBp1TxriB36SvwToLiZFNSoSU+t8Lq4l3dWKVdPjuB0eVCiMpXDZ3UM5tUqLWUy7tQocLevxRmodudo4FFxlJ8wd/asKVCifFCRBCmfAmcOdyQIWUjE9R5R5iX/KMiNxJxjIwIjVVsiXjmwr6eE+W/z3n6mg/6O4JASWMbBcRWkx4CQfqIvTEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 19:06, Suren Baghdasaryan wrote:
> On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> We now rely on sheaves as the percpu caching layer and can refill them
>> directly from partial or newly allocated slabs. Start removing the cpu
>> (partial) slabs code, first from allocation paths.
>>
>> This means that any allocation not satisfied from percpu sheaves will
>> end up in ___slab_alloc(), where we remove the usage of cpu (partial)
>> slabs, so it will only perform get_partial() or new_slab(). In the
>> latter case we reuse alloc_from_new_slab() (when we don't use
>> the debug/tiny alloc_single_from_new_slab() variant).
>>
>> In get_partial_node() we used to return a slab for freezing as the cpu
>> slab and to refill the partial slab. Now we only want to return a single
>> object and leave the slab on the list (unless it became full). We can't
>> simply reuse alloc_single_from_partial() as that assumes freeing uses
>> free_to_partial_list(). Instead we need to use __slab_update_freelist()
>> to work properly against a racing __slab_free().
>>
>> The rest of the changes is removing functions that no longer have any
>> callers.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> A couple of nits, but otherwise seems fine to me.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!


 > -static struct slab *get_partial_node(struct kmem_cache *s,
>> -                                    struct kmem_cache_node *n,
>> -                                    struct partial_context *pc)
>> +static void *get_partial_node(struct kmem_cache *s,
>> +                             struct kmem_cache_node *n,
>> +                             struct partial_context *pc)
> 
> Naming for get_partial()/get_partial_node()/get_any_partial() made
> sense when they returned a slab. Now that they return object(s) the
> naming is a bit confusing. I think renaming to
> get_from_partial()/get_from_partial_node()/get_from_any_partial()
> would be more appropriate.

OK, will do.

>> -       }
>> +       freelist = get_partial(s, node, &pc);
> 
> I think all this cleanup results in this `freelist` variable being
> used to always store a single object. Maybe rename it into `object`?

Ack.


