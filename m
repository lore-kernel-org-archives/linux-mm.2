Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DE9D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420006B002B; Fri, 28 Nov 2025 07:04:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7CE6B002C; Fri, 28 Nov 2025 07:04:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335576B002E; Fri, 28 Nov 2025 07:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 260516B002B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:04:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2DAF50545
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:04:05 +0000 (UTC)
X-FDA: 84159882450.24.6FC19C0
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id D682D120012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:04:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rjvODXBf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pwJZJJp2;
	spf=pass (imf29.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764331444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbDjONWolVRWulV3h7Xuju+0Pp5SGwJDbywLzt8xkyA=;
	b=yVs5L9aAW1T+le+o0+FJkhEd9XfcVqsr/63icdhNeeNbZG7YgepaJihxHKy+KG0tPfhTtF
	hwXI9Ig7Vok+WKzN/03uES1lREAehDwGOlXCW4DHDTyxUxag9wLN+9lc9L1s6YindzAkor
	28/ntHtSk1zXDLcNq/WkTkZpP3c7G3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764331444; a=rsa-sha256;
	cv=none;
	b=bxd3moq5cfWN5rMd9/AZ9em/Nh3U8jzanJnfLD9AJfDOgqtdj8hjl/DfM+ptvtWPYDkSQr
	EOlEvum4emoqhOzEnmouSuMMZPk/+FFyN0gi5f/V6qnx3z/zynF6K1O/x6Aj49yEE6X2er
	fAukCag6yv8SH0mT+YiD7WMVZbJ/QyU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rjvODXBf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pwJZJJp2;
	spf=pass (imf29.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Fri, 28 Nov 2025 13:03:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764331441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jbDjONWolVRWulV3h7Xuju+0Pp5SGwJDbywLzt8xkyA=;
	b=rjvODXBfX/sGkP/SCBKWlg8gpJJxx2QtqmFIp+teBWBjiWqBL8VYrIZsj3aPHQUc6HIpf5
	+gJaijo1gEFelmDWDnOZWkoGyV1Xwk/V8deJSxh/TMhCEvj/MSbeCFh139+ess3+XZBA50
	2N7JPfLDkTVvg5GQNjOcGeY9KhJfhk/PPS2am97rxe1W/A6Uqjp51FL0YmE5eW0zsK+8z2
	jpK+InifjZCWat5n/Udg94w52lpUupY+dExqkuTK68yS0PABYP76Po+H+ZnD3hUZXH7kzv
	6ZRpS6PpL27XyGr7IsFGdkGqOUvzAfc4BZgwyrtKlH/cvlbGZJQ336rUeCu2zA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764331441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jbDjONWolVRWulV3h7Xuju+0Pp5SGwJDbywLzt8xkyA=;
	b=pwJZJJp2Pqx0lf2Ld6/O21R9gOY7TB3qWP8v0eYtWWqzIGVABTIINg+o1P9ZC0sFnIaQ3K
	YStQHA1g20ACsBBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, brauner@kernel.org,
	david.laight@runbox.com, hch@lst.de, jack@suse.com,
	kuninori.morimoto.gx@renesas.com, liaohua4@huawei.com,
	lilinjie8@huawei.com, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux@armlinux.org.uk,
	lorenzo.stoakes@oracle.com, marc.zyngier@arm.com, nico@fluxnic.net,
	pangliyuan1@huawei.com, pfalcato@suse.de, punitagrawal@gmail.com,
	rjw@rjwysocki.net, rmk+kernel@armlinux.org.uk, rppt@kernel.org,
	tony@atomide.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
	wangkefeng.wang@huawei.com, will@kernel.org,
	wozizhi@huaweicloud.com
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when
 handling with page faults of kernel address
Message-ID: <20251128120359.Xc09qn1W@linutronix.de>
References: <20251127145127.qUXs_UAE@linutronix.de>
 <20251128022756.9973-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251128022756.9973-1-xieyuanbin1@huawei.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D682D120012
X-Stat-Signature: zj4as171qhasjn8pbpnmfjgsrh4yfawn
X-Rspam-User: 
X-HE-Tag: 1764331443-698671
X-HE-Meta: U2FsdGVkX19vFqLS2WKZd4X9FcchsXAnLYD2uQk8mWN/LXRy6jCnPywU/sDL0jTWz3MbsHMNRS/H9p8Vgl4345ZKeZAP8jm3dR5ojijl1CKweoTE/GXb1ILS4z1ARe6pf6tXSEinsVf9UvGMbqt3qBNgYpk/NYDYhRoSZGo/SMNlvB2LKYdvVKbtl8YsMpZOkCnG5M0ZxlDgRchnUirQNeDKF1/HroXN6O88ewtihBIQpxhJ14zS4ry+GslW371ceJN553mxUQ62ZwsLK3I2PrK+SfYK9GX/lNhDu/RdNoia05dQ4ThF10WJBBXM7SfVSk5ALm+T2wRe8DRtsFoLAGz7xVL0L+JBB3bUgrvyrqjznLYGNg0p0q/u0U55aFBJUI5o4ketyIl5X/9q7/ARsri1wr8Gfck9ukkNuP3JtCVasF5gLzLhCwss4USmuO08jIRkuoj1UBu5dI9LHghctx97dCdoxhkHMJ7lihX4ndFQV8uYLSGM3AepBkdGNpPIpayOvxCW7UbMdKoE1dakNhxsQfM+Q1jHRA3JfJACgh0MuxBnWQDiHWyZhRRqgy7ptwuYB/P6fu35Eta2U+Hm+mijcplacnrs0Ui4R6HoBHHa7yVhBRrSeylzLWlbL7Ad3IdxeDGDt4a/iopdXsac5m+MrFA3MPuBJR4IzZEPsPAcmcYYEW9Kcn11N11v1Wmh03/R6PsiV7J/ZypehhBAbgFOFnmPdJPC3r7M2YjbyoqVMBl7aFArSLzQYB8Pv+ixfR32O9nzLCSKfIOf3NmX4CqNSJiZid4E2J5ukG71BxApP2TYbd6NDMVQjgx1HyLPgiaj1L+W7hOtgqMxZ8oJxoxYwnrY1ZKKmw8VIGq1WDav5NdQF/zaUkNhgEFniT612Chblb0nPMQ9Zf+tRuyKht1OCHqhMbsKzhgksqlTniHGANaVaTob2frPrxniRS649vU1UGiMRTuEppIUVsE
 NRF6xzVE
 FvkAGjlDCRaWJcdv+9W1xDzRzPhTy+UAEIw/NKVTJ1k05VGpI8seu6q3ssnR2THeGgLO3wzicnsIt+3zJKnhpjh42wW3rnXatcGH6LbMQ37K8QVzmuue8HjoMmygiw8kVsGPiclJsNzMhzU2xjEjP8V9AG6yijdmHqHcrR41DMVP0sV+PsmUZIYsOAO/aG9CJRKNVJXQR6g4/0wAbl9dVilNxwXXkZ//QOaJErF4lPTtHJQttOmrStuMx1pOFyBthjNcChktVrrcQ1w/1lVm+1qMwpLJrABLEXiKyZ7HZveugtwltTVBbdKgpDh30EuI7Wsbq5npqPXSNeH6Vqn6HcBStxezmfbzMW5vhWbRFrN86TjXR/gSHx1Dej4oymhBAdBnkyz04N8NVL2ER1MackPhaMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-28 10:27:56 [+0800], Xie Yuanbin wrote:
> According to the discussion, it might be better to handle the kernel
> address fault directly, just like what x86 does, instead of finding VMA.

the kernel fault shouldn't have a VMA

> Link: https://elixir.bootlin.com/linux/v6.18-rc7/source/arch/x86/mm/fault.c#L1473
> ```c
> 	if (unlikely(fault_in_kernel_space(address)))
> 		do_kern_addr_fault(regs, error_code, address);
> 	else
> 		do_user_addr_fault(regs, error_code, address);
> ```
> 
> It seems your patches hasn't been merged into the linux-next branch yet.

I hope Russell will add them once he gets to it. They got reviewed, I
added them to the patch system.

> This patch is based on linux-next, so it doesn't include your
> modifications. This patch might conflict with your patch:
> Link: https://lore.kernel.org/20251110145555.2555055-2-bigeasy@linutronix.de
> so I'd like to discuss it with you.

what about this:

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index ad58c1e22a5f9..b6b3cd893c808 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -282,10 +282,10 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	}
 
 	/*
-	 * If we're in an interrupt or have no user
-	 * context, we must not take the fault..
+	 * If we're in an interrupt or have no user context, we must not take
+	 * the fault. Kernel addresses are handled in do_translation_fault().
 	 */
-	if (faulthandler_disabled() || !mm)
+	if (faulthandler_disabled() || !mm || addr >= TASK_SIZE)
 		goto no_context;
 
 	if (user_mode(regs))

We shouldn't be getting here. Above TASK_SIZE there are just fix
mappings which don't fault and the VMALLOC array which should be handled
by do_translation_fault(). So this should be only the exception table.

This should also not clash with the previous patches. Would that work
for everyone?

> Thanks!
> 
> Xie Yuanbin

Sebastian

