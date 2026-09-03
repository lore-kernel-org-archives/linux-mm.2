Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04340C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 19:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB356B0095; Thu,  3 Sep 2026 15:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BCA6B0099; Thu,  3 Sep 2026 15:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8756B009B; Thu,  3 Sep 2026 15:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31BF66B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:09:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 961861C1F65
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:09:06 +0000 (UTC)
X-FDA: 85173388692.23.EED3ACD
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCCDFA000D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:09:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IYEj1hVc;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788462544;
	b=WgYqnA9ZpA9MEDx+81OcssE4xLUq8X7O1IFWKyygqJPdZBHV0+oODWl4QdEWvxCoKGZp69
	igSqal2eWcg0/oZ17IU7Z1PRVQ77nTz9bZbaNBW8YpsorgbsgvjRbUmZOX4vffb4DVTYpo
	aj9Js3OU9aPUM1QjC+5TK8tfnPc0oug=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IYEj1hVc;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788462544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0jjBKM/T0lxzBL1G/oFuXqJ/xjVo9f/c2XBOtxdJVs=;
	b=ijBZHEntASlVf9+Rcvq8jdi+tdGx7sPVax6cAzqYsLAzVnQqM/pLxyc8hs2AjcqPj1tIw0
	1UKJzsFUqktgFI6paRbyA6VUMHnDRZvvUwzJyz/hTHLhiAl/SqZjGj0K7yvj65wuQKIPfS
	AW9CwK8vt+YrTwhleR5nTH65QleF5jo=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-86162c086f8so2648387b3.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 12:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788462544; x=1789067344; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B0jjBKM/T0lxzBL1G/oFuXqJ/xjVo9f/c2XBOtxdJVs=;
        b=IYEj1hVc8NERWQdp6adc4i1wReL8PLjBcbCsWR7j6cB0kwbknfqJyHiPj9uq1pN2aX
         vHFXqYN/FtxVQlhcdDSUNGanTHKmelsSEaR333NP78Sh9c568Q77kTVRh1jPXBv3cqOf
         EXejBf7t9kZqYPV537CqL7BkeAihhtBbmZAKFBFWzKp0FAeTkZIkyCj5GZ92bdegDJKs
         BCCsK+Eg+mBWbStXu4SjKkpFGIAf7QTSSq9igdFFH2uc1PKLIZ/9ROIdwMr1q5p/q2gQ
         RSvR69dGwBiMduL8V80iMu5xP8U4cfVvI3Bs7zVYK+rxbyho+YxtiOQOycXIJc/dDLuG
         siHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462544; x=1789067344;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B0jjBKM/T0lxzBL1G/oFuXqJ/xjVo9f/c2XBOtxdJVs=;
        b=sfbq0ACTBLhcXUGC2x44OJHgvEcA8g1R2PU1wzocSoaV9LuG9KyWsKGaON425KmBAJ
         EGCGH7M4m2xv2XZ/F+ztFzfOvFTQs3V1DJS68s+o246BeZQAde0iMaPE73Yc/7JI2vjJ
         e/qJT1NJ9XXGw8KH3fhw2Dwne1NwvkI25B2I9WnS3KjYRlRpw7urGGIPaXMuCakr9PIx
         IImmNvixUWHFH/G7dsi7J+pukJsglsD1DTubGDYlsicb95nCdu8xxT6Nyigxg3mxsonN
         RBTnBsmqCZsCOoBLKVDutgRXQwaCwLCngd5FPIkLYq6ByII7EMhTnX0jK63muPlBWkOo
         mKxQ==
X-Forwarded-Encrypted: i=1; AKwUvBxaNrG66NRBLKrWQvuOBI/JIfB3gmAWTgNOlM2u6udawoLLLCGpu4EG+XG0ymxkrkN8nUNODPiI2Q==@kvack.org
X-Gm-Message-State: AFuF++lc6b8PA1G6jDAZo7IAsFHguXHKQj0TTsEe91TNxjTnMP3mduHy
	y1kv5UMvYP7t4HXpwjSgoQ9iW9DEOsw5kbdMdH1qbBfaYabEYToAMFzK6NBfTvnU7A==
X-Gm-Gg: AYBFou1aoPhk4F/DY2QThQCPxx0Ec0eRGi2Xze/Xbm1h+AWmMhlvY2CmJbguPIEiCNA
	zA1KszmON6OxUHtB87i7KMlmlL2RhY/Xe+hy9U8l+k40RK+TAKbdrobud6HCdpCWTwYo3xivfun
	QAZ8+tM2fcOgIMb9UBIiJ9AcR1lIvqQ6iMLNJXJaLCuVXOB4PVWQy/4A6vRZRtROUbYmch8SU7S
	UDb+hFqjQdtZojbz/QmrmBjRcl1fDqlu7KEFTTX9lPpe+j1esfobsGX03Cio0iJj1ZDUP6+BXcS
	2fxH3cZQxvvr4tPJ0IDhENol3fRL/m11Kv0LCdwCpGJZAkAhMGYfQx58rIvQB3sHDtds2INDAa/
	mjIaSuXxDYajIAEVgX+30JQiR6yB0R4/o2SC/lND8g2Evz86nkZnddjrG4KHzFqlYP9J1IAl3RH
	BH8M4qFZGCyAB85DHQN3vMheR7iuaps4IpiSx6yE8a9V78mfd3PbgtpA6VlPchOdjo+y2ULj6GU
	h2Twb8srZdWBTviHvxJ3TPBvW2LLGV45+Xk4ts/Tt1RV5ai
X-Received: by 2002:a05:690c:e257:10b0:80e:c332:1796 with SMTP id 00721157ae682-86e7081d3ecmr33938977b3.10.1788462542453;
        Thu, 03 Sep 2026 12:09:02 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714af5581bsm2146627b3.36.2026.09.03.12.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 12:09:01 -0700 (PDT)
Date: Thu, 3 Sep 2026 12:08:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kas@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/25] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <aplHq9bvNdyPGEw-@thinkstation>
Message-ID: <e2098d3b-722a-50aa-3b01-ec012f05c1e5@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <16b39f43-d91e-7b23-900e-90cec13837ff@google.com> <apAllneItXmyjRPo@thinkstation> <7b30ca86-dca6-83b7-a632-180e35ed2a0c@google.com> <apThx6sWOQ-aZcN7@thinkstation> <821cced3-dcc8-6c80-a92c-c568c2639e5a@google.com>
 <aplHq9bvNdyPGEw-@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCCDFA000D
X-Stat-Signature: gcaiaz1m53r3zhzs71egud9xbni1zd3o
X-HE-Tag: 1788462544-689725
X-HE-Meta: U2FsdGVkX1/GvJDe0CQ8xy36QdK2Xqb4B2/Zsa8Av38jepOqQna+1cIzzrwxMvl1KSd/RvA+0XLnjVG72MHX8YAGvpvlJ4zkyN0D+oyhJQWLxYdokbsGult3H+x6TtR2dDdzo3C+xYI/N1YXg2hrLyjm9YRmI0OYP1K8RFiYPExwm/Jio0DudZZKKGV695AOchoYDICqQiS9jg1HXLM6xvj1NsYsfUx7dzDFyk6YaqaGn+gvlji7M6Yu1O3yebyqJM2g8Z1gq6Xc9wXgxP3FfJ8DbOp/124hv1Lp4HFRt2AZqJR5b+iBVmFaiq3IewOIVuu/CBfLYawTmDhSaSfTnec9cGF6HYd95+c2bWMLzVi1JYmho9QVla83oO1ZmJk9CHh5IjeeohhzMex/hvPmKQHXoez0Dc2EnNbfRk0Dj1MLlB7d0e1b4sLJfPYkh9jTJlUgA6tNUKe1ZtROvSutLPqruuASTRMe/If5JmQMPzWsuGUjK1b5U6ZkjVh76XsKBfHNeM2T0QR8reXYtXmNYtGXISWqWitSLq3OYELe7xdQtzPOq8fNuj9E16rSq3GfbNnN+apky/VZkm0ojIf7jJCT+ubglH8qWunGjfGWcpJvJL0HZFOa9UOpP3gz3Y4IX+XWTTv/+D8tVVrU/Ae/cozOYynA7cseeeymfMZ7qcXVTFp4Ue9Z3aSeComzwQCxVzln8yjRT+f5fURGC4oRZ5Wii3z+G3HWsdGVrX4DQZ1tQwQKk96hqJjY3U0X3rF9cdlRIaY93cLso+8Tmu7LO6wFnvgY8/M3+bFdnAbwa0cIOKnfD/KiljnLxA4KhGniF6rjb5WqfawrHL1xMUf5iMwUSEdBrJzpyTUuHfvrw30mHQZS0H/6Dk1jTMfi8twYwb4/9MxHNw/gJw+bIP3BNdSY01tF1CcrVABUxSVQEI+YuFakd92VvNZ8OAOKpzss7A+Q1hVvCglLFNM2oDI
 qNqYQOuI
 nhJctGfrI/5xFBht79adGlaUNTV74DNJZ2OTpyK2f0yhJuf0nU2gJe+cSMAf2J98Fikk7kW84lsmLKKvFLFNERC/meRgs5Xdf4DDFa+t7Hr28eIvew1YmD9K9k6MdGgIMJfHTxiyJX1e+GOk/O3HzZUFw1RhD2ZmaMfs/qlBqWcX9vP19dU6+mX+0ZPtkKuWchvWedU67I6vGl8avMKPUTVDXq+YXdf1hUmw7tb7Vm+9f9yzyBlYqX1n+8umrwR8SVkv1YA2mFwEEkk18xRyXbJJSEmtYxA8m8HAFhR7bGujKVsAPocggazrWAblx6iMQ/MTVhARf97uY1fqipu6eaHC3ThTRXNQLuDtJJHZftZr10LDF/H36KcD04GJf2M8pp9tC/sQxZpdpUFcANm/roZO6e2QZFO2H+AWbWGNEZtXvf9cjJRA0Dj9qjEkrnCnj1d9zjWUCaivZArMux6+bjALm8HagdJ4DbnleJHpi75Z1geo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026, Kiryl Shutsemau wrote:
> On Wed, Sep 02, 2026 at 10:41:56PM -0700, Hugh Dickins wrote:
> > On Mon, 31 Aug 2026, Kiryl Shutsemau wrote:
> > > On Fri, Aug 28, 2026 at 01:40:51AM -0700, Hugh Dickins wrote:
> > > > Do you have a head for smp_mb__ barriers? I'm more anxious that
> > > > I might be missing one or two of those.
> > > 
> > > I think the release side of PG_lru is missing.
> > > 
> > > You effectively turn PG_lru into a lock over folio->lru.next.
> > > 
> > > The acquire side works: test_and_clear_bit() has a return value, so it
> > > is fully ordered.
> > > 
> > > But there's a problem with release. set_bit() is unordered. You
> > > correctly placed a fence in __folio_add_lru(), but every other
> > > folio_set_lru() is problematic.
> > > 
> > > For instance:
> > > 
> > > 	CPU0 				CPU1
> > > folio_batch_move_lru()		folio_batch_move_lru()
> > >   lru_add_del_folio()
> > >     lru.next = LIST_POISON1
> > >   lruvec lock
> > >     list_add()
> > >   /* no barrier */
> > >   set_bit(PG_lru)
> > > 				  folio_try_get() == true
> > > 				  folio_test_clear_lru() == true
> > > 				  lru_next == stale BATCHED ???
> > >   lruvec unlock
> > > 
> > > If CPU1 sees a stale BATCHED, lru_add_del_folio() returns true without
> > > doing the list_del() or the NR_LRU_BASE accounting, and CPU1 then goes
> > > on to lruvec_add_folio() a folio that is already on a list.
> > > 
> > > I think we need to have a helper that would set PG_lru and enforce
> > > release semantics.
> > 
> > Thank you very much for this, Kiryl: it helps me considerably.
> > But I have to cool myself down close to absolute zero to think
> > about these things, and can only manage that occasionally.
> > 
> > I've nothing useful to say yet. I believe I understand you, and in
> > particular your last sentence, which I take as an observation that
> > clear_bit_unlock() is well-established, but what we want is
> > set_bit_unlock(), perhaps better named set_bit_release().
> > 
> > Of course I'm not competent to add that to N architectures, most of
> > them unfamiliar to me.  So I'm looking for a reasonable compromise,
> > to minimize the additional overhead needed for correctness here,
> > just using what we have already have (test_and_set, smp_mb__).
> 
> It would not be N architectures. This should be good enough:
> 
> /* include/asm-generic/bitops/lock.h */
> #ifndef arch_set_bit_release
> static __always_inline void
> arch_set_bit_release(unsigned int nr, volatile unsigned long *p)
> {
> 	p += BIT_WORD(nr);
> 	raw_atomic_long_fetch_or_release(BIT_MASK(nr), (atomic_long_t *)p);
> }
> #endif
> 
> /* include/asm-generic/bitops/instrumented-lock.h */
> static inline void set_bit_release(long nr, volatile unsigned long *addr)
> {
> 	kcsan_release();
> 	instrument_atomic_write(addr + BIT_WORD(nr), sizeof(long));
> 	arch_set_bit_release(nr, addr);
> }
> 
> /* arch/x86/include/asm/bitops.h -- mirrors arch_clear_bit_unlock() */
> static __always_inline void
> arch_set_bit_release(long nr, volatile unsigned long *addr)
> {
> 	barrier();	/* LOCK prefix is already a full barrier */
> 	arch_set_bit(nr, addr);
> }
> #define arch_set_bit_release arch_set_bit_release
> 
> I don't know if we want to make it _unlock() to match
> clear_bit_unlock(). Naming is hard.
> 
> x86 does need an override, since it has no locked OR that returns the old
> value -- arch_atomic64_fetch_or() is a cmpxchg loop.
> 
> arm64 is happy with the generic version.
> 
> ppc and riscv need a definition of their own only because they do not
> include asm-generic/bitops/lock.h, so the #ifndef above never reaches
> them. ppc can take the generic body. and riscv is a one-liner right next
> to its existing arch_clear_bit_unlock().
> 
> This set_bit_release() gets better results than alternatives:
> 
>                 set_bit_release()  smp_mb__ + set_bit()   test_and_set_bit()
> x86             lock orb           lock orb               lock btsq
> arm64 LSE       ldsetl             dmb ish + stset        ldsetal
> arm64 LL/SC     ldxr/stlxr         dmb ish + ldxr/stxr    ldxr/stlxr + dmb ish
> ppc             lwsync + loop      sync + loop            sync + loop + sync
> riscv           amoor.d.rl         fence rw,rw + amoor.d  amoor.d.aqrl
> 
> I can prepare a proper patches with what I listed above, if you want, so
> you can prepend to your series.
> 
> If you don't want to go there for the initial series,
> smp_mb__before_atomic() plus folio_set_lru() should be good enough:
> 
> static __always_inline bool folio_test_clear_lru_acquire(struct folio *folio)
> {
> 	return folio_test_clear_lru(folio);
> }
> 
> static __always_inline void folio_set_lru_release(struct folio *folio)
> {
> 	smp_mb__before_atomic();
> 	folio_set_lru(folio);
> }
> 
> -- 

Thanks a lot for taking this further, and we may indeed want it later;
but you guess correctly that I don't want to go there for the initial
series, and I've not yet convinced myself that it's what we want anyway.

Assuming that the existing pre-series code is correct just to use
folio_set_lru() throughout, what I've added are these additional lru_next
transitions, unprotected by lruvec lock, and it's just these which need
the additional protection.

So, I haven't finished thinking on it, but what I'm currently inclined
to, is putting an smp_mb__before_atomic() after the LIST_POISON1 in
lru_add_del_folio(). That's a long way from the folio_set_lru() it's
intended for, which is unusual, but it seems more to the point than
always using folio_set_lru_release(). We can switch to a proper
folio_set_lru_release() later, if that's usually seen to work better.

Hugh

