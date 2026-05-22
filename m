Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC78CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C286B0093; Fri, 22 May 2026 17:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E40C6B0095; Fri, 22 May 2026 17:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020C76B0096; Fri, 22 May 2026 17:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7A9B6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:31:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D816120832
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:31:20 +0000 (UTC)
X-FDA: 84796351920.11.227AF57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABB631C000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:31:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBZyjw7v;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779485478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1JkI15vgeu08xV//dtK9AYlWM5a5o5EUbaFA14ty+I=;
	b=I8VqoEMqwhnFCEQszRVA4GruAeqCtyXKw7jAa+Szd8uaP9/cTZ9piVVeJfEUe4um6BpqYd
	mde0y4Y0aLB0LiZXRTHzAMIR7EHjn/KazGtJXraocruHysejHkDgxEQVToxpWr7KFrU41Z
	+QAoZpMtc2F2YPvm3VE8Wr902x0ZHr4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBZyjw7v;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779485478; a=rsa-sha256;
	cv=none;
	b=z2r5DfPc4q4KD010WNRcHNST/ajm4dVbEQWln3j1MSlGvkqRpvjI0DhsOwk/a72bM5EW9c
	gKBQtQndORSuj9N1SdabI+sbBaalpHI9c/ga9h4eC2fTCit7LYfb+WMy2/+WAsbyJvkNQh
	dLNdajMGuxmGyuhWfJW7g916OMqG6JI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 351AA60103
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB661F00A3F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779485477;
	bh=C1JkI15vgeu08xV//dtK9AYlWM5a5o5EUbaFA14ty+I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JBZyjw7v4TNs8wWX/9uH9UPBORLbnP1gNykROVCnzzWe62LQQGsuyUduxL0WjCfDh
	 awMAeL5mdNc+eQzJ7BqmHxE3C9bM6xoXDYi9/lvJBN+nkCjPiSJx/Vqw/ic89PUGHa
	 +oCJ1oAWvGkcR7AzCfLfmZzjjdqRgrdDvE6SFuMHWIglBp4SxVU+16fJi5Gy5cg2CB
	 E2gUsfGHL1LObTCegYK7jYTi/FXgvbuCtfF9DI05/1rUMNFO31tcnR/GD6GcQfYJn4
	 wAZJFiQOY6SoK2CMUiaOTZ6KlVvfLBxnWemo+yhAQr66O/AVS8Kq5HeBx50PdR7rYd
	 GzMKwfZ/XlIOg==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50e5c5033f6so65673431cf.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 14:31:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/EZ/1d6PYoJQnfzDEMf+BZhYuCOMOPXmz2k+xrq1TN4kTqRMFZHnJeULokOGRRH1oQ2XRmuYPBGg==@kvack.org
X-Gm-Message-State: AOJu0YzNLOApbjI2Znysqt/INgHLzOYFznWTguxxgFY4i6/mgu1tdfqp
	6Uq6a1W6SFcRhMgQo3kS9EopDBSDCNs+JItp8T7WpggxkWgJ/jQCbWCQPMpPvovsuGvcmh5eyTr
	go29VRnPUQPSMBnGzC/nUQECx8tNxFnk=
X-Received: by 2002:a05:620a:372a:b0:914:c100:6a0f with SMTP id
 af79cd13be357-914c10072a4mr332092285a.23.1779485477280; Fri, 22 May 2026
 14:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
 <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
 <ag4h87CBd-gph9zX@casper.infradead.org> <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
 <ag4kj84EcKqamdB-@casper.infradead.org> <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
 <CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com> <ahB6QyHgYq8ksj65@lucifer>
In-Reply-To: <ahB6QyHgYq8ksj65@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Sat, 23 May 2026 05:31:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zxLvZ01i19vdo0xA47T1hxa1VRYvxLmiDhy5q1GDKPRg@mail.gmail.com>
X-Gm-Features: AVHnY4IqrepDwpGO5qDQsSaxTVFULk1Thk0Uu8QgQ0mfUUrDDRbDPxaWPMcP1VU
Message-ID: <CAGsJ_4zxLvZ01i19vdo0xA47T1hxa1VRYvxLmiDhy5q1GDKPRg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7d694p9upwc143k3518ymdaoeshbagwk
X-Rspamd-Queue-Id: ABB631C000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779485478-639498
X-HE-Meta: U2FsdGVkX18dr7pjyz3CFlgNiPSjn3/rqSvST5zasnt7jTLKgkkDcC10C61Rgb9Bvh653GykYJ8W/Col/arg2e0p/ywvTdDUZx2JTJDX/7Lu44RJOjkbH1MhQ5hEoNHBW/REzZyASUDF31HBuX2j87SLO8ig0zRiX4caaFU7BRqXC5mkwpRG+nwzgQW4kzrI6N5ulTz/IQ6O74J+lWKnFJx80vyQuPthw/sfOJ8TNAnkKaoF0FCgKsdBi9qsYwsVl4XJCYXXcnhKbttLa7MqRorj7RxznuyJa5ZbulLNKbhBGHkVWCl8/OfKe5IX8lhzQ9llofU6aLLAB0dY5ktw2ctKBlzsDh/qs7bfpk3/kdBIsorRw3k5o554z3wo64JWH5D9v76FxrF21N+5UDVE2Ck8FhGjAkiaRzLgrbx+t2ErnN2Nv6hF1wU0QuSSdkUUZIIYIfRxSrGZNOVqJLHdMhEj9LJruesqqtmmk0BvKqlMQCYt/aP0pyrMMS1b8R/RtNyfuUHJslmoIlwJxp1I9Z/Ptf7HWNI80hMcAZe5oUU6NiVx2ubBfDjvMR4vXgpLrwOwk/ZsezmX8VFqk29pUevUhKCUueiqsgpik9TyN9EHzDs16t1iZplarcO+UxzNjrzhj/qrz66M01f8HFsF5b8Bbj91TwbKcMXBmTbgIAUFlMrHFxICOYX9J+Ul1o4O2cDiNK9wJWMDmKm6vowYyScc8lRazFf5DtFuw/DgX2QYg9Hzq8de5MNeon0ePJkKftJoLLNigr44ELMaXJEBOHThpOkKJutOW9E0MdgR4X2C+HBDi03af7VlbVJROFs/IALh7xPiDkz+kQR03N94CWRG4EnTLAaSrQe5NhQOcPA1lmSnlS7KgwOceGhvfuxVqSlCAAV/kox+BEXcGp583fmp0Auwk44gfF0uws/URGWp/KR7N76so2Ldi5gl+41M8iXpk80P4wbqp1KRQuA
 THyU+A9c
 rV7ZgYsf9KxJ9ze9ei6DFGwPkWX+AkPlEIMgeiqkTccdYvwRPlQOwpMJAHU4V/7E9hh+hbkRqiI8Fd37YfsIhL2VyZufV+2zFzUU113zFicxRYwFw+Qnkmoc+H07pUzngQAtLAUmLRfsZrGO64FVqV/7zvm8krV6eL/L+YVqzijLHSOKDRQfDWxP0o+HP1MkPU5bPdzDpr4lGl6+uS6LAVJdIZ7u74gjftFv3Btp5Jz5oRQ7Ygmx1hUiDJVEbxzQIEea2AtgWZm2EA5J0dZnD8vL4TLVpUTINtEcOeb/xbAeSYNjUsgYqAfTjnAvhIIzsmk4MT6ZG8TjjPutGJc2FQV7raujU5jMkDf1PuU0w3/lz5HIT3ryjbj1rflaUxg/1Wx7At60Bz0Wsr5fxQIPG4EQrNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Again this is making me want to sit outside and sip on some lemonade and
> ice :)
>
> Yes - android processes are aggressively multi-threaded, sure of course.
>
> The missing bit here is the forking - what, where, why, when?
>

I really want to know the what, where, why, and when
as well. But since most applications are not
open-source, it is basically a black hole for anyone
other than the owners of those apps.

Let me try to do more investigation to understand what
is going on, although it is really hard.
To be honest, I would rather the Android framework
completely prohibit apps from calling fork(), if
possible.

> And then you say zygote is sometimes multi-threaded but sometimes
> single-threaded, which is adding a whole bunch of confusion on top of all
> that.
>
> I don't find these stack trace dumps all that useful (though thanks of
> course for taking the time to gather them), I think we'd be better off with
> specific data on forking, in some _concise_ _summarised_ form, ideally with
> numbers.
>
> There's such a thing as too much information :))

This trace shows PF I/O in one thread overlapping
with a fork() call in another thread.
But as I explained, I really do not know what kind of
user behavior is behind it.

>
> Anyway, again, please let's see a new _RFC_ with the approach proposed by
> Suren, with some _succinct_ data demonstrating _exactly_ what the problem
> is, so we can make some headway here.

Okay, sure. Thanks for your patience.

>
> And now I'm off for a cornetto! :)

Sounds good :) Enjoy your cornetto!

Best Regards
Barry

