Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD12BCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 21:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D206B00C7; Tue,  9 Jun 2026 17:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEEA26B00C9; Tue,  9 Jun 2026 17:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB61F6B00CA; Tue,  9 Jun 2026 17:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B96336B00C7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:54:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14C9C1207F5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:54:59 +0000 (UTC)
X-FDA: 84861729918.14.0899453
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id EC81DC000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:54:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=axZme7aM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781042097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jckXv3l+sB3MjuXWZIb+AffGQN0g5BrVOlnrbi+mZxQ=;
	b=lc01prH21gcPA1dq0LMap+sUgPy2OiUg7/yBh1qUHZwEl/JE+XNRDoaA382ffbqZYCNt+g
	NaIsS51JGBnMOWFy8bWDFGH2KbMptYQ8zs5LDSDK7UYvwfcd+7AbJcrnTQ3w7QElZDS4N1
	X4wOeMuisF5eAIzUI8vYMJ9XdzLd7PY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=axZme7aM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781042097;
	b=el3TT7SEgdMQSqskxemFBA7yJGmAgwY+ax5L11lQFIPq6IWh4ehikRX0W3NdEbb3LSUn04
	CtRWmk+6rJnoN4ZTMGucOMhSGXuBfcW6GNFU/YT7bmJfasHoadneTY3Ch272LqkSQ4Ji9/
	7tF1RwixfoUyjRc5aF0P4SKLR9xlxsw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0b1a48855so10195ad.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 14:54:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781042096; cv=none;
        d=google.com; s=arc-20240605;
        b=JTK4P2BCAicuQ3/Q541aJXxE0cxe7OYgL9H4DY3Stcx83yMwlEt8rXGxcCCvBFjq4i
         uyRTCsSYbIPAXeUDXdjUtyrCO5RZ8vjcHbroOgXKl7sNL/MWbQ3Y4ZfAZIASaWiOHHfM
         LKklfw4FA3c2EN47jY42oZHyfBF/PFPCTqduHBWgpAFTjcP84IZ+OiNW8jfoEg9ctfBC
         afX4Y/cGz2Ckmq/RjYfi5bBJZ9x04TNEcMIKL24QJcoM7ztYIkiPWSp1y2RyaHBbXFoF
         njU/IC16cZV7Dh3QnSqxP0NgvGFdVx7RV+BBdlmtP6VF2/lNyI1Uf/ob0O1sTdGdG7/a
         keGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jckXv3l+sB3MjuXWZIb+AffGQN0g5BrVOlnrbi+mZxQ=;
        fh=xjkSefJZJgKLWhcMxpRkTesaHQVCHuoF5/A1G1647R4=;
        b=kFqlinnf2wpzVMeOsS9ZmkXAI3iDnBOCcWrs8+jcecfbC5fIdYZ6UfDOQW91DaVmdG
         9pUJHNprGuvQtQrvE7te7Exlzzz2/kXElKT3OkPXVzMtJihHlXrl7adXIruj4eCftCmn
         dnKhp/8R5u91ZChaxbQHexSk/Zr/di6YuRG26NY/IvtKImjQo5GEYRNxNpe7vJK8IqM/
         cAiI1iM8ubYbXFd9SxkYpFDuf/yAW/49LS6u/UyV8JzLsRzkfnqnTQBHPK+hIbxitqWg
         f6o13rR3hxLDQ1xXC1J9YUcNMBSqg5g3kBOOY5jTQcgOUXIFf8pL3GC/iHzyIw+bEHBw
         eACQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781042096; x=1781646896; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jckXv3l+sB3MjuXWZIb+AffGQN0g5BrVOlnrbi+mZxQ=;
        b=axZme7aMCLzTD79i/kjZNI8um4oB9uktQoyWV8Pa5aU5kMahRPld9xGE8BI2Tsv7Ot
         baKNv6HHpdoS6aRa+DFD1Ba/Sk9T6RyNBaK7h4fAXDBvndSaJJwveWMpoWrcLjuw0EDj
         M/3lzXKziOuKpKASJWOV2Ep+zdAjVM/TRor1C+x8IktSXap/PgnxHJfBBO3G6Oq329du
         Fd3a/SPXYf4Vk0Q0jwsaolW+vl/ZALiGxpSabY/nvm6PzMwiAu59p3vHAM3I+f7C1MNe
         HTngt6Q8jEYMEcxtFCX2BJKNUuasNsOrRqxnhGc18hgCQON0yvhkyLGlf3uaerMjo+lb
         IOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781042096; x=1781646896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jckXv3l+sB3MjuXWZIb+AffGQN0g5BrVOlnrbi+mZxQ=;
        b=A3iB7LaJHHLkGKBnWzph+Gdz3f06Dqvl7yilZYRvPM5ZDh+bxHxlHLXAFBtWkfjXN+
         UCpxAyXokQbVZinmAkU/9ZImLgCvPZYsDE8y7koaHyVfcVr7G4c7sefOhUl8AdaloeX/
         0l9LZLHDa5ONz5cxkZYpOZVWzirKklsn/wenbi13RMle5DHyCuCxJ5sOsQ2rDco43FxS
         018kalAZ3OvAO98glUbKWz6Zv7Pb+Lqt1onYJRm5eKctAQeP8L8/A1qGJ+o9e9TP0EF7
         z7ZKLvSqSdW66DY3asf7tin1qeNrHbqs3SN9EItpqjIGPITyvd3RLkFQN0jmpX6BPX0B
         4+xQ==
X-Forwarded-Encrypted: i=1; AFNElJ+DkPFk5/k5sX9L8tnfH4l91I41zGoXpGAHHr/BPTO49khJUsfIPE8M1+xtHnG4Ky/Q5Qh3MC1EVQ==@kvack.org
X-Gm-Message-State: AOJu0YwC2VBwnIk8WkJxzLTDeB+XJZ7yW9hKI9bqO8hmXbNQxJEgwnb3
	oNxJAzAWbq9bHrqeBpJfogGR2S1KuVDvrbK+RupIBqNnk4KvFrOlWgsTfxjLIBNEdnjL7ZJ6mqx
	7aDnsuL+gykAl3kQ094XBkkCxhLOHsUnpuh6/kT/0
X-Gm-Gg: Acq92OGP7BjV+waZzEFcZ8EOhI+UNYTOHQoOuxjh0ZOwK2/qEtMJJ6qJVxW/uF5/753
	Le0yhYNllTcUu8u3gDi604PPPEGFz4mOpWYmEam+4bbB3Hu1nyicNOJ0ISP0Fz6L8bETPKrNUAf
	xW29tbjEFN4EgE6mf9KBmJ0ihCrmOAguCfoxY4LgLcic0cDzEamMT73aCXmv1JnHLRc+XyfgmQe
	6gtdv1rSGpNCMYNOuNmKrJtKjn7LJo36LSe/SyfYMv/1r7P6UdNZiST8VNe7CzVNA9KsEnduDas
	22Vlc3EQZLj/BvcGApwEWzpintC216gxqi/I5B9vJCeMgw6t
X-Received: by 2002:a17:902:ebca:b0:2bf:139c:dcf3 with SMTP id
 d9443c01a7336-2c1ebfcecdamr7819945ad.19.1781042094955; Tue, 09 Jun 2026
 14:54:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <0e91fdd3a88dbe5220d15c4c8ff7b8f66e86af7c.1780701922.git.abhishekbapat@google.com>
 <41a7ebb9-1113-4f13-abbf-6f55d99d62f3@linux.dev> <CAL41Mv7jOJ0rtAEDZP2DEGa5d1GfTbK=DXg8k1BL5qjFuQjNuA@mail.gmail.com>
 <2b7fa423-c721-4157-96ba-93bee5010044@linux.dev> <CAL41Mv5ZzuVRy5cjp_Ozn=9QCpCe1mFS36o25Z1dnbYCvNs9+Q@mail.gmail.com>
In-Reply-To: <CAL41Mv5ZzuVRy5cjp_Ozn=9QCpCe1mFS36o25Z1dnbYCvNs9+Q@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 9 Jun 2026 14:54:42 -0700
X-Gm-Features: AVVi8CfQlQG3NX7xET8VBuYCXP1cOdkuN3Pt-zoAzCmaNuMFxaRypPiYGkZ2BuI
Message-ID: <CAL41Mv6XfbSMUvdU9btrtsh-HXejCH=HZmCuTL1gKRe2XAPvpQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EC81DC000C
X-Rspam-User: 
X-Stat-Signature: ec6ob39esbew1zzmiqkhftndzx6xu896
X-Rspamd-Server: rspam09
X-HE-Tag: 1781042096-942773
X-HE-Meta: U2FsdGVkX1+osRmVx1ZKsfkmyLp5MqvOTcJ5vG5q7v1PvIeT3jXtMB63Td8TkrGxSwJbbU5wNXq+VArhpOu3T44LEnUQce9B1rWS6CWEqSMtM1cEtwZGrKwLDwjeruKmlgxTCHvAvPA6qLn/429u46VdN6T3LH1+rLiVAOR98yiNAlwrXi7DXAYv04EybGxt57WLveoP7OAmm+bocuNPwLNGKUbuNFj6jDLkTda9HrJ376Wh+HQceyaOQE8AznZK8p1HjKv7SzMZW6XvKHg4MtioWfVCEZ6R1hLeyjuatxQmeP3gq20dBiynPafuLG84X0cxc8xbLw7AW9X7fdQ43kfmm5YrP8d8WM/p/0/B2RNba6dBPgFWM+cyj8rpx7SFTA5pc893PTA2K/UeXB9qgzJKg5WOW08PdQQDh9BO9STV+ToDTA6IWThy4+ydjhz23OKCIZKNQgjctolPCMzWyXimbWwZc4+rhTFFqvc52w3J4VQk7vgCiXonUuDrEJCoH5ZRdJyupwUU9VBzIfSZ82DnUHXXX/A75RgykmSJuR9R26nt1ATrYwHYXXqol7t36hizvDx6PDlyuOATr7Zq/BOOWS/Im8Fdim4rUfZG6/qpIjkqiyornhDP7PIpV0GwQd6FTxDjUHiEcBo8Zg5xiCGyDH1r4Rju+4vKudXMoPbAh1Ij6EIefGFEHofOnG18nJ20qla95ydWXVQVwgfwfSDfV1dSJ+47Fe0E6AgwyQp0oyDY7YGb+c4OsNY6Ch3rlJNSkebc2Nuaxc4dUtAMISwJaX1R01oqjH5rKK5AuYJ2VDT1+cwN2P3JOyGjcr2tRz+slRJ6ibji8apTllSFEiVlKh5MFBBIMg1lyUPjzgNYeUB7DrvNVUrQvN6QpLdxc8jEcr1yy/NWxbPCn+KKmYm73T1yrDVV1NTRHwEokkRAAEl8dQEqe1Syta/0LGdOvWqkgCMDRA4G3YemK7K
 1z9J71Zp
 xXORGEllspBQGR9AOUNWPj0kEyJAkJ/Pr3CqBZTeww2Lh6CK9GhOU2RtNbXW53i1nmvnp3PG9NRSonDTfbD6r7N/publA9H/AAywZRTBThb1aOb3FxNR76ocsdamN9d9r8iNL5iyKJ0FcvN80G9TG+QhR61MLDVoRoOhL4yRIw/OWWifs853RC/xghORXXN/DRzEve5TIK76nUv3TJowp483z/GP7b2k1NY1Lu0nrINSBqTgjoTlCpiwGpFyv3eiai8ZoSGAjjJfR89lzKJ/KkIQuZPDk0jKk1yMJm4+HrUOoozu5csDSlPzawZFTBOzYutUinxma9fHS53c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 1:51=E2=80=AFPM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> On Mon, Jun 8, 2026 at 6:44=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Abhishek
> >
> >
> > On 2026/6/9 08:19, Abhishek Bapat wrote:
> > > On Sun, Jun 7, 2026 at 6:53=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrot=
e:
> > >> Hi Suren and Abhishek
> > >>
> > >>
> > >> Thanks for the new version.
> > >>
> > >>
> > >> On 2026/6/6 07:36, Abhishek Bapat wrote:
> > >>> From: Suren Baghdasaryan <surenb@google.com>
> > >>>
> > >>> Add the following ioctl commands for /proc/allocinfo file:
> > >>>
> > >>> ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be use=
d
> > >>> to check whether the file content has changed specifically due to m=
odule
> > >>> load/unload. Every time a module is loaded / unloaded, the returned
> > >>> value will be different. By comparing the identifier value at the
> > >>> beginning and at the end of the content retrieval operation, users =
can
> > >>> validate retrieved information for consistency.
> > >>>
> > >>> ALLOCINFO_IOC_GET_AT - gets the record at the specified position. T=
his
> > >>> is the position of a record in /proc/allocinfo.
> > >>>
> > >>> ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
> > >>> one. If no records were previously retrieved, returns the first
> > >>> record.
> > >>>
> > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > >>> ---
> > >>>    Documentation/mm/allocation-profiling.rst     |   5 +
> > >>>    .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> > >>>    MAINTAINERS                                   |   1 +
> > >>>    include/linux/codetag.h                       |   2 +
> > >>>    include/uapi/linux/alloc_tag.h                |  54 ++++
> > >>>    lib/alloc_tag.c                               | 232 ++++++++++++=
+++++-
> > >>>    lib/codetag.c                                 |  18 ++
> > >>>    7 files changed, 312 insertions(+), 2 deletions(-)
> > >>>    create mode 100644 include/uapi/linux/alloc_tag.h
> > >>>
> > >>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentat=
ion/mm/allocation-profiling.rst
> > >>> index 5389d241176a..c3a28467955f 100644
> > >>> --- a/Documentation/mm/allocation-profiling.rst
> > >>> +++ b/Documentation/mm/allocation-profiling.rst
> > >>> @@ -46,6 +46,11 @@ sysctl:
> > >>>    Runtime info:
> > >>>      /proc/allocinfo
> > >>>
> > >>> +  Profiling data can be retrieved either by reading `/proc/allocin=
fo` directly as
> > >>> +  text or programmatically via `ioctl()` calls defined in `<uapi/l=
inux/alloc_tag.h>`.
> > >>> +  The ioctl interface supports structured binary data extraction a=
s well as filtering
> > >>> +  by module name, function, file, line number, accuracy, or alloca=
tion size limits.
> > >>> +
> > >>>    Example output::
> > >>>
> > >>>      root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=3Di=
ec
> > >>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/D=
ocumentation/userspace-api/ioctl/ioctl-number.rst
> > >>> index 331223761fff..84f6808a8578 100644
> > >>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > >>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > >>> @@ -349,6 +349,8 @@ Code  Seq#    Include File                     =
                        Comments
> > >>>                                                                    =
       <mailto:luzmaximilian@gmail.com>
> > >>>    0xA5  20-2F  linux/surface_aggregator/dtx.h                     =
       Microsoft Surface DTX driver
> > >>>                                                                    =
       <mailto:luzmaximilian@gmail.com>
> > >>> +0xA6  00-0F  uapi/linux/alloc_tag.h                               =
     Memory allocation profiling
> > >>> +                                                                  =
     <mailto:surenb@google.com>
> > >>>    0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> > >>>    0xAB  00-1F  linux/nbd.h
> > >>>    0xAC  00-1F  linux/raw.h
> > >>> diff --git a/MAINTAINERS b/MAINTAINERS
> > >>> index a31f6f207afd..77f3fc487691 100644
> > >>> --- a/MAINTAINERS
> > >>> +++ b/MAINTAINERS
> > >>> @@ -16711,6 +16711,7 @@ S:    Maintained
> > >>>    F:  Documentation/mm/allocation-profiling.rst
> > >>>    F:  include/linux/alloc_tag.h
> > >>>    F:  include/linux/pgalloc_tag.h
> > >>> +F:   include/uapi/linux/alloc_tag.h
> > >>>    F:  lib/alloc_tag.c
> > >>>
> > >>>    MEMORY CONTROLLER DRIVERS
> > >>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > >>> index ddae7484ca45..a25a085c2df1 100644
> > >>> --- a/include/linux/codetag.h
> > >>> +++ b/include/linux/codetag.h
> > >>> @@ -77,6 +77,8 @@ struct codetag_iterator {
> > >>>    void codetag_lock_module_list(struct codetag_type *cttype);
> > >>>    bool codetag_trylock_module_list(struct codetag_type *cttype);
> > >>>    void codetag_unlock_module_list(struct codetag_type *cttype);
> > >>> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
> > >>> +unsigned int codetag_get_count(struct codetag_type *cttype);
> > >>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type =
*cttype);
> > >>>    struct codetag *codetag_next_ct(struct codetag_iterator *iter);
> > >>>
> > >>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/al=
loc_tag.h
> > >>> new file mode 100644
> > >>> index 000000000000..901199bad514
> > >>> --- /dev/null
> > >>> +++ b/include/uapi/linux/alloc_tag.h
> > >>> @@ -0,0 +1,54 @@
> > >>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > >>> +/*
> > >>> + *  include/linux/alloc_tag.h
> > >> nit: it should be include/uapi/linux/alloc_tag.h
> > >>
> > >> (I guess you may have missed the comment I brought up before. It is =
not
> > >> a critical problem though.)
> > >>
> > > Apologies, I missed that comment earlier. Included in the v4 patchset=
.
> > > Thanks for bringing this up.
> > >
> > >>> + */
> > >>> +
> > >>> +#ifndef _UAPI_ALLOC_TAG_H
> > >>> +#define _UAPI_ALLOC_TAG_H
> > >>> +
> > >>> +#include <linux/types.h>
> > >>> +
> > >>> +#define ALLOCINFO_STR_SIZE   64
> > >>> +
> > >>> +struct allocinfo_content_id {
> > >>> +     __u64 id;
> > >>> +};
> > >>> +
> > >>> +struct allocinfo_tag {
> > >>> +     /* Longer names are trimmed */
> > >>> +     char modname[ALLOCINFO_STR_SIZE];
> > >>> +     char function[ALLOCINFO_STR_SIZE];
> > >>> +     char filename[ALLOCINFO_STR_SIZE];
> > >>> +     __u64 lineno;
> > >>> +};
> > >>> +
> > >>> +/* The alignment ensures 32-bit compatible interfaces are not brok=
en */
> > >>> +struct allocinfo_counter {
> > >>> +     __u64 bytes;
> > >>> +     __u64 calls;
> > >>> +     __u8 accurate;
> > >>> +} __attribute__((aligned(8)));
> > >>> +
> > >>> +struct allocinfo_tag_data {
> > >>> +     struct allocinfo_tag tag;
> > >>> +     struct allocinfo_counter counter;
> > >>> +};
> > >>> +
> > >>> +struct allocinfo_get_at {
> > >>> +     __u64 pos;      /* input */
> > >>> +     struct allocinfo_tag_data data;
> > >>> +};
> > >>> +
> > >>> +#define _ALLOCINFO_IOC_CONTENT_ID    0
> > >>> +#define _ALLOCINFO_IOC_GET_AT                1
> > >>> +#define _ALLOCINFO_IOC_GET_NEXT              2
> > >>> +
> > >>> +#define ALLOCINFO_IOC_BASE           0xA6
> > >>> +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALL=
OCINFO_IOC_CONTENT_ID,     \
> > >>> +                                          struct allocinfo_content=
_id)
> > >>> +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _AL=
LOCINFO_IOC_GET_AT,        \
> > >>> +                                           struct allocinfo_get_at=
)
> > >>> +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BA=
SE, _ALLOCINFO_IOC_GET_NEXT,       \
> > >>> +                                          struct allocinfo_tag_dat=
a)
> > >>> +
> > >>> +#endif /* _UAPI_ALLOC_TAG_H */
> > >>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > >>> index d9be1cf5187d..a0577215eb3d 100644
> > >>> --- a/lib/alloc_tag.c
> > >>> +++ b/lib/alloc_tag.c
> > >>> @@ -5,6 +5,7 @@
> > >>>    #include <linux/gfp.h>
> > >>>    #include <linux/kallsyms.h>
> > >>>    #include <linux/module.h>
> > >>> +#include <linux/mutex.h>
> > >>>    #include <linux/page_ext.h>
> > >>>    #include <linux/pgalloc_tag.h>
> > >>>    #include <linux/proc_fs.h>
> > >>> @@ -14,6 +15,7 @@
> > >>>    #include <linux/string_choices.h>
> > >>>    #include <linux/vmalloc.h>
> > >>>    #include <linux/kmemleak.h>
> > >>> +#include <uapi/linux/alloc_tag.h>
> > >>>
> > >>>    #define ALLOCINFO_FILE_NAME         "allocinfo"
> > >>>    #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct al=
loc_tag))
> > >>> @@ -47,6 +49,10 @@ struct allocinfo_private {
> > >>>        struct codetag_iterator iter;
> > >>>        struct codetag_iterator reported_iter;
> > >>>        bool print_header;
> > >>> +     /* ioctl uses a separate iterator not to interfere with reads=
 */
> > >>> +     struct codetag_iterator ioctl_iter;
> > >>> +     bool positioned; /* seq_open_private() sets to 0 */
> > >>> +     struct mutex ioctl_lock;
> > >>>    };
> > >>>
> > >>>    static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> > >>> @@ -130,6 +136,229 @@ static const struct seq_operations allocinfo_=
seq_op =3D {
> > >>>        .show   =3D allocinfo_show,
> > >>>    };
> > >>>
> > >>> +/*
> > >>> + * Initializes seq_file operations and allocates private state whe=
n opening
> > >>> + * the /proc/allocinfo procfs entry.
> > >>> + */
> > >>> +static int allocinfo_open(struct inode *inode, struct file *file)
> > >>> +{
> > >>> +     int ret;
> > >>> +
> > >>> +     ret =3D seq_open_private(file, &allocinfo_seq_op,
> > >>> +                            sizeof(struct allocinfo_private));
> > >>> +     if (!ret) {
> > >>> +             struct seq_file *m =3D file->private_data;
> > >>> +             struct allocinfo_private *priv =3D m->private;
> > >>> +
> > >>> +             mutex_init(&priv->ioctl_lock);
> > >>> +     }
> > >>> +     return ret;
> > >>> +}
> > >>> +
> > >>> +/*
> > >>> + * Cleans up the seq_file state and frees up the private state all=
ocated in
> > >>> + * allocinfo_open() when closing the /proc/allocinfo file descript=
or.
> > >>> + */
> > >>> +static int allocinfo_release(struct inode *inode, struct file *fil=
e)
> > >>> +{
> > >>> +     return seq_release_private(inode, file);
> > >>> +}
> > >>> +
> > >>> +/*
> > >>> + * Returns a pointer to the suffix of a string so that its length =
fits within
> > >>> + * ALLOCINFO_STR_SIZE, preserving the trailing characters.
> > >>> + */
> > >>> +static const char *allocinfo_str(const char *str)
> > >>> +{
> > >>> +     size_t len =3D strlen(str);
> > >>> +
> > >>> +     /* Keep an extra space for the trailing NULL. */
> > >>> +     if (len >=3D ALLOCINFO_STR_SIZE)
> > >>> +             str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> > >>> +     return str;
> > >>> +}
> > >>> +
> > >>> +/* Copy a string and trim from the beginning if it's too long */
> > >>> +static void allocinfo_copy_str(char *dest, const char *src)
> > >>> +{
> > >>> +     strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> > >>> +}
> > >>> +
> > >>> +/*
> > >>> + * Populates the UAPI allocinfo_tag_data structure with active run=
time
> > >>> + * profiling counters extracted from the given kernel codetag.
> > >>> + */
> > >>> +static void allocinfo_to_params(struct codetag *ct,
> > >>> +                             struct allocinfo_tag_data *data)
> > >>> +{
> > >>> +     struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > >>> +     struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> > >>> +
> > >>> +     if (ct->modname)
> > >>> +             allocinfo_copy_str(data->tag.modname, ct->modname);
> > >>> +     else
> > >>> +             data->tag.modname[0] =3D '\0';
> > >>> +     allocinfo_copy_str(data->tag.function, ct->function);
> > >>> +     allocinfo_copy_str(data->tag.filename, ct->filename);
> > >>> +     data->tag.lineno =3D ct->lineno;
> > >>> +     data->counter.bytes =3D counter.bytes;
> > >>> +     data->counter.calls =3D counter.calls;
> > >>> +     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> > >>> +}
> > >>> +
> > >>> +/*
> > >>> + * Retrieves the unique content ID representing the current alloca=
tion tag module
> > >>> + * layout, allowing userspace to detect if modules were loaded / u=
nloaded.
> > >>> + */
> > >>> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void=
 __user *arg)
> > >>> +{
> > >>> +     struct allocinfo_content_id params;
> > >>> +
> > >>> +     codetag_lock_module_list(alloc_tag_cttype);
> > >>> +     params.id =3D codetag_get_content_id(alloc_tag_cttype);
> > >>> +     codetag_unlock_module_list(alloc_tag_cttype);
> > >>> +     if (copy_to_user(arg, &params, sizeof(params)))
> > >>> +             return -EFAULT;
> > >>> +
> > >>> +     return 0;
> > >>> +}
> > >>> +
> > >>> +/*
> > >>> + * Seeks the ioctl iterator to the specified 0-indexed tag positio=
n, reads its
> > >>> + * profiling data and returns it to userspace.
> > >>> + */
> > >>> +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user =
*arg)
> > >>> +{
> > >>> +     struct allocinfo_private *priv;
> > >>> +     struct codetag *ct;
> > >>> +     __u64 pos;
> > >>> +     struct allocinfo_get_at params =3D {0};
> > >>> +
> > >>> +     if (copy_from_user(&params, arg, sizeof(params)))
> > >>> +             return -EFAULT;
> > >>> +
> > >>> +     priv =3D m->private;
> > >>> +     pos =3D params.pos;
> > >>> +
> > >>> +     mutex_lock(&priv->ioctl_lock);
> > >>> +     codetag_lock_module_list(alloc_tag_cttype);
> > >>> +
> > >>> +     if (pos >=3D codetag_get_count(alloc_tag_cttype)) {
> > >>> +             codetag_unlock_module_list(alloc_tag_cttype);
> > >>> +             mutex_unlock(&priv->ioctl_lock);
> > >>> +             return -ENOENT;
> > >>> +     }
> > >>> +
> > >>> +     /* Find the codetag */
> > >>> +     priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > >>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > >>> +     while (ct && pos--)
> > >>> +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> > >>> +     if (ct) {
> > >>> +             allocinfo_to_params(ct, &params.data);
> > >>> +             priv->positioned =3D true;
> > >>> +     }
> > >>> +
> > >>> +     codetag_unlock_module_list(alloc_tag_cttype);
> > >>> +     mutex_unlock(&priv->ioctl_lock);
> > >>> +
> > >>> +     if (!ct)
> > >>> +             return -ENOENT;
> > >>> +
> > >>> +     if (copy_to_user(arg, &params, sizeof(params)))
> > >>> +             return -EFAULT;
> > >>> +
> > >>> +     return 0;
> > >>> +}
> > >>> +
> > >>> +/*
> > >>> + * Advances the ioctl iterator to the next allocation tag in the s=
equence and
> > >>> + * returns its profiling data to userspace.
> > >>> + */
> > >>> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __use=
r *arg)
> > >>> +{
> > >>> +     struct allocinfo_private *priv;
> > >>> +     struct codetag *ct;
> > >>> +     struct allocinfo_tag_data params;
> > >>> +     int ret =3D 0;
> > >>> +
> > >>> +     memset(&params, 0, sizeof(params));
> > >>> +     priv =3D m->private;
> > >>> +
> > >>> +     mutex_lock(&priv->ioctl_lock);
> > >>> +     codetag_lock_module_list(alloc_tag_cttype);
> > >>> +
> > >>> +     if (!priv->positioned) {
> > >>> +             priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_ct=
type);
> > >>> +             priv->positioned =3D true;
> > >>> +     }
> > >>> +
> > >>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> > >>> +     if (ct)
> > >>> +             allocinfo_to_params(ct, &params);
> > >>> +
> > >>> +     if (!ct) {
> > >>> +             priv->positioned =3D false;
> > >>> +             ret =3D -ENOENT;
> > >>> +     }
> > >>> +     codetag_unlock_module_list(alloc_tag_cttype);
> > >>> +     mutex_unlock(&priv->ioctl_lock);
> > >>> +
> > >>> +     if (ret =3D=3D 0) {
> > >>> +             if (copy_to_user(arg, &params, sizeof(params)))
> > >>> +                     return -EFAULT;
> > >>> +     }
> > >>> +     return ret;
> > >>> +}
> > >>> +
> > >>> +/*
> > >>> + * Entry point ioctl function for /proc/allocinfo routing requests=
 to fetch the
> > >>> + * layout content ID, seek to a specific tag, or read sequential t=
ags.
> > >>> + */
> > >>> +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
> > >>> +                         unsigned long __arg)
> > >>> +{
> > >>> +     void __user *arg =3D (void __user *)__arg;
> > >>> +     int ret;
> > >>> +
> > >>> +     switch (cmd) {
> > >>> +     case ALLOCINFO_IOC_CONTENT_ID:
> > >>> +             ret =3D allocinfo_ioctl_get_content_id(file->private_=
data, arg);
> > >>> +             break;
> > >>> +     case ALLOCINFO_IOC_GET_AT:
> > >>> +             ret =3D allocinfo_ioctl_get_at(file->private_data, ar=
g);
> > >>> +             break;
> > >>> +     case ALLOCINFO_IOC_GET_NEXT:
> > >>> +             ret =3D allocinfo_ioctl_get_next(file->private_data, =
arg);
> > >>> +             break;
> > >>> +     default:
> > >>> +             ret =3D -ENOIOCTLCMD;
> > >>> +             break;
> > >>> +     }
> > >>> +
> > >>> +     return ret;
> > >>> +}
> > >>> +
> > >>> +#ifdef CONFIG_COMPAT
> > >>> +static long allocinfo_compat_ioctl(struct file *file, unsigned int=
 cmd,
> > >>> +                                unsigned long arg)
> > >>> +{
> > >>> +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(a=
rg));
> > >>> +}
> > >>> +#endif
> > >>> +
> > >>> +static const struct proc_ops allocinfo_proc_ops =3D {
> > >>> +     .proc_open              =3D allocinfo_open,
> > >>> +     .proc_read_iter         =3D seq_read_iter,
> > >>> +     .proc_lseek             =3D seq_lseek,
> > >>> +     .proc_release           =3D allocinfo_release,
> > >>> +     .proc_ioctl             =3D allocinfo_ioctl,
> > >>> +#ifdef CONFIG_COMPAT
> > >>> +     .proc_compat_ioctl      =3D allocinfo_compat_ioctl,
> > >>> +#endif
> > >>> +
> > >>> +};
> > >>> +
> > >>>    size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t co=
unt, bool can_sleep)
> > >>>    {
> > >>>        struct codetag_iterator iter;
> > >>> @@ -993,8 +1222,7 @@ static int __init alloc_tag_init(void)
> > >>>                return 0;
> > >>>        }
> > >>>
> > >>> -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL,=
 &allocinfo_seq_op,
> > >>> -                                  sizeof(struct allocinfo_private)=
, NULL)) {
> > >>> +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_=
proc_ops)) {
> > >>>                pr_err("Failed to create %s file\n", ALLOCINFO_FILE_=
NAME);
> > >>>                shutdown_mem_profiling(false);
> > >>>                return -ENOMEM;
> > >>> diff --git a/lib/codetag.c b/lib/codetag.c
> > >>> index 4001a7ea6675..a9cda4c962a3 100644
> > >>> --- a/lib/codetag.c
> > >>> +++ b/lib/codetag.c
> > >>> @@ -19,6 +19,8 @@ struct codetag_type {
> > >>>        struct codetag_type_desc desc;
> > >>>        /* generates unique sequence number for module load */
> > >>>        unsigned long next_mod_seq;
> > >>> +     /* bumped on every module load and unload */
> > >>> +     unsigned long content_id;
> > >>>    };
> > >>>
> > >>>    struct codetag_range {
> > >>> @@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag_t=
ype *cttype)
> > >>>        up_read(&cttype->mod_lock);
> > >>>    }
> > >>>
> > >>> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> > >>> +{
> > >>> +     lockdep_assert_held(&cttype->mod_lock);
> > >>> +
> > >>> +     return cttype->content_id;
> > >>> +}
> > >>> +
> > >>> +unsigned int codetag_get_count(struct codetag_type *cttype)
> > >>> +{
> > >>> +     lockdep_assert_held(&cttype->mod_lock);
> > >>> +
> > >>> +     return cttype->count;
> > >>> +}
> > >>> +
> > >>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type =
*cttype)
> > >>>    {
> > >>>        struct codetag_iterator iter =3D {
> > >>> @@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag_t=
ype *cttype, struct module *mod)
> > >>>
> > >>>        down_write(&cttype->mod_lock);
> > >>>        cmod->mod_seq =3D ++cttype->next_mod_seq;
> > >>> +     ++cttype->content_id;
> > >> I have a comment on the content_id bump placement.
> > >>
> > >> ++cttype->content_id is placed before idr_alloc and the module_load
> > >>
> > >> callback. If idr_alloc fails or module_load returns an error
> > >>
> > >> (While the chance of this occurring is very low.), the idr entry get=
s
> > >>
> > >> rolled back but content_id has already been bumped. The actual
> > >>
> > >> content didn't change in this case, so userspace would see a
> > >>
> > >> different content_id and assume the data is inconsistent when it
> > >>
> > >> isn't.
> > >>
> > >>
> > >> Thanks
> > >>
> > >> Best Regards
> > >>
> > >> Hao
> > > While I agree with your comment, I decided to place the counter
> > > increment there because the chance of failure is low. Furthermore,
> > > even if it falsely invalidates user data, the user will simply query
> > > the content again. This placement also aligns with where the
> > > previously used field (cttype->next_mod_seq) was incremented. Let me
> > > know if you still think I should move it. Thanks!
> >
> > Sorry, I should have marked this as a nit when I raised the comment.
> >
> > Given its low probability of occurring, it doesn't block anything for n=
ow.
> >
> > The reason I raised this comment was just in case someone adds new logi=
c
> >
> > in the feature  that could fail. But if that happens, we can move both
> > next_mod_seq
> >
> > and content_id down together.
> >
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
>
> Sounds good, so for now I am not touching this patch and keeping it as
> is other than the file path nit inside the UAPI header file.

Actually, checkpatch is complaining about using the same filename
inside of the file and hence I am dropping that comment completely.

> > >>>        mod_id =3D idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNE=
L);
> > >>>        if (mod_id >=3D 0) {
> > >>>                if (cttype->desc.module_load) {
> > >>> @@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod)
> > >>>                        cttype->count -=3D range_size(cttype, &cmod-=
>range);
> > >>>                        idr_remove(&cttype->mod_idr, mod_id);
> > >>>                        kfree(cmod);
> > >>> +                     ++cttype->content_id;
> > >>>                }
> > >>>                up_write(&cttype->mod_lock);
> > >>>                if (found && cttype->desc.free_section_mem)

