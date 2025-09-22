Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA3ECAC5AC
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC178E0010; Mon, 22 Sep 2025 19:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83738E0001; Mon, 22 Sep 2025 19:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99768E0010; Mon, 22 Sep 2025 19:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE3C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:18:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54E3B14027C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:18:11 +0000 (UTC)
X-FDA: 83918451582.25.789E521
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70DE8A0003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:18:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e5WDQfzr;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758583089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMhzCZwWvSzmvpHLTjoUKn9VxrN7Ynwi1w+l4sf5xFg=;
	b=5w3aZSGOFaOK10tF5gbbtwHr+GIO922gRFvD4xJc3QLlGcEDUtqDXz890VACNGCRucNct1
	x1LBbcv1Ui/MlZnEr4sGoO/AEL5Vzbme2lDK0aJTi1M8ztr17iQbnsKoKQ4qdpsApy1Pe5
	/GSjnaTAAK8HZqS4LFzy22HEZS4tGDQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e5WDQfzr;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758583089; a=rsa-sha256;
	cv=none;
	b=4Swn33Kps2+hQbtEFB8mc+66mpi6HfUsJ1iQ7U8zf+cmsuUMjQkBAxUYJP6NSBK/6UmzR7
	qyNLb6xIwNFFFNvkWfls0qgznfMWDykXoZeC/06sPeqDExpD2TZfoUWpoXVgkZZwcWDJM6
	8MZbT4h7J03PJ+/vmp/ebrmViQSPMC0=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b5ed9d7e20so48856891cf.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758583088; x=1759187888; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMhzCZwWvSzmvpHLTjoUKn9VxrN7Ynwi1w+l4sf5xFg=;
        b=e5WDQfzrpUUOMkycNXU4L18P815DLRR+dkxQb5nC1BGWaaYNYSybmZuAL5GdAHc8B8
         zTWThqQibIiT9VtGQ853u5m9NTSCdeQkNGLor3TGGoE2kBxUbvd97I+DYGXdKfLHjaGJ
         rjep6HfGVQ62vsEYirUeR+RSZDNIM/cJzbSNB2D7pBxFlQATkERJluh1hJ5jKjj5KMj7
         Qwv1gIxxlzEbIAJk6yGLp6OtiJG0/sdPdV7QouzkyCZ7JfXwNUZdRcJKTqebgVD3JIwt
         QjWuWEUcI/cnOiiCdHiCzZJl9uDy5PqQsvCmDyMd8zcsyDW6mrO56b6vrYRTqGNiU/uv
         oxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758583088; x=1759187888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMhzCZwWvSzmvpHLTjoUKn9VxrN7Ynwi1w+l4sf5xFg=;
        b=Err/Gx2MwHIotqTu+d96xCmhOs3nVUvJTWkuhO916hco8+eUwxQud+3DkO6k+Ky/56
         mJm4mUxFqTcYrTC9QAr4sVDVeDQ/XiTO7eatifHvvwNNI/CS9RKAuu9pMtHoB0Mu3gRs
         cstnH9An+pVc5NMQ+vZ89X+KISHt8ZtejRAktHOqOn+FsDccg/pADWVT/QByjP2MXd5T
         ewX/qb8kke0NYGxOEjA3UhdZ7jnp1eYSWiN0wpHjWY7uwa8xw2VdGZTWPNg2PqPZIdP+
         v2F7f3QISiov20RnsIbzsimVcd99Ko7fV0mggHqsfuG4AexxgusIb6GIAI5W7o5xowNG
         /oFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyCmC4Cq13GzHPet3iS2wrgiJDOZpn24ES7uO9zJfSkMglYbEtT0xE+x+7X6qM3YB2rvkuDFyLLw==@kvack.org
X-Gm-Message-State: AOJu0YztctIW/1cwaKUb1RZmpB+nToyiJHVBzmWy1rIZHn7ukAs5S3D3
	kGdhUxmwMdzLgI0xeuZH1QiyJ1LS0NAFNrJ/avgCUvj6Bj8aZFH1qYnz9yMee+W/jgLS5ZRCfvE
	nSJ4zZZZC4gIbVHCMraA3ziz0thfVwquaHeZ8Pn6aOQ==
X-Gm-Gg: ASbGncs4a6N1HG3X4A1uh/ricv4wpfz5v2UcC+OrlwbvaQ9bBBUV1hBXLOXt5NrDtWs
	2WXxs8KYydGrdLqa9japLmSQ4CUwzTQu3WH9CB9cKzW21dPNysW9+Ybj7dgG8xfpMGp48emO7wo
	YNKwyLbbLarKLj6RjxAE3li5kS1+oJ+HpfF2c0Z939LjKOQ1HjYlWn7saKizHqIXc1/4fTtxx6d
	V/V
X-Google-Smtp-Source: AGHT+IHI7fhTCub3gR6FvbuAadFoUObXh5vH4jQwaxG/DrUU33qN/BcWlCQrH5/hzcu886DWWuHj5rfrmRYYSjZ03hs=
X-Received: by 2002:a05:622a:130b:b0:4b3:140c:ef9f with SMTP id
 d75a77b69052e-4d369eae636mr9141131cf.23.1758583088357; Mon, 22 Sep 2025
 16:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-19-pasha.tatashin@soleen.com> <20250814140252.GF802098@nvidia.com>
In-Reply-To: <20250814140252.GF802098@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Sep 2025 19:17:31 -0400
X-Gm-Features: AS18NWAv4dGFYOhiSllCg2EpqurnWbzUBhfung7Dsp39jZsN7-oM6V2Ui5LlSZc
Message-ID: <CA+CK2bB+NRneE=uFxvQ867zT3BHGvfBUz+6Ntqk9p2=wj4JYWQ@mail.gmail.com>
Subject: Re: [PATCH v3 18/30] liveupdate: luo_files: luo_ioctl: Add ioctls for
 per-file state management
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 70DE8A0003
X-Stat-Signature: 5rxdynr7kpdjjzg9wcmxfgxhfdk47qnr
X-HE-Tag: 1758583089-293677
X-HE-Meta: U2FsdGVkX19d/4mf0FaVm9StJwEbtNQ6z8hXeYnRxkjBJ7WtXkJ81lSUjNHGZq92Bmom7uNOTM2wsAtNdCpvq5bEp0wVkKqCYCfJeK2hmKtWvPJpqiutBiZ8kNlo4MSh0MFiABNfiJJNRgAf77sQj2yShhddP7GmN+139N1ZELtwg2++Gd8QBQ1RvpcZJgw4qjgztO0s9KFP/eTmKpDPOtJ2jFbyjgXvkmA7DU0gZL6i/pt4gLbTskl6YwcESeu4jKk1be1BYQ7rc86KRLBatx3DXSAX+WohF/RMV9SOZloWQjRRhEr3h/5JFrZl7N7G5hPRCdSbnlJmeDVZr1Niy++5zM06eVT8xwZqLK/Z2g0h7ACwfabuEF2lc4ltXJvLHgTBnDdS1GtmDxazYM5djJT0BMjjAacKl47w2H0KWHBNCR1O/ayViMgfoxhqDtpG1KNEw4+mmQfNhK95Z49gkrCDC1e3uVrax0dXbAFeUNiN51nYf9BZ/plXQJW5pWUdNmTXJdKN3sj3k5HFmRgNSYjFOZAtZbQDkywF6IR5kIKEpHWKGVZMmpzsIYBNg/YOkCj82za45lRRYauefJpbZgsACrbWgBJuWYObQI8m5GgjTENkjhv7prHUlFnOiZxHQn5YYOXD+w32bBK4T20SU2lbfMfmzEdW5hByG8MUFR5NbCT1vToMMUSLjxb0frxfi/+ZeWzkmLbn0WC9y8mKOpYYWmAeewkaXqeYjyeH7sT/ezhheVniv2b6nTNv6wl1LoiJyDE23k32Yc8iUtrOvgWJMH/zk7jpD9MlFpX2RPxiMufjhiBhFgxGExwCEYfRbnENxgrzWjw6jY8LUV8G9erGA7B6RLuk9jdcPXe5LjkckKK0PBUGn6xVuGwJiDOROGceosd9FNj6tLWfZrcDKtggiL2qwSofw5PNaShh7LOLB8FDhUlJbVGmRyMfUo73JUaI/X2eYHBP5K2tvvt
 3rJnn7DA
 333haMXz3MWjjjsoONpKbv7LakcYv28UUt/qXTiRC3czJoivz9xWSYwN9SUGwQEPC1ONWDgOWMgYVqVybNqbmPCM2eyTMK+VG5lPSBhTKme3unEFfYn23Gcc1NyfuE8wIwTjpPJRMG0CZhgDoGKr2dfjVdwh/8+HBcQT2A/hlPlTYEw88VAg8QkDBXQqFpppPiAUNU+W80k08WhxO3gT5cocVPvKuIXAUVpTjxy8ic+y1NANgAU3kwtTAvb56ZvZEd4BuodDnpQUI23w/BdPu/5Us7IBg8yUZnCjrWgqIUwV0UcswmRzsdp1u4DHXldXAa8ONBYbrctlQUWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:02=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Thu, Aug 07, 2025 at 01:44:24AM +0000, Pasha Tatashin wrote:
> > +struct liveupdate_ioctl_get_fd_state {
> > +     __u32           size;
> > +     __u8            incoming;
> > +     __aligned_u64   token;
> > +     __u32           state;
> > +};
>
> Same remark about explicit padding and checking padding for 0

Done

> > + * luo_file_get_state - Get the preservation state of a specific file.
> > + * @token: The token of the file to query.
> > + * @statep: Output pointer to store the file's current live update sta=
te.
> > + * @incoming: If true, query the state of a restored file from the inc=
oming
> > + *            (previous kernel's) set. If false, query a file being pr=
epared
> > + *            for preservation in the current set.
> > + *
> > + * Finds the file associated with the given @token in either the incom=
ing
> > + * or outgoing tracking arrays and returns its current LUO state
> > + * (NORMAL, PREPARED, FROZEN, UPDATED).
> > + *
> > + * Return: 0 on success, -ENOENT if the token is not found.
> > + */
> > +int luo_file_get_state(u64 token, enum liveupdate_state *statep, bool =
incoming)
> > +{
> > +     struct luo_file *luo_file;
> > +     struct xarray *target_xa;
> > +     int ret =3D 0;
> > +
> > +     luo_state_read_enter();
>
> Less globals, at this point everything should be within memory
> attached to the file descriptor and not in globals. Doing this will
> promote good maintainable structure and not a spaghetti
>
> Also I think a BKL design is not a good idea for new code. We've had
> so many bad experiences with this pattern promoting uncontrolled
> incomprehensible locking.
>
> The xarray already has a lock, why not have reasonable locking inside
> the luo_file? Probably just a refcount?
>
> > +     target_xa =3D incoming ? &luo_files_xa_in : &luo_files_xa_out;
> > +     luo_file =3D xa_load(target_xa, token);
> > +
> > +     if (!luo_file) {
> > +             ret =3D -ENOENT;
> > +             goto out_unlock;
> > +     }
> > +
> > +     scoped_guard(mutex, &luo_file->mutex)
> > +             *statep =3D luo_file->state;
> > +
> > +out_unlock:
> > +     luo_state_read_exit();
>
> If we are using cleanup.h then use it for this too..
>
> But it seems kind of weird, why not just
>
> xa_lock()
> xa_load()
> *statep =3D READ_ONCE(luo_file->state);
> xa_unlock()
>
> ?

Yes, we can simplify with xa_lock(), thank you for your suggestion.

>
> > +static int luo_ioctl_set_fd_event(struct luo_ucmd *ucmd)
> > +{
> > +     struct liveupdate_ioctl_set_fd_event *argp =3D ucmd->cmd;
> > +     int ret;
> > +
> > +     switch (argp->event) {
> > +     case LIVEUPDATE_PREPARE:
> > +             ret =3D luo_file_prepare(argp->token);
> > +             break;
> > +     case LIVEUPDATE_FREEZE:
> > +             ret =3D luo_file_freeze(argp->token);
> > +             break;
> > +     case LIVEUPDATE_FINISH:
> > +             ret =3D luo_file_finish(argp->token);
> > +             break;
> > +     case LIVEUPDATE_CANCEL:
> > +             ret =3D luo_file_cancel(argp->token);
> > +             break;
>
> The token should be converted to a file here instead of duplicated in
> each function

struct luo_file is preivate to luo_file.c, and I think it makes sense
to keep it that way, amount of duplicated code is trivial.00

> >  static int luo_open(struct inode *inodep, struct file *filep)
> >  {
> >       if (atomic_cmpxchg(&luo_device_in_use, 0, 1))
> > @@ -149,6 +191,8 @@ union ucmd_buffer {
> >       struct liveupdate_ioctl_fd_restore      restore;
> >       struct liveupdate_ioctl_get_state       state;
> >       struct liveupdate_ioctl_set_event       event;
> > +     struct liveupdate_ioctl_get_fd_state    fd_state;
> > +     struct liveupdate_ioctl_set_fd_event    fd_event;
> >  };
> >
> >  struct luo_ioctl_op {
> > @@ -179,6 +223,10 @@ static const struct luo_ioctl_op luo_ioctl_ops[] =
=3D {
> >                struct liveupdate_ioctl_get_state, state),
> >       IOCTL_OP(LIVEUPDATE_IOCTL_SET_EVENT, luo_ioctl_set_event,
> >                struct liveupdate_ioctl_set_event, event),
> > +     IOCTL_OP(LIVEUPDATE_IOCTL_GET_FD_STATE, luo_ioctl_get_fd_state,
> > +              struct liveupdate_ioctl_get_fd_state, token),
> > +     IOCTL_OP(LIVEUPDATE_IOCTL_SET_FD_EVENT, luo_ioctl_set_fd_event,
> > +              struct liveupdate_ioctl_set_fd_event, token),
> >  };
>
> Keep sorted

Done

