Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBCE106ACFE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15FFD6B0098; Thu, 12 Mar 2026 19:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E38E6B0099; Thu, 12 Mar 2026 19:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24886B009B; Thu, 12 Mar 2026 19:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE9206B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:59:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75F591C48F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:59:40 +0000 (UTC)
X-FDA: 84539080920.18.631CC23
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 50123A0009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:59:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QiwNdZng;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773359978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTqNpGgN465Yvz/rSl1CgTF/afuaa3OeIu5BLYs4TjY=;
	b=xJCGzSO7N1rM63ZT11+EFobzV+Gp3LwB53XPnbUGBOAJn2vTa/ueOIGu0gga4+YveAH13s
	Hr8OUwsb88CBCPQw7mREicb4lU6jVVYVrH2RSY2EKciQSiTHKPRa3DLcjZKhpTXapv11m5
	tW5fsotmlC54DczR69MchBQJl4SholI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QiwNdZng;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773359978; a=rsa-sha256;
	cv=pass;
	b=mhVa/N2rb3aKjg+ZVmM2s//Qub71wXafCJp8h6xlj9E403DRLuHwWtCsj0cBp+ef5i8pk5
	z82AHaQuZQ/vlClHisnoCsvgnYLPzGRTzYZpDT2miOUHHizjiI/eq0qhmXMTFyVchzRS5A
	pl86bAwehxuF+PbrhOrCBhr1yZvjpLs=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38a67221fe8so14675701fa.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773359976; cv=none;
        d=google.com; s=arc-20240605;
        b=A1P4RdOlQGrNiEiD7Va+wd5HGoFS06pAz/DdmxOyg3DavJSout3zuDz9jml4wc3mRo
         toqUBGuVM1kxmVp5TLC4SDuLnchso5idQiqC/37cRC5hJYgbsVciulIKxsCX01OCjieg
         6q2/VRT6fQ/iYvCF8Dt/OVH7DOzYryBwYZIx4qSadxZ+7vFrSsKZUKvuKa4VE7PloSw+
         //hRVWHCnM+wv9/TVSYJpL+3VM4EqKG+GOy6kWGbkexnLHs03muoGq/urr3F7qVEvRLq
         wxhPWLEuOnTM2XjFA8qi+dmtazApnC/h6UPtWqtCrf9ahFOgB86asN62GsC5EWtG3ODQ
         k0xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bTqNpGgN465Yvz/rSl1CgTF/afuaa3OeIu5BLYs4TjY=;
        fh=WaR27YUfDgGTDC+DutDh1IvpA6nowVxc+ftEvpG/lco=;
        b=laSQLY2yEJ2TCaDgU5EPSSoj/KOulBAQIUPS5OA3+w2X1XmTc1f/+mHwqGY6EY0EmU
         O/xDgYrwnWQTe4iqTvv0baQ+P9r8uaX6uyZDFoA6hHAdYFJaL5RPWL8cq0oBj+9Sd7im
         AsdNkxqXRdObZYfBnEQSw7cGtpiKdC236YNAkPmnkP9l0NtEz1tfCbDuxeuUNIYivi/j
         iZ66D2E9RCWbyO8qsQ9ugVybWw4wH7gt0ELAeHCF5c9UUeWF9ghaRlPiGgazYn7KXNoM
         Xam7qsfWXJq0j4RaCtqNIXcgbPeQnXGxlT2O7mszM+1rZyQAQTIgPsJAgCJne1ybvag9
         m4tA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773359976; x=1773964776; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTqNpGgN465Yvz/rSl1CgTF/afuaa3OeIu5BLYs4TjY=;
        b=QiwNdZngtEGEQ8CBBDOwPY0pK+sIv6Z2Exs8A01ITD4QnCVAKkxkj5xLezWURF0xEF
         J28HjbK3H0YDL7ILylad1zGUerJKv2r9/1QfPy2zK/guFtMJM8bj0Hjxqp83NtRqPx6Q
         YnP7fW8/BO0CG+JxuURTAz5xuu5/9LE8Jj1/dtGy7Pr7PXtiourEGoK8xgD0T2vlGLIN
         bxNrXNOjyp3rfKtoFmKkTmXoKF8RYYAqbvf0x2nnjVzNE74XO0FDgXym14U7EF5iJQy9
         OaBHkYJXuLwuaX2FCC3nT+SoLuWGbdl7jJsLlxnbbcmk9avB+s/frDhFy8bPCBRgwCZu
         ANfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773359976; x=1773964776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bTqNpGgN465Yvz/rSl1CgTF/afuaa3OeIu5BLYs4TjY=;
        b=kFVWE/NU+I46hX6EaovgXaQMs97x1pmUaCTZsMSddUU8HLU0aQhtk1AIauwld3kOAs
         s4RwvCD0F4MYSP7adj4ObRLR0u1lzpeBkpBwojvsU4Z7iwe+oqv/8Yg4+5cWVHgur4if
         MJ8B45UvEhsrQTj5d0SGy+74aZ1qGy0LFq/MrPOX+QjXDm2E5vr8rn4gfN8KPrXvKAiY
         52gzO/s59gmkdlXIjAxb9Km8al92d1gAsGHksLBna7uczFYsCxV/Q5H1hkQ9HlGoYJ6m
         sNxZnL93EK9enktGuDKQ+PSdh3vjXQn0Ky9BLsH2Cr3KJZ2IWBWflFp4mn5msWm2NfAn
         8x6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVM3vQOHT29BcN0R3WQRCB7PnXfG3HyDW7Q4X3HUIdDg2FWCeA8cU5owl5PLf35pSAHWsImCqXeKQ==@kvack.org
X-Gm-Message-State: AOJu0YzkadF5hty+UsbT9hK+9+RP2DWJ/Gswop3RB9dczWrp9ZrbLWz6
	9cVQBtu5rro99V7r9StJYoQH5G7lmqfkBNDzcU7/NY4lqDJ5Nj+YcaCn5NLd1tVlukj3YuPdQ7j
	mBaoDFZDvW1nNdniQDmdyE8/Z4rIzjb9MqaJmgQ0a
X-Gm-Gg: ATEYQzxuCE1PIoSCmetl4scJJNXEK8CePEfmzmeStA846xfiNT6Qp2fI402BCmZ2QfW
	6GP9vF1PgAsOvMt5Vd1Rd2RgJ4qnRNL0nR74PyYUgsdLo6XDNbyVEaWp4Iq7qAo7NfpEGKWkSz9
	SLkMgQcQWPsI7BcBVVx/BiHe8zPlx99/MDmR1mu7KnxAieanx6tr6Ti824DHr6WyS69F2ZbWTyW
	rGr+XuFn3FB//zc3tKObo0FyhlC9P8TMmNeZeykGJq1Sjtnr8Q5fmNi9S01iLhMqQLLG+wvGPEx
	mEDRfmFs
X-Received: by 2002:a2e:a98b:0:b0:38a:8b28:f9d4 with SMTP id
 38308e7fff4ca-38a8b28fc87mr2205331fa.41.1773359975972; Thu, 12 Mar 2026
 16:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com> <20251218155752.3045808-5-pasha.tatashin@soleen.com>
In-Reply-To: <20251218155752.3045808-5-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 12 Mar 2026 16:59:08 -0700
X-Gm-Features: AaiRm53g7VGNXRbyX9cPaNdq7ZlceruL4-G4Q2GJaYwWhokxL7AnPTywHH32ZSk
Message-ID: <CALzav=cJmgG04+Ba82Rnr3iKpU0gKD5WD3oF-_43rdD7T+REEQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] liveupdate: luo_flb: Introduce File-Lifecycle-Bound
 global state
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, rppt@kernel.org, skhawaja@google.com, 
	rientjes@google.com, corbet@lwn.net, akpm@linux-foundation.org, 
	kees@kernel.org, davidgow@google.com, pmladek@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nicolas.frattaroli@collabora.com, linux-doc@vger.kernel.org, tamird@gmail.com, 
	raemoar63@gmail.com, graf@amazon.com, Bjorn Helgaas <bhelgaas@google.com>, 
	Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 50123A0009
X-Stat-Signature: cib5cja9c589hqtnfhph95yodkg7z8mx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773359978-674307
X-HE-Meta: U2FsdGVkX18YnfsFeN4N0M3vccUWhBUEbDmX1pqKELeSonDR/swPasOqoUYdfcxTzD+KZaHRe6qkqj2JzmFbN5uOSmURGTB3T21/g8PneM/FGLMRhgrDwDREjF7M5qSfypzsSn0isAByb0BkPdyssFn2VbTPsPldnL4ktyvv16RznR1xZ9gKbDCmbb3l0euCHYn3ImvNmAxmNu9I8VebnSTtIQq1QztCILSqs9AxkcBgCLCsKxf5ygQBpV+3rVliBgCa1IUOfP7wweUne1X9IfFwaKrbhd0e4z3scbmWXyMLZ27WIuIZh1lI4Uvjg2JO/9zkmPyXLliWg9N36M7gWY/GX5PBCGz8klIOldfFhCM5TjNhZMqjOyMjwGrBsVDl/vitL8Fh5dk11PNhCYxCJs6bWErCTAI3lAHUBu8GKpoKIivOg+lqC8Ryk/TIKcU+GMQbJibVX6yExSiVlfIcPfKj7pzdjTG4+lblbqY64W72mhnRMfXNzSLEWQGpJHT67CuKHfFX+sioiJPJll9kocvsSYcp0aoCl8mjskTabYyu1RyzdkI7dVGf6lqyOHpRL1hOIGGfjX6/z3athQiDspqt7kcHC1FTr311hagdH/hhFEgesPb1DaxdfoLvcHSV5IxvVBljC/IJA3PCuHjT9ILAZyrJHyPRCwwuXs0DXBxUQO6HHy6ahAyYFuLH1ZA9twjf2OLXvWFoz55qC2LPumTQ32/kWO+/obf9ZlhwTV7s/U9soi7pQGHNCU7hHQrH4OaRWH/j7tyEWlfDpvLQP8u8hOncXkXZj4upufZAyQY820VAn4Yes3JvFUU9u2N+1gqqn3CfkKt6NMRxGM2HcxrCUG9F1fK5JXvcncMNDCabgQbQRHdCJYjCelpaw89HRsZ/NRajx3M1NIcztE92LYdPTsvvu+tpRxUcjh2EZas+DACFEg8LsAfJXX5wScHfgI65+ucyMKpBbdYuxEF
 FrJDWtGr
 3GLaROBU6xmu8cXFWZ33VIOKymLKOOR0qeVK6fEid+BWnlqhpxXcPgQhReByDipk6dvEs7/DtTqgC0xJ9iC0NMltfILijgfd0aLjTXOvE6pwxcf4CL4+AsD3ACRSFORqUcMwOhSesaA0xKCvXSpnDNfL0M/xJNaFYlwrUiui2Q+PLBw5RL2pC2weOGT04cU7W0z7EIOTt2mjhAzka2F11NfLbyBq5lXyzTgcToG0rFP1vWME1w81ul584YJCVaI545yQ1dntaO03N3dAQPfL56yLzVyc58YxrUKaXaFCXW7bCC3opYuOUq+ehe6e/m+juVR51morJlCjj+gBFKDcxyiYiOHWVgj/xxxZOlZuADDP71Nbvr+E5jjEg1cRAXq8R8IgT0M7MhVsUZ2+2tdxPSc3yo7HTHZ8IWnbg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 7:58=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> +static inline int liveupdate_register_flb(struct liveupdate_file_handler=
 *fh,
> +                                         struct liveupdate_flb *flb)
> +{
> +       return -EOPNOTSUPP;
> +}

I think LUO could use a cleanup to return 0 in all the register
functions when Live Update is not enabled via CONFIG or parameter.

I think all of the users of these functions are going to want to
ignore -EOPNOTSUPP. memfd already does.

> +static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
> +{
> +       struct luo_flb_private *private =3D luo_flb_get_private(flb);
> +       struct luo_flb_header *fh =3D &luo_flb_global.incoming;
> +       struct liveupdate_flb_op_args args =3D {0};
> +       bool found =3D false;
> +       int err;
> +
> +       guard(mutex)(&private->incoming.lock);
> +
> +       if (private->incoming.finished)
> +               return -ENODATA;
> +
> +       if (private->incoming.retrieved)
> +               return 0;
> +
> +       if (!fh->active)
> +               return -ENODATA;
> +
> +       for (int i =3D 0; i < fh->header_ser->count; i++) {
> +               if (!strcmp(fh->ser[i].name, flb->compatible)) {
> +                       private->incoming.data =3D fh->ser[i].data;
> +                       private->incoming.count =3D fh->ser[i].count;
> +                       found =3D true;
> +                       break;
> +               }
> +       }
> +
> +       if (!found)
> +               return -ENOENT;

FLB users have no way to distinguish between "there was no data
preserved" and "there was data preserved, but it was not a supported
version".

This is especially going to be important for PCI [1] since there's a
big difference between "there were no devices preserved" and "there
were devices preserved but the incoming kernel isn't compatible". The
former means there's nothing for the PCI subsystem to do wrt Live
Update. The latter means we should probably panic the system.

[1] https://lore.kernel.org/kvm/20260129212510.967611-3-dmatlack@google.com=
/

> +/**
> + * liveupdate_unregister_flb - Remove an FLB dependency from a file hand=
ler.
> + * @fh:   The file handler that is currently depending on the FLB.
> + * @flb:  The File-Lifecycle-Bound object to remove.
> + *
> + * Removes the association between the specified file handler and the FL=
B
> + * previously established by liveupdate_register_flb().
> + *
> + * This function manages the global lifecycle of the FLB. It decrements =
the
> + * FLB's usage count. If this was the last file handler referencing this=
 FLB,
> + * the FLB is removed from the global registry and the reference to its
> + * owner module (acquired during registration) is released.
> + *
> + * Context: This function ensures the session is quiesced (no active FDs
> + *          being created) during the update. It is typically called fro=
m a
> + *          subsystem's module exit function.
> + * Return: 0 on success.
> + *         -EOPNOTSUPP if live update is disabled.
> + *         -EBUSY if the live update session is active and cannot be qui=
esced.
> + *         -ENOENT if the FLB was not found in the file handler's list.
> + */
> +int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> +                             struct liveupdate_flb *flb)

Alex Williamson and Jason Gunthrope both suggested this should return void.

  https://lore.kernel.org/kvm/20260303210733.GG972761@nvidia.com/

I suspect liveupdate_unregister_file_handler() should as well. I don't
think there's anything callers can do if unregister fails.

