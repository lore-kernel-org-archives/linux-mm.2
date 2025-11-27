Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C04ED11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2706B0012; Thu, 27 Nov 2025 06:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99ED6B0022; Thu, 27 Nov 2025 06:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6EE6B002F; Thu, 27 Nov 2025 06:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1856B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:21:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 566765BD95
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:21:18 +0000 (UTC)
X-FDA: 84156145836.05.A426AE9
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2F102A0003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:21:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kzAHUMF2;
	spf=pass (imf15.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764242476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DodGNQ4J3R60otr7WXzwptpN2trZwaXPd+16aznDXKU=;
	b=QHOv1UP1HCuJyrLQpcm0/SDKWVqcJ1BpmD4FQExkWVdwkFUAdG2c90UHqqTPRcfRMedxwI
	dHDWsoPRwKxUx9pBvVAra/XoTpcIL6EzzX6lOKIGFT7gmh2xei9u1YGnXXP4q0h3Kc4SnI
	MEHPZf8J6m2gxfB0Y9WicHuNiCUIZFo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kzAHUMF2;
	spf=pass (imf15.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764242476; a=rsa-sha256;
	cv=none;
	b=MQQ/L5YGVg8VsO9eLi84z9FoK9+5ccVQLb07z8md+8MTdaovqPYMbTA60W+1YbBaSU32K1
	ChlkU5/LWvEqYkymLbcuC6IA7WY31q5/DP9tW5/51TnaU3adq7PePpTrfK3XCOmO8/8faP
	ovQ/wmCDCoxjz/y8gNqDGFnNEtRDA9s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DodGNQ4J3R60otr7WXzwptpN2trZwaXPd+16aznDXKU=;
	b=kzAHUMF2dUX/75F2x8k4f67X3bwt94v+LeKbd6y1I+Pfnt/W9chF7FpLBH1NgTjP/L/NGfo8n
	xvIQ0+PuPafeVGbUpzBFi9IJnhCxY1y3YnVnFQlCNNtgM7nYb04k1porCfASxHwGKtjxPIckwVs
	1urT6Cq6FxhqN1lH2J74Qto=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dHDTl6J2qz1K96R;
	Thu, 27 Nov 2025 19:19:23 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id CD7A614011F;
	Thu, 27 Nov 2025 19:21:10 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 19:21:09 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <bigeasy@linutronix.de>, <viro@zeniv.linux.org.uk>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <david.laight@runbox.com>,
	<rmk+kernel@armlinux.org.uk>
CC: <brauner@kernel.org>, <jack@suse.cz>, <nico@fluxnic.net>,
	<akpm@linux-foundation.org>, <hch@lst.de>, <jack@suse.com>,
	<wozizhi@huaweicloud.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <catalin.marinas@arm.com>, <rppt@kernel.org>,
	<vbabka@suse.cz>, <pfalcato@suse.de>, <lorenzo.stoakes@oracle.com>,
	<kuninori.morimoto.gx@renesas.com>, <tony@atomide.com>, <arnd@arndb.de>,
	<punitagrawal@gmail.com>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
	<lilinjie8@huawei.com>, <liaohua4@huawei.com>, <wangkefeng.wang@huawei.com>,
	<pangliyuan1@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad() with rcu read lock held
Date: Thu, 27 Nov 2025 19:20:35 +0800
Message-ID: <20251127112035.129014-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127072057.EbvhUyG4@linutronix.de>
References: <20251127072057.EbvhUyG4@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: 2F102A0003
X-Rspamd-Server: rspam02
X-Stat-Signature: k7j16jp1gbfhgqxysj8fpfqbnwwh3x7f
X-Rspam-User: 
X-HE-Tag: 1764242474-976487
X-HE-Meta: U2FsdGVkX1/BrMPtSN5HVBugdiqmDPlVCg9hsM3P2AX+PI0Gqzkyo4oe22Nl0sQ90uNVHjXhS534K6B8H21kHW9XWQCrYznzgEBsn6ssWWIoZzHI8amg0KF+xwwXweXSbaf02G48RLxgTHkCn7EvtLfw7o0AgzzcHNpTc+oNMcjypI1unr/zLmgkHCzFcWgp9JeC6PPuctrHiJY30+1DREMlwWtj07PzeAoQHYEOhnpwxZL4JsHLCcZnAXml65YQiMqmAopTd0gPaIXL56JYfkCRl+N7CGvqnNlaySDtwVvD/Ns90qMo1mO10RztSQ4ZIsGYpjZkNco3/utXe31MzFoKZ8FkcqQgPyvbQ5phpPJis7GRmFgpYMfd8aHF1Ko8fdeD4jXGXwNnMUbkXKjUforRnmqc9Dp9VlNIOmaaffN2s2y7HQmlrQmbjh3/SsIxqvxHcheg1PRXnMXvKh0kxgS+GPlgqVfNdiGo7gzvyJhGDDeedBcSP9TVqRonJsVVmgLt42BGDVZcidHmIXIJpNH7sA4k6Au0WrkVUNEG20mSPPB0paVCSYS3IzGknSVSNsdhhKhqEMc99wGE0WejmYIu88o6ZC8a4jqPPcdT6p2bMixN3VsEmtzE6Ehc+hVgF2rrBLGzsSCgX7hru2N6RgBxnSGphUzA7+whWwva06axaQHA6Z/NcALQ2z1mjHGdj76UrR1H3m5Q9XkWpRBq3/MYHdpLlFRBwtqoUq8yCP/axP9lcisBj7gn7V925hVCuyDA7aL0kOqvOnd1N4h2LrNUbwViiy1bOttMsStxONvUSMGiPfVkGzmaGY4uHeLNPSCIcOzhuxxBR4Id4qMxm9OdDX3r0MdNJfGMWYmTX2GwufUL8PsFgxiSA51/0LTGeMPfLURajjQUYe7nqP2Z6GCqvA56q/GdLNEghAsxMtAmpkZzqlBmKjM2tou7thksXTBajCKSZZ8A6N9xKzs
 6hoFoEdM
 ezOdhWvNpf1MqxBWPbBKC2GBsF0WSqwIIwrSzAxUKmXrteXFN+oYjAojt9tLj0IpJVKSxyqczDE62Sat1W1QMqv5OKqOzA8/9+pJsKUQ9ll/DadJ74Ys5rB5efcFg+ikkc7qZqnxdYHFKlRaLMBQ0jP/MlkQNczNqXh8Ei5ZwdP/m70o9DejZvd0lvIFA4XVVZDRlUf5nr5nNHxJXSqYlqyZ5RmqmpR5MXs8MBc81ojzHF9cC1f0h2Md6EhVvQBDOmNXCXdPLqeHOdWtp47Bl4/BdMMdbMN77MUFAGT+U48TxDTNRSFhTj7NcAOwCtBxpnwTE2TcdxL89k7KpAaKdFjOAIwHHU3VypMWyPz3WCksXcujUsQy6C+5xUW3y/IT4koBCB8w/0Y2NGugeNm+vuPhsBxm2l4C0AWdfOzkzsnzMRbLa4BwwIuJ049YxruwY64Uvk/X4tgr+QzkYL9guq8zx2jdcBmK66hyrrojym3olhu25Io/i+nh2Cm9tEWC47Bc2f74iPMb2cGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On, Thu, 27 Nov 2025 08:20:57 +0100, Sebastian Andrzej Siewior wrote:
> This all should be covered by the series here
> 	https://lore.kernel.org/all/20251110145555.2555055-1-bigeasy@linutronix.de/

Yes, I know it.

> or do I miss something.

We had some discussions about this bug:
Link: https://lore.kernel.org/lkml/20251126090505.3057219-1-wozizhi@huaweicloud.com/

The discussions:
Link: https://lore.kernel.org/CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com
Link: https://lore.kernel.org/20251126192640.GD3538@ZenIV
Link: https://lore.kernel.org/aSeNtFxD1WRjFaiR@shell.armlinux.org.uk

According to the discussion, in do_page_fault(), when addr >= TASK_SIZE,
we should not try to acquire the mm read lock or find vma. Instead, we
should directly call __do_kernel_fault() or __do_user_fault(). Your
submission just moved harden_branch_predictor() forward. I think we can
have more discussions about the patches to fix the missing spectre.

I am trying to write a new patch, I hope it will better handle these two
bugs and be compatible with PREEMPT_RT scenarios.

> Sebastian

Thanks!

Xie Yuanbin

