Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AF6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0966B00E2; Mon, 29 Jun 2026 09:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660FC6B00E4; Mon, 29 Jun 2026 09:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F12A6B00E5; Mon, 29 Jun 2026 09:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0921F6B00E2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:08:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F6A214066C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:08:01 +0000 (UTC)
X-FDA: 84932977962.08.6AA767B
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3AB6420005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n8efmFXZ;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738479;
	b=Y9dSjiX0g1NlqbBHZ+hKjoTz6C24pfFIRyOEv6ym31pTdTtnTcHOMHWYVxT3hQSORoGUj/
	i/MgP34GiQWRct23O+GBkuhf2ky4RWeSvU97oCmyf1wIfaej3MhGfO0qLuDG3vLDvZsIyX
	dqiVYQJCMXI26hOQG5DRIi5nBgHt5PI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXlEqg7p36Jks1c4yuaOXWFRq7Kp2sLsUwczenqjsfU=;
	b=CbD4Zqb/kSFi4JV9QIwjfgSXZcXDDCfTGZJMA5NKw+MQRIUw5TzgI6LBQePizlwELkN9Qq
	bglGcEslcvtnXHr3cPEyXrc8SN4ki1xaz8axIMzsdGN4jMMjJJGVmEAYCqknPZHoazWLvV
	5q9cU9A3FSHXO7eUnNloj0erb+rTjA8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n8efmFXZ;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nXlEqg7p36Jks1c4yuaOXWFRq7Kp2sLsUwczenqjsfU=;
	b=n8efmFXZdzG/h0lZ6Y0o4MsHme01XM8L7okaKbD/TR5W3fhAEUiS3084Q2F4FbdJWy9onNHJn
	NoyvX82wTsDRv9G5PxGTgVIRQ7Jcm5Hx10ZCpPXtHg6aMkk03hx8R8iCitsSqg5zLYEjQwsADbU
	ewPWK6UfSGus42FOPWCcAkU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gpmYc65wvzLlYd;
	Mon, 29 Jun 2026 20:58:44 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D6CF40588;
	Mon, 29 Jun 2026 21:07:53 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:49 +0800
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
Subject: [PATCH v16 18/18] arm64: vdso: Expose sigreturn address on vdso to the kernel
Date: Mon, 29 Jun 2026 21:06:16 +0800
Message-ID: <20260629130616.642022-19-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: qcorxsxtsbtxymsf38ea4k19o6k8mski
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AB6420005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782738479-894365
X-HE-Meta: U2FsdGVkX1/q+65vpJvqe0KPr64wrv7JUEA7z3iR88yVrQBtjvrPPTIYMVxNlgiQHgo4LRFXIeAUuNQKS3Sl+mb0n0gr1fsfTX6Lr32HD95d/+l4Pcx31zpfgEnL7u06x0UpZmtMrdJ5xccMrWv58gFXJwdg2ie62q4Ay7m2zFw2BqZRM8W0sa5VrODKT7rewE81QryWWK/1fjvJ5PAArgb8FBhc72V5wjMYAIgcovenLfoFlh3KF4Giu6O2PTa51e8HD4kQY5QT9oDxC7RD+cG2ReREkG8MaznVtZUmV/1bJIetS5lVtkNoU4SSBmh2fmv/CaHuFkIlv1fyLw/kaddR3pwx60Bia026gLnHtxCzpO6byygtLDorHeAZonTrvBuoLCSGmttqdpFiHx8y28hf1+EQWOMVZlm59brWX1oJa8Tfft6aZZIhfIRc8WTNgNKcgtRgC0udY4wAY3sdkB860c+YcJ5C91xj5w8dGpxdIqE++plaH+4lrUdEbcpkiBR8BTNnzT1OjXzFJg8qa/U6K9bWYNjX8nATC/c+2ZpqU7kp9Ems781g7DI0qYcqlGjSkdTe6TOx/PzhlVa6qFcpcogOKC879zTIBTm3aS+0dJS1tJ3zt5j7FvXpsEOmo4HumyXaFcsiKKlw0rwd7rdU13EHgs/hN2DP8UGMlWDR7mgWeZ8uLuEzvRrgmiIXd7jA5xPPZ7LKtqLcr6lJufqfVGPJMn/600R+tSKEdlJdARWlSkztFIqPytTPwzK4gnOrZXqzqKmxy+BnLOVaFuMA/vw8IYz9dn9rsMH51PsjufkzeZZr37IdGvZDQ/Hwc7rD4caLoTGuJGa12M8/m3Dj42KltWvbwrcJGR9wLXbtqds0mSz/SkSGQ43f88Hd9BYF4WipxA2uyiwImDCH4BHTFpkYowUJf5+mgixeEZBnjQZnNHCwR1LUe3GCYaI8OgniDFg2tKTZoXhMg0D
 s5+H0Vbi
 wkeZHz+dOxMf66ZXzSnDft8rGfx+pd2Ahf3Na47pBrkJ9x6GjrB95ArEiLSvv2/DtDYoQee7mhIsDqEmHVeJzZoN1xDry3mSMqu3zNuVOcPO8BmGcgOonKPnavhXq1FhKs3Pvv9XdIQz5Pf+b4Adlagx/j/xstHLavCVPl821tvySsVl4/i7qgq4LcRKLTZA37MDb3JYCpRBf4tlfk8201q0/TMlGtWXEuur0oEs45DzOUHsyWX6bR6KaPmYPhfezCnmWkcNP0qoE/cHSds+48TC0FcBKbgx4JjQ6ePaG2HVekSDZCizzeMyQj3TbwVbMSqxrXdzfB8Pvhq/UB+5Ukc+uYHK9yHMIoy29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Syscall User Dispatch (SUD) requires the signal trampoline code to not be
intercepted. This is necessary to support returning with a locked selector
while avoiding infinite recursion back into the signal handler.

Implement arch_syscall_is_vdso_sigreturn() for arm64 to support this
exclusion mechanism. For native 64-bit tasks, it checks whether the current
PC matches the 'svc #0' instruction inside the vDSO sigreturn trampoline.

	SYM_CODE_START(__kernel_rt_sigreturn)
	        mov     x8, #__NR_rt_sigreturn
	        svc     #0
	SYM_CODE_END(__kernel_rt_sigreturn)

For COMPAT tasks, it verifies if the instruction falls within
the architecture's 'sigpage' range, allowing the kernel to safely bypass
dispatching syscalls originating from these areas back to userspace.

Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: kemal <kmal@cock.li>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/elf.h |  1 +
 arch/arm64/kernel/vdso.c     | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index d2779d604c7b..f43d4dea916a 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -185,6 +185,7 @@ do {									\
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int uses_interp);
+extern bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs);
 
 /* 1GB of VA */
 #ifdef CONFIG_COMPAT
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 592dd8668de4..5a0314a3c26e 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	return ret;
 }
+
+bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
+{
+	unsigned long sigtramp;
+
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		unsigned long sigpage = (unsigned long)current->mm->context.sigpage;
+
+		return regs->pc >= sigpage && regs->pc < (sigpage + PAGE_SIZE);
+	}
+#endif
+	sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
+
+	return regs->pc == (sigtramp + 8);
+}
-- 
2.34.1


