Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77736CA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6748E0123; Tue, 12 Aug 2025 09:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57188E00E5; Tue, 12 Aug 2025 09:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B048E0124; Tue, 12 Aug 2025 09:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C360C8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:10:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C82E820D6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:16 +0000 (UTC)
X-FDA: 83768138832.20.3D63081
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E3284000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GNi+pwJb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755004214; a=rsa-sha256;
	cv=none;
	b=K1GBTH71tfQwps9/1JXCK5sZP88zOQfhMrhSrLU3rSom/5cl/sGq/YTLd+c4ZzshFLdOxL
	P3ABrz4P3feKEITVZE+2eA5nh5Qjz2lhsmOw5V1KBPuVDUHmWRo84GFY3OKEJF/srqa5Lf
	EHEG9AZcBRfV6taeabzCvxS3/dMdGlc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GNi+pwJb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755004214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMz5O7u0akvXjVncCick/hCZpGXIHb0iYHhbJTqmUJE=;
	b=SA0gN743OsbDK0LoFXuwySx2K82GD8x0gU1AyEXdbWijx2eAtqY/0Z6da05g5CXxijzGSi
	+yrf+uwA6aQ+ZAMnZb9rwgfmIeTY5awTfVDxQEgZMn+vRyjT7SPqft3YjX49elrKVL1ctL
	SG7wvd+uiYbHgpq9Oc6VctO60XiQT2o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755004213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SMz5O7u0akvXjVncCick/hCZpGXIHb0iYHhbJTqmUJE=;
	b=GNi+pwJbXKzI1L4V2/gN3EmZKfOKK1TwxDXUq+M8PgJdr+3UTCwdQYjQtDe3lAXgkYG4Vw
	tfDd1PG5fqlaHKhVslIs6wNTVmrb3Mb/ByI71OQRN2HwKXOqRb/FtyGS+KKfpwRXQY1lDR
	/rzIE6p9B6/AF8HjNbYsN9GK33bmb+A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-087PP938PFqZR3S46zQ-3g-1; Tue,
 12 Aug 2025 09:10:10 -0400
X-MC-Unique: 087PP938PFqZR3S46zQ-3g-1
X-Mimecast-MFC-AGG-ID: 087PP938PFqZR3S46zQ-3g_1755004207
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F303180034D;
	Tue, 12 Aug 2025 13:10:07 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 499F41955F16;
	Tue, 12 Aug 2025 13:09:56 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: snovitoll@gmail.com,
	ryabinin.a.a@gmail.com,
	christophe.leroy@csgroup.eu,
	hca@linux.ibm.com,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	chenhuacai@loongson.cn,
	davidgow@google.com,
	glider@google.com,
	dvyukov@google.com,
	alexghiti@rivosinc.com,
	kasan-dev@googlegroups.com,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	agordeev@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 2/4] arch/powerpc: remove kasan_arch_is_ready()
Date: Tue, 12 Aug 2025 21:09:31 +0800
Message-ID: <20250812130933.71593-3-bhe@redhat.com>
In-Reply-To: <20250812130933.71593-1-bhe@redhat.com>
References: <20250812130933.71593-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E3284000E
X-Stat-Signature: yczqnbcnaw3qncmdzt5mqr6oh4ki3r6o
X-Rspam-User: 
X-HE-Tag: 1755004214-378138
X-HE-Meta: U2FsdGVkX191wpO+wbQrXrW8KUuR4/hMCdvPkiT8S0gV+zgX67o87LiGakNN68buzHCHaQ1xvET7z5LPBtI2sYUTD/0DTa5R/NkIMzRoqQFXR4Z8r5aQE5xuy0zrd9fljhuC2csZEWE1OljEB3Pzol4GqBbBkpL52BKj2ZYOGreDVfxU6w7nyYPWOl+khQkwgsn/oOctEjTNsvtZsAA+tXYy+m7ksMsLVW+EMeZR43uwRbneCRBBhodNkdZWKctuZX+XE74zxXf37wLgDundL5oABe9MJiEoF6zM1j2tEuQQwQ1WLmMISEHQ1WL7EzWRiYmImhiQpqZIp10xVLS9f4dDnUN0Jjl9AKPfyZn58pGmCnTBqahfSW/ZATl1tMGVGbXLZKJTC9h3MNzMlHuK8oWVlypMWYipfyRTeCjllt0ufNJwhpFz0ndYNsnioFCN/Gj3ma7J/WbcW5mifc3Go/2j23crIlkNtv1Q2hfrm8QPwqF4b0zV2pp7XHJzQJkmW+qzbCgEHeswXZ6tuTvg+Qpr/mnpx88+xtjPhaX+kOa7YT5Y1JJzx978OjpfwAaEOaKrY/DbfzVPg4tEWegYkXHCt6CCy/JW9iUvHlJzRA8dLdjeOCrWGAutVxqVmm7RC/Yp+DeOpXSu54Ycytsv75hG3QaJ85oQ1dlH7q9G8ERWXdGst9epnQdIOk481KqAZ8tShDijIOtuLJLEIdRe18LkfpDJNLihdW0nlYqgV3ybfmDqPPbeDI4UNtME5iqOKx1RzwzpzJMPi6vv4liQ8JJlzlHQizUtVSJd4xxeq6EMJw3IT6T9EDN818vNW6ivZnwfvTypbDE2vCESvxMyZnAjK+nBrFA3U2hh6c7mjOCwG4NCZoCOtJSbVGCIltMw7yMaxVhFSIzq5iZoK5Mvm+WvQBFQZsDvwjNbFPzAsGzsNoIrWnGrBytVI68csmhidMl4i10z0Pn2pQcMT/r
 P+RaSQwd
 MK4w2zIR4JzJi1sbtecrpF6SipQKHBuN0FcDwTRYmV25EtjdguQuQk/lvdmMlUQxv3mzIsRaE07aNS9IYB04M6CjjvBsY37T5d14UNg5zTEMJ27EbzIViElAv+Y1kd9ldoPSymeSOFzKLE2ZKMkxv3v/zSO6OM/NGePmoK3xbCyAaastfW0zKzCIALD50ydFMyC8Oto1e+8lMYyzSSSQEILeF0k93BshTXkH0Fzi6tWWRW5kofDaUyYk9iy5DsF1mmsCbSP9fNdCy+oejNRAjmNjneQJRjFla60nZRwrA5d4ScdjRu8H2MciFv6pE995jw+AgudVGC+QaR4AcgDu2L9cV8Q1a2Sk/gdccmI8vQj4Z3FB4q81qfXPVo2sbzRePqf0KKrJhRhfr0TKvWuwpI+O5QRZfWoc0Mkng+OkfrnBgxbO/Pjakotj3DPNLQSaoSvTu1Hq8cxKncrl4Vo63IHuALP6lOm+6cH/7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

With the help of static key kasan_flag_enabled, kasan_arch_is_ready()
is not needed any more. So reomve the unneeded kasan_arch_is_ready() and
the relevant codes.

Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/powerpc/include/asm/kasan.h       | 13 -------------
 arch/powerpc/mm/kasan/init_book3s_64.c |  4 ----
 2 files changed, 17 deletions(-)

diff --git a/arch/powerpc/include/asm/kasan.h b/arch/powerpc/include/asm/kasan.h
index b5bbb94c51f6..73466d3ff302 100644
--- a/arch/powerpc/include/asm/kasan.h
+++ b/arch/powerpc/include/asm/kasan.h
@@ -53,19 +53,6 @@
 #endif
 
 #ifdef CONFIG_KASAN
-#ifdef CONFIG_PPC_BOOK3S_64
-DECLARE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
-
-static __always_inline bool kasan_arch_is_ready(void)
-{
-	if (static_branch_likely(&powerpc_kasan_enabled_key))
-		return true;
-	return false;
-}
-
-#define kasan_arch_is_ready kasan_arch_is_ready
-#endif
-
 void kasan_early_init(void);
 void kasan_mmu_init(void);
 void kasan_init(void);
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index 9c5cf2354c8b..c1b78a9cd0a9 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -19,8 +19,6 @@
 #include <linux/memblock.h>
 #include <asm/pgalloc.h>
 
-DEFINE_STATIC_KEY_FALSE(powerpc_kasan_enabled_key);
-
 static void __init kasan_init_phys_region(void *start, void *end)
 {
 	unsigned long k_start, k_end, k_cur;
@@ -95,8 +93,6 @@ void __init kasan_init(void)
 	 */
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
-	static_branch_inc(&powerpc_kasan_enabled_key);
-
 	/* KASAN is now initialized, enable it. */
 	static_branch_enable(&kasan_flag_enabled);
 
-- 
2.41.0


