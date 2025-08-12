Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C97CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E598E011E; Tue, 12 Aug 2025 08:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F328E00E5; Tue, 12 Aug 2025 08:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40038E011E; Tue, 12 Aug 2025 08:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF6ED8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:51:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7D34C02D4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:17 +0000 (UTC)
X-FDA: 83768090994.19.197788D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id EBFA84000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/XiVgYV";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003076; a=rsa-sha256;
	cv=none;
	b=plPVSu4KuNN0eWGIYfVjEijl8tyBIwSyyqTs37iNVRODc6+PAWRv3y/J+UC2JwlWbt/tpG
	z73eJTF+8kyjk4plbDLfqg2M3NwMyhAaHRnfIbbJ3SY8EVrJugoY9bKiCvEL3lHQhKf+Bh
	U0pgVi+bXEyRWHUFWt7su8ECJPSCaJU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/XiVgYV";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdpdSshaazL7siJRM8NVIrvzcaBedwi1OmyrckGBBVw=;
	b=bsK5MRR7ZwkxkMCZ48fM1BRFaMmgFop+jbkj8CGYkFH2fAHKrePh3Gr+f2IfPClDjactJI
	EiEZIDn1uTLcMJS8pghj1St+hdC3ARMhURox8mmHJFeZtO2v9NaxXd5jGWn0gPCdEpJfc0
	feq4z3ikcYh20bkVclTPLamP4zjWIgM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qdpdSshaazL7siJRM8NVIrvzcaBedwi1OmyrckGBBVw=;
	b=G/XiVgYVwkKt2fQurxiF+q3Ja0ZDj6f1sasy9HHZbbpNDyNgO8QafsCXMf7GYMx3Ct+94y
	hqrn01WGXrKBhmhBGeS8t6YniOAzVk+zj6L4EkDxOCUCqvWfAYgsBM4NnMZPBeFpdQ0AW1
	syYyNMPBMooevTFCp8bu3Wf7X1Eb2Dk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-3Xj9WACAOs-CFxfowhebOQ-1; Tue,
 12 Aug 2025 08:51:09 -0400
X-MC-Unique: 3Xj9WACAOs-CFxfowhebOQ-1
X-Mimecast-MFC-AGG-ID: 3Xj9WACAOs-CFxfowhebOQ_1755003068
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEB4C180045C;
	Tue, 12 Aug 2025 12:51:07 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 441D6300146B;
	Tue, 12 Aug 2025 12:51:00 +0000 (UTC)
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
Subject: [PATCH v2 10/12] arch/xtensa: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:39 +0800
Message-ID: <20250812124941.69508-11-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EBFA84000B
X-Stat-Signature: ykqbpxuxn17gm5sbrxdtxjxfemxdw4io
X-HE-Tag: 1755003075-814604
X-HE-Meta: U2FsdGVkX1/HmxaAPQXOJ5kLjWIvrC/DgP71wXHZR9bt7SFD37INtjThV2WCxCmtz+XGF/iFPQXysL8Fdg4WWaikmmhd8vkBQCZMQvrh2ze8ltRmlAqGlCTo0WiMlIk72AxWtjlcNG0NppjsYRewt7n3JwwO7JaZogoMelkWLJiXIf4xxThbJX50RBfR1+qsiqCgd00flTHwG8R0Mcg3cdwMXuThyCAi4hfxfgKKQKcMaS5zYg2xRavrlGF/IxX70/2kDzqjhjRaUs20X2q2758o/MqUwrHdr6mvK+hstI+lr68iPTK96riSZdrtiXfCVOMhA3ii1FtfjOk3P4w0uiLDeZWl5fCO/+m8LyRvjA2Zul117LCqM9YpjzlK+PTBRplYyh9xCnrNEYVjSk90fFpPtU3S3csNjPnu+m5a3CLmKqHU7/m1uroNXJpY9kc7YAfSudZuYCQaz+7UtUXQlFiJQdvz5Vq7L4tc8YSmt8lsisxzrcj0hewVaoYiQb0vE90A/L9+LZg/0wk9PP9OLEBQP1dI1aZAiVYo3tnMs8/YvIf775uTsHrwgX2+DqurhIRNZmwtxDsxnkayoWHGTY/PUSQyqaTQGz0+ugYitVu/Gih/2uHXIeeKE+qQdOvKcazup6wef/aOzpw4hcdHaLFlz0lAPmfv0i3GHZzN2iOrrZr36oX554uToioFZV/UAQnq4bQeDfYlEilSXLTVTxG5wkN1NswQK1dlpAhPZI4OOhB40FMtyLkuS0ZDr0Hxsv5g1WSet9ZgttphKCeb++9Et0HTXvPo3HNQZQZ/FO5Xksz9Nm54Mb6/I12gsB0ZOrGjKo+CQjf4+v+WGpjeZMWAbhtU5+MilrqUA0Lg45cKs/Fx4u4XDGtwm76YxLix7ikVHihd17Wob/rM8uSJGEnk72WKwNhYl2MZOaxvYxGhvcw1yClKwp/occZvcK79zpaPN32Za2pQc4iwDDF
 H0dAnIgX
 h1H4uiDX5o2KFu8OHJSRq4p4NiHllb84D5flN7bCixAQDiLf6qo6TlduNOyB5ApQY6OezhtlyiW/mD+hxoAIu57Nu0+OrAC3niZJ+8XIHeXxtm/p5VV7Sg/jGCtQUx0h76asZg/uoDj3Ppsem9h/Z3x7Im1nCZJ2AdULz51ILbQrTQNk4BwI8pZ497Jf4+TuYAnHE6zpvsJ3QFjGSCsG+/0WTG/MuM5RVSEHl3Sw0O+FV1k20LRrghAtpTZDKP1ze4DrVB2VK/EXQwgzs207AQ7WMEFy+GdDrf+X+FHslSIOiPQKTwtjh3QbNXHJZy/EmF+/agssmx01mzUeJhJGTyFmRJnwcbXFYoSUnwJR3Ybt7cdcU4BC4IFY0HAlg9W2ZuxxlqflIFQEIa6tYsx5n0Bj/oQ==
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


