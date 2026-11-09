Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080C6606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LPmxC0XY
Received: by kanga.kvack.org (Postfix)
	id 13B766B05F3; Mon,  9 Nov 2026 13:48:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC1D6B05F4; Mon,  9 Nov 2026 13:48:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE3E6B05F5; Mon,  9 Nov 2026 13:48:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF5366B05F3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:48:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46186C0746
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:48:48 +0000 (UTC)
X-FDA: 85416467136.04.DD392D0
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 50A0614000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:48:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LPmxC0XY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794250126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DW4GqatymZdzrlfB6/YGHQTH2HKZTymQgY+Lx0UesPo=;
	b=PSWhEHN8KUtx13VhgCqFzr69dz9DZ9sr9Owq7EbfgdOjzeNH94J6rbaEHLVnZCIuyzeI7n
	gO3hSjGew83q3oahKAWFAVXPguePOPnpFcCHPaZ9zSr1dnfw4VC8XvaZSGNY4vOGw4IUKm
	A74x0eOewnRTn9sIB5mrAnA+gu/o2Fc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794250126;
	b=aj5ZtRdmsc+lL2fG4Wv8lEueqYqTcOPRIEifnkB3n3tYqdgWGg+g7kEEvdBkZ8qWdBFrOy
	WvzDVQApqOXbiHCWsZ6+QYId3MNo/OAGGBNFb1W54VzJ5fEpjUMAl1VOJVAHIr+LtkesLe
	jC1dRl1JLpR3YBZ9IdVT99cP+j39/9Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LPmxC0XY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b31fc13124so9312787b3.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794250125; x=1794854925; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DW4GqatymZdzrlfB6/YGHQTH2HKZTymQgY+Lx0UesPo=;
        b=LPmxC0XY4A1vuVRZ/sOHPi1sf66hAMfQQNEy2Jo8poEvHcM922DT/BDZvmnw9H7AlC
         iDJn71TshHkEgECVCVzxJeE0Xq6qbeNA4nbn/6hBdwBhlKiJ548krEGBcXPMcQqqAkyM
         QL68GUODWG+fcmh3C+8/WQwB8rr8ZnfPtqc1Xql99a5A1ZtChxKmMmkU1nyeQmzOyYBG
         AEno5nJP1BSixebXqjeYew5zPtDGfnDqzec3H4+H2sD12z1D4c5yNehUGpluQQprdqHh
         BntRiN+I3FnX5z9wGIjLt9ASPoQKDSwbZ1qYOxhPCNT0rcXLJGQ1qn9rRZ1lUtc57QDp
         roKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794250125; x=1794854925;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DW4GqatymZdzrlfB6/YGHQTH2HKZTymQgY+Lx0UesPo=;
        b=hrSMkWfG2lg9PQycZUHw/tWXD/kmHKahrzRuH72M9RHd3N89OPahu5ncgC/F2rN/ri
         WR3ZSPKvb//kVEfgu7e1hunHmCwkIDw8ZTpAijLBTptUkY6RHb17ahs8cc4RL9ym8Vfq
         pzR8r8jJayTvZhiC9WPvFSJQTfFFFD0fFHxH38Aattxq8dSGAeIrqrdu3FSS0M5OqR5Z
         UNw1cu0gyHTRAYkZQ/m+CjQzyWihrU57D1TAnqr976GFXGhMK0+4x4ite9MG3EHYtgaX
         X90K11CavZtyrxxHrcW7HynvP85VFX+ajhzQzLuC+IikBCVfcwqDe5j3s2To96zVtyJ+
         9vaA==
X-Forwarded-Encrypted: i=1; AL+hErH1dgsOlz45adYLms+Ki0FfsG6Dr2r20jPTGltEd/eO+t70HEOXHIun4DNKRE1zw8EXYzvpV0WKJg==@kvack.org
X-Gm-Message-State: APuU4Z88P6e/lK6mpP3iSWhIriFilwcM9OzVSbIz692KiVPfsl1A84Ie
	sqp+hd/kAiAErRSDaJ4FySSVwLG5bRriL22j28gW+GECj4+GlEQZ9o88
X-Gm-Gg: AYBFou3E1ILyYk8HEM7XMyAEgYb79B1dFWDCto460dMB3t3FPzoee7oBFx7jSF5vEa1
	0TkN0K19abP/M2OZ6MEida4Hb4n5CUl04uhnZxEj1Wvjt2o0t1U56oxVUfkhrqKOh1h5KIdntay
	4JIVTcQkn4KGsvzRqzXxAejDEqcb/OaosMVzPQ3zoh7/sm8QiIDFYpXQmKgY4IFahmsN18xrc4a
	oUa+QzYUqP9XaKuS0z04I3rQbDNoxZ6w8a3U6IM+pacP3MDJRfO7fNBr78ubPCdiph1bxxJmKz6
	CRMvLYOVsd5IiUUqbzUpoweFam9rMeuCFtoWBlr+kD2xl32RL9z6sg75ObOZGjrVMOxbZNswnwQ
	Tw+QGZbf4LND1shTSEB3TuFjvTjE8MGyUas0j1hJFX8LDY4ngaBFvKMYEWUG3ojftzYIF84GcIH
	U2pFEFX9gcvPA5H3sahXq9K/JtXdCzNI5DoUy/yYIYAhdJqDZTuBnLCyWB4J9zg9MRgluJ6Y4TQ
	dlD0KP+mNhDUjIaEjxLS9AJJbM0OKzy0m8wWqlEHTbap5REEO8FJqbkimsJtFPKtMP5dU5xLZuX
	er83lM1BkAIN47nriZvgOkwuMJZTR7IdrAWeLu72I6q/ktTVGQLcMMW9medI
X-Received: by 2002:a05:690e:169e:b0:67b:f621:8d4d with SMTP id 956f58d0204a3-67c5673d88dmr413181d50.28.1794250125439;
        Mon, 09 Nov 2026 10:48:45 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:17::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b39339cc9dsm831357b3.8.2026.11.09.10.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 10:48:45 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: sashiko-bot@kernel.org
Cc: "Joshua Hahn" <joshua.hahnjy@gmail.com>,
	"Johannes Weiner" <hannes@cmpxchg.org>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Michal Hocko" <mhocko@kernel.org>,
	=?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>,
	"Roman Gushchin" <roman.gushchin@linux.dev>,
	"Muchun Song" <muchun.song@linux.dev>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Kuniyuki Iwashima" <kuniyu@google.com>,
	"Harry Yoo" <harry@kernel.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	"Maarten Lankhorst" <dev@lankhorst.se>,
	"Maxime Ripard" <mripard@kernel.org>,
	"Natalie Vock" <nat@pixelcluster.dev>,
	"Tejun Heo" <tj@kernel.org>,
	"Oscar Salvador" <osalvador@suse.de>,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v8 7/7] mm/memcontrol: restrict memory stock to leaf cgroups on v2
Date: Mon,  9 Nov 2026 10:48:42 -0800
Message-ID: <20261109184844.1862780-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <sashiko-outbox-200379@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fyqakgf9npoez1cxf4sqjubd6ynjb11a
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50A0614000E
X-HE-Tag: 1794250126-388713
X-HE-Meta: U2FsdGVkX1+OERznUX/1Wqcq6WIxhCfa5ZlqpkSqYNE1qcRaxoKfpPcz/5NGGzHqSORiHlL4rwjqGiYRpzVnduh8bKM/ZOKpxT0PQM+1+ffLTgXJur3+6ychIuFpLVtHyoRNn53TN46J8/8kbU0LCOg3e6cKUZ/hgqGAbPU7j2CTo/Angu7mDLqYhxm+2jjyNapnLuLb2kP/ufhBtnHYr656eW/0XMOG8dmcxpjWZ/mWVVNi5zUGZTw4ue1W+yC9nOUoRiaiTEZPdSX4mklJXFxq1lh+7FHok+lm0lM9yCkEocNLDBup5FBW9iwT4hRKfUq/wXirZskDwFSSOUJgttUyk2io1LKftljtYB8e/FExJ4Z4xjyq5l0tG8qFJFlYG2GjQOKVG90IoG0DPyeJ7/ZAGOLIBla5JDS7kuwA6SysI9twB4tqXVovCeLv786xB2w/oASa5jrb1qGopD4Q+lZSl2qiky9LUsN07DHbuG3qHeR9vc9Gpc8cSWgRXc4yW/xNKKv8fyaYe7alZ5Y2rqmMcLnIciUmyA99MhnBa3rbdS0zFcZNgcgb19N020wxGYwwIpsiMwAe1yViE8ot0Apa63L0/ZlJhak2+mo1vt7n5tSIXoEHY0Lr5G0h9u5Q/atYE7uXHOxt2nrnQFPkUxD+3WqrlAO9XLvkKkFRa+iy8k3e0vqyyp7R6QlHUF4wT5Ca9dsG2yRCkoDDTKRtoHYwDqlcHdQvjrYQJdBWZU7+ojVLodF4wsl62GCZlFQ6NdnLHerhN7FE0/RlrMiyxCDQtTfHR6mMfbE5+QIMGeIt+8T1X1lqy+Cgbu/Z8VjZ3iYYP7FxVa6O/boD3Ll3M2GgFw5Za8asPY9F0Lmcmmg06+m4qwOnSg9awyOiUtjjUt0Grf99/lmwv5BkmRzJoLnfUvvtCc7NIh0FbaHtr6h/cVi7ykke4nn00bkPhAZgpyBczyJtzJFtGxSN1X+
 wyT2Ppsj
 I+zrYe0mPYPg6pyo0GShYHuusFbLauP5phVfk1mab+nTwrdKILIWKe7ggwZrM1IXV6HreT7ih5Vie9nPRsoqZCboC18qgcR3yPGE0qI4P3S/Ev7Q7NhDZ18vY1/NGm7HsJm3+J9xmDnO45x89Uyu75mOOhF2wzQDdUcqmAg1xdcmqHUu1QMpYMyeChi2eG4SqvJHYSsaA6hfZogvIy+WbIpX6DB/RP4E0I0+M7JYrTzOTxZDtkdMKeGPL579S3rSCRXz05S+FzJBvLHMArof62vSZXqYnr1KKGt4ZWD6RncNgE2ed0xPcANzw/ygD3sfQtnOxDNQaNfXGstspVA5RjLdGOyoLO647fVVOSkP4eKNsFRlVv6SgEuqAHtXEyf7aUil6w5O/VCeTlv+d4j565gbNTDVbgGua3gehmDgCTUuTU10eOxxfSo94m7JYhutDG9jRQstBHAm2FtNnr7f5BXYsK7+XZlnU33tw4BGfFZ3MCPvjg4KqjPSnD5WCbhKlH/PhJjNCPlmh4QStWEF8ITG77ztps20KoJTn0Zsn8aVY/Jm1CX6Sl9kS66vkf/VDi1F1OKNipA0M/3g7eNP/WRE8PyWc2ZovwFZ9BP0MjZUHMuxICVRxbSsVc910f1xb/ii3K6GaiWiVa35bjoSjY9+LsH5bZo4xv6jJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 23:31:05 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm: foreign slot drain on fast path in page_counter_consume_stock()
> --
> 
> commit 4a3e7ea8b6bee1d8310dd3c42d8ad7c15aae3cf4
> Author: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> mm/memcontrol: restrict memory stock to leaf cgroups on v2
> 
> This commit disables memory page_counter stock on cgroup v2 non-leaf cgroups
> when they gain a child, schedules per-CPU stock drains for online CPUs, and
> lazily drains any remaining disabled cached counters during stock consumption.
> When a parent cgroup becomes a leaf again on child offlining, its memory stock
> is re-enabled.
> 
> > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > index e1feb2bd1e225..7a3b7cea0ff94 100644
> > --- a/mm/page_counter.c
> > +++ b/mm/page_counter.c
> > @@ -158,6 +158,7 @@ static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
> >   * Consume the cached charge if enough nr_pages are present, otherwise return
> >   * failure. Also return failure for charge requests larger than
> >   * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
> > + * Drain disabled cached counters while looking up the requested counter.
> >   */
> >  static bool page_counter_consume_stock(struct page_counter *counter,
> >  				       unsigned long nr_pages)
> > @@ -176,12 +177,17 @@ static bool page_counter_consume_stock(struct page_counter *counter,
> >  	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
> >  		struct page_counter *cached = pcp_stock->cached[i];
> >  
> > +		/* Drain any stock that is disabled but hasn't drained yet */
> > +		if (cached && !READ_ONCE(cached->stock)) {
> > +			page_counter_drain_stock(pcp_stock, i);
> > +			continue;
> > +		}
> >  		if (counter != cached)
> >  			continue;
> 
> [Severity: High]
> Can draining an unrelated disabled slot in page_counter_consume_stock()
> acquire spinning locks from an NMI or alloc_pages_nolock() context, and also
> add foreign cacheline loads to every fast-path stock hit?

Hi Sashiko, this is true (more below).

> In mm/memcontrol.c:try_charge_memcg(), may_batch is set to false when
> !gfpflags_allow_spinning(gfp_mask) so that charges from non-spinning contexts
> such as alloc_pages_nolock(__GFP_ACCOUNT, ...) do not evict other stock slots
> or take spinning locks:
> 
> mm/memcontrol.c:try_charge_memcg() {
> 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> 	/* Charges from reclaim or non-spinning contexts don't batch. */
> 	bool may_batch = allow_spinning && !(current->flags & PF_MEMALLOC);
> }
> 
> However, mm/page_counter.c:page_counter_try_charge() calls
> page_counter_consume_stock() unconditionally before checking may_batch:
> 
> mm/page_counter.c:page_counter_try_charge() {
> retry:
> 	if (page_counter_consume_stock(counter, nr_pages)) {
> 		if (nr_charged)
> 			*nr_charged = 0;
> 		return true;
> 	}
> }
> 
> For the counter being charged (counter == cached), the caller holds an active
> CSS reference, so css_put(counter->stock_css) when depleting the matching slot
> cannot drop the final CSS reference.
> 
> For an unrelated counter in pcp_stock->cached[i] (cached != counter) whose
> stock was disabled via mem_cgroup_disable_stock(), the charging caller holds
> no reference to cached->stock_css. If that cgroup and its child were
> subsequently removed while its per-CPU stock slot remained populated (for
> example on an isolated CPU where schedule_drain_work() returns false, or
> after a racing refill or contended mutex_trylock(&percpu_charge_mutex) in
> drain_all_stock()), pcp_stock->cached[i] can hold the final reference to a
> dying CSS after css_killed_work_fn() completes.
> 
> If an NMI or non-spinning caller on that CPU then runs:
> 
>   alloc_pages_nolock(__GFP_ACCOUNT, ...)
>     -> __memcg_kmem_charge_page()
>       -> obj_cgroup_charge_pages()
>         -> try_charge_memcg()
>           -> page_counter_try_charge()
>             -> page_counter_consume_stock()
>               -> page_counter_drain_stock()
>                 -> css_put(counter->stock_css)
>                   -> css_release()
>                     -> queue_work(cgroup_release_wq, &css->destroy_work)
> 
> wouldn't queue_work() spin on workqueue pool and scheduler locks in a context
> where spinning is forbidden?
> 
> In addition, the commit message notes that lazy cleanup happens on the next
> local stock miss ("The next local stock miss on that CPU scans for any stock
> that has been disabled, and will drain its stock"). Because the
> !READ_ONCE(cached->stock) check is placed before the counter != cached check
> inside page_counter_consume_stock(), every fast-path stock hit at index i will
> also dereference cached->stock across foreign struct page_counter cachelines
> for slots 0..i and drain any disabled slots before i while holding
> stock->lock.
> 
> Should the lazy cleanup of disabled slots be moved to
> page_counter_refill_stock() (which only runs on a stock miss when may_batch is
> true and gfpflags_allow_spinning(gfp_mask) holds), while
> page_counter_consume_stock() only checks counter == cached?

I think I will actually just drop the lazy cleanup. I don't think the
drain is necessary eitehr since mem_cgroup_disable_stock() clears the
parent's stock pointer and so the parent can't hold more than it already
has. Any leftover stock that remains as a result of races and isoalted
CPUs aren't consumed or refilled, and there is already an existing
drain path like other stock (when the slot is reused for another
counter, by drain_all_stock(), or CPU hotplug). 

So yeah, I'll just drop the lazy drain and rely on the existing cleanup
paths, and I think that addresses all of your concerns.

Thanks, Sashiko!
Joshua

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261104233029.3282438-1-joshua.hahnjy@gmail.com?part=7


