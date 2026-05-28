Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A75DCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4637D6B0098; Thu, 28 May 2026 17:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411CC6B009B; Thu, 28 May 2026 17:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2672C6B009D; Thu, 28 May 2026 17:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8AE6B0098
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:30:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D01561C220E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:07 +0000 (UTC)
X-FDA: 84818121654.19.B700DB7
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id ED8E340013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AZWsHrsl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780003806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kp4nYgBwYqbTZevet3/JvCrzNrQ24lukygwTOrJB7hw=;
	b=BM1aFP4PxItcbTpYgKRDz9jzjQdH9fxheqSb87FnNnrYsxjHRLhBXz8ymV8EgnXPuQ8zcN
	jRL9WiN8U7elOXtEWhE3RE+BAgmEEkIs2Qf5hw2/P30uPi/Sqc4YM5PNsPOIFwg/3+jNde
	l5/iFijJpguvAs+9JKiOi6Le2V/cdJo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AZWsHrsl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780003806; a=rsa-sha256;
	cv=none;
	b=CZpeioCj+PTXzgBpCjotAAdfMwacTaLKFdWcXD5IQoN5yY0dCl9hGedGNuo3W+ou9EqL33
	qnjtGFLZjJV6NJac4/iEaT8ma7J7LI1PtftALv/+nUX0gbjMhN2YO8hzEIFD+SZvXz6qeh
	LjWdEsyeyylwv6U2HnJPt9QZ0/cH7eA=
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4824176bbbeso4591309b6e.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 14:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780003805; x=1780608605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kp4nYgBwYqbTZevet3/JvCrzNrQ24lukygwTOrJB7hw=;
        b=AZWsHrsl+UHdOiTo//07Q17P21BmGgwHEGrlcRy7dhMZNHvvup9MpBnbui5XXyV7Gq
         DF+uIOCu2rL/XZ6IGBT6LCA2LNsvrp4cS1tWoPChmBaxYzzcf2CUg+3Phi3GwbwqQNat
         b1/GSc5pz7Hu40lKHPU9sT3ejt09GW4+AwhnCjDiEUeNNyO+vIiteb2gFoCFNtF1nZGw
         eLJjEMOvEoY0ZwFKNGKpRDnrp2PO94Hm0jo2FAX3sAFiLBc4YfCN+KzuJ1XVRqFl8RK1
         VV+9vKaB3JW6DFLoG5E58b1T0w7nV34mqdK+7WoKdMBeDWhjrTIE+rPpevNcKNpLonu6
         d6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780003805; x=1780608605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kp4nYgBwYqbTZevet3/JvCrzNrQ24lukygwTOrJB7hw=;
        b=VPMHO+4ltMcvYIPcObqg/cwmBqhvz9Iwka9oZ6yEQW5fx9JT88Db3dVfvfhG2LhC2N
         Ow3KwI9PXhhsD3gRiEtEkyHWsn2RuD3dZDdpMtmHxPqTqTeiFiaRcdgwQ3/ZARvuwQYe
         sJYJD61yplmQvFhkvYwRteousm36rwtODV5BgbchAegP0Zd+kTGYWvvyVTZOgyekb9JO
         JidriILG/8W188W7jCW9RbeDK0vt11ki1BkbydZFXzPUj7B46KR5Af2617IfCIWLrYoe
         cTNVs4GaLJwIrY4Og8MSFOmsuuNBIPK80xUNLrIiCXxEo3mK7vTb12FlroQqQpBPs/4b
         jTvw==
X-Forwarded-Encrypted: i=1; AFNElJ8gyYs20MCZT+JmT5P6AsR5+gxfgXM9jv2mkEvbpgT6k7iQ0PHv/W0YXZ3NQesCKYW4JRWJMc5qDg==@kvack.org
X-Gm-Message-State: AOJu0YzU8PUtKZLSsztOMEuEDlp7Y5MBVIc3NUEUH7gkSvEirVmbTonL
	ey8B/dwDC1c+9Jij71qGSxKwoVrUiagvkT/E7nR4pVdS1O5xFH2vLV1z
X-Gm-Gg: Acq92OH1LJu4pF9fJgkhU/KY67LGB7LCXu2ymOI7bQEeORCg0QiU4zfuN/Cd4pd5Gqe
	quckjmFx4U3syOsPDRsRkM4k2D0fNxanvzQ4uc4Ath+OKc7h9MYdqnQxKrX3WTHhto0fAvG3di4
	BCMkzYMEt5QpeI7+Xjc797nS6+nRZA3iKHkQ7+BCMvCp9SZ7o04IGJekTaxNNs3oFecuaQG61Au
	V2hcFA1bvEluIedcffMR8D7OWO58SQd6DYYysoHFJpCra/JgzOKRMMLU6OYQCQPnu1tZNRf9QoX
	CTDrgzEzjWk73aTTiCnliCFQCRushu45tp6FMzBFLahqwYcRJlaFvawvrWCaiwLQQa6XP+7yhCg
	1SwnSWQ3wQm+7jQGvM3eNoQyyV1qsAMv0yPxHrP2evuW6/u5jv1DWnJvop4J2ITVCTdzRstBCyM
	DY0BDwYZi+oOtMnB+0tYMhknfrtY6miz+4q8XzsYtgzO9j0fZh4sFv12Yr
X-Received: by 2002:a05:6808:250b:b0:485:542:f905 with SMTP id 5614622812f47-485e6acd9dbmr189559b6e.16.1780003804882;
        Thu, 28 May 2026 14:30:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4855476cbccsm10188560b6e.18.2026.05.28.14.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 14:30:04 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [RFC PATCH 4/5] mm, swap: only charge physical swap entries
Date: Thu, 28 May 2026 14:29:28 -0700
Message-ID: <20260528212955.1912856-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528212955.1912856-1-nphamcs@gmail.com>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uogougnriuzjtn3hyeba7bqyncpgi5m8
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED8E340013
X-Rspam-User: 
X-HE-Tag: 1780003805-703003
X-HE-Meta: U2FsdGVkX1/Ph1PO8+vEshEJpygHO4Iqs/vJQEtUSjMJJcpEn1yv0fjP/Q5ByPL2d/OWceEbF0xAz/NN+vjfO9Orr9zJbnQQ17m3Mf4EgAudKu4Fxuf9H+qSPPgDgOoc6qgChFQUd4TOOr0NGc/AcmO4vfSMbGpSl2eAMeW6UvzztwzUKWGGtSrIm8kdOQ+eA8yzaUN6DDUklo58lRk7FqLLVfXE27p+wPMSr7o/Hycq48NVeXKRM31IcdgYrw5yfciN8/UgfFxOAjh7+SIhV3lEXTYiHGOWQPrX58orfSYI7aWYtzLej5oSEGK16GcTqhipJIA4yb63WTe/Q18JBTHjtthRK2btWZ7Y61x6lvA3gDMkVOKTsxaFuP+PUZKlbMU8SyiMiprAhuM8ExVITE05AaQTlUls8Fr7aV0Q5GXRDkieOGeo9tmNpBjM6oGTjJ1gAwT0C8F4khlIMg1qblgPtddsYpA/aKOt5KCD8mmOOYUQVqYutBDitYKT3tfbp4eiJifbGcv8YMJmpJk/QS65XgSbM7iVuWXqAGXvxQ68Di9sv5qNOdeiEZCZIq+I0m+cfR9vgq/IJGmFbChexNQNLwRGmbwVoX4XcVdCfPeOtVEpj366DkHlT0zEQtaClbwElqpgBL9OuMT16WF6eh9rhQOa7zmYzHJpk0l81sY0zBU5wCl5J1xSjqq+8c76FzAJIW2vvs/ADbI1fraUTGydANnJ27KUXkVaLeLILjD6qMfRQy7RJO6R7q07qM9gGq1wtS/pCTsx2M1OOV6iiO96SczRxlIma8ohVMYWpaWVjk9tfZcZNMP+VDrnURBQbdKJcGxuVWwnqm/MTfGzJYAQ8sr95fM0H9imiHUAhyhzNd+J7R0yT7EJQiodS3m3nH3OFPhE/MjS467+/jxfAno625fwYNPdWSCCKiWFHIlMmOmgWXXUPwc4D43bAiql8ww3aJDFg0rj5Q3Ti2P
 jP1KSV0D
 fE9EbvXffyGCi+3ryniATJTBXKV970eY2xVhlcAmSlQeyamX7sft1nGW6dEz7iMzWENvn9GgpezQULcOPvceCXJaS0KOpG/UyAzgydBsX/y2RqPLkloBsdNCK+1nX8Y+YwqbNGAg+vaSLuNqAZRvC2V1zHt7wYXPjbD4pODtn2HazjmASymSjshuw/AXJn2wJA2a1NDMhHPHm7ybiL/RK3RDS2BYYqdCc4defwJutsaD0VPF1Uwx1qfWvBb9Q/FWGBt8oUc+P2T1bmlLANUjyc2FYiTNoZWKLn6l0LpuZ26jrlxCpu7qk+HBRDAkZ2Onskjw6Ufh2+qXWChVRgcg90iV0VuBPFbg4cBqdE8D3KTeh/UbBcMLjrujRgbczHWZ0X+6F5s9p7Ws4EeufUIEWz28Sny/TSqQJCNgUWXXesEhHpGhwNnhWQzZvbxq6aQYzkTbbylC66XFpSeDqcii5GR5wWQhDSBEngcpqEF/nooC2clG3Y3S6ojA8+DKiCoTvHyGSVIUriM/vCJjmD9M0cGjM0xdhaIHFSQKatzfz36lwdchtZByiVWnh1y4CGcYakcchhwj+L+YAuOwhIrMXQvMlxGpxschP4/KV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop double-charging vswap entries against memcg->swap. Previously,
the entry was charged once at vswap allocation (via
mem_cgroup_try_charge_swap) and implicitly again when physical
backing was allocated.

Split the lifecycle into four operations: record the memcg private
ID at vswap alloc without charging; charge memcg->swap only when
physical backing is allocated via folio_realloc_swap; uncharge in
vswap_release_backing (only nr_swapfile entries on v2, all nr on
v1 memsw); and drop the ID ref at __swap_cluster_free_entries
without uncharging.

Direct-mapped physical swap charging is unchanged.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  57 +++++++++++++++++++++
 mm/memcontrol.c      | 118 +++++++++++++++++++++++++++++++++++++++++++
 mm/swapfile.c        | 109 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 276 insertions(+), 8 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3fb55485fc76..6f18ecdf0bb8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -597,6 +597,43 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return __mem_cgroup_try_charge_swap(folio);
 }
 
+extern void __mem_cgroup_record_swap(struct folio *folio);
+static inline void mem_cgroup_record_swap(struct folio *folio)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_record_swap(folio);
+}
+
+extern int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+					 unsigned int nr_pages);
+static inline int mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+					      unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_charge_backing_phys_swap(memcg, nr_pages);
+}
+
+extern void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+					    unsigned int nr_pages);
+static inline void mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+						 unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_backing_phys_swap(memcg, nr_pages);
+}
+
+extern void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages);
+static inline void mem_cgroup_id_put_swap(unsigned short id,
+					  unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_id_put_swap(id, nr_pages);
+}
+
 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
 static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
@@ -613,6 +650,26 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return 0;
 }
 
+static inline void mem_cgroup_record_swap(struct folio *folio)
+{
+}
+
+static inline int mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+					      unsigned int nr_pages)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+						 unsigned int nr_pages)
+{
+}
+
+static inline void mem_cgroup_id_put_swap(unsigned short id,
+					  unsigned int nr_pages)
+{
+}
+
 static inline void mem_cgroup_uncharge_swap(unsigned short id,
 					    unsigned int nr_pages)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7492879b3239..91618da7ec20 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5513,6 +5513,124 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	return 0;
 }
 
+/**
+ * __mem_cgroup_record_swap - record memcg for swap without charging
+ * @folio: folio being added to swap
+ *
+ * Pin the memcg private ID ref and record it in the swap cgroup table,
+ * but do not charge memcg->swap. Used for vswap entries where the charge
+ * is deferred until physical backing is allocated.
+ */
+void __mem_cgroup_record_swap(struct folio *folio)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (do_memsw_account())
+		return;
+
+	objcg = folio_objcg(folio);
+	if (!objcg)
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	if (!folio_test_swapcache(folio)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+	rcu_read_unlock();
+
+	ci = swap_cluster_get_and_lock(folio);
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
+			  mem_cgroup_private_id(memcg));
+	swap_cluster_unlock(ci);
+}
+
+/**
+ * __mem_cgroup_charge_backing_phys_swap - charge memcg->swap counter only
+ * @memcg: the mem_cgroup to charge (may be NULL)
+ * @nr_pages: number of physical swap pages to charge
+ *
+ * Unlike __mem_cgroup_try_charge_swap(), this does NOT touch the memcg
+ * private ID refcount — the ID ref was pinned earlier by
+ * __mem_cgroup_record_swap() at vswap allocation time and lives for the
+ * lifetime of the vswap entry. This helper only updates the swap counter
+ * when a vswap entry transitions to physical backing (folio_realloc_swap),
+ * so the counter and the ID ref can be managed independently.
+ *
+ * The caller resolves the memcg (typically via folio_memcg + ID
+ * comparison to avoid IDR lookups on the hot path).
+ *
+ * Returns 0 on success, -ENOMEM on failure.
+ */
+int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+				  unsigned int nr_pages)
+{
+	struct page_counter *counter;
+
+	if (do_memsw_account())
+		return 0;
+	if (!memcg)
+		return 0;
+
+	if (!mem_cgroup_is_root(memcg) &&
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
+		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		return -ENOMEM;
+	}
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	return 0;
+}
+
+/**
+ * __mem_cgroup_uncharge_backing_phys_swap - uncharge memcg->swap counter only
+ * @memcg: the mem_cgroup to uncharge (may be NULL)
+ * @nr_pages: number of physical swap pages to uncharge
+ *
+ * Unlike __mem_cgroup_uncharge_swap(), this does NOT drop the memcg
+ * private ID refcount — that ref is dropped separately via
+ * __mem_cgroup_id_put_swap() when the vswap entry itself is freed.
+ * This helper only updates the swap counter when physical backing is
+ * released (vswap_release_backing), so the counter and ID ref can be
+ * managed independently.
+ */
+void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+				     unsigned int nr_pages)
+{
+	if (!memcg)
+		return;
+
+	if (!mem_cgroup_is_root(memcg)) {
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		else
+			page_counter_uncharge(&memcg->swap, nr_pages);
+	}
+	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+}
+
+/**
+ * __mem_cgroup_id_put_swap - drop memcg private ID ref without uncharging
+ * @id: cgroup private id
+ * @nr_pages: number of refs to drop
+ */
+void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	if (memcg)
+		mem_cgroup_private_id_put(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
 /**
  * __mem_cgroup_uncharge_swap - uncharge swap space
  * @id: cgroup id to uncharge
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a0976be6a12b..be901fb741e5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -33,6 +33,7 @@
 #include <linux/capability.h>
 #include <linux/syscalls.h>
 #include <linux/memcontrol.h>
+#include "memcontrol-v1.h"
 #include <linux/poll.h>
 #include <linux/oom.h>
 #include <linux/swapfile.h>
@@ -2043,8 +2044,15 @@ int folio_alloc_swap(struct folio *folio)
 			goto again;
 	}
 
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	/*
+	 * Vswap entries: record memcg ID without charging — the charge is
+	 * deferred to folio_realloc_swap when physical backing is allocated.
+	 * Direct-mapped physical swap entries: charge immediately as today.
+	 */
+	if (folio_test_swapcache(folio) &&
+	    swap_is_vswap(__swap_entry_to_info(folio->swap)))
+		mem_cgroup_record_swap(folio);
+	else if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
 
 	if (unlikely(!folio_test_swapcache(folio)))
@@ -2096,6 +2104,26 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     unsigned int ci_start,
 					     unsigned int nr_pages);
 
+static void vswap_uncharge_cgroup_batch(unsigned short memcg_id,
+					unsigned int batch_nr,
+					unsigned int batch_nr_swapfile)
+{
+	struct mem_cgroup *memcg;
+	unsigned int n;
+
+	if (do_memsw_account())
+		n = batch_nr;
+	else
+		n = batch_nr_swapfile;
+	if (!n)
+		return;
+
+	rcu_read_lock();
+	memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+	mem_cgroup_uncharge_backing_phys_swap(memcg, n);
+}
+
 void vswap_release_backing(struct swap_cluster_info *ci,
 			   unsigned int ci_start, unsigned int nr)
 {
@@ -2106,12 +2134,36 @@ void vswap_release_backing(struct swap_cluster_info *ci,
 	unsigned int ci_off;
 	unsigned long vt;
 	swp_entry_t phys;
+	/*
+	 * Per-cgroup uncharge batching: a single vswap_release_backing
+	 * call can span multiple cgroups (e.g. batched free across
+	 * folios), so we cannot uncharge with the first slot's memcg
+	 * for the whole range.
+	 */
+	unsigned short batch_id;
+	unsigned int batch_nr = 0, batch_nr_swapfile = 0;
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	batch_id = __swap_cgroup_get(ci, ci_start);
 
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
+		unsigned short cur_id;
+
 		vt = __vtable_get(ci_dyn, ci_off);
+		cur_id = __swap_cgroup_get(ci, ci_off);
+
+		/*
+		 * Flush per-cgroup uncharge when crossing a cgroup boundary.
+		 */
+		if (cur_id != batch_id) {
+			vswap_uncharge_cgroup_batch(batch_id, batch_nr,
+						    batch_nr_swapfile);
+			batch_id = cur_id;
+			batch_nr = 0;
+			batch_nr_swapfile = 0;
+		}
+		batch_nr++;
 
 		/*
 		 * Flush batched physical slots when the next entry
@@ -2135,6 +2187,7 @@ void vswap_release_backing(struct swap_cluster_info *ci,
 
 		switch (vtable_type(vt)) {
 		case VSWAP_SWAPFILE:
+			batch_nr_swapfile++;
 			if (!phys_start) {
 				phys = vtable_to_phys(vt);
 				phys_start = swp_offset(phys);
@@ -2165,6 +2218,9 @@ void vswap_release_backing(struct swap_cluster_info *ci,
 			phys_start % SWAPFILE_CLUSTER,
 			phys_end - phys_start);
 	}
+
+	/* Final cgroup-batch flush. */
+	vswap_uncharge_cgroup_batch(batch_id, batch_nr, batch_nr_swapfile);
 }
 
 void vswap_store_folio(swp_entry_t entry, struct folio *folio)
@@ -2222,7 +2278,9 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	swp_entry_t vswap_entry = folio->swap;
 	struct swap_cluster_info *ci;
 	struct swap_cluster_info_dynamic *ci_dyn;
+	struct mem_cgroup *memcg;
 	unsigned int voff;
+	unsigned short memcg_id;
 	swp_entry_t phys_entry = {};
 	swp_entry_t pe;
 	int i, nr = folio_nr_pages(folio);
@@ -2245,9 +2303,33 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 		return (swp_entry_t){};
 
 	voff = swp_cluster_offset(vswap_entry);
-
 	ci = __swap_entry_to_cluster(vswap_entry);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+
+	/*
+	 * Resolve the memcg for physical swap charging. Compare
+	 * folio_memcg against the recorded swap memcg ID — on match
+	 * (common case), zero IDR lookups. Only fall back to IDR
+	 * lookup on mismatch (task migrated cgroups).
+	 */
+	spin_lock(&ci->lock);
+	memcg_id = __swap_cgroup_get(ci, voff);
+	spin_unlock(&ci->lock);
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (!memcg || mem_cgroup_private_id(memcg) != memcg_id)
+		memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+
+	if (mem_cgroup_charge_backing_phys_swap(memcg, nr)) {
+		__swap_cluster_free_phys_backing(
+			__swap_entry_to_info(phys_entry),
+			__swap_entry_to_cluster(phys_entry),
+			swp_cluster_offset(phys_entry), nr);
+		return (swp_entry_t){};
+	}
+
 	spin_lock(&ci->lock);
 	/*
 	 * Install PHYS backing without freeing any prior contents of the
@@ -2468,10 +2550,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned int batch_off = ci_off;
+	bool is_vswap = swap_is_vswap(si);
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (swap_is_vswap(si))
+	if (is_vswap)
 		vswap_release_backing(ci, ci_start, nr_pages);
 
 	ci->count -= nr_pages;
@@ -2491,18 +2574,28 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		/*
 		 * Uncharge swap slots by memcg in batches. Consecutive
 		 * slots with the same cgroup id are uncharged together.
+		 * For vswap, only drop the ID ref — physical swap was
+		 * already uncharged in vswap_release_backing above.
 		 */
 		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
-			if (batch_id)
-				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+			if (batch_id) {
+				if (is_vswap)
+					mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
+				else
+					mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+			}
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
-	if (batch_id)
-		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+	if (batch_id) {
+		if (is_vswap)
+			mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
+		else
+			mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+	}
 
 	__swap_cluster_finish_free(si, ci, ci_start, nr_pages);
 }
-- 
2.53.0-Meta


