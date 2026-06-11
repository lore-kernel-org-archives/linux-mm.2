Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFC1CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AC66B0095; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFD36B009B; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FFB6B0098; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8536B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51B431A0651
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:58 +0000 (UTC)
X-FDA: 84867644316.23.279B682
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4CD5E18001B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SUlctvwU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3wrEqagcKCCkFGFWSFXLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abarnas.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3wrEqagcKCCkFGFWSFXLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abarnas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUGCjfh6EUmYtCCfKGjZNWokb6MJPrpnpmuE3FfsWTU=;
	b=3WlAB81ZAIS3XxptZtxOxWFMen/3pIa29tsoNPBcfJk1hDNQxSIkEpEM73ek5YbFOvNeIw
	tTn9IKMHrMNjPgGdpFzzJsLopr084uAaesvkzj/nlj4RLVTNNzfbKrqwLomk4vGAeexvys
	GJCl+OifeXk8dxUBX5dFh588mBMG5Wg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SUlctvwU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3wrEqagcKCCkFGFWSFXLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abarnas.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3wrEqagcKCCkFGFWSFXLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abarnas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182916;
	b=Xg6YTr1phX+3ODWPp+Vf8ELY1kSGcUGCfMU5orKdREVV6oeYCUeI4ZYDFC2irobPCDA/xG
	4RQWIvr5i4BW0N+WAhCAEnZlgOE6nbv7m8X3tgtgoq51JQpeSqnlTJWnuRkIJqHYhSw7QJ
	5UDlzwULEhcxnJVBMZI65EqNO8qCLLU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490abeb7298so82660665e9.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781182915; x=1781787715; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUGCjfh6EUmYtCCfKGjZNWokb6MJPrpnpmuE3FfsWTU=;
        b=SUlctvwUvMY2uET8VF2bwilBaEZ3Z7kOE2LTOQxXkU6QMIsd6jko/uxBykxaKcrqin
         aP01IhUPl2oYMgyQ7rH1Nnq8PIuPj2v0jcLMeCDXvmpT+RlwpW9nLmrQPOmVM7rxKWxz
         V09TOCWcofJ0lhvmiEEOjpdzR6QL4UEkz6E0DDe3tCN8QQ2FBkqvfErpGxlH+oJ/Y5LK
         uJCuYDStOC56xLQmFvK9q0V/NUIDTTwy/LmXOaio5I9TGpayXCEcWubUU+ADfXZlJAlC
         z8dLWP3MYm6sERoZ6ff9Wx5zO4maYCACVWmFw1pbSGrGS0gfoG62LD0DkL/H7djPpWwz
         kWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781182915; x=1781787715;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UUGCjfh6EUmYtCCfKGjZNWokb6MJPrpnpmuE3FfsWTU=;
        b=RhgK7vvbpjY7XJ2pEU69lEJrezw31HE1FnHVty7i1vptjAnf6WseipMU20KfhPijPi
         9v+VMFt5vSw+PQSnJh6wENxhdStYDDOzEuPFfTckZfQMvHdOJK8k/nFaox7x0KGnzJSN
         Ktlp6BBT5mfKgXiEW22Tk/pv119uYSJjwHA+MOANk1kfl3E/z0tCoEkeSot2+pFe0izI
         rQXwJJA3VnrU+TJ65CgaFxgxHxEdk+AotFR7GHqztOQ/1pChPKZULZ18soutUPwa7L0O
         097xW+7R3Q2JWwLYw+n2iGmBbArsomhvptf0uoht2BH+oNTtouGuoRNQqpFauj86mAYp
         jEJA==
X-Gm-Message-State: AOJu0Yx8E83+qDqhDBoWh5itT+xqZsbyEfOOgHN/+zTqrx41XoU9cYy8
	wjOrLobSjD78djvuNBbHB4QS/qqynnKwu4liDq0AsRhVk07rHfl6zkqdRAW9g7G9KsXdAszQIqS
	f8cbg+DvjUw==
X-Received: from wmlu18.prod.google.com ([2002:a05:600c:2112:b0:490:b58a:2c9b])
 (user=abarnas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d2a:b0:490:bbc1:d508
 with SMTP id 5b1f17b1804b1-490e55d0f77mr36764525e9.1.1781182914565; Thu, 11
 Jun 2026 06:01:54 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:01:43 +0000
In-Reply-To: <20260611130144.1385343-1-abarnas@google.com>
Mime-Version: 1.0
References: <20260611130144.1385343-1-abarnas@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260611130144.1385343-6-abarnas@google.com>
Subject: [RFC PATCH 5/6] arm64: execmem: enable EXECMEM_ROX_CACHE on supported CPUs
From: "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CD5E18001B
X-Stat-Signature: 78ex1tephg4879uydx9mkiwb5nc6koub
X-Rspam-User: 
X-HE-Tag: 1781182915-540867
X-HE-Meta: U2FsdGVkX1+wC2vDjq9+CilBtxHiqX6IH/Im0bYPaoLaH7wtzeZcfCA0ldQ910+orWoJKbk/CB8PP+HFidVl+tOEdWPqYctVAypZS7/iok9gH8yXIhSoYe8zj1wZ37jNL/UIHF9CYwKJxc+8xR3P0cxfoEdJpUixoHoy8jxVAN8EkIQN2QNzL64DWUTyWW6bCzu2HZgUZ0hA3/UuvWF0zNU0KulUUiju+ykUxILxKvnHN1t5kNxQE8fFsNg0E4g1reZtxtLmsezUlaPrWqVNFd5CXVD4q/tUGnSeV0tIg4nA1LT74F7lzA11UyyXDlkvluJFU0UsgE5AgMML/IAzScxl06rbR3BQhungeWSDH6o6FFy5O9Q3aFjvjFKNBt82d3/Xa0VZblneWNe+vQgMdcUyBYzETqDSS3gLhSnjxGrYwveo5CpZePdeo2FpaeIEwXpRc/6/Axq2aeDXErUWYpIqxBqF3OWrhjBsUTZQBS1r2mJ1Cu1LX06ZZVdEiJk2BM/ZZzv6O2qrktmziiY7nR5CkPDWarH5XXIofIXk/RY7a/JZW6KYJBsyIuzNfq0V+JCmD8o7HkukbxFZQV8OeGJUyRJg8/WD2lY0NftfCmLW5celG/0ONm3DBPRpa3TliC997i5hDFhReTQFoP/w2uxYTCMMf0CJthrfkVq/1lmxlDCPlhykoERNTgAxhzLg+mx3SndoJIoaiNUQZJu+YED8HHVQNw7NUoz6g27FqjYle4hXo1oz1R+LIQ11z6iWPXMgO+eT30HQZGx73qs2kskj1Wix5vKv0eHE6ccyawXR83WmUASYTMdzajzNkN1qSaz2u8BRQX85dEyw9QuI4ExHeSvHCBCSxAftJqHsIfjuASQDqX+gjgueX1DS1DuU+CVuZUrI03cDHtfT1FiBaD8VrJBCwsJzaQP0ZCbwWIiCCp2yfvnOuA+OLBcVqW9NgYi3fValE2uN1qh52c7
 XKSTd064
 yyByCxggH5qZKXH1ytLTNhGMkTt8okEqhvWtM4KZJcVgtZtBBFL6TiXanVR9XmVETWZ7yZdv3CgvSlCYqqAQGC/oiGN94XPp/9xhOux1h+pJv2JGYzVwbt3RhBb4eBZL0gAX0nDSr8PAh9JOoVww0X60hZBLZFAdne4Jt3kG4rHZGMEExhEtZUWntu0yfbl2WSduU06NujzTVmAdrBX/hAhY0bcTFNZW3Zxgdlbk2zOQAHhX243b76nZtPZhg6sbE3jQ9VI+MR3+51MQ0vum94CJpNnyUMjrvA0GBAvaTaxs0nDZxWweSGmMcKHxsrPtNCTiNQ6bcykhMzf68pLNHyIiRgJSMovpkftxcDt9V2yQ4SmlqTjyjVxHRj1h5rxAaJ6Clobky4Mu7GWN76widU/jwq6tdK4UYCglINRt5Wk7hgwRTR0qxYyhXcL59ca4OxJdmGa3ioZAfTUvb+CggGF7bxj7BV8DaSoqzMtTVamkd3FHzhyycaKnwkIjKmPG71wRpH3Z1Igw3AMn0OxER2GwItAglrNfD8JfmEgRPkrAsDDb4+ivwoeblv6w7hdm0qTIQVQAuTyN9BLR8OVQtrkkr/JNI56D4ox74KlCIP2fzybgHGyJcEO3zmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable EXECMEM_ROX_CACHE support for ARM64 systems that implement
the bbml2_no_abort CPU feature.

Using the ROX cache brings a performance boost by reducing linear region
fragmentation caused by strict memory permissions (e.g., W^X enforcement).
Grouping executable code (which is read-only in the linear region alias)
into PMD-sized block mappings reduces TLB pressure and page table size.

This is only enabled on systems with bbml2_no_abort, as splitting
these large blocks to make pages writable during module loading would
otherwise risk triggering TLB Conflict Aborts.

Signed-off-by: Adrian Barna=C5=9B <abarnas@google.com>
---
 arch/arm64/Kconfig   |  1 +
 arch/arm64/mm/init.c | 22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..79c347ab841e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -285,6 +285,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select VMAP_STACK
+	select ARCH_HAS_EXECMEM_ROX
 	help
 	  ARM 64-bit (AArch64) Linux support.
=20
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 71aa745e0bef..8269d7747b84 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -420,6 +420,12 @@ void execmem_fill_trapping_insns(void *ptr, size_t siz=
e)
=20
 	flush_icache_range((unsigned long)ptr, (unsigned long)ptr + size);
 }
+
+#define MODULE_TEXT_FLAG	EXECMEM_ROX_CACHE
+#define MODULE_TEXT_PGPROT	PAGE_KERNEL_ROX
+#else
+#define MODULE_TEXT_FLAG	(0)
+#define MODULE_TEXT_PGPROT	PAGE_KERNEL
 #endif
=20
 static u64 module_direct_base __ro_after_init =3D 0;
@@ -511,6 +517,8 @@ struct execmem_info __init *execmem_arch_setup(void)
 {
 	unsigned long fallback_start =3D 0, fallback_end =3D 0;
 	unsigned long start =3D 0, end =3D 0;
+	enum execmem_range_flags module_text_flags =3D 0;
+	pgprot_t module_text_pgprot =3D PAGE_KERNEL;
=20
 	module_init_limits();
=20
@@ -531,12 +539,24 @@ struct execmem_info __init *execmem_arch_setup(void)
 		end =3D module_plt_base + SZ_2G;
 	}
=20
+	/*
+	 * The ROX Cache requires bbml2_no_abort because it uses large block
+	 * mappings. On systems without this guarantee, splitting these blocks
+	 * to make pages writable for module loading can trigger TLB Conflict
+	 * Aborts.
+	 */
+	if (system_supports_bbml2_noabort()) {
+		module_text_flags =3D MODULE_TEXT_FLAG;
+		module_text_pgprot =3D MODULE_TEXT_PGPROT;
+	}
+
 	execmem_info =3D (struct execmem_info){
 		.ranges =3D {
 			[EXECMEM_MODULE_TEXT] =3D {
 				.start	=3D start,
 				.end	=3D end,
-				.pgprot	=3D PAGE_KERNEL,
+				.flags =3D module_text_flags,
+				.pgprot	=3D module_text_pgprot,
 				.alignment =3D 1,
 				.fallback_start	=3D fallback_start,
 				.fallback_end	=3D fallback_end,
--=20
2.54.0.1136.gdb2ca164c4-goog


