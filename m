Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C3ECC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F132D6B0092; Wed, 14 Oct 2026 09:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAFF6B0095; Wed, 14 Oct 2026 09:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27D36B0096; Wed, 14 Oct 2026 09:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD4176B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:07:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58DD1A056B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:07:23 +0000 (UTC)
X-FDA: 85321257966.30.1721183
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C4BCD2000F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:07:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJXvNhle;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVcsAY5wGMlDOwmq1UZhDfW0sTXv6nSmjcnxiZJCQSs=;
	b=arKWysRj5vH7k0l0IP17XBkI0dgLi8DupKRuBRdiNyHLDf5qDoVrmu9S+PcT7u0FWh38zS
	mG9kht7Xkrzw19fvBaNDnAIihm+iKYK1E7xR3te3WtL4KezNtFr3Zk1s4zQfTLwLVDfB9y
	e4MmoxCk9LjQZ0Iczpio32ONoFHbmZE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJXvNhle;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791983241;
	b=8KNFwD2IPlUBfsPvMB3ZPZAbqjx9ASsB/WbvsZYyIJBhhLZ+IhaVrbKthUD0Zh7vcdvb95
	xoaeeArc2BZqLzPYwrAYJLYtitk/8//khKsEancDEgy0s9RRPHQBRF5KLIIcee08BpGyW7
	4hGEOTD5joQi0/EKPEBeKHIlVl1GGto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E70E560219;
	Wed, 14 Oct 2026 13:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5C31F000FF;
	Wed, 14 Oct 2026 13:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791983240;
	bh=wVcsAY5wGMlDOwmq1UZhDfW0sTXv6nSmjcnxiZJCQSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gJXvNhlenmvFPChjIvsCVcupdI2lvpG74I76/6onSupzyO0JjNjLRd8nqJ5I0mzJr
	 iqy0aBl7eU/sNq1UeTHQcq9kHlgTtxYiZmwV87gGeg9gF/6S/nInXVBK1+WAheoZrq
	 IsAggvZ85Uz2egR5kLg2PBngfG6QygA/b7Y+0giJQQfNvt3ErLXI7YHtm4srzKTxyU
	 1D0sdzRuOzsf8lXOhV1QyPsJ40wzLX+by66/gY8/om4e4E12NwZy01kmORNiJoZIQd
	 S0lEEw9xFXQeZEwJWzPJWpyO035uhqDkm6XDfP7Nsmvhg6Z2TZgUulV6X8W6/QR/yZ
	 dT6m3qgj6lUew==
Date: Wed, 14 Oct 2026 14:07:18 +0100
From: Harry Yoo <harry@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in kmem_cache_destroy()
Message-ID: <as96u-sh8BbjXW24@thinkstation>
References: <20260930195110.13296-1-kaloz@kernel.org>
 <ar5pESlkEMqNsgxv@thinkstation>
 <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org>
 <as4QhUscRVtBzYpm@thinkstation>
 <481e9a16-cd30-d463-14ee-b5602bcd5a21@kernel.org>
 <as4q2WlR7mLhMBpG@thinkstation>
 <e4184209-75ee-929d-0103-ca15d5886000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4184209-75ee-929d-0103-ca15d5886000@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C4BCD2000F
X-Rspam-User: 
X-Stat-Signature: huem15i1hbn46w61wuaqfbbdpnosjtc5
X-HE-Tag: 1791983241-479854
X-HE-Meta: U2FsdGVkX1+Q/zzWy4rXNLj7gxYOJEPW3Oij3IaN/Kcl99rLymJD0oG45lNAAbwzfFn5HL0GcXo/MvEwQSiPXTUkObk5Az4c2sE8d3E94JNkXSG0njhDwqDWu/xjcqjofsNpdfXHQd+k6Ofr9NqN2IYxJ4iZzxsHgX/nvQ4qpN6s4au5VZsct6TJQq+juA4cvoDlaOUXZQQ8TCy3FwnLdcj/ydrOf3yuUE8QyaNDY+mDBJ9AeaOYyuuhlcdWrv5OT1Dkq5gph3q3vCV7l7kCFf7ePnzcpFYxrcMeQoToRmMZNGaRbddpC5CcNFrOO1gjNWOJUsWwxeqEMV3Ol3cbnDQfU7KbOgqB1WyBjp42iqItWygDpsN/dlyWfezU+mwo+Nwz0PXyf48knFPM9al/EUMvDbFf7sNTTp6E4ZqEfZcK2GMnG6BDgIJlP6HVvXPJ6ep9QQI/JGF6sLdfZXW375H4nPuV9xPnB6LyYwl0u3gmGuwgVoNrydpVQp3No91cXLm6mm/ePYENGV4VPfINWIRD1wHxkDxIW0OEb7Jn3+Sng6QWjK87x3xHK2OfKItZ8Rae1Ufj2nSJGy1x/VZw7XGALZq3SN/1NSIXKC5dWExLnaSW+jGXPheTP5Zt/CWKyIMwnhDokUhmgszkZrRLrgjjdRN+glxuMHasW1tuqUbkGTYLUff1+oLTVlN2c8psn43Z5p2wONXF6AcdflO69kYEiEL9alEkJECO9kmU9htFdS5Mx+YgjSOBSsuAz8ni/B6dUSL34OHIiABcXZ8nXr3nOfJU9fYckbASG+WJaq9JJW2xDs+FTY9wUkqPoIoe/J3RHjCAxJ48YMy33fzsfuMXCPORuCAEqXoTCcp6+fdkvi35/92oB4Cd2qpLUY/W9TArKSip1kIQPtAfi4Fz8yGH0jZA7v8HOEYwV9cLnKruAeDCLb1RvMk6q4VKTvAmg3+EBmFgliRGtmaUCc0
 MnJV+r4o
 fY4m8g7sAf8ugtJitK83g35XSUTitm7j97OIHROzesEpQOV9PEiQkWXzm/XIBP3EkGVkwFtCQAFixsJ5BzPddGFbGFHbZIjyjjjrVybVQfglRRW+RU/P6LDxhZXicQyVpLzuYF+HjIC9462mNWq/loLN//kqbQ99QiiLISO7UOYIz0qFPeshR0/LCa5mEkaR3wk/g6cEEy65lZSOpjzbmNjjhovMiYwqSyl04o19utAPZ29TtiAQW7ccvRCTst3NpBdCkLFDQMboaY0fBVFfLO87SSs/qoUellymsmmgUM/+C87A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 06:32:26PM +0200, Imre Kaloz wrote:
> Hi Harry,
> 
> On Tue, 13 Oct 2026, Harry Yoo wrote:
> 
> <snip>
> 
> > > > > There is a related older window: after list_del() and before that
> > > > > single read, slab_sysfs_init() could set FULL, skip this cache, and
> > > > > the single read would then call both unlink and release on an
> > > > > uninitialized kobject.
> > > > 
> > > > No, with this patch slab_sysfs_init() cannot set the state to FULL
> > > > because the slab_caches list and slab_state are protected by slab_mutex.
> > > > 
> > > > > I have not hit that, and this patch does not close it.
> > > > 
> > > > I think the patch does close two bugs.
> > > > 
> > > > One introduced by 4ec10268ed98 (reading slab_state twice),
> > > > another (reading slab_state outside slab_mutex) introduced by, hmm,
> > > > not sure which commit introduced it :) should be very old.
> > > 
> > > You're right, I got that one wrong. Sampling under slab_mutex in the
> > > same section as the list_del() means slab_late_init() either sees the
> > > cache on the list or we see slab_state < FULL, so the older window is
> > > closed too.
> > > 
> > > As for where the outside-mutex read came from, as far as I can tell it's
> > > 0495e337b703 ("mm/slab_common: Deleting kobject in kmem_cache_destroy()
> > > without holding slab_mutex/cpu_hotplug_lock"). Before that, the unlink
> > > and release and their slab_state checks ran in shutdown_cache() under
> > > slab_mutex.
> > 
> > 0495e337b703 Probably yes. Not 100% sure.
> > 
> > It's quite messy, reading slab_state has been done inside, switched
> > to outside, and back to inside, and so on.
> > 
> > But should be fine as long as we can find the first commit that
> > affects -stable kernels (>= 5.10.y)
> > 
> > > SLAB_TYPESAFE_BY_RCU caches were already released from the
> > > workfn outside the mutex since 657dc2f97220.
> > > 
> > > Want me to send a v2 with a second Fixes: for 0495e337b703, or is it
> > > fine to add it when applying?
> > 
> > Could you please verify fixing which bugs resolves the issue on sparc64
> > described in the changelog? Reading it twice, or outside slab_mutex, or
> > both?
> 
> I tested it. I built five variants of rc7 with a small test that
> destroys a SLAB_TYPESAFE_BY_RCU cache while slab_late_init() runs
> (same path the floppy bio slab takes), and booted each 10 times on
> x86 and 8 times on sparc64. Boots that hit the WARN:
> 
>                                              x86     sparc64
>   mainline                                   9/10    8/8
>   one read, in kmem_cache_release()          9/10    8/8
>   unlink check under slab_mutex,
>     release still re-reads                   10/10   8/8
>   one read under slab_mutex (this patch)     0/10    0/8
>   one read right after mutex_unlock()        0/10    0/8
> 
> So it takes both. The read that hurts is the one at release time,
> after rcu_barrier(); fixing only the double read keeps it, and so
> does moving only the unlink check under the mutex. Reading once
> right after the unlock didn't trigger it, but that is still racy,
> just a much smaller window.

Thanks for verifying that.

> For stable, as far as I can tell the release-side read has been
> outside slab_mutex since d50d82faa0c9 ("slub: fix failure when we
> delete and create a slab cache") in v4.18

For SLAB_TYPESAFE_BY_RCU caches, yes.
and others since 0495e337b703.

I think Fixes: d50d82faa0c9 should be fine.

> , so that would cover
> 5.10.y. The patch doesn't apply before 6.12, so the older branches
> need their own backports.

Ack.
Are you willing to backport it to -stable kernels as well?

And could you please post v2 with updated Fixes: and the
commit message ;)

Thanks for fixing this!

-- 
Cheers,
Harry / Hyeonggon

