Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D743606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ihIvKZ+f
Received: by kanga.kvack.org (Postfix)
	id 7C1936B05C1; Wed,  4 Nov 2026 08:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74BF96B05C2; Wed,  4 Nov 2026 08:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A716B05C3; Wed,  4 Nov 2026 08:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3964E6B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C16A94071C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:34 +0000 (UTC)
X-FDA: 85397450628.17.399AF38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9D19540007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihIvKZ+f;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797352;
	b=4o+GDEdlI5WS/3ZOLKTNobXWSEBcKVGQKjjabYxqcsXOlAzeOwj7HWZzXYUjHYaAyLuxMH
	VMWy6MJXqhhyNIQ7UPAk9HsiWyzcxWGF21Tt8CSUT/4hVBMRh+D5EOJd+Cg3CG1P2yj1OE
	KjxVOxmxE0suzCb18RJLIIXCWIW+oW4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihIvKZ+f;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeZeKqOXIg0pdVk38aCcXZjtPawAjmXXTX6c9OEoxb8=;
	b=cheqt8yMLXqIpOPR5HpE7FzOAQvyQ+0aQ46ZPfSJ9V8ap/T/QYNEaAcrCprLuG+Trz9okp
	qxZ6fySZkVcKU5xhY29bk6rtm8mky+/aFpKYlkqpyYguskhv6D9eJiDc018p+sfRVpUof8
	PIc/LMJPBJtrcLz6CTnJVRqoKpWJRso=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F28FB41B17;
	Wed,  4 Nov 2026 13:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04A31F00A17;
	Wed,  4 Nov 2026 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797351;
	bh=ZeZeKqOXIg0pdVk38aCcXZjtPawAjmXXTX6c9OEoxb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihIvKZ+faxz+GWcGkPr7VS+TK+j0Q9bv9UwAZ57eXbpmZGfjHyIuqUrcn1bQHz1yP
	 K9DJ4mljISfxegncBinm5OpOR2kFDP1a1HgdJAXaOYzjRamhsCVc9b3pz+Lt4Aejnx
	 pUAZvLVKoQJ85p+9QZNKXjmCmRE8OtgGENQIhUAcW/V+RvHOI1JHFAClOMMpiAe4r1
	 w+69J23em1ovBi11OunrHqLRj5WBkKIDb31Mx72EkeCuVvyikah68DcXt6Ukj6SevZ
	 YKFNVNowntR8cFQEuMY2vV1r7eiKTsz7qwX8NCvp+iLlI9GvKONoRggay1GYRHi5z/
	 e3MElHCM9PxDQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9134B1980052;
	Wed,  4 Nov 2026 08:02:23 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 04 Nov 2026 08:02:27 -0500
X-ME-Sender: <xms:3yzral760PUag65_UE_5joCN5pnKCtoba4VN2oYma6jiL4zCB6vIjw>
    <xme:3yzrap1d3-Hbj7AzFEvhniiaJBhhyUzyG90C8iEK26hqrofSFUW5EDai0sFVH237U
    1cbnwGp8ceXLqdW-fULz6ZC_UmmU5QfIiz7bzEtKu1avKqMX3lGxvw>
X-ME-Received: <xmr:3yzrahkGuQ5SN0G3yvIPx_DuW7fMInt95XuhJS4COrMdvS-DtxDSoExqm1Q>
X-ME-Proxy-Cause: dmFkZTGhPc1Yg5t9Q8eRQaKCLT0heVoXQqf6h4uqMuRtXQYzheOI1jp47nBw26mcWoxz9A
    DH10HnpPYob7RxaCTf32YkHXSpJmh1hLC1IxxzXB90aJAI2wMnFT+nxhjDMKjWZ9Ablulj
    X6EGhbUdQWvr3vCsmIbyKlTdtYm8QJi2H9b42DzXiIRq27TGzwIAKeq7xgftm17WrW++J+
    RK/ZhBFKi/01LbyIuttpTNhw8T5nzUYT3/gbSIkELTYoQfWYa9TU1xDsUR8Sja7r663Vhq
    dT9Vb6Q8iqTkFCbamg7ObiOCckNJsrzr7UPmHz2jvO2iFJ92ew01ZxP0mcoMzU2JutwOha
    B0jPeJCBnNC4bQZANG5NWvjwjnKyS/uH056P98u4op0L2e4Iord3UfH84RIfYlHaTOGsk7
    srDkEB2m0ia7p890WwKoD1qaoP+JYmRcbTzG/b3f5CggOnhlFwvRLaWQuOvc/eq/J/4EcD
    TIXJwSN0kv4mJ/QTWdHzD5TIm9INfuSWeMq9uVNrdKDjR+ReIFvj6K1gwxJ7CcEzha7YqT
    FdzNyJxYTNQCD2Fz3hszaSWQ6e+HyFZj3b+FE+PZfHXyEgFJJKmAjiLvfj4MpT2MDZzugD
    uWc36bFDX4sCm0d0dGA+kaFWELT0F2X/WBFaC8D82SbM6fvZPJxYAm2qqU9Q
X-ME-Proxy: <xmx:3yzraiidZoKKrBGI6E7L6qynhl0Em-AezKc0MX-Tt33cE9_Iygr1QA>
    <xmx:3yzrao3sG404ab0J5a7u8oEgC95P-wUMiKhkpSJhLmhtxzwlS5r5Rg>
    <xmx:3yzravaf5srwmm0HropDcBxDZj19nUcmU9PIsrtixYFGWbSE3UfF0A>
    <xmx:3yzrallljCUcEVIwimi3JoASouOX7P5PfKKRxE-5uI2nNE_MuQY9vw>
    <xmx:3yzramUTQGT6xyYYlzoDriz2u-q_n1CNobPIdvkYJSPyer84Kxebhs7W>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:22 -0500 (EST)
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
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
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
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH v2 10/18] mm: have folio_mark_accessed() return whether the folio is hot
Date: Wed,  4 Nov 2026 13:01:06 +0000
Message-ID: <20261104130118.2507513-11-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D19540007
X-Stat-Signature: j7z8hnr9gnnim7nc6u83ozsojzaigrko
X-Rspam-User: 
X-HE-Tag: 1793797352-140569
X-HE-Meta: U2FsdGVkX18G4rYYROfQEHy6WVe8eZXW6+6aGRAKpvgqSVTLqMCGTMOAKJfwGYYU3cdR6SiwQBdcVOSOUiCzJ26X7aHLU2zd7GFLIgHnSE32hMojbskrLqtxtKmdS6hu02+ay3ENMnhl09yOTfUsPJd91S9F0w3roN90mCzc8T4eUHRmnWuNfmqWJi3iBgoWqe5+mt8lIFYP5WObK2XWIzrFxOGCZDgcW6jWqKso/a/q7amH62MKvOcFxV6MfOFA9JMACRGAQfiC43+v/Q4kC70roJ47O1P++6DEEpKxrai0ee9UKwqWUPN+p3heIr3Cg8VMQzxs0bs2+8jdArMt12FRO/4fwF3m/KttgkNV5OSAt3GN8CRQiGz/5IeK7QzgSj3dWn1ibInCNEklu9E3f1df7DJR5qSiaCookJ8qR6u+CKRzBmCClz7J515uISmX1+GERfNkX4EdgY9dmZjFRZgD8BcOZRqhrwTifx6edPBpewkc5wAngne7cnOhjEOVNs7SZgtFunkYxJjOr2gagRa4H1npw47wV/qGR7qAAwpVyjg6lIVTTydKUNJWfCKoXiLjhIAUSPxYqMlkq2iStaQirtOACTp8GKzs1BAjm7Qur712HMsb4PmsO0ZdMCe3cY8AiVUnB6mw9B/AJDt8atX1nE+Z+JeNQKae9CEEX4QmDfxWjXIuK2DVxhrklt/ZbBNJsDDIGcr1I8vh1erpCPcr7621/ddeIvRs4DfsIDxFcvHSxmNCmYdj1E6WV5KuDqZH5FI35tPqvj3SLFYEXmwaFa5XW2gpiPyhMPfuBZeJFb1shbEcdnr2jsBT2pA8m7y1j68okgopsSn6o7sa1VukmSnuHHX7NCbjwJpVSzVVDV62gwqaHDcAnnfvj59sZZ+1I7OOpyqV23zqeMwogsgQrmLov2DfpXctWbvjiNF9fSXKvRy45ruY8IEFeXXZRfa6LSRVYZRBB+KMpN4
 ZBHEX+w+
 m6MiobBFWCcLXEaKkLmDAcoKtNGcg1qhv6tilfSnOmnEM0TAx6YhGdiUOZJMRqTaG/3EKutdKkreMN6CqEdu5X12wsqLBsMf6dsDp9jDEHQ4nS1DrzkbLKsFMOZ9K3/d6KLTIuVT6aF1hLHG+Mt0ls3e2ZdMOx/l092KDQZAwvp22oKTVwo55Hq57/weutpaWx7emEO0a8uvUQJs4aHBI+Arqogp04zO4F1v8qd3xoVeopCEovi5okwwITFbPOr1KNJ9V/rJp7imKsjbjJo0cWjM+dP5WBHKuGgktY77GyMtAsiX791qYFpLdtYhEWVPGggg9ueR/t7mOulYdiPrITptPpPuN2Zu9IjAWkesL8Ux75sjG14yqwPrTZQqCzA0A/fG4ubxyTFLeLWjDdbJA6txN0chFKpfqRIB1L5NAaOWXZZJIF24hv4MqZE4iksrhL5g1
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


