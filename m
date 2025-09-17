Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DF8CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA7A8E0005; Tue, 16 Sep 2025 23:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B6F8E0001; Tue, 16 Sep 2025 23:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932B08E0005; Tue, 16 Sep 2025 23:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 841048E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:47:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 026E41403C8
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:47:08 +0000 (UTC)
X-FDA: 83897356578.21.378D28E
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E79C40009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:47:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758080827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yOS4Vd6BwRYGVikwEWA90bHZ9KyHk/UV8wPDKJ5vFgI=;
	b=vq/eqPzmPdG3IBCxxgLKRq/2k1YepJ9NwcYKZHAAMmSfKOAfSojpOqmEbHQv/FgGkKY1ax
	2hgCggo80BZ48XDgDn0efIyorPw67bvZNZVTa0jb4r6TWyIhQBo0aTnDrDrL75DUFaiITS
	fXbg9c0s7A5iuAQgVNXR/ab6VHRX3tU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758080827; a=rsa-sha256;
	cv=none;
	b=MhfSw+VaYCPETuU5l57biGy2kZ+K03tZTBMmoALKMhnMXJz391Rofyq2xR5Hp1xd6RzG76
	BeOvSm8JsDyXug0GY3uG7JHIQFKP5SQv9mH5wDsmjbxff7tVnS1xTpb2kfHVp1vIbFfkBo
	NdqFMqN2nBOzWkLUEb74DDpBXUbcbdc=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABnsXvsLMpojtxAAw--.607S5;
	Wed, 17 Sep 2025 11:37:27 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
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
Subject: [PATCH V13 3/6] riscv: Add RISC-V Svrsw60t59b extension support
Date: Wed, 17 Sep 2025 11:37:00 +0800
Message-Id: <20250917033703.1695933-4-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnsXvsLMpojtxAAw--.607S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CrykZr4DWF43uw45Kr18Grg_yoW8KFW3pr
	sYkryrCrWrXwn3uw4ayr95u3yrXw4kGwsxGw4Uuw1rJrW7Z34xXw1vy3W7Gw1DZa1vqrnY
	gF1F9r1xuw40yFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmCb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280
	aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
	kF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_
	Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jg8nOUUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwkIB2jJ8O304wAAsq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5E79C40009
X-Stat-Signature: kk4suk3jyrbkmkjxieadf5mig864n1mt
X-HE-Tag: 1758080825-185104
X-HE-Meta: U2FsdGVkX1/HxcyWLz9boTcu7VyGrD76tu0XiPriSg5F8749mCE/qC40QVXMFcHYymhJ45zo2IZRj47pShrc0whYnegXKudS4tjtXsb3ZhqVLgUVHmVvb+kQ8tl5KoJtnb3BZ8nzV4ZHiEJMn9z7D1Tcv0rbv+PigCcbEj9jVc65hVf+ZJZF9Q5spSh21mpKtmlNkY3H+sENZcxFkXXBfuaES1VVHOuVOG1BEVikdDuFGAJ+DIptEO1CT1mT9TT4EM9TrOblATFFhAnM1BC9CqdL1vrzITxio+6ENBVc0X6f4H8etK5ekuPOqZP1rh6xkwgKv6biPClhCAHyjYZTxkaHTZzgosb28LQBZT1qBGtd9dnCn23i9h/n2PPhP9Vp1xPuLsh4OJQFz1ynmQYygVb3Mlk4brTZW9KoHLjYcsRHQDFxZv0cfGPXhdTB3DTJVeBPSSCf7Re4sETZ0oQPJj9nQYmlliihRka8tj2nmrpj4AZPoQdkGVJ8pp5ZBll5asSMqclndqCtsawC594l5Ymj/YqrzwmdvSuigzoO8MYttHX79BCBEdRXnjfLDY6GucHlx+ZuS+ZN9sxcvjWbJs/bUvbOH7BndWlpODUt4IxSSfl3nd2cODx+ZClRbGY8SpQdNeMMldGg9SKlKYq6wPEJckeXW04r52dakMKZLv3/63tYzBSturBGr8d2G9W4Cpww0HtsbCZ1DiQ2euFjSahn0dil6DnoJ4tjtvPD4Rj/PiCH9aHfPRaVOdFqYPE4PDM98bSmeuDz8mwm21WNEfWUPCMOGPUKvbBkTOadL9HYJa8/nd9cdhE4mzOr9oJB5J021z4cadu2Uh/nFnssqo8PjApidyUZ9IRIh8mhtaus634dGQMV5sm7PeN8r+FakbxjI1PwukjGujls/vEphI07kp8h9g0q0jEZeBfJjY4SMlq930uZprvG2l7y7dNhSXwp1zswB3BHt4F5YHb
 x2NJSPwO
 jOwi6O+6Y4rYDiIjKbAmcX71BUspeWMdaXEkpOOVdxS4bMzA8IExO/IFBBedCZ29PeEr3fznoDzwaSkdhzBbdnu9u89IU0Ys7xizAWxNv/LCD1iwE4huOmLuiFYjI3vrWsEYlrq02r5w22ez/Jxg8JOthHwdO0DfdVK4UzeqKuaQsRRcDsJaM7BHMXDMx2CJucHCAPbZ/FwUKH+Bss/ij4aTun/amLT47XpNucZh+BgQ6gHHkGn2EoQwaIPjtK9emXjcHpziHQTwRHcii97HrmmMSFRgrk45fE1LETag5skHXTHzgiJqVgTMjNM3588Wu0q7KKcr75uKugM9S5e16z01WM9xDFegEYr3v7yopVzcaHHDo+VSLIxRJEBnz4SkTEwlRZqQzIN+Uu7F3vFTo/gXfSqOB1C8wNj2E
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


