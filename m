Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74D6C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1464B6B00EB; Wed, 26 Aug 2026 05:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A87B6B00EC; Wed, 26 Aug 2026 05:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2DB6B00ED; Wed, 26 Aug 2026 05:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF6786B00EB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CC22C02DC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:29 +0000 (UTC)
X-FDA: 85142887578.28.BD40683
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id B32E740003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xq1YbTvD;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/N27OffVwB9HknmerMZN+vGpNQOngX4+yhYYxhlpgs=;
	b=yrKZrvEZZd2hErgbViyN7kC7DlpSjddv+4PVagcvtyenHP+2We6St/2qYS/jLWq1eSfdT8
	daMVLkfQQhMzGM1idOIIf0QRwmPvs3GPqHjCHuXLhjoEo7rzO8cV4iSjSwehiFUQnKpS9V
	7QE2Bl88HDufe2c++SKu8REupojJN7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736327;
	b=qCrZrRkPTLj04yFqDbw11fdIe+K0wahB+AqFRaAvm45+3dnknQreMVWqeFSJ9jBIyrYbY6
	dwcpKOofQn4wp+xXx7HLQJjszy6mkoRcIYTgYIXf8hRZPWIXGwNklCuJQvgGaFfmNvR5Mo
	m8S83vYzu00Tm3ddsVh0mYPvhojLgiQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xq1YbTvD;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=C/N27OffVwB9HknmerMZN+vGpNQOngX4+yhYYxhlpgs=;
	b=xq1YbTvD3XNNnXqFEYm+rNDxG6EdsqcQH0HTMN1s5TayGIm1XkNSyQvmkbCWJmLw2RC3Hg9MW
	03OTT0taTlXRmwul+dn+StNpv/it+wBQ3leQZDkbShT3eaE7XAglReIYtuKqLTKOKW4s7jvAaSh
	i66n7enwbsFGUXQhFmGkLKQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrS2MbVzcbMk;
	Wed, 26 Aug 2026 17:14:48 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 2935A4058C;
	Wed, 26 Aug 2026 17:25:21 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:18 +0800
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
Subject: [PATCH v3 05/17] LoongArch: kexec: Fix CMA page leaks in segment placement retry loops
Date: Wed, 26 Aug 2026 17:25:29 +0800
Message-ID: <20260826092541.3905933-6-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: w1uc8m34hogpsy7zp78ew9ufditpa4ca
X-Rspamd-Queue-Id: B32E740003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787736326-405375
X-HE-Meta: U2FsdGVkX1/UE0gps+4l00ev4zrLxb+rqZCtWIHkk34t3yjXFme//104zneAamf9I13TXjIKasGfbQWxPKKrNlxlaEJ6Gm0vevc8QdOeDTQ8Qp+gnu0lh2kD0B+IwvvxPcPjtrQA214/lz21k70S3LPjSEby8ow8Tgu2fDJd5ivxLaW970Kg1zSU9PdvOXVa+WPkmrCZLvOp6qGb243QmfTYbEOxkCOMBpyU21GS7eV5oApLHYDIbT1t6In8Oh+feQlfrMYOpYF++GGn3ERlsT1f2ot1/q8J2pxZNMCIywRXNOo4l929tnQstbLeVKS6DX2E5pGKvO3+mSLBJJNXVpqMcxxPEAe4QcNsJr+yvqxX5HiFzVYdASU7Lf8DpcAaM3ht5J6ttabxUMqc3D6Dlhs/c9YSWrDiaM/aFrRTqGfSHuZVVkTwC2bHRQ238hz+nF/cWB2o0kdIox0xXGi1DcxJzW9eDO6RdDlBOMEp+mWCeJT8hLI5sdB7KogaG5/0eBoIhGLe5YhkgwQ2+NcqV8CRMvqzDqrY9nT/vFB/YsDbFcWCimlQLVQ5pXDJQK0ipNloiJXVuAqSU0c+XrJdTB8RDM5Vb1fBZWeXAE7fI8VLKKMjh8oUUXzLu9N1xoRzBYz7er0Sj+h5vZBxNFz8qhW7P1xV79Rz3hSg06AxWDKpyOgRY2Uvqe6Yqr0LaQMklsTTaK29+6UkxIuW0YPMzzVo9w0Zrc9RX7hTnHT7K2Zhdwv/nSWldtt48pUx13PIcr1RVpkhEDMH/RCfx5oMMJVmjTggHYqT/7FfTFLsKNOgoTc+Dd59fRn0r5IvNzngG47w54g80+y7iQLAX6sNw6jL0hTwURZHo7kynXnD0/hz/9OmE1TEc2Ff8ubGK7EjdBPMFBJvz1y2rPqAVM3yg1N74JEJjVWscA0Fnp6/s7svq287SGcHznj5/YYp8xYcpJr7+8ZmkvAdT/DP5tW
 0b37gJ8b
 ACnHbdfbzyu3TLQqCqjxLRpGfl21pAXYkgIeTjCmhPB0KaofcF4hy9kFrDPQYwx8g89ELAW1LoWdVXrcjhE+UEoMbkH2CQaLK9soutgskcHC8R/4mAkfteuaWDnOKgcDOWHHbZ6px0EJ1vgwoSHnfGCG7erLe0JttQE0GmXsvS0gmSZ8/ZN8cbCp0YkCDbBfs6kHqM8l7y66c8l5FuJAPm3z8fr9s9yXPO7vo4NK71S0QIX3BOE3mH7niPCrmmWTokqs1T5N+6YVlaymwTrXSRXr7I+hazQwpzIM3KXnTy5Gp4hw3Jzeop1XmvGvZJ1net88b52thJ8C1WzNp3ENjpNgecSldq5dpvDKLDxCYTvyrOULIlD2EkJQNm6os9lG8d7/I3klVPSuPFPNqqDKjPDs+qg==
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


