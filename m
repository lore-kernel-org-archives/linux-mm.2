Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190FCCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7998E011B; Tue, 12 Aug 2025 08:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860D28E00E5; Tue, 12 Aug 2025 08:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750C78E011B; Tue, 12 Aug 2025 08:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 629638E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23944140313
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:53 +0000 (UTC)
X-FDA: 83768089986.13.9F51726
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50BB7A0002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L3ll80hd;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jd0CGLClfWsUYGgm7aK9F7vU1kBgjVrUFDs4V0d+D1M=;
	b=D+EwJ4ucXaz07PsmGYO4/D/Syr1ZpLGfxfStqChajAL76NVTKC1zAQ4wm3Qtt/rs7f1Mle
	yGhP+64/v3IKllNxlGTBoY7YpLEAwD3cPRe8oggKXN+bwgTGkf42LgwxgOuW0iSHUWj4Md
	B+MR3OGQmcghGPYuGw3LUs5ZFlWvm6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003050; a=rsa-sha256;
	cv=none;
	b=U1VuykmMuKMnPlBjJp/QANKb4PpNuBMuam3sQ/OF6zEweUicVo10ZCyG1ZRLEl1QLbkCm8
	Qs4PRCzZpL/OaTcCpiYNvh1PGqIBTmCcoV3ewjm0sNqFfLoXSOHIgunrwQErO89F1VCilg
	CTHB/tQPVl/j1HWp32MoRXR9oVhFkls=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L3ll80hd;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jd0CGLClfWsUYGgm7aK9F7vU1kBgjVrUFDs4V0d+D1M=;
	b=L3ll80hddIWALYdkj8hTBaAOlF5/+1+SCH32d7I3gad2ekg8qDVTxPygaNQVyQYeDRNtUS
	kz3ohX95/qFEjmzXnlyFubdbBQpjeNGe0RN7ooTXEeMpsqhdmsWQCIE2RNXDwsF3tH2+SW
	4S9D3OwK2WHvAoPv/IIBeh6BMuprpTg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-aJnDQK3BP9GHbyaEUfDmJQ-1; Tue,
 12 Aug 2025 08:50:46 -0400
X-MC-Unique: aJnDQK3BP9GHbyaEUfDmJQ-1
X-Mimecast-MFC-AGG-ID: aJnDQK3BP9GHbyaEUfDmJQ_1755003044
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90BF2180047F;
	Tue, 12 Aug 2025 12:50:44 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 140FC300145D;
	Tue, 12 Aug 2025 12:50:37 +0000 (UTC)
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
Subject: [PATCH v2 07/12] arch/powerpc: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:36 +0800
Message-ID: <20250812124941.69508-8-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 50BB7A0002
X-Stat-Signature: u8scdgr378omenqox6h1ho5rok8i916f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1755003050-402970
X-HE-Meta: U2FsdGVkX1/u1/FOK2h91HLez288iqAy02X1mf+o1BvNiiH+TR3FU6W4YBKXDhnictKmnbRl51TEpTyi3+iIMCNb09sMV0oXMaR7S33YOZDZWXn0K8Wyw8vn4LXjrtCnBYf58DzBWhwq5ytcVIG6fAS1O87NeHwp2WN8DtM1T3c65IA4p6EdLPFeClw5eI77uvdkIUirl1iICp8bDXVsJuCW9CeW+VE6c7b3WZ1EbTZIRK5/gh8eZWON2kZ0SnvkUFWS3JbjbnMBAYWtpZjG/Ad2vsh4HpxHu970iXBb9OIMO10ISgh7rVyeOoUKJ5o1q69uM/WR3GrEx38SEhaj2/FbMcqjkZm6sEL1vfc9JfRa+FnPBWEO0LtsFKB1Ue+iZyICL8BZH0mG565d5xt0t7mVCBhXYV/Ly8fwbTDzA8jVxwdf4otVDdPFUCcAympE7G9et+9WMwVz1Wn32WldULms78e3cnzCuWJcxkJTbvNVespDlvryoXDvQ3liYGBEjeV2Qq8eLyr7bIr2TbmW0nKzjt6QXHQ+VvtVAQq/SEeh0TA1I0bU8ICRjSDhf2L9Vrql2I//ik860TkodtO/SHDsK3BjtwL+FUlaLa7EaKEZWEOnQi53hl6J27C3zuc9MnQXfkHrD7Y+xQKQ1zgoo8FHO+UiggnjFSWbnbrO9m0bBZjkOdez94/9Azs4H8sjy5RfJTAJtIxDCWqfLjldWHa87O8YQRS437hSFWZi52Z0MsG/FKkinbI99otqYJNOMDMnMVL8z4/ScgO2uiZgwRvvUdaKPA7dBDUzTyp9sDixc53lvIXY2GmLU6yqu34L9ZoI3wYJiVaAYxlfZjrtAYi+29Q2rzfTVohvDjet7jYx8eXxCpa6ww4epwfi2zxxW1dzbQakwTtv2JRKKsgiD/hMJibpvqte1Jj1sLH4vAz+ZpzyFQQ84UKfXuAnrHzzPnbnzzZOzmq8m5YFAQH
 +dg1NDIS
 tFSX0VNlYZVDfJRVxssx3MQpJ6W4DFvGvW83Ta1R9moUawuNHIzd+SiOiE8qxTggatxVaLnG4vKr629IS99sp0dx5gOZd5yefQuzO3aoHlqsIq6TBFhKbY8A4DPJiUnUTJfWW0kVQteWzUzziQ9hq7Ok73eBXGzl6XFC7Ya9jfnWMhSws4JmUubae7xoWpOszDcnXPsR+MHSIvhAehu2Cpbgw49POGYpY+jZ/gmKEqHxiws0kxEKno3escDXwTL04AM2T8U/+NKU1fjbL5MI+mood04fIy7kLA9Tej/wJIWcKxF3z4UN4/8FBekpaoWTtbwZP4P7BXxSp/yBVH8oNzunxqJhf7Co29cqcHqHEY1NV/Gqug88KxSzBsz1iYK7FI2iJU7AGnhpmUCXyX7aZBM8HIw==
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


