Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40AFD116F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 12:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77A66B0012; Tue,  2 Dec 2025 07:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B017B6B0024; Tue,  2 Dec 2025 07:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8F86B0026; Tue,  2 Dec 2025 07:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 878836B0012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:43:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 168EA1DB1D1
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 12:43:53 +0000 (UTC)
X-FDA: 84174497946.05.027923B
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2098920008
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 12:43:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=A0MDWDd+;
	spf=none (imf13.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764679431;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pz/V+JN/TaTGWZf//BDpclVF4cfp93h5KOPZd7Eqkp0=;
	b=1Et4UXncL2yUUSq4lh1sy3ER42kc96eL7s604RHZ2PBVqL/z1Q1LhWZwlMTvibauhMhMKj
	9mJt/km1AF3Y+EAIntMXrG4EUdQXQtUhf5pn3PigfIV89zqVd20vw8nk1Ek0MHJ8v3dwnc
	5pCaLbFci2vvdmNYbgJ+mJ2fSjctvHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764679431; a=rsa-sha256;
	cv=none;
	b=jyv1cdEMwlbkjodIrulahVgY8myhELhW4Wpu3LFcjhA0YCvreVOFW41ampRBjwa0GVqtHV
	l4LfdDxU8hdYyDS+TQYzV1+VEvzZPFgDL4FGtAHXBn3OBJUNBkOupYqFlabziLhXHwrimz
	ssg4ATSWCuSEqk3LqHm4MI1Eu+4hvfk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=A0MDWDd+;
	spf=none (imf13.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pz/V+JN/TaTGWZf//BDpclVF4cfp93h5KOPZd7Eqkp0=; b=A0MDWDd+gqUx3aOH3D6ksP9xwZ
	0REuMbfigE3bF6yA8RA08z27Bl6rVUAQsoiTH//L777avZYe2w+QUnKfhu5n377I5P7YW/6Pz6ZoU
	rd9NmrSMObrxcStlE1mr+X0cbbZW2TsAsetc63JhxzKLEoywsWcf8CWB9EYnkG8S8J3yK8P5MSKlm
	jAfrjf/T0qB4X0Jfyu9ifSydqLyDVmuiiIb3gDtsVPNnAAGMMXOeGcW9s2j2/uE7QK+H9PQ6cILUy
	TpKxptt1g9WU7kv7H9wc/fE8na7giqk54+0S1Q3rnxPUu53G8r1PHMFfhIxp8LD7EjiT6p7/EXv4D
	6LH+Gdcw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39162)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vQPjF-000000001hN-1Z9W;
	Tue, 02 Dec 2025 12:43:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vQPjA-000000007Sl-2MI3;
	Tue, 02 Dec 2025 12:43:32 +0000
Date: Tue, 2 Dec 2025 12:43:32 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zizhi Wo <wozizhi@huaweicloud.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, jack@suse.com, brauner@kernel.org,
	hch@lst.de, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	yangerkun@huawei.com, wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aS7e9CbQXS27sGcd@shell.armlinux.org.uk>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
 <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
 <aSgut4QcBsbXDEo9@shell.armlinux.org.uk>
 <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2098920008
X-Stat-Signature: berxk54yzy4rx9jszyiuqetd138pgpkn
X-Rspam-User: 
X-HE-Tag: 1764679430-247971
X-HE-Meta: U2FsdGVkX1+kFn+MA1DLljt/kF43vnKOwzIckMIm/X9qHyEcnsvPslbLTJ2S7SUtXhnYxONlyydVvWIArUT/pAjlIKyscJLW6ooa5hUUqQ2JTGjxgAeU3nfq/pH1jFDFHPy/tWAiiiA0MJk6wgVHgJhAAOrwI8SERMS7GUGpbUg8a6pI50zpBIjeqDVwijhUQBAqCtgU6x450RVUhQtdySHUjmofHr/CrrdeiscTIIaiv1moiOVOHj7m/EW9MqqVfkXsbE8SG9HMYr8WdOdADIvSBbTN8HL4CMQEoZv+c762ZhufKSqpjvjbYb77xQ2aFMXZCzY7YZIS/Ik1qRkJvXKkRy9cKcDhAIFy0on2mBXCPjq9qOo/F9QZkvArHyQLt7tAEFumcSDEIAoFiIFF7Mk3veJFqAZHQVGju+USvUYgaKwtuWdAVn+IDLJTXtyPZ1j5T2tFFiCqq93/0y5oEQy5fdoaz1lqzqaCHnMo5hT7AvHRyAceZ4Xh2itt4sGUzqqUim6JtdhVI2nw4a7sKZ4nuR7gs8uESyhqz6EzaA/4mbCB3lbChO3JT/MoA3cYkcDzFJHFtiGWfR7nZTaFI5SN5AyKpupoB0ET2VY46CTAjWD7Z0KPAQg01/Lb86Pm8vN1140rRmvi+KbGtsG1G2Hkp9ynywMnq/Y9Z3s03+t/xQ002Gso4YJNJsl/en3rKAmjVNpRs+AmldEzCpnDorJzIaj72SqVjg+N5RIsDVr4iI3uGGz9U7YnXPBln9D0ldoRj1Nnnw5WxclLu/uRNAgDhiy3aYpPd1Wz9PBoKkMYe/JRfHUMWPzEYSRA/AizTdPP02X5yUej0ZAOwEvxFOMSNinh1pkjpPYbaFDZJ1eBctzLfIij6vURv5O3UomRCodWFbRBV1JPHi2uz6cETJqvQIi+/gqUw6C7ihFEpu9pTbcP4FA8TGUIBDbSt/gAcCOFwmZObea+uznbi+W
 e8Pln0za
 RVSV66zExxo3jVBZ1s95L7Qwyo+83lVch0bcHXj+Pw8RWIDyygTMsAaumdF8qYc06kzGeN533MTAbhdxR3IsyvXknRhFv4LTcO5o5V9rSMYTa3KMZw8xxC+nIjjU06MfRWqnXo1iin6zBdinsf0tSg5Hw/ZmDs2L3fQt+8Tc3FW4D6AnPp6PtR+ULZNjFg1kbmDpxtZ41I5REtzVW4spJpnaWj2DkZb1CtjfNkQ132gCSYwVva6duSwNXlO/Y8xX+j06usw/vF6MWINY2xQAdw7LVz67jIcIETckKOnjynC+NdHdkBjZD7Xr6NbtH97is7jrWFYCNlxu2HHRmjs0xPGK7voOWxKun4RNves3lDe3QV9OnIvunMmSVdq6g51lodEPUuFHvQY7aPNxF3VEgwN1teq556SwV3Ner4jorWv3W9+bWWCV2/OzHLadkLiPTdwlTONHXOGnkaZrQmb60ZCsJlGRqzf5Bo1aM40z42sSPKCnQtf3+4VDlVZZiOXvpwl/xxoymq8FIOiQpjD6xdaliUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 09:06:50AM -0800, Linus Torvalds wrote:
> I don't think it's necessarily all that big of a deal. Yeah, this is
> old code, and yeah, it could probably be cleaned up a bit, but at the
> same time, "old and crusty" also means "fairly well tested". This
> whole fault on a kernel address is a fairly unusual case, and as
> mentioned, I *think* the above fix is sufficient.

We have another issue in the code - which has the branch predictor
hardening for spectre issues, which can be called with interrupts
enabled, causing a kernel warning - obviously not good.

There's another issue which PREEMPT_RT has picked up on - which is
that delivering signals via __do_user_fault() with interrupts disabled
causes spinlocks (which can sleep on PREEMPT_RT) to warn.

What I'm thinking is to address both of these by handling kernel space
page faults (which will be permission or PTE-not-present) separately
(not even build tested):

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2bc828a1940c..972bce697c6c 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -175,7 +175,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 
 /*
  * Something tried to access memory that isn't in our memory map..
- * User mode accesses just cause a SIGSEGV
+ * User mode accesses just cause a SIGSEGV. Ensure interrupts are enabled
+ * here, which is safe as the fault being handled is from userspace.
  */
 static void
 __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
@@ -183,8 +184,7 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 {
 	struct task_struct *tsk = current;
 
-	if (addr > TASK_SIZE)
-		harden_branch_predictor();
+	local_irq_enable();
 
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
@@ -259,6 +259,38 @@ static inline bool ttbr0_usermode_access_allowed(struct pt_regs *regs)
 }
 #endif
 
+static int __kprobes
+do_kernel_address_page_fault(unsigned long addr, unsigned int fsr,
+			     struct pt_regs *regs)
+{
+	if (user_mode(regs)) {
+		/*
+		 * Fault from user mode for a kernel space address. User mode
+		 * should not be faulting in kernel space, which includes the
+		 * vector/khelper page. Handle the Spectre issues while
+		 * interrupts are still disabled, then send a SIGSEGV. Note
+		 * that __do_user_fault() will enable interrupts.
+		 */
+		harden_branch_predictor();
+		__do_user_fault(addr, fsr, SIGSEGV, SEGV_MAPERR, regs);
+	} else {
+		/*
+		 * Fault from kernel mode. Enable interrupts if they were
+		 * enabled in the parent context. Section (upper page table)
+		 * translation faults are handled via do_translation_fault(),
+		 * so we will only get here for a non-present kernel space
+		 * PTE or kernel space permission fault. Both of these should
+		 * not happen.
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
@@ -272,6 +304,8 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
 
+	if (addr >= TASK_SIZE)
+		return do_kernel_address_page_fault(addr, fsr, regs);
 
 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))

... and I think there was a bug in the branch predictor handling -
addr == TASK_SIZE should have been included.

Does this look sensible?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

