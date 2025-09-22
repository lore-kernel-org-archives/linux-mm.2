Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C3ACAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46CA8E0010; Mon, 22 Sep 2025 04:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E078E0001; Mon, 22 Sep 2025 04:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33FA8E0010; Mon, 22 Sep 2025 04:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A38568E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:29:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37E41140565
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:29:14 +0000 (UTC)
X-FDA: 83916211428.23.CC34D93
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2171D40004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:29:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758529752; a=rsa-sha256;
	cv=none;
	b=dgeBhxx+qI//tPGRpIdQHH0j8rFK0iIY9+CqYPIj7gSZnXRr1KbWjDkrEgVMsRuDANP0wS
	ghy6+Ra90MdvFSfQ7q83Hpno90HT54QXBR5wMnNhpnUcnlIHqziNHIG4wTV/CGfKLGwfqx
	688CgawKc9vdIhLy0az+z6uoYdXhmOc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758529752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pi816NSxpSsHUZbkMSdLHoJH9uRJkzOEaGymZ89+4Gg=;
	b=X536JpimTdIftWLtsSecW4egEkZ6djifADsA7/n+N2+RdFXgHGe6RHw9/36pbswpbbM8Jl
	Ut7jHpMqc+JDb0lSg0VAPbJfkL3uXSpXKdA1++8bbGXCEvn9wmp73AHxBoDMxHuxuD4TKU
	e6QcRI0rEA8X8zASweUOuhOqnqfjl3g=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cVbkP0p5tzddGH;
	Mon, 22 Sep 2025 16:24:29 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id ECF3F180486;
	Mon, 22 Sep 2025 16:29:06 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.108.232) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 16:29:05 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <arnd@arndb.de>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <ardb@kernel.org>,
	<dave@vasilevsky.ca>, <david@redhat.com>, <ebiggers@kernel.org>,
	<kees@kernel.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linmiaohe@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux@armlinux.org.uk>, <lorenzo.stoakes@oracle.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <nathan@kernel.org>, <peterz@infradead.org>,
	<rmk+kernel@armlinux.org.uk>, <rostedt@goodmis.org>, <rppt@kernel.org>,
	<surenb@google.com>, <vbabka@suse.cz>, <will@kernel.org>,
	<xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
Date: Mon, 22 Sep 2025 16:28:43 +0800
Message-ID: <20250922082843.26722-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <727caa4f-5be5-4b59-a10e-8dc9bbc384bf@app.fastmail.com>
References: <727caa4f-5be5-4b59-a10e-8dc9bbc384bf@app.fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.108.232]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2171D40004
X-Stat-Signature: p375r9b7t9m6tmc56eggqxds9wxf89kd
X-Rspam-User: 
X-HE-Tag: 1758529750-442885
X-HE-Meta: U2FsdGVkX19/50uXlCSw5X7uEWVK09pQA/a8M8uNjtj6hoq11vFU2yUUIHY6V4U10tZQ6ihEYrA0VGkmDhZKOstxHFnDSbIF+d1JuQ8eR2OO0mh2TCQcdT350ANu7ggsnpH3ryj7JPRoLFzliAdrEE1vmBLILqUOMhdaypJV29kDHFQVYzRIIjzs1dkCUcYXgTdIrnWC3Kpc1jxLG3NPO2SesIzP+QHsLiZE1Tpw/y+2gvXYrk5QNcul8v4SPb7PHc934TELufVeAZAxbD0EqKQvBksXfEtyU2/ZfPeHwP+LFEmwZKxFZ8mg1ToldPNSqzsjq+Piq6GBqLtsLz6yIkpPic3WMk9UIpXfVGAdivwtmDFhjZI0XBRJBIzYTuanmGhBfXFajd3+IQzlqhj+THeM+mCkIX0MGtckvZGH3Ci1dkTHC/JuR60ROJlRAcpTllkHFJLjQVTmnXfkAD67pre5Mgzd3yLfLZWjjgu/AU9X0g6j4Id9LTiiCVVCKwF9SQCvQ0Rhljhi2HC8Y7k9p4qkJGDfaFnyujRkB0EjpYiuQ8QyVHIXiK0pOWOHWQ9GKqo+55dXTpsIpLEGxahHGae9VO/8mi9ouzrjCCapR5qgd6uHn4+fiRrJOVycuDY4DOGHB5YQh5zSfJnZITSoe0/wVX6212bO3yu+xFvPkd8BgykgZZJ9qaOfSE0KyK2KORuPu+1gF0jlTXMT/3Nri7Qu8r36Wcl3wQfPWa544eG07GV8gCAhVjQb8mYmfvSu18XDz5uSJNb6cpmN7GIyBur5vcPv4GlJu+JFshvLRHX1ZH1jqsabho+BQng/WJL+G/9+mIbCu0BlemNU/fItZFgE1+ihOhlP6skax46RpYv4LVr2bOZiCd3G05959m6rKTbwmfT4OhQc1/z+VeBBvu4Ne8u1G/J9EXRI5G9+6jttM8GovShQrtADkJnem6l1uNxVv6TeRZ01r+T46T+
 152Ko4RT
 l5PTo/VQmEGMgk7TNhkNX2jy5E1aJzWE1GoC+oUsK9iRLrbQrzx9DSRKulKXHt21MuvNFUYxQnDTwUXp3T2DISSYZlEPWm1F+OI2z6Xcq8J3pHPCqQUhor3r+bnXFgVqD8dkSnIqZjkXze51AVC8K3Nq6Vgor0YrZY64tzESukBITFx2Kfnd4L0dlq0ZWOpoXqjHgygomSx0dFO3kfQZYdp/+rUf5n+SZ7yNLjoNtYZIM4OoWia8U00IugQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> It would be helpful to be more specific about what you
> want to do with this.
> 
> Are you working on a driver that would actually make use of
> the exported interface?

Thanks for your reply.

Yes, In fact, we have developed a hardware component to detect DDR bit
transitions (software does not sense the detection behavior). Once a bit
transition is detected, an interrupt is reported to the CPU.

On the software side, we have developed a driver module ko to register
the interrupt callback to perform soft page offline to the corresponding
physical pages.

In fact, we will export `soft_offline_page` for ko to use (we can ensure
that it is not called in the interrupt context), but I have looked at the
code and found that `memory_failure_queue` and `memory_failure` can also
be used, which are already exported.

> I see only a very small number of
> drivers that call memory_failure(), and none of them are
> usable on Arm.

I think that not all drivers are in the open source kernel code.
As far as I know, there should be similar third-party drivers in other
architectures that use memory-failure functions, like x86 or arm64.
I am not a specialist in drivers, so if I have made any mistakes,
please correct me.

Xie Yuanbin

