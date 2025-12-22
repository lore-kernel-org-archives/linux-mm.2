Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64AF5E6ADE7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 21:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4846B0005; Mon, 22 Dec 2025 16:33:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9827F6B0089; Mon, 22 Dec 2025 16:33:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E4E6B008A; Mon, 22 Dec 2025 16:33:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74E786B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:33:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C22613AABB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:33:48 +0000 (UTC)
X-FDA: 84248409336.09.09EF12D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A62B620002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:33:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QOD3u4tq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766439226; a=rsa-sha256;
	cv=none;
	b=2DaetCpw6a5fO8skVOEqrpeYD4U7nnAgw5P96DShNqbRCpM2iNXdl0w4to8iorjIQ0lHLc
	tKYMz1xcv0qZds/I/w8y/tNVzbZuJMRlwGtlh0foqkz7gJgLo18amGrIAiyMbmDXEU946s
	/3mrd5rM+2ko6YwmYvVI3Nprmc0qVE8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QOD3u4tq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766439226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wv92kFj6FT+4Ld1XNIzt8vKNd4sT3izicr5PlWCqcsc=;
	b=BThX6+nT3Yf23UI2Q8yqkApiqqbuCI/LhKVkoEko4Zbq1wZhiAnLP4htjwvZAqnQbIUBdT
	hgG76wh5NOSZgVYRCAOv4YKyreCWSIVUvBFDgaApROElXMQw5zvFJB8MLtPmVn/hIprn3G
	qZc4uDJ83iEjj96shbcPE0S32azvv4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71BBD42B67;
	Mon, 22 Dec 2025 21:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5CCC4CEF1;
	Mon, 22 Dec 2025 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766439225;
	bh=0r26v+vgZ7y2B5fP+hL/CfC1LxsSYQaGQALoSUVLma8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOD3u4tqwmNzqI4c/1BKxggeRudS6Iou54JHJvqcWLOzHaEW/EKf0d/O+cTcfSka6
	 5KWyLlbWWNX4iOAYgUiXISlAcIN+icxrL5G/HmNLKsJ60T6pE/r18FbYJXKdtXBNyH
	 029BBUHq/UN+hpy9eFNAcUreDxYi3lPKm4pyFGzt1Fk719nBbO7haka/GvV5bVz8Aq
	 hY4rVHy2orsflqWD6XU+85M6pHk6WLNpYZpAJgJI0iOBc+CtqCBo1tUIR0vaJLykN0
	 dG8kIJVbsbkpP2IlbtwwdWMYDRrqqrLkV8YsXO2TXQuBZvRHGWVowecd5MEVm2jRsT
	 /3Da4VbMWdYww==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Enze Li <lienze@kylinos.cn>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
Date: Mon, 22 Dec 2025 13:33:40 -0800
Message-ID: <20251222213341.3687-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6wQ5h5j42iTaepRnSkA6mqeY-ExpHA4Qc6K+-xb6T0eQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A62B620002
X-Rspamd-Server: rspam03
X-Stat-Signature: d7i4amycfy9pjnn6rw7kxfzh3hhapgic
X-Rspam-User: 
X-HE-Tag: 1766439226-920213
X-HE-Meta: U2FsdGVkX191hu85bMV1qFkHA52S1aaMEHNopKcBXp37BrwsGbEgpvB6mpkHp6rvE4EvrPznZRnRX+cVd2JCnZ5LIaztvutSGDWo/IpXm+/wMEFQp5ZSag7lP98rPjE5AW5xkm16EhvKiVPnAkZ9hvOJ5aYr/yYHunUj/PEJRpAQ53LdDGqGNV2uECvzeMWMcXoxXqW3Fqi5d9h4iGtAvt1b4uVv/GXu/7WLQBKQ+xmpoBAq2uYmeKnEkC09x6H8epMMAPA5sC9RXBJ1Cc9Pbcsv0xcHOvytvUt+7PXVny+DS49vJN/HJgkvr+BUnSGjGuKzhkMAqP8S3dS+pxtilS9piBiQLS//8IDrLKW7pWY57nMUk29j+gNo0P+kDxL0AVKYP3FX9KYe4f4wzL0A8wNItylU97TixrkemlagUIregp3iCdjppK3nHQFnQEuS7QwX6wqdqCr5fjxF6M1Wyf3bBYHwDJvoxbZ2UNxijjK3CPN3GHK3n1c0hFhMKdqV2ACdDFnhGgEN4XCk0G33RXX89pKARwYFCM+R6BTZzKvm8NLodlDiWZx/5drv9av31IJhXPCYdd/LVpcfDQzllShFrI686fPgDy7MOB8LNcmSzdMagLGQ77GqIVC3xreundONvIPVJ3oqMBdEM+woAuA4z6iYY6NiGBVxHpSHXW70c9jhjo3v8HfgV5BqAnEbc/bRJHirn0QuulgsK6VoX8t5Ln24FIbpCBa/cSsxomrV5kwyps3JaVtA85ccCqNUeOda40iA0uKS14qc0+Rpt2xmMDutC85WFycA4nO6i9VBCL4DhkCJTZ7XNtZpg3uO9FasTPTE7kF78cLnHOqkSwXlAx279C+UXPArnkQx8yO4CXZEZrRJbVBghMRp+EDpGw3NMWtcNE+DToPFPtgGrLcTVUVBdembIM04GNNXwa97qWJa9wEPLBYiwIbMrAMUcCtQRW8Q6hBF3A/ReJ3
 Dl2GAyvb
 Y9YF0u0TtHB23/bDTRFn3C7CO3SrNvS0ZDBG8SVyxOez2gR1TkBlJK4j7iJ9ZtetCoZ47r4dd2zZV31JnlYxkpQ/0Jj/6rbslGUX4hFBXuQHQOZem22n5G8g6iYqLZQ/2KMV+wj6s1NDjxzJt8cRtFdQxXK48rXEaGI4NWX/etXbu1KILK1Oz8zGL9v82HHFFYea1icsino8zP13UKToFxdcWTsZuHcIwSxyB5u71h00B7m3GxWlMbnFcPgO69Lc1vbCw8aa0vsxcVc8TeND4QTXsAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 05:57:55 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Mon, 22 Dec 2025 at 04:27, SeongJae Park <sj@kernel.org> wrote:
> > On Sun, 21 Dec 2025 20:04:23 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
[...]
> > > So far in my view, I have analyzed DAMON as follows:
> > >
> > > DAMON core  <---------> kernel module   <------> damo(user-space)
> > > mm/damon/core.c         mm/damon/lru_sort.c
> > > mm/damon/vaddr.c        mm/damon/reclaim.c
> > > mm/damon/paddr.c        samples/damon/*.c
> > > mm/damon/sysfs.c
> > >
> > > Above, lru_sort and reclaim are DAMON core characteristics, but they have
> > > a kernel module structure because they are executed with module_init().
> > > I personally think this is inappropriate.
> >
> > Could you please further clarify why you think it is inappropriate?
> >
> > > Additionally, currently, DAMON is
> > > executed only once at a time according to the exclusive=true condition
> > > when damon_start() is called.  In this structure, I believe that the meaning
> > > of "kernel loadable module"  is non-existent.
> >
> > I have to say I still don't get your points.  More elaboration would be nice.
> 
> To summarize the Damon I have analyzed so far,
> 
> DAMON core  <---------------> DAMON kernel module
> | mm/damon/core.c               + mm/damon/lru_sort.c (schemes setting)
> | mm/damon/vaddr.c              + mm/damon/reclaim.c (quota, filter)
> | mm/damon/paddr.c              + samples/damon/*.c (using samples)
> | mm/damon/sysfs.c
>             |
>         /sys/kernel/mm/damon/admin
>             |
>             +--------------------------> open/read(get)/write(set)/close
>                                                (user-space system call)

Nice analysis.  Please consider further referring to the 'overall
architectures' section of the design doc [1].

> 
> The DAMON kernel module above is a sample that sets some parameters of
> DAMON.  I think it's better to use damon/sysfs since all of this can be
> done in damon/sysfs.

I agree using DAMON sysfs only can be better for some use cases.  But nothing
fits all.  Hence we intentionally provide both general purpose user interface
module (DAMON sysfs interface) and special-purpose modules.  Please refer to
the 'modules' section of the design doc [1] for more details.

> I am continuing to analyze this.  If any
> improvements are found, I'll send you a patch.

Looking forward!

[1] https://origin.kernel.org/doc/html/latest/mm/damon/design.html


Thanks,
SJ

[...]

