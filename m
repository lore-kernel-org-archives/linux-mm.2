Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A26C606A691
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GjIapT0p
Received: by kanga.kvack.org (Postfix)
	id 8A6876B05BE; Mon, 23 Nov 2026 13:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876D36B05BF; Mon, 23 Nov 2026 13:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76CD06B05C0; Mon, 23 Nov 2026 13:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 455A86B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE4BE160870
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:36 +0000 (UTC)
X-FDA: 85467282432.08.C35A92B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADDDA1C0007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjIapT0p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460014;
	b=O+wvKefXRjqiz1sT/gpaS/AUhxBs0VLtr1XiNqZvW83Nv3hi5IN7eWKTbrvgDjxjKjHdi6
	tslvRKR+1qqu4fxknLl64x7RgoWdVwp3zquDAe6Q87j+bPPjhS89ow1rDtC9MUO1JoWYhx
	FNT41gtAI7nNpkF/g88TSpjf+8DChx4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460014;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZRD7oqKaa21oADy1rxMl/sYyXjHVIlmH9ps+OCcBhU=;
	b=3zpNzmt7sG+7d3oSOklxuMEgv6lbBCkjoqztUCZhFSvWByN8rpVRRajvpAODmFzG+oAWg9
	539oiO/QK9z0qP3Dp3nz4B0BA2CIdsT7Z7TpAmA/sF/zs016fWpI/0vymlMi+qCo1qD/0b
	GZje3g5TBwYADP5ZNFB3efjL+Yh9qtA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjIapT0p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E30962414;
	Mon, 23 Nov 2026 18:53:34 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460013;
	b=L5sH35iUuVZhpiX1BDpbepxo2aZTY7tePET/Yw7r9cl+tB4UdloICjOkI+rW1Ac3WE+K
	 sduRzfEf8N796XGc9C0poGmwIhHx+n1EfF7XygEY4EalyeWGtyjRpBN6cBjktu3RgYucX
	 Fsxoz6e4zwtkLTsYLhk4BjS6cUh7pnhKuVzM5m77u9YWqyC9vbZM2UXZr3NzaUTJTmI4R
	 CMDxOul7cUlF3q3iyek810njdGG7/QWFLdT4GQai5DUh/Ve40/aFxpOFCfrLU8XOLc2bB
	 UvPF8N4RZqyrPzAtMEuU0es6vO0fvRckVcDedis5STWD7YQu0ceN6RNCys64TxYxi4Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460013;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=FZRD7oqKaa21oADy1rxMl/sYyXjHVIlmH9ps+OCcBhU=;
	b=3uvi0A/P46pCu1EuULGgeen4IiHsO2fEKsKU+0zW9shwLWKme2CYqaub/6oACsRfRLQx
	 HGq0J1vn2kakeXfWpTLC+htSjAjA4fuXconjQgsC8r6Wev6Oh9oVvVV7829En46MISOQG
	 wkp6aRMfbM4w5lCdIwaHU7m2MeBVUzo3pygcefw7gOoR1KoJqeE6sPquV3hidgoK80rNe
	 uzdCsVv0UqPm9fnvzaDK4LQb3aANpS5JSZX0SaAAOEFDaqvYfWnhdAssy4upXyEDyHo8Y
	 m5rUyFmtaJfuq/ZmRTUBXzhpAOu36e34RCcTiweySSwqmWHTzK4H+vU3bvM+geDbUZA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 66BEF1F00A3D;
	Mon, 23 Nov 2026 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460013;
	bh=FZRD7oqKaa21oADy1rxMl/sYyXjHVIlmH9ps+OCcBhU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GjIapT0pKAT5Z5BlZTS6TPnJe2R9H4D4wt+f1pK4id8Ymxjzm32zOAEgddZoAQCUM
	 TzNJuOCf9WquC69ggzmvn3hs5qEIY6K4AFL5oSOfBIVcI2wGRo1mr3M6dMyXi+2q1K
	 byPd/lJyJFHhupzI4oT7KqeYmWRjbOYWrpHxwbAWi5VdvwTAJ4HGp/1QfgMhFgcMLJ
	 agOxi1q5lBvoVZIwjg9v2mkfqfZE4JGiqnW2drcALtNfYv6MpgWCIhAKsCCvvLdFNa
	 ONG/759MB4c6rduFJ+IbhMvaRPrWtBlQ8EFhFOBbbiesH9Jwr9wRnE0dg80rK9Yz2a
	 j3Qy9ERMJ/d8g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BD7AA4C641;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:58 +0800
Subject: [PATCH v6 06/18] mm/mglru: skip the flags cmpxchg when nothing
 changes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3997;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=//cwp1yvGPvx4hSAYTY0g5G2U3Dt6Ds7AHeyEL5Sfsk=;
 b=OR6OERTRzsjoPZgx5Bj8eld8+L1XVLhawLjPJ1B4sc7XEOe3NGkoxMtMmdek+EcOY+3113Uru
 m7OZMjFvbZsDbVamj3o5bX6sRQ2sYnivCMZ+kVKANGsxQx3MTuu1gKP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: ADDDA1C0007
X-Stat-Signature: cxgdb9ag8xob1ie1d75j1o5ou9otz814
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795460014-408948
X-HE-Meta: U2FsdGVkX1+iHnVyzB/elDSpKFybjJWNfXBZSsPjPJsNuUf1oY5w8ajsxbwi+lCf7u0BvqIIFATNzxqQthvGERIigxaZJiRLiri0XBx2ZF0sx5txSrBnGTxbWcu2OozMAxg0cFt3SVXKLPWZrFKt1eGK8923mNiQXE2BcUVnsJe55oZg6KGlCMKXE3CAFDKQm170uahsP9eECoRkhj+eQPtOz/J3ZbX++RqklyV3PSiC71mpl8XL9JcYNoWvOct2XXnz4bT8UL9QCzkuLZ8ap5VYrF7k2sAIS6c89ZgJI9GmhVYWSNUYQ0i6o7q63sqIOiC/pFo9hqDADRziPfv3oG1EIxLgc2oX5vhygGa9DoAcogTou7QUYHpUCpjRf6q/825BTCj2MvA05mqSUlaUz+s7+wwJ0SHuCYlptA2U0djvu4GO2YdUer27mr4SSYxj92qeblAzbwAeCSTv/pLTOLVpVf7d/T5qxpSoB6hTWcXNyN2rb/DV7ueLihs1Au2OLUSmqspAc4dy1g2bofj6h1oUwPFp2Pnpg+SO83dr58FoT4X5inb7wyDLN22k5JnYwgNzdb9+TioscK4wQklMRiUxpUkm34E3d5tiSc4NDu++ZX2w5GEhwyISUIU6tbjnohWCGrwL6Cp5//6IDKKHjtiX9GoVoxMotLnj5sWrZKqhJ1u3kIMG5zaTYB6JGqFPF+TA70z4n0PeFtQVZdoKJhONTzFe4AdkijOTiW+lSWhOP0VoGr4fwJ5UM+U4G6JwR8edVi+nL1wiSScrxlP5MKHJ6QNxikfXhUuBernj8i5MqOtTAfktoJjyWtUos9t5y/c0acY6Q6DpoTHxNT8WnXsLHM94RTbGZyNfqi2LM5Q9SfW7lOup/xH/BRoF5Cs0FR4IkospexXsLrRWMgj+H8iGjY/CrbTJp8KD6ulVgVBTLGAqXwStpavpVdh7oGe1fAcADXzpqlljebH5Fcq
 HYN09WY8
 2XdkhPWnD1W3sgNhTuIHgTR2EIok9hxNbHq6vJtW5FZMQK04UV8zR9FGkU7IQxiputaD2qemVs/l6korhcprIzvP/CgSBEUKyuZ3c9gLJWyakwNSGhhohJN7XdgexsNsx2MQVo1GuWmQnBuC9hVoyMqVt80NLvASPgq7L2MsOeoyh5doelN7xTFyYgHSANVR8RinUzeV5F0uHZGI5Iov0u8bj0eFc5RqRdJdxjjj3KY6GBmaGGhcuqPrfFZPlzAp44iZyQBr8+UxiBB4RY7Do5NRTvZKTuw9YxlXQ4bYuH2JNtmParqJCzJFscE6IFe2MdMZJjxtpfh3Ia5lsFjg6X/IFEprWI376lkGeMBqiW/tBuMvSom6PNpVGXePMbXk4XM0JLCrLyWOv3Ju4Uls6ZHRb6TCQhdazyer0AmEJqL5dhq1Xfp+e9LYuP7u8xUiReBg0eQvq4XP1aEyKPeuw8Xh6UGkefurNbQANqI8dMI6GKCziKJFxQlh94bc5ffr21FS3PBGc+zeoT+d0dq/zREPG4MnYc6hBwamC7oZ5HefHl+l/XRwuSzXY8NrE6ONU6+bwwB1PLm6C8uhqjF3dZZxLnxq9bzzZ9Glck1HX02ak4zeOOwW+UQsUD5OAlnCTM84BW7Wm8fj7J1CYNhpz6/fn8kFNhMb9FsaAkRk9LoeBM2I+a4B7mvpB+f23BPZ/eUmZhQNdDVyBiAN8q/fyHGOk5BpNK0ZqvsX4RLsGmnCt1N0kQlal1ST0zUMR4C8DgszauSruBzIBf8P89H3OmDiCWso6dTbINrXpuHoDAeK5oCdXFNHMpNCVReRXOfh8Fh7+kCFvk+DQi0+pIx48rIF37g==
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

Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
[kasong: adapted and rebased for the series]
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
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
index 202e0f874b23..15df5618a3cf 100644
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



