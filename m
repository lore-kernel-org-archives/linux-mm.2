Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF77CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 19:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C526B0012; Sun, 23 Nov 2025 14:08:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4146E6B002D; Sun, 23 Nov 2025 14:08:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32AAB6B00A9; Sun, 23 Nov 2025 14:08:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9E46B0012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:08:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A50D8C0168
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:08:03 +0000 (UTC)
X-FDA: 84142806846.12.87E63B4
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id B97CCC0010
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:08:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y8j77ZGk;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763924881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9klKgJBevyIJ9UZxwySgKudasKfMx5MCjdCZws9FhVo=;
	b=6/Mm9fGS/MgbQmJ1fdQjUFUknOymZD77A/RMuqQ+tBBA0Vllm34rox2H4bQgDG29/Q6FTk
	DksEkRDSCuBB9yP8P1RlgNHbYWUV1PoR+n1t0aLtX4o8baQqDgl9Q2jo760hEBoSnIVXRl
	AKa7YkBkgz09K/NzE/bdeTi5Om8mWM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763924881; a=rsa-sha256;
	cv=none;
	b=mTxn1YC30oazeo5PdUyeUYnI1UcxzK7HF9FGdiE9E4krraed9L3m/IqNWGLB8dHd8pN0NO
	ePLQNvHrnUHBqQdP8X31Po0zK4quncGc7L0i7/F+wdvgpoCnb8beagmXrXcuuPhDg11lyx
	KOtjS9qXax09ehU5gqzzGoku3oNIY3Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y8j77ZGk;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so5876447a12.0
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763924880; x=1764529680; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9klKgJBevyIJ9UZxwySgKudasKfMx5MCjdCZws9FhVo=;
        b=Y8j77ZGkRLNo+AUaGl9C6chKl6Q0GWMkgxYr3sspMDeTs8C5dnEmJYK3NrcGQolMzs
         xtsJlJr74HPsZRbPlolLsNEWX4F17pRhgnsK6R+rOH7QJ9ttPEVNkB34cJolxtrUd7+5
         EUfDpD76JwBEyYLS5nSZnyZfARNbbvwk1SzOV4p7UrarE524Zyt9EfOmkT/W/nIZho0G
         Q7J2yt3UNIIJRYboZZZfQIf0x6H+wwtv57Rp0b3Q2XV2YhcETyTTC+B1IJkRLM5E2d4k
         eEajPo40yeBjBoeYmEOAgUSjmb/WnH2y4+kCHpKEoCgzbhHw4CYEAiVDVvAEL31rWnNj
         MC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763924880; x=1764529680;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9klKgJBevyIJ9UZxwySgKudasKfMx5MCjdCZws9FhVo=;
        b=PJo58z7s01/3AcmMZjSoMS1CuKH5PfCPk4M9OwLF4Ry4VRo6j21E+QMr6U+AJxzt6i
         sBZ5UEOwQO4Kph6hF5RDfUg4W5LPlEgg49sNFVO/BHBkkyVX+7Dw+Uhn/ueTS2YrO1eT
         Tfrb4Tf68vdlkSHPM7NvT4lAeQsIGuNTsVB3nB23x0AVMIxfGG7FgRv9nNQK+qMiDOp0
         iuW+fQELcnkCoFrtkvBqvzoVxtsI7muwyvtiMZwpBeiralF0Nm3UyZrUBzg45Idqc4lD
         HSWb3gqfMJZ33U4vHJ4NU8WsnRE8ubKJQTC3tpFZktF++l4p2dO+NlCq6F7xvqoFg6W7
         BTtA==
X-Forwarded-Encrypted: i=1; AJvYcCWo1xsQ4MIpUwrvdHN/D19zxMmSDP1DRIv8MZO3tllFm/9vkxXCk4OLsNnDJcW6pqO72auFwl5ueg==@kvack.org
X-Gm-Message-State: AOJu0YweTScOgfBdC9uCPWHxWIkqUTtoktzPG/qrJlVGDRTCCNuyeyjZ
	2VnfQSuiE7Ajvhr5eWLPiO1IhbiszEka9KDSF+kSwyuEnJxKmuL441yTKtVci6qleozOG+FxYGT
	1TRtj9gE8/4aW2qcaFvhX2YqJXAlhZ31y44gf77Z6bQ==
X-Gm-Gg: ASbGncvm1nTJLA6pSBSD/TglJAZCyxYCEnPtxBMXkEml9bkKRnNv4geO+dG7CLEPYEH
	orD4sb8t4ynRM/J3tiX2MpopNO/tndgSBVzkyNkCRq+cMHEosAGswCLK9CjguOYuv4dWwrb6H8T
	bq0RfoUNLC6GCJEbRji2zTI80fPq5xllqZK1OMDZq7WcS0NSJj6yCAEy+jrGU1qzKHXGjQfasLg
	4jRCm7iuMarVZBm9cu+hAOTEoa2itak66XPzEPAc9Avu305SXD5+YpS3AWqBmWFWO5U
X-Google-Smtp-Source: AGHT+IFOPKZqtlSeAujqMHhI3nlxfVlasLRItw5Gn5lA8EUX2qTjBZTvohylQJZ+Rg9P0N2YJ5gu38vULtGu6oqEXEk=
X-Received: by 2002:a05:6402:27d0:b0:640:ea4b:6a87 with SMTP id
 4fb4d7f45d1cf-645546a47bfmr9166511a12.30.1763924879937; Sun, 23 Nov 2025
 11:07:59 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-5-pasha.tatashin@soleen.com> <aSMXM8ayzV2kx6Ws@kernel.org>
In-Reply-To: <aSMXM8ayzV2kx6Ws@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 14:07:24 -0500
X-Gm-Features: AWmQ_bmHjB6aEBO9sova9XMvan8ygXuOf4QeVdvSaQktHxLRV6AQzJ8ITGz3YWc
Message-ID: <CA+CK2bDJhdTA_3hqqZtFS2hN59YfVYrG5S2WRNKNAJws-f9-gg@mail.gmail.com>
Subject: Re: [PATCH v7 04/22] liveupdate: luo_session: add sessions support
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
X-Stat-Signature: nax8sqrukbftjehex9ipc9s3oc4ysq14
X-Rspam-User: 
X-Rspamd-Queue-Id: B97CCC0010
X-Rspamd-Server: rspam01
X-HE-Tag: 1763924881-472520
X-HE-Meta: U2FsdGVkX18lb0qAwvD/qD+rulcYHLCr9YtwipgLn+hZIf8cUdFMhYY6QJNHA06oZqo4T4CfZndagLo6XR9ytbKz2E3rqQO5FYcvPSK4HNQ7RdQFq+/7Am43nJ0oi+gPkCxHP01aF8umefb9igEOKopOpClWe9LDBpx5bc66fkv2tGqKSEG53TtnzmyCQ+61B4bHBvJoYb+9Szx0l3M6bDheN8PX51sPPk0JAf0f4wBCu1nEDllSt/LhrfenefLW/SRFVWJmlqVYMB3ALgDRlframOKvMnQsqlM3eLt4QGwAe7v02bWzQ+yGz7RdwGzXASdcHGStUsRgy6Whu/5kfEV/F+pJrn5igCYFp8bkJG9+Yc4stxGQvgVLStzspO4lHSI2yGjqJ9hqysyKPMM8TyzE91GPXIK99HhTIsA/xrrXiuDdLZrtBNrRKmBUNF7qcUjHJZxv/SfcRgQ0yr4PLYpkUBcFmvKcPo98i2yjI7QMMXtgeYLMrDeDzlLFcMdo6VcGxMs62TfY9IKLz+MItd+OQkJIV4VC7/jzTV+T9k7N27KZGfxQjsUZ57qWs3n0W0hO/DnqPzLwDAg8w5jFAhdp42U13fezgHN67ymJAOY4zmxP9mGNLYNRISthmhqW0rFIcYLUGpNZzbbHiKre6272Sze4frSfWi/zSVeOxQAsJJe97tF3HicqAtfDu4U4ZHAPi3Qe/SbdBlX+V6RX0a36vszD/jA4NpFeGD25OoTuEV/fdaSD/HfaLPEhK9rygY7X2tzJABjs1C25lPxCMzNHavRgcYh5vFAQZYYcvJeKLiJ3/UHYaBJmX5fSePN5cuNiUAp0z2aRoHbRalJkoVy+DxQbDUolmO3lNAuK/wqe+aI5pBA372wBKcKEaCM0e1xYKmMDDqKuCirBewnkMrAN/7aL3Uy9lSv0ZwYUXiWXbIXdwpAAU+R4xEWfPNJ2LZF8ZVrRr5sGS7r9igs
 pvBeHgwj
 PE/Mb5YHfON759/D9q5EjZehHJw491rERR6F7uidwkJOBRFgbe6TGa8WsafPCXVxaoLONPFTwgsTUV0yYKuZ6AVoWK4nohSar5ohYworsohvg7rNjXiokUfH+movdse7f7yVHaMQPi18gUt0zSH1pI8XnfeWtY0B2wg/mH3aibtWvR2v3llcdwYdbTJ3xBlY1AEG5F3/LnCHs5bRR4dQDSBI6KB02WwXRSbGncv+0MFSvr06OXQcqQ9rcQ0XAAGpwSGqw2yATArHLRByNULzFSV/slXGbyp19Flx92tj7Qhpc/ViGo+CPpR6wotDlrzPnzfulc2Z/B3S/GHA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +     outgoing_buffer = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
> > +     if (IS_ERR(outgoing_buffer))
> > +             return PTR_ERR(header_ser);
>
> Should be
>                 return PTR_ERR(outgoing_buffer);

Thanks, fixed!

>
> Or, preferably, just drop outgoing_buffer and use header_ser everywhere.
>
> > +     header_ser = outgoing_buffer;
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
>
> ...
>
> > +int luo_session_deserialize(void)
> > +{
> > +     struct luo_session_header *sh = &luo_session_global.incoming;
> > +     static bool is_deserialized;
> > +     static int err;
> > +
> > +     /* If has been deserialized, always return the same error code */
> > +     if (is_deserialized)
> > +             return err;
>
> is_deserialized and err are uninitialized here.

These are global local variables. They are automatically initialized
to zero, and it is preferred in Linux source code to not set them to
zero.

> > +
> > +     is_deserialized = true;
> > +     if (!sh->active)
> > +             return 0;
> > +
>
> ...
>
> > +/**
> > + * luo_session_quiesce - Ensure no active sessions exist and lock session lists.
> > + *
> > + * Acquires exclusive write locks on both incoming and outgoing session lists.
> > + * It then validates no sessions exist in either list.
> > + *
> > + * This mechanism is used during file handler un/registration to ensure that no
> > + * sessions are currently using the handler, and no new sessions can be created
> > + * while un/registration is in progress.
>
> It makes sense to add something like this comment from luo_file.c here as well:
>
>          * This prevents registering new handlers while sessions are active or
>          * while deserialization is in progress.

Done

>
> > + *
> > + * Return:
> > + * true  - System is quiescent (0 sessions) and locked.
> > + * false - Active sessions exist. The locks are released internally.
> > + */
>
> With those addressed:
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
>
> --
> Sincerely yours,
> Mike.

