Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E94CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591466B00A2; Thu, 15 Oct 2026 10:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569946B00A3; Thu, 15 Oct 2026 10:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A51E6B00A4; Thu, 15 Oct 2026 10:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269A06B00A2
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:48:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B19E380980
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:48:15 +0000 (UTC)
X-FDA: 85325140950.24.6D1B5FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E8304000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:48:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6Npo+w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CI+ok0/Z43MdcnV3VUwcn2him7kLkNUJ17Hue0PIVoI=;
	b=StzpcVjSVK4ws+gV5v4qj434niGjADy+A8sFHx27fHvZGS4AyCJY+Qw/aeIMQyhgDZO9sW
	dKA28FpOD2HlsCN6TH4Dr9D25GCNv3xRAs02tS47QPl83HOp/I2+OvA88Np0lCL6Vojocx
	IsYUihVVph6pM3EIrZJnDtnZaJ4CFW8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6Npo+w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075694;
	b=Z/TnJUVJrhZbrP03zR7LXniWpXYpWJbY+3sGnzeHeMx1CppTGcQIu9W3z35K6x5W9UErOk
	YCK6NdQETPjDjlHx7s57snw/DqbkifFkV4LgB/Sv7EZlgITpRgBqws0AdlGFP3r+fOFy9m
	OOjl782OUwBWTvqwA/czQsTY8m78Eu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27D7060120;
	Thu, 15 Oct 2026 14:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642561F000C4;
	Thu, 15 Oct 2026 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075692;
	bh=CI+ok0/Z43MdcnV3VUwcn2him7kLkNUJ17Hue0PIVoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I6Npo+w4u9JFFp4P/7aITeJ9Mrxa9x+/hj97hi1koxyVvBbv/oGud8SKnHdz1O4VK
	 K+/+v5C0hDTA4m/xkIat5mXAFuqMCW6n/eL/Z6CGVJVJWlOPXkwxHvUFF2YmzUADer
	 Vw5yFAD+xNmHX7klYT+L4eiusWgjQr7mApWL0s1rtbQftXIECY8PMqn+H8HgC5eFVq
	 u7oewxpX1Ai4uzkUjGGiEHV3PbFVTrGgfqMg5zyJcK1M9CVnI2w1MtvUiPDorft6SR
	 F3f8IjnLPpj3WNZxGvbBCrG0UdNocS/RYZO23NQm8HOPs8cevZlAaqM4JBvjfwoGme
	 Zo674Cu4zZvxg==
Date: Thu, 15 Oct 2026 15:48:10 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Imre Kaloz <kaloz@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "Jose A . Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2] mm/slab: sample slab_state once in
 kmem_cache_destroy()
Message-ID: <atDCYwNfKW3m6YXh@thinkstation>
References: <20261014150844.8536-1-kaloz@kernel.org>
 <d966f16a-a2be-48c7-b31a-a2c7d3ef6d5c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d966f16a-a2be-48c7-b31a-a2c7d3ef6d5c@kernel.org>
X-Rspamd-Queue-Id: 2E8304000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: xfiguoks3bj3iu6zc4n75z1jxh43uqzy
X-HE-Tag: 1792075693-866853
X-HE-Meta: U2FsdGVkX18kywBJy78bgHtP7Mlv0zlNj3eNRkG98lLM3GyOlct1DSYQj1CABhJWYNbAlWDrkGh6jEiiEJYcRl7oHDxsgBk1X2ME/QLbUp8L0gsMdFHHS9MQGdPUcM/3fLO51bnRsDJxY8HyVjfCEdt7Rq/LCmsaurj6vUAuh61DZEan0s8uV6tumCusg+sPHA9tugmZtNP8Ees4DS6jtyu7B0EP8Iao5BeSMKKkcsutm7bLKbt/eysmuHgEMIMyjOg8myht/z8ehPj0x3++z2Y5XIWhWYHC92zlZGiiPbJ+oacwRZPanYsIhN1cgdElAGRxbnjl+LhIdDnmR6BERQcmQmi/trQsFqdI3pM2q6VpkLP9D3m2Gb0GaL7P0zqMyRu3+VybkZKQ7YAzeq+OpO/yW1ptG6PE1aTUGp64jeUToytBvDT4NkgNsNhXjJ7SEk1d5iOiTSumZ6fr6asm5DqzSUmSacxCFvLeXNJQQi88733LnZ27f9Wi+SYgjYKaJFRMNmyJskTGnlx64+FpRbHZPRBKcCKiSCMIay+80UMGGwgGc7cTZqQ2q68FiP+D7Zv6MgVYmsoIoYzkvgm29gFWEmpZmsnc1x3Ftk+lgUXvH7mO2xLnurP5w9vFA05znmcfQK+lCG9o21ZHTt/ohKLRNpD9FVn9A4n3EtFMcb9EBqbiMPvP1V7IyIH7FhKKafilcJgctj9bvK1zaGsc9DmxY0vlF+bb2pgdaryFAVLS0kpGXWrj5ZekGDf4om2PQiogeUDRoyjJWGovlTGc5NILFp1cRPmTDELU+BEac/QUEEd06O72YnKizcgZLUVme5Gq7dowGASgOpHu22NRFpLk6Y43X28yQpXNQCqKt+T4R7bqXJoZ1zr71acGcbN2z4IQJEvT7aG1Ch3qzSd/C0svPFhmOoIOknoMIzmnMKPHx14xDaR6a/sOKjDQOgYmTDKCTMfhUrdO1k0+30I
 8O0fqgNv
 icIWhweVfqZFqf0KTAEwR6LKsJ50+GghyB9Hv+eyVtLgVUkyJn7mn3KMzqLt05A9m1rXzcH155T+CpjA3F+9cFw8aWA2CXvzrfdSlEQQWy2gWlTAArp3Eg1cMFAMsR20BrZfGYoj6VS6RhcORqzq+7j7e9I0WBl9U/jJ/z5mX3GrMLpGOjYEjEH6uwoAdzSST9eQYcfZ77X7RQ3AiYmHn1+KY4KL6DK821ymmue+KqsoWbiE5GrJ0OIV+N0I4xBJ/duOh0RpwN33R59ZEc2iZaXf9PA+TXp2DXAIa2tJN9UfO52LjVOqIdno6HQU8T3D5bwh2+ovF6Hw0kDKgld5gHnEew8R1wmncqGY+ezVj5zwYzJtMYsG4VP6z2eYkBCRtWCX/Xdlj1DUq9VQdidq5PPxttN1mzUPEAmraOXV08pTa4061Z9wxwm6TIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 09:21:43AM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/14/26 17:08, Imre Kaloz wrote:
> > kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
> > has dropped slab_mutex and unlinked the cache, and for a
> > SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
> > before that test it sets slab_state to FULL but skips the unlinked cache,
> > which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
> > on a kobject that was never initialized:
> > 
> >   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
> >   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
> >   refcount_t: underflow; use-after-free.
> >   kobject_put+0x64/0x2c0
> >   sysfs_slab_release+0xc/0x20
> >   kmem_cache_destroy+0x104/0x1e0
> >   bioset_exit+0x13c/0x1e0
> >   disk_release+0x54/0x140
> >   put_disk+0x18/0x40
> >   floppy_async_init+0xbec/0xd10
> > 
> > The release-time test has run outside slab_mutex since at least v4.4 for
> > SLAB_TYPESAFE_BY_RCU caches, and since v6.0 for the others. Since v6.12
> > the unlink-time test in kmem_cache_destroy() is a separate read of its
> > own, also after mutex_unlock(), so the two can disagree. Both tests ask
> 
> It would be useful to mention the commits here along with the versions. Also
> this suggests 3 commits but there's only 2 in Fixes.

Agreed.

At second look I think we should improve the changelog a bit....
And the history of this race is really... messy.

I'll just rewrite this part a little bit with specific commits and
add Fixes: tags for each commit that introduced for re-introduced
the commit, along with some history so that people* can decide whether
they* should pick this up.

*who may maintain downstream stable Linux kernels

> > the unlink-time test in kmem_cache_destroy() is a separate read of its
> > own, also after mutex_unlock(), so the two can disagree.

This part is unnecessary because reading slab_state outside
slab_mutex is what we should fix. As long as it's read under
slab_mutex, reading it once or twice doesn't really matter.

(See full changelog at the end of this email)

> I would guess the 6.0 change is not a crucial one?

Uh, I thought the Fixes: was 6.0 one, not 6.12 one :/

> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

So... below is my suggestion. What do you think?

commit 13564e1cfc847aa540019b55a1f8e588670892fe
Author: Imre Kaloz <kaloz@kernel.org>
Date:   Wed Oct 14 17:08:43 2026 +0200

    mm/slab: sample slab_state once in kmem_cache_destroy()
    
    kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
    has dropped slab_mutex and unlinked the cache, and for a
    SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
    before that test it sets slab_state to FULL but skips the unlinked cache,
    which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
    on a kobject that was never initialized:
    
      WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
      kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
      refcount_t: underflow; use-after-free.
      kobject_put+0x64/0x2c0
      sysfs_slab_release+0xc/0x20
      kmem_cache_destroy+0x104/0x1e0
      bioset_exit+0x13c/0x1e0
      disk_release+0x54/0x140
      put_disk+0x18/0x40
      floppy_async_init+0xbec/0xd10
    
    slab_state >= FULL asks whether the cache has a kobject, which cache
    creation skips while slab_state <= UP. UP is the state just below FULL,
    so a false sample cannot skip a kobject_put() that was owed.
    
    Seen on sparc64 at boot, where the asynchronous floppy init tears down
    its bio slab while the late initcalls are running.
    
    Sample slab_state once, under slab_mutex which slab_late_init() holds
    when it sets FULL, and use the result for both the unlink and the
    release.
    
    The history of this problem dates back to v3.2:
    
      Commit 69cb8e6b7c29 ("slub: free slabs without holding locks") in
      v3.2 moved sysfs_slab_remove() outside slub_lock and introduced
      a race condition between kmem_cache_destroy() and slab_sysfs_init().
    
      Commit 945cf2b6199be ("mm/sl[aou]b: Extract a common function for
      kmem_cache_destroy") in v3.7 accidentally closed the race while
      extracting a common implementation for kmem_cache_destroy().
    
      Commit 5413dfba88d6 ("slub: drop mutex before deleting sysfs entry")
      in v3.8 re-opened the race by dropping slab_mutex around
      sysfs_slab_remove() in __kmem_cache_shutdown(), to avoid a lockdep
      splat between slab_mutex and the sysfs lock.
    
      Commit 657dc2f97220 ("slab: remove synchronous rcu_barrier() call in
      memcg cache release path") in v4.11 shifted from synchronous
      rcu_barrier() to asynchronous RCU work for SLAB_TYPESAFE_BY_RCU caches.
      That commit, again, accidentally closed the race by moving
      sysfs_slab_release() to shutdown_cache(), but only for
      !SLAB_TYPESAFE_BY_RCU caches because destruction of
      SLAB_TYPESAFE_BY_RCU caches is done in an RCU work.
    
      Commit 0495e337b703 ("mm/slab_common: Deleting kobject in
      kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock") in
      v6.0 re-introduced the race for !SLAB_TYPESAFE_BY_RCU caches.
    
    Fixes: 69cb8e6b7c29 ("slub: free slabs without holding locks")
    Fixes: 5413dfba88d6 ("slub: drop mutex before deleting sysfs entry")
    Fixes: 0495e337b703 ("mm/slab_common: Deleting kobject in kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock")
    Cc: stable@vger.kernel.org
    Signed-off-by: Imre Kaloz <kaloz@kernel.org>
    Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
    Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
    Link: https://patch.msgid.link/20261014150844.8536-1-kaloz@kernel.org
    Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
    Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

