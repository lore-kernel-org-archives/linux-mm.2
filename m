Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 036D7D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D196B00A6; Thu, 15 Jan 2026 04:21:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644BC6B00A9; Thu, 15 Jan 2026 04:21:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592616B00AA; Thu, 15 Jan 2026 04:21:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46EC16B00A6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05D438AA62
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:49 +0000 (UTC)
X-FDA: 84333655938.25.37BE039
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 718E64000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OFYSnzrR;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQK/s74PjQsybo7IufNQRVQZSXZogi5TVyOZzcgmn8Y=;
	b=iyD1U+AzcfNOAc4RwIiCKXgCwrKsZtPF+N0zvRuJ36T48JHtLjZaKz/lp9E6B6hIwE6AC9
	r6xlyeW3+QOTMDzd1EPiiJrn7k+rLjd0gM10MceXpC+XK0WgFdv0BNeWko9i2d+ZdjmBFU
	ftNfaYdm5DKJAl7/vc0P84OjCBh2faw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OFYSnzrR;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468907; a=rsa-sha256;
	cv=none;
	b=do5fiQcyZ23UD3zR6BZckw/bq6eUEuiX+QhFXpxl3iCkF/47btKGa5hNDOpGF3o+thHak2
	z1YDH8MYg/J7X07vNJ/0jF3V4gSJF9/VxulztEOxzHV3NuzjGwUbZ5NO+jKsw9ZwhoDPge
	e/i0x6Rz4gndKoJ1rxvd3z/niU7NxOw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10AE8601AF;
	Thu, 15 Jan 2026 09:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3F7C116D0;
	Thu, 15 Jan 2026 09:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468906;
	bh=QfJODb3fLD5hI0yqpV8bPffFJbeeNR9z0J/ex3110GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFYSnzrRIk8CUweoFvnALc8UkccAxZt/i3iCriyBA+I/zJLMeME8Mp2WVUoiICN3b
	 CBVMgtFX/1kPf6qCUSX8OuUmfeDlgSrLnIZMdi1GXhai8maIA8s0xRP63jmbrO9BkO
	 2arju4rT7IQiibRnpqgIe+UbVDQRnOx3QuBgrDXkDgnbUIey/MD/gCgq1h9VbyOCmg
	 BMg15H/nhYtfsbk8SCZQSruMTcFGWI/6EcjjsDuezMPHOdQ9Mv/NfXCh0wJGwx2Cmn
	 MsAxSB0BlH4irDhYEedCtspCpCYR72b65QBxumJxnErOBx0dBYbhsHJdwr4/+xuw1e
	 TFQdfFS4JjoLQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 12/23] mm/balloon_compaction: remove balloon_page_push/pop()
Date: Thu, 15 Jan 2026 10:20:02 +0100
Message-ID: <20260115092015.3928975-13-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdibhc3spnfq4qyx35rfa8ohc6r9emoy
X-Rspam-User: 
X-Rspamd-Queue-Id: 718E64000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768468907-323117
X-HE-Meta: U2FsdGVkX18VvlpxjrhbpvGIVR6sEf33rN3q7INb+Glfy6xESLb6Svm3Eu0a2W52irvp3f2oEzNt5y5wiWcUrcCNLL4T/J3s1TwbR/YxK9zyi0svHuo1VnOrH/S9CW+eycwlTN1mdtfy40MbWUXm2yyzhiI9eCFR4R96o+qtwqZz3lw4lI8uLZxdRt2tqaKO/LWuTsMC3TU9CsgdedQ518GIMqkaNDWAD5hnlIyU12/VVPLS0oPa36oqwaIZifV6sSP9DGUOBdofXZ1rXoyFydgkj9H1P3Dp8qots02B7cN7usb6DWPvic0p13vfbxKJ+Hs+6FeJeBYAvBT4QiAWJJUD1CoAPMHoyRFnEyTGfZQsDiRIS0EQuVc1SerAax8TsM4skHNYw5Rm5MX32kkpvFxQeKdf4mEJCbZ3NKsFQkfQg13QW1vp0AIMbYnFbqtjqmLXFC/hM5urflf0uLGp//ejIlbmnVimR141LtZVF0ybvzz1kQn4B8Ki3LUpbnObnWn10OEZN4Lc6IDcoQrnjScY8OF9uykpJRgSHd6VaR0Up34nper43kG2EL82EZBHJ3WYS+cZIDhZpARuyVytWFLK5Qyr/oK0buyDgXqiCHM4OK89zSjwlU7KMAWQi7nYObpusuv9WR9jMiaN3HU2PhXoIeJgIRKGwXSK9JSZbgs3DVm29o6NLMIcVjv1bKRYXZ/4PnJ1BJMRVp2KGKHujk7fKd5en+2QiVlZWjWhER2Govn9C4G8px5IOHnwklJ5bsrrhfyY/sxuPlTlXd02rijVdV1Bu7BMHmEbnduoXwYSjQnjByMAzhjjp/nUtmfVpvaooTaKSDfYjZqwQMsUFUmUTkugreV4T7ws5uSTKdBBiz6P+3jeWc7gcYShyh5Yb/Uxqif7er7zDucxeJ1h7MUgOtDO6OdD4Z02qt8/z3PzX84yq56zqr/WPl1lobYkrnoJGIWUIbk7mKWGkOf
 E1G9o2Jb
 +AgziO3yADxigEeV7hPaMNYM4D1FquUQHmzBLWEPYa3+sievuPum/IaS0+rqIRB6gzjOoqV8NWVqH2V/Erbypprc+x+qO+MR+kpttqvEUSK8v+MW1cp07kodnSWCBtly3/C49bqdJyJXuvVtC23CNa6BAlEeAVvk75lkgcd/+L9YJQ4mNycqjyBD0gUW4cQHuvuEJTo2V4LGs83DTDAioIYiWMIZ3BxSLP8+2S1pRkaT4+xmP77CtQ/K/bYmJdRnEuJEUbaDxg9oMS/MywrZyvZZ7DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's remove these helpers as they are unused now.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 30 ------------------------------
 mm/balloon_compaction.c            |  5 ++---
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 1452ea0635245..e5451cf1f6589 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -126,34 +126,4 @@ static inline void balloon_page_finalize(struct page *page)
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
 }
-
-/*
- * balloon_page_push - insert a page into a page list.
- * @head : pointer to list
- * @page : page to be added
- *
- * Caller must ensure the page is private and protect the list.
- */
-static inline void balloon_page_push(struct list_head *pages, struct page *page)
-{
-	list_add(&page->lru, pages);
-}
-
-/*
- * balloon_page_pop - remove a page from a page list.
- * @head : pointer to list
- * @page : page to be added
- *
- * Caller must ensure the page is private and protect the list.
- */
-static inline struct page *balloon_page_pop(struct list_head *pages)
-{
-	struct page *page = list_first_entry_or_null(pages, struct page, lru);
-
-	if (!page)
-		return NULL;
-
-	list_del(&page->lru);
-	return page;
-}
 #endif /* _LINUX_BALLOON_COMPACTION_H */
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index c44e0b62203cc..90b2d61a593b7 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -128,9 +128,8 @@ EXPORT_SYMBOL_GPL(balloon_page_alloc);
  * Drivers must call this function to properly enqueue a new allocated balloon
  * page before definitively removing the page from the guest system.
  *
- * Drivers must not call balloon_page_enqueue on pages that have been pushed to
- * a list with balloon_page_push before removing them with balloon_page_pop. To
- * enqueue a list of pages, use balloon_page_list_enqueue instead.
+ * Drivers must not enqueue pages while page->lru is still in
+ * use, and must not use page->lru until a page was unqueued again.
  */
 void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 			  struct page *page)
-- 
2.52.0


