Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A07EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871656B00C5; Wed, 25 Feb 2026 03:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792CF6B00C7; Wed, 25 Feb 2026 03:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640706B00C9; Wed, 25 Feb 2026 03:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52D216B00C5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:15:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D8D51A04F2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:32 +0000 (UTC)
X-FDA: 84482269704.23.FB7947E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 32B1C80009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EnnvQlcn;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJ/15auNTcs4bEnKE4TKOadihs1pA/T7OdgqiTtaDyY=;
	b=r/KyItz69CIlA/dGNTW3uKZUnRcoemp0bz8XQZIL07mOGQ5ywK4qZpEAPvLJg6iBeU1EVQ
	09NF71nEcLP241qfH3t0JWPFZqARTWt49Ph9LnK4ywyz0N4QMtW+ZX6AqAlZQrOEdN0pTO
	SYq7etiRfgMH2MgttO8+5GKfXz/CCoY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EnnvQlcn;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007330; a=rsa-sha256;
	cv=none;
	b=gb1pS+AYJ6BdQK2ldDH/CXpn0WEVFnPIfwfanxuI0a/PePmLrz2pozneSXeTXP4r1BWJ7l
	ACRW7k3a/2S2q0UyAFxpbWTg5CxuRrRzK3FPw892lAM2expYMpIpFz2sFW7RehIOIDmLzw
	FHPzhT+Np9JpzovUSLEdosQWhcJvQIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJ/15auNTcs4bEnKE4TKOadihs1pA/T7OdgqiTtaDyY=;
	b=EnnvQlcnvXG/kzahIj/uUPGHyA6y8E7bEe88bi57op0ezsij31kxu1G7FIRhQdvH42r4Kl
	yrA/57eQDprGLhgHvsVw/YskNccQUsPxXjJ6w4aPqZUFD0rfAudTvMJmOSGyF8HJAyukYh
	CyrUuqowhUtiJ5YK/N+FurQDujDvTxE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-MO7Loi8qMuGy7jOa06YqRg-1; Wed,
 25 Feb 2026 03:15:25 -0500
X-MC-Unique: MO7Loi8qMuGy7jOa06YqRg-1
X-Mimecast-MFC-AGG-ID: MO7Loi8qMuGy7jOa06YqRg_1772007319
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 320AA1800349;
	Wed, 25 Feb 2026 08:15:19 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BFB231800465;
	Wed, 25 Feb 2026 08:15:08 +0000 (UTC)
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
Subject: [PATCH v5 04/15] mm/kasan: make kasan=on|off take effect for all three modes
Date: Wed, 25 Feb 2026 16:14:01 +0800
Message-ID: <20260225081412.76502-5-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: fvIh9ahUPoZbzi1oE_NZt1X1oLVqD1N1CjhFbrhEKTs_1772007319
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 32B1C80009
X-Rspamd-Server: rspam02
X-Stat-Signature: 8m6ne5aiybgn6ot9a1hdkxwwrnog18ys
X-HE-Tag: 1772007329-310705
X-HE-Meta: U2FsdGVkX196cD4FFgI678Wv29457Jc8LBLcXqAOB9TbWzlMv7kMLVn7qwxbgHcuBh1wNKfSU0pQ1D0DapE6Rwf9f9oFZJtVqJbTN4M8wgSnpnZh61cg0sPGSv6nuTYEmyQvZnKeC2hFJQCYYqlUgKwkjK9sOQ+ErgXBGRhU9k8BEW+M1hqtQK31F2pOMmNVx8IHS2G0z+nyoJGqFRSstTp+WzHJ+O9vG/1+z9rmu+WTFYtXou3/IkyMjZfvNdG22qMMC/v4HTDoBmbvhD2dnugGP1RA+VOby+NM7v+W5G07z5meIXg+IuoYcu2HtytKE7zvXZeQ1lx1eeeTZM9eWX+lfRbumgRV1wHegLgtp9/DE0YWLqrusOZriHJu6WhlTfw0S7nOBt1O00KBx76BSoejm3jKZjHCoRTwbATGu5G9Yi3v5JSfTUIQ3WHKJrbRcmyd1odiI40b1s0q+ZD9wSunyw5toQabdfyF9WijSbqdhwqoWCH9UdqAD1pxxQpphz4p9TVPCdw5kHj4Ifr87LAGg/HnyH4gOLok9JDjztRau4t7473CwJNEE8bdexKgaSWkN+7kPaz7lS6T5tZyM+tBQJ1CPZEzvNgE4VjP1dsLZb7eVsAF3nqS8RVheNZ2ROlmDhMKx5G7kkDHD0Gcosk2LhV+r6HURIvPHAcaXuPhz6lYoVMM5EVdfQZFeuccCDPjFsbC6fmwf8GAskbMY8Rk7NGsE2UgByF9rXnAZcsPz48YLJUPjHUKN+tLoZrrdtNYSrRphmIxdygQsIKbKZHzI034hrZoBdukellSntCzuiZ+QWrLskpcj171FYYqIkKKakYZGApImMnHIFc9uN6IpAWo/+dUg7vGqFosJyg7/TjMRy5G/KU/teCVqHjMLVc2v1cHIxPL1fdEldNPxNxonQiRAN5/6PlUZeQkd3aJ4GeB1hS0BuFP5j48ywElYKC5wxx8b1lzk3mFYea
 f+2w+gwv
 SuVQLGLsb5CUqKAvz/WnuRRRYFFtepoc3iL2w6dX3qWfKW/zOGPSMyRtXmO2x6nUuBYe9vjrzqA1YdJiwU0Emff1Yt+UjWMTpIQP5cwPgt3cAXcLyD+gzWszP3t44d9KpkEiQ0FVq3L4HaIfUvQAFwMD5u5UysAiYDFqTtKInDWL+YSpPe7RMsSYZCOWrLIVBZZgIJV+/SHguKcXULpyX08pGILbXULIbwXsb9LljT3pYC6GFop/uKxIGG7P45/XFyd8KdHHDK9HVKVmDmnj80g3M8UNSzoD8s+yO1p7KKImg+uEwfYuNUC/AFkxIt2fayw8W/5Jk+NGU5XBkuOpk8Ys3zkFxpshasrCnmCX9tPfEpy6tP/WfAWLbCdJZI1BkXPU9vZQYYr/1eBXGb2LGPOY6rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now everything is ready, setting kasan=off can disable kasan for all
three modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kasan-enabled.h | 12 +++++-------
 mm/kasan/common.c             |  4 ----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index b7cb906825ca..cec21a08446e 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -4,10 +4,11 @@
 
 #include <linux/static_key.h>
 
-#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
+#ifdef CONFIG_KASAN
+extern bool kasan_arg_disabled;
+
 /*
  * Global runtime flag for KASAN modes that need runtime control.
- * Used by ARCH_DEFER_KASAN architectures and HW_TAGS mode.
  */
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
@@ -25,18 +26,15 @@ static inline void kasan_enable(void)
 	static_branch_enable(&kasan_flag_enabled);
 }
 #else
-/* For architectures that can enable KASAN early, use compile-time check. */
 static __always_inline bool kasan_enabled(void)
 {
-	return IS_ENABLED(CONFIG_KASAN);
+	return false;
 }
 
 static inline void kasan_enable(void) {}
-#endif /* CONFIG_ARCH_DEFER_KASAN || CONFIG_KASAN_HW_TAGS */
+#endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
-extern bool kasan_arg_disabled;
-
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return kasan_enabled();
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 0d788a468e96..fc6513fa5795 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -33,16 +33,13 @@
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
 
-#ifdef CONFIG_KASAN_HW_TAGS
 bool kasan_arg_disabled __ro_after_init;
 
 /* kasan=off/on */
@@ -61,7 +58,6 @@ static int __init early_kasan_flag(char *arg)
 	return 0;
 }
 early_param("kasan", early_kasan_flag);
-#endif
 
 struct slab *kasan_addr_to_slab(const void *addr)
 {
-- 
2.52.0


