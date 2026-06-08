Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87495CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18386B0005; Mon,  8 Jun 2026 17:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF5B6B008C; Mon,  8 Jun 2026 17:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CBB6B0092; Mon,  8 Jun 2026 17:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3A5E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:54:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95D068D262
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:54:59 +0000 (UTC)
X-FDA: 84858101118.20.6755161
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf02.hostedemail.com (Postfix) with ESMTP id 095B28000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:54:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d1qhtuG4;
	spf=pass (imf02.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955698;
	b=6tEN1hSbDTspmGwyYkcquGzbySWMGs3K2v3+Pa4kZz9s58Sgs2/4MWScsWPMA4+HRV6XIl
	Gr0gTPMzVVi7BHib1qQBCIpNPtxNR5P9c8ZIrBLmiwe0CkOHArqM2cWrDS56VhtovA+aeK
	TDbUaZUlHGc9P3TlqZXSjSGIOtI9TpI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d1qhtuG4;
	spf=pass (imf02.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oj0FtlSLZIgUilMGC2OWnVi83GOu9tr2O5wNkJKwS4k=;
	b=pryzcpvnr8Gcn6URQ9LIKl76ou78nbThEuoQ13+Uo6Pj6FjehMWA/PMqF8eHGz1SwaIU0P
	s5EG3wpEslRnjMygWr3RevNKGt9usolLE4jAR1envc2LyyabIOC2AhJh0ciyAzlt7G+aVs
	uUcAF5lFnBSoK9bAUCEsLgfShQAkmFg=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780955695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oj0FtlSLZIgUilMGC2OWnVi83GOu9tr2O5wNkJKwS4k=;
	b=d1qhtuG4utbrN65jFZqeHIptfYaBVoeiLBxCt65fHvUAUKlxFDtGGQskKAozUOVBFwzOST
	TLGKvTH/EYM3h0YY0iX14U4T1zT7pYP+FAycn34C7qu8ix1K1DW7pZWHYEiSi+7AMsaTK6
	ub6GSgGmoV0zgbRWdAwv7g2SX9ChAe4=
Date: Mon, 08 Jun 2026 21:54:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Message-ID: <60e07ae8452aea4d88148dd70271d1812420e21e@linux.dev>
TLS-Required: No
Subject: [PATCH v4 2/2] mm: implement page refcount locking via dedicated bit
To: ivgorbunov@me.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com,
 pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 095B28000A
X-Stat-Signature: izef8rewdjzzhtemygob7hyinft4rdmi
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780955696-135032
X-HE-Meta: U2FsdGVkX18u1C5p1zkKLWh2xreChr1bBtk697KIQgZwQlIkvwwlcQLL3u6AkvfnD5zOhWtSrhrVbQAtMGbKWQBlrm+zZLH1SEk8Lc2O+pr4fDK2Ugfy9UAYwizGv0nSTDl/xSHuqXZ/dUIe38GJeH6zyNGR0XfSnAemOHZZ5co9j+PjvCIWE5IgqJ74u0EGwTsGAsEiu5FNo6qw6Vo5/Pf5uXabshcMW+xHWwF5dZvIqw15mq982jnPtCTAURRKHczySw64n+A48lrub4/P5za3qzNXWdYl02k7zClKm116SjzoYqDlaxbcgMLfvrUc6swzHvyj4o5yctNquKPFupcC+Hrhr/UEZ6Kf+0V8xfXI9qPTMSJupn4QFLo1qbnIRlaSlGZGUabDQzq1pdgm95y/kFwaKvW89DKjmskzRnhTnMJQVd0ucGiBk/Vnh52RzUKlMcm0RuMGIJxUDf0L5cliK9lbmI+sFePAI7tR8JKtexXfQZt+16OPk6in1EHpArfhiJmcCqycvKMNe/MpjjnCDX0nr+GPhHXULtAsOdwCiM6DG3fR6xz+sNIjpKxjQtFB6K/QwCz4pL4CDF2l4MGvp8hAgl/bPcLmrU6/hnQE0CowCyo8H+z6Qq5nqwJ9EwiDeECGadPKLv3sDeLKkrjzBgTx4RjYaoPYaxQI1+LwrM/ab9RRo5+23yHxQDNHZJUaw6uWggowvQXQbmvLbR46ugsm2yl9rWYysqMT0cVOB/Q789SVvpjiInerqiAvWnTeNqZGH3180tNyiGOKVza0/OrBLat54n48nGCTB5+i28VSRRCsIp23K8Y9LGkJ6WxRLVNKOLSMgy07NRfDiiZQgQEWu/VZxcfWUs1NDnmmRP35phS5J5HDYKy01IhXnGGExHOET1QSxMhmfCo5Vt6vdYtWG1eFpP3eDQNcZs6pOk6qs74Px2DtFlSxepXT23PYWUR3Ki+l0m+amnS
 iV26YIDd
 Yehh7TI+SNLC6AdQ9PNqh/p1G2fEFhN647/AQZcWx1BsnHox6+adlkvP4avQWI6ro3p8D9uCcjkkFTHoPlP4R1MZPu6OjY968mh3zAva0Hz8IYYy2IyRTxM3hBpyl027xR1kV3glWgj8wFJ4Ewe4MvPS5M0DGUTwvAtvLsgQRAUiyHxg3c96Juv8yj+P5QFtqWocHdxNJBBsybni0Jv2wYv5Lucne6k1kBYQue5fDYg2qcfTLvwJuf2VZ75be95PkQi/7HBVkNzdaEcH+hGepKtKs5dLhtjbfKzJCvRiJb3a/RJgwMWRKKnpprCROfQCuh38J
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
 include/linux/page_ref.h   | 30 +++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

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
index f784db6f775a..64ee0838c52e 100644
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
@@ -127,7 +132,7 @@ static inline void init_page_count(struct page *page)
=20
=20static inline void set_page_count_frozen(struct page *page)
 {
-	set_page_count(page, 0);
+	set_page_count(page, PAGEREF_FROZEN_BIT);
 }
=20
=20static inline void page_ref_add(struct page *page, int nr)
@@ -196,6 +201,9 @@ static inline int page_ref_sub_and_test(struct page *=
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
@@ -225,6 +233,9 @@ static inline int page_ref_dec_and_test(struct page *=
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
@@ -250,9 +261,18 @@ static inline int folio_ref_dec_return(struct folio =
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
@@ -287,7 +307,7 @@ static inline bool folio_ref_try_add(struct folio *fo=
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

