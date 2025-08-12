Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A8ECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194908E0115; Tue, 12 Aug 2025 08:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134228E00E5; Tue, 12 Aug 2025 08:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0227D8E0115; Tue, 12 Aug 2025 08:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E401B8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1127C1DC07C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:18 +0000 (UTC)
X-FDA: 83768088516.26.BB0DC32
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 30227120019
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RJdmj+xA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003016; a=rsa-sha256;
	cv=none;
	b=IaHaxx58wESDXrTvJcPewircLixfyiaH/S1nS0zAuXAnnXP4zARGYfaBiPRPRf5WFD1uev
	EwTt0JvQnBr2DcwSHPm9z35Y/7buxznK9tZf98jDLZsMtaBlKu+BaoSZL6ANg4j0bNyBBK
	igv8wTVFFhP1eiZADUGJhWj8+hxGfk4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RJdmj+xA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEDfd5YwQwP//qNNRp60/4j9gVHcNuQdiFWm+KANNic=;
	b=5+Da+vhu4za3oCRVHWoYiV4qkPi0x16YeRrE70DU40QpHG8HnDHOJP82ZGGMIlZHPddHSP
	5PAddHv0dz+bsNZWTI69w6uhVhBF0TO71XTvr1tiDIWxzspquqJYWHLFCBKilP5n2JRE4u
	T5yn+0KEICyeoTrBZ2/KYidInvD3o50=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oEDfd5YwQwP//qNNRp60/4j9gVHcNuQdiFWm+KANNic=;
	b=RJdmj+xADxIcqwGc9oInStRsvkrNUgyoGm8zS59PoPq58eYTZ2eN6BG1d6wSPR6jlhPk+3
	wMdYk3wZZbJB5YIw0Jxof80Bh3+LEkgqIJ2/+CXC1yImDLMgENEYhWINBvuySkvsyca4Po
	QPBOPkn0y2X8KsIyiKQ7Dns6X0M3SH0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-25-pB9e8V-hNSCSigDe8LiZ2g-1; Tue,
 12 Aug 2025 08:50:10 -0400
X-MC-Unique: pB9e8V-hNSCSigDe8LiZ2g-1
X-Mimecast-MFC-AGG-ID: pB9e8V-hNSCSigDe8LiZ2g_1755003008
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8214119560B1;
	Tue, 12 Aug 2025 12:50:07 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E97330001A1;
	Tue, 12 Aug 2025 12:49:59 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 02/12] mm/kasan: move kasan= code to common place
Date: Tue, 12 Aug 2025 20:49:31 +0800
Message-ID: <20250812124941.69508-3-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: xcbxij1crexfu916rxazs9xohro8h34f
X-Rspam-User: 
X-Rspamd-Queue-Id: 30227120019
X-Rspamd-Server: rspam02
X-HE-Tag: 1755003015-644584
X-HE-Meta: U2FsdGVkX19I2TS6suaP9hrXbTSCVBsJOc0xO5waPXNgIUUTC+Q02wpcsw+j5fD5SMOcePeex1X5/ci8aVn6vAt5qWSr8BWJ0KmvUluY7pg7lrc/Mul3ajZylNCyAAZLN9p7uF1x5P6lojoNw7Hx8Ugd4W77nEgqgeoSX+4sF9ppSiqE3PM4cbaNJDMrJeAN46uaFOEcezTeHXnt7gLK1diEkxldMyFlmegg7twFhIpzukYz6ESYLHQrXPn8l3gDm0lqyliWaQUjioW00ULKCF5gEAfNZiFXtkbJTzTaf6qt6fEmCKocL4VogzqIDXIT6SykhIYPvohiw9FjBiYe9kym5BhJjG8xM3hTFjOknNiUTT3EVy+pJPnb9lWI0FaE6bnVFQvyz0WIF6haVUaIyhy+tmKUaFgpO86lCJvvasLt8uPOqHtB2m2ufIiwIYHYwPVLRn6jZE2mJ8QjuqGdNWpoX3n7ZZLGXdwINLBPfJ+bJtA1KJ0Cui7XVZFh5mYn/M1qd9R6+GrCPcpPAZq+UbTYQ8ZhptwoHRw4gTe497jkuNvWQTpB9YyQyUCb0BsZD4Wz9FIb277GHZ7EURiHgdTcB3JK8eHW7+v15qL952f1n51U6UFTPpKHelWyku/XfpH/9XnIuBQdlecCz6TX61l1fkOxQDbtroSB5RK57WqBHTovxMn6QXT0hY5pgZ8jTZKgC66kepnOf/3/vrT/ttkL7j1MBE6EYYiRDS6LwGB/GcOBTOWLG6OOkPMvf3sT1xFe7hZYRPvClmb6v3zxgdWeQuB78yZ3+7VPCbFFVGHWHW8wH4wdU/N3qCwyiGKahitfsS6atsyt2J5ErMkyX6a6bKe4L6lMiLZh+YdD4//aiVii4sEbDQVb73KdeMmafAQnJn2RfSpc1E8y2NUCcCH2cz7WxVotcPNXVicLNd+x3K2te+auO1ZescmfJSBgcjagGD92HN/qy42HCcU
 QV2xwFOA
 XzxupSLU1Di/84OAFazznAz3P1bZcC3yAlWdWwhvxWf37xN1HOdv9AfAyEYr4o144IRm8R5NVjoE1AWfQxQi0jnw9EYVHfF/VYfBY64F5IfaVvO6ga1JCbnoinTbueGl70+Kp43Sq0/XEzVXJz1WIQGtVH1hvwBmKhuo1hkYIOxgKROX2FIF2rJ/6Qu+xdhQzriJ/sB4qfuh5EnWNJxErWxPyzDSeUlKdqBaGWsCoTh9V09X4imSVewiEGNdJjSeaAqU6DZEizK86wqpM9d8sRHj7FP5699ctLi6XumV2l7LY8bx1of03REtKMLm1e0J7qGWDSxYaqUwuFPeGHLBj06XVEad/sH1ukWdUAw+ErfU1UcFIZaZQkl6/uy59/2HFZZCXI6N+h1YSdmgnD4HGNXN6Cw==
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
all kasan modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kasan-enabled.h |  4 +++-
 mm/kasan/common.c             | 25 +++++++++++++++++++++++++
 mm/kasan/hw_tags.c            | 35 ++---------------------------------
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 6f612d69ea0c..32f2d19f599f 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -4,10 +4,12 @@
 
 #include <linux/static_key.h>
 
-#ifdef CONFIG_KASAN_HW_TAGS
+extern bool kasan_arg_disabled;
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
+#ifdef CONFIG_KASAN_HW_TAGS
+
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 9142964ab9c9..69a848f2a8aa 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -32,6 +32,31 @@
 #include "kasan.h"
 #include "../slab.h"
 
+/*
+ * Whether KASAN is enabled at all.
+ * The value remains false until KASAN is initialized.
+ */
+DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
+EXPORT_SYMBOL(kasan_flag_enabled);
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
+
 struct slab *kasan_addr_to_slab(const void *addr)
 {
 	if (virt_addr_valid(addr))
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 9a6927394b54..377e9c285a74 100644
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
@@ -41,17 +35,9 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
-static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
 
-/*
- * Whether KASAN is enabled at all.
- * The value remains false until KASAN is initialized by kasan_init_hw_tags().
- */
-DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
-EXPORT_SYMBOL(kasan_flag_enabled);
-
 /*
  * Whether the selected mode is synchronous, asynchronous, or asymmetric.
  * Defaults to KASAN_MODE_SYNC.
@@ -85,23 +71,6 @@ unsigned int kasan_page_alloc_sample_order = PAGE_ALLOC_SAMPLE_ORDER_DEFAULT;
 
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
@@ -209,7 +178,7 @@ void kasan_init_hw_tags_cpu(void)
 	 * When this function is called, kasan_flag_enabled is not yet
 	 * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
 	 */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	/*
@@ -227,7 +196,7 @@ void __init kasan_init_hw_tags(void)
 		return;
 
 	/* If KASAN is disabled via command line, don't initialize it. */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	switch (kasan_arg_mode) {
-- 
2.41.0


