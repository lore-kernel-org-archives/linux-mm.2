Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFEACD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875AA6B0095; Fri, 12 Jun 2026 14:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826186B0096; Fri, 12 Jun 2026 14:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715B76B0098; Fri, 12 Jun 2026 14:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB9E6B0095
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:09:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 079D21401F2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:51 +0000 (UTC)
X-FDA: 84872048982.08.3DDA798
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 33490C000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kr+T6Nec;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781287789;
	b=Yhh4w4XuFStzXDQhBvuNy7L2MtHrJgUy0k5VWX6o2+Pmjqsm+hnuLE5gZkLT2imHppNJxs
	pIJLLenuG3LGmbT7a8Ktq2+lLxmrQ2AjwbhpD43aA5ZUfn5nJjFQ+QTBO5D7PLggFx5SvS
	+mg/Av54qP09A7rXnTMJMdRoo4lPIB0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kr+T6Nec;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781287789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScGPgP09d6CTH8k9i/xxOIHmej0/0GzUcvmFJcghR1c=;
	b=M09vTBeUkP6BnjddSS1xKpXl4D02tX3TI6XI3KlXQdN+egTUbBlqAQC0sVlZebXBaUg+TA
	3yQ30kWU5Th9pXorYxrfqdwesWjFxKp6SB3cDEqjCwmizA1wk42X92KTNgUQwW8LEllRUZ
	5uwNcBxV8F2wX+uwMm7OM0hV7vdJIJI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c0c20f0c0aso10038665ad.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781287788; x=1781892588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScGPgP09d6CTH8k9i/xxOIHmej0/0GzUcvmFJcghR1c=;
        b=Kr+T6NecuMU/AAZouFZu5k/IMonCSTN6FiZTtC7/ro+7mhMuvZim8ts9IkjXL2MTz2
         jYTxwCdnzf7xejB/+WPfBHSeHVwuAU56jrsK+doIbIuL/pD6Iv4Bvq0LjDDToBvKUlJI
         ohvD9CEgoBbTEpY+VpV9eKlH8g9B/uPNXdKlbL++rj+kle3bvaReVAxDLo8XD+7Txx+3
         fLZJ5+D/gumWbMbSlMIZWr1U3S+7//sFBpVp3U6VSBw+j5M+YM5BPp/izyP18G1yZh02
         QyHmcHt/SK84zd1l6FmbLN22JQZTtbwycWrZE9O8qW6PpirsYCYqQ2xKLmI9LrSkra1s
         01Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781287788; x=1781892588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ScGPgP09d6CTH8k9i/xxOIHmej0/0GzUcvmFJcghR1c=;
        b=CzUooRRkZCP6DQtAU3Wjj7TPCkwq23xTCDr6yY/uNJHvz1o4SgjvNlj+7Egv9mF46S
         0fy1EzPI9adFC9INY8R7Th73/6RmestdTjq1zzPhwFIjCOFiVKTo5oDbzr3Y++rfi3cn
         JimOWTKLxea05GxgFuAQfTdBZLap8jEv292vwSNOoAGHqaJmvve/c5md8X91I9cAN/oL
         audiSC8Zu5lNTvcr2E/I+0zA+bebHeLWIETVezVRHxfCt/IuGfbM12yPmcmswk2NjcFE
         b5cKjfmeRgnnFOH7kpU+zJHHu3hIieRma3KAu4FUHRLS0fsVC2JS1hbmnu33RVl7Mj6q
         RGow==
X-Gm-Message-State: AOJu0YxeUXVvcZZlHTy9gbqKmAkoKLYZQdTXLcmZJT54trRj8zF6HcOO
	NLRilTJtEh3yHKJlsXW0aVXFvd9vvmKnnAfxzZqT62bCOVUMcnapTrZEtT+hDGRJ
X-Gm-Gg: Acq92OGF647eMLbyIq/hr06+CxMX1lI/2QlVmfMosGwDeePPQE55tUw8V2Kte4xqyk9
	mkQxOcpzXwWoTbWqISqgfreY28s2lItCsPag15lRMFCGpYGy+d1jI99U7mP4d+Nt+zORbFqs1Ez
	JROKVn8ROKv6oifI7Ynxo5g5JuBtF9yLt9kG1HKWwPLx9/SW3MuOEhviQjDThbUWiv+5cgZAR6Z
	/9tRg2XBEimxbC65i4q//d13vQHYbiTGRpzBSDRO5TUUFQXlijItzQu0hrC9kDSY+qlfnRSEwOG
	LFRFAD70eA02zdmWSi7I2W1SPLpMjYMve0oXSSmYiBCUCe41KFUSgSUy/LFzDWU1Scpwyz88Qlb
	OVY2pgoCR07blhEEMw4PZHjzLbKjgDIdT2jiltG2bPkUpaZVK0lmbFUAYc7fMbO1lIArJQfNMZ2
	mnVwGP0J8qmAW06vYHELyww+C2jpTDjrFp
X-Received: by 2002:a17:902:d48f:b0:2c2:1982:5270 with SMTP id d9443c01a7336-2c6641e28f9mr8104325ad.21.1781287788002;
        Fri, 12 Jun 2026 11:09:48 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f7c70easm38956975ad.25.2026.06.12.11.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:09:47 -0700 (PDT)
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
Subject: [PATCH v3 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS via ARCH_MAX_PMD_ORDER
Date: Fri, 12 Jun 2026 23:39:16 +0530
Message-Id: <a1ca4510e1bd3090fa639709ffcf10430eb4c136.1781287297.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781287297.git.ritesh.list@gmail.com>
References: <cover.1781287297.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33490C000F
X-Rspam-User: 
X-Stat-Signature: buperwa3j8n4qtafdgasg8s8q3nhgo49
X-HE-Tag: 1781287788-385278
X-HE-Meta: U2FsdGVkX1/iVSaTBK2P00qz390J12fo+TLuOJ8M04gaP/6sTxwm0FxU1Go2VlsHVL5NZFCI5cpbqWhufu/gjKHqCKPWUl4DCx+nu5YZKrXemEM7b53I50qkc4izt45k7TDGOfejPVkJJ0gEINlUVebZX+GpmdzEB/iyYHRxOcEdv/Zb6vxptGt5FhqUhIVgpWXD89JKSc9eMDyHNY3dFEh4lIncbddyPdzM67NKlKfdycH4k4PR48Fe+gEhh8RatV8UunUyI6AEj21/V/sPSh6Mi52AadNfVetPW7cKuPjFmQDPkX44z9mfjo/aD6Ga/anaryyTxWzi0t/ePW4Y3FUZvHXLcGx8lY4zE8Lh7yDjXYr9EEcGFrxb8i5oNFh6QaeDQXee45KHyx+40e6EladjOmzs+aF4ZKPQCgUzlw0vogrYwwYTfCTX4nvXUqct7CVget6ZZEyoshIkR1csL+8b+YPIJ4N+WESq9Yt65Nw41o4U1249ImtNeZEy1QLuiVGh0X+X0wwDvf2nJ7DNIUfNwUWQ/0O45vwMve2usweeWvHFX8TQrWZwr41cnYCancfw+/qt5f0vnzZlWHZa5WdjsUVWxUZGGovXbVRNaA1gPEPuO1CrxYkFJCp23sfPa1jm8b5spYXNpxpIzYot3Q2cWN9ySFvrrRT3zWeLdtlzwtim7RIzQQDclD4TA1X1EmO0LTipzolUjHYXHGJUDf9qhstf3e3BfvO6dc9/F9Z9YzqgyN6ivKpRPXHZtccDWifxAVOR6+nW0t7SOttOHdxy/gO/TWF59f18NOavyJqzlc7uGhU5IXefNrqtGgH88QWm9AjsxZsiQH+W8u5OJM/4YVEllFe39EhHX9NMtdyb1GX/XMG2edKYL2D4s+0sxeEzLDaNHV86BUgLc2wkgig1V8uwj8B8AxPyu+qpxnkgN/cItt7fYgaIRgDMU59Trit7Fu6WRgTYHzipXmg
 FQZmi5yn
 w0glzFzoXo3RawsBLNv5L4KXa8HvCgct+xYnScFNKg5DPVbVGtzJTD7djAgeK9wfpjzlMERPUjwzXBxxJQvw1JwNgbSz+Z6VAvJPRfKUQz5S1x3CY+aDru7hx2puf5nVzYcfX4Iy25FdBUGgrbmQm3rTr0x6n61vQqySL/tNldnAmy1WVfCD1Es9XpvRp1jio6ebY4m/EQk5Px9QIljYsJYi8oN8ZgbWUEqIZ9bCgMcm5pT822Swf1U4GcO4Pu0IBbsmcw7ACf6eve+1LCaxHyMeakR27VnZquPtqjPFdE862pmEbcGi3Fp7iRYARxuwYWoGG5rbHD2aL/ShDz82Q0QKNMXg0QYciiTSHtU4KwA733fwolmMVF6DCU1vcXUMdqRdwIfF3RoWor3GAI0fQpxDAxkXM5ZFqcTfofv/FE8+0Y8bsntrf9iK3G7Wz60jziJ/Aj7oWvuO6cYTxdXYuC8gpXI+fzsX3TVOf5h00okE/mInfBhwmMqCqyrOh24BVbsmU99b9ndXaQbUGPhtKipL+D5NXhIp7HIbHmgwYEr4SqT2czQWQsC5KwuDMtvv/w0SrKf8oh8E9ctnKu7d6iC74hkensw26HFr8AVci3x+QZbyq5IimN79mAJ6dLsVY7o4W9gD6HSLKFVFUTS+TSIgHRXsP3YXBinHmHU2slCkcEJnOt3w6g08Ty/3epbsxmIfos9iePavKSgyovcXg1MCUQA==
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


