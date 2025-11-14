Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BCCCE7B12
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2C88E0012; Fri, 14 Nov 2025 09:10:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AAE8E0002; Fri, 14 Nov 2025 09:10:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A05A8E0012; Fri, 14 Nov 2025 09:10:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6889D8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:10:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C31788722
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:10:28 +0000 (UTC)
X-FDA: 84109397736.29.8AE95CF
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 17CDCC0016
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:10:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sms9VdUy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763129426; a=rsa-sha256;
	cv=none;
	b=TiBz580E/nvqiLnVFdzbp3NqltmGZUXPE7+HOyvXQ/kkUX5mkTOlO6U+nSXN8eInAT1uRb
	SM5zKbX32kY3uFQZD9KojnonCdlkN/7XtfoA5FRoKD6dWDFain4i9rdogD+hWOR9koK2Eb
	91o9w7rUdsAozIy2C035Jl1ItXWaFEw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sms9VdUy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763129426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUyLyvVVKlFsH483G8ekZl8QKBp07gDZblbUWMC1jGk=;
	b=VeMfG+f095bhtqpHsbcZ/XDUfZGxOwEvEpvvRDEE5TPMofZ81yWEkDk+xgKBN9VJfuPb39
	1DhTVlnfP3hsaWv8zwG2dHy/N7KkXyqjGqRJ3rY7gtBzmqkIrA//geK7n8HLu0ximRIUm5
	Ze9XllvIyxB9h6dJQw7KEDtXwobIwC8=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7370698a8eso68303666b.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763129424; x=1763734224; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUyLyvVVKlFsH483G8ekZl8QKBp07gDZblbUWMC1jGk=;
        b=Sms9VdUyyh4bZr/f0NMIxME1zEZiUhKUcU4g0/jLtXaliMwlO5s08nH8ZFWE76ovXE
         pHJNPConIErLkSp2ov4I7KyRc6rId+kqWVV8EvuJOyCHlDqD/nQ0GivdlWnK45LiFuHr
         nejGiBvCyMLmHSgOwuYpOyz9vVL1yRp/GOwX3SPpzULyigtS8EMvC4K2KeXwcavsijya
         ZdccE0SjAVYFmUi73NNKKDPEE+zw9m/0HD5ssQwj/7/Ym3ffby6jk9aZt4/BzayHs8hH
         1Fx17DuYrND/+reJo0lD0INF14iW4YwCBE0G8T0uZGwF7PEy9mMWHmWUlWBN9wZLaZ6W
         mgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763129424; x=1763734224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wUyLyvVVKlFsH483G8ekZl8QKBp07gDZblbUWMC1jGk=;
        b=YYe51wM+gvFyt693Wri223pd7cvA07L/pYezj1+nvooXX8ZBpXO8QludF77FhqcfBZ
         33MVmZcHnxMXE6oRINXuodxJQCU6cEcccftPoGPBtZlYlEAPJf8eoesPtej+winLo7ux
         mkDgeh28C5qexQF3vR8+T3QIt+/TgKok3GFIf4fiP7sZlP5vJrpVNRpA8745iJyeUGYT
         CogQ/FThgLuaT1nRzxDALlT3K5SUdx666I/dn2CxiXmG9lZ+1Imo2wQ1YFvGq3TRWwRP
         3yoB8eTHHrcKOaIYXYuHSDOuTxXz3AmCqVwVUIBrYDdQEF6V1jT8rrv523nOxo8XTckb
         DC8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXy2DpXpTCk2nX6mduOWDaSwVRszBnNicQlDsCUDxBoFoQmfeVDUTDzZn+4JjVlb0LUbcdKxbP+AA==@kvack.org
X-Gm-Message-State: AOJu0YwSbVQavIiHTBvmUXBdFGsEh91j03saTQf3Kxiivw4bN45Lopza
	QegiNsuJzv11N9VqoIZ99S9EQsrj0BmATvp3lbaWea0fGHLEBhN43xFmH9TP3iN/IJC3xZnFi9c
	KOhwIAzqIabMonjSJVVGqa2My8n6nNHe1KUwbBiA/zQ==
X-Gm-Gg: ASbGncsliPQ1WLZstMv4TMm/luaFvDWPAJiq6ApRqFUBFVLllWLqJNi+PyaHGzZ0IMd
	SjeqkLvTPZ2rDr8+ESaFR7Cjlq0c/Ap3Iz+CCuApBrQlA06wUQGFGpumMwGY2mbzD9LpB+RgVVj
	4uPlaGJpYxT9eXb8SlyYePO4B3DmnaIhfMorubqu5lmOHSIUbCMaMhNAtz1QxQHYy+nPAi75QBz
	qKrAr2dXdeG2ZmG4va8L+tNGIiXIHJXhdqH7T6pDSZ9sUJ8yTEF7gQXrvWQw3tK5dCU
X-Google-Smtp-Source: AGHT+IHfDqjVq2HQlgOvTYSXDolFUyeHkC2njHwkXXlWNiYY2vI3dgM9DBu5caW7N/gKzWP7vOw7EXXGJJQDhW4sn3w=
X-Received: by 2002:a17:906:6601:b0:b73:6998:7bcd with SMTP id
 a640c23a62f3a-b7369987d82mr195682366b.23.1763129424454; Fri, 14 Nov 2025
 06:10:24 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-8-pasha.tatashin@soleen.com> <aRcnRFnqhm3jkqd3@kernel.org>
In-Reply-To: <aRcnRFnqhm3jkqd3@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 09:09:48 -0500
X-Gm-Features: AWmQ_bkHcsPKYBwcaJBkDElGfbsE2VmqDOwwNe9Hzx_22lS14GpcHvhkYld0Zm8
Message-ID: <CA+CK2bCO=Hu0a4P5-_a4QrOSdKLR7OXEk=Nsz-p6TvjEHV9rwQ@mail.gmail.com>
Subject: Re: [PATCH v5 07/22] liveupdate: luo_ioctl: add user interface
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 17CDCC0016
X-Rspamd-Server: rspam07
X-Stat-Signature: c7x9w4sai4jd9wazgao6hp8oqkyj981o
X-Rspam-User: 
X-HE-Tag: 1763129425-393454
X-HE-Meta: U2FsdGVkX1/0VOCDpabYENUptBmkAzIKndbhRoieOG9ZMit3GVYySPXN9mQuJixycIIUIqsgg0Zl1cDAZz0BFV9jD7zz7J39IeNe7FvEZhpUFuNdxUjtOrKkOTF7Y8ijXsO7FhbE3mSqo+qHwG/gpk6CKw4XPz0aV8eS1QwyvmBsJt8Zcb70BMypYyjpAziLgaobefveEjuapQ7oyYkXRm0eS/jOl61KbAA+H/gSHKoCbvI13ggVOKzomq6212syImA4vgK3WURspcfe63H4kIzySjtXvoEnAV4j8jTSr+uxjMbf/rHzWNfMOuoprw5HhZCNHw0QtsgIw10i9Rc4hC3wgj+KeUT9brQ30Pwn9tvVCy+NL2seGhm1ozQvxtBDcNSLmpM4TJLfh5Kl99eMAeVKOZ1cfNoLpGh6qivG4NKSVQOYyxI7lVFlJN2FedzmdTwW9fVxvVH/KPsJGmwpevNDrwncMe2h9Und+FzV3UeLCFBBRg8S5IaP4recX5kF/c/lAR5acCd5eiT4CDXjENd+PL85NwlKhGlTZh3cG0dcSbFE8340Vy333CvrZDWNp3LQ2MWhJag6Rcg9EzJpWIhf909DuAcn/rcSsfZthHW2MHwi1BWh32OQ7pPpZBv3WNCL56/S4qIaPZeKR9Z2yyfhHMrUNLCZnXKNCYtYresnYeDiLuiRm4rveQ5EddmlmCSdUB/ulXapamDZC80NVk7MxpEepRw6qSRRY1lP4/Eq15iGvHSae84naPrwcVZmivqxxBlpDAKFUiYYfLMGNlivF2/F+zYcaIwAPaWnwY+01/qiYchhlmXIbMB12x0BMse83PJDk9hhnkRcjYfPdmd87vUHFr5rVr4iUcxNcWJTMANkFJ5F9hiiYZPaEPJLmwR06OnWTIbTVx/IWXsrf2j42oA8AYu38GTVw/gJxk8ZE/RABvYnwBSwWbYEArONuEVv4F5MXXmw791cfJg
 9bsaFAlB
 c/DP9VD3Io8++a7Nw2rcoNS5g0R9TAg/iEV27aBXt15qGfh+lUT4DESspRs3690KLLFHiFDXYLf8fA6ByntKBSdf0C6eOw1zOTSjJEsnW/35VFToaaLcMxZYuBAGeRO02PJHAhN9Pinf/FWe0pdXWs0e6J+GCm9AAZBn0EJ4p7FsF1uWeo4pLgqXLa4AUdDENWMXAb8TJEAEaQebJmDnLLKhETy3ZIJ8GV/YQy/20HRRJGv1zFH7jWfV5CEoWELUlNhS0PqCCnQYh9dzRUlOE3mGQ1WDc/4YKWDgTahj71faAtP8kvObijbQM2GdEhe0l6YNFw5oV7KTegGIaX52ckYLXbjAXGvt0jjARl3U25fs7TfeKsvL4qbZEp4Zxm0PqzoO1pPjenNlR9A4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 7:58=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Nov 07, 2025 at 04:03:05PM -0500, Pasha Tatashin wrote:
> > Introduce the user-space interface for the Live Update Orchestrator
> > via ioctl commands, enabling external control over the live update
> > process and management of preserved resources.
> >
> > The idea is that there is going to be a single userspace agent driving
> > the live update, therefore, only a single process can ever hold this
> > device opened at a time.
> >
> > The following ioctl commands are introduced:
> >
> > LIVEUPDATE_IOCTL_CREATE_SESSION
> > Provides a way for userspace to create a named session for grouping fil=
e
> > descriptors that need to be preserved. It returns a new file descriptor
> > representing the session.
> >
> > LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> > Allows the userspace agent in the new kernel to reclaim a preserved
> > session by its name, receiving a new file descriptor to manage the
> > restored resources.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/uapi/linux/liveupdate.h  |  64 ++++++++++++
> >  kernel/liveupdate/luo_internal.h |  21 ++++
> >  kernel/liveupdate/luo_ioctl.c    | 173 +++++++++++++++++++++++++++++++
> >  3 files changed, 258 insertions(+)
>
> ...
>
> > +static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
> > +{
> > +     struct liveupdate_ioctl_create_session *argp =3D ucmd->cmd;
> > +     struct file *file;
> > +     int ret;
> > +
> > +     argp->fd =3D get_unused_fd_flags(O_CLOEXEC);
> > +     if (argp->fd < 0)
> > +             return argp->fd;
> > +
> > +     ret =3D luo_session_create(argp->name, &file);
> > +     if (ret)
>
>                 put_unused_fd(fd) ?

Yes, thank you.

>
> > +             return ret;
> > +
> > +     ret =3D luo_ucmd_respond(ucmd, sizeof(*argp));
> > +     if (ret) {
> > +             fput(file);
> > +             put_unused_fd(argp->fd);
> > +             return ret;
> > +     }
>
> I think that using gotos for error handling is more appropriate here.

Sure, I will do that

>
> > +
> > +     fd_install(argp->fd, file);
> > +
> > +     return 0;
> > +}
> > +
> > +static int luo_ioctl_retrieve_session(struct luo_ucmd *ucmd)
> > +{
> > +     struct liveupdate_ioctl_retrieve_session *argp =3D ucmd->cmd;
> > +     struct file *file;
> > +     int ret;
> > +
> > +     argp->fd =3D get_unused_fd_flags(O_CLOEXEC);
> > +     if (argp->fd < 0)
> > +             return argp->fd;
> > +
> > +     ret =3D luo_session_retrieve(argp->name, &file);
> > +     if (ret < 0) {
> > +             put_unused_fd(argp->fd);
> > +
> > +             return ret;
> > +     }
> > +
> > +     ret =3D luo_ucmd_respond(ucmd, sizeof(*argp));
> > +     if (ret) {
> > +             fput(file);
> > +             put_unused_fd(argp->fd);
> > +             return ret;
> > +     }
>
> and here.

Sure

>
> > +
> > +     fd_install(argp->fd, file);
> > +
> > +     return 0;
> > +}
> > +
>
> --
> Sincerely yours,
> Mike.

