Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EDDCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4258E0010; Mon, 17 Nov 2025 10:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394D88E0002; Mon, 17 Nov 2025 10:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283B58E0010; Mon, 17 Nov 2025 10:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF3C8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:10:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 869F484E3B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:10:09 +0000 (UTC)
X-FDA: 84120434538.12.BC4B9E3
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4ECBF40011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:10:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Krfv9q8c;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763392207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dP2LHZDimsWJcFP9x1EBqhMw+V3jN7gWuVzxTdsDvKU=;
	b=sHCZVQh64dGL+LK5I4LslkQO1EWssEBZo00bpk/BdRdkCbJWKHAMHmiPcGYyg+K3pmYHge
	uh5FTgWSkI+fsKUOTuHpQ2E5mdbCfxdH5trPHE+29X6IbxRcCY2OUpoPVJdqFA8YuANh1O
	n37FCg4BX+pgT/xOdnBjKUnCYiJ92wQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763392207; a=rsa-sha256;
	cv=none;
	b=DVRJnghFGUxXy3LxhrpikxCUk0j3iqjqjxdXmck1zGU2lW+3sGIOsJUoYxdgHlJPd0ybUW
	X570G2ThyY9ArUt1ffNwYZeRHvG4fRZbaNneMvUGFQNzACArvbuw5vvK2sz4cK/Y2T2z4q
	Or0gLB9ofHyD4W5xK0nZbsGxwoHOG8A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Krfv9q8c;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso6810930a12.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763392205; x=1763997005; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dP2LHZDimsWJcFP9x1EBqhMw+V3jN7gWuVzxTdsDvKU=;
        b=Krfv9q8cv53ybT+8Q06S7k1OGVkgTGv80O72/hUdsa2cY4W7kYhucesHPy26nj5rZc
         cB7ztH7nTWujpXoYScQGVtHf4KcQgzzjS6/N5PkTn9/kQRZLdweLJhd/j62d30neQncV
         DMGOeUVBfdOstQLUAp0sBtbr/2fn3dEcm6qlslkqM///ePZ73xThoGGxglx63BrrZFHd
         g3zs/AgTeoLBxNfWhcqmiZYfBQ7FGOJui51oOPgAsKn8jy5bfjNZBzHdnoRS+5WxqYxm
         4S+tX3UrS8WYbHEPoG5gmOeaR3Acc5YZe/UAhCUwh4ZfOe6cuYOQ66DIDiVYZLI0U1jF
         j/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763392205; x=1763997005;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dP2LHZDimsWJcFP9x1EBqhMw+V3jN7gWuVzxTdsDvKU=;
        b=A8n1W8/dxuHJYeVD4ORSW/vTab+0adASwaHet84cNWfTOnfhlKVmIDxQPIjqCycPZz
         jZA/X2I0pZ1zwLwmf2o0Of4UNOunfcOIVSRI5UB62mJ6kzj7WhAFjzvDcp3wpJEiknCY
         PkLc/mcQhE1ej6pNFic/nQm/EDTxGzZUDX7SMPru7q5f85RdYBAXWeJgCgG8VdHMdt4L
         hfPV0lbdYvrWSln6O+HN2u9seEdebRtyKBo+7LaS4sHslUE15z8by5yw//XxL0AQuxCL
         ht9r++Ov6Jy3i/NS+MEl0TPfNiojXnCJaSpWctYKlDpYi8WhhiVl3xpkcoQFiL15n9mH
         +Shw==
X-Forwarded-Encrypted: i=1; AJvYcCUxzvefvfh/WSYR2dLOorHqzBoGTLHJKraoHdu+k18zccNQoJzo6IVIn+F1Ig1Gb1VZTvvj44o/iQ==@kvack.org
X-Gm-Message-State: AOJu0YyjdqklkSEtK4zLBJkSmzO9tZkjxQgNjcryWYu3jsZcJr1OkD+O
	leaizgkh7RfzNubztxNqkfs3T9LJStS4GCIRP6cJXUWu3VoTfncRJHUJ3i/q5Lx/3Qpz3iBd7zx
	0RrKT8wDsyTUW72zTcYY0fYb64e2pWFrvninFkTRvVw==
X-Gm-Gg: ASbGncsvNNy+M9XYlDM9LVJf553ijOXsdrA3R8AZ5ye7Xj72F/SFOrCffOMgWeBBRaQ
	xwJlGpSR/Pu4e2POGwJjbFuELxfLrbg651smXCr4JIszC5nGOjtYmDglx4Bop/jt9EEsvhG4VEC
	EA56valFIl/z5RlXWNW4j9QbWsYhxW4goP0//ZNpvbWtAnqjjZyNoLAjyRlFXfYObQBqnBBjvpA
	6DT0LFHXCfvxyl65nNuZPUA75s0M8aKYZe1b2pV20+gMb4+QjvMtjPbwnoeR7x1Jaw/
X-Google-Smtp-Source: AGHT+IE14EI84+1nV9PNUG6pyDkb7Qkp/5p7KJ3U1mYqA34EgSz0oKhHHX1OOhrjgCkHr3Z59mY5mFsJkBFb4s2zZDw=
X-Received: by 2002:a05:6402:2809:b0:640:fb1f:e95c with SMTP id
 4fb4d7f45d1cf-64350e8ecefmr12877833a12.20.1763392205305; Mon, 17 Nov 2025
 07:10:05 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-5-pasha.tatashin@soleen.com> <aRoEduya5EO8Xc1b@kernel.org>
In-Reply-To: <aRoEduya5EO8Xc1b@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 10:09:28 -0500
X-Gm-Features: AWmQ_bmj83X6sEGtJOzbfwBfqdKgU7Rrd4Q7eSBnGujAPm0UgvTXUn65F7Vknl4
Message-ID: <CA+CK2bC_z_6hgYu_qB7cBK2LrBSs8grjw7HCC+QrtUSrFuN5ZQ@mail.gmail.com>
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
X-Stat-Signature: p3bth6w89qxzju7cxqjucg5k18gme8fk
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ECBF40011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763392207-924077
X-HE-Meta: U2FsdGVkX19FNyX5xvrLOywxPI5yqBU4LVszDS1uVD8/HTBT4cKOwpXntpTYX0wdhg/CDnXt6A2o2ScLJWyfaxno4PATBaB1EaDdS2A63AWEMyWlhr2q+xEBwCTsmM/acWVyWZ4+uSgZTOL63lzvn2kluTH6OJrrXQURzsfYtvPQs/SQAwHJhPUf18TUZ4H8Mz/Dse9EZSDGfhrPcl9sJGLQDjGrtNI+O7sIVBv9280ytiqNFU7LsU+vRgl2q+8WAUHQ4CYg4KB46oV4+Va6l3HW6116WUHS+DnGBXJOXC97uIGEjoHAbYLVxMA/oKwFEaWswyxJVrrtrtYlnI/eAgnN7YswOlbvdh0gO7mcZPMWP5+xvzGEHemczYaROTjNxa0KMAZFWcnHV2ykn3vCjQJVI84EMM9A3cjQ5tSJwLpeccAoLbPZMd6oXtaO89hRAdj647LKrdd/yH0uPzrlcbLynEHbmggJqoQpefxeGv2u649D8q3Su59p9+Zx2lmjwFdpijhE+/0TUMgidRPvG11EOqJUuc2g2c2buubVEiFuHhObuGyXkV7D2//WR1uMWh2IAD7L5kDyQNxG8NCK5hBl2K71fKP7H26RYQbYWUvsnyBbWvozIhw0+BUnEJViEOLEWV3FAIFGcCAdlZdT1PJ6xiIcziBs58ZNJgvC8i5Yi/brnHKmdyXgWauZwSdN7VTxN+XNszmYC5ihYP2v7rIBw+qGhqMWlGvSr1gpAO6l77WqE4yX1mwijCmtnRVRrC8KsRn07+J6mKefldDIzX4jFXPvl/+Z0FBs5t/sAgIff5ARbAZI1SS0gaEFMQGLGVIpC4hz71ybNPCp7/fk4/HFVlSXAPCWbx4uGKdqwM+If0wved/+n+YnM3AbDmHJ2hVDxWIGQmD8ATWz+dMcPkVtPJfrvhKWQZ3/Bbc5TnkTPIKKQ0iFYjOQHgOLHswCmeNLLlK3sv8dOA5QR0B
 IxOxvZy4
 2tI7RHBzpyFzc7pQmT+8zVgVxCOkh7JLWd/lgaYGZ11Tr81SyiDGS7FgdsrqdGLWhzox0hOMkGFxzXhdwuuAQhyPY569uV6FDinvro7aKq2X9NL6IUviZb3KHzJ4iAxqDNTUiUXzn3okmaCcdBi9uHzmLXkJ7M16ccLHa6tZu8VlgFEsFu8b5gtgMBJT1LWlzEk73Tkb8MjZs9dOe2c9BKJdgT4yA8TrN9uIXTTUwiPfvct7bH22dvgBaXdpDTPm6Es8I60TMeZjMV6mk+IGsU5McBld6jZEmJLue80CZiAVhYvJFABWo6Ru6Lmxp3q5vjz1Jhwes5Fv75OTVjCacNmdYnmz9hIc7xeBShKeZTBFa9ZBOyEnQVxBe7Z1lptCmHgeljraCGSmWYVLoDsKQywvcHmklJZrPv0ujFuarGYqfV+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +/**
> > + * struct luo_session_ser - Represents the serialized metadata for a LUO session.
> > + * @name:    The unique name of the session, copied from the `luo_session`
> > + *           structure.
>
> I'd phase it as
>
>                 The unique name of the session provided by the userspace at
>                 the time of session creation.

Done

>
> > + * @files:   The physical address of a contiguous memory block that holds
> > + *           the serialized state of files.
>
> Maybe add                                    ^ in this session?

Done

>
> > + * @pgcnt:   The number of pages occupied by the `files` memory block.
> > + * @count:   The total number of files that were part of this session during
> > + *           serialization. Used for iteration and validation during
> > + *           restoration.
> > + *
> > + * This structure is used to package session-specific metadata for transfer
> > + * between kernels via Kexec Handover. An array of these structures (one per
> > + * session) is created and passed to the new kernel, allowing it to reconstruct
> > + * the session context.
> > + *
> > + * If this structure is modified, LUO_SESSION_COMPATIBLE must be updated.
>
> This comment applies to the luo_session_header_ser description as well.

Done

>
> > + */
> > +struct luo_session_ser {
> > +     char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> > +     u64 files;
> > +     u64 pgcnt;
> > +     u64 count;
> > +} __packed;
> > +
> >  #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
> > diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> > index df34c1642c4d..d2ef2f7e0dbd 100644
> > --- a/include/uapi/linux/liveupdate.h
> > +++ b/include/uapi/linux/liveupdate.h
> > @@ -43,4 +43,7 @@
> >  /* The ioctl type, documented in ioctl-number.rst */
> >  #define LIVEUPDATE_IOCTL_TYPE                0xBA
> >
> > +/* The maximum length of session name including null termination */
> > +#define LIVEUPDATE_SESSION_NAME_LENGTH 56
>
> You decided not to bump it to 64 in the end? ;-)

I bumped it to 64, but in the next patch, I will fix it in the next version.

>
> > +
> >  #endif /* _UAPI_LIVEUPDATE_H */
> > diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> > index 413722002b7a..83285e7ad726 100644
> > --- a/kernel/liveupdate/Makefile
> > +++ b/kernel/liveupdate/Makefile
> > @@ -2,7 +2,8 @@
> >
> >  luo-y :=                                                             \
> >               luo_core.o                                              \
> > -             luo_ioctl.o
> > +             luo_ioctl.o                                             \
> > +             luo_session.o
> >
> >  obj-$(CONFIG_KEXEC_HANDOVER)         += kexec_handover.o
> >  obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)   += kexec_handover_debug.o
>
> ...
>
> > +int luo_session_retrieve(const char *name, struct file **filep)
> > +{
> > +     struct luo_session_header *sh = &luo_session_global.incoming;
> > +     struct luo_session *session = NULL;
> > +     struct luo_session *it;
> > +     int err;
> > +
> > +     scoped_guard(rwsem_read, &sh->rwsem) {
> > +             list_for_each_entry(it, &sh->list, list) {
> > +                     if (!strncmp(it->name, name, sizeof(it->name))) {
> > +                             session = it;
> > +                             break;
> > +                     }
> > +             }
> > +     }
> > +
> > +     if (!session)
> > +             return -ENOENT;
> > +
> > +     scoped_guard(mutex, &session->mutex) {
> > +             if (session->retrieved)
> > +                     return -EINVAL;
> > +     }
> > +
> > +     err = luo_session_getfile(session, filep);
> > +     if (!err) {
> > +             scoped_guard(mutex, &session->mutex)
> > +                     session->retrieved = true;
>
> Retaking the mutex here seems a bit odd.
> Do we really have to lock session->mutex in luo_session_getfile()?

Moved it out of luo_session_getfile(), and added
lockdep_assert_held(&session->mutex); to luo_session_getfile


> > +int luo_session_deserialize(void)
> > +{
> > +     struct luo_session_header *sh = &luo_session_global.incoming;
> > +     int err;
> > +
> > +     if (luo_session_is_deserialized())
> > +             return 0;
> > +
> > +     luo_session_global.deserialized = true;
> > +     if (!sh->active) {
> > +             INIT_LIST_HEAD(&sh->list);
> > +             init_rwsem(&sh->rwsem);
> > +             return 0;
>
> How this can happen? luo_session_deserialize() is supposed to be called
> from ioctl and luo_session_global.incoming should be set up way earlier.

No LUO was passed from the previous kernel, so
luo_session_global.incoming.active stays false, as it is not
participating.

> And, why don't we initialize ->list and ->rwsem statically?

Good idea, done.

> > +     }
> > +
> > +     for (int i = 0; i < sh->header_ser->count; i++) {
> > +             struct luo_session *session;
> > +
> > +             session = luo_session_alloc(sh->ser[i].name);
> > +             if (IS_ERR(session)) {
> > +                     pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
> > +                             sh->ser[i].name, session);
> > +                     return PTR_ERR(session);
> > +             }
>
> The allocated sessions still need to be freed if an insert fails ;-)

No. We have failed to deserialize, so anyways the machine will need to
be rebooted by the user in order to release the preserved resources.

This is something that Jason Gunthrope also mentioned regarding IOMMU:
if something is not correct (i.e., if a session cannot finish for some
reason), don't add complicated "undo" code that cleans up all
resources. Instead, treat them as a memory leak and allow a reboot to
perform the cleanup.

While in this particular patch the clean-up looks simple, later in the
series we are adding file deserialization to each session to this
function. So, the clean-up will look like this: we would have to free
the resources for each session we deserialized, and also free the
resources for files that were deserialized for those sessions, only to
still boot into a "maintenance" mode where bunch of resources are not
accessible from which the machine would have to be rebooted to get
back to a normal state. This code will never be tested, and never be
used, so let's use reboot to solve this problem, where devices are
going to be properly reset, and memory is going to be properly freed.

