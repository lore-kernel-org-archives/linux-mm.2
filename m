Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC554CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129EE8E001D; Fri,  5 Sep 2025 15:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA468E0001; Fri,  5 Sep 2025 15:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0BEF8E001D; Fri,  5 Sep 2025 15:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC2AF8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83EBA13A7A3
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:40 +0000 (UTC)
X-FDA: 83856148320.06.44B1D91
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 857C9180007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LvdKrl3w;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099678;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcBRC1dfTG2s+aFL1L7sgVVmaFlNWBkL9Ua/k3R9Js8=;
	b=Tb3RmK+WsR+f9nLz/pccGLUMKLgjjc/fscKi9vynl77KZD955axir7oBwDD+CS+yU7P933
	thGWIE7K3rP1rcif4HzCLHI8J/xx54zgEcDMu5e5ZyJIZR1x4AJ/M6oZ2c/wFiEQPkBm3s
	kc0l1VM6DCyGpN/02C4gbsbmaaH9kxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099678; a=rsa-sha256;
	cv=none;
	b=FAzBNbmmk+pMLgey7SghOb9YZmKifq95NLrPiKa2aiehSFKHkBrkhFRKm6DAYY18C4Dw3L
	mNDSf/pVdVrV2/J13lvdhvBDD8xo3WsDRxKwgqayIvvio5lQf4kS4mje7/NwuyDUQPV0kw
	5NJqPljdN5buGIMWtdWY0uxkwqIdEQE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LvdKrl3w;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4c3d8bd21eso1523497a12.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099677; x=1757704477; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qcBRC1dfTG2s+aFL1L7sgVVmaFlNWBkL9Ua/k3R9Js8=;
        b=LvdKrl3w+3tv2SXmY7SivhWD0OLK7WEvrsJUR1M97CnrgLtbpwlBOUlyJOxlKm1Jqx
         aeFvPPz5PS45Sw9dFz7u62mGZ8a44L6m5sr0nNOhAUsn6F+DhfI9vON3JQkycobxONMp
         zg1y3BO0u0HZ8ihef+b7JmMp5uGMInM1k3l0UU8SldwOqdhoKt/+BpeLOMCWfUPN+LUq
         DNlk9r6VuIAGcy/9cRGfZ00PYKDz2eqTcwW5rKN2yzYRFu5FQ2IKuSWyTu0LTtGkd6AO
         y/6OwfbL4adr0h87oZxCh4fiq3zcuS3HYmAb3flG/6qfp38ZhjSvdnGR1vXTsYA8C6e5
         eC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099677; x=1757704477;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qcBRC1dfTG2s+aFL1L7sgVVmaFlNWBkL9Ua/k3R9Js8=;
        b=b9hTxHKqIbScUvdKRfWmy8eYW/Ti7eBrqkBA4BlzrVniQWZU03n9gHEE2VTCm9D47M
         1Dx4xsh+SCMMIAnGCb0vIznc6vXbXUFef3C6MnIpPLmxIZP3ymlAn0SeBGevpFpLN5qW
         ZMiZo7JB9+ot8y2ZC/OdGp7l3bB7awS8ON6uGBXv8FNeuCEX8tx4DppJ7VAZqpk1Yceh
         oslHFHHSGOHl2wmb5+gIf5h6xt4tMCzq23lKe8XvMfjtgOxfg3qSRYiHN4+/osKuqNum
         g4ejaweCBTH+E0L6MK0iyK/vFFV66kkbynbPUSaxv/3QVJfzsgX2eynqL/89YAQEf/EM
         ZNQQ==
X-Gm-Message-State: AOJu0YxTQswhry/XkpNzTTGsYyymSizkWSEWz85L12er42k9gcRn2ioy
	8UPCN8udZTKhKUfS1/whF43BJrL6fEE2f1kmEteWbgaVWwJU4G/FPoUrdPOhSKZKBLQ=
X-Gm-Gg: ASbGnctr3s1jEeuJLzOEueGcSGFOecWfUya139goLoPDIms2jH7wsV0+cOhtpjXfkAF
	wx64l995R90tGHxpApB47IfUfCRB5Vq5O+rkN8F5pQLyS3OnVUz+/6qIrATuuUmD+TRUIQ35pOg
	7vk7FlC8Of5xCTdu6u2kmkPstzc/a3Rz7EoMaZ3+NydGvIJ7outD+SCZZU/qdrcmrIbq1SQKs6d
	RYsmMvYKxMzP3TNftNQcmCbwlHFoo9jVTwUfWPqrGR/2LqL1woi9kA+KmSULnmNaWdAPFCBfmOO
	wDaABLN6/Uuo154nUXLDRv7Ai7sk/92c+VjmRdXQt3usm1hl8QNOj1iqD+olW8MJiaSBeBjIfea
	MxzfyASxe9QtzGGpvjl/YvEgmi1FXJrGqlS+XUbfALghal+8=
X-Google-Smtp-Source: AGHT+IH0gGzdjlZMueDj/hSEJuQyIDnEEPfDmDuK23QnXLBRkJurBKBb+WQfJlSWK4T1Xzn33MtTuA==
X-Received: by 2002:a17:90b:51c4:b0:32b:98a3:7409 with SMTP id 98e67ed59e1d1-32b98a37612mr8823618a91.34.1757099676730;
        Fri, 05 Sep 2025 12:14:36 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:36 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 05/15] mm, swap: always lock and check the swap cache folio before use
Date: Sat,  6 Sep 2025 03:13:47 +0800
Message-ID: <20250905191357.78298-6-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 857C9180007
X-Stat-Signature: opfyn15sd9h8hh6w3o3fqzx6soakx5tt
X-Rspam-User: 
X-HE-Tag: 1757099678-901629
X-HE-Meta: U2FsdGVkX1+qg1ejJt9BSTjDL2cQL6YvneGqZ9rx/2jCm7lrVpiRVr2Y1BF0HMSRxTc4NFaeyU8YHipNLz+fnvDhggSc+HGVLy+IV3FAhJuqaeslhsmglIEQZfihfpMPiH9mzeNaRekbZwIJhgUnRbZu2cLM4bLj0JWVcStp4Vcoy5h/gEBgA/2xA/zxaWF/s5ozEIBSGFArtSjxQKktIoo8qjW5Err6Z0zUI0nFMvRwbeh1oZeucvB/3ZnUS0BWNRg4orcgkp6AulZY5l9T/AI4wV1UfzA7eSN2F19jHWiNWrC+IZplExRfSB74uiZAJT3ilb6AG9dOyaG1NzAvFD4xcxILot203hlEW32nnk+E+swLqCCymHyn1iWdQ8Ql5b3dF1yfQbSmcfepqF3BJjdx1AYjOkgfky2utdOBD4xz1xaq6EK1MtXIZhhKWIUJ1a9OwG+rvlm5lNIxcfCOykKvAZKdOU6tSi4RjC5o9TpJQkHTYeESacAEvk0Bomn3GqvU7H66rtthjBCbGRC34t+DpB9zax44Z5h/RWgImNUzK5EqzHEnvQzIV5SA6qK01l0yaCnNMf47wD3jqi1LSr5gdzkQUlwuE2hiK2LEOWgCGXsO/OQU+XNn+ckKTiPUU03g7NVY71qhd1jPiMI3P7uUNUxnCPt7fXZrb9KnuVeETUUyMBSmhlW2FGdd0koY+By7LTebjvJAA6tEp3piGf5kJqY0jwQRsTjRV+pZnjxfDHY4uowCKUYVzRBNllSlbK+3+nVng4aRWmkSt4paTybWVokWIN0xeYVLxOZTV5fFiwovLNFJhEd+OSzFLe5HjG7r7wwoaFLkXrXheQewAapz07618RoIDOPAkFVAuVXijB4CqZVGmx5P7l6rNDzcVdS2mJMcyIYf59n8mq8Sez2fgZwx12DW3up1Uks77p1ckCeNCJUq4dql8fL1WXbKS1cg75kBvfewE7jgLgA
 FAy4rA59
 3cc47tQdqMCDuvdQ68v0cgdpeA9yfn4d9HzJOjHv/S0+hh5bjEbqz5jtvrN4VeP6x6homqDecV+4s8qevfC6BYjXGQe+t0ucCvPnhLonfy1gJkL89/Ht3St3BEzuZFcNpnLhTuPC1AWNTYU064UUFLo+Y/o8gQ2PKJpnbLR8FKEkMo7gp6uGSRPEYVd2lUEs3IQPiSEYolwWxInDXIt4f2AgUquXXvfMX8jvgin06io2pnTuQowQSBettN/JcIGqYl6QVDkNB7P9xI9rcUhiNCewjagK348AOj27eUlUWGtLiWtYX1MvHXsv74YBhzQXtxa2+6VfUk0f2DMuByY669bsThPiY4dUPXItp+KwoLUcfAfVT4XT22pVvlufqcPVOsh0p7gnU6GOODuMJuqG8g0fKS/hbhev0ZU4/W7kWoRjSEMAs1iQRDUqRIUEz/SoX6UG1ReSFmntmlRnKya7/v4b/vRKSFxG9LBdT4KkGLSzdul4sN/hi88CCr5QyySQwE4oDRrunlWUfL9TltXEk/F73Qx0m1/r0nzl5dCvew/3Bhv4uJz2EZXJ3DHLfKmW8t2OI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cache lookup only increases the reference count of the returned
folio. That's not enough to ensure a folio is stable in the swap
cache, so the folio could be removed from the swap cache at any
time. The caller should always lock and check the folio before using it.

We have just documented this in kerneldoc, now introduce a helper for swap
cache folio verification with proper sanity checks.

Also, sanitize a few current users to use this convention and the new
helper for easier debugging. They were not having observable problems
yet, only trivial issues like wasted CPU cycles on swapoff or
reclaiming. They would fail in some other way, but it is still better to
always follow this convention to make things robust and make later
commits easier to do.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c     |  3 +--
 mm/swap.h       | 24 ++++++++++++++++++++++++
 mm/swap_state.c |  7 +++++--
 mm/swapfile.c   | 10 +++++++---
 4 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 94a5928e8ace..5808c4ef21b3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4748,8 +4748,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		 * swapcache, we need to check that the page's swap has not
 		 * changed.
 		 */
-		if (unlikely(!folio_test_swapcache(folio) ||
-			     page_swap_entry(page).val != entry.val))
+		if (unlikely(!folio_matches_swap_entry(folio, entry)))
 			goto out_page;
 
 		if (unlikely(PageHWPoison(page))) {
diff --git a/mm/swap.h b/mm/swap.h
index efb6d7ff9f30..a69e18b12b45 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -52,6 +52,25 @@ static inline pgoff_t swap_cache_index(swp_entry_t entry)
 	return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
 }
 
+/**
+ * folio_matches_swap_entry - Check if a folio matches a given swap entry.
+ * @folio: The folio.
+ * @entry: The swap entry to check against.
+ *
+ * Context: The caller should have the folio locked to ensure it's stable
+ * and nothing will move it in or out of the swap cache.
+ * Return: true or false.
+ */
+static inline bool folio_matches_swap_entry(const struct folio *folio,
+					    swp_entry_t entry)
+{
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	if (!folio_test_swapcache(folio))
+		return false;
+	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, folio_nr_pages(folio)), folio);
+	return folio->swap.val == round_down(entry.val, folio_nr_pages(folio));
+}
+
 void show_swap_cache_info(void);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
@@ -144,6 +163,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t entry)
 	return 0;
 }
 
+static inline bool folio_matches_swap_entry(const struct folio *folio, swp_entry_t entry)
+{
+	return false;
+}
+
 static inline void show_swap_cache_info(void)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 68ec531d0f2b..9225d6b695ad 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -79,7 +79,7 @@ void show_swap_cache_info(void)
  * with reference count or locks.
  * Return: Returns the found folio on success, NULL otherwise. The caller
  * must lock and check if the folio still matches the swap entry before
- * use.
+ * use (e.g. with folio_matches_swap_entry).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
@@ -346,7 +346,10 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	for (;;) {
 		int err;
 
-		/* Check the swap cache in case the folio is already there */
+		/*
+		 * Check the swap cache first, if a cached folio is found,
+		 * return it unlocked. The caller will lock and check it.
+		 */
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			goto got_folio;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4c63fc62f4cb..1bd90f17440f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -240,14 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	if (offset < swp_offset(folio->swap) ||
-	    offset >= swp_offset(folio->swap) + nr_pages) {
+	if (!folio_matches_swap_entry(folio, entry)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
 	offset = swp_offset(folio->swap);
-
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
 			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
@@ -2150,6 +2148,12 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		}
 
 		folio_lock(folio);
+		if (!folio_matches_swap_entry(folio, entry)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			continue;
+		}
+
 		folio_wait_writeback(folio);
 		ret = unuse_pte(vma, pmd, addr, entry, folio);
 		if (ret < 0) {
-- 
2.51.0


