Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCA1D43344
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 20:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC42A6B0005; Thu, 11 Dec 2025 15:24:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9AD26B0006; Thu, 11 Dec 2025 15:24:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A086B0007; Thu, 11 Dec 2025 15:24:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B61BA6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:24:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40DC9160310
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:24:41 +0000 (UTC)
X-FDA: 84208318362.11.EB5E82B
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F29B1C001A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:24:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhUPYhGH;
	spf=pass (imf20.hostedemail.com: domain of yx.0xffff@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=yx.0xffff@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765484679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vS04UpnMf1M3nTFS2HrhXej7VoyiDsU8crRoKlTWiC4=;
	b=up3+QRDXGP0PAO1dTBCKcZ/5wyx4IBA7q4841APtsQi+OwDZeIp6BUrWtNUhuiJYkZFA57
	LzmeOHud5ZoLa+MMdRyC6KN3NARlv8WKxyL8dCnvALwTTc2WVbyGHltkF5AhLKLXVJ6p4w
	nx5sN0tzoX0gZ2JXsz+BBYwUzi2MfPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765484679; a=rsa-sha256;
	cv=none;
	b=GW+HKx4fWjRuyCsG+lheDn8+vYc1XIg6GEb7SU9zS22vUGkGuMT0MSmHsO9IGI/oSRoyeh
	bnVIyWzvWclvNJ9f503AvFnHH3wXNpR97dlSK8cX50U2l0kajNGdP0Ts/lo6taOH+r1RSD
	R8Gk8jDH/B3C6eFwdIyL6tOKcD5yzE8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhUPYhGH;
	spf=pass (imf20.hostedemail.com: domain of yx.0xffff@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=yx.0xffff@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29845b06dd2so5910805ad.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765484678; x=1766089478; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vS04UpnMf1M3nTFS2HrhXej7VoyiDsU8crRoKlTWiC4=;
        b=nhUPYhGHYE/wi57iBcycKL+xywtnmRH+7PTyLCkXp5fzZMPGheXH/YO7UPb0ueQc4X
         qHPCZ3AyMTfuhEu4eyMNLFUY+Z4/gbuyTtNDunOo+58eTsEe4bHvBLFz8v1oCSfmptBa
         FgimTVQXzv63LsgAqedd9fYtesWwQjGe08lN+5PzKmdsepDGlHvjnhCDIg22icsNg5tr
         RaNOym7EE62NChIL5F1VQTXYQQP2pMzV5ZgBCWjrN9QAzhTjfsAEz551sofnjztI7C4z
         wvI49iELKY1woUPfqfWzMxEhGSOMbMMuAiLM5QyeSfM1pe9f5NbSWXyHRoDf2yG879hm
         kl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765484678; x=1766089478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vS04UpnMf1M3nTFS2HrhXej7VoyiDsU8crRoKlTWiC4=;
        b=q49u7o54yotvcYNnSeBaRGwL/roxVrbjnDCyZR6qd1BH0ZcLajVeqJle84LHhk78nE
         tlWqH+89wMMYKBMgzHFgL0j9eN/VMgO05gGWAEV0OIccvV/ZntGs6mPez5huE5BWElzn
         l3JXhEbMZnOdguGhaFA4kR1UkMxKGsUS0vnquy6WhJgA8PjBem5IJt+mNweUqUWrbZkc
         smglwT+V6cAmfmtRYHgSRCFkU+KiM5y176MnFs4CS7sFSnI5T2rrk9WCFfIaTABn+tLB
         Ycd3rA8zxdpWtbwRNBvi1pOO2g63QAZadHGPKT8t6LzNLDOfK/cCWyHn/jeD0InIzxYi
         OpQw==
X-Gm-Message-State: AOJu0YzTl7P1TDp0eWEYiUTsMTJIepYu1vYx5SbV7feuT75DFA95qqrG
	GXdZAfxeXsqxh9l/pYDtXT1VXbzGlJU/KgFCV+xoKe9DYqWD9nkFV4o3
X-Gm-Gg: AY/fxX5+l0NgCCk6EXfv6dwnRwMbs6IAgZOlO7UY70ThF5Fq31lTa9gnI1Nns2cdTDo
	jDDQTwLORbvCSILbd5c0S6MMXxwGy6KN5UBuDWoTRaT29xmZoenZL3ovXfTRQqZGBGQp+3sxR9B
	dZkOunUFMs17gEt8cQtRg4EdKPg4nLOcfmu0tvxdn3+mvr+JW3jTrEppz+GUwuGdBcNgHuYXNg1
	GdtCuqLURlANE6vueUPXg3v2zMSD9GTQKusaWVWAGzwKn+S8+tjkbNV3WGz/1t2M+sTmnu9fiya
	7qAuRYH07+RbhLPTbVCLzxb57RnCLJZuTpOSqxKpULcz7PRSWZ2b8pHpPrPoN4kuMB+TQ3kNwsh
	doaI1bfEe/y21HuwwClsddQAPHE/k7Lp7qH3P3g0AtBTjNV+bDkzauugTPOo17eDcvdB6szxihv
	Mk3HlI8sA=
X-Google-Smtp-Source: AGHT+IHjcM3lcap3FKNCXDUPHth1hx6E2j82st7BoSmYCTHB5B3f+XK7DsR/nSUl1x4LaQWzBb7btA==
X-Received: by 2002:a17:903:b87:b0:298:52a9:31d4 with SMTP id d9443c01a7336-29ec27edb12mr96231595ad.54.1765484678170;
        Thu, 11 Dec 2025 12:24:38 -0800 (PST)
Received: from localhost ([125.121.98.163])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b37422sm33149375ad.15.2025.12.11.12.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 12:24:37 -0800 (PST)
From: Yang Xin <yx.0xffff@gmail.com>
X-Google-Original-From: Yang Xin <redleaf@linux.alibaba.com>
To: akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yang Xin <redleaf@linux.alibaba.com>
Subject: [PATCH] mm/oom_kill: add sysctl_oom_dump_stack to control kernel stack dumping on OOM
Date: Fri, 12 Dec 2025 04:24:33 +0800
Message-Id: <20251211202433.4495-1-redleaf@linux.alibaba.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oe335boqrmy3kgm5useecugdoi611jfx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F29B1C001A
X-Rspam-User: 
X-HE-Tag: 1765484679-927656
X-HE-Meta: U2FsdGVkX18Uqy4zUGV6edWiCChAZj4rOhzDH7ETiJkyKGTEwgUlx0xfPeWfVFEyaAxKY8H9BK7MiS7fUYkJbhpogq/UFxnHZsF9l8NcdWU4gyn+UqBbZYoorJzRzNn7scZhUeOVqJjZ6ajSp7/Zr/MMd7WHRfzwi8bzlJ7gMTHIiwtNpVnbCoFlk+r7X6NgUdWepW3ZhWz9z170z3SuDnABPyFmWepAZCDOElIVLHWtK2+lScJCKSumMa9rE91BF1muOqL+XZq35lLp4S/4s5zCqJEpTGQFL01ZQG0zu+s2IGuN6nqnZHl06oXrLJt4VmSFemJ6zsJV4FH8YUx6K/zLTj1XV1aUWDmh2W+J/fRTFMzT7LjyjMtb6vmGtat5vFM4DwWFQbEGzHqxDN8/q5t+pjEE6/KQaKLvmuRPwuhp+sxh9SBc1X+hioEtyucCOuwB691moaZ/ObsSbVxWsiVoUE07SLyRuYnULgOZ2+xpfY3i1Y9zcsxl8FOPad42Ji4HkSZI5e5a5DYPcUPPkl4acrGBqxpycOaOF3n57CWNYCobY14dfxf3+QThQy4uCZNnvNb+LmyvHlrWMltWnPJBty0o9d4JYnL0MHhW1FJaOnB8L2QYBgcDWyCy55X/IyOfJHleQNWFJHEACUOWTiQQN4r2u3oVU7LJRCH2FM0WoV1gDXHUmyiww3s7ED6Yn893dp1ty7H+HBqJOJGF/NzB2RNITG+Bfwz7RPDi5UtxNOS3P4kBLBRHmxvrz1o/8Y15wOnW5XM2R9i868/PCnWGzHv6VclPl1Uwxcvjs2tc8OdM2qag6Hg/DVdJZ0J7ZOTpVz2n0ysNycdQv7oSd8dHpUVP2ISyWFJvjpXEaukaRbSp3Yz2vMSePPf9qNGeGaO7nmP67W3meIDHvi4Q+Fli44qHhl3OkF//LgbW9Czhg704qcZgJbEjTaeZwUK5PPgHzI+at4/g5zAg7vS
 PU5qD8vF
 jvfI06FvVwH5BRgZzgCPhz2mBPedrHMqR4fVxZjYUNPUibSkpEp1YOryM5MsrKns1z+ZA5yVqN4r9SlVRCCiT3ZflSnwM+QwAsreCZ47MTHKLg0bsKCbD5ckxL/qpUFppgRH3/3Ykx2FEOnxTSX/RuOOVksPU53lS8i1zEQLrK2T4YfcJBGbL/TdqS+FAubmHfOUwjVehoLfXbvVJNOvzGDMvn/4fibOCJbrokdMQ04w2twedgNAXQRQzupPsFAnnA2McZXv2Z0PPXhID4OERafQoPR4GiQ9zNAqg41Bka1Cpzh8Uq+PypvVQm1Y0mctF9APTTGAlKFbcJZip18IfEY97oCA0r1TyRJLKujYv3ySLDDosJxSJ7TjQXJHXXN0KCMFGGoOStr1ZWjvr7hLkFRkIGiPE4T3j1Md5vksjLFZnEVsrbttVlDdlS0BR65Vbg8kLaTdANM7FIrtFXGjH6EcXUlWlimrTR6IVcqoKgOEcysxaoGcYELHQN9mXXWvrqvsNMz/vlu5KlVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

    Most OOM kills triggered by user-space processes produce kernel stack
    traces that are not helpful for diagnosing the root cause. These traces
    usually just show the page fault handler or system call entry.

    Furthermore, dump_stack() can be expensive. It often runs with
    interrupts disabled or holds the console lock for a long time,
    potentially causing system latencies and preventing the system from
    responding to other events.

    This patch adds a new sysctl vm.oom_dump_stack to control this
    behavior. Writing '0' to /proc/sys/vm/oom_dump_stack suppresses the
    kernel stack dump during OOM kills, while '1' (the default) preserves
    the existing behavior.

Signed-off-by: Yang Xin <redleaf@linux.alibaba.com>
---
 mm/oom_kill.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5eb11fbba704..a51dbd2e6912 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -56,6 +56,7 @@
 static int sysctl_panic_on_oom;
 static int sysctl_oom_kill_allocating_task;
 static int sysctl_oom_dump_tasks = 1;
+static int sysctl_oom_dump_stack = 1;
 
 /*
  * Serializes oom killer invocations (out_of_memory()) from all contexts to
@@ -464,7 +465,9 @@ static void dump_header(struct oom_control *oc)
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
 		pr_warn("COMPACTION is disabled!!!\n");
 
-	dump_stack();
+	if (sysctl_oom_dump_stack)
+		dump_stack();
+
 	if (is_memcg_oom(oc))
 		mem_cgroup_print_oom_meminfo(oc->memcg);
 	else {
@@ -736,6 +739,13 @@ static const struct ctl_table vm_oom_kill_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+                .procname       = "oom_dump_stack",
+                .data           = &sysctl_oom_dump_stack,
+                .maxlen         = sizeof(sysctl_oom_dump_stack),
+                .mode           = 0644,
+                .proc_handler   = proc_dointvec,
+        },
 };
 #endif
 
-- 
2.30.2


