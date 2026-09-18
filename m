Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F71C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882E56B00A4; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8599D6B00AA; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796526B00AB; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 587AA6B00A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3570A0602
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:02 +0000 (UTC)
X-FDA: 85226333724.28.3BB6291
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA5DE14000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B8LdeBNK;
	spf=pass (imf26.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723140;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p16IolOPsQCV+Izpuow/gQLlAdei4JmWBIR7EBuHkSA=;
	b=fPmlfNnprDyA+/LDlb8R1YRhRB1op5SX/JZ+FzLUQMvMd/qGcQAGMMXraHISVN6jOLa5eJ
	Plq9aBzKQHo1FHjwC2Qp8V+/NLSC2i2GZuEAtVD7pj8X2WrfCcj3aT1JTBrTpShT0pgXgr
	ca4uc7m0kThQD04QpDBitwDUMPOzblw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723140;
	b=gEP04OJmrAiEmnAFlvqHowUmEKKfxqZND11Y6B+TTcNR4Gx3YOz73Mn46fdB0W0oAz83G1
	SlDhpoyGFRgtg5LHAstbwWQoxgqHa+DQwYC5QY6kGEYGym4o+BBHT6thFp5gjKSXPYA4nX
	/5YAF6/tWUHqnTyr14CO8DkYbah0m+E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B8LdeBNK;
	spf=pass (imf26.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FB8A42B39;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E65F2C2BCFA;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789723140;
	bh=hP6DiKHP1Uc9RaIourNerlT7Ph3Y4wow5AD623XN+Q4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=B8LdeBNKdJ3wtDnDHMchqGFjCuVjH+ToJvR9NcjyNddJoI0ChMUK/+FuRdpLmhLZc
	 yhUJ/YGWXVDH+Q1wpphFoz9r0SXG+09ZwHeC5XE4+PVK4abKNq7xBKL+zynXwRsLWr
	 Gem1ckC/EH5GRXhMMYols2acGK4bz9v2vXI36LJ3qbt0gm2KLsmVqyJPoNI0Ls6QCv
	 qIfAtfAtBqWUSXma0Sdhn8aOg79DsprrH1jzJovrb/W1YlDRkmI178pdoAC9Tlf+5O
	 KpBss+BXIOD4xBFxtHQUPoExPpiWJ2GjEltHUMGcCqcAtXoNhifvG73+P5T4B+5Z3h
	 AichhMGyW0G3w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8875C982DA;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 17:18:41 +0800
Subject: [PATCH 2/4] memcg: base swap charge accounting on memcgid root
 status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-bingfangguo-memcgid-rework-v1-2-5bbf3220d88f@tencent.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789723137; l=4703;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=keWbZOvEsjhpQI5UWIYf9RawqjSwL3RBr8uJHFAQWMQ=;
 b=spR77VUIfZyg808RonfMqNMBmWjRn22uOgEi75/oCt05YRBn5v7VOpT0U5xctGim4lOhcb34P
 9tx7NAgCxj3CKbd26yb+ucyOUe/EXqt7knbMtop9nI0dd3yyJH4dRvV
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: t6r1f13arwtr5qaczpztrepxmhfdkqg6
X-Rspamd-Queue-Id: CA5DE14000E
X-HE-Tag: 1789723140-910276
X-HE-Meta: U2FsdGVkX18bbAsKIGl+RlWb2azr58AgHMBMCAViza/xZoTVqtQEU28lh4bexdwROhocI8ZAnySuy+21PzbW5URbga2vFjqzkD+MaWIRjw13j7aWl6fo5zH52DKvy/WC5ns8PPUHPGiv0fuGfyJKxxFQztxf9Y1Rh+Ly/MuYL+M50vM/uuwZgK17YXyEevxrfoZgSdorC+LN5vMCiUz0CXbrtiM+TvP11SqvFas7iZrh7hlJ1Vb86dIvafzx9ia2uuYkq5L4QASJ0zaqJaLSvLsFxMXtQQm5/eR9f5wyao9+HFb/KezyTpRhk9VNMLVOuki8sWHD4JWWW//rEX71q5g6QOl+O3Wzv6MPKPykfwrXajqBIZfWQBXeM0wbM9kBWtv7SKEMcttnvSbVKYU6McQbh2FoYyCSsMmlQWj5MQ1hsMkSSyFEYLdEzjpv9vOv8twZlD14DABkURtAD92D/Scp7kfbnnQDti3elt6zMnAvlt03H0rxREe8aYhKzlWBKlYUGe9sFVxh9h/XNwHtoUkUyk8zySzxMfvenD3UH5sogqDfnNX2fDhQqcdukTijgPnyyYjYDwobk0fp33jCtgO2XSoHtQAMxqDnqVEmr1sTPDsv0lMhTU2mFypc5bJvgyGGpmNjZp2x3xuR+Mkc5Dql0inqw4+cnJ1pEZtCCbBhuF67X6k/HiFHYj67hjXhRzpbAZy7XumKnHIKCpMMaHB6Crq0thPqkhF4ln+LutSXqnqp9dnURumiPEmGlSJjAI+0Szq13VJXtw+QFY7pTKyD+WTu5OmGIZyuncn3YX7sGF0neS05prExqztNfZS3IEfHZqgu4KuaZa/AVRjgbCIML0vGbN7pp25kYx5mZ+l3/b1hh0sGwkjAA/V9BzfzzV10SKN6QqjOcD6/oMrRxBMrITbm6WuSkr4wp3F1uuUqtMPkgswsY3ucUJxMACB/mr4wgpCE8medJvnF8cj
 ysMoD3Th
 gMXYzIsJczLYaxe54d7f2gUbiLqgk8ohkyFxjbco5W8wv/bYN21UlTS3gIkayTR3Aj+iKrlXhv91sxDM+SBBlJRkx0N36UuqO0slJFwLd0l5gG0z5IPp1ReqkitjJp/SFDtH/tbpGUUA/j1FBuYgxj4b3mDt3poUhM7M98910nWnpRslmUSpXGacPAgsfG/OieQ8r3agikf+QEUWU1P+Bny2Gag5JWR+KPGDoYkS432nYtLWnKTGo1It2DS6MUlF0EkpvUyj+rHEyahJF6tIF+4fsPd3OH/Y1yKnsr7MQUPOE08cJkQUxJJTNDDMFd7mo3ozqAYj3Q9GDPSwlqDc6DdVcWFDHern/EuZ2k1exSwKgQMInobaWxRWvs0oMA5qRC7cTzoJqT7EhNkjHAqkaJbJSEV8tXJXzwMY0+Q0/sL9a9RQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

A private ID currently pins its original memcg, so testing whether the
ID belongs to root is equivalent to testing whether the resolved memcg
is root.

That equivalence will no longer hold when IDs refer to objcgs. A
non-root ID may resolve to root after reparenting, but its swap entries
still carry counter charges inherited by root. Skipping their uncharge
based on the resolved memcg would leave those charges behind.

Use the private ID's root status to decide whether a swap entry carries
a counter charge. A root-ID entry carries none, while a non-root-ID
entry must release its charge even if its current accounting memcg has
become root.

This patch adds a new helper to check if the memcgid equals to that of
the root memcg.  For swap uncharging and v2 swap charging, simply decide
whether to charge/uncharge memsw or swap counter based on the swap
memcgid is root or not. For v1 swapout, don't recharge the memsw
counter, just cancel the charge if the swap memcg ID refers to the root
memcg.

This makes memory and swap charging have similar semantics: one relys on
the objcg's root status, and the other relys on the memcgid's root
status.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol-v1.c | 16 ++++++++--------
 mm/memcontrol-v1.h |  5 +++++
 mm/memcontrol.c    |  4 ++--
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b1..ed015fdd95123 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -271,6 +271,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	struct mem_cgroup *memcg, *swap_memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
+	unsigned short private_id;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -293,25 +294,24 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
-	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 * ancestor for the swap instead and cancel the memory+swap charge
+	 * if the ID refers to the root memcg.
 	 */
 	nr_entries = folio_nr_pages(folio);
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
+	private_id = mem_cgroup_private_id(swap_memcg);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
-			  mem_cgroup_private_id(swap_memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
 
-	if (!obj_cgroup_is_root(objcg))
+	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
-		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, nr_entries);
-		page_counter_uncharge(&memcg->memsw, nr_entries);
+		if (mem_cgroup_private_id_is_root(private_id))
+			page_counter_uncharge(&memcg->memsw, nr_entries);
 	}
 
 	/*
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 2cd37e1792d79..23be2512702dc 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -22,6 +22,11 @@ void drain_all_stock(struct mem_cgroup *root_memcg);
 
 int memory_stat_show(struct seq_file *m, void *v);
 
+static inline bool mem_cgroup_private_id_is_root(unsigned short id)
+{
+	return id == mem_cgroup_private_id(root_mem_cgroup);
+}
+
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 72522ec827c9a..bfe53e4392f09 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5976,7 +5976,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	/* memcg is pined by memcg ID. */
 	private_id = mem_cgroup_private_id(memcg);
 
-	if (!mem_cgroup_is_root(memcg) &&
+	if (!mem_cgroup_private_id_is_root(private_id) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -6006,7 +6006,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
+		if (!mem_cgroup_private_id_is_root(id)) {
 			if (do_memsw_account())
 				page_counter_uncharge(&memcg->memsw, nr_pages);
 			else

-- 
2.43.7



