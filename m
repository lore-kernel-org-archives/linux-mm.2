Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1129CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82DB6B0088; Thu,  9 Jul 2026 22:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34CE6B008A; Thu,  9 Jul 2026 22:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22EF6B008C; Thu,  9 Jul 2026 22:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBA36B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:32:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05BA61A014F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:32:38 +0000 (UTC)
X-FDA: 84971293596.24.F62296C
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf18.hostedemail.com (Postfix) with ESMTP id EBE121C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:32:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6HxuLkZQ;
	spf=pass (imf18.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783650756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLA3HPVa4IkL/sCfl1Ni6nHLO1tC0tF97SgS+HJzcKw=;
	b=dHmG4Tnb5KPXwVESz3eSTiqpQFmpngzdbufWQnj3PL3kKGdA+z0GO9EXipV1IFi45/potf
	vWL4YqWScRuKfGRV1/MNGu6C669VrZXWXLX11nurpzaO8pn98EpyKipXFuoJaDr0zBJniK
	s/qqUmjcraj2Ijsqt90rVm/KIjzoBFc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783650756;
	b=cpfkky6hrYiU7zvap57H186WuX70S+/Cz/VWz1JZflMXq1qT3bscDZLMHBr6BJ9RWDA9wF
	h8Kmaj/N2R+BP6F7QXpCbAX1unhmABylOZzlcCKWBECNNAupYZfld04aqud58cZp71B5Iv
	JvNiAUUkqZRa1oKE1wWr8/fFc+kMFOE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6HxuLkZQ;
	spf=pass (imf18.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vLA3HPVa4IkL/sCfl1Ni6nHLO1tC0tF97SgS+HJzcKw=;
	b=6HxuLkZQ7xEfYha1BMyGZWIQVghQdQM1lgZu1HHkY/7k9r5bFITWYJDg0J+VdpZVQ0DeDxQrc
	8qE9+C+/OxxoF7nH3pM8iUm9t0U8VFGslx3vMzaEdEvJpVbH9JjEAjTHOwyJUQnE++g3RN7ZbKr
	Vq+jXLlvJE5mIz12+PFFPok=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gxFxF0tvJzKmVj;
	Fri, 10 Jul 2026 10:23:13 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id AF2C740572;
	Fri, 10 Jul 2026 10:32:30 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 10 Jul 2026 10:32:29 +0800
Message-ID: <3fb3b11d-515b-400d-b1d2-5623dacb92cb@huawei.com>
Date: Fri, 10 Jul 2026 10:32:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
To: Russell King <linux@armlinux.org.uk>, Lorenzo Stoakes <ljs@kernel.org>
CC: Xie Yuanbin <xieyuanbin1@huawei.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <liam@infradead.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linusw@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mhocko@suse.com>, <rppt@kernel.org>,
	<sunnanyong@huawei.com>, <surenb@google.com>, <vbabka@kernel.org>,
	<xiqi2@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
 <20260707131409.79043-1-xieyuanbin1@huawei.com> <akz8aZUW23rpyrLO@lucifer>
 <ak0cfZPZIWz4v95K@shell.armlinux.org.uk>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <ak0cfZPZIWz4v95K@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EBE121C0003
X-Stat-Signature: trxu79dc86t9n67gxwfrta3tohgb9nmw
X-HE-Tag: 1783650754-292848
X-HE-Meta: U2FsdGVkX1/z0AAhDMCfoAULT23QX49EeEgfR19+8qg+r96n+E3442c39fXz/V68YYxUYbmE5xzINH/LKtJl8HVNSApKKULN5qjhosmmO+hUkgqQR8Tmc/IZcZiaRePtiK96JdDxucraN0llEEj8G5lyogygs85Qyy1fudu4yunRudTkASsIdEUBlm+2Y+A6pltaCQlPy7xne8fAY1F6zztnytEtV849/TiWHiOkpceo/NlCJdTV2VYzPaxETxD0+lasizdFsZl13LQtGE4R5t46ZwRDAFhHF++fZVfoGqGxZs0jImiw6NT0SlI11NpxhXtFUGAG3+TMsUMeljSM9AYunpjJZdHL8CXIxIlTbIlyHI+mMrCRl5aFbSKdCKOpu4O5S1RlYihzDV8dBwJ8ko7jiOCgWND5QOGy1Evr/3qQEdIsrjfOoXUSBt+4orTHM26XTIPa7v25vs6EaYCdzMclj33ceiIPtNHDKnj2PVThTluXbRpke8G6Eb0K7roXyT4Xk3soKtrrwDuWFcVp55t5oLAebRlC1EX94GhqOmUkPEqqft3Mlf31pIYdPK3jNTi5H0LmH8nBIOFZyX/8MVhm2auYUwH31LJ6Fo3D4ns3OOB23SF464LpfIiuowP7ggJm7WP/xWIayR1/YI0v12vO5lVpkE5q1WyB4l4X9VLMJSUPYKFN4daoF8jCLOb0HarQURMtwpFtX/BXQqeKVy0R20AImiGdxFGjlixjJNxXFEmw3yVt0lqZ/SvugI/rL1Lje2tTbs3J3sZUvJqsMlMBUyr0H1Gwku2GHpj/e5YDO1f4uM5D1YsM5SWqJ2VsIkpNzzNxm+dH8fnGhYmZsx/X1JfVB0C6Lzl6uU4ZfjpjnrcG15tNIQNc9eQtjeiD1DOBy8nJs+wdzP5+Pp+vWTSK1WtVqikfjz+e4/jWQSE94JCBdEaCqj7yT3k5EPQh9Uw20slHTYrPPSJ06CR
 MtJbn+Cz
 X9wqFB/Ijw0E0Yli9/KsfOZ7UCqFpc9TKMTk0nI+EwPRyDe4JrR7taxevIEPAHDvCQcPbVFWkSGjZJDIfZrBMVDNuli91JoDbqheyZ5mbR47iIFgmifcsdlo2FTMfXSjgC+fNBgSoMmZwcE659Q+sJ+son62sEL+Uklep8G24o/48D+T3bXubzwCCWk4O394U4ebQSeW/FOv3ZJRIJij85eZho2+tyvDfRo4XOZIQp1NpDDKF5FAyrD9Cx45dvBglqGd6SnkM400UUdkd5kXCRu1gOEeL+OidaiuuV2gpctyWltx1TrGqBbyema4i2PPVOAVdA2JAKFscnKK/8Vet0kTJxCaz4csgVuIhvcYGUzls1kE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/07/2026 23:34, Russell King wrote:
> On Tue, Jul 07, 2026 at 02:20:19PM +0100, Lorenzo Stoakes wrote:
>> On Tue, Jul 07, 2026 at 09:14:09PM +0800, Xie Yuanbin wrote:
>>> On Tue, 7 Jul 2026 12:57:45 +0100, Russell King wrote:
>>>> No. This information is useful debug for kernel oops.
>>> For kernel oops, I think it should be `!user_mode(regs)`, Qi Xi's reply:
>>>
>>> On Tue, 7 Jul 2026 19:48:12 +0800, Qi Xi wrote:
>>>> For do_DataAbort() fallback:
>>>>
>>>> 	if (user_mode(regs)) {
>>>> 		if (addr < TASK_SIZE) {
>>>> 			mmap_read_lock(current->mm);
>>>> 			show_pte(KERN_ALERT, current->mm, addr);
>>>> 			mmap_read_unlock(current->mm);
>>>> 		}
>>>> 	} else {
>>>> 		show_pte(KERN_ALERT, current->mm, addr);
>>>> 	}
>>> changes nothing to kernel oops. It only skip show_pte() for user-mode
>>> faults, and the fault addr is a kernel address, which means a user
>>> program is trying to access a kernel address.
>>> I think it is reasonable to skip show_pte() in this case?
>> Well the whole reason you're faulting here might be because a userland process
>> did that right? The page tables should tell you (presumably on ARM32 :)
>>
>> And I hate to repeat myself, maybe you didn't read the whole thread but... just
>> use mmap_write_lock(), this isn't necessary?
>>
>> What is this trying to achieve?
>>
>> You're not in a hotpath, why are you bothering to conditionally take/not take
>> the lock?
> Unconditionally taking the lock could lead to a deadlock. Consider
> the case where the mmap lock is held, and we get an unrecognised
> abort from the kernel.
>
> If we try to take the mmap lock again, we'll deadlock, which will
> result in very little debug information being output - and the
> system locks up. The only thing that would save such a case would
> be if the user had decided to use a hardware watchdog, or is
> physically present to press the reset button.

We are preparing a v4 and would like to confirm the approach for
the do_DataAbort() fallback path (__do_user_fault() is similar).

As Lorenzo noted, an mmap write lock is required here because
munmap() downgrades the write lock to a read lock before tearing
down page tables.

-	show_pte(KERN_ALERT, current->mm, addr);
+	if (user_mode(regs)) {
+		if (addr < TASK_SIZE) {
+			mmap_write_lock(current->mm);
+			show_pte(KERN_ALERT, current->mm, addr);
+			mmap_write_unlock(current->mm);
+		}
+	} else {
+		show_pte(KERN_ALERT, current->mm, addr);
+	}

The lock is taken only for user_mode(regs) + addr < TASK_SIZE, so
kernel aborts that may already hold the mmap lock are left unchanged.
For user-mode faults on kernel addresses (addr >= TASK_SIZE), as
Yuanbin noted, it is reasonable to skip show_pte().

Please let us know if you see any issues with this approach, or if you
would suggest a different way to handle it.


