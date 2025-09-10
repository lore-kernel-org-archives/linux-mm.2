Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4951DCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60D18E0031; Wed, 10 Sep 2025 12:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945B38E0005; Wed, 10 Sep 2025 12:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835C48E0031; Wed, 10 Sep 2025 12:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5628E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A55FB5B7E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:49 +0000 (UTC)
X-FDA: 83873826498.08.F32C6F7
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3913F80007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iqoig0H5;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520587;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUMwPFkC6/4gEbz67OObm145GGunBjCLIUgwlHXltYw=;
	b=fM/PqALj7pN5pvzJ2kEOwRzWgMU2P7szKdH32hG4A2jrRNZ+8mj8s10jwoRWWbxqVR9QN1
	34caFc7NkyrOxNuFQFwQSHn7mUNvo/tSPxcNzirdZg+c0unWjHpel3wqF6Mj38JbyedlGm
	OsurnCo4KN+z9mvIgAd8CqKJAPRJUUk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iqoig0H5;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520587; a=rsa-sha256;
	cv=none;
	b=al9/Yu5VUqsG1dSe6pq/sxlAX8IDG3TAHfRQ+441dFAXZTfSj8FI540ick8rgOo7S42mBQ
	s2a2q8pG6aJcAMXhygogG4ZK4MWZpEBmqSC+WZzPGAuzVfcGJGpkZ/uW1DeH9Yh6EQkyvP
	n9nlzDJF4NtET8xm99qwf3nmt11pCfE=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7724df82cabso7939080b3a.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520586; x=1758125386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mUMwPFkC6/4gEbz67OObm145GGunBjCLIUgwlHXltYw=;
        b=iqoig0H5EY5kU7vVPg9jxXgn9KzjkLz3/KS9XT8UyAfC3L5Sh/iOpLtQHqZyQYSO4Z
         Rwq9iFyPS7kycosGiQ42dg7lKldzxGEit8JAPTVJc3PccuCg6pJDSLBKPMWkjH3EwQGR
         K5HiIgldwczxPPisreAKzhvmADoTwtMUQXZEHmTWlKPTptkMH0cyWdtaIrBofcoN9rXv
         P9eKLwnA3tcW7qjYp+XHMmz6jvrWpCM8flPGfpxVNK5g6kBy7D0mOVCrmJF0+uRbwajf
         PobIYXPPEPGcpeLHi9Kmhp8wJxK0W0kuvARNRKkhP+YeftMwVZa038flBDHVsrq6I1WP
         yHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520586; x=1758125386;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mUMwPFkC6/4gEbz67OObm145GGunBjCLIUgwlHXltYw=;
        b=R8qh8s2zID3Y2MIrdquVtIKuwUhkph/6gLZ95vKoD3MjWjAMm/zSTWIs/WS2G6P8mr
         SDmA1ZfT6KEiBQH+VWsywTXXg/rK+uTxW1GRgo/etyLGq0Z8DQD08Lw25289KnyFcQZe
         zxMBq7soP+SG1fn0GUFXQsguQeowDeRFPP+fJRijupp4xLMtufp9d+O1qdd3DUIUvd+E
         NoIZXS3NSIEhP6pY8wYIBdQGzLvFwMwrsVrJFM2zi8upxyFQHsZhXvnAXLm4GP4egNQ6
         Bxnw2zb5JOrlmq1AHXp27KOUaqA0oKE4vvMpEd3u37ZMny4FWUGkyVVTW8zuDyowLyAc
         v9YA==
X-Gm-Message-State: AOJu0YxBA+lwJPXKe8pezAe6pB7hRrYuo5V+gAtKr3e6j4SKneW1r+YN
	ct38sHmJadmOfz1W6cOGmPnsexuSuZdUC4MXtds/mwixK5KBK5YmBD1cV1MpfBlW4D4=
X-Gm-Gg: ASbGncv4C9dGi2d5fvLgMSgWaPMMQUeIv4BMNYwN93n/HNI0vfCrQIoDpFfd1QQxgeI
	3nRl3zoLG+bS8DXaqzcIV0GMknEuoEzQlkxaLxY7HttRwP+Epa+CYDO8zj+uVZCe7UTVCT2sjEB
	KImybErHIv9ypWIibNAlJCUR2IPauchoBZFXmZnwKytihgxs4MNU3t7tU/k+Exyol8yzKTsbJdi
	hrfApto7GUADjjYJut53tokBWHfMXLkvJmTnycQpigk97+cqooHDx1yqCPxK5JJlh59Iz2CNth+
	fqNNtZlxWhg0oLGLdkWjKBJ4gc5dYR31ZChZ0egQ4GNZZEQS3P+UjYJ5ZL9PnrjnDKUdWrFhJMv
	i/UWuTHJ36xjrxP59iBMSnZyz5vp6XRp4zJkSIOUqt4ji9Ho=
X-Google-Smtp-Source: AGHT+IF4aEJFdwdzqld0Qv3VuyHOHub7zXw74OiqWKQuRHCc9dAp9UkKKUX0sq6k06ILw38fGnOA9Q==
X-Received: by 2002:a05:6a20:2584:b0:246:3a6:3e45 with SMTP id adf61e73a8af0-2534557cb54mr23558299637.46.1757520585439;
        Wed, 10 Sep 2025 09:09:45 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:45 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 12/15] mm, swap: mark swap address space ro and add context debug check
Date: Thu, 11 Sep 2025 00:08:30 +0800
Message-ID: <20250910160833.3464-13-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3913F80007
X-Stat-Signature: gzzantsk3jar4k3ri9sr3tdzz93q1d1b
X-HE-Tag: 1757520587-920250
X-HE-Meta: U2FsdGVkX1/Kx/5eG2kPeZWluHXota49AKosQh5cCfQk8HYZw9bSdflMTe+cri06FYQbV2UxsKMr43hghRvcYmRrPLQ3WaKDYPSnEQAGPcRDF6q6N1mJg9iNlB7hWCNmAzSpnxubswWcEtPAK/XBcN+pjh3VJWwiCwmeQwQj30j+1vLe8j6dYBxPElQBsgmcHYmKaL+WjUECpdI9LXUB0OkWDmWrWKc42Dl99js744DtohEf1Agyyz5oq771lCgmwhcAfhXTjY7L6mYUvD2dFY3HRuarsLMMg38X4RRj54//OG81o7993lBoPBlpYcycx+PpLb5T+Otym4dYNEsuhGiPRqz92kni79WbXN6RM+w6NLKDurkM/yjrHvWdX+917wakyGNUId2fFQsJyfDlO40INipEe65//veogvlbnEMD9FVkkAvd7Wimq34GlmsCN6LuYuzIo7ERZMXczKAqNI1PMdW08xpsv4sl+htnZFvxL1YHydWKikOgQHbbwd54gcxQExN31QcpBNCStmjcUI2AJgI7MZ1gjkjRfOMqKni2Z8m2X6vX4xUhuUy47bwGnDjDfeyVLBFc6an1uZOz1bVGaDkk4Nu5DWRewtXObGItc8j00r+3IzPcgdLqazQQakWZ4JHI82GF0XdkQjVtDvINEFyTp5C77uFX8OJwFo7op9vB+J8oFhDYAPqVpq42dQpw6Axl2su2FiuUOXOSyV/O2J9VGMhPczA/p7XSrNrwk9KRcbo7que8/4lI3W/eeBKrnNlCMMwWEwQFQvOjBbR50W0nwz+WPWcWiUI2ESDHfJ8yVuzdljdhr7PlqtxoheUomnuM7WqRowOLWC3JY0i7AEtx5zwsfO+JWdrwHGCheuDfTf7X0TPoSyGEWmim7LnMBnoKMBb3tfhL5fHLM1w+UiZrV71a8bjTp6w0RPMdPCXXzcPjWPx8z0nJSw2X72FRiUbDhRK+5tzGiU3
 BmmhDYeg
 ECItLNYRjTpHsQ2aF6FM1Zk2ZeNDpqamuMRay08hb9dEldjKz1RKSJOatqTqwfQYjGMZUZyeyzR8hjf0TmraJILpV246TOJPNOc+nZSeIYI5D5c9UmIwQqQnIVk0zvauy8Ee4wZLXrUpmuuIk3j0QYQ+nef2AEuW2Z4rdViLad0ov26vDdTdknorV6m1p4lme3Bz1jbvrXQ4GAbZzMdy5kQJzcOrISscLeyppGP0zirEv+6iostx8RHBDYmEv1P7dZGZllWjoKSVz3UTelTkpMcqjOJyHMupNt2jGFaBhWjC2C2zPlDOAwb/W/2/4OkvvPe49tpZDhngDQzOF5R4GAu2RdH8r9kvbPTl8gXZnRckEEubZvURGx0KZIWAi8BF2W/4gRVrnZOVg+TTjRm/mfQQI2U1VlPPtXQQLdatPImD0wXTchmPJ9fvnTXlFXOzMYja/JepKgTrW57zxnIQ09MkECRbjdMUxYxQEc7Fz7jmHq5odLqdBGXtVNzrJlrD8w39iVW7uEhfAM+YLh4M6hVNXy97rkGLRff/GY7XaH2171imYJ4kRTMSYw+LJtSV5b0hxx0Hbl8hXxVoEzoCrWYAgmb/DtZPI9Jr8vwA/1LedxlM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cache is now backed by swap table, and the address space is not
holding any mutable data anymore. And swap cache is now protected by
the swap cluster lock, instead of the XArray lock. All access to swap
cache are wrapped by swap cache helpers. Locking is mostly handled
internally by swap cache helpers, only a few __swap_cache_* helpers
require the caller to lock the cluster by themselves.

Worth noting that, unlike XArray, the cluster lock is not IRQ safe.
The swap cache was very different compared to filemap, and now it's
completely separated from filemap. Nothing wants to mark or change
anything or do a writeback callback in IRQ.

So explicitly document this and add a debug check to avoid further
potential misuse. And mark the swap cache space as read-only to avoid
any user wrongly mixing unexpected filemap helpers with swap cache.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/swap.h       | 12 +++++++++++-
 mm/swap_state.c |  3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 742db4d46d23..adcd85fa8538 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -99,6 +99,16 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 {
 	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
 
+	/*
+	 * Nothing modifies swap cache in an IRQ context. All access to
+	 * swap cache is wrapped by swap_cache_* helpers, and swap cache
+	 * writeback is handled outside of IRQs. Swapin or swapout never
+	 * occurs in IRQ, and neither does in-place split or replace.
+	 *
+	 * Besides, modifying swap cache requires synchronization with
+	 * swap_map, which was never IRQ safe.
+	 */
+	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	if (irq)
 		spin_lock_irq(&ci->lock);
@@ -192,7 +202,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 #define SWAP_ADDRESS_SPACE_SHIFT	14
 #define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
 #define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
-extern struct address_space swap_space;
+extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f4a579c23087..97372539a575 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -37,7 +37,8 @@ static const struct address_space_operations swap_aops = {
 #endif
 };
 
-struct address_space swap_space __read_mostly = {
+/* Set swap_space as read only as swap cache is handled by swap table */
+struct address_space swap_space __ro_after_init = {
 	.a_ops = &swap_aops,
 };
 
-- 
2.51.0


