Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97CC5C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A876B0096; Fri, 31 Jul 2026 13:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8941B6B00A1; Fri, 31 Jul 2026 13:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7828B6B00A6; Fri, 31 Jul 2026 13:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5171C6B0096
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:47:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AE2B1C0BA5
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:54 +0000 (UTC)
X-FDA: 85049603268.16.7EF944E
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0BB0CA0012
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=Hclb6FV2;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="W v7tZH1";
	spf=pass (imf25.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785515272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDJuTD8Vcay2+Rdlju8jd0+4JfwRzRzUz3/gOwvyzEk=;
	b=UwIJkf0WuY+OJWhG+HuxD/r3kH487CR8nwWvHMV+KIBhgS/Npz4xQ9djAZABiyBdmTJZeT
	BfQkJyPMPAQcXykFkg2OVSaeVlEmtLWPKgCPQvzoY2znckKxonkGD5EfISn4+vNUFsNXEY
	EFLQyZslFAl4jvKcc7yc2de5sm7uEnw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785515272;
	b=mIWow10VVG9D1O/L+jgHoJ+kxKPct/jmcVcmV50isSLARkxx8mUgYtRDpWS6SLgalKEK1t
	OwcQmAQmsF40AqEfNKXiYRcNpCTE/FSUP+oBuCKtIw2H/7M/rEgp5QQd5T/FEyKxi01zaj
	h1LDwhAgeeYacDqc1SL42S9JgXvz8A4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=Hclb6FV2;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="W v7tZH1";
	spf=pass (imf25.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 41BD21D000DD;
	Fri, 31 Jul 2026 12:27:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 31 Jul 2026 12:27:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785515271;
	 x=1785601671; bh=WDJuTD8Vcay2+Rdlju8jd0+4JfwRzRzUz3/gOwvyzEk=; b=
	Hclb6FV2E4h7miUmIFatF7vgILbkq5iEkCMeqX58TuS1emswDoozRst6lCLKrT1r
	IwITO94liQrRfXoq/UR1Cp45KPNsviPwwaTbL5dl1J8NxCPQ13RczR1dczbxjxZP
	9yc1a8zrGTfnHzhDuEwa7y5ErpPHcdhwPrDPhXLxII/PT8FJzNMWEp4NwHhtdTXf
	h4j/3BmUkYfS/ar6hgh3ffuMnR6LX31WkKnzR/LgTwG20Zs/bgUe0u2jMR8u2zXW
	9R/T76b5+qNd+cj2Mbi7EhQyyRkH8+/nDEC5w5Lp3crhvIugjKbgkLBw0MzF4u84
	yWx3dHwY61PVrsiE8Ham3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785515271; x=
	1785601671; bh=WDJuTD8Vcay2+Rdlju8jd0+4JfwRzRzUz3/gOwvyzEk=; b=W
	v7tZH1Q/YHqS3HUVGTuTIPse3MKFqCZelV6q9mYHY4epWM2zC+aAKpHYzUeAySVC
	rDOKrgHWMN+O21uy3IjLf3ebGB2cUpbFc3LQ7G6aurdaEeA5N6MEJv2wJ/zSiWbP
	AzPKJ8WKMUGeylC2516STchvP0vG+fB7DTU5uv3wEV052H0Mrkg6lwAozynmpeTi
	YNJKnLkhgerLAIWp2Np26HbQP2WFTZGHiQTXKltDpnYyfV5XOCXl40+zj4O6UJTE
	TXsFg/Igq8SRvisRCMykDMbxchMDiktjSKPctY0bjnbFHdBJG4S74Lyu6QKijenN
	vK/oIJEMFzMqNN3Xz1HSw==
X-ME-Sender: <xms:Bs1saljrSp7mk7qc2Vw1p5p4ABiZpUtE60indWxE6MA5Q3FhEyBU3g>
    <xme:Bs1saqf6GAyquJwmY98GouY6oCpUCPdALmTT7XE8-BnueW-XHa7BuRsZrY-sZhLL0
    71t9bxQKpzUn9I3ByU6kqK0wgaPTPoLDFrC6U7kzqL28z-XRlA>
X-ME-Received: <xmr:Bs1saly_z0Ti2R2ioYZbzjjBljD6tu9JbMmznqN9gcb7hoNzzCACiHHQ7pbGe-iM2Mabw2lZcTJhboptqA>
X-ME-Proxy-Cause: dmFkZTELfHAaFlN+kIG6IssmIq8q0/JRtHYiEDamnKwtHAGTm/rIkphiM7dmck7n/tEVID
    Jll9XZRXegS5DA66U1m8pj9kUlkWW6jbmxkpZ2Vy+f9sbLWY4LPn/k9o06nVK28CzSnHlD
    lWYRxoJf+HWhSZ1zy9/rODG5OphaTJnkZfxiinHtBeukYGRaEV6rsOpAthbf9Rnwd5neaW
    b5ga7UTCgjqgAq9wYXuIHu4RL0lK64k1SgzKLwhWoz9uN8eIJVTlSs/QiafsKJeCqGBPP+
    mXVeoA/rZsAKFBE67k4yvTZ9NpiBwhCbzC9zQWp6wR2HnNM114K5oGLjvHnZO8zy7kGoVA
    hWs1HmKnirvo6badLfxFLC1ngv0vJGoRz2yU1pHhumbJcOkKOI1TtNPdhNaBkQabzrHwSs
    Y+7ylrnEBz1FMgf9G6IsR8hTGiv7XS1m50dEM7iVhvYlPUG0379fhge2f9V/z3oUvLoxr9
    ROaKaguFReJhiqZNhkD2XnlISmZ06TLF+XHEmpScoNRo1mg4BzI04MU+Oxq/K72xAlD1/c
    lRg7SLxd+kAXPrpQII8V7zbztgUBuWpkzKb8l+6UjlDsNcWEj2Tr5qCKIMZOXP0v6qIQIy
    +V+eXG639NjJ3RxuUWndaCx4R8t6V8NOngjS48abG8QAD/cuG5n/twKPLx9w
X-ME-Proxy: <xmx:Bs1sah0J_Zqx9Wm495aAHKKyq_zeBhRa8kYfGRkR0LXdWure1xaNMA>
    <xmx:Bs1sajwoT1TWg_kbaEU9yClxnpO-kipWVN0DCX0fgJ9aab9iuIojBA>
    <xmx:Bs1sauUKn1OLfclDrDHmd_7hCcA_KhPZF7HTuDRW2QMgnsxL2ZKuiA>
    <xmx:Bs1san85u3s4a8sam9gCd9BRSEWPxpnzprbbAhoOLGglgWyESU-nig>
    <xmx:B81salKYXEKXujICpl4UbPwDur3BiZlPUHWa6w3bSr8Ec7HpXLwZQlpO>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 12:27:49 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	keyrings@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: [PATCH 2/4] kexec: add CRASH_ZEROIZE to wipe secrets before kdump
Date: Fri, 31 Jul 2026 18:27:37 +0200
Message-ID: <20260731162739.158320-3-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731162739.158320-1-linux@jaseg.de>
References: <20260731162739.158320-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1fmjmyh4kx8nkcnbz9sw1foujz6ux3q5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BB0CA0012
X-HE-Tag: 1785515271-591026
X-HE-Meta: U2FsdGVkX1+pYgRO4AY7Q5W0PQy8xocK+9gxN8fSbj1xfnzWqX0HckpOgSfRX3NEn+b+fp+SgDJ/8t/GmPTcH8Bi5Uv9uRy5WPCYuwhpi5Jff/KcNHrAvw69nk4PUTHiD/xo9JjehNIVFneAu/LUfz4DLdM0N4WzzcBt1dTiYjZGPm2C2lopGtgvYv6bghK7+/I+02dG+ohcelVIhE0erXwlDK240P12wZXIj+A5fcbAjlllTuSG62xlqOGstelinCK4Yw6rDVqkCm/el0o9//ddzFr20RfOFp8F8BkE038nD+cjatjBkb0sYU0zfUsIwsHyA6cAIu3mr1pDqksPXFYjBpRHLelZ0SYLQ7BnIXBdM6UQHBinUMQDquDSciiPi02+oL596/Rc9JUHYJdVpJWvPr9Qi6F0E1+WFsUep33RzhPvcXNTvSnIKAxyD0ZiqDoZlcFwyqvTmmCkT1JSIX7lN9oX+/zKIFfE8H/3J52WBpFcchWd1vSMZ8vLeBIgXlU9CI4TuF8TsD4onn8UiplZN3msR59jTx3qjiHxfFE2ZLxA6BdBMBTFkv2nvkqtfk7zidIcpYiiUtw1gupgOLlhySWWhCiCpT0REsh5O2lzHbNEunEOKCxTLdew+TX8aTmu23l76PsQYLyredWRvSoR6eSEiH4iHzONzeeQMJ5jyS+sEHVxCmjJShLLeGhe+9chot/qk8GNNRGSKFq8hBSWvNcRNLHg3UuQ6wb+dDSETdtp6i/3pHrH3ZKUEvM8DeMG/UNqE+di8kqVoTidyWhnp0J7LbFyLyC5MRHTUJEh6MNgXdOL+x8rPIlV2tGOASkVB/neZq/Ks0vjfUv+Sg61nftdzP3z24zCjr6JNKR3rfcdynXb4x/ne7nkU4XccVMBBpmO2IjhgblZp2lvPc/nmStAusLtcYfl4SKaFOSK12HCQfKf4GRDlW+cVVZQqIlulq2i8x+Vxvz1l6+
 VAdX+TY+
 EqXuN0Nr9x6qQkdMZcvr+cBfvY8rpJLMHIhYzdmi7yBDlZoIDjZEJngr/+qXL2eqctHR5ouvCTsxWn+HCIiVbgI42uajSY5zDJQpaYArhWu5gnH4IH0pBP9BdI6EYJLn44zShD5hLZfx4XFazMq/jZEisRXLLQncpWBw+4KTjOKgo54j9f0UMwA1X/lj+sQOaAuA7UNQmxQOAKBlJ0diGa1GnEzCI62B7EH6sMR9m/DITkDAa0GeJJdsLwLKWzDCgNbzIph7uXJzVJ3X/8tTxPX4hNmV/GbcC9i5dlgYiaFY797Q+YXd0/jpiSRt7bKVzDOIn7fl8ZsWlAUng5g8HkzokO6buhWuCeomOQtq6GWnOKm4z/Y/Dp4+ytq21L3LjBEVCh08UrG7vkk0yIlTBFKsHQrVDwGC9uGBO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kdump is used to capture system memory after a panic(), any secret
keys currently in RAM end up in the dump. Add an opt-in atomic notifier
chain, crash_zeroize_notifier_list, invoked late into __crash_kexec().
Subsystems holding secrets can register a callback to scrub them.

Callbacks are run after machine_crash_shutdown() has already stopped the
other CPUs and disabled preemption. Callbacks must not wait on locks,
which will never be released.

This is a best-effort, defence-in-depth measure, not a guarantee.
Secrets in flight on the stack, in registers, in DMA buffers, or in
other places in memory are out of scope.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 include/linux/crash_core.h |  5 +++++
 kernel/Kconfig.kexec       |  8 ++++++++
 kernel/crash_core.c        | 18 ++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index bc087124cd78..5c7207c0bba1 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -5,6 +5,7 @@
 #include <linux/linkage.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/notifier.h>
 
 struct kimage;
 
@@ -34,6 +35,10 @@ static inline void arch_kexec_protect_crashkres(void) { }
 static inline void arch_kexec_unprotect_crashkres(void) { }
 #endif
 
+#ifdef CONFIG_CRASH_ZEROIZE
+extern struct atomic_notifier_head crash_zeroize_notifier_list;
+#endif
+
 #ifndef arch_crash_handle_hotplug_event
 static inline void arch_crash_handle_hotplug_event(struct kimage *image, void *arg) { }
 #endif
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 15632358bcf7..92ab0a69c8ec 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -179,4 +179,12 @@ config CRASH_MAX_MEMORY_RANGES
 	  the computation behind the value provided through the
 	  /sys/kernel/crash_elfcorehdr_size attribute.
 
+config CRASH_ZEROIZE
+	bool "Zeroize secrets on panic"
+	depends on CRASH_DUMP
+	help
+	  Wipe secrets (e.g. kernel keyring and memfd_secret pages) on crash or panic.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..d3a7763e2759 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -23,6 +23,7 @@
 #include <linux/objtool.h>
 #include <linux/delay.h>
 #include <linux/panic.h>
+#include <linux/timekeeping.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -33,6 +34,22 @@
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
+#ifdef CONFIG_CRASH_ZEROIZE
+ATOMIC_NOTIFIER_HEAD(crash_zeroize_notifier_list);
+EXPORT_SYMBOL_GPL(crash_zeroize_notifier_list);
+
+static void crash_zeroize(void)
+{
+	ktime_t zeroize_start = ktime_get();
+
+	pr_info("Wiping sensitive secrets...\n");
+	atomic_notifier_call_chain(&crash_zeroize_notifier_list, 0, NULL);
+	pr_info("Done in %lld us\n", ktime_us_delta(ktime_get(), zeroize_start));
+}
+#else
+static inline void crash_zeroize(void) { }
+#endif /* CONFIG_CRASH_ZEROIZE */
+
 /* time to wait for possible DMA to finish before starting the kdump kernel
  * when a CMA reservation is used
  */
@@ -142,6 +159,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
 			crash_cma_clear_pending_dma();
+			crash_zeroize();
 			machine_kexec(kexec_crash_image);
 		}
 		kexec_unlock();
-- 
2.53.0


