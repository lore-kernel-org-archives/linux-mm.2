Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33988CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 17:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735638E004A; Wed,  8 Oct 2025 13:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695EA8E0002; Wed,  8 Oct 2025 13:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E5D8E004A; Wed,  8 Oct 2025 13:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3ADE98E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:02:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9C46C0694
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:02:44 +0000 (UTC)
X-FDA: 83975566248.28.A83CD12
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id A009CC0010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:02:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ImEtogTh;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759942963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BODKjR/Yrua4uagxV7JAKQu5Y6484FclXcvnVtP0Ids=;
	b=bWYCCPRHvOddmd+BOY0kiWDte4F1964K/A5bVsofjP9CB80g3rXXUEZ1WZ6Ub+oGj8pIhH
	aRtZ3o4rdk9WUaw1edNh+3Je2vmVgjwa+qZ++cRkf4TMeh3rXHw5KSl0aI6CLI44WLDFp4
	yRF7la1CoYzdhrHOvgue5rpFL+2Eotg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ImEtogTh;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759942963; a=rsa-sha256;
	cv=none;
	b=TMdCXP9HibmQXnqOmXPSmDc5lWLoXQsCKQ4ap6SKsDUEshXo4TjfskD9hY7cUjj4a3Joym
	5jleNkGd4G91g+g0Ob+42TlaOL0D7pAe+Sh+QQOwa30FpKRC4Lcbbmwlh7vhFJpjUjj9GU
	cufgRumdepiT7haDHstFJfDOyd+BLmE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759942960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BODKjR/Yrua4uagxV7JAKQu5Y6484FclXcvnVtP0Ids=;
	b=ImEtogTh0Qu0BQbbsIQhE3xhi2kpV56iAk7nUKH+E+BrfzLTe1IFnAs1u2nKXZ4WwXK+rP
	N4Qk9gMKmXy+ZNj+q5FZFsQxoYmLp0idznsWNAYeTnVwQAUsZ+z4suI0RtYA3ZrCJZnGqD
	4lTBro4kASUXODnrVr2/PzmbAiart0s=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Song Liu <liu.song.linuxdev@gmail.com>
Cc: Song Liu <song@kernel.org>,  Andrii Nakryiko
 <andrii.nakryiko@gmail.com>,  Martin KaFai Lau <martin.lau@linux.dev>,
  Alexei Starovoitov <alexei.starovoitov@gmail.com>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  linux-mm <linux-mm@kvack.org>,  bpf
 <bpf@vger.kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Alexei Starovoitov <ast@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <CAHzjS_tq34QC4NDQd_L8crQii2QZCxZr28ywSw=gMnFnqD_z2A@mail.gmail.com>
	(Song Liu's message of "Wed, 8 Oct 2025 00:03:37 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
	<87wm6rwd4d.fsf@linux.dev>
	<ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
	<CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
	<87iki0n4lm.fsf@linux.dev>
	<a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
	<877bxb77eh.fsf@linux.dev>
	<CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
	<871pnfk2px.fsf@linux.dev>
	<CAEf4BzaVvNwt18eqVpigKh8Ftm=KfO_EsB2Hoh+LQCDLsWxRwg@mail.gmail.com>
	<87tt0bfsq7.fsf@linux.dev>
	<CAHzjS_v+N7UO-yEt-d0w3nE5_Y1LExQ5hFWYnHqARp9L-5P_cg@mail.gmail.com>
	<87playf8ab.fsf@linux.dev>
	<CAHzjS_tq34QC4NDQd_L8crQii2QZCxZr28ywSw=gMnFnqD_z2A@mail.gmail.com>
Date: Wed, 08 Oct 2025 10:02:28 -0700
Message-ID: <871pnd2uor.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A009CC0010
X-Stat-Signature: s8x7osyw9boa1kdporcjd9thte9ekb5c
X-Rspam-User: 
X-HE-Tag: 1759942962-385155
X-HE-Meta: U2FsdGVkX19KghSCbBOu8q7Ebvl2lCiMS7li6TSXMZWp9RgVwCUQz9WRkwhqQg3EXdsY37MvgOv9wYtkIZrh3fjEXNabQ8bEMb/NIYBtCOflxhZ0poVsp1EbkGpjT0CLNe6xXQMSw6+vyF4JtZ1GuF4cGQWvZ5WhZB6XohR1J3vwfJlv7yCIbd2YtvZLquKobeApZNOoN5QAx3MWNF4DWgUxrhLjsmdL/QwSYjklM2QgPTRTLV5iyDLye9wvYqv0k/jHIxmX4XlcKprUabNeJZ/RFkGqagRR0AkxfJrcYyZ1q+npekt4KczVPjVLCKQXGk2nKaAKKXSFHHsqU3gooaW0AATHEjpZXkI+evjHSNRiFs1g4M9ZlT74+BWbRy0YlIXSO7ZkX0bH4grUx0whdd1D8pnu2fcGDPuKEbB3BuZcthyxTjv7m2d0VYGSSLp6PfW3klggFlymBTdy6RS9sbYXASZHSTJhmCZFWDvO4CZOO8SPDzQKv8s5SvsAM84YHjHOTgOeaHuI3Cbed5lMnHydpzRCnCHvhW1WYbY994/MroqAk8pSLqZJHJN8kSnv0PCN0JELNHiGnu7gtGVDQ44vvKETzKG1HVVeURlF5JWaQ1UPN4aXyp1rJvS8t0LP9D5DfqnV/WjEvhtHnIo1vBLUM5FQBavXQJWItBn8OjBsIgERc9p7mLBQxyOLD9yJeG9QGZUiKunDfRuOQf9Q3J/Y5uKerIq5L7Ffff5ceunsQgRkoZfjKBqbIC+TZAeJYQqPfX+EOgvtmjViqmSoS23Yy9MIwZ9WmHWZw7Gt2jB8ATrc7HoNKBZ4k8rUJchQDODadXwBFo31gcreHDM/6f6IH3beA3HPHz2vZCxNierdnrkvn7THaracWTh2sf6SGnJ088l/X5mhhsJhJaRGudY51f+hpnClrU+vI1qWeoZX5uBb36OExzfTrvMkylywS0SGyjwTcPSF8VJZ6ZH
 Ftb6Cosa
 3bAIah9i7OKvoJWbQkRhe+RmkVx103k1HJ3/QjBuN/pvGS80y0iUBlBEFxY29MklXNqnHw9Z3DA4LNTgCxE8afxJLuOq6ybOfFQNr3UfgVAgLsxAuKT8sZO/nXw6P8lVlwnr7TcxrhqWjsME8AbThp6VwRY7/D49kXIdz7vVpib5Rs94PgFER5Fd3r/+0aUn1NfgjBXW1fx6s7xBMTxqcEO9oURKKv8RGh0hXYCGWG/9Yhm8JK/jSm1R+cuWqhqgOKer2sDuAcTkFj7YeflG95ujMCutcBXTn3hXDjx/6jVd7o+c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Song Liu <liu.song.linuxdev@gmail.com> writes:

> On Tue, Oct 7, 2025 at 7:15=E2=80=AFPM Roman Gushchin <roman.gushchin@lin=
ux.dev> wrote:
> [...]
>> >
>> > I am not sure what is the best option for cgroup oom killer. There
>> > are multiple options. Technically, it can even be a sysfs entry.
>> > We can use it as:
>> >
>> > # load and pin oom killers first
>> > $ cat /sys/fs/cgroup/user.slice/oom.killer
>> > [oom_a] oom_b oom_c
>> > $ echo oom_b > /sys/fs/cgroup/user.slice/oom.killer
>> > $ cat /sys/fs/cgroup/user.slice/oom.killer
>> > oom_a [oom_b] oom_c
>>
>> It actually looks nice!
>> But I expect that most users of bpf_oom won't use it directly,
>> but through some sort of middleware (e.g. systemd), so Idk if
>> such a user-oriented interface makes a lot of sense.
>>
>> > Note that, I am not proposing to use sysfs entries for oom killer.
>> > I just want to say it is an option.
>> >
>> > Given attach() can be implemented in different ways, we probably
>> > don't need to add it to bpf_struct_ops. But if that turns out to be
>> > the best option, I would not argue against it. OTOH, I think it is
>> > better to keep reg() and attach() separate, though sched_ext is
>> > using reg() for both options.
>>
>> I'm inclining towards a similar approach, except that I don't want
>> to embed cgroup_id into the struct_ops, but keep it in the link,
>> as Martin suggested. But I need to implement it end-to-end before I can
>> be sure that it's the best option. Working on it...
>
> If we add cgroup_id to the link, I guess this means we need the link
> (some fd in user space) to hold reference on the attachment of this
> oom struct_ops on this is cgroup. Do we also need this link to hold
> a reference on the cgroup?

Not necessarily. I agree that the struct_ops should not hold a reference
to the cgroup, it's better to do the opposite.
This is why the link can have cgroup_id, not cgroup pointer.
I think it's similar to Tejun's approach to embed cgroup_id into the
struct ops, but potentially more flexible.

Thanks!

