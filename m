Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BAF606A320
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dEp9P8wt
Received: by kanga.kvack.org (Postfix)
	id C012A6B0B42; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86D56B0B45; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1EE6B0B43; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6906A6B0B40
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A43AEC03D1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:31 +0000 (UTC)
X-FDA: 85353637782.29.5621C6E
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0809840003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dEp9P8wt;
	spf=pass (imf11.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792754190;
	b=0FTCuXZ0bd1swQyC9YVvDorNu8fa4gxc2o8WjBX4wtVCqLxA7/wR1SuruQj5dP++c5Wp/7
	kQzNKPn7wPGeUw8H+c5RkhELXxbQhD9Zla13mmMl/e4l5thiLPqQxDdnkO/SuuhAXkjh5D
	5BohoZR5ydN0OlCzgO1XNsuRRjB2uNs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dEp9P8wt;
	spf=pass (imf11.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792754190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XR763hCbspNzvt9Ja5KlngGTT7u+E0yj2HR4cp4PfjA=;
	b=OjtqAlk3RlvJbJGQfuHT7DOpm+7QbJbfRTN6n2MTsDd2AMUWEZo/4NMyrP9NnZzIhfq1D6
	eVtEzwg3CRwGvjdmqj5+3pcDIAtsTssFP/yFJLumOMMQSUpJnGJRXAw2n3kdeL4qMnbO9g
	DJ/IiaAukva0r6SczKh1KR3fmnLkdBM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792754183; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XR763hCbspNzvt9Ja5KlngGTT7u+E0yj2HR4cp4PfjA=;
	b=dEp9P8wtKFFnU9ygvZhkHsuOeVWzaAuomqIWciSFKZ+L9UE6UfM4JQuBFeedv7e1nkFVu/G9DWjpVO9pG0NcEJKTnwwH/Ok3T4uD7ImX0uhE+QmFFFjyO2eT1qQo9hfITP+QeEXi28Yz//e+8iFUpGCH0XDaw2AC6/kdBK/c2UM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDM1n5K_1792754181;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDM1n5K_1792754181 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 19:16:21 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH 1/4] riscv: Call early_ioremap_setup() before parsing the DTB
Date: Fri, 23 Oct 2026 19:16:09 +0800
Message-ID: <20261023111612.2134-2-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261023111612.2134-1-cp0613@linux.alibaba.com>
References: <20261023111612.2134-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0809840003
X-Stat-Signature: mq78dqtti4koj5hth9pe1mipz46h84gd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792754188-597455
X-HE-Meta: U2FsdGVkX1+2Ku03hrdEjs/UKul5cBwqWc4acNkbaQZzkIlezyw2qs5csH0XWpm+qkww0EZJKMGUekE8TH4+GEmfLzt9glcy9UOkZf9oKNW0XVPOZqPsvGiMks616phkuUdDhgrOVw9V4qBMFjLUBXg7kjsUa3MfUfmGki9bjNpamMUOlYWH9XV88KZBFTIk4GIxQARvDVtCi5j9D99OzOmnw8DhCOvIQqHlSYSIW8jYTcgAUNe6HGCXepynjN0o8flNJPozeylZ2s/MCKpAG4BL4gSk2DFmK1htL5dh+HWpGz6X6HUWJISnOnpU4hPkJqTKQ/MFPJJrdTekGstqWcb52g1qXDhLz5k6EbUIcUV+Sps82g/NFOVwEEW8/Jc8oek8oMvlLVcQF5CISF7itWIiofDACo/CX+f96BCKhTFRrGJI3ptd/xqR8L12p9/mrvSsFP7tn3CfM0c8FRbG27d4tfkNSlReSEMuTbLF8Monc0vU63KSyMokL+lW/ctSdOfywSMLaAw0jzJVlLczT3enZLsEA6Dl7ipyPlWykQ4arKN2/Wkk0hM40EVubqCi7TVunLtyQ2TNijZR89+G5DfYcBpm9poVNDy7iMvTvtJjUcMC9E7E6xsPOea3Fh0cLscLWB65NyzQgJq1X2N/vZOBI1TFQb/6ocXrwiptZslUvJBAGrFdG3177cfgmU6Vs/2rKexguSC1RNexGr2cVXKfK0w5RizWeSOYNosOB9478/nqPrs/Y7uFD/ROk+3q3Rpo0nwSAdqNm5P1dvBwYh6U/CUOMH/9cmQurezY3kAnjKFZr+HpN5yGGJagblUBq8Vo2nERG3PjMjabk8d9/7kkSWhbh2VJZwBzeY7f6WGtyF8gZF5ZTzrQQRV0bFjzYnZrJ6jOj/wa2zXW7ca6bgAoGYVdcV41dmQI1R6izJyQH3jEvLlcjY6mOf1eb457ECxiRuiq3vN4mtX6c30
 X+BJ6voS
 klEb5lOOpXcU7vC8qXJkkOW4SQezjwnulAjnPhVRn2l2ygqWTcka6XGVe1UoKV+e1dC+sFyGi2h1MqTAOSZ4RUVMZOZQNHiUqm5yqEvSKFe10/QnuqnLT+qJjkOgVngCrS6/skgQmOpqhS3jLYGHIrTFr4Z2+fAdlo0dNaXnsDbPRcG7q950PEHKlFke7ixDNc0oLViiocAzMlkWzBQNeIwjE25IAwtc3i1LDcsJqs8Ye7XwqBfNz+T0KrCWddFS9tzkH8sJjGd90N1PiKv5VX8VAp6/KdzCaXz6eYNt6umUGrwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

early_ioremap_setup() fills in the slot_virt[] array whose entries the
return value of early_ioremap()/early_memremap() is composed from.  On
RISC-V it ran after parse_dtb(), so an early_memremap() reached from
the device tree scan returned "offset + 0" -- NULL for a page aligned
address -- and the caller could only report a mapping failure.  This
stayed latent because nothing reached from parse_dtb() asked for an
early mapping before; the DT based kexec handover parsing is the first
such caller, as kho_populate() maps the handover FDT and the scratch
descriptor array with early_memremap().

Move the call to the top of setup_arch(), which is how arm64 and x86
already order it (early_fixmap_init()/early_ioremap_init() before
setup_machine_fdt()/parse_setup_data()).  The BTMAP window is mapped
into early_pg_dir by setup_vm(), and RISC-V neither calls
early_ioremap_reset() nor defines __late_set_fixmap(), so the virtual
addresses stay identical across the switch to the final page tables
and nothing else in setup_arch() depends on the previous ordering.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 arch/riscv/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index d79f99b86033..45e2ef9d32fa 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -308,12 +308,12 @@ extern void __init init_rt_signal_env(void);
 
 void __init setup_arch(char **cmdline_p)
 {
+	early_ioremap_setup();
 	parse_dtb();
 	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	*cmdline_p = boot_command_line;
 
-	early_ioremap_setup();
 	sbi_init();
 	jump_label_init();
 	parse_early_param();
-- 
2.50.1


