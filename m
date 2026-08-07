Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8310C5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94FC6B007B; Fri,  7 Aug 2026 09:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45E26B0088; Fri,  7 Aug 2026 09:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D016B008A; Fri,  7 Aug 2026 09:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8594E6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:19:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DB32A0258
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:19:30 +0000 (UTC)
X-FDA: 85074530100.28.B83FDBE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 28CC340007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:19:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aQJOXYER;
	spf=pass (imf27.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786108767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghmYN1RPgcxIty6ogS+bnA0TI+l4LmW2YxKnCJihXr0=;
	b=kKptiWmXs2hzf5QNj8HYAM0oaGJBEhnbsbc+BanO+MLaIeNisN16equLMJkZg8+oOUfohQ
	2Hk3zG4C8cokmu2H1DLplb8x8Jhd7A5125ZDuRbQgMeMICpvG6jbu467GgIrjPPdcSZJGw
	G+hd/xFs+H5VzlUQPP91qujuOTCFE1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786108767;
	b=1lCWzlokdaZGCzoYPw4bO068B7gkEJxJXHHLrwqS6taUB4YiL069gFw8+mw2UFQsFjSGBS
	uS8th/ofZhoCXFuJFBid5kDQ/sEZkD0uUK3bFDPnITE0qK3NMkHsIhBcWzdTnGPTy7jueE
	IGv4pMa8p8tNnUww28XAVBjgy8yJvc0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aQJOXYER;
	spf=pass (imf27.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ghmYN1RPgcxIty6ogS+bnA0TI+l4LmW2YxKnCJihXr0=; b=aQJOXYER5Ka4zVKe+FlkzEt+TI
	kzxXnGTDEkCffHLp2jo4ZicOtIlnrc4ryKJGXeJJGGFJB5vXIOd2qdI4Y6Ia6HoO+LnwObD1RFcri
	8udhBwjbYg4VY4meGTTM0q2TewtJDIpLnKGfmLQmoEwFjvupY7EB4C8xdZhmEs5+EJij+f+xIDwHS
	fzncEZOMsct4P1ZWTA1ZhohGMCLZlSlWT4O6y8QSIhmI9dNmPnEcV8fFeuAiTtSCQht4s9Z6owkdX
	EqVtRii81DCBpzqodpirUil81P3MJ71mnzMPFw54MuFiKafHr+gUgVg4NlAeroRE4FrbwMJzcxxF1
	c9GnzTNA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsKTo-0000000876H-1Fid;
	Fri, 07 Aug 2026 13:19:20 +0000
Date: Fri, 7 Aug 2026 09:19:03 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <ulmrkvrqbxqvri33y2olv6x2xjahb3yuee5vcgaojlxhl75gxs@ihjkaias5kml>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
 <20260805004619.GA28508@ziepe.ca>
 <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
 <hg73nwj6fdkqect6xzf34i7e4ki5izjyzb3lz6ery62sq3566k@i7tsboqhsdxd>
 <20260806154845.GF28508@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806154845.GF28508@ziepe.ca>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 58ybst6463uafwjn3b87uqd1yt3msqbz
X-Rspamd-Queue-Id: 28CC340007
X-HE-Tag: 1786108765-601432
X-HE-Meta: U2FsdGVkX188AqL1XzlWa6+5NaekP70jerjLsl/b+aauA9+Redfa/3X6yt2qVK6LjrPAexr63brl5tHS614ttzPvUJDCf8Fj/T4d+IQUbkWrcTCYeTENViYZzuSLUwcbqi6zeLijV+BwWBUNwcx2HHPd5esarQrz8vlvgkJdGgKtCsG0AYTAgwKvJBslKACjtDOwJWO8hYRDPbFURwivNTS/ii6P8d68TlcXyv57b2MVoPf6/0MAbNzhQlqd1OJ2AyuEbMFC2p6+AOyiXlO+U9F+N5ubYh7MA4sE7i+1yCd+BFCcAMRoKrWBk75bdCg0tct3gbPG8ha+EurciWGgtHLB7RjpECD3RJpuqLDcZuwgYrYNYgPrcLX3btVGM/ILAqVTuDleabbv4kVYkAQxfQzsMtA2fVQrV4lzSI9Ot2nPhcxyoi3pIGuFonJZA8eh/wkGgYRSJrJjdRiVKGnQB1dX+kBFxkIi6Q0K75+VUgb8zz0fGUT2WLYYI+aHSOFDW4YAglR9ozo+34QUeTPJyw7rB7mlvLeyZu9+iICeSgGx7mzoYrphyXRBJXL0y/PH5gFNdxir1Kjw+Vi0eslNkCADa9Qw9vG+9T7Bkf8xvHNYMqIun5aAlUoTRtWfcKP4X7Q0+gx3WjECac72mKP794Hc33q3oJfSSIsffxWQpDxT3d6C5Tokd6Rr5HNjc9t6s1xlZySAQgn0YD9opjoMdQMipgnlK5eXSiMqDK1VhW2bsTgl/7G8nQCQInEaMGre0nRh7blMpkBTUYx9/pMNiFvsZPUtlWA5QNoawTWiH8noKLJwkysAoxN0ompCdHng6sCDl3wWGKK0crH74+W2OfqNTyvSpPHT0JvjLn9ep3jQnsg3B1+2yS7TObzF9mEMJHdRT0qvAlIIh+kAbLx6iAEzjTK5kESZ2OYe970W9fiaxaPU/7Xhy/2XBbzv2uFuAOkT+atxVEv8CB9f+a9
 QvBAHoZ2
 RzxDdNOoxQg1z53PAIiIJyA//w5iilI1VUnRFaE1tve4coaou0KIv/n3nUVS0dn3m2FNln5wMX/gfWEizguf4fLv2XU8s2JelNmhUnVbl2iJJdwChHrcxGU/B6jdT0bEuRZjgXihfOFyUy9CabMJhxgkF4iQtNus09HkjPn0DF9NiOpwpjdf8ttRz4LkIsR78gh5V6v+S/8FeO4HLZpedUFMttr9oFplB0cQvVH+Y9q9ofJq0MSZwMJQSzmFoagODKG5e1ZhQhmyEsgdfod+RWprTADLY8uR2v06wo5qW6OgErdaVRFYCtEmB+9iHGrVBsGoU4adL1H18n9d9lKUEnvO9aqRRT1UED0I8KmeNi6WZ0uz8alk8eFYglg/Yn1u8N7vyDaRN88XKNQLhMlsPXllGuaEdP7Kyh1lLpeXazpC1p1pRHCjfhSuT4mMvvO5OATd4/NM+jSmGg9JAgUdbYYMqjvbepMTZQwzXKXaoOSYcgg5O8cQ7vQgcayEX+0EeqVr4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/06 12:48PM, Jason Gunthorpe wrote:
> On Thu, Aug 06, 2026 at 10:29:27AM -0400, Liam R. Howlett wrote:
> 
> > @@ -5609,8 +5612,7 @@ void *mas_store(struct ma_state *mas, void *entry)
> >  		goto store;
> >  
> >  	mas_alloc_nodes(mas, GFP_NOWAIT);
> > -	if (mas_is_err(mas))
> > -		return NULL;
> > +	mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL);
> 
> It still feels really weird to ignore the return code from mas_nomem..
> 
>  void mas_nomem_nofail() 

Sure, that's fair.

> 
> ? and maybe it can have a WARN_ON


The warning would never trigger.  If the allocation fails with nofail,
then you'd never reach the warning.

Thanks,
Liam

