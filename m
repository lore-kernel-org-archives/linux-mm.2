Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC5C606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OLr7ASNA
Received: by kanga.kvack.org (Postfix)
	id D45096B0187; Tue, 20 Oct 2026 18:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C8C6B0188; Tue, 20 Oct 2026 18:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31B16B018A; Tue, 20 Oct 2026 18:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 958AD6B0187
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:03:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20B91A01D7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:37 +0000 (UTC)
X-FDA: 85344382074.09.E4C94D7
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 481F01C000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OLr7ASNA;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dby3oqMku+pe08nNb3SVcKfzQbLv8VO0Jweo3C76TU=;
	b=HosRvIfTDoqyDumaPSR7ngZSpFhNmtuxODinaNXwKkHtA/n7lMB25ki/oiwDoIclW4lF07
	ygYEszqu8EXQJsbvJYiIPq/kM4Kp7CcSymO88ufN1DHHCrJl5KbaDDcnsn4yNCJWPLWs71
	ZNP1miKow7NPd1qtFG/3cEktHlhoFAI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533815;
	b=loc/rKxFrlSsyoes40vzQeIM1tkqYz3rxvg0Q5USj9qU6khO4tM2Ty6Po+SuEdySaTvVHj
	TW/ajqQ2sKFL67ik8reTJG1+bFAnlHZtgNjoBOYeT3Sby3T5GcmzSM3Nq9LivWlXduFy0z
	RYhOp7axNMUxgkxDDEpQWR5a2vIO1s0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OLr7ASNA;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b125371596so8139647b3.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792533814; x=1793138614; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+dby3oqMku+pe08nNb3SVcKfzQbLv8VO0Jweo3C76TU=;
        b=OLr7ASNA+67qT+uYnQ9j/yUEmhhYSTw5c4eeEUv+HqU1v4t804Rlt5eHY8ezMp8r/p
         M11CrJDnKwrQIhMVqQrA3NcQKqT0SoAV8eBdkPo5GwE+85fN/OiuNt220AHSz2C8Hqeb
         +GIkwnhkbft3vsxtXCO63OwGjPpZ2V6jpITqEej81qh6QOOKGkqV3VavdLpJB/AX8BBP
         b7ZWSzvoaWoJH6G2XAqT2m0VfPnWZ3HEu7VsRGppOoPfcHCXozTs9Oh+QMBmt2DsQtiR
         68ckL+i0RmcsDK7CAOWFlC+uZiXUv1BN/qfprWWz4sObIy9F2msW8/bgBdowEjVIsJlm
         iOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533814; x=1793138614;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+dby3oqMku+pe08nNb3SVcKfzQbLv8VO0Jweo3C76TU=;
        b=XKZsB0hWvXGQBP5sq1RYH8aXb8LgVCgPFTKzCZmdqM+eVoxGY7doBdtL4zS/+mBACk
         pRNASyGWTWRDZxwrWzSt6ORgtwHolxyWSgRigbJjwLCPytRrukz72JPsKcruxvtMJsPT
         CFJAik3BClvg8f+sIdDHTjiaSSiAFsYdoCycaxYYDuNCW8iPVuoN7pohoY0PAifZ+fqa
         Wm8YaRwMv2gqvybwHTAgiBucVomD7ZeKZ+KCsn7itz9s/e7u11ALJ4L1NopsOlkCqcPp
         bZjw0ks5AUnTo2SBwr1eNaNa5ToEfk9nOWotUbkczxghNiKVxhRvndkjJTdgUxx+txsp
         ik3Q==
X-Forwarded-Encrypted: i=1; AKwUvBxmj/e86j9NSw+xB6ybFXyIep5R6nbHd+a/Cq27KCkVTiHkuAuVHdjD8sWhFzUFRLX+QoL6LFRRvQ==@kvack.org
X-Gm-Message-State: AFq9FYLy63UlOZ8vZkN8OZ/Qwtkz3d0wb5OLGR43m0fq7LX8EUJugMUA
	TP8zqd5MRcA1uJ2wU4p7ZcJuBG0F6QpzYxFkgjozUw7JX8FnG2eGBJvi
X-Gm-Gg: AYBFou1IFCqMKdcjKHPG487u5dR1uA+6Iky/moT2pfHTlq7LR1tVi2Lfh1crCbkgpIL
	zj0xmr4CP0xPGKZ7kwz9MuKydvEAvR3DbZ8D/HpaGaOi5GKDHK/xYeOtZw8EivwhU0nehJUkl0U
	4fWcnmuEGn/wtYSK+3mJQm9gAC2inWX64+sZIfjiVQ+m97X8efhiVrTm557UlPDRPAwL22vC9yE
	k33uJm8lVw02vDpw311D14DR0nXZ0J6Nw+kUb54t9hJKukjaBl9HTLR+UdHsx0ypsm3FEPy7vBZ
	VXROsmqH7w4U8eK6UVlWf0VyC14Sowzb2FOmz1JqFksQL1SBYKtBhl0hnK2VWcMRVHRSqW0DB/E
	UVU+rC3kZy8mrQe9xvJJL4WXNur0RXg8MVkp+zB0nRI94ua79Ux2IosJy5tPD79prEIZBNA5DS/
	SrZjlie2a2kHHyxUasaeQxlre6jZUg/a5dJqQHOo/7rF58+6B3irG0VUOVOrXmewpZd+oRoXT/7
	xa52Lq9cURojx+Gp+fCEMh055A+kA==
X-Received: by 2002:a05:690c:a:b0:8b0:a30a:7f31 with SMTP id 00721157ae682-8b133dae495mr1678197b3.29.1792533814287;
        Tue, 20 Oct 2026 15:03:34 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300eb0ecsm3660387b3.26.2026.10.20.15.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 15:03:27 -0700
Message-ID: <20261020220331.2641416-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atfMngq7nyZpt4u-@linux.dev>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 481F01C000A
X-Stat-Signature: ojg4kcbjync779n9mbmzb7kgi3rpyhsc
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792533815-910137
X-HE-Meta: U2FsdGVkX1/omk7p2xz8GKCBq60dXAw0MjDu5Im188rzBnD1GJLiWUN3siVEGBJZ2SrLGCCj0HkOVfA7w4Gwqbder+RXCeH1BVsEy4BUDUUD1sCxgbz565uYBjzeK2ZbwDKQqrg/ms+Dicfc+AGY0ppSwHbteUJqG1zC+McXtCKQN0DpD6u0kkEKbqEoBADLWs068y/nCN5gXwPGsNW7at4E7UAvDQEvllvCApbdeWhSEocIkvsoF8sgu9cMOfwj6Ysmkl+qRPfwqCpXraXtwpxMIECXhLQRmqnNR69afoKVeS68sreKo1AnXot/DNrDCCaEXBjcam1dCh0FnhW/Udo0yZwiL6jvWoHYHk1DjTmeqkFIF5vUcnuf+VZ1uB5yW6puQQ+YIkUuS9kSxqxXfnhzUy4BPN/cCDdx6EZoLhn7ddHlQbzeYVT1XQVNKDUNWWNTWsbtDyXK5OpQz/lizXnerg7TFmT2yjRy+4Lga40mkSINkS0er2bW/fnsaIuYgrAB/StyL0pur7J3T/tPxGaaJwgcnw5mAyiqv67hDEK74LkK/DmdzL+q/wIA2RLyEn3BcTAtRI51ttm5zm9fmcmu9P1brCfa4/n2KldQNQdShVxOs/YhHOYSTGgS6CdiAWS4MxHRmHthucZRB6Oe8RDpHaBwoBH8xGjw3y8ywAmAwpwvHamlPuTbzOVk6mLsayDX5eoMtbpJuDo9LaBl9ZUuIRbz7QIg8FMZcbyygA0yu9MkJ1vpRSTIrVZxIHYeaP2BxamfBSpvupLWZiX0mFbi8UaIN97FeM70xyGSVTiqDvvtIBVFt2PsDOfJHkldWUNlVzfBlGrHr2t/DSH6mJUtAgAgK3TBlWisyIf2EHgRbpICRH5TuQDKQnaMYaCULk7n7sATN9XOYdnIlNboDMq9FFxRhS6w2yCt0RODzVmhZxhkhISaxcXvij/nx+7vhowpkuxfpU+MgRAoRyD
 mUM4kutC
 yoZO4TwIIe0w6KoY5BshsU60iVMT/wMoAfV7vMl2zSLTwTnLB3LuZjnsnI1tq8hKlhpIttku7EPDcqoZSqubVzofa1D5CmRJdqmLiW7qWFpa+FXPTaLJwma45ydw3a1gY2TvYPa1qARVUgcfH/A2ji5LM2aK45VBu12Nxy0/0QzRvlqwPYC3W2n6PrT4BO2lXTY91kAIaHjzQhCXWwqulkCwv+y9V9m/tNA7y2OD+cZJLhyAmANPekN/0zcByMTHPgYktLDeqq7iKisMu2imPe5nSODbYI0NoNoaWAGAE9XlAK5N0mtdiKzpdprcDrHeypqY2jteJH3RfBAwFbzKaVioHUMJb7EKmCyI9SSOJ0bMCh/f/Tc6K0Gw5N5s1AwyNB0fwqAfSbspKz97FwDWUOdbY6kCBTz+a6GjMBoVuS7wEbO7oelPZXAE49tdx/3JKL3gvLPpwCBRlYpHVpDz3PbqgqMLkMnWAkyrWX7sfpPr0/oFHv+ICVDY6NA9eqLYQo+r32AFHUDAGmXSJdzpWmxBWPXL/wfpKbfbU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 14:21:22 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Oct 20, 2026 at 12:35:31PM -0700, Joshua Hahn wrote:
> > On Tue, 20 Oct 2026 12:03:38 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> 
> [...]
> 
> > > 
> > > So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
> > > is set, so you can't have it concurrent with drain_all_stock since it
> > > will skip that stock. But refill_stock also calls drain_stock when
> > > it evicts the slot but the flag isn't set, so is_memcg_drain_needed
> > > can read it at the same time.
> > > 
> > > What do you think I should do? I think reordering makes the intent more
> > > obvious and maybe it's just me but I did find it a bit misleading at
> > > first that we were dropping the reference and then publishing. 
> > 
> > Oh and just for clarification, my page_counter_stock series actually
> > gets rid of this codepath and switches the order when moving it anyways.
> 
> Yes but this patch has fixes and might get backported, so we need to be use it
> is fixing an issue which is real.
> Let's try to reason how the race can happen between is_memcg_drain_needed and
> drain_stock:
> 
> CPU 1						CPU 2
> 
> drain_stock
>   WRITE_ONCE(stock->nr_pages[i], 0);		is_memcg_drain_needed
>   css_put(&old->css);
>   /* assume full grace period */
>   						  rcu_read_lock()
>   						  memcg = READ_ONCE(stock->cached[i]);
>   						  if(READ_ONCE(stock->nr_pages[i])
>   							mem_cgroup_is_descendant(memcg);
> 
>   WRITE_ONCE(stock->cached[i], NULL);
> 
> 
> Do you think there is possible race condition in above? I couldn't see.
> 
> However I ran this through AI and it has convinced me that on PREEMPT_RT, this
> is indeed racy access.

Wow, thank you for going through and doing an analysis!

> AI reasoning:
> -------------
> 
> How it breaks on PREEMPT_RT
> 
> On RT, local_trylock() takes a per-CPU spinlock_t (an rtmutex). That is
> rcu_read_lock() plus migrate_disable(), but the task can still be preempted
> inside it.
> 
> 1. CPU A, refill_stock(X): there is no free slot, so it calls drain_stock(i) on
>    old. It sets nr_pages[i] = 0, then css_put(old) drops the last reference and
>    queues the release work on CPU A.
> 2. The refill task is preempted (by a tick or a threaded IRQ) before it clears
>    cached[i]. CPU A's kworker runs css_release_work_fn(), which calls call_rcu(),
>    and grace period G starts. G will wait for the refill task, because that task is
>    inside an RCU reader.
> 3. CPU B, drain_all_stock() → is_memcg_drain_needed(): B has already passed a
>    quiescent state for G. It enters rcu_read_lock() and loads cached[i] == old. G
>    does not wait for this reader, because it started after G did.
> 4. B is preempted right after that load (RT readers can be preempted).
> 5. A resumes. It clears cached[i], puts X in slot i with a non-zero nr_pages[i],
>    and unlocks. G ends, and old is freed.
> 6. B resumes. It reads X's non-zero count and calls
>    mem_cgroup_is_descendant(old, root). That reads old->css.cgroup from freed
>    memory.

Thanks for taking a look. I think this is the race condition that Sashiko
brought up in the original series that I had.

I will go ahead and send a v2 with a new commit message that explains
this PREEMPT_RT race condition so that it is more obvious where it can
actually race in a kernel. Thanks!

Joshua

