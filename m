Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F394CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93E48E0142; Tue,  4 Nov 2025 08:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44968E0124; Tue,  4 Nov 2025 08:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A508E0142; Tue,  4 Nov 2025 08:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A504D8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:48:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63A9D12BF32
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:48:47 +0000 (UTC)
X-FDA: 84073055094.10.36D5F4A
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43D26180017
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:48:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=485pWYjv;
	spf=pass (imf06.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762264125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/OARezs29eUq90xKny6FQe3l9UwiuCpXkYqxg2+/iY=;
	b=QWScHy9bm1ARNztQlKqv0eyZswf+PoRY7eZO/p6SUoKVNrOUMEwyxcHS61fhTpPhEiEUDy
	dnr1nVz2q3QROVxzt4vNbKp0c9qvkMCgaCMy+a7CoPGwki6RdzKi7NtDZSTWTk9j1OZ85Z
	EEWBxnMfoPIrVcjENvSzKei/Er/EDsU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=485pWYjv;
	spf=pass (imf06.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762264125; a=rsa-sha256;
	cv=none;
	b=BXtnpSDksK1jqg1DDk9s1vjc/1C+xASv6LIWBBT9TgWDIMdikre9Q9QFbmo532Udx+8VFs
	SOQHElbNRRsHnvxoegVMHe8sGdTALVBpQJcfhrGXkyPPSKMWlSByPo1K3vy4r06zon/dOO
	299DjDJeQdoHdW43HHlzGw2fezOGFFA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3/OARezs29eUq90xKny6FQe3l9UwiuCpXkYqxg2+/iY=;
	b=485pWYjvuZXFV9mKiWgarmKxkGqcVR6VQWU2toTQMryKr2Ccu9GXeoCSUTGB9tmbqKoCpniXy
	I+RSyrWRIamnsSyRhH5kbEOoRupCQmkdnbybmsLNDjkuvrFDBpROPDmUvLZ+CmZ8iM4HeydHHQC
	MM1lAeLT19FUO479+LA7qEA=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4d18rj1mzYz1prL4;
	Tue,  4 Nov 2025 21:47:01 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B967180B69;
	Tue,  4 Nov 2025 21:48:36 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 21:48:35 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <ardb@kernel.org>,
	<arnd@arndb.de>, <dave@vasilevsky.ca>, <david@redhat.com>,
	<ebiggers@kernel.org>, <kees@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linmiaohe@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux@armlinux.org.uk>, <lorenzo.stoakes@oracle.com>,
	<mhocko@suse.com>, <nao.horiguchi@gmail.com>, <nathan@kernel.org>,
	<peterz@infradead.org>, <rmk+kernel@armlinux.org.uk>, <rostedt@goodmis.org>,
	<rppt@kernel.org>, <surenb@google.com>, <vbabka@suse.cz>, <will@kernel.org>,
	<xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
Date: Tue, 4 Nov 2025 21:48:31 +0800
Message-ID: <20251104134831.147584-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <e323f1f3-f543-4e81-af6b-243fcf9ba750@kernel.org>
References: <e323f1f3-f543-4e81-af6b-243fcf9ba750@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43D26180017
X-Stat-Signature: yz4g595qerom5pnyn8fmpjb4gg16chni
X-Rspam-User: 
X-HE-Tag: 1762264122-475408
X-HE-Meta: U2FsdGVkX1+RLwBMAiwWhcG7tO9Cg2hAks6W9kdIU5vxb/jpHaoBA6TAlBErfwurL6oCfi5d2qgv+JLMhTwtENdD9Z+SShfkslATxIp6jX/CtBgXV50TWMZ0Xd4SCk+KE6YCarjVvrj0MJHaoyUQI0jPOnHnT2CTlLb9GhNCdqSqCrwliZV3wEBqWM/p9epoDGx37uBp/3DKE5Ew24tFXd8YR1rYOZVqsIXjG0++WvCxV14rQcbY8VyJ/vAwXTJbSEofpUc04BA2XiPnm+Mzn8ecUsXcCKYXtecPFDQPJjDpqROkdXT4mEL1yLKzdcmPr7pFa5t5Sm9GlZ4IfRUm9UJgPRiN3MwEvoFaoJynMJpxJMWr/JwxsB5d+q2e/5EKH3ZwuRj4mkpRadcS/JJWrXbxCPbuBhIab5WnU9KrHSv9hRbz7q/+3Vc4E/rcHCF8/ZM/0s3+TbSQ4R+RzuQGH6IVNOqreU7X6ClR2V885JvI2keRqReRcjlqYsHO5Kc6e9r/xN6Mv0S43AnNTG5+J/zpXkqKyyALDus5Wn9y0c1ilWyOtDf2kQDtzT44x1xGaB9lnsafY5icyR7gxIbgOD5qwOufrhTIr5C0DrUVUnlOEW2zJrWQW4WJkfS6w02TvStACg8YZ0CwuAPt6ubne9OI9KHDizVPcobFEPVd0gt6mikHEUcq7b/2gowP/MP/gvHDR3sHmNpdTsDEZmCTI2hyqXcHW4e3yqzlaidZuDvYkO0S0p/rxGQfvB/Myek66yUPdf2gHT4f615GtogkR4ghwvs8CffS4mBgRreN6znoLDC47dkC/UcJm/ehQ/uy286XtvBaKMjfwDe4rpPBw/gVvbGDwiNnt2pIDo+h0FdKSthfaxAMoxhwCHQcVRs5paOVUPKAVR32i5omfBIX+3/vXd+0U5iqRePsTVs9jQh4RpURQpsNq8UINYLCwWtxcjWiRO5k2bfspL+UNAx
 1LvoKgzF
 u3HHNJx21aaVQT0Gv5ccoNwBKyJAJGtg6UJJWW6ga+7o2mGkHaE2T46AqCJ+slHr8hna3kzfe0Do7d0LE09t78R88xAVQIwJbzHlU7eUcXxDvuQ0IlyZTuF5U6VVWNh25/NwkiIl6VJ2Jf2KZUFBi5WGRWKek68yKCJK4zRTdOieMIUERuPeFcxVqRl8BaGHJ1ckNuzXmCeQzl7368D7qNlETPf9kDWEfN7iwMzrb5aUaloe6jDmpwBfL7ZCyvWmSvMGvmrpddwgVvFwB6RmISu7/nRkPkYbpu1ao62rDnNRsD96ufqWQxndT6x7tXgsZPtx2l7dEL8THEG7ju8DpLXg82bGxQ9qXhl5n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Nov 2025 17:53:18 +0100, David Hildenbrand wrote:
> Can you go into more details which exact functionality in
> memory-failure.c you would be interested in using?
>
> Only soft-offlining or also the other (possibly architecture-specific)
> handling?

Thanks! Let me describe it in as much detail as possible.

The functions in memory-failure.c are currently used in three ways:
1. When the application is using memory, and ECC detects a UE
(Uncorrectable Errors) bit flip from DRAM (the detection is performed by
hardware and is not perceived by software), it reports an interrupt to the
CPU. The relevant driver (a third-party module) has already
registered the interrupt callback function.
Based on the configuration, the driver calls `memory_failure_queue()`
inside callback function, or wakes up the related kthread to call
`soft_offline_page()`/`memory_failure()` to take the affected memory
offline or kill the process.

2. Hardware memory scanning function: The hardware periodically performs
read/write tests on some memory (This hardware is not a standard hardware,
so it is not included in the ARM spec. The scanning is not perceived by
software) If bit flip is detected during the test, an interrupt is
reported to the operating system to do the memory-failure,
just like what described earlier.

3. Software memory scanning function: The software (such as kthread/
work-queue) periodically use `soft_offline_page()` to isolate some free
memory and performs read/write tests. If bit flip is detected during the
test, it is considered a failure, and the memory will not be recovered.
Otherwise, use `unpoison_memory()` to recover the memory.

Unfortunately, the driver code for these three methods is difficult to
open-source. I have also been thinking about whether there is a
general-purpose function that could use memory-failure, but I haven't
come up with a good idea yet.

> Cheers
>
> David

Thanks!

Xie Yuanbin

