Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF3DC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ACD26B020F; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981896B0248; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD526B024C; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB286B020F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9317BC02A3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:15 +0000 (UTC)
X-FDA: 85095629430.16.65A891C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 918F2C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RfP6jZ1g;
	spf=pass (imf10.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611133;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMEPKCfIBUZpHr8isAUIgJJVNxLEHRWpO24AmdTYIAA=;
	b=z5UgCpbR3HADIHX/iBk3SMNHjPXA3vDGiUotxoxHUkTKP8knXoNZ8jrKEse2X2Nha4xcpm
	+6Ivl139pOb20Fe4bhmg+/SObEUpgQWcA/W8KkdoYYTjSmfAA4Sd7ra35Cl/rN61t9aEG/
	o0IQZ+AMSAd978+CIeh0hfHxfRO234Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RfP6jZ1g;
	spf=pass (imf10.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611133;
	b=m2i0tB179RyUFWkiokacRxjmnsyMWUq17+jdd4+p30AR8sqiEAp/gn30PTuvn/PqSJ9mRc
	UIILHProSsVS5fk7vv5gi7JkMrKx8Lkft9wohmAygN5kNyRhghswkz6x3QQZgDkiwxMzIj
	d+YCeTNtfXyzIhFQ/O/kT0Zuu80CSok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1F5F43B9D;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB260C2BCF7;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=kR5zbkSvv/RlKYuZXiHgRuu0UFnNidkDfN2007OyReY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RfP6jZ1ggMa6trUcUGQtCnAYEDpNKuCrnzBMVI5PbQIOu9Xzi6sfL9dnF6vFsVEFu
	 +Xy9acYBGaWqIXo9XIYkcJqrZK1Rn0USRIjDu3py131+38MIq/SpGi5Ob4ltsBRN4n
	 MEg4iKW99OT+2Ne7qVFsqWsJOGwZdB0Jlfv5EN0oQHhk4Bl/o014To5HR3fKHRgNqT
	 ELFNsRYpztYG+EdSGTs4Z1JPWzDErROInTyz4uOS7Yz0bIMjmwE2SYK0PAg46gSP1U
	 M0ok0XuDrdfFvdgndo6P2fWpDEO39+cE5PfaQmmjxtl3eLFy9aZ9+6zEO2Src/KbbJ
	 3b5XjEjRsXSRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F204C5CFDB;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 16:52:03 +0800
Subject: [PATCH RFC 2/5] memcg: get stable memcg first before getting
 memcgid reference
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memcgid-objcg-v1-2-83d21c685b77@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=4263;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=jO1EJ+YiSvB3LpF8HaBSpgO3Wgmvg81030gxkA7owJQ=;
 b=IuoSLuzL/85amN4CY0wJlbVtvGU0mcWEE5s5ZLz/r+pG0gu1bd9lArAGvkUhpLoBQdNeOaZQn
 /8mlXbtlBnPBY0MdmBu+DAQ0AO/qUgV3bOyPNMKrDjv8rLi+hCRWcs4
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 918F2C0002
X-Stat-Signature: qduobh78a4pysfwfkim1gggo4gku7ffe
X-Rspam-User: 
X-HE-Tag: 1786611133-605119
X-HE-Meta: U2FsdGVkX1/Z4BJSngzTeu0lXNiXdkf5YV9QV9pz9wUz+Q3Hx3x7aQlx1zICLNLRUPekWOMA/jgvyvwksQMDvvSiZu4Q7N4PUCmKao4r6gl7vfBj8zq2BnSL+uw1i/xAU++Acz5IX2Bsre5fff0PM0nebOD//w4jdrfEH8PgqFppJ9ajp/+sdU823OActgEAU6080Fsx3eEIotODqrkJe5Yj7BRUGFelUlBETy8na637ow4seKTB69oPtfDaAj2cY31uzW2GcSnOmoaJJ15hkB4Nb2eAu68MCDNtFZJU+YdDCKUtjV69KxCLp4FC23UiRlvrO6wZqV4d+BRL0OLcbffqm6d0hJFVCA6L7vUadx1BNYrplV/pVtXj6AOVFd0D6aUlh3S+nJWBtCzU/cJ5oKOftecBJhcyaWHJRx2WRnGksxAmx1zHhGFXQ+atBzlGvF0eEbT9wlqd/I9wcAPf4/L9BClzRppWrzOIb7BKTr+o/i+SnU7lrnPzrU1R+Df3LUcFfH2dDeLjFVMNeL3MjTc5q5IcxtlFcfnlBtxrGVA/g9M6bVFXCxPjVvExFHfl5WKsBDUnoo1Wr8NJldc7jQ1Kbdr8yLrPT4srasgRjc1VFFEKov678OWDYSWqp7BxBUEU7fsCYJLx8hJ7+2uY6KomkSiQpf1hOvxT1/RFm871IaMcGZ1/g0fzN1ythliY5S/MUdOnpcQjNp1ZtfVydX2I6ILGa5YiHuTuLR7C6gv8R3vFYlvNn/X6omGF+lWFtpZmI9kNJyVHxdWw+aHqtXZqow3I4dCFW6+z2TWYlv9r0sr6l4IH/PwAGbRhQkoF89CXyv+mH7eFH0imMjU7ipu0w2sR/+iUm8e03jwvuJ4JNIlbqozswsaTOBvknk1xhM0EujIw44J5LI2HLamfW0En+H9tXxYT9wx5go8c8E2KGhAbuQm1ci4KFYPuBYWDWL82fKOAK7SSp/Gjc/x
 h+miV6eP
 /v6/OCL11YyJobx23uJfRYZJhtamSO5MdST6zUX53AL0xWcwwCLNfmu59UvSVPliud93fL2Z7Dxbi65Y7rpz0frXoSiG+YUrmZkB5UjfTmpupFEkplVvLlh+sUFAsxh9b33VAX1YFyun9RUQNmterydMHLuDtX60SPv9rx1tCgWkuvrpUd8Jdigi1q3Tvx0Y2dseDIrya1vgya3NzjQUhUyHUHGnLNpjkGTEFOi1HbeYoj0Lkm0DSASqBYKWLM2sd/t8fSXwV2Yiw1dHV1aqrvkMVlcRsa+3V5GdNbAZXayJ4NPjwBbvgzH5DwwRvAcFMo5oFGtqmDYvgrTYjQ5viVBkcsy4pD9WVlqq4SNrvxXuEjwggHVY0EMZrls7SkLyONHqfb2wfRvl8jNTU43t4PPzJ8ot2Fk0waHlmuVJvvdL9UFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

Storing the memcg private ID in a swap entry used to take the ID
reference under the RCU read lock and rely on
mem_cgroup_private_id_get_online() to hand back a usable (possibly
parent) memcg.

Now that the ID refcount lives on the objcg and stays alive until
css_released(), holding a memcg reference is enough to pin the ID. Both
__memcg1_swapout() and __mem_cgroup_try_charge_swap() take a stable
memcg reference first via get_mem_cgroup_from_objcg() and pin the ID
afterwards, dropping the rcu_read_lock() usage and the get-error-put
handling, and recording exactly the memcg the folio belongs to in the
swap entry.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol-v1.c | 23 +++++++++--------------
 mm/memcontrol.c    |  9 ++++++---
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 2dc599484d006..a913d32ad1e17 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -618,7 +618,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
  */
 void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 {
-	struct mem_cgroup *memcg, *swap_memcg;
+	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
 
@@ -638,19 +638,20 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	if (!objcg)
 		return;
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
-	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 * ancestor for the swap instead.
 	 */
+	memcg = get_mem_cgroup_from_objcg(objcg);
 	nr_entries = folio_nr_pages(folio);
-	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
-	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
+
+	/* we have a reference to it, so we should get exact memcg itself */
+	mem_cgroup_private_id_get_online(memcg, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
-			  mem_cgroup_private_id(swap_memcg));
+			  mem_cgroup_private_id(memcg));
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
@@ -658,12 +659,6 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	if (!obj_cgroup_is_root(objcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
-		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, nr_entries);
-		page_counter_uncharge(&memcg->memsw, nr_entries);
-	}
-
 	/*
 	 * The caller must hold the swap cluster lock with IRQ off. It is
 	 * important here to have the interrupts disabled because it is the
@@ -675,7 +670,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	preempt_enable_nested();
 	memcg1_check_events(memcg, folio_nid(folio));
 
-	rcu_read_unlock();
+	mem_cgroup_put(memcg);
 	obj_cgroup_put(objcg);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5f30e76ee93d7..a210fe2501219 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5660,24 +5660,27 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
+	memcg = get_mem_cgroup_from_objcg(objcg);
 	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_put(memcg);
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
+	/* we have a reference to it, so we should get exact memcg itself */
+	mem_cgroup_private_id_get_online(memcg, nr_pages);
+
 	ci = swap_cluster_get_and_lock(folio);
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
 			  mem_cgroup_private_id(memcg));
 	swap_cluster_unlock(ci);
 
+	mem_cgroup_put(memcg);
 	return 0;
 }
 

-- 
2.43.7



