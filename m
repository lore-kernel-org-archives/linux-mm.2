Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 239EDCCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869958E0013; Thu,  6 Nov 2025 06:10:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819C28E0002; Thu,  6 Nov 2025 06:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730228E0013; Thu,  6 Nov 2025 06:10:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6107C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:10:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29BE416037D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:10:00 +0000 (UTC)
X-FDA: 84079912560.16.741F4ED
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D9CC80004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:09:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=X5U+jc+0;
	spf=pass (imf30.hostedemail.com: domain of guanwentao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7a36Jqyydi+rF8x+eo6LeG6yiYsw8MXSkytX2sMwGMc=;
	b=6VedbmM/9Bq2wu4sARdL+GJsPdOmOiDdMz6NUDD0FQXXABtTIC/14FVpOeT4cLYcExz4jY
	PyclbD8/pgpxHCpEKOs11QharsCGNldvU32ZzJbNU5wg3mibU6fTCXWJl3MCTpRQ8JpG3j
	67wTE77DlW+cp7jgRNU3pgnFIfZlS+8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=X5U+jc+0;
	spf=pass (imf30.hostedemail.com: domain of guanwentao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427398; a=rsa-sha256;
	cv=none;
	b=JMDFxEX2num1kqMM35AKbidSMdOnT7bvIMusWlEOXCmFKTfcK3x4qQStAGXWFM1B2Jmmzh
	elmE/1wS5D/4CbM9nryfRz+aBBdbapKPOzfSX7a7ObNevo+rwqk/epIGyWhzudOskJ0y45
	tVoqJhJGHQU89R1Rkmdz+kYEWrnA6Fw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1762427383;
	bh=7a36Jqyydi+rF8x+eo6LeG6yiYsw8MXSkytX2sMwGMc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=X5U+jc+0a33TA/LWTWKJd4jnN5SnHKtVjhPpJlZU4MlytVK21hg7pdnwGCo7fhU77
	 TKlatrv9pAjrWnj67/Da9VYPoBnsiKJ7Hu0N5E9JyWkDqmdz0kID8d7IHQyB8qD/bd
	 g+Q5zUQCrHLMzQVzsHNRiIFQKxWOMe9Dl29stmfA=
X-QQ-mid: zesmtpgz1t1762427374t053580a9
X-QQ-Originating-IP: qJ1mXk2OsLLE8RePmt3JpC7RiJgxZ09hPSHLQHH/Pgo=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 06 Nov 2025 19:09:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 199588377174854463
EX-QQ-RecipientCnt: 8
From: Wentao Guan <guanwentao@uniontech.com>
To: Liam.Howlett@oracle.com
Cc: anshuman.khandual@arm.com,
	vbabka@suse.cz,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH v2] mm: cleanup vma_iter_bulk_alloc
Date: Thu,  6 Nov 2025 19:09:29 +0800
Message-Id: <20251106110929.3522073-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MuaVFG6ep5hsGpXMWJYEMyzUan7DwDJTy7uKUKZt03fytPdvxJGRMv9h
	I/d84tt+yauaquBVAqefD7e2zR2DmPbhod821T0wzFWK1iAXzACcxV7Y1HFq+D0PYsCUCSs
	lwo8Ww2G/D3ibVXS1Ba+lMurWB/nubHMBSiCejVpgGtcQZUvCsbC7DuQOllXqFvhA9gOM1g
	rTk9BXDS+FWV8sLXXOZyHZvSpNXvViJ6j/5s01KSbWhVfCLBJScTmZQNO17L2URHC1htIdN
	WIZo0X06baiFThlXAI5xcOl2Zh+sxHPOxcCXhXIfj/t/q6WIqjiKF4EgMjPB17KHtFNrOB8
	QPtsK2vmxlCfOFkgBuGPRXVpaWXSdNPVkUZQr+mksiZ16RC+0bCT1gwVZQ2KAgeMLzpgeVe
	3+d31rjoMGZSdp1411XJxlO7YAoJ9NQkklPfwjGAqYoQ9ZfzEh/59Kii+C8ZLAUNVder7Sh
	EwEWVoRSvA9KUoPKqemH/YzgZySDtMZYVT8JszXDBy97EIKB39k76g9AjLf/phnPcTSjqhH
	2dIXYpP0heousbdy7fcEs1tZiggcAW+Bx7cRgtduMzeFAshoLgjcfCV468gmla4iBzjpvKU
	BXwByqKzfvMdjWF0P3A0lfQfbIvStKq+jU+WiMGU0WRKizGH5xJ9D94GCL+rqCkiYzOlWfb
	DnVPdyKEtJOzQ40ycFRWQR59h62cEFSYNT3amIdV/4Vp+oxt0beWwWE9FqPWgmCZjr5xPo4
	QNaPX0ere1DWZBi46YOQ/BwADWs/pk75U4wQbghN40BMSN7JyFnIphjhOllDIz+1PvqVjtC
	OMP8Zr4a0b2sWTN5q3M2On2OstrPRKNZ9DxYH2pUhzchlD3MShoAIVwizWWv4abVnPBMCA3
	Xn2BEqls9YXTqHRiSRoRKoxRwH2HyjCTxqUsdgcdRK71zHZeUrTdiKtdlelSjrJApC5gtta
	Y3+kmmk4My2TqiLMZQ5STWp3xkynOJ1ly5BiCVQ4lL1v5Le0mAJ8eS2oQNoWpuvQEUaAHFh
	IV5FCmI36Y44+4IvdTeAhJ/jZOkIH4bROaD37zKNvikMJ9PsJMPBEKP6jfdVLLvdq+ukTTJ
	BlhIT3WJS+HfvxJKoRKtNOebDt84lreDBtWaeIfyF/40sOBNqMJsfA=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: 6D9CC80004
X-Stat-Signature: 1taewjaezb85341prcbxxu3f6i6cmcua
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762427395-862047
X-HE-Meta: U2FsdGVkX1+B9ZGGvsAHuq5MKmLdbDyk3naVzhrDG/uBws/GDdqUiV3HwErs7gAqsLxMZwdS12Y7JPVxso4L2yidGQ97s/EA4GWLH84a3o/Vv0IOKWLA0zbLMYomJUoeSCc4aTGabVlqyWgu28PeQyzx5G4H6bGS7Qr5WBE2D4PHZOanGf44CYycAPk7d0b1+68MYNnkrutms4T5uOgdIEoAmiOaiw8ZE0FCrd5XSLBbMyC96SqzVf5BYXwaSKdsVZShIGMfYPlC9WNz6qXeJQlT/CtWjQgZo8NHwokPjepw74u0fV5Tv/ONfk14vLWBW1nmOnxERbncS/xvVUG9P2K88MVSrVTaPK8MJ5YFG8fVpwJPr/3UzWH3gglqf3iY55zcUd3yt72gL/SKME6XkkYWcXNSGMD6KMUg1fciOVOFBBT7aQnYcfN7gz6ICbeNqiV9axORLTSUa2pKS57HNtHrt79VyYIz25qQwd3K7Te9l0SI8TEN8nygdCe/lXrS/IhMPwRmu1mftZx7whgxSrTyewpIiV5k6Z17SpTbSoLotlJkWdO8G1mTma8U/CSz4KsBQJx0M5NGvF8YjMeWEiGCerWUlSaJtt1DXGUAnkHmxZ0XQunI1//UudeUzqLU2uf0n8zTeGhlYtsx3/0p+eKvoyCZBTPN6kG+/hSS2keMyFSmAZS1TjfIjXi9fg8jsVBIuDvkKeVQCxo8chh22qibBCQAoIy5TyHhAZo2oe8h/iwQLciP/VJtqde79iG31F4vThsywP23BxVn0HqQp9/F/DK0WfqZYjCaoLVwPGZc3CuT5OyD7FfOWRgJ2FgYfjLUu2Ox1rMNv1sQIS0dfxfGvf2IgToFH5rZ2UNPlQEI1NyC3ib4hUJ3H9hJkZfLgHVZgAuEIeG53cDMxBvgzHFvgcn16GeBbQFz7n91ybHIHltVWfZoPP0e4bU5/VFsUiI3vWg0psD84HO8Wtr
 HRnWBZQC
 ESAcGQK3V3RsIG44iIsLCySb+GofIVU4HUDvOqSEqndd3TK99cGE/n2TSC2CIJAqbuDegUvzrC0/i7KMgK1U4gJTiVzFo36yLERwdXUiUeccaniuJF9jB1tatQJRYr/wdqepP8mJZG4A6UCHDABZHJ/ma8hiAaAySsbrf17sbSrik3xPJ3N+Uhuh7tcBfMN53FPT8RmRzn5/pWDTK7Ztv1/IseBbAVkNpTApCbgk//2kun/E2p/xgMrP6kcUCNobT9+igQL9upi22iOQf7Gt9hTGg9CTYL+0Hnz1rT5Q5u4rYDLYa3MedH3ahDlCICtoTRaEadwq5KS5i+NQ0GOeaMrbhHscezDl2+KGSWoFjF2WZrRtR+Gmg0Ge59mkzYL+TfdOleFV9cz228Uc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()"),
remove the only user and mas_expected_entries has been removed,
since commit e3852a1213ffc ("maple_tree: Drop bulk insert support").
Also cleanup the mas_expected_entries in maple_tree.h.

No functional change.

Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
v2 changelog:
also remove mas_expected_entries from include/maple_tree.h.
---
---
 include/linux/maple_tree.h | 1 -
 mm/vma.h                   | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 66f98a3da8d8b..f7ba53f3f9035 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -536,7 +536,6 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp);
 void mas_pause(struct ma_state *mas);
 void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
-int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
 void *mas_prev_range(struct ma_state *mas, unsigned long max);
diff --git a/mm/vma.h b/mm/vma.h
index 9183fe5490090..4aa72c7e94400 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -498,12 +498,6 @@ static inline unsigned long vma_iter_end(struct vma_iterator *vmi)
 	return vmi->mas.last + 1;
 }
 
-static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
-				      unsigned long count)
-{
-	return mas_expected_entries(&vmi->mas, count);
-}
-
 static inline
 struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
 {

base-commit: dc77806cf3b4788d328fddf245e86c5b529f31a2
-- 
2.20.1



