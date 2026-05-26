Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4F8CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE686B0093; Tue, 26 May 2026 09:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968C06B0095; Tue, 26 May 2026 09:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FB06B0099; Tue, 26 May 2026 09:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9A36B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:53:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 106D31C185F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:53:02 +0000 (UTC)
X-FDA: 84809712204.04.B93BACB
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A9F04000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:52:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779803580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGMUYuxe7Z1l80NC4Hgpa1Aqgb0BcOkycA8OObckoz8=;
	b=DZikoze0qOzz+f2TKH3cs+dD7+x45YekaAJGaypgU5sw59fLTxH0TDmMgF1CL+nf7/9Hbg
	zXOJtfmkccN5/tCDCNGJ4Qe2FeQV7Gm3KT2pJASRE6dRY1In5TEgaHzd6+bSP71mq1POcl
	jdOJHnfMkfC85l9ZquSuK8ZyEXMJvJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779803580; a=rsa-sha256;
	cv=none;
	b=5CcbBO5f1EwYGl1/wsaN8mokTnwpI00P5ZJTjB4i76R4hdFPnmI5Uw2JMRGJgLGXfBhrQq
	o7oJnugxR0u5u2gQb8mz9aOILX4KGGfzXfdQac7C4GgTU80aAyGcavp3FpegqZf9Ac9C4K
	Fdq/ulyA7GgFwphRJ6rlNLoxieltM7E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gPvMp5W9Zz5BNRf;
	Tue, 26 May 2026 21:52:54 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 64QDqnbb029921;
	Tue, 26 May 2026 21:52:49 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 26 May 2026 21:52:52 +0800 (CST)
X-Zmail-TransId: 2afa6a15a5b4d4a-86bd4
X-Mailer: Zmail v1.0
Message-ID: <20260526215252256uhTBtz7781U8x3UhNgmY_@zte.com.cn>
In-Reply-To: <799bdd0f-2771-4fad-8617-fbe4165689d9@kernel.org>
References: 20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn,799bdd0f-2771-4fad-8617-fbe4165689d9@kernel.org
Date: Tue, 26 May 2026 21:52:52 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gbW0vc2x1YjogZnJlZSBwcmVmaWxsZWQgZW1wdHkgc2hlYXZlcyBjb25zaXN0ZW50bHk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64QDqnbb029921
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Tue, 26 May 2026 21:52:54 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A15A5B6.000/4gPvMp5W9Zz5BNRf
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A9F04000C
X-Stat-Signature: 8ig7t57if4xkm1rufi6tsupkbxcfgdp1
X-Rspamd-Server: rspam06
X-HE-Tag: 1779803579-758339
X-HE-Meta: U2FsdGVkX1+8ule07IMLp/avcT0GVna5n8nElZOfDccqXBaWgfmBdiuyRPCX5x9w8yRBCCLt+ElokPD2lZbrvvCfDtKaNfiY1+D9iJpJ6dtKAIAnYoQVs0WOtem3qLokKTnd86JAyWuRfPlBf8ZKV0oAq3A7rjvb0eOhqaKbGpEwbsEwMQLZROY8ke4Ggw3arPfOzwCT6qTh2cYNjaikbapGDE5x8pLy1h1vuX+kCdLc+feETSCkMdtGMeO4rA66VHaYtkKdNlCFlnZO0wWVf6lBU+JgTNUecKpmroL1NQxElBbZ/qWrSfJy7j4EuucX/LHO25pmIjy8GQNW5Xe5yEFV+RE07nbjtc4AZKI08lDpTkceOrHl5S02MmxQ0q5Rlr9dkawCKYHVP93N5mxwFGZoSoZk63P0Z/dotWF1qOXMFB5/1BB+2Nr3ZyumwNV+dm8fvvrza9MYQTMIxAQ0ZmtlobiasRxfq3civOVZ7qfThCIHSb8VFguxqT/B6651yL3jI1m1KYSyAlQbVl99ZzE8fGtZeSMt8A82/4e2B7iYOp5jidcGleQB2rNLyUcOU/FeiE76/vuW/qWZpwbEpsGq6psdMmXmvaP5Y6LUykh7rxB2lZbDGMmMQZqWKXgHmV/u/KxojNgpyNaFFItxovp95yixls9hSkRgW3fmwqkZXUtiYCJ9jm3CTCRhcp7mbSNTzB3Hr4dNNxowtwk0uLDyZCIJm35ycUHYxW3LGmh3COSCQXtsAbC6zSzCqLwy0sdF8tlJfr9qD8UQMzzbaTSkfmT/OlWhcCFHY5GmvuXlvXWKYutcGCz5/GyE4OOdr9zcWbKzDEfTjwDkKgzBaAi+UrN/nzL2a9llugg7aY3V5bm4DvWuLj8I/Iug2f3sLHUkk33KrLIna/nzJF8g1uCfRDIv3IChKXkaChG77EThK8BexTWXeJ6IdCxjp70rM3z2wPoDYjhfIOiqafQ
 FnZS2sib
 j4JVzk7rY9ILyv3yhW3j86rKL1YSGpdso0yHD/Xwvganp9ug+g1bttpHSsKQtlVkkB7ito41IYPdmYGCGYEpvw8PJol43DHGhQ0cY1q0nKjGURuTEGg6BXvDIt78v/JTENhYtXanWk9j8w3nJqr9Atovljg/sWlT1XIfiJwLw8NgG/f6qKZyAjtjqiFuvSJGqIzsnko/bqlIU3jepsN8WQBCg1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry worte:
> On 5/25/26 10:10 PM, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Empty sheaves allocated by alloc_empty_sheaf() should be released with
> > free_empty_sheaf().
> > 
> > Move the empty-sheaf capacity initialization into __alloc_empty_sheaf()
> > and use it for oversized prefilled sheaves as well.
> > 
> > This keeps the prefill paths consistent: after flushing an oversized or
> > pfmemalloc sheaf, release the now-empty sheaf through free_empty_sheaf()
> > instead of kfree().
> > 
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> >   mm/slub.c | 13 ++++---------
> >   1 file changed, 4 insertions(+), 9 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 04692a6f9128..f4c06bf43f2d 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2782,6 +2782,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
> >           return NULL;
> > 
> >       sheaf->cache = s;
> > +    sheaf->capacity = capacity;
> 
> the capacity field is only used by oversized sheaves (for now).
> It should be outside __alloc_empty_sheaf().
> 

Thanks for the review.

That makes sense. I will keep the capacity initialization in the
oversized prefill path.

> >       stat(s, SHEAF_ALLOC);
> > 
> > @@ -5015,21 +5016,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
> > 
> >       if (unlikely(size > s->sheaf_capacity)) {
> > 
> > -        sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
> > +        sheaf = __alloc_empty_sheaf(s, gfp, size);
> >           if (!sheaf)
> >               return NULL;
> > 
> >           stat(s, SHEAF_PREFILL_OVERSIZE);
> 
> So now SHEAF_ALLOC and SHEAF_FREE include oversized sheaves.
> I think that's fine, but can we update the commit message and the comment?
> 
> the comment:
> SHEAF_ALLOC, /* Allocation of an empty sheaf including oversized ones */
> SHEAF_FREE,  /* Freeing of an empty sheaf including oversized ones */
> 

Yes, I will update the stat comments and mention this in the commit message.

> > -        sheaf->cache = s;
> > -        sheaf->capacity = size;
> > -        /*
> > -         * we do not need to care about pfmemalloc here because oversize
> > -         * sheaves area always flushed and freed when returned
> > -         */
> 
> the comment is still worth having?
> 

The pfmemalloc comment is still useful as well. I dropped it too
aggressively, so I will restore it in v4.

> >           if (!__kmem_cache_alloc_bulk(s, gfp, size,
> >                            &sheaf->objects[0])) {
> > -            kfree(sheaf);
> > +            free_empty_sheaf(s, sheaf);
> >               return NULL;
> >           }
> 
> -- 
> Cheers,
> Harry / Hyeonggon

--
With Best Regards,
Shengming

