Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E1FC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069366B008C; Sun, 30 Aug 2026 00:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A4F6B00AA; Sun, 30 Aug 2026 00:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A846B00AB; Sun, 30 Aug 2026 00:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B933F6B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:26:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44302C0242
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:26:19 +0000 (UTC)
X-FDA: 85156648878.04.435F1C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56A6DC0005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:26:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I95TTF0Q;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4oyq3XNxRWjvU5KSLZ3bRN6q9YknXc+HlOna4jRbr0=;
	b=UrbYfKpe5s899C/pOZQ7luL3djtf/7gWWpA1BL0ecOu+h41aSohyOnZCX6FS8q4ZmBzBI/
	0F+JoZ7g7z0VjAeNXCXoREJzH8Cwe1AOlg0AqB01Qfhsv0uG9I0nns+4qhLdKR3jKLbNU1
	lYJeeJgMGKBX8gTq7GxBPg0YuisTI3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063977;
	b=gd5erMt93xYEa+z2DM09IsVmbVnynzhrjyh0EqEMEtATHXaI77PVaGJrUtA7G13kL9RuV8
	wgkJr6YHfViBS6e7xgUeJxN2TZ9PuCtLlpG3MYaPkkNR2wvcEoSRgoRi1PLnWn8DlOY5XG
	Z/tks6OKzOgGQp6epGTYG2O6tGjsa7w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I95TTF0Q;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3445543F57
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1708E1F00ACA
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788063976;
	bh=z4oyq3XNxRWjvU5KSLZ3bRN6q9YknXc+HlOna4jRbr0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I95TTF0QUvm2sKLPEjcrxd3aq353fdKMcv3SW7001GkL12ACKoyFefSQeeTGTkMd8
	 ypJirdJ2KH0hio/e+7BT3gBUP+LdlL9BR+KBVnJZniMvujaw2fZVoT/ZiN7+epiI6L
	 fcvYq31wwZ2Z3UknzLt7zCrD/fR61PAE5CRfnfUky/h+FIvob2hRkjFVfgburqe7nT
	 pu/ZzTlFjds/E6JarfSKthPs6bq1tWRBGbEKtHx2Y8umTAybEYS07p4BxrzklkKRDX
	 9yt2QCej+V97Rm97l0RyfXBhNxysNrL51AxX84WW8FFTIcOCNtjQd75waSxMrShwsf
	 DDrJNHyfggdvw==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9392aa26b25so61329685a.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:26:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqGNpbGC04ZX6J4s2ZQ+Fs8CccrW52RoKre2rW6CEbWgefthNTQG72oK817DFJjQ/WskqYerQ7yhQ==@kvack.org
X-Gm-Message-State: AFuF++npGMP3Ooe4nXZ/czcyNVr2ECxnMpMHYGMR6jUM4Tk/82pq4QK9
	VXAYWAaP8Os3YVbnCBwAKJnLPPkrYrW8z1MwkAYUkTVLA5dfa3rTITThLEsUo8Dzsw/t2nrF71f
	e80ybOO3du25/Ksc0dAIbiMjk5+bu7yc=
X-Received: by 2002:a05:620a:1d08:b0:939:32cc:f2cd with SMTP id
 af79cd13be357-93932ccf558mr159931785a.1.1788063975448; Sat, 29 Aug 2026
 21:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260827234704.63163-3-baohua@kernel.org> <20260830035843.712320-1-kunwu.chan@linux.dev>
In-Reply-To: <20260830035843.712320-1-kunwu.chan@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 12:26:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y0Pz2fiyhS1X4PY+D-z-o8ycSKdFar9R5PQg-o2Kd6pQ@mail.gmail.com>
X-Gm-Features: AcwNN1VgEblGKtPauG047hZ4EFaf4rQhRNcWvgLAHvyDRFW4jMs-EL1wXwED7J8
Message-ID: <CAGsJ_4y0Pz2fiyhS1X4PY+D-z-o8ycSKdFar9R5PQg-o2Kd6pQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
To: Kunwu Chan <kunwu.chan@gmail.com>
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
X-Stat-Signature: wgx145fxufaqzrgoe5br51xcrb14nbjp
X-Rspamd-Queue-Id: 56A6DC0005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788063977-162023
X-HE-Meta: U2FsdGVkX1+3yM5U2vphwcLJ1b7fohl1IRbRyX3G8bYgicA5lhBX2UBAOCDJtc9cKZPP6ly3MaB3FH4GuY485ms4qD6eQv4N++oET8ypD6WAIuasnzaTBtpnUcTCVR6e4HBzQ6g8OgNNbN0cSN5YnVAFqEnwm2sNXKWEJQjZLzr5b77WvOY4U32rzd9LLxbEAtIxe5lPjJr7VKZwjIKQk3eVNC3I8aCXdQcl/IbJ/zZo0Sk/UW2PVXd1mDDCLPUIM5UK1PPqBUpmR9OOQjS3eD5PvPXoYfHeTX3dFb1JjwavgJeqt+DB9NxNAmIfMd2Z7BNKkdwffospViPpmdGGZieVwestMmSC4rZmFVsCI9zozaKnGtiIWaKl2kZu+GsWjJn8kRKI8kSIWBczniO75+PCWz0rcIUZmoZsQz080oE2kvEogeCGhisJdiRSA0uEeZdUZMRdQkcgIxPbYXn1S9AHfU8fbBtYpZIWYGb7EJ+AAf/P3g7jyAAE7r9WqIZZdjv8+skk2pGvMPwGDXoR7TcB2bu5EA7qmzZBO1/2pZFMX19XuJDFjPMlVfyzW0AQWOMJ7LJ8tFNl6gSaQo6k58ggEl7N0p/9AE15DrvhJXUFFVO9xTY9C153db8gglInqnKodzYFQHFjEjO6FT+/1iuN369X3ySA5yC0LopnZWm7ksVcYrUkH99HLcHU39w4gS6wta8Q/Oc1DSSTxHt8I9VVBHkKMGkXuFi1obKXfEdhkxWjr4fQHRlDGOYSDYP+rCBbqK3JOqE6YcAd+GgRRW2/a0/m0ZrlPW6mk4zgzKIL6cTzXv7HdMa34ZUv4s0rM+2mXRhPvUy9VWoT0rPlmRP+PL3m7HJXhhV8w1n31tQBW3hGyFzk3+7svi+8Lj2WeC4l9Rv6gJUhtUt4YaI13sYFeTo31bwKWmGxXLmbvIRCd9LfzWQYjmi0BwnEjyVKcXINoIhhCOm/7InzTKQ
 jTEwi7/x
 IXbrRuIrOvDnrVUc+U5zdlMHBGLuJv1ASFtJIyfdGpLJDbG8RAeuvBlMImrAv2xTtLroz6A4zDvV/QJPH2gvlzQnvbYC69H7umlDzfonYE4W2O2QnycFjUctuSnP1tL2vcFidnmnSH4lSe4nydARQfFurD4iFJqO5UWILzfsVOLSX+7sarqvOVaglfW3BT8y4vqqIoQnylbH4lH2JW2BkMAyhBLFW7lTbYRamBppKykrKc7Ml3wtl9AMvsBTZNG96MaSGcnSnVIEedVbRib8czI8iVrJrxDrLSS9ldr8vIqRtrYlBh9yJLLLX71EzRviU+5icCS1rKbpVSn5/tqhi8bXqKhohjLF18cF6U1D3XdID3tFLI3qOUdM9yA/KWrDNNNHYQQol4E/lngZYjDYdDOkHRb/qQNdIxK8xQ+HHvZ8FnSMUW+k7qH3KQrLg3NBeqsECKWVjLNBYzL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 11:59=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.com> =
wrote:
>
> On Fri, 28 Aug 2026 07:46:59 +0800 "Barry Song (Xiaomi)" <baohua@kernel.o=
rg> wrote:
>
> > Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> > as it advances generations. Instead, accumulate the size changes
> > and update lrugen->nr_pages in a batch after scanning the entire
> > oldest generation, or when the scan stops because remaining reaches
> > zero.
> >
> > Since we only move folios from the oldest generation to the second
> > oldest generation, the active/inactive state cannot change. We can
> > therefore skip __lru_update_size().
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  mm/vmscan.c | 23 ++++++++++++++++++-----
[...]
> >
> >                       if (!--remaining)
> > -                             return false;
> > +                             break;
> >               }
> > +             WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> > +                        lrugen->nr_pages[old_gen][type][zone] - delta)=
;
> > +             WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> > +                        lrugen->nr_pages[target_gen][type][zone] + del=
ta);
>
> Hi Barry,
>
> One subtle point about the `remaining` handling:
> when `remaining` reaches zero, we now `break` rather than return
> so that the accumulated `delta` is applied before returning.
>
> As I understand it, this is required because `__folio_inc_gen()`
> has already changed the generation of the scanned folios,
> while `lrugen->nr_pages[]` is now updated only in batch.
>
> So the invariant is that every successful generation increment must
> have its corresponding `delta` flushed before `inc_min_seq()` returns.
>
> Is this the intended accounting invariant?

Yes, Kunwu, you're right. We can't return when `remaining =3D=3D 0`,
otherwise we will miss the chance to flush the delta.

So changing `return` to `break` is intentional. Another option would be
to duplicate the code that flushes the delta and keep the `return`, but
that would be ugly since we would have to duplicate the code below:

             WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
                       lrugen->nr_pages[old_gen][type][zone] - delta);
             WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
                        lrugen->nr_pages[target_gen][type][zone] + delta);

Thanks
Barry

