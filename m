Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4FEC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 08:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BFF6B008C; Sat, 12 Sep 2026 04:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C316B0092; Sat, 12 Sep 2026 04:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B6E6B0093; Sat, 12 Sep 2026 04:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C92E6B008C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:25:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63D04C016C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:49 +0000 (UTC)
X-FDA: 85204426818.25.68B2C5D
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84DD6180007
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mZ8qcMQ0;
	spf=pass (imf06.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789201547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYYZoGWdlGWHi1GqFofODMAvVspXQpVNRnI7u63JZdA=;
	b=aVpyTCQTtFTjySGnisTEXKHdNqk4dBD77Dl/8loAQhGaCkAhWXrxrFfIQV11zIhDQbFfbe
	SnzLNelpdWiYPg8l6vEJQCMwu1zQzpvWQOfEdYgSlgRrdCjlrtMinPuNAJ2RUcK4MpIHMd
	TdmTsMojzZLFzDz+haUxeTdYRe9ZJ5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789201547;
	b=BD08kMnaBdCZMQpnYRt+98T0Eo2xYcI3eJO8TNiG2zHz2SvNmuOAel58YetdKjyPxs5W0U
	CRSyl7iV72sr68MqmZOzvvKv3e1PYleW//xl3sCkD66/2v4pYY6x3i/TV2cVxaKBe87kFo
	T1mQ9gGdnDndFTlIuxd/PymX6+/dLNI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mZ8qcMQ0;
	spf=pass (imf06.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=fY
	YZoGWdlGWHi1GqFofODMAvVspXQpVNRnI7u63JZdA=; b=mZ8qcMQ0jNua/wD0a2
	R5+bUyUTNUp77BIOXdh3ftCnuPvuOYstV0lvDqiAuvWUINtT/j36FGVtXK12uPq2
	UvG0+ZU3l4GcQw4Lh1f0Df5nwZlcZ5GTlQ2UjjO7CQlIP2P3yAf6M//MA9O7SEZj
	GTD8sG8BhEqw6XsepLNtEcMVQ=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnr7FODKVqmfMoSQ--.44660S4;
	Sat, 12 Sep 2026 16:24:49 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	borntraeger@linux.ibm.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	harry@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nico.pache@linux.dev,
	peterz@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH RFC 2/3] mm/ksm: use the VMA lock when looking up mergeable pages
Date: Sat, 12 Sep 2026 16:24:06 +0800
Message-ID: <20260912082407.75875-3-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912082407.75875-1-xialonglong2025@163.com>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
 <20260912082407.75875-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnr7FODKVqmfMoSQ--.44660S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxArW8Gr4kWr4xZFWUCw4kZwb_yoWrGw48pF
	WfKas8KrWakr43u34fAr4qyr4Ygwn2gayUAFy3Ja1avw1rtF43GayfJa48JFy5GrWxG3Zx
	Ar4jyFn3Canrt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j92-nUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xEbFGqlDFGSgwAA3q
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zdef9bqpcmkuts1fquqo9ssic594nbya
X-Rspamd-Queue-Id: 84DD6180007
X-HE-Tag: 1789201546-507016
X-HE-Meta: U2FsdGVkX19S3fT8fV20XhX+4tQj+2DkplvAFBD28oBlMKXPmfSYbnzHl8uO5+nRGT0u3SdFGpdn2YBPO4Lo+6gpx/fFKDG0KbYFIeTC6f3YBC9iux0IIkaFaFUoLultD7lSN2QBZQDYDYAo91/lP2tgp5YAnzE0eElnAFOnysTiQekW/tFP11ebLWf5FgNrNhNGQ7gbHHGccHCDmXtMdaW/c3yaT1bG6VIGHqRefOp6WsXH/WqqzT30eOOJhuK+9/GdVDl2wSdbEcXar8blVfiTGMt+rJfJEp89OhRDSaQEVtBZBZc3+pv88NgBOl/PcEBa/Y53r9VmOhG8kQTXEtZ2WT/c2asjLp3Rmz9TaQgLIV22/Xb+9Dx3+bG0EcMTc9jidwJ30NsF5BBAWbqAbYSC/H3KfRR1AvvnvFzLPBpMLHkJRWNIfP2gCiVhTDfsfC+wNl7Shz0NurIlJK/Byxs4Mb8v80S1LxjalOwIFCHfThaVxPfVjIvoBl3VrgGPJNAjQ2lsiQELM8troRlO9BYPWOWYB9ZQaEmbLfKqQce1N6hFp2V8KkrkO3WzvehAT6ANjksxbGY67oKTSR/ww3Ag4imihHANY3gzfrrfmrBHYIcS8IOnwAp/xhpHV1lD7ST9AKylg3RyM+S6Pm1HtXS2NG7HB/VlHGF5aXjwoBkXdBKsbLJ7UtfMGyvlF1jMLgGAU22pZEb65CdFL9dnvmMfWPhAxmjRWCJmIjTmNQO2j9xhosiMexGqGbyP9v5Xv2bHcVzNEx2N70i/H9Tt7lahmC8yYisrfMms1lZ6MYdjGxpgKIdt3RnyXL5yYdNtkKhDxj/WFOshMNeC+A3T1NIakM08sJzgvr6kl8tpTlbnysKaJbV4hp/xWhypnOjFo8wdp9Ugkr0JLk0RcaLcDCeE+LM2QBbAqujInu3Mge8dXLCoMZPfeU/FAbRQnMuZmJ49zjfE+TYCu5CZ7B+
 oesNBSI4
 U1ueN3if5foUXIKQka+JWlth4Wl58K5nx3fN40aHTgvXpUdmsoK7FIAcJfueReCSPMhbs7U1Hzn4C+x+EhD1F9kkjUjE37HNrWRNihXsrGC40yOzuYf5pIVZtVJaeLsFLfOoNyHgKkfw8w+xqwOwc1i22vc+uVALSEvX3Zghsqf5qTXnvacxJEehR2+mat7IzDFKL0IS6Ec07elE3EhR8O377SXgiwRmlzicwHPqRp2+7pQS8yV6OHp+ykw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

get_mergeable_page() currently takes mm->mmap_lock for every unstable-tree
lookup, so KSM is serialized with layout changes to unrelated VMAs. Try
lock_vma_under_rcu() while holding an mm_users reference and walk the page
tables under that VMA's read lock. Retain the mmap read-lock path as a
fallback when the VMA cannot be locked or per-VMA locking is disabled.

Extend folio_walk_start() to verify a VMA read lock and keep the mm_users
reference across the walk, since a VMA lock alone does not prevent
exit_mmap() from freeing page tables. Drop the reference before waiting for
mmap_lock on the fallback path so an exiting mm is not delayed.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 64 +++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..aee1a1b49b1b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -811,21 +811,20 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	mmap_read_unlock(mm);
 }
 
-static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
+/*
+ * Get the page that @addr maps in @vma, with an elevated reference, or NULL
+ * when the address no longer maps an anon page.  The caller must hold a lock
+ * that stabilizes @vma: either the mmap read lock, or the vma read lock
+ * together with an mm_users reference.
+ */
+static struct page *__get_mergeable_page(struct vm_area_struct *vma,
+					 unsigned long addr, folio_walk_flags_t flags)
 {
-	struct mm_struct *mm = rmap_item->mm;
-	unsigned long addr = rmap_item->address;
-	struct vm_area_struct *vma;
-	struct page *page = NULL;
 	struct folio_walk fw;
+	struct page *page = NULL;
 	struct folio *folio;
 
-	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, addr);
-	if (!vma)
-		goto out;
-
-	folio = folio_walk_start(&fw, vma, addr, 0);
+	folio = folio_walk_start(&fw, vma, addr, flags);
 	if (folio) {
 		if (!folio_is_zone_device(folio) &&
 		    folio_test_anon(folio)) {
@@ -834,11 +833,52 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 		}
 		folio_walk_end(&fw, vma);
 	}
-out:
 	if (page) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	}
+	return page;
+}
+
+static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
+{
+	struct mm_struct *mm = rmap_item->mm;
+	unsigned long addr = rmap_item->address;
+	struct vm_area_struct *vma;
+	struct page *page = NULL;
+
+	/*
+	 * Try the vma lock before the mmap lock, so that ksmd does not queue
+	 * behind a writer that changes the address space layout anywhere in
+	 * this mm: the vma lock only contends with modification of this very
+	 * vma.  Pin mm_users for the walk: exit_mmap() frees the page tables
+	 * under the mmap lock alone, so a vma read lock cannot keep it away,
+	 * but an mm_users reference can; the pin also stands in for the
+	 * ksm_test_exit() check of find_mergeable_vma() on this path.  Drop
+	 * it again before waiting for the mmap lock below, so that an exiting
+	 * mm is not delayed by us.
+	 */
+	if (IS_ENABLED(CONFIG_PER_VMA_LOCK) && mmget_not_zero(mm)) {
+		vma = lock_vma_under_rcu(mm, addr);
+		if (vma) {
+			if ((vma->vm_flags & VM_MERGEABLE) && vma->anon_vma)
+				page = __get_mergeable_page(vma, addr, FW_VMA_LOCKED);
+			vma_end_read(vma);
+			mmput_async(mm);
+			return page;
+		}
+		mmput_async(mm);
+	}
+
+	/*
+	 * The vma is being modified, or CONFIG_PER_VMA_LOCK is off: take the
+	 * mmap read lock as before.  We are prepared to wait rather than skip
+	 * this page, so a contended mm only slows down its own merging.
+	 */
+	mmap_read_lock(mm);
+	vma = find_mergeable_vma(mm, addr);
+	if (vma)
+		page = __get_mergeable_page(vma, addr, 0);
 	mmap_read_unlock(mm);
 	return page;
 }
-- 
2.43.0


