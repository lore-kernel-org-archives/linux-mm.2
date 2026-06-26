Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1860C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745A96B00D2; Fri, 26 Jun 2026 11:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3D76B00D4; Fri, 26 Jun 2026 11:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE2D6B00D5; Fri, 26 Jun 2026 11:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 239746B00D2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:34:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA485A04D6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:01 +0000 (UTC)
X-FDA: 84922459482.24.A1C185A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 011901C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:33:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=steeb120;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782488040;
	b=ORbTlFuzgaxh21qKD2rFCsetWBEDg/HHIA6QAnKASp/JDqoJP2GZA1dgTbx7U/8ysp2Fqu
	VlFzmlDGs0jCbXwuD19MfSOPcwceYAvORGCndvwHBHpflpAJgZ/eJ6eSqJyCn1TZizauQ9
	NbsM3IWacPEQPwCmdqazkbiz4AiVyrM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782488040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOiPkwothfTA2rmi+c/kq8SP1KePaaV5Q1IWxlsVhMY=;
	b=EbTwcYBqnA3hVHplshf9lglM/HJWlu0zysn2McN3dgOkp88TzCoamR6yKUepEuuHdAQrfA
	9gklONlWz7pEJ3FUr+T3dLO3UlICzUCSAzSqZwyvn4x+rk5p2fSCM5/DtXCTrOKFbw81Dw
	+IAqmxTHaa/oGO/aOkSl9nIdG+lbwTo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=steeb120;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=QOiPkwothfTA2rmi+c/kq8SP1KePaaV5Q1IWxlsVhMY=; b=steeb120KU41n9ZeVlTyW0pGpU
	k7y9mdQoFsHvz5frOdb0PP5WUEi7W6SP6p4LKClySNcPCK7gBF9Bt2nzLw6uLLxyvO68kYac53jrl
	H7BXMr7+eO1j/HO9uCgukHVZ9GgpTMDnE8BnVGMTpSTvKE3nLMh5sFWX3Uu3JiS9HO658TK6xjesR
	XNddL3kFRIZzwkkvC+FeuCVreS3veQ2E3ZO8vWrDKVcjeTfBmOLMSz0LptZowoKCgcbhx/jPeIlpj
	XNte/LIauhCKhJfrPfGf90CwTr05761RBBV90XxuU8zcj9qqLzKb5RnWOVtd9rvi3+gqgNOunsQXf
	8BHvX07A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8Yo-004489-2J;
	Fri, 26 Jun 2026 15:33:43 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 08:33:16 -0700
Subject: [PATCH v10 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-ecc_panic-v10-2-6dacb8ad024d@debian.org>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
In-Reply-To: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6471; i=leitao@debian.org;
 h=from:subject:message-id; bh=N16Suf8TPJtaU7ji4gu05w60pkCD4r5zujzdnjvNYGw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPpvEkahGSTW7zDidAQDNvyfvCI4lnqkBgT+xq
 NlVQr75DHuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6bxAAKCRA1o5Of/Hh3
 bTCVEACap2rkTh4AtD9dy1UYvGkg0B8XKDoewS9xwTRWGKgG/8LyO9WGZHJ2fzVx0zrUuP2p9gq
 ioh18rHB7jzDOADmagEUS3OhIO645Iv/LjG9rSRofOTkhZjfy2tLCn55dYwSv7Kl5XwgGlSCTdW
 fJ1rKOiacas3YvbivRuQEtfP+g2Me6mcggMP2F0f94Ro0DUGrOO/b0YBgN24Hi8pTgNOctn6tpR
 R36dL6HdzYedODmQgAF7XozMZCVYF3Fbs9AvoeQV0hb2eMd3700G1WyObB7DmKJGCkOPp7pJomd
 LJB1Esm+Bvat8vD8KijIDG4HsReDVkZaaQD50gUPLoeQpHSHUyc62TLeqpqbYYvoOimWCHXMhvc
 5u1+MhJN4cUklevGOEapPIlHHc6vNJI1FsE12PAOOhS/jM3k4otU+eKwbuqsNrOxjUwHec6iZcK
 ZrrRqgdnH275deoYBM7F9qkhwZqJyXHJpgy+fRxi95ebMEsY3pfJUPh865zo5PgvMz7jnbvmEYS
 Y/mwXEhZ0ZKYzzSpiV4930ph/2kMoJXON73m2Ku0LI5tX5uMaIan6esJfnsGbZ7ln2HW1J9Cjlu
 deCwzXP37Tg682gCCTAHHrO6Zpz2NhlywAaRqU5KF1hC8FZwX9LcCwG4lC50H+aVe2nQuaR9gL6
 z16owN1ct9RMeSw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 011901C0005
X-Stat-Signature: 3m6x6z8unrofrr9pppqoyt54714qikpf
X-HE-Tag: 1782488039-606572
X-HE-Meta: U2FsdGVkX18hMcydYTDtrnrjJPgXe4crdeBQFaqBMkDERC9xY6k8MQkwQXLadhPBal/v6N/fCJKcBeIIkbi66KMKHNOW35wQldj1lAXemTPRKnfrQnQsrNuho00OCtfGxKEsS89T9DJLRTQ741+xkVSsv+lKN3R0uGtwE1qQViqK13suMUlG0GN7Zuc0NbpaRJrUtYZCr9W5t+NRQgioJU878MLEn/k/zNEMsQnnUE09Ln4U9xG8MikEdkCDmB4GiAmKouKBdPhr6AMpnxllO+vmDSq5nyvhrjWWa4RXxxhVZT//FMYeEu+E9fXLLtws+ESCac//o5nsycvkbWvd50tAbS1xIVyq+axukxFJa6Q9tEB3jcjzPOv4A3J0oWBVmjpF3RC12XVNGNhSV0eL14ASu6IRWVtI/lEsdSkpb7OivzlXp42pjUH2e10V9SZ5qD4FQ8jUBXZrteTRDNyyoxEz2pjNeBY4JgzQbI3hxEOqUToXZtf2FzHjpLIH6t1J3ZJjGT1Rn4N8cF9StH72eJRBpmv1pzmfEWx0KF3k6hHWk0yHduXCcT8oLkBord1ZUY4uzr88O6Fp2Aj9RjtQppHyvt2AjEc4Je7YQ6IHh6zDP+q04hnaRQ99Q9WLZCgJ34NMoQPaJWbBOh1upDwPQ4TVLXv/K7Rx/aAn6vvlYAkyx1RhSSRqqDAyxnweo+uQymzPHq/32peUx2kOKnrwvK0gzXUHSAj+MRyFusYNhAl7ljUPYXHWrrtQI4CzmAyoyvHbg+GB3BXkuUQjmMWQOrXKwEeVO2XHoTfeOMNBhR5dXWqU8THJ8LZ5WALFdrNSzH57h+2B9kYr1cKn+bvqpRny8V/evEwaI9AxOHaMGAKjUog+3dfhEH9AiMnjxonW7Kd7SpwZ154Whc1aQKnBp/76FVuEa4ip2Fb1RceYEFf5+B5eIO9gdDJ7b9OIGQdvLdsTaxo4ebjy9H7Njhe
 hbH44Bjv
 y4rKDSnuleqe5wvh8Y1bsRPoGvBlNAGLTMekGuLF4tk2jTBffcdmK1eXtsiR3nvcFEhfe4fFISDpefK5J3t9niH9sThJLhKU0ByldOO41qvOBYmGgFWCeFfZ1eM1c3GRSjfa0rmsigcXMVClXr142vi/UP9TuA0nmYslCslDLKopVQ8EntI4Y2mZFRs+/gShG45KuAjSHWcwqLtoeifrDrh/NnHDyjWhIFDMUpyQDYB86GKO5SjTfKCl1Rv6eq209khyusxWB1inJx8KYwy6xXIBTeh31+1kondoNoZHqncjWl3MnjF/4aRLC88YXvocC6GeC0iOCsJpRGKttK0BSiexRt7N8tL2MgT73cpwTjzH2QYiSKW+Vb4Aj/uKCu5lR1ARk
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
 mm/memory-failure.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f4d3e6e20e13f..d08fbd0d8c39f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1325,6 +1325,36 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
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
+	 * a stale view.  A free->alloc->free in the same window is still
+	 * possible but closing it would require taking a reference here.
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
@@ -1371,6 +1401,19 @@ static int get_any_page(struct page *p, unsigned long flags)
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
@@ -1418,7 +1461,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 		ret = -EIO;
 	}
 out:
-	if (ret == -EIO)
+	if (ret == -EIO || ret == -ENOTRECOVERABLE)
 		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
@@ -1475,7 +1518,10 @@ static int __get_unpoison_page(struct page *page)
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


