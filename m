Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D874C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680306B0111; Fri, 26 Jun 2026 13:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631306B0112; Fri, 26 Jun 2026 13:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520806B0113; Fri, 26 Jun 2026 13:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24F486B0111
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:35:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A263C25E2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:35:36 +0000 (UTC)
X-FDA: 84922765872.17.8EA121E
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 840B04000F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:35:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=IwKQVIfY;
	spf=pass (imf12.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.177 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782495334;
	b=aB932TJIqflQAjUzditzvyKv6O+QBesATuWCEjUBECqjIi3jBCUT2hrWzXcektyRy5kAcn
	OrmBaQxJSQNqHCC5GOQ/qj4BDjSKtjaVoyOq8nPT6iM+YoE3aMN36fod8rHWpbDNmQUl0k
	YX5G1LyAs31VMt0ap1GPBJx7/QT/7OE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782495334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2rq/jb9kJpeX24z87UrbY8sPlcGI6O1WY5TpBBjHjfY=;
	b=HEMaI+XgMjH2UKwJdSQPnW2GHHM13B5qDiipOSPIQxuZbY1+smTT7sVp+1HE5HbhnCsUWg
	srHFjSNVCK+8pJ29tSBkQf8gE+OXL40rsP7PVWCtzrJCh6qj2+n9jCuj/VWyW7RTRCktj0
	LTc5Uc8cAnAKx/XfRffnphCqHBpQH08=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=IwKQVIfY;
	spf=pass (imf12.hostedemail.com: domain of xmei5@asu.edu designates 209.85.214.177 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c7f1db3ad4so11468735ad.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782495333; x=1783100133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2rq/jb9kJpeX24z87UrbY8sPlcGI6O1WY5TpBBjHjfY=;
        b=IwKQVIfYT4l0hOcTNCpDpRhlaFW8fuKQjNc3A/fSYENz1bNI/5ruES5q6J7fe4h4pg
         VLDwgKUl1bbIvnOJtBB6dXpd5w5e5di+YXOs5sc026N8XdoL3Fdk/4Nvs1gvllX/jBqq
         tzlWgBG3lonqjY0kMhKIgCHbT/yz7vWu5AgYSVdd7v2JxWkYWwl5G4KWxy+OiJ63f114
         ydLiYzY331Kdfi3NxE5SQ2USe8nSmeaQ9u/dn7ksqCQmjQZw2DhN2wywSjAMWIDC1Ac5
         RTCTrlqa3D35OHRSh+MKMUY4bXEaY71u+q77VpBKSTWrMg6k0kMy7UFhEgDM6eBGX/Wj
         ouSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782495333; x=1783100133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rq/jb9kJpeX24z87UrbY8sPlcGI6O1WY5TpBBjHjfY=;
        b=BNt8Ho02EGu7GPSQtknm4W+pjp4ROD6otI81/sCsPym65Dj146Lw2MDYZDkdsvPAhg
         lvHIQnUh2cSw4nVVu8mtLiEEA0vagqHGmkOr93hw6nQEDMk8het1QxJBvak4qWsh7fVU
         tmu5LBpWZx8kwQaps5xpcKrAcsXB/aFJd77W//3WKoKoqAu/q/HpjMJcuW6kD5hvcVKq
         FLs/HBDD6ObZv75DuVP91q+1ssiD4mjDAt+SySjrc+cY+Ld+RtNlV93HqHnMpeYVntjy
         po11FDOWSYa/w/RFkPfFI346ULKvbbhxZ77i05DOEgKIzDox9DC1bo6qA41tbY8W5tT4
         EGVw==
X-Forwarded-Encrypted: i=1; AHgh+RqHYePfhjQkdj1IfRW0yH7rdMo6Ldbn1xzmzkWICOAnXJXzgdLrmWoRhr6/5IeA8PKvZSnniOr2MQ==@kvack.org
X-Gm-Message-State: AOJu0Ywf+26ZKGZ9WPGtN74mWLage1JGiDm6sbbzxt5E0yJDBZuh/keG
	7POeAbAqd6DqilRSo0pcYGqTj88yCaVvY19Zs/O0rWsjIDxX7bNfZ/fWRTNq/kt39A==
X-Gm-Gg: AfdE7clWWqULgGiHDZoNZj/efVF00BAjJtp70EKxrIggjwZE0z9cRp4sMf0X4Pew3vi
	1deIbnJyueMIsq18S05Uzjkynbpd33ZjRL/E5iMOoQE38b17HIEtNtoy3ZYTeu2dVNXc8iVUn0s
	BF0rrQJ9iuxKJPf2AHjfLWEk9sjRYNue3IUBS4VfSQeEPJFj6k9ppbvnSvHv6yVray+hQHlPf/2
	Hp112uYpfOrjaRPPz8M0COmW2J2taPqSDs9yniyX3O0JsxA2YpqpvedhuyT8an6evjeErVTvyZp
	+/P7GD6TxZL3JpJftIwq6KUtJdLGAbPr6hfuof3Os8uJPfq1ps/aJA9nk3cQveQDJjxYUWoSxrO
	FPrdu4N6s6gkF514IBLatWg9flwYwfDEksXG/xG+DfOfNRlYYe6h1AuPErpRTYJKF3lmUVuziRw
	YGc875BFNH
X-Received: by 2002:a17:903:1cb:b0:2c7:f227:58ee with SMTP id d9443c01a7336-2c7fca717bdmr68178005ad.22.1782495333348;
        Fri, 26 Jun 2026 10:35:33 -0700 (PDT)
Received: from p1.. ([172.56.109.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f6509ca0sm42853305ad.81.2026.06.26.10.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 10:35:32 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-hardening@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>,
	Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>,
	Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based stack pivot
Date: Fri, 26 Jun 2026 10:34:44 -0700
Message-ID: <20260626173444.2252041-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 840B04000F
X-Stat-Signature: 3jrh6f4xry4cjouq996eksic8881upce
X-HE-Tag: 1782495334-824216
X-HE-Meta: U2FsdGVkX18GpqGJNXM9ct7BhPDZ/KbM435kl9lDUzY+VLnmWGTANlZVAxUaeDi6gpsT8qf9ueTL2QTz+UjLUC9yQH0e6BphS1YKh6VTuMSJvT4H7T9hHIzBo2XJGzftSPsoYviEJ14y7xoJlNRvAdJbQK9v5CgqwzZtix1TeDJNy61Au0ZTyRCxMcwKKGzZ5znAeqzrHXTD7aREW2MTaOEG/+LTnFF+0UhNZYBkxBg47IaXKjUlrBUhsb/M6t2TB1CeU4fgyPxLz1UVCVkO9TNzNaZmLna64NtSjYW3pCCQ1pcQWZVrbuzetKzvXAXOU+LQv3BXTcL/+gPbwvvJ7lHCJRhM/RzD+JLHJA9TGh8kHJuEtjK61Y8zH8CDkduOj4BEL/nwrRFrpjSzkkL085f+5toJ7qSqXYrjjcAZRa4a7AKsizdRllgmo1ZQGmZooAp9/KbNKPY53ryh0vH6DvxikmgomddQuqfLYDQQH0oEvjsxVCL9qBbCnN2SaBdxekNfRlD25dWBQFcPTW2ktkTcQviE45l+ESr2JA5Wg2KAV6Pu0GLzTqpc0vpZP0p1H7Y/+wzbGkjdtmK+jiwMnHFZt7UmgMTKU1SvVXvrlsnk3SFVoJIMSaxs5g0nw8M3EBWXPgVPxycC60h7ffSbPO0/w4icB/UiJT4mHUos6KTlnxEzpakW09OF4QI+R6ejKtCAssdb5Cr4qN6NxTD6FlhI4/h4W3WuSp+ProMWMntQiFRewsoSdnQFTdDLw5pzk4F1Jglw7j1ZwT/K5EZGM7MaXWuxtbqfUynq36taXp/APyogTFFvQ7mSLRwn+Y7FUKQRRVefHIaV8XFK5WAxNxvM3I+wQ/va+WWJuFcZAX6rfli27uke+VfAOL7FGdKquPrwgIGSwky325klWSKh8uwekvH6hla6cveP2ZG8UgOmBpvRaqoSQYlsC2wKZ8JpnaxmQQRPLaVuC8lP+j6
 Jsq4YrXe
 OqOs/piUbxyRFfLBbvEUSPAMG9vq7dq6Vb6Cu0KXaoTwX09JeGj7SLnlVRXJbt89kOOuTU9HAvsIyfyo1udwvjrtqaFV03w7Vf8QFM4nblqZt5N28p+vfAmW31eGmgBlfVJZcdek8dl0Ju9KMsxLsWNT5LHHivp69N32lJRAJwRu03TgMWUg0AngwfcBgtavTadr+8tPqEw+hQzFDifdgDmjI+hd3KcXH5DeXkZOifxwctc6wMezZwi6Lv9CjEPoDKuimF4LXuHUYXAfczKwUZ7kcB2Y8qfVGxDBF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc area,
which an unprivileged user can surround with attacker-controlled data by
spraying vmap allocations adjacent to a target stack (for example via
XDP_UMEM_REG, though other vmalloc spray paths work too). Today each
guarded vmalloc allocation is followed by a single unmapped guard page.

A single guard page is not enough to contain the x86_64 ENTER
instruction used as a one-instruction stack pivot. ENTER imm16, imm8
builds a stack frame and lowers RSP by:

	imm16 + 8 * (L + 1),  L = imm8 & 0x1f

imm16 is an unsigned 16-bit operand (ENTER never raises RSP), and L is
in [0, 31], so the maximum displacement of a single ENTER is:

	0xffff + 8 * 0x20 = 0x100ff bytes

That is more than enough to step off the current stack, across the
one-page guard, and into the adjacent sprayed pages. When those pages
contain a return sled feeding a ROP chain, reaching any ENTER gadget
(opcode 0xc8, abundant as both intended and unintended gadgets) turns a
control-flow hijack into full ROP execution without any register control
at the hijack site, making it a one-gadget-style primitive that
significantly eases exploitation. The pivot happens after the control
transfer, so it is not constrained by CFI (kCFI/FineIBT).

Widen the guard region from one page to VMAP_GUARD_PAGES (0x11 pages,
0x11000 bytes), which is the smallest whole-page span exceeding the
0x100ff-byte maximum single-ENTER pivot. A pivot off the top of the
stack now lands in the unmapped guard and faults, instead of in mapped,
attacker-controlled memory. RANDOMIZE_KSTACK_OFFSET only perturbs RSP by
a sub-page amount, so it does not change the required width.

Introduce a VMAP_GUARD_PAGES knob that defaults to a single page (no
change for current architectures) and can be overridden per arch via
asm/vmalloc.h, and set it to 0x11 on x86_64. This is deliberately scoped
to x86_64: the 0x100ff bound is a property of the ENTER opcode, and ENTER
is also a one-byte opcode (0xc8) that appears as abundant unintended
gadgets. Other architectures (e.g. arm64) have no equivalent
single-instruction, immediate-controlled pivot reachable as an unaligned
unintended gadget, so they keep the one-page guard and pay no cost.

The override is gated on CONFIG_X86_64 rather than applying to all of x86:
VMAP_STACK is selected only on x86_64, so 32-bit kernel stacks are not in
the vmalloc area and the technique does not apply there. 32-bit x86 also
has a far smaller vmalloc window, where widening every guarded area by 16
pages would needlessly pressure the address space.

The guard pages are never populated, so there is no extra physical
memory and no additional page-table population beyond the larger virtual
span; the cost is virtual address space and vmap_area bookkeeping, which
is negligible against the 64-bit vmalloc window. get_vm_area_size() is
adjusted by the same VMAP_GUARD_SIZE so the usable size reported to
callers is unchanged.

On x86 this widens the guard for all guarded vmap areas, not only thread
stacks. ret2enter targets the stack specifically, so a narrower
alternative is to apply the wider guard only on the thread-stack
allocation path via a dedicated VM_ flag; we kept the change in the
common path as defense in depth for any vmalloc-adjacent pivot target,
but are happy to scope it to stacks if maintainers prefer.

Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Jennifer Miller <jmill@asu.edu>
---
 arch/x86/include/asm/vmalloc.h | 21 +++++++++++++++++++++
 include/linux/vmalloc.h        | 16 ++++++++++++++--
 mm/vmalloc.c                   |  2 +-
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmalloc.h b/arch/x86/include/asm/vmalloc.h
index 49ce331f3ac6..2c341f398227 100644
--- a/arch/x86/include/asm/vmalloc.h
+++ b/arch/x86/include/asm/vmalloc.h
@@ -5,6 +5,27 @@
 #include <asm/page.h>
 #include <asm/pgtable_areas.h>
 
+/*
+ * The x86 ENTER instruction can be used as a one-instruction stack pivot:
+ * ENTER imm16, imm8 lowers RSP by imm16 + 8 * (L + 1), L = imm8 & 0x1f.
+ * imm16 is an unsigned 16-bit operand (ENTER never raises RSP) and L is in
+ * [0, 31], so a single ENTER can lower RSP by at most
+ * 0xffff + 8 * 0x20 = 0x100ff bytes. With CONFIG_VMAP_STACK the kernel
+ * stack lives in the vmalloc area, where an unprivileged user can spray
+ * adjacent allocations; a single-page guard is too small to contain such a
+ * pivot. Use 0x11 guard pages (0x11000 bytes), the smallest whole-page
+ * span exceeding 0x100ff, so the pivot faults in the guard instead of
+ * landing in attacker-controlled memory.
+ *
+ * Restrict this to 64-bit: VMAP_STACK is selected only on x86_64, so 32-bit
+ * kernel stacks are not in the vmalloc area and the technique does not apply.
+ * 32-bit also has a far smaller vmalloc window, where a 16-page-per-area
+ * widening would needlessly pressure the address space.
+ */
+#ifdef CONFIG_X86_64
+#define VMAP_GUARD_PAGES	0x11
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 
 #ifdef CONFIG_X86_64
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b02c0c6b371..b8546e519deb 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -49,6 +49,18 @@ struct iov_iter;		/* in uio.h */
 #define IOREMAP_MAX_ORDER	(7 + PAGE_SHIFT)	/* 128 pages */
 #endif
 
+/*
+ * Number of unmapped guard pages appended to each guarded vmalloc
+ * allocation. The default is a single page; an architecture may override
+ * VMAP_GUARD_PAGES (via asm/vmalloc.h) when a wider guard is needed to
+ * contain a worst-case single-instruction stack pivot into an adjacent,
+ * attacker-controlled vmap allocation (see arch/x86 for the ENTER case).
+ */
+#ifndef VMAP_GUARD_PAGES
+#define VMAP_GUARD_PAGES	1
+#endif
+#define VMAP_GUARD_SIZE		(VMAP_GUARD_PAGES * PAGE_SIZE)
+
 struct vm_struct {
 	union {
 		struct vm_struct *next;	  /* Early registration of vm_areas. */
@@ -236,8 +248,8 @@ int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
 static inline size_t get_vm_area_size(const struct vm_struct *area)
 {
 	if (!(area->flags & VM_NO_GUARD))
-		/* return actual size without guard page */
-		return area->size - PAGE_SIZE;
+		/* return actual size without guard region */
+		return area->size - VMAP_GUARD_SIZE;
 	else
 		return area->size;
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bb6ae08d18f5..8bb2b3ef40a8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3217,7 +3217,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
 		return NULL;
 
 	if (!(flags & VM_NO_GUARD))
-		size += PAGE_SIZE;
+		size += VMAP_GUARD_SIZE;
 
 	area->flags = flags;
 	area->caller = caller;
-- 
2.43.0


