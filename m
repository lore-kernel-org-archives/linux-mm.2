Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70D0CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1BB6B00B0; Mon, 28 Sep 2026 13:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72826B00AF; Mon, 28 Sep 2026 13:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13136B00B0; Mon, 28 Sep 2026 13:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88C336B00AE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 225491A0283
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:01 +0000 (UTC)
X-FDA: 85263889242.29.DAD4616
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6C50340005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mCPAo09B;
	spf=pass (imf11.hostedemail.com: domain of 35aa6aggKCHoqkmqrYdYemmejc.amkjglsv-kkitYai.mpe@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=35aa6aggKCHoqkmqrYdYemmejc.amkjglsv-kkitYai.mpe@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbjBREz9vOqId6KGSe2hfelOhYq7OUN6jgn8hmrgsOA=;
	b=D6W+AGQZHGEmlhhmoHAQJKAina/l/Cslap6fNVm42ZKxuaFFNanMpeECivsLmqG3EcnCLw
	Y0Fujzf2fvu7B1ADg5Hhb4+CYSr9ig82KrFdhoJMUymaZC8XsiTOli92hvpKEPHoW6V47I
	x0ekRuZR7ic0XTOxbvj9KpYL9UQckhs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617319;
	b=oaO9RIoFBxLLxLqXYmIF2dK23keV2Kv77ceyeKpwGcnp6EBp/XOCFB92vBwgImnMFsYpzZ
	yUbgCSKex7LR1mCWJO0ze97h2W/qzLh/mYpzztv1VUfQfOFVUlsVmr9O/EgdmoWZgPXTEv
	CaiBMVXToxgKd1gFrmbM95Bgau0MpPk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mCPAo09B;
	spf=pass (imf11.hostedemail.com: domain of 35aa6aggKCHoqkmqrYdYemmejc.amkjglsv-kkitYai.mpe@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=35aa6aggKCHoqkmqrYdYemmejc.amkjglsv-kkitYai.mpe@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e65bee41aso2661945e9.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617318; x=1791222118; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wbjBREz9vOqId6KGSe2hfelOhYq7OUN6jgn8hmrgsOA=;
        b=mCPAo09BWBi6FWNHMoS6wtrWfsDuZ7TAEINTfej0NsZ2HLPvbPo0Oc69JMarsCgm4q
         SpeWPKBBD+xltPtw71Y3a1pqo24asiUNoukdJBhY6zAgDVCicBo+dbE7B9dVBm489Orb
         hV6JxUSPZCpL2EkrAD8Rs8CLYEmbNcSzls/DqJgHIIF43OFEuyZa1YCE28oXtY35On1i
         a8WrDyNeV1wcpy14SJnXzEVxvWdsjKMXuUgH6D5FbB+OwBwiBFUAUknwHyJ5sOfpUyBR
         +xCSTLYlG3f3Li4twfypb8FjstbjG8erZMtOfY7sMTg7bGL2qrNlgPF3EvhCpyofz4nV
         xfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617318; x=1791222118;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wbjBREz9vOqId6KGSe2hfelOhYq7OUN6jgn8hmrgsOA=;
        b=IBptTOnCKY0vWeGHJBeXe/a/ktuPcZqCWrgf2pell1OmNQBflR80eJfsjYXm+1Un3N
         WHlfTpqU0FUpCigT7Ro1gdZva8f/DVTkr7IU7rF5xii0t5Bv0PyQB/Gr+NRg2PL6tx6i
         zNnkpzCeHIe1cgQG9KjC6mWE+60AeAYVWnPo+IROMaDpqL1pTBK0/HPr6K4/asqaK+ZN
         QJqnYHV1PuIUA0bIWQemiDjXnrkBcNYq+D/DhUnFGCt/UKOul2P/WxJyl8Rki5bJf2PI
         fD4WumjUDUU2Bh28O1q6EAeo9GRIw083uaoPEUDzVXvpSWnj22XRcmXPzbbylI/UhLJ5
         1z7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxIjZ76g4GWyCosUio1dcsTGyOsuDn/Gik4AzJKd7dFIYzGyiZMrJ+uP//MdMoPZ7xiMGOnMQ2gmw==@kvack.org
X-Gm-Message-State: AFuF++kqPizDwtahC3ycwRi7geVHpRQ+S3ryKPPAM2AIgbwWjhn4NMzF
	IzA2bc4P4Ivgi4jbgxbgLFVi2blk0uQIaO4eG1Lc1dMeHQY75avpLqInt39DWu6f/T8sfNC8s81
	uzsWtszypH8sYpg==
X-Received: from wmdv11.prod.google.com ([2002:a05:600c:12cb:b0:4a0:8ba:ba83])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:470d:b0:4a0:34a:588c with SMTP id 5b1f17b1804b1-4a00d778efemr1664475e9.14.1790617317905;
 Mon, 28 Sep 2026 10:41:57 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:16 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-10-smostafa@google.com>
Subject: [RFC PATCH 09/15] arm64: Don't assume the kernel stack size
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C50340005
X-Stat-Signature: n4z8r3et9mw59wesa65kcrwo3pmbtrap
X-HE-Tag: 1790617319-756038
X-HE-Meta: U2FsdGVkX1/vtXML8j+18tIdswx3RS1Uo/JolBv++A+7yNR2/JoMKmuLYkvH8mH6s1W4YUn3SHzXdX0j81HU+7KBhjxf2ANpcQScvbyo6Fo3bveOOQlQbrREt+sebUVtKHFm6aEPMMcXBsR1yBFx7KHE+lbjsQFvsnXE9ojdT9pfBBr35xkYq1cAMj5ku3oksg3J6PsnMKikAzR1uZr3IG1vBE4QU5x1Jy2Cr0cuQBpcESYom4txrf6RA/KhV557jEOk9uOX2vQS7O5clyoqrN1F7ILtgt0CoE0R6F7Yd00Z6WDTmOZzTjPVpa2dCz7IFjHKJpc6L/zmbsWkE7FhtrV1IIHDu2Fevp/9S99juhFShX0YBYccsxzlAALwpRiKMqztuWn3jERY9v64BDQjwHdf+bzqg4HNJvYPBVKq7ylvC0d6kHn94T+b4hsGqlSvLafjWIViwER89ertSZ9V0pe+k44yVPbrHu0GoEx68gDNGcMIPcKlvWJDIf8B4GwYSZxR09eMZTQeTP2cCnqluXrRdA2fZIFP5KP8YA+jpYRwWJFQ4mCDXzZZ2DbaRFEweJh+ICdoRVQa1OxxBE1Vc79lUaznDlejuBjcp2siTo63qaGZD17jxWDjWNf/RuVej+TdXUq2MRK1FtFq9BjmMFnBQVGAEFK2B/PHjMvg8kuOGm7HQIYul4nFyr1NQq6Gg/2BAw+sjlzZdBSyR5d2dw8qEo+YgeakHW+WyUzJUvdmGPKEunSPUcUU+JuXLPlSMWWdj00Uj/Zkma6E3v0iB0a3IZv93espqAYxFX2yUuFz2tg7oqlvm03NW1jCCtP27VSvile1jK6PwXCCvY5UKNl2/kovpBjoOaoYu9WQbonnDayRCDEiqnc2lGD5RzPhyo8nlG+iiXRIZaRevYZ6UZBo92KFPIUCQv3Cmbgik72C4DMPc99fVry3teZFsgnbqfn212i3sKUYVoXI8Ka
 C3PvDl2t
 ZLY7RAVisA0bGFbaQYn+H5giCjOxR93o8tXIJAF81jjp+VDj7sbGJLRZQAHP4mZf3lGXrF8Ei04lfN16o9mE+vDGSi6xd2qpZ9WFVroRBSrjgEOFLD5v9uVJ53Dj+g5NVxuWS66XXnv2i/8k9ZvbpMdvdGhrVUm9MT5YEfh8/R01uKTt+hdBZj2TpacexQYlzvAAOTIRL+eu3gCKrLjOaULr+ykiPs00DKKfp0UrpYDB7UzmGr2DmFqRzLoA2KjztkH7qIh+MR9Rx/wMvNfj3LeTiNi2Rtjx6KTaFhSsQ7Up1CV1jiU0f0cNNBzH4AWhJkA3NHmXl5k69k+DU9Qhyiyaphh0slGs2LTDVr+r10fhW3Oepy9d/hVMdqmvpsU5QKe8tI0tFOrXdy5KCSJHFPyJgdhw4XkD/bUf1VXjYGfLktUiIx+sjO8KYm57LplRsRGxUfetYrSTIOniCsMeMF4Hr8o/KKsOGrdJRS0PNkj0unR72UU623XXA1zlQ2umXeKhwphe6EUeluMy1ru283yzWkAkib+0YlVFRicsOScy2uR6w3agp6Z14Hk0lv0/YjmzC1KwcGqT1Ktkz8s8M5MJIWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

stacktrace and panic functions assume that the kernel stack size is
THREAD_SIZE.

The allocated kernel stack size may not be THREAD_SIZE anymore, rely
on the newly introduced helpers task_stack_{low, high}()

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/stacktrace.h | 4 ++--
 arch/arm64/kernel/traps.c           | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index eb18d7cee62f..cbc93cf213a7 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -41,8 +41,8 @@ static inline bool on_irq_stack(unsigned long sp, unsigned long size)
 
 static inline struct stack_info stackinfo_get_task(const struct task_struct *tsk)
 {
-	unsigned long low = (unsigned long)task_stack_page(tsk);
-	unsigned long high = low + THREAD_SIZE;
+	unsigned long low = (unsigned long)task_stack_low(tsk);
+	unsigned long high = (unsigned long)task_stack_high(tsk);
 
 	return (struct stack_info) {
 		.low = low,
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index ce0e213d772d..b91b154843ef 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -902,7 +902,8 @@ DEFINE_PER_CPU(unsigned long [KERNEL_EXC_STACK_SIZE/sizeof(long)],
 
 void __noreturn panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigned long far)
 {
-	unsigned long tsk_stk = (unsigned long)current->stack;
+	unsigned long tsk_stk = (unsigned long)task_stack_low(current);
+	unsigned long tsk_stk_end = (unsigned long)task_stack_high(current);
 	unsigned long irq_stk = (unsigned long)this_cpu_read(irq_stack_ptr);
 	unsigned long exc_stk = (unsigned long)this_cpu_ptr(kernel_exception_stack);
 
@@ -913,7 +914,7 @@ void __noreturn panic_bad_stack(struct pt_regs *regs, unsigned long esr, unsigne
 	pr_emerg("FAR: 0x%016lx\n", far);
 
 	pr_emerg("Task stack:      [0x%016lx..0x%016lx]\n",
-		 tsk_stk, tsk_stk + THREAD_SIZE);
+		 tsk_stk, tsk_stk_end);
 	pr_emerg("IRQ stack:       [0x%016lx..0x%016lx]\n",
 		 irq_stk, irq_stk + IRQ_STACK_SIZE);
 	pr_emerg("Exception stack: [0x%016lx..0x%016lx]\n",
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


