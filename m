Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002CBCA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 11:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33586B008A; Sat, 10 Oct 2026 07:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3176B008C; Sat, 10 Oct 2026 07:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D25A6B0092; Sat, 10 Oct 2026 07:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7741E6B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:26:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B1E680565
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:26:01 +0000 (UTC)
X-FDA: 85306487322.25.6DD1FC3
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9031EA0004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:25:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Gae3uUkk;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791631559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iE2QEQrwTXqpoYPa2dWn+Ity3YDDboIZyxHqWaOWsQs=;
	b=Jktrs4JXlcikSDhWzf2QKyjsmhl4NYu634AeYsEp5/2wNuNnbYXIXN/khFSOfqKywQP9Ge
	8Ho3gRsldjsGLTjLn//pciPeZnqI0eoADDP3WWb85BzWqZpA34hcbYY6FNobzTU9poxmwA
	7y07t0miPFaEyVZxGMFsGfYY+YP6p/s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791631559;
	b=4ptvjFXqLFzAkBZIjSOqVC4cZuZ7yOavi/BM7kgf8Ve/ydQ23/2Ca7zW3LpLYaQZ515D66
	3/ceNlrcvlCJXmebjghtFb0BRgnp1Cc3+/LP/y0kljjqfZCgyJQFNTZ4WS/Qich2ZYrFH1
	yKb7MciVKc/6SkzKdei6B9sGwrmzNvU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Gae3uUkk;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ccce967aa8dso206829a12.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791631557; x=1792236357; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iE2QEQrwTXqpoYPa2dWn+Ity3YDDboIZyxHqWaOWsQs=;
        b=Gae3uUkk67qUCMsngcE+8KZw4o4qmYxENHcuf2X7u5dr0TT1EOKVCwEl8EnUh5lO39
         gInAoaVoUMG+o10EfZ4WpZdulbIWX4UDdDhVVX2gEDYh9BlKfLpEt11u+27+mgL85Il4
         ci8H/KxlNWeHtQFxZ7yP2pCVXe9NlG9lYvC+poY05NEk5VxZ02udWIT9OPJriOsUZeCN
         pcWn2FdsZyO5wW+HX7dPwLaTNbXPZCstOxGcYJmTPBYiVr2qO4ZnKB3IC7mOIC5NIQeS
         xd6SkOBr455XltswPNttc8sqbGoKXQW1cKXIJaCiB6Am7BLGEA7RArNL+h+mXz8NmXPb
         1waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791631557; x=1792236357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iE2QEQrwTXqpoYPa2dWn+Ity3YDDboIZyxHqWaOWsQs=;
        b=sc+oC8erCdHM9Pwj/h9qjjo5H7y1kBOyFfnjl7ftqC5guKcdw67p4mQoRG+zVbClu1
         iWRyTeYRbnX6Nb9d/VM+XLSH19RoK5SXaPD+M404MV+8EhUR9Mat6zLPk3NxAitkU8o9
         cx4FlvSvHhjBIkHpT+gt68chjIpnjWqz4bA+jsSwLb6jsrjI6sBGDK7qS/jVglIRy/HA
         NVR3/GjPo9J8bGRmE8TpBHW3SzwhqNBEFZ5WIyG2zI+n7DdwP0AMeMakqLPOS4Ary7ZZ
         O/nh4IDN3iWgN8ybPoeVW6Z9/lM+4oyuz5MN4YFIgjHLI+llLpFzUJud3aGsDy1LApx9
         Zb+w==
X-Forwarded-Encrypted: i=1; AKwUvBwYIUK3rjZzFAk/XbqAbX23VmgPAbDOAM1sssFlgpJk7c8Z+xf4wkM4uw0uZnER3mMZTKUEDij9Tg==@kvack.org
X-Gm-Message-State: AFq9FYIG/A+Yp2xpNPey2PKEVI3cEo7fuyG4Bu2XMhkwMkKo8QdA0/ik
	qFwQkH0ZXjQPQezQPoqhqEuxWLGGg08EbRnzMwWGkcHnjfUjTCmj759NN/SN1W/DXPc=
X-Gm-Gg: AYBFou1pbn5jI+tIOdvb9AGHhQ3YKxKsJiytuIhpu9+rXTZlFlAjTj5wu1fsi/wAZLH
	SzK1GsRH6UwC4HY/iFQrz3J7hVxpNLngt+wtbgcIQ+Ql3Jd7MEm1YQjiJ6ceiGEGfr3rx2l5Biu
	n0K57mYY8qOr1XEeXeBY+95URi4f7rY/LXH3iJAJT6yhRCpKYlJyjrVHz2+YKiIIPwEbAbkIeA0
	WXumSKWqMyzDXnIH7lwDaIEPUOI9btwtF2GmvrnBzgDXWiwi2G6a5sufVHVs79YfUQaxZJ3eYxN
	h7k9Q+3s0HRHNGrhRrerG80lD/WpoLeFc2OcQw3YhK7z5igJ7cqIGnQBjINH5RkRJbhRW14vhie
	dtaK9rat59l1wY0wOP5HurEyXAJW1wXpd3tG95SJwCU7eTQBw/YbSLGeaAZAUZREWkmPQKUG+Oz
	xGdVbQwuNqVRc6hxqG34Gsp3RKQZpPTS0Hp6zYc+PgqVCkkYurUYub1pYEW0BXxNA5yRvj/3R1N
	njEsDc5LdA1K0ehaXfYLxDfD9tnlxMvhYjUuuBFwOZsLxXX
X-Received: by 2002:a17:90b:2d06:b0:3a4:b30b:b501 with SMTP id 98e67ed59e1d1-3ab3a32d491mr3593827a91.9.1791631557025;
        Sat, 10 Oct 2026 04:25:57 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3690474esm7900233a91.0.2026.10.10.04.25.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 04:25:56 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 1/4] mm: fix missing page-table destructor in pagetable_free()
Date: Sat, 10 Oct 2026 19:24:54 +0800
Message-ID: <20261010112457.49485-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010112457.49485-1-songmuchun@bytedance.com>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9031EA0004
X-Stat-Signature: z3gp91wzywgktojmnyya55abs5dw6f5m
X-HE-Tag: 1791631558-396428
X-HE-Meta: U2FsdGVkX19dJVGllRtXBGorWCWmUapf0s3aKHLeidIV1V8iTdVn6vQCbklIMEUpE/PQT5LQoj7Bn0I9I0L8lpOOGPxAmkwhWfflQhh2UAJLTraZq8OFzZR1KuPNrSKWwGlL7od5DYK7hPJd2HIt1Ku1kwxLyyyxZ+mfokqdBaht/AdJDTSOXF4rznmcv1G3MY9QHSA9sYSbVCOmr/Yc6kKleLOV77BJTqFFgQPE9PMYyE09cvNDTcUcBc76kRo7OOL4NKNd7ZZCXg5wRNKAl53IAKOT5F74cE/deuAgQNHEg6hOZ1a8aT9uTJKRvpsKiMO1D6J/LN/j683NmecS/KfSFktIDzH44RGzbYL/xBfD6cDSIRk3LT4UXub6gK+V/4IkfNldZHzLG/mDMHIhzsNSqIODFuJe6dcjALCbUlIW91GBe8nrjRUq/2KBw7o7L+YOfuZg2UJQKT+UOmy5zhaddus4JfbX/oYYfQhhNCyaaR2nhVqATtgzOF5W0PSEl+TIumPUUyRMsSG8XM605dPv5UlE1q7KdeCIpaZ21DHVJq6riYSa2FlIWbz20N4mHYtnY2LzCDORF8zbL5kLdAIkmphXDrKJL513Fk8Lui/Z+jKu2gm4MwF4e+hLgqXFaOhR88dGzmwV3Ud+ULU3x2dvN6jJ08cvFaAp8VjOh4N2ds+HykXJwDF0oaB4YF7dK0TMCE80KUWsE2vRwGIStOfVvRIMZH2Vrl+nqOq/0mj6cYzDbnmPnTVoEBw3VkktUZS2x1wE1rL6B1MVbpMmMGOdxqxQGMyacLHRgmEFeOPje1eAZnV5kmvJa7mYaCVjp44y4n0tucJIbpqftxRNGkhJ7E9OeVKGAQy+GU5rtc38YGAbLLvU98QfXLIei1hWb5u4Nn5ak+xaZRrDd4DfCqr+I70vFvLozhJGUzoGsFEn4/a8STjyfOSS/Ie89N4TugEHhUSWpj1tyunVSbz
 S/RLby//
 IvMqI8RNvmHao1r1V3I2ZfZ1B7Egw9nnV6A9Zh4KcM0ac+SM67Kck+2f2//B3sjfcVgxKqf1uXMvCtDU9crjwYJtV3cYAGPdebximm9HkLJ2mtWuHhNWnJRo/aIptmlt77qvD1RyAQgcsTHE420L7XwTXl6EevhFvy8ZdkegcK/VYV8TTyQGBFsnyR/2/Dfevr0cp2kZNfTnbJL5zuUZxz1nqd+DgotStP7ru20oSuwvPtkzDZkh1mljH/DjDMXliHHBSty6u5zdl09EojqC1cswqtJuivYOSBEpo/n9WoFcNChhOOMYUPyRn5l8uXfzLB3cAk/qYLuudDHw860+tsq715EmABDyHP0lRtfIk1/e2/RWALMLgviY0BnlIKVJU5fAO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
tables.

HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
splitting a PMD. Restoring the vmemmap backing pages does not collapse
the PTE table, so a later memory hot-remove eventually frees it through
pagetable_free() on x86-64. That releases the page without running the
matching destructor and leaves NR_PAGETABLE elevated.

Make pagetable_free() detect constructor-backed pages and run the
destructor before releasing their memory to fix the problem.

Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Move destructor handling from x86 into pagetable_free() (suggested by
  David Hildenbrand)
- Trim and update the commit message (requested by Dave Hansen)
---
 include/linux/mm.h | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5cca90fc1df6..771a7d60b0a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3969,23 +3969,6 @@ static inline void pagetable_free_kernel(struct ptdesc *pt)
 	__pagetable_free(pt);
 }
 #endif
-/**
- * pagetable_free - Free pagetables
- * @pt:	The page table descriptor
- *
- * pagetable_free frees the memory of all page tables described by a page
- * table descriptor and the memory for the descriptor itself.
- */
-static inline void pagetable_free(struct ptdesc *pt)
-{
-	if (ptdesc_test_kernel(pt)) {
-		ptdesc_clear_kernel(pt);
-		pagetable_free_kernel(pt);
-	} else {
-		__pagetable_free(pt);
-	}
-}
-
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
 #if ALLOC_SPLIT_PTLOCKS
 void __init ptlock_cache_init(void);
@@ -4078,6 +4061,26 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+/**
+ * pagetable_free - Free pagetables
+ * @pt:	The page table descriptor
+ *
+ * pagetable_free frees the memory of all page tables described by a page
+ * table descriptor and the memory for the descriptor itself.
+ */
+static inline void pagetable_free(struct ptdesc *pt)
+{
+	if (PageTable(ptdesc_page(pt)))
+		pagetable_dtor(pt);
+
+	if (ptdesc_test_kernel(pt)) {
+		ptdesc_clear_kernel(pt);
+		pagetable_free_kernel(pt);
+	} else {
+		__pagetable_free(pt);
+	}
+}
+
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
 {
 	pagetable_dtor(ptdesc);
-- 
2.54.0


