Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB633D1268C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 01:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165E36B0012; Tue,  2 Dec 2025 20:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1176D6B0024; Tue,  2 Dec 2025 20:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0546B6B0027; Tue,  2 Dec 2025 20:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E856E6B0012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:48:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79D3451778
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:48:24 +0000 (UTC)
X-FDA: 84176474928.12.4394568
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf15.hostedemail.com (Postfix) with ESMTP id 396AAA000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:48:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2a92kw6v;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764726502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIempqaM8kOBJ+y/E9PeRjl6HxUaDOYzGfVfS5fH348=;
	b=Gq8c5OMKt2rIdM2loDyNoW3cdYkU5TAMRQUlui3wulrA9K201ccw9lar9MACH0z4GW84MA
	SHZMI9vZerMc4FhOZydVoYDzcU64HoZtyfH/cE2SuA1FVMKOU/7jwJEhnaLM2XjDKH3Da1
	Td3wDUu3mRgXq3FzWkA34HVUfAwYjtE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2a92kw6v;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764726502; a=rsa-sha256;
	cv=none;
	b=KsvX+JcgtcKlDcNGOnDlj2p6AZeTZTQn1SexiPzUtK3v1iEiIdeUuhtJyOy7bo5gkUAdrx
	EhXqLsNCJMhWAzeHNs1uarzIuw1da92ScPVPrNRyX2zMSPEzinmqh2cBIOiqO/cF3csr8R
	X+NWJgErf/jmc5+BalcdtwQyz8uN0lI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sIempqaM8kOBJ+y/E9PeRjl6HxUaDOYzGfVfS5fH348=;
	b=2a92kw6vO7F3z660yI8YgpbKmYdDLdJLg/naZks2OKUbRKu8aEOtlsTu+5Qrwp57FyGJtT5aT
	Ad9FbZcuy328yLSaj8FoyvIZ/Izm2J46vkLNzBoF2w5xoarhGS1Zz0TrPCxZI53Fj2LCvWHZoNg
	Dlp9fm2qJPZ37hTiDEglcvI=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dLgTq2tFZz1prKT;
	Wed,  3 Dec 2025 09:46:23 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E082180409;
	Wed,  3 Dec 2025 09:48:16 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 3 Dec 2025 09:48:15 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <torvalds@linux-foundation.org>, <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>,
	<catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<pangliyuan1@huawei.com>, <wangkefeng.wang@huawei.com>, <will@kernel.org>,
	<wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>, <yangerkun@huawei.com>
Subject: [Bug report] hash_name() may cross page boundary and trigger sleep in RCU context
Date: Wed, 3 Dec 2025 09:48:00 +0800
Message-ID: <20251203014800.4988-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAHk-=wg4ZnsfpgXYL5qhjYDYo1Gnssz+VxnKZzHXMEmE7qrnQQ@mail.gmail.com>
References: <CAHk-=wg4ZnsfpgXYL5qhjYDYo1Gnssz+VxnKZzHXMEmE7qrnQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Queue-Id: 396AAA000A
X-Rspamd-Server: rspam11
X-Stat-Signature: e39sedni4ggdejznfqa7jejw7px1t899
X-HE-Tag: 1764726500-887560
X-HE-Meta: U2FsdGVkX18YMAxgrIX5/5BKpCrhmBD+RxQ5PlzPONECa0PmQjLpqMXli1cx/517YzWZCBWi4XmW4dwxENys5GnQYbO4iCfb7SlYB1wJ0TB5Tn04fjobgJtHydvNJpcIivw9TsYF/oS/+BIz6Vdav76qH19afOgGXme1rl/AtcynB/a+JVKFSC+UCTBlvFTGEAiIi7TxIoqrUJjGznKs3v6MgU73fFaMPCpJIBJwjkbycbJMBbRIHgJw6BvsRyqUbZ+OqKEHeK2euwqepHs1JXhcI0lH+VkUMIMpaCh0oKfHZEtrxT41FK88KfJrdedpF57SYXvID+hN7Mfyt33+8Tui23URMSYYRp+hwhVSCYo9fQ4rZvWXiUypHGVGvH5H99F1gQXaWV53YJPPH1XRWkX1Egsm+HKz9ZyPaCT9/raBx+V6NQfp+HRae79KWAA5m8bhveuySf1/LD1WOKxnMea/auIpWMqpJ+AgVgS4ecmT5jT3sgnE5F+pN3bb6vVcoVuHWmQU93Cbsea8FhTZ7EgC/4ynoq1LHR1ufKlYq9AsZOkSiMsP/ELA5erzrRg5QS3sfUSjBZYRWXF/T8da7GlJlkTQDCwdZ/qwyaCGCcuM7pdnYhlO2PVjXstAtecmMmaXJ4wQvum+uaszp+z4cHJ/HkSJkeE/fje75Nz+mz6ao6DwlmTi6qLQuPW1OVSwRaHdiEQUIcfbOYVmOBfVz2VWwv5ECrKN24WA1HeLWN7KgB4RrMTMWI16ovhWbl6ukr2wObRH3hMGgytr3UMNBB+V0rd9OnWxjrVHCiFYHEtJQbXcI8kGG+fLbRZa77fwIsFpICu3maxZf/iPiwyyckwkUVBiHzG4eQ1IeXVPD5rpwfxzLqvd6Nps4/y+wliQlNt7mViOzDVbr7or+HKhvNnLyVn5PXwN49tuIQcSLJCpyEK5a6iXCTG5hGweR6Li8c1SZYoVlpF9vyjiimZ
 ArlhN/Tt
 f6jNIvm7Yk2jU4Z7zNeaIo4JkrCvvpw8+kyIDbeItmrPTdnlIDZleg3S0SkM64SeRipckkWYpYGEGJk8JumxIV+wutH3QFvCH6LW8wyABF0Ey5916Kki9GRWYa0Be5YvnLT39iXsUywgd0a/VlwdYRyx4J3NeIxPN0+1T5jRbuSw2t4bxTsuA4MMNUcxpxb0VEqfMIQxtZCN7yfQ8rQPfAC3gKerbX8rz/H+CO1ksJ4o2Ez2uG/dl228omj7yKWrIyUSDEuL5DeCXfyfQMNl++0wbV26BkHC1fjVgZ9NsHP/bOCKzdSCTluowSL5EWplqF4lXYAbbvUypV7Vzx3pQFn2uoIOHUp3AAgvMSIfwByVtXSad5fkhmkOJVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Dec 2025 14:07:25 -0800, Linus Torvalds wrote:
> On Tue, 2 Dec 2025 at 04:43, Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
>>
>> What I'm thinking is to address both of these by handling kernel space
>> page faults (which will be permission or PTE-not-present) separately
>> (not even build tested):
>
> That patch looks sane to me.
>
> But I also didn't build test it, just scanned it visually ;)

That patch removes harden_branch_predictor() from __do_user_fault(), and
moves it to do_page_fault()->do_kernel_address_page_fault(). 
This resolves previously mentioned kernel warning issue. However,
__do_user_fault() is not only called by do_page_fault(), it is
alse called by do_bad_area(), do_sect_fault() and do_translation_fault().

So I think that some harden_branch_predictor() is missing on other paths.
According to my tests, when CONFIG_ARM_LPAE=n, harden_branch_predictor()
will never be called anymore, even if a user program trys to access the
kernel address.

Or perhaps I've misunderstood something, could you please point it out?
Thank you very much.

What about something like this (The patch has been tested):
```patch
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2bc828a1940c..af86198631c5 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -183,9 +183,11 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 {
 	struct task_struct *tsk = current;

-	if (addr > TASK_SIZE)
+	if (addr >= TASK_SIZE)
 		harden_branch_predictor();

+	local_irq_enable();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
@@ -272,6 +274,24 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (kprobe_page_fault(regs, fsr))
 		return 0;

+	if (unlikely(addr >= TASK_SIZE)) {
+		/*
+		 * Fault from user mode for a kernel space address. User mode
+		 * should not be faulting in kernel space, which includes the
+		 * vector/khelper page. Handle the Spectre issues while
+		 * interrupts are still disabled, then send a SIGSEGV. Note
+		 * that __do_user_fault() will enable interrupts.
+		 *
+		 * Fault from kernel mode. Jump to __do_kernel_fault()->
+		 * fixup_exception() directly, without getting mm lock and
+		 * finding vma. The interrupts are not enabled but it will be
+		 * good, just like what do_translation_fault() and
+		 * do_bad_area() does.
+		 */
+		fault = 0;
+		code = SEGV_MAPERR;
+		goto bad_area;
+	}

 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))

```

Thanks very much!

