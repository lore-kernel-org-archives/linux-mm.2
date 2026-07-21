Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F33C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A626B0098; Tue, 21 Jul 2026 04:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2515B6B0095; Tue, 21 Jul 2026 04:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B1F6B009B; Tue, 21 Jul 2026 04:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E37066B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7252B40421
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:09 +0000 (UTC)
X-FDA: 85012083618.08.8F49E94
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf28.hostedemail.com (Postfix) with ESMTP id 341D6C0007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Yoed7e8R;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621947;
	b=QRxbKO3GRRhU74KPI6KmohPkqGreZKHtDKRkp9/Mrsc8FXFtVljGQJrcKhsy0f+1A1lbi8
	cZsXKXosWcg9eQnlWx1Fc4lv+/1kdYqkwZREFPhcJDibmHHS89XQdL2eCiLPvz9deAxoNV
	7dmmEQEGRBzZEAmP0bWqrMHgYI+oces=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Yoed7e8R;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdc1f7APJXH1A4RlASICiN/qzPLenJiErSnTlc675VE=;
	b=PL5Bvm1qxsB3ymB58COjFO0nM3bQooVcOH1gSpFKgtqeqhS4Y/762UZIW2ntXQHd1hEZud
	mAXHwnmjpIbU9rgvQ7LjKgvw2C56wU4+nIvL2Fg2Wg0jEMIIRO5pNPSBUaOXMpgjoKDugW
	2E6zQQkd1mhcDeNT0Rbu0fKNbV1c3YE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cdc1f7APJXH1A4RlASICiN/qzPLenJiErSnTlc675VE=;
	b=Yoed7e8RXfOGKV5BdhCPVXK/NpNB6mm/UMlPjDUXaQkHY7ucrT8JDQ96VcORif+3a7+Fop22y
	cFDvKhdwhXM41APldPjb8jHhpx+SUKhJ3da18rRw3RmPu3w+dXIpr9au56y+EnCkAnetg3JJ+pw
	XnHVMvusQEhxGFgUiJ4agEk=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h495y10Zlz1T4Km;
	Tue, 21 Jul 2026 16:09:42 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 387C340537;
	Tue, 21 Jul 2026 16:19:01 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:18:59 +0800
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
Subject: [PATCH v17 03/15] arm64: ptrace: Open-code seccomp check in syscall_trace_enter()
Date: Tue, 21 Jul 2026 16:18:46 +0800
Message-ID: <20260721081858.1169276-4-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 341D6C0007
X-Stat-Signature: 6m3cdc8g3oys68mi7xuai183m51szdcf
X-Rspam-User: 
X-HE-Tag: 1784621947-489802
X-HE-Meta: U2FsdGVkX19EFbPMs/IJlswOwoAcQScyltbSpL+zuYYGeDEcSmzUxGoUzVotP4gsG1ZTR/huyaSLQOcfCwwJkADpfYJSwJzumTMsi3qw/aTZ0FUS+8hIX8xlf77Rk8Ytx803cUvjmYkya8beHqKGCtsK/TGaGjnRL6bc/7v3dUqnpG/mLz9X7UE/c2gXrYUUWvfmGtN4K0j9d396VbfxnOlLF5xEc93r6Tnq/bSxx1Lch44nZ70nXVNoiluCH/KwTBgZFk7iT0/5FBpJBvUi7uZsJpFVoD7Tv+QllgY2+bYE5eM6pfhLgvESus4eRLzJfDJ/TU3rYSOe3EvK/XEanY1cnjiJSXd9WtbORut5obQBRgAkud1CXw4ZmqQ404UrOgdA7WoH9iEx6HjhRQB1ivHbcplcNpUJhYhkNO+kaHxdfitqufNHVqrjnWnbERC6snk1J3nIcY3HWLVzPost8v+EomIp8XqMJv1GfHkkHQ2AKdrbiC4GNzTwHTZ4SKmpa6S39Dz+0b3nFjEm8GpkuaYMgZSWs8fhJJOjj4D3jCu9iocTpA3GvneULtTIyqOm4PzRk1v5hdddbgK6sM+9NE3CGCkpUQi2U9zOVZknAM/yiKwwf0+FadKlPdjodJZs8X0Z4zvdB1GlyGw9x/SYBrU8pE4zF/Y6ksHUXzjbsAhJAHGVPL0O+1li20v+P8Kp5R3ILhQ4Utn3BtuJU8pO+KciCW4FD28ACsTcqKbd5XuJtZ3bFaPmhFPaHeDEYqZlwiFtMwXCNduk+UEWAW0JaEFt6lt7uRMYkH5U667xNnk47b5j87+5W+o6ohvS449aP6YIOow2iideKXZT15Nv/cNA92HSltK5RU8WPkUFNyYG2Y0g/ZWL/sMCZ2JbMp/pELhPC/FZ0ZNxbbR13ZlCSk6AdQxNhu7VzkMn66KtxVDIT9TmGMM4lBh1/dBU5P4Aay7c05xkxbjIDQlGF8I
 QWaUVTns
 pgDg4RwntQHzdEQDC8xC5xPD6JWrpyP7X03j4ZP7TuX+iMPn42kfYUGEATZSxwkQFxuPpv20hF5ysl2PeaUp/DDtzR9zrHB7rABD7vouTDZoypUeUzytPq2gykVx7nJLiGvn3ALI+/D7wN8gJloSYy3AgvP6qqsQLngRtZRA69Yah+2Dzo6/Q4GtntYvPaHGqx6G7DZdCUA3X11crNiW2MLyzMiu5V+bCJ7rs0QRM7nRbeuQ4ow7A5UrLNqFkEVITI+pq+R1tpgb4N522bMFOV4eiejt1nZoLiRJjyKv8NQcHcBXdpLv/VHkaZPHeza8ODcs/KrqCj8RSG0DAtSTyFEan0jgKhAaGWQOPku7fDxSGHDAq25S592FAVBikGYerXyxfLgLgxGh/MXzMaNVqUcNMebRsgA1a+iD73VP/gBjsM6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor syscall_trace_enter() by open-coding the seccomp check to
align with the generic entry framework.

The generic entry implementation expands the seccomp check in-place
by testing SYSCALL_WORK_SECCOMP and directly calling the underlying
__seccomp_permit_syscall() function. Moreover, generic entry explicitly
re-reads work flags after ptrace handling to ensure any updates to
seccomp work flags during the ptrace stop are observed.

Bring arm64 in line with this behavior:
- Re-read thread flags after ptrace handling.

- Test the updated flags for _TIF_SECCOMP and call
  __seccomp_permit_syscall().

No functional changes are intended; this change simplifies future
migration to the generic entry framework.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/all/20260713025712.416366-1-ruanjinjie@huawei.com/
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 643e63a65734..cd0607ec70ef 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2478,11 +2478,16 @@ int syscall_trace_enter(struct pt_regs *regs)
 		ret = report_syscall_entry(regs);
 		if (ret || (flags & _TIF_SYSCALL_EMU))
 			return NO_SYSCALL;
+
+		/* ptrace might have changed thread flags */
+		flags = read_thread_flags();
 	}
 
 	/* Do the secure computing after ptrace; failures should be fast. */
-	if (!seccomp_permit_syscall())
-		return NO_SYSCALL;
+	if (unlikely(flags & _TIF_SECCOMP)) {
+		if (!__seccomp_permit_syscall())
+			return NO_SYSCALL;
+	}
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, regs->syscallno);
-- 
2.34.1


