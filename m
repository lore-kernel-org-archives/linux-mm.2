Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629F1C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91A26B00A4; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B136B00A6; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BBB76B00A7; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 688576B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01764A0156
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:39 +0000 (UTC)
X-FDA: 85186957800.04.501DD15
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF002160006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xq1YbTvD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/N27OffVwB9HknmerMZN+vGpNQOngX4+yhYYxhlpgs=;
	b=Ysz9l120Dn4XlCjjoHzOV4cPWFOGNvsmqjdbFb8BMvTi1/Lz+0MM4U7w4W82rspO4wuYfZ
	xaoDWHXA3RLzRI1DvHYyerdkOJc7k3DGjgI+g2zVYb40z9R7Yaljm8+s6a/20Xuck+iCH2
	a9TllQS0wdtpsvjJshjv+dpV+ocqM/U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xq1YbTvD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785618;
	b=4kj1lcFiG553iqNq4PEtCNM5NvtebaT7DEZyOk91/sJWYC2tBKuLLg/Ty+hXbMKd2C4/W7
	2hfyLEjEHEy/WgEGlm9dB3OR6gvc1qjYjDMVn5Jj3X9zz22MVEOymnifAyEK7z6DTKcZR1
	94iDdmwyzMCDEHMo1C8i61/Rt9DlBj8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=C/N27OffVwB9HknmerMZN+vGpNQOngX4+yhYYxhlpgs=;
	b=xq1YbTvD3XNNnXqFEYm+rNDxG6EdsqcQH0HTMN1s5TayGIm1XkNSyQvmkbCWJmLw2RC3Hg9MW
	03OTT0taTlXRmwul+dn+StNpv/it+wBQ3leQZDkbShT3eaE7XAglReIYtuKqLTKOKW4s7jvAaSh
	i66n7enwbsFGUXQhFmGkLKQ=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hdmth0pJsz1prPv;
	Mon,  7 Sep 2026 20:42:36 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id DD88640538;
	Mon,  7 Sep 2026 20:53:30 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:29 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <jic23@kernel.org>,
	<tan.shaopeng@jp.fujitsu.com>, <zengheng4@huawei.com>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<djbw@kernel.org>, <seanjc@google.com>, <liaoyuanhong@vivo.com>,
	<vishal.l.verma@intel.com>, <fuqiang.wang@easystack.cn>, <makb@juniper.net>,
	<piliu@redhat.com>, <ebiggers@kernel.org>, <jbouron@amazon.com>,
	<mclapinski@google.com>, <me@linux.beauty>, <graf@amazon.com>,
	<bgwin@google.com>, <takahiro.akashi@linaro.org>, <palmer@rivosinc.com>,
	<x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v4 05/12] LoongArch: kexec_file: Fix CMA page leaks in segment placement retry loops
Date: Mon, 7 Sep 2026 20:53:57 +0800
Message-ID: <20260907125404.922123-6-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF002160006
X-Stat-Signature: drarr9mzpxfb94j75zuadtjsb1q73r8r
X-Rspam-User: 
X-HE-Tag: 1788785617-303675
X-HE-Meta: U2FsdGVkX1+VqCRUHLM4OFrHh1/OJurCb9DMqsCLSUem60wCeYvMOLDD4umeaZb/rkZjq8Wv9KPkcaObhsH3JS+ekZXFRUBuSE4NbATK9NKXi/FBKA/JSUpNt5lY6uA0/azhs4JLEDt2yE4aFqO86pVsGmz6Tvy+VBNhmEGPNnkPEZGpMSa8QNTO+p4tZ9EM4q8i2AV8t9lZ2WZmgvy0NpZHWyON6CTQrQ7S2Z6XnYgD+4GpVpb+a5llxOENverIH5eo/AgSLSRFZAxiErLG1WXXeD+E5wHQXJBqn4+yXqLm+HTYSQQ2PMAcrzDrOtnIIpg5IBGU8Hf7bcTJC1Cd4R88rpQgG20qtA8Dsp5Oi8IVhrQS/CtN7CUvzqiqrZeLCPEGBphFl8ewJ2/i80joP9srRRrgdK0ybIJ/huc7zsq4ZJmLVy2l1M7jC+h3n53x7Igvq1RDsXHuo3KK5rZFUEvDSEHz2/kqnQ878A4gqbn5elN7hFqKSQiHQL+NuTSRDt2nLW0EDvqJdmYrx8nK2qUfPGEfn98RQzm3PskMk/4GWx41sHOP7rksBgs5c+MDrSwnBtqZVO5glQn6F1z2pdBnHUO/XIxl8TUfGK3d78Ai7YxBn94zAi81GAeyogDMJNvbyuDSyYAiHFkSU4lKKAVatKwgZMZmOC70OtLytRXoNJL9COjpnpx8OwEmtX9ZWDkZJAj0gXKHuGOPlf2g5QgrvkPfaeu+9jvyA+xxRczp5soXjJTzn/jkWPdjgqkzBULh/ekHNoOcJFLaqOOsferv4eWPTxF4yxxgRmdVNxegZoQinNbOWKlt1//f56YDj2BZyq8ymw1imgrrDE6337sT7Zqj6sydbH5QRF+IVY265ZIqltGj4NKNw3BbS4JoDGFXhU6JF23U83QMa/syhbIwWG9XIBPux3L27cuYcVpOQyHdNiD+UQPSgXiPB/1/DVRVS16ZrOsgGZCYwdh
 sv5tA4qx
 axIk9eajMhlWQE1OV06LXDWzz5yAs1fWUIh2XnvWgE36icIm5UE3wxd+qhxi+ArELETyjpfw0eboBjLUTzR/PzGT9xvTSanH1aQ/bhMuy56nh7RpDPF601b+ELMZiiV+MP05jXTpuT4PNOQXZ0TVivMg+CgD96k9Hd+hXC6OtkfAs0bnmkCSake8MydvGZYaBfyOxNSnzW3SCE8cO602+Fo7jQ1Y/bhseFWJV0/QbUrY2jwV9mqZDFyKwXc0GlFh5gCrEFdCuQ6HvELiwfyA99LgKknwggLbZFnL5OI93zoFf89Uhs7EukUICe21xNrP5yyra9Kcz9jYgmmHen34eWkP5uUjJfVOB/Q6b4HTQerrzYcRvzpa69ENDcLzG5asZaCCTeivyyQfPSKSACBuWQjFPCNFlqgkABvL2+kqpQbm5ZCrFp8x4ZHfT58j2zfpbXCFV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During kexec image placement retry loops, any midway failure causes
the loader to truncate `image->nr_segments` back to its initial state
to purge the failed segments.

However, this truncation introduces a memory leak. The CMA pages
allocated via kexec_add_buffer() during the failed attempt are tracked
in the `image->segment_cma` array. Because the subsequent cleanup paths
only iterate up to the truncated `nr_segments` boundary, these allocated
CMA pages outside the new boundary are permanently leaked.

Fix this by explicitly releasing the associated CMA buffers in
the failure paths before `image->nr_segments` is reduced.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Kees Cook <kees@kernel.org>
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/loongarch/kernel/kexec_efi.c          | 1 +
 arch/loongarch/kernel/machine_kexec_file.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/kexec_efi.c b/arch/loongarch/kernel/kexec_efi.c
index 5ee78ebb1546..15fd797ff3de 100644
--- a/arch/loongarch/kernel/kexec_efi.c
+++ b/arch/loongarch/kernel/kexec_efi.c
@@ -86,6 +86,7 @@ static void *efi_kexec_load(struct kimage *image,
 		 * We couldn't find space for the other segments; erase the
 		 * kernel segment and try the next available hole.
 		 */
+		kexec_free_segment_cma(image, kernel_segment_number);
 		image->nr_segments -= 1;
 		kbuf.buf_min = kernel_segment->mem + kernel_segment->memsz;
 		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 5412aa9f3568..62a5be102065 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -217,7 +217,11 @@ int load_other_segments(struct kimage *image,
 	return 0;
 
 out_err:
-	image->nr_segments = orig_segments;
+	while (image->nr_segments > orig_segments) {
+		kexec_free_segment_cma(image, image->nr_segments - 1);
+		image->nr_segments--;
+	}
+
 	kfree(modified_cmdline);
 	return ret;
 }
-- 
2.34.1


