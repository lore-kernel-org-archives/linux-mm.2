Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B499C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 05:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C4F6B0088; Sun,  2 Aug 2026 01:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F126B008A; Sun,  2 Aug 2026 01:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24416B0092; Sun,  2 Aug 2026 01:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5A4D6B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:13:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8CE64015A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 05:13:53 +0000 (UTC)
X-FDA: 85055162346.26.D2B73A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 432B680006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 05:13:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIG841MM;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785647632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niRnBgIOkxhhckIvRPqaMN/7uu1K+HF5yKjgNhj8FHg=;
	b=6svZbAjhVGgeyVJhVjVDlLAjcsDEo0LG1GrCQjHfbgn6i/V7IbvtYPJzSpMzCdrOFkDluV
	mOymM/xP48VjROpCsW9Iw6Fc44S8CdhKlHVrKtFGs6y6v7J38PEUkSTNnhs8sIpCMZZ6Gu
	m6uvLu4s39F3DenBMRMfLwdYS1JUQ/Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIG841MM;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785647632;
	b=GQvnzPyFGCjwpqXLMwKpkGY4hdy+haIHoKhze1OnrlbqqxlIKFNURauytPRJ/LZeMiorQd
	SPICRZk0sOcGpqkv18Kv+o6f47Ubtvh/Sz4bMn8xBR9Z7nBEVkTikOI6+HP1DUnmkFHQ84
	3HQIv7VXbM3K6miiIaLdHDHfjaaHOfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6980B6057A;
	Sun,  2 Aug 2026 05:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C691F00ACA;
	Sun,  2 Aug 2026 05:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785647631;
	bh=niRnBgIOkxhhckIvRPqaMN/7uu1K+HF5yKjgNhj8FHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FIG841MMBMJ+WtcYJdqXnQCHVZGpIltri8KaiXfcHlsFPBRqWdWMKMc3K2soCwoZL
	 7yBTVZLZI3rUDTYKFqk52KY0BXKkYDvHxQvgsinj+OZOH9F6LoEUD9NsQ1tCNO4Bw/
	 wfEyt7KdDv/b20V45tVAXKQFQNaqJvajbqa4ltZBi5D3t0eyfjhr8F8ux7n+V+24lO
	 1LvsuTldEjsilv/xKDqHQKZyVve2DM/k2kTJdgnWJDwSsDcO+EyTR1BzmqGe4XHlLH
	 IHi18M68GuyIWupDCNNbNRObSqAXl4Ov/Fnr4PHuCe1LuSgpvM++cbpEx4UtGm/iUn
	 oBakHix6fSitQ==
Date: Sun, 2 Aug 2026 05:13:48 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
Message-ID: <am7NCCxeg3BsoYSa@dev>
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
 <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
 <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org>
X-Rspamd-Queue-Id: 432B680006
X-Rspam-User: 
X-Stat-Signature: ytd6y85totqx9x1yr5mk8tmi7ji6ofup
X-Rspamd-Server: rspam04
X-HE-Tag: 1785647632-6262
X-HE-Meta: U2FsdGVkX1/KAG0D90NBG4mEwte+UMWpY4NK3eIxK1tFh9DhTx0tEMChaBlqLPKvkEgv4z3RHfdK/8hFdzxWTrZPwtqOIEnZbSJox7imCoc/4vzlZb9a8kVTyrcVi49MgELXkp+YpJGZy9hkOBbefUklYE5Q2GQSf7f/0PceYT9ZMcxYAZ8III6fhvTwBlihwXQRWrU0VrrC2GyQXAWQGs2Xd3kUnSWpZPTDSFc/A5G2lGmdhnQcTN1C6ROOrwJlYmOUoJRsN/ZVm0t8B71tZvfeZd5hITT/zGZyHylMAEh+QCcP0Y5KbAVqQWQQux7cxDYu/9VHrpMkI9Cyzqj1XVUOmIOg9ZXoeIkpGsETgf5bXO1BAOxjRHHZ8XawX8In7KD/egq6++zU1Tgz9HaAUcAPgS0HpNMsaVSQ7vIRd0nEyMc/mOjU+TChgxcAfmHLasWuchz5VcouY/ExSp76HPHwNCkFlwqoq0B5Y1rLQIB1rwoY6jasSWDoawd5A7NlvU7O9H90GUyQCSPH6EvuHCRR0IG7SLhrBOyzsWdeQknBo6runtUzsltoZE3BVKC1WVW6G72pIYclsPJ9M/UR1P2B8HRK9FtnbPRn+7lzaeZy7dN6ivR5VO6woUwYWzEr4aYXU6q/yQ6tkFiQL+3JZJIT6X6CK8N8J64A+OSuh9uwzkOhaUSUiyhrgeNcQ4s6SGaau42JJmv4NxCcUMiyw6woly3lNO0m6MbREXzZt2f+1i+BZG/Ab3beuGBW0KPi3F9mxEP0KVjaWzOpHiz0J7JVITFKLtedEp/3VRUMDOeVP3vAzvQwx0vvSi8VPR3fUfWsGWVeHj6IzAB2JwzwbwmKcvDm3wD4RxEE9y0ss3tOfD0NrmhAWT77eQl6+IIso+RkhLuDLjbNXCBKap7ptdPF8Ht9kv89K+aDuLqyFEw0f2E2MIXj/KZIVc1Jt8kwDfFlcVSq9aix/8Z43DW
 VmQRE9cn
 A3Vqj3IoChPSn4rxxTBA+H9KY2y5/xZ0W3n4n5hgnQKh92sa5rUd6HGMuxIZxf5znfdObWVFLx59CcJcxQb9LpabHHwCNlz9PHNy2vXRMTMFYFx99g0ym5XdtHqrTs5na5jha3KdNujeJYYTxM5zK6B0+22OOgdn5cqeXiAySPYzVBGZZkDf6ol0i0q47vIEkoyeRfXBZGB4vZhZDmy8sVhAnq6znn1W5ifOtft4W2DGXYj6so6VkXruI9MYi6N/SZd2O0sFmhi5QQhwJIg35vWbtgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 04:15:26PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/27/26 07:27, Harry Yoo wrote:
> > 
> > 
> > On 7/25/26 10:28 PM, Alexey Dobriyan wrote:
> >> Sysfs "ctor" file prints offset/length of the cache's ctor function
> >> 
> >> 	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
> >> 	init_once+0x0/0x10
> >> 
> >> This is not useful:
> >> 
> >> Offset will always be 0 because ctor is a function.
> >> 
> >> I'm not sure what ctor function size is doing here, it should be in
> >> /proc/kallsyms
> >> 
> >> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> >> ---
> > 
> > I'm not convinced that changing this (without strong justification)
> > after exposing it to sysfs for 10+ years is worth the trouble.
> 
> Agreed. It's a pity this was exported in the first place. I can't see a
> benefit for anyone knowing what the function is called. Should have been at
> most a flag whether there's ctor or not.

Agreed.

> But possibly a justification is not to leak the function size, which might
> be theoretically (although unlikely) a hint to some attack.

...but you need to be the owner (root) to read this :P 

> Well at least if somebody complains about getting broken, it's trivial to
> revert and we can hear about their usecase.

If we were to experiment with this, we'll change it to print a flag
rather than the ctor's name, right?

> In-tree tools (slabinfo etc) were checked to work properly?

Looks like it doesn't read ctor at all.

Commit a87615b8f9e2 ("SLUB: slabinfo upgrade") added -o/--ops option
that should "Display of ctor / dtor etc.", but it reads "ops" attribute
that has never existed? Bit puzzled.

> >>  mm/slub.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -9149,7 +9149,7 @@ static ssize_t ctor_show(struct kmem_cache *s, char *buf)
> >>  {
> >>  	if (!s->ctor)
> >>  		return 0;
> >> -	return sysfs_emit(buf, "%pS\n", s->ctor);
> >> +	return sysfs_emit(buf, "%ps\n", s->ctor);
> >>  }
> >>  SLAB_ATTR_RO(ctor);

-- 
Cheers,
Harry / Hyeonggon

