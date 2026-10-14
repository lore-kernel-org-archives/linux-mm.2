Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870A7CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E0B6B0088; Wed, 14 Oct 2026 09:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E796B0098; Wed, 14 Oct 2026 09:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844216B0099; Wed, 14 Oct 2026 09:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65EE56B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:16:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04EF2A054A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:16:09 +0000 (UTC)
X-FDA: 85321280100.30.310B650
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8528AA0013
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:16:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IfV8S4NQ;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N/Kx0frmkxosvQcop9AdOprS27rR/qXNkOdGxt6bKsI=;
	b=FBQhYWESDYB7LXMKkoAQAjVnE+LbFW/zc8zsCbzAYRuHhAnOeSJ+tpZjWtXSo07QYcnl3p
	gWT+2m84vpNC0/mTYEjYnjX/ocT9R3zFk96+YhGtMwNL0ZFnx3seDgEiEd8XCvAH+U0FVS
	RdbOwako3HF1aVLLTR3847qSOUPX1kg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791983768;
	b=7I0eKhZ0vt6Xst/uK51CqC2bg6eZLQckeZxRu+3C9PI76mOH0FlW+Lx7QeFcifwYvriAhr
	scoNB4QS9Zb2KgQHWap2GIrJeQxXsAYNKOjJFMVE/Tl1n6iAht3C6gyHRwf4HJ1d+8v7nZ
	ZjvBKx0bir0sJZwJbCBKSYtSjMU3h+4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IfV8S4NQ;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA4BA60219;
	Wed, 14 Oct 2026 13:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD001F000FF;
	Wed, 14 Oct 2026 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791983767;
	bh=N/Kx0frmkxosvQcop9AdOprS27rR/qXNkOdGxt6bKsI=;
	h=From:To:Cc:Subject:Date;
	b=IfV8S4NQS0MqMSLTMwNl1QtVDDkd4UFmd5o0O0OGBCKj/A4Te/Y8nCmicx7OVbrwq
	 6DOy8g4oT/WhRQ7kj6Ob0FSCFmHLmTwhMvQFGI9QK3hFL6CdwN4EUKuYNzuDQiSNjX
	 bArrNH0X6myiUQssLkLoGWrMMxej/xMGzZRMKfmW0ZbzCse+Z0b7fldUO91ZcIHFOM
	 d+Hs+e1vRtiAbij056A7JxS/5qBI5Tv/WmDU6XUSkVyv9eK67kKv/B8cPngMEYBECe
	 Kbbcgcll6kLnGn2PCbYd1kYd4Ae9KvsUUTW1OzIR0NwYzxDhr8QQUw4u2VZQbY+yqn
	 uca2v4+jYSvKg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bing Jiao <bingjiao@google.com>
Subject: [PATCH] kho: do not reserve empty per-node bootmem areas
Date: Wed, 14 Oct 2026 15:15:44 +0200
Message-ID: <20261014131547.259138-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8528AA0013
X-Rspam-User: 
X-Stat-Signature: mowpi1q9zdsw3azirm6kesie93mwzcaa
X-HE-Tag: 1791983768-343982
X-HE-Meta: U2FsdGVkX18y74S4Pv28jLo/hFsON0cCg6s8yKrOXB7g5WHNoFgHgFIayWYf8AtEIuAgy3ekHKz2nFv0mLGveEQ+gd/e4AddL4OMqP9cyPDfqyO9oIq9mTwUzPR6qDuLnnDWuyfYyMYCEv3deKnLGyebtI7ZO4Y7G2RhmbCL50nOZKC8k56HVHmjVo8d9qTTAMpPFZiOZE3UqmKXAr6vvQTIUeulsegzyjdg85EGSSO1vNwMYZmmBLJzdJmZo6jcNtWR8IN4/fhICvnengkyMsQ8G2IIh8DL878Y6VvgAHAB9RlusjkVik3SCbZq/GDz28I8GDJ9MqUYo2Oi+9FXbesEeDa4Q/Lso40wRFV5U3O9ckyBfvNZKoFAVBJtfEMeJjPkzaLovh409fjCXv7Er+X2DSaPuOJTl9ig4y7VtqN977CzSjAG1prOwJ/IrB1JmrhnXfjxO1Eh5u8j+R1FH9w9tu0yJGo1TfYD4e50vgbLQBbpguFKaufQ81WgxcL93R6/+qoJWg/PsjBIn6Ln/zinaAcGavozudYgupcvSnSziMFddIefxZ8Xod5MWAHhdoA2+1yDVjCY/5jnrvhELZ2Gop1XMya3YVcDrX6XXIYnlz4Qflh2qCBnNvOtVQjvUfi1FzJ21WEDWCumMuLhKkgIEQFoqKY+Qr1jyJnicTXEp1MJfb0B5zK05Ky2BXHstEjCdCnOcDDNZElfuS/YnZAro6uY6yqa8joO4ETu1glCq4xoqExGxbalqv2+SixgZuKiY+pmE84X4TbBCI+aR1xDP/lJba3Jp8klSTkOznegZOq40gZhTJb9c4BC9d/BaKL3d+KMA0ReX4lsjnypieJj15xFe8g2qEYTDOeW8vPM0z7REHq2sw0cdZ+x4Xb/7KxGZs266O78J7aSuyB6gWssy29Jp39/fxjnWekHjclhSx3reEoTPCO1GuyMPfvv41tUnJ3VVCjYauG2ni4
 6QDFYJrO
 PYHGb1PnhPHRoYCf7iSCcqr3gwfiZuNzEtXkejiivLiS+uH/CrW3/vf1GrWiwsYG8uIX/1H39peKtVAOG/DyCwNcXH/VrXLQOWxDe6EzxVMrwczpgaDFI7lnMbD0mXTKQNO9H0OJVll0beRh2byhslUGUVyzpx+w1sjgDhYpQcJcnIsS0WqRMKp+O0deQurGhq8i+Z8IwieKV4Ey9s6x8StlPTXGpQipsQ5YiXX4WgwwSSFxdRcULTi1n+yDj5zAP93oz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Some nodes do not allocate any early boot memory. An example is
hotpluggable nodes with movable_node enabled. So the scratch size for
them ends up being zero. Zero size allocations normally don't play well
with memblock. Memblock returns an address, but then doesn't actually
reserve anything. This address ends up being recorded in kho_bootmem
with a size of 0. In case of hotpluggable nodes with movable_nodes, the
allocation on the node actually fails because memblock refuses to
allocate there, and so KHO fails to initialize.

Skip bootmem reservation for such nodes entirely.

To keep the code more robust, avoid overloading kho_bootmem_cnt. use
max_nr_bootmem to store the size of kho_bootmem array. This ensures that
the location of kho_bootmem_cnt assignment does not affect the cleanup
paths.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Reported-by: Bing Jiao <bingjiao@google.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7018e25e4eda..6f1f55fe3181 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -831,8 +831,8 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
  */
 static void __init kho_reserve_bootmem(void)
 {
+	int nid, i = 0, max_nr_bootmem;
 	phys_addr_t addr, size;
-	int nid, i = 0;
 
 	if (!kho_enable)
 		return;
@@ -840,8 +840,8 @@ static void __init kho_reserve_bootmem(void)
 	bootmem_size_update();
 
 	/* FIXME: deal with node hot-plug/remove */
-	kho_bootmem_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
-	size = kho_bootmem_cnt * sizeof(*kho_bootmem);
+	max_nr_bootmem = nodes_weight(node_states[N_MEMORY]) + 2;
+	size = max_nr_bootmem * sizeof(*kho_bootmem);
 	kho_bootmem = memblock_alloc(size, PAGE_SIZE);
 	if (!kho_bootmem) {
 		pr_err("Failed to reserve bootmem array\n");
@@ -882,6 +882,9 @@ static void __init kho_reserve_bootmem(void)
 	 */
 	for_each_node_state(nid, N_MEMORY) {
 		size = bootmem_size_node(nid);
+		if (!size)
+			continue;
+
 		addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);
@@ -895,13 +898,19 @@ static void __init kho_reserve_bootmem(void)
 		i++;
 	}
 
+	/*
+	 * Nodes that needed no bootmem were skipped, so fewer areas than
+	 * initially estimated may have been reserved.
+	 */
+	kho_bootmem_cnt = i;
+
 	return;
 
 err_free_bootmem_areas:
 	for (i--; i >= 0; i--)
 		memblock_phys_free(kho_bootmem[i].addr, kho_bootmem[i].size);
 err_free_bootmem_desc:
-	memblock_free(kho_bootmem, kho_bootmem_cnt * sizeof(*kho_bootmem));
+	memblock_free(kho_bootmem, max_nr_bootmem * sizeof(*kho_bootmem));
 err_disable_kho:
 	pr_warn("Failed to reserve bootmem, disabling kexec handover\n");
 	kho_enable = false;

base-commit: e1fe7daedae7a4a23aca6dbd58e1746750b632dc
-- 
2.56.0.385.gd3acb90ef8-goog


