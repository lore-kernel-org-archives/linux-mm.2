Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED8BAC55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6346B008C; Fri, 31 Jul 2026 16:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF6C6B0093; Fri, 31 Jul 2026 16:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4CE6B0096; Fri, 31 Jul 2026 16:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA6256B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:21:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D2ED4014C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:21:55 +0000 (UTC)
X-FDA: 85050192990.08.CE93271
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0981140003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:21:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lf1FfkEc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of linkl@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785529313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5CueYXbQOcoeKtu8qRFGDocoF+pTzEJV0YKoT1V3Gg=;
	b=lGzJb7eoHxmMMdF8/e1LM87Wx+BmrDFgXfbAZzpd2LkFaB3hxhW+FXf40+jprHyqAf0QDX
	r2i/xAtTUzaha2f2Ur2qWRjRcis9poilkzOoYQxO+dEJxKdWKeYQSD+buBO2u8AsNsmpq9
	M6i4U3FrZT6cs1PFLUBkvtg42xXPU9Y=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lf1FfkEc;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of linkl@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785529313;
	b=5FDXB11saT59IFZATdptqbRoHFK61r0YWHANoNpnz7i3XHtu7lg3Wx+DBfSfod9acGo87m
	Q2NGwddo41R0fMhpDI7ZUURErSjKIlECWeiLP32j653f8lcXsq2Gt2JB81Z5haHzo7OK7t
	NJP3IQAZTMmFczKHYnOXOCTp8YxSLjo=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c01c79467so57291cf.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:21:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785529312; cv=none;
        d=google.com; s=arc-20260327;
        b=ZHYKWf+wwYnnwoEFI59FWrmoDCHejayIiUjYhu6G1/bFhoaNvusluZq7TQjC66meEQ
         AS1H+u3myzsv2euuhHKyNTeYGAVeaKfxcMP6A0zqfD/TIfJ9kZKLpHKIyMKIhNmqhCT/
         3o3Lqk+/LM3oLLC/KL8hP3wOrDgt8UFqGF6SWyVIJWENr96Ib+Q/raNoduyOFh+sC/9w
         fJFXdjtduMvg/tsykmOH62bkCDI/Y5ifOs85qX/8pIi1piBGWhf4V8WVyFhcAGauyE1N
         imQDe2OwDWHOKLrg+0cPTZfyHWT64vKDTEqh0RwxWB5MVuBm2mGlLgpkbBg/b4qMM06R
         Pvew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e5CueYXbQOcoeKtu8qRFGDocoF+pTzEJV0YKoT1V3Gg=;
        fh=MFvm3VFuF3sWIptJ6zEs2D4MpCYpAn5M3vlVRgxbEig=;
        b=DOFoAuOVpUIfFBMaBWTgE2IZfDrVfE09L7Mk002ooaeglEvskkiVpQsBdTv+LEahXN
         /uQa/QgbFx87teRPXv8E4rAoyZPHT++TvYlXh3iaW9dhwlOoo3aQP+vgDOBXL+Rramkq
         rmjtyvyhI7gcGk6piAEhEbna2WW1ZSznt6qgtBA0/3r7EjHG+JdECskZ2dIM2j+tO89G
         PZf9q8s86j/Q0P0zowOZJ6zz42p2B8X549agvr+2WkixKrkg5r+KW59jKQF6pXusgwD9
         8OdY5T+jEAfqnwEL0zNp8ZCurTMDoR3adPttUqOdWiJdP516viEmmUzuzVweWM1lKijg
         8RpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785529312; x=1786134112; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e5CueYXbQOcoeKtu8qRFGDocoF+pTzEJV0YKoT1V3Gg=;
        b=lf1FfkEcfMZk8EDkNvsMIAWjjPF9Jrl28nM+3V4GajE5RFYQxUCae5Fv0W4x9n6cXR
         7L1EeS4EeIbV127Le8YEq84k6Fzw4KX0zihwDsmH2kMtQGnNgXbTenuYu9fdgnXy/xAu
         n+km8nFDz7g/ODcQHixmi4HIyvC0Fb0KP1KiNLfPvqvxVtvD5vu1pG4lWpz6vBF8u3k8
         NQOAf6JagiAg7EQWe54QDgWjYFTH/b7l0TNYRH0lHs0/UR2q0l+XIvTuDY1t9MVi8EXq
         7RTEYeqBBhWKxHi6wNA3Xp/nFHg2teKUtki6INXlzZqlRJBzAYffIZ0cxv16CsiFk24Z
         MSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785529312; x=1786134112;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e5CueYXbQOcoeKtu8qRFGDocoF+pTzEJV0YKoT1V3Gg=;
        b=DARdxvvcxoPPkGjmoYpStweJgmBb3kkGgM4vXAnmpYKlnSjT2NTLx3P1Idjzx4F8lz
         OPuU477anqoCjbyJbB4cDBa9HDmNl+9ZLRCNjfD1kQWsB7KyW+2A+Q/MjKDtn2NTvI6I
         rU8uxyOYZ21ET+fypLc+V+RoNydHy4MyHBMUpgNWPyrkPyscDKze1rjU4tM5rtTqkUfD
         47CUvdSAiBVPUtYdtcwxo4e53jVwpmKaAvI6hBP7LR6/SLVn+gJbOADmrvekAmI2JYC2
         GiawczUbCyCbXnvCiQbbdDrbiOiJvC5WTLRiLniuaCcRsNlc8tjR0GDtmSobz2oUR9FV
         2hHg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1NiVt5QG/E/+CaoGn6y5oHPiPXgSHftcr+z3F1CsMD4iiFK2+r9korHfUKHC/+is6IxIVD13ISQ==@kvack.org
X-Gm-Message-State: AOJu0YyMLH/HXyiLuuun2hjdxa7aLD2Iqam6FAOYGQKRWIq+Tb7HqEUN
	suxdH7OJaS3yHmOdxnrZJvA3fxsf2ET5lwz7PK+L0FEDRk50SdMrlYnTHiAQ0e0O/e+a+juP+I+
	zL7vWwPJHSvHfDIi/mXLN0heE8GjKYU90fbmIMoTXEIYLCWdf9xeIk9GijC6KSQ==
X-Gm-Gg: AR+sD131fJp9SoOe29d1YhlcOtqay6xEAZV5Yg+pgmYvPrJX/uvbXDB+4Gg9OZjMuEM
	mLXKgS73rpOaWO708laBJqhKJ0sEqZFZkATa1g+99Vj9xMIgGkObLZIvSNSEB1wx+YQCeu6R7TS
	Npuhwt+LosolFjgJH23QU4IsXNXZC8H4Np7nLEhU3h58bpZspwf3DLumcvt1y4yVwZC7MkCnR0u
	L+hyt9UBHc49yN1GHvyJF6V+6hxiIbU7yIXxJsXGyUvQ7QOZK1/jI07Uynw3XED1U4Wyyq4MOZz
	SBajdfYkROV6RTGXQmKmt4s6Edlu/O1lbONvBt7pmiLafXv2tNfTSXwuDZS/kePX+Dq0lTh9kNc
	=
X-Received: by 2002:a05:622a:1823:b0:51c:935d:8d74 with SMTP id
 d75a77b69052e-52b5b0e51demr641901cf.9.1785529311540; Fri, 31 Jul 2026
 13:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260721005603.1710551-1-linkl@google.com> <20260722173639.34d3f58413354218b24a5b0d@linux-foundation.org>
 <CALUx4KSfUUud86k4SLwETJAciRc8kZ9QocvBj39KmzXDiQ7J1g@mail.gmail.com> <20260723051327-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260723051327-mutt-send-email-mst@kernel.org>
From: Link Lin <linkl@google.com>
Date: Fri, 31 Jul 2026 13:21:40 -0700
X-Gm-Features: AUfX_mxNBDgDMslJcUjNED66vC66b1XZjumXM0ISgNPSYjId3DELRHMAgLjGE7s
Message-ID: <CALUx4KRoCco0HA=Y_qFzSD=CegbJPUkQkvjRb1Y3UcgRdwQToA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_reporting: use system_freezable_wq to fix UAF
 during suspend
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0981140003
X-Stat-Signature: fiqzkietsin59ihttrquhqgb3rnsea4m
X-HE-Tag: 1785529312-997815
X-HE-Meta: U2FsdGVkX19IBXZOdTgS3fryAmTgu1bmx4UHavGFQFrK/Yn3q1m5Ehfofs5nEGo0q5F9l45i//TslJQilxIG7szI4CoX0ho9d1D05CBoqJzbdorw3N4FDWaLlhH2FWlq7Riyd9KoXEgIYnRyTGaD+9j3BGKwXvoZg2mDCB3IECsALQIZzGkm684e8DwG/EpjCvGORwsUPUUyBDVwzJ4uxO2UycGp/OsH2PSEzMBO+joqCGexyjEBYIrGMVLIb4/mxV7UWJ9LS/d6ysbqXYk1QPCaV/L1vNsyALfmOzFC1fkmgQpL5mQRzQzngrKd0RtBpGPVLKWkMFKTQDjWBQoMbvDzkMeO07E50LUCW0SEsljCZeMzPz0Jy7ug3/+TnasmJsEn8NzIy+Nt/XnOQ+LqcEq5+GMqA65VaceCfRFtBInALYtezrekVSMBkThIzreMHbGS6lWuPfR/nH5YiunIjwk/x7Db+JKpW9PmOBiQvUvwjR60JhlI8IXzfHngvO5ok9SmkpMdchMgI3FCsWFu4U2ncxKMx1zqeACOesMeJhdn7neizJOequehZLg8CpIeNR8YhJsvfyphbCF+Mu7pu2kyhUvP7SkkvAm5JcSlbZO2G6Xx7QnGwRKAYCaF9gzWOE60jRENu2VzxkptqX0/aequsXJx2MXcXstQBviD/GNorM6o7I4g0RwwJvZq1PaSPBnGFwsbQUPHXorXfPiKcIckGPk8nGM54nZ3oDmHo/cF83F/vM0a9Lew5Ew93jyK2pELSr3x1ppXG3hSj5bldi7ohCv+q7Z1hBoD0/dtZi6ec03LCcvBDFBgZaj/dRGkBJ1G05WliZQAfQDG2aujNGxiE4vM6NcgxQn+1sRSNXuDXwN7Z8YFkSNnmK0lS3m08ORzsFjsmCNeaR3GY+bpKm3tQivc44O4ymPlTVbLMqdMEsS2cpqv02kCMyia+CJtWKsQACTzilIxdMpvIdA
 0fxDo4jE
 +GXePNaSGX5kGko4IVnVIQjBpqDQEs7htAG3AUsDGdTfTQjB2DPo7SxJm7JRSQj22mybtA97iEWrvIBqgvgUYF0d2CSOehRXv5prCGbXF24v6ZvFmRtay+xL+TbhlU2I5fCj+SaQNmdd7Uvs8eYE0LNgFumISKuLtXhWI/YmUrJPBuXYqbQqU233Wr5RVGAijnc3OP4HJqDCQO3o2hYNNC/T2/bGHx3Ulf3J/0RSm3GBkFMPGtCN1WtkjN3r4k7CrwiVy+Hdju+m95P5cRTScJolMDbsvikCEdXIrmuFkFjkGZ094MjjR8xT2NZ6elSSy8jggstp975xCW+U2hoRCh4/oOj95BA7cDHVji1jtqnRyRM50Rglly+VX7VLaiom+APOo0xG6LLr2TF5QHxpiVfZNdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 2:15=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> I suspect rest of work items we have, e.g. update_balloon_stats_work/upda=
te_balloon_size_work
> all have issues around freeze/restore and error handling.
>
> --
> MST
>

Hi Michael,

We have indeed discovered a kernel crash in update_balloon_stats_work
after the balloon driver failed to resume and initialize in our
production fleet.

Alex Wilkins <ahwilkins@google.com> diagnosed, root caused, and
reported this vulnerability. I am currently drafting and testing a
2-patch series to gracefully unregister callbacks and cancel work
items on resume failure so that the VM continues running without the
balloon driver instead of crashing with a kernel panic.

I wanted to follow up and let you know that we are actively working on
this. I will send out the patches to the list as soon as they are
sufficiently tested.

Best,
Link

