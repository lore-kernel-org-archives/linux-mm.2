Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E44BC61DCD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA6F6B00F5; Wed, 26 Aug 2026 05:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2336B00F6; Wed, 26 Aug 2026 05:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8126B00F7; Wed, 26 Aug 2026 05:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7D36B00F5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91788140138
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:46 +0000 (UTC)
X-FDA: 85142888292.23.DB2E9D9
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49674160002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M2WCjUV3;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736344;
	b=hDGWKrW4wn6UX6TVr9YjMfNLq2ezJ3Elgx/oDW//dsw/2F+5dd/0mk55T/GEHpk26Ahs/C
	G/iTAHCcIbNWNtP031XUrZyLZ/vmpRFRv1qGlCQGE8Ft0Abp2gYBvP9C2JEhuVUPs8oDPz
	Ac+Q5Z8HPGbsNIuOb8YugNKOyCO4ccQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXgq3/Gz7CGC/Wi4k6l57KKkgsMLlKANbfKYe/2S3+8=;
	b=qDFSdFoKcflixgDdJU58oZgWnmXHivj+nBb8aeRkF3eZYb4Fsx5xmyQmfjgRY7EMFJJnW5
	SJ7zSFUCecDBdoE88TOiAxj+T/5N0w3Swo5sGL/IG+uOYlq+zElzu7BxfWJeGPpVLV8gkB
	t8e+Kxu+i2gG05bk7HE1PMJakYBXEjQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M2WCjUV3;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oXgq3/Gz7CGC/Wi4k6l57KKkgsMLlKANbfKYe/2S3+8=;
	b=M2WCjUV36RnHb5fNe4vvLb2ECdr0SMY463sjrUv623cM5rtnEGxtrh7Jm17vAKP9UZkTNrCdo
	4xEpxcC38LZJXMGdX94QIQPU5uBerz/eQFv4Hc6UV3ZlxTKy/gxQTre5I4ALJj/5VKN0N7CO2JZ
	Dri1ZnSNgYAZMZLggRJdoJE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrf11brzRhR0;
	Wed, 26 Aug 2026 17:14:58 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id CE3AC40537;
	Wed, 26 Aug 2026 17:25:41 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:39 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<thuth@redhat.com>, <gshan@redhat.com>, <jic23@kernel.org>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 14/17] x86/crash: Simplify crash_load_segments() using crash_extra_elfcorehdr_size()
Date: Wed, 26 Aug 2026 17:25:38 +0800
Message-ID: <20260826092541.3905933-15-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 49674160002
X-Stat-Signature: pstpo3wf4b3corgh6njh7cg3o86iz4um
X-HE-Tag: 1787736344-348969
X-HE-Meta: U2FsdGVkX19RptPZ4pTR9+68R4pIXRwVXb9X9uneKzvRkbPhYOEWgztQG4aCj5K1hNBqMH5J/Q9hQDAls/F9B2ZbFcNfO+3H7bdECnwgRs6eg73Fc8yVcVH7Nq3eVsQbX2BYlOhXwxyMob38bCQfBkGLeIXvikKcyEnxqwDDw+8+fDqWb8hPgFIv1lcUqeVfdwsMETz2d32wc0itgUXUvsCo4YtpvflANwpuakQLinIMV/R6Bu9KbvJ3vcU1O4H6U/jkLTU0w7gnOdIIy5Tyn91A8jMiuSD8KMzHDJl/N0JuEqqnMCnVe5D37cMwQM91ZeXu5YsBSfpmAg5/Xf8EhmiDy36T/D6MjyMz/AGUYiMvHNCGH6BKwJas+7bdZI2PVgZzTY0jtct8onnFVsm/k+bLN9WEG+1twTvZr4cIgKoWnu0GbQZ+VZx5SRu+tGXrEgtoNK/ZRYZNHEXe5LLQqluk7d0yZJMDNdUQ9cVRaglqRNZpr4vX7GyAk+h1EANaq1oRBm6U4r/PlmqyhFLhAl6E4uPLp11t+wYSF1qLL7Zb1spiiksrQAVqZ9x34x2tozRDWw79Le/9yKfuqiN+THpq0Z6mEbLgn3lDa01nLVKyPn9twBJypkUEsJhpo7v+nE/ST0CPFxYGaLz0a77b4rTLNYne1a0qxQjpT6CV1+QE+f2+lZiNrdSOD6KI0WPkeDakjEAM8kHeMPIxvaX1KUkORBzxfCEXSChlId7Wkb2OjdXOFtVONg4hyhiWpPE2Ewx5p2kzTNqoxl+r/ABnHgBIz447A9YfAZxda8JMEXx7kQdvR/3CqdsNhhspuBl6rBmdcs5OXWOvZOCj72t4siTPunqmBG6IR0h23uNp5IQgOTiqsv/+G6FF5bxwa6yjeXZ9s2LQHBJyt+LNdbRNyXigKFdBplzwfKfKxXaPZBiQgWKkorT+4WCikr0LDNfO5ztVjbvDwi4VnxMstWU
 K3Grf2FX
 jJtiZ/+B1GCZ/pf3GT+TLIZzQysyoZmx/6hFsdoNHsIjMf2wpzzqWAJ06osGcwW0y7LmJeslwvFwUyRubHqbI3DGScshmQI8AqAQk5pRnM+X1j8R4+fUGfT/96JPPbcAwcInGamX3GhwarEG+y+juWhWDRmZu/svnnCmaYhS09E3QvCmmra5UzmK6uL3mqBj39Fjfq9Tu0u0KOYYjYAe1S889ZQJSGRw1ExIyMfF+VoIAfXY4g4jMY+vttU2J3V6t2h5yIb8P9AyX/zK0nmxxyXCfSq4iJmtrgqGa2TrGtw9UNWBCCJsX98BW378S6Y/cssuTVMriRXvJng2J+lvoxOTBYkMMLPpUKTDn0HlmCPuoH4ykHFGdVv0QF0b1/9CsUPTwNLt1/4saQOEvr9/EhBlc8+T0op/YwNTuO7SeDZL4JAVerQklSR2wlTTrK5UpuwbReFMw0k6phzfCXtTxzcATzrp/vQ2F8nSC3Q5zN1Gevv8/VTZNGc7fsOESU+JQ6u3OK4Nfg1WUD6hZdSdntfM0/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded elfcorehdr reservation logic in
crash_load_segments() with the generic crash_extra_elfcorehdr_size()
helper. The helper centralizes all PN_XNUM and memory range checks,
reducing code duplication.

The elfcorehdr_index is handled separately in crash_handle_hotplug_event()
during the first hotplug event, so it does not need to be set in
crash_load_segments().

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/x86/kernel/crash.c | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index afe2aea19f47..99eb8583d932 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -348,42 +348,20 @@ int crash_setup_memmap_entries(struct kimage *image, struct boot_params *params)
 
 int crash_load_segments(struct kimage *image)
 {
-	int ret;
-	unsigned long pnum = 0;
 	struct kexec_buf kbuf = { .image = image, .buf_min = 0,
 				  .buf_max = ULONG_MAX, .top_down = false };
+	unsigned long nr_ranges = 0;
+	int ret;
 
 	/* Prepare elf headers and add a segment */
 	ret = crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &kbuf.buffer,
-				    &kbuf.bufsz, &pnum);
+				    &kbuf.bufsz, &nr_ranges);
 	if (ret)
 		return ret;
 
 	image->elf_headers	= kbuf.buffer;
-	image->elf_headers_sz	= kbuf.bufsz;
-	kbuf.memsz		= kbuf.bufsz;
-
-#ifdef CONFIG_CRASH_HOTPLUG
-	/*
-	 * The elfcorehdr segment size accounts for VMCOREINFO, kernel_map,
-	 * maximum CPUs and maximum memory ranges.
-	 */
-	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
-		pnum = 2 + num_possible_cpus() + CONFIG_CRASH_MAX_MEMORY_RANGES;
-	else
-		pnum += 2 + num_possible_cpus();
-
-	if (pnum < (unsigned long)PN_XNUM) {
-		kbuf.memsz = elf64_phdr_size(pnum);
-
-		image->elfcorehdr_index = image->nr_segments;
-
-		/* Mark as usable to crash kernel, else crash kernel fails on boot */
-		image->elf_headers_sz = kbuf.memsz;
-	} else {
-		pr_err("number of Phdrs %lu exceeds max\n", pnum);
-	}
-#endif
+	kbuf.memsz = kbuf.bufsz + crash_extra_elfcorehdr_size(nr_ranges);
+	image->elf_headers_sz	= kbuf.memsz;
 
 	kbuf.buf_align = ELF_CORE_HEADER_ALIGN;
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
-- 
2.34.1


