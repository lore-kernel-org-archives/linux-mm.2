Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 927BFEDA68E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34916B008A; Tue,  3 Mar 2026 10:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2A56B0092; Tue,  3 Mar 2026 10:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE526B0096; Tue,  3 Mar 2026 10:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF626B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:43:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29688C11F2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:43:38 +0000 (UTC)
X-FDA: 84505171716.18.FE18C5B
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id E289514000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:43:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=U7PBQddm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772552616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iJQaiUJrWfplRxtcMoHp1zPaYjGQn94g6/CCuRZvsM=;
	b=Ogh3Tl0KJrS5dHKTxYEe9KHZ6ftE4jdEjCMmLvWIfTEgFCf+MJgknxAFozoe4SBhI5BoXN
	shLDBMzIIUxjMyr0utZBEmD0cMYGNAaaUebVk24meCJ5N5MJCYLyDuam/JzSoqs1T2HwiE
	iu2v1ZOAY7oEO6o8isx8zwsstjQaI2k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=U7PBQddm;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772552616; a=rsa-sha256;
	cv=none;
	b=ehJW9MgND6piV0pnVH2fWgoaK9io3WL6o+fcPhFcipvB0M9whtyk9tIP87r74ixjoL2gNK
	kZT0C8Bo9mepsyGqb3/sEY0K9b/m3RKs6Lb8IPpv3xEjJLJDjszp6v1wjc/r9oVKWyNnh1
	5dNGtcWWP81rWOb6hMKZPxb2F8pAFb4=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8c711959442so554695685a.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 07:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772552615; x=1773157415; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5iJQaiUJrWfplRxtcMoHp1zPaYjGQn94g6/CCuRZvsM=;
        b=U7PBQddmyPZqPlhJdOamZvY6538vVXZ0OFHv46CFl7RKwDYcER6JI8IXDX1mKFU3eF
         rtt1PHpXbfAdkMA2C15zFvL5jXtNW2GdohYZ2GY1g9ad/x6OrUvJlVG2EuyZi0LOy8hg
         9XojcxfbqSRcxPbDWI3/xt8AEUH9vU9K86gSQfkAkDJqELqkVLLGzw/z0BBMXqBZKDts
         hZpSz92sw1Lx2b9VWFLDkPP4wR4PWo6vadYLmyNeCmMA0NJxFI7VSl6VbTQVgnep0PJE
         88OyS7+KHWNNim3idrmixCMac3eZMxrZjewORxXxgXOAaMGxMuYk3+OWglSa5feghx79
         kVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772552615; x=1773157415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iJQaiUJrWfplRxtcMoHp1zPaYjGQn94g6/CCuRZvsM=;
        b=aI+hLp5+8uS8EnDfE4dE8h0+Hnlxb1KM1mnV7GCX/rMdG6taz+bo15Fy7FgCjmu/Yl
         LiJeXsbc0y9z7T4EeEmNKzn4Q/lNsKuDBv9VFcDfnis+dn6Da5Uknm7bd+dCwMH/0JEO
         I9cPtUqjduynf/7cWupeuLx2zsgIeeMVcTPy2ndZTzZw2kqKS2nIYmbrZlYSV2ls5OIt
         LK0tPit8o7XSIzlYpJSehaw5F4WQtYGYd6XFpyqezazvYUYdjxmXhFITQ1m89RX5No3i
         SbvNlaUoyV40F0Liikty/Y++KsrsMC3JpAtmA8QfSyyxr5IroXDBh95Zxpuy0ORfH6iR
         6Ggw==
X-Forwarded-Encrypted: i=1; AJvYcCWoRS0pJb7jmGG8QzCzvwkwHxJyMYO3LkQurv8RBv1zqExSpQ2VkrslZ4+VDcnLhiI06loFRab/Fg==@kvack.org
X-Gm-Message-State: AOJu0Yx+aIZW/LqmMuE71wiMdCMhqj9kIBxs/nV8jylCj1ec+LYXsyBr
	MFRe+Kbq8hIZPKKufIZih09GGs2wKUfuL2yLmS0LI4DYprnKMRTe8FEpQCSuzScGkN4=
X-Gm-Gg: ATEYQzznyw8Yr6FPvJ11B8G/jh7szGncLIftl5IqRm6WsEHPlcLz0l/FyVeMTRqCupz
	Tu2aSi6jZ3RvK/gyQFplIjpbGrLck3pMTFrrWwCZYou588MignBBjDyQw2hkXBmQ969cKkyYc3p
	YwDACdXmzVVLrSSygcvDyesp3Gd+xB3+0LJ+1MpvJWcEhvVZfPsRneA9XOvQSt5r8NY6UqlyGQj
	e054hrJNLApTuRKFXIC9/YUiky4Xi5FuSgn11ZAc4S56udGF5XJkMEmYJUSm/2PHWRXlV9z4Z3+
	ieRCZXAUfgmekK6fCnC+OOVYdQh2dt1ZsFonWU3sgneHnhASce4wlGwRM2l//a1GBOQo8ekPMpS
	hk/czkraEhhGAllj+JKd0uc9wCfvSwpTItgoBg43xMbwlW9wsD/1E218EGtsg0+KHNM/8xzWOiH
	ubJ/B5Wh8HA5rqz5+/HDj3U206gaUEjbT6
X-Received: by 2002:a05:6214:21c7:b0:899:f39f:b884 with SMTP id 6a1803df08f44-89a0a86c9d5mr33626696d6.9.1772552614690;
        Tue, 03 Mar 2026 07:43:34 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7374e07sm134729676d6.33.2026.03.03.07.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 07:43:33 -0800 (PST)
Date: Tue, 3 Mar 2026 10:43:29 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <aacBoazC21TAi-Q2@cmpxchg.org>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
 <ji2jjt4vtmt2ox7wzytpivttc4z7j3u6cwmv23r6xit5322gns@te4t4djl5nlk>
 <541a6661-7bfe-4517-a32c-5839002c61e5@kernel.org>
 <aablae2eFl9ne5fW@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aablae2eFl9ne5fW@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E289514000B
X-Stat-Signature: 4yeyzfwxjchgntfx3k5wgrbx73bbeqs1
X-Rspam-User: 
X-HE-Tag: 1772552615-405186
X-HE-Meta: U2FsdGVkX1+iuVc7PFPIaF/pj2aO0xxqDzIKWvQESxkCvobWX1pZAin6kSDuw5FKr5y8W4LLGpZ2n2IadDb4hHZuuFHqIuQwXvYjpUhh1x7/cYE+bvO1CIW7kh0TZumat11z2hINqU2/pJJyfSRnzjvmZ1OzNwwEJaOQ6oekeyhPnIqpXzRStcVpTMIUXu0T8pgg21qDyLg/AIB5+xF0323VtoL7tAOx8V4z6mn44MMQWdxT0Xh+XmeZqKby9RghaUOFrOKmbYgQZGARNzhn83VsI485E5ox5rm6eCJMja+j7OhmE4Pe7jHrcN/+UL+A/97zTq9xygMr0b4dr0NgPpnZ7hV7Zoi72MmO+eNHbUI7v15zHYFenLYym/QndN+HicpgG2V1Np8iy6D6p6DMUy0zjLifn0opmouj9v3D4itJzyD/Jfl0K3ghTWQGVcvD/OslQuy0pbLimFrxr99LEARH4iqiAk372HrXLLGu9nPzXktSGaUBauyPJ/KwYzhOOlmJvHypwegLf0jrXudSGQIbxmMYhaDZ4c62YqRqXM2oZy1zCVtPBhL3DVyugIGK+GMP6D8xobdS7a8kkE0DV07wcdPrp+ueSIXf3g09nJKAmV1P4RUrIa6x3HB1Eam4hHLViekBTk/1kiX7UsCHwjwIE6uGUskLsSWfDIK2F0ROtn/UZ5FQjtlqLc40a19aHde/T1yYwrm8eedolTvgZasDBXFEEM8sFhTjSc1CuYV/ap+rdsGgiWOSbBXKYkUPfGE9rlgzQGhU0BuX9k6RjeJipPwPIEXV1SYdM+kosBJQYYNL1GwKae6ZeJqmASFb2l81HItz+a6GUIqSYEK2bXdEd1Soz71sMexzvx1VqVwWg0pcBUk39ETaqgXjcI7Jf9o1QDRBVZYGXI+3n8WSDn7q7fXGjWtSliwFjitFwzxNGYdPa2T8k5k0BB4E/N1sX19fWkHWH1U93vEKLfB
 BARX1fSN
 u8gPtAsqLyGNEYt/HnqzBiLQbI8xs/hGhCie1xXEH26r0UAWcv/Ml5EZpJbThRjPkveOwBlYy5E3oBwK/hpzcLZmIjiF2J7bnMI/7HOmLnPFOwYDJoYdd/UElqdIDKex0QT1IfGfMHypgrpcJBb+hEtYF9yM1LI4+rwWzAwwnqGFTumgeKiLFwlbxQhd+l7b+y7K84fL1RLsNUpqzvuSkCrqu0TQhBLbtH3dBER+WsLVyvR4/GF4KLpKT6l9xK8mhLG8haEQn6Y1UdMs/T82/o9SGbubj1WjKSCaDO/jULXcQyXBIe48bBJfbSQpY7oPIgxpRwsi9D9JO62AN+K7F5Yqif3igckRK3PF5fH7MOGf9ssmyOz3vK9zf14xAJlgkvEhvqp0WyKCeu1Z9TB+7vefoDJ2OE+emul6xzx59IkF7DLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 05:45:18AM -0800, Shakeel Butt wrote:
> On Tue, Mar 03, 2026 at 11:42:31AM +0100, Vlastimil Babka (SUSE) wrote:
> > On 3/3/26 09:54, Hao Li wrote:
> > > On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> > >> Cgroup slab metrics are cached per-cpu the same way as the sub-page
> > >> charge cache. However, the intertwined code to manage those dependent
> > >> caches right now is quite difficult to follow.
> > >> 
> > >> Specifically, cached slab stat updates occur in consume() if there was
> > >> enough charge cache to satisfy the new object. If that fails, whole
> > >> pages are reserved, and slab stats are updated when the remainder of
> > >> those pages, after subtracting the size of the new slab object, are
> > >> put into the charge cache. This already juggles a delicate mix of the
> > >> object size, the page charge size, and the remainder to put into the
> > >> byte cache. Doing slab accounting in this path as well is fragile, and
> > >> has recently caused a bug where the input parameters between the two
> > >> caches were mixed up.
> > >> 
> > >> Refactor the consume() and refill() paths into unlocked and locked
> > >> variants that only do charge caching. Then let the slab path manage
> > >> its own lock section and open-code charging and accounting.
> > >> 
> > >> This makes the slab stat cache subordinate to the charge cache:
> > >> __refill_obj_stock() is called first to prepare it;
> > >> __account_obj_stock() follows to hitch a ride.
> > >> 
> > >> This results in a minor behavioral change: previously, a mismatching
> > >> percpu stock would always be drained for the purpose of setting up
> > >> slab account caching, even if there was no byte remainder to put into
> > >> the charge cache. Now, the stock is left alone, and slab accounting
> > >> takes the uncached path if there is a mismatch. This is exceedingly
> > >> rare, and it was probably never worth draining the whole stock just to
> > >> cache the slab stat update.
> > >> 
> > >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > >> ---
> > >>  mm/memcontrol.c | 100 +++++++++++++++++++++++++++++-------------------
> > >>  1 file changed, 61 insertions(+), 39 deletions(-)
> > >> 
> > >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > >> index 4f12b75743d4..9c6f9849b717 100644
> > >> --- a/mm/memcontrol.c
> > >> +++ b/mm/memcontrol.c
> > >> @@ -3218,16 +3218,18 @@ static struct obj_stock_pcp *trylock_stock(void)
> > >>  
> > > 
> > > [...]
> > > 
> > >> @@ -3376,17 +3383,14 @@ static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
> > >>  	return flush;
> > >>  }
> > >>  
> > >> -static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> > >> -		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
> > >> -		enum node_stat_item idx)
> > >> +static void __refill_obj_stock(struct obj_cgroup *objcg,
> > >> +			       struct obj_stock_pcp *stock,
> > >> +			       unsigned int nr_bytes,
> > >> +			       bool allow_uncharge)
> > >>  {
> > >> -	struct obj_stock_pcp *stock;
> > >>  	unsigned int nr_pages = 0;
> > >>  
> > >> -	stock = trylock_stock();
> > >>  	if (!stock) {
> > >> -		if (pgdat)
> > >> -			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
> > >>  		nr_pages = nr_bytes >> PAGE_SHIFT;
> > >>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
> > >>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
> > >> @@ -3404,20 +3408,25 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
> > >>  	}
> > >>  	stock->nr_bytes += nr_bytes;
> > >>  
> > >> -	if (pgdat)
> > >> -		__account_obj_stock(objcg, stock, nr_acct, pgdat, idx);
> > >> -
> > >>  	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
> > >>  		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> > >>  		stock->nr_bytes &= (PAGE_SIZE - 1);
> > >>  	}
> > >>  
> > >> -	unlock_stock(stock);
> > >>  out:
> > >>  	if (nr_pages)
> > >>  		obj_cgroup_uncharge_pages(objcg, nr_pages);
> > >>  }
> > >>  
> > >> +static void refill_obj_stock(struct obj_cgroup *objcg,
> > >> +			     unsigned int nr_bytes,
> > >> +			     bool allow_uncharge)
> > >> +{
> > >> +	struct obj_stock_pcp *stock = trylock_stock();
> > >> +	__refill_obj_stock(objcg, stock, nr_bytes, allow_uncharge);
> > >> +	unlock_stock(stock);
> > > 
> > > Hi Johannes,
> > > 
> > > I noticed that after this patch, obj_cgroup_uncharge_pages() is now inside
> > > the obj_stock.lock critical section. Since obj_cgroup_uncharge_pages() calls
> > > refill_stock(), which seems non-trivial, this might increase the lock hold time.
> > > In particular, could that lead to more failed trylocks for IRQ handlers on
> > > non-RT kernel (or for tasks that preempt others on RT kernel)?

Good catch. I did ponder this, but forgot by the time I wrote the
changelog.

> > Yes, it also seems a bit self-defeating? (at least in theory)
> > 
> > refill_obj_stock()
> >   trylock_stock()
> >   __refill_obj_stock()
> >     obj_cgroup_uncharge_pages()
> >       refill_stock()
> >         local_trylock() -> nested, will fail
> 
> Not really as the local_locks are different i.e. memcg_stock.lock in
> refill_stock() and obj_stock.lock in refill_obj_stock().

Right, refilling the *byte* stock could produce enough excess that we
refill the *page* stock. Which in turn could produce enough excess
that we drain that back to the page counters (shared atomics).

> However Hao's concern is valid and I think it can be easily fixed by
> moving obj_cgroup_uncharge_pages() out of obj_stock.lock.

Note that we now have multiple callsites of __refill_obj_stock(). Do
we care enough to move this to the caller?

There are a few other places with a similar pattern:

- drain_obj_stock(): calls memcg_uncharge() under the lock
- drain_stock(): calls memcg_uncharge() under the lock
- refill_stock(): still does full drain_stock()

All of these could be more intentional about only updating the per-cpu
data under the lock and the page counters outside of it.

Given that IRQ allocations/frees are rare, nested ones even rarer, and
the "slowpath" is a few extra atomics, I'm not sure it's worth the
code complication. At least until proven otherwise.

What do you think?

