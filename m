Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F0EC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18FDC6B00A3; Tue, 21 Jul 2026 04:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1402B6B00A4; Tue, 21 Jul 2026 04:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F4C6B00A5; Tue, 21 Jul 2026 04:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCB546B00A3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:19:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26E38A0448
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:20 +0000 (UTC)
X-FDA: 85012084080.08.B9D1EC9
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF853140008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:19:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iyVuvj+L;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0TRHr4VzDpovfYUtkO31A1BgQ5a3zy2JjAUxtMkl1o=;
	b=jhJ1VhALSeXP0trON36M8V6Rf0wI4cflzw/OLUaRy45r4PGKdx87mXi9i3keHmF5xfxakf
	y7/9d1wVvSOedqkQAYMzTKTcYR20pQQ5FPHOZX/7yOjviLbPpWdwKfqC1/Otx8ca634JW6
	b/4nR0k49qgKAhD93qXAGo41bZpfWbg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iyVuvj+L;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621958;
	b=m1DGOnHi7jk/NjdfUXDwyGkF3LR4gCJF5OIKfSxEC4hhAbfdzmdieuVEyS5/d5BeA3pUqS
	amNnbB53HjW9nFkTrHdQ58vPMcD1Hgp+iCLWqr1aVIhUhYxNSWvvI8y1TlebaDgafgzPnW
	94WPLsPRriRfqFg0QDbaqSJDFZHdfWs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J0TRHr4VzDpovfYUtkO31A1BgQ5a3zy2JjAUxtMkl1o=;
	b=iyVuvj+LSqhBuF7ytK1mMCueWjT6x9eE4CabIZ+ip5NeyG9yY4wxQDbW6/gVSC/FrN8S9qqv8
	ILScpWaGCdJbb60aQdUlAF8SohAPQrrKWx7KgkeDU1k/V2wr00zaHd43ayKtG7ClgXKVrp5AbuJ
	OHil75TjNhrNy/KsuUSbq84=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h496D0vHbz1T4Km;
	Tue, 21 Jul 2026 16:09:56 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C0F54057F;
	Tue, 21 Jul 2026 16:19:15 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Jul
 2026 16:19:13 +0800
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
Subject: [PATCH v17 14/15] arm64: Inline el0_svc_common()
Date: Tue, 21 Jul 2026 16:18:57 +0800
Message-ID: <20260721081858.1169276-15-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721081858.1169276-1-ruanjinjie@huawei.com>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF853140008
X-Rspam-User: 
X-Stat-Signature: u7nati8hfi67p8jn9kzck6qxhiq6woqq
X-HE-Tag: 1784621957-745843
X-HE-Meta: U2FsdGVkX1/S4wa5EQtiQWcWRinee1Kq8Zrowd2ccyX95hc2pf/RnPytfX+yzjATnwaJSHscqXBAFEuFE1MHSPcpeRi7xtIJvb1bESVsnBBPbUH2XDT2mSK4sKMxk9pLz5DdGsrFxQdideRvcDgCqWbZZvBgeY/9zV12EgXZqN4xrJNhXqpFuH8mRthtB5hKSzPu8Hnu+tdATaCcM0TedTUI8x0/eJYsaJ6bq3Aj7XtW+94lt2YMoG9kDwK9Wv2Fy/8iNjY5ci20J0LgSSj6wCgj2NDT+aXX0molhuu2P9CUEQIa2sxPFnrY+hSMJPfgLqGVo9xsBQqOV5hI8zUFuXXJPnqPkmcHHcbdCPDRY9Ggw01KbZBp1gs+ZH7tmO+KJHdcA184npffPNszESTBrJ3+DgJFXZk8wFw1W3puLIIzIYbr3irweEe4eFm99B0FcGGVoFA7gRdWZLO4QZq00NSipiku+LYGPpkwe1C9CxTPDWaB5xR9m24D23e4/3mI4znk4tIQTc8E18JxWHSlL5avNEFUSnsG+fxxyswkjw3sTp8NBDu4PaVvW2/H+vkjSzU61AQh0OKkm50TbNiws9y+fqTeP4SFrG5gOHsv5PurNtbladJuDQbBfsPrR1V+86MQ1R3ZZqMVuz7YtIaQwEvz80g9Q6HnrtJEizWB8cL2WW2bDcvaHygSDGP4PvzvGB3lLWZ3kJDS3ThHoSbnPCz6lmQgnUoQ/Asb450TccpDzTrg5M9kdHf5poTqC1pQtYXw/c6SsZSt2IGPA/PFC8oAkk8H29+Lf85tDOZA4/60SscBBynH02H5b/MuwTl9M6axJnbRVSdBl2qqRPkrgnT7PPzjwS09Tofl9zOlrvlJw3LZCd6ZepglMqnMq+v63MINgTH3lAK9Ucqzcu/0TUzM14SNdVJ855+51U/nx2WSqqGpmOVY4wi5ImhxKz5WmP/4ru1YuEveXsEOxwC
 y/4Wx3Sz
 JZpnUZjhURH85jtbX3lTb9U8uOdXWsBb3S5TAMNOew/yOPXSMcqMe46FXbz5Md7e7IyrVnzoJQmY3qD39b9vUim+qNEpw3sdrB1tbUvFNszzCIBINb0bDcZVD7TnJfyQq4Jo+zIOPDzWtHUIQ9n5rvpl25lEP0mI5tXQUwRjEY1zVf3AOIyPxUVDDcgDvvQdoKlxG3TveHTjY8XtpKE2r+NeQw0fUjbonweXT4ZiPqbodNHzGjXhUMCAtRjTBxb0jb1sGmgDanWs47LQzxaJcqwf5YpoSuiEGys7KwHg4mx+zUHv9ytjjtm+as+fJF5pzeTdh+uPQOFWbsWuSfNHXXOWvyXBCOaVE9zIHYJ0kNhdztW3c7deUYcJ1G8wZ2GwTjkVxEmioS69tBEJG8z61rVH8LNudnAb3Ug0kItlHOIXMELs/qOYV9OGtgZPkEf2hY4zA/J9CURM1jNA=
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
index 4a13108defb0..2535cae9413d 100644
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


