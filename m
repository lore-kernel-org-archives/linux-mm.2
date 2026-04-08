Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D8AFB5189
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 03:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292516B0088; Tue,  7 Apr 2026 23:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243206B0089; Tue,  7 Apr 2026 23:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132786B008A; Tue,  7 Apr 2026 23:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 000626B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:40:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C85113BEDB
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:40:30 +0000 (UTC)
X-FDA: 84633986220.14.DDE268F
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id A09084000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:40:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iBIorfVi;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775619628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8Ds3pHng15kKOEJE0OjDpk2jM6or+3GmYgHlHYpLlk=;
	b=WIGxjjNizEeRu1jd6OwXBVgifVerjnkHA3fOzYrnn9s7aB5JrEJbjBjNiDeWs72GtOCr98
	2AwmnhyBwQeKAPSXkXEtO0rV0ijAWF+T1Ba49GXksOc4bLxvpQDlp5mYLV1RYKF8qGWzRd
	3eCH1zZgmYdwena2+ztZ01B+zWrpVWY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iBIorfVi;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775619628; a=rsa-sha256;
	cv=none;
	b=4ZNdis//WcIRbjr8WX8KPscN7NalvmzNJDhCZ+/l8MbSCn871qpscAxtx8UXPZrMytZ7hS
	pXioyHe11ub7R0bokw5gFt5s2IXlcwVAZPVHFsILtfyNKxW2nrHQ6wzSNXxeMn/Bp6Mun/
	3uDcANIs+kSGwypZaMTuIBmpgKaR9W4=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dbba5076c8so2165052a34.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 20:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775619627; x=1776224427; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8Ds3pHng15kKOEJE0OjDpk2jM6or+3GmYgHlHYpLlk=;
        b=iBIorfVi4DRJ5nVNDhWWurEmUtVSzEtrWJZ9OyL5m17SKOBlEx5/JHQ7KxYYQTKZNg
         o3m0VYVWM+TJo/3V9Vvj0GTUQXPIIUSni4K9yA/JTCOwtPkywgZjRVXh/ZC75PaUwqS1
         V5Vv52BuewPIZQYpFTd6GttdCVZnMSRDTsweukBKTe90+TdokCq6oMCqoaz3L+e7IynZ
         NN+ArQYGiPmwCEBAKcQSSqyTFLEC3eyRi4xjXyqtKY+iC3IdKR8asF3sfmtWmHi8Ave/
         q+SZBZ+sVau0irwTyQ2275toyaRQrm6Ge+qt7YeCi3MEv8LGCrfIFPaby07aXxj3GOVV
         yTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775619627; x=1776224427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c8Ds3pHng15kKOEJE0OjDpk2jM6or+3GmYgHlHYpLlk=;
        b=oNThNM9M3PVOt6l43NkEkZ2p3ZUKg79v23iJwYZL6Eu6xnka3HgfLMO7gnneV/wk+q
         ZKzRcGDYpUNM9C9JfNOjqe/Vjjy3rHXIAPZ4FaAgLd70G3A73mJWHYF+LNAYPrOLf3G/
         kpG/WCMOf2JCKxeI67JDWe4I28/384cCAfYpJIVz4kDcL8itXxzixYeDgRx+9ein+fkW
         w14Pr7ET3dqMkL6xhX39BYq144FNfXgjDZLuomRRYchSLnmEZBeOymyVn8h2dVhkX2NV
         imMkFZGmMvIyI83jYlwaYwSNk9Gm/bPpLsKyw6cMWrhK4zPa/HXQq/O+bzIffei7cfef
         XoAA==
X-Forwarded-Encrypted: i=1; AJvYcCW+MOPAnvI6Yg+HPYS3K0it7eCjP5AxmyTChgufL6Dxre9Hu6286WFXh5cWIVyAqoaQa92QjQ1RUQ==@kvack.org
X-Gm-Message-State: AOJu0YxjKKnE4acATD8Drka1MTfAtAyiBrc2agzIaUyFu33eWbwJEKKv
	fncf20qcVvSUsUjouiK6OU0j9aI9izTEbLIsScUgZN/hbTbVEz03ijjC
X-Gm-Gg: AeBDietiVJc73IqRYwPlHKMTyIM5aKimjbZeaDJ2RMCWLAa0qfytFjQJQ7EZugaufEY
	fbW5LJyWKhkVaU+nlARSxaWxCypIBC51WskPisd+XbiXTRG3JPzhNIOYVH2vDCzyYAURkGSI2pO
	LFudY/DU9/+CF2xqzDLmb/5tVAYgpJwSRPb9uFltvNOezGwxWu2I7uG3ziBeLISpml7/N6T7C3a
	J0fWP6g0AR7v+havXyJ3CKBH/FFwLi9tC+IkkE/hL3gzCPl790gFx5vwaPTByvGuV6H3kK+VFYd
	2qz0P1eerEIF9QgTzURjIjGEqpKzPrki5GQB1lAkDNVbxlfeM1Q3mCAbSPknrVPq2gPGy2XP1jG
	eEFV7vorzWRx482aVtRBBDqBL4k8Pg528TVOOurmyaiyjW36E43by4+e5eVZIGKx/Gyqu7/HknV
	TPVs4LV3J5Fmbj5vUd+CHI7Q==
X-Received: by 2002:a05:6830:391c:b0:7d7:419a:7ac8 with SMTP id 46e09a7af769-7dbb7517e0cmr11694018a34.15.1775619627529;
        Tue, 07 Apr 2026 20:40:27 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbed6c3512sm3988912a34.4.2026.04.07.20.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 20:40:26 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Tue,  7 Apr 2026 20:40:24 -0700
Message-ID: <20260408034025.3317937-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <adXAG52R6WVHd0n9@hyeyoo>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A09084000D
X-Stat-Signature: sktkojsoz8eh9tggupd5aoifu1k8a3ft
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775619628-217874
X-HE-Meta: U2FsdGVkX1/OYpEGuQslURR8uzJnyFg6yPkZZCSkNGNo4y9GiheAz5eQoESIy2gTvDckvThiT9zq3GjFjUHv1XOU7rSEIGA6F+fe8trUVw2LdLtFDQBCgXBwjbfqJBpF/7UVztjwrASZo7aZDVzKI9uif4lEn5Z42kOcqNPvmUKjpk/j6/OZJUYw6n5itzgqShE7wEZUwHTu5fp2dcmwg37HyZsXm+Rq2CaeDGolFgFeZRwvU8ChbNqSTRnZ4WoH5X0rlenIspltQ0FkDjWhiUDSVNw+LhishQt/Nr/SgrCpQHbosnmvejW0Yr6w6ycX9PQ5QDiBR7RDzDYEAKkyqTr635sjSHthwTVmIVEeUQH3rH3UhZrzf3OK5jRUlCbvrivU3VW7F7f9Zic8B1lSW92GkX80+fb6lRUeJolZv4mnz/LdDiqJuWQYuflXxCtSBqAO0XCiB3bgoc4/vlcMA/+wReC0IIG8BFVLbvRTSf7EqC2m1p3zqTEBe9hTBqZGSYI5b+L1k+Ue9OL7AsaDfe1VMig/MJg0uzGcakgUcyqUp0XBMgrqDVYI67QcM7godnyJa0udu09enXrVaVwKVKBOwI9+49Vux7QAFoK5G3T/V9zTyib9TvTIodnOzW7Yo0vdFufasdWzRulLG/HW8RRjF0aZIi5hOYNoT5rPpzZZCmD/43r6yQE0tbv0/Oo7JztR2cmOWUfI9yUDGyIxJykEiS/Eknd66eizI/ITzutwDiITeuTbR1o/Z7do/gmgNR0RJ55+1eBBm4yMbarYy5SoreI3Ztnit7S9HFTW+lHIIwqFwmhfJQDsr3SMN+8e7dNuHcR5xZmkIKkdeRXddP3zaZ02uhZjKkF1+JdOZ7F7Ng6r+gKVf0yhuLDMfiJT+TAOBqHpX1zoi64XSMUrBEHWsVZoNopXPddNqwDC85PS4ZWT9EW1pATcFhxiyhWy2IGpknEy+FKnVIaLC2P
 jk4ygFUr
 o/4KR1Faf1NEihRNjF3b+2KpnGTFCc8tNjFlvLRxYSM+O/n7jRZ2pcyqqIk+Aj9+TpsJAu8WWZAIQIhuSKP1DnwLkfk6u4fufXa20SVDsUuNznpnDGHCFVt/v8aNnf/gBEuJac3CTqw3UgNo/SyGKm2VVYHIGyfwwnYKmHnMrClNGtzg8HQlgFVyXtSXEK/q02g/uoKWQOftvLmAhgGbtUWX4jW2fj9HPmyE/gVtZnuua9vzy7qvmmi3PM822fvdy5L/vXkbhxpH/3OBmPRz4wp1WTKDOrxrQpdsp//o7cneyO4qBSkYlleIT0CJHWlCaQ0TGHsbmAe1ztlggT220mb4zBZZq0KkRfOshr1jJSZ8MyjU8i44/nVmhNFs9QvHZoBvBgbb02XR+ABeOBkY0JwGuYaPEPgw33ja66ID6BHJe4JsaBVvTyKCmmfjAnmpViYJotIos0yxW7CLuqPXaGrDPFky7YCRMN33C1Eb6u0v2ddmBc5+Q8bOp9sAkLKGzh/CaiUdd4bkCB3UlhL/KX0XNbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Apr 2026 11:40:27 +0900 "Harry Yoo (Oracle)" <harry@kernel.org> wrote:

> On Fri, Apr 03, 2026 at 08:38:43PM -0700, Joshua Hahn wrote:
> > enum memcg_stat_item includes memory that is tracked on a per-memcg
> > level, but not at a per-node (and per-lruvec) level. Diagnosing
> > memory pressure for memcgs in multi-NUMA systems can be difficult,
> > since not all of the memory accounted in memcg can be traced back
> > to a node. In scenarios where numa nodes in an memcg are asymmetrically
> > stressed, this difference can be invisible to the user.
> > 
> > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > to give visibility into per-node breakdowns for percpu allocations.
> > 
> > This will get us closer to being able to know the memcg and physical
> > association of all memory on the system. Specifically for percpu, this
> > granularity will help demonstrate footprint differences on systems with
> > asymmetric NUMA nodes.
> > 
> > Because percpu memory is accounted at a sub-PAGE_SIZE level, we must
> > account node level statistics (accounted in PAGE_SIZE units) and
> > memcg-lruvec statistics separately. Account node statistics when the pcpu
> > pages are allocated, and account memcg-lruvec statistics when pcpu
> > objects are handed out.
> > 
> > To do account these separately, expose mod_memcg_lruvec_state to be
> > used outside of memcontrol.
> > 
> > The memory overhead of this patch is small; it adds 16 bytes
> > per-cgroup-node-cpu. For an example machine with 200 CPUs split across
> > 2 nodes and 50 cgroups in the system, we see a 312.5 kB increase. Note
> > that this is the same cost as any other item in memcg_node_stat_item.
> > 
> > Performance impact is also negligible. These are results from a kernel
> > module which performs 100k percpu allocations via __alloc_percpu_gfp
> > with GFP_KERNEL | __GFP_ACCOUNT in a cgroup, across 20 trials.
> > Batched performs 100k allocations followed by 100k frees, while
> > interleaved performs allocation --> free --> allocation ...
> > 
> > +-------------+----------------+--------------+--------------+
> > |    Test     | linus-upstream |    patch     |     diff     |
> > +-------------+----------------+--------------+--------------+
> > | Batched     | 6586 +/- 51    | 6595 +/- 35  | +9 (0.13%)   |
> > | Interleaved | 1053 +/- 126   | 1085 +/- 113 | +32 (+0.85%) |
> > +-------------+----------------+--------------+--------------+
> > 
> > One functional change is that there can be a tiny inconsistency between
> > the size of the allocation used for memcg limit checking and what is
> > charged to each lruvec due to dropping fractional charges when rounding.
> > In reality this value is very very small and always lies on the side of
> > memory checking at a higher threshold, so there is no behavioral change
> > from userspace.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  include/linux/memcontrol.h |  4 +++-
> >  include/linux/mmzone.h     |  4 +++-
> >  mm/memcontrol.c            | 12 +++++-----
> >  mm/percpu-vm.c             | 14 ++++++++++--
> >  mm/percpu.c                | 45 ++++++++++++++++++++++++++++++++++----
> >  mm/vmstat.c                |  1 +
> >  6 files changed, 66 insertions(+), 14 deletions(-)
> > 
> > diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> > index 4f5937090590d..e36b639f521dd 100644
> > --- a/mm/percpu-vm.c
> > +++ b/mm/percpu-vm.c
> > @@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
> >  				__free_page(page);
> >  		}
> >  	}
> > +
> > +	for_each_node(nid)
> > +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> > +				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
> 
> Can this end up with mis-accounting due to CPU hotplug?

Hey Harry, thanks for giving this patch a look!

Yes, definitely. I think the solution is just to charge based on possible
CPUs, even if that might lead to some inaccuracy (by however many CPUs
aren't online at that moment). Seems like that's what already happens
in memcg anyways, so I think this discrepancy is OK to tolerate.

Will spin up a v3! Thanks a lot, Harry! Have a great day : -)
Joshua

