Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBEACDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473636B00A4; Fri, 26 Jun 2026 06:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423636B00B2; Fri, 26 Jun 2026 06:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3130C6B00B6; Fri, 26 Jun 2026 06:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F27AD6B00A4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:14:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 584671C1B89
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:21 +0000 (UTC)
X-FDA: 84921653922.02.6558790
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6BD471A0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468859;
	b=DapV2nkG4BHM5hq7sUwEEycaCdG8Aibiw0kwV57RDVIHWPfJ93vjuPHxIV6sUCKd+u9eCj
	JEd0+8Dkx3bk42mIX/4P7L9vX7iDG3pkwxcBDp1CXMHk8WVdDjd9OEbgyZPfNawZob/n6x
	vM4D8PEGm9Gs6cAsUYsFSkuL8ZDZlUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TynSdaQ58qF5cmfO3ktCh6Cq7Zw5aN+HxMRTnMgeCjU=;
	b=VWvADbMOCOCqcxA+WSkK1N1qrTJsfK/oZMjtlGhy4LeBN2rsZHTh7QXdi3kzyiwSH1Y+ce
	9IfnvuL1jOyVvDI42aptE7w7lg6DeS9BN1zcqizmuwQzcHR4i/OU/BzFnztJTcne8OQGvw
	oBij8W85unNaj63FpA6uUWeHoSRwYj8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 263E620CC9;
	Fri, 26 Jun 2026 10:14:14 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH v2 3/9] mm: percpu: fix obj_exts metadata charge size
Date: Fri, 26 Jun 2026 12:09:30 +0200
Message-ID: <20260626101356.1599643-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626101356.1599643-1-alex@ghiti.fr>
References: <20260626101356.1599643-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEBI1JGbXlpiiDp14fkAsKfAN5fPZBM2Ab7MYJnFM3+SveTMVF6Fpqo1pIn6X+1iOtVOzIUV5Y0lYysvg8wUhEu6iechcA9ZS1suPyZBWm40kuX54tSMCypoKaVvhov2zRyofq7gzsMmi381Aww594HETMja5HFS74ld7NppEkUPFcpepMRwyMI5cA7mkGe/vhPQABef+NqYfMk9kxiJ6/r8++B4sCphBOA9I/gZUpooOC/H1BTNf8jBjGO3awTrxngcQpM8nhCbLDXRzq4VxFUibvIrp2s4IHqQiAqPfb6IAcP9PvJXxAvxWk/3kLhKU6wNMf25eg1lrylx+omoElrMRhXPRTU5QAg55P1A2fULuVyjLaTCVf7iCHGVBwHvfUvN5AohRVwGfhnIDVwSRogQ8qtU6eHoi21/nWgO7QqbC8D34ZUT6xMWTVoNqENRF6wTglzFj3RFNzyrE64W0+8gPQZTZmZCCEdMOhU12z3BO+Dlx4k1PrIkTJAFe+Ubve4yVGt3pqebgd/QQo5qYcKAZMSbK+ItdwIVu+1CxpwBldP1RCI0BoFxYedUvs9q2yeKwHnxRzF99KLVnof+nFpoen7mheYmrlMO0ml12sKHpjSX73fHArGxufNUjCDHUQEyCfzYVIEatnwZjdax3fVfRGWsCn4cYTj8KhC3x1I2g
X-Stat-Signature: yw51ry543xttfhzfjoq6or59c5aqri8m
X-Rspamd-Queue-Id: 6BD471A0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782468859-683691
X-HE-Meta: U2FsdGVkX19V2gUQzcZUWqHGWB+4249I9Gaj8k/pGm9ovfI84z4GBhE4W4pg0s84IRyUfydtG7yMGVKvswlpzQyo6Ec/AYw6VmBi63XYffV+gsUdpFrs4vhXyicM/0KBn6pj1kpMzSZJybtuniN1PPGly06zovcAFR8zOdLEnWG6Xv44z1y6NmAsCOX2FxpRQg9pSeajm2xXQPaCmHfSn6RCNPrOCOqcBy5ykMYa/P7nt5ofEd/9wrrMvLFI5R9zKDf1sn1SdwrHGEEvJF4Pv6gKeS4GFOWLkr20BOey7ZLZLjkD8zvXBcgkVUKCEZcdR3zhdvCRbG6joc9FPzSD5oJ0sXJNNPJflona86ofvHnDY+VJFJ1TVnIIjo0EJdBd6bqP0rWLd1TDlXRYAUuQpSe3Vc40By3EAjWWJwrFF0C0gU0WqVzueYjNqSXTHDZEcjs9e6Nl1fOJ49i7OAkZvEuR243xn4equJCBmSQG2j3oxHEaDKpAHjQcZ6yqe4j/D1lV6W47CEiBRkHqEUo2iKMhQh8a555flGJTVN+pnQozOm+R/Imoep8mR+nOkPQpye5iGTyVGDmPqtA9F988H6yJfItNHGuHkely3wn0eFuGsAdVMM8yzxgNe6AL4vhVlNJPYLTwunadZkZrNFVcqy8SU53E+DMZDMjCOmnVWHBTBWZ2XgJ5A1cPDp7wK9rceKOglkrtlJN236Je6g263U9qaEBUhgFVkAwcVM9H5DVZVdbDBnXODkevcnJpJ9cw2iasPMhHfA9i9Cvgxu+FSMNYpXPdRaA0pHr/e14/LOUo3Z0AK8V4YE4sGX/r4t5eTaGVZ+SuRwmADiMR8hPtbOiapKrrLQSLI3Agw2O0FMkK5TCKFCK6MxU7v9KNFhGTILqop4AbU8g3tEDvBszKvCqRS8FPQvcgMVXZXOgn7QvaxSeJ9NjUtx2dp791DByJvA8kNcmcidNAKG6faoc
 P13QmYwO
 hgivlFs2mmW6q5+Yih2hn2RP+/cD/bKnAV+hdANS1pb0gRymSWVGmtKZf4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pcpu_obj_full_size() uses sizeof(struct obj_cgroup *) to charge the size
of the percpu obj_exts metadata. But obj_exts is actually a vector of
struct pcpuobj_ext, whose size, when CONFIG_MEM_ALLOC_PROFILING is
enabled, is 16B and not 8B like sizeof(struct obj_cgroup *) currently
returns.

Fix that by using sizeof(struct pcpuobj_ext) instead.

Fixes: 8f30d2660a38 ("mm: percpu: introduce pcpuobj_ext")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 8cbe039bf847..d1c0a508710e 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -156,7 +156,7 @@ static inline size_t pcpu_obj_full_size(size_t size)
 
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_kmem_disabled())
-		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct pcpuobj_ext);
 #endif
 
 	return size * num_possible_cpus() + extra_size;
-- 
2.54.0


