Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B25C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81A46B0005; Mon, 13 Jul 2026 20:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32EE6B0088; Mon, 13 Jul 2026 20:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49B06B008A; Mon, 13 Jul 2026 20:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4B86B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:41:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 295A8160207
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:41:22 +0000 (UTC)
X-FDA: 84985528404.28.D2CD002
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id C84D3C0002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:41:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783989680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8xd8/TgcoIVW2dBr0gKr5kPkmk/XCPljFfXa98YCEFA=;
	b=T8dBkKgrNodFPa02ed4wKkL/36WA3Mr8dnKUg13Fn40SCpHoKZVVg/GGV77t9mcBdWMd5N
	meKoqS68KL34qn9gyNWpv6nUx/tNTkgHC3oLR8AuzMOlQVx/hATetRT9PCKg6R54/wFLQt
	Xp2LVKHbgjbg5HXN8ZSp+PI98rtthbI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783989680;
	b=sP0wDH2gTlW2w/X73w9H1LJWUQBAUsqZk1DpFnPTA/ZIKhJR6EL0Qs08HsJ6Ce3G3emC9U
	0Q73wpok4MFuXPuYEcCPrErwc1vxd/AKfsgBUh4dG6WyuTl5ymHuKZqkJk6FgjpTZrbT0p
	pw6Bd4qESbD5fHPQ5ZptCDsN+/QYsEM=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gzgTm61yGz5BNRf;
	Tue, 14 Jul 2026 08:41:16 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66E0fAuu007375;
	Tue, 14 Jul 2026 08:41:10 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Jul 2026 08:41:11 +0800 (CST)
X-Zmail-TransId: 2afc6a5585a7f9b-3eabc
X-Mailer: Zmail v1.0
Message-ID: <20260714084111267LYR6nswASLSX-jLwxQh4w@zte.com.cn>
In-Reply-To: <alUNQrCzt6Las0PP@lucifer>
References: 20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn,20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn,alUNQrCzt6Las0PP@lucifer
Date: Tue, 14 Jul 2026 08:41:11 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAyLzJdIG1tL21tX3Nsb3QuaDogY2xlYW4gdXAgbWFjcm8gcGFyYW1ldGVyIG5hbWVzIGluIG1tX3Nsb3RfbG9va3VwKCkgYW5kIG1tX3Nsb3RfaW5zZXJ0KCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66E0fAuu007375
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 14 Jul 2026 08:41:16 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5585AC.000/4gzgTm61yGz5BNRf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C84D3C0002
X-Stat-Signature: 6q9kdajzeu3ftwap3w1jsp7f96m7fcxr
X-HE-Tag: 1783989679-458386
X-HE-Meta: U2FsdGVkX1/mvwnl5PPO1kJDXKqEC2pBrlWYkuQ1M+lCO8ffHwAHIL8s3lzcl9pDhcv0fnCyr6JaoVf7jiOn0v/0H5Oerx7YEYwFJgA74VR7JSSOc0vpFx2DMD0aIeF+r6IUR0KHJERFvT+bhWWj6/dHiNIQCcWk4w0k/fKPC4743GjRda4Y1I+lchRR6MyauavGTVWOnQysg8Cd9/HjDB1+BxyDLO//csSXowclz2XBzwNqHy6jgSGPTRwYyrwGMbvf4GdE3+JKjihky9qFbp3xorMQHLD0nJRB87anPJpM7T05j4UCi71ohHDHeDn76UyzMk5iC67NKWgbcCgG25y3xYqdQ2awoiWoHVTDOTN+yYSAcj7mqXKGXTZI/P8QPFhBnXuas21RAGgfGHW/GgfhZFlTvzs/0YECr461c2zm8nMoPSwrj/FuHGbU6mfKfbav3cXKus6wVIYa2p2V4rDLv+Zqwl20uv3SLndY/TNQtgTfDjkg8h1NL1xDCjMGc6xryj4Ozbl8fEZY4h2Rlv12uTQyJhHUf1QtdcSQJzDwnWbDeZQDnAbzXphmSB6OafBnr1CBmSiGm16rP1fFKP9HOTkSVt+CuAY86VMr7jnFfIAOi/XHSUWan0uprI7eSdzC8y6XsANaiUR1v4boKl91/MbN8Y6cr1XqfywCR917xfuXL8ohAFU2ZrejPBvq5SexXgab7ezU6Np1fDb25pBdsWWiGc9gxqt1INPtNoQL+MvX/nGM3pH+PRhDx2RuOKv63BDgpWtFDax0Nc1YkRa+MT+Ry49KtpFxh0SjpLVCyHLnbfU6fZlM4NuuP/ZNzTGAOthQFb5Ws2Iy8sOq+h+KHUswksa0EP7lPR5i+5JzLRSn+B5CguulhPiRwjeJ0nCUCgLBc3bz/3xo1DdZDeiUKDb8+ddAzVFcingyWpGN8RbP4Z24n+19wNjPnSO/dCHTnMXsI2qhc/BAERp
 xUUn1nza
 0FWvqbZ4AxfWwEXDXhxTEB9uK78btogBlXkATRXO/m9O4eAtUKcxWxRe2dN20DvsfeFR5V4yxDmwtxh344KEcYh1wMlcX3m8R/gUIkmwmSRmfF99I6Eupf+d4sl5cATbijjpaXiKjnipjI1gwsPDiE84DR8qTixugCKfbhkdVHnuEbGL2g5F4Rl8X7nGnEK+UBoedSKBitanBPNSVtV379IoDTjRc2XUB3kxkn4P4QRxGevaHK1t61aEZb1QkifY4Fr8MKQtcHnh194M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hmm not sure I suggested adding a comment to explain it...  or removing the
> prefix _ from the existing macros :P

Maybe I misunderstood it.

> 
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> 
> Honestly I don't think this is really adding much, but I guess adding the
> comment can't hurt.

Agreed.

Regardless, adding a comment to explain why these have to be macros would be
better. Would it be okay if I send a new patch that merely adds the comment,
without removing the underscore prefixes from the existing macros? 

> 
> > ---
> >  mm/mm_slot.h | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> > index 5de3e91d86b4..710c70166c79 100644
> > --- a/mm/mm_slot.h
> > +++ b/mm/mm_slot.h
> > @@ -33,12 +33,17 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
> >  	kmem_cache_free(cache, objp);
> >  }
> >
> > -#define mm_slot_lookup(_hashtable, _mm) 				       \
> > +/*
> > + * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
> > + * functions because hash_for_each_possible relys on the actual array argument
> > + * 'hashtable' for sizeof() instead of pointers.
> > + */
> 
> I didn't say that you should change the _macros_ to drop the underscores
> though, there could be some nasty macro hygiene issue without (though
> probably something's broken if that does happen).
> 
> So let's not do that.
> 
> Also you'd probably want this comment above both with a newline after so it
> doesn't just seem attached to mm_slot_lookup() :)

Yes.

