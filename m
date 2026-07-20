Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88AF4C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089116B00B6; Mon, 20 Jul 2026 15:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F066D6B00B8; Mon, 20 Jul 2026 15:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32E46B00B9; Mon, 20 Jul 2026 15:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92BBC6B00B6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F37E5C0234
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:27 +0000 (UTC)
X-FDA: 85010159094.15.F2FCC8B
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 413AD120002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EfrZhJnu;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWSndD15nfA3ulYoFeibVziNkAccxURrSPvFkTAURcI=;
	b=uTFQTbZYWVyIu+ly68QG6H0rLHSzrJB3HOuplaYSrI01rmocSY9R6R1d4pJpN3BGcE4i9W
	oNXrluwSj6FD7uu2KUW7dYW4cLMZEahu7i0qO6p7NOy0eBSxTyv7wjVgTW33SaJ1yRD5A7
	+j0njRXwJr/Hu3+EbESiIuLWRVYcVSA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EfrZhJnu;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576126;
	b=AEHV6Wbkq4gc5mxwuqQB8AavM4gxcB4fSrFLVi1TUHHGxithZ6uX5InBluWeVlI0ARcp4X
	Kon+0j7Fc+OwMMUjy4BkzfDdjdoEui9ek95MZL6R4VUz0ao2Xx97S27QI0uppp64oAKNgW
	FhihR9+ptn3+cJ/rnUqe2effJN/GddI=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92ed19f4d60so369313085a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576125; x=1785180925; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wWSndD15nfA3ulYoFeibVziNkAccxURrSPvFkTAURcI=;
        b=EfrZhJnucUTFXANJwxKsPXv9WCmVGPCHqDz1Tmmg2C61fIWCH4azLUKtThw4zF90ET
         iMj1qLUlnumlEgM1GW+qQL7ZTk1NkFQCq4sPk4+9kA+Wpr/T2m+FPDNuRVuQfUlffuWE
         HmIGLnLd5F8vIzt7KxjgV8Szchu++ZcRFKgy0XoOMPi2snrbiccEwrx/BEZfLsaI9CwB
         JByTO8B9PNM7FpC1dPVpbghK04PPDON3ZzO02hH6jlYF8H9tUmXkEGP45lwv1IPYJpuI
         2rajkJlKXswXEVQ2GFlnVmQ2mes0agFUa7sleIwTFoT6dgjjlmzgqKBFG6YcMkY6t9PY
         paKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576125; x=1785180925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wWSndD15nfA3ulYoFeibVziNkAccxURrSPvFkTAURcI=;
        b=aYyRw+ifWOR1aLHqPf8fAS6rJFXte8pbwrCwaFDa0AhgpCcGRKBA76tQHUqRtiwfWx
         2KZiyV+2mUGsfv8VuAoAbydTBry9XYnJX76OZMVWhIMkLQPjR2dz9XZIaYAh/uGZNgZl
         Yjxp3lYM7eyRgqNUeuLUL15bfACzJPVoPgt1iae++MR+zCxsLQSfEwyec+fU9EeTbs5o
         dU9mR7ag60ojtrjGmtNH2Q20uxnYlei7KGU2HQtmGeTpdxPEmXtjYz4V9ZATuDO20Rh0
         5kazllOgR06YAMISC6xaZZbtte+liYgseDn67Z9D1KPFUPbI0Cjmk5dJcIyOUogHN5Bs
         buSA==
X-Gm-Message-State: AOJu0Yw6puLQPJw+9B/HH1ieBSdLTdVmzcQC7Bl76O6rmYzm7bbGU7xJ
	ak8RUVDFCVQrOcXRYd66mt301TpfZ5Ex7DrJAIfmgAW8mBY9qlBsoI+XfD+DBXCu8vLVjy1qlrY
	Q1wqG
X-Gm-Gg: AfdE7cmpdVuGnKUNNLvojY4COXRYtWUHELwmukSTGoPz8vHaBo1JlYTp832ZktZG8CH
	X/NYR/Qp+ygfyRVBfb21gXytJEv3kKCo+P9WobSdUDWUY28pqaDLP2bp/oA3uUS/5awxcB6Hty3
	U1DOoH9zXkNNPgU4BzFKtQBlndDiaiVBsxeX7k47IkT/A/kMD72y7+tBeXMUngxFvxYMYik/JEt
	Ws7u9/6keajr4yGgTcyXImxCKHB2zPikIoIejG1Y2vbks6HiH1HK+1y42sX4Js1mhLynVU0JqDb
	FtEdHn1ZbsCyXpu1jAk/BhHy8AZ7F0a4HSGMdOwtZ+ZuZK4G/zV7BAR/ygKmsXV0gOWF6W/yb4l
	txWlmLthqzQLBv9kuqDErGqYTRDlZEDIR6dr0nOkSANvHSjmyrikqGz/PDtiDvAHZbrSZn58cEQ
	qF/k4grrOlNkQNbh06Cq7NXPxR7gB6SbcQe0A0m9D46f0xgTyM9MwiLm0CHLnVJEA=
X-Received: by 2002:a05:620a:2913:b0:92e:f2cf:56f9 with SMTP id af79cd13be357-930b4830467mr1569223785a.9.1784576125333;
        Mon, 20 Jul 2026 12:35:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:24 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 18/36] mm/gup: disallow longterm pin of private node folios
Date: Mon, 20 Jul 2026 15:34:12 -0400
Message-ID: <20260720193431.3841992-19-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 413AD120002
X-Rspam-User: 
X-Stat-Signature: ym9mrse1c85r3m9cd87qr7ckc76kkkrh
X-Rspamd-Server: rspam04
X-HE-Tag: 1784576126-831646
X-HE-Meta: U2FsdGVkX18Ix9F2UFDPtWxmdUppG7tqi/g3aPndCfkK2vwmC0KD0f/zrQwQFVlxOIZRUz6RtaFvt2j5SwwG48ouM88OZnJwUcO0f1vvwjGkfXOxfON5/fFlRrratF4KReeZjm9yIUk9U8gbDSTXOoC45iknvNW6E4YL3UuC4sZdGh51VDywDj0BE7ha2ZmFgpuDreqARQxLaeSAx+K93PmnRaZNIkq2bozLfSw7H9zuFw6VPihiIF+KbtYO344sYiRQdoA8SqeIxGn/ucM58iphts5nWnpTROgzyV7yer+HTF6yZUe/Chm8F4zEwF8ee+jS2fEnTo5TYAEblAaEKK2NPlgKHJmiWQXSsDPJ+OWU03LMc12WCu6yL0m29Vp2gyaVAHaOPZg9D8vBXEcKJqbVfqFrGfFA6+xv+I7GYQmb1k0JUiq2QuuJTWyrj5GtNUHnV5PffLyfOv1HNMfZ+T1TEfvwtBOFz5kym5LQ9SAXHuFbBtR03lf453qWRU1tT5rJZZlUQQ5PpeY03lhNsQYein/bBJIGEepGFUYCbvcq9l9tdILMtB93f9x+qv+1OoHPS/z4zSJq35/LNGFy7UmjJZzin1RIUoHPAhP+q69a0Oxd6nYRRJ4T6Iw10Qn5HArOdf9PCo6Na8XdOeZlVsZB7n7xZ8zcrZ6BKnJC8C2CTqKdrduGf1+k8wlA29QIwBdsm7sZjwwcqkLlQqikb3pzy9qtCzjm8LpsiBUiu8BcuGOryly2mpniu/nnNu5fZD6qJcYpHqiKXrEQ0H4r/Tkydar4Vkk9sl9sPEMW8A6iU/xuVfyVKFg9RlnHx1CgJbJaygeLlrYA06lgCDjF25rxSqH3Y0A+vCUokZ2If4yEYvL4FwjD6twV/RbDps1L5d1flJAq/y6hUwjXFoZz3kuN+c2nEsVEoz+7kBR/vBxGAbGXlPdpXgzoJ4IPW+sq0MKfhcufhhwG4JpO8jt
 qxCVRedn
 Ll6jLbyb9WjhP9Wt3IDIcYW1SepQSGK1dIPtbemKdnng3jsBCC1SKRH31zu188rkzUZxzZeRKxv0QKXhTOqDcY2ZuXDwKCO0jeewJKhrC8F0l7p6mlOJNKXcc3BajI19t0Mk0TQdW7x3JvSrCC2dPrclCa/ErGUmQ1X1bD6N9Br3jTFfcwPsZBfu/bVmSFj+MK+7BQF5reaICE239q0CKteNuL+l2mJWVznpztzrLkU8HgMLR4goEKgn20FI99QjUDlhcsIvGtiWntpxYt3kjZUjD9lOqtKunTlyRqsicB/Ed9q1QKuMNkaF+YHi1IbQRyvnXeYw+LBOMfvjzgqVsQD3rbH/5o1RZHbdR7a5sVh3fFwBt0Tv7TUtjw0BM7jABWpjh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FOLL_LONGTERM on a N_MEMORY_PRIVATE node folio is wrong both ways the
GUP longterm path resolves it:

   a ZONE_NORMAL folio would be pinned in place
   a ZONE_MOVABLE folio would be migrated off first

A private node folio should do neither - the pin should fail in place.

Add folio_longterm_pin_forbidden() (true for any private node folio) and
reject such a pin in check_and_migrate_movable_pages_or_folios() before
any isolation, so nothing is migrated.

The gup-fast path defers a private folio to the slow path via
folio_allows_longterm_pin().

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/gup.c      | 27 +++++++++++++++++++++++++--
 mm/internal.h | 25 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 1d32e9a3dc79c..a7d4de223785c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -547,10 +547,10 @@ static struct folio *try_grab_folio_fast(struct page *page, int refs,
 	/*
 	 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
 	 * right zone, so fail and let the caller fall back to the slow
-	 * path.
+	 * path.  Fail for private-node folios here so slow path rejects.
 	 */
 	if (unlikely((flags & FOLL_LONGTERM) &&
-		     !folio_is_longterm_pinnable(folio))) {
+		     !folio_allows_longterm_pin(folio))) {
 		folio_put_refs(folio, refs);
 		return NULL;
 	}
@@ -2389,12 +2389,35 @@ migrate_longterm_unpinnable_folios(struct list_head *movable_folio_list,
 	return ret;
 }
 
+/*
+ * True if any folio sits on a private node whose folios may not be longterm
+ * pinned.  Such folios can neither be pinned nor migrated, so the whole pin
+ * must fail before migration.  Checked before any isolation occurs.
+ */
+static bool pofs_has_ltpin_forbidden(struct pages_or_folios *pofs)
+{
+	struct folio *folio;
+	long i = 0;
+
+	for (folio = pofs_get_folio(pofs, i); folio;
+	     folio = pofs_next_folio(folio, pofs, &i)) {
+		if (folio_longterm_pin_forbidden(folio))
+			return true;
+	}
+	return false;
+}
+
 static long
 check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
 {
 	LIST_HEAD(movable_folio_list);
 	unsigned long collected;
 
+	if (pofs_has_ltpin_forbidden(pofs)) {
+		pofs_unpin(pofs);
+		return -EFAULT;
+	}
+
 	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
 						       pofs);
 	if (!collected)
diff --git a/mm/internal.h b/mm/internal.h
index cb9f4a8342e32..85c460296cea1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -110,6 +110,31 @@ static inline bool page_is_private_managed(struct page *page)
 	return folio_is_private_managed(page_folio(page));
 }
 
+/*
+ * folio_allows_longterm_pin() - may this folio be long-term GUP-pinned?
+ *
+ * checks folio_is_longterm_pinnable() rules plus private node permissions.
+ * private node permission is checked here to resolve circular header
+ * dependencies in folio_is_longterm_pinnable.
+ */
+static inline bool folio_allows_longterm_pin(struct folio *folio)
+{
+	return folio_is_longterm_pinnable(folio) &&
+	       !folio_is_private_node(folio);
+}
+
+/*
+ * folio_longterm_pin_forbidden() - must a longterm pin of this folio fail
+ * outright (neither pinned in place nor migrated off the node)?
+ *
+ * True for any folio on a private node: such memory can be neither pinned
+ * nor migrated, so the pin must be rejected with the folio left in place.
+ */
+static inline bool folio_longterm_pin_forbidden(struct folio *folio)
+{
+	return folio_is_private_node(folio);
+}
+
 /*
  * Maintains state across a page table move. The operation assumes both source
  * and destination VMAs already exist and are specified by the user.
-- 
2.53.0-Meta


