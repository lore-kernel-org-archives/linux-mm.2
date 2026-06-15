Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14F9CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0BF66B0005; Mon, 15 Jun 2026 07:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD246B008A; Mon, 15 Jun 2026 07:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABD86B0099; Mon, 15 Jun 2026 07:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAC526B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:33:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 617DA165A31
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:33:11 +0000 (UTC)
X-FDA: 84881935782.05.0F7EA18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 805ED4000B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:33:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dfoH9/SA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781523189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7PxZJmxS0sSV48sfoCzYBalzdbBZzB0Jt54N/oU4Ns=;
	b=jEXC85nUomfToVN8KzCuqN0wUmZYfkmqsHDa9g/uPqT3iq7EOxuEN7wg69/huHGjYb/dUk
	lTYsNykSvyCZTRLSUIiUb7ZB/STytfxPXsigKbQrg0abAUXJxrMxdTx8OCkP5TxF6vKKD/
	ziNG6tut8XajgzTh5m660JJH5fT2J3c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dfoH9/SA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781523189;
	b=6/QAp3yylWi+FDmlDCcyLdg27ieKMkDR/4TwCwVP5xKv+8AWhYM+iiY+rROuY9VqNKD52a
	ZONgVJpgpPVd47gqOxDxOjR9YdcbBoJ/iKBsJP1df5LA+0PqJAbb0Jex+hGQclDErbb+QE
	CXDXG4VTUm6/OaPpUzYi5OmKt7OHr5U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66E3844424;
	Mon, 15 Jun 2026 11:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C487D1F000E9;
	Mon, 15 Jun 2026 11:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781523188;
	bh=Z7PxZJmxS0sSV48sfoCzYBalzdbBZzB0Jt54N/oU4Ns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dfoH9/SAlduQwCfauLK5I+jtrR29528OwQ4MFivcQCHFVmuRJ4b2raigfawBGm67Q
	 93aqHFP2lG/zWvHN2wcF7BPsRPmUgJ5uq27rpwSTUQWDIPi4OdNttOi9KIGZxYOPF2
	 LtFim5HXu1FoIXpnXU5FOuVyUF9GM7f6VGLVKxLvdU9C3ttpym79RUCFawp08q6tpV
	 TgS1Y0rbmXAnW6Y+hHiO8qurJLsZyXRIOBjIFYa9vVUGYIElSM6yG6/KaXksgpaJjX
	 g9Dq5drJ3Xoa93/P77RCsUzfRmSQWx384ZoRjG/sWSRkwTb5Lx7ABnACYgIH4OiGpe
	 rorzXLFc22Zow==
Message-ID: <e079b443-76aa-4b7f-a91c-e5152bad1af5@kernel.org>
Date: Mon, 15 Jun 2026 13:33:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/16] mm/slab: pass alloc_flags through
 slab_post_alloc_hook() chain
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-9-7190909db118@kernel.org>
 <CAJuCfpF0mcV3TUCNi981YO=uT=5p_7OOY1S6zdgwm5PMMV3w8g@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpF0mcV3TUCNi981YO=uT=5p_7OOY1S6zdgwm5PMMV3w8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 805ED4000B
X-Stat-Signature: 1b6ijtf5xsz9a1zs56immuyafq53quhi
X-Rspam-User: 
X-HE-Tag: 1781523189-784031
X-HE-Meta: U2FsdGVkX19qe+erFfG/agddgROK03NhqxyZ6ubFQkm6JKNsGqnMe6RjjH05QKffjMNJtSeS5rIHa3G8QDAAT7bhwdu4yI5Jj7BWViiClhbS4Qwx5Yq1trY9+LDoVs9qYDwbEPC8A2JR1b7Lp3pdkRC6OGzWJ7OLb/AjEd7qstM1af3/j0QkTz9/OUd6D3GqE7LC1BBEuioP/BsbgSIfhAhjVL5sIBtQIfFDbKHRMMXKj5LrYW2vQMwalYIiAROyjD/TsPLKakUwl9gacWUIuJLQOgDPkCf9AI1fvecTapj0xUn33rUXIJTclMHTq9yDMDkhLpklRAoP2o3OX9sxCKm67e04LMgncsi+QnFi1zZazIPZXjHgsxGl4zn97J7nHEKXtlqSborG5Zx4dPSMHlQlsMJa8GQzR8KFkkzWujNEP5m8vyqU1Jm+Fq8dr04DsJ3oGeD7XmUecru2ufqt/rjQw6EoKM425ad3YuLr9LKuaU05r8RX3PTnCDCi5rGI3uJWSsn2bCs/tm1Zlz0vHJUYNRdUhMISYHwvOOSRWmZ48xyBK4Ax6lP7dOTDXmztLz9tz+av+pkJTX4dSYQE4EFqENr7oki8cbVvhpQPByuanbhFTtE7VVLnQ4szIg/oKTUbTz7m9tgT+Yzzf2fSNrC4yKV4LhiTyOjBbcar/MElqn8GlPEjsjodvAVJ1OHQ3l7bofzNFutBdOPV9v6x3kNlp4eRBK94bsUe8todVF5yNI+leskJUt+ZDe7nigRLW0peXqUve4yuCNisQrOdDQ3bgIVu+3mlwh3JKcQit6XE0CNo5X+bx7DxJAF0l8MyzJlKCjABoQhXCPwV32YewS3Ftgu38MaRVhlrG07mwC6/UHZ0jzBoH4Ut7cyhUSDu7HUSmw+WHsngRldZDnIQ8/TTOK45kw9QP/48wMskfxMZW2ThdV1HsWVH//swtdfPT6h2P+BXsxIe6n4tpAg
 sWzGDHzW
 je38DU5DSJjwT74o6ASNRt6OUELnDJGxN+t23NdLDq2/OzPFpIHdbcsfpkvRvNNBu1UvWQor5zuhvVCbCFfjnnPqO3hh3v7OLeOSsZUqEBHQSHZ1fBWfzLgNhcGiEqlp61XFYSxqtU5Ufe64/liv2gk0IR4V/VDVZNSFpNiI29cwlMPXfnBsCAn9rCyjuV24wyj33JeK7th2AcaQlsz3ZCzoxgcsdDnBMAvkjVkgQHDjSrEUqZU763Kz/5xyBfF8JFW3cS0Rx4chSujCijrDQ44+KuVb9IV/XhvlAZZQ1yuC+QlD970f6T6rzf7Yd88P4ApWRCtONaOeCoIo8Ec0WgDMt+Ib92LXNW7BO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 06:35, Suren Baghdasaryan wrote:
> On Wed, Jun 10, 2026 at 8:41 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>> @@ -4568,9 +4577,8 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>>  }
>>
>>  static __fastpath_inline
>> -bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>> -                         gfp_t flags, size_t size, void **p,
>> -                         unsigned int orig_size)
>> +bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size,
>> +                         void **p, struct slab_alloc_context *ac)
> 
> Would if be possible to make this last parameter a ""const struct
> slab_alloc_context*" (here and in other functions accepting it)? I
> think these functions accept it as an input parameter only and are not
> supposed to change it, right? Makes it easy to veriy that
> slab_alloc_context is not changed between consequitive calls reusing
> it, for example inside slab_alloc_node().

Uh, ok, did that. Also changed orig_size to size_t.

>>  {
>>         bool init = slab_want_init_on_alloc(flags, s);
>>         unsigned int zero_size = s->object_size;
>> @@ -4590,7 +4598,7 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>          * orig_size if we track it.
>>          */
>>         if (slub_debug_orig_size(s))
>> -               zero_size = orig_size;
>> +               zero_size = ac->orig_size;
>>
>>         /*
>>          * When slab_debug is enabled, avoid memory initialization integrated
>> @@ -4616,14 +4624,14 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>                                      !kasan_has_integrated_init())
>>                                  && !is_kfence_address(p[i]))
>>                         memset(p[i], 0, zero_size);
>> -               if (gfpflags_allow_spinning(flags))
>> +               if (alloc_flags_allow_spinning(ac->alloc_flags))
>>                         kmemleak_alloc_recursive(p[i], s->object_size, 1,
>>                                                  s->flags, init_flags);
>>                 kmsan_slab_alloc(s, p[i], init_flags);
>> -               alloc_tagging_slab_alloc_hook(s, p[i], flags);
>> +               alloc_tagging_slab_alloc_hook(s, p[i], flags, ac->alloc_flags);
>>         }
>>
>> -       return memcg_slab_post_alloc_hook(s, lru, flags, size, p);
>> +       return memcg_slab_post_alloc_hook(s, flags, size, p, ac);
>>  }
>>
>>  /*
>> @@ -4918,6 +4926,12 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>>  {
>>         const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
>>         void *object;
>> +       struct slab_alloc_context ac = {
>> +               .caller_addr = addr,
>> +               .orig_size = orig_size,
>> +               .alloc_flags = alloc_flags,
>> +               .lru = lru,
>> +       };
>>
>>         s = slab_pre_alloc_hook(s, gfpflags);
>>         if (unlikely(!s))
>> @@ -4929,14 +4943,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>>
>>         object = alloc_from_pcs(s, gfpflags, alloc_flags, node);
>>
>> -       if (unlikely(!object)) {
>> -               struct slab_alloc_context ac = {
>> -                       .caller_addr = addr,
>> -                       .orig_size = orig_size,
>> -                       .alloc_flags = alloc_flags,
>> -               };
>> +       if (!object)
> 
> Any reason "unlikely" is removed?

No, fixed, thanks!

>>                 object = __slab_alloc_node(s, gfpflags, node, &ac);
>> -       }
>>
>>         maybe_wipe_obj_freeptr(s, object);
>>

