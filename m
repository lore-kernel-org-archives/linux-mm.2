Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BB2CD4F38
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8348E0023; Wed, 12 Nov 2025 20:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A408E0014; Wed, 12 Nov 2025 20:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1A98E0023; Wed, 12 Nov 2025 20:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E39F18E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A64E94D02B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:09 +0000 (UTC)
X-FDA: 84103895778.02.DF6DC8F
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id CE61240008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=VhZ6fmpT;
	spf=pass (imf07.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLUmTi++1HGkiLtqpPoIfkvNz5bT2yFaPhtAlSBbrkg=;
	b=tQDD+Xyu4sWRVAiH4KVKBaGpe9285uhJorPg+V18xxwMX9sHQRxtRk2dqmxs9qm8W48P+m
	wNXPl6WR5Sf6qft8Kyhv4R6OsvqJMO7OEjzZcSMteF7VSkcrGkuQV3KYQFVkFz5vumgxYW
	kihafsqeFMNuEN2Iw+waUatn+kLVzDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998427; a=rsa-sha256;
	cv=none;
	b=29xJ6lTlsaiT+/nmwFLphnUlCgZ725ftVAFq42pm3kKLKsLj2jAymy4zVKzS4ICXQGLhI2
	K2+5PDMkVGMaYgfg80qsWPK0Epq5wXrpwpwqn5CfPDsYGh6iMErlKusvb282t8xsxIp/vD
	dx6jM4unHZwP4MeOmmucyOmx74//5qk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=VhZ6fmpT;
	spf=pass (imf07.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2981f9ce15cso3097335ad.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998427; x=1763603227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLUmTi++1HGkiLtqpPoIfkvNz5bT2yFaPhtAlSBbrkg=;
        b=VhZ6fmpTPM4W0W3lLxHpPpykdK5vXjauuMGbSjCFmle91G1vkg4153EJCYOmCuVAOq
         T8LKfJ2MHuy0EBy9LW/DgeEOXAAlJIAVRNPKUox6a46bD5JX0x4B7QwwoauJy912yrhU
         crX9WCIS6oHZks2e0619WH1z5+mHIq9iHsmsjTVUkQk93uI4cUR5v2utGV/9MUyG2xP0
         aPnAFhXI79L8pKtSmnsSOsvWy7/3wNK+obo1FPiy4A6vfCYmdgOe11w950dsRRKMnbpe
         kKgLn/zj3FdXPLYgP3jvkBNdv9mpnxSURhijkJQjZ7/obV5jJpyeSGQBFlWDiKmywE9L
         /Plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998427; x=1763603227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VLUmTi++1HGkiLtqpPoIfkvNz5bT2yFaPhtAlSBbrkg=;
        b=Hw7ZMhfrIaldwwIDgJsr7n/xYd4ZRh1FWFyE0dEMN0AQkvBMFKylQ/5fVtFc9hncNo
         dP6QjarS4Omn5eMmRZqgLwXn8GgsTn2JhwPWMzbemVDygDY5nrduQGCZ4kwifi1GPK8S
         MVB7EV2jhJQ2t+DkOM/0qV3pFC+cvrMuebshrM2pWQz+afswX0Mk043AU6bH7ASW/3Kb
         MDpFmfa98wEJjiUnuwTf42Oo0sf5O1MZWRJ0ujuXkKyGW62bsTGcor527zZufYUCjx6i
         4kfZ3lxlM61ym425VrH84lSDaQ50oL3qy6Yj5obH/hhDkyi0dhNHlZqvz0Lx3AT/K+j7
         5LqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFvQRF3xpqoT64oa3Dd0sjJ4BzGHDZHMkTQ93lyaNXZt/Fv0W/hEgVaV2wPI+FTIVhTCavdyNbfQ==@kvack.org
X-Gm-Message-State: AOJu0YyWwo5rZTvvteHhjYYRbClcVdu8mTWJweRun/u1Wv1dqINc5lUp
	04C6jJPVeVHogM5Cvf//8mj9J769zAHi8Ios9EXLtzjLtoN1yWkQf+TjZY0zzrjPKV4=
X-Gm-Gg: ASbGncv1rMqnJ0grEQATe4TGCupirjqn7u8aXPg1/Sp3fRxTztCYvodHid0LRmlBkoX
	t2T6bBPqK8B0IrNBgXr6iZl9jiSLUUKdUXVquyOSnSVp9GUGhQqS/JSJuZEAfv9qFandoSp9kng
	K1WzGy26GXFi2zwIrimSqNAQkAw7HE8wyuSOTQLM66pA9AHelsT9hdDaQK87/MOm0YlA3P7bPjj
	HU+fwcxI0QLjLM1BV03npeWgJmQ9RXrvDw7/1Y9NlQuGgtp/zCucX6OxGrB73/BA5IQF+zrw3QW
	GxvtpLotjdXHKQG0i0cMY6+7+lbYHShyrws3g8zlMJtv4R63sDZJyMTqEofMew/BjMX2Mpy6fTK
	dMDST1fpNu23K/vTfbW1CYOz9GmWi3ycbVwq6PIZkMvgpFK7eczH0D9KiN+Q3i0KtVECGtAZRT/
	zru2DQ3m2Fmrq4xbiR19/pmA==
X-Google-Smtp-Source: AGHT+IGHyS+mDyrQaZDGXxDAQVdZw9gnQRb0FUGE5S/L7D9yFzt8E/UzPtcwSd6KHOBX5fl5Cq42AQ==
X-Received: by 2002:a17:902:e5c3:b0:298:3545:81e2 with SMTP id d9443c01a7336-2984ed359e1mr63898395ad.22.1762998426605;
        Wed, 12 Nov 2025 17:47:06 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:06 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 05/22] mm: Move the fallback definitions of pXXp_get()
Date: Wed, 12 Nov 2025 17:45:18 -0800
Message-ID: <20251113014656.2605447-6-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jwpic5om3qp6eqaqyz4y4mrzd4g8a33m
X-Rspam-User: 
X-Rspamd-Queue-Id: CE61240008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762998427-694013
X-HE-Meta: U2FsdGVkX1/ZhYwvW257bytRJHzTnl6I0vzs0h6y+fPUQurkuEQDdOS5gamrag9tOU8MxydHQ8GWZP2kuiUCxRIP9upw5F4ZFrNHcVLNjXHxd5kbniPz3dCvHj9GFtSt6cgV37O0uW8p7BHiqq6ssEnfzDEJCNSlGf60JZHVbtq+TcOC8ntC1jArLvEXSTKK4yw45M0ab3544xTCx7VCfO/8zg6ZVjtOkrRlw2ADkEPAZfTRdpC0JVLHxxdqaU1U5WkpJ7+ElB3gun4fdkGzkIdfdr7iGTBfoM/bhRz3DNXalaiHPpcNByKOqfshrI33/znFVfeBHN96LUopKDrWm50jRXVdCh74Lrdve+jGBIOz5WItfjZb5zXSi/qTCWeqVXkf8nDn97h3w0oRyfz0pSipcK+ePVXhk21EpWZzvjhYLdk4hF8SJBjr3zAHX48MlD4y+2wdrsOUhcV0tdf9R8DbXRkjhoU8V+hJElVEvb8n0KmHghf+piTZXdziLLsSSrya6mDe2H3Ru3lKo94Y5ViKFWyV34AIqZ6GiFE9j8Ydw/efSCDuXXtMu/NIzJNCH2w/0S/PbgJgFg5R3oiNJRf3x08ttT5O5l4GVZO0p8M4JYKS3yQntJ34QgEpIxw3pj2ENWglN8DabpsrrMrUIKsijmghi2wYJXu7g16mqzv2Gj4THUhGEZborrveupAt6LwpPnzY/333euSNmv7Yz3LWtp3Q6EtGJKdXsMnnI8J1zSOkvCzs9kQWpP2XMVGeSzQQf6w59zdPzw7D/osh0+IVa+4IF4FJSOQiRouNwDc9HomYtkZxQpTCZdlIjIDtzgQ8pZILNccnK7lJ8c6+EtOUZ15Trq8o4hAJ205uJ1KgrH2y7CZCAzWYdITWdEXPAl5+vT+vohP8USY3eg1hSslfKokpaqbflUOUIr1tQU0BT/8ECP++zBxl7tuehMyu1rbvZF07jsQWuLyYROy
 9sS1SX80
 9tcRD4L31Xia8uzUB6pML2h6Ctynghj+4mnF8AzA2Wen9Ib5Jte79ztt4KOXWNzZhGzyKucrWVAjIPF7S4FBNAHXl2oTGecIr1XpcYNAnrWrJPfil1JN8sRC7YdO7Z/RjJ8rm5P5ItrrrOFB34XFBmO3zFg6eF72flga20me4l7vfue1UfwYPhws5600Iaw/xJjPaPtBWHL98nkksTTGG4s8ZzYxGiVeYs7hVeHz37WkDv3VqeU60rg0W0gcvg44AsL9FjsXJsCtG/GLj3CvOgTioyI563YgjwQfm8mS37zya4xMiGtgn1ZRsBtl1CrS5ngcsTxIJ7+2MmGoN2xF2Xk0hbfM2OeDnqguYGb4sj0C23PPVrELPlQDZMnqr4W7oLwwuc9qp487Mbduhs3lmp5zuCPGz/GcXhjFE1D9QV0L6dCPh+QNyQ+z0IGSLpxgEAQkj70YNyGuQbIi8kf2e7gVl1wOuiWMb6eMx+043Ai02rA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms need to fix up the values when reading or writing page
tables. Because of this, the accessors must always be used; it is not
valid to simply dereference a pXX_t pointer.

Move these definitions up by a few lines, so they will be in scope
everywhere that currently dereferences a pXX_t pointer.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v2)

Changes in v2:
 - New patch for v2

 include/linux/pgtable.h | 70 ++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 32e8457ad535..ca8c99cdc1cc 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -90,6 +90,41 @@ static inline unsigned long pud_index(unsigned long address)
 #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #endif
 
+#ifndef ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+#endif
+
+#ifndef pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return READ_ONCE(*pmdp);
+}
+#endif
+
+#ifndef pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return READ_ONCE(*pudp);
+}
+#endif
+
+#ifndef p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return READ_ONCE(*p4dp);
+}
+#endif
+
+#ifndef pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return READ_ONCE(*pgdp);
+}
+#endif
+
 #ifndef kernel_pte_init
 static inline void kernel_pte_init(void *addr)
 {
@@ -334,41 +369,6 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-#ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-#endif
-
-#ifndef pmdp_get
-static inline pmd_t pmdp_get(pmd_t *pmdp)
-{
-	return READ_ONCE(*pmdp);
-}
-#endif
-
-#ifndef pudp_get
-static inline pud_t pudp_get(pud_t *pudp)
-{
-	return READ_ONCE(*pudp);
-}
-#endif
-
-#ifndef p4dp_get
-static inline p4d_t p4dp_get(p4d_t *p4dp)
-{
-	return READ_ONCE(*p4dp);
-}
-#endif
-
-#ifndef pgdp_get
-static inline pgd_t pgdp_get(pgd_t *pgdp)
-{
-	return READ_ONCE(*pgdp);
-}
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
-- 
2.47.2


