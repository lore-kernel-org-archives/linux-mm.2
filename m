Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4621606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXG7Q3Zw
Received: by kanga.kvack.org (Postfix)
	id A0BF46B08C8; Tue, 27 Oct 2026 16:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7406B08D9; Tue, 27 Oct 2026 16:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A476B0760; Tue, 27 Oct 2026 16:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 569556B08D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:33:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8894140AF2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:33:35 +0000 (UTC)
X-FDA: 85369556790.09.06490A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4C1418000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:33:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BXG7Q3Zw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793133213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RUsmSn5TTXp1D9mIJ0obASDtKKRFcgaXruKo733un9o=;
	b=lRHMvaA7XZHA6wCzqRqXBoKWfc6RNOAVcb7z49HXZELeaz9DSdgd/KcWDGbitSwCo9xRZb
	OfuAU+KWLJpIl3fJwLogDzMVP6jLh9gzmYei9VggtY8clPd3eIpW30edNruCzpeN+tfpMv
	K8ogavb0rcaI8i+OrkMsKQwb8WDg4jk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BXG7Q3Zw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793133213;
	b=NbnYHO4anhQ7B2eRMF2vSGCEuYHzaRJOFDXRpZ/TVw9gpNqRLXAsMf7UBCPCQc83dYB/P3
	AVfYRxgM/XCYDJEk3Exlc7jCu6FPvrQXkzRgpRE3Klqu8xmMuEP1L78msLMf7vgxS7eJDQ
	K/TEytjyangid54sH2XHTuF2NieggZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59F356022F;
	Tue, 27 Oct 2026 20:33:33 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793133213;
	b=jJZy6axos4EmObl9spOrPMEro1hDlSAMETbdsIgRO+p6bxwptEMafgFRDqgYeYmf6VAG
	 cszb5a8lNTp8BSJfH/mpJ7mbZb7Y9f1ITIUxxaHJavsIbAXkfvha16TWS6uuJ8eBbsXQd
	 8H7lyGLzen/Wr7TN9Oz46Hr6AtCgMm9eKSwp3He6HzBRPVsZS6YYMdTZzVkjhM++D25TX
	 SWsswwbITxc8GmxkK240f36BQy5uhJWv4FHHQmkRi5kqNiwxGjdPDHrrVXS0hOInBOTeS
	 nGR+/ugZ2Ra6O6doXaRTkVaZReHPFQBhNyB2iSMMnfDQei7+2yaxC6oyr9nTzXt5Rzg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793133213;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=RUsmSn5TTXp1D9mIJ0obASDtKKRFcgaXruKo733un9o=;
	b=wr+DjOaaECUlchssCVu6rDPeQRrl9MH85zwGNmnm46uUQihuHSC/YMNH95JTcdPrFh54
	 388HHTfflHCljq5CnFpLbqbs3HPWFDhOIXtiCsjF/F3jnSCSJupy2LK8W3S4t3fYMmJoh
	 ZGfUfYLZa8hzyAEC/+ng6FTG5obFGy9e7V8I6THEgzcuzF3bZMzt6Zc0oSG7Zb6Qfhqbw
	 g6BGzrveckbY129ZG9FDc05S4MGdfP58VxbX/ZF/IoRp8ujMN9WJFycJ0/rXhVwsg5IeX
	 frNZFR4N9kl1LPdIkeUSvf3P0kHfp2qFvYxzHg/yOZ4pfeCPQXLanUtbH6s1t9BtrQQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 81D7C1F01825;
	Tue, 27 Oct 2026 20:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793133213;
	bh=RUsmSn5TTXp1D9mIJ0obASDtKKRFcgaXruKo733un9o=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=BXG7Q3ZwHaXPb724Gr8w05DFzyLn8lvJXSOvLU2S147jYv6oSrNTwhqcANecrFqYw
	 ev3zLbkLzxKyz06JNQhgHYJhz/HZe+adzyVqqmiCwhr60xMTSp/9aY3SZtrneSOzSj
	 PqbzLYv+x+oopTyrNrv8/INVrJPtIBKDG6pOwB9uTTkQ6EGIL9ANxe4YyzsuptkXKo
	 lOcDnRH21JPJV2T6NxWmzQlsy6x+E0B6FiByNgUIdbzcW1SF/Vp07cjR3ihXWRjxWb
	 lUOpICDAr4Rz12rDhK2Y9IM6Gv8a1OqVM97Q85rRGwbrH7HpYEJQJU0XLre9zXovXZ
	 I0Ix6ksxW4i6w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D5F5C451F1;
	Tue, 27 Oct 2026 20:33:31 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 27 Oct 2026 16:33:32 -0400
Subject: [PATCH] mm/shmem: fix swapin livelock on a mismatched large swap
 cache folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261027-shmem-swapin-mismatch-v1-1-84e30aa3b9e5@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBCF4avIrDvQBFToVYqLMY7NFJJKxqoQv
 LtRF2/xLd6fQTkJK7yqDIkXUfnFAvOowHmKH0YZisE+bWPKUH3ggLrSJBGDaKDZeRyHloi4NbX
 toXynxKNsV/fd3dZ//2U3nzHY9wOS/mNzeQAAAA==
X-Change-ID: 20261026-shmem-swapin-mismatch-fd7aaae7152b
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793133211; l=4725;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=Vdl4OKyE80c+N/UAG+bYXzpu0HL0y5evYFJyEcYjtvw=;
 b=7uEcFzFrWSSemDyMXBbHWaNW+OuNxmh1qJi8M4WhwJ60XkoJkAc5+eqGMXNjzw5vbCxDuDjY9
 HBoa2eD2w2CDUcUk64WjB98n/hFWwztLwUaIG5XzUTnR44iklMkG7ET
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D4C1418000E
X-Stat-Signature: waenf819fus85r8d14e8xswhye7foxqf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793133213-532152
X-HE-Meta: U2FsdGVkX1/DSfaSy90lR+O/kk3eIlyb4mrXkdl4DxeLNczq5kpLM8Zne73EXwjhap2xvZgF7z2YmUq4foyYYhBKaOUAX5UyXCp+mv9fL8UXL+DjhutUn6s5Yexj9eN56h8AZwwtCKxdBuyIdcr3HfW7WQ/jYPAFk73rPUCWHUhlx+AJ+Iwrm7Ax88Vp08Lbw47sdC5FXMBcNugDZ0C5r8PdzsqIVC+O7uGKusNqr8DAfbpWJKZEraP064F9f1GKonq8dv2caEPAxIATqrb9Z/9o7VKB3VJEq7zeq7k63qubBxaw7wsCnCognS7NPRdGVacvBydj5KQx7Yuk8Z12YJD6hQocHMKwEqkOSkJPhOPecVKum2oYqFkpRE6l2K6sePBtgsb3WRuv+cFlLScQsL42VRfOu8wqdJx9g+Kly2QC8pJARjzWHJdPoJ6VXVSHWqjxAhoKeX1NUE110FBh1oXMod1H1vNc0fxj68G66Y3NsViw7ug7N/H9NZ8gri1vz9yh6nHViLPBBLETqsnN6+k4loME5Iipz7FkWNau6/zfMWR+93jCq8YkaecwcgbWhsclTDpxbztjYt0ym3RIKBymDfGyULAtVhmG0gKsL1a30ZLGiT9pDwvddaCvyquFNQMrJQqv0zqPwloRj2rR4PG8ud/BNEy2bsnK4Z+HV2ey2Tta1VgZP9SzsiyEGomd0REf66gmIZSjZDvTqJ3eR5RqJbDmGnl6ofX6YzQMeoVII43ZXIYm6vTxZwypvmqQKYc5SNMlpLAjN3vkfCYgGJXSRfuUx1M4mM1MNSgI6p0GRirqaTm/qZB3ZObU9QjQzyLyUKY7T5Z5wn18hS1sugvPAdqrs1HqykIIeBhASa6fKRdoy7mDFNmvh5lCb+eYmX4ToE9N44hM+979PmMUL33FiQgPaJhPjn94Qj+MR+9uBO1BPaBT3jfbWkqKij4cIbdF99b76vOW+1xxPer
 Wf4EAdGw
 yWnf9OqMEZIoiSgxBheaZWTQ1FZIe+ZdDRu2o59Er/MOg5+V6d90jMG73S3M+tphB8dGB57K+jU16cFL+9/FD2sy/+0YIbQqOTJVYxSRD2Bs/zUV0xodw6dZYtOzdEnMtX/1fL9yAkEwWsi1ldNQi0+Huhiil8GDDXs7fYpOQrLRmRO0ixoKwv4cD8W2ZHF2BDvrIoMpQEcPcjeMJWTSflwm8Zdh3hXeYyNFdRO43uHi4nH8T+XIvADPSW2WKd9RdZ0+LNw+Cuo+riXpjuRGbxyPCRt78xu5BrqZ0nF1SGBcOs+nglf4VgCtnMOEvaDgvSOFyGfhB1L8DPQ4X0Fbj4a17Ro94f1zAgGN68HnRyFEgdAfWk/zBlytPQuDeQ5WBns78moB3beHzE7UfFXfUgA4DeA4kzH/cmqVCwtyhAv8Kvl7qzKRQtgHs1+phdDo2kSnKoXFyVpBC6busBHj4Vxmpm52qZg/wIoBy2mDf5eIWwfU2RzLCRP9RpoOa1nxlB9HJNBWCyay8d1Aisp64vDGx0LjZsakGsHJANso6HMzpvJBAk62WSoYP4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

On a SWP_SYNCHRONOUS_IO swap device, a large shmem folio can be left in
the swap cache over swap slots that another file now uses.  Reading
that other file then loops forever in shmem_get_folio_gfp():
shmem_swapin_folio() finds the large folio, rounds the index and the
swap entry down to the folio's size, finds no matching entry in the
file and returns -EEXIST, and the retry finds the same folio again.
Since the task keeps the mapping locked, a munmap() of the same mapping
waits forever.

The folio is left behind when the slots are freed and reused while the
swapin is still allocating it:

  Task A (reads X)                      Task B
  ----------------                      ------
  shmem_swapin_folio()
    allocate a large folio
    for X's slots
                                        punch a hole in X
                                        /* X's slots freed */
                                        swap out file Y
                                        /* Y reuses those slots */
    add the folio to the swap
    cache over those slots
    shmem_confirm_swap() fails
    /* -EEXIST, the folio stays
       in the swap cache */

  Task C (reads Y)
  ----------------
  shmem_swapin_folio()
    finds the large folio
    rounds down to its start,
    where Y has no entry
    /* -EEXIST, retried forever */

Before commit c246d236b18b ("mm/shmem: never bypass the swap cache for
SWP_SYNCHRONOUS_IO"), a direct swapin that failed this way freed its
folio instead of leaving it in the swap cache.

do_swap_page() already drops a large swap cache folio that does not
fit for anonymous memory.  Do the same in shmem_swapin_folio() and on
a -EEXIST, remove a large folio that is not
anonymous/dirty/under-writeback from the swap cache so that the retry
swaps in a folio that fits.

The reproducer below fills a small brd swap device so that a 64K shmem
folio and the 4K pages of another file land in the same slots, and races
a read of the first file with a hole punch and a swapout of the second.
This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development, but the non-deterministic C
reproducer can typically trigger it in the 2-4s time range.  With the
fix, nothing is triggered after 600 seconds.

Fixes: c246d236b18b ("mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Two patches in David Hildenbrand's v2 shmem fixes series are related
to this one.  "mm/shmem: fix truncate hang in large swap entry" [1]
makes truncation retry -EEXIST directly, so it can also loop on such a
folio.  "mm/shmem: preserve allocation errors when swapping in large
entries" [2] fixes a different -EEXIST loop, where a failed allocation
is reported as -EEXIST.

[1] https://lore.kernel.org/all/20261027-fixes_shmem-v2-10-86a00952acb9@kernel.org/
[2] https://lore.kernel.org/all/20261027-fixes_shmem-v2-11-86a00952acb9@kernel.org/

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/shmemloop.c
---
 mm/shmem.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 13e0786436cd..f1da8432d55c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2568,11 +2568,14 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 * and swap cache folios are never partially freed.
 	 */
 	folio_lock(folio);
-	if (!folio_matches_swap_entry(folio, swap) ||
-	    shmem_confirm_swap(mapping, index, swap) < 0) {
+	if (!folio_matches_swap_entry(folio, swap)) {
 		error = -EEXIST;
 		goto unlock;
 	}
+	if (shmem_confirm_swap(mapping, index, swap) < 0) {
+		error = -EEXIST;
+		goto failed;
+	}
 	if (!folio_test_uptodate(folio)) {
 		error = -EIO;
 		goto failed;
@@ -2613,6 +2616,15 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		error = -EEXIST;
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap);
+	/*
+	 * A large folio that does not fit the mapping, e.g. because its swap
+	 * entries were freed and reused, would be found again on every retry.
+	 * Drop it from the swap cache so the retry can swap in a fitting one.
+	 */
+	if (error == -EEXIST && folio && folio_test_large(folio) &&
+	    !folio_test_anon(folio) && !folio_test_dirty(folio) &&
+	    !folio_test_writeback(folio))
+		swap_cache_del_folio(folio);
 unlock:
 	if (folio)
 		folio_unlock(folio);

---
base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041
change-id: 20261026-shmem-swapin-mismatch-fd7aaae7152b

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



