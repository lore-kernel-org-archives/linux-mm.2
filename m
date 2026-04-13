Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088F0EBFD36
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722426B0089; Mon, 13 Apr 2026 06:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8BB6B009D; Mon, 13 Apr 2026 06:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0EA6B009E; Mon, 13 Apr 2026 06:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC6A6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2210E1B51DD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:22 +0000 (UTC)
X-FDA: 84653205924.15.FB97EA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 85ED7100010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ptiEy90A;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnI/luqLStNoiJ4QCu1XUBT53fXNaUimf7vNQIMdo1o=;
	b=BrfCQwCjy13lwgYcOMbRNN8zl3eOwFZD0dRrXcwyZtG6wahoHg/geqzp+qO3UfYTuaS8WV
	GtkwyjwTVi906dYpdYwRrlPUI2w2h3Gmgoj8GDr/JKs6fJMpgqEC5vd5/uEDPtaDmtVgVq
	bM4IAbx9qJujiaIAxv6Amcma99SFZTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077240; a=rsa-sha256;
	cv=none;
	b=yFP5remJ9Xht0MJJxUn9XXQITPXHdU0lRaa/6H91KPIN2poskAXbwiHEHqgA8mmE3zzUx0
	2e73uG7Ja+Na9qHJhfhOd23cXFbcOzH/Oarg0IkF4sT30KjFuZ/GhNvL5Ma21xGdsd/TBH
	nwpaoiyMeBPVG9ZU3joKUxwoVHF543I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ptiEy90A;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BE9E6111B;
	Mon, 13 Apr 2026 10:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0CDC116C6;
	Mon, 13 Apr 2026 10:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077239;
	bh=tmm+GelxzH5APhqtu7GMS7JKHUp8PnSoAWwiNCsV7mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptiEy90AwAOhfOXWuZXo24IhG7Ft01/3nuCQ6IimufgpwPtNUmpV0Qowsw11mrxBS
	 lE0bj/24EtzatXBW6lZaX+yDTh9i8fRCiuRGZ47uesB3ICbCzQRZm4+QCOtk4vO2ft
	 7PfvdSj7Sdof4fdgeZxmBtt9Yb/DJ9jlv2fWQ2TxvofoJZbqQcOlbkzQZVmmD1Im9h
	 9oFC/Bx/6OdhOMPHAFy59BtdTVC+wOt9mjqm+lSGy0jeIUSyztC6Fftbu7nqmYX8Bb
	 xqyqOCyvkJfeEQubRxkRrwqmxMptRNuUnK4xc+ltGeSkqpT7ewrIuccl3UTbH4yTeQ
	 KfJAgenzEN/GA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/10] sh: remove SPARSEMEM related entries from Kconfig
Date: Mon, 13 Apr 2026 13:46:47 +0300
Message-ID: <20260413104649.852228-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85ED7100010
X-Stat-Signature: rxufqq1uno6gundew99wbqfaaq3u1xiu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776077240-516781
X-HE-Meta: U2FsdGVkX187ypLvweMmpd3Frgs5rCDpTiPvidobUBDOcrjWzoke9oyj+bJpY/9BKqYriYOwPx9rvLPQyrnm6zynSYC9oHwDY7bQYPbnQ5Pz5B1mTpRnD05dhP7QjRlDvaowumQvpiq+9rRdglqoXiMB7/pNZbEzl2r5YzRXK7vzMDKC8xMtV9jtVKEnEsil8p3XP1s48SdIMR1vcIfAl06Z1bbC6IvlXnI4EZcpqnpWcAKEyNJv1cFGR26mr9OTQdOwtkYOnjtJsndE6UfEk5ruinvDfUPcUnC8T4AyRFkJcBza+d5skz5LKl48zxOpsZ1zI7lUemJQjf8N8O1BS6Q8GVvlAOcaSuxqudS++XB9gQ5Ef8Kbf9M9pnL6dLFyqjcft8zIVVHhSTfj94ReIfpuF/Py/9pzyjuQoiUjPbsRC44oYhY4LxsfvgfwGETKVVTySQ1SzdG6gSxZ4EWjUbmr3i9A6hXegdCQ+KT5J/k8ZLhmh8dmAJAqujYi6LQjOCIDqwaU+aPlmEQN7j1mGbTUQRqz/dtP/rp+enCUWwfJCoZLFi0u2tCwvpNt2JlxipEQ9WTFCWDK3xGKNAFzSSGn8od7wDKmYe8OAHJLxrfQx6Lg/wP10oGVZnzA44mao34H6iQDjrvI0Uz3rx1XcUh4oPnroc5fEvgOoJLaUcmnF/7qc8crguJ4WguPpTpNXKEWEdAJWMA0XvAwtCKJu+G6GEx1R74/l0sISlbAuKwgwe85vEwmDyeCf+rh/FL7bXD+jNmUdTYEga7JUWM1FMWF7N5Un5c2OOrMqF0/h+fcWOQLW8Pq/AsfqGcPi1+Vp8xIsIqKcY0eC27uduv4hHcNwLHNJpG4+8ssvDE4OSWepqOPmW8gqt1ecX3GzRIYbo8cOAxlRlpxnhXMMQbH1NhHp0psZaaL8ENkebpoIXY/b1AKvFgccZO0r0eOlp9+OfumoJusuc/8gzTNzw9
 TsvqNdIC
 RhlpMKpJ9+EPTtZm5PzyyX36oHddUn6nxpinaeGGCzf7S5j7Mu0wr7Zfa4+FVm/nF2hKH+SkKANb6AxnayffD0I6xt+QEzVoA15bucQRcxShkUVQWU8WbNbHcMHRf89UXmV27AJcsVeQ6Tx4MyFoaDM8nXyzVjEijqq24ViDy4ftXyqDFoyg1fqy4TbsUia7ZsflyqxZbZqM2zDxhxHIWZTl/ZJxI1LiTrezFdsFGfYB8vgH7oL4UgP/VqnVKTB5AdFk2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Without NUMA support, SPARSEMEM related configuration options only create
unnecessary overhead.

Remove them.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/Kconfig    |  8 --------
 arch/sh/mm/Kconfig | 10 ----------
 2 files changed, 18 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index d5795067befa..29d55f12ad50 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -390,7 +390,6 @@ config CPU_SUBTYPE_SH7723
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -401,7 +400,6 @@ config CPU_SUBTYPE_SH7724
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -442,8 +440,6 @@ config CPU_SUBTYPE_SH7785
 	bool "Support SH7785 processor"
 	select CPU_SH4A
 	select CPU_SHX2
-	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -477,8 +473,6 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SH4AL_DSP
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 
@@ -487,8 +481,6 @@ config CPU_SUBTYPE_SH7366
 	select CPU_SH4AL_DSP
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 
 endchoice
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index 71fecbbb080e..c7d889a1a9d7 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -115,16 +115,6 @@ config VSYSCALL
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
-config ARCH_SPARSEMEM_ENABLE
-	def_bool y
-	select SPARSEMEM_STATIC
-
-config ARCH_SPARSEMEM_DEFAULT
-	def_bool y
-
-config ARCH_SELECT_MEMORY_MODEL
-	def_bool y
-
 config IOREMAP_FIXED
        def_bool y
        depends on X2TLB
-- 
2.53.0


