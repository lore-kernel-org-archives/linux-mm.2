Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AFED3CCB1
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 05:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B906B0088; Thu, 15 Jan 2026 00:47:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5C86B0089; Thu, 15 Jan 2026 00:47:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEC66B008A; Thu, 15 Jan 2026 00:47:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD6C6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:47:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D405D160203
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:47:39 +0000 (UTC)
X-FDA: 84333116238.10.209D6A9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C867A0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:47:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IkmCyUgG;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768456058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7owkq+vNrkOnZ4Uf9xDVh685P9y4fUEQ3B6cYaXJRc=;
	b=VRrzQe2ZBpwXtGAgNGQtD0tXLAa9ItzoCA7CJHPgJBv6pLSI8aN9zxtYSS4wEknZvKavBS
	DU0PejJAlIVeGpcraCBEvf/6+Lt0zeizBRMt8FBXGuqvTNv9IXLwo6YmOgDTT5jdnlW0wX
	ECsmgLbDL4vly+Z/iwrMLdImlMX3drk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IkmCyUgG;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768456058; a=rsa-sha256;
	cv=pass;
	b=sDeQoNCayo6Q0aEy9ehfqhXsfPf4WAkc/Y/7jyHNQ+bEhqa3qWWtos8ZmbMUdx5Bv4I0C5
	uCFpezPgjHVBd0cgZXh1icNkkkXtg+frzMEj6vZn36JY86Rzs+EwMzo5NdBVMOMtwD2pXP
	HtSXOfGlscE5ED0jewzdEcgf7ABpKJ4=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5014b5d8551so259621cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:47:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768456057; cv=none;
        d=google.com; s=arc-20240605;
        b=akY49UDP2jzgHLQJ6d/0vuY6YMIyDYydBVOQieKyMnPT+ur9F1G2SJ0OeHv1dZVZ0D
         n/H1bVPzfktfJIHI+72YZtsV1rtb72bE6PuE1KoDvSs6JVAvF56DdgkkQMgimuLSnwdL
         rexj115n3AMKQktJV9uoQQTsA4uL8g/j+q5DKM4RRgzkQnSTwnPdkyUDRWS5d4BA53rr
         a5Ui2EUvXV48rmdurJKDurjbPPdDEtjKDK2b+XVxlOZCC2DVi1UcBA7XFtFrbV3w3d3o
         dcxzn6AJB52KolR0XcPvtE3nXHPZz66mtW6A5SMbwYumXGEv+Cgt2kOjbWKAbM+ylss0
         Ka6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D7owkq+vNrkOnZ4Uf9xDVh685P9y4fUEQ3B6cYaXJRc=;
        fh=kVIUoybH7vhLfPO9xfnWBmT1h50wS+nCARNOwosGHH0=;
        b=HPsNBM8ex0Tap1QfG9HItSniO5gMe+OlzpFA7PfZzu9dlEySrJQMLMp+oUWEt1ZIV1
         LuanM3M2bc524lZHGGzDdQwnQM5G75Tzh7c1kQT7uMC5DrgmonprUkI3vuYxy1QFIlDP
         2E86ryeQzQLeLgE82Vot7/JHKb8aLUNyyen1dKd/YXhNmoG5p/4TWIQ2v958layhkv/B
         MPVboKehXWJN65Lpd9LACCLSPoqet3j92PSKFGnWYoAfDOjPue+3EalaXn1sUNCAmSJZ
         JVty5UXTZFm91YXbdpxftM3Deqfo1alhek7Lbww3RmSllP4STsmBvIrC4rQQzfDR4/8n
         re9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768456057; x=1769060857; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D7owkq+vNrkOnZ4Uf9xDVh685P9y4fUEQ3B6cYaXJRc=;
        b=IkmCyUgGM1tYNDZ18j6J/qiAapAOwdPiwX40nZ+1px1c+/XEAItzwjrjhRFnj3wS9G
         v0FkKol2+jucqpX9szEthzc0ZWopz/4UYLyMz/ADuETPFMihKMWBmsYCEKSIsQlKcZ9S
         JgqNfkISeW9US1Nq7eg0llTiiC6TWrwpAa3y7Vee0nH5VXimWPXH8B8jostb0k97B9UW
         FLdSLPWtdTKrSfsmH0fLI+zPvaonxJy6xOSnKTxx7zS9pd7vK1jo9EEWOYQKkbBuiOGY
         7CBZYQJe3esZOacKpOS0lRkeCWQLqO7EYhJlfKL/xvHJXzEv+NUwT6StnaEJats2MR77
         OQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768456057; x=1769060857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D7owkq+vNrkOnZ4Uf9xDVh685P9y4fUEQ3B6cYaXJRc=;
        b=DSUoSdiOUTspucWTzZqF8L3GMI0n2EfRq5AKyOKt4r0fPS6585zqxYvc3o+uVkNDt9
         gJvVtDTB9l4B9oxkjVsV0bjCpKOrlSSaFXi6n6C+m8vbMjUarnJIlQz04uM1JNvyB0EJ
         Lux9rT93MfrbXrJahKxLI/32RKqcx6IJNUJBnDGjgQSoirEHtXlgpFahZ3YlFuL9H+z5
         Dqqj17jpRnxmFegVNcM7IfZ8zhDvVdjlVcsOwrAf46t595TXPqmfzQyXYObtoP8/zcf2
         99J13o2mEmOF2It3VPVLWBrHZpncIG8wd7PAesPToR6GyWmqZrPjvyJWJ3FYMUD0t3SH
         mmQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSLcEwsr18LdWzVjVfTHP/dqXqjI2mCVA1FDW5faRg5qdo8C9insI9Nv/ogINlh2lpOMRBmiblig==@kvack.org
X-Gm-Message-State: AOJu0Ywz0STA4waPcaYRqniJAjNCH2m4KV/5RldcHAAeFpXUteZ9gEzy
	Ai4HfDd5LSdoxVlwHQ/YlCiA7YWrT+gGuhqFZo5R+JkB5RPh6ez+VLIoli+pXZ4rVvsSKOs3kT5
	uFH7Ot5pr5z5cZUCWSZCcur3KCLnN94j3iZxdw9L/
X-Gm-Gg: AY/fxX5f++/wU25XKb0kqATJkmXtX3H3wx9T79oSPqLJaeYBec9sphDcY+YNP2P1nb9
	dyG6ZWnAsrINUhVs4ZufFtE2ZDaLmDOmOPNdiNFC1K9SKpsOZoJIhmH3pPqn65HssOpoYcAIO3Y
	y+73L44iYYryjUKOH/BzQmJquZeputKJ+9nYa2AngDfXbBgc+61ptoLrytnFHKJ64TBzORLt49g
	e+XjMDuKk8amdG4Mc/oRWittVB0bm+BJobVWCmcVEKbtefwwLz40/b4aYOCZf4/PIJwdA==
X-Received: by 2002:a05:622a:10b:b0:4ff:c109:6a4 with SMTP id
 d75a77b69052e-501debdf6bemr6888091cf.4.1768456056729; Wed, 14 Jan 2026
 21:47:36 -0800 (PST)
MIME-Version: 1.0
References: <20260115031536.164254-1-ranxiaokai627@163.com>
 <20260114192336.9d98f0330bfd6c8638762dd0@linux-foundation.org> <CAJuCfpEFZNwmpwfUqM45StJKPZG3s+qZpv8Vy2ohF6StsL4LGg@mail.gmail.com>
In-Reply-To: <CAJuCfpEFZNwmpwfUqM45StJKPZG3s+qZpv8Vy2ohF6StsL4LGg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 21:47:25 -0800
X-Gm-Features: AZwV_QgPLYk_wvubGcMzqYA4qu8cXgd98BFVN0miWrf_RQBG3AlBQbPQf-gYpd4
Message-ID: <CAJuCfpG=FsWar2jXXNAaRCWZf6UA8_Pw0QGAOTcf0=tbV_MeDg@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: fix rw permission issue when handling boot parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ranxiaokai627@163.com, kent.overstreet@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C867A0003
X-Stat-Signature: bs5r3co73ng3n45zuuaqm7mh6uoqip1r
X-HE-Tag: 1768456057-21264
X-HE-Meta: U2FsdGVkX1+x1I3CDjHqr7IXT7Djo09dRx3Ng7flXjpyOwHpPxlPqX40dQSkZMJ6yn2iYIDl7/Kvt+NsEYyyi18g+CtufGjTzqsQGXE1MJMy9e7TtWHGeyASxcr//28ACgwAslg9E2Oos4IfkuKAUKauCfqi5aelYieHPaVkSEtTlcJ1VVp1VkvRzbDepsKDUvx5ACLqlHVOAnJY59jQEPffaDiY5cNYHbyBTNPF0yRi94tDeXOoJMsIxfpmvc3F06Y/XGLiIaQF0mxapJkwlqtj0sJ3xDCimWRRMtl9Fws3ehazRfq27UoBnv1Ea3G/r2gSUf8p8Ddxajg0J1o6jG++pH6oXkIGKEeA361cz+xT52MjZOMLvklVnmqbxO0PCUkK0jGVS3Q2r04WT4VzA+e5d1G+wxrlI4qsPAIYcbz+OdN7osIzO/hEHoEWFUlY/kVUsDs4oCSIbDyO/sE2mBCWeToivxSG3rERM2O478vEpvZxGUiYQJhAYnQnJhloTONuODUgfHlS74fs0H8UA9fuDhPgwoz4j0KThC4fRb462s7+YajuIYFL6MZYr+Rz+ifHvo6xoFjbya9VHho9YL6TW3KfS45Lcs7c8v8RTCvL2eAerKMhiuy4/ntOt89tZmtVLr80LIKEHm3ruhbBaY77w3XQOCENriaWosH+JvwzTKpOVYOTD2Ha4HkQ+xReAH//Js8VyiHCuoCUd1PZgX7FlewwCkA769WyC12ypeE1/oeiyXoH4ORxcNTCKs1zbhigeb4QykXnbNKkcygMn8NDVuxXj3sh/BKv42LnTZWnfQ1SoxJ8QAkwDLS1RYl21wx6v5jmAQklODwWh+twzPGdwcRIsrRUnYSlSOIBFL+nhAhhsNvtyXbABfJ5mHcT7LJB9qiF2W6WkTewFhrbH3p0OHHRRk6LNZYSc/cT8d1uoUvjZIjG8Jx1pODCFdlB0L7q+XXwRdDhcvr2JQe
 8HzOaaRs
 tVcMwBk6UukAGlCMZkYTlKZtQnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 8:58=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Jan 14, 2026 at 7:23=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Thu, 15 Jan 2026 03:15:36 +0000 ranxiaokai627@163.com wrote:
> >
> > > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >
> > > Boot parameters prefixed with "sysctl." are processed
> > > during the final stage of system initialization via kernel_init()->
> > > do_sysctl_args(). When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> > > the sysctl.vm.mem_profiling entry is not writable and will cause
> > > a warning.
> >
> > This sounds strange.  Why would setting a Kconfig debug thing disable
> > alteration of a runtime control?
>
> If debug is enabled we don't want the users toggling profiling on and
> off because all allocations made while profiling is off will have no
> tags. If used later enables profiling and these allocations get freed,
> each one will prodice a warning about missing tag. We want to avoid
> that by disallowing to toggle this control at runtime when debugging
> is enabled.
>
> > Documentation/mm/allocation-profiling.rst provided no hint.
>
> True. I'll post a patch to add that limitation there with description why=
.

Documentation update is posted at
https://lore.kernel.org/all/20260115054557.2127777-1-surenb@google.com/

>
> >
> > > Before run_init_process(), system initialization executes in kernel
> > > thread context. Use current->mm to distinguish sysctl writes during
> > > do_sysctl_args() from user-space triggered ones.
> > >
> > > And when the proc_handler is from do_sysctl_args(), always return suc=
cess
> > > because the same value was already set by setup_early_mem_profiling()
> > > and this eliminates a permission denied warning.
> > >
> > > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > > Acked-by: Suren Baghdasaryan <surenb@google.com>
> > > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Should we backport it?
>
> I'm not sure a single boot time warning produced only in debug mode
> warrants backporting. Do you think we should do it anyway?

