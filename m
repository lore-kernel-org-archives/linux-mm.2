Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705DDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D616B008C; Tue,  1 Sep 2026 19:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4FC6B0092; Tue,  1 Sep 2026 19:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386306B0095; Tue,  1 Sep 2026 19:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158D66B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:24:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91528401BA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:34 +0000 (UTC)
X-FDA: 85166774868.17.5FC6587
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DB5AC1C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONNpfGFz;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305073;
	b=U9cHrlXI5flpm3rPBNzviDvQvp77ChOgqOxFRd5KMXYptwBTeyq++bUEL5BhPVT4TDCtme
	2NQZnGxBeO9gV2wF8tX6u4tIeQtaNDF8IVrM2LtWv/AmZh3XLjQIyjsj+3AGRZhn5OaPnx
	81juCrPYROeBgMGYWohNm8nHrohnXsc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONNpfGFz;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0X7OvF6yz6PTqxJmY35ICxOJAuUHhLkK951+WZcIng=;
	b=8rBFJ46bwMj6nnmSakpvdC1D7CTyfDDcXYL7RYNEIrBmoO4leAiCuh3Kh5HGQpuPDxqS6L
	otNdFcrKZ64jIDemoM1dE01FHomIwqiHfVBW1biWHXG0Ed+omhxF2Cxje2vFr8Qzq5Wnqg
	AUWFrzrlGb0HysARr6AP+Tuv0GCVdtU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EC3443F60;
	Tue,  1 Sep 2026 23:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C771F00A3A;
	Tue,  1 Sep 2026 23:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305072;
	bh=Z0X7OvF6yz6PTqxJmY35ICxOJAuUHhLkK951+WZcIng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONNpfGFzn7/T6wh+dIHvukw5pagye5MuBBVr0HN8zSArlZBW3NpZi89/Q2VTjz1Xu
	 efTyofK06CMYGUYqzgpM0x/rEsRcvbNkiUNW/IQNcP+0c/Orb1+sTq2p/df5AntkE6
	 YLaw1PIsQYaYlRqL0xHMxajJPelQ+WPNigtM/EEqAxb2iI108K6c+IJYbjJQy1pE1B
	 QvdoXEq62EqTOXIcMaXdBX0stgWpI5ayA8z2IVg0feyRkgpzHWk1mTSYjgKILTg0HR
	 B/TxgSKyq9pF7pZN2PM77xw3kMhEkbK2BHHpNw+Phfd9xafJWR70FE47gVJhALnIMb
	 Dn1MS+JSVqdbQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v3 1/7] mm/mglru: separate folio generation update from LRU accounting
Date: Wed,  2 Sep 2026 07:24:15 +0800
Message-Id: <20260901232421.40157-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260901232421.40157-1-baohua@kernel.org>
References: <20260901232421.40157-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dq3r4tauio9w94isdpsbjq836yt6mhfc
X-Rspamd-Queue-Id: DB5AC1C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788305072-736129
X-HE-Meta: U2FsdGVkX1+qdum8NdtxQR2K7jt7Ak14KeRjxQPfHXSXO84d/1v7JX9LffAonSOm0FH1kU4acE7WaT6wAH4UTcNCgkrhBH9DHR2TBJf53Of4Qr6KirPE445g56hw5eN3XsqWI8A0uaO73ijDD7hcbw3tYb4WAbRfF9XCQj/cykZVa6w2QMuv+uBovqwUzzj8SD+Hh8O2vNDAksy1EvhLAEugKHnLoadWQif14hWHNjwTqM2flWRMVlt8doDgRiRJcUNPtTZ9KXHZeYdm5p4+SyGc05gl6EQ+F5ZGvnCwpWRhYvBgh1givbdAReqCycVMT8CxjsX85wmCimkbXrsQczv7s7Eanu7yhke6hcLfAhzRtHGtdalONgP+bUAmbqIHDDML9JMRWWCnuPZfP2IJvKArVnCgzosGjUhHbqZx1xTDvTa4aFdznq4sWwRUOipve8yjeI5Art971GkQclVE+XcMhbW24ec3xqsJr1gV03dCz+cOIO23AEGgnKFpofw4NHIMLKGVYkTy2feehDsTK40UDtyQKu24Kz3jyCwRJdKG3smGVJ4Keufntx2ry2JewD6RHIXNC95A2/3w98BqpUtHxdPajmKOm21f1eKmDwuyVJxrwS5O5LVkFEHpeMkeJyHwsFqsnC90Zm6YAI9oUq6SmiSKqT2GLx3CBIKpK1BeIJZDp/0QX1uLGVnh0Q3m63aMzU35s0EzKnIT3qZlUpNZl8L0ipUrxgGgj8emxTEGIdijJc1D/eZEdQ+Opk3zdXh5UvOVzU92UITCZeeXD9ecfSau9QTr4oQ+GfVWwS5f1JnV12DF0eQbjGl2LTCjLH9xgpm4YJ1Q/QWuEyB30SGVQyUGd7pGVDtGwm6sRbr1il0M8iYSo82l5I2k4p6du803UecFioq+K3dCpJIVBnx9Sw5pXBq0zt179wX7BTfqNi4y+75u3YUYTZ0pjX+tebymosqcx7HFc1E6e/u
 E+kmVVNZ
 EBhHXvLYivLyCGzCX+z2E6JcvWsaXjnanz5oxfTTJ+cufR5KptTNs3ZB9HKUMYZX9Ke3+YQWiWEox0p+y+j7slHtIHcHADEAqkO9Mhal+Ui7+ixRwwKeKb8a2sqY3IM7Su2QY7/Q/3UhMcKtqYefxCQwDIo9fYvIqnFxTOnvfVXOqmD85L6ZNJrHvOroKNoGaPKkrZeZd9LzKPqe/ZvZPBYgj4NEKB7RtW2aSxtmTe8OZmShckJM1W54daYkQ68HHL3U7sS5rIg0NDC0o8jkAXS8SD145uWZw587SVYFwoGNYSw5qASmh54xCEHRYPE2wyLenZRwCi1U/LvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_inc_gen() currently updates both the folio's generation and the
LRU size accounting. This makes it difficult to batch the LRU size updates
when moving multiple folios.

Extract the generation update into __folio_inc_gen(), which only updates
the folio's generation and reports whether the generation was actually
increased. Keep folio_inc_gen() as the wrapper that performs the LRU size
accounting when needed.

This separates the per-folio generation update from LRU accounting and
allows the latter to be batched by subsequent changes.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/vmscan.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..54bce2f608ef 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3295,21 +3295,21 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
 	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
 
-/* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	int new_gen;
 
 	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
 
 	do {
 		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
+		if (new_gen >= 0 && new_gen != old_gen) {
+			if (increased)
+				*increased = false;
 			return new_gen;
+		}
 
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
@@ -3317,8 +3317,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
-	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+	if (increased)
+		*increased = true;
+	return new_gen;
+}
+
+/* protect pages accessed multiple times through file descriptors */
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	bool gen_increased;
 
+	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
+	if (gen_increased)
+		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 	return new_gen;
 }
 
-- 
2.34.1


