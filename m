Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8084FCAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 05:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB128E0003; Sun, 21 Sep 2025 01:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C438E0001; Sun, 21 Sep 2025 01:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C718B8E0003; Sun, 21 Sep 2025 01:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0EF38E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:45:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A8A085F11
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:12 +0000 (UTC)
X-FDA: 83912169264.28.54386B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B11E21C0008
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+GIwKUZ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758433510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0UkgIRRiUCJy7C6Y062+omUJT2kSrmXXwq/Mgn5w2Q=;
	b=0R9GhJ6XBV4RFXXXavlcd4DIcim0XLdzbbSQVpZYsGGrd67rWkt1Ke3Owep/rzvYLpBZDc
	v+EEHjliVAl4cDTmxPN8dc+YrhVbOkJvz4Ntow1/XOI1fLYVsqsz52eLmHIMuZ15hUHJu9
	Gna7Kjmr8pGwWwGyHZxlzHr985LWNK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758433510; a=rsa-sha256;
	cv=none;
	b=fqsPq+oQQNZBoCUtoX+7bpWJZlV6/BxZQNWCXncQD6zKIAndNqyzjHoWQS+LJ4edEZ/9U5
	tnDOJWQWHKoQesJflBXMbFhkwl1xFn6MLnN+ffe+IkjchULBHbPqAZL9hdUzq8YKHDVvFk
	h08zn8Ls9YMC+60hlTq40r2Cwua4u8A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+GIwKUZ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1ED460194;
	Sun, 21 Sep 2025 05:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B61C4CEF7;
	Sun, 21 Sep 2025 05:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758433509;
	bh=qKv5CzwLLtDXYj45Vz9NYuIeSEVLwG4QLtqMDnI6e28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+GIwKUZiWi4CgoEKu3KIu0wCOseJatAQSLSbZrUrAd9QoU8dee7yMHTGBzMSl3ED
	 ghUNJKQmWMNsRQsovFspvdM74/loQb6s8wVAyzRVLnudXh9mi6Y9XAD4BTFIqTrpxV
	 YpM1FDAM8o9cVrU53BDIL8rEfMKrl3lifCqVMPTyMJMNm6vheOM0whKLPYEpG5SKzJ
	 9WwAHXW99DNpa7Mnab+L4PVv6op2Lmf1qcubLtxBjpv2xAQeajXVNojqll7cN0T3pX
	 Dv7AmV7DMnJJuGJ0nmafCjjorQFg5WhjF1blob4QalpCms1ubzOs2Ozz77S1JYfXRf
	 iGTaBzeol9Tbw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/4] kho: check if kho is finalized in __kho_preserve_order()
Date: Sun, 21 Sep 2025 08:44:55 +0300
Message-ID: <20250921054458.4043761-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250921054458.4043761-1-rppt@kernel.org>
References: <20250921054458.4043761-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B11E21C0008
X-Stat-Signature: q6je9fq5xw7ubi41ibydqm6cdqz7sw4w
X-Rspam-User: 
X-HE-Tag: 1758433510-637263
X-HE-Meta: U2FsdGVkX19to+sAO2nADJZ0Rw8udtSal/n1idi1odU1T136kxexWlu2ien7WS7Q1RyGlvAJkfRY0B7BVG1W2S4cIggm+DH73FQm34GKQdKd7uQOvDkF2ZpIBlJ0iwhWCCVvQywpJTlGof4qCy+yLkMdpphsyG0uDU4O/IrLAE4ujwBzSXNqpBNy/vMka4f382CeGfCpuAHElxMcphUxt4wZ5qymGeTcqLvT2hBY2TdmmoUGZw3c7peQjwJY0spS/O8UI8LbIhPQUqopod/qUr5KA6FtNDbAY0XXTIUcGANcR4P0CONhHVC93KRdLbo6RNF4z8yAkpcut3PMUaCHg6G/wvZKsh0rptMyFa2b3IxBK843tW+K1vHZlR4S/foWmIJdt9gN8tVi6cyyzZLRdz6cfvxVQbWJ9zRX+uOdQzC6tRaJNxSNRHFKAult2MsKVNOQnjMyta6aMfG2NQ8t/bnyw2+SmeT74mGN9eb6NYTBc2cJRkLQSEXnMXHzmvx+wS5j6ezU/qtpuJ8aG4TrfYZI/k7/XJAmoVy8/FWTZoIB+8xLt8vdZlxDNrtK1IKrwLTdZW4aI3Fw62LkjQuEIxKtBd5SCUlnEB/ZqQ7fUn1jhz7MuJnRKj0BJlmCMnC7xr2AKlDccMAefP+HqEotmOu8kO16FPJKMcbKLqPc0cGl9o99cMoNTBDKn23mABV3CG0VwBxgpwv/jDIl6qcZlyj3pCswpLOCR9wRzdFbPKlFhMnhn1oSzvC+enzlFQ43cqCbPNV9tYAEpUofgDt7+FJCrtYiAOi/iafOtklDb/jGXeqjSPcEj2wPrWAIx6dQrpxyxPO3MDDnS0VKHkjbpYGnSBmH1WysVFLO8gibGLnyGHOIZNFX8BsrAjtCKljg2xKWh0YKMT+kle37XtXtiLBgJCSZ1kboBxvaEOfgP+X3GEl9hTQ0aNjTUqyH4ji3mlyYm+isjDZewC60Nyb
 8ICW+8w/
 UbsO6kOPjaAcivwN4DQo3dYp5VFVsqghEC19eAeZxlWgmRJz0eYlik5lVWlCUPsByVeKEgyEjreJz30E6+8PvVyyq8SS7J9UkV4lw7lU1Q3jFlRUHh6TW0sL1H2TlOaX8CJm8gaHReHbtNwuXdL1cZiHIRCezQ/isnyLBPUA/i19JqUikLwHh7prgigtNbbhRDBdwT2fWMLYfY6NIgD1wAX+aaP0+TQW/7AZShYk6B7YxgbwCllpQhONPpTTgu9dBSfIYwE97g52yVO/k6WZmtfMYtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Instead of checking if kho is finalized in each caller of
__kho_preserve_order(), do it in the core function itself.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/kexec_handover.c | 55 +++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 555488eb1a18..85f1bf38b123 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -107,6 +107,29 @@ struct kho_serialization {
 	struct khoser_mem_chunk *preserved_mem_map;
 };
 
+struct kho_out {
+	struct blocking_notifier_head chain_head;
+
+	struct dentry *dir;
+
+	struct mutex lock; /* protects KHO FDT finalization */
+
+	struct kho_serialization ser;
+	bool finalized;
+};
+
+static struct kho_out kho_out = {
+	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
+	.lock = __MUTEX_INITIALIZER(kho_out.lock),
+	.ser = {
+		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
+		.track = {
+			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
+		},
+	},
+	.finalized = false,
+};
+
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 {
 	void *elm, *res;
@@ -165,6 +188,9 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 
 	might_sleep();
 
+	if (kho_out.finalized)
+		return -EBUSY;
+
 	physxa = xa_load(&track->orders, order);
 	if (!physxa) {
 		int err;
@@ -667,29 +693,6 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-struct kho_out {
-	struct blocking_notifier_head chain_head;
-
-	struct dentry *dir;
-
-	struct mutex lock; /* protects KHO FDT finalization */
-
-	struct kho_serialization ser;
-	bool finalized;
-};
-
-static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
-	},
-	.finalized = false,
-};
-
 int register_kho_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
@@ -717,9 +720,6 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -743,9 +743,6 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 	int err = 0;
 	struct kho_mem_track *track = &kho_out.ser.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
 		return -EINVAL;
 
-- 
2.50.1


