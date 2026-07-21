Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41F1C44534
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05B56B0099; Tue, 21 Jul 2026 04:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A902E6B009B; Tue, 21 Jul 2026 04:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930B96B009D; Tue, 21 Jul 2026 04:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5851C6B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8CEF80406
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:10 +0000 (UTC)
X-FDA: 85012083660.28.2101CA6
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA7C680003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=41yXRk9x;
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnYDyjFiAR1AxVoELjeLgtZ0vAqYI3txzE4z19P1pME=;
	b=WBkMJs7yQsTUTYm3kKdTwdle9fF27vWbBnORsVUMEcgsdU4bCvg8w9VHMtNdMz9JhZ/1fx
	gakTobckbXrrbTguJkF8+DP95cEMtZKbjYndKNl8AZw6O8JaOBb/R4t74mNfL9Z5rI2QpN
	BhcjgpHmnpi58B/8FQUJ67lX2ihbVsw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621949;
	b=eSG7rqC31lW94k+RyZh6PxC9iFmix5eR70VJEJZJ70sKyBAS9qXn1NDvzY8eevLcX0MiN1
	R6JQzc+hRqFEJpZY0nL16BQPvzIe6JdujMAfYbw8CSKGz24nNUOEtl3jiPyjiNsyH959dy
	aDnFzgK8oqZheCPCiKQeNWOTDBoWKyc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=41yXRk9x;
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FnYDyjFiAR1AxVoELjeLgtZ0vAqYI3txzE4z19P1pME=;
	b=41yXRk9x+uMNmX2XAzIa3ZCE1wFWbSR2SARzWYCMks1pllTC5OyA36c05tMWmct10lGVxiIPT
	BGqq/iw6X2JA5sAW4MfYtJXZ01jQsMm9unaFK5sJhiQtUx8487Y2fRt16FZTlGMDSRkrGuSzJFO
	4Xz2DLVpi6473wTEt3aIIw8=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4h49601qJ5z1K9D2;
	Tue, 21 Jul 2026 16:09:44 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 1024040572;
	Tue, 21 Jul 2026 16:19:05 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:03 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <mark.rutland@arm.com>,
	<linusw@kernel.org>, <ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>,
	<yeoreum.yun@arm.com>, <anshuman.khandual@arm.com>, <james.morse@arm.com>,
	<tglx@kernel.org>, <broonie@kernel.org>, <pengcan@kylinos.cn>,
	<ryan.roberts@arm.com>, <liqiang01@kylinos.cn>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v17 06/15] arm64: syscall: Rework the syscall exit path in el0_svc_common()
Date: Tue, 21 Jul 2026 16:18:49 +0800
Message-ID: <20260721081858.1169276-7-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA7C680003
X-Stat-Signature: 3hahy8xruzg3kfj3t9tuc6urhd8781hu
X-Rspam-User: 
X-HE-Tag: 1784621948-113227
X-HE-Meta: U2FsdGVkX18kBTOtrbXLAhi0z45UamAjM6CLkv6UtA8Jn3BFSIihwZwF3X3svYjk60G20PIEOUPROhYz7GRUxFJmf5K3ZrhedoSqJCjbLbrlN4WPUeLXm3YGHPpDlhkSKZ8hkWKPVTcle7kPRkMXYRQOPUSI4AYpGWMXMTrB4X+3T8/uOP+TRMeGWz456Zlg9p/wfIE6BQLxn8mhTkti37HpVPxjH+0exwHScz73FM5HLiiZTFnNRFExgqyxa8ZXkYjjnHPHIE0SbIeLWBpcXV9uBKMGSNgTIGP0ErhcdBpGv+0EIItOArCk64vpO78R57irmJrMB1yFFiEsE0RiFVdRX5ehFjrYGaGGRvqaPAND0mdp5mpc2mtGm8e0akikOTaAVgBjFuo6bKHWnLXiW18kxlgXo5KnmOIycS3iEA/PNdxi07F+Ctm5dKmG51Vb9fSJ0SA3XJrYPRz/4/8jPVONL4MVqhVWA9rRrY2yNagTCm6A4it1N5QMIsUfE2vVy2Qm1phh2/0l1xtVF5H/KEkMY01fh1MeRdIGNvU5Z4ur0M2G47/Udsdqm4OmEhPyXOgE+uDQRRlGd5+ZukcmSWZIGzyrSYEHW6Hmz+4799bnzCAFr74lPv+d7wvtEsYEXcgFM45Ytccv0X9sjuxIHN+EXiO9j8a9JRT4+v2Ph1XvVWSoBO1FrxZBuWN0PubrP5V2hf8jq2d2NQag2OizRic6igOSn8s6agwOtgQgHAHyHpPgiTOF4J2GkXIkyG84yAHUyPi4RkLC5kvplCzO3qqj8OEAuul+JV4gzzka3C+tt5YlRnXKgbPTHcpfvGWVZjrU7P3pzAhaQrXWF5L06968SOQfu41hT9b3zQEeCME1zK8p+zjbdtXqUNTwO1BwURh9nUnyog0r0ty1io4T51zuwbwIaxestyCyJiZS6PMuficf7UKoDOULaOkx4ownNwoJV/a3yuu+UAj+V4I
 LjR312eA
 DVbx/x8yPylJUPPDJlW6Kd6/nJFJFcRxbK5i8Hf1TgvdU4l6NQ/hPZim2AxdgxIUJgeT/tTnDj1dpBQjN+9f82qzr+V0/KAPUvszsdYtpdeInigMyGD6WQ5J0peqfLYtpqRoY/65lHDC46QRGpOWFNpZUZZ5I+8Fd4hXMgn3uasb4lpfk7aon9mkJP3GNA843t8tijmTpzM7EeDTOAIegHnKXlDOynLtMVgSJIWk9RYZG9RKVA4nIHde64pqer6wFMfoBHhWK9a0DPb25NymKxd+9n9wtCZlV6E4Nz/N/RB/B7YawYSNo6pxtIjqRIbmkjQ+g27GIhLWXjAN7Kh71HYiwhHjidqIYIVKU3bj2DFGEYOZK7bK40zJ3dOHo+u5c2HinHrU/MQBKt5iCeVvQL5fkiaMjYSScuGMbx9zZWPszNhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for moving arm64 over to the generic entry,
invert the nested conditional flags check within el0_svc_common().

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/syscall.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 3e78e159b2a1..b8d7d29a431b 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -127,8 +127,9 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 */
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		flags = read_thread_flags();
-		if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP))
-			return;
+		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP)
+			syscall_trace_exit(regs);
+		return;
 	}
 
 trace_exit:
-- 
2.34.1


