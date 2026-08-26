Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA278C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8FB6B00F7; Wed, 26 Aug 2026 05:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479786B00F8; Wed, 26 Aug 2026 05:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368546B00F9; Wed, 26 Aug 2026 05:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 122196B00F7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A93FF1C165E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:51 +0000 (UTC)
X-FDA: 85142888502.15.912F546
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE4DA80006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PHmoGMGZ;
	spf=pass (imf02.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eBN1xy3LsTspM2cXc9iihQZgxEMtvQyI2J8OiqZLKg=;
	b=1KvYN+tIXayV/mWrveKc7TyMnaSfY32D312umhcSbTMXc+64OFApEgBWP/jyf0v79SkS4/
	CAjtpoxdfpnCg668LTXcgj9ddX52e3SLDlqt7woIfQTj0XtqxSuRmcnBFg6AFavgc46D9V
	9hHpAKQVBqkkUhKqTFqiQF8laCoPiRU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736350;
	b=74ocqAchRBz7hKHuKhyPVT1yvtLXzQCuSthpA40f1Y9D69X4Y0hmjTERPeFEPP+nQse9vW
	as+bhhQV+Hfe6Z2DQZXSGaehsDI3fUXFWlut1ZIDAY5axLESDZX443/LAdFT/a28FZi2gQ
	M9jBGIjDs5LTkgJVy3tLzyF6YVdnBWg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PHmoGMGZ;
	spf=pass (imf02.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9eBN1xy3LsTspM2cXc9iihQZgxEMtvQyI2J8OiqZLKg=;
	b=PHmoGMGZCpSK83cFfL1l+GZjf/pY9I+6IoZqg3WJ4VLG4xW6NHlRLdZlpXZs7q+S1hU6FgzSG
	rPNsboboV+FxPnNuPRJvY6Ww7D51z6C62ISbmu/FflpvRh5Xiy1KVbEeTFJW1U4tML5IiSjG8eN
	PcED3zgeHCZOJt4Rn7qsZuQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrf6YSLz1prN4;
	Wed, 26 Aug 2026 17:14:58 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 6A56D40561;
	Wed, 26 Aug 2026 17:25:46 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:44 +0800
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
Subject: [PATCH v3 16/17] arm64: kexec_file: Simplify load_other_segments()
Date: Wed, 26 Aug 2026 17:25:40 +0800
Message-ID: <20260826092541.3905933-17-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: 3qgfcts5udu5itbic1iqxchi1zdo3e74
X-Rspamd-Queue-Id: EE4DA80006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787736348-721293
X-HE-Meta: U2FsdGVkX1/vn+qeSpV8ulBdNKr/L0o4aBlzIT5j9XOuVRaWi1hnAk80uq+tfKbt4jqdvNGgg57EdAWRZKmHpc4YSC5Paaop2+tTQfG1sxT9BAFRJpgxgvrYkxYQ5Xw5H6tdFWg+wqSrJk1/GjUCazgaIlxwMZ826ZEysgQrL/20vTsAz7HT3pW5kCB6qOOqCLYFF5N9QK7V7fdp7hOv6PC01hmQpAFikmS/++/xYn/lqlftO7P1dZh9XEZLBtVgqzfsXxKMCsRswazNnHfvI4+X3+aBYfBVV0h3TnPy3mj2UZ6l+zUqTqM5mdfFLeHkqFGJXPm9jNAaNqYAA35EEzTJzlACfy6Ord9/23rI0+jEtj48hyuD7LnRTPiphSOBCkSEA4ITCljewCHlhx2m6ducB7dGJkG42OLsbKfgB4yUUGoGH7+MxFmvzQPe0smsEZYb/zNsJ652y8s6GNrL0OvHwsfxLQ6KhafbDQiVt/ZgoCEmuzPcikYoNI4wYhUuiKyqd9kKX8iF4oSi5LEeraT0YmOuak/Cbpbhq8eyLGc+ly1PGEdaliu+RsWLcn357YPSi59uC5IrPKv2JLxuYSfuhscqBjP8iimGsroAHRhtmNIGmswi/tPRCCPvUXa0CR7XGNfozhAYxWEoqzGIBg+nHeode0hkaexfw4+7wknUjOqjgkPcSRN9DVmNqUafKDkPcIN8N+VSCS8KveY1Wo2B3Yx2jsSI+5cVCLr5XLmKkY0v7y3cWa8eV88DBicBBjOuiODkS181aGFoh3QQ5wta9/SOQskHjX89FqmeiHlM//PKbNkU1bc3erMm05oZiObJQff70tI4GG/vKNAGMBycwiQ8hgcFnP50IZEyc0659ERdAPOsXbWshywVDukRhw5fzFaps/h6r1JAz3MtYBaxzTRSXpNN684aCGeNlF5oKHY85gKAGn7iHRWN6MH7K45dKmyZZ+TZ5O6F4L4
 jxeBJWeV
 wVktiKygb2jUZeww0pK+0C+C+7rncmz3RyFQyd0xR581D+if+6Dl+SdgoLdH3MYu3PJQi2af8c9r40ajqwKj0tehxttMRV8HrY9bIJN0uOTbdjiRJOVjadq6SnRQQybmosce/b2cyycqbkKPWboKha+cMgvpkqrrJB/TatcRERvjjGo8f6oetJo5nYTQpciQ04ivW7ukMsHjSOrA1jYd8BMhPxH+Ml/H3kUhQ1jsMNDvLqoGWmLJmWbUfUZtlfUFYXugrb5c3nlM7iC411T9+uaNqx8XHwcX6ma2P6SdcbWZCEo+tqOJ/ZpCIFDh0IVWH84JAqR4WOQ4KlrknkeezvHRXNI1iQ2nOfCo0032hqOCQeVw8nkD4IETsgfLviC7pLv0znYPjJdv1NOFaOkpuRSkd0ekqnEBrdogC7AGHcIR2ALwH+CQ28bOjdOJcHd5i3z3YCqlbs0WHbX68BySDwiCebw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use `kbuf` fields directly in crash_prepare_headers() to eliminate
the local variables "headers" and "headers_sz"..

Advance the assignment to image->elf_headers before
calling kexec_add_buffer(). If kexec_add_buffer() fails, the explicit
vfree() in the error path can be removed, as the global infrastructure
in arch_kimage_file_post_load_cleanup() will handle the cleanup.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/machine_kexec_file.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 2f750e5f4fcc..3d907f8ee594 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -89,36 +89,30 @@ int load_other_segments(struct kimage *image,
 	kbuf.buf_min = kernel_load_addr + kernel_size;
 
 #ifdef CONFIG_CRASH_DUMP
-	/* load elf core header */
-	void *headers;
-	unsigned long headers_sz;
 	if (image->type == KEXEC_TYPE_CRASH) {
-		ret = crash_prepare_headers(true, &headers, &headers_sz, NULL);
+		ret = crash_prepare_headers(true, &kbuf.buffer, &kbuf.bufsz, NULL);
 		if (ret) {
 			pr_err("Preparing elf core header failed\n");
 			goto out_err;
 		}
 
-		kbuf.buffer = headers;
-		kbuf.bufsz = headers_sz;
+		if (unlikely(image->elf_headers))
+			vfree(image->elf_headers);
+
+		image->elf_headers = kbuf.buffer;
+		image->elf_headers_sz = kbuf.bufsz;
+
 		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
-		kbuf.memsz = headers_sz;
+		kbuf.memsz = kbuf.bufsz;
 		kbuf.buf_align = SZ_64K; /* largest supported page size */
 		kbuf.buf_max = ULONG_MAX;
 		kbuf.top_down = true;
 
 		ret = kexec_add_buffer(&kbuf);
-		if (ret) {
-			vfree(headers);
+		if (ret)
 			goto out_err;
-		}
-
-		if (unlikely(image->elf_headers))
-			vfree(image->elf_headers);
 
-		image->elf_headers = headers;
 		image->elf_load_addr = kbuf.mem;
-		image->elf_headers_sz = headers_sz;
 
 		kexec_dprintk("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 			      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
-- 
2.34.1


