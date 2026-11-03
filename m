Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC5A606D82B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=r5LIKHdT
Received: by kanga.kvack.org (Postfix)
	id E00706B05E1; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD87C6B05E2; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED306B05E3; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A26B76B05E1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 361821402FF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:53 +0000 (UTC)
X-FDA: 85393084266.07.D0D2093
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0608EA0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r5LIKHdT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XR763hCbspNzvt9Ja5KlngGTT7u+E0yj2HR4cp4PfjA=;
	b=wKsrpgSc3y3San7txvYMHfXLT8OwDH2xOie79D0zJeLlkKQjywcQYC3LonZ3K+csxMjQpT
	IcqFv+DDEB7dOrRbwsSa81IQ7TjnNw3QxxcY+OjuyUPJCbld47tQzaa+H1eLDOc5odi3e0
	06q2gW3mVHQkCqEyxxS8RUSD1E1n1mE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r5LIKHdT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693391;
	b=0iWQPK95Pr03SGgbEjhfbhDoAo4OOiVpWP0y9dS5iGAqqYp//a5sojxpPRgYGvmUKTcM4C
	j4i9HeoMLBiDrIGR7Ssfvs+MDMJQzRbnAj71uukGqd65i/fbJYMCx/SIXP2Kb1wxJy1fnj
	fCu+W0/2kMLriZawG9uuHECf/o6lIPI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793693387; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XR763hCbspNzvt9Ja5KlngGTT7u+E0yj2HR4cp4PfjA=;
	b=r5LIKHdTpsCavJoA0VAb8j8KAgEU44FswBwyniJN9WLtsXmyMLCFHOKqyLaWVKT1QWYgzWx/LUJrwlzcd65//hQ+/Z/yCijce9ciF9OvkXmaxIg3FlNVSc6XW2irXtYNb3E1t63gMndeBz5F9tU226p/as6ApYuPC3uuJa+ynpE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XE27L01_1793693380;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE27L01_1793693380 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 16:09:41 +0800
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
Subject: [PATCH v2 2/5] riscv: Call early_ioremap_setup() before parsing the DTB
Date: Tue,  3 Nov 2026 16:09:23 +0800
Message-ID: <20261103080926.2079-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103080926.2079-1-cp0613@linux.alibaba.com>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0608EA0003
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: qqpg86c3hr58wsr4gd7o1nwimfk6p7tc
X-HE-Tag: 1793693390-143066
X-HE-Meta: U2FsdGVkX19ZS1tajvMDMWZ25ReH+OZu9OkDVEyV5cGX/GqU+gVnw4+JWLTsj9JPgfqYtS3ECCQyJnsSYic7ZsMHLiKEWfrcue6FEfVIgRbEXu9FipbcfJqWnIcXLEdRYx21JKphZ/LC66jd+pL2F4MbN/hVRnpBbq2Mll9C1rYVlvZW34/n8m7fInhNGQbDR1j7jF3YmA5R6AsR4ogjDb/xemHWe9YJljulV043R73HX7qa47LHUoQ1eaX2eJpKfBQkJML6OGcYvojT3sxZ26LqtcYDyfbAt5AIuxJ0zAHad57NmQEdt2IAxhoJzPLNPn+R4rPOeQZRGumCe62u0l05EnFVkSkYWR/6eYWMn1kslzfvCbPM5xZZUJODrTtkhUvwwxWZTPxzbq/Q8imQ20mOPieXZi69B3DZsuW3UjXk5JhFpTF78h8BGH68/I7uPUB30YqpSVbj4FiTYYZZ4KdRtRXb24WuTrjkmr7oMGvvsYig2Sg7Xm9RJFarmhtt4P3b56757fyyxpySftcXIXV0PXzUzHMTd50L3kPly1IO94m8mVmbVRu/ATdnjkUyuTCSym4lEtHYE3Ppy3SVZjkHgiF43F1+kxb2704Ffq3hj1XfFSH1ySjo0i2s8YzBzx7zxb1BrSnbmShSgYKAtc+bl8kWs60p8afUIRvUtMrXd/Fdd7vEyJkA5lnc58MZDQbXz978Ta+2CLp8Vg8bmFcrpsitu8hgPtE/n6duhD2zI9OcmGQPNGFzrkU16Njw/iUQ05gYdOl7hOv6BCVT75bUiuHPTuZXGL6k4Iod7Y1+UmoUlSXGyz5kFBcf7vYUSoA7MC9rax6Bg6LCEmb8R2Qv+/vq9XVhxdcCaa+XsMmMzV+mHJ2MDwb0rQXuYMnFkaq0pvzAzfaStaXXDP9uxNVXpuU5KGh5MOXK+EtswQIWq8WPcfGPhUSrkQmoa5e/PwNA/mPKg1XSMkMe+/M
 0lthF35v
 oN3Dtx4/xuokEknf3xqQ1pL+yCmtWMW7qT98Wr0HzZhIH5+a4U+0jS4tk7VBzFaOrtexForm2K+63GlKDMupeoIeW4FuE11eeZXAYbNS7EwAc0wRBfKrW2TR9pmsUwG/fft+i23RZuEinS8EcBZ1NU2uSOw74QxGxtznryu1/ZIexQKFfb281iqbU+Uj9HQMdUeAKOkQHu9ZrccUQHSS8pD5Q3419RMjMRS+kJa7FhwAcAuTbRfkH651ZRIM1S5z+ymD7RnVL2oebeMkao3u23dQOlm13gk+O1Mf2b4d368yGS/o=
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


