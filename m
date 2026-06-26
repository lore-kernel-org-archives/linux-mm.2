Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCC7C43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F386B00AB; Fri, 26 Jun 2026 14:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F656B00AD; Fri, 26 Jun 2026 14:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246016B00AC; Fri, 26 Jun 2026 14:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E02066B0134
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:47:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BCE7A0585
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:47:05 +0000 (UTC)
X-FDA: 84922946010.01.23DCFB8
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 78DCE20002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:47:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RXfHTpS7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782499623;
	b=U+K4xjML/Zzo/5b/CoY3haYqBp5IFfAl18HNk1QPZpTtTJZls9E8nMbsa6FCteXEtCdPEF
	OIrjIkf15lk+0PGRePcczN2F2ISCL4jgPauDq/6mWxv6W/OffH3lu7aWM4R2OZ7P0k6Xkc
	Xd2ZqjDYzUzWv2cJb/Zxne61gOjIPJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d89Pw8WhojuHM1Q/i4jkWiFg7OUnGngxwYZcoBgDwiU=;
	b=DzuhWlXw1AqNPitXkWxffjLhYNSeiudqt7GWw/ZHPEj094oN7kUb673Nqe+J9m4nuGC4Hw
	eiYfwk8ETsGoNbUSMEBx0kus4E87F4q83sQECwYkjl+jRvUcAAK9MwSFoiBx2tvad8SFNF
	G4rGLz2WUymUsU14ggMjtGxvmbB+bMQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RXfHTpS7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782499621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d89Pw8WhojuHM1Q/i4jkWiFg7OUnGngxwYZcoBgDwiU=;
	b=RXfHTpS70Eq6o9IFUfZbK4HqUVFL7lKg6bSHpox2znXFCPCO2NC6WRm6KFnpFz7gOF6F2a
	FxLxeYA7GLnPQ+q0mltipwBRfLdH4GJnzYXW+aY3sVuNt9XgGi5AjuLSLXFsHjaBo1IMR7
	8e5kXsICluR6JX7OzjRHq9BqSzy3eiI=
Date: Fri, 26 Jun 2026 18:46:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Message-ID: <42f67f4ea908c862d11ca65aa3da51503bcb0962@linux.dev>
TLS-Required: No
Subject: [PATCH v5 2/2] mm: implement page refcount locking via dedicated bit
To: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Cc: "Linus Torvalds" <torvalds@linuxfoundation.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, ivgorbunov@me.com, Liam.Howlett@oracle.com,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, foxido@foxido.dev, harry.yoo@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
References: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 78DCE20002
X-Stat-Signature: b8r5h9os3w9y71n444fuzfnry4wepm45
X-HE-Tag: 1782499623-269827
X-HE-Meta: U2FsdGVkX1/WK6LAdQkoFbnC3KAKgo8+kFamar0+/z4Tde51Adjy2sTT5uCOkVFUc7lLTyi5+V9KmuIwqafIWbIvRK3bYm6dzkTt1hmaKCxbFcMpXkRwrb6K1/o2IPApFbELuQaFERUUBGJ3K+2gnBq7vz5CELYjTXkgL9OFFdfCajyM6PzWI/2MvAhYI+4f+uMCDdQAYSvYvXoPbzH6RK1FhN3h0RR/XLAlMRJmscVOw4GHvcIeshaX2Am5lSaTIOrP27r8LPrMc5Pa0SaOjqvSv9rjCA/VdWz1qikAv7Qka+vghVB5CiQg4U2unB4Qs56liVjSPBBxHw2FACTp+LznGz2GUmiwXZm/zBU8lILXWBlVWgTPSbYyHmUOBr9RhfGKtFxXkXpCqwDrk4ieVd+qxNKd87+VDAvM/DEnsgAzNkhpofO4Bq4Yohj+wADzvkGMjUxqEYulYgdE1CJPd6wVJuE3IczMrT7fLa/TKMa3MikPoF5a0sbj+5vIp/4j5k8uPCfdy3mtKZQqdHfovM1eawB/aO3xt9oBU5PL6srklFhjB0vZpKO8dnaecxRBTwutkcodh0fOOW6Xq57utKMf7D0ABMNyh6ww1LnAm9Emr1oYLaUG7/Zj7Oe7xJf3RqJdkvx5029Ui31lMBFdPd8Oza+KF/LbiE/n1JF69oxgT2Hu5jeyNFiAxeEbIrhervtGMKf2lrhcMQhjzTI40NfkIXA5/ysTK1YQhPgdYV0CnmiCvWLZ380eZUhaHuDwP5ezZQQMdPYsz3/PdmY8i78CQdxFSRaPQ8hjH25JCsFmNu/cCmYu819PYyHNoC+PqaBlGV3lIjxu8QMaL+NREc3bpTactjtAF3tEBLLna80Tzu7zDOyP7+YhMri9MBv+QQwOhaYFd+nzvvp83Nn9dZFUYHw61jHqP39DvmJLfC/MpTpA1bnyPd/7rcOcScKph7z6367N8DSUHqSyUFE
 kjwrOVr2
 lR/99QRISdaGKxxRwTec0VTl3wl7XoJv8mtP2YJ0SSbfJyKOkLRYzSL1aYA6Im6fkwecwI/7mJDxb1/Q/VSK53smPPfzJ0shn7hFSF+jdXb5dd6KUnAXGEfaYy1p+JJszVX6Wt721alRU6BwYJ4tB/qBfOoreGw1FrGP7ZoEWbTo14NRoJZHL8iHusU5IhTwI37v1vNJtpQ9WzENdkLTBoYJzrO8bC6Oh3lI2DfEf8Q4NSnj2wfc/vFR/vF3d15vQRuJ/yegA2cWijTQugaF/rtJ6aVNXRD/oBMWxErvDH0HQ5KCMFP3lFUE5HT9sqTMeE6jf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current atomic-based page refcount implementation treats zero
counter as dead and requires a compare-and-swap loop in folio_try_get()
to prevent incrementing a dead refcount. This CAS loop acts as a
serialization point and can become a significant bottleneck during
high-frequency file read operations.

This patch introduces PAGEREF_FROZEN_BIT to distinguish between a
(temporary) zero refcount and a locked (dead/frozen) state. Because now
incrementing counter doesn't affect it's locked/unlocked state, it is
possible to use an optimistic atomic_add_return() in
page_ref_add_unless_zero() that operates independently of the locked bit.
The locked state is handled after the increment attempt, eliminating the
need for the CAS loop.

If locked state is detected after atomic_add(), pageref counter will be
reset with CAS loop, eliminating theoretical possibility of overflow.

Reviewed-by: Artem Kuzin <artem.kuzin@huawei.com>
Co-developed-by: Gorbunov Ivan <ivgorbunov@me.com>
Signed-off-by: Gorbunov Ivan <ivgorbunov@me.com>
Signed-off-by: Gladyshev Ilya <ilya.gladyshev@linux.dev>
Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>
---
 include/linux/page-flags.h | 13 +++++++++++++
 include/linux/page_ref.h   | 32 +++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..ea9904a67334 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -196,6 +196,19 @@ enum pageflags {
=20
=20#define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
=20
+/*=20Most significant bit in page refcount */
+#define PAGEREF_FROZEN_BIT BIT(31)
+
+/* Page reference counter can be in 4 logical states,
+ * which are described below with their value representation
+ *        state              |         value
+ * (1)  safe with  owners    |   1...INT_MAX
+ * (2)  safe with no owners  |         0
+ * (3)  frozen               |  INT_MIN....-1
+ *
+ * State (2) can be only temporally inside dec_and_test.
+ */
+
 #ifndef __GENERATING_BOUNDS_H
=20
=20/*
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 61a2c9b9b73c..21257559b06f 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -64,7 +64,7 @@ static inline void __page_ref_unfreeze(struct page *pag=
e, int v)
=20
=20static inline bool __page_count_is_frozen(int count)
 {
-	return count =3D=3D 0;
+	return count & PAGEREF_FROZEN_BIT;
 }
=20
=20static inline bool __page_is_frozen(const struct page *page)
@@ -74,7 +74,12 @@ static inline bool __page_is_frozen(const struct page =
*page)
=20
=20static inline int page_ref_count(const struct page *page)
 {
-	return atomic_read(&page->_refcount);
+	int val =3D atomic_read(&page->_refcount);
+
+	if (unlikely(val & PAGEREF_FROZEN_BIT))
+		return 0;
+
+	return val;
 }
=20
=20/**
@@ -145,7 +150,7 @@ static inline void init_page_count(struct page *page)
=20
=20static inline void set_page_count_frozen(struct page *page)
 {
-	set_page_count(page, 0);
+	set_page_count(page, PAGEREF_FROZEN_BIT);
 }
=20
=20static inline void page_ref_add(struct page *page, int nr)
@@ -215,6 +220,9 @@ static inline int page_ref_sub_and_test(struct page *=
page, int nr)
 	int ret =3D atomic_sub_and_test(nr, &page->_refcount);
 	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret + nr), page);
=20
+=09if (ret)
+		ret =3D !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BI=
T);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
 	return ret;
@@ -245,6 +253,9 @@ static inline int page_ref_dec_and_test(struct page *=
page)
 	int ret =3D atomic_dec_and_test(&page->_refcount);
 	VM_WARN_ON_ONCE_PAGE(__page_count_is_frozen(ret + 1), page);
=20
+=09if (ret)
+		ret =3D !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BI=
T);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
 	return ret;
@@ -270,9 +281,20 @@ static inline int folio_ref_dec_return(struct folio =
*folio)
 	return page_ref_dec_return(&folio->page);
 }
=20
+#define=20_PAGEREF_FROZEN_LIMIT	((1 << 30) | PAGEREF_FROZEN_BIT)
+
 static inline bool page_ref_add_unless_frozen(struct page *page, int nr)
 {
-	bool ret =3D atomic_add_unless(&page->_refcount, nr, 0);
+	bool ret =3D false;
+	int val =3D atomic_add_return(nr, &page->_refcount);
+	// See PAGEREF_FROZEN_BIT declaration in page-flags.h for details
+	ret =3D !(val & PAGEREF_FROZEN_BIT);
+
+	/* Undo atomic_add() if counter is locked and scary big */
+	while (unlikely((unsigned int)val >=3D _PAGEREF_FROZEN_LIMIT)) {
+		if (atomic_try_cmpxchg_relaxed(&page->_refcount, &val, PAGEREF_FROZEN_=
BIT))
+			break;
+	}
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
@@ -307,7 +329,7 @@ static inline bool folio_ref_try_add(struct folio *fo=
lio, int count)
=20
=20static inline int page_ref_freeze(struct page *page, int count)
 {
-	int ret =3D likely(atomic_cmpxchg(&page->_refcount, count, 0) =3D=3D co=
unt);
+	int ret =3D likely(atomic_cmpxchg(&page->_refcount, count, PAGEREF_FROZ=
EN_BIT) =3D=3D count);
=20
=20	if (page_ref_tracepoint_active(page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
--=20
2.54.0

