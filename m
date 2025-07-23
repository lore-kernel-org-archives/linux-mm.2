Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B2EC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234786B00FF; Wed, 23 Jul 2025 10:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6146B0100; Wed, 23 Jul 2025 10:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085376B0101; Wed, 23 Jul 2025 10:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E65436B00FF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF684C0676
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:15 +0000 (UTC)
X-FDA: 83695807230.02.E390108
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id C611C14000C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=IGy0M26o;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D29uKJn8/3Rn+J78XMEvNXa1khBLyQZ2td0gZqNttys=;
	b=kdjzcD2QiLqGqzcP+8cD9yd6ZYvFUYiNzRNo3r8aIrL3PPLpqNxMnhqD9R1bpBiVVELbqy
	VjMyvzICytmPGlOXFotvKK5UgN5rXAmTRFm27anctcHUfj9saOSWdrtBbRiC5KaC4YzUYJ
	BE77yT8bTjcEoCuV4rJ28M/7uS9N9dI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=IGy0M26o;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282033; a=rsa-sha256;
	cv=none;
	b=YgdETUAOBgXhXOuWTUwmJOW+L7hxgVGtJhvPPG9O3UyHY4oSyMy32t5N+OaSBqP7AhsQcX
	YbUPcVWVbUUMBn22Etcxdn6rduDZllY7WhuP2goTBRKhUAIVmsTTaqd2ey1c6h8npovPL4
	QFW+w+0bM6BxH2ZmiLoprr/V1vAbuoc=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-70e75f30452so44733507b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282033; x=1753886833; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D29uKJn8/3Rn+J78XMEvNXa1khBLyQZ2td0gZqNttys=;
        b=IGy0M26oLkH7LJAotDOFBDFENIUXe5vZ7YqdkjQGC1TPN3e6EuDPwn3Nt5UB7icB+R
         41Ni6QYn3nkZaIVNdX1mww9JKyRzhjv6SIIILX2x+azX2RVusu0jriGjhUNO9rmuNAsj
         ZVZ1LAmfzYc0NQvaQPh1WgwX7wB+K5N1MqH6MoDRxcv+/B9ROowLH1LwS9I0HFdbdHwQ
         NC8fCsbZ0CuU9QbHBULb0UXsWiM2kVrIYw0EAdG8WSh2EzSMxmRDHqFwjCF86o8KN05t
         IzCiBsH5AIjV0kzKTJH5Vw+yEs8+g11UE5lUM3K2nFCepRd6pYnRp/Dka8uW6mXVHhNl
         d86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282033; x=1753886833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D29uKJn8/3Rn+J78XMEvNXa1khBLyQZ2td0gZqNttys=;
        b=Jx7PDwDYyJ3O3EV0a1RkyMG63WNIlUvwNDYVvKgGHTGnwXMo4hSNFfYOXiGCBdE5bj
         mMFXFDmHUdXQq0xwlxGE0u+7lpLq0bjr5yTWhI2IReBQIyUDP3awkVZzmrYJQDNvlIyr
         fEB08wJoq1tocWo1rto02lUNMYZm7XUYO1/k2JqcOJKLYEpqGuRPN9o7kwXA0wdrwGLT
         xkk1mw6xZYXtP6v/k0Goz2mFxPuyFRlAAxQ53m4n861qVG0o07ZaxJDAuRy2rw2/U/SU
         NzraZAvrWdgqNOUqZZhXAUmQYQfifCPjb/YmXJHSTcPCuFGo+st1LZix+ic5ponYjWpq
         5t5g==
X-Forwarded-Encrypted: i=1; AJvYcCXVI10kj2cJL1tDs+i42F7jP3WeQpzDHIRzt7vutVFTTdWzb+GkYAj9h2tep8dCMnBCE8MnK7rK+A==@kvack.org
X-Gm-Message-State: AOJu0YwATWzlI4ci+ihlg2X3V/HGdSXxURVVmL5/3Q6j/GlBTxX5OCJD
	Z6fsyFIQr2mY5fGR3Flr7FzJaSA7nMX0z+GAOcS0IkjnOdAJ1XrdM0ujE4uJq31a7+M=
X-Gm-Gg: ASbGncueb6hX63IdowNhFoNivsQGyIzxDQfqSGhqeQe3Djc1JjPPEUG58vl9qqxmSR7
	RjZqPkpnV1RzF3hL2Xq1XJ8icZntYR/S5CrcXMnvBluET1lifZzI9LDcpsieP/BLVwSVyYgzBJL
	+vot/s2JS4N1tnF9pStMvzr7nFNKs+SJ81txYPI3oLVQvdwbN8japhdKhyEWYYbpyUUdIquH8iY
	Zh+Qb6LtAO9CN2x6aVAQXvGG8dLjmZdaLXyiqNI7uXqBUKinsvAgg0aMUTXe0iWlpVK6r4o46K7
	0XNNDBIklM6jI+KRhmkedn6wgH7gsMaGs83Nhx/m0CxMA2BeaENOThhd20W77rJJvb7cLEX4W6V
	4QZmnc/6Kj/W/4SXl3S0NgmoS9gVqE9XSFv/wqg33MKWGyycNaU8KmwxUtZD4pV7T+qqhx22eao
	jzdsx4QS9saaoabOz2W9Qvo9IC
X-Google-Smtp-Source: AGHT+IFeWfzg1NbPbQd0TMCJbAp/VOmnf+ZjLhYQ4sLpsf9nKFizjYFZRceoNYpmNyr1XfBgtE4QnA==
X-Received: by 2002:a05:690c:6c05:b0:70e:2d30:43d6 with SMTP id 00721157ae682-719b4371f86mr39627127b3.38.1753282032758;
        Wed, 23 Jul 2025 07:47:12 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:11 -0700 (PDT)
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
	witu@nvidia.com
Subject: [PATCH v2 09/32] liveupdate: kho: move to kernel/liveupdate
Date: Wed, 23 Jul 2025 14:46:22 +0000
Message-ID: <20250723144649.1696299-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C611C14000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 49ze1snytqfe8jdkn3yjprimumhrmjkw
X-HE-Tag: 1753282033-23851
X-HE-Meta: U2FsdGVkX1/lbFEQs780uSqs0dM9Y0QaN3QWO7UQvQS1HtqrjQVWvgdqKHfXMzNN7BAQiZep/5/cbwKLMThM3bDRF8urzMa7z7dmVkPEsL4kCcIFewIUXXIO9y1l7E3pWC5o2KzwUe4wAURbLyQ678rx7/4ma9x11wcVNs7FC32tzRm/HIGfzKgG4dK4STu5WeXtcRzsmR8oyzxrI2ZSAV3naC0OBk/muRmkkyzRqeKWDTwRs5jTIUSIByWmD5LH0pZMCrtxO5CG/8hT4/VW8WQN9GmlNPS5llB84tlub0Ie9BSSUo7Yk45ltvLF5cG1HVu1M37Q5QTnYnUw8jK6nWq7XDGqtDnjXHuXsfei6kUP3/6RgB4J75p0+bcCVHwg/9uSzpDAw6qmx01uLInLULSquiNhgZnnHKOFLhrzlYsYZidszFa01BN4HIeaR9+OO+igv6/8pU4PM6owhzDybskMwMXqo1GyqztckqFnCgyUd7rq7C2P0nKtYUuO0lCSPEJawrV2c8r4quVufwgumephDOySLaOTWFP8vb/U49XwSpUbGj6vvbZr7DI2V7m69oMWojDpbYPDAiBP81krtJtcTI7njgMpcDkQ3m8VFqe5PXmdrELGsHJSKrKJIJ8ZOseWKeAMi3gku3DVi5AWiaIyeJql/V+nYCYDYwfBRLgwnlm5aieecW2dgmgeKPHAAh4nkmsiMkLiRe5U9nG9zA/rRwDkFpP+WBW+6F+scZjHszAnNv85P0SKCRKvGPiZMVPBxOKc3hcemkQK7xIXWR7MiiTxpIew5OtrPDzLT/cDt9rHwyJ8L4Gi919rFB5hyWbPiajOddUGI3EsLD5KWpl9hHUG1v6MBTK8Qy4E78xSWktgZFuQVP0jyBqw2FCetIMt0MMIBSlsmUjQcFqixzSV6kf9iAYz9lHQcqW06Ug/B2w4ZixRRRRMGcjZfVbcSD5/dQjpC/QzQrZlIhH
 GEFuN2IF
 hTK1n1uyBCKTH9dUIPVOb06Nrb+BB2/tmgdp4WmnRrXMcgwLm/9nGbimkRYoOzLAIUR8GCALj4nN3XUHWlP/48z6TGGb7zSC4BKPi+/SAVK5ZRsivrleAP5AE8g7AnVNFGL8SBh/rdMvIWnXeqHyDLjrrwwsur+EHgiNXg5/fNVAx+4aPt3WaghZayTbcDia5t12YXapTpoIlkPJYw4u6ZG7I7Gvfp7cBYNT/Zwxd3QVCm8TIoie/D3vFu4wL4NFi1Aei0g8qxDHWTR2BZmuFgESQNWnxXAKqFpb5G2jhnBGHPTJwudCnvJJe+mAIe31v+rkw/cND6dpiXGIMKZu9EMzJl/q01xxLHlRabU4dwd+3i2YfTYm7bYkVBdxRM3NV+E+glscsph8V6EmWW0T4u8PcjF6GiqXB6e7kmgsQAH1SExfqFSoRdsRkSz7/IFX45Q8yivwb+Y+IiQ18Bk7hI+nS8XAKHHyvf5mgWa/jlFB5Y86MXnqaKdWzaEySZp9QpPOUAt/iJmE5xLyrMhbMbn7HrbtGZRr5E4hCulp8u/vlkf95UxHuns/qDQ==
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
---
 Documentation/core-api/kho/concepts.rst       |  2 +-
 MAINTAINERS                                   |  2 +-
 init/Kconfig                                  |  2 ++
 kernel/Kconfig.kexec                          | 25 ----------------
 kernel/Makefile                               |  3 +-
 kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
 kernel/liveupdate/Makefile                    |  7 +++++
 kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
 .../{ => liveupdate}/kexec_handover_debug.c   |  0
 .../kexec_handover_internal.h                 |  0
 10 files changed, 45 insertions(+), 32 deletions(-)
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
index 00de7c78de86..3b276cfeb038 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13356,7 +13356,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
-F:	kernel/kexec_handover*
+F:	kernel/liveupdate/kexec_handover*
 
 KEYS-ENCRYPTED
 M:	Mimi Zohar <zohar@linux.ibm.com>
diff --git a/init/Kconfig b/init/Kconfig
index 666783eb50ab..fb7ac0e56a87 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2083,6 +2083,8 @@ config TRACEPOINTS
 
 source "kernel/Kconfig.kexec"
 
+source "kernel/liveupdate/Kconfig"
+
 endmenu		# General setup
 
 source "arch/Kconfig"
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 9968d3d4dd17..b05f5018ed98 100644
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
index e4b4afa86a70..632f692512d7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,6 +53,7 @@ obj-y += printk/
 obj-y += irq/
 obj-y += rcu/
 obj-y += livepatch/
+obj-y += liveupdate/
 obj-y += dma/
 obj-y += entry/
 obj-$(CONFIG_MODULES) += module/
@@ -81,8 +82,6 @@ obj-$(CONFIG_CRASH_DM_CRYPT) += crash_dump_dm_crypt.o
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
index 000000000000..72cf7a8e6739
--- /dev/null
+++ b/kernel/liveupdate/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the linux kernel.
+#
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
diff --git a/kernel/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
similarity index 99%
rename from kernel/kexec_handover.c
rename to kernel/liveupdate/kexec_handover.c
index 7908886170f0..72900afbdf04 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -23,8 +23,8 @@
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
  */
-#include "../mm/internal.h"
-#include "kexec_internal.h"
+#include "../../mm/internal.h"
+#include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
@@ -825,7 +825,7 @@ static int __kho_finalize(void)
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
2.50.0.727.gbf7dc18ff4-goog


