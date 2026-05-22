Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D6F8CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957FB6B00A1; Fri, 22 May 2026 18:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBFC6B00A2; Fri, 22 May 2026 18:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7EF6B00A3; Fri, 22 May 2026 18:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8226B00A1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F9F41C075F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:44 +0000 (UTC)
X-FDA: 84796441128.08.AFBDA17
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49629A000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PwsFLCIX;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31yASLdMSEM7nexMHwB6RiM0ndTUZyyCT5Ui47lS5/Q=;
	b=AE6sXFQxYBX9g7RTYTMWMWSQjfc7a39yugvHV0MCEISpmhmM8nmvhtgpRofeP3gKxCAdT3
	5b46PjFUyN8xfWu7KzVJqnUbywUYd3UOMzV1bmL/EYCQUKEZHfx/WNbeG07WLXBrWqN13q
	2Y2TGU70XLYrm6ly+Vfl2vkOU1uzmFI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PwsFLCIX;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487602; a=rsa-sha256;
	cv=none;
	b=vA8BSAnrrQKCaP+Q+yYkPddBO34i/YTp2VE8lkn3eOp+Uj6b4Qanp43HOMVTcYYcW6H2SW
	jiYIbs2F8lQMtoZYxQzM9oHv0frO79A5wqaQay3Sx6PpGsStOZ6/KZOg4Qv96gqF3m/Ze3
	NCcjvvYqd/jKnv8QYzg7oShhe0TliqY=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4855e69a5a4so455324b6e.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487601; x=1780092401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31yASLdMSEM7nexMHwB6RiM0ndTUZyyCT5Ui47lS5/Q=;
        b=PwsFLCIXenEzFZ9xmL1bMhOBBrTDOTYh4HABVaDYFok9BglqP3gQ81EFkrtwacZEN6
         1wuTOtNNqzKLGVYlOVjDhyG/eGLsmRbounrqzOS1z8370vnoMZ+EAFtv2f+5MVHiWPef
         6gtY+6mj63NyBU4QwN87SyvR1ZNtulkXffMVomtKnKmike6E+mmEoxq6qQaeIfReD7AO
         093msNCuUcWEynKN7FfrfiGREFxJ0VaMIlybLhcGbr/Dh23Y64tIykFPwRe782p9LTBe
         sbHzldJKXo/9E1E70nM7UO08IF9//OQQuqCMfEy3pddog6BOB5d1LDWWbG3ROt+3lgcI
         dc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487601; x=1780092401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=31yASLdMSEM7nexMHwB6RiM0ndTUZyyCT5Ui47lS5/Q=;
        b=Z/RR0FL6h+P7961GtIYAHEI/xssgYrBkCxG161HWa5+GMzhEGAA4qFj9jMkT/SFqG7
         nv5VBjK5S0zBK+ptFKow+stcX+dBSqy02YWwL+b35zyU5VFaca5vVUeUfcZrodXV6T51
         D6JySnnMYPTtD6rKKwn+kfLCPGaYYOiKNE2xsLVjYdk8b7jehAyF0nZllEUgsPMt9iG9
         roTMyH50Jc87XKuXHlvQ7XuptrD1Ow3ll1dIz4DaTQxQN1lHE+KmTCQWVD4xIK7cjbE2
         9utI5jj8yYdzExYNA31hXC6dH+h3UKmYw1SowI4Fd8gMRsDuxoBPZVCU1NSQJmneGevG
         ckBw==
X-Forwarded-Encrypted: i=1; AFNElJ/HU9pnhZD8mbruqrU4WxosU+oupbY5o6dzlV0a0h/QS0bvjh4TaHJYxkQkdAdq9ttIhsys7ZZvMA==@kvack.org
X-Gm-Message-State: AOJu0YyTirSQJJcQpSOaNkq2zx+rkbb2JkXl8hGy0BO3FAixNvWiw0OF
	tIjeJeSsBhwKV6WFT0eweaiPKtjEUXsKieEauKHS8IvanlBEoO3FS6+s
X-Gm-Gg: Acq92OFuWgvLAz/oOTKUaoKOHJ9jRXnKNxG9lFVvBtpW86z1x/hC0XR9Ez6T4zbeNsJ
	y5BQeNeWpNNixlaPGkfNZPEK3VYF5H8JiDeo97Xvby3ytUDmyhjJ936zdOoPedWtuGeOgBX/Khw
	fHhxxF7Wusm6Vr9P4YC1tV9Wqf4uMipgac4aZc8ZyNhGc00HrvT1Vea+7RUkWcw9W/4bP776mUj
	JUrIVhaYEkpgH79ytW0D8Pa//Uh7aIejCNOg2XrRZ28y4zABGaTjvTA3vfJCMNnm3GDoGo7T6hC
	DNGk9d3KDVBS04YD3vGsr52tRZPvzXFqyKoo9vqR7ObMOLzJUN+M43ITfx8SnnDfpTQAJsvqXnZ
	YNfNxCbO6ypXEmbRt0d7QZ2/wPawFpQ4wp/f0kWiJtxt+s+TZvrc3VxtAHeWjEtf/VTORKsQjP4
	3L73CEoV06ay1f0QC2rgQZiayQVZZoaG5PM8TG9mWqY1XwNkdgKvQKjoAGqZyjESeeYcFtcLDGX
	ic=
X-Received: by 2002:a05:6808:c2fa:b0:485:4441:721a with SMTP id 5614622812f47-4854a1d46f1mr3600895b6e.36.1779487601412;
        Fri, 22 May 2026 15:06:41 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48554041ccasm1180385b6e.0.2026.05.22.15.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:40 -0700 (PDT)
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
Subject: [PATCH 5/7 v2] mm/memcontrol: optimize memsw stock for cgroup v1
Date: Fri, 22 May 2026 15:06:23 -0700
Message-ID: <20260522220627.1150804-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49629A000B
X-Rspam-User: 
X-Stat-Signature: wryqhy119jddgrpb8uymy36px4p5q1mc
X-HE-Tag: 1779487602-597671
X-HE-Meta: U2FsdGVkX19euU0Jw8wQSfjJhpiic8ZDfpY4CTniWfg3X/4GiffXmBu2LWr+dQQwx7Xpi+ZW4AWEB32jeBoB5VwLCg074dOs+h/mlIpx7jXfWuvHrGyCU2GtSsyf5Q8jEgOEjtN0F6V2dWhGHt/n+hW+mDvcPwTbz/8Od822PraBLzCR2fF/3KduoQ7OgAoOrqmBvKn4KT3AqKD2XQBDCmdHcP3Qr7krXcGjHgle/oQGaYoeAByLxW3uMpRX21yYQIqua64GsRC7JvDLgC2UH6vDBVJv7GonCwB1AAw+cYrq6HpvEBw4vU5KpIQ95az/HFYQj1495MQn7i6M0OR1zPNriqfGTsXV2YbCail5g08sOfcRL7I9HoX+JNB6SxoEm4d8wACSGyue3/U2OwdYyjsBcFDdRwT2aJMBRCdBJWuaFa5HSqnFJfIsq1/qoX673i9zFopRtPz5jdx8gjv8Kx3BOyOC4Ie0R6tjDBsQxoglG7b5W4E51IKIUBxJOykYWr8NoQdmzwZZyzXXxfReb85mRkDCevouCz5cKcCbI9SNpWMU0OrtJoinhuiuhCaeSMdlwTcDOKhDItaoXp++84bwWlLRAqID9qRUXY8f/IgWzdzUk//neWuUy7Y/X7Fm9cpoRGIwV/5v9DD9NYwZdHSwGWdiI9Y/i7PtdCx5ahKEqbir5gZlR4txeULITxCGOsTT0rPSydmdbAsgitKUIRcJkZYZtcHIlB8ltyQhAODAtZXNsURq++XHQ8XRpnBJGCpOyl8RNmeWCh+BmbLfIs9lvM52fa2bmOZqxSzvgrMZGSkr9NvYNZIkhzbVF+QvWpoly+uzg9t6kjkxfvRePx0DOZMC8n8vIVBCdU9XYWXOwg+KF8ncvVLkzAqcSP1N8P16t0q5P0mCAUAPSP9S7yYv3BM5nFre2swsUFM7SvBZZZYyzhxJGuhSAgrE8jiL85I4qjWa0TcNcslcLns
 DfPqtKSQ
 psPGOJaXYsY+7h801pnnqsYiC9g2e/vw9MESyi3WKZrJlg4cXEDDDqehg07q2MmeHx4FMwyw21ets+1ey42jSLoQlh3rDuAwHOkOl2J9BXuW9NQVYxGBEHBjgKme+qBUb8LSH6LRflk7dDTr5piFdlwSTBymJU4I9ZO+omGQZJNRlKNV4/fhY3B4SVjh8lBh8LxDgG4Leh2ma+MBYN5Xz7ZYkR/hr1UA1j1d+P3+/FcIxbmdOjFCiM0zVllxPBMY9079xTCXwV0RrDYFU61Pm2r7ytNldQzlhQoXWBIdu2eh/9e6q5L2l2GiSR//lxLb4ak7aKOwTsbZ3/7UQJ093NzF4Rx3aPCdjKSHjKy3dvRLEtZWjfAs2sLdy8p1X9DFFXJetRXTzy3KmE3BbK8Iiw+cjKBXbQtDWuc+aMWOz9IzM2w6FtZO/uAo9Gq0lqR14rfJ09pa6ISAN+D205xB9TtfWIwbYZQuYv2vWmjGq9rajUqedwyfGXYv2Og==
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
index cb1ea17e03730..06ec4d26cb519 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2058,8 +2058,11 @@ static long drain_stock_on_cpu(void *arg)
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
@@ -2106,8 +2109,11 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
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
@@ -3947,6 +3953,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	/* failure is nonfatal, charges fall back to direct hierarchy */
 	page_counter_enable_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+	if (do_memsw_account())
+		page_counter_enable_stock(&memcg->memsw, MEMCG_CHARGE_BATCH);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -3987,6 +3995,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 	page_counter_disable_stock(&memcg->memory);
+	if (do_memsw_account())
+		page_counter_disable_stock(&memcg->memsw);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
-- 
2.53.0-Meta


