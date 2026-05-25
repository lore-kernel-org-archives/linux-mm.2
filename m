Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A05CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58ADF6B0095; Mon, 25 May 2026 15:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BA36B0096; Mon, 25 May 2026 15:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403CA6B0098; Mon, 25 May 2026 15:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 320426B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1CA2401CC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:10 +0000 (UTC)
X-FDA: 84806869980.22.C4F6434
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 147A340013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AllV3TT1;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbriz7dbk9TD0L3VAQpwYxY9mGZG6ZyIbAJOMgP+gHw=;
	b=kumQGJxaMU1zrqHGjp7qzGzxNriKZlxsPkc8/3VQltkKgYFzJfK02GWedpcTQ83zGZG7hI
	R72ynVOQMGkcEMXBxwsvubsNjCpgX4HXIjVOXAIqWnrqlszCAZQf1VehClCIPjcB6Cqczx
	mwJLkZVBXdlHCqv40vFkpYyIE0zIobA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AllV3TT1;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735909; a=rsa-sha256;
	cv=none;
	b=1kA269L9wLvW+wYe7wQ33v0Yi0AGSQbGcBd8Ejgxd+Jb5GLPgZOBHAvN8mDu7sI3MK92Qw
	Nq5s51VX+WKt0I4sTsS7KWzCxonAEEm9RXpi4R/J2bI+S9ts5GmA6XPjdCqu457N3YC1WQ
	hh4OP34RJlDNQcQHDzCX5J73k7pAiZg=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-43bfe055ffbso72147fac.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735908; x=1780340708; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbriz7dbk9TD0L3VAQpwYxY9mGZG6ZyIbAJOMgP+gHw=;
        b=AllV3TT1PJemym8jrrQ1EGhpMYs4x9SXnIJ13RgeqWSgDT7jYbVJSLw5PzALTfGHvf
         tkA9PsN9aMcLA5OufujqVTVXGqJAQqUdn8AlBS1zMkINsJv2SftL1Cyg9MXousHmwZ6k
         F4lpXfmGjdzewoJZT495vWKdsTaJlQr6X80tKrm7qELmcoEX8XqVuWfbOqytUOYR7WZ6
         2ueOh9+ksjVXEkkaSeYkELtTBlCUxCz7UYccbgyBlC4cx4Al4Y6pyfhjDJkM9StyAIQK
         RS6g9YepdWok4YCe58ULKAC9yW215SEpPY07j3bBMkmR70+dJ8DF6xayANOX6v8erceC
         KKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735908; x=1780340708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dbriz7dbk9TD0L3VAQpwYxY9mGZG6ZyIbAJOMgP+gHw=;
        b=ji+UVCUKuN1m9CYddeAPEQNKSB+NwjiqjHKRelArlZf69mlfDYp7q9MglRv72dJzG0
         j/kW+Fvs2tUz/Gohc3inGwKT2py4gJw6K21oBws8gkraGLgK/82nvcu2a0sRYJZySd2p
         x72t6zSRfzXIB4CfMMxF9HhqKd7A+ayve3gnmanMvak0qxr1IvlnIe+zbsPH9m/pRPE3
         8cjj5BOefSqzCrgv0iEPJhd9RQVRWdat6CpTA1L0ycVWYGD4uIje8rXCB9lLuwirLUSB
         hyB+b1p3+og94ZCQkUWujsESwOXQcU4H4ajkUBLI6+cJypOGAHBKAV4dHk+/CoTurcel
         6OLw==
X-Forwarded-Encrypted: i=1; AFNElJ9Bl9Dg2Zzvx1TBz7i+qB07jS7ph+3lioEVCAPPXS6n5ZuPT7fjCg7MyPrZuSUQAREYNktXiasZZA==@kvack.org
X-Gm-Message-State: AOJu0YyZH8XMIEQFfv749OUOHsk0rTJJ1l7DqDlBkZWP+1pz230GcXrx
	A2wNPiWBqmdaJ964BGUZCACnQWf/uS3G2cj14aUOSHyBOEmMqeJIQ9D+
X-Gm-Gg: Acq92OFAWdMwNhq/UNVnjoV1MTR8Y10X5YDCe2bUVV7hCElluLfGzc5V0MjiJea3u2g
	Vo3bgt+loq5cECxOI0W8UAiIgZ9se5oD5TMhPx4HNqUv6lUOs7NA8Eh74X93s0AJR0r/oUqiakr
	4paffWk9/yQ1tapEKbQslEc9L58IfIxeanZdtfq+gOZaxCM3fnPDVllVFTEUXlm7w++u/yz5Gao
	PIH1pa5Qh6tErc+2Q343+AlBwysX3ZQc2LRQk2I/L+4dY1yJiEtZG2bVBH1eM6qF4AbqHLSHuSE
	jr01U9HAt9yCKtU5PLzNfzsLZ7rbf5FHaKqPwEQeDybzFs9/MeB6aVLBDgZJMXOOTnWtwBoqQtq
	tvd4QlN50FIoB5WCkYvtqop81Cxr5d7lyBNc2If42UxE9Fr5/eh+pKZwCL/3FbKcY+icw8E3lHl
	7dlTjWxsVf88i3mu1z5/LQOv5F04B0CTcpUpmZS8N/bqFdMkmQd04CPriU0Lh3xmLl
X-Received: by 2002:a05:6870:b0e5:b0:439:ca41:d517 with SMTP id 586e51a60fabf-43b5ae106d7mr9194388fac.27.1779735908121;
        Mon, 25 May 2026 12:05:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b635d26b5sm10931364fac.6.2026.05.25.12.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:05:07 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 5/7 v3] mm/memcontrol: optimize memsw stock for cgroup v1
Date: Mon, 25 May 2026 12:04:52 -0700
Message-ID: <20260525190455.2843786-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 147A340013
X-Stat-Signature: 83cg94cp66t495g14bckk7zrofr17h8h
X-HE-Tag: 1779735908-529533
X-HE-Meta: U2FsdGVkX19GFgXUEkf1KMbhPJZdJ1WQU0Pplw0WpUu5qpSxAEU6faqOykcPB8cLtWaPU9Bkj1K1H88djgfg6LRNGyCQ46N2uqBNcHCzYxpccVvB8klzOhM43Nse+rTi8J+ul/KC0l4Csfdt64wA+IF9PySs1YGSSX4araNjoHk0c5OScmUKr/CMvsZIV8swQvtm26p0vvzu1Ua8WPvz+4hIYiW58u/QgkFyQVoDLYtUDa5Gw7jVqY2103TEGJa7RR5BYuAI72fqCS/IhZ0jNflInEz8ZcH/XrutvUTRuCcFlaCmDvftDpkvj+4GDtgVFbWl0jJuT3CUFGz5etGqcOogQHPkb9YC1oX+rZbE+UZNgETWEd36BJFFEIFwoAPkgQjnEcJcQCAMpL79l4P4/+CZTjsU/AMChd4jy8azclDWBXjJIEm/+wVtYTrkAvVKc3CyXGDKIjjhKMMvjbvrpJV/YZRuAQjDhYj2VkoSd9WHr8rvOOmmNdPwy7oLtDcf3yIgajC5AX2gbNYkR83TnU8nnhMWENs8b1jeM5NvDBigSJ3rWdH1VW8CmnbLZb/KAjh73l75huBtL5A9n1m+bIh2vWAba3QWgGa8Ik1AdBlAjPsUTKpcbFy6rkpcfXficrJmB1n2nA/IKYuLGAfKU1rZBSqCT4RtZ2CRNZukLFdOl56AIeuJysiDyDgeKm++0/O3ixPYKBuGt0HK2ZxE5/f83ptqWvA8dW1wasIRPgwORj4AC+pKW6ZK+o4/wqbbTHL0+MV3F/4la7ExiUAHPVltOf2cCGR1qT1x1Jqvyyeqr977K9GQ/HLcul0dwFnFsK7RfEgTVU1bgiJYOQpYDL1bskvHfpXHVYi06bwjOJ6Yy32SS2qF3jC3XKXUNihuJHhcP31SMCPELSUVhAocuVixoIV2tA5Clgta22VIAl4kHHtn+XxDphpABkUK2Y4ncwMehMgT/aEsxEU9+Vx
 BX1sVP8i
 v8dp3XCQmeEWhI4nOIt3DZOTLZG0L90WrUcO/d+nBHdzE4D2QXTXqYKgawfj5gaM7JG+ofGCuKd/o4wS1OTusApaZd3HZo/SJfLwdkbZPpmTbSlSvGs/fmuuwsOi60S9LdXA3j0djJnas1rFOPs1o9qsp9vQB5kMjc4/T7dEigK5JyTyJjP29r0aMTE4UP6FaxHS0HrKciWTftZ73Afcga6qiRIpFP+1PhN1TuF7wAGsVxav1IHcJ7hmjl/kvfUueP/5u0e+1ChdwcblrBJyrSkBhAh1x4nwX6/Q8l+QqOWDTGltdvfirRRGqyF02hMtVIHWZO8xPgeK26GDzEZJ8D4P02gMZYUszZZw7xoVAkmNfUQtzU1lXwtiJ3HRTtm7mnlZ/2MNEB0S77JV0AIC9eDZEfAXAqnkVnEtgL7ok3ooQHENTKIiXkLjnVUek2ykeilgMr+YJun8FAJXqgcuAYyhlaCyUpCbPE/L562LUMqf2orZX552pVa36W+Q2ktJx/YuNcbP5C98rNQpLNScx1mu5zyYp3dEDaeQJmLKlVlBeZgUGcObj5eB2sHXQ7nITC+LTMXklmKef59M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, each memcg had its own stock, which was shared by all page
counters within it. Specifically in try_charge_memcg, the stock limit
check would occur before the memsw and memory page_counters were
charged hierarchically. Now that the memcg stock was folded into the
page_counter level, and we have replaced try_charge_memcg's stock check
against the memory page_counter's stock, this leaves no fast path available
for cgroup v1's memsw check.

Introduce a new stock for the memsw page_counter, charged independently
from the memory page_counter. This provides better caching on cgroup v1:

The best case scenario is when both the memsw and memory page_counters
can use their cached stock charge; this is the old behavior.

The halfway scenario is when either the memsw or memory page_counter
is within the stock size, but the other isn't. This requires one
hierarchical charge.

The worst case scenario is when both memsw and memory page_counters
are over their limit, and must walk two page_counter hierarchies. This
is the same as the old behavior.

By introducing an independent stock for memsw, we can avoid the worst
case scenario more often and can fail or succeed separately from the
memory page counter.

One user-visible change is that reported memsw usage may transiently
be lower than memory usage. This happens because each counter
independently batches the stock charges, so the visible values can
differ by up to the stock batch size (MEMCG_CHARGE_BATCH) pages.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 952c6f7430395..f20c9b829224a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2265,8 +2265,11 @@ static long drain_stock_on_cpu(void *arg)
 	struct mem_cgroup *root_memcg = arg;
 	struct mem_cgroup *memcg;
 
-	for_each_mem_cgroup_tree(memcg, root_memcg)
+	for_each_mem_cgroup_tree(memcg, root_memcg) {
 		page_counter_drain_stock_local(&memcg->memory);
+		if (do_memsw_account())
+			page_counter_drain_stock_local(&memcg->memsw);
+	}
 
 	return 0;
 }
@@ -2313,8 +2316,11 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	/* no need for the local lock */
 	drain_obj_stock(&per_cpu(obj_stock, cpu));
 
-	for_each_mem_cgroup(memcg)
+	for_each_mem_cgroup(memcg) {
 		page_counter_drain_stock_cpu(&memcg->memory, cpu);
+		if (do_memsw_account())
+			page_counter_drain_stock_cpu(&memcg->memsw, cpu);
+	}
 
 	return 0;
 }
@@ -4259,6 +4265,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	/* failure is nonfatal, charges fall back to direct hierarchy */
 	page_counter_enable_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+	if (do_memsw_account())
+		page_counter_enable_stock(&memcg->memsw, MEMCG_CHARGE_BATCH);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -4323,6 +4331,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 	page_counter_disable_stock(&memcg->memory);
+	if (do_memsw_account())
+		page_counter_disable_stock(&memcg->memsw);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
-- 
2.53.0-Meta


