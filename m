Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7772F4BB9E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4366A6B00AC; Wed, 25 Feb 2026 06:05:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E11C6B00AD; Wed, 25 Feb 2026 06:05:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3056B00AE; Wed, 25 Feb 2026 06:05:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4E56B00AC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0D36B9CE0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:10 +0000 (UTC)
X-FDA: 84482697180.08.40D7D8B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id E4EC240003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WXcwiink;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5++u0m+xGMfRLjfeOcLvTjbT7zO8s4I8sMKuOvXVOb0=;
	b=fHtYQGxJzKelQtHaCGC7l8SugXd9w+XwqzhMHmq094bSR4OtzvtXa6SUsiECNg5IxbMKdh
	AU7wIY/ETypV/2J8ab3qUI5i7j+I921xRLz1Iyc7vatN6suKmckxpriBIdRny2Oma/54wu
	fLOkPRa8oSRsQtPDY1lt5KAj0mIfKrM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WXcwiink;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017509; a=rsa-sha256;
	cv=none;
	b=rXNHI+W/FB3j5ux2PGix0A1vylNmQiJ7vX37OXDSxqbnKO8hfRRzyUDwveZ7REmMpTAhuP
	CU9q90vabsvUYcpteMQ8R9gClW/U3gidDXqHAUDUuZNVqBqKByqh7+uZWURz+gSi/i9IiI
	qzYtGh655pQjU/TpqumJPM1oLS6Ny9M=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2aaf59c4f7cso30442635ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017508; x=1772622308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5++u0m+xGMfRLjfeOcLvTjbT7zO8s4I8sMKuOvXVOb0=;
        b=WXcwiinkAt+W8LyP1jn7fNgRMWP6eCyF2eMQ6e/5CFNdnkVNq70pAK0suuT2UNzOKf
         SAZ0uo3CUgkkk3d4ZVeXQkFm4Dg4uffrOnM6L9DPEkv15ISTs/U8kjc1qJS/4uq1gFsA
         rX1k7iGsENBtLazboM7qFnd94Ej2m2RO0KUMv3XJZ1JpNJ1bMWRb4HpjDdNyyfHG0886
         EHYG4whiSmoWLBS+FkYCNX+lL46QXYAu6aG4mRBiqMzEEyz34cIVv9uKpXCYZBIgKrYV
         3BWEj25zVTJhQwnfzQqI1P/e4WNmZfO7agQ5wHj6sBWIEkbj0NACFFyq6c6N3dxXgD0Q
         Vnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017508; x=1772622308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5++u0m+xGMfRLjfeOcLvTjbT7zO8s4I8sMKuOvXVOb0=;
        b=dhRubWBY/wgjZs5eNccNlxZCHaKSe4+l51dYojynk0ck/SccFsmTTReldJPSz7pG6V
         E+IjjC3oDbk9p4Czz6/lO2TL5xOo6SEKcudNiNDOkNTBNVy53ofHm+5ASON/JbYvp0zN
         szjiylJCtiahCBza93lazLPhB3YSVBRHFcTT8IPf/HGCcAC/ZGqI1ioxTmRBhA5Ryyda
         pWSBH63I1hT8Y3uH0eIifDP5fsBZ9sRbab7RGO1QsdcZzRCqXP2XvfVigbnfiWpwneUg
         zWolg+0Ls45DSP8bnyuisLen8V1OcjwusDzuQSo3dmMq4TSRPEzofgre/EzJ9BeJmWKM
         5fIw==
X-Gm-Message-State: AOJu0YxXJGUzcSgXySSiODpIjz5WKy9pzmq/PXDX7lEk/s2lpE8lrpiz
	SLRKlcKSL7izuiC83MFFQOh3F1kSQLBymBLjS++5jWk+Gcr62zT+HNCQ
X-Gm-Gg: ATEYQzxzxVZqPWWwFkeWQmL1MoBB4Qb+EYEMatrdzEmgf8CdSIOQldhMcxewIKyLNCw
	7Tp5m1G0z0tRk9i/t57w+gGP99hOxnxqVtDDtLjC6u16wcb3DI1P40WI/6ctx2OY1MO3bVrkbMs
	/HGWfyOuzZPKGJ2wTE3AWRIcFQ3Rqb9Dldr7n/OfzUSJNIfhorZbOZvFzceY7cJ4xuaUWk9vUUs
	xuBAcH3mttvUbWpcpJ+e0rtiVBvlCBtsGMQIGXWiEUKJ65q77gHCSoprABQyRkS4yL5Kq29RAHZ
	yOABSye/M71VrkLWyPoMXIXyvocFXsmVJG8UXM9B//4LWIL0elubhrshVWMdZdipeKgPo/fnS/L
	7CsZ1eGRIfHe2z9OsyBwzekZMpX7f3TrTUVI7SXkacXXpdC5f2FXojnqjRO5YbOReHyUliGB3cg
	PSJICHHpwrsbekLy4UbwDoIxo6qy92auY=
X-Received: by 2002:a17:903:2ece:b0:2a0:e532:242e with SMTP id d9443c01a7336-2ad743fee5cmr163977165ad.11.1772017507407;
        Wed, 25 Feb 2026 03:05:07 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:05:06 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 05/10] powerpc/64s: Move serialize_against_pte_lookup() to hash_pgtable.c
Date: Wed, 25 Feb 2026 16:34:26 +0530
Message-ID: <dd9b5abdcc56d935681f7f95fa018bd886d59ba0.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: E4EC240003
X-Stat-Signature: t3srgomuqkq6fux7dhtzrdahwxatcszb
X-HE-Tag: 1772017508-54128
X-HE-Meta: U2FsdGVkX19pVjaY8+gg/CCFyozep9wg39wYVUuFUTVAOqfCORSAhFXcMVXLz6YkYIscVVo9XsUWElD6VSTvrZmUAY+DU7BZEyUoNAV7jfKsGvWTcwqZThz+oCXDVMMtLOFDmMEeyhVXBeYmmATOGlfgL71AtufdzXIMEPmoJdBkldcgSv+wVXrfpyehsbVvt80a1N4odyoUq4DZmB6pTgxTX0LEQNgd3EuG9flPYf20+ghjiWVJPbPK39/muRxv2XW1+bVPZRgTHH6Q+iZgioI6X7PiuZX6OS/EczLCULXvbakeE1InVQ+Jfi5+Nx3b4ydHLWtFQwZtukBakPURu/9hDF3w9fkWYnZHPINQ3x0bRps+/Z3KcychR6DKYaHpyWfLDADt5Fw/F19ntQuOkSw92AxDIG9wU04yK8yK7unsuXAaeha9Px40rgol3rOd0Uv84NroLRuIxMVWMt66tMilNdTylyAm91awvhPZftSAiq8i5hOAQEo3xSEIH1r+lkmQ2HGRONd9n2r9DW783FsGB/kZwPZJapdpwCXd581KhbAnLcyN73A/jvagklMITl265zL0WWJlT8rhtZ3ciLiEfm6Z6wFD3lUIe+zbjRQ+xG+2ck3+yVsNygkbjta/WNWPHpqtuwm+JjFrxkxXuu1VbvVetl9iu6kijwT/HWxMQMljw+7MuVcHHHrQ7NHoUCqhYLIN/W/JY7ZJaCDWLsFG+HO/50DAQUxHLSK9XjD06aC9p9+QOX3ua0P6/LTcjILossEAM45CLagvt1ofA99GpprpkclLc7xh1AfvRwcUJWXaoNhHoFF8aKEzBLa2oZ7hUU4uTHwdiG1l5hj22A/GvcLW9e6VFKmIhJYCBbPEMmBW7fEus/iPS2Ktfv1ff2lA6RZsStx/ZIaknev4M7qyznBxE3XJdv+zyVGMIpKW30V4/C5xfCg7WQIC5SWQ6Zhvz0EC17f2m3pcWBE
 yJh7Q0YK
 7sSvTMzbUT2EV3TcQviFn+YZxWfwkPO2IpcHHU8d3HwVgqOX5mSATPcZY5WP0GO2pLtmtcgqZn2gTZ2S1YwsllC0qPcO+jLO4LIGChHKCCr8X7UBg7kUpXpAy9r6kCr2xAEs4BpCCdozfRrNJj8u6LZ2E2e0jWkTdoFINHE9DqJsXV5x5fAV5UqNnCDbVTao0yMeh/U65U2PenlT6IrFLOufPq/+bCfrkM7cqq5iuTHlMObyVnx+ndxfjXyresEr925gweGOzJTK2v2sqoLqHzNlTZIlan6Gv/3Bk/keFcbvGXfjJh+9XqOgY2K5SP2Le10et5nYiZCnKp7DYjG/J+MBP97dT19uMnT0xm37N3negQgzA+6IMjAwNNF27eGYvvVAtMwg5NJ3HXstWmqOrSHM1Ht7BL9IvHzkCZIK5od2R6Ngo/vcBGniZYKOsRRxAyF/O2uWXHAPvTDpKC+A3pbZ/ZZ+ifv2PxDwXuB4DFXGUFzBZdRLlYIu9RpvotTKvvsCC8bk7OHPBZOkttHd75ablUwb0rnlha8HMECOAlKSzFdpoKSd83LV2zF+1A8gD42Rt1bygcYv86Z2eRL8zQ3CZkIiWjtnAzVmiN+HeUEpcnEJ7MtDWC3CqtPlaQW+jeZc0L/dcpQQwmqbnqMScZBRW3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally,
commit fa4531f753f1 ("powerpc/mm: Don't send IPI to all cpus on THP updates")
introduced serialize_against_pte_lookup() call for both Radix and Hash.

However below commit fixed the race with Radix
commit 70cbc3cc78a9 ("mm: gup: fix the fast GUP race against THP collapse")

And therefore following commit removed the
serialize_against_pte_lookup() call from radix_pgtable.c
commit bedf03416913
("powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush")

Now since serialize_against_pte_lookup() only gets called from
hash__pmdp_collapse_flush(), thus move the related functions to
hash_pgtable.c

Hence this patch:
- moves serialize_against_pte_lookup() from radix_pgtable.c to hash_pgtable.c
- removes the radix specific calls from do_serialize()
- renames do_serialize() to do_nothing().

There should not be any functionality change in this patch.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h |  1 -
 arch/powerpc/mm/book3s64/hash_pgtable.c      | 21 ++++++++++++++++
 arch/powerpc/mm/book3s64/pgtable.c           | 25 --------------------
 3 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..ff264d930fe8 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1400,7 +1400,6 @@ static inline bool arch_needs_pgtable_deposit(void)
 		return false;
 	return true;
 }
-extern void serialize_against_pte_lookup(struct mm_struct *mm);
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index ac2a24d15d2e..d9b5b751d7b7 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -221,6 +221,27 @@ unsigned long hash__pmd_hugepage_update(struct mm_struct *mm, unsigned long addr
 	return old;
 }
 
+static void do_nothing(void *arg)
+{
+
+}
+
+/*
+ * Serialize against __find_linux_pte() which does lock-less
+ * lookup in page tables with local interrupts disabled. For huge pages
+ * it casts pmd_t to pte_t. Since format of pte_t is different from
+ * pmd_t we want to prevent transit from pmd pointing to page table
+ * to pmd pointing to huge page (and back) while interrupts are disabled.
+ * We clear pmd to possibly replace it with page table pointer in
+ * different code paths. So make sure we wait for the parallel
+ * __find_linux_pte() to finish.
+ */
+static void serialize_against_pte_lookup(struct mm_struct *mm)
+{
+	smp_mb();
+	smp_call_function_many(mm_cpumask(mm), do_nothing, mm, 1);
+}
+
 pmd_t hash__pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
 			    pmd_t *pmdp)
 {
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 359092001670..84284dff650a 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -150,31 +150,6 @@ void set_pud_at(struct mm_struct *mm, unsigned long addr,
 	return set_pte_at_unchecked(mm, addr, pudp_ptep(pudp), pud_pte(pud));
 }
 
-static void do_serialize(void *arg)
-{
-	/* We've taken the IPI, so try to trim the mask while here */
-	if (radix_enabled()) {
-		struct mm_struct *mm = arg;
-		exit_lazy_flush_tlb(mm, false);
-	}
-}
-
-/*
- * Serialize against __find_linux_pte() which does lock-less
- * lookup in page tables with local interrupts disabled. For huge pages
- * it casts pmd_t to pte_t. Since format of pte_t is different from
- * pmd_t we want to prevent transit from pmd pointing to page table
- * to pmd pointing to huge page (and back) while interrupts are disabled.
- * We clear pmd to possibly replace it with page table pointer in
- * different code paths. So make sure we wait for the parallel
- * __find_linux_pte() to finish.
- */
-void serialize_against_pte_lookup(struct mm_struct *mm)
-{
-	smp_mb();
-	smp_call_function_many(mm_cpumask(mm), do_serialize, mm, 1);
-}
-
 /*
  * We use this to invalidate a pmdp entry before switching from a
  * hugepte to regular pmd entry.
-- 
2.53.0


