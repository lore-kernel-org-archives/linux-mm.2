Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3588EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 09:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DFA6B0005; Sun, 12 Jul 2026 05:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225136B0088; Sun, 12 Jul 2026 05:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162C86B008A; Sun, 12 Jul 2026 05:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E95EB6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:34:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B965C1811
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:34:04 +0000 (UTC)
X-FDA: 84979613208.04.D5B29F3
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 08DF220002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:34:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fRR82dfO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783848843;
	b=vf7YqgIRf/wtK6pY1w005WI/oAS1WSuZrC5kWlqKcWM+3xhUbauSBsd68gDJTxgWxOgWFv
	f5KuEZYhN1Pdn62GDT23BrDZG5tHRFbbe3R6BvP4FWTeWrZxjrNUtaEOWCyn9E6aOKnjfB
	MzHC96GlQUa66STB7ed75nWxcoP/dsw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fRR82dfO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783848843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vMx3q6WpMdIPab9rV2riWxB+G+tfX1FJkOnRzcZxCMc=;
	b=2fKmQppMXpc/FAMlFJFT7jR12vbfp8nQnWSdR6cakCFZat5zXYkQJ0F3SefRecgnnHCDzM
	9vEt16tQDMFr7jajPflFw7Efwye2gBJSQb6E8N3MtOttM4Fn5VgIXOW6n20weDkvyIH89a
	Xrgp49circeiKrCoxLIqFYd25bTCXYg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783848839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vMx3q6WpMdIPab9rV2riWxB+G+tfX1FJkOnRzcZxCMc=;
	b=fRR82dfOdn+VsVP0GrBzLtK2kEe5psEyw1vXpLDqwYqN7kw82/9Uxedj09hYh36Q8QYjQ+
	r+yybcGMmLME0O0hoihn3V6eoqpfjEex5anJ+kHhX6q1wNYwBV/R9bideOmCPsC9qKmv2d
	9frD2+PFZFe3MTsK/0bV4UPni/YNJu8=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Julian Braha <julianbraha@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm/kconfig: Drop redundant dependency wrappers
Date: Sun, 12 Jul 2026 17:33:26 +0800
Message-ID: <20260712093326.8313-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 08DF220002
X-Rspam-User: 
X-Stat-Signature: ip44fatchijk3q3jrjcpow1oibptchkf
X-Rspamd-Server: rspam03
X-HE-Tag: 1783848841-845600
X-HE-Meta: U2FsdGVkX1/0NT3+yMT/UiMxDZafzgoLzvZGvMS2Euc1h1y7PAAvOgsOiDxOUOdwVF6J0tzMvyHdf3huAeuRh6BjW6bTCkncYNdle/5evUqn/nVpX55xMmCYc7h7rG73Xm4FT+EEuOVdEQLyD+TlseUU8jBE1T/ZkKo6POZEhuZWFN+HIzM2aGyqZF4TgKF2t/w0RLRSjaUOPL7tV3vNldBDnppbF2mXnMeQLqUNAlTCPIxEfPe0VbBOeXuO1fjM2lqvUH2/TaOKT++xihARNGJHx8TiSRA338Za3bFuuPbc64rSpMUVoFjYktpFehDS8L3+H8NsrvVcXE810rWtKrOUDQ3g7+SWivfZ5BrDpzEQPUOZNpTkPqgLLJpsL3T6ItqMSPv/hgy5+DEy+hQ488qIm6l+zaMkkEPPeHB5ZnnNHzOkZklS6dUI3oubFDEk2GkgpL+cJnXSOkk+UfmTNyps2my+TlSd2tk6XffMQtSIHPeBM/40GPlnU9NqkCHk0T74PlioDaeDOlNSKwGaA3A7Nh4FT6ex0bqP2znKpoSp4LMMfO2IRtpJR6NvAcl/DAKJb5PyZ9PLwG/ZPNFLZh5YnL0wH3RV9TW5e1yhUkcEvPv7FAPj6xXcu5gu+bZVhjSQUKO0N1DAOIE98cFZTQDhu23lMfdb1dCI1os/jO4cWUM4jE4rPlQF5s9WBjqieexV/ySs/Y9aUJQeFU+Q+KN6FYQk2pTwbUu+SOPUa5BM3r8Bycgrot6ePmK6fbrcwi+uqwl6UxxqSJlPS9pEo2LBlTkguEOuQUPR8eUXcMc1e1I40nLQObS1kuQiKkDAVkN2OM4T1iN2nbLqgpG+yxeErPsJ5vB5+1dG8JinuP0wWjAnSHFd6alIQ9cEGV2hwdLRjsumliAcpu2ANATvmm+FlY2q9pubTjPBuO9DUfsnFPwNPlzGIPjd9WXBvVbCbyBr9BWgHsBAuZ1+4hh
 4d6IO1D2
 De5FvYnivXgFttk/bBveqClR6v8E5tYXRhJGNtQ4/lqHE6Poqqe1VIA/2/1oUSGWN4rqQSYN9Db4GXwJztWJPtT8tsDXUODlOP8uhv5RPdQon/QpE/dThPLwlTWWB6kKjCqMf+D4RI+SJd+GJNUDpHI7kVplGRPON9DrrlxEC4HmN4eEPEredRgEgpMCHaLZQAuxwy6ua+dwP1ZeqciTATFLYX+vsotH/vasl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Some mm Kconfig entries repeat dependencies that are already expressed by
their surrounding blocks or menus.

The zsmalloc allocator options menu already depends on ZSMALLOC, so the
outer if ZSMALLOC block does not add any extra constraint. MEMORY_HOTREMOVE
and MHP_MEMMAP_ON_MEMORY are both inside the if MEMORY_HOTPLUG block, so
their local depends on MEMORY_HOTPLUG entries are redundant.

PTE_MARKER_UFFD_WP is the only entry under if USERFAULTFD. Move the
USERFAULTFD dependency into the symbol itself and combine it with the
architecture support dependency.

This keeps the same visibility and defaults while avoiding duplicate
dependency expressions.

Suggested-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/Kconfig | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index ff29f770d10a..7d1524e5c3d5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -125,8 +125,6 @@ config ZSWAP_COMPRESSOR_DEFAULT
 config ZSMALLOC
 	tristate
 
-if ZSMALLOC
-
 menu "Zsmalloc allocator options"
 	depends on ZSMALLOC
 
@@ -161,8 +159,6 @@ config ZSMALLOC_CHAIN_SIZE
 
 endmenu
 
-endif
-
 menu "Slab allocator options"
 
 config SLUB
@@ -591,12 +587,10 @@ endchoice
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select HAVE_BOOTMEM_INFO_NODE if X86_64
-	depends on MEMORY_HOTPLUG
 	select MIGRATION
 
 config MHP_MEMMAP_ON_MEMORY
 	def_bool y
-	depends on MEMORY_HOTPLUG
 	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 
 endif # MEMORY_HOTPLUG
@@ -1391,17 +1385,15 @@ menuconfig USERFAULTFD
 	  Enable the userfaultfd() system call that allows to intercept and
 	  handle page faults in userland.
 
-if USERFAULTFD
 config PTE_MARKER_UFFD_WP
 	bool "Userfaultfd write protection support for shmem/hugetlbfs"
 	default y
-	depends on HAVE_ARCH_USERFAULTFD_WP
+	depends on USERFAULTFD && HAVE_ARCH_USERFAULTFD_WP
 
 	help
 	  Allows to create marker PTEs for userfaultfd write protection
 	  purposes.  It is required to enable userfaultfd write protection on
 	  file-backed memory types like shmem and hugetlbfs.
-endif # USERFAULTFD
 
 # multi-gen LRU {
 config LRU_GEN
-- 
2.50.1 (Apple Git-155)


