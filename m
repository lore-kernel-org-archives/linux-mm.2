Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EC8C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCC46B00C3; Mon, 29 Jun 2026 09:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660116B00C6; Mon, 29 Jun 2026 09:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500946B00C8; Mon, 29 Jun 2026 09:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 101306B00C3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23179406A5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:09 +0000 (UTC)
X-FDA: 84932975778.22.CC3E2B9
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf11.hostedemail.com (Postfix) with ESMTP id D4B0340016
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mOwRVIyy;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738427;
	b=T2QY8ia/XLuhIYjfQsiLzOEp2fC6g4b5TSnJYBWxyeZUq2ftpD9yCfew0mEJU7APHUrr0j
	0dtXL9ZdRevzo0vU9ZuPe/LLGQHLNMu31+aYzEVs6Ko4b0tw4aXeG0VJJnUu/nJ3m5w1rV
	0o/IKEIZC1GYEADZ9f2J+em3ewBguA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zB/fjC+R3zx/ldZ3/8oK2r3J7YfHaNZdfYESXvKwXnU=;
	b=RxY7rGEqtA+1YT4ULGpeTFKWzj4graZbaAiBn/4GUk0HQ/ZW7qVVXhKtYIraHIO4mdFSPO
	EtQsSjBRFoLvQWFQHRI3JCyNUjsk9L3ItHHkzzsQkpmQbX5/ipDX0Qw22LJ3OxVDXDnDfC
	EvDCQ3hH6QtHvdE97IXe5Tcq/61E5xI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mOwRVIyy;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zB/fjC+R3zx/ldZ3/8oK2r3J7YfHaNZdfYESXvKwXnU=;
	b=mOwRVIyyI/7ex7M9RN2nxK6PhHDJKnL312ejLMNXz3H5JVPa/94rnk+sVWVAhuNE3JnvDOXGE
	pHZKqjVCu39RDW0QKSS6YMVQsbxm9X2wtshznqfSlm5NDpCJb6vWtPLNU2SPyst4JYsgOGt/jQ4
	FsYIBCz6KTKVIv7LXsrRdrY=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXd1ZFnz1prMV;
	Mon, 29 Jun 2026 20:57:53 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id B4F2C4058F;
	Mon, 29 Jun 2026 21:07:03 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:06:59 +0800
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
Subject: [PATCH v16 06/18] arm64: ptrace: Use syscall_get_arguments() helper for audit
Date: Mon, 29 Jun 2026 21:06:04 +0800
Message-ID: <20260629130616.642022-7-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D4B0340016
X-Rspam-User: 
X-Stat-Signature: awfsezw5um5oq8h6asnug3hojxwphcju
X-HE-Tag: 1782738426-906292
X-HE-Meta: U2FsdGVkX1/+C6EUGatmemCkSiWPnejSt51G3qnBfB1nEIcVZYDpTurIY9FnADQIuJmUteIUGxl6ldX2/bPv18Saq+e/1950qyJOhF7eyYH1AwlldxJB1zvzYQo9GBnaDeNx02RuXXmD7UEnbGvw3BPxTWeOszoMPTAUwYZQsBFWkM2JK5DEFLUYN1lM68wyYTnC0TnF1YzlBSAByRghz9gpsJtgwa5MqFd/+9KnGsWAqUp5Cegmj585OHj1JogS8bsy3gy9OOnlnC+dNBhRvOY2+07eCjQILLf/HqZ5kkqFRYh9Ev23t06aDYSV6XoYiYc9X/VD0lN/rQdZqhqPOJK282iIMqyIcHfW5qQxCq8f8kOgxhnYmxGnX1Waczbk6HYdHVuKS2T+mUnhyZzzXDAQgDwXSTVNt+NgEBcpOY1dGUpXmdLETEU/3C4G4yQWhCawuEmeikXtH2yDghEip2xce52b2qhOnMg1uBwuXLc1JCrI6BV03bsEWZbVEUf4uAeq5ccSNWHNO0CTuwOxRyY6J1tm35gr3Q4JI8Q3ZzmSyV1c5Jql55D5q03uvwzrOk7CguXPYqJ87ZNh1SOYk+Xo2weFH/oNDGyNP2aaLIY8bgIRFNCl43y3fJaoYI397QY6Y7GHFg/GLU5HplCsjt5FyGBQpLk1A5dvAfxmcgDCSE/EcDOtwej0VQ8cOQGOtJ3x3Ruqcl3mzb/iQGMjt9109FNlJFPC46j3MA0r1KCHkwwY85Dy5u6mf0D23pu3NAz8kvTikjZ5dvPrYUNtza8/1poDId7WLC6pRwZgVjjlZGwCQPoVDvZmHGq+sTX/DXUQwymTvWWJpROBUgkiTgnHwFgvd4gkSNqH9EBe7kh5zgnndXNXdYVZBCqqWfZ4CqhSbyfBI0Izfs73SzTH2PG/5rVc8CpQIE2SwE5nHjjczCddb0FNQ7I4MV4E2p/tRr2YQzr+q5rLOPa09Xn
 gMhFKXeY
 I694BULmokg+6v+lqaBeA1BSGG9CO3N48qur9QzezMpSFbtEvsJbh72Hf9Tql1OVtuB3rlS3W4gFS+JRdlsAIrFBJzEoYCp3/4p3hTeIdFI2sVwFPiIsvbmFMNVBa6F+ejiq1MxU3yHRZRpf/FG3mhXFW42pLNzQEV/aqdctKfiz18kEubiyepiNxKJH9LSprxRZlnedv5aBSwDBU65CeZ+hxbf5fjTsE3PDryFdY9R3nqCucuqWXUqYwuaw0DFltS0wAqh4ihDYe+cGIkfdFLg4zR4t8fc7/dOZ1aVGIAXAIkcbSNE8aqY/btdV7hYYf6KSYZclQshNmEM8SiBsLmKZgasMnbO5sQWumZX4k8wcVX5BIxG+lcKsBVTZt6yp+4xjCizZi+pnnFAhD9yVZzgp3g8cK5sZvcn0IFpX1Kq5fC/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract syscall_enter_audit() helper and use syscall_get_arguments()
to get syscall arguments, matching the generic entry implementation.

The new code:
- Checks audit_context() first to avoid unnecessary memcpy when audit
  is not active.
- Uses syscall_get_arguments() helper instead of directly accessing
  regs fields.
- Is now exactly equivalent to generic entry's syscall_enter_audit().

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 30df515528e8..ae71cadbd4df 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2408,6 +2408,16 @@ static void report_syscall_exit(struct pt_regs *regs)
 	}
 }
 
+static inline void syscall_enter_audit(struct pt_regs *regs, long syscall)
+{
+	if (unlikely(audit_context())) {
+		unsigned long args[6];
+
+		syscall_get_arguments(current, regs, args);
+		audit_syscall_entry(syscall, args[0], args[1], args[2], args[3]);
+	}
+}
+
 int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 {
 	long syscall;
@@ -2438,8 +2448,7 @@ int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 		 syscall = syscall_get_nr(current, regs);
 	}
 
-	audit_syscall_entry(syscall, regs->orig_x0, regs->regs[1],
-			    regs->regs[2], regs->regs[3]);
+	syscall_enter_audit(regs, syscall);
 
 	return syscall;
 }
-- 
2.34.1


