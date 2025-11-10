Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2CB5CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054928E0027; Mon, 10 Nov 2025 10:32:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9838E000B; Mon, 10 Nov 2025 10:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1838E0027; Mon, 10 Nov 2025 10:32:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0CEC8E000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:32:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6170AC0155
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:32:03 +0000 (UTC)
X-FDA: 84095088126.03.88B4366
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 751751C0007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:32:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gv85yDD5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762788721; a=rsa-sha256;
	cv=none;
	b=uXb+SWwOe23gJ8+ylkHyLW36D7dU1NVhTB0jwlNTw3jRQ+ksDKZZfmJrlHMKzUsF5aMe0+
	53lhiPYZ75ijb4N31CtcF+oQFtQx/7KBaHSYL94bJJjGX/s7s0V9EOWdsL9alIk2YQp1fT
	1oIBu55P7w+klqOBQsL9JVzyiPKuArA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gv85yDD5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762788721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvyB1b8oEOYU6YUvXYl67lC2NdpCRz0gUoF3IKmaXbs=;
	b=pUu8XvIIlK6cKoioZxMZg+1HA6AIFTVHb1JxpgM4CqidacSbKezjmghjJPM3Par9XGy+8U
	bw7Zd/xpMleiqhHDdBMelEsoUNhTXiGn0bk/mIJSaKpM1lVCbaomu0iRc8UjpAfpTMq7bT
	xdvCoxBdhOOCXMOCrvGyHjteayFwCkw=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64166a57f3bso2498349a12.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762788720; x=1763393520; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvyB1b8oEOYU6YUvXYl67lC2NdpCRz0gUoF3IKmaXbs=;
        b=Gv85yDD5ymMfunOf3QoyW24uvpYd9Z9cRNGdUzX3geQI+KS8Q2veDki0L1b1MNr+l4
         2/VwQtZMT+p8xdQwfcAO0TPuqzIish8odwhLg3iKhUl7OQRDorjagtZ+S6MciHS6d9zA
         40QCMIzX9ah8jIAn8jAv4cKAMOO3GOiv7ZVMLNlck0n7dKp72BssnLPZv3bXljTeZ26j
         PCiW+2JXFLTr4hJevsnu7u5F1Vm1kktnuXN5O9mjRvAXaj8zgGEGzWH9JEyMwnoP4WTL
         KAWRT8dNpVZDzRvWYsqEG5423bJ4LkZgmGkW9jJDtmUpCjsjHICWjrwgvF0Bt0oRXo8U
         ipmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762788720; x=1763393520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yvyB1b8oEOYU6YUvXYl67lC2NdpCRz0gUoF3IKmaXbs=;
        b=d6zzsQxZkjjWfNKrVM5T6q27jEZzSdAp1z7jFQqkf6jDjapoa7F2QIkONtHxECpDsc
         yZEJUcG0MnMAYfY/tlUksKLa/Qn1ZDjDJGuV55CcSiRPTpJ2sb0e6xxheEuIsKHUg0Fu
         FxWUIeLA5Q0YeeB3ANHg5Oo/1YYqQuS3vBZYb6Ah0JZTwozHBkM9Dh3ss2LUY3Y5MhYi
         8BEgngXiEATRu/VWbGO5ZChRBuXTWIv5Qszi3mFGBxtXgdqRVa4ZmEXSTFdvV4YvxZkf
         6Abkjf++1yMDbB58CnxiHUFkpuf32zXwnjGPXcShx8Cqk6KinsneXRIEU2HDjfd2FvuH
         7TRA==
X-Forwarded-Encrypted: i=1; AJvYcCXfxMYixM2RJBE7BFKl7BQ9NenN/ujT+K7Ffn3V81J1+YMYQQdfLWHJCLdfxXVC1itJYtIBmg1wsA==@kvack.org
X-Gm-Message-State: AOJu0YyCL1270X5gICXx/dI9xhZ1N8muDwhMOy3dd9V+l6NVXTc9ISiF
	s6y9bVWqi9RSx74WDJAP6v30iZeJsq1eBVNHfZFkCivkpn5MSRIXWqyYQc/WAmmj93+jwbHlwHu
	VSlSZ1EdX1ylKzBnPwg+hm11odQOsca80Z7HHHf3bTg==
X-Gm-Gg: ASbGncvqzrp21t9pPzce9h4e7S48hvSQVQ+2ctuQZlct4QLp9BOeBDqjzYOJz6XdOdO
	XHA4CJaUuOTqXGZ2BKWOvoO0AjP1VFpqfTysU+RHdosUlFPieSZwHB/QBweCyRMTO+CgwMErc+v
	7B5E/jfgLLm2MnOUHMbuQN1Ob5IysH2WWmQRzwr+PZSxTmeHyUfcnGBM2jYiWyTrDqwlRF38K4b
	tiwstGl6XYCZekW9t+H4+wMNeeHVCACuHySVP1I5zI3YvCZgFBqAzXXQQ==
X-Google-Smtp-Source: AGHT+IEWEmCpMEiE/sigVWI2wEcl1lVXHLXnEbH4KM274tOZXUBy76PsgNh+OSo+pFw8/8SS+R3xNlWxCqdsS2OcqhQ=
X-Received: by 2002:a05:6402:51cd:b0:63c:4d42:992b with SMTP id
 4fb4d7f45d1cf-6415dc1304emr7523926a12.13.1762788719813; Mon, 10 Nov 2025
 07:31:59 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-6-pasha.tatashin@soleen.com> <aRHe3syRvOrCYC9u@kernel.org>
In-Reply-To: <aRHe3syRvOrCYC9u@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 10 Nov 2025 10:31:23 -0500
X-Gm-Features: AWmQ_bnDFpVyCmvtk4rzMsE7lIBuj-Os5t1X5u5kjgkokRKpm2UiGZaOTcTCYY0
Message-ID: <CA+CK2bA=cQkibx4dSxJQTVxVxqkAsZPfFoPJip6rx8DqX62aEA@mail.gmail.com>
Subject: Re: [PATCH v5 05/22] liveupdate: kho: when live update add KHO image
 during kexec load
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 751751C0007
X-Stat-Signature: sumfxzp5j1sj9rzkbu3j4e66dn3ycrj6
X-HE-Tag: 1762788721-774421
X-HE-Meta: U2FsdGVkX19+6VJOME2pmjkIqPYeFtP9L8rJKF7aN0iDpGbCy7rWPXb0QuWgoG6Tjwo9jy2XK5rorYxzLL/zu+4b0rzCI+P6KKsmPFc/NXvS6VCtbJvqWaPWxNId3PakLMySNPpS66dKQfV929kIlws9SnEtQ6Pk126+9SZTx7H5zV1/Es72HqVD0puhgweWiR83pykUiUsGeOxqG52fhoHUhtJOlLqCWP6MkufOMpccKYbEk34afwyKw0h6K+U2+lk0uiYZ6OaO6xTRb46sIZpdYBs/ZXAKrOgNdk+vq6G5YRC2/TT0tPPYSy0ObHBEc6Wbyg7ejCBsOfgpBQiMyiHywTDT1FCCsQ9sfjRwc64muZFvxYrQ27XCQsM7K693BhNFldLdMxqB5kGgpItBganZOb4thilhXxJAvoD7J8UWaqdgcxyrzirXTlv4q6//jHw6IUFmFPiPMDe7Qlit2ph+KWJjarQ7f1plbxrKvrxb43SWYs3InKpjdp9PQaMr69Qjd+pfTeomX/vROyUaSc6JrenEzGM/wJe9DzddB/Qm4w0d5hmq70hL7spwyZZnrYxy8Q8XflabzjQm1v2fCFwVdtt93DgTEGMZJ0gaBJ3TwYSYI4J+sFlpOwseQ7t80/wOOOc7Ocf6JodLqhEs7v0xyD8QOkSbbfgZ43DMW+bKZZlZQI9NHr/DAZ5CYe5amRzrtsJxp0K3nu6+jyIRuqA0ymJ5vNbBdxDJ2LOLmy2sqp6MsOhw9l8gcgpcm7Yth9Xmc1AeTmDighQy/1gZd2w0K8U+TqYh61WJnq/qLYZFkp8cnqQ5B4wSSPRuRHkEGAynPa+d0zGD6UTTbXBRLp29sukiGipj4pRImHuFwz/2G8NQ3b8r9kPNwLfusgwrUP9bR0/7RbpK19py7oJcBtTbXvR+3kA2cCyzt5cNwYSWBfvNwv65VUVkgcaMGqe0ws2n6Z2WdmkPj2Y9Yq5
 iTkza/Pg
 79gKwsz1rr2ZHPkbhX2lEeeDO5xnyvkLHbAmhuGqPmYpGkXEK3U8m0WeL1mOqa0XwE5tX+cdH2PbFpbMLhD50gC6YorYm2+0TeVVAuVdTiY6pMk+T6IEgzpdOm9ddDxhC4NQYSAUiQsXJmTeHL0EcS1b0Bc9xxF3WDp8jsgurEFkgaB/ifhGHE96gd+B4W/qQD+nmTdHysSxi6IMnRljhyjm6cDNsoydG6kjedIV9GLqz2OR4wdgDX951MLKqJRFh+5XLX/6v2+JRiOCd0qHxwQj9Wju9wgksNNo/EgV6OVoCRq+oJ01BmBXONcFN4q3i42W5wnBjPYu/N+UJxznInUsV2F/WaqAQ6z89bsTvHYZeaIvrGGBpi+heU8A6YJbG3FS3Ty+AG2qCBJj3prboTnfcPeOXjETwu7lblxPCV4JGdLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 7:47=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Nov 07, 2025 at 04:03:03PM -0500, Pasha Tatashin wrote:
> > In case KHO is driven from within kernel via live update, finalize will
> > always happen during reboot, so add the KHO image unconditionally.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 9f0913e101be..b54ca665e005 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/kexec_handover.h>
> >  #include <linux/libfdt.h>
> >  #include <linux/list.h>
> > +#include <linux/liveupdate.h>
> >  #include <linux/memblock.h>
> >  #include <linux/page-isolation.h>
> >  #include <linux/vmalloc.h>
> > @@ -1489,7 +1490,7 @@ int kho_fill_kimage(struct kimage *image)
> >       int err =3D 0;
> >       struct kexec_buf scratch;
> >
> > -     if (!kho_out.finalized)
> > +     if (!kho_out.finalized && !liveupdate_enabled())
> >               return 0;
>
> This feels backwards, I don't think KHO should call liveupdate methods.

It is backward, but it is a requirement until KHO becomes stateless.
LUO does not have dependencies on userspace state of when kexec is
loaded. In fact the next kernel must be loaded before the brownout as
it is an expensive operation. The sequence of events should:

1. Load the next kernel in memory
2. Preserve resources via LUO
3. Do Kexec reboot

Pasha

