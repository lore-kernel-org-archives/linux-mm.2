Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1E0CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6236F6B00B2; Tue,  9 Sep 2025 05:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F488E001A; Tue,  9 Sep 2025 05:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494B56B00B4; Tue,  9 Sep 2025 05:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 331BE6B00B2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:57:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D477E1A0460
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:12 +0000 (UTC)
X-FDA: 83869258704.01.75368E9
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf04.hostedemail.com (Postfix) with ESMTP id 83BF740002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:57:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4rMXI662tXlPUgZz1tZHQFISwliqndcRvNpZcbyqzc=;
	b=tdxLRngf9wAvCVKYb6xmb7c3ShF81X4XK57S5by3CyqGDIm0C2ZZSaxXysjXUvxxM9X1v/
	PLu7arEh4n2enGzC0uznZgvoupQAlGCreOeDdscsQV05I0/yVrNLVektYaLNjSmn59H++I
	6Ta4HnM99YTUU12TfbE2Xb8O3ukfF00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757411831; a=rsa-sha256;
	cv=none;
	b=UmvJYiSzP40DzxWLs4lSDi6zoh5pb4POmGVVdpuBOflyK41ZsgSqGva6cxjvn6AeqSLUiH
	kH0lwrfnVeEKsFGGyBKIhXHcZOUufxSl76VXdaYcaerJ5SFcqOy9w5MvcF+15uBWvyv5/Y
	2U/7BB2GJCzEEjHZUbrHJIFAW1aUy9U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowADHHqHO+b9oWh7qAQ--.61766S5;
	Tue, 09 Sep 2025 17:56:33 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
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
Subject: [PATCH V10 3/5] riscv: Add RISC-V Svrsw60t59b extension support
Date: Tue,  9 Sep 2025 17:56:09 +0800
Message-Id: <20250909095611.803898-4-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHHqHO+b9oWh7qAQ--.61766S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ur43JrWfJw1ktrWrXw4fKrg_yoW8tw4Upr
	s5CryrCrWrWwn3uw4ayr95u3y8Xws8Gws8Kw48u34rJrW7ZrWxZw1vy3W7Gw1DZanYqrnY
	gF1Fgr18uw48tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmCb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280
	aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
	kF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_
	Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jvv38UUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAcAB2i-53NJeQAAs-
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83BF740002
X-Stat-Signature: 6h51f6h3yza3cq4gr73367bqwjbbtm9p
X-Rspam-User: 
X-HE-Tag: 1757411830-992532
X-HE-Meta: U2FsdGVkX18QFhgk5E+ygA3RJfFoYFPvN5ztg4+x4qz7KxvDdkqsuDr3OHrmeL4yht+++Np6wkPmmrPihOVy8aShxZ2gCIItmIkrV1n278sfjAbGA9be3TG9KtqFHpphGqVHnCU2RNdFNcUFWRLxMU2H+/ZIrhTsojbfG2/Asa+PgKpUKxWw/1EMLn4RvrPEGDNqzyHkj7LZ4FlvhFOReopIiWrgU+Svnj/XY0ncRPYM2NY7GlTFoUaqLkoFBvhh9AU8kzpMCKSI9mB7Cpp4WVa4gJuNwx1vXCpbHxTYo0iK6k4oAbHf2TU+LHwiTeOY2h2///AQBT50ws7rl03Mjukx0kB/IcBCEoR4fetGfn3GIY2Y8dcYn/rPaMcQeERGDKwq1INIDPWMpqEb1beg+w2yf+X62Husim+i3lEAKe0pTdkN4EvbpoFN5jd9CIFx3jFfywvizuUFp+pSMNxlyixwn5COnyEHh0JvwZ4sQf4drCNoRB/eME7hDnq3eNExMJ0N1EIFUfgVc5a518H5vUgzYEpPP/PSJdutC70WmmwdK0J6V/GzJaCtuntP8EKytnUen2pYQDSTU7wRfrf2vLPfCZibZQp9Kx1abcFzFIWmoAxdYoD6de3Lv+c759tI8dt1POe/a7mExomWZnNGP/0l58TyYfwYZNZ4pYceiC8zjpxHZsWw1QzcIH8Dwd2H5WjEAstmB4gjbsdLkRpu2bP595rRli/nxyzs2TrqKvJGynJp9tobMZLurIsPbEuOQjE99kkMr17C/ni0Mp+slQ9QYVyKAri5YkGjg38f9dMrfijqjVSD41e1NN5eY+uSmd5xYQXXlU+ckMF/ZHQuN/BzL06lH5VKxbPzkorDm+Z0ClIRhqJ6XfB0kIEAfZjUs8a2hycjGhM4KBfkb+zPbZODCeGWIeF3d/I3SKQMNNIk4aFrayac/cvUDCtzl653z0zdLL5ROCdsg9l9Jy8
 84aet+Iy
 nZGJgr7GIEdEdrtjsr99P8KQQPk/l4mpDXzOuISE5xd5DkT/ni7o9P1SCek075RzRx/vHLnzlmpjiL8kyA5YpPyL1plsnkdqb5uVY5BY6vk8e9ruQTzIpbTLb/bRP81ivAzmdwkDgv0BOoIysh+IKhENiniiCUMDVuftow0BbRo7U/W0w5u92s+vxaN3i2tYEqjo+2fSF/X4cVRvAtQgjVvk6VvkaM3sIKIi8YewfQSczUaQOKdpCSSCBxU1ZqelhIMxY9REjP5aJFHlRQRXi4JolgGV2XvTXSsRFihXHLg1mHXlPCcKCEX6uPC00xRb4+rRUbV0eveD7Dgfwx8KrGMj/xdt60pqbDe/3
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


