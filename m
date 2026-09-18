Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965C5C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E336B0096; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07E36B0098; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81216B0099; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1796B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49356405A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:20 +0000 (UTC)
X-FDA: 85226447880.03.72E00FB
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57FC540006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h1jxo3g6;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g746orfjBM5FKI/4ioFM0MPbnRDGHMAm7NJngqq6WSA=;
	b=HVQcdDygEv4y0+kOArhibv9ectWiGhkLMcJP2ZKXdASvv5dEjuTORHY8+qQZWSmg5egzX9
	DUuwkxUkspnlenP7Bb6zs8fbPDXlKSa4Oj0/wLULQgDoDxqMFpvuJir7ngOxJBv2u0GqQd
	8qwDQN84TwDL8nw9bhbcRXWqP4Ep4D4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h1jxo3g6;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725858;
	b=sVy29sz78rjqCuaqeyIS0jF8lPEpozCKMyeVtFoW3wAlTcRJlmXpP7wepHoJ4TvcJZUWz4
	9KN4HjaP5HD21KCS2fUPjVOAJ2qG4tBlTeCI5VCMaF2D5fSeH8dv3G8tADq+p/LZGSA+5j
	Ew2s4QKYHxzbiPnU/UpgiOWeteiNCl0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=g746orfjBM5FKI/4ioFM0MPbnRDGHMAm7NJngqq6WSA=;
	b=h1jxo3g6i+Np9G/ygFulWombg/WWMVz/nTSO7gjsBS9mUvrsf8A1hYwT/QK9YNw/PYEjbGJJP
	flmsFMVVXB+OPm2NGt/WJCIxlXEKLJyUYJ29/n9rb9hEiJCkb2OYQAVDWCoW/izsogrfAUkYoKj
	HDssVLSCyfy0uWkUl/kaLnw=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hmScB70ylzRhXT;
	Fri, 18 Sep 2026 17:53:14 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 6093540538;
	Fri, 18 Sep 2026 18:04:12 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:10 +0800
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
Subject: [PATCH v5 02/17] kexec: Record allocated CMA pages to fix release size mismatch
Date: Fri, 18 Sep 2026 18:04:27 +0800
Message-ID: <20260918100442.3841135-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57FC540006
X-Stat-Signature: 8hinqaarzsddywphowgk4qij1k8yoe6o
X-Rspam-User: 
X-HE-Tag: 1789725857-270789
X-HE-Meta: U2FsdGVkX1/s/w5cuXTgE9hPcCa0r1z2owjOVz5Pk+G76AlTnpaXldp6UWqtz52mdUTNmQd2pcpiqeLSv3Gcqn5J8f8UAPgYX1DOHMkiOZ6Go284+vhW2+TzYGU2NIQb3p9EZ72ryTKF+aOZXfi23cVWZ3BBTPJgXOSsf5cbXuwdXmHEbg7On4KkT0P8tUi90VS6qPXaz8hLYG7jpoTp5PTGd2W/H0hkz/RpGru88i129PPbMguHrmEJGXmU6kksJdhfG3xXBzbFjL/78+P3dNN1o6RpQy75VVC6APvjhtEK02sRhxpmcHr40ywXPSzxUePfrpqQTTLgHlDEcrLjip6krgzBS0z/JClZHBUd0L02eF2fnTdElwdcl2uj6qf9Evye9iN0tlFfi1ZZXxZ44Gsrm2NkH6KZoXtNkWll2x1xCPiOmBxSOmTyVuz9nl8m2yxATGln/VIQNN1u1mwKymn3mc8ZgR2P79vD2SFv6eNaa4KWGKOXXtbMjP1Hfp5wmIS5voZN5DmbaWZ07jxlUz4b//cdshQdSrsZFccsff1BWJV4Qf1QRgbmGTZvfqF/GTD1gXeGb27GvZpsDNHsFL6Wfp25VPLkRqnlqnkR1USZnJMJeyG+YAzplNIy4NKk8rOZyiyWcPwLtEYAObxZiSFHqgPdZkd4U5dzFKkn65QAkOfeipyuvJMs315EtqjLg3NXM7wANApUrKe3XjnOQMTASAkl8veOgLxpchvgwcB4r1qZxPgnBQYg1zEwW9C010z+hpMIvxHlcwb9W3WGj9jcr8KGPaaMH9ktoGoeJM8c+qgdcojFvm3pgbTyQOLqjPr2cjNt1ZmO+tG1PnvOEQSMuNTxRB/L7iez/jnZc68XYVbFshxaDsenB7xWEWVQxzLY3p9wYkhenvM2QbZzbQkhjXk57yxCrBpaLvD0hoTtJcjdoqbO9pDVXZGqb12NOZOEZbb9NsELTkXa63Z
 sYtHAE7Q
 m0PkUbW/+VoLljG/spWolAvx4m9+KPVd6T00EKC1deH5QCB24zDeWlUpvlv5WPZ3DLcJm5ZToR0Bu3U49gjvSwHrwdnerUXQbNBD7xQoSv88CIewc1m9D9mGj0Je15ct8co1jgpjCxewm2SNii+E0G7pVvHWEGWH+mCdpk+Fv0dikcJWtXj9ikLW4kUPd771foZdAnHBsMV2VcuKQzU8eJQO1X91fgDBnyaV7xVubqgup+C90UUbACrLrNxauyc6uPa75hvOZ9bwlQ/WpuGrjTm+CchHmNQQY3/j3DzTfTBzsi4wP79cMXl83GEWhi/DPYI1iygUqoLdw2DUNnbLyUVmX/wAlLbH35qe9xR+3URf7WoqrG82kuVT9w2VdhSy0ShESMhTEcIuEKiEoTUbV30+W0K/NMOciN4xhG0mDofqdfBwpGwbcbIQ71i3caZ+0rCd7gt1CGgmQp7dMJOeFhaVhw6vYQPDf8R/Vt6Z9JUjUBpDV9HuiMEYl9y+dBmJF3cxjw32unkA5bX1igsWONgpa1tX6q2AKWr8L3XB1KI3MLW94F1jmcZqd9tNF6QeZpNkQDtBPkl5Yk2DmI0XdYO81Mu2PFbsIZdF6p7E/q7k2sbXK1bgDZCkUWGDZFKxpzpx1Wh3CQ+Z0ZnyUcofkH3wn+RHqtu3d6hxB8Z95zck11sR8D1gM33CSAmHXz0q9DbSn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA pages allocated for a kexec segment are released using the
segment's memsz to calculate the number of pages. However, some
architecture loaders modify the segment's memsz after allocation
(e.g. arm64 subtracts text_offset), causing the release function to
free fewer pages than were originally allocated, leaking the remaining
CMA pages.

Add a per-segment `segment_cma_pages` array to store the number of
pages actually allocated from CMA. Populate it during
kexec_add_buffer() using the aligned memsz, and use it in
kimage_free_cma() to accurately release all allocated pages.

This avoids relying on the potentially modified segment->memsz and
prevents silent CMA memory leaks.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Brian Mak <makb@juniper.net>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Justinien Bouron <jbouron@amazon.com>
Cc: Li Chen <me@linux.beauty>
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 include/linux/kexec.h |  1 +
 kernel/kexec_core.c   |  7 ++++---
 kernel/kexec_file.c   | 13 +++++++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 0af8ae4fdd08..6b1df80524bf 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -349,6 +349,7 @@ struct kimage {
 	unsigned long nr_segments;
 	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
 	struct page *segment_cma[KEXEC_SEGMENT_MAX];
+	unsigned long segment_cma_pages[KEXEC_SEGMENT_MAX];
 
 	struct list_head control_pages;
 	struct list_head dest_pages;
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 7f7cb77f0caa..5493591a9e4b 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -560,14 +560,15 @@ static void kimage_free_cma(struct kimage *image)
 
 	for (i = 0; i < image->nr_segments; i++) {
 		struct page *cma = image->segment_cma[i];
-		u32 nr_pages = image->segment[i].memsz >> PAGE_SHIFT;
+		unsigned long nr_pages = image->segment_cma_pages[i];
 
 		if (!cma)
 			continue;
 
-		arch_kexec_pre_free_pages(page_address(cma), nr_pages);
-		dma_release_from_contiguous(NULL, cma, nr_pages);
+		arch_kexec_pre_free_pages(page_address(cma), (unsigned int)nr_pages);
+		dma_release_from_contiguous(NULL, cma, (int)nr_pages);
 		image->segment_cma[i] = NULL;
+		image->segment_cma_pages[i] = 0;
 	}
 
 }
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 59fb9d71e9d8..67d6df9824e6 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -670,7 +670,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
 
 static int kexec_alloc_contig(struct kexec_buf *kbuf)
 {
-	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
+	size_t nr_pages = PFN_DOWN(kbuf->memsz);
 	unsigned long mem;
 	struct page *p;
 
@@ -756,14 +756,16 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
  */
 int kexec_add_buffer(struct kexec_buf *kbuf)
 {
+	unsigned long nr_segments = kbuf->image->nr_segments;
 	struct kexec_segment *ksegment;
+	size_t nr_cma_pages = 0;
 	int ret;
 
 	/* Currently adding segment this way is allowed only in file mode */
 	if (!kbuf->image->file_mode)
 		return -EINVAL;
 
-	if (kbuf->image->nr_segments >= KEXEC_SEGMENT_MAX)
+	if (nr_segments >= KEXEC_SEGMENT_MAX)
 		return -EINVAL;
 
 	/*
@@ -789,12 +791,15 @@ int kexec_add_buffer(struct kexec_buf *kbuf)
 		return ret;
 
 	/* Found a suitable memory range */
-	ksegment = &kbuf->image->segment[kbuf->image->nr_segments];
+	ksegment = &kbuf->image->segment[nr_segments];
 	ksegment->kbuf = kbuf->buffer;
 	ksegment->bufsz = kbuf->bufsz;
 	ksegment->mem = kbuf->mem;
 	ksegment->memsz = kbuf->memsz;
-	kbuf->image->segment_cma[kbuf->image->nr_segments] = kbuf->cma;
+	kbuf->image->segment_cma[nr_segments] = kbuf->cma;
+	if (kbuf->cma)
+		nr_cma_pages = PFN_DOWN(kbuf->memsz);
+	kbuf->image->segment_cma_pages[nr_segments] = nr_cma_pages;
 	kbuf->image->nr_segments++;
 	return 0;
 }
-- 
2.34.1


