Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCEA606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDAqQ9oY
Received: by kanga.kvack.org (Postfix)
	id 5B9936B05BF; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592026B05C0; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A88C6B05C1; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2132D6B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C0871A04E6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:37 +0000 (UTC)
X-FDA: 85467282474.02.50278FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3D42A0011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDAqQ9oY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460015;
	b=V/vz9I/bWyBjhzLe/VoFsXFWKES0sKvdnzuvO4ZIWIDZ9m/OhMTxt5PfM341kuHCqvhVUN
	FJXrSR0as6RczQbDXgbMdl0IkAOUBqPFwuQNGZiQt6p6f1fzxhqus60/wP4PPpraLMGAAt
	My/BctlWZBWhhqvdyCrkCWFscJzTBYo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460015;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/flV6tJgyZ+NqYZar1xR5I4MimyYfehG8yCe8+zdxk=;
	b=GEn8+adB5Q0uFCdJ0I5kPNfCbrNHKk+RSFYbuowFV35hmJDCULe5z4IArp59qrlfTvVWHu
	JA54Xf9t7qAbxwfy+dbokbinHPXRxCLFooMcBoBMzewaSy42yHHuaH4278d3p01GpM9RFA
	rXmu1H0ymnGfronjEdgq3rDrnIMzrww=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDAqQ9oY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97BDE621EC;
	Mon, 23 Nov 2026 18:53:34 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460014;
	b=p62Ed81Y89aMzUgxTpk78a79MrhEUmnLYavQ696wtmLCZDPYKCV3wAru/iwpu9YSsVlK
	 pMBGfz9ZmbD3kE/++IdS7WVtJ0KR3eAUfQwss1Y0GwlsU+UxG/2beUxslk1DIxXG1vSfD
	 SX4G2XWZD8eU6t3C0VL80KUgXgM1PyTtHsH4jDoowHHj6lpDy+wzWuOW9sYlMbtQbtubB
	 +4QuSrE6owogWzhZ7YLS0K/8gU6QYZd5pJr4DPxew8rmU29SLqQpTuJ+csS1+4/ZTk4yD
	 oJpELdw0zILFvjL/WtyM31ThO1o8wnirDkxPOdm8JkeUZLNZhGBVhfqvAEeo2/SEulw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460014;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=G/flV6tJgyZ+NqYZar1xR5I4MimyYfehG8yCe8+zdxk=;
	b=cjayCzUJPTIWmltITr9F5PXhWsm7J1D7LH54gXHzlxdVi//axCxxu0V0Rp/V1OkNfyRm
	 Q870N/5LikpnR7H/rVQB2xr1J8umrurcFcduNb77PyHlNZZJGmtg1VdtGtAf9SExgeQYM
	 lkWRzoQwWQHxH15gQpj4X+BmaMUqe5pTH5FpILp7pYh8tGi43mBri27br0kHRHX8yiCx1
	 5KPpkGfiyrGHmNVVlKSwnxkcDyPsXLBi1TYH8sqhlnRr7IWTLODRGyHgo+qYtjGpGdoGu
	 /itjajFrGYqcFz8+PNCLiXSVj1NfwwTzgwoIt4JCGP21x1Oz0fNPT8NdG8VVrEcs9yw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 299B41F000D2;
	Mon, 23 Nov 2026 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460014;
	bh=G/flV6tJgyZ+NqYZar1xR5I4MimyYfehG8yCe8+zdxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YDAqQ9oYb3T2mS7n81kZRH2vQYH0SsQ8r/xOuYSQ7va+QK/nGVgPp7fzDgOdz4EWe
	 Y02a7JAzr8YU5G62G7w0SYmjPcVEEKjWmV0N/suPdErzu3UJfk3vLabL5yCNbjh9PR
	 YCH43StxC7FP0IWQ+CsdYfXlUeawLtvX5+/P0pbkWUOD+0z4junbyPjyB51HQqxFLw
	 g3I3A5WQDqN9m/6BoiSHwtKmHlpn/6FVIx8EIcU9KMnYpVh/1qNIVd7RUKrDk/xbF+
	 Tf/rjDNwv5xRD3PeGqO4fWJ9e4HRVWSXeA0ILXM4tvjC+kMB/F4V5+fM6u8GdnhBo/
	 E14CyLWVHRaHw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 080574C649;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:00 +0800
Subject: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count a
 generic API
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=4795;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=PBYnbcUr9dUAP8lVbFcm0yrXQShhXuM2Q3GvdJcxzZ4=;
 b=4IBQ/rfrcPb4A6znz9CjQVL0ric1Ec41qoBxJYerdLkN9zyX5+X8c7XbuMh+IFCahStZfmZzL
 V6ntTsPl53LDvoF9eCtZGnxiDKfw/BcvCiB+68Ie6SrKJ6RXj4uonwS
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4gy5bu4aazmm9nqcctmxzrgak7ci3wfw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3D42A0011
X-Rspam-User:
X-HE-Tag: 1795460014-257325
X-HE-Meta: U2FsdGVkX18XKy9yOpyZ6PKJ3Gl7s72yTgplIa0TVECSejiDcrJyCDR7DWLGgh3tiXG0QvPpopRsSxX0Sk1FLbyRUUFaFA0soNWI2bF38+QAvTeBcApO/5f4wcZLRCEfXPrKyaD4qwD3KVg0k27a9H0y7h1bYxdDTqZumUvd7JfWDwtvmct6rWsWXgkkWROLuqCRKlP8B15gm3uYJ7GdFy2Uc8o97aIliCEEj8kRioRVoCda0u60mbYy6vy13zj9Q3nWI56E/fONx7nwsrvedD4QJy5LER3ecZFWX/fS8jZT7RAxux2ukqxZWSM02Ln2hFbnE5hfXK2Rf+h1RsrdFuo3awP/uk5ZJLEQQxRZy5GKWVBYH63rB+R7g/jgqhvHwwBcWpPq0OgPv80ZgGsWo4AhSseWMLDQjuXE6eAMG3PXzbYjQ8fCI128q0MMHxe+rlqGwbpULfVVKgz/3WW86nKrDpmuV9oc2+k4e10AKqbzsvj+insxUTu0gJ57CWVrol6JAcO3ObUOeZXHnFnJmrj5sVjjYSuQnP2tr6y459VlZ1FnMDempQ6D2N1PnttH3b62SpyJVVXvjGhqTch9KHAKtByvKO9iLfF2kS5HRUJ7FRHPPtzQk296jemLWcK7g/ZMFwmUXBJp2dzGfUhy5ntjzKkPTtUjB/1jqkBBcKKIqFiJkH2Jfe/x8qXZ4Zs0dsw3QZJ7UyAKdUsEC3NuKj/hRO5lVaVm/NRJrn3+/2+YzyMA9ui4ufPnheI1GarPJC3toH/1vHhbbiYkyz0EtFyGo8HuN8QhX5sgR4hldtHj+xZkFyuvpTYQLTJQyrCkjs2RV6P6YgupkahSBR/6RZUEQPf6A39gMN5GF6omH1WLJOyqk8qUyr72KhdJg/xHhi5zM9Xgg0m3go3kjdyvhiya9VZTonwCQR6Zxri6Omm/UrbvE8wa5co3Dc/WQJ726Zw+R0IFdIfTErDmn9i
 iP8tbEOk
 4R6fZ/p8zd9O29shF874jdgU/kgTFUmX9IQLL0NKTL+ZYkRhYEcBR3gSxGKKgjk3Am4CfSP3LPyURiR8dTFGeGpZO8TJHFzlpg3/p92vE1mno+YUtTT70z3LyV+I3dNed/j1CYS0m7wH8caOvUcsaY9HwPbEEswPHnqPdkKV+xcp0OBQP1swFq9ILiOV2B8D3TbKg3RY2Y1/wauG7au+ofeQmEXUTBxIabqaFF0+/jlOKT/LJFnTTBahDADLoKGLNSNq/UqIKVw8vFqbo5u/vehlfM7qiJ2Jf1f169TfsPEC+surSVihQBoPMAS+yLgMlzI2zblC808vyznNcHHoeiU3t+74gC8IJXDTEzDGQdM0GwEsKyjIzC8abdO/p+oYoPbJs0b8POF9BFuBeFs8fxBX/iHtBzoThCtM7emOu09Dz4rRiFJu45DtbHXxh/GjsV/1UZYwwUUUnD0cSS1v1dACXmNjiEqXEajhV7Bef1jblkr7FUPd6ymPJSBnTrmYmQbT8oenTMz9LDB5P7AlTSf7+le2pE7PA1pGd9Zwt3UP89cc1EgQBuwzQ2ygL2bsKS9js9hSE0HfK6+w9rUHrP3AcDZhlT1TKocfh9Ew5LjV2QoyeNcecHTqGyOQCrF+NxCVPpE5t1lWNRnOWntfaKjcpiNTYnu0bWI5CVXj/fBlZht+cypwNtYgIaPqkOTqgw62DHdL2uqco69b+9hjFD7Ru5BFqrGE5RQGkCwZ/WQ+/OkC8wu2ncbIfHlaQZddGGt8N8P5zubeSd7Qr6uMQi83JoQHO2dY69heQJlhBprSBWmITNNfyfKwLQYfFuU0UcnjzmpxHOKpxeK6vFJ16ymsDs2XJmXjr3xeJM4L8KmxJvGz0cRpRI0QUPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.

Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
Without MGLRU the extra bits are never set, so they are inert. Move the
lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
unifying the API for checking folio referenced and workingset status.

folio_migrate_lru_refs() now migrates the complete refs count,
including PG_workingset (bit 1 of the encoding), bitwise identical to
the direct copy dropped from folio_migrate_flags().

lru_set_refs_flags() skips the nonexistent mask bits when
LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
!CONFIG_LRU_GEN builds.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
 mm/migrate.c              |  2 --
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f38dad1198fc..180db43c3a85 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -184,6 +184,12 @@ static inline int lru_get_gen_flags(unsigned long flags)
 	return gen;
 }
 
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+#endif
+
 /**
  * lru_set_refs_flags - Set the LRU referenced count to folio flags.
  * @flags: pointer to the folio flags
@@ -206,7 +212,8 @@ static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
 		*flags |= BIT(PG_referenced);
 	if (refs & BIT(1))
 		*flags |= BIT(PG_workingset);
-	*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
+	if (LRU_REFS_WIDTH)
+		*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
 }
 
 /**
@@ -252,13 +259,31 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+#ifdef CONFIG_LRU_GEN
 void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
+#else
+static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
+{
+	/* Should not be called with !CONFIG_LRU_GEN */
+	WARN_ON_ONCE(1);
+}
+#endif
 
-static inline int folio_lru_gen(const struct folio *folio)
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, or PG_referenced and PG_workingset (bits 0-1 of the
+ * encoding) for the active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
 {
-	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+#ifdef CONFIG_LRU_GEN
 static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int gen)
 {
 	unsigned long min_seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
@@ -424,20 +449,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	return true;
 }
-
-/**
- * folio_migrate_lru_refs - copy the reference state to a new folio
- * @new: the destination folio
- * @old: the source folio
- *
- * Transfer the reference state to @new during migration: the MGLRU
- * refs count, including PG_referenced, or just PG_referenced for the
- * active/inactive LRU.
- */
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	folio_set_lru_refs(new, folio_lru_refs(old));
-}
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -470,16 +481,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	return false;
 }
-
-static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
-{
-}
-
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	if (folio_test_referenced(old))
-		folio_set_referenced(new);
-}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
diff --git a/mm/migrate.c b/mm/migrate.c
index 65869b8acec5..0430197fdc04 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -807,8 +807,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 		folio_set_active(newfolio);
 	} else if (folio_test_clear_unevictable(folio))
 		folio_set_unevictable(newfolio);
-	if (folio_test_workingset(folio))
-		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
 	/*

-- 
2.56.1



