Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B06ECE7AE8
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884248E0017; Fri, 14 Nov 2025 06:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B948E0002; Fri, 14 Nov 2025 06:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798A48E0017; Fri, 14 Nov 2025 06:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663DE8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:14:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2190F58780
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:14:13 +0000 (UTC)
X-FDA: 84108953586.08.AA76689
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6B168C0012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:14:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B1fHws4v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118851; a=rsa-sha256;
	cv=none;
	b=zfDG/gkp3vOprtecJqvq2X5F4agc9qq++yhGbNbpYrO2c+zCtCAC+qTANi+GRVIRiWesV3
	FfsRCd7TdCZrQ07etF4NUab+mqEWF31j7QUvyldK5jiGby+DVTCay7XtBByRHisdDngqnU
	gykTjSwzWpcih8c4KSG3qlKeZ/97V5k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B1fHws4v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MvAZBElD0X3pJk/MX8AXoxW4zTACm8dJmSYdSV26R0=;
	b=CXQfxrCsFkxML1+G8Pu5p5tIFLRp89rPHo6Ax1SbVa2S6bofaQ1wurG0cQfwZ1QTvyPXhi
	tiYaDhdLRykBSKPkHfEYGcLIZTiFpxzPAhRF4jvlZxRZnG2kEsQryHq5oVB71WNMSqR/3G
	u1n2jnBBom4oeu9UAdZz5EEfMMIWsuQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3MvAZBElD0X3pJk/MX8AXoxW4zTACm8dJmSYdSV26R0=;
	b=B1fHws4vdV9SHk7Nm4NMEkMGypQnWt5ebGnT0lkQhYxPSrPX9T5usjJtN8D6xLK5/tENRj
	6lr6jCeTav9vHkLaX2Cm/MDvr39umGBs008BSWf4p0qasklCP7V5XJNNR/0A712o57bV/X
	UdgHrzzazzIM8MjWkX4twJlrGaTbo7c=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 7/7] mm: make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE && 64BIT
Date: Fri, 14 Nov 2025 19:11:21 +0800
Message-ID: <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6B168C0012
X-Rspamd-Server: rspam07
X-Stat-Signature: e4a7c7c4jkbryaz1bpp6uaaf8pu74568
X-Rspam-User: 
X-HE-Tag: 1763118851-946192
X-HE-Meta: U2FsdGVkX193QQL1CjEaf5ygmfMwOqEkGlg1/XmU+7EgKzzNnoOo98mRXpXNrqOej5NfmCJKb4NRCTC4xzxRLfTEUrgjP5XcGYI61SsRIyRXjLank5VjBs4zERaAlSaAg7XgAsKlY/WsxyFn7Ac9u0+WrtdhvSy8MGDkPHfkwMo5Xh5AOsQbGenb1IkxEBsCHDAgLZ3craR4Ja+ePaI/8ASiXL20Bgp0vcV+E9+uAI3K337JGQsohBxJpPIeWGBSo7W3q1EU56Cy/glPdMACx1cyY98/LHrvyuoeOnzVg4V7SCryOODb4uCBAe7ti/NggrcDewAMmk7jLb1VVF92Gu3XAUIWzJaMQBmn58lpGj7K3QWAQfGJDVvtRbVeBGzNKd1SDkbkmOoVWkLajtnz+2FkGnIgmqOpocjIdr8W8mqdjpOi82JJlgaH7EIGoH50MligsQT2LZuFC3wQDhfi169+3MQzBhadKdhb0HDpc5kjo0Jyxv356YzR9Mmob4fCr8kCIVNSe/nmGYuYwDHKtsE7HbujbBdCnDyrzgUeCZy8Yguo+86uRy2puC+yquOxmAVDR0UVNqVM8/QwxXUiwvamlTfPBJ5T6/iCoIh783wtD1oHOyoe2alDZJkkv7y1X5tX6tHpVTsmriYblszHFKUH5CbPbUqRpNzuedNFYUH06CdT4VBC9O2mwC9WlAXJF7PI50wKYyLSNoEUJpfhHBK3sbc64hJyc5c3iyWN0hPlyfGvT1fxkcDxhAEVlXzY38RP1RvvHD21QZ6D6bL7JuSYzAj3qLp+eb4zCs6H1H8LHqtMhSSPvw9JNFfuL7ThDe0gJ3f/7cLlsUe6UrhpiMj/WgKs0qoFS36Z+t9o/ToZIR9f0KkYilWuPoS2OwktLL3zwYKAnF+2sp+Cq0UqXZBGGBXDp34+nW+N1xVjhcELP33PoPGXf02uiZ0DU+whAVXVIbp/yCZngIqM95L
 3tY46h41
 vtyF+paA+BSH+dO5BwrTkCC23esjTERMiKG6EiCNJYfLy6k9ste83xuvJH0OMXLEpsGjxXvhReu9AZgBp7oHhMFX8UOItYJ8hA2rPFKUl0hh8lcXq2OT/XEWo2i1azwEppun6pn9liZ31rIdKIXdL8uh7BqX/vmgpHMwsOF/WvwrQ7GV4RWEEh7EkDwd8bd4Thofgfvz6wrTcEtYhSU3RqkO1pAQ3cJVfFYKkp5nFTz7uSwA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE so that PT_RECLAIM can
be enabled by default on all architectures that support
MMU_GATHER_RCU_TABLE_FREE.

Considering that a large number of PTE page table pages (such as 100GB+)
can only be caused on a 64-bit system, let PT_RECLAIM also depend on
64BIT.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/x86/Kconfig | 1 -
 mm/Kconfig       | 6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eac2e86056902..96bff81fd4787 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -330,7 +330,6 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
 	select SCHED_SMT			if SMP
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
diff --git a/mm/Kconfig b/mm/Kconfig
index a5a90b169435d..e795fbd69e50c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1440,14 +1440,10 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
-config ARCH_SUPPORTS_PT_RECLAIM
-	def_bool n
-
 config PT_RECLAIM
 	bool "reclaim empty user page table pages"
 	default y
-	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
-	select MMU_GATHER_RCU_TABLE_FREE
+	depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
 	  and exit_mmap path.
-- 
2.20.1


