Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C421CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69BA6B00BD; Tue, 26 May 2026 13:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC896B00BF; Tue, 26 May 2026 13:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB766B00C0; Tue, 26 May 2026 13:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A337D6B00BD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62EFF140453
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:43 +0000 (UTC)
X-FDA: 84810333846.08.6077C00
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F589100011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fwgnjDcS;
	spf=pass (imf14.hostedemail.com: domain of 3i98VaggKCPgfwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3i98VaggKCPgfwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818381; a=rsa-sha256;
	cv=none;
	b=1BGcArqoceSP3aK6dgpKulz3e3dudPXf9hha0few0ObgZD2R9hRX2Dom/s+FFJ2f6IvPZQ
	7qVLEc+4FCqYQ/MGFc0uLIbWDIybEkGHCgCO2N7ELimJYbYhZ4ys2LyEdLdW1IOG7unFX3
	EKQ/xKjJmsyEcqoj7D3lncLBwwFCoBY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fwgnjDcS;
	spf=pass (imf14.hostedemail.com: domain of 3i98VaggKCPgfwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3i98VaggKCPgfwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YW83U9WXzmuOgO+qiU2xntn4xO4oQspRqeeRLd3+Ago=;
	b=LdmmDhaWOovCAU0WthjDCMtqj8IfWkzznKDbjYoPiHKdSxJyA5oe9tATdGyqUEVNa+IIC8
	D+sbhWAr8kWt+DVqsv+CBedh3IT2+FR0sA/FNl4JkG1NEjy6+Rtg7lyCDwkyyazpoua7aE
	wgq3/8UH9LiDW0qUzasADua/4Lmx59o=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fe6894f3fso63695215e9.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818380; x=1780423180; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YW83U9WXzmuOgO+qiU2xntn4xO4oQspRqeeRLd3+Ago=;
        b=fwgnjDcSc55QL3XNsfTzShGokm1mpta3o/uwmpinUfxkQGRVAiq2s0eIjTXv+Slvr9
         Q7J+SzPUxk4q5/T1xQdbOE0ZZFQRt2Ay16Nxop4rcA0JamTIS9OxDDRMxjpUE3aX5dY5
         9nSbuUkOD+89COll0/fxjoDY8BflapDvQUIf22qcqQ0SMkifq4jHcMbyHn3Ep6FahZge
         udA140xOygzbU8O3V/O8Gah2/i72uHNY/pXCKD04uDuSxWak2jo7jCVHClPmVahEy98P
         lfG1zsQleYwpq1btWimqm7U3rtWzu0IEA7ToSlzHcvIIpzjfL4Vzo1gayBdrv8HBeBLJ
         +Wiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818380; x=1780423180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YW83U9WXzmuOgO+qiU2xntn4xO4oQspRqeeRLd3+Ago=;
        b=NNY35k/2fqF8ZhOXkBrCl8ytKEeHh5qJN+/W3ZVSi6L7Qy9IL10EOKCI+779o9O9vs
         tfNn2EzvkQX3GMXr3JEOGEfusMj6xyI9tjcltw5+ueHe3kt5oc36rffqRj8EPFTXpzDC
         artmpzrhf2pUAbgd7FdiUXAd7NlIU9FGqIAVjt5Bi233NmTPd0Sp4tz9Lpgcq5WJhFUb
         V80hnAq2GuZ6QnqV0NMkkyOTpMnHJoLhRIt2EcHA9Qn1cC84Xc/WBVRNqEi+96aonLz8
         i1cx9Do8MFyzZ0M8rwGSowdUeEU19PMK6Jm4LxSXmYknzmZLCGEZwqO2CPdqfp22t0Cu
         p97w==
X-Forwarded-Encrypted: i=1; AFNElJ/ENw/y+W39gwZTnJylnqYJnOG96+jwTixga6zeMWZ5IOl82TssPcDRbiMCDe6xTBX0/sAVpkr67w==@kvack.org
X-Gm-Message-State: AOJu0YzbS50aIpE7A1w0Fd/b3OV3+yI/5G2OOA/Vmi1P7zf0/1p90KEX
	LYQaYeS3jbV82vLw4nIxLBuu6omx+PRxtJMQI2g5OK7OBiLv1q9XX2Hidt2xdpvpgBBQyKKuSg=
	=
X-Received: from wmbet15.prod.google.com ([2002:a05:600c:818f:b0:490:3dc3:e5bb])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c4a1:b0:490:3fd9:e78b
 with SMTP id 5b1f17b1804b1-490426cef8bmr337552265e9.17.1779818379722; Tue, 26
 May 2026 10:59:39 -0700 (PDT)
Date: Tue, 26 May 2026 19:59:02 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3044; i=ardb@kernel.org;
 h=from:subject; bh=yy+qAKwWsZGAcScio201064FyPP//0qmouvkE8IJvkQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fnaITtnLMqdFLhxOPsKdSl/fzf8vyMu45VaardtDA
 beLD6d2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgInYcDP8lc9eXJtj5vLqXm5w
 sP0Cd7YzPcsCnzf0M7wXrV0bcOh0CsN/58OffBc4fZ3FmC48Z1Xn1KPu098u1d/xmnenxq61z05 +ZQEA
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-32-ardb+git@google.com>
Subject: [PATCH v6 15/15] arm64: mm: Unmap kernel data/bss entirely from the
 linear map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F589100011
X-Rspamd-Server: rspam03
X-Stat-Signature: irntipk78eioeuimhy4bhsx6u8dwy8sj
X-HE-Tag: 1779818381-504618
X-HE-Meta: U2FsdGVkX19RnRPjNtqu7f66N56Uwf1/CZhtTDtxftHD5NX8tdsl69m6Gb6UJkTiaYu0Yy4gByC/B44HIlsAguQl6CM3nA3GzhvtuNWq7g0U+YIPxCox3YI2/CG/smPcpejHm+kjcePbqauOHc4aYMw8nnYjwKlCODiBAwCa7Wjq7dOfSfNdCa2e6zmEV/G/hcJA3l4kyB7oRD+Ty/wuyMsqXx9RYJKuVBVTextDjbF8e4hY1N8jSfirSXST2zcIwweoZetAGvWrVtnYNb0KODhPYnqEVrSLoUFkTe5pcGH8Q9Tic3qxV7OfMa8Fn6dSx9toJ8onnc2erS/oWtOrByDFTusYgF/J6CmCEwr1/o5GCmKryzKw+AGFk2QU5X9T1g6J+GTcXctrD6AxFFgxzw9IHUVMVTUimKq+L229M3IWgbmQQ0Weof36pgWRDWK9Cj/LcT36sRh4V/258DysIOZDHKbOD1SM+J7Vc00i8ZZJCgifEInvNpc73d9l7lCatz7JTxMDJTSYQhY7fiEkNBHWa/yWOh1C9xo/Bn5IjlUWe9sEm18umkDSPr3sXmtSIgYsClqxN28Rz94Rkf5JcAYiirIqDtczv2sGE9vtM2M0zI9h1Ic3TpiKLgnR4whFy93ic81uyrRkDjJlX4yTyNRmRlL43yT4rsgk413UpEoH+9y+eSn4MtOGtXoyiPVqVePCadyJqNATUivkx2X76rMct4zm3IvlOPWNiuc3sDz5OXbPhBF2LPQ/mnwij1khCoj1AnfDItTyPjQDs3qNYjR9BxE79LcYYHRR/Y8javIqnylRxCA2f9ns58WOlMLuX6hlIcqOy3PF4p8FrdE746/FyGjhDUJofu5S9pp9Cus1x8QHsHOllgy973LLSjzzmWD33iuthTuwVpraIjF/i9FQpWr3Gkw2KW2BBqpbZfojLAEGymSo2j3HX78meVj+BtTlVsLt8uVQZrFRwF6
 1BDLyO/t
 1gNZSK2Z9wDvBrA6RBwS7BN8lxRZZ6ARHZKeocoKFUNX4/T1NeFqUAIO3VovG7gfQ77NGMx10KaFtjOmCcxS6FJA2ZolwcS0Vr+5o+t4Sm8ZTrBEMcugfzx1ox3PAGrPbHP6lPCeOyX7+L6IRozZs1ziDVLin+S84m3ZzXzch70syHbxWwtc0Stl1ag8tZu1ibAnzPTuQrpv3AhZzo98l2yCx855W4WYtk/cIXm7KpYrY7Q9zAlsSXq1fmFZ89cVNDfrTEcjYgs1y/0dfm/HnFVEKFFmvGY42e6W4wr71V6jPjPGn7zoj6Py6ysziTRqtDIk9NUD75vkuO3GDcOptRt1ny0z1RVeKuUMoz3qEB1VuqFGoBENqLRGDdKbj/0i4qA91GDl39J584CKS/XvvXx8x/gnG+E90eT1RspuLG2Djz6CWcD1NEOGOyBMUPwMo+Ndq/UhyCSwOgtv7xWXYJidaJ4+EgLLNoNhntNhNtSznrjJU9uK8QGXPtsuE761ntioQUADMoT6sWzMRz0eqIlkvcXqPtmEo1fKwDuZRMG9DY94aMM9xMZU9yxRN6UDjsbbvaTT/SsAIOcp4syRtPxP84TCE9s/LMjJo+qdQNEf+cNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The linear aliases of the kernel text and rodata are mapped read-only in
the linear map as well. Given that the contents of these regions are
mostly identical to the version in the loadable image, mapping them
read-only and leaving their contents visible is a reasonable hardening
measure.

Data and bss, however, are now also mapped read-only but the contents of
these regions are more likely to contain data that we'd rather not leak.
So let's unmap these entirely in the linear map when the kernel is
running normally.

When going into hibernation or waking up from it, these regions need to
be mapped, so map the region initially, and toggle the valid bit so
map/unmap the region as needed. (While the hibernation snapshot logic
seems able to map inaccessible pages as needed, it currently disregards
non-present pages entirely.)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 39 +++++++++++++++++---
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e7ca53d20b87..cb00e42abbe1 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
+#include <linux/suspend.h>
 #include <linux/kfence.h>
 #include <linux/pkeys.h>
 #include <linux/mm_inline.h>
@@ -1056,6 +1057,29 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
 				 end - start, prot, early_pgtable_alloc, flags);
 }
 
+static void remap_linear_data_alias(bool unmap)
+{
+	set_memory_valid((unsigned long)lm_alias(__init_end),
+			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
+			 !unmap);
+}
+
+static int arm64_hibernate_pm_notify(struct notifier_block *nb,
+				     unsigned long mode, void *unused)
+{
+	switch (mode) {
+	default:
+		break;
+	case PM_POST_HIBERNATION:
+		remap_linear_data_alias(true);
+		break;
+	case PM_HIBERNATION_PREPARE:
+		remap_linear_data_alias(false);
+		break;
+	}
+	return 0;
+}
+
 void __init mark_linear_text_alias_ro(void)
 {
 	/*
@@ -1064,6 +1088,16 @@ void __init mark_linear_text_alias_ro(void)
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
 			    (unsigned long)__init_begin - (unsigned long)_text,
 			    PAGE_KERNEL_RO);
+
+	remap_linear_data_alias(true);
+
+	if (IS_ENABLED(CONFIG_HIBERNATION)) {
+		static struct notifier_block nb = {
+			.notifier_call = arm64_hibernate_pm_notify
+		};
+
+		register_pm_notifier(&nb);
+	}
 }
 
 #ifdef CONFIG_KFENCE
@@ -1189,11 +1223,6 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
-
-	/* Map the kernel data/bss read-only in the linear map */
-	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
-	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
-			       (unsigned long)lm_alias(__bss_stop));
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.794.g4f17f83d09-goog


