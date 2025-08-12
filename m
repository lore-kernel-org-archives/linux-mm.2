Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E1ECA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EAF58E0122; Tue, 12 Aug 2025 09:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2BD8E00E5; Tue, 12 Aug 2025 09:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D87E8E0122; Tue, 12 Aug 2025 09:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD148E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:10:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C1F41402EE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:06 +0000 (UTC)
X-FDA: 83768138412.02.9AB3E4F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C06F20011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nx1ovDjY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755004204; a=rsa-sha256;
	cv=none;
	b=DIeL8FOQQJcY9rSvhPQcNJRRxegfZxRqFgkCeeHg8Ilz+idzzksLW2h/fER5gp3Dc1bO4P
	qgoJY/40lCKO1ypsGGtq5NTMtrdqiGFN3OrjV8L6bBQOJYF37HN9WEKZsGnX1xcLZVCDg6
	PLzdpquZHf/rD0YFs/BNKI9bz/AvCr4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nx1ovDjY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755004204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrKPnao6QnTzTb2pG0ayBWIzuAufBFmMDXfM7PPaads=;
	b=t1z5xTHhQycQDRg4SJ3cet34Kn3cHDPjuf+yGSMcorVxOvCi0M4+8H9flyYiYdiiXoV9D4
	YwtFJadGYwXCowzfHL8OFsfYrqwkv1motI4VElZkyzvpiiK3DG87800HAqs2t8O60EpEGd
	+Os4CFhfmzN87MyGo0E8197Kb5v2Brg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755004203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrKPnao6QnTzTb2pG0ayBWIzuAufBFmMDXfM7PPaads=;
	b=Nx1ovDjYIAhbVqEcAOsTpRBmpZmBrLNXS/IzVPUUWdszVfd7S2hLCQA+c6iJCzRTwGudIs
	m3SzhqKeZYXEZFvTt2m52A/Xp2v0t8Jt0rS4jvS0X4i0QxW8gNPicBTSg+AMbEPsCHdXUe
	22pn3YY36zRKEbtEaV1lRTdPY3BDIRc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-ZtSTzWdEPtKWugn1Y9IMQQ-1; Tue,
 12 Aug 2025 09:10:00 -0400
X-MC-Unique: ZtSTzWdEPtKWugn1Y9IMQQ-1
X-Mimecast-MFC-AGG-ID: ZtSTzWdEPtKWugn1Y9IMQQ_1755004197
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF7B21800352;
	Tue, 12 Aug 2025 13:09:55 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D4231195608F;
	Tue, 12 Aug 2025 13:09:45 +0000 (UTC)
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
Subject: [PATCH 1/4] arch/loongarch: remove kasan_arch_is_ready()
Date: Tue, 12 Aug 2025 21:09:30 +0800
Message-ID: <20250812130933.71593-2-bhe@redhat.com>
In-Reply-To: <20250812130933.71593-1-bhe@redhat.com>
References: <20250812130933.71593-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C06F20011
X-Stat-Signature: 48ddzbi7hxqr6r586ixnc8jr8rpwhxee
X-HE-Tag: 1755004204-985576
X-HE-Meta: U2FsdGVkX1/KCbG2HIvjT2KqiQmkBr0EF2wtHFNsNF1QzsFkXDxn+LK2L9dFfnyxhGByTnMMkuqVQs5G4nZ37aPiSFICyVlSTzFKcbZdhfATRq4JxdO4yV8qiaPCT4bfMkHHfK+cXDNjIhJqkt3UJz411+7udtoD217Lnoa6iNpeRzdfkYmrWSubh6jDnonViOQv6JyVUc3DbDyda+ZNX2uLowMjyrt8ooZ3upRi3xSvDcAyyzk7cFJX9Pm5iD2KvuqwWbUpktXJWc2+3XeTyddfgrZjyA52QuH/1wK4EQBVgl++yF5K8G76ba1W6pVMA3F+GHlCo0D+d00v5GHTJXOp5JsUCRRwjT4t710Pdwl9BcOoUXWkufDFPbu2op/xl4lC9RP6kJX/Xke4nvjH8gk0DuIZlaosjKI8Kk+98/vOCAgNxq1qEqddxbMlaKHiLGv40dJe3JjiGMnyeWefI1h9joO/MrsfO6q2NkLN5M6CBUJLtf8ZukDaeCHzppP8wDNBTPMR1yEynGtBdD0Xnym+lzcL9pyNV0gqgUIuU1QeWW7MmgUW20iTwJiKUeZCkXBOiltgKKooyk9mvhkJo7lIYU8jhteG7QGmut4UvVGin1z5L/1D4wX18fuaTxK2Ri0c0COfITwNvB/hxziwE78mUAnFYIxx1AOwueafeb+vh+NC2RCaxMFlBctEpvMUqhRh4Uyp1ET7A72qrv6nLA7CrjnZqAzqE+cVinB/4KT7zJ42QyHT25kwClFdHO5PlGp5FtvF4Ybn6HbBQgLA8Is6JJS+CMrjjnfykhJPRmUWWop7uabQAvOfiKD1d6U+sjsGaFxzrV885azOoF0KlHhp29uwuYsEzPI8fCcDfZVMdN+lZEclvjDGQxjZhx27qfy9jv051EE8rccfGU55K9o2grgbZ3nvdreOG0GvMnexLRJ6LE4xgeidgWDz2aGymJR2tRYMAnDllSNUhdJ
 Jqvjrmgc
 HU29Dt0+lc+V+5QTM5t2W1QUM//QxFiuxzSNn4JBhZkvfR2IZOBuZn2Vmxcx6VPUOj4Gm0ah2UoON4ioCnfH9zpY1kp8B1WF+Gt+2a9MxxgnaVhJsjsWPawJ4sGZSNqFInUnxxuGf03JNS2ecZViqqBqoPMimeOD/+ToAlBdW8G5Ia9BSFoEYrKdNtZOZDkqjvkKHAaW6vSLuXDYpfzHYmvY6B5kutBBjquccRZh0SCo+0Hp27XttCQ8aH9OQVScac4wgrjZihHNCb3G4MQPa7DNZRLrWbRNRhdWremopb27Ey3vV2Lcgc/n5CBOnmiPmJIvfSxNTNGeLeecfBZVywnL+ag+cM6gUPkcFH9UFYCTv7Rimynth4oUVXp52Q5G0VfnARfzJxDAy7CUwSr2AS/kFy+R6EX1dZmPjmSoxaFx2htXlKwscPLKTNo5ZTNR9Nle3AeKaTAmMUPs+FSJ0ZmPYTVlBaVmlbe5W
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

Here, move kasan_flag_enabled enabling before populating shadow of
liner mapping regions so that kasan_mem_to_shadow() can function well
just as the old variable 'kasan_early_stage' is located.

Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/loongarch/include/asm/kasan.h |  7 -------
 arch/loongarch/mm/kasan_init.c     | 10 +++-------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/loongarch/include/asm/kasan.h b/arch/loongarch/include/asm/kasan.h
index 62f139a9c87d..0e50e5b5e056 100644
--- a/arch/loongarch/include/asm/kasan.h
+++ b/arch/loongarch/include/asm/kasan.h
@@ -66,7 +66,6 @@
 #define XKPRANGE_WC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_WC_KASAN_OFFSET)
 #define XKVRANGE_VC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKVRANGE_VC_KASAN_OFFSET)
 
-extern bool kasan_early_stage;
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
 
 #define kasan_mem_to_shadow kasan_mem_to_shadow
@@ -75,12 +74,6 @@ void *kasan_mem_to_shadow(const void *addr);
 #define kasan_shadow_to_mem kasan_shadow_to_mem
 const void *kasan_shadow_to_mem(const void *shadow_addr);
 
-#define kasan_arch_is_ready kasan_arch_is_ready
-static __always_inline bool kasan_arch_is_ready(void)
-{
-	return !kasan_early_stage;
-}
-
 #define addr_has_metadata addr_has_metadata
 static __always_inline bool addr_has_metadata(const void *addr)
 {
diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index 0c32eee6910f..f156cba818e6 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -40,11 +40,9 @@ static pgd_t kasan_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 #define __pte_none(early, pte) (early ? pte_none(pte) : \
 ((pte_val(pte) & _PFN_MASK) == (unsigned long)__pa(kasan_early_shadow_page)))
 
-bool kasan_early_stage = true;
-
 void *kasan_mem_to_shadow(const void *addr)
 {
-	if (!kasan_arch_is_ready()) {
+	if (!kasan_enabled()) {
 		return (void *)(kasan_early_shadow_page);
 	} else {
 		unsigned long maddr = (unsigned long)addr;
@@ -300,7 +298,8 @@ void __init kasan_init(void)
 	kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_START),
 					kasan_mem_to_shadow((void *)KFENCE_AREA_END));
 
-	kasan_early_stage = false;
+	/* Enable KASAN here before kasan_mem_to_shadow(). */
+	static_branch_enable(&kasan_flag_enabled);
 
 	/* Populate the linear mapping */
 	for_each_mem_range(i, &pa_start, &pa_end) {
@@ -329,9 +328,6 @@ void __init kasan_init(void)
 	csr_write64(__pa_symbol(swapper_pg_dir), LOONGARCH_CSR_PGDH);
 	local_flush_tlb_all();
 
-	/* KASAN is now initialized, enable it. */
-	static_branch_enable(&kasan_flag_enabled);
-
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized.\n");
-- 
2.41.0


