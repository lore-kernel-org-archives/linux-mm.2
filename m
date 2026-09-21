Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C839CC982FB
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 23:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A239C6B00A4; Mon, 21 Sep 2026 19:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB216B00A5; Mon, 21 Sep 2026 19:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938036B00A6; Mon, 21 Sep 2026 19:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 722636B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:25:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3E801202D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:25:28 +0000 (UTC)
X-FDA: 85239353136.05.83B4B36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2947F40006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:25:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="azIn/d0w";
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790033127;
	b=yargRuwGMnYpIVeI1oYQZP/r8Th529Fb3VjLMt+0IcoDn56moLJ4NsEaKFYd4CehtXV+9V
	5G5HqKVmSJTneVakB3bKtkmp+DSaX5+4w2zITaNdSOY46CQvsdBdOaSxLqxesj1xar3RW/
	fUprpsfLRlFp6x1SMLk7FvyB3vl+8BE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="azIn/d0w";
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790033127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaGIE4gQUBGH4tcAm0OKjGErwoNdUaA0Sne6xnAyux0=;
	b=wJXUxuarDVm5iHowAOLzdqMTL8xPp8uMw3bfjac8V+Ie1JGhpeZfDY14CdQIeWVG9KOFq5
	IrWsJEAwLW6V+7bn8MYpGyDRI2ZdRs4bYBffCHto0QAagG2L7ibeQOsoR/YfbTWs1uXmib
	oVTOw5At9Oh97To7hGMyFGrXnmJeJyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11D99439C1;
	Mon, 21 Sep 2026 23:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CC31F00893;
	Mon, 21 Sep 2026 23:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790033126;
	bh=oaGIE4gQUBGH4tcAm0OKjGErwoNdUaA0Sne6xnAyux0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=azIn/d0wCBW/n5NuSAAvioZRTS6hsz/Zzmk86xwjKslNuC+NfEG2OnH1ZfzQ3TRz/
	 3cro52SIhBBCt2l3ERGmS9tyrTutoW2wkR/hIcoE8WXd0jAVCrFmXdAtIROZ+AIl+L
	 mZunPKrWZ9NH7wotaotbcWy1jLlQG8AY+mu2J+ZtfZlmW8ci62EJWLiLIbYeUpfJG9
	 Xn7R+a8VNffucyoETZHR1hjCQqsc31YOS1uipcHkLK6NSFO+mKrQNeu0qUGVDrEYTT
	 nN48t9N17wjW6roUjjostFNHgjYqWZkqJbefoyyzfHGd3NkjlW7+HtwXrktWeN6lhZ
	 jp1Vo/FxK1B0Q==
Date: Mon, 21 Sep 2026 16:25:25 -0700
From: Kees Cook <kees@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/7] mm/slab: Give bucket caches the alignment of the
 caches they mirror
Message-ID: <202609211620.342AAA61@keescook>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-2-kees@kernel.org>
 <arEdcaJz4i5HP26a@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arEdcaJz4i5HP26a@thinkstation>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2947F40006
X-Rspam-User: 
X-Stat-Signature: sb5jy48opptafzuu5rokxjeebxobx3yx
X-HE-Tag: 1790033126-421460
X-HE-Meta: U2FsdGVkX1/s2POqpka3Zn7kt7ou2boHQYP8R2mFZwydviisTVdex6hg6TRZqcBvdbTObCcdcjBHigwfmRHwxwzY1QhYdeSB3thigklGJ5fRQCOLipZbQ8QwaU8A/WApZsNPKIGtTQqcAyRyLN4eGZx62KX/J5KJdUMPCfKwbDUtZGBVFkah6aWdtascE0HbOIjaSj9/SVjZeL05P73mGahPGnXlxLms0GI5GMjDzuy3snzkRcEw+BA8TeNa15M+1wCEjbV/rqEi5btDi8WPXEVPPIZjaBR7qmYw2sBtJ4tA1siS1RNSDrtP7bRC1Lq+Be83/snpSsSxQnhEOfeDBbhGx2s55XNDAWOeppO6g44s0uED8duLl7RM0q1B9ZYcPCvNhmSn8Nhy1pco++1qj1+6P64Qgtc83hDaNFbwgo/aV1V+RSVG0+cRWHTtG5tZXuU4fwCZJLuUfC5V3Om2EggD+02CxSVeA0Pv5ryuDrTuGWdE00Vi228ut+WS5zQ9qbmHJHkvzL4KShrtbLsNHgQE6Eoolpv+jOEl7+EEpiBego71gY792GgdgDbG+ldljjMb0wbMs9szJ9sntKKxOuIMSnQFALwt/QES6Z0PY/H376dOgbM5ETPPtRUWnScpLWOHDi8n/L5vnFZG38FAeX0jpbRpg2VroPvokYh7kxka76uf7Zdej2uAWKRBYtdTIKjaRdLb2WJ8Gc8ett1kgpbKMiHJqqsvBVIC72QeJmUAYWv1mBpPIYu0GIwzHMLBGXLAJrPfC+oug7z6cxvJ/x8S2Lk/4m5jtl4GBkiXSttaDZgFItY8SLys89PEftK6yKUbB6xgkOcMDtTr2rOPnK8SjYmT/+TBRPkg/XZurVPC1rbmy5Su3NU2196dhdg4lUMC1/d9gCdeSKBvmAR10CihPGTpYtdpzDiTd2WIhnl2ngedQ3SBsFsg0QF2/L01Jk1LB8ITlsfLLNEL/xH
 bDmGurW1
 sLUC9ooPk2Z9AJTxsiMmzuDi9b6dgEmjxysXbo1YiQIkUbn/PHsHW91izU8p6iWSII2wS36r9UXCQBYGNC9XN3vAb0avrQCLPcP+ST0x6Ap/4kblu1IHv4lhbsGH5AqWeB5ukI5BX+Nw86rgOkvqBPp5pTUL8H8bwevM1lTJceVRtwgf3+/EcnMJ1Hfwy24xQJWqDDDKZ//6MTuuPvKbfJQUVxhw+z+jeLZ+qYFeTqjZbXcCiffTp994+y2sylRQ8Ets9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 02:17:21PM +0100, Harry Yoo wrote:
> On Mon, Sep 21, 2026 at 12:58:13AM -0700, Kees Cook wrote:
> > A bucket set is created with kmem_cache_create_usercopy(..., align = 0),
> > so calculate_alignment() falls back to arch_slab_minalign(), typically 8
> > bytes. The general kmalloc caches it stands in for are created through
> > create_boot_cache(), which starts from ARCH_KMALLOC_MINALIGN and raises
> > it to the largest power-of-two divisor of the size:
> > 
> > 	if (flags & SLAB_KMALLOC)
> > 		align = max(align, 1U << (ffs(size) - 1));
> > 
> > This is only a problem when slab metadata is enabled with
> > CONFIG_KASAN=y, CONFIG_SLUB_DEBUG_ON=y, or "slab_debug=...", because
> > metadata changes the stride size off a power of two, for example:
> >
> > 	size 128:  bucket align=8 size=224  | kmalloc align=128  size=384
> > 	size 512:  bucket align=8 size=608  | kmalloc align=512  size=1536
> > 	size 2048: bucket align=8 size=2144 | kmalloc align=2048 size=6144
> 
> Hmm... I think what adds confusion here is that in new_kmalloc_cache()
> we adjust the size based on alignment, but in create_boot_cache() we
> don't do that. Perhaps let's make it consistent and move it to
> new_kmalloc_cache()?

Yeah, I really couldn't figure out what was "correct" here.

> > So bucket allocations will fail the IS_ALIGNED(p, ARCH_DMA_MINALIGN)
> > check, potentially creating problems for non-coherent DMA situation.
> 
> I was wondering "Why should they respect kmalloc alignment..." but yeah,
> It makes sense if the users were using kmalloc and depended on its
> alignment.

Right, it was a "visible" change between standard kmalloc and bucketed
kmalloc, so I figured the right action was to be (bug?) identical.

> Well, but that's already done in new_kmalloc_cache() and
> kmem_buckets_create() should already honor ARCH_KMALLOC_MINALIGN? 
> 
> The largest-power-of-two-divisor-alignment guarantee was introduced by
> commit ad59baa31695 ("slab, rust: extend kmalloc() alignment guarantees
> to remove Rust padding")
> 
> ...which makes me wonder what you're trying to fix here?

What Sashiko noticed was that alignment might not match under certain
configs, and then I verified it at runtime, and figured I'd best fix it
just on the basis that it was a difference from what a user might expect,
and it might be especially important for skb data.

> >  			if (WARN_ON(!cache_name))
> >  				goto fail;
> >  			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
> > -					0, flags, cache_useroffset,
> > +					kmalloc_caches[KMALLOC_NORMAL][idx]->align,
> > +					flags, cache_useroffset,
> >  					cache_usersize, ctor);
> >  			kfree(cache_name);
> >  			if (WARN_ON(!(*b)[aligned_idx]))

It looks "obviously correct", but I probably failed to correctly
describe it. I'm happy to do whatever here.

-- 
Kees Cook

