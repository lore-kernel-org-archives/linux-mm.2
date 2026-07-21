Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA7EC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365696B0095; Tue, 21 Jul 2026 04:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33BAB6B009B; Tue, 21 Jul 2026 04:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A996B009D; Tue, 21 Jul 2026 04:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAA9B6B0098
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECBC2C03DC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:08 +0000 (UTC)
X-FDA: 85012083576.10.2947439
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8454220009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=o4GJv8CT;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xx5QBUbkJeO+8NVxlyHI+T4QL5u8nrlJRITGeX3ec8o=;
	b=J1V17TBXuJjg4KdNrgPbWHRO0hhGR4JU09ihX0CAUK0BJC1ApfotysGXN2ur93o4TP4u8P
	FrBWkUw/VSoCkdHZb1wd2erZYH24wJwv/8nu50CUUaFqwz+CDTQUqzqyUeMJu8QHSg46HD
	DTh2KZNHcxTtKAfLL+B7eWIV9NKiMuY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621947;
	b=7VDR8CCpNFxLtnAahWGe+VXZMFj2WwnXPNOcJ7SIaBF4AQwaWe2FVFZyVWTVn8fFrfiOwd
	DfPJAMLiGBbWCIYurfNOl9GDIgOpBMzoNOR+rZ8OEjbvv+/IUuZwhvIU1yv2v9tpUwVgYu
	81AiOrh9sWekQQdp9rlqCpzo4Plc1mc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=o4GJv8CT;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xx5QBUbkJeO+8NVxlyHI+T4QL5u8nrlJRITGeX3ec8o=;
	b=o4GJv8CTuCkLCE/j6tEGY10AJB1WOLGMRhWicgEaJv7E4qP71sNqT9M7Idp7u1RGqmI9YUjW4
	d4bMEpp5WtmARIV8xRGQTcvBfUhqdV5XtsbZS4aRqVchfqLBPSeW8j/MSHvHQ6NPwbZiHtGbimv
	F/YY0VViUNfs7sVuwLpJqBY=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h495v45Zfz1T4Km;
	Tue, 21 Jul 2026 16:09:39 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id A5CD9203D1;
	Tue, 21 Jul 2026 16:18:58 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:18:57 +0800
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
Subject: [PATCH v17 01/15] arm64: ptrace: Skip syscall exit reporting for PTRACE_SYSEMU_SINGLESTEP
Date: Tue, 21 Jul 2026 16:18:44 +0800
Message-ID: <20260721081858.1169276-2-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Queue-Id: 8454220009
X-Stat-Signature: 9oy75eicc8ty11fxm8rdd6uotgokbd1z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784621946-30094
X-HE-Meta: U2FsdGVkX1+PPck9TogZJxyfqTVboE4W/lpCuWlpYYjAcL26Ojvw0VrjUpIa+7ihqzkfnUKENqOcFhN/yxxB3rJgISKDxec1bbV4HHW5OFVnkOCycjU2+1Xq9A0M520BV8S27aIrcFx/79Jo9MAZZ4zAJxqKE1AHrPnyaj5etEHmKOea81dwQqLBtdZpuGodIUuJBkGGYZiIoaEQ40V81TwrfEnaTeohv6FkP5DIAOaNJKDiglNSyMbMonh8L3ihPlDlRtL7++h8LbaWrOwYfCSFSoTDk04/b+Gk8w+3wuSMa7bRONTedO07vQsEhQkqXx7UQL4RbX90GYpSNE3uDz7VVc6OE+zcylfwArfaPqoiOKZb0zeP32YfKJM1DObvzsUgmheXJ+yGdvHDXR7iYx+sHoMosPJQF1YqGd4NzWyZNpHkYUWIem5QENKzZ2bhnqG51ft6FBTpIqEFD7lEeYkpk93SbAGyZ1SxAhNYeXpyjCUMqgjQ1EFkubZXnJzDh1w31uJTHSTiFafXIHCK7KqjAdHUpxHscmPrL6JdMZWmxLZAuu6AV/zaIasOXK5yJtYFxh+KmXbrmxydXbBzEsIOxEKkdCXF6dlV9IgwTS57QSZCt4tvGwBrsbrsj3VxgMBKfI0gHbzEAvDj1E2c/MjHoVJbEGxBEtGzllqZ4jZt+Cc93+9kdKcOBAPb+LbTqcU9EXSt5R1sbIzl0SSg3NPoJj+COI+i5Mg6NjtkQAukaH+fW9U4gqqNn5LsJ8Orq1Oih/sZEcUWIguj3Fo54UvsRK6Ousm7tUI9gwZ/weHs3iv2187heEPMs6Xz6Y6oPYgY67/5jA5L7niV/CoEPh3NIOMI0/0ddHREvy3JMEmbz7TQq0zNxePVFD0eBhtc7tHoSfoZCbOj/JTPG7atS5JrvuD8TI3W6WDmsp8AW31QICn/L2Lqmd5ma7OQQuTAiNHQ5u1yujW9rvT/J72
 vj4s1884
 mzyJFjaG/APzo7Af0y2Mdh+GlNaoGqjAhK6yvmOB/5g14+tlNjDpMLao+mB8D/l+UtqWOyPo/mPgeG1XDEvBqJN5Vrt2Bq8oT9VIUXLIdW5TTvffYlMKBmos+5ApFUadOGCItKRjaigIsL1mk0sJz2k+J0Riz6qrNhP9yliIB6W6KBhl9eB5kzuYb0u4JfbH1tKgq7RhsuCMDcqA/25RNjRWVhj469kTqigacHy3xM+RvsNL3etPL4Daj0G6rToHh9d/fv4tbHng8zYX5st730cuMMAUHlpo4IKP/qJBR9Oz1tIMFrJrQbYjBsBALs+RpnaYV/+RXDxQjzGa0eT+OhldiHTENe0Arv+Ayd1hxGlYcw3gvunUjfvN2M+llZMwDB1VkeFUtFOf1yk/QOwsfyOPOx9RjLe0JOer6NcIYDF1yfSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

According to the ptrace man page (Syscall-stops section):

	"If the tracee was restarted by PTRACE_SYSCALL or PTRACE_SYSEMU,
	the tracee enters syscall-enter-stop just prior to entering any
	system call (which will not be executed if the restart was using
	PTRACE_SYSEMU, regardless of any change made to registers at this
	point or how the tracee is restarted after this stop). ...
	If the tracee is continued using any other method (including
	PTRACE_SYSEMU), no syscall-exit-stop occurs. Note that all mentions
	PTRACE_SYSEMU apply equally to PTRACE_SYSEMU_SINGLESTEP."

When a tracer uses PTRACE_SYSEMU_SINGLESTEP, both _TIF_SYSCALL_EMU
and _TIF_SINGLESTEP are set. Currently, arm64 unconditionally reports
a syscall exit stop whenever _TIF_SINGLESTEP is set, regardless of the
emulation state. This deviates from the documented behavior and breaks
consistency with x86, where PTRACE_SYSEMU_SINGLESTEP does not trigger
a redundant exit stop.

[Changes]
- Introduce report_single_step(): Returns false when _TIF_SYSCALL_EMU
  is set, ensuring emulated syscalls do not trigger a duplicate report.

- Update syscall_exit_work(): Use the new helper instead of directly
  checking _TIF_SINGLESTEP.

[Impact]
- PTRACE_SINGLESTEP: Continues to report exit stops for actual
  instructions.
- PTRACE_SYSEMU: Continues to skip exit stops.
- PTRACE_SYSEMU_SINGLESTEP: Now correctly skips the redundant exit stop,
  aligning arm64 with documentation and the generic entry infrastructure.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Fixes: ac2081cdc4d9 ("arm64: ptrace: Consistently use pseudo-singlestep exceptions")
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 924805e0c8da..4e9c71d477a5 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2482,16 +2482,26 @@ int syscall_trace_enter(struct pt_regs *regs)
 	return regs->syscallno;
 }
 
+static inline bool report_single_step(unsigned long flags)
+{
+	if (flags & _TIF_SYSCALL_EMU)
+		return false;
+
+	return flags & _TIF_SINGLESTEP;
+}
+
 void syscall_trace_exit(struct pt_regs *regs)
 {
 	unsigned long flags = read_thread_flags();
+	bool step;
 
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
 		trace_sys_exit(regs, syscall_get_return_value(current, regs));
 
-	if (flags & (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP))
+	step = report_single_step(flags);
+	if (step || flags & _TIF_SYSCALL_TRACE)
 		report_syscall_exit(regs);
 
 	rseq_syscall(regs);
-- 
2.34.1


