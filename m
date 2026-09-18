Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19841C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2786B009F; Fri, 18 Sep 2026 14:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C486B00A0; Fri, 18 Sep 2026 14:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39AD6B00A1; Fri, 18 Sep 2026 14:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1B256B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:03:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 577C5160774
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:03:03 +0000 (UTC)
X-FDA: 85227654246.17.72673EC
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf04.hostedemail.com (Postfix) with ESMTP id 54FFF40018
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:03:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I6h0dpmv;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754581;
	b=rjt8vHzFZhyd54kUc3OeJmU1uK3BbvPIlkJ0TO/JP4/7fuEm2XYaJAh2t4dHbi7Z1nK8Re
	AXZl7xadvpl8j0LC+5TVqsiKGbQYXVl/nRHBXtyJAHoqmLAj6XW/Et+D2eSQW7F7jQULJC
	exQPV5UzDJ3qksPonfNarF/IqwBL2sM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I6h0dpmv;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leUxoZNbrIHhJwMkVXew1sBjFqiId1Gr67nxTcdiA8U=;
	b=5d8Q0oywZiX6XaEzvkwOwUiIWul73nTOXJ3bLxT4ogvn3xKeyEi8x64DLqv9yh/QzplM71
	+LFepT9VxXHiVoBK4yYFe0yEPUCPFWUJ1hf/7PNGcAq2RBRwVEEj+IMUHqIQ0gTPE6iluI
	VWsw9reQLVprR+LqwYxj0p2UKyKZ7kw=
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-7f4f0d1778eso590233a34.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754580; x=1790359380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=leUxoZNbrIHhJwMkVXew1sBjFqiId1Gr67nxTcdiA8U=;
        b=I6h0dpmvF4Ulvpz/EA25YY1vuyOm75WMSauWHa2e2KoLzxya1L/5yI9X5nWoyQATSe
         DW1KiB88ArCfbBEy2ux8+3/QjS8PwHHzAEj7aAy/GZ8mzsZaQJKN9+dzkxI493CpHX3S
         4JqpElBTkAucViWGmfkH1gUPkpCXJGoDNffg6ycz1r5vuK2x7ekIvjWZCt2IyhAJxWex
         qqt87vQuT/7mR0UeFwh46HUbxqMW7urccM3kymjmyg+ok/4AlFDg7677JgF0WRm4cRev
         N/4cBESlgA/nLhKO4gE2HvQoeNwSlganNai8Tp63CDcrg3JC+CF5t7ouEppMWJ0bjUkz
         Cteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754580; x=1790359380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=leUxoZNbrIHhJwMkVXew1sBjFqiId1Gr67nxTcdiA8U=;
        b=wvoa+HNdcXaOppr6pvYIUzeeyvSD/d0FhdNJfZ7znT0lrowlA/QHEzruUxC09LjFs6
         +E6/YWkRSDNHQTBoljkVOt08PvkK9QsdEf0lLeKc3tmbNCjAgPMEVLX2OBGpn+yVZbi9
         JyObS38JSqLshR/Ow+P2ng3+0KrDMJybnpimrB0TWu6bkdEp/27BCB/Qr8TSOQhI001P
         tngGIt4jUygzfv+eB4zEUtXNv6vMWWEjQ3xCYdscLhlIugAAAJwU2/AgfjaIEy+W9oCw
         FyaA4OZPAhJaCg62NguSx4Aon91W61Yi7X+9zkE0/1W7iE/4I76+H9LNF+5H93TGp4pp
         /kdQ==
X-Forwarded-Encrypted: i=1; AKwUvBxtjki0uZnYo5fWCfF68rgpJh+M/1XKjl0WrQI/P86eWvT0NvQyneA+bt7bQ2fLJxq6ma34HmvkLA==@kvack.org
X-Gm-Message-State: AFuF++lva5Sfn8WDZ0WuMUFYsVpXPkcXi38TlaejaZF/NztFaPeALohH
	OW4uNSILTNgmzdg6kI88XdGwuXoTi3EENy/92m2THOF4jGtDIQqGlTZCtgrBeEHB
X-Gm-Gg: AYBFou18ZmA9KtC66ZlYbK9e6A3pOxsQD55YNpVNtMAtKOgUXyVEy2NuClvbp+p1DPJ
	ANwzg9Kgkf8ycIjrUVdraDJLDrI5zwbc+VSaRMO4iQ232c62EHQXLdhe93iicfrKBexxBzvc1xl
	dIC6ADH5+2n70lVphvd4G6+jp4sz73Ugn4c+vSP+ojdbINYFmUPANtUQWFHWOTyswj6QpSZ5Llo
	xWBX5QJ0sl2x0SHWEMT5r7XTIaVpI5GVZZwX5npnhi9yO/Yi+GQTEH5kn/pzKIspRjxrWtffzIp
	pjVSkAYR6/XYWeOHIolXmYskHSx40SEYpSQG5DmbyLQtgdZ4+y8RnDKcBYdiPt5Gekik9g8Nmbg
	itjF7ctSLFNuHvxE+Ft5dmzezP5CUEhcT11OdvjoUQT4CLGbrPk2K7KAo9f6C5sg7T+WtMMpgC3
	PIRl1+4xLsbr/B+sdXDFyG6XsFOpmtv+lIq9YBNlpzoFQa+r/AaFx1rrCmj5Fgyun1AHXv5vaK5
	9tXnuRcpUV9wzwXGhRiXExnc0wHSI7n
X-Received: by 2002:a05:6830:650a:b0:804:ca33:4aff with SMTP id 46e09a7af769-80de0e50a9cmr3677995a34.9.1789754580097;
        Fri, 18 Sep 2026 11:03:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8107e894949sm141880a34.17.2026.09.18.11.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:59 -0700 (PDT)
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
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
Date: Fri, 18 Sep 2026 11:02:40 -0700
Message-ID: <20260918180241.3424851-11-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54FFF40018
X-Stat-Signature: 4xzwscrzqi615m6pfaub6ihhmotre8g3
X-HE-Tag: 1789754581-566297
X-HE-Meta: U2FsdGVkX19kVUAdzpvUFgTm+bQvuxUXrPFHmz5IoCmCr8438jzsmTxzwv5w9NmAdEdEHXxXYGsPSHYtmk8IdpuOmYnxyhrZZWEkYjBGzgZV3oOmZ35uwJDCIuUyewYPCRI0U+/QLBr31X48Bu+dm16aZvGBqoQXtkuBNoq4emPQHRXooF6V5ExsSSevg6zb4nuEQ+0IMavDImDO+n+OmPAESU3RW5obtjs8U2w17AWbF2BabGsUNTbNn5jalqQ2FC7qrDNrn7hY6Qkl3Nt4M10n/aCf1PGdRlmfC7bBDdVgsj298XKR2ntXVJcJ/ehaGkJYQLrbXR9Anw18smuSOS3OGCEVh240XQsBn9CxR4zlZvqZ8qwL0/sQnE5BBh7+KMIAohr89te4xWSXEhhyAViyjC1nqbJ7DrwuIzMySYlH/aYy8wioBdQX+zNoHx1/GILMP+sZbu5nJdxJ5dM3qU7arnqmBkVlQTwneGlh5cErSPcDHcVkMuoM/0ZsQefqzw+yuslWBrHF0IVcOBhInjlFAXyA0/EQYmJ963doKcMHb2l6zxcyNi8c+ZK3PQHZJQxGHW8YYQm0WqhI1U9Jrqs3v4foXhMltEz3t5BiZvutND6sghwf2CBJhL83Umnr+VzoaskDuPJJ+dcdLBQNjBzoxSaDIQZS8xGA+U+S04Y01CzDEdGD/SIGVq+57WduB2W0RZdA4jneMTTPbQPTe196GtlEqiUUITQEaLG5KJZhK9xZEDLTbLZbzLX7mi26GNrZ0be8Gk0FQIAY3Y096zxlN20q5Y+JkdaJzpH/qPn3TyuREVlvg6J5CWjMeQsFhLAonNnB4lsG9E+RsOHgE0hJF+RZ9b5Z5EOR2UUU7EFHHxQfeIDBGZ8XxKE6tj0vcp4g6pfOHmkBFhdCsxa4Z4vu1oHsgSbg1Ru8sdvSNZwSQ+p1KPwlAvL47Zq5UpJ1fpKp4Esa+3TeZllZN4g
 u40qLJNE
 sibJu93uktQEMrXKgrsvLUyivPKDc52s6qP3ZxZ6QUktKiy7d6tZFOYgXsTLh62QF7vLH4b+nZFeCYo6GZ6NwyPMK7wXloU522lk7CdsxqW5IRz7CiBcVmsgoF4Q37A55EIOkaohWhy2B3955ygSS+i8LkYhh51ESLmR+n2mIFDpvtzxZjiWifVnd+lkWLLsbJUkohSjkyfa+/cnEvhxheqy/N1yqOnBrwz3akNbAF1MXioHdX5qf4f3OT3oB9hdfKeTilSLkePmMK5xWxt2OnKhN+TEGIptfxGYlhsPOzBjH3zd2lRkaz6LYIyMmuiO85blofXBg8PCER4vdjRKGhv6/gsxKTU7/wKf91aysJY8bltAs8ky2US/eK2E/MTZHtH5/fp0h65MGI8nkjEp/BigEuXkBAqXPWY60WZ4jmDvKsdXjrzjURN4GvH9Ow6/sS3lIa7Zv8hL9oENY83+RQEg2dwXb8761VDvHTeCdUT0n/WmP5H0dgInCsBqLsypXYd4y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop allocating a memcg table for every physical swap cluster that only
ever holds vswap backings. The table costs SWAPFILE_CLUSTER *
sizeof(unsigned short) per cluster, 1 KB per 2 MB of swap on a 64-bit
kernel with 4 KB pages. On a vswap-heavy workload, where zswap writeback
is the only consumer of physical swap, that is the common case.

Such clusters never have their memcg_table read or written: vswap-layer
charging records on the vswap cluster's table, not the physical one.

Allocate eagerly only where the table is known to be needed: every vswap
cluster, and, when vswap is off, every physical cluster, since none of its
slots is then a vswap backing. A physical cluster otherwise allocates on
its first direct-use slot, and skips entirely if it only holds vswap
backings. Hibernation slots have no folio and record no cgroup, so they do
not trigger it. That deferred allocation is on the allocator's fast path
and can fail; the allocation it serves then fails too, and the caller falls
back to another cluster.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 83 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 19 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index cf07d87d2301..39d1840b0d36 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -472,7 +472,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	swap_cluster_free_count_table(table);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -493,7 +494,14 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 		return -ENOMEM;
 
 #ifdef CONFIG_MEMCG
-	if (!mem_cgroup_disabled()) {
+	/*
+	 * A physical cluster under vswap may hold only vswap backings, which
+	 * record their memcg on the vswap cluster's table, not this one. Such
+	 * clusters defer memcg_table allocation until they hand out a slot
+	 * that maps directly into the PTEs.
+	 */
+	if ((!vswap_is_enabled() || swap_is_vswap(si)) &&
+	    !mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
@@ -571,8 +579,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN))
 		return ci;
 
 	/*
@@ -585,8 +593,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -863,7 +871,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
@@ -1086,7 +1094,9 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    struct folio *folio, unsigned long offset)
+					    struct folio *folio,
+					    unsigned long offset,
+					    bool *nomem)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
@@ -1115,6 +1125,23 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
+#ifdef CONFIG_MEMCG
+		/*
+		 * Lazy-allocate memcg_table on the first direct-use slot of a
+		 * physical cluster.
+		 */
+		if (vswap_is_enabled() && folio &&
+		    !folio_test_swapcache(folio) && !mem_cgroup_disabled() &&
+		    !ci->memcg_table) {
+			ci->memcg_table = kzalloc_obj(*ci->memcg_table,
+						      GFP_ATOMIC | __GFP_NOWARN);
+			if (!ci->memcg_table) {
+				if (nomem)
+					*nomem = true;
+				goto out;
+			}
+		}
+#endif
 		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER))
 			break;
 		found = offset;
@@ -1124,7 +1151,15 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		break;
 	}
 out:
-	relocate_cluster(si, ci);
+	/*
+	 * On a discard-capable device, relocating a cluster whose memcg_table
+	 * allocation failed queues a discard for slots that were never used,
+	 * which folio_alloc_phys_swap() reads as progress and retries on.
+	 */
+	if (nomem && *nomem && !ci->count)
+		__free_cluster(si, ci);
+	else
+		relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
 	if (swap_is_vswap(si)) {
 		this_cpu_write(percpu_vswap_cluster.offset[order], next);
@@ -1145,7 +1180,13 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
+	bool nomem = false;
 
+	/*
+	 * In rare cases alloc_swap_scan_cluster() can fail due to
+	 * memcg_table allocation failure. Short-circuit to avoid looping
+	 * over the list indefinitely.
+	 */
 	do {
 		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
 		unsigned long offset;
@@ -1153,10 +1194,10 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, &nomem);
 		if (found)
 			break;
-	} while (scan_all);
+	} while (scan_all && !nomem);
 
 	return found;
 }
@@ -1177,7 +1218,8 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 	spin_lock_init(&ci_dyn->ci.lock);
 	INIT_LIST_HEAD(&ci_dyn->ci.list);
 
-	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC | __GFP_NOWARN)) {
+	if (swap_cluster_alloc_table(si, &ci_dyn->ci,
+				     GFP_ATOMIC | __GFP_NOWARN)) {
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
@@ -1203,7 +1245,7 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 	}
 
 	offset = cluster_offset(si, ci);
-	return alloc_swap_scan_cluster(si, ci, folio, offset);
+	return alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
 }
 
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
@@ -1310,7 +1352,8 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset,
+							NULL);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1354,7 +1397,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order < PMD_ORDER) {
 		/*
 		 * Scan only one fragment cluster is good enough. Order 0
-		 * allocation will surely success, and large allocation
+		 * allocation rarely fails, and large allocation
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
@@ -1369,7 +1412,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	/* Order 0 stealing from higher order */
 	for (int o = 1; o < SWAP_NR_ORDERS; o++) {
 		/*
-		 * Clusters here have at least one usable slots and can't fail order 0
+		 * Clusters here have at least one usable slots and rarely fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
 		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
@@ -1590,7 +1633,7 @@ static swp_entry_t swap_alloc_fast(struct folio *folio)
 	if (ci && cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
 	} else if (ci) {
 		swap_cluster_unlock(ci);
 	}
@@ -1981,7 +2024,8 @@ static bool vswap_alloc(struct folio *folio)
 		if (ci && cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(vswap_si, ci);
-			alloc_swap_scan_cluster(vswap_si, ci, folio, offset);
+			alloc_swap_scan_cluster(vswap_si, ci, folio, offset,
+						NULL);
 		} else if (ci) {
 			swap_cluster_unlock(ci);
 		}
@@ -2860,7 +2904,8 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (pcp_si == si && pcp_offset) {
 		ci = swap_cluster_lock(si, pcp_offset);
 		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			offset = alloc_swap_scan_cluster(si, ci, NULL,
+							 pcp_offset, NULL);
 		else
 			swap_cluster_unlock(ci);
 	}
-- 
2.53.0-Meta


