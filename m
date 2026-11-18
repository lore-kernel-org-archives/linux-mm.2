Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5544A606BE23
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FNV/h4F3
Received: by kanga.kvack.org (Postfix)
	id A1E5B6B05BD; Wed, 18 Nov 2026 16:03:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE5C6B05BE; Wed, 18 Nov 2026 16:03:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895536B05BF; Wed, 18 Nov 2026 16:03:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5439D6B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:03:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDB4C808B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:54 +0000 (UTC)
X-FDA: 85449466788.27.FFE365F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8EFA280008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FNV/h4F3";
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035833;
	b=odlxJ8pf/p5reWEs0Tqezdf57uvhwcZ8q0m2RbU+gqkP0WpA2FddRaGjFxSwOM2LxVuyZ/
	Vuxh6WK3BJFJIqFbzDLDrOKu0pLMjzw3xyTClkxe9iI5taPPecrIpVeQ1iIvE0Wp7xyF43
	bTxoeJCU/crpo/s6T0FvvhFrfMJsiM0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41vfnI0ZoD897IEdGdgzDciDJt9MzpCIhSsZSG2H/IA=;
	b=fa8RAEL202Atq32Yeid+njlhQ6d6gZvVddaxbUZS+jydXIuAja0HCsJZ8EBTu3VlRg7IJs
	f7FrFJvIkCxjUlRzrD2tyyjIP+AX7NlozgIOoGt1f6iuIyRx4STmHpAI0HpcTHON7st5VY
	58R8XCMQheP2sLyykZVc0OLrrbV9lJ0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FNV/h4F3";
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCC8243546;
	Wed, 18 Nov 2026 21:03:51 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035831;
	b=Y+oTfttcPpcmZPqcaQ+Uh/B40XsOrN9wqp2t51s0EPoIJS11TzUHjNlwmeQO+Iz3tbTy
	 6RAA38J5MKvsm31BC0nC1RkDVsORErDJCYlRIsmHBZ/+td511TpBMvbMOAtX+NwdLot0G
	 sF4UVmLx4L3GyioAMoD85bNjZf6SZGh1xVzq3CjzR5b6g4z0xX/jMVCDCk6gyGZVTGD59
	 WAcvKoKGDvZ/emE73wHMZj/hSgMdsF7MWe/yEOv23RfxrJg46Xiij7Tu1XvPDwU5nqwew
	 082Kg1vZTCLM6VqFRKGUQy9M3rIA7BYonChF4zfPouLQJTHZULP/m5kXlwKXuII+jMg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035831;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=41vfnI0ZoD897IEdGdgzDciDJt9MzpCIhSsZSG2H/IA=;
	b=swMVbQAwP+KsEUz5d/r5r7kQapafdGXXbE0TkFDnKCci4cb+HyZXbVHNuUxbh6/HPS1u
	 mNHvwVP4giFqS/uQHDQHqhNd35Q8w7+azhJ4ZZ34TOaznvfz/pgyf7Gp9N/eZAK1uSXnn
	 y8Xwx6DpBQjEK+sHW/NErZetysMhcUiXC92ZYsoaB1QXBDWo6Wq8YC2XbpE2lxDks7vTC
	 C1MaW+zC7tN5FWm9fQpU5EzuTTScWHhyI8JmiC+p2I8jczZNoHwsS2Rduy/srLoYusp9S
	 BmVuS9Wxiy+xNA+rdBUttPyiDaKukH8XkDBkTHcpTs6uw9YXP+Ne7MZVzEfmX05mMRA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A54FF1F000CB;
	Wed, 18 Nov 2026 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035831;
	bh=41vfnI0ZoD897IEdGdgzDciDJt9MzpCIhSsZSG2H/IA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FNV/h4F3Z8UzmG4/YD0ypGY2S7UDaw+Sh9r5YKdXjCwy42yB6c3QPJ4eUNjtVpBdQ
	 1FLETznddO+HUKlplYrCqhW9HbptqeAETF5wtZmY4Vohyklxy6HHk8gnP7aNL/tR+P
	 YTDMH1yNo7hY92i0LIzIJvsoyvBu7vdPPrq/dtwCZuN/uOQpaaSyvTvxPF0HDiLe+c
	 IN9gWrPuPBX5+M0h5w9NXsfzonlkSuBFk4Jwi+zf3Gx1pX1mmnOEtlwwhK0InL7yVp
	 1O80EaC+//Gej9ZjOGnCaa89b1AwmEThZOczqqwwJIUUO05TsHVba7G0OT4ghufJP4
	 rDEnmxK8TLZHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 998694AF98;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:37 +0800
Subject: [PATCH v5 05/17] mm/mglru: skip the flags cmpxchg when nothing
 changes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-mglru-fg-v5-5-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=3975;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=rKjtT9cTVQE3kB+eFzFZdlThrfxXKVi5B+1GEDGHtjw=;
 b=eXy1GT3doCWx4eA2MrHyusXF+V13z0BHWbZolJceGwJbmMtsa+zI9QRCGuCTBY1Rom264jpeW
 FKGD+ZvzktJA6h8Yvwm38iMU9RTQym7XK1PfXQXh4ylDSTy6KSdhsZ9
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8EFA280008
X-Rspam-User:
X-Stat-Signature: 93iqfdfh74gzkfk8dgcigyfs9zny4kdc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035832-933028
X-HE-Meta: U2FsdGVkX1+xPO3q1aQlCqfbsf0VmB2xXGvZdr4GERVl5Qc9Z7PVrRJKmNp0qwWmHePspktIh9whrs1BRD7F3OiPxfVF4UO2q9O52TZkO1BMzAGUXevkqHZgq/DZ+Hhm1Mgcql5TOwgFTbthmRQZ9mFnl5+IV1Wym12LZpDOMM3OoaolQa+cm3zXdcU28A5T7+9bZgZfdt0SNNuiAM6ap+jtPHYjL2KA7TT34hA8SXc2DoYIC0mkwqJbT6z9KuwrMAt8o0VHrv80zeWN9o8o3K1BZG5JD7DBU655WJ+TMkD4wNdzagpHQYiQOwuKU5j+S75Veeac7v1hV5H+vUXhyxL6bNbQoc9z94Le8LXYn16yPmKIYRTa64a1PDr3br1T/mINu1B7Vl61cmxRFf3UUDTC9sPPOK9XajNJ87IxwpzAUbcIFCtO4Ujkwt/U1aytuYQ8vFUFq/UoE/xxnv+1T1XxzNBxCH1h/Mojcp51pEPn/+2jgYsqAkjC9s54iRQC1ufZ9kBezml+zbD6ZJaqtfLkKkUdx5irFMS3I0sDGdBcR20l4Cty1Riioxk6tKE9TY5ccs2UUR65DUoJUqeGD1aPCmhgc4MKUxVA829alun70ssvqv5PIXYFnCvLhTSTrC1Ho1ZdJSmU5FSIyv88X/mmYGeA+7u7mzslzjimU4JYO60mq7TstgMBVWCtj8T4f60K6p4e8Tjnaj9Ebpet+WEAfDQn4QHWLWdPBvlgz6eQSTaEK99Nci7Z2lmuUQqlO3i1jI9a1FogQgTnZunL1xDLh2IFABWoUazFa7TCqR17AySTcswIvb8aoXlI0okx3jK34NdVMc9LPrzymKAYR9BnhscO71V6wqBMarjJnwZfBPD6ZLIqIs5D/A3EOf2HXnIsS/JNU6+Sql1w4z875aVSQy5XkBhhmAspN44DD929ubnuyxPyc4bPzQl5M8VW6xfdppyGs7jwWgW8/d6
 o6OfOiPd
 AdqfL7co7fAM9Tn0mXKqvc+7ipSiHmV6xxwiZcREWzI0fYckEk3PVJQc8wSXBvGMaNv/OQPqSfRhgY9HWfvR+WGMF1HRcnN++xIBGvzI7ZJO/YSPazrPF23ouvL+uQESyZ8b3QgHNabWVmEu58Wa4uDjCDPMhyiplDujKEVQyqudY+eun6s/45DCGeqc8o2csiC5XjzgEwd7cnm09TOS56U23/Ifa17godpUccr3G+NjI3n0mgRTbXU1LOgRxaFeyn7MbGZfhsYshno3V5MY2+KdeNmLGxcG54uqYO3Ulx3VkkonFxcRUVZQ6f7vx3HPrKyG6KSDjDAVhK9/43xoLBIw/gA1IOe0cwS3mNuWEPwvhTJGn5E/Jbqk+7sCaKgSlEi3d1EVAz/d3WGJ+by6lyuyMo3bkot2ndYyfC+c72inhhK0E1Ek39Hl0jFkzh5jTnBpcpSfCuDpCEzFqM/sL3ljPm+bh2uoP65ETi1dWqKU5pr25t1xLyyut1TF2lThnaIImcpsEkFxRnoM6loUeAmFti5urMCGO22sF/96vk4FAdYlG1yYDEPRv77iqVYAHAHP4Na6jKMwJ1oe1dzcZSaf4Ukil4G9xmMe91PC2Alad4o2GFE0W+5QmoPMKL29m1eGaiI0OXqCzDufqxizcaFf69fQcIXFw/kMuagv1gU2Ppfa+jaI4ZGk0dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

folio_update_gen() and folio_set_lru_refs() always end with a
try_cmpxchg() on folio->flags, even when the new value equals the old
one. The locked instruction still takes the struct page cacheline in
exclusive state.

That is common in practice: a folio mapped by many processes is visited
once per mm during a page table walk, and after the first visit it is
already in the youngest generation with refs cleared and PG_workingset
set. isolate_folio() and the eviction paths also call
folio_set_lru_refs(folio, 0) on folios whose refs are already zero.

Break out of the loop when the flags would not change. The update is
complete at the point of that read: the flags already hold the target
value, and a concurrent change to them is ordered after it. When the
cmpxchg would have succeeded, the value written is the same, so no new
state becomes reachable.

What the patch drops is the retry. A retry re-reads the flags and
recomputes new_flags from the newer value, so it overwrites a concurrent
update with what this CPU wanted. For folio_update_gen(), a walker that
read an older max_seq can lose the cmpxchg against a promotion done by
another CPU, and then write its older generation back on the retry.
folio_set_lru_refs() can likewise clear a refs increment that raced with
it. Breaking out keeps the newer state.

No caller relies on the full barrier that the locked instruction
implied on the skipped path: the eviction and isolation callers run
under the LRU lock, and the others (page table walks,
folio_mark_accessed(), lru_gen_clear_refs()) only care about the
resulting flags value, which is already in place. Note that
lru_gen_inc_refs() already returns without any atomic when refs is at
LRU_REFS_MAX and the folio is in the workingset.

Tested on an i7-13700HX with turbo disabled and the performance
governor. N processes map the same 2GiB tmpfs file (huge=never) and
read every page, then one aging pass is triggered on their memcg
through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
over 2 boots of each kernel:

  processes    base   patched
          1    32.9      31.7   -3.5%
          8   195.1     160.2  -17.9%
         32   755.8     592.2  -21.7%
         64  1597.2    1260.6  -21.1%

With one process, every visit changes the generation, so there is
nothing to skip. Before the patch, perf annotate attributes 53-58% of
the walk_update_folio() samples to the lock cmpxchg in the inlined
folio_update_gen() in this test.

[kasong: folio_update_gen() is replaced by folio_inc_lru_refs_walk()
later in the series, which keeps the same early exit.]
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 2 ++
 mm/vmscan.c               | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 46beded51c7d..2571b3f01226 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -233,6 +233,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
 	do {
 		new_flags = old_flags;
 		lru_set_refs_flags(&new_flags, refs);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8d14831cdf83..0f24b6ebc1eb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3274,6 +3274,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
 		lru_set_gen_flags(&new_flags, new_gen);
 		lru_set_refs_flags(&new_flags, 0);
 		new_flags |= BIT(PG_workingset);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	*type = folio_flags_is_file_lru(&old_flags);

-- 
2.56.1



