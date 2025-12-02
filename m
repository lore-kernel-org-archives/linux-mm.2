Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D98D12673
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 21:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637CA6B0062; Tue,  2 Dec 2025 16:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F8C6B007B; Tue,  2 Dec 2025 16:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BDE6B0088; Tue,  2 Dec 2025 16:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46F666B0062
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:01:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECDE112DD6
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:01:49 +0000 (UTC)
X-FDA: 84175752738.20.849AC44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8286120014
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:01:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5F9XPB5;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764709308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfIB2dTwVK9TXQOG+9XblKFW0gXqGvS4rA6eHs5TAec=;
	b=kb0JkgriOlOr4cijH6axaA30n5KXEw8/QkdQVF1k3+XhzlKWMijmay2uX9iaYeoasJER95
	TenIhNwixclWpsQHJezOdNJZDa8bg0KveCQmtN5WFEKXNyowa/wroRSgxhtoPa5ZJM93Ms
	0krvos23kio6k8unu0PGshbBQ5a8+5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764709308; a=rsa-sha256;
	cv=none;
	b=hELgho8in8O3cwrS+dHgv93bCtXHiONQupPpT3uqHm3nv0aktnH9XnJr+kCbaQqeFBgiwS
	E6NJDNW0MS66r7lWE+zsm3xeO8z7O851xalFmFhMATslS85pkjl4Zah/bwzVVqfSSrZXwC
	KOVmpEK6fOBlccZY3rn2W1jk4L+RQtY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5F9XPB5;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92B4C4438C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B91C2BC86
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764709306;
	bh=Prmm/KeVL9uyZcHlLqpGMJwDHpB+k51t8aXoNMxOyvo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s5F9XPB5LJy0RkX5APnJuB+RXahY8F2DUAOcwq5srYlgQVHsJv/+5Rb2FGJtyx9Yb
	 b6T8tm/VAXAczEJ65HyxjdHJRTj3vgtrFDc+q2MEMvBAxckTKk1JxdUrM4uB326tqr
	 7vAGUXZ7om72qYnbjUvkVdf13lJmWFl3Ociv1Xsu8WtCgJAFLFrRXu6kGMM+pPhBej
	 kILgKxH+uoF2Jsx6W7dqiWh109W32SZNvCmg6mi1jrmcMtQnHL5EZch/gOMCM5bEYq
	 dGhabPBzYQ0DU0GSMgnoM6ykIfdhEPkXw78HHTJ2Z8REP1x2BpvpgKkWB1PVixu/JQ
	 F97g8TbkNQCpw==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-63f96d5038dso5190908d50.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 13:01:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV91EByd6wiqHK0S8+2+wr0T5SrUjId9I3CNIa3+/KQtTiDVnURzkqjt/GrZzJmqwZWDNoY/NUn0w==@kvack.org
X-Gm-Message-State: AOJu0YzcgVPwHDUyz66bZrVNGlyaud+wclsHXu6I5xAkjgzgktxdVHsI
	S1gjrjg13umhtvRA4eya68Iblq0teSabWYcpYhkHiCqHTVStvkDUoe38vuaVHRReSeRin0py724
	/9HdJmwMzW5uuRq4CkgYfQk6eOV2qPukNYE8qaoxZ+Q==
X-Google-Smtp-Source: AGHT+IHB8Zyz7EwMSUL/jLnXqgH7DxdnwC2rgumZt+GP6kWCxJi7ULzqffBVZFn67K3oGK1epCAszgJLWpJCEqFxcNk=
X-Received: by 2002:a05:690c:630e:b0:786:393c:5f16 with SMTP id
 00721157ae682-78a8b556fb3mr349935817b3.49.1764709305579; Tue, 02 Dec 2025
 13:01:45 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
 <CAGsJ_4xZPPE3TaAYU96srZKe6aKZmV743kQ97E48ZWh3BQ5Z6Q@mail.gmail.com>
 <aS6H1b4MHo9HAPHS@MiWiFi-R3L-srv> <CAKEwX=PUW_sbN-GQXAh3NHGGuN8LOSFy_8qWRUUqafgwW4JB_A@mail.gmail.com>
In-Reply-To: <CAKEwX=PUW_sbN-GQXAh3NHGGuN8LOSFy_8qWRUUqafgwW4JB_A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Dec 2025 01:01:34 +0400
X-Gmail-Original-Message-ID: <CACePvbUsTjkwYZ+JbDuYDpjsTp9tTScsb3omzLKvAN1nTibxeg@mail.gmail.com>
X-Gm-Features: AWmQ_bmzznTZTiROpT8pXWGJWHKQyXkGX50PvkHF43Zf6zMNYcdRBgxwaLfXBMk
Message-ID: <CACePvbUsTjkwYZ+JbDuYDpjsTp9tTScsb3omzLKvAN1nTibxeg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, Barry Song <21cnbao@gmail.com>, Kairui Song <ryncsn@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C8286120014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 1ckupkr3jrtcdupgaphyc7yqiq78syxu
X-HE-Tag: 1764709307-382216
X-HE-Meta: U2FsdGVkX1/aqYz9cEHhTyM8NhgTMwoyeYdJJHTGJ25zYPIvha9s4VVT6g0H/P6B8M9uy8fXKeqCytYqJnXXHU5A8Xvxam9ZEuG6sCawmaHNQGjyMxZan6pQMvBDL6V7rWpLTdr7PJJk5xP4HrMruYd3comRNjK/3W9bFa+kn+M0wdR/Z7WYeW/ix4d9HRbixjcb9NxlxNEq8zONmVUcEPEAWZXtO8robeADNu1bNg3tvUnT8GrZqyN186X3DgdbgWA5U51VeeQqetaFfyYC7mUXloESak7J7zkCtVwZf1uJifkNJ6Pb+d98C/C5Bi4Ehiro0sl52KqoGBvrcVhoWr3zdM1WXoKB4zQokgX8fPsYLs8QAyKM7nT4mO+mMO0uH9r8JKJz4ca9aNEO2q+PgSnJC0dS7uGJyBV5BWXKA+PLycquo3akPCb0j4y17LIxXKAZ3fooYAsXDkPPMsFhEwVSbLc1Ow3o0migxXLLCRabCODKY41syl+RozBm/jRn8v9fnPHMPNTQ/q4iQh+92WozAlf/qzkyo0PRckAkyQo5n0YaESNpguGVOY7FPqdrEBW7cc/3k9ZsUhQCPG5aEmtORgZuDRLp0Yc5iozLX4Xl2meaJKsqnCwup1z/YxEPo+Z+oSNOUFMFrWXR6Fi2yf8fhc4N9JGU+1UPkIDFJxpuGxTY9OgGxtkqCRyxGCZ1kJheh+lfFvJJtRol8trZ+0lcrTBvSUl1CytKN472kHfRsoJUpZA/ZToteLEpKH23wqXxuqgeLBSmakOTsqrpJeRxQgPQ0cAmIaHP/3GX9AWvjaV71hFwz0KOIXCIxzfTcMaf5KeZpv9aiBlNwZXb0r5gKlSnN+vcN861twLtUuF2UQ4hMrB6Tf7XlK/W5KhZOzwKMiOqnKA4MC5rac4F5tRl7jjglP+Toj8vkUbResuwtdFq04kiUoS37dDeLFTSmmWyL+ukbiRSJvbLXai
 KMhmuSFU
 ZrA/oK7a+o8FG1TIcSPBQ+ScZdN0g68G7rVzH6UkrB0K9kTUQ+ViKDcV0IaxR9zGGD2afQLubQNojwbxx+ewsvJrcWe7/AhUOYAHjX0/KhSAennoRcqrHOvPwMEyQ8eUrSxqsYsNfyZ1L6ccvkNhhHzw7qmciwTWz3NSvT+qN4cUOGxJVkpeks1YNnqihz3PZw3eKVFf8Bc5a+DNNgB/oWDb2yHr/S0sOD7+ntL4iScidO3Uyfwe7WJWfW5bYcLT7vS8IOLDACgyhuO3EdN7KeS1rIjrNRFAtCYZHwuKuxnh/pasNsGdWgSHWcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 9:53=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
> > > Apologies =E2=80=94 let me raise a question that may be annoying.
> > > I understand that people may already be feeling tense and sensitive.
> > >
> > > Despite the benefit of compatibility with /etc/fstab, we still need t=
o provide
> > > a physical file on disk (or elsewhere), even if it contains only a he=
ader.
> > > Personally, this feels a bit odd to me. Is it possible to avoid havin=
g a
> > > =E2=80=9Cghost=E2=80=9D swap file altogether and instead implement al=
l "ghost" functionality
> > > entirely within the kernel? Ideally, we wouldn=E2=80=99t need to intr=
oduce a new
> > > =E2=80=9Cghost=E2=80=9D concept to users at all.
> > >
> > > In short, we provide the functionality of a ghost swap file without a=
ctually
> > > having any file or =E2=80=9Cghost=E2=80=9D at all.
> >
> > That's actually what I would like to see. Just to make that we may need
> > change syscall swapon, to specify the flag to mark it and initial size.
> > People may complain about adjustment in syscall swapon.
>
> Yeah that's another design goal with virtual swap - minimizing the
> operational overhead.
>
> With my design/RFC, all you need to do is:
>
> 1. Enable zswap at the host level (/sys/module/zswap/parameters/enabled).
>
> 2. Enable zswap at the cgroup level, through memory.zswap.max (you can
> also size per-cgroup zswap limit here, if you so choose).

From the kernel point of view, managing swap entry without swapfile
poses some challenges.
1) how does the swap_full() and swap cache reclaim work in your world?
Will you create more holes not filling and fragments?
2) Do you internally have only one si->lock? You will  not able to
take advantage of the swap device round robin behavior.

> and it *just works*. Out of the box. No need to create a new swapfile,
That is a user space thing, existing user space tools.
> /etc/fstab, etc.

Able to continue using /etc/fstab is a good thing. Now you are forcing
distros to insert swap on for zswap which do the above init sequence.
It puts more burden on the distro.
That is not the main reason I did not go this route. Mostly I want the
patch to be simple and easy to review. Keep it simple. I see virtual
devices have drawbacks on si->locks and other user space changes
required.

> If you're unsure about your workload's actual zswap usage, you can
> keep it unlimited too - it will just grows and shrinks with memory
> usage dynamics.

How do you cap your swap cache in that case? I feel a lot of
discussion is very hand waving.
Having a landable patch will get more of my attention.

Chris

>
> One design for every host type and workload characteristics
> (workingset, memory access patterns, memory compressibility).

