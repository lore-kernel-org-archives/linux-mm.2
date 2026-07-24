Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF37EC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586BE6B009F; Thu, 23 Jul 2026 21:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E676B00A0; Thu, 23 Jul 2026 21:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C836B00A1; Thu, 23 Jul 2026 21:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 136806B009F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74907A012F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:27 +0000 (UTC)
X-FDA: 85021952694.24.1175A93
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F35140004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Noio6pPY;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m95tIey3ZtO+pvQbNpV+QgUQHO9n1DJkdAhqLOU6XCs=;
	b=1lZPQc9qkHHnHs6yZJ9YSAgJ974ihxBv7IDllHUe8JrUirW1bbvweXu8JcZ7K7o8a++zUT
	IBzItAqukF4W8N4flrebZrXPMU6v5OoSPgWuYvQ+D6Q+6j6sSM6GWr/W8sQ/JlCqFw5siE
	ucEYnpjJKN+tPNTLaSRpqmwVxhufBaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856925;
	b=AKFH93riXUj/Ao5EwI6DuFNonBaa3/1ALZZuQ2PnBVY7OklL+RN8MJ6QHizYVJnyXrceab
	hvweY/w5VFVII6ou2+ZdXhmCTI+TI1Whh+Xg8eMLw+Er9/SriMkRyC7c9dBMr7o0YNC/7x
	q1zdMYAQev6CnQ/+z4HHT6S0x66g21k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Noio6pPY;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m95tIey3ZtO+pvQbNpV+QgUQHO9n1DJkdAhqLOU6XCs=;
	b=Noio6pPY8iZGbaI1s4OXggq131dBdezKFCOb/h5/avFVYVtTyObHuF2Zwujj/sJR2/j6G5
	Mtg5ndgQ1C2AnAHs2RFtYvMhQi2GGIqcIcq7RDU31zoWbJeYvqy0+kmMF6nMzxkLyBlmFl
	w0CbVgBwbkEWt7RJFVzvEkq4gX7CuOM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-yamiaaF0PwitWjTXObKyCw-1; Thu,
 23 Jul 2026 21:35:22 -0400
X-MC-Unique: yamiaaF0PwitWjTXObKyCw-1
X-Mimecast-MFC-AGG-ID: yamiaaF0PwitWjTXObKyCw_1784856919
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 110CE18011EA;
	Fri, 24 Jul 2026 01:35:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43B6B180059A;
	Fri, 24 Jul 2026 01:35:15 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 10/14] mips: move has_transparent_hugepage() out of THP guard
Date: Thu, 23 Jul 2026 21:34:14 -0400
Message-ID: <d8423d1c5601a902516bb0d0413c5ce4cdabbfb7.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Ed3E4vwCe8mn5dul0YCgM26SRjZh7YXWsSv4B3R_IQQ_1784856919
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F35140004
X-Stat-Signature: 6dyriqhrgq1wz6wy6m7cbghzu6rah1gp
X-Rspam-User: 
X-HE-Tag: 1784856925-58031
X-HE-Meta: U2FsdGVkX18UH/pYXhpU6vODz5yLOIqpOtPnEqYS5z9KkZ6QP0QgHU/B7n+Yb8ZNQ+HdZTOPwG+6JAk872P3HuIQSBI7+0c8/gtlAKNFPFAqyi8i+k5+IfRztNRVqk2Mwt+b7x+oohgQO5V14uXXj999RP56ADQsnYlyLVOJGvg9EERPU+LmVbdY3pDwomupgp564AV7+lCY9C8PSkdIKzW0cwYEKdKdOx0m8FfJqVGCGniTXNcsn7dvrzht238y/AygVhNCAGu+Qb9O4ApSzF9YIcG8pZX2+kknKSWygsl/z275WqT5ZtFk9gKrK69r1vGS575Mh1eLKJEf8OXjxun+wozLegYgb94k8+U//G3tB/Wv6B/+tLkf12HpbgWODVNm+yu+FL4URfaYGX2QPus8Gn2F66OhF9dy41zD+1xlLoSDQwACIDiMVD94D6UYKYbCrx+xIpGRXiOnKLvNpY2JiHIHPZSVqJseGq/Pp+RT/l1QKX1QBRQxo0s0nTFQMNLL9YRz9kZnop7OmSjXAssrO+kF9FsggSVei/bI7wN5UXQOcqFWIAZ/Cmucwaezh5H3J7fsYxukMMDVxYF1I2DiI7ZRNf0EvsZYECwpxpWOSqfSfOzTbQBiphGL6WDqH+wJTdBJM7IAHNPIFwaBZ1eVs4Cm9THlsTARGPky9k20TYABeaF98dRBfMyqmoEs7BHKqP3XbEAp/AT6C1oe4vu6cz2dw5kAErJcB3qzyx7WXotfiERF++XuWHPnuvq3OqZ8ZNK/hZnXr3Jka8qZuVynG0L1OlcIEHflMFj0n7ogNYWjeDSmT87PoWg3Cp/F5q/2KtKVyKhkB1aWRogiGr7JQHhYn9bfODrtEarfnikKIYhUHaP6GtXGhV/6FzgQrh4yecezhU+6ehIbTy9SAK6D8y5Rq0s0cjK4UQI/ZHuHFoptYRcOZzXqFO6zeatg5sL78++4O2kNHTMomBl
 8T3Gpqbu
 JOVNxkyhP1rtiGvnAZ2gWescEaXoLn6NMdGCoyPBTFQbfrMhp0LL4pa6hwXiMSHqRpbLpepQWRERlE/FNmVN3AYhaw3KIvN51ALSMkwyClQ2F4y1RZHFKALV799JRVMHan6RzQ0m6tb9HtSrN9c2Hzpas6VN7nAMVa2BS/RWZxGKnFNWT4PVtvN9/iTc8z2GtjfESuJJ7XPdAYQGBvr8KAE0kYLsSaYElFLRUD5gyp3AkD7FVeQ5eo2pl2Yu7kS3JPlEQXrDYhEz7de4oAyOMImBH1obZrTuhaKKf1NT9lERcRGEnqd5yk/lpHG70cAMvOlR/urMg29PVorH98TcX34ygvNuPMfnzChS/dCP/R+nMyZv4GIsnHSJNKsmLXmt6bbnqO/cK53Tkj/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

has_transparent_hugepage() definition is guarded by
CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
CONFIG_TRANSPARENT_HUGEPAGE=n. Move the definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/mips/include/asm/pgtable.h | 6 +++---
 arch/mips/mm/tlb-r4k.c          | 4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947c..b038da872ec6 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
 /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
 #define pmdp_establish generic_pmdp_establish
 
-#define has_transparent_hugepage has_transparent_hugepage
-extern int has_transparent_hugepage(void);
-
 static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_HUGE);
@@ -743,6 +740,9 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define has_transparent_hugepage has_transparent_hugepage
+extern int has_transparent_hugepage(void);
+
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 24fe85fa169d..f4e369342a56 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -432,8 +432,6 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 #endif
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
 int has_transparent_hugepage(void)
 {
 	static unsigned int mask = -1;
@@ -452,8 +450,6 @@ int has_transparent_hugepage(void)
 }
 EXPORT_SYMBOL(has_transparent_hugepage);
 
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
-
 /*
  * Used for loading TLB entries before trap_init() has started, when we
  * don't actually want to add a wired entry which remains throughout the
-- 
2.55.0


