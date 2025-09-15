Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6588CCAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916628E0016; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877028E0012; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7788E0012; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2A58E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:14:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09ECEBA0C7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:33 +0000 (UTC)
X-FDA: 83891075226.22.05834BD
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB25A80004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757931271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4gT/LrlkNiwBdHahNcMmCwR9QGscc2bv4efKuisUVc=;
	b=qOcwb2nUhE8mB0ZKmCHbISKwuvSNnj/dA+0rSANsHPWX+SsCr9+gGrJHZLCHvfEZd1DpE+
	VyaNteMjb9OHaHMpY5on3rLEKW/JSgCP2p8RgseHjSARJOQdSSIlWxghhku2SdsNcuzpWF
	erKK3OEK0AyH/EsCt6eNDjbr1srZQUs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757931271; a=rsa-sha256;
	cv=none;
	b=Thmc+vBmI5YLkn/nK+YcvS0QdT71T8oy4Dj4sS9I6lNL7/DPQfxA7b5nI02Klv4G/B17hB
	Jl/QtbVlAqZ7jgkR5HnGfm12mSU+oUd9kJVGrUGhxMLIenDKRyKDHOwC6ensoOYbOloDOR
	NkmUTVDt6sqRj8/BbzrTM5GZXJQnjbQ=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAD3lxHf5sdoHWn3Ag--.53429S5;
	Mon, 15 Sep 2025 18:13:56 +0800 (CST)
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
Subject: [PATCH V12 3/5] riscv: Add RISC-V Svrsw60t59b extension support
Date: Mon, 15 Sep 2025 18:13:41 +0800
Message-Id: <20250915101343.1449546-4-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3lxHf5sdoHWn3Ag--.53429S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CrykZr47tw4rWF1ruF48Zwb_yoW8KrWrpr
	sYkryrCrWrXwn3uw4ayr95u3y8Xws8Gws8Kw4Uuw1rJrW7Z34xXw1vy3W7Gw1DX3WvqrnY
	gF1F9r18uw4jyF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmGb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7
	CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWx
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IUnwXo7UUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiCRAGB2jHtda7WAABs2
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB25A80004
X-Stat-Signature: tg8jgkxtef7tec1zbu8eumyd6idrftes
X-HE-Tag: 1757931269-479757
X-HE-Meta: U2FsdGVkX18WVLT8Ok/CFER21YbpzHJnEJbNa0JQcV+W3joQJVau5AmgQpGT87ZKMRQBU+ym8UKZarkZNXTL7mCHupabUf2g25PoFRcQHyYGqjz4w2FD+loUF7utHYI8KsSzrOpHKAdwpr2DgdlFSePJdRNThuzONuod3jnpD+aqzn8CYjsi2ZzrUb5w9snuFWA8l7cHDWjDwwl2EW+Sum12RI2bTPVxK8bJ9OxeAUEJcJOdHyUMagOp8kY+nyViAKaXecOZUM+S0Yvcaof1xfCnMe4Fo2rWu1BVO/uupD+iJ0njtikXGsz2goZLK7g0PEdAHjOny+kLgoIXqOmAVIMDRz0NIAs4OpWANvGLK53qp8w9a1sVb8qKg8+Q88d58IbnCNLbNtt4IL+Ti/bYmD+NDUVrZi5M6VIJNuqbTdxXG0Qoycjh3Om8KZSMnl/57MsqktCKFbF+p7O9pbIkPMbdWbFFoy3Joe6tvKCzRaLANTg1aa4o4cho8UZDNhhBp6q5Aodb1oqTpv0PDH/aj6genGF1MeEI2jhiLyXPWoqaYqL8A32gCt3jSDixWYKlwLEy0z4NLN12sMgNcMEV8tg7+n84fTWhff/e92MWEkUU9KGb/jhS9mCaU79fe6cY7Mj0PVAk46MJil4HlMVotgq87S44vsHbBqDUlj5uz4UY0XXYe+j7LpYgwknzHSxm2DDDt5zRRSVknmZFP5ON6eY9+PUlIKxCAZ7+9Ac2dpAA40O/CzevgwR9Mn41HoTRpld2LPGLpZoTRqqFZRxq3IgJiYRomf5vnYW0ge6uy9YmV+Rxo8QIq7gnTTzK5CHRLpIwaco6iBGpzW3pWfuV4MZZ3OfES8vVgWAbVH4AM0CfLwQX2nocjvPOnUXOnYy9bT0ppz8JeqpJWFjHzI7IItRRca1+Va/PqC+tay7ls7G/UbumeyzwNq7C0AD1f9Al6Dijykx2HrzKaEGQXKk
 DgcpKAA3
 h7pQIekmGEn0nCCKssnHgwidwStFL/FamlkVZIGgpDKefpSDNWs+Q4Fx3naNvAXf4FlHiiDAd9+222SLvhqUdmJPlYnXFLqhqicjHVIX0QfYR2nQVth2JDy5bgjXAZFkcPXzwrJjFP0WxyS0IfRpjqd8rU2YYMKlql5GIjYj1iTWThAmESPyWtwgGJquRCuS6ZY9qNAk7VCXfEvFFqXUJvtj/OmfGEV4ntroVpKQJzZRm7sOn5YLIeqGGJRzFrgaUdwPlj2RBT/ZZX0ANoR151G7ZwgjmqJ/XCPNavriQJSMCIQFko51EPMP0Wgm739dUrV9JhdfT0/W1geCrk3xZVgiooxWp5qXaye96Cj6Ua3vadewIx6buo4d7E+TH07Z6dsHM0inSRc9KyvHVvcTw76stfdZcW7eNbeux
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
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 arch/riscv/Kconfig             | 14 ++++++++++++++
 arch/riscv/include/asm/hwcap.h |  1 +
 arch/riscv/kernel/cpufeature.c |  1 +
 3 files changed, 16 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 51dcd8eaa243..e1b6a95952c4 100644
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


