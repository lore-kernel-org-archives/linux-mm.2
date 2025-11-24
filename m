Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F56CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 04:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2392C6B000D; Sun, 23 Nov 2025 23:03:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9956B0010; Sun, 23 Nov 2025 23:03:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1406B0012; Sun, 23 Nov 2025 23:03:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7FC86B000D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:03:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AB681DF86F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:03:55 +0000 (UTC)
X-FDA: 84144157230.06.0F332E7
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F07320003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:03:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kfjGzXnO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763957033; a=rsa-sha256;
	cv=none;
	b=rMlSaWZFpkiHPM2y25GA7M3dqSgPj2GldDeCvqy4FoEn2ZpYSjqa21klAnCuE+VW9ICFX0
	4fgY4UpHnvmeStgQKQYY87Ue8qEFHUmqUhsWlDWTAycvuwLED9uxMPbfxYsMDZzUiGJUln
	ODfx+gfZYUoQc5GUpqKFGJ21PZuo944=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kfjGzXnO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763957033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIzIXc5+6uVpF0ayOHYE8/pgkHr6fXDjfmHkpf7eXRU=;
	b=3TtyEmxOjgTxHlyTute9TionorgVcO1mojOFnxDZAwqvMeCjfcRl4xNmDGW6UTY5WLJCbh
	LGbw4ku5+PPFuaLhZmLRek/3Ic3eluzSJmV2jB2FbM1bnt94LHFr8aM7fnxpj0LczWBOoh
	5IiCYxUNOI+Qe9oA1udEZEOVLoxuP6o=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso6807931a12.2
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 20:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763957032; x=1764561832; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jIzIXc5+6uVpF0ayOHYE8/pgkHr6fXDjfmHkpf7eXRU=;
        b=kfjGzXnOUkKMQb43XjyyWRu8Z0gNhSgvMVwP0SZzWoknw+jxPLXbUImB5hKrQXym7h
         kwiRzAGn6f9lOc30johtsRFbXTPCOQslNxyGANhjgCf9A/ghsuvlAM3+Rt5UX+0udC8J
         Vf5Z3/lem9M0l+dlMTZJ65CT6K89N99+GGa/lc/k/korzkMZx/rjMbkKavAYMvhQZWBl
         GG1lNPRYVaaNpuvuugKrAeZURFSUNeN0IjIrB9R3RUKm3v870YtSdzDiYld8FOP3idqj
         C1a1Y8y0TJx0xy3QTRn7TJJBFZjwZBadS6pWHdMpL3evvNmnb9AWdV2T1RFLcd4gtNHb
         8Zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763957032; x=1764561832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jIzIXc5+6uVpF0ayOHYE8/pgkHr6fXDjfmHkpf7eXRU=;
        b=b8UXIwYOLs012YhLjHhiJf6AC7Bkiw6UPm5Rh5410VpH08ez9Kc6HRHmjYVPCaUBI2
         jBOTC/eAErPWMotJjhety+ur/lqyh0UcvxLbDcJ8wpzDqVRizZIrYsyPhemelZwnbbVk
         PkoFLb+vQp0gZ/+M+cflugdAp5+vF47qHoV6yRPbyLXZ61asWYE5aHQ65OsDAqCLqk96
         TwGUl9iETjvf4ZMjWtizOYaSqrw5eU0vef0f4SwjtRNgwoWQwFGwO0LZnKB+h1BQGkrA
         0FdXlCXfqQNT8Z+h7dZjLV+m1c1lzf0ZDuzR9WWp6Epsa6Ci4udVyAOq5rIKYMJ1Rz7W
         FV3g==
X-Forwarded-Encrypted: i=1; AJvYcCWyXrHUhZ16djf6CoJhPQ5E5CV0SOhsVSoFVO693Ccc/WQlawH+ckEYWC3ROYKHY9YTnLI08PInzg==@kvack.org
X-Gm-Message-State: AOJu0Ywq8PAU9GtFO1xLOwPcUiZq7RtrfYpguSf/JPZYuq74Dyvz8OHU
	YwJ9oh9ugm0AyErhtxocQ/qMMvNIVdTtLg61owo9/QXPqCLMBqahX1yNbXmBrKeTNx/knFwPTBu
	cSZZYQ84VIYVvIqtM4uAmJq0BN5siuvc=
X-Gm-Gg: ASbGnctMdt/Ia1RDvkLtUFLMLVuEgWBwY5myI+OgWb7rdSCGYEvWiVXn5sKJuk9sGRD
	e2cCjI5IzctHw+F0nM8pHcFx7UqIGAr1crY6nT4ZvLQrRVmwIiSXrUQQDPg35l1ghaxboshMz+R
	CIbNA6dRYaRfFl4DF0jEt9tD3zeFdpeGe6y3dJcDMvMDQKDKmHz8ZQE89qUj0luguxnK5Y6Ob1F
	zHeOevKIrZDxCVfOGI0x/T2uXAbDe5/ktkeVHSzRew/7T9KoY4//+sBSirH721gWuoMSY17JXcF
	4WQpNsZgtDq0UPm0uiPFOEbZgQ==
X-Google-Smtp-Source: AGHT+IG+EpNIJR/8vbvl4HffeNR5OJyD41qemaPRJgSXLBv9qphS6ohV7DktIMFhDU7zw0nhM/SlfpEje2DlezUY42M=
X-Received: by 2002:a05:6402:4314:b0:640:96fe:c7b8 with SMTP id
 4fb4d7f45d1cf-64554339994mr8753470a12.2.1763957031489; Sun, 23 Nov 2025
 20:03:51 -0800 (PST)
MIME-Version: 1.0
References: <20251123063054.3502938-1-mjguzik@gmail.com> <aSMhj2Q6BTMNSsA4@casper.infradead.org>
 <CAGudoHFjqRPao2DOF35rHrYDOAjVC+dcWJ2kGm+7JqnMNk=o2A@mail.gmail.com>
 <aSOAcMSYsQ22kPid@casper.infradead.org> <CAGudoHFKo8mgxPYVitf9gGWAtQwJfHos_k-zB-hk=4FiCiYVPA@mail.gmail.com>
In-Reply-To: <CAGudoHFKo8mgxPYVitf9gGWAtQwJfHos_k-zB-hk=4FiCiYVPA@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 24 Nov 2025 05:03:39 +0100
X-Gm-Features: AWmQ_blKcDGc87XpiuRA7G298sEhmBQXlkiPO9xXgf-J4eqsM71xt2lj6A2WBO4
Message-ID: <CAGudoHEKMM575UDHpVsbPfOKQQPh55+EKgTkJbbb_oV_kjbzuQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] further damage-control lack of clone scalability
To: Matthew Wilcox <willy@infradead.org>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F07320003
X-Stat-Signature: e6wqda3mkeztm97xerumytu3tk4yn77q
X-HE-Tag: 1763957033-94571
X-HE-Meta: U2FsdGVkX189CiMfsJCsta8DfdwweEv1/9vyRqIYDEKriS57584LbIlgjia9AqF/MquiLxD8mTpnEL/wgKsfmtIViCtsuIA/3uIQm3V+QsEbKrC4Zpcs0srMy9f6QlTMcrPYieCpd6KqwZgJIgQjOQLrl/+bZzzfhMcKCw58lDsDjrOlBYqDmABhh82nLRzpqeshsTOKeiBNhSbWNOmrwriatb02OrEaYK/HQpPaNFAubUq5j+g7xkOl9DFxBWgKq7Qmzd1l+krApSfIMG8DnMl+wn8K1d/FQKdHEKo4XqgMWttqTT0h1/wwL7iSTaCte/v/iUXgNeSqwfaVq2etzZpNQuV0O0Yot8rUGQa0CDneHkJ3ovdP7rZxivnJs6O3v3tpltsJl9wFWQce3gomxO5OkLmO/cIGXpruEWqV0wsNSKq4hBbpoH1nd5wZRM0xQoxtdBnmoSw4JLCM1y8j/zhAy/0Yd6HJHoO3eWpXUaN7aZ5oekTrQ98/t65lxsPeCxyVDUWTEfITni7v62NdbV3ITWdW/0ozbnhtsFm+eE4OsjF5f0mFZ0VjQ6hd5z5o9IP09Vs4AtBI6ubelgo2FQb6xkjiaAqhE9Io2ilC7YMoxgvfV7O/tQpj46NPCDWp64VZUoGZPDotkB9h0NC4MGoIUROYHa6fewFJc6uWwU1o8l3z0IFw1t08Hpw1yZjFsifMGGUrSeD8cbk2C9KFI3eZfAsi4OhNnQGmx3RB7CvyIoJV1Ut1GrMphDj9b6Od86geX1JPO7AQenwhrPmwWoN3BuwoMqVD/7gVQd1o8SmkEGxrHtRvKLMoT371i+2SGGQz/D2YPrU+OMyG6Srvan6EMBh1q53dB8yztUDdagx8S+cMelYXjhBAyA757WmsJGgvXe1OAENfUjMVWWPN04V0ACxSWNhaLRn0zj/YE/I9yYA2rrS4qSBmpFfOkkieLIey2BSpmewJ57TnlCV
 dDYfCzBU
 PyBBq/P4y86mzSa0jj3iPinC2LzsRXUxG8xXUV/f0PWyM0wQYNAtsTQYA9pBrJg3RZ2Mqz0rBsf+exnWFSC9X4EWI4O/K8b7HK6RYYspn4OyUXHdbaINP6b7WoHvpr7m8C8eN73lRTdqmvBm/CxHkrfgvSw9O3m38rwTyw6euZtOU0SGswBJqO41ZwzJzE3gJgNAckQdWFLXp/ASuwILkFl+dQoks6G2LNNnnW1rH5nNhTGMWEtcxr51XEH4KKOgZXoEW8w8yI+M3vq/8e1LcBxWp0qMjnYxdYYBIWGxvM5ax3zB2Qx5VRmKJXuHBuCUjgvCxc64lhRz9zM93tzN+vxPn2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 11:33=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> =
wrote:
> Ultimately in order to makes this scale CPUs need to stop sharing the
> locks (in the common case anyway). To that end PID space needs to get
> partitioned, with ranges allocated to small sets of CPUs (say 8 or 10
> or similar -- small enough for contention to not matter outside of a
> microbenchmark). The ID space on Linux is enormous, so this should not
> be a problem. The only potential issue is that PIDs no longer will be
> sequential which is userspace-visible (I mean, suppose a wanker knows
> for a fact nobody is forking and insists on taking advantage of it (by
> Hyrum's law), then his two forks in a row have predictable IDs).
> Anyhow, then most real workloads should be able to allocate IDs
> without depleting the range on whatever they happen to be running on
> (but deallocating may still need to look at other CPU ranges).
>
> With something like a bitmap + hash this is trivially achievable --
> just have a set of bitmaps and have each assigned a 'base' which you
> add/subtract on the id obtained from the given bitmap. The hash is a
> non-problem.
>

So I had a little bit of a think and I got something and it boils down
to special casing the last level of a (quasi)radix tree. It provides
the scalability I was looking for, albeit with some uglification. This
is a sketch.

Note that as port of allocation policy the kernel must postpone pids
reuse, as in you can't just free/alloc in a tiny range and call it a
day.

Part of the issue for me is that there are 32 levels of allowed
namespaces. The stock code will relock pidmap_lock for every single
one(!) on alloc, this is just terrible. Suppose one introduces
per-namespace locks, that's still 32 lock trips to grab a pid and that
still does not solve the scalability problem. For my taste that's
questionable at best, but at the same time this is what the kernel is
already doing, so let's pretend for a minute the relocks are not a
concern.

The solution is based on (quasi)radix where the datum is a pointer to
a struct containing a spinlock, bitmap and array of pids. Likely will
be a xarray, but I'm going to keep typing radix for the time being as
this is the concept which matters.

The struct contains a carved out id range and can fit -- say -- 250
entries or so, or whatever else which fits in a size considered
fine(tm). The actual pid is obtained by adding up the radix id (which
serves as a prefix) and the offset into the array.

In order to alloc a pid for a given namespace, the calling CPU would
check if it has a range carved out. If so, it locks the thing and
looks for a free pid. Absent a free pid or a range in the first place
it goes to xarray to get space. This avoids synchronisation with other
CPUs for the 250 forks (modulo a thread with an id from this range
exiting on a different cpu), which sorts out the scalability problem
in practical settings.

Of course once someone notices that there are no IDs in use anymore
*and* the last id was handed out at some point, the range gets freed.

But you have to do the locking for every ns.

So let's say it is in fact a problem and it would be most preferred if
the CPU could take *one* lock and stick with it for all namespaces,
all while retaining scalability.

Instead, every CPU could have its own pidmap_lock. The struct with the
bitmap + pid array would have a pointer to a spinlock, which would
refer to the pidmap lock of whichever CPU which allocated the range.

Et voila, allocs still get away with one lock acquire in the common
case where there are free ids in all namespaces which need to be
touched. Contention is only present on xarray locks if you ran out of
space *or* on the pidmap lock if someone is freeing an id. Hell, this
can probably be made lockless to further speed it up if need be.
However, lockless or not, the key point is that most allocs will *not*
be bouncing any cachelines.

