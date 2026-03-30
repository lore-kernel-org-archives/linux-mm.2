Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51F01061B1B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521726B008C; Mon, 30 Mar 2026 15:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2246B0095; Mon, 30 Mar 2026 15:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E74B6B0096; Mon, 30 Mar 2026 15:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDA36B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:29:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E77C08C593
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:29:09 +0000 (UTC)
X-FDA: 84603717618.01.D726E3D
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8D5540010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:29:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Kckc6P0k;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774898948; a=rsa-sha256;
	cv=pass;
	b=WphZA7W3V0W1Qn0h/cMC5+4wiayECg2CBS4am+Aos8dGD8tFZHaD5eKhhRRlPDK+T0M17V
	GaA/c5PkqcQ2pzQPhnv0K4QK32LHbN6gSlTHd5j4dkT67pIIHzbyGPVFFkmjX8AzYpbOt+
	hbz0Az47rkP4TXVXfotFYeHPFUvKkJM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Kckc6P0k;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774898948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMPYY2EyNpnWJ1+KKKw7qEsz4X1iaUrZ6XK4zp9dMW4=;
	b=fmcSZ/feijrjuzs5/y7r3CUGumgIJ5gz0g3yEXe7UTVqRC0MAFsepv3o7xPc1LJpWxKweF
	sYazBqBNVIshPY5fe1CbjV579f+rrcUwjrSkJ+rSBQDyTCbyK1+k88fRwhw6LZvNq0PIdB
	dGFHapJ7igy+faGXSwzFDF+Qut8mRQQ=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-66aa2204e9dso10842808a12.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:29:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774898946; cv=none;
        d=google.com; s=arc-20240605;
        b=YLWu4y4xDPgd41nxnvYHkNjWu11r645DsDDcGLUFPuxALcAvCaiw2yOxbeBCpAas2H
         +0z+JWfMSev+0OqmOJt/NvUq10rr9Lkw99n149wADQODNhOc8nbHmXvVdotnJpuRKvHG
         yQKV0/UAfo/uT07IkXxnKz6xzgYt+ZBDwgMvxk0oJSTS98XWZAIzot0krQRCwdSy28Xg
         S/Ort66TI4cKjymo66IVvYGD/3fRIqnFi7y1I6SOPC39mGVXGxWqom6OS2m1h6YhtSha
         d0X8rbYsrYO5vBVPTHBpI6RYClaiPMUAr2keCW8YlU2FXiTzuT1j7AvKtB8lNOIWzvIQ
         dKOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mMPYY2EyNpnWJ1+KKKw7qEsz4X1iaUrZ6XK4zp9dMW4=;
        fh=l9cFd86I1Z2Ih6Hn355ShOv7WrduxAehjo03Kp3qZhE=;
        b=BRjzrNV4zl9h2DAxA0Jf7yQ4Zx89IcykmucwLOgRI6WPhVNdxR0zTvRUJsqKmK7Ys+
         C41ai44Jh69mCXuk2f6FEglxI1jy/k9l+4t0ftZM1d5Bo7fDFMTFauGsmaBlZ6pahJ3q
         VKeLt+Y4FgIvmLwe3DXvi9YNBvYHKQesng7IcMI2jcZukf1DQbo1oCx1DxKd9QQvPrlu
         RYqtMzIu0hbZOWq25y/wWWTbWpaLBXQik6qnNa5EvfHK+ADFnxbX0NABYjej3ibDUXDn
         xfZ2dkHxgi79b5XQSpEIqoSHbwsPd/526bAa1r91D08oPQp4C02Z+gBnqDABDOlGZUx5
         dWYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774898946; x=1775503746; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mMPYY2EyNpnWJ1+KKKw7qEsz4X1iaUrZ6XK4zp9dMW4=;
        b=Kckc6P0kL/AiuhNvqeDTGu98i4NUGih+XBvvIzsdWiqRCIIbB6fklTSEzJyFeF9dl1
         yz1eX51nn1B5RBPO6UyHnO7s+9cwwtTfBr+sGHyfCriYEyIkdfkmOcaufKHDd6wDIIBx
         +Yn7Tf4Lp+uPiO8lYwfN2Jhd5BoPmd+8DkjQnsUB7M/SBigYgDgDY6O3LtAfyVynX0BA
         2gx3pBOyViDdiV3LbLk7aBRZvkHW8hZdHSBderncOLqqpcbqkFDal5xnZDaabctiZuS6
         1i+P6C8wnfA7WjIEkBaqrtGW/YhUCFJro4m7ki29MZctPed+fT1vZBuS/5Q7+IIzF3v6
         5Hfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774898946; x=1775503746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mMPYY2EyNpnWJ1+KKKw7qEsz4X1iaUrZ6XK4zp9dMW4=;
        b=hPScyVi2yduC48v+QQLQo+YMJZcobrcI5Hw0YAIsZamnDhF03rnclNeT7E/awHn9Tp
         zKEBqmxEJSUkrOk6P4Bh9o8De6R5cD9yiNGlR8GPviVdiKYKqJDVNVYOh79ETKSTMl5a
         m4Yh72x97Fotu9oIQtZOD/yn4glgZgdZcO+kYW6O0FHt3FIMdmKJOOT183uqjfAN4zpN
         ArCUAf9vZEBqzORK/ZLrDeEWCWOOy6aeBQO6idjpgiZI0EMrI5BdSxEFMTyN2vNzTsLu
         4clF4tfsNIsmYvVxscR6x6YuIVpMod+kA1LY77LsvHl6/AYmJ0mR0kVRHndW3g/Cg000
         L88Q==
X-Forwarded-Encrypted: i=1; AJvYcCVr797H4AACUgzvFKsGDW6H2JwJJALdN9BVNtJ9awv+pfzJVMJE0kzD9V02RhP2NTQvfflgNyW96w==@kvack.org
X-Gm-Message-State: AOJu0YyLgyaJqDwYAchBCb+BSITOKMGhj8kriAtvDdGNjPnD911Z5p6B
	eBqVweAGfzraxs4mrSIPUf3Xd9sJqIjoNzZT3btTJ4FwsArKX749tOifYGaMKIMoVmbmmwiHyVw
	67eI6vtTALrqeTK4GyMA5/dMcjDkOuMeh8N9ugryOYQ==
X-Gm-Gg: ATEYQzxVLDTcVG1fkfLOk7QRU9lWbFZDRj0lg2QJYdWcSv8LjNMzoezB0zp2e3YVjaA
	YcETPwKN0EGdUcqxGZ5QqJxVaaWHRZyFJn+D+XIJAcQ7NjOVNOgid419MPrVWdb14GdOSnT0UyN
	js0j7lIHDYJvkPPH+Xkn7ISerdj+KH0rGvaoMF0ZkCQ3Jxrm5pTsq0Mnte7D7DPZeQUu2CxNXw7
	Gb75uqp/gWyBhqZihlPylfHOKWzFuT525XatWApKO87z+7ry78VesRRrR9t7eB3IoekptSQ1Lmh
	BduGG2OcDulOvzZaHbUD2Lw5OJz5OWFhwADWGQ==
X-Received: by 2002:a05:6402:2111:b0:667:90c1:844 with SMTP id
 4fb4d7f45d1cf-66c33839ca3mr406890a12.10.1774898945874; Mon, 30 Mar 2026
 12:29:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-6-pasha.tatashin@soleen.com> <acqrSaBSDdcgDmUn@google.com>
In-Reply-To: <acqrSaBSDdcgDmUn@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 30 Mar 2026 15:28:28 -0400
X-Gm-Features: AQROBzBVZxBKyX2BJ4pRBnUbzFzjOYoewZ5cEGzlyxETnFJtajzYAWbM6BXRH9w
Message-ID: <CA+CK2bCu5s9RUpbex7+D6Z9pu1FueKn-omjNbb3KQVmRrO1kXQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/10] liveupdate: Defer FLB module refcounting to
 active sessions
To: Samiullah Khawaja <skhawaja@google.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C8D5540010
X-Stat-Signature: nkzxmy8oes64f9yab8hj89pham5jt5aq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774898947-734200
X-HE-Meta: U2FsdGVkX1/rarWfzXfLicMNsimoXRJAzLMTPHZoO55bOsuoVPjGr67LKzX2Ek37a53Wm+sdBPSNHRrdlzRr3Lfw0X6k6YW8rQApyaQJLIlUW0b4qXgbDFf4O5m7q1X3cROZSsT7MW1Cr8IpZBNIglS3/KgDvsIkEiTcDFSaIWL24xmNDH3cpQGz5A/mya1J78iqPcchV2N4/qHxILfLrz+/BbVfouREa3IGnkNEoMdOxciAJznQXIafH5n1lIDcfoX4lAEDQEf8zwPmbQJ3b4tr8q62+lofLEYg+wAD+ql8/fzx0oqa4INYKbjL87NIiRYOsp177BWPxjsgO2LY9GfYRHzjBuoFlRNw+aHsL77k8htL+7EIaxjzDgRKYijrqjDNXPdHItQusIocjbsCt9QJDBL9KycbyVTgLRn2iLJWyXIMBcl8x/k/1smi7y2dcJhuk72R9xNMbH0awYRP+q42lKoVLHekVzfInpNIRoU/mX4E5pI2JHB81yPxMq9DuxhUTqc7srwSV1COi6EmFaV2iCu2CULo9tTSVsvkknSOC+ViJ/fNmO6/pOYu+O8DPNcipqmOZ+89TG7GVQlXnnD99HsG1MQvVB2t7nwX+ANyc1WxLRAlukME6nOnCSCgHvILYBjJy8EvnrQH7+8BJUZ1Yl6fu5iPVB5++tQwJBdOl357vFO8XhmMkKPoNAEI6eA812mXW2rS/+6WsD9VvbhDsWQjZaifeY0F4ep5XOtxYVGY/LU7h/wjft1kEKZ7deRJ6K4IiAy7/bMGNGs/myUwrodx1B0NfsNFJF3pLystMH1wq39uZ2nOVsifr5oWfT2//lT2bFE3cj3j1PmTv+8tKBC3Z3LtIyCYmyxde+NietaX4/0tlhreeZvvrodoadlKcRjyCkniXPiO9mgcQNUC561ADzUPuMEIxm84Gi20UKPXgJ9HxCWdk6/GCjxPg4nhPLm/slVA9XEgZPB
 ZJLi2tdh
 r4Q0l0HSzWi+8MDpE0WN2N1vmeXAFJHjQy3KHr7Af5bQfzj/BGnVu0xNcudChu37rAkbfZJzuUSxW8heajg1Ye1pDzj5QZcyqRZadMTSWKYlAx8pcwFPwPZoj9UAZ3vN5GL3I9IzFubG54oYcxToejfT4fF7QR928IuMSQNQ4R3WkAu498ZfCOniBCum1+6Qd05pk4vR13S/vojgTRklOZj9vh4acXTpRn1Qqtg0UtaEp2V0qfahzwvt5xtV8mRlycFTnrbgRouWs1y3mVQcZRXhgeBpSb2f3Shj6tL5A9g3yuHiGawsA5xH2B5Iq0OlpN3j3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 12:56=E2=80=AFPM Samiullah Khawaja <skhawaja@google=
.com> wrote:
>
> On Fri, Mar 27, 2026 at 03:33:29AM +0000, Pasha Tatashin wrote:
> >Stop pinning modules indefinitely upon FLB registration.
> >Instead, dynamically take a module reference when the FLB is actively
> >used in a session (e.g., during preserve and retrieve) and release it
> >when the session concludes.
> >
> >This allows modules providing FLB operations to be cleanly unloaded
> >when not in active use by the live update orchestrator.
> >
> >Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> >---
> > kernel/liveupdate/luo_flb.c | 27 +++++++++++++++++----------
> > 1 file changed, 17 insertions(+), 10 deletions(-)
> >
> >diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> >index 3c91d0008eb1..ce28ce9b113e 100644
> >--- a/kernel/liveupdate/luo_flb.c
> >+++ b/kernel/liveupdate/luo_flb.c
> >@@ -115,10 +115,15 @@ static int luo_flb_file_preserve_one(struct liveup=
date_flb *flb)
> >                       struct liveupdate_flb_op_args args =3D {0};
> >                       int err;
> >
> >+                      if (!try_module_get(flb->ops->owner))
> >+                              return -ENODEV;
> >+
> >                       args.flb =3D flb;
> >                       err =3D flb->ops->preserve(&args);
> >-                      if (err)
> >+                      if (err) {
> >+                              module_put(flb->ops->owner);
> >                               return err;
> >+                      }
> >                       private->outgoing.data =3D args.data;
> >                       private->outgoing.obj =3D args.obj;
> >               }
> >@@ -146,6 +151,7 @@ static void luo_flb_file_unpreserve_one(struct liveu=
pdate_flb *flb)
> >
> >                       private->outgoing.data =3D 0;
> >                       private->outgoing.obj =3D NULL;
> >+                      module_put(flb->ops->owner);
> >               }
> >       }
> > }
> >@@ -181,12 +187,17 @@ static int luo_flb_retrieve_one(struct liveupdate_=
flb *flb)
> >       if (!found)
> >               return -ENOENT;
> >
> >+      if (!try_module_get(flb->ops->owner))
> >+              return -ENODEV;
> >+
> >       args.flb =3D flb;
> >       args.data =3D private->incoming.data;
> >
> >       err =3D flb->ops->retrieve(&args);
> >-      if (err)
> >+      if (err) {
> >+              module_put(flb->ops->owner);
> >               return err;
> >+      }
> >
> >       private->incoming.obj =3D args.obj;
> >       private->incoming.retrieved =3D true;
> >@@ -237,6 +248,7 @@ static void luo_flb_file_finish_one(struct liveupdat=
e_flb *flb)
> >                       private->incoming.data =3D 0;
> >                       private->incoming.obj =3D NULL;
> >                       private->incoming.finished =3D true;
> >+                      module_put(flb->ops->owner);
> >               }
> >       }
> > }
> >@@ -412,11 +424,6 @@ int liveupdate_register_flb(struct liveupdate_file_=
handler *fh,
> >                               goto err_resume;
> >               }
> >
> >-              if (!try_module_get(flb->ops->owner)) {
> >-                      err =3D -EAGAIN;
> >-                      goto err_resume;
> >-              }
> >-
> >               list_add_tail(&private->list, &luo_flb_global.list);
> >               luo_flb_global.count++;
> >       }
> >@@ -493,12 +500,11 @@ int liveupdate_unregister_flb(struct liveupdate_fi=
le_handler *fh,
> >       private->users--;
> >       /*
> >        * If this is the last file-handler with which we are registred, =
remove
> >-       * from the global list, and relese module reference.
> >+       * from the global list.
> >        */
> >       if (!private->users) {
> >               list_del_init(&private->list);
> >               luo_flb_global.count--;
> >-              module_put(flb->ops->owner);
> >       }
> >
> >       up_write(&luo_register_rwlock);
> >@@ -527,7 +533,8 @@ int liveupdate_unregister_flb(struct liveupdate_file=
_handler *fh,
> >  *
> >  * Return: 0 on success, or a negative errno on failure. -ENODATA means=
 no
> >  * incoming FLB data, -ENOENT means specific flb not found in the incom=
ing
> >- * data, and -EOPNOTSUPP when live update is disabled or not configured=
.
> >+ * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
> >+ * live update is disabled or not configured.
> >  */
> > int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp=
)
> > {
> >--
> >2.43.0
> >
>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

Thank you Sami.

Pasha

