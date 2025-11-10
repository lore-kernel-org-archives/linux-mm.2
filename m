Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1581BCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0238E0013; Mon, 10 Nov 2025 12:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7E58E0003; Mon, 10 Nov 2025 12:43:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5508E0013; Mon, 10 Nov 2025 12:43:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 408E78E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:43:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA755C021A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:43:00 +0000 (UTC)
X-FDA: 84095418120.14.385E3D8
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id D36C0A000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:42:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R+8tZGOO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762796579; a=rsa-sha256;
	cv=none;
	b=FJb7aifAItLXoSDzpMsxaYz0vV2Wv1rTKZjX3Knovqh2j7Xy5hSma8PKxHdQ/FPdtymskA
	BBEw0+u9fwqYeK0goTkoaMZHFuMAeDeArPjMokVmfxJM9YAYVvVhNMjApBenOYSDmXNnh/
	rabKSBEUaSYhGXpZwIHQRmm+fDkDgjA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R+8tZGOO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762796579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUewd4yleLJA5JoGTJV3GbsdDnDLJGqt03O6urjLvaA=;
	b=wjtmjm7STx3QC//cFnXkUa2g3KeD5/MEhzEY9KItr0pB8J322r+LZSlNmM9+BtT5gu7pkb
	mdpoG/OACr7e5xAWnQcF0m8uC2JoD4FWiEAUtZvh/QYMq1Wb92NMVR4RdYgX3bzMo2HZNJ
	37enLP4R2BFhJFRsKNKLxGE7BLzbKWA=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so4999304a12.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762796577; x=1763401377; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUewd4yleLJA5JoGTJV3GbsdDnDLJGqt03O6urjLvaA=;
        b=R+8tZGOOhauH5mtg+JWXxNZ89IWLXQdaojE/d+NYRfsVGATO1MCAbAk1dpl5/f1hob
         YX0cvljb6iG8cBNYwYzTny2Vw01i4ClusMnj8DzJbguVB52VutkbK856bZtfU4mk8dVX
         UDLZdqGDIE2RO5LLg38X24QwGzHkrrgsp/aHneIXb7oPFnKRajGEWN8L/OdgDz4LYiA1
         EZOLWHIC5BG5zJ9P//Qy3IRacm5U7I2Y+XRZgGNE3WMOP1mlaDGpP9T4GgRej5Snov4p
         1E2y6pHVH6Gd0PeI409rxd4hmj+bebaWi0hYh5SFGUezIIjGIGXR6BdZrXz8/xIfnYuH
         jdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762796577; x=1763401377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dUewd4yleLJA5JoGTJV3GbsdDnDLJGqt03O6urjLvaA=;
        b=OQ52iqtrNlY8eVXVknI3Htmx3+afRnH0uzLxhVURdK7v8Fx1qz/x0y8Sk++AWsrNrO
         DH7VdlviVsKmpgUKZwMfNGXsFK6KS6ED/B0aRFxwECIX6bGsud1aaKOz6pZUu+Et3BOx
         tggaT4mv5IMu7NBukM8KmT+mZu4mHwLRECX4c9dDwuMSUvgQ9SUp5N84S+Z5xTJNmoUm
         3UOUqv0VBss7DD1YEeqSKqfv7k9i25NN3xQDE6C7gJ0BCZfqUDYUL70E0ftiVKHzPL0l
         YkYDI4oePOpmSCK9LZURuCsEDy5JdWn+n2bwMCrrNZldzNSv5hR5WP8WHaMB8oW7f+66
         bGgw==
X-Forwarded-Encrypted: i=1; AJvYcCWwZg4FVsJcKOlND7f3LHROPtY5d8xbRDswkPvwM041i5bMjzZogNBv/HdevC/AUnu8xvJWt6lDkg==@kvack.org
X-Gm-Message-State: AOJu0YzdKLrcYgFE8tQ7gTi+0UErBxWWjimOp9S03HkMLbU9mZSpjBKG
	Hh5n2I4AQl7G+j+n8F+/bTSmktPqlmTJRTrj+ouaxOtQcy+iHqYQPsEe+HDwifNjYJbGo6sa382
	i8ujGWeHjOY14imc4M9RR9y6YYY61nTDWXb3NAAh/hw==
X-Gm-Gg: ASbGncuxDXjw89Sbx7KmWpFNWzdQutNeSGBKLLDEhJtDrhQP7Q9akTn25e9eMo1Wr+/
	EU2lJhFR0ZtwdIK9B/DlMfJYVsKO62rOP5rFu90t/Myf3NWg/ELt4iAqwAjDZ+JhjFr5xhW9pVY
	5yeT/v/hdsVVO8ZQZi0K/Y69Vfbqm7CSStnrbkbSEo8+mkHs2rKRvk5w1S7sQ363FS8Qkt8EZ6q
	Tz9Jue1LYjTNpnd5lpYo0O2WyT1DiGlzVo/vtEXePjfOYeZJlXd3XXJFraZbMGwY3ZL
X-Google-Smtp-Source: AGHT+IGohd97iFSzusnKQDkeinSJTmpnCSTGsIETDXka805LYidOh0KbeB0Llp5c7t8ysAzDBzzykZsDEtrUy45tKnE=
X-Received: by 2002:a05:6402:1ec5:b0:640:80cc:f08e with SMTP id
 4fb4d7f45d1cf-6415e83dbc4mr7456751a12.26.1762796576718; Mon, 10 Nov 2025
 09:42:56 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-9-pasha.tatashin@soleen.com> <mafs0ms4tajcs.fsf@kernel.org>
In-Reply-To: <mafs0ms4tajcs.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 10 Nov 2025 12:42:20 -0500
X-Gm-Features: AWmQ_bmosonxcvpRMVKb6ujiu2Wwb5WZcJ_Ml7LhP2hix7ibfaliD6vYbfTF0S4
Message-ID: <CA+CK2bCWeqLmndDa8eg+iLrSBHg0XAvMr0mHeKSeH0Y=6F02kQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/22] liveupdate: luo_file: implement file systems callbacks
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, dmatlack@google.com, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D36C0A000D
X-Stat-Signature: cnpbt9o5agm6cuog65tqatao5gkxqmif
X-HE-Tag: 1762796578-342471
X-HE-Meta: U2FsdGVkX19DUs3jwNYY0Uhw8XkQ6tmhmA6wbtm6UAFBdmOLcTAN86q03bzVta6gnyFJcqRqg3VqBzpTT5hY6NlUu063eRccaPC6xl8TALN4j7lAgT9Fso+DBl3+TUbvECqOLIOpkjS8VNZ79y0F+OlhbzeEoJ+jHFqzN8idB0DWg29LQWfGNiPt4ynQ3LQAaRLc10QGP27EHiJIuBHdDZd1MaYLELXXpx0+G9HtoX8I+VmEwJ8LYdy2euezwOdDku9vcKrTG70o5RzWyyecD71nHEYUAdkPobDK7zROXzunSUXwfDjXycFjjEpB7ZvAQyWsW8OkKTIilYgjcQZ+1wZ24SrCKEJvxJ0XtIZ5ivykC8ova6Hp2BHs+Or2n1n8tbQdUNasTZU2iy7903s5fjnWq/4+FIeK5fq4NeSR9Gvead5u4Nw3ScA5De6qs7TlsME819AWCFhj4sG2XmhLbUucL84G3AQ9TDeRBBAMIkXF7+KAyDzUOWaNa1oXOk6bAnS3SqW+REWJwuw5ayPp7lAiEP7eVQMaas6LZNKOZO2OERdmmpp8fYAeqEAqqcJt4SZ/PSPRrNfrpKP/e3dN8um6GzkWCeQq6tbMP/0RTrkAK7x2tct76IakUefUDHGIiGIvblzRxMQCI4l4Iz6LXtRkP/xY2clNtELvkt6YSjw+xPTB1au1nriCFAFitjg0O84Mmtmf/qIi4nKQ3ScBKj9Rwl3nyJImSjlxDaStaYDFMHJnShNO8rhhZyQc/1V8oCayMWrcme/HJtp+p91bbtWk/lOhvmysfp8KGrxdbnqT7g5udF+CBbcIEsDMq773Cierk4VmkIdZclrNzYWe+g+/ul7cgwX6elPt8UdmkH0lgGhRotAWCVXMxkmxzOt19DDvXP1s/oYut8ZPU2ZMCv8PsyCojtp39GScRRAzZnPpNQ1eopGyhyeZv37Kc5PB9ErwX+0BusrOUH60jf4
 uMdmzwY+
 13B2ZTOE34nxDS7hBZ5T1yYa+8Jzxow4by3VusRPilWEO4roYZ6eXITLNR8nWmQbQssgR9OLgB/ss4Dwn++kdIYbikEDSpf+X28LO5lMOkCNUOlslBundgdDNHJtfTx0Q8CRIGERxflXBXCRtxv9fVVDnFWptBvSp4bwCIaG82o0B7faMl1cOCRjrUaqGmNRMcyzyO+GtjmVAvvsqsPJeGzTD0YVp1zK/NcBkGDqXZb+5TlVor0Hh5mED1ZGPyYE2KuZ94QCpPrOFk5qWP/sI8AYcnf6rMvWgau1RZTOhT9+G/0vgu+U+WZxE4luPhQLv95x9QwKqyzaj+G6Z4pJU5jpn+q1XWsQfY6ZZtej1WPYgjBtOK4Nx8kNYX5ac22MWO08azHSzsvrZRSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 12:27=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> Hi Pasha,
>
> Caught a small bug during some of my testing.
>
> On Fri, Nov 07 2025, Pasha Tatashin wrote:
>
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
> [...]
> > +int luo_preserve_file(struct luo_session *session, u64 token, int fd)
> > +{
> > +     struct liveupdate_file_op_args args =3D {0};
> > +     struct liveupdate_file_handler *fh;
> > +     struct luo_file *luo_file;
> > +     struct file *file;
> > +     int err =3D -ENOENT;
> > +
> > +     lockdep_assert_held(&session->mutex);
> > +
> > +     if (luo_token_is_used(session, token))
> > +             return -EEXIST;
> > +
> > +     file =3D fget(fd);
> > +     if (!file)
> > +             return -EBADF;
> > +
> > +     err =3D luo_session_alloc_files_mem(session);
>
> err gets set to 0 here...
>
> > +     if (err)
> > +             goto  exit_err;
> > +
> > +     if (session->count =3D=3D LUO_FILE_MAX) {
> > +             err =3D -ENOSPC;
> > +             goto exit_err;
> > +     }
> > +
> > +     list_for_each_entry(fh, &luo_file_handler_list, list) {
> > +             if (fh->ops->can_preserve(fh, file)) {
> > +                     err =3D 0;
> > +                     break;
> > +             }
> > +     }
>
> ... say no file handler can preserve this file ...
>
> > +
> > +     /* err is still -ENOENT if no handler was found */
> > +     if (err)
>
> ... err is not ENOENT, but 0. So this function does not error but, but
> goes ahead with fh =3D=3D luo_file_handler_list (since end of list). This
> causes an out-of-bounds access. It eventually causes a kernel fault and
> panic.
>
> You should drop the ENOENT at initialization time and set it right
> before list_for_each_entry().

Right, thank you for reporting this. Should add it to self-tests,
where we try to preserve FD that does not have a file handler.

Pasha

>
> > +             goto exit_err;
> > +
> > +     luo_file =3D kzalloc(sizeof(*luo_file), GFP_KERNEL);
> > +     if (!luo_file) {
> > +             err =3D -ENOMEM;
> > +             goto exit_err;
> > +     }
> > +
> > +     luo_file->file =3D file;
> > +     luo_file->fh =3D fh;
> > +     luo_file->token =3D token;
> > +     luo_file->retrieved =3D false;
> > +     mutex_init(&luo_file->mutex);
> > +
> > +     args.handler =3D fh;
> > +     args.session =3D (struct liveupdate_session *)session;
> > +     args.file =3D file;
> > +     err =3D fh->ops->preserve(&args);
> > +     if (err) {
> > +             mutex_destroy(&luo_file->mutex);
> > +             kfree(luo_file);
> > +             goto exit_err;
> > +     } else {
> > +             luo_file->serialized_data =3D args.serialized_data;
> > +             list_add_tail(&luo_file->list, &session->files_list);
> > +             session->count++;
> > +     }
> > +
> > +     return 0;
> > +
> > +exit_err:
> > +     fput(file);
> > +     luo_session_free_files_mem(session);
> > +
> > +     return err;
> > +}
> [...]
>
> --
> Regards,
> Pratyush Yadav

