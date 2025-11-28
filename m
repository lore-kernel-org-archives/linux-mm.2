Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E84ED116F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E236F6B000C; Thu, 27 Nov 2025 22:34:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3A16B0024; Thu, 27 Nov 2025 22:34:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3546B0026; Thu, 27 Nov 2025 22:34:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B88286B000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:34:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CB6DB835F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:02 +0000 (UTC)
X-FDA: 84158597124.10.89F16DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 706AA40003
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/ylJZF7";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3gPrOC7MauvGRj4YbxCiDaSAJrqi5DShDaS5sFXKjg=;
	b=bpCB8DSqN2OXcIukxpVU7+1KI5G4KFuTC8WF7kXs/tus6kMWusp+4zo6l9s2WaKmVdFHPA
	RMEg4mMBIuVQ5zquXNR3H8Dzd0w5wt/JiAVcNv0U9toVeNh6nXel96NB1GT+r95dUV4YkN
	ETAHH70R+gJMTpe3YPrYlFleGvUHpSM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z/ylJZF7";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300840; a=rsa-sha256;
	cv=none;
	b=nxDoHXYigOxTbdPL1yO2f4hK+EYU89/q9B3SU6txNuVGrHtDYPQ5urvGo7qE1yIY75A7g4
	6RvjyA/Q9NAStD9nJ8qtqmBhAl35ENErY0MINTS2c1Q5vbUPQL1Q5rGpJdvKMKXCBtLdVZ
	+qgw4y+9a33JEwg9srD8s/hfzRGTPpA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3gPrOC7MauvGRj4YbxCiDaSAJrqi5DShDaS5sFXKjg=;
	b=Z/ylJZF7zK9oPiPH4C/i0/Od/X/R9UkPJq31qvSkGCRRKqsn7jGb64fPv8bIFjnq87MWxg
	1fPRJLoqbbp15FNYDP5wylKbmtoblUY5nnTSVzD8k56JkIrX1j0WGfjInwT0TMxgtd6G4C
	2jUaxLqcU0Fg+jW9R/B8zADzN2Brq/M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-uEumHcseO-e49imQKWSn1w-1; Thu,
 27 Nov 2025 22:33:55 -0500
X-MC-Unique: uEumHcseO-e49imQKWSn1w-1
X-Mimecast-MFC-AGG-ID: uEumHcseO-e49imQKWSn1w_1764300833
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 657891956088;
	Fri, 28 Nov 2025 03:33:52 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A23FA19560B0;
	Fri, 28 Nov 2025 03:33:44 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	elver@google.com,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v4 02/12] mm/kasan: move kasan= code to common place
Date: Fri, 28 Nov 2025 11:33:10 +0800
Message-ID: <20251128033320.1349620-3-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: 706AA40003
X-Rspamd-Server: rspam11
X-Stat-Signature: 7jdworwfnsu5qsrtuhqybyfp73a96wxn
X-HE-Tag: 1764300840-388436
X-HE-Meta: U2FsdGVkX18olnSVuEzNjPrzar8WmGm3h1l+/3terNpj5kHuaShEY+Mp32xqni0siV348mejnh+X1lFtWQaJjctM3WhT2RW+F5mlXqafKR1o0YP03/LiwvGfb6pAInX7w5KA769LNkN3Yj2q0p3KLELFORQ1xGZguKwWG9CUuf/XetW3n2d1sdSvbbchNCJ48A18ePC0zuHHiBRHJyRgxYERGbQHVcP6A0xw3nbMT6DrOaNJlljBAAgwlYg7mP7OwPbvIkYGPgfsn5S/kKoPG5boqpWg0ufRQPI+WdJpC+TdHS109OTcgBmsMYIGFpDDCdJznIsbJf/IYM3XP3cGcp8Z8RKqKQeTUvY5uSLUYrqgWlKQXfq7d8P4/x8lHgba0R+04WwaQY7jCkZw48WaVhnPesH8K35Gy87ENef8cIILelkR2anijWhK/68n/5pFIrerRHEBwiPINieGlJUstff7dXNkiE56asklGigRaAmVT9hzv2nP5WTYUP2Nkg5d1zk9hkFzJlxwX/xhk/Vdwh6/NP9RumkuDplQN4o7qATmL9pPWn/Wmd64bEDQ+IOyULfeQlGsD9xDJ7XFwnPEhK4Ujd7V1DmYUv2okEveN+agm4hW0ZCfKa+shtNaVBzoYUVSYjV9oB83jnFBvR2WIODVZsGpCsCGRoq742XKWZV30Tf4L3fX1xMzCxq3Rmka1nLN/jHt4MNm7qsFaF7s/ZOhmiJg4QH7eVhjPq9rO6OomBicSLXrdLv3xCDsQq1QnR/l6A+2wU7YOhH6EZv3MPvMp9UhqYWlXzt36yOkShimCs1nTu0h3bNy1hwMGX8vXgVWcvuOzCry9zqIN7Xzo8amj8HXeCyzHv2/sd4ZOEksvzTHKWid7bMYQFOnzg6M7KKvO47g80ZDcjl3p4+OXM1xe8o5AuuQixFj6qx5QC126qKEryvg3iaH6JTEltFaXqes3vsdPji9cxw+hmK
 1+wFH3q0
 SGjJ6BLdlBPB4jk5ydofDNxHcJxeYJV/b36/NwNlKQoUirlLgnMHL7qLxbsnfLMPpvSUdH/OVpDJncuouhmWRAHH3VX4tvLqrMbyNNA8Ogis4w/1a7iITJgYoXfoGF+W+GRhuSHGaJsfwdkiD3yXKDR5gp9KOnb4Vp+S22i60yRZXU/UaLWJXr7i0PSmM11mHnitUhUUqzcumiuPdD5oXa+fz7x2trnsNPKbO01bFHwXZ8wru/5cBQMHdT00vYYf6SxEGrx0cw9ULrwetUtXDjORQd0ymE55kcO5WQm8NR21YHzR/xFnfAJpo7taM23JJnXLyHaIRD2jpI89i4CBG1RqNMifJN3d7MyY/1eNfY1R0IAjyeEkieyEFTICSyEH0zzlo0avslYlW0/0KOv96pyYjkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows generic and sw_tags to be set in kernel cmdline too.

When at it, rename 'kasan_arg' to 'kasan_arg_disabled' as a bool
variable. And expose 'kasan_flag_enabled' to kasan common place
too.

This is prepared for later adding kernel parameter kasan=on|off for
all three kasan modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kasan-enabled.h |  4 +++-
 mm/kasan/common.c             | 20 ++++++++++++++++++--
 mm/kasan/hw_tags.c            | 28 ++--------------------------
 3 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 9eca967d8526..b05ec6329fbe 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -4,13 +4,15 @@
 
 #include <linux/static_key.h>
 
-#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
+extern bool kasan_arg_disabled;
+
 /*
  * Global runtime flag for KASAN modes that need runtime control.
  * Used by ARCH_DEFER_KASAN architectures and HW_TAGS mode.
  */
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
+#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
 /*
  * Runtime control for shadow memory initialization or HW_TAGS mode.
  * Uses static key for architectures that need deferred KASAN or HW_TAGS.
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 1d27f1bd260b..ac14956986ee 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -32,14 +32,30 @@
 #include "kasan.h"
 #include "../slab.h"
 
-#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
 /*
  * Definition of the unified static key declared in kasan-enabled.h.
  * This provides consistent runtime enable/disable across KASAN modes.
  */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
 EXPORT_SYMBOL_GPL(kasan_flag_enabled);
-#endif
+
+bool kasan_arg_disabled __ro_after_init;
+/* kasan=off/on */
+static int __init early_kasan_flag(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_disabled = true;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_disabled = false;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan", early_kasan_flag);
 
 struct slab *kasan_addr_to_slab(const void *addr)
 {
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 1c373cc4b3fa..709c91abc1b1 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -22,12 +22,6 @@
 
 #include "kasan.h"
 
-enum kasan_arg {
-	KASAN_ARG_DEFAULT,
-	KASAN_ARG_OFF,
-	KASAN_ARG_ON,
-};
-
 enum kasan_arg_mode {
 	KASAN_ARG_MODE_DEFAULT,
 	KASAN_ARG_MODE_SYNC,
@@ -41,7 +35,6 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
-static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
 
@@ -81,23 +74,6 @@ unsigned int kasan_page_alloc_sample_order = PAGE_ALLOC_SAMPLE_ORDER_DEFAULT;
 
 DEFINE_PER_CPU(long, kasan_page_alloc_skip);
 
-/* kasan=off/on */
-static int __init early_kasan_flag(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcmp(arg, "off"))
-		kasan_arg = KASAN_ARG_OFF;
-	else if (!strcmp(arg, "on"))
-		kasan_arg = KASAN_ARG_ON;
-	else
-		return -EINVAL;
-
-	return 0;
-}
-early_param("kasan", early_kasan_flag);
-
 /* kasan.mode=sync/async/asymm */
 static int __init early_kasan_mode(char *arg)
 {
@@ -222,7 +198,7 @@ void kasan_init_hw_tags_cpu(void)
 	 * When this function is called, kasan_flag_enabled is not yet
 	 * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
 	 */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	/*
@@ -240,7 +216,7 @@ void __init kasan_init_hw_tags(void)
 		return;
 
 	/* If KASAN is disabled via command line, don't initialize it. */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	switch (kasan_arg_mode) {
-- 
2.41.0


