Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A2DFEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8291D6B0089; Fri, 27 Feb 2026 11:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8138C6B008A; Fri, 27 Feb 2026 11:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754936B008C; Fri, 27 Feb 2026 11:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 615066B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:33:53 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00BA2588E5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:33:52 +0000 (UTC)
X-FDA: 84490783146.26.620B6A7
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0132540013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:33:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=INYuLY70;
	spf=pass (imf17.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772210031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kQXL4k4vaoAwO/08kBSmbP1pYahNUXnvrQkJ1Hx7w4Y=;
	b=VpAyebRXlP4TX9xfc+240rkW1Ohg8MgBTmTqJ6OudOhCtgLjtwgwA8Hg2eJ0gAmXBqF+O8
	/2q42XxnPgQxoyJ0s9iBHrPQ90wn7iu6R4xlltf4+AhvaRWPiibQgGfb7v7juj9IIeoFMv
	K6a9O+d1KjF80NbZ18LtQZM6xwTykpg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=INYuLY70;
	spf=pass (imf17.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772210031; a=rsa-sha256;
	cv=none;
	b=rMFbksEfx6FFB/7hPY1wHJtoyy4c5ynNzpunTmKuXsC4DmNFPMRf2qsI0UEM6/hzuFQkHc
	tN8dBm5TGmjOMzOl48X4bjpooVsr/yils8SRowDtYJ60kMwgy9leWwhE9z3ffX1DLaNBUz
	da57HSeQ+L+4aG63EHf2DYTLMQnBlvI=
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id D098C260B7;
	Fri, 27 Feb 2026 17:33:48 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id eluT5zvIjBcL; Fri, 27 Feb 2026 17:33:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772210028; bh=1BRDZ6KfArhSOUWxCOXleAvjBFxgRYA9XpavAbLIS/k=;
	h=From:To:Cc:Subject:Date;
	b=INYuLY70P6XaGhmxnysrHz6mAq1IExmenhyzL+pk8dpVNsCxp4IRPeEYbCEO/W3YH
	 88Eb/kxtS5OAQ3DuXzvn/JtHJnucRgt6oAjdiq+fj8UVlL7me5zEJJzcbQ/9gsYU8e
	 YPZ7804Ze7DP0OEtYmbmdTuuD/UYYaDn+ylMPN65BJRLZX3cSByoVLNbhf+v65tPUb
	 H6QU5QOozrbLkWZ8uBFWxkl8PUrHa0nkV49VTrOL/y4huv+iC3T+UcKNviqZp+x3E2
	 7O1U/VPSv/NQfYYvjJEDQr9ll4magRWWmWKVPouHkM+xYVuXBMA4heUHuqMY0qSGQd
	 Lh2aRdt7pPSRQ==
From: Benjamin Lee McQueen <mcq@disroot.org>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Benjamin Lee McQueen <mcq@disroot.org>
Subject: [PATCH] mm/vmpressure: scale window size based on machine memory and CPU count
Date: Fri, 27 Feb 2026 10:33:33 -0600
Message-ID: <20260227163333.6394-1-mcq@disroot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0132540013
X-Rspamd-Server: rspam07
X-Stat-Signature: twzwaph6p4ug73iscsmwy6iysucwi6x9
X-Rspam-User: 
X-HE-Tag: 1772210030-936747
X-HE-Meta: U2FsdGVkX18Q18rnLPx5HDDohqgVzGtciejEXoNSTWzqOMCeElxWR59ev+XelB1Zuj9ufoIEzvaj+E7mcfvYF9BA3RVUoLyLqUc8jETY6PqUqwhicVUzVkM1gdw50k5aKFy2GoaF7ewIP/xeFQVCdCCOVXN1kwdT6pbhtunWk7Ss014g4HdbUdqcrvrcKWJ9DgjrUPgBQcz7Him2PAC28jxsEHgqqmmetjPFgxmyN3S0TEu4HWhLlxMFp+l9+6/bPpJxQ8IlCjjsjoMNqe8u8WO3leVPKGghEncHHB/+COkIpAqUj2bpi2xLKl3t2AZRO7WXSK8r690hUOa6qpx2v0lNNhguDqDj4HVGHSdaQ+xRquxmCcUV+Zg4pUVG3PGwzrFxC9ZDTpdG2aXV+L+YJy2dyqUW/mTt++c2CQ2angoGTqCXe3qRDC9ug/u9NIM4r3hTEKomgu/2CI9V/UzV1kbxMRKWiELoPO13N25nagdUR8CO/uX8nOQhlBZxV+odCy1yE30g7NQinRY/EYTbuTdQDO/fIW12q9K1yVMCpB+yS21EKMAcP9L95U4jcjFPSFTTpKCUuZ8NjJGwmYP8vz1sAEWZRsY/7nF9hf4jY2QpLs8Y4uLbm6e0nVg9DzwhrxPT5eVkjyavY4ixTFoOmLrFo5UxzS44UK92E2d4A3636TsTV5YI6dvSQq1+ZS2yNkkeGOqhtas+/98jbJtuSz19x37U+DqxYa/AM/Wrs76x/JhbsujcEXVue02lwqHzfvmIxr98N8JKRGCJtBm/OOkS8sero/pbxguXzPXiDesXv2TxN4wl/TnbIaA/R+CoWc8LqsQHzJ9lh1ebpCtBHaZmYfmINCqmibUofBG2bXey7lo1Lmj0e0yDrZbRufVTDe/dVylZciadjGTU6n2pREehGsEKnXe5jpJJHJIPrhGNkN4RiEUQg1ZQ8B3ziU6YskJ0OHWQ0PabuOf6IUn
 cXBPV2MV
 lTerwW4fHM9qRROp7gYK6TY5REoW17rR8heS4cima73vH8s55+jXuHDOpzLhKQDJOG7g8FPo2k4GZXHjmD+u6887vgCSm1bK85hkRKiK/MDm3/WhrvdW7eFmC/rbm/P09F07wpUPGppK4MKFl+VFpR1Tu3no7lmsDu3NMqvq+2so4CoxVq1Pt3nPBL6tbvqBkzxcWpcrX/0qVsNtNFGTB0xQL3pH/IlW03bRDWkNhrPqi/Q+43kl9cHgsEbwMCVuukiZf2I7vDJQE9j31pa2M3UwRTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

the vmpressure window size was recently fixed at 512 pages regardless
of machine size, this patch makes it scale based on the machine memory
and CPU count.

Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
---
 mm/vmpressure.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d..b2989c70dd39 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -32,10 +32,20 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * Window size is now scaled based on RAM and CPU size, similarly to how
+ * vmstat checks them.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static int __init vmpressure_win_init(void)
+{
+        unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
+
+	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL,
+		2UL * fls(num_online_cpus()) * (1 + fls(mem)));
+        return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
2.53.0


