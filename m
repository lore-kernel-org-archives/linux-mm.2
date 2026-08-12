Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 294E6C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 04:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77406B0088; Wed, 12 Aug 2026 00:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26776B008A; Wed, 12 Aug 2026 00:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17036B0092; Wed, 12 Aug 2026 00:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83DD56B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:33:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECD271402EC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:33:56 +0000 (UTC)
X-FDA: 85091349672.30.9C0469A
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1717A40004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:33:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XWd3qbwF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786509235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy1zI1GXyroGfJFfqMluytO0IUsUPNG66YqCeb7UD1Y=;
	b=2IQj9PtrK0/bjf2wyytu9wB7MWF5kZMfaThQ5o4VlM9UH5IiGyM7H6hR72M+v0Yqc/7Flm
	7VOQpqfra9HiDForFY90c88yuYxiV0iQrvQ38HQlUXBnEmAzngZ5Rxy+nwt0uGkf1yxghS
	7eimkpnUVKzGxOziYkZz6tkuc0n3NVA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XWd3qbwF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786509235;
	b=mbTdiqukXv1GdaoEx0j5IrsR/aJYShyQ6LogF36QF7pyOOXEyWAvN8Ha+MOugNBffp+bmi
	xncqyvsHPgrNhh8TWQpT/fYGj2MIlpzgPce7on+5pPhOssf9L8oHlIukgRyP1goiO7HGL9
	hoIDfgyeetT/GiMOUn+Tv2h0Zn7W2gM=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15b1da6b82so53273666b.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786509233; cv=none;
        d=google.com; s=arc-20260327;
        b=nVLeQG4mfNAX54DQqF2VkIQKpb4LGB0OuZSRpZYRxvWVQ7QAQwRa7Squi28/5Hvsao
         XSceMegoEkKLigpnnDbQvqbXx9UTAxOAvetXqTn7wrE62KdgrLApbpHYJ7SEjDqfsFOv
         4I2oSU4E92d/fVafclFBzZo0mJAAXE4KvQ8MeI1GqU5ONuotzCT5l4WJZHxLbdxuXPd+
         5QDX/aGRUMzLTY48LQSq2EoL2hQTEH/QG2iNzty1Q+xupsvlHqAgxBwwNu2y5jVXtCAS
         BxZGyU2neuV9FwjsUFr2j1WQuYTcEdRVRL/hySEWU2Qi9Ywnqee85gIkyLZv5ZWQCgSu
         1S4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gy1zI1GXyroGfJFfqMluytO0IUsUPNG66YqCeb7UD1Y=;
        fh=eBvjfVxDFI93yOgWjA7cOpso+ZB77BHpD9tRb1Yest4=;
        b=ntMSL/i2E+aE3uJApHE0CzZCng6EHPenJx+WMIPcJs4h2lONGMFGOSEsGPVPBpUivB
         DmYIrtElXiV0QrJjfHhUOWaTvrZAQchFRH9Qn+yPGF8Sn8a+vF62ENVxoziD+opsnijb
         mAZ4CTiaUCbMdWk4QDkg/Z3D93Iye+ck8/s954LTWReotslX4CGgoxUIKMAi+gTaOHat
         +C9uFjeG8bsZoSHIk8kEBVTZms600915Haswp+wVwk1QyTbTbO0Vy27VdVfUSNOn7RMV
         4NuuEuCu8lx3V61Kdo0/DMlfhi71MdS2V+OTKkobj1VBAXOdzq1DPwxwiU6Mlu6/26ZF
         spEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786509233; x=1787114033; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gy1zI1GXyroGfJFfqMluytO0IUsUPNG66YqCeb7UD1Y=;
        b=XWd3qbwFUuxp1ki4F5s//MfFFkigS++7ayU93ZCnLprAOWdcfG0HOMEy4DeCpyTUoz
         luYAs2l5YU7cfxPtlnrxO0xHQ0/i6TlnvilsepjU+WayLj+MvmDO3HuZPgWCV9BrWG2e
         V1sAad9lhJ32j994C5itOtpEK+0k6iur9Dbgu2AWbRepZb7NwkEYB1PvHx+Mcp/xloTk
         RAP2JyO/P4Go+BWWwDLaXPYcMwCeG93UuUZauqQytCdWaOIF3ZAOUzC8M7DyvI6mdsg0
         1yLVuNtrSpdgzvUWJ//YT10bZ+gu2wbzHx3fn3duXG8bpQgZV4ZggN0gAW/1O//n0N7e
         iJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786509233; x=1787114033;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gy1zI1GXyroGfJFfqMluytO0IUsUPNG66YqCeb7UD1Y=;
        b=WuBYiUTKc3juDNrT8JaZ9j5gc4WFHxqWz9ujf9Mr6RB9gN2KAW+xKSwDQJtrhKHK+d
         Wps5bN4dS9QyO74nJVsnePAcoq2Od+KBduXiJC7yDkVoUOK3s92eqgE9Q4a0xXK+zoDb
         4tVF+1mQSZdpswdgjwuGgI6fN0IIoX1fI8nXr7fJDmeo7G4HgQsBThJSkxr+IpY30pIM
         zrVF8Ax6/jPuzjpFdSk4ivVByPTKHnY3ctkTKowO1XvpIbdKjreQ/RpONrBSSzndxHAw
         WnouUpNKQFZT+1iI6xEw4tkIA8ceCpytsbKcHP9PklIkpbSTRER3jHpmpnQeWAScvDJw
         achg==
X-Gm-Message-State: AOJu0YwVT1RV4yoVTIU6XQIwsx1ZM3s4UfYf8J+INg+TuEJYrTq7uCE8
	LV0xkhaGDsMhEI4EYxlSrr/FHr6B1OAyTd2G0IqlnMq2HA6Y62bXusXBn+mFihkbHHx1MCTDFrC
	I1qjG2RyPXoeicQ1j7U54E9/zYFnK+JQ=
X-Gm-Gg: AR+sD12jD2T2+jgy5y2pwKTYtlB0vllOatL2rhuBW6tMy7XTm3OSJoKxSVm0dWJ8+Kv
	50BF5YwuuP0D+Tlx53Csx5hijRjmZjpY2lrd8GcWzUsLcPS3QtFJ1xv7rdIB8DM3aiQYsG5BvNA
	Lq1+g5NxExWeqrEl0QjlCUXZ6KtfQG9pBI1q1oYOQ00J3ld0Rqr3yT2kirTwA+ijPJ9RXtB1wYc
	ZkfLOl/nucGiSHZFtDwOYBSGZ6f/RHbq0R8JVQtGzH39cnoFXanK245Kci6PQ2OuTHsBBgrhZnM
	yFtw7bPBkhXJNbsi+2HP1QOAEKgfNNd1sm9wlW2nRAPjr58uNES53IFjOZ57S7FAUB56YJXzEdi
	5F29SjoSxzYyr
X-Received: by 2002:a17:907:1c0f:b0:c1f:e9d9:64d4 with SMTP id
 a640c23a62f3a-c20f2eadd70mr102822066b.11.1786509233434; Tue, 11 Aug 2026
 21:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com>
In-Reply-To: <20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 12 Aug 2026 12:33:16 +0800
X-Gm-Features: AUfX_my9hsGTS003zWy5nQRyHmMtI6GZWhD6COMTnNNqrfcd37GSx6vhXbVAVVQ
Message-ID: <CAMgjq7CKvvcJLqc2Chi+shiTSUA1aAdyauXGViMGNcVixPjRuQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix and remove redundant unevictable folio handling
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, 
	Suleiman Souhlal <suleiman@google.com>, 
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Yu Zhao <yuzhao@google.com>, 
	Steven Barrett <steven@liquorix.net>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1717A40004
X-Stat-Signature: adxq73z6bssccbq6wkgmr9u6wbpjs7ea
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786509234-703136
X-HE-Meta: U2FsdGVkX18tPMMdE4SX5KuXdEXHqNRtw8q2/vjskBlNHhwoCQ4sweNVSeC/aRfvBPM9hNjBNv4xn2/uJSTJ2WlIKnNcs1FGT9DDk0GLXAHYhr/Qe+t3PxNNuCYtM3LHKBAqbIkSHaCydy+mo3Ubh0kzI1UGig03nxVtSKOpN22oNH6/k3ZJv4OIKXmeel8zT1Y1LnQW4nE1aFkMO67vCPP24vE8v9pQA7/eYVJtigfXyt7c+ZR2qc1l3gRI1LIZl1v7aA9Uar6Vm4BCAuPi0A5axbJAtRUiSgXuOTFlojsuuU2fX6IqfsAMq+MTX610OVK9wUD8TQ7qXg5pljHwcFOh9D9gMz85MWO/mX6ZEIL8iQ8LP3ZeAY5LoaLRXPBILPJRFiebmjSd+HChzj+uAS1Wlhu2iX0slJ9cLYUWiUa67qgDzuZYkXnGsG2xePzqGZDnWEfZbXvMhnz0A/zBW8OM1HUoN3Yf4aRujh3v7bm4TblcANNuDOFQUaXhV071lPhUiSyj40hNe2F28ZIL0TrKqI84/J38ZmGsdfA0qNQiMhFQTeiGAVbLfP8isOMjuTfdRNfzQ1GoY75pwSetKzM1AK0S2kMcBuL1bMTXS+izWDBXQhrUhql6SmqE2P4ev+MCyUotShU+uY1gFtu9CkJEW7FyNcP115i9Bj7BjSrXAF2t/Nc1VQuFL5gzWCmKu3gwKd6HOyqNoHzUoqGnm0AWnyGLRgspyL3DwdbcUgVtbZlyJeiEuM4v0SS+DDAkQSYr/RSk9YVx+KLfP3bwuETjyEg6xLe5RUvuXXrgL3B+OgO/4DZqVgvgXbdKzFApIL23FaR5UvKNMM3zgh+kozdZslSYPXapPGMD7kRf2W3+jrU+l4tJet7YhDT1d+hVXQh1DBD/PADiwmpFx291QrIeKjrmhvJZhyvfcJW2aLMUtkR/VSx9xrnIR58t+8xpPjnSD4EJ2MEBMidfmbw
 uc9o9XTv
 Lu2dT4+T36hIdCvHNHZAUvp6OhutIZehCZdavRugmbtqxrXIfLBJ4YJHiUXoejNJWw8Bq6gybXfejvzW4GRaagG/v9y+TSSsFhWNqWd5dD0qahW+8rSqmvuIr521iQC3MPjOmSWQ+5XWyE6F/MT3syjBbbGR6lW8P3Sj97H6vOnhxOvhnBzOnPm/1x7N8qAm5o/eCWaj+xIDXXvvQHKPC/EBOc3FVt0ok9SL8jZH+9n6Bt3zpG44ChV9JgU5Zg7vAwXYnyL9taKnqhkSrxx154V89+4xtviax5GkyNgmtFx30LApR4kbf/BOmesUW70cUylxCY+PIjL2b1woazKujtQamb4lPxykkfFzVY4IYLiNk47AxI7BqA5PvPqLZmgshE0AJyY+zVCyEY1BGWvgdyyrpbCHA+7cQ8pOzlFykrIGJr+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko reported this (TLDR: mostly a false positive, but I will send
a V2 to make things a bit cleaner):

--- Patch [1]: [PATCH] mm/mglru: fix and remove redundant unevictable
folio handling ---
commit 4d1ddce0f76b4c4700b6f963424566b2fce82fd9
Author: Kairui Song <kasong@tencent.com>

mm/mglru: fix and remove redundant unevictable folio handling

This commit removes the !folio_evictable(folio) shortcut in sort_folio()
to rely on the generic LRU culling path instead. The goal is to ensure
unevictable folios are handled by isolate_folio() and shrink_folio_list()
with correctly initialized mlock counts.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3194da7dcc795..eca5ff64238dd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4660,16 +4659,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>
>   VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
>
> - /* unevictable */
> - if (!folio_evictable(folio)) {
> - success = lru_gen_del_folio(lruvec, folio, true);
> - VM_WARN_ON_ONCE_FOLIO(!success, folio);
> - folio_set_unevictable(folio);
> - lruvec_add_folio(lruvec, folio);
> - __count_vm_events(UNEVICTABLE_PGCULLED, delta);
> - return true;
> - }
> -
>   /* promoted */
>   if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
>   list_move(&folio->lru, &lrugen->folios[gen][type][zone]);

With the early !folio_evictable() check removed, how does this path handle
actively accessed unevictable folios?

If a folio is added to MGLRU, then the mapping is later marked unevictable
(for example, via shmctl passing SHM_LOCK), and the folio is actively
accessed by userspace, it will accumulate elevated MGLRU references.

When sort_folio() runs, wouldn't it hit this promoted branch (or the
subsequent protected branch) and return true?

sort_folio() {
...
/* promoted */
if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
return true;
}

/* protected */
if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
gen = folio_inc_gen(lruvec, folio);
...
return true;
}
...
}

If sort_folio() returns true here, the folio is skipped for isolation.
It never reaches isolate_folio() or shrink_folio_list(), which means the
deferred !folio_evictable() check is never evaluated.

Could this cause actively accessed unevictable folios to circulate
indefinitely in the multi-gen LRU lists, artificially inflating the
active generations, instead of being culled once and for all?


========

The answer is we are fine, or at least I don't think that worth a
standalone optimization.

We have two kinds of unevictable folios here:

1. mlock(): mlock_folio() sets PG_mlocked immediately but defers the
list move to the per-CPU mlock folio batch (31/CPU), drained on
batch-full, by every lru_add_drain*(). These folios sit on a gen list
only briefly and are then moved off properly regardless of hotness.

2. SHM_LOCK / unevictable mapping: these do stay on the lists until
scanned. When their generation becomes the oldest, if they're not
worth protecting they're isolated and culled via the generic path. If
they are hot, they may be protected for a few extra passes, but this
protection decays, so it's not an indefinite circulation, and
correctness doesn't depend on when the cull happens.

But to avoid any potential issue or concern, I'll send an V2, let
sort_folio just return false for unevictable folios. I think this
change barely has any visible effect though, just to make it more
consistent with classical LRU which also unconditionally isolates
them.

