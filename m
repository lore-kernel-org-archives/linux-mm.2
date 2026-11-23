Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDC8606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZuqDxe5K
Received: by kanga.kvack.org (Postfix)
	id 0D7756B05C0; Mon, 23 Nov 2026 13:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0DA6B05C2; Mon, 23 Nov 2026 13:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09A26B05C3; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B86B16B05C0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36757A86DD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:38 +0000 (UTC)
X-FDA: 85467282516.12.FC6D765
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 231144000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuqDxe5K;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460016;
	b=54ClbC8GLHUjjwD3utKSRJznZDBtCQIICNba1azdUlpsT/NFM3xqT8kf4IVwCoRE+jTaAc
	bwJyDcLpWY3U0a14ACC6lU4vlm+cQnpVqSlXvKtpIHy9V6Oiqu8yhZ8j6zTOXx3MqoQoMB
	ZawAG/+JcRveD7k1SCpmyURoUxzhNtI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460016;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPY6Gpk1GxeXHfsNbxjcPs+9GQpLxPguF+KSpyU0BSA=;
	b=2ED/XfCLMinUh+ZRQIo3hPpFrp/z5ePpxXTUJ0x2hFcEkqgMwIp5M/Nt8KaTBn4JW12yz+
	IbuFopcOBnCJV8P5GsnzVbFPowMrg9vWdjpF1wLRlyTub6uSfZlr4rOVMvjpy+BaWxbyj7
	m1sMXnUBY8LBdRsFVng2S+TAUDntOgY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuqDxe5K;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAE7F6242C;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460015;
	b=ykCXgYseupH1NWa096EtDRlPwr1kbjrRM5Ie7F89QmaP1j6sqsJ9nnZsyy7PXjLumaIm
	 L6Vb4gLB5BrQIqeR2hn1HvXmlIa69c8DpTsRRcFgDTBUbykojd8vXr9jBE7xUz/Xd8Uzd
	 2JyQOJWeQvpWjU0LN+tX7A/xvyrpk8AH4YOVXazLLzCuhmqNa1SGtS3Gga1x0/DOHDcyN
	 gxldSsSxwOcoIA17R4m5wJ2Hm1uLJ1xNlX6af1ue7u72zy5lh8IpSscvoot+69d8fErlx
	 qaYz/yxHWkiFF8TAiM87Kn9wLwt2ZPjItc3z+LJEpW8CvrgbxvzkHbax4diPXpNAIgw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460015;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qPY6Gpk1GxeXHfsNbxjcPs+9GQpLxPguF+KSpyU0BSA=;
	b=mNqLLIrO/R1HSehraW1jhTPj4NAWGw/XMHsqhu9arNg51+K4g8SHOOJGsC2pDc5/tmAV
	 pMMp3oXuJ1nLrJevDYv8vFEVI9YjEx8CakdgFUh3m7g0Ajl8cw64SugQuSBEJO9m8yhW8
	 UJSBM6oATK9cH00JlqCUuL+U1W+4P3mvZywyjpS+Cjhj644gXuGgnoGAXZVAlyPDNFluB
	 qxS2dZdbhCFHe4oZPEYnRcR5b6zXGfvzaebfuT0A002exo84JNgh7cZkpbtDhCc86ZF/Q
	 HrkT4dvVCsORrNH/wZBGqblrA0+a62Yz5+TERtHeRwI81S/ZBP5hvCvX2NhLq/Z0vVw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B34541F000F4;
	Mon, 23 Nov 2026 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460015;
	bh=qPY6Gpk1GxeXHfsNbxjcPs+9GQpLxPguF+KSpyU0BSA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZuqDxe5KOPm164Fb2Vz05B6TeOEf0nqlV4XrPLsIR8SoKaFTv2GWIwEiLrut5qiRS
	 mFXHSNeGYU/a9601/6XXRGZmK/TK3xqvRRTHilB+RqluuV0X3tkUOzno9W5rKberCv
	 /ologgR3LW/sPuTdecaSHFMTkS1TN7SV3lC/MHp1ylXPRXshgJH61HCk6H9TwYTAzA
	 d6iB2TfK3Ylt9ZSn8St969Xd26cBJH0MPC0F30gcHOUzlz1q1Nt3gK/gi67k7fEFjX
	 IDxYP4J1p9J8hE96IqtnHz7V+zJQho11gdAuPS0eeaVAiAeaRMn+vVmoXt6NnV35IB
	 zlCPfUp+8Ilkw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 471CE4C651;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:02 +0800
Subject: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a fast
 helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=5455;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EDvLpnxrpVD1Kfz+v/3OI17Dk6Yj7fBAiXtjWEmtcfY=;
 b=n7lufqexladK34F/awLOMu/YkEQJxZMmTJft2kkPNiKhixsNSlw2tnT0Eri4RZ4Nl8hmLaSz7
 plNCLhLOSEeDefNIfoeK4sf8RYsnkDXloTqw6+THIDruqVfCyK7ORqH
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 231144000F
X-Stat-Signature: pktghq9ryobx1orriqwufwupt5k9t5fs
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795460015-731559
X-HE-Meta: U2FsdGVkX1/UQJbMBIj8hv637k1uHJE/6i57rtogy1sh4ZWPXzWMjBTxM/vChoDHCrR3RL/cbec3MZVeXxF9R+hMVaR2l2sIFClV1jKMEAglscr+CVmiKlOEhRNyqWwqvmNWBDm3nIYE5HEvHJ2xRMgqD196TlHONgwH/8GqooDi+9vbSt/u8PWm7suXoZ3rYriQtue0Dy8LrPkoqebLmxQDY7clTUPBTlLn8Kz7hTzSg2qzF7AVL+bDIwBOZv0xxF5hIfphiXiMUIR6ZP/LuC8F8IgDD0yQLbTsyamOuAh/BGpqGM8644F6oOdGrNdqlMF8mZAElclDtasxM/HTis0dZjhqq7bvJyIOM6T0o7SJJ+oyejqkUvcsmvQ0zLvIUXTMqXlHXOTKDtpEgFpsQLw1hN07WSMdP5k9lx1FOYN6Vlhj/YeFx7AJsJnLUwbEwHOep4KQl6/LXBGpxvYj12ggB86H8L9u83NProRE8s5VH81716WtFM4rh8jUxVpU5Uhe8rv0HLJZBPZJ0M6SUpa9Eq3jOjFDTITt/egs3ZhzYctiRTGK3xlO6emucLfjmTWRT3oAZ/mPMQ0z73acN0dUS4DhAME+0/B1PJcn4xflTFgFCKBKatwj6TszDHqvIUpkjUrw625MCRBAracW9ILK7KjCyQTZXITcr4cLFYZAf2jKwrQSiy1ILHsRDfByRJmL8wmNeybhNXf0CabD2PkE9aw9a9+wm1IB4cLMOIz1/b/lnopLvjh1t3Bq4R2Qma8gd+PIVuIGysRZcJo6QwrKzbpcINtENIU7vkdTduF08scSrGa3D3N0TRA3ms9VXJqLob6IxM2Gu9xdRDRFp61kh8TcizcBUcWEOqEqj8sYA5C70bQTLYMXVGyIJHPdU+WgaHC4byxwfXyW3F1c95Sjc2byUhnnW5Os3WXigFrU6TfopRb3pEOD3zzz09clSqbg9bc0FrsgumVrAZj
 o28HcKlD
 56r2UbmencIUlypdBmg8ZtsfMMu1eLg8QnkSo84YYNVArXE3h0ibL3mDOrvWFua66rpYK5aICqxBc44qBdR2UYYFGJBK4h62tgl4m5s3ESsUS98FGarSAm8jSTid0qnu4N0GSaK1KH3AUCsnfbb0Vd/to8X7w8rx1mnexUL7ZQ3m6TRoIuDrb9fDKAZVZfU16H7YZN2dTMptCteJ3WuFDOwpIkisTTOu+PrpMKJAuSy57kqoA9uavgwfIiUwJ8Kr7zFvKvHszitbDRr5OSBTg7uEZvxOpwvnojx7f1kX8f2etN9B5CjW9YstevFJGLEyWRedvqPeB8NdNby/2d1G5EVB8v0l8ngdC3XcrlUWYa1JKrOuixJufq9r/9lbdLr6cif6XWnN7LH2b5/D6MAWlHjoy3Yj3AeJic0pb3D2ZARlKC4+OKZf3dyGwN1KUekqVgrTSMN/wlhAM/Ez3QDoD7yS1rTlA72AOn+zJjw4VulCD9YfaFptupkgUsflIeV77gPHWtgIgWZInYSg7uYXkaL+xUg3gr4PCrTVLCI/8BceI/4RjP3Q3tkhgo+mq4Boscx8zuYebPG+E74HfTwFFSvC++Wf5tTCSOHBEACWqv+QMJAGXgfX6bYqFUjwUK5PH/1msMuFTXE1ADV82nJYXqj5ZZTeX3BGAwlkEq2IA5y0eoY1xxfeOGcGbacOtEhFbu7g6DtiIDbMrb9uV9m9zh91FpE4DfiXHm76esT+0I6EXKL5LhiKw0T53O1sS6KLpIiJ+FrzS68q5oXWHJ/4WBfxcdXKItJ4HPHIkBGfk44ZQyQV+EadkUuPepA==
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
nonzero MGLRU refs are left unchanged.

The classical path is taken for a folio that is off the gen lists while
MGLRU is off, not on lru_gen_enabled() alone: while MGLRU is being
turned off, a folio can still be on a gen list after the static key
flips, and setting PG_referenced there would bump its refs count.

That check uses lru_get_gen_flags(), so move the helper out of the
CONFIG_LRU_GEN block, it is now built with the option off, where
LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero. Keep the decoded value in
an int so the subtraction of the offset-by-one encoding cannot fold to
ULONG_MAX before it happens to avoid -Woverflow error with CONFIG_WERROR.

This helper only aims to be fast, it exists so the gup fast path can
stay a fast path. The new helper doesn't account for refs above
LRU_REFS_REFERENCED but that's fine for now as GUP never used that
or anything similar for CLRU either.

Convert the gup fast-path sites. No behavior change for classical LRU,
no regression for MGLRU either. Just prepare for the following changes
by providing a helper that follows the new convention.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 62 +++++++++++++++++++++++++++++++++++------------
 mm/gup.c                  |  6 ++---
 2 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b15c3618a1f2..13c8b6bce349 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 	return lru;
 }
 
+/**
+ * lru_get_gen_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
+ * -1 if the flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_get_gen_flags(unsigned long flags)
+{
+	int gen = (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
+
+	/* The gen is stored offset by one, so zero means off-list */
+	VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
+	return gen - 1;
+}
+
 #ifdef CONFIG_LRU_GEN
 
 static inline bool lru_gen_switching(void)
@@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long *flags, int gen)
 	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
 }
 
-/**
- * lru_get_gen_flags - Return the LRU generation number from folio flags.
- * @flags: folio flags
- *
- * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
- * -1 if the flags indicate the folio is off the list (e.g., isolated).
- */
-static inline int lru_get_gen_flags(unsigned long flags)
-{
-	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
-
-	/* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison */
-	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
-	return gen;
-}
-
 static inline int folio_lru_gen(const struct folio *folio)
 {
 	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
@@ -483,6 +483,36 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For a folio off the gen lists with MGLRU off, a plain
+ * PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	unsigned int refs;
+
+	do {
+		refs = lru_get_refs_flags(old_flags);
+		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
+			/* For CLRU, just do folio_set_referenced() */
+			if (refs & LRU_REFS_REFERENCED)
+				break;
+			refs |= LRU_REFS_REFERENCED;
+		} else {
+			if (refs)
+				break;
+			refs = LRU_REFS_REFERENCED;
+		}
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 7605da0e06d8..da04bebfff43 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2921,7 +2921,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2990,7 +2990,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3032,7 +3032,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 

-- 
2.56.1



