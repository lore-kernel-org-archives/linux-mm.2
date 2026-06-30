Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585B3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136AE6B011B; Tue, 30 Jun 2026 08:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E2E6B011C; Tue, 30 Jun 2026 08:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E516B011E; Tue, 30 Jun 2026 08:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B63FD6B011B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:46:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E8031C6F3D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:53 +0000 (UTC)
X-FDA: 84936553506.17.FEBF293
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 204B118000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hyOt5eZb;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823611;
	b=n+hp1y0SWJ0BJVfIn7v7LN/JWXPWF65TBo34YvjVGfUgeaW1QSSCH7fhRbN2JuJfJ4CAaW
	UYZ3clGMN6+O+5H6MefGUUpUvAi+dwHunJtsn7YjV8Ile3pJWlr0gBs4qWGX/F+fdY/yO2
	mHmkKb/W/OWTSzKx7b0GoAeLIIFY90I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=weDADfQQC9XKEy/7w/rj1X2ztgRTHSRo5MmtKT2/6dE=;
	b=3J4PlxJBGaaTHhYuPaTFg1Y0H7YDPtmA8HYO1CsU+qGEmv2GVwBt67esf+LJ++bWeGecEe
	Bav113RsMPowgFktIy+2xf+eC5oTtpEdEm4R6vDklPGd1Lfc4H1yo6OzqX+OqI73WC83jD
	iubGYc9kBWB9VSsSfGoY7bLE6iet/Hc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hyOt5eZb;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=weDADfQQC9XKEy/7w/rj1X2ztgRTHSRo5MmtKT2/6dE=; b=hyOt5eZbgEfmMIBv4QBhk37fEy
	GSvM6THyIFD3emJUSrZo2SI9w8lL4W3F4b8YQlMsycDv3LxrUxj9XvICbP3jTcs+VFzqQfk/13GZk
	kz7kHlClGocCPwhck9VjGDSE+24JfBCuup4MyZf6zsMgOqaczTLq9o8DtdX/u+kVhD9w3kfuNBYWQ
	fQEtCF5tj3sotCtiK5v5XPBYxQEZr6N62LlNllPkzCSbeQyZbtuSj27lSsEqVaj/9KgkdAyVmlDrp
	exyyepkKS69j0m6ZyBLE5SXrU2IShdTWKKabgPbF/xkOwPShPdTBTjfDZT8qQroB0xq4WsTnCnX3o
	DYXM3+4A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weXrM-0074bM-05;
	Tue, 30 Jun 2026 12:46:40 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 30 Jun 2026 05:46:05 -0700
Subject: [PATCH v10 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ecc_panic-v10-2-c6ed5b62eea2@debian.org>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
In-Reply-To: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6620; i=leitao@debian.org;
 h=from:subject:message-id; bh=GaED5srKVuxGk+sMRMSMg1mKfXoDXSHlZoLJEzW0g88=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqQ7qdfmSnk9V7vowWxhJ+2fhb0qD7NDDDv6ax9
 MMzj0i3J2yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakO6nQAKCRA1o5Of/Hh3
 baJhEACl3tXB/iBMjKZtuVvGXVxWjHMNEWUmKCgrKF+pBvwAg1xCR+nzPvdu+/ZInPcBmilU5Va
 ROBWT8FOz1KIDZ6r7dc272rZvS9huGCfl8NKrloKwjC2T6Wgxv+7hwRAxyR+yFTj3KSW/Xt+D9J
 NyGBsaxV1CpzAyIl7OQc1AmKt3KEhZOrLmmY4BgoKhxlW1WfpuRzh2JGvOs6KDlAPv6BlDK4gnS
 lF7vtkhmywymREDm+qqzSmYsTk4JK6ExpzaTVQffbD++N2q4ygSftdrjkx2OLCLIpcdu5MPQoC+
 TPUakIDu+8aRzCS7q/dqCbKYEd1nyfsqRohcljfA7kKSje7bEGZ9dOlixaVlvWx0wtUZdMfbM6Y
 AakspsuRDdncccB6c3DqJYrti0MKU2rEJsmV8dZ1F5xwca+Exfn0k3pkDDkrKhDwqrGUVvipwmv
 SmAFWhBRYh7VKrtjjOsVYP4uGDTg73fpNVsFgdAyI53cy0vw4cyNewsiAZYne3DHOtEus5ncdvt
 01PhC8Nb+ROU3oi/KkSBDJAZ2PsT9h5erMazpQipoQ6Jhhwf5uVhb/N7bdUCBC6iwff39Ji6mTj
 doSISstgh/z1IlNmZ0L9P6Dsom/Vr+6jSDgjBVKY1+zQxnG93Z5kBBVVmJ4Dni1OgmDRUlxNtyj
 E8LYRE64ZDx/Fkw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 204B118000C
X-Rspam-User: 
X-Stat-Signature: dcdbnf8pm3h7cyrojd6wdoiad8k8ei5h
X-HE-Tag: 1782823610-134654
X-HE-Meta: U2FsdGVkX1+zE1cmHSSmpZPFEx8it7lNVmYFPEG6m/AUSjhp4VWtw1OeTvVh5PR8ke75rgxXlf6cecTurxG7dGzg028ZbbuMqm7R7BWDTZNluRLNOoYPB/csxqVYQGNJLSoe/NYlGJiuKYlWNBH1fJk/fAkmI6xdyG9d6DE7V/k+BETJIAffZP8OUQY1hQgyb2x6IECoPc38uLj+8D2s8b5vg4PUvKZ5mAerPgAskmF6GUiJTyQIosP2pdJ9rBjLkgJ2raOU1aLVNobd+PsT+QwfoemPYbtnCD26b2WhjqYu0Z/NQ2q28gLfJw8iAFIhPOSXF7w5FDnsjlSU1MQawcna2/fwrvpcSy/dfwjyIMWfDtpAwRItjk92GZdW5P5S9jY5bmpqKoEynKvkDtX/G96YHzCVwSdDvsjoB9HQj/eXLjuhpS11qlQYrK/HbRTPRUcBVZpwOnz1D/FB8WBcBV06N6n71o2EGxYvG2QZGRwdJxJPbh8FAJK3Q5pcTakwVPQm25p69wmtcLntY/98b8xHBRt1JljNH1ken/f3p9tb1w9p4se8i4X0tc3Qm39CaloNejWeFxZDqjTwHmdlojnKAtwwZ5mUiLY04aZYcKGGrwZhjrXw8m55qInk6CsySa26C0YgCOLdctU9nEsiPkrUWlz32MwxcbYjFBDXGBKgM6ZOqRHMhdVDbZvmis87HUFAicI0Fx4xpuvxpX9aO5YDFRGgvSL4kSQs3IAmpVPCGuZkbWbRu39cb1LT3L508u5Y3ajlO7kBQyFnboaO7cWNqUJiuq4SxqrV/flrUU+hsnTnh2rCL/6fzq7QV/yIRE+uOTTRYVQF8pdwlLegoBdxFTw5cGiBmjC9nY3v6kGVF3zXg98l93VRJbhuOH06AqAMHBiksNKfMdQTC1qtdFYlum86EFjW7YBoRbKDcvnBn21AlVh6gE+2dmDr6B7m1NzxGCX7y9xqmDCYzfn
 Ws6G6HRA
 wlxMfqrYILdDO3GF7/BezwJEKAE0gyef7buNBeDtkiCzaKKRhYOcP6n7M3ZnOwgnYYOoxspekkpmVhdxY4HjjBkFDSSEdhLnp2odxM8cu7a2Sz/L+FFdrjVSyngfvEuZju9fe0CSGRIp8Jgbf+/sXp7+CaEKzJ9SolaZO5cw71o9lsFw/rN/jK69URl7uBzTHxqGW8GUtkLzmdXILFistB+QXdBOKMqHQAjcPGgVFdtCcdN/ubUTemUD3eUAYKd4dCevbXLh1i9MQxJCZ+Dh+6lClnDwVzypxTWSm8CgT0SmSlDpngLT7p14xHN8PIKGgDYpAJRORDPc8VoiXUxHduP20QJmryBMKCfJUUPCDzclseypqTIWoDio26oChPBQmZ1l/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_any_page() collapses every HWPoisonHandlable() rejection into a
single -EIO via the __get_hwpoison_page() -> -EBUSY -> shake_page()
-> retry path.  That is correct for the transient case (a userspace
folio briefly off LRU during migration or compaction, which a later
shake can drag back), but wrong for stable kernel-owned pages: slab,
page-table, large-kmalloc and PG_reserved pages will never become
HWPoisonHandlable(), so the retry loop is wasted work and the final
-EIO loses the "this is structurally unrecoverable" information.
memory_failure() then maps -EIO into MF_MSG_GET_HWPOISON, which the
panic-on-unrecoverable sysctl deliberately does not act on.

Introduce is_kernel_owned_page(), a small predicate that positively
identifies pages the hwpoison handler cannot recover from:

  is_kernel_owned_page(p) :=
      PageReserved(p) ||
      PageSlab(head) || PageTable(head) || PageLargeKmalloc(head)

  where head = compound_head(p).

PG_reserved is a per-page flag (PF_NO_COMPOUND) and is tested on the
page directly.  The slab, page-table and large-kmalloc page-type bits
are only stored on the head page, so those tests resolve the compound
head first, then re-read compound_head(page) afterwards: a concurrent
split or compound free that moves head invalidates the just-read flags
and the loop retries.  The lookup still takes no refcount, mirroring
the rest of get_any_page(); the recheck closes the common split race,
and a residual free->alloc->free in the same window can only mis-tag
a genuinely poisoned page, never reclassify a handlable one.

No MF_SOFT_OFFLINE / page_has_movable_ops() opt-out is needed: a
movable_ops page is always PageOffline or PageZsmalloc, whose
page_type is mutually exclusive with slab, page-table and
large-kmalloc, and it never carries PG_reserved, so it can never
match any of the checks above.

The list is intentionally not exhaustive.  vmalloc and kernel-stack
pages, for example, do not carry a page_type bit and would need a
different oracle; they keep going through the existing retry path
unchanged.  This is the smallest set we can identify with certainty
by page type.

Wire the helper into the top of get_any_page() to short-circuit
those pages before the retry loop runs.  On a hit, drop the caller's
MF_COUNT_INCREASED reference (if any) and return -ENOTRECOVERABLE
straight away.  Pages outside the helper's positive list still take
the existing retry path and return -EIO, leaving operator-visible
behaviour for those cases unchanged.

Extend the unhandlable-page pr_err() to fire for either errno and
update the get_hwpoison_page() kerneldoc to document the new return.

memory_failure() still folds every negative return into
MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
this patch on its own only changes the errno that soft_offline_page()
can propagate to its callers.  A follow-up wires -ENOTRECOVERABLE
through memory_failure() and reports MF_MSG_KERNEL for the
unrecoverable cases, which is what the
panic_on_unrecoverable_memory_failure sysctl observes.

Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f4d3e6e20e13f..087658484e242 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1325,6 +1325,38 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
 	return PageLRU(page) || is_free_buddy_page(page);
 }
 
+/*
+ * Positive identification of pages the hwpoison handler cannot recover:
+ * pages owned by kernel internals with no userspace mapping to unmap, no
+ * file mapping to invalidate, and no migration target.
+ */
+static inline bool is_kernel_owned_page(struct page *page)
+{
+	struct page *head;
+	bool kernel_owned;
+
+	/* PG_reserved is a per-page flag, never set on a compound page. */
+	if (PageReserved(page))
+		return true;
+
+	/*
+	 * Page-type bits live only on the head page, so resolve any tail
+	 * first.  The check takes no refcount; recheck the head afterwards
+	 * so a concurrent split or compound free cannot leave us trusting
+	 * a stale view.  A residual free->alloc->free cannot be closed here
+	 * (frozen slab and large-kmalloc pages cannot be pinned), but is
+	 * harmless: where a wrong verdict could panic, memory_failure() has
+	 * already set PageHWPoison, which bars the page from the allocator.
+	 */
+retry:
+	head = compound_head(page);
+	kernel_owned = PageSlab(head) || PageTable(head) ||
+		       PageLargeKmalloc(head);
+	if (head != compound_head(page))
+		goto retry;
+	return kernel_owned;
+}
+
 static int __get_hwpoison_page(struct page *page, unsigned long flags)
 {
 	struct folio *folio = page_folio(page);
@@ -1371,6 +1403,19 @@ static int get_any_page(struct page *p, unsigned long flags)
 	if (flags & MF_COUNT_INCREASED)
 		count_increased = true;
 
+	/*
+	 * Page types we know are kernel-owned and cannot be recovered.
+	 * Short-circuit before the shake_page() / retry loop, which
+	 * cannot turn any of these into something HWPoisonHandlable().
+	 * Drop the caller's reference if MF_COUNT_INCREASED took one.
+	 */
+	if (is_kernel_owned_page(p)) {
+		if (count_increased)
+			put_page(p);
+		ret = -ENOTRECOVERABLE;
+		goto out;
+	}
+
 try_again:
 	if (!count_increased) {
 		ret = __get_hwpoison_page(p, flags);
@@ -1418,7 +1463,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 		ret = -EIO;
 	}
 out:
-	if (ret == -EIO)
+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
@@ -1475,7 +1520,10 @@ static int __get_unpoison_page(struct page *page)
  *         -EIO for pages on which we can not handle memory errors,
  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
  *         operations like allocation and free,
- *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
+ *         -ENOTRECOVERABLE for kernel-owned pages identified by
+ *         is_kernel_owned_page() (PG_reserved, slab,
+ *         page-table, large-kmalloc) that the handler cannot recover.
  */
 static int get_hwpoison_page(struct page *p, unsigned long flags)
 {

-- 
2.53.0-Meta


