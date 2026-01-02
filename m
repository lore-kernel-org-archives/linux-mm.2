Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5961EFA374B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 14:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D036B0089; Fri,  2 Jan 2026 09:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9B66B008A; Fri,  2 Jan 2026 09:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5076B008C; Fri,  2 Jan 2026 09:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 464136B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 09:53:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 009B95890B
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:53:46 +0000 (UTC)
X-FDA: 84287318094.24.0DE4B7A
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0CBDA20004
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:53:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767365625; a=rsa-sha256;
	cv=none;
	b=sgwSXorem8A1Ew41bMy0lSs+6tUmPLZc9k2fXzcWekA4y4YEb0hDlo5JNTGKBkELH4icnR
	utH/QL20GzhfZAsrfAwVrozERurf3AbzVBxdUvH9Kh4RfDPDLCN2UClgYJBCvo6gragnCp
	7HtQK9UFYiZZXaJpA4fy7L2gAUIT8hY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767365625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yBZj2F93B0VknEVYf7xGk1WgByUhBAGZQZsBhmv5asg=;
	b=VQsB5MY2HaM1Ple1fA4wA3MmMekoJ2hoYDGzOHLW7S0ZpXadBlEOzfUYazMbWJjKmjR1jt
	Mfti7HvXBiTw/mPSlTnq5iH05Tkq9EYSWqLeyHZaivKWCI4rqjipzeQvVzBqYD9tAvkWQG
	caXCnUF1JVJLs3Dd0zp70/n1g+OJR1s=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3fe3cc80bc3so3889051fac.0
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 06:53:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767365624; x=1767970424;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yBZj2F93B0VknEVYf7xGk1WgByUhBAGZQZsBhmv5asg=;
        b=uXGEE/hRJrEyoUoSH5frhbC8SAVoM4lF1D6nGJlD4D9Gw3GqXNWDUZsY+WpNDr5Hj3
         LQYavYljZmpeI12RXhuwZu+DCpePbhcLgGWExHgQBV7M3hx6qNiYWNxvupJNqOj+PYtt
         cBvdHuAzmZ/WKz/xwpDLjMqwiB3eorAFm/u2C0vrTSYWodTD+Ku5Q9XUo+jInZwwpZD2
         CK21OIcFmvLIEsoSlN2/1e6viFVUgu4nQM2+6jkcDNU6umZQqQJjQZBnRXi9epuPnCwA
         VKQ7ylbWiaPoepJSUKy2o9clrJYPcI6DFI1JEWe62ZyNSVtPXAa2ExOYmUB4FGrIR6BG
         3A+g==
X-Forwarded-Encrypted: i=1; AJvYcCWK2uq99uE2LNkBfBxBXpFV+pi4uEHaD74VhWbKjdc9Y/ObjNYN9amH+uPw85cv2xUHbZcuhq2qtQ==@kvack.org
X-Gm-Message-State: AOJu0YwUzPVxXSE3o/Tu6r9+h72AADp8CtcWPlK+EcDcsWdZcr/YuhqT
	XoKPLoXsr/v+rHpQZk145YP8gnJbQB0J7wcONrg/063rpKNSUBzBzrmh
X-Gm-Gg: AY/fxX7TKPGc7nYtLsenNnJfX4ZpbDiJpMsjuH7HfBMuypkhVOyLKdEaQPb/rL9215J
	Y558y5y0xyEI00A6GwKWzPmLvFZPoZwp2aRCMjcl1lLJfRM5M8iZIU0Mnvb2+GB2MkAutOnpFEf
	bvRPD01bRHL/yQHYUaZheyWU1rblLaTd36Agowk3uLjRfvGA2dcselCAU9mNG31mAkRxi3QGz57
	vYsL2t9csaUrmQqrQffHE+dk7mY8gQ/Z/0N7EGNkqKdsdcnr3nH7H4RJ9SxRLsxQ1JBGg+S8ahC
	esPdd2gvfb6p9gI8rwazmlCNMWvDd9Ak1nvVhiKUMSNzoicBujT5Ek5uOufBOA3GlMDvtOB4k0r
	4QagqPvboH6edYr8HMQVtU/bbhIhCVFFmzAQPu5+MLN5dhfPjCLAV9dL+AJ8Wf6f4JnT5XyJ3c1
	wVIYK0LfvLdBbMNQ==
X-Google-Smtp-Source: AGHT+IFOaVirBFIVBZXp+VZPeHS4wt8YP6E5VjPc88CEkvgr+k+wnwNlOhaQTCbgaVjjYSCBS7oZqQ==
X-Received: by 2002:a05:6871:3607:b0:3f5:4172:17 with SMTP id 586e51a60fabf-3fda5481b05mr24323475fac.56.1767365623867;
        Fri, 02 Jan 2026 06:53:43 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaac145bcsm23292303fac.22.2026.01.02.06.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 06:53:43 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Date: Fri, 02 Jan 2026 06:53:23 -0800
Subject: [PATCH v2 1/2] kexec: history: track previous kernel version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
In-Reply-To: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3988; i=leitao@debian.org;
 h=from:subject:message-id; bh=wkabXvOflaMtjicTrJd388Qj/w3vpwAMxUhL5Eu01do=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpV9v1U6zJLO/ry+WPczyFJZR1wa6NiK54DUKmT
 /oKNSxUEUWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaVfb9QAKCRA1o5Of/Hh3
 bRJyD/4sYGh1GsPWiH6s8aw30fI88MqDBiSHTaYzpuOZCJMhkh1im4Uqn0+m95TXj5JEClEJV8d
 gIardAHHIJ8vnaLCm2ex+aTkT3SWIUoHp74QgDp0VtP6QHqbsp+RK+cCyNokL89rWx2/RsJfwzp
 n1Hoc5m1P4F8MJjksTjNdceX2C1zrJ8iLlzjnlUiTDQKZQng+7nJz2LhzeoXFLU9PqW0kJ5Vhtp
 epab9wfi+G4uEFf4GCU2h5xLiBBenVW/woOk6XXfMSi8QchtXwx/6qQ3LBKNZX0xHEQkOO9GUrl
 WkYdO3KVJ1x6joMJcins4nEPiantJViFgi4EW22q8TcuMTAQZZZCDdlJI2fBTm3+g1XboDOjZSh
 8bA2PBGH2BnpccZffEraNywxbyK3hROLRsxrKvcJw+vDHnLRk7pU24j/tVPwUEw/v+ca+qC4gMO
 xOQjHJc7sv6QO1+ug+/gys3oM8FU6KpKiV2yHoxrLgv1FEx1wT5VTbCX4lA6ncA20QFfwDYFgdf
 b7yptHQN0RsyLF6WC/YxU0snOsIO95kx/E54y6SRO8lJuLp15Vh8pvD+ni/uRYUSYRX3/I5W179
 JM9EXTiuctOk+dk78FPHuCWSXV5kV0wA0tmuHpnz7xgj/09oQNH7pZJ9bJC59NEi7/Wihbbx8lA
 5iKY0CP3fzn2maw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CBDA20004
X-Rspamd-Server: rspam10
X-Stat-Signature: xho7nj6938bcqbuu1fz89p3kchgchb1x
X-HE-Tag: 1767365624-327702
X-HE-Meta: U2FsdGVkX1+Ovptcnttqk7R+kDmolHKQYTZ24/ClUIxhMGrXe83fNRyU1IOY1KhK5lklfXwVBF8ceC+9jgPYqjMeZdVuSaMGkO1oyyyZ9QYxj4EcKUVFg5GvbAahdV2azR57U1Coe/oE5I7sJk29pB4ar3uUpza6cqTop7PQsO9bm1aT5ER6snrLYrLpuWHcHjMycFvnB9hQm/LMkuGXjs7MJ9t4R82AW6uMUP3JMViQIUfk49fV+mg+Fpc65vT3KrV5u++gA/M4ytk1ILHADpVVdhMNdJj1rjm/QMI8tq4wHX5KSC6IrBCXujg5S2ovjzv3Y+8+HuivYfblS5u8til1X5fHEJp5ojov66O5Rpwvwu+q5IG3DlNq5RGEg5GcMg5iYP0i0gxsBRz9JpGkBddNpD89qlAmDx4YVBP64jOFIzr7QgokIyXWdHLSFzPZk9CB2z9+fh0m9L/Ei+3F/k+r/sSH3x026yaL7n3E/6a+pu2ZtUJE6wUqXBqUmeqsSM7jzHqJp7vPz8te3k3wgtu0x8tkqGLrUPub/MfbuhJ5eeLLBJXRZAxqoYzD+DaWpOBLqCAkBLvNCKJDWfUg7XwN8vMNdKYeHUboHaeJ0RuEszQ76d7MJMBMWg49/9hfFPzqC9qRF6YzQbfgTA/UFb9wTkcC8svv5S/O4VLQxhSHgLfXW967ZJxFjRDAa82PlS8R+c8SUYmbXzpIR2Ci4xk6s+u3L+UbHb4B5ce7y99e606NxceKp+xTSZtZOeuGfLk0dCtsOd4jdu2BTe1uhS2UyRjSVHm/z+u6i4Khg0ILdGxpX8aNPTXu+ST54ldedQCQU3UEy/p1dQrUxpiBVpKyvX8A//RsDv2pQYhzL/uA372D3b9stWwKh/QLZsciuRz32BaYLCbu/HT/0LvCgywrf9Qq6aTrx3iwVSAEUJWs2JNutwmLQxFVphnh5erMAPps64p9beowSfy7O5s
 7N2NWNFr
 vsk0LeY5xY5t5Uw6mj68l1cDN5wHCannwtJwZMGFhUa5jSNlv41lm96gVl6nJKFwWV38jj0RGwAaR7rTUZHiG9rd6jkwNgt7yn7JuwSet1gNI1XyLIfIVEE5vsQHD4hxLzqu7STJZqSAxPeJZEqCXY8sc+s5CAshW3NvouW5E3ftzKrWy5ZZaMbnSWPy3ZQV0xne0S+TmqLgSqX/eBoq9inelNY27o4h/hEdVrn3GdllrGkkEyF5v80dIIxyhuOBPA12uP+f0ItPZHeaZ4YcQBfMKEz17c/1Q+Mtg+9CLeRkvjyzsQBPemM8XGXnqfEO+Rr6jH3lYhJA3vP/WCmDgmI3wl9cQNJG0Kymrsx02fw44ii7cN/YlxC1vtCtm6PlDZEaKMlLbHCoPdvUfhNnOwFAD+osiFw1ZEr5t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add CONFIG_KEXEC_HISTORY to store and display the kernel version from
the previous kexec boot.

When enabled, the current kernel's release string is saved to the
"previous-release" property in the KHO device tree before kexec. On
the next boot, if this property exists, the previous kernel version
is retrieved and printed during early boot.

This helps diagnose bugs that only manifest when kexecing from
specific kernel versions, making it easier to correlate crashes with
the kernel that initiated the kexec.

Disabled by default to avoid overhead for users who don't need this
information.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/Kconfig.kexec               | 13 +++++++++++++
 kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 15632358bcf7..b770c68a3800 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -94,6 +94,19 @@ config KEXEC_JUMP
 	  Jump between original kernel and kexeced kernel and invoke
 	  code in physical address mode via KEXEC
 
+config KEXEC_HISTORY
+	bool "Track kexec kernel history"
+	depends on KEXEC_HANDOVER
+	help
+	  When enabled, the kernel will store its release version in the
+	  KHO FDT before kexec, and the newly booted kernel will read and
+	  print this information during early boot.
+
+	  This is useful for debugging and auditing to know which kernel
+	  version performed the kexec that booted the current kernel.
+
+	  If unsure, say N.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 73da00aeaa99..06d99627bb3c 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -21,6 +21,7 @@
 #include <linux/page-isolation.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
+#include <linux/utsname.h>
 
 #include <asm/early_ioremap.h>
 
@@ -36,6 +37,7 @@
 #define KHO_FDT_COMPATIBLE "kho-v1"
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
 #define PROP_SUB_FDT "fdt"
+#define PROP_PREVIOUS_RELEASE "previous-release"
 
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
 
@@ -1253,6 +1255,9 @@ bool kho_finalized(void)
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+#ifdef CONFIG_KEXEC_HISTORY
+	char previous_release[__NEW_UTS_LEN + 1];
+#endif
 	struct kho_debugfs dbg;
 };
 
@@ -1332,6 +1337,10 @@ static __init int kho_out_fdt_setup(void)
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
 	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
 			    sizeof(empty_mem_map));
+#ifdef CONFIG_KEXEC_HISTORY
+	err |= fdt_property_string(root, PROP_PREVIOUS_RELEASE,
+				   init_uts_ns.name.release);
+#endif
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
 
@@ -1455,6 +1464,25 @@ void __init kho_memory_init(void)
 	}
 }
 
+#ifdef CONFIG_KEXEC_HISTORY
+static void __init kho_print_previous_kernel(const void *fdt)
+{
+	const char *prev_release;
+	int len;
+
+	prev_release = fdt_getprop(fdt, 0, PROP_PREVIOUS_RELEASE, &len);
+	if (!prev_release || len <= 0)
+		return;
+
+	strscpy(kho_in.previous_release, prev_release,
+		sizeof(kho_in.previous_release));
+	pr_info("This kernel was kexec'ed from kernel release: %s\n",
+		kho_in.previous_release);
+}
+#else
+static void __init kho_print_previous_kernel(const void *fdt) { }
+#endif
+
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
@@ -1527,6 +1555,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.scratch_phys = scratch_phys;
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
+	kho_print_previous_kernel(fdt);
 
 out:
 	if (fdt)

-- 
2.47.3


