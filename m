Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EF5C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21BC6B0096; Mon, 21 Sep 2026 15:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F92F6B0098; Mon, 21 Sep 2026 15:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FE96B0099; Mon, 21 Sep 2026 15:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 711AE6B0096
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:59:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5EED28012F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:25 +0000 (UTC)
X-FDA: 85238833890.12.83FFFD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A46D7140007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=goOJO+Ju;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3OLDjTedsbgC3rcZhdOQN0X2zBug4ET6xkZFH6DZFY=;
	b=7NOC0Esy09Ua4ZtoCoplMbSHT0i0CEQuTQ37OFdo1n+OimKChIyhVVWBQCWK2wvSijaFif
	b8kTFOjMUVqBjCt3f4weMEhQG1v0pb9sGYXC5TS7WWXftjF+F0JuukhK4P/CJbv9sEAbR+
	mbNoafEdNzXnpTQw1wfzpBzkK4QLXI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020763;
	b=Nopl9+Gfj+bBPE4sL8fe+f979EUawDLWVi4m0tyTcgrg153UznUBaxavsFmDPGHiSiPf/V
	A63AXz4hFHiwGwPUH+Wz4rVv9/Y8tnPC8ZsuCZTTzymFvUrjXfT+pBnJ3koiBtwCAZnNvg
	EBwafjUlmjUmVkF8FWfdyknEMIfZY1M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=goOJO+Ju;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CD7C60142;
	Mon, 21 Sep 2026 19:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907511F00898;
	Mon, 21 Sep 2026 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020762;
	bh=f3OLDjTedsbgC3rcZhdOQN0X2zBug4ET6xkZFH6DZFY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=goOJO+JucOQyVJhwBfpMh557Mt7X9EpUqiE/EPsXm4eYLVfpDHY4Sz7us7rwrdmnQ
	 Bfe9PXXPxI2rtkVy5TKC1kpPBhNLS0Dfks+8osZBKG+2uxCn93k+LsvLN55gPfnomd
	 4HcmAsTeQgH22E7n2fE/ONBJ6/4uD9CmmdAep74u34s6N+wXG4C7Wx7N0YyhxML3nn
	 nHXmHNHxzhBBZCOy63EBsxd4Sq90Vlm7Vfz/L/J2QJTZenlQBdgLulgN1JQQDYH3fP
	 U9RH3bGbIYac9um1zcYtRfW35E3dnGxbfY5n/IBwFi+RPzRAEMMBRrUOaGCqgxviVb
	 B2Z/oHF0sdVVg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:58:53 +0200
Subject: [PATCH v2 01/13] mm/sparse: move mem_section init to
 sparse_extreme_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-1-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2075; i=david@kernel.org;
 h=from:subject:message-id; bh=RDUKgR4Zh55foA1PVaXPqBWcOHxguZt1tds+dCAcB5o=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rQqTbnO8DPl8RKB1sUK0hNk3s8y2fL9/Szpe6K7H
 Nadqok61FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEkvwY/kr/UXzOzb2/r9fs
 yu09Wm8rfa8/a+vamDFbU0OUfd+FlemMDP+jP+p8mDLpZB93zpJFEi3mBRu03Q1VzZ0Fj9xLrq4
 tZwIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A46D7140007
X-Stat-Signature: ubz58pw7mgg3kjfugbjjxdd79hr4zr81
X-HE-Tag: 1790020763-122859
X-HE-Meta: U2FsdGVkX19Pblv/ZBGXP+eg+bGS1Jd8nLm47TVsFSO0AekoiBSz2zq6hvI+SfxIVg1EODqrmmRHu9h5rp2hcC8YI1EfzheQ+Ui7NyA+zTIlMcwmX8j5gJmHyL0usO9Z1jW8luot1lHlmMod1ma8pLPabAMPxVLDVoNzTpDiGKCQGMeDxh41UICUHQdCaEXg2hzFjJFSNQTywlSDWoaVX/5pVka7eY432jITtvmNoWGOr9eOPC8pqusoVwOXu0HNXm5+2/r/6e0N8DMksotOlnrBLqQ6DLEQ/0+TVCGfWRzpZIcH9528VZrykMxh/Lbb+YotagCiWDg55W9Le36Zl6V/2voxeVd2qQO97O96LVMYGPLVbMc+P07OGnY3MTjK7eDtiR+bUoy9wc13XQTRXBZ0jwei3K8A7yJ72EvticldgC+Z61OtcsDN/pqLm2aMbgN2I25lzuwvBZsZEBZympzMSk5HcYu9fOISfSPM4v8ulZpo1sx4Fv2Y5NRpDD6+yeKAmFyUA2vhh3gNeTKWEWBs8c2KruBz4f1aN934Dn8sU3KAda1fqMgniNa4f/ebVgO4wkf1YWw9mj2lkHUWbXPQOWkWgNQuLb3qtBlJ4hrqpH4iclkrUSJl+Xg+VADGDUdmzOB+jtiNfJ6bJYE7FgzqFddhz6NDuLoNTNEbHa/nnEJyKUIyAM3ZmnA0Vqq+24XguDdvuAMGA1izVhr1Ta6IchGeJvYegKt6MIZpnCFzJvZQO64c6tRI200EaTGQacRU3W720Out+MB4D/HRy3VW4SFkhkBtiodqdUfjywGokmTjdGf1DPsSE1xAGvHrFRkgohKSFgS0F/ZYYf5FL0aoGZSCa1T5cT5g4R9B7U4xz19cPJ8X0ZUwcOHfPkOLrBfAwcdlkBEVWY2i4DaOJPZWW/QZz4Ka9Tux5ngoBylCyjyLcFKNpOXQf7s5nL+qPVo4WSMLlK9Up5ZPtBE
 R3MykTRz
 eJlzZUkF8FNopg0vSJfE5VE8sM+SsXm/xLN0mr1MR2K7SgsXyctbF7velsMZZeMZnk9CrDwUwAcYh6xIvmO7aAX0kwXh8/K8BWqL01nxinElsvacM3FUaPecjbWv7G6xCmbc6AttavgTnNBerZps+Ql4fvKKE/5KSjNxcBQ4mPDY0Zc8+bTBogoVxwI5UDodPtqoytk76d40qF//YY1Q68KLnZq8/QrQMrxq2S7PZaXloZkmATD9OqfGEhVokH1yJp0iv8L8Yvko+lqjXBsEBYOH1MtJ9o/ZI3cNp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's just avoid another pair of ifdef inside a function. While at it,
switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h
as well, given that the x86 variant already provides one.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/cache.h |  1 +
 mm/sparse.c           | 19 ++++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/cache.h b/include/linux/cache.h
index e69768f50d532..b6e857b985bca 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -89,6 +89,7 @@
  */
 #ifndef INTERNODE_CACHE_SHIFT
 #define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
+#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
 #endif
 
 #if !defined(____cacheline_internodealigned_in_smp)
diff --git a/mm/sparse.c b/mm/sparse.c
index b75921c622ede..8cd2b06b231ac 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -103,11 +103,22 @@ int __meminit sparse_index_init(unsigned long section_nr, int nid)
 
 	return 0;
 }
+
+static void __init sparse_extreme_init(void)
+{
+	const unsigned long size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+
+	mem_section = memblock_alloc_or_panic(size, INTERNODE_CACHE_BYTES);
+}
 #else /* !SPARSEMEM_EXTREME */
 int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	return 0;
 }
+
+static void __init sparse_extreme_init(void)
+{
+}
 #endif
 
 /*
@@ -196,13 +207,7 @@ void __init sparse_sections_init(void)
 	unsigned long start, end;
 	int i, nid;
 
-#ifdef CONFIG_SPARSEMEM_EXTREME
-	unsigned long size, align;
-
-	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-	align = 1 << (INTERNODE_CACHE_SHIFT);
-	mem_section = memblock_alloc_or_panic(size, align);
-#endif
+	sparse_extreme_init();
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
 		memory_present(nid, start, end);

-- 
2.43.0


