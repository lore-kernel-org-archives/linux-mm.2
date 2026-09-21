Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE20C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD466B00C1; Mon, 21 Sep 2026 02:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384986B00E2; Mon, 21 Sep 2026 02:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C6F6B00DD; Mon, 21 Sep 2026 02:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F34146B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:16:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 051B2A6415
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:16:35 +0000 (UTC)
X-FDA: 85236760392.15.31982B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 04CD380004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B8/S9+vD";
	spf=pass (imf30.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789971394;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vB6vXkb7Z/8aY5/F3Xm6+oHs1JuHsWeIILbhyPJHGCI=;
	b=0RlDGGxnMRC3/8lPtAEuOSMr4SGIgKHOo6xFXBsX3zrRBaGhef6rO/GXN+Udj927/nBst9
	3m08qBn4qbgKGeGe5ivyl2ZaIIGRCb0K5jNa8XQ8+AGGX4gbLgpRSZH8zp91Un7GmPhdSM
	dLLK5rED0h/+00wktAhVzbTTeR1SS24=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B8/S9+vD";
	spf=pass (imf30.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789971394;
	b=T0ugwk1fEZhoiH6BMC3kT2brert0j/IjrWbGeA3VYArVx6ZELh6tLIDyPdPc7mbZ1hzhbF
	YnuogIp5Wb301HWZnNrugBfquaausGOZgpsGfUn1mJ4oQiakq5S+SC/9YcHalx0jIVOUUO
	Zfz/t3Lx9nFTFB7pli4oeF57B7NMxmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40DF244205;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11EDDC2BCFB;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789971393;
	bh=Z7oPMtzmmdxZysH8NfprVZtdImWm4xoqdqjiYrOmKrM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=B8/S9+vDvxGDAjUWVRIfABjPEBAjAy9Nm1hRE6d4sRCbnzlFCxEyTR+AP8bFKK4SM
	 /H7gQozKaAQVm5QxvCGbnbjJN8MMiOIB5hDooWErWbtjoS0xphpxWlR9cdIR9OjLzY
	 Smu5gcZhrumLDeTHLljK29B98Jzw3RJX53SqYF0Rj9uXAKX0PHhb9o/AK3BhUhRnF2
	 B7uJQKBqnxMQTai4JIBz8C0qO2kLbfuqjY0U4KNxCWVgiaS/OG6r3vXJ0GQiYHuW/4
	 Vki2HKmPu4ZQyl23/wDJpvnMtfsV3fgD5Y6YxfuNPAGgYJeTMHrCJLgU5QliqNBPLB
	 /qHVn30VZ6/4g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7756C982E6;
	Mon, 21 Sep 2026 06:16:32 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Mon, 21 Sep 2026 14:16:25 +0800
Subject: [PATCH v2 2/4] memcg: base swap charge accounting on memcgid root
 status
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-bingfangguo-memcgid-rework-v2-2-6c0637dc0edb@tencent.com>
References: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
In-Reply-To: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789971391; l=4757;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=9FAyfMKM+7unLAdMxjg2Op7yswvqwLDZxs1E3W/Lmyo=;
 b=DJXQvDM7Ki8+9464bK5faIcO6vt3cMKvvJ33Y66tpyyuAQyR1gRDHKvAv1MkCrl8UZpXxh0MQ
 BNC0qblHNNqC/SHLIKTKwIuhj7rHyNsStz7NfFvhohcYC5smbLkRYHS
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04CD380004
X-Stat-Signature: xjuxt7gug6g3xbwtx6anfhc6md6g3rwg
X-Rspam-User: 
X-HE-Tag: 1789971393-43164
X-HE-Meta: U2FsdGVkX18A6d4rqjRtJWEBYVHjyZCyLjNO0qv80cvf+NYp/RDHj4iOJMLdhlCv7n9EWZfEVBPrEb66Vb4h8FD/nUNYG13DdSBnr7iPdCihqB1xN5n3zUg7exZflecQSEavR98G4z0U8xEwlZNAWIMvltzNZYvlHjyikELrVHWjFWHRYJtIFUg7I3tpkGW6Utd3sSBNRL0bcsQIfMP53RieBZKODKouvLA6fEPV/yp2O8n+NV1TcynqF3YTHlrNqhSWTSuXmh/FWT7r20asIGo0tELL3m7fbRHYWPJE56U89ma8EI0Z8uh0hAFYwXqJtJDFG1Myn5Zi03rZxmj0DE4Vq7IZXtVPMrwJb5P1bAPO6ie4GtxoYS8SXIWNZH9iI8yyoS6jpakIui2llgtjfmLTeeLohraPtmLsdkBdmZBP9ZF2XxOTk/Pb/fP2cquL1gh92d3IUFF0L2RbfUG3qXq3ayrV40zGYrJ0XMgueG/4/weWjIZ4OzXQlY1O3E1bhzko3Q7P92b/e1TJxQep+zcavXjRHejUvQpshty/HoLarb7dsinqxqcAcVnN1ILn//aNm+REomLL7xQ380GeEfW4aZ7Sg4R1NitIfe5D/KJQUfe4L0GfGkCriHsqlL5OkwRi3lFqIP/2X8MCl6rtSfaLDUM5tVcw4q5n3ZgAhRS5NWrr4gbp8GYqv6bb0S6Q3grc2w7dp4UlTwLGnPog4W+JSmQODcuwEVYMiNHofkABua7hQ+BHDCVA3mgsHxiIgCavNGj5z1uqrom6Ok08uLgLdxpPesQyNw1UmnSfQ4OZKlg2T6gAc17xsz4I0/zxxr0ezFI5OFWB3Ktl8fnis0CvOpfGn+CI6x7wbOeHMTajJiPbM2yPytDaM9K1m9HSTFTekaMEaDAEOXbGTEmW7U/qMuXePo4NoGzbCGViTegk8BglYb8I5m6moLhI3dqUyOJ9JjWS0ZO5psD4ov3
 n9X9Ng8B
 9aNgxhUkewkoiTdIK8boL0YoI9bzbffE4pVFggqWdBpxNKvQlfP2B59tRH+QsO4dIq5mMl90nqw8nulLGO6epYXmqoObpFP6PArhuA4LvbQRMLVesrPw4M96emj/Knwmsw0KxavxkUmW9GE4cUx+OsFhedjHCOVRGCtjKwPIVb19MXwKwHUSVs7JDadQRHRMAs5g+usoOq3mhPVE5Bn2F8FZLgL1JtTSwFb2bpOmsBn967Kis1JfLPQgT0rn51c5pH+JH1fY7un0LHrHnuvl+qQ3bETz32jUOJOs9DQlvAlDjFxJG0+VD/BMeedDnPmsRrPuIUToWvMxlx+BlB98qljWtvvVbtngKKuAFpDqMz0djyFRknWjVl48mK0VW5nb4vp9worzMi5bnBPk8sYbOXXxzKgjd+Qbdl415iW1hhGR7Bks=
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
Acked-by: Muchun Song <muchun.song@linux.dev>
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
index 981a231a76129..aedac862fe254 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5975,7 +5975,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		/* memcg is pined by memcg ID. */
 		private_id = mem_cgroup_private_id(memcg);
 
-		if (!mem_cgroup_is_root(memcg) &&
+		if (!mem_cgroup_private_id_is_root(private_id) &&
 		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
@@ -6004,7 +6004,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
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



