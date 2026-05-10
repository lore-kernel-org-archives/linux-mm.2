Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B70CD37B9
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD7B6B009E; Sun, 10 May 2026 09:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F406B009F; Sun, 10 May 2026 09:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7001D6B00A0; Sun, 10 May 2026 09:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 556D36B009E
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28211A03D9
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:21 +0000 (UTC)
X-FDA: 84751659762.06.9AED57F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8390A40005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QtlkZWfV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGb7l1kAxv9MKBkfCqbImG36uCWauG8O8z3ALFvmsSc=;
	b=f2oAxw8SNyztaekKMazk/NJfiyiRNP9VYib7PPI1or5eZbsABPZpSP5rKTFl9yZjQJ64Rn
	7q6qMVkb5QJfe8Q2MhPM3kj4RQJonDl6vPnbFD4T8kGcmOuIQsVMbOLqtnQVYs/Kd0UvnE
	GqdLflaMR8jOQLa23b1WZz+k6lavc3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421379; a=rsa-sha256;
	cv=none;
	b=Zb+edqANJoo7nAycF677e4PLVqekFjVCzfwun/EfGD6PaBLZXgvly/822l111/1nYZ/Kly
	Ki3ov7bisZsoLw3RZwUcguEWNdPUyZUFecgAB7llixKNrVmggqCBuL7N0qhYHBeaNMqHr9
	gCyM7gK3M6n/Y4tyuqhg0jl3F6hWLBQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QtlkZWfV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE32C442CE;
	Sun, 10 May 2026 13:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46639C2BCB8;
	Sun, 10 May 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421378;
	bh=AJnDtX1NJ4+f7zL2d6aAAQhuSPiHbmuimqf/ugSMF3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtlkZWfV2M2zpY3Roc5bD1Ovu5EmRn5/cjlJxaY1+jEMkio4OOZ5MD1BI6bqiUUyJ
	 umf3xT2Cznkv6XmDamvYgZ3kAqftzhfiEOkozxhDkF5bBSt2vISedirn4gA6vaHrdj
	 DfNvXHmadpqFZMDOtqyh23mXxhJx39ymj4ugcy7YMbMSb4S5AQkHjUS2WbnHa8xIuZ
	 9vtgcVIPE2eah4akGVOU/WF7P0nL5IIlnRZbxt4muptfKZf7ZmDTGjEO3d0hDZHokk
	 Am/dYEuKMgsGbau39DH5vG46GuVBNIDAl+BcO/+7fBPWGKjASRtBYFxGOW/AFOdL7e
	 hX6xBUHSVVYkA==
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
Subject: [PATCH v2 09/10] sh: remove SPARSEMEM related entries from Kconfig
Date: Sun, 10 May 2026 16:55:45 +0300
Message-ID: <20260510135546.13554-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8390A40005
X-Rspamd-Server: rspam04
X-Stat-Signature: 6s7mf3m5g78wt4rkdympe34ix8kua6fx
X-HE-Tag: 1778421379-742018
X-HE-Meta: U2FsdGVkX1/sUYZULJK68xmGs9xh6xPUDizTLvT/p2iT3Lk0nRH5eibSWPBsoi7QftpkC6Mmz49rKQ3g5469il3QtvjE+WDewYjoMlSa9bANf81ccfujQOw3b4j0rpvC+5l8kVWPYQ1Ohw+NcM/MaA21jmDpjsNT8SSRf2352T0JzWcitOO8idtOUGibNfgl9r/KCOQUUvsNCmPT4UihdIkN/rCU14yrtDnGticPmt9PbIq0Vqr5JJXo4dloPDmzrVodLXtT3ayjzaozGDCHClB2SxeCokfbh3Vx5XKRwxnqPOauOdcH4WQMnQtzVus0ApvfRBh2LYRNeveQAMjF35jO3XDc3meN/ARGY2EPIk6HGdqOmD1r4cG/7fVA4BfLpsAK6zm/Ar8cj4ABX7HKhJlJZK9u1z7J7bc0QvdVsUMxj3t4Mk1QwpJibimWvASclbmyd+ryk6AmKbCGl1V6Df2cpx7RYMNm0/3PEw8619GT1Pn/KUWDpqClEadCzeib+6al2XLKDTyxuKhNDuf2sknx7/IW1PDCmSDrEDWue8/E01ADsO4qMa6ajxVQLPoYU93suGLN9/qEyc09zNR2Vz0ytELuwBwNFdV9YukTejxzwzZjTnAFa7zeKjGtGablBKYV/no9iuHLbDZYBgScArVPOMpKgNwJSb1/ACeQpry4ReqdbykgNWpQfTdKwMb6LGdl36AG97/3F1kye0/tWmV3dH1AqrMplTsc6kiaZ7MV1Cb8iVbs7yC/a4/GgJcM2QiKj+VPClAvGimmlB8i8QrYR+wOReUF8nk1KysTKs0jfYGtDejH1n022f/OBLw5f9BxwF3hoD+SIOjBHaohPJGjQhCHowMvq5r/LwnIVY5dHMzB/sXFU3z1iypUZPyKdCpu8CIvQewK8Tvm0VU7UMkH2DvE3pAJFAOQuecGk0EXTr+SdcKXIdmkmVGKpJocP1wivGaz7px+G7yslNe
 QGtnETAw
 28j1d/FSszkPCyWldhHF3sY+63uS3DAEZxTfFeyr5S3khL1sZyI3MV9kEFhFPMQ3iGF+XLNd7+6hG4T+vDUFzWk1qirqLQDXnHRo/TD101g80JXlQ5zOwkfS8Gn7mObh5ACOLA/ANFKfr6VRJeB9cWj/QEbls9lUAN7IaxrlmBdAO7uxZmX8stUHE2Rhz3EGtKKwD3+I7DBChovtMSZuilaSZ2MPIjGUyAEgNshReDk6qCvqkARIR6IJ2S/E/3+PZGpH5g0W++x+NdQU=
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

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/Kconfig    |  6 ------
 arch/sh/mm/Kconfig | 10 ----------
 2 files changed, 16 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index d0ba91eba71a..ec50072a6f22 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -386,7 +386,6 @@ config CPU_SUBTYPE_SH7723
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -397,7 +396,6 @@ config CPU_SUBTYPE_SH7724
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -438,7 +436,6 @@ config CPU_SUBTYPE_SH7785
 	bool "Support SH7785 processor"
 	select CPU_SH4A
 	select CPU_SHX2
-	select ARCH_SPARSEMEM_ENABLE
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -472,7 +469,6 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SH4AL_DSP
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 
@@ -481,8 +477,6 @@ config CPU_SUBTYPE_SH7366
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


