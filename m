Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D119C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3586B00D4; Mon, 29 Jun 2026 09:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D3D6B00D6; Mon, 29 Jun 2026 09:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7243A6B00D8; Mon, 29 Jun 2026 09:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 453EE6B00D4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C45DB14068E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:41 +0000 (UTC)
X-FDA: 84932977122.06.81472D8
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf13.hostedemail.com (Postfix) with ESMTP id 853092000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vMQyd7PU;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738460;
	b=TY5afFK7TptNzbCrg9iQgfvdFHOxfL/FcB4GyZFtGeSLkYcCpGAuKRipltbyUfDlh3TXXw
	nTR8HB8zCg68CWfrCH3neJ16ebeIyrKkK12uFkhlwLCQ4yWaSMgZEpYC+sXCSb9sFtH974
	ICTHSE5xUfd1fIsPi9/PvOlKpCnAZtA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88/9LC3oaXf1+wz3KqBUcB/GwyiMHDxQhNIIGWx7XWQ=;
	b=dqLSJ9UGzcVQEm4uAnEzm9djWtNGjD/rWFyOvdW3A+5FuUvyj3MNzjQNWiUYfBrWn+JpWv
	7kIFcXII+iEA1s9z1IJly87j1YLBEijyV3VA1yn8TjKtH1Go0Lp2cz+CnptAHVLDA0Tx6V
	avcOGqAwyVsRzqCycblW8eZyeqipJ1g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vMQyd7PU;
	spf=pass (imf13.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=88/9LC3oaXf1+wz3KqBUcB/GwyiMHDxQhNIIGWx7XWQ=;
	b=vMQyd7PU/QZEyGd+iM5AS9uijAiEEN3rW3wIvKBjZwlBD5MQJj1Tlt+q7jJp4ZiPz15+OfpmO
	7wnZppF8ItYKXMlETdA88t5xCnaKFB4c8JPxavs6JZH8OfioD1Z9FnSCf6q71SyakoYN0RGkV8v
	dCrl4W78TYEYNgWClqQ3Alw=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gpmYJ2CK3zLlYd;
	Mon, 29 Jun 2026 20:58:28 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id C918F40586;
	Mon, 29 Jun 2026 21:07:36 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:32 +0800
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
Subject: [PATCH v16 14/18] arm64: syscall: Simplify syscall exit path in el0_svc_common()
Date: Mon, 29 Jun 2026 21:06:12 +0800
Message-ID: <20260629130616.642022-15-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: x17jkgrxowkcijfmxx3gkhmsy6dbh64m
X-Rspam-User: 
X-Rspamd-Queue-Id: 853092000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782738459-401636
X-HE-Meta: U2FsdGVkX1+NJ/1fd+BxQtD3OQSZ9JNo3qTdVzfGJwKxxREy88MXfM8ZfVG7ErMaFVBpIFqBZbpG076FBlINsxKsakO+O9Nt3zgqsZMIqj5FdWSVxmbIsmHDk8ULpWHuLmW5hxMQktrC/zq8WPI10ob8FyJvUDf4g7P2vTWJ2RgQ+dtP/vAI07y1E5+AtSdG14IAAxit/B0XjFcdTIEEIsrFW5MAlf0PlRAuDcBcFqOlxkOxAyHM4R4lMqNsrrK/riX2NMjnyatQiHCHrUs4zxhYl0JdQMpbvhsvnZTqBZJLtCTAkAdIy39iZp8r69X7TVGK0QYLWAmQlL/eZwZFyaIlhCBOQB+gAxrI53vwLcSBe01UuUq3v13+5CTwjQzx8XYiAhlo4ey1J4R+8z4sYVYJyZA+8ZzIKxK/lvkd1IiJIQrVbW5Bvlkxa1HvxOe167/f9JdLKaO2qdHLCzig7//sCsEpRE5M8CNE5R07OPL3us05R6S6ejunF7TbqKUjOR7LSoJrniytedxS5DHhjH7sbr1Z9qlbUCmBi/jYyz1iMntJ9ODGqiAODcGiinJd+9PXlrC7yl/Z24diXDTqYKZXYb4m47YbhZgsaKWF6BKd9BiFlleWBx7BzYtCrCAziJT7xzdriSHtekCBOBxxxkCFYHB0cEtvZ5ZO40XJ+FT5SmyDWN894PdYqBucUrRldlv1XcYKOoXV0g/B3jK97tqCCtME+aOb2tuD2f+EFLePQxO7m6Fi1jI/gpcptgKhRVUfDP8G46kh5Ru0r5pE/0p/RdLlsU8lHy6I/Az0YZ8qfKSknU8kDB/t1ZlGVeHl6+V5XuK/gCoWqGB9reFKxxVVhTpUgMDFyJvm5PGGpSCoD/1gr8fe1L5xNIIUTLTXBR0/Aro2/AHxWX84xrfQOxia8ecaf8ovMT+cLOaXr1WDagc0ozMEdBDL2+70vSR6ndIN7WPqp0JexBUNL4G
 m2cGWEjj
 z+49Ftxr3FeypNnDEdeffobitbSMgkQ3CqGWomxukfig2iuyFyVnp7QSNEy0Xgsi8kYLfBZdM0i3ar+oYddvWS1dPnNWJj33NC9v5etcIAZvLUDyZWARtmUNgiI8V/O7kMcM54sRwbrunSRVsMa4+L85O65cB9Zr3w5yAMsYTgIayqvIR6BKuRwhf/Asa9sQ0tSA3sRwF0ySfU2J4JWnX0YOGTVqxaY7J7W9+o0eQnMqKzB0nfa+a9sqezvrfJk5WJDXSEjBbJfjtMqwRi7F5/nGYP4s7laskodhM3LUHWt2bYhvsYXmBCBHo/ljOpGKm8v1IThyggOB4R4eIxNsX/TyhHu9wxnU90JyOAujvnbaaFN+SuKY0/i/zv+0vc/url7PCd8yg6gUcfWSEqP/TPxgQ6LPuy+nrxh8bXMVS6LPcX4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the redundant conditional fast-path check within el0_svc_common()
as both branches now execute the exact the same
syscall_exit_to_user_mode_work().

Since both the conditional fast-path and the fallback slow-path now
uniformly invoke syscall_exit_to_user_mode_work(), this explicit
conditional branch is entirely redundant regardless of whether
the evaluation is true or false. Removing it collapses the duplicated
logic into a single, unconditional path.

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/syscall.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 74308b6df43b..275cde8ab6f4 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -114,17 +114,6 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	}
 
 	invoke_syscall(regs, scno, sc_nr, syscall_table);
-
-	/*
-	 * The tracing status may have changed under our feet, so we have to
-	 * check again. However, if we were tracing entry, then we always trace
-	 * exit regardless, as the old entry assembly did.
-	 */
-	if (!(unlikely(flags & _TIF_SYSCALL_WORK)) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
-		syscall_exit_to_user_mode_work(regs);
-		return;
-	}
-
 trace_exit:
 	syscall_exit_to_user_mode_work(regs);
 }
-- 
2.34.1


