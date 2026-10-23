Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBEC606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VYZAC06w
Received: by kanga.kvack.org (Postfix)
	id E74FB6B03B1; Fri, 23 Oct 2026 12:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FBA6B03B2; Fri, 23 Oct 2026 12:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34D26B03B3; Fri, 23 Oct 2026 12:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A903C6B03B1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:10:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 141DC12018E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:10:21 +0000 (UTC)
X-FDA: 85354378242.25.11F70D9
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 600BF1C000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:10:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VYZAC06w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792771819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pcQjs8ioOVkLcmotAGouT1i8KfpRT9OJ9Yjm+nNsKg8=;
	b=f8ZUqpT8Cnm6vDDSiDNCmEUH39UDY1VSms57d/YOhbp1Hx0SI+NfpOun6WFAp93JXowDUv
	kzSOo8XAX0Zx0f6iaus9wjdXy9mLXD4/hLw0/9t+BVrID8Axiu/V7Um7b7LMme5FcY0Brw
	YG7SUjzEK+gzvAt2n0g31nf3wHBmbNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VYZAC06w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792771819;
	b=LH6fa1RZAiBn1Fxp8zXFLnyPcoGqJ4S0+WLaQG4j0Xf0+yZHD58cI9FANnWPkCC6uYgAjL
	jISIpX8ph/kvZr9TTnkqT3g9aKTCczJvGB+rBUjLFj22wibfUbaYnpqpir6eUjcSjxuqKy
	pJ+xziQMkPGI1RuDO23O2CcyVozeExE=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so912386a91.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792771818; x=1793376618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pcQjs8ioOVkLcmotAGouT1i8KfpRT9OJ9Yjm+nNsKg8=;
        b=VYZAC06wK6rcn9Zi3J64J3c2wG5HkX0KPbch/FhtV8Tzx813PHQOHeqrHa3QRBiGQM
         462ca78iRdy3WhKQFZrf1K2INzfjCempUwAL/+G+AK8hIDJEtF+Z6QcTnP4q/QPN00Fx
         9H0VKTTVzgqoFGJ6ZbXVtL1X1EJD7pWMylz5mgIr23dELty6THRiSfx9+JpWAyMf5LWR
         L3xtYnQTO8trAqMiwwz6x1np/VAHRD8ofkGlBDvFmcTNtZBQsihYkazfJdYvb/Y93nSQ
         eoIJzgISzMkl7pSeqp43ACG5fZCYHTfHlweoaWTh52TJro/gEkeUGMP3e7vYnGRb5lyi
         8eqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792771818; x=1793376618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pcQjs8ioOVkLcmotAGouT1i8KfpRT9OJ9Yjm+nNsKg8=;
        b=bGwCk2KUdGTFYUVaPFIbNvfk/l3TbSsu1MVVMgis15dm+dgKlugxNri/M+iz5QbbB4
         0hfwdqh2xU2wjSZ7x1F8LOfV0NkwxK6SRptNFJe1BSVi6dFuE4vgIbZ99RgCOKFHcvKw
         DJMReEzN/dyTVhAZrwLtUYQ5LCBkTiJhh32Sw6/CZIVPceMo550c0JaodJYq1qwe9ekp
         srI8fL5KyiQjkc7CmBdtPU+6J4f5Qg9NfmIvUfOWZnqoHsrrJI1TRfA5PBUhz0t7Wx8h
         ZygyF8s5ITfVz73SX5oaPlhic5rb/R1cYWooc+XZo0taC3ZBaZKnTH0sPxz3ODtxmclb
         Azdg==
X-Forwarded-Encrypted: i=1; AKwUvByludxfwOAEN+7ge9PLHCrotph7bNVNchjQTce09TDsv0rO2O/3biycu/MNzI3PrXAXjUnJFRDgcw==@kvack.org
X-Gm-Message-State: AFq9FYIaZHffPXZMU4890Cb0SoQ2R6D7Of1PBIYNEZiBIpjcHfen7XzS
	jqRbDilhUnsWPsiIKNavJgFBdcU7mC1NBKub5f6rvdi7GVqSG0j2HEHu
X-Gm-Gg: AYBFou3ti6RAGH5rFIpk8UB2kq1JYxcVdekCgcR2WhguskiRKXoPaXc+6gWJYw96L6w
	+DlWHGipe+0b9hukX9EUrnYVYUmkgVOIih3oALynYIt9Q9egY3ijzmjAgwqRggughrwguSwzsux
	PnwOTXuKeKFqWsbg//7l7+QDU8lkaWAkIlG9u2fvjtmGW3aiQYOyGerFHwhrOizMw1KbcYNjOnn
	41CtHe/fb8qasehmuoAvEx95U2HcS2VaBt9ycP6k/hKFbU6wnXqx4MLkQpD0qR0sI2dvtwZLvtf
	W6mjqWoZQ5ipetLnu2uiS0B87gZ3W7OMjdmKMMjt/KcB/SJyGe2IGGo4LsyKmaP7GMS2m3ODnPH
	E775jyCEcKVf4v1EjUdaXHs+SCSOmyzZFGXaR303usn2uVXMsXZG8Z0b/jY5hpa5uPUWM3cGedp
	fsAfHGwyVIX0FuSAn8uJ9I39yaXQYsTMq2QIWOz+DNKUuM7DiQtA8LyU+TyBnrdYH5tPH2Uh1n6
	BADQVNFkpPq4GGxA0otWeaAOOnSeEnsaFQcPUHBPOS5AgRBeXai8UAP//pK9Bi98jbgtK8uGjeS
	ZuUUVQ==
X-Received: by 2002:a17:90b:4b84:b0:3ab:884b:65b4 with SMTP id 98e67ed59e1d1-3adce154993mr2197303a91.59.1792771818170;
        Fri, 23 Oct 2026 09:10:18 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ade31ff0c9sm258584a91.1.2026.10.23.09.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 09:10:17 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH] mm/mempolicy: remove unused mpol_is_preferred_many()
Date: Sat, 24 Oct 2026 01:10:01 +0900
Message-ID: <20261023161003.59086-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 600BF1C000A
X-Rspam-User: 
X-Stat-Signature: j9mpfubayengnksauahoh4g19wkuha51
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792771819-147150
X-HE-Meta: U2FsdGVkX18p4IKqd6NZmbcbLpzvba/7xPlFsKAvFcRNMP0HjfUKh7yRKxPwfG8OJvPYvlxMDIwstZqzpSe0oxTZHzSqZQQqzv3/MZ8KC2KGo7aqLglwu4pKwJa9AAjhy1tnWy9PaDzjk8vnzFI5jukWML5EFm3OB2gOQ+Hk9gwopBf7wNBVlh+PuCsIZJbGWiXe1HZ3EJHq1KhjQAGNlfNm7e92iyvszZtepqXUMrDZvD/z8NgjtZbtF8hjJXuCrxRg8TFceMiDzd++3vU+VhSoL39noNxCyhFGLGFVYcsy/xl4i6vtAPEuuAMZiBfLfnQXTDg5P4WdFifEc1Td5b/yGn/+hkXKkL1pKyqLRZ9AfD1A/icFMnWS6q7j1HsREhLWYtRPyaiLze/5iyYoOwZRqZ8Rw8zGjkfG2JBxVmrLTPpNHPE8nO+SM5VTaT45Z3PGQr7wi764QCcu+Y4ydabh1r30hwA+ZeFLQoOaP3c7udOXNGWpsfuqu7bBabFNHUU7I8nJwJkG909+8cfpCAcd8Az15vJ4f2PO9vw9XuN7RysSuGK173+mpjAW10HjBehWiJ/qBd6ecmz9rJgchl/qOtt3TiNz/YKio6VarP58EkrPcgtXUIxjDMm5kT/wtMGDVemxLS/j7o8/q1r3osYIuEJb8m8jL956jHJaZfZjX2vtJ+zxvP4yGlxJLYl+Kyz9cCeKuvHrOv8WlqhkY6nOOKDLgb0CzPbzDfb3zTB9k5x/n8PAE800fmlFaM2GMUnzQk5uh15UC0bSRKeDRHTnMeUHcEArg4nAPIYt3MuJ4hdcNzAa7zJrWxotlSKKPiuIvHC+qK0hhD508PVnMl/ZAxPcszqDUYD7boQo4oX3t8/lmqX6UCnxj0MDLSijsi+bOW29VPIXZOwS9G1K21fxsbp9SpbuhcJgKVYU8kw8npVZG5T87lnClY1Z93bMbo4CQ9p20g9tipoJldD
 DlW/6aOl
 cy7eKpLxhbNc2cDahdtwzRpusmbzikHN0uVXqjuavID+b8N7jmF03ecPE/s8ChXKifFMMZDverXpPHSutt74IGiAtJ5R4L+nHv9y+h086x/TdDgSuUkZqXf0MmNunQRHOVpAzwQllm0AHtp/UrqliJGACEEGLpEX875dmQFNi0ywcHcrIwupjKO5QjwhLhVBPJ+5k6T/ayFHBF/ZQUi85e3J3r9CZlK+62Ld2BVutYwZU/qqvGzcl0KSACnFLBdU5cS9NLUl4LSmkHATNELgd35y3Mg8blumnN9xOS6/ephHFJIsPCUtApuMrag3f/qBKG1clc0fOrVdDf5iXEEQPzCnTs5h3OEJojL7ouTpWDWJUydRqTPWgl2PoLRa6VZBlJQJsGC04LipIdzYF/iN1cEpM4Svfm424JDGe+B+8bROztSVK+LQOyCru1N5O1j0GQ1fXNMiEIcIkPQcNi82XkNW+E1+keSPiyMhTTZ2lUx73bnDpxzfBJzQJ/40zw5wz9R/XlFD8koSJFqG0cJm9Mw2b4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit a492abe28bec ("mm: hugetlb: move mpol interpretation out of
dequeue_hugetlb_folio_vma()"), mpol_is_preferred_many() has no callers.

So remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/mempolicy.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 65c732d440d2..cd8f944209ca 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -173,11 +173,6 @@ int mpol_misplaced(struct folio *folio, struct vm_fault *vmf,
 					unsigned long addr);
 extern void mpol_put_task_policy(struct task_struct *);
 
-static inline bool mpol_is_preferred_many(struct mempolicy *pol)
-{
-	return  (pol->mode == MPOL_PREFERRED_MANY);
-}
-
 extern bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone);
 
 extern int mempolicy_set_node_perf(unsigned int node,
@@ -298,10 +293,5 @@ static inline void mpol_put_task_policy(struct task_struct *task)
 {
 }
 
-static inline bool mpol_is_preferred_many(struct mempolicy *pol)
-{
-	return  false;
-}
-
 #endif /* CONFIG_NUMA */
 #endif

base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.43.0


