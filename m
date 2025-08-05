Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B9FC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A528E0002; Tue,  5 Aug 2025 02:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B7E8E0001; Tue,  5 Aug 2025 02:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BA68E0002; Tue,  5 Aug 2025 02:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 302EC8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:24:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2AE91A0BDB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:24:02 +0000 (UTC)
X-FDA: 83741713524.01.1161201
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29A9E140009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:24:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OcbWbscA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754375041; a=rsa-sha256;
	cv=none;
	b=CL2BbMXzbl7RDyydM8JliiIzwIArtVAgIOikx5ETBsfF3gk6EJu4Ed7s1lTeTmY4b5BKhs
	OkeWpdQ9KzNdzgq+0z5JEuuygk5rInEz6RRAlJ2WTAug5GDvnjh9QwH9HEJuASvi/MMmh5
	iJHh7XVyLql92CmNDZMm9jECZ0WGb2A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OcbWbscA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754375041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZBsPQV9kOkkozOpLxZBEzL8oHtewXXrqpcjTZWsiRU=;
	b=r5C22dbLbUY1p2XQP7Q8vFtkTr7mJIumbwdp0FBRmD1nHe+90IbNRnfPkR64zBjrG91WBR
	2AsdvwfXpZuSABCGB2LHCHuNt9zOlY/r/JW9/3efQS+js2vCYsykuLPWmU84N6XoEnKYkE
	jMJJyObo8rkOClMVUwjcdedBpdC2cEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754375040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZBsPQV9kOkkozOpLxZBEzL8oHtewXXrqpcjTZWsiRU=;
	b=OcbWbscA+tClOSpRJy3gTFFu/oP/XOPYUuUygY4G0Y13kSYD6RaovQviD6ZeBJYDlpOMti
	27viEuPaaEMsvzhGoON/BvNZTj3Hcmacd+nGPeQO+/xhMQgs6vClYDOL/NcDne8Aiiuzj0
	so4A5XtGGKWvW8KHaKn5jPZgmyQKwY4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-TZy3PSbmM6WgBfqMCjg2Sg-1; Tue,
 05 Aug 2025 02:23:57 -0400
X-MC-Unique: TZy3PSbmM6WgBfqMCjg2Sg-1
X-Mimecast-MFC-AGG-ID: TZy3PSbmM6WgBfqMCjg2Sg_1754375035
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E55E180036D;
	Tue,  5 Aug 2025 06:23:55 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.136])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C857B1956094;
	Tue,  5 Aug 2025 06:23:49 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 2/4] mm/kasan: move kasan= code to common place
Date: Tue,  5 Aug 2025 14:23:31 +0800
Message-ID: <20250805062333.121553-3-bhe@redhat.com>
In-Reply-To: <20250805062333.121553-1-bhe@redhat.com>
References: <20250805062333.121553-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 29A9E140009
X-Stat-Signature: 57uuqpmhqdw3wd4gx4cscm4orobdcs6y
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754375040-399039
X-HE-Meta: U2FsdGVkX1+6hYOSrJp//qV8XhNrTKOHBpaPCuuwwqbXtHembQ/ZrQc3g2I+grgdo6kxuJu2FfUhPqg+Tuupg8EJXrjSwgT8L4lRTwNL7H5fwJtYehYdtIU+AiuIUGa3Fzi8hV68CjZHFlkJWg7zt11fhvnvWFhWnvKHH8c7Q2T3ircUt/yZkpoRy/YX/wWcXAhs4M3HAzTTUZkqrlexx4PhCVhd/V4YaAZwI8s2PtV/+IZWelfTIQF9mKnA5ZTSCnHDoj4e7WcRXUaQda0DFiG+mt3ny/hszi8kvcVfvCWZMaFZEpgyy1kftrb/ViDlpoGMvXAN3AGVdAdQPLjw4XaMBqt3m5UNLDdAh088x8O7WTDuNwbaYrqgYVwhfnXPOJ4o8movtyg1bqrGzhUsgv+cM/2SZh8VTP3MoQABaqYp7M/3ieaI9QyjZb6Wz7zyeeQW6Q6VHCD2/tYjuXSHBd9pfJIguyTNZytasMI3FaTAGKhfflhGjLuUMOoORaA8dJr4mbnN+VVk3SfDwUeMMJiSVR0IaEWL9oruoGvqzJM0oJ+gPukA3EWamCfqCsfE/WL2yb8IgNE5PBsrZM7MFnEzIZKDlSbiDXJ0EKLnKlglYNiohabNOCd/+v1VCnxUimKYqsCgHcT5AHuTlJQxDnNUIvKWgC3CI7rx5leh0SXGRCF9Np2Licv77/p2ml5sQ/fTH1Sp13piMldPT73bU4ztpON7EAn3NIXzX9PDBHxRSP+kDVn1jJLsdO43A02BhObsREEQfArh9wHcheXEbPAssRSHxF1nezlCZw9qSWHKvtVeCeGQQSkNRdVzF2aZCRIPKghrqdYyk6uYaLH1Q/EU3xE/e+mUkaDVivuvnUAWKBDW84EpEU01N8jZlqC5K6QiuaixF77URlOaUPcvavO+MYJYD42RccCYkDK7G/aw4sU9UyCHaHY15h1v9BCZIXZv5Cub+d9i9zcrgz2
 Y4FibsTi
 09kMbWgnLTmyhRFUck/RzfCIWcBHzx8WY+X1RDzVnOtzybe8+R3qPTSd1zNX0gjTcZhtKg8zbMoHINQroTO2AW9xQSk8mFYcxTf/nnY6+rGwzlMejSbfN8B8bRPNtppERn+TX
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
 mm/kasan/common.c             | 27 +++++++++++++++++++++++++++
 mm/kasan/hw_tags.c            | 35 ++---------------------------------
 3 files changed, 32 insertions(+), 34 deletions(-)

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
index ed4873e18c75..fe6937654203 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -32,6 +32,33 @@
 #include "kasan.h"
 #include "../slab.h"
 
+/*
+ * Whether KASAN is enabled at all.
+ * The value remains false until KASAN is initialized.
+ */
+DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
+EXPORT_SYMBOL(kasan_flag_enabled);
+
+bool kasan_arg_disabled;
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
+
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


