Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4772CC61DC7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA9C6B00EE; Wed, 26 Aug 2026 05:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5649D6B00EF; Wed, 26 Aug 2026 05:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4553F6B00F0; Wed, 26 Aug 2026 05:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5766B00EE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C8D31A02F8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:33 +0000 (UTC)
X-FDA: 85142887746.29.AB2A04F
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A3B020005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JX+hJB4h;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gF1CX+SLowxFh9fJKRvX/sCOgXb1E06TJatahYgRnw=;
	b=wrHTJ6zbxtCMmQtnHIqrzReg+Sftvq+qWch8LQGuHMfjJmwwrfkfO9zFzRUCuEuaRzA+N8
	DpFLgoPdyy9kY9mzerzmtT6EzJGam5IXignxajnvg8gFyFq8xuLPh09VN9kfEgv0BKvt+D
	cleNckYOoJyeQcJcU9y3niBISWw7fZA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JX+hJB4h;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736331;
	b=7fs5Kk3tUgx7rXPV23UbMvN+9nVmICfEEQ17oBJi8BNe8vvj5jgJ553ogdnlyiWKq++TwH
	I5CT6Co39iltwuLtV0gzV/3xfSjiwNK5XsD4JT0wOSyv4uTfD8I4yT88g0ps45kbIpEvaS
	WOMy+LX0dBJSibziRyZ2W8h16d2iTnI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0gF1CX+SLowxFh9fJKRvX/sCOgXb1E06TJatahYgRnw=;
	b=JX+hJB4hTDDgkqA1/sg50c8MkVgqGYd5+tQwQD3uhUYhWr5tSyj9b7DiiSZk+6f6uc8AIE9K+
	ir0Lyq63+jQ7c35zwdyKfSwDnYHnSJCkKIb5GmhVr88An2gsqRKmbRDNYbe4sIKFnFBQ50Jwe6I
	os3GmFKja6Un1xAaUllqd0w=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrN2SFjzRhrs;
	Wed, 26 Aug 2026 17:14:44 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 0BF314058C;
	Wed, 26 Aug 2026 17:25:28 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:25 +0800
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
Subject: [PATCH v3 08/17] crash: Extract crash_get_memory_ranges() helper
Date: Wed, 26 Aug 2026 17:25:32 +0800
Message-ID: <20260826092541.3905933-9-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: rp6pkinssupz5gb1zgfd4qjoihudsge1
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A3B020005
X-Rspam-User: 
X-HE-Tag: 1787736331-184244
X-HE-Meta: U2FsdGVkX19zBmbEyyNOVr1hw+fBnlfk5JhyUEM3C4VAXeGsCsp59DjgBHhSvvBLSxmswGDvRn9lQwks5U+iQRKZCYWnE8ua9gtsDHMiOi7Gw9s/WwbZIrv6jCkW1FkpLW+jWLjfr7mtKfcLuy6ggd/hitXOmVn+C6LiNNVUPJQvLvXpHjnXcWq7ubIzeJgZUZgaPIJMm0uOM8ARDd7woemUBuUSrZDGUsQtg2V2yQcWM1sosDGDFRuzkAusTZpJIcN+AJauO3BfOVruALyYVHmMugS4DixcwuULwmQctMz0TywtGZXusArJVEF2qtEEPk/NDU2Wo+u0Rkovvo2n2oPoKU40F4PIg4LqlPPwIoOMuInQn819qfoNXx2UJoplt1NIWAWGvsqKN5sNneqeDYzgLWNRqy3aLD4WGd4siniMUylbDbNxjbQaAUbFYiWLlubmJ0LqOPzo1XraBpv8ha+9G8emVKsx9BHmVt0Vbst6l928sn9OlRehabkhqUyuHNOM29LqApFYjhtOwMnFObCaaTp1/f8VHcT8HBL0uy0u+ImS0g94mTvy4tc0mxDuZfi0TEYq1k57FHu2l4KD+STPWQ1mQKuXbcPE8azNqgPkcOe22rmnD0E+6TAmVO6Hc2YjiQI468KA1r2f5SJLOAzxXV3B0Na20FFNJe6Fu+e4suJUrPOLdvdUgeS1I7HgcLSbqQLy2G1DD/c3mwtvJhWQWC/JQGAaYRjqanRVmQtPplvKSHiMwIPQa2Q900exk1/hwBuKqPbLLiFdpOYq3GCegGnRsfM8MJqFRLnVSbH5VIRmnYsQii1Ur6yxjJ8mejZaC7bF+buQ+tZjFJA5FHj1IIpyUCh8a8rl7uYS76sCtEoPMOMfwQ9cn+CVJeauMWuL7O6G6ihXL2H9err4Go0jxQXlefv6M004hW6hS19L990L/F/PfifZd8Irjd5hFWFbhwQz2QHOthvlnxf
 kAWNvR95
 UvlhbxRCMRm+59I7kx7mrt6zU8bCN/wveYm4ocLbtF70jU/jChRJGRsnfm3/yXp/IsPy0dK2KkcXM9tuRl2WyMyyjVS+OR04SdJtf/6huhm18mU93Ov1n9pyTesXFcCTWnEZMCadu9erujQsZdBjiT4c3MDKGZLV1wUnyF0Q+1UAUVE0Dgj9opZx6oXM8i779bOw9VZPOqDSNRmdz6ulHR/ZiraZyvLHH6RIyhyOn6zkisNFcb43Qcw8pvNkVdmRANr+HySGvX9iUNBd58kVebT2vG5U/DnCOlL6ClS9pi/kxM+GyZAes2EbwZtthKAoZupzs7iDs9X76IqzyOuAg7sWdquBPCDee6tG2F50QKVEzMyEWRJ8A4JMbDIPdSnqS522iNBdkolxggsHQ/0DR6hdK2rannO94qNsBuq7cwdzZU1cZnA/PdLLwTISaooIqeh4RLlCNe+U1Gzgs4uOWu9y0wrd19GliWRTR
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
index bc087124cd78..619af312bd9a 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -62,6 +62,7 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
+extern int crash_get_memory_ranges(struct crash_mem **mem_ranges);
 
 struct kimage;
 struct kexec_segment;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index d0bd2d0cf899..991d1599cf9a 100644
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


