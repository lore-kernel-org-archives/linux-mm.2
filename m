Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FE5D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9BD6B008A; Thu, 27 Nov 2025 09:11:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B07C6B008C; Thu, 27 Nov 2025 09:11:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6CE6B0092; Thu, 27 Nov 2025 09:11:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB416B008A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:11:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC1B4138FB2
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:43 +0000 (UTC)
X-FDA: 84156575286.06.2DB3FBA
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id E7DAD180011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Xr/+YFMy";
	spf=pass (imf16.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u3WXNKq2AX75j2bmfv330sc+Ngjbx9cqOj8cPkF805A=;
	b=HDLtJyTuck60o2DTMkK8/aJtT/O5cAchr747BfIlycAmLeVuPiaM+AHGZQpQh36GTzwhXb
	g/1O7+lwKtpG9oozO7Ky8wtk8j0SZbZfiNQzMch7cxCKXtBnKfc3m1VxKU36/PwOgw01fv
	MKpTycQsN+piEkvOgXPv4Lwn3PsQKSQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Xr/+YFMy";
	spf=pass (imf16.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252701; a=rsa-sha256;
	cv=none;
	b=VK3ADPjfIpTorv1SueUvJMVCGCqTzuIZxZTEdFXoVNzWETEW6GXgpIT2kr4mMf7XdUh0Gu
	PC+OqTWLGCgo0iF6+LMIlh9OVDXKcQv23E1JC3cyUovsa/Eg81+Ok/OWcp3LKR+97Ua5Kh
	zOMZTtYVYDpZSh6rXuYuaifX+13R1u0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29568d93e87so9033455ad.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252700; x=1764857500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u3WXNKq2AX75j2bmfv330sc+Ngjbx9cqOj8cPkF805A=;
        b=Xr/+YFMyrfhzp9U+g5JYdgruJt9cRD3loFYcYu6BljJleXuNyg53+tu3nsELdm19Ob
         gSommIWz1KtulWQrJj/GyGCYHANOhnMksow1ZrP4GLVzkJ87lm9gufz4CiALWNcAazfn
         jLYDEZpnoK4JSLgxwjR9svQoUMOVmEO6WrmAAGFNmzOSbGLOopl5LpVvFxtdGlZukV+9
         J2EMDrwUOKjZWxdqz+hwhQnzr4O8iyjAyaCf4EjVeriNyuPESUpKZyABSyZb37pxvZWV
         M2lcUoIC0K7sY2h705Gaaqfr5h/zZI3nFEFdBhC4NLfgZKE2MCOrq22BSz6tyHEL238L
         SKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252700; x=1764857500;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3WXNKq2AX75j2bmfv330sc+Ngjbx9cqOj8cPkF805A=;
        b=Do2fsmRKvUj2RQrK9pQks/gdHPwHTdAIS3hCtCgmkf7kEHAJdeN2BfJTyPh46dShSs
         IjPG9oBALy6La5KkaTLgjjU+3Sd2BqHN/eTJ2YrzeP4SuNk5tQslODPd3MFhiQz+PkkD
         SEvaSAEVOajsV4HI79ExsGG39o5a/0KA+lJmA+xnBOzaHvqmbFSQqGt7GnXv12GTCcr9
         lzlZJ/rQXprZj3d9kPOKFL145ShBiRkCJ8IvIcYuhhzZ4ixH4NAJeWWX+Om+pT4GJgGV
         Gbb3lAIf0n2YgdxOOWcEdu7TehvKb9O7CyopVntyS2EAkj+u7qhVJVHg0fW1kht158+k
         BltA==
X-Forwarded-Encrypted: i=1; AJvYcCXabKkGQHD94jTWkwTYL5yuRqmZQx4l2+IqCuWz6AlIxtyOpTuCjfaBxYym+BGn2Z00vgQMc/KavQ==@kvack.org
X-Gm-Message-State: AOJu0YxcpBvO4/9TmXqj8E09vbS8qxAcChlsjmDDfhsPJ8xbgXsJ98gE
	E9LISmM9WPH7J+xKgyU6TV+jD6T0N1ctogz/23u/qEHca7cx6Jdmn695KMknLSiZ7ySGy/BNmnU
	Q879AOCtDqw==
X-Gm-Gg: ASbGnct5wOgSjMgTsK5RRuBpB/oqUbhf+qsK53dd8wLu14J7hmB57CZNy3Glx1qq8d2
	QhZisciF/MB9z5+qsn55NB9Zal5zijxgESw0t58pmSDZH1HGyaucjpxxdrEJghA2kfVOdBQEggi
	lcg4RMLNCsrE/RavhZLMwET0w7PQ5oWWxyZ2WgbTinSHC8H0Hn+08nItvUonJne5J6znYTlf8LV
	MH6n85NmcS8YoiVgoPcP5w6feLzJjwc7njHYDI0rrIU5uosZSxWCR6Zy+jdo1nYD8mSAf7yBzMr
	pDgwQTfgYLWABiRvbqzjNEPUABc4+cuI4zHkMq36Zn634D4ea4syOrA+gFEWcFEX0qY+3NyR3PN
	BxUYmLOO1uX08nCBiGo1d7uG4F2U866Xa6PYH4fLd9/xffWt04SUyXG7j/QQ/tTyvuNmxmbB3J3
	fB4w0m81AKvDP9wun4Gx0f8QQEwUzRpUZsthRYNeRizGkbEHRgLm+zntbkDXxgYouW9tcov9XXm
	aPfSae7l+PB
X-Google-Smtp-Source: AGHT+IGqqZbiAaSC9ZX+pYvJ1IbIc0rETHK1OBZOJFFlIrrfxJbsAOd/0yhH41xHJLHj1PsrjPP9Tw==
X-Received: by 2002:a17:90b:54cd:b0:32e:3552:8c79 with SMTP id 98e67ed59e1d1-3475ed6a4f9mr10948253a91.29.1764252699207;
        Thu, 27 Nov 2025 06:11:39 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.11.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:11:38 -0800 (PST)
From: Xu Lu <luxu.kernel@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	apatel@ventanamicro.com,
	guoren@kernel.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [RFC PATCH v2 0/9] riscv: mm: Introduce lazy tlb flush
Date: Thu, 27 Nov 2025 22:11:08 +0800
Message-ID: <20251127141117.87420-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7DAD180011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dgzcyfdejibkibcm1trqczzyuohc5wc4
X-HE-Tag: 1764252700-534056
X-HE-Meta: U2FsdGVkX19fy+DgQ36XVLC4cy54xIzWXyH/GRAeuqUErYOLzlrIQ4w4t8pA1BUkiWOSwnL80zpPBNEHRPjsOTrHtk5YL/hjBL7Ihimc95SJzUbF2ow6TJodcznxnGNW8Ec3ts6SakTnKl/WIwqiUeTU8Fw530dy7rFVg4+zFiJ7iGQnwWVakChXG27EyTDUSYcqBsBeoGHV+T/pHnWsOzSxboH/SjoG6+g3iCIZE6JhRpaH1o3u7Nzle+ZS4Z9YCVxefuDCqgZslpRWKvE6eqojgCzZOvT0mZePPqEfRZ/qMzN0mBaSCmWYGhdTBRJp7NzbkZ7Hh56MNjF47PnVtR/P74/3E9e+WPEoE6A1+ZR+ifYWW5q0NaEab9EelM4KYC5iOKFwrINWQY0tQ0LNqp0pRYLitCGEg0brrmkLofqJB1rm9EFmz7SEwPEjk1VsRhPkvoAI4jw4ln3oEdXfiksTrHbuCdtw9FxfvIabUUsRIznW46+y8qOWYsR9CDKTlCWbehXBlO69s2vR/Wg5qLg6BvWgxLLhbUNcQ8225rYUEiZdU/2YqabQDggUmdux2F3qS/fXstI8acIDZOwubUqMpScD88vVtZ4hYeVkGvhbf2eaQ7p9Hw0xL6S623V7Cq4GAdU5U0R7j48Ct7AtD+BY+bhg6DPOApP5363i+oK8vTGZAHbQmgvTl6BWsxlCRwQ3OTBC5prkuUa1gXbemZpEY9+YrHahy6FnqPjvXO70hJbqdd0zuqOZiZ7BJmku4KyYmobiaI8e7QZoTAMoanq36ad8iusgRcfiWFrRVWQBXUCVdKT40iwIxdQC+9/676MJ8TEdSOxJQnrl1Sd30OM3ua4hhZNd4Nlywd1Zc247leJ9/Hrvw0KMkHY/JIKg2OSt0YTPsrl4A+wfB4Uc2NWqWJLilL23J7Is867tnlTyW+iqHTFyoHl757/EoZ5znePfo4MQ2S0Y25zxy6J
 z4a0TfBg
 o89K6yzDbflpgmBLiaKsaByxZN6gA4hfSC/J4SHykYGzdCIlCsEV3RFZbHi0NpoEHG6UgkzcGVkzdcb7+z9tP/Kv4oSzlpWQNa+6q/1P6xCojvhYeXKMP63kkXeOyL8Fb/gda9JRjlIP9GnWNn3V2JHrN1TVDwaaquMhwD+J/GcbIRN260xRoTasqmtE6R+UNbAcroXsFoay2Q1uzjVfGSDAYLA1NFO7bcG2BB4CME5JXqXzB0tBcFKbEUll6youtYFcATxunuWiTkWbGZm8nsmBEKzWzSUV8PZb/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces a lazy tlb flush mechanism for riscv. This
mechanism is based on two insights:

1) Since each CPU has limited TLB entries, there exist limited active
ASIDs in each CPU's TLB at the same time. When a mm has not been used
for enough long time (or, after enough switch_mm times), we can assume
its TLB entries are all evicted out. Then we can clear current CPU in
its mm_cpumask so that next time when the memory mapping of this mm is
modified, no IPI will be sent to current CPU.

2) When memory mapping of a mm is modified, instead of sending IPI to
all CPUs recorded in its mm_cpumask, we check whether each target CPU
is using this mm right now. If not, we just store the TLB Flush
information in target CPU's percpu buffer, avoiding the IPI. Next time
when the target CPU switch_mm to this mm, it can check the percpu buffer
and perform TLB Flush itself, without IPI involvement either.

Using this mechanism, we significantly reduced the number of IPI due to
TLB Flush:

* ltp - mmapstress01
Before: ~108k
After: ~17k

* ltp - hackbench
Before: ~385k
After: ~2k

Thanks Guo Ren for his advice on memory access latency test via lmbench.
We are unable to test it now due to lack of real machines. We will
supply this test and adjust our mechanism according to it as soon as
possible.

Xu Lu (9):
  riscv: Introduce RISCV_LAZY_TLB_FLUSH config
  riscv: mm: Apply a threshold to the number of active ASIDs on each CPU
  riscv: mm: Grab mm_count to avoid mm getting released
  fork: Add arch override for do_shoot_lazy_tlb()
  riscv: mm: Introduce arch_do_shoot_lazy_tlb
  riscv: mm: Introduce percpu TLB Flush queue
  riscv: mm: Defer the TLB Flush to switch_mm
  riscv: mm: Clear mm_cpumask during local_flush_tlb_all_asid()
  riscv: mm: Clear mm_cpumask during local_flush_tlb_all()

 arch/riscv/Kconfig                   |  12 ++
 arch/riscv/include/asm/mmu.h         |   4 +
 arch/riscv/include/asm/mmu_context.h |   5 +
 arch/riscv/include/asm/tlbflush.h    |  63 ++++++
 arch/riscv/mm/context.c              |  24 ++-
 arch/riscv/mm/tlbflush.c             | 302 +++++++++++++++++++++++++--
 kernel/fork.c                        |   6 +-
 7 files changed, 394 insertions(+), 22 deletions(-)

-- 
2.20.1


