Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF7B606A329
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SuW3FrNe
Received: by kanga.kvack.org (Postfix)
	id 733396B060F; Wed, 21 Oct 2026 02:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3336B0610; Wed, 21 Oct 2026 02:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB266B0611; Wed, 21 Oct 2026 02:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE906B060F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:03:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A229B1A043D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:58 +0000 (UTC)
X-FDA: 85345592556.14.BB158A0
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id CEF631C0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SuW3FrNe;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeGd0iaaX9wfTd3kx7wQwl7QfCj0iIAuoGLe+aoH7yI=;
	b=1UdB/po843iNkpg8tWIWQwIHogitqvQL4ht45u43500FafHDbUbPRDmLqCpvsknm8qsoPU
	AcGDTA4GXOkV1p66LZuW372tjxCuqHyv3e5mDJG4wRoL2Mjpcyno3fbLC/WWOlcQSZXSiJ
	Ggj/ZiUWdm82j7kvdk4b9CYQRpLYw1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562636;
	b=59ZTj+4Gt2g6n4fdsrtiWFcgbMaOyV3IOYq1Fyv8nrJ6u2tLZgvO9uLkbxyaMIax1R0HCi
	WHs2puNFZWUYgzJ+tZNmnbV1JOfuLSNNE/Oc2dQWRP5ckr7bi1dSqtmF2oOL4AKuS7bM01
	k8skT6T7mLm4f4aTKxTvgYz4Arvw3zY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SuW3FrNe;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b10d24345dso3458577b3.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562636; x=1793167436; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FeGd0iaaX9wfTd3kx7wQwl7QfCj0iIAuoGLe+aoH7yI=;
        b=SuW3FrNeCxJILcbyXzaQ+jYm/FwfeI5IPt73+PIGl2qm6+yof06xIQ8zSAyB2B10Kl
         anx4Xi7J6yMCBJzAkP2YOzgji+IruKgjoBthb4x0s6G5N+1Peoq082f4Qs+d6iV+GTNT
         MEOjAomdnS+nsLYGil2zBA+12xRhoHNd3PzTQPd/+F7BJ4b8MWg9f9yKf01/Y5zPBIXj
         c39JugvX+LJtUScUvZRixzGSc012WgNBRk0zgFCKbsBNPmxM+luix9yMBen+iQvfgy88
         ctCW4RPKwqsaLnT3fODghbcnH4CNZBxEuoeAWGxuXhddNEOTQiLxaC8tGkwlq+JGb2y2
         5fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562636; x=1793167436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FeGd0iaaX9wfTd3kx7wQwl7QfCj0iIAuoGLe+aoH7yI=;
        b=LA1rOxQJXvoRAjWu30KW3TH10mQmP2Jvw1mSXbo7XGca/puGWG9yMpPb7He9DoQHvY
         M02eATK7vLZ1IkttljXTjSQ0UimNCrQcgZoveoAzJQLQqKI1F1WqpQjb9Ykj17VU3MOb
         zztyT/Jw6VtWsuyyeeGhD/pktqYCoKgKcjxSpFVUVdy6KWbAjBNYuzabu4TQOd790yBV
         gnWBDLPgNfzgfM9MClz9tP1QnHuVrhy2oC0f2lAVv524Sfc5tlSVe28QGgSkLxblha1Z
         8OtKjPAnoobZ1Mbr4PzOU9TbQ+5vBmVRKIWfQS79SiGhqpx3vA4J7INmKzuKpkwPzLJF
         zkVg==
X-Forwarded-Encrypted: i=1; AKwUvByYzwhE5YeNP05vcJ8N+51LxaTxsJUtrFy4BE44YH8GSjOjgRVZGcv/wRNl1b0fshy55gwgCJ/hLQ==@kvack.org
X-Gm-Message-State: AFq9FYJ+5OmTCVWFWATkl8dI6jGQMj4i7JFpmZYY/gSPRINlRAi5A3io
	TdSqbzzHQtXAkIopt4pG5EftUIcN0LDzNCkgZMsDsrKQg9/p8OPuKxNs
X-Gm-Gg: AYBFou3FMZwDlOhz6gXpRD0KCpK2urajfW/M/tTCgrFlv/DOCnoLj60aM8bJ0cISFfV
	nGiQBLC5ebIPcpmHWt3RzGNW/BSXTldjE3XxIcNLzIzrICpqe7lMBAeKGG5jQF9ffGksitDTSB8
	OSogUToAAyGuZ22Yf+OPV0Pcrttk2feEUuLwzmEuRCeEQNIkwWgJxnzp1QkxTrZtlRmGVBqTBih
	Qy49PAR00QSNBqiJOjF8zMLCd9/xt4+6jY7JGBaJPqp28Uo8Z7D/i60OoA/kLU+91dAGrSFChQa
	czkQkZbyk0T0UZudcRQX3CRO7oKceVTulpTOTHbU4Qw/aWW8epsfxOP32U+ZRBtJi3nRl9saK3Z
	KfuOnRql55AxTgjqlknf+FlhQb+lrzH41ZoVQI2kkxso09mW1NUGfC1/PMtg5rtOfRYl0IKoZpx
	4EsPyM33Qw91rw8IMwBwsZwHxQXcWTRlphUut/H2k8Py7wqE37ZxMTKQ4Ki8BN5pjCw37YnWCcG
	RhFcrM0UNuTEi2KW6N8/OlAtVYRBRoRG17KrdwQNlSU/C3b
X-Received: by 2002:a05:690c:660a:b0:8b0:d3c7:52e9 with SMTP id 00721157ae682-8b13400d0d0mr4996737b3.36.1792562635989;
        Tue, 20 Oct 2026 23:03:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300eb0ecsm7200107b3.26.2026.10.20.23.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:54 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 09/12] mm, swap: add debugfs counters for vswap
Date: Tue, 20 Oct 2026 23:03:20 -0700
Message-ID: <20261021060323.553433-10-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEF631C0009
X-Stat-Signature: yy9y55q6kbjqabbqqjuu89hd55syoz54
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792562636-910171
X-HE-Meta: U2FsdGVkX1+LPZeM9btNJLrmMVPm6d+8a4iVKweMieIlrd/J8CzklanvA/j7SJcy8XBn76BkSt52fEkQ5SdsFfo3Hrh9K8XhHQXSp+0WcFYd5sfJYaX6T99yiufvQVPs0KU7fxgo9QL0OT2nu++YkCRJIaZ7mitj71rRV1w6MDxay37QhpxsB5ScpNr5FXmd5wIEbHh6IfcgE8XZ74ZErXtwUAW8qwiaRp5CAbhb+siPx3A45tcORIynHoWsUE/T3AX39P7cw4a2MxERQPYeDmr1OTIDCfe8co2q0MHG80wnoOV4Qtir201toofOFKsSSjKk/QWQY0/lJY5ctGRgkLntYljaUJU2F0jShyMRfFwoyPOxczSnBt3ngkM3m1cjhlrgghXXxasgO9YiiX/2fuS7WUg/L+gd4NYiPJ1aPuS2+43mRrOTQbf9UJEjtfI9b5wkVrab6z8vr83TjpBbIb1h6do+w/EU4njmhkqZp4atCu6HB1AF14OhDBuyzZEB05gT/bhktgJU+14OUxAftrTW7NOkcRLbyaC+KjIgWVUcpqHp0IUvTdIQqFZnhoRByjmtH/xvGyf/upZ1/of5QbYHPco1uuhDFPxsSfNxIdMMu6QCaNkleG4yar2bX/1wPnrD0zPTlgB+nld0pAP0w5svbkloR6PFlfMFdi8XEs61o6GjJ68vUrf3piEZlXST/K7VQgO78Iv55xiE/PGuQlifwtyfCb+YXuNdZEIU1AvaepC2Aeyv3z0XhtM0N3C/i1CiaDMx73TNQVfsFVVOPlB06fvh93s4JK+w86scpPhd0jFOct3aDlpXEp3uzMjFsiZDwOSF52m40p8OnxooAD/nqv3XaedGuMV2sRwOm4PE/S6U4+axT3ezT+B22K5BjtGoSvprPs9B5KbbZcODAaT/a43+/z5LbAXdwideitKrvGMWdHW2w+bm/Vl8NxqP9+uZ1ttiux9nGT9ApiL
 VkiJwMlG
 MF9yyPrkoMYL7vHlpNgpyMC4uEfwk+7YjhsDsBPNstih+YHhiyzFaepDh1VM+ih9wvd3snHONTdhdryAs/jAp4hTNMxiokiXFsAUb36LoGckEMRehMK2jFmG3HZQTR6hfyoYdGvbOwQ5J29RQL5/JSTl0QWVC7REm5evakgzKgzHXK+0Ro7QXimWklFUOYsREnwYGG1lWDtkyZ9dsg+o4RDvYYMTh3/D1nMNxGszQu5BPuwqxo7JhQD1Uticd2QAq5FRKSWV2MUlz2c2KSARyQIHk/rucwRbU7fhGUT6tg9jCXuVY5DE8UAvS5PxPWUBivl82OPLjltzWLMJJLFQuP53/Zf06F1TFXQehA7BShC8Yu76KfVGYkSQoYcCHkPfn4UPjApTTr0UbTsrirerdVzDWY02QoiLlZvoa10DFEO706yNb8h6AgoQfZtgEVK9JJy+wMhIGvG0CgzzYdCrQrMtjZTLHoXLb0MRh0xTnmUZQD9w5vBvp2iebbF899pvBvTHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add /sys/kernel/debug/vswap/ with two counters:

* used: virtual swap slots (pages) currently allocated
* alloc_reject: cumulative pages whose vswap slot allocation failed

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 341077fee23b..12cd5caeaaf2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -146,6 +147,7 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_long_t vswap_alloc_reject = ATOMIC_LONG_INIT(0);
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off);
 static void vswap_clear_cache_only(struct swap_cluster_info *ci,
@@ -1997,6 +1999,7 @@ static bool vswap_alloc(struct folio *folio)
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_long_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 
@@ -4874,9 +4877,25 @@ early_param("vswap", early_vswap);
 /* vswap does no IO on its own. */
 static const struct swap_ops vswap_ops = { };
 
+static int vswap_used_get(void *data, u64 *val)
+{
+	*val = swap_usage_in_pages(vswap_si);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(vswap_used_fops, vswap_used_get, NULL, "%llu\n");
+
+static int vswap_alloc_reject_get(void *data, u64 *val)
+{
+	*val = atomic_long_read(&vswap_alloc_reject);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(vswap_alloc_reject_fops, vswap_alloc_reject_get, NULL,
+			 "%llu\n");
+
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
+	struct dentry *root;
 	unsigned long maxpages;
 	int err;
 
@@ -4926,6 +4945,12 @@ static int __init vswap_init(void)
 	mutex_unlock(&swapon_mutex);
 
 	vswap_si = si;
+
+	root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_file("used", 0444, root, NULL, &vswap_used_fops);
+	debugfs_create_file("alloc_reject", 0444, root, NULL,
+			    &vswap_alloc_reject_fops);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 
 	/* Last: everything above must be visible before routing starts. */
-- 
2.53.0-Meta


