Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0C1CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170C26B0092; Wed, 20 Aug 2025 01:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1223D6B0099; Wed, 20 Aug 2025 01:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03F16B009B; Wed, 20 Aug 2025 01:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCB496B0092
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:36:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A837F1DCB72
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:23 +0000 (UTC)
X-FDA: 83796025446.11.B5D6545
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E2D3840008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMLmBRIX;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffaqmFj6s7jEE3FagcYbQXUNvNizOaxd5L//WV57Tuw=;
	b=z4tBJfgSS5kDK9XJPTz2Is+SCakxbjGdxT2iVXYgrZ+D3uQ4w3hMhfpkm9mVxl7Mpfx9bM
	ha/u/jkvs9dTobRZCyOu0oFWMgm3YK4chzMoIMdR9iFFWdkDt2kic9BuODBZj8yMBbNFBO
	R1A3i8p5pg/PDZCj8tG+ZafqJBV1XCk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMLmBRIX;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668182; a=rsa-sha256;
	cv=none;
	b=18C8PN6ubsnx7ScXwRthUmJDxIkdYWAcc88+utheEGbU0qO6KJ49Nfmy8hA8mFOzmVuwRO
	GpJO+XdlX2DlLkpLFwc9qsMquglSZMDqJCe4hgIHt7Ez5ejQfETuorqFX/GxLK9HQjARy5
	kXhyanz29HRuylRSpy79VF6jZ0uXjr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ffaqmFj6s7jEE3FagcYbQXUNvNizOaxd5L//WV57Tuw=;
	b=IMLmBRIXG50KfY9rPG7NnFRj5uSr9HNpSLCjRi+WWaBiND16R8+JcnEr/r+uIohUnqnq3A
	Gx85gAnBQqUPJTRUxxnqBVq8Q/2U94UDoww+mlZOZbd2k/loQfAN20a/mPikvVfYVvqdI2
	3qDUXdKipi83tM9w6JwQkfgXNT7vSig=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-ljSlvNsWPGC2J3sVaEdsMA-1; Wed,
 20 Aug 2025 01:36:18 -0400
X-MC-Unique: ljSlvNsWPGC2J3sVaEdsMA-1
X-Mimecast-MFC-AGG-ID: ljSlvNsWPGC2J3sVaEdsMA_1755668176
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0057919775E8;
	Wed, 20 Aug 2025 05:36:16 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B83A19560B0;
	Wed, 20 Aug 2025 05:36:07 +0000 (UTC)
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
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 07/12] arch/powerpc: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:54 +0800
Message-ID: <20250820053459.164825-8-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: E2D3840008
X-Rspam-User: 
X-Stat-Signature: uunzm74gtf47h6xspbcfy8ctxd89hfdz
X-Rspamd-Server: rspam09
X-HE-Tag: 1755668181-166429
X-HE-Meta: U2FsdGVkX1+Ck8WDb5qcjBzAoNc2d9vbqWC+xyw+OIWKj067aQCHhQzFQBI/dC4kyipRsrHQKKDiWasVJLMK2AKsLO++Er6qJFofD13zS95pFu0LQx7NumKctUtqrUe/F1oxcYX1YFDCj4U/bo60sb5CWTCBfmAHZnBUOXglIszFTC3mCRKngIEgJceB504k2U9EZRwjJ6N8Gl/pQD0ZQicmc7KpWLpbzwsbYy8yYgbyiK6vDtcj2v1XKKpmjsb83ke+Bp5e25Vvg/JHE802VaFBUH1i1r0UTz/q7h1dIzINa7hyQ/8omrBltI+DkiFC82F6h7M9wWlEp63xgUAfrDSv97A8TUPq5pc2PwrzG+MYl5G04aHsQrC6v3ElHOpZvsjAe0cSHppkPxXDABctXqheRnsIA0JVcnXm8iOgEFsLu1bNUyhfoAI01io55J5sP+4EvD2EkWvJ/W1QRS1pCA0o/Fl6oh6YSRIL+obbs19RTiUnmGvu1eXsMnBu113MVxyI3wecxW+DY5rgiWlSl5fUW9q/gXVTQXi2Bjxdt7WjmS0VUAXNkLBjRy6nz1PWbxmRs2kmOm5R7fnsELV3BWt9vDKEQ9TPuJtUuUtDoO7XwWFnaCHT5MNwDyUHt/2pKb0DULhVnN3BO5pu8Sq0YiZLzy5Xq0i6cX6rLSDhROLlll4BAjttNMUkIGQcjsAJjswKdhb1M+808oHpNCjUh32qvxc3CaheHfdz/Bd6E9skpXQ3qa6ovDfh87v9nCMJ95rMQF4xcZrkic7HRfqWDW0ZJ+8qrRio1Qc5kVm9bAGjQ6NdjYLyuh9AmJImbGyjqd9Ol2AgiFTTFAJ0U6AtZzofr4Flh8sM42Uf4tVfiqo2EQGAa2ETI017t78iqKBJprIHx1EOuRFc4dI3OqFxSNI1hb3Pw526PB0vY884XwHcf6q60HEgW3FSUOq6D1H8be4BJko8fqcRVaP2mZQ
 6MQBS9bp
 i4CSjmyEW3tukeFVblWNRMWl75P7xT+Cz67+29bVmMJL8u2f0L4+rOLStB9gt9O4PTA/372Tmsb79nKSp/n5jK1rb4mb3vbzhcsZ8qosU8XhWlVi+4r6S3cF9UEB6lv/sIgsI8Hl7UA13sj1rJNyDyVqp7sg2173tRPDqU85g7R+zmaYmPyn9KjR9Oe5deWhJ/tbY8bnAFoRudFb8vrJywCog6dVb86S3yIjJ25+8HWvG9+ghvmTLrAvhMB5mK9gfn5sbJA4BNjuWKJw8e037gHiGnlYGMlMmSFzb7WpoxRK8Q5vc89ZlQmTD0t+PmV8H7p0THa4rWZSNjbB7TKKuZoi1feNrVz5QAadJPvZcN3J4OJCjck3LVAC5pmCPdEV/ei70LM2IX4FSXsDI7kqMxgSLlsWcIXGZR3/s5KdXGGU+YU/xTIA5d4/DRdnM700722mcOLvdVNJdGYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This includes 32bit, book3s/64 and book3e/64.

And also add code to enable kasan_flag_enabled, this is for later
usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/mm/kasan/init_32.c        | 8 +++++++-
 arch/powerpc/mm/kasan/init_book3e_64.c | 6 ++++++
 arch/powerpc/mm/kasan/init_book3s_64.c | 6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
index 03666d790a53..b0c465f3fbf5 100644
--- a/arch/powerpc/mm/kasan/init_32.c
+++ b/arch/powerpc/mm/kasan/init_32.c
@@ -141,6 +141,9 @@ void __init kasan_init(void)
 	u64 i;
 	int ret;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &base, &end) {
 		phys_addr_t top = min(end, total_lowmem);
 
@@ -163,6 +166,9 @@ void __init kasan_init(void)
 
 	clear_page(kasan_early_shadow_page);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
@@ -170,7 +176,7 @@ void __init kasan_init(void)
 
 void __init kasan_late_init(void)
 {
-	if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
+	if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
 		kasan_unmap_early_shadow_vmalloc();
 }
 
diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
index 60c78aac0f63..1e1c10467a2b 100644
--- a/arch/powerpc/mm/kasan/init_book3e_64.c
+++ b/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -111,6 +111,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL_RO);
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &start, &end)
 		kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
 
@@ -125,6 +128,9 @@ void __init kasan_init(void)
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index 7d959544c077..9c5cf2354c8b 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -56,6 +56,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL);
 
+	if (kasan_arg_disabled)
+		return;
+
 	if (!early_radix_enabled()) {
 		pr_warn("KASAN not enabled as it requires radix!");
 		return;
@@ -94,6 +97,9 @@ void __init kasan_init(void)
 
 	static_branch_inc(&powerpc_kasan_enabled_key);
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KASAN init done\n");
-- 
2.41.0


