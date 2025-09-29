Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65DECAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C9F8E000E; Sun, 28 Sep 2025 21:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5E88E0001; Sun, 28 Sep 2025 21:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229918E000E; Sun, 28 Sep 2025 21:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC3278E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6F061DDB12
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:42 +0000 (UTC)
X-FDA: 83940490284.23.2A5B202
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id E3F9220009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gqhplMxI;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9ZBZaC3vdnAz+H8XWrjcI+m01YkVPNevX7SPwh/ro8=;
	b=GV7RIVg0cL+wqizumAexkvT37jCY9RUwBCOvnygo7NPG+xwbz1xFRJGDExQYG0qUg4X8cG
	bzjX53efCRBrZDp1QOtZLahFcjS5SbjExGk7R3Z6qqiI6LjH/yD24f0QUJgSmK7/nWdYXr
	5VW7o3DYdBoK4VASO5y3Y/MiPPlISdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107821; a=rsa-sha256;
	cv=none;
	b=k6uV5EwW9LKph+AkOS/P/aFSJ/dmWEzTpTeQNdR+DzmRFe5EBezgZQDnuyx5aJuAloScWU
	7Q5A1bOyyHfF6Xfxcc+oZoFkJ0oGq4AKafYlVhj6bMXgKmm1cbPxamhhn2nbJEiKmraRf1
	HiAElKIP4twLQgbGkpL/cVTn6QexwI4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gqhplMxI;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4dac61ed7a5so33575931cf.3
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107820; x=1759712620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9ZBZaC3vdnAz+H8XWrjcI+m01YkVPNevX7SPwh/ro8=;
        b=gqhplMxIQDFJAB22vuM/mj05c0T2aYlzhi2zD3v70rkPE0XWOloPzu/Tc+gkH0yxbD
         x56ByCyTE1xl3iPEcOsTlwMG0ax4z7Lw9aFhfCPZWhgvXNwZRdtBpFWyai0Lf6RjyZli
         SjMlN75agnfdHEvPdjTgeFuw0NjzAG64q/5WRXcYLiSjnANAPTkvDZ6bcSisd4OylO8G
         7T7wdsnVd7iYz0zhCALiWbOIqTTNMI29RE9RDzGIVaM1TIVIYI0k3VvTce5UgGR21nas
         uWcajy4cPeVBGnDQic4CTNf4Z0oNLaiemGHq8zkbnlkK6YFh1KF1HG5oKMvo+B3ay34S
         A3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107820; x=1759712620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9ZBZaC3vdnAz+H8XWrjcI+m01YkVPNevX7SPwh/ro8=;
        b=UJV9CBawCV9mtfPgeZ4njFBUK6Yy54lxW0tPagKaKbSf9gZTghuIxi5Aq84cm/W+zb
         RT5szmpgCkrvHi9qCdfLikWvevtLQvMpa/C364JVR+jb83h/0dZEd7yIQn/yWERqWBzO
         W48InPPOu7FFxlh9OUkZg675hpyfFbkj9/ps9ZVPwCQ/OMrUEdbo5NE9frhA+LuwgVO9
         VBM1nVAvNlUTjWnGGAMo4/XnPVD29MC/6YXHnbQfTwRuthNRpD4WGvqVTsd0Nveafnx0
         l/nq77vbhJRkEu+alj5E2Ti7K1XW8s6Mkw3Jxm7YhpTlxxllN/idsR3ChkRZtmFGROSM
         btqg==
X-Forwarded-Encrypted: i=1; AJvYcCXBe1+NWa1P9t+/50qLND9Nw/HF0/MtL0hHgdBhxrPnL8z73Wp51bX4jiQOAqZq1BLvQVbqmyi+Jg==@kvack.org
X-Gm-Message-State: AOJu0YwnmGJIsI86XC66+9BLZEuZsHbRK/J1xb49KjaCP3NaITYJph+K
	39ETTcNK1ul1xPo4F4JOGWmKXGBreRrPLf+C4lunXFXltmRDfN8JT7lzF6xrjJgpFoI=
X-Gm-Gg: ASbGncsEauVkoIezYi446Y1humi1BCwHiSq2e/uL3WPp21UQiDSrdSxEM1Nwbu6h0fp
	cW9QoksAh8jjcD3s2ilfw21JTEtN/TpItB4G0XrFPQxkhX3h2Ie46NiwVpiHia3OfEXISx3wdQi
	+GI4Y9jHrWr3MYa0HMoGvO5Qmkg1YH9OB/JHzU8HrqF26A9KOgnmqCmw2HXEaEG6c9pLUu1K+k/
	d8LDRWwobUXI2F8LyFPq766XUYlokQi5HKEfSKtQ1FG5CsQikxFNbSScv1CbqIHTcHCznePT1Mx
	I6alLkJQts6M86tcyaX6BDnHwWBHc2qeZYniAXI52LYhbwA6eILL0zXH4xhsSKhe03e9YxTTi0R
	FozXwK0H1Jdb3KxEIyfbtAp9q6SiRyJaOUNpsEPILDsa+2FNKaZftGZlRYn0MOECOPXAOfO8wAD
	o8U7UuXO020Q7rbxL71bqjkP6TpXeJ
X-Google-Smtp-Source: AGHT+IE10H11AdCpFcZo+kud9wUci9g/QjNXpF8kId7N/q2vHl0kUjCR57f1sJWtfpnjlo9cA3j/tg==
X-Received: by 2002:a05:622a:2609:b0:4da:155a:76fc with SMTP id d75a77b69052e-4da4744f3b0mr213359021cf.16.1759107819934;
        Sun, 28 Sep 2025 18:03:39 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:39 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 06/30] liveupdate: kho: move to kernel/liveupdate
Date: Mon, 29 Sep 2025 01:02:57 +0000
Message-ID: <20250929010321.3462457-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mzn1kaki65x7ni7gjbu5kry4aka4q8uw
X-Rspamd-Queue-Id: E3F9220009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759107820-387471
X-HE-Meta: U2FsdGVkX18dceTJqWM1Q4f+aBdjW/4VmpHpLGcENPV6lVa9U4tWrLh+I64JdeYDaO7S3rxj5gg7PReURhoUQOb20pxkjV7W0HzLxeFwMj9o/5j8DNYUDkap0exOCG6BV/2lVy3VeUyqv95sppsd8TNU3r/Zr3kbdoc/F3eCE/zcWZgNJAbMXo0Zl1VvfRhLFP6ObX0ScVgRQq7pEFMmNwCgzRd8Eh01/UHRQ6KPLieDFxuOYTZtpNn2YuMM2pP4lHrnrDFFGrMiM9/XOpCz3DKUa3oN0x+hldAFP3ljceBbAU/WpnNvEz12tqqzoZlhkGSTJyZZAQrbzqaPiu0PS3nS/8jjmM3n6dk6OvwuYTEqkAy99XMvNy0klCRV6bEJ/KagRAs4s5miU4ZNIjvCpLkVutMp0yAzebrKIyMWQh+jCQpYRsP5bVd5CItXSuFLcxVrF7IQWk+9SZCB5TYjiW/sOwfEa6QOAXCY1q9tgI6ZL+9Ibuf+HNI5EE8vNAny9D4RhMcaszCQyBNIwu18OjoIHgCpmEzrVLWYFu2a0m2FkYRUxG/vhzAHfcEmFMedzabTTq6EJqkFCG/xYvqJ5v+ijt/2x14JuB6457llDoa9O6ZsqxHvXXwVj/3C7ZEhIh6LPksmHtegKCQx6XpTok0eEhB7+ViaDva8AgUCoSSYpnUz7GfZ6sk1ez0korMhGND79RmeaK7emmaBz6ZfTk2ONJ/ivyeNYgb5tzQUeiCkzyO6qvhsnsUOjRY7ksbjDbCgecot+Uf5HObMTCsJwTXdmovwy5APQJB/GD7XzKOl4G9H5HOftZjT+4Nf4OiSYNmfkKXFbe5D6eqZNfLM+9rZgR+12PO40vAbd2PeDS+6mtpydhw0rNVH8LgI50yh5HJIJ8J+5hdV8MSXSvkHA9x0sGjevj4iByCN3yPQz8zjangYFthVs2XAQTkgRLRfBCzJt4L7OfuUe+/gOkY
 O8l8c3j8
 xgYb9Vc41Vx2V24L5fjmdNn/PdxET88J1UiuvnxfzYVNg6IdYQh7SlU5c2QPC3rS5PEUPvJwmQYGF3nTNofe3Ear5UzjMZpO2WpVRi7Y/G+cKwbMmLbWqc0BtUWu9f0c4nrawYU+eoZnckInmdvZSkhPZmMrfsu5mFdby89SGRDX9s/ph7dcDlE2m4CFsHUDogCNVe5yJUI1YmwLfe7T/gh6DrTWaLxqWeaOH/N898HZm0+MA/6kfAdpnozjfSpLfsEokJOkk/eLhfkDydry9EjuJtWDgalehL+fQ/mmFxNzLV9BlLZ6yqQoOeYfa9LtUhRFN10loLC3kc8HTZD3xPfQbnOblljdOBZ45sWs8RSMveK4asLuRGq5YM+fZxtGT4EdeUOKmZTuxm4fONiUcx3XFK17mq5gUoARKXlOngAozcy1pbdHa9nnJVmKK3wCL1jxPhIr13lRH/Cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move KHO to kernel/liveupdate/ in preparation of placing all Live Update
core kernel related files to the same place.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/core-api/kho/concepts.rst       |  2 +-
 MAINTAINERS                                   |  2 +-
 init/Kconfig                                  |  2 ++
 kernel/Kconfig.kexec                          | 25 ----------------
 kernel/Makefile                               |  3 +-
 kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
 kernel/liveupdate/Makefile                    |  4 +++
 kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
 .../{ => liveupdate}/kexec_handover_debug.c   |  0
 .../kexec_handover_internal.h                 |  0
 10 files changed, 42 insertions(+), 32 deletions(-)
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (99%)
 rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
 rename kernel/{ => liveupdate}/kexec_handover_internal.h (100%)

diff --git a/Documentation/core-api/kho/concepts.rst b/Documentation/core-api/kho/concepts.rst
index 36d5c05cfb30..d626d1dbd678 100644
--- a/Documentation/core-api/kho/concepts.rst
+++ b/Documentation/core-api/kho/concepts.rst
@@ -70,5 +70,5 @@ in the FDT. That state is called the KHO finalization phase.
 
 Public API
 ==========
-.. kernel-doc:: kernel/kexec_handover.c
+.. kernel-doc:: kernel/liveupdate/kexec_handover.c
    :export:
diff --git a/MAINTAINERS b/MAINTAINERS
index a6cbcc7fb396..e5c800ed4819 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13766,7 +13766,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
-F:	kernel/kexec_handover*
+F:	kernel/liveupdate/kexec_handover*
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
diff --git a/init/Kconfig b/init/Kconfig
index d295e79d3547..9952c112154f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2138,6 +2138,8 @@ config TRACEPOINTS
 
 source "kernel/Kconfig.kexec"
 
+source "kernel/liveupdate/Kconfig"
+
 endmenu		# General setup
 
 source "arch/Kconfig"
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index e68156d8c72b..15632358bcf7 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -94,31 +94,6 @@ config KEXEC_JUMP
 	  Jump between original kernel and kexeced kernel and invoke
 	  code in physical address mode via KEXEC
 
-config KEXEC_HANDOVER
-	bool "kexec handover"
-	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	depends on !DEFERRED_STRUCT_PAGE_INIT
-	select MEMBLOCK_KHO_SCRATCH
-	select KEXEC_FILE
-	select DEBUG_FS
-	select LIBFDT
-	select CMA
-	help
-	  Allow kexec to hand over state across kernels by generating and
-	  passing additional metadata to the target kernel. This is useful
-	  to keep data or state alive across the kexec. For this to work,
-	  both source and target kernels need to have this option enabled.
-
-config KEXEC_HANDOVER_DEBUG
-	bool "kexec handover debug interface"
-	depends on KEXEC_HANDOVER
-	depends on DEBUG_FS
-	help
-	  Allow to control kexec handover device tree via debugfs
-	  interface, i.e. finalize the state or aborting the finalization.
-	  Also, enables inspecting the KHO fdt trees with the debugfs binary
-	  blobs.
-
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
diff --git a/kernel/Makefile b/kernel/Makefile
index 9fe722305c9b..e83669841b8c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -52,6 +52,7 @@ obj-y += printk/
 obj-y += irq/
 obj-y += rcu/
 obj-y += livepatch/
+obj-y += liveupdate/
 obj-y += dma/
 obj-y += entry/
 obj-y += unwind/
@@ -82,8 +83,6 @@ obj-$(CONFIG_CRASH_DUMP_KUNIT_TEST) += crash_core_test.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
-obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
new file mode 100644
index 000000000000..eebe564b385d
--- /dev/null
+++ b/kernel/liveupdate/Kconfig
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+menu "Live Update"
+
+config KEXEC_HANDOVER
+	bool "kexec handover"
+	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
+	select MEMBLOCK_KHO_SCRATCH
+	select KEXEC_FILE
+	select DEBUG_FS
+	select LIBFDT
+	select CMA
+	help
+	  Allow kexec to hand over state across kernels by generating and
+	  passing additional metadata to the target kernel. This is useful
+	  to keep data or state alive across the kexec. For this to work,
+	  both source and target kernels need to have this option enabled.
+
+config KEXEC_HANDOVER_DEBUG
+	bool "kexec handover debug interface"
+	depends on KEXEC_HANDOVER
+	depends on DEBUG_FS
+	help
+	  Allow to control kexec handover device tree via debugfs
+	  interface, i.e. finalize the state or aborting the finalization.
+	  Also, enables inspecting the KHO fdt trees with the debugfs binary
+	  blobs.
+
+endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
new file mode 100644
index 000000000000..67c7f71b33fa
--- /dev/null
+++ b/kernel/liveupdate/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
diff --git a/kernel/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
similarity index 99%
rename from kernel/kexec_handover.c
rename to kernel/liveupdate/kexec_handover.c
index 61b31cfc75f2..71e98c44cf47 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -24,8 +24,8 @@
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
  */
-#include "../mm/internal.h"
-#include "kexec_internal.h"
+#include "../../mm/internal.h"
+#include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
@@ -1129,7 +1129,7 @@ static int __kho_finalize(void)
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	/**
+	/*
 	 * Reserve the preserved-memory-map property in the root FDT, so
 	 * that all property definitions will precede subnodes created by
 	 * KHO callers.
diff --git a/kernel/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
similarity index 100%
rename from kernel/kexec_handover_debug.c
rename to kernel/liveupdate/kexec_handover_debug.c
diff --git a/kernel/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
similarity index 100%
rename from kernel/kexec_handover_internal.h
rename to kernel/liveupdate/kexec_handover_internal.h
-- 
2.51.0.536.g15c5d4f767-goog


