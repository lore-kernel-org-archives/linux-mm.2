Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFC9109449D
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 23:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204D76B013C; Sat, 21 Mar 2026 19:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5396B013D; Sat, 21 Mar 2026 19:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5216B013E; Sat, 21 Mar 2026 19:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E80B86B013C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 19:05:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70C1E140622
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 23:05:47 +0000 (UTC)
X-FDA: 84571604334.02.2589792
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5701140006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 23:05:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LVHdKtbW;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774134345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxFfukiYQfTiKo8hngBXYOGIkpypLUKnBpebRqVgDE8=;
	b=tz8Atgy/U0AsSGe63ml0oJD4CMnKdeMQfLSPviLVnlLOtjIfI5qrFH4ib69Ul02rpPhGgJ
	l0s9gKBMTCHp2MGVyvAh/KR5ocg4TFmvCoTgp3nuy5+JFWR81WB5Z+/zWTixi7WYUIMt9l
	njwoN3mtx9e/RfFoTU9exutPwA5Ms9A=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LVHdKtbW;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774134345; a=rsa-sha256;
	cv=pass;
	b=ZKM1Le7GfMHHKRs+IyZ5BoUqvLOFtEZagESJ7N6DXjWELvCfPxnnpmWF6li7gcVHtZDpQW
	c3hE6zIa0cypAyBWjlJr6Hvsx7V7VudfFpjLavqMbI5ck1lgvGbUZDN5lkkFHKY/wx4ylt
	IdZkcW+GWdYCvjw1CSPzWw+9EY9Y2W0=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-668d4751a3bso2573540a12.2
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:05:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774134344; cv=none;
        d=google.com; s=arc-20240605;
        b=P7B96D/6Bn0WLluJJIDX0kDRLHk7S0LkiesXWz9YZORdEtxwbIWPUFXLgf4tCSa83e
         Vb1AsuaGlQ0eAUhEGOw16c3jV85H99UzqHYK0yNkzOkGXp2UPk3ejTFP60d+nBVOJd6R
         2LOLtOF7irzyhQEEY/sh3QUqrivq1GFjr+Fyz5hR3HHJiqRNGeHuRXo5PegWIZXK68FA
         zq2YFvHULjNV3952Q9yp4XAzII0Qzx51S4msR3VeW0bqZ4NLYKU1Rnro8TZKHX2L0zeV
         LAyNy74+ZHSQeHH7c1LVr63Q1CxzXRS9ptyVIZTKw/anV0JWpS438cBF1TRE87+f+wVB
         0u0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NxFfukiYQfTiKo8hngBXYOGIkpypLUKnBpebRqVgDE8=;
        fh=JWjlY3ueReDI8B3ilpZxryyPnvtD1Peg8+fb1mrpdwc=;
        b=DsQaXMmeuy3YcGs+nppKJu2UTLFFFZSIV6YaeWefBMhx0NARLV29ckDMG7xmIFwIi3
         XwZpXtSc8uGKlVlph+ndaHrp3UTAtl5eWCjbNjKuHz1nTXeFl4XcxPjFVg98xn97/MU4
         QQEZqi+wcgXu7G4aD4QDWIKApGLgW51MyiDKM6LR8HcBo5fAtqBRgdIMeDmXGggsCyAx
         5sKbIhGS+jQJTcsIzsOlgznFVar01hHPtxorSzsBh/nr0vWii7/2ck+x7LlUYZqvvOXA
         iBFC7vbqF2iROjb00XoQ/JFTasgjLV0YllJfmz5YNtr4NZiSDLA1U0SZkb4Fp1hWVUkO
         Wz8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774134344; x=1774739144; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxFfukiYQfTiKo8hngBXYOGIkpypLUKnBpebRqVgDE8=;
        b=LVHdKtbWk33qd12pCODgGLiIP6uq3a+Wqc73KgQmRsAahcXF38B9pd81/rUg8+DxdZ
         oFOR0a9JnGQgqlWyMkZW0cWI7kxmrHrAwVrToMNg13fazi3ojv8FaRo0eJL9gYUwIPKC
         l9s6ijp+tYP1hTDZK/71u9Kj59PgdJR3GdIrSK9/mQT1PkRJtgGrsBNhAP1VhjR8kFCn
         Jh8FNCZFLCxq+nMzk64CToEIQQN4pWtbmAqTtk3pSj8ZR/l+FlA13f9Xy3/g4gOimgE9
         meBllcLtgQK2fpCeGdkGRjCgOFcZbAEQ86V9hZOmyHwhYVzUWrnh7GiwMe2iy5UfUlaG
         IHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774134344; x=1774739144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NxFfukiYQfTiKo8hngBXYOGIkpypLUKnBpebRqVgDE8=;
        b=c3wB37mEC3KGodjMxglAODcmlXeA62BPcCsU4/1HfSmT6CqMmPiOyJCnIRA2WYuHtI
         wD5RyKht07FBfClLceZXE2330oUU18ppDTYe91OpM5+CO9c8zujPHUUIyXknBCoa4wro
         fvwmY4RWBemrS4btvbxLYAYMnVSyhpUMcAgvnTWjNkUO7vS/8wE11MUsdxBHGAEYSvxm
         kmXykUAMuBSKP+XS6m/k2jGTSwPv6jIGtQVHMgo7vb/lx3wWPsFBOjhHuGuT6MHmSrQk
         SwyjUu4qBpwMQvUZkKWgUXZ3K4GG23K312NjbSkVkq95Qmb0PV2UgdgbrMaQ4Tl1vnsX
         VYYw==
X-Forwarded-Encrypted: i=1; AJvYcCXJnqGR1eegzaQFg0clRAhB1KwMjB0Q6GneSGfCJBMTj5Yc+S6nRQnjbwnw3WC1tSt6NgLF2EvyPQ==@kvack.org
X-Gm-Message-State: AOJu0Yy26ClyTG8t25aGLcToXlOoYSNGzvCIUA3aVJsoANxIhY6Dgqkq
	i9TCt3ReqjqmycoI72PHBHbVDSw+VEn68cwBys4JHeQAeoXolkxlf005EdxVDSqDuODQ3LECicj
	UD0bMlGGnBADQdrxKh4qIRaovpeh0WlOIS39rCPkHKg==
X-Gm-Gg: ATEYQzw+vU4iX88BSyDUjeUp6jM6zRgDvKnhKQDU9dDJmaRQlKb9CnXOpbVKWS7gOfE
	2JXoQ9Gz9VGDVWHM7TUatMvgbCx5v25R3MqWCZh9L/cjOJBzPdmSZJH60aOWGEDPzcQW4pMwX8c
	9WaHFtEi0fwdjXSE4N0YOLl+YHF2tvYtHm4HW9ii9FQYWSJT6/Ct9myrP21g/JSjnaaUQye2JuX
	GomirgYUQbP3FWTuy5FISKrBrrkjaFNPX19JnnG4XweJVPliYJHaksZZ454MND8A0a7CB+SkdWU
	+FY5TgsnseOw1PgXBZNyPAwCOfsqKWaU8Zfmi6YkAG3pzjVd
X-Received: by 2002:a05:6402:5287:b0:667:7d90:71cc with SMTP id
 4fb4d7f45d1cf-668c911507amr5739041a12.3.1774134343288; Sat, 21 Mar 2026
 16:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260321143642.166313-1-oskar@gerlicz.space> <20260321143642.166313-2-oskar@gerlicz.space>
In-Reply-To: <20260321143642.166313-2-oskar@gerlicz.space>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 21 Mar 2026 19:05:07 -0400
X-Gm-Features: AaiRm52N1A5JiyPRBAXH_ftxFPoPbwtABbjPiEkUX2L9NL3d-c2DKSK2P4FMnrU
Message-ID: <CA+CK2bCVge7xybLshgLLphHAdRSHMLD3egT1nEyESBUFi7kHCw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] kexec: abort liveupdate handover on kernel_kexec() unwind
To: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Cc: Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5701140006
X-Rspamd-Server: rspam07
X-Stat-Signature: 7wm77y9hqazwxgbdopgdkzdnj11g1z5a
X-Rspam-User: 
X-HE-Tag: 1774134345-834776
X-HE-Meta: U2FsdGVkX18HaZPO6GhKhrMwvdiBU9RT+O1L+WXEF/aCLj63ynu+s3h8yu5zegQ5v725Dj6dFIOCdGEnO8i/vEuodNStMpNWtnz3XtWdm5VXy9SUpXMwMGNikfiatMTD1KUlLkrQGxvf0UD5tRRh3PqfOmioVZsWf7aa9MswVIPdBbKePU9HpbEoYZOowJB1s73UzsUbHrd/6HwmNVtlZ+l9VXavxwyi+E/UdZDmH5fndzQvAW2kTY5/KBgpKMbckg92sHRN8zyJB3Ff514GvvLU0BMArImnobXe4gI2V0ptxx1PIbYG2aByj0MRFGM/YGvkxwqWPF/6/6z56ou1GE/kRFCfgY/jWawHFSoKwD3QetEVQ9CEvbhR7JTGPj8IphuNI3bpN8y2MjYuK29sSqCAWD6CmsejsdMQTnuxXQoo0WOkZ0rxfPkROqljnAO4aj23xaxL41UFvbFSoimWCUB7Ml2AqtSs5bb3oxoCVGcTiDVIUR1iUpkDmtqeAH7vlinHFllqHhV6DMyRlr25sja/lJKTtJOjGdmf7h3xlK/F1iqIOQa5eOX7xZtuCvuiacMrLOAGprF0BXiuu/W1DXQHqT6kqVhvQpED7DW9CMCZTRng6fZB9p0KMEh1qXs2wIPyYZhlOkpp15lqzQFokw5rYX6ObaliFgIi9h2UyUAo+AmORXJwAad1ZWwM0Bbs5dQg9aNheVJMqJ8WNcFqX/P8gJ7ac3e1ZrpwlhUZWsGazAOYu9UVmsRw24ljem2UhsidB/JHv9L2OwmhR20R60G5xPlExFqCwVE/tE5t7zwAK76XSzsH/hwLI+VENmqE61HnO0orWwPgXLRKvrir8P0lkN+zdhI2Kg7TOzGkvdEhNLxnlzG+01iNNW8ubj0sqEEHn8VmcjuHnW4XD+KUqhAs71/oIXjOFTMLzYnHbHvWbDHXYduMPocwW3APzWZFSo1YvrQ0CajGRsnyEiG
 GA2rlENX
 /kqcwJuupR62rxHGhWikoT2oGSUtqE/3wF5Mu5uh+9nUJUf7yNiUC0WXjArbLAw3/UofRiyWUiQ6BuXAWYeYl7p/+Hioa5Pj6Vz5HLk7j6tiTohxbutAq01cMhb52+3wuwRvBckNAPUXnedkUp/7XcyVYVkJco9uHZ69IETLYV1M3EHNjGyqjq3HPh5dra7TW7AbFy0LZEk4zBkXvFINsjeb8JPk5TV3LjzZOmZCk1mPosmvwkS+MvU0Bc7HUyCVHG1O8uldR1m1NwrgFdZJ0T040LheNNFs5Lv3b0B5lsvlpoCZJ47xfhAuSrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 10:39=E2=80=AFAM Oskar Gerlicz Kowalczuk
<oskar@gerlicz.space> wrote:
>
> liveupdate_reboot() can freeze outgoing session state before the kexec
> transition completes. v2 only unwound that state when kernel_kexec()
> returned a non-zero error, which misses the preserve_context path where
> machine_kexec() can return to the old kernel with error =3D=3D 0.
>
> If that return path skips the abort, outgoing sessions remain stuck in
> the reboot state and later user space operations cannot make progress.
>
> Treat every return to the original kernel after a prepared liveupdate
> handover as an unwind point and call liveupdate_reboot_abort() there as
> well.
>
> Fixes: 8b32d3ced269 ("kexec: abort liveupdate handover on kernel_kexec() =
unwind")
> Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>

AFAIK, preserve-context reboot is no longer used; in fact, it is
currently broken. I tried using it six years ago and hit an old
spinlock bug in the x86 code that prevented it, which means this path
touches dead code.

It was originally developed for machines lacking hardware support for
hibernation, and I can't imagine anyone using it today. (I know Amazon
is using it for a non intended reason and that is a very specific
scenario in a costumized kernel that internally fixes the upstream
bugs, and would not conlict with live update).

During live update, we cannot return to userspace after a successful
liveupdate_reboot(). We specifically place liveupdate_reboot() in the
kexec path as the last possible point of failure. Perhap, to guarantee
this behavior, we could  add !KEXEC_JUMP as a dependency to KHO and
LUO or crash the kernel.

Pasha

> ---
>  include/linux/liveupdate.h       |  5 +++++
>  kernel/kexec_core.c              |  6 +++++-
>  kernel/liveupdate/luo_core.c     | 11 ++++++++++-
>  kernel/liveupdate/luo_internal.h |  1 +
>  kernel/liveupdate/luo_session.c  | 23 +++++++++++++++++++++++
>  5 files changed, 44 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index dd11fdc76a5f..d93b043a0421 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -226,6 +226,7 @@ bool liveupdate_enabled(void);
>
>  /* Called during kexec to tell LUO that entered into reboot */
>  int liveupdate_reboot(void);
> +void liveupdate_reboot_abort(void);
>
>  int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)=
;
>  int liveupdate_unregister_file_handler(struct liveupdate_file_handler *f=
h);
> @@ -250,6 +251,10 @@ static inline int liveupdate_reboot(void)
>         return 0;
>  }
>
> +static inline void liveupdate_reboot_abort(void)
> +{
> +}
> +
>  static inline int liveupdate_register_file_handler(struct liveupdate_fil=
e_handler *fh)
>  {
>         return -EOPNOTSUPP;
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index 2fea396d29b9..95710a7d5e56 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -1139,6 +1139,7 @@ bool kexec_load_permitted(int kexec_image_type)
>  int kernel_kexec(void)
>  {
>         int error =3D 0;
> +       bool liveupdate_prepared =3D false;
>
>         if (!kexec_trylock())
>                 return -EBUSY;
> @@ -1147,6 +1148,7 @@ int kernel_kexec(void)
>                 goto Unlock;
>         }
>
> +       liveupdate_prepared =3D true;
>         error =3D liveupdate_reboot();
>         if (error)
>                 goto Unlock;
> @@ -1230,7 +1232,9 @@ int kernel_kexec(void)
>         }
>  #endif
>
> - Unlock:
> +Unlock:
> +       if (liveupdate_prepared)
> +               liveupdate_reboot_abort();
>         kexec_unlock();
>         return error;
>  }
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index dda7bb57d421..95a0b81ce60d 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -233,8 +233,9 @@ int liveupdate_reboot(void)
>         err =3D kho_finalize();
>         if (err) {
>                 pr_err("kho_finalize failed %d\n", err);
> +               liveupdate_reboot_abort();
>                 /*
> -                * kho_finalize() may return libfdt errors, to aboid pass=
ing to
> +                * kho_finalize() may return libfdt errors, to avoid pass=
ing to
>                  * userspace unknown errors, change this to EAGAIN.
>                  */
>                 err =3D -EAGAIN;
> @@ -243,6 +244,14 @@ int liveupdate_reboot(void)
>         return err;
>  }
>
> +void liveupdate_reboot_abort(void)
> +{
> +       if (!liveupdate_enabled())
> +               return;
> +
> +       luo_session_abort_reboot();
> +}
> +
>  /**
>   * liveupdate_enabled - Check if the live update feature is enabled.
>   *
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_int=
ernal.h
> index 0cfc0269d746..8a6b1f6c9b4f 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -88,6 +88,7 @@ int luo_session_retrieve(const char *name, struct file =
**filep);
>  int __init luo_session_setup_outgoing(void *fdt);
>  int __init luo_session_setup_incoming(void *fdt);
>  int luo_session_serialize(void);
> +void luo_session_abort_reboot(void);
>  int luo_session_deserialize(void);
>  bool luo_session_quiesce(void);
>  void luo_session_resume(void);
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index d97ec91e1118..200dd3b8229c 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -788,6 +788,29 @@ int luo_session_serialize(void)
>         return err;
>  }
>
> +void luo_session_abort_reboot(void)
> +{
> +       struct luo_session_header *sh =3D &luo_session_global.outgoing;
> +       struct luo_session *session;
> +       int i =3D 0;
> +
> +       guard(rwsem_write)(&sh->rwsem);
> +       if (!READ_ONCE(sh->rebooting))
> +               return;
> +
> +       list_for_each_entry(session, &sh->list, list) {
> +               if (i >=3D sh->header_ser->count)
> +                       break;
> +
> +               luo_session_unfreeze_one(session, &sh->ser[i]);
> +               memset(&sh->ser[i], 0, sizeof(sh->ser[i]));
> +               i++;
> +       }
> +
> +       sh->header_ser->count =3D 0;
> +       luo_session_reboot_done(sh);
> +}
> +
>  /**
>   * luo_session_quiesce - Ensure no active sessions exist and lock sessio=
n lists.
>   *
> --
> 2.53.0
>
>

