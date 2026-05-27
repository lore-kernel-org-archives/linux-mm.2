Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209ABCD6E41
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82ADE6B00DE; Wed, 27 May 2026 10:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC2C6B00E1; Wed, 27 May 2026 10:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6F16B00DE; Wed, 27 May 2026 10:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0B96B00DE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:06:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2327E1405C1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:45 +0000 (UTC)
X-FDA: 84813375570.11.8FA9583
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4EB3380005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VfUbJUAU;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhENfLdutSDbGe4T/p6ITcwdZ6ZMuTAeedUQ6PdP1Fk=;
	b=5oW8PV/lhedbIYF58KyebqGueVRNt0ul6ubTXamR9TYtO99yhyM9xGffIl4+a2QfVGPVHZ
	9a12MVeHxQIGg+XsobydLSH5/RwUVeBWCQHO3tXjKYfJNHTDEHInxr5hyT99KREgvAngGj
	rT7JcJG+g+gTkLsf2R/LRoHKO+q1+lQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VfUbJUAU;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890803; a=rsa-sha256;
	cv=none;
	b=3ZfhK4mTLKpwF27tEQhKahmjUS7L3gKj97gc5jLrxMHQrgGPKjUp94CLbr5GisIB972QxF
	zTi4FsdG2r1puGr13ILd6cmqdCGqd3mABBXdWQeLJ03WAfRLQtF5ccEEKJl7+JGOcgzQUY
	gbDwje/sagzu+orkRYWU1DlTfVvl5Ac=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=FhENfLdutSDbGe4T/p6ITcwdZ6ZMuTAeedUQ6PdP1Fk=; b=VfUbJUAU1vNX3D9FZHTX+CUAL6
	6Gs5BxlBwCam7V833cbRWhz1idOQNJVdj1eCnKCmpPnZaXA/JKyFfhR2GjvDOIeokjn0acL2Ance/
	cZnpDtOhf4vtQcrpeGKiuKfPb4h1QphQB5HLd9IYr1dcfa4DeRjdW9jqgU7mkF4oIdtdpJohfyKDx
	p2xINNw1Izfmx3oQsikG4EqKbRT5s4l1P8wj0OYhf9vXdi0l75/RMzDLzA3CoOFHoIdLB4nA43Pnf
	nfQu3L0ZrfkhshKYyeg78tih/dpnS+yTLHfbNXh0/Tp6zYeE11+YUoN8+O8I+fY1Xfzc/TRuh6STl
	nU+pY2sw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wSEu5-003DSg-0e;
	Wed, 27 May 2026 14:06:37 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 27 May 2026 07:06:15 -0700
Subject: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel pages
 as -ENOTRECOVERABLE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
In-Reply-To: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=5797; i=leitao@debian.org;
 h=from:subject:message-id; bh=CMxDEuc+EJZDUlHOyEkCjFppFFHvyvtO25COFqS0Qrc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqFvpbS4dSsLryGRWX+9CPYnqcxRRV/9Yht/L7s
 XGc2EpThbyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCahb6WwAKCRA1o5Of/Hh3
 bRUnEACk+lYX1maBV4qTr6tMuEu0Y5FijjQMZPHRDPTnPfxlEPM5BDjnUvbeFpeQbM+FYBoxYMA
 u13ESUcZdgyrIzikvUHVTt/jXadVLZ5J87zSkZ/vecu3C9dUZ3OcI2zjiGT+JVhjeD+imcWWHZu
 WawfRRCqu3CBxWMReAXteQxdpSqyJyjddeFXdylp/e+r5LpSBPBhTeG85xRL6YR10tAD+8EM/xk
 j99eNf0iPQiIFgL20/Q3haF0lN8TKiDRYfXzBSluPIfbslCkPS1TzgMLxRsT3mLCAjNAXAchBGL
 8WctMsHX3iuL6XHl6/+9Zr3AGhBeym3aRUxNYdZLw7XJ8uTVqxox+r7e4mqDjrB5WpNtptFs1xb
 g6SgvNbfRGYboUY1caUvG/fZYOOqkMIePIOWfrT5klstFnvjsgjiDX7Mdnd3lyYJhz/rKiODBFz
 5USCGHDvGFnIEru3Cu0Y7Hx+OtXhLA/MlK5bG4C4Ba9k81g+dA0sHQ3i8kL674NqAxsDegOuXaG
 2TEHjVRkONmgCiG0/6y/9I4NAk234e7xEOSZTm8B30eWuDtvOgC6amSJxcmPeaWkzyycP0Mo2dO
 GN11/W9K/aWqGqGPC6r5tmZdvjWw3uwBgVMMGNZSfauWqIZTjf18YMJq0WBGZXJUjEkuSXFWLCb
 JM6gHyue4CMgtqA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4EB3380005
X-Stat-Signature: zp3qp4oo1qzu55am41i81x7iddxycxxs
X-HE-Tag: 1779890803-641746
X-HE-Meta: U2FsdGVkX1/z5KMcwYDRY7+5X/GOhuSYcZJMAA5vpxb477kSu+TaQTXfeMMCpCxT2IpeHyWN0LCzRjcuZU8NQuyEp4n1Y6M4r6D5fE0zNNscYPra1r9WINyAJ7VjB4CvLc97l8ZOrAtmApWLho00b9sP8fcLyhL4i+dLZO7UUK4ofg7IT7hhyuMTrjfewb6YCayxXQby4qA6kQkXlItxFsm97KAa0vom400hFI+Yox++qdWAXKt853L0wWCJ4VFF2DZCS9s1cKXk3eUxGLxuCCg8FQIaWRneFzt3ZdqW5Hz8fCp+URMk9knnOB0NGGiAAb2HiYWEpVuXuzP9zbMAIS1pejenO9AaV6M72XG7W9smClYdqxpcIj1eCyfTV/gtrUAnNQK6tKTKWtUtPQTTjp7fVZeZi9/fEtHFRlAAKPBkUgWbbHbKIVd+hSUt4u5ARVDMNbMlH4qPv4O/VwI3wS4G0Vd50m/G8yoUsKl/1UnS6y0gbz2vVGcUF/EXYB0EbPFSiy4YK38b68hC3Vde2QkjmlIhdBUuavZY2xrNGx1JH6fxHvQCAF2eBNmOJgVF/gYV2dERkC9JjJ1ucjxU4Chg02Pte8txmXIjsataeo7tv1utyfiWHoP2sl+SbpBYG2zFG9nv6BE/pOeNFCVDalwL0PWintN0eLSUOrqlyY61cWg6RCU7TNuJd7vDhhnN/7Y5B9Z5gL0bNekCMws45fsMNNZeKNumUh2675kTeWtdrmnnkSBDML3jkdgQ4nrxc/Z3hwLS6p5Zxuk4Z1az/6hDUIPQy86FP6farKH9u3wjyH6g6NHWGo+HuxBEWiqd252LiRYKDDdIsOsO/pveZpoyf0OjqUL+EFExTV5AoRlW+9gZHwg7pRakUcVl/VjB7ea1M4/tFTy7/dGvOaAPoki16ionWGZy5he68OnMTl3FVaZV4OVOKF2u4bjiMluq+QqNEDViHbl9biA1hgN
 wpZJ2i1J
 IljPnZKqlCrb4NdpCt+MUuih2of1hTstNcKyQKRUGYuhDuJWbEiw8H3GdCLx594xX3o4YB1+lc5HJmwWGcvnNVKJELBxlyHSyQoC+1EeQIwmsoXcOzN6I7wDVSbvRGvc7iYjde4WTGoXyJjuUL1Wgh5eFDoGv6zXLPDMX/9zNDSi/QaAVUMpK7I+4okGjKLoYYSViTotamImSIPi2p9Ymfw/Xg59qHFKzHx0AWe/CouLFXOYWIQ9zfxn1tSeyILyBwQ26pzhyF3Z1J0PS0x7rE9MeNNzr5m7a5EEjJ/1mwP0DpFTjkZNVaOZCwgpnLHR2jGl5FUw7i11jSFq5Fx3c7TiUqFxn/+WmkLHeWOBk5HB4kiydnSgUkooB4x9qpDDOQAsz
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

Introduce HWPoisonKernelOwned(), a small predicate that positively
identifies pages the hwpoison handler cannot recover from:

  HWPoisonKernelOwned(p, flags) :=
      !(MF_SOFT_OFFLINE && page_has_movable_ops(p)) &&
      (PageReserved(p) || PageSlab(p) ||
       PageTable(p)    || PageLargeKmalloc(p))

The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors the
same exception in HWPoisonHandlable(): soft-offline is allowed to
migrate movable_ops pages even though they are not on the LRU, and
we must not pre-empt that with an unrecoverable verdict.

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
 mm/memory-failure.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f4d3e6e20e13..8f63bdfeff8f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1325,6 +1325,28 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
 	return PageLRU(page) || is_free_buddy_page(page);
 }
 
+/*
+ * Positive identification of pages the hwpoison handler cannot recover.
+ * These page types are owned by kernel internals (no userspace mapping
+ * to unmap, no file mapping to invalidate, no migration target), so the
+ * shake_page() / retry loop in get_any_page() can never turn them into
+ * something HWPoisonHandlable() will accept.  Short-circuit them to
+ * -ENOTRECOVERABLE so callers can panic on operator request instead of
+ * spinning through retries that exit as a transient-looking -EIO.
+ *
+ * The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors
+ * HWPoisonHandlable(): soft-offline is allowed to migrate movable_ops
+ * pages even though they are not on the LRU.
+ */
+static inline bool HWPoisonKernelOwned(struct page *page, unsigned long flags)
+{
+	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
+		return false;
+
+	return PageReserved(page) || PageSlab(page) ||
+	       PageTable(page) || PageLargeKmalloc(page);
+}
+
 static int __get_hwpoison_page(struct page *page, unsigned long flags)
 {
 	struct folio *folio = page_folio(page);
@@ -1371,6 +1393,19 @@ static int get_any_page(struct page *p, unsigned long flags)
 	if (flags & MF_COUNT_INCREASED)
 		count_increased = true;
 
+	/*
+	 * Page types we know are kernel-owned and cannot be recovered.
+	 * Short-circuit before the shake_page() / retry loop, which
+	 * cannot turn any of these into something HWPoisonHandlable().
+	 * Drop the caller's reference if MF_COUNT_INCREASED took one.
+	 */
+	if (HWPoisonKernelOwned(p, flags)) {
+		if (count_increased)
+			put_page(p);
+		ret = -ENOTRECOVERABLE;
+		goto out;
+	}
+
 try_again:
 	if (!count_increased) {
 		ret = __get_hwpoison_page(p, flags);
@@ -1418,7 +1453,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 		ret = -EIO;
 	}
 out:
-	if (ret == -EIO)
+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
@@ -1475,7 +1510,10 @@ static int __get_unpoison_page(struct page *page)
  *         -EIO for pages on which we can not handle memory errors,
  *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
  *         operations like allocation and free,
- *         -EHWPOISON when the page is hwpoisoned and taken off from buddy.
+ *         -EHWPOISON when the page is hwpoisoned and taken off from buddy,
+ *         -ENOTRECOVERABLE for kernel-owned pages identified by
+ *         HWPoisonKernelOwned() (PG_reserved, slab,
+ *         page-table, large-kmalloc) that the handler cannot recover.
  */
 static int get_hwpoison_page(struct page *p, unsigned long flags)
 {

-- 
2.54.0


