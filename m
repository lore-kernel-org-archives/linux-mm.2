Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFAFCA101F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9588E0008; Fri,  5 Sep 2025 06:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F04F8E0016; Fri,  5 Sep 2025 06:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E7D8E0019; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A141A8E0018
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:37:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EF67160665
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:37 +0000 (UTC)
X-FDA: 83854845354.21.F48EAA0
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf11.hostedemail.com (Postfix) with ESMTP id 51D8040016
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:37:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757068655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4rMXI662tXlPUgZz1tZHQFISwliqndcRvNpZcbyqzc=;
	b=k8fRH18izf5XQ1K3g7w8I6YV+CyGOEt/oItchgv31ItGUfe+AGqiBZapau73n6/CR3mEJJ
	FI/HETxbyH0mmCCDhIoo3IFNEiz557LzmF2m28MM9jw9AJhHtCdCUMAaGlyYD3ay05MAO/
	koLyePnHT99Ck29g6BUzzTCVj2gQ+wI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757068655; a=rsa-sha256;
	cv=none;
	b=ht4RDYFGDPyT41nkQBKYvNp+TyCDr8rcOT0fkaUPKDJNka667dogW3EoIkVLuRXUNztaou
	AnF+GIhWgSQT4hnSBYbUCfSMVlFsk0iwbwpO/85B0lT4P5ZZeYcYgvXz++5CqP5lGQwafC
	j5V3ylBRkgGEpfQMU3fnnm6z1FgtzFs=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowABnwaNMvbpoocLNAA--.50311S5;
	Fri, 05 Sep 2025 18:37:02 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jan Kara <jack@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@redhat.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH v9 3/5] riscv: Add RISC-V Svrsw60t59b extension support
Date: Fri,  5 Sep 2025 18:36:49 +0800
Message-Id: <20250905103651.489197-4-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250905103651.489197-1-zhangchunyan@iscas.ac.cn>
References: <20250905103651.489197-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABnwaNMvbpoocLNAA--.50311S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ur43JrWfJw1ktrWrXw4fKrg_yoW8tw4Upr
	s5CryrCrWrWwn3uw4ayr95u3y8Xws8Gws8Kw48u34rJrW7ZrWxZw1vy3W7Gw1DZanYqrnY
	gF1Fgr18uw48tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPCb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7
	CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l
	x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
	v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
	x2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
	80aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI
	43ZEXa7IUnw2-5UUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCRAQB2i6ooVpyQAAsb
X-Stat-Signature: g38gpnnf7ipgxqokhjpgmsobh5y75tub
X-Rspam-User: 
X-Rspamd-Queue-Id: 51D8040016
X-Rspamd-Server: rspam05
X-HE-Tag: 1757068653-546906
X-HE-Meta: U2FsdGVkX18locUcJuW8yNPlr14iTeDg7gnDZXjRwQ2IP12u/3G21qE0VYXGpDarc7DqLStq7RvZXnD7mDvlQVc80CikQ3qZmzMiJeHbMIcPUNhbmmcaeAwHeBvjaQshbEBKqII9esTV82gclUn9sn+1K3y+cPY33F2zoLgeQ8a9f+Jf/WQo4Yla+CxYG7lkkO0E7c89qAeVloT26oXgO/eKkaiAj4nXU6uWUauoCqE77o8rVjeksTqrHmu8EUF0VswQsE3+FDWUfH1zRmj5xOZv3GsZbU0G+gTvUG6mi32ViJc4igGVGNS85AIUvhog5BL6a+5JYvjoTPMfZjRb8d1UeoC5eN1BaYJtI+QW+C6sqdyJBdnIcjuigjc2CH9fLngWUcyPQ4YcwNYkBm8VGcF04Vn213LylyA5vcDUuU1I7KXImnvRf1DaksCdrmhrxFN9kA42+587GY2zXjR33TmSTbo3R9Q5HysaNrqZxmHxdE6mQnRnjHSNyoe0DRtxLst7d3VR2gdXx/jAhKJpr5GbbMz8StNHHbFvS1fOjlUw2xAsP7N/OhPoN9iUAyQyPDmlIBaoCpAkW+4ph0BcyPeYjcCAYNFcMpKGNOIWmAgyz1nhBWy6jgewfBYj1+d07fpy+wUAlkDEZxtCrFI/dsG3SBKEgzRj5trUrKS18akM8OwNBkQA0q4YAu+IFXVp3tFs0vxsmguuQm+ASwZy6aWI64YxO0c5vCU3eMrPaaadUliyc4EfGrMqbYnXyGd4uXMvxgg+XQ+7WYWArqXOjovm2Natz271Fnbbydv9OHB1M6zb3gIhBcqi7cM/ud65olewFmJwTyPIDWK5tuuYDpNsKRFcprQFAUvpAHtDHUa8P51hakCs7XDfrW9C6P6nvK/i63RZXtxoqgH6xCX8+kPEG8kI+tNFW+WMsxcOUY9ADclz4S2kxu38XZ5IyiSsakWAmYwYw9ZzyTdCIgH
 kSRB+IuF
 j+2YpW6ZR4vaTpiAOWPGKF0D/SCaMKGcrLVlGHQTripeAIpeALfvC6nzCW5eeivVoKvoYXJOHl9jPiCbH1PCMMgI1vuIbKQm60Mi5xqcpl9nTxJh9b6MXJ3Js8Ab59cqMmTlek9DCvaM7ydkewiC3ygPvnE8iL6ukUzcVB/uk8KL8+zs0Ax1JEKhfv4qITdvgU4tB3CiM68zBQejnVUQip52EO78XPOuuzCIXBmUDUk8e1euO1mGH5jGkay6l+daiJvnikO0Xlk0o0gdnhqXeczaAzCYu7i+KMMGe5Dgz4eYZ2+DIwdUU7CW2gurE3lG7ECOS1x7gV/CjSC7x7/FvwqXkXrzO7Up3Ol32
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Svrsw60t59b extension allows to free the PTE reserved bits 60
and 59 for software to use.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 arch/riscv/Kconfig             | 14 ++++++++++++++
 arch/riscv/include/asm/hwcap.h |  1 +
 arch/riscv/kernel/cpufeature.c |  1 +
 3 files changed, 16 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index a4b233a0659e..d99df67cc7a4 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -862,6 +862,20 @@ config RISCV_ISA_ZICBOP
 
 	  If you don't know what to do here, say Y.
 
+config RISCV_ISA_SVRSW60T59B
+	bool "Svrsw60t59b extension support for using PTE bits 60 and 59"
+	depends on MMU && 64BIT
+	depends on RISCV_ALTERNATIVE
+	default y
+	help
+	  Adds support to dynamically detect the presence of the Svrsw60t59b
+	  extension and enable its usage.
+
+	  The Svrsw60t59b extension allows to free the PTE reserved bits 60
+	  and 59 for software to use.
+
+	  If you don't know what to do here, say Y.
+
 config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
 	def_bool y
 	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index affd63e11b0a..f98fcb5c17d5 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -106,6 +106,7 @@
 #define RISCV_ISA_EXT_ZAAMO		97
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
+#define RISCV_ISA_EXT_SVRSW60T59B	100
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 743d53415572..de29562096ff 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -540,6 +540,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
 	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),
+	__RISCV_ISA_EXT_DATA(svrsw60t59b, RISCV_ISA_EXT_SVRSW60T59B),
 };
 
 const size_t riscv_isa_ext_count = ARRAY_SIZE(riscv_isa_ext);
-- 
2.34.1


