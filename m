Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8766BC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BF56B008A; Mon, 28 Jul 2025 17:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CC86B008C; Mon, 28 Jul 2025 17:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132956B0092; Mon, 28 Jul 2025 17:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 042B96B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:41:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB31E1403A2
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:41:52 +0000 (UTC)
X-FDA: 83714996064.28.7D33A27
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id D050D120004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:41:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="sfgTe/dx";
	spf=pass (imf29.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753738910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUAStNjqHbOFii/5P+u4/wZKuq2iUR2hGxINlcM8q3o=;
	b=2UoVyNSvAShhTbYV8bxxwuib9WdI/QmPWRVtkIov8OPwdY4N0ClUiq4HaZuuMCoK9Z8qtn
	puzqWRldnneYS64WEuScm9cyLzPaOcZYGC6PAFqACxSQ3I3tBK9o/rTwEZp1DfLhfMZ3Bb
	7K16LF3o+pFGNEldgPWv9Jl5sxVNEk0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753738910; a=rsa-sha256;
	cv=none;
	b=We3TXGa9c4taZW3CWcxHB0FJrGY7T1+6l1EKG05Gp+sGGUDhPygQOOzkxbrqpKjc6TNdo7
	h2B4ZKMH6wAhrHlDCWrr2xrMLFgGyqhzmcI4hbygJ+YRPUI1MUfYKi7jTjnE2I2hZR4nw7
	8neYs1T6V2xOzT4mmJm4kYyRSmt9tds=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="sfgTe/dx";
	spf=pass (imf29.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b34a71d9208so3606931a12.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753738910; x=1754343710; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUAStNjqHbOFii/5P+u4/wZKuq2iUR2hGxINlcM8q3o=;
        b=sfgTe/dxE/7e2BhvctZzfrh8adwEgTcY6OUDxtNL/JaqzXkkxjJUrhM4VwpwdgD1/t
         5u3ys/jwwBmmPl0I69fRibTV0c8IUZ3Pd9shOmOxcA3XB1idIRWB8i46+Qgkd7owGbA7
         S8RpEScLl/KOXSbApI0t0ha7osdAZuBspRDM3hH1YYorzn9/9l5fn2p/THsfYV83zL7K
         3eT+8OYTLGrp5H74ncnGXz0T79UGJeydWUdsIY6T78qORQ9QrUzXxmrbGdwuoB8yJGo5
         AEe6nCQDrESILrffPEWP/lR4GFNQpSClfKsUrLU4NTP83qXJXmxRo0C6/Is4komlkp3O
         UQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753738910; x=1754343710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mUAStNjqHbOFii/5P+u4/wZKuq2iUR2hGxINlcM8q3o=;
        b=ElbLID0bXG/k35n0KJ7bCJG6Erdez4aPqnLXWlg8wM4Bsgc2ZTc7dhLkU48L3LeIVJ
         Lb94KdSlPdxqqNeOXI7zWxd9mJg9hZYLxirMJ8DmPwcKHQtLcHx/AzeUBar2DIpGmiVt
         kZzW8gSQlTC4NoZqRUTPgyEuAVjvhQk1LpRb+d0P8nMpR6xXTmMVyEc1UockqLUp0iyN
         GDIYQN9j1C+haMFMon71M44NoYGX09MveaMxRNwRFRrBaOvt2FLA416Ve0scE2OcSAk5
         iZTrzGN7pIoddpbNiUR+Q95wmU1D8aUu8ddu/IOFNVNxZnRKo5mARK1pumKsVqenKUkh
         oiaw==
X-Forwarded-Encrypted: i=1; AJvYcCUyyoaBYqSfzU8FC4Q9vtt4a+NClBTjsR3Mb0BQJDufrVELX2OGM+BRXI6ya+8jgbxJU5tzwjDVew==@kvack.org
X-Gm-Message-State: AOJu0YzlZtRSlPcWnpaYUhkwLE3b892WLV3TGQ3/aNQLV+OjyCw/Aqrk
	qthKGuxBAMPh7TNdxrLvGhzTIxkcFTHa25qByv80p8zbJsjujIUeyjIRumIlbR2sRKjmS50OgQM
	91mRzCxd1AmN6lCbyAPT44Suc+g9glQwLLlU+N0Z5
X-Gm-Gg: ASbGncsZHxqUgOqaArJCIuBMHvY3LOb7aKwB0y+vEwMF0Bi6XH1IQXlHiH0+ZZLpQya
	w0qV1ypXbSPeeGq100tcBb3hzl7K6+ouDwWY3LvPHFFeV/OgisqRQWTVWYWNLMc9kaaSp6SmTt3
	F6XI6azFYR7Lw5+8czgYrMjoIN5PS+43cA60Ci+ByEEv0LvKoLYdWtb+RyDlDv4YiPwprjcxXj4
	/pN47SnCllDI2kOPcdUXOD2C2Y32zznuW6Vh2ze
X-Google-Smtp-Source: AGHT+IEOGwzp8WL8Q8zkHDQhkD+Y1vauphLStdSB+fJ+ZXlleLTi+x8oG5ddB2+iE4U4lYOfWltk1Hl2Bj7BLkm2VMk=
X-Received: by 2002:a17:90b:58cb:b0:312:f0d0:bb0 with SMTP id
 98e67ed59e1d1-31e77867c38mr20558782a91.12.1753738909472; Mon, 28 Jul 2025
 14:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <20250728160737.GE54289@cmpxchg.org>
In-Reply-To: <20250728160737.GE54289@cmpxchg.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Mon, 28 Jul 2025 14:41:38 -0700
X-Gm-Features: Ac12FXzCNlmLcbIv9fmqumLLgswVMcQm_-d98NXQVOA-rLpKXIlVokMyihIY7Fs
Message-ID: <CAAVpQUBYsRGkYsvf2JMTD+0t8OH41oZxmw46WTfPhEprTaS+Pw@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D050D120004
X-Stat-Signature: hppckqnwifhj9bs1ewe99f4m6rmc3fgr
X-Rspam-User: 
X-HE-Tag: 1753738910-917356
X-HE-Meta: U2FsdGVkX194Oz1qaH+nbrasqNgNb+/VJFYq6cwysb2Xu/2XL1Zu9CR8gYi4s+hkl7CnvaJvn0yzipdBNz7+A9XDM1zBfavfJ6C5yEeYMYVmlL/TXKaQ8eLpKryZzY6gZoChaGIMRSkZ4IQ4ooNwxT7nlx+euPEiFOj9SGYPrGQdkVkfBbsxvIA48ULD5MDspRBYIJg76a7W/x61G0+IuDPQenArVl1T6AxW6DulWeMrKm2YwrsHpISM6huBXvLBVFRa31lI8DL95gQFZ6Cm0H0FP6ojrOl/jRpVadM/pdddO2mYa3n55Hp1RX7x3OVEwgkjuaF2D7EE0bw4DlZTsANtNaJLb/dEH3TP1U7x8zuNoA0p5e0WwDM4Urxsr4IzZoG97BlU0pwZfHIQrfY+S3JRLadCR+NgTb/SlTAT7M9kqMgVcHoEuTwW1EH42B3lK493vV31Z3mZ7+ojsJeQ6Gwyu1HNWEuQV/9oEHEitl8KIc9N+TwB8YjJMFtZYVnG+rD9NW4cUe33Q3WMZfZffxH8V4lpxoVXMHHulm4E0ai3J2+e5Qt5Qb0CEPFy9Bu9frPLq8C/yVNwXckQCThPHqPPtHf9ax/gOYYmIzjbGfe46nDCyk5i+b/a7D+MCKhnz6tINjLlJ9EFZDWWMUL88kRXGDv0ro7ySKLn4kCrU3YGBoHQLedRpz475pXGV6cfg/0lIDLxQqmNrsYdwgBt4IfguMLKJ6TuEE25xEWvjkFdvN/1ZyNego7IUB3ngqDUN0nCd+F6lyx9e9UDvzmvrrnMy6op7XuSLUmdq5cO8Mo+8ZmQ1y0vHSi//W71m8hr6aSznRQnE2DozUMHHV89ZnxsY2La2JpSTHjhb/G0VitTCNbQ1kkgRv0jw2ey1zZIO9QYzlYtjXDTUeHfuqld4E3fqFBKYH22QyMq26oGhoXi/QZGuGUe86B8kPql1rnJ6cynwt5+JFTJxm18Zix
 wDJXwVGI
 bZs0Bq9KcEGhxMDl4o17FedJy/gaqnc/ZcjmL0XV1FKGvPfJPeGEJuAvpKQCYqPj6gYkSd473xa7BPmuR9zEgKh+xe16G0HC/uFnepbNaanE7tWrchhidJkYLBDBhM76zw2gQDu7l9/4HA7lFJJJGsKdKKV2c3GvusR3OgmUbPQ7Zse7+1O7V6IWLdF9A2KkFUI60SKTqLLtYVanK5P9UDFLqmQ5vzAhS1z0o8n0wixVFy4jM1WsPPY+HlWR0usIRIHK+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 9:07=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
> > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > buffers and charge memory to per-protocol global counters pointed to by
> > sk->sk_proto->memory_allocated.
> >
> > When running under a non-root cgroup, this memory is also charged to th=
e
> > memcg as sock in memory.stat.
> >
> > Even when memory usage is controlled by memcg, sockets using such proto=
cols
> > are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> >
> > This makes it difficult to accurately estimate and configure appropriat=
e
> > global limits, especially in multi-tenant environments.
> >
> > If all workloads were guaranteed to be controlled under memcg, the issu=
e
> > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> >
> > In reality, this assumption does not always hold, and a single workload
> > that opts out of memcg can consume memory up to the global limit,
> > becoming a noisy neighbour.
>
> Yes, an uncontrolled cgroup can consume all of a shared resource and
> thereby become a noisy neighbor. Why is network memory special?
>
> I assume you have some other mechanisms for curbing things like
> filesystem caches, anon memory, swap etc. of such otherwise
> uncontrolled groups, and this just happens to be your missing piece.

I think that's the tcp_mem[] knob, limiting tcp mem globally for
the "uncontrolled" cgroup.  But we can't use it because the
"controlled" cgroup is also limited by this knob.

If we want to properly control the "controlled" cgroup by its feature
only, we must disable the global limit completely on the host,
meaning we lose the "missing piece".

Currently, there are only two poor choices

1) Use tcp_mem[] but memory allocation could fail even if the
   cgroup has available memory

2) Disable tcp_mem[] but uncontrolled cgroup lose seatbelt and
   can consume memory up to system limit

but what we really need is

3) Uncontrolled cgroup is limited by tcp_mem[],
   AND
   for controlled cgroup, memory allocation won't fail if
   it has available memory regardless of tcp_mem[]


>
> But at this point, you're operating so far out of the cgroup resource
> management model that I don't think it can be reasonably supported.

I think it's rather operated under the normal cgroup management
model, relying on the configured memory limit for each cgroup.

What's wrong here is we had to set tcp_mem[] to UINT_MAX and
get rid of the seatbelt for uncontrolled cgroup for the management
model.

But this is just because cgroup mem is also charged globally
to TCP, which should not be.


>
> I hate to say this, but can't you carry this out of tree until the
> transition is complete?
>
> I just don't think it makes any sense to have this as a permanent
> fixture in a general-purpose container management interface.

I understand that, and we should eventually fix "1) or 2)" to
just 3), but introducing this change without a knob will break
assumptions in userspace and trigger regression.

cgroup v2 is now widely enabled by major distro, and systemd
creates many processes under non-root cgroups but without
memory limits.

If we had no knob, such processes would suddenly lose the
tcp_mem[] seatbelt and could consume memory up to system
limit.

How about adding the knob's deprecation plan by pr_warn_once()
or something and letting users configure the max properly by
that ?

