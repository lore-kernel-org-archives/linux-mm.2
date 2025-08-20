Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52031CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69B26B00A1; Wed, 20 Aug 2025 01:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC286B00A3; Wed, 20 Aug 2025 01:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE23B6B00A5; Wed, 20 Aug 2025 01:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB5266B00A1
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:36:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87B9F1DC431
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:31 +0000 (UTC)
X-FDA: 83796025782.27.3EDCEBB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECC59A0008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iZRQ1GFv;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSX6B0M/ECg+25VESJMFTz+rvOMGoiNHgeaxc9XIWxk=;
	b=5qUSgH4xT0anLmyj4FxaYS8l8ahOV26nNdfYqhow/s1UKR/yX8jpYDFo7+prLFGTvAvb7d
	gCaH6sNzUwwxZVHIt8I4ZHulgaCv7V6nRChdp2BwGaaEjLkYKbsCs7Y3iJ0Ch287w7aioS
	c5xYamM6xM83TJSN57P498seonZvgw8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668190; a=rsa-sha256;
	cv=none;
	b=Xl/ncSRBbEYlHnLC0CNVT8BFCDxa3LGoBvclGgmrDtbFQmesa3CmlxWVg5JoT7k+jpTCY5
	yJpcsdZE5ZtSEM27BYR84bst9H3t/00c7aTLhJ6i479YmjDxPOc/jlN24E1hp4xnlrhNmP
	1NSXeJM89+VfUwZ01C0dpamc2G2uOmY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iZRQ1GFv;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tSX6B0M/ECg+25VESJMFTz+rvOMGoiNHgeaxc9XIWxk=;
	b=iZRQ1GFvSFaxsS6L7RJsee2/sO+AdhyB0xjWdzDT07+BWOuzplNqDKTfiLOVIuGbL1728u
	N/BPwsvvVZNNq/P7j/AZmWUNCBSolClFYsfk/nFMxy/GweBVbfq/TaHSSjLiFwZR8OZE2d
	48yNOmIP056PJLhyRES8Mr5RQlHoox8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-GaD0GWmKPR2v39dZ-bWOUA-1; Wed,
 20 Aug 2025 01:36:27 -0400
X-MC-Unique: GaD0GWmKPR2v39dZ-bWOUA-1
X-Mimecast-MFC-AGG-ID: GaD0GWmKPR2v39dZ-bWOUA_1755668184
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6107180047F;
	Wed, 20 Aug 2025 05:36:24 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF69119560B0;
	Wed, 20 Aug 2025 05:36:16 +0000 (UTC)
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
	linux-riscv@lists.infradead.org
Subject: [PATCH v3 08/12] arch/riscv: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:55 +0800
Message-ID: <20250820053459.164825-9-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECC59A0008
X-Stat-Signature: ufywhurfbq91p1u13h1meid961gybjdn
X-Rspam-User: 
X-HE-Tag: 1755668189-678338
X-HE-Meta: U2FsdGVkX18Zue1EYfppmWw2pVh1xm1f8AW9nfv0IxOGz0cY5OGoFUiZQQgcvttGaclB3BzkjeqwlUqh3BWffEB7ktUryHWX9B2+YBTlgvf25nETixsyuRdEW4nf8ZZbQ1BjTbNCs8gO38cmgg7ak6WJcH7n7NAoMFCw+NLcErDogsLJ/XcJZcOltTLarPnD8CgMgHlW9Mkm577nlxj5S052ieKDVjM93jJ5CvdhsLIoQ39xAltOF0ZqpB5iLksiQznitX+FtmvfDXHHh7P0fFJatAO3ndXKA7F3HhMA8xGlQctNG7nIooNcZ0UsXUuNLB5N74LutyMHjDzivaMpcNRo5w8B1SdnqsC648hQY/81Dji2PTExvbcF2PzfSR/gS08ypLTGy3JDGUiYNH6pP34GYuvGxvCrbHrlSLl1cDGtPMAKxr9wajKPNZ6pDJKk3neYibMRTpqqzxWXC0dTWaX8/6yUQwfHzJyJV1sVBE0Y3hMmsMhqJm8Jpq9ajY+9D2OvvJFoqdmQUzTH7Z8hRHl06+1Rdx7H+rQH8nk4MqYX+KBvF6GeXENXhwMdZV7E7gk1FPLCNXVS8HrJ9iw7ubqmB+tq1nAVHsDjuL52lelJEmJxgGhTFuqta7deLmRmjqhC036qwtgBHsyXU7OGIFOz1THaIwVb9GGIjRq0cZGozSvG8Vs6+6xlN+iek5jyy/HRmrH640k4VKFHbcdVCj5CxA9D7QG54ulNOznZJkELciE9Lmvk/Sp/+Czo1+Rvn92JGulgg7FSMRbq7aeA0bbHoaKYxsZreCCvUtTesd73MJevsB1AR09eJLRgMuwgNUuKSwfyqNwuI3MKZe3wYxIP0wjgx75jCFrcOotqJu3ZNMBmJevXzZKkhILTz0lV/KNHT+eW+ZE0v7gYHH3AGAcoj2IYleYoFtoZ6hdFPU5ro+b8BKmg7h0Y9Suj0eDXvdaqjb6NiQCy/QqQFJj
 3NspYhL9
 JBQOjfljJlCI/llWMBCufrh1kKUAZfKhY1rhxp2de5pL8Ls/OxNp5c4onMnfyCyb716AA/g563lpLw+yEYjQfzWG7+/syKIOYsmxk8CtxhCbnvI4Zdm2Qx2K4vTkejDg1+T5V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-riscv@lists.infradead.org
---
 arch/riscv/mm/kasan_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 41c635d6aca4..ac3ac227c765 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -485,6 +485,9 @@ void __init kasan_init(void)
 	phys_addr_t p_start, p_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	create_tmp_mapping();
 	csr_write(CSR_SATP, PFN_DOWN(__pa(tmp_pg_dir)) | satp_mode);
 
@@ -531,6 +534,9 @@ void __init kasan_init(void)
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
 }
-- 
2.41.0


