Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85610C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C19E6B00D9; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778556B00DA; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6604C6B00DA; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 300856B00D6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAFC9120661
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:45 +0000 (UTC)
X-FDA: 84932977290.04.9A956F7
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf29.hostedemail.com (Postfix) with ESMTP id 759FA120004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RYtyy34k;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738463;
	b=Os0jXXxYStMXSGqkbZsZAap8JCP3D8YekeG/ObmVFmmTqYNGJhGjkRi5loMDRg65vjvM7d
	cJdBeFUTSTJst7imEgWNfat+u5S0Bw+LZEuTUrZeZTZOFBhDk2kRc+Jj+InjeU9Pyywfmu
	bgc0/gkHj37vuu39RB60UQY6p1pLy00=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRrvuMXzaYK6HUR0cuKvFuvToTthZqw4duYY3VtWyyU=;
	b=0ozugaON0fV/23beoGCZGf6H3xv234rE30HZa0UXmzWNJ7PWfVTKCpKvoYUolE+adHGC/z
	jqr549K4MOvQy1rGhy6oEXaNXdzwqwYMS4g4UTcFe++4o44ehmjmvjvY2PVPvIVPt9oBBJ
	y8Y+ts62CxnfSvgY07rMdfFrYlpGJq4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RYtyy34k;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FRrvuMXzaYK6HUR0cuKvFuvToTthZqw4duYY3VtWyyU=;
	b=RYtyy34kDkosU1+WmQBuulXKUnMrfVd8npdPpPN9UHFmGzxLygei2ZZYz4n8eWcB5VbipDq32
	s14zl1Nyg8PgRu7X/8Ui0YmbSgThw4mzNWZRTa94HP6JR4MMibMzO6/d6RcJG+/xJQyd6dqq92m
	YFIE8NhHSho8g4AhoiG7huc=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gpmYL3NGSz1prMZ;
	Mon, 29 Jun 2026 20:58:30 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id EE15E40575;
	Mon, 29 Jun 2026 21:07:40 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:36 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <mark.rutland@arm.com>,
	<ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>, <linusw@kernel.org>,
	<yeoreum.yun@arm.com>, <song@kernel.org>, <james.morse@arm.com>,
	<anshuman.khandual@arm.com>, <broonie@kernel.org>, <liqiang01@kylinos.cn>,
	<pengcan@kylinos.cn>, <ryan.roberts@arm.com>, <yangtiezhu@loongson.cn>,
	<sshegde@linux.ibm.com>, <mchauras@linux.ibm.com>, <austin.kim@lge.com>,
	<jchrist@linux.ibm.com>, <arnd@arndb.de>, <thomas.weissschuh@linutronix.de>,
	<sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>, <jgross@suse.com>,
	<kas@kernel.org>, <x86@kernel.org>, <linux-alpha@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-csky@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-m68k@lists.linux-m68k.org>,
	<linux-mips@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linux-um@lists.infradead.org>
Subject: [PATCH v16 15/18] arm64: ptrace: Skip syscall exit reporting for PTRACE_SYSEMU_SINGLESTEP
Date: Mon, 29 Jun 2026 21:06:13 +0800
Message-ID: <20260629130616.642022-16-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 759FA120004
X-Rspam-User: 
X-Stat-Signature: wknge8kctx1jjtdmw11zykesrwmobybk
X-HE-Tag: 1782738463-830991
X-HE-Meta: U2FsdGVkX19GoSFLHDtfuAGCz5+2uZhMI4918rRmZaoqCS8MQ3OhevAr88fOiua3Se/pT9yAjm+b8blfS6mOGTLGpVCuqIZa0X/cFRmzSzVGOrg2AfRofjccNJeLHcXgqEMnKuqqxwKYtO5MP/F5QoJMwEyQhUzm7DP2FutqyM1vtvmZFo4M96tgZ+Y6Q2YHHyeSWor7PF4c5fYAUmmkLZDow1f2Q0AxVVdN2uFBKV3AIjpeLHaKgUQwjSlobgxOd49lL+Wc6GOo2Om0bXQCy6ZTladptkx8v3IQivhqCVabnCoCT11/feqJ7CkbRhlEEztyksQT5SAoMKTTIQsLgNFzYJxfBVvYFxYj/7Ob1Xdo2K9LjysNV+ZJZSTnhiiTODCvsUVWviXn4t5DGCsCElmFRWVBoH7cSXlgAIcrADhuK8qcf5DBUEj9sIQ9Hr/+32cNTjftxCnBgyIFVSpEcQ2FMsHmhI6fDkhnMxuWH1m+fo56+yNtgtHPf8R+7+cLNaRaj0gRhqkXdB1AXnco8urqq7uBC7AH2pwldHXcepWigQ9OAc6FJhraKb7qbIpI6XNp/cA9V5OesQCkT++MB7kqRK6TGb+0Ui3tGnWkUaVLxXgLsqp106U3pexCv6WhwkiWo6mtkMyv0n1hSS8ic/UnekYlTZOMvlHXwXu7u+CNoOkOzklcCZym6PdXHNgl+B2YcLsxqKF2KnrtpUkUSEhgW+F2C7tJl/xs2YYRuo6rs1/PtysSY3EwSSTVOZeWLew/nOEyZglC1+4NQA7f6TpwRpgfx3rm7iLttIdRRftm7EUbk7tPTfXyrL0ysREpsyfcpqyBIiw3a+c/IhaQy7w66RZv1Zl8RoCjwwbcuyh9+7nRZGp2dvn9GPoPXz90C3kPKotx21AHMC3tdaviLFsYZjPpPX5KyIPXTh/mrrIav2hiuMECWbrCrzJVrTkCDpVv88fOMV5ij/UHfiH
 vW7vriFU
 ksro6d2/NXjnfLnaOCA1ubsUp4lEb81ZXzNwirT+yaRKXmOSVTdoxpQgqbXOLJTRKVG9CS227MtE4XV71pSHanK21S2hm1TlCltMnTHXrjmYFgi+DCUFuIR83xwMwrx7IcUDqDyXI58noDPq/VMQVj9k9zzXwXUzta4HocX7Eg5kTlwk6om/UVWrSq005WGukRlQnYk9avjK2AwIO7o1A4I1hXNZR3jh6b0jFdwqUYgR/C35nIzKHnoKh8Rye7/KRuthJHPblnI7rgdzgRBJBmeMZ5fdyl0LeiqURa+3HYPV4DqJ1YyrjNmbFpcAV3yrY8cqZeP1voIgKXrSB4sZ9i7lxX/LbBfJPQRHiQv4UqduMjDNU1u5DAiUQ7hqM6RBJp5/qLn7LhTznzG30bBpVtdXnyuOTK/7aMcNPZ93hanYHd0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Align the syscall exit reporting logic with the generic entry
framework by skipping the exit stop when PTRACE_SYSEMU_SINGLESTEP is
in effect.

[Rationale]
When a tracer uses PTRACE_SYSEMU_SINGLESTEP, both _TIF_SYSCALL_EMU
and _TIF_SINGLESTEP flags are set. Currently, arm64 reports a syscall
exit stop whenever _TIF_SINGLESTEP is set, regardless of the
emulation state.

However, as per the generic entry implementation (see
include/linux/entry-common.h):
"If SYSCALL_EMU is set, then the only reason to report is when SINGLESTEP
is set (i.e. PTRACE_SYSEMU_SINGLESTEP). This syscall instruction has been
already reported in syscall_trace_enter()."

Since PTRACE_SYSEMU intercepts and skips the actual syscall
execution, reporting a subsequent exit stop is redundant and
inconsistent with the expected behavior of emulated system calls.

[Changes]
- Introduce report_single_step(): Add a helper to encapsulate the
  logic for deciding whether to report a single-step stop at syscall
  exit. It returns false if _TIF_SYSCALL_EMU is set, ensuring the
  emulated syscall does not trigger a duplicate report.

- Update syscall_exit_work(): Use the new helper to determine
  the stepping state instead of directly checking _TIF_SINGLESTEP.

[Impact]
- PTRACE_SINGLESTEP: Continues to report exit stops for actual
  instructions.

- PTRACE_SYSEMU: Continues to skip exit stops.

- PTRACE_SYSEMU_SINGLESTEP: Now correctly skips the redundant exit
  stop, aligning arm64 with the generic entry infrastructure.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 05ceb9f2d038..650db9b47373 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2452,14 +2452,25 @@ int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 	return syscall;
 }
 
+static inline bool report_single_step(unsigned long flags)
+{
+	if (flags & _TIF_SYSCALL_EMU)
+		return false;
+
+	return flags & _TIF_SINGLESTEP;
+}
+
 void syscall_exit_work(struct pt_regs *regs, unsigned long flags)
 {
+	bool step;
+
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
 		trace_sys_exit(regs, syscall_get_return_value(current, regs));
 
-	if (flags & (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP))
+	step = report_single_step(flags);
+	if (step || flags & _TIF_SYSCALL_TRACE)
 		report_syscall_exit(regs);
 }
 
-- 
2.34.1


