Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39378C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E4A6B008C; Sun, 30 Aug 2026 00:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFC06B0092; Sun, 30 Aug 2026 00:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC456B0095; Sun, 30 Aug 2026 00:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBDBA6B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:47:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 318AF140245
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:47:51 +0000 (UTC)
X-FDA: 85156703142.22.8225A70
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4FE4340002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:47:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=osru8nqQ;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788065269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Vc06ZNRpYBBHTvqsgy23xgxM38CjEwml45kmCyFTrw=;
	b=nQy6ucRn9MNpEWD3sNPwqojhOiZdNkRGE/WwVoYvTCOobj3br6Jh7IOFqoUDCgvFqPLRcd
	nAi1YpKQQ/W/OiheMoO9gqyCoIhMPYO4VK3brCXlUqnN5ZrHSNawMn+WHsd6okJ4FgnjLy
	GBMGd8AkrgGFN3DkQ1lC/WEUOzxehqE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788065269;
	b=HusFVik8RPiyf2WA0gY5JwYfdal6hv4GiLarwwQbyOltcEa54Iyk8TRZ1Bca6VtGW04eY2
	26CtOHJtBOtBInA0Hy3G7st8WjYCrc8VUx7rQPPvFn5m9RGzGi03jV8/a+PYKvpf7VBMGL
	tLBdPTnSbRpnxq/vy+YfF686YKw+4BM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=osru8nqQ;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b8687630fso15368565e9.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:47:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788065268; cv=none;
        d=google.com; s=arc-20260327;
        b=ByHykbfc2zOU5+pH1TxsgSvdDY6TkV/vRuI+C5w5wpGi5FENr9/1yO+PH1+tzGvq7V
         eB3zfudH/b60CkfHqpVL4EQfIHLQmkrVP++3EkFnuH+MKU4/cTFQ8QC/9qbiLGmTltbN
         uUFKwrBzWlmhzbDrtLKRVO/KDuYz2+M417Gxqs2l/D9ZXxqUuTCbjlymdZnXZA3s+q48
         VRmwHMsWjK5Rru9YNSiCxQbrIN5qoLH6YEqVfeEY5u7DrhSNDsQqNBiVlhS4oTzRS8T+
         qRBmUwqHXq2eFGyN2+ZRMYMDQVn9PEJ52iK8lwhQgl6fm2Ezr4tiKvsgAjCCPK2+xgXX
         WOHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Vc06ZNRpYBBHTvqsgy23xgxM38CjEwml45kmCyFTrw=;
        fh=SaysGBKjlAfzBaBQ/a+fY8VKr2aagOO6HvuE0eYo6Fc=;
        b=ooO8gUDgmhfAZPoY71dxDtHlh3k4g6wXrQOYLo1m+2JvfhTrKI4pr5fLZgd0uJSv5O
         BhUrpLq3KegLAHudgblvjQA3HCpF0MIrQO4/CuIIlZfvJgE+J41PkoT2Jb7+HzgKR1r1
         12UpODQPzM/UkL3L5Dmj3Oo0FlnEM4fWoyO/x5pniMBhEHlFi6Y9UUtERooQjSyhWvxK
         hTpthRXMN6uwaI3eTW209hKJsiKG0onbz4RiDoFyjuaDGDTZCYUjc9zzUjDBHI3T1Rcp
         +q47zDvwWKviziu62Aa+gXI1WReBQ1vyQWtZtDRpOKfJCfpIFWNXnlEy2U7Gd7rr+L8C
         RnMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788065268; x=1788670068; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1Vc06ZNRpYBBHTvqsgy23xgxM38CjEwml45kmCyFTrw=;
        b=osru8nqQFb0L4c5d1iBtN0tPOfokvKQZs8GhzzX0djaZtZBRwMjmRT7pj/Kqc9AtBb
         Cu+KbZcx7PHixx3VA+VC9Zo2QfhhymJkteBq0hhHa03ljxrksk2pY/wjTEX9WDBDMbFP
         Fte3Y7GhuUoRQew8iPsmuvHiR2eqvoBonUzMPZa6Htn0SBeiVGsYrtKYsCR4Os7KH866
         0Slp2tq3rvA1wm5PhWK0GOCvn5ZK0HEwT+PCtLjHzKcXUow9zw5f2Z2LBYqFThYD3HhE
         D5WHXryClnw1a48Cm0jol9fC7RYZmmIYuZCbu6mPSDcUe+Xwn/7PRPr4rn8fuC/koJkO
         VhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788065268; x=1788670068;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Vc06ZNRpYBBHTvqsgy23xgxM38CjEwml45kmCyFTrw=;
        b=hkvAPmDlk11PtDPG/Bx/NUYSPE9e9MFWSPi6YVkcKmy/NUS1OPsqozSlkrv3Tp7tUO
         6tH0aN+Wbt9k5hqc/eARSmri9JnNZ4cpavEOH6+IW1IdY0fl+giaS2NqDwyGm5mgA1b+
         pBcBY2+o7UFNs0SVa/F6tu+BDk53B5Uj7/wX8YtaJ88gMdol7KB8BGHoqsEMDM9TWnSR
         BbEt61Gy1HalmXREapeXKjrqyLERLz9E/FiSzZQ76D1hv0VcglAoizfOeJkFF9eCMe3f
         xTqgoK0y25cx0124RPKGS09jcotBAjYDZ97tz+/crHH00FB3lsQ9CaGwr/SmsZMNRz4z
         WzAw==
X-Forwarded-Encrypted: i=1; AHgh+RqzuM4JYAeHMeC+DXZsIC97H2e/VPZ+NGthY9DbXGpJFBZfPRTD3GPAss/VCDPGze0UDd6ICoyWEA==@kvack.org
X-Gm-Message-State: AFuF++nFNusTTMBbaZHQ5ObueFp8dfA+r177VcNfSK/Sf2viSjjbYWaW
	TMsWZu2YJV6HsCqkmCk7RWKjC4r/EKnjY70C3fh0SE+YQb7HLsoIVjBLF3Svde1UB19/dMDcPCe
	sV9x9rOkqM/L6jVC1DkujJ81uVJx266Q=
X-Gm-Gg: AR+sD134z+a8jhYKohnoo4UJ7D+vULK9l9HKKJo/tKF1yHvM/9Sar+5HhiWYZuQjkKQ
	+1vXOTME/2BBPIpNDbARvTurL4MpVpqJXOYtvO1Zw4SQA0OhfA7xlF8Ou0B9X5RK8u6eobYRdpv
	b4nabs6TSPevUPEFFYav6raLnA3v6NviIm2Cc6/Udv3ePN79Lvu80wvD37EQOM7Kv03wWWvXgJR
	+jMDkKTvViRvwBDLOf9FVJ4C9IEqKIIf0k0gja/DOxccfRFm/+bEJfb9Cat8HebBlZPq1HgFHXd
	CwSFXBoxC+GFIlEZo8rXNznFni3zILP/oqjzPwUkK2ouJg==
X-Received: by 2002:a05:600c:c4aa:b0:497:fecd:5b00 with SMTP id
 5b1f17b1804b1-49b91c56cccmr199584725e9.9.1788065267228; Sat, 29 Aug 2026
 21:47:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260827234704.63163-3-baohua@kernel.org> <20260830035843.712320-1-kunwu.chan@linux.dev>
 <CAGsJ_4y0Pz2fiyhS1X4PY+D-z-o8ycSKdFar9R5PQg-o2Kd6pQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4y0Pz2fiyhS1X4PY+D-z-o8ycSKdFar9R5PQg-o2Kd6pQ@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sun, 30 Aug 2026 12:47:36 +0800
X-Gm-Features: AcwNN1X1BM3aFCDy9xWEoYq0B8egfZbvtIFbvh-Pve7EqgmNqihbqIlpuSJ_cJg
Message-ID: <CAN_Opa-zZEHoc5+7peZk0nApJ-PW4oNqy6YDomRs803o26TpUA@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
To: Barry Song <baohua@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, akpm@linux-foundation.org, lianux.mm@gmail.com, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	chenridong@xiaomi.com, david@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3d5gjxjgayijuu1rzb9hjnp4fypukszp
X-Rspamd-Queue-Id: 4FE4340002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788065269-512701
X-HE-Meta: U2FsdGVkX1+vDZmHbr84xT/1rQG/qUiUYBLByLEhS1GPSlcOt+C9KoDVem77nT4votCUJ1Qe00N2ZCuLr9CdV9HJzmPdCbCiu3NBsieUlJ1GbfsCqYQs+rpcOnGnBfWdsEdIZCss0LNfuN+t7S09vgaH7HhHZv2a41ajBqszu9B0X8+rGncFFU+O2KhOs5lTagNe5xJ1okzuLWMwc+Z7AvhRZEdlTS6Q8+vNbtoOCXBjjqEcDueiR1jdSsryRsONlUCqqbtk4X2CLMLpigveEAM57FfB03RqVwoADykq1780JOLcweS1R4MAF5tTOAGJqNWGTP1K4qvQRA0pLLsL4NJGBfrDMcAuR2hcbEHXglsHQsiiRKpfH1kk1r0o5UNDQfUw08jfIuKJ4AmMuja6/5MT2GwBkoHoJYJULTAZTICi/T+Yb5UmtBosomqshreHuUMKNSXkxubFOg4aFCML1MxYGwJ1VIo8U9poliRkkVUQO9m1G7imfkIiYQ6vNRfrE/acfPVqNNyiSbK5HBTLpZM8l2E6wWr4sm4QGEE50qO5+vItK16IAiAcNxo2BhgxKN6eUBwTGj5K5UgEl3paJmxWUJG1ZHr6P7Sj6pfxaDNGfzS7v0qhleVGlytvV/niy6Wf4ShtBcIa6KM9C3Gw83GpuM3vt1SbKo366FC5dU2+1l3zWpRW644xqVxYPPO20xPZkNSOBsdT6bzCEMzqMGTGUPOg2FxHlZtuv/+XH7PjT1A4IdV/5A8JUcpmu8xWQSoUzrfF0tIervfioybTeeCVl1DT40JfGhd4XGbT8pzsYcXwsVPHf3xc9dXomFD4k24ClLBgbetUMbXUIKiDI4ZA0K/WEOG1tAylkJi3vA5Utn0tnmmAYRpFq7r/iYJvlPqDrxc/p40wsbgNmQji0H7FJ0mL/77YNMU2/4DGM8wpbJ5q8oP7mCeaQnybAYZ+GAFazJJQlseLREmwBeg
 oQ07og8Q
 sXVdUbIES2qZaPD6BS+N1L6Nkf9PdgoQBeVS8EhgVuE4ULJo/AbkUupignx0Mqv7mvE2cqMvkBeWLKANi6DY/KYAjI4WzuymkKednJ1o29vIBoa/NyHIuhmNWa623LHSDp7oCYGCMN8z2Ogp1sv+7YjhshS+MjABzF8AtWrR6t3rZn/Dzdomor1YpR9iSH30c3mjLve03FOV7cGCSjfFF+3o5F3ZxwqnOdbiVmImuqCvaOmz2FaBQ1GV+RBGTxG/qR7zQZcB6J72TvpOXEeSadbd3et6dn4yyz/kjEv0NMZqEn2T3EA2n3bvRHs6K1DKBgaKAgMjMLJJ6UDm7QGjOUxKTdtitxqWWQZkt2LGElM+Fk9Gti763nOqWQlaRINuHswQmmKddfMOw2XdmbjIjuOlTxjtWeyNV0uxDRv7vBcyRCaPvg/d0c7nyhqdXgXb5m9tg4UH/l8N6WTpzo6Z9nNLbUQVwUhfKwK/+T/orxo1XnHl95rPTtwOi06OL4jETCBC+H3OxhzX5s8z1J6Lfqqc0ugEXPDyIfseZui0nGoEMgpU+cXLAgeRmu6KVILz4zqBp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 12:26=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> On Sun, Aug 30, 2026 at 11:59=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.com=
> wrote:
> >
> > On Fri, 28 Aug 2026 07:46:59 +0800 "Barry Song (Xiaomi)" <baohua@kernel=
.org> wrote:
> >
> > > Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> > > as it advances generations. Instead, accumulate the size changes
> > > and update lrugen->nr_pages in a batch after scanning the entire
> > > oldest generation, or when the scan stops because remaining reaches
> > > zero.
> > >
> > > Since we only move folios from the oldest generation to the second
> > > oldest generation, the active/inactive state cannot change. We can
> > > therefore skip __lru_update_size().
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > ---
> > >  mm/vmscan.c | 23 ++++++++++++++++++-----
> [...]
> > >
> > >                       if (!--remaining)
> > > -                             return false;
> > > +                             break;
> > >               }
> > > +             WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> > > +                        lrugen->nr_pages[old_gen][type][zone] - delt=
a);
> > > +             WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> > > +                        lrugen->nr_pages[target_gen][type][zone] + d=
elta);
> >
> > Hi Barry,
> >
> > One subtle point about the `remaining` handling:
> > when `remaining` reaches zero, we now `break` rather than return
> > so that the accumulated `delta` is applied before returning.
> >
> > As I understand it, this is required because `__folio_inc_gen()`
> > has already changed the generation of the scanned folios,
> > while `lrugen->nr_pages[]` is now updated only in batch.
> >
> > So the invariant is that every successful generation increment must
> > have its corresponding `delta` flushed before `inc_min_seq()` returns.
> >
> > Is this the intended accounting invariant?
>
> Yes, Kunwu, you're right. We can't return when `remaining =3D=3D 0`,
> otherwise we will miss the chance to flush the delta.
>
> So changing `return` to `break` is intentional. Another option would be
> to duplicate the code that flushes the delta and keep the `return`, but
> that would be ugly since we would have to duplicate the code below:
>

Hi Barry,

Thanks for confirming the invariant and the control flow reasoning.
The logic makes complete sense to me now.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
KunWu

>              WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
>                        lrugen->nr_pages[old_gen][type][zone] - delta);
>              WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
>                         lrugen->nr_pages[target_gen][type][zone] + delta)=
;
>
> Thanks
> Barry

