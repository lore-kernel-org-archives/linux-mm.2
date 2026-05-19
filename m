Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD81CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122FC6B0005; Tue, 19 May 2026 12:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA966B0092; Tue, 19 May 2026 12:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010316B0095; Tue, 19 May 2026 12:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5C2E6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:01:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 874CA8F61B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:01:50 +0000 (UTC)
X-FDA: 84784635180.26.2CE72CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DDB7180014
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:01:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=STwqmIGX;
	spf=pass (imf06.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779206508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cipZ17JT05Ge5l1VfUm/NtrMByICdVG7S5/ux07qG+4=;
	b=t+ibfanXGBysQ0PX0JKPtVEaPzhIZuEN++bgKi7hfRr5uwAoK48JkxHPGKohzPaDrUs/nW
	uDjffKTlz7wbr5kf14v7uyEFjKJQDdNpFqZEbYYsqTtCphIIexnWdXv4YafgvJcCbMrOC2
	fiwi/tDaVgnrPWMjh1izLw/HjI5nDcw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=STwqmIGX;
	spf=pass (imf06.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779206508; a=rsa-sha256;
	cv=none;
	b=KCjXqu5EAzfRy8u4VxgWvo69oeHvj+NRbJFQ/+V0EvCPI1xoFuAxAiGhWG68a3HbSet3RR
	w4Xgl7kZUHLTSDtcfob1EyG+LCaliw7KFPxFzntsc61he7BrCqO8Xogf30v2XpF4aE8bFC
	ZtanLYZeNRsecPI/q7/ar6ZJDgeOFvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779206507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cipZ17JT05Ge5l1VfUm/NtrMByICdVG7S5/ux07qG+4=;
	b=STwqmIGXEUy3uBVn9+OnBz1EUMuEEhF8LT5ArylWqDiW371+ecPXoFbZ1vELoBiRHZiciW
	obG9CkSYrLgKCbWDk7+kV+RKFxZ+PJ+wca10N612P7HfEoqbP4U5ubumLzwnZtqbutzqfV
	PDsFei0RM5+/tjd3M4UR7Bhq5ntjDIA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-VEWpUfEsPZyM7EM4kRR7_A-1; Tue, 19 May 2026 12:01:46 -0400
X-MC-Unique: VEWpUfEsPZyM7EM4kRR7_A-1
X-Mimecast-MFC-AGG-ID: VEWpUfEsPZyM7EM4kRR7_A_1779206506
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-90fc64a47edso649102285a.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:01:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779206506; x=1779811306;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cipZ17JT05Ge5l1VfUm/NtrMByICdVG7S5/ux07qG+4=;
        b=dLaeB93m7+aq+TOmTibpZmTOQ8dYgZWjbjgzpFoGxg5N6FxMzywV4f9RzSChp8ITzR
         1aDWwFg9Tt7A62L16kt5m7W0WeY49tVEfm7CdHBuU/NymjlRjCBSFIpfSjWRLIKC+/P9
         7zBxvlx+OKMfp33BjQBut3r1Kw64MyNd+tjMQxVxYvT7g3gx9tz/U509mzvnp0th/afx
         gjPu27Wf0fchrC8AYythhcxUtwTj84Jz9A3S7qhN8/JHxdg4mekjgIVAqa4zDxWFPT4C
         hN74g7nJxtFfzmn2P960YdsJ2qlOxvuFIh5mmiO854YpfT7t0sfzgVbXnOWIPCKJmZCc
         J10g==
X-Forwarded-Encrypted: i=1; AFNElJ+jdAw/aS5OzwblRIJxbREYnH6xR7jsaF3iq9mK3gWSukV6dvvEWgY2N9V63BKOR8j36bdGTPKX+Q==@kvack.org
X-Gm-Message-State: AOJu0Yyh82i/eaC9H25hPk3hE3SWxMA03e32ZFTRSqbHX0jH+1sGxrlD
	BUT668wdKxNMeuxFd/WLOIvKblX4o1njNSZvJjPtFT8ICEPrv9CPKUdDff4Ru4kCfdniUW/UeiL
	ql3uFtydqEL/NNxcwt5IgXpj7cFWP5vOE503FVnmxaCedck86mT4X
X-Gm-Gg: Acq92OHytYAJ0zlhDowFzr2A0A2B56RuVZYb2KIVzpdE7BjmPPNwzEHLVw38ZJgogFj
	SCnNHQsZnizqv2cJnzPThypAVa91YDiF+3qKauLEJI+w2kuadtVh9UACaTSD4Q/vd3a7UUxk3NB
	ctOgaHqXwnSpo3ESYbzKQphDjN9DtqrIjxsK6WMuQk7cjsWVNzl3NuNFrRYgYzW3tFCoFyIha4E
	DwF+zYCGs16QSogwhvQpu7VGIdCsyGBK7KkkP4QpOHXazMbf5sITokBUDsdfmR4t6KEl0DaTYbc
	tXx8ZRkP13XkYhotVDITCO9+tXL3YVepVGzpsYPvvmIhZy+3ixidhCRaFoGBp4vhMU1ktscR+re
	YLj7cMLsVrCoX0XIhaTC0YfqlIx4AVWvTxCdTxm6gGayzrkUx2Td3PhSyNUHdQNPN1w==
X-Received: by 2002:a05:620a:7116:b0:90a:708c:e6d9 with SMTP id af79cd13be357-911d10425e9mr3114785285a.56.1779206463337;
        Tue, 19 May 2026 09:01:03 -0700 (PDT)
X-Received: by 2002:a05:620a:7116:b0:90a:708c:e6d9 with SMTP id af79cd13be357-911d10425e9mr3114014285a.56.1779206432003;
        Tue, 19 May 2026 09:00:32 -0700 (PDT)
Received: from localhost (pool-100-17-21-205.bstnma.fios.verizon.net. [100.17.21.205])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bd62e233sm1876151185a.45.2026.05.19.09.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 09:00:31 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Tue, 19 May 2026 11:59:01 -0400
Subject: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
MIME-Version: 1.0
Message-Id: <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
In-Reply-To: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org, 
 Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ob_YiqYbMwvW4dhu8sDRPNQqSAigTd-yPCP22pb5YWc_1779206506
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2DDB7180014
X-Stat-Signature: 39t1c3fr5rpmaysaxggiwf5f837w53mn
X-HE-Tag: 1779206507-983267
X-HE-Meta: U2FsdGVkX181fZQkpISbBSwFNYJL7fo+1A4gJJPi0gAL52mevyalqrawMP4odjCkFXvp76FdrNAaqQmH9Sstn5oELaDG59vUOSweUwv9rCyjAm6/I7a5LfVQSFHg9NCKwrM2VoB8Wk3iT9UvRgE2qiUH6M8XcabmwcLy5h63ID28Z04RV0H2W25/mgcnsSAfuzBxx48iPkU+rGp+EgMTxFEhLvpwKfuSrT7EqdE5Qq+B7H30KAIei+oEvvl/cnw2UvKUyWivz33B81PF6t/UGEwRTsKGkVDAxPbhGGo1nF4LxSOy/M7Xd2iiMe847B8I5s+eyabBaA0SpnyuyBebQYphERbyuXhaTBvYdxK3BeWoKZLmAoweQE5b/33OE9BNBPZsvTV8c0CI9d6COkHenDBZmxvnSCrfA+/8sLAy34U2XeF2Heb5vNQn4XDcZuoroGq4xy0jj8g6zQgmXDa7bXv5KPlUSbtReyUo1Grz7RRtwKv24gSLgadAqUdGbNNSEUgMUTfsEUMZmiN/pRe4WMYNJ5I/RKKpVl9D+i+lshyyAm9LfAeyLUA6Rwh3ZwXwWFxuR5lvHTXJexYwQBGZ8LS+h6qXmgF5Ib+DGMHiS+N44kGhqCAAFREJDHB/mRhA7dOe6dw6Fl7Ww/F/bwOvmxhB+ShefPQuKumsHjG4d6qRYnxjboB4iF6AyUV/8bXDKg3wS0N6FSEDJaxJ2y2wkp8/6FG/kH50hjzRaOQx3sFUL72o/9FIUoeeD6d3ed6ntbb83t3+uyceUya4RwA0ZwhQwIEnAASFw6dwJ1QgukHh+NNBy4De06kZ9fkEY2bC//TEtViWzlh+vpXR/83GbJUN+ENeY2dGVGU7O68ythyBOzlu2h16RzHt/70md+KHSdjlFnE4+97pgDtXGEECfwkSDeIE5GEWIA6t1ojQ3OTrvRLZcEAT3fh6uNerxXigq057BOt8OeRRrzuX7Oy
 kEi2Ei8J
 22dorD7uCHAj2O+4PWcc1uhkuuAvWkyJro1YS+57GT35dDoMQEShPIGfd8rReXRjn3/injco38/D8cB1axrh+QB0+IIHzHh/ML7ehf3mviKvDC5SVbtW8jjOBA5vXII2LVnmoOPbu02ntNRqHHuZGSYmCa4ozuo39oWSPwPlsskN/fZ9L1heY0mM4kvfIUoYI92uPgny9lH+pXqwpppZvNHBRKEQuIY13vab4Vr2hUy9Pe/7/jPZpfU7qlcN0yPZPP2D/Dz7SaiYCn+OhL1n20en3rP+d5cXftMN0kAcUtroKPXArNHBzQndWdWntSiVwrAipyheVjGYFCDqcltoNxkfjhuUgDijVUuEeu7UzRP7KzjIEfSW+bPHujX6kBFV1zDfDOS74D/kFGEtUEJFeyGEBIp4lJrKJ8Z1tCfLtj53lbqMFdHGD3ow3djPz8UOMrvxWMsfo7um3obVOY0RObX6g1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mem_cgroup_dmem_charge() and mem_cgroup_dmem_uncharge() to allow
dmem pool allocations to optionally be double-charged against the memory
controller. Take the struct cgroup from the dmem pool's css as there is
no convenient object exported to represent these allocations. These will
resolve the effective memory css from that cgroup and perform the
charge.

Introduce a MEMCG_DMEM stat counter to memory.stat to make the cgroup's
dmem charge visible.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 include/linux/memcontrol.h | 16 ++++++++++++
 mm/memcontrol.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b45748b2acee6d7f43da325eb50c1..8e1d49b87fb64e6114f3eb920293e14920290fe7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -39,6 +39,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMEM,
 	MEMCG_NR_STAT,
 };
 
@@ -1872,6 +1873,21 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 }
 #endif
 
+#if defined(CONFIG_MEMCG) && defined(CONFIG_CGROUP_DMEM)
+bool mem_cgroup_dmem_charge(struct cgroup *cgrp, unsigned int nr_pages,
+			    gfp_t gfp_mask);
+void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages);
+#else
+static inline bool mem_cgroup_dmem_charge(struct cgroup *cgrp,
+					  unsigned int nr_pages, gfp_t gfp_mask)
+{
+	return true;
+}
+static inline void mem_cgroup_dmem_uncharge(struct cgroup *cgrp,
+					    unsigned int nr_pages)
+{
+}
+#endif
 
 /* Cgroup v1-related declarations */
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c03d4787d466803db49cdaa90e6d6ba426b7afe2..91a7ac16b6eac2d6c3700b6885a068bf8b640706 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -433,6 +433,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMEM,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1606,6 +1607,9 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
+#ifdef CONFIG_CGROUP_DMEM
+	{ "dmem",			MEMCG_DMEM		},
+#endif
 };
 
 /* The actual unit of the state item, not the same as the output unit */
@@ -5909,6 +5913,67 @@ static struct cftype zswap_files[] = {
 };
 #endif /* CONFIG_ZSWAP */
 
+#ifdef CONFIG_CGROUP_DMEM
+/**
+ * mem_cgroup_dmem_charge - charge memcg for a dmem pool allocation
+ * @cgrp: cgroup of the dmem pool
+ * @nr_pages: number of pages to charge
+ * @gfp_mask: reclaim mode
+ *
+ * Charges @nr_pages to @memcg. Returns %true if the charge fit within
+ * @memcg's configured limit, %false if it doesn't.
+ */
+bool mem_cgroup_dmem_charge(struct cgroup *cgrp, unsigned int nr_pages,
+			    gfp_t gfp_mask)
+{
+	struct cgroup_subsys_state *mem_css;
+	struct mem_cgroup *memcg;
+
+	/* CGROUP_DMEM and MEMCG guarantees this cannot be NULL. */
+	mem_css = cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
+
+	/* Use the memcg, if any, of the dmem cgroup. */
+	memcg = mem_cgroup_from_css(mem_css);
+	if (!memcg || mem_cgroup_is_root(memcg)) {
+		css_put(mem_css);
+		return false;
+	}
+
+	if (try_charge_memcg(memcg, gfp_mask, nr_pages)) {
+		css_put(mem_css);
+		return false;
+	}
+
+	mod_memcg_state(memcg, MEMCG_DMEM, nr_pages);
+	css_put(mem_css);
+	return true;
+}
+
+/**
+ * mem_cgroup_dmem_uncharge - uncharge memcg from a dmem pool allocation
+ * @cgrp: cgroup of the dmem pool
+ * @nr_pages: number of pages to uncharge
+ */
+void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages)
+{
+	struct cgroup_subsys_state *mem_css;
+	struct mem_cgroup *memcg;
+
+	/* CGROUP_DMEM and MEMCG guarantees this cannot be NULL. */
+	mem_css = cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
+
+	memcg = mem_cgroup_from_css(mem_css);
+	if (!memcg || mem_cgroup_is_root(memcg)) {
+		css_put(mem_css);
+		return;
+	}
+
+	mod_memcg_state(memcg, MEMCG_DMEM, -nr_pages);
+	refill_stock(memcg, nr_pages);
+	css_put(mem_css);
+}
+#endif /* CONFIG_CGROUP_DMEM */
+
 static int __init mem_cgroup_swap_init(void)
 {
 	if (mem_cgroup_disabled())

-- 
2.52.0


