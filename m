Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC13CCA476
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 01:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD458E0005; Tue,  7 Oct 2025 21:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46DF38E0002; Tue,  7 Oct 2025 21:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C0B8E0005; Tue,  7 Oct 2025 21:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 205508E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:07:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABE4516037D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:07:20 +0000 (UTC)
X-FDA: 83973158640.15.34C465A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A09420007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:07:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YgN/V3wA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759885638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBCqyJMWlRsL+4LATvFpWbApDg0JJQI3CUv1g8acmHA=;
	b=K3LGr3MjL0HirVeP3bxx+H/vfDNXY1TNndN/+vIxlQAOe+MVGbvLteUm2b1fVLaQTt9cmk
	GFdYMGGyh4gBBJB/vHyvCRD+Jo2Ndi2AZwBABGqozLFd6BAdU7JAEjio0ywRPOWp1EApxY
	KQaS8F2RuL0rIt1Mr4VV+ff4cHNVf40=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YgN/V3wA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759885638; a=rsa-sha256;
	cv=none;
	b=ITWCTZgEe3BE2ELUh2h3G+dwIRxjkTYv/YOjmyrFfldYZAqnAp6uUgLlx9flXzx1WIc0lc
	PPfbjjbg5hzD5J8U68T1KleuOMxiph+6cRVhtoZYHVeuJURsf5OYcPLVoKFhjcsW0JnBHA
	7KHMS9Uu3GjJ94EOq0sjB8htlMJmgZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE8A4410A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E59CC4CEFE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759885637;
	bh=zBCqyJMWlRsL+4LATvFpWbApDg0JJQI3CUv1g8acmHA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YgN/V3wAL5l8gU911XAnxezLGZznwYAlmCRXe3Ovvevboxu0GX2EcRWaIensz5R+e
	 8z1dSIXKO7hq3F/pXbQryVb/AWs6jqG4Nik+dLdt5Sl7JtT/H9bM5g9RSIIu8CPZf2
	 Z0LhS1pRVa6E+PA3OMsh8A9GaLdMShsX4AtgRGQtmP2RFPnnT/EB+40FGp0CT5Fe7k
	 HxfE8hYtzbuQpIEBERPhdWRYGM53FARCPG+MhWzGWoX9QoyYCvq3W5YfVaZ4tnbZmK
	 e4zAkqe2ImVEIh+5gtHVYKSF1zi6C7DMKrpSkTH7jByb34vG4S5XcamUaJfS2olsfG
	 rtEN6VaSzLL5Q==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7f7835f4478so48021716d6.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 18:07:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCURPeSy1zai6Tz+cI0iavIrc2zO/YkQUQPHdbvb66kAxkaGkP27Nz8ZNDPaJCfxXCmYjYeQBpT/+Q==@kvack.org
X-Gm-Message-State: AOJu0Yx2CUAe8xsLp3ZzTNFIYf1SIVlvTHZikHDFUDHoSKsGCRkjP95Q
	ANvLqUpuHAJbsUKUrQshxFD/ITWU9gui4Bc3F5VzV30vOA1g5NXYkkAC+ZcSl//p5NLELv9OBtG
	rmtyRzyUS3t9SNh8FmeSovWTO9OsY2bw=
X-Google-Smtp-Source: AGHT+IEcmF6j99P7KkUpn2/4L6HaFID6zbkjSdls+iCzttgJ43409b0C4AVN/zVkcxiO3cU7SJ9+sGQsQOMolE5AhVI=
X-Received: by 2002:ad4:5c65:0:b0:786:2d5e:fdda with SMTP id
 6a1803df08f44-87b2101ec96mr26440866d6.18.1759885636562; Tue, 07 Oct 2025
 18:07:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev> <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
 <877bxb77eh.fsf@linux.dev> <CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
 <871pnfk2px.fsf@linux.dev> <CAEf4BzaVvNwt18eqVpigKh8Ftm=KfO_EsB2Hoh+LQCDLsWxRwg@mail.gmail.com>
 <87tt0bfsq7.fsf@linux.dev>
In-Reply-To: <87tt0bfsq7.fsf@linux.dev>
From: Song Liu <song@kernel.org>
Date: Tue, 7 Oct 2025 18:07:03 -0700
X-Gmail-Original-Message-ID: <CAHzjS_v+N7UO-yEt-d0w3nE5_Y1LExQ5hFWYnHqARp9L-5P_cg@mail.gmail.com>
X-Gm-Features: AS18NWAx-XMC-g3j9uutWYIZTxRO0r1IXmHmgo-2RkWcxjCjTc5QNe70onU4eO4
Message-ID: <CAHzjS_v+N7UO-yEt-d0w3nE5_Y1LExQ5hFWYnHqARp9L-5P_cg@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A09420007
X-Rspamd-Server: rspam03
X-Stat-Signature: pz6krk5pwockgw9s138yzxc7ahrjreaq
X-HE-Tag: 1759885638-94039
X-HE-Meta: U2FsdGVkX1+JE2HR80idz073kjJe47TG+zXlxP+Hm/GdFipf6k0Mxdn0mf+qZQXJCxzK3gRa4x0hW4KUsFAqHqfk5gZER/MhUWB97uVWFMLt34sYblKojGToTWGU4InKIaN6DSRrc1BYuXeWCXeTJI6sMrGNuIjtuBKdWX013Ar2twZGT0sqTEOsy/cjeZOaIQ/ZSAHjxO6AFAF3xeJVg7awLrgKSpieYStAalaGSEjwyUsQnTR6251uXTzu2XxmsoRQMokLr3iRgWdSqhmE9T912vF0IkXBQWVIA2SCSCR2dqQWQW46kOxCVvO7RgYHGimNviEtoCGQomBi0aA2QpKSzrMS9wuMSbTFIgk4iH1nl+YhiKlLHdW/MfTnnTQ4cjrj/wBSSA6ykjt6GvOrdjrAEQMGS7ZEF9tomjAI6QNjfSud0mdWvlfZuaz2d1OlmA+6li8Hf3962341LUAROJ66jrmj1ssixKS7Cb9gXKwChC9bo5SIpzGBWiWha4w5MB0Bj8Sp5PyNw6UyT5YdCRMf7MhbVrYzXek9S78BEUzzE6arpbNlPdkXFvJ8/Mik5s82qQjKwc1xtEVyLX+vaQ8z55bl6JQ+wgPuNciKsBuA5N/R+JaJRbktq2qVcRYXu62t3rZDphlSoWYmUkIN3A+uDAcVH+XboOrejThwTi6LjTEXFXI524f0Y6pQ5DUbptqr6B5KB9leKsHG+RRIr3TYtibui8Znqsn4In9Qa51qjBhT7HN5xQZ7Jh1UxWvbIOMefQ+u4bqoU2Au+zCErCEw8Y9yWSIlONHrMgfjqlZ9GTf6pj4b4kLPClko1SKPU7Anp+l0v0KE0tIh4QLs642h080RK4ZjTWbIiMaseD+dyQtRAOY1BIMzL6Nj0jYKKD7HZPP5gVdLaKX8kWt84PHhQtqzfC7jkZmz4rMEX2+NgXj9r6579CmHXug8Wtikv2wVejwAPj70XYF5BfC
 WYG35Y07
 u/kiTXVx0A5TEhbTR8KMrjyscjaIJxbYTmcYMvzq2iqtfdyT5i3KufOkcwZKw3LZfT3pTXF5KHpFO0fuBjOvPNtEa0E59tL1o8l3WhBEepjZuLLI1GUxYKQWNgtykGy+AtLwa9VsMs+RaidA8L3SLM6y48Wt9ipK2h+9Ig0zKrsXBkBQe6x9yCMqA3OUrm85uFfeeed7DXImuMCzFeDzDCDYBuEtmOK4sV9LE9o9sNZK6HcYXLIJHOCTEeJmzc1lEHV65lbuHRetS7ntLgQbNWrHxDs/m1Bzx2nb1QDiVWUxRfT5AKwLLVnSXibIcwIbiA8oTpfMAvYe+xeszqEEYlvR5zmqP6bXbB7v55VQHMJgUtKcErPvonNEZqXNlgR2805P1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 5:42=E2=80=AFPM Roman Gushchin <roman.gushchin@linux=
.dev> wrote:
[...]
> >> >
> >> > So, there cannot be bpf_link__attach_cgroup(), but there can be (at
> >> > least conceptually) bpf_map__attach_cgroup(), where map is struct_op=
s
> >> > map.
> >>
> >> I see...
> >> So basically when a struct ops map is created we have a fd and then
> >> we can attach it (theoretically multiple times) using BPF_LINK_CREATE.
> >
> > Yes, exactly. "theoretically" part is true right now because of how
> > things are wired up internally, but this must be fixable
>
> Ok, one more question: do you think it's better to alter the existing
> bpf_struct_ops.reg() callback and add the bpf_attr parameter
> or add the new .attach() callback?

IIUC, bpf_struct_ops_link is just for bpf_struct_ops.reg(). The
attach() operation can be separate, and it doesn't need to be
implemented in sys_bpf() syscall. BPF TCP congestion control
uses setsockopt() to do the attach(). Current sched_ext does
the attach as part of reg(). Tejun is proposing to use reg() for
sub scheduler [1]. In my earlier patch set for fanotify-bpf, I
was planning to use ioctl on the fanotify fd [2]. I think these
all work for the given use case.

I am not sure what is the best option for cgroup oom killer. There
are multiple options. Technically, it can even be a sysfs entry.
We can use it as:

# load and pin oom killers first
$ cat /sys/fs/cgroup/user.slice/oom.killer
[oom_a] oom_b oom_c
$ echo oom_b > /sys/fs/cgroup/user.slice/oom.killer
$ cat /sys/fs/cgroup/user.slice/oom.killer
oom_a [oom_b] oom_c

Note that, I am not proposing to use sysfs entries for oom killer.
I just want to say it is an option.

Given attach() can be implemented in different ways, we probably
don't need to add it to bpf_struct_ops. But if that turns out to be
the best option, I would not argue against it. OTOH, I think it is
better to keep reg() and attach() separate, though sched_ext is
using reg() for both options.

Does this make sense?

Thanks,
Song

[1] https://lore.kernel.org/bpf/20250920005931.2753828-1-tj@kernel.org/
[2] https://lore.kernel.org/bpf/20241114084345.1564165-1-song@kernel.org/

