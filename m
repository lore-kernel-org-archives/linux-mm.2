Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4769DC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 17:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108D46B008C; Fri,  7 Aug 2026 13:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BAF76B0092; Fri,  7 Aug 2026 13:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDCC6B0093; Fri,  7 Aug 2026 13:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF5CF6B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:13:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 367EB140123
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:13:29 +0000 (UTC)
X-FDA: 85075119738.30.4F6D1DC
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6CFF940003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:13:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=AY1myDW6;
	spf=pass (imf04.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786122807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K3BbygswI9SirNkrlFNlq8ARPgb7zU6ZFZ/03Baxhe8=;
	b=6Heizt/uz0DoCZUFbDVKWNCIX/xtvUWpj0Y+RZ+VQGkv6fetmbaeX+kiljjhLMGX4fZmeI
	RPxIIXL/ur1DtXkZgzM7qswR+zoUjd7t5d4tNJpQe5toaKXw+VVAh7YMoI81tW67Lc048v
	Gy+m8kuviedaYRHELXIcAzolRluzFXI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=AY1myDW6;
	spf=pass (imf04.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786122807;
	b=Exrt9dVfgAUK8aTFwDm6/yoD3CTLAvvzF57KLnQ6nnDYrN8UOvz6BtdXuXudh2qiRIfBNc
	xGhMCUmdlYkEW3/6HSpSdKt+r2nhONZB1itlOzXpRZOVnuRKsLq1amMhvhyhqM+Rlkl85t
	wG83J8oIC/qc6vgHLbV9I2YnFAxtAjg=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hGrMV4Xsbz1XM6JX;
	Fri,  7 Aug 2026 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1786122802; x=1788714803; bh=K3BbygswI9SirNkrlFNlq8ARPgb7zU6ZFZ/
	03Baxhe8=; b=AY1myDW6thkncT/D9fi4qkmsPndStwdeea1fNG4go9OQo0yjxnc
	fBrfh4xOJKySzmXO4+RJfq15QJ+SBy7zo8h8hiL/NCe2VP+KX0Fzgc8YE2v836bc
	QXuXz4LB8NcG9hHrluXUB9uBhbmPMxqBye/0B2Buil994USY340kITjZJ3z+CKiW
	z0287loek02MFIYsMk8bAJNBv7fENNMEDAZ8jk8stPegojz0ivOQXmsr2J945Gq0
	WWdkIWFpIDQ2dED8s7HwUwEJ8PkN3clJBFSUVDo8fpdBKzawp6nW4fhH7+9hAZdl
	jix43IgZAMIQciEyiDXFFMSEujWW8brkq1w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id op4pkjehLSp0; Fri,  7 Aug 2026 17:13:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hGrMP47Bhz1XM30g;
	Fri,  7 Aug 2026 17:13:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH] mm: Make VM_FAULT_RESULT_TRACE compatible with sparse
Date: Fri,  7 Aug 2026 10:13:10 -0700
Message-ID: <e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6CFF940003
X-Stat-Signature: n6mkxm7x5jcakj71dwu1pa96a8gtuhx8
X-HE-Tag: 1786122807-370679
X-HE-Meta: U2FsdGVkX19Vxz3IA0yikfAzL8HBaM/6T+u3NTTmA/t6YFH5LEDFXFukl7xWnyz131MDw+q5zJdYASHP7fuSu9GRjvCb4kQExnzsYkicCIhRoGwaa2RMdKfoR1lXpKVO3rNdBEY0cxCPFywCYyOjygw1Y/0v5ZJODY/MYXPAyfV/vxgcxxmtWqs2JKP1eLy2I6+qKH8jLSrk/ttDrCyXEMuGYe8NVPNSISvPkOxY0ITguR6GlBAQ019vVvsVBLBsQLTFGhLuHs7UOMYIvpx9kVMI+enTuJriWrSAsrsBwfjDGCsMam1DLiRgrnQsAjQ4GdX2RcYRY/YmJnRbidnrPkEDxPWMmMNZjnWz9aXFW0cJqciBf+AnnpAe86a1Xl2HOTrhdOD6pYV3cpQF36VAdXyzh+Usfs49VQiYu7/ToZGOepen+sIMcN/cTcWwB/l+TOC7W+Co1AVswcbfNuk8CI19s1xMqoDF3N9unPFJMIWK0/4r7HZh+UjpFrLQuXI6f4bEEa3ytsF1fvIxLmXbOdKyHOBmr31JUSZCNFh4TdS06dEY+alNLEywI+DcNmz9+HDCt0xrCWWnJ6zALuvyjHkKTfPWk2ckwj7aU/iPwAQnST4tdq+ZMzsODDHraO6YmAZJp0VS9pxQ/q84GjrXTGgd6UP8qfMsKJPTlWbreplZZgB08OSDKtbqVwl+UYhPr9qhNUuDIIxNnV/JOKFiu9MrXENwTsfFEiY5KLhi1+odybk4kpMs5U22ew0boiHJ1G8DXlvlu3QqBZCsUpXcVEj5OfB5PDTVXH3F8w7h5B6dOjDWOg1S0QrDqGEmeI5+9/u9ym33A7r1E/Je1kEo2VBwhDYp4/ihCMVPgpJEz/80doPWpDXmiBSndKQm9AURiEGq0+/R4nMzSiVAxsPGx6c/FtL5i60P9bVtvHZIWdGks2YYOSuTc+vbzZdAQoXRWYZJMsR69oe75T8IxXl
 bWBrC9Ws
 EvfHRq8ZC8R4zG3jJ2Gt/km9JDed8CFSRTVEopL1J6XerztbmuTtWZZxvTJ+HwLZEpSJY3zBNXSC+AVCRuKGasVSx3haJgvxsOzK2hei2lR006NV/2oA3+wckHPgJfUU3fvVp3mT4lMZ8EnxR6vDTBAxmryjO0J8uhJaQU+hEYZq2ejdUNq+GrwvBItwv31s+PfXilXuH+JZI/fkuoTZxsubkhD+LmDaywP31lcYxfjbFrjc9yE8jjLPECEsazgZBZFlI8sxJxSJTyL5B4v3iLVPOF7NeTpvUEuua4sbi6463f9fFOFezNTCua3MAr3nimL46suMuCA+d9mJl2wjWEb4/Y1+5B1VNBG75khrm2lg7H8oXGQjOOma3x4VF/yaHHEJg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix the following sparse warnings that appear while building f2fs:

./include/trace/events/f2fs.h:1469:1: warning: incorrect type in initiali=
zer (different base types)
./include/trace/events/f2fs.h:1469:1:    expected unsigned long mask
./include/trace/events/f2fs.h:1469:1:    got restricted vm_fault_t

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/mm_types.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..fcd7d6cfce0f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1703,20 +1703,20 @@ enum vm_fault_reason {
 			VM_FAULT_SIGSEGV | VM_FAULT_HWPOISON |	\
 			VM_FAULT_HWPOISON_LARGE | VM_FAULT_FALLBACK)
=20
-#define VM_FAULT_RESULT_TRACE \
-	{ VM_FAULT_OOM,                 "OOM" },	\
-	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
-	{ VM_FAULT_MAJOR,               "MAJOR" },	\
-	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
-	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
-	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
-	{ VM_FAULT_NOPAGE,              "NOPAGE" },	\
-	{ VM_FAULT_LOCKED,              "LOCKED" },	\
-	{ VM_FAULT_RETRY,               "RETRY" },	\
-	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
-	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
-	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
-	{ VM_FAULT_COMPLETED,           "COMPLETED" }
+#define VM_FAULT_RESULT_TRACE						\
+	{ (__force u32)VM_FAULT_OOM,                 "OOM" },		\
+	{ (__force u32)VM_FAULT_SIGBUS,              "SIGBUS" },	\
+	{ (__force u32)VM_FAULT_MAJOR,               "MAJOR" },		\
+	{ (__force u32)VM_FAULT_HWPOISON,            "HWPOISON" },	\
+	{ (__force u32)VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" }, \
+	{ (__force u32)VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
+	{ (__force u32)VM_FAULT_NOPAGE,              "NOPAGE" },	\
+	{ (__force u32)VM_FAULT_LOCKED,              "LOCKED" },	\
+	{ (__force u32)VM_FAULT_RETRY,               "RETRY" },		\
+	{ (__force u32)VM_FAULT_FALLBACK,            "FALLBACK" },	\
+	{ (__force u32)VM_FAULT_DONE_COW,            "DONE_COW" },	\
+	{ (__force u32)VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
+	{ (__force u32)VM_FAULT_COMPLETED,           "COMPLETED" }
=20
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */

