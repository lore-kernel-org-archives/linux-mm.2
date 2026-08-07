Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964E2C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0DC6B0088; Fri,  7 Aug 2026 16:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552B06B0095; Fri,  7 Aug 2026 16:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466C96B00B4; Fri,  7 Aug 2026 16:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 271966B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:32:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 972251A0104
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:32:40 +0000 (UTC)
X-FDA: 85075621680.21.86DDF86
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 232F61C000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:32:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="txM3/Mqh";
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+e7tI6dv/WBN2Dqk5qu94PHzXUXxMyXn2M6GZ6F3l+E=;
	b=ZloLAUD1sxnUGoeQCSvCeyIXHl2mdMmE+kwYYPpas0cbtMZDaUT5WqAkE88wnoEvcV4v0Q
	sXVKjk964Q22ZlQkkq3uNLT3b8T3fD/386a1akXPJqf9LjzmKsntAZP/g0YornzoY6SYe6
	inLpC+znhGJQdi78/MEYDE2vwT1hP78=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134757;
	b=Jm6SwUJ8Mzke8uMhnZ9Lr1vf9d7j3JMSKfHWd5NCcFxS/Pamrh4mhL79lt5NkLs6ZbdjuO
	LxCm73Hu6DDYGGk6O95A1nSFEI3QDGfBrH89BrI5GjtaotjHsrN6e8ltv7W3/FnYGrpgFc
	n3pNphyAFQrSu05v7cdU/OKAgEG9SjY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="txM3/Mqh";
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+e7tI6dv/WBN2Dqk5qu94PHzXUXxMyXn2M6GZ6F3l+E=; b=txM3/Mqhay6liWZG49EHiLUTzR
	84y+iR4IUp4Fd0F58neNcass5fwkhCNKeXMinDFdTH9Lt0e76zST5HaWM5XZangvNpf26tuldpTp9
	2iusua2OcJ79A+1wwVO6icmnWZGeCknV5Eos7nEcxC9v/i+dm4Asx7DwNW17tpFBTlOtG7jTjDWAP
	DvZgEJAzbmubALt/1NvOmT35rK72zdFxVt+2ANCPPHNDp1FyElrjFseYQmZQw9oqdA5COoIoX/oQw
	DpYCOmjTdFCjWs5pjGc4C6ETzTkDTXiugp5SUikLxxbmEQmeSm7vOvCECI9Y4ujE4koI+Q1jXMk8Y
	30Wg81tA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsRF2-00000008jDV-3AHa;
	Fri, 07 Aug 2026 20:32:32 +0000
Date: Fri, 7 Aug 2026 16:32:31 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <znowjptiinhpf6soj2egyrfcva6acr5dumpjiif43xq6haeypb@v6i4thhxjvpr>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
 <20260805004619.GA28508@ziepe.ca>
 <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
 <hg73nwj6fdkqect6xzf34i7e4ki5izjyzb3lz6ery62sq3566k@i7tsboqhsdxd>
 <20260806154845.GF28508@ziepe.ca>
 <ulmrkvrqbxqvri33y2olv6x2xjahb3yuee5vcgaojlxhl75gxs@ihjkaias5kml>
 <pipldkadm5oy4olwticdjqfjz4ccn7jfqo3tdle4n2b4jtfmiq@5ckyybqnyk4m>
 <20260807192622.GK200537@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807192622.GK200537@ziepe.ca>
X-Rspamd-Queue-Id: 232F61C000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zr8uy7ia6indoddbdcub5tbuhhmf41sf
X-HE-Tag: 1786134756-981457
X-HE-Meta: U2FsdGVkX1/9odJpu/m+N/h2HD0We9ZHGjdqxWpGAaXrlvfB6QByAgWmqW6Km2L81OoXJt+Y+E1ITOj9UWtaY/FmZtBkxbtGAZcU7gGFdaN0//8Iqsg8PNNj2u1288rV3APY6DDmSphbrKA8oAbe27YRegR+DGwtd5AvTHXq+U8yu55Co7J8d6mtTa8XLL6crWEya6gdHho8Im0QvRlNOBuO1P7ZRHwUF1GFWtfJgzKQupHN4+LEn0pquwqOY216ZtPWtStJBv/X2nFIN0QcQL0WQIf7gZremAhdbobNQizVMwTRwOH1nDDuaskAFePjaBmM3PqisWuE8gbksAOzsDX4jUjmhH1wt+LqQ+tg5Dijs4dJIM+NCQr40IUcv1pzzvTOXLeAIsfyFP1A3MNJfSUp2xsotZRm3HS6v3MvLE9dnAApJM5WV2t7YtqHC3tYl4OAyYvrpqbsAPNy7U36gkVqnGPky7KwzcLCbr/QHB+DGWBoavJVLMYfSXKzuiv5XH46CTyZVngkSv0bo8ECbt4Rn76VeGsG4G/pQp6snAei9OdyqrJ0F1QArHuHtla6nCVymmrtRWF7EAhbk64ypOwcFSROJJfTXTkzH+5CbX0BfTHQ1Oe9iFKONCa3XoZEtwhte/etOlsKureufD+IuKlU43m3Eq7fjmjhufddQm1fYuzZ/SKeYAfWzewnSsWhm6bTKF/7mLrrbmLMPJ3yZE3PgiBPTznJlpqiAjIk/G2bNH8tkwA8Zl6T9hbh4BzjAF0T8J21R4tHAoyCiyfoRPj0pOzUX4nOp9y/bRnJfbM4tuXXOdRek+lY3MkYeQZ/kOU84purEqD1+STmKt8dZYjz0K1xXf5FTJlpIqKueEcn0691WCpmA4qB9JrgwIbT/ZBSPadj1xl2BiH5thDdX0hu9ABcQ3gRPIKOfuoLYOyCKEGulJA1rhVGdulNkh6x+8SgBB/eJQANXKF+AbV
 Kt/QPKWD
 u7dXwKgZ5g3ZBJfu7XaXh280gXEEtaAQJh9+CjmDGsJlo9B65/NdxisO0+BsrsJfqtWBH23DeFOvvQNAr1TOFjEjo8Z0mFlwI4cN5kCii6ArgmpyMraXZaSb0rUx/0S7w7G8Sr/7FkA0lsC5mdG0if9rlrhfP7981KE4NrPGh6BnMdQ2AFBoj25KDVifeZPqSNahDeXPhHAkIJHtdfa3hnGBvAt4cFqlQfiFoywYmtbT1FPknrh5DMCDC93I3H93FcDt9ZT/ZM/o75UBZR5A+xwHIgfteAc4pKa5hfWyIuESJDUlLVGu9ryjpA0aXRDgxU07cxrbyLhqo5PFQFqGC516Ut5L/q/kZgU4d+iCHZJOPYixxJJYaLmFfguMqDLwmxFAAd0vSzyzd5pxZ9PKWmVMsGcVHMiWf1CsRitoIm4p7N1dn5ME7/EkeWHzaJCYyyOqkVutX/LJG4qAZAkNicBHcT++iKplHp8nFUhIK/+jZPgedisEGpNwi9dD61Iv2o3a8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/07 04:26PM, Jason Gunthorpe wrote:
> On Fri, Aug 07, 2026 at 03:24:24PM -0400, Liam R. Howlett wrote:
> > On 26/08/07 09:19AM, Liam R. Howlett wrote:
> > > On 26/08/06 12:48PM, Jason Gunthorpe wrote:
> > > > On Thu, Aug 06, 2026 at 10:29:27AM -0400, Liam R. Howlett wrote:
> > > > 
> > > > > @@ -5609,8 +5612,7 @@ void *mas_store(struct ma_state *mas, void *entry)
> > > > >  		goto store;
> > > > >  
> > > > >  	mas_alloc_nodes(mas, GFP_NOWAIT);
> > > > > -	if (mas_is_err(mas))
> > > > > -		return NULL;
> > > > > +	mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL);
> > > > 
> > > > It still feels really weird to ignore the return code from mas_nomem..
> > > > 
> > > >  void mas_nomem_nofail() 
> > > 
> > > Sure, that's fair.
> > > 
> > > > 
> > > > ? and maybe it can have a WARN_ON
> > > 
> > > 
> > > The warning would never trigger.  If the allocation fails with nofail,
> > > then you'd never reach the warning.
> > 
> > Upon rereading my reply, I don't think it was clear what's going to
> > happen here.
> > 
> > If there's really no memory and no reserves, then we're going to panic
> > on trying to allocate.  So, even if I rewrite this to have a void
> > function to print a warning, it will never trigger, at that point why
> > have another function?  Are you looking to document what's happening in
> > the code with this?  If so, maybe a comment would be better.
> 
> Yeah, it is clearer to document it with a function that can't be
> called wrong, IMHO

Okay, I'll figure out how to do that later.  I'd like to get this in for
the next weeks -next testing as we're getting late in the cycle.

Cheers,
Liam

