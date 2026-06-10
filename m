Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40592CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850BA6B0093; Wed, 10 Jun 2026 06:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D98C6B009B; Wed, 10 Jun 2026 06:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1916B009F; Wed, 10 Jun 2026 06:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55B3F6B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:36:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1FB31652D6
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:36:47 +0000 (UTC)
X-FDA: 84863649654.01.29B521C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28D1A4000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:36:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZ6Qtz5g;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQTUqMitfqK5SwCaGpDybdGAV/jF7E+YCtgF5UZzAMY=;
	b=IVI0GL2FuVJupAtZ9hCnQMrvKnmyJOTpS4XpWZgDqDRgechEatBKChCbabJDjp6L49rKMQ
	9u9n5upzbaiHg3bMCgxa/VCHCsfX/I/JsfEkF/E+uaIZ3tBakVfWlYjU9F+BQmd7rGpXw9
	bj54KJaBrpT1wU77CTvRaETNOETNEHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZ6Qtz5g;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087806;
	b=5NkU6RDDo+wGS21KLYjLjCo9ndMIo3kgQCM1+eydQ1XX0Ek5dBWw3MVZQ6KmFCInHSrQ6b
	bnAouiaJA3cvVV56RQOjm7XFnX1V4Mt1LJE6CW8MNK+fyqsiJCduhcSBB9EbGGbz2Ld/C5
	F6AB9DuEYdaq4qyXWi0urEp14bdcLDE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19B9A44153;
	Wed, 10 Jun 2026 10:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1821F00898;
	Wed, 10 Jun 2026 10:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781087805;
	bh=CQTUqMitfqK5SwCaGpDybdGAV/jF7E+YCtgF5UZzAMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EZ6Qtz5gdMn6joD4fDvudVD1fDvvX0o+8W89oZW7JfLsZpzbLBCwlOA8Voq9iO/kr
	 aA14LfnEBNTbSyb1xHTkXJqMoGDF22+Bf9h1BARo8/KUGW8pA1nI6GHcXGjCV4yXhF
	 YFcBaCbIEYsFWokpBZyTpNxNofl4tKiy5is7YfjRBsgsycoY7oU9oFWX6nbh0KvZwE
	 mikZKysht9uP2cvN0kQd0mKgq7MUe9MaMTVbTq1bIWtHpe5Ohd/fFqdhAr+pXWVkKA
	 jk+otMGHmjLlbM3VfnjBA7Kd1vMIMNFApuCKn4FVask8SpRTVlp8sRns6tfAKlXWiu
	 7mkbtuQaCXBkw==
Message-ID: <ba9f23b5-6133-4bf2-a71d-4449d53912c5@kernel.org>
Date: Wed, 10 Jun 2026 12:36:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/15] mm/slab: always zero only requested size on
 alloc
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <20260609-slab_alloc_flags-v1-1-2bf4a4b9b526@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260609-slab_alloc_flags-v1-1-2bf4a4b9b526@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 28D1A4000A
X-Stat-Signature: upc3i41s9c8yqn9kcczra9agmaefwfra
X-Rspam-User: 
X-HE-Tag: 1781087806-159630
X-HE-Meta: U2FsdGVkX1/bl0WB8IIsgU/0HxVHLwcZDN5OStRKu/gJe3Ds0iLJCj52UCZA7NryJYdo+toRn05u+GiGc9H3iMo9Yn8I4/TEzdgKYrMJ5hpWKMCzOF3ZENfi8Lov+p6xJr5F8DR0UMIPAwkh4S9eViHC+0RwheQwUx4pU2kfIisSczMiAyzRMtHILZrMZsIkYlp07EblKe1PcasTfXw4mFM15HlTVPe67qV41AMV7Y66ml3bL9SHhB8tU/7k85UsfD6dHkgOk/sFM6ED+phpkHUJY/sNmc12VMPKVQResRnJ4A3BwPLlAoG3akEWhhMEMMWSAA5cPNQ1Zfj60ebgBoM0/5ZhlXXjmhQ4vVkue/Mb8u1zjhphQmYXTPIdZ7/rpK6SfnrYLG0kuX9z6a9DMh6q5/cBshbU1ggQqLDJ5wwMz9/NyxrEvOAqfzo7jT0mujxEgIWtD0NGjW3Bb6Lj4W4huQIGpHqhdS4iAVt3ySwD1Ckq/5Xjriwc21HCTTLiJkDQl+WbO/3Xb41IU27wiN2I/lX7I+ghVSgSL9J/rxc8QMlnlMBlGWRuCtRGoLzmJT+VJpxAMrGwDISHtGvNxJp7DF8pwyWKR8Css5IwfNTrZexFcmbksoaTtE6lsY8Xl4+osavEJOix8NPbWS1GAV6SdijKL7m2bauhLp4/vKarrFej3Rxs8ufx8kPfhMLIsTUJn/H1PtKvF0/zAN7UUc9aY7/d/uYS0PelxxB3x/dwKs8I6GMJ7SnT5gRXGRsT0lPtvBgXrbvIwO+7LCPMnOkKkfAfPZBDm++ms7LpVXNMQA/aE/Dzrp8xzGOnnLloEPlqtzWGIvUEe+VT5tGjrdtWzifRF3KF23qkHTmu5y1LB9W3w27TpKIvurChOABzMoitFViNmBPA9ApuoObrJ8ybBaaOpMzEsiLJURASbnXmp4mrKxX6lovOoH0Or2v+0ZLbdFhX5WuI5uVjK+x
 WbjQdaS1
 qlr3qo3A6BM3v6wnEs0DXmVxG6+BiUT82pesB/ug2JPs3WqsCEF1AnHSfrXhExhQW5lLqYJtEBy3/asqdzkJB2tHrhiSi0JC0CUkI1WRoblsr2ymM1nnjOVQi3eZKYRi8FQC0ZMIWjjYuCdKNK9kilTj0ibSuR/iUuAQhd0n0LlhEe8vd/6Cm5QZNfrfD8uMtTQ4giKrt2tf4YfS+pZIjYsbDyRQ2lo2y4mYjrQKfomg3uUzCPRIiqSfgxOpiHeMtsEj26POnFUd7DgvLeb8ltwLnMkkXTpJMiNQP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 11:17, Vlastimil Babka (SUSE) wrote:
> When zeroing on alloc is requested (by __GFP_ZERO or the init_on_alloc
> parameter), we have been trying to zero the whole kmalloc bucket size
> and not just requested size, if possible.
> 
> This probably comes from the past where ksize() could be used to
> discover the bucket size and use it opportunistically beyond the
> requested size. This is now forbidden and enabling debugging such as
> KASAN or slab's red zoning would catch this misuse. Therefore, nobody
> can be relying on __GFP_ZERO zeroing beyond requested size.

Well, Sashiko says I'm wrong because krealloc() might be used later and then
the initially unused part might become used and we won't clear it because we
don't (unless slab debugging is enabled) know the original requested size
anymore. So we have to keep zeroing the full s->object_size in the cases we
currently do that.

> Theoretically it might still improve hardening in case of unintended
> accesses beond requested size accessing some sensitive data from a
> previous allocation. But then, init_on_free is probably used also for
> hardening and would have cleared that.
> 
> So the usefullness of zeroing beyond requested size is practically none
> nowadays. The disadvantages for doing it are:
> 
> - Interaction with KFENCE, which perfoms the zeroing on its own because
>   it has its own redzone beyond requested size. As a consequence
>   slab_post_alloc_hook() has an 'init' parameter which has to be
>   evaluated in all callers (via slab_want_init_on_alloc()).
> 
>   For kfence allocations in slab_alloc_node() this evaluation is subtly
>   skipped over in order to do the right thing. Other callers (i.e.
>   kmem_cache_alloc_bulk_noprof()) evaluate it unconditionally even if
>   they do end up with a kfence allocation. This is only subtly not a
>   problem, as those are not kmalloc allocations and are using
>   s->object_size as requested size, so it doesn't interfere with kfence's
>   redzone. There's just a unnecessary double zeroing (in both kfence and
>   slab_post_alloc_hook()), but it's all very fragile and contradicts the
>   comment in kfence_guarded_alloc().
> 
> - Interaction with slab's redzoning where we have to limit the zeroing
>   to requested size.
> 
> We can make the code much more simple by always zeroing only up to the
> requested size. Move slab_want_init_on_alloc() call to
> slab_post_alloc_hook(), removing the parameter. Remove the red zone
> handling.
> 
> For kfence's zeroing code, update the comment. We could remove it
> completely, but due to possible interactions with KASAN, there are
> configurations where neither slab or KASAN would zero the object,
> so simply do it in kfence. At worst the zeroing will happen twice, but
> kfence allocations are rare by design so the cost is negligible.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

