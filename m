Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FB1EFD209
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356576B00D7; Wed, 25 Feb 2026 03:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334C66B00D9; Wed, 25 Feb 2026 03:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D0A6B00DA; Wed, 25 Feb 2026 03:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D75B6B00D7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:16:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1FCF58EEC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:18 +0000 (UTC)
X-FDA: 84482271636.11.C0335BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id C67461A000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c79YTB5d;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+N2FdzBXq7d0qBg17oIVx0hpSGWg6PAf2XJ4iYnD3A=;
	b=i+aKxK5kpEEot427gQVPXIv1K7wHDu/HBi0cQ+53pM4Pjj6op7NeI+dAHFf8N7vocK/vNF
	VqN8qKYbTf87nhxcir506ftfSVMOC0G3lMtR9ln7NE0FxGwFBzybl5LuwABFXfPaJp/52/
	MMnkKSRIf5SZA4Ldfec7564rpPErg48=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c79YTB5d;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007376; a=rsa-sha256;
	cv=none;
	b=0nVIxBGexUwhSkZT+H+hyylk4s0S4xgfTwHyrxCSZFXyz5oI4v+TGG6+XxfgGz1Hwnia8w
	6s9DIDUAXGWHOI64PhzX/VjUOUJxZYmmgf3P0W+NoFD2bsvHyrTDkbHijV6dsdtNOz3qSi
	wdSnd20gZLlufg4KoJ6u1MYldAqzWDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3+N2FdzBXq7d0qBg17oIVx0hpSGWg6PAf2XJ4iYnD3A=;
	b=c79YTB5dADik5Q5ZG4JqorEhC9/JEfKOcUe3+boTm9VzMjkrfWaA+8XWYVRPxq8WmLHy2W
	JNM8tid1psfVpbrtHZVqN1wsUL4TjDcSJsNfXAtR/0IAyStg2BnoxPZvu55T5d/KMVECFA
	vmT8La4yRm3XlOKjmkfibLfFVq+eS+A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-5bDMHpyIN7qY2J9aFw6T_w-1; Wed,
 25 Feb 2026 03:16:11 -0500
X-MC-Unique: 5bDMHpyIN7qY2J9aFw6T_w-1
X-Mimecast-MFC-AGG-ID: 5bDMHpyIN7qY2J9aFw6T_w_1772007369
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C83718003F6;
	Wed, 25 Feb 2026 08:16:09 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50E031800465;
	Wed, 25 Feb 2026 08:15:58 +0000 (UTC)
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
Subject: [PATCH v5 09/15] arch/powerpc: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:06 +0800
Message-ID: <20260225081412.76502-10-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: WzhHRcWcvyZ3oFoYuIfbn7E-j7t7zk-LNfvy8JnR288_1772007369
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C67461A000F
X-Rspamd-Server: rspam02
X-Stat-Signature: nsazh7g3iyr71szmwi4x4s9grwmn55fp
X-HE-Tag: 1772007376-844781
X-HE-Meta: U2FsdGVkX1/sWxqcPieBP4ESydCrBEk6qZ88ElA/KK3mmhkoGU7Bb4YdPDq/WmBcaZ/5ir7AjnL20cNn2iPm3v1tEY0wt4J8wXr/iqg9qPqTlCJcMEfwJMHcLJY1HaAx1WuDpXpKKateahZLjNZk42LFjK6Z/Xl+1sav3Mjy0GlChhFsxwlVSMVQyfTBxRVXRGwgOUeb+d7ibinA4qdSgCkHO0T7hcpw3KkAazkBS005sZci/Hn+OrQ9+y4P33AUbizGH7w4+IIQknOXRBHNTAGCCirm+ZsYlUJi2hYG6LjYFuRLMGwpK0RLSUD0McYI3iivYUajLzBpbhPB8GWvSGJhyNff59zpzP7ufV/zR0hHXazax4TxLuugL3RvCCImt2NOaCRNXmFnpMxl3PrhoiKTxlwPJeoDaB2dXQOdHOPMFsypDFRGSkfDSOJL75kW8IXTlMXJ+FtsvrH+SXkAyBqkMnS9g/helJnwVx4xGp6/DTuIO/wA2Xr96qfNgnwuEkLlfPVht56c6M2opjzU4AiUOGapJZ8eny9cLcIl7UOdkXeqAIuiPJPkZ3E0B8/jrtGMiYvUwBOEylsyp+fpK9/Iwahbt9VyDb3rPd5oSB6WInjC+k0rnoobMD5HFd8hoGtt09+Tuty0LDPD5fwqdZ/7lG3YkvMx1UnwFuAKbRsDxvMaBycRfu86nXW96p71yxG3tvBL511LtzR9zWwwn+e3M5Gd2lJVPW3mJmvrgSWWahJZQfNnNhZOhpBaeTyUoYB6gXkPhxK6+6iYaUP9Vhsa6d/R3vFozWpdJB8CKvVsy7klk15gkS4l6HbOSr2s40IDt8TXMhdW8Ybhi6w7Y0VpSqjQpzI5f9+6hxV9vn1H65G4yJf5byqf8X1VLAzlLU0VsF1XUrXcpypdyNLsM22vZRo4zA0JoIb2PAxzqAPxFAQvQ71hKJIUNW6ee/i0pmm2dggOPonb32SXmGr
 U6SXjys1
 QjdXDvoCqOK10EQc4Lw481DTch1/84uE8Umadf/RIQhtxqHHbbNk7Lsq+vlsb9QZKbUjGFwQNrZEoCbNZfanfqDOsWSWi2BLhPuYSooxDXmUBR0RppHMD3l3Q3/MptkCmXUXnVhV9Bq40ndoMa1t4GXDg4Le2zlYP29+m6Qd3eOTmRy0MQaQnm1UlH+tP4i/m5zRMMLnQro0VpiDMG5OWPg8IzcGQoLfeMJzs7T+x4SqWNSGaZFqv6Qg9TkqIz1TpTIvprjZtkh6Ix33s+YrxKEfIsW17qGUhV9RFZwlRkF/SD8CQJUX+VI3Mww3ronebuxojzm3T5pVSSSs0LAIMWt6NPeh8UDxdBmz7W0m4ztqyd5JdOCcMMhRwFgBwFnngcdLpu35kfrD6y8GQaM8zhLDsx1qZntANeiYNyJn6ZPNINttZQ64bWRA6kzH+lcYvHNK46P48YRMDj/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

This includes 32bit, book3s/64 and book3e/64.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/mm/kasan/init_32.c        | 6 +++++-
 arch/powerpc/mm/kasan/init_book3e_64.c | 4 ++++
 arch/powerpc/mm/kasan/init_book3s_64.c | 4 ++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
index 1d083597464f..0ea2a636c992 100644
--- a/arch/powerpc/mm/kasan/init_32.c
+++ b/arch/powerpc/mm/kasan/init_32.c
@@ -141,6 +141,10 @@ void __init kasan_init(void)
 	u64 i;
 	int ret;
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &base, &end) {
 		phys_addr_t top = min(end, total_lowmem);
 
@@ -170,7 +174,7 @@ void __init kasan_init(void)
 
 void __init kasan_late_init(void)
 {
-	if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
+	if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
 		kasan_unmap_early_shadow_vmalloc();
 }
 
diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
index 0d3a73d6d4b0..fbe4c9a7e460 100644
--- a/arch/powerpc/mm/kasan/init_book3e_64.c
+++ b/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -111,6 +111,10 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL_RO);
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &start, &end)
 		kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
 
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index dcafa641804c..f7906f9ef9be 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -54,6 +54,10 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL);
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	if (!early_radix_enabled()) {
 		pr_warn("KASAN not enabled as it requires radix!");
 		return;
-- 
2.52.0


