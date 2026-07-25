Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0971EC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 02:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35AF26B007B; Fri, 24 Jul 2026 22:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30BA06B0088; Fri, 24 Jul 2026 22:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221E66B008A; Fri, 24 Jul 2026 22:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E15986B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:10:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4820F40157
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:10:08 +0000 (UTC)
X-FDA: 85025668896.27.948C695
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE16D140008
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:10:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MHZhLRJd;
	spf=pass (imf09.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784945406;
	b=NhO9ojmsziFY03Habu1uIvtTxRBREyWxHrKbnt8iXRwYLgzOkTp5tv3/zE7d3+ZNAKsKqP
	6XsbzNz05HUQ8P2/tcwGiRKkSwsorMVgCxynJ2iUv1k15pyu2H2jE51NQPpzq9LDyYU+Xa
	aRqTWIOcgOZ42SrhIFaNeYmCQ3lM+iU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MHZhLRJd;
	spf=pass (imf09.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784945406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAzdFsTkdaqNbxbLnBrQPK/wQUH/o5uxbbXwAcfxmDk=;
	b=y0dltOfO9fFVCm9uimtRhZQhYFR4FmRjpOs0ZTiBCcZHxxC5MVhrs7DinCzUrXrGt5sZV7
	gFtjUQzlV9xz/s/RbgQDzlhEPup9ZSYYYXhXZCIMLFk54yPOxH4pgnNdjTp3BuLDz5I5mU
	3pApXmPjdHF2JmsQ4bdGoizGB74y87Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QAzdFsTkdaqNbxbLnBrQPK/wQUH/o5uxbbXwAcfxmDk=;
	b=MHZhLRJdtvktXcz0io+Xng0s5ApaY9vVeAcRTB9e7OcucaL4fI0lcbLExGL7hX1c6aBEkxEBa
	WLl6I4NWyCtE/kMqKREw9e84xX42uTxAvLGSfWVi1lQvJ34L9deYtyeKVnAFknjFZbU1CqpenrO
	LWBO+LecsXWXApQlFsT7XOQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h6SkC1lKczmVWf;
	Sat, 25 Jul 2026 10:00:35 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id BA5AC40586;
	Sat, 25 Jul 2026 10:09:59 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 25 Jul 2026 10:09:58 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linusw@kernel.org>, <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <ljs@kernel.org>, <mhocko@suse.com>, <rppt@kernel.org>,
	<sunnanyong@huawei.com>, <surenb@google.com>, <vbabka@kernel.org>,
	<will@kernel.org>, <xieyuanbin1@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH v4] ARM: mm: acquire mmap write lock around show_pte() for user faults
Date: Sat, 25 Jul 2026 10:09:26 +0800
Message-ID: <20260725020926.11440-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAD++jLn_DDvWAudHC2Qtz9kaaonuC0YGTXn9nvPtZfGLbtUsOA@mail.gmail.com>
References: <CAD++jLn_DDvWAudHC2Qtz9kaaonuC0YGTXn9nvPtZfGLbtUsOA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE16D140008
X-Stat-Signature: z856sq8sjqpqegf1p99m1gwkscndu4pg
X-Rspam-User: 
X-HE-Tag: 1784945405-459049
X-HE-Meta: U2FsdGVkX18WLb4BtHxpBxylvSotq/xhruep59hDDjIL8bmEO7wO0ywNKq8+SJJDr4aKQDLSawYi1AxvjtAOP/Y5bqPba72g3nGLyOxGzEozrEBCW7kFPMSx+GLlrrJJbrePsAl1sjGjJmb1QwuKOklms5meBnpRdXgXCDPEW/8B5z8R6R6cacx1UbWzKzjL5OQqb7OrvpEI9YKCaNUxG0OXHX0h07xeWu6S/ZAkIyE2OM1ckgsX1QOHEM91m77p8ltwxDtmEizIotfYJGT3mUCV1sG47/AyEqYRwD9xCu/+Andwn8NWFMKMAMdELkz+3oP9m97qVKKYjDqExyOl6I0Ae7naaSAggeia3Jhc5c9t3rDzKUAM2Jp9exEAQv4LSTzdJM6A+NDoXtZwvpqm5f9Dd27SEShyIZtwpBOVSvp4JGZt142ocjdrZd1i9oCYgvRZ1O9C7/MKZtHBttyYNN1lfNwFVrkLdWLrcCo2gRNH/scLRIRTw9BhBLu+9hJG+GtsDfbnx7T/Xh7NxBalQacMQ0unW9Agd6zZlGNNMT4VuyDiR2iOW/SAPlEbfkGxbd+84fO03+mxINJBCOkYhWRjEYDJoVh1Ee54yYLofZA7ugXDva7UtQLh6lfhLOxzqDZMXdZNTjK88Igw89uyHh/FR1pQlt57U1/euBcHVhvBuOeFZRJey1WGqjgYkoKvoedjapx40jgqUDGiCoJ0WBzjBo9xzcj0BWFOmkvUh+655PwomAfUKVUue7td8E5I1fPgze4+LkWUhYBhyR1VLWzQUqGy2vprG0Z4zGaPH1YjsnUjED6QPrOT+4h3WMDnS493w7D7yJvZmpG4pegH78kaQ1oqF1O16uXpjwAwPpD8I30X1bbbLGiweuA0uto3fp3dUjNmMYHBjQuzO1GChiUkYwg66AoCUQUG0jUGk9MFb0WIyQThjBwz5yiKwlYkcvqvyJUOxVfW1Bd/COw
 ZKWrPyQ+
 eYKGKHnhhbeG57VcRTK56DSJWJ/atMJlcKAY8lY4O0vHvHsEL1Xu2/cjkH9AaesRtvmB7vbMo49+KzrSaEJ9yhXPq3m/Oy8823Ulx8SA7TOTJef7BP5liRfgwt8YnA5dCiA7RvIk5D7z5ugKzNGf4s5qxdTSikBLDKdUtrZVSqBjNEAquWIbsrZdq/8a2254WLDQvL0nwwP4WRkRZx8mm9buFAYY+15JcwaoISJ84sVnBfwatekvrucpQNjgzsTRxlcIGXez5KmJmmYkBo9jvSb3l2rMTQlvqBs+ZdPCgoiJFfj11FQhL7FHpSURPluUVBSfiLohM93tdSKVpOgoofnEqqfn3UF5+a6F2fGdKtbOKaipVuetRyKvIa1F6E7g7/mrNjGLj1fzqhUIJ4qc2rR+cs5EUbiMcq/nB8w7MSXuLubSSAAxQoGJnVcQ9au156HqB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Jul 2026 00:05:58 +0200, Linus Walleij wrote:
> On Thu, 16 Jul 2026 09:40:22 +0800, Xie Yuanbin <xieyuanbin1@huawei.com> wrote:
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Fixes: 6d021b724481 ("ARM: dump pgd, pmd and pte states on unhandled data abort faults")
>> Depends-on: <20260629123349.134224-1-xieyuanbin1@huawei.com>
>> Depends-on: 59e4f3b45b96 ("ARM: ensure interrupts are enabled in __do_user_fault()")
>
> This looks a bit odd. I don't get the first fix tag, drop it.

The first fix tag can be open as:
Link: https://github.com/torvalds/linux/commit/1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
It seems that a 12-character hash is no longer sufficient to index it. :)

May I increase the number of hash characters or just drop it?

> I think drop both Depends-on as well.

These tags are for the maintainers of the stable/LTS branches. Since
the bug is very old (we discovered it in linux-5.10), they are likely to
be backported to the LTS versions. However, the depends-on commits may
not be merged to the LTS versions.

If the depends-on commits are not merged, this patch may trigger a
might_sleep() warning when calling mmap_write_lock().

Do I still need to drop them?

> Put it in Russell's patch tracker after dropping the weird
> tags.

Just to confirm, I will be the one to submit this patch to this website:
Link: https://www.armlinux.org.uk/developer/patches
right?

Thanks very much!

