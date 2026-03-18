Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B9F0FCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BC46B011D; Wed, 18 Mar 2026 04:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3476B011F; Wed, 18 Mar 2026 04:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FF16B0120; Wed, 18 Mar 2026 04:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA846B011D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:15:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32AD61D3FD
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:15:10 +0000 (UTC)
X-FDA: 84558473580.09.A4B118F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A277C40015
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:15:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nw4Iq8vY;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773821708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA4FhAwitjbMx4fSEAXwn/fLSpojQUqHhpfXKSoM48M=;
	b=3Wih6FtqQkKlmT+52lKnBLL8jMZ6NZPaZEc65lKoZKDThc/gTM9meyQPvjg3JqpoQlxQ8G
	1vG7f48xROrt1enTCBexeVuS0l6bvSSapskJQyA0LM/nxTE5QVHJ9kpiwWPBWjjauCCMUo
	Bkka+XD4dkxsd5OfLvgB7PKZJx4EODw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nw4Iq8vY;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773821708; a=rsa-sha256;
	cv=none;
	b=0yAv+F7/v/hljKh7ioAlNDY/nM3MykcDtWCdKhAK5Thw2OTWyu3A/shuGKuFEp6DGX3QTs
	kycHDP0CPYR80OlXSAMcKt8IGBa9vDXJXwRMQr5tlsT7zC+6ZAw7IIlKj5kTv6lXdoZ5lS
	oubBwqrqX8atF68HWIcamOBPlziyRVs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFFE6600C4;
	Wed, 18 Mar 2026 08:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33813C19421;
	Wed, 18 Mar 2026 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773821707;
	bh=yqTaqO+qzEFFDEYd3nxXky9PFfRd40iUXDeJGUIdVPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nw4Iq8vYYab1bMNPqPjAgVJ4mwmMciGmr/iEwes3FeiiJhS+EzCJy2d4r7EW/uvCA
	 MfXOzHbzlRcsN9JeGJse+2M+mm2bb2QXNC0AuW/0qDmZoNyMhdp2HJgWjxJR54of0o
	 4+5+PkO5TcDrJwk2T7kF+GmN18rITr7yIjxGc5NZ6oH+heE98W6xNyYLYDtGwX1MCV
	 bfox/sfXQLKPIdAukr/Squ9VDyuDAiyaS/OmZEQS765cE0/CapPXXr1vmRtmVlzA4W
	 iK1OM/L46e1H4FgmURjcOZKe3O/m71feiDhRgxY/U8hOKm+gJaKmz4L0vtpRCnlAZC
	 xntlLjorMM19g==
Date: Wed, 18 Mar 2026 10:15:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 06/14] mm/bootmem_info: remove handling for
 !CONFIG_SPARSEMEM_VMEMMAP
Message-ID: <abpfBcnGOemxQxzL@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-7-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-7-david@kernel.org>
X-Rspamd-Queue-Id: A277C40015
X-Rspamd-Server: rspam07
X-Stat-Signature: yuui1u66efc3an841t786ehg9qrnx81u
X-Rspam-User: 
X-HE-Tag: 1773821708-820179
X-HE-Meta: U2FsdGVkX19ssb3oe5OT1GLWOzpIUPOk0KELesVDa+iciHEX+7dA4NTkOB525zemxeyVR3FLDfDRajFlCiOsuwdY0Sgs4iqTxeXPDbHM2wZFBKR/RNb+i09k+LhYIPui7ZZPZC2Q44eQHGPl0A1ZTUG11rEG7p8WUUEqNJzerjR0GIfVYRKuzpl0G/rywXt753R5oiThmR/SQY7aLFZkwRYJrbk8I7X3SCRh/vhb0EfiPgolXXmKtCA1oKPYg9nLP1qL95mNUztUeR1QfJ40anTdc6jKNuXV/HIoDsgiyJJzS6rdiYYyF2JMPvMp9Mqj4BSpgecLTiAFdUdPSpfHwRQDVOpYs5sl7mu2HtiFeuWlBE8Ym0UwldRfxUDRcuwOuCV/It0WpLRLOFILi4CZw7koTmN7q7bdfMh1jYIT2xsMuHKDHY580TDLRrfBw1ktnMAK4ZfzYyQs4d+poCDP1zSfrjgKrcBOOzPuSchh20pPoIFJNNphiQtU6M6WkD2O/tnt5qSQl+BH/41NHCpV4oVT8Eu0Nnfh4OVNuFnp0GYbL2rulID+3+BoyA6PfI/vyG10zWZ6iRYTncVN3ihBMiUkZ8n8qWzJFDO4cpPNMt5IlMsoODGHtDRWtNjacd/xH8HD7HyAVol7HL7J0eYFSWTZ/Zi3sBPX8DxPCoGAPIwEt8YBYOcG2v4v3QaBpovbfQVa2ll9F/PIsUDUHOm8d5WmCNZO9bM3j+zHtjXxnU6UW2pkw7E3b2wi4qR+nLLeqK3SaCASr0Sn4+e5JKSPZdGtl73KhtHs8/WARyFmpVJc5pjKNR3G4b0CuDBUawNZYbrj+eIltby4dOM18x0JzFkfzS9TF/brtClHrF1yA0S7TteKuazzxd1P0JCoJKWLdtQH+4xW/ovyJppfInxKqGsy9l++tYnWYNvEcEf9ouBsLfQRZgoQiUoExpsWAE5SoCP9NNFh4y2gyyoZutc
 ND/ZsGS0
 JIsf4/Y6sj5nsLzMTD3rNdwggSjbnd3kDdX8HGRQosAOfgq4YQJiHR2Kn5fwHyxAH4gJwWGV4pXzXF/hUCsEzCGeCkhwfBjahav3VZLhfMG6Z/NitNLqT3FKA2I1OpakprDt4YyXfSMu6XKnYXI8HCfQuZ2y7kTF3DaC0K3l7vqUd3KeNcPzjiIlFosAm3QF5tmE5zWVKItogb4qIpYCxpPVJ2A3K9aDHpEa9u9/3C+LFhUpEF3e0bYequk8cx7ctjDMzmp4dJi9oVz3vaJhhyfzyQYxZb71/rj/nX+p1e1GJqatprXuJ2xMDwXmkXLQKihae+xPQI0sVyTlPzNgI8PHBZxZ0E0GHwLaR15+cn9wO5Fy0mj211pe09w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:44PM +0100, David Hildenbrand (Arm) wrote:
> It is not immediately obvious that CONFIG_HAVE_BOOTMEM_INFO_NODE is

Would be nice to make it more obvious, e.g. something like the patch below.

> only selected from CONFIG_MEMORY_HOTREMOVE, which itself depends on
> CONFIG_MEMORY_HOTPLUG that ... depends on CONFIG_SPARSEMEM_VMEMMAP.
> 
> Let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/bootmem_info.c | 37 -------------------------------------
>  1 file changed, 37 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 102ddbd4298e..261abc3e1957 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1841,4 +1841,18 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
 config ARCH_HAS_CPU_ATTACK_VECTORS
 	bool
 
+#
+# Only be set on architectures that have completely implemented memory hotplug
+# feature. If you are not sure, don't touch it.
+#
+config HAVE_BOOTMEM_INFO_NODE
+	def_bool n
+
+config ARCH_ENABLE_MEMORY_HOTPLUG
+	bool
+
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	bool
+
+
 endmenu
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ad7a2fe63a2a..2d6f348d11f7 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -127,6 +127,7 @@ config PPC
 	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
+	select HAVE_BOOTMEM_INFO_NODE if MEMORY_HOTREMOVE
 	select ARCH_HAS_COPY_MC			if PPC64
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..ef2d2044f1a9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -70,6 +70,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
+	select HAVE_BOOTMEM_INFO_NODE if MEMORY_HOTREMOVE
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
 	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..a371df4f8da4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -455,19 +455,6 @@ config EXCLUSIVE_SYSTEM_RAM
 	def_bool y
 	depends on !DEVMEM || STRICT_DEVMEM
 
-#
-# Only be set on architectures that have completely implemented memory hotplug
-# feature. If you are not sure, don't touch it.
-#
-config HAVE_BOOTMEM_INFO_NODE
-	def_bool n
-
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	bool
-
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	bool
-
 # eventually, we can have this option just 'select SPARSEMEM'
 menuconfig MEMORY_HOTPLUG
 	bool "Memory hotplug"
@@ -539,7 +526,6 @@ endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
 
-- 
Sincerely yours,
Mike.

