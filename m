Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53484D35697
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AEF6B00A7; Wed, 28 Jan 2026 04:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32F16B00A8; Wed, 28 Jan 2026 04:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E0C6B00A9; Wed, 28 Jan 2026 04:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 945A36B00A7
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:31:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30636B9CB3
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:15 +0000 (UTC)
X-FDA: 84380854110.08.D826E46
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 398E940015
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zb0j47ka;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592673; a=rsa-sha256;
	cv=none;
	b=23YxinhsqJy8jdYBLCfuYDlXw6Lei0WsEuhzbKTw9cqnHrOU4xDLrWZ5sMwrsqHc+yX1by
	4DLLh61OVfr9RrOjKO/TX7ODoSv/HNKOe41zAXhvNjt58O+jvo+CcX2l2Htb21z0SvYy6a
	WWvuAIKoIIUF1wuvqE7knT/w9K7Ox4I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zb0j47ka;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IO3x3MxqGRi8WhnUHEHqBelhkKQlEmUKW/aSZAplwzs=;
	b=XGdzFEr0Y/AvRuCqeo95j4PkKhU5gVOGv93vcQMZc09//JvEGU/aY1VMTvfFS87cDAzcsh
	WCQBTqNvaZ38YMWT95O27eOq3ZH1czEXhwIVu3tDtdZ314ilh/3obxNTL9WfqnTkn8/DFS
	GEVpGyuYhihdPzxRh9OU1lGfZ8u0/Ow=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-352e3d18fa7so4596548a91.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592672; x=1770197472; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IO3x3MxqGRi8WhnUHEHqBelhkKQlEmUKW/aSZAplwzs=;
        b=Zb0j47kaHejpOqZgArP8M18sA+sKOP3vNnvz+HbBQi8WuQ2MCTcjlhJgdEc/jZsjUh
         9xS+7/8BwNzUoOFHmplf+59uHdsF9vlIfP+j4NIX5zDqUNz2FGAzpzjT1s8e43xc/FZy
         1h5xeA4T+ajcc8MXghWifk5ncGmaqerxK98QtDi5GBKwtC7sNpZQGxF+nWAX386znIww
         ujCsuWvF9dxCuREvyJWWO2nVMEBMUs0LSeLoV/aWpVx0YzmytZys4okcy1u0FwsObiVv
         L8RKMheWg8iGqeqHDwVCTDeY93qeT7jvPB3WvAV+mZ2nus/ZKCD2CYSI8zqPsoxxhe49
         bGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592672; x=1770197472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IO3x3MxqGRi8WhnUHEHqBelhkKQlEmUKW/aSZAplwzs=;
        b=JzbadtGFJwvqnEw35WMNBeodx8V4KSIut7LiPewAIjmIwbeNduB8vV1dRYxEnbaWvR
         Pr9uTzPbdwkcbg3hR1DgJ1JFePqW81aAU8cgCGYysM0MiVK0+nWSj40DNVSrBhzYaHH6
         0CniccFRb/E8POvFWrFJdyYtJyE++KxEapDLNwxuaSHaV+PQOYuK++Vvno2V1eNMb+YB
         WWXbQBS1IjW/42XbLD2rtj2CldTF12uf/G0PV1G4aNpMNO4viwbg8QL/1AkcdmmtqkjF
         kn6F9FllZHKhWxYb6aa8tfknrcNwYYm0P1iqNZhi3YujvNTZQDZEt0IDP5qpbiGQiXLI
         XRwA==
X-Gm-Message-State: AOJu0Ywo99Kyi3aHTcHftWCpnQCVCp929rdUUE/JK1tzlkic3V0M2puY
	PaeK8DXZYQHz6ALMRN/sAg43Xp5cfkFbyBQq8CdIc1dSJy0Q/F/sTx9W
X-Gm-Gg: AZuq6aJD2oxk0T8k2BkdOjtSE2Cjan0NEEnhNKkeIkcuDc4FSQj40Ia8+zn/vAbwkuQ
	O00zu19cbE8gN2+H5qNCZTqrfucILsq5Rb01o1TUg71hRYl9EpT8p9VF8Jsj0E6vFyoASzfT83u
	/kNY2MZy43hbgU8TicXZQTIDmkEilP+F+dXGCMbpjIXoxNh5ltUVJChE7YjIQ4dyJ9+H1Vd2Ihj
	COTW95e+PA0mBTx/mb68djl1lYnaoHpzAwpUqYUV6TS8FhVYJv/TzxZFQ93FMFNmSBCRgc0980o
	9NDa+MQMJQZZnSBrG/WB0VWZcoybrxpFSIZJGyPIAiQtyncVNri1WEZ1VHxrQt9bMuY7DJQk7Rc
	cz/0P0lN7Cpg8tyG+henWrKu1dGLF5SpcE+4WcPgLoPbIdoK0OlnL+kzBSn+6+KULr8b/sC3il4
	wt4zn70LvcRgBty7BapmEBEIDB3bPw8eqr5zpcvvjjlE7jkWWPq7UoZGqMj376y8JqdPCO
X-Received: by 2002:a17:90b:3ccf:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-353fecd0906mr4046998a91.8.1769592672086;
        Wed, 28 Jan 2026 01:31:12 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:31:11 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:35 +0800
Subject: [PATCH v2 11/12] mm, swap: simplify checking if a folio is swapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-11-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=7000;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=JNIm9AZzdz6ohutIc0C0GEVsDBQSvtZ0ar1ajiaQqZM=;
 b=cXY2N0M4lgSWLTYK6dAshXYinNIZR/38U4M7MwXKjOqluHtDrbBrKH/NSmhj3jkwpLJCLsOkX
 rodLFRaLMbgDBVVA1L4Er5DEpZVqhzmWpkF+JV9PrCNB1OLiKTdJw7m
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 398E940015
X-Stat-Signature: byyorxz48uf36er7q1pnso9iikioywk5
X-HE-Tag: 1769592673-749751
X-HE-Meta: U2FsdGVkX1+6N2DsEDEJLMmXeBDqBmLZ41Di1orUDlHZK5efqtmHb5e5GaLss2mzblqZrZKbuYPge55UlTdCIKYCWgpfgnyf7UanNUB64HZ3zvjHt54lfnLX7a+QZ9QGw8tNhLTUfvhGCfUGyJkwQMcbXGqw9WRwWw/wMmdJxdGEPJOqFJu1Jx/arM/QDlIzQR1l0TUY31Jcf4vNLit2QHG7vQzISX1nmFqy/dVSxoUt+H21uV02t4e/OXb9MbIzaBJwZ+TiKEbsNW5BYEigXB6LYa8CcEhwSGK5zbel+79DcbHqPdoVrdgZsL02FU6lR0heHilWoKLmLhBIS1P5csGQii8TB9ai8/BEI7baDk03Feqz6NRzU7xvVon2ikQpjVqNDKBtJ0CL8RUt8qBeHjN7+z5ucXpORFxi5NzrwYgE2By1ddA0aNEMj2y+9s7pZZI1gHG8GH5JVXMo/oQguY0tQ6a+kjVZA1ctBE6gozkWX2xQ1MPsBgyrx6LYJqzdzadJhwxJt0d9gaQVqSP5TlhV8zmg1t2Z9zTIVQKP0YMzr8W/Ow7NwgMa4/x/B55+pIxH4uqSjmff/xWZLczTizktrMmwZlgoSekmqIIYOsWuL14N2iwwDJqxmsyEp1Jp+3v4eVY8jjh1Q8TpwRt396pSM5BgnzJyV/f51t3VtQw1qP9o1xvrPpVdZFZIWa37DKGA91W3MprVIM0RYhYHg6NtY4M3jHcb0Ect3aJugjvKyEx1XlRIofIOInAENkJcoaEU/ptLUgLsMoQbEXv+NOf83zhuiqdRM8Evp7xPCn6NRAANxYnBE/Pcu37g+C//CS2VJ/EjqGf5xbn4s30SRxGNxa9Lc5MQQr/bXmcuSofIQzuGR+nkmiNLbdtMG9Qyt8NSekGigHUM6+8XbWpZrZVuhlU5fu6ennHuP7z8vjaJfkKxFIKBCNff2L/LuUTor8g4fNKCuNPiw4p0wEt
 FKSRxMdS
 jsh2ye0RrPNQaJvzJ3Bzjo9IdRazZJlo96bKcxZLVi5Ix/9gm8urG88ITR0o+et05EJOxZP/SoAQfDzry5in2zwmru7BPrJYlkhVEJ/SbSjQQWCulO28XNMbwhDzQkyDCvoV4wybkw4vGK0WXpeaFqUN+oZ3LkAMIIanpMxuEbLvPvr3m9TakNRSZyqyf3wreDM1tZcw0gGKl8r8g1B8xZajQuQDNMSshn8+zKls4+I2NCoYU4+B/6Z1MksmNcBIit1BbKsIHKkF6ktUTNccBzWcggIkiqBaVFzBnmKm5es+VsM4Ix99LgnQNYiHexe3zWbQkMfcSoMegNxX+CP/ff0kcvaef9uCLHJGlXMGPvz3jzoFMJaxrDWLvorScwopNMWVXkJmQcn2mVX6wUmvlMAUpdZ2gy8Ha8rZlcPu2WvfD3Y9A8GU0J2QKtg==
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
 mm/swapfile.c | 82 ++++++++++++++++++++++++++++++++---------------------------
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
index a7fc8837eb74..f5474ddbba36 100644
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


