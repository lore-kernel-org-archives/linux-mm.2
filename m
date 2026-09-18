Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67496C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57836B0099; Fri, 18 Sep 2026 06:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA4D6B009F; Fri, 18 Sep 2026 06:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09DB6B0099; Fri, 18 Sep 2026 06:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6D16B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA51DA05B0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:28 +0000 (UTC)
X-FDA: 85226448216.27.899F699
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf16.hostedemail.com (Postfix) with ESMTP id 82E74180004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QDOtzo0Y;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SZRrezQ0aGrf6aoi2mjbpyD9DzDa0MzzJwmMo2zVh0=;
	b=DQxPlFpb8IysJXATdo5gy+P89xydxiKXCvI5SwJ26OrPkYrcnSLzyq1Kyy0T1urfFltLO0
	02x/djjzFv66VrsY5kS/hxArUqAWQsfGya0gBufNWqM5H7+ksjASDKw5pABa+ZmebntHxH
	f79jZQD+oHbmuaxGLgKKZAhhCq6R3YA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QDOtzo0Y;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725867;
	b=HzbIeTcPHaK1Sb5Y3h8ZzkGe+9yM7hthkKVX0wPQ6708NaB8jxyLHRXd2VhWqM/1pOAh63
	M5NRm0p3JD34BfqJDY0w2/zsK3xRpVfKPgAmtNE/YVyRMIEp9U9RAmStp3HRMItcho5+ij
	4HhZcd/tf6Lrn+m2IFBci9dYhAqBuE0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+SZRrezQ0aGrf6aoi2mjbpyD9DzDa0MzzJwmMo2zVh0=;
	b=QDOtzo0YbEPraF8hBNN1eIHHylUMG/0f8u5ka7yGUNTwM1OnOYxP9zWXeAlrcrPh3LHLBghb2
	nIQRJeX/fS4RhMOLtRND7crtI/jS6NinldAxrfL97sRs7OyUEmKcrvK/a+f42xeMlDcgBE0logz
	Y70h41sj0wu9iQS94ph0bQ8=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hmScM5hMgzLlTm;
	Fri, 18 Sep 2026 17:53:23 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id AD84440586;
	Fri, 18 Sep 2026 18:04:23 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:22 +0800
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
Subject: [PATCH v5 10/17] crash: Extract crash_get_memory_ranges() helper
Date: Fri, 18 Sep 2026 18:04:35 +0800
Message-ID: <20260918100442.3841135-11-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82E74180004
X-Stat-Signature: oek5iab85okjfccms6s9hw5kcfzjqugy
X-Rspam-User: 
X-HE-Tag: 1789725866-358887
X-HE-Meta: U2FsdGVkX1/MAmnqJ06uygWyttfgq0IbFGu72sZSRz34pWpu8YUJSwdlpu0jKtjUySUKuP5ZZ0XHWBgM56SN7GxqE5ejZqRuHQwdee6+l2cnlWtognG3N2OjfA1E5+DVxF5OMtjqmJuI6fZUYgpLjCL81b7D6EDvp8ksGoSoYKbD17hdUfLksoMOmhufCeZyDAZjm9yf1FuLnt8udwBb7YuKAx0LuDn4MR00mOkFEg8XufmV6HRLqAvXDD9yu/egEsxLT16doD5G12oQ4Ru2SVkZxbHQopLqw1VDVDjsOxWk0DKDK8v2MpAG70Y1/4fN90zO+SPCZYOqp5tu8jOHUs3Y+NdMIsksfv9m7iqj2RA9Mu9hjUyDyWt5WBzmHHIXPzh1YcIFVfLBx3DHlHdC9biPHMTR/TbxY/5HAOKfFtsbxd++QryGgdWhktl4CqK5P3TwUqcGw8w4kiqhDVcHVUGJlBvSoS1yn89tsbv/ELhpAtSUYmsJqoZmpEa+isfuWI+AtqD+9yrkReqAxKUsHWAIv46zx2xFLz0JzXfW4rfSyMAhoZxvn7YZ+y8g13upt9QXweJqf1Vjk0pad3HDjHvYw8FBj883TiuHLFHB0ulwgGD5lQ4TPE1YspqoS0uEW8ZqxTcNrndu22uZcBHBeM6p60Y6Jt010kUyTstWwBk67E6lX2c2vMMbfVR5/Om2VtBwhWulQ93uwgM3Q3NTVfdpL5ts7tk9oUVjUmvzTma4py0vwQ4W59M61ufA/v5l1h3UMTAn2t+fxCfGbSyMziIyMdZkSAaASMvLXQPe3RbMuGQm5qfInoLeRTS6cfvc9nts8a2srCatzjApTnr0+pQj4KW98vnq/SoXgYaqNy2lgOW8bZOyjMMcWT8eUmvhpBR4VyUnU+b27q3ARIiM3CW8eE2hpJwU3SbLrnJGKux4YSfx+5fQkEIWKhMN4p5mAxvopx7akQTq/Z7oUes
 U7DOZGm8
 +YJcWLJ3A1IZXcRh8EVQh+c581BrhLQIfXVbZvx53GXS7j9VByK1KvQuJvYdTcV6ak7FaLtYNge9K9se0IiV4jMYZJ6yMjEVB2kB8BHcSYSaxCG6LF42V4+bGwiOkOi23iVR5Qj2eh/tFY3jyU0u/4YMKEgoFKarYK3oeLo9qkrh7WxvLNPDbqvuYqw4IfLYJn7fsTdt3uBH9iTHnUPCCqQVKB4MDnjDV0kv+EmVXxNMzoFge6NbDjXL+8GxeXevAudwRQxonjrdlX+1SLxAq1C9Xk/GHW9GU6+fXa3t/B5kRtCdhaj4YEP1rm9hMjHhphf0UrUOT+Krz4Cs+4G5wBlbVQCM2kaqGy1NO53Sn/yJmtcxBodTUbCi46tF1OR/PS1qx+2pDp1fHY0prYhbPAKQSQyeXuVHcPCDyg753aknax7ni3Nfwofr4ypkQecPq50eVS/nmF6lWyWkWemvuFNuM4Vp2y6irusbMJIAzmqevcMOtGwIfSaLG4FNf6uhFvKnRxov8uMPuLkNpOt7sZiSUJoJsrLRz4hzeyyTqiPrcrCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the crash memory range collection logic from
crash_prepare_headers() into a separate function. This allows
the memory hotplug path to obtain and modify the range list
(e.g. remove offlined memory) before generating the elfcorehdr.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 include/linux/crash_core.h |  1 +
 kernel/crash_core.c        | 22 +++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index bc087124cd78..b1c816e98143 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -62,6 +62,7 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
+int crash_get_memory_ranges(struct crash_mem **mem_ranges);
 
 struct kimage;
 struct kexec_segment;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..406b68d2adfd 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -317,8 +317,7 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
 	return 0;
 }
 
-int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
-			  unsigned long *nr_mem_ranges)
+int crash_get_memory_ranges(struct crash_mem **mem_ranges)
 {
 	unsigned int max_nr_ranges;
 	struct crash_mem *cmem;
@@ -344,13 +343,30 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
 	if (ret)
 		goto out;
 
+	*mem_ranges = cmem;
+	return 0;
+
+out:
+	kvfree(cmem);
+	return ret;
+}
+
+int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			  unsigned long *nr_mem_ranges)
+{
+	struct crash_mem *cmem = NULL;
+	int ret;
+
+	ret = crash_get_memory_ranges(&cmem);
+	if (ret)
+		return ret;
+
 	/* Return the computed number of memory ranges, for hotplug usage */
 	if (nr_mem_ranges)
 		*nr_mem_ranges = cmem->nr_ranges;
 
 	ret = crash_prepare_elf64_headers(cmem, need_kernel_map, addr, sz);
 
-out:
 	kvfree(cmem);
 	return ret;
 }
-- 
2.34.1


