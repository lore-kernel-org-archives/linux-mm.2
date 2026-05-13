Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A32CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7ECF6B0005; Wed, 13 May 2026 05:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F1C6B008A; Wed, 13 May 2026 05:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A446A6B008C; Wed, 13 May 2026 05:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92A5B6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:21:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44B6D1C18B3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:16 +0000 (UTC)
X-FDA: 84761852952.27.F3CCAEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5D935C000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L+5lmtL/";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778664074;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ka0obPlWjZvbUaMWoGJ4SnCo8AARLBm3I7iqW7BUBd4=;
	b=vBymyWhgqxCWhkfNU/uZ+ubrM7RB0aEcfudXtnO1sVVzc4xiRJ6Xae33bAviC+wt+LP7LU
	bdRs/46LP97lBDnaPK1q9gAiAn5svD9cuSl/jNivGU1Ya9o41wAfAvc5e6KBzoF4GF6zVK
	TnCr9KqcJfhPm8veOmA32qbCIsuHphQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L+5lmtL/";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778664074; a=rsa-sha256;
	cv=none;
	b=wOFrR8DzVGoklS4wdmEyPaNsByH7XLIQmYZ2ERwJRz9Jk6/eq9y2CBqv+OwNX+KAg0ZV/E
	MJGuGZeFqnuMH0iYYH/6eXAYiwurZKV17zCCUeS5SjIR/vXYoFGNcUfoHif/RZnzMp1xQU
	4Iir4oV37tjmGrjVbHVwFRAmCnd95go=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADFE560126;
	Wed, 13 May 2026 09:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5662DC2BCC6;
	Wed, 13 May 2026 09:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778664073;
	bh=aaZnNxvXRi5RGCK81lftC2Qg+WtZRlfiL86526nBOJk=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=L+5lmtL/COrDSFio0rUoG9I0GaS0/1xNDz2NY4MLj2hGQL708gMliOMEcPr2GqMVN
	 1ZKMf+VJjXs+PkdG4adC7j7TkLyVlM1JVMny3KgfOpfMyjOzZDL/rqqenTVUsHQCwj
	 IBW2IQfyYTfr08c98+LFMVRP1BXdwit/myAI1tcvsHj/TOL7xcxCwggyxa+faDS8PP
	 I7+1110tioGlFf2C9AwY4RYj2KBpoHY3dR4u+IINzZnsIk5dktMcGsB2QP2UoMMRgF
	 JMojArMvnjh+dmT97TcpeUMvyLJiRmnxqGkuInVsKZ6WVwBza+AV4yhpfjeOzbo0FK
	 9ikW2SYk4WIAg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C623CD4F24;
	Wed, 13 May 2026 09:21:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 13 May 2026 17:21:11 +0800
Subject: [PATCH] mm, swap: avoid leaving unused extend table after alloc
 race
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMUQrCMBCE4auUfXahCVbFq4gPaXaqKxJLNmqh9
 O5N9fEbmH8mQ1YYnZuZMj5q+koVbtdQvId0A6tUk2/9oe2cZ/uGkTEVJOES+id40IkhR3HDvjt
 JiFS/Y0adf93L9W979w/EssVoWVZl+BbseQAAAA==
X-Change-ID: 20260512-swap-extend-table-fix-ed7d1f458dac
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Breno Leitao <leitao@debian.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778664071; l=3322;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=olohF3NDSrfjvRRAsUpHGpzDKysDHKS6sIdmBbNETbA=;
 b=zpAlWCyt1bbDtA2xwMhWBQt1LZ0rOwusVROrVS8ULCEYK8RVrCy3ZRG6YzoMUZBUdCPTLeScB
 RQqXHkwetdFDO1d9a3eVQdPMExYZKu5VPmr8f27kKEH4r5U5nd/pjzM
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D935C000E
X-Rspam-User: 
X-Stat-Signature: owmf4gpcf8az5brd3zydtzco5uhmh6qm
X-HE-Tag: 1778664074-327044
X-HE-Meta: U2FsdGVkX18UqXCLCJwG9odqXMOs9veB38XC7yCaIRGBkJqw1i2NrshptcvsBCw035PmCI5IvOZo2yWol4tefGoB4hkYU9Ikp3IzWt3ihe73JZgt5Jg21SVqqKvWRM5QJ5dEEeH9ic7IBrdlgINjKHa4JucuqbcdEghtACo3019X0M3geSrImbcXPY3wxc2IOW0juKFfL1cJBTrb3MXarL+NImPptYZlawbbve+OqJhbx9sbF2DTk+NMU8d2fcXfgcpWEapexipvHJzGeIEHF5mEiY97OOHOIREcave93/MYtLrSP5gjW/y1bPo7Q3H39m+YO7QtP9qph9tvfeBRm5FO8011o2s85wliJXZJ5ocM3XUyxxeB5YzJkdJPnOTEo4nm/fn2/EsCAON74N7abkFjpXvcieLA+vCq1n/+pSqbrj8UAEc1on/w7nXR+RwVNa9DsxESFXrxcqeRPbBfCt88zAMirPinWpCbvSEBHCiPPN4bMerKa5k4SgFY5qjddpGS3rapuMB29VkGVmMCNJmjK/vNz9autrtZTBb08pt93XIgUL+gl47vXqk3gwv27t9lC1i7F8xMTILEzc5UEihXjtEMeWSJi2yce4aR2TPqkM1DOUR8DB2ftpEM9wfiiz86NVsY8BHRCywKb4yezeaEOdeXkuQvUr5Ii6RkoLjHhmbHxH7GvJG1bVmgqwpqR8DE69OWmhCM3GPmzAwkgm+b1WB95i1XjDPlfGT+h2ukoVAo38QHUsvSsHl7j0sYA3Mr4dRV7/ugXfOKeU9sCgW/1IEgscvNumu2psucyYpWgGuW9ZtInFEyZtArov1GEB9lDRTVrEwOtqt054x5pSVhlstPFawVtUr2smtBjed887W2C0ySUljgQoigg9w3Cc7qlM756gms9t+HagP1+9W6p5c8wWP9tH2T9HDd7ddrHbWGQ2w+Ffcdcy6NHnvJZbRhKvb8Plt/kyVKHVP
 8uRcpR2C
 CKqxSUyLzBV7Le85h5DEHpfCLg3bTxAGBGhYHIzwGmQ0TF8tdS5X5e4hwM1/SlEzypdL2XzyzugFCdjFSsQ+Z6b5imICtLAFjoTfFmAnR5i90rUsyMigZUZc8H11UXRxu0MO1ebuM0wMQASf83Erifa9uofb/C1zi2/+aAKnSBzYLGnasJnIfowV9ZucMdOqGDsJnQOTgrTAf+6+8vPhjOus9NKA1YGGzS+cD4nnjRZBBSZnZJoTRM1OJO/rK42tDevJ+66kne+nOJ8JkNqOl0fi2Mr886L0/JUWKzsIIIKTRDiCHqnJi3xO6ahJuZEgBjaRo/YvxtScm+d11s+Mpt6mkPGXShpVYgmSQr9VukGrwpzdsZ15wrPY5/PoSr7GvgTJ2DKDEmUe10BD7IDmuEjLXv77qW6I3DOlGANs0APKIcijVzQ3wdJJ1KVPja32uvF78
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Allocating an extend table requires dropping the ci lock first.
While the lock is dropped, a concurrent put can decrease the slot's
swap count to a value that is no longer maxed out, so the extend
table is no longer required. The current allocation path still
attach the new extend table to the cluster anyway, leaving it unused.

It's not really leaked, the next maxed out count on the same cluster
reuses the table, and frees it properly. Swapoff will also clean it up.

The worst case is one unused page pinned per cluster until the next
maxed-out allocation or swapoff. To eliminate the waste, re-check
under the ci lock that the extend table is still needed before
publishing it, and free the local allocation otherwise. The added
overhead is ignorable.

Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/linux-mm/agG6Dp0umhs6O1SY@gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4840fd40f36f..451d20bb9f47 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1442,8 +1442,10 @@ static bool swap_sync_discard(void)
 }
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,
-				   struct swap_cluster_info *ci, gfp_t gfp)
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_off, gfp_t gfp)
 {
+	int count;
 	void *table;
 
 	table = kzalloc(sizeof(ci->extend_table[0]) * SWAPFILE_CLUSTER, gfp);
@@ -1451,11 +1453,27 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
 		return -ENOMEM;
 
 	spin_lock(&ci->lock);
-	if (!ci->extend_table)
-		ci->extend_table = table;
-	else
-		kfree(table);
+	/*
+	 * Extend table allocation requires releasing ci lock first so it's
+	 * possible that the slot has been freed, no longer overflowed, or
+	 * a concurrent extend table allocation has already succeeded, so
+	 * the allocation is no longer needed.
+	 */
+	if (!cluster_table_is_alloced(ci))
+		goto out_free;
+	count = swp_tb_get_count(__swap_table_get(ci, ci_off));
+	if (count < (SWP_TB_COUNT_MAX - 1))
+		goto out_free;
+	if (ci->extend_table)
+		goto out_free;
+
+	ci->extend_table = table;
+	spin_unlock(&ci->lock);
+	return 0;
+
+out_free:
 	spin_unlock(&ci->lock);
+	kfree(table);
 	return 0;
 }
 
@@ -1471,7 +1489,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
-	ret = swap_extend_table_alloc(si, ci, gfp);
+	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
 	put_swap_device(si);
 	return ret;
@@ -1664,7 +1682,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				spin_unlock(&ci->lock);
-				err = swap_extend_table_alloc(si, ci, GFP_ATOMIC);
+				err = swap_extend_table_alloc(si, ci, ci_off, GFP_ATOMIC);
 				spin_lock(&ci->lock);
 				if (!err)
 					goto restart;

---
base-commit: 972c53e0ec3abfc6f5fe2cb503640710fb23cf95
change-id: 20260512-swap-extend-table-fix-ed7d1f458dac

Best regards,
--  
Kairui Song <kasong@tencent.com>



