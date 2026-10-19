Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5067D606DA4E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPTiOnBr
Received: by kanga.kvack.org (Postfix)
	id 3936E6B02E2; Mon, 19 Oct 2026 11:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36AD46B02E4; Mon, 19 Oct 2026 11:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9346B02E5; Mon, 19 Oct 2026 11:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F22FC6B02E2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:58:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 868A312076B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:58:07 +0000 (UTC)
X-FDA: 85339832214.30.90804A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AEE332000F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:58:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mPTiOnBr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Yntcu++Bk23KyJ22PYNQhhCbRirZ3yVnoNv98kbGCE8=;
	b=Ru6W9R3Up4hhByAyepq4yt1brp28/TuFwu1m59+F+44yhmNrlgWF3jKfw++w8b7+0naEe2
	bGZWBWnxT9ReuhgsJtsmH2oWTypFEkinvyUC0DmsqBDJDkDIiaVSQSqOb22lv9O3BsknFn
	3FnEPCsvLfcGXUevf/BreGavtl4Zg4o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mPTiOnBr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425485;
	b=pdU+s9h3lwYjkh3efQoDt+7b6kgGF6uANfGOqo43YqM3WrKeNzU/Tf/C0DrH/sjt7TirAo
	QdkOiQJKHDQPAP2FjNlYZIjeLKQjzeBGoJM9cBNz3tV1w5bC+RGGHrWyfN5mU0d61A++wX
	iOdycKjKfaabOPjAvu8z+S6ivauk7B4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31EE144057;
	Mon, 19 Oct 2026 15:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18DD1F00ADF;
	Mon, 19 Oct 2026 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425484;
	bh=Yntcu++Bk23KyJ22PYNQhhCbRirZ3yVnoNv98kbGCE8=;
	h=From:Date:Subject:To:Cc;
	b=mPTiOnBrcRiYvhdEH48MA8B3jLhdSuY0CP12o1xMeV0yGsm83xnedw0bOdtFNDy0A
	 tLly8RCPgWjBB2dILWnJbn0Ag2CKgUNDflqRW4Alutb7HFPMh4tpeOoK6JPKyC7iqD
	 mToXV3F31lMwwHiPKSoz1RKjEbsuEUdEtnjUFdJOuzZIXEyp3L3u1SADAG51SZzgib
	 H6cxf+xT8XNDFvBoiea0DLC5HBB39ssEBEXASkCVe4Rf600WLt6Amb1qew0rGBtaq/
	 A2O3foqkJ7FxcCXnVHh4FCRFPS4QVHW3zG6cJAc1GJ7RV3ZoanIIL2z1kTuEXyI7Nb
	 t8GkAzjVnzBtQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 19 Oct 2026 16:57:48 +0100
Subject: [PATCH] mm/mremap: correctly uncharge accountable VMAs in error
 path
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-other-mremap-charge-leak-v1-1-d94477fe6545@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSQqAMAwAvyI5G2irFOpXxEPVqMGVVEQQ/27wO
 DAzDyQSpgRV9oDQxYn3TcHmGXRT3EZC7pXBGeetsQH3cyLBVWiNB6oiqiwUZ2xL54vCd8aFAJo
 fQgPf/7pu3vcDFbuVVWoAAAA=
X-Change-ID: 20261019-other-mremap-charge-leak-b426336c0299
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Brian Geffon <bgeffon@google.com>, Dmitry Safonov <0x7f454c46@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2175; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Pa2pyigwPtTmiQmHbxbptIgogTHVgWu/s511reRaxWs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKu2XGyWPy44dQzj7H2zceTUzcuUn+teVrHOffv106Wt
 shbi+L2dJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiJ58wMrz8fkrB78jDXH2/
 kMJtRq4dO6y+Wqy6sag8wja/YbpleAHD/4ys1X/nXDr2x85UZH4o56mNfQz3DC/OzHjwXHQejzz
 7DC4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: AEE332000F
X-Rspam-User: 
X-Stat-Signature: tsxb9opzcxygcnnoyu4zzy8bhoy4fgp5
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792425485-847667
X-HE-Meta: U2FsdGVkX18br4MuqFpf12eRrKcoBg0MGkJjGs0sX54Xbmda3fioP4xEy5HGPF66cthQoXs/ru10/lxpcGO2hyuH47/0CLr0zPKwLlCzCIXlob/Movjh0PhwEbIGrs8OSp+es1wgks28a97ScTul/rPrLQE5Qrm0t6rc/TUcTb3gfcNKdBCRNQLU/rzzn8yLWMRtAmf7tgiokCbRriKaDO+LDQGJT7uyDA5LncOZifzx/2xENvjwrj8v59HSq6IRvaPAa+8FC3hAMWv+jpe5vzf83N5KK3uzcxyR/m4O3a0j+YK71YbQugR+IHDOJ8RviMGlRO5qkk2R3psRwrNz67FQbLT2LBG4l13f8fxNuDpB8R5heWQDW4OftIE+j9hOQ1HRZ7+ZxCY8PK1qTulWKfiM1Kymc5yvSdoB/cQvXLU/4Oyx7x4t5x5wqCi6ZCbVemMbzOuBWgnqTsli9IYlEUmkAu6AmIC7oDXIk4y6/uAw6RLPaG4nfqs4f/DjEoPPzcNiAt062sYBuP+Dyhk7CAc5ma0893F9U5Qe5DxDdcxeYfXyNL1VqWvehduTYz7ZEz27ltTy6urNNuujjw7HDXfTOlJUngtU6tydbx14qWqmaG+/ZD4riGqxnuFCKyGDtXyzDFdxrQQys1+++R0jFYUA6zVZY3qkArB4vqPPYu7mhsDb4pKbdXKLNY0WHnyAO563AJnDdsi8E3ZnKbb0Qd/mKxW1zTuV0flk40cwybWrMzkjPPAUrtaTL6rN8ItsPWqQsW01ronOJDpkj1P4DEBPG2sFqQo2r+Jg+q20PCc2K9cALwZ8LuEJyz49z9F11UtdCzsExgrGK8EUcGzXA2jFQqBOSd+HyGzCX/e0SPgrDL378Xx8fT315VMLzdoOtcrVOtaylNqKpW+AVk2OS015ShRtZiqy3xNqmUuD1msi1P0ZHZXlZ2/AxphUCXZrpS6AI2E325HwN1Wy0oG
 sfBvg/rd
 m2S2p8f2FsUTfxRroJf7c034SotIK3P1NrFV7CUbgUZBo1QmoeKw+lXkRZ+GqOQdgciXUt1lxu0HxsTGzIBAjcQIt3Irm1dNSj66HuW2hG8pIdUNhfP/Czny447AVR+uIJHKcBS1k52ze/8MiF+qwSWlJx5xnZvPzxqibHcbaer7ZbWdQzcSiR2RkLsng1CTcF/rHW16PEf0TTp8WgPOfMmgeixWCsYhMkuVFtqTKB3ADkfzVL6UGB4I1Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The mremap error path is a fragile and unwieldy beast - it reverses the
page table move then updates vma_remap_struct state to swap VMA, length and
address between old and new VMAs in copy_vma_and_data().

If the mremap() operation didn't specify MREMAP_DONTUNMAP then its caller,
move_vma(), invokes unmap_source_vma(), which unmaps the new VMA rather
than the old one.

For accountable VMAs when MREMAP_DONTUNMAP is not specified,
unmap_source_vma() unsets VMA_ACCOUNT_BIT during this unmap in order that
only the delta of a VMA expansion is charged (performed by
vrm_calc_charge() earlier).

Therefore nothing uncharges the expanded VMA size, and there is a permanent
leak in global Committed_AS.

Resolve the issue by uncharging when MREMAP_DONTUNMAP is not specified.

Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Issue was found when I had local AI check the other mremap() fix from today - it
raised that this pre-existing issue was present.
---
 mm/mremap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 6970783fc445..1620006028c4 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1338,6 +1338,20 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 		pmc_revert.need_rmap_locks = true;
 		move_page_tables(&pmc_revert);
 
+		/*
+		 * When copy_vma_and_data() returns, the new VMA will be
+		 * unmapped rather than the old one.
+		 *
+		 * When an accountable move is being performed, this unmapping
+		 * will not uncharge any expansion, so do that now.
+		 *
+		 * A move is accountable if the VMA is accountable and
+		 * MREMAP_DONTUNMAP is not specified, so only do so if the
+		 * latter is true.
+		 */
+		if (!(vrm->flags & MREMAP_DONTUNMAP))
+			vrm_uncharge(vrm);
+
 		vrm->vma = new_vma;
 		vrm->old_len = vrm->new_len;
 		vrm->addr = vrm->new_addr;

---
base-commit: 4dbe24720eb3811563cd56b35d87ddf3f9beed2a
change-id: 20261019-other-mremap-charge-leak-b426336c0299

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


