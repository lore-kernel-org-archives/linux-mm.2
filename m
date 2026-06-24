Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E816CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4D3A6B0093; Wed, 24 Jun 2026 10:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE756B0095; Wed, 24 Jun 2026 10:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF916B0096; Wed, 24 Jun 2026 10:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71D966B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:16:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDD22120394
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:16:38 +0000 (UTC)
X-FDA: 84915006876.15.B31EBE1
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id D8DA68000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:16:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qZT/aXCe";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782310597;
	b=cKVvYWTWdWRA3dAHzvujWlFozb9bZ0yR1maHLhrqvyUGmvpqp1S6yZUHb6+DHblVIwsioe
	JhayTB687QFt4EECMq98Ax7yLl90KhH618oV8Cg23FGA8GPTmN7Zmc8cumPhPIzNbpFisI
	h/urkJpvL9nvg0+jXhjRx3P4npPh0j0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofp3hEpmgBuA2Xl9gZnye4TILLUrjr4efPci3kviMPY=;
	b=hmnXeyKEi49L9b89gKykO14hM3TVzWwF+tOKe8EXOFY/xDLuRSs1CNnbvxEmmGcKkJNjSc
	MtoznxTJJ+WKj/Cj9fmlw4FclpXAKy221TslyrM2YTQJQN3FbBgki/nTa13oKGQYxzwq39
	/zF+BtY18ycRgUgz2D1bQU+aFporbAI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="qZT/aXCe";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c0b97e268f3so155526666b.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:16:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782310595; cv=none;
        d=google.com; s=arc-20240605;
        b=WOLkpWd4ZryKhEGYjv4Eg8DKxSpe6/fmhs0dyrY4/cKIf0tZtAobku55Th693rpbsO
         j8E0pTS1cCAlIy8pPhnFRlBjchXg/xGLomT/4YLrlanjzbxieT3Fd6w8ISX5gyhruwnC
         bfqBkoDGqmKC6z2EVTtwH20P1cCVnHSactucJn+BIhVRcdENfznIXtk3+t/hI0UGCuY0
         7IdERwSsp2cOq18l/DOGtR1Wq4n7YWKL2bEeHc0BvZ/RXLHN3Fqm6BMJPKaL8ZIVUeNY
         +tBbCBCb7yILEnub9sdWWtgGASOmshwHV0Bb4XrApKDfRqYktwxF6MydDLDiNJRM2TW8
         0fGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ofp3hEpmgBuA2Xl9gZnye4TILLUrjr4efPci3kviMPY=;
        fh=pJY7IfDYTOim97sIF877ER2ZpzcIzwQJyzasHfHxYeM=;
        b=fZmwASuJsmk+q0vK/zwBWYN+cSBkdPfMhH8xPw//UsK/RqrxCoBCloCZw43DpVeAA2
         YSP0XXWuTxvV9JtVuV69pWQaDmAPM+wJps0uXmBC5fQaSnHJ/VkVG4wGJduXm1IUgvMj
         riDY4vwQvqzeVRRUL2ykCzyKA5cBD+aOP/xloW0yafXWwbP79ZGR81n+Je9HtR+4jMq5
         tVJft12ASyOkjNfVV53JNYF6IqpnXWN2W6iN2BIy0jIk6B3wf6iG0GieCdEIw+sZovlA
         xQs97/gevbEdZZY09ZSlioGY54DI69z8YIaVQCASamVXgLLf05XKKX7heJwyVtyTb78h
         ycMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782310595; x=1782915395; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofp3hEpmgBuA2Xl9gZnye4TILLUrjr4efPci3kviMPY=;
        b=qZT/aXCeKH9DeFuVTm9IrN7pGo967Eu24jJ4ia5gRmESAy60KulUfxxYYpTW8MP5pA
         42/vqDobU7s3OZ+AMyCfmsg5ibFyDL0+AuGUoH9SKCO2+6N1fY1DplkOdx9WipmupNeV
         v6t7hQCPQYCZU1KlW8BF4+oRiFKoLydHJmPOJ9g0QH55loqBXh2qliqkVNVzJNmCVHg4
         skQJOs8NW8ZG9VJARrWUGEtf37EeKkmRnEs6wMYy/M5+3bFm5uorkbqZAfeO+Yb3G1wT
         PhlChzk6686NI/49arWsBQFmZ6SJI16M/nopUTUSEpjRJ6oAXRHHcih1wkZ9z9vLpiSz
         fBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782310595; x=1782915395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ofp3hEpmgBuA2Xl9gZnye4TILLUrjr4efPci3kviMPY=;
        b=jvq2HZ3blHnMdMWWnTboWk3AuXLnGEVC+V8AZM4a+0ZgEvO5TIVKmbzbfHfLVZsUoa
         gxfNLb2B8wgEpf360LcAjIXaEsOyvF5ZWORZ2BfU/xFSdF3wI+ykn9eutu+SGrUConib
         lX/tDqon6re7jumoGiCef7Ne1BQGpM/uLfmWusKfTSp8++hJy66jMk0E5zPQkVcpbHp5
         LzYve4rAl6xEiU3Z4LchB9CV0nDepO1V8rkoSf1eql567Q2CY32h0R/W+y28Pj+c4FOo
         2KvWgmehGtGhCa8krblUobRJKKpdGXeLDG9tuwjcCyDe58bSaEFG2orTx8Zp1EAqcb0w
         NrpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/VP4ZsS6QGxf8r1TtHzyhj3kDjRnG18MDcVS/OVZCEZx1GnXPt8tFm9wRKOI8y7x+8TYZi/7YSlA==@kvack.org
X-Gm-Message-State: AOJu0Yx719tbR2qvdHnxJBwAA7rjFv/rA9ZCOH09QsJ97/6TLQkZ01VY
	E41ep46Pw4TSwtmkH9JSYOcjiuLujSXTc2Ml+zsABe2q785ljrf/CTUyqXqQpqA9ZoEZXtMSfX3
	kt6hjuIfrvsxZLGrqbcQqK9yGera82p0=
X-Gm-Gg: AfdE7cnVnBr1rqg9U5xws3oX7hVKPxZbFOSosKAjJfjuem0abF6pRrwJsd4Oiqx3BWi
	k642KPtAR6bl/j+48uceMMmOiVZ0PR8hHw2uJfBHuYdV3Obu5T3AOJjtaNBI3MvAhmyA0KYOv6z
	Vg+cbCZnBB7Zrr6XP5gfGeB0i16xTVQOym1+qeIK1hLYiqbmzMTTph0O/Q6R2P6jAU/8tzyenMP
	y0hhJWuqADV8dCypMKV60323nFHEGliSZHzhNvjtT3wkY5l6QPnQ9eILbAyl0Q0M26N+6TqxWQx
	CC64e4NWMrzvisIhIuBoJGR4awD4yvyT4pt5cW1DQg==
X-Received: by 2002:a17:907:6092:b0:c08:93fa:2a62 with SMTP id
 a640c23a62f3a-c119ce79d5bmr206413566b.2.1782310594693; Wed, 24 Jun 2026
 07:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com> <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com>
In-Reply-To: <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Jun 2026 16:16:22 +0200
X-Gm-Features: AVVi8Cf8pFFkEx_V7HqzrhdruZGs8cQ3Zufmxz4l6Wlncf8175EfLgSWMtHkhw4
Message-ID: <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8DA68000A
X-Stat-Signature: utxtjww3spggzrritg6uw3ngg6gqdf5g
X-HE-Tag: 1782310596-917876
X-HE-Meta: U2FsdGVkX18IB177EOCdrZPWiB0KN4Csc6ghXs275ul3I8yOZPXNNUIt4a5zpdIe4tok5JmAGi6fsq4dPDQNu0+sCRk/+KGBIQ8pSkQ2uf92CVj3EtiPTSkFk9SQs3QSvJPVoNURW3jS/OKNPS2UEQwyRmMKPhVPLdOAkilQS088HpzbNx9QymGTms7cdnC67yWfZGrPT5wVWKy2IKl4F2n2ZEAutfvSUAsty3MaXXQyHSfc1mztTus/jQuXK970U6kdXJ8eZBKLeyJsvR4Zqzm/CiLm7/7ATlxT6LijdNIwsuBCs+ZBUsY9FDaFoqEHvtWEHvZy34CZKrKFxUBDraSN04x5oAePoYOsYqr+ZoaH+Wo7QoBsfV+UTdfRKADunvJcQ6PChgxB73zINLtY17W7K9hyGFM0iZVP+Yb8VNpGtu1QB480wAPqsGPaQSdWx/AI5BYwieuTPyDIkpfJiU/sQeIO73xyEytyBgH/J4a7QCO9gHM+lW2qmRxYEdlDJzbHvAH8p2ACVYW20PjMnrXxmyChs5X5hFdsSZ9/kLOIFOxxYIuvfDiLZRBeq4mONnT4wknohCBzIo9dG7pKg1GAgPIneX28FWunasY5mMzV6uBNeDQ0nlTLm22E+k2+DKmjT9sqBfSNiQPxFgf3vBhmYJMEdIoUZ/YLjXU5EiIcyiltRiezWB3Aso7RZjIlnjFvxqOLPICLVqhuKdCSxQOa4B7n6bhGYrGOp1EKd7lxt0d2corxqP396QsV/kP3qNRscxlQn/9Te4tiybm8AYPw+yaQR/KtaJAmh+u8zipLi2UIvyknYVOsloFsSckXOpd9T4OQvHM0cVIaRnbDd+mqGtaXtuizU7z90SBK2x9SJ/wgFgc9DAtLY6eYgKnJzf7Wk4yWesORdKk73zuVB+8rCGASbtAFdxs7ntnpzycfuO5rL7bjHbrFy1Vpms7eXm7g8CgOaxjnLF1jwtD
 RcrUhEtT
 V1J6b6GyXlvKR7M51UOBmiJmWjwtKP8xDkTiUISCupbJJNCJa3d8kUh4DyPmz3TRF8aew/HaHFZTPG9R7L2dRtFG/6kKlsM8IlPTdlV6uXzx5iPuu8SNdxvsm4Ii7VM/et1EQUlMSz8c+YyF1sJIrWowzkqFwbleFveorctevlV608rypb5gId6P9vCxqzfl3pMwXObSmzUETrKwJxPLz4g8C0K6TtG3Te5m/EJ522v4b59R2+qrZjJ3eGDarm6oNnlz/5SmpIwhFHTjWRn6wiPtmfjQ+Mvz8jdTQnBCg+K3aJnsQFfysZWWElQYaNi3+gtFPkewivYna3IzxdO2k27RCqNzAbkcWrmzwUJCIgrWK1WYapvA9prl0PyOKL/vr+BOwFlUDNkTr25toRJ5VG1qUStE1W5efWgK7yrXR6nyfW36GRlZilR0mcDZPJvBNAOEse5KVJxGABNWgDsGc4vf8JsEM0jv9BlPn0rGmutAvrkZL+vhlxYGfXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 1:45=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
>
>
> On 6/23/26 19:12, Nhat Pham wrote:
> > On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
> > <ptikhomirov@virtuozzo.com> wrote:
> >>
> >> Overlayfs forwards data I/O to the real (upper/lower) file, so the pag=
e
> >> cache lives in the real inode's mapping and cachestat() on an overlay
> >> fd returned all zeroes.
> >>
> >> Implement the ->cachestat() file operation by forwarding to the real
> >> file via vfs_cachestat(), the same way ovl_fadvise() forwards
> >> for fadvise.
> >>
> >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> >> ---
> >>  fs/overlayfs/file.c | 18 ++++++++++++++++++
> >>  1 file changed, 18 insertions(+)
> >>
> >> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> >> index 27cc07738f33b..a7e252a91ea43 100644
> >> --- a/fs/overlayfs/file.c
> >> +++ b/fs/overlayfs/file.c
> >> @@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_t =
offset, loff_t len, int advice)
> >>                 return vfs_fadvise(realfile, offset, len, advice);
> >>  }
> >>
> >> +#ifdef CONFIG_CACHESTAT_SYSCALL
> >> +static int ovl_cachestat(struct file *file, struct cachestat_range *c=
sr,
> >> +                        struct cachestat *cs)
> >> +{
> >> +       struct file *realfile;
> >> +
> >> +       realfile =3D ovl_real_file(file);
> >> +       if (IS_ERR(realfile))
> >> +               return PTR_ERR(realfile);
> >
> > We're propagating the error of ovl_real_file() all the way to
> > userspace right? I think we need to handle this.
> >
> > For example, we might get -EIO here, which is unexpected and
> > undocumented from cachestat's POV.
> >
> > Maybe handle it and just return -EBADF or sth like that (with some
> > updated documentations, etc.)
> >
> > The rest LGTM, but I'll let overlayfs maintainers check the
> > overlayfs-specific bits :)
>
> Yeh, we probably can use EBADF here instead of propagating:
>
> Man cachestat(2) says:
>
>   EBADF  Invalid file descriptor.
>
> not really a bad fd here, but probably close enough not to rewrite man.

Please don't do that.

Re-read what you just wrote - it is ridiculous
Because of being lazy to update man page,
we are going to send a confusing error to user which tells them
that their fd is wrong, which it is not.

>
> I'm a bit hesitant though, since in other overlayfs operations we already
> propagate, maybe that was by design?
>

Exactly, plenty of overlayfs operations return EIO for unexpected
conditions, often accompanied with some assertion as is the case
with ovl_real_file().

Even though many man pages don't document an explicit EIO error
code, it is obvious to any experienced sys admin that if EIO is observed
they should look at the kernel logs, because an underlying subsystem
may have reported critical errors.

But in general, man pages follow development, not the other way around.

Thanks,
Amir.

