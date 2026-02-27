Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289B1FD530C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626086B0089; Fri, 27 Feb 2026 03:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD856B008A; Fri, 27 Feb 2026 03:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D1C6B008C; Fri, 27 Feb 2026 03:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6A06B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:37:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7BD01605A7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:37:33 +0000 (UTC)
X-FDA: 84489582786.11.D3C0254
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id E08C540006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:37:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="IWHTra/q";
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772181452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/3FWIRfBeOvT6QTu+yorgvPrXYgbqfTPn7LH54AhVs=;
	b=A22KStmzH0/P7uCRUlp3y0XUBzcm23+30epdiXXEFDs5BbpGVHkxTyajACUMJx/R96omRH
	cBSVYvSdHug+kX0VSfQlMtkjTaY8jY7kXJuGTvtWrxjSJ2RGl6qK1rJger7BYKuHZHrZil
	J8vbEr5ViTDuoy3tD3lEubN0pxMjDRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772181452; a=rsa-sha256;
	cv=none;
	b=LcR0uvrB9jjeiJ3n+31IYXeu/ls1NWolL2Vx4K3dusQiianv+scX8wMAIdF8a4BVgbAgyU
	5CamQSJnzaxlV1gZ3JGiIKkWkmXWFHt9cDqEH4CCz8nqk5z90hNsEpzWO6JO73Op40NMZL
	nG+5uKpXXgzDEvohjnHTWvjaDYWgQVA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="IWHTra/q";
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 27 Feb 2026 16:37:16 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772181450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/3FWIRfBeOvT6QTu+yorgvPrXYgbqfTPn7LH54AhVs=;
	b=IWHTra/qqrgWiiFixnwwmWqFGSdl+ty5zHr8srU6IpRomgr6PZjv1NRd5KdJaunOhZrIGd
	uYxIIgt/Q6lKIkXYJZs6IKJhcDl+ua4y+YttbPlBsErnGKB8JoHYe91Pfqy3nTUA4ASHKx
	pfxjaVGfRAdbyJ9M1nG0gZs/9B/qtC4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, vbabka@suse.cz, harry.yoo@oracle.com, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Message-ID: <twvbu57mdw7ekw26spzzy5e6quq7k7hko3hvxttv6yjlhyuhpb@iolbg2iwsowx>
References: <20260226115145.62903-1-hao.li@linux.dev>
 <aaBM0fN8fqER7Avf@linux.dev>
 <e759dd9b-0857-4155-b570-cd002155f123@suse.com>
 <siuyozcbi5x6vusawdy3be5buho5y4qilc5uls7rgiihagk7uv@cfrr75gh4bty>
 <25f6a18c-0600-4a21-977e-19b8b4b203b2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25f6a18c-0600-4a21-977e-19b8b4b203b2@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E08C540006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wce7hukuoqyytprz8tpwphu8y4qn66gp
X-HE-Tag: 1772181451-911324
X-HE-Meta: U2FsdGVkX1+6J0CS/fyN13Ig2f2P+58TNxlrtZbXUyEM0fzoi6UtMwBW727h4Jvmf5D9DSE4TnTHJlPQw7ip7Pxvv+j5copjN8pA9ESaORouWl0W7/2vC58glbXxuQHkah0J3YzjQjtO9lvhrmFkmVrHQCsxOUU0QBhGm0BHsK4OSa59pLboVY7GAQ2FOiOu0R184x+oy6VqXqoeQTzUaQZOlBPWpMt2sb6MRwj7XC/yQi9tgnm5E88/Ar5gz1Te6BUiqm0bum5Dg1Dmy97iMpYWX2HZNtiwFNyb3o4+bskrTYPXq9TtNSLgE/2T/7m7Ytl3VK0wadzkjyJluxkqsKmy6ZBL+a1CLeS4nFJ0AgPsSQ6i90hj0DTHrVwOq87IbWdlhzed/4W9penkMxePMm0XEphGpmuIYRh7DXjr2sN9WF3QFvacMtCF+GPVvvWURKqFCUiKzA8axS+A3AqEAkwflf9qHoKqMGBqgT147e0/urXeD6upZrazfhYyaAHRkWhpyCQ+htqLn/iSLgf8Jvwddx4GLamCVnWC9egivWfAnG/Xfw55k/Ogj0j5SWo2gwZRDyJ5YuswYaSqUutmje0kGYO49cwO/vHapa3cLBQU8kJlIJnX+EMJ8SKW9a0beQYq+zMecaptSdWhfxRx1zuatsApFrdzXMo0+X8nSD1Nly1Oa7b7VPocP/Hg/iKpcwKXIwQlY5i3v1GR7fQ2gHCh8nHfsNaVS9lNRYMpeS70i/DBtAUoOF+dVsH7Ll5TUvVaFNb/JN3Cn16Rhw9x4qSHXHBQfXcGWBBOsT3VEvSooJp4BF2Om3qvKXmtQO+PVF8Wxjn8Ydh0R1QTfnw1W7uRTkngBT1ZqzpkBdnuxLlNfvtc4SKkubM9CUw1TbsXIoFemYBaTGngPinuAkPcfkPk0cbvkdcvCWeYGUrg+pBqPD6MSEyEqOo/lpM1P0OMpCh+4m+K6IiurBDvsK5
 kdtssrKc
 T2K149t92VCF0u+FeVataKh+AbxhSah423gmmiDKpSV8Le6vBKEiS9n2dGmr4SXS18os6zG9143vyd+8RvSMGox2DpZJL4Sg50Pq/wJNpymUGf/71oinljjIEVlYLbueX/YwfLQIspNx9cuCmGVeXyKNyBaxs8dCGoeawT0KFaA83nG29xEsZJP6DzSD6k1yP8w90uQVe/bqJt1X16cYrDsEy3d1AHZP/jkUtOGSe1bgdogM/ACWs5w+buXx4qe/E9VDx2BWpUmcXn97zQq8ObINa1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 08:46:18AM +0100, Vlastimil Babka wrote:
> On 2/27/26 02:01, Hao Li wrote:
> > On Thu, Feb 26, 2026 at 02:44:02PM +0100, Vlastimil Babka wrote:
> >> On 2/26/26 14:39, Shakeel Butt wrote:
> >> > On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
> >> >> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
> >> >> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
> >> >> than nr_bytes.
> >> >> 
> >> >> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> >> >> Cc: stable@vger.kernel.org
> >> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> >> > 
> >> > Thanks for the fix.
> >> > 
> >> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >> 
> >> What are the user-visible effects of the bug?
> > 
> > The user-visible impact is that the NR_SLAB_RECLAIMABLE_B and
> > NR_SLAB_UNRECLAIMABLE_B stats can end up being incorrect.
> > 
> > For example, if a user allocates a 6144-byte object, then before this fix
> > refill_obj_stock() calls mod_objcg_mlstate(..., nr_bytes=2048), even though it
> > should account for 6144 bytes (i.e., nr_acct).
> > 
> > When the user later frees the same object with kfree(), refill_obj_stock() calls
> > mod_objcg_mlstate(..., nr_bytes=6144). This ends up adding 6144 to the stats,
> > but it should be applying -6144 (i.e., nr_acct) since the object is being
> > freed.
> 
> Thanks, I'm sure Andrew will amend the changelog with those useful details.

Got it. Thanks.

> 
> Weird that we went since 6.16 with nobody noticing the stats were off - it
> sounds they could get really way off?

Indeed, it does seem a bit unbelievable. I suspect the conditions required for
this issue to occur are quite strict: a process context first hold the
obj_stock.lock, then get interrupted by an IRQ, and the IRQ path also reach
refill_obj_stock and then hit the local_trylock-failed path.

Therefore, I think a small amount of data distortion might be hard to observe.

-- 
Thanks,
Hao

