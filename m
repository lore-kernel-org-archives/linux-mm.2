Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB086606BE36
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RkTRpXIK
Received: by kanga.kvack.org (Postfix)
	id 22E756B05BF; Wed, 18 Nov 2026 16:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6196B05C2; Wed, 18 Nov 2026 16:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080CE6B05BF; Wed, 18 Nov 2026 16:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC7D6B05BE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:03:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECBB11A085D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:55 +0000 (UTC)
X-FDA: 85449466830.12.D406BEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF29A18000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkTRpXIK;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrlGQLEEtnfHmiKobaFWc1jYAzCVcr+GQMXlFd622xo=;
	b=scDuyd6IQBQ8WerR1eYiHXtQa/Axj/mepcKG+6G9+0LmWlNVx56ALwxlkGiwByQkMLanx3
	B08jVlzotqTlxGuQeUc/9vyCqrAr8cnA0DtZaNWMeEqbf3ZbQ7gUoaMNnqvklOvXe1whEa
	1da2Q6JVqN5Dswa8bNXnJi39M0Mc0xc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkTRpXIK;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035833;
	b=K+1AQszwNKcm3rC/7fTW8Sbjv39QDbv5W8fLyApQilgnQWVj5csI+vwy9BXM2UQnZvxTIS
	fSnWW7niNnSreOgsnfOYPUZUyW3WAray8TswfUaCGM+D3nuWAQHk1beQ7rw2IRYfQ+T0zZ
	4TlS0pfJ8IcaHAi2WApdl+iMVSu1/nA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9228A474AC;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035832;
	b=pG5OrW/uBZPXBqseyekgDSkMGdZvx7XGXwugu7CQ4Wa/w8kjaMt2KtS/VGm23QsKmAsF
	 mneILvdN/1Ay6/6lpk+yHCFHWuySGQxPDBrUg47g//YJhsRm6+W44uTHiONwhy/aYmwHG
	 wSP0xPbl8jGbQ/TpgJgrbRGuo4cEApnycE3Yv/Yea2c9WOaZtbIlg2xDvWgwgO44geQWn
	 cF68iCIPcqLyIsyCqotSus5TgaSS9KV1ffQpePFdu8sBJ0rNb18oRZ/D5FM4WfFeMz8xv
	 TNm1HdJOcGM+joGar2fvBaRDsDuFAqWae10gXFUS8ykofZe94LkxsGWOyk4Vxd1Tdyw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035832;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=LrlGQLEEtnfHmiKobaFWc1jYAzCVcr+GQMXlFd622xo=;
	b=N0ftSeoSXn4C5+mKL7toZ8UMA0yBtV7qT18vb2PogSaw7e6lGu79bNmJvhGPk2v9FDXm
	 w2knGF6r8R5eOxyArkrfRxKrE4lx/bGaOGyoGcI0YG3+6IGjj95mde/EMNRkGZNb1pRzZ
	 lz2gT+ClipKkf1S/Fbvo4yHYiO4Cs05bCY2ILzGpMW+OAasuQuxmebTtFA+qIpWTjZiN8
	 bwyQ+6qj5bTfnn16DUX0DygRxOq7wP0Ea2r5YWZ0nIaKarSd87DE0SuWFu4fI7iLoXSH7
	 U+NaINEUXmOFskp80WQ5I8WvUtSMlUvohCzBEY89VZqbyLN8hAkyS5na+p8fBlmaV/g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 45AFB1F0092F;
	Wed, 18 Nov 2026 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035832;
	bh=LrlGQLEEtnfHmiKobaFWc1jYAzCVcr+GQMXlFd622xo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RkTRpXIKFYkatCJ6QCZCJ57rn6+nPncX6VLQlHGkYdM9zmSOoD3h5WoMKZnl04wwH
	 Z9iv9ZrcQv9NZeV5JLmqhc8JViRXXxDU+mAMU7wlN9wcHNtAhtSUXYfQYm7X2GZ0Y4
	 sWkfcQJ63EDfGXWH9y2zoM/lqkMrAcLZJ6ttyJZcoShig6Bg2UR+iUhYGCrjkhVNxw
	 f/s06KPFga7nfmV5RKxd3F6sCuwuBnXfGBhrf6KWRC/7o1QehKpM6o/VzoIaqvKscl
	 OGQtWa8WCJ2gows51Z6AD26c5CQW2fSICSJP4jXfl129jqjTbT7CTWKeC2/B3b9aP2
	 b6Pe6HpFdADJA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0801E4AFA8;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:41 +0800
Subject: [PATCH v5 09/17] mm/mglru, gup: mark folios referenced via a fast
 helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-9-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=2914;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aPuSORUuSGb6n/3Hg5v3XmLoMlSfc/wD/Eg7ayRbx9Q=;
 b=mVjH56jPWf+UzjInxmZy/kp7O4dv1XnzWnKS+bF0j0IGWoAWH0R5LwmaXMcMGUyzWt6KLBOP8
 z48pHs21UafDLh+OKHavVo75L7jSb1isIoBYLuM8ZJ5b8C9AkCuLktY
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6oq53amn7d345rp3umapu1t1uycet86g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF29A18000F
X-HE-Tag: 1795035833-483758
X-HE-Meta: U2FsdGVkX18ZywKrhEF4OvL80nzlDNKPRTnTo8ZDFbjnMRmq5E8alrARY4DheqbAat7kbiOKetWGlzdntzMECSrVltIFDgBRGBa8BN3QR4bCm4g9g4QmPiKwR83irhTXFJdDhVN5kzbokZsLx7WHIRkWGZ7Se3fgntgRrwdOYCvgqlW/uy05dnlh+zXDx1SujJCAIIloejdkzIupVKAu6oZ8hH+c99s/XqR/QtrmWx6S0H8xlRjmDOZY9FCaGGXa5RnN713Qn5m3s57mgp+ecDwavwhie4c4Qqkyl+OL4PAWcfQTwEuz034dfANbpspknWSnkKrpYaqblj2ERgo1F/GY0AIN7cX8W6Yo7z39s12mz2PLFQgkbulBrOrkgH9+mmR4A5aPSEbyxRr0E7hEfxN77nzi52u/OFMVosuXMcFhBDqus+gVTsETL5mKc6Tj7UBoZi4uUC9p7JjXnTdI1ilhEn1/0tcuWW0xoyNcKEUd0uTD/3kMutnUdXQITO6ZJJfuaR+KMXPVXj7w5Qp990R1+xh9PQBTF5bmLEJ7WWVrM4eQzfxyJQdPJbbwn+OX2QO3CEbUR+sFDbPa9oXhxHIImmGNIsikjLpHsPRfzIIi6ftqflLkR1CNry802YbsM+9nAmYjqc/KEgW222LimhSCTDw8knC4wmwIDrDLYPvVbTDgqvZCvaQnnL3a+9PY7lKaq5y1bthGyNU7QozqD29V5RbG8C2pWQNt+Pma7uz+br5zqJsIM1R0eOkLC6tddcsSSLiO0prul5mKtcGfpwfRx/KkH6OHoJWdED/SR+dgb0I/XEKYL+loecCHjkSn+lTOAPL7ncsYsG1Ijy08bWFWo1cCNXbMKG1taftW1Id15wxez0JSvt4B+6IXSqDgjcA/Lkr8E1eq3aiBYlA1HdHJS7ZIR3nLh+0BhhUFmZq2kbtzqAex0BxR6ZWUPjb7bzmKsqau5l05Zp7y5RV
 oj3/C71d
 IMaFSX3s5cu2BoLh8RgItYbNwxqQbN/n3a3JL9ac0OpNNUHG+2OLP2gHkq7sge2KWhgVhKYhZ4/N5tQ4PaD9zXsuTzYj2ubZyMewdR3NJ5C8CPDHZZn9Xkj56klNS/1V2SJQBt2bkebVOcH9rLwK9ROtMAneMpguOcNVcbj9UDL8cXUlNLKvPwGYxdA15jDaX892aMEuJgJR+WydFBcDWckE4jBMSWvPO69ZTOgfRposqiLRwMpuD4a85iZ8llP6/Gdb9TQhTqpgdsuaxmiVdEb81mO+TFItFhh4xoyU8raWxAfdXjHjo+C4VMiUjP/sHORLHVhhixMTeSTrASODDY3TEd0vdAwXo3+JLOBHgt1tF/HoPtVGdiic2352sG3sXqdQ3v/QqnCuqlFZcif1LfHD016NvMgR9YxGweTZt2sSq3cYsq9N8YfBuDRPq1a8hIbpzYzv7Fyv1CNEq8t4zRYSh4vOEwutUpMWghrBjvt996xA708w5iQ8H6JDWedxQ1kLqnjOpsD/T8Ickrt/clYKCkGv0FHC7w77WAYNDMOg4ZCscGpfs6wBSqiN9aZHB7u5A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
classical LRU as before. No counter update or promotion is needed,
nonzero refs are left unchanged.

This helper only aims to be fast, it exists so the gup fast path can
stay a fast path. The new helper doesn't account refs above
LRU_REFS_REFERENCED but that's fine for now as GUP never used that
or anything similar for CLRU either.

Convert the gup fast-path sites. No behavior change for classical LRU.
There isn't any regression for MGLRU either.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
 mm/gup.c                  |  6 +++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b15c3618a1f2..3323a3c7336b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -483,6 +483,31 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For the classical LRU, a plain PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags;
+
+	if (!lru_gen_enabled()) {
+		folio_set_referenced(folio);
+		return;
+	}
+
+	old_flags = READ_ONCE(*folio_flags(folio, 0));
+	do {
+		if (lru_get_refs_flags(old_flags))
+			break;
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 2b405cce2ca5..596e62954659 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2911,7 +2911,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2980,7 +2980,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3022,7 +3022,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.56.1



