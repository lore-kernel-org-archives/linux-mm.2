Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306D0D0E6F9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4536B0024; Tue, 25 Nov 2025 10:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C146B0026; Tue, 25 Nov 2025 10:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3566B0027; Tue, 25 Nov 2025 10:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 693676B0024
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:13:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24849C0202
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:13:55 +0000 (UTC)
X-FDA: 84149474430.21.3D7B66D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A5F720002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:13:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P0qk4FVA;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764083632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJAb0zqhShPXJU9IU9F3kUJv+d4qBtikcObWfuhaWDU=;
	b=KBbu7GxN4TyiEwo+TuxQVLe89Qaf6ySdY1oNyHLHKGvafThr750qO1yaFYpjcYgGmY4M/t
	suX/qNXDllLYcZBwxtrZgw3WLp/JFtvEySCv4RQ0pBxcqVwfjRcMwxOZRJV0j9/sJbiOgS
	5odrAqQHw50tvgh5ddk08OpBG0p1zIw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P0qk4FVA;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764083632; a=rsa-sha256;
	cv=none;
	b=MJ6vOvKLFqj/Z0h0V5Bt2rJZUewzj6+FlMsv486iZonXSDP4yj83xx9fN/POhUIdxPJuiD
	Hmh0W7u5jVYTR0ARR/1zWwa2m4mhNtx5+N852rAgNE0I/mMWV5+bFG25ALV2HohsLl/dzz
	2Lgn4v7kJer/q84ezwpNOw2yf0+nMCY=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so9183986a12.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764083630; x=1764688430; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJAb0zqhShPXJU9IU9F3kUJv+d4qBtikcObWfuhaWDU=;
        b=P0qk4FVARVPRjNayp29HxNcr8kXgTQTzoeZxdnYVODhFH92pTVy0A7lSF0qvEI3mNB
         Qj4wpIM5ViN089G+4tUFcudQ9/cunTEFOMLg89Xvh8Y1Zx0L2+tdz49fqg6gmuB2a+E8
         JDaVtWRqPkkGFZsSzOO+EioMCafkZdEaMTN+7P79GvhOVRsv8A7Qs3FBQeO9PEMgmRho
         rUphpUdUp7nW8wHFgErUhQOMprC+bWoY63O03S93lMYPs1XtLRWrn0hOHs8R43Qvlajs
         XZSs2/XrkC/kmzB84veZs2TfMsSF7L2DdVWr2p75dhPD/TjE9UuM78dLo3NV/hpo7QpE
         lu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764083630; x=1764688430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJAb0zqhShPXJU9IU9F3kUJv+d4qBtikcObWfuhaWDU=;
        b=ZtSFRza+uWek6pupmay26MJWdXzTGQdSB6ThqrhY/EQvqmmfpKQOqNS70qLpXRYMd5
         laQRag/Ey6gsChm4mtEAMlJCeaN5DZcu5I2V0vxPLagpm5yuCwsLbEy6AiqSHpkCGDZF
         s/ujrkiMLVKhDTmP6mQ51EdLQbRBOu9QrNnWgXzmS7U7276wZ8HXCHz2FqvWCwQPFxks
         7VJtsoRKTYr4hVwAOEpzig7Va6DSkAXNrZ6ZXNfvrKHIccLeAH0ECH3l4kODYmFTDXEU
         pzJe/un36d+vTnvEV6th5cGUoPC7Sq9opqz+Qlde7PSLWTNf3rurx7R25Zav/4Q1ErNX
         8gXg==
X-Forwarded-Encrypted: i=1; AJvYcCWwKV0QvNqSxW4r40z32GC8ws/L/g0cexvSVcu8fsfZFlG1uDlEYkcXCZfb7kouEBuvl6FtnlMSOA==@kvack.org
X-Gm-Message-State: AOJu0YxLnxn1n0675UNLfT5SY4GlE839Yn1huk3E0UHLbF6c0IA23YuX
	/eFSH5yRr4YWyJ0vi8jKoEgDNiB0rrNjaFdIBgRobn3tTxQHWkXwzCEuaK9lukqevUCixO2m5pg
	6Xd0oQc0v2sBKf/Odr8mZEYXOZlVNsszfl0Q/xJBynw==
X-Gm-Gg: ASbGncuX7pKFKwKpy3oF4oetZbqLJBkpGyQ5yqw87T2fJKkUX70lsg4iObQdciSJe/M
	iizx2LwacYXUbYex06DyEjrLtArR4Z8pzlEiPoQ2gAYoiPnc0fUGh7eVY46DBwXLVOnftdJpHUZ
	LDd2wApmurISSqnnkeUk1VB9Yldul6va6GxDklkrc9GzEhzm3pOPQKBTL6yoM3hyvXINGoaMsAU
	bVRObbjwmlS7NmVTlAW+0p4hxtSLDQZvL2CyC7uq9kjUbB48nwKnO1gQuwuoKX1OguU
X-Google-Smtp-Source: AGHT+IGitbk1SBZ8i6I/16DXqU5ZqIa4zUYc/a94r8AU30+VoEWiOjzICaCR39+/6YAvGwaSGnJ5T1RqczQTlRLZSFw=
X-Received: by 2002:a05:6402:2714:b0:641:3a92:7e6f with SMTP id
 4fb4d7f45d1cf-645559fcb28mr14017569a12.0.1764083629776; Tue, 25 Nov 2025
 07:13:49 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-7-pasha.tatashin@soleen.com> <aSQU1LlPDDsN2rUw@kernel.org>
In-Reply-To: <aSQU1LlPDDsN2rUw@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 10:13:13 -0500
X-Gm-Features: AWmQ_bmueOySR-IcM9KD_nVWlrEwNsK-bJkIQQ6vkf5Ej_a3i1HC8W4-4CGCmcA
Message-ID: <CA+CK2bAoZ9GhL+SCsrzWL-eG1XcRai0h9QMrL-fsZJFzSxSt6g@mail.gmail.com>
Subject: Re: [PATCH v7 06/22] liveupdate: luo_file: implement file systems callbacks
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
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hpgbpfe4q6q7xftxmfaog8pxc6k61np9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A5F720002
X-Rspamd-Server: rspam09
X-HE-Tag: 1764083631-185523
X-HE-Meta: U2FsdGVkX1/IC46kDJtIiM7Mh4Z3TcJuDGF7wGzBiBX5BFFGKDBKiUA7lDhCi0I3GupAIoiacc3hd59TUDOIL9UeP0Sa3HYRd2fvhQ87s+BkBXSPz/20q6xw6DEzoS4Sa21cuXwzf2/q5iD2o5SJirnFd0JXEBt+xPEwfvBosWjyuFnM/83/aTK/av56uimmN/ilvNUyf7pa0Nvuts9AtWb9Ey68SqfjIW/csdVmyaiDpY/WoS0HNPVfv/5HuFsBRnPfLlSO9m8vW04g9IgM+h35BO/SLJ9VRnlvpxzqLYBOh3WKMiJzowanXjs3AHVuvPd/Lcxb/40mJpw63YQIPJP3ZAv/msK8LxqPLaXNdp8dDviVUoNeTgEn8v636pnkrv55g0j0VWW+7oGbCizaKzc03fklvPsZcUmFrN0bYN0PqjxblFz80mPg9+J0vYeEMsRCRraFxIjuWpk0qkpPzFM6bvXtukdtYebUgUtIZTWN0o9TL23/Zf7nizxWL1AVqXNatJ+FVZBsDPH4gto3CAG0EfqtIQoKFtdG9T0jqu0P10aDfi6nBsom5y5MiNBrtaeowQFih02KI90Ac4XCnDmRvU4Lei1o9QxC8a4H/Jp/TxutinFLZuzOQXdfUE9BfR9UBpIiZUI0ImlfSWQ4pJFizxStSpL9glaxnuBOP+y69TeLoGBRcWx3c0FHwqEBpOpFNlMAoMOVmiwRSoe1Iz0/e9Sr13ixh14JpAuMLywF0+3uLh2IqAAwytyQBuXTJz5dJ/RQZnFleag7hjex02K6rr1thZcmcqFHtzI5CQQmNwO8Pcs2Pd9ljMhlVI8Mz0kkvrlvgOkxcJqzETXeAm6nW6ZX08m6auoZ0a3h+AhySuORMTV5wXmOaa4W0OzWabOpAveBiKh53/zmEDtQD2vc6xRkHpUe3zrOSI6VK2hZDLr1tIOUDRYmtgXY1ZmZ4yPpC4X/OiaSNDP/apx
 FZV1VX7t
 D0n+2DByGYJzyPY0Rqzee3WxHRAXimCP/P76bU1HdH+wkTJvPjYf81ArGIH5NjR040nyON+/UPs6bYx5K2/Qy0/JyQ/Tk76ljnseSGBUCa9vqNn9eolwohbfpVZ0sP8OfmTxKQsiCyp42k310WTDSM+MvG/g+OYnMKyP6Y9o/9x+4U2tHb8nIbv+3ujyrH28ufcexYS4q/74gTCdef1afbKr56eu78cyNT4UxGydDsJExu0y9ROdA3L7yEGRxS6v3npkK1EerTIsZTuc6XNIN+ezfbVwYLfMBth2+o73uHxsoIGlasyMbpmpeG2e9+KB2w0aYMZxA/47slRrhsEO5Vjh3h5Nwn88WrXTc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 3:18=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 22, 2025 at 05:23:33PM -0500, Pasha Tatashin wrote:
> > This patch implements the core mechanism for managing preserved
> > files throughout the live update lifecycle. It provides the logic to
> > invoke the file handler callbacks (preserve, unpreserve, freeze,
> > unfreeze, retrieve, and finish) at the appropriate stages.
> >
> > During the reboot phase, luo_file_freeze() serializes the final
> > metadata for each file (handler compatible string, token, and data
> > handle) into a memory region preserved by KHO. In the new kernel,
> > luo_file_deserialize() reconstructs the in-memory file list from this
> > data, preparing the session for retrieval.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> With some comments below
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> > ---
> >  include/linux/kho/abi/luo.h      |  39 +-
> >  include/linux/liveupdate.h       |  98 ++++
> >  kernel/liveupdate/Makefile       |   1 +
> >  kernel/liveupdate/luo_file.c     | 882 +++++++++++++++++++++++++++++++
> >  kernel/liveupdate/luo_internal.h |  38 ++
> >  5 files changed, 1057 insertions(+), 1 deletion(-)
> >  create mode 100644 kernel/liveupdate/luo_file.c
> >
>
> ...
>
> > +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd=
)
> > +{
> > +     struct liveupdate_file_op_args args =3D {0};
> > +     struct liveupdate_file_handler *fh;
> > +     struct luo_file *luo_file;
> > +     struct file *file;
> > +     int err;
> > +
> > +     if (luo_token_is_used(file_set, token))
> > +             return -EEXIST;
> > +
> > +     file =3D fget(fd);
> > +     if (!file)
> > +             return -EBADF;
> > +
> > +     err =3D luo_alloc_files_mem(file_set);
> > +     if (err)
> > +             goto  err_files_mem;
> > +
> > +     if (file_set->count =3D=3D LUO_FILE_MAX) {
>
> This can be checked before getting the file and allocating memory, can't =
it?

Moved up.

>
> > +             err =3D -ENOSPC;
> > +             goto err_files_mem;
>
> The goto label should say what it does, not what the error was.

Changed to err_free_files_mem;

>
> > +     }
> > +
> > +     err =3D -ENOENT;
> > +     luo_list_for_each_private(fh, &luo_file_handler_list, list) {
> > +             if (fh->ops->can_preserve(fh, file)) {
> > +                     err =3D 0;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     /* err is still -ENOENT if no handler was found */
> > +     if (err)
> > +             goto err_files_mem;
> > +
> > +     luo_file =3D kzalloc(sizeof(*luo_file), GFP_KERNEL);
> > +     if (!luo_file) {
> > +             err =3D -ENOMEM;
> > +             goto err_files_mem;
> > +     }
> > +
> > +     luo_file->file =3D file;
> > +     luo_file->fh =3D fh;
> > +     luo_file->token =3D token;
> > +     luo_file->retrieved =3D false;
> > +     mutex_init(&luo_file->mutex);
> > +
> > +     args.handler =3D fh;
> > +     args.file =3D file;
> > +     err =3D fh->ops->preserve(&args);
> > +     if (err)
> > +             goto err_kfree;
> > +
> > +     luo_file->serialized_data =3D args.serialized_data;
> > +     list_add_tail(&luo_file->list, &file_set->files_list);
> > +     file_set->count++;
> > +
> > +     return 0;
> > +
> > +err_kfree:
> > +     mutex_destroy(&luo_file->mutex);
>
> Don't think we need this, luo_file is freed in the next line.

Removed.

>
> > +     kfree(luo_file);
> > +err_files_mem:
> > +     fput(file);
> > +     luo_free_files_mem(file_set);
>
> I'd have the error path as
>
> err_free_luo_file:
>         kfree(luo_file);
> err_free_files_mem:
>         luo_free_files_mem(file_set);
> err_put_file:
>         fput(file);

Yeap, done like this.

>
> > +
> > +     return err;
> > +}
>
> ...
>
> > +void luo_file_unpreserve_files(struct luo_file_set *file_set)
> > +{
> > +     struct luo_file *luo_file;
> > +
> > +     while (!list_empty(&file_set->files_list)) {
>
> list_for_each_entry_safe_reverse()?

In this case I prefer while(!list_empty(...))
It emphasizes to  a reader that we are emptying the full list. _safe
is good to use when some items are removed from a list while
traversing.

>
> > +             struct liveupdate_file_op_args args =3D {0};
> > +
> > +             luo_file =3D list_last_entry(&file_set->files_list,
> > +                                        struct luo_file, list);
> > +
> > +             args.handler =3D luo_file->fh;
> > +             args.file =3D luo_file->file;
> > +             args.serialized_data =3D luo_file->serialized_data;
> > +             luo_file->fh->ops->unpreserve(&args);
> > +
> > +             list_del(&luo_file->list);
> > +             file_set->count--;
> > +
> > +             fput(luo_file->file);
> > +             mutex_destroy(&luo_file->mutex);
> > +             kfree(luo_file);
> > +     }
> > +
> > +     luo_free_files_mem(file_set);
> > +}
>
> ...
>
> > +int luo_file_finish(struct luo_file_set *file_set)
> > +{
> > +     struct list_head *files_list =3D &file_set->files_list;
> > +     struct luo_file *luo_file;
> > +     int err;
> > +
> > +     if (!file_set->count)
> > +             return 0;
> > +
> > +     list_for_each_entry(luo_file, files_list, list) {
> > +             err =3D luo_file_can_finish_one(file_set, luo_file);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     while (!list_empty(&file_set->files_list)) {
>
> list_for_each_entry_safe_reverse()?

Same

>
> > +             luo_file =3D list_last_entry(&file_set->files_list,
> > +                                        struct luo_file, list);
> > +
> > +             luo_file_finish_one(file_set, luo_file);
> > +
> > +             if (luo_file->file)
> > +                     fput(luo_file->file);
> > +             list_del(&luo_file->list);
> > +             file_set->count--;
> > +             mutex_destroy(&luo_file->mutex);
> > +             kfree(luo_file);
> > +     }
> > +
>
> ...
>
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_i=
nternal.h
> > index 1292ac47eef8..c8973b543d1d 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -40,6 +40,28 @@ static inline int luo_ucmd_respond(struct luo_ucmd *=
ucmd,
> >   */
> >  #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
> >
> > +/* Mimics list_for_each_entry() but for private list head entries */
> > +#define luo_list_for_each_private(pos, head, member)                  =
       \
> > +     for (struct list_head *__iter =3D (head)->next;                  =
         \
> > +          __iter !=3D (head) &&                                       =
         \
> > +          ({ pos =3D container_of(__iter, typeof(*(pos)), member); 1; =
});      \
> > +          __iter =3D __iter->next)
>
> Ideally something like this should go to include/linux/list.h, but it can
> be done later to avoid bikeshedding about the name :)

Exactly, I am planning to propose this as a separate change for
list.h, but I suspect we will need to take care of other variants as
well, reverse, cont, safe etc.

>
> And you can reuse most of list_for_each_entry, just replace the line that
> accesses __private member:
>
> #define luo_list_for_each_private(pos, head, member)                    \
>         for (pos =3D list_first_entry(head, typeof(*pos), member);       =
 \
>              &ACCESS_PRIVATE(pos, member) !=3D head;                     =
 \
>              pos =3D list_next_entry(pos, member))
>

This does not work, because list_next_entry also accesses private,
what works is this:
#define luo_list_for_each_private(pos, head, member) \
for (pos =3D list_first_entry(head, typeof(*pos), member); \
     &ACCESS_PRIVATE(pos, member) !=3D head; \
     pos =3D list_entry(ACCESS_PRIVATE(pos, member).next, typeof(*pos), mem=
ber))

But that extra ACCESS_PRIVATE bothers me, so let's keep it as-is for
now. And solve it once in list.h, and then update the private macro.

> --
> Sincerely yours,
> Mike.

