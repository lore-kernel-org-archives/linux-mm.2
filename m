Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C05CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8D66B0160; Fri,  8 May 2026 08:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A1B6B0161; Fri,  8 May 2026 08:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB01F6B0162; Fri,  8 May 2026 08:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB42F6B0160
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:43:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DF7CA07CB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:43:24 +0000 (UTC)
X-FDA: 84744218328.16.C35894F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75969100004
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:43:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=efUEqoAR;
	spf=pass (imf05.hostedemail.com: domain of 3aNr9aQYKCGsPURMNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3aNr9aQYKCGsPURMNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778244202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yw8JlaSpIG/b7wcgyltU18thTsqMer3AjPDNtSWFlzw=;
	b=iTnEQr4S65DztEvqEGie5S7LT2iBjv28hIw/wmAGcYrhzQvCo7oDtZvBQRdEpp7LN8zOCT
	MEnOze7aowx3YGEQbdMKsWoxzDh8YPlOiZn6UqG9eUiG4AcCG2yTehg3GC8wsLaYs72IZu
	fb112vfFgnhyX6YCBzrD093oxPAKIMU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=efUEqoAR;
	spf=pass (imf05.hostedemail.com: domain of 3aNr9aQYKCGsPURMNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3aNr9aQYKCGsPURMNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778244202; a=rsa-sha256;
	cv=none;
	b=J8f0EB74z0j4AsFBDv/mlJXtq460JZXGXrVWd6STIn7R3ca9F/4gL0utD7O9SgVQ/CW1HN
	hv/laaWRY6fOTdNQdWVn7GmFCQPKNfUERWLQwLPBEJFLXlDgdBfmbZgkUj8LR583qtBcc7
	H6P85UVQ4/4cVTxcTz9awtenCXtYWXM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48e5df296aeso12195625e9.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 05:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778244201; x=1778849001; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yw8JlaSpIG/b7wcgyltU18thTsqMer3AjPDNtSWFlzw=;
        b=efUEqoARCgV4WVc0c/ykl0NOgsk/tlipGFPx6n+JME7ODU1EkHT5YSJTI6s+5zrI1G
         VECxiizmDHwtiUnSlmxVGKcZLxs1R1Niw2BpJ76DgXA9tsHSxPsET0l4G8+MsvCrkAj1
         am3KEEl75VNiDYJuCM5/1dDZSB7maRlI9QDmRMCifR+cuoE8rt7jObQNHgrjbUPYQRe1
         ObX1D3ehjzSkyK68teQmCzmFnQFDF4LfsNu5+7FUqbrwoPeosC74kf7leI32025i0hh/
         9u8CTlxf7wpoQkWglNghxJcI5wKdAxMPDz7H/3XKa412Mnt0Z+6hGPdWlqVl58Z5ftIP
         n5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778244201; x=1778849001;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yw8JlaSpIG/b7wcgyltU18thTsqMer3AjPDNtSWFlzw=;
        b=tY7qY87NG27Lof20hWEn6+Id0pXHDNTfzDGbaklzudlZh0G9QswEyxGZdSNOiw6JKe
         mwCqFEmBpxIEzUMlCiezM0cAQethLN/xNTGkgBSQHjNAyNbhMRi8To0w7fwtgsXf74aT
         nIAfgZeztVx75ScZqujEw85PkMAlGB6Zy6FK6aQitAQHv+FJYVssY+gQjfeNXtBIj/94
         g+lAMpLWh6ZFw9wfG/tlIASG4wIk2wRWC4si/Soap5/L1cJWJOm8VGuW3s8Y5JwFy8hT
         1gMlqLwD8K2drJ8EIL+nJAN+8yLnU/63KYbPVsGEjYL54tGoNPbkzJwui1oSXCL/TOYF
         BsBA==
X-Forwarded-Encrypted: i=1; AFNElJ/b6NdL9GlmHuehI9VfPHY1YSLc62x6dZwr66f1+FSwFcWroE7mmFLGriSUtSq+8bA6AKzRWnizMQ==@kvack.org
X-Gm-Message-State: AOJu0YzwfgDOsW+mCTgJMoP6Ue6gQxWmLmjcCZU4feK5OOhKqBbVPcOs
	ANzrZyacT6aIbfWJ2peISsjZFyNidsUbbzyqGJVbgARrUzmKv3tY/lYtye9WAfD+HcUoH0YIrDM
	H4DxMuA==
X-Received: from wmlf19.prod.google.com ([2002:a7b:c8d3:0:b0:489:1f67:5a81])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4749:b0:488:aa33:dc8f
 with SMTP id 5b1f17b1804b1-48e5df8d7a7mr98905585e9.0.1778244200245; Fri, 08
 May 2026 05:43:20 -0700 (PDT)
Date: Fri,  8 May 2026 14:43:15 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260508124315.2526312-1-glider@google.com>
Subject: [PATCH v1] entry: Fix KMSAN false positives in IRQ and NMI exit code
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, elver@google.com, 
	Dmitry Vyukov <dvyukov@google.com>, Jinjie Ruan <ruanjinjie@huawei.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paolo Abeni <pabeni@redhat.com>, 
	syzbot+cdcfd55737fe43eeb3a3@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75969100004
X-Stat-Signature: w57qmihcyu8w3fwb6mckekimczimwd1g
X-HE-Tag: 1778244202-352165
X-HE-Meta: U2FsdGVkX18n3Eo4pKeDFZzwGt+JclctK2VA36QCIsIU8KDzW0ypiY7nSc80onaMCzbzm+/pmveReb/ii10xT5Tboil9O87Ia3XtKGnRmL0DZSLs5eDjlPU/1S59qp4JaSK7KJeKEsakbGDKBmbuw6WPWnYqh8clzbyhmo5CctznDv4D7Gj1hM7JTdwPvh3V6qCc2UbfKKekDCHoD3nat/PtBHtiQOZfmVhAgmObb/BCo/nzA4UR3qd4yzI5SbXlBYZuNZjb7fOSOZpsvTqmxhBFbZ5YdhnTz/r51HfaRv+AuXycS8Z4qCJCzz2ShaLyIbjDgtEaGCQINCCl+bqfjvS7ia300nejfH43ko+5eeBmNEwe1AjukBKMwBmLDzgR2aWJzkfitbtbxznB5dnHPO+aCT5EWUpnzjJr++ripG48bg4BcndKDJ/PFUD/R5xsjrQDuikNKeLMo5HqHKJnoaLXhPodOPl+vLq9XgzNynQV2ZwxQAA61QObPsFyeDRJxW+8KKLfPqQCjkpXYvg46IhA9Nc09TCmXQznCzvYdZcZHgHxrP/GBy3jnpNdAHx8NjFEKOjNsE+7uOQCYRpuwaesM8Tuahys9rExgPHVBMSHmTpBz6KXQo9Adktaykdhta1T0dIuF4D4EPHdWq7n5NweiAlq1Tn2FaFJ/YI3ZrnE9seBTXzynxrEH3TPS1UdAuh5unwnHlokfDZPHnxmMnnBJKexrjwKAGckTlgxD4ES0d8FvFRwloZl1tQd0ZJY2nSfof4rp4NQ5JELBaTwFSNt6TN+Vdz/KQYXJ1ajLxSKJtrG3ek64Avt3RlnfP12AaTrr4hwkeRvlZw+zfRqT77F4fj3qR7EBNinzR6nwK2hMbJptPbvfHc2g+escSEEXr1DeUT/0nKovOz9f2D4sF0siUD61fkHnURzXBv3pyOwTU+sgW0w9iTNIcWnIjwaeNxhkiU47nWktSNaNut
 PtnsFyFI
 EvXz6EyTEl32h5D3/4Q8Uy7j+PoK41YQbKcnRL9NHBaStykvQ3kzp3Rh2SFURn5fGTieyjyHLyEwhLHQRUKca9o/r1xfaGG7VlcJo0tnOMU6u0bsRRnypCsSgfz+ciEgn8mnt/WAaCPJY5TLs35LmZJKa+5xQvylUkZuxsvm5tP3+rCAr3PJjqPG+ZL5ly9HbsE+OLY1A7aK4EaI0MCibxNvnREq9XAF/apMxQN/J10wtdzn5dUQlamIV0xtNTXud/2ozF8tyHGqXVZrfu32orqN+ZulZ022ECKzIbIuJUIt1cLBMKikqOthQS5vU3d2cD9y7IwV8wMzA6otsFtKMW8xSKQmIq/1IFRLSz2IlUZtExWgrq33wmPCu8j/QW/7lxe2z0swUmhLEoKCb8QQAOzUHSJCFvSqfsHwSArF7d08WIOaRDMX9GvPoNlCtKIaJP9WlDc91hEMNkSUPmaOfjZipDN15EMyLdR0YcdLKlr6IONI9zl2rXHCtH9uTGnIYFKhzhNOa6TtikAndEfozI0ZGxuLvkpud2i3DTIoIymvPD/DLZfiYc7j/ImLJosIAOLH5DUQ1kddza/4AygZ9RaMNGqD2riQFYLCkFswluSltNI1u0rOdMu7tsfeRm5xncLHlp1ZmHy1DR3gLuaa0L98u0ebLfMWGRIde+N8A8DemWfiQXAhpNt5bF8EN39WrCh9eT/aQyntjZBSB96kRH01MOW7PnRv2yQFFYgc8udUzhNwQyJTxTIQefpqwunuYU1/8rpDrhwvCXI85MreRxcGMIIS58VrXyKb4FnLsDu6yLf6RzWR8qRHLoSMDMbGwxfOvIVxpfTkGi9KMcOqyL4EvIKokNthO/vMGb18pGUMVQI7QBOgV6Zr8gzWV8DUeC7HIPmh+8qgSFkoOPEEZZtM4lAyVKctfRKze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported a KMSAN uninit-value warning in
irqentry_exit_to_kernel_mode_preempt(). This is a false positive caused
by the initialization of `ret` in irqentry_enter_from_kernel_mode()
occurring in uninstrumented (noinstr) code. Because the initialization
is untracked, KMSAN considers the state variable uninitialized when it
is later passed into the instrumented code of
irqentry_exit_to_kernel_mode_preempt().

The same issue exists in irqentry_nmi_enter(), where `irq_state` is
initialized in noinstr code and later passed to the instrumented
irqentry_nmi_exit().

Fix this by explicitly calling kmsan_unpoison_memory() on the `ret`
and `irq_state` objects inside the instrumentation_begin() blocks of
irqentry_enter_from_kernel_mode() and irqentry_nmi_enter(), respectively,
immediately alongside the kmsan_unpoison_entry_regs() calls.

Fixes: c5538d0141b3 ("entry: Split kernel mode logic from irqentry_{enter,exit}()")
Fixes: 6cae637fa26d ("entry: kmsan: introduce kmsan_unpoison_entry_regs()")
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Reported-by: syzbot+cdcfd55737fe43eeb3a3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69e7ee1f.a00a0220.17a17.001d.GAE@google.com/T/
Signed-off-by: Alexander Potapenko <glider@google.com>
---
 include/linux/irq-entry-common.h | 2 ++
 kernel/entry/common.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/irq-entry-common.h b/include/linux/irq-entry-common.h
index 167fba7dbf04..be47d430d521 100644
--- a/include/linux/irq-entry-common.h
+++ b/include/linux/irq-entry-common.h
@@ -427,6 +427,7 @@ static __always_inline irqentry_state_t irqentry_enter_from_kernel_mode(struct p
 		ct_irq_enter();
 		instrumentation_begin();
 		kmsan_unpoison_entry_regs(regs);
+		kmsan_unpoison_memory(&ret, sizeof(ret));
 		trace_hardirqs_off_finish();
 		instrumentation_end();
 
@@ -443,6 +444,7 @@ static __always_inline irqentry_state_t irqentry_enter_from_kernel_mode(struct p
 	lockdep_hardirqs_off(CALLER_ADDR0);
 	instrumentation_begin();
 	kmsan_unpoison_entry_regs(regs);
+	kmsan_unpoison_memory(&ret, sizeof(ret));
 	rcu_irq_enter_check_tick();
 	trace_hardirqs_off_finish();
 	instrumentation_end();
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 19d2244a9fef..390364943f92 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -177,6 +177,7 @@ irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
 
 	instrumentation_begin();
 	kmsan_unpoison_entry_regs(regs);
+	kmsan_unpoison_memory(&irq_state, sizeof(irq_state));
 	trace_hardirqs_off_finish();
 	ftrace_nmi_enter();
 	instrumentation_end();
-- 
2.54.0.563.g4f69b47b94-goog


