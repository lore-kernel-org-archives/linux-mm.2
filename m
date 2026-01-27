Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7B5D2F004
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4966B0088; Tue, 27 Jan 2026 07:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1A96B00A0; Tue, 27 Jan 2026 07:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE7A6B00A2; Tue, 27 Jan 2026 07:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECE1B6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:17:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BED19160A8A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:17:08 +0000 (UTC)
X-FDA: 84377643336.18.2ADB47B
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C6E9A000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:17:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PPUTXLwM;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9S/xSrdX3PQNdvGeiuAn8WfyMx/Wvh3tfYwOBKYci1k=;
	b=QVeazx8AtraXimR2SqHCdtYwsfS5So+WEnu0Q0S7+cb65qRG+tddbpsLSG6MLycIwAiCJe
	N+Ulng24uxK9iugUd1RY0d5u3tNaJSLO5L4ghpWfSgiHM0bLLhv7vg1ceRGJfAQ54xZkPc
	ZHXgC6VSYwXPWitxKHLg82BhnN8W6Jc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PPUTXLwM;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516227; a=rsa-sha256;
	cv=none;
	b=EUwy8zpkz/yRIJdWkfnZWiZ6edk6YzC4Kk9iyaXUnMMOlv+3kkSpW5xiXnzEEWeaN/l4lL
	mSGsv7So27Y7cF1NKP8iHh7w4PYEvhDIWmXUSGjxojsnsmIc9+6TaAOgUkQiYmM5cN/N2k
	hReRA8aRjlguzDXif1jiXgSqB82UQOI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9S/xSrdX3PQNdvGeiuAn8WfyMx/Wvh3tfYwOBKYci1k=;
	b=PPUTXLwMU1duEHyeudBnwMgqeL0QFNpFSjT+IpgiJrSgmVNwexEAjm3B23aqu5g9VcrKTg
	Aaw90cmNk5t7rMZujqg3RHg4NK585jt1GbWmBoHuCc2OwJwlcNbfr9XVJ72IPkS44CiySj
	6Y7MLvU/JazKo2G7NgIk8Lrczju32XY=
From: Qi Zheng <qi.zheng@linux.dev>
To: david@kernel.org,
	andreas@gaisler.com,
	richard.weiyang@gmail.com,
	will@kernel.org,
	peterz@infradead.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linmag7@gmail.com,
	akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	sparclinux@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 8/8] mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:13:01 +0800
Message-ID: <83b034810935a9ff18e425b085e065bb0acb28f3.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pk5opioro4q57ix185pod37o6uwanrcn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C6E9A000F
X-HE-Tag: 1769516226-998370
X-HE-Meta: U2FsdGVkX1/tzwTLNPuLMpExBN5VUBL+06+y0mW60OUOAvV5MbEcNluyD1LC0We9JbCSPLoHJo18gVdRPCQlylWlOnBq3EfpA3XaXrKY+h1v8MBQoCCD7LrKCytb1dC2vrhruDmVxGAvdlUnkYdlOEpDmsyQorCeolj03aKk3GohqQzw4ItkxbRXoRtUGn/1V+Wo+RBsTQ+s53SsSd1JIZ2NFplmj34F0wMH2VFYlaS5fzRwjQKcdhFi9llfmTk1QFt8XqwHCRSD1saJFaUxcbG1xRfJdwf6hKTo0E2jJ5+pNRJKi1cDITEae+CAxZGIKYdJrj5U0A36qRE+fhqr0UBQfyls87LnfcH6MCNYJAatAKVF4wlEVdx6quPSHKDHDj45QSyt17O+4Ga5jOBALGoQRnwKdiU8wx1hHftRCnsFw0w2eIbF78KKOJQkAMD56cY8MBFDK+kzTaZ/SXzc7XI0o2B7rNCM2g3CjyTsW8I6qCgp7gdPs6xtfeZRfNMM3A1Ng734GOkO4RKjBRYnsuG6ywMGUbL0RHhC4vwH0CMFbbS5/OrxjLW/luDvig3vDkg4rap9JjmpDgbhfdK5RxX8GQIcbBOGWDN2URGG4ZgdbM93l+xlqCSqCbNrHpzZPHXhPLhwYuRHEhC+mPkR6l/YiGLdCcb+dm9a3dJJOuaunywyYuKxoQmW5Mmhw8CVXfuktbPlgjSX4ejVzWB7/gJvxPw8fX50GPnCHrGhZ0M2DT34Ywuumph6E8BVUMRaeneVtBxvyTeWvi97fMTLZt5FBnTGNOWJ1T0eLa2gywqBNupkvz2zLHR5Lh1Yi2AEjOOQiGgtd3rbS+cTgqsDtK0sxEbjBjj7aP41OVtonWTgwlpghxo5Gflc6PiFME4fhLqKtj1gQK0hv/Ti2Ne3ZVUTRRHn7mwvarqsOTSKyLf0allDLeO+5pUWLioXurw6a97WAYpWyg3sF4BUPd4
 YjHBirYu
 BRrHFA9PVa5W5uasUNU0eDx4djQhjmxdCyjJltc8kRUpd50zNl85QRR1gM7l6cY/pk+4qrgjpsicP5hnuI9UDMz+Io5bApNPlzB+LDls7mr189kvPEwp52l9ZqdUVYArRGn8AT77VOuLcS6llDDI3fzWtQoR/yDr9rBSvNOgtfF9zvCCrV8xkkSsJ+x720dg4g1IGsVk/IY7TgiuIu9viESRxhFwowqdmvETdpJJI6NcZMZpSZPCqEmFBYoVM9ITKtWISP5tN4xfv8yyLMuIDMAa0Shen74e/+4xhoUZOvsm7Mz0ocfbo7FyjRUEnrl71FFtQU7sjTphR7G8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The PT_RECLAIM can work on all architectures that support
MMU_GATHER_RCU_TABLE_FREE, except for those that have selected
HAVE_ARCH_TLB_REMOVE_TABLE,so make PT_RECLAIM depends on
MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE.

BTW, change PT_RECLAIM to be enabled by default, since nobody should want
to turn it off.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/x86/Kconfig | 1 -
 mm/Kconfig       | 9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80527299f859a..0d22da56a71b0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -331,7 +331,6 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
 	select SCHED_SMT			if SMP
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
diff --git a/mm/Kconfig b/mm/Kconfig
index 456e9eaedca39..1f3109b164d86 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1454,14 +1454,9 @@ config ARCH_HAS_USER_SHADOW_STACK
 config HAVE_ARCH_TLB_REMOVE_TABLE
 	def_bool n
 
-config ARCH_SUPPORTS_PT_RECLAIM
-	def_bool n
-
 config PT_RECLAIM
-	bool "reclaim empty user page table pages"
-	default y
-	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
-	select MMU_GATHER_RCU_TABLE_FREE
+	def_bool y
+	depends on MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
 	  and exit_mmap path.
-- 
2.20.1


