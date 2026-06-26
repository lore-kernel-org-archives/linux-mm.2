Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D354EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02AE6B008A; Fri, 26 Jun 2026 09:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5B56B0093; Fri, 26 Jun 2026 09:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CB96B0095; Fri, 26 Jun 2026 09:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3166B008A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:26:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC674A0465
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:26:23 +0000 (UTC)
X-FDA: 84922137846.30.AC4B8DC
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id E12671C0007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:26:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WmXkUSTy;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782480381;
	b=C+lrWvT1IlcDAobWqERig8MuT5TlYhm3ZZ6tdFHyx6LeFb5GIP98uSuWxZFO6sZmmNDKfR
	h5sNZsTiWGm7gulxFFR8NSku6MCnfzvF22PcOlISXJNfh4rHrbWhC6JclTv1beMB9VkYba
	eIfrawMfB4gpKIQkKAmOKGmzVE5XBGA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782480381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Voq7hjuwUidlNWLMzAJPrs1yx3BiWD0UlJWeQWkFWrE=;
	b=HTc71xpo+F4jiB2NrGAMlpx011nQLikh3FnNxB2UXOP6VljLRCAKYo0jAjya4IHis3pZqv
	ec5OKPmM6z2PADNdIhj2LbmcJ0rUn2jq1QEbKNS/jIn6gViI0jB5aV3CIeVsMHVTm/pIcl
	fwfNTSCZEWi0ADSRqkhrjinUSR66w8E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WmXkUSTy;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4926f8e02e8so2096745e9.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782480380; x=1783085180; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Voq7hjuwUidlNWLMzAJPrs1yx3BiWD0UlJWeQWkFWrE=;
        b=WmXkUSTywMN6joNxDawaovvFN5fjN3l4sJUlHL8IR991/1OEbtdh6akgZUPVyjWX0j
         M5EjnD1P3dKUB5J+KfZDpR6SDMNd7h/CIg6M2x26B9gT3M6t0YYGvc2qYkPZR+8btm/A
         dFrO4TmGFK+yVmWBmRl+V0Y8Q6JrV21wPh5PKXDPC8ZfwanXTQX0QTr73RHvQ4ocaN+G
         O85d+bjuWyGmuEZf42MXkx4H27XBC0nihpeKcl4D37i1Yd/Gl29gAt4Rr0AfMSa0Wp7Z
         png93yPsTckG96KSSmv16kPh4mQvB43sTt7PjRLtjIMh2/bM9ShtUWAMTXqnsjiS9/r+
         K6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782480380; x=1783085180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Voq7hjuwUidlNWLMzAJPrs1yx3BiWD0UlJWeQWkFWrE=;
        b=fycpN/Q6YxFZH4f6+8JcDfeV/PAz5PYt+9iFCquKTU3zd2aRlt/wX5ht60l6gl/Aho
         XYTx0b+OUwPWjt4ljw95DoEEuD/xy/rqImKPbrhLJvRpF0ht4LiGVmD3HObBBIeIMB69
         z/XBxRJLAiFX2esRfIOpH/eH0zFB/5RIlVpaMh3LM20kOkYAE6Dg1jaNsuhi+5O2uVrD
         l0sVMFgZLlGtJ165TCgp1JeOUb+DHajcIh3DaDBIOxOyVw8Kg1h3T/3MEzil9ZF7lOmp
         lgVGRTsAtYZNm4jppr9TfGfaBi/ociysEyp313Zs5b/CH5TzkuaZji0qagfgw6nhp1fI
         twJw==
X-Forwarded-Encrypted: i=1; AFNElJ9c/kKqhwq5xO4QN+VxM0ugYrJ/n563i6+aILocchCA/ZCJWjerM1wAsZxfmwjWtICCcx8LQ976Mg==@kvack.org
X-Gm-Message-State: AOJu0YwyJK8lqaCgrKsem6gjVDg0iqaQ+jTMWn9GZnFHYL4kiMGWY5AS
	KOMtNo+H3wh/9kEzcIFTVA8acX9IBGrWgRrahajzqYs260Q4biR/Hu2X
X-Gm-Gg: AfdE7cmIp0ImNplWhkXOrk0FKeDon5zUfl688i1d+z7YFs7p02phEGXPQrj4tTWPdX1
	EBRjxFbb8pFczxvz+qe0UgQxX0E13HWGk03AsNmsSjycdNNQpL5TPBdqgpSuNoDGsNqLKSSlThF
	h31Lq7X8/b6k7f2GSnTnAINg6rsOPZzQ4EeaRC1qTnx0u6pv2Eqrp3hjq+cRZIIKn59AuiaTtPW
	lpNz9BLGFRJpORMW2MNOJ+bR3pWnO6TrHKsiwWU+sUeT5sSiKXXi7mo/to8ZEdWYemep4pfCrwR
	ywnSLd3shlQE8vOYWsa9+BlV3DrIjNWoWyDejP/7gisdRjCpkpyYeAUXEL6+zzzYdX5mKnkqnCn
	NOFUGgd1i+Pn2wVtMedIoFIJ/VRbLS84oRqv08OpkQSDcf+uSvsvIA8ufmD4R1Zos6tIdna2dSU
	SY/z7YUhqPG/4pK1SYWMAv/LuykrIfJp/fsq7Q2R6vYRZzHoKtzA==
X-Received: by 2002:a05:600c:8a0a:20b0:492:4c2e:9610 with SMTP id 5b1f17b1804b1-4926684a979mr76376465e9.11.1782480380120;
        Fri, 26 Jun 2026 06:26:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49268f700c0sm85859525e9.0.2026.06.26.06.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 06:26:19 -0700 (PDT)
Date: Fri, 26 Jun 2026 14:26:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, John Ericson
 <mail@johnericson.me>, Farid Zakaria <farid.m.zakaria@gmail.com>, Jan Kara
 <jack@suse.cz>, Kees Cook <kees@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, shuah@kernel.org, linux-fsdevel
 <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 linux-kselftest <linux-kselftest@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
Message-ID: <20260626142616.5232c61e@pumpkin>
In-Reply-To: <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
	<sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
	<CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
	<24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
	<20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
	<CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E12671C0007
X-Stat-Signature: 4ic3uuik39i5318ebebxmu9ht8ishfeo
X-HE-Tag: 1782480381-815529
X-HE-Meta: U2FsdGVkX1/GXPKFI79OBB79pcyS7QgCS6C/I/2hYQ7374qSQ+u8/OZLFN0dZAJibXuRe69ZcdCBVFp/yXMyzsZKr6ux5ukueo2kGXYTsEgzAJ4Ll3uguKbYPe6/TXiNngxl3l/4NF4HH7GaQT5TCPBD/4YtDLr+KBXQhgLlN/fBxlqcGUlvNFpuviabiO4bScckx7s2wDr48LXnpeDQdOeQeEbgifHsN9qwa9LJAng/fhwvR4acVn62CSAD1HI5ZwMu9dxW3z6LVmkujq7vUXTiqHhxw0bQGV3YEwrOUHB/g+RNlFo2FKIolkXQIpYly6tqzbNcq0ceajdZI3RNla1Q/Tq0AZasfb3B/UP8iavpbrfXHe3eLuBi0pIslUf6MhwK7PV6yOV9hZgjvvyItKCcGr9hUvv17/8PewW1f7qSWJB5VKbsm3mXf61/CHyOzq1S91K7q0HLoZesB8j5KkocU1JGWizN3PzORSXuy6K1i3MIgQ8NYA0sQRSKeEeQ4syyNa2I2DvhL0Eug3zBzPAREkR5IPuUpZupl/miIfR58nC0T5uN6xRAV473wCB+SRfwsff0D+t45jW6G3hPSLvwj3PPIvfEIWrcsJ/ca2JhAcWkrJEt7Ax4YxB/7RgZc8ZnGmENQdQ7zcUVOCIzyS66fPPvLpEbTs3I9L4gTp5EahOXv5M2yg465vYEE/kKXp84pN+0+H/AimJAOUahzxGeBYTsqUEw8mTKySsm2qiVxk7mTh9ZrjbLy8MrymRPHqj4gcJrVY8hRfCbcr4O8lPFTCv3GQQMLnp9lvtdkN+E4+XzjO7Hnh8qMgVpBgLPIjILUXBkAZmp08mbVFAr4cq4mUGUi6iLK6J0eEiNgvaLFtA6y+ScIf18kE6P8nAm+tXVHgzYscNttRZwAZnYS+xvue/QiprnoZSzVZAs/WPQrZv9cxO8EH7CkXd9hl7BYUAh+ltAZHgwr1EUBPP
 2b+V1xfs
 8LFW3pR6sXZCDkZtvmmSrpUY4OCD2rVF5KBSqy1NCYbiToFnIAziuO/MUi6Ae410UTDCNS6BRJopW8f5AFe5oNmcFYZK66iv09k/42j0tq1e8CEYSjOAUn0g9GuBRtsKlBW1g0oQZVzfCUZl7gYyQuMJ0MPqrZl4N3kmyk4lTVqFGEQqzP0DQTSeCCM2qDKOgY/lxlUIpoxtmvTXLQ3+Pg4Q2dVe5NRyzVbz+QilrM0835IrdovZAXI7KKosPkoh21LwBEnNB8VCRRSD7EH8lrID6c19zJOoNmPayHZHghzA2p/mV65UZbU1oAUF3nTe501BPhNdfb42d6bTwPft2xDgZHu4LYF5IOESfWO7dldFxeLPRRtP5xqlV0EghYqz9TqNj0zLUVxJNuPKtFfxNDhtYPaG2Q1UdIfMlF8smRfLEYYxURCs1KdFlD56xPOQRkqXY4JazCV5byjLspKSJx2/CUcZ+iwxftxrEMgUtyAJR+s1s6dZU/egLGiGVfxdYDuiMmPTTns2F5b6WNJbQxeeXjDSBkI0taeNJw6nATUKwIeB3R9WzsVdeAHjCX9Xt9eozooy4o38bkbAavoMQJ5D+YUaLHXEzH30ItZG+YGGS5LsXE0H4Q0EuKGyueuDnlqscdh4fdv5hq6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 14:39:22 +0200
Jann Horn <jannh@google.com> wrote:

> On Thu, Jun 25, 2026 at 10:50=E2=80=AFAM Christian Brauner <brauner@kerne=
l.org> wrote:
> > The arguments I have heard from various people so far are:
> >
> > (1) Userspace would be able to clone a random chroot to /woot and run a
> >     binary from it without having to set up a complicated sandbox
> >     effectively making dynamically linked binaries more like static
> >     binaries in a sense.
> >
> > (2) Quote:
> >     "If you debootstrap/dnf a chroot to some location in your
> >     home dir and try to run a binary from it, that it tries to load the
> >     libraries from your /usr is a pretty unintuitive and not at all
> >     useful behavior."
> >
> > (3) Quote:
> >     "[Various remote execution things run in locked down containers that
> >     disable userns, which makes the sandbox impossible and hence our
> >     builds wouldn't work there." =20
>=20
> FWIW I think someone also mentioned to me that it would make things
> easier for them if they could build a piece of software in one
> environment and then bundle it up with all required libraries and such
> and run it in a very different environment, without
> container/sandboxing stuff and without static linking. But I guess
> that's kinda niche.

The problem with 'ship the shared libraries with the application' is
that you get all the problems of static linking.
If there is a bug in the library code you can't fix it without getting the
3rd party to rebuild their application package.
If the bug is in a system shared library updating the system libraries
fixes the bug.
Now this does require that the writers of shared libraries maintain
backwards compatibility and that the 'system' provides the required updates.

I remember a long time ago the company I worked for shipped a system where
the libc.so the linker found was actually an archive library one of whose
members was a shared library.
So some functions were dynamically loaded and others static.
There was a bug in one of the static functions (IIRC it corrupted the utmp
file), once located and fixed the 3rd party had to be persuaded to rebuild
and re-release their product.
(It has to be said that anyone with half a brain would have realised that
because libc was split for compatibility reasons, statically linking this
particular function was actually stupid.)

	David

