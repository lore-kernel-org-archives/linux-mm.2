Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166F3C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090AA6B00F9; Thu, 16 Jul 2026 11:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FE66B0152; Thu, 16 Jul 2026 11:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E717D6B0153; Thu, 16 Jul 2026 11:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C94B6B00F9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:14:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56DF1A00DE
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:07 +0000 (UTC)
X-FDA: 84994607334.07.B53A543
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7AE2C1C0007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=faSr0W1D;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205845;
	b=q1lxDFjr1V4hMEh8zE9kjMsLfQlipBeH7Fk7drLSxAKqiZBIjpMyUXI+w4raV0LRu/7QwN
	YxVJE0LK/Zu/NyAnSwztDuh0T9qRKssQwbU3xcPQ8ABBnuJ8iDhYh52yBITn2B1ELykiyb
	48uUF8nhWbgMrqbcCR772osAtyPI55Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=faSr0W1D;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVEhlrHEVqIN0Ar3D+s2eFCiOScwlS1S3mz2hTaXKkY=;
	b=7PZYfV4F6Fl5KJEQMrBb2Ubci12Pt0/3Jt3e5u2Fvo3sY5XKqCfJdMlu4yRbCQtjHNKXA/
	aCS1xYbg8AjX3CS7Trh8cIvu2iZ+H+sEnVdb/7TNW4HWxFiKSe+4LVz2Swlb6XYQCCL7hh
	K7K/uZcnEYVwuoQGoUvmzFjxJ17+7gE=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so5145784a12.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205844; x=1784810644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RVEhlrHEVqIN0Ar3D+s2eFCiOScwlS1S3mz2hTaXKkY=;
        b=faSr0W1D3+qRAEDx5q+fwS+BhXr9AiO9TOhz5Nzry6LlvXrvTGsovnFVRAfQ6OHULJ
         CUi7fVkuPEhtISgtZctp88SUhvOTKvgdf6Uc3nKBpBr0V6liDFjStk6xvJt62LEkDnfL
         1BOb+jIyhcge/I4fBFkEybgG+vlgmyBlqeOMg+695QYlr1RVX4D9i0jcupM+xsNNXYOG
         FJ482duyuOzZ2/tRYcNHgjXlWIlqCiGDHlydtWsHfD9L3sGkmPaYdjc/qFRLcBHKSugJ
         WJLMuAeBLsVPAFh5hswKwGlUh037czD3heT0dThw3JgJY4tzoAQvNTDAZztu/TF9BCvt
         OZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205844; x=1784810644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RVEhlrHEVqIN0Ar3D+s2eFCiOScwlS1S3mz2hTaXKkY=;
        b=HP1V9U8XcYvS5IArShwajz0TE7YjgY9Ih/8q4NSKX4mrFCzERaNtXEIqgpCw8IgPxQ
         6nT3tjx2YNp678GVZziaYY9PNtaSh201aMVFUdwfvIT6sKJxIvK5r7KhnKrFC53Zhm8u
         RdsiAZWmAKbrlryyVYm5YDuuMT9sgShMMhOdeg5gKe8he5pFDDuyjeUcdTyFRyA2/DQC
         +CAqlGLdeQswHHRc4+c+xP+7IMXDF+sFTtORJRkFuTg3sJ6vpzWcbj94k4670wbsodcU
         0tOCXhOXF1Wq3ywm4/0bzsiaQT7+Vr0HNi36wuWDtRFTIARAxGGOg+QVX71nNpCGnaax
         YPfA==
X-Forwarded-Encrypted: i=1; AHgh+RprervsAax1gt0umCoD6Jxi2wgJlhZEBIgT2oShqwXMHlAbFyiQ4A+wyBFARWIwSpVZwL0qh1K4aw==@kvack.org
X-Gm-Message-State: AOJu0Yyaq4nfHcGMWJ8XAlOxN01BXN2ualru65ZgErJy1Mut7m6ceK9q
	NaF0o4YM2mfrpYFnBUN4Z7AxKSZIibqh3EtI7yilGXFhnyAkrYAUuzbXrdz8Sc0Ze2cgFfDf9eI
	ebVLjff8=
X-Gm-Gg: AfdE7ckC+7BypU8eGNDXQlT8rwPGCKOPq+sIqzjVY9SWyS5ExdtV5zoqCjhLpYCi/wl
	w3cgnuN3QFtmr7FuPSY0tuk0cfI/Fd6SmUexjCkpwTc6Qffn07OtZni6+iJNgeI0ryP6JEjrio/
	xXjsx3YeSKJVKYld39Ylzchnn712wExmGkrU2dZdMtLol5J6AqEHYLDeI90yz+J5QpJItD1zSia
	5HhsSX8Z7Q6dK9W9EsGt8CDKaMAIsfsfGeeqRglci40jL3Yip0c4EA+jajZMjKkkXOzzGy1jqQb
	Q+mO6ZoJce0HGAenQmjdokL+UxvpB0w4UwsmHuVYUTZuBbbl3OCcID+MQAw5c6VUEDNBp1WFR/c
	PWkK9UD4isYqwk24RvoXuY7bRuwi1p1HiBsDHXf5hy6ZrEpxtM8k//eX0Qpob4UNypq44Z+CGxr
	xP7C+CczJBKRCicEL2HVB6xwQ=
X-Received: by 2002:a05:6a20:4308:b0:3ba:cd5b:3dc8 with SMTP id adf61e73a8af0-3c36c1f1e9dmr7530059637.31.1784205844222;
        Thu, 16 Jul 2026 05:44:04 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:03 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 09/15] riscv/mm: avoid Svnapot consistency checks in ptep_get()
Date: Thu, 16 Jul 2026 20:41:44 +0800
Message-Id: <687dadf430c49a840e24976e37ba09f991bc3222.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7AE2C1C0007
X-Rspam-User: 
X-Stat-Signature: 5w15o3bb9cgg9s1dqmdtx1coc86rugpk
X-Rspamd-Server: rspam03
X-HE-Tag: 1784205845-148593
X-HE-Meta: U2FsdGVkX1+de3AsLi7nOVmbYYgqa+JywElsOszPnivm31teubI5uyPPQ4ttENnOPpJTEb2VRx2vaxW3Txngz8soUGNsGg8dDpA0yuh82SRJTx+URSdtAoDH2bTV71Q7MYLV5Tr9dTIpy3WKdI/MP7KIs5wMdnRF9WPYMt/d/ld2lmvbPoXG5riWkaiNwZzWKsnEIsEQoHcpEFfANY8vsKczupYK/+On5Fbc7CqrygDH68VGZxKuzYr7YVRus0ki3iDaAobgvORMarlSRpnIJVjBY7i9ocsw9qCqPdM6fahHl9tyZK3/BMO71ICmtzrnXpBqiqgOeECb5h/mjNs4LqS2cKmGakXV6cSUFPkA9qKKH/uoLJsikif03auqwL6MEVv7YjsqXQYqd1FdteEP1c2lhAqe410KrNC+zlZCGah0hCHlkIsabicbBhpP2CbhULqrgj4K+orjYU9+jis9/OWLKn4WZurzBeWiMINMxMll1kJ+Zur9AwFqsfIYhIaDd+pzO9xD65fa5QwTsWGKF3zNCbgTIiu8FpT/DxzPYJdBB2qylhvItQ/PqzVBUAEbcmMFYBbGq5/gk3TLWRA/lkVD3RYFGbpBJFrU2/qSy9hd0SmzKTREpoSqH5YPj/+DQipcLcuX43/Zz5Dksj0k5buXGsCIrmCWc99J2WxMS1ZYiCv38ewEFVTN6uV28uulVoU4uU8SpgG/gMVTn9DfAQLLmy1vcW1gufSW+EWL54QnrAqyegopNfBC4OCuz3azJXqqmbijaJXrT5rBjUR5k9e5xVWkEWxp2J15/CZ5K+f1J6wZRPCgXktbjuKdKLlhAmuFaTICAoiaaJkzZZ/uVmdG1lLROSeUSEtU76xWBSCE9GidS0HCpi0aA8p70lU9EQrHfiYQAltUGbGkihFPEJQYGAAoQR/bLEjeCiVqvHCTJaIFz4cRnerQIT4bzOpq07UGJ8cFnSxzSI879nE
 tu7biIxG
 tjBLtiCIPUlmxci9YaAtZxplkOIJR7gIK/FEsyRgLbMdaWcRfCJtU9K3KS2V8BiS6bKFwfZdvJyl5CSqg6CI8E3furpfGvdNoYwt4XC9Bx7kE4/xprmKcueg1/tTReesHh3SRCkk5/d2/hIz3x5MgXygZ08qCWrzoxqwiR9+5u0wsz8Q3Vjxgahv+dteFk4KaLI4tVh/J9+mVpyH74Q8p4wBngMQ5KssdmMLSiRIA8V2OdRITxK8FjSkTn22OX+e95cJ2gtcNU6le61JnSHVxT+pkzg4oXcbTTTQ9tFgQVGfhz9Oj0bCQ2W37zzkiSgJkH7rwU3+W/WrW7NB6ZOVdbyJqg0auH90GQ4p5sneqXVkMVr/9J1wDgC8edw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

napotpte_ptep_get() builds the returned logical sub-PTE from the
initial PTE observed at the target address. Neighbouring entries in the
NAPOT block are only scanned to gather accessed and dirty state, so they
cannot contribute PFN, permission, present or writable state to the
returned PTE.

Drop the range consistency checks from this ptep_get() path. Callers
that rely on the block-wide A/D view are expected to hold the PTL. There
are generic lockless ptep_get() users, such as userfaultfd_must_wait()
and HMM walks after pte_offset_map(), but those paths use the present,
marker, write and PFN state and do not consume the gathered A/D bits.

Keep the consistency checks in napotpte_ptep_get_lockless(). That API
must return a self-consistent PTE snapshot to lockless walkers and fault
retry paths. napotpte_is_consistent() verifies that every scanned entry
still belongs to the same NAPOT mapping, ignoring A/D bits, and retries
if a concurrent unfold, rewrite or refold tears the range while A/D
state is being gathered.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h |  3 +++
 arch/riscv/mm/contpte.c          | 19 +++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index e4b9c05014c00..dd56c20a817bb 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -930,6 +930,9 @@ static __always_inline void napotpte_try_unfold(struct mm_struct *mm,
 /*
  * Public PTE helpers may transparently handle Svnapot-encoded mappings.
  * NAPOT-aware arch users should stick to the private/raw __pte* helpers.
+ * Callers relying on the block-wide A/D view from ptep_get() are
+ * expected to hold the PTL. Lockless callers that require a
+ * self-consistent Svnapot range must use ptep_get_lockless().
  */
 #define ptep_get ptep_get
 static inline pte_t ptep_get(pte_t *ptep)
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 70f9a0668b50c..0f66426b0ecfd 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -294,6 +294,13 @@ EXPORT_SYMBOL(__napotpte_try_unfold);
 
 pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 {
+	/*
+	 * Gather access/dirty bits from the whole NAPOT range for the
+	 * ptep_get() view. The returned sub-PTE is built from orig_pte;
+	 * neighbouring entries only contribute A/D state. Lockless callers
+	 * requiring a self-consistent range must use ptep_get_lockless().
+	 */
+
 	pte_t pte, cur;
 	pte_t *start;
 	unsigned int i, nr;
@@ -307,14 +314,10 @@ pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 
 	for (i = 0; i < nr; i++) {
 		cur = READ_ONCE(start[i]);
-		if (!napotpte_is_consistent(cur, orig_pte))
-			return napotpte_subpte(ptep, orig_pte);
 		if (pte_dirty(cur)) {
 			pte = riscv_pte_mkhwdirty(pte);
 			for (; i < nr; i++) {
 				cur = READ_ONCE(start[i]);
-				if (!napotpte_is_consistent(cur, orig_pte))
-					return napotpte_subpte(ptep, orig_pte);
 				if (pte_young(cur)) {
 					pte = pte_mkyoung(pte);
 					break;
@@ -328,8 +331,6 @@ pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 			i++;
 			for (; i < nr; i++) {
 				cur = READ_ONCE(start[i]);
-				if (!napotpte_is_consistent(cur, orig_pte))
-					return napotpte_subpte(ptep, orig_pte);
 				if (pte_dirty(cur)) {
 					pte = riscv_pte_mkhwdirty(pte);
 					break;
@@ -345,6 +346,12 @@ EXPORT_SYMBOL(napotpte_ptep_get);
 
 pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
 {
+	/*
+	 * ptep_get_lockless() must return a self-consistent PTE without the
+	 * PTL. Recheck that the whole NAPOT range still describes the same
+	 * mapping, ignoring A/D bits, and retry if a concurrent update tears
+	 * the range while A/D state is being gathered.
+	 */
 	pte_t orig_pte, pte;
 	pte_t *ptep;
 	unsigned int i, nr;
-- 
2.39.5


