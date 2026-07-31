Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FB2C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2A06B008C; Fri, 31 Jul 2026 11:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489766B0092; Fri, 31 Jul 2026 11:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5286B0093; Fri, 31 Jul 2026 11:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFC626B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:46:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62649A1991
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:28 +0000 (UTC)
X-FDA: 85049498856.21.2FBE000
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6B86620009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=buBYFgP6;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="i AjX4Bh";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785512786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDJuTD8Vcay2+Rdlju8jd0+4JfwRzRzUz3/gOwvyzEk=;
	b=1iwvD9Cuj6USu3KFJ7QECiL+jcWIL680oQihB8plGongTn3XoJuAggvNIYJEDg0UOIV+8D
	krQRHzNMlyblUSCvns4VKZRKZjpPSHSpEtaj+mjg86RTrSpBIrV5VCUDq+ZHB97MMhVEHA
	sepKeI61UgbK/KhfM/t6onIlaDld1tA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=buBYFgP6;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="i AjX4Bh";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785512786;
	b=cD3l/2WY6iELiH0dwO1vSklKZSmN70eAFjxZ8oW0Y/yR8JZ4DHEfJphOl50GGNGQQfpGe4
	+YEOZCFx68VkcBty2lvSLJJPNoRtSgj3m8z57F5UTDu/DlWXvUBaomlRqqu+XitLqjVen9
	Jup1N5gNUE4e9dqINnYWzJh/m9cMVCw=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 458B11300113;
	Fri, 31 Jul 2026 11:46:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 31 Jul 2026 11:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785512785;
	 x=1785519985; bh=WDJuTD8Vcay2+Rdlju8jd0+4JfwRzRzUz3/gOwvyzEk=; b=
	buBYFgP6+JQ8TRSLIR82ewZArTts20O9JKEd5dmyRt0+9UOyPSIDt9uOPZDtuRBv
	RNEvca7vqe3woUFF+1c7hi0UC1+3fGY/5j7AVbbk7Zmur/wwbn1YNIxRqu1y631i
	dW/cuGsgW+Ol92eYnz2sBJ/dA1/R5oINA76/X9sYmkEM7haEdI4AAg0HyQn1QrNe
	HGzud0keDd63kin+L28kTH+xV2HgjKFc4QplYWThOBSv1K1wAbinLKtVtCk0mL88
	Mm4QGTLtFIGVkksdpkzlk8X7UpKxFgvtKq6tGofgqIrDV0n3HYC3bH02No8U0lrB
	KHVtzGiuPjikAGxPJrSfeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785512785; x=
	1785519985; bh=WDJuTD8Vcay2+Rdlju8jd0+4JfwRzRzUz3/gOwvyzEk=; b=i
	AjX4Bh+jaYkO1aD0xiJjq0YR9gRYbMHKrubsBmIrmF0SLGZjG8uap5Bzdwqn1ZOG
	doKTv1lEZsMXdWxrXlvpEnowBPPhn7L9sJKbm3Ba9G4Pddh+2eC6zTnIK1FlfjMe
	ZyLHqaBNktkLoMrq4bUOcdX/GFVBceHj2t1loog8IsisFtx/biPO4TqHWEGPWsaG
	ilSzaQovVelR95zfSWt4cetlaxO5EUtoqaH0CUBi552Tc3ppBf6R2VG6m92rN5ze
	3Erj1weyVj7uYfHjdWkS2jDb6sZwm60jd2MZr5+xzAAhH3g9qvK/6budwxvj0EpX
	r1TvjzP+Q5kUAYTBDwxLQ==
X-ME-Sender: <xms:UMNsaqBFA0PKDXmxhrDxCxZpIqNb2eR9EkgONS5o_cKz54nUOl9OgA>
    <xme:UMNsagqUFMH7sxvfDkOKLvGsg0nFRt58Po7iAmQTr8wwqdw5-fk2DtgGDOYJhuxVX
    W-1KOBjOnPc6Zd8qUm5xWHQhl35FmcOnhMNhdjdnxMXvbjRrfTzRg>
X-ME-Received: <xmr:UMNsapZQRgDsYIcNYyGM78g47FcwBia0DQdyHorGouqBkucCs7nM1IXBGmKzclvavd4Mv00baDU530PxiA>
X-ME-Proxy-Cause: dmFkZTE/BZlAVVxDq9/HeYo9P0/sW1MPOKOzDZ2zczt2A8za9TVFfqEYLK1+OkUHjXNeVE
    xlY3hzB0LLvX5gB9iYwoLGDmmqsrU5556smTDInmhhGhkvXGJPYIY9dA60V1rmC96sOsI0
    XHygQvS6a9K1hbqGvNlelDmHj9E3Ec86FFih5aSGF3F2tH8eUwQUnZN22O/3yPx1ZKBTV3
    xDZn8CjjGaejfmd2G7b5yAbKcRL7w3G3sNyGFJi3IBL1nqr+l7yrItuwDyFqrIuyqCsuPT
    nNwSp+6GfQ7Kugx/1btpxv047qEzH62cBeVY3JQwhsB2H5waeSkwx8HWbJQCRnbraO98kG
    6027MSV9lKz/fLMN11Ex9ELYwFhZ51yFdgGeT2ITTOkqKl60K1ZbfbQvqK4oEGHyj0vUTi
    zKZMFSLfBk7PlA+BR6AEltHAihXhQT8QYUcA/4PBl2LZvaiLOQoHL/yqeIdRqLs3QlHNol
    qe70HNv54SoVwt+uUt4VYC3UZ/vwLxiZt0SlDugWs9ufvM6xodf7R8nO4PqrAUQDSjr34q
    2Nq7XBKrQJMRsuGQX0qZS+NqPJIFj3+rECUZD2u2OzoKbnQVKTUKhvRCTKW/iNJqr0gVi7
    Ri5gz0+7qgZ/Gv+nBCA7tdjlhLpJZz7nNMfnlepPP1EhsaFoWq0nXwqngRiA
X-ME-Proxy: <xmx:UMNsaiGv-zu70rASap_44Sr8gmoB70bjvCoTG9Ia4LaaGCObmvkSBQ>
    <xmx:UMNsavbn67Ym8Sm16ilYb5_nKOcK-b6abG6vyyxvoZRI2yg6u93fnA>
    <xmx:UMNsane9D1mTHTmLxAskY_yTBJPKgj8eKkvom6VCn4A-LaErf3p6zA>
    <xmx:UMNsarDyDPCDFP94XmuEiLmhTqjsAH24JvQIG4W0oBSthXJn67pB5Q>
    <xmx:UcNsanMtKnGnczfB1xWhnx5ijYZszoeBSiuPKcGXQHJji8YvY-x9xJ_8>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 11:46:21 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	"devicetree@vger.kernel.org"@kvack.org,
	"linux-kernel@vger.kernel.org"@kvack.org,
	"kexec@lists.infradead.org"@kvack.org,
	"keyrings@vger.kernel.org"@kvack.org, "linux-mm@kvack.org"@kvack.org,
	"linux-security-module@vger.kernel.org"@kvack.org,
	"linux-integrity@vger.kernel.org"@kvack.org
Subject: [PATCH 2/4] kexec: add CRASH_ZEROIZE to wipe secrets before kdump
Date: Fri, 31 Jul 2026 17:46:06 +0200
Message-ID: <20260731154608.153258-3-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154608.153258-1-linux@jaseg.de>
References: <20260731154608.153258-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B86620009
X-Rspam-User: 
X-Stat-Signature: 7efzb3mfq3d7ubh3nykt8s93sa8ux7fn
X-HE-Tag: 1785512786-249314
X-HE-Meta: U2FsdGVkX1+Co2++gxjOsB8jZ5WYoRbRwFpZmYqwFMagyUblQuBgqkt0eAccIAPxPbqolGtRy4pP2FcnM+RPhLxDM4mlj7Bzwua4A5BSdoQj0d2D+b4hfkdVRhl64QaHYltqNNCVpo/VuK5HwYpJRJ98i+KXyIdbyekZWowsaUvJp9RpzbEXgH/UrAoNbJbsmFJSNdh+tZdc33Qkq3T467DuWga+aagKyYnzmUZ62CexoFex6BdM8WDR/NlHWJtbIexYfWfNc/uM4152IFVNhH4T31RxtaMI5Bdhk5oHfRDlEgW3YsPnxXlpgV+rOP6lRA1Cta3voX7DGt+GBvQIEjWywWtQ8PoHrHdn2ZkYbM0pETnBaxSC/ikhufkXVe27XqAOasWci0kgvClPNCPiYnIfw0rSxGZGrSd63Eq1fxSV0rulKPua5E7tCz9Q56biwYm9sYczB0lLSdBvg38ZBpmH2vm0vaXp5Cy4vQeRRIAx9dup+J3zW2QcTpD7hwODWretXyaWYVU5Zx5wS+iNd8SofMF1yhTPBjIvsKuiZmUVrob/6wWNE1C/vD9EQGwoNLXwm6C7lEXNHtyHqPL/nXAPhpQsXsUZsrfL06agFYFAMW+POkD9H5oz00MfodoE+OakepP7529NL6frEr4YIctgrA1I4Xn+Vm1WGGFVlNFH7OpmVNLzhM+r97jQQZYv56MQ1WY+10P/Jz7qb9HxF0aSf3mNVJZDFUImZ6MOkXAwovL+G+U+ixFb7WJP3lX3dfbAcX/+IJfUVg13ojndyOaTqXusv/4rK16A0tYM7Ew2pCN+cAjk9HFEACDbkuqOtQXuLirFT2yv+LPctK0pGElNztHOUs+4qIcRK6nxfKaqvuvgk14WI25p2QkyO7Jom1OCCCGHTM12JPe9bo0jnALKPt3KgNHl/WSfxLuH9pX4TBLnaXEuMx217IA1A6AZDdeDBuhL2TNF2fR2nIq
 0X07EEjf
 Whcs5GM4og5nds4+deUBWkfLjCDUVdgqoNx1d2gDJLUhkwWqKWP1LpDYMjdgDBknTILuGMjm6QRhG1YcllZaal6VrxPSwn4yQ008fFy1tdzNcwE3WKaiTKDBvVoAooUKTzD5tI8rvFDByfDhFEMrqfxOiVrXs7MeAPzWTq4zmrwUO4aj7kXJTPSg6uLHy2/GRgKbCmUcWXzX6J3lDh8T6RtOGGT7BzTrikZR+qUfl8X7cv4+0Wwe+AYxBKFBQr1YgXc+7ajkpHuzel3Xr5GnmaBLDYnKm+RKgQrKCsUxjUw4sYxYyU1n7HGcDUhJEASRrksg3bOnzS58f8qhqzqb+a1jHiAY5ohL5Lkvzm4T1ffzP63mddTm2DOR6KxODCstI7kjDQZmmhsRu1gLssqosEyd5hHkSCQgQU7M5RJ207DvAjRa+eomzysqOiFJk5GYHAt43jnAubQtn0P7T3m+bhN7fMBOCxc0UtDa4KLhbFaGdBJ922JT63kzUxF4MSgOAaNIrDwFZpn/hDWMLaJomM+GAdB8j+WDdL1OaNWwTIvlBcWNmKZLfg/9ME8BmdSGYazbwif9qqbKGd6jxgtpq7gl5tQ0L3mJr8tqGKKdjToVmMNPIqLcKJa3Tyqymd1sVd2Q9Sq0kv7ueuBlbYbr54n1zavCLEd/AqPN+MYrxPRvcwIAO0vSJEfTfo8k7AJodEeiuzk1c9Bdq7jCsqZbTbtuadaUBbPj6JEiVsxRTYV8Qi1Dn/PsQWhdr8TahBkYtJDQI7puUd0J3ImREc7woEZ8Sud8Z/aPQG2EBxjBV2iwsczPaapMWoPPRwR8+ORh7YbBCA1BfVS0Xq8TxFinNHr8CmYXnAmhD5JctHvEXIkGgkLB3hJ1IgZG0bwzoJwDbNLLot9ZWYxzZYCZTNYdkcar3gnrWb4tEqZzCT3alUii1KoXwDy6hop0aYBUI1rR5AguYKXdo/LbsC/eXVj/Lyf68G/9l
 RFeDkiMJ
 +tuPRaecsRTe6PyWaLLKCKAqdQNxtoM27vGEW3vBXfFDWPqibvFlKYwTsXtFj1swboax/pAXjGSRMnrk21mgNA==
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


