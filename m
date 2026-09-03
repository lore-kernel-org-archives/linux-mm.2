Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 727C3C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7455D6B009B; Thu,  3 Sep 2026 06:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6AE6B009D; Thu,  3 Sep 2026 06:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BDDD6B009E; Thu,  3 Sep 2026 06:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2026B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:56:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28713C04B5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:56:32 +0000 (UTC)
X-FDA: 85172147424.22.AFE5BC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 21A5E40004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:56:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1YJ8g4Z;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788432990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XiQkSdBuViJhK1RAwv/WcHb/2F2HMU7HpXbahyvM+E0=;
	b=FqkKedsGGqM+ETDz8gQXwiuChrA/eoewCSaXljMW240ibc8Y6jG80kVch1pDxyRWoVE9vW
	Sby0V2k9iUaSS6t+//KDBgtqZHaFPwokW51NP0dYpHxGq59TLdE+DBZYSHuyL42Bf+gD2k
	QkvkR0TlukR9kAj35+fKAsEHRKs3qdY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788432990;
	b=0NtuOeVRKAP/uWq7w/iKgFhVW+QH+Sm9uzri+Hlg0R1m2qjrUuqStQQ09M/qesRLxstDFk
	GDlyLGRyZWavCaSYzYuRKBUkWHk+wQPQA3inOIG9D+UL5r4TmAS/M0UrKBjEQjCYtFEcV4
	wfok1xO55w3gnPGoIRIh0urx1A1q+kQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1YJ8g4Z;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D18343E10;
	Thu,  3 Sep 2026 10:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDAF1F00A3A;
	Thu,  3 Sep 2026 10:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788432989;
	bh=XiQkSdBuViJhK1RAwv/WcHb/2F2HMU7HpXbahyvM+E0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E1YJ8g4ZDmJgFYPmGdtkXbt2SbGloE5KgPWiNDmzYD5H+0i1jL8mpi84emSVbjnO9
	 irmLmjENy8Zbj5AWR/LdO0ZYMJQhl6SXrMNxaCHkawiW1PStgucE6DgdDT96bqGsUD
	 Fh0FRbuEPJCfS2Bpb3MuSbwk6FnaCOoy0D/G3SzzNTwMoBScNNCuwa0A/nh5tuwvPh
	 fd1MXtLfC4O2IeYkEY9m4uOFEafrLJJILsc4dqdfNz7gS0mct91aAnrv0Yn7VTKC3D
	 6RCcENIlKlTGaeuoLwdE4s58mGXaMLJUbgNe1NfPhzX9/2AMwL6Q/AOUq/9O6WXjoI
	 nnym8RX/8zigA==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id 893DA198003A;
	Thu,  3 Sep 2026 06:56:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 03 Sep 2026 06:56:25 -0400
X-ME-Sender: <xms:UVKZamIPGdTSwMXtzhWS2XNv8V_X9rqvclDcQIAPmBw85vqcUJt6Dg>
    <xme:UVKZaluFRNc4_GnzSaVHhjuuJvG0gyG16pboe-5XeHfbXKV9u-P0pIYp5YmLVG0Eb
    Khmr8tAx3g8GmCiP_OvbFFyZCY-AZr-LAsQAPSKCTUEspI9Qb1QhCcl>
X-ME-Received: <xmr:UVKZao-g67Pcb9Wn8J8SHlaa4cGtpwQki57Zw4nXVwEpoTglk44pC0cSXJM>
X-ME-Proxy-Cause: dmFkZTE2vw9rBDB6ZhLsQ6+CrQI8s2qKm/A60heJ0L01+aqdfpUavd9W3Flk9ygWT+QFwp
    mE2BJJQAcCNCN2yQEO/QNo8KqvPVSjQoVwmD4wh4iPm8SCtGX51Fbl1bfGk9nIvo94LLoS
    DbPAK6SQ3yRsfQfYBB0+cE/W+NgrQM5sNhf3OIrcEjQyPKYN4EtdPVRvdBYBHV7r+8O3ty
    GFcSK+Bkq8lHnOAo1KINJ21TichzO92EIRCe84TVoF8p9/h9hPQ2maXMkXaApGSTamLSVj
    6eIZPnbWRfl3kYuq/qf8QcVCAY+VEQWf25EY6cu9oyTGFOCPLa37QrM2nNlI3l5ueXcTos
    5TCMAY7rReahwfAH1qHbxHW7xpWJcNLmCn+3rqMoJAeCGR5jwVyFsp0Oz5VmGvoYHGvyb+
    kJGgIziu8a+oKvOpjtc21O6XEF/aL2I7Zn6LHE/9vKjTtecpD8laqjfIf0jHF1MVlf5nO6
    8i49U7BEnv56JRBs7gao47i+61WcgJ4fymJ9+5VgMEQaQWQemyZCGatLnbOaRiIh9o4HfS
    EYAz9ALEXEOjrmODtSpJrHE37mSwVjcoCse/txxs/Z0VrrJrf19mMM8rpqzsvnkoFTQkgd
    pssiaV6OsxXcD4Ho/PWwP8pkfJmG//FmEK190CuZAcxVorlErU5Vy73zeKLA
X-ME-Proxy: <xmx:UVKZamB3Y_uWvPz_oiuNVGzSsWaY4aI4n_mmLyKSmcVOHxuYkoxYww>
    <xmx:UlKZat4klBgTOvEbFB_Et7ymvuHEd4t-Mu3omx7quS7XrgX2A63ftA>
    <xmx:UlKZaodyHZawt2FctaHJVhVeW6ErTzyJ51ZmVy6iw8uvhItT4odFzw>
    <xmx:UlKZat8eeJ2VADripRpoJZNPmFmfApz2o4p7BFblWIAv7XpTx3ssJw>
    <xmx:UlKZavGKRHYccIDnxaZpJU5lAykHr1junb0145CTbKA9TveQZtq7K8yc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 06:56:16 -0400 (EDT)
Date: Thu, 3 Sep 2026 11:56:15 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, 	Binbin Wu <binbin.wu@linux.intel.com>,
 Christian Brauner <brauner@kernel.org>, 	Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>,
 	Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@kernel.org>, 	JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 	Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 	Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 	Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
 Minchan Kim <minchan@kernel.org>, 	Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 	Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, 	Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/25] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
Message-ID: <aplHq9bvNdyPGEw-@thinkstation>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <16b39f43-d91e-7b23-900e-90cec13837ff@google.com>
 <apAllneItXmyjRPo@thinkstation>
 <7b30ca86-dca6-83b7-a632-180e35ed2a0c@google.com>
 <apThx6sWOQ-aZcN7@thinkstation>
 <821cced3-dcc8-6c80-a92c-c568c2639e5a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <821cced3-dcc8-6c80-a92c-c568c2639e5a@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 21A5E40004
X-Stat-Signature: c8k4aaf36bci47d8za6zpac9bb1pgd1a
X-HE-Tag: 1788432989-744481
X-HE-Meta: U2FsdGVkX1/QvyAFySwmsYG15uglFro9gjGSP3+8Yk18DAQyJ5eMubyMF2k0RANmgA1QYNyaVHq+vKOTb9KdXYIA0Ziq5kvAy+8jECTmcyN5pBD7cohz5zIS6oIcN2G3dC9zr72s55Myedsn9bQ8gAYjuvogMqWcbRUEnguoO4vcKoEwWMangd89uPdU26Cy2ST7ImO4wjQ3uiv9z/g0cGnGTjLGT/Hs/nERpiewRwYKok/kCS1oGG5ySrWZauFGrhJlcTZ74pNqIz0exRUo4KUEMevsuNaqt1J2fhgzril8dmwN4z/jDjQcUcJ5O0fBO93GiJIs2Y/B1W57kbkcr/+OboY/jVwrcO+AoWxDklvSG7SZUrYy6y46xeiJiwlpby3MwJztHchsdS8/STGkRKhaRmIudL90CwuT1jEflz0g91oNzpiHD4e0PQIS6Oq0cRyTnkdPsl6X8zM1lpU5kRtpFqyernjlKy+ehtAobj+zduDvrCin/SOXimzqiPFT0a3/QH1xt6GIk73h6jQBxpiB6eQU9/PF0A+ZixZ4slJAVx0ofI9ZIMriIlIeXxT+6m+rLukO0XZWOV0ER0a5vBpm99KQLrGr7MSjw9TQXme5+pvOfuDoBVeVAgP0gK9M5F5LaegD6NIRWf+cjsOBHv0euDeUj47xA/5my9h8zY4VahaUn4bEYput/OiO4i/Dij3KYZTNustkEfYGxL0dgw3CioWQC3qKrzKAZIMt2v5jTQXadPC37wC3hL4g+idWMHNeM1US7dMG+367Ot2FfXb798bFuubksXeUrC095KsCblw3bTl/VhsdSrX72lrw9z9pjsfKBq74xswROQz1dEdE4wFRUfEjZmKungJv5QS0rA8Zwt+s2pJ6bHeZK4uc2nLgKWvWJADUoRVRJjowknLUf7V4G7KCtAoVYNE7OArwh5A3tZSJXKgZAbnruZx2AhoDIhVdNT00pKOKdUU
 AAHGjf+J
 VmnK93Hm6roQHN53QNexvEybDxs6juyzWg1bIWvWeWc/fTc9rFeZ6D01NV5GFWUCd/VBp4MUCib4T3DU0e7XI99eTD1hV0a6jlX+hRTrwc31EQL6BqxWfguX2/i2tyCgjh1rhKnypE34U6txyOar7ts1Zo2ENhTwFIh60H8C3cG9n3QxeWlcV/nUkLGhnilyddckIcPSDDvM6F4I5WwcHhbfrEHjW6nNPg3Yy4ZVM83HPBucNcQg7R/g4PJPxv17bL/8fO0aZICyWfpNPj1p2W6r2WMqmX660raTzySz2sRY80czl9BPGH493DcLAk67xGUn49vr9ewWWg2Cr5ztuFJOhKsiOYJy2Pe2cBJe12954Z3bAqw3qt6tvvH/h7ofbwJC+ZxdNqMoC5X9bpXj4Z6wZSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 10:41:56PM -0700, Hugh Dickins wrote:
> On Mon, 31 Aug 2026, Kiryl Shutsemau wrote:
> > On Fri, Aug 28, 2026 at 01:40:51AM -0700, Hugh Dickins wrote:
> > > Do you have a head for smp_mb__ barriers? I'm more anxious that
> > > I might be missing one or two of those.
> > 
> > I think the release side of PG_lru is missing.
> > 
> > You effectively turn PG_lru into a lock over folio->lru.next.
> > 
> > The acquire side works: test_and_clear_bit() has a return value, so it
> > is fully ordered.
> > 
> > But there's a problem with release. set_bit() is unordered. You
> > correctly placed a fence in __folio_add_lru(), but every other
> > folio_set_lru() is problematic.
> > 
> > For instance:
> > 
> > 	CPU0 				CPU1
> > folio_batch_move_lru()		folio_batch_move_lru()
> >   lru_add_del_folio()
> >     lru.next = LIST_POISON1
> >   lruvec lock
> >     list_add()
> >   /* no barrier */
> >   set_bit(PG_lru)
> > 				  folio_try_get() == true
> > 				  folio_test_clear_lru() == true
> > 				  lru_next == stale BATCHED ???
> >   lruvec unlock
> > 
> > If CPU1 sees a stale BATCHED, lru_add_del_folio() returns true without
> > doing the list_del() or the NR_LRU_BASE accounting, and CPU1 then goes
> > on to lruvec_add_folio() a folio that is already on a list.
> > 
> > I think we need to have a helper that would set PG_lru and enforce
> > release semantics.
> 
> Thank you very much for this, Kiryl: it helps me considerably.
> But I have to cool myself down close to absolute zero to think
> about these things, and can only manage that occasionally.
> 
> I've nothing useful to say yet. I believe I understand you, and in
> particular your last sentence, which I take as an observation that
> clear_bit_unlock() is well-established, but what we want is
> set_bit_unlock(), perhaps better named set_bit_release().
> 
> Of course I'm not competent to add that to N architectures, most of
> them unfamiliar to me.  So I'm looking for a reasonable compromise,
> to minimize the additional overhead needed for correctness here,
> just using what we have already have (test_and_set, smp_mb__).

It would not be N architectures. This should be good enough:

/* include/asm-generic/bitops/lock.h */
#ifndef arch_set_bit_release
static __always_inline void
arch_set_bit_release(unsigned int nr, volatile unsigned long *p)
{
	p += BIT_WORD(nr);
	raw_atomic_long_fetch_or_release(BIT_MASK(nr), (atomic_long_t *)p);
}
#endif

/* include/asm-generic/bitops/instrumented-lock.h */
static inline void set_bit_release(long nr, volatile unsigned long *addr)
{
	kcsan_release();
	instrument_atomic_write(addr + BIT_WORD(nr), sizeof(long));
	arch_set_bit_release(nr, addr);
}

/* arch/x86/include/asm/bitops.h -- mirrors arch_clear_bit_unlock() */
static __always_inline void
arch_set_bit_release(long nr, volatile unsigned long *addr)
{
	barrier();	/* LOCK prefix is already a full barrier */
	arch_set_bit(nr, addr);
}
#define arch_set_bit_release arch_set_bit_release

I don't know if we want to make it _unlock() to match
clear_bit_unlock(). Naming is hard.

x86 does need an override, since it has no locked OR that returns the old
value -- arch_atomic64_fetch_or() is a cmpxchg loop.

arm64 is happy with the generic version.

ppc and riscv need a definition of their own only because they do not
include asm-generic/bitops/lock.h, so the #ifndef above never reaches
them. ppc can take the generic body. and riscv is a one-liner right next
to its existing arch_clear_bit_unlock().

This set_bit_release() gets better results than alternatives:

                set_bit_release()  smp_mb__ + set_bit()   test_and_set_bit()
x86             lock orb           lock orb               lock btsq
arm64 LSE       ldsetl             dmb ish + stset        ldsetal
arm64 LL/SC     ldxr/stlxr         dmb ish + ldxr/stxr    ldxr/stlxr + dmb ish
ppc             lwsync + loop      sync + loop            sync + loop + sync
riscv           amoor.d.rl         fence rw,rw + amoor.d  amoor.d.aqrl

I can prepare a proper patches with what I listed above, if you want, so
you can prepend to your series.

If you don't want to go there for the initial series,
smp_mb__before_atomic() plus folio_set_lru() should be good enough:

static __always_inline bool folio_test_clear_lru_acquire(struct folio *folio)
{
	return folio_test_clear_lru(folio);
}

static __always_inline void folio_set_lru_release(struct folio *folio)
{
	smp_mb__before_atomic();
	folio_set_lru(folio);
}

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

