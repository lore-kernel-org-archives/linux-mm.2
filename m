Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95503D374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19CF26B00B5; Fri,  5 Dec 2025 18:17:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126A76B00B6; Fri,  5 Dec 2025 18:17:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC076B00B7; Fri,  5 Dec 2025 18:17:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA9C26B00B5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:17:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 916C31A0234
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:54 +0000 (UTC)
X-FDA: 84186982068.26.EC4CFDE
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id D27E02000C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZEZVYtx8;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf03.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVUnQStwfypeNS8SEXvjI0KB0EJuUa8gDW3BIXGvW00=;
	b=TMNmwXU79bdPFO4wCNVD2xf/9o58DthYV4z+IctYXlnBsFWAoCR/J/AUO8Cu3A6K1F072P
	udqOjYwNSb1qlu4Ezvf+Azv5KVz5ytMF5YLlYXRMdk/gwi9L4314F9ZWYOUXDTGt+836DH
	OL4vB8vQ49CnW26z56OW6Nd+R5jPk54=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZEZVYtx8;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf03.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976673; a=rsa-sha256;
	cv=none;
	b=5NJZOxvagLQD9c86yne0bT85uxb7VQdtKLfq9wZC8xCbJmYiOXfZBSfZHtpNxfGD89KaG9
	GoLSvjFFyRIeZRmMyc/OCictacamHUQO3jRAqYxBp/6Zaujetu7FgBA3AoFDgFbsDGCKQR
	6BwifFoKHWTI2GakfMwsDxEss15FCMg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jVUnQStwfypeNS8SEXvjI0KB0EJuUa8gDW3BIXGvW00=; b=ZEZVYtx8JmELotkfzPfZwRAGeQ
	aQD9x3Awn7X1CqaMVjnE8zOjC61zuuvL4WOyGKOlt2L7uyQjCL5T0r8WaEtkUxeXdK5bXki41JbAx
	ljLLeTT4a3nZTKcMIEwowcRvklCLY3C78J2wZ33YM1XMrcJNhzwoKeB67+yxIRBhHuKX4vPiaVlPO
	BCQsVlFwhohsp6NYpMCU7i7bfeKetiEL/uNPVFlrGNg2Vurt6i8wSKNVY2dgr/lEHez7UThbRp0jp
	H8oLvmopyucEpdp+iAlaSRhcPwW7CiqIdIrsq6VgRi562ahwLZYXhVwnfKu85toh8zlDi/W/9GZ6e
	5DCz7yOw==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3b-009H1j-31; Sat, 06 Dec 2025 00:17:47 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 5/9] mm/page_owner: add swap hooks
Date: Fri,  5 Dec 2025 20:17:17 -0300
Message-ID: <20251205231721.104505-6-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c8j1oxmza6dmugnocse1zwd1hj43tbn8
X-Rspamd-Queue-Id: D27E02000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1764976672-683769
X-HE-Meta: U2FsdGVkX1+MUAGR1lV7Na8IbPoK0JWG7KZ37Ja8JKY1m4kBzcJmIC1Rw/BgBD3P7kvYcdpecbWLM3wKsPJ2jkrU0buU1iOZhCCMy2CtZTsCQunF3pSqkuaAUiJPUklblJ03c8UWHSCbWcUU77HVyjJhPCWwxYJz5mFmFHmP3hWFIlC/I9q9y3Fdhp6VOIhFUom+3eU7ENOu+5q4F20d1Pao8uxgbJ9Gi7bvhAQjnObbhvEXL2h5QZ7+4R2eFbtmFDGYvtLvM7f5DwEOTDwFic2YROhCD9kUv00x6s2mkkBT5s0Grc24iJYE+fiJc1x+LAj2OYLi66UtyQdghSnGmsR26lQWMEaL4tlVk0dCNt8zxATbOh7UPFnFtvDXs5yy0Tpxk/QQQya2oVA3EdSOGhnMHXWm2NLnFdxpOA+y/SWr4s/51qYLBNM+c3+hN23SdnSsZoTvQdeBzi8ojKKmvqWbQUQn2tvfnWxFqtoPykMRmmR1nQScQ6bK6uXHyKD3RTK6Q2LfpQIrXR/68v/Zu4LZRiEPvVoe4pffO4TXL7pKEgJyHVBjBlP6SgdDG5rjL5irbE4D1ACH4tQKFxHNZ/U5J/kEKxfPIqOjezppZnByqVuIGoQ+vtnHXFcl8io3WHeWh0eb3k3mMiCRN46sdzBWIo3NKnTQs25rkGSPiJ39e2Mgi284i5nilGhAm0S+1Qj+abdSsUVznUxwTe9szf5kGQcDHEgkHvcvZFQJhxeqKysDDn/tH6znpOAXAxfPx7/NX2dGuyV1w+5JJw1HZN4CLjZ3Qu3DPwCfqxSwQFMPAe508pZKC9MBgsc4vHipVt7My6laj+xLPMX/pEGgxgz7hokCq+WeEy2edoYqDMLxyUW8YTVWvnynqlehIA3La10JuZ/dXUowwEXJSCgb12Yh4xt6Wp+6EPHBvS7xmEktlmQ05RC8/uh2PDry9+pfRvjZJ177Iz2KM9X3P8W
 TX3x41/v
 RuYF3Jv9XjGA2hAfCbxgheepT1nKRHw3M9FzdzsGZjUmTpLUQ7aSYYQcrjZXQu2Qdt50one+utLC4Y8eSs4YPHjLBtm8At1mMXzdK3ax+BrmVk8Ob7yZssGHg7FlfwoCGqPddE3UnLC8wvxx74MyO0UlQnpXdVMJk0xU6DonicxMw3ddRX2caCeI7SDRMzfY3vB6vZEoMdUEHKS2N+fLCFsiDDaNLBeDncbss3sY8WPXYVE5uIroqYr8ZwESEsN6zS7RKuc2GHWV+FN0mPag8liIPMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the swap hooks 'prepare_to_swap()' (before swap-out and page-free),
'swap_restore()' (after page-alloc and swap-in), and 'swap_invalidate()'
for page and area.

The first two hooks are the core of the new functionality. They store
the (initial) allocation stack trace at swap-out and load it at swap-in,
in order to 'maintain' the allocation stack trace over swap-out/swap-in.

The refcounts for the initial allocation and the allocation at swap-in
are adjusted/fixed-up (incremented and decremented, respectively), as
the initial allocation is decremented at swap-out (page free) later, and
the swap-in allocation is incremented at swap-in (page alloc) earlier.

This is based on the swap hooks implementation for memory tags on arm64
('arch/arm64/mm/mteswap.c'; thanks!)

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 include/linux/page_owner.h |  49 +++++++++++++++
 mm/page_owner.c            | 120 +++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+)

diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
index 3328357f6dba..cd95aacceba7 100644
--- a/include/linux/page_owner.h
+++ b/include/linux/page_owner.h
@@ -75,4 +75,53 @@ static inline void dump_page_owner(const struct page *page)
 {
 }
 #endif /* CONFIG_PAGE_OWNER */
+
+#ifdef CONFIG_SWAP_PAGE_OWNER
+extern struct static_key_false swap_page_owner_inited;
+
+extern int __page_owner_prepare_to_swap(struct folio *folio);
+extern void __page_owner_swap_restore(swp_entry_t entry, struct folio *folio);
+extern void __page_owner_swap_invalidate_page(int type, pgoff_t offset);
+extern void __page_owner_swap_invalidate_area(int type);
+
+static inline int page_owner_prepare_to_swap(struct folio *folio)
+{
+	if (static_branch_unlikely(&swap_page_owner_inited))
+		return __page_owner_prepare_to_swap(folio);
+
+	return 0;
+}
+
+static inline void page_owner_swap_restore(swp_entry_t entry, struct folio *folio)
+{
+	if (static_branch_unlikely(&swap_page_owner_inited))
+		return __page_owner_swap_restore(entry, folio);
+}
+
+static inline void page_owner_swap_invalidate_page(int type, pgoff_t offset)
+{
+	if (static_branch_unlikely(&swap_page_owner_inited))
+		return __page_owner_swap_invalidate_page(type, offset);
+}
+
+static inline void page_owner_swap_invalidate_area(int type)
+{
+	if (static_branch_unlikely(&swap_page_owner_inited))
+		return __page_owner_swap_invalidate_area(type);
+}
+#else
+static inline int page_owner_prepare_to_swap(struct folio *folio)
+{
+	return 0;
+}
+static inline void page_owner_swap_restore(swp_entry_t entry, struct folio *folio)
+{
+}
+static inline void page_owner_swap_invalidate_page(int type, pgoff_t offset)
+{
+}
+static inline void page_owner_swap_invalidate_area(int type)
+{
+}
+#endif /* CONFIG_SWAP_PAGE_OWNER */
 #endif /* __LINUX_PAGE_OWNER_H */
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5cd7de1f8023..d256f58deca4 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -525,6 +525,126 @@ static void copy_from_swap_page_owner(struct page_owner *page_owner,
 	page_owner->tgid = spo->tgid;
 	strscpy(page_owner->comm, spo->comm, sizeof(page_owner->comm));
 }
+
+/* Store the initial stack information from page_owner to xarray. */
+int __page_owner_prepare_to_swap(struct folio *folio)
+{
+	struct page_ext_iter iter;
+	struct page_ext *page_ext;
+	struct page_owner *page_owner;
+	struct swap_page_owner *spo;
+	depot_stack_handle_t handle = 0;
+	swp_entry_t entry;
+	long i = 0, nr_pages = folio_nr_pages(folio);
+	int err;
+
+	rcu_read_lock();
+	for_each_page_ext(&folio->page, nr_pages, page_ext, iter) {
+		spo = alloc_swap_page_owner();
+		if (!spo) {
+			err = -ENOMEM;
+			goto out_locked;
+		}
+
+		page_owner = get_page_owner(page_ext);
+		copy_to_swap_page_owner(spo, page_owner);
+		entry = page_swap_entry(folio_page(folio, i));
+		err = store_swap_page_owner(spo, entry);
+		if (err)
+			goto out_locked;
+
+		if (!handle)
+			handle = page_owner->handle;
+		i++;
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Fix-up: increment refcount of the initial allocation.
+	 * It will be decremented by page-free at swap-out.
+	 */
+	inc_stack_record_count(handle, GFP_KERNEL, nr_pages);
+
+	return 0;
+
+out_locked:
+	for_each_page_ext(&folio->page, nr_pages, page_ext, iter) {
+		if (!i--)
+			break;
+
+		entry = page_swap_entry(folio_page(folio, i));
+		erase_swap_page_owner(entry, true);
+
+		page_owner = get_page_owner(page_ext);
+
+	}
+	rcu_read_unlock();
+	return err;
+}
+
+/* Load the initial stack information from xarray to page_owner. */
+void __page_owner_swap_restore(swp_entry_t entry, struct folio *folio)
+{
+	struct page_ext_iter iter;
+	struct page_ext *page_ext;
+	struct page_owner *page_owner;
+	struct swap_page_owner *spo;
+	depot_stack_handle_t handle = 0;
+	long i = 0, nr_pages = folio_nr_pages(folio);
+
+	rcu_read_lock();
+	for_each_page_ext(&folio->page, nr_pages, page_ext, iter) {
+		spo = (struct swap_page_owner *) load_swap_page_owner(entry);
+		if (!spo) {
+			rcu_read_unlock();
+			return;
+		}
+
+		page_owner = get_page_owner(page_ext);
+		copy_from_swap_page_owner(page_owner, spo);
+
+		if (!handle)
+			handle = page_owner->handle;
+		i++;
+		entry.val++;
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Fix-up: decrement refcount of the swap-in allocation.
+	 * It was incremented by the page-alloc at swap-in.
+	 * (early_handle: see __reset_page_owner().)
+	 *
+	 * FIXME(mfo): 'dec_stack_record_count: refcount went to 0 ...'
+	 * with stack_depot oops is hit occasionaly on tests or shutdown.
+	 */
+	if (handle != early_handle)
+		dec_stack_record_count(handle, nr_pages);
+}
+
+void __page_owner_swap_invalidate_page(int type, pgoff_t offset)
+{
+	swp_entry_t entry = swp_entry(type, offset);
+
+	erase_swap_page_owner(entry, true);
+}
+
+void __page_owner_swap_invalidate_area(int type)
+{
+	swp_entry_t first_entry = swp_entry(type, 0);
+	swp_entry_t last_entry = swp_entry(type + 1, 0);
+	swp_entry_t entry;
+	void *spo;
+
+	XA_STATE(xa_state, &swap_page_owners, first_entry.val);
+
+	xa_lock(&swap_page_owners);
+	xas_for_each(&xa_state, spo, last_entry.val - 1) {
+		entry.val = xa_state.xa_index;
+		erase_swap_page_owner(entry, false);
+	}
+	xa_unlock(&swap_page_owners);
+}
 #endif
 
 void pagetypeinfo_showmixedcount_print(struct seq_file *m,
-- 
2.51.0


