Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4457FD2D9C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE976B00CB; Tue, 10 Mar 2026 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3D66B00CC; Tue, 10 Mar 2026 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC276B00CD; Tue, 10 Mar 2026 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27E606B00CB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:03:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBDA5B6B4E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:03:05 +0000 (UTC)
X-FDA: 84530319930.16.2C9FE65
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 023441C0020
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:03:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="SU4/O4FZ";
	spf=pass (imf18.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773151384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIavvIBtTtHaasvUFabIuv5jcPdC5cBsH9MQOa5Z8Ag=;
	b=3uuTkLBiWLT0enhLJgMX3RdGsxNy2pYpU4uHQCqFNYX+cWPVb6ywVGnJnrosR436RqyIDv
	WQVOUZ3RzjqO8Qbx5Rcmbz0v6cMwb6u3eq1OnGU3zplNm275P1wR/8GlJUxXtvh1Eeyb7L
	OhGdPSpyiYPDh22qYUl0hr0Pw71/Fe8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="SU4/O4FZ";
	spf=pass (imf18.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773151384; a=rsa-sha256;
	cv=pass;
	b=hBpeUnXYZb1BcHnXFAZvy170Wy+JugQVbfYFDmQwYlJ9vdxtxPaqTOqfj8Y9m3amdKAdGo
	hU+IiXoTygIIbYfMcsd/joSEsUIRdrkjAw6AuTH17jmseKmMBYtCvZf1ycYHAGeAApE80f
	DWUT3X0aN4vd1dEKyvn+lC27NbdjedA=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-509062d829dso508681cf.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:03:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773151383; cv=none;
        d=google.com; s=arc-20240605;
        b=Gl0IYa8dUKymVpLTJKaVtuEwtpxKIOfJB4z3PA/j5PKJm+wDwJ3jjZonCx3lFKxWqD
         HkluvEd2FvZ120Sgwz1DFRhd5A8fClhdFeM5BFZNf6nbeXvoR8ZNgiJKj1XkOvZ8lNqM
         4ARRHu3L6oJ9ewh4MgNRcx6kRgBizIaDrMN0vamGiOMnRMXLZs/bSRR37zz0B0VvqtKb
         yJaCvfuD8kjcJXpeMNacWAb1PzzfXN564az2OxmOyupsdXrAYlwEZVQ8X2CR4reEnsoM
         Ns/ywUcEz1vXA9iW2vJfSh2otbJS1ATvx5F2Pfk5FtdqhXheSnp/cHdCABDzvUZL6bF8
         D3jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tIavvIBtTtHaasvUFabIuv5jcPdC5cBsH9MQOa5Z8Ag=;
        fh=A6eTM6iDIgAAM+fR8vBLYEBOI4GchSzjydsf928Uk9w=;
        b=H58GN75CJ1PM48WNkjLoEFSo/6FcV0868oFEDMHi5tRcSfUaWzNBsidM0upUo6v9p6
         LfO5e8W1IRlkEyElYk4U0Dpv4OfvY3M8+hN5+plYVr7WEhr3oTZ9WTlNcEqcMTQjDXv4
         418528axsRYkGL/+QVcEGsaQ/66XJoukNZ/rESHS1LMNYGuwnOvs/p9+x35Qf2o45k1s
         4UUlz+x9ga36Y8HaRAH4jTGgqaRnhG60VU2xwN1nkHl1D1xkYof1/Kw9d5BRG9ucjHt/
         2DnAaoZU1qXNn9sw1LQM55aq/gD4XIFJTxmyTCmvHXa4EYwy0m6pftssxuRJjfENYkhN
         4Q5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773151383; x=1773756183; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIavvIBtTtHaasvUFabIuv5jcPdC5cBsH9MQOa5Z8Ag=;
        b=SU4/O4FZof1DVea4rlEvOpTbPPeJiM8DxU5oltNy7YuWBW/C7U+HZSs0GECeHVxjAf
         fGzqX/TKNAg4Tts70pHSGZKQ4JpJ8HiIidEu+m48/MY+BOseD50JWsO4mI7XlgbL61tN
         P/tSU7YHFhO3LrXTl6yoSGuPRsC6tuQp2B9a7/NinSpxQkTZ2x5j4qXCOFyMQrA+vaOx
         on7h9WtEYMqTPqaqO9PbILYCJ5QtiGVbDNcOxW2PlVgFyAbTIDpAZ7ODLyFZ13L4XAga
         VMibOPp9iJjj+D3/R0hNmckIfpnzWFsiiDUKYfYkDjAF/IJty+ABlnuNZYlSuWcP6Jkb
         eZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151383; x=1773756183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tIavvIBtTtHaasvUFabIuv5jcPdC5cBsH9MQOa5Z8Ag=;
        b=qrz1wkj5yNxMFAffdnD9Mg7AJzOVabQY9LYqmm+pM/iFFH2A0AektyKubcFXt6PkDc
         7Ebh1CJW4L+R1dnR2umdidx+bPg2NfkuRZ2IyVp3z/5Xta4n52rkZzYSU9//+49khxcp
         UVLjF6r+ZUj5STyvml8FQIPmh59NgmevA/DVwmCG3BE4C5LfWhTyALWxjJScHG5CC2Zg
         XBZvNfnDGYh8YN6+E9uLwyT6lEaG2fe19y6PGQAAUpm0ANwPzwg+Nx5Xx73DXMfaqFTG
         od+hxQ5h2AOAdZmt4WSmaa0BASOQ4oDSkOKfgPoW7Le/734cCXv7lCX80tdKgmzBRkus
         vkgA==
X-Forwarded-Encrypted: i=1; AJvYcCUIUZPZwJXCPyxbg1llfK6undtnNvxFZUHsh0WJboYKpk+3oRvweWMJQxK4kk5xYBgXq8ZLA0UNMg==@kvack.org
X-Gm-Message-State: AOJu0YwSzW5CQKuDpyNjIvaRAA43aOdTopQGud9QEgBgAlebs6bKcIIO
	vwWFl0JXYnNiydyHN+Nd+lEuyNQ+vIcs6a6llwbwxQjgL+Lj6XJp0L4EyGHdvTC6FG8klrPVjiY
	J8hVgjYI7FqnqyXEuNRDmsFyCEKNtJh6th8AU1yWm
X-Gm-Gg: ATEYQzwGCF0kHCBx1BsXuHtEQJ6qjfpI3p18Ifu6xFPghxDcp8xRmrCh6cez86fh6x6
	FVBr/65op/QC876mkVb69r3/YtXqIioUvCEtpRQii6DJiLmDozRt9pcCPstwVTJzHPcX4fufDaj
	v0cIGZJycaKlUOUvAtAUR25Aib842Dhg1UZ+cfr8XRpqLprbOXBxXyWH/iWuqzq/Km3TWpRnDYO
	BQbTbqj8v57RiUFCoeUov6/vXEtYgAK2D9fe/8obTIaGnkBO3D05o/KpDeyoPGxt9tbmGPn18kz
	hZpugiyO3k2VNmy62r94dhMcUcyEEP5gNkHzX7zRIeJK03l1DVZk9IJBuAPKiFFiaAdGYkeHuFF
	jpwJZ2/ANJg73t/ni5SaH2b4G+ZLdK4DIQWU=
X-Received: by 2002:ac8:5e4f:0:b0:509:105c:74a9 with SMTP id
 d75a77b69052e-50926f1e3aamr13927151cf.18.1773151382478; Tue, 10 Mar 2026
 07:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260310060407.1133800-1-senozhatsky@chromium.org> <CADyq12zF3cwzSFcKYiGAdJ_G-NVnydBRQn+x0fgNq1kVgof4Vg@mail.gmail.com>
In-Reply-To: <CADyq12zF3cwzSFcKYiGAdJ_G-NVnydBRQn+x0fgNq1kVgof4Vg@mail.gmail.com>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 10 Mar 2026 10:02:25 -0400
X-Gm-Features: AaiRm505DSdRTNRL1G8h-GZEtlrvi5UA2vbcMF3uI1SjdIgSiG4KGr1my05BvOM
Message-ID: <CADyq12wpJVSvWDzWb8Y7ZQAN940qPKRdHbmu-UCN1L2GkyH5Ww@mail.gmail.com>
Subject: Re: [PATCH] zram: do not permit params change after init
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, gao xu <gaoxu2@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 023441C0020
X-Rspamd-Server: rspam07
X-Stat-Signature: 9mihckhmoim1z4bc5wq6jnzmz8gmug84
X-Rspam-User: 
X-HE-Tag: 1773151383-602587
X-HE-Meta: U2FsdGVkX19dvRmv0+iYLiQjqai9ZXuu/yRvNl+lpGSHTK8EdVxXNAznEEqw3KhRGKLFF3iEvn1XXapYx3XUZbDRHeIk+1vMLcyf6V40IriZ1WdGg7zSWAI85ww7Si2nQj8krdA77/h24zt8VKc8/FpLNROf0z0fVuwgs80xhesfUBw6mNQzjLW0eKOqJMeZAV2ax2Q5VYKvqUiVOO9aAsfbnHGrjOSt0+bXsMMhChVi9CG6UQJ+bOqCgbR948wVyKukLX99rgBEK/CBq5szmshzGPtizW9gPIaKn6qQbUf9JDS0yP8b3D8jtY/MZKWogB1f43U26xGR+PgIFQ5i7JUpY9sYw0T/kzWMprMHcRqYehHge7Rk5AadP37pup5xZEuA01btf/ToBNG//4zGwDfh8mxLJQEDTODV4mb8rFVBo51IhHphgC40wIKhvh8SkVxKVWG2hLwGj2APdjZFxH9iW63FVHsvMu1xDUwNkrKHnK/8ysAPX1G9X4/dIyfmPlbBNI47jm33wex03YHDSRowt+XoUrWQTChP1woFqADGrvbtJBKvvCdX/FCy5M88OkEtcpIAOjxw8L5bIs0wSawuotxUvwlyy1odO+jtE5M7sN10j7UnmG046HGt6+0LQf5lu3ajHLe81ctbysjia2mqlvXtV6ao3zO6pV1AZZn1tj9ZgsDweLnW2a9EnquTMxQQ/pTM2T2mToPg4xxlJO8X3pWZ0TyfeYWlc83PtmHT3cYeUSeDYGfptUWv96yXMkHmX5T55oKQBvTtM+l8b01C8YPEvXdlFc8jVSTZMOhves9kQhcYgexnpVdBAIqf/EjZAOaL/WVDSMzx9D3fZ4d1rIrCk+7RQ1zK2AUb8c1GGPyBY4fFTvBrH9ch8ApdXAbGmMyJtA6VR5XgIannGjFu0x9udw6j82FLb7KHzcNsWMTh94ktBMviuWU/WnSK9CmmOibgKjrmmyR3UNK
 E+AaxCk+
 aJsYQQBKKY4137qEi+o3mU6J2RpQgmg7d2BQUl/OWqyOi4P6IE6nGokjKE30ZfRC3xxEUzFct2ABbNGTs30Jro/JYWIFNkhQbwnkeIbqxGLXLnhKo2lW1ygHNWp07aklSbMzmWkk2kZZoBb7ETJhzQorjuKpxYylLCyv6vc4XS5aR1GUI1Q9rmPIjBp0kD7YC/Wtku+xEuGOYVBS5zz2rOKykO8wsJ3OBaxv0+I5/1oOm45X+8psTzAxPvd6mE12zjGOf8hApDJIljHgRvH7KXUzJyjZUa4jw1acOmFrn9y8JBfaEnIzLIC9H9DYHnWFhWhIqqHrszFMUpkmx4dgnBlBAHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 10:01=E2=80=AFAM Brian Geffon <bgeffon@google.com> =
wrote:
>
> On Tue, Mar 10, 2026 at 2:04=E2=80=AFAM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > First, algorithm_params_store(), like any sysfs handler,
> > should grab device init lock.
> >
> > Second, like any write() sysfs handler, it should grab
> > device init lock in exclusive mode.
>
> comp_algorithm_store() and recomp_algorithm_store()?

disregard, that happens in __comp_algorithm_store().

>
> >
> > Third, it should not permit change of algos' parameters
> > after device init, as this doesn't make sense - we cannot
> > compress with one C/D dict and then just change C/D dict
> > to a different one, for example.
> >
> > Fixes: 4eac932103a5d ("zram: introduce algorithm_params device attribut=
e")
> > Cc: gao xu <gaoxu2@honor.com>
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
>
> Acked-by: Brian Geffon <bgeffon@google.com>
>
> > ---
> >  drivers/block/zram/zram_drv.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> > index c41e1257243f..7551c5e664a9 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -1769,6 +1769,10 @@ static ssize_t algorithm_params_store(struct dev=
ice *dev,
> >         if (prio < ZRAM_PRIMARY_COMP || prio >=3D ZRAM_MAX_COMPS)
> >                 return -EINVAL;
> >
> > +       guard(rwsem_write)(&zram->dev_lock);
> > +       if (init_done(zram))
> > +               return -EBUSY;
> > +
> >         ret =3D comp_params_store(zram, prio, level, dict_path, &deflat=
e_params);
> >         return ret ? ret : len;
> >  }
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >

