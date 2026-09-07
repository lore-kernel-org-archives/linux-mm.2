Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A3EEC79FA9
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3062C6B00AA; Mon,  7 Sep 2026 08:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291C16B00AB; Mon,  7 Sep 2026 08:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C996B00AC; Mon,  7 Sep 2026 08:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEFBF6B00AB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F3F81C035D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:44 +0000 (UTC)
X-FDA: 85186957968.13.B865BCB
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B5DF20006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n6KAgHz6;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785622;
	b=e2SWcGjXrTug8h7XE5045osxGTvJkPHafdVE774FeiTRmVSrS0kz4PaYSIRWIVXc6Snrrd
	OQSm7g0Q16ovU5oiEXyfMWdYPf3s5VY7lrrFHFuEOZn9+AP/Urj9CYh++T+eIbplGPpvRk
	NZieg2ZZLqFBdGypMIJw8aK2MD2J9Ow=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n6KAgHz6;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36bd1Aryi5uvtn548uu4wSOfSDdMAA0WJBii4KWoLys=;
	b=DlvwYG3XDBVEUYs6NeyZ1j/7ojZnxolabnrUgZhCsCu6aZCY6//KZYThx/vgbOHIQquLrT
	3E8iUdJAohPwc8t2scS5txiuXmu5RYpfJ4yPJZosC/DOUixuxpLDTV/Ji1/aTqq7kBF3qD
	t5LWKFYrmTrot4FGmuxNO+q572pnom4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=36bd1Aryi5uvtn548uu4wSOfSDdMAA0WJBii4KWoLys=;
	b=n6KAgHz6AmQudNNRUdMm9Y1neIc7wALlg5aNvxTbqdqGiHB+U26TuDZdrvBnX+EQxmfeelZE5
	CRCDDv5sfI43GDMRnSpw7v6x7KPkT4tMVlVGlZ1XWLqB+S1Xn8pfDJg8R+pnnHB7k0i2VM7pr5s
	kOWQ33LQzfCzBoyxFpXHRF0=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtq6pmlz1prlJ;
	Mon,  7 Sep 2026 20:42:43 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id B2E1640575;
	Mon,  7 Sep 2026 20:53:38 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:36 +0800
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
Subject: [PATCH v4 10/12] crash: Introduce crash_extra_elfcorehdr_size() helper
Date: Mon, 7 Sep 2026 20:54:02 +0800
Message-ID: <20260907125404.922123-11-ruanjinjie@huawei.com>
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
X-Stat-Signature: ig36fejd5dkg7u64kr38haes3r36r57c
X-Rspamd-Queue-Id: 4B5DF20006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788785622-573043
X-HE-Meta: U2FsdGVkX1+p8QVKaXTYYvOlGoaSCZzti63t+/xe5wH+RzyDwsfe3+SDa9wl6qqolZC14iJG4D6raZkP0162yYTQSE2ZMRLtxyTWYJ2BZZxWKvt+dQNiiJfhc2epr1Y5Soajamzdj4tsELiijiYGGc/dznFx5uSe1h+kdOoYqUrDzk5fDTel3s412jXI1ZJcll3v+JHPkciqEYzq4CigFYy/ymwh/XI2+DKOkWwd39qMEyCzJmUaAz8kQKyxrTmjpve9w4Kw91DJNizafTU+Q5/yYldBTE1RGkxltoOL3l2aOTRMeDMBXjBxEFqj8ZW06fVZODKJlGRH9M4UEQBLJHbH6D422Iyl1BSB92dCOqokYOKIejaepzi5YxDjo8XKQ6Gzsw3i0S8q5sOyzfppQlWFvjC58qLE/pHKBYVNZczm/bAhO1CelC4z9qm2UFCyTSGbumqnH/rm3e5mmjTJ07zlLiK0CCMQLJHpWA4mBmpfM0x+KvF2ESvNVnRvIa7nUoR7S6Oka12RaSdp7prVi8O7yO87CV08n1Dl4PJHNhFWfNzBMGPHuaE6xRophKuIZxt6AnaYXJTTYLsAlhh58PY3rYqcsY6FV8+Sbi1KhxltbwBi60T4gno38ffL83AZytLvOfghE+I8CYerNeXsuebH/eI4erKLfr1GzFzgKemCH6my3eFsePKWruDW3B8DBSciGLpnrp3freCPFfe6v73gtXPXDnkar9Ro6KMzdNJ6n/+k0N0eBqhJrIiZLeF+bjlUK+SzzDzZb296gDHm7qPfLLA+HcT+DhnlGpTCYZg2Rt4cPig5GcngYZMrZvDx46mdOzp25eboKydIS2GuoRemfIxFSLunhxYwoX0CGW2/x2kzyH/wePqUjxbkwPnZTdT9hbvQ+BufnlM2yg8JAxfF9lpzzJse7T5pCVlBHQImFTmFN06u84np23UT1yg3o6NmLusbHLbwM3ueSzO
 SlkRhyDl
 k0poIQFtArnkI1vOg2zxuu7oRZJ8VOr7sB1zrPzHiQJe+PeHJmWPRIC77JnvXMhmuy2aB3Zz0RSjptOk6aB6+NHbxNV5xwoeH8hjsfXKdCDdAocrJJwtMMd1m3lw4k+9mSP3VLFTLGXDvl7aNSGRq4ZZdftpVLvz29gtfxRMEAdWIZy3tzlHtLp7UqVMlDnQjYqbLtNn21vK4eJTO/LQQxcriFJhHZWzigZoc2a9QQbiAbLTEtMki2ttmiCfseR0KEHb5gM5kpIcu/TekLHuDz+gzpk3Gna1ZC9PgEoC3yvNMXjN0k1sJ9qN7OOP9SJm7NI3ztnM6ayjx+xdvtBo8e3f3/Ih3FL52cQR7NKrfoJG0LLYzpVQtcxvEt7KtY654Av+onbWZxNpWDnFC2BeqMBXAZl0pYNZ+FmASmCQETMXY6NeYh0A2oNYcXB6uulzkAiSuzFdzI2hp6za6b/vJLU9ltMKTNfeFWOjQg2j9ieed56HfxAcIcMMRd1drv9NLzcN+TonaNKDvUIS7bh4wCP7J8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the elfcorehdr extra space calculation from powerpc into a
generic helper crash_extra_elfcorehdr_size() for use by other
architectures like arm64.

Strengthen the original powerpc check: instead of only checking
the loose CONFIG_CRASH_MAX_MEMORY_RANGES, the new helper enforces
a strict compile-time BUILD_BUG_ON() to guarantee that the absolute
maximum theoretical number of ELF Program Headers will never exceed
the ELF physical limit of PN_XNUM. This ensures absolute safety across
all architectures with zero runtime overhead.

The helper also provides a zero-size stub when crash memory hotplug
is disabled.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/powerpc/kexec/file_load_64.c | 19 +------------------
 include/linux/crash_core.h        | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 6075b1c88511..2b0325e4a628 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -374,23 +374,6 @@ static int load_backup_segment(struct kimage *image, struct kexec_buf *kbuf)
 	return 0;
 }
 
-static unsigned int kdump_extra_elfcorehdr_size(struct crash_mem *cmem)
-{
-#if defined(CONFIG_CRASH_HOTPLUG) && defined(CONFIG_MEMORY_HOTPLUG)
-	unsigned int extra_sz = 0;
-
-	if (CONFIG_CRASH_MAX_MEMORY_RANGES > (unsigned int)PN_XNUM)
-		pr_warn("Number of Phdrs %u exceeds max\n", CONFIG_CRASH_MAX_MEMORY_RANGES);
-	else if (cmem->nr_ranges >= CONFIG_CRASH_MAX_MEMORY_RANGES)
-		pr_warn("Configured crash mem ranges may not be enough\n");
-	else
-		extra_sz = (CONFIG_CRASH_MAX_MEMORY_RANGES - cmem->nr_ranges) * sizeof(Elf64_Phdr);
-
-	return extra_sz;
-#endif
-	return 0;
-}
-
 /**
  * load_elfcorehdr_segment - Setup crash memory ranges and initialize elfcorehdr
  *                           segment needed to load kdump kernel.
@@ -428,7 +411,7 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
 	 * Account for extra space required to accommodate additional memory
 	 * ranges in elfcorehdr due to memory hotplug events.
 	 */
-	kbuf->memsz = headers_sz + kdump_extra_elfcorehdr_size(cmem);
+	kbuf->memsz = headers_sz + crash_extra_elfcorehdr_size(cmem->nr_ranges);
 	kbuf->top_down = false;
 
 	ret = kexec_add_buffer(kbuf);
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index a68c0a6346f4..b447facf37cc 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -106,4 +106,24 @@ ssize_t dm_crypt_keys_read(char *buf, size_t count, u64 *ppos);
 static inline int crash_load_dm_crypt_keys(struct kimage *image) {return 0; }
 #endif
 
+#if defined(CONFIG_CRASH_HOTPLUG) && defined(CONFIG_MEMORY_HOTPLUG)
+static inline unsigned int crash_extra_elfcorehdr_size(unsigned int nr_mem_ranges)
+{
+	BUILD_BUG_ON((2 + CONFIG_NR_CPUS + CONFIG_CRASH_MAX_MEMORY_RANGES) >=
+		     (unsigned int)PN_XNUM);
+
+	if (nr_mem_ranges >= CONFIG_CRASH_MAX_MEMORY_RANGES) {
+		pr_warn_once("Configured crash mem ranges may not be enough\n");
+		return 0;
+	}
+
+	return (CONFIG_CRASH_MAX_MEMORY_RANGES - nr_mem_ranges) * sizeof(Elf64_Phdr);
+}
+#else
+static inline unsigned int crash_extra_elfcorehdr_size(unsigned int nr_mem_ranges)
+{
+	return 0;
+}
+#endif
+
 #endif /* LINUX_CRASH_CORE_H */
-- 
2.34.1


