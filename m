Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48BE1CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 07:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F978E0008; Wed,  8 Oct 2025 03:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657818E0002; Wed,  8 Oct 2025 03:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D068E0008; Wed,  8 Oct 2025 03:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 461BD8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:03:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB8CC1A03D7
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:03:50 +0000 (UTC)
X-FDA: 83974057020.20.F8B97C0
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A59212000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:03:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JyPxH4ze;
	spf=pass (imf29.hostedemail.com: domain of liu.song.linuxdev@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=liu.song.linuxdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759907029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIBontMI3JXOfH0koR9RkZgD7vrZZLov/LpVr4jsmxQ=;
	b=yJCnpLwNvzI644igMbyU3YEA0uaffVaCct/nrK8vAf5Z+kT5FLekRbCUuQ11zpUcVzfrCY
	9bG/HcVeKvJ8BuqbZKfuQDWtWHz0BfMIqDxvj8iT9yEygZEYFQnfTs1PeKz2dtX0AYUY/F
	JFFDdY94YUlmW1G2hbe3YRyUyhAIBcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759907029; a=rsa-sha256;
	cv=none;
	b=WWf5c3Nqh6bBHhy5hnz9Ah3y0YbIaQfnFG+y6wtOlFnVt7G0m64wQW6J0icsuw1rfYisYQ
	z4dfawoAgR/UHu9yd/JvWfYNjI9y8Q0PvCTBjD7EUDahuP62p1Sxx2oi5uB/77oEVTUc7z
	X7SoY8ZrXXogkdF679Qdws154p08Hzc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JyPxH4ze;
	spf=pass (imf29.hostedemail.com: domain of liu.song.linuxdev@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=liu.song.linuxdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-78eba712e89so66621846d6.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 00:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759907028; x=1760511828; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIBontMI3JXOfH0koR9RkZgD7vrZZLov/LpVr4jsmxQ=;
        b=JyPxH4zeeJZM9OGxk+J7wctcXsypaPG7Ns9frF+LmHa4jvOw19QZ+CCRb9r0IO0WAr
         RDVK/0yS1m6Sv0KmnPeIaub4us77Qn0wrMlXjDV/bByjxZa4EriYqvAtH3kpiPjZjgeB
         Zj0tvJyDs7FTaqMiRv8AobLpdSUa9WsWLpobMKf/YFqavBhN56L1v7zvbU4neEroeAsO
         pCQCkBAmi1/okBZy8yy6JyoMJ/XQeSfE2aVfX2uI0xo6NLEFVYsAdosktOQerHbPQlVe
         GAP54kyXKTWVPbDBzDZ69ZBimQ0Ok4E5YUy1/f8WIAGi5H1PtpW95WmcQOndHDE0PodP
         +1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759907028; x=1760511828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZIBontMI3JXOfH0koR9RkZgD7vrZZLov/LpVr4jsmxQ=;
        b=XuuLQbBQoGsFJJnGiZ9syzaeLltSQRD/nRjIfgpagBNp45x7ithYigXK5vPtHUQg8g
         rt//nONY0Yf2hYK0Y7D/FSBsslIuMWrO0pYQ34K9FfyFA2bHk/J7D66AoUlNAILtfxzf
         XPf6dpLipBIvqWX+bTts+1rVgLDjisD6Bmnmra/HftYrRvv9mXcsfdi7J8c3Zx4X1vcg
         xgg68C5Byq+r3DC363ISEr4SVuIjulAGidYrl8rXzcEPR5qOaa14RTR4z/JlQR6zgC7k
         +zt3DcZVCtjKw+DGqYD2JeZAgq+c2N5/J4YvTbvDLTOlLhuShMBU7/114+296WlbJB2I
         LY0w==
X-Forwarded-Encrypted: i=1; AJvYcCU+DU57ntbXKBe0x9Q6hT1XIPDPEoEwxk8VAA+TPLwkjXNrCwJTXirUD0NnsPtN10LT5x599Dl/Nw==@kvack.org
X-Gm-Message-State: AOJu0YyBJ+8IQqMBwZmI0IRD3rjMK8n+ucl307lu2vRImmhs0ulZKMjO
	JAqBYjmgcxr9W4l8zHZAgt0atbRStblMeod6NeRfki5ZLO5aSTIADCcqhqBK/HWWTyC4vc/QFQK
	6GpTuIGCHXO3FnjtckjwyBzY0uXWgmhk=
X-Gm-Gg: ASbGncvz6l6vYAejYD7AeGvgKJGaiWqo7VBkaOV2pv2XP9CDSBXYMOFgs1eMG258kGn
	aetqurvuV/S09LKSGgsNxinneLFgKxZWT6ovQoho/JAhUokx1gIU+drJPXaFUh+tWbFZ1IKG7/C
	u3fdEFMi6j7CrYZJV+P+CsqKjd9OWtYrwZe7dAp0NnxqfXeNfwhq0QXOQY5K7bNR+Uvf7PTB3RR
	XP7H63Q2AyJR4rolHUuLVH4TWSzQrwL
X-Google-Smtp-Source: AGHT+IHedmjtfrfQZ6kW8QKuwAdECr6I1hiXfVOXlZcxsFN061YcDFnfXfAPwRPbs6K5+eMFaH0JseZMD/Jr2viOYaM=
X-Received: by 2002:a05:6214:5199:b0:720:3cd9:1f7e with SMTP id
 6a1803df08f44-87b1bb42849mr30308086d6.0.1759907027966; Wed, 08 Oct 2025
 00:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev> <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
 <877bxb77eh.fsf@linux.dev> <CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
 <871pnfk2px.fsf@linux.dev> <CAEf4BzaVvNwt18eqVpigKh8Ftm=KfO_EsB2Hoh+LQCDLsWxRwg@mail.gmail.com>
 <87tt0bfsq7.fsf@linux.dev> <CAHzjS_v+N7UO-yEt-d0w3nE5_Y1LExQ5hFWYnHqARp9L-5P_cg@mail.gmail.com>
 <87playf8ab.fsf@linux.dev>
In-Reply-To: <87playf8ab.fsf@linux.dev>
From: Song Liu <liu.song.linuxdev@gmail.com>
Date: Wed, 8 Oct 2025 00:03:37 -0700
X-Gm-Features: AS18NWAyjZKWTXeQJNB3PaOT3WzsTXBdhqC-Rkcj8nywQj_gcgCbw3kGbTWlhpA
Message-ID: <CAHzjS_tq34QC4NDQd_L8crQii2QZCxZr28ywSw=gMnFnqD_z2A@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Song Liu <song@kernel.org>, Andrii Nakryiko <andrii.nakryiko@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: r96xwc1mnnsotihwox6rkx8pzgnzm74u
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A59212000A
X-HE-Tag: 1759907028-169690
X-HE-Meta: U2FsdGVkX19tjV4K79zxfRlb4ey82NY679u+C9eYkPoTh/TtordTAzYHNWZSSBrr5zFU4rtgVVIbIVSUpJjeB+RSfQwLqSRrBeH/pI0x1oZ50eux3/C1eootC/sLX/oH6jiUS9uWIK20OVvnUzjnfP6fWJkVIW2FTv0b+Z5770j5oYwI7kPzKC8FRXIdxt0Y5X+j8MBoyFO5zTdE/fWm8sEGU07Zs3SLtVVnL5W3tWRy5T0WNWUK9arbe4585dH5Z85jPnPxyaIsmsj3VfHUFK0KhIAh+w5PZZuap9KMvU2FLz+E5K0YSAFdT3rFQJ3g/H1hPCfexWIArL8BTgrieTQeqxNxEw1kJFQbMCs2Awd8AIMc5jCXFmsikcLRsbazXmErx9xeZtU0YyHB3RcFQKUxHsC+Q+HRjvXKAGB4xRVTAOiRkXT6pwRjUwR4p9nm3mOIEYIR+SlxwFViU0xrJstWVkYyJLjwk3xGfmJBNISQ6+rAgfooxmLKMx0Czhh/E5oUPo0sFAcnflCQDvs1utJUOu9pUVDhLQDuDw0LTPasnoLn5Fv7s43XpiENbWMyplVih6n7Q79ZYxrHfRcos4GJ2byb7DlQmcdoGQmE60efE3Y8IY+2cj8EUgWOFdbylicOhw0KsOtEE16jB0aGwOE0MSf+ATHUIBVSdiCDMGgxMrG18tlaIJL6yCYThGzVep3A5g1qFdb6LY9wQ8R1wh2qDjCqyJVi/94Fh3r2r3C3erQbFyqK5olGBfrQsgDGK+iVkv5AfRr83+ifrcpRY1g1zCcXuo5rAcX2GQRTopfLqwd5RMLptJRn2msypHISPaHzmwO7JMf3QXMbWYPrzq1gkJDpbUlb7a55TKAuARSkn+lhP0BfB+YSlPsMLb2tnU/qVvf6hm+tGXnbupHvovaEGuYR0m+d1Xy6U04ADokfjUH1SRUJKY1x1rvF0O5xViNIlNdw7AFrXH3NUJ6
 6166xY/q
 3cneg5PcXshX7zcOHCjHGArqxhjVn91IYhuU/xcdTpsSq4u6ie+9LDnId2tvaMFEuZDYSOuzMQJ/S2em22OhV6KTzSFNKLNEXjyWwvAXY4JWQFTyt0qyAyslMzrU5rZdA8uKunEQ2UiO2Qfg3HBq94yh25n/4dwSdzwPz8eiSqo+X8TWjIQy6YTRRtrgfNuM6MpmhScbAsCl2HqQeFGXUbegzC8jme2w9UnskdFgtWfQWvGhwhDJi+w0NGJ6n5HvTsEVM4hyi2t2h6YslDTBjdPzW1AbzzFBSx1A8ew4QlpepUYroDY8qDs4bFcFmcNkpNOeskXrPhtFpNKRETpkXfUvoQYa8J7kfzz/3ed33yt8KqiKiTw20WHV6wVqZgsVkIZFW6O2qwMhZTf/4uOJNqZbIyt7hGGTkHWH1gR6s3R3W8GGzmiRhxkZaUPEKaBpiMsDt2AOthdqtxYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 7:15=E2=80=AFPM Roman Gushchin <roman.gushchin@linux=
.dev> wrote:
[...]
> >
> > I am not sure what is the best option for cgroup oom killer. There
> > are multiple options. Technically, it can even be a sysfs entry.
> > We can use it as:
> >
> > # load and pin oom killers first
> > $ cat /sys/fs/cgroup/user.slice/oom.killer
> > [oom_a] oom_b oom_c
> > $ echo oom_b > /sys/fs/cgroup/user.slice/oom.killer
> > $ cat /sys/fs/cgroup/user.slice/oom.killer
> > oom_a [oom_b] oom_c
>
> It actually looks nice!
> But I expect that most users of bpf_oom won't use it directly,
> but through some sort of middleware (e.g. systemd), so Idk if
> such a user-oriented interface makes a lot of sense.
>
> > Note that, I am not proposing to use sysfs entries for oom killer.
> > I just want to say it is an option.
> >
> > Given attach() can be implemented in different ways, we probably
> > don't need to add it to bpf_struct_ops. But if that turns out to be
> > the best option, I would not argue against it. OTOH, I think it is
> > better to keep reg() and attach() separate, though sched_ext is
> > using reg() for both options.
>
> I'm inclining towards a similar approach, except that I don't want
> to embed cgroup_id into the struct_ops, but keep it in the link,
> as Martin suggested. But I need to implement it end-to-end before I can
> be sure that it's the best option. Working on it...

If we add cgroup_id to the link, I guess this means we need the link
(some fd in user space) to hold reference on the attachment of this
oom struct_ops on this is cgroup. Do we also need this link to hold
a reference on the cgroup?

Alternatively, we can have the cgroup hold a reference to this
struct_ops. This way, we don't need a link to hold reference to the
struct_ops. I think this might be a cleaner design.

Just an idea. If this doesn't make sense, we can revisit this with
the code.

Thanks,
Song

