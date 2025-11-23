Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18CFACFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 16:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317396B009D; Sun, 23 Nov 2025 11:39:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7226B009E; Sun, 23 Nov 2025 11:39:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD0F6B00B2; Sun, 23 Nov 2025 11:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05C796B009D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:39:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 542FA12D308
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:39:32 +0000 (UTC)
X-FDA: 84142432584.12.CDCBD88
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 67981180011
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:39:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BOFGPUt2;
	spf=pass (imf16.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763915970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nF9F5efojBGLZOAlTl4vjhThjbCD6GXSkPa3Y2WCZI=;
	b=aZT9aJJlfVcEP+bRZQF4AXLFVMPOzIBJ2LpmfZ01fyo1RKqif1m9xvMqBMYe4w3oi0Y7na
	7qicTiFi8d1yVNep533rTMmRTrG8Vj2n20jc+Y6zu0hf03QjUiLCeUwtfogYhBAZhpnRhq
	BWw595r9aqkKIibYFJYKzKOENmGQeZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763915970; a=rsa-sha256;
	cv=none;
	b=8YNFgBEQhGk76KIISGtEp5LzE3ld7JP94EVZ78hciYGqJySd9LWqy26h72nWcbyNUECkhE
	12vk6THLwyhHKGzSQeQfPzM6SU4yywBmlIrLXKf6yGy044AyrRmXYPnrZlJVyNDx82Jzp0
	K/VodYkTLkDMdIzaVa2t0Tuks5hq3Rg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BOFGPUt2;
	spf=pass (imf16.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b7277324204so598442866b.0
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 08:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763915969; x=1764520769; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nF9F5efojBGLZOAlTl4vjhThjbCD6GXSkPa3Y2WCZI=;
        b=BOFGPUt2WfkVDLml2wu1/59eqhdKL8xjvpwSh5vcI5zgjZKoE+yS+f+SueSJ3vpGj5
         4IMm034iKKk7Q+eKZBi3B/ABQrdpA22z2y+OuwrHvTMQoaJtE9KdWShKxVeH3CQPEO01
         3SOHXHiTHBIV1YMJjalm7SCMQELiek14wj2tVsI5p0LjJna93e4mDaVG4+dFdYIYcgFj
         m/bC08BiCgIWgB3kFl6kxFDhCfYugDrUtBXFCAb//0UmBZqxp/2MgnC2ijnQgbHfnf8m
         dk1JvihaOn9+2vPcnUgCok/Y2NEiu8ZDrtZ/QrEal/S6ViwTaeim/Tad8SPay+j45GSu
         5v2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763915969; x=1764520769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9nF9F5efojBGLZOAlTl4vjhThjbCD6GXSkPa3Y2WCZI=;
        b=jV4IvzECjJriL3WXR/Pjs6QxlrZY6OnLprFEvolFeC/XiF+yosgLDTsG/dx2EJg2iY
         +Arq21OzgjrNhm9SW6VNHNG5wKS/zIVuUytQKD8e1nSXjtd3w79gfSUDqDsqC8cu57pH
         WvGU4sChirEyU4NwlsDaTQ/TaGB8RREkevfdMxPJSabd8EX0zb6F2SWX6c9ysfREu1os
         8vRTUP8Jtjx6OQDvkZFOdOeh2hqaHzj5Bi80Q4BPxhOD6UJUTBMv/5NXmnkzb2dU1qrE
         4YMRWEqSlYjSzpQcT+kNHqWfZ3MftXWuDWiEMT9QjHhkr5kG+7LHX611viAgAeQxZiR8
         RavA==
X-Forwarded-Encrypted: i=1; AJvYcCXUQLqFk5Vdo9cn9/Qj9FUUb55PY7sOhCsC1vJ2/M7T2btERX8uTNdriNWLB73aOlc9RCGVdjzR8Q==@kvack.org
X-Gm-Message-State: AOJu0YzKHOj3nagHY7L9he1bxpYYYZhmlJMWdpubZ/9oV+ENcTfSaEVn
	7B6NV1DbkMPGV+YFDZqnRVVJJkwyxG3l5J8H1EXVMVfeq8kVZkqzmE33LLjn3H4sgUMyiTkiVyL
	vMjrYLW6LN8lzPJZoLn6C/JGP5VN15OU=
X-Gm-Gg: ASbGncvchjEoYD6zexKJ2MN9Z7dShS7yf6XlsWJ2/xnEgZuaCxAif9RIR4uu8GwofqA
	KGYeHxyAsviMC0VIeC1qXumuL3kFKARfQNCBNearLDaDi5T1dPj0ibBmsZvQAJb+SfBStmBvi0j
	a/PFnOB0bAY+HudSunIJpoBPVXm9UBibDiXFwJB/RRnF+2HBihU//LjP+NhjCBFGKiLypFwD04X
	+G5yEuFKZtFr2xLDfKz6+uAcqM0jf6/MImk0PfzeCBcbiXX6zJbzTibAvKlXQcpDWWHIMQ44XGd
	wvXsGH81WggCE9eNw21owrVnGw==
X-Google-Smtp-Source: AGHT+IEXHuzrSrOwRIezBiL0JIQz+ZX4o5T1WHd/HM+Dfad/rTBo+hg9vThiH+eF0HdyLrDgtXE7IXukdfxN+plJwZ8=
X-Received: by 2002:a17:907:78a:b0:b73:6c97:af4b with SMTP id
 a640c23a62f3a-b7671731855mr970489366b.45.1763915968401; Sun, 23 Nov 2025
 08:39:28 -0800 (PST)
MIME-Version: 1.0
References: <20251123063054.3502938-1-mjguzik@gmail.com> <aSMhj2Q6BTMNSsA4@casper.infradead.org>
In-Reply-To: <aSMhj2Q6BTMNSsA4@casper.infradead.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 23 Nov 2025 17:39:16 +0100
X-Gm-Features: AWmQ_bnBHcrpFlJyjHMeWmpSf0ukjbGRorO5d3kVyh81tcR2HnPftoyyZ6MpFZI
Message-ID: <CAGudoHFjqRPao2DOF35rHrYDOAjVC+dcWJ2kGm+7JqnMNk=o2A@mail.gmail.com>
Subject: Re: [PATCH 0/3] further damage-control lack of clone scalability
To: Matthew Wilcox <willy@infradead.org>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 67981180011
X-Stat-Signature: 7fgobthpf1kahgaiz7gz6q1tonybbop6
X-HE-Tag: 1763915970-667601
X-HE-Meta: U2FsdGVkX183JkUN43pf7vjTL6UD5oX0Ek0YKdnVlkT/fNgToE4zglWHxePzHixgR3S1IGHkrzTge+3TGCgV6gOqal3BSN/413W4KLpDmTLxzJb7+ekttWrF/7oM1zatqTs73wsvT7nqekRZlKTGPBETqBMqWhaQf121G3Ua7jjLHlSgR63rMB1VuNE5oXy0GC5YOrqBnQap13DrpB4DFTa4bna+Pi3nRT3jXwlSK+lRiwXy43p1mVDleHVQ1oWLYoZiWZ7OrBW3WmvQfNwoW9hPfaVOzYa6/SLpPXJXecX6Tlc4nSuudN0UDazePy4dUlxwD8vRmrXEy6r4ekyAx8qgzmCvvT1SyBgkhcBQJBGwXgm3JhqIFua2+IqjDuDsQM+Ae16Zgov4TWpY5hRRpZPt18w+nsHJOGfI7KjFmHxBa5ZYGdFZKlyseWUWM/cij6BKzFQpeMzSkoTW/ZSYQugTvyMvfzTpRoDAkQw+4rykF6S9PlxLyBUeWogIsJ4xuDZIKPxF+aQCGDhRszGUnQScAFaw1ghe8+djTJ0W+OngKsTj5NU7eY8n+eIY3mEJuy34ZvH/eXYydctPif9+NuFa/5Vy2NEhJCz7daIHW8bx34ycL+ICwGORFmZp/+VbBLS2IU8NI6Ag0fXqoT92k9zKXfbhi7Oc4UOmHp9Gva3WVdpevLUpqBkyZUZOPKVS9YqmB5j1p1zT3ySfahe55flz+PqWda9Zwek5y7oj6tyHA6Bv9on7OOBjaxkgIYJXvLLD+Wn+cogR7WklhfUmIlYuOTaO5BmaUgDrq/IemzEVkuje4ccWYxpd4/EPz5L1st1K2WpxYbNA6p5ros0XE33hJ//QgjP0yCcN0k3hWLEKSU6DNHS9lcYCwED5kcPfvQ9wiI1ASYz6HVf21qPccB2YdrmItz4Ma0TCHduf0nIlQDpl5ryLQrs5Py3bB3uzV8dYWXRk8x1LGoZBLAO
 SpPWevtF
 0haTEF9pM/mJQc0N6v8azovOGcol+oqpmo40JC+w526FTm684FTuhcaUyQfk6KmTbIXsk6kgc20a1XouJj0Y+NeyIbAmNFSawHLH8GQlY5eWcXpRaOKiagngfwDwlwR5yGRBfOAhcpCJdEmjTPUayUOsopKZ4817+P5KwvAtYCsNuPmkvs54ZrX2sNSxqwS5IooWi9Tfmv9X+x6/o1xbFZe4mDfrL4fd1uvwwCqZr5hCGkMZn1+KzCzmkZlOvc2Wdqer4M4/J/4EOCyELPxdqnt3vcmrodjek36trMDAwWCZOhpQicZxpHLhFdpbndlFF5IU4KWPqzjq6R3rqyAna1TnWyGo7987Oztl4hm56f0azxpF+BtPAd0LAOs3mreSp0b9A/bEhtNOgRoALy2Ez4OsRqeMXCIqn8ubi0R4/2aTbEKrnLiixEFQAt20ka1bCX0siFUsvSxK3vVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 4:00=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Sun, Nov 23, 2025 at 07:30:51AM +0100, Mateusz Guzik wrote:
> > When spawning and killing threads in separate processes in parallel the
> > primary bottleneck on the stock kernel is pidmap_lock, largely because
> > of a back-to-back acquire in the common case.
> >
> > Benchmark code at the end.
> >
> > With this patchset alloc_pid() only takes the lock once and consequentl=
y
> > alleviates the problem. While scalability improves, the lock remains th=
e
> > primary bottleneck by a large margin.
> >
> > I believe idr is a poor choice for the task at hand to begin with, but
> > sorting out that out beyond the scope of this patchset. At the same tim=
e
> > any replacement would be best evaluated against a state where the
> > above relock problem is fixed.
>
> Good news!  The IDR is deprecated.  Bad news!  I'm not 100% sure that
> the XArray is quite appropriate for this usecase.  I am opposed to
> introducing more IDR APIs.  Have you looked at converting to the XArray?
> Or do you have a better data structure in mind than the XArray?
>

I have some recollection we talked about this on irc long time ago.

It is my *suspicion* this would be best served with a sparse bitmap +
a hash table.

Such a solution was already present, but it got replaced by
95846ecf9dac5089 ("pid: replace pid bitmap implementation with IDR
API").

Commit message cites the following bench results:
    The following are the stats for ps, pstree and calling readdir on /proc
    for 10,000 processes.

    ps:
            With IDR API    With bitmap
    real    0m1.479s        0m2.319s
    user    0m0.070s        0m0.060s
    sys     0m0.289s        0m0.516s

    pstree:
            With IDR API    With bitmap
    real    0m1.024s        0m1.794s
    user    0m0.348s        0m0.612s
    sys     0m0.184s        0m0.264s

    proc:
            With IDR API    With bitmap
    real    0m0.059s        0m0.074s
    user    0m0.000s        0m0.004s
    sys     0m0.016s        0m0.016s

Impact on clone was not benchmarked afaics.

It may be a hash table is a bad pick here, but the commit does not
explain what (if anything) was done to try to make it work. As is I
suspect both sizing of the table itself and the hashing algo were
suboptimal for the above test.

I did find a patchset converting the thing to xarray here:
https://lore.kernel.org/all/20221202171620.509140-1-bfoster@redhat.com/
. It looks like it would need a mildly annoying rebase.

The patchset does not come with any numbers for forking either and it
predates other unscrewing I did in the area (which notably moved
tasklist lock away from being the primary bottleneck). If I'm reading
it correctly it comes with lock trips per ns level. This adds overhead
both from single-threaded and multi-threaded standpoint, in particular
still having multiple acquires of the same lock. If it is fine to use
xarray and retain pidmap_lock that's a different story, I have not
looked into it.

Regardless, in order to give whatever replacement a fair perf eval
against idr, at least the following 2 bits need to get sorted out:
- the self-induced repeat locking of pidmap_lock
- high cost of kmalloc (to my understanding waiting for sheaves4all)

