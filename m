Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44882CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 04:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514EE8E001C; Mon, 17 Nov 2025 23:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5A98E0002; Mon, 17 Nov 2025 23:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DFA8E001C; Mon, 17 Nov 2025 23:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 232398E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:29:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B270FC033D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:29:09 +0000 (UTC)
X-FDA: 84122448018.25.0BACB2E
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id B4D231C0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:29:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=beDUbqsa;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763440147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVK4IdpOEfypRyCSONdTJzqLYJ2T4mhuvQFJg1heiHk=;
	b=pfHgR39akMlmu1YrJlwl6fz9dFYCOSJcAGMMlDmAcFGoKEenE+pgnrtz9j0xYDXGg8KzfT
	IaVYFGncPmzCP+0f3f2KJhC4qqDfZKDeFLSCwl1duYKs/7aPEmCLZ2SZRQef9g5g/YP5Mz
	7m00BWm262psWeKwXWV+Q14nK3c53EM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=beDUbqsa;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763440147; a=rsa-sha256;
	cv=none;
	b=OpL1R6di32lRtvSJngXYEOao/KSM3qpNnFVp2pFrVP0iNmop3OVs4ZXTm43+BjxHQBjAfI
	R2++84taSI4/GePaDb6KEKmK7OwzBJzEDQRO83z0lqBcsuv6gEdz8uQqU03rMx1sRONk7h
	RIGM1MW1dqzdKG+6DiSWvGmQiduEXkA=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so7849285a12.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763440146; x=1764044946; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVK4IdpOEfypRyCSONdTJzqLYJ2T4mhuvQFJg1heiHk=;
        b=beDUbqsa4KDEzPrhVUl3YgwLINbW01ypHbxeASVmhl1sILq4XXnKSwv5xQCU7BQEW/
         dQr3I7Fcml3yzdyvaCwciCHItYrSnv2Ki+kckVN0r9JMaIxT0Np59lyfn9zJwqdESE6k
         T16Vwx15paDPkh7efa7wC5GAoFsvHvsfbUvJKwXuTRtDTg+w/7IbQXIePuE6BkVrq/47
         5F9wieGNp/Nao1rgZajcyMWnmpbXf5oiyR8eKDK38fyt3lk7PPIj0WWQIUjkDljWoeBc
         n2FHDkqdI64K9l4plTnHMjetybYKCwOuKomFWMx/xkIqnUvZ7gXO99QuXuXNjxhhbjWk
         Pawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763440146; x=1764044946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nVK4IdpOEfypRyCSONdTJzqLYJ2T4mhuvQFJg1heiHk=;
        b=w0VaP8uSXur+eBQe1BMm7QGSzJaBGGLzc2kmuly0ZQSyqFf/OaipPOYe8SDKQCOyC5
         KGzrY4PmoXTo3vOg9z5vUULTMJRVQYCyKwYNSoVZWVHUr3//Gzy8cTTG3wbevWqYC+Ft
         1jqiawXgzTzmgGwGre5+S0wFgP3tqWAFWa/6oCvJuE53swoEFSdNUrgAjUUs1CUSermq
         S/ddr+rQWPrIM5JQ/VJVBXTwBqr63LWWaZFvN0rTgxG5V9TZmoNbBY3oMN7R7eLRldZx
         EuP9fE9bPc+0ulsraoLLg/p741Ypas99CicXqxWaWoyog27hpt//Y4FQmDB9v0IqLWuz
         UYPg==
X-Forwarded-Encrypted: i=1; AJvYcCV9NHc3kDqkTpBN5b9lVD/GYIAv+DP0BAB9ZQ8AlfG22mO1J3FBSEryAW1L/oI50IQFt7wMIs8rIA==@kvack.org
X-Gm-Message-State: AOJu0YwzWuOFqnzM8rSdrbT3Nc/XY2T3vrAgWyE+iwgWptvH+jvUut1V
	qJ7TBAPdV5Rdn92eYM9iK29dh1hsCHJgaxpYygcGqv1tZKIpWb/OgG0syWKwrxUrVEkl9AwZttE
	JQvyjJhtY0MTVUuzmoBejn1bmj/QtqVSjK6yJubRLxA==
X-Gm-Gg: ASbGncthPBkgbvJobq9S70cKMA1qiWa5jcmkj9kMK5wrYk5WTrCK2+H2dIeBxHvqq3n
	pRFQU2ecZFLESRchk0SqvcJuINM4WC9w4odf7a7cM1UOZvpUkDuz/JM2xU74cm9gN7ZyDp9DOxA
	4PzRnaq4B7jAfIU8XeeEhE2aTGY313/hGKku7SuBn123HZlB3qc6AcjXXSo0jNonuITaQZGTZ9Q
	WEd8TZBxGgXsKTFd1DkKCuzVaUF8ztcUptyi5ZeHAo8c7aueNe1E/IDAXLE3UmsqoBm14PNoxFP
	6b0=
X-Google-Smtp-Source: AGHT+IF6ySItcOMgaBoEyxRCTrysqlaU4//aieWHoBgnptA91clHqaU2ww5S0PiyBiCx/e+NYj7wY0E/YvrpgMWF5v4=
X-Received: by 2002:a05:6402:35d6:b0:640:9993:3cb8 with SMTP id
 4fb4d7f45d1cf-64350e039ffmr13236688a12.5.1763440146078; Mon, 17 Nov 2025
 20:29:06 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-5-pasha.tatashin@soleen.com> <aRoEduya5EO8Xc1b@kernel.org>
 <CA+CK2bC_z_6hgYu_qB7cBK2LrBSs8grjw7HCC+QrtUSrFuN5ZQ@mail.gmail.com> <aRuPcjyNBZqlZuEm@kernel.org>
In-Reply-To: <aRuPcjyNBZqlZuEm@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 23:28:28 -0500
X-Gm-Features: AWmQ_bnXjUULcNqlTihBFO8sKCACG8mKavb9e7Sf8PiMX_A8JxJdQG4B0RQX_fk
Message-ID: <CA+CK2bC1HviYczgs8=sh8Rt6rxgPgWuda4DGYpg+oLfHn5b2ow@mail.gmail.com>
Subject: Re: [PATCH v6 04/20] liveupdate: luo_session: add sessions support
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
X-Rspamd-Queue-Id: B4D231C0005
X-Stat-Signature: u7hx4r3uk36ir6nypydziucd5idbqiub
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763440147-735524
X-HE-Meta: U2FsdGVkX1/AlQtZsu7n81WYwA1MOzDgmFEULZ+fDnHK5ssMpHYb63SWgA+GIt/DuIANym4iF1+A3NnE+tvFrWPSiSKPp5MHNUVOY6VhZmuy2E+Rb0kOImGk+QtzrnDBpDEOKlQQdhnfEturb/5bj7tlQyiYG3A2EcJ+aSudTuunYyT5PtxqEQUbXIJOQNnbSQEIqMZTyi0YCmpVb0ZoDv1yzNpnDF1fzRleATY2PTZgE8Fbj7UphBN3ZpDEGTQ2N313NWU3p6GlqMVGdzZohBsU0FOe4+zwov7Xs8kcUdPR/7RNZe8h6IUOGg/hpwyt+zIn4zMaPNaEz6n+yD835B7zam9Y/n8syn5lz/rkyHB5coWCGWiCPvv6sqy3rgdM0yqc9LDI2Y92I+uLmfDJCzEiA5fP9zdfrjxq7gTgyf64CZCMtDqaxHrM+vjHptCmmVzwMRp0glHoCzsKe+DETQR+RrMC17JtAVhSO+V+cO6o7F6z7cxT5UpR72D+lIofr9bI1zOdOqN3dQTMkYRAmVWRbFwjRtDGl7XQGQjMs5jMxIiqbrTrsO1o7sBMU3CaK5vwu/OlGKI+bQ3kswVFk8pxi1GkPN+vD5ig4ICX6rQb+RWC8tkQ9DuBJIHJ38/KgQiSMaz7h4Drg0fBaWZVM6FyFnRlO+8gYruAkCSapsN3vekbyfEkHwdapLOPfn1jdkbes41Nh3gi+iHyxegAHYx0UdV7qyt8x2JK2Nq2PtNhHik5PPwPtMEhflYseIYKGz7WUsdnoR0PWaa2cNxDjmVhMZxe/k0iSETFbT5EVLPM5btUwT7o6f7xEkeE2eXL2MQqHwhy+aBzqMfGW/qbubZYUKMWaf70pDhhhx+kTCUu8Vnx8Bsc+wm5flqhxl2M/ObOoj7pHduM53jbqjzZt7F3zhtpZR1eecdxOQVcAvzOQuXkDDlqX6yC+HuaXWI9iOtXbhr9L39rfpYqMSy
 08Y5Xz+L
 OM6q/Fzt5ttHmONfwz6r6XIE31N5vMPSkYVpB7yQdZOIPT3im7k4tNr7wXZTXCUL9ekHS1ow9Mtx9P6clnkGrE4IyAMYT8cnY+CyRgu6SHTwjVz3UJ/UWPbHvtKj9QT3D3rhhYurVYeCPZ3QD78k88zmlZFlJCFVIFwlBy4hPSDOpxFOBVeInl5RoeWtLrJCv0kXofKX29cyli7tFPGQn82yVJnj2Y2YtihWoUy5+Yo0TzfxvDJALYTSNO5F2ldF5j4v7v+JER4KPIO2GhlBXS83TFVU3/OUV7iGLSBcLMiktpOYpQ9O8b+52ByOUAFhNhjpSZLdwvFhFMcA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 4:11=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Nov 17, 2025 at 10:09:28AM -0500, Pasha Tatashin wrote:
> >
> > > > +     }
> > > > +
> > > > +     for (int i =3D 0; i < sh->header_ser->count; i++) {
> > > > +             struct luo_session *session;
> > > > +
> > > > +             session =3D luo_session_alloc(sh->ser[i].name);
> > > > +             if (IS_ERR(session)) {
> > > > +                     pr_warn("Failed to allocate session [%s] duri=
ng deserialization %pe\n",
> > > > +                             sh->ser[i].name, session);
> > > > +                     return PTR_ERR(session);
> > > > +             }
> > >
> > > The allocated sessions still need to be freed if an insert fails ;-)
> >
> > No. We have failed to deserialize, so anyways the machine will need to
> > be rebooted by the user in order to release the preserved resources.
> >
> > This is something that Jason Gunthrope also mentioned regarding IOMMU:
> > if something is not correct (i.e., if a session cannot finish for some
> > reason), don't add complicated "undo" code that cleans up all
> > resources. Instead, treat them as a memory leak and allow a reboot to
> > perform the cleanup.
> >
> > While in this particular patch the clean-up looks simple, later in the
> > series we are adding file deserialization to each session to this
> > function. So, the clean-up will look like this: we would have to free
> > the resources for each session we deserialized, and also free the
> > resources for files that were deserialized for those sessions, only to
> > still boot into a "maintenance" mode where bunch of resources are not
> > accessible from which the machine would have to be rebooted to get
> > back to a normal state. This code will never be tested, and never be
> > used, so let's use reboot to solve this problem, where devices are
> > going to be properly reset, and memory is going to be properly freed.
>
> A part of this explanation should be a comment in the code.

Done.

>
> --
> Sincerely yours,
> Mike.

