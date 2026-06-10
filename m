Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942DDCD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A886B0005; Wed, 10 Jun 2026 17:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B826B0088; Wed, 10 Jun 2026 17:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A2A6B008C; Wed, 10 Jun 2026 17:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D89F6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:21:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 468881A0223
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:21:17 +0000 (UTC)
X-FDA: 84865273794.23.54A19C1
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 374BD8000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:21:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTTy1enP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jkrshnmenon@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=jkrshnmenon@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781126475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lcxdh4WpQV75T4a1j56otEoiOSXpVoC9+LXovWlg34c=;
	b=ZxUs9CdPA/R0HnBjvChRszPCUQUU4kXJUELRIpZYwKk3EvIV8Ir3KZtoqU8eALfKLWV8xs
	G96q+o70VtrGE3vOQJF6PgKDAyVLp5dSOj38RZvS2hs1j1VaTDLB3MWGNgqvxs7ahXANjZ
	rGvGLHCFUxaCcDxwD3TZM3pdbwGNIiQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTTy1enP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jkrshnmenon@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=jkrshnmenon@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781126475;
	b=2wBL37iIRERBd+mGImBCs0lmMgs9m+cK/yAAtG6Q5h2Z5LdFMrvun/eX/acX9wVQ7cR+N0
	TJNL6s3ZmRGAEFRv1/iOI3r3zThW+L6eCpzOx1Xz+XbW+YTIqepAY6jnQ7AEZmdjt7pLNS
	/0uD9obMTcNbzHmEmShzLxOiZoJ9VSg=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-3074adb8fcaso1654663eec.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781126474; x=1781731274; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lcxdh4WpQV75T4a1j56otEoiOSXpVoC9+LXovWlg34c=;
        b=PTTy1enPQ58THtzfHLcNTLENz/XPEn9YhScvxOVSEy5qO6O0XHbsVEdxhw9nKgaInd
         Hirj1Qs9SxAqx7YoHG8v5Mgg0pefA4XVpInBVCHj/x9pZT2IPBOq/f9VWSk6yPYQZzdU
         q2EZ9EiRh80JhV3w6S142KLNb/Nu3pSUmha2bZAnZr0jOfyP+8PtBQpiG5GoOxiwPEST
         nl4C5PjW7l1nk89bevYJFWWEtfSBglItMgtvtWQ5fvYexf63pqFT3mBWw+dPvC0Su357
         NUvkygFizspIePu2wr5XLkmb1JIQrCto5ycND491UGMFplWP57LdT1OYt6jwfJcDSOEp
         xzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781126474; x=1781731274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lcxdh4WpQV75T4a1j56otEoiOSXpVoC9+LXovWlg34c=;
        b=GiGJn+9isc5TtTSX3IOUh+6xsWgabY7hbI7uqKtIKWFKPQIxuYst3Wx02+hsQgyDfI
         Bx6HD8WA1sX110RhzPliEbnyiC4/WX0K1BmjlhAwVma5SawZe+IBEZeTyyfNpj0FG4/M
         AeopK7M5EEtVupNVkY4f6r5L4AYPquRpVzwvvhIcwtjaZqrFMLZ00xmoSzLWT/1qPRuq
         s7oxrtx0NIkueRCAj9Rp9JfdJtcMSqNEDhvxfHqUBw+KqSa7TBG19tLYfiXbBIa0lxGL
         i0hHRwGnqGKZLWy5m3BT9RMeWI7PU7dvRivdYkzTsawnaIT8bFdpk6vGW3QVLJe1LbP2
         /Sww==
X-Forwarded-Encrypted: i=1; AFNElJ9oZgcuskby+Tp3sMtRZHWQ7gf+fPxjU6PBZzN6bh7Kn5WiaOxuiE/xCUXs+ZxeV+WQPpZ7m2IapA==@kvack.org
X-Gm-Message-State: AOJu0YwwqpX5JKclt9mZ5cdCzoYXuK0eLsMmyY7O2c3h8rK/cgcDAM7A
	//9hToduAABP+xzA1X8TvrG/dC8fiKS1xFYNk2Dk6ewxq4XKirk2agfJ
X-Gm-Gg: Acq92OGsSuB0f8nhDh3pbuxqH6zuOFy8wGooWIQk9+gLLiKCyQtIU1Zd6QryAZCpj+a
	hwAP8tiqOHNBK2xLnC3nfqKigzpvI+l65GVoHVIQkhFr83oFAonmPFuFuE8CeUIDeYaHkZVuMzK
	tIvt/w1sHrdqr7gMyTn2PHe9zdOaU6XvcT9Fv00zfeWfGAa2ZnZM5MmQ2CpTbpa6pUYS0Q6Q9WO
	R3XOxmy1gJ4J/6EUata+uL7LattDh/BdXBMChJq+7+PgUiB1Wz6I36WOfIKagjB71v/y77273ov
	gp59rfWKQmE3v3ty0v2N8UUi7dVTiuEe/ZASxDK3VBHiKKPXvh2V2iiDyAN3hL5hmnTaKnq7B9d
	xeCNpA9RPY044VbC3Qp80M4ssf22JvYdZU+WYk+9tR4aKYsoPeq2LNyE8lebLagccqx0ET/qX/9
	wgSOh0i+UGyO2UfswgzDMWD8Dr41fgVkBHmQ==
X-Received: by 2002:a05:7300:5729:b0:304:e72a:d4d9 with SMTP id 5a478bee46e88-307ff5f73f5mr630170eec.19.1781126473482;
        Wed, 10 Jun 2026 14:21:13 -0700 (PDT)
Received: from jarvis.. ([2600:8800:1b01:9700:d47:c88c:e69d:2e42])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3078c1ac378sm19472655eec.1.2026.06.10.14.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 14:21:12 -0700 (PDT)
From: Jay Vadayath <jkrshnmenon@gmail.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com,
	elver@google.com,
	jannh@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	pfalcato@suse.de,
	syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_slot_store / mtree_range_walk
Date: Wed, 10 Jun 2026 14:20:41 -0700
Message-ID: <20260610212111.561726-1-jkrshnmenon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260423093420.038ce8c6ffb45279d0a809a0@linux-foundation.org>
References: <20260423093420.038ce8c6ffb45279d0a809a0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 374BD8000F
X-Stat-Signature: o74g3h3afn8dpjj74q3h57anfpj5xn5y
X-HE-Tag: 1781126474-169520
X-HE-Meta: U2FsdGVkX1+1xUoVLa8PJZ7rWNH9c/YqpGeWUycaUmzalsH/EWV1uO4yr3ptxrkD3E1Wv1LmMLyE2Z5RHPG2c+l1MmsqHVh4gj+CCBFBMboqjU7BpAtsFyALpVHrpacrkWCxgM7/stqt5AmKeC3843kPfz3Y5D+k4ZrWesZMBLn9FERjTEhsAlxhokk7bM+fvwL8kdvwGmIZellf0qX0O9mmZD5R3iZyZh+BpSr0qpCAOlibkJfEcibXTpn+vQ0PzbRzZkXyAQzM7iZYtJSyeGfFa9IXo0nH6VvJNqyahyAAgAyXxdwMJqPIH8I2mwcEXX3GiTRvBO/2jyCBMZC1mUi6GYN14RDvs3lRheiQt3NSZ8FwQxQnpwlzruDKWsA/czOaia5wog3q7Cs86j4R+920JJd2PvduYGijAZwS/5R1c3ghOtMVRdwYk4iQYZaCoJQ6Nbb+MsOwjjPQ6ox27O0Y0TEIZburHQZoVeQTAgn/EskXnp1OCyfIzRxT9/HMYR8sPkNUASCXJezKYGUaq145U8CfU7sPJp63qRNGwldigMwa5kW28unXdImA33POuOf0ZM8EINsIRKEobchvMqc4Cj5tCY35eiqA5gRRjX8GusBojqCvrcH+V2WTkGZaP4iwzZYxwzJEEzNEQONoLnE6slSrpgNq85Ur9aboaT6tfxyMFg/oCUYGjrzkWPQu4YCnqfN3xynHQSfGzpbQcKO0hADPICMCNnbu36BZo7M0Ih8JKJc5dY4I8KYdMiN2vx8mcDvZv9F97DLfoc/UNKFkQ+vt4bWRzfzJ41hNj4SHrA8bggXGRoGGjaeNjggbTo2wNuZbHum9tcto3+Iwyo1MUTrS/c/4lEsmyt1DOeFFdiR6WCp9zU699l+XZKxs8PZ6a36r508GDvp+0NbAZ7HGjYz1zDzqeBCs3ftRHykSwEUlYVfABCxd/0Dr1UAegZRJ7X3x9YuGkq1b0I4
 Nvb/cYso
 pcwI06JHRGsAtQgvi+vPHI0ULLkFGlL1BxUW+oqubQO15TOfBn34Etkrtiq9oUGCeRMvdNRhxDe+/g2y/2sDckkm48YLinM9Tjwnw2AZM1VfKV7586/wv9m2CvUyxHJsHgF/CVZVOPnlMVeNzaO7zQMi02+hPbUjFDn1Ge3xp8VaS/LKVrCpkg//K5f2BhOw5xEpGddFkliaoSljfDoUVGePUbad5CmVr/OrzTP7wru0KapMlQ4+4ylP7Aw/zOerlh/wwqmp1f/qatBsDgiGu95S6uRx11m6onlazoKvxE7aYJeJYXJZw2RUi8DxyX+J639Q7NXGMvc8HoiUSMvReWhJTU05XMpO5BAP0fwlFHNeC26kZHeQ3pfPPecNSP+3AuptEFcaL3tSSxb6ZaexQ971h4edlwF6j8s+A2AdwTA5XHfykqYVFtr7sDuAspuXvT23ZFqD7RgoGyqjrM5RhJoNwV0lOniW49Kc0310+EY+cphHEph3R/k+thdkfVtyDInMdPIyp8GUMTjgb7UyjYlBK+bOmwViRq63cSQiIA0zrCMvxpfSViScpHTAIRQupifmXh1/rwWWXoiQhMCnwlD0TBaoMEfHDg6vNmj0dBv7LAQwmGNo09gBmse5T03wfMaqsM/N5dsnt6O4wpsjNt2H2HS+tMlEvWpmhDpZGTzUgucXEvxLRCI+ioW1bjAYE05DPqGZBPY6ytPq6taZV6/DX+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I am a security researcher and was able to independently reproduce this
data race on an x86-64 host using a KCSAN-enabled build of the affected
kernel version (3cd8b194bf3428dfa53120fee47e827a7c495815).
The crash can be reliably triggered using the provided PoC.
However, I am not aware of a method that can take advantage of this bug
to achieve a practical exploit.

Reproduction environment:
  Kernel: linux kernel commit 3cd8b194bf3428dfa53120fee47e827a7c495815
          (KCSAN-enabled)
  QEMU:   qemu-system-x86_64, TCG/KVM, 2 vCPUs, 2 GiB RAM
  Host:   x86-64, Linux

Expected KCSAN report:
[    9.814310][ T2967] BUG: KCSAN: data-race in mas_wr_slot_store / mtree_range_walk
[    9.814320][ T2967]
[    9.814323][ T2967] write to 0xffff88800c4d0f30 of 8 bytes by task 2966 on cpu 0:
[    9.814328][ T2967]  mas_wr_slot_store+0x33e/0x360
[    9.814335][ T2967]  mas_wr_store_entry+0x172/0x1d0
[    9.814343][ T2967]  mas_store_prealloc+0xc3/0x170
[    9.814351][ T2967]  commit_merge+0x247/0x450
[    9.814360][ T2967]  vma_expand+0x195/0x440
[    9.814368][ T2967]  vma_merge_new_range+0x153/0x3a0
[    9.814376][ T2967]  vma_merge_extend+0xe5/0x110
[    9.814384][ T2967]  do_mremap+0xbd8/0xc40
[    9.814394][ T2967]  __do_sys_mremap+0x99/0xd0
[    9.814403][ T2967]  do_syscall_64+0xf9/0x540
[    9.814411][ T2967]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    9.814417][ T2967]
[    9.814419][ T2967] read to 0xffff88800c4d0f30 of 8 bytes by task 2967 on cpu 1:
[    9.814424][ T2967]  mtree_range_walk+0x234/0x440
[    9.814431][ T2967]  mas_state_walk+0x5c/0x80
[    9.814437][ T2967]  mas_walk+0x75/0x190
[    9.814444][ T2967]  lock_vma_under_rcu+0x73/0x500
[    9.814450][ T2967]  madvise_do_behavior+0x29f/0x7b0
[    9.814457][ T2967]  do_madvise+0x12f/0x1b0
[    9.814463][ T2967]  __x64_sys_madvise+0x2c/0x40
[    9.814469][ T2967]  do_syscall_64+0xf9/0x540
[    9.814476][ T2967]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

The following patch was applied to scope KCSAN to the target
subsystems:
--- kcsan.patch ---
diff --git a/certs/Makefile b/certs/Makefile
index 3ee1960f9f4a..a14f4393963b 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -1,3 +1,4 @@
+KCSAN_SANITIZE := n
 # SPDX-License-Identifier: GPL-2.0
 #
 # Makefile for the linux kernel signature checking certificates.
diff --git a/io_uring/Makefile b/io_uring/Makefile
index c54e328d1410..dea4f90bec8d 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -1,3 +1,4 @@
+KCSAN_SANITIZE := n
 # SPDX-License-Identifier: GPL-2.0
 #
 # Makefile for io_uring
diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index 824f30c93252..03a0e89b52f6 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CONTEXT_ANALYSIS := y
 
-KCSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n
 
@@ -9,7 +8,7 @@ CFLAGS_REMOVE_core.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_debugfs.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_report.o = $(CC_FLAGS_FTRACE)
 
-CFLAGS_core.o := $(call cc-option,-fno-conserve-stack) \
+CFLAGS_core.o := $(call cc-option,-fno-conserve-stack) -Wno-builtin-declaration-mismatch -Wno-missing-attributes -Wno-builtin-declaration-mismatch -Wno-missing-attributes \
 	$(call cc-option,-mno-outline-atomics) \
 	-fno-stack-protector -DDISABLE_BRANCH_PROFILING
 
diff --git a/lib/Makefile b/lib/Makefile
index 72c90fca6fef..6771e3d7ed58 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -337,3 +337,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+KCSAN_SANITIZE_maple_tree.o := y
+KCSAN_SANITIZE_maple_tree.o := y
diff --git a/rust/Makefile b/rust/Makefile
index b361bfedfdf0..e19ba2714d22 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -1,3 +1,4 @@
+KCSAN_SANITIZE := n
 # SPDX-License-Identifier: GPL-2.0
 
 # Where to place rustdoc generated documentation
diff --git a/samples/Makefile b/samples/Makefile
index 07641e177bd8..9048409de6d0 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,3 +1,4 @@
+KCSAN_SANITIZE := n
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux samples code
 
diff --git a/scripts/Makefile b/scripts/Makefile
index 3434a82a119f..95bddac1d1af 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -1,3 +1,4 @@
+KCSAN_SANITIZE := n
 # SPDX-License-Identifier: GPL-2.0
 ###
 # scripts contains sources for various helper programs used throughout
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0718e39cedda..cdcff805ae16 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -96,7 +96,7 @@ endif
 #
 ifeq ($(CONFIG_KCSAN),y)
 _c_flags += $(if $(patsubst n%,, \
-	$(KCSAN_SANITIZE_$(target-stem).o)$(KCSAN_SANITIZE)$(is-kernel-object)), \
+	$(KCSAN_SANITIZE_$(target-stem).o)$(KCSAN_SANITIZE)n), \
 	$(CFLAGS_KCSAN))
 # Some uninstrumented files provide implied barriers required to avoid false
 # positives: set KCSAN_INSTRUMENT_BARRIERS for barrier instrumentation only.
diff --git a/usr/Makefile b/usr/Makefile
index e8f42478a0b7..4a519330041e 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -1,3 +1,4 @@
+KCSAN_SANITIZE := n
 # SPDX-License-Identifier: GPL-2.0
 #
 # kbuild file for usr/ - including initramfs image
--- end kcsan.patch ---

Once the patch has been applied, the following scripts can be used
to reproduce this issue locally.

--- build.sh ---
#!/usr/bin/env bash
# build.sh — Build KCSAN kernel + initramfs + PoC for maple-tree data-race reproduction
#
# Usage: ./build.sh <linux-source-tree> [kernel-config]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="${1:?Usage: $0 <linux-source-tree> [kernel-config]}"
REPO="$(cd "$REPO" && pwd)"
CONFIG_SRC="${2:-$SCRIPT_DIR/38a879f4a73497f2dfef.config}"

NPROC=$(nproc)
JOBS=$((NPROC > 16 ? NPROC / 2 : NPROC))
BUILD_DIR="/tmp/kernel-builds/kcsan"
LINK_DIR="$SCRIPT_DIR/builds/kcsan"
NORMAL_USER="vscode"

# ── Install dependencies ──────────────────────────────────────────────────────
if ! command -v busybox &>/dev/null; then
    command -v apt-get &>/dev/null \
        && sudo apt-get install -y --no-install-recommends busybox-static >/dev/null \
        || { echo "busybox not found. Install busybox-static manually." >&2; exit 1; }
fi

# ── Build PoC binary ──────────────────────────────────────────────────────────
gcc -static -O2 -Wall -Wextra -pthread "$SCRIPT_DIR/poc.c" -o "$SCRIPT_DIR/poc"

# ── Patch lib/Makefile for KCSAN symbol visibility ────────────────────────────
if ! grep -q "CFLAGS_maple_tree.o.*fno-inline" "$REPO/lib/Makefile"; then
    echo 'CFLAGS_maple_tree.o += -fno-inline' >> "$REPO/lib/Makefile"
fi

# ── Build KCSAN kernel ────────────────────────────────────────────────────────
rm -rf "$BUILD_DIR" && mkdir -p "$BUILD_DIR"
mkdir -p "$(dirname "$LINK_DIR")" && rm -rf "$LINK_DIR" && ln -sfn "$BUILD_DIR" "$LINK_DIR"

cp "$CONFIG_SRC" "$BUILD_DIR/.config"
cat >> "$BUILD_DIR/.config" <<'KCSAN_CONFIG'
CONFIG_KCSAN_EARLY_ENABLE=y
CONFIG_KCSAN_NUM_WATCHPOINTS=128
CONFIG_KCSAN_SKIP_WATCH=1000
CONFIG_KCSAN_REPORT_ONCE_IN_MS=1000
CONFIG_KCSAN_REPORT_VALUE_CHANGE_ONLY=y
# CONFIG_KCSAN_PERMISSIVE is not set
# CONFIG_KCSAN_ASSUME_PLAIN_WRITES_ATOMIC is not set
CONFIG_KCSAN_IGNORE_ATOMICS=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
KCSAN_CONFIG

make -C "$REPO" O="$BUILD_DIR" olddefconfig 2>&1 | tail -5
make -C "$REPO" O="$BUILD_DIR" -j"$JOBS" bzImage 2>&1 | tail -10

# ── Build initramfs ───────────────────────────────────────────────────────────
BUSYBOX_BIN="$(command -v busybox)"

WORKDIR="$(mktemp -d /tmp/initramfs_build.XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT
ROOT="$WORKDIR/rootfs"

mkdir -p "$ROOT"/{bin,sbin,usr/bin,usr/sbin,dev,proc,sys,tmp,run,etc} \
         "$ROOT"/home/"$NORMAL_USER"

cp "$BUSYBOX_BIN" "$ROOT/bin/busybox" && chmod +x "$ROOT/bin/busybox"
for applet in $("$BUSYBOX_BIN" --list); do
    case "$applet" in
        ifconfig|ip|route|udhcpc|modprobe|insmod|rmmod|halt|poweroff|reboot|mdev)
            [[ -e "$ROOT/sbin/$applet" ]] || ln -s /bin/busybox "$ROOT/sbin/$applet" ;;
        *) [[ -e "$ROOT/bin/$applet"  ]] || ln -s /bin/busybox "$ROOT/bin/$applet"  ;;
    esac
done

cat > "$ROOT/etc/passwd" <<EOF
root:x:0:0:root:/root:/bin/sh
$NORMAL_USER:x:1000:1000:$NORMAL_USER:/home/$NORMAL_USER:/bin/sh
EOF
printf 'root:*:19000:0:99999:7:::\n%s:*:19000:0:99999:7:::\n' "$NORMAL_USER" > "$ROOT/etc/shadow"
chmod 640 "$ROOT/etc/shadow"
printf 'root:x:0:\n%s:x:1000:\n' "$NORMAL_USER" > "$ROOT/etc/group"

cp "$SCRIPT_DIR/poc" "$ROOT/poc" && chmod +x "$ROOT/poc"

cat > "$ROOT/init" <<'INIT_SCRIPT'
#!/bin/sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
mount -t proc     proc    /proc
mount -t sysfs    sysfs   /sys
mount -t devtmpfs dev     /dev 2>/dev/null || mdev -s
mount -t tmpfs    tmpfs   /tmp
mount -t tmpfs    tmpfs   /run
mount -t debugfs  debugfs /sys/kernel/debug 2>/dev/null || true
echo 0 > /proc/sys/kernel/printk 2>/dev/null || true
[ -f /sys/kernel/debug/kcsan ] && echo on > /sys/kernel/debug/kcsan
if [ -x /poc ]; then
    cp /poc /run/poc && chmod 0755 /run/poc
    FOUND=0; i=1
    while [ $i -le 10 ]; do
        echo "[init] === poc iteration $i/10 ==="
        su vscode -s /bin/sh -c /run/poc 2>&1 || /run/poc 2>&1
        if dmesg | grep -q "mas_wr_slot_store.*mtree_range_walk\|mtree_range_walk.*mas_wr_slot_store"; then
            echo "[init] *** RACE REPRODUCED on iteration $i ***"
            FOUND=1; break
        fi
        i=$((i+1))
    done
    echo "[init] poc loop finished, FOUND=$FOUND"
    echo "=== DMESG START ==="; dmesg; echo "=== DMESG END ==="
    poweroff -f
fi
exec /bin/sh
INIT_SCRIPT
chmod +x "$ROOT/init"

( cd "$ROOT"; find . | sort | cpio -o -H newc 2>/dev/null | gzip -9 > "$BUILD_DIR/initramfs.cpio.gz" )

echo "[build.sh] Kernel:    $BUILD_DIR/arch/x86/boot/bzImage"
echo "[build.sh] Initramfs: $BUILD_DIR/initramfs.cpio.gz"
--- end build.sh ---

--- poc.sh ---
#!/usr/bin/env bash
# poc.sh — Run the KCSAN maple-tree data-race PoC built by build.sh
#
# Usage: ./poc.sh
# Prereq: ./build.sh <linux-source-tree> must have been run first.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KCSAN_BUILD="$SCRIPT_DIR/builds/kcsan"
KERNEL="$KCSAN_BUILD/arch/x86/boot/bzImage"
INITRAMFS="$KCSAN_BUILD/initramfs.cpio.gz"
LOGS_DIR="$SCRIPT_DIR/logs"

if [ ! -f "$KERNEL" ]; then
    echo "ERROR: kernel not found at $KERNEL — run ./build.sh first" >&2; exit 1
fi
if [ ! -f "$INITRAMFS" ]; then
    echo "ERROR: initramfs not found at $INITRAMFS — run ./build.sh first" >&2; exit 1
fi

rm -rf "$LOGS_DIR" && mkdir -p "$LOGS_DIR"

if [ -e /dev/kvm ]; then ACCEL="-accel kvm"; TMO=180; else ACCEL="-accel tcg,thread=multi"; TMO=1000; fi
KCSAN_ARGS="kcsan.skip_watch=15 kcsan.udelay_task=300 kcsan.udelay_interrupt=150"

MAX_ATTEMPTS=3
FOUND=0
for attempt in $(seq 1 $MAX_ATTEMPTS); do
    SERIAL_LOG="$LOGS_DIR/serial_attempt_${attempt}.log"
    echo "[poc.sh] === Attempt $attempt/$MAX_ATTEMPTS ==="
    timeout "$TMO" qemu-system-x86_64 \
        $ACCEL -m 2048 -smp 2 \
        -kernel "$KERNEL" -initrd "$INITRAMFS" \
        -append "console=ttyS0 root=/dev/ram rdinit=/init quiet loglevel=3 printk.devkmsg=off $KCSAN_ARGS" \
        -serial file:"$SERIAL_LOG" -display none -no-reboot 2>/dev/null || true
    if grep -q "mas_wr_slot_store.*mtree_range_walk\|mtree_range_walk.*mas_wr_slot_store" "$SERIAL_LOG" 2>/dev/null; then
        echo "[poc.sh] *** RACE REPRODUCED on attempt $attempt ***"
        grep -m1 -A 24 "BUG: KCSAN.*mas_wr_slot_store" "$SERIAL_LOG" | sed 's/\r//'
        FOUND=1; break
    fi
    grep -q "poc loop finished" "$SERIAL_LOG" 2>/dev/null \
        && echo "[poc.sh] PoC loop completed, race not triggered" \
        || echo "[poc.sh] WARNING: boot incomplete"
done

echo "============================================================"
[ $FOUND -eq 1 ] && echo "[poc.sh] SUCCESS" || echo "[poc.sh] NOT reproduced in $MAX_ATTEMPTS attempts"
echo "============================================================"
--- end poc.sh ---

--- poc.c ---
/*
 * poc.c - KCSAN data-race in mas_wr_slot_store / mtree_range_walk
 *          (the *exact* syzbot 38a879f4a73497f2dfef race — the genuine double-fetch)
 *
 *   Writer: mremap()-grow/shrink a VMA against a larger adjacent gap
 *           -> vma_expand() -> commit_merge() -> mas_store_prealloc()
 *           -> mas_wr_store_entry() -> mas_wr_slot_store()
 *           writes wr_mas->pivots[offset] in place (boundary shift, entry count
 *           unchanged) -- this is the reported writer.
 *   Reader: page fault -> lock_vma_under_rcu() -> mas_walk() -> mtree_range_walk()
 *           reads pivots[offset] locklessly (the double-fetched pivot).
 *
 * Why mremap (not mmap MAP_FIXED + mprotect like poc.c): the slot-store fast path
 * (mas_wr_store_type() -> wr_slot_store) is only taken when a store shifts a single
 * boundary WITHOUT changing the node's entry count, which in RCU mode additionally
 * requires wr_mas->offset_end - mas->offset == 1. Growing/shrinking a VMA into an
 * adjacent gap that *survives* (residual gap => entry count unchanged) hits exactly
 * that. MAP_FIXED/mprotect split the VMA (entry count changes) and take the
 * node-store/replace path instead, which is what poc.c trips.
 *
 * Build: gcc -static -O2 -Wall -pthread poc.c -o poc
 * Run:   ./poc (needs a KCSAN-enabled kernel; ~30s)
 */
#define _GNU_SOURCE
#include <errno.h>
#include <sched.h>
#include <signal.h>
#include <setjmp.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>
#include <pthread.h>

#define PAGE        4096UL
#define LANE_PAGES  64UL                 /* address span reserved per lane */
#define LANE_SIZE   (LANE_PAGES * PAGE)
#define NLANES      32UL                 /* independent anchor/gap lanes */
#define BASE_PAGES  2UL                  /* anchor VMA baseline size (pages) */

static atomic_int g_stop;
static atomic_int g_ready;

/* SIGSEGV/SIGBUS recovery: touching a gap (or a region the writer just shrank
 * away) faults; we still want the kernel to have run lock_vma_under_rcu first. */
static __thread sigjmp_buf tl_jmp;
static __thread volatile sig_atomic_t tl_jmp_active;

static void segv_handler(int sig, siginfo_t *si, void *uctx)
{
    (void)sig; (void)si; (void)uctx;
    if (tl_jmp_active) {
        tl_jmp_active = 0;
        siglongjmp(tl_jmp, 1);
    }
    _exit(111);
}

struct ctx {
    uint8_t *base;       /* base of the reserved arena */
    int seconds;
    int cpu;
};

static void pin_cpu(int cpu)
{
    if (cpu < 0)
        return;
    cpu_set_t set;
    CPU_ZERO(&set);
    CPU_SET(cpu, &set);
    (void)sched_setaffinity(0, sizeof(set), &set);
}

static uint64_t nsec_now(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ull + (uint64_t)ts.tv_nsec;
}

static inline uint8_t *lane_base(uint8_t *base, unsigned lane)
{
    return base + (size_t)lane * LANE_SIZE;
}

/*
 * Writer: for each lane, repeatedly mremap()-grow the small anchor into the
 * adjacent gap and then shrink it back. Each grow/shrink shifts the single
 * boundary between the anchor VMA and the surviving gap -> mas_wr_slot_store()
 * updates pivots[offset] in place.
 */
static void *writer_fn(void *arg)
{
    struct ctx *c = (struct ctx *)arg;
    pin_cpu(c->cpu);

    atomic_fetch_add(&g_ready, 1);
    while (atomic_load(&g_ready) < 2)
        sched_yield();

    uint64_t end = nsec_now() + (uint64_t)c->seconds * 1000000000ull;
    unsigned iter = 0;

    while (!atomic_load(&g_stop) && nsec_now() < end) {
        unsigned lane = iter % NLANES;
        uint8_t *a = lane_base(c->base, lane);

        /* Oscillate the anchor between BASE_PAGES and a larger size, both > 1 page
         * and both leaving a residual gap (grow_pages <= LANE_PAGES-2). The entry
         * count (anchor VMA + surviving gap) never changes and the store always
         * shifts exactly one boundary => mas_wr_store_type() picks wr_slot_store
         * every time, instead of the node-store/rebalance paths that a shrink to
         * a single page can trigger. */
        unsigned long grow_pages = 3 + (iter % (LANE_PAGES - 4)); /* 3..LANE_PAGES-2 */
        size_t big = grow_pages * PAGE;
        size_t base = BASE_PAGES * PAGE;

        /* Grow base -> big (boundary shifts right), then shrink big -> base
         * (boundary shifts left). Both are in-place pivot updates. */
        void *p = mremap(a, base, big, 0);
        if (p == MAP_FAILED) {
            iter++;
            continue;
        }
        p = mremap(a, big, base, 0);
        (void)p;

        iter++;
    }

    atomic_store(&g_stop, 1);
    return NULL;
}

/*
 * Reader: fault addresses across each lane (anchor + gap) so the lockless VMA
 * lookup (lock_vma_under_rcu -> mas_walk -> mtree_range_walk) walks the leaf
 * holding the boundary the writer is shifting, reading pivots[offset].
 */
static void *reader_fn(void *arg)
{
    struct ctx *c = (struct ctx *)arg;
    pin_cpu(c->cpu);

    atomic_fetch_add(&g_ready, 1);
    while (atomic_load(&g_ready) < 2)
        sched_yield();

    uint64_t end = nsec_now() + (uint64_t)c->seconds * 1000000000ull;
    unsigned iter = 0;

    while (!atomic_load(&g_stop) && nsec_now() < end) {
        unsigned lane = iter % NLANES;
        uint8_t *a = lane_base(c->base, lane);

        /* Drop the anchor page so the next touch faults through the lockless path. */
        madvise(a, PAGE, MADV_DONTNEED);

        /* Touch several offsets within the lane: the anchor page plus addresses
         * deeper in the (possibly grown / possibly gap) region. Each is a fault
         * that runs mtree_range_walk; gap touches segfault and are recovered. */
        for (unsigned long off = 0; off < LANE_PAGES; off += 4) {
            volatile uint8_t *q = (volatile uint8_t *)(a + off * PAGE);
            if (sigsetjmp(tl_jmp, 1) == 0) {
                tl_jmp_active = 1;
                (void)*q;                 /* read fault -> lock_vma_under_rcu */
                tl_jmp_active = 0;
            }
            if (atomic_load(&g_stop))
                break;
        }
        iter++;
    }

    atomic_store(&g_stop, 1);
    return NULL;
}

int main(void)
{
    int seconds = 30;

    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_sigaction = segv_handler;
    sa.sa_flags = SA_SIGINFO | SA_NODEFER;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGSEGV, &sa, NULL);
    sigaction(SIGBUS, &sa, NULL);

    size_t arena = NLANES * LANE_SIZE;

    /* Reserve the whole arena, then punch each lane down to a BASE_PAGES anchor
     * followed by a (LANE_PAGES-BASE_PAGES)-page gap. */
    uint8_t *base = mmap(NULL, arena, PROT_READ | PROT_WRITE,
                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (base == MAP_FAILED) {
        perror("mmap(arena)");
        return 1;
    }
    for (unsigned lane = 0; lane < NLANES; lane++) {
        uint8_t *a = lane_base(base, lane);
        /* keep [a, a+BASE_PAGES*PAGE) mapped as the anchor; unmap the rest as a gap */
        if (munmap(a + BASE_PAGES * PAGE, LANE_SIZE - BASE_PAGES * PAGE) != 0)
            perror("munmap(gap)");
    }

    fprintf(stderr, "[poc] base=%p lanes=%lu lane_size=%luKB seconds=%d\n",
            (void *)base, NLANES, LANE_SIZE / 1024, seconds);

    struct ctx cw = { .base = base, .seconds = seconds, .cpu = 0 };
    struct ctx cr = { .base = base, .seconds = seconds, .cpu = 1 };

    atomic_store(&g_stop, 0);
    atomic_store(&g_ready, 0);

    pthread_t tw, tr;
    if (pthread_create(&tw, NULL, writer_fn, &cw) != 0) {
        perror("pthread_create(writer)");
        return 1;
    }
    if (pthread_create(&tr, NULL, reader_fn, &cr) != 0) {
        perror("pthread_create(reader)");
        return 1;
    }

    pthread_join(tw, NULL);
    pthread_join(tr, NULL);

    fprintf(stderr, "[poc] done\n");
    return 0;
}
--- end poc.c ---


Thanks,
Jay Vadayath

