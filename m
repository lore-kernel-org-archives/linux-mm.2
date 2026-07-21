Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E77AC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45A06B00B6; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CCE6B00B7; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31CA6B00B8; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 849DA6B00B6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC45EC03D4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:06:20 +0000 (UTC)
X-FDA: 85012202520.25.ADE9946
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E405100006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:06:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784624779;
	b=ej6drP8lObkszNDxydsZ/e5TnoQgeDypB198pVZxdNLYdtnp4DEdGivVtPtgEOG3cpeeL5
	JNBYXQ7Y0iWp2AlZia87fvlFNh/4lrs76gC0WIakBUCSNzLiMxnVr2D21fbcG1ZIJBSOHD
	UXRQJfCTDR8OhNqBRaLvg8Cgflc2AFk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784624779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uuvh8A9GrbgRnYSNzXlzbSr4WIu1Jq3J31+FVNwbGSs=;
	b=yEgGb/jGXnlFCeyDt+0Jbxg80mKpeEFPSagquLKauLa7Befyecg0gNuPGDl8Pt5vxzYfUk
	IRO22IPVeE0V7PjVKVcwi5NrLxKX4O6SjYU6uVaPU3BEtvuUKQih6z+RN2mTTx8+scYRBR
	eDxEqNnW4kDfN5T0oTt54KI6xT0cJ3c=
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8BxmuuCNl9qKJMFAA--.21877S3;
	Tue, 21 Jul 2026 17:06:10 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxb8d_Nl9qdssTAA--.39236S4;
	Tue, 21 Jul 2026 17:06:09 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH v2 2/2] LoongArch: Skip address pairing for non-exec sections
Date: Tue, 21 Jul 2026 17:06:06 +0800
Message-ID: <20260721090606.8982-3-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260721090606.8982-1-yangtiezhu@loongson.cn>
References: <20260721090606.8982-1-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxb8d_Nl9qdssTAA--.39236S4
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7CrW8Zr18tryxKw4kKrWfJFc_yoW8CFWkpr
	sxCws5Zr48GrnxJws5J3WkWa4UGaykWw4aqF95J3s2yFsxXF9Yy3Z3KrnxXayUuw4rAw10
	qryFqwn8Z3WUCFbCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07josjUUUUUU=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5E405100006
X-Stat-Signature: 4r336xappakodnmf9kxwhqc3s3319iuk
X-Rspam-User: 
X-HE-Tag: 1784624773-975466
X-HE-Meta: U2FsdGVkX189EckvWU6QJua4btH5PfH/u2dlVeCJqE+QLU9QTwv9ocU8CLTTXyeJJXla1BbIbMpZDkvE9A//y1gdb1V3mfN/Y/9Y5QOhyJX//Iw89Qe7mN5M05fuR8A/Uy8JEJRiMxeXs3vRh3wTcK00erJWiRZ5/jyIW52gcm1S39Ba80CfThDnIQmpPrsMAZ5iB/ZlfEbnTPT78Tf9mUIUYt6/3wPtVJhADvDVDzL/3e3q6cxcsQvABVqI61qpQ6Bj6ibLIYMeGu2PGbcimaxadzpsQLlNmp9rna9RcXVlSCN2WjA3ZUSJfxMqGoNJ6Y11DpQw+GC8fkWIPQw1dlFQ2B1nZTyHQ4P6l7kauf5AhTKiddSWKmWAPjzbIUsya6EQabKcCzjYr0H4gqbs33dQWxBr967xVHDuqz1ew84/xXiTe+puhIN11qwK7Mpgbf1Obb9TdjN9d9EuGq1OS3uTQ4/wia2eFRLOg+5dkP8Yksztm6JqkqbyF2oIPMitsEnDumME8AgVSLBIIOtskFfXjNI/R7pLkx7clJUlZGp2/7lmSsfU4PzlHjN8Ehlc6gICc9APYWfw1x5AlcvvnnFd9C3BW88SBbWahLbtxWiOUGUlgvcFz/kBqDhP/pgizla/dVQR8WdIpIw62SAmufPhXZxnl0XJcIn9T4doGGckV7dquBLO8NvnI3EaxQLo4Pkq1gUpoMsVRYU3XQ0LJhD0jRKKlArcx1RnI0u8Bzn/guXK+pnvem0r32I4yLCXfMlr7RKtGXkimTAOfpllc6BHRQK5INkdNWR2pY2nTNLzj2nDZuafKVnM9PTchWxU+Dj8CqmganelL3y1MmdUAXwXdWzIoA2HzIZYj5JijYZw/TDOLaZ/k8flA5WMH60fpJDMGRV7Nx3y4ALgY+dI2iyMm7vfXZplSRkt+dzPSyazq5pFjFR7bJNiuCaAAQRUj+SJRkKrxAf35DIfWH0
 S2jYPQ2+
 u1FVU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The module loader currently runs expensive address pairing logic for all
sections blindly during relocation. For massive modules like amdgpu, this
causes the loader to waste lots of CPU cycles analyzing non-exec sections.

Furthermore, there is an inconsistency since module_frob_arch_sections()
already ignores non-exec sections during the counting phase.

Check the SHF_EXECINSTR flag in apply_relocate_add(). If the section is
non-exec, skip address pairing and then jump to normal relocation. This
eliminates redundant search loops to improve module loading efficiency.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/loongarch/kernel/module.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index 7d4d571ee55e..c84ac1546dc6 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -484,6 +484,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	Elf_Addr v;
 	Elf_Sym *sym;
 	Elf_Rela *rel = (void *) sechdrs[relsec].sh_addr;
+	Elf_Shdr *dst_sec = sechdrs + sechdrs[relsec].sh_info;
 
 	pr_debug("%s: Applying relocate section %u to %u\n", __func__, relsec,
 	       sechdrs[relsec].sh_info);
@@ -522,6 +523,10 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 
 		v = sym->st_value + rel[i].r_addend;
 
+		/* Skip address pairing for non-exec sections */
+		if (!(dst_sec->sh_flags & SHF_EXECINSTR))
+			goto apply_normal;
+
 		if (type == R_LARCH_PCADD_LO12 || type == R_LARCH_GOT_PCADD_LO12) {
 			bool found = false;
 			unsigned int j = idx;
@@ -562,6 +567,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 			idx = j; /* Record the previous j-loop end index */
 		}
 
+apply_normal:
 		switch (type) {
 		case R_LARCH_B26:
 			err = apply_r_larch_b26(mod, sechdrs, location,
-- 
2.42.0


