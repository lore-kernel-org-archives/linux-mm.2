Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3270CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5A5F6B0005; Sat, 20 Jun 2026 14:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0BAA6B008A; Sat, 20 Jun 2026 14:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21646B00A1; Sat, 20 Jun 2026 14:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD69C6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:19:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 229EC4021C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:19:35 +0000 (UTC)
X-FDA: 84901103910.23.1923AD7
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1844416000B
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:19:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qg5TC9lP;
	spf=pass (imf08.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DnwXLv+Azv/S4ZnnUQ/iGBMtsIq6jPezKtzzdS8ZdTU=;
	b=aWsWrJeh8lkQKahDagpEic1jXCrk5IMlGAZLlA4JvbNl+RdNQJMNDJkzdp0UNSAt08GpWE
	I8bzVomghAIaYT0Fl/nvaqO/cCkFiLjSx8t/C5QnRXYPXEjfJ9P/MxTb5cDR2eoXtmubhW
	cTg2jJs+2P3W12aWAjsdBtzgxy5wQeg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979573;
	b=aTgTUzFO2Tcyd13zuaKye6fvPfdkdeJvKrvOv9/rasH9AEXvBPmooPWfVKiDx63yVcYUVV
	tsEvqJ47dWzzwbPHNDssVUDmOwdHkGODIAQ6ygTBiRZEpsM/USM0L6ZT+Jg4lvXvBwrhIi
	CVTiiTQKY1nrMCVcIW8hHo1CXki23iI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qg5TC9lP;
	spf=pass (imf08.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781979570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnwXLv+Azv/S4ZnnUQ/iGBMtsIq6jPezKtzzdS8ZdTU=;
	b=qg5TC9lPET+ZPm+CqSrRWXvxLxYfqvorf7kKl5EmuS7w+oZtjA/TvyGRB7tWRX/enDcja4
	M35DQ8sQUAJGyY09EvvwcnNsA/vHPNVTYWI02Pg3hIlkQQX1dkFPepLl6A4BLHsCHKt56J
	fro1AoDGwrayAXwGSN2fsJFive34UEo=
Date: Sat, 20 Jun 2026 18:19:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ilya.gladyshev@linux.dev
Message-ID: <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, david@kernel.org,
 foxido@foxido.dev, harry.yoo@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
In-Reply-To: <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1844416000B
X-Stat-Signature: fe11zsen6zi5oemhtezj4a1okpysmopw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781979572-182036
X-HE-Meta: U2FsdGVkX18RJN9spwY6LyfjnrNkeVOhrbUWg4E1zZzebCd29qpXvBsmjIHkQhNXq+rqgDM35tZ3ESWHeEt5SdM22Hcu0FMxIiPv3F3j757JnJ0TC5Zcd4uom1wyG6JgX5Uwzf1fCqy8QBcUoxfA8A1ZULtQLj6UoVReyAvAJuK4MtCZyOQPUjUa7MA76d9HCxWnNtYF/gK20IUDUgb4EbBbt1VglcElyou2KANltnv5YjNPylwGiMZ1y5rGXG23wi4R5x5vwHEJzZkc7XqLWGeGczWoceicJjmLjoREkWDgGjVsImf9ho+R/8Q1uDpUApUWOe4G3Fpzi41R9uWX3FPBKAEftLMJCxYU+9n8+thWjkaq1ZuAN40LdNe4OwC+F9GMN/nKt7olzkQcJeYPhqeSTTLzGnwz+DUsCo0ShNBnTLnpRy9lSAkqcrd0EXPe52E6Ob1sPm8vLRBnFm2Z2zxPhzMRwjGUwNO7aQ1X6V+BRvED9yIEu29H/y7Yz1c2e4Ke2WUZuJuZZXyCOLhGdOT31Jmf7n4k2anuyr31c+eLKP5R97nUC8e8OQ0P4rguCYuf3OJVa3loIhmQZodtyRzuRGoEZpIc8Y/+g0U/ZSTl4cY20Y2tABNQcxdED3JN2X2ZhnPmKz4fB49/LKDGMNXiDkYDXqxK5fUgwp4Gyn2C3g47VLvb4NpJmL+1wqNzYi9iye8ts0sTqeCEWHS5YxjW/KgCBsbPYG6uUFXiouwk0VTkrgt7gUuGHV22mmthkehSv557qrJ2x9p0mlMfbfYXdOQLcze2nolOdO/AwzJo4bRIoKO+xlt7QNGPYBCeWDcNvEAqdDqawV64rfN4Zrt82aUtKwgOeWPfXENS3PTizFdCUAaXKWGQLC0LhYgtqYQPqPu6dkCg2SSfWPhq4EUxqC/LN8qL3LeOtyW+Hwzjf3ZZ2vtFHpFsXn1euTCl7xcHMQix+BYQGqsUXYN
 d+kc4LVR
 pH6vfmavjBx+gjERj0x1hAs6agpLUhcRHpDBN7WLoVM2jO9AmT+C/yYXczqgMlR11t4iUNsYsBJVQNjawBQB7iuvtIXbJv/XwzTtoOdZexds/AjLc4G+FiVf4AYqJJFyS8dj1J1XdRxG4CTuSnwJYPiSD31Y+xWieyZpczWKjlnZLps2Uce35qm5wheo4Cj6WVpJqGWUHCkJYbZ3RLatgeXOsDea/5oPVfROBZGVCDDO4rQKRU+qBcoc57UV7tIdLVFMSIFPQoW9t3cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> >
> > This patch optimizes small file read performance and overall folio re=
fcount
> >  scalability by refactoring page_ref_add_unless [core of folio_try_ge=
t].
> >  This is alternative approach to previous attempts to fix small read
> >  performance by avoiding refcount bumps [1][2].
> >
> Thanks. Nice numbers.
>
> AI review had some things to say:
>  https://sashiko.dev/#/patchset/df26082871b4c65b2bd38d409026237c0857283=
6@linux.dev

Among some minor issues, it also pointed out a funny ABA race:

```
T1/T2 work with pages of type X.
T3 works with pages of type Y.

T1: page_dec_and_test()
T1: -> sub refcount [1 -> 0]
T1: -> *interrupted* (very bad hypervisor, for example)

T2: optimistic get() [0 -> 1]
T2: put page back [1 -> 0]
T2: calls dtor for type X, returns into the allocator

T3: receives page of type Y, sets refcount to 1
T3: page_dec_and_test()
T3: -> sub refcount [1 -> 0]

*T1 resumes execution*

T1: -> CAS [0->LOCKED]
T1: BUG: calls dtor of type X on page of type Y
```

While this race seems unrealistic to me because of the full allocator
cycle between the two atomic operations, I wasn't able to prove it at
the first attempt. Maybe there is some synchronization in allocator
that forbids at least X !=3D Y, or something.

I'll try to research fixes/proofs a little bit more, but I am afraid
that unless someone wise with mm/ knowledge comes up with some fact that
I missed, this patch indeed has a major (but unrealistic) flaw.

--
Sorry for the delay, grass was more touchable than ever
Ilya Gladyshev

