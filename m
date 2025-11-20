Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F343CF887F
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 22:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D480F6B0029; Thu, 20 Nov 2025 17:07:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8B96B002A; Thu, 20 Nov 2025 17:07:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DF06B002B; Thu, 20 Nov 2025 17:07:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACCAC6B0029
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:07:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77DFA88D33
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 22:07:29 +0000 (UTC)
X-FDA: 84132372618.05.B8B574F
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7026A140014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 22:07:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NnwdbSuP;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763676447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZknmF3VpgAd9bo/Uo3njgGJcOyZCg9JJGN/hBR6DdHM=;
	b=WtrAYX5ewngkHM3epLSdqVtMeFAGI9Wvs2xZHm176E0PLYxzgUToDrg+MJRrvLB+RERQg/
	XulSple87mFehDHW1fI6c3VAPmR60XotJi35sKZPxZmChlVTff4v8ikmxj6zfNkLacSN5r
	EWVMZ2+XFwlaI0Eo2EDJGXVyXxaco90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763676447; a=rsa-sha256;
	cv=none;
	b=Wv3ghaNvz0yikd1KpPm4W/wuKDPwQttCcbCA3zw1IJ/lQnAFJew+v0aqrr8xtNG3cLcEWm
	/kXHkq+V7nUmBDeXtgz7eds/9XTmTJ95MvfQA/hZjRCCpVWNymH8Zl9uEugUgq4WHrJ/LH
	qpPOO0O+F4g+ZYMDNhmisv4ruR1p77U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NnwdbSuP;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso1394403a12.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763676446; x=1764281246; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZknmF3VpgAd9bo/Uo3njgGJcOyZCg9JJGN/hBR6DdHM=;
        b=NnwdbSuPe3TZT5PEGFa7Lu2MIxH+VNgtEuDWMAQIuNdj8ZQFlP3QEekk3py6df9bjC
         qXhwfuPpmwHd/H8pH4+wLoYgQBJ3mXBN7TP7luPWjC5s/x9c3l852bgeQrzNxBOCTf0m
         yplQe4PPqfmtMCtjX7AUoMS9rbcI87cBDM7skL4qv/sTFPOJXpuZIuRUgjU+QzmMb/+k
         OosXgSlqkQl0cjZzcnAWfmVFk4uS1PDM7UvSLqlPy8IdvTJYXsJbEhDp50975GjtYX+n
         t/v/flaRLfDPy/fuh+L3du3wZCc1fcxLlYzgDBySmtP/taNpjEMNPWdtb6LGhzY085Hx
         yZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763676446; x=1764281246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZknmF3VpgAd9bo/Uo3njgGJcOyZCg9JJGN/hBR6DdHM=;
        b=n/v284qWh35Eo4Z3gFzGxfKGko2Yil3KIQ0856953IcQqDAAdaC5fB1GcqhHmOieeq
         ihfEJE8U8OfINXTF5/sGb5UtBrJdmt9LxZB8aI/Bq4GzA4Yv/w3QjhCvfffNSzdeDQkV
         Hfx0ky2jxLi7c3vm/gEc/cCWjEBt8NXrB3SB7oK4ckpFPhpaGD6998/Oa+xuw1wQkbUy
         90kCLN294fJTIQs5AEQJA5EhLUK49KvY4oYXawatMlqqSLee4nXJQeqC8yE0vZsz5EeU
         EGN07kdldDPpwXuOy2eSF+9cro1oPjs+ksZulZtQ9tCs5BOrlRuXMljW8gwaDnQ6Bq+O
         aEeA==
X-Forwarded-Encrypted: i=1; AJvYcCVts/NjwPxcWtrEgRiiO8As6Rn6RzpAcpHAowbMF1MU2/v+S+x/uubSj1DN8DNLXLBIGEJJkotNaQ==@kvack.org
X-Gm-Message-State: AOJu0YxMbnzsFkQQ9FDFNmwjJzuDxX2ABYo2Ul63ucnxNMFB/L9LlAQl
	lGV3NqgjNl9bHMBa9v903y9MI/Kt3bwZJXoK/wQOs/CsxD/nJZm9v1JojfyCtk3ISZrVKHXDo4z
	U/+GWyiWL5NqIF50wRqP45L0XCxjkeV45wUY/vxThM2J6NxrI2fO34s5Hfw==
X-Gm-Gg: ASbGncsFQxubwFOSXPgRsRXGn8fi55gcHvdjfhYvZvA4i2etf9hsD1lV0xc2cVvtr7y
	BYAsF+wvzAbmzJjZB4foSlUKFkxwvBRnYa23bouQeQ5pgaiZfu2T/nWNvCOfVqv5xhiCK4Ej1bW
	kz8X3R/34038joc20iCZ6Dd65Iv/VJGJqVu0IP7g+LIrCavsiCqlc5b80noJN9+iTvMFmPg8b1u
	itpjikQceXoMoEGmz8ldf7QWddRGB+eJhrHWypvbwuiohR1WcrEh0CUwfeGxcGMQAbb
X-Google-Smtp-Source: AGHT+IGGH+g0kYgYnofK8nL8B1VmA3Kloy65i8uSy0ml2n0UZYKAny9eZQdSBm/1tUGN38T2SrmNnESf+SbwD7gKsW0=
X-Received: by 2002:a05:6402:1ecb:b0:640:9997:a229 with SMTP id
 4fb4d7f45d1cf-645550783cfmr206597a12.3.1763676445755; Thu, 20 Nov 2025
 14:07:25 -0800 (PST)
MIME-Version: 1.0
References: <202511210513.ywQeN1k6-lkp@intel.com>
In-Reply-To: <202511210513.ywQeN1k6-lkp@intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 20 Nov 2025 17:06:48 -0500
X-Gm-Features: AWmQ_blimq4IQ7xme_3ojz0bDM0Um-4i6aYcx4O7UAhNInw7IGfPjHprHt__x7s
Message-ID: <CA+CK2bDOxj14O2kuvn+BNnXJ+R7rb0CK+ZS_hoiUBX5YhDfaHw@mail.gmail.com>
Subject: Re: [linux-next:master 9912/10599] kernel/liveupdate/luo_session.c:392:86:
 sparse: sparse: Using plain integer as NULL pointer
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4td976w4hufh58c31ys8bimtqrcs6sbw
X-Rspam-User: 
X-Rspamd-Queue-Id: 7026A140014
X-Rspamd-Server: rspam01
X-HE-Tag: 1763676447-273593
X-HE-Meta: U2FsdGVkX19um8Xup0p8bB/3mDoMSegLp46mMRNiwkKMXCYZ3mNgfAoiLrdF614ZU833uLLXuY5/BITlTMmIHrikyQQuAeN7o6nnCYFse9ONyB+l3Ikm8ib4Al9zu5EMW6jz+xbgIszwZLu61h+i+P28jyIaXnFZKwcVMg03FkMgMCYJXxTcxkMTGnXs322EgqIcArhZIlaGJyrjHVh+Wu9mL6g1db+3HXFvywmpSHTaeG3Jy3qB5Oq0MhykTLZPZWiOvAdEiyzw0nuQJtlbO/IFAVOHFYDRXvU/C+bqrJR9AHVP4hQPouAhM4sr1B9eY6h195LoGAZUTDFPoS0QlvUDubaFUj6Aw33iKC42ymwgVNOv0kl/RZtggwPxSS3Kei1AUDkThZuoOLiN/RxnY47d4pQ44kpputSLW4y9AqjGBSkwWA8CuskghlJmbVC/T3XRkNAh/KcUnRqgbCy6OP43B1xAJxeaPudmtek3crcCojPIo8SauX2wWoF5gbwd2Z4bOxbXdH+UZOwC1RA46pYFhu43HvpaX1kQ9dwMZT4G2p0AJ5szMjVOsNglBMfhNDqEDteYqY/Rh3OATF7R5t2kXMjDY0YlCamBx+Nfy5Papt0tUL+8hgW2YxUWk1YRPDBvGfwTTl6NyVexOfrmVPZcwyPBaF9DUXoJ55/23/Zm6C0nZZTJjKL4R5Dv6nnhCzmi/kubymgwj8atPV/Do4BgF7SGgr+4dYuTKFKQzjS6ruODD25SWsLpr9Ztf35y+1FMGcaIfkIQCSZUy31AiGeWZCFVHXyXavZJa7JGdMOQ58kwg7O+ppVziF9DHalucPDLWmLqq1MYAgF50AeV5IQKeEhNaQ6Q3gMwbGSEfiEu3au/bz7SfIIcf9Y+PAxI9Xdgmzai9ZyrQgIGftImuA7g6RsM7vtc3JA/pbVkCo6qrB5MV5b12LZ6juNDyXaE2jslyo+zwBlK2n4bv8i
 mBdzGENy
 QXhH1VPU14Nv+1A+RUcXksWNG10j952uW8NaKaBTSr1d2hwiAYcVUPqMQo7kMEop6rGfOroEJi0RWzQKg22rrVQ3wuXjbbujxXpGRbbjcj4fc5AGgGBIOBTJIuF4XonSBTUvgRJJmtuj+Uam7mI4wmXQ6wINCuS6Q6wrrY4llgCZPgMQPzU7NoRUxUPTuVr4OjWK1O2uF7qKWi8tjv9XdoO6pIl08par+5yc82SwY0WTg5Xah0HAO9FdeaINQzfvWLLdMP8BDF+1kukeVRuHRP292AP9MvqyIYH60a6aU2tuMWVj0QdaiKTumx2jNzqoopM7QLwKOA1xlOoK1Jcqc1SopZAahjFtRaW1WMmNStuC95S2Crk4riEHhUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 4:36=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master
> head:   88cbd8ac379cf5ce68b7efcfd4d1484a6871ee0b
> commit: f485f57c35af5b8c2a243dfc39ee171673484915 [9912/10599] liveupdate:=
 luo_session: add sessions support
> config: x86_64-randconfig-121-20251120 (https://download.01.org/0day-ci/a=
rchive/20251121/202511210513.ywQeN1k6-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0=
227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251121/202511210513.ywQeN1k6-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511210513.ywQeN1k6-lkp=
@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
> >> kernel/liveupdate/luo_session.c:392:86: sparse: sparse: Using plain in=
teger as NULL pointer
>
> vim +392 kernel/liveupdate/luo_session.c
>
>    357
>    358  int luo_session_deserialize(void)
>    359  {
>    360          struct luo_session_header *sh =3D &luo_session_global.inc=
oming;
>    361          int err;
>    362
>    363          if (luo_session_is_deserialized())
>    364                  return 0;
>    365
>    366          luo_session_global.deserialized =3D true;
>    367          if (!sh->active) {
>    368                  INIT_LIST_HEAD(&sh->list);
>    369                  init_rwsem(&sh->rwsem);
>    370                  return 0;
>    371          }
>    372
>    373          for (int i =3D 0; i < sh->header_ser->count; i++) {
>    374                  struct luo_session *session;
>    375
>    376                  session =3D luo_session_alloc(sh->ser[i].name);
>    377                  if (IS_ERR(session)) {
>    378                          pr_warn("Failed to allocate session [%s] =
during deserialization %pe\n",
>    379                                  sh->ser[i].name, session);
>    380                          return PTR_ERR(session);
>    381                  }
>    382
>    383                  err =3D luo_session_insert(sh, session);
>    384                  if (err) {
>    385                          luo_session_free(session);
>    386                          pr_warn("Failed to insert session [%s] %p=
e\n",
>    387                                  session->name, ERR_PTR(err));
>    388                          return err;
>    389                  }
>    390
>    391                  session->count =3D sh->ser[i].count;
>  > 392                  session->files =3D sh->ser[i].files ? phys_to_vir=
t(sh->ser[i].files) : 0;

Should be: session->files =3D sh->ser[i].files ?
phys_to_virt(sh->ser[i].files) : NULL;

Will fix it in the next version.

Pasha

