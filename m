Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A80EC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 19:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE74A6B0176; Wed, 12 Aug 2026 15:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF556B030B; Wed, 12 Aug 2026 15:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5976B030D; Wed, 12 Aug 2026 15:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD54F6B0176
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:55:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E9188033E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:55:18 +0000 (UTC)
X-FDA: 85093671516.09.E8873D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C0CCA1C0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:55:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOGF4XxB;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786564516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sbYnK+7+pDJHMoo1674MURaCmvSFhmYBOep1ki8h/o8=;
	b=FIWZrDLYCzUcOtjgxh1Pae+GBgvacX6Tq/tlYud2TbkTWdTPvq4J2ytCqxWW+VwLWz2hB+
	jgLtUxiENitwW/vYgfQ4/RbsBxShKKLp4xIeHURBb49twxc1yTYlkEpMvhf1RWqPIxka0m
	3Fx2rGtiwD/i2Pq4WntKhldM/d/I2Gk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOGF4XxB;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786564516;
	b=bOG0QjA7XOFzOgpqWvZqCSNMfv2Y1wgNz2RJL98M0KxRcpvMZLHZvgHbufNNjbT4Iv7Hso
	1YQe56lc61KR51Nwm0/5No2ThQ9CwwUu9e6J1tWUt1+nZ27th5y6gosOVZHpAlj595QF7V
	RnspoMmNhmDt3i6HlwFJA7O54YQ8eW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DC9460A7D;
	Wed, 12 Aug 2026 19:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9B01F000E9;
	Wed, 12 Aug 2026 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786564515;
	bh=sbYnK+7+pDJHMoo1674MURaCmvSFhmYBOep1ki8h/o8=;
	h=From:To:Cc:Subject:Date;
	b=WOGF4XxB46SxBEsX7rKAtTuL2RTDHdqAIjtMsuY03eBUQbZy8hnPmeEgClElQZE1c
	 32Q5C29YNl4YoJtA/KcXzHy0uCcD1elPwMxFGZ+QLY3hczKvcnXDD0V/wuFjczVPAX
	 cv+u0XngpvWUaq8xu+oPeyTM4zGFeFu7ecP0gmFQgdq1cKtW7eC/Ex7HDNMxY/yTiI
	 yE5dHoEWubbJimhFYwWq7Au1r3BydkEnvwu4hq30Fqu3BRbOkGKqacJ5yxcAVpE8mu
	 flnmtfDg9SUp56Nlon3q/i8LD1AGFSGwxhFqF/HHSOE1tfP7xu3JEvL9oKkXiDh7vO
	 PtwSkwcpyJ32A==
From: Tejun Heo <tj@kernel.org>
To: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gabriele Monaco <gmonaco@redhat.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: Drop CONFIG_DEBUG_FORCE_WEAK_PER_CPU
Message-ID: <178656406317.2437052.7257990869957704195@slm.duckdns.org>
Date: Wed, 12 Aug 2026 09:47:43 -1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0CCA1C0002
X-Stat-Signature: db8ijdigz8g3ybxyy1cgmxuy58wsyi9r
X-Rspam-User: 
X-HE-Tag: 1786564516-188197
X-HE-Meta: U2FsdGVkX19OJAhIozXCyYugLz5c0lGGqykqh5os6KRMRzGkdS4UWAkmkjmWaGkGmlJlpnJ3SRKctGXgfHMq1ewzMCI65FLMd0vVcOcj7/l1vN60EEjfRNvw7YKh7za/OWWyFyPPzXaWW3gENWAOwCFPdwUrbJJnUghSA+A3VtdSyhT4BqizD85FFpRJZlcb/ywDwf/RAoOZnjF5G7+xpRVM2z9pYXWwxL/pt3+IodBkH+Q0jyiRAobVIyHRum9GLpeGg97I0WVcnmhuUZxQ23E27WZwswa9hziBu9HLzn/gsb5c2TsuOpzcOHQnxyVCWr3rgDTC4UfDbJjLrl0WDyV6+fl5+RFrZJANVPWgFQ/ZXglhyB0Vfimxl4DYB0zA8PVXGc6LLr7MvF+HuxdNy1rLwgnKwEVhEsZ8VbUuvqydrI7BnBdCqxQC7ii0hgH7Z8Aaf5jsIoUsBDPc2qGASP4yHbzGOPkfT1a01np52O6By1r37R5c+xxooYP74gL3pn4UgHlaN3SWXePFfqlrmJxj7WZ0lYVGD6U/lQDgQENGMFfsKXJfB15y1pUSWX366jQRNU1DJwpQjb5LFV3eZwW7BdPk3WntSg8nabO6aPRRsCcSgxLy64erTWVP+O0ea1NM6i36/OAcGk6lKTU3W7hLf4obCl7HkIZKXDfjfqbbtEMVBTBm6L790e7b7hxDq6jM4mny4mHbwpPfPH1zGigUP9u1fVEoChfaAgk5DSH5k2NVJMiwzeTrkfyw917QpHP2w9eHz8XrxDko4woqE6fgJIU0NHoA9ThiSlMixT26o8omdyetWfYyp4FPMIKBOpTBoSZIRRGu+igd11kFgXUaOOc+7l+feY3fZhF64vNZQXzMqyNbx1i8iYx5tkrpGorsU8B2K6cOFJp2sNiWBkexf+YKF5mn7+R796EBwK0vonAfjjrENjYbaUJ69fapp1ukMMTNbkI/6Hw7mmz
 4bLcSkqo
 +6pUq0j2nG3Z5rWE8hEw0b3d1sDT3NADJA+Ya6il5NiJIL6j+LwTLpx7cmB08q+js06l569MLJcfd2JNBTx7nPGXHsVAXpoqlZOkn1W+vpIzvuA+baGyNfGr1hRGYJWbpZ/1Y3t+vQPCThJkpy3+Kyx+mMy5QE+tQ/XW5HeBffNpfFbW2dUD7TanWWPCNHGKcFSicR6MyV2N00ULNVlrgMyh7ZewiMA1n/6h931Yzw8Q8dvdUxzcEfNaYu+bpEovggl9SOoIxSFTzKNWuxAvXpSIH/t2SNEq7DQz8K0bME+9QqCRcrob7hyvdcIRmsX8DivaqawSsbGuMcqsp1q6SmMH7YTHsxrhDzVI4rZvGdRrekBHPt/Q4Z0+cBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alpha requires percpu variables in modules to be defined as weak so that the
compiler generates GOT based external references for them. This puts two
extra restrictions on percpu variable definitions. The symbol must be
globally unique even when static and a static percpu variable can't be
defined inside a function. DEBUG_FORCE_WEAK_PER_CPU exists to give generic
code build coverage for these restrictions without building for alpha.

MEM_ALLOC_PROFILING defines a static percpu counter at each allocation call
site and thus can't be built with weak percpu definitions, so it depends on
!DEBUG_FORCE_WEAK_PER_CPU. As allmodconfig enables DEBUG_FORCE_WEAK_PER_CPU,
this knocks MEM_ALLOC_PROFILING out of allmodconfig build coverage.

allmodconfig coverage for MEM_ALLOC_PROFILING is worth more than build
coverage for restrictions which only matter to alpha module builds. Drop
DEBUG_FORCE_WEAK_PER_CPU. Restriction violations will now show up only on
alpha builds.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/percpu-defs.h |    7 +------
 include/rv/da_monitor.h     |    2 +-
 lib/Kconfig.debug           |   16 ----------------
 3 files changed, 2 insertions(+), 23 deletions(-)

--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -65,13 +65,8 @@
  *
  * Archs which need weak percpu definitions should set
  * CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU when necessary.
- *
- * To ensure that the generic code observes the above two
- * restrictions, if CONFIG_DEBUG_FORCE_WEAK_PER_CPU is set weak
- * definition is used for all cases.
  */
-#if (defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)) || \
-	defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
+#if defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)
 /*
  * __pcpu_scope_* dummy variable is used to enforce scope.  It
  * receives the static modifier when it's used in front of
--- a/include/rv/da_monitor.h
+++ b/include/rv/da_monitor.h
@@ -24,7 +24,7 @@
 
 /*
  * Per-cpu variables require a unique name although static in some
- * configurations (e.g. CONFIG_DEBUG_FORCE_WEAK_PER_CPU or alpha modules).
+ * configurations (e.g. alpha modules).
  */
 #define DA_MON_NAME CONCATENATE(da_mon_, MONITOR_NAME)
 
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -613,21 +613,6 @@ config BUILTIN_MODULE_RANGES
 	 It also records an anchor symbol to determine the load address of the
 	 section.
 
-config DEBUG_FORCE_WEAK_PER_CPU
-	bool "Force weak per-cpu definitions"
-	depends on DEBUG_KERNEL
-	help
-	  s390 and alpha require percpu variables in modules to be
-	  defined weak to work around addressing range issue which
-	  puts the following two restrictions on percpu variable
-	  definitions.
-
-	  1. percpu symbols must be unique whether static or not
-	  2. percpu variables can't be defined inside a function
-
-	  To ensure that generic code follows the above rules, this
-	  option forces all percpu variables to be defined as weak.
-
 config WARN_CONTEXT_ANALYSIS
 	bool "Compiler context-analysis warnings"
 	depends on CC_IS_CLANG && CLANG_VERSION >= 230000
@@ -1053,7 +1038,6 @@ config MEM_ALLOC_PROFILING
 	default n
 	depends on MMU
 	depends on PROC_FS
-	depends on !DEBUG_FORCE_WEAK_PER_CPU
 	select CODE_TAGGING
 	select PAGE_EXTENSION
 	select SLAB_OBJ_EXT

