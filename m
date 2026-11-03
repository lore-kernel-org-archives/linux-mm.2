Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732D3606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Na2RL3bf
Received: by kanga.kvack.org (Postfix)
	id 8DA396B00EF; Tue,  3 Nov 2026 15:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B5B6B05B1; Tue,  3 Nov 2026 15:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779D86B05B2; Tue,  3 Nov 2026 15:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C79D6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:12:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2C721604DC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:12:22 +0000 (UTC)
X-FDA: 85394904924.20.6A40547
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4F62180007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:12:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Na2RL3bf;
	spf=pass (imf24.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793736740;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LPXZxchUm5nge0v3DQkOxszRXEJTkRZa1rt6rKMK+JM=;
	b=t4TL4xnTFyiJaW+4bHwd4dSKIQQVanJJ4io5JiSOATvzCacrbE+xrSZRDbLiomXu4a9Qut
	5IWdYfjn/gu8/pUez7R7CNs7/KFoA7+SlohZl2EextFG5ctszyh85rcKZq5+bQibBt1mIg
	wPfFW3YKXZly9/PXDRZzZs0D5/GuDI8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793736740;
	b=2Dx9nI5wqVHD0n80/IrbGe1vGzwJfbt6xbArzfRd8IDmboIr6w1uh/wPSI2BjxElyNnrVO
	Ofu7xaUpJucqKHjhV8BhdAgutteOfdQ8W29pwXPFvBELFR2qqqEkKyz7fTgnFpxBrN6H/d
	xbbTMnA8WKLizniarjYrszT+tFp10G8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Na2RL3bf;
	spf=pass (imf24.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B25AE438DA;
	Tue,  3 Nov 2026 20:12:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793736739;
	b=ji4EYdjdTE8+f8dbQZfpPxgBBx1R6YgWnzSvsCmtyCBmOEEj0b197tajcWgnBluHxsGB
	 8fpibcEeB/j62bqRbzHMY35TWPEVomuH+cEc93RJY9GwvkjDCikT2yEKrJRh/Iqg3rrLW
	 +tXmhQoS5QJPv0VRjRRp+6jNE5GPUT0gQjnBn2cm09CeWfW2JlCCPCvaTMaDfKl8Ir7mj
	 w3cSaBcpJWItxY2WEujD1fV5tht8RQygGKGpnk4CsjWhmvTH6phURP5SLpHix6rgXnV/f
	 Lpsooi25DysPxElKabQELqlbL3c6KPS5U5/efrr+CmPhegPRJiFk+Al+vGYOcvleqzw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793736739;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=LPXZxchUm5nge0v3DQkOxszRXEJTkRZa1rt6rKMK+JM=;
	b=cmb0421mg3bmxy0sI04fFms24rqe3RUN8J+7rPYXRMufUPAq1z2NIPP7+ecKUX3SQucZ
	 GFDo7xRLyUXwZQl01QBXZKOgfvxf4zkQk/7CdFjuwKDFDVyMRZaDyfmNTaFka2gRH6Eyu
	 ZPqBGKN/oyARa8pCnI5qgCufXQGYSj5KL1yJ/PMQWnCRFuzLiHCcHbtsctOIqm3ntG91f
	 Yw5gTpuXy1lm+NMg3weOA/cMZ+Bt/hc/e3E3TZv1aQhX9LQJLaNxdaPitcxDmsuKLJH/v
	 S7+XaL7pppO/2kmReD73bXtgpGgpJSMNtlITji2064wIvU/NoAf7JsuAk3wdNTKgeFw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EEEA71F00919;
	Tue,  3 Nov 2026 20:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793736739;
	bh=LPXZxchUm5nge0v3DQkOxszRXEJTkRZa1rt6rKMK+JM=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Na2RL3bfb20YvrgQB4657VuEeiqj/7j8/u9JoQCyvNC5wApVFkuuxS7VJNf+r4J9l
	 eR73dDXBvo3g3ve3mn2jOcFZHZCaFzbpQmHx7Slyg59LPgncZ609yJm5h5hX25vzAb
	 EKJwpr/T9FJnEgDWcS5eRzlw40wotBdjpyYuHjRsjKa2Mw7tDRqUSli2HjQiSqONZN
	 gnHd/NqafuK5iRx4NDRrO7HO5EN7pgLwZAfiUr7cyWvm8iLM7GdAprxHzgyYkjHBNn
	 i+mBvyT1ks02kpqfhqUzoyqwDq6ATtxVPk3YiZCysA71VFve35vyj7Cjj50/g6clxw
	 /gqf6qiQPem3Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6F87246AF9;
	Tue,  3 Nov 2026 20:12:18 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 03 Nov 2026 15:12:18 -0500
Subject: [PATCH v2] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-swapin-large-unmapped-v2-1-87c70e597250@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNTQ6CMBBGr0JmbQ0FUtEV9zAsSjvIGChNS1FDu
 LstHsDly/fzNvDoCD3csg0cruRpNhGKUwZqkOaBjHRkKPJC8LzMmX9JS4aN0sUsmElai5oJVfc
 CxZXXooK4tQ57eh+/9/bHPnRPVEs6S42B/DK7zyFeeer9c6yccVZxrCSWlxqFatQ8hqkjeUYdo
 N33/QvGuIcCzwAAAA==
X-Change-ID: 20261030-swapin-large-unmapped-6c8f6e691864
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793736738; l=6340;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=Lm38oXbEJUXl/i24q7z5muDUs9iAOX8Ua2b7rdxhOzg=;
 b=ko0BNXLXteVoQIhJcyCVhxe1a2+lBg/WU4R0hGskkUGY6phfCi+7xVH4iJejuhqQr+YMn3mJf
 4Zi9sXrKEgzC37xSgQL2HITElxMBpjxiDPYRWPQ11naL9T4dPOqIP5V
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: eoimp1bn4umy9csdtpexbbtwwq9rc5ca
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4F62180007
X-Rspam-User: 
X-HE-Tag: 1793736740-888534
X-HE-Meta: U2FsdGVkX1/tGspgj2RJ80uL0fa7nOr0N3bVlHIbwKGWDpSTbGIgnidB4w2U4yVLiIRYjqjfreYkmKCGDcET4UDXlVBmhcpCeDLp1/2ifsYfrQ+A6yt4q0yFwVje6y1N5Fyg60lseHTrnrharkXCdLFDaDMvGk90tt5FTnA+tsuokmNf/02LuMtS7W9V1p6GdGW79OQQ2wCSufCq5aXyxSuzZMmtgwoO3yk9v+6dumZJ5YOrSyrlMSGWMNJnh34j9/sEH+xlvAXEj9viAC4hULNPNrSEo4g4kvXcpLaSjsDFSBv0Yz5727bv5hDlY+65xHfuJGQ8bBlZPVspJ3PexTHxv8BsoB/qnMIv15HaJRmG/XlzQFDZR7M58rQsztjotB0IQsD2cCBrojMwLhJlltgTkIC/+bf1WA32uh3uLKmhv9QeCks7p9EDy+Ko/qc1vjSaK9WAsxdqyklEY8EMMxhifleqreTCdod1rJlABPHmcmzkp/ibVmX/wSZ3P23wPoGr/BzwG8jut4B90b60iLn/pzQykSkLiJmtXg6MZ220RCCz8woFjddnDetrxge1b3ZEEaAu1ty2S9h9k5IIoBFIqFytJFujS6OBT2L0Lb8sLL6mbBsHNTomyiqAJDfd9fsau2qf5uBJP3ihjFnA1awido4Uqlt4deXGxvr13zvic57alrTFuE9YSAmK8p33aGO0m4TbU5sn+91ITNzDE58ErVehoWYWmDY4ALewucYPWX+WHCRXbnxuULhKP3HQlCSbVTplWX7yxiombcDKlq2BoDFoIePy+JgT2Ft4qOwf+1Cx2tTx7VYhVgv/ZX/HyCwnbDPMKlWerg67uTYJE0G4k0YhCeJEv+CZGMOkcgf7Yg3wjPC036UTCEBCOYC8L86R7C9cCdl6Lrri48y/Rb7suiYQJiCb/5M7WUhLB3d7O5TXB4AFY25/xU660YG8M8y2ZRmEjS5khhw4T6m
 5UBZ/Hs6
 IfYjuvjvzHMA8Cf+dWMG19GwJ7DdZdL2O5xCc/WLUTFPc04xT1+6fLK0YfemXHipHwS/3abR8KFZLbZjBISvZYMk+ak52o7pI1OfXNHaIo4ydAlx9ScFijmolwOMzbMDUACqUtWpNdSikdzHrApV849WHxi/GMqr37EPQFB2zj44MxXy2k2Ndn9/mb08CdvWmATkL2MULpW8PVlvoDWLL62mGJLKScijpPj4SHwvV2HeYwUwK7QiJOVecq9qihvcw2h7VfvmVHGX2/iHxI+CJYmNdvstko7VzK+753dRyXSEzECqWJMM4lA0ZXm/Fqf1lBL8hqrQMiOqwHvPYP0inD3qDDdgZKF9NuC7aGYT2+6ZL9gV6+16QWJpbkSHF7V7xY3NbNYdurVqLiR6OkppGBzS81KZEZYeUiIB+PWSO6KNFgwwYY63jjXauV/CwI0SVtb/rHlmTQ07ZpOC9oIkimUKDA4oX5atfJPuNc3AF5wsa0Z2HqyYuGdvQOrcz3ufDhZS4eVLJj2eV9e4apF9ySBF7Z7rjVCf1ArOfR4YHVCZiQgiA4aQq0ENC6OAyfHri9RgXqw7Wwe+JQjkJcrJckj7fLZOXxygUs72bsWNRDJM1glA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
one large folio in the swap cache.  The folio only becomes anon once
do_swap_page() maps all of it, so if the faulting PTE changes in the
meantime the folio stays in the swap cache while not being mapped or
anon:

  Task A (fault)                       Task B
  do_swap_page()
    /* swaps in large folio F */
                                       madvise(MADV_DONTNEED)
                                         /* zaps the faulting PTE */
    /* PTE changed (F not mapped) */

swapoff then maps it, which marks all of its pages as mapped and
exclusive, and the next fault on one of the other PTEs crashes in
do_swap_page():

  [    6.424485] kernel BUG at mm/memory.c:5195!
  [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
  [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
  [    6.451035] Call Trace:
  [    6.451567]  <TASK>
  [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
  [    6.458525]  handle_mm_fault+0x16f/0x480
  [    6.461143]  do_user_addr_fault+0x312/0xa30
  [    6.462044]  exc_page_fault+0x66/0xc0
  [    6.462846]  asm_exc_page_fault+0x26/0x30
  [    6.476708]  </TASK>

do_swap_page() already drops such a folio from the swap cache when it
can't map all of it.  We move that check into a helper and use it in
unuse_pte() too, so swapoff drops the folio and swaps the entries in
again as small folios.

Such a folio was never mapped, so it shouldn't be dirty.  If it is, the
helper warns and the folio stays in the swap cache.  unuse_pte() then
returns -EBUSY so swapoff fails instead of retrying forever.  With the
fix, the next fault doesn't crash anymore.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 1s.

Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Changes in v2:
- Move the check in do_swap_page() into a helper and use it in
  unuse_pte() too (David)
- Use VM_WARN_ON_ONCE() for a dirty folio (David, Kairui)
- Keep a dirty folio and return -EBUSY from unuse_pte() instead of
  dropping it, since dropping it would lose data (Kairui)
- Rebase on mm/core.git for-next-fixes
- Link to v1: https://lore.kernel.org/r/20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/swapmthp.c
---
 mm/memory.c   | 17 ++---------------
 mm/swap.h     | 21 +++++++++++++++++++++
 mm/swapfile.c | 11 +++++++++++
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 91836d217d25..2e0dadbee382 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5166,21 +5166,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	BUG_ON(!folio_test_anon(folio) && folio_test_mappedtodisk(folio));
 	BUG_ON(folio_test_anon(folio) && PageAnonExclusive(page));
 
-	/*
-	 * If a large folio already belongs to anon mapping, then we
-	 * can just go on and map it partially.
-	 * If not, with the large swapin check above failing, the page table
-	 * have changed, so sub pages might got charged to the wrong cgroup,
-	 * or even should be shmem. So we have to free it and fallback.
-	 * Nothing should have touched it, both anon and shmem checks if a
-	 * large folio is fully applicable before use.
-	 *
-	 * This will be removed once we unify folio allocation in the swap cache
-	 * layer, where allocation of a folio stabilizes the swap entries.
-	 */
-	if (!folio_test_anon(folio) && folio_test_large(folio) &&
-	    nr_pages != folio_nr_pages(folio)) {
-		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
+	if (!swap_cache_folio_mappable(folio, nr_pages)) {
+		if (!folio_test_dirty(folio))
 			swap_cache_del_folio(folio);
 		goto out_nomap;
 	}
diff --git a/mm/swap.h b/mm/swap.h
index d5bf21f517dc..f045a384fe79 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -464,6 +464,27 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 }
 #endif /* CONFIG_SWAP */
 
+/*
+ * If a large folio from the swap cache already belongs to anon mapping, then
+ * we can just go on and map it partially. If not, and we can't map all of
+ * it, the page table have changed, so sub pages might got charged to the
+ * wrong cgroup, or even should be shmem. So the caller has to free it and
+ * fallback. Nothing should have touched it, both anon and shmem checks if a
+ * large folio is fully applicable before use.
+ *
+ * This will be removed once we unify folio allocation in the swap cache
+ * layer, where allocation of a folio stabilizes the swap entries.
+ */
+static inline bool swap_cache_folio_mappable(struct folio *folio,
+					     unsigned int nr_pages)
+{
+	if (folio_test_anon(folio) || !folio_test_large(folio) ||
+	    nr_pages == folio_nr_pages(folio))
+		return true;
+	VM_WARN_ON_ONCE_FOLIO(folio_test_dirty(folio), folio);
+	return false;
+}
+
 extern const struct swap_ops swap_bdev_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 71ef9e2efb3a..fe2a00190806 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2513,6 +2513,17 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	if (!folio_matches_swap_entry(folio, entry))
 		return 0;
 
+	/*
+	 * A large folio that a fault didn't map can't be mapped one PTE at a
+	 * time here, so drop it and swap in small folios instead.
+	 */
+	if (unlikely(!swap_cache_folio_mappable(folio, 1))) {
+		if (folio_test_dirty(folio))
+			return -EBUSY;
+		swap_cache_del_folio(folio);
+		return 0;
+	}
+
 	swapcache = folio;
 	folio = ksm_might_need_to_copy(folio,
 				       folio_file_page(folio, swp_offset(entry)), vma, addr);

---
base-commit: 71555ae8c7572fd99158013ca2e29187c5d2508d
change-id: 20261030-swapin-large-unmapped-6c8f6e691864

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



