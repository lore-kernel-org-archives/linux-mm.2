Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176B7CD4F3E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119216B008C; Tue, 12 May 2026 15:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054BA6B0092; Tue, 12 May 2026 15:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E6F6B0093; Tue, 12 May 2026 15:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D33136B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:51:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91702C204A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:40 +0000 (UTC)
X-FDA: 84759812760.09.351F091
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id CEA35100016
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cg+im3ER;
	spf=pass (imf14.hostedemail.com: domain of 3yYQDaggKCDgmebUqUdUaiiafY.Wigfchor-ggepUWe.ila@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3yYQDaggKCDgmebUqUdUaiiafY.Wigfchor-ggepUWe.ila@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778615498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hm3N3CUlxXRBXqf7e3XiIHtpRuBL112Zzp/Y6lHhCj8=;
	b=SE7P6/UYCxlxDp0DVb6kCLj9PWSwsuxLY/r+pDoDvLQhVyRZytHXdfVD88rjrGcILhLbWP
	NMGXMY/YCRGlflt+ycQ1/xluljS3fQHU6hK/gnBDDl8oXaU3CmDs3DDf/pj6kX8IjEAE+P
	gCQbMLGLYRC343YbBjv5+5I/tBIy8wE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778615498; a=rsa-sha256;
	cv=none;
	b=7QYqsvjekW1CdqMzgWvoASAzV3tNIU6/OM/cF3JPeMPGIOSBrxPTcr7a7kHRUYAilEwtY7
	AuEhcp7JAjtzVHqxlR8hL4LQf2waOLq7yoDAwc5NDh2aEh0YzIV3e+RciCN2wNy+bkoghu
	UYpl+KzbHpb3ty/2ZJK1jmexEJ1rlIk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cg+im3ER;
	spf=pass (imf14.hostedemail.com: domain of 3yYQDaggKCDgmebUqUdUaiiafY.Wigfchor-ggepUWe.ila@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3yYQDaggKCDgmebUqUdUaiiafY.Wigfchor-ggepUWe.ila@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-837d43e9ff3so4385698b3a.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 12:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778615498; x=1779220298; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hm3N3CUlxXRBXqf7e3XiIHtpRuBL112Zzp/Y6lHhCj8=;
        b=cg+im3ERZS78f2vaJ+a2JiPpCszrB2f3FbhwKTqZDW/6Iyrglt8gal2/aKcVJ5rdAr
         8emx8+08M/cEQFWEC56dTVondoaa9DPAFBHBqWck1TDyyPQbzVfefO3wQ5LV5kJIiuZa
         E+eLJ9IshPywGgO8aCSDQblYNcfM/i4QndWimugzcBLN0dbGe05ReVOE66G8SLxIDEuM
         FVGhgTr/T/HoCm/Ob3FJceuwvNToRdeUkUvUCt0ZqN0nsnwGMr7sGr94ebNwC0iJLOyo
         7VCGo3sXe0CdkmKY2pZKN5H7vfS4QERPeKP9OJPNDC3mWTXEkWk1S6NLUbcPQz9QFA+5
         Clyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778615498; x=1779220298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hm3N3CUlxXRBXqf7e3XiIHtpRuBL112Zzp/Y6lHhCj8=;
        b=ryyjFlqJ/4lq/YJe499UHaVRs70+v4hF8/4PGqC1c7a4mmF6LDRBen9BozGSPXhqaL
         tODNGXKkf8xdEvXp7BfTbGzfPuj7mBLv/VXrAVj0TjEkAgRZrs+SoMbtffl9++B4eMtE
         0sD5DHKGyifkhlUcoKaqqryBf/rjnDbAm6BcmMakywg3ttRHln/D44IM9hXHxjTwmKj9
         IbiCdqoavV/VrUvcKkpz44w1364G5eisq2cg/mWs0fS4Lcoz38nF55Ni40cuAQbknv+g
         HgWGoqyssBLUZ7ydOi9L9XKNzAU65ceEgceR66bsIyPNSIiwldx85HfURHgos0F0X2Ip
         cO0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+rxfes1PigbvG4ILjCx1VJP4qyTjpw74lGLfcrI4bZM2Nl8aC3WYrNhj7eE3svVRfesC6++jPcuA==@kvack.org
X-Gm-Message-State: AOJu0YywNL29GPBSCAaplGMaiLxdPfEzPhKOaxb2l9Wy9JZdpLpqIRDw
	RMQTopF32EqGpz/QUF5HP3R/2ZWxxh8OphzIOGhLhMKPbYVUFrE0U1DgqfWBvyDuX1rlpjnwfkD
	2rlb80GZ+655sYA==
X-Received: from pfbdu16.prod.google.com ([2002:a05:6a00:2b50:b0:82f:9778:a429])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a254:b0:82f:2226:5aeb with SMTP id d2e1a72fcca58-83f03fe5b91mr112295b3a.20.1778615497372;
 Tue, 12 May 2026 12:51:37 -0700 (PDT)
Date: Tue, 12 May 2026 19:51:34 +0000
In-Reply-To: <20260512195135.804833-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260512195135.804833-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512195135.804833-3-skhawaja@google.com>
Subject: [PATCH 2/3] kho: Add helper function to check if pages are preserved
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CEA35100016
X-Rspam-User: 
X-Stat-Signature: 7bqt74e9rr86pkdzxxjet73n1jhuzrwz
X-HE-Tag: 1778615498-594058
X-HE-Meta: U2FsdGVkX1/lCRoZ4duBTBFm7pgyWnAsscYK8SktScDoabV1zdnyb4mP9zULorlbUtB+zzs3L+scVPdfQXQuqaCI37r2dpQq/qcj81kI2H4vtqLvdAtsPea/fDmQub/jWUJ2R5bzT5UXGxlt3OJQJaSSNszThSvKLHmYyNVfZqCiXSnSsra95e93XJmhmdX9ggJGYJtMpWiogyiZRm89Uy/zaz+VuirU9ZmJZ3FBvAhc3PlRUJbZWPYuoa1/xh73OsCOH5YI6OWpVrW9L9pSw2y82gKtlMhMEdXAOGZrlELSwhqwsx12+7cnAA9761U8PZKUtvWCPcZnwjXP+8XxQIwqhN0mbhj+/AvWTS8KxHR4HRIg8/KHiYWvt/7Ri1kSbFklr5CG0fpy18iigA0biNnkcWHYFPKRq2PfGcJ7WlJ907A9mxOvWBTEHalZgKHUQY0ueAborLfNs2jL0ccNrJ/Vg0uvtAfQphTLkRfUzJ36Fg6YwYwoBvzH2tl1VgfmcTdvEfKfDYEPFNEzN89S+KS04DiBvsrzKGH2cyv1Mz+U/vj/9mp127WQ7Hwk6NzhzjsLN3gYijwWstz/UQinOBFLv3+GZpDe9Kww1KSCnGbgUvRVJwnGLFqpx7mnIiGCufZ731nsUk9AZKqCa3gfRtitm5IipZQkvj4s3UxkTweTuglgzYP2bvVXV+gY4HLWtpGE+wS0TnL/TLov/QFg1I7n+wzemmXyI7geBSpc1MTRIDi7Xj32ffrpZ9hfKv/a2wD8u5eCQFPa4o8uh5pcQLuc3wndCpQ1VAmwo/rQEX1G42wfxpn7TI7vBsId3bJoyhFqP2T9Rs8VyuhSjHsn+ZjB72s3h4EOQZpdNlOQmCANWPYT/23sH1GernJu3/0rUKhMBSxt/2q+YQ8j458u4oniPfKxaDzJI1XvhX5ju6C/x3ReKWTYIz2aqnDaXlKAF+JYcWUB3mg3NoiIki/
 /eNSid5+
 i/i+Y5xxis5pcfOzy7arzCtZKNfnNk9c+huBwBhJGdF1dpTd4MNZeGaQD9pI2CnsrgLzxgKG4HTMX3xJdvp9HmBE6vprhZ97rYdCfMnWJs2ZRmPd1SJ9jCzjBh3jKFPSItOsiXS3y9YQQANLpgZUjWQ6qVFB5Gg1oniEDM9THCOlDkr1MTRlBc97cPWmXLlcqtNbuufMvG5mhW9YiJDYuMoqIAWaGGx1hA4Y3jaar7oucaCeGtiwWN9IgdfM8iwUp8glf7mGgk7k0zhOLy2hvdOY7p4d9w2XLpnom4OB9x29V+Q9E89yrPtwsmE756C/zYMJYMnqn7Wg6Wxop/bCMstDfM+rScmrh2jDPBNXCADds7PPwFIgwkmiYFrB9W5VxrCh5YVxTezAFHO58xuBIFoP3E4GvI8jAyqKssiWVyN+CIEW5UY+RYe8f467vOyBnGwOLol7KJafZfXMnYyUgJjFLlaKCqg6jajEGoqGFafolxoNWoN5X/bNoJm1knHJp/hkdpngSafkJzCU=
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
 kernel/liveupdate/kexec_handover.c | 52 ++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

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
index 1375291d9b07..f678372b3e81 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -12,6 +12,7 @@
 
 #include <linux/cleanup.h>
 #include <kunit/static_stub.h>
+#include <kunit/visibility.h>
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
@@ -1771,3 +1772,54 @@ int kho_locate_mem_hole(struct kexec_buf *kbuf,
 
 	return ret == 1 ? 0 : -EADDRNOTAVAIL;
 }
+
+#if IS_ENABLED(CONFIG_KUNIT)
+static bool _kho_is_pfn_preserved(struct kho_radix_tree *tree,
+				  unsigned long pfn, unsigned int order)
+{
+	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
+	struct kho_radix_node *node = tree->root;
+	struct kho_radix_leaf *leaf;
+	unsigned int i, idx;
+
+	if (!tree->root)
+		return false;
+
+	guard(mutex)(&tree->lock);
+
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
+		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
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
2.54.0.563.g4f69b47b94-goog


