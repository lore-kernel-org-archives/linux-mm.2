Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2571AC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2056E6B007B; Tue, 21 Jul 2026 04:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DDF36B0092; Tue, 21 Jul 2026 04:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2876B0093; Tue, 21 Jul 2026 04:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE4506B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64F188040F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:07 +0000 (UTC)
X-FDA: 85012083534.17.EEABB60
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf09.hostedemail.com (Postfix) with ESMTP id A9E4D14000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DfcVeem5;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r5CS7SV39qqjCqco+74BzMJY0RngzF2mSdulT8Fpkg=;
	b=Y3c8P3vv0qTo+V5wCpmkv/qIGs0609rynZb+FdkEttyKqgSB5QDyUdWTFwFRCOMLHoBg+c
	cyd2uAZSNkz1GatsLtVS7Ilg0k1N/gS722MUEKtdizRpNQS/BugKGEViZNVqzHY6dhkuls
	eU324sxycMV55ngiVWTLzA3RjrqrlVQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DfcVeem5;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621945;
	b=iIpFCJKEPxrS+pHpNKq/eE8kLTdAxOOTZIOqPOIYEccxkd4qYEoKxl6qorai1x5UTX7IEu
	NcMexsAacfbNIUbtE9IuqWBG83ffUapSUOw5n+kAaIF01eOMo7kNGaapaO8BtoSMnhdNbl
	SCIJVz12usWHspjLeRRkN8l979FCCls=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0r5CS7SV39qqjCqco+74BzMJY0RngzF2mSdulT8Fpkg=;
	b=DfcVeem5+MnKlRuGOQh0Z6ny7kYUzfefpf5ZOBU3CfGlCJZ0AxstCUsHQZJbV73yA05ZICib/
	ISf0PPuy0M1l7OXYVL7FIyLpyHEulh1lFtRuB6y/pMtnmf6QBA5viSVHGEO24gQGsOPZjP74QQe
	XQ0ewthC8PLuN6j6lIJSpss=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h495s57ZGzmV91;
	Tue, 21 Jul 2026 16:09:37 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id E67F74057C;
	Tue, 21 Jul 2026 16:18:59 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:18:58 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <mark.rutland@arm.com>,
	<linusw@kernel.org>, <ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>,
	<yeoreum.yun@arm.com>, <anshuman.khandual@arm.com>, <james.morse@arm.com>,
	<tglx@kernel.org>, <broonie@kernel.org>, <pengcan@kylinos.cn>,
	<ryan.roberts@arm.com>, <liqiang01@kylinos.cn>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v17 02/15] arm64: ptrace: Rework audit_syscall_entry()
Date: Tue, 21 Jul 2026 16:18:45 +0800
Message-ID: <20260721081858.1169276-3-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A9E4D14000E
X-Stat-Signature: 5xd6dahm78unnk5wphkcscyiopi7u94b
X-HE-Tag: 1784621943-859059
X-HE-Meta: U2FsdGVkX18pmZluhXjMItTGLUUCvN2yHca6SAcZGX7OvaHOiNcT9papr7Nirc6zy9G+jgBBx0+/vhCM5z4wKuIQr/3HSVR7DV3UTmTCiOgniLIjWUW9Wkca50NI2YCKH66XBbXaX/HcOUb0TEMPMX5L4W3a8/Fpd4tIQMiLdoRgauLMUAwqoIMVlUZT4K1yDz1qiD72ywYEUD+hP7Q1nWVnFbrd4ts2OAZ3So0vRGSAOA9u5V4xImPupPqh7W1JQfP/WosECZPOqkbtVXOjEyzkylYOF1JJhy89hr/z0Lf7QVM1g6tpNS7BPhgRsj/d7nKw7N7Q/StsbBvZ2l4SnZpsPlkxf3qGCkDUmgX+7KD4gMfPwr/0jguZDVSAmpq6KlVq1Q03xh2iLFtWzBgZDXdYGPNxQ/sbsNB3QdWWo3h+m+O8POV1zBoi9optPuwKJdDHWjnsY+9C7qlWZlFqYp8MfsSpPR7X7UjxJjZNHBKZLHTFbbJyGHDNRZB/1JXji1/DdzVgC55tMYVlAiANuDU0dXDgwTU3942+1jMD6t03gG2EXRI1yzCdnnko4nuAu1/bSS6O9dZtNNEDhoyCzb/WKJAsi0OLAwQu9eJgPWdoTYfitgm34JZaAmn4Y5bETlGY1++h+T2qMBHzmo6D2uFA3MK5t/WPTo4Rur5576oJ3FB+JWMZSjjp9SwhtemMUgI0BAdKE3nIIceZYI4kh2c/zMdcigchmPHuyQMbI88mcfxB+9UPJCUSVe0tx0w6knK8Y3zq9QEYmMdmOKHinHagY8wXjrcma2jcxv1i8K9m3rt5yK9r1siow9eMkXew3Kt/odAzOFRgyqjvbxOe4TuHWDUcH+rxauwqcEq4d4STbydgBLDonSwx+2S1xjjZMFTNB1Y5Xb4RacEn6HOk7M33I7fNDrfS3BUP85OJ2oVP3kpl+bKQxLI2BMzdf1pwM1u859zXHzIXpfwvqVj
 i0OGNhxO
 Q7fr080IEXETgBhLd4MmlbowWVwPSKV8NTludTe9zy4DjKF92pdqetssQhMTY6X/R9ZCs++hMkxgzjrmPaz1hUEQ6h5osix9IxmBxSBHK73KLWtsJUVKhh0yoxZXa4jZuW4dW+o9mwNU9l7F7j4WmeIGHAdFMCZ7LSr0gdrPC9mVXp5kOMFj/ZmYQyxEFtU0fUdemnSdjBu4CUPGtx3O6f9tZFPdYGYWb7ema+uvrNLvvOob4I4oNYTtTwN6hTH2eHg59WL5H9aEm5U1SGpESyRzrA/q74wmIDDYB8ewgyZ3GXggXC48oKVCcufkAA9UKj2eLP/Y1mnp3jYGWw7/16I5XGGT8lYYaw1ocRfi8RuzRI1GZh/QilESYVFBFU/9o4oHSbuNVa3C07vq9LeSQzkACXviYNzp97I/cuCa9OtkhntM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract syscall_enter_audit() helper and switch to generic helpers to
get syscall number and syscall arguments, matching the generic entry
implementation.

The new code:
- Checks audit_context() first to avoid unnecessary work when audit
  is not active.
- Use syscall_get_arguments() helper instead of directly accessing
  regs fields.
- Use syscall_get_nr() helper to get syscall number instead of directly
  accessing regs->syscallno.
- Now exactly equivalent to generic entry's syscall_enter_audit().

This is a preparation step for converting arm64 to the generic entry
infrastructure. No functional changes intended.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 4e9c71d477a5..643e63a65734 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2458,6 +2458,17 @@ static void report_syscall_exit(struct pt_regs *regs)
 	}
 }
 
+#ifdef CONFIG_AUDITSYSCALL
+static inline void syscall_enter_audit(struct pt_regs *regs)
+{
+	long syscall = syscall_get_nr(current, regs);
+	unsigned long args[6];
+
+	syscall_get_arguments(current, regs, args);
+	__audit_syscall_entry(syscall, args[0], args[1], args[2], args[3]);
+}
+#endif
+
 int syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long flags = read_thread_flags();
@@ -2476,8 +2487,8 @@ int syscall_trace_enter(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, regs->syscallno);
 
-	audit_syscall_entry(regs->syscallno, regs->orig_x0, regs->regs[1],
-			    regs->regs[2], regs->regs[3]);
+	if (unlikely(audit_context()))
+		syscall_enter_audit(regs);
 
 	return regs->syscallno;
 }
-- 
2.34.1


