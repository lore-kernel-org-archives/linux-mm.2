Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C816CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BED8E00C1; Fri, 22 Aug 2025 13:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D5C8E009D; Fri, 22 Aug 2025 13:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44CF8E00C1; Fri, 22 Aug 2025 13:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B89E8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59F4D13843A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:28 +0000 (UTC)
X-FDA: 83805125376.17.4805C02
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87CB9A0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Lc758Qm/";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf15.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7icmFEtMbjG8nHUlUz3H6xEpzLvZfrYx0hP4AUrTZT0=;
	b=Xcp2D6dh0Ug3UWzfmuMwG3/kstFC2Y2DigEsNRNn+9TB66/rSIQscxDHmZPXEeJKXYyc6Y
	DPAnIiRTMJbeCjzBkfP5xx45X5Wvv/1ilmdjUUT2GnY4KKzRGNBefzFtfD/EPMETRcsEtv
	CPJGaMOmfu/7uBBmqEYQR11if6SLeMI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Lc758Qm/";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf15.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884846; a=rsa-sha256;
	cv=none;
	b=x00hpFgg7FSu4FkfQ+xZ+yz/7cZ4dErFyiFSKmSaquoa0iePxy1vQxZ8rYIuMdUBh9n7sd
	3zP4JZB080ADKXrMukZxqEYvrrjdvz8k8rmF3BmXMcsmqIT9n0NpmbAD+LKHwB6CScQ6fh
	p24hsfQoAgHqKP4SvFzbyifPA5hRHhs=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b28184a8b3so26772071cf.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884845; x=1756489645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7icmFEtMbjG8nHUlUz3H6xEpzLvZfrYx0hP4AUrTZT0=;
        b=Lc758Qm/6lzScXYUBr0jkRwmTg2vjW03WMc72iCOyi7TVdHca2cx1C966uF/jq4uyn
         xQRkzA5sTHf13YlHsgYsDapncYu+tCDeEbpc6IWEe1Qd2ryDTYy4A9BgiF/pQhI/w5Gp
         RC1aEli7kdGk7AhF6X7R7GkiW2hEW56ftrfEsS0Qx378zhgFGxyj276kxBbvYbV99mpt
         qKWwWy4LNQwOlpi6Rsvgz//D0wdpb4xke+UdUSTiL5e2HMzxnGU/E9XV4plHPHdwRxmh
         p3fvRuKb65Zx7aT6c49CrgUWFdRg6n7HevR1E0qTjuqYMidUqgaJ7n84EOpVBOrPUmAR
         n9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884845; x=1756489645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7icmFEtMbjG8nHUlUz3H6xEpzLvZfrYx0hP4AUrTZT0=;
        b=OeUd0JksxsFOqc+n0tNsJYeLELGb97Y+ZmML/LqE8wpLOJLjwx/eNPhKE1KUMhJqV6
         I+igX9Jwn1HFE0otmZw5Hs8CTVqMHeTdDm6qsVbDuJIP58c4i+rhKVyXmfk/FKjlBA/H
         5oycWwgpSp3VnnmnEnwiurFR9S0SfkACF818U2jwkV1VP68znmXFOQLWhvmSoI80SRnR
         cRwdQxtNmVtO5qny3kNivhhL/nkTyIAKUzLKc17W4nto2x0/erxpKgDRZxceL2OqUKqp
         hUZSEzaHPoV8W3Q45lN5TQKYdzcm9ukI6EkkhIbMqLHdl516JLVE0UYvAGrhpz/pKRUX
         aFnw==
X-Forwarded-Encrypted: i=1; AJvYcCUe06WHRrSMBiUm1LHIFsHeh62flD1dPY5cb8tPire9DX5H2V2WjvVhlPFaRQPIg5hdhGQGtK01Dg==@kvack.org
X-Gm-Message-State: AOJu0YzAMudLOvQjRbG7xwRhULSeY44KlR8LzsozKCHdWsNK/HkhTOcu
	tg4E05Ttw4Kb/f3KfWhpOG1wbSS6kRK33AnV3O6IQ4ZUR4COp9KUkZlgHuVz5xTOpEw=
X-Gm-Gg: ASbGnctpRCKp+gCkSiNHOkfNfL2uRGdQRgrdsTmvGjtI2ZD4ieWHCBxyRKqcmOXZGxI
	FLj/iQuKNThBP0f59KLjHH120Z96qZs8wZG8WQv+Oqk7ioJC4BoWJuSTFiBXUP74M1l20QUv4lC
	iL6Y321GRs0uZ8uXg/a8hCFw1rqjbCRFpcSE5GSt1LH8bZru4MKo+Hin3EFxMiL04ewFlYn7pXQ
	YA3r+PBD3+dw8J0wErYg4SkRGsfs1lw8/81cVK8nJ6hk4OXCzfIndzU38/nVdDazDMp2kBZtG0a
	p/NQk17g+IpKUPuUfQZkct0pziYnuNFTLySiFBHbeqzH5picxkQO6ETDyNGkIeGWdHq4do1hAY0
	sOXlXZFj5jOh00XdBu0w1D2Ju95KwIjFf2eOphJJvGI0IuVs/fGK1ZR8EZrG4mUbHfwTT6KzqFS
	yvQ0vmXA==
X-Google-Smtp-Source: AGHT+IGt5FtRUkeNaYf2QqcOOYK1voNcUZefaLnp0B87objwjhy4KKvTzMxzHCr1EhOf/GN0KqwnNQ==
X-Received: by 2002:ac8:5dd1:0:b0:4b1:103b:bb6f with SMTP id d75a77b69052e-4b2aab276d4mr43535751cf.61.1755884845347;
        Fri, 22 Aug 2025 10:47:25 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:25 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Evan Green <evan@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Joel Granados <joel.granados@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Celeste Liu <coelacanthushex@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nylon Chen <nylon.chen@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 3/8] riscv: insn: Add get_insn_nofault
Date: Fri, 22 Aug 2025 10:47:10 -0700
Message-ID: <20250822174715.1269138-4-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 87CB9A0004
X-Stat-Signature: b1f3snko9z1ikqc8npyidki9penpzm6x
X-Rspam-User: 
X-HE-Tag: 1755884846-121042
X-HE-Meta: U2FsdGVkX1/Q6avoYu0QOkEUW36MrzouI6/G3i8q0bosrt2VRpLIOuHVzDGL3cQbyZhm/q5wx14sxMO6aVMfGKbobBCZvpC8fR5K7WI+hsatsa0k5g6kiVUw7XsmT1PEdE2ft3E+N/VhZ2/9ca2oq9U8KL9p+UBNz75PidMdHtqq0ofe7zyCjj21ZZ4tpEnDjq0hLCO8wHSYOG+M2HDfpOMMR6JMWTDewnuom6yD9hVGEsgR5eeBouT5gp2XilykNPzIhL/ISD07vjTAu/0P230B+aQx3gbJiX2pEKOV74e/nVQWtrjAHHQ/pH7yUnI+SYlgJWXXNPWHuwrxaDtLOcR7eumsxU9hqVeIebAv92c/GIqggYhBnZkJ/N+Av+Msn1TGlqsnXiQByCN7RzwIopSmZiHkUY1de9eYHAt9nKOhtre/DYlWcPKZ1+aFaxtIgpWNxr/A3h4zy598aWToLcaHFe1dMDtOT17ZwiQXH4tOxeGf6JBKXRY1Qizz99uxuvcM3lVnamJgBnQfty/kdBxePDyA+h275efyxANlogv68LF0Cq6R62Uz+DQwYGoV6duCwUi7Rh2dRDJxjXUZGEnsiJwSvntbON+WGJV/wTWJ5MaQUqvZPmZoLu60j15wTR1ONXeElcdgJDfxRKtnXgzTw1llpTRWHBwLPgaFmOGfiXUJW2KFQZHi33ZC4vzMacD76PHhFQHBI4+tsB418r/VzfT6O1FN8bIMiRI6FFmVE0mMtHO+BditzOXILawLPrM1GFp69hRQO6/Z5M+LnyULyYFx5rAMU5ZBPEvxk0xKZ8TWTl4WGbRuWFj/PWIOhoioIp9B1bx+rFBQ/se+BsCJiGUXOB4QRjUZbQ5TXXWukx8LZFlB+O+cYBlw2XiKKT47o5NAnIosZ0kLXM88j/UPBVaPmfv3FqajI4OEAKmYpo71awxtUZPYoqW9fkF/cDEfIIF3ru7+6GrMMEJ
 BJSVytTT
 +jLm7wZ9JG4RTyHb76yNZ7lP29F64+tcY/bzaRvcxa4lypQklZFWAAACHzPwKVu64Dc9OH6E9E4y7RYzYLEgo8dPmUbEUkyOYB26oLeI11BCskJsdh+wxQpGtqmgC6EI4S1uYb6AOcS2d8QVOmHfzKdxxc25Ry5DTkEsMTQ0GgJlSELKYIC/5e/x8R7adQXlNvuY2UDMZuxhEExCkLAIfNMTS55CdJonUYJrB/CAEo4bVwIOvzg37NmYT3fi+gnVUueB/zEdl52wS5xboW2lWa5P9cF9CR96AAZv412HeIS2vwhu/CUzN3kjLt4baFfoBvW3Yer7OK7Qr07DaOGzMIP7dH4shOwJXuHVzdEX5xd09rjNZ+fcWYx/Ze6MwFSTjgXt9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_insn_nofault uses get_insn with pagefaults dissabled, allowing it to
be called in an atomic context.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
Unsure if copy_from_kernel_nofault is an acceptable replacement for
direct dereference in __read_insn.

RFC -> V1:
 - Add new function instead of using copy_from_user_nofault
V1 -> V2:
 - No change
---
 arch/riscv/include/asm/insn.h |  1 +
 arch/riscv/kernel/insn.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index ba74e5b8262c..f87e0a48f786 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -553,6 +553,7 @@ static inline void riscv_insn_insert_utype_itype_imm(u32 *utype_insn, u32 *itype
 #include <asm/ptrace.h>
 
 int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn);
+int get_insn_nofault(struct pt_regs *regs, ulong epc, ulong *r_insn);
 unsigned long get_step_address(struct pt_regs *regs, u32 code);
 
 #endif /* _ASM_RISCV_INSN_H */
diff --git a/arch/riscv/kernel/insn.c b/arch/riscv/kernel/insn.c
index dd2a6ef9fd25..c8f77c0093c9 100644
--- a/arch/riscv/kernel/insn.c
+++ b/arch/riscv/kernel/insn.c
@@ -2,6 +2,9 @@
 /*
  * Copyright 2025 Rivos, Inc
  */
+
+#include <linux/uaccess.h>
+
 #include <asm/insn.h>
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
@@ -74,6 +77,17 @@ int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn)
 	}
 }
 
+int get_insn_nofault(struct pt_regs *regs, ulong epc, ulong *r_insn)
+{
+	int ret;
+
+	pagefault_disable();
+	ret = get_insn(regs, epc, r_insn);
+	pagefault_enable();
+
+	return ret;
+}
+
 /* Calculate the new address for after a step */
 unsigned long get_step_address(struct pt_regs *regs, u32 code)
 {
-- 
2.43.0


