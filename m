Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21984CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF946B0031; Wed, 20 Aug 2025 05:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7726B0062; Wed, 20 Aug 2025 05:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96006B0089; Wed, 20 Aug 2025 05:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94D6B6B0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:40:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 391471179B7
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:40:38 +0000 (UTC)
X-FDA: 83796640956.18.A0F1921
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 443D71C0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:40:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CPnVRW+s;
	spf=pass (imf20.hostedemail.com: domain of pmladek@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755682836; a=rsa-sha256;
	cv=none;
	b=eMMqIfVcaEi18gcUr9DsNjIASkW7/wbpWqF5/sd33kSpe1xMx+LKTOLYMNKRstJlkOIKrD
	+M15DfbGHx+3ZxhLgpqE2JDRuzek3/BhvpyX0yAf4aedPRqPopAAIEgr5MgabUN+ED63/4
	7zdeo1Cw1UQEnmZyN5kSbVzoIR4Fpig=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CPnVRW+s;
	spf=pass (imf20.hostedemail.com: domain of pmladek@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755682836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NM0fyXJdFVsVnU/yS6K0gQI6XozNG1TCaWkFW+vAlK8=;
	b=nf/fYaMo4Rx2bQ6IRa44xjb7CVKPz3F1O67cgLzkuG3r86/aAClnUNRbqNkk5pYM0fYEcL
	bgH8NtE/pbI9sQrsZHyonixM2G9nmH8kDm4BIgysX1EfSmVJzEvF514QjKBlaRf2Swaf0H
	8f6Sdn05xwRoaNxGDE/mnJQMNTDUYkw=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afcb79f659aso949904366b.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755682834; x=1756287634; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NM0fyXJdFVsVnU/yS6K0gQI6XozNG1TCaWkFW+vAlK8=;
        b=CPnVRW+shj7O208p/RgPT7E1ai/RB76yesgNpyrM6mfE+V1p4jvZ2gPMuys/KGGplq
         cQvN5LWOBxTviXI9Y63mr7F7QE/+2TFcCLO8kVmfGiu8cuWrMROu9ct7BMPjVsbjewNY
         WlOkUUSc4I7lCWDn56LtWUBrZDQPFOMqt+mk2N8kbMN/ShMCtp2M5N9A/ges+SKbYkUo
         D8eUZqjX0a1mJ8WB33Hnuokf085orM444sW75Aqnh6alkIn/YplDnqLT2Jqj0dvuegoA
         xswJ7fKK+YSQhaEXf1Bvl+TseMMreP0Vt1oZr/VM14Zm86cV14+uVarOjzrFiIvjkurq
         uDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755682834; x=1756287634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NM0fyXJdFVsVnU/yS6K0gQI6XozNG1TCaWkFW+vAlK8=;
        b=RHAg61boftYGCGxnIZ+qhSZhapO6yC1C/LGaNYSit2J61QbT7h9bOwDxO9cDysrTdX
         5qd3XTYw66uv0XzhZhagb6Hh0Xe+RhZpcS3xs1JpnM4rW2ol1jzbqSUs8ge/YPJIlShb
         fUaBacwDkk3DSdpRBieffPo7Q54DL2RrC65z1Yqehqt3QvSZyR2//SuI3QrVFBCsgChC
         7+a2lVWlYIIHNBRWjO8mGqpctPG9i5N7qs87gtS+A0aWAqz1fuNrPyaCM6s9euNVrS4k
         aSRMKXRGcHgFGjJqWO9mEr2wgAm0DKb/u0tRT1Pwv+oenKOjYPOA84Kokx9i7hpI3TUK
         6lxw==
X-Forwarded-Encrypted: i=1; AJvYcCXM9XGuZ/sp4DQhsU7610ISNvmK37ZQ57eakYFcfI7NzxxHQkovFSF38m8v04fOS3Eme34b6s/9/Q==@kvack.org
X-Gm-Message-State: AOJu0YyB53vED6CHCvZcUstMZyI12Z8wdR0rjWl5OIYY+JdTT99Himd2
	XAL2mO35fj+eQ2XwBzn8YQJ2SpXxPgGxP4Pmz4Aoubc5v/Ek+PJhpEa6wpwEmY3Zn9/AZly0zna
	Ixc+9
X-Gm-Gg: ASbGnctw/R9VP9Yz1ntsWR/OXzGX04XCjx1wKz3hqCYONbI6lGQXCaLkVG9zKL20k5u
	I9o3JtNTJdQ0fSmcfesbudcpO9g/pTRXfGedCFEc3BFQ7hAjFYvWAfNkYTuluGbJnYNinTVEs41
	UqfCyrFeM17XMis77aCcWMiXo+zsLKq/ztWMBqfUDQ7auuMtrEXNwhCWEGk2ENpATdX3C1lQWFR
	nRYJBWFLEhJANdgVCQYTY68BPFytetQC9smvsJYGUpM7mO7K50MC/SfHl+IB8xFI9ndnMShgwmS
	z0kJaC5ln99JnlSsDIM6f3Pbk6wcpnSmT2mKP8/lZU9Wi1SyYgI/c769lGM4vrfyXnHidla0rIg
	DLKjinP6ZgQZetC4YtQ05QExYHg==
X-Google-Smtp-Source: AGHT+IEL5yizeK4oP3hcKNDpDCbogCgeCUIgrsK+feZZ6+ybN7ZuuNRbKKwxk5Z77sh2bbe8+uaS7Q==
X-Received: by 2002:a17:907:3c8b:b0:ad8:9645:798c with SMTP id a640c23a62f3a-afdf0209598mr168513766b.51.1755682834470;
        Wed, 20 Aug 2025 02:40:34 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded478a14sm148404966b.76.2025.08.20.02.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 02:40:34 -0700 (PDT)
Date: Wed, 20 Aug 2025 11:40:32 +0200
From: Petr Mladek <pmladek@suse.com>
To: Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	paulmck@kernel.org, john.ogness@linutronix.de,
	kernel test robot <lkp@intel.com>,
	Feng Tang <feng.tang@linux.alibaba.com>
Subject: [PATCH v2] panic: Clean up message about deprecated 'panic_print'
 parameter
Message-ID: <aKWYELPjbhC7R8NO@pathway.suse.cz>
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
 <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
 <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
 <7a34da58-874d-4271-9dbb-7991468d58ff@linux.dev>
 <aKWWcPOf9qPIoCe4@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKWWcPOf9qPIoCe4@pathway.suse.cz>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 443D71C0006
X-Stat-Signature: n7bcqgifphkn8xfm5w5w7d343nbg5mhd
X-Rspam-User: 
X-HE-Tag: 1755682836-44659
X-HE-Meta: U2FsdGVkX19n8YSZ5YfiC80kTrOZp0btHr5owOlxVS2I67Mc1QPjl3KwpfNQsBVaWCYfkyeDhWFBJnT0UUFvL62QEd7jkgh3UCqTW4k6dNcXCDGRsRynPZ1FUsQmFPrSkvZ1GZ+aocC1MyEvkw2zXcvnf4f1AH5lrIoTa8AF8zxxiUlx4Ub1KK1FYrVdvoRyTzw6Sd6Zc6iM6Z9r/15YUe+iv+nhHqdsbP2ZRdu3a9M9uwuehyev55Yyxe2oC69PgZ40OWezEpQpx96lTyKtKnTk4ie0RpkfYNGcoStkMNx3GRv+hQ+ZApw8hwR8bIXyooq8ypdlKOTi1oOZG/pUeRYyLSSGXZ2gUtdu2HjAC7mISUZehT91PkkJElmDI8gr1haH9YGsQ7R1eBb/AD9DQ26zJlIgXeGp9KhJNBdeDmBtShmFPtaDeA5DvGc27U/g0cj2oB6G/5d2QEf7ISZFyH8Fc4YlB428XqTcvzhAiN2pKzpwft2F+m1U4nqlFR5lt8FnAqIbDjRPnWh9hNxelpFCL10QmXbXN+BBgg9B5frdOsC12G+Ge/gAFsFhHR0YDnXY9VMUXLR6TM6thrkkXZUvaVxqCybJN2ipXOskpqgRIPxDUudpjLgcAVcJbAMYgHOixI1LZWzq/z1M+FqlawZFXJMGSbCyaeTBlrWWI7UoXjyGyWl3j8umixR76v5qtr008OuOOCBKx0DUxgI2fB3kbnf2LzhYc5Bn4QIhcHlQRdQqgmiOGLqr11gVJxPfCdcGvc7m087ztKYKBCz+nFw6+Bo1lqiCwOM3JUnxIGR7zV5sl5yp5Mv1C4qLRNEYQ4mEua1vdxJszlV2ucN7b/EnL3pLcMVdKbUTJfpFG1TvexXhI8e7VKSBmTPTthlEJATWynxiqD8zfRYnyqwu9EVkQg+J9jrrve5x5crizRX+I83S4ShEh+4CkoKIP6cfuAwBbpEf3nceILeXXAx
 XvrxXLSP
 nF2jNI1gZ/4fQ3I6WR864fq2fNp9AwCe9xwSyijeLscRYOTTmgWAWt0s6vrVdxOKPE0jNIseTQ+1rrG8hHN4XS2eZ60ECGWlrRB3OgiffVJXKrFszKv41eVV9dZJ79jGgkwKP22Dd8GZGs9ps0Hp2TZLxuoWsWeCm2O1QFGaWN+h3vRQOW/c9/YrNSTmBne93L4/VL0eEL3F5ovJ0u6BBgxRnBX9ZVkumN/xXq2/ATpgYh8bw/STGzLSbnzdNK3scaPiWoNBfzeiVskYpC+gr36jeAix9DpszfuVL5OnDcF0dwWPlOJ4VLYXo3aZ06iy4QrVggBqSJ77tCAZVp9r5GXwa6V+LmOX/im7feoRiHZqeEud8LS9LgEeIkKDrDsG5w6h/RF6wptt41XA3kU+2kl4msA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove duplication of the message about deprecated 'panic_print'
parameter.

Also make the wording more direct. Make it clear that the new
parameters already exist and should be used instead.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
Changes since v1:

  - fixed compilation with CONFIG_SYSCTL disabled (kernel test
    robot <lkp@intel.com>)

Thanks Lance Yang <lance.yang@linux.dev> for debugging the compilation
error reported by the test robot.

 kernel/panic.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 12a10e17ab4a..24bca263f896 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
 #ifdef CONFIG_SYSCTL
 
 /*
@@ -125,7 +130,7 @@ static int proc_taint(const struct ctl_table *table, int write,
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-	pr_info_once("Kernel: 'panic_print' sysctl interface will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
@@ -944,13 +949,13 @@ core_param(panic_console_replay, panic_console_replay, bool, 0644);
 
 static int panic_print_set(const char *val, const struct kernel_param *kp)
 {
-	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return  param_set_ulong(val, kp);
 }
 
 static int panic_print_get(char *val, const struct kernel_param *kp)
 {
-	pr_info_once("Kernel: 'panic_print' parameter will be obsoleted by both 'panic_sys_info' and 'panic_console_replay'\n");
+	panic_print_deprecated();
 	return  param_get_ulong(val, kp);
 }
 
-- 
2.50.1


