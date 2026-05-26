Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6D4CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 07:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F4D6B0088; Tue, 26 May 2026 03:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF3A6B008A; Tue, 26 May 2026 03:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EBF6B008C; Tue, 26 May 2026 03:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93E886B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:12:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D65C1C019D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:12:19 +0000 (UTC)
X-FDA: 84808702398.27.FCC4A41
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8312C40008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:12:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779779537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJXi80O1UGq4ef8XtxrDZzlC47Nq7xtC18QhavwLv1U=;
	b=qBwfXgK/emijt/haCOOC7xQWNfHt/aOy57t5QZoNmC+YqfXD9iHHmdwiRxVOXUBgLZsJeQ
	yvboB0BM2eKE8m8wuC541QFsGay6oB9n/er2VMBuI4Sn+0kXNkAzN4bs1T7daOGpxy74il
	opiLmy3uKBc0dpvdVXYQHtP9aAfjDzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779779537; a=rsa-sha256;
	cv=none;
	b=aFgG3CBWzH/5pEeyrjgS7yutW0X04SRmKYrTCqrGoxRxKf1CCukwCMGxdf51hsDrspcMQH
	+A9kUTqCA5rGGQViIpl1wgMZv2WZoZmuhPNGNuFh0Kzyzitn8xy22j0oKxzN0kiADBtCSs
	AodMVt+usGZxCGSjy22bUBrOBoNrdXg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gPkTH75Rvz51Stv;
	Tue, 26 May 2026 15:12:03 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 64Q7Bv8w008025;
	Tue, 26 May 2026 15:11:57 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 26 May 2026 15:11:59 +0800 (CST)
X-Zmail-TransId: 2afa6a1547bff29-4dfea
X-Mailer: Zmail v1.0
Message-ID: <20260526151159456kRq8QhhwO2mb6qdqY2_L-@zte.com.cn>
In-Reply-To: <ahU1JTiy27FI9QaU@fedora>
References: 20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn,ahU1JTiy27FI9QaU@fedora
Date: Tue, 26 May 2026 15:11:59 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <hao.li@linux.dev>
Cc: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gbW0vc2x1YjogZnJlZSBwcmVmaWxsZWQgZW1wdHkgc2hlYXZlcyBjb25zaXN0ZW50bHk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64Q7Bv8w008025
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 26 May 2026 15:12:04 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A1547C3.000/4gPkTH75Rvz51Stv
X-Rspamd-Server: rspam11
X-Stat-Signature: 5ie9qk49oyax5namhddz3uhaqkw6k43c
X-Rspamd-Queue-Id: 8312C40008
X-Rspam-User: 
X-HE-Tag: 1779779536-337340
X-HE-Meta: U2FsdGVkX18XRBRWFM7WTeNvVGU6rKAFUqaAkwJT3W5IGuRpdXkCiZsSpNTq45Fa5vskDXW+6IZI2Z+jyFULYrecZ1pU3qgvEspI+zlMxV76l+jVYil3F1APw9AvT5HFYbzUmIbZY7y2+tXqruW234llzJ0dpWij+dDjj5IQhfRikDUUOnWmEXFuzM2UnArACGva8wzcYCOEKgWqzWcMrJx2i5HfXyPa4LBf9EosEWqdHk5BFiDsG220F0+KNi4dBsIIxklsAqb1cIKew+xPv0ZKe2w2qzWY59Zq6JJkOchHwl77OJD67U+yRNichdUqWO4O/MkePexEJsLjWxqF3gRH5YUYnfmNUpeRWnt72dMvr2+Lsl7u+s8yTX7L6/OMzQd+RIUD0clX+EjU3jleBNcOb6wC4TXMUyUi5TjHZMJ6QV4bv85O4PqvoHchq+12nzPM5du3EUR5E0/MCaUUkrwmEgQAfB4sN0DBwh7eVx4F22vhV6a0tpIT9PKldyVRPwRUcSYEAcB+R0t0yA3PqjN+2XGtRJLKEI5siyBF1PWQlPCvFPDVQv/N4PU37rLU/gOuwlAl/ptxMZ8NAQo+NzzXOj76BFievgjdB5Q7loYC6QJp9FBN2WpCHkbDqZybjnuunau7ydb/1NgB1Ugp60t7TaPEm+u8VT9MHG1rgCH3wzjcCQJAdmllU8aF7zrGbTXQ3kskxPhjn5b66qB0vJ3Hpp0h5fkAkkadGMpYYlTtF2u8ZrbXhx2An992buBmQ7d0vgFDCFDPshJtIQJUWZcDciyB9pjD5zQ1GLWSq5kcjS1MKoSzqbJl568nmxkAepgQyDZNMhrUyVWfDtNiPnNqAW4A0rnjJjhzLy6NM6fVLr1cAvqYY8N5p/f9bVhH+febQVa/pCkPL53BbgPQpuGTXWgajaH+Cq511Jf8wLz48FqB8/x3TODKxVYWPUukWpgYOfzDMViPfKo0sK9
 LYXe5XfF
 ZYpEHKX4Ew3CB6/yygIjQrbD2QfXOyrtfb6Nbei4bE88LhY074hOPK4FT741lmoVlShR9uBPsUYQIQAgW+aGEnsclCoPu4OrA3E0XAzEpehaCqJBS/S8veSABh+ocdVrt2JosgjNHh0BeWCr3W9EWGLx6NDEbyTWoaGyK8uAZCLu7B+kN/krt4AXW39MdQ9f8m5BWrNMUPfVj/CAeE/c0UsMS/AZ6XSYQqXiTVZSPUECYl8BOBYAHmfjifw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hao wrote:
> On Mon, May 25, 2026 at 09:10:00PM +0800, hu.shengming@zte.com.cn wrote:
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
> > Changes in v2:
> > - Rework the change as suggested by Harry.
> > - Teach __alloc_empty_sheaf() to initialize capacity and pfmemalloc.
> > - Allocate oversized prefilled sheaves through __alloc_empty_sheaf().
> > - Free flushed oversized and pfmemalloc sheaves through free_empty_sheaf().
> > - Link to v1: https://lore.kernel.org/all/20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn/
> > 
> > Changes in v3:
> > - Address Hao's comments:
> > - Drop the redundant `pfmemalloc` initialization in
> >   __alloc_empty_sheaf().
> > - Keep initializing `capacity` and `pfmemalloc` in the normal-sized
> >   prefill path, since the sheaf may be reused rather than freshly
> >   allocated.
> > - Link to v2: https://lore.kernel.org/all/20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn/
> > 
> > ---
> >  mm/slub.c | 13 ++++---------
> >  1 file changed, 4 insertions(+), 9 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 04692a6f9128..f4c06bf43f2d 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2782,6 +2782,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
> >          return NULL;
> > 
> >      sheaf->cache = s;
> > +    sheaf->capacity = capacity;
> > 
> >      stat(s, SHEAF_ALLOC);
> > 
> > @@ -5015,21 +5016,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
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
> 
> just a bit curious, why did you decide to delete these comments?
> 

Sorry about that.

I removed the comment while moving the oversized sheaf allocation to
__alloc_empty_sheaf(), because the local cache/capacity initialization was
removed from this path. However, looking at it again, the comment is still
worth.

I will restore it in v4.

Thanks a lot.

> >          if (!__kmem_cache_alloc_bulk(s, gfp, size,
> >                           &sheaf->objects[0])) {
> > -            kfree(sheaf);
> > +            free_empty_sheaf(s, sheaf);
> >              return NULL;
> >          }
> > 
> > @@ -5097,7 +5092,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
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

--
With Best Regards,
Shengming

