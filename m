Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245EAC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE246B00A6; Fri, 18 Sep 2026 06:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886456B00A7; Fri, 18 Sep 2026 06:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D93C6B00A9; Fri, 18 Sep 2026 06:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 428346B00A6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9F5D1605E6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:45 +0000 (UTC)
X-FDA: 85226448930.18.57C4214
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9279640004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=C2eZF9Mr;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xY6MkLtAML0NhdwFhEh6HEFrtMWS+BaF8Jv6SYbylCI=;
	b=o8ldzajuHXDJjyx+qP5lqp101vOHQtkawHDzHuS+2y/2m3wmv3ueIMig63lYmVwAJjN1R6
	OvDURYJOHbYcqb2kSWL3v0HQhaq5gK1Cwdh2xoal3YuPjbZk8Y6102HmIxWTuxfA7I9yz2
	UgzcSlPWz2ctrCi+RDtaL6d1ohzVQNk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725884;
	b=MNpwfWqi6w3Ti/gqzwK+MbBbUPIGNX7G71BdF04hlvc+LlUvclZIpjyO+zB8tQh15o6Qtd
	G0gyh96/eNlk9PsczwW/0H2M8OUHGgGfV/627klXWBloPmHgtQp6fX3BpJOpBoRY6pp475
	QBu63px4JMTi9nqyxnL+oEmJhjuKaM0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=C2eZF9Mr;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xY6MkLtAML0NhdwFhEh6HEFrtMWS+BaF8Jv6SYbylCI=;
	b=C2eZF9MriTz09Fyd6sSJRN6eb3mHxLBMVzS2eueaGbQwfruJTStfHmzacHg2EphpPC7IEogVN
	vKy7HEOXjk8HJKqpXYqJT2TzYh11n9eTIQIYH9HAE08ba7TuLwPVwJITDWlXJ6ajgI17Ju7r/zg
	o/XgABw9N1BRe9NbOBaj9iM=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hmScM61twz12LHv;
	Fri, 18 Sep 2026 17:53:23 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id CF0FE20333;
	Fri, 18 Sep 2026 18:04:30 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:29 +0800
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
Subject: [PATCH v5 15/17] crash: Introduce crash_extra_elfcorehdr_size() helper
Date: Fri, 18 Sep 2026 18:04:40 +0800
Message-ID: <20260918100442.3841135-16-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fiymz8iop1dcfztxohc1wdf3r9gue7k7
X-Rspamd-Queue-Id: 9279640004
X-HE-Tag: 1789725883-807989
X-HE-Meta: U2FsdGVkX1+fYT/rUr2iHSbiVtaHU638WGKeRjd4g5wU5IF5N/TW0KSBpni+bn4YeR+OKM8UnQf9Yov65sKvYSkIVqtiAi638Wdo5XhQ+XTRVNt4mLDObjKkpbsSiu56wmCQsif3j2Ef//ZNN5FaxTRYRuvcYvKzwHvwUw0o5Jcet/kIf1WKVrYB4QJsRtykdtH239QN9+ZWpIM3wxKTPHcvGsXSfWfcOAH1JMfOjPoUCer3fYAssRVn//8GInCJ3nBI20E4h44xRVyVzHZcoEtCPBstHF9ajTjbUEZ1edukxM81yQnCfxcP61dpvwL4UeRt7pM2ouPbuYUy49QlNAEsSw69zg1nA6tm1uc1Fz/Yj4STelJROdWmNaCzhyY9iYWCd13SDYTJuUsL/749cwj748bD7CcYlWeWZIkdJH2adPmhpYOelWn5mH35m+mF2T29uTpwNM+yHsF8Bd3854tASfZ3aC7tK4kS51/rvQk2rQywKkj4Nt8nIkTIarCF5ViqOCX2jphaHilNDiPFx6s88eRMLymZTjVJCDhOfBsMplBmcRUyVlF4V10QRrNqUIKi+OCyBNaY4yafdSnSaot54BioCVrOIv3LoHNMhiMjkjLPFAWqTxSco/sj1AWb9smVY5QY8muMqsxgqKo+1JzPySJnhjcc2urE5Aok0iD6MNKsev5mYNVfiy/+Tw2Y1zKJYqIeWAy3c2uSa5aaJrjpixisLKf3Oojozd/iQ49G1y9cl5n8Q2gQ35k/axtsv3uGK/0uvlfXvNXb6aDxvzcDZG/6r87+ZavKn/2hwt6ayMrMd7T+iK7iXRdU9EShpoGSKietXTS5NUGwlwfGi1+tntsQhAC8xl21bB8mbBOb3MRMwGMIQLtZAIc6vCSm2TzB3CG2ErWlgt7w+zzOYVt7zsb4Bu1AAWqbq5ARNH77lSg4y4kOXdre+c2ZpJ9mwskpStIJfBav2kNTF1x
 IGy7hfkJ
 eee0FukjVPcphPtU5pcNOTdUHOCTzQ1ktWlekMVNb4L8fWVz7djaB9QIfIF2Vh5n4XX5KIYCaYQZunxc86abZObEHECv4v5UR/X7Sv2O4fDPlIUF++mBXM5ikgUkVM2nFlvNfswqg0BtyeAxMcPpGPnDWRHD6bNT0JIpcM7vT7fevnEBf4NzTVtFkm+JjYtZg234Jzhxc9dJm7gIuAXGfCc+YBa6y4hP6mWGttkTJ+sx4Kgw1/ZJwk/sP7dSC2HE5RFTg2IisMButMPZL9/DU8HLIiCGI8qxVRC+8GQCtKyn0r42ZR6PTeNF3UZ3JuaDKXQQrHSaLmaURfjO07x9qZ7+psckrj0Sdp3C2Q1K6nGAqRVy2rmWVg1cxjE6fIP37ndJWgKW6ayN5eo0Z8HNu6CxlUmqO8IY4RQiYCgFLxpdmieX4dPX0OcDz+hx0zGtlWUVseEJvCjj7A2q8iqIcaCnUgETdexCwW2UfIgEwGLAnFvXAt4adKFSORCDmNpsYMNrlEAl1WGG4AGQhpkI5JFZtnxWfc4dT2sInQhEf9tOESXkwQo9HopmLWOU22kyBGJghzUDQX2kbgSADjjED96CG24ZsTOrlVX7b
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
 arch/powerpc/kexec/file_load_64.c | 15 +--------------
 include/linux/crash_core.h        | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index bd80c5fb1b1f..d3512c85ea83 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -374,19 +374,6 @@ static int load_backup_segment(struct kimage *image, struct kexec_buf *kbuf)
 	return 0;
 }
 
-static unsigned int kdump_extra_elfcorehdr_size(struct crash_mem *cmem)
-{
-#if defined(CONFIG_CRASH_HOTPLUG) && defined(CONFIG_MEMORY_HOTPLUG)
-	if (CONFIG_CRASH_MAX_MEMORY_RANGES > (unsigned int)PN_XNUM)
-		pr_warn("Number of Phdrs %u exceeds max\n", CONFIG_CRASH_MAX_MEMORY_RANGES);
-	else if (cmem->nr_ranges >= CONFIG_CRASH_MAX_MEMORY_RANGES)
-		pr_warn("Configured crash mem ranges may not be enough\n");
-	else
-		return (CONFIG_CRASH_MAX_MEMORY_RANGES - cmem->nr_ranges) * sizeof(Elf64_Phdr);
-#endif
-	return 0;
-}
-
 /**
  * load_elfcorehdr_segment - Setup crash memory ranges and initialize elfcorehdr
  *                           segment needed to load kdump kernel.
@@ -424,7 +411,7 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
 	 * Account for extra space required to accommodate additional memory
 	 * ranges in elfcorehdr due to memory hotplug events.
 	 */
-	kbuf->memsz = headers_sz + kdump_extra_elfcorehdr_size(cmem);
+	kbuf->memsz = headers_sz + crash_extra_elfcorehdr_size(cmem->nr_ranges);
 	kbuf->top_down = false;
 
 	ret = kexec_add_buffer(kbuf);
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index 1296a9b29974..aee2449f343b 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -107,4 +107,24 @@ ssize_t dm_crypt_keys_read(char *buf, size_t count, u64 *ppos);
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


