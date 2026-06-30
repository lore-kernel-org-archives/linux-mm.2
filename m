Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF22C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7879C6B00F4; Tue, 30 Jun 2026 08:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7384C6B00F7; Tue, 30 Jun 2026 08:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64ECF6B00F8; Tue, 30 Jun 2026 08:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318806B00F4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:02:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A83FE140212
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:02:30 +0000 (UTC)
X-FDA: 84936441660.27.9506420
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE75DA000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:02:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjJnG9eM;
	spf=pass (imf25.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782820948;
	b=w7Zt6d6E7xPQYdl/zwUc0WuzInbgfoWGSmAzfImLxSSMIInCqZQtPocbnVjWAbZLRKZjIK
	ObtqKemkMnwKAfdRy6it3lSR6IKP3JXhk0tp+RVWMATuwQGRjx0QjXUAz1DYr1/83YeFOY
	R0ioGv51iYcf+80vuqRp81+VoophMEk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782820948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtOT+ofm/KMHAXBQoy8Xf77zwNZ6tmjUK28sksK7y38=;
	b=RcGLsBAlGRX9Gfp1lMvn/5IO5rvlYRFfi6eXKj16KKsHmLe2lh9VXw5dSe9X+0LqVxJdCK
	vFwP1cQTbHIiLdqCr23KBahG34+cPbkfXEjmlcGbDuEQ0/4wR+0KTsl3Sp3uhcHoexOhZm
	Tf8T3twGvxxg6UD6M/jn2D+OgbZrK1o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjJnG9eM;
	spf=pass (imf25.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493ba729dbdso3209185e9.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782820947; x=1783425747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtOT+ofm/KMHAXBQoy8Xf77zwNZ6tmjUK28sksK7y38=;
        b=SjJnG9eMQtoPINcaUXZTjnywWCa33zZYJUCMkWk4DzMxPB4AWj1Ectu5/R50pfyFyP
         jmQlxrkQdWqOWIXTwcvN++9RhwEbu7uEtqvLuVVAn84u0fi3XyNEtzD1vfb55lhji/ke
         y+Vj+st/LlnDehEHq1Y0cwR2CPLARKQOFpsJO7jz3gXpbOwefDWAT+wm4+MYStnlAl6Q
         I7NRG5caqWGVXCX3SubtdlPDV+grzMuX2aVv2NhVLTRxIAGxHtQlvX7vxV/Tad6hVi0u
         8IldVQ8pwajm1Yy/7pKyV9WdQCejBHE/9T6GPEJJqWCTgD5ue+Bxh09BTJX5ysZhYKdw
         +7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782820947; x=1783425747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jtOT+ofm/KMHAXBQoy8Xf77zwNZ6tmjUK28sksK7y38=;
        b=XkamCpzGrQjwVqDfIEUMyfLy0JiZw7Xmu2WDdna+FsAjL/nIWxJNG+GdWX2QkOqR3V
         u7BUXz5QksUI2GGwGFNpKzCQ7KVE0oMKq2Zd0UhkevWieEOxOrmBBqCETpYG3SfwitXG
         7lEmb2MloWha0jeIo4pPX7n5Hu6+YFF4CuVLgxZR7fknXFOATgqHUoDNnR+AaDRP2Tnr
         fQ8FIBy5liEz8fSGgP40T2Lm2b3pHmJz6fcUaPoFjnjFu3IGjjWuqG7J8vE7a6rlGzmu
         ZfRUULCreowpvQI14Lz8TtTz2PKyzR14qdcMeASL/NkodIwuoP7e7/v7r7g4BJtFYsIK
         zhjQ==
X-Gm-Message-State: AOJu0YwHlC8Gjy8fyCbd1bF55yZP45gpupPtpPh4MIYwrIJKZXUrOpfX
	f5mMhormqcMIAoJOCc+lzAz9PvS0i/zSw47nX3ykMshLOjknc2GQ64OhI48FcSAZXW0=
X-Gm-Gg: AfdE7cm1Ewku+RHqgZwidxk+OUDCjnEObjgBwpL3WD7I7WU+tqv991KQYAUhiWXDyeK
	6bzb5ZaFtEdDf3hW0SugDqaxJY94Dnv9lrbfMQeSV0E009/2+TlMC+C+VV+PEAjL+TbxPKpfs3r
	YtxWbAZ+IAkJZrqkVK1PEtG+lhGNaLRgxEyvqeDrb3mYjDoNyboKOGf/FhNRP9FjknVmdq1a3fE
	PIQaimmlq7dPQcYBfD2jAm6yKJBwLW4zC9IT/TCpr2Z2WUSUY5eRAA9OSiSjYr0P6zVwcNyr8St
	g0+4JBHosLP+SHrubscMsp8bUTPQBFqCWPpL/DjjgMUIEBPZRBeQS1OuclrvHXJuBBvLccFpb/T
	bdcO4zOxkD4m4V2qiLBcqYTcH0LzBEgu9auAWimjKMuX+D8akDsu89PTjOL4wwxVvxe4/LYx2zo
	PZRccLqsfX1+U=
X-Received: by 2002:a05:600c:1c17:b0:493:bba7:e9f4 with SMTP id 5b1f17b1804b1-493bba7eacamr28333925e9.18.1782820946110;
        Tue, 30 Jun 2026 05:02:26 -0700 (PDT)
Received: from user ([104.28.155.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b8cb62f1sm112720015e9.15.2026.06.30.05.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 05:02:25 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	yahia <yahia.a.abdrabou@gmail.com>,
	syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Subject: [PATCH v4] mm/shmem: Fix data-race in shmem_fault
Date: Tue, 30 Jun 2026 15:02:22 +0300
Message-ID: <20260630120222.11562-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <1d27c781-0adc-474d-9c75-899e63bf7490@linux.alibaba.com>
References: <1d27c781-0adc-474d-9c75-899e63bf7490@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zwzz6pqx9h6eboogoy9kt3znpikud9er
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE75DA000E
X-HE-Tag: 1782820948-975257
X-HE-Meta: U2FsdGVkX1/4dbk36uoch0PWGYYRU03ilpOkTUodW8eXTGH2lxm6uFD74/zCHhaIwyG+KWzJ0DolPkGmQFhzJUYdIx3IxaRxJvFEmjgvM1NhFUZHV2VWKLuaGhTZfuP50CAgdSL2hFWU8Kssa0Oof0CW4sYWqY7COJlRNN1kZQ6v638iDIZDqBK4jWW+DLBpH/kTZrSbO5x0Vh4ZUuzJwTtnsnbblb23ShmiS/mXYQ85q1vWHPlbBaSoV70K/D0nSp43wS0cDewLyeFkmm74BJqq0PKeBkqw8RFQ4hd5kAoMjkiWbBNCV83ZKyZtx5G6i9FEOAFb46FYya5/BDPF18f7cUP3nA9TAgn/hbGLPSa9Lk/7RUgraB6atSxYYlw/E2UMtdfY4FNHw5fO7avctQSYHTYF1MEjfJDiYEcw8ZUuRju9H28SJdw2XWrvyZw2PMyf2n9u0RsxDVmygPWIRnoX3ojR/Jv9ej/Of3CDmE/Yv/FqSpbJ9j6t+v9TAd6USdq4ZlBF5+CULj+Hogk3Q6vmbIvYXfYzxr2Ub0hP/uG9G+wqALLok/ZZFGpLA6Rqgem/2FYttbeu9Okpq41+JNWh/sk+f6fOlC2TgiWLUKlEuJMCt7ivWiGE5s3055e/1mlcdSM1efwyMCD/vBC/XPRzywuLU8jk3RqmIMAZjorijWPUKltwc3a6Izg1AS8fTCniGD6VOxTg/dTXw1XC+W9P92+MLcFJ/GpUSWUjj2G4z7cTWusFadYhfteBZmLgOcVwFNZDhp+ieV3wLKSrI1rr5Nz/8CjHcUI+2Vq75EOS02tCwiSQ0GcTCo0BSrVZ4dtXg7EmKaEdNPe1DJHuvcmcJUXSH9o2tudpxkiFUmzgaOwSbpeONdipDjLdpE+8F91vP0qkKBM7mUrScwduAlFWznJEfOABGlI5EzObrL2lqkSyueV5nxY1gRJ9qxbEVfCOC3MkbbtAEciZ++S
 oqlSRWg7
 btDhiBUJ/05WCBUyOgCy8lYoTyeJU1bthclgl4QNCSewcg0K8d+RLTHOuS1q+YM82038ju/TJE2vIXQEQqLnugXXAIErWc9HEAoGZE8fEMXKM+1lephpbDN2+afhQ+tmVr8+WV0fpCWFIMVRFpsSVkOmkO0ZRtwwz8ZfLehJ7jHSVOQuFyWZYzM9WcgLSIQ8gaBPYYqd0sSb25/LvFPHh/3ye/kkG23QnSBpsXQQ+aKtoxhjTU4WErlBryEb9JFtVWYydfkTuXe3kigViDsy/mk/PhZPSwMak3bwoDFrT7kg9Wy8Y1j6Xqt0rkVQB8xGvVxUbqa3n9AxRLzSHkTUyMnAe2P+p4wqi/ITWPvUNjsOgRKh0D5zFeySkXqZSikTuFCE27nhQ1vxItkUb2hUjWN/uyA0lkyaHjvD47Ju8XV6rHBEnFjV68mBGYgOFgZTNAiqr0yUhlhPiIIkAV4wK4aaAL9NI5XTsTtQ2FCrLJNRzP5zUhuGBmsgu8OEzYiHJaUAle5LpIA8Q0O95aVKe225kDuHN4u0ogtxj2IkAra0kE/fXcNr7CtaG1UxFczdIypLBSlA8nqgpV5YTOgqcEgludNuCRNbSLvSA4/F2sAlQ5AfEfpp5iav2Zn/B9DNMEk1eTM5Ma18XYZc643H7vcZC6i2KsOGU7EtOkNiia36v0umetDUxR+1yBXLOudjkDLoUK7RRT/GMp68JdY25HX+M0ErH0UjdKrBmdKedH8Pyml+DmKpFKnN2tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_fault and shmem_writeout access inode->i_private
without holding a lock, while shmem_fallocate is modifying
it while holding a lock, thus a data-race is created.

Fix this by using READ_ONCE and WRITE_ONCE, which provides
an atomic, lockless read and write of inode->i_private which
prevents compiler optimizations such as caching in registers
and add writing to inode->i_private with WRITE_ONCE to prevent
the compiler from writing in registers.

Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
v4:
- Remove redundant READ_ONCE
v3:
- Fix lockless read in shmem_writeout
- Apply WRITE_ONCE and READ_ONCE across all
  locked instances of inode->i_private
v2:
- Add WRITE_ONCE to shmem_fallocate()
---
 mm/shmem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..adb8431743e6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1657,7 +1657,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
 	if (!folio_test_uptodate(folio)) {
-		if (inode->i_private) {
+		if (READ_ONCE(inode->i_private)) {
 			struct shmem_falloc *shmem_falloc;
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
@@ -2693,7 +2693,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: noted in i_private.
 	 */
-	if (unlikely(inode->i_private)) {
+	if (unlikely(READ_ONCE(inode->i_private))) {
 		ret = shmem_falloc_wait(vmf, inode);
 		if (ret)
 			return ret;
@@ -3630,7 +3630,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
 		spin_lock(&inode->i_lock);
-		inode->i_private = &shmem_falloc;
+		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
 		if ((u64)unmap_end > (u64)unmap_start)
@@ -3640,7 +3640,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		/* No need to unmap again: hole-punching leaves COWed pages */
 
 		spin_lock(&inode->i_lock);
-		inode->i_private = NULL;
+		WRITE_ONCE(inode->i_private, NULL);
 		wake_up_all(&shmem_falloc_waitq);
 		WARN_ON_ONCE(!list_empty(&shmem_falloc_waitq.head));
 		spin_unlock(&inode->i_lock);
@@ -3672,7 +3672,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	shmem_falloc.nr_falloced = 0;
 	shmem_falloc.nr_unswapped = 0;
 	spin_lock(&inode->i_lock);
-	inode->i_private = &shmem_falloc;
+	WRITE_ONCE(inode->i_private, &shmem_falloc);
 	spin_unlock(&inode->i_lock);
 
 	/*
@@ -3747,7 +3747,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		i_size_write(inode, offset + len);
 undone:
 	spin_lock(&inode->i_lock);
-	inode->i_private = NULL;
+	WRITE_ONCE(inode->i_private, NULL);
 	spin_unlock(&inode->i_lock);
 out:
 	if (!error)
-- 
2.54.0


