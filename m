Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CC3C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F066B00E0; Mon, 29 Jun 2026 09:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9106B00E2; Mon, 29 Jun 2026 09:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240046B00E3; Mon, 29 Jun 2026 09:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E721B6B00E0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 568EC1C2A47
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:57 +0000 (UTC)
X-FDA: 84932977794.18.7772A6D
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf03.hostedemail.com (Postfix) with ESMTP id E05D52000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cSATadQt;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738475;
	b=27LCr2gmqIPnrsPQ2Bkxk1T+NtBFRNnW5uviLr5un/fVr0FjzXIOzabRaFirDii8c8xP/9
	M/mJMTKnwQ+oQr6L7a06BLdz+6cNPZxLkj14vxzx/aCZN23cjRwNJXOhX4jXCkeh7PnJJk
	YYQ2lxGQEqzpAgES/xLhqTN+rLL+n/U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4M70Gapyp6lHxcKfDwoDJcCaABh3//z1ZN+1TfSdMw=;
	b=EInzH6HP6QPgeEcsRNvkQWbKHP2l3lchKwzTIO+b1dcSksm9IppDJLw+7+0QftHr7nAnAb
	+J82tA2dIo7IzQs4NOjRua7QJqzFte57FCOQdSdo2JmYomEioukH7kAlYFNb62ZEHeF42e
	3gpQFp/dyV5mboZ1hDtblUjNIstuXYI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cSATadQt;
	spf=pass (imf03.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+4M70Gapyp6lHxcKfDwoDJcCaABh3//z1ZN+1TfSdMw=;
	b=cSATadQt9PmNn538c0HHU4sX8smMeILhM4/tfoRnYuXf0zwowoLl3eZcV10IFFxBuD4+cb08H
	+KSbgdGzMyMpvYFbzcGOgEDWHH66J/pCKAly7VOfjRPdrY2/LCxyITtutjzl5BZTqlAVvhPbgi3
	gxod+gURdaXV7rMOTz85YpE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gpmYY75QYzRhqt;
	Mon, 29 Jun 2026 20:58:41 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B07540575;
	Mon, 29 Jun 2026 21:07:49 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:45 +0800
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
Subject: [PATCH v16 17/18] arm64: Inline el0_svc_common()
Date: Mon, 29 Jun 2026 21:06:15 +0800
Message-ID: <20260629130616.642022-18-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: dxurcoqsgzrcnf9j9o9how1h3didj5n6
X-Rspamd-Queue-Id: E05D52000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782738474-217510
X-HE-Meta: U2FsdGVkX19jxVSW7baMWwywEsapoBC3wqUd/X5kRPE7bMP+LINPNdRj2c4zTRRuauiyAYc8BEIzuZNZwe0TXdBcIaPKZVstQqbyM6MoRQCh2fJQgVGjRF2Fsvz8fgBgCRPXvfTi3xXG9/iRgRneL8Ln+lBBbr8TpoaOF/QuIxjtIMvGzPRFqvgPNRfPuUWxA/u4KsQqxtwRzRthnhjLNJunURCPRrU8D1MhS3taNK/YpjD7eaGLpZ4WLMIGYy3B4y3KKabdfnAmhIUSAUba+/nK7DTcuaqp2ro3I5MEBl0v3DRmiJuPEQuH6Pzyl/lFiR84+Gym4+uWOXBu7ni/qx5A4mchVRKQaDyLxjkSXdiAchYGOnFPjzuLRscflPNWdUmSfErK5BjCSwVYwIDVzDZkU4o6fG2LXPudPJpFbe/5pmEprDMRHX+2/Mp1hHnQBcql643HPb+/X2G+JaRThmMdE/OP+iZ45oxvkDOul30nurJQFfRpWlclaDXiHr1bVAM140rgyX/b0bFUhgzGNfsmgPMcXfYdKawY5RfYOAlAScWMgqtwVD5oPm3ij6m7r70BnR4uH3sUcgF/EA95X7YEEP/f7HsUXD1op2jA1GPO5pYu7RIFhxtUiWARUSHXW9a4BMPijErJKV5ke64AxULyIIKHbRxugZDbyqhxmPrpjnPv8iHKcm7gwmjAkoG1CtCQA20J9bED5aK6omZGt7QWVrtKWVtCEFzL73YnEyEMRVdx30p6FNbkjt+D9bqoE9YvhYZSarSFnf53KJ3cd2BdujkuojZ+Oh6MYZFzL4rjr++nNMaDTzbesKrCBN34EOuhAh7CvAneyjspbbEgR5rCY3DSNZt2OOeA3eTsRAS95mDLOUDH5B3563m93sRtmfcV2QXCGWV0K46Cyn+1FcbBk/eZJDmfU0AMFVs5XTGqvgETcdtslRdP2XFPdrRqJx9dVSGjvygLwI4QOLJ
 axbiNIuN
 wjCtCG1ejaRBTKsoS9aKzlt8UJrOHUBl5rQcFeKIaJARIBEv9+LJ7cJmE4velqySKfE/tp5upcs7YfDQlUkvlAfHeTcr7OsKbggtb2lxLtkM5NKnoFduxGxQtXUlXux9LeRw4rDoWg0HlKnfP0qdZALs9jxSsxtu0Rn++Ao5I3yQsYOm13MiSIfMFue5f8amSRv012lzK27hJKIIfjQ4M6f/OQeJBrvQejMRXknmSOJKWbjHWoLEAGfFjPkjzbrZ0HwHbxY9L6PiryXwHImMqKx5FChuE14pRMiNH3wEJevUhXGiDzNb2n58750Cl1cDIWQx9i0kfuhRQ7J+YwezSAeUoP6ElmF1BSyzvntEq2f1sBJtwTdhWL+mCTSY28M68wpjHU9tmvYjuUT8UZLpBXKVPCGvHf7JxxNcIudwSDCo3a0RcvXIgKMMS9cpN2bZBkhtXfCB4y/LMJwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After converting arm64 to Generic Entry framework, the compiler no longer
inlines el0_svc_common() into its caller do_el0_svc(). This introduces
a small but measurable overhead in the critical system call path.

Manually forcing el0_svc_common() to be inlined restores the
performance. Benchmarking with perf bench syscall basic on a
Kunpeng 920 platform (based on v6.19-rc1) shows a ~1% performance
uplift.

Inlining this function reduces function prologue/epilogue overhead
and allows for better compiler optimization in the hot system call
dispatch path.

| Metric     | W/O this patch | With this patch | Change    |
| ---------- | -------------- | --------------- | --------- |
| Total time | 2.195 [sec]    | 2.171 [sec]     |  ↓1.1%   |
| usecs/op   | 0.219575       | 0.217192        |  ↓1.1%   |
| ops/sec    | 4,554,260      | 4,604,225       |  ↑1.1%    |

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/syscall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 41a3b70a9374..e0a98fac3b85 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -55,8 +55,8 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 	syscall_set_return_value(current, regs, 0, ret);
 }
 
-static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
-			   const syscall_fn_t syscall_table[])
+static __always_inline void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
+					   const syscall_fn_t syscall_table[])
 {
 	unsigned long flags = read_thread_flags();
 	unsigned long work;
-- 
2.34.1


