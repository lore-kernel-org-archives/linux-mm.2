Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B7AC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8CA6B00B0; Sat, 12 Sep 2026 15:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790D36B00B1; Sat, 12 Sep 2026 15:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F6B6B00B2; Sat, 12 Sep 2026 15:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 381E76B00B0
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:50:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93514140486
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:50:44 +0000 (UTC)
X-FDA: 85206152808.05.EE64562
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9743AA0004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:50:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vI4PQNvt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789242642;
	b=rsTNQvnjJKrYBCoaXyg/0bzZFx3vffy715Ur/n+nQ63JTY1lXpuyRe2blGhl3tcDmGaf5T
	S4dCUhnpHGAzSl6dYPLWIk34DPBJSYHcqxbXqr+MKYigX4ovPCPR1QF/T8SGNFC1T23+bf
	AqdLAdyfsyxrYRn7CoVAYWhQHxafkqA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vI4PQNvt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789242642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOa9NahXWmGce85T5uzEDXB6XC8e+WguWeQziQN/kZg=;
	b=tXBRIAkNOrzRHZeif6MWYqrL+lzgX+mJSGQU872BB6pZfD50U64uXXXSW7Mdc5L4+hGB87
	IK2PIMhWDdqUdTOkaX+m364DYb+TfX3laam1w0Va+boQ+qwout1ZaKLcGBqL0401dOPCiC
	4DRGtMKHeSnY/mfXqho0uik9Q2QFOd4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IZQWpLfgOYy2HoyGgwPrn56oEiNSXBhTyZWh8PoLnm8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789242639; v=1; x=1789847439;
 b=vI4PQNvtzlz5BVglkofWTsBPA2OSAuND2Xwvxxxa6xJ/msUylIFRfjkuTMEihxVtkwfQtU71
 Pk9Mmmccy09A3gqx8ZBJeUKYQYs1Y4gU5zjrGMB5nEr2SHTFoGNTndIhWP/6M5zr36YcfEKlqON
 XbTZkjx4hK5Dw0euM25ihMW8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 657099db2046fc3f;
	Sat, 12 Sep 2026 19:50:39 +0000
X-Mizu-Trace-ID: 657099db2046fc3f
X-Migadu-Flow: FLOW_OUT
From: Ilya Gladyshev <ilya.gladyshev@linux.dev>
To: ilya.gladyshev@linux.dev
Cc: akpm@linux-foundation.org,
	andrew+netdev@lunn.ch,
	apopple@nvidia.com,
	artem.kuzin@huawei.com,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	Liam.Howlett@oracle.com,
	edumazet@google.com,
	harry.yoo@oracle.com,
	hramamurthy@google.com,
	ivgorbunov@me.com,
	joshwash@google.com,
	kirill@shutemov.name,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	torvalds@linuxfoundation.org,
	vbabka@suse.cz,
	willy@infradead.org,
	yuzhao@google.com,
	ziy@nvidia.com
Subject: [PATCH v6 3/3] mm: implement page refcount locking via dedicated bit
Date: Sat, 12 Sep 2026 22:50:10 +0300
Message-ID: <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789239015.git.ilya.gladyshev@linux.dev>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9743AA0004
X-Stat-Signature: nny6npm86yorccygwg43ay1t8b95pxxm
X-HE-Tag: 1789242642-244865
X-HE-Meta: U2FsdGVkX1/povwTfpc9Zq8kAWghQmR9ooG0OVWYnZG/MVBv3Gzq5f3vIpP6wgyafDw0GUvmRqqzb+0mknC2NLfobPv4RKlyan6KSnr83AsLX0QMm9SUWVpQagB77v7J/K1hteWJ7omDFLc/yLjWFckMEzTdnC5b1NuLWFU0o+mPEWTKsrsDHzjIk/C0uGnIDFzbcLNhEMNNQgeORyKmE34YTkPaaHdJ2UNbvaqs0WB0RG6Q+MJLm8yFuczrieXT0CscUcwJe4B8u3Bn+GjnLC88CzWsA3+lpg6U70ke0yGqtdi8uGudRDBo9qjsmei4xzTSp8/YA/9/zTl7AUmt9MrBYWVk4XYoBaCTpz112RFICHuUMXwYmhBHzKjjmjVKSVNLGaQ4lWT31KiFSEoxko6N55Wc3wWbSwZGjPsT7NWcfvadG/qbBJLMvmGZDWxrvb18xtwIcUewfPobdx7A7GgvM2sziDohA12BBtp5CMEooIvjbVg3C/erNXOfjfZDuiDjEyWAwgT6yBDRE5X2xRG7ebeS7F9DgTroy0EoNW6is8KXvqoPj0x2L1fq50DmESbXmuBg43bZLZkIQvYZiMGlVJ0BsRZRFTfM8iy+YaoLBWYumAXsU6KDZTT0WWPFOIQRf1CDY6FyvtJbcrcdyv/LkAdTiI9s6s81pRsunyKtmD+ufzwUedUJByX+dusKxDTVtfiU60cd2B6Y00HATUFtIKYc/l62v6kbaBwM7JAxcvNcXkdIBNvRGz1+wOO5SSNSlAZ30/yuVxhKDOAgjffSFylHhciIMv7tPK9YdvHrvDVveUjmfFFMYPtsEM5Ea0MS32hKav/ZByBSoXs6Uq5PAAzSt+v3gz9J1MyhuGSaRsZmpHUb/uszQNHKo93ZFDHIebgq1gDz7J1MVlaXuAmi9UKCqZwAojw6kiLqHbwyxMrzizj99y6M9r25JdsyrjOQU6+Vbd20vhPNpg6
 B7MCth7E
 ghvYBGu/XpIGQlVC8ihRAfp865xanlU9IqafJJgr0oNLeB2lrWVdDSyobjE6KJKzarZvzBH88nyB9RSCbF0H/Lg8fjdHULJVj5Buh7NzAiIdAlj5vFzag88qL3kn5Lv5RiqMk8xZBwLQ/slBJbO/MJamQhqJ3GYn1rQawcFiNhHR1hXb/ruT+IX5oHpDHoWCr0Lz5U+ipGyxsMQUfQ624TVTCwUnYhg1vjZk0nrTjP1LJ1IvIb69f2vcpF1Z9l34MCP0Qa7w378L2RekKPn9xc2mclm+PjHGATvLhoi1aRA6HOBvwc5zCLSr4bfJG5j7bfNof+ZwEfduBgmeAhz3Xy1qYyfZE8+xWyetzN2BvHQb1e74NpfUmTXXaF582CzzIwKKkBS1vg9Dk9OXLs7cgr9BA/qITNzB0LoblKw/DlqD/iMo1e0xI2AA6JWfZX8m0HNDDia4qhwKp7nq0oZfGQmuhn418nMsagwht56W0CTiZPWB6baWpaMXkaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current page refcount implementation uses a single counter value
(zero) as dead. So, to prevent incrementing a dead refcount in
folio_try_get(), it fundamentally requires a CAS loop.

This CAS loop can act as a serialization point and can become a
significant bottleneck during high-frequency file read operations
[1][2].

This patch reallocates the refcount value range:

(1) refcount < 0 means dead refcount (uninit / frozen)
(2) refcount = 0 allowed only as a temporary state (see below)
(3) refcount > 0 is a regular reference count

In other words, refcount is now split into "dead bit" and a 31-bit
counter.

Refcount decrement now works as follows:
1. Counter decrement
2. If it is now zero, try to put it deep inside the dead zone
   (CAS to INT_MIN). Or you can view it as "set up frozen bit and reset
   counter".
3. This CAS can fail only if someone grabbed a reference in-between --
   that's okay, this page is their problem now.

The size of the dead zone allows performing an optimistic increment
inside page_ref_add_unless_frozen(), replacing the previous read + CAS
loop with a single RMW operation. This reduces cache line bouncing and
improves scalability, especially in NUMA scenarios.

[1]: https://lore.kernel.org/all/20251017141536.577466-1-kirill@shutemov.name/
[2]: https://lore.kernel.org/all/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/

Reviewed-by: Artem Kuzin <artem.kuzin@huawei.com>
Co-developed-by: Ivan Gorbunov <ivgorbunov@me.com>
Signed-off-by: Ivan Gorbunov <ivgorbunov@me.com>
Signed-off-by: Ilya Gladyshev <ilya.gladyshev@linux.dev>
Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>
---
 include/linux/page-flags.h | 13 +++++++++++++
 include/linux/page_ref.h   | 30 +++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce..b19721e0e7ca 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -196,6 +196,19 @@ enum pageflags {
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
 
+/* Most significant bit in page refcount */
+#define PAGEREF_FROZEN_BIT BIT(31)
+
+/* Page reference counter can be in 3 logical states,
+ * which are described below with their value representation
+ *        state              |         value
+ * (1)  safe with  owners    |   1...INT_MAX
+ * (2)  safe with no owners  |         0
+ * (3)  frozen               |  INT_MIN....-1
+ *
+ * State (2) can only temporarily occur inside dec_and_test.
+ */
+
 #ifndef __GENERATING_BOUNDS_H
 
 /*
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 82ff3a99297a..cc7a9d7db504 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -64,7 +64,7 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
 
 static inline bool __page_count_is_frozen(int count)
 {
-	return count == 0;
+	return count & PAGEREF_FROZEN_BIT;
 }
 
 static inline bool page_is_frozen(const struct page *page)
@@ -79,7 +79,12 @@ static inline bool folio_is_frozen(const struct folio *folio)
 
 static inline int page_ref_count(const struct page *page)
 {
-	return atomic_read(&page->_refcount);
+	int val = atomic_read(&page->_refcount);
+
+	if (unlikely(val & PAGEREF_FROZEN_BIT))
+		return 0;
+
+	return val;
 }
 
 /**
@@ -150,7 +155,7 @@ static inline void init_page_count(struct page *page)
 
 static inline void set_page_count_frozen(struct page *page)
 {
-	set_page_count(page, 0);
+	set_page_count(page, PAGEREF_FROZEN_BIT);
 }
 
 static inline void page_ref_add(struct page *page, int nr)
@@ -220,6 +225,9 @@ static inline int page_ref_sub_and_test(struct page *page, int nr)
 	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
 	int ret = atomic_sub_and_test(nr, &page->_refcount);
 
+	if (ret)
+		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BIT);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
 	return ret;
@@ -250,6 +258,9 @@ static inline int page_ref_dec_and_test(struct page *page)
 	VM_WARN_ON_ONCE_PAGE(page_is_frozen(page), page);
 	int ret = atomic_dec_and_test(&page->_refcount);
 
+	if (ret)
+		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BIT);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
 	return ret;
@@ -275,9 +286,18 @@ static inline int folio_ref_dec_return(struct folio *folio)
 	return page_ref_dec_return(&folio->page);
 }
 
+#define _PAGEREF_FROZEN_LIMIT	((1 << 30) | PAGEREF_FROZEN_BIT)
+
 static inline bool page_ref_add_unless_frozen(struct page *page, int nr)
 {
-	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
+	int val = atomic_add_return(nr, &page->_refcount);
+	bool ret = !(val & PAGEREF_FROZEN_BIT);
+
+	/* Undo atomic_add() if counter is locked and scary big */
+	while (unlikely((unsigned int)val >= _PAGEREF_FROZEN_LIMIT)) {
+		if (atomic_try_cmpxchg_relaxed(&page->_refcount, &val, PAGEREF_FROZEN_BIT))
+			break;
+	}
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
@@ -312,7 +332,7 @@ static inline bool folio_ref_try_add(struct folio *folio, int count)
 
 static inline int page_ref_freeze(struct page *page, int count)
 {
-	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
+	int ret = likely(atomic_cmpxchg(&page->_refcount, count, PAGEREF_FROZEN_BIT) == count);
 
 	if (page_ref_tracepoint_active(page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
-- 
2.55.0


