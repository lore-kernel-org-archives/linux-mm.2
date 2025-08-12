Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A2BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813D18E0118; Tue, 12 Aug 2025 08:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CD58E00E5; Tue, 12 Aug 2025 08:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665A78E0118; Tue, 12 Aug 2025 08:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5684D8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF3EB1DC0B6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:33 +0000 (UTC)
X-FDA: 83768089146.10.0571A22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 35415120016
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHu4TLt0;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xr/w2mK6l802lCxz4VjyI0YPeCChzTlSQ7qvXcEbkU8=;
	b=jdOFbWFehp+CP4e5ZXO9pJFmdfdOpL5lQDihbxM6zeARfgoePSHZ8B1w26e7/lWu+QYMyM
	ExtvGOxAb/21XSslOZBNOxG85jadtDaBST8XZzZfdIAgpS26By4bDlDIoqVPrSWjsoxCsi
	p6H01r/k++wloZTdBzsUKNTHAdNut68=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHu4TLt0;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003032; a=rsa-sha256;
	cv=none;
	b=0JUm12TArsdG/unUTl+s44bx95eCojMO4NomEEZ7foYXRU4I+NxZ4NyRp4aubrBfIPO8v1
	K3LBS5udXmD50dnZ6STfM3TBweRjc3OKyms43hV/Zd7v98+c6/IBJhT+St5xfTG2z/8vYV
	mw9y/CuxpJ4KuWm/NUlG4QUhdKEvhsI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xr/w2mK6l802lCxz4VjyI0YPeCChzTlSQ7qvXcEbkU8=;
	b=fHu4TLt0M2KJabpuDeJ8JWj0qTDBvZpbP9OIJagWYZ8opUTXZAjXxmU80eBUjQxl8QNssg
	o1gKGYqH8zlHCPvPhEEOSn2CjgYyZhvE9q6NOFBzc5FhGNS02cRxGMJIGFCg5zc2ih6BC8
	ZdiPCBRDAs6rtmnnyGFPWkMu60F/ldg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-XufWQzS-Paee81uzo9E_Ew-1; Tue,
 12 Aug 2025 08:50:24 -0400
X-MC-Unique: XufWQzS-Paee81uzo9E_Ew-1
X-Mimecast-MFC-AGG-ID: XufWQzS-Paee81uzo9E_Ew_1755003022
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24E73195608D;
	Tue, 12 Aug 2025 12:50:22 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7BD173001458;
	Tue, 12 Aug 2025 12:50:15 +0000 (UTC)
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
Subject: [PATCH v2 04/12] arch/arm: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:33 +0800
Message-ID: <20250812124941.69508-5-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: chkucnq3r5kqzwoostexcr4zrdwneawn
X-Rspam-User: 
X-Rspamd-Queue-Id: 35415120016
X-Rspamd-Server: rspam05
X-HE-Tag: 1755003032-499279
X-HE-Meta: U2FsdGVkX1/u5tz/QRD+CM05xX5Tj+m+0BkrKJoFAM3XDBep2Y7Y7DMaCG8WcNDNhY8M5lKPTht4VfXwNSRe0QJAxjHX5UuOzVpYvStbOXY1uosIxC8qKooursdfZJzn1HKOcGOKpscW4Y0UOoCZfkbT+xW0BEg3QcmHtFVibXgGYSVH4gjUOhIR+eHuWD0Pq4oay7As/eFfAfi9iyQaJXOpNgQ1n9yt5DSCGGmNu5G/2hBiET6EviyPEZGViodWeGXK4zTVboPryb6/wHfQz5ihcc0TBOCOYgUbVW8XtuuD6iP5ZZbfoU9m7D1Ammx2pKt3V32XRJOGVI/z6ay/rtkkLpKhBsot9p6jaLYuYnoFTiyAQf8t8tO1y8fGG6rQ4OHCuIlqsZU/iwkTKsC2lkUMskWVBz9AHl8+vZ8JdtxwuJoUQke5LNz5N4JjKW+H9n6XN6fMMZpTqzkzoX4c+zttIA6u3LFnKttaqk/Ux5Uzre8AX/biyokDXLaAxRJSBjB/IC4YoKJocYldm+2VPYeBtNrnGBSCNRzyGiy2D6IPJZsRObyfgPZCb1mjo5QUlFd8rA732G79LRLXWmC+ChFSzCOWXQ4nscdf8jyr/knkcgQrAFPOROFiuzKo6nQxuGG2Ien1ap5YzWy0CeuDixnUqfD003+Wjn3ci+a7YKfUDN09JfNG16dk95kIEIIop5pHOQtKAMEEApAa1dji4cJJhGF/iYjpWEeQai86YKyl8l57eTE1MYfsdn8FneIrBbtyr/cGDrNTn/9FUsGu7WDltxrsMvPTNu6NlsakI7vEXIQNxe95x+oIycLqas6CTuS3IKcN+5UbpGb6Y3goLzFQnDoANTFDIbP+MBHutUpiQowFo8Auwi2RbObC0UwOyrIPwmdGphHcZVN1lR9bTZ0OU94PEZzHtc2bZkmYDJdBKaQuMomEKSgdHQnU/wVqWzHyBg4QPFm8Id1gPpG
 84cUVfBG
 DXiT0NkFtO55y3yv7pW5KR75OCIzOS76DLT+kF8TgP8bHZ5+YgG8DTEoobIj7d8PIHKXiUlQ36VKRTtuWxI4klFrPEMkv7gtsngbdgqJ2GSUBOVKTGHPvyLJsm2hfDFt6nfPS
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
---
 arch/arm/kernel/setup.c  | 6 ++++++
 arch/arm/mm/kasan_init.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0bfd66c7ada0..453a47a4c715 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1135,6 +1135,12 @@ void __init setup_arch(char **cmdline_p)
 	early_fixmap_init();
 	early_ioremap_init();
 
+	/*
+	 * Initialise the static keys early as they may be enabled by the
+	 * kasan_init() or early parameters.
+	 */
+	jump_label_init();
+
 	parse_early_param();
 
 #ifdef CONFIG_MMU
diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 111d4f703136..c764e1b9c9c5 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -212,6 +212,8 @@ void __init kasan_init(void)
 	phys_addr_t pa_start, pa_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * We are going to perform proper setup of shadow memory.
 	 *
@@ -300,6 +302,10 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
+
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
 }
-- 
2.41.0


