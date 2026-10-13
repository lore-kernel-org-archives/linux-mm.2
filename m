Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E3EBCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D5D6B0088; Tue, 13 Oct 2026 08:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DD06B0096; Tue, 13 Oct 2026 08:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8634A6B0098; Tue, 13 Oct 2026 08:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 603606B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:38:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E362EC03E3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:38:05 +0000 (UTC)
X-FDA: 85317555330.17.E657CE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 580E94000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:38:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl0qMY6j;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791895084;
	b=eF1VFZCQvtnSAtt4QguUQ8FzvIs2tDxPDO09n6oJpHTwvsBNRQf3qLyeZcgpxz+Ew+0FzQ
	ATLUQ5kfQXBPRf0trd6/H/9iGZPe2MHGBd4qt4MwaKSEIsima4n4jujeMxF2EpdSr/rtZc
	CoF1k0sj5Up2q/0kbROc9yCT+vzyw/g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl0qMY6j;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791895084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIMflr91/F4+/ElLk2iXFBQgQtgrPATZUPG9GvQDims=;
	b=WGKCJIStBZBYDpdZ0n9AxwLfgldVv1U4+z8CtJgUIjjx/yXZlpfioCql3cSJxNQ4BdTjZg
	T6lGLWbVT7KnLyYd0zSnDWlsoTn73nQNIF4ieR9ZTsGO2eM9LqT8Eyn5VV4Nscw3rBVTjU
	09L6BEldLnVVV73xL3nBxaCchM1zWyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D97E160A5F;
	Tue, 13 Oct 2026 12:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212401F000FF;
	Tue, 13 Oct 2026 12:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791895083;
	bh=GIMflr91/F4+/ElLk2iXFBQgQtgrPATZUPG9GvQDims=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yl0qMY6jwCOkNLtLFv6sTgRB1mFOK6e1GRyA5DvrmtTpv9MgjAnLuOroXeYhBaoXd
	 w1Mb/XI3ZfZ66+gSYg74JLpiau3G3m2WvcCkDhka8jj7mBJnLDBN9KmWL8+rMtXKCI
	 OrNCmQW42sUy4awxQNvvPnJ/C+2kpIVVY1hnwh1ux5FKn9DufDQNj05+2le4KGpsQa
	 evJCGrPVkclf16YP7RKRmxutWMVj5WjBI2g5IMuHPNgdG1p3LSTlX+98lskSdlvkhE
	 eKDMh9WcKcCU90jvTRa2PiE8o2Tjp7t38iY85i6B4hMrfG0csK4ZZMkwI9Kc1+/pe0
	 wwaJYkfkou8fA==
Date: Tue, 13 Oct 2026 13:38:01 +0100
From: Harry Yoo <harry@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in kmem_cache_destroy()
Message-ID: <as4QhUscRVtBzYpm@thinkstation>
References: <20260930195110.13296-1-kaloz@kernel.org>
 <ar5pESlkEMqNsgxv@thinkstation>
 <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 580E94000C
X-Rspam-User: 
X-Stat-Signature: qheyegtgtihp35ggu3yrpwtgbx31k4rp
X-HE-Tag: 1791895084-963847
X-HE-Meta: U2FsdGVkX1/Mn+C5CwXOkJrQLNhMaxL+3TX3uYvn0adrxhWWoAkunYmv2yYZP4Ilgr34bQhl0RAb46muAFH23VgfqXdwWawT4RytfzRcA7/BwreVHU3Do1j6HO8ZApu+0jQ9aQo5QGdvEY9aAXSb2arLgTEzHwLi2ZWKb9NwUSwZ9g/VWL+/vXXD2tVN+Gf24nwSrifnZpaFKWUgEoI9Gg7KNa9SG1VH6giMY1fuSIMUIKEYpKk3b07PFmB9Wn+KazDoqHnRJ1KBBd6bBvg5iPVW7Jh/gqbjHz9QM901hSiIyMUN0ge+mPp9ci8SA90lO1yqP3jBAKrba62QCcwruI0ohvORXcSmuUJqs9pfELRA5VYCkLltHpO6J/8gs4lPWwNcJjJwO6917gKs2EvWkoetvukSddYIUh2Yr97GBH/7h7Rv4UDqJy5oS31QexVAcG3iBQyurcIIPwSlTAzCFMbcr1QNQujbiLRCCoG7kaDhIzx/MDQ2jQ8EcBpGg+f39dJYmI3zU4pL4qVK91PmZdzixzZwydT1tOxCGgVzRQ0aKUpcwswbl6A6eskaMty02iyykidjRExL5+/w+WWizG8vH555lkrNbHTbx+RabrgHruYUlLPcD/V75NS9Wvs5AJJvfTWn0sMEXuIKNtRHr540/s4KOmK2PSAStoFkGdBTKDzOvS9BAadfLJr7yEK1zEYQIpRx6yEjFGYQ5J5PKmoE0e83Ls9bCSBL8ldYd+jTGtJw1ioDQFviqqdVhDTI+7zSHZuwfMk9+dGXCnUBZKVjWEJUbWWFlFmneR47g3sXjgiPUsksiprqUUBNeSyN3gFUdWNZzKR1q/nLkw+dqjK9b7FF4RQt3N6SkSieErZHFjCObV1VlbDgX0dx35sbLCNkNosjrr1FcLWSdIAfJx+eJjpYEDAWnrpKdxTlgEuPLWWm1zoKf2VyJSNGQTL3D49ssE1yCSmpRh8wEs+
 Mw1LI8NC
 xvgOFf3Mco8ZbYysR0JRG1dZHn5XBcUdqioyb/rVts6o/TY2Jqw2rQES0rd6z3danY6UM+df3SF0R86gvbC6VwyQpZgzIWRbgGfkLROO3TY1s0zZKEtgcSXHrAANmWifdXguttwLrCJ7RctCJpK7YPsWcMyVcBGNyScZaAV65zS9p0dwgW0fFW0kWCa3yY4Vgp3581mWjSbSSNzcKTAdDAlv/VSzFNIoHl2lUTAFLxm1WjsVMV/HFTF6M3gMF/q8jSKP3jE0XLlmhCiEqiuNUMkyLIksHhc54yH18BG/WstOzEVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Uh, apologies for the late reply.
Catching up after trip at LPC...

On Thu, Oct 01, 2026 at 05:42:36PM +0200, Imre Kaloz wrote:
> Hi Harry,
> 
> On Thu, 1 Oct 2026, Harry Yoo wrote:
> 
> > Hi Imre,
> > Thanks for catching and fixing this!
> > 
> > On Wed, Sep 30, 2026 at 09:51:09PM +0200, Imre Kaloz wrote:
> > > kmem_cache_destroy() tests slab_state >= FULL for sysfs_slab_unlink()
> > > and again in kmem_cache_release() for sysfs_slab_release(), with the
> > > cache already off slab_caches in between. If slab_late_init() runs in
> > > that gap it sets slab_state to FULL but never calls sysfs_slab_add() for
> > > the unlinked cache, so kmem_cache_release() ends up in kobject_put() on
> > > a kobject that was never initialized:
> > > 
> > >   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
> > >   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
> > >   refcount_t: underflow; use-after-free.
> > >   kobject_put+0x64/0x2c0
> > >   sysfs_slab_release+0xc/0x20
> > >   kmem_cache_destroy+0x104/0x1e0
> > >   bioset_exit+0x13c/0x1e0
> > >   disk_release+0x54/0x140
> > >   put_disk+0x18/0x40
> > >   floppy_async_init+0xbec/0xd10
> > > 
> > > Seen on sparc64 at boot, where the asynchronous floppy init tears down
> > > its bio slab while the late initcalls are running.
> > > 
> > > Read slab_state once, under slab_mutex which slab_late_init() holds when
> > > it sets FULL, and use the result for both the unlink and the release.
> > > The kobject flags (state_initialized, state_in_sysfs) were considered as
> > > the key instead, but slab_state is what cache creation and
> > > slab_late_init() decide on.
> > > 
> > > debugfs_slab_release() is not part of the race: it only looks the cache
> > > up by name in the debugfs root and does nothing before that root exists.
> > > 
> > > Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")
> > 
> > Overall looks good to me, but could you please explain why it's
> > not relevant before this commit? pre-4ec10268 still reads slab_state
> > outside slab_mutex.
> > 
> 
> The outside-mutex read is older, yes. What 4ec10268ed98 changed is that
> unlink and release no longer share it.

Right.

> Before that commit, kmem_cache_release() did one test and used it for
> both:
> 
>     if (slab_state >= FULL) {
>         sysfs_slab_unlink(s);
>         sysfs_slab_release(s);
>     } else {
>         slab_kmem_cache_release(s);
>     }
> 
> So the two could not disagree.

Right.

> 4ec10268 moved sysfs_slab_unlink() into
> kmem_cache_destroy(), after list_del() and after dropping slab_mutex,
> and left a second slab_state test in kmem_cache_release() for
> sysfs_slab_release(). The cache is already off slab_caches in between.

Right.

> That is the window in the warning: the first test sees < FULL, so the
> kobject is never linked; slab_late_init() then sets FULL under
> slab_mutex and calls sysfs_slab_add() only for caches still on the
> list; the second test sees FULL and kobject_put()s a kobject that
> kobject_init() never ran on.
> 
> A single read cannot produce that split decision, which is why Fixes:
> points at 4ec10268ed98.

Right.

> There is a related older window: after list_del() and before that
> single read, slab_sysfs_init() could set FULL, skip this cache, and
> the single read would then call both unlink and release on an
> uninitialized kobject.

No, with this patch slab_sysfs_init() cannot set the state to FULL
because the slab_caches list and slab_state are protected by slab_mutex.

> I have not hit that, and this patch does not close it.

I think the patch does close two bugs.

One introduced by 4ec10268ed98 (reading slab_state twice),
another (reading slab_state outside slab_mutex) introduced by, hmm,
not sure which commit introduced it :) should be very old.

-- 
Cheers,
Harry / Hyeonggon

