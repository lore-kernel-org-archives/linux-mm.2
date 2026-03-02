Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E57E9B368
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5934C6B0005; Mon,  2 Mar 2026 06:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540506B0089; Mon,  2 Mar 2026 06:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4181C6B008A; Mon,  2 Mar 2026 06:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9C86B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:10:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2D1C5C6E7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:10:51 +0000 (UTC)
X-FDA: 84500855502.25.B29A0BB
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id C37C5100004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:10:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gEds2REw;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772449848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAyXrDD4Yj8Fm9bpd9lbcg0XkyU20IsWnG2Gb3iPSsk=;
	b=cqSxFwhnr1wP53po53UvqCdFhIQiInJ91SPH6dKMs8agWDvPZxsg2ol/XA7k2ZrX0ZvRdd
	j5jzM8QDs7ZCcaK1g0287JONZSXtpWbpScSdVK7toaLVvL/iTW9toXoiwCJQzB2HJ+UFon
	h/V3TQW/D6Jq2uh3qkGDbW5o7A/+bLk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gEds2REw;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772449848; a=rsa-sha256;
	cv=pass;
	b=iS2Xes/ByhZLilhHeAafk9Pdb9CgRuISpClOiUnsabfybmvhvgM79CYXzxgnrRE7eJNwWd
	UHmqwz7PtCiBFOYPmTmkCbwmFb5a3B0kFuQ7L6Kg8rcVqVjZLP1tn55oawy5dqPcgIeN+2
	cLIZ7I3e9eYatD2h1JQDSRgI34fN1XU=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65f94011dfaso7591460a12.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:10:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772449847; cv=none;
        d=google.com; s=arc-20240605;
        b=Xi4s5AxhJclKoMk/5LDY3x3tviDyPfNhW9k5Zroudz4k2mU+jBVWbbPSue3BiNmDl0
         NeiwZ5FYEQ1EB+CDU4Hyu0QdHMXJfn+RH7BlpkEjANkwxr8iJLh7EyX/WYh4q6KejO4a
         n3OTJLz/oKWqhQrjOyxRkBsEHhjPaUC/3KG/evaOyv4m6jTR2LVBTXJe+P8/5Zc/8edN
         tzztfGN2IdPEYt+fENFYeoJCtXdHm2hOreFr7RSxNjGK9o9TfNCw0bTdIY7EtmIP/Wvs
         x2B4tReVw8VMdxLiYoW+Pm95X9490Sx7xQm55KdCllRCxQgWsRmgpwgFJv4zinVgNQ09
         fTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fAyXrDD4Yj8Fm9bpd9lbcg0XkyU20IsWnG2Gb3iPSsk=;
        fh=Sfo0GaN2FjPYueiIO5HDUqUatDGi9I3v5J2WawE979M=;
        b=ZEgz0H3mqgpITyesUwQflIwLHugVMMoAt9veYlIAO1o3DihsNACnNPhN1B0t26IsFo
         6EOpp2bO2k2qvB7PgZPOM+9HHtRpxC60UL35XNco0F5JavRucHim48/JWD40djy9YCXN
         7ZRr0o/Ee20XvGFOAK1MI9qBLIn3jTGTUYiGRTKj1+wybvVInyMe/SX70apRfXGEzDGY
         8Gal1VXdcYAAUZuHF+PTm80/wSXcCMO7KBlwkBTuPxKBkumjQ4VCF9E9acoy2Ql/zoTO
         F+jdUW4DSYi1yo/h8z9h82l07/jjhGKnojTgdhCoKRDzhCx6qDvTJgEEN37TbAl83x4t
         Ulgg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772449847; x=1773054647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAyXrDD4Yj8Fm9bpd9lbcg0XkyU20IsWnG2Gb3iPSsk=;
        b=gEds2REwaA1K4ZKqdxo6hFbKK8zz+U1meIG3vrhfXys409MC27sulorwmTysklQ4Og
         KCIOWAkhJOJX9FMMLnwIFh0FCWUcBOT3NOcd9e22hLakSrUbNsYOrcBotCehMf6M0AF4
         dF7yonE0ED3n7az7Qsth2SurTVwaeFr1OX/YxmQpyyoM96vHp9/+TQ87SAHTZ4SQAah5
         JElNqPzkp68vIlNHI5Rpj7+CV47tZr0LZD7uKijyOf52DkNLZpMzhwwHui9kRwzZvm0S
         IFpq+h6aaXkASltc5RzyrhoMV1trEkkK83IEXPsh4zyrlZysxIFKxlfxvjDzwyy0l9AH
         aiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772449847; x=1773054647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fAyXrDD4Yj8Fm9bpd9lbcg0XkyU20IsWnG2Gb3iPSsk=;
        b=UeGELOU5QGlKYlOjjhHquO070MiWD7OQRG2qoxmi6dtNOG3xk0l9OBFzA4+F+klYM6
         IzjcymvP+/EnAf3jH7vOR0zwgiEr2E8kspHfDi9z7+MNtADeKeD2l7cBYfgM5Km5yU1S
         MvLl4C0nLQIQDhs94H4Okn7KtUX9KXl/sJKhQnnQ7R9jm7j3/xPet1buqsOC5A/fuSxz
         ARQAH8j0hCAkJL2CqFXMQeRxOfhGYDbuvl5Yt1MfZKmnb0cm1VkmFlXbHG7ozhFFeRf+
         W5jQZViaeawxyoVZuESNvlGudxih9JziNHUHHt8XDtMlEbrLTWl3IGMx/Ax82JDSkuVQ
         S9WA==
X-Forwarded-Encrypted: i=1; AJvYcCV38+YvoUGt0ghO29VWnaGD26KU5KdtZPvfWosxsj5+PSAXE/G9fTlxJjevl83Hhlzan4JRt5/pAw==@kvack.org
X-Gm-Message-State: AOJu0Yw04muHDBvGQNsCG4FRspjUukhd6lSCiIBFfHDd67LSRYA1dZn8
	m7HsaqvElEIn7SYVpmrvyt94sUqQqOCJEHeV58sQxCZ86VS8KR1z6b0BvSMKgI2CEVtGZ+HmWp1
	YffSZpHaftXi1mb/3v2PTIJR292ws3G8=
X-Gm-Gg: ATEYQzwkAMQZfA1eRZZSvavcz1iDkLrknyJQEiaFd8wXiJ9iXCK5crrXKXTp73DeDct
	kItbVxS3xGl3pl250hGihEO0mQ5N//h+riQFFyxNwT8IcB7wkP6ZIizDjZ3rldlrpzbRg8n5wZ6
	Tpyq8W2RcoEH+A/BVT1gqy/I2plYGUhBg/IqbtzXgX4EurnqQwa4T3qDOm22N8ciKmXFWksz547
	Fs+J18CYLS6KGkTNp6bEV19F28gjqQcLfXmx3cJjtvMMuQ81P41BmIupYVN/LBa/GieMxkh98lh
	LmqeIN562Jf9MeTAwx/ZHgQS3Jl1O0t+rf6fvQVa
X-Received: by 2002:a17:906:4788:b0:b93:8d6a:7ec8 with SMTP id
 a640c23a62f3a-b938d6ab5femr511575666b.24.1772449846833; Mon, 02 Mar 2026
 03:10:46 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <20260227033013.94901-1-21cnbao@gmail.com>
In-Reply-To: <20260227033013.94901-1-21cnbao@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Mar 2026 19:10:10 +0800
X-Gm-Features: AaiRm50rf3fJlx9CnoZTucsjismzO0YI8AXEXIv0sgC2COIgw-pxpHYoNfL7S-Q
Message-ID: <CAMgjq7CDgap5pe_xVemow+SbaRW+ERXZBZvkymhFWZQZdDM2Kw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF] Improving MGLRU
To: Barry Song <21cnbao@gmail.com>, David Rientjes <rientjes@google.com>
Cc: axelrasmussen@google.com, linux-mm@kvack.org, 
	lsf-pc@lists.linux-foundation.org, weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C37C5100004
X-Stat-Signature: oz3dit37fmwej3qtfnzsc36e8phbgeay
X-Rspam-User: 
X-HE-Tag: 1772449848-69522
X-HE-Meta: U2FsdGVkX1+h6u2trR0ymA7ba/e9tvRVphOwf8ZZaO961O/lVv61J0CmkMWOggYY1WZilx+yMticUkh1YoOVP69dyAPfP/di+ZttDcFDJcsTuKKxvlwkvkKZ0mcpwNwMf9R9YC/I67OR8aMimdG8T7sWtq9GEnhRwN20/5bqAA+bO+R4jhLMgGED4y6E6K9OYcfkgMF9ahaGcKTI+lZY/GMQLlVP3q3zavTFZAwmDr/t/n5/midzK2bT6X+iW62y5fi9hdEbDZXKF9+MKllPm0DJ+fix91prUO6OF7Vgfg36rUad/XmMt439A96rcDSVjzcdVnQNW2LjjIISjb04PICWetY32ggGuQsGskDhu0CufJ9EwII4gx5GpVAXoJ/lPMvRJ2q4I30yTimOZJgqYhIEe38r8A6A7lFL/hqSZ/PGn/6YQnP3vzc/IHbYtX4UQlZUlQVz4WWeEkJiR2nS3eJsMTTfF7bqKjkinDnB9/GMtYewS+CfDS9eb1nHClIdPtuAZacN2gIHIvTKqTN7Cuthu0W2Ckq5td/TAyvRSoa4WLN0vAUTLi3dEFf5D8QWv+cCj2BaPMfWgWhYYfzXQ0P1kSS2UFe4fdeBEWWJ1mUH1QanT4xkVlFezgBaUM7UI/jnSsSjBdp0vQvIGUTyXsrlIm0dWgTx98pnaSaEe+pnb/dQIucGVS/6PAg7AYQtzI+LPoOI2cy///QpNNxpWA6OzQibU3lWN67Wt2m/Xvcj9NkIgYyrU8tm+670UFaYfP5nkCmipbXaw2XpEZ4kd9BWxinvhJcTAITdO+1+QMVYdP0FTw/1NcD0Z7JkCkwItxNsuc8Z7ySh1hhDd3RgUVeQskxQhpweqNpQTV44aaKknzQ9WpMdQV57dGFY5+NtfEdSIbI/T2b5qM7QDoLodha1+MVwnRKvMTHJ5+SDRI7eehkTmx1f4lsy6xFGEqc/u47o3O/buFOmeryd9uc
 FKps3L7z
 HLkneJe0uwnqvRaRCZc6T0EEbk0fSTCt/sUkDt+IHL+xKBLvZ1B0ieFn9zLgDqg3ko6UOvwKRhiMzprYsyjnAOWybXfOEgUqI3lPyIB9rfIO/RhcOJ0Es3FkxwulN/up23T4Lz67ul4MWJ1J23WCtL98P9SO/4heuEenKjlm/4vABf6rRDAucwwVG2bCrydWFRjPtjoiAlw/ONs/FFVSpbi3THOKKPzQ0JGzhqUK09fuNjnyUT7vET0mPhxjYoDykja6ZO5wP5GDOgRFW5NWBa/wVps9yQipmAl36fjEiBuAKdkFFwPoaYloS2iULSKoU4v2Q2OZ2DN0/zRRXPYzGWE6jS9KpvW9XrsdhTCo35ReVd1RtCTCEiJzFBRrN/5iQxyT3uQmTZ2KLSteykNM05LzFosaG22sKZOqJ1X0r/UswZ5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 11:30=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
>
> > 4. MGLRU's swappiness is kind of useless in some situations compared to
> >   Active / Inactive LRU, since its force protects the youngest two gen,=
 so
> >   quite often we can only reclaim one type of folios. To workaround tha=
t, the
> >   user usually runs force aging before reclaim. So, can we just remove =
the
> >   force protection of the youngest two gens?
>
> I guess not=E2=80=94MGLRU needs at least two generations to function,
> similar to active and inactive lists, meaning it requires two lists.

Hi Barry,

You are right. But I think that doesn't mean we can't never reclaim
the folios in the oldest gen? Or maybe, just let the kernel itself
perform aging when one type of folios is not reclaimable.

We have an internal workaround for forces aging, and waits for sync
aging if one type of folios are not reclaimable (without the wait, we
still hit the MIN_NR_GEN protect again since aging is not finished).
And without the MIN_NR_GEN protection we might end up over reclaiming
without aging.

The problem with that is that the OOM killer became very slow to
trigger since aging is costly, so the system will hang for minutes
before OOM is triggered when it should get triggered immediately.

And for the OOM part I saw David Rientjes also mentioned the TTL
config in MGLRU, I do think TTL is a good idea, we just need to figure
out a good way to make better use of that.

I think a feasible solution might be (just idea): implement async
aging; decouple aging and reclaim, reclaim just keep shrinking
whatever is oldest; and optionally improve thrashing and OOM with TTL.

