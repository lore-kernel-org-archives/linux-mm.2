Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712C1609A55D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+LS8tnZ
Received: by kanga.kvack.org (Postfix)
	id 88D476B02C9; Mon, 19 Oct 2026 11:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865986B02CA; Mon, 19 Oct 2026 11:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF846B02CB; Mon, 19 Oct 2026 11:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41C086B02C9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B88D640759
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:26 +0000 (UTC)
X-FDA: 85339812852.30.4FBDB60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF974140009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+LS8tnZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5Nfzrde1GD9FfRh74qOmGM0CUmDocdXRs1qdcRag3k=;
	b=zrDaGulAManOyaJLYov0t5FqC4jts30dZZFH/FVte4EzbHetD3esXlh+DfG6EZ07qLBhAV
	D60HE8I9bFzLWwiUUsdzwkmNY3phRpbUOkzf31CLJOxUyjNO23wvuml0wVjFjMnhBc3dyr
	UxrPSeDXNlsG1X/vu8MHxeik4mK5RCc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+LS8tnZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425024;
	b=ls++eYLZK6oQKa1YkriuUbPCAju7ELwfN6zG3/az72GT5TT3jrzfOXCft2tHnVwt1hSZrC
	9LP2v1+YHYLybVrl5xu65MJIMP4Y/hxQuvcGPAkUtRU8QcY6qzWjPb5B8gNz7kdSYOvfYu
	c17L3sRS+OjjXJw7PrK+MND9v29tDbk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5993860D97;
	Mon, 19 Oct 2026 15:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA3F1F000C5;
	Mon, 19 Oct 2026 15:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425024;
	bh=+5Nfzrde1GD9FfRh74qOmGM0CUmDocdXRs1qdcRag3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+LS8tnZc7/cSmIigTVrn2+tU5mpRRNp5KbDmGKl2Wh3GH9rWoWtaCr6P1Ude67du
	 SDLgbTEHSTysXX86PVFVGAHmUdXe6RJZlhrWx7J+HrRGnFUeLRUuT48WzOKcZr8jC9
	 mv8FV5rkVpPp3Zcxr7/+GaNvChRp1/tDyvVZ08U3URr9RsyZb4wOwiFkR0jIs9KNvs
	 mp+EeXy7e5JUvjztyvoqXqBjzOv2ezMHNPxHG9v7nuAwTEox30ak4VFYRWiH4uhAdS
	 rg1JyrY1Q3i6Y49RN5W3yDnCXihpxlMycvEEYY32FLPzVUkNRp0AnvrQgFVVUeQRC7
	 +/L4fXaAv2pYw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2DA0E1980047;
	Mon, 19 Oct 2026 11:50:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 19 Oct 2026 11:50:20 -0400
X-ME-Sender: <xms:ODzWarhAx1EZd734HWV_D-5du2ufehE7IkT2B9kzO2URJOyZU57qcg>
    <xme:ODzWau8t6DMj1RgdVgr3vMJYTlvBG1sSWzg7ZyfT6dzkhmFg8AghocxF8LnDYBkjm
    fDp1EHZgcL3bumC2MfY-LNr8AlXgN4uwf0B9QYpFQkVYepGBznejj4e>
X-ME-Received: <xmr:ODzWagNlOw_d9RBfofrUS6MPeq73ZO0O4YBnNvNOYXe3MZsCQ2f7MB7aQsg>
X-ME-Proxy-Cause: dmFkZTE+kjgISKw/D5xbtovMvE/5+MXw9OAGtDBfqR9Zk5dZNOqhNWGTcEGO5Lmn7qsaMJ
    P+2+K5eT4SfShSSEvxMo9+0NhMtUrbV4W6Uy0A3XpuEB672w8089GbqFaxEF0wWgdpl5Mt
    ZGUplA1E9XDXzNgkO2MrFgMfcNS4u61SieDRP0v46gjH0l2eZ2DL9zme+jYfCIiYlLA1YJ
    nvbn1HssXPAJFHKdL+OCiEp78jaTWZC2fJHjA4vCnfghQrymIXyUGAHupLMJJEm2bjt0nv
    kEsuBoXYnW/I4u0Q3SZjAxl07Y4ERxrcHOAeD/N6wYko4+jO11wXgs98kOmjLgJ2rMOJIZ
    dfeJ0xQ74xoR6DfShFlSEAqdM3aQWhYGU9iaTUYTePGvrkWjscCqx8LuiCBIrLxzWO5esr
    XIWYeR8T4YsFXzTV8r5ByFLLce3aWQVDs/AH8HBc2svQkWdXOwpi0Xzyr1iXxxy3YDQxuu
    d+vqpBfcAJrom7RgY/UM1LcB98A5Ic6xZOKqm1cV0yUmWcjUHVykTDmFvPPPI9Ab4nRoMb
    UX70np05MwHA6FfDOUprjmrpo5WFE5+GZaMR+0EHllstbAYlSw/gD9O0Orj1fDNJWYImOg
    jGxc6OHbvGHcn3reOVmwkwpuisL9nJUWe/8+U8Oz7SBLCzpL0Si1/Pkv3cNQ
X-ME-Proxy: <xmx:ODzWaspC50ZUmwCmz_PMx1tPkl-98bkCPw3DjMiF4XjC74GU9Gj7lA>
    <xmx:ODzWaof-CfprAISdkVF0pO_7PcKRofuyMvTeTz3pqBaqkZn0UzScDA>
    <xmx:ODzWamjj4m5jZjVLqwEb1yllh9cj6pOIGhHgBfjRLaVeJeqN-If0tw>
    <xmx:ODzWauOIpaUAMvtzp8j0uqxHvK_Amg04xLFU5ouA1-rd1tFHwYsAZA>
    <xmx:ODzWaicxGvQaWMLeADH3d6m-A1_QPdb-7VqBnz3Q4woIukWcoLt88aBn>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:15 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 09/18] mm: have folio_mark_accessed() return whether the folio is hot
Date: Mon, 19 Oct 2026 16:49:02 +0100
Message-ID: <20261019154913.1765974-10-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF974140009
X-Stat-Signature: xuae45tk6kp7dcbgfbs516hmjisptzp3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792425024-428081
X-HE-Meta: U2FsdGVkX18/X7uH/p0x06lC7EIVWV74CEAIjbooazlNbF4UEj3tqXEdTafrNuv0BTtGeY6/WmosL5teXOZEYPuCAiligCowpP4PP/0NWxPNd1BYZQjNrQCYK5C5bgRzGrRxO/nQc2uv28DKOUDpo05HEDzxxeOlmmtn7ObX0Om5CbS5/yYRv1jF73x11/XBcZkOkiscpCn1nKGyum+QLMkD/ObkcakaFQQjAoCrpSbPtJITNU+7FJg3L0zI8nvjb7bvZ6QfdP6fjkbgdVRsohPIS5285TAH+mb5yyuoIHwqhNGZ5JhdP5GSwTo3FLV2b9y985a6D7vfs0iN18+OqaxwBeA4Ys7GOfT0EXD1L2tPG7RJ4UTAG2QPw38gHeX1Dyz4TpsEulH4QkqBfm5KjHlsRT8TPyaxj++i+uS8ZFQWaahmMuid79iIYeUmrtszEEgNj06ZigHfMNj6S3UC96KuD5t/1MCiz94DHOPrZFSiXUiynVHhrGY7TaUSwi3l6e8lvDYG+KCLlOrcHv+SI3FyRMXfCDFr7vE4UIoLLJlOlzAFmSDnKhQE28zalLTPJbzWE/IoZAUfRkfwdS3xdtp7r2WLQckO9vG6iG/76tXv7luuVBwJ7Md2cyHWR4XyWS9EjU54yf4RjbTvtbpGvE9gMsIFiaWOoxkJQnxR74Y8W2EmKP5ZIRdk3reBSMBWqCr75+uSTmepPhpPVoUbtu3DQ3cRvPo1lnLmMU/vi6PoSKMbksY6KEkOj4LpThWxBJ16+MjGmbzLUvC/ssBkfjcTSZkoXrrmeGfiNTZ2h+AIaaLv/0rBpM9IeKnbNtdl7hGFfhI53CEd1eoS2b2XnMGMy+H/E/sTA3IaFRlhDGNq3Qihp7z5lchiWKpxzT+CAMeVXJOw4A1z/cy6DKLMq5ySBSWLsvVo3/85bMm+Og0lNVqPBEtInA4auwBFXfBBgNYgPSD5Te6IYdZp7ok
 UEYvdCoj
 ykvS9FU/DpuPrsOKluU9HBQ/nJOwxqbYZsqacLZOxyq2a4obbVFLIgEsOw+t5jL9F/7V39leJ/2arydLkYH1DrAjzBJ/7U3U7VkvS4Uy+0caSAIkYX2D0SGfcO6BabFGyawRIjOGjRUSzlGRRToYXjA2eFijEDOImQqzqek31lDa36Ae9sYwXREgDEs6Or2W+kXAk1BEthxja1HBYEvXUqoqwrJhs9a0PVN6eL+DYZ1dEE1gbd2A34x2Op4kXy5co/cI7iygDmQqlKe/8+7eUcj9v4jPJ5rcJG97BvXWJNnwFzIo7Wnclw6ntpeC2UGXMPKIEyfZtvbzk8j62bgiadR5g//cVxippRxKONj2Xu2y7moxrH8BaSZVfM1KU8tF/N/DTwxrjbWkxYCgYtLk9nSdjJFPxmgEeJ8KzSFD7zENcIMsyVDF56gtJvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

Each call of folio_mark_accessed() moves a folio one step up what the
LRU records of its accesses.  Once the folio is at the top, the call
leaves it as it was: the folio is as hot as the LRU can tell.

Return whether the call found the folio there.  On the classic LRU
that is active, referenced and not idle.  On the multi-gen LRU it is
PG_referenced, all the refs bits and PG_workingset, which
lru_gen_inc_refs() now reports.

An unevictable folio counts as hot once it is referenced, and on the
multi-gen LRU from the first call: it stays in memory in any case.  A
dropbehind folio is not hot: it is dropped after the read.

No caller uses the value yet.  Preparation for reading the folios that
it calls hot without a folio reference.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: shorter changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/swap.h |  2 +-
 mm/folio.c           | 46 ++++++++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5658a1634b85..67aa5271ae6c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -295,7 +295,7 @@ extern unsigned long totalreserve_pages;
 
 /* linux/mm/folio.c */
 void folio_add_lru(struct folio *folio);
-void folio_mark_accessed(struct folio *folio);
+bool folio_mark_accessed(struct folio *folio);
 void lru_add_drain_all(void);
 
 enum lru_cache_drained {
diff --git a/mm/folio.c b/mm/folio.c
index 50a6dbe55998..6144b9cf301b 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -352,28 +352,34 @@ static void __lru_cache_activate_folio(struct folio *folio)
 
 #ifdef CONFIG_LRU_GEN
 
-static void lru_gen_inc_refs(struct folio *folio)
+/*
+ * Return true if @folio is hot: unevictable, or its flags already held as
+ * many accesses as they can.
+ */
+static bool lru_gen_inc_refs(struct folio *folio)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
 	if (folio_test_unevictable(folio))
-		return;
+		return true;
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio)) {
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
-		return;
+		return false;
 	}
 
 	do {
 		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
-			if (!folio_test_workingset(folio))
-				folio_set_workingset(folio);
-			return;
+			if (folio_test_workingset(folio))
+				return true;
+			folio_set_workingset(folio);
+			return false;
 		}
 
 		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+	return false;
 }
 
 static bool lru_gen_clear_refs(struct folio *folio)
@@ -396,8 +402,9 @@ static bool lru_gen_clear_refs(struct folio *folio)
 
 #else /* !CONFIG_LRU_GEN */
 
-static void lru_gen_inc_refs(struct folio *folio)
+static bool lru_gen_inc_refs(struct folio *folio)
 {
+	return false;
 }
 
 static bool lru_gen_clear_refs(struct folio *folio)
@@ -419,15 +426,20 @@ static bool lru_gen_clear_refs(struct folio *folio)
  *
  * When a newly allocated folio is not yet visible, so safe for non-atomic ops,
  * __folio_set_referenced() may be substituted for folio_mark_accessed().
+ *
+ * Return: true if @folio is hot: it was already as accessed as the LRU
+ * records.  On the classic LRU that is active or unevictable, referenced
+ * and not idle; on the multi-gen LRU, unevictable, or PG_referenced, all
+ * the refs bits and PG_workingset set.  False for a dropbehind folio.
  */
-void folio_mark_accessed(struct folio *folio)
+bool folio_mark_accessed(struct folio *folio)
 {
+	bool hot = false;
+
 	if (folio_test_dropbehind(folio))
-		return;
-	if (lru_gen_enabled()) {
-		lru_gen_inc_refs(folio);
-		return;
-	}
+		return false;
+	if (lru_gen_enabled())
+		return lru_gen_inc_refs(folio);
 
 	if (!folio_test_referenced(folio)) {
 		folio_set_referenced(folio);
@@ -437,6 +449,7 @@ void folio_mark_accessed(struct folio *folio)
 		 * this list is never rotated or maintained, so marking an
 		 * unevictable page accessed has no effect.
 		 */
+		hot = true;
 	} else if (!folio_test_active(folio)) {
 		/*
 		 * If the folio is on the LRU, queue it for activation via
@@ -450,9 +463,14 @@ void folio_mark_accessed(struct folio *folio)
 			__lru_cache_activate_folio(folio);
 		folio_clear_referenced(folio);
 		workingset_activation(folio);
+	} else {
+		hot = true;
 	}
-	if (folio_test_idle(folio))
+	if (folio_test_idle(folio)) {
 		folio_clear_idle(folio);
+		hot = false;
+	}
+	return hot;
 }
 EXPORT_SYMBOL(folio_mark_accessed);
 
-- 
2.54.0


