Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43342D0E6EC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E526B008A; Tue, 25 Nov 2025 09:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6226B008C; Tue, 25 Nov 2025 09:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9236A6B0092; Tue, 25 Nov 2025 09:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 855076B008A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:00:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35D851A015B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:00:07 +0000 (UTC)
X-FDA: 84149288454.12.01B8502
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3C52010000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:00:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KdE1fomA;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764079205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPADEzDInP+4EgYdCnNY22SOys+qqvVd9B9lyZm9LUs=;
	b=fqETG1FY7egQYyFx8EhGPDujvuwk4xQ1epYlOuBUD5USDTVd1SRa5E7sHr8KTIP5LFFzqt
	5RAa4xKEc4pa2kh1eiRCYuc7YFRdykLlWPax53DH1Y56AmDEo6FQYssGAKemnJzcFUFTHn
	lHMyteFzdOaQPxz3HNmW3SPepW5Ne24=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764079205; a=rsa-sha256;
	cv=none;
	b=0wfUlK3fo8ln6N4rGRx0l7rMFsBH5I/0iWvnU8sL1GeQw29c5GKBXse3qM9foo0SaB4IWr
	1Sutizhsg09fCgOrTtmR9QcN1ZueMpjEe6hN18gCSrmEV+Mp+/gnE4mAENoUbtN9JhKcWx
	/uuVm0KnAiiy3cZnOiG+zrT6dWNXpqY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KdE1fomA;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so7844403a12.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764079203; x=1764684003; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPADEzDInP+4EgYdCnNY22SOys+qqvVd9B9lyZm9LUs=;
        b=KdE1fomAIcqTZy3LDWIsnycitN24JwuJeLqbQp1XELEp8dcVsD57dHp7ZzbNHtSdDk
         98k5R9HVnlJbwBWmUOiaPMpFPs5+AeT2GrTNKsSPfSn9n1bHl4YQtK2Lbd+tlTUalWPr
         aF8Lme6TknyRQFD3kFU3hAHPC707JRiAX6lHjdjjw4bVSaDtaAhD0tpJxf/qvvuSvPaI
         m7wfiKN9t2Cd0FK3fFj8Rccf74XuzyDYiK4D0KqsKUgs+KKw7RJa0ylP5WcmaYgipX3j
         Ozp9UhAx/dsBmw56wE7su9I1Ye62HCI1MjqJb5XL4S6fRsrHhx8Nc+qqykX5rYzpSBVa
         76Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764079203; x=1764684003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gPADEzDInP+4EgYdCnNY22SOys+qqvVd9B9lyZm9LUs=;
        b=BaajGnTxlFdlatyWCS+lLtRHMM3wjClxWCayWPZnhIfvsbxWz/MODcgcKogNhBl1cC
         UkgfaZA4+1Fz2cOlGTlKQp6y7O1e+CQdrKrTCN+9oUnv3zC/Gw01KAWW2OrwNHugpMXi
         8RZ/QMV4SdXPTYvs2lAzTC59aOz2/FOBmlGOa+hfUt0OTCixzLxlFLoTSQoZYEtw6H6I
         sqpFwTXsJ/JFQOkneGrpy+wTltnPGNrejthSXk2EoiZ8lNFYuRvkLpmshrhWdYYzQWqv
         d/mZCXS9FNhEH4o8N6XdBJk6gwrt+EZc5dQ4gTDeyq74X+Y8SDtW1Y8+cmrE85GCyr4a
         4m5Q==
X-Forwarded-Encrypted: i=1; AJvYcCW3SbTQAhfd1P4/8JoZUdjd0ncQ+YlwTmzelJddNykTHLWwn7rRAe4snsWOigZ7ZFzsZNcxD6ZTdw==@kvack.org
X-Gm-Message-State: AOJu0YzqJHxH4xyG99zzkDzQ5xxk5DqyzUIcnHd2tgnWBv0E/9Ahe1qN
	HzlackcIfaeyAEGAVC+rqD5CqVzjopV2reBgKdiCgPLOASX74uXRfDe9PjciyHfhoYpHMEpr+IG
	7Jy+dJCSy/bSthCMi1xgnzY5TR+nmjHX4qDVJQI1NCQ==
X-Gm-Gg: ASbGncsywMog1xxEXp53x8bqO71T0PDZAlxrFb2fI3i9YcfNMG1FhQJxlGcA1t7BvHt
	gFgIaoQ8uGoMMH83PZYpMGFMQ7Cfljg7+lqAAvcHkd/2c/d5/KyVQpxY8lWxWntpsgxdySn5GL4
	ZT+J1IjfU69APlLwFfUlScS2eGiaE0Wu14aiPTDqtdjxTMOUNvNKHlo9y+elbVNhqOOLAwPl4mF
	AXwoxRjv6ACqPZ5KZnzhHy44iRDlAVIuRDjFtjqJG0LzX13vVSa7yOjIV2lQDxEJN1I
X-Google-Smtp-Source: AGHT+IGQvP3sp8P5QdaHoU5hl5stQ/R78sD1t68LmqHbhIYjocvMZQNdcinW6IeCcPNYJc/WOurXaWpr8WBXOL4qx2M=
X-Received: by 2002:a05:6402:35d5:b0:643:18c2:123b with SMTP id
 4fb4d7f45d1cf-645544420fcmr15551385a12.3.1764079203274; Tue, 25 Nov 2025
 06:00:03 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-3-pasha.tatashin@soleen.com> <aSLvo0uXLOaE2JW6@kernel.org>
 <CA+CK2bCj2OAQjM-0rD+DP0t4v71j70A=HHdQ212ASxX=xoREXw@mail.gmail.com>
 <aSMXUKMhroThYrlU@kernel.org> <CA+CK2bABbDYfu8r4xG3n30HY4cKFe74_RJP5nYJeOtAOOj+OUQ@mail.gmail.com>
 <aSWqQWbeijvruDqf@kernel.org>
In-Reply-To: <aSWqQWbeijvruDqf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 08:59:26 -0500
X-Gm-Features: AWmQ_bkHTYlHlGxKmBiHNdm6t2thzT9HecweCk3JjWHiloeJgWPSmfHodz7nV6A
Message-ID: <CA+CK2bC2yptSzT+FJaef_K3bvOeDmmOzZVf3VakaKn6r7qk+dQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C52010000C
X-Stat-Signature: xgyg99d937xboyrj5sqdwf4ubapn4qr1
X-Rspam-User: 
X-HE-Tag: 1764079204-187377
X-HE-Meta: U2FsdGVkX1/phebmjj9Ke+VjywEWDshXGAeTvwr9yTry9gdW72SqCVoEndwitLq6wuq2FCl7qx0B5vKuoTH6Bx/cd+HC453cc4oTAE8MW7gE85qDWtfuJ8L5bn9AWIkjyZoRLGna4gXFzL1nGah1REN4/jzRqCQ8b4ESokl+hl6sRrk0of7ipF2jiOQuTgGpiim5HCD1fCuiqopmgbD+0+Kr1cZamIVMxKm1cKbpr9Gzv8XtjLMobh/zhs+2byg4sb4zxj9Tai0fyINHu8QdNDy9OhpLKoFtFlZy+O7TmNlPwkiOJ0ukLbX2ZKWFzpfbwvM/vr5uxNhFZw3pnvjYcv5C0xzr99tI1oJHMd0AnqKlHUXHR/hSUpQnjvbiBOh47I87zklMqxKQQ7cwQ6aKXfPrRlGGa6xgUjKW70odY8Z+MM4EuvvDSfs2SVGpERqWyE+M2dp8vG1LWUvbGDviCHXoSIWXdd3j9qMFAFp3z9CKBreRbau2H3wBLQrNeY3UEUlqI2h4V6mWFJEJUJLcOE2A5oQLmBoSV/KX73KU8Sp6kCfzXG/r5UnTW+WUkU3nDMJhub2lBFdyIxhPLYjaN9NrbTzs6sdbu01zZZe77qyvYzZNn5nfiq3sM+HbRfP9j/jWBSgyUcxY4zJXWV+ZjU9lJoa+lEDeY6kf9E1Yzj/ftYi+Pm6U4g1Hw91kYHTB6YzEy9uWqVfLP66cqJOhSfi7ZBsfx3Hh0V5eCthpmtbxSArmeN1JFLQh6Jolef2+95BrDfL5hvnB1a8aXrKtlMgCeNkBNJNhvPUVdumqEEhHrvGfsMVdxbDT2qx/I7Mec/z7rzIOnxCnEoqjSwy2SXwRq0va2NHn5QaJKJrh8b5Ismgm/DaktGVIhe9qtLCt4kKZW8FgjEQOu9bjsbhZ5pAv+1VJXxeeujeOCLxNkg6fwpNP2wZw0rHBoFEi0ioF82E8xIbSHdCJRLjdcqJ
 oQliFD1I
 bl4k3/GJxxBcNEYdr/FDuf+gLwSy/adYFPL5iTXKGbg7X923azlv7inmGtSmPb/tGxItalVckutSUiYXLw00ixnpBtOhtQmOXMFaz2Pd3/Uv5Mi85fMhaFA24UjfwTowvjAAKSCVMNLUOyCyCkZ2gylyzIeRTw46hTG1AFJvQoSE7ZdDj/RS95HsnfYIHqFIzT/3SXqgkBvJJXehUIKLceErQEkY0ok6f189NDLUCwl5pnz7kuVJ1sK4Wcg5uy5lMtWtrEXQ/VoPmIZQGEXP79KGJlUWEKRja2U1fdntUkNE1DUFnFRmed6DntGA285YtXE26yQcKoBv9UcQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 8:08=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sun, Nov 23, 2025 at 01:23:51PM -0500, Pasha Tatashin wrote:
> > On Sun, Nov 23, 2025 at 9:17=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > > > > > +static int __init liveupdate_early_init(void)
> > > > > > +{
> > > > > > +     int err;
> > > > > > +
> > > > > > +     err =3D luo_early_startup();
> > > > > > +     if (err) {
> > > > > > +             luo_global.enabled =3D false;
> > > > > > +             luo_restore_fail("The incoming tree failed to ini=
tialize properly [%pe], disabling live update\n",
> > > > > > +                              ERR_PTR(err));
> > > > >
> > > > > What's wrong with a plain panic()?
> > > >
> > > > Jason suggested using the luo_restore_fail() function instead of
> > > > inserting panic() right in code somewhere in LUOv3 or earlier. It
> > > > helps avoid sprinkling panics in different places, and also in case=
 if
> > > > we add the maintenance mode that we have discussed in LUOv6, we cou=
ld
> > > > update this function as a place where that mode would be switched o=
n.
> > >
> > > I'd agree if we were to have a bunch of panic()s sprinkled in the cod=
e.
> > > With a single one it's easier to parse panic() than lookup what
> > > luo_restore_fail() means.
> >
> > The issue is that removing luo_restore_fail() removes the only
> > dependency on luo_internal.h in this patch. This would require me to
> > move the introduction of that header file to a later patch in the
> > series, which is difficult to handle via a simple fix-up.
> >
> > Additionally, I still believe the abstraction is cleaner for future
> > extensibility (like the maintenance mode), even if it currently wraps
> > a single panic (which is actually a good thing, I have cleaned-up
> > things substantially to have  a single point  of panic since v2).
> > Therefore, it is my preference to keep it as is, unless a full series
> > is needed to be re-sent.
>
> Well, let's keep it. If we won't see new users or extensions to
> luo_restore_fail() we can kill it later.

SGTM.

>
> > Pasha
>
> --
> Sincerely yours,
> Mike.

