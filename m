Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C1E5FD5F61
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 04:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542806B0089; Wed,  8 Apr 2026 00:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6736B008A; Wed,  8 Apr 2026 00:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409826B008C; Wed,  8 Apr 2026 00:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 326216B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:21:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B22F8E29E6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:21:54 +0000 (UTC)
X-FDA: 84634090548.21.4D2D692
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id A75F01A0006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:21:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775622112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xH42glrgYu9hSbhdHoYNu1a94UrZHPAFnOkX1dS6Os=;
	b=TkZjXx2y28u1Kajo49gLPm/mZQ990i8zm1GqRn7tECKdvfd2QUzscBY4do0hj3+zdtNMpV
	M0xJJBVOqKr+Zrax+UvF6UCg1eckMMBiKezJgEIFQcesXIAEUNpZzHdHMWgvSUPgVUdPEs
	WnUztXq/DDqwZoffBc6NOM4izH8hEGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775622112; a=rsa-sha256;
	cv=none;
	b=fuU84SVLM+JFh7ifhNOp/sRJWVWx5ULx2PbFttpcYcFp5zrY7BwUfj7Jwf1Rx9FCHnEWyI
	l0N/Ygt03beDnewniiaxl/5LdG5CaMcuaCfhY5tAzS8li8pgwBT1tMsJLgkHNCDXW1cVdx
	m7twtpB4wF90sZJi9VgyXk19LNf8heQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fr8z00PKXz8Xs70;
	Wed, 08 Apr 2026 12:21:48 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6384LgZT059071;
	Wed, 8 Apr 2026 12:21:42 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Apr 2026 12:21:42 +0800 (CST)
X-Zmail-TransId: 2afa69d5d7d6c39-32e8c
X-Mailer: Zmail v1.0
Message-ID: <20260408122142195kd_6Njq39HPtNW0rnWnF3@zte.com.cn>
In-Reply-To: <adWxmEzU23nza_pn@hyeyoo>
References: adSFyyFWlLy177rB@hyeyoo,20260407210216761qrDj8RR7pN-ycbvYmA69v@zte.com.cn,adWxmEzU23nza_pn@hyeyoo
Date: Wed, 8 Apr 2026 12:21:42 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6384LgZT059071
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Wed, 08 Apr 2026 12:21:48 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D5D7DC.000/4fr8z00PKXz8Xs70
X-Rspamd-Queue-Id: A75F01A0006
X-Stat-Signature: j4z4tskxx6jwugqu4q4kzqkdhr5x437r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775622111-208161
X-HE-Meta: U2FsdGVkX1+vWSO3RlkMy7uJYtlSRa2MFGaUIFyI8PRaHuhVC4ciDVAhdTbtHwAJEDgzj1emlQVSXyAR9hhDHw2Oag6W+IGrhYBEhRmIoaJZDKQBu/5d/D0BJjglhy7X0BPs4rDr4iA3mHxfOG3oE0SfthY0ZSGWOY9D9bUeo2cn0jV4+waUzbvp0zfnhGjLCr2Cn91lzD5A/bHMUpsZyvRQSJTYaeKk0s5LTw0ckFd8jS8Y1XOJH4NC95Cf74fZo+Q42uExbbV4IDLvnETTbMqi5JqIBVd33E1rri0//YI7NaLPsV3zWVYip+wmlbZF8N9GEsfjPwL1oMagP33OWkWfqVIuuaOgW4lKw7FQopYtUVhm3irWn5og4713PwByEcXzPiP805fzDjPb4ORVmTgVdN/D7t1WLUCgG7KKGcR0bhj0Jo84wUwyltbk7BjrHfGuzzxw5d1j8K2weU6rLLrTlNHvsWrJkWBhxYaJYWQEmX5KQLe1tcPzAliBdkcXcl8PtixKqk2/ZgttY6WqfqXLOHsS4Gge1ty5BFEgMn3s9m5PH1FdMvWAml5dw/Tlzyq8VVbRXTN8FTVTVy7kP4fP3hsQ543SqHaAMs6K2Oc8s/hcADF7AwGMecpl3toWT04mXjdWR17pHukA93U+Wy7z0i66aGWN/xO5FXhtQa0D7sIF0J4+p2D2Wuqiffug7zZVOW0hAFgAnfwGKD/Hn+Rh1kQzVrMw+Z6z8jIMJQiRXfBMCwX+Udj6HrGrthCP3nxYim+SA20rt+XX/W2qQ6jFOnDPYQtOCPMZzOmXJh+ruhAiK9w4pxpDNl/Avv0SIlzo//TjtxMDa+VPxUWlSr7e24yCd54J2SIN1fogoqpo6knN8Akd2Qv+vNNg3LAqNvmgrIunKk7TWH6tWNjDRUoimAQfAZIHpMIm1HTXG+i2y0r73IQfUYttUP9v0Ox3boNu/FhKZU+sIIXt1AF
 0f9uziZn
 iUHuGauDzq0Cg7iVaHAnYsX7Tqig7EK/Y+dqbrZ3zseuOBHDPOTBSfe6UDdchCdW793L0Fv86ieiDAlRX8igDv+Hlak9GYKIAvtQRwS/eNy4R8XKkrzbnsY7gtNu5Wr4ssCvzCpIxx1myxaCCJDeMLqcDHvnTGgyfPD8BZYRZvI4QiTehO3F2fq73H8C38EdtM0ma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> > > > -        slab->inuse++;
> > > >          allocated++;
> > > >      }
> > > > -    slab->freelist = object;
> > > > +    slab->inuse = target_inuse;
> > > >  
> > > >      if (needs_add_partial) {
> > > > -
> > > > +        build_slab_freelist(s, slab, &iter);
> > > 
> > > When allow_spin is true, it's building the freelist while holding the
> > > spinlock, and that's not great.
> > > 
> > > Hmm, can we do better?
> > > 
> > > Perhaps just allocate object(s) from the slab and build the freelist
> > > with the objects left (if exists), but free the slab if allow_spin
> > > is false AND trylock fails, and accept the fact that the slab may not be
> > > fully free when it's freed due to trylock failure?
> > > 
> > > something like:
> > > 
> > > alloc_from_new_slab() {
> > >     needs_add_partial = (slab->objects > count);
> > >     target_inuse = needs_add_partial ? count : slab->objects;
> > > 
> > >     init_slab_obj_iter(s, slab, &iter, allow_spin);
> > >     while (allocated < target_inuse) {
> > >         p[allocated] = next_slab_obj(s, &iter);
> > >         allocated++;
> > >     }
> > >     slab->inuse = target_inuse;
> > > 
> > >     if (needs_add_partial) {
> > >         build_slab_freelist(s, slab, &iter);
> > >         n = get_node(s, slab_nid(slab))
> > >         if (allow_spin) {
> > >             spin_lock_irqsave(&n->list_lock, flags);
> > >         } else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> > >             /* 
> > >              * Unlucky, discard newly allocated slab.
> > >              * The slab is not fully free, but it's fine as
> > >              * objects are not allocated to users.
> > >              */
> > >             free_new_slab_nolock(s, slab);
> > >             return 0;
> > >         }
> > >         add_partial(n, slab, ADD_TO_HEAD);
> > >         spin_unlock_irqrestore(&n->list_lock, flags);
> > >     }
> > >     [...]
> > > }
> > > 
> > > And do something similar in alloc_single_from_new_slab() as well.
> > > 
> > 
> > Good point. I'll restructure the path so objects are emitted first, the leftover
> > freelist is built only if needed, and the slab is added to partial afterwards. For
> > the !allow_spin trylock failure case, I'll discard the new slab and return 0. I'll
> > do the same for the single-object path as well.
> 
> Thanks. Please keep in mind that you need to enable SLUB_TINY or slab_debug
> to test the alloc_single_from_new_slab() path.

Sure, will do. I’ll make sure to test the alloc_single_from_new_slab() path as well
by enabling CONFIG_SLUB_TINY or slab_debug to ensure it gets exercised.

--
With Best Regards,
Shengming

