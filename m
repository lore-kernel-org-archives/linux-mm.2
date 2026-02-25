Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D842AEFD209
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479806B00DD; Wed, 25 Feb 2026 03:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4372E6B00DF; Wed, 25 Feb 2026 03:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3392D6B00E0; Wed, 25 Feb 2026 03:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F93B6B00DD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:16:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C56911C2F1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:51 +0000 (UTC)
X-FDA: 84482273022.24.ECE8F06
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id C25A71C0011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CstRHfmz;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hnbGAm/9+0AQuOsI/z6/MObWdWASDtilCdbwr5t2xI=;
	b=6OLH+WXYJ/X72+cn5/9QDFYA4jUJGGWdc0LGLeJzCDaLg/o4RxVGOMnJ/c9CIZ4uKka6k2
	o3QFPlAIQbDinzbqMQjFurra5d4llDT5kxXXl8wbqY5l9e98A3GoXuTLmZTv5slGw/B/MM
	uTveoHN8zEKXO+rLUF4hk/vRTjEA3Hc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CstRHfmz;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007410; a=rsa-sha256;
	cv=none;
	b=N/uN14wgtUqzfr03qlTmIvtYa6QZ3ESD43j8luE7TBKEMqQpF97A2PC8ibx7gPP2+XzXA5
	VNkRYwUth7ls0lDRXN4Up8ktHDbVsuzpSnQc2Xg4PqBL0IXGe6QM5B0myjiJ8TwHlntMbg
	C4P+Yk/Oi0580tc2PjRG+/fp7MH2yAI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hnbGAm/9+0AQuOsI/z6/MObWdWASDtilCdbwr5t2xI=;
	b=CstRHfmzJW0SAxDBPeC8ZrG0UQEVnejWHsT7+J6zBnovr3XL6d49DauJKhaz0IgqFNeuDJ
	DU9rwxvTwFZH6qTLcBApGqxhQlUbYi5dT8J1vLN5Nq3/ZuIj7q1SzYvHvSt3Fy4j65menh
	a22Uzgw9wwAS5YqRE6kpiUKCeFNa+vo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-kB3PHjUANFi-zOP_mIJF6w-1; Wed,
 25 Feb 2026 03:16:43 -0500
X-MC-Unique: kB3PHjUANFi-zOP_mIJF6w-1
X-Mimecast-MFC-AGG-ID: kB3PHjUANFi-zOP_mIJF6w_1772007401
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6D5A19560A7;
	Wed, 25 Feb 2026 08:16:41 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8570F1800465;
	Wed, 25 Feb 2026 08:16:32 +0000 (UTC)
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
Subject: [PATCH v5 12/15] arch/xtensa: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:09 +0800
Message-ID: <20260225081412.76502-13-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: eCMifHe9XPw-rZ3kmg_Xdt_IFeVJDAbURv1t6qdS5rg_1772007401
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: C25A71C0011
X-Stat-Signature: rr31i6p7u4j4fmxamzj87d6i9q4x55fk
X-HE-Tag: 1772007409-484913
X-HE-Meta: U2FsdGVkX1+8gGPnCX8h5rbAIcFREHPBf/iMiMjFDI7QFFrG5ETEJakDy6jjEgRSA12k6PnoqEBeBHZX/KGufT1jSgx0Xl/7JeoXlELBeNupvEl/NXyDtXf1oAlHf8PEfSOd4CRzoEezM7CIeuguaXpntldTXSr3nn4v8E/5lK6KMuVzzwxz6YpOEx8gVPONxvaC8k/q7RYhYG15kuasMRIf+o2XDMp6CYraqmtrd4QeLSy8gsqZzg4FoOCxAOkRdVtBPKkYx7IWGL2JbVIzR5mYTuAW0cqqhosO/zyae4w9oKFSXk5V26EDC8QvdU78FYLha4utxOtRiFZQ1MHBEvkS/sctOELuVkrDp5KUvOhpfqgZcsScg9A8rnXLWkhND3HQJpRN3PZDtGeU6bY+GPPTKyJZ93Ahl8H15Wqz4DGRz+fKuCPHYq8rc5wZHf+ajTdl5v1WAk4Zs7NE/NTxhYb30v9c7mDqEAB7PBlX7SX9dM4OzsjJel4/R9wWQ8AmDUuGKid9e/YDWwdV2jGNxKqKtuMSx5zLYU2akTaXrnrM12bl8lPr6H+vLEMTbgPVIud131n+s7UEo0xDWwK1CF5jzVqo5hBSX5ErKQPm5N2umFkIIVSZPGU4UVEdAtMHHX7kTjgrhT6S65gfzLcXl1FUpAk+HYazXSHHGS8PlRTcvFAByKh6SUscLqTT1DXLVpDQz2lpHGbO364g/yZ5VjrZljn9NTrmF+x8AXLk3TT7u/GzKrsWw4QOX+XdHWm2f6F0J+SjtcaAM/uvlKW5xY9pEeHM1beTDAGAAuI4WBQvQ7wcTmcBf+mqtOEjew5wqCspFwzEFLNULA3wvr2ijRKycm7ZgeEq/hWG37iB0y7UH5KBGEEe5RzrPY1etlCIjhgEzSr6fuQ3m7zy1UPimY10YaBKrOjA7EUx7HZL6T5Nx6YlutFWGbYlbHxQpHkdrkJ10D0iriYbTA6jx4M
 F5y/zQyM
 kEiTHdFXmTQteAf/EZR+qU54N1rUwJFDWECZglXunT4Itf0Ou9oXjPCJvokzPGjyR5v5fl8jCKWWq6MyM9tXJ5jJcKHvd79HIqHH9Dh8tAc6amWr5S8t/8S1iiUsu1tvwBILM
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
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/setup.c  | 1 +
 arch/xtensa/mm/kasan_init.c | 4 ++++
 2 files changed, 5 insertions(+)

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
index 0524b9ed5e63..eb367b801218 100644
--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -70,6 +70,10 @@ void __init kasan_init(void)
 {
 	int i;
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_START -
 		     (KASAN_START_VADDR >> KASAN_SHADOW_SCALE_SHIFT));
 	BUILD_BUG_ON(VMALLOC_START < KASAN_START_VADDR);
-- 
2.52.0


