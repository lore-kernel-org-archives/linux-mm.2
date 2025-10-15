Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7094ECCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6BEC8E0088; Wed, 15 Oct 2025 14:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43208E000C; Wed, 15 Oct 2025 14:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B801C8E0088; Wed, 15 Oct 2025 14:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A74108E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:58:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58F40119281
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:58:40 +0000 (UTC)
X-FDA: 84001260000.25.0DE1466
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 61A6B160012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:58:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uFhQrWoc;
	spf=pass (imf08.hostedemail.com: domain of kuniyu@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554718; a=rsa-sha256;
	cv=none;
	b=fg0OQMqWQyTdcs6I9/AIMZEz0dmv/oob3Icn5BQ5McrGwhBFOM/rXSw5/TQ9bDuGvsa8Yq
	Tk8psE8WNUMNveff/uCcsH8abETG+4aKg/L0NfWNq2HTKyeWA6902I759Svu7Oqr1pD/8R
	4EUCwRXOo4DuMBLe5qWgysM5Z1VnZQE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uFhQrWoc;
	spf=pass (imf08.hostedemail.com: domain of kuniyu@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5wWPe5cNvLvLkG2x2JRUcg1UiLk0hyS1ikpUjlCASg=;
	b=7PHjUn80j8iJevNha2G8C/ZDTugndAOIhsj6SEaHq0NZgYv542xA+mfsclemmUSf01DWOu
	r2hqyneLc+8PpkajaATNDcrdePwHGgo54jW2vho12Z8zARMe0so3JYsSh0C8nsd6L3I89d
	HTDxANXnCOg5Tw9A2ErXVCDFSfh8ZsI=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so11026746a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554717; x=1761159517; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5wWPe5cNvLvLkG2x2JRUcg1UiLk0hyS1ikpUjlCASg=;
        b=uFhQrWocmPVx0STsefAvNGyMnAVmmZZuTLp7T351dZ3oGwqE2W7zdt5V5M1VkaME9d
         zvLxwtTNjV5H707uzKzFDwYu8gcOtSqp8hD3dCAUuAQfKlQtaFwn/65RvG9qVNLu68Hl
         tcPsvb+6DN4ROyxj9j6qbJznO3cI03eR+Lr1I9ZdKST6Q2FZQaQg5ZYXlEd9kwrD0EIM
         XkULUlNtqjQJJfDjI75uzH/XcOF0HkeVNBqdScR2MU7kxPI2W/qgi0ziNBP904GN/LAS
         OUHwl4XnOTGmnX5poB/KlsUJNOf1a3kcAXqN8E7Wbx3/9HdbF5BfcqmDNWa7U7W7YnzA
         rLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554717; x=1761159517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5wWPe5cNvLvLkG2x2JRUcg1UiLk0hyS1ikpUjlCASg=;
        b=qEaD2mNtNFOxu56lwqMUkP75AnA/W699N2pKcVs29CvK7OxmUPGH8TIJRJKg81Mkeq
         9QmKiGb+hJ2HkY7kbinuux28v84m6iYETza/90XWt4cSD4YCWNTHuZN3DljncLnu7YwS
         OMtEU1UT6iBeStrfHZIcxFK857FV+ZiEnYqbWcputMrdJIvpUr8sk2PqojOa1AfyiHqj
         8/dkpWnDh8KJ5hMKydZE+guH+bSSWSROtqn5810+lOZssdHhvauwbkYrcV29Kzj4EKKB
         4iRzHF7WXstxYFqlRtdORm2YlZM7UsMb1O0vOZOg8Zl1mAFk+9oFhVc1H4WcaMiNwXmz
         ecvA==
X-Forwarded-Encrypted: i=1; AJvYcCWyKoC+kpsf+/HnyN2sW/xlCX9pgoRknC9jXlRmAOPS/cEYu0MT3qUpUbalLPBeZAnDPlyo2JMIEA==@kvack.org
X-Gm-Message-State: AOJu0YzGVwV2bHiiL5/XWbM5HrZv+pLgOK97WH7/38B7htQfCcV9GILZ
	8CEKNydMu1TvDK8s5K44JTtsxPdYLOMvPgfN9ywyhCdQCrnaLijz0WF0CSoPApjgGRo7QEG2Cyp
	if3cWdBInCxnXqXPIB33BskMAsblHrFJSLYhDR56u
X-Gm-Gg: ASbGncs035rabsargEXG8pphh22sY9DG9819GBI1JJ/pd0urufC4FcjnnGvollTJ+f7
	UkHvH+4uGBfUVoWJq5488m3C//EMB6kd8c7giAaRrJwHUi4AiCkkC77wc7UGeaTAPDg2KX023CQ
	zNl8b77CwtiUhJjn/ny7MGd5p5QacNlVzbNjSVyBHU0718ppgVLjdbkFmAk6Om+0VZNZTnNl6Eu
	rZnaeg2coN+rCNIo4E/KyfTM8xFDDZ1bAMyAlnuZPnmidQeD5ex0dtoK/XF1Rc46/aB2jfF7g==
X-Google-Smtp-Source: AGHT+IFXcR4/a/uWu2/COMG2rM2MXmYSeyVnHJVJ071uBYQhdmJ2s12d0Sglrmv8RLNynXPyIpu3cpFeni0ANJye8G0=
X-Received: by 2002:aa7:df92:0:b0:637:d2d6:dddd with SMTP id
 4fb4d7f45d1cf-639d5c6f393mr19995045a12.36.1760554716460; Wed, 15 Oct 2025
 11:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <87qzvdqkyh.fsf@linux.dev> <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev> <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev> <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
 <875xcn526v.fsf@linux.dev> <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
 <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
 <CAAVpQUDWKaB6jH3Ouyx35z5eUb9GKfgHS0H7ngcPEFeBdtPjRw@mail.gmail.com> <cfoc35cqn7sa63w6kufwvq7rs6s7xiivfbmr752h4rmur4demz@d7joq6oho6qc>
In-Reply-To: <cfoc35cqn7sa63w6kufwvq7rs6s7xiivfbmr752h4rmur4demz@d7joq6oho6qc>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 15 Oct 2025 11:58:23 -0700
X-Gm-Features: AS18NWCCDR5AqbojOF4FmdytvEGOhlifSaI5ISfKVV9sd4073qOpkYTl1jQCD34
Message-ID: <CAAVpQUCNV96vOReAeVHpwbUg9XJDLRTkHmcABh9dhm=f8p5O+g@mail.gmail.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: u466daas3ms14qyitkg54c6i384xuqot
X-Rspamd-Queue-Id: 61A6B160012
X-Rspamd-Server: rspam09
X-HE-Tag: 1760554718-212351
X-HE-Meta: U2FsdGVkX1/Md4CUYk954NVnxJa/SsxGWj9FgAoibAL+BkDGzcrt5+d4VCpchKsziuclqEAvjGoJ1jRuv7eGrWcPlKd4mrFceGsjOEPx3kqdFLjJtht39YXotd/STNtRYvQd5dl2k27ohxKsj5AcHC6z9BSg7plMREQDWhE0QJmDg5m4WGDyX0uVEOKHlkHL0fQI59YvpPl1xpVSPdaPhue8FhdZjshm/fAQ5+eVuoCjakeiNkiawPrJryzHWYdlSC4idoGs/thcoz/nR9fC637gylm0Qmaplv/ZbTRbaovg7PzUytZiFi0CBgShG4nsUE4f5IDaMpfM5+RANvKnhEdxI5E5wIsdCe0EgpyPr8a/g/9UohA1fNO++Wqt5PiXPC/bD0KaMrqYaaLsI9HlU6W1W4BJolYqUUSs/6nQHWm+z0KnVqBjJ7PQDr2ihGcrDW1ihiRyr4yddFkdVP5BNdTbUsdJRYA3rS4RzdZeNPOsDxyjNsNxJU8mKwSoQCeT6+8TO1L7S+V+esJ56ZyiygaDQlRlSpyJHFMkz7iHHaAtlmVvc3dziaWTqOkb8jMc/3ejBi1nRshxscK65HKrfcBxTi+Nw44ZQBD01EPvXiTceGXNeiNSwIQBOxB3J4qobTz29vv80W6ffuDKewvnL7EHP4UhVQOfVdNQnBZVlIBZQ1uyZoKGukpvdueglhX8Je6EGn6b8mkr6//mLpFDZwkgTT5isOqAfoXhfsCKN6EcrOtf+GyBtQ4WqBMMe+yXbwclLEsuYwOWWGEjOAuo/LRnPF5EipBI9kH1ZnBs5qDhj7X4V6Tgg1fHfx1nxh57wAcf6jTvzf3w1t7K1H7bqbsL2SHc6dz1udKttCwmA39s1BevUmrDPFvkH3Z29Wf6OYSS/dKav8al5tHA6ARaelQiRv7zt3uwJvIl57va4F/ylHOBLQr9IGplJ6yT+bMVCKWnSR/veoq4EUnYuVd
 /irb3paD
 4kP5HJkflXSQxvMgNpdNFU1/QuOw9uMrYK5F4xLD5YoMqG5ZMTeMeSDBfo93ZRk1pdcrOhGBYmEgkeEeEnpVbc9loEWQaebH/caYaBv+u8VMLLjvH8O1sUy4nqiu5Bi1mWTU0AeM9chNMiioi4NIqYeePLtWJhLxTHjjuasbISPjfWVj+i+cI80splfV1P6LVNcow
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:39=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Wed, Oct 15, 2025 at 11:21:17AM -0700, Kuniyuki Iwashima wrote:
> > On Tue, Oct 14, 2025 at 1:33=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Mon, Oct 13, 2025 at 04:30:53PM +0200, Daniel Sedlak wrote:
> > > [...]
> > > > > > > > How about we track the actions taken by the callers of
> > > > > > > > mem_cgroup_sk_under_memory_pressure()? Basically if network=
 stack
> > > > > > > > reduces the buffer size or whatever the other actions it ma=
y take when
> > > > > > > > mem_cgroup_sk_under_memory_pressure() returns, tracking tho=
se actions
> > > > > > > > is what I think is needed here, at least for the debugging =
use-case.
> > > >
> > > > I am not against it, but I feel that conveying those tracked action=
s (or how
> > > > to represent them) to the user will be much harder. Are there alrea=
dy
> > > > existing APIs to push this information to the user?
> > > >
> > >
> > > I discussed with Wei Wang and she suggested we should start tracking =
the
> > > calls to tcp_adjust_rcv_ssthresh() first. So, something like the
> > > following. I would like feedback frm networking folks as well:
> >
> > I think we could simply put memcg_memory_event() in
> > mem_cgroup_sk_under_memory_pressure() when it returns
> > true.
> >
> > Other than tcp_adjust_rcv_ssthresh(), if tcp_under_memory_pressure()
> > returns true, it indicates something bad will happen, failure to expand
> > rcvbuf and sndbuf, need to prune out-of-order queue more aggressively,
> > FIN deferred to a retransmitted packet.
> >
> > Also, we could cover mptcp and sctp too.
> >
>
> I wanted to start simple and focus on one specific action but I am open
> to other actins as well. Do we want a generic network throttled metric
> or do we want different metric for different action? At the moment I
> think for memcg, a single metric would be sufficient and then we can
> have tracepoints for more fine grained debugging.

I agree that a single metric would be enough if it can signal
something bad is happening as a first step, then we can take
further action with tracepoint, bpftrace, whatever.

