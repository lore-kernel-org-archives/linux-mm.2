Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7418BCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC008E0081; Thu,  9 Oct 2025 11:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC588E001A; Thu,  9 Oct 2025 11:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B458E0081; Thu,  9 Oct 2025 11:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF8B8E001A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:02:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C8BF1409DB
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:02:05 +0000 (UTC)
X-FDA: 83978891010.07.46A8EF5
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 23AFD40018
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:02:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VSStyeaj;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760022123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/z8khJoxVLHmPK7qoZGvzrF4DQgT26xSoUBDnCmifo=;
	b=uVO8slSuYMS3/h1MbxwzDAebzJPhFQSziKL1qDoO9D/83d+zqrKTkTi5TjhcfaDq+mcWvH
	XzJW1acS/zzJOXzQ6V8WSd7Qsac00AIfQp78hiFhTnMf7JcyHiwdC+AJXXfpwrE4+Axshi
	wIC2KU8Vzp4CbVEwEGKbGsTlNHOQgcI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VSStyeaj;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760022123; a=rsa-sha256;
	cv=none;
	b=AxF/Jgt5Pgxi6HtCZ84+yufMdgLKQaVVp1qlmvg1hJcJ4wJre2E8RA4lhiGF/vsK24QaoU
	AsHDSbTs4kQ7NBEn7rg6WEsDHbrzJubGVv2LObqw7oCY/cj3HoeVqyl6cZMkBoWwa8H70U
	aS5Nnnl+dwhfLgqNzkEqBKMz1ppvNhE=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-86420079b01so115739585a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760022122; x=1760626922; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/z8khJoxVLHmPK7qoZGvzrF4DQgT26xSoUBDnCmifo=;
        b=VSStyeaj1S1mm710v7F9KqFHhRGKLcXS8XxQKC7mIh6qpo+LIMA608lu5Vh2fBGDRs
         /Ur1AUiOdJl85kezPyPNK++KiADFibreQ++b/Fxe+9OWR3DcxB34yayrcQxZz9O8wSTH
         hR8ef+fESYwXZv821aekVwlnjy5UdTadbOgpTnKHp3Fp72+U/jNAi0wnxW4HzJWb4LlE
         TIG0xjdiIOBvl96iPuuiXskl9EvbcvOYreqBb7Cgwa8A7i78YtWlQA0a6aenNY1P90fA
         yvyDPzts9vTyucOTgmvGHKDcUEv2WETdGT0KL7aB70ntO/3/xhAhvF0zUD7bt1QddHV2
         zB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760022122; x=1760626922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/z8khJoxVLHmPK7qoZGvzrF4DQgT26xSoUBDnCmifo=;
        b=g81J7sjfVNfMWFdeeXqLll3eQVwlLqeyFXHzTpdkpbN1ozwbpN5wUb4vYlcSLlGqg1
         xxqDjKiO+KsS/LToD9zPcctSwuJlBv5m/vB5I6vD3lBBFonzkL0qhf/4995/FmT6B9pt
         O35jdX3i9KNgI7DXYykA7y46WhGMeo/BNkdQ444vpX2y8X+XUuc9zWgXXB+F3eqDa1pp
         EbEdvVhFKvB0ZTd1/kyGOqNE1HjGhJKVdEaiWmHK58N5ChAnDb8iq50i+T5p+6yWBEwA
         8xfbERZe8seWz3jqOHIb+LFp2/pT5JIApgeQttgAwxt1Ro4YZ1aS5fVbmh2Ko+YZ/fm+
         Pdcg==
X-Forwarded-Encrypted: i=1; AJvYcCUI9fCWa2oeYvCzClsRa4OLkwUixbBEQF7u8g/3ILinUzZKF77FiCmcTxV3FnU+fhIgeqSqh8fTYQ==@kvack.org
X-Gm-Message-State: AOJu0Yy97K2AnVkZqodSvp9ybMhY6PxMthu3JlgyfSZg5YiPu4PSPAfm
	hOSVFOgaGX/fY/Dx4aKCyw2sdG0YBRYk4jeHhzEH/Zr0xOFhFjRgVdNoi8cyH9/Qp/k/Jczb+xc
	I/bDgohnMRNT3Ovj/8QlqeIjsjU9O2U+HV7UXZoP2Qw==
X-Gm-Gg: ASbGncuIl3nhr6Ld52dZi9r4AGC8WMGAG0jQxinxKnz1gL6ZIjaH5SenSwz8RVWwhRr
	nB2Eno1xVt3ZKJFjTktfLkNIOX/phSWNG4zDqKzeq2/Joi3JvEu4tR/HZ7G8dLg0NGtlItsMOHK
	52QZCT/0tRhumkT75N9yMI1Tc9ZQtqzDxbyqbHH+MZIEo6fREtxyfB3Si3oejX5UYCtq1yxHIAR
	x7wG3IoFDDgW7Dc9O0AvJDavVi+wN93apsTriY=
X-Google-Smtp-Source: AGHT+IHWZrsWQBVDgH/jOLg85ut9tpsAvs6Ay6dPPKxRl0eGWT6ufzfd4YGMNHN9dJa9p/uV9JGeofl8lrekOiPxgXc=
X-Received: by 2002:a05:620a:1922:b0:80a:beb4:7761 with SMTP id
 af79cd13be357-88352d96abfmr1122356985a.76.1760022121721; Thu, 09 Oct 2025
 08:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
 <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
 <20251008193551.GA3839422@nvidia.com> <CA+CK2bDs1JsRCNFXkdUhdu5V-KMJXVTgETSHPvCtXKjkpD79Sw@mail.gmail.com>
 <20251009144822.GD3839422@nvidia.com>
In-Reply-To: <20251009144822.GD3839422@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 9 Oct 2025 11:01:25 -0400
X-Gm-Features: AS18NWCA3qNWmPQQ-Sno75dRV8wzDfExqmWutOxV0lNaAa2GJDqhBEemNsPTudQ
Message-ID: <CA+CK2bC_m5GRxCa1szw1v24Ssq8EnCWp4e985RJ5RRCdhztQWg@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
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
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 23AFD40018
X-Stat-Signature: 9oxc4ntajt1u5xjwwkokktdyodb95d96
X-Rspam-User: 
X-HE-Tag: 1760022122-680275
X-HE-Meta: U2FsdGVkX1/MNmyIJloJSUxxFoJoo7BqiQL+W6FAjEO50MyHufqjn3h2Hx/jv27S2zxxEXtSmKUmYKfP9jmQ7REsQHyEZCMG6lx28CL7kETCpTdA7JXvJjJ+M69MF86Vv0mqaDFaez3VahRttp/NMkiNNtGgzWfX7UiLyp+kmhdLeD5ntQz1qJMvZ9XCE4rfpau3bluE25DP/cTs2jv5aXmKaOp3iRAnK/kL3MpB7SVou3Ubx+uFYyH8lv4hWvL+3p1gtBDad3ul20E3Pnpqs/zeIvUEEX2xApJq3AhpH0iEHNI6n+2BnKBGn/vWhImYTSPo8QexkSASZ+g/ss3Pmu+Irq9+9hKcyOdflvhCXp0k7ioMAkP4YwYVZerRpNDRL7Y2GLSZMohXGCo2Whr5BOAYmAFQYcmJ1yrSdok2PmQTWJC9skbzapWpUyVw8iVwORTnWi8O/jz3NFSoexTGn7mjvw0kyn8Jgz+NdSmWhFVrG6JmLryDOflXQDex01J/alU1YfeA4yjZlWOQQjpUFk9Nmr1kM26No/0IUfzZII8FJOwED1LLcU3QIFVdQMX9wagFavMPGO0PI2pXV8Zv/EcSure/WOv9vHbrnr1iW1eTaf2fNubZ7IfjEv8LjvvinpgEBzuKnmAEHCBrAxSFg6neuw8Tth+xC23UO7Pu4wi7ogvZ45HiUllbKlEmkNCiWtW2GZDQT6qxDXQmS1hhIdXy4ktThsJwpjiKiaMhIA0ueFvU1b8Jim+xBNtyucSU0VvOdxkjQmhVO9r8exfXp2Dpub9uWuYNQkz4arHwFGsgZT2Fcxz9ecUnNwFBz6VkJX/rV1ONwzrmjGQX829n9IBnZ5C+5ue9q9Ykk7BDYG7lrPJSX0NwL80jbPgMgDpa0mdqejMuXC++J/lyk0L4DfF4lQwHVGJgPzRCPGNWKkC2VtvxVyx1thDzm9St+8FWCZ4Cwtnb12bqg4JR1Fv
 IgO1enYm
 i1cGTOn87JxxqN7gVwSIL5z+D/NpkmqZMZWrIUXXmdtSbty1e8E6hX4EBnwdtuDF2KUOGWOYFeuOwnHmKJztyw8MdB3pyy/6vqjkxary4IRQvB82VKoNByswnXHicyKbPjc0auNb2deXgdTCEvYdr/9UJRFuznZ7y8f1i6Du1zlzy0uJnMSF2gc1okE41MKHsFy7BdstEJjpIuipJnZ4CsRP6DpmHBx7RkPHN/T48tWWeXq4dQyadezlww2ZhgCzzdijNI/1vlQwtzIvDrSCrMfcfLVB6LclGG5e3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 10:48=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Oct 08, 2025 at 04:26:39PM -0400, Pasha Tatashin wrote:
> > On Wed, Oct 8, 2025 at 3:36=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com>=
 wrote:
> > >
> > > On Wed, Oct 08, 2025 at 12:40:34PM -0400, Pasha Tatashin wrote:
> > > > 1. Ordered Un-preservation
> > > > The un-preservation of file descriptors must also be ordered and mu=
st
> > > > occur in the reverse order of preservation. For example, if a user
> > > > preserves a memfd first and then an iommufd that depends on it, the
> > > > iommufd must be un-preserved before the memfd when the session is
> > > > closed or the FDs are explicitly un-preserved.
> > >
> > > Why?
> > >
> > > I imagined the first to unpreserve would restore the struct file * -
> > > that would satisfy the order.
> >
> > In my description, "un-preserve" refers to the action of canceling a
> > preservation request in the outgoing kernel, before kexec ever
> > happens. It's the pre-reboot counterpart to the PRESERVE_FD ioctl,
> > used when a user decides not to go through with the live update for a
> > specific FD.
> >
> > The terminology I am using:
> > preserve: Put FD into LUO in the outgoing kernel
> > unpreserve: Remove FD from LUO from the outgoing kernel
> > retrieve: Restore FD and return it to user in the next kernel
>
> Ok
>
> > For the retrieval part, we are going to be using FIFO order, the same
> > as preserve.
>
> This won't work. retrieval is driven by early boot discovery ordering
> and then by userspace. It will be in whatever order it wants. We need
> to be able to do things like make the struct file * at the moment
> something requests it..

I thought we wanted only the user to do "struct file" creation when
the user retrieves FD back. In this case we can enforce strict
ordering during retrieval. If "struct file" can be retrieved by
anything within the kernel, then that could be any kernel process
during boot, meaning that charging is not going to be properly applied
when kernel allocations are performed.

We specifically decided that while "struct file"s are going to be
created only by the user, the other subsystems can have early access
to the preserved file data, if they know how to parse it.

> > > This doesn't seem right, the API should be more like 'luo get
> > > serialization handle for this file *'
> >
> > How about:
> >
> > int liveupdate_find_token(struct liveupdate_session *session,
> >                           struct file *file, u64 *token);
>
> This sort of thing should not be used on the preserve side..
>
> > And if needed:
> > int liveupdate_find_file(struct liveupdate_session *session,
> >                          u64 token, struct file **file);
> >
> > Return: 0 on success, or -ENOENT if the file is not preserved.
>
> I would argue it should always cause a preservation...
>
> But this is still backwards, what we need is something like
>
> liveupdate_preserve_file(session, file, &token);
> my_preserve_blob.file_token =3D token

We cannot do that, the user should have already preserved that file
and provided us with a token to use, if that file was not preserved by
the user it is a bug. With this proposal, we would have to generate a
token, and it was argued that the kernel should not do that.

> file =3D liveupdate_retrieve_file(session, my_preserve_blob.file_token);
>
> And these can run in any order, and be called multiple times.
>
> Jason

