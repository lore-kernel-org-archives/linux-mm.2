Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8892AC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73ED76B00AE; Tue, 21 Jul 2026 12:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7167B6B00B0; Tue, 21 Jul 2026 12:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D5C6B00B1; Tue, 21 Jul 2026 12:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 397D76B00AE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:25:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B023A1A01F2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:06 +0000 (UTC)
X-FDA: 85013308212.29.A828D17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0587640008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGIO4UJ5;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651105;
	b=dxJFqZ7nUhr0Ceyp4s5VYHuwrxspkfurteaduk3OKJhuU6GBO2HOu1AeDujFcRJRiX1KBa
	Su0WjgysdjjEIA5inUH+mhv/xuGtu8HN4VAQn2Tv3MlOgzpYswB0x+zMsvnL1ymACZ3Hgf
	7IwGSQ5urUmKpqyB1wexc/4c6CUpyRc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGIO4UJ5;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHE9E+mQ6FecAcifXNkjcLKFQsJdzpbS6vo0hKS7MCs=;
	b=Jp9U4VeJNiwDnfcv9x6hh/3eMUhTN7fxTgHSc+8seERwh7uwiRE3diHhLUuSHtxf6wjxHL
	mdaHZVKnhabuCWJhNt/eAdxwRHqeNIZ3jk+Vd7gtshp6DdzKWSKiCbCeVykH6UTcegppJ6
	oYW6gLpE5jB+38VZviFqEyWfJ/rK2Uo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A9BE42446;
	Tue, 21 Jul 2026 16:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C379D1F00A3F;
	Tue, 21 Jul 2026 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651104;
	bh=aHE9E+mQ6FecAcifXNkjcLKFQsJdzpbS6vo0hKS7MCs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JGIO4UJ5qxnF1hC6IdbRB7Cz7UAlenF2xGg1HDepQsa9sW3gzBG8KEjpg4eaajMqn
	 +1z2M14sXjjxZISNdj5pwAqMHTYh+ZMsh7mBT5HDyAo4CqTgBvlVgEdpN1dFHSYHjv
	 rUbGkkyOrsNatXd86xR+fx/PQ1t8YjkznLPlooouTIhlpQwPD4ct6gTnRbtt7ANt/y
	 z/SocZF0FQ4ral3W7XLaZeUMwSW4tF3g82+UCiwgH8TzGWqC5EaaSGPxt1pgyfaO7r
	 j1iXeKTnDY1apTx0ilVi+Jb/uOzHx1utq5agfbvlNdBmjxsPvPlSKQjQ7EZqcXI7ID
	 eKsxCxxA5cFbQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:35 +0300
Subject: [PATCH RFC 12/18] x86/pat/mm, mm/set_memory: abstract the CPA page
 table lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-12-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: 4watobcsp5okeymo8ztcha6nhxokui19
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0587640008
X-Rspam-User: 
X-HE-Tag: 1784651104-802087
X-HE-Meta: U2FsdGVkX1/4RhYYS4meKdjRC7Owl3fiLRvJTKidlxbAg/NbcQPog/o3bAKbXvmBVgxuxXphQa3he29Sr8SHvPZNGllEmQthCg4/C9O3Ni17RO5tCcRrCyjaEaeX5exzfyrGPhp16xvbJ8JhAfvBDbuxOc76CilHDjQ0s+HxmcT1xYL3ZcbBsw8RTvBkJbgKuQ/PizGQ9fnTMzhpDBomygp+6Ifo9HAttcUCCAwJGlNzTX1eNTlzQ/HGGtYJPZ7/wInRUyAcX8KpG7yk5af7+xV9iXPeAIy0ausV2iFF8NVaj36CmYzE7vnK2yAQYL7257IIyE3lQ+TEACv/ADXn9WIbx6iSRwmCEHbxTvZisIUIVNTcIFDR4ihMYjs5u6WNhh+HdpjwUOOi9oWNGO9ouYWllPz/hfAfkGP4Dh2p40577prwJP+6HHEKG2oKNWQSjorNTuHm6iCYPPq2NmUTCy1IapbNNoKzH6APguT3wMJcta+2BiGYbMRndp4+sgZDUMFz6HiYgb9xa79edBNF6DuXnAgLTGylOg9C6F96yjfNG3aYHVvWl9/vITvnl464HiMs9DSG1xx2Zbt5WEA+gNCeV8naQL8tEZMf4ma7+rRnH+2g7STspIut7rJyNr09ap7l96GoiD2pM4E040OUgPd9adnEow7FU5Hhz9XkOVqIkvpGfJjNmlC6lqDAt7AZJxsHMlDl0KDDZAJTr/qYB8HsFZX7+/AY+OpiLpiSqZP5PyjspkSf9DdruRco0+YFw65VYA5hv7ytxMTz2xUu3Fpx80ojgS6JgvxYCneBlYZQBsiWeJhibcNzN55nyyLkm70UZYvasLvalnH2gfN7wmYNOy9+FH1mPESVSOZ/6OTgCHVcxQB0mm/2/5dP7hLyvZzRJ8xSOXeoXROVAqFu9RMDIWw7T4n3ieqNeLOYfNixEegnhYp9+GtlIfCkpDv2Fq7PjlM+oH8RLiW/v9i
 X868JLX+
 EvReAS+8x5CX4TybWS7rSdhZMvMYBUTPMKXk4Wqw/Focqar+KRHHSG0YvvejgD/rtWoSpc2SXt2mLoWfGKPXSNU8kKmRZF3zCYM+WOdM2RaBmCSMfDziNroLKSm2PB7w2C5yT5a7agxCPlW34FJwnXBztDEQXNn6QE04s+5ICEi3gVWf5yWd8hsFB3YbiB+h23BeL53MCvCeZag+XlQ8jeef8I0qYqbuKGRR//yOg3G001jy3QUaD5gXQdxNlhvPbrE9NIleLdGPtRVck40NZ6jwQR/UGWFjWmiHa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86 requires taking pgd_lock to serialize large page splits against
parallel page table operations, for instance such as
arch_sync_kernel_mappings() and pgd allocation and freeing.

Add arch_lock() and arch_unlock() static inlines that replace direct
locking/unlocking of the pgd_lock in CPA core.

Since only x86 needs such lock, keep things simple and use #ifdef
CONFIG_X86 rather than creating an overridable infrastructure.

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/set_memory.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/set_memory.c b/mm/set_memory.c
index 712264de8e9b..d2846804e4e6 100644
--- a/mm/set_memory.c
+++ b/mm/set_memory.c
@@ -14,6 +14,20 @@
  */
 static DEFINE_SPINLOCK(cpa_lock);
 
+static inline void arch_lock(void)
+{
+#ifdef CONFIG_X86
+	spin_lock(&pgd_lock);
+#endif
+}
+
+static inline void arch_unlock(void)
+{
+#ifdef CONFIG_X86
+	spin_unlock(&pgd_lock);
+#endif
+}
+
 unsigned long cpa_addr(struct cpa_data *cpa, unsigned long idx)
 {
 	if (cpa->flags & CPA_PAGES_ARRAY) {
@@ -170,7 +184,7 @@ static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
 	if (!sd.ptdesc)
 		return -ENOMEM;
 
-	spin_lock(&pgd_lock);
+	arch_lock();
 
 	/*
 	 * Check for races, another CPU might have split this page
@@ -202,11 +216,11 @@ static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
 	if (ret)
 		goto out_free_ptdesc;
 
-	spin_unlock(&pgd_lock);
+	arch_unlock();
 	return do_split;
 
 out_free_ptdesc:
-	spin_unlock(&pgd_lock);
+	arch_unlock();
 	pagetable_free(sd.ptdesc);
 	return ret;
 }

-- 
2.53.0


