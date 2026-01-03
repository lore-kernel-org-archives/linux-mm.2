Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87378FC6176
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 08:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD4D6B0098; Sat,  3 Jan 2026 03:48:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90F76B0099; Sat,  3 Jan 2026 03:48:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D446B009B; Sat,  3 Jan 2026 03:48:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C93806B0098
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:48:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CCC01A01D4
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:48:10 +0000 (UTC)
X-FDA: 84290025540.18.BCBA676
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id AD81880007
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:48:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MBO+NQYf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767430088; a=rsa-sha256;
	cv=none;
	b=0oYk+TkIeDoHf+9rMW8AQHBCEpkJD0ucheiOm5/owwrcGADzS9ap4VI8jCkS6u78P2qlqm
	Bmy1/j9UdquCC3dLtSYDQwLkVnxS1Vv9+91X4lsrTHxidiOC/A/TJ7IrTFWCZfL/1nzTCV
	bFOboXThiTo81XF+l2GQUPLGDpdzx+o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MBO+NQYf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767430088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHUhniRWcOleZ/LWsZA4B498/r40yHnXuPYvUqkOFcY=;
	b=38xE3z5n+iUBPjojnRdEDLaDxVP3QamV26BUeXwJ2c5Ok3HAVAAHzap7B+3txiC9bX93I3
	bTHt9JMPIOVnGEED4F00sAoiJzAxh+mE2AKK2ShRqWZpNmcDJrEWsxOPSlcJyL85IsZja/
	e2vZJNgFadLUyiENIhzy6DQrMCR25uM=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-803474aaa8bso241958b3a.0
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 00:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767430087; x=1768034887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHUhniRWcOleZ/LWsZA4B498/r40yHnXuPYvUqkOFcY=;
        b=MBO+NQYfTTTXVrnJ9jAnWIlKWgQDdVsWQjU7d+kjLiMzDi7y1+tjQmmywhbRV3Tgqq
         ppvO910l+/GNeWB4YOA+lkCe55Nf/92SCC+ivjHz/Fo/Xnj18xKtN3NE3bPxuEnmNFX0
         IwNaU8HG0tN4NhGdUfmSpZAl5Hg26YXhXT9L6qR16CP0kPmqwipU2fqf7gKqSBPM/n67
         xiRno1UaN3NWieePGpJJNJQCaAkpYZUxMCMxd2Pvlk+5wDprc9Zq9sGEHANCaq5JAISD
         8ja6bTbidVAvgbstyJKFqhKBEBqSqoN5qKjYh1/N6LQS9q7bmyEisRJVo3izuMjJU+BF
         Ssdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767430087; x=1768034887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JHUhniRWcOleZ/LWsZA4B498/r40yHnXuPYvUqkOFcY=;
        b=M4ERKxLigny41sOkbUHRwqFPUS+KOR8kc60zJ80wcCL0tTrt4Wo8Q5kxE423YsTwQA
         bS3pKf1neg6u9dAZ/TXgWrr2DgOouGovhncFbyUPNwnsfkxxNkPolS6UCY8U5fXZqpSB
         Yv3IUdPLfxwFIMngKY83kXtNmfoBWk6z0NzfH2NaRFo7bt77CFsGe0LNtRgWxfq6KwPk
         r1UQq1ccMFeXG+fRmGEo8hH6Z4caW0Wq5fpqZSVDxbcez1NXxSeK9MFyfdQxiSJbu6Pd
         DLBlcXgwQ9kOVQXvz3FS/uxZzV9EHyEXZVIFo/d3FXiCkmru470N+fEZ4W6kKXkXGqOB
         pj+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWOk+2c2i3+OQQZUOU1+hHg+0I6sUaJLWY4W3TOk1q5NKTjml0Dk28LuLirbbVQOmS50mx+gCE7Tw==@kvack.org
X-Gm-Message-State: AOJu0YzDAjYv7JouXvVE09n8xJAgjhryn47KgZVvLZgLsDhmj2XqEkSY
	L2TR+aFqphVmZ+/RHHd5vhVa6qli7alT82ilA4qMiuf+Xa/0sZZ8pejN
X-Gm-Gg: AY/fxX5tlZiwgccQwQf7O3bKjBEDZR2iYEUQO+7XyQd/0uxK1ODSRBIe24AD+kRTfIs
	vx3IE2kvrr9lxaCZL3PwkiixNolrNTwJfSnKpTIkxYPGL/d8doub8IbT2+lLNORKeEc5dfX+uYg
	sZReG3T4lssKpLtMnUwpBuCmfxDzh/lObAyYysMjpUrG3e+qXwZdWkGD6AjaS24svv7nUgfObVX
	kc/u7bEChTvfbpHmS0dCOYvxKxsxc0QByrTdcafP790m7jPbSoKcEbzJcrx7TaioeFB6PdO2h9+
	znmJjwiekF6yhQIkV0HvWsuHOmcRXu0SseYRm5M1Wv2qKEJb9pONhYlAq0+vqGhjl5CpCm5NEIV
	RWNqeOLa/Si8t9X81ECM/rClOuQ1f7qPSA6bOPgqscgv9ppsBuIv/evEOJhKdNf3pVMjbXx2SwP
	3jKzy5mstL4AhRE+PupcxHcdcm1FEM+DTv/io=
X-Google-Smtp-Source: AGHT+IFoiqDv7u4QVwPAsnB9Ilz+AGYXHXN7Krwf9OXzvHcyBpVKkqOp/lFBq/KGwKuFExK695g6Ag==
X-Received: by 2002:a05:6a00:4895:b0:7e8:3fcb:9afc with SMTP id d2e1a72fcca58-8148ba1ab36mr1175712b3a.18.1767430087435;
        Sat, 03 Jan 2026 00:48:07 -0800 (PST)
Received: from jvle-ThinkPad-X1-Carbon-Gen-8.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e197983sm42704939b3a.33.2026.01.03.00.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 00:48:07 -0800 (PST)
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
Subject: [PATCH 4/5] arm/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
Date: Sat,  3 Jan 2026 16:42:42 +0800
Message-ID: <20260103084243.195125-5-ming.jvle@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260103084243.195125-1-ming.jvle@gmail.com>
References: <20260103084243.195125-1-ming.jvle@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD81880007
X-Stat-Signature: pref455uf7ifbmachj1p6aajdr8m6m15
X-Rspam-User: 
X-HE-Tag: 1767430088-125916
X-HE-Meta: U2FsdGVkX1/1I1sHTM0u3I0ZvV5wZZQZLYK/0LLEbwD7sSEC7i0oaHSBV1oCeZlpZTLw0GFLMBwrZ8cDWrz10eG2/3WB8vf9h9mWkwkkDAfc1/xcwEW549JspNw7nAp0bMTMQ6duPPvbc6jAWGF+rRWewrJQuLnViSRVM+iB6YQJE1iy+9yP/NAH8XQHQmgB9PqgAwXAMQwiNk3567fxy8YSFeWFoa0A4IWDYjlzP9rOpd04I6kuum0hZOMaVovsxITLrc4AvJ7yLrk+pn5CuWRwkfFxyp8i5xxmz5jnia+vpdHMISQQ9HGWng2wZIBGFK3+QWgEwkyY9jfwpKkBrcbLtkEO5kA2dZ064sVcFXeoFfrNr7Hsp6mWczSy4tAdMWV4qmOtS1+nb9bS/iygjQMlyv0UTPncZhPro7IvZsZ5GXoMxgNGDK+N/GeA+abB2UXaiU4ImfkJ4zlq/LJj2rO4syaKrxgEO0DDxc2aGTMfNn5j175k1+lizO13o2GXmcLZNq3zEwVFimPtBhQAfChVuC8dLEUG389ZMYjaR2thlJ2+98rxg0sWlol25qX7UDN6hDiwovt8ycuJvbH+3hnGIkjZleSJZx81wit3wbA6RU6tmYtoBgiPrYyZeoRtuQmi9CmB7MLVd0xpZfzMZP+giVzhdcWnVSftS1qjqnbUF6MayAcGjrD2E6NHrq+bYln779Y0ZTimG0+4W66GENT2gF9RbNkL+nVdmGLp3QF+KkCITIBTaHLogw3EQDA0YLjGXcmYLnt7px1Ak3CBWr0zyYDDXVdtHIBtdwAIcygm/trSK7nUieIALmIwSCGA0/JNdLcaZG1EPI/HXqyyFP063FucWIBJcxmSREPuPTPCRO3U+81ZrGk7NnlpIuaoLDfIslzbHGEHUCAy/AevzuEiVzK9ya3AjmUlu6qkC6yWU6jcQXEKJ3sGlCUHy16A94IuGo5luuhPFUn74aC
 yd2AMhUg
 MfyZon/sapM1Mayzigqqpdsr/25ADVgKxSuzpzvpT6ZUywwXkXRE7Ogq41Y2tPCabyByWNVARM8EkCuSNJh0dHfqLSNZWE3rwk9FxtjizehR4zVvEIf9VGUWX9PORbQG0Dy+gUn9ebhi5m7pmKy6FBeN6HP4zHEBTywn1cwlxoGo4LUZ9QV/C3ZkmqmC8BGucPotf6I17f7KPPttaL62UPPb3df7fJgAlp1x27kV+CXAgrrcpQOjQKoV1O7fpfPG/6JmU4i+RA6KlUEAWxF/1wO2NIcOILEwjXnKB0qDbVflzgZ3Wx/gJ3R9vcq2KoTdMvK8jigULJUMsuiLR5PIDcUef7fK0Y5Ciyb+G51Vc+tFQup8zIY3NyZadLxrkz4+BUhnjsZ2U7TEv7xRuMkWmoJDF3k9MzIoxzRM+7tPo6XEzQw5YrLZRUf/PGCqioKLI2Ti6aTXMi68ts8fnvV/J4RK9cLtd3a/+5Uyw0blPhTR0uz+6Jfz5aLcA1VbrV9m5ioZUPvgrJOU5R6gF9y4FFONUmck+mXGLqL5o36jJzGHG6rNnSLH2aX+TJA==
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
 arch/arm/probes/uprobes/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/probes/uprobes/core.c b/arch/arm/probes/uprobes/core.c
index 3d96fb41d624..0e1c6b9e7e54 100644
--- a/arch/arm/probes/uprobes/core.c
+++ b/arch/arm/probes/uprobes/core.c
@@ -113,7 +113,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 			   void *src, unsigned long len)
 {
-	void *xol_page_kaddr = kmap_atomic(page);
+	void *xol_page_kaddr = kmap_local_page(page);
 	void *dst = xol_page_kaddr + (vaddr & ~PAGE_MASK);
 
 	preempt_disable();
@@ -126,7 +126,7 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 
 	preempt_enable();
 
-	kunmap_atomic(xol_page_kaddr);
+	kunmap_local(xol_page_kaddr);
 }
 
 
-- 
2.43.0


