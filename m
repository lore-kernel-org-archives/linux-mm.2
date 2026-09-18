Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D1AC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28A66B0092; Fri, 18 Sep 2026 06:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB53D6B00A3; Fri, 18 Sep 2026 06:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08E96B00A5; Fri, 18 Sep 2026 06:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9361F6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3423AA5D8C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:39 +0000 (UTC)
X-FDA: 85226448678.04.BF27881
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD87E4000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PHmoGMGZ;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eBN1xy3LsTspM2cXc9iihQZgxEMtvQyI2J8OiqZLKg=;
	b=LRELqxeXhg5fA6Rnpx71UhxqI1VTXE+Blc5RrT5xkV77rWLHiu30qD7eKtKEZbxy31+K/8
	iWOgkdRUZ67JkkP8qzbsM8/LsWuZ8v/3x5Y9QUbdsNdwRjEytS/HSFEfDVnwauDuT44YIb
	rT2t/LSpiYM35lXLIhZh8hE5hMh2sBs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PHmoGMGZ;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725877;
	b=J+LouQQXYm3VuEL6UuqclpTqkrFNjiFvgOyUFRW9rus2F4isBseGJJ6oOvzAOcf76S7Ec4
	xttzIAeaBs2WH8IdXp8NWlefLWRTa5Xr04VDzz2zOfbYH42KUmcddiaB+4WeJnEdISCW1D
	I18YGMBzJWeyTawd1QalRVLyE1uPpH4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9eBN1xy3LsTspM2cXc9iihQZgxEMtvQyI2J8OiqZLKg=;
	b=PHmoGMGZCpSK83cFfL1l+GZjf/pY9I+6IoZqg3WJ4VLG4xW6NHlRLdZlpXZs7q+S1hU6FgzSG
	rPNsboboV+FxPnNuPRJvY6Ww7D51z6C62ISbmu/FflpvRh5Xiy1KVbEeTFJW1U4tML5IiSjG8eN
	PcED3zgeHCZOJt4Rn7qsZuQ=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hmScY040lz1cynY;
	Fri, 18 Sep 2026 17:53:33 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E6074048B;
	Fri, 18 Sep 2026 18:04:32 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:30 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 16/17] arm64: kexec_file: Simplify load_other_segments()
Date: Fri, 18 Sep 2026 18:04:41 +0800
Message-ID: <20260918100442.3841135-17-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Stat-Signature: duzmznw3yjj4u7g5argn5gf6abbw79he
X-Rspamd-Queue-Id: CD87E4000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789725876-399456
X-HE-Meta: U2FsdGVkX1+ol+gKQ7upDwPEmul6DoUYJjIHowJpIjYRwKAmD0lMI+f9nxxn2yELcxP4TOrPJRIrTsFD0KaqDxrh2ZrsVQPiJUE0Vp38fpHfVXHrCVApZ9zaa2QPxoXDY0noAsoVAS7+ZOsTROMMC2Cz1qHg5HREKKUdGV9W8ocrrQjl8+uNAvj1KS9nhLi2SDSHi+kZV2AJYzz6laX+Yp1ZPyBjZuKUIyx95lkwKKb5y9+JODyfwgxgSQ0e849Lj70bKZOqui5WTb/WJ2f6PPs3qoDO8Cc3tQGjS+nlVmiK7bWxi39hc6iDsxVKNI2cr/I2L4fVJ0Y1eK1tsb7pFLE5pAL3Km5gPMonJh3kDDqYlqZFZ5jTHu+yEQlqMJz1BeaiFilHu14rCBkl8R/EdChdOUi6v4DLm2v7AD4eTgN19Pi27rkBkTLOdgRb3DEh6kZApfHKpIksa1qnGM5etpl3Gi3SR18Mr8vd/4FJxHZ+NpZ89tWnRf76+yfvz5Bp+DenaA0gErVH5/ijAEDTlmN3QrlqTEJecZGgixH8DupcfmNzhWyebCr/fAfZ9KdzgD6LfbmiYd2FamMN/7CQziNl9GgzdXEq5ArLsNZ9Cb/i6fHmI33kN9RjSGzWkoz31jUoFBc5T66ZDHUEpe+LD/iBghQgT3Vj8qyYbIKxjmSFUKeHFtxgOuFeEQFuPdzC5vQGE4KQdViMA11PJX/h4buwo7dLGITSP+tRJaGTnSiDd5wrGvbbIh8EBijL6egbA1c7WHWFUiaWYrMYmv6bskcrNJZVgYcpIxkY3hLZfIZwRr2oooKg59Dgobx/AkLnL+i1HhWkMWqKQNRcCVdF1jm47q/Cd1+EO2y54XcZ1n2+8oScxQ6k1WHTEv2CHQAqE/5xr6TU7p5xmHNzVADqXIFyGvVqXicwaFFxgRLoKQzca7k9zROJlH9Izf0S7w3oIUFFLVEuqZyXHzy8tvG
 Syo/gsDC
 LWiq5vwvGwpGhyqP6qBbMZLZtdnQ+iTZAgZi0CRszXoVK1NYimXhlkkuGqZpnx9yuBJFx+8hosqcB6RVeCzNyC/dvB1As9tSeTUR6UsAlVSUmTDU+AM28+Ru7RYazSxeL83jioJB7oYJXuIl3Lhfox0hIMt5ZZqqLFLREH8MRMMtVTskvZow01iCpet9FDLT2zbhweDUagqL49xfQpaA/cZlKmOnxx0UbGFumx+uUyhQ7mukaOmKmnpxZZIX1oG9UMFpAVPxUAsjQS4iQX9K26FzlF9XsPK9feq19x8c/CNLK5fNT/TkkyPVPBcpEVH8FHgEgP8gDss4jmHVB8sXt4f6iDz+vAlvw+3+0f+F28eh454hNoQZ5+sNxtoM8mkwSyFz3fWoQtckQS7y7U3ZUW7BFEQXc4cx6Mcs6CYYrSkvCVH0nTEQaFBFmS1GMpBvGJU+xkWP0//rlDz2JI8BT5DV3AQtw/yAVl/1BaO768+m/7bz6xho2gd9v835MHioP1mxtaEMIiV6hh3RMo4f6dfTpzuUHRfZPs93e
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


