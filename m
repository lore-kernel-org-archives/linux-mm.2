Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC8DD374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7486B013D; Fri,  5 Dec 2025 18:18:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767DA6B0317; Fri,  5 Dec 2025 18:18:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A51E6B0318; Fri,  5 Dec 2025 18:18:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D50E6B013D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:17:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B671E16035F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:57 +0000 (UTC)
X-FDA: 84186982194.12.A665110
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 239F8C0009
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=J0Kfx8j6;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf28.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976676; a=rsa-sha256;
	cv=none;
	b=l5NX72CxDWiMwkzNIeD7ZVb3SJsNYsjA+Wla5yjiMMyA8ojCbWVOlJBjxM+MxAVmzK3lNp
	7Sijrd9/i7XCPwVcklGK29+3zzmBCcqNJTXl5BWhlncC4QOXFNbxRlog/mO1CBPi5xrkjE
	FcD3Q9NRBaXU/D2ZL8w/t2tlfENRyfM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=J0Kfx8j6;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf28.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Be4md6ScQBymbi4Un/wkCf1ZzGb3QrWFfwvJYmGp4QA=;
	b=yNps8prg/N88JlEIWGiDlFt6yqFeN7oiRf7zYn7MAcJsGqpTQoKskfpjvkbkFHs6PzUI8s
	fYXDuYWQeWb29FSJ2gI5peqCdNuY3ePtPLiHUqoYP05oag8SXTjBYTgJPToHdZ7pPimVF9
	jSA2hqXFLRwyukN7SOnK4N2zBuV3ztU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Be4md6ScQBymbi4Un/wkCf1ZzGb3QrWFfwvJYmGp4QA=; b=J0Kfx8j6qgmtxY2QGR5psVlUo0
	Qwq0ArB/OGaW+IIfAvafvihpE35uu3wwoNtff08tnGmd0Jw2Q6fKNOb4P6KcT98Zqj4Q3Zrc7wNuN
	hw0zTiLhHuwPydsGufe5WK3mwgWtqZwmMjR87MSY5SoWQit6RFZJMVjBmFOzhpox893jNm7nncDC5
	bgq+RX+oLqnm0NSaMm/5IAhOpa2V3lttNq5pW9hL435oVes9BY+N7zE6nC2IMVMFGcYu2NW6RwLSJ
	J+7Ey35oI6ZEbBITAz2j4FvHMR5p5T6c9a14QDopQN6ykkhYgn7Wai3JzeGGB2OZa+Be49/r5L1uT
	Au90KcPw==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3f-009H1j-6A; Sat, 06 Dec 2025 00:17:51 +0100
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
Subject: [PATCH RFC 6/9] mm/page_owner: report '(swapped)' pages in debugfs file 'page_owner'
Date: Fri,  5 Dec 2025 20:17:18 -0300
Message-ID: <20251205231721.104505-7-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 66ram5tex5chu3wmzyxaqi4rx7nw8acn
X-Rspam-User: 
X-Rspamd-Queue-Id: 239F8C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1764976675-429085
X-HE-Meta: U2FsdGVkX1/emegvJHmQ7NGT+pnr5Yh4y7bbgcBFQ31bhzDAWzA+oG4v+ZWmUmOlDVv6ZLbKHCtI7aSWfI95qv08J3n9jDyd63+QxbW1H6pNq2zuUV9K0mlnToi53eDkfQq57ZyhEL4hUleas30OYCY4jsPUm0WXjEzNzvzMqoccjxS4Xz+S8NDvZltXqiXT0JHVtokAgCwBxFycIcUlNzxUZ81oDaFwX7Y0YdQmRXXc+nmFYGyNcdQ/Y332QNvcJ0hF2wFtVKRZULggQC9IBBFbL6rEJewATgUr0nvZ+GneMXTYtcAnWxD2VhlhTV5ealPX8PedYeDrUA2CBQ0X6v5Q4xBnBsbYpsr9x51CSdBViBDIK6qDMZboM8l9ZrzAGedb0tpwrkQRJGjwe8SM8zSDGijVOC3gGs0xscWe4BAOg852fJzBevdZIXqMxtw8r+yhxYSoQ2ke0ry9GGhXuMQISf309hRQwlolbxrenl9B2Y/7rnysNurgJQI26TKqV4aoCMFEBQdUAyE3IhSvjrnwnXmvbT5VG55uw5sfQGkcJqD72+mawMZ1pYNgFg31KWjVqdEgCGI40QcRWuEtRkS/W/059fQ+tgSd5bEJLl/mBk2quwZceiGy4tdaYQhsT0UtKE4HXshfcvaA0V1fsMf6ZU7jCJ8+oYncWSLr4nvO+pTgykwX6nc7J+UsBM39P25vRiFegbcQevo382XFRWm7t9laHwYdI9IY09khu+SMcNOmPZDzWnO0tKWXU/b1BFCLnhgv4ov2DtWQSNAzWh3rBtVkMaPDMZxdGHEftMYQngvQkp4/ikDYCT1gSGRUuBHSstVUIGqlLDy8qtlhyr5l4JiyUPvd6Mz3QM7Xe8Wqnun9cDoXaI0e9y6IqiI6Jngjx3uJWtsQJQxKXakS/qzMWIqhicd0o943w9X+kODWwolNFYlr0UfeFt9TT8x76dbNdJ6fHopB6jdmrK/
 YvqXAIew
 PKYc6t5vuRmT+3TqN8cvxXPGkXw4NpuXdoKgfvNdV8kITa+wcLKygr3zXUx19eKo0/M+6x/4nVbL82Is0fNtf/7g/kPo7xjfm+jSmWmhIBnzKhZAuQ5juteAlpPaQHudoD49Bz51p4MOWiL1SSEKqkwqVM/0YkzJ8zoIXnsbv8ra5vIbJpo66oyAtiYsf7FqNvTbyOEWY0ZEoPea5jS9cSDDgLn/Dt972cwoqwdjToGeBwgRgXEaTu2jVtOwT0YNMB9cKkjO8Hpr5eUL00f6To8clI3n2Pk2pL6GvTIAByvnuUdAWugVk6w4VrkSI87G4pFhi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Report whether a page has been swapped in /sys/kernel/debug/page_owner.
This is helpful for stats, verifying the functionality, and debugging.

Add the 'swapped' field to 'struct page_owner' to track whether the page
has been swapped-in (and had allocation stack and some fields overridden).

Clear it via __set_page_owner() (page allocation), __reset_page_owner()
(page free), and init_pages_in_zone() (init). Set it in the swap_restore()
swap hook (swap-in).

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index d256f58deca4..589aa1d7b9b6 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -34,6 +34,9 @@ struct page_owner {
 	pid_t tgid;
 	pid_t free_pid;
 	pid_t free_tgid;
+#ifdef CONFIG_SWAP_PAGE_OWNER
+	bool swapped;
+#endif
 };
 
 struct stack {
@@ -275,7 +278,8 @@ static inline void __update_page_owner_handle(struct page *page,
 					      unsigned short order,
 					      gfp_t gfp_mask,
 					      short last_migrate_reason, u64 ts_nsec,
-					      pid_t pid, pid_t tgid, char *comm)
+					      pid_t pid, pid_t tgid, char *comm,
+					      bool __maybe_unused swapped)
 {
 	struct page_ext_iter iter;
 	struct page_ext *page_ext;
@@ -293,6 +297,9 @@ static inline void __update_page_owner_handle(struct page *page,
 		page_owner->ts_nsec = ts_nsec;
 		strscpy(page_owner->comm, comm,
 			sizeof(page_owner->comm));
+#ifdef CONFIG_SWAP_PAGE_OWNER
+		page_owner->swapped = swapped;
+#endif
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 	}
@@ -316,6 +323,9 @@ static inline void __update_page_owner_free_handle(struct page *page,
 		if (handle) {
 			__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 			page_owner->free_handle = handle;
+#ifdef CONFIG_SWAP_PAGE_OWNER
+			page_owner->swapped = false;
+#endif
 		}
 		page_owner->free_ts_nsec = free_ts_nsec;
 		page_owner->free_pid = current->pid;
@@ -370,7 +380,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	handle = save_stack(gfp_mask);
 	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
 				   ts_nsec, current->pid, current->tgid,
-				   current->comm);
+				   current->comm, false);
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
 }
 
@@ -428,7 +438,13 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 				   old_page_owner->order, old_page_owner->gfp_mask,
 				   old_page_owner->last_migrate_reason,
 				   old_page_owner->ts_nsec, old_page_owner->pid,
-				   old_page_owner->tgid, old_page_owner->comm);
+				   old_page_owner->tgid, old_page_owner->comm,
+#ifdef CONFIG_SWAP_PAGE_OWNER
+				   old_page_owner->swapped
+#else
+				   false
+#endif
+				  );
 	/*
 	 * Do not proactively clear PAGE_EXT_OWNER{_ALLOCATED} bits as the folio
 	 * will be freed after migration. Keep them until then as they may be
@@ -602,6 +618,7 @@ void __page_owner_swap_restore(swp_entry_t entry, struct folio *folio)
 
 		page_owner = get_page_owner(page_ext);
 		copy_from_swap_page_owner(page_owner, spo);
+		page_owner->swapped = true;
 
 		if (!handle)
 			handle = page_owner->handle;
@@ -783,12 +800,20 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		return -ENOMEM;
 
 	ret = scnprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
 			page_owner->tgid, page_owner->comm,
 			page_owner->ts_nsec);
 
+#ifdef CONFIG_SWAP_PAGE_OWNER
+	if (static_branch_unlikely(&swap_page_owner_inited) &&
+	    page_owner->swapped) {
+		ret += scnprintf(kbuf + ret, count - ret, " (swapped)");
+	}
+#endif
+	ret += scnprintf(kbuf + ret, count - ret, "\n");
+
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
 	page_mt  = gfp_migratetype(page_owner->gfp_mask);
@@ -1052,7 +1077,8 @@ static void init_pages_in_zone(struct zone *zone)
 			/* Found early allocated page */
 			__update_page_owner_handle(page, early_handle, 0, 0,
 						   -1, local_clock(), current->pid,
-						   current->tgid, current->comm);
+						   current->tgid, current->comm,
+						   false);
 			count++;
 ext_put_continue:
 			page_ext_put(page_ext);
-- 
2.51.0


