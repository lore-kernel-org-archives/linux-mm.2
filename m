Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A597CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 18:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D395E8E000F; Mon,  6 Oct 2025 14:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14CE8E0002; Mon,  6 Oct 2025 14:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26B28E000F; Mon,  6 Oct 2025 14:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B28568E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:03:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 527D21606DF
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:03:33 +0000 (UTC)
X-FDA: 83968461906.15.89B10CD
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 603C114000B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:03:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LfqPpyaZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759773811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvwmvZY5I363zl2hxXSo3p16V2l855H51CmL0I5zxCc=;
	b=sdbrqrRDx9hpGdN1or1YOsWqPwo5SH6NmNAGHGTPbLujh7Csr3EHx+fIR7QKyJ5NL19t+b
	HLD0OrNB2xf5fTEBXYH7wujWP1GXfOMdaYApF6Wu+KecHcjY7vbq8qXnkdZEe8cgw3tvjq
	8mVNx2ALqlvEj1X8p6lpD2T/cO3GJPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759773811; a=rsa-sha256;
	cv=none;
	b=wJjXtwdp96yz7jTpADEPuY7H4oIPlpvxCF22zGSgtJ4On3BuLkTEgdBwrC/4b6ypjUzH5I
	odt0R+uCBh9PAnepSJa4388JumlJpyVNqfv6+MghL72VuZZcKHhJHjxy3KMqG7yKyn/+FO
	GsH3psA3jEKEInJ/o9RQy9Hkx2wv99M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LfqPpyaZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e6d9573c2aso12570451cf.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 11:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759773810; x=1760378610; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvwmvZY5I363zl2hxXSo3p16V2l855H51CmL0I5zxCc=;
        b=LfqPpyaZ8CAOV3JfW3svpVdcXgg8RhMj2TosamdCIJDDWcFr66dMGOYaustLPKduhQ
         1aXNLB1tJJj9azQQ3h9g2j5mzi8fRzNjAKr0SzxipcPI8/AhUHvih2faEO1k96Q2AbaT
         rAEINK33zinEoAw+zEwfGe2s1NG68RdmzHqa/XY7sWbjSrAozUSNaSuBmReqOQj34LYt
         hMWlB4PzmiuRwZRZLuHbWN+7h1yW3YgZJWgxzQ6/EB0jXHKQnvEC0Htq9vvNc2zfezk0
         xab65Fsf/uf+ujNMDPQIuJu9bhnC4q7ZpoqEFRMGCZuqJn4yryRArdUyemwE9vhKRtm+
         NWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759773810; x=1760378610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LvwmvZY5I363zl2hxXSo3p16V2l855H51CmL0I5zxCc=;
        b=Zfw/TzyX+8XXJUVfaeqQhnArK/aQ7Bxo4cHi2FlMj7Wy1JOPSrkvn2pmk5SiJcxPl5
         WdyD9yz/d4gbX33DECA9WqjoKpdz2fdr3T9C3ezRd3CjaACsSZWp4J5EiD9hwoQ8jch9
         mKvYSzs/VzAMr9kcBYOwgqjEYJqywLYqIH9nMiWdFHMuE5IbB3goW9e7lkJNZo10SuEw
         FTOCga7LdQUhqVUpEVakqMS4BaCzQRDqCvuLBNmRHtTdHmI3oxwxBngOTBqf7hTZZZam
         soiVqMwwon2pnwu9z8VSCKD+w2df6Lifexf11zwjByRo4UZFIml9a3SjlEDXoWVVZjdV
         melw==
X-Forwarded-Encrypted: i=1; AJvYcCWj1mqW/JtdUtXGJb0zibuOSYxIcYdUsV6hdZf5Tr/wH5DJaQlUXZKKMkvhMdujmlbpCoDT//m49A==@kvack.org
X-Gm-Message-State: AOJu0YwlWc0PathL4XKnOECn7jzU277zML3jR+XyOjswDtk1sKTJ/neU
	+0oikSX1/kDmeDnDxTZ8cvU79mb4uJNStFB8/BmfbrsLMTT6ivm5EX17lFz7sPw3bIQxVMZgYpv
	SNQhvRlpo3QJ2SR9abKnuyIebau58qeNSPQ+A9bkIeQ==
X-Gm-Gg: ASbGncu7+ZFIhG9GN2nAUUc0SQxjClUc0VoeNNauURgfp9ysCcvlbZb2M+DpnGvFUMn
	echNzbxPMjJuAr/FuvqxR3QCplasXOFqzb2OEEUiQcAkRpcBWkZrcWLZPmWyV5Vtmw9YnzA8Yro
	88ESPxIFwK6GGHFENEJvab6ZU/eiNVYWWSCn+SxCee3AHjv5313NVLH35skqqhg9WlMmayMxNs8
	4hdP68UmyQoGg5BUeJ7bIkrJsmnSm3u8pzXjXA=
X-Google-Smtp-Source: AGHT+IEVZfCkL4v+Tnkl5nUWA3GDanDfXIyCKp31DpQy1v3t8oAJmzi9nP3PButZfFc5VJpBDaeo1ldCgKUCHIfwIPE=
X-Received: by 2002:a05:622a:1a87:b0:4df:1196:f570 with SMTP id
 d75a77b69052e-4e576b09389mr190614081cf.53.1759773810132; Mon, 06 Oct 2025
 11:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-3-pasha.tatashin@soleen.com> <mafs07bx8ouva.fsf@kernel.org>
In-Reply-To: <mafs07bx8ouva.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 6 Oct 2025 14:02:53 -0400
X-Gm-Features: AS18NWCL5ohjgHwfiII61tAev4bzSNa8Vs80Sb--F-ZT325ugyMZfqAlQjXZbCY
Message-ID: <CA+CK2bCN-__524n+2wti+m8K6JntCudsR1--cFH6cW9CTXnmiA@mail.gmail.com>
Subject: Re: [PATCH v4 02/30] kho: make debugfs interface optional
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
X-Rspamd-Queue-Id: 603C114000B
X-Rspamd-Server: rspam02
X-Stat-Signature: 5ws49tkwa5wx3pwazbcsxo3481oszbob
X-HE-Tag: 1759773811-802180
X-HE-Meta: U2FsdGVkX1/fCOCDpz82HSrW0I/MBil0sj0/F9wiZO2wYYUO68Q+gyyZXdKBjf66dHPWsEsoUna4JcZsRoV0j53EL9PXFeZwh58hGJ5cyLYrdyzdcXiTOopvid4eT7uaEZrEEL/DrbXwR2iqdPDs7Zkg0qnejN7JK5NUmeFYShvOdUTfdyXAZyuiUmDq9uT6546najaPrH48c4H9OSMCDUGrLI95csBkE8uZycWaZ1qRzeaKqTsWL1aovzb15EasNjWhcAJ9SMqxlZeQmxci+IQ6Mwo5GQQZQzGQ1Y6D6ZPodfsrM/0i5uOsPxuu+bAZblSP87jIpc9ONstE6u11KyuuhYJrwh/ncVGgMkbKLY3xZMa3b9isuEcQCZ4j5FjF7TWJYi8iq6FffpLw9+3jz+YPJ58esw/K+vafYYAOJL0sTrgWmFQ42HCa9mUy8IPYpUP0DAF7oZlhqnwTQNWOacPn4zL0GQdPQj9iX96/FXGENdU/m3iqSwXxv+R4GXVQPgDCh2NMVr1TfO1oNlTXlW4ZabQfxLIKtYnySYqD7HxIKvFDUpXXSdiW0ZJM/WoUN2fQ5m60eZ6zzIy7HhOEOE77bx6+BkybS/PvDyFTOLcCy5jjM5nzcKhPh9szQUrDgCf2ghjcJtEq6En4zuPNlOnP8CAeE9ba7B9bydmG/lhVRxhSqFDIPOhHrrKYz9U/6UCFRWy7ZKfZaEWHk4gvQ9GhMqI19F5039EFheqK1FojfqrjYGtmFH+N9bEoAmN5r8Pv6r3fEIfQpVb29paYhGq+cmOy1tTyF+0Cshp4DGyMAVI1wUko5nXn8QV9dr1uPGRh/AroKNEbje3gUFsey+R9IETRVdsUC0WW2lYggSM68LAzvxcOk2AEyfPDHS2MSEpFva4a9MWcsS8E6aDaXro/ZML4ln9nOEQMmSMWZmAp/yumegEBJzykh9wUiju0UHgw1GLUaXQwrsVn1Ix
 v1uEedWR
 SfvxMUoXY+jJxTzkXwZG/4tilA5kkpxe5Y/Aj9Epk25weJcKrCVrNTr23Q+cE3Yl1pQFrIFklfL2k/OakcdaislF05j06FwT4gVobBKdruHVqzv5snwxigL8OSN7kVb1MvDpSIxzhX5hu0UZjePRrHh2uN7VX9rnifnDMeU0H0J0WJKHTKPpdDw8T3tlvoBngxYBGuq+DqCVbKSxOiIusfp7Y5CZ6qaaFbVB3wBKpDBP+r5ZN68yxK3pq8W+kEdCtutsxV20/Gh/9SgiJM4fCB1EEuwuPn+A7QSCRPVWxG00b/aUThQx9mtvMZLFpTYTAxeV9Rzq8Cj10lfn3k+ybaeANDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 12:31=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>
> > Currently, KHO is controlled via debugfs interface, but once LUO is
> > introduced, it can control KHO, and the debug interface becomes
> > optional.
> >
> > Add a separate config CONFIG_KEXEC_HANDOVER_DEBUG that enables
> > the debugfs interface, and allows to inspect the tree.
> >
> > Move all debugfs related code to a new file to keep the .c files
> > clear of ifdefs.
> >
> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  MAINTAINERS                      |   3 +-
> >  kernel/Kconfig.kexec             |  10 ++
> >  kernel/Makefile                  |   1 +
> >  kernel/kexec_handover.c          | 255 +++++--------------------------
> >  kernel/kexec_handover_debug.c    | 218 ++++++++++++++++++++++++++
> >  kernel/kexec_handover_internal.h |  44 ++++++
> >  6 files changed, 311 insertions(+), 220 deletions(-)
> >  create mode 100644 kernel/kexec_handover_debug.c
> >  create mode 100644 kernel/kexec_handover_internal.h
> >
> [...]
> > --- a/kernel/Kconfig.kexec
> > +++ b/kernel/Kconfig.kexec
> > @@ -109,6 +109,16 @@ config KEXEC_HANDOVER
> >         to keep data or state alive across the kexec. For this to work,
> >         both source and target kernels need to have this option enabled=
.
> >
> > +config KEXEC_HANDOVER_DEBUG
>
> Nit: can we call it KEXEC_HANDOVER_DEBUGFS instead? I think we would
> like to add a KEXEC_HANDOVER_DEBUG at some point to control debug
> asserts for KHO, and the naming would get confusing. And renaming config
> symbols is kind of a pain.

Done.

>
> > +     bool "kexec handover debug interface"
> > +     depends on KEXEC_HANDOVER
> > +     depends on DEBUG_FS
> > +     help
> > +       Allow to control kexec handover device tree via debugfs
> > +       interface, i.e. finalize the state or aborting the finalization=
.
> > +       Also, enables inspecting the KHO fdt trees with the debugfs bin=
ary
> > +       blobs.
> > +
> [...]
>
> --
> Regards,
> Pratyush Yadav

