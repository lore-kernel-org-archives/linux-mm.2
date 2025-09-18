Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68118CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950378E00D8; Thu, 18 Sep 2025 04:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8B48E0093; Thu, 18 Sep 2025 04:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A19B8E00D8; Thu, 18 Sep 2025 04:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63F198E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:38:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2AD6E13BC90
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:38:19 +0000 (UTC)
X-FDA: 83901719118.27.2FEF7C2
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0E7E140002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:38:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758184697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yOS4Vd6BwRYGVikwEWA90bHZ9KyHk/UV8wPDKJ5vFgI=;
	b=65XFDKwU36FA4PaEXy0So+/zN1qhzHVEaJNXMDIHUbKO8fnavijZC8bgW0bHjUhT9sivCb
	njjVLtB6O4Qizk/gGiSe/PR1D+VVGn/lVeOOmJuu455nCx9zSCLVCDbTtOKQG0YIyBKSx8
	VNDPcBBDY9VOyIKmHUjT9+el8hz/au0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758184697; a=rsa-sha256;
	cv=none;
	b=0lCJiXiwC/mlX5+zaCZgsBqGhVgbYFCYgkOR86RoJSarwwh5sleRtYfx1x/DYBqCJ70sd/
	smgpxZcE9tVLq76kjiEu2tgSxRdShs971LPdbcyZjMq411RMMbfhr1yHYsNlZyazb0dgQS
	R2ivrsM0GdK4EXBxTXkdVzu+M623sMI=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowACnu4XjxMtolHKCAw--.43062S5;
	Thu, 18 Sep 2025 16:38:01 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V14 3/6] riscv: Add RISC-V Svrsw60t59b extension support
Date: Thu, 18 Sep 2025 16:37:28 +0800
Message-Id: <20250918083731.1820327-4-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
References: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnu4XjxMtolHKCAw--.43062S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CrykZr4DWF43uw45Kr18Grg_yoW8KFW3pr
	sYkryrCrWrXwn3uw4ayr95u3yrXw4kGwsxGw4Uuw1rJrW7Z34xXw1vy3W7Gw1DZa1vqrnY
	gF1F9r1xuw40yFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmjb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280
	aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
	kF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4U
	MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
	AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
	cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2Kfnx
	nUUI43ZEXa7IUnw2-5UUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBg0JB2jLv7wXtQAAsH
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0E7E140002
X-Stat-Signature: ktk49ccdmz44ti7uaffsbapxdi1u1b45
X-HE-Tag: 1758184696-903453
X-HE-Meta: U2FsdGVkX1+WU72d/zBETBxRgePX7XkQIa+my9CQ9rPACtGZlvbR+pFwFEHyW/M0kEORlzxXyj4IO95vWNoVbDpJMT92NPydsaumw3TUyNMf9/X5bQADStPzDyyY5mvFwejsoyB5HuNBDEEOaYZ6BRGI3qNBpps0NOPndO7pgU3DYdqRhRk1FuUCJtY9PSOfAaLENEXoZ8My+U9Ji3wVoX2ucmSJiLa0DWQxNCKU7ir/MGgeQnad2Bmj/wuO4TlP8z3LhMsjURuaYzMKX+aCUChnXi225b2cdB8lm2JiYVC/APbsteiPpk6Qk34YEWcsjx1p31fNQGFa76SWINx7T/71Ok+/qdALr6ZyBqrUpBcp4yjukC8/vdwu7iT9jD0ARIhScsZDsldrg4LdJfMiz8CjGe8dXdXygaivjj+4Ex/BApU1Xl8+fjyy42iGERIQ3Dc4caBfnrJvufqDII+gRuU2ox3yDKk8VFD4vYuOEARf24/C04TWbwyf2M7FiY2eZRld57n1Zr84nyAttGJl6dTX6Ijlz6/nw4roX8ALMh+SpB6i9S31sU+O32t3nrsArBU4TL0EtECtGgsX60t4afAoEXbjl31QExSL5f4zpSzceOrthwalDW2+Ogf5OE+n+S5RjMhprmM6h8LJGydEq0jAnDVzKBiD0D01AWnnUlQz4vwEYGYn3Ej5GkEpF4seIqHDhFcaYavUBXcH1HMHo/wx6At98BfjC0VtEo8YVYNTvixKABrSigsZAmXMed/U525lnG1BMzo1QGjeva9wGS/IsW/OCaadxOBk2vajb3Xhtz+pX8SKE4Vq2VX399kr3aObkK6ihx+gB4fAatcjiUXd5aRZWjPnaBg+FrYlATUoQPq8M89kDLXoyc3hxJAaU65/P+IFXDSwF8N3PMyd8M5EgdLTcjexEdMF3WzWtJvB4VfbjlwnSlN07F0Ub/P/eAHFdUK6UY0pxNOxg4k
 Y5WBr1fG
 jcDeHQBHBiWsz5F6v8xlZ0m73Qzn5vk9jzLINKdab7+ZUbbkzq9BwU2V/KfVy+6upkCZW6MaEHTWVZdhSejJnzeCsd4a+oh4Kx4GgtcMOmghVN9C9VbBIKfO8SWIg0EeJUIGLOl6b8rJoefWKG9MpmaFeGOlO+ItvBVIUTTVrb+JHuLWYOG+EoczVMPS3zVGCfZmq/7sHDIKmGg+26UUxM0Yn5HTvAKFU2Ui7D/rqaw07vaHUkiowQHkz/b5/op3FCFeD03FzAR2NAW7Hxub2gLzd4kHzfk0ZOKwLGpOG2WcVXUc3JeYNO4oTGIAhJHXBNq7Qdk1zvAVsT4ib01cbD56IW3dIPLsIEnOd9myyg5/wbf4j3jzDDVGN+8MQyOGOeIOMEn/CYwyI7KV5eL7gD6OITBm012sGghfH
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
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
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
index 743d53415572..2ba71d2d3fa3 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -539,6 +539,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
+	__RISCV_ISA_EXT_DATA(svrsw60t59b, RISCV_ISA_EXT_SVRSW60T59B),
 	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),
 };
 
-- 
2.34.1


