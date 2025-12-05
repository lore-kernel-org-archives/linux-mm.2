Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AEC8D2F7E7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 12:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F9A6B0147; Fri,  5 Dec 2025 07:08:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FE66B0148; Fri,  5 Dec 2025 07:08:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307B36B014A; Fri,  5 Dec 2025 07:08:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14E036B0147
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:08:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDCEC59619
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:08:39 +0000 (UTC)
X-FDA: 84185295558.23.949038F
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf20.hostedemail.com (Postfix) with ESMTP id 791011C0018
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:08:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=JrZon1c+;
	spf=none (imf20.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764936518;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOqOO1RkHv+TL4sHO2I/M94wigINI1Cn0aqofm8+DJM=;
	b=0p1QSa7Q7bV5w60ksSB2x84BqzbrsVM1OSt/ke6zOAeKZzSoOXmzRugMesS2Ha4LKzj8ck
	KhvYbRjTu36xZCYqGinavLcysVWPi3ceH1+FKBUsZmrrZt8hh7i171ks4ypF3SZHRUIy0I
	pPD+caEWgLdILF3g7yyycv9UcdtxfKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764936518; a=rsa-sha256;
	cv=none;
	b=wo9D9ylgq/Ymc3QxdU68tyeHxVBfN2nmTyYyjDy08/Q1o+mDiByO80IZhtunWFgUc7gfow
	kuo3KzzSGOxkYhNvPSbetYAGuJ2IZXWgtfdborRi4CzDI4HW11OU2b0kbHsuZcIOER29lL
	VeBGuSGHTsh9ZpQmoV5AvCw+ZYrEZdY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=JrZon1c+;
	spf=none (imf20.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qOqOO1RkHv+TL4sHO2I/M94wigINI1Cn0aqofm8+DJM=; b=JrZon1c+goGZ/cvJPITZz+HQAG
	H8Glqh4GmzB4ynFJAlqotxWYu/at+K2gILu3ugTSYfgyyA9nlgkYCOH9DsRXqv3mk+Id9XnDEeOyo
	KPPF7riTyhWttscjHg/UmGw+FFzHJ+L3PDkBoL47BA7n8mYjoZSHW/H/o341Ym97v+olzn/mai3wg
	jtud26oX+CTo/9jlt8VAMQYI2a5VHeGTe/kcmC2pGu8768drFMpPega2QiNq3vkswcBw485F65wHM
	TiWeqs1otv1R5KDD6QrYP4z85DZ5jaJokaX/uCSIHMgPaKqDiJ87vv2t31h78rMOxahMYDXcOxl2s
	+bhzADnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53922)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vRUbi-000000004aX-0Y8R;
	Fri, 05 Dec 2025 12:08:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vRUbe-0000000025R-1Eju;
	Fri, 05 Dec 2025 12:08:14 +0000
Date: Fri, 5 Dec 2025 12:08:14 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
	brauner@kernel.org, catalin.marinas@arm.com, hch@lst.de,
	jack@suse.com, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, pangliyuan1@huawei.com,
	wangkefeng.wang@huawei.com, will@kernel.org,
	wozizhi@huaweicloud.com, yangerkun@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aTLLLuup7TeAqFVL@shell.armlinux.org.uk>
References: <CAHk-=wg4ZnsfpgXYL5qhjYDYo1Gnssz+VxnKZzHXMEmE7qrnQQ@mail.gmail.com>
 <20251203014800.4988-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203014800.4988-1-xieyuanbin1@huawei.com>
X-Rspamd-Queue-Id: 791011C0018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: bxxn8buq3yuagtb7aisfiq1oniez9t6w
X-HE-Tag: 1764936517-275199
X-HE-Meta: U2FsdGVkX1+zJqEFBRP0LPYz4RFjLj4/kti2HIXOeDDy+m0eoqgi6VBW+t75l8123DGBGfBT+higy9rRdUAnUpL9263DZdIJq6w3UzifkwKnUHqxtgEVwRtGef508SRgWfuH9/ruo7HJWrRn7BurcS+vJz2qM+9QYtaEqaVg5C64a3zn/8uPWbB9v0NiutXFPw/Bg6YsDPgrs7fCQRQA5WCgZWNvXSCcuYyZamBHsQZwZA4kPUwDVBnaRl5PRlMttpC1HLIHpws4iVuMcbIKefYkMQP0RZfO0GnJWcHKobFhc+AqKCIzfGsVzssWGsyxSOJ4EpiGUYMMC3DUgj8qioRg8lXYmyhuNh/WtjEK1hxT2w+z3ZcXSKSQP74ZVdvm4oFWx7nsDAGADNGxtU/iKHCcHGbE0P3eW4lIC8UrI7cJ7dn0RyaC1uYQ0IK4N9FqRTaXRuGdXZp3faGHLT9jAOHElCsmEI5GUzCpRWn4CmXcpOMikS8LIH1bzKunbbgcRBYq6QHefIQ49flQrGXBbQeGQZ1SWlXTK2CzhRaZFMtAJRCFhZ63YoSGlot1vcWTzu4an3OapfCkYtovD5anFrrL4/PNMhjd/aBQlb5GTRhfwJt35pwNitoZzYR4v5zGtZoBVncKWvzLG1n+00gcmfKCRjPJwS3N3i72jez3X0YNFcfXk/dahKxY+exLB6FBhv7mQ/eDl/1a6MCfIooPKZrCTEhltjETaHfjLmxtOGIgsySuanYxok4FLTqFLS8rBSH31UDlZ80TobvUy5j/qxGVZAFLM4gVit0i+erH0tmZb9ORk+JJHCnlSn0XGzxqrFeFM6SwraDdeNO2HWb8Ni7URp8EOFv70+nxs+CHhK3vtZ8VtITL3s+gsin9oRUWzRrYOuNBf/CSGbeNlCcUCRtLm6zCAXzwW1SWzIbOA07cTaz3kEd/8wGgSVS3dmIeQLZkYsz7eUAWrn9sLtV
 IA+0dmh7
 q8PZTuAhEeFOwV1zeE4H8TmPJBcoruYPbCazz3viVG+dkkc/iu1ZdR9Szkh+JAUdrST6afhpHXyQuWRE2m+G8dVvpfeu8VNjfwupSsMWDLP2EKwbJHKpDg48ugiPUWf/fpUqctFV3SeYM41JFRD1Iu0AFSjVlPzxxnceEuufxlYKNK2McY9wpqw4JZa0AXDmcmtfqU15AN18GsJmJvOeGNaqgBAMdITta5+EpChipvimKT36yX9nEW2uHlT7VMvpPo8i01vRCEvecwmWnQICeQtNuap4/2XpxlsFPKSnuF9bwlBnMxhGBTcdnPTYaobFVJ2aSly8/0AUuOhEp1RfgXI/e0/6bZusIa0v41Ee47gd27uGnqrmIrKr8h9j3+vjs3upTVkqw6yU/su7YtS+bccphwiqV52ylQwSYpoOiWddJ3SqnUpTXdig2KCWTVsxTDPJ6ysZ2ComEGTYbLG5bXlkB3qPyX05cAWMNxtHug8Z6rE9gzLz7g8MntG53/hgqwKPYrJS2TzOBm+f6+543R9KntLPIv3tj8dmUmjuYsxRZvUYTNNfbd3LHxBnIXgWutdhG0yhIKoBbLS3hZRHbclqe4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 09:48:00AM +0800, Xie Yuanbin wrote:
> On Tue, 2 Dec 2025 14:07:25 -0800, Linus Torvalds wrote:
> > On Tue, 2 Dec 2025 at 04:43, Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> >>
> >> What I'm thinking is to address both of these by handling kernel space
> >> page faults (which will be permission or PTE-not-present) separately
> >> (not even build tested):
> >
> > That patch looks sane to me.
> >
> > But I also didn't build test it, just scanned it visually ;)
> 
> That patch removes harden_branch_predictor() from __do_user_fault(), and
> moves it to do_page_fault()->do_kernel_address_page_fault(). 
> This resolves previously mentioned kernel warning issue. However,
> __do_user_fault() is not only called by do_page_fault(), it is
> alse called by do_bad_area(), do_sect_fault() and do_translation_fault().
> 
> So I think that some harden_branch_predictor() is missing on other paths.
> According to my tests, when CONFIG_ARM_LPAE=n, harden_branch_predictor()
> will never be called anymore, even if a user program trys to access the
> kernel address.
> 
> Or perhaps I've misunderstood something, could you please point it out?
> Thank you very much.

Right, let's split these issues into separate patches. Please test this
patch, which should address only the hash_name() fault issue, and
provides the basis for fixing the branch predictor issue.

Yes, at the moment, do_kernel_address_page_fault() looks very much like
do_bad_area(), but with the addition of the IRQ-enable if the parent
context was enabled, but the following patch to address the branch
predictor hardening will show why its different.

In my opinion, this approach makes the handling for kernel address
page faults (non-present pages and page permission faults) much easier
to understand.

Note that this will call __do_user_fault() with interrupts disabled.

Build tested, and remotely boot tested on Cortex-A5 hardware but
without kfence enabled. Also tested usermode access to kernel space
which fails with SEGV:
- read from 0xc0000000 (section permission fault, do_sect_fault)
- read from 0xffff2000 (page translation fault, do_page_fault)
- read from 0xffff0000 (vectors page - read possible as expected)
- write to 0xffff0000 (page permission fault, do_page_fault)

8<===
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] ARM: fix hash_name() fault

Zizhi Wo reports:

"During the execution of hash_name()->load_unaligned_zeropad(), a
 potential memory access beyond the PAGE boundary may occur. For
 example, when the filename length is near the PAGE_SIZE boundary.
 This triggers a page fault, which leads to a call to
 do_page_fault()->mmap_read_trylock(). If we can't acquire the lock,
 we have to fall back to the mmap_read_lock() path, which calls
 might_sleep(). This breaks RCU semantics because path lookup occurs
 under an RCU read-side critical section."

This is seen with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_KFENCE=y.

Kernel addresses (with the exception of the vectors/kuser helper
page) do not have VMAs associated with them. If the vectors/kuser
helper page faults, then there are two possibilities:

1. if the fault happened while in kernel mode, then we're basically
   dead, because the CPU won't be able to vector through this page
   to handle the fault.
2. if the fault happened while in user mode, that means the page was
   protected from user access, and we want to fault anyway.

Thus, we can handle kernel addresses from any context entirely
separately without going anywhere near the mmap lock. This gives us
an entirely non-sleeping path for all kernel mode kernel address
faults.

Reported-by: Zizhi Wo <wozizhi@huaweicloud.com>
Reported-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Link: https://lore.kernel.org/r/20251126090505.3057219-1-wozizhi@huaweicloud.com
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 arch/arm/mm/fault.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 46169fe42c61..2bbec38ced97 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -260,6 +260,35 @@ static inline bool ttbr0_usermode_access_allowed(struct pt_regs *regs)
 }
 #endif
 
+static int __kprobes
+do_kernel_address_page_fault(struct mm_struct *mm, unsigned long addr,
+			     unsigned int fsr, struct pt_regs *regs)
+{
+	if (user_mode(regs)) {
+		/*
+		 * Fault from user mode for a kernel space address. User mode
+		 * should not be faulting in kernel space, which includes the
+		 * vector/khelper page. Send a SIGSEGV.
+		 */
+		__do_user_fault(addr, fsr, SIGSEGV, SEGV_MAPERR, regs);
+	} else {
+		/*
+		 * Fault from kernel mode. Enable interrupts if they were
+		 * enabled in the parent context. Section (upper page table)
+		 * translation faults are handled via do_translation_fault(),
+		 * so we will only get here for a non-present kernel space
+		 * PTE or PTE permission fault. This may happen in exceptional
+		 * circumstances and need the fixup tables to be walked.
+		 */
+		if (interrupts_enabled(regs))
+			local_irq_enable();
+
+		__do_kernel_fault(mm, addr, fsr, regs);
+	}
+
+	return 0;
+}
+
 static int __kprobes
 do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
@@ -273,6 +302,12 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
 
+	/*
+	 * Handle kernel addresses faults separately, which avoids touching
+	 * the mmap lock from contexts that are not able to sleep.
+	 */
+	if (addr >= TASK_SIZE)
+		return do_kernel_address_page_fault(mm, addr, fsr, regs);
 
 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))
-- 
2.47.3

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

