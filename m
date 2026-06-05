Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F38ECD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5457F6B0098; Fri,  5 Jun 2026 11:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F74A6B0099; Fri,  5 Jun 2026 11:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C366B009B; Fri,  5 Jun 2026 11:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 340676B0098
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:36:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7AFB401D0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:13 +0000 (UTC)
X-FDA: 84846260226.15.D2E4EBE
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id F1E4514000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/dGioRI";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2POwf/K9X70lHx5WEcIKkTy5o0DDbStiw7GuBjFdd58=;
	b=jvGPMy1lpaA968GQbMPLRnJmfysAxTs5VZcFFL3zs2jpX50Ms6eBzeBpupPAHzLtiqcd36
	dpmvjttNbusWZoz+rR1qr7nZ1xPF7LX/kKpGxB1qR9tDBXWd6q4wmcYKSv2b/AWU/Q4slI
	2RAbPMjoQxjw1+XtSUEGmEqjIjXQn6Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/dGioRI";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673772;
	b=qmmx6VcV2+N2hcXczEpZH4ckpPYq/qDepKd8wOSPBo/ZZl75PYPsR/1HMDmxADeFRfpjx/
	N1fqppMEXSVfS1CEi7dvl8jG58qMdhQfYVXBd8Dz47n8sfHqobVc50kOqa7AmBfcn4usgE
	1Jrb24rz0X626BEmfZYPRuTMs39bPvc=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e6cfdc92bfso750028a34.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780673771; x=1781278571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2POwf/K9X70lHx5WEcIKkTy5o0DDbStiw7GuBjFdd58=;
        b=Z/dGioRId07+hjaqzMxSG9HT/mtWbOoxmq6MJxNpnmniuIuJJCIfUOtCxUTLqILNSu
         6kv2vOaCYw9Hkx2MixUQ613lWfBq57fdQAxgelnacqiK6fGwoFZpQaneth7PjVU5gndG
         3VUUBjucipZQc/1APB1u5SQTMnadFstVpCfMN3T2HHtMeV0cU5m6iuzzc/S//SzB4wwY
         yLqeT9y8cPjcEyaDOAC8PvFlJmN+X53rUnIUYkW4iV2TyViv3SUj2CMinHpHlBNQiDBg
         FyJl6r+5PsdTV6xk3PrVHlW90jxuw/5x3iQOZC4uAbl4vL/Or/2gQr8P+Rm9JC8Cwpb2
         P1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780673771; x=1781278571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2POwf/K9X70lHx5WEcIKkTy5o0DDbStiw7GuBjFdd58=;
        b=PGFWz5xbqxQM/nGz4ajO45LX1WK9+PYioQQ/0U5utJ051JAgBwCRb/pVnBZG22OLPn
         VSFybfBFjHqgJlJGMM1D30SdR/sRbStYkJ6lYf1pFylyYxYEaNWpeOIhMzlc3UJ0ZJi6
         GB3YdeHUILmrcRxKOaMUFUHSGkLbRt8RwZPWEC5Q2F7zz+f6fL8qHoN2lGXtTQn/o1YT
         it55wLOiqPZ3L6mzqg+P0D/E1HJrKdimemibKlw+J5h1EBvbJ9b5sJNhXwBYAfEFblcs
         hSk6PycpbjN/uJ6L/vwpYcgmws6m2hZOTbMmnIpP0r+l3mOpzhZcq6B9ncNlYJQeNTVS
         JCOA==
X-Forwarded-Encrypted: i=1; AFNElJ8mg2Kt86qQDK8ClDFom8uAzn2JAvBfTTLKT5JItmFRZjanImKAOhFmE9ohb0nmM5wl525hWjr3oQ==@kvack.org
X-Gm-Message-State: AOJu0YwzuVRfev+G19p943+TOoNgBhv77Wfr644tHfL03iB54mkynxzL
	oeGAYX/6teBe87oSqzH+8B5KhwmrwQF3YA8OAYvl+cLWHYbLU4cec5pp
X-Gm-Gg: Acq92OHjDM2DPLdckGLGqdmq0PcBKAeHUV2xVKMOlPJh7Fsj0m5dIXLIlpv4hDEU0IY
	RFRKNaLYL4KKXfXKxpYcU5NopbptaeV5e52eHgA1ar7fKPZ6iwrB8SGVl7po9bLW7Y2RHW8x0OB
	eg+BDoemHDnuk+WEUyBUt5mRflunMzNRhsRoef3Ijdv+hG1nBDMhNIt6PCaimPcQoyGCZU0seyI
	JgDKtYUNSiQ5mAHkpD+VEVYjcAUBtUYw/jpBUypqCurV2zGzS1vJx3WXKZ/o7OG9ezOz7NVzMgo
	TravqoZ8AD1RPm+Tt86p0h1KjRbTy8QJQGWtYQrpl1Y5cI/CMrrSaprW5uB3n9vR3jnCmRiKevv
	L1ZioQcYQ31DkDOSPLiCP12B1BSgINg83CSDOyCSp3W46ge6om6WbYyJdqRiljuTt12NtPSRNGQ
	goRorbkBKCbPjRPQQ9iDXaybTD9FtGJ79DxkHIc4E6c5yarGftHePu/nfrr7f6msZgvU8m1mKiM
	g==
X-Received: by 2002:a05:6820:4b03:b0:69e:59ec:f70b with SMTP id 006d021491bc7-69e68c19e22mr2043956eaf.37.1780673770989;
        Fri, 05 Jun 2026 08:36:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e4620b0casm5398168eaf.3.2026.06.05.08.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:36:10 -0700 (PDT)
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
Subject: [PATCH 5/6 v3] mm/memcontrol: optimize memsw stock for cgroup v1
Date: Fri,  5 Jun 2026 08:36:01 -0700
Message-ID: <20260605153603.234296-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F1E4514000E
X-Stat-Signature: 93ocsxia17kgsetbic7m3oej9h7ccs7u
X-Rspam-User: 
X-HE-Tag: 1780673771-307904
X-HE-Meta: U2FsdGVkX1+l8/3UUZ3+LRGrmgHtn9PrrzoQAXZ+hZ8rmX4qn6mtBPGzy7XeccBwkQS2ft4FdwrqOl1TAa2UEBuqU93esEmibC8pNYifrJbkRQQzbHgQA1O3MZ4w1/zPI4OKcWSxdKjMtMD611HyML0FjL85jQ0ND6xkmnOZi0KM3JKZc7G8CWoaYopyBJ9CmvFFD8DgJKr+LnKpiVYdCNWMR52dtCcNYJOrfhhdknPZgSVwmy+sSyUuw3bavPR1IPg3qgid+ivwPvnffQsm2dSsuOnf7+UoTGcougvAI1B+ZDk0vz+0lHfDPULR+KwMFy3oOe4Ep/KRJlc88LmpaP7oVMcyF9x1ZZt5BZSJ0ed3ca5GXzhKZ3+E32K+/U8g72sjFsVusQy4xRaxnrVibwBQUVbzwuHwwAigDCbQfyIQg4Y8VPmxlXntxWHUO2mlYZbX9NOhD7p7IgZzViqTdTww4SEQdoI+nCKBAQvt7XqiF39svdOztcokDAVDlwpcY6PMkYkGhgVU51jJpj/R1eWoh3cHJSiX6SzD+Ujp+58GdHrnEPCwdUteX5ACgPJowby+rN+ZccskoHtqCAJCwtfRxgbnkXo3Ya2Ifb67TfvKsVhQMk9CcPRTBOvhvyCQ64y+uEnB5A/ACPxwgV0bbC3pnAw1A884nLp3yVwBQnNZ3gTqGHp1qI3IETiu6MX/EYu1BUhEWTNKLSdu0ABL5G85wDTo9KuWHigyPVP+Mi190QWLDiprCxv0Nl2HB5a+9L+NRCo+hbN0U05+gowjGPi6bAGsHn4M1WhVlSNftDKFuWcJ9D5KkE1IFHxdSEJWPgFc5hSGOKWnBGnaxgbnMGTdoEpfNoAnaQYrTyk9fG3IraxLGlH+fw25LDQh2gwNkhMUGvogJPXr+ooyso7h1nr4rkHtg4atfpeMUK2Xp0WkrjH43BSaX7jIr394P0wLA89NjDm9e9pTKQIGtST
 Prdzy10a
 1V0Sd2e9kyWRxL+ayIXiSu5AhAscJlJ43iZXlhenG6GWHsYaKrSCmqWUN3Y8IDDxl+Ts+3p/xrDu0dYlauMosgCKmEQZWhm/DW39mBBao4cr9vVRJ68pCLkHJ+FAytS9oPoIYoHKTKF0MjSkvol/6v0aDqoMg6ibMrzYmYHOm86MvAJU1l+2E4B4c2BCNZ68eKsSPPqwMZ1NYsqK1afw2e7m9PXMaxeYB2fAlj/nI4zxqmMtddG3+qfUBVdLr6AAcoEDq/lzo1mi74UwfH12VHtXge5HC1Xyu7ya6fw6hyF8JgiZDgnxwGsIcR8iOLWrB1QF9xVvhTPbFWj/tqBOYo/YtSvTfXjAbyG4gGTcTlc/wnDKM1N0EfF3MvVG4WFBKv3pfZ43/boLVWm73WlygNa+SBy9oyRJ/t/fbaXT8a81BaRPufgmXR++oQKCat1/SPPi6bGt2IlMBpFhRVIRVtBwDWM8SEQLAqK/86ZqEXRhpXsVTNqPwsv0bVg==
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
index 562ed9301f5a4..d0da2f842e2d4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2274,8 +2274,11 @@ static long drain_stock_on_cpu(void *arg)
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
@@ -2324,8 +2327,11 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
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
@@ -4237,6 +4243,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	/* failure is nonfatal, charges fall back to direct hierarchy */
 	page_counter_alloc_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+	if (do_memsw_account())
+		page_counter_alloc_stock(&memcg->memsw, MEMCG_CHARGE_BATCH);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -4299,6 +4307,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	lru_gen_offline_memcg(memcg);
 
 	page_counter_disable_stock(&memcg->memory);
+	if (do_memsw_account())
+		page_counter_disable_stock(&memcg->memsw);
 	drain_all_stock(memcg);
 
 	mem_cgroup_private_id_put(memcg, 1);
-- 
2.53.0-Meta


