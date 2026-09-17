Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DA0C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C336B00A0; Thu, 17 Sep 2026 02:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE04E6B00A1; Thu, 17 Sep 2026 02:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85996B00A2; Thu, 17 Sep 2026 02:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE8D6B00A0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FB6514022E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:35 +0000 (UTC)
X-FDA: 85222222470.28.E206916
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3FAA180002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tgvb/ymQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625253;
	b=3HhP7ye0Bp48/a34oPnqdL25+spyz8nOnSplfBhLnWIGYC29Cq/lKoBPIZ4q3Cd9FkcLrP
	nvrwNs2LLdjrTncjhXiaqXsylHjC4huVnlErcoqBTLujcwS9jU2QE8p4miXllmeMXloKex
	8EV9i0tYm4xnJswnsq5WiW0MBr4gd3Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tgvb/ymQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTDScTOE8TQ4i6dhThN64lodtCizNRIyLxOaq3CiOvA=;
	b=BWCYvHio84IM24WPEh2lVV5HJG2kureAyISdbEqJ22zdOUE2g8seCedUMZW9TcVcm94c+7
	dddkEu/ddjq8UI1JoqUuf2fcvcM2vfEQs1cj/IxNwH+2BSsXT3Yy3H54QHEa/S8IEvZEb8
	pkqgUlTRCF5KIZ+v5c1DYQp1qMoOKW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6833060A5F;
	Thu, 17 Sep 2026 06:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256E41F00893;
	Thu, 17 Sep 2026 06:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789625253;
	bh=hTDScTOE8TQ4i6dhThN64lodtCizNRIyLxOaq3CiOvA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tgvb/ymQ4uZxzlwsrt4zt6ZJ0/fykLPinMpgDdvhvxceX9F52Rf/TeKwk7n9hkJ/m
	 6Mze0ESvg53N9bgJSEK76Wx62sxfQ1xfakOmoxdjDO+9uvlkIHio3snOeGlbHNI4R+
	 JsXpzZPlutDvCjdeEzxV5pXh/zJSRw7Wooh7Ra8I+4jPEwfIjtFOG83VdYAac2uEhZ
	 JHIxzHVHt0zPi+6n4HdHpxa5ZpH6L+g5PsrlIVexBz8RFcGhePZEbc5aP0igBBieBs
	 O/LviJWcKFqQsBVjKPMc1i9C4vwLH/OgpIvoFynQl+MRJ+ljIBsmI2mfNUiwX2X1FO
	 k098b3Ccnej6Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 17 Sep 2026 09:07:07 +0300
Subject: [PATCH 5/5] hibernation: make hibernation unavailable when
 debug_pagealloc is on
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-hibernation-v1-5-7f7dfae3dbe0@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
In-Reply-To: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3FAA180002
X-Stat-Signature: y5hdb4wyhzqyf34hy8jefqazbgdixpsw
X-HE-Tag: 1789625253-537534
X-HE-Meta: U2FsdGVkX19rEIlOYAeRi/ZTjWmK5IRn/S8Zl45VZs0DBAszzaNfOA+rdtKRx88Tb1S5Nlls12iItbyqIHaIEaNEcxO6wXXSQECw8/jjCMxWyBoBuZyy7elDX9/YSH/oQDFA2BNHeoBMbeiTCdiaEdq0zZb9Uy+1TM3GX1U4ARn0JgPvwm0zFb/lEETCiORbtY3GPK2NAFVllYXlPxNORpQOylcRWzV0Zx2VLgpZzw8vhULK97q/LUF3N4DepbErBUyllZ5uVJkyE2QWhPLB/jCTdFudfgcTN6Brr7zH9CeEvjN4vnYFv7YsD9vrmoA3EupfJvH1BNTtQqea+Q4uHF677Qzb4ytHAx4sH2jDPmmG6s92hP+1Y3k/eWsenVCbFEtDA5LIvOjvD75FQAtb2XjlRFMo0UjsIJS90NAAcsjnn7Hk1PIF0AAuIAEGKFcA2cAyXttN4c0MBvg+TT27ImpVG38UemesDdQXrmKNs7L5K7Eu1XFDB6r9/MsPtoQsZgF/08X0xXnHJjyShf0WzdQ+7znEcyeToPndJV0g8RdsWc320mczU9zQBun+8FXBnqUlmhOAm5Y98GWCYMh6sPk7CoF+VqQtiS1+GaT+aLG16UrSXt4dzfYdb92xLtr9GarRFUgEHup1arQiZDQEFcFucaSt/mr7dayZZOGs5NRozmceMIu2hBmxVC0pofwm+S5nvdVP01GsZY4ZZ51Bxu4Az0YrERkouNza97xcBJCwzHpL7sE1oMLpS2Oag1/0xnoiVUNAuVyOZtGbbwWXqvL4TwpbwyZDcZBDgaLwkPgFSx03Hrh2ZF3ruDxGTHTa7/fPZBgogxgqehTGDBSKMfi1k7th0/AJ2WmJYDcbDwUmA0/8YRKDWq5MIumfisDQ4HHsvOJlPnRw5FYGpRMn0nLBK/wloQq7wJEtpjzUIF/92SXFVuFspv/eycAMGBqdM0glDu4Ls/WgjU9HBfH
 8cmdz255
 F5/rptkG9loD8T8vZNSRCGmnudQp4MdECDZsjb1/VKpoTTgt6xrOEnUmkcAnORTMv+5cjBYdHyCSeT+p4SVdytKTPBPm1WWbdFvooXbYQr4Jexe6NyavjoDqs4hZP4/rZRFG8d6RKkphqihTZAbq/eaZXnGV3Vq2aCi3R/MDzPtbi0Lml3O5N/UIuZ8Ck94uOhfh1pTr5LmyeM8dvXwKoAuS8v4y9JxgVJC/fwBkAogIS5/sudEmnQ+HVvA7blK3robgoGDhJUmswpQdQwH4ysWmZNGSF6oEnPVg8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Back in 2008 when commit 8a235efad548a ("Hibernation: Handle
DEBUG_PAGEALLOC on x86") enabled coexistence of hibernation and
DEBUG_PAGEALLOC, the world was simpler, the combination was only supported
on x86 and a non-present page in the direct map meant that the page was
free and debug_pagealloc removed its mapping.

Nowadays there are more architectures with inconsistent views of how the
direct map should be managed, there are more debug mechanisms in MM that
can either drop a page from the direct map (e.g. KFENCE) or require that a
page must be mapped immediately after resume (e.g. init_on_free).

The latter constraint is particularly nasty, because enabling
debug_pagealloc and PAGE_POISON at the same time simply breaks resume:

  BUG: unable to handle page fault for address: ffff888000100000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 4f0c067 P4D 4f0c067 PUD 4f0d067 PMD 4f0e067 PTE 800fffffffeff020
  Oops: Oops: 0002 [#1] SMP DEBUG_PAGEALLOC NOPTI
  CPU: 0 UID: 0 PID: 477 Comm: bash Not tainted 7.3.0-rc3-00090-g4a613f1d9124 #1 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
  RIP: 0010:__kernel_poison_pages+0x45/0x70
  Code: 89 fa 48 c1 e6 06 48 01 fe 48 89 d1 48 2b 0d 9a ed 87 01 48 83 c2 40 48 c1 f9 06 48 c1 e1 0c 48 03 0d 97 ed 87 01 48 8d 79 08 <48> 89 01 48 83 e7 f8 48 89 81 f8 0f 00 00 48 29 f9 81 c1 00 10 00
  RSP: 0018:ffffc900017dfd78 EFLAGS: 00010086
  RAX: aaaaaaaaaaaaaaaa RBX: 0000000000000000 RCX: ffff888000100000
  RDX: ffffea0000004040 RSI: ffffea0000004040 RDI: ffff888000100008
  RBP: 0000000000000000 R08: ffff888130fcada0 R09: 00000000723e0de4
  R10: 0000000096ad9215 R11: 00000000db907bcf R12: 0000000000000005
  R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
  FS:  00007f8f2243e780(0000) GS:ffff8882e8e13000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff888000100000 CR3: 0000000140679000 CR4: 0000000000750ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   clear_or_poison_free_pages+0xd1/0xe0
   hibernation_snapshot+0x548/0x5a0
   hibernate.cold+0xcb/0x321
   state_store+0xc3/0xd0
   kernfs_fop_write_iter+0x163/0x240
   vfs_write+0x21f/0x550
   ksys_write+0x70/0xf0
   do_syscall_64+0xb1/0x590
   ? __irq_exit_rcu+0x40/0x110
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f8f224d0687
  Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
  RSP: 002b:00007ffe7bbe0910 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 00007f8f2243e780 RCX: 00007f8f224d0687
  RDX: 0000000000000005 RSI: 000055e3e53135d0 RDI: 0000000000000001
  RBP: 000055e3e53135d0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000005
  R13: 00007f8f226295c0 R14: 00007f8f22626e80 R15: 0000000000000000
   </TASK>
  Modules linked in:
  CR2: ffff888000100000

It's possible to build a complex infrastructure involving a new page flag
and/or page_type to allow robust hibernation and restore with
debug_pagealloc enabled.

This infrastructure requires a proper detection whether it is safe to
temporarily remap a page to include it in the hibernation snapshot because
relying on kernel_page_present() is too permissive and may include pages
that were deliberately removed from the direct map for security reasons.

This complexity does not seem justified to deal with an esoteric use case
of hibernating a system that runs with debug_pagealloc enabled.

Make hibernation unavailable when debug_pagealloc is enabled and simplify
hibernate_{map,unmap}_page() that don't need to deal with debug_pagealloc
anymore.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/power/hibernate.c |  1 +
 kernel/power/snapshot.c  | 31 +++++--------------------------
 2 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 281ad49411481..37e41c08f4f36 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -110,6 +110,7 @@ bool hibernation_available(void)
 {
 	return nohibernate == 0 &&
 		!security_locked_down(LOCKDOWN_HIBERNATION) &&
+		!debug_pagealloc_enabled() &&
 		!secretmem_active() && !cxl_mem_active();
 }
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 6583b57722e25..baa4fc9e5ad6f 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -85,12 +85,7 @@ static inline int hibernate_map_page(struct page *page)
 	if (is_kfence_address(page_address(page)))
 		return kfence_force_mapping(page) ? 0 : -EFAULT;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		return set_direct_map_default_noflush(page, 1);
-	} else {
-		debug_pagealloc_map_pages(page, 1);
-		return 0;
-	}
+	return 0;
 }
 
 static inline int hibernate_unmap_page(struct page *page)
@@ -98,17 +93,6 @@ static inline int hibernate_unmap_page(struct page *page)
 	if (is_kfence_address(page_address(page)))
 		return kfence_restore_mapping(page) ? 0 : -EFAULT;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		unsigned long addr = (unsigned long)page_address(page);
-		int ret  = set_direct_map_invalid_noflush(page, 1);
-
-		if (ret)
-			return ret;
-
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-	} else {
-		debug_pagealloc_unmap_pages(page, 1);
-	}
 	return 0;
 }
 
@@ -1446,10 +1430,10 @@ static inline bool do_copy_page(long *dst, long *src)
 /*
  * safe_copy_page - Copy a page in a safe way.
  *
- * Check if the page we are going to copy is marked as present in the kernel
- * page tables. This always is the case if CONFIG_DEBUG_PAGEALLOC or
- * CONFIG_ARCH_HAS_SET_DIRECT_MAP is not set. In that case kernel_page_present()
- * always returns 'true'.
+ * Page could be not present in the kernel page tables. Try to map it before
+ * copiyng and unmap back as needed.
+ * If the kernel page table update fails, bail out with an error.
+ *
  * Sets @zeros_only to true if the page was entirely composed of zeros.
  *
  * Returns 0 on success, a negative error code on failure.
@@ -1458,11 +1442,6 @@ static int safe_copy_page(void *dst, struct page *s_page, bool *zeros_only)
 {
 	int err;
 
-	if (kernel_page_present(s_page)) {
-		*zeros_only = do_copy_page(dst, page_address(s_page));
-		return 0;
-	}
-
 	err = hibernate_map_page(s_page);
 	if (err)
 		return err;

-- 
2.53.0


