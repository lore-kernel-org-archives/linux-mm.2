Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDDFC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15596B0092; Thu,  9 Jul 2026 02:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EECE06B0093; Thu,  9 Jul 2026 02:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBD36B0095; Thu,  9 Jul 2026 02:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6DDB6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:37:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 349191C83ED
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:37:20 +0000 (UTC)
X-FDA: 84968281440.15.87CB5C3
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf24.hostedemail.com (Postfix) with ESMTP id 24CB2180004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:37:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ktnvhwnt;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783579038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nx9uTIIpEYlLKn/TlkCDaDRFao/mdFBZNp54PrQsjPw=;
	b=uyvv7U9JKmde9jTuCS7sPx3cWgpfICgDUGzbjIYBhyaSlevjWLCLWAq9duqkrcs3oOsSr4
	wxCb6Q1N82pf/HplRgTM+ZBOajv4rGqg3qFXz90zSrGGCw0wDdoN5/IBeuTnrhE1N3q04a
	6zeEU6fWZqPhxxRiscPPsrfKSv5YPDs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ktnvhwnt;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783579038;
	b=FnxJPlVNIWqvQ5thy67sR73nZ2NNNimfvsRKVZLOz/sHKS1O6U17JrY0vox7vYSOKutS9M
	QowEm+glQByFDnwRnXwEXkkxZOdeCi5PXnZtU90gvPvL36RRqbV/P9DHSmgncefpBKwQR/
	zH1Gx6RDNFhzwoH90FLeALoggc4IYvc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nx9uTIIpEYlLKn/TlkCDaDRFao/mdFBZNp54PrQsjPw=;
	b=ktnvhwntGgaRfWEAoNl4nP/eMAv3WF40w6U+rHuISN9Agz4HcuqKVmp7oYolkH1rs7mUNfj74
	gCHhpWuGxUwoXRpbuDGJzqHbbuU4k1jP4vTX4mO+NAfGMKawslgm9u9z/t6vpBkLBD6GuiT0hg5
	ivGaNCxTDm241yTFRway9Ns=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gwlQL0MmWz1T4G2;
	Thu,  9 Jul 2026 14:28:10 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id ED73340579;
	Thu,  9 Jul 2026 14:37:11 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 14:37:07 +0800
Message-ID: <21875fb4-434b-480d-b68b-e2ffd5fff5ae@huawei.com>
Date: Thu, 9 Jul 2026 14:37:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 18/18] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
CC: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@hansenpartnership.com>,
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
	<thuth@redhat.com>, <mark.rutland@arm.com>, <ada.coupriediaz@arm.com>,
	<kevin.brodsky@arm.com>, <linusw@kernel.org>, <yeoreum.yun@arm.com>,
	<song@kernel.org>, <james.morse@arm.com>, <anshuman.khandual@arm.com>,
	<broonie@kernel.org>, <liqiang01@kylinos.cn>, <pengcan@kylinos.cn>,
	<ryan.roberts@arm.com>, <yangtiezhu@loongson.cn>, <sshegde@linux.ibm.com>,
	<mchauras@linux.ibm.com>, <austin.kim@lge.com>, <jchrist@linux.ibm.com>,
	<arnd@arndb.de>, <sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>,
	<jgross@suse.com>, <kas@kernel.org>, <x86@kernel.org>,
	<linux-alpha@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-csky@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-m68k@lists.linux-m68k.org>, <linux-mips@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
	<linux-sh@vger.kernel.org>, <linux-um@lists.infradead.org>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-19-ruanjinjie@huawei.com>
 <20260630172619-6c78c2e2-c2d3-44be-88e6-6c82de12baf4@linutronix.de>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260630172619-6c78c2e2-c2d3-44be-88e6-6c82de12baf4@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 24CB2180004
X-Stat-Signature: 67ab1apfafpakt91fjq19sy69nxpktgi
X-Rspam-User: 
X-HE-Tag: 1783579037-15198
X-HE-Meta: U2FsdGVkX1+Cl2UQI+rXCQesh3XUTZt/i/fciOONky+ZBfUI0clHyxtHd+OE0A3yVLGM5Pm5qgzwHeTTrYOWZnQwt0fdCLQbfPBsVw1wC5u5yifdTPKr/83u93u8E5Ye6povjF9U+wYvOWNYSPcXgbfVe1eemlGGw1SIsAWs66zv1rogTp4cQlzHK9GIXVcKLZAyGyfUmi3D0Bx4xmyEqMfVU4PdDsxHmI09xP15isNxCAQ0/OvSB9863rtVn6XQC6l92duE50STZGjUp8MfThVqQ/O7BPvCrP29PGq2v319Ol8BqabsR4ohSLHDNkAc+pAGP2XCzYkVykq7MRVC4dQlk+LuLyBDL2IEBjfAZykC2SUVhsel8ZrmoUGgvMspw/bfMRMadO29jjsM7wspQAdBywmBewVtcZExvuoMERFOb1T2777ciekxWmgZDv64qmYJqeo5fM59smnA1YMgLsGnyVPSzG/U+V+zLAvgYSJgh4W49QYjtyiFS3b/GEih3A2q8OTAua0AzbEVOTuKKhnZHFQX8vRJNRMpwhguev+NyYbgvBX3WMUBS36SnCzjRxGU/9CiutX4qK9AO9i5VFe/qrephbgIaPEjZZWEIYaFhq87k+iELxU8XuK6aJvuoBLBAe5ZzaekMbUip5eTs2DqIpt3UHgNMk6PjYgyiJAI2GaxzHM67Cw6PLgXwVoVbyEUa1Xt+04g/pAnHpomSJ9RAh1sk+76zWVvzgA8mYT3lQZTtOE3CgErHIis5uzbZAZM/LyS8xQxvfnjn8+8KFN7LEyxbcC2VYpI6n+/xt63KdsiFhUmIYO8LWktlhSjnR8CxvTVDHw0FGlccsUTS3x0eGUsc1atz1mp3pmekZl5AIItQ5Armb/YERbtyXqOTAJr3absEZbhv0rDF8h+iQPPGucgIgd9nruPZA8+hW982D5VHKtX3AuG1PDqHLViwOkBPL8HM+Cw8bK6Ys1
 /Qp6Mhiv
 oWLu9NfLj1Ugy83ON3dIzPA7FsP6NpuhuU724qX/yc83TxPiswgaWZjcbQh7om5c9Xm9DURY2PFCACiRO7/s/ERYqoy6GdQ6IJB0B1OtKasbNSfGED2OGehGbrCe9de/m5FFrVfDBzkF1ZcPeVSPX556pPXKX73FUY4PAbFJQx+EQvPTwtWOf21UP80mTDlenzBh9MEtLZ7KdYsFiyDfNSe8V+IkbO47N7K7LTkqteQXn4aW0tsEqWFiEqbFHRtold8fOjecDTgFeADzw4SexRBF18otVBUpfDc47mY0heHbTIK09AeV/8w0tYrHa27kiKzl1C69jzInimxeMJzHD0+Glfpih5NiCsEkC8VVuG/xCx0L9FnOxs8ZQN1JQQOeBv2deQshUnpL/aKslkQ62Lg+5aLQApHAr43KqXIz/0SXinJ5FRMg8aeafhhp23f/lc2sw1dVLGegSDRe9NDPmuNeHdihez7lFldPKJd0OVxKDK843ak8BJy6ISQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/2026 11:32 PM, Thomas Weißschuh wrote:
> On Mon, Jun 29, 2026 at 09:06:16PM +0800, Jinjie Ruan wrote:
>> Syscall User Dispatch (SUD) requires the signal trampoline code to not be
>> intercepted. This is necessary to support returning with a locked selector
>> while avoiding infinite recursion back into the signal handler.
>>
>> Implement arch_syscall_is_vdso_sigreturn() for arm64 to support this
>> exclusion mechanism. For native 64-bit tasks, it checks whether the current
>> PC matches the 'svc #0' instruction inside the vDSO sigreturn trampoline.
>>
>> 	SYM_CODE_START(__kernel_rt_sigreturn)
>> 	        mov     x8, #__NR_rt_sigreturn
>> 	        svc     #0
>> 	SYM_CODE_END(__kernel_rt_sigreturn)
>>
>> For COMPAT tasks, it verifies if the instruction falls within
>> the architecture's 'sigpage' range, allowing the kernel to safely bypass
>> dispatching syscalls originating from these areas back to userspace.
>>
>> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> Suggested-by: kemal <kmal@cock.li>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>  arch/arm64/include/asm/elf.h |  1 +
>>  arch/arm64/kernel/vdso.c     | 16 ++++++++++++++++
>>  2 files changed, 17 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
>> index d2779d604c7b..f43d4dea916a 100644
>> --- a/arch/arm64/include/asm/elf.h
>> +++ b/arch/arm64/include/asm/elf.h
>> @@ -185,6 +185,7 @@ do {									\
>>  struct linux_binprm;
>>  extern int arch_setup_additional_pages(struct linux_binprm *bprm,
>>  				       int uses_interp);
>> +extern bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs);
> 
> A header for that?

Sure, it need a cleanup, as currently, there is no syscall_user_dispatch
header file related to the architecture.

> 
>>  /* 1GB of VA */
>>  #ifdef CONFIG_COMPAT
>> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
>> index 592dd8668de4..5a0314a3c26e 100644
>> --- a/arch/arm64/kernel/vdso.c
>> +++ b/arch/arm64/kernel/vdso.c
>> @@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
>>  
>>  	return ret;
>>  }
>> +
>> +bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
>> +{
>> +	unsigned long sigtramp;
>> +
>> +#ifdef CONFIG_COMPAT
>> +	if (is_compat_task()) {
>> +		unsigned long sigpage = (unsigned long)current->mm->context.sigpage;
>> +
>> +		return regs->pc >= sigpage && regs->pc < (sigpage + PAGE_SIZE);
>> +	}
>> +#endif
>> +	sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
>> +
>> +	return regs->pc == (sigtramp + 8);
> 
> Instead of hardcoding 'sigtramp + 8' you could add a new label to the 'svc #0'
> instruction and use that with VDSO_SYMBOL().

It seems that the modification of __kernel_rt_sigreturn() is not recommended

> 
> 
> Thomas


