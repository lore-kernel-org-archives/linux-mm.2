Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20402C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 07:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D4D6B008A; Sat, 11 Jul 2026 03:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D886B008C; Sat, 11 Jul 2026 03:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A531C6B0092; Sat, 11 Jul 2026 03:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 885C86B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:58:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 311DC90BB0
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:58:30 +0000 (UTC)
X-FDA: 84975743580.16.FDCBEF5
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf24.hostedemail.com (Postfix) with ESMTP id 924BD180009
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:58:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LGE0hMkP;
	spf=pass (imf24.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783756708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxQ1ovDyhvvGVyJA8vX4ADWtfoejcpKh9n/5W0S+X/0=;
	b=i56ULzq2o3hbRPD30xF4UOs2QwgiBiOOn4X+4UbzavZXjrJNpshV5ElvrbjC4fkQtJpF1S
	8poOpLA6hRLbemCbn4HpcpyyU53SkbXXVnYtV5Hq7FMadidi6r03cIUOMI2BZhSkWIz0sc
	hermEbRZWFCIh7RjtOe7JG1nQL4qvlg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LGE0hMkP;
	spf=pass (imf24.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783756708;
	b=7DaMYqIdP5QND7oT8msGzRwPxX2zXOWycxsTR66YC7Zv1vPPdnsTAg5Ueq3J6Ckt2av/GX
	pg1kOj52HTAdaed3S9usARGUJDEKaXBI3k9119agKpUVHDXCR6G0MY8mMhlTGXAKqPvHXU
	5TRSiTIwaHO4Rh6EGil94hFSmXvgK3s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pxQ1ovDyhvvGVyJA8vX4ADWtfoejcpKh9n/5W0S+X/0=;
	b=LGE0hMkPdeowF8yD213VC9YiTyviyT/M2oD99py9EoMELuo+yzb2Xxzktwdl1yL2SwXYpkxDo
	ZfyuWXDn3tnB2Uww9HSLUma2+9wm+SWtuOJrVOmJZOsit9u7nuBfzLvdMSRySwDTU5is/OS6IU5
	CkHnKcQ0jpUQziohLwrrmRQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gy17J3HW1zpSvB;
	Sat, 11 Jul 2026 15:49:32 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id D4A41203C1;
	Sat, 11 Jul 2026 15:58:17 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 11 Jul 2026 15:58:16 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <ljs@kernel.org>, <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <linusw@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mhocko@suse.com>, <rppt@kernel.org>,
	<sunnanyong@huawei.com>, <surenb@google.com>, <vbabka@kernel.org>,
	<wangkefeng.wang@huawei.com>, <xieyuanbin1@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault() under CONFIG_DEBUG_USER
Date: Sat, 11 Jul 2026 15:56:51 +0800
Message-ID: <20260711075651.3114-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <alHnqsIdcMghnUER@lucifer>
References: <alHnqsIdcMghnUER@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 924BD180009
X-Stat-Signature: eq7nc8u99uc7txdkqsfjrsdm4etbpaqi
X-HE-Tag: 1783756705-414693
X-HE-Meta: U2FsdGVkX1+732gxsJg/LNyIhCHIU2n2RROvv+e1iX1aieysKvkWk25164JIcY5Gqb5WUlfue50Z6beqi2bYyOeSE06A5ltfSxGcMBKDVg4o7D/erAzi7dnl6ePoFbPAiYuAQpsSanjQaptycMc65FNcCwE6Ov+od58stxDkS/G7pLueQ0gM+wCWoWVE798zpJ+5ImgIT94pVx4bLrWco6p5YTGzPyO/OUuSLGP8nzc+KWpZgfRampHHpANoQ/zmQwDxEH2cBjhqdJvZ83zPtyf/dGEIW7NoxXzNbZnEoN15W7IbDTjbSxXKxOlaaYjLTVlDYeU1n2IFTOHnjEISmh4t6cG8pY5vPLdh0rzQIK5M14WHBiXEMaJ6jSCC0d+EMYda7A0aYIlwt+BNPUlHT+f9a7FZaG5vHQjxK+QR42Zgrwug24xbqvgjuQcAD3q1OgizJv2c76gYYV5UJhNcPuKNocLcJ3DrbhHWxWTxza9fHuvcLsOBS+NksF9smbJ989cPVm0Q3ym8RXZJ6zANr5+3LTQAqNtTE9OgvuMfwgIX6sh/mWeGMuwAcIbHQXPdRxvXjV4XHyGmqFCNsUq56svWCrdkpcuQuYXuI+9+AUBrfPTDwCm2wLoRb2JV5FnXN0UNMv7OjnOrQwj2rk5cnWFSFsaNyO2t5ewpiTWvcNBuBenJwWJ5/IRjMKo1GqzhpeF1W1GsFgp54gCydbTVApYJ9gYg1j327I/97RcdKBNfP5Hodo9G7vE8Mso2LwCZNVRNI3awuDnEfiszS8HgO3kUGIETU0vFZZZ+4tFLgOAoCjStCRsjRuK6gaKc+OXIfiTUltsnN/4g7wty8x/O8caASVlIXuYfnWeBw2ffCaij7qP7fmYFWty2e6rDkbR3XhqggV/dhonJbl5dbI3RexZ7WvqzpGm01xyiIRSbfCaNDBYhos78V84x31R4OXl3AaVHp/N85Sl0E6Hc5hl
 7iGPoKG8
 bzk9BLJDvidEzBbgbbOdR/a2yULYvh0s9cVzc77vEayUlB2A/N/+ZJdt2tReIcET+1+AFzzVnraST62z+M+HM1BlNU4FJiE6FzfpUokIDLPU8pQFJv8gSQvXymqYGP1pSpHct1qGeWI9iaIClKkOCvI1zh2OfSC2CEPHaVO64rZIXZmN/o0i7M9vsfrGuehkN4WiuCeDlp5iTi60cTSY1hocuc7DF4P1DOjEfCmTJPs2A0Hk3Xwob6znoy4W7aYafiMakgca5SsooIbvCciXRAzO+bD8ezd8VJ+HYtO5ks4mP+PAsnzkyJvvWuSk9zd2FfKoz/P1fwNwAs9yap8Xlqbbgx+9cfl0IdhnRUrxJC7lP2TTtnprjdW/xGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Jul 2026 08:27:23 +0100, Lorenzo Stoakes wrote:
> In general yeah but with mmap_write_trylock() after you add the attached
> patch to a series (making sure to cc- the right people etc.)... but also,
> wouldn't you just generally want this in show_pte()?
>
> Seems to me best way is to put the existing show_pte() into a __show_pte()
> and then do show_pte() like (untested top of my head thing):
>
> void show_pte(const char *lvl, struct mm_struct *mm, unsigned long addr,
> 	      bool is_user)
> {
> 	/* Write lock needed to account for concurrent downgraded munmap(). */
> 	if (is_user && !mmap_write_trylock(mm)) {
> 		printk("%s[%08lx] unable to acquire lock for PTE output\n",
> 			lvl, addr);
> 		return;
> 	}
> 	__show_pte(lvl, mm, addr);
> 	if (is_user)
> 		mmap_write_unlock(mm);
> }

For user faults, I think we don't need to worry about deadlock issues.

As Russell King described, deadlock problems can only occur in kernel faults.
On Tue, 7 Jul 2026 16:34:21 +0100, Russell King wrote:
> Unconditionally taking the lock could lead to a deadlock. Consider
> the case where the mmap lock is held, and we get an unrecognised
> abort from the kernel.

As we never return to user mode with mmap lock held, so for user faults,
it is safe to acquire mmap lock. This is just the same with the syscall
entry of `pkey_alloc`, we immediately acquire the mmap write lock:
Link: https://elixir.bootlin.com/linux/v7.2-rc2/source/mm/mprotect.c#L1011

For the kernel, the user faults entry and the system call entry are not
fundamentally different; they are both kernel entry points.

