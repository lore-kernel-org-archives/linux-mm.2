Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B59FC4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 03:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D01E6B008A; Mon, 20 Jul 2026 23:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A076B0092; Mon, 20 Jul 2026 23:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324296B0093; Mon, 20 Jul 2026 23:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 035F06B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:52:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 786C5803A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:52:59 +0000 (UTC)
X-FDA: 85011412878.30.53687D3
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 253AF20002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:52:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=OFBM8Ll1;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf31.hostedemail.com: domain of chenyichong@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784605977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zY79sr8kjVeHPbjSxuo3LSPqqajUZP8hWgccVp8Sv18=;
	b=0PT52UbrvF3vDpVECPllmwcuHUyaM41hLOcnPxTZQFhynLwazMMP6vM/IR26Quev+e3aLe
	3cMyjMHcc37iwYDhct4E5/m5RYvGvPpNCF4PYhas+ELfUMiv28c3a/X+z4Rk7iqEjhCoKa
	579PWUJSlSJmm98oNFEun7giPDwBwi0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=OFBM8Ll1;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf31.hostedemail.com: domain of chenyichong@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784605977;
	b=txQLsI/wR5hB3NZJ412QZAIpRGJ2BYnY2dXYzeqPwHG9MQ3xIhBRaiQnRmLElId6a1qnhF
	MqZlrzQRn8oO1sm3toM5/HaTA5AazlNFlqt8DHTeJEnkwkRORH7NJJOD4raOZR986suLdQ
	NQN1iFy6lYllpHI241VLz5cieWHBd6I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784605948;
	bh=zY79sr8kjVeHPbjSxuo3LSPqqajUZP8hWgccVp8Sv18=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=OFBM8Ll1JDeuoEIf6hZZOflZhhpQHuGjUF84bfWqT89JJssvnaVXBGlahLBtY+tWl
	 RQtQiauj+by8q3fCJVcK9TsU0PyhDM85sxdZzVXq5K8YudU28b+HEeij4eb7myeYWu
	 yHLIc30So1bQLMlxzON98VcgQ8a8QIO6Lg7pzvIA=
X-QQ-mid: esmtpgz15t1784605931t9189992a
X-QQ-Originating-IP: aUunXqQ0UPlQn8AHkHeYf9BotVgzzkUO5DceQIxvYzw=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 21 Jul 2026 11:52:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2443382836857113774
EX-QQ-RecipientCnt: 8
From: Yichong Chen <chenyichong@uniontech.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v2] hugetlb: evaluate subpool free state while locked
Date: Tue, 21 Jul 2026 11:52:07 +0800
Message-Id: <20260721035207.1437935-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NDxI9psdf3YVKQxzh+pLbeJcw4N5/iO+ftLCj4XefDB7p/DbUHhJXy+b
	pM2iV1IlB5ix1X3K53MNYsp0ILfUWEB1hCTzXxGF9ibqEnimirucD26PX8nm+XRqo1nEigz
	EpMo+2sve32o8Y6xoWfN42821gX821yE3cRq59zjCeVKx/6TFzRm1NPRrJbguZwdTCEDk4d
	8vxe0BII/BDX5jMjpjjvP02wzhg+2l64kxzk5MbPLgMrh+GmxbtMt4VOGLSBnpegoX0zpZU
	LsM9HTzTRO6dDVXTulrIzgSYZsjFotd4wh8ErOAmu5NUIW0FcmC771q9H1iS6tnP09nOyJ6
	SYHloRZOFTvOKfmptm7/4oGC2nrLMoVHvZJmWEB9UuGfRPqxskz8kMCKTD6a01fsJupQLaw
	YtX+Sz7cha7X4okYRMhjiojo+LnHISV0KSrLMdg2xUNBcdbMfB5Q714KhbOlC9Zqclrv8MM
	qv5/MERlUgGd1bT0obvia890w5LQAb2xuRzPLjvwO9pSQJgJN8FPjComIhJ9Tmn5MxmJ4fr
	NekMQdkBnP/4CtJvFF0WTb748FjWokqTru6saHTFrwazoMjzr3/jTIafeXDRKflLR29tQ/a
	WeUyDTp08A0Nj1/+Oo4gqzjO2kSt3zVdM/BC0rNy4NjFkchrAiLFqTgwyAkor4X3pIM2gJb
	dxF1SZaJVfrB3OfCiiD1rbZjP5r9sTD1Y9JRG7vmuje/JjJGL09iYWmcCMRE2oa3ARq2oeC
	kC1kF6dEXi1YDu8TFyo/CnyVGrvt9G0s6L2vW0zHb2Rj1ZI0gJBBkV9ZpNk95O3DApS/NXF
	IXQngi7kYbDsdxJsgE60QWVRPplHWnscYNP1+D8rHC/A5Wkep8zHzFRVjZfPppC0Mz+ngAx
	KSIi0GkLD8V3TFwJux2USgxELuWcZ6DFKO4/UTyfctmUgs06+eHYE2DYvC+TRfbEItjPZTA
	YpmLsRpiFhGxXSFea9SC02LuZzaxgVeITCbu/Zohjli0t4TcmhAf/bvugy6tpm+SY+N2TRT
	/9h3GJ7VuXWpRGOCv8
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 253AF20002
X-Rspam-User: 
X-Stat-Signature: m9t8de64g4f5tsbpmqx3xqyybaednmai
X-HE-Tag: 1784605975-32375
X-HE-Meta: U2FsdGVkX18Iz2kYam/Vqr9phFUO2ZT9zUwZV6EBSIW7CdG6OIyzOi6yUH49F+8gObf259dCIAPTDgWtl3WrGSAutM8KQ6+vdK1VH2E2Azxv4NtpNu8tJLBXoXV68AXnj0y5W0Dfq5X2YZI/VQnoggq+SgIo5XQQS/p4AbQNPs+6tONbr11pRPS+KLPutm+aWYAvs98gW+5Q3sCDyzwbNriNk3AoaNVstSBkqcdVBNssMJ9XbzC7HtGHKTmmiY+e2ZuYM168guVkeXIFuhpl18xYqLWf6FTtbhH6ejKAi6WpXLBfvzrSoaTGE7BroC7W5ZjJCYP4BMe9Iu0Bg/S3BENZe1LeEYdaa/gozwy5ngkKcTbgIFs0YpwIpompsJg4E1gYxB56RnOL8MMulGlbXa8LGza1TMGAb8uwtZRWi7zA6pMd+RWVrOk87q0M5eEAFSY0GfCPRr2kf87jQ3F71J2sSPyFlE8oCv/XqMJ9XTJD8FVyumQEsKfXGCT1SbxXvm3VUG/AK1U+GNuO/nWOnkcMUM7aZ9TVbeSqRPU2kXepH8qoxPyKmDwP2wYhcbR+gxkcogRVyXz4/oLB8TljJis3wpKWOb8GWIlGUYimeduGycB6XZNhEYvcsXq1intK9fgd0Onc6A1inoXOYlNztAjSwrHl42seiE5GuShRZ5UTvup+DpM0ZwYvhkBeCqEsipKIcOXL9vWjwbEtlGIYEJxuzNzPfBK+TW1ATg7u4jyoKoG7IqOev5Ccesj6sCLuJ/8WvRQcVKV6WpN+Odm+zA8+bW3DmrJuBOJWaUzKdkSv5LVMadakOF9g6qO6E3zgbIMaI2MRyvyVhcoyhs7tX/Y+CKQTPNZDbMMo4XfNyAqxGxupEhwRm3AX7ailKCyRvVNDR2TseojL7BC73iXZckK96crXZQaj4s4cr0GBV0xN1UuPssjNTT7jIVGNjQA8dK0/MGPn0Slbh1M6cUu
 7xwv1UtR
 GFhnYrZkgc7cjE+zu9AnPXjZYHSk57YiyzgXcSacD/RHQQseqoR6svPGI/E7uDraC8fIhY/CrI0wcrU/Gim19i/L/lxp1fai9+Ib4EmmmHCGU3Sf2yZWufWNF+mgNkt/UPjS178TCT3XokiLtFAMui7FDQtpTSj7+4Sl8hIA4n61v9JcfFb1CrfZl4KPXnDFX5dNtGiSkG0e8zqNam6Di1WaC7ySYfyjtPHb+9wCwZVyHFLdf8TyXqTYKX3KANpprv3PYH0ccWFAmp5JknCC0Woo4MF6HsLelmxiTjrPdaKDhwNql2ifZHlrhFynNOkAkpsqZf/ngRvbeRrX8A8LnfigPBNsfPR+QppUq6BrzvRdQoazTv2WLTEST20YveYXEZPRDeQKopMmFblGq31PQRktjDN3tg3HO+fu2YxNWwSTZtTYeSNvIRJSyXAEBD5dogkkb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

unlock_or_release_subpool() drops spool->lock before calling
subpool_is_free().  However, subpool_is_free() reads fields that are
updated under spool->lock, including count, used_hpages and rsv_hpages.

Keep the free-state evaluation under the same lock that protects those
fields.  The reservation accounting and kfree() calls still happen after
dropping spool->lock.

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
v2:
- Reword the changelog based on Joshua's observation.
- Drop the Fixes tag because this is not known to cause a user-visible bug.
- Add Joshua's Reviewed-by.

 mm/hugetlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e319c6a00555..46ab702c0fc0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -140,12 +140,14 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 						unsigned long irq_flags)
 {
-	spin_unlock_irqrestore(&spool->lock, irq_flags);
+	bool free_subpool = subpool_is_free(spool);
 
 	/* If no pages are used, and no other handles to the subpool
 	 * remain, give up any reservations based on minimum size and
 	 * free the subpool */
-	if (subpool_is_free(spool)) {
+	spin_unlock_irqrestore(&spool->lock, irq_flags);
+
+	if (free_subpool) {
 		if (spool->min_hpages != -1)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);
-- 
2.51.0

