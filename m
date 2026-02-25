Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E3F5EFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5706B009E; Wed, 25 Feb 2026 03:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2D86B00BC; Wed, 25 Feb 2026 03:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2A46B00C1; Wed, 25 Feb 2026 03:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B99026B009E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:15:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27C6616051A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:21 +0000 (UTC)
X-FDA: 84482269242.08.F9CDC1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 40B21160005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fb4KX4Je;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krRB48lflglDsnK+MbRSOk31duSyM0PDe9SlLiivSrU=;
	b=yLq+IXlMgOCv67AlzeI4F49V2KTEfzAgymfki4K43IqaU0EGBweUZ97xMhxNOBKxI8thRq
	/P4cY9s0W2iaCMJJ6cljeRJRSWJpQ/jyk7ePbHKDdjXFE0zR0PSF6Tecf29V5a7ikAImEz
	PMJQ/9ou89qnMi9hni8KFEj8yEdTELc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fb4KX4Je;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007319; a=rsa-sha256;
	cv=none;
	b=lhBEI5iqI1CCRTZVKEdYsT2oIUvnUw+sr7CVNUYtnnj+8GmsW+pSnwFrvxX3bq6L/xoWgn
	8w0m4rhH4+cF/PhyAsHffpuf8KTOAOXqbirPSInZtaVPzRxUCdtqoLtZz+c2nRXwF2ZnTw
	tsUh6p62jrRTXyNIcmUyYQmhjzT7n8g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krRB48lflglDsnK+MbRSOk31duSyM0PDe9SlLiivSrU=;
	b=Fb4KX4Je7qDjJs2YC38zXR5CBucR7dG+7UYPdBfuh5bUO6DVSvNsjqX+zsyvlfDUPuksS9
	1kMywKn6iDaPcwjg4Vq80QkN2u+a4EeC56ecgiNYwqE205tI3QseNulYo02HxpaaLMl0kQ
	ajmkVsk4VCDsYcRFLs4oefNXOGylnmQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-297-WO8-mb7BPemrfREQOcvRnw-1; Wed,
 25 Feb 2026 03:15:11 -0500
X-MC-Unique: WO8-mb7BPemrfREQOcvRnw-1
X-Mimecast-MFC-AGG-ID: WO8-mb7BPemrfREQOcvRnw_1772007308
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14EC918004AD;
	Wed, 25 Feb 2026 08:15:08 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 860561800465;
	Wed, 25 Feb 2026 08:14:58 +0000 (UTC)
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
Subject: [PATCH v5 03/15] mm/kasan: mm/kasan: move kasan= code to common place
Date: Wed, 25 Feb 2026 16:14:00 +0800
Message-ID: <20260225081412.76502-4-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 6fn0ZtSPdQt5aP9fM0rdg9XN9RVGdhINC6nd2Iaus4c_1772007308
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 40B21160005
X-Rspamd-Server: rspam02
X-Stat-Signature: p5u4jrmepteeaj39us7kt6pwj67maobm
X-HE-Tag: 1772007319-805232
X-HE-Meta: U2FsdGVkX1/bQbpal6ZKOCUMoq3/Ol7Z9Gq1nC0iCy9Dm2Z7uMB3b8BfhRWEDktQXBOv+F5QKlWc8xXx6xFDnI27qDsnBlzrEUL/ffgODHEjk6Sexisd4KB8ND0gpUlA99S14g3ujPzbry1iPrlDyO6GVEXPPMa8MQ7VrIoXpzzaytcO/zgMksGuEmVVoxiNyZmHlaTt8prE8AJGwL34R/k6NvEwlQeZ4TtTfywXt+5UKsouVi/3HYBsBNmu408vhXO6xtp13cZ7Bwvx27D4iZKpiWz5P6+9Is8pUoF+IQACyG7gWZsF2Lal5JV90M+1eclDRetZ1QQ/YB1fOcRKmJPSh3kF0AIVW1h21mYU0nSRjzH4ZLuIOD17vdDheGJW89229FPvYrRk9ohHnCM+Xx6wIvdcBaAv0uyQfT3zt6hyPX6OlQ0yn+Jvo9e3DDbLCw/oqaHyVgbq30HALNXAw1O/WA+iZFmQjfWXrP5PPaWe1NYvvkkoPBdIENbjMdHJ2J9ZsfZ7dq3ciBoBo0WnlEDHUbShW3/datVTHD7uKpM4UWKw0tTLjjvhZn9+C86i9UYDsiyXIL7Ojp081QSf9BwswormfO0ZnzchadOfWRDKi7+2F5QPaTww8i/ezJXNEN7o2ab1XDI1Wg4iCxPwangJazXIP2tLwLma66q8E/zu3ttA1/Tyx/DWLqk95n+otHM1bIBR2EOl9X8Gl/yPdYEO697Q/NrH8sCJdVy6hmA0GADGb6Pf3rgFbV+9T9YD9tELoJtAVTgjaFHx1aB7YU1TWPP7BTTXOcrxLEOXRqRJ7+8w4wgb2dzZkqZm7G4lprEC04ksb8pvEdpXrIhKD0hMcBNJ/ldcyRNJia0mvojzgrP3AvukUFS2U2XbuiqleeUHbGLpnxitQLeOWMqAKcmyUYpfRHGCQO2azYV2WFuoGtVxgpC45/GsRIVnfhV0AwdGmpkiPmv5gmBDgw4
 jV3TxYgP
 LW05ZmJ8NpvRRwfeQOWGCxWJ2Fw3tF+Oo8Yxblg1eGYLPW4E060rcSCA2yoSG9koTS4KG7sksUFNywhnFoGHKDm2Q6WQOpkT8YLUt84CZ6DDw1xNVGYsH3Ob9XZ/MUQ87/2dMIWexrw8C+ZGVG15bhdq0+Cb8/xQkV7ezWuBoa/AYs1EM9EPJ/JonG7ue96vF6KcUt+tDSpT1brQ5gEWj0oP0meXxqFK8Quy1ooGULksSoa5NAOoOuwIJncY40UIFAx6o7l0CfJ0byD/OmRD573ubU1HBX1CZlTbQzF0kj6l4hgQ6I3bvAQwRBr0zkXMcWSFHYtL3NDE3RLbbIwP9p6YFYjN6iYU0z65N5xQ1k7ySx1X8o0pRi8VdQ6sHbxpXlkQRA8KYDZQLrcpYKv95ez5EnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows generic and sw_tags to be set in kernel cmdline too.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kasan-enabled.h |  2 ++
 mm/kasan/common.c             | 21 +++++++++++++++++++++
 mm/kasan/hw_tags.c            | 18 ------------------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 9eca967d8526..b7cb906825ca 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -35,6 +35,8 @@ static inline void kasan_enable(void) {}
 #endif /* CONFIG_ARCH_DEFER_KASAN || CONFIG_KASAN_HW_TAGS */
 
 #ifdef CONFIG_KASAN_HW_TAGS
+extern bool kasan_arg_disabled;
+
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return kasan_enabled();
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b7d05c2a6d93..0d788a468e96 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -42,6 +42,27 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
 EXPORT_SYMBOL_GPL(kasan_flag_enabled);
 #endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
+bool kasan_arg_disabled __ro_after_init;
+
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
+#endif
+
 struct slab *kasan_addr_to_slab(const void *addr)
 {
 	if (virt_addr_valid(addr))
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 26a69f0d822c..9602ea4861e2 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -35,7 +35,6 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
-bool kasan_arg_disabled __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
 
@@ -75,23 +74,6 @@ unsigned int kasan_page_alloc_sample_order = PAGE_ALLOC_SAMPLE_ORDER_DEFAULT;
 
 DEFINE_PER_CPU(long, kasan_page_alloc_skip);
 
-/* kasan=off/on */
-static int __init early_kasan_flag(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcmp(arg, "off"))
-		kasan_arg_disabled = true;
-	else if (!strcmp(arg, "on"))
-		kasan_arg_disabled = false;
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
-- 
2.52.0


