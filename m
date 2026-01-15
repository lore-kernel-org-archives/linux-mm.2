Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102BDD41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C81A6B00BB; Thu, 15 Jan 2026 04:22:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772276B00BD; Thu, 15 Jan 2026 04:22:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668946B00BE; Thu, 15 Jan 2026 04:22:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 555986B00BB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:22:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 236A1139FAC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:58 +0000 (UTC)
X-FDA: 84333658836.07.0B3D15D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71F1A100003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:22:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YGSJm4R7;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQE3ScVVmbY6AZ1BxUT/hBQHoX39GXwAcFJSeD4v1Fk=;
	b=7VHPp8e2LxmT2Pgnz9agY1I+gIrQ3noaFZLs3X6fDl8fHOtTr1o/IsHHTB1d23brvgUj9r
	z1bPUVoS5AvgDEmugqeh7HKNAJiV/rlkGfrBSSVwjosaTH3VKHcAs2ltr6qo/xvwmM5iRS
	YqgZFgOw/bQyevcL2qMLQWPyumZlGfo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YGSJm4R7;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468976; a=rsa-sha256;
	cv=none;
	b=CoP2PZTc4QMTvyisGN+DQfcT+CgDm7VxxKhFwR+A5zIV+0hVsIc0jT/Ac/udUjUQ+t5h2/
	zU/lkNJAT3LAkUFCrckK3nQxHzN8B/ktjpgbmEBuFJA7551fNUKTc1afL7edRS9sqJQnzq
	FKWC6XTuDLwfEyaT9NQCYalzumKiQj8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABFDB40D81;
	Thu, 15 Jan 2026 09:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511E3C19423;
	Thu, 15 Jan 2026 09:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468975;
	bh=p88E23dCTiy64PagmGaBE80XA04TjGF75KHH64+hMzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGSJm4R7U/R58XrtXpfth8OYhuw9HdCkCtpWyccTsIRiLwmNpmCuzFOQjJE8hn4RB
	 uz1otUzKMl+JqDw/m0o2g+c0JgWmf6LIEDWnjW3WcP6Gvgi+5AVgLTM1Tkg8i23lo0
	 HscxoHnTt49CQRkbwTVeYEz4Qz+ebECUrYwNMCKBX0+CxNj01SL7fE/3p/Er6/91Bq
	 qsTSS2JteQnFmUfiPFBKiInhJ4zHkCfhIxyV5hE4LzhJeFBY5JnDrPkZwPA036j2Zq
	 pNR1R1afCa7a88Y+63spvI0c0ua4He1TcQa/OUzSv+MHhmqmsjSw5mliwnFBp0jb96
	 0PDz3KSlgkcGA==
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
Subject: [PATCH v2 22/23] mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
Date: Thu, 15 Jan 2026 10:20:12 +0100
Message-ID: <20260115092015.3928975-23-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 71F1A100003
X-Stat-Signature: rueu1pszaq8fenpqg8f5z631zhs9cdfk
X-HE-Tag: 1768468976-242612
X-HE-Meta: U2FsdGVkX1/8V2C+SHuLHB2i+HGcy5hYBZ1eF02zCffFW7sUwQ184v6KaO2sHOSrJQLkuTBqaKJaAapiy/M35j8mQftZ61HcxgDCU5lI3eJK4GlGEfsgoZnlAMLuoKF8VRlv21ClyhhRgkOfpfB+PYjJ92UIfHIk9RVLJTf+L6a9YIigR9WLFFbLBjS26IM8dOgJuHWkys5zfbvouTqznbkXgyofE8NikiRewoQQO8yD3vFv4FIU4qdGVN/n7JzqSqazhcqymS0EvnUOjYKkDOxzgctl9vGysmqNBY1zQQD1c8O8mLoI3sI/0GW9ExAsTZFOeFc06/DX3nAqD/cAPH12eaDxRcLuYtYuhVLooQIzGF1SvNNaXjufPyFdgne3qV7hZQhK5m/tdUgIjV7YwOMukN3qhItyoF3SuveLIIF98/Mhv4Cj5T2aiTzfhkPTXoEqZWEVZh1+28F6CwA3CKoBQVjhh8jeEQJU6YyGttEO0CBBorcFXfVLmWZd9Fse7qeXCjT2DbIaHx2kwuax3+y+QbqjjIS09ds8v5F7eI0X2VRQSAwqWxTE5X0K3AzsB4v4l/VM1HAmDsfLH7c3WygZQpDsrjdg9ca86QNIankoNW759SATETeKFolVm0loKRgqgw2V5HXix1JMO34w5hreQ36EM4fLR9J2wlIPbvrFGZki/tg71usSqlBuRz6L05qC8CkQzIb0jfa3v9TVrqjBccdct8LlAjBX60GSqsjtiq6IdGM0kYiDVf2swhiDKVIkRsK175kNA/shods6huUsP1+VKqraafsGcUYxpSgtLKAATSG3HzXjrsVC2249s22Deu4qz68bxb/1qmuhY01dsht+YrNZ3QUnN9DHZLTr4YJTPuPQ5uOFxD8i/rl11iqu3y7bUdajX3xHiPYMI1vlyAe+2r8FWwCqMIkry9uT6Cr8J7Qap17M/0ojALInaQXLiU63cVKCv0tvXuL
 KorjFdxG
 Vp3hcN8bq1zmF45Kb+IVnGQerNkBME2eorGcKRjk8wO6cUr7M3owk59UJU2BRhUqPRIgmvoCDGhFY+RAY4hr6TCwkE7WwLE85TvI6A7OadlluTblFOBaj9N7cKPcdZ9hx7JHub580CQEEUMTTS5XHnn9BvmrVAbRkGKUUDD1f92y5xxmpYyjTSvLKnOK933NQAFvkoMypvcolGVNoSeMl0w8/WGT+ExXDpk7MkmxoBwZ2zxK5H05ZxwrcD5t/owdLb+OGLcaJ4tThM7hlnxikG7U8IQ==
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


