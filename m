Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E47D5C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55596B00A3; Mon,  7 Sep 2026 08:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2CBD6B00A4; Mon,  7 Sep 2026 08:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA63F6B00A5; Mon,  7 Sep 2026 08:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80EE26B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1549680156
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:39 +0000 (UTC)
X-FDA: 85186957758.12.CD9A7D5
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf01.hostedemail.com (Postfix) with ESMTP id A226540003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QDOtzo0Y;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785617;
	b=DTWimp+1M5Zh9Jzo9UPflcp00OXDjV0CJ9Q1BSM27cx7rXRF7lUPdh5wz7DR7OAWqVOywf
	HrYfWBxE3WKcTTBX7jttE+PccJHJemDbwK70u1PJQ4KmOLhbsoIxr+pR2hzBiEvakerR2g
	j7q9D6nnN55wDHfSV7Itjg4E9xGt1yw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QDOtzo0Y;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SZRrezQ0aGrf6aoi2mjbpyD9DzDa0MzzJwmMo2zVh0=;
	b=kvbGRsm9k/kVgm8bPtJ9v0CHhv5Z0jZwES/Dkkjq/DbHx05EJG53v+0d5g8sReQLPTjwDp
	bPeLcuM95O0DkjLdr+LJSjOLNU3sLfs9WV6CmUvW8oiDjhZNNzcD2smyJTYW1ZlvrSCXvU
	1gRyePviUqWWM6l+SPZWMVe+2EQN2H4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+SZRrezQ0aGrf6aoi2mjbpyD9DzDa0MzzJwmMo2zVh0=;
	b=QDOtzo0YbEPraF8hBNN1eIHHylUMG/0f8u5ka7yGUNTwM1OnOYxP9zWXeAlrcrPh3LHLBghb2
	nIQRJeX/fS4RhMOLtRND7crtI/jS6NinldAxrfL97sRs7OyUEmKcrvK/a+f42xeMlDcgBE0logz
	Y70h41sj0wu9iQS94ph0bQ8=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtl1jcHz1prQs;
	Mon,  7 Sep 2026 20:42:39 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 0873C40538;
	Mon,  7 Sep 2026 20:53:34 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:32 +0800
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
Subject: [PATCH v4 07/12] crash: Extract crash_get_memory_ranges() helper
Date: Mon, 7 Sep 2026 20:53:59 +0800
Message-ID: <20260907125404.922123-8-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A226540003
X-Stat-Signature: kdiy3z53ti8a19h4egdqb9jgfehdqi68
X-HE-Tag: 1788785616-142147
X-HE-Meta: U2FsdGVkX1+9LuTBTLeiggdbqVahLCIp5VNYZMOBF7C7fvyyaZecKNF7gQyG9c4huTvnjj8CS19eGarwsyyq7y7B5flXN6gwPsFua4RtpFevEWR2AdhPQMy18EKHPJGdjeIyBD/F0uaCofCxjEJUfm8fHFU2UFJ57OBlQB1gOfq0asadDXSb5meOnEPowygmitNhF+Pe1IhogiI5VMIpzn+VFII5rhhyMxR2sVCxzwFwytWADIk3skQYd9cS9FSa4bgz4M+goS/TkXd7YysK+Lk4tr1ye6XEe+h2UTEJZZbIdFRaIyqaZzIPvjZ9MHkO0SMyNjzOCNwQp4+hcmTynmqUnTUvfEa3+EWDdtkdR2ct42uMCio1ot/yfymBx4w/etM6D1NvYIARVNTY1HH4Sajh9/IEiFvW0Ug1T/4GXNEEZNX4GGcJ6GZcP0bh3a450Ih5qvpopZA0bJToW/nVEpR0cnVJldKumOzeV7wwWOQN7Fiuw1tMX6pOYc8gB1ecDCDgGoW2FM7T80wxNar6lmv0vHR0rqFTFwS/H+ld1iZbUPWSNVpfj2fRtqZNbZq8g9ZlzE3l8xXO9RLwC+BOwCt1nSOzlGMpMvNifVGfb4cBxjU+kA5TBifoQ2y6mSiXaEWwY6g6QDkvbimZODE3oPAYaNdYzLP9cSp2+rOs6rzIoCTv32On5JaZ1fGna/0tIfXdfypkrMTMUXbWk9eed4q/iAuwSgTJWuxysDUzw3bvauPoHVX/hKFXYMsLVhRkmLBBv2AbR/Ege8KJ2T+NrMBM6ofR2NaGG2GWycMwFKUrvQ7n3Z1iwB/b1c/L4xXoZatqBxoM4qrNwnFD0SW9Zz1mdKXGL7+KIoxUx+DRv8on97lnrMX4ZhSnH9jwYt7j9BYE37LKEL970CDuVUngSTH7YCi9gBi7J8xDfnOmEFSbJS+CULHJ5IPgWWKv/CNw6ZYGxu943BFPx04ubF8
 lKTy5byE
 2zLbE2zkMjcN64cyGzzI3PPq77+dqgHQ6nDUprMXmP5z4iW/gXEC8g99FLBTZDgWjOKxmrORX0h4u0vC4w9lSwD1nerCVt2zUJwR/ZToDtJ7mc1WD58tlrBiPkx9U/2YvNL2Qp73VF5iTV7tl41MoqpuPZyShd+fq/6l5Flt7lyrI8Ki65b69nnCN+6qHDXMjIy1pIPwAneLsa99cJYRIDyYa+GGAho87UJxsYlCfYDyGucaiz0wIm3WpBHctSEBmnUFGyt7G1bcuoOuUESfAwoHkevo2fattsdWLUQ/v27dOTm5JeIfhOLpb8qJiqZuM/mNiiLpzG0cXUBcF/7GnzfkxQdAqq3zZwlO1g2V3aaF5hEym8zr2wbf6YfrMYGJUMJxSx7fLhjLTgxkHtZxUrwZN5yh0OanI4VOoTxYzp05JocqTf+cJjK3H6CLw3zj4bQVZhajFGDD3bIHAt5VJN3YI39p1hgDACpM/
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


