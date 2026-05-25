Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB347CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A0B6B0095; Mon, 25 May 2026 03:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41616B0096; Mon, 25 May 2026 03:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E746B0099; Mon, 25 May 2026 03:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B87C66B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:39:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 670B0A0199
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:39:59 +0000 (UTC)
X-FDA: 84805143318.23.7A00A37
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08ADC1C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:39:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779694797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EuMSzJ5+0yJTZ3ktprxRVTomVlmhM29P7TZnU/wdGQY=;
	b=nGV9VqeZbAqO5yosLrH3ACNtpTeV9uiwLqv780uLhBIkyoHYHveVANHzBasW9soQnx0HqE
	XO7giUjRWonUzGcUm2JR4nSdj52aNrgdtHfKm1eUWdV/u1RKE4RJfNzZ3QcxxBl5vmd9zZ
	IfYNxkAWpKrkF85l87a+pG0gV3Cu/ws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779694797; a=rsa-sha256;
	cv=none;
	b=21/AKLgMiMEtlL/6s/TVnphpnmr8/mKJYqqZlPW8zBGhB9ylHSAbq0r/brLKV3KCEEWl0V
	W8XbzMxZgJjQ8lnZrBgEo79BRZg7VFT9QY+5SrN/jOQ3LYOfGlqukSBWRhpHD29s9Wcfyf
	H7jiINTJitH/7jnWlUjHCwfNctqJJdU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gP77t4Rlcz4yjjH;
	Mon, 25 May 2026 15:39:54 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 64P7dbZS091500;
	Mon, 25 May 2026 15:39:38 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 25 May 2026 15:39:39 +0800 (CST)
X-Zmail-TransId: 2af96a13fcbb849-ccf84
X-Mailer: Zmail v1.0
Message-ID: <20260525153939906oYxXCclwv-YEIFEbZ-iXn@zte.com.cn>
In-Reply-To: <ahPsR0YTfhgQnmwQ@fedora>
References: 20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn,ahPsR0YTfhgQnmwQ@fedora
Date: Mon, 25 May 2026 15:39:39 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <hao.li@linux.dev>
Cc: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbW0vc2x1YjogZnJlZSBwcmVmaWxsZWQgZW1wdHkgc2hlYXZlcyBjb25zaXN0ZW50bHk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64P7dbZS091500
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Mon, 25 May 2026 15:39:54 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A13FCCA.001/4gP77t4Rlcz4yjjH
X-Rspam-User: 
X-Rspamd-Queue-Id: 08ADC1C0007
X-Stat-Signature: mqt5ngw9spkfzhnwehrw35pfde4dqn6o
X-Rspamd-Server: rspam06
X-HE-Tag: 1779694796-256737
X-HE-Meta: U2FsdGVkX1+pn0BWTwJDv7soxn7/P8ue4p/32RbR6wDOgJjFnw/oyMNaggwQBQ4F0/EGUNMztpJYNtc2FPTZ77NNII2n/O+ytz7nieeVAI5dHQ4047nwxGA4WOxtY/y3rtnUHaIpME+sDl2yuEWtuLJcI7X8VJS2EsnFc3ubj4E8mSttmwZfHNpCRhooR1kNWB/uLOdjE0fYXLGWLc1FhwdrWMrOthikTqT/xxoh6Za3qfRTbJOW7jEOAoULxY0uk0cKXUbd3x5UOk5+O8oy8iAZG9N9NGq9cQoJslUGnj/OU3fg10iTe34BGwah6hYF0+dV0UJjGsgW5sneWKYYoc7TSKXh/YFS3C7MiLUD2YN4A0eM9dXnAAndbkJBKABIeBljiOISMiGsdFQ6rT07s9gLQ+UrRONghEsIaD6dDi+Vr8OgEsXicTmvQm4LBTF2Go6psXHPTBB7fV86l3mxg0wZdsIJVvAZDm3ygb8wv6vjRiOwIqAGNdYwYe7rM++WCPsV3/ZupQFSUat31xRk2wPImvnMQA2jKbV10jcAh3N/4EDw3t0aHAdqTbwt0cc1Rm+vIeYszrib+RZuagPIWMN3RKtzQRXQ3qESMm5JUqg9ZUuT7b2n2fG7Nlcn00RAgIXvLCEShecgSYaQPYZcRsa+eCco94Ixa9s0UZ7TJ1EdacKa6x/tF7OiwkJVPUGgq1PWy2dLeRKzWv+j85RjeyNt2GzIEhLUlw4kj5FzCrAR60KgXCLkGiHqyp1xe9SMczZv7BjvPGTxwDTGcsFCbF/EkfsPylkJ6lmMU/VS473GqWQsip7kPTRpmYvlQ96MZILG75SM3qvAnul236OsBrrmOVImaFP9ch5M5WNwp6PD5YHoEIiJPypRwwWFNNBiQKjIaomJZiB0/ZEarBXp0pIu9A0dyvwGV86n8fV/7+5TcvUazUMI1YSmZUS6CgtulaNBSrPs8bYAzXsUZuG
 vlaX9iU7
 rYn+BvgABu819ykHn1BQoLr/jaWCjW+b9UjBrdBEz60kNEARc2MtPsL5fWaOLcjgnPV8gL3D0F9tTQm66taTKswsCcFm3+T8NwuFalu58gISdFYp1HgC6A7q6fDF5CZW40anKnp6wUyRZqsSuFjHRR1cy7iMkJKJXSC3+lUGK/P58NCEsSilIVGjDkXQFQCWAlnCpzWtURJDu3cGLvCzh+VI4c47lB5uecIWJu63GHtpkQZanzmT68IRBXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hao wrote:
> On Fri, May 22, 2026 at 02:59:00PM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Empty sheaves allocated by alloc_empty_sheaf() should be released with
> > free_empty_sheaf().
> > 
> > Move the common empty-sheaf initialization into __alloc_empty_sheaf(),
> > including the capacity and default pfmemalloc state, and use it for
> > oversized prefilled sheaves as well.
> > 
> > This keeps the prefill paths consistent: after flushing an oversized or
> > pfmemalloc sheaf, release the now-empty sheaf through free_empty_sheaf()
> > instead of kfree().
> > 
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> > Changes in v2:
> > - Rework the change as suggested by Harry.
> > - Teach __alloc_empty_sheaf() to initialize capacity and pfmemalloc.
> > - Allocate oversized prefilled sheaves through __alloc_empty_sheaf().
> > - Free flushed oversized and pfmemalloc sheaves through free_empty_sheaf().
> > - Link to v1: https://lore.kernel.org/all/20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn/
> > 
> > ---
> >  mm/slub.c | 17 +++++------------
> >  1 file changed, 5 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 04692a6f9128..bbe8351f1bfa 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2782,6 +2782,8 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
> >          return NULL;
> > 
> >      sheaf->cache = s;
> > +    sheaf->capacity = capacity;
> > +    sheaf->pfmemalloc = false;
> 
> we could eliminate `sheaf->pfmemalloc = false;` because the allocation use
> kzalloc.
> 

Hi Hao,

Thanks for the review.

Yes, I agree that `sheaf->pfmemalloc = false` in
__alloc_empty_sheaf() is redundant, as the sheaf is allocated through
kzalloc().

> > 
> >      stat(s, SHEAF_ALLOC);
> > 
> > @@ -5015,21 +5017,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> > 
> >      if (unlikely(size > s->sheaf_capacity)) {
> > 
> > -        sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
> > +        sheaf = __alloc_empty_sheaf(s, gfp, size);
> >          if (!sheaf)
> >              return NULL;
> > 
> >          stat(s, SHEAF_PREFILL_OVERSIZE);
> > -        sheaf->cache = s;
> > -        sheaf->capacity = size;
> > 
> > -        /*
> > -         * we do not need to care about pfmemalloc here because oversize
> > -         * sheaves area always flushed and freed when returned
> > -         */
> >          if (!__kmem_cache_alloc_bulk(s, gfp, size,
> >                           &sheaf->objects[0])) {
> > -            kfree(sheaf);
> > +            free_empty_sheaf(s, sheaf);
> >              return NULL;
> >          }
> > 
> > @@ -5064,9 +5060,6 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> >          sheaf = alloc_empty_sheaf(s, gfp);
> > 
> >      if (sheaf) {
> > -        sheaf->capacity = s->sheaf_capacity;
> > -        sheaf->pfmemalloc = false;
> 
> I think we couldn't delete 'sheaf->pfmemalloc = false;', because the 'sheaf'
> pointer here could points to a normal size sheaf via the `if (pcs->spare) {}
> else {}` statements above.
> 

You are also right that sheaf in the normal-sized prefill path may come
from pcs->spare or the barn rather than from a fresh
__alloc_empty_sheaf() allocation. Therefore, the pfmemalloc state
cannot rely on the zeroed allocation there, and I will restore the
explicit initialization in kmem_cache_prefill_sheaf().

Also, after looking at this again, I found that capacity needs the same
treatment.`capacity` and `pfmemalloc` share storage with `rcu_head`/`barn_list`,
so the prefill-specific fields need to be reinitialized whenever a normal-sized
sheaf is reused as a prefilled sheaf.

I will restore both assignments in v3.

> > -
> >          if (sheaf->size < size &&
> >              __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
> >              sheaf_flush_unused(s, sheaf);
> > @@ -5097,7 +5090,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >      if (unlikely((sheaf->capacity != s->sheaf_capacity)
> >               || sheaf->pfmemalloc)) {
> >          sheaf_flush_unused(s, sheaf);
> > -        kfree(sheaf);
> > +        free_empty_sheaf(s, sheaf);
> >          return;
> >      }
> > 
> > -- 
> > 2.25.1
> 
> -- 
> Thanks,
> Hao

--
With Best Regards,
Shengming

