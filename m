Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4DD109446C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 10:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4293E6B00A2; Sat, 21 Mar 2026 06:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8D26B00A3; Sat, 21 Mar 2026 06:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8356B00A4; Sat, 21 Mar 2026 06:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 170A66B00A2
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:58:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2148C1F25
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:58:42 +0000 (UTC)
X-FDA: 84569772084.24.E3A2FAE
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56D1FA0007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:58:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=h1L0ZIm2;
	spf=pass (imf25.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.207.19.206 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774090720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oR7/taKa02ak4M7U1k8zDcir8rfHGE1O5n8xEZ7jI5c=;
	b=WL2jL2UOYRNMksjmSbYesMsH/sc/+J/w0IV6Fq0OFuEdLnSFpKG6VhLLEIL59zz2OaFe5O
	RFMC3q+xR9SdddGzWOZFV58155OF40NYIK1gBbJ2oNOXq8HgwIOSy7R8DUHkrY9yEydACB
	yLWgIk45H4FGA5ZuuqDnKHnSRSIKNmc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=h1L0ZIm2;
	spf=pass (imf25.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.207.19.206 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774090720; a=rsa-sha256;
	cv=none;
	b=e8SDht9Zf53Ve3fA55kmefWCueFJAhzZRLe6J+YLigpXtDlKj8XHOZcxWLpVuyKmjqPt1C
	m4qc1nlNlqlfFuu5QbZ1+XwYT5sHJlSwl+xEH8yPhyYHPi8J3Mz059MUBVXDZ4rCWTjxmn
	GuBqe6UYo8ktbjwdXN2a50bw0B5qzxg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1774090701;
	bh=oR7/taKa02ak4M7U1k8zDcir8rfHGE1O5n8xEZ7jI5c=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=h1L0ZIm2COGs4G799Lh/DEL6iEBLrdLayJU4rj76agwz5V31+ZbLDUepYnLKV39bx
	 s2efQBccKkT6Vj1y8JPxXL7/owKIN6AcKXQb7QKfJsVctpSuihF6RVzQKdB84vWShj
	 9EHPZirEd5q2beXkAVmCE4+mRfztzV5D6RUFav8Y=
X-QQ-mid: esmtpsz11t1774090698t874c55b9
X-QQ-Originating-IP: UCCHATCo+fkZj52uVTSv7poe6w02/BFI6ujd/On2YH4=
Received: from localhost.localdomain ( [116.172.93.199])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 21 Mar 2026 18:58:14 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2501166162289827961
EX-QQ-RecipientCnt: 23
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: julia.lawall@inria.fr,
	xutong.ma@inria.fr,
	kexinsun@smail.nju.edu.cn,
	yunbolyu@smu.edu.sg,
	ratnadiraw@smu.edu.sg
Subject: [PATCH] mm: update outdated comments for removed scan_swap_map_slots()
Date: Sat, 21 Mar 2026 18:58:14 +0800
Message-Id: <20260321105814.7053-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: Ml8T/6JCI2CtGlMAIE+4Uv5REzt8blTCXlgvMWBH3EjCEVTRahwIpgBe
	3Zli02NPq7EnqO9jKWuLNtH1aMIt8Z6Thcs977Ta9dRJiZDhE8/I6ifbxHWIFfYFezXIrMN
	97ZeA9w81TnvbK23lZrxLahdGSKA61Sbe/t91u6nIeohlvAjbDaIa8K1bPnpYvb+P0eBhq9
	stj9mmua0cXAM53pL8ulP1GJpPDJvpJqOMPQk1mNQR//i8OeCh/fmnmPlMUh1M95X+/+PP/
	kcfcW8D4spoCUownF2tO7ZsvDgWlTQbnCCk36lbgaWANVD3rwl5ykkIwqxlkGyUO9im1QKN
	xqeZ5Jhv06VmNDIAT/QYcmLpIj5xKazuQ6J2SYsa5fXdLsJ2jlPwhwORGUpAEy0wHM4UOq/
	StkdsYNI+z1CUlCePCbbu/RCCcXFsNrpalb2c60nH583pTPW6TvT/mjTLgl242hxLBLOd8W
	cNzU6PewqmdBp7t1v/QFyvaCcwepNLzUM2w+2BBl50Sq0DZvHuw5i5BSyS5o8v6WrDh5REL
	nB2FeaSzgd10pTF3x2uAfnfsCEffG4T/xPEdA/Y+vKl2E2SQudMtqexFqiP3GEGSIs1Yrps
	U5N2XrLPujY3VLGOVh5QVzJrGqRluwINbqyWlDFqjpB5puuKdKKQE2ur3XtzehBiAyRJfxb
	3WJviNJzrY9f+taQl4hCbInhhv5yRfNXacMOkaalYqx/IphSl4bUkUGQcsGkjx2pZBlK2ML
	VaFWRdnN0fp3/qMKEWMx9+6f17buQNcwkJd00LiunqTh1wHSziR2pniMf5fZbzkrlaFGfm0
	+7B5Cqe3YiE9ydsFbiwfN91OzfaHJ6lk1wMSdycqoItGYC14g2grvKdzGku5XXJugyudnGV
	MmDvDfVxjwyYe2cjyQol5RKAs1hauynSDoeVlF0pY5lWDgB5/C2eDlTfUl+R1OoBgGGvfb2
	7fLBgrBDXTPRxolr6qXm+v2TK6gw0CyTw97tcX0buhTwhfVuuvh/f+tlvOFA/Llctzb9dUS
	Tq7VxbxAS7xBZexPXCIURzgrTYXmFtDU1pwNuS7J+OUYnaQKj+pHoGLjHFoggm4dIdmLM5a
	uJ4N5CCsQBgt+t9kSsLVCOTaG0p6e+bWtY02CN+H9bR
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: qaztm8f936poyw6q11prtsq15dszzcc3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 56D1FA0007
X-HE-Tag: 1774090718-720119
X-HE-Meta: U2FsdGVkX18IBEo1cq5vzcSaoHMA6HnaTtavWaNC2BozbuLV8efWebphZn+UOooCvw9C5AAFrSddimHvefuPF/cEK8+bHSzO+qil/xscpJA8B1XI/RO4XPebMtzLEsJR17zkoQeweXb1/k+CVZKswDODGB704v6mSZNdE6PhRSYhkOmTZFWc4Al2BVGX1QCnfjvgzQqyyzN6NPses2gQqZXSl/x5lYmAJMUrI733gFr5Yus+qVaCq4xpxfb67LVvTZo1uLwbTKYT4R1IiuB6zRrWfYXtVUmmQd4b4pj4bKF53OytvQuO1mePsFM7Auu4kGi/PR7sT5tQOk0f7X9vo60xasyp2T6Fpeifv6eH/j3eLhG6VqknrcV2O9dRaPxaqzr30v0GVM6YpdCh76C1jJgt3cfbt/AMd4gPKudF5wCVgMUxrOfLRBtael1xysOd25lBXFT0QxNd+iNIwGn8T0ApwwZ/N5J12p8f+k/uEucgDmX0hP95FCBEAm1VKbr2wsZb1eOsfDmZd4LBDtej5NQugMpwNiIMm8t/HjGwfpHL5RwE9jijKgU1bMq03Dc12D1zf8h6facgEhHn1QV9KB7zORhpo4jnkQoFI82O1YaXEy+lmv2NNylMLgDHQL9WNQyhqu4DRoyWLdXvkMePd1OYKcXYxsTo8tuYcS/XoLz22QWcTZpNYRsbUbPYy/Iwml5Mj8P6ltHEdUOSDHxBUXd5an8sfonOPIRYN4SwEMAFjcsrmM5WjPzh5V2QPLWTL16OEnTBJxp1D4rdyYRL0VRCw+dsGryrWLboPHeYccG+Fj9aEzXoEshQPtjLQjBpnhkBoumJ4+7ki6fJ5VEJDlQQj8pHAxUdBPpgZj1ZX2Vud6zqy5BZjghccq5/fi4HUl6dC8IvZt78XXfAIARRotbE590k66fDCFKAzU8378ovYoA0bQGqdvJmuzzS4Mznuw8sVvY/pU0rLovMF3b
 zQ4jW7J2
 J8029eoWDcMWL8VZGJYACPPvW4fpzGp5rjqA4NWImwmezYfGIKpJk0EMYGazGfeVylTSN+hbkSRB8oA8j1mzb8hsaraUJbEYqsbPh0r6bt4ixNN/wv5nDgnESwcTJXiyWulMZ5BqcmKUiSK0il6CwDBP4lRHg5z3XGlty8ZwlS0HB+Mu5dpxg6GgL4o0Sha5fLyiaktmr8hBjUEB4HhLz8PYdp7oFuIJfMrqtksqQfRWHEL5M+mrUfEwoCJOltjJDsnoZVBojU/rjZqhJGtvhhHC21W+HfCzHOVK4S97uHQhAOk/mo5JGIdmgawAYHlKqOHOnGVKrpgDoVHjEZX8S6DNCllwRohQY8rfQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function scan_swap_map_slots() was removed in commit
0ff67f990bd4 ("mm, swap: remove swap slot cache").

The three comments referencing it simply noted that ->flags can be
updated non-atomically by scan_swap_map_slots() to justify a
data_race() annotation.  Since the function no longer exists, drop
the parenthetical reference while keeping the data_race()
justification intact: ->flags can still be updated non-atomically
by other paths (e.g., swapoff clearing SWP_WRITEOK).

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
---
 mm/page_io.c | 4 ++--
 mm/vmscan.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index a2c034660c80..330abc5ab7b4 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -450,14 +450,14 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	/*
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
 		swap_writepage_fs(folio, swap_plug);
 	/*
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
 	 * is safe.
 	 */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..0758ef3b100b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1070,7 +1070,7 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	/*
 	 * We can "enter_fs" for swap-cache with only __GFP_IO
 	 * providing this isn't SWP_FS_OPS.
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
-- 
2.25.1


