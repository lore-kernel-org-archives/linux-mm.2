Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014A9CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 07:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A37F8E0007; Wed,  5 Nov 2025 02:50:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A898E0002; Wed,  5 Nov 2025 02:50:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0917E8E0007; Wed,  5 Nov 2025 02:50:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA0228E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:50:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A79A514021C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:50:02 +0000 (UTC)
X-FDA: 84075779844.22.EBA37F7
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id CA69440006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 07:50:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=fOpg6INb;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf12.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762329001; a=rsa-sha256;
	cv=none;
	b=Syhyk6mrS66cJ2LAJ+DuHIEUofx15sd7x71hKyEqlJfkATYrLGZdhPqmIDuvDRj6p01610
	QeTk3JinD2up19RK/zUCumNNcrSerSsWHP6X29OKSKHh9WDO8lYnBnn3LIz45lGi2k1aql
	LfdTOeS0Enn19XCGT04ZpOC87RpyLSc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=fOpg6INb;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf12.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762329001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h6ZDRkftaiRuIaXsVQnD3pYoLoBZQe+K8uOwtjlQzE0=;
	b=F+wWvw9QrTK+ewpclRQJuRThOxo/UGVMbo6Dj40jOSO4Y73VIbjlN4d9R4QaAtRGDDY1LK
	paX1StyCmsYOwxca609MU60Tz4y1rdahLKt6LjhpmnGxnbMHyYJ6oEYzKGsi80iLeF0iOV
	eC6ZHEPTCNAC68X7Dr8vFRW2MLWfFtQ=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27d3540a43fso64517885ad.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 23:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762328999; x=1762933799; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h6ZDRkftaiRuIaXsVQnD3pYoLoBZQe+K8uOwtjlQzE0=;
        b=fOpg6INb+JL9WN5HXwtQNcgF4PVwBil77H7U9/LKj2wz+ikkXBYXjiJk5j6Z815Ad6
         J/RalW3oiJ1c6BY1A19zMaAoURwb2OdSYJTa7vyRvgtJ1YPgS73uulu6YDI6+es7070V
         K/EL2RMvpeCc+MpJ5s4j4W0q0PtQd7D3k4PpaSRDZzFKwinWk+zYhUYqTUgb8sS/32es
         mXaM5B1q2mkfrruqKkUhwz5xV0YZdiIQfeyPTCoalY8oIOWwL9wGvy/yveI6I1gLzeHB
         5PwF8+LDk0ggEHudSP5tVkjPB30ViOjS+XR8EGq2fiFWxBMel+5VDt3qP0qCUSpg8MAU
         bAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762328999; x=1762933799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6ZDRkftaiRuIaXsVQnD3pYoLoBZQe+K8uOwtjlQzE0=;
        b=SbEXP24jAd0Cx6GpFKGxJLi4zNDL5DI02jpdehatxMhvPs07Qu0lsJY72oxdwPQvBT
         sYLInuAmQi5yelX5i5VUWWvu1A8uga7Ou7ffaZvoQFy8U9K3z/jZqDr8ec5StuX1qBER
         nKXP3ksAl5ue8D9iEC8wk5cilsR+C1eGiXamTO/YM1undkeDx16f7rNHUKeAAAyYJMgV
         zHHeicY5xPq8rhQZK85ttE4UZfD1uOGM8odi+3wd8f3OnxITeI3jRNiAYfgwUW8x0MIe
         gEJRSNPTk8LHZG1tsYKu5KaQ4Arh3Gm769kD9H1wDX+rysXkrOywOhgtlqXXI5U7EeoO
         jwMg==
X-Gm-Message-State: AOJu0YyBRdaOOJGHFXq4zMwvlUrxwrafs9S6reg3HlyXyD8yfq6O2d8n
	fpgp2PSzMF3dBYnPni1NJZ+1ecI4p2+Xzet54TKxXP1trwRPO8/tGhVbciwUr5k5e0Nsr30T1Kz
	oAdhfvuXnTsLVEQ/KJKPvafhvJNWxYCQV4JlhL4cVJ0L1hltKovPJvUdRaV9H0NTJHPQDT+W0P5
	AE5FoKXWJMNrvTOjrh15+q8hGiVUM0fYYRUiDT4WPI21g=
X-Gm-Gg: ASbGnct0rsI4EfOwbTnyWX3eMk7kL3m5qoUiO25YNs/YsJpOldtYTFr5IjI4mc1M9pD
	WdDsujR6P7vorvtnlnAA9oUFD5IWsWimwGvkLi+z+XN1BfwUamdo4elONv5qyLQ6WT/N1EwiIa9
	ctlJLufZNV69wzKAy1cI6jHn8iWXdBMvcBwr87i26YuuN7AM47+G4619uE/tusjzIlgstWL1wg1
	9RoM88Er+Hkyc2Gfb3cjB94coYLxlGepNK0HdxNdQmjE+aFvRBYbfWVecn3ijaQHHPzHVsZxR70
	i8CyVlcKqw1QO9OZ6u/+5pgUd6E/c/rBQv4tNjJH59Wn5248XUqYdJVP3EQ1+BiybMQUlKRJyUG
	WayhYVuU/qL8BhATy0uTFFo1FC0aE0MzXHoHnM8Dm07Ckcz9bW1cUhGApiQkr4egSPTQHDcX/h0
	B5h4uetuxushZcUt8A4pXT0mal
X-Google-Smtp-Source: AGHT+IHKjbv/6sAUPJqMP9Dl0+FTFfNEli/mX7VCSD5WGbBzuqeNeE5PeGE+njoNMn23lIVIEk6Frg==
X-Received: by 2002:a17:902:ef49:b0:295:4620:3e18 with SMTP id d9443c01a7336-2962ad2b255mr39869055ad.24.1762328999123;
        Tue, 04 Nov 2025 23:49:59 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd6a10f8fsm5295564b3a.68.2025.11.04.23.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 23:49:58 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	joel.granados@kernel.org,
	jack@suse.cz,
	laoar.shao@gmail.com,
	mclapinski@google.com,
	kyle.meyer@hpe.com,
	corbet@lwn.net,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Date: Wed,  5 Nov 2025 15:49:16 +0800
Message-ID: <20251105074917.94531-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA69440006
X-Stat-Signature: gxzpia3dtbm6sigcj5y8cn5mohq5wacp
X-HE-Tag: 1762329000-919070
X-HE-Meta: U2FsdGVkX1++bJRIzPSGUH0f3ymc5/+VksJw7e3kk2dMJFOeUxgQ7gqcZaCwCjNhIMfLEEp8JjAQ2j86d9eb+/EIhrG/uquAZrmimqM062x02q300awISAnjnWPeHzTZWDvzbGHNWGjmwvtC7wxRZ4lBd0Z7LLHso5JSZ1SBNT5ycHX3HEFa26p2LzdSpaFUbE+nsgBbCk8cVkOpPwe60uLupWVBECSrksKfx1EbbhdPZ2HD1g5wrrgj2ABWzQaXkbs39PkiqMaAApsz8cXcoL2qCudah8SXMTiIyksYi130u6KlkWVp02L3Tjm+NaramrNEJ/rTUphxIk27M3DY8AgiiJcRUqVtitdwzv8lx5vzXZnLwsSXm68iB3F4D51+Pmn+CtxG8FfcjfCxwqMWqUo77/oWBVigYGnKY73w7DGF3692kXeTvZWeWXWStXWCcBrG9yHhd+hEN18h+SK+YU7ZXHEGQssOj20Ukb8MNuWCYLpg0y6I+4zo7yVN7k/y9ycpBsAL1vr+KApBNFBM+YuuQHShFUCJsjkd00Nbk/Llgvco4gcwMTLu+3MlqPvcYsUhhqO71b2JE/DIaujkeVDxVGyXdRzSj0iMYLxO/iSVnJdrPE9oQghMvNlHXJ4PseY6QPQFLWt0JGKpCwfjNYUmxKaftW3CORhP9Q0UxiGpNFMkO3ibSDLwgw0gATC1Ecz3vUXj3rbaf3s2qqc4lV9n7NkDYA6231rAfxObYjEyw1pzWJWimjLmO+cZqxQKeC644jlaOyE8lkmwQHJS4xossFbf2COoNRNc9/77t6vLBuGsbiA/RLL5k9qpCZukgM9E1Dy49FoutgYstHc+MjFoOaYvC91Z9DAnf3NtlGdsEV7YxxNH99HhMrOc55Kt30PpsT6vYeKnk5bZxtsyZmIQT80BL7kKdiWXBy7aI0NjXaJhlU1mx7WBel7tPWYlL2n648uuqGI0CBiaJPr
 AcJ1Rn2T
 1PvJJu9qrnvTEq+RwD/4MenquERFVzLfw06LgcpnM9l0RSJLNcw/CQEsVZMys23zKjYiETAufSb3C+Bu49AGlj1WAfVArxFarh21ziPfXCj1aGDIixdyomqvBo1DUnjxMYYmEAGQE7kKLG91WSYeSLAN62PBl4zJ5Z8/EPqVDGjvxvuKxIw497NEHNDmQU5WnTkDbEaJnlIIvPlXwL69JQA/QW5hCsM3Xz3atoLeJnb5TUOsNAx70IWt21eX0GdN/KbepEz/UyoM6JOfUQo/G8m1CKJwUB4/luyKd9FOxMazd7kzEjh6f7bj23gw4jlZWJ1Ue8gYwKKgz+oH+lcb09/+PA521gx4K40zrzfvzIODpPmNsJyFE1HQmAHaqMOY/KovCs3p/N0Yna+Cc0LxZiTN0QvU6EFAkf3naEWeZy1ksatc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On high-core count systems, memory cgroup statistics can become stale
due to per-CPU caching and deferred aggregation. Monitoring tools and
management applications sometimes need guaranteed up-to-date statistics
at specific points in time to make accurate decisions.

This patch adds write handlers to both memory.stat and memory.numa_stat
files to allow userspace to explicitly force an immediate flush of
memory statistics. When "1" is written to either file, it triggers
__mem_cgroup_flush_stats(memcg, true), which unconditionally flushes
all pending statistics for the cgroup and its descendants.

The write operation validates the input and only accepts the value "1",
returning -EINVAL for any other input.

Usage example:
  # Force immediate flush before reading critical statistics
  echo 1 > /sys/fs/cgroup/mygroup/memory.stat
  cat /sys/fs/cgroup/mygroup/memory.stat

This provides several benefits:

1. On-demand accuracy: Tools can flush only when needed, avoiding
   continuous overhead

2. Targeted flushing: Allows flushing specific cgroups when precision
   is required for particular workloads

3. Integration flexibility: Monitoring scripts can decide when to pay
   the flush cost based on their specific accuracy requirements

The implementation is shared between cgroup v1 and v2 interfaces,
with memory_stat_write() providing the common validation and flush
logic. Both memory.stat and memory.numa_stat use the same write
handler since they both benefit from forcing accurate statistics.

Documentation is updated to reflect that these files are now read-write
instead of read-only, with clear explanation of the write behavior.

Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
v1 -> v2:
  - Flush stats when write the file (per Michal).
  - https://lore.kernel.org/linux-mm/20251104031908.77313-1-leon.huangfu@shopee.com/

 Documentation/admin-guide/cgroup-v2.rst | 31 +++++++++++++++++--------
 mm/memcontrol-v1.c                      |  2 ++
 mm/memcontrol-v1.h                      |  1 +
 mm/memcontrol.c                         | 13 +++++++++++
 4 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 3345961c30ac..2a4a81d2cc2f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1337,7 +1337,7 @@ PAGE_SIZE multiple when read back.
 	cgroup is within its effective low boundary, the cgroup's
 	memory won't be reclaimed unless there is no reclaimable
 	memory available in unprotected cgroups.
-	Above the effective low	boundary (or
+	Above the effective low	boundary (or
 	effective min boundary if it is higher), pages are reclaimed
 	proportionally to the overage, reducing reclaim pressure for
 	smaller overages.
@@ -1525,11 +1525,17 @@ The following nested keys are defined.
 	generated on this file reflects only the local events.

   memory.stat
-	A read-only flat-keyed file which exists on non-root cgroups.
+	A read-write flat-keyed file which exists on non-root cgroups.

-	This breaks down the cgroup's memory footprint into different
-	types of memory, type-specific details, and other information
-	on the state and past events of the memory management system.
+	Reading this file breaks down the cgroup's memory footprint into
+	different types of memory, type-specific details, and other
+	information on the state and past events of the memory management
+	system.
+
+	Writing the value "1" to this file forces an immediate flush of
+	memory statistics for this cgroup and its descendants, improving
+	the accuracy of subsequent reads. Any other value will result in
+	an error.

 	All memory amounts are in bytes.

@@ -1786,11 +1792,16 @@ The following nested keys are defined.
 		cgroup is mounted with the memory_hugetlb_accounting option).

   memory.numa_stat
-	A read-only nested-keyed file which exists on non-root cgroups.
+	A read-write nested-keyed file which exists on non-root cgroups.
+
+	Reading this file breaks down the cgroup's memory footprint into
+	different types of memory, type-specific details, and other
+	information per node on the state of the memory management system.

-	This breaks down the cgroup's memory footprint into different
-	types of memory, type-specific details, and other information
-	per node on the state of the memory management system.
+	Writing the value "1" to this file forces an immediate flush of
+	memory statistics for this cgroup and its descendants, improving
+	the accuracy of subsequent reads. Any other value will result in
+	an error.

 	This is useful for providing visibility into the NUMA locality
 	information within an memcg since the pages are allowed to be
@@ -2173,7 +2184,7 @@ of the two is enforced.

 cgroup writeback requires explicit support from the underlying
 filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
-btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
+btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
 attributed to the root cgroup.

 There are inherent differences in memory and writeback management
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..8cab6b52424b 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2040,6 +2040,7 @@ struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "stat",
 		.seq_show = memory_stat_show,
+		.write_u64 = memory_stat_write,
 	},
 	{
 		.name = "force_empty",
@@ -2078,6 +2079,7 @@ struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "numa_stat",
 		.seq_show = memcg_numa_stat_show,
+		.write_u64 = memory_stat_write,
 	},
 #endif
 	{
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..1c92d58330aa 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -29,6 +29,7 @@ void drain_all_stock(struct mem_cgroup *root_memcg);
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
+int memory_stat_write(struct cgroup_subsys_state *css, struct cftype *cft, u64 val);

 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c34029e92bab..d6a5d872fbcb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4531,6 +4531,17 @@ int memory_stat_show(struct seq_file *m, void *v)
 	return 0;
 }

+int memory_stat_write(struct cgroup_subsys_state *css, struct cftype *cft, u64 val)
+{
+	if (val != 1)
+		return -EINVAL;
+
+	if (css)
+		css_rstat_flush(css);
+
+	return 0;
+}
+
 #ifdef CONFIG_NUMA
 static inline unsigned long lruvec_page_state_output(struct lruvec *lruvec,
 						     int item)
@@ -4666,11 +4677,13 @@ static struct cftype memory_files[] = {
 	{
 		.name = "stat",
 		.seq_show = memory_stat_show,
+		.write_u64 = memory_stat_write,
 	},
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
 		.seq_show = memory_numa_stat_show,
+		.write_u64 = memory_stat_write,
 	},
 #endif
 	{
--
2.51.2


