Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA7ACCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5DD8E015F; Fri, 31 Oct 2025 07:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD438E0042; Fri, 31 Oct 2025 07:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2678E015F; Fri, 31 Oct 2025 07:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CABC78E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:57:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4221413B151
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:57:42 +0000 (UTC)
X-FDA: 84058259964.09.48FB1B5
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A275C0004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:57:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nsfJHOJG;
	spf=pass (imf28.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761911860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY7Z2MmzbkxuT2iz0v8W7dJrKa/ZUWsqjm3RZImAMKI=;
	b=oSR4rAyM2LFxB6D4YBfxvRGoLfPA6Q8qfiZJuSpO1Rj+lKsso11RBcLLpSyemfEsXD60bD
	qmW24u9l9Z1XBFW4ZDXYS3HQFAjxM3IKDSpzkSS0nm+G12hxwd7B4MtQmJ2/PMokE2dP9J
	5wRvvR6mn0X034Zlm2AhmZVxOhpyTGU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nsfJHOJG;
	spf=pass (imf28.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761911860; a=rsa-sha256;
	cv=none;
	b=d5JlzJjug2lXP+Zv2ecZttGeDGrzY6sUM3Vj8S6zMtbqfZjrscIBm6DAR0H0hZN79bKGd7
	T1pqIZIMyGOOAdbEAkkwFVS/3yZqLIChEqSEIKHM6gMJo03So5y6JuhOGgi2NngbpJb1Y/
	+oh1y8wgkhcSkVVolt8o3R4MUnw7FQw=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88025eb208bso14089346d6.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761911859; x=1762516659; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dY7Z2MmzbkxuT2iz0v8W7dJrKa/ZUWsqjm3RZImAMKI=;
        b=nsfJHOJGyC7uI2gElgAFDwdxj2ovxS2Q13qqihupUqlduxpaSgcG16i6X3o6VvAxi8
         T/Gi7gUYHnb0Y2UdjPFB/QnPtwfq/hDn6wUZshCnujGRHNg2umMGWELD8DSNHGPhRJuE
         K0n0cXXmr6VvhRpFvw2j+FU4H2UPH/m2ywMODr2Nl2feJ55Ompkg/tWEpiuo6jPUL7db
         5HtuBxkjYTHFvuqHuEehcs34UznMiNkUpve/BBwaK4xz0hDPocjZ25Q28nnl3fa7k+EL
         18XxvhSWVvlSneddx/dt6fudKp6VF7bBYDdwHUwU8Qe71QhblVT0uoGz40+3bSEb8ZNL
         9yPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761911859; x=1762516659;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dY7Z2MmzbkxuT2iz0v8W7dJrKa/ZUWsqjm3RZImAMKI=;
        b=FGyPsWa2qeliUgk7fUof8in5LtmHKtAD20ObyAL69GKc/KPmFGM2618mkPDMuXWgQa
         QiljnC0Lcb3ksFddfpeHV8mySqnWEQf+b2uPKe70gmTD3mifpsHfm8UiVHpLdtBa0l0b
         sPmmwgps9n6W5sFkyuEwfX/5xtq8pif+XAlJ8kKs5IVb3B4dvTRYDAkjwgEZpCj0qSz3
         gy3NgUTn/QqvvHdc1zlslsFoEy9PgIDQXS3xlq+We0hRXEfLUFek3LxPefUfDRoEVwVc
         Dd5Is+0Fm2khyuzir6ELEZi/XpAmi3pQBlFA5l6O2kHrBzB7DIgyK4lX8H68y9j/0Xdj
         NMyA==
X-Forwarded-Encrypted: i=1; AJvYcCWkKDpJHZLr724l5eL9wvSZQL0Sx1HV0xY0XmNhHjJxCViVUMc9awL+4Eg2jz7sRTt8geV5yLCo1g==@kvack.org
X-Gm-Message-State: AOJu0YxkV0C8+6JQ6bRhLkBGe9nfsg9HV9AE27XNJeyDd/Ta8g0t4oKx
	JuXN20ZMx0v83K7Ug3fRwJ/mLKvHX7FUGmYWWomDX5h1ITMQtbpJ65PgHGsLop4SXrsEwp3bd84
	9NNVI5w2/ALfU60MwB25U6EikZPAWCy1n2GKpLO3t
X-Gm-Gg: ASbGncu7uOzJCgcjq2VpvXtnCku9hnLS0gKZhnb58mJ6e4M/Dtwch/91Q+2BK8+pqiG
	Gm2wXAcTnBOKcuRkDBLXQXDufKILmApgUjhnVED7hWIgTJ5nvxbxVgOrw1JIORoD882tfGwO+pi
	5szADe+PV3NklYac1V8d5bWywschNjPlc3tQOtLqX7C5uFFxd7Eq4psQV0Kvw9WcJfbXtRXk+DE
	33OTg5bOLOkuvxWXDUVMjrGcNH29WYA6jgbHon4J8XKwa5DtHg66OWHCKf2eToO3segSIqxZSOv
	eFCSsDyync8Xma8=
X-Google-Smtp-Source: AGHT+IH/WfUBbYgpcQjhubmZPkjb99DuZN8mTUPRUydXIR3zlsXxfvRxJAbboXz8gq5VWvs192w21z+0QLbcg/B7x0M=
X-Received: by 2002:a05:6214:238e:b0:880:219c:34 with SMTP id
 6a1803df08f44-8802f316e39mr33232076d6.21.1761911859273; Fri, 31 Oct 2025
 04:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
 <20251008203111.e6ce309e9f937652856d9aa5@linux-foundation.org>
 <335827e0-0a4c-43c3-a79b-6448307573fd@linux.ibm.com> <20251022030213.GA35717@sol>
 <20251022143604.1ac1fcb18bfaf730097081ab@linux-foundation.org> <CAADnVQ+o4kE84u05kCgDui-hdk2BK=9vvAOpktiTsRThYRK+Pw@mail.gmail.com>
In-Reply-To: <CAADnVQ+o4kE84u05kCgDui-hdk2BK=9vvAOpktiTsRThYRK+Pw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 31 Oct 2025 12:57:01 +0100
X-Gm-Features: AWmQ_bmooBOl4Jc73SKfuTO-ZNCvAEqNx0sukASP61H3kOcFqYTjm6P9qzvWG3E
Message-ID: <CAG_fn=UQYdGqiMbFxp+XTgP=zkZgDGgdcA74Zcs9HTo+zd3oYA@mail.gmail.com>
Subject: Re: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots are
 allocated yet
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Eric Biggers <ebiggers@kernel.org>, 
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A275C0004
X-Stat-Signature: dunjejw85n77tfm6fi44e5piexqiok66
X-Rspam-User: 
X-HE-Tag: 1761911860-903150
X-HE-Meta: U2FsdGVkX18KRHsY44AS0lkdGwzBsC7yCqUEd8Usw701Eo/nhFD40pq4SrVMWecZib59unHjsN6eNEtsmTw3msbIYgu9QK9yhPC76LC9/GaN8dkKsHSAJ7dDyaAt/PWKF+WoAqZBLbu4zeCCvn0C7cj31C/DuvZijUikbeFm/qg2xEcpS26jz65QP5F5RW/cENRUp1GE+OnrBlQMIpK8/gK6RmW131pBVPb3mI1ZGQqhpMqpNlz7DZVhw53JNLoBZxkZaoywiOTGn6QIQoeR0jeo8qHGj3sFxogmkMstZ37HWAeO8++YcaZQUFBoPLM/uUeifFC0FS0qj69AKChif22/aWiF020u+hxyHIhppW++3O2eRgiE58Wewjq88zGorBs1Rc24MXYJXKX7NI+h4ZiJakTw3wH6vhv6LarhiNjv0ToEtzFeJzAR3NvmJb1POBMrmUQoeBvl6p7LyPCKZZswUkMnY9jlL0k3rJar6aM3uNjhiFxNWdGEwWW79Iqm6hRmpOnF/J9zNSdA4LqMJ286/T5jl9dQzpV2JArNONvTCbA+qEgIiRt0JV8tvOmXFCvdX9pxpVoX1YPTBi9RrIoc6bN0Unu46gI7NQn27bRKnB/t0m0Pty44JzJQEWF7FSfGkPvdx8T/hndsk4lKmxMn9noRxD4RQmfVpd7u1GCLdsPvShGv+UpWBd31mHaE0EPilQorSPvaVd79xhLTjbJFUcnlT31VF+kC6jHu0uBE8HD7Ma0lXphQ2DkDO5fK39oBPM9FMoCxTqbivgTizl6mc/dzNZrCyQg9thvH/jRQiCErHBhHkcZoBaM1kT9rxDI/5MwNXQfXjJbP3KrgrqOH9nbntgRv5TZvfsz3enOYBkPXeyW7SPjOlqsvq2O1NSGvXn1cBwncy3RSjKbQfZKsZihjpMEKzLv6sxJlRoG7EFFf4UzPpwDiXo/VeSSd832flEjtEJk2yM0eeBE
 Z3gA5fFA
 Ey2gIZ+fgElLxfoEbvROzkDcT+tO1cnLfJT6kKWDL1twYbxhNFU92j8zn8ABlqseaG5Elm630lEefnYc+GoIMrYmHqODrCul2hXZRwfwcmoPAKmj5vROELAVS8QjhVx8QZ4PCibIR4rrs4g0W+/ZS95ar4z+OSPAZV6ARo8q/R7YCHFTzIGPzHa/u+fQy9srUhkhSTCAHemmk1smQ5OVw7/h3AyiVTIkB8SupFhmfWv2AhAS98vgZUjUYuhhbyiEexBx1QUM9JR7AIvVC/kmf7fQ+rFoq+xY4kilj0vdfWOAUO7zKN4s5EOWps60sF8L9HC6+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> What's puzzling is that it took 9 month to discover it ?!
> and allegedly Eric is seeing it by running kmsan selftest,
> but Alexander couldn't repro it initially?

If I understand correctly, Eric was linking his tests into the kernel
(CONFIG_KMSAN_KUNIT_TEST=y was implicitly set because
CONFIG_MODULES=n), whereas I ran them as a module.
After the kernel booted up, the stack depot was already initialized,
so the tests behaved just fine.
KMSAN also continued to work normally on syzbot and report bugs (see
https://syzkaller.appspot.com/upstream/graph/found-bugs), so it wasn't
really obvious that something was broken.

> Looks like there is a gap in kmsan test coverage.
> People that care about kmsan should really step up.

You are right, we should add KMSAN KUnit tests to some CI (wonder if
there are KernelCI instances allowing that?)
I'll look into that.

