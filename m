Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C30EDF145
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 10:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5676B0005; Fri, 13 Feb 2026 05:03:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15CAC6B0089; Fri, 13 Feb 2026 05:03:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0861D6B008A; Fri, 13 Feb 2026 05:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC7676B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:03:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABC74140441
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:03:52 +0000 (UTC)
X-FDA: 84438997104.15.2A165A6
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id B48111C000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:03:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eYn3MDFE;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770977030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ua28z24qUIwhHYuR3RexH1TybxsEtCTG1vVnJWGtDUc=;
	b=7R7C5TfWRgabADklc+WBswhpSFdDyCRDYZGoQqgT7Nj4flX2v8Ldf57tuCm7D/6vtgkxqI
	V4UJmI6cU4bAhZkQ7Es3IYY93PeCXp7aj0omR+vjQJjpfGidTTJsgVmPEficHfLgT+tWtf
	7HXpgZx0nNbZFlw4Ms30hx2Ckbkj8S0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eYn3MDFE;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770977030; a=rsa-sha256;
	cv=none;
	b=i+TCQfzkmtQ+q1g3A8/0o918jsEZrMczA2vjqQbG2oOLA8/yoZwMxD5EfqBS58QNxT0Ylw
	liVCjI1KjcEYp1XiIyfhFzTnpc6EjfH+u25HG+NeP7mwM0wUx+qFaPZs2bjVX5zixnvtu7
	JCixtmZ7ijX2phqybB9YEFzpCTAqZFQ=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-824ba8f0acaso475094b3a.1
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770977029; x=1771581829; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ua28z24qUIwhHYuR3RexH1TybxsEtCTG1vVnJWGtDUc=;
        b=eYn3MDFEr9mu6V99DO+yobtkUGiNS+m8Od5eRO9RsccfpFmsx871YWSxsc/KLNdsg2
         MuCy9PBonqETV4fbMtPYFjUkMquNeeSj/Qa+9HtSAuWKUkvsiB7J8g7HYFryrvG71/uu
         s8Hs3Su/HZo2+wxJITEE3VZ1AjG6F5Xld5ZetEvYxIEHNoXKzUtRFyso0yqE2PKMSOyX
         +yP6frbs0nxtUCbpCUvJSbOb6B3lXc97DZbTq0gbyARXyNX9ohkxPaz8YJbTYLNjZ1ON
         WTW/WMbgCSyaYIkgmATErHSt0uULkz4nUbwoxEMlFU0ZbhlHmOervv1ochzeBcVRBXQW
         H+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770977029; x=1771581829;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ua28z24qUIwhHYuR3RexH1TybxsEtCTG1vVnJWGtDUc=;
        b=YTgmukdtr11jvellRiDOZZcCOPuUEnIpu23k0PmLpWNJMSwxfAHQickpeUC6Jf23lV
         g+WL4Kws/uc4ZNhUbUlr4uYUEahV4KDRZffrgAxf8NuURIbLbwVh4LEinaaH531fDxsW
         oFucac7un3/lYJDfeTW4TkKxDhyMd+U4wwzI2Yb/oe+9PjnTWG0UAf6MVBB+NZy/jiFT
         89B89BPf8UH4fmqBbiPKZw9ugHyuLk2tNttwM8y7oyWo5vrSByx4BradnXZ8j523bYQF
         tGt9ai6QmT6PxiCf2raKyBBLUk3LznsL6L6reaE8CIc49cPxfDg61gyEH62qRM4TiquI
         xEiw==
X-Forwarded-Encrypted: i=1; AJvYcCVFcSIlxyriWUozpIIGTkxCM30aM19z4WtRKUZQaxoIZTUPYcNpU91KkNPJQUClqWdnCjrldbNWkA==@kvack.org
X-Gm-Message-State: AOJu0YxRO3OnsSp1YfS62WnoRiHGot34huTqKY15Gm+xihEhw6ERHz8P
	M0nRbda0CUZLSVF2NLJuxDdLzc3dzqFiwLPoFXipD7bxFIe51ptlbmzs
X-Gm-Gg: AZuq6aJ8wgH6yC3jvA74K/yTWofpLpz1lBYFbpdIu5UqVHE5BIuTIlBBBV8us9W2ewx
	QJq6WMfYLS1t3rGbrfGoVrQr671y5iOHaPhmToLn5x6L5fnL6kBbm7QdByrU3dfrOM4uhbGEtuZ
	h+gG8ZR81oBjcLE27snMMl7gj8yqPHQiiokZvUG9nsO09INo8d3MjSjP5Byou3XyE9AJOtyeJzC
	SqyvYKbIJFrQylnOHRAN4hxtgADuDfAtdcVBA21Zp2ljk2TVczQk6AdNK/HmxLTJXx1pJaMbfkq
	1vhPlH8LZPf+WxS/UYE36xRAXq6pvvJ4Q5zv1u405eYJTq431kgazK345cL33vPgZd2NTgZi0dV
	V5tZ85uSmBROEH0ZA9M1a7D/6xh1NFvdRkPzzjPit/KmRDZAgwTcScsRO7bG0/e2S72HOoEixSO
	NBAAFAA8b6wASuvfYxnL3dxkmhE9+9PzO0XGfmy18Gp2oyuNBBscx49Vd7xSSD7uo8+Kcsww==
X-Received: by 2002:a05:6a00:9288:b0:7b9:8142:96f4 with SMTP id d2e1a72fcca58-824c94ab2eamr1348552b3a.21.1770977029363;
        Fri, 13 Feb 2026 02:03:49 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a627a5sm2473663b3a.27.2026.02.13.02.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 02:03:48 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 13 Feb 2026 18:03:32 +0800
Subject: [PATCH] memcg: consolidate private id refcount get/put helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDI0Nj3dzU3OR03YKizLLMFF2zpEQjc3PjJNPkRCMloJaCotS0zAqwcdG
 xtbUAcS/uOl4AAAA=
X-Change-ID: 20260213-memcg-privid-6ba2773b5ca2
To: cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1770977026; l=5327;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aaFj5J9A/PnGFEo2q9D27aps5NSieS+BOnpHHXp5Eqk=;
 b=NCr+8KXvWVTribPSok34ty4hUhLU2/EfjCEL+VahbxmDCkbQ5IkaoayDDK1+gfER+QaxYvFZJ
 gftXwyIzRAYCv2mzXrGBZ1ysQkQw9seQLFFImWE0V6EUqmzB4tcT1lI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: 71k5z8jr3fwq43ep1djt6qfs3jk495tp
X-Rspamd-Queue-Id: B48111C000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770977030-607196
X-HE-Meta: U2FsdGVkX18i02jnPceBFa01b2C3YhFVZUInJVVEsng0YnvkrqNCTvVyU/NsFpGvh4h+kcf9M+XhzkDrQL0+B8UlCF6iaI3wy6fKoOSR/oU/yYmYhtJvr3dNRwobdkrJKc6hXIGBoVNp+XymTK/RTQbeYAr30EVJv3eEFylKxSnlakoJ+8bxmogsN6J9HNV/o2HoLv3QPJikHnDJGjMb2qLHmabJQMAw1s/rCRUikVbQlx2AjHGNZbaQmkG7sNzbdx+0hJV+E/zWB8oAeW7HATeuBQC8azLiKEe12EDXiAtyEJsQFjxeICWrVVF/Xb8mB7jv0mRPOlgr+Apqv3cQ8B/9PrxRsRR/SNMDnDRzdT2EAxxEWTgXN6ytIJgWTOiO7fPWDn5YTGQjd6v7FpZ3bOtHLNSHuLU+L7d+QO1edN7R1g3u/wnc4Ytxq3XblL83tvMQ2nFZiss9f5LaoaSfdcQlpY/PXV3RlhlJBHyM4+/GFEqwCDVk6jjaQ+l+gYpTmcJ741XTCX+a3YQPIyL9CXiTO/rgV0xC4IkjEiBgj9x8oCsLKuaLngyLBnZBNSJj24s1gQAgXI51qe3CHhwlTrwUsyrwqD5RVcZ5lOqz+HCOW4CWsTVAjtyUTGmAsl6ViPCnOA2S2iP80+SRtW0YxJ7bk/vM7JR1CxuZIAwrUzExRcOivpT4oWxKsFgoovBV/p+5v9LeekdMQXOk2avEyLgMcpINHo5vuhsugM1+lmTD2vyMxgDP8nBSn9ojjg08tGQubVYLzrTNyPEgxni5WwKjgGLVhIFWXzY1zlLmEnqewoJvE2qY2COsQ6PgBKTEdHdInc/sZdJmlKHI8PYsvrGxbMYyVHNTOMJMTbw4JdLGeH6wmTp/+jPXWghrSayMrwJc113BMlubAe/BOvLSIFK0Pv+ulsQ/grM7QMXVOtoHoYNyhM84RFFoNwgUefjnBVmWlPAebF/2CuLBJRC
 gGEXRB/U
 KNFBW7GxkHCP7YQFqAjAHLRotg6MAjZhSWDu05BaHuhZQZXA0Ur8Gx2ivVpm4Pa85mypkqzIOMKCXpKOdDISKuiFYg73LvHbW/3KYNai4TBLXggWzYg84C89EHQb8Qfk7W8QZxrQuawFQYnDbcMXRHftcqofP/3uef3nRaEXwT9xmZkUfpq4lW6u9tApqxm4W6hW7SJtWHHpmuLD9+OFGhzc//I/cwMvv374yff0qZB+Yb1sj4RQn4pWYBqBSiioeO0jBhrGhDgGMnSiV7imuGvKmIupv2dVRxSrBZtWcv7z11pLxS5qfP2eYUeS2F/1iIp62XXBgrR6mFS9+Ex+KtT/wM1Nug+bn6leQeNHvy5CPFwmZXhluNnVChX2GWe6t4bQll8KNxCj0YVIqV67rzW0pArjt2Z56jJCjCDq17/r1WGIT1yCgIiR8RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

We currently have two different sets of helpers for getting or putting
the private IDs' refcount for order 0 and large folios. This is
redundant. Just use one and always acquire the refcount of the swapout
folio size unless it's zero, and put the refcount using the folio size
if the charge failed, since the folio size can't change. Then there is
no need to update the refcount for tail pages.

Same for freeing, then only one pair of get/put helper is needed now.

The performance might be slightly better, too: both "inc unless zero"
and "add unless zero" use the same cmpxchg implementation. For large
folios, we saved an atomic operation. And for both order 0 and large
folios, we saved a branch.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memcontrol-v1.c |  5 +----
 mm/memcontrol-v1.h |  4 ++--
 mm/memcontrol.c    | 29 +++++++----------------------
 3 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 0e3d972fad33..c28a060abc64 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -635,11 +635,8 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	 * have an ID allocated to it anymore, charge the closest online
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
-	swap_memcg = mem_cgroup_private_id_get_online(memcg);
 	nr_entries = folio_nr_pages(folio);
-	/* Get references for the tail pages, too */
-	if (nr_entries > 1)
-		mem_cgroup_private_id_get_many(swap_memcg, nr_entries - 1);
+	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
 	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 49933925b4ba..dbbd0e13d4ff 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -28,8 +28,8 @@ unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
-void mem_cgroup_private_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg);
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
+						    unsigned int n);
 
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 007413a53b45..4425ef51feae 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3564,13 +3564,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-void __maybe_unused mem_cgroup_private_id_get_many(struct mem_cgroup *memcg,
-					   unsigned int n)
-{
-	refcount_add(n, &memcg->id.ref);
-}
-
-static void mem_cgroup_private_id_put_many(struct mem_cgroup *memcg, unsigned int n)
+static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -3580,14 +3574,9 @@ static void mem_cgroup_private_id_put_many(struct mem_cgroup *memcg, unsigned in
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg)
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	mem_cgroup_private_id_put_many(memcg, 1);
-}
-
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg)
-{
-	while (!refcount_inc_not_zero(&memcg->id.ref)) {
+	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -3888,7 +3877,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg);
+	mem_cgroup_private_id_put(memcg, 1);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5170,19 +5159,15 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg);
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg);
+		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
-
-	/* Get references for the tail pages, too */
-	if (nr_pages > 1)
-		mem_cgroup_private_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
@@ -5211,7 +5196,7 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put_many(memcg, nr_pages);
+		mem_cgroup_private_id_put(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }

---
base-commit: 9fff1ab283e0982c2b8e73f1d2246fd38caf40c8
change-id: 20260213-memcg-privid-6ba2773b5ca2

Best regards,
-- 
Kairui Song <kasong@tencent.com>


