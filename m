Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7075CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5816B008C; Thu, 21 May 2026 22:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F0E6B0095; Thu, 21 May 2026 22:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916BA6B0096; Thu, 21 May 2026 22:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DBA96B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:16:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C5A0A0941
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:16:08 +0000 (UTC)
X-FDA: 84793440816.13.4DEBE2F
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F21240007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:16:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf04.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779416166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ltOH0Yux3nvkRW/OfBhiTUE5Ca+Fa16nwk1YbIFX/q0=;
	b=t72e2ZplKENu7bytQx1P8gIKxXTseGZsv5Furea0w7eEjTbLSQpFYF/roCLZQwaDMVHQ4a
	StW1aDgpGTJ+CpIr6P/eJ8dsgm50rPvRZhyY3TRSDRQ7TGZH9wd4M8TdUvghJ9/6oA86CL
	7k0oWqz/zCQXtbM2XU8qlDIsL5uC27Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf04.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779416166; a=rsa-sha256;
	cv=none;
	b=ieYtGL8nYlwocNpPsh7Yd6fNwzFo9+UewH/5nk0Uunnj6hc9jz+gGlgfDQ0bhC1oB5fIs1
	QFiPYx70LIj9cEnWaI/lY3CvwOl0j10dcO31gJ1xN1VEvL0USmOb3pyshj3BVGfGzZOSSe
	wn59jsddCrpmXmwomiDhIiPt9boCK04=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gM85W4X7mz51Srk;
	Fri, 22 May 2026 10:15:59 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 64M2FtCr050800;
	Fri, 22 May 2026 10:15:55 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 10:15:56 +0800 (CST)
X-Zmail-TransId: 2afb6a0fbc5c0bf-c567b
X-Mailer: Zmail v1.0
Message-ID: <20260522101556073hStdIqOTUdAZF4RW8Kt8g@zte.com.cn>
In-Reply-To: <13fd910b-e897-4a9d-847a-545267209bf8@kernel.org>
References: 20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn,13fd910b-e897-4a9d-847a-545267209bf8@kernel.org
Date: Fri, 22 May 2026 10:15:56 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogZnJlZSByZXR1cm5lZCBwZm1lbWFsbG9jIHNoZWF2ZXMgdmlhIGZyZWVfZW1wdHlfc2hlYWYoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64M2FtCr050800
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 22 May 2026 10:15:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FBC5F.000/4gM85W4X7mz51Srk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F21240007
X-Stat-Signature: 597nu75kmjyjfupkqph7n6b5is51ttbn
X-HE-Tag: 1779416165-948464
X-HE-Meta: U2FsdGVkX19h9qGHkO9asZjCf9iejowEZPcDR0hO+7Th7C6TeL+HiJUSB2KPrQYJ1vnBXbWsZ5uQ2IzjKwNU0BWAOU6l4oKSJvd+fDaneAURqFj42uxbSgSDIA7LboQ2H0DHNpFRIF8zHMsBSPv6YrKmESAokPkZcmRljLbmgqumY4SfofHy4FU1hhKjmJXperXcSsyCqkz6Z/emroSFQxPJWcrytO2LthOjAu3TEfZaSlcAoVgDZrm0hlceaw2N09G0Lgk2j/ud4tER8TsYddLxjW7gtVg0VqeL0gV5AAlq5THhCZMDWReGoQJQgbnTnl9pedpBVFKtpk6CYWygQjFdRaZr4DYlu54KCGr/jZBB1UL3JI97c1BGCOZSEGsUTEim6Qnf2HMIXI3eg+cIDzTaiSHVYuiOrvYoTyINHPgcHG3NzaTKfEtuQT197ZnMr1bjnyn7Um7Qo/vJRsn8QYRF5TzJXDrJp5+i6gO+oWPMgFhyb70mYLYS7Pp9ImUEFAIssiHftf8R7Ms/vWMWF4WIzz9ibpewkqcZlLCMlqouBurLDpOA+SjEwb/SJIYS+s1VPmza9SFROkWq9eFsFoXR028OwvLnklxhrVSCr6gmeKEuXihPqcDg/SluPhazJP2aGQNp9pgb/MC8TyYXTxgP8BpIhz5ZxGuV/1jZHOx4039BpYAi4n6AkpToTKDSpMG8wB5whsyCC9hVmRVHBDUqgaN8osjdlOU7A7ozH2X19j+W1mMXWonym3nkB7MhOzOMxmbyxaMxNNi25ZSMe8rsca/cmEImcLVKcWlvEJ9SBQ2IZRQ2L6moB2TF7SzVbryIYsKliU4yHM72aAOHtHjhkIsaToMdTbc3Qj0jyH6Wxu1vaz/ho4bE0R8GSWNlRZPO5YrDSBs98KWdMaS5zFWBUZ09b2ZJoUA0bVEhZ7s6Q3j1hJ9OPuyGHtri9GegWefGoq+y7sfPosx2Udv
 06EkOQgp
 /fZV5/rQaFckvHGUzC7odxwfLea1PVA4rQ88BUvw5hlayvDh8wzujiWuOovQ8Q5Yh16q1egxJFO4WO2n3yer9FVDtmmTteqnm1ABMOQDtOHPkww7UIHWn9hO6iHObb8u8g+WVf6tl16izm3dUBi6kw1dBc8eQH6f36/IiEkLyH23oEgYfOfDfIF0/qf9l4FAwcUNqvlKw+ZXwGXqs56JtEBEACMsZWUF6siFo0VC2MhXt/2ui4KqtIDWRz5qQa/Vbelj/oHWiKd05bEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> Hi Shengming,

Hi Harry,

> On 5/21/26 8:50 PM, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Regular sized sheaves are allocated through alloc_empty_sheaf(), which
> > sets __GFP_NO_OBJ_EXT. free_empty_sheaf() is the matching free helper
> > for such sheaves. It marks kmalloc sheaves with an empty codetag before
> > kfree(), avoiding the alloc_tag_sub() warning for intentionally missing
> > object extensions.
>  >
> > kmem_cache_return_sheaf() currently handles returned pfmemalloc sheaves
> > in the same branch as oversize sheaves and uses kfree(). That is right
> > for oversize sheaves, which are allocated directly with kzalloc_flex(),
> > but it misses the matching free path for regular sized pfmemalloc sheaves
> > that came from alloc_empty_sheaf().
> 
> I think it'd be better (in terms of readability) to teach 
> alloc_empty_sheaf() how to allocate and initialize an oversized empty 
> sheaf, and always free empty sheaves with free_empty_sheaf().
> 

Thanks, that makes sense.

I will move the existing capacity and pfmemalloc initialization into
__alloc_empty_sheaf() and make oversized prefilled sheaves use that
helper too. This way, oversized prefilled sheaves can use free_empty_sheaf()
instead of kfree().

> > Split the two cases. Keep plain kfree() for capacity-mismatched oversize
> > sheaves, and use free_empty_sheaf() after flushing returned pfmemalloc
> > regular sheaves.
> > 
> > Fixes: <1ce20c2> ("slab: handle pfmemalloc slabs properly with sheaves")
> 
> When referring to a commit, the commit id should contain at least 12 
> characters to avoid collisions (per the process document).
> 
> ....but probably Fixes: is not needed at all, because currently no user 
> uses kmalloc caches to allocate prefilled sheaves.
> 

Oh, yes. I will also remove the Fixes tag as suggested.

> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> >   mm/slub.c | 9 +++++++--
> >   1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 04692a6f9128..a6b720fa79ad 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5094,13 +5094,18 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >       struct slub_percpu_sheaves *pcs;
> >       struct node_barn *barn;
> > 
> > -    if (unlikely((sheaf->capacity != s->sheaf_capacity)
> > -             || sheaf->pfmemalloc)) {
> > +    if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
> >           sheaf_flush_unused(s, sheaf);
> >           kfree(sheaf);
> >           return;
> >       }
> > 
> > +    if (unlikely(sheaf->pfmemalloc)) {
> > +        sheaf_flush_unused(s, sheaf);
> > +        free_empty_sheaf(s, sheaf);
> > +        return;
> > +    }
> > +
> >       local_lock(&s->cpu_sheaves->lock);
> >       pcs = this_cpu_ptr(s->cpu_sheaves);
> >       barn = get_barn(s);
> 
> -- 
> Cheers,
> Harry / Hyeonggon

--
With Best Regards,
Shengming

