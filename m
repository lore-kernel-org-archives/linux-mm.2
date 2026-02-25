Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93103EFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B876B00C9; Wed, 25 Feb 2026 03:15:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E266B00CB; Wed, 25 Feb 2026 03:15:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74976B00CD; Wed, 25 Feb 2026 03:15:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D65896B00C9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:15:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4F231B6EDA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:47 +0000 (UTC)
X-FDA: 84482270334.04.C2A97B0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 994F040004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fkNv/ONH";
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I228xoUl4+ZrgdKCBvI2rCmcNIzmRojWxOXL2gQGmtk=;
	b=Kji/zWbfxGwobede3WoxYDjaBLxRC+4LhX/XUQT1eGCLyANeMTjAGeyxw0Al70OcWbBOsz
	jJXf2AACahFDPaF2upkasX3F0ma/KJ5pgH+q9+hWuhQlRsApCTB+qdpM/dqsoC6iroYsw1
	W1z6fU3FgMTKmkob+8bAgmc7Y+MT1Yk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fkNv/ONH";
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007345; a=rsa-sha256;
	cv=none;
	b=3h5nLP1OAlwF4qc/XWyqfv53e0qpuVfoIaqbWZSnxLGqOIC1lZpfVS/5ZIk80Ar73w9OeI
	nLXSMhBdjVX+Y8K4Iw5Y8WClIC9af0h6NhRj7FIus+l8AChcOS8Ttl2Em/el7GGfqHGizl
	jpYSSBFjlKdqKIzZ4U0hsx/U3DA3QD4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I228xoUl4+ZrgdKCBvI2rCmcNIzmRojWxOXL2gQGmtk=;
	b=fkNv/ONHLOlS4sNVnAsfoz97ySa718zug7dXz0M1sg3nthKx15Gt3t2Uu+wK2Xv4Ri1T/x
	FUqrqm6DjRnhEOr+FHYn4IZUgysxlSuDnRBMJG2j5AHn0SOlhZRK9xV7VyLVjlnGdatmG1
	tyu6WuTA6Rs6N/nrdQ4ZDHZoW91Y3UM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-rwD-1e3zOqOiSldVPhFTdg-1; Wed,
 25 Feb 2026 03:15:40 -0500
X-MC-Unique: rwD-1e3zOqOiSldVPhFTdg-1
X-Mimecast-MFC-AGG-ID: rwD-1e3zOqOiSldVPhFTdg_1772007338
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01DB51956070;
	Wed, 25 Feb 2026 08:15:38 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68EB31800286;
	Wed, 25 Feb 2026 08:15:29 +0000 (UTC)
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
Subject: [PATCH v5 06/15] arch/arm: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:03 +0800
Message-ID: <20260225081412.76502-7-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Hm8lR7OtjO3ABnV-0nFs3qSdJpFJR26hrSyhrRBvY8k_1772007338
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 994F040004
X-Stat-Signature: f8zmgchdxmtfyzeqjihp58yh9trh68mm
X-HE-Tag: 1772007345-724183
X-HE-Meta: U2FsdGVkX1/QIbXgkUrvAbMHkgzz83ktNFEvamt038iKENVYU6EQ7u1tXeW2V0PvVnOzEnr3ltNc5OQJ6/cWrG0YR7ShKCsP7a4hyTbt+gay7e3Pkn+ER5sTfeU5scd4yXmQSDUTYqFln5ZG4EtbwuZMf4V6+4qEEc/nxADlHmrnAk+0lZwiAIJj9Yo0kX1WgXHPP4uXKnS5gMtquT7SlQdEU4CkLxP28rmA1wjfBE1PXbpvVuNJqq5n7u6cOfdN7BmJeVlUW/oJaT9DAyTTwDWh4GapWji9HkldDsMs7ysDEIa3mupQzbA9c5Jh/4WstMJBKpFQrzGdLlDDN14IIBnHu7+QIXeARm55BDWtJTJxX4oEjtXKLHp1h2Eq5r/8qIYh7kmLZDaoLPawdS+hU2yP2IKEfwwUIFg4VjQ6re09+H/mHB++uek9FCz78go6S7pYmCI6IlQv5tRet+ynMkGL0pWFOA9YTv1tXbedWCRnEF/6CTFeq2OV/OzLhGhkTFkVGmokViJ4ueIgAufcdMmfnhHo2QvT4IA331yAoMgPv9ebXbWxmMBXyXNPdBS+nAQ5T9kRWz75EvzwfJrAOIsum9t89EbhVWEN9bRVPl0aduWQa0cbw8ojMAq8R4zB9rlJ5k51jHALOcj1TGmPoCtCW01LqaMQls7RmMQxQDC69nG79Ih6TkcL0tKtGKc0Z6dvWsE8keCb15m0X/cBOH5YzWo1hMTM6uPH0VywsHdI/vxBxV3VXQbcZZjPE2QkXrbs1Cz84jLsZX4u1Y2WjvXpVGq8ltatx9OPdePU+tLBoOjwqJlPGGHtKP9YXMxkjIH0RUjW5MxmGj4yIFJwFsdlgt4Fp5m6PFsHQl7zWBrflI5azgn5GYMOJx9SgxneEB6iA67SRx36dxQHaayL6TCe6bb4Qn5aeO51//uXOxIwg5/DBnLByhk6XsrmaLIYcRVqZYJW7tInxu/S/CN
 U7+UZ4EM
 VAHrb3dfUX4P/rGs19rdRb0e2xV2OV2jWrS3rftRdj9uDIheBq+0qw0KVO+ig9HkKWsiIf4jkmHlWBVlmxfMfrzctOvgGFRf78mKaiNN63hq2tlbHIEvO9YFhp333VXsC0tLdHonOzCKMyD1h4gdjE27ZI2dStk6g9ASKH8vMv8lgF+RSJFR/zUxcrZV1fadC9sX5btuibYRc5dS3HbzWBGoZK77l/7h6WKzZWB8ysVK31dHhaN+L0YNX1w1IRXMXDzOLl7PmKqHr0/zsXx4XpsLmG82fr1KzxuOecCyXCNdOVOoBCaG3QoLq3F8cE+bM3zG4NzDD75mI8NvaTOcYjQJjFwW+iTKwJWuZlgKOva7VwzM3fa9iZPhU28tWI7HCojSA5gFF0rXpaOUQBiHwH03qHjXPdP4Sv/TmCr8hGOmTL+N9Mi395RWduxhy8TvGTx0fckNIOuiiNS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

And also call jump_label_init() early in setup_arch() so that later
kasan_init() can enable static key kasan_flag_enabled. Put
jump_label_init() beofre parse_early_param() as other architectures
do.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/setup.c  | 6 ++++++
 arch/arm/mm/kasan_init.c | 3 +++
 2 files changed, 9 insertions(+)

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
index c6625e808bf8..82ec043c891f 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -212,6 +212,9 @@ void __init kasan_init(void)
 	phys_addr_t pa_start, pa_end;
 	u64 i;
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * We are going to perform proper setup of shadow memory.
 	 *
-- 
2.52.0


