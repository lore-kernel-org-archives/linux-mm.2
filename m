Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D73C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812436B00A4; Fri, 18 Sep 2026 06:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C216B00A6; Fri, 18 Sep 2026 06:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB426B00A4; Fri, 18 Sep 2026 06:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE1B6B00A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2EED160605
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:40 +0000 (UTC)
X-FDA: 85226448720.02.E7840F7
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5B247100004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="0wcIVz/N";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725878;
	b=wTk5YrVB5ZlfRpiPgfjoXILcs6z8elVUTsb3gaiWE2zzRe0ST0Dv/2yJb83ilUAAIhZWra
	w1hJQuLcurx5wR2/xgib/HzZGf6se16KFySRSq/bK71RJISet0C8GIqiqXmYbA0UPewitV
	mGe3GP5kbp23nrfab2WrNl5IAxcI6MM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="0wcIVz/N";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnxxiylnyHipl/A8SV3AAIGnQGPzs5xWXDe5kWQdoK8=;
	b=EXMH4Tyw+o9upuQgs7fHcDrt8xvxbjwO75NiQVVHpwsiUTZmbUjovFVwYSjfZnPcgRCadN
	irY8OJtCwNjTXOXGBV4kW99Y3qcW7Un4qmW0EhIP7l5bLe7haRtlrc4CDO0vq21ohU75zh
	uqbnNjy4z0/mOhK3LuDOhRi+1GvrhKw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PnxxiylnyHipl/A8SV3AAIGnQGPzs5xWXDe5kWQdoK8=;
	b=0wcIVz/NKsz3gLpf8y14MTzeo91L7xA17SSIcnva1ijvtAHPfvMAiGbgY84jOLMdOSDODlTqp
	FE9GxBfXkkJdMRm4pBCXfVlwvRpVN7aHNLNfNcYCiXQH1Z7phnSffRJ7Nq8BfOP/+sVIY+6zxF9
	0VjE7YG+aZCdI1BcLH46bJU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hmScB2P4Pzcb40;
	Fri, 18 Sep 2026 17:53:14 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 70DAC4057F;
	Fri, 18 Sep 2026 18:04:29 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:27 +0800
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
Subject: [PATCH v5 14/17] elf: Introduce elf64_phdr_size() helper
Date: Fri, 18 Sep 2026 18:04:39 +0800
Message-ID: <20260918100442.3841135-15-ruanjinjie@huawei.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B247100004
X-Stat-Signature: giwp1upj9oxnw6yax95t43t1oj1uaa6f
X-HE-Tag: 1789725878-444091
X-HE-Meta: U2FsdGVkX18DumXMvEPFNz5G+Ksx4aaI12jfQOMwn6M9K37ggZbGnc0A6mnvPY+Zsz01jcjQ7YZmFXMlC9y/f/Yo13fdV6YFpnOweplb+QayilwJZjBgXsZTHUL2+U7Seq7QB6eOvdaJUPMJTmf8gCYgU4HbVYMVI4iOyva3eP0fkSNrpEGshNmWsZOs7M/AXpLTfVIeLgYFjEAOiQ9CEKziDoiy67RwKGPPZpC2thp9PRXo3v+ZGFomXL4yzCt6Zns9RJne2Efmj0bTzKhwVw432bmx19uGy4ThKAZl16bpCXjDFNcFFf/AF9HJ+IJXPRv4YirwyC9uyvYAgnINWRCNNZOJP+Z+rIWDPgBgyhloGgxP5hL5q9dPhzdqaum7zR6Ynw4MzrEPkVmfRFotmxoXlY37ZgsRFB0k5IC9pdqn9L6zB4gUsdq6BpQ9TYPZl2CIuGxfU6W1gzhixrZH5Ggk72ma6DRtBdEuePY276tFVQpYM6/3PSUjFIo5aKObOgcI9ihFCKUkZrHSAr+RHzQtUlJW1tLrQI5yPTMJfkCDzFrO0oizD6yUE9AEIJ+lFb1MJte97EDGTaYfw4XRnzJvlCg9+vzVOCSqJSESr+lTUVeFCqq27n1TW14j+9JHEEv3Is3dyEZfUHepdBBKPSJ9A07DEkcqPl2I7QfTLuQ/TIUG8Jz8BY+9rw4viQLah4jhYaROZS8hPph0KFyeKs8zzCgKcKuQbsBQj26w4VwaJvY32n+UkNkndsRrkbhLeIdiQWo0QZFMI0pckj6qJua7XWlzXThuuCSOBS7q/28wOE3nPJRe4YkJ8XEXWPp4ZdJD/ebbIs5bfbowxtrUR1cWrD8uzLm6hhE98UQcPYXoHWK+29wwFv5vGCfZleRMr29O1V6uNW5VeekxlMaXwsUx1IYj+9Ml86iq2RdZdWVDgjZpAslN/1UD9FWNjuIbBK9W5kSH0OvRwVxB7CS
 8TQK91Vw
 ze2upl3tgyjKwHB5NzH3Vy/8SzJdFQbIX5qkE50AO2WL7133URf/jeAe6U5cHa1XPLd4ICxl2VmpYJ6Cj5/ogC1sT1uq7Td25DWZJ2u1KqDD8ZAIe2GO+qHq9hMcJzUZu8jLl5cYuFWprop+mjOIzex/PGHLCx8RwV3UqE0O6C9F4DjoJaXIHp/rlUD9vln9YuIL+OSZ1IVSrZUZEPk5xO0QHoVeAVwSAVMsbj0Lk+LrQyUiFSzb/6K/hTDFYckhbakNOnlfbsvgd8byfPbQDAbk4wgfL4P3BHZwxLCWA6wOmH/t2+ulYYUL6FU/T8R/mNU5XIt3xUbCDPiWXuukVVD2WYVWRmHt0+k86WV5ArZ9T7EANGBXSM24N43kIaeQ6AX5z+WPtMeOuUKQrsE4OBRT4JfHBUJZrtsMWZ4D1d+84wl54AZqNJz6uvABlP9PWAmU5WxUo/GSV9SD9JW8lT+0uctBOrpOEt3sSbKZekFC8pPa1WpSDfKXSZBfwJjFjsvW3QmjOsY3W1QaDFIeOJIJGMSd35ZaPO2cmBgx46eLRKtpyOTTeO6Ovwv+8Hp+IqqTNXDB8SEfwhoBZLzQy0aYpIodB7sDj8Fb3VkPuYIhPt7EeuqwZ4VTHrmaW1TsO3qgPaq9WlGCm6Vmbb5c9yF6cRh+0fq0zqGfi/umAt7mXeU2d97sHzdRkaKIAlIWdIuQXzKJouaV4ugo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a common helper to compute the total size of an ELF64 header
(Ehdr + program headers) from the number of program headers.
Replace open-coded calculations in powerpc, x86, vmcore,
and crash_core.

On ppc64, struct elfhdr maps to elf64_hdr, so the powerpc change
is a pure cleanup.

No functional change intended.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/powerpc/kexec/crash.c                 | 2 +-
 arch/powerpc/platforms/powernv/opal-core.c | 3 +--
 arch/x86/kernel/crash.c                    | 3 +--
 fs/proc/vmcore.c                           | 6 ++----
 include/linux/elf.h                        | 4 ++++
 kernel/crash_core.c                        | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index 8ede33740fc0..0cdc64da35b8 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -478,7 +478,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		phdr_cnt += CONFIG_CRASH_MAX_MEMORY_RANGES;
 
-	return sizeof(struct elfhdr) + (phdr_cnt * sizeof(Elf64_Phdr));
+	return elf64_phdr_size(phdr_cnt);
 }
 
 /**
diff --git a/arch/powerpc/platforms/powernv/opal-core.c b/arch/powerpc/platforms/powernv/opal-core.c
index 32662d30d70f..fc0aad61504b 100644
--- a/arch/powerpc/platforms/powernv/opal-core.c
+++ b/arch/powerpc/platforms/powernv/opal-core.c
@@ -309,8 +309,7 @@ static int __init create_opalcore(void)
 	char *bufp;
 
 	/* Get size of header & CPU notes for OPAL core */
-	hdr_size = (sizeof(Elf64_Ehdr) +
-		    ((oc_conf->ptload_cnt + 1) * sizeof(Elf64_Phdr)));
+	hdr_size = elf64_phdr_size(oc_conf->ptload_cnt + 1);
 	cpu_notes_size = ((oc_conf->num_cpus * (CRASH_CORE_NOTE_HEAD_BYTES +
 			  CRASH_CORE_NOTE_NAME_BYTES +
 			  CRASH_CORE_NOTE_DESC_BYTES)) +
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 7fa139725514..6711f8bf1db3 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -374,8 +374,7 @@ int crash_load_segments(struct kimage *image)
 		pnum += 2 + CONFIG_NR_CPUS_DEFAULT;
 
 	if (pnum < (unsigned long)PN_XNUM) {
-		kbuf.memsz = pnum * sizeof(Elf64_Phdr);
-		kbuf.memsz += sizeof(Elf64_Ehdr);
+		kbuf.memsz = elf64_phdr_size(pnum);
 
 		image->elfcorehdr_index = image->nr_segments;
 
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 44d15436439f..ff324969d798 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1238,8 +1238,7 @@ static int __init parse_crash_elf64_headers(void)
 	}
 
 	/* Read in all elf headers. */
-	elfcorebuf_sz_orig = sizeof(Elf64_Ehdr) +
-				ehdr.e_phnum * sizeof(Elf64_Phdr);
+	elfcorebuf_sz_orig = elf64_phdr_size(ehdr.e_phnum);
 	elfcorebuf_sz = elfcorebuf_sz_orig;
 	elfcorebuf = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					      get_order(elfcorebuf_sz_orig));
@@ -1605,8 +1604,7 @@ static int vmcore_add_device_ram_elf64(struct list_head *list, size_t count)
 	}
 
 	/* elfcorebuf_sz must always cover full pages. */
-	new_size = sizeof(Elf64_Ehdr) +
-		   (ehdr->e_phnum + count) * sizeof(Elf64_Phdr);
+	new_size = elf64_phdr_size(ehdr->e_phnum + count);
 	new_size = roundup(new_size, PAGE_SIZE);
 
 	/*
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 5c402788da19..400f58a13d92 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -109,4 +109,8 @@ static inline int arch_elf_adjust_prot(int prot,
 }
 #endif
 
+static inline unsigned long elf64_phdr_size(unsigned long phdr_cnt)
+{
+	return phdr_cnt * sizeof(Elf64_Phdr) + sizeof(Elf64_Ehdr);
+}
 #endif /* _LINUX_ELF_H */
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 852a5f51d472..8e30ae107a7c 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -193,7 +193,7 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	 */
 
 	nr_phdr++;
-	elf_sz = sizeof(Elf64_Ehdr) + nr_phdr * sizeof(Elf64_Phdr);
+	elf_sz = elf64_phdr_size(nr_phdr);
 	elf_sz = ALIGN(elf_sz, ELF_CORE_HEADER_ALIGN);
 
 	buf = vzalloc(elf_sz);
-- 
2.34.1


