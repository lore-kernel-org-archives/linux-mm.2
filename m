Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A132EF586D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 10:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137176B0005; Sun, 15 Feb 2026 05:38:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA916B0088; Sun, 15 Feb 2026 05:38:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1B36B008A; Sun, 15 Feb 2026 05:38:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF85D6B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 05:38:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADB5EBC441
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:38:40 +0000 (UTC)
X-FDA: 84446342400.25.B57D8E1
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf05.hostedemail.com (Postfix) with ESMTP id D3F34100009
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:38:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CGrC+WjP;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771151918;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xfddMpTBkv4yU1TaSitiYJz3pzQM97yNutklwj4FDs=;
	b=CP3API6y63EJn+KEN09EUQhANeLccNWMs9b74tiQmhFIrVyA9Vj3xSg2AhChLkKuxl5Y4Q
	BMRqRR10TZnpHjlzDfzqciXrTQNQVnJlfyuTbXegPE3qDt54NIQ6kttgNPrCoRUDLzyKkY
	kim1/TAfpKgBl5my4xQii6GWUgWlwtk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CGrC+WjP;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771151918; a=rsa-sha256;
	cv=none;
	b=E6GoY8yb/KLMfMhABCvf+yCrffnmhO4rDF1i0apy14rS+nykE5NgFx6ezWRAVXVH5nX8lY
	TM//sF9eQOl2BMvSPLNn5wVWZ1zx2+n+pWM8VY0Fi7W6dresUG0x4EOg34J0Lnyu/hIUlK
	mg9zbI+VDkoBUEaU1gtyTVR5USW6hMo=
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-824484dba4dso2078533b3a.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 02:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771151917; x=1771756717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9xfddMpTBkv4yU1TaSitiYJz3pzQM97yNutklwj4FDs=;
        b=CGrC+WjP2qD4ksNAPFcm8i67FhvHgmFBXNTbRHxiuurTiWlRPf0YlSc+pEaBZjYZiW
         4hGAaN5VGNaylf7yykV2xYKTvB/lQzwKSQIDgqoGSrRH0I0c8o4uXmukn2ui8bggXp6b
         3fGo+Gchgh+kAEN/MYt41y7N2FkVhBz+wQC61YzmvMbe3afhZ/+fmGKi7BnVYl5wtL/m
         UAX+Q25AqLafMmHLs8QifvlN7Q7Z9zZok5uWKci4zg17cQdPqdSLr56mUeTmMafpMdkq
         SrlXPBvCtIH50P/uxR9mwIXGDovutwglZA//Z0bdINU6tABRpaLqM7M9XNjawDE3gh+S
         0i/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771151917; x=1771756717;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xfddMpTBkv4yU1TaSitiYJz3pzQM97yNutklwj4FDs=;
        b=kkX/aIQUxgutXbpSa9i7XA9v4nnjB6+ux6BynF6yP0X39fG4QW6A2Rvp2f9QrcuGWG
         L1yiHKmuBHFBVcfBw97E5oogAAdjTHF1+OS8XAlqwk/U7AqRI+CYtfDtLJM3PJBStXrA
         MWBDHZ3aLcPFL1KL0GZOTx/BHjK4IN01mofpfjnZdfEVYLwI2z71A+p5N+P/zf2BJ7ev
         mQcUDi4f3skgpJgfYDLjVKwK1CPLLsZK9PxctEN55/uR0T0+MlwG20Dx6iNhB0gqEJtr
         mMPHfd6pxfop867sq8WT8HlhAgFGZDQkOxEbaM4qJcZvAw2OQWzxOtIKG1SGI7eAsPcK
         +qNQ==
X-Gm-Message-State: AOJu0YwAHNinA1/53OZ0s0ZbtNm28Lun1TBtF63ZJ1liU/MZoWYHJqI4
	0lcNPxhPL26x6qInuz1e8zuqTnAaitaFXp/tgRnSP9riZrvv99ZKTZlm3hlaxlVEELv8Ig==
X-Gm-Gg: AZuq6aJdh++cV3XNrx/2lCtRGGW1XqeJeWDyDMvvmbDu2BsPhzNlTUxqoB2k9Z40Lqz
	BayukTBSn0/xXTiWiGuE2xcG11PsXwXtoGuo5mi9mdPUQmtvdWmb6PezvrqqjTUAEnFkGJnw1sQ
	IVk8W5BwVq8PlGI2kIaiFzP6VNNz4bbeUGUxzW1LJ88EktbUJ1TgwzLxdOIhGy+vGAOKFjARNgK
	FaJ7HGEUKOLjtgWmTJZ4pxsG6JJR8OCV38LKXrncuJvFCLRwnXOWDvXUWxU75mAGv2lMR6vm1v5
	/MDNz0gwj1xQaVd/q5jmQD1MyGPe1M6iW4Ap26VgQ1ODMZF0AOyR7MufiN5pNuamg3DWGewJqvR
	xUQpu3BOvSSjS/ct8e6vBadeWhKZ30EHGLxLEQICVrmkqKFDwgT6kRXffwUOvggeNzb6fzciqBF
	lEOxh64WAJR+Kkg/LzqNTszyNkw/L0pcQZT1TxvHWBr0J2g9cF2d0gwUz0LOP+4wN/+xVsA9ITX
	qg=
X-Received: by 2002:a05:6a00:3699:b0:81f:eb35:69ef with SMTP id d2e1a72fcca58-824c95be066mr7117872b3a.40.1771151917075;
        Sun, 15 Feb 2026 02:38:37 -0800 (PST)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6bb5acesm8165660b3a.63.2026.02.15.02.38.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 15 Feb 2026 02:38:36 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Carsten Grohmann <carstengrohmann@gmx.de>,
	linux-kernel@vger.kernel.org,
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 1/2] mm, swap: simplify checking if a folio is swapped
Date: Sun, 15 Feb 2026 18:38:14 +0800
Message-ID: <20260215103815.87329-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com>
References: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3F34100009
X-Stat-Signature: awrciq943w5bbqy8kyejw9nqw1rzcnet
X-Rspam-User: 
X-HE-Tag: 1771151918-683582
X-HE-Meta: U2FsdGVkX1/quZZvnXjua7wfVqxLe6tWGIIc0I6FoVIh8DeZiVow+YKspyDBDwNPG3rI8X5bfNyYe60llpK+7JV1q7BICvbV7ygGh/G8MjROA9MFVoNeSVu5yhYNgh749DUHK8Hmu5bDE9EmjBEubCMrtTvTXZsGE5lzxR0wOY9yfGwnwsOL9wvSjErLLgbudDBDfjH5khHXRSCIrec7XI2nsD5nmDERBKziTR45wrWk8kqRMQ10AU+UuT8p7o8eY8/m2SR8genwJbhj5zLebv0NXPImhvxiAP0dw2CmwLZFayHsz8NmZdkLBiSqpSA4Ths9FlB2PE0IEihjw94mkxu4u9+AzbwbVVfp+atrUS9NSZmPTsovcasHYC5J/HAnB6ieAQCF93lRiVAhdujLH9EbEHBAQMBjgbcBaMrRVRg5dRDAMf/kLs3OTrePcgT7zqloF0Q86aIrdRgmKKeOfgzlwHp7aHDdl8yCuo1LanUla6HbQuT1VyEIWynsbuO9+szVLc1rbxtSfPCqAC76foZ4AB6E9dlDS43D3WKom+sGsP1mBppI1eoQ9pMTXLYRIhNXOPTirFkpXnEg9UftVZtwftacopgG4/2846R8M+eFWLaBYvBAMbX0zymJi5yID6P1k92pKyXgsxrYGOSZBKxZVItJwUvjDnkN6fW6O32nGYIR+0ZwOJ1T+9UhtEDAG5Pu24ObSqBQ6IryhI3rtweGDsE9EvqHAvrUofH/JnhHpZ+fs9AN/M2iqk9r2a3Oq7h+wqRSmC11nTxGvhgJayX/Cu5MBCUAyYFGY8IqXpp+w+oDGhVYiRWMGceMRlmmbgaF/jSnrEvYkFLiE27+E1fTfW2sZW3nzSCaQZhErwHm65pA4uFx9qUXR2hyknfSQNy4mAOcHhQFik1q3yr5diP5UUoxlj6kFK2D45jUn1p68x9N7gWMmJq40i9UrIykn4fX1k1X1xCZH04rBjr
 m7aCOyJY
 wgwOeo8MWYAzi8fUzKbTwKWtsI81XH/FJfmXG2jv7Hc98BbtdB10+sc1PrVstzcPi8MAwbkCZMsxIOJNStcytgUMEmVjxyjAMkibhOCzus+j3KgSsNdAWAfCBkzzMmLoBrKftMvL3M4StLisYZQ7WiPgktWsNp//dIMk9rRmNcEo4tFebrfOCKU17tgGnSTeAo6iJhj/cpaChKTqqGUaovmOxK+Av9IF581ex4sjI9NfssWDrWQvLyMhrL0VQPe06De5MssVqN8fn77jaToiibJASr5U0a1uUBLIKS6xVimi6Jkg5WENyEygasaegknJn0mJRwFw3eUngI2sZmHDWHrw0sc1t4qc530BYLhL8DtCqSWGD4uVVXZT3VWEvYRiJ9GlQazPNoLpcZ8kUz1hefh3MoU8EI45WHuANeTFP6iIXpqHBHyF1MpKOyQbYFqmCnbZdGdJiBmHCs2cWu7DDTLHff5eUmmCfMm3whGasfchg5/c47htf/vNoRWr+K9reLjqzuQVn4rONt3g1XgzCtuCXeQ6oVU9JDW4BM4eJ3AEkZpWIwWiEBx/cDEU89XmgWttJuLZlv6A7WMD6VlZr8MlTIXBMGN8mCOvX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Clean up and simplify how we check if a folio is swapped. The helper
already requires the folio to be in swap cache and locked. That's enough
to pin the swap cluster from being freed, so there is no need to lock
anything else to avoid UAF.

And besides, we have cleaned up and defined the swap operation to be
mostly folio based, and now the only place a folio will have any of its
swap slots' count increased from 0 to 1 is folio_dup_swap, which also
requires the folio lock. So as we are holding the folio lock here, a
folio can't change its swap status from not swapped (all swap slots have
a count of 0) to swapped (any slot has a swap count larger than 0).

So there won't be any false negatives of this helper if we simply depend
on the folio lock to stabilize the cluster.

We are only using this helper to determine if we can and should release
the swap cache. So false positives are completely harmless, and also
already exist before. Depending on the timing, previously, it's also
possible that a racing thread releases the swap count right after
releasing the ci lock and before this helper returns. In any case, the
worst that could happen is we leave a clean swap cache. It will still be
reclaimed when under pressure just fine.

So, in conclusion, we can simplify and make the check much simpler and
lockless. Also, rename it to folio_maybe_swapped to reflect the design.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h     |  5 ++--
 mm/swapfile.c | 82 ++++++++++++++++++++++++++++-----------------------
 2 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 9fc5fecdcfdf..3ee761ee8348 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -195,12 +195,13 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  *
  * folio_alloc_swap(): the entry point for a folio to be swapped
  * out. It allocates swap slots and pins the slots with swap cache.
- * The slots start with a swap count of zero.
+ * The slots start with a swap count of zero. The slots are pinned
+ * by swap cache reference which doesn't contribute to swap count.
  *
  * folio_dup_swap(): increases the swap count of a folio, usually
  * during it gets unmapped and a swap entry is installed to replace
  * it (e.g., swap entry in page table). A swap slot with swap
- * count == 0 should only be increasd by this helper.
+ * count == 0 can only be increased by this helper.
  *
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9628015fd8cf..cb18960a6089 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1743,7 +1743,11 @@ int folio_alloc_swap(struct folio *folio)
  * @subpage: if not NULL, only increase the swap count of this subpage.
  *
  * Typically called when the folio is unmapped and have its swap entry to
- * take its palce.
+ * take its place: Swap entries allocated to a folio has count == 0 and pinned
+ * by swap cache. The swap cache pin doesn't increase the swap count. This
+ * helper sets the initial count == 1 and increases the count as the folio is
+ * unmapped and swap entries referencing the slots are generated to replace
+ * the folio.
  *
  * Context: Caller must ensure the folio is locked and in the swap cache.
  * NOTE: The caller also has to ensure there is no raced call to
@@ -1944,49 +1948,44 @@ int swp_swapcount(swp_entry_t entry)
 	return count < 0 ? 0 : count;
 }
 
-static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
-					 swp_entry_t entry, int order)
+/*
+ * folio_maybe_swapped - Test if a folio covers any swap slot with count > 0.
+ *
+ * Check if a folio is swapped. Holding the folio lock ensures the folio won't
+ * go from not-swapped to swapped because the initial swap count increment can
+ * only be done by folio_dup_swap, which also locks the folio. But a concurrent
+ * decrease of swap count is possible through swap_put_entries_direct, so this
+ * may return a false positive.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
+ */
+static bool folio_maybe_swapped(struct folio *folio)
 {
+	swp_entry_t entry = folio->swap;
 	struct swap_cluster_info *ci;
-	unsigned int nr_pages = 1 << order;
-	unsigned long roffset = swp_offset(entry);
-	unsigned long offset = round_down(roffset, nr_pages);
-	unsigned int ci_off;
-	int i;
+	unsigned int ci_off, ci_end;
 	bool ret = false;
 
-	ci = swap_cluster_lock(si, offset);
-	if (nr_pages == 1) {
-		ci_off = roffset % SWAPFILE_CLUSTER;
-		if (swp_tb_get_count(__swap_table_get(ci, ci_off)))
-			ret = true;
-		goto unlock_out;
-	}
-	for (i = 0; i < nr_pages; i++) {
-		ci_off = (offset + i) % SWAPFILE_CLUSTER;
-		if (swp_tb_get_count(__swap_table_get(ci, ci_off))) {
-			ret = true;
-			break;
-		}
-	}
-unlock_out:
-	swap_cluster_unlock(ci);
-	return ret;
-}
-
-static bool folio_swapped(struct folio *folio)
-{
-	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si;
-
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
-	si = __swap_entry_to_info(entry);
-	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return swap_entry_swapped(si, entry);
+	ci = __swap_entry_to_cluster(entry);
+	ci_off = swp_cluster_offset(entry);
+	ci_end = ci_off + folio_nr_pages(folio);
+	/*
+	 * Extra locking not needed, folio lock ensures its swap entries
+	 * won't be released, the backing data won't be gone either.
+	 */
+	rcu_read_lock();
+	do {
+		if (__swp_tb_get_count(__swap_table_get(ci, ci_off))) {
+			ret = true;
+			break;
+		}
+	} while (++ci_off < ci_end);
+	rcu_read_unlock();
 
-	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
+	return ret;
 }
 
 static bool folio_swapcache_freeable(struct folio *folio)
@@ -2032,7 +2031,7 @@ bool folio_free_swap(struct folio *folio)
 {
 	if (!folio_swapcache_freeable(folio))
 		return false;
-	if (folio_swapped(folio))
+	if (folio_maybe_swapped(folio))
 		return false;
 
 	swap_cache_del_folio(folio);
@@ -3710,6 +3709,8 @@ void si_swapinfo(struct sysinfo *val)
  *
  * Context: Caller must ensure there is no race condition on the reference
  * owner. e.g., locking the PTL of a PTE containing the entry being increased.
+ * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
+ * be used.
  */
 int swap_dup_entry_direct(swp_entry_t entry)
 {
@@ -3721,6 +3722,13 @@ int swap_dup_entry_direct(swp_entry_t entry)
 		return -EINVAL;
 	}
 
+	/*
+	 * The caller must be increasing the swap count from a direct
+	 * reference of the swap slot (e.g. a swap entry in page table).
+	 * So the swap count must be >= 1.
+	 */
+	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
+
 	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
 }
 
-- 
2.52.0


