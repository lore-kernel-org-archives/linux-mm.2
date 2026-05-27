Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8A2CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21BE56B009E; Wed, 27 May 2026 07:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2110A6B00A0; Wed, 27 May 2026 07:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91616B009F; Wed, 27 May 2026 07:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D25546B009D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90869140560
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:08 +0000 (UTC)
X-FDA: 84812925456.07.6C225ED
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5387A40006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Ig32bQFm;
	spf=pass (imf17.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880086; a=rsa-sha256;
	cv=none;
	b=XWluVkRo3EK9+uqVoLGXO/MLnDZ9jgzUEv/Ca2IDyCd0CF1FZ8Lw/3c8wFo5EOLj96/g9U
	QehINiKqLQWnSuGa/lC4rMSu29mrqzHUc5cIiLuCgZYCxPvoXBDhumKmDNFPZz6WzvV/Er
	xrRUask9lf/ZnUNv72IL/+AyoHfEjPE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Ig32bQFm;
	spf=pass (imf17.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAh+iwG70E8JH4DQIjXnQUcbO61+yXM/nHjJfWOvA0k=;
	b=DPCI2dODRo2j+ecrUPRN0W8IgdX+eTKj3c1xKP6/TqIwJWa+Zhkp5sMarpxHziSaSQHZri
	DyI5Qd/mng2xoQpCurwRc/IMoC30deQlKiUyVaqjECbhP4kFeJ3e3tqzXATsask2AvpOr+
	eghbbAMoCDbYPXG8gir6gEX+HZJDnZQ=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=yAh+iwG70E8JH4DQIjXnQUcbO61+yXM/nHjJfWOvA0k=;
	b=Ig32bQFmc8INY3BCfFA6LQ4UzcwpW/JGe8sael1tqJqOBLk3oox+I6nqUUIGex1n1N8pQtIJk
	yVZGl4/RXGdJkFp/kao4vzp2Ip99gxCSnwMPPcUQ6r8gz8VW+NPUDa6Zk3T7/N6YcDsm3X97AlG
	aefu1iGJ0x1tJNI3J3TBcXY=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRdg4PV6zYl1N4;
	Wed, 27 May 2026 19:06:47 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:02 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:01 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 12/15] mm: handle ANON_VMA_LAZY during migration
Date: Wed, 27 May 2026 19:01:44 +0800
Message-ID: <20260527110147.17815-13-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Queue-Id: 5387A40006
X-Rspamd-Server: rspam03
X-Stat-Signature: ft3bysy5xiis71sbeegm3nzzkcaid5na
X-HE-Tag: 1779880086-190746
X-HE-Meta: U2FsdGVkX1/rv0f5ZMX/4uikv5gS0ZC3WNLehpmMJdutSL5x1UxIGUcCUQYM9qxctYUpFVGbwnE8OKQ/Jd8eAFdnhOnC4yCnhu7GSk6QzURjkEGgKDx3rUN1V/Q4V16mFfuXIvlh8EkOh1h60Vsx+P53CdmoHNeXxl6+BsgKHr2J5kTngaGLg7sa2cZWiRzsuczzSogrW3e7TNRW/Jg+54TBYHLPL7UqMuAUbVup1BEnLwITaGppCF54cVSiCbPwGJ/i6BIODC2+i7/oaVh3cS1z8nLRmBDiE9ctuSDnPLodpt3D9nD21WTcIe8wQNfHkjOY6i8+oadYkvlzl3pv9AbM21DKBHbPDBDjw+qegBm/NFMGDzCm5kY+1rYByf419DXzbHL7tWqIaBdJf4+vSvb0YKV+DL3EeJuRu0vMbQgegW7Qz1QNh294NkDx/VrZWxCX5hkxp0qQ/HAyQCyvGWZOx031uGjSDxPML20fALEDKwg7HIZXehuU4kjPd6TDhJDJU+ihGZWUqxZ2/i6FCanmgdNZu2bDXP9SDNnFu8V9iQZM1PMVAS0djmAShT4/1u0BCS1Ny4B+XXryCpvx+VuKYzF98x4ZTuHEA1I89MiAqqzb8WqiLMZsFHd5LIPtaYYuTMSvuBccWFeuvw8fAC+4I0gA0md4qwFY0jmh92ChUBNQG4DwkfbHTdPKnbeu1hojMFdw1ZVQPVKhrL2YtX2pKJ805cvXn8N8KtpJvfvEnGPGUfPNA+YWuJeCc0eG0SmrLwplsXzk64OwkpqzFH2DiSXQyA8MiVfxc+/oFheo12+hSE3zobwdYBSiUv+3q7P3uzIVXPHhAcka5HOCWq/xMSTUzDgIeuz13NdrdiYF4IjQJtBdYpNTzzKcWQaAEr2Q24sn+4O70ObyoeivfAhdvuYfx4VTTlacyB+3j4oPEvTDyJCaSqG3MTWUjVgbi3unQnS8sr3jbgWfRRU
 mFGSRFH+
 uOwhh9YxD6TAlxYPUrtfgn5iU0oVmAFdP1MfCmHnAD0iszvlsNmpOj/3VBNzoi7g4q0nZ7R5q5Rj/CUpFD3blovA6XnqvUEvjNCl+RUIpUwCaOBdkodqT536FIWEjoQc55fi9L+l+DqNwigdLjHUjp+IuNoC791soH5pTsjrr5g+Tu8VFOWuc8Su7k0CgmMYpiUj9RuyaGYGO2xgIcX2oJkJky+rcHwVfjSkCTjAKsGn7IeC5HXZwlmYYFfbryXuk0wGhlOcQjk/odzQZzHGD0vM/dFHTRIN0mrpxEVjCUXsPbov4TRONOR34UktsMWqjT6SEthak1JB5qAE4LoOBtj4Q4R/Z2NV9rI02ey4J10yTPYi+rbRV+VtcXAZVsNCXo80I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To ensure the atomicity of folio migration, introduce
folio_trylock_get_anon_rmap().

This helper guarantees that the migration operation is mutually
exclusive with free_pgtables(). For ANON_VMA_LAZY, it uses
vma_start_read() to prevent the VMA from being modified or removed
during migration.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/rmap.h | 12 ++++++++
 mm/migrate.c         | 71 +++++++++++++++++++++++++-------------------
 mm/rmap.c            | 40 +++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 31 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index ebe9f3f61170..59244481a8c1 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -1042,6 +1042,18 @@ bool folio_maybe_same_anon_vma(const struct folio *folio,
 anon_rmap_t folio_get_anon_rmap(const struct folio *folio);
 anon_rmap_t folio_lock_anon_rmap_read(const struct folio *folio,
 	struct rmap_walk_control *rwc);
+/*
+ * folio_trylock_get_anon_rmap ensures that the migration operation
+ * completes atomically and is mutually exclusive with free_pgtables().
+ *
+ * Note: for ANON_VMA_LAZY, this is not equivalent to
+ * anon_rmap_trylock_read() + folio_get_anon_rmap(), because
+ * anon_rmap_trylock_read() only increments the VMA reference count,
+ * while this helper uses vma_start_read() to prevent the VMA from
+ * being modified or removed.
+ */
+anon_rmap_t folio_trylock_get_anon_rmap(const struct folio *folio);
+void anon_rmap_unlock_put(anon_rmap_t anon_rmap);
 
 static inline struct vm_area_struct *anon_rmap_iter_first_vma(
 	anon_rmap_t anon_rmap, unsigned long start, unsigned long last,
diff --git a/mm/migrate.c b/mm/migrate.c
index b397cdeab09a..4abbfd1faea2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1173,10 +1173,11 @@ static void migrate_folio_undo_src(struct folio *src,
 				   struct list_head *ret)
 {
 	if (page_was_mapped)
-		remove_migration_ptes(src, src, 0);
+		remove_migration_ptes(src, src,
+			anon_rmap_value(anon_rmap) ? TTU_RMAP_LOCKED : 0);
 	/* Drop an anon_rmap reference if we took one */
 	if (anon_rmap_value(anon_rmap))
-		put_anon_rmap(anon_rmap);
+		anon_rmap_unlock_put(anon_rmap);
 	if (locked)
 		folio_unlock(src);
 	if (ret)
@@ -1279,6 +1280,18 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		folio_wait_writeback(src);
 	}
 
+	/*
+	 * Block others from accessing the new page when we get around to
+	 * establishing additional references. We are usually the only one
+	 * holding a reference to dst at this point. We used to have a BUG
+	 * here if folio_trylock(dst) fails, but would like to allow for
+	 * cases where there might be a race with the previous use of dst.
+	 * This is much like races on refcount of oldpage: just don't BUG().
+	 */
+	if (unlikely(!folio_trylock(dst)))
+		goto out;
+	dst_locked = true;
+
 	/*
 	 * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
 	 * we cannot notice that anon_vma is freed while we migrate a page.
@@ -1287,26 +1300,17 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	 * File Caches may use write_page() or lock_page() in migration, then,
 	 * just care Anon page here.
 	 *
-	 * Only folio_get_anon_rmap() understands the subtleties of
-	 * getting a hold on an anon_rmap from outside one of its mms.
+	 * Only folio_trylock_get_anon_rmap() understands the subtleties of
+	 * getting and locking an anon_rmap from outside one of its mms.
 	 * But if we cannot get anon_rmap, then we won't need it anyway,
 	 * because that implies that the anon page is no longer mapped
 	 * (and cannot be remapped so long as we hold the page lock).
 	 */
-	if (folio_test_anon(src) && !folio_test_ksm(src))
-		anon_rmap = folio_get_anon_rmap(src);
-
-	/*
-	 * Block others from accessing the new page when we get around to
-	 * establishing additional references. We are usually the only one
-	 * holding a reference to dst at this point. We used to have a BUG
-	 * here if folio_trylock(dst) fails, but would like to allow for
-	 * cases where there might be a race with the previous use of dst.
-	 * This is much like races on refcount of oldpage: just don't BUG().
-	 */
-	if (unlikely(!folio_trylock(dst)))
-		goto out;
-	dst_locked = true;
+	if (folio_test_anon(src) && !folio_test_ksm(src)) {
+		anon_rmap = folio_trylock_get_anon_rmap(src);
+		if (!anon_rmap_value(anon_rmap))
+			goto out;
+	}
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
 		__migrate_folio_record(dst, old_page_state, anon_rmap);
@@ -1331,10 +1335,14 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 			goto out;
 		}
 	} else if (folio_mapped(src)) {
+		enum ttu_flags ttu = mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0;
+
+		if (anon_rmap_value(anon_rmap))
+			ttu |= TTU_RMAP_LOCKED;
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_rmap_value(anon_rmap), src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+		try_to_migrate(src, ttu);
 		old_page_state |= PAGE_WAS_MAPPED;
 	}
 
@@ -1415,7 +1423,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 		lru_add_drain();
 
 	if (old_page_state & PAGE_WAS_MAPPED)
-		remove_migration_ptes(src, dst, 0);
+		remove_migration_ptes(src, dst,
+			anon_rmap_value(anon_rmap) ? TTU_RMAP_LOCKED : 0);
 
 out_unlock_both:
 	folio_unlock(dst);
@@ -1434,7 +1443,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	list_del(&src->lru);
 	/* Drop an anon_rmap reference if we took one */
 	if (anon_rmap_value(anon_rmap))
-		put_anon_rmap(anon_rmap);
+		anon_rmap_unlock_put(anon_rmap);
 	folio_unlock(src);
 	migrate_folio_done(src, reason);
 
@@ -1485,7 +1494,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	int page_was_mapped = 0;
 	anon_rmap_t anon_rmap = ANON_RMAP_NULL;
 	struct address_space *mapping = NULL;
-	enum ttu_flags ttu = 0;
+	enum ttu_flags ttu = TTU_RMAP_LOCKED;
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1519,11 +1528,14 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		goto out_unlock;
 	}
 
-	if (folio_test_anon(src))
-		anon_rmap = folio_get_anon_rmap(src);
-
 	if (unlikely(!folio_trylock(dst)))
-		goto put_anon;
+		goto out_unlock;
+
+	if (folio_test_anon(src)) {
+		anon_rmap = folio_trylock_get_anon_rmap(src);
+		if (!anon_rmap_value(anon_rmap))
+			goto unlock_put_anon;
+	}
 
 	if (folio_mapped(src)) {
 		if (!folio_test_anon(src)) {
@@ -1536,8 +1548,6 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 			mapping = hugetlb_folio_mapping_lock_write(src);
 			if (unlikely(!mapping))
 				goto unlock_put_anon;
-
-			ttu = TTU_RMAP_LOCKED;
 		}
 
 		try_to_migrate(src, ttu);
@@ -1550,15 +1560,14 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	if (page_was_mapped)
 		remove_migration_ptes(src, !rc ? dst : src, ttu);
 
-	if (ttu & TTU_RMAP_LOCKED)
+	if (page_was_mapped && !folio_test_anon(src))
 		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	folio_unlock(dst);
 
-put_anon:
 	if (anon_rmap_value(anon_rmap))
-		put_anon_rmap(anon_rmap);
+		anon_rmap_unlock_put(anon_rmap);
 
 	if (!rc) {
 		move_hugetlb_state(src, dst, reason);
diff --git a/mm/rmap.c b/mm/rmap.c
index 57cd85efc50a..46876b3dbfbc 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1223,6 +1223,46 @@ anon_rmap_t folio_lock_anon_rmap_read(const struct folio *folio,
 	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
 }
 
+anon_rmap_t folio_trylock_get_anon_rmap(const struct folio *folio)
+{
+	struct anon_vma *anon_vma;
+	struct vm_area_struct *vma;
+
+	if (folio_test_anon_vma_lazy(folio)) {
+		vma = folio_get_anon_vma_lazy(folio);
+		if (vma && !lock_vma_under_rcu(vma->vm_mm, vma->vm_start)) {
+			vma_put(vma);
+			vma = NULL;
+		}
+		if (vma)
+			return vma_to_anon_rmap(vma);
+	}
+
+	anon_vma = folio_get_anon_vma(folio);
+	if (anon_vma && !anon_vma_trylock_read(anon_vma)) {
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+	}
+	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
+}
+
+void anon_rmap_unlock_put(anon_rmap_t anon_rmap)
+{
+	struct anon_vma *anon_vma;
+
+	if (!anon_rmap_is_anon_vma(anon_rmap)) {
+		struct vm_area_struct *vma = anon_rmap_to_vma(anon_rmap);
+
+		vma_end_read(vma);
+		vma_put(vma);
+		return;
+	}
+
+	anon_vma = anon_rmap_to_anon_vma(anon_rmap);
+	anon_vma_unlock_read(anon_vma);
+	put_anon_vma(anon_vma);
+}
+
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 /*
  * Flush TLB entries for recently unmapped pages from remote CPUs. It is
-- 
2.17.1


