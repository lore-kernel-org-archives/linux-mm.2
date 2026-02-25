Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D5C1EFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BADF6B00E3; Wed, 25 Feb 2026 03:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BA06B00E5; Wed, 25 Feb 2026 03:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCFB6B00E6; Wed, 25 Feb 2026 03:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D86336B00E3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:17:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EB1BC1EFA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:17:29 +0000 (UTC)
X-FDA: 84482274618.10.1B9C78D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8609100006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:17:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXiNa+Yj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007447; a=rsa-sha256;
	cv=none;
	b=HvCr3WPSHfgSpak4FWFdLe1R64nSlon0AKu5BGFxfvGki/+6k1Q1uMWZ2gEMZvo9FSfXKG
	o9SiXHZXKgJICZ+UNSQ/LUpT63bsmoafUb5nGzoHnRDcRL/AmWRBkGVkLmArO1LaGBNs56
	b4/ECOAqT6QN1Pvh1l97v/D1XOZC2Rg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXiNa+Yj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oV6MOc6IZ/eQSfEt7lDYf3QV1I2fYi7uzloZcjfdDk8=;
	b=UQDpTnYwLdIK5GohuQI5iJzXFflDSNYrTslZAyGTsrkLHtOtZEbi7elpk1YXkRgDBCrFPP
	kCf1YTjuCNgKzyCcx1rrUHmiAeoEctVUepBtcqDnhZWzVgEUaYSqU39/aW3GEROZi26ibV
	QWN5EN1TSHzKAtW5c9jUL09wjyz77vM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oV6MOc6IZ/eQSfEt7lDYf3QV1I2fYi7uzloZcjfdDk8=;
	b=PXiNa+YjYf9xRoxDJFv0X8xYotSgTZb+UCAGyQJpbI1XoG+ndyD3n7vbbvbV1Bx8e8Hn8h
	ycSwt6juZm7qhv1WeGlkglpJy1Z3i0/NWkv6bOk5LuKF5nCNECD8/KJIBIcXBHYlklkDhS
	RwrZYJJGLHUJG+ABKACsHbGi2Hkq404=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-d1eK6WOzOV6_MuYcbjoUdg-1; Wed,
 25 Feb 2026 03:17:22 -0500
X-MC-Unique: d1eK6WOzOV6_MuYcbjoUdg-1
X-Mimecast-MFC-AGG-ID: d1eK6WOzOV6_MuYcbjoUdg_1772007439
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33B381955E8C;
	Wed, 25 Feb 2026 08:17:16 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 657C01800465;
	Wed, 25 Feb 2026 08:17:04 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 15/15] mm/kasan: clean up unneeded ARCH_DEFER_KASAN and kasan_arch_is_ready
Date: Wed, 25 Feb 2026 16:14:12 +0800
Message-ID: <20260225081412.76502-16-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 92dgqxFJq5Zgb7jIb3xCVnP7h75r7mblbwGMeRCfe8w_1772007439
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qszetjoyew9uxxoxgcgbnd6qk46m6yck
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8609100006
X-HE-Tag: 1772007447-83651
X-HE-Meta: U2FsdGVkX19HgfOQfi6cnSGjaza7sLA6o2KudabPuBnzVYsDXA7aRgRy/mASgeviAvDxwWBWSrV3/ds84ZdnBdUdAbWCD2znBowciHOVR/50CTtpt77xaO7IpSG/QDnnzBvUpaQGYontYTEzw8Y308CcsXybJxlwX9s3v52m8LvWwZAFvSbIR0AH3PsGTibWAMYxqorf+GSNNNUto0+SEYGJAwYh3GoIhLh/jLSQovksIeQpa+naBHwRPTXPUZktzTpcbcwgwUtBhGRhcw719rZs/Bxihc/kuc2eqnylnU8DSCgXlrywwTI5/GDOJqvUWeifN0byWXqnBuP+Gx/8J/wWcig211LnUWHsDkXYs1cn6YAdPmP5naRJVy5PIKfID5xS18nPYwIDKt7scR0IIBu0cFKJURGSAm/atTMM/fiqlxyoShsLqXAiHO4AtTGQMwBqYeFWruBCn2H6cFJ0YQfZHmK/BNz6L5Ti+dVcRr+8LiWhnaWyG/hmrpD7/1fhLL4cZU5EX5fyVzoiIpm9tnwvDKJj5HqQAQ5zM77tzf0yt7O/+BPgpjTSp8uqSyCFD4mnjRp1MkeAd3avi3NwODswIKy+g8ejtvQuKDGotKLPhyuTfnZKyazRPVStYX20xBoxJEfBvYzgEGgxr6ggNYB9kkV503NkgCEoQKLfZgGs12hXM5vRfNtDbs6yIjGm+L0h/3nzY+Zd7YwrW6WMS4BPDsiT6uINB7ZxwLp2bped+yQG+WB55+Ht1drmbE86LhCxLy7aqFrYWxcdrFPelJmjNIppPnJmTVssYEJfUB7XrxjCszn8DVcARW2oeznJZM1fkmYQO2HnlxKr5okNWdPKf5/yZrTTZxSZwwWkP+h+FYRpMzmmILE71FL06G6Lg1ccegrmSrWmLp0M8KjecCDlKC2ep/4tP3iVfq0OvQXq87c7qeQUbkNnUH8Scnzihis9qqVz7djd6E4aStP
 vqC6mCp1
 8lbkniqeGVRFjhG+8Ayq2qJz3pVLLXC6D78FiPqD/DSFeqP4nawyW92bIt+kBmngwLjhb0U6ebdk3MgBC7S2Ar9KMQ5gQkVcFMJiwx0pS8JTpnL4d1QMUxn0TSH7Gv0X+D8x4SqTaEjKTJk0FiXbDcUa4pIT5bXwXxO4rHp0frzAeVtBOxiZkyp3AUO4NMz1YdWG2kei0XbDJu+MmnaGrr8J61aN/k9sn1YFSPO4SVTY2fmh1+gsw3t8g4XwyAAY5XgpfPGcNSoJ2sR6/CX2YLXqK+u3vRvUHkH5y7L09q8bobhQGwr7A34nbiqIi9CUOMW2jfoZnK0apqYqxM57pTKASXeYXtzFJ4M74mczagSiBjlG7EeuoZZx6XdEpuGnRIE/+xPPLDrs2XOoHmuP+EqRw4FuEWresuz9aPQW7AIYoes4S/pt/flTQDNPGpPTGD6S4lGZieWDKeoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 1e338f4d99e6 ("kasan: introduce ARCH_DEFER_KASAN and unify
static key across modes"), kasan_arch_is_ready() has been dead code.
And up to now, ARCH_DEFER_KASAN is useless too because of code change
for 'kasan=on|off'.

Here clean them up.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/loongarch/Kconfig |  1 -
 arch/powerpc/Kconfig   |  1 -
 arch/um/Kconfig        |  1 -
 lib/Kconfig.kasan      | 12 ------------
 mm/kasan/kasan.h       |  6 ------
 5 files changed, 21 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d211c6572b0a..4b7802d02911 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -9,7 +9,6 @@ config LOONGARCH
 	select ACPI_PPTT if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_BINFMT_ELF_STATE
-	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ad7a2fe63a2a..b51fbc25bdc9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -122,7 +122,6 @@ config PPC
 	# Please keep this list sorted alphabetically.
 	#
 	select ARCH_32BIT_OFF_T if PPC32
-	select ARCH_NEEDS_DEFER_KASAN		if PPC_RADIX_MMU
 	select ARCH_DISABLE_KASAN_INLINE	if PPC_RADIX_MMU
 	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 098cda44db22..fd0bedd2c696 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -6,7 +6,6 @@ config UML
 	bool
 	default y
 	select ARCH_DISABLE_KASAN_INLINE if STATIC_LINK
-	select ARCH_NEEDS_DEFER_KASAN if STATIC_LINK
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CPU_FINALIZE_INIT
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index a4bb610a7a6f..f82889a830fa 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -19,18 +19,6 @@ config ARCH_DISABLE_KASAN_INLINE
 	  Disables both inline and stack instrumentation. Selected by
 	  architectures that do not support these instrumentation types.
 
-config ARCH_NEEDS_DEFER_KASAN
-	bool
-
-config ARCH_DEFER_KASAN
-	def_bool y
-	depends on KASAN && ARCH_NEEDS_DEFER_KASAN
-	help
-	  Architectures should select this if they need to defer KASAN
-	  initialization until shadow memory is properly set up. This
-	  enables runtime control via static keys. Otherwise, KASAN uses
-	  compile-time constants for better performance.
-
 config CC_HAS_KASAN_GENERIC
 	def_bool $(cc-option, -fsanitize=kernel-address)
 
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a54766..f08f7f75c285 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -552,12 +552,6 @@ static inline void kasan_poison_last_granule(const void *address, size_t size) {
 
 #endif /* CONFIG_KASAN_GENERIC */
 
-#ifndef kasan_arch_is_ready
-static inline bool kasan_arch_is_ready(void)	{ return true; }
-#elif !defined(CONFIG_KASAN_GENERIC) || !defined(CONFIG_KASAN_OUTLINE)
-#error kasan_arch_is_ready only works in KASAN generic outline mode!
-#endif
-
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_kunit_test_suite_start(void);
-- 
2.52.0


