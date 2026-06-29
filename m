Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38D8C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC6A6B00DA; Mon, 29 Jun 2026 09:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836646B00DE; Mon, 29 Jun 2026 09:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE806B00DF; Mon, 29 Jun 2026 09:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA1C6B00DA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B39C7906F0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:49 +0000 (UTC)
X-FDA: 84932977458.07.A55310A
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40FE34000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rEU9ZwrN;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738467;
	b=zS0HFYln6phOlF0TJgV0c8yFQz5H9A0FSAuhz32i5Kl28ThgI821J/aj6MN6V5wnsm/vB2
	Grh0IYdpI4tf3JP4H6rtSAKjExFIsMdFQxjZ3A9APvzs+wAcLCzF8jnJbxneWhyLgAjG/4
	Epf9kc1ASIHszjkfApQZlfNtQQ+I5Fg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbCpjFZF6greSjBN49CIhy259uMcOGgcGwhOlbQVct8=;
	b=mdjaiQ9lG+DP2e1VA6+m/QmLZbICpXWbtc1xXmfC3AMNwA1szWGGDHcZ5e5TasxTuek3ST
	VsepAxsI6ftGwhRc2X0vAWwqY1dmOHwaR03Q27nksd8bqlfK5Fv3Jzbllml1RIP28/nIOi
	H2ZK4kYXjXuFOI0DbWRXWZfj78EKOYU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rEU9ZwrN;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KbCpjFZF6greSjBN49CIhy259uMcOGgcGwhOlbQVct8=;
	b=rEU9ZwrNTUHPPgTu1tePw2vP4nYtQBZo5Qm4Vtevq+N9IfFkvW8HvPX7ogKbzu0wMOOY1x9ko
	HxJl+IvMii9vzmWoQM/mHLlSm4aN6qWgjuxRfEcPJDUsWXwQAKYXmSQ2v9drGHZOx/KuvkLzylE
	ww3TwdXayptVRzczxsKwNvI=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gpmYF49ztz1cyQ3;
	Mon, 29 Jun 2026 20:58:25 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id AAE4040572;
	Mon, 29 Jun 2026 21:07:32 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:28 +0800
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
Subject: [PATCH v16 13/18] arm64: syscall: Simplify el0_svc_common() syscall exit path
Date: Mon, 29 Jun 2026 21:06:11 +0800
Message-ID: <20260629130616.642022-14-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Stat-Signature: fao879tzyjotnxi6o4px3fri6m7nq31n
X-Rspamd-Queue-Id: 40FE34000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1782738467-834952
X-HE-Meta: U2FsdGVkX19hcs6IodzcwktIYDHZ+ZQY4nJew4tanu2XAt46/nFMaY8FNhmBpXUyXE+TQYC3FRCQ+rOk4+EvZCj7hsnhTS3ctJ6TODdbaURYgMxlPuD+tTX/I6jS/YXF3VTO894+gpqz9hzv/gOKTAaUEvRoR9FYGTUVLhq4FaS+CoCHwk2UDypM9sv7SHgMHo6i8ofLhUR2+8xIo9jubKDNJjfFHAkew1ek03nyE6owHrofP6z2zlw4AE4bq9l68Z5OeWH/4zMtmSQxMlvq+Jlay3su1xZ/jHe3PFsy+j1PHbw/WgPTv/FYAkSpZbSTD+3dFljO1O9FclnVlR18qXKRjxSYH1XXgyKhnYFGW7WkwmTT5nXe2l8SydfjPQhYTyxCgIeqkQiXmK73VfjFOr0BBsaIoB8+6DRPtYfV6jknidPt32tdUQR+cCXrxlbvfOVzx2OYC2Na75JA7oO8JNDjZegCG4o2+51moO++ye2j8INjCQmleaFtySwZwvxLxOLxuHKNaEX0vBE5UzJspvgDvPkFhvlUvMV2JRjVFB5D7js4Ob/ZJqiAcP95smoi4UoYaTFAdQn4Zc3BtuVzcEnQBXmA8OzDa3gUPmhXtqFizz9wK05nO1ILuJxtiTPMjDeHKNSug+8iGbVNuxJcUpZfCMFVXdPvr8tF/fDSNGfUKDoY+MW9EIH9GrazRHc62z0IEqIcqTcd9FHLVlqVZ2cNH6dQQJZ4i/LC/YmNY/zBi6L1tQUFyRw371dMH2GIVn2CPdnZ3uF9GZFidY9Hikseml/qAnIxG7Py60UcxUet3RshJjaWNXDWKVeEjZlU6e8E/bVlWiPIGOrDQLzzlxnYqIve2xzgFnsQwJ+ar+Ae8uQBcnkDrqIPomhPVzYxSGo/eFOJS+DTLgncuevUSww9vVxFbT5HXlGclMMm6naRr5p5ndwSUL6zLoDZvMAu5B7OUfal9JzIEAwxy9r
 LH4wzJpE
 mqAiWzosVwTEqy+AeaMylPbauaSob8JnQrKCqEXs0S02Kqt2JoqxH06m8fkeejkeyZ3AoZlXM10Y7/MjuZu0nk46Ghc0lIvNvfzfXJuZ6kmQledeKEG67wBkT5N89Z8dUmR8IuAiIdPXBVQxc5zbQKck7yRRXrrysg3y276J6uC2WQxNKMyW9Al+Gyu370rxY1ZIPrYgFvG7LvR9j8tGbGQuZXOXW1JxZ+VczFOLYzd4btCAHjNL+4N1U+/dTJP8Uz/XIPsYSZBfqfRRgE8YvLMqX4wfav15L2WIuGcy2cS3wXJRNEKL/cIVG7jjn30aNZgTBBAXukwinuLu1MdECAfB8+uhVZdX5STVN3AjGDIQaz9sDoi8Yu15myGeRe2Xb0VYFdpRjWFi0fXc+EX7h2VhL4bTx/2FjH703km1qszG4JgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the redundant nested conditional check within the system call
exit path of el0_svc_common() to streamline the exit sequence.

When entering this fast-path block, CONFIG_DEBUG_RSEQ is guaranteed to be
disabled. Under this constraint, the code logic inside the block becomes
completely identical to the evaluation performed within
syscall_exit_to_user_mode_work(). Therefore, invoking the inline helper
directly achieves full logical equivalence while eliminating duplicate
code nesting.

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/syscall.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 5dd94bece929..74308b6df43b 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -121,9 +121,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 * exit regardless, as the old entry assembly did.
 	 */
 	if (!(unlikely(flags & _TIF_SYSCALL_WORK)) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
-		flags = read_thread_flags();
-		if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
-			syscall_exit_to_user_mode_work(regs);
+		syscall_exit_to_user_mode_work(regs);
 		return;
 	}
 
-- 
2.34.1


