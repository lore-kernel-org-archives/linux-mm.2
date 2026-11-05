Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4C5606A33B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CAepGpPK
Received: by kanga.kvack.org (Postfix)
	id 647B06B05B3; Thu,  5 Nov 2026 12:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E506B05B4; Thu,  5 Nov 2026 12:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DA36B05B5; Thu,  5 Nov 2026 12:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE146B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:19:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5C751A0BAF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:19:31 +0000 (UTC)
X-FDA: 85401726942.05.B524219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6CB3A40005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:19:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CAepGpPK;
	spf=pass (imf12.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793899169;
	b=N202h9+5TXYGSiEi/TFvIOOdLqKKZLD9GgdovU6ZPJ0KXCTg+UdcLy3aHO4+BPx86IJeSf
	vnjW6oGTTSpeA3Su1V4qw+S+zsRKr2OM+trkbjs/H+lJvmXYTCJwfl3Geo1clyATpXarZC
	QXpwzrMCxVR9igYOd5VFHxq4/J5RYY0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CAepGpPK;
	spf=pass (imf12.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793899169;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ri8L3EEoBfWFKUTJIJIbM8fwsbVuZzUOY2ODmdTus0Q=;
	b=m9oIdhX1z2ddQ3/UiLsY3F3DNxWcLxNP+yGv6fV0gFEhEnuLec/PBsoPiD1iRR2pvceAjH
	/wr3d+xKNVV7oVqATdwJild/xsO5wiGskkZjgKHjwfUjUBq9jeXIdr0C+xndy3VCNM/Wh+
	ZENiEYm4l4Vp7JrXAtFmgeY/8vT5F0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91339423E1;
	Thu,  5 Nov 2026 17:19:28 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793899168;
	b=BYlD+bkzTnSOJCEgeQXIsSdMXMKWpQQiOAQ5czviYxqmO8xYR/t+MkeLQ0RDhV8pXG0i
	 8LYQrjoEF3Nvp7MHwiFfPTrwEP5G27YIqwttvzBq8fqzhx1tBd7WFj5/6ZGyjw3S035PH
	 qmWFdANS7cu/UpiF3TxGHpfE5Y74uVga8YO2FNNaQa0xn/FAIByxNwF90Cpsnk0woUiAn
	 tHYMJB4U6SpuA1VUQ2EY7UeZtW5nWnqCB+FiOPvt8slPOjVB2Qo489DECRPid67veBwsJ
	 XRo/rXTow7upVWgpqvsRtbDFxBP5ju8Bxh8LxvHWf3WojrZkHyYoG7jYmFM7TLEWa8g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793899168;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ri8L3EEoBfWFKUTJIJIbM8fwsbVuZzUOY2ODmdTus0Q=;
	b=oskCuaH29X6wZN7Q7LdmWDbTgOj/kkYsLptBTuQCJoyJ6BM4njxtHpflxD8QtC3WwrTO
	 hBhckZF57FqP6rhnICUBTwmhctcGf6rNFbCb3ECsJB29naWieLxrO1gF+MXTtoH+WFKwv
	 r3xq4atBoMJX3D6GLfGLDenb5g8lwHHCfRd17Ht+izCgcxc9shnB/eRAv2GPPGbBCCNB2
	 o4AhPY6upNO+Fj22tz9ez4gg9kdxp6rIfBi4mzN87vf0Cn5/1PaR2o/1ZEN21z5bAGcOH
	 MC7JTB3ruzhxkkbj75QhGT9nNfoTmTnOipAShiFdCzfk0zUpeXlbLAEvZeCuuv8gW3Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A7C231F00A16;
	Thu,  5 Nov 2026 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899168;
	bh=ri8L3EEoBfWFKUTJIJIbM8fwsbVuZzUOY2ODmdTus0Q=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=CAepGpPKhgaekSDGEQhP07Bx34thjGLDvhVKhEZ2W1l85QfWsJKVWhiWxPjk/Uy9e
	 c7kdKqPudkncJwZ5V5v5nt1+TUKosdGD0mXDSgnDULQJHBcaIyFM3qjK42Pc2W1BBO
	 vAayO96njBbXY4f9mtUsvSb3ITpyDETvZzKwCgSpcv9AgXrk/jSQVpoO75Wtk/gUG9
	 tCB8yqcWsrK8RTVhnTYe4CXnoxVu3Pss8Hivvtfy3Wd3FOnGK2/+mi09HIcQ//xBIY
	 lIir7q7U0AzE+kOzVYPTOh3Ms6ZzIscrxdb/Ykj0fSgwVrheWq+7hoq8r/ixU7E89T
	 piSj7WXQFNWfw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 094EA47348;
	Thu,  5 Nov 2026 17:19:27 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Thu, 05 Nov 2026 12:19:27 -0500
Subject: [PATCH v3] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261105-swapin-large-unmapped-v3-1-d5906e4cf18d@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4XNTQ6CMBAF4KuYrq1pCxRw5T2Mi1IGGcNP00LVE
 O5uiwsTE+PyZd58byEOLIIjx91CLHh0OA4hJPsd0a0arkCxDpkIJiRnCaPurgwOtFM23OahV8Z
 ATaUuGgmy5IVMSfg1Fhp8bO758s5urm6gp4jFRotuGu1zG/Y89v5teE45TTmkCpK8AKlPeuzmv
 kJ1gHomccaLDxSkX5AIUJHrnEFW5iJjX9C6ri/CfztfGAEAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793899166; l=6342;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=8JpSwuWf9NP1iQYvz5Gpx6uSt1GJJVSQ0Pxbzq2T8RE=;
 b=xkIsHYjRBs2rIxzOFBF2QCdJqdG9ZWe2Zb7y5agSBS+3a8FYWIRsZN0iJGCkY1GbGI1UR/EXx
 4pSs4ibZEoJD8kISLzMiOBs1eP+1JiOnI0ge0A7V9/F0eLEa4DVx+Rg
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CB3A40005
X-Stat-Signature: g3q99y8mtew7asbxwmn6zspgfpt47cce
X-Rspam-User: 
X-HE-Tag: 1793899169-702808
X-HE-Meta: U2FsdGVkX1+6TgtwodLQyRzEcGteKl9o3gVhz4xN0DmqlEUUMeFsb3e/2ahri3uV/lS6G28+SOFox0AeHnA5nXzqcNfYn4v9c+Qw5cCGiLbQCExS7uDxGOjwseDkFDsN42i1FU32JnYDBCQKmNM5Uzg4BAv4rLauNNZ3DZJXgHOc56NhZMwBQA48uq99p2cYCgK0G+PPf0nzW1og9daxgtRCy0iLDIW4/KD5xRvfAb15Gr/Y5hqgNJ4Gi50gghQBRDHdXZGAqgo9cM2djzSP9BcsytawkH6zMoJa2FbVLeJQN5YUCH5mpALh3pT/jXe9tFk+hnS4V1+zrkU9cEjcpGSXVClcJOcvGQsP2bNNwrf9qPn/DNM+INSGTkRYW3zT4Ca85/G3bGseq7zJ/Fx2u/YIa1SzFqLaw1iN8p5jMDtrlCTxsVnjCm56W9/v5djeByQJVgfhUl0GUN2Ia5PmCGcwS3XYwKBVBToHb5gHOnK6syKP02oxRGIySUJdmqiJB+jBOby5GPcr3Awnj2jeXEm+y9EYuO49cs2FPNL/7ZQXr0Uaim7XibBp9KOVUzgLVMQ9u4ahN415wXnOD8k23AVq/r9zJKdbeCj1jRf3uFUy3JNqSJgqraJ+ItfcCZzd18ZZQzoMRvtyame8docExNOu4wszvngU9UbIP/GIe3J83QiJbR7xJHvO4nod77RWJbhN997jn61jKfOn3gEnKW74DetJxnQjqlzqV/KOOTsVycejj1ewZVISRFQWoXy0BO3ZHwRkHTjqXVlhwLlPrRm0ZUkBRksyhqLsSvRq/AFvYD2eJc1YWVXKnjsaJscHk2vJcpzcz7l1qCfjZyhJOG29A77vgviUK6Tdsogf5zAGxUplh7i9HkxFDvaJWc611MRMC7Bjh7LZehntteWcmRBjxiLML8XwEz1loeuSyoG7lH4qyN6IZES4rmavolAQQldvhcjIeJfPFAPZDai
 jrtUbAa3
 M0PN7q8+TWdc1hb95BZDxg4UE2oGRDcQwmWNRHjWla9Wjh7PuAu55s+3ysOhAvBpbb7kIZqHQqHV2EHamQR047HBqo3vJY07PwV42zi0DTP02c7d+yE+MF8yRHDVF4H5gRWtKQRQE3iqMak33YfQo1gPEskVCkyIJSOB11CrNqvwh9vkdZADRmh2T7o+GvI7uXXC6F11BSiPAhhJR3zSeRmxnS1TurhdClu0tYgIjPYLIOOGK3FE+zgK6X2vDJdKsDC5oHRg7SQP5fLxbtORzIL86sW8BgZM6sMygDi36zEM/gwDXg2nfl/CMxk+X7VzrSxF50pInXLLADYhzWY6gsMvh5a8v/sxmMJaJDMu0vC6bRZjk9jPX1rtw+ul4xNKV4Xy4Cq+ho/vSiqbwr4mR07B2lUXnhieizXdVBn9HotqY+gANRLqoyb9v558o+3QdjkSBZ2fusZGwAl3L2QZW+3Vz95ZNYVeSpFu8u3/VF1kEM/XidfM5g40/ijyE4dxz3zte+1EKDSNWF/iXb3kiZ/zGDbqJwz/rU4ikn4QBsnT+xZM0LkQLUdVVAs11L5rTMl7bFtgxsfQG4w/FiL/Bkf/BUnuyhCNZVjW7cr0KQXxbzSnKL/2Evf9r/DVarYgxwuV3
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
again as small folios.  With the fix, the next fault doesn't crash
anymore.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 1s.

Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
Cc: stable@vger.kernel.org
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Changes in v3:
- Don't handle a dirty folio, the helper already warns on debug kernels
  (David)
- Keep the comment above the check in do_swap_page() and say "some folio
  pages" instead of "sub pages" (David)
- Drop the note that the check goes away once folio allocation is unified
  in the swap cache layer, mention it here instead (David)
- Add Nhat's Reviewed-by
- Link to v2: https://lore.kernel.org/all/20261103-swapin-large-unmapped-v2-1-87c70e597250@columbia.edu/

Changes in v2:
- Move the check in do_swap_page() into a helper and use it in
  unuse_pte() too (David)
- Use VM_WARN_ON_ONCE() for a dirty folio (David, Kairui)
- Keep a dirty folio and return -EBUSY from unuse_pte() instead of
  dropping it, since dropping it would lose data (Kairui)
- Rebase on mm/core.git for-next-fixes
- Link to v1: https://lore.kernel.org/r/20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu

This is based on mm/core.git for-next-fixes, on top of David's 7f2c000ffb10
("mm/ksm: check large swap-cache folios before mapping them").  On mm-new
it only differs in context and applies with a 3-way merge.

The check can go away once folio allocation is unified in the swap cache
layer, where allocating a folio stabilizes the swap entries.

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/swapmthp.c
---
 mm/memory.c   | 13 ++++---------
 mm/swap.h     | 10 ++++++++++
 mm/swapfile.c |  9 +++++++++
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 91836d217d25..10016f7984fd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5170,18 +5170,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * If a large folio already belongs to anon mapping, then we
 	 * can just go on and map it partially.
 	 * If not, with the large swapin check above failing, the page table
-	 * have changed, so sub pages might got charged to the wrong cgroup,
-	 * or even should be shmem. So we have to free it and fallback.
+	 * have changed, so some folio pages might be charged to the wrong
+	 * cgroup, or even should be shmem. So we have to free it and fallback.
 	 * Nothing should have touched it, both anon and shmem checks if a
 	 * large folio is fully applicable before use.
-	 *
-	 * This will be removed once we unify folio allocation in the swap cache
-	 * layer, where allocation of a folio stabilizes the swap entries.
 	 */
-	if (!folio_test_anon(folio) && folio_test_large(folio) &&
-	    nr_pages != folio_nr_pages(folio)) {
-		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
-			swap_cache_del_folio(folio);
+	if (!swap_cache_folio_mappable(folio, nr_pages)) {
+		swap_cache_del_folio(folio);
 		goto out_nomap;
 	}
 
diff --git a/mm/swap.h b/mm/swap.h
index d5bf21f517dc..7779ccff5a0d 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -464,6 +464,16 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 }
 #endif /* CONFIG_SWAP */
 
+static inline bool swap_cache_folio_mappable(struct folio *folio,
+		unsigned int nr_pages)
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
index 71ef9e2efb3a..5d915951639e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2513,6 +2513,15 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	if (!folio_matches_swap_entry(folio, entry))
 		return 0;
 
+	/*
+	 * A large folio that a fault didn't map can't be mapped one PTE at a
+	 * time here, so drop it and swap in small folios instead.
+	 */
+	if (unlikely(!swap_cache_folio_mappable(folio, 1))) {
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



