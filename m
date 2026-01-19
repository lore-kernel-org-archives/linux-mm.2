Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55CABD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B206B02CB; Mon, 19 Jan 2026 18:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8066B0335; Mon, 19 Jan 2026 18:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5EC6B0336; Mon, 19 Jan 2026 18:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 897E96B0334
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:04:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2725113A8A6
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:24 +0000 (UTC)
X-FDA: 84350244048.23.6926D12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 899F840005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gur98Nh0;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YL5Yp3bmPDaN/o5VCxRQgT5jiyEB0sYSiNPeEfZnNLs=;
	b=y/mXR2eQliZk8zHI0BaluDwNGYT2MzlEwlHudncMyBxf8qsaKbpsR7ss3WO3Roj23grr8/
	xwa2VuHmHkHjF2jSnTpPnr0UL9uBeSY4NPnjDFSU+M9Ps0A9B+GgeQb503Tr+zgNzD+NTs
	cA+HpZWN5y06Itd3bQFleZo0JhwAolg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gur98Nh0;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863862; a=rsa-sha256;
	cv=none;
	b=EikyXmAG8sB3cfB3NE9TOlJz1+LMpbV1SgTGm7bhL6LU27DSqRlqVVfQpsXAksjHGPSTkI
	5ZiX8+9ovUdtoTEaYNUBz+7EENNQmUiqe8rJNkhwJ2RaqJ4GXGetnat7jg2vPrLz5gUbKM
	wmitjSQB+3EH+XCzV22NaM7cOUthzfY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B3DC600CB;
	Mon, 19 Jan 2026 23:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C54FC116C6;
	Mon, 19 Jan 2026 23:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863861;
	bh=bBab6NBDRM1JzpiE2e7pM9KwdFDytuAM5t2vCrPDoaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gur98Nh0ZRVpYfJcb6gHUUpn6bxCBetvsDOZtfvPoVcwEo8KJ5clVB54eAiPH/Iai
	 heYJBC6atNIA0y1z7PIzaecoSG2s3xEJzDZhMXVrPIqwRl9NKhfXGO5qyek6NOd4uG
	 DUN0ewf2L0U6Rl3E9Nsx1uLhmL6eMgG5sNvexfLMmHYNMM8aV4XigKa1MpIyPfbGLI
	 GlnWYx+NZnQXcxFVmFUqx5dXbO37NlrV5zRYL3FQ2HVuEwNv+jR5y1Dy3TcE7HF1vu
	 MznI38e3Yz0CTVvnDhPa0UHMuVJr+pjhB8XC+kBMS2/qDZKl290mgjcKyNJCzh5URn
	 RSFOLhHJE/ssw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 23/24] mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
Date: Tue, 20 Jan 2026 00:01:31 +0100
Message-ID: <20260119230133.3551867-24-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 899F840005
X-Stat-Signature: 157bbhkxd49fak1ewr5rti9u1u1rfsso
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768863862-125248
X-HE-Meta: U2FsdGVkX1/0DC2HvzcPfFD3twqTOErMDnFGFxhn4McTjfzEgCiEM1djqsT9JDAQGei2Mp6ffsSlknEhCfx7nM5A0aRIQvLD4INRktBARiDU2nB3l79vBIoei9cVCm0SX2XV1bMj19lQcbvIfkn/Gui7WpugEDXu4YlCN24k0Rot/jA1rh8eIOduDuMaNKz2E28d6qmmLDUnNhF9aVd/Tl+3KVoZcUpnE0Ad/KPt6gOR+hP8gkot8G8iMZBfdF3pV4u19v/5ijSHfNFQwWBCsJ2OAd0nYi8WMewoh0+wr2Se1RlFdV935+WFHx6NYh6J1dDJE4zXgrFi5EtxCoWIViJL6Zo8wpYsk3kL8xb+ikI1fxJ4/tPCpTMjuu/D2xF5et/qnYh/KVHmER8SEGE13H6RlKBCzREgHk8e4cTMUEp73TEyTCOv9exh/X6BS5ofHYwnkPGgH1bGFAG5Oo4QutKnAQF1X904fokKI8idZOXQQ1CfG9IBhPYaycsToeZcr5AZ8v2MjC6BGakwWJKwHL+6JTRL3I8lifJPWq0wFaGAwbMl8fR8YgtdeoAMc+yrBzPl4d3jlIN3nD5qXLbSTdXXSY1u2zMbufuokUVaNhswoK68lXZ91FrxNJX1p7Yr8NtL/iFcSAh7cj0/WMfjF+RNoWICz61eqmWhED/178btcCnFWCnIx8u+G4z0zyGv1fpxlgclNDKhgVZzrWwl+JJEzLKKrmw7vRHwvQlnSwY/ONkRhCyNlvDn3REsi/3olo0I1JfGUyTE4vsWGAYidffpZzZEmq8x/xfOS1uuci/BCN+PdIPQF8f9ZPyLas8uiM9p0i06parh5Pz+wVhzunlCNM6rT6w59kP5uE/wc6oP0I09Fzh9ryvK4htnygaYB/a4T7Y8BB5OUN4bLjIzQAuhrq4SCxzFEomXk4WTBt2udomY3qZ84NiYFBAhIU5EJkreBjmNih4ynUvnEb1
 vycc1v7Y
 +WYFW9DFxllIDkLtn7kPWSQblAJYsoaTv8d6g67n5e3QxQV+8c+jukr0McBn3zOAu9a47Q1IPru47wQQZeXfys3UnkvYwkzR3uyyafq6mmQrUN0RNZ063oU3ttqhfJBDm5T3inwwmCAbcu8BR9uH9ilw2yzE+AA40+w0qHO9P7GIT3N3ZiKuJi1aIoaGAiwpIpUhx/CDvwQJqa4ZxpY1aSXKI+7Yvzm/ZJKlenVj/V46AKwQUnIK2smtNEJ3JZbJV9btI03P6LdA9kY/mRMGbitk00t9M9Zgr0Anxf3WU79EH/1c9E73rPFNmWOo+cDAU5j0TvDtstE3D09Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's make it consistent with the naming of the files but also with the
naming of CONFIG_BALLOON_MIGRATION.

While at it, add a "/* CONFIG_BALLOON */".

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/powerpc/platforms/pseries/Kconfig | 2 +-
 drivers/misc/Kconfig                   | 2 +-
 drivers/virtio/Kconfig                 | 2 +-
 include/linux/vm_event_item.h          | 4 ++--
 mm/Kconfig                             | 4 ++--
 mm/Makefile                            | 2 +-
 mm/vmstat.c                            | 4 ++--
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 3e042218d6cd8..f7052b131a4c5 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -120,7 +120,7 @@ config PPC_SMLPAR
 config CMM
 	tristate "Collaborative memory management"
 	depends on PPC_SMLPAR
-	select MEMORY_BALLOON
+	select BALLOON
 	default y
 	help
 	  Select this option, if you want to enable the kernel interface
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index d7d41b054b982..5cc79d1517af5 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -410,7 +410,7 @@ config DS1682
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"
 	depends on VMWARE_VMCI && X86 && HYPERVISOR_GUEST
-	select MEMORY_BALLOON
+	select BALLOON
 	help
 	  This is VMware physical memory management driver which acts
 	  like a "balloon" that can be inflated to reclaim physical pages
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 6db5235a7693d..ce5bc0d9ea287 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -112,7 +112,7 @@ config VIRTIO_PMEM
 config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
-	select MEMORY_BALLOON
+	select BALLOON
 	select PAGE_REPORTING
 	help
 	 This driver supports increasing and decreasing the amount
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index fca34d3473b6b..22a139f82d75f 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -122,13 +122,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_SWPOUT,
 		THP_SWPOUT_FALLBACK,
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
+#ifdef CONFIG_BALLOON
 		BALLOON_INFLATE,
 		BALLOON_DEFLATE,
 #ifdef CONFIG_BALLOON_MIGRATION
 		BALLOON_MIGRATE,
 #endif /* CONFIG_BALLOON_MIGRATION */
-#endif
+#endif /* CONFIG_BALLOON */
 #ifdef CONFIG_DEBUG_TLBFLUSH
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
 		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
diff --git a/mm/Kconfig b/mm/Kconfig
index 460a148d5b71a..8e23af521605e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -593,7 +593,7 @@ config SPLIT_PMD_PTLOCKS
 
 #
 # support for memory balloon
-config MEMORY_BALLOON
+config BALLOON
 	bool
 
 #
@@ -601,7 +601,7 @@ config MEMORY_BALLOON
 config BALLOON_MIGRATION
 	bool "Allow for balloon memory migration"
 	default y
-	depends on MIGRATION && MEMORY_BALLOON
+	depends on MIGRATION && BALLOON
 	help
 	  Allow for migration of pages inflated in a memory balloon such that
 	  they can be allocated from memory areas only available for movable
diff --git a/mm/Makefile b/mm/Makefile
index 1e31e0a528dc1..0d85b10dbdde4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -122,7 +122,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
 obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
-obj-$(CONFIG_MEMORY_BALLOON) += balloon.o
+obj-$(CONFIG_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
diff --git a/mm/vmstat.c b/mm/vmstat.c
index e96a344ab5974..0f64c898f79f8 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1419,13 +1419,13 @@ const char * const vmstat_text[] = {
 	[I(THP_SWPOUT)]				= "thp_swpout",
 	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
+#ifdef CONFIG_BALLOON
 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
 	[I(BALLOON_DEFLATE)]			= "balloon_deflate",
 #ifdef CONFIG_BALLOON_MIGRATION
 	[I(BALLOON_MIGRATE)]			= "balloon_migrate",
 #endif /* CONFIG_BALLOON_MIGRATION */
-#endif /* CONFIG_MEMORY_BALLOON */
+#endif /* CONFIG_BALLOON */
 #ifdef CONFIG_DEBUG_TLBFLUSH
 	[I(NR_TLB_REMOTE_FLUSH)]		= "nr_tlb_remote_flush",
 	[I(NR_TLB_REMOTE_FLUSH_RECEIVED)]	= "nr_tlb_remote_flush_received",
-- 
2.52.0


