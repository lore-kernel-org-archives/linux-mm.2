Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB5ACAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACCA78E0145; Thu, 18 Sep 2025 18:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06AB8E013E; Thu, 18 Sep 2025 18:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9420E8E0145; Thu, 18 Sep 2025 18:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 808F38E013E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:26:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B55E1404FB
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:32 +0000 (UTC)
X-FDA: 83903806224.29.C40BF43
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F667120008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dGntTpOC;
	spf=pass (imf29.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758234390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tZ1awk6SoUQIOVQF3O5Wg32Zi3pcSNXGfmdT++muNE=;
	b=M1dtTw9UiQsBSSE/4dFGLbvRMle1kZ/thbvyIjvGYE2OTBrJMDM+UT662iyR7Du4mXqeVL
	e2uz62FwHu1iajw4NN1YjcsSVZc/on2ZRdPkdphw6iLHtdWsFG89Nq5ZQY6eocWufiorzE
	EjMKqZ/n8sbOZLK6mXkeyuP42D1hivI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758234390; a=rsa-sha256;
	cv=none;
	b=ee/WXL8N8qw86BZfR8Az1SXwzmfOlgWPdk/2x2WZ3Vb+WHIxVVH7noMHWaZzIYTEDfBiUH
	DlZcACLmQWkVmQl6AqgBA91UoAEcBCyldyznpweXxbQlv9qTsjcA/5AohcCLOSvPQtkgMa
	xjHvQE/fO4nGw/I9AgnKWvYS4MSmTmA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dGntTpOC;
	spf=pass (imf29.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7761a8a1dbcso1458938b3a.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758234389; x=1758839189; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tZ1awk6SoUQIOVQF3O5Wg32Zi3pcSNXGfmdT++muNE=;
        b=dGntTpOC/kBYHy38Pt/zEFRsTPiUiD4hgyjFTyamK0OXjlNkaJDnpIMoPe9hrgRBcO
         /NiRfEHzye+wn6HH/TMM4kOt/tBIExL5YIKgdlZC9kBavcOuLRiwv9csrloRlmHlFMS+
         dLC9Ym8IWtaWchvviDjfFigYXD5vnatcJugqH/t0z5itQEPfFv4PM4JpEDGeGavclaSR
         5YsdFgpzT7Ucnnn40dSU8Za11tbynwfBsNoOhirZtFb7/28BqTqgwr1SA0s3v/iGkMqw
         ycNlIxAn1/4AGcnwUCyeJyTA/a6944fyaLYQk2rgHyg9sI6XGx1eGU2p09JC9XU99nVa
         c0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758234389; x=1758839189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7tZ1awk6SoUQIOVQF3O5Wg32Zi3pcSNXGfmdT++muNE=;
        b=mZVulfdE7oeI5ih5zi4iVBjQ/RkSaGHKrOR1D4/B59az8/D8cxdB5vnFux7wo5V43/
         BBbJsG5i1kz9b7+exhcmmvjygDE0gAjUdTGQu5g8qgveKt/FSaUU1g3XchZhAAQ41ShF
         5Ux+VHIxQql0SjkQkAOk64IPfY7qcnPX4XozfRFJPN9Bl3PH9a5f5EE5NFQu8XVsdPPj
         KsQQTb6ut5I2waXCNXQE2TDOhCqQkGpZfsehPfKEY8H+w/v8ka0JJkKpHJei5uV5iMTH
         1qCFm+K6xZsLC78o34SSzMjytWcToaAhoH/Zq+Attu75uF1nNQjVAASwaXHoHKdCyvHs
         rOGg==
X-Forwarded-Encrypted: i=1; AJvYcCWVJietzAd4ZsA08OWSFmB0TdGF3+H/LstLB7j0+CywWapUFOSlMErPZ+fLms/WdZBPHcq1B3R10w==@kvack.org
X-Gm-Message-State: AOJu0YzGR0xxTjubIhaR5Py+ZRij+EFyhoUMl2LpjdZHcFO5duH3MYW8
	HLaVO0xf/2PLCiaA3TWM+NFqsTpMmfRaKP5LqyTTEyy2bpqGhPeWneuG
X-Gm-Gg: ASbGncu1sbHB0CvylfAJ7JDIVp6MxcxliiNAnqT/FwilXNK0JGVqFc3+NRCqu4lHvUA
	F0kHvAUEPPIdsuPXrqpR+bM2X4RddQWfcG9GhKklKHIZzG7AvOd6yX2eYt5Xrft6NhSlWPEgBGs
	V0iJBn/W81G5rniytP5P9rpQhBg/E2HmOxoE6Z0tKcK5w1V0Sw7BGi58yWENeZXFuzCOm1kcAhk
	ligmF7rzo/LpucK92RrbdgpTmdJY6+lhBIE9AEg0brN1m4MuYnhAUHBJ7abKdB9ZoN9taZprpyH
	sW3EXjUgvxY23nvAw14TQs+R29pdrQtngesXlEr0O+17SsXaJ+QxnNNwnBs3DaiyyuYrUTm5cWb
	TuIuzTD7eMBspwIDkvHhNLFBZ9dzlL4Wx4B38HueeKXKEtP4=
X-Google-Smtp-Source: AGHT+IEWFbh2aOOMKw7ejiTJRJw8lOcG5jy15DL2xMCbkrQw2DZczjpxb6lHP6fuCOtxt7Ts0n9cBA==
X-Received: by 2002:a05:6a00:1250:b0:77d:6a00:1cd1 with SMTP id d2e1a72fcca58-77e4d031e97mr1237987b3a.12.1758234389331;
        Thu, 18 Sep 2025 15:26:29 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:c5c1:2e33:6cf2:beed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5fe6de75sm407542b3a.19.2025.09.18.15.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:26:28 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch 5/7] x86: Introduce arch_cpu_physical_id() to obtain physical CPU ID
Date: Thu, 18 Sep 2025 15:26:04 -0700
Message-Id: <20250918222607.186488-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: usmske7co8zotiwhjs4atw5aqkm11ega
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F667120008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758234390-845882
X-HE-Meta: U2FsdGVkX19WB6riTuZusUTf6NzXHYhQl4AtaNggif9nRhcqZvxN329N+fuzy6e+G+pY6ddQz/1E/xCmi3gRdJf4kn4utQLaL+32bmf/iSDEistU8YC1MMsyAt8LtPbc3Z2tWmEL/Mo5NM7CQbCsA6MnQQXN+O05aDyvVu/o9lMrIHd4Hgu0gbIa0FR/PyaBBhTYOFhttJ5eKT6Ts2kZ5N2C1151UCkRVxmAt9QM9pqngluvycrLvj8ZWnsdiZ+mpM0CWPPNIUS48yptcU/HKZBq3pThvkpjfV7JUJlhOTN1SLh+MrcTd81kruXQp3GqBBr2dS5QQeL6fwQLi3jUBmeWvVW48YD2Htk8pCRxN6Atu37TfmKW9rkZ5R5tJvEyb71H+j5idRMY/SNhxc0nZzMvpZfT56vSYHJiOKf+kg/6AF/NDdJTUpdHGivlEPJqBiAt+Y8K+kDAnaQ5yTZG2XVO2im6IvJi3Z7MH+Vz8TIQYZf9xmL62h2Ak6inwTtJqLTcu2wmspUL3Tc81Jx4J41oLzQvitvMWQFSx6s4ir62sOsovrfdmWFobauLKxsEkKbBdNj2WlMeLs+Icdt5MfB8igmQiCqw0mPPlAruHL5q7UQxuX88kYCgLGwRXVwO5m3DxEZe8+dh5mYp7N8Xv7ihm0VR0TYUbUT2emHYmlL838pi5tcKqv0Kd3CTDJfSnM1ZgNBeXVY1gjJdeHNcYUrhmahBjnceU7R0qcgy5g4aSD4febSY5Z4PsIutQqCh6emr5ABI+GzlioLmL+/SPspXo+M2Ki0+x1tFsvhqDGTd0oDgKlEIq4FN9RRKHKfnR4/jez8SZwy1N4gDD1bQks5lqXn8bEs958h+jKjodvHWERQjuyLVO/ktrQHjRtg00dwnzkFeHzDY1xhKuEkAEpFb6NVVhtJ2lYnG/owpw8VG1bwSCa/0NSG6ptx0YmhPykUCQIsCrVELC4kl98A
 /OiOUGe7
 nRJZuSFt/tDZxGq+UPjtKlojxDsqLtQNYkIgpclxpwZWh86h4TF+DXVL6mU3lEMrsNZkEmuZMBPA1DpAnwMQ/9X1pCX5iPJ76jqxX5ySKGsnm0IY+SuGKytNVI7ZLgDbyajkrJk7+kAroqQ6dXLfDdoXSKF7neMl9x63btAjvzfH5w1O/O1taA4BjXQjOHztaStVIMlbyDpMNWuw133C9YoH1qzZdl+Tgm5Co0csc8uPJ3uPrkXWbAnZMnUfrqkd9wh5Nk5/DjJnxAVBiMJGMQ65NnLd7ZG+ZZAaax8Rq58oPotBq9S7aqqzIYHXNQx5dVzDRsoUxJeG9Tv8Ll7cFYKXYINsiBuWK/BtRvizw2Pb1vS8nRy/1TVipOn5ETOPaoaMYQrIWP6PbDcmJEDQH8XFEpHi61C1zG2YTSj8+uOCKIBUwCX57DyJUxUOcLj65cdjiQJTaoLQSaVIlfBZ8z2xOH+zPmStOiT17OzSb1YnHvglMH2mWM2cU9aMVABHqFR5TXvugonRKhpY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

The tranditional smp_processor_id() is a software-defined CPU ID which
is only unique within the same kernel. With Multikernel architecture, we
run multiple Linux kernels on different CPU's, hence the host kernel
needs a globally unique CPU ID to manage the CPU's. The physical CPU ID
is perfect for this case.

This API will be used to globally distinguish CPU's among different
multikernels.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/include/asm/smp.h | 6 ++++++
 arch/x86/kernel/smp.c      | 6 ++++++
 kernel/multikernel.c       | 9 +++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1a59fd0de759..378be65ceafa 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -40,6 +40,7 @@ struct smp_ops {
 
 	void (*send_call_func_ipi)(const struct cpumask *mask);
 	void (*send_call_func_single_ipi)(int cpu);
+	int (*cpu_physical_id)(int cpu);
 };
 
 /* Globals due to paravirt */
@@ -100,6 +101,11 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 	smp_ops.send_call_func_ipi(mask);
 }
 
+static inline int arch_cpu_physical_id(int cpu)
+{
+	return smp_ops.cpu_physical_id(cpu);
+}
+
 void cpu_disable_common(void);
 void native_smp_prepare_boot_cpu(void);
 void smp_prepare_cpus_common(void);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 3ee515e32383..face9f80e05c 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -289,6 +289,11 @@ static int __init nonmi_ipi_setup(char *str)
 
 __setup("nonmi_ipi", nonmi_ipi_setup);
 
+static int native_cpu_physical_id(int cpu)
+{
+	return cpu_physical_id(cpu);
+}
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
@@ -306,6 +311,7 @@ struct smp_ops smp_ops = {
 
 	.send_call_func_ipi	= native_send_call_func_ipi,
 	.send_call_func_single_ipi = native_send_call_func_single_ipi,
+	.cpu_physical_id	= native_cpu_physical_id,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
 
diff --git a/kernel/multikernel.c b/kernel/multikernel.c
index 74e2f84b7914..7f6f90485876 100644
--- a/kernel/multikernel.c
+++ b/kernel/multikernel.c
@@ -150,7 +150,7 @@ int multikernel_send_ipi_data(int cpu, void *data, size_t data_size, unsigned lo
 
 	/* Set header information */
 	target->data_size = data_size;
-	target->sender_cpu = smp_processor_id();
+	target->sender_cpu = arch_cpu_physical_id(smp_processor_id());
 	target->type = type;
 
 	/* Copy the actual data into the buffer */
@@ -175,6 +175,7 @@ static void multikernel_interrupt_handler(void)
 	struct mk_ipi_data *data;
 	struct mk_ipi_handler *handler;
 	int current_cpu = smp_processor_id();
+	int current_physical_id = arch_cpu_physical_id(current_cpu);
 
 	/* Ensure shared memory is initialized */
 	if (!mk_shared_mem) {
@@ -183,10 +184,10 @@ static void multikernel_interrupt_handler(void)
 	}
 
 	/* Get this CPU's data area from shared memory */
-	data = &mk_shared_mem->cpu_data[current_cpu];
+	data = &mk_shared_mem->cpu_data[current_physical_id];
 
-	pr_debug("Multikernel IPI received on CPU %d from CPU %d, type=%u\n",
-		 current_cpu, data->sender_cpu, data->type);
+	pr_info("Multikernel IPI received on CPU %d (physical id %d) from CPU %d type=%u\n",
+		 current_cpu, current_physical_id, data->sender_cpu, data->type);
 
     raw_spin_lock(&mk_handlers_lock);
     for (handler = mk_handlers; handler; handler = handler->next) {
-- 
2.34.1


