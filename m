Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28149107760D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D946B02EF; Wed, 18 Mar 2026 15:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE826B02F0; Wed, 18 Mar 2026 15:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD136B02F1; Wed, 18 Mar 2026 15:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B15E6B02EF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:25:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC6F6136246
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:25:36 +0000 (UTC)
X-FDA: 84560163072.22.C548FF4
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9EE6C40012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:25:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gdoGhLbw;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773861935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NducLCjpH3d8vRwvCq6m5Mw1JAEaZRFw3raao9vqHxw=;
	b=bOPwJVuLmPAAuiibh4rXm7U0JTloomKiIvdaLtt/DsOSZLfKck8QdHp4simj3HhdAwnQd+
	X03fzTAu9vFXMBcuRn5E+YGR65ZHKC1BKl706pCnwluXC1iH+YNjAEkIQviBJMl5L0mEYD
	LmfCicAkn4zWbNM/BZPu081mOsJ0h0Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gdoGhLbw;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773861935; a=rsa-sha256;
	cv=none;
	b=BKO93CAx4RJ8UmU/deoA19tSYwJ8mCiBuA9TCT5BkDCVfORYzlGQYqMOkitguLxZeiEPGj
	JOTDEVOHUsslpMawPOHec+GJsslXckWb7F/V32VLgEzTqRvADgBtefFCl/KTmbnLmGIz/w
	MPDiM1x/meT5DKN/cHoVsjb7fBt+5hs=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50697d6a69cso1209581cf.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773861933; x=1774466733; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NducLCjpH3d8vRwvCq6m5Mw1JAEaZRFw3raao9vqHxw=;
        b=gdoGhLbwzjXNwHZwhlNLo5sFnIORq/8AFKnrkhkDSm4lfhIWHuqCY+AuHx7+xHh+GF
         0OpZmj5GjVPZIT2zzd7+q5K0nlByP74/G+pUHedGuqWGE+tnUJCzEJQwMLWtGqrc6jXD
         9pZezDJoT2DkTzOUTkGJB7Lnxnh1rZ1DSb0Yvvxgg3DSllKaSyNRLs3d1vlQ8va6jADX
         ILwC8Ii89kIUyZl+vCtF5FK/ITuy0S2qwmY1qFgVqRe1Pq3ii5ZzWg5FjveItYvo6TjH
         9aPN5FrI/PovNJZseMFitf9inShg/I2yQlT3WRIlm+CsvtEcd0Bytb6PwLwB//L3JgWr
         NjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773861933; x=1774466733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NducLCjpH3d8vRwvCq6m5Mw1JAEaZRFw3raao9vqHxw=;
        b=WjYnRxU1pcJhGEdNPy9EARFMYRC6HEC9aCQFOHay/LyQUILL8d6jjYedAeta9j59v4
         j803wyGbA3fZxUq5rWR1aSjAZTXJNdc7aRNdLntj6prFJRyWSZOou9QyT3xxCrCiaP5l
         Bq/+7t2QAG7B/FFPC3mzx8l5AhCgiT7C4I+uJsFOPiAJtvWohoryzJebc+VLK8AOo2nE
         Be24MdRnNL1wnUpOmxcg6pO8TkhzIoN3O+1lRxXiAg8HAcejaj9907+4uS4FCIbhkGm+
         CtPZawscSMG9M/T5dJofFRG1KHhkfnUchEMC4LzUIiDmn9EsKQJF4i+Rn1XH5dmx23SE
         ggmg==
X-Forwarded-Encrypted: i=1; AJvYcCVW/wYP2Vd4ozc8fEViUNC/jZLPxNCb+XPClFpJdNJlk5d0zISdqK6/KgRqHTRjyY/PwHglfKdOnQ==@kvack.org
X-Gm-Message-State: AOJu0YwojDCXwvkcg54Kel2D7cM3E0sUQsSFgYHzyr8Md2+s32mbCo3v
	lSLEIeTFOKpKuqamW6AVXaoZiRdHaTD0R0e2EgNqJ77IUqjvvSR6I3C1sfurTSDSK8w=
X-Gm-Gg: ATEYQzyCEw5Iiget+2B0mi+o4OKXWdSrki2mX74RIsO/mqBsxJDiVOtjRNthupv9pnc
	ahOOZnML+j6O4ziMUnxVOvWctLr07VRcSbKGMexmduUBPXvpCovKVKp4R+9XDnnONCk6Y+J7XQR
	RHuZgHYJSLVAvpSZA3d0v0UMAu9c7c7K+59YTS/nRFZv+BsQvZIRGXvE7RH1t4U9rys8yNovnpW
	5wAyGe3yQnr92W1T5oUJ6o5UG/yIyPjFD1x485e71EIJp7TQWxxOaSzwVsiH6zQ0TTPIHL5HGaD
	Li7CZTrn8We4rANAIMHuCrDj4j6xUVvr/zjxjJVeGZuMYF9V21l6O+4uPVQFKUBjA2ogWboq5IS
	C1j3gUxpeLXls13YRKPOWaUqbifOW5s8hHqAFtNSP/z53iI3Q44LeQPaFH+zSYVJqlDrSS7xZ0v
	s/PpEekmfxM+/MsaVHWAEZfw==
X-Received: by 2002:a05:622a:589:b0:506:a075:b247 with SMTP id d75a77b69052e-50b14743959mr59908331cf.14.1773861933453;
        Wed, 18 Mar 2026 12:25:33 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9ce61bsm32260176d6.23.2026.03.18.12.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 12:25:32 -0700 (PDT)
Date: Wed, 18 Mar 2026 15:25:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot
 return NULL if !skip_empty
Message-ID: <abr8Kf38paSBh9H_@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-2-hannes@cmpxchg.org>
 <abrnEU-wHNkqGK2k@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abrnEU-wHNkqGK2k@linux.dev>
X-Stat-Signature: a6tgjjjm1a6dh1877i8k1wmhc57k7pao
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EE6C40012
X-HE-Tag: 1773861934-98165
X-HE-Meta: U2FsdGVkX19SfoSLTwrmXgokfC67bQmxtrR/UlJPTCSrZAZK8El60QIDmd8UzSpcsIh2HtnBiLcfIlOhCF4CowRzj9fuvU3B2WoBqb6dp3wDMiCoCzZyq6o/wiWdjRQgH0CKr+t015c7IdAu81zsZp5X6MOlVlEgUMkU9SDug9j6e55/g8onwXyeh/AVZv0Y62ty/aaGQtJ2nUJ+BMV19mdeGX8Yk+lKlmMtD1qI+sdgU8ay1wODA29eLi4uXGkrs/y9rtAIBXCLZH9D2Zvc4MutiY8iB/5jn9tdVFnJ7cue6bolVbeGFM+PMCgMSJ3Vga29d5l4HqDPmjthuLsh/rajNG+kbLsWbajmaEpG2V1OA/svmHl9ljIqQB5LkaPSxyubtxNSS59HIJenWffNcGJqkQusxD/ct2YkmThzwG577eoOh2Z3EUNcVxLf1nHR3m4AfCta14lNMLNoXkkBNkHSNkKdI/juc1KWtdwY+TX3l0+e7un2c5arfgG6fBrFBbfwJ9dUNfGN99yzs6oBjkx3TLWxlE1ODCihGbACydePVeruA/KBXrpEAHTYkiEHT7lW+sxR+eXBDTv2m//Qc3FFRokWsJ+ci2Epa0glMFn+NuDNkOClzMb2+AsA3iQIdSPbNOSSOdIOn2x2mMprY3Qtp6lwKS/AutRq+9X06u1WqT4DqOCzrMIAhSTGnzsun5JJs3wGNQswyyA3txCPliRxAbs8yJ8bOBLEWYUpY8OWbfPizti0C83USTAXoezDB5/13NciPoAH3N/PhNY2zfi6R/QwAX8lyK8iLzIqUTbitqazlBx5GuBgPFEoMQDWdAqDkdKLLGLuPd0yEWK2XbUIv42MLhNCAZR6mCjQ4Ae/env+9XRmj9mKgILECULNZJ5vl6kvCtGkVDBZPKoGGDR9X4fcewsdCCul0585MHl7n3vqQk/KzjV0ndmvj2MLVi1OmiNSOIIHErCe0Lk
 8ajZezqC
 afJsJ04+mI/HJUlR8YurbM5OcnFSR++iOp2W4+XdMUZR62YArIw8iYnGZObUDCVmlao5ybJEu0Aq0LyFeZA0FG+oNq0UqXub2mMxjrYaVjKWOuXOJdLtAU6jvqQmTjkZ7GHJFglJjWhgRkRXuUL9+qmgq//h8TGZXDi3fFwCSJJbz6esawzBWLZg6D4wCDuTdytDcoumw251hxVZXhrf95g60PCzcUNLswGfkk3ONPQMCwObH63olqcls392dSGvLWgZmap/JD3Whf4yuxeOxWaNmzzG0Fqd0cOr2TGsbgnWs3SEthhKlM6u6Ni+SC7v6fsvP0maTXAoOnT5VSVUVbNepDHCjBtygtuknNtVXArY3IrAbW8oWQAoOjVn0pE8b9KE/Z/qAtgXKPlWMj0+GibeYoVEbAcEwGEbsMuCDtJb0avga3scKco5yGt0jcx546EeGaY9Ow+F2siJB0hCMBgkeaOjjzIkEX71MEnzKWDzkLt16aCBgfuvYkL/Z7PZCXpoTm9FZO/3olXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 10:56:55AM -0700, Shakeel Butt wrote:
> On Thu, Mar 12, 2026 at 04:51:49PM -0400, Johannes Weiner wrote:
> > skip_empty is only for the shrinker to abort and skip a list that's
> > empty or whose cgroup is being deleted.
> > 
> > For list additions and deletions, the cgroup hierarchy is walked
> > upwards until a valid list_lru head is found, or it will fall back to
> > the node list. Acquiring the lock won't fail. Remove the NULL checks
> > in those callers.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> 
> What do you think about squashing the following into this patch?
> 
> From bd56ea4505f792e00079b1a8dd98cb6f7a5e7215 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Wed, 18 Mar 2026 10:43:53 -0700
> Subject: [PATCH] list_lru: cleanup
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks for taking a look!

There is some overlap and conflict between your delta and what later
patches in the series do.

AFAICS, the main thing left over would be: to have
__lock_list_lru_of_memcg() for the reclaimer (which does not walk the
parents during a cgroup deletion race) and lock_list_lru_of_memcg()
which does. Thereby eliminating the @skip_empty bool. The downside
would be to have another level in the lock function stack which is
duplicated for CONFIG_MEMCG and !CONFIG_MEMCG, and the !CONFIG_MEMCG
versions are identical.

I'm not sure that's worth it?

---
 mm/list_lru.c | 50 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 1ccdd45b1d14..cab716d94ac5 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -83,13 +83,12 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, unsigned long *irq_flags, bool skip_empty)
+__lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+			 bool irq, unsigned long *irq_flags)
 {
 	struct list_lru_one *l;
 
 	rcu_read_lock();
-again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
 	if (likely(l)) {
 		lock_list_lru(l, irq, irq_flags);
@@ -99,18 +98,24 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		}
 		unlock_list_lru(l, irq, irq_flags);
 	}
-	/*
-	 * Caller may simply bail out if raced with reparenting or
-	 * may iterate through the list_lru and expect empty slots.
-	 */
-	if (skip_empty) {
-		rcu_read_unlock();
-		return NULL;
+	return NULL;
+}
+
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+		       bool irq, unsigned long *irq_flags)
+{
+	struct list_lru_one *l;
+
+	for (;;) {
+		l = __lock_list_lru_of_memcg(lru, nid, memcg, irq, irq_flags);
+		if (likely(l))
+			return l;
+		VM_WARN_ON(!css_is_dying(&memcg->css));
+		memcg = parent_mem_cgroup(memcg);
 	}
-	VM_WARN_ON(!css_is_dying(&memcg->css));
-	memcg = parent_mem_cgroup(memcg);
-	goto again;
 }
+
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -137,8 +142,8 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, unsigned long *irq_flags, bool skip_empty)
+__lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+			 bool irq, unsigned long *irq_flags)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
@@ -146,13 +151,20 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 
 	return l;
 }
+
+static inline struct list_lru_one *
+lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
+		       bool irq, unsigned long *irq_flags)
+{
+	return __lock_list_lru_of_memcg(lru, nid, memcg, irq, irq_flags);
+}
 #endif /* CONFIG_MEMCG */
 
 struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
 				   struct mem_cgroup *memcg)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/false,
-				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+				      /*irq_flags=*/NULL);
 }
 
 void list_lru_unlock(struct list_lru_one *l)
@@ -165,7 +177,7 @@ struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
 					   unsigned long *flags)
 {
 	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
-				      /*irq_flags=*/flags, /*skip_empty=*/false);
+				      /*irq_flags=*/flags);
 }
 
 void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
@@ -313,8 +325,8 @@ __list_lru_walk_one(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/irq_off,
-				   /*irq_flags=*/NULL, /*skip_empty=*/true);
+	l = __lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/irq_off,
+				     /*irq_flags=*/NULL);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
-- 
2.53.0


