Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA08AC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 12:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63526B0088; Sun, 30 Aug 2026 08:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC836B008A; Sun, 30 Aug 2026 08:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBA96B008C; Sun, 30 Aug 2026 08:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8902B6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:52:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13D961402D3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:52:40 +0000 (UTC)
X-FDA: 85157924880.04.8F6ABEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 603DAC0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:52:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wrcyrobq;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788094358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+w2XNkCWNOAyz8LeQ5op7kMySPGtAcuPEqaVAY2YEI=;
	b=G3CN2weSsYBpCYA1af1XNTedABz1xOcRfLdYjbxP+cQpjzvJqdUg9WliI69iyck8wNO5a2
	gxE9tMjbvaxbzegmpI+//azjklkCNSxmdC+mOUDUzuq3qnt2IRCVpRVAHncENYqNgkuaFk
	TVIZt+DyB7yEAkw0jU7btAHIigLAew0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788094358;
	b=gl8jG4Ihwt9N+NTm3mB2Pb2GtGIULhgXjK1KpKRIxoEaVd1Alfloew1hTeCbEiha1OJrhg
	S8/m9/O2CJ2hRtQfIuKia0Sn8NJCTRqNHgVyhTcfwowXmGWaw+N++3RrIvSGOltqTPMGoV
	xIKEYP47dCEJqSubC00W5FyaLQtZXt0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wrcyrobq;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F59F41591;
	Sun, 30 Aug 2026 12:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00161F000E9;
	Sun, 30 Aug 2026 12:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788094357;
	bh=t+w2XNkCWNOAyz8LeQ5op7kMySPGtAcuPEqaVAY2YEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WrcyrobqCjymKqD9XkqUts7JrHZIY+yyBn+aDdn3CLT3xjJJAq1YINb7It1NcM/eX
	 8nFvixT1w2I8Ge0X4dZr1qlypupLyOzqKtJbId2XRFZvkt1NRoYP8pE+TFj4OE4g9A
	 aXXHuMhgC2YDxTSZdWTUERO/WjDR6lfFwxA5YWoif09eZ4nUrtJXlSRl4iC77X9TLJ
	 j54EeBjTfyBctaq8kxLZ/XsgaYwPyR/Ukpw9rMOGN2d1qhcJqXmCf3xykzJTb97TSx
	 Eb4LysfruHTXGuJqiiRHcIwy2pkgLJSDRKnVdWWW5rsXLLb5lxYIbHCg/Gyr6h+0wU
	 kbmM2LlD14/GQ==
Date: Sun, 30 Aug 2026 12:52:32 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzbot+805630f1453e490427fa@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: reject unsupported kmalloc sizes
Message-ID: <apQnNhrsBfGm40Lz@dev>
References: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
 <82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
 <ao9dPUpHxP5uOOcw@MacBook-Air.tail10959e.ts.net>
 <DKZ7J9HNUDR6.BP9KG5Q7HYMJ@nvidia.com>
 <c4684212-f44a-4aff-a02d-f3f26095ebc1@kernel.org>
 <DKZUH9SFMP6H.1ZMKA92IHQLG2@nvidia.com>
 <c9c11ca3-8f78-4086-8549-5e99a4d79feb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9c11ca3-8f78-4086-8549-5e99a4d79feb@kernel.org>
X-Stat-Signature: c9ocohnis1nrgmpwg31jn37aunp95fuc
X-Rspamd-Queue-Id: 603DAC0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788094358-334900
X-HE-Meta: U2FsdGVkX1+D3hZzlC40y9UDbvZyRm75Bdi2nUZ2fqAeVjhUTz/yjSBIdA2aEYsizM17SSG7ckFe4UfekzUazm/k9cHUrlAAigLDyWlLhS/qAhQ+dArMqeJ3yRwMh1dOUtgdeCJYkPd0hwwHK3wFT7KDzRVWt7lojTKs7vx7vZEWM/CgtZoPdIvWUkNc13zu72WMelU8Ed6KS4vRMP8tVt8QuNNQ2OXaPHZeq4GRHRqi3pQJ3UHP7rCQGkmOIkpDZ8D5kzcpZOsAT1RPAmsNjbzKcKV0Jt70Me3vKdr3gOiKKimEFHJFKwgaVKCwDYFGGdXMAsAQtq1UO6QcEeIWKeS6crXd0ehNKKqjrPBEZmyRC7cVKVx5LuJnoBcDfBUaQdNOBkMbaQC0xzl1W7CFRfrSFV4CePMuGHPVKrqQqfOV6hoAiY7oLvnnAY9YwKDU1I1R3gNd7EdyTY80uv3ER6ao7Qytin1uO2jDj2E5vBQYYYmDX+G0jN/yWp8ChX4lMh1h/Avg49ImmO9Nkqxc5xQ88asvP9fTnm9iirf+EuyTSKkQzRLXnxakDkgL/e9IbQ2SKYY7O+k7b35FbXI8xH1MesQ5WUSCRujievJuX02uzhw2LgsNrGNeleLZ+0SfvEzVeB0klpNc+NyCcDdrDxxKKWGyTLggzcVg1goXREozrfb6KPFE4roNvJdW4uV1BMaWDH/92tfHh1X3c2T2hvOCKOf3gFEsX1u4QF9iMiq7PjrDQIRUspu5dJdiOAmK6GU1bTbcHlrBS9V2Er+UTEGRGyHhC+FmiCMN4mu4uGTRViJWgZbyarVwV7cd7dKVpUGgDY67CjCqJguUa8L2biDhoXlgs86TIM9yg2eXUJzoq4wITYDpWMkTftSa3H6l8sGzP7prfezjOHKT1FAXnWWs/DpBifxYT7+yG9SwbVA6IpHQHonQboMPuKYv8HKTuh+6RvdqbTHdnwtJD+D
 iE4ICESK
 zW/e8pRMclHNx/2yqrX4/N9uxt8vK7YN0FaWc5h8uUwbKkgqFpLcOvVuiFBDDOLbRRVaeGtuGMKdr0NPLi2SV7aEt15LuYLe4a5nEMKJpSkJInkNkYiqCgvXA7ACzQLrY+N1bmtFx+nwHlThOUWkeUSgArxoLOSJipIi9SMF5GRSDKC311X1oYOssRaei5jRmELzor6mfe/ABMuwWSGvCPtiwgjibybNw6Xmwfo6LqIik8UtGgGyLaN41EobSGrVZPdjq5ZLaxLOMfs0xMIOdhT7/HDFt+PUb8SuIxHdpxj3z+/Oq3y2BMtCtyT8rbTazh108oRCHhooy7F+v4X8BCBN2ODIYX9nqToy8aVTbAga2MykNwaD04NjoKE1NgPzbJRXx5LusyBx9WG56BW7LlyDePp0q80WU9lmIM/Q3q2XV6ThubIYz5JnLsqeCmLFWpKOUippS/xyKxlSUFeDmA9ivSArECfaEu6WUFXzwZE0gb5td3lS2CzYoAKnBN0R8GJundOTKLGFX9+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 06:49:33PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/27/26 17:51, Zi Yan wrote:
> > On Thu Aug 27, 2026 at 3:47 AM EDT, Vlastimil Babka (SUSE) wrote:
> >> On 8/26/26 11:52 PM, Zi Yan wrote:
> >>> On Wed Aug 26, 2026 at 5:47 PM EDT, Harry Yoo wrote:
> >>>> On Wed, Aug 26, 2026 at 11:28:12AM +0000, Vlastimil Babka (SUSE) wrote:
> >>>>> On 8/17/26 22:40, Zi Yan wrote:
> >>>>>> kmalloc is used to allocate physically contiguous memory for kernel
> >>>>>> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
> >>>>>> the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
> >>>>>> sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
> >>>>>> because kmalloc allocates an order greater than MAX_PAGE_ORDER. Systems
> >>>>>> with panic_on_warn=1 crash because of this WARN. Fix it by rejecting any
> >>>>>> kmalloc size bigger than KMALLOC_MAX_SIZE.
> >>>>>>
> >>>>>> Fixes: aadb4bc4a1f9 ("SLUB: direct pass through of page size or higher kmalloc requests")
> >>>>>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> >>>>>> Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
> >>>>>> Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> >>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >>>>>> Cc: stable@vger.kernel.org
> >>>>>> ---
> >>>>>> It fixes a page allocator warning (order > MAX_PAGE_ORDER) when gadgetfs
> >>>>>> requests excessively large memory from kmalloc. Instead of adding
> >>>>>> __GFP_NOWARN to suppress the warning, as was done for usbfs[1], change
> >>>>>> kmalloc to return NULL without a warning for this specific issue.
> >>>>>>
> >>>>>> [1] commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively large memory allocations")
> >>>>>
> >>>>> So I checked and for kvmalloc() we have in __kvmalloc_node_noprof()
> >>>>>
> >>>>>         /* Don't even allow crazy sizes */
> >>>>>         if (unlikely(size > INT_MAX)) {
> >>>>>                 WARN_ON_ONCE(!(flags & __GFP_NOWARN));
> >>>>>                 return NULL;
> >>>>>         }
> >>>>>
> >>>>> This comes from Linus in commit 7661809d493b4. I'd do the same thing here
> >>>>> then.
> >>>>
> >>>> But the purpose of this patch is to avoid the warning in the page
> >>>> allocator. Should we fix this in the caller (gadgetfs) then? 
> >>> 
> >>> It is fixed by: https://lore.kernel.org/all/20260820223719.A4A3C1F000E9@smtp.kernel.org/
> >>> 
> >>> Please disregard this patch, but we can keep the discussion going.
> >>
> >> I still think this patch has some value if done as proposed above. Yes
> >> in practice it will just replace the page allocator's warning with a
> >> different warning, but IMHO it's "nicer" if kmalloc() sanitizes its own
> > 
> > And SLAB maintainers will be Cc'd. :)
> 
> For some people it doesn't matter if it's SLAB or PAGE ALLOCATOR :D
> 
> >> requests to the page allocator, using the KMALLOC_MAX_SIZE value.
> > 
> > Like this? Or the exact pattern as kvmalloc() is preferred?
> 
> LGTM.

Looks good to me too.

> Should return NULL even with __GFP_NOWARN or if the warning has fired
> and won't again, and AFAICS this does.

Right.

> The kvmalloc() pattern predates WARN_ON_ONCE_GFP addition, I think.
> 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 0337e60db5ace..b562f2a6fbbee 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5263,7 +5263,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
> >  {
> >  	struct page *page;
> >  	void *ptr = NULL;
> > -	unsigned int order = get_order(size);
> > +	unsigned int order;
> > +
> > +	if (WARN_ON_ONCE_GFP(size > KMALLOC_MAX_SIZE, flags))
> > +		return NULL;
> > +
> > +	order = get_order(size);
> >  
> >  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
> >  		flags = kmalloc_fix_flags(flags);
> > 
> > 

-- 
Cheers,
Harry / Hyeonggon

