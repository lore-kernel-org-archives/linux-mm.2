Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58688CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06788E0022; Wed, 20 Aug 2025 01:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7688E0011; Wed, 20 Aug 2025 01:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD238E0022; Wed, 20 Aug 2025 01:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB7108E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:37:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 960151DCDFA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:37:00 +0000 (UTC)
X-FDA: 83796027000.17.F221D68
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id BF8081C0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fe1y/WEh";
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcfWxvd2gMUp9MiHd8sOWfFMV/Om7sFRA8QIIlclSZk=;
	b=dLojpFFIfSyAiEA48Ufb3UqiUVWvW5/6DSoWmSZEvAmj60z8eHNdjvQXJjYbY8g5OD6irn
	PebvV3mqtp8ri+Z1fq31pHBdMaddkiU//6fzXWY4LRIIZkqZ2dI5kBMKSDHObbvf3uo4Cx
	xiIYu8s39hCDkeWHB8e/4n7/ZYFGfaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668218; a=rsa-sha256;
	cv=none;
	b=m5qee5QHD/85jN6rNvH5fEQ6m7ZlxkB7ZTYrgZegQeN47wev0cAqnOud6Y+qoMNN3NaVIZ
	uwIcqCXtoIqr6ZlWKqpNqTJwaRiuy2IL5muHy18tFrXhMBaPNtiAr2AVVseV5T9EAf95ye
	ANYrDtGcrnXX0LZGFlySIzKcs/5cCq0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fe1y/WEh";
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VcfWxvd2gMUp9MiHd8sOWfFMV/Om7sFRA8QIIlclSZk=;
	b=fe1y/WEhdTpdBZ8Vk1954PPLGm+3a+zxth7MToZ+VofZ/4VZ5zyTq1CLIzxDohc6XDRvA6
	76ofxkKXU9AYtTZRsaj1fS2A7sqiUT0dZQudUK766/3WRxFMNbEEUe0RzpBz9N+Q3WcVtj
	OAYs2Dz2sErJrG9i5saI398O5dIxGkE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-kDHKpYH-PcCG6_xA3bDyRQ-1; Wed,
 20 Aug 2025 01:36:50 -0400
X-MC-Unique: kDHKpYH-PcCG6_xA3bDyRQ-1
X-Mimecast-MFC-AGG-ID: kDHKpYH-PcCG6_xA3bDyRQ_1755668205
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26AEB1800346;
	Wed, 20 Aug 2025 05:36:45 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B28D119560B0;
	Wed, 20 Aug 2025 05:36:34 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v3 10/12] arch/xtensa: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:57 +0800
Message-ID: <20250820053459.164825-11-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF8081C0002
X-Stat-Signature: 99kn3n8wdt48sq7rkro87ng66h7tq9ks
X-HE-Tag: 1755668218-713318
X-HE-Meta: U2FsdGVkX19QbXzTlRzwkbV78mXZUQiTORK0Wm5SxyBe4yUavN7Fp9/GhgJnO9i4xIdzjcicaE7DwYTXJAAQtOdjvkW+jDcdxfb+QsRQjJtmz3Cn2srjMZpJMvsUwN21AXnJNurl8ppu9y+jP2EY8A9Wzw4G2LFMzcNY5FMThWb2aIakfFeTYPvnkdQ1XHEWhsUfuqchCVZfxxdKGDYU9c0r9hJdY0+ii0IRB0Bz6vpE0dDn+dGbXZJEYzqKgBhYvYcT/AtOtUEn27fJZktV6HJuwWSI0WyR567FOTblggGB2YBdBpp/sKybrx2ZI4bar47Fo2MeOZx7+7tiBryvfXy2ZJTLnYXeeqxPm7uxhsFv7iCV7ScpCtN1I2kGhl/cZSeVERXX1k1Pk/v/dCDb3Zxd/8s95kPS7Gf0wLjNxZamjIe+dGF/NPxt0z4IRTM4hJQQA+ssQujRihC6HGY9JH4ywFLc+XQ7YEUjVVq90ILf+fek1Y4aibBXCb3prOeJPwt2wtsc9g9Xwi0zLofUCGJ+ItDiKTMja1b4qE6uTrxw+ysXpW6W2loOX4lkJiREfwFErxspXHjO4/iGtenq9fZ2HDbqDeG0455I6t3tI/PrtM/hbTHv8y2VQXvIzDl/bu3GSgVHotGaGXA2aCMVloeOqvdkxBctcdWXN0Jao2ZR4XrAdDLNVCjU1G2ctcEm6n/hv+dX+WMLCEZRi0sPrEI3TSoORf9OM8jgJRMBYf02Q9BLIpClzdWgzvZGeRm9h1g+zVcMDwcZMTqyA6Mk8QfwlmrVQHLTjTotbDGZ78s6CWdfuZ+j1WMvNDZalhs7dDYlr4pk646GedcNZeC6gmWfyBjNKvasemyXLZaIHA/WjSDSAPxfymyv/8xaQYIo6udKen3gt28fZu1HM4f+txE1sNPScFGFC+PTxSrMwYCjU/E6JM+1sIL9DHJARqJCfensMG3K93haht/t9KA
 5UbKuaCZ
 rKYdAWzBrg3rdQxSgcvy1zguLfYPWZqatZijWdtRPI7PlSRl++zqAVJ3oHSPpd6auBriq6BCg5MEPYpqiVRrZs0dKMH1pxclgKUc4yALXKReKbGjbqV8GmU+EUGtmEQgjvIAfHLIL55WsihWNn/qq4gkd4cox5qSPOLZwvQBZTpiE86t+GlwPX0ojvt5SNCqa9a0qnk4qvYuqUKGP+z58W7/h40Fi/H3hftuPG3QzNW/dTomwUG/N3C/GyXtX1N4zWGYx0mXwzVG3toZeyA4KMD6yvfjxaFCAcw0kIW+VcUTb3hC/cK6g6PxXT+P+lq2k2KVRkbJBf27KgWn/QrKuEXYGo1Zk7iBNizq+uAFEd9nkk6xCNxG0cjB0co7zLQPF1QbeUIHmqeaQ2KDMUV7m764E3tHoUoMgLm99+qSu3PM4FzSR0XqE1Ba6Dqxwd50vnFUD2kcqnpqZivNVvjg+2c6BznVZMkxCnljF80PXC0QuWdI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

Here call jump_label_init() early in setup_arch() so that later
kasan_init() can enable static key kasan_flag_enabled. Put
jump_label_init() beofre parse_early_param() as other architectures
do.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/setup.c  | 1 +
 arch/xtensa/mm/kasan_init.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index f72e280363be..aabeb23f41fa 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -352,6 +352,7 @@ void __init setup_arch(char **cmdline_p)
 	mem_reserve(__pa(_SecondaryResetVector_text_start),
 		    __pa(_SecondaryResetVector_text_end));
 #endif
+	jump_label_init();
 	parse_early_param();
 	bootmem_init();
 	kasan_init();
diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
index f39c4d83173a..4a7b77f47225 100644
--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -70,6 +70,9 @@ void __init kasan_init(void)
 {
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_START -
 		     (KASAN_START_VADDR >> KASAN_SHADOW_SCALE_SHIFT));
 	BUILD_BUG_ON(VMALLOC_START < KASAN_START_VADDR);
@@ -92,6 +95,9 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages. */
 	current->kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized\n");
-- 
2.41.0


