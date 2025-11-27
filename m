Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D419D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB446B002A; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7923E6B0027; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8AD6B002C; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 565456B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:01:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E98CBC019E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:01:40 +0000 (UTC)
X-FDA: 84156549960.24.99CF191
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0891F18000F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:01:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BrKKm1Dq;
	spf=pass (imf24.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Dqh1/ZwDt2FOZnFxUGnYOMEzfM7bVg75Vg41Zs839w=;
	b=UYdQdL9+uKwrRCOUo1qq4v08EQy/+pmiMVCb7Tp0Qr1mrtKjpFyGIPTSLMxq2MV/bZ1yr4
	F95iUeN7DEN+PxIOlK/gpVTUND1sK98FNQ9uCzIH+L6IdWXqqSeLkh7BI2HGRpTUwIi0tH
	5z7d79wobbz46d23WuTtHgQWTfeLRpU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252099; a=rsa-sha256;
	cv=none;
	b=RPS4en6XRVyBBFIQQ8nkGFnln6bQ1Xiugih0hNgw9iXlYnTu9QAtsK35zzilNMteITHiT2
	71s87zejSYD588TvSv2Qg13IJzsEKu5bOewotEdmNGIJgCzGpnAdeO6UHps+BrfN5t0INp
	t1GVtXoIbds0V/C+izH3J5WDYOHE8Ls=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BrKKm1Dq;
	spf=pass (imf24.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5Dqh1/ZwDt2FOZnFxUGnYOMEzfM7bVg75Vg41Zs839w=;
	b=BrKKm1DqDzeaPEp+Ht6Vp/QY+ceSXm0RUwkjGBSqqCOPFcoSOx/71e0Mm1DqOC4+FFZh1hLY7
	DeUshsfdhtVNukB5sNmzhb4QBQ8AfnDJggNB9pw+skQQpKsXxsvzSyPat63XJ8AQU5aBvI3TFWH
	MPAJn5/2Zab6HVX1/S+Pimk=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dHJ2l63Lrz1prLQ;
	Thu, 27 Nov 2025 21:59:43 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 981F21804F6;
	Thu, 27 Nov 2025 22:01:33 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 22:01:32 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <will@kernel.org>, <nico@fluxnic.net>,
	<rmk+kernel@armlinux.org.uk>, <linux@armlinux.org.uk>,
	<david.laight@runbox.com>, <rppt@kernel.org>, <vbabka@suse.cz>,
	<pfalcato@suse.de>, <brauner@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<kuninori.morimoto.gx@renesas.com>, <tony@atomide.com>, <arnd@arndb.de>,
	<bigeasy@linutronix.de>, <akpm@linux-foundation.org>,
	<punitagrawal@gmail.com>, <hch@lst.de>, <jack@suse.com>, <rjw@rjwysocki.net>,
	<marc.zyngier@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<wozizhi@huaweicloud.com>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<xieyuanbin1@huawei.com>, <pangliyuan1@huawei.com>,
	<wangkefeng.wang@huawei.com>
Subject: [RFC PATCH v2 2/2] ARM/mm/fault: Enable interrupts before sending signal
Date: Thu, 27 Nov 2025 22:01:09 +0800
Message-ID: <20251127140109.191657-2-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127140109.191657-1-xieyuanbin1@huawei.com>
References: <20251127140109.191657-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0891F18000F
X-Stat-Signature: w9iim5huwrot7zxh8r4tp4abgd6m43et
X-Rspam-User: 
X-HE-Tag: 1764252097-733118
X-HE-Meta: U2FsdGVkX1+GuaRWdEpa8KT9hH2RVdtinHUvW61lrR/I5w5yIjWEZMru3f0NzxTkEYrfRSQpmu0UHKOHsvBZfwaEcU6WMUTNCwP/P72tK3gRp/2699CUTAv1pJ9Tz4nH9oZTZwVOowYvXK7t8orWWjYTUrR5xPc+Z/an+EfzYgDgBWv0eJK58yaOkDWTfVoPEWL7SUCGjelhdVbvUK2rKk1HA5UO1qBAnFvRQ+pCcQ/zRcyGTBxqhLqpHRvDGbuXpCTQ+RR07ZkQyUPDDoJmdzvE/VQCdOY03I0InBdxsqW55M8Qwdb0fyNFxotz+ZU1xPQbJnFsvm44eHqYhqazvcyfiQ7eA0pLt8zFC164XrsV2qokQEn8Rov34gu68v6DFN9nZ1CLojl9pMbmmSEO0KYBwd6dzdg7NXvHqfbZG/1gofxGV92meoOgueEo9m+toqAKtb9DjO657pKhEmxuVghvYm+L32FgssIPT/igHFdIbL8dH/mouPjzIROhQkD2cHAexXgBROk2r4C8dFoDXQsI5fgWs7NX5g3H4sM5lIPrmSdRNcPFqNuw/ugSZQDSmLoT4M3AL4IZtGcAZbtfGXL/g+JnPVEkl7hsC9/GLoITi6KXbnIM/O5hUBtzeniTSeWjjXYfxvpuKX0DnQFJWJ5btswK2x4fwDsJmm4q+f8I7banwgnEZu8WfAQDWlr+ewKrB0/h4lJphFOqFq3k9Vn+6xyU49Yf2hMN9cBBPcZyjFtbLtAyUJgkhqbTL1Np1Yhi1LXqx4x1I5D9E1YVRhCGvY9ANvcMCfD2p+FV4rl6icu2Y6Fulcdgo5tfoqUQMWEq7VmI5vic52G6FggAcprRuUcvrRvGyy80FIv91IH6KIaoOhG+PfS2Cp9NUsF313u/qhxlMEhqybMIt24kjI2wVbKfC5bdT9IhlPBQEEGqfUvQPxJsWVzs+c4gHhBQTgwn4irXoyty5kag2Tk
 AcXvxOPw
 aazfS7F3lZeexFHwXk7YwQISIufwsz2qVglpsdXjT5Pyj05MZkk8BAFVcIGoBzl5EtdHYlFOhzWVDZ2atJz1UVIEyp3Ki7ASphatmJJ13X+59UscCtlvdP114d12tvi50DESiyL7oJvyyF9jOtEmPA+uR2+ftvy0G/KQeMITJN6FzN30WnuT7v0aE0yuQ/iaatRyGXFxzafBFBu2zEmOKCu/o1WOWQCKTz+dIyTnpaytZZ/OBn8BAJxo91X51tMfl0Gu4d1DckigO8XkpmjaRwIQocAt9Q2fWBrAYzZ8SH8iyEbSBivWtC9P8rsWWz1fdGjRZzpYG5yj2P/VvlstwSgRfxiOu8f+KWy1ibFzHsiyisU/w+5sT958ry8sBIIl4BXj2CDBURLN/XJg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xieyuanbin1 <xieyuanbin1@huawei.com>

Sending a signal requires to acquire sighand_struct::siglock which is a
spinlock_t. On PREEMPT_RT spinlock_t becomes a sleeping spin lock which
requires interrupts to be enabled. Since the calling context is user
land, interrupts must have been enabled so it is fine to enable them in
this case.

Signed-off-by: xieyuanbin1 <xieyuanbin1@huawei.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
This patch depends on patch
Link: https://lore.kernel.org/20251029155918.503060-6-bigeasy@linutronix.de

The commit message is copy from:
Link: https://lore.kernel.org/20251029155918.503060-3-bigeasy@linutronix.de

Maybe I should add:
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Or something else? Thanks!

 arch/arm/mm/fault.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 5c58072d8235..f8ee1854c854 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -184,10 +184,13 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 	struct task_struct *tsk = current;
 
 	if (addr > TASK_SIZE)
 		harden_branch_predictor();
 
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_enable();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
 		pr_err("8<--- cut here ---\n");
 		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
-- 
2.51.0


