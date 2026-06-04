Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B0ECD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727016B0005; Thu,  4 Jun 2026 06:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7F66B008C; Thu,  4 Jun 2026 06:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6157C6B0092; Thu,  4 Jun 2026 06:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5726B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:16:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAD45C1AC7
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:16:03 +0000 (UTC)
X-FDA: 84841824606.21.DAFE186
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id E854B4000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:16:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UyD3Flju;
	spf=pass (imf01.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780568162;
	b=qzoCwxd+HMeofStcl57UMakItLvTpyxyJ4eAPJf2GuZ+yvEjK9Qj5eYmJ+D0iLJCwB9Py5
	3R/R/qLTHURAfrTQaNpGo2M9ZWSqQEA7TGeY/4Ptbfo1PcYnXm0pY6dYFAUSvg8j5Whwc6
	JxV6Kt2aN7dJmf1IwGiLv6C4gPoNwd8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UyD3Flju;
	spf=pass (imf01.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780568162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qNmtiXuwb0Ppur00DNdkJYZlOVI0uDXAYEOqp9/VNI=;
	b=gFbX0fEZyRWuekkUD8JDiJfrqncsJK7LFLbmIRxgkqrx+XXdgQxnO0WpzUaBFWbuSEoVCo
	bOLCeMYVTJX07BqW8bw0rKPM122daTGjr/zKhewF782694Hu1rr7HYrTiIjiDSg0FgfL+Z
	XG0ghZIgfeUG5biCSXWkfOWk4RVOzSk=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780568159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0qNmtiXuwb0Ppur00DNdkJYZlOVI0uDXAYEOqp9/VNI=;
	b=UyD3Flju98zCYaKYt0PMZvHaHTND8cObc7KPKeG04gx7OvuAlpb1obDbKZcDnfGQtQNkSW
	APR8ElbuCra1w33GDt14lKRvgoVruHwlHm3OBxG5BP0Vfd8zVEnoMa3mdbkyLL2cKMwSfU
	Qsow44k1KDyZEt181NxxZiRFBpagmbE=
Date: Thu, 04 Jun 2026 10:15:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ilya.gladyshev@linux.dev
Message-ID: <9c0605c782299a2bb3ab6a8e73da26bafddea52f@linux.dev>
TLS-Required: No
Subject: [PATCH v3 2/2] mm: implement page refcount locking via dedicated bit
To: ilya.gladyshev@linux.dev
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com,
 pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <5dabf3a748fee0c7b142c74367e7586f5db1ed1e@linux.dev>
References: <5dabf3a748fee0c7b142c74367e7586f5db1ed1e@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E854B4000C
X-Rspam-User: 
X-Stat-Signature: 3zxtsarcto9rn1scgnbdutkgwouo9bfy
X-HE-Tag: 1780568161-398106
X-HE-Meta: U2FsdGVkX1+siptcjvGWSrQm/zqZ1HYg2FiheG6nGrcRDjnNo+r05pTGWXfOFZOgYSXE7xJmQAwdxIjoTk5vDn+LvSOvlkucpzvQepGRx29BctMBTQzblLl64bl7GphxdPYjJdNZNzhTRr6A7vJS0fingXm36MptneeTXHpZZ+c2Mor3FtmWNq7cCSOl4Ok1HPGhBrGr4qrsEDJ6wH47drjIlORF6146OH7CNweLZk2voiyuFiDIF+Lo5kIMkBqIzvviDcEhTjhaLvhu6ZhphUUS52R6QMY2web3fIQ/gOmzmBhbNHes5flnCyuZXeG871G3TMCvEYPYTVEHMemo5jvStEnoJE+048/9lC/YUDYcKw+6ENFlre0jlKPY3JCvITjZD3oJ7qh/GYNUSVpHQIpeN/TAxoDcaX10Wyv/diUoGQFAmHGK3+/vxGXyFJEBRrhBVM0Z3p8xr2TFsAc+kTUyAYJetv1F1fL3y97yAJiGIUTQRJWtV2qUWQkwfgrFtyHIURIbfWYP8iKqqA1y4tSOA01tpV7JpdbPZTy3/eahTWdivmAlQSiGVbc6OozRraATsVB+O3i26ZBeyjc01Vr8m32b9kIJ3Gbqhn3Q/6bmcsCBt73IeDlKJ3uSlZi6QLg2o2sIEPm+fapy2OS069sbTG6hqvK8xRoO1nLU9WRLERjr6ysa2FtjQKneNFtTXd/2ZvBlXFFi4fkJktdAztdS8jJ4MRspBYlfMerxCUAx6VwzEcttlY1Fv80XiZw7i7KSL5Jg//FB4mu+qwT8hvbOhiRjrQ1RrsnShGioRlMwIzXaT4GyCV1cRIs+R4pFya4NLVx+UCxJjwCwwkktu702UqTw49jj5hTD+JXYFkNIMOCcTxUdDIjECecorzBVkgH4T7ZXO9q1w/F709oyfAongtVB1peTa6UXals5C5KonDKqvUreoh3qudRP/ysiCgGTzEDnuQiTP7gY5Cq
 55yB7b86
 UeQoWyLdoI5SimFnRsZX0HvHE75kMIqkE0+K9fptnKkiP2oMxgxYqnu+PlFlLCDzqOHBYvhzzgyBAK6m5GBOxJNiwhv2xaXmdqNxpvcHYrMY+n0D66cjSf/UIOWcorkDCgNImEo5jSZFaptfeLcSiNbwvq8KjNNK45y2hULrwzuZukeTBTGpqFXepM43j5nZwUeP5BSMGjK++bPlLxNPexvcjkmLAFP8D44clMUV/qoRCcmyr+/kCeRB6qwO0rnZeHeIbMwx1K5aTZLHmlsW2hRwE1JmqTsm0wfPzSQxrL7Ay39kskOUjeVyhNjEGABkb+WO0
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
 include/linux/page_ref.h   | 28 ++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 4 deletions(-)

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
index 24b09c8fbb68..b041894b6659 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -64,12 +64,17 @@ static inline void __page_ref_unfreeze(struct page *p=
age, int v)
=20
=20static inline bool __page_count_is_frozen(int count)
 {
-	return count =3D=3D 0;
+	return count & PAGEREF_FROZEN_BIT;
 }
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
@@ -191,6 +196,9 @@ static inline int page_ref_sub_and_test(struct page *=
page, int nr)
 {
 	int ret =3D atomic_sub_and_test(nr, &page->_refcount);
=20
+=09if (ret)
+		ret =3D !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BI=
T);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
 	return ret;
@@ -220,6 +228,9 @@ static inline int page_ref_dec_and_test(struct page *=
page)
 {
 	int ret =3D atomic_dec_and_test(&page->_refcount);
=20
+=09if (ret)
+		ret =3D !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BI=
T);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
 	return ret;
@@ -245,9 +256,18 @@ static inline int folio_ref_dec_return(struct folio =
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
+	while (unlikely((unsigned int)val >=3D _PAGEREF_FROZEN_LIMIT))
+		val =3D atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_FROZEN_B=
IT);
=20
=20	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
@@ -282,7 +302,7 @@ static inline bool folio_ref_try_add(struct folio *fo=
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
2.43.0

