Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C01CD4F34
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B9C8E0011; Thu, 13 Nov 2025 02:28:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80188E0008; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86BE8E0011; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F93A8E0008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:28:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50DEB1408BB
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:37 +0000 (UTC)
X-FDA: 84104756274.15.D22E61E
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3584120005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T7RgaM2wRuZRr3lLmPPjQvXN/NFbal/gm6SIgi6Hn7Y=;
	b=BNH9xC3eHqGfXiExmBZfsrXG5pyZKeP5lmtdb6tUeZcMg0yQEosUZ3wu72/fubFyRj6MNQ
	FFp9jTpq1xMNGYFJzAnuU8LrywUGv8q+RizAEQFdq6U3zjUGfac7SwBvO/RbYwUZbHwtD2
	KFCf+xEWmFkVLajl3fcqVKBd5wQ5s3I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018915; a=rsa-sha256;
	cv=none;
	b=nuk65rG3ovLdg2biLDoCJvbQg1kEguv+9B+jwvlBo8aovCmhXGsOrbPK1gFVohWEmeMOnV
	sTKJWAZSpDNZBX61JHlOR5T5y8P0ABtBKwFnYun53DaG3FxHGNo3vvNamQrQiYcy+S5kxB
	u9w0+TabewEVbUGcOrlNxYEbGCI4eaM=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowABnbG2RiBVpVTOWAA--.33691S5;
	Thu, 13 Nov 2025 15:28:25 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org,
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
	linux-riscv@lists.infradead.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Conor Dooley <conor@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V15 3/6] riscv: Add RISC-V Svrsw60t59b extension support
Date: Thu, 13 Nov 2025 15:28:03 +0800
Message-Id: <20251113072806.795029-4-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
References: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABnbG2RiBVpVTOWAA--.33691S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CrykZr4DWF43uw45Kr18Grg_yoW8KFW3pr
	4rCryrCrZ5X3s3uw4ayr95u3y8Xws8Gws8Ww4Uuw1rJrW7AryxXw1vy3W7Gw1DZ3Wvqr1F
	gF1F9r1xuw4jyF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmCb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280
	aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
	kF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_
	Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j9b18UUUUU=
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBgwFB2kVaO5zWAAAsZ
X-Rspamd-Queue-Id: F3584120005
X-Stat-Signature: w6crhmzzhmt6uq8kzszf9bxmw1frkj5q
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763018914-838903
X-HE-Meta: U2FsdGVkX19T1bl65Hbv6eAwkV9mOAmbDynqE7w81xvRtUOfDtTHgpVrCb5fnaEfTNZt4ZiAl3CaAEiU3LU4FUVhD5DfqMYifWkeRixqjIO+gaSFuW4fNpT+0Dj6j2IJM4J/hDmm8Lvpa6nbq2Z9xT9ih5DZ+6X3w20Jo5H+u0T+Es+6YZVq+n7RZWo1t/JyB7BgmXO27Gs05HWurO+Be/yLRQt5Bx86pEKXAkepl+uuHN2GA59hxtWUTojalcs1u7ifCYpdpVAOSb6d7yNKy0/GZgeiTr+p32OTlaxKHNv0eqa/iD1CLqxwUdjX0hta9g4kXXTanCocvoliemFG45814U7XdChXLceqF+BgOtgOlHAMygB4Hh2rj2JA2AeCiJ36sZGImRuSqPUw70pBobUH5TPSrvCSABAQ4/w/VnrdsGPgsvAt2c1E/3mJORrjwWa3h0wdC5uOmBBdXDL2D3VUb5QM9ITj8c7K9pglNqYDdnsAp2mmqK8aVI5dp3xoBTPwsXdv7MARLvRJiyin5ksmw1MlHj1sGP12n7MMhO3RZ1DipwOO+PjJvZU/JdrqUfRqZ43YzGutA3uMGZIeu9FM63jArYWm1/JRh52PJ4AHNU66BehM/HIi9fL8vObbPHE98dF1vjG/TcU7SjvvW1ByGKF6GQRWjmIiHvU7mdEE7FXToDbFif6l8EFor0BitXUKjNasWka/Nix5PULcwuDyS46jqBJn9oF8bn4gZcS3u4NnCfUCwhiuV/tRHhucjeAeBEZImN/sh8BU79/CWgwQ63UhhuutGrgU6tQEEE50tAJbSzAiaJf7XnBp0/oCGErSslJZ6ULY89Mw1YJHxBOzKaWWjjUQrT40MlW8nMYxRaIFeuS3SeDVhFH3zsHclVoL/wORhm2owiyC9kUPscOKfZsp2Fj+LHIwDXrch00gqG3BjuauKCc+78TKCOYUSHLh4+Gjoll+ZHelcDM
 OMraOOkQ
 k7tvgBy/3FiAp/xSjz589UauoAhJGII8F++PnH9HxAHIROEaRqlMFynUehOa9Ii9vdGc1oMtLLSKZ7th2lFZwudRnly+TK+3Rq2hqrlPahRm+5KNXLjal4cDpkFWS8zwRIq71FF68owpis9dMUOetROD2dNEf/YJQPcyi0tDv1WxoM4PvshjpiZPo/+n1s2tUF7kEL/39WFk/XxxIssdltSvtehuzCK6UItvW07cusjZ4KPSPqrfD0yIb9wxCRfkvld+EhC0cCXB9Oi6sz5Bcd2rkjSmMMreEDPwzSCU9Jzr/Jw+Z5t0cDFMJMCJt1h1SLetPElstUsEcbUdmlxfVEn4ZUEEikw17SNIFHQbJgNT17j95RYfKJLEbatusC7QTnLqT+EWfNNZaov1baQP+y/UbnGscUmlMfSuf
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
index 22cda9c452d2..829d95d173cf 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -849,6 +849,20 @@ config RISCV_ISA_ZICBOP
 
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
index 72ca768f4e91..5441282656a7 100644
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


