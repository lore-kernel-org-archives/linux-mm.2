Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8AA0D116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 04:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A3E6B000D; Fri, 28 Nov 2025 23:08:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61B46B000E; Fri, 28 Nov 2025 23:08:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E896B0010; Fri, 28 Nov 2025 23:08:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7DE66B000D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 23:08:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BFFF50AD1
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:08:34 +0000 (UTC)
X-FDA: 84162312948.21.D4C2A37
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6B853100012
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:08:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QnpmFAd6;
	spf=pass (imf05.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764389312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NoGgYCD49mxEcy5U/zXcoMvWiWdPjcqwWl6NwL9nQZM=;
	b=MN4l5NMi3+jVVto4kztLwZclI6qcWpOFaG8q0Hp7XSHwgZK3pYHkxpzd840E6rM5e6U0JB
	rVa3AkRMGRzwUhWenqbGyDLjXwsV7lub70cYZsJEV6jodDMspqSvK01rah7StrMuqkHTq6
	vuBoI2HYYG7tviM9G4ll5klQ0fh9054=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QnpmFAd6;
	spf=pass (imf05.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764389312; a=rsa-sha256;
	cv=none;
	b=cq4nVhjz8f72x5atJPrfhcLOP5CYyYQfQUE33czp9y/0UkjU/wcY1WaHYkKzC0XNnMUvit
	xuM3MToSf/2JaoEIHNCYKND5WCC6QEggAuKr31NL6g9MdCtDv+XYx4N8ZNaXJameH2EwB5
	hc+Ng84i10Un9JnYeAyce4MHzUF/GSQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NoGgYCD49mxEcy5U/zXcoMvWiWdPjcqwWl6NwL9nQZM=;
	b=QnpmFAd6TlrubU6aXhvwZbdddGjGP4Ir8Af9ucYd6Zwz37RmBOpmDnZOmZTg4klJYnlqYdyFe
	fzGUlPqKZa3gf1KhWg22d0n8/OtAkZ4T2XC19qTBcxWe12ivLLL+jYD3wtzkhSVmuprFXGhUvWQ
	GxP75zEiFjRrAgZT3wq7nc0=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dJGnT2Ln5zLlTZ;
	Sat, 29 Nov 2025 12:06:37 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 950921A0191;
	Sat, 29 Nov 2025 12:08:26 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Nov 2025 12:08:25 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <torvalds@linux-foundation.org>, <will@kernel.org>,
	<linux@armlinux.org.uk>, <viro@zeniv.linux.org.uk>, <bigeasy@linutronix.de>,
	<rmk+kernel@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>,
	<catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<pangliyuan1@huawei.com>, <wangkefeng.wang@huawei.com>,
	<wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>, <yangerkun@huawei.com>,
	<lilinjie8@huawei.com>, <liaohua4@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
Date: Sat, 29 Nov 2025 12:08:17 +0800
Message-ID: <20251129040817.65356-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
References: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: krqtefpanam54rrg77aqskdnca7zfbsj
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B853100012
X-Rspamd-Server: rspam09
X-HE-Tag: 1764389311-865841
X-HE-Meta: U2FsdGVkX18ZEhAzqRI48XfbtRyKNJkX9lDI1wsWEKs5Z287OTunZXARlptdyEaDRyofi9LpF+dJQyFTFPMwz/jOA3VhQfVl7Gq0Lk9hsW7Y6Dhnc8g3Wd8MlPn4Kbd1FLv3/ZkZheMOf2XfLDwfJ/OKuffV1FR7TUKsJMDitB5sDbxAF6GUG6iI6iVlOAe1iXyBBLzstpcFFOLch0q1z+LRj4Sg24OyXnk4H3lCn5QhqQmjybTL00vP4iCJRidjxiQL25Xl5c++2VVMmGOFIud69NFKYiV5d0tQLrUO9hvAhUNvZbQiB8qiKCslrBYzEXfBHNzUKZnaB7znaKZumkfKXkhFwLs/OO/Ylzo4+t4G17y0Uy9ZWh8MEb6kj8WB3xj8+QIdKcB0Y80uBXmg+B+7Lt82fUcreJiHisAoc89wQs7LiWiSDNKYpTcKVjUc2e6Az2HzZWRigkekSPjADJijLUkqR0ZVIrUurAbVfaWeMY8VDxBvq6ErznR/C7TmJ/vbuy/Hr5sGAsisOCJ2m9WazWXipOSdLEhxYTZrspeIJ0tL/4qr0x6lGtMAYMSBYE6ci/P5PX4EQy8obQATKa9FEgXBLDB9I/X/mY0Y1Oe/2D+GdanzjgDf6i8HJU4i6Eok9rXTZWYRiA299/vIh0KnLaikC9EjvESiKnslgAg9GOWoKHz5nOhKNrCpX/pZ5BN9WLWApZdtw/rGf/JAUR47dHKhLu+A2sA2uiF1uCApyGvslPJKPI1vNDAIoDB7fqQFFhaLEkGwNQFmc7aakOzjel9aT8P8ydx28KjNd9TSB91rCnKWtsz9iKMCG8fLeMvRXac190FoJ6t8rxece6CHP3CJk7yBiD18V2xjzRgXji9qVui7xpvqbAZqbbqNsZ9eJho4IAks+ccwNTkYihEEddLUP01KqANs1cKppE4PBQRKPpi7XvyMOnEV7Mbz4tnmiyaUQO84l+3PNLv
 7ITQwCU4
 rCVFlq+4DBfGSa0GY1nRNrp0WeZbYwFQrVtasUcokqKH7jBy8KGIqtbGh3/jEOT7ez7P6g9Ghli7/fK7AdJQhKydUqgKaFbgj5odD0ti3Np1nYlZ8vbqJfMqGu8roM6J8rxCNvpfk7IYPGvwviDJ6v1xTAW1qXw3/pXNQU9AxDDxAFB7azbPbO2nE6nZXCKm4gcKziPZTp/yHukvHrqWdZVNSu4FJ2nE+JE97OjBfwyQMUGilQ0HCfj87p80rZ4LK9PyyC6eE09XtAaE0qo+dp5DVcRTYs/wVSV5yAwI425xe7HllJASxGjDlDBWnL6blppWjlWRNZ6sLchAzBCz32j6f9mvwuSEuetE11K9iTJxPRljRFzbSbVh6r0It7VlQ3RLSCCMgrQgdNMJBmsRJP+9s+HRv+up3b7fo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 17:35:37 -0800, Linus Torvalds wrote:
> On Fri, 28 Nov 2025 at 17:01, Zizhi Wo <wozizhi@huaweicloud.com> wrote:
>> It has an additional check to determine reg:
>>
>> if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
>>         goto no_context;
>>
>> I'd like to ask if this "regs" examination also needs to be brought
>> along?
>
> That seems unnecessary.
>
> Yes, in this case the original problem you reported with sleeping in
> an RCU region was triggered by a kernel access, and a user-space
> access would never have caused any such issues.
>
> So checking for !user_mode(regs) isn't exactly *wrong*.
>
> But while it isn't wrong, I think it's also kind of pointless.
>
> Because regardless of whether it's a kernel or user space access, an
> access outside TASK_SIZE shouldn't be associated with a valid user
> space context, so the code might as well just go to the "no_context"
> label directly.
>
> That said, somebody should  definitely double-check me - because I
> think arm also did the vdso trick at high addresses that i386 used to
> do, so there is the fake VDSO thing up there.
>
> But if you get a page fault on that, it's not going to be fixed up, so
> even if user space can access it, there's no point in looking that
> fake vm area up for page faults.

I think the `user_mode(regs)` check is necessary because the label
no_context actually jumps to __do_kernel_fault(), whereas page fault
from user mode should jump to `__do_user_fault()`.

Alternatively, we would need to change `goto no_context` to
`goto bad_area`. Or perhaps I misunderstood something, please point it out.

Thanks very much!

Xie Yuanbin

