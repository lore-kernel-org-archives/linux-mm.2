Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5E9FDEE4A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790646B0095; Thu, 23 Apr 2026 16:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C13C6B0096; Thu, 23 Apr 2026 16:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C41D6B0098; Thu, 23 Apr 2026 16:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36E546B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9E1A1C0572
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:57 +0000 (UTC)
X-FDA: 84690974634.26.9848157
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id EA453140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EaaRAsqV;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdJLrTxdQHuW/q5XioIV4K0g79ptTVlTBoTPrKNx/x0=;
	b=7togTBtD+GfFaMcDOYIG76A6CUf/n0bKNveg6naw4irw9g5UK6kEI0JJYQfqAs15zgNQHO
	48h/SUNHyritvHoMR3crV7TuGqERWrgpvDXBVn8UnvLJmDAO/498Ldc9bbJ30OHbB4R4fT
	W6k5LUFYd1UvTsk9OY+5jccB1ad3LHI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EaaRAsqV;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976496; a=rsa-sha256;
	cv=none;
	b=SfKu9XS7t0z11BeDaGEtN4rpeS2fy9D+4FP2brIGFIL7myvrzsKALNd7qPiFuL6tKO7/8Z
	j6JIvmON/7X0r4dNiEhHGvbncxzvF4NJMOLQZINhM3YKMVS42GfRIJCO94uFVYwuQEgevN
	NPqm00Rtsiv/A7Rp2l8dUDuE54+Bq90=
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-463f00cda04so3823425b6e.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976494; x=1777581294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdJLrTxdQHuW/q5XioIV4K0g79ptTVlTBoTPrKNx/x0=;
        b=EaaRAsqVB1P/VxfzNTGQPMDtwReRb5Y8h667VAWtP6RDv+j9d0wo7SpnM78t3/Mh4G
         ew2bEsTrAJdiuCblO/EVNPX98MqJ3qKDpNw0fLgHRs2DHPvFWuI4r1Fh9OwNx6GsMg8x
         8sGZE2EXHL/kgrsw786Q4TNGWeKI8PDlnhRRFSdaqACsjel0C69QXGx1H795lqFsF3b0
         zxHm0vxuO3UBNOreIWczDZWb7DGxcTfsUT70aqQZMcWZFnMDpHJWnt5U5Yfvr4dpsRNW
         EcgektkPrV18yowxRdzR4mDfQaWqh1pqp3jdVF9/u7tq3KlTv2w/3ufR2bfSlUdAuOzw
         3U4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976494; x=1777581294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fdJLrTxdQHuW/q5XioIV4K0g79ptTVlTBoTPrKNx/x0=;
        b=r5iYitw/2T0qjnWYlu5RzhP/ltjvd9/zC7DnZh+d6yAocLOeuxYy6gN12MOzLbesCB
         rZ7D9qsFX143O8MPMhxgkzQU8gVlnJz91wTKcwRt3VLe4KxT/xHVzrbo5on8iDodls92
         2w4PKyXXs+hbQ1JDoDL7g6wOR849/b+KARukfqz9NQ3RzuA/Y4R55ED1sobISOtCDIhi
         1vyRC0vvRKffIT+U/rDsquVQ0ivgOvqtqIJSoiTY9QG7x+3s2f42ansVdMRGJGm7xf4j
         3hJ3zXvx2tNu1dKq2vyukRRGbHl0ToQExp/nw5hdDLGUuYWmKMrdRqhUofUE7xbSrV+h
         uymQ==
X-Gm-Message-State: AOJu0Yw/p2kQIoyj1h7kMAnslwR9Y1oD1hyUDEaz6GFizCemz48pfQDB
	G3HAKgh48ItoGSS+oqiaet+kT16nPfioTdSm/73lMbv0d6QWWmv5+H13tsVMBQ==
X-Gm-Gg: AeBDietB9Pc9cx0H139pQPIuLGQFZ2QHKka0tGwXXNy7alXdCkw9AnXUuMAuPrcCQc4
	mnkqU9EHklxzqpcuR1nQJ/cqfUY5YCtQ76a79fyVHJI1QuVEIsNqJXFyZ1DOxmESUrXx/HXR2aC
	Yyp+CZmx8+3odudT1PcvVY3W8bagnUExeyK2H9icscqqFej+uQTdnZYB+Lq7GUZNNJuwXL3sgbn
	kP4A1jivAjzdBLA81JyWbvjo8dGuDcqpk3Mr0gftTACYOAwhTahgdYEIaT5UR4FuxvET7iUvarf
	IbwXRd39qu9puc3/pR9Bv/QW/gPDnG/F88nEi+8yXreGMz+3xlwNzBEjE7EiKF4w8iRlJoqL93V
	gQjk95StFuwIv3NJjVCZUBd/7NzTzcIR1mIljNJBAUqFWdVhp2FDlIFZkbKBF5nlsLmGKymCyUl
	rUbC3ESKXab33y0jbyVmBOQGbNCC2B0D2po1KjT0yamA==
X-Received: by 2002:a05:6808:4f53:b0:467:58e:5d4b with SMTP id 5614622812f47-4799c8809admr14587198b6e.20.1776976494595;
        Thu, 23 Apr 2026 13:34:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-479a0169edfsm13908805b6e.9.2026.04.23.13.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 5/9 v2] mm/memcontrol: Set toptier limits proportional to memory limits
Date: Thu, 23 Apr 2026 13:34:39 -0700
Message-ID: <20260423203445.2914963-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EA453140002
X-Stat-Signature: ff3qmam4dk7j3i9amzkrknwcm6wke1pr
X-Rspam-User: 
X-HE-Tag: 1776976495-113272
X-HE-Meta: U2FsdGVkX18H5VxLQmKgF2yv+Fb48Gk9mgRPzAkH3pJ88tRFG11GIn3JbGwpyJUPyQEOEa6HusSCpfB8uHaR/qlZsVLYeen7e/15jk9lBHAVAOnzHPotAJR3yadXqpkVEGn+swP+u/BggHbUKT2CLKRKY5plKkXG5OjhBDO1LlDcRSBRr87NJKR+/HnngxZh6x0qYylazVTXfejGUcm7TFnLiiwLV2nRRFMNSZQE8IliZW7MLnMAUl8gsvebqb8vj6DHa0htgAmZJXeVV95/tgD59loKIGGBVWdlrEDjwd9uQIHS1RGXp70Z6IaX0WfS6uT/Ek0EgCEi5BAkkV5wNZqDlqA+Rx/ByN+1nk2W26Lhn5l+Kh6WiN+D0LEwfYisaQh2RowBJBW2iHXNGdqJZwr0Dwo4i1xjQn8A63jwmk1swqFU/c5+F8+eLQ/uo6Ry1AdnqQMGW4EQQJxVd3aquXTbMbBplrDaEYUnQc0nQ+sru9NyevPrKs0ETgsvicCzG7ZGWsURGQ80Glw82KRmsP8TkG65ZRzmj2bytaY/5JpAZxGEmk65e86AvCmc8YIeOZfveMwuTvIe8LA57b8Dp05J6+46D0bQA9yV5jic7MBrAoS5mhwUEwS7ZmMgH/H6gYDh5BM+xFKA4PGgFyNWx+QIFDdvKpLcCBmceTcwCavrw9K4LunggG2Knyja1dn/AtdZeIhI16DFN+2+JWNl4AZbJufOCiovpB9XnNTiN0Nz7l5i1+GdV5mMdOm+iWTXoVjbix0XP1Hy1HTJkUijw48/ES4cKMFvK8yhFUTTacEw9aE8m8mifWehohKSrqnm/dbMATDifjXqy64RvzMeqGqWSdwt1Ocqdi8YjwvdCiiv/2e/j2xS/Pk7cT19TsR9wm1KQW3b5t9cELDkeAW69LxIw6F8uqaCg1SJC1qPXZd9bHm7Dfp4rd6CC7Tq/WxRvp93M6Bbj+mZBwkwp50
 lnZe8Bvw
 M3VNtDfnH9EP2P7biPcsoDhllJN//Tpkf9VlAK3krRyu9PENrrzR4LMsEw24BItMyb9h/SFmKq0hLGsTPj1fqo599QAC0S1gWcCiDqLS2qAWlW4005nrGVe8L+HoOzJeZNt3VIOZ1h8iirEv1Wscvk8nMbwn5A/3XmAPboOvzBzSZmRirbh7ziaoCjlBML6YS4VVZsshJufIx/3H7ooG9DRcT3YqHg+gT6iaAR0UPlJTlSv+ZDWx267KB0nVQQxEq3YE2VWyd50Ksf6PwXBF/QUC4PfJXNO5bJ6pt+3ABQ7OdOad5jIf73ZuKqrXn2t8I8I8USvGpjmJ0jNDIYza3+RziWLZoxCdF4bNPfvQM/A3ZnOsVjQrsz031L6rTGougXHM+xICJ9VOpGEjq3zIPK0MvmS0sI6sxzhrQ1ExK04h0uSclqXc4JL36/1Vk2/4sH3aBzsgTqZ7R70OLalX8eckIoWQ8ImA6SM28608Eu6YBOSPeBDy+1aUhm/Vz90GjkCjeM47AYrt55A87WaQxadaXJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compute proportional toptier limits based on memory limits when
users write to memory limit sysfs files, or when memory hotplug causes
the toptier capacity / total capacity ratio to be shifted.

Also introduce new read-only cgroup files memory.toptier_{min,low,high,max}
to expose the derived toptier limits.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 12 +++++
 mm/memcontrol.c            | 93 ++++++++++++++++++++++++++++++++++++++
 mm/memory-tiers.c          |  8 +++-
 3 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0cdb6cd1955dc..6bcb866440075 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -543,6 +543,14 @@ static inline bool mem_cgroup_tiered_limits(void)
 #endif
 }
 
+#ifdef CONFIG_NUMA
+void update_memcg_toptier_limits(void);
+#else
+static inline void update_memcg_toptier_limits(void)
+{
+}
+#endif
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
@@ -1099,6 +1107,10 @@ static inline bool mem_cgroup_tiered_limits(void)
 	return false;
 }
 
+static inline void update_memcg_toptier_limits(void)
+{
+}
+
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d891cf77cf6d6..3acb06388405c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3875,6 +3875,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_set_high(&memcg->toptier, PAGE_COUNTER_MAX);
 	memcg1_soft_limit_reset(memcg);
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
@@ -4092,6 +4093,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_set_max(&memcg->toptier, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
 #ifdef CONFIG_MEMCG_V1
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
@@ -4100,6 +4102,9 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
+	page_counter_set_min(&memcg->toptier, 0);
+	page_counter_set_low(&memcg->toptier, 0);
+	page_counter_set_high(&memcg->toptier, PAGE_COUNTER_MAX);
 	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
@@ -4438,12 +4443,51 @@ static ssize_t memory_peak_write(struct kernfs_open_file *of, char *buf,
 
 #undef OFP_PEAK_UNSET
 
+static inline unsigned long page_counter_max_or_scale(unsigned long val)
+{
+	return val == PAGE_COUNTER_MAX ? PAGE_COUNTER_MAX :
+					 mt_scale_by_toptier(val);
+}
+
+void update_memcg_toptier_limits(void)
+{
+	struct mem_cgroup *memcg;
+
+	if (!mem_cgroup_tiered_limits())
+		return;
+
+	for_each_mem_cgroup(memcg) {
+		unsigned long old_min = READ_ONCE(memcg->memory.min);
+		unsigned long old_low = READ_ONCE(memcg->memory.low);
+		unsigned long old_high = READ_ONCE(memcg->memory.high);
+		unsigned long old_max = READ_ONCE(memcg->memory.max);
+
+		if (memcg == root_mem_cgroup)
+			continue;
+
+		page_counter_set_min(&memcg->toptier,
+				page_counter_max_or_scale(old_min));
+		page_counter_set_low(&memcg->toptier,
+				page_counter_max_or_scale(old_low));
+		page_counter_set_high(&memcg->toptier,
+				page_counter_max_or_scale(old_high));
+		xchg(&memcg->toptier.max,
+				page_counter_max_or_scale(old_max));
+	}
+}
+
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
 		READ_ONCE(mem_cgroup_from_seq(m)->memory.min));
 }
 
+static int toptier_min_show(struct seq_file *m, void *v)
+{
+	return seq_puts_memcg_tunable(m,
+		READ_ONCE(mem_cgroup_from_seq(m)->toptier.min));
+}
+
 static ssize_t memory_min_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off)
 {
@@ -4457,6 +4501,9 @@ static ssize_t memory_min_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_min(&memcg->memory, min);
+	if (mem_cgroup_tiered_limits())
+		page_counter_set_min(&memcg->toptier,
+				     page_counter_max_or_scale(min));
 
 	return nbytes;
 }
@@ -4467,6 +4514,12 @@ static int memory_low_show(struct seq_file *m, void *v)
 		READ_ONCE(mem_cgroup_from_seq(m)->memory.low));
 }
 
+static int toptier_low_show(struct seq_file *m, void *v)
+{
+	return seq_puts_memcg_tunable(m,
+		READ_ONCE(mem_cgroup_from_seq(m)->toptier.low));
+}
+
 static ssize_t memory_low_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off)
 {
@@ -4480,6 +4533,9 @@ static ssize_t memory_low_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_low(&memcg->memory, low);
+	if (mem_cgroup_tiered_limits())
+		page_counter_set_low(&memcg->toptier,
+				     page_counter_max_or_scale(low));
 
 	return nbytes;
 }
@@ -4490,6 +4546,12 @@ static int memory_high_show(struct seq_file *m, void *v)
 		READ_ONCE(mem_cgroup_from_seq(m)->memory.high));
 }
 
+static int toptier_high_show(struct seq_file *m, void *v)
+{
+	return seq_puts_memcg_tunable(m,
+		READ_ONCE(mem_cgroup_from_seq(m)->toptier.high));
+}
+
 static ssize_t memory_high_write(struct kernfs_open_file *of,
 				 char *buf, size_t nbytes, loff_t off)
 {
@@ -4505,6 +4567,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_high(&memcg->memory, high);
+	if (mem_cgroup_tiered_limits())
+		page_counter_set_high(&memcg->toptier,
+				      page_counter_max_or_scale(high));
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
@@ -4542,6 +4607,12 @@ static int memory_max_show(struct seq_file *m, void *v)
 		READ_ONCE(mem_cgroup_from_seq(m)->memory.max));
 }
 
+static int toptier_max_show(struct seq_file *m, void *v)
+{
+	return seq_puts_memcg_tunable(m,
+		READ_ONCE(mem_cgroup_from_seq(m)->toptier.max));
+}
+
 static ssize_t memory_max_write(struct kernfs_open_file *of,
 				char *buf, size_t nbytes, loff_t off)
 {
@@ -4557,6 +4628,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		return err;
 
 	xchg(&memcg->memory.max, max);
+	if (mem_cgroup_tiered_limits())
+		xchg(&memcg->toptier.max, page_counter_max_or_scale(max));
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
@@ -4762,6 +4835,26 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_max_show,
 		.write = memory_max_write,
 	},
+	{
+		.name = "toptier_min",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = toptier_min_show,
+	},
+	{
+		.name = "toptier_low",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = toptier_low_show,
+	},
+	{
+		.name = "toptier_high",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = toptier_high_show,
+	},
+	{
+		.name = "toptier_max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = toptier_max_show,
+	},
 	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index acc02679e312d..ddcc11e3919da 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -924,15 +924,19 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 	switch (action) {
 	case NODE_REMOVED_LAST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(nn->nid))
+		if (clear_node_memory_tier(nn->nid)) {
 			establish_demotion_targets();
+			update_memcg_toptier_limits();
+		}
 		mutex_unlock(&memory_tier_lock);
 		break;
 	case NODE_ADDED_FIRST_MEMORY:
 		mutex_lock(&memory_tier_lock);
 		memtier = set_node_memory_tier(nn->nid);
-		if (!IS_ERR(memtier))
+		if (!IS_ERR(memtier)) {
 			establish_demotion_targets();
+			update_memcg_toptier_limits();
+		}
 		mutex_unlock(&memory_tier_lock);
 		break;
 	}
-- 
2.52.0


