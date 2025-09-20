Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E48CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 03:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20F548E0002; Fri, 19 Sep 2025 23:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6DC8E0001; Fri, 19 Sep 2025 23:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCFE8E0002; Fri, 19 Sep 2025 23:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFED98E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 23:57:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72759C06F8
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:57:14 +0000 (UTC)
X-FDA: 83908268388.25.03351AC
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94878140004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:57:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WXP0AYNY;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758340632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xH6hM5+uYUvpQzwjZ48WJR43EdufTTb4azsiErKH1OM=;
	b=Jz586EonK5FltHgg8HKopE61929c3R4ANTCAL1cc2/kzYpt5iSNHEnqU47VhLzLsCd3pV4
	JHy492f+lq8OHqfNYrjNHOSA9UgsGpAg5zrx6aD44x9zQ+hz0YkUlucdUto2G9rWyIDp4V
	ERmQm7BY+WEvFR+On73petF1Kk3IC/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758340632; a=rsa-sha256;
	cv=none;
	b=SpHE0JzCgic/GycBotbf1dsldMHlfWW/RsPiaY7GBOFZirgpZfKG9dvDW/ZophoNlY0Wu1
	3aHh8L0Q6uP4lcBQ2eijuY7NIgG0XmQnBusQCvR97O+dsO+mS0SFaRYpAv9AstYfhRU4Vg
	/PPy/1xeyk9D6KaeH5uvDHkMU2MRw7o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WXP0AYNY;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-73b4e3d0756so18803737b3.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758340631; x=1758945431; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xH6hM5+uYUvpQzwjZ48WJR43EdufTTb4azsiErKH1OM=;
        b=WXP0AYNY9Js13YG5bAEEyfmY6eorx0/q9gqvOy171zeFigdNFyJySvIPP/L+oRW6//
         We+uUkZUn4JMiMIwEhCgU6E2LjhiCvSO5HoUUg+Fxxw87qKja3jXvZazGsD7YaCSrzhe
         5/ZzXbH3ic0mVRt/47cde+IGs+wSr8TupORAOWHWtzqhitAF7/lVal18oRmoUbg5y8vG
         /lm5U1P1SEsEZbJCIap8mijjJlOyGXH2hJ+OIcelIcL85GneOMTrDXZl9V/jmIctXrOQ
         NqZPi2aKSBM/o5khZFLOyHToqanyHA37zRrriREMektNyX3In1gkEUGtym/ALffl/phm
         tv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758340631; x=1758945431;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xH6hM5+uYUvpQzwjZ48WJR43EdufTTb4azsiErKH1OM=;
        b=Ca9IgVXWtiVK9UDrMr/7w26iGi+8PG3K9BSY8aYkUErRtWHL9HTDSNwPMBZsTmraxh
         o0zdfo1C3hZoDNwlcX+7l5WbrmMaHxVBdmquvTtKbHXYaKpHyvxSxAByj4XmUGnsZywN
         /PjmqQ7yGh4HAmc6fMpwAOgtgc9KSAtqRr69ENI09cl4TfxXbsWUUEk4NqkA54zoZ4G3
         iySkLkZ/xEjmnI1fQwUivoWeVpO3sWgtLDmcwbEijTGveDjMF/rAN/zCSf9ux+O+jSyF
         DO7ms3vvCbm4jOc/QPhRODJmfTM/LIdQRn/lzYXnyBMWHYFhrzFq10MbbDENft67Bm+P
         7C6w==
X-Forwarded-Encrypted: i=1; AJvYcCVD5sKi30N313C8cXs+JowsBA7sTtYHFl6JMRacqYs4XBQ1fcbvw4CuGu5/n+EJ9R1GqgtKje/QTg==@kvack.org
X-Gm-Message-State: AOJu0YxwebRUOua9dQRNiFyV8pxC8W8DSSDS2PoTNJX1vBB7hpsY7CVy
	oawMfubuG20Y6F95vDV/YLZMVgjgPIspV9gUZ5byiLe1+oZ6Ur5iELn3UAkabPk4bg==
X-Gm-Gg: ASbGnctsa0KGQUesPXzImXcCT3auya8dBx5pmfo5ApSFYDbs0K2k34xydVx2tWcf+KZ
	SkFUiKo8KnyMaDuMrYfZu/d+zb4oOxiedpnwqGj8FWm/U/iOI8pqPTDeGEdTY7qEe8ikxlVZvgA
	Ah/kuGUCWBTY32j5OYiek1YRrG/2tbC9D6eBbfoqTtPR0d8F+EucnYkdZUy4VBYTNyoJ3G9N05z
	uP20QQ5pU7sR1F9YTnGGzEf5vUJ8hOkdKcHUyl6tpIPpRW3/y6g78D7R6bY1cq5w5vTkAd2QLIo
	Vkxk3/2b3c+A14GiWCWMh+/nVnwS7RpW8ycFffz5gixO6DykmaOwxhWg9FI+cvq1w0Zymovk7NM
	SpJzNqeuiSbXsQBodOgLMzjwIK+Eb1js6LNgdS54Xjo+tskVwLKfQ/RL2VK4zxxU8SIqkMf0tdV
	Hmq/1IsEI=
X-Google-Smtp-Source: AGHT+IFOjydhTIxOMuRWaHPVHVnDuc+CupOCKpxARECSbvouVQMdvs/yAMFktox+RTHRaDtzQiQwxA==
X-Received: by 2002:a05:690c:74c2:b0:71f:b944:100e with SMTP id 00721157ae682-73d40fc806cmr50255247b3.53.1758340631208;
        Fri, 19 Sep 2025 20:57:11 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-73971700944sm19051247b3.28.2025.09.19.20.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 20:57:09 -0700 (PDT)
Date: Fri, 19 Sep 2025 20:56:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: SeongJae Park <sj@kernel.org>
cc: Xinyu Zheng <zhengxinyu6@huawei.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Paul E . McKenney" <paulmck@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>, damon@lists.linux.dev, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, zouyipeng@huawei.com, 
    Hugh Dickins <hughd@google.com>
Subject: Re: [BUG REPORT] mm/damon: softlockup when kdamond walk page with
 cpu hotplug
In-Reply-To: <20250918085249.58966-1-sj@kernel.org>
Message-ID: <296c2b3f-6748-158f-b85d-2952165c0588@google.com>
References:  <20250918085249.58966-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: t1btcuoo4o1w7fssxfzrps1cz4c6h4sg
X-Rspam-User: 
X-Rspamd-Queue-Id: 94878140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758340632-976355
X-HE-Meta: U2FsdGVkX19Yrqk1a8ZXzr/tu3BjFj6K7vvdgs+3OPsvwK2QE4S3E8UJwLnVHQrt9L1iaVu4Toh40qVULw8ygOBvIwd9WOCd0vnW+Hz+aKI+8T/Fr4yGFygmbsrWziApOmrdTt9X5wWvJaPj1C/K+SSSp4MleR+C/d/VfLonk9IlzXcaZxRNevRdigxOxOkJuTgul3zpwifZ9rBtg3Y2B5rMi00vxrFR3SmYXV0cd5OU4g9ToNCJbh1u0s2f20/c+mxICUyMXqwH7iYT0cYarOhJzSF0AHmobSr4hsnu0ejS87i0wmwpkN0FWe7zPkNn56ajpQJNTDBkglfrhYu+dV7PwHzSnuPIDGg/JrJChUSK9w9sSfxM3EPniHEjyLwhwA4QBJmSVQ7pPzRQfEIvgHFR8Vl/VkR0D2xOr5+3HoZpE5u9nkj78SW3alQl41txPYURxhXR1jrzXRDbQU0Om5SJiPzDq8ie+/Iry+7ypxNriQbSG6lIb/rt8PhIgsnMHfOy/0C0uLkaVGL/4d+D+qj4hzREDXTDQ7/Ukx13fCTVDcUiS7eZTamSuf7FC8ntc/KKS7vti1aovOYRBLk2BxQ9GpxgRJ9Y35FAOmZCueidYurIJw59JVjAhb/ZvlGGPi2133rzrUeiDQz8cY61FgcG6LGJoKwECHnf9uhR8d0xNEX9RvqFAJ4jfvPAfHFS92dBpW5aNK1/JWsfyCBlSyvjcDInUipGzKlGw3QDpBWgIlhpk1lSdlfSAGgKD3nHCtRzQv5ytUfVaBhe90K0lzzm9eeuE0zo1RPJom+K6fW8ufYUPADZYDm8Tezvat5woF43OOPEGOXDIU0qVHoFbYYfuzk6dEskd77f4yhwUwRXzKnRWX1NHHX2idmHOEjKclQIKh/xx53+0RT/LSb4HNmf9ABU7Gc6TcawRaF64DYzpH6vDITC4O5F3NSjClbCNnw7BvEvZUghAet+PDD
 dOt3BbFT
 tHozrTZqqFcqWCHWknMfphz9lSPQZCl1mZgBIEXJIYm7flf0XYYDyyn5+8ctSgVw6gaIWOPGd3AzpD8cE2rQgTlUEpzVAFz4naTbDgf/rowrU8uI/Znw/KXmnLd560EvrLjhRbt9TN5/R34iUld1i9PqX4D1B8pvLbg3HWSxN1PeUlTZ4M/KBGBU8dSjAk/bKaja15ujenrJiJelEA0SBA6HDOEFm/QXhhMJoHNJLDN9juWB5dJ0CwGbAkmggIQxzvpruoXsytFoqSKYVkmOGsFpTze+HXBLwWG/PY9ehyePAkjKglcWbJym+XVpki45Gii3E9hN8+6Il7bPHDs0JCVuSP8IaA9/++M+EYSxuI43suCB0wLzWpVEYJgLIvkmvRWdpoJ33HEyLAfsSohcyYsOyDEShrclZHBFHXhg+cYA+6mlsp6OaKKWwIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025, SeongJae Park wrote:

> Hello,
> 
> On Thu, 18 Sep 2025 03:00:29 +0000 Xinyu Zheng <zhengxinyu6@huawei.com> wrote:
> 
> > A softlockup issue was found with stress test:
> 
> Thank you for sharing this great report!
> 
> > 
> > watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [migration/0:957]
> > CPU: 0 PID: 957 Comm: migration/0 Kdump: loaded Tainted:
> > Stopper: multi_cpu_stop+0x0/0x1e8 <- __stop_cpus.constprop.0+0x5c/0xb0
> > pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> > pc : rcu_momentary_dyntick_idle+0x4c/0xa0
> > lr : multi_cpu_stop+0x10c/0x1e8
> > sp : ffff800086013d60
> > x29: ffff800086013d60 x28: 0000000000000001 x27: 0000000000000000
> > x26: 0000000000000000 x25: 00000000ffffffff x24: 0000000000000000
> > x23: 0000000000000001 x22: ffffab8f02977e00 x21: ffff8000b44ebb84
> > x20: ffff8000b44ebb60 x19: 0000000000000001 x18: 0000000000000000
> > x17: 000000040044ffff x16: 004000b5b5503510 x15: 0000000000000800
> > x14: ffff081003921440 x13: ffff5c907c75d000 x12: a34000013454d99d
> > x11: 0000000000000000 x10: 0000000000000f90 x9 : ffffab8f01b657bc
> > x8 : ffff081005e060f0 x7 : ffff081f7fd7b610 x6 : 0000009e0bb34c91
> > x5 : 00000000480fd060 x4 : ffff081f7fd7b508 x3 : ffff5c907c75d000
> > x2 : ffff800086013d60 x1 : 00000000b8ccb304 x0 : 00000000b8ccb30c
> > Call trace:
> >  rcu_momentary_dyntick_idle+0x4c/0xa0
> >  multi_cpu_stop+0x10c/0x1e8
> >  cpu_stopper_thread+0xdc/0x1c0
> >  smpboot_thread_fn+0x140/0x190
> >  kthread+0xec/0x100
> >  ret_from_fork+0x10/0x20
> > 
> > watchdog: BUG: soft lockup - CPU#18 stuck for 26s! [kdamond.0:408949]
> > CPU: 18 PID: 408949 Comm: kdamond.0 Kdump: loaded Tainted:
> > pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> > pc : damon_mkold_pmd_entry+0x138/0x1d8
> > lr : damon_mkold_pmd_entry+0x68/0x1d8
> > sp : ffff8000c384bb00
> > x29: ffff8000c384bb10 x28: 0000ffff6e2a4a9b x27: 0000ffff6e2a4a9b
> > x26: ffff080090fdeb88 x25: 0000ffff6e2a4a9b x24: ffffab8f029a9020
> > x23: ffff08013eb8dfe8 x22: 0000ffff6e2a4a9c x21: 0000ffff6e2a4a9b
> > x20: ffff8000c384bd08 x19: 0000000000000000 x18: 0000000000000014
> > x17: 00000000f90a2272 x16: 0000000004c87773 x15: 000000004524349f
> > x14: 00000000ee10aa21 x13: 0000000000000000 x12: ffffab8f02af4818
> > x11: 0000ffff7e7fffff x10: 0000ffff62700000 x9 : ffffab8f01d2f628
> > x8 : ffff0800879fbc0c x7 : ffff0800879fbc00 x6 : ffff0800c41c7d88
> > x5 : 0000000000000171 x4 : ffff08100aab0000 x3 : 00003081088800c0
> > x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> > Call trace:
> >  damon_mkold_pmd_entry+0x138/0x1d8
> >  walk_pmd_range.isra.0+0x1ac/0x3a8
> >  walk_pud_range+0x120/0x190
> >  walk_pgd_range+0x170/0x1b8
> >  __walk_page_range+0x184/0x198
> >  walk_page_range+0x124/0x1f0
> >  damon_va_prepare_access_checks+0xb4/0x1b8
> >  kdamond_fn+0x11c/0x690
> >  kthread+0xec/0x100
> >  ret_from_fork+0x10/0x20
> > 
> > The stress test enable numa balance and kdamond, operation 
> > involves CPU hotplug and page fault with migration.
> > 
> > CPU0				 CPU18                      events
> > ===============================	 ======================     ===============
> > page_fault(user task invoke)
> > migrate_pages(pmd page migrate)
> > __schedule
> > 				 kdamond_fn
> > 				 walk_pmd_range
> > 				 damon_mkold_pmd_entry      <= cpu hotplug
> > stop_machine_cpuslocked	         // infinite loop
> > queue_stop_cpus_work		 // waiting CPU 0 user task
> > multi_cpu_stop(migration/0)	 // to be scheduled
> > // infinite loop waiting for
> > // cpu 18 ACK
> > 
> > Detail explanation:
> > 1. When shutdown one cpu, a state machine in multi_cpu_stop() 
> > will wait for other cpu's migration thread reach to same state. 
> > In this case, all cpus are doing migration except cpu 18.
> > 2. A user task which is bind on cpu 0 is allocating page and 
> > invoke page fault to migrate page. Kdamond is looping between 
> > damon_mkold_pmd_entry () and walk_pmd_range(),
> 
> damon_mkold_pmd_entry() calls pte_offset_map_lock().  If the call returns an
> error, damon_mkold_pmd_entry() sets walk->action as ACTION_AGAIN, to retry.  If
> the pte_offset_map_lock() continues fails, infinite loop can happen.  I
> understand the loop you mentioned above is this case.
> 
> The error handling (retrying) was introduced by commit 7780d04046a2
> ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails").  According to
> the commit message, it is assumed to be safe to retry pte_offset_map_lock()
> inside walk_page_range(), but it is not for this corner case.  And the commit
> introduced the error handling pattern in not only DAMON but also a few other
> pte_offset_map_lock() callers, so I think same issue can happen on those, too?
> 
> So for the long term, I'm wondering if we should update pte_offset_map_lock()
> or whole pte_offset_map_lock() error handling inside walk_page_range()
> callbacks to deal with this corner case.  Or, other involved parts like CPU
> hotplugging handling?
> 
> > since target page 
> > is a migration entry. Kdamond can end the loop until user task is 
> > scheduled on CPU 0. But CPU 0 is running migration/0.
> > 3. CONFIG_PREEMPT_NONE is enable. So all cpu are in a infinite loop.
> > 
> > I found a similar softlockup issue which is also invoked by a memory 
> > operation with cpu hotplug. To fix that issue, add a cond_resched() 
> > to avoid block migration task.
> > https://lore.kernel.org/all/20250211081819.33307-1-chenridong@huaweicloud.com/#t
> > 
> > May I ask if there is any solution we can fix this issue? Such as add a 
> > cond_sched() in kdamond process.
> 
> I think adding cond_resched() on the error handling part of
> damon_mkold_pmd_entry() is doable.  Since DAMON is a best-effort approach, just
> returning without setting ACTION_AGAIN would also be ok for DAMON.  It will
> simply make the behavior same to that before the commit 7780d04046a2
> ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails").
> 
> If this is a real issue making your products bleeding, please feel free to send
> such a fix for DAMON (I'd prefer the second approach - just return without
> setting ACTION_AGAIN) as a hotfix.
> 
> Nonetheless, for long term, as I mentioned above, I'm wondering if we should
> update pte_offset_map_lock() internal, or add similar error handling
> modification on every similar pte_offset_map_lock() error handling.
> 
> > Or is there any chance to do some yield 
> > in stop machine process? Probably next time there is another different case 
> > running with cpu hotplug can cause the same softlockup. 
> 
> I'm not familiar with stop machine process, so I have no good idea here but
> this might also be an option?

This had me worried for a while: thought we might be needing to change
lots of other places, and scatter cond_resched()s here and there.

But no: no need for cond_resched()'s, this is all just a confusion about
where pmd migration entries are handled: a pmd migration entry is accepted
by pmd_trans_huge_lock(), but is not accepted by pmd_trans_huge().

See fs/proc/task_mmu.c for mm_walk examples of trying pmd_trans_huge_lock(),
then pte_offset_map_lock() if it failed, or ACTION_AGAIN if that failed too.

When I ACTION_AGAINed damon_mkold_pmd_entry() and damon_young_pmd_entry()
in 6.5, I didn't realize that the pmd migration entries were reaching the
pte_offset_map_lock(), with corrupt results (or did pmd_bad() filter them
out? I didn't think so, but it'll take me too long now to work out whether
a pmd migration entry counts as pmd_bad or not); but knew that the new
pte_offset_map_lock() filtered them out safely if there was a race.

But they've been reaching it without any race, so yes the ACTION_AGAIN
would send the mm_walk back again and again for as long as the pmd
migration entry remained there: not good, and Xinyu finds a lockup
when hotplugging CPU without preemption.

My suggested patch below (please take it over SJ, and do with it what
you will), converting damon_mkold_pmd_entry() and damon_young_pmd_entry()
to use pmd_trans_huge_lock() as I'd been expecting, so handling the
pmd migration entry up in that block.  (Side note: patch against 6.17-rc,
but I see mm.git adds also a damos_va_stat_pmd_entry(), which would
better be converted to the same pmd_trans_huge_lock() pattern -
though I notice you're not setting ACTION_AGAIN in that one.)

But I have to admit, there's very little gained by using ACTION_AGAIN
in these functions: it helps not to miss the range when racing against
THP collapse or split, but you're already content to miss the extent
if it has a pmd migration entry, and there can still be an instant when
the range which used to have a page table does not yet show the THP.

So if you prefer a smaller fix (but a larger source file!), just
dropping the walk->action = ACTION_AGAIN lines should be good enough.

Hugh

p.s. I believe it would be possible to do the old/young business on
migration entries, but I didn't have the patience to work out the
conversions needed; and it shouldn't be part of a fix anyway.

---
 mm/damon/vaddr.c | 39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 87e825349bdf..c6b51a52fca0 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -307,24 +307,14 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
 	pte_t *pte;
-	pmd_t pmde;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
-
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
-
-		if (pmd_trans_huge(pmde)) {
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		if (pmd_present(pmdp_get(pmd)))
 			damon_pmdp_mkold(pmd, walk->vma, addr);
-			spin_unlock(ptl);
-			return 0;
-		}
 		spin_unlock(ptl);
+		return 0;
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
@@ -448,21 +438,12 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		pmd_t pmde;
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
-
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
-
-		if (!pmd_trans_huge(pmde)) {
-			spin_unlock(ptl);
-			goto regular_page;
-		}
+		if (!pmd_present(pmde))
+			goto huge_out;
 		folio = damon_get_folio(pmd_pfn(pmde));
 		if (!folio)
 			goto huge_out;
@@ -476,8 +457,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 		spin_unlock(ptl);
 		return 0;
 	}
-
-regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-- 
2.51.0

