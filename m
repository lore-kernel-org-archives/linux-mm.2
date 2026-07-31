Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D801EC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0446B0093; Fri, 31 Jul 2026 17:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80EE6B0095; Fri, 31 Jul 2026 17:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96346B0096; Fri, 31 Jul 2026 17:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9365D6B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:53:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FF29A0BDC
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:26 +0000 (UTC)
X-FDA: 85050423612.02.CA7D84E
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75350A0012
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:53:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pEn3pIle;
	spf=pass (imf25.hostedemail.com: domain of 3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=als7b8ug69mz+jjevN//6dwMY7mF0ZGUUEH5Txoyuyo=;
	b=4OU2M8nxUAvbsejw/dmGswTsPfFa1rRBBdXmuv+vz8Hs4wvwBykaS858GxuZ4drrWQEOTl
	0IW3s5kq+NWshRAyFKbDYE/l0zouC/QgWPVpDJ1IiG2DBjKzHOaxrhDDIreUkzdbqmVC/h
	h6LSEf8w3ByH7b7iaq+dhvaXsIHdlYU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pEn3pIle;
	spf=pass (imf25.hostedemail.com: domain of 3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3UxltagoKCJQ9C4yBC12994CC492.0CA96BIL-AA8Jy08.CF4@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785534804;
	b=HWw5fFWr5qj/0AIsua93IwT9wCy/sNmvkAf9piR0MjGJdBlS1FG+MSJqAeBGMTD12dYNzH
	uhZxzsBYMqgERxC97gJMHQwU6OCkFufNc1wypdM8tYDR2e7ztno1mENnc5mPNZmN0+2/EV
	C/F6s9amskZD4+H1B6nTyXH+ELCSFm4=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dc085b0a7so2545727a91.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534803; x=1786139603; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=als7b8ug69mz+jjevN//6dwMY7mF0ZGUUEH5Txoyuyo=;
        b=pEn3pIlexTQOPWGdHKKpOArZCTrtogFhK5L3/Jlk2URTjg6IUjFXk5SLbavm6xophT
         2DPmEKI+F/Zf2epMSWUgLreOqYHDi9iBTsGvLY0hrt7kWF+gfSLQPAOl0e2PfhUFsfku
         oMuFiwDqqP2k+rybVwziRQab/Pag7wsXnWQcEUX31SjzxnBEJXiVV00izj2PrRIzJO67
         LnK0P6ZZB1Ps8BN5wZz6IjSLjjcDEvjJb6hUsFpN/ldjWfapF2sR7Y6ODhkZ9L9OZt31
         rQs0RSzsm+URg/oYNHLMfRoY7Bk0cp60JG/DcZgJz2dtjuYFgekr/YuD8TF57v+2d/Z6
         f5wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534803; x=1786139603;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=als7b8ug69mz+jjevN//6dwMY7mF0ZGUUEH5Txoyuyo=;
        b=laAos0RWhJTj8h3qioRg/sZAre6p6HfHCOD5gfEDTWXz3Tav3NO4AsOuAcn8IPhV4b
         PwBrUgsNK2csE9NngRtKcFYtZRVCwvmlId7hNmA128KbbXKNbp8gOVflB7DbaPwfjFe7
         c+U5pDoGOEMpmDw2T5n2RHLWLlgXiAihdf7dipHZtipuEyptYlgWxemuXHqlZjt2BW9a
         Lkc/qHT8hFZC28C9qLRvYDa3wtGHNdfuYKisA7NUppe/XbMEdeqAsjeIPAhv1nOVsvyg
         ixQudypG5P8zzLxKkHJgna61PcNUMcCV/KYoYn3daQX414HhemyZuKD6lSeGMERJbnbY
         Hl/g==
X-Forwarded-Encrypted: i=1; AHgh+RqA0pUXVWCHcKGRBmdGFUEgDeLf0EKT0yQ5PiDSldRu3KqcPDvU67futhiQVUqZ3CEkWzQSnawpnQ==@kvack.org
X-Gm-Message-State: AOJu0YwjAAdkb5CcZIPLvKNdgSZWwCSN97MR8HOVi0V8uC1fLVGpXzoO
	J3GmWC8ZZXoCLKZljaTAAjNwicZKn2Se4TM/tnZMf2ZFSnMJfxdw8Gliuqc37PVFH8HYShGh8+C
	rFlmzDbjx1sNJ+sxgNUXVeg==
X-Received: from dycmf5.prod.google.com ([2002:a05:693c:2485:b0:30f:42b1:df2b])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2dc7:b0:37f:9ce2:348c with SMTP id 98e67ed59e1d1-38fbc4eead6mr1133723a91.29.1785534803101;
 Fri, 31 Jul 2026 14:53:23 -0700 (PDT)
Date: Fri, 31 Jul 2026 14:52:23 -0700
In-Reply-To: <20260731215224.831696-1-loganodell@google.com>
Mime-Version: 1.0
References: <20260731215224.831696-1-loganodell@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731215224.831696-4-loganodell@google.com>
Subject: [RFC PATCH 3/4] kho: Add support for multiple versions to debugfs
From: Logan Odell <loganodell@google.com>
To: graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com
Cc: pratyush@kernel.org, akpm@linux-foundation.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 75350A0012
X-Rspam-User: 
X-Stat-Signature: tfj56gphpdwe1nthbrismowiz7e9hoyc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785534804-756975
X-HE-Meta: U2FsdGVkX19FzeFkpcC6F+c85XDsZZ8Z0nsHUKM0hD2SLkeIX7V0WbklmYOocejvuKIidjFwMa3el72nYGq/gAYim+X3nvJpLYa9zh8RTilFgo4WXmV0uJuYYHgavUGW5/M8BFTO/sO1/yLIT+QrqhHOpbxh3u2WnHF5wyeQ7DEwjy/m5v+UGJXMjg9iC0c0tt/EgMZXhCb+xPs1b46Bhq6JkTNGyhnV0MbtlQxjCYD7hWVW8ubulW6IPrlbXvgXBQg18m8AVOJ8waulRHVMl5niD6/heujSrYrR1XXU6xzw2mk1fAoeY1bHOJaiajMBxLpeOwpzC6thC952XeR5Y6a4eObKGgl9ZsB1yifQMUdnQir/S2OBx7d14EGdYO61fnZvMBM8K2PHzHQ8Ovu2ID0+bnHquSu93u6cIlXuZa13QVPedUSPlE4OLMYSxGQOHyrtYqda1F8+J+/Z2hS3KFWo2Bpsk6Gx78sl2lWSiAIhpHRJ/YDpq3XjL5YiWVBwkzN+XVC5yy95pgBfmX243LtQWSe4LS7IQg/BPXD5lqCQyGsa4+dGzEL02cHhE6vJ9Xfov2T1Nf9LepPJ/gxdbE8y3WznmW3yMEMs8EZsfIN3iADKkmlNy8wR9gayxWpg8XcP9xAJTZ84VQ1vu4cNvzrMe9rXjxNieEoBNY25Cz+/xRAJsNPTvIJ/NW5kcEKemFLtsuvY/rWwTsho8ySNAjzouT5VEQapsqdWJ1FRb4c8IA4IrhIQJgRunFHCGdCy+sZDirJ2qt+3npVVFwGGHbAhlUQW85Na1OXHra7ud32aauCUdG5b9P1cDpEQFVd+Una0HQbE4/goHn0oRrFjNGZGxNDhKHneuDSA2fBKDyNmrlhWDh684MsWOL9onLT5EeFfdkwzRTiAK3G83Q9r4kK4ZcAIWii3ufTYq7I33C3E7DsbKSFLrrSC+yhn/cSs2YSIcLYS7lmy+coBw33
 RWHizsRs
 Sba2fKy2rnxPyfyZ78w3FLpyG95bLM7MQhjVTIKCgG1n8OnnuqcZF2C8nsG9fxMFiYlfI3hGnGUqVqR7rg1P8L1o9WqeDiZ3ppPR3lmb1wNf73rOuDG9Fre1WCa2t0hOrl9IrJmxIWAMgj8THU7IP029hoW2LoSw/31WrcO/6VNleDUmq1F354G5pbqDouXjqJuHx8c80zGxt9nbiREPoLTRYEh0CrbK3328WenIcbeY0UGJwRaXs1KwEGX7TY1wQd3bFn/fi1UbWt2sKjOXCRnbnyb/xN63QTrD+5uaWvmqzvjd+fneNF+avu4pfcc/FYSRgvga+YzTPalyVSopoqi+d9pVcWrOyZjqNBIRY0tO87V5Zy6jHNUAJadXBWL3EOhjLi+AdbZVkzQwFMHZ0icSq24SNAcuZWU7myfINjYSA/TkN6P7DX6Llq0EADs6AgYIHf043MSLhHjfXuI2tuXJz5zCzvX7HJ3TPEjIVaUZHWN5xxc8QW15TL0fl/xTt9Yo+RnFuetxrjjyAHYF9J0KBm4vAZo8Mtn8WADaq0mZe3t8s+/W/I50EppD7nSgj805n/bGndw7fmFpGUEIKNC/GTWa3Mb+TMppoHJbD9SS2jWnrbcrC3Ezz71CCJ2omqbas+PHf27EaQeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update kho_in_debugfs_init to search for versioned subnodes
(depth 2) and expose them as name-version in the input debugfs.
This ensures versioned subtrees are visible to userspace for debugging,
matching the behavior of the output side.

Signed-off-by: Logan Odell <loganodell@google.com>
---
 kernel/liveupdate/kexec_handover_debugfs.c | 57 +++++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 2f93939168ab..2ca055219900 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/libfdt.h>
 #include <linux/mm.h>
+#include <linux/unaligned.h>
 #include "kexec_handover_internal.h"
 
 static struct dentry *debugfs_root;
@@ -140,19 +141,49 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		const u64 *fdt_phys;
 
 		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
-		if (!fdt_phys)
-			continue;
-		if (len != sizeof(*fdt_phys)) {
-			pr_warn("node %s prop fdt has invalid length: %d\n",
-				name, len);
-			continue;
-		}
-		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
-					    phys_to_virt(*fdt_phys));
-		if (err) {
-			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
-				ERR_PTR(err));
-			continue;
+		if (fdt_phys) {
+			if (len != sizeof(*fdt_phys)) {
+				pr_warn("node %s prop fdt has invalid length: %d\n",
+					name, len);
+				continue;
+			}
+			err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
+						    phys_to_virt(get_unaligned(fdt_phys)));
+			if (err) {
+				pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
+					ERR_PTR(err));
+			}
+		} else {
+			int grandchild;
+
+			fdt_for_each_subnode(grandchild, fdt, child) {
+				const char *gc_name = fdt_get_name(fdt, grandchild, NULL);
+				const u64 *gc_fdt_phys;
+				char *combined_name;
+
+				gc_fdt_phys = fdt_getprop(fdt, grandchild, "fdt", &len);
+				if (!gc_fdt_phys)
+					continue;
+
+				if (len != sizeof(*gc_fdt_phys)) {
+					pr_warn("node %s/%s prop fdt has invalid length: %d\n",
+						name, gc_name, len);
+					continue;
+				}
+
+				combined_name = kasprintf(GFP_KERNEL, "%s-%s", name, gc_name);
+				if (!combined_name)
+					continue;
+
+				err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir,
+							combined_name,
+							phys_to_virt(get_unaligned(gc_fdt_phys)));
+				kfree(combined_name);
+				if (err) {
+					pr_warn("failed to add fdt %s-%s to debugfs: %pe\n",
+						name, gc_name, ERR_PTR(err));
+				}
+			}
 		}
 	}
 
-- 
2.55.0.508.g3f0d502094-goog


