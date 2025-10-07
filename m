Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4B5CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 18:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D194C8E0008; Tue,  7 Oct 2025 14:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0128E0003; Tue,  7 Oct 2025 14:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDED28E0008; Tue,  7 Oct 2025 14:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71858E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 14:07:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F67586414
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:07:59 +0000 (UTC)
X-FDA: 83972101878.17.8E1A32C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id E48DF1C0006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:07:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MSBVuo1N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WhJa8kGl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MSBVuo1N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WhJa8kGl;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759860477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7ybSyGSzF+FRXdFzdx+gGkeN95mqDSe2uh6/YLSygY=;
	b=kcMEWsIVx6g7+7h25Qzf0TGYfmguP2KbOYSQFHPSgJOtjYe+aCj/1i5qG0qQHmP5pssDA1
	qqrgFMqbeOTs4D3EiTRV1B11JqIG8gTkti1IoQuIUCpGH0JSSkNrmnyK7kp8hxJ5jPyD3R
	W7RmiFByk6rgo/3L7ZlDP7ndSzMN2Bs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759860477; a=rsa-sha256;
	cv=none;
	b=CmQjIzFSmZXcJwK0YeZfebG1vtXEg07rxC7B3SYKO6mughiI8c0vFGRaicPtaiLhTF8fVW
	2Q/Pp8vbXwjuNP7ESIg9XW55NWRKBiaKkeAVrg8g426Zc0zVWmV6McljMd8mQq3dUppnbS
	EfnHZZxRHusQpzpigrKI633fzReoqVI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MSBVuo1N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WhJa8kGl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MSBVuo1N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WhJa8kGl;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 269891FD6E;
	Tue,  7 Oct 2025 18:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759860475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l7ybSyGSzF+FRXdFzdx+gGkeN95mqDSe2uh6/YLSygY=;
	b=MSBVuo1NQr8VFlVt6Jy6MUQnC05jwf3Oteho9kuN0w3MoZYTZJ4zuyKaKKiSOpLamoEvk3
	wpO3Rf5Ikj30kC4UqRhsVQRYR6mfX7DqpLjI8DbhQpnFHCaAmGjobX+2iM/Maxis5x3V8Y
	CDmA/1gWkzHNEdKwxzHHSPDjIMoKIbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759860475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l7ybSyGSzF+FRXdFzdx+gGkeN95mqDSe2uh6/YLSygY=;
	b=WhJa8kGlQuf1/mHUTlO5TeYn/3fuFxm5ezFKFgsW+XEd3ZFAYMAKeDPN1pYi+epZVVV5Lr
	Btq3TDW0pvIsFICQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759860475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l7ybSyGSzF+FRXdFzdx+gGkeN95mqDSe2uh6/YLSygY=;
	b=MSBVuo1NQr8VFlVt6Jy6MUQnC05jwf3Oteho9kuN0w3MoZYTZJ4zuyKaKKiSOpLamoEvk3
	wpO3Rf5Ikj30kC4UqRhsVQRYR6mfX7DqpLjI8DbhQpnFHCaAmGjobX+2iM/Maxis5x3V8Y
	CDmA/1gWkzHNEdKwxzHHSPDjIMoKIbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759860475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l7ybSyGSzF+FRXdFzdx+gGkeN95mqDSe2uh6/YLSygY=;
	b=WhJa8kGlQuf1/mHUTlO5TeYn/3fuFxm5ezFKFgsW+XEd3ZFAYMAKeDPN1pYi+epZVVV5Lr
	Btq3TDW0pvIsFICQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FEBC13AAC;
	Tue,  7 Oct 2025 18:07:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jI6OA/tW5WjLfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 07 Oct 2025 18:07:55 +0000
Message-ID: <e072aba0-6160-4485-93ed-3c3ae5abdc22@suse.cz>
Date: Tue, 7 Oct 2025 20:07:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: Don't call lockdep_unregister_key() for immature
 kmem_cache.
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 linux-mm <linux-mm@kvack.org>,
 syzbot+a6f4d69b9b23404bbabf@syzkaller.appspotmail.com
References: <20251007052534.2776661-1-kuniyu@google.com>
 <10d6dec4-665d-493f-97a9-2982dfbc1afe@suse.cz>
 <CAADnVQJ1AzEL6JD+ePBZctqmK6unYKDYKuARRwDBhNJ3CBykdw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQJ1AzEL6JD+ePBZctqmK6unYKDYKuARRwDBhNJ3CBykdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: zuysz16jrpz1krai84jnp19uaxojsa4n
X-Rspam-User: 
X-Rspamd-Queue-Id: E48DF1C0006
X-HE-Tag: 1759860476-616789
X-HE-Meta: U2FsdGVkX1/Ezd/FIMtgcYZImhBtPwJDQFGwy/lnOJepvQetGcTs9qjMs5Tp3FnFjn/VTXS7zs5rqGkAtTMsAYE8dgCJWDculElei1dQLK+Q7+RK1aJvKgchM4AdzpciYxL0lup1xi8WZtECjPmEdHH0Ycl2L8F337VYQJkpTm0XDcgIaZ+Qf5Tc5DsOWXASYpNFh+Px+bfUjAJNfMsk0k9MSp45sXSAyg0cdFwMVnC9yJ7NXsfkgG0zUMk2wur5P227DwDbotRzv17N1tonJS3uc37ERyt/V3i6ioscuSiUk58Ug3B9TtxT0haBxniHzpsSkJxHNMAyKqaTqmcmTe+jzKe9yC+ZZDZPWrXq/BgKfJB44G5e9Og+hJ+OSrg8gwO8MCrsj7S4PyhpHtndusXa2KdZ6QFFRAAuZlsAhGYo+8jkf2DmMGfA7EFZrYulf+9bSuEu8iPpWcpxV26Zc5jooAr2JI5kvIR55QrDSbVhocP0YHTJJ/vZ4FlXF5wHxQpaJjnMxS/P0EpeOY7R9L4xOuSnyiiDGOxpNsnWbMdlP/04IXTxmWhpy5nbZqiQ+TedcVNF3KTILmt0MZV172kJNPweHWik0djtJ1PTKIQvsp/wkowI1Ym/j1cmzCyaY7U3rHuOEQHGD6E7kilc1le1vRFkqRbh/sKxTAN0PII9vnqGQ0TRIy00NsBpnDS2CuY87J4fOXQ0K4goJpJ9guT3FDvQq1Z9Rujr3JaQ4L3vlZCiNbRvsixK6fNJfjtNErj1MEC9aytjbtxML+Gqk8C82ZbRbSzwcFHJ1nb2smiN8TRSOcnx+TEVTGpPw77MLfmaIWxpeHJvi59il+0MAUc3Bl4ElkX12B3zIlkk+Ie56udOpvl5+sBD1Ttc8/yXvcJVvnIT7814CGYfwNfVHDrALNmzju6vgLxU8tFmbiKGmHkXOaqwWpdnJJhnWVuu8KcTX9NWArDU5D+lNqR
 RwhjApJs
 OTurg5TarisC0HKCHJEFiUaiVZn0W8twVn9LDGvJlSZ3X7ovEvn2SbfOt1Ce83H1m9AAycCmqpcWNljTjSZljxVH6dWSUbzqOL4dxIGLP0Ns7jacVI6KrNX5XA6HmWgVxHCQ74y9drhqc0Lga7iK5z3MzS/HbY9eWPSfloS6uNmBASUnj1O6JHlg/N+CZH1FlUaAyoNOgjxbsK3f3UyuLgSqrpwFP7L5ueclG3RJof+v1mdzbRByCed60Yup6Cr4w9MStd/7sXrUtvmHItTrj6Nqkz069i0gbyNHgD/k2ej21334P2psKrZLCSgDfQYfArYlhefhSSYYRKnl1NQHyfICEMj8w2XYXBqK6mV/jQ6OQTXwwOxxXIMG3L4bNapftDilADBIwpPpKSw959goqh2zYwZ1xwav1E+ri9IiTrscYA4+8sYh4kMqxcrrIGoFC9Y48w10jIba7QGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/7/25 18:11, Alexei Starovoitov wrote:
> On Tue, Oct 7, 2025 at 12:46 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 10/7/25 07:25, Kuniyuki Iwashima wrote:
>> > syzbot reported the lockdep splat below in __kmem_cache_release(). [0]
>> >
>> > The problem is that __kmem_cache_release() could be called from
>> > do_kmem_cache_create() before init_kmem_cache_cpus() registers
>> > the lockdep key.
> 
> Hmm. If that's the case then alloc_kmem_cache_cpus() wasn't called yet
> and s->cpu_slab == NULL, so any kmalloc/kmem_cache_alloc from
> that slub will crash. The above sounds like it's a race condition,
> but it's not. It's a weird error path in do_kmem_cache_create()

Indeed.

> due to syzbot pressure.
> So the fix isn't quite right.
> There is no need to sprinkle #ifdef all over the code.
> 
>> >
>> > Let's move lockdep_unregister_key() from __kmem_cache_release()
>> > to slab_kmem_cache_release() and do_kmem_cache_create().
> 
> I wouldn't.
> 
>> Thanks, added to slab/for-next-fixes
> 
> The following is imo much cleaner fix:

Yes much better, I'm changing it. Thanks!
> diff --git a/mm/slub.c b/mm/slub.c
> index 584a5ff1828b..0a1fbddb77f8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7693,7 +7693,8 @@ void __kmem_cache_release(struct kmem_cache *s)
>                 pcs_destroy(s);
>  #ifndef CONFIG_SLUB_TINY
>  #ifdef CONFIG_PREEMPT_RT
> -       lockdep_unregister_key(&s->lock_key);
> +       if (s->cpu_slab)
> +               lockdep_unregister_key(&s->lock_key);
>  #endif
>         free_percpu(s->cpu_slab);
>  #endif
> 
> compile tested only...


