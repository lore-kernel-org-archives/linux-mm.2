Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A92CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 19:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4B26B008C; Thu, 21 May 2026 15:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E566B0092; Thu, 21 May 2026 15:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FECA6B0093; Thu, 21 May 2026 15:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10F476B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:32:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD1651407A4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:07 +0000 (UTC)
X-FDA: 84792422694.23.C2DC18D
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA75FA000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wdiev28Z;
	spf=pass (imf25.hostedemail.com: domain of 3tF0PaggKCAUxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3tF0PaggKCAUxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779391926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5K2FdXzRnABLtF63rsnxGYJOAKntAeJNMkiCQxBi/I=;
	b=yZf9WIXDO5qw7bTlInN7R4PyutMt5hvWr8zTc5Y6vyFjmmkN4IBDxyRrfE8r8H4UG9Gwnv
	gZ0OPd7/rT7DQuOBN23yhIixSczU0kHjK/B8egGqzqi3Zdar6BSN7S6NcOTkqBReKtMZKQ
	pJfqSRf9hqpQ3/0x1JQEB2iiZbd0Vxk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wdiev28Z;
	spf=pass (imf25.hostedemail.com: domain of 3tF0PaggKCAUxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3tF0PaggKCAUxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779391926; a=rsa-sha256;
	cv=none;
	b=26QQQ3MDOSr9DccOd3YOtM7k/jZiAana6W/Il9pwV9HusXqBfVfSvwGFGuqg60DUL/8Jx7
	MualqQWifATWVxn+SIkP5xDBbCa3qqT2q3X+jgPwlySWdCeO4x8XHM5WI9b4+qSHHxh7Vw
	g5jMHM7HF4o/Ywm28gT/TToWOJkRqt8=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-837c4eb3bdfso3994402b3a.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 12:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779391925; x=1779996725; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T5K2FdXzRnABLtF63rsnxGYJOAKntAeJNMkiCQxBi/I=;
        b=Wdiev28ZOattEztJ+9ZRLqivXaQfwO+xWlxbZDsPySzJb74qSBzjocfVJEJj+rlWeu
         ZcnSR7yEepdrgHgvP3zfKXz/RZP6J65defS8Yrx3iZDIj/k7x5cP1yrD+UzVt2TU3FE0
         zL3qkJtn41xrNdkzFTid1yAD7i1LbIW+3ywAhGMDx5M5REdSdCve3s4W4wUliXb6lmSQ
         IfJmYhLzicJgD3cULRjJT/i+3hh3v5/JQYiv6ejlIzcDLerwTL9UzazoPL8eJvKec1WL
         ksU13aWq2mJk67f0IeEE9qRceAF7e3W7/3N78QTtL3uKmM2E253E0qtueSWlrElEUykq
         0cvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779391925; x=1779996725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T5K2FdXzRnABLtF63rsnxGYJOAKntAeJNMkiCQxBi/I=;
        b=j5FMstINex0vo5G1R0hdfXacq6t5cIFUmLgjis7cEyFGqnDBy1AozHwYRDi2U6Ymb0
         JAiFHk781YvMseCU4ugVETHFfMNr4OJSCBqmpmob/Y0K6P/YVdFa/hORrNirRNmhTcGo
         bVzNOW1QHbKRNys0DsuON2TI1qk8C0yf+JUmn47rhBsngHmtIGEKM//ZGLj2t1cjwvkU
         CvLwOnogejjuOl6k7GbcNLm+8qIofzMjSlOUYRBSxlzkhtwFZBlfl5EmLYVqYZzoo7B9
         xn8D9ehlP3T89/rxeXY19V74mnw+cv7B2I8cFdqAgJ4DqYQu4TBQzMdPOmVxlCghunaN
         wdwA==
X-Forwarded-Encrypted: i=1; AFNElJ/ooHN6SBxtiWgG+94BdOaYFoOA0meDUt25KmNNbDUZvZ5H+VuE0Hk02ABlR8uEa1/kZQ8TDb0lOw==@kvack.org
X-Gm-Message-State: AOJu0YxyUsR50qgF68BmdbppWuf4T4T0YKpiQqEcjCqaGUYlUffv1lG0
	Qqxx2wRxMwddSGuWVpLKGvpiBbDsPswptq0SLXpjZmHxFIxLbT7ddwm0b0yewXAR5146LPHEpmX
	84Y3rVUQAUujssg==
X-Received: from pfwp44.prod.google.com ([2002:a05:6a00:26ec:b0:83f:75b6:75ac])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1d81:b0:837:42a6:589d with SMTP id d2e1a72fcca58-8415f129f9amr521581b3a.11.1779391924486;
 Thu, 21 May 2026 12:32:04 -0700 (PDT)
Date: Thu, 21 May 2026 19:32:01 +0000
In-Reply-To: <20260521193202.746810-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260521193202.746810-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521193202.746810-3-skhawaja@google.com>
Subject: [PATCH v2 2/3] kho: Add helper function to check if pages are preserved
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EA75FA000B
X-Rspam-User: 
X-Stat-Signature: 9hc7pzf8zefwfrmdahm678mjhs4ep73u
X-HE-Tag: 1779391925-947450
X-HE-Meta: U2FsdGVkX1/lkuVwwYhsEcK/zzEGKdyKaO2vaDQlyoWh7iNXFj5RJHd5aNdSfqoqGo48ACLPc+3wnBhQpmhKwXcx8AQ6UQ5apG85OBgkyOB8FAYli8M41b4xl6408fwedcXEqx9YkuhP9+ZzKlEe3IcVZFy26ogHbEM3ySpgoy3fx3v/tIGTLW/iQru46BHpXr8IqxWFsIwhc6Ovw3Rh6tR5WMA0sEHZ6mXozVRBNoFwjVM8yyWKHIiF1WW7+n8Fdzv9XUcpv6UAhbc6K1r5fvbI+bO/OJSEtKQDrww54HKAoNx+36gPTzBCceAMx2guk8suspwaGTol+r1VKZNt2w0hVS0YSQJprWrovpi9FSGGJxknN8TAuvKMGPprKQEA267VtrWuCkH/Ua5W337S9fzkSYt3lLA8gOsBnTB1woGKa+8Ob2vDjKvAbUnfs4oJ6u7bt68UoGSuJprHIV8ZXIGMPFqFpDrVRH0Vz0CWfFrdxF3q8AJsN+eITjGzpoeJ7+Urv7tQSiHFQZdQHJ16D3jm4UnCJ/qzCCoGc8wBpqE9Nnv8fyLCpza0rdV40g98Jc6N7xhyMSqgfC4U2+KQ+2sPJ84K2ItvERsYGd5qIOEfGrAg86JZ3xK1z3eJRn1xwIfi3jdKE3UaNSy61sSCRjmKd7bU/7xitkcaqAAqh8LWiX/UR9bzmQO+xk1VpF/GXL1piAJVOsHQwpjBwyGEkZgYjlkPWVJd/dK6vygF60GbXYQ3hlBX1gyhYOq0mXATIkEnGjF4Ti+2BWaiYNkvItvpRbtejLozVWHvB7A0328rJk9T27jA/YUre8bvvLhGOKrfuCqUDLXwTd7CIXZ5PJnk+UkZN/Vu+Zk4hrfBtCtIg63V2eB1E4TwP3+/+7UHXQBllrTs/G+C0wqIhfBOzgy1KroamVSBv06UmXn/FxibVF0lEFC3u5F++VSEbqmbfJpZiH8jweoWGXJkd8q
 64VKRHR4
 8HD1+s0b2Y0WBC60u4tKKQGGgUpALAuRFsJG7KGZTd0yk7pUU84Kdqlkz82uxXbDiiJGJq8prk9m9dYM/YpqiEzFnVVtl5Ey8d7JO2aBHXGr6LwmD4IaGS0ra5aQ5tv9xTCfB4uiqY1YQcO8xbpQOy23kmdBZK/jj2qZWR0wFiGVd8qSbg+0xI03QYYbi34iomWBPZyOkAwwAjOv80cnut3DZWxcwBsp16Tcc591YbC1klrRpmEZ9hwHq/Ja0toEzcf4z4DCfqqS+dcSdxxc91FPwbvZIFeVXr4FuTCQBjn9wisJNKd+uZRV/RDSugBTAkpManUuYyqq55uiV/hnRVago4DdSZ8M/kinAq7N3qC8e8+/Odc0EMKqUy91lON2Q2zwP4PDp4zVXtK74NPZfSTBfNIeJs5hVudURfGUjBCNxojwvoJmZK4pm5Rzxa8/P6DAjetPx7rOqUlYweXoTJ63uplC65kUk/zMig0a/+ecsRPjQOnKCrZ3XkzQD7AwpDkzTsDBf18+Sq4u1XZesvNDvHgv2lefwlVdWdDi2aSdu/fl6L/0WrQKL5iWdFtU2WpYytDxeirmDMvQEwBUUL9AE1GpI3Y2XmUaub6Up10oAu1hs4g+QpaSeYWSoNQipa0nvtllougwZKc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kunit test needs to check whether the pages are preserved after
preservation or after unpreserve. The helper function added is only
enabled when kunit is enabled.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/kexec_handover.h     |  5 +++
 kernel/liveupdate/kexec_handover.c | 53 ++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..a3afc74cf41c 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -32,6 +32,11 @@ void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
+
+#if IS_ENABLED(CONFIG_KUNIT)
+bool kho_test_pages_preserved(phys_addr_t phys, unsigned long nr_pages);
+#endif
+
 int kho_add_subtree(const char *name, void *blob, size_t size);
 void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 902019f36c24..abe201825e83 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) "KHO: " fmt
 
 #include <kunit/static_stub.h>
+#include <kunit/visibility.h>
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
@@ -1775,3 +1776,55 @@ int kho_locate_mem_hole(struct kexec_buf *kbuf,
 
 	return ret == 1 ? 0 : -EADDRNOTAVAIL;
 }
+
+#if IS_ENABLED(CONFIG_KUNIT)
+static bool _kho_is_pfn_preserved(struct kho_radix_tree *tree,
+				  unsigned long pfn, unsigned int order)
+{
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	struct kho_radix_node *node;
+	struct kho_radix_leaf *leaf;
+	unsigned int i, idx;
+
+	if (!tree->root)
+		return false;
+
+	guard(mutex)(&tree->lock);
+
+	node = tree->root;
+	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
+		idx = kho_radix_get_table_index(key, i);
+
+		if (!node->table[idx])
+			return false;
+
+		node = phys_to_virt(node->table[idx]);
+	}
+
+	idx = kho_radix_get_bitmap_index(key);
+	leaf = (struct kho_radix_leaf *)node;
+
+	return test_bit(idx, leaf->bitmap);
+}
+
+bool kho_test_pages_preserved(phys_addr_t phys, unsigned long nr_pages)
+{
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
+	unsigned long pfn = PHYS_PFN(phys);
+	unsigned long end_pfn;
+	unsigned int order;
+
+	end_pfn = pfn + nr_pages;
+	while (pfn < end_pfn) {
+		order = __kho_preserve_pages_order(pfn, end_pfn);
+
+		if (!_kho_is_pfn_preserved(tree, pfn, order))
+			return false;
+
+		pfn += 1 << order;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_IF_KUNIT(kho_test_pages_preserved);
+#endif
-- 
2.54.0.746.g67dd491aae-goog


