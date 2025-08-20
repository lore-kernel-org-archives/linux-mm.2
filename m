Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EC3CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E192A6B0010; Wed, 20 Aug 2025 01:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF05D6B0011; Wed, 20 Aug 2025 01:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF9A6B0023; Wed, 20 Aug 2025 01:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B8FF86B0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:35:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B8751382DA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:38 +0000 (UTC)
X-FDA: 83796023556.25.80E4B22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id B0BEE20004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GLSPaXMh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEDfd5YwQwP//qNNRp60/4j9gVHcNuQdiFWm+KANNic=;
	b=spxjfEaofuApwWl/hIC8LapYHrzDaCcHwtX8QSukHbR7mzq6TKsS04+uZ3EZ5uF7G6+k+N
	R881keaZ14yCIVIhoSNHuFPdzKvGczP1CVLDpF0tzbFmG+oA57DV2RkHcQT/y/6P61wDhB
	rVddkdoMQVQbdSRgP/fcX6aK2DqLNrw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GLSPaXMh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668136; a=rsa-sha256;
	cv=none;
	b=qSfiYt4J0L+8hv+ur4xx9VqKbRegr9hyHOV5ddxOsuixkDM+3b71io0EFh1KOHyUaHk92m
	gztY4isx7JQWW69O8PiKQcYTJpj0jsu1khLOLbtxUGc8Z9S0wumemSDwjqg9+lLyTNX4Qo
	xy2WESx9IZhm45aaSbTgJI1JWxICFN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oEDfd5YwQwP//qNNRp60/4j9gVHcNuQdiFWm+KANNic=;
	b=GLSPaXMhCkmAJDwvXEolzNn94Np6/CJ5Wwdr9FKXir5F39fY9NY1HrSJ0Mmcf2OX5Rb8jg
	jNbBBdXa+p5MZgy//VzCtTwqtExEz+7y4U88vPPmQnZrRbGtGBe/r0ggS3DwHPqL+Zn6AR
	BPZiAu/qdWEGaYK+poL9GO70l4BWNhw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-210-apjXEsCbN2uozEJ6S1Khlg-1; Wed,
 20 Aug 2025 01:35:31 -0400
X-MC-Unique: apjXEsCbN2uozEJ6S1Khlg-1
X-Mimecast-MFC-AGG-ID: apjXEsCbN2uozEJ6S1Khlg_1755668129
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D44CC1954203;
	Wed, 20 Aug 2025 05:35:28 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B85D19560B0;
	Wed, 20 Aug 2025 05:35:20 +0000 (UTC)
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
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 02/12] mm/kasan: move kasan= code to common place
Date: Wed, 20 Aug 2025 13:34:49 +0800
Message-ID: <20250820053459.164825-3-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B0BEE20004
X-Stat-Signature: fs79xyyz9395ctoxfqqsia6y41ccwgup
X-Rspam-User: 
X-HE-Tag: 1755668136-819182
X-HE-Meta: U2FsdGVkX1+1geNoYSC/bZXlYPBfLUk3H4x7oIteADa3KxdnlBVPt5m8DN/Rb6+qy2MtTltptJmaeFEg3EZu5xdU9Qq+ZM3uTtGo9tV2yYg3XXNum30oMMf3PPShGazfCIld5vrkpz4ecsnb22xnw88nYCqdlKa0CTNp1C+aBqBvu4pfKv5dvokNz8P4S6inlRsOS7DwUT+tmteuQ2mwmr+JrBYibIlDJx5+ZGGwEkPOh0kqLz4NfEDjsXQhAjayaixrigfFeqnAwZ+JCWdtRwez5KXOUyrQX+LTCj316IcWJNfJPiPKheTYwxVh4xfy0ixoSC1T9a+JiTNxxAWx+N8XxEQUsDnh79yTR+kYovHWOhB4FD9pgRyn5spMEEgVhkQkz5SxIFn47vrP4b3MTeUlqVj8zMLpGJ99q/+g3+h54A80uSrOp4s5rCl4R+DHtfR+9wfnFbhkx5TUPcqh2kPk1sbmKi96Kszq8pGMDnc0bvM+4iVGVfjr7eLOoZyEOr/Y5nu9an3Ur75PurfDp1LiKYC4JB26SpjvRCnpD/FcmXzBmlnYxZf0jF8SeIsG3RwgjATY49WyoR2ImwKLiQ8/La+tTAQdQoOqo9dfY1SRenU/cealhRo4Tj2GqWBHgZ7PcDCcjTAreL0CEdgBkdHlmsBFioS1Lp//42CyFKSro5ilNl4oJGQnRY9P6YpeVb4aqwrJLZa4oCcagng/xQtlSpxcFfsdt/YHvbjlhW/55eamVS5h8tddkYZMYCr3LkVcgnDebP2FcoA7XJjz5eHG9QkZO3UhwYIr44nrncwpQ93YTsWZw8B4mj0LsJZZe+BPDfSIvPZLMMg4Cpz8bM1UfKooxRxX02i6h7oy576yqjbc0rHE6M7+8PoUvCIAUcIjkS0uOoI1xmg9qEfLTqCfjTfuf0pOANAomdwpERevv6TwEd/ydJ1QUZa9j5nbLtxoYptNXJQ4I6ugmne
 F/YTNesI
 r9zU6GQHbFEZrbwq+2TlnYJSQ6dlnN0iz33dpp87B3noQ/QmfpGNUt0CV2AxkOLKKFD5ImEzpKtYjqCD2/17ezitK4matmbVNHso8U8BmP7g4i6IYtKURj5zvl1pCVkpY16E3f/SuvSw9H4hGlzv9mt5GqXi86QqhjSBVKGRTSoFjwYAAGbp1aozC11tqWgD4TO603I3ZVvHlAWxDaKzBAcbZF0+K9gJ2OlgEkExrsjjIJ4IsuC+WYOyUuomyJ+SGud+EfMKNWMvB8pEku9hjqfemF7nI9CWtG5DaSclAF0ecnz7/EByHzWbTrUy9WKMag6qmvD7oMcba3RIA4FOd6+liVacsBoG2rCR0WS2/43m/APbuab1SJ2ySc965TNgvtTrSxzsnmFi0f8Ujn1INPGRoTg==
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


