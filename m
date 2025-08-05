Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A6AC87FD2
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91FC8E0012; Tue,  5 Aug 2025 10:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC948E0001; Tue,  5 Aug 2025 10:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB7A8E0012; Tue,  5 Aug 2025 10:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89F178E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D90D14043C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:51 +0000 (UTC)
X-FDA: 83742930222.13.C65B0D9
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4DAB140012
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mT6QQ4yf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404009; a=rsa-sha256;
	cv=none;
	b=fnPgXmXUP57wGNxlN6w7X8UOf1kbjenEoTs5oiEKjCmYL+51FLnqjcotH5gQFqhuSxFz81
	Gx7G0eQl0EfK32lYx8nkNRNxd6qBF671qrM39TZ1xwC5OEBonKJluWh6do/8eMmleaLR5X
	ZkSZ8kTHEZRQEuoFiHAW80p0uPXKakE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mT6QQ4yf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdpO03g2oqaaq9F6m1+GGOlZl0qQTOQbdkE3YGqW9w0=;
	b=EFA1F1AD+SpHn6VfwT5SV4HFbUQ+sc3+8XncMaZnW1Kp8X0yS3z8C/5BsibpU/qTyhDNAB
	8NE6Bt8zy54UCDrb6rcKEOx4FFcTyaTkyJdWblLJ8pg7Qs0ZUI7+fYxqkaZMBsxY4mPpkE
	J3jJIXNOBABrC9f0G+EFLVz4S6KvS6E=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-55ba26abd62so2665790e87.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754404008; x=1755008808; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdpO03g2oqaaq9F6m1+GGOlZl0qQTOQbdkE3YGqW9w0=;
        b=mT6QQ4yfIw5kIfs3h2rCkMngY6vAvsajVnU9ZsJffbNR5ZG/2ONSmkxzLdJiQTQ4Nx
         pS+UopqfW5Vb2LUkMZ0bkbt23bz11lais/GCAtCDtO8EI0cwunIYjLtWVnyy7cN+HHsT
         3HYS9klhdyVD3TdEYRs5i5W3ddQW0x3PXoiTwDgIgZ+eupRpAqLoyBKQYbGqn+qPVcL2
         BLew5QzjzzLX+4ffU4+nK3JVEKf1A+3n3VSL/T6L6vK6yL2NPI5BY4R1V5jkShDpWC4R
         0FFWNKYz27KyqyosbycQpABT3QqerkX5Be2l2Wq7La1z9MP2LbDevuTDnL5xkbZXWwFJ
         XjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404008; x=1755008808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdpO03g2oqaaq9F6m1+GGOlZl0qQTOQbdkE3YGqW9w0=;
        b=E2seqQs6zafzM/rbiux5V90xh8f3yNp4kVgv4ABTYWyGtvsJgIgHzHA12lo9mPXbcp
         4B1J+D3hK5G/wzUl5zJQjl1IhdczroYuaCNOtCyM2OyajEiM3yWO2PoLCwocTIebtGru
         XONxdNid8q4cWi3XgxOXlGb96awrmLBQuUbJmppDQMsM9T3bI95KZjfZYeO3b4g8/dM9
         W6Ep0t/i4kcFcDzCIk7nnoO8cAWJ6JQ5lpif5UkSMoC8j3yiyge3Xt9A9UDaQGxSYSVE
         tRSAukHA2Rl4cAO0QC/AEyVoGHNN2w+A4zgeOx28pVzgxQ08ir7oEuqQ6/dVYCRphQ6R
         xAXA==
X-Forwarded-Encrypted: i=1; AJvYcCVV5LHjosJzo4fUD2XlpmCT4aehliVA1QziNPz58TAPezyBNOfTjtb2HZmxW2h3yfy7hv/aARFITA==@kvack.org
X-Gm-Message-State: AOJu0Yxb0D0OC/WsfgLi/9OaEmroE5aEIfTIQ/7/cfxqtAwIxQkveMDq
	CZ2rBiIH7jhoswAK1wjwnhfuKfYECtNTs06RMyvtvUngQYIpheIlw8y9
X-Gm-Gg: ASbGncsS12EqModHV45NeyPZsuUzEiH03yH6L1vfqADW8Sfnk5T1tIJhW1Mk2M7KauJ
	AsvzB8XuELAsKEzpVQ+fCO+YydjASfvxQ5eLMNOGuF22FCD6ANwpEftDYY8Pu/L/HrZvxI+qgpX
	B7SbnVQgpXxUYMwr4OwB3bfjR6aaieXODZYpouX5cAp2UtY7qkgxTYiFNPSh9z7QgxE90EYrITZ
	js+gH++oNzJBbjjIXAiJs73R7mi+o4/4TYiA2OpaMb71mBOuIkKcFtAdECzfnMFfu0N9r3SBpOu
	qfDhoDYfGGCanuNpHvDoy29s2nOCYTsRv2wOTCq/x/OZrBvsRCIWahG/+yfo8ZB3nWRUdG0Y7/Y
	4P0R6CGMEUCzGTSNyN9DlA233tlAIu1KdsMdzXoiacaMyZmZxuuMCdsn7Fj9KShaxINZRgw==
X-Google-Smtp-Source: AGHT+IEVcUaDrsN/KncF3Ds7Ejr3CDmhOGcodfBsVHrYzHQORJKCgwrZQppnXPfaGPKlSAziWl9h7g==
X-Received: by 2002:a05:6512:1254:b0:55b:842d:5825 with SMTP id 2adb3069b0e04-55b97b9395fmr4615455e87.43.1754404007496;
        Tue, 05 Aug 2025 07:26:47 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:46 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	hca@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	andreyknvl@gmail.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	trishalfonso@google.com,
	davidgow@google.com
Cc: glider@google.com,
	dvyukov@google.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	snovitoll@gmail.com
Subject: [PATCH v4 8/9] kasan/s390: call kasan_init_generic in kasan_init
Date: Tue,  5 Aug 2025 19:26:21 +0500
Message-Id: <20250805142622.560992-9-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4DAB140012
X-Stat-Signature: 47o614mz9fzspjsjbkti3idrgf41a59m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754404009-792648
X-HE-Meta: U2FsdGVkX18zNoqm4meh1GCckijJBEw1Akp+XWNNXu2Cn9mah7T99EbFYEi5PNIOKZ+OZ5k7q6QegaX2bwbCToLRIM9Mfn+l0KgtijUy2mwVtYWVx8NqlJVWj9pcfd4wfpchI+TdeAgRfQJNx+qt+iOUgfxSCINkSXOEA1pXKTPU0KHUz65DLkOo2AOQULr5WB9eRRYu9inh3Fc83xYUwSg1XqylVeqNusNz4J7UMNzMLfhtQwvv0gUyYL2bQFgCDLzgsjDz6QYtwvpSfddBIH3dsoaZcvLjn3mbM9upMDIYCPtF01kGe7IT4EnMJyQyleBq7nZ671Eucpyhy5siEo/sqFu+EABufXyCAkV8Ode9oAs9bmWSZUGGNBCOTE/eGDAqEnmqLmeXbNWMP1flE2cXMs7i+EtRSy62rYM4DkYld22jro4/EgIrTdnhiZI9h7rxIhYMMu26tnLvG3zRMPe0DJRMoy7m6vblP3Ewarlyt/PfQ/gnlHsFXUxgD46MYWkNOH4PNCwok0DVdhj8RdwDtY+rTEUiGRZinR8w5df1PC7hlYT6pHdhI3VhZVZn2prvU3hgCS+6cFOrTHm68fEEaELn904iMGG8W7FOUo5XlAKiWkkQVrQalOc2A3RXrEI+mqFY5bIl8KanryMuVLOOuroCX/D5emVag8YJ4dZwLzPRzGNYJo4wT9Bxq5MXFckOBeVCcQWYuoR561h0Lg54wfnmTut+A0OPsfpEIao8Peo+c6XijEzzjYHQCfwWGU+U0aASXv2VdQmoOAHV0Y33PpF6n2uCGSc8A8RvWQYbRNOiUFLphLpvTmEfJrCxKJ0NV7MAesBCHllmHVMyGVigy4NIxkg6AkxRZtjZyhJOCZ/NK1FUnX7b+fVf5d4C7IGCQmIwQhPjzSV6UZAEwbzchZcYXXT5fhLqMcMs1zZRv2pjVhGo1ugbj2UOyT0XcHqm0bRbXAB9aym/D85
 I6zBiuiu
 PgZuq3GnY8j9vAKprMf5ii+J42URAqLSX1ewivArkl1ep7nF+gXPMgYRFzwWPphoPltny69aO3XGwFmW2jaXMWdl6bCBc8BcNBT9TvKaxR6A6q9z7JDPFpT9DCrvJnL0kOqLO5rz3rxeE2sZCpCXBentybZmojFAZoejPSGuKJHMckVxxYkP49xZ+43v6h35qfUJbB01Jv3Rfft4m7J9vvtHzBCcemo1JFeFMWrp4vfSzjE0ACF8231Zt/II2y00QyusYO31EPnxFEC9wPUpkVVIqaUk52kTGEEuWRMCJqTT1SxAW/9TkVUilgn0HvfiMQQBg97pirlmgM6Wh6Dycb2DCCaz7o5sFd0FO5HJn8HstH+GbSbNOne6PGhJq0BRy1xNSJYSoUPhlg0/JBgGJjIPrPwHF/f/rKIjiFZ6183YDpJX6u5AsjfuNxDoGHzDJucobnkkppwYD4z5ZAm+Ilw6BjmcVUqGi18AUfFqMUI2w0oyxmhqgwbtqpTqGY71eP66K5ZQ1PjdOars=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call kasan_init_generic() which handles Generic KASAN initialization
and prints the banner. Since s390 doesn't select ARCH_DEFER_KASAN,
kasan_enable() will be a no-op, and kasan_enabled() will return
IS_ENABLED(CONFIG_KASAN) for optimal compile-time behavior.

s390 sets up KASAN mappings in the decompressor and can run with KASAN
enabled from very early, so it doesn't need runtime control.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 arch/s390/kernel/early.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 9adfbdd377d..544e5403dd9 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <asm/asm-extable.h>
 #include <linux/memblock.h>
+#include <linux/kasan.h>
 #include <asm/access-regs.h>
 #include <asm/asm-offsets.h>
 #include <asm/machine.h>
@@ -65,7 +66,7 @@ static void __init kasan_early_init(void)
 {
 #ifdef CONFIG_KASAN
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 #endif
 }
 
-- 
2.34.1


