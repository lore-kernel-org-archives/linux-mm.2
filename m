Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07846CD98E6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 04:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67C66B0093; Fri, 19 Jun 2026 00:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18346B0095; Fri, 19 Jun 2026 00:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E7B6B0096; Fri, 19 Jun 2026 00:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91E7F6B0093
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:41:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 117E2C1B1C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:35 +0000 (UTC)
X-FDA: 84895413750.28.D4246F4
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4137F120004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JZH/GSYW";
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781844093;
	b=Jgsavgp6Dq4jhmUoRQCUxZriOd7rsXWDjQIg/s4HgSz/dm5C1E1RAH3llZOmpQ54Ls9lmL
	SveuLmffRg5hK2X4SYZHT2QLlCcQLytNkHSbZIQaxluDdty2Un7Hjs+TucMe+U6fpkZxsL
	kpzS4DNZdA4Qmd/KPojqYiJB/O3L1eM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JZH/GSYW";
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781844093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScGPgP09d6CTH8k9i/xxOIHmej0/0GzUcvmFJcghR1c=;
	b=FG7v5RWnlpyeEUzXD6HkaSWTuptNPR/vd2pW/L42m8NyUhOLt78QqXLywV5zOF4uT4a04w
	wA/FduNHCucAJP1V+FlEHK2T+aSWDcgkeQFV/+p51ALdITGEWGCLAaKRflFfU6tyG4UGq1
	s/WU/+Nhnjq2Wb70Kw9mzKMqRIGlBoM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c6b67d5fa1so14323895ad.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781844092; x=1782448892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScGPgP09d6CTH8k9i/xxOIHmej0/0GzUcvmFJcghR1c=;
        b=JZH/GSYWhG5ZFGEfa2wjXMu+Ksq9gNoVm3AN7E7aZeiLPz+ekLsDwN7n5qnhG3NsO+
         aL/e30wVWkOmxS6QUy0CH2XC4BSOxkRo4Wd8ux+FZ/V07KH7wm5/CuNOsA0XaQbr6C8j
         JyPALrgo6ateDuEQrxTCOKv0rRo6sre2P/w4YmaKiW1Vl+fT1HrOkYLaq98aa5WHxrwz
         mfzRUtP6VOZWX/nLzGlfSQRjC83q2OWx69iOUFCRl82Z79IvVNWz32RZ2J4/qJotJjqn
         Wk/jGXKtAMjW3XF0i3iKXGe7TL/peZQhCt6el2rXoHhT06y8NXQfHvRW1YX9cEmCi8+q
         SHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781844092; x=1782448892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ScGPgP09d6CTH8k9i/xxOIHmej0/0GzUcvmFJcghR1c=;
        b=fO2USIavBddiKb7Y6Hwmf0rSI1M2osd1nZPJuU4aRYoTP2G/Mmftq1N8RwD1XHoAiV
         DkRgF9X6x6O2y5Isdp28fyAnVQcq8n36CWEw79nNiBOhphhe9eiQU5lgG7MpHCPswNFI
         vp21hEIGYJWT0UKUa3oqnOu1gpMvlOB5tCj6/yxcD83jkKRoALnyLSgLK7kD2tIujtzk
         UtlyqaUlv5q13Q2rvrjzP7iU1+H1t0+VZIFZqGERVL+tc4CsHWvxSimg1o8Ts38aopEP
         3c3wKISQrNmt3c+Ljwilgy3fajM2aUOje40Jqtb+IC+gFUqIwwa5LJmmobOu5b6jZyjg
         F9mw==
X-Gm-Message-State: AOJu0Yx6DljixEjc6Cmjb2sRj3vA7gvBIsIMaCl/7NKYryEHpdhOYLiB
	j3xBuR4wadPHVkftn8rSxms4lCRR8t/hySrCASVFfyOcqOOUUFfSqCCEJRxOoA==
X-Gm-Gg: AfdE7cn8IZ50ukGn6FBcSu/BZjHrpOI6RhtQkWRkyojYFgqDU5bmWOnKOKl07EXzbRC
	3k1/P/NUxnNFR4kcpr0PKcs+Skhl8pQbmhnIv1NmlydYgv+jwJt/47+ykk1uQB6Xp7Zx64ivPMU
	XAQmKDY8TsWTCjzGD7vRuVyvqRp6mHACbujDFRLHyDXR8KMuwZDw+q0h/F5DgNPGmVBM+Q2iYHa
	oyNsrEK+vmnM4qjtJDofqQ0Koc0pK8dselRTuIhbITLtvofCHUw+wFdaGb5RTRs3HjBpQqkfZ+Y
	u+MM2xMhYI4seg0X9XpRQxs7gJcTKW/oRMEQZ7X057m9I5XH8IVUOg0YUYQx2UX4jfqeuOeFV0t
	mSZOAq2A6XwWcWiKBDbjyGjxokrjMJpeqpxG1UuNh73n5UXjpR+PCw34RCZwWX3Q/i8AtJH80vN
	sHj+cp/1JTzTEy/10gnnmv2Q==
X-Received: by 2002:a17:903:2b0b:b0:2bf:dd8b:7cd with SMTP id d9443c01a7336-2c725b713c9mr13974385ad.10.1781844092067;
        Thu, 18 Jun 2026 21:41:32 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7208e5760sm8293735ad.36.2026.06.18.21.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 21:41:31 -0700 (PDT)
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
Subject: [PATCH v4 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS via ARCH_MAX_PMD_ORDER
Date: Fri, 19 Jun 2026 10:10:58 +0530
Message-Id: <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781843449.git.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y5rjrarzempth8mbao1nnwx5courhehq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4137F120004
X-HE-Tag: 1781844093-800516
X-HE-Meta: U2FsdGVkX19GOExYEXNKgJEKJ0qxbKdQ/7gY8pveSYf2bZ/E5wPzHbm2AUyjG39/78uze5RHOXN3Dqnxf5Brw7lNQhDVrxkGl1K+HOi8r/ds4oJXVZe1mq4Tr+b6XbF2SprVTg4tFeaq0VLNNvQQd2ALwQxoz1VprMyc1HwZtGnwINTv6jlmYzNJdjBerfou40K6IZvznwGTPnue8nA+/Bvdd6KJlnOkdGlJ8KLX8ovz9lcf7CH1tS23pMvSMqq4BsNHWw+R1Ar1JaLEQ9lYJHGMsmOS0WwDtnFLzg1vKI8V+zNdOY7Wha2FO+IHfz2EfHNJumGoECFFSlQe1PpbM/auEiKX/d/T4aGzXHV0HWeaAdsUztgda+llVQ7lk3itzUkl0+bNehBzARHlVaweiN/PxvfEEksF6HkWfqA64YDsF8sQTwA71QfhhUkyF6zCG7KqBV7V/GNwcJMMuzeX7CTDtlx4FaghXHe7WxDcf2+mvfjf+Jsk7PnPxpnAFINUegZKEdxmY4xY6e+gpCSp4lkNxcGDCW5LK2q20UnoKAXD1jz8vV1kE0wX2MqP75jhlL5imr0Rs1ExaALnXnV/xvncLlcRM8Uu58jZV9J6tt5TqaKpIoK/qdiDVtWXV6bbGG+zsbYR99ifF2kXS8XT2cZghLHo/Xw6WaE3sj+JjmGnMdwtOSuDNHIKSbiXXnOLfM6cEKE/gwcvCbIvyITN7VOBkvT3+pFxrS1AYF2Yw9qIPDPvVKS7HlkBj7yFz8Qxh6vPcNUFFAF6WSpneDh4FrCOuYQ7mBQC8HE6AKstsgA+ZTp1d8qJClsePz57J0hUOVGeJsOvZsRhZd+WD9KwKb7L8MJwSdSfafH7gzNruYjrRSWXZW1xlXx+MHjz1aPBJucBVbS6/Kl4HVwlZOKbsXFRpJgqBJ8jT1FVibFnEmXlKYzqjlnX7KO1tMDVgIpzbny2eVwLJCYFikmJhcE
 4+AuAkbu
 btd8OO6BXr4BeGcYlgtEjmkjZ0FpUHBkeFPnluBwS8X3IXzmonZelMGIrzGymTIWwqB+EsnVv1U0RXFxgXrPoEZT4m7GG8NgM3L3SGnTTm3MW2CNf2bSprU2H93nAljbaQqUaKXhPEryFtC/xVBTVuv6l59Pm5eEX35trcBZroUykg8NZSrRnOXIi/k7E/xHvFtaeTdW2M/ezGLGUoiv+O3LqPyMRW82XQLogoCkkVoI9GRrqLPkszaiSjOOjmoOszsbQFd4zuACZfXsYNJY1bU3BOUOLgpsGlcTocc5N5epEeOFrzxaAjas9CZc/sU9eYLc4GHz/pfFnNxU8pTjixemW3J+iObhy4PDNX4GKBSkqffstedAh1Ku96JF3NFyElsBBLh/ncxUaXDDo3MdxQxFIFyrS1S7/Z9142bmHtbOizOXlJ7BNvNpAcGkXSvcCRdAVwA/mIEcjbRdha0hKOtM0YcHl52PMAZ5/NnqArbPUXR/ugOkx7imLlQ3WsOJbwkI2I+Jq/9wxBmgxToNm+akcbaIwZwQmXJoUWggtBxOExKP1iJ+cVS97IhQsVbwO9t7sxg3Q6LtaQELuXRMVL1p3r8OJ6MjQaQfwAKZ+W3jfiSqF+6mvMh8Itw==
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
index 8f0f68e245ba..317168aa2db5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -229,11 +229,21 @@ enum {
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


