Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B125CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914628E0077; Wed, 29 Oct 2025 10:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC018E0045; Wed, 29 Oct 2025 10:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6545A8E0077; Wed, 29 Oct 2025 10:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53A9C8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:38:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16BD2140774
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:38:23 +0000 (UTC)
X-FDA: 84051407286.05.18484A9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A3F41C0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:38:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dy2ejHyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YXvv7lfk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dy2ejHyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YXvv7lfk;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761748701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/w3MRB+TOS2yBG8/nTaTk+4AfwEGJiuVEcv9DVs4O0w=;
	b=xwieExYgq3jUhw4aW69Slat2b4Yrjhl0UY2Eov4YxMWZhZLuqCxeJxVzMSPZCsILSn5qaK
	ge0m0tx5q3g2tcTdZtu8zgFwr8BUdkBmZmiHAI57XQFyyt/s9+LfG0n5efWq7TDycnfZlQ
	e/36dSNNUQphoTXa8KZnDfGSIqA9u1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761748701; a=rsa-sha256;
	cv=none;
	b=5G4tcKTgMd9j4DkrrEFOhhKP1gzXxDkUTgnYOVUozJ18SaSp0/SaunTbLwxvwpgomwHxm1
	FNL18ZT7/0nXb4+9LS4VbQR/aou2og1aKI0SRJ5z4O6jdVN4bbpcTvpaUHtCqXteEpvVAD
	VcDPLm43n1UvGDKCgfPbH34JKwwfE1k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dy2ejHyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YXvv7lfk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Dy2ejHyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YXvv7lfk;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B80E020E00;
	Wed, 29 Oct 2025 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761748698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/w3MRB+TOS2yBG8/nTaTk+4AfwEGJiuVEcv9DVs4O0w=;
	b=Dy2ejHybghJItGmopa/mI7O5bjUrZCtn3b4fnZGRLGrPLEOkqsmOrS5cP0XTNuPIWJaCQr
	yPGkp+x0d9V4weD10d9dD5TuxNIxhCR0zxzJZp+8Dm+W/inaVh+TXmqekiOf5DWHR/y6ui
	zIUvY2G25Azrbf2zHT4q8LcEg5VZuGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761748698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/w3MRB+TOS2yBG8/nTaTk+4AfwEGJiuVEcv9DVs4O0w=;
	b=YXvv7lfku3lTexPm4eW8ZyAx/WioeWafv3duPsNvEUqN1pgAIKXLHSx5HQH1JkQo+myXA9
	2ul1Eue4yN0YgrAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761748698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/w3MRB+TOS2yBG8/nTaTk+4AfwEGJiuVEcv9DVs4O0w=;
	b=Dy2ejHybghJItGmopa/mI7O5bjUrZCtn3b4fnZGRLGrPLEOkqsmOrS5cP0XTNuPIWJaCQr
	yPGkp+x0d9V4weD10d9dD5TuxNIxhCR0zxzJZp+8Dm+W/inaVh+TXmqekiOf5DWHR/y6ui
	zIUvY2G25Azrbf2zHT4q8LcEg5VZuGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761748698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/w3MRB+TOS2yBG8/nTaTk+4AfwEGJiuVEcv9DVs4O0w=;
	b=YXvv7lfku3lTexPm4eW8ZyAx/WioeWafv3duPsNvEUqN1pgAIKXLHSx5HQH1JkQo+myXA9
	2ul1Eue4yN0YgrAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9980F1349D;
	Wed, 29 Oct 2025 14:38:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TG6wJNomAmldPgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 14:38:18 +0000
Message-ID: <0f630d2a-3057-49f7-a505-f16866e1ed08@suse.cz>
Date: Wed, 29 Oct 2025 15:38:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/19] slab: move kfence_alloc() out of internal bulk
 alloc
Content-Language: en-US
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-1-6ffa2c9941c0@suse.cz>
 <CANpmjNM06dVYKrraAb-XfF02u8+Jnh-rA5rhCEws4XLqVxdfWg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CANpmjNM06dVYKrraAb-XfF02u8+Jnh-rA5rhCEws4XLqVxdfWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Stat-Signature: 6x9tr89rehjh97ytbbumuxn7q77wf8ns
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A3F41C0002
X-HE-Tag: 1761748700-293979
X-HE-Meta: U2FsdGVkX1+XcfUYlC7It+Nr4vUYIUafQjMMd7yK9GqVLFEM4VMHZ3Fmjf5RI3ST/64odLMknm5b5FpcxGEJOUDe7S74h8iluCcQqPhnFpJxcYkOFAytmKFRpBjfZRpKL23CJpQplShNcQLEqJL9DtJfzaeQ65K2Wh+dLmImn/oa1kvJZ0NDBG+YK7RBfeL+BEUTpTE/vWhd7W9H0dcB8cOIojxGZsxJEApIKGcWSwxj2FDLFnwp0RwiOUwrkUIRMsLQa261Qx4vnDvWTAeKL8uN2eipTptEVtPUzNCmPcRZ4n8uC/4eTmaS1ZYLMEgDncimWU2vM/ILlwx2bqCP4LdiKGcg0OzvP1SoqYqie8hI+RWG24rPyxDkTEVII9lVrCfbLZ4o6OR9f/DXgPuTvc5FADoZAXW7IRWc/z/uBysmXlN6BOtNL/RhnMglKa998SDe8n2KERgzlZy5WSRoaYy4Wc0j4VTkjeIfO2y5GMTTM/y3hJqpMPemN0YnD/T6WzMQ6uagCvRnLVWpcQa5UFEYd0l8rFOFUVhPFtKzJYAmx4Yv/4+v6TicbH7wtONbyWOl0ETQkx3mx+l4YOq3IZAmHW9d2H7pjcRkq0FTpd24n+zlbFypcrAXfbnZG+Vs+QAN19nvjjAYVtIE41B8JdxxHGDcyIIGnmk7tLGBXWQIwnm/Jz4ux4optU/iF1XtIXRVwIiVT8BmXS/qDAnH1djQbHL/o4nhtdU3b4KEnPEvt0ohLanOqjaaZmqbTJ3JKJ/dbnX3UqEQtAOTqY7oom7shoFFpK92yOAHpJnsRmTg4tp0x5xmGmS2qPcaTPLLtAUjuHXiTu/RQKzwybpxwlBMNx93E52GzWWoFlUQJ8oRvRgXh/GUoN+ZwloDgMXFoIVjaSqpMJYT/RhlR5l/c4NI/pWZQ96ME0KcXI3xvXPkXWEd1VqVfOKbi1QVESsZyb9rIhdnr1b2QbdgYVW
 qv+B2eG/
 Uyx9CtolvqWJj4EMynEa6+cll7HaQdqlkg6o2zeLtQ+HwwPLTFNgS8/KAdY1Mw0GytwThJZp+n02XJ1oE11gsvysj3UxUoGop7cXxM3QeQcOaA//rW6aIuWwaBK05s65wxhMVGmy1+oZOG74KhYk3XHXYmXXT8USrkwQcnxK9fZGehtVs7x+tG5pl4f02dNLHWmoG2xlsipVetThn6IYLqF4BoZEkF1+W01/CHW1q33o9XqpkN7vJoE31Y8Q7vC3UdMZ1ixs939StqjNwA1+Y1RVOfII1OgX80zZtW+auy4MQXolG1NZihlRektGFoS9vo7uBp55C6v16v6/SZ3A0h7f/GfFm4nMJGm/R9iZepU0GdJH3hoVX4cUVNvRILCcTHpa3iDvAmP5pPm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/23/25 17:20, Marco Elver wrote:
> On Thu, 23 Oct 2025 at 15:53, Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> SLUB's internal bulk allocation __kmem_cache_alloc_bulk() can currently
>> allocate some objects from KFENCE, i.e. when refilling a sheaf. It works
>> but it's conceptually the wrong layer, as KFENCE allocations should only
>> happen when objects are actually handed out from slab to its users.
>>
>> Currently for sheaf-enabled caches, slab_alloc_node() can return KFENCE
>> object via kfence_alloc(), but also via alloc_from_pcs() when a sheaf
>> was refilled with KFENCE objects. Continuing like this would also
>> complicate the upcoming sheaf refill changes.
>>
>> Thus remove KFENCE allocation from __kmem_cache_alloc_bulk() and move it
>> to the places that return slab objects to users. slab_alloc_node() is
>> already covered (see above). Add kfence_alloc() to
>> kmem_cache_alloc_from_sheaf() to handle KFENCE allocations from
>> prefilled sheafs, with a comment that the caller should not expect the
>> sheaf size to decrease after every allocation because of this
>> possibility.
>>
>> For kmem_cache_alloc_bulk() implement a different strategy to handle
>> KFENCE upfront and rely on internal batched operations afterwards.
>> Assume there will be at most once KFENCE allocation per bulk allocation
>> and then assign its index in the array of objects randomly.
>>
>> Cc: Alexander Potapenko <glider@google.com>
>> Cc: Marco Elver <elver@google.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>> @@ -7457,6 +7458,20 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>>         if (unlikely(!s))
>>                 return 0;
>>
>> +       /*
>> +        * to make things simpler, only assume at most once kfence allocated
>> +        * object per bulk allocation and choose its index randomly
>> +        */

Here's a comment...

>> +       kfence_obj = kfence_alloc(s, s->object_size, flags);
>> +
>> +       if (unlikely(kfence_obj)) {
>> +               if (unlikely(size == 1)) {
>> +                       p[0] = kfence_obj;
>> +                       goto out;
>> +               }
>> +               size--;
>> +       }
>> +
>>         if (s->cpu_sheaves)
>>                 i = alloc_from_pcs_bulk(s, size, p);
>>
>> @@ -7468,10 +7483,23 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>>                 if (unlikely(__kmem_cache_alloc_bulk(s, flags, size - i, p + i) == 0)) {
>>                         if (i > 0)
>>                                 __kmem_cache_free_bulk(s, i, p);
>> +                       if (kfence_obj)
>> +                               __kfence_free(kfence_obj);
>>                         return 0;
>>                 }
>>         }
>>
>> +       if (unlikely(kfence_obj)) {
> 
> Might be nice to briefly write a comment here in code as well instead
> of having to dig through the commit logs.

... is the one above enough? The commit log doesn't have much more on this
aspect. Or what would you add?

> The tests still pass? (CONFIG_KFENCE_KUNIT_TEST=y)

They do.

Thanks,
Vlastimil

>> +               int idx = get_random_u32_below(size + 1);
>> +
>> +               if (idx != size)
>> +                       p[size] = p[idx];
>> +               p[idx] = kfence_obj;
>> +
>> +               size++;
>> +       }
>> +
>> +out:
>>         /*
>>          * memcg and kmem_cache debug support and memory initialization.
>>          * Done outside of the IRQ disabled fastpath loop.
>>
>> --
>> 2.51.1


