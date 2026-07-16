Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D5D8C44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 01:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0126B0088; Wed, 15 Jul 2026 21:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461276B008A; Wed, 15 Jul 2026 21:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3504A6B008C; Wed, 15 Jul 2026 21:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 035D66B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:42:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 856DB1C02C8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:42:50 +0000 (UTC)
X-FDA: 84992940900.30.7BB97B4
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id 74AED1C0004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:42:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ftree1wa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784166168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0YLltPeizTaHD27Fn9ffDythfCLu2l1zT8h2w1jiMvo=;
	b=i4tHf/J6pBeripUOQYGCyf57YB0H5vWJizBbP37Q+mqSymilnUBc/5O4yzbna5tciCakZX
	DhP00FbOAWYjOcLg8ylYUisQkID+BsBvNvGJfkPaZXimNamxW9kfJH18Si9zQWxiRfYK2q
	eRJM+L6YPCcr1UsNdHHpU72GJkal+JI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ftree1wa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784166168;
	b=iDyPL0KRqL4Xq6WIrVd0Yft4KiyHpfgs1TL5+YUsDnU2o1aMt3F0ZGJphkbof8XhUgCdla
	O9Zwx7At6JjLWX8C39ZtsWMVdrJMeSSf1cd6OVN8AbYBcbqKbeNjm7SjNdPu7ujrx99plr
	ZNSAIRbs5UMllVo+yb9uNJzUwmsna2Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0YLltPeizTaHD27Fn9ffDythfCLu2l1zT8h2w1jiMvo=;
	b=ftree1watZKga8gU6wNb3X37dDAZx5DBaRpXyIo8dK0PIG+r09OhTLrWbAP+EFMyiLl/mhOg9
	wvg47lyIbLvIW25CzZlR/ByYnfIQdNM0i837uVWZP+z0naeGcDqad6oLoyLkpVWq/iwXfJUX62J
	QYVKNY6oWx7GuSbjyXwVDFc=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h0wXv2KqQzLlXT;
	Thu, 16 Jul 2026 09:33:19 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 14F3940572;
	Thu, 16 Jul 2026 09:42:38 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 16 Jul 2026 09:42:37 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>, <ljs@kernel.org>, <akpm@linux-foundation.org>,
	<xiqi2@huawei.com>, <david@kernel.org>, <linusw@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <will@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <sunnanyong@huawei.com>, Xie Yuanbin
	<xieyuanbin1@huawei.com>
Subject: [PATCH v4] ARM: mm: acquire mmap write lock around show_pte() for user faults
Date: Thu, 16 Jul 2026 09:40:22 +0800
Message-ID: <20260716014022.2823-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: net49kcd7t5dfzegpmg5ybf44bw3cp94
X-Rspamd-Queue-Id: 74AED1C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784166167-856233
X-HE-Meta: U2FsdGVkX18LdQax4Sg598CNTJV78c7yJDyKJyuiOiFKL/sUPeSoFymuB6NvLibUM1ebf6tjbxobRNgrTimQcruTJEQCCSWdqyHT7hQNyq4zwKDw6fcR5FsPPeAaUDG7ZGpaJ/M7J8C6OibVieV1vIaO+lE8rczqZIKvhsaHWvfcnQmgH7KMbALWZQbo7xNehos1SfydtMnRdZvCVTSu4FC+ELo+HTGYITd5smBmPpZ7+OsnsbXw1TGqsaFFM79EMK+KYSOOrtJ+g1LvCXHRzfXp2QrtNXyvpNE20csZSYivMOn+UPCJE8wG22Y+WeYCk23R6um37btcYToVMlC7PPrKyCiCgffv8QJ/aoUNcWvFAF57ZtUmPdb1tOM9ab1D0Ju0KwRUBz5HF31In+eOMwEahvcAickQepjd/Q6tWdy8JLdWA2clKhvs/3LvZ0NHyybRhvlY8e50fAjykg207LWvaKYu0/LwFXLUE20rVRK5gkUIY3fZN9OBNMiXabXoPWD5VwE1TFGlvqAsfHDcdD5vBiOq2k3RimJMcMQHrmy/kxgvzAiSbKDCzS9QD4+f6lZtCAczTY8mFUD8AZsvNMSCNgo6xHJGWyGvppbJEDwG4gUfw/hgnMAG7+3dgHjFRdtgTl3z5mST87LxVA0Pb9i3iieWJ6YxnWOAOKNEIH9P/SxQY3cWgvBQETXzaXl4unfzH2XHXcIkDV6pwDoTkp9ma8G5OfvET5DQUbT8EUdnc4KH23iZod1H3QdtpTu0Yqkhogko4xMqKOgUSiqHi+p/N6iOHbwHIzvnw8qg0Ulpa2gq/f5LwPWL9mXgT6x5zuNk/DPKWtJqu6NAilNQE/muFkt1HoRHGIQaaHDwgnUHKuEY8xfoDcxPxx31FKbxBoVpILd/Ty5wWIu7EGzL+4MZ45lxBcyNZZUtTezLf8gq4DPtdOSQlJEIopdCWsEgG5QkzjX1fghVmWzHL5i
 WHHxnZ4J
 YZcUTv/3KGaFzLTdZjelDubRf925bLciWKewEqt/Zy1DADNZ8MQYf86L4a+XC1xNKtna9k1YMT5haIy3yAR0uOWYns7yz+ZeFOFQa+nwrAMhsiiekv8H0lPt31t3T9D0vJJaMWPNmFx/0yeeMxnkxrQSK/Vx7iWMjSI+KoGGNwdUCjxNS/QZZ3lCKXlDrFzuIf/D33awtvjRyFhBPkZBV84Gho8IKxsO9UvlAySA5qlyexRylzPTAWNee58NVFPsagOBtJKGXZz7F2t29UI/BRBIojuXlloqBcQvhWamRfUwUvHzQvUbuzlS0g4T7KjFwWbQehiNo4EL+wWUaE5VX+gobOXRQrSOasHkWtiaaIrD8ZqWuVAHPhV0uZDYxf0PVgmCfj7k3Afhw/OL/4PERUYKRwgc6pzJCj09R/Fpi6Dnzxaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEBUG_USER=y, and cmdline "user_debug=31" is set,
a user fault may trigger show_pte() without any lock.
If another thread in the same process concurrently calls munmap(),
the page table pages may be freed while show_pte() is still traversing
them, causing a use-after-free in show_pte().

If CONFIG_ARM_LPAE=y, this may cause a kernel panic if the pages table
of PMD are freed when show_pte() is running.

Acquire mmap_write_lock() around show_pte() for user faults to fix the
contention.

For user faults, additionally restrict that show_pte() is called only
when the addr is a user-space address (addr < TASK_SIZE). This is because
the lock of tsk->mm only protects the virtual memory of user address space,
furthermore, dumping the page tables of a kernel-space address for user
faults is unnecessary and may have security implications.

Keep everything unchanged for kernel faults, because the kernel is
already in the "oops" state, acquiring a lock may risk a deadlock.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 6d021b724481 ("ARM: dump pgd, pmd and pte states on unhandled data abort faults")
Depends-on: <20260629123349.134224-1-xieyuanbin1@huawei.com>
Depends-on: 59e4f3b45b96 ("ARM: ensure interrupts are enabled in __do_user_fault()")

Cc: Russell King <linux@armlinux.org.uk>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Co-developed-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
For __do_user_fault(), it must be a user fault, so the
judgement of user_mode(regs) can be omitted.

For do_DataAbort(), it may be a user fault or a kernel fault. If it is
a kernel fault, it must be a kernel oops, the kernel will die soon.
Also, a user program may be constructed to trigger
do_DataAbort()->show_pte(), as described in this mail:
Link: https://lore.kernel.org/20260625100031.25088-1-xieyuanbin1@huawei.com

For user faults, it is safe to acquire mmap_write_lock(), because
we never return to user with mmap lock held or pagefault disabled.

Note that, due to the lack of ARMv4T for testing, this patch does not
fix the issue in baddataabort()->show_pte().

V3->V4:
  - Keep nothing change for kernel faults.
  - Change mmap read lock to write lock.
  - Restrict that show_pte() is called only when the addr
    is a user-space address (addr < TASK_SIZE).

 arch/arm/mm/fault.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index c68677503532..0a09d4ff7718 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -174,21 +174,25 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 	struct task_struct *tsk = current;
 
 	local_irq_enable();
 
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
 		pr_err("8<--- cut here ---\n");
 		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
 		       tsk->comm, sig, addr, fsr);
-		show_pte(KERN_ERR, tsk->mm, addr);
+		if (likely(addr < TASK_SIZE)) {
+			mmap_write_lock(tsk->mm);
+			show_pte(KERN_ERR, tsk->mm, addr);
+			mmap_write_unlock(tsk->mm);
+		}
 		show_regs(regs);
 	}
 #endif
 #ifndef CONFIG_KUSER_HELPERS
 	if ((sig == SIGSEGV) && ((addr & PAGE_MASK) == 0xffff0000))
 		printk_ratelimited(KERN_DEBUG
 				   "%s: CONFIG_KUSER_HELPERS disabled at 0x%08lx\n",
 				   tsk->comm, addr);
 #endif
 
@@ -632,21 +636,29 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 
 	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
 		return;
 
 	if (likely(user_mode(regs)))
 		local_irq_enable();
 
 	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
 		inf->name, fsr, addr);
-	show_pte(KERN_ALERT, current->mm, addr);
+	if (likely(user_mode(regs))) {
+		if (addr < TASK_SIZE) {
+			mmap_write_lock(current->mm);
+			show_pte(KERN_ALERT, current->mm, addr);
+			mmap_write_unlock(current->mm);
+		}
+	} else {
+		show_pte(KERN_ALERT, current->mm, addr);
+	}
 
 	arm_notify_die("", regs, inf->sig, inf->code, (void __user *)addr,
 		       fsr, 0);
 }
 
 void __init
 hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int, struct pt_regs *),
 		 int sig, int code, const char *name)
 {
 	if (nr < 0 || nr >= ARRAY_SIZE(ifsr_info))
-- 
2.53.0


