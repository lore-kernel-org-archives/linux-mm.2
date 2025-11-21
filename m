Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC0DCFC50A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 21:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507F66B0062; Fri, 21 Nov 2025 16:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8676B0088; Fri, 21 Nov 2025 16:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE086B0089; Fri, 21 Nov 2025 16:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27A7A6B0062
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:31:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C36FD1A060D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:31:26 +0000 (UTC)
X-FDA: 84135910572.01.AAA271A
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id CA1DCC001C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:31:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MlrSi68j;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763760685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+byFGoWk/0V52ELeDrnzRQimZK8yvBtN44GDPwhdBk0=;
	b=caLOXaY/S53JxP0m27VBybrW+jeRjaVt1dQEAEtx/6igabAIaGGjUoVTk3j9W3k8gNmDEp
	Dt7tI8uf+o/o+CLKzuK8QGs4caOvxVDND4aAcTYpNIU5AMGiQ/IINL1U81Dbc2iSVfehad
	HKP/RKApZ0DmtgxLembac3JH4nWsexE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763760685; a=rsa-sha256;
	cv=none;
	b=eHAfxWTYi3g6Kn13gdvQamX/TSAT0krSGaa/JnukADXhU7G8poGzhRmng78CMh2Zq5SAc1
	Tlsn3I4YMk4jDKcro99FWjnvN+PazeqPzrGbzKy5SetDefKwrBjkq62S9RPiu8WQCmJGtB
	/aGf4HhONkhpdfXkJVMuMzmXiZM2Pa4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MlrSi68j;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so4049705a12.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763760683; x=1764365483; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+byFGoWk/0V52ELeDrnzRQimZK8yvBtN44GDPwhdBk0=;
        b=MlrSi68jiBFU9rM2/JD9ACwJbAegoAWuYWAN97qd9X9YJUQmg86ibHyKXMHttmIiUA
         XOt8VF/aiZrmZT/lzV0cTNhe3lULEsqMpAkKjLrqDSsflgm4+Y0aShERwrtL4X/nfSHy
         G2saFn6ivUCFzVeEj43yfXIYiOjUetF6XcCxqTkDTHGNzaUmGIOTH+AqL63ZUUjqHlDf
         4PlAackq/RWbEAEcZJZ8GuNnMr2JGEIuENIVOipA7AUj/MVZ0m8W5XxcC8tnd+pMHe4h
         wRrDInchLYkl/SEPcY9u1jOPTUW/8SEt5JZWiGL1Sqzp3C7PD0KY2KEkstntxP0ZA81X
         K8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763760683; x=1764365483;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+byFGoWk/0V52ELeDrnzRQimZK8yvBtN44GDPwhdBk0=;
        b=E1SF0ckwP106ppsLwn82uqo2Qyf1f1n20dxgUWEQxSfMEsdF1Pp65urqSHh5c+97ww
         2A2dlgEisljinPLG/nw35tjw/jx6jhMF75mfGEbvhG1HUeB5ZZbyB6FctH+VkNOUDZYY
         ey5OUjwyYA1bJ17qHNsAKxX5Qt1H3+pF5aAjLVdhY8mSYe4WCcKUASjz4Q5nSLjwQiiG
         ho+Tet7SYKKZCgT26oAqPulNIKuAueu7xfp0wA/q/Ka5/UWr7yAtwJa9T9ePGI+85uUy
         dBXwFrrbcXNOEwz0SLAsouhu7x45i5G3ZyanfAEGXc51OClNA2X0T6MJGrXT7vjtlRvP
         RuJA==
X-Forwarded-Encrypted: i=1; AJvYcCWPBq9tG6dilcXSkLHuFpDp/FAk8cz3hPKqwOUilXoVKOFrYQCpJhBlLefd7K3Cl0d+ILWhkDGmGA==@kvack.org
X-Gm-Message-State: AOJu0Yxaop5O4dXoHlFOsp484FjK1ZtM0QPgetEt/q3AqB3eBJ1SWGf3
	+qXEhIOb+C2cdJQkt043cAv+EMl0tR2I5SrTImy/bpax6Oq4rI6CdrXC1/tvDUOQvvb4WnMTth1
	dh6Zjq8bIdYs9FE0in2nAjFSrix5I6gUpOnW0OWYKrA==
X-Gm-Gg: ASbGncvFS9aiOU+aRxBb+jzGHuifnEAqEylpMuwKYAAP6ZNIS/0mGEk6GMFhuSb2767
	Npf8uFmlfwCLrzEEReMYXKxu4R2Q8sk6X5yP3WZsyaKEHwXser/+IK//xdMnABhZeu43L4FYkh4
	Mpn3zxwpik6Yc2Pcz0az2IBVYE0gCHmJ9RDX10Y2hyLUWxv0f01hx708sWfCs/98/Pzt8fVlhEy
	JkA35VQg0nXgrCoLPU5vI/1AXoaOwHRjPc9a6YfLfYOQOnqO4yCtOo12jIOUQGpdmub
X-Google-Smtp-Source: AGHT+IHb/TNH6HpXoXxdJqBqtls7NiUE5U9WcaIN1X3bEaIYHVHMwMKVOTZ0kii/oe8jLFgQnVtKbwI5uYAd2wY8FI4=
X-Received: by 2002:a05:6402:20d1:10b0:640:f8a7:aa25 with SMTP id
 4fb4d7f45d1cf-64555d0426fmr2711637a12.30.1763760682926; Fri, 21 Nov 2025
 13:31:22 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-5-pasha.tatashin@soleen.com> <mafs08qfz1h3c.fsf@kernel.org>
In-Reply-To: <mafs08qfz1h3c.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 21 Nov 2025 16:30:46 -0500
X-Gm-Features: AWmQ_bmySwNVArPJNxXTzBmV6LhGk1Wdy9I8BgPPnIaZuGaVx8wlezdZ8VKPhXs
Message-ID: <CA+CK2bDSSJhjx8fH1rsb3unS099pKWze-=WX1B2ZnE0LCMXUAw@mail.gmail.com>
Subject: Re: [PATCH v6 04/20] liveupdate: luo_session: add sessions support
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CA1DCC001C
X-Stat-Signature: xofx8mrqo5jjywhjetyykuc4qb6pi8g1
X-HE-Tag: 1763760684-751324
X-HE-Meta: U2FsdGVkX19q8Op0UAmLTZWJzr3k/vgQiOPPazyFE8M1LuB2enSU1sVT73w9cS2yDdsFtXX+k/vh/+mIONkhWiRIhx87ZVvoLzVvQERC4NJOAC5cj0fQLicm+B0c/m/0oDHYUP8Te87xTl6CitLNcbPyEB4csaBwBXwxQZrdJ+4zeFOS4YWck3LLd49Wh4ECvlMChp5D6hXbSV0vTiviJyDbo9Nju8vIXYUbbXl2rtJEz2FFS8bfYkR+iRPoojAgO/nZQ8KrEsdjb9gCKav3yCXIDv9U3AkfcXyDboFQa8MS8TmOlc2FrNaHUM3xiTkMTSAsfz8sp1RxUvLcr1C9L964FqpK6cTy9Xma8c6lC0WHM4AF85Nll9/oLRxmpqHIkVkZxLzBsxg40D0hrLas89QRDDPHjkVisUpbVQa6nzSTjWUWEzJH8529LgxmmChWA0Osdi1bnMYX91fhPQI4dQJVj38P8D/i1iIj28bmUyLfynVjncsl1Q0EZh8CE11Vk4UJH7E1Hd45qRa/X1unNUHWw/oxGdCPB+JRG+ybxFgE37eRdgvR/2NV1H8lg+z7Xnl6sBbJfMhyklHqG+u1AEa3mq+X94ifW+MfCpiy4zdY3qU+hHU9JOcer9hYVNT4f4euLh/IlhoJpac9gWr09cpSDQPd0HkazKpcApD2H3EfYr3UhJRRO6LoilD279DsfTYPrs35EoS6WY5WuF+cnAZjaOyLstQSkgd4arY1dojt/VVHPUHjG39gPYmjsIe/QjvZxnNJmdx0bxob7rQBRtyQmp+FvTq8zzfi05Lcgs5ZxBjeXhDEKOg+seXjZYDJ+fMp+4Cn2Y/4myiyZA6TkKQSTkakNl+6Zgsj8Nsz2ye5NysZ/zLlhBYAtP/aje1dbYvlFJUrKYUklY70grCxgqW0lYC/6hIF9yc0zB7uqcwrrf3FIx+wFYTliLxOuAmIFhbBhJuulpyYwck93aa
 JdF55Esf
 vdPgXApJ8IiwMjGbRMJo4sjRFSYBGbwSmUIb1zb8qHllAM9OrgGLa3yBcpJg+WnRYE9eiyy3FrobipJ3NwZhrBNPwYh+8CUD84MFKBa4PjjDxkpxMWU6x0Vyd5If5dsJa/6p56yDfhAaA8feczXnzaOZW5FhGta4+V0B2UOTwPOO119h3DsLonewwW4DqifgMifS4okRoNMIKJPULPPqc5NjKHZaY4sERI4nivjchGadgIIS4jJz729+irEa9CnOUzS96Hkwad2/GJzuKKwVaUdyc18Fj/c9wSoX4MfcONT5+QkoLLBsYbkvpBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  /*
> >   * The LUO FDT hooks all LUO state for sessions, fds, etc.
> > - * In the root it allso carries "liveupdate-number" 64-bit property that
> > + * In the root it also carries "liveupdate-number" 64-bit property that
>
> Nit: This needs a bit of patch massaging. Patch 2 added the typo, and
> this patch fixes it. It would be better to just update patch 2.

Yeap, this is fixed.


> > + * This structure is located at the beginning of a contiguous block of
> > + * physical memory preserved across the kexec. It provides the necessary
> > + * metadata to interpret the array of session entries that follow.
> > + */
> > +struct luo_session_header_ser {
> > +     u64 pgcnt;
>
> Why do you need pgcnt here? Can't the size be inferred from count? And
> since you use contiguous memory block, the folio will know its page
> count anyway, right? The less we have in the ABI the better IMO.

Right, I had pgnct because my allocators were using size as an
argument, but we removed that, so pgcnt can also be removed.

> Same for other structures below.
>
> > +     u64 count;
> > +} __packed;
> > +
> > +/**
> > + * struct luo_session_ser - Represents the serialized metadata for a LUO session.
> > + * @name:    The unique name of the session, copied from the `luo_session`
> > + *           structure.
> > + * @files:   The physical address of a contiguous memory block that holds
> > + *           the serialized state of files.
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
> > + */
> > +struct luo_session_ser {
> > +     char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> > +     u64 files;
> > +     u64 pgcnt;
> > +     u64 count;
> > +} __packed;
> > +
> >  #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
> [...]
> > +/* Create a "struct file" for session */
> > +static int luo_session_getfile(struct luo_session *session, struct file **filep)
> > +{
> > +     char name_buf[128];
> > +     struct file *file;
> > +
> > +     guard(mutex)(&session->mutex);
> > +     snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
> > +     file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
>
> Nit: You can return the file directly and get rid of filep.

I prefer returning error here.

>
> > +     if (IS_ERR(file))
> > +             return PTR_ERR(file);
> > +
> > +     *filep = file;
> > +
> > +     return 0;
> > +}
> [...]
> > +int __init luo_session_setup_outgoing(void *fdt_out)
> > +{
> > +     struct luo_session_header_ser *header_ser;
> > +     u64 header_ser_pa;
> > +     int err;
> > +
> > +     header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
>
> Nit: The naming is a bit confusing here. At first glance I thought this
> was just allocating the header, but it allocates the whole session
> serialization buffer.

I made it a little clearer by adding "outgoing_buffer" local variable,
and then assigning head_ser to this local variable.

> > +     if (IS_ERR(header_ser))
> > +             return PTR_ERR(header_ser);
> > +     header_ser_pa = virt_to_phys(header_ser);
> > +
> > +     err = fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
> > +     err |= fdt_property_string(fdt_out, "compatible",
> > +                                LUO_FDT_SESSION_COMPATIBLE);
> > +     err |= fdt_property(fdt_out, LUO_FDT_SESSION_HEADER, &header_ser_pa,
> > +                         sizeof(header_ser_pa));
> > +     err |= fdt_end_node(fdt_out);
> > +
> > +     if (err)
> > +             goto err_unpreserve;
> > +
> > +     header_ser->pgcnt = LUO_SESSION_PGCNT;
> > +     INIT_LIST_HEAD(&luo_session_global.outgoing.list);
> > +     init_rwsem(&luo_session_global.outgoing.rwsem);
> > +     luo_session_global.outgoing.header_ser = header_ser;
> > +     luo_session_global.outgoing.ser = (void *)(header_ser + 1);
> > +     luo_session_global.outgoing.active = true;
> > +
> > +     return 0;
> > +
> > +err_unpreserve:
> > +     kho_unpreserve_free(header_ser);
> > +     return err;
> > +}
> [...]
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
>
> Nit: it would be a bit simpler if LUO init always initialized this. And
> then luo_session_setup_incoming() can fill the list if it has any data.
> Slight reduction in code duplication and mental load.

These are now statically initialized.

>
> > +             return 0;
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
> > +
> > +             err = luo_session_insert(sh, session);
> > +             if (err) {
> > +                     luo_session_free(session);
> > +                     pr_warn("Failed to insert session [%s] %pe\n",
> > +                             session->name, ERR_PTR(err));
> > +                     return err;
> > +             }
> > +
> > +             session->count = sh->ser[i].count;
> > +             session->files = sh->ser[i].files ? phys_to_virt(sh->ser[i].files) : 0;
> > +             session->pgcnt = sh->ser[i].pgcnt;
> > +     }
> > +
> > +     kho_restore_free(sh->header_ser);
> > +     sh->header_ser = NULL;
> > +     sh->ser = NULL;
> > +
> > +     return 0;
> > +}
> [...]
>
> --
> Regards,
> Pratyush Yadav

Thanks!

Pasha

