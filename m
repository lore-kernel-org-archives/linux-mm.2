Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA96CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C5B6B00BA; Fri,  3 Jul 2026 13:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04746B00BB; Fri,  3 Jul 2026 13:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941386B00BC; Fri,  3 Jul 2026 13:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65D856B00BA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3648A01C4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:40 +0000 (UTC)
X-FDA: 84948177720.18.43F8E32
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2131FA0007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Srkat/f5";
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100379;
	b=vZil//Z6PSejmzu/rdoNO/034k4t97M1YiJaS3CHEbkqXOXnPF7mz38hvhXPR2pKnLxK+/
	6wTRU49ZUDw7qzeTVrFOw+0mZBA1GcyzPPxw74fKXjnhER6RXFHHi7v5iEBXOBq7XBUa1N
	ZlxHW4hVZ8spck2rQpnhHecgC7PFd7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kglKe2lO/2DLtx0uqkbUxkjlIDuPAsDBzRzykOy8o0w=;
	b=HftmDD9x8Xln6eD23KtElWFoioGm1xZisQJQOKAtfT/fLDp+l4S3uYJRBS/EpLuKemoEP3
	Ml2rUjP5trOk/DVeHrRMm/Tr7hdrCR258DDu2hG7D3BJe8wIXuPVtEXxeuRoaVnZL31i6X
	qvjWD4Z0TMP9r525XzEc1W/9yhsCH6I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Srkat/f5";
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kglKe2lO/2DLtx0uqkbUxkjlIDuPAsDBzRzykOy8o0w=;
	b=Srkat/f54XcoOhBvNcNGPtoxqbvvmwjAGDHDY06w9NQtjuV+ZT2oIagXp2yKTlMqC9nkFA
	F70iEsN8rq5q5YNooE8d09ZH4dNHnTbg4ePa4DkqdJS3Qux0ApGqjhTTTAdu0X+A0efWDq
	0qpRl3acWDcUugdPCt1g9+e+OKMBeZE=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Alexandre Ghiti <alexghiti@fb.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 04/11] mm: zswap: add range lookup for large-folio swapin
Date: Fri,  3 Jul 2026 10:38:21 -0700
Message-ID: <20260703173903.3789516-5-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2131FA0007
X-Rspam-User: 
X-Stat-Signature: mtgsxuktteigsu4gyxsht9u4t7sekweb
X-HE-Tag: 1783100378-235702
X-HE-Meta: U2FsdGVkX1+O8cxtmgBrWcPahUnlIzqcdm/rJyh2gpQVow7rU+4yel0e3+cb76mA3HoglUKeXzmU1mwIU7YcVR1EevLwrreWw2uAdTSpaOpveh0yoDBrH/grrUsoc9YkWPjV64kGQ+LTL7BMshSaCDwFxKMEZpHmiHfFbpketzyH+1wOYU9WGW53pn5f9R15NbWTuxveHuZP+FJD8Rgg4zyiAvncLtTpKSFdHbfkk2TF+d6DQ2nYY521JBTGhGs/YiD679VXndM/p62PjBGXE9GDKqO9kRV1fJsqnzAAGtNJySi0904utXJuj6/qfo7AI2sBP7Qzi5Vyso4JqbJSbBfBDGRTxh/Ax9wqoLkjmQn/Kf3jwMdL/0JMJ52CabARo/RM/mYeFZ3hg4tPidKCdAg4AWVR0apzrzt9pzsBJZ+fqUfAuRxUhds5fCsNtYFo0f7c99HMM6VeTHXgEH6bzYdPuyDBgeYqyx4VumoNsRlSloG0lxz/NgfEzABWDEl00/pHJp99tNMIBzGgugh7hkrhijTey/xPkDTeGJY+NtEzRJ1Ed4rDpoKS3jIHsqPB2EzCW5oIT9Svu95WHgZvQp0saOZH3+xIo7SjA9fF1Gs2+ssN4F2XQfNEeTgswQd4VSsWVNCoH/RO9uBU5GNSJ109aDCd5ZJUrc+U6ZTUnI7D+t+SVIjxqYWhdQgZBhcwuO7MIu4tykjsMULYhnfOt6WoIESvCwA7FYvjjdxAHY/XjBoeDbR3Es9mG4Acm6lL8QjmCfkAxLhRAOafMe3g9Mge+sqrNPHnBvVdA6cuhpbrLyiRfOwXzqx5zSqrvAMKLFVSztc9tM2wt/a9kKW09arHB5R2JTVvQXtGnxcohcaMIRDUIjbXknWsfZGuarggYvJLh44tGBNRxXCk7EYo7OyaOHrgm1GQPBwV9FXjZh9+bR2x/UJvXIFDg3WdHkWTQuipqjpvthyaZy3uu26
 NPqyCs/q
 UWQrZHZD2k0/jtaO2NawMgwMtJmXTswp/xNpfZrywn9Iczu58kWFPJt38MRv3UtxaTcepYsvYs/rD3p3E+wamBkVd/9rexee15FhDpp4F+fQKt4fQjVNsUjq92Lr6uvfJIN4Qltl676eqHlJMX5fNujjWHcigTKC2djjcp9u1VpXHuuBwgw7TbA4qBtSmZURRpzn7A6+yphQp63pacArLpOwhZM2gpsE9lPnv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexandre Ghiti <alexghiti@fb.com>

A large folio reaches zswap_load() only when the caller expects the
whole range to be on disk. Zswap still stores large folios as
independent order-0 entries, so reconstructing a large folio from
zswap entries would risk returning partially initialized data.

Teach zswap_load() to scan the covered range. If no slot is in zswap,
return -ENOENT so swap_read_folio() reads the backing device. If any
slot is still in zswap, fail the large-folio read so the caller can
fall back to per-page swapin.

Add zswap_range_has_entry() so PMD swap-entry consumers can make the
same range decision before attempting PMD-order swapin.

Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/zswap.h |  7 +++++++
 mm/zswap.c            | 46 +++++++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..de10aa528597 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_range_has_entry(swp_entry_t entry, unsigned int nr);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +70,12 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_range_has_entry(swp_entry_t entry,
+					 unsigned int nr)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index b5a17ea20237..89dd88a5223f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1559,6 +1559,27 @@ bool zswap_store(struct folio *folio)
 	return ret;
 }
 
+/**
+ * zswap_range_has_entry() - is any slot in [entry, entry + nr) in zswap?
+ * @entry: base swap entry of the range
+ * @nr: number of contiguous slots to check
+ */
+bool zswap_range_has_entry(swp_entry_t entry, unsigned int nr)
+{
+	pgoff_t offset = swp_offset(entry);
+	XA_STATE(xas, swap_zswap_tree(entry), offset);
+	bool found;
+
+	if (!nr || zswap_never_enabled())
+		return false;
+
+	rcu_read_lock();
+	found = !!xas_find(&xas, offset + nr - 1);
+	rcu_read_unlock();
+
+	return found;
+}
+
 /**
  * zswap_load() - load a folio from zswap
  * @folio: folio to load
@@ -1571,10 +1592,9 @@ bool zswap_store(struct folio *folio)
  *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
  *  will SIGBUS).
  *
- *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
+ *  The folio is unlocked, but NOT marked up-to-date, so that an IO
+ *  error is emitted (e.g. do_swap_page() will SIGBUS).
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
@@ -1593,13 +1613,19 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 
 	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
+	 * A large folio reaches zswap_load() only when its whole range is
+	 * expected to be on disk: PMD swap-entry consumers split before
+	 * calling into PMD-order swapin whenever any slot is still in zswap.
+	 * Confirm the range is entirely absent from zswap and return -ENOENT
+	 * so the caller reads it from disk; if a slot is unexpectedly still in
+	 * zswap, fail the read rather than return partially-initialized data.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (zswap_range_has_entry(swp, folio_nr_pages(folio))) {
+			folio_unlock(folio);
+			return -EIO;
+		}
+		return -ENOENT;
 	}
 
 	entry = xa_load(tree, offset);
-- 
2.53.0-Meta


