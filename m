Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28E1CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F44B6B0088; Thu, 15 Oct 2026 02:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A52F6B008A; Thu, 15 Oct 2026 02:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB626B008C; Thu, 15 Oct 2026 02:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58E336B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:05:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C57E6A0943
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:05:54 +0000 (UTC)
X-FDA: 85323824628.12.C456321
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf03.hostedemail.com (Postfix) with ESMTP id D002420002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:05:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pz0W2hS8;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792044353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wlUCsxHXLWs7Wx8NC9uf7/dRKOPK2vFI+rUx2++PVFQ=;
	b=xwd0PKsNDgSN2pk2tYzFj0rc2SyDlOlX9dgckwMf+XhwHC24vpkryutDjo0zQDwNM2BjAm
	7ikJScvGuQEH0V651NMgOLNlcLFDo/wxaIwKyOZjNnJ9TWJ3orjBWs4yTRwHzdbsJQoAo/
	u6fvxA5bYbr+TYYhaOvu5zEm6pW0WtY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pz0W2hS8;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792044353;
	b=qtZgFMFkKZwYZ3rxCMgwsjjh0pyhSLlTob8yxL1aG5toe/8Mwf2Ov64hXgIdYNMl9lLc6K
	xzARiQJ80IQyEL7uT0zse13cHaRW176LN9NefHTo9uCn7/QUcCzC3wnQ6hO3z+6rA3iRPw
	FjN+Vj/ViiZTaFvmXBrEq9UqRymx0O4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J9GWURyfQ7XeSnnt8nEKld8twXqqnqqFys3Ywn2SEHA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792044351; v=1; x=1792649151;
 b=Pz0W2hS8nvDz6r86Qr/w+qtm5riCqsoqESyJsPaFus9zoNw+CgAnSk7n5m8ep39Jh+jsdncT
 YWmenbBflNTDiSYE/yaaCi/uImqzilKFr8ITPahrBBw9ooNnTR/MBavBkB2Czkz1GeaoGP877JQ
 Q7gMIlS6U63CV/fU/i6VOzaM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ded6eec12efd0d3e;
	Thu, 15 Oct 2026 06:05:51 +0000
X-Mizu-Trace-ID: ded6eec12efd0d3e
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio that left the swap cache
Date: Thu, 15 Oct 2026 14:05:27 +0800
Message-ID: <20261015060528.302634-1-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D002420002
X-Stat-Signature: 5dnefu3azg6bw1jxwmqr8c4egbn8t9np
X-HE-Tag: 1792044352-383370
X-HE-Meta: U2FsdGVkX1+Bz8b+G8sdhgCh7+6YQr8qMaBBOSPZacffug7C494Hmd8WDghFaoYyEEvwChhcR5zRHt/ck3MBuIbU6dWbg3jkFf6+xPPv1d/IotvZYrRh/FNNgSZW5EQzq+uHYn8m+IwmIu0xpnQ5XTZP1q68z94WaEW3tAVCt1X3Te354XVfQPt3tNajj/do4k3xkn+Si41/USkgSAK4uUZ0zMNh9pSxXTpyiMoxrhwzfKuLyWiVnI3/geMxjNyE/iWsubm5ENGXsegus5IVNIF5O2PkaLKE5BMcO4XOXKvcoblWOZXOVoE++/G4AS7FJzIP1uodzNG3BE2Rc1+X6JOzqeUdnfg5VmHV4/VBNxuN50v6BZ4/yN6lgh1rU26v3nF9KO0m4SFLtqr1c7aFhq7XFrnWV4vDSIttDkFDT/qp0FHELCC80/dO6pnA8iTakf8+u2dd6w79iWTTIUPgfyBw4gMUDOb/EZYjqiQn495Q8YKW+qrawUIF7zEzGqRjE8eZIK30TCffx0dJtAp8fi7AK1vy0OlMRggWzT1yGS/ntQ/G4ekNnW3vDsjs5/xLrWQjUjFLb1TVY9g1GqrEASRPdzxF3b4/C1f9NNtfdtVgTSLxrjS5Gen1Jm/IWb2SYbVHwO9GrPyblxTzjkCj+sB6vBFF1f9sWMASmJTbjgUiY6PlaGD3GziVeio9wuXMZEQVKAyRvCzuA3zlFSlrCRvp8xcm2KvledlkZjLwt1DphSyv1XK57ZEASBupkr/VSWOu9AvpJn1UmDTrG2uqZbiXIEzBFllFiZf2uyoQEAMpAXjc+8GnyWfdDlyhdy/8SaT9G7mYS3dnzYH2SaJsui/kTPXyk3d6lkzdf+akHCVMA92p7kLOWksh/KxSc2JcrJG0JzU0iKZrJWk+qjqT+wUGhM70kRNPkne2p0UJ1cFvN/66vWl3ejiL1a1EFmaM6A5403rllxJ7cSfwwMS
 eqRDY0hv
 j8cmWP8LHOdJGdg3WM6lSVvT+j4j2fs/f5Q9Em4XfWSxrB79VEPLfdlVHE8vUTFKitLh/OzqYH0A7f37YbWhQaOtkw5arKPbAZgdgOPA1QK+GTWWHCQh2SjeR5ioAN64Ef+veBjJzYhNasYUHJLz/lcF8dbSP/SG38nO2wtEY18hqy+TMXL4XvBCFtJomu0/d3wP8ND6o4pMn6ykNrKFzygmu5uaVdAKTmoriBym/qKEO1ddkgtrxyYs2JOKVEkwtkj9c/V6HykDHjwRf52tJrS2AOerxihOMnVc2i9tedA6dW/3q3I8nkVB4sDTaV0sR0oUEMJsZ/+XImHdWwgxxHNgTtNNvaU2GEVabMhaKxbdPNnb8Sj7DWnhJdzAZFJYviqot0XMUc9jSCSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

swap_cache_get_folio() reads the folio from the swap table and takes a
reference with folio_try_get(), without any lock. If the folio is
removed from the swap cache and freed in between, and its memory gets
reused, folio_try_get() still succeeds and we return a page that has
nothing to do with the swap entry:

  CPU 0                                  CPU 1
  do_swap_page()
    swap_cache_get_folio()
      swp_tb = swap_table_get()
      folio = swp_tb_to_folio(swp_tb)
                                         madvise(MADV_DONTNEED)
                                           zap_nonpresent_ptes()
                                             swap_put_entries_direct()
                                               swap_put_entries_cluster()
                                                 __try_to_reclaim_swap()
                                                   swap_cache_del_folio()
                                                   folio_put()   <- freed
                                         page reused, e.g. as an anon
                                         folio of another task
      folio_try_get(folio)               <- succeeds
      return folio
    swap_update_readahead()              <- may clear PG_readahead on it
    folio_lock_or_retry()                <- locks it
    folio_matches_swap_entry() fails, unlock and put

filemap_get_entry() does the same lockless lookup for the page cache,
and after folio_try_get() it rechecks the xarray, because the folio may
have been freed and reused in between. swap_cache_get_folio() lost
that recheck when the swap cache moved to the swap table.

So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
takes the folio lock of someone else's page, before
folio_matches_swap_entry() finds out the folio is not ours.

Recheck the slot after folio_try_get() and retry if it no longer holds
this folio.

Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
https://sashiko.dev/#/patchset/20261014090821.227366-1-jiayuan.chen@linux.dev
---
 mm/swap_state.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index ebef568cd62e..d9e36c505398 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -92,17 +92,27 @@ void show_swap_cache_info(void)
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
+	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
+	unsigned int ci_off = swp_cluster_offset(entry);
 	unsigned long swp_tb;
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-					swp_cluster_offset(entry));
+		swp_tb = swap_table_get(ci, ci_off);
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
-		if (likely(folio_try_get(folio)))
+		if (!folio_try_get(folio))
+			continue;
+		/*
+		 * The folio may have been freed and its memory reused before
+		 * we got the reference. Make sure it is still in the slot.
+		 */
+		swp_tb = swap_table_get(ci, ci_off);
+		if (likely(swp_tb_is_folio(swp_tb) &&
+			   swp_tb_to_folio(swp_tb) == folio))
 			return folio;
+		folio_put(folio);
 	}
 
 	return NULL;
-- 
2.43.0


