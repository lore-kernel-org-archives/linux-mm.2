Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7ED6606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IWNJU/v5
Received: by kanga.kvack.org (Postfix)
	id 575EC6B05B8; Fri, 13 Nov 2026 17:05:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF336B05B9; Fri, 13 Nov 2026 17:05:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2486B05BA; Fri, 13 Nov 2026 17:05:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2DB46B05B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:05:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C8761201F5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:58 +0000 (UTC)
X-FDA: 85431479196.27.7F3B5E7
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9AE53140009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="IWNJU/v5";
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PR3D8+JRACUUYgmS+awgi4uwjRnOXa+PYlfs9seiINw=;
	b=3GUQXc4h3jlAQAN95PThXOvc4eIHdvUYlglKF/RTZLI2X/XkoCKpR/Ro7CpMzXRjMCfOVA
	8rM3YI2yBH+R2b7vBFUtBPiRES2RH2DBy25mrKKqyaFasiQAgHF5Q9uiMQr6R/owcm2fUs
	0MpRV9US6024scrtCyH5trLL8lTnW3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607556;
	b=pgyDJ4mm2pg8HR887RU+RzvfLVqXUDRUmDX7OyG9uTzrhJyAVNt4xNJFft7Pt96XNfY8F7
	a2vGshujuX4OX1NkDxAw0U0r1fCX9VRxdvVxrjUU+qpvWYNWT4xPfmP3FtVV4nFLCLObmb
	aV5rdj459JVqcfF/s/hz8KzhOla8l/E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="IWNJU/v5";
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6767d92cde6so1641543d50.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607556; x=1795212356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PR3D8+JRACUUYgmS+awgi4uwjRnOXa+PYlfs9seiINw=;
        b=IWNJU/v5bheB0JWkWjnMvXb4/rcMeaXCC3d3NshSiXac0fFk7urHl5z8ulxlV/gWHY
         j+ZuUoaIbSgD9A4cB9bZJryW+Gdc90UZR6u6GpHnVAix7SOORhzAtakhi3rIE1QoXmvn
         Dx6exxVFKo79E4S9X2gBEjhsh+nX6DFgFfrnYgRv8UDbzgJyc/plDrVvsGm2mXBVpgLT
         rNgr1Fp9VRmPk2HYnc1zB5mPkYsHS/rGXQZaYsKiJJaUIgsJAE+al37b82pbpjV5AU9I
         yuIrjbUR75Hgd0qEgMu2JzobYnqLKXUKK8+4VB7Ho+2jvTeKAnDmtL7an109Yg0LV0gf
         i0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607556; x=1795212356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PR3D8+JRACUUYgmS+awgi4uwjRnOXa+PYlfs9seiINw=;
        b=L1SEsLTkG1BQRHAWXLD0Z3k8frIbHofoCZD5rGsnGF9zTbdw5vNpQ2FU7aXoA0DD0b
         ZvB8So7eCl6/HH5bI+pWlp6qu14ZmW1Ekp96MFiWlMSSHAxsJPlFHnYV2mEChfpVxl8K
         XR28burbJt0rOYd1BwoknGY2r5eer4kXk0/7shZp2U/8a3tMfDEj2CO6wYnVLmv34czq
         9vXPdGDt2NDEeaUW99v4kniGRZbUzg3u4d3Z4MDos0T34HyQheEuyL5GWMYBTtv8wVgK
         E+S3jiavsngY/cik9POxLfeDEBIE3DRvN9GTKRxE8y8qYA0rXlxZJdKXmEPSHqXnfC8C
         cjrw==
X-Forwarded-Encrypted: i=1; AL+hErEunH+oqU/cg2UcJ0yZl4EVn8FcgQ4ERBjI3ymxdiYOylcfjqJMlWlv1zns5BMyYbTPPK5V2RyLFg==@kvack.org
X-Gm-Message-State: APuU4Z/5+AkwWaqBhSSGKZnFvuy5pSMvC2qrJJGS0TQOlVGcAvLFRuHi
	ysGIxJw00b9TurvxYor77ca+ozRZv9xuuyGlUmNb1JxZb+k3fXZHMRMSMmSIag==
X-Gm-Gg: AYBFou27b+YsQgTVan64VSriF84x+beOcm7tejJTAlPaLZsRYuqjiwvsVKqKz2ENtIX
	afciUyS5iubgUQoiVLoXPRe10bV/3t05Up7lLAPRuXWyEuyfhx/5DzFHv49Yfdw6D0+Ym8xuHKb
	5h23jEiac2d0FF4AuTRW8TJg7BNCNsRUHxDrrTpuqJSY0VGKjCo5XN30E86jTMpDhU66cjOhZuj
	JzTQ7qF3etNAh/q2WPrz0oWiYGAn1K/E4u7Dzu35N/6r452MbbtcW3qcyPHvL1sgpNw7cM2ssr2
	IdLdhQ5d/X15ijmvQ3KdKMC3N/cZQGabR0hZxKHLK22rgCudRoo44Uacnro1p69HiDMsheLKFzB
	uDqbPley6JPjq5Iyd2ouT7ZhMVSYZC8BSCkSvgjlgxZ/MBamfbTA53TXli7GlOeVWo17b9YWea1
	28iv+VNI8IofZQSLmAHbRMKXNUWn6MbCv2bJnTkyMXOu40UqpSQCjc4NBtPHmRw+K3zNZEeaYLl
	8ycJUD2h5XhTGBKunoasaCRAqlKbOjT1m/aWucYVoZLcJSaoYkFqZfMT9862zDoki058nVDP4Fg
	xhPXbvcgYrlv5T7kjvwNyHDTgKhlzQbiB7ZFq8dmJqz2QdMiEEjmAWIrxrd6fWwtxk5SEecCIPV
	A8+P078M=
X-Received: by 2002:a53:c808:0:b0:67c:2491:3754 with SMTP id 956f58d0204a3-67d8973e601mr1944017d50.81.1794607555621;
        Fri, 13 Nov 2026 14:05:55 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a4359absm3179886d50.1.2026.11.13.14.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:54 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 7/7] mm/memcontrol: restrict memory stock to leaf cgroups on v2
Date: Fri, 13 Nov 2026 14:05:34 -0800
Message-ID: <20261113220539.2275715-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bdquko4eunzefk7r7me6dmw9m5kg4atp
X-Rspamd-Queue-Id: 9AE53140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794607556-609210
X-HE-Meta: U2FsdGVkX18gqq7CmbsPOb2AxqMD33VIchomjtZXpuKbTdjl3tIoj5N8yyZReFJxgdl2CU9cHJ9vEBc07ovCwXibaB2XvqKGHn9wgNCIYR0x4/Ph95t4BSO6Wl6Tm2MATA63yOUx7VisswLGAC8c9Jno3EeMK2hpEu3iCFE5okWvbTO07S68OQy08C51dsoZAeLFoQkYTL2dkdY5rvNA2LY27T6sHcQg/JJ559QtxD0yvuHIfDLRV70zFbrgLqGDcaDdvJ+5xV2vVAvIAREeIecqIgrDDm1xSMnvm1aSSnYqplwruFh+n2vUNUvB8Q/Z2cL4iA2VeTkaMEFHqXXWhI4jorm5gGo3FcbKB9LyymBZU+XORK93Xxevi1/IpTAumyyErSZUHbX3aypwhwO83GnY9x3Q/DwOL0o6EOpftp00xG6MOGkdK2UiPrK//v+tP3UjX7tGoLGzHC2jzZUHU92HVGYK1Xp5Uo0+LF1LxaiOP/LWzQQu+H+g+NXFIkWyxoE1sFIOr0/rS6smvjg8HuH77oGDQPOj9oteZNLSmh/PsQ1SjxPGYZ5ZqX4Xjo5LjgPDm9u1Y6G9g50NCL0cPmTw9hyDkdCi3oJgfDHySLqPF/7YCjgF3JiBxyEKbwLCii+o1O2ndXwsQTGFgdUFx1w8iiqT318EiSzf/moA0x5/Z1iw3Qpgt8gm8AtQ11FixKlPoLSz6rqLBw77Cjl5VwJuohMGC6NebPibplOnamgio+ladX6+ePXJHgm2T4cHrMQvVC7oXHeuEIru1GjIpM8GTtEHwcN+gqmTztQgGvqS3Oxm1ThNIkby3WpkEblV/yKs7Uc06/NCYYdCuttKbHD6hf71iEpUjeW5EK2ABRsGPdyfpAibqUiTOcdLjX6RDqIekns7MAm2ZZAViIKc4/TdPVAHAslWTVXYDFeYI7NlZ23LLF6wG1easI6mH0nf8X6i1SbIOmjbcNxBkai
 vCy321k1
 1CzYF9G+u88MECAYSspcZG7nGUry+mF8Tl2G0oyNVkCuerLIFivNysBuWRoWUFcG9Wq6prIMamdFKvh1RToSQiD056KE8NsFv3wrRxHaM9ri2aEWk/o7SXWRY731/SFCEPpiGOYZHY/Hk2Vdb4D7z6TMfdBKEw8LjnsKaJX9ejJp9QumolGh2t3fD+kdRI+tvboDRl68Hotu7vN7S/6cd6c067BDWGUXNc/c0ikZ5aqZ0P1yhzsx6jKmaBYh/4Y5cnI1Tga9te340+Q0cqLr1oNUifwogGLQ/jNe/4Chfy5EgzvwMAyYrZkUomWICmnN7pHOrhnhwDOsdEwqComArCeBcz44KfSZVP1dWhRn5URKkvmzYs9fivtf1oQN9HIw+LRXlecKGwiJlfUgkU368Vds3swgUNtuyfbJWV71cAQvVxFFOBHRMemkay0oNkZv1RQXFmGeEZTkZR2shgSlZ5yOjeTpK40IrkThgHnOjQ2t2NC/TqVgnouOxMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In the old memcg_stock world, non-leaf cgroups in cgroup v2 usually did
not get directly charged, since new processes can only live in leaf
cgroups. This meant that stocking was usuaully only for leaf cgroups.

In the new page_counter_stock world, stock belongs to each page_counter.
To prevent unused stock from accumulating in non-leaf cgroups, prevent
stock refills on cgroups once they have children, and schedule drains on
non-isolated CPUs that stock the parent.

CPUs that are not drained because they are isolated or because there was
a race with a refill may keep a stale slot for the parent. This is OK,
since the slot is never consumed or refilled, and will eventually get
drained like any other stale stock through stock eviction or draining.

One behavioral change is that processes that do charge directly to
interior cgroups now do not stock. Reparented objcgs or swap-in
charges used to refill and leave stock in non-leaf cgroups, but we drop
this in favor of not stranding unusable charges in parent cgroups.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb1f46b457ae8..15b5e0692c436 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2189,6 +2189,22 @@ static void schedule_stock_drain(struct page_counter_stock_pcp __percpu *stock,
 		clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
 }
 
+static void mem_cgroup_disable_stock(struct mem_cgroup *memcg)
+{
+	struct page_counter_stock_pcp __percpu *stock;
+	int cpu, curcpu;
+
+	stock = xchg(&memcg->memory.stock, NULL);
+	if (!stock)
+		return;
+
+	migrate_disable();
+	curcpu = smp_processor_id();
+	for_each_online_cpu(cpu)
+		schedule_stock_drain(stock, &memcg->css, cpu, curcpu);
+	migrate_enable();
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -4314,6 +4330,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg->private_id_objcg, GFP_KERNEL);
 
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && css->parent)
+		mem_cgroup_disable_stock(parent_mem_cgroup(memcg));
+
 	return 0;
 free_objcg:
 	for_each_node(nid) {
@@ -4366,6 +4385,20 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	drain_all_stock(memcg);
 
 	mem_cgroup_private_id_kill(memcg);
+
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+		/*
+		 * The parent's online_cnt counts itself and its children.
+		 * Once the current css is offlined, a parent with an online_cnt
+		 * of 2 will become a leaf again.
+		 */
+		if (parent && !css_is_dying(&parent->css) &&
+		    atomic_read(&parent->css.online_cnt) == 2 &&
+		    !mem_cgroup_is_root(parent))
+			WRITE_ONCE(parent->memory.stock, &memory_stock);
+	}
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
-- 
2.53.1-Meta


