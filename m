Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E184D606A335
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QAwZ1GWl
Received: by kanga.kvack.org (Postfix)
	id 148BC6B05B6; Sat, 14 Nov 2026 09:49:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9BE6B05B8; Sat, 14 Nov 2026 09:49:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F314C6B05B6; Sat, 14 Nov 2026 09:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA07F6B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:49:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BDAE40437
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:45 +0000 (UTC)
X-FDA: 85434008730.25.9B10B80
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 885B1180007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QAwZ1GWl;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667783;
	b=ifSPNqxG1jSYnar5YodTG00zop1sYsB0UCXyldebX1CFhhVVhAfY6xh2H1srtCy+EWGyjZ
	n5y8AmJDkPPoCr8O65t3XOLeXzo3dU5omElYcXmVodNJUFtUrPnftDQ3le3+6BVfCqrQlB
	o4N6xpX/DuKUtxW5ZkOf/Ihr7nNLP+8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QAwZ1GWl;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xmpeLN3tjFh9PjQPZhkSHJLU+h0hkIrqBfSHYgvILA=;
	b=o372skB0021KqJwcTdbHyktX3pNWnNcVI1SuGL+PeE7K+euKRj0eMXbviQDflQSPNSyCN6
	nN8ZinN/jlCfX6vrxKtRI6yzwPTro17kjxV5DjaFt9/MVRUjtSn0alprpaRnGAyJID871r
	keebfDQxapIC1aMa+/IWmB+yEM62BGA=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ae691283ecso967920a91.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667782; x=1795272582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/xmpeLN3tjFh9PjQPZhkSHJLU+h0hkIrqBfSHYgvILA=;
        b=QAwZ1GWlidYK+608EU/ZVwxWQ6Aa8la/IazAhlqyUC3BM0WPgP88Fdfd5Mv+xg3NC4
         ARRvmPjUS7t4xZUCj3AzlA5YB/A4FuYALKSSIkqaECxqBBzCnlesuCzYo9a/nYadI/2b
         lkwRFjmSITN2P9I9O+kkJNv97Cz/OH/1NdYdMIj28AQxy6I4mctvm3RMA1b/r1ebm+4P
         eFwWUqJHdUxenvlxdf1wMBSi9fu1qcm7WJqPLweci7zDGEKmvyokxbAKVkXHFxnJkC0G
         1Oooj+viyyjLmL7wKadoGT+NTUooxBkdUgn1Cf+s2XDEWpLi/YSAB3DyjP3nJsRaltjQ
         dCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667782; x=1795272582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/xmpeLN3tjFh9PjQPZhkSHJLU+h0hkIrqBfSHYgvILA=;
        b=bfCskZzXWpJucUKleKfYuFQIMaPMm9m4cNVBP8R7iqFcIcpFDQUDD7ZKzy41utjNYe
         +7DRk3JMhzQOGJBjo3wWL5eR+TtO1Rnnd8ABqXS86yiFtGUopqhlYEU7T6ax9eP9wqgl
         tb6U8HEBRqIYQYa4iGAtwzCP9gR618JuRtS6mO3bRiAfpEF6Bt6QJ1io5pkHgrzQTBOP
         uOfX9N1SG35g/Cg+OUciBSZqV7SL65lK0PZRLWXgBxJhygplTcM3T6sA1/G2Fn1Sp1bG
         CY4B+2ggVeNH5xbKSPllsQheb4/Lz2ZOVe/CBeS+iPoKsMWp4otS/Zet04hQeRCNSUKg
         QXfQ==
X-Gm-Message-State: APuU4Z/zO8GPKvuPJLJyHyyBL4EyS2p6ThRQTF53Djrd7ymsRp/QSYnY
	nexKB9kEPM628JhEIPwpo4fgbqdZclc/4LS008AFxoCfC+XJER/vk8BKeb/M7g==
X-Gm-Gg: AYBFou2ArPc6hAVhZG58MtMb5Rzm6r8aZ52fVYEBS9eFMNPWwqeIPWgONkWfSqZuubd
	GmvFw3hdIcRU6MK8fa02aLHimBDqmG6KlMnzxpRaTHxPJfzWLj+kpbGLitPLVZrTLPRwwktv2al
	TF0L6plTHvsoWn4Mg1cLE/VnUC3RV4VaHXFxT99JweTtmcQNPqnnA+0f5S3/8v4bTFgcxsamPun
	D8XlUCcbN6OIRLjMBCu7EE3ou3ItOiR1G3kHyiG0gZ6k4UJ7rk/NrNQo4uSmlOD4EJ45gaIPGiS
	D+z9c0hZX8OLydEZToWGDZ/L6u2rTkIOLAqAf4lAC4dN1WrfpE9mbV1DNH4HWAcHCU678Sp73OT
	BN7s8VF9PfsmiIxyIuscouD1CfQesTBwEXN6Fuu0cnO3+7MMPFDWrNW1++q5rfpKaqMu+TRXItK
	8Y9HuOHgXgVH0uOuflaIn2mJxoRb2p2ZhaHfstc20BHjLVAp5liBysmwTgWd4d+/nfuJdFznRgm
	lWoIzBLRoT6pjtgergoiHEVazBrNUnpfs4gq9h4ekdX+uNH12Xm1IBvfxtDRgpYf77ByLuN5HGY
	qQbVmY23ukR4RMtvi+QJG6kY/3bb74ONsFA1umBEL/1U0ejpW+I7xbwFDDN8Cm7kKQO0m+9eb/u
	7OtJcx1QD3n3w2A==
X-Received: by 2002:a17:90b:17cf:b0:3a8:9d4b:2788 with SMTP id 98e67ed59e1d1-3b197d30295mr7107823a91.12.1794667782210;
        Sat, 14 Nov 2026 06:49:42 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18c800esm2419014a12.29.2026.11.14.06.49.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:49:41 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 04/18] mm/swap: introduce swap device iteration helper
Date: Sat, 14 Nov 2026 22:49:31 +0800
Message-ID: <8e1766da4ddbf22e36f8689360dfea64377269fd.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eafwq4qce8g7f8oyr4jkp8u8ux6dmmio
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 885B1180007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794667783-320086
X-HE-Meta: U2FsdGVkX188vDnxRi9knMmz+3ZBsb2aSTZy6rKrBJbLSEyUpC2NzQ11PSDeK7hx7LJEA+NkeuU+yuieysYGMP9ax81ZiIHGUoeaED591ikcWh7LHvhk9Y85p4Ql9f3Y/NqdQVzltufh1HdOSsBOfhHBQdJkAm8ltV0Adnr+KQ4KlYvAK1+Qc5H/4SzSTZgUypmAtylfj3CJnKnKRTrMzTlXRYdFPBg+mtP6ZbmIjYOF2s0KTwplqv2AlmePDkNbN6qGxj75mHvUUWRhJ156cOnSkVBV9nO3wFVl0swNBK8QxjnYN8KaPBjC4Hjcag+wW31tu7u3THu0z+MDJ1Z186B6dhrLT8ajZsLXl27AqOFIRa34XYLWIS8HnGx5zAj9fk+7IEXnwzcJvsyltgKaxIm5lqoKYvYgRM6AL/jtyVphrvG7MYea8ZOyTV335AbTiS82oqMLwRmWEeV9Y7gaRcnkII7ygj20iDRPjyki0GDSKIa6d58NKoDpUnpFY14z/WBU28OU3MjrVeISbSbc1mT55gkhLb0VCKKzQw42wAK2GVgtjVmLOu9ZAqiccWG5NejnBqtda6XME1kRMB8Tz6QVKBfMWGCFH1Fpc708zjE2hN8I5JCQqNVKpY8m5vdJ8J009/QTsnonfW/zHSIPKBifnGMPI2kjwvESI8Bqd+IEgYJGKtYWpv96uq90SY0yqKaqeaq9IpymcDzbOAXBRu9XCoxPs9XBIC6Xg3UHAq/JBxqS/Cw1WF4Grmb8mxRYQIdC1RTghyfHh2C70RSPDpymyGEtDSVG0aPr6agCFhQgdjkp/n/Z2GXB94mjKS98FwYS1748uJOWHR6iY/aQhlF3o4jbLrzkeJpibEyvdTK2caHxjKDWuYeZfM9F+Jdfu9zup/k7LHE3rtuu4+jzthc4h0CbEh1mLIr0G1BEQdiMr76p/3twBtues84Zl0uNSgraLoLS45iECOcISBl
 TYXZohyD
 Xr/VYnieCFoqavjXfCvfEDq8yHgqtFp0C35dS3jrZV0zCnq1CivFDAKvSJPfo15UhNNrGBk25C/1A9yab2fFfqJgP0ygTNynhlxfjAOmW5yaL9X7P7V3Pm0lAcywj991KO+ADJQItResOHxuqlAwaBdnDky5s9BonSjZOI/n76Sur4fuE4q9VMzX1BkNYr0owVyyE60SJfovaF8NrnXfol0LTjErMRhmZDbf2Bss/Xn9bIUqh8a0A28lQyX6whiKPul5RqKWzSfzwQSBtc8Y0Z8g1zsGst1I3qnXSnkJMHxeXqNBeIvNT1v8cqa1XEOXiriKMFQ9wwtT/TMeGqDPnkqD2i0hDdBP9tCbCOsvEO0m+eqY2c2rVcN+wNS20+OC8PVVS2Y4Cu0Nrzt6QwXwj1+uinMSYsA9jHxJl3OnTXO5oMsWouKZEyuQXNSEHQJtUHVekHf8SKFTOA6tRP7E3KvF4S6cTeTHKNjfT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Several swap users scan the swap_info array to find in-use or writable
devices. Add for_each_swap() and for_each_avail_swap() with SWP_USED and
SWP_USED | SWP_WRITEOK filtering, and use them for hibernation lookups,
drain_mmlist() and si_swapinfo(). Keep the swap_lock requirement for
iteration.

Move the live-reference warning from __swap_type_to_info() into
__swap_entry_to_info(). The iterator must inspect descriptors before
applying its flag filter, including descriptors whose device reference
is dead; entry-based lookup retains the warning.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swap.h     | 12 ++++----
 mm/swapfile.c | 77 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d488a69c2809..70fd3ab655ff 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -108,16 +108,16 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
  */
 static inline struct swap_info_struct *__swap_type_to_info(int type)
 {
-	struct swap_info_struct *si;
-
-	si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
-	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	return si;
+	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
 
 static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 {
-	return __swap_type_to_info(swp_type(entry));
+	struct swap_info_struct *si;
+
+	si = __swap_type_to_info(swp_type(entry)); /* rcu_dereference() */
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+	return si;
 }
 
 static inline struct swap_cluster_info *__swap_offset_to_cluster(
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6485c8020d3a..1669a46515cd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -106,6 +106,34 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
+{
+	lockdep_assert_held(&swap_lock);
+	while (*i < nr_swapfiles) {
+		struct swap_info_struct *si = __swap_type_to_info(*i);
+
+		VM_WARN_ON(!si);
+		(*i)++;
+		if (flag && !((si->flags & flag) == flag))
+			continue;
+		return si;
+	}
+	return NULL;
+}
+
+#define __for_each_swap(si, flag)			\
+	for (int __i = 0; ((si) = __swap_iter(&__i, flag));)
+
+/*
+ * for_each_swap - iterate through all allocated and inuse swap devices
+ * @si: the iterator
+ *
+ * Context: The caller must hold swap_lock. The lock may be dropped during
+ * the loop body but must be re-acquired before the next iteration.
+ */
+#define for_each_swap(si) __for_each_swap(si, SWP_USED)
+#define for_each_avail_swap(si) __for_each_swap(si, SWP_USED | SWP_WRITEOK)
+
 static struct kmem_cache *swap_table_cachep;
 
 /* Protects si->swap_file for /proc/swaps usage */
@@ -2284,26 +2312,18 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
-
-	lockdep_assert_held(&swap_lock);
+	struct swap_info_struct *si;
 
 	if (!device)
 		return -EINVAL;
 
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-
-		if (device == sis->bdev->bd_dev) {
-			struct swap_extent *se = first_se(sis);
-
-			if (se->start_block == offset)
-				return type;
+	for_each_avail_swap(si) {
+		if (device == si->bdev->bd_dev) {
+			if (first_se(si)->start_block == offset)
+				return si->type;
 		}
 	}
+
 	return -ENODEV;
 }
 
@@ -2470,16 +2490,13 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type, ret = -ENODEV;
+	int ret = -ENODEV;
+	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-		*device = sis->bdev->bd_dev;
-		ret = type;
+	for_each_avail_swap(si) {
+		*device = si->bdev->bd_dev;
+		ret = si->type;
 		break;
 	}
 	spin_unlock(&swap_lock);
@@ -2996,12 +3013,14 @@ static int try_to_unuse(unsigned int type)
  */
 static void drain_mmlist(void)
 {
+	struct swap_info_struct *si;
 	struct list_head *p, *next;
-	unsigned int type;
 
-	for (type = 0; type < nr_swapfiles; type++)
-		if (swap_usage_in_pages(swap_info[type]))
+	for_each_swap(si) {
+		if (swap_usage_in_pages(si))
 			return;
+	}
+
 	spin_lock(&mmlist_lock);
 	list_for_each_safe(p, next, &init_mm.mmlist)
 		list_del_init(p);
@@ -3997,14 +4016,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 void si_swapinfo(struct sysinfo *val)
 {
-	unsigned int type;
+	struct swap_info_struct *si;
 	unsigned long nr_to_be_unused = 0;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *si = swap_info[type];
-
-		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
+	for_each_swap(si) {
+		if (!(si->flags & SWP_WRITEOK))
 			nr_to_be_unused += swap_usage_in_pages(si);
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;

