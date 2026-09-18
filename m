Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5EBC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EEB16B008C; Fri, 18 Sep 2026 06:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EE46B0093; Fri, 18 Sep 2026 06:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D586B0095; Fri, 18 Sep 2026 06:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 189606B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EF43A5F0A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:20 +0000 (UTC)
X-FDA: 85226447880.09.EDE2A46
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB3964000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Ez/wOSF7";
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725858;
	b=3xuIlI2NSGyRxXgzIpglso/GPhInSEynwOYfazTex7VV23i6T7aymzcgTNMu9xtbPTzEEk
	T5+8buunM1KwflaROIkeMuGmiYWlHLwwD8PtH5oTamyoF+KM5qjACoq9Cc9DQfxzRN8658
	SoqmK4ODRbyzwfqpygaBXDxnftc6Zi8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Ez/wOSF7";
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzeLYP4W/HVtauBH6zrP+s/J9Q0YG9Qv0eMgDswYLO0=;
	b=RBVSxWy0k6QqQyzJa1isf6JWbq12PsUPG41EFPV7HshaG3Zv8GlLOQoT2bN5jFaOLbfVVW
	S9gRL9/qT7l7CHzRwqgVcQQgKcytLE0KqcnMrQ/9+qdRtc8M6K+zbh1A3yCXh5cgcRzwKw
	+iiq5648FvYvLuB/Pa9RmiprM3Ysbfo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gzeLYP4W/HVtauBH6zrP+s/J9Q0YG9Qv0eMgDswYLO0=;
	b=Ez/wOSF7kN0QxhLrYOxwsAq0t/qVSH7zO1LO6a7rzHbsnPODXfipqqsojEw0qCoGxc7ny7coD
	r5CTzt7mwcrfYR0Ns1b2jGOyjEoC1z/DtVergIB5XHUbsALHHtqEUbsn6WEYdxjWUtLytZbUcoZ
	lEboIM0h4256GoXqxjGf9KM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hmSbq5r7Yzcb4D;
	Fri, 18 Sep 2026 17:52:55 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id E5DD54057D;
	Fri, 18 Sep 2026 18:04:10 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:09 +0800
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
Subject: [PATCH v5 01/17] kexec: Fix CMA segment address translation with non-zero text_offset
Date: Fri, 18 Sep 2026 18:04:26 +0800
Message-ID: <20260918100442.3841135-2-ruanjinjie@huawei.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB3964000D
X-Stat-Signature: idx3s75dmoqni3b5ibbsdem9ayufxbro
X-HE-Tag: 1789725857-815860
X-HE-Meta: U2FsdGVkX1+9ujzc4Z2r7chM3A2k28qjiLZqqHeKTJbaCeMzVCMV41jY15K1Gcr/cVaXKK2gms0iOLXbu8XBYkoeV6mV/x6jt4OT6DIvsrk/nKS+I+zhlAVKJSE0NLhpOp4+D9pwCn6sBg7gCUkfNApkhBeZEdi8lZaQ3r/7VbgynhqMofSfFEm0KYpgY2GRK2JOOjnQSrKSuf2xdgoEzg/ZeunZrGbRcuT+Irl7btUWNQSW39L02zvRAs1fsKyxDGgkcqwt3Vh98AmGoxqdb0brEqg6sj/NkntLgqZf+WrTj5uA9j1I9Du5Q3EzK21eNsB66C+DbhmHeCQn43Ne/aUPXkHX3dYapzvrDGXxSAIa3/bTG+ugxB8cQmU1FflKGcG9750zi1/WLUGYTXHb+v/WZqypcqbinZgvb9rhgLkHVeKJpG4vALuqWqBMVJ0r5gmBGcrTOqKkcud1ODVbfPqFBZjzsGyydEhM0zrIT5dW3xFRQ+5I8bVnVjqPJRG97TUzijAegytzxe00nio5xV+4QKMJRvX3yQg3rFg0sVxMfSQBfouR8XYgexhJBw/K2pAYQBNcUrws2SrkpbE7Lj7CwovMxEjaIW691Ge4gZmm8hdyvWSPkOMTjPS8o8ODSNuKDZVtkXJ4Y/shMBufD9YKM73hhq20B5nNtQwvVKGnZdIPKZCLrwmEJDDVY5SQjhYm33vHHjugOlv1nd6KxNwG0V1NXVuaBW7F5idLskRJ1/aDNgWnc5QiisFL600vy/wHPWrOz41GKieTdWR0xhBHX1mc4/MnATKOJjUlNpmejaybXhErhLyx8mNRG3RE9DyDpwj9UCIUvWCCm9JXqysv87e2AQe8ahFIRZXB2ONgEhRToId8yi3a5XRSDV7MdJn6orpp4oTqxWyKbvKvzqqoU6v6OLI8nZ4MU4aAQEhZnwRGDy3MbvVBRHNbgkZvaEP0w0NgfN9LeMWCTp1
 IV3B8Fey
 VAquGhc7TmHaO1/+meL+oI3QSJHTTBGgDVWFcAHCh5ionOdsMC1ryhHSKcZftxojtI/5A1gepzjw6WinHQyDJ792/Ddpn+0JCzwtJ1hPrh8pwUnhtrUFizBb/G4zQ6qeXUIe+IIq231ODwUCTWDoOa5iyFuwOYgnYkh81hSZlW/3eKz+K6T237Yps2XVCNrfNrLJhajPXLELgLgac5+gLqeulekzSLUMCNZXEWAAs2dZwtg5gtrhf1HqeXxVw3ZcwFJ92zZKrqqARqrp5nmUvsfD65L9xmtI4IWFKdIdTMWxmfHhoZr4o6xpjlIM9nPJEJxI7O4FnZsZSKIqSXYmeXJ00mnZqdqSopMDrHR3LJZVNxoH+zQOCusMFGlfNUSDuSmjkMZ2CNgFIyUmnI4I/76f+Nf63kjaHqFSq9bsLXNIawwLvFqoACR6Ec8Wf1pDpBFq5HVEcQz2SS4vlvGOM76BIf+L+5H8EmLSB39UsKRnlOiyxzvHuEt7e5x8P+z0NlhpgA1eeELGUT6lnAHtBO1g8Mf3rSsTMVAKiGqh2/0MICL7Cy+B65xHUGzazsWXTo9C3TpdDhF2BpSLRF0mxUATlVpBG/D4mvDCk4ZRwzm76a29oG6tmtYQhuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kimage_load_cma_segment() and kimage_map_segment() translate a CMA
segment to a kernel virtual address with page_address(cma), ignoring
segment->mem. But arm64's image_load() adds text_offset to segment->mem,
so the kernel payload is copied to the wrong offset while image->start
points past it, and kexec jumps into the middle of the kernel.
kimage_map_segment() has the same problem for any CMA segment whose mem
was moved.

Add kimage_cma_vaddr() to translate a boot physical address inside a CMA
segment to its virtual address, and use it in both places.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Justinien Bouron <jbouron@amazon.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 kernel/kexec_core.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d05..7f7cb77f0caa 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -738,11 +738,23 @@ static struct page *kimage_alloc_page(struct kimage *image,
 	return page;
 }
 
+/*
+ * Translate a boot physical address inside a CMA segment to a kernel
+ * virtual address.  Architecture loaders may move segment->mem away from
+ * the CMA base (arm64 adds text_offset), so the offset must be preserved.
+ */
+static void *kimage_cma_vaddr(struct page *cma, unsigned long mem)
+{
+	unsigned long cma_base = page_to_boot_pfn(cma) << PAGE_SHIFT;
+
+	return page_address(cma) + (mem - cma_base);
+}
+
 static int kimage_load_cma_segment(struct kimage *image, int idx)
 {
 	struct kexec_segment *segment = &image->segment[idx];
 	struct page *cma = image->segment_cma[idx];
-	char *ptr = page_address(cma);
+	char *ptr = kimage_cma_vaddr(cma, segment->mem);
 	size_t ubytes, mbytes;
 	int result = 0;
 	unsigned char __user *buf = NULL;
@@ -965,7 +977,7 @@ void *kimage_map_segment(struct kimage *image, int idx)
 
 	cma = image->segment_cma[idx];
 	if (cma)
-		return page_address(cma);
+		return kimage_cma_vaddr(cma, image->segment[idx].mem);
 
 	addr = image->segment[idx].mem;
 	size = image->segment[idx].memsz;
-- 
2.34.1


