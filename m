Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D557CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 12:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36288E0006; Fri, 10 Oct 2025 08:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0298E0003; Fri, 10 Oct 2025 08:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEC28E0006; Fri, 10 Oct 2025 08:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84F488E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:46:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3111F13A80A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:46:34 +0000 (UTC)
X-FDA: 83982178308.01.1D3E682
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D4EC18000D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:46:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EwSUSCY3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760100392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSdoiDX5nR8jqPMFduOgTUs/SIBXnAYTIt/wPSACCBU=;
	b=sDO6zaYIM1u2J+FVq1Y40Qfph/6z44v3sKktbUlC+rFFn8H+tSQPWZIUImwhVrKEdafZnM
	wVy+bRV829UkEvRikEA4gIH7mQmZF/FMzZe1o9RxOnpA3cmtE/OfJ3zrmYFb6ukdYhYOSo
	VpUxl8YYeHR0qdRWRRQWusPaYkJGf9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760100392; a=rsa-sha256;
	cv=none;
	b=KJVlxcFW3qGrfIXxmT6JmCHSQ0TRm5lcLkVq9b7UkO0LUmUxH+qlpeMexvNC3Xk0V9zxhv
	yxKY8a15f/wAl6pPFBj05ESGUVMvQHxxN6LEdKnPnvj9PqSWJQzczxy9fd8i+bp+Ke+bPj
	EBOFwD30V+GLI332q1nNh/cM/IdR/YY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EwSUSCY3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4e7070fa69cso11982521cf.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 05:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760100391; x=1760705191; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSdoiDX5nR8jqPMFduOgTUs/SIBXnAYTIt/wPSACCBU=;
        b=EwSUSCY3IqAuJjR3tiSEBODZ9crNmo7Z95mKLxikjDgkveRztm6MMhNC1eUtZ/9Ha/
         8iDITYsx5Ebkot/1jn7adzRvmsTjbCax5rJLrqnTjM8TxDM+oU9oKeYyKVuA8TmBIt1C
         hqWDwW6EjAKs5OfqwlAAyTEl0aQio6GloO3x0Us7DRy7XmrBjeQtM7xFAkpjaIikPZvf
         343IuIWJ/Q4ez0kh3p3xeUqdvtU8kUhNIZQx+1zmEWHdunXwcqcT55SaP3srMVR7ZCPy
         8YkKZGXaai8m520x4nqXrMI1RI29y28d5acEU0nMDlgTRFW3x8JDSa4z+qqp9yYxQPlq
         6GtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760100391; x=1760705191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kSdoiDX5nR8jqPMFduOgTUs/SIBXnAYTIt/wPSACCBU=;
        b=kB0M2doirsrtweCeoW0gec6p1RcfUxLpxUfmFY3cCoaNu7+aX6ldnxIwAvd/NJhZs/
         bWPfkPrZGZ8pfuYJ1A+47qrTJt9lLkz3gFOWe277K7CqxZ+AgjYGsnEnVkDJrIJVLne/
         aBcW/jAjWLVEinkW2ueBf8iNu1vFoOa5uSgPi/58QH1m9NREg27qhR/6iIAIa2UoQ9ic
         TrOnsIsPy4y0jMzNDX+n/1IqX+t5Jj8Nadvna4q+h1L5DABn5RxBV1czyc0XhlTDNJUY
         /iwDXQqoACmJfDUZsknKiVDJfYFxx2dMI+QD/OvACRUWeTr0vP59Rb6c8vDnzc6fFFYx
         R2LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXC3NP9QgHFj/weic9fSeo1/oKBPgnHy1QgSb/6s1SDv+ySTxoygrnwRrQhM04r7sDYN9saZhEYfQ==@kvack.org
X-Gm-Message-State: AOJu0YzFFeDpNo4UQowMNsxoYObu9jA0pQ4xyC3DYVdI42yIbvgb3o+y
	fLnTN1Em9oj0n5afbN0KbwkNK52xM0Il7kPJjQkGHfj+GOhvKgBpbKO7hK7wpTQWNBVFXNRwcFb
	cgD+2Y/ytnIt9OU8pIJEmF6Kj9U9fh94lZF5ohP7zLw==
X-Gm-Gg: ASbGncuiU3pXOWvQlL5OYcT8wytc5hWfT/iAcJUxXKRMeHU837HcDx5CHmWbM38zBSh
	0cNk/ctgeflkRTO4sV/9ep/aDo6Umpvrho2MJDV9JIDZQWi8evplWV34+vEbqmuxNQYpAJTmvHm
	1dbCI3Q2HXIVj8e2Mo0zoNtZnmegeHtnRpgox5U1YZk+3uHBChvHKiFtdvxzbkhQiZCpyRT4qv3
	zga/S6cwQXc5xjw49d1QMLrQpwNI3O8ag==
X-Google-Smtp-Source: AGHT+IF3WkXquYSs0aZNr+CjES7Xeg58N6tZ4SYA03I6oeZM5oBf1kS+Z/F3o89F5+eVQe4l/6epRXKKJ0esSY22H0k=
X-Received: by 2002:ac8:444a:0:b0:4e6:eb6c:fdd4 with SMTP id
 d75a77b69052e-4e6eb6d00c8mr119176221cf.52.1760100390967; Fri, 10 Oct 2025
 05:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com> <mafs0ms5zn0nm.fsf@kernel.org>
In-Reply-To: <mafs0ms5zn0nm.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 10 Oct 2025 08:45:52 -0400
X-Gm-Features: AS18NWD1lDKPEljKLMW4w1nOwJRnWgZiJv6poOU8kRsyRJy9732wSgdXfAOypQY
Message-ID: <CA+CK2bAKdu4-bZQgopNguE_gVtfZ-mpCo+0zOk-9wu8LW8QQwg@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D4EC18000D
X-Rspamd-Server: rspam02
X-Stat-Signature: puznkju53nb6f7w9xg6tjrojefsua8xo
X-HE-Tag: 1760100392-348153
X-HE-Meta: U2FsdGVkX18xhEjAypKED3XmrAIXUxh5JIK9Xm2NxYST6uLotdP1KUZGadZgdPuZWVi+JF0NGysr4fgms3BBL3KZ5jXe9mg7a+YKjmYVt7BjYVMM5FfTNw2ZfHrIqSEdvpFneUmdDVYas85TySHkdS+jbjCaUaskEZ3nagF6PN5CGnPDIoKr0r/pLptCkW6APUeAvUlXo+iGtB1e4VXEqLKUlXVQ0yEi5x0litEYxBaxLYS98/04ijm+8IRWRIGL8Mf+H3HVKaFavVJhDs+fQsslz6JN7+w+Tco8XQZpedIGFoBMs478moO96zrt2P1BCdDxgpkjAEFWpHh2/AZZ12pxzhgTeQljJmdvaX3QPE+GBqg1gEDudA9dzV/fmCmRjrc26vL8NfLPAFMxBGOdPn8DR0w0+xJXqsuN5B2BJGojDU5rgfZnMZs9IOa7a9I0mUBHuKqp61n0VvZ5nxKHPDF+AmWgv4V5zAe0QRHtYq2aXmUmAr+EWIQZHt18z7Bk2SGuv26ZzF4/+FlmsyqExQtr3/MNhntodJXEwq0Bm8RH8N23NGX3wyHIyYd06tjz91mADO5gPNrckk+InwvmjXv4aeuAGzwRHfR2x8xTwzu4qGs7MTULd6EWkU3VoD8aJ4peiBW+3HpEPtY2HGlpVcYEtQZVOmFEmKAjpbEf/PGfS+8fBXhgrTGoll7NNj6GW3oPrWw8L84U4llzzBVzVQwD8iDUiOUV4fLzP3K5b5GliuTot9JsIXAcgtkqTRjtpPoylpgmMIEDnYYm+atATGAsr/tBk/1GRDTkipc3GcC6vXe4vd/CVQRnTb/Pouh8tK/KKO6/nidArJszveiKH1xto2TZF9y+kUR9fZ9U5+5ohjaoQBMUjET7SJRe5vKF5Asn/Vs3MCDbzwA0OOO66s0Iv02q55jOzJUiCxGUpY/+p10MG2ZJs7FZcS0fRFIZe/WsqCv/g142uu/qrcC
 lJNdSozk
 8h+NRKXr6s+qQoBctOEjFvRLUpTb+vFqlQSvQj7s3QvcI3lsBvV9G9qO0CVo8nf1SSmK7yBeYDqDh46NqHHNzEOmPWw3N1uLAyYt9USGSJVAOXS8Ud6D2UqDy7gRkCJQqdu+UdM4KCkRGNL8CvUkZjLzAp3emfdyyZNs1Q7AMZKX3F0Z84LidyItG60R40oQ/B8zY4tm8Qia7PqqNDWJWODgNx+RMYAOqB8lSj0vhBAtfj6qhuZzStjhu47YzoHNiJJ3BviP6x/mvrX6GbfbyLavwW4dDjQpOvppsxZnDVHaH6GFYflRyvQKE58DjNclVKtOBapkS5jkjdIoyOdv1J+AnXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 6:58=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> On Tue, Oct 07 2025, Pasha Tatashin wrote:
>
> > On Sun, Sep 28, 2025 at 9:03=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> >>
> [...]
> > 4. New File-Lifecycle-Bound Global State
> > ----------------------------------------
> > A new mechanism for managing global state was proposed, designed to be
> > tied to the lifecycle of the preserved files themselves. This would
> > allow a file owner (e.g., the IOMMU subsystem) to save and retrieve
> > global state that is only relevant when one or more of its FDs are
> > being managed by LUO.
>
> Is this going to replace LUO subsystems? If yes, then why? The global
> state will likely need to have its own lifecycle just like the FDs, and
> subsystems are a simple and clean abstraction to control that. I get the
> idea of only "activating" a subsystem when one or more of its FDs are
> participating in LUO, but we can do that while keeping subsystems
> around.
>
> >
> > The key characteristics of this new mechanism are:
> > The global state is optionally created on the first preserve() call
> > for a given file handler.
> > The state can be updated on subsequent preserve() calls.
> > The state is destroyed when the last corresponding file is unpreserved
> > or finished.
> > The data can be accessed during boot.
> >
> > I am thinking of an API like this.
> >
> > 1. Add three more callbacks to liveupdate_file_ops:
> > /*
> >  * Optional. Called by LUO during first get global state call.
> >  * The handler should allocate/KHO preserve its global state object and=
 return a
> >  * pointer to it via 'obj'. It must also provide a u64 handle (e.g., a =
physical
> >  * address of preserved memory) via 'data_handle' that LUO will save.
> >  * Return: 0 on success.
> >  */
> > int (*global_state_create)(struct liveupdate_file_handler *h,
> >                            void **obj, u64 *data_handle);
> >
> > /*
> >  * Optional. Called by LUO in the new kernel
> >  * before the first access to the global state. The handler receives
> >  * the preserved u64 data_handle and should use it to reconstruct its
> >  * global state object, returning a pointer to it via 'obj'.
> >  * Return: 0 on success.
> >  */
> > int (*global_state_restore)(struct liveupdate_file_handler *h,
> >                             u64 data_handle, void **obj);
> >
> > /*
> >  * Optional. Called by LUO after the last
> >  * file for this handler is unpreserved or finished. The handler
> >  * must free its global state object and any associated resources.
> >  */
> > void (*global_state_destroy)(struct liveupdate_file_handler *h, void *o=
bj);
> >
> > The get/put global state data:
> >
> > /* Get and lock the data with file_handler scoped lock */
> > int liveupdate_fh_global_state_get(struct liveupdate_file_handler *h,
> >                                    void **obj);
> >
> > /* Unlock the data */
> > void liveupdate_fh_global_state_put(struct liveupdate_file_handler *h);
>
> IMHO this looks clunky and overcomplicated. Each LUO FD type knows what
> its subsystem is. It should talk to it directly. I don't get why we are
> adding this intermediate step.
>
> Here is how I imagine the proposed API would compare against subsystems
> with hugetlb as an example (hugetlb support is still WIP, so I'm still
> not clear on specifics, but this is how I imagine it will work):
>
> - Hugetlb subsystem needs to track its huge page pools and which pages
>   are allocated and free. This is its global state. The pools get
>   reconstructed after kexec. Post-kexec, the free pages are ready for
>   allocation from other "regular" files and the pages used in LUO files
>   are reserved.

Thinking more about this, HugeTLB is different from iommufd/iommu-core
vfiofd/pci because it supports many types of FDs, such as memfd and
guest_memfd (1G support is coming soon!). Also, since not all memfds
or guest_memfd instances require HugeTLB, binding their lifecycles to
HugeTLB doesn't make sense here. I agree that a subsystem is more
appropriate for this use case.

Pasha

