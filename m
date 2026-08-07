Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0C9C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340E46B008A; Fri,  7 Aug 2026 16:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0C36B0092; Fri,  7 Aug 2026 16:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192516B008C; Fri,  7 Aug 2026 16:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E384C6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 648B9160162
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:04 +0000 (UTC)
X-FDA: 85075592448.17.8AE8B7C
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C9B28000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tCYAV9WT;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwNwt7qn0Dj2QjnweBxCilOvMKex3+n+ntJRoPVYrE4=;
	b=MyttuuByzYgflsqCkSxVu+n6OslQ0twZfVqEAUHQYJQhVE7S275N8D/VQk0cdC4juF5Jq5
	tfCUxaCz+HUBv1GjVmAHJ45x8dKkle/prb7ydF8C4aDCciPPCjBBGybSC2/iEEFmxmcTmu
	l1pb958BLiQV8Qki5+kyxfzm3ABpgDk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134062;
	b=8JoUbFKfti1CYQYrVClUXoXGjTUH8qZH5ULKthKpq07Ufsk/YaI58sM83G1pDW5siq5FaY
	mhNkxgGfY5K0JnwjdF4FfH3h1goYKVgf/DVdHFti+8OwXSRjflrCq3JmPLg+G+dCGxjL6B
	jl65OynSPdLI37ZKnYZTQSCmAtSnDvM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tCYAV9WT;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6ae6e407bfdso1490072eaf.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134061; x=1786738861; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HwNwt7qn0Dj2QjnweBxCilOvMKex3+n+ntJRoPVYrE4=;
        b=tCYAV9WTNeJDqekJYYTuPxreoWeh1m6xLbsYek/tNgTQnwH3IQlGBSg4U06hvsSdrf
         H6UE+Xrc544zZs6vEYWfsKHf31KxlAFyMJAJjPQg7sNS4cCMPYAu55qagrkSBXwSZ9ft
         iMtqI55Jp8ujmRsBKuqSnlSx7sLt/2bskSSICCDerY3dr0AShI9QjJY2evHZFKry58Ie
         jqBuooSxTv5GawBRkNpP6GSJ1oc5M03+oFEsMXm8TNbCMwbdQEmNz7SB34e+ggmDwNic
         PPVj3xP3WEiz9yNcIUmioacWar3c6ZVesz+CHSQTw+Dft53aWJ+dvkoULLukOE0NIShY
         SbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134061; x=1786738861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HwNwt7qn0Dj2QjnweBxCilOvMKex3+n+ntJRoPVYrE4=;
        b=J0x42UCcc7W0KN/t1FBBRekO4FpgScJ+jbnimjV/qQCjG9wA7jVSSvijS4UJMAGhh/
         RZaUd9X86gYGSywiWt+/Cv7fs42niYcjycQUU+ag1H1fSyponHoJmyN0LWRuMicEROPi
         CHvhDBF7z5MAdn70Qm7jrjmk1NQbK7sAjGP+JiKbicPAdXkuLM9DkT7opmZRkRaUWTNu
         Bltnr4Th09CuzmNWOc7PkByMA00GnP5tfjc8ELSUDADH8yG+TfozOZULPyqdHujeKLmu
         jponG2wL+OGHwSSN/F3pxaUNamfsCznGZPoVBloC7iaMQa0/+gaIcLkxKUu422ryg/YC
         d4Lw==
X-Forwarded-Encrypted: i=1; AHgh+Rpk4IzP7ug5fZGWIPQPC9MCoW+Rokuodm1Oym849DsOyE+MYq85UabPV2Jwf/mragtoyQnfkT0PkQ==@kvack.org
X-Gm-Message-State: AOJu0YxCoUpE7fibT0nFwoOSDMWN56HTspPbL2imzzG5z10I2aqup4yb
	xFJTGPVR/QtMxK3QngG/nUSMq2yypyIDPZ26bJGBiqUqFI2nhgH/n+gk
X-Gm-Gg: AR+sD11UA7NtowWFz62Y9VYzVKkl6aBmZZLD/n6ZJB6VcxH5ZiH9cwP9mVADX2GV7Kk
	PZ5ddKRXUFRef82S+EKPgDciKV9sh+kzkkWmgig/IN/NOrJrZctUw2qEhRPuaUBah0crC6fIx+U
	jNw9/RDyRVo3dzsslEplguN8OIWoJP8d3SJ6/Vgcp4faKOQ1JroQKakTZ/tFqii1KEWFoOo8gsL
	rMUXM/6uqrQ7OxTEqCQygyhtuw/ZTNCifvtmnBAaZ/8tQyXbeuszascLB3GsfGl4swuoUkOiQ4z
	Dl6pL9iuTultgS4S811CEUeY19nkZ4I4z8Bu1aLgwQVq8JT7WYgS+ZBimTuMNg2HZ4KXcXQFUW9
	lB0E1bKQUvVDeiX5hScHzU6qLyYv/ZtqDZ57JPhztrF3PLCu/ZrzwPvk81gNZG9nY/nnQ41RJxy
	O8nc09Pg9UFNPS6I7GkELUYXiMqNgYu/eUBerXLL7o8sABWFk7q2tJ5lV+m5qTWPOPPwEj9eSAw
	yGGZxUtCVukg2D53khov1/Ob6rULA==
X-Received: by 2002:a05:6820:1791:b0:6ae:ab01:9199 with SMTP id 006d021491bc7-6b042266f4fmr1570536eaf.34.1786134061552;
        Fri, 07 Aug 2026 13:21:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:25::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc2631esm3229086eaf.4.2026.08.07.13.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:00 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 01/14] mm/memcontrol: Introduce cgroup.memory=tiered_limits boot parameter
Date: Fri,  7 Aug 2026 13:20:44 -0700
Message-ID: <20260807202059.2620949-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C9B28000A
X-Stat-Signature: uo45ghorzyg6kuycijisqrapgs9td63w
X-Rspam-User: 
X-HE-Tag: 1786134062-234122
X-HE-Meta: U2FsdGVkX19gICqhSk2yKMGV/O6lO2F5OkeS6RWx9tcGyTJ6KNvlZ9nNa08R495sCt684/cm7Apv7SyZ8FeNUPrhX1ehGepgQx4J+bIHP1m33oUu0jRNfVzuaMmTkEKqr807blE2+53nGvubwnR1HZN1vov0y0C0FZauTee5Uz+g6TSr+VaW4E1nUZU8LhkTHAkoiUTI2I6JYBKHrVaznIpoHYW64msEbknqOKfhFWdabbRGtzlpR4fYS8VXx2y3urMCnMw4jkbZzt6iGE7ScjAtGbsngZIt3oTLlrP+HPaE82xfVorX4HKvuHQZdS1mwqSy5UXuxzVGD3n16Hbqb42+6NSDTrSvtk9HfuMi4MR+VyQ/VWhXqj7E21L0OhFFzOEn0uDCO1AdlgInBpqtEIWhLVnT24z4TEoAOW//bI+vIM3aTy0fotA/MI9d1H4IOejJ6AH5Wc8IcVRC6qkQa2zCIwcCp7Apr7tK7duBu1kwW/MkHk/bCVm7ltjKD71MNsd3xsab82R0gOo6RlW9Y8eynAQRGN6ouj8ewB1rh97kQDtHcXaGI77+qVj9a5SnT/tHkLQPrYKMw6M2DBtkIlL0Ruhpje65VLX9RNLxRbhZiPdeVANGkGhjMKKe5StU/fZ1KTSF4/OMGiCLmAgruvpJGgYGXgyyQj3bd6P2HQrIL0lRQbX6F91eYyGK2t3+gi2EiWTTx1iWxeA61ZNQeF9GUP9+/WrX5oPtNXagI7NywSRSQlqNj2ShYKzs9MDhKLo8L20pv8nYBWnXN44Y6IlGaKaM4SbQGkj8eXf3FzYTyQhiJGxN4GkJU+jHSnYVId6IiAAYMGPIgEWkLq4YovEwNpVK5Plw1gXGVl7l9/qawbVu2ENQrtVrS5vm4yLapuqVAjVzM5LfAykrctmJlHZwoqSYwnkttryI46u4SBEzzLQW1rZIz1VQKXyAJJMSZzUlGat6zj5Iq42pfFQ
 bE6ENHCu
 Hmd8Hg3Ux42Rjfba9Vr065kozI8nsvdb3C0egNpICGaSGxNtUU+21TRIncYJ3O4tuam/tZvlpx/Cz8wIPPpg8oL/jYDIXBLHXco0l6Xbl8MSDcvTG9GlnMACpLhQq9hkATGt6iTqxTpmBuLmzcdnhxY9tDDaHT/LjKG5gxh1UjD4y54hu67ShhCpuU4QQL6mSnGX++aOfZRYZCTn38tYGkTY0tT+hW1Qr9ykxthibC6MOe5NLCKWChcyLZG5hVRmZdLgOJn0yq/VNDxJL3TGUipDAQ8glfCGp02pQBp0nImu5KG2vPXwafU6zHtmnEmYxNV6gMQ+cb/dEOSDHsKJWoA71UGU+2cLn5kiT1usDPDXis4H6sVtLrjq6lBLsNAncUei+B9U4VriahPN+5uw8esfwc5X4RPfNtavp1AQJXTAruKIhE6MkxLKKE8UMU6zCiGVKVD9WjBs5cz9Pgtufin2wNSPkUaI7NAAxlh+DZF35H5EJQdj+mjZSGFpSUcrFswXZjqdavTnT1oLAnOnesdJ68XLZy380vqc14+z8YMNLyMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a "tiered_limits" option for the cgroup.memory= kernel
commandline parameter to enable tier-proportional scaling and
enforcing of the memory cgroup controller limits
memory.{min, low, high}. Since mem_cgroup_tiered_limits() will
become a hotpath in the later commits to gate charging, demotion,
and promotion decisions, use a static key so that cgroups not using
tier-aware-memcg limits has minimal overhead.

Enable it by adding to the kernel command line:
	cgroup.memory=tiered_limits

The option is boot-time only, since flipping the bit at runtime could
leave charges uncharged in the future, or uncharges for folios that
were never charged.

This feature is incompatible with cgroup v1, and wil raise a single
warning statement if a system booted with tiered limits mounts a
legacy cgroup:

[XXX] cgroup.memory=tiered_limits should not be enabled with cgroupv1

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 18 ++++++++++++++++++
 mm/memcontrol.c            | 19 +++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2118d5b33d051..dce03df7eae05 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -530,6 +530,19 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+#ifdef CONFIG_NUMA
+DECLARE_STATIC_KEY_FALSE(memcg_tiered_limits_key);
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return static_branch_unlikely(&memcg_tiered_limits_key);
+}
+#else
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return false;
+}
+#endif
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
@@ -1083,6 +1096,11 @@ static inline bool mem_cgroup_disabled(void)
 	return true;
 }
 
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return false;
+}
+
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29330f5f9d4eb..cefe33b5fd285 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -320,6 +320,13 @@ EXPORT_SYMBOL(memcg_kmem_online_key);
 DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
 EXPORT_SYMBOL(memcg_bpf_enabled_key);
 
+#ifdef CONFIG_NUMA
+DEFINE_STATIC_KEY_FALSE(memcg_tiered_limits_key);
+
+/* Tier-proportional scaling of memory controller limits enabled? */
+static bool cgroup_memory_tiered_limits __ro_after_init;
+#endif
+
 /**
  * get_mem_cgroup_css_from_folio - acquire a css of the memcg associated with a folio
  * @folio: folio of interest
@@ -4202,6 +4209,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	struct mem_cgroup *memcg, *old_memcg;
 	bool memcg_on_dfl = cgroup_subsys_on_dfl(memory_cgrp_subsys);
 
+	if (mem_cgroup_tiered_limits() && !memcg_on_dfl)
+		pr_warn_once("cgroup.memory=tiered_limits should not be enabled with cgroupv1\n");
+
 	old_memcg = set_active_memcg(parent);
 	memcg = mem_cgroup_alloc(parent);
 	set_active_memcg(old_memcg);
@@ -5584,6 +5594,10 @@ static int __init cgroup_memory(char *s)
 			cgroup_memory_nokmem = true;
 		if (!strcmp(token, "nobpf"))
 			cgroup_memory_nobpf = true;
+#ifdef CONFIG_NUMA
+		if (!strcmp(token, "tiered_limits"))
+			cgroup_memory_tiered_limits = true;
+#endif
 	}
 	return 1;
 }
@@ -5630,6 +5644,11 @@ int __init mem_cgroup_init(void)
 	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
 				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
 
+#ifdef CONFIG_NUMA
+	if (cgroup_memory_tiered_limits)
+		static_branch_enable(&memcg_tiered_limits_key);
+#endif
+
 	return 0;
 }
 
-- 
2.53.0-Meta


