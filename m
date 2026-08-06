Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C62AC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445586B009E; Thu,  6 Aug 2026 14:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6026B009F; Thu,  6 Aug 2026 14:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B676B00A0; Thu,  6 Aug 2026 14:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0235B6B009E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:43:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FB71C01D4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:13 +0000 (UTC)
X-FDA: 85071717066.02.B21275C
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id A4B261C0009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RsSlasAm;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786041791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJDCmTvRD2vNfT2YGrgT7EosXDcYWyreOqvvzwLRIg0=;
	b=TGi7fjeFS6eFv567XKkIpll8KaCrOdE2wo+8SK6ui8RM0hNAfn3tD8KErce//NIJFq5n8U
	KV3NWA8+cH4KjMATo1BbCi3lkg3jV+vlwIUfsToWXpPrNqONnX8VSPdYu++KqBvZCYU0U3
	A1vNar55MdJ0VeLNFx517YfpyPLSwkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786041791;
	b=4jLkuatejX9NIGy1Lcr1fYjMKcc8nBejDjPSynBlxnigfLRE2iVy5TjziTIw0AcgaD0LsW
	CVmTrdSQ9cRqd6x4fMejhynhT21Q1x826WS0l99jGgxGF6xatHf06FMoULTtRVwqKsU8UV
	/KdMIuKlOu2WG750d9NeDHkPtlX7qNA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RsSlasAm;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9f69ee6f4so2310516a34.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041791; x=1786646591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJDCmTvRD2vNfT2YGrgT7EosXDcYWyreOqvvzwLRIg0=;
        b=RsSlasAm+raopJvnhuncPvul2N0UsihcmZKhVB8NiTi4l0mqDF0ewnw7qVEALFLHPR
         8R/En/VTzTJaFM0si7mEqNEIXd+IJQaG1EjriNyvL2lZoTwbfn4IdCdcQ6yzQ/H2Ufsg
         cVk8NFAevKmo1bRXK0G2sCNBhv/A1DnHPbsKoKVkSgWP1mNcZiJ32m+AXhZyuk4UfhKO
         USGgnkdH4Xs5COdKzZpQ313ON80nw/Zbcgbv2U25fcqCRXLo/uvaATbB9PNuQmcIKI01
         /i18CxieuJ9SyJPlG9iEjGbLHQnp6dzBE1R6KquwCBZ5pOfa0riXJDDwKhESiamGdg2B
         Zc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041791; x=1786646591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XJDCmTvRD2vNfT2YGrgT7EosXDcYWyreOqvvzwLRIg0=;
        b=rHxZMAw6GxHsK/JEnWrvyXWoRqWAK7FUHj21BvACNIH6rSHQABsxGLy2dv88JUTTpb
         XP7CQ58IlflQ+3jNk7dozFAt+gGUa3FeTLe/uqwt3voX1YIFNSdgz3ebr6XYNQhHHBj6
         4mA529AG2J9COaWfgj/Xu3p3iv14IbaDrDCCWpqxZZwTZliOIz45FlSo7zGMXowZqg2z
         XHhdzv2yZCn9ZEu2WQd3+TuaNsoCETDup6mMjL/UAg/fmUQPE/2H1tqGbAEmmE1dpDBd
         k9C/T4NaV2D6zLkcVtdHKnERIA3YerLRtli3zd2Bt8SbbXAnYU1zy3ec/htz0lS4Ai33
         AwqQ==
X-Forwarded-Encrypted: i=1; AHgh+RpngIl0nTTfiVB5fKO4GmXsj4Mx5AOYnsO2pWOtYdFa4WOHcF0fehBu6Qebr9iV7sQYNh5+NJjMZA==@kvack.org
X-Gm-Message-State: AOJu0YwstGrbt+YXhFxnebNl2vXgn9E0DheunIiZT3APtFw8is2q/iZA
	BvuErUTSfxHHhTa85tZdMqynhwgKfQ1ozK/1aJFSy9YI5ujq6XRau7ZRtyKz7H/3
X-Gm-Gg: AR+sD12xgJUvs3o2EC/JzkSi4gpbijblwZ++CDqfZGthdDcmQC1VUBU+ULwwcH+kMvo
	QW+B/1u8EXVjdeIKtddkUGBWtfRJjvIdBIz9wB0e9mVYbjVnrb9dRr/ddYokeynaVQg8QMcvgyO
	QJeeVLm1ICVIaugNOBpWBSFcYKoM8K2ZlXLRj/UuwOlr5VdgYWhRW6m/6yn5/Gw2ZFOKrN8+u97
	kxfEj07GUXLvcCE01asQ4tWL8hH9D7Pr7+2O0K4td7vbL+QLh3qZrnwQa16d6A9Mr6Yo07eA8AG
	o0PbsNetQkBMau34xWduNFkFvHgrXuM+0UJVQU+/dFqZ3zUQxeSVes0hrMQA1NYB4oY8uCKycWd
	SvTdN6Oy3teOUpgk9WYrVCCBkglmWbVZaJ61fCzss/Utvqdom3oKh7xkD+gxWpdclVpXmGccb6g
	7Lho9+jl3/SYANku6YlFrxvOhc1t9Wnq6qPWx2+gBl3B3IPg/g1c9K5QLkq3IBcc7U+QzWjj7XJ
	d8EhAZXjriyFQTxDXCZ1mo=
X-Received: by 2002:a05:6830:6404:b0:7e9:ead3:4449 with SMTP id 46e09a7af769-7f1e5d0f423mr10084761a34.6.1786041790716;
        Thu, 06 Aug 2026 11:43:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f1df5a4f9bsm5051028a34.23.2026.08.06.11.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:10 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
Date: Thu,  6 Aug 2026 11:42:52 -0700
Message-ID: <20260806184254.3790858-10-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4B261C0009
X-Rspam-User: 
X-Stat-Signature: kn7miopqq4rsse4i3dt6fo1cuiymizrw
X-HE-Tag: 1786041791-271296
X-HE-Meta: U2FsdGVkX1/eniU3dsT0XZQGq1BLEByVqnNnrDISoc+WUfAb2EKWe0kqivYjn6oViqtDDmegAUGjeISywfjUdMlB+M7DGBqvBAfB4A9pWdk/D4fKdTgoIdWefzO0PPPp36vqvI3rY5zUkPJlHAzAYyE7BcKerBd55JL5k2lCTnc/8Oj3l77FWBc0sdYuqX58yLe67ej3vtBRJ1n4OffJ2XTowP6DScBycWi1XsvpGdLz52fr7qgpt4Y7FK1djx7o4iFr7Lq9tFZU6vStREUpSab2Fpms0PYKehSdy83Xie4ac9FkRfVX4ZDVC8KAffjr9MpF0Or7lpRD8prmiEqpovOSJl+/HwJKDf4n07lu1NN6Zz9K0kR/bpVPaPreQ5fa61Bi6VpKfsGgvurpQhes9lCXpVE2ZUjHMPgn5N2TG/TVY9QXuXFdPSwu5Z7P6s1BHbB3dzvx9sEKgRHlzJpp5b/bfXj5M+jKalCdhlOoeC2p6AoF9A2PqUojQc6UwzncJMkP+xcdUTJcPb62Od8HC3wS+dABaRjReCy9y7fGbDPlr3KOSucNOkr1Ch3fHwpKnHEWXK75Xmg4fOU1QbOENR5FTDHrXGQehWj6Qiz41CeLu4hl2oXN9EpQBxeQyHqQF+ly0QVNrSk1IY9VzN4AFsjG559Hhz8qDL+XZMID5hSg2PUdqPM4be3wHACsDrR1BSykdRwyduGOOPTpokSy4lrQ6mSPafv1mQLefMjEbVrUJk4v0D7D6km2abx+RrcbZo1dH6VzDvouGVDQjdXNFeBuv22c2/eUSmNbEGBlvEz64eA2Vc6J3jyKv0JL9r+TDeIOoerOyNDIFq6i4b9nHhncmC2ab6Mrw1wxi/dGZxOwAQz64JeU7CNHbUEDs7R/QAOuSBq5St3T/e+SyZIuh2NcrG9cDMhGwH5JfdIQuqPLFSHyDfPaP3toUcooTt8BdddmBBxAjERWX6iM1Ra
 LGk2Zi/C
 Wl5SPV2EN5NtwsaPGJolP+MLd3mKR1lJHeoP2S/cTD+A3N1JDhJIS+LrfTvIGtji8tDW6RgwET36Pmog0X5kjs2UeKImZEYumMlMdtp6zEfXp/cg9xcUxoDVwi2Om9eOtkXVWiAu2WywuYZ7jVD2YgvrcP+uIJgbih0o62UIDqF0PdHHY4FQNkfX1sxA4Dz7J4IQlsDje/beiGzqqiPGnF/wBXPC/kVbFRP9yUchtr4HvqgbCcm/Bfl1EdJGP/Unc7+8F1qc4txq+TOWrhngjpQG3L2wDlfURDlvaVD89M7d0Kc/tAiPMV3wM79dgm3DR5IyF3X2u7MPI/lV0mlx/zcr1sN5/NDMpL5YFRDeRdhMrgYA1iTHby6drrlxvYcqEbdtDfxdv2y9QE11wJVHababA4GiPIy71IjsFvKGBfp1TcasrQf1pxQSBZ5KTY6rsP+g9QPzJwhTSro4aNu34S4Qxog2kXL3BBFLtNLmrnXHdzAbNPJhPuysb/kbnJCEgjgrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add /sys/kernel/debug/vswap/ with two counters:

* used: virtual swap slots (pages) currently allocated
* alloc_reject: cumulative pages that failed to get a vswap slot

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1a2d9d9625fc..b4d7af21ca1c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -133,6 +134,9 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_t __maybe_unused vswap_used = ATOMIC_INIT(0);
+static atomic_t __maybe_unused vswap_alloc_reject = ATOMIC_INIT(0);
+
 #ifdef CONFIG_VSWAP
 static int sysctl_vswap_enabled = IS_ENABLED(CONFIG_VSWAP_DEFAULT_ON);
 
@@ -2056,11 +2060,13 @@ static bool vswap_alloc(struct folio *folio)
 	if (folio_test_swapcache(folio)) {
 		/* alloc_swap_scan_cluster updated percpu offset already */
 		local_unlock(&percpu_vswap_cluster.lock);
+		atomic_add(folio_nr_pages(folio), &vswap_used);
 		return true;
 	}
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 #endif
@@ -2665,8 +2671,10 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (is_vswap)
+	if (is_vswap) {
 		__vswap_release_backing(ci, ci_start, nr_pages);
+		atomic_sub(nr_pages, &vswap_used);
+	}
 
 	ci->count -= nr_pages;
 	do {
@@ -4862,6 +4870,7 @@ static const struct ctl_table vswap_sysctls[] = {
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
+	struct dentry *root;
 	unsigned long maxpages;
 	int err;
 
@@ -4896,6 +4905,10 @@ static int __init vswap_init(void)
 
 	register_sysctl_init("vm", vswap_sysctls);
 
+	root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_atomic_t("used", 0444, root, &vswap_used);
+	debugfs_create_atomic_t("alloc_reject", 0444, root, &vswap_alloc_reject);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 	return 0;
 
-- 
2.53.0-Meta


