Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A279D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 13:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA9A6B0005; Mon,  8 Dec 2025 08:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774036B0007; Mon,  8 Dec 2025 08:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C0D6B0008; Mon,  8 Dec 2025 08:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7116B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:19:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FEDB1DDDD3
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:19:28 +0000 (UTC)
X-FDA: 84196360416.30.B9F6056
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf08.hostedemail.com (Postfix) with ESMTP id 38085160016
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:19:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n7TqFqQ9;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765199966; a=rsa-sha256;
	cv=none;
	b=x2FOBSSwyI49Yma5e5RdZyNnbZGRRbAIQHUTxfYljsQ6+cZsbk8YSX947TU/Drf+r80M8T
	QRMK1p6dcktrC+ph2bqyb9WyvZL3OvIvXw9S7qewSN6xhkoRKUNRcogOCdIUQOjJI5Xxhd
	CKxdwAZRhPEuKn9UCyKixZEqzE2BsPs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=n7TqFqQ9;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765199966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysrxwg/xE7lnFNGohOCmC7V8F5GKgROP0io5QDz/Zq0=;
	b=CRM5EgKfl0C/1EyPx8+G5cm50K96BUVgSyVK6+tF/3q8ME3S2et/iZmyPzZTkasPug0WN8
	cF7j1mk1RuY5QEHTQAyBUtnnBLl/qagSiwudMp0d/AzHVtiStxwX/hFLdW7djNc54jtRgU
	O1SHhwHbXVjKh6uPKHkeNCevO17wQao=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ysrxwg/xE7lnFNGohOCmC7V8F5GKgROP0io5QDz/Zq0=;
	b=n7TqFqQ9HTOt/u0LYnDQ4xGo+E13YxUv9GwtCrD38j0HVMGcYV38Luu01lOwQVG9NtKS53ntG
	STyMq76qqXq6/3MxzS2v99EqMwtmzBwtl5kAQmEHZOyQ3P72eNiW9+a6LrJw9ko6M0h3eHM+Zu6
	kL1nXtXwR3olt0dg2KfyNjU=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dQ2ZM3grbz12LK7;
	Mon,  8 Dec 2025 21:16:59 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 4EE9C18046F;
	Mon,  8 Dec 2025 21:19:18 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Dec 2025 21:19:17 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>,
	<catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<pangliyuan1@huawei.com>, <torvalds@linux-foundation.org>,
	<viro@zeniv.linux.org.uk>, <wangkefeng.wang@huawei.com>, <will@kernel.org>,
	<wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger sleep in RCU context
Date: Mon, 8 Dec 2025 21:18:42 +0800
Message-ID: <20251208131842.76909-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aTajXdAVYh9qJI6B@shell.armlinux.org.uk>
References: <aTajXdAVYh9qJI6B@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38085160016
X-Stat-Signature: req4t7k7cswpiuuqcnzpbdycmgf4knhn
X-Rspam-User: 
X-HE-Tag: 1765199964-217032
X-HE-Meta: U2FsdGVkX19SqkqfVjjdm1Zvq2ssClTiKGEfJT719LVE32DnAG7sBgf45OGyECcLXri1Y45vzKwVEKBPyxK1OUZgwXArqDR0vqbUnfmwGODr3tx6OkVpXphFfXBvFjuPIvq1nTwwtkt2rVMl/pmaQkg58eSi2j7hR2V2Go7gBlAazxWn55t4UKl/lTFtGAGFdcIYM12C8vRwZFMAS5f9EzRN8kok2csGl9vn5Pr+7iv/2D82reDLNyDaMANbN4YpQUNxAq9CQ14oAt29ShGBWsTilJzrQRtKmC764zZwdbrggJyiGqon8yGoY1J4gRh5E4bImTdq3al+VY3yCsJb7vx+p8buztNxxFGrX9s6TWFJKq2KLLIrunVXWPeylSSlfXcxsEsgqlQyROSuDyyBZ9mWvShQV9wgCiI7z0LRKuC18vcBbVp3X/Y9zds3Qpfkdn8yQP2ftSdAeIIGPqBJ2Ap+V0rtohd41bkKTU4lBboygpv2wmYF/+p+Elgzj7ke6PJK2yyMGbC9jf/3Ds7trObGtk4Oq5BB0G8FXAQQEQ53k87sTAoLKBaermNQN04B2HTRaTFWhqHtrkM2opVXQxSpJ1In9LCi5kbLMw6XnMxAlgjpEALR5QCNMuRSROp3UU4/1sM5jQjt/cleGUSwuL6fTxGAuXE4vctbgeUIaNTO1wyqP4OgO3NscSdtHXMziRTFUZEkIForbn/B0f2PEt98vNhUkK0TxgFk/7vXTx1K7sKYvRUu2MKi74DNNzeYu/uUv21rbquQyKIX1pViZ40ccXaHWPxzS4d/2kuyWBmNNqqEAshwtD/Dh7wC1+YXuLE9ZcPqb6064mrJjPvOXccVboYaGFlI3UG8ena2kYdH1LHnFRZ+wAN8nAiPrBqKq/e4Bpbg25Gvn2J/oxfYyx4TWYOsZeZAfJGlEcFZ3wq0DZJS5W4LLgT82+7hZ+X73U1OjzEw4FACo+edvZ/
 CJ1Dl0dr
 z7lFfLWaHV4hKan7uR3CnCH9Vt5Sch437UtOPe370reQ7dChqAKfYK0+FKpdFTUbPQ4xEltJXxfrKtpaEyV79wDnfy2OJ0PHLYhku9uHf06wqrEdlDJYXcetjB1l2CSxba+WcBcgTgMe3GgWUbmSnfbdYjLVS44tmlm5jTLPKW3QczYu8tFknpTrAyGN+QRbg6SR5nMHGSiWqBqxq/pF/A4UHk/YFlYVz2tvO6gWQAB+GFGLRH90EclQlLIcA6EZuy+O9YQ7b+JnQ9rZZD8WnPK1ENEKKKM6O0UfkUr3MFg3s2r3WEhiaO2chD3dhdlMYA90w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 10:07:25 +0000, Russell King wrote:
> This isn't entirely fixed. A data abort for an alignment fault (thus
> calling do_alignment()) will enable interrupts, and then may call
> do_bad_area(). We can't short-circuit this path like we can with
> do_page_fault() as alignment faults from userspace can be valid for
> the vectors page - not that we should see them, but that doesn't mean
> that there isn't something in userspace that does.

I had indeed been lacking in consideration regarding do_alignment()
before, so thank you for reply. But, may I ask that, is there a scenario
where user-mode access to kernel addresses causes an alignment fault
(do_alignment())?

In your last email, you described it as follows:
On Fri, 5 Dec 2025 12:08:14 +0000, Russell King wrote:
> Also tested usermode access to kernel space
> which fails with SEGV:
> - read from 0xc0000000 (section permission fault, do_sect_fault)
> - read from 0xffff2000 (page translation fault, do_page_fault)
> - read from 0xffff0000 (vectors page - read possible as expected)
> - write to 0xffff0000 (page permission fault, do_page_fault)

There seems to be no do_alignment()?

In other words, is there a way to construct a user-mode testcase which
accesses a kernel address and triggers do_alignment()?

> That patch got missed - I'm notoriously bad at catching every email.
> There's just way too much email coming in.

No need to worry.

> It's to keep the behaviour closer to the original as possible, on the
> principle of avoiding unnecessary behavioural changes to the code. As
> noted above, do_bad_area() can be called with interrupts enabled.
>
> Whether RT folk would be happy removing that is a different question,
> given that they want as much of the kernel to be preemptable.

Thank you for your reply. I have no objections to this, although it might
introduce some unnecessary code paths, at least it won't bring any new
issues.

