Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E0C5C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1CD6B0093; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3BD6B0096; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944C16B008A; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC616B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A82FA16075B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:27 +0000 (UTC)
X-FDA: 85007790294.17.8AB1963
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf27.hostedemail.com (Postfix) with ESMTP id 828D540006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VIThfSyI;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784519725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=am+19/5kAwq2nurOsVBVrTqc8AGbedae4TuQBKH9vBE=;
	b=oYJ9FfK9ZCFzMaZuQ1tyEi5JY6i/zae6Z366Xp5m9pRNekdFl4q7xHZKUPWCM4WkXhC2B3
	uuyumONwR4wqmDU9KIj317LdYBtLLIrVYs1gvIUL5LrZ4vhPCQwNcjGc2rlNy9KRhqa6qT
	smWvwI4QlXPCAtdHskAZzPhHwcg12Ds=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VIThfSyI;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784519725;
	b=TviVJVyJiQ6lvtKsiggJihnNRHZDOcxK/zis5epe+pExd0hFsEI9x4e0QirtBMP9yhEHr+
	wPm8uZ3OscsgboPIDukFGkwB8QA7u3YauAUtWmaA3MNxZGu/S6LxUuBiNUkYuEZvtzQfHr
	lqAqR/yTqhh85zr+AIkH6Oa4tgrUCS8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=am+19/5kAwq2nurOsVBVrTqc8AGbedae4TuQBKH9vBE=;
	b=VIThfSyIuCRFCFF1v8dCBMlufnInFQsyK07b6P4yTI6Kf3KVmhmgNQwsTP9gDhNCkdgyAteKy
	0wBjZ1xlSovsYSIJjCIHvVcfg81veu5xGCnWB/FcZbQwabsUr0VWp3pXn01GolPk7uBD9xHMqyk
	As8O/JD0WSEGN7VJhcK4h9E=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h3RHs2r44z12LDF;
	Mon, 20 Jul 2026 11:45:45 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A08940575;
	Mon, 20 Jul 2026 11:55:20 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Jul
 2026 11:55:19 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 1/3] fs: stable_page_flags(): use BIT_ULL() for KPF flags
Date: Mon, 20 Jul 2026 11:30:19 +0800
Message-ID: <20260720033021.4091944-2-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720033021.4091944-1-tujinjiang@huawei.com>
References: <20260720033021.4091944-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 828D540006
X-Stat-Signature: m35jcwud8eaogtfehe8diacqbori7jnr
X-HE-Tag: 1784519724-688862
X-HE-Meta: U2FsdGVkX1+MAh867K8+7G9zGJczf9x/aUiuvS0KVHHnM9iBUNrNwPi/xCalAH6YF3JTcDEeWNm9dlHC9iPYtUxjHsPGbTGsmOhXqa1L2yKGzF1rgKhGHgb89i72QEFyCkbV+9w8CXqKDzbRC2x2iM8lzz6v3a9K0cPTKYByJHxVhxD0ONJoNDJtDe1yiDv5WJXUlYoNbmiBfbuBAPUE2QFav2v3u1GhR8kTJpRoGbiFs7+pp9hAKbQ0xkYdtKGBCkb5xTIOtNJTgOXOIDXU5jg/+uUXNF2lg176xM/Un7JqCktkPUXmcCHr+e9nsVD7RDUWrYeLXLcOYZcDUWQTC+gxQx9S+7Im9/zUDgyUsQJTLyn1vw4a5LyHcEszaYxXslIezUcDPQuzzNQt4zOJoXmBYDJdCrt/wSxBny7ThC7yBspznK+BUZLLF2Q5YYF0DYNEoBQynqITEb6OIf+f6OZNdHzBNGLzgY6SUoM93BrIfT/PMkDRBDDenSa8TL9tGInL1wzLEnVqn5jYe6+A8NhmSq0Qu/AP8LMS4LCDFZHMabvVGt/M5woPzLQOzg7E6cOWoF+fzsHwkUHgDBqdzgNynCbz8i7YyXiI+os8dUVMzLjzFNhSDsG7HT0BEOYnXB8jnafNpJkh3xzaL/2mrJcLXhbcMpqIqV/zui6JzDGF+EOtEyJjOEg3IwdSWpCv9wgbNsSKnJS782A+SFnTJiVilL+lhXfYtrMXlasTzkOSP9U0DGCmCNvblMBIuRdMExHoi8iLNY1RJeTov+2k+GOIbScVXWtp4P4cKCHm4BM4cqhbnBV5KtA3zGjLRoYhdz3AclIZAvLdSB2YmP2fsmtFW9Gf09jGGAkxcvv1dvJAuxssylAqe7GlPenTByqDstEz8YEzm6+P6zOPzuMBbmlmheLu79fIs/kzLgaU6lzpzVF7Q7y2ynj17lEA1SZt9PmMqXhuUOfvwotiv3n
 zZpKRJA+
 /L3I3fIrL2qlsai0KPASjkvBE/4Srk+W53ttvCFDAQJSySWXmtx/R9g74NQq4xW4eaR/FG6z15iKPYaRWN9JGwZim8Ham6yOn+JbEEKvvMXDhyzYGE3IaKWZBQVpHYKHy5meI5iroVBRqr3Ssma5YbvMtlmsPh+sci2b+gjQMtCIvQVedK8shmuFwOqvrisIn+0k5YPi5d9tEhPeyEpnec8bNgZAjSWZAR2k5tx38q4cOU9RBqWQ99yEkpQUK/zHzgG/mWqfNmQeF/pn3u+H3NOdDN5tBcVLSjOPHngtsytB8Fj3142K904y231mDpB3/3zUaRlZJva65rlu2uzVSDQaJsy8i4HYYj7lzduVaGSATQaEqcrvGVeuDWN+UuZ07KJry
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stable_page_flags() function currently sets page flag bits using
"1 << KPF_xxx" for various KPF_* definitions. KPF_* may be larger than 32,
which will trigger -Wshift-count-overflow warning. All KPF_* values
currently used in "1 << KPF_xxx" are smaller than 33, so no warning is
triggered with current code.

Replace all occurrences of "1 << KPF_*" with the BIT_ULL() macro to
ensure all shifts are performed on a 64-bit unsigned type. This makes
the code robust, and safe for future extension.

No functional change is intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/proc/page.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 7d9387143435..ee39b321f1c6 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -157,7 +157,7 @@ u64 stable_page_flags(const struct page *page)
 	 * it differentiates a memory hole from a page with no flags
 	 */
 	if (!page)
-		return 1 << KPF_NOPAGE;
+		return BIT_ULL(KPF_NOPAGE);
 
 	snapshot_page(&ps, page);
 	folio = &ps.folio_snapshot;
@@ -170,11 +170,11 @@ u64 stable_page_flags(const struct page *page)
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 */
 	if (folio_mapped(folio))
-		u |= 1 << KPF_MMAP;
+		u |= BIT_ULL(KPF_MMAP);
 	if (is_anon) {
-		u |= 1 << KPF_ANON;
+		u |= BIT_ULL(KPF_ANON);
 		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
-			u |= 1 << KPF_KSM;
+			u |= BIT_ULL(KPF_KSM);
 	}
 
 	/*
@@ -184,35 +184,35 @@ u64 stable_page_flags(const struct page *page)
 	if (ps.idx == 0)
 		u |= kpf_copy_bit(k, KPF_COMPOUND_HEAD, PG_head);
 	else
-		u |= 1 << KPF_COMPOUND_TAIL;
+		u |= BIT_ULL(KPF_COMPOUND_TAIL);
 	if (folio_test_hugetlb(folio))
-		u |= 1 << KPF_HUGE;
+		u |= BIT_ULL(KPF_HUGE);
 	else if (folio_test_large(folio) &&
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
-		u |= 1 << KPF_THP;
+		u |= BIT_ULL(KPF_THP);
 	} else if (is_huge_zero_pfn(ps.pfn)) {
-		u |= 1 << KPF_ZERO_PAGE;
-		u |= 1 << KPF_THP;
+		u |= BIT_ULL(KPF_ZERO_PAGE);
+		u |= BIT_ULL(KPF_THP);
 	} else if (is_zero_pfn(ps.pfn)) {
-		u |= 1 << KPF_ZERO_PAGE;
+		u |= BIT_ULL(KPF_ZERO_PAGE);
 	}
 
 	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
-		u |= 1 << KPF_BUDDY;
+		u |= BIT_ULL(KPF_BUDDY);
 
 	if (folio_test_offline(folio))
-		u |= 1 << KPF_OFFLINE;
+		u |= BIT_ULL(KPF_OFFLINE);
 	if (folio_test_pgtable(folio))
-		u |= 1 << KPF_PGTABLE;
+		u |= BIT_ULL(KPF_PGTABLE);
 	if (folio_test_slab(folio))
-		u |= 1 << KPF_SLAB;
+		u |= BIT_ULL(KPF_SLAB);
 
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
 #else
 	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
-		u |= 1 << KPF_IDLE;
+		u |= BIT_ULL(KPF_IDLE);
 #endif
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
@@ -227,14 +227,14 @@ u64 stable_page_flags(const struct page *page)
 
 #define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
 	if ((k & SWAPCACHE) == SWAPCACHE)
-		u |= 1 << KPF_SWAPCACHE;
+		u |= BIT_ULL(KPF_SWAPCACHE);
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
 #ifdef CONFIG_MEMORY_FAILURE
-	if (u & (1 << KPF_HUGE))
+	if (u & BIT_ULL(KPF_HUGE))
 		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
 	else
 		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
-- 
2.43.0


