Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042EB606BA1B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6dv9eQB
Received: by kanga.kvack.org (Postfix)
	id 1611E6B05CE; Tue,  3 Nov 2026 09:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113936B05CF; Tue,  3 Nov 2026 09:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050D76B05D0; Tue,  3 Nov 2026 09:58:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7DC66B05CE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:58:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C29D120441
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:58:30 +0000 (UTC)
X-FDA: 85394113980.14.CA4D395
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 973D01C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:58:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6dv9eQB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxIxJVDR0m557SNz1wHD6xc/rB/AEhEzdsgGBjmaoHY=;
	b=dnf1OS9qWx9mkps1oH4BNMIBd53z9njmKlyA2FoCVE0RcBJSlp8kq64uryU1rK3gWVUr6y
	SKCTTobIs7B+5bVlrqLxVK4Uj9sjoHSt7ql4jsfvRJjU8aZlehcS8b5WH7G2aaE6k1z8a+
	uR4meHiwY90TtA0El9WEqgrmlRQeQE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717908;
	b=gnE+Li9IeUqm7s6Yk6cs8ZlNFykU//sYvVCrXNCB+gX3SEri+gMgRjZ8XEY4LDG8maIeNR
	dflIGwQSy9dgUHKvdH04K7/csFfeFPtz9VKmE5SDi5hQZvJAahqKr4PZER4t/rJdlRKqyV
	q4xhXuhZDOvrQ96H56dgUnN8DkRo1iI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6dv9eQB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C813F40E02;
	Tue,  3 Nov 2026 14:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3354F1F00A02;
	Tue,  3 Nov 2026 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717907;
	bh=JxIxJVDR0m557SNz1wHD6xc/rB/AEhEzdsgGBjmaoHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F6dv9eQBS3DHoFKwspKTOCxDhh2PQeBeZFPAVKhlhtwy8OktZf6MQUUnEbC2Cv/UF
	 24vR9wkvQDqKQpNZqrT2lzrUkHWRjCipIVudLSxtXHpZ0JESeyVqpCfVYo60JMs3lb
	 Cf7aAdbx4uI2M8tj/XRul15/yMFO+uqoiz6/p0jZbKVpXi91pcdiyQX18AWU7jzeW3
	 JZ3hVRdB8PZCkJMTfG8YHfMMYiMATCrkqr4MekNd7C0asp+cDRBHSpJS6vvciIUup2
	 dAuxhiLgwoBqeIGoUfjqGqR6LWyaiU7ub8hVOsWRoPrDtw0ZFZM224IET5Lux/F+qk
	 nv7G8gSm/n5Qw==
Date: Tue, 3 Nov 2026 14:58:25 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] mm/slab: handle allow_spin in slab_free_hook()
 instead of open coding
Message-ID: <aun1uxYrS0imczik@thinkstation>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-2-fdf4d17351dd@kernel.org>
 <91776136-ecaf-4687-be63-a2c074435462@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91776136-ecaf-4687-be63-a2c074435462@kernel.org>
X-Stat-Signature: idofdffi4fwaqr1rsiicsw59bhk55zsg
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 973D01C0005
X-HE-Tag: 1793717908-35617
X-HE-Meta: U2FsdGVkX19LCbTcfRxGZt8iBhI0rhxe8qVPTW6ozrazyaZAOk09f/MKbsrVU7r2q8r8L7KFdpuTe+vAasyuA0Np9rc/ThTOkpEIeyYcLGDy82ShyPoZ5e+bggPG35llq5vjaOszqtcFxotwbsVDeIzWgXtN7E9J0uoPlK5XQ26LOhWkTWw0izeZYQpNP0lLSTyEG9yFMqJ3vhhw01eDhjvQTZv3w9zlLBPvMs/rib7uzN3dcg2jTOjhPbrpnr+n1e2oHHXkwqJwPa4nSQjTCOglIF6fdpWE0uwkAz5+tw66cthwxR6RqjH+pV3kUP4UQ5buQLzF0f19mzFZTjdz2QhMW5cf7pL10Jg1xxnk6GWTgu/VU/zGIMyL1FlnQUoYU1Sr+oI5M5HMTDRepG2qawyQmYZ1YvQGGwN8oK82F7Ywdgu4piDjJn3yEEYaUlWc1H2xfIodNAHNH5zfx82XHR9WE0iAjlCbFeiUecJFehlvcKo7qldRcJt5lSJylRv6WP1NDzczwiqdA2tyl+84k+iiWLeNEtIJ+CoKWTpz2FGEVnOTOoB4y3DN2Xvev7Wc3ehmx5qroxV8ufuQq+BfMYa7haXxWu95gAT9WvkLU2w38eEQUNUMQ9tQnd/Fx9GwAo/E4nohNHenY7uraGCEOXezUqctXsTbaKRgNTaL54CAn5CE0jjwcilTbxPLUuU2jCef/IGQTb6eypDI1Pbq3kgMq9MiXX6p9DmqANrU6LaGsbM1AFFz4r440dyUdxUy6wp34pBhzNURYq3wga46uo+uK270IBmv/r4uxMXG6LAZUf7nJJWiwbLVdNKlxy0Vd6d65jqPIV5mKf8Ds7928PensZJ6folKrdQFr+tM+L5xUn7hUXM7EoyX3spPsNwm21H6lZWEGVat/JLFdsSjlfFCP9GcoyxNon1ovhk86rY6v7JUgwjx1xzh+BLkG7yRyn/Q7hRISaHMuSfS7AR
 97mvvpux
 r349cPClAM+zKERxNtq3NFHHMz4XFvpD+Vk7zlRhBqm/2ew9hwdIxNPSx2idTPFg1p+LAEk2eV9noj5Vlp6XLtQvXgRAge1OHa2F161f36sBV88GU+S3de5iiXutjmCpK2x3551MEmFCIJ/iRlriJrFdCTiXG42ip6uYoE7t/oWjdiao0WkykUHkpXSW2VzWEF8/ASQclX0K4PQJATgGCD2P5lsxYJHn5CwJFqsFUQXtbwkCA1jwjDm/6OgCnrCZ+jI5YEEewmkKr8CONwJK8ahUbc2ImxgRPm42pn1GF0RzsS7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Apologies for the late reply...

On Fri, Jun 26, 2026 at 04:41:22PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 32672a92581b..85760c8ff2e2 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2611,41 +2611,52 @@ struct rcu_delayed_free {
> >   * - memcg_slab_post_alloc_hook()
> >   * - alloc_tagging_slab_alloc_hook()
> >   *
> > + * slab_free_hook() assumes that memcg_slab_free_hook() and
> > + * alloc_tagging_slab_free_hook() are already invoked.
> > + *
> >   * Free hooks that must handle missing corresponding alloc hooks:
> >   * - kmemleak_free_recursive()
> >   * - kfence_free()
> >   *
> > - * Free hooks that have no alloc hook counterpart, and thus safe to call:
> > + * Free hooks that have no alloc hook counterpart, and thus safe to call
> > + * when spinning is allowed:
> >   * - debug_check_no_locks_freed()
> >   * - debug_check_no_obj_freed()
> >   * - __kcsan_check_access()
> >   */
> >  static __always_inline
> >  bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
> > -		    bool after_rcu_delay)
> > +		    bool after_rcu_delay, bool allow_spin)
> >  {
> >  	/* Are the object contents still accessible? */
> >  	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
> >  
> > -	kmemleak_free_recursive(x, s->flags);
> >  	kmsan_slab_free(s, x);
> >  
> > -	debug_check_no_locks_freed(x, s->object_size);
> > -
> > -	if (!(s->flags & SLAB_DEBUG_OBJECTS))
> > -		debug_check_no_obj_freed(x, s->object_size);
> > -
> > -	/* Use KCSAN to help debug racy use-after-free. */
> > -	if (!still_accessible)
> > -		__kcsan_check_access(x, s->object_size,
> > -				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> > -
> > -	if (kfence_free(x))
> > -		return false;
> > +	if (likely(allow_spin)) {
> > +		/* These hooks acquire spinlocks */
> > +		kmemleak_free_recursive(x, s->flags);
> > +		debug_check_no_locks_freed(x, s->object_size);
> 
> This line shouldn't be here?

You mean because debug_check_no_locks_freed() doesn't acquire a lock
when there is no bug to report?

That's fair, but I didn't want to introduce functional changes
in this patch as kfree_nolock() hasn't been calling it anyway.

So separated this (and KCSAN checks) to patch 3 in v2 as they only
acquire locks when reporting a bug. (Taking risk of deadlock for bug
reporting just like KASAN).

> > +		if (!(s->flags & SLAB_DEBUG_OBJECTS))
> > +			debug_check_no_obj_freed(x, s->object_size);
> > +		/* Use KCSAN to help debug racy use-after-free. */
> > +		if (!still_accessible)
> > +			__kcsan_check_access(x, s->object_size,
> > +					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
> > +		if (kfence_free(x))
> > +			return false;
> 
> The whole block now misses free space lines that it had.

Adjusted in v2, thanks!

-- 
Cheers,
Harry / Hyeonggon

