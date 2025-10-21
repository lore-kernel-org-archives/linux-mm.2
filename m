Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E0FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BD88E0024; Tue, 21 Oct 2025 11:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EBB78E0002; Tue, 21 Oct 2025 11:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C608E0024; Tue, 21 Oct 2025 11:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2A58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:01:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03FBE4869C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:01:04 +0000 (UTC)
X-FDA: 84022434090.08.FE1B2A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 39D50180006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V7JB6/hI";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxeaoFY2Zid2XlBwuhP3Cbqf0hU6HwUeKjXEu5WpZgc=;
	b=v+4odtORkpsT29LV6mcLZ50fLZAgESm8YKq9QyMobkB/yKgCh8v+q7GjT5vkVn0UNJE0Hv
	OzFZbmTh2FthJu2OBqp5JpDig61a7mSOe0WEx0sy+cHeovIhQfHIDYu7FPAoMn7yR+V/JX
	uqTkZN99y7kslMFSuEq/RQO/pqSsHW0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V7JB6/hI";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058862; a=rsa-sha256;
	cv=none;
	b=5jhyIMOSJfhbbG2x2DTrww0Sgf9mPvebZi0OKeSo1Rn/iTXYCZhUE0JwrRGnUvEPv0Dabf
	YDYfQ2HpE11L9qYehIntt4fIldOUxoUBL8DrxuIMhr6D9JP770qoooEbFDVJ4tp0AOwyxO
	U+eWfnHNdyYePuTwjs8g6dFzMRFSnoc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IxeaoFY2Zid2XlBwuhP3Cbqf0hU6HwUeKjXEu5WpZgc=;
	b=V7JB6/hIdOZaKish/r4jEtA1qiCosg6Ans6+oToHefEw58S2Lwedfzl5Gee7UgsryAs4BC
	MmrhqxSuW8QgwFc73M5iVqA0X/I4KRiZJ2mzubO3ZOw1a6LtcydHXb/rfP72S9BPEKRYhO
	nPl763MAB6Uwc1dII0WmCzXLY5FKymY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-7TsDHMvvOuql93amFwFToQ-1; Tue, 21 Oct 2025 11:00:57 -0400
X-MC-Unique: 7TsDHMvvOuql93amFwFToQ-1
X-Mimecast-MFC-AGG-ID: 7TsDHMvvOuql93amFwFToQ_1761058855
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso30355545e9.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058855; x=1761663655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxeaoFY2Zid2XlBwuhP3Cbqf0hU6HwUeKjXEu5WpZgc=;
        b=aoZw+i2y7ydfgLY40yWYtYlySW9cxC81NO5Bxpx2ODXt4lCu7hlD/QPcSmjXZEVtmK
         4GAQKZlGNwLSi7yqS3U2vkhmzFkwjzEkrY+3l8vqIRn7JMZGlhBHPt9sH8hNUTZ+YfeG
         9V3haoOUED3iZ/uDuGvTLd4OPBgCanGRGBDrbrOKDUo7DdeBxFn/AmZZHeSeQJ9PbqiH
         0dwiCBpDDwC1fhS8Z36uu9m+PBW/TS2PakgszwWbT25e+HoOkL/vCes3s/HPlWw/WZBK
         ku35ZJRsrgsmmuiSatJ/e02+Ea9KsE1JPqzK6InkX3gPLY+j7/ig//3ApBJsSgjB9Ldt
         2sFQ==
X-Gm-Message-State: AOJu0Yzii9ykWj2aT/AgUV3qkKD613OmC3JeSn/vwhrYfhRyzuzqzgey
	Vlj7E92zNoZyUFWq100ff5ZmLZqseZXFbj8a2dls+tPRf869OuHYoebujtDFQp4GcrMIpXhMC+q
	pgKQ5Yxsiiz+BOa27WDBsaUgS6EftEwH6dfvizvFDWoKDbfVuDz9+
X-Gm-Gg: ASbGnctYJ2J3xxiti0C/zVRk2SMypudRPhoFHXWTvT7En0uZGRjyzuUFpxIh94hTwzI
	0mrHG4n3NhRr8RM1LK5Y0VozihrIifI3knh8rORXg9kTNgl7LIGR/uylH/C2CXSMuQAo1Thsgny
	fweqQOOQjDJDDeNhxmtVZGByxQUhMoDB0SyikUQz4yxHb0HV2f0x5OiGApD1/0rDVoGN5qpEQ5K
	j9eYejx9WMW8Z/s5Xhpki7L5ExpUyh4+JOd9jBRNFtqqx2rLyW3zQlH6BFgbF4t15befWRKLhkJ
	JHs8DWnGh1nhzYLQOTj1hHsp21k8Rz0oUGFS4eXPhIj8gnELcM5Xb3k6UB8jUBcvrElvTSvRkOP
	KLhWz9PtYKPMBlLl3ZKSNKkkM/6/y0eguGjdI0tOGE9BTIflkFT1ik30eehhX
X-Received: by 2002:a05:600c:6d87:b0:46f:cdfe:cd39 with SMTP id 5b1f17b1804b1-475c3ee145emr177215e9.16.1761058855009;
        Tue, 21 Oct 2025 08:00:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTNQTiGz5xAhZ5fsddDZjV1qS7LKojQZq7D4oRaNBiv/doXb8XOAkbt7nBaFlt+DyqmCX9Sw==
X-Received: by 2002:a05:600c:6d87:b0:46f:cdfe:cd39 with SMTP id 5b1f17b1804b1-475c3ee145emr176645e9.16.1761058854422;
        Tue, 21 Oct 2025 08:00:54 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471144c82b8sm285435185e9.15.2025.10.21.08.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:00:53 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
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
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 22/23] mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
Date: Tue, 21 Oct 2025 17:00:39 +0200
Message-ID: <20251021150040.498160-6-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021150040.498160-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021150040.498160-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cOcfMJqXt8UIo--2aT1RAHH9ey-kVJxhXN5y34VPejw_1761058855
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 39D50180006
X-Rspamd-Server: rspam03
X-Stat-Signature: 93odw6o9fhrkbcnhhhhq3xampofdftgq
X-HE-Tag: 1761058858-493596
X-HE-Meta: U2FsdGVkX1+DdmRk7qf1wYEGFf72m8bYniSTDcsrC/M0b1EFYF7R3XCeRZaU07hfxwZ5dl//m7Fl9b3pOzX9tY3dR/fB0tN/vBocGTOKuB5UJ0Lx9y4csjBNa5AMjkJfRnTy4I8a/KSFGFMhzRyiMNx1DCmyLanfjn7XwLlBpV1azM0RXhr1mW4ISMml5UIHG7oCJh3j9AJzQYZ0EmsTa9HC+stmBCJSaz57k/brWUWqAWoIuM9WM76p2BnQB6LwnLkWxTFA0XGZGu02OBoTdCeIj/CKpEqOPq0L0hZPjySEtULxOj7cT+GRs4xGHz29pIwaNwSv930Fb6+Hj5lxj+P8hNtBcCbYwXChKZTPHnh0wcWMusPsIXTpJ3J8cSpEKH4jIIrRA548qIjEdW1ID0Bcp+AJj9Y1Z0ksaVg4b1CfAbYDOpub7yJ8Nyi+Sy+89b9/UJ4ihjDncgHFab26AkAQCeUlu98kpd0agKADgVRo6s1gWr0dB3rgUDaq1QlPg88UBjvONGZpQ6VI1LgnoBnCiugTItAmiwb/taOIP8rW9fcNrzWApP6o24/kWn4LXC2XnjFDGbq09VtZTa/RbOCQxTGdLw3udboRPx1O7R7hnBYUlTA/TLVvjz09yx+H+ZCP8iqfuYFudn6VMlGRwHO9GKzY/8QNsxGFbXA79Cra72poj5V11AlJGh9rbx2WhdKU5zMKhxR72u1RNfG8UfuvGvk/+0v3xiKlsIdLCzcJ7lGMKNck97P9Zf8N/YZfsFJiy5XtTqvX9m2Ay7pLxAERliZtoapsvaC//dA8SW4LNgaYHDy7c99gqlwT60Hp4i/+/WDuYrybl+mUddUTUFrj+gIuOqwHHMdcYZ5ltYA194IYECMshrDOhvaxBVMdnvmMdodLwkkKkCcaiIZynrCAsYhikS9DPJ/IHCU/0dsEGK9SgEyRX1EjaUWKGNGu9MfDMB3OnwJu3+UvdEn
 GtFyZ2zv
 ifjA42wEwdf+cc8NIo00a4V9z1+hVQXOWHFHlpCWbISmu79pcvBS1RJkeYvcTK3ego5F2GvHtQoa1ABWjeOHgL69DIrSkFu1mx0rRazK7SVoVgKW0qtSUCRx/Pb+XFaWCpWECJkpdRu8L32AwRjvVF6mKsbycZ9+GpzwbrQyAoRqo4twy2kJV0kr3r1MLE7VybtJaLA8H35oF8veKmQYcAeG2nASKrvcIoT0L2kE5bd3B/YNyKelC3GwKUfru7qjgtqqCpTwuwCHtN2u7h1Vz4NIwaxgrxSpSkNClllxAqOxUuQ7Ao4lhLfxxS1EDjvpTJzlilo4goc3IPSz/c2x3yH2iZH55txugd3GTFATz4s0yR+ez2X6lxkXk+4lqgCuBdcyhKrxUIhgiQOf5KhBmtd6ikuS5BrB/qRv6GgALSU9OKjBeV3HwfEcrAk/gG7XF4typ+Vj6B6JG49c9v2rbzEL/iQOOMlCKVdyPqyoQN3BZEROq50HFjmc4eSo03JPfpJaTwHKZj98UDK+1gSNgS2dTtkFyreS01647Q9xoKULXxyRvnssZo4ooPw==
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

Signed-off-by: David Hildenbrand <david@redhat.com>
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
index b9c11f67315f0..47da8dfcffc2b 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -411,7 +411,7 @@ config DS1682
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
index c058a65080d1e..73e352bb82653 100644
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
index ab012157b5109..315aec23d78f5 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -121,7 +121,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
 obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
-obj-$(CONFIG_MEMORY_BALLOON) += balloon.o
+obj-$(CONFIG_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8843a8c4914c4..542378df0bf75 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1431,13 +1431,13 @@ const char * const vmstat_text[] = {
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
2.51.0


