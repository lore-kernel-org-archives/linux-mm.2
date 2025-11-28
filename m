Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C24ECFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 02:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4924E6B000A; Thu, 27 Nov 2025 21:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41CC86B000C; Thu, 27 Nov 2025 21:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E45C6B000D; Thu, 27 Nov 2025 21:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 187476B000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:28:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6CDD1402C4
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:28:07 +0000 (UTC)
X-FDA: 84158431014.13.FC5603D
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf06.hostedemail.com (Postfix) with ESMTP id 56D8C180004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:28:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v2N7Xi15;
	spf=pass (imf06.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764296885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8t+SKLfB9YSz+ESvF8MmSt0kWBtO3/8g8KlI38flHHg=;
	b=DED+FZMpQhlk2jJGkErHaUQiTDb+gP3m9pB+/sY5bNxJMUJmsdnt474UQDYUgPrMi5gxHj
	LUgXrBOTI2sXzJYvPbfHKDD1lXOWejvPYJQ1LeZYIaZa3+Co+dOlr/TL3xTbJTii31yQ23
	vRrZsctbSJhPku+qRM+JxXqFbt+Etb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764296885; a=rsa-sha256;
	cv=none;
	b=OFv9Ozin+ODyL4UzV6nBl/5h1EtSs82rGXwztMOS0YqJSItGxk0VYxXt1SlxJ9J5U+oYuJ
	XYUN5Jof49bauvLbar10X95SkkoB8GSQMYqiUOPVB+bFN/RLT3atGkj5Mfo1YS4VN6aXnn
	s8w6WsePePDO7MXAtmLreMGLN4xVcdY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v2N7Xi15;
	spf=pass (imf06.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8t+SKLfB9YSz+ESvF8MmSt0kWBtO3/8g8KlI38flHHg=;
	b=v2N7Xi15sXplM6/c4zwcXTdDZ2HeUyMB89bLjFelMFddlcr5SnQGmd1D8l3sxpZjoYTCwEAV4
	CQO8Hj1I6+GqeRNUeZkUdg1otg8WO5cwKOrZNH7wZtZ8gYwtw0xSlwKkysFtHoT/nlHFrdflYL9
	fso03TKP5dqdUWTiC1vO7+w=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dHcc36LWhzmV79;
	Fri, 28 Nov 2025 10:26:11 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 0145F1A016C;
	Fri, 28 Nov 2025 10:28:01 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 28 Nov 2025 10:27:59 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <bigeasy@linutronix.de>
CC: <akpm@linux-foundation.org>, <arnd@arndb.de>, <brauner@kernel.org>,
	<david.laight@runbox.com>, <hch@lst.de>, <jack@suse.com>,
	<kuninori.morimoto.gx@renesas.com>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux@armlinux.org.uk>, <lorenzo.stoakes@oracle.com>,
	<marc.zyngier@arm.com>, <nico@fluxnic.net>, <pangliyuan1@huawei.com>,
	<pfalcato@suse.de>, <punitagrawal@gmail.com>, <rjw@rjwysocki.net>,
	<rmk+kernel@armlinux.org.uk>, <rppt@kernel.org>, <tony@atomide.com>,
	<vbabka@suse.cz>, <viro@zeniv.linux.org.uk>, <wangkefeng.wang@huawei.com>,
	<will@kernel.org>, <wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when handling with page faults of kernel address
Date: Fri, 28 Nov 2025 10:27:56 +0800
Message-ID: <20251128022756.9973-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127145127.qUXs_UAE@linutronix.de>
References: <20251127145127.qUXs_UAE@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 56D8C180004
X-Stat-Signature: spaubmnxumuhu58xyn8hubgibambij1s
X-Rspam-User: 
X-HE-Tag: 1764296884-184542
X-HE-Meta: U2FsdGVkX1/kKn6UsfUwV18LhXrCqs3ueO2aU7dVohU1cZBbUWzbO4Ml8x9bDt67lLPYDS/oJE6aF+Ovd18knp7duWfUQVo0Up1M2B8W1bKg4GqDXlepzRGx5Egs3GIhXIMsncgcjmwSmn4dgMmBtJcfrT/i5s3vSKp5ZbqCBzd2WyqtCAqqpNJp/tYR96SiHS7kE0eLIaomzaXphe8lohnPdOM7X8wePkR7yyyQhVLFRbfOk0Ad6R6SxRRX+9vNxe37gUUGTxRLL1huI4iJ0FWbgCwh7a3U3UEz/DwmZU/oDLbH4J/JFCrniVGeZ4VcCc03j0mQvro9EkLuM9qSpz9Zd/Gs9Z3FfK/DcKu9famM0dcqy0lW7tIBFeW5bZMPCqlYwULALfzVa6RJ1KHAseM2TFspHjSZ6OhZ0kzwejPmvUECtUrZuv7BDJUwrnqUl/js4jMwnRhZWV8XcxmvIRLpmZZ683mQQ0yHrytF96d9iO3ArRX2EKQMKbGzqNCavCpKb01qGtp+A6ycQLvyNjR/qhBCHrfeIwsxwFaqDxnbLf2dEunL+khhEJpH0qgLxeywd6bycQeuxpADUUxeJrQIPkaQ0lo7gmWTiKeh695KbneLRgq9gUG4Q3IveHT57MXf0qL0fZG9iVI6BZ5nD8y2ou9SunFNU1EhdWtwu16K01w1MHNwn99/Qf/1dt3sHIzztRytu1mnR/6dcKk7NjAuCX9vGEOGqeJGG6YZIneNveB0qLQi8s2oud6sBjq/nyo9bFvMMfgLKRfgI/If3Dg68QFCZqk72HeZI9hFzZkOiRUibuLckmssna82zWg2jvmBUAz24jWqpzLd4TgaH9Cj/s5WySmjounxcynkuzyOMvJWitQGa80qZjJXbVYqObdxtlonHYp7uaLc+uEF6mNFoMmDjBcMk1R8wjhN6veuImWkt+noMAqob57xSct38Y1MoYBAn4OfUSrtC26
 pUlDlX+d
 Uoi+aPNrhUWVIela/s+1uykpCwhwyClbyGoKXCKqHWwS1xpcrM6hs/fI35rMgY6bGjpbZTrztPg5YIWp/tG9jDDeO95OoIdfa1u/QjSDN+h4EUqdewJgK84nMOPT/gY0xdA/Dh6slvCdlRmTeA7okWXVAQlMWiRq1Z+74fIF6gNHsuoGQ/qQasOXIPECPEQk6NJqmiw5GVn2tRxlaHvdft2bqAnRmyQcDSNBudiKY0R0p82/WiQAqmSSqV1otwmWw28usFIUqUBiUpqCVlWWavhNfuDKobrXgwW+UPtwQigPVnN3GPWqkCnk/tzy0wAMeH3csLT1VolxfZD4NPPBUQLpzHgP3jxtpFtu5pxsm24sTqyscsG5uZ0FSdvXAvOUPEMc8hbn384xuQlb9gKLmu0gt997wRL4DAZEF1kWGMez3czwat732lGm7hU2BDBhoNEQ1qAnbGJlDZ9gai9Aqa+V6OimsGDHjgNQjlhBKgjxVnIc+qrwiPmwaqgJrDBBwAWj0my3Dq6dFieC9eMd+m3Kea7bheNdw1pIf5BstlGFES9Fig+Bb3ProAQXfzk3g/pgG/bXVS5DKMdA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 15:51:27 +0100, Sebastian Andrzej Siewior wrote:
> What is with the patch I sent wrong?

Hi, Sebastian Andrzej Siewior!

There is nothing wrong with your patches, but when you submitted
your patches, this bug has not been reportted:
Link: https://lore.kernel.org/20251126090505.3057219-1-wozizhi@huaweicloud.com

Your patches fixed the missing mitigation, but the aforementioned bug
still exists. I think there might be a better solution that can fix both
bugs at the same time.

We had some discussions about this bug:
Link: https://lore.kernel.org/CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com
Link: https://lore.kernel.org/20251126192640.GD3538@ZenIV
Link: https://lore.kernel.org/aSeNtFxD1WRjFaiR@shell.armlinux.org.uk

According to the discussion, it might be better to handle the kernel
address fault directly, just like what x86 does, instead of finding VMA.
Link: https://elixir.bootlin.com/linux/v6.18-rc7/source/arch/x86/mm/fault.c#L1473
```c
	if (unlikely(fault_in_kernel_space(address)))
		do_kern_addr_fault(regs, error_code, address);
	else
		do_user_addr_fault(regs, error_code, address);
```

It seems your patches hasn't been merged into the linux-next branch yet.
This patch is based on linux-next, so it doesn't include your
modifications. This patch might conflict with your patch:
Link: https://lore.kernel.org/20251110145555.2555055-2-bigeasy@linutronix.de
so I'd like to discuss it with you.

Thanks!

Xie Yuanbin

