Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFE8C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1626B0249; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478D36B024B; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E856B0249; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07F446B020F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:52:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CC8C1C16CB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:15 +0000 (UTC)
X-FDA: 85095629430.02.033B96E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 86016160003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QEPWjCtG;
	spf=pass (imf08.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611133;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMnWEl9R/HOQyONbNoVPy9eDJqS9mOe/XxMHwHeRU7Y=;
	b=xQy7YGDikRt/gX8syUJYJgAEXJxKyePDYSLES9G1JFXkfwY4XDDNs4NLmp25IOTQmtWWjm
	RjjaqlfOBdWvT3Cpg71HrmwQsvI6ERfSXneWgaejP8T8uxNPcJfa68i5jKNVCOP2MBsk9f
	3zIEFYF1VgMBTggFplKvuC8P/F2inDw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611133;
	b=XnrgiXb3GS3IMO/Qw1CVd4WsPtfkKYAPcTg4My5b/Y0CDZOAlVeZxsrmifNsH7iuX8RDn5
	EzOVmTt62CfKo2r6TC71h/Ekd5zwA72btLFPYE4it0rbhEi6t/vy3leDVQrqqcEsWkUXAB
	iEQVlrDkdOE+TGbxncJbxP8Oj5Cz9GA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QEPWjCtG;
	spf=pass (imf08.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D382543BD2;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5D4DC2BCF5;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=YuyPCd/TXGvgbAvhPChGeYw4WxnJWp82+drwUmZOF3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QEPWjCtGG8O34+4NMiSIXqSwp4U5bnOEDqslYKlj0rvgdylZpAcndqddK2iVtTx6u
	 zmgM0y2ji/Zd8ehQPJGGnCmGFWuD/4Psth4bG9a8TeJovlALBwehTzCvCUANWoizMh
	 e1VAHRWscZw11V8E3A/rk6ciwW1Tgy9w8YBH7LTxA3qDQPw1hFy91XyGGHVhRNkSVy
	 lpBFDJMkMJfksU54MNE7ok6EAEBHbFXb08Tm2iSssx0wSApAfcD8XUpj3IPDWS2cij
	 lJ/5814zGkTbUKkOjnqN0/bmMGQhO/HgBfUMJ0B7k1t8+FUxPIZKc9+r6mR53inH3r
	 QIyzUIdctyb2g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECC6C5DF66;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 16:52:04 +0800
Subject: [PATCH RFC 3/5] memcg: remove retry logic in
 mem_cgroup_private_id_get_online
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memcgid-objcg-v1-3-83d21c685b77@tencent.com>
References: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
In-Reply-To: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bfguo@icloud.com>, 
 Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=3214;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=5i2b3adAqDemDU/NAVoq8sK/uF2LIbB9NIx+Y5tqrZ8=;
 b=R9G5tW/eOsF1fEjMg6cHo6RdBDAD5yzOljC1iwmE4ddG37Cg5xTgcu5n+bSnG4To3/L8nTiny
 eDLxTl9DEDGAgfNU01C5tFnLzDpgWesTl3zgcaES2tabu+sgDAb5DeH
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Stat-Signature: tm9u5su7ud3bqb83iy815e1bwfw9zpqi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86016160003
X-HE-Tag: 1786611133-183182
X-HE-Meta: U2FsdGVkX1/V5jWGoEaEO0Lpgzv8qe1LCcHAofcMPHnj2xJF4wlUH83se1rbDR2jm7OEWeVTjvFywYlsjXws/XWrcX8MsbFClgDyTpZl8BwlPC/NVrc1Axn5DFIDGWXiKuAUDWNuibJcUBHaeXDDcIXzIDjC/3MYEFf+uorX3/RuCKUMZkxFL/hjFQe7mJShA8iNqDV2T7tEsWE54CgfbOQBe7Bs3mXWtm9Q0D8syuwjaz5USLx/DbGIU6Ndw+FEkvVFLqmvx7i4pViKOCwptraU4MImUukeRtWCAYnVWBJ8dyi+v0w6dw7Ibaqr33Aj2KIc+5yLWgaY5q4RTpcEgP6vEDkcANwoAjGk+Xh2v+LTxTeaslb8HVJojqP6QXcWdqjpdeVi2p+eCMHDxRdrd6xXT8cjW6UwN2QHG+GNcXYjd29fGjLGbnS9oA1ufv4cW9iLPHVkTqxaXKINTGsJW9xjUAgQM8s6g1gsA2xZxGm6r6rk6/doQEMG76QWojL3joKLacFHU8gE40MeyjDQo+UlWgBKbj1EXzOwh5blGUJn0O96QJicOL9hV/TnfB9fcxVqLMBGaJ3jcjbIlrtI3/55qOAVUCBl2G+Ya1ttXT/QMeCYjb5CoOCVxrh7hpPZHbEcdnEqqJuq0CZHVk0F3HkE8Ny6snZ30EubybrQnk8pZet858QBbU7uUSnydArpyF/S6fjc4LcLCuP/0E39fNlmJHcTPpXi54Nf8x5fRkmHCOvymOxeRzH6ukDGfC4memlkipJbv3cswlHkkwxfT+jeyPbHJvi95LOSZx+FExzb4DKvp1ie/gR6I5RPieEARCcQbo5Ud6JjLwwf/JOTpuObHHnWxMWIk65uClvCLxotEvxwuD+S9bSc9jOn5/QN+O9wgYX2xPywB9KPItsLxX8PtdcVy/NQ66HBMlYJS7dUk92CPQFRtw3lx/z/eni7zMUoRWTd5tSVe4qM4nt
 d+RxoerC
 gdvYOrkAI9bkdPbvNTmSPSLKKd2EoIgdCKylbOLDZQPz9w1pXXFasKbezTR6GXqApRw9CWadvmWOK2w82w2zGNWvjt7rw2i2uLDwfr4icIaa2mQJnDCYaq2wzxJePl0GPSjIe+W657K+Bl5PVypB0GbBwzuDM89MoDIMrhJbXXaFhP4o9stPO0xsF0WRsNsNUaAEiJxKGXOgPBAs1O5EoD8pxUIlii0bFWOVPt/DiF144co5VCGzma5Uic7JMJQI4PAVeKDh+y/iplWqRO+XNo1dxi1zlSCjxhqDsFEs8JG3hNjCkzDsE1fpKunhusksMAgMFuaUWV7v1cKHzkik2vKmsBV1EAiFuHWqDdT3nL5MHa4lNmLvgP2T3Lk1VwAFxfJYYWhzJQh1g/At9RyNH0L/WebqArvzLMobRrC3uMG7tj06IaOX3PkXq4RyAz1HXISUcUMc0xA8BmuzaX36c0E8Hdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

With the ID released only in css_released() (patch 1) and every caller
holding a stable reference obtained from get_mem_cgroup_from_objcg()
(patch 2), the id refcount is guaranteed to be non-zero whenever the ID
is taken, so the retry loop that walked up the parent chain can never
trigger.

Remove the retry logic, rename the function to
mem_cgroup_private_id_get() and turn the fallible return value into a
VM_WARN_ON() that documents the invariant.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol-v1.c |  2 +-
 mm/memcontrol-v1.h |  3 +--
 mm/memcontrol.c    | 20 +++++---------------
 3 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index a913d32ad1e17..e5161e061bd11 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -648,7 +648,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
 
 	/* we have a reference to it, so we should get exact memcg itself */
-	mem_cgroup_private_id_get_online(memcg, nr_entries);
+	mem_cgroup_private_id_get(memcg, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
 			  mem_cgroup_private_id(memcg));
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 0f703f239c80f..9c74400aa7ddb 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -21,8 +21,7 @@ void drain_all_stock(struct mem_cgroup *root_memcg);
 
 int memory_stat_show(struct seq_file *m, void *v);
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
-						    unsigned int n);
+void mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
 
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a210fe2501219..12545ca48194d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3985,23 +3985,13 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 	__mem_cgroup_private_id_put(memcg->id_objcg, memcg->id, n);
 }
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
+void mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
 {
+	bool success;
 	struct obj_cgroup *objcg = memcg->id_objcg;
 
-	while (!refcount_add_not_zero(n, &objcg->id_ref)) {
-		/*
-		 * The root cgroup cannot be destroyed, so it's refcount must
-		 * always be >= 1.
-		 */
-		if (WARN_ON_ONCE(mem_cgroup_is_root(memcg))) {
-			VM_BUG_ON(1);
-			break;
-		}
-		memcg = parent_mem_cgroup(memcg);
-		objcg = memcg->id_objcg;
-	}
-	return memcg;
+	success = refcount_add_not_zero(n, &objcg->id_ref);
+	VM_WARN_ON(!success);
 }
 
 /**
@@ -5673,7 +5663,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	/* we have a reference to it, so we should get exact memcg itself */
-	mem_cgroup_private_id_get_online(memcg, nr_pages);
+	mem_cgroup_private_id_get(memcg, nr_pages);
 
 	ci = swap_cluster_get_and_lock(folio);
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,

-- 
2.43.7



