Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2BF4C5DF94
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 02:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9230E6B0095; Fri, 21 Aug 2026 22:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3F46B009B; Fri, 21 Aug 2026 22:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9726B009D; Fri, 21 Aug 2026 22:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55CF96B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 22:47:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAABA1A02DF
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 02:47:24 +0000 (UTC)
X-FDA: 85127369208.16.6052CF4
Received: from mta0.migadu.com (out-76.mta0.migadu.com [91.218.175.76])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E3221C0004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 02:47:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gQX8HsSM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787366843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Iu4M9aTmhgOWpf4BCPlDhObwoIJorDttg9oJ80fpDSo=;
	b=ZnoKkibFf5We20IJ+l5bSXqiCXIhRBroM3yPvrp0gsENQoSJmffqgZslELirVGT6HTBA7M
	d5i8yLeUc1hG2449V2JGqGYeF5WlEuusmpBaclEE6P/X9ai/DaBzcjn+HGbxcm9eAhtQ1w
	HX4YJu5OA+NrmMMD1Qi3QnSnvEZ4EDs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gQX8HsSM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787366843;
	b=daEyQdo+jCQ1dfafqllD2Y3FcugSczPn9XIx+3+NG2IeOMq5njnWGM1OWzoeivRCs9WCiQ
	l2Od+K3ROG2onZeJF2vu5tAA680whks5j7IzX2q57JHAAgxqW9ozvGEcOjqjyJ7ynYOLly
	7cgDvBbIKEHUSnRjS8WiAs6pky3W/JM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eVVRhhBLN/+FkM0gx4duUnqi0A2acoQjl/ZnvoeEHME=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787366841; v=1; x=1787971641;
 b=gQX8HsSM9DqTFD4agTBDOyYobA6sHis3+7otPremcuTr7orWFzBJ/jPQ/EEC506SVxs1U4ae
 g8c1NvQlwifvnOWX2Jd+gMT7XUDJjx8Icko6SY+WDmt565PVx+18BaxiHPExdB6OK+HK70lROjw
 J/ZQER65vq7hxnEyAyy+mmQk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:5c::)
	by smtp.migadu.com with ESMTPS id 07ae24895d946565;
	Sat, 22 Aug 2026 02:47:11 +0000
X-Mizu-Trace-ID: 07ae24895d946565
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] memcg: move LRU size accounting on reparenting instead of copying it
Date: Fri, 21 Aug 2026 19:47:07 -0700
Message-ID: <20260822024707.77192-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ymb7u3th33iu4umtdkgcjk1ioanhjbon
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E3221C0004
X-HE-Tag: 1787366842-488928
X-HE-Meta: U2FsdGVkX1+2ZCUhY6HvblzGw4KQafglEiPyu/kQi6gOleEJaTl8cJuTk8mTL7twn4Uo1SKSI4JWEe+bm6c4sNAtN0lt1eKqlsyy/rTvukKT7V1YHL907GKLX4Z2Eqs+AfeoCZNnrZARD6/favs1p8qEdrrf1fPDJpKtA7aDU+H9/rBseP1sbBpwYhs+UbhPdpr89Pbn4i5qM3g5gaOTdZknIes1uihARgyeC3f4joLTVz319PTYMQwpCwz3HzS5FBX7momd7M/oyAAOH72G/3NLPEvtfHgY3n9x8D47qv6xsHCA2ErBExVgle7CAD4iG8xdOYa1UU228TN/E0dRYP9KSZCXztWScEFFo8cpyE+1/XMOw6GwQfzJeY474JhNUlGK4yKG0x5T30mEkz7tpniOcEjZ0Jfb8f3q5i1Kit819ELZ+l6mORJw9FJR7jl/0lipI4ty17z6HSGOmsXvjuFheWHJxJSBhiirVsct3wdZZPhM0w01pfZSRHCxtURwur4FFNTVm46lKwFGWUVFZTzcbIzKgdL3WETmNdgozOvRdT08F7JO7tCzUtqFDyLq9BVki86M4ayn5GJJ2OQcObiI9a05eM7OKOu5lxa2PivNH3fwkpt72TEWd92WKGqbm3EyhMHuwDM0ZK9PsGS0ILSeSJ4M1yxzIjahSL6Gz5fCrWn89DwqmBzQ4W7FyKIucrXICffVvMmo8pWFDx0hlFoUg6Km2r85SX5lX8c/Yqhfw6J6vUpspQTAHRvRcPfUlC5o+SxSBi/9jP9L1OzRfWGNrpHmZLa/JfGqKGvgGn6Z0iCQpmxAizVrsXEOs1S9QfMZR28CrpZfsX3IPbiu3bb8+o1VCQtyKS6X3rKhiUDMPwaPUYGSz2rMG2HckR8LIRVfs8FphNnw2ak+xsc4YwOrZYNWLCt0cmoSggOY1HT6ZP0+iMQXrpPUDNPLId0xpCaydwdjmcwruHiP7/G
 a0TnDwqu
 ZAkusAaVQVKsCM7if/vuFr8uFkDkKDlF+oRBDf2OiKifjW3HaBpmNknAHe4tJ/zPhWE/1kGuB+FwIfE/+e+xMfKBf94n6jRhZLnfdVHPuRBffFKTvtTvcGEpy3Rkd9r1S7c5XlOhc2Tz7GHzR2ytU8hH3t06tk8s8c3aQRDsT+8HpkS5YToF02CNyNGEbKe8R/+QdjWX8CDzcNY/t9xwG5QVMAc10MhWiAVtNvYPL1dqrf9kG9ucyFDj4Y1hy6ij0JbxENke3IzNGgG6HmbmHUyuAe02PkIKPDgqODwtrQLpcctE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a memory cgroup is offlined its LRU folios are reparented to the
parent.  lruvec_reparent_lru() splices the child's lists into the
parent's and credits the parent with the child's per-zone
lru_zone_size[], but never clears the child's copy, so the size is
copied rather than moved.  lru_gen_reparent_memcg() does the same for
MGLRU.

The parent is left correct, credited with exactly the folios it took
over.  The stale value sits on the child and nothing will correct it:
folio->memcg_data now resolves to the parent, so every later
update_lru_size() for those folios goes there.

Dying cgroups are not freed immediately and mem_cgroup_iter() still
walks them, so shrink_lruvec() keeps being called on them.
get_scan_count() reads the phantom counter through lruvec_lru_size() and
the scan loop then grinds through nr[] in SWAP_CLUSTER_MAX steps against
an empty list, for as long as the dead cgroup lives.  Under MGLRU the
MGLRU scanner runs instead, but count_shadow_nodes() sums all of
NR_LRU_LISTS through lruvec_lru_size() and over-budgets the shadow node
limit just the same.

On one 251 GiB host a sweep of every mz->lru_zone_size[] found 380
counters describing folios on no list at all: 124777314 pages, 476 GiB,
1.89x the machine's RAM, across 57 cgroups.  All were on memcgs with
CSS_DYING set and CSS_ONLINE clear, and parent/child pairs reported
byte-identical sizes.

LRU_UNEVICTABLE needs its size moved too.  Its list is deliberately not
spliced because lruvec_init() poisons the head - the unevictable LRU is
imaginary and folios are never threaded on it - but the size is kept by
lruvec_add_folio()/lruvec_del_folio() and those folios account to the
parent from here on.

This depends on commit bf4ade7dbd76 ("memcg: keep folio's objcg same as
its node") and must not be backported ahead of it.  Without that
invariant a folio's objcg can belong to another node, so a folio already
spliced onto the parent's list can still resolve to the child's lruvec
until the objcg's node is reparented in a later iteration of
memcg_reparent_objcgs(); clearing the child's counter early then lets
lruvec_del_folio() underflow it and trip the WARN_ONCE()/VM_BUG_ON() in
mem_cgroup_update_lru_size().

Fixes: 07a6e9a2c199 ("mm: vmscan: prepare for reparenting traditional LRU folios")
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Cc: <stable@vger.kernel.org> # After: bf4ade7dbd76: memcg: keep folio's objcg same as its node
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/folio.c  | 9 +++++++++
 mm/vmscan.c | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/mm/folio.c b/mm/folio.c
index 59c477120b9a..c02dcea9c03c 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -1130,7 +1130,16 @@ static void lruvec_reparent_lru(struct lruvec *child_lruvec,
 	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
 		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
 
+		if (!size)
+			continue;
+
+		/*
+		 * The folios are accounted to the parent from now on, so the
+		 * size has to be moved, not just copied. Leaving it behind
+		 * makes the dying child describe folios it no longer owns.
+		 */
 		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+		mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
 	}
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index fe7f0c52a18c..561eeec5628c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4635,7 +4635,12 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
 			unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
 
+			if (!size)
+				continue;
+
+			/* Move the accounting, do not duplicate it. */
 			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+			mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
 		}
 	}
 }
-- 
2.53.0-Meta


