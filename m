Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0193CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505976B0093; Thu, 11 Jun 2026 05:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD6C6B0095; Thu, 11 Jun 2026 05:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F30C6B0096; Thu, 11 Jun 2026 05:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4DF6B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:48:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BECCC140517
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:19 +0000 (UTC)
X-FDA: 84867156318.14.8BEB004
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id E2B58140006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c+m38Ro6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781171297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kbz74MU7QErdxN5+g1e14+NsDJyyX6Cj5o0sAgDfuo=;
	b=7shxWo2oVXqgoG89XtlsPqHdM/2nm9ANk6xwmetNkU/mYIr+qJCDTXxykxhPdZ6WonWPIB
	yfPjNOzMMkXTDNhglx2Y705DTfK75dEseqxyVGX5cclOM1Ld7CHEntNmJqNvy5n9+Bveyz
	dRd7xylzM8TIEv/v32AW7q13M50U7Hk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c+m38Ro6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781171298;
	b=VMyJvJ+S+40Oa2gps+pZSEtQxWz2L21d/19j5/WXhm0FeFT5NiXSwcjjymqy05uFUamI7J
	R2iWtdALq2jwmwG2VSPJDTdhwj9YFoAVyeG1pHk7sb3muT4kSwtgNtuvJH9xCzYvgEIYlF
	ArnqE3zIScADQlHG3w85io8F1X88wz8=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-37474afe908so2000847a91.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781171297; x=1781776097; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kbz74MU7QErdxN5+g1e14+NsDJyyX6Cj5o0sAgDfuo=;
        b=c+m38Ro6cmalnm1xzxE+JPr6dtVRoXX2yCwqc4v0HRuNqgbd0/i63YXR1GHeqCfIzB
         3lDkZbWzCaxSl5KzQDKveT6Gc0tTgeTR9AQL3qp8X67M0ggZ2iz80tJQP6f5ib5Bo8NI
         BmyGXnZvU7LRBoQDumrNuybJwD9AF0hVbpVME2Y6O+Lc1fiSN9gSoSrONvgJl4p3FqzJ
         ZTeLxosz2uQcS/WdKRLpHgN9WrY6fd8VbQf46jAPwKjBexRaBqlhqiqwSW/N3R2lS7Tb
         Ho8lgXN3xTsCs2Jn/9w1Fer138uKqycOVNBqqyx8Qorrm5c/30OzmpYzMF+eMIU4QDQX
         hPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171297; x=1781776097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0kbz74MU7QErdxN5+g1e14+NsDJyyX6Cj5o0sAgDfuo=;
        b=IQz+WssHxnEqt5+Avug9MWj+4uOdToC7Eb5mQ4eDZ6wIO8s1ncg1fbhnPqCt5mfYC7
         D0WIpoIllOuyL37vPZpKbBwZpR1P+psw7AJSc2I3FANnWZdoDUttZMELeJ7eb2sCpuYu
         qa/eUQ6SL6Vu2znNwAFknNYRYxlBNwU4Nw4DG4HDenCaAGy2c+taSKa5V8VOFq2TytR9
         MiiVjN1cZK+fXw+wrNK4LxSFHmViJcXvU7ExG0/IKzYjXaRh24RqcOD+WwiTuKww3U/z
         a+J5LmJumBTvTT1MYkP93emdcGPMHGIj/Nim66jeu2t+mzTByzB2A5S/FTFhDRaoLyAZ
         vYGg==
X-Gm-Message-State: AOJu0YyzszChaLOniMzrpo511+06dBraB1D7Xtf1G615oehUQth6GbWm
	pYLfTGQbKqFXfd2ceskjXIJ2WI+qJP+bwNEf9ORPYT7GESXVY9I8GKgo1FgAIPoR
X-Gm-Gg: Acq92OFKPpun9IqGzZivhneoeMmS/78j33nSLCmMQL8+AAiBlVY/lKGOMea6BE0xaDC
	cu4gN7b3ecD8T8dXdEa4vy/zLlDMgB4dDLWrKbpPphf106cbyIx6p2zvNF9YmJ0wGUdu6GG9C0t
	HX4GymwvjxbGdRJXbxyC/alPAhWL5TdrLeTV4p09void1HU2Y1rsF2fmj8OP36JU8Oz4YMzDV2v
	/9v0kifHqoznlUSDpZzRw29+aADNKZfsymGcQcl3yS1RgKj4dq/bTRxQe+VMvaiBPbi88yw3RMv
	R3kvSdYdnleqdkW6MNSAf9h2Z/QWcy236p752lQMRFGDGUU9dmf1l6Q3G0hlAdL+AEL1ujyxSso
	BFwaHPCWFW9NyYrMEymW/6Dsfar3SAnhuXeKZh3P8qepdd/U/fLdJeSAxNZLE0BdBczAgTCi2Mr
	dSu8DA/cLeyFP2qWuGlGkdLQ9pxMbshfLRtXpvDitXCuE=
X-Received: by 2002:a17:903:247:b0:2c2:bd05:dacc with SMTP id d9443c01a7336-2c2f0f11c2bmr23663225ad.16.1781171296415;
        Thu, 11 Jun 2026 02:48:16 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629d042sm283324905ad.60.2026.06.11.02.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:48:15 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS via ARCH_MAX_PMD_ORDER
Date: Thu, 11 Jun 2026 15:17:52 +0530
Message-Id: <4821927908f81632fb2a3724d4ff99fe2a946506.1781170904.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781170904.git.ritesh.list@gmail.com>
References: <cover.1781170904.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: t8nwethu7zr8wugg3rwyxb1orq6ppj3u
X-Rspamd-Queue-Id: E2B58140006
X-HE-Tag: 1781171297-721942
X-HE-Meta: U2FsdGVkX18f7gXV5OSWmTzDKAT/gE8dHOw08/W2L7lBI2dqM65iRtIHiXnd655weR8aO2c4MrmIy6I6vu9Nnn8ASMH5YcrQifMt+ULMg3HCOACC0D6fnM2NyqHqaXqPpDuOZOjcu0RX/TEhzhH+qDttv6EwlSPedeHc4hIx95SRsq5ESkaxGekJmMYAyAYZH344ojsCwr/GfjN7QCHIHo55GjJ/2bM/1vWJgcp1Fa2AYEn1siul881QLcRwQQZuYA/V3+E9zK81oL7/fBwPOdxAAPPdzfk8R0IuQSU4mKWwdkj7nEPKnvvj5djSF2cR9zacA7QQg41Aztkg85ht8/Vh+Lde0vJPzEw5GyG5DFZR5ygIpfeHhsBox0z3VZVwAq7qCR4y0TjXbUwGpzk++Ruz+6vCRLaDSMB6B7rBbBrDtqoK+hrftBwzU/N89bNS8439lF7ChbCIHo3V8BMWEtfwgBYaLcv89UwsGyTnhkfUTXMFnU1j+ybdQ/owoYZOAuLkRIk9V3r1aSldfp3t+/6v/wcbcZ7j8fqi+CNuCJ5x0FJxlvJ+d+/JsNm9Hs0C1CpKGfD20vzKo9EJl7nDzILYbTb6ViDSqusRNcEnwQ0fUoR+2lDnyaqq1+GafbOEF3Dd3ocD+0wDrh6EDcaJuyPpFCpBfFKiQxBWGHn2hNTZ/r9GQRPwLjDEUySfo1MGynZkECZRahwhKsdIT6iazBR7Fse5glcfqQveu2Bk2pDXtJMnm/+4fkCqcPw6w0I3bia6+6HZgD0sMaoZnnplocBKVkMtbeKjrasgMZzhxYQN9gGg2jPUBBz987Z1mczrGt/Ad2D3xrxIuNpGEqYDmOyMIpAuqRevPxhR0Ii7tAOUFlJAMBCwQ8JcHKXUOWHbJBBcWpPZLyb0dzZxyFtqFzoCyk9FGXBbb/a5L8XZkEcc3yK7x5wgp8/+DHwkiwtwJzXBeEVHogA3GY1aiAe
 mYaed2q7
 246wJ71ROyRVN9zQYcx075qLjVd7MMu2S62ftb9rgTyl0TAKMnFTqUW9tmllcBC9sPefCHBmjUiZFrKfFZq9QV7LBJZqNaTO9TmPa4XOEC6fLkQSCNgG+odSJ/R2njzsz2BxxTWQffCi7p0kwbkp5aN4tbTWuY/qKsGoUW6cdaxTzMQ1whtSwyzYEd/TjA2qdiQMTdubPLbZkm1Pcvex9waCQOKW+z6sN8zfS3QaGo1KA0291NHJ0u9bU21LscuH16/GI3BlW8oqoQkheR1/Vp4bOaanlH5p2L4qgubjC46foHgxPUHBlSITmRmKoM4zpAG7wSmM57HT/PZwFWfE/3eBxCA3h1zegXtssxduTzSm8Ew0Wz3uiyJxUXNYkuzuOVU/7xweySMzzCnLolzJWVkSRkLWsYh8cEbqkWosqdcvhmqW2dHlxHS6cnDhE8WOMaMS5RQQ57mnvcSLryoTIhnLJUxZRMiBG1pNZD+yf1+womhw1yC05/xDSAcKItLaHBkF1TomvTIeRrXUG5/w9ickst7dyhWHhI7C5JrU4+UZ35cE/+4drSNDnJQ5hla8CBhY4PNXv8jIs+ZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SWAP_NR_ORDERS sizes a few small bounded arrays inside THP swap
allocator code (nofull/frag cluster lists, percpu_swap_cluster's
si/offset arrays, next array for rotational device). This currently
expands to PMD_ORDER+1, which only works when PMD_ORDER is a compile
time constant.

However on architecture like PowerPC Book3S64, PMD_ORDER is a runtime
variable which depends upon which MMU is selected (Radix / Hash), so in
that case, PMD_ORDER cannot be used to size the static arrays.

This patch provides an optional ARCH_MAX_PMD_ORDER (upper-bound)
override for such architectures. The memory overhead on enabling this
override is negligible. Even if we make SWAP_NR_ORDERS runtime alloc,
default slab padding could cause some memory waste. Also we lose the
per-cpu cacheline benefits (for percpu_swap_cluster) because it might
cost an extra cacheline indirection overhead in swap_alloc_fast() for
fetching si[order]/offset[order]. Note that a fully runtime
SWAP_NR_ORDERS was considered in previous version but was dropped for
this reason [1]

[1]: https://lore.kernel.org/linuxppc-dev/pl1zdksc.ritesh.list@gmail.com/

Suggested-by: YoungJun Park <youngjun.park@lge.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h |  7 +++++++
 include/linux/swap.h                         | 12 +++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..7f22d5d5fbdf 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -204,6 +204,13 @@ extern unsigned long __pmd_frag_size_shift;
 #define MAX_PTRS_PER_PGD	(1 << (H_PGD_INDEX_SIZE > RADIX_PGD_INDEX_SIZE ? \
 				       H_PGD_INDEX_SIZE : RADIX_PGD_INDEX_SIZE))
 
+/*
+ * Compile-time upper bound on PMD_ORDER across hash and radix MMUs.
+ * Used by THP SWAP code. Check include/linux/swap.h
+ */
+#define ARCH_MAX_PMD_ORDER ((H_PTE_INDEX_SIZE > RADIX_PTE_INDEX_SIZE) ? \
+				H_PTE_INDEX_SIZE : RADIX_PTE_INDEX_SIZE)
+
 /* PMD_SHIFT determines what a second-level page table entry can map */
 #define PMD_SHIFT	(PAGE_SHIFT + PTE_INDEX_SIZE)
 #define PMD_SIZE	(1UL << PMD_SHIFT)
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 46c25523d7b8..4e1701b4a565 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -223,11 +223,21 @@ enum {
  */
 #define SWAP_ENTRY_INVALID	0
 
+/*
+ * ARCH_MAX_PMD_ORDER is an optional arch hook: a compile-time upper bound for
+ * PMD_ORDER across all possible MMU configurations of that arch. It is used to
+ * size SWAP_NR_ORDERS on architectures (e.g. powerpc book3s64) where PMD_ORDER
+ * is selected at boot rather than at compile time.
+ */
 #ifdef CONFIG_THP_SWAP
+#ifdef ARCH_MAX_PMD_ORDER
+#define SWAP_NR_ORDERS		(ARCH_MAX_PMD_ORDER + 1)
+#else
 #define SWAP_NR_ORDERS		(PMD_ORDER + 1)
+#endif /* ARCH_MAX_PMD_ORDER */
 #else
 #define SWAP_NR_ORDERS		1
-#endif
+#endif /* CONFIG_THP_SWAP */
 
 /*
  * We keep using same cluster for rotational device so IO will be sequential.
-- 
2.39.5


