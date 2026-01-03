Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEFB8FC6174
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 08:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3033F6B00A5; Sat,  3 Jan 2026 03:47:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E13B6B00A6; Sat,  3 Jan 2026 03:47:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3C46B00A7; Sat,  3 Jan 2026 03:47:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD986B00A5
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:47:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C29E56C56
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:47:55 +0000 (UTC)
X-FDA: 84290024910.09.85CE0A0
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6C6B120005
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:47:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kfm31f27;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767430073; a=rsa-sha256;
	cv=none;
	b=RPiLX6ctzvMbxHSGcmeKprinXdPRNyI3OM+bpVF+r4vsvFPvDB66IM6ZlO+4LXqBqEVMtz
	OAoM+7wTbyuKZ1KZpmHX0eV3X1bdcJ1mjQz7LUTb4ZK3bR5WCNt4M2Kb5HjD9aAv7nI2vb
	cHMazMUS0q92Nk/pJaLTdadsBvyotFs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kfm31f27;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767430073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sa14InhCOXebwmWDP7ecBkutspm2W7OpFimtcnzXp3w=;
	b=mSiAn3mhRSotrgQGMaJ/Tc3beTxEG4D5ETp8PXllTatOc+iBaK0P5ZXOQEGlMhjfqElFTb
	mHNdiaJBAeinddxqGzX1+/WFYYIf/qHNCB9oKvlbuA88LLUm+AkUWC0Bw4orz/BknujY4e
	agTAaqYFbLBk3SXYTtoJGpeaq7DNxjg=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7f651586be1so232619b3a.1
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 00:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767430072; x=1768034872; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sa14InhCOXebwmWDP7ecBkutspm2W7OpFimtcnzXp3w=;
        b=Kfm31f27xjLKfc4Q4ewKWg0qCGiicn3gzVx1XTQS0IwJI3ARPnO2P06gmyFpHbup+P
         bxqO+gNR5T+LiyEKMQvkwvMOOs1/uPf/Vg1Bu88pcHcg4JmwdZ78bV/tn57SuoW9IbgC
         9vQOGCqFV9Je+5KIBFgg1ghzP3UJXwNRcUvwlRQ//F7ea5pVvXftBqk8sGzk03c99T1M
         encsiXrSa/9jkdJIhdkZIJ+A6opaGCdsfmLqYoYgLm8mMuS9ot0lA6LgcV2d+Mg1h64k
         fujTvpLm1n3s9j5Lvek567Zf13mSJVCIRC836Rnw4pkTDVbN0fiCcjCE0iJC5N6Iviq8
         B9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767430072; x=1768034872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sa14InhCOXebwmWDP7ecBkutspm2W7OpFimtcnzXp3w=;
        b=QgkCbNBiGHtrlCiYqynurWJcLkgG5eMT3shmuZatvGfdqstC6pPT7HmsWDJTVpfqIP
         YFDnsROVfj9i6NW3G4xHTYT17iaV9bSuWHTQU7WFkfqkKBnL3DK4IaJMiQwHbrFft1in
         C5DVjX50XxWbjPtOyVam9mvGGRK9JTD/WSscRjc0O8G0h3e+rs2MG/jdk+XeJA3CwRIz
         TwWKYIEXW06kk6vyGYd4GYP1EFP30Z00QoF3elrHjWgitL5D+cmn9rCERr9R2JmzoMdt
         to9wHfTTJL+RD4MCEGfSTZ/ziEnAfKLfyuXVLCPhsTJdxDiUwBeuKKy0M8H6JVswNptH
         pgpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIfrG4mOF1udnOropno2wqLdK7bffwqNT4TCcgDuvaFkXY5j76E8kx+3Yubzbm9POXA3VKZX4fyQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2xcZGz/LR+WI9euBLgYiqGGKFLEN4gGLNPhwJfZfD8gNimbiU
	JzeQ681HiS/MswGiG5zfd453kmFABHQDGYPGrPDlLE2IneITznR0Kuxd
X-Gm-Gg: AY/fxX6Ev3BGsNn5DG7y9tS+jIv+Il0KJpnMEYSr2y8kfOUM56gHE8gFgLK5p50bn0X
	mcbQyhOc/xsPCd3PNsB+9jkHaz45uUWqr+gZUHoOHqUe5BE+eKHKec0HdmxOwGfwIt75jXnskzB
	+ay3qwctPXZuM/gGFg7QYHxXDRvn+9BAdifFn65LBCdknpHA6tE78xtBqRWEJgYuVyLFblU1h+X
	VkWwXNdJfthDXkGOoe1NiK+1cbhQopiyWguow3Y3ZE5tiG0SM7B2Z+yUZmnKkaHnXeuBxmVwxnZ
	YaiJ0rNl3pL3gIg8jzLQENmQq+OmqyqadhdFDDdrbmgi0bWfg/uAs5GnYwdcTuGxrkLUD8w7C/O
	L1AwrqmhKvKojd7Q26509+xOmJDhlQEjRiIQkd75Ueg2Kv1qpu8VuaoY96PdXNIt+eYS8txrZAh
	a69LfF5yNQHLfWrzMd0PRWPpj4JLhiH3D7RzA=
X-Google-Smtp-Source: AGHT+IEE/qkOzQdehsR4JxutS5UUMjtZZSX5KqQIX0KxALxL/oRTRg+GqK0LQ65hB9xD4RLyoqIiJw==
X-Received: by 2002:a05:6a00:1f04:b0:7e8:3fcb:bc46 with SMTP id d2e1a72fcca58-8148b5212bdmr1895799b3a.27.1767430072502;
        Sat, 03 Jan 2026 00:47:52 -0800 (PST)
Received: from jvle-ThinkPad-X1-Carbon-Gen-8.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e197983sm42704939b3a.33.2026.01.03.00.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 00:47:52 -0800 (PST)
From: Keke Ming <ming.jvle@gmail.com>
To: mhiramat@kernel.org,
	oleg@redhat.com,
	peterz@infradead.org
Cc: linux@armlinux.org.uk,
	catalin.marinas@arm.com,
	will@kernel.org,
	tsbogend@alpha.franken.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Keke Ming <ming.jvle@gmail.com>
Subject: [PATCH 1/5] riscv/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
Date: Sat,  3 Jan 2026 16:42:39 +0800
Message-ID: <20260103084243.195125-2-ming.jvle@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260103084243.195125-1-ming.jvle@gmail.com>
References: <20260103084243.195125-1-ming.jvle@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6C6B120005
X-Stat-Signature: cyamqzrjfkhu14bki7qeejpmamz363gh
X-Rspam-User: 
X-HE-Tag: 1767430073-522912
X-HE-Meta: U2FsdGVkX1/1SxXcfkvkXLS+i+REnCpYK9aAv5QoqSyeXRNAnKlNdDjzgVV8SgXZQjoXQz4EB0fCLzZx9TADk3qLoTRh2duyF4owP4jAJyDO+DYWtCu1j7o9+HsdmuitOryvJC+ENr9ftyMeuHWGvPGSMEJtJ9FSjKmk7RiycLEcOgGmHVhcNOPP8riy77P+I++7+bc2XKG/+bFbNaogSwMxQaSGRUAL6fz78bm/kidIIF1XueVYq10jLjuyCrQfQlYwioRtyDeN816y4IF4fn1y/R34UUQo4muSfhd6+dodN55r7NUdHElA+Npv0xsnNX1e8L8nWaIjiwG5L60C8QdAFcriP/z0P0iqOxBtt/Ge5DKEY56Ktg5X2g6yFYcF0J14QJTJvIHHqLV+sczeFc6jQLIcSFZFn06zpv3xyiqoqQlQZskQcOalMhHakaWs87crkx/xt84b0XfTAwC2ZPXkpdrI9avaoNKIb+Q0cmDij6zG0L2FsFbaa8LC8jtI5PLziTWKJP0Gk0f/PHli5iGKqguw2dcsFiltwSAkkyMmw1/fzdaAvH1YI+zgnQrHYm8GvPDBwosT8M+QhJMHQJHmTvAjZQmVIi1m4Kh/hcxHY5/QzTH8YotQcil3eu2G9pdLrbZP6IYSAuPR7iZdmrlklf0//LBaikVsAPt78EZumk6JGi+FLFS2exYLtEpG2eZjy/IrM0a/kO9RDHfGSrmyLsZMwr6q9VGMeQp2b1crW+pXw+yPjpKMQwX5WVlf/QC3hZS+f4CEG4xEOW7jKYR2T4pUyW+Babf9UEwHmqRNxJqytgR4845aw6VNSG6t9X7PmUtbWwX4B+gLIoakG7kOty3Jct6SzAWh7d0GGprUSkmLPfwD+5eGgMtY+hD8HZgORuXjxZQ8THkkLmpCgpBPGq8u2fW4aRpthtoA0oBOHIbgAN3cTv06KmzFNWaCQE/gvE2mTTrhhC2vPkQ
 DnnoqGhc
 /oqwN8I+5rv7d8+2BAc9TWrr2cDKBi81DCULQMJFPVet/XxXH13NYWwyN7ntWNH8fCn/+qRcBVmJRB1uay3pemx/dgpUAlG9B4zwbby6fdwu0CZfqFjgvjBC38qDxOsVW8obLSQfyLQOnpTY+PI+Cs4euSTGtdo/jFFBxBni5qJAoeLcPWLQmWVmQt5grj/Dnj9dMx4qYl10AN0Cv5rO8bHfhXyOiMB80fz5ZOrbgXeWPwL3B6aJtjyxGNtTi3Cjry27VP01T2FujJBHz0qrAVPZoZZGf7H1pTAfNvjsyX4FD7wEL50q1cLpIQovVhhH8Wk6tG0YvqnDJ4PcsY4V6R2mvQ1S4go0FXfy8jhTIegb0Zcnls0UVJzX9ajRot2AuS9MLAgta+A0v9zGBYytx2npUh+GUgE8LcSxi0yTlPSB3o8ESk+mGvuNwJvjxoB96RrNnGebZ6FlS+CZ6PP7Oi69VubQxnKf2JbSNK6+m8jH7e8pf5mmuUNjUpQeZLtGo/aN5/ZjbwU1wasydMNbuQu2tWg/vB/mhqFXJimRb21KM+H67X5JNaHCudg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace deprecated kmap_atomic() with kmap_local_page().

Signed-off-by: Keke Ming <ming.jvle@gmail.com>
---
 arch/riscv/kernel/probes/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/probes/uprobes.c b/arch/riscv/kernel/probes/uprobes.c
index cc15f7ca6cc1..f0d0691a8688 100644
--- a/arch/riscv/kernel/probes/uprobes.c
+++ b/arch/riscv/kernel/probes/uprobes.c
@@ -165,7 +165,7 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 			   void *src, unsigned long len)
 {
 	/* Initialize the slot */
-	void *kaddr = kmap_atomic(page);
+	void *kaddr = kmap_local_page(page);
 	void *dst = kaddr + (vaddr & ~PAGE_MASK);
 	unsigned long start = (unsigned long)dst;
 
@@ -178,5 +178,5 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 	}
 
 	flush_icache_range(start, start + len);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 }
-- 
2.43.0


