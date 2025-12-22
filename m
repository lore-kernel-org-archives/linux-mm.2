Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E4BD68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827466B0098; Sun, 21 Dec 2025 19:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB776B009B; Sun, 21 Dec 2025 19:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B73D6B009D; Sun, 21 Dec 2025 19:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57F196B0098
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:52:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 158D98B8A4
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:52:10 +0000 (UTC)
X-FDA: 84245280420.25.B1E1A23
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2AF9F4000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:52:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dSw3MCn4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766364728; a=rsa-sha256;
	cv=none;
	b=3jdZXYIHGQHvntbS87Gf/TtUxb4dwI1KCkP6Camp17XkXGQLQnj1mx49qgo+8ZwGTIrZyI
	QS2LtRYLeeCOcHflyUdZids7zTtUaaRdzd9S1SBx8oaDXg9OgL9dEjLGpo8RYo7Aw/ekRa
	9YhRoFtleOKWG39o3HvadRqSC8AKKbQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dSw3MCn4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766364728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sgxw54yt9GSPY/wJxGqE9fcBAoHDCIdYJf5fPQafeGk=;
	b=zsEfgP5OX04Xp8srL4HBVgj2Fz6WDaUG7cTz7/roF1fYVuqK8b7CSKJrt4TTHvMb0/Ct1l
	nJht+18q794p7Y4FoW3HfgTG5G6OVDc5wqSkZdBJIoqffIeYszkyG7FYZBR8+rI/JmoYDs
	fcxiGdeSWkG0+GTvYNaUs14DqMeyvQU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so19466505e9.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766364726; x=1766969526; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sgxw54yt9GSPY/wJxGqE9fcBAoHDCIdYJf5fPQafeGk=;
        b=dSw3MCn4AXaa16AYgDwkFtHQFOJy/ANPWpO5gYV9eiwCSF/rikwDx5cvSeugmOu6Wa
         bm89vLg8CURYrXPyEeP+CStrwqJilrGMMp2cE0YdpGjgFSeRhOpxWTt9uKdibKTqk4Bh
         CzKIGGEushCLzwsrFNuy/AfGCWMlHYsRqWjRxx7YFzoz/uDNpmCDByjCG+bzWskLadIg
         7+lkci5zvmIbOd8Adex0p2z7DtneXlNBjlwKrUWeFQILOlDlcwaK6mWTEr0DcAorzKYF
         D/Lt7BjahSwldAb9EGS/GWVbyO5pcdtidsDAvnaVvOLGwAQHy3tFyEMuTpFxl06S0OIU
         fM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766364726; x=1766969526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sgxw54yt9GSPY/wJxGqE9fcBAoHDCIdYJf5fPQafeGk=;
        b=A8TvEtrYhoMkoR+G4sKLIgm4fP5/Qh6ZySARQ4nyxYT/SxgKUS27KjtO5CLn/pp0b7
         2Loj0XeVI+8OUepH5e2TS8MOb1DUDKbxQhWCMXqc9mn4APs1yKF3ZIYWdkfkMqJUE4RT
         TDQkJnBYWS2maYOgfxjIfLUYjUvjqKRwdv31sS0ozuNR1tPqp8cYxjGd67aginu7MSHH
         YXT6HFqm38LigwJWk0+tz3cq5IS+NVB+uSpyfQS9req394ny0zr/kxlcQUd0LF7TEvaN
         WnQ4mpW3ypK6XqjALYIg/S+np7Zy0nU9EvUS6dnv503HaXOq2qTKv/Axq3MgWj5dmqsp
         gksw==
X-Forwarded-Encrypted: i=1; AJvYcCVO9SOOpZlqBCcf1f6+peeyl9UhcVb6x8taLXtD/tTo8ODFk7bCD687S7jrP5YYl3KKn4hdmqO23g==@kvack.org
X-Gm-Message-State: AOJu0YwYR7X0ud1BTWWosQ/ZzI6/5c5O8st5cYKXb/53ayfOhICUqFhQ
	w7lCWD1qRnJusWNZMH8P7dBWn7LEIE8vCJeK9QCSNOSDnVzjYIQKnpTZL081d85ruebsFJ6RjC2
	diSACy9T/AVjejP2l9wvbhzDxlsSeTP4=
X-Gm-Gg: AY/fxX5IHAkCgjoCDV3f2BU9CpNk3FtlkvkTMHqbxs0B0dgfKmeUA6PKKEwFD2FnV52
	HteDDb5A02YC/MzU/f6yvRpKqD14NgtN6BFlUXyRCpZf3v6LGkUVwN8VdN4lFes43ZeYKoJssjk
	YWyHwWjMPhUHPwSdOv+jGqryBj7rL4yxVDe1HGueF25GQB+2+DmOToc1Kav3EJzzFdi4st8zNbQ
	xE5rXrPxfmuBabvW0x6taHYH16wvcdzZ2YPwlN3NS858MVy/kXBqSUMUyekociHjJDHkOAKD/+M
	9assYOU=
X-Google-Smtp-Source: AGHT+IHA16aQRMS4Hem/AC74vdS4Ff7LKIP4VMbmo8FPVAYBL8Mw/QHeO5wccSM02ZpEMBGqze5bFexvMNsLQRlPNA4=
X-Received: by 2002:a5d:6b04:0:b0:432:586f:2ab9 with SMTP id
 ffacd0b85a97d-432586f2d34mr5077050f8f.5.1766364726514; Sun, 21 Dec 2025
 16:52:06 -0800 (PST)
MIME-Version: 1.0
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
 <20251220041250.372179-6-roman.gushchin@linux.dev> <CAADnVQJo3HspB9-_R5yWKWLdExDmFayDpNZ4JnoBpCw6aRNTrA@mail.gmail.com>
In-Reply-To: <CAADnVQJo3HspB9-_R5yWKWLdExDmFayDpNZ4JnoBpCw6aRNTrA@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 21 Dec 2025 16:51:55 -0800
X-Gm-Features: AQt7F2oaz8HCkylGYSDrvse4JsGkKsP4asJjXaU4aAhPWzWneVtyudJr_jhxED4
Message-ID: <CAADnVQLfrUxh6vLz4S0otPppHTNx6Dno_bfsTgt=67e=mKoeHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access memory events
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AF9F4000A
X-Stat-Signature: mu31bm35986dg1zxwukyt8phcu44a6kf
X-Rspam-User: 
X-HE-Tag: 1766364727-282478
X-HE-Meta: U2FsdGVkX1+7psW2mb1jzP21q8+tyMR6A5GLJFFpEnXx7mK16mrxMSykkSxc4Rz+FvF5fx5/Qx5hYsH5Q5Ia8FC4JJNSZox1vTn7nv/phW90zypGOV96VPgchMyCFO1hTvypjsx0m2EDoq5Q2efMSgI6PkoOYT9kn9H+r4EVXjJ9nR7oJdGIGbH97xORJlyz9msqz2/OtdP7OruZE0ycyu6l8eMkhKYw/LrYE0BFjP66zOTIoX+cqraw8hKxanzUuFFS7NGTADVZ+PRxByQlQChyXMUQ4+m/vH1sev4vHnnfAhCFmzZhLPdv9kDoNwOXfuUeZtI11B5ly+/4CWRsiMkdU3ppfVd23s1GbRt7D4eFWs3Iw8b7HY9vfC+JT61EZUNe5pY6ubgPNh+xAp7JLfFjT4c40HX/sTXg34KoJtFCC8kVwV9hir926ijcFgOcESc0cpMTytpIxTBnB5ucJ9BFyjAe0e2D4rURer7syAhMEc1UsZ0bhwzmKdLhJgkYJfOwEpxGRIban14IoBLXGggm5GKL3k402lGr41Cmh5jPufQdRCg3cOEZ1toXuxBpMCc17nvH85L10q/MAN6SSotoT4LIU9fuXEqv4vnP503FnbQ8Nbut0kRFdNDqsnHUWFu0vDsTpDPd6yIZNOJwqPH4JCf17vLbIv+SWUGBNDKdUrV90X4nSTSC60TDxpqCzfLdKnFJ1aVvEay1R5GO/1/B5Ustt8umKdznS36a8u5qjsfsH+/Pxo1J7V7+6YxElCqL7L8relmLMgbzJzPNRPj7PqyXLInAi4u/pxkWRMUaN/pneW/1NoeNuaqY2Y3Qk5JdcYJXaVngg3KCvg2MqIYo/3I2UnfQrx1vKvHiPImBSgQ66xVjLg5TGzNvj2ctUUcCdEACnCFrSFlbNNyz+WPMw3Yw4YEHMvv2vDjKOEmb5VTXCkFdRBIF4KVGBNTibNgu/+MvzUHthbHL1Oa
 /CL43v6T
 YSftMccSaV85bXMrg4NQSecUI5scRlHq4ooix3LHqM6asSa2XydHd8/kUi38GAr7I+9u2vJ9bfbfgngPZg/kiEvd4vw7+Hqp+OuY8DH6NKznJyfkVhGXFcOwRiAK+bWxcZUbbGX5cfn2YEG2XGqGp18pmggAbqG7Gc5btPdCdBWHI4PNW9RtgBZtFBh0tT4fRYzo95F3+/mPyrUqTGqWonMSLR7K/ug9uN/IuSM3VMVy36/8ArbhQxKe5Re3ZExemof81V41jdKhSzHM5zlOKJXMydjrSOQztSnEmY1+eW1o7svB8HLdY+EAGDNbVY2GLhOmm4RtcZvicCSpZMlx5E4Dpit3Cv4OH3515Vin4AzbuOdW9Tam4EYDfpx09zjQmrAEFty+JBsbaaa/02LodDAMbGnhiIxtKuUI4ANi9B7Y3z0RG5Q1DAngryPFq55Dege+RARW/+DioUeZ4gNeCIxLmRWa+OXWj2eMywG19ne17/7JuvXtdUjnW4bSX3SRDmX/StODGxtcNKgwnR7iOjC46hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 2:49=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 19, 2025 at 6:13=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
> >
> > From: JP Kobryn <inwardvessel@gmail.com>
> >
> > Introduce BPF kfunc to access memory events, e.g.:
> > MEMCG_LOW, MEMCG_MAX, MEMCG_OOM, MEMCG_OOM_KILL etc.
> >
> > Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  mm/bpf_memcontrol.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > index d84fe6f3ed43..858eb43766ce 100644
> > --- a/mm/bpf_memcontrol.c
> > +++ b/mm/bpf_memcontrol.c
> > @@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(str=
uct mem_cgroup *memcg)
> >         return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
> >  }
> >
> > +/**
> > + * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event va=
lue
> > + * @memcg: memory cgroup
> > + * @event: memory event id
> > + *
> > + * Returns current memory event count.
> > + */
> > +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgro=
up *memcg,
> > +                                               enum memcg_memory_event=
 event)
> > +{
> > +       if (event >=3D MEMCG_NR_MEMORY_EVENTS)
> > +               return (unsigned long)-1;
> > +
> > +       return atomic_long_read(&memcg->memory_events[event]);
> > +}
>
> Why is patch 5 not squashed with patch 4?
> I'd think placing bpf_mem_cgroup_memory_events()
> right next to bpf_mem_cgroup_vm_events() in the same patch
> will make the difference more clear.
> For non-mm people the names are very close and on the first glance
> it looks like a duplicate.

Also see a bunch of kdoc warnings flagged by CI.

