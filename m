Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1B9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9113C6B009F; Tue,  7 Jul 2026 09:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8E26B00A0; Tue,  7 Jul 2026 09:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8012D6B00A1; Tue,  7 Jul 2026 09:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59E636B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:15:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7F8EA021C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:15:25 +0000 (UTC)
X-FDA: 84962027010.18.4A3E952
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf18.hostedemail.com (Postfix) with ESMTP id C34B31C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:15:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="dWFZRQA/";
	spf=pass (imf18.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783430124;
	b=iqbuud2R/U78OmUJC31qdTHlfhIeoCnV5f/0/AJtCf355hGj0QKKVYzlylleK67ySHWl4B
	jEh62WwJr/8t15jSEmPKI9No2tHqbZFB3BKptM0mrhRUJiFzV7pEXkgHKcY1Pf5PWXMJTE
	idt7Ndf7BMAlVHn0sL9hYedv2I5hfNk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="dWFZRQA/";
	spf=pass (imf18.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783430124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTq4yOA49QhlXOXrp8xyGqUIQBxOwKD7PpLrzm2nnzA=;
	b=XV06+kqwJDblhCPvEWgXu961ZjyN21GN19/Q1gARoJVjk+hg/zZORyBRFNCnR2rgboD8x/
	b5cBKZAQP5ypGRDQce6sm78CR/YsYpMKSB0QJQaG0IeG8YA/xbe13h1N67clYg4857Naj+
	aOiqL/sLGHr303uaRBMKi2IwHII4alY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RTq4yOA49QhlXOXrp8xyGqUIQBxOwKD7PpLrzm2nnzA=;
	b=dWFZRQA/SlDxm0OzZwPM5aA46486uARLH+zGJkfWCpwVsyF8r0gA5lZfgOPQl5oGLytPvW2y0
	B5MOax3La2evsFXGJ44vJUj5867CG4GVv66bFjIpG150jHcE0eNS4PxH6M7xthz4NR7rJnHe0ky
	6jLpuGpQLP2U800LAzB0rr0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gvhLN4KN4z1cyP2;
	Tue,  7 Jul 2026 21:06:04 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id AC379402AB;
	Tue,  7 Jul 2026 21:15:16 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 7 Jul 2026 21:15:15 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <linusw@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <ljs@kernel.org>, <mhocko@suse.com>, <rppt@kernel.org>,
	<sunnanyong@huawei.com>, <surenb@google.com>, <vbabka@kernel.org>,
	<xieyuanbin1@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault() under CONFIG_DEBUG_USER
Date: Tue, 7 Jul 2026 21:14:09 +0800
Message-ID: <20260707131409.79043-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
References: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C34B31C0004
X-Stat-Signature: qndod1n74zt5gd76ijmz375fzai3azc6
X-HE-Tag: 1783430122-588920
X-HE-Meta: U2FsdGVkX181RmY8pfc/y5LwBoso0XDoKPIcA/nHRAroWvAz6PVFTsI439GCy2ASiExvnGlH4LPX8IKVBKKyPDUh0tS5lqQ74DNFcldfwTeUKNSMLp7ovpYyjqVsXxF+cgMOow7z6LfE0DVjy/VMMuTWXu4WX58kEh+YbHRFhlZ8ZCBsuBqFX2+3tRNKIrnsl/gb3RXOZITJf7gnjDUT9X4cZy+SWsDrA8o0hVcKpRZRESXrPsmqeyUOh9Mx3/r1xour8BLA2YY86VjIpsc8ZowNh9F2XwZBSRgauexjv0SUwS0ZKN9aZRq9Pi2ODzq5kYPJTse++tyqspSWangVrnI6gGVYjqN1K+LggRvsC3q8AsKoP6xIygwIjGciN/mfWPQS5fY2BKsogcyJJyNOHUAVYqlbtxMs7REOe7JG2P6LwSSHngl3b8wVuMzdDZM3VUOGu75i8S49TgEl4Sz6jmCfNP4iwGHVElGzbDYDHUopckOldwsMiNddou9GdaJGS6riOYME4gV3k8nAbLGm7sy3PJgjZbqNpL9TCX8kFNQCoyuXhZdcerNN1el1R2jw97i5bSYbSVS5YkrH9SS2rbPBoYIw/68TwKByRS9DIdhqGRJIIRg6wv5OPyC0L1FWpP9dnhIbuB/6jzynGGSG89RHbTaavctLg7fvM1q5SNFGMtiCW9Nai1sv/o8MWWJbyEv0yhYq9BIyRt/xCWky/gP+ylHQkZ5RWOfggsoPpag1O2AVRhziHsOAWzTVlKsJ0oQWXWavoxjrEzJZmYTzHlRrLnCgFNqlZf5kFbenQ05/r/BzEBo/SPn7ip50kXr8emxRDFbPHNoJCv96wUJjk+SGtYBOl7Kv+pcMp4/IR0RnsLnK0TFTpYZBCpaiWRH1zcoy0rKdPjX94EfVOa4AY3HS39q/Pjbw3QcubXvddrdkCzssECcDcNuZSnn7EeHpfTNMc2HCNrY2KmZVyq3
 r+u8aqK9
 d92c9VVsALgdXH/ZMLPuwxgIOzakxPEl5iitCIhFsdkMHkw0j+m8Gvh9S2axdoIcSu7fOuwHxodooJhSgnW6QaufMNjP5YluE+7v/kHx9DGf+nJ6Gng0wFBr9VGJqBYNCv1vtJntKzmpe5qyjo0/AgVsQMY+8l2oNZmSWzB1a3I17IMoyhVFfr6kF+ZznTLLRRJatz3dc9WMgytJ8QOXs+sf04qp9WKgkex0ZnBf1aVKrfXDIdC9GMXr3vI7xly2P16SNRVeZwTEsPMF3CuWtq0uOVCteDAFXTXaIxEYYufdatqHtoj/3TVly3R8K6gZ8pf02fjxw+07LHYuhR0tC5ggKZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 12:57:45 +0100, Russell King wrote:
> No. This information is useful debug for kernel oops.

For kernel oops, I think it should be `!user_mode(regs)`, Qi Xi's reply:

On Tue, 7 Jul 2026 19:48:12 +0800, Qi Xi wrote:
> For do_DataAbort() fallback:
>
>	if (user_mode(regs)) {
>		if (addr < TASK_SIZE) {
>			mmap_read_lock(current->mm);
>			show_pte(KERN_ALERT, current->mm, addr);
>			mmap_read_unlock(current->mm);
>		}
>	} else {
>		show_pte(KERN_ALERT, current->mm, addr);
>	}

changes nothing to kernel oops. It only skip show_pte() for user-mode
faults, and the fault addr is a kernel address, which means a user
program is trying to access a kernel address.
I think it is reasonable to skip show_pte() in this case?

