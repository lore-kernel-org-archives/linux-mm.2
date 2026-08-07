Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63112C5AC80
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B9C6B0096; Fri,  7 Aug 2026 16:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D2E6B0099; Fri,  7 Aug 2026 16:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA5C6B009B; Fri,  7 Aug 2026 16:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94F1B6B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F53B1A01A1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:12 +0000 (UTC)
X-FDA: 85075592784.11.07013DF
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 547E5140011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UNfL+jZ/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vEVg85rEvrzvIwoN3Uc+WskLG7iLQIioETffuSYNDk=;
	b=HKB4BXVodgwATxdgJeBu0d4dB0x1n8YEQcPnmtnVE1kGRcIjUYQXklXRNAvbmyjt/jktmr
	qmNx4N7E1X2CGsbhgyX6xw84U0fMQBIlF3AA3Mr/yshsV5sN8A56J6powIixvc/LxhlJVw
	tBd4LFwZpqkMo4b1I3X1bm/AsXZouYk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UNfL+jZ/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134070;
	b=PgfKZ43s0floya8xWLUE08f3ziqV8TaHB6USVYxNBJzMnQkZ1vZoCKP6gsiNcjTaqhy6bf
	JYVXKPlkFme4KQxUWPuMtxMiMS6jO+puMc3J8MuzYUCzFGA/VHF9zdBGrnx1f68NNgFzLP
	sVlsLHKdYhOQGR8ZBnf1XiCgSpWB8Do=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6acc74fee76so1620030eaf.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134069; x=1786738869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5vEVg85rEvrzvIwoN3Uc+WskLG7iLQIioETffuSYNDk=;
        b=UNfL+jZ/gTQMYy3/tpE59gVJvTGu8amF00nNtyt3wmag/E79AOZIW8uFKsqPX0pm9a
         XCiejoNhoc59fuQR9AIvZXr+YZIFCKjnzVmqOeKOK6UJ+1dNgGfj8tf+g97rBtZ5WmJy
         ++EzXi1Cb9L2UiGcp3B7uRFTFcN41F0a3q0QmkUzoifMXaxghQmcAKZmXrojbgjjgHkr
         SRccejCX4VUAEneJwoThU6VkDc1YAkzXhSBnsawuQ+FHAXQNohrd73Mgj7og6s2CinR2
         bxsC9y2IC79T1esmBX+6y8gUe4ahnejl9fO42Rdptlw+mczXEtL1XKM+QTG8dLpASuXo
         1p8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134069; x=1786738869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5vEVg85rEvrzvIwoN3Uc+WskLG7iLQIioETffuSYNDk=;
        b=ALN30IoEIAh0oCWLoaKSmLHY1u+utp3Isch40flPO1zVEnEiFXTcJYkT67wOQA+NsR
         T4SkhH1HmYTWD4YZH7CvDK8kfAn2XSJgNRANXa/E3lK/uJI97cWPzbsCTtP75VG9uTxd
         YKdPKYEWx/dGx5+wASqhk/1hNM8Ki2wkhFvVCc/MHJKsblGnBpp6DzdHK4hM58LMdCfE
         KcljiYorrPmCYb+cj87XLdxU+rGsR5TQF3cmMtvOifvjzOzLynawjYDFDzrzlNjkx3YT
         Wbw5qrD7hnrAVgI2mr8TVP0wJQqpiHyq7gL92z2kdU/YemS9AtAMDunAYrd9i8gQf1Qv
         iPwg==
X-Forwarded-Encrypted: i=1; AHgh+RoebVUZNkL9R2CIE8uBoaKl/3ln6nIQhbUZXjb0wzDl9tpNgOWoeVZ3CwmJomEBl8kJMpUgWuQ7gg==@kvack.org
X-Gm-Message-State: AOJu0YzY0l0m/uZbpxNHdCijG48KU3dKVzTYl+8y4VBrImDWebqiWk/p
	Y+QQI7kbUgHKxx01VTwQirzjcmal5iQVPIpzuK6KP327Q+3Jm4EDvh7r
X-Gm-Gg: AR+sD12iJNthrdxQ6Dq80ovb8MRe+p9A/wJOYpF2jTrDRYFdpYFb5q8MozOUIL1y5cm
	Sv2b2AnS16t9K9MFNGQmzHYAZ6fFKPTJdnagjStkvniPYTHOpqcUShOupKO4+MUWk4JtrRY02wb
	Ffr6LUIPRUKh7wQLW0zudfo1tDK5xzJO7T1gQkNUDUGlXiK5bcIA3FINJUwVnmSIx24Z409pEKV
	DQBSW/sXzuR0nlxtp24LC/7dQsIJ4dIcdSD+5wcQ2Z3LvNXJqx8OkNusAO3apV75s3OtBmvfhHT
	/cz3cMXZCJuIpMN/uwaWTs2sT8s+hUaPaqc/gY55fuXbuzoxjizW7JuG7axkKgdS5J8+2zQoItw
	+HFPUGD6T+zQ/jA9QQ+RNGVJ7sgryvF1RCcSml5UHWnRA2U+GQSY8RXcR0hlM6vR6pfhFSh39G5
	ePsfyP9um0LvG0WEYiNVypEpMCleR2FTBnlRCf1ptJV53UoQyylkJ30eWY6z8ZgjjjJdjBuQQcx
	oCLGS0jSirvPtvT7w==
X-Received: by 2002:a05:6820:168f:b0:6ae:9b39:68d1 with SMTP id 006d021491bc7-6b0420d5753mr1429497eaf.23.1786134068227;
        Fri, 07 Aug 2026 13:21:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02be475f7sm2836904eaf.9.2026.08.07.13.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:07 -0700 (PDT)
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
Subject: [RFC PATCH v3 05/14] mm/memcontrol: Set tier limits proportional to memory limits
Date: Fri,  7 Aug 2026 13:20:48 -0700
Message-ID: <20260807202059.2620949-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 547E5140011
X-Stat-Signature: uk6e781egfbtrb5u779755n5tonocagb
X-Rspam-User: 
X-HE-Tag: 1786134070-635818
X-HE-Meta: U2FsdGVkX1/brDw4WgLXYGoongVlXDJpGaVd9+Q++QuUzcX8FnqcE3trEwFbCqsysP5bw6KUV0oICnNAFOjgO/c+54/NPjXmeWDobeRc8gfbHArU67n7hxYrEKkVEWgthL7p+ruDGuOIEtECCBgBG2IqwlUFGaItq1lyhoLFVrwsDdICHXOKF6RD/VSwyviVPk2EDHLK5r/xiEhVrppr7ifj/zluhzqFszGHWhL8uLbA3u2WFJ2L8xu2YWwZsRmClsGYS/sEYW7vvx2HJYZHz/p1aoIO8QJqVF8GrRoRXLcEse+/XTFFPkkLI7kGPXI0dWfibgeGd7FF5O3HElpDJkWL65nItwBY3Sssnw0V6zC4m4DiM18pl+dTGO3haTzB6WHmcgxX2ymY9fWhbivgLMm5Vg1QWbyjyZSoJq/MR/ExpvXEeTroVEr26yJ0AFcwJLYPeZFUFGd9a7S+g/U0Cae3/ZdDjRXKL2Nu6tadfbOBLVv2mE/PUvadRMSFqpC2fDEMGRnt+mPxEmk1cNoN2Bn5tVSqhuGj03RXP9e8mNmbyycR34movHTVdEBBlp6KfENDzVK89ISzXLBxG3dTSBOYqmGSLD5BY5tluFBmv+mVQEE8mwbnaDttSTdsSMCp1CzstaKDPsjxrQQhuOw8JlYlBQaDYu4YHy+NbNJqD5UTvphzq0byK6o5GMmr7g1P5dOpKm8hMkvdb0NRMPW8I9YIr3DnL0TZeVJJUMoqHMta8vEyELd6zr+rIP211cmUe9ehXoDcgAywL1IMX//lXTtdFD7tsj+BUH1RDm2yY314ML9wiNjl0M/bxeaWiK8IoQtEnRI17jeAnQ1JCCmrDpJjx9pTWkGtGXBgdvAAzlotFpVxJ+VZwIXtdzmxDLE+B30o8zBDkL2WVaBEcbZJKrBcAF9mVxmFQjdD88h+XyaPhhc6Wdba/cMllb/pS91QohH22wLVaHxPlZeWzI4
 cJGHaTLt
 DxrMhhNqvi7Mbdi3nszMkdVSUyw7AugbuYGDrLT9p7J0Tkb5f9x9oDRkPcrfjTCnybkby8z3q5r59TXjI6VykeMncj9HtrX99+YTr/X1BvZ+y/HiBGMjazAu34MFt7w1Gln9lqkK7cXEa0Z30V+uYMb8zzSke757Hk23IrJszx6ptsBMTpTYnaM+Z45GwVvQPfKFvX14XeokkpU+Gdiqze1ZIcGaS4lZnTaYn2f7XEDwWA5hrNRi7L0dDzLuT/+bLtADLy7kCqUJqAhfAIHU+WeJeLjdZEbvHElv/2UeJZKYIcBK0QjgbGiKs3Q7rWWPyJBP5C3HBXhm/FXQZ2Ud24mPqWKRqItHW4mjz4o6XMWzqGe15+Sy8rV70fya/wzsjZG6yLM4ensLMbv63NBMUkgsaemhveDEF1GaBlKkKORZ1GWBpxdJdgMhZfitCR8z60Cxp7lCeYFv0fwZ4UrBF50gwurDSpj+N68f9mDZR2Qhloubd9gVHAzlciPaCfESqW9ZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compute proportional per-tier limits based on memory limits when
users write to memory limit sysfs files, or when memory hotplug causes
tier proportions to be shifted.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h   | 10 +++++++
 include/linux/memory-tiers.h |  6 ++++
 mm/memcontrol.c              | 54 ++++++++++++++++++++++++++++++++++++
 mm/memory-tiers.c            | 13 +++++++++
 4 files changed, 83 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bb5bde87ac85a..f7a92b66330ec 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -537,11 +537,17 @@ static inline bool mem_cgroup_tiered_limits(void)
 {
 	return static_branch_unlikely(&memcg_tiered_limits_key);
 }
+
+void establish_memcg_tier_limits(void);
 #else
 static inline bool mem_cgroup_tiered_limits(void)
 {
 	return false;
 }
+
+static inline void establish_memcg_tier_limits(void)
+{
+}
 #endif
 
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
@@ -1102,6 +1108,10 @@ static inline bool mem_cgroup_tiered_limits(void)
 	return false;
 }
 
+static inline void establish_memcg_tier_limits(void)
+{
+}
+
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 0e49645cdd1a9..04b396f60b457 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -55,6 +55,7 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
 const nodemask_t *mt_tier_nodes(int slot);
+unsigned long mt_scale_by_tier(unsigned long val, int slot);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -169,5 +170,10 @@ static inline const nodemask_t *mt_tier_nodes(int slot)
 {
 	return NULL;
 }
+
+static inline unsigned long mt_scale_by_tier(unsigned long val, int slot)
+{
+	return val;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d096010366515..defd04acfb3fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4421,6 +4421,35 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	mem_cgroup_free(memcg);
 }
 
+static inline unsigned long page_counter_max_or_scale(unsigned long val,
+						      int slot)
+{
+	return val == PAGE_COUNTER_MAX ? PAGE_COUNTER_MAX :
+					 mt_scale_by_tier(val, slot);
+}
+
+static void memcg_scale_tier_limits(struct mem_cgroup *memcg)
+{
+	unsigned long min = READ_ONCE(memcg->memory.min);
+	unsigned long low = READ_ONCE(memcg->memory.low);
+	unsigned long high = READ_ONCE(memcg->memory.high);
+	unsigned long max = READ_ONCE(memcg->memory.max);
+	int nr_tier_slots = mt_nr_tier_slots();
+
+	for (int slot = 0; slot < nr_tier_slots; slot++) {
+		unsigned long new_min = page_counter_max_or_scale(min, slot);
+		unsigned long new_low = page_counter_max_or_scale(low, slot);
+		unsigned long new_high = page_counter_max_or_scale(high, slot);
+		unsigned long new_max = page_counter_max_or_scale(max, slot);
+		struct page_counter *tier = &memcg->tier[slot];
+
+		page_counter_set_min(tier, new_min);
+		page_counter_set_low(tier, new_low);
+		page_counter_set_high(tier, new_high);
+		xchg(&tier->max, new_max);
+	}
+}
+
 /**
  * mem_cgroup_css_reset - reset the states of a mem_cgroup
  * @css: the target css
@@ -4454,6 +4483,8 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 	memcg_wb_domain_size_changed(memcg);
 }
 
@@ -4797,6 +4828,21 @@ static ssize_t memory_peak_write(struct kernfs_open_file *of, char *buf,
 			  &memcg->memory_peaks);
 }
 
+#ifdef CONFIG_NUMA
+void establish_memcg_tier_limits(void)
+{
+	struct mem_cgroup *memcg;
+
+	if (!mem_cgroup_tiered_limits())
+		return;
+
+	for_each_mem_cgroup_tree(memcg, NULL) {
+		if (memcg != root_mem_cgroup)
+			memcg_scale_tier_limits(memcg);
+	}
+}
+#endif
+
 #undef OFP_PEAK_UNSET
 
 static int memory_min_show(struct seq_file *m, void *v)
@@ -4818,6 +4864,8 @@ static ssize_t memory_min_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_min(&memcg->memory, min);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	return nbytes;
 }
@@ -4841,6 +4889,8 @@ static ssize_t memory_low_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_low(&memcg->memory, low);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	return nbytes;
 }
@@ -4866,6 +4916,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_high(&memcg->memory, high);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
@@ -4925,6 +4977,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		return err;
 
 	xchg(&memcg->memory.max, max);
+	if (mem_cgroup_tiered_limits())
+		memcg_scale_tier_limits(memcg);
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index bd5c78cd26ec4..e2c99f51c36d1 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -810,6 +810,7 @@ static int __init memory_tier_late_init(void)
 
 	establish_demotion_targets();
 	establish_tier_slots();
+	establish_memcg_tier_limits();
 	put_online_mems();
 
 	return 0;
@@ -967,6 +968,16 @@ const nodemask_t *mt_tier_nodes(int slot)
 	return &tier_nodemasks[slot];
 }
 
+unsigned long mt_scale_by_tier(unsigned long val, int slot)
+{
+	unsigned long total_capacity = totalram_pages();
+
+	if (slot < 0 || !total_capacity)
+		return 0;
+
+	return mult_frac(val, READ_ONCE(tier_capacity[slot]), total_capacity);
+}
+
 static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 					      unsigned long action, void *_arg)
 {
@@ -979,6 +990,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 		if (clear_node_memory_tier(nn->nid)) {
 			establish_demotion_targets();
 			establish_tier_slots();
+			establish_memcg_tier_limits();
 		}
 		mutex_unlock(&memory_tier_lock);
 		break;
@@ -988,6 +1000,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 		if (!IS_ERR(memtier)) {
 			establish_demotion_targets();
 			establish_tier_slots();
+			establish_memcg_tier_limits();
 		}
 		mutex_unlock(&memory_tier_lock);
 		break;
-- 
2.53.0-Meta


