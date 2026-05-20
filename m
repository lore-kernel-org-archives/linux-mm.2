Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF2BCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB4F6B0099; Wed, 20 May 2026 14:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2766B009B; Wed, 20 May 2026 14:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFF36B009D; Wed, 20 May 2026 14:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E59B6B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:19:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3ACAE160DB5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:34 +0000 (UTC)
X-FDA: 84788611068.07.2764FA8
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09316180008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Tvl5t76S;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779301172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oEEsZtW8Pf/6uUW2B3iJA42A2wM+bzMQaMvKLN416U=;
	b=7LDFngn6RtKMsQ3ekP/X6GqJ3nIpb1VA2xobntTR1fPErUMhTNGpWnDWL8jHlWmH0dPxuW
	Ce8gZYYRIbHEZspq/XyNhcq1BTeTp5zJsvzWcxFVrlMGdb6hCT35JaH1OTG0Sq1/s8y6dv
	sRYklJDmEWjNUUopi4Rv3lKu3UxFpYM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Tvl5t76S;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779301172; a=rsa-sha256;
	cv=none;
	b=1o5cr+MejbosOjLVNpV2RdaTWk4LosRRhZxDG9cjtpF29hHlXd2nrn4gRIcoybrCkS/7Sm
	qWajxLPU93xebagWbhtnuh17nb5XP/ZFwwOVoIz0+5eJBSjzh+fzkvx0kj7DlAlOAehMwh
	UCdsjNqg8xX2As3KnzFFo2HFgJA6STs=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6870a365c77so2815361a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1779301170; x=1779905970; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6oEEsZtW8Pf/6uUW2B3iJA42A2wM+bzMQaMvKLN416U=;
        b=Tvl5t76Smzb3QksVwLaEWevbZJdCAsKcrkFT17yPSIxzEOCgo2iOllxEraPKBF339Z
         uvog0jdTziOGqfgPSUmEWP9k6IMd4bIYGiT8XJl/5mC9kJBD6ABCJxRjgSkihV5gYSmw
         3UchpZ/nYB65hbw7BZZghu23ToYzVge+gJqmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779301170; x=1779905970;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oEEsZtW8Pf/6uUW2B3iJA42A2wM+bzMQaMvKLN416U=;
        b=Tl7e+F8rFyF6BkxhkCN+c3vcAf+vpUxfWzFgKB0OyYu6mA6JxxQ8+JYy2pkILkg9Yq
         SEQhjro89lN0xrYtzQxSEztzaJcRvra0+/HqzPX5e/0DCUhBcf3d638DdPl52Dycitw8
         XporbfaCn8uUA/8Ubg/7Xdu3liMn4rHskAxC7CQw4JEDtejN5/GxcGeavctFhGNUn3PF
         tya+crdNMqGVD5+xB+rP7J/40IB+quDOHDXH6/8fCn4bL5xA3/WwBSRGFXatQmtHY6RS
         thrEKSH/Q2HcxnbNQoHaIANASnZqVknUk2jH6drKpoY89Sj8LHYTgq5qIAYAyrM5Q34R
         7YZg==
X-Forwarded-Encrypted: i=1; AFNElJ/9DiwTj4F5RFoNYWlRFpJob/l+uqA/a8MGcz8ELGMGxAafbYWoVXNz781NrSBMulW5HixpU+zxhg==@kvack.org
X-Gm-Message-State: AOJu0YwQuLLFrqX9Ur+PvwU/KAJ2p4h4x/Fl1IV87lcPwwgG9CohaeZd
	hpPSxYFZGBtiW5QB2JT5M2hZWaGFgJ3x8UQ5edg0A/4UzAVGMvRxiSoW4LnkumWxvmsECpDOEgw
	Gp89nF1qQYw==
X-Gm-Gg: Acq92OFJunozYlQEW+FOJ5QzxQ03GeeuExP/zhH4d7482WkLejUWKRS/n4uA0O5uN5o
	MJn8IALVyar64f1bDZLHgjyqOuI8sJ6R8mxLpZzuFOcOoqvaOm+WMSZpJ+mcQojgG+5ObPtK9xs
	VqduJIUWfRoZ13g0itar1vn344F6aK7fhGOKNJ6Zs/beRZpHtyZiXljO9ABpT3OGOgOjla4GDTi
	0+zmnx62XSx94ijqYs99WE/8LaJLAenmFR26PqBG/WklGO988tcGMiQ5WOEuWethWVTA/ceZEQP
	bz5Hnur6PWCMbF/M8i6VZC3RFZ5xDxnELediZ8+vfEE9JuppeZ0i7QhhyuCTpogrp5bmFQPejil
	LGCysMpKKnhlKLWrofuutTOeXqcL0nfOTBvipktYzkxbxFdMRMB3KNTmDErV8BItWqJ/2LbxHOH
	kUFWSOGRwM7kNFOY5zGhxh3KgcCkAXOaIXnIJ6nGgf/UaraqyRWtvT8MCjpsezg1j/PjHUD/s=
X-Received: by 2002:a17:907:c248:b0:bcb:d9c7:c6f with SMTP id a640c23a62f3a-bd51780cf97mr1533831466b.7.1779301170147;
        Wed, 20 May 2026 11:19:30 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4bcf492sm890594866b.6.2026.05.20.11.19.30
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 11:19:30 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bdbac72ac1fso46187066b.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:19:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8ONXslkUPUANKB+Gctlfon4cGWmSEIaGj+bQr4cH9yAoUd1aLyKSKPOlHRDmuOIY6m/BPScVtoEA==@kvack.org
X-Received: by 2002:a17:907:86a2:b0:ba0:d58b:6045 with SMTP id
 a640c23a62f3a-bd51797a648mr1561777466b.27.1779300697778; Wed, 20 May 2026
 11:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com>
 <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com> <CAG48ez1ekM0nkBbw1gD30rsVp8x2BJV-6Rb-30L7m_eCdcGVTw@mail.gmail.com>
In-Reply-To: <CAG48ez1ekM0nkBbw1gD30rsVp8x2BJV-6Rb-30L7m_eCdcGVTw@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 20 May 2026 13:11:21 -0500
X-Gmail-Original-Message-ID: <CAHk-=whTe1yUc+SqJvqrLhCvRykS024Bdn72NsNrosqH091e2w@mail.gmail.com>
X-Gm-Features: AVHnY4KNZTnm4EfK_fzUFTfj9LdoT6UesXL9eF44XJCjJWXp549HYM3LW-4K7wU
Message-ID: <CAHk-=whTe1yUc+SqJvqrLhCvRykS024Bdn72NsNrosqH091e2w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past exit_mm()
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 89bmpijxsq831g9np3krdegjxnkct8h3
X-Rspamd-Queue-Id: 09316180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779301171-161624
X-HE-Meta: U2FsdGVkX1/6gWobE9d9YyUMmh/Mo32Thz5EFX3Sz9gZrZ0hA6CJd673conOI5NNtv74gQJfUSRPpaHtq44c6xpwv7yFGCW/nqJ2DmRsi9MeLpG7j69Om8KIwUZ3fTR0EjWgtuxkiAEiDueqglcQ7agGrx6uETLdrJB9oYVgU8P/Dv4iMHvkV4BNkspnILk8zELzfiM6767pxJ8beMZfIKrR5sHSvmcMrp0eNs0rXB0+JcO6CTc0LtUuN/lf+nTvWk2sOzKkkhT8w1zoIvzcQ3cTays8Tbd6ZwUg8JF+cU8kaiHWuw4sTfrXleR0LDMFdUKup8AxQKmoA0lKaRKdPYEFAEBdxG7q1dRNGT8M0ScQfz2XD09alGfL+O7fcY0xEJ584rD2mGK7x6ezYM1MZ0c6G0TMqnmxknbGPDihEAmSM0TyU5cB9hYoG+j6nzT9+yE0uPSwBr6H5zsY/vJgkKXXtu28vdRtjwT3l74zZ0FtanHkKzNCl+I4+q5qwaxucVWKspU9timS+f+9qD3vRAMPGb5QUB1a3nLOuO5obPVTUNZCxBkov5/y2QoX0h5k9VCX/60kOwaCYcW5cz2RgwL7G60n0o1bKiZN3x5koqd+0YhOllMh/aNcQ08UAOVhEswm6A0lINxhi3KwYP2DwFXgNcMCdB+bSEHp4GHWQNa1ZH1zMbrewl5/y8TBLHG9Bnlu7wiwdgBpsDxTIBFiMVhvUoviY6NyCD/rMlg9F+fhT2enZT/zQl/WSAxCg6c+cJbON+UnBx7RgTJMFB7QfG78XMGPtTz6SOyJcF4FmY+zHPgvMDIDQ39dc9OHAkS0FUxLrUVb4BS5bwYMffAl17h/JL3anjijE3rP3dmE0dYwdGiOJXYMECFuX1f4fhcuhHWX9kOoTrauBWVIz+iXMdR/5oWCOiSXvCtKA3hRrMViKW0Fz5We7N7I2ibtFhsU04neL6SWfRAEqFAgjtT
 mNqw8vss
 lYqJ+BWdBT+D3tJRYGVGguG4i88ZLw5Ntw+/D/dP0fe6pVGr+y/sHRYzXx6iyEo+JuCHKDUZWpjWSsI83RmBws0unUyn4ERM+3aanX2VxK6sLwdsAbwwYH7HNg1aNGj52Q+jlm3lw1n2VukT3yno9u0EVvAFUSHVo/bSJ1W/ExMwgqJW80QGjUZxxqHXvlYbAR1ZV4J64m5mAEfh/dsQk2jB+rSfRWT0uo8ryHNZn0npvSCyP7j4FErWHkzFahfnyrmcM9HGsgYTQLq/Haq7S/gVwMRfiUlC4VAGMhlG8XQi0xMhASvDvXHID1rAAKIe50zfwAaGFiqpcOUssdmeGlq9Ss+e5Su1u7UhajL8438DzHBj9w7wQVET9vldaCYKJyl9yunmTQVMeCtIsdtwRqltl8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 at 12:29, Jann Horn <jannh@google.com> wrote:
>
> That's a signal handler for signal 36, which probably usually runs in
> a multithreaded process, and it includes this gross hack:
> ```
>   // If the process is undumpable, /proc/self/mem will be owned by
> root:root, and therefore
>   // inaccessible to the process itself (see man 5 proc).

Well, to be fair to that "gross hack", I think that's an example of
people working around dumpability being kind of a kernel hack, and
then /proc using it oddly.

I *think*, for example, that had we had this whole exec_state model, we

 (a) wouldn't have needed to make setreuid do dumpability games

and

 (b) we could make task_dump_owner build the inode permissions from
that exec state, instead of "use the current state, except make it
root only for non-dumpable"

and that would probably have then made user space not have to play odd
games like this (and probably made a lot of people not play
dumpability hacks in general).

So yes, it's kind of a gross hack, but I suspect we forced people's hands here.

But even without that, I do think we could probably always have added
a 'permission()' callback that allowed self-introspection.

So self-inflicted damage to some degree...

          Linus

