Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CF3CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153168E0018; Mon, 15 Sep 2025 11:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12AF68E0001; Mon, 15 Sep 2025 11:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068168E0018; Mon, 15 Sep 2025 11:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E898C8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:06:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 806BA1DF5CD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:06:41 +0000 (UTC)
X-FDA: 83891811402.25.41C0F66
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91011100009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:06:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mf4f5MiS;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9WWi/ihcO4oKOZe+uMVsUK9rCWPwUBkVuax2VPkCyw=;
	b=WUjtdY92NevJ/KVeR7S4Nc/Bbu4P+IT0GxT/mjUwVUYSQ+PGRz40i/su4UESiTDAmbKDdF
	xnPU8ChDQi0Et/pLpJ50EuDFsS6Z9OWJgp3qdF0jRGyUg0GUmj0TbovLFnjTeM1Mmnj+2j
	HsKSgmbaYv/VN1uiuNTjJfYL5xTrAhQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948799; a=rsa-sha256;
	cv=none;
	b=YZdA7j+TYKmiQKacRl1S9Zh3FecbZMLaJDKTvoZBR/bqISbdqDS+RtvYED4p6jOU/bjEQa
	L7LJausmpIYGb8zBMQ0R2uTMaAZ+zksPCVXiT2rRDeff2w83eI+luDLFCE0DR4Euokjf11
	eLPD9L80c+02BR8+2Gv2EfpsiGkNChY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mf4f5MiS;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62f37300fcbso7779a12.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757948798; x=1758553598; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9WWi/ihcO4oKOZe+uMVsUK9rCWPwUBkVuax2VPkCyw=;
        b=mf4f5MiS63LPiGgqYMRgzT2VaXehMjGtnKE3BLck2b1GK2Z/y2KfZv9l0J4k92EL2O
         A5uFb743j7S/Hno7yfrQ7abgc3FoDt08XM0QZaKI2klsIZ+0j/BeNkkP0p+JCAvY8VSZ
         zH9fkHgsHju3sc6Q0x/TE64+sBXOLn0gVlkjj4iJIWll4/R61v3I0vXL0QAbf/ByOZ+9
         +ksSdUSCtNjEsrlcKZs+E+DTHJfzUiG+iLI76BSQXSN7AzKzSU0TJpQGDs4ut78f4RLH
         HfwGZwk0dMx4s3gzdgBNTGfN4vF0Wlg3lkQ3WaXCxiqgJ/p5DzMRd+HYhV/JRM04LEBV
         FSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757948798; x=1758553598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9WWi/ihcO4oKOZe+uMVsUK9rCWPwUBkVuax2VPkCyw=;
        b=egG3jtAHYhXKlGUk7dNWl1hBWA22wvEV2muOnv3oHzf71gmSo0TD9TOziklMQVy52Z
         z60u7qBp406kHYwXrqExeb9r2q+YCP92IHtFCyprloHU4hssEEUc1l+sJ/03AiIFa8t8
         OWEb9bmKqueYp9LRBGJ3nxF/pcWqbbzfSJEq0LsJnKPWkqASg0b1OdeXSbctdToFenhr
         +juC69jJJlQhFkzheA2SYeobhCJ+AQrxN7luqe3OYD5UOCGoa+ultGFFE8AI8zSnwSK1
         q298TXArAecRLfmXxIp72bR72OJcCxDUTmTjV0ON+usneKGViw8gZf3oFMC8KCHnNz+j
         Xhyg==
X-Forwarded-Encrypted: i=1; AJvYcCWPugHEkBSiRCXR0REKJxgsXd2SWNi8F3jdC4Sg2JvKUbEx5DE1aRJquVpbQp+7yMwOlS4SBvzWAw==@kvack.org
X-Gm-Message-State: AOJu0YzZREfQmcLqSrlhC7LVaW7tluB1L18KSAWtflW/vDjR0w6kNu/a
	zVvv7z12/exfFV8p8mmfV4FRh84nBGvLdXBIoOhHd1jYMYseuclcjyjzTnXw+DWmhQ8fk/+egZB
	JVSp12Yuc5vVcYIwg4n71dNis8Sytp4TWoa3vU2F/
X-Gm-Gg: ASbGncvBLdWClXc4veUBIuKhihkNpyqc/VlrC5c2sMWfx2VgT1jS0TZGdo5M3Byw5A9
	JR0PWYWbI9mDdUBUX+BA4BIemsp7ZSWmfS7l/DclGzK1iufIN9duZu6G8Sek1nP5wabpHJ5Psgl
	HoaWKYYLI6kxNja+CXsN9b4uGAx14Kg4Vvcdu6Z2AHGYEXdUY3WCJ3ELtAbFj8J03tQFOnXYm4a
	JXC71uA1SUE
X-Google-Smtp-Source: AGHT+IGjXi1PFjJ4mYxVJND0ubUCMLSxglAxJpNOn5/9ShV7QOetbvNvu0dB8FJs+cORTcGH5C8xzIQjtHMDsoJbcW8=
X-Received: by 2002:a05:6402:562f:b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-62f02779419mr123720a12.7.1757948797375; Mon, 15 Sep 2025
 08:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
 <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
 <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
 <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x>
 <CAJuCfpHJEUypV2HWRHqE598kr-1Nz_DokMz_UgrUnq8YkFcb9w@mail.gmail.com>
 <CAADnVQJQo6+AwJ_LxARVu37J-5T-7tyn1kA5hMVDGDfEyjF6mQ@mail.gmail.com> <e166705a-e838-4c8f-a8cf-64913e120caa@suse.cz>
In-Reply-To: <e166705a-e838-4c8f-a8cf-64913e120caa@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 08:06:24 -0700
X-Gm-Features: AS18NWB87vwLHWOm_ZFhLCV5OSwUHRhJoQJhrbB2IlJ2yzZsuK8epBGSVT0Yb4c
Message-ID: <CAJuCfpGR2tHhUu=p4X2YKPNot4TJbhuFPRiT8BgOHvtcw=j-Ug@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dy4bu7dentwxdbqrt1mbpofk5py6z95p
X-Rspam-User: 
X-Rspamd-Queue-Id: 91011100009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757948799-711124
X-HE-Meta: U2FsdGVkX18EuT7xXjTVb369yuESUJnhPbWkbTFCaFXYMyXGnWwZuXIsNX5rya9kFng05QavQlGj4EuQYvSuMZFj8irFn7xDtSKDsSMNbKQ3bA+pjXL9ervgmUMD8sErA03ZLdNUO0YPex/tKrDVwCD+FF6F08qio6Wi3u5Jn1XHMJVFt3zusR90dZhedUrdPFdFN+h72hsoUw19ijvMVLXarfknvfbjQ3vJcVfNnNOWm410hvqIyxMhWp4unmBOY30/Q0TwNXbqeHDiTkbKrImQX+IftCUIllyZ515g7kEmBU3YpURFp1fSwsbQgMho9VZPiGUEVH3tJd/X9oWhWEmI3dLrMtefNjXaOlyojJvOmi2CpRVGB1U7gPESA7+SvEJjJ66wWhqqgsyVdvE8/x+at1JmdhjX0COsc44UvRSNrrdK9smXPkKbWxnYrI/tRbeTdT21hD+/NYMWMMXg9vEOcRqsGGtTncENB99fzimbVGGvt8blQZf2UTNlWgdWmOpULuucyY2V19AHMnz+JeHb6WN5X7ZeQrhyoV8BrHY4BBR+/XdeTrS1Jl7+lrhCQM+czx8K8uX4Gono2rGI26WMpzPLB7e9l5RUPmdt5Qt9kbWH6rkq7b095wMI7mhT7hmS0epf9q7inQfb9+hmtwU2lNUH+WfT9Yab4ph8ovMUZRWz9ExHxn+tcpIkUQYlvc6J2bas5FLhEcI6n0tRvVTph/W/nQAHGE4+TYQRCN6fpjYzA6eFDrlX7rleoxz6w5AQY4KiTgX0rmASG1YZMMYvb1+/CQy1GFAIfIdKPxzYfeG5b2iFr1omUBGmay9Wjxifzc5hVS8143wqzbxAolWzRcn431aXbHoZ2373GD2SW58sxuCMGyaEiOxuiSbrWo2oSRhnflJBhwtY6SwROyzfxaH21iSsYBgx0QgBhwRZ7Ily07Y/jo92TR83z0gnCFc8LkXYOXeH+Y6SMk9
 aOAAfb/s
 x23TvM9G+02KFi7BFMTeo+t5Jd+zSrVvE5ZZ27yliHvoewAqGVn6dyfAMko+aIoU3T+90nsF/ZP37QTr+m3b47u15ocBlkygLiAGdXeR2bBBhyVaRwPRmy+bMIFa7Pgq3/YNGhRp8NGjUnp9JvqWI5qoc/vFZ2zFdFGVywdz1crNV5UHCPfHrjS2Ibsx57x9oCxhjC88gaF3nSiHpaMDr4yMltKI8DVDp+4WEMUhota8I5Vseeg0ndpt7+hqswsRLYUPhzVxAnU18XpXtsQT8fJziAFq/x0OYsXNT5G3AuNP/glwsCyROOpfypP3U1LezT6tKKx6bN/JLPXmryFLsoo+N8gEqbnrYoj/mNdk43uRyFdShbvQdIdoJhTjnKezcu/EldORFaPyEuXZYb+cd7sWAkujkoW24hAj+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:51=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 9/13/25 03:12, Alexei Starovoitov wrote:
> > On Fri, Sep 12, 2025 at 5:36=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> >>
> >> > > > Suren is
> >> > > > fixing the condition of VM_BUG_ON_PAGE() in slab_obj_exts(). Wit=
h this
> >> > > > patch, I think, that condition will need to be changed again.
> >> > >
> >> > > That's orthogonal and I'm not convinced it's correct.
> >> > > slab_obj_exts() is doing the right thing. afaict.
> >> >
> >> > Currently we have
> >> >
> >> > VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS))
> >> >
> >> > but it should be (before your patch) something like:
> >> >
> >> > VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS | OBJEXT=
S_ALLOC_FAIL)))
> >> >
> >> > After your patch, hmmm, the previous one would be right again and th=
e
> >> > newer one will be the same as the previous due to aliasing. This pat=
ch
> >> > doesn't need to touch that VM_BUG. Older kernels will need to move t=
o
> >> > the second condition though.
> >>
> >> Correct. Currently slab_obj_exts() will issue a warning when (obj_exts
> >> =3D=3D OBJEXTS_ALLOC_FAIL), which is a perfectly valid state indicatin=
g
> >> that previous allocation of the vector failed due to memory
> >> exhaustion. Changing that warning to:
> >>
> >> VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS |
> >> OBJEXTS_ALLOC_FAIL)))
> >>
> >> will correctly avoid this warning and after your change will still
> >> work. (MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL) when
> >> (MEMCG_DATA_OBJEXTS =3D=3D OBJEXTS_ALLOC_FAIL) is technically unnecess=
ary
> >> but is good for documenting the conditions we are checking.
> >
> > I see what you mean. I feel the comment in slab_obj_exts()
> > that explains all that would be better long term than decipher
> > from C code. Both are fine, I guess.
>
> I guess perhaps both, having "(MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL)" =
in
> the code (to discover where OBJEXTS_ALLOC_FAIL is important to consider, =
in
> case the flag layout changes again), and a comment explaining what's goin=
g on.

Yes, exactly what I had in mind.

>
> Shakeel or Suren, will you sent the fix, including Fixes: ? I can put in
> ahead of this series with cc stable in slab/for-next and it shouldn't aff=
ect
> the series.

I will post it today. I was planning to include it as a resping of the
fixup patchset [1] but if you prefer it separately I can do that too.
Please let me know your preference.

Another fixup patch I'll be adding is the removal of the `if
(new_slab)` condition for doing mark_failed_objexts_alloc() inside
alloc_slab_obj_exts() [2].

[1] https://lore.kernel.org/all/20250909233409.1013367-1-surenb@google.com/
[2] https://elixir.bootlin.com/linux/v6.16.5/source/mm/slub.c#L1996

