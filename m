Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E59C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F3A6B00BD; Mon, 29 Jun 2026 09:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2466B00C1; Mon, 29 Jun 2026 09:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9346B00C2; Mon, 29 Jun 2026 09:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFE4D6B00BD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D73091406A7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:06 +0000 (UTC)
X-FDA: 84932975652.04.CC5777B
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61B15A000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MTaxtZoI;
	spf=pass (imf25.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738425;
	b=ONTdc1IUf2ASrug7TR6FCk3JnZO1LMda/ouy/AV3vUmA7bh4nzy2UaovRJ3tbtlEsPwACN
	4gSeOIKInp9dEairJaQryg3zn9v17GJfYxVzLSarMEr+tX53cELyiQtNKNSYiMRU7n88HX
	zxc+AZDNWBz8smt1EGl4bY1yvhTd9XA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEkdmA69WtTXExuZLfEkpZLMXMGJ/f3AY4V8DVXKqRw=;
	b=U5lCCmAKcbZw5gdsYIWBT9zV0jTl1wpR+4ADsuetvHmdrV2J67o/xsMbYUCupSWv7PHZgO
	H9RaSOEMtd666CWB1YBcucjZ7wgq4rJHs4G6b6T5XcM7kZh+aJTIPbaukUQSeOQ2VB94P5
	8vdjzYPelfcRRmKs9yRCaFRx6LWJNdg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MTaxtZoI;
	spf=pass (imf25.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XEkdmA69WtTXExuZLfEkpZLMXMGJ/f3AY4V8DVXKqRw=;
	b=MTaxtZoIiJej3h8IZ7snzVqdmhJGOS9zscPQpnZ0vogaqBMw9HETbUSFTDv18Uj96JowjH6zy
	YMid6p8Ahvt1PFxAPT9V46WncX8SvkQowBnLorn+Xppf+yh425tHoApzUtORksHMhSpRvKpKs3h
	IBawMCzGrnucixsCnL/u+RA=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXZ6YvVzmV8L;
	Mon, 29 Jun 2026 20:57:50 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 968CF40572;
	Mon, 29 Jun 2026 21:06:59 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:06:55 +0800
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
Subject: [PATCH v16 05/18] arm64: ptrace: Expand secure_computing() in place
Date: Mon, 29 Jun 2026 21:06:03 +0800
Message-ID: <20260629130616.642022-6-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: xo99f76aw5k39y4rzpicd3dayab5snhe
X-Rspamd-Queue-Id: 61B15A000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782738424-705901
X-HE-Meta: U2FsdGVkX1+GGtQBBI3qGY4dGaQ7IocbrI2qTeQqHdICsEa8iMXI6WxyGs02gyHF8Z3Ei7HJRg/XmFIDafQmyQzRUZIvm/hFdErMhzAfgTdj+yk0tyPGKU3eg782j5TyqrE89B6QFDllDR4iyfKKeElbytdPYnoRKaM5bQpG1V0maddZQHJfLOpZVV9uEwzkCCk9TnJ9ePrtX5b3g2Th0hX27Hlv8++a3D3gud3b3rhgmyq5emLMsDJfiGiNfyMP3El2tnlfV+gddpxXpIuKLdjKcQCQ0GvUQhJAX6BUyP0V9p1sVt5nAffMYyFJElYfCV0FA1J/FfTgHVKn4EdK4CvXOTfmHf6dUaHzcxpsZJ1N7rpPirST/CnuY4YISFuwMbpddj573jZcj5W2RjGDkt2ZbhMMTBktV5WsBCHqIdpYXrTDGHbJs4hSHNrF+RoB01RB/dADwImk0EItW9oc1TaXARhGwnK3x/34Dq1Y+c28TV6cZnRTildmXFQKIUhqlELrBbp8s32C7TsmWenw+z/G14+ykHsQBsX9wBSJJtfs0J2kgKzsBhs6zzYNlyzY4AtYuV/NanrZV9RxUTSiFJw8xIvjo4BecGEGeTLwPy8wjEJnCvGgro06lbpa7a09WOXNvIgZka2cKwgw86gH4BFmgtIyFoMhvyr2urQbGaAsx0ajiTzQowPU9jPYiGEW8NHVtkVqYhGpIyVV/1PAP8s4xFK2hAhbun5YcZruU723RQlnj3MEyQdu1HjXd7QWeAsWXE4s8bl4jRv5vKiji5R59sIh0SPYqXs4PP83tPJbEwBpNODhmF6oUd8NhtMX/5b815C+nrDTDx0EkPIFQpkybn0OVEIOBvXpipunrpsajujum5X8uBp5qwOgMHDkTbNW7LZQewBz/3PhQPUYlaiUQVWRIaDjafwFlQKaQ/9hWxwwSGZAqP3iF3S7TObRU4YIRQwgPpVXh+Mqy+d
 kzaTXBZT
 pjfvehp7som78pJxz5wSE9ZLVW7CvgWdj7/KfpIGaWyBrN/DTeVZlLKjS/6JqCAD30g5OucbLkB5fyUrlfk7qAF1YQD/jSWT4mUn2g81SOg2jbGNmoMQhWo6FbRQ/hUIBpUyJ8ch0wdfJAUUJHxkJRinvAKuYXkLncH9fAfg45jKmwy2f0gLRE8BRmcMFs4GyMBDSVODKqiRAOoV7D53Vpo3lW73AUdhQZ4+px/WLZcdN1Z/BAaTIp8QDUUwmRMfpqcU2zSUg7CRPOpur9ZypyrLqX/Lp9w6fkzs0IK4Rx+BbWEtWU5rdYfhdqhp8lDYmytlb03fVaG97Ltma4AsM9OcsyBzsSGTOqDvvevwa79KqqAvTZLyA+JFbBelhyKMjGMCeLVMDvJEgoDZJPUD7YNykXVTMNNmyUvKkd9Im0SH/pls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor syscall_trace_enter() by open-coding the seccomp check
to align with the generic entry framework.

[Background]
The generic entry implementation expands the seccomp check in-place
instead of using the secure_computing() wrapper. It directly tests
SYSCALL_WORK_SECCOMP and calls the underlying __secure_computing()
function to handle syscall filtering.

[Changes]
1. Open-code seccomp check:
   - Instead of calling the secure_computing() wrapper, explicitly check
     the 'flags' parameter for _TIF_SECCOMP.
   - Call __secure_computing() directly if the flag is set.

[Why this matters]
- Aligns the arm64 syscall path with the generic entry implementation,
  simplifying future migration to the generic entry framework.
- No functional changes are intended; seccomp behavior remains identical.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/ptrace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 863083de37c3..30df515528e8 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -2420,8 +2420,10 @@ int syscall_trace_enter(struct pt_regs *regs, unsigned long flags)
 	}
 
 	/* Do the secure computing after ptrace; failures should be fast. */
-	if (!secure_computing())
-		return NO_SYSCALL;
+	if (flags & _TIF_SECCOMP) {
+		if (!__secure_computing())
+			return NO_SYSCALL;
+	}
 
 	/* Either of the above might have changed the syscall number */
 	syscall = syscall_get_nr(current, regs);
-- 
2.34.1


