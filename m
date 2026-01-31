Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18BDD7977D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 15:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE506B0005; Sat, 31 Jan 2026 10:32:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6266B0088; Sat, 31 Jan 2026 10:32:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE226B008A; Sat, 31 Jan 2026 10:32:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBB8E6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 10:32:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F42014053A
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:32:18 +0000 (UTC)
X-FDA: 84392650356.08.0413B21
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8B5672000C
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:32:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HcbLUbLR;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769873536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmjGdchX9VJtK0FU2Fzj6LEZpZPKttvIbDysWym1XqE=;
	b=zGxVlNVo+WZkNiUYTcTP8crZ2COgWMyibnFovkArQ8P7AfQ64gCvuxVBzOi2leliHWy6Qq
	4lNUwayEIfTfGf9ZelC+t3OCv3REr+kutcheRM47DWzmjIqlKp3+miG4e0EcsAZAoMi5ua
	9D8odyFst90xvi11V4Y0Dfbgbub51IE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769873536; a=rsa-sha256;
	cv=pass;
	b=BpmwJJBzsyXz/1S2TxXufhObstHyPKl38JUK3jHi8JcqlI7cQ9p1GGNZhShC6dfDViX6aK
	y395F0TUh6FFiX/swNfxNJ4x3XBZU7TLnASRZFeSYZr34NehKmnpi0ZjigiAZSkOPXgpI6
	sQu9VIeG2uhfRxSSbvHO4xkxJGGaOFU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HcbLUbLR;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-658f1fde4bfso1227406a12.1
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:32:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769873535; cv=none;
        d=google.com; s=arc-20240605;
        b=IYWvPsuqmQAiCRoQkyYeqN+k+uvsTa+YFan3Y2s2h2SwhQOQjjq0EI49Hy04LcWKte
         RvUW7tK/BFglxCDXZhY3F04vFFGgulanLo+zoAElS2Jya2jRhJ+2JhfA74oekGLWyrEu
         7zdAv62bCxxFwZnXF3GNETU18B7u2vvse8qF59jk6pI9HBSoJ2UjCKiXQK/XyTx10b+F
         fgTN3YGLtpi6V601cBvutu5Yb+D63utLtSPh2Hd0YRxnazOXzA8yi7shZVd9F+0vT79i
         X480k9VAg1NK6oaUdhYEoFLXWJKCAOKmz4dChMFv44TxUbXL7H/Pia01S1Ic76VCGcF3
         DKEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QmjGdchX9VJtK0FU2Fzj6LEZpZPKttvIbDysWym1XqE=;
        fh=PH6OWv8KTYwIeJE0c7eeqWlTlMUttmbzX3DcONNkcBQ=;
        b=L/aQ+jUF6AdvEyWyQ9aTLe1KvxXoxNNKVGSowJ3yyTIi1Fn+d4dYBvfOAApytGTh0J
         mro8D0clCtjNBoG/cb8AGdbrlwSL4hlmVKJoBECE1P8pXucwzpiq/EjAdBgFbUegKRF7
         t6PPJEyU6SUGU3AfGWIEJ+4le/RM+g/R4wSBsKNXydsxUQ0kFwLYSmGa6tfFxq2lKqEa
         T92U6pXldevOgXq7ONL/mAPlLvm14Qz7FJEDzwUvrKbxx0yyiXFFOTDZEZeAbzs2Pay2
         htgJsTlhjXv9kl0cS+WLECyKGMUjwAypTPCW5rd0rTbSbhLHbPEoq4HG3txKRMuIoJYv
         RZpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769873535; x=1770478335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmjGdchX9VJtK0FU2Fzj6LEZpZPKttvIbDysWym1XqE=;
        b=HcbLUbLRIa71O1cmeqf1Y5v1AH++5Dt4qDWhxPYbfDkSqkWWcklYqPBnfdFSAQ3Z29
         ugoDdXPrDfiIaPBEl4szCtkVl23F7Ofn6kCA8Cl9etIu1XGKjqQ7+EN/MZjVkFbNxAs8
         q5CIdiXZqE4I3OAXQhSz6uW+2VvLtHG/K6/1noEnjxFTHk1j8kABniV5sKJVmZH0Fa2Z
         E7MW5VQoK7uXVib1TKfRH9p9BS03ZbGYomyf3Yf2jaW/TfNPb+MW3d4+3CxKOFughPeh
         zu3jMciUwsdyqmsGxhrEauGrGD3L1rRrnutNgrWX1hYnA7KUjVG2W5DyuIZhagr3zjxK
         V5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769873535; x=1770478335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QmjGdchX9VJtK0FU2Fzj6LEZpZPKttvIbDysWym1XqE=;
        b=a2kROjTLK6ae0MtaHHEQ7YKkayFJ1LuZ3mFQ/dtT1CXoHarmoH8NeiYPE2bM+iahsX
         JSWEcHP62ZETFFRkEtXoSDugam/WBlHvBRikQXsHDyhLSfUi35+WuukW0AKPJaMO97gb
         P4CF9wK+THwkGxidgGpDOZ6MsEvE6IVZ0jNGvKl1o96rPUiMHDv0UnAZfQm7lT7AU6Mv
         ym+5Abm4vYRoXF2LOPmmVBWJs7zmAqXq+/jiZopU+eCiBZwS7RkL1R/uStZsRxrRQOib
         mnSc1WQy3HnTZt7+wBI4BFcg03y3bTzoZoN+e0kDGp9i1oCQQEkCkweKv1Mx74t83pW2
         S4hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeN/ud5kZ1OdtyLkSxgSwIUTLccjTmsBdY05oOlHgKT1N1Kw3C065MaQ/hWX07Am5w+husTl14Bg==@kvack.org
X-Gm-Message-State: AOJu0YzqvEyor7wFttWMDEfO2kLzIRS4fM5WFXMa+Foal94YTVpLu8Vw
	qxKNBkPsgpXgiRIWKp5Ix4YsFedJNwriQo+6MMn/pz6isxd+NLx5vN4S3UDMaF2OjkHMI65jhus
	f25/8i4PUnx9YBz2SZvyCw6oPyvSCFbggJstHYxSROg==
X-Gm-Gg: AZuq6aIDG5Qc8n7xnE88cAwQ8cdUvTkz+p6Ah0OObrrhFW0R2P0vDAn8a9Ub77uFHwV
	V7FExWVOVwCJvBbM30YSc3A6R8463JLfBNCSCEq40zfbRpwFZ/pr+IeRPt77vSXbai0nZhclH1+
	v/3eYqvoxb5JyxtTFpc7l1o1QzbKq87FlGWTdpwOtwlkXBJIL/yrSdL92sDAiEg1PyPgmgH1sVH
	MigkEUe4Oxrh6j0zbIz6PoCvNhVFWQ4nndpV7RBDX4OJN/nVqHMDk+5KvDBdYVjhVKB3+6u2z7N
	lcdyQCZLa5VTHoZyVoiz3INYjQ==
X-Received: by 2002:a17:907:9616:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b8ddf3df6bdmr682553166b.0.1769873534557; Sat, 31 Jan 2026
 07:32:14 -0800 (PST)
MIME-Version: 1.0
References: <20260126230302.2936817-1-pratyush@kernel.org> <20260126230302.2936817-3-pratyush@kernel.org>
In-Reply-To: <20260126230302.2936817-3-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 31 Jan 2026 10:31:38 -0500
X-Gm-Features: AZwV_Qjb2bpB0DCndnrnqc8yoWzJZ4bRHyw6p3BDmQvcz93e6Nk5U8SDbkk9Eqw
Message-ID: <CA+CK2bC9WBdYoQfJXZs+K6DQjDkrGmppbevL18mJ=DhO0TkG1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: luo_file: remember retrieve() status
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8B5672000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: m8zoyxx6s3gu8amkr8c1y8bwzpy1ee9y
X-HE-Tag: 1769873536-265456
X-HE-Meta: U2FsdGVkX1+Q66hS8hdWOp051tbKgm64MH7tCumQH+G8EY9tsrHTK9GK24CCf85qT3JtPrRUy1J9hvrTd7/Qe9U7D/8wRfJUeNAQ1Lf9AVyZk6Qe85efZgaldTAtppcdJXA7Y4L4BTscmQVYgvoW9wEMsfRbe1qgNDnKQkPpBI7c46hoI124JzklXEIkCg7oXi6cJLDYMfnd9Alrx1fCsp+meOA/7AYocjRszaDR4ZI2ZxuK1Gkho+0iNBU3AzVuqD/sIciP6887mqJ1nsJO0O9DyLaUs7fXe+V5Ni+/pFeIyAPgiA4q2676e3uZ6K0GPMN6gTlCTRplnHNoWaVeWi/qVAsOmBUO3iDBr/Klrwtoua4aULPcKOvrhVJkWL3/Y3GjgFiuqQ8j20TnNmvVjdzBUhrls1ensgQBhrR+ozLJp4GNJl1liPoVTD9gUR6wkZVqLkeJjJwg406WarzJf+Qb3NUgdLyED+G6NOu1+ubDZdUOlDcveRfgyVtAWN75FKGP1gkylIWPNjy+PmCqwLMpNzQvUaqkKdSsGrasvr2RsjmCy4TQOcdT2Hpan21YEiYMQZ44poHzX9XVvfnWhbVqfxK2GdSirAfrH+6dWQaTl2pP3qZipFh+F/qFDHd6NLL8LsYnNV0O9MUHYCUAMM+m/IDN/sOKG14uGOjBMgQ12zw4atTjg5IBL4U+S2b6/pxXd558zvYW9Jg6kbXXmjfuP+63aG/UUTVIu76r39MsyYyvssYXRVvjLu4kNlDn2p/ArFo8xsvyg24l9LLWPvOhj5Q5ahsaWYjk4pcKf3UWoiGrTmmq/hipRtFAo7x6akUSnNYSnjS8LIlkx5Ac56nOjlCabiXG2AD3/lk9reFS4Gio05CQ5Rv+aCAgEH25R6wIjErPjS0Dn90ciX3vp773VRKx3V4GI1cjZ7Od3MryMk9/g5uEgqtPOwyEOiwdUQEC7+7xaQarEfjX7GR
 5ykdKR/5
 ytU00WIf2cscRSiObDU3QBIIG0m3g+vRfLqB4wWpJGd8vEbRMUynkB3OFvLVS8lKBk2gYzjCFVUdfmzdWSAxkl0WiCu2EV02sYPc2lqrOlxrWc/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> LUO keeps track of successful retrieve attempts on a LUO file. It does
> so to avoid multiple retrievals of the same file. Doing so will cause
> problems because once the file is retrieved, the serialized data
> structures are likely freed and the file is likely in a very different
> state from what the code expects.
>
> This is kept track of by the retrieved boolean in struct luo_file, and
> is passed to the finish callback so it knows what work was already done
> and what it has left to do.
>
> All this works well when retrieve succeeds. When it fails,
> luo_retrieve_file() returns the error immediately, without ever storing
> anywhere that a retrieve was attempted or what its error code was. This
> results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
> but nothing prevents it from trying this again.
>
> The retry is problematic for much of the same reasons listed above. The
> file is likely in a very different state than what the retrieve logic
> normally expects, and it might even have freed some serialization data
> structures. Attempting to access them or free them again is going to
> break things.
>
> For example, if memfd managed to restore 8 of its 10 folios, but fails
> on the 9th, a subsequent retrieve attempt will try to call
> kho_restore_folio() on the first folio again, and that will fail with a
> warning since it is an invalid operation.
>
> Apart from the retry, finish() also breaks. Since on failure the
> retrieved bool in luo_file is never touched, the finish() call on
> session close will tell the file handler that retrieve was never
> attempted, and it will try to access or free the data structures that
> might not exist, much in the same way as the retry attempt.
>
> There is no sane way of attempting the retrieve again. Remember the
> error retrieve returned and directly return it on a retry. Also pass
> this status code to finish() so it can make the right decision on the
> work it needs to do.
>
> This is done by changing the bool to an integer. A value of 0 means
> retrieve was never attempted, a positive value means it succeeded, and a
> negative value means it failed and the error code is the value.
>
> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callba=
cks")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/liveupdate.h   |  7 ++++--
>  kernel/liveupdate/luo_file.c | 41 ++++++++++++++++++++++--------------
>  mm/memfd_luo.c               |  7 +++++-
>  3 files changed, 36 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index a7f6ee5b6771..a543a3a8e837 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -21,7 +21,10 @@ struct file;
>   * struct liveupdate_file_op_args - Arguments for file operation callbac=
ks.
>   * @handler:          The file handler being called.
>   * @retrieved:        The retrieve status for the 'can_finish / finish'

Rename retrieved to retrieve_sts

> - *                    operation.
> + *                    operation. A value of 0 means the retrieve has not=
 been
> + *                    attempted, a positive value means the retrieve was
> + *                    successful, and a negative value means the retriev=
e failed,
> + *                    and the value is the error code of the call.
>   * @file:             The file object. For retrieve: [OUT] The callback =
sets
>   *                    this to the new file. For other ops: [IN] The call=
er sets
>   *                    this to the file being operated on.
> @@ -37,7 +40,7 @@ struct file;
>   */
>  struct liveupdate_file_op_args {
>         struct liveupdate_file_handler *handler;
> -       bool retrieved;
> +       bool retrieve_sts;
>         struct file *file;
>         u64 serialized_data;
>         void *private_data;
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 9f7283379ebc..82577b4cca2b 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -133,9 +133,12 @@ static LIST_HEAD(luo_file_handler_list);
>   *                 state that is not preserved. Set by the handler's .pr=
eserve()
>   *                 callback, and must be freed in the handler's .unprese=
rve()
>   *                 callback.
> - * @retrieved:     A flag indicating whether a user/kernel in the new ke=
rnel has
> + * @retrieve_sts:  Status code indicating whether a user/kernel in the n=
ew kernel has
>   *                 successfully called retrieve() on this file. This pre=
vents
> - *                 multiple retrieval attempts.
> + *                 multiple retrieval attempts. A value of 0 means a ret=
rieve()
> + *                 has not been attempted, a positive value means the re=
trieve()
> + *                 was successful, and a negative value means the retrie=
ve()
> + *                 failed, and the value is the error code of the call.
>   * @mutex:         A mutex that protects the fields of this specific ins=
tance
>   *                 (e.g., @retrieved, @file), ensuring that operations l=
ike
>   *                 retrieving or finishing a file are atomic.
> @@ -160,7 +163,7 @@ struct luo_file {
>         struct file *file;
>         u64 serialized_data;
>         void *private_data;
> -       bool retrieved;
> +       int retrieve_sts;
>         struct mutex mutex;
>         struct list_head list;
>         u64 token;
> @@ -293,7 +296,7 @@ int luo_preserve_file(struct luo_file_set *file_set, =
u64 token, int fd)
>         luo_file->file =3D file;
>         luo_file->fh =3D fh;
>         luo_file->token =3D token;
> -       luo_file->retrieved =3D false;
> +       luo_file->retrieve_sts =3D 0;
>         mutex_init(&luo_file->mutex);
>
>         args.handler =3D fh;
> @@ -569,7 +572,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, =
u64 token,
>                 return -ENOENT;
>
>         guard(mutex)(&luo_file->mutex);
> -       if (luo_file->retrieved) {
> +       if (luo_file->retrieve_sts > 0) {
>                 /*
>                  * Someone is asking for this file again, so get a refere=
nce
>                  * for them.
> @@ -577,21 +580,27 @@ int luo_retrieve_file(struct luo_file_set *file_set=
, u64 token,
>                 get_file(luo_file->file);
>                 *filep =3D luo_file->file;
>                 return 0;
> +       } else if (luo_file->retrieve_sts < 0) {
> +               /* Retrieve was attempted and it failed. Return the error=
 code. */
> +               return luo_file->retrieve_sts;
>         }
>
>         args.handler =3D luo_file->fh;
>         args.serialized_data =3D luo_file->serialized_data;
>         err =3D luo_file->fh->ops->retrieve(&args);
> -       if (!err) {
> -               luo_file->file =3D args.file;
> -
> -               /* Get reference so we can keep this file in LUO until fi=
nish */
> -               get_file(luo_file->file);
> -               *filep =3D luo_file->file;
> -               luo_file->retrieved =3D true;
> +       if (err) {
> +               /* Keep the error code for later use. */
> +               luo_file->retrieve_sts =3D err;
> +               return err;
>         }
>
> -       return err;
> +       luo_file->file =3D args.file;
> +       /* Get reference so we can keep this file in LUO until finish */
> +       get_file(luo_file->file);
> +       *filep =3D luo_file->file;
> +       luo_file->retrieve_sts =3D 1;
> +
> +       return 0;
>  }
>
>  static int luo_file_can_finish_one(struct luo_file_set *file_set,
> @@ -607,7 +616,7 @@ static int luo_file_can_finish_one(struct luo_file_se=
t *file_set,
>                 args.handler =3D luo_file->fh;
>                 args.file =3D luo_file->file;
>                 args.serialized_data =3D luo_file->serialized_data;
> -               args.retrieved =3D luo_file->retrieved;
> +               args.retrieve_sts =3D luo_file->retrieve_sts;
>                 can_finish =3D luo_file->fh->ops->can_finish(&args);
>         }
>
> @@ -624,7 +633,7 @@ static void luo_file_finish_one(struct luo_file_set *=
file_set,
>         args.handler =3D luo_file->fh;
>         args.file =3D luo_file->file;
>         args.serialized_data =3D luo_file->serialized_data;
> -       args.retrieved =3D luo_file->retrieved;
> +       args.retrieve_sts =3D luo_file->retrieve_sts;
>
>         luo_file->fh->ops->finish(&args);
>  }
> @@ -779,7 +788,7 @@ int luo_file_deserialize(struct luo_file_set *file_se=
t,
>                 luo_file->file =3D NULL;
>                 luo_file->serialized_data =3D file_ser[i].data;
>                 luo_file->token =3D file_ser[i].token;
> -               luo_file->retrieved =3D false;
> +               luo_file->retrieve_sts =3D 0;
>                 mutex_init(&luo_file->mutex);
>                 list_add_tail(&luo_file->list, &file_set->files_list);
>         }
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index a34fccc23b6a..ffc9f879833b 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -326,7 +326,12 @@ static void memfd_luo_finish(struct liveupdate_file_=
op_args *args)
>         struct memfd_luo_folio_ser *folios_ser;
>         struct memfd_luo_ser *ser;
>
> -       if (args->retrieved)
> +       /*
> +        * If retrieve was successful, nothing to do. If it failed, retri=
eve()
> +        * already cleaned up everything it could. So nothing to do there
> +        * either. Only need to clean up when retrieve was not called.
> +        */
> +       if (args->retrieve_sts)
>                 return;
>
>         ser =3D phys_to_virt(args->serialized_data);
> --
> 2.52.0.457.g6b5491de43-goog
>

