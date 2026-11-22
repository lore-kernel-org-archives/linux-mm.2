Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AD6606A33A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BGsr5tWn
Received: by kanga.kvack.org (Postfix)
	id D6CA46B05B5; Sun, 22 Nov 2026 12:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CD26B05B6; Sun, 22 Nov 2026 12:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BF56B05B7; Sun, 22 Nov 2026 12:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4AF6B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:03:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20581140716
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:03:52 +0000 (UTC)
X-FDA: 85463377104.05.61B1AF9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46D90140010
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:03:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BGsr5tWn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795367030;
	b=hGofi5QASqmvFF6kCF6YpeDwA697bwHvsNyJUEBQvdaMcAGN5P2Rajd8rN3H24juOH2npN
	yZpY43DkKZr/KJmtELpMdI/rYmiqmHZubpHxfKcnI66inNUpAQhgfIaBGq72hOAOKTSDp5
	Cv9rMXTJXG4ynwYpDROEAQ4uYRz9xZk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795367030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmTrwXa44wNwYeC7jaSDYKhs1kagM9vZS4uaKGYPdVA=;
	b=rDPMe0a1ZK610rKmTV+e5Ve5mlZqVtGtIbqwNSrOBY4PYI84oTSt3uz/0EOG/zHLpFe3Iw
	R9swxhpaDqIeNr/ZvL0SYE0oQQ3iKXWWlpa9wdYC6zAOy8N9zHbO2VqXzhaTBRsriK6geq
	ojgsWg4YYl+QTFIY8+bWOv9E2yj9PlQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BGsr5tWn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f00fc215f9so17092435ad.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795367029; x=1795971829; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pmTrwXa44wNwYeC7jaSDYKhs1kagM9vZS4uaKGYPdVA=;
        b=BGsr5tWnUx8VpP1U2H7TmNgNaO9Yv6V/eV49uxNytaWwzSw9CEwPFNpEOqcp+GY1uL
         F1NBKWcYDACGWcXJpxhBKSj+O+o1MQK7s0OGrSM+dO/BqSxbH8ujUCFuf+08XBlf6qGA
         gzRXgoIFbbKPoP9SqM29T2Gm5EYIavn3Qkgl0nNS0K8x7TJ2merJ2szasXBeYiGMO9FV
         8rSXkvJ2D77UT695AXCayWIutxw90tU7s39rmXuvPuKFWfgQO+ODMn8Zq1FgbdLf1yCC
         Y/BZVz6kde2/aRL+HMQLGm24XQFL6KI0azYZn0V4KIxfaVBwM0uPhHM1ILH6Oc75pTIT
         uehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795367029; x=1795971829;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pmTrwXa44wNwYeC7jaSDYKhs1kagM9vZS4uaKGYPdVA=;
        b=Hkwa1HX2mkEI9h7Z5sMYPNY9EEVv195oZLRmuiJ2iJZRRAyasF0xAWKO/p41dCS3Zi
         UYzp2cWflKzVgMiyZDfwZjOWzi/TGcoUGmwAwduougTHFciG5S614twxoUbT3+Fv+QhW
         cC8Bq9RXRDdd1ocGg7TOdHQNh+Ev4EeCdr1m1qeM9fquEVMzmtly7mhX4DCePoalaupo
         jjtc3sM0sWqIm5dPsvrx4KyQRh4aWHO3NPOrrd96dtnIm6DRriQiVZBXcN6706XPsJ9X
         7CY9TlWmtBNs0e/tmJjpAE3gDi4hMGMMUCydFSAZjCeK7GhVejy3LGhQPkIv8qf4/V2V
         fuVA==
X-Forwarded-Encrypted: i=1; AL+hErE1EJcGPvQvR4PsjQREIvfCSHdDoj6O7SdsVS+ULk/+pzwyX/DHApTHvtyTILPRBb5A/m4uQu7tjw==@kvack.org
X-Gm-Message-State: APuU4Z8kmE5i5mep5g6nWSHmCpT4STKq1QaitF4gnMNEpSKDGMEeAQA8
	fOlKioYP0gywZJrLKZ5noirnfl+35Ig8K9PzK2QLCzXrgIjT9LN2sZOX
X-Gm-Gg: AZFdTZcXf5buTDxztSITUjAOHrq/Xkw1qOJxOncvSLmnapaqK/SpwFs1/5MUgLEB0tS
	kENMqVsyK3IPY3RjSul32ZvG9cQev8l/jhQTpD/E0wmIwypmtDA3sM/GhBwwnPOmdBx1r5HN1YV
	Kh5v1epzFe5xQ4sVbbAPGfrirjCQnlr3Idj+xmbmFbWhw0HwxGmkKnu26BfHferT/8rSXNUerIy
	nACh4wv8CNntYZDjcBFaSaGdTfkM3R1sQVdG3mtUiN62FQurWJht5WKe9QaZ2aY58jvkQXvaeoh
	baCFSI9RCCNbX9sxRGwOdWFJ9acoXpiBshFbdFgYp7pXGFfoExAz2As4qFvx4fEp57MNHQ4jfZ1
	ay4c2y6viq3wiEcpAlISKenCuCfQquVgFbC5oPuPD9agFlXF7lY4o3eyWxswUXz2kHCR3WL7esA
	nI0eeSrI5CRdY24J3Q5cr30P0GEQf2Y8hsEjNcQxBjsMN69nWQWC5eO/DoyGu34jGMDNhDL0ITw
	ks2xVZgsk1uVzUMjfldJ8lGbpidWWdjWRFjAlcTUUBNoSwpxVdTtRmDs3Csm6S78CCMedbhNpfl
	kDOX8stH5v23zA90/b3atZs+zYSdCYy2YkmkUBGaMEIiGoDUAqP6m5TFsZ/S3YbPLT9EfaM=
X-Received: by 2002:a17:903:41cd:b0:2e9:8bd4:577d with SMTP id d9443c01a7336-2f03f1bfa6fmr95419565ad.37.1795367028759;
        Sun, 22 Nov 2026 09:03:48 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c42b1sm39111735ad.17.2026.11.22.09.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 09:03:48 -0800 (PST)
Date: Mon, 23 Nov 2026 01:03:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: kasong@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <awMX9W-Ykjw4maRg@KASONG-MC4>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
 <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46D90140010
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: u7dkfenzisep9uio6t6qsmtgmkkh55ir
X-HE-Tag: 1795367030-978810
X-HE-Meta: U2FsdGVkX1//jXi8BYvkZV//W5nXgWOpRlt4SzF3ErTz96r/iNYmDXo0ZeV21MqPiM0ZJrF9zi5+LDj/fk7mSk+rhLJwPnmfZczVvqXlzzav5nAgPFW18esLOPxM9V+6UTY+JS3r/Yy3kknxDSiiV0uPXE/vpEtcKgcmGNXqI3jvBs7GVF8itlzah37M/SZlOwuM6RBJ+TxGJ9n+bv/IeVOiowUKXQxGhVd9hxIzxqN9pyqa6cwgykCTWgzEW52e3yPb5sGy2xKyEapDivq+97mGmAdxaI6ggPi39rj261e8wR8IioV0sMW4yv3RkA7md718qMR29u1RZA9h2//HPigVrqAMGQPC1BwwsvcuzEi0jFiF4uvGxu4KwCUHJAlMVkuSahfAsi894oJWv0xibCsWRCMs4iveB7riKurbM/0orpDayMTqx/6mRTy7M5V1ZjdzOEsrndgXNwBH0xxJ2hm6KE8TM8pCfsMjn+Sh7bNt+CcHJuV/Cy0mbPE+lIFU11eGl0u5JOCRZL+7ktAp/GejjYwK0B3CYLCaAcNNcG45RUM96escO7f1SAfiZ6qWOtr0UKcGha8ZI2e6RucW0+ELyjKDnbADQaVzK2vSX6BD4gX63EJx48G2+fkSqHWeZ/dUHnAp2P6w9V5fmkLtJ6mH5b5l29LKX6p/w63rTuY8H6CKbHf1A0EpVzHRvUSNz3b3iQM3msxOKyCTepgtxcwLnEU8NpoK4HRCFcbfNk4ka3im584gis5Nkcu/37giPLFHhMIAX/fnkqN/Io9Xd6Cemy8eJ90hWhelmClSRs3N665U5MwBwMp56gi6TW3ZVGx28Ls4RD4MFrmI9zP9IvLMr00/IfQQnyGD8dQhjPaTRyt6hRjpkfX8zokWrs5P0jenEG0CPcWExx+9Ln9Zq/kZFgHIwLFYuCmGUWNo7+g3EhWjUrwVsShXzxg1ZXl/stRZJPwD1Mezil/JuJq
 wxk+sFX3
 KkxdAASH7efu9GT24VFBad9hgw1OI9+seJYBp5bZLF/Tg/tKxGRJyTTkGbV8q+4jXO2HonRlfXxiwyyCC4D3BuwxVXtryHmkN98vbSp8TeYJ1Jp5H4q6R14T+9jtpMEy2YU691s6RlrIcktFBX7dVKrymnzIVmTQXQmVTVPsIwgaCRrP9K6zLVcY416Hyd0sBtoOBu2dOkAsE246f3UmHHpmCkx6UxqlBxe6QG/jWiS1IFegJAYlQY4hYaxbV9w8nfyoY085mTxhD4C5BqtGm4CU1mbYMg2rD6FkEaAx7DREXmzGWcsDYx+7uzXXeQNJj38X5iZeow9T0zMHHWtKgyvOBeI6pjjUhVfViSa86hBh3WRFcVsYn7J1SAgF8vP2EJqwoZkOvj8qzPgGvZUa3xO6whVSPQx04iGAbYaMC943xXbCpsXqFWCSZ80k08WESOB6mDXy0wu9h2i8yxUU1oA3Q4+PJ2RlpWHPFUiTwyJc2ckWdIuhexrkXq51OqmjM7ByJgGsnh9+a0k+UmTALP7vAbF2yH/S4Rhk9Z+RhH374RvCD+92ZxkRbpqghg5su/uMDmOPw3HOyLyNSXGx/EBiHOzx4W6L1o/2LS/MTDJuuzkQOIRCsWyhq93pOaabpNTX1V9cHABInqch4bpvfcgKTZwVA9LElcJepSJj8cDCtWOVBSnq965LyY5UbIxyeotDkzXSNKgL7wtE+81yj2f8rY0SpVBHlUcwp2EalSuLd+5FLyvcVB6MRRr7XN3XPkdS2HX2bXa5C/AFdd9qFubrfNcusJ22wiFdC9W9yD+nDO3h4sizGPzMiCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 03:53:44PM +0800, Muchun Song wrote:
> 
> 
> On 2026/11/19 05:03, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Add a helper that resolves a live lruvec for a folio under RCU
> > without taking the lruvec lock.  It takes a folio directly so the
> > lruvec lookup happens inside the RCU read-side critical section,
> > which a lruvec-based interface cannot guarantee.  The first user is
> > the lockless folio_inc_lru_refs() path later in the series.
> > 
> > Factor the ancestor walk out of lruvec_live_lock_irq() into
> > __lruvec_get_live(), so that both entry points share it, and spell
> > out why the walk is enough while only the RCU read lock is held:
> > reparenting of a memcg that starts dying waits for a grace period,
> > so it cannot race with the caller until the lock is released.
> > 
> > Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
> > predicates, and use it for the walk rather than repeating the open coded
> > css_is_dying() test a few definitions away from where it is explained.
> > 
> > No functional change for existing callers.
> > 
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> 
> Some nits bellow:
> 
> > ---
> >   include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
> >   1 file changed, 56 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 980358bc6f49..441a5d57e723 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
> >   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
> >   }
> > +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> 
> Let's make it const for @memcg along the way.

Good idea, but css_is_dying isn't constified, maybe we can do it later I think.

> > @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
> >   	spin_lock_irq(&lruvec->lru_lock);
> >   }
> > -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> > +/*
> > + * Reparenting moves a dying memcg's LRU state to its parent at any time,
> > + * so anything added to that LRU afterwards would be lost.  This helper
> > + * walks up to the nearest live ancestor while the caller must hold the
> > + * RCU read lock: reparenting of a memcg that starts dying waits for a
> > + * grace period, so it cannot race with the caller until the lock is
> > + * released.
> > + */
> > +static inline struct lruvec *__lruvec_get_live(struct lruvec *lruvec)
> 
> Cound @lruvec be const as well?

The argument is fine, but tricky for the return value: when nothing is dying it
hands back @lruvec unchanged, so a const argument means a const return (which
isn't right) or a cast dropping it again.

> > @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const struct folio *folio,
> >   	       lruvec_memcg(lruvec) == folio_memcg(folio);
> >   }
> > +/**
> > + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> > + * @folio: the folio
> > + *
> > + * Same as folio_lruvec(), except that a folio whose memcg is dying is
> > + * accounted to the nearest live ancestor, which is where reparenting
> > + * would put it anyway.
> > + *
> > + * Return: the live lruvec, with rcu_read_lock() held.  Pair it with
> > + * folio_lruvec_live_put().
> > + */
> > +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
> 
> const folio?

This is doable, will do!

Thanks for the review!

