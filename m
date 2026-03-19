Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407171090240
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7DF6B0504; Thu, 19 Mar 2026 11:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F9E6B0506; Thu, 19 Mar 2026 11:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DA76B0507; Thu, 19 Mar 2026 11:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 806586B0504
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:19:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 493D9140633
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:19:53 +0000 (UTC)
X-FDA: 84563172666.27.0FDB463
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 30B3F20003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:19:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ogmafgDZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfH8Q5Td26D2zz2vaWeEEQdnUyXBLu9cQNzXDyggGWs=;
	b=D68akB+4df4laO/aYpRZ4MKylbN4ORqq9f/V2FWsna8WNVWJ0VAS6k9/Uq1WmnzsoaRlg9
	k5ZqIhygQycgxGbpNOfB9BUle/UsfoDWjIWLTPCreS9tvwubLOtOi5uMHx/AbOnmT4P723
	qzLqFIUhPioRmPCOuj+Y4Zh/mKzO/R8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773933591; a=rsa-sha256;
	cv=pass;
	b=uY/kqCSHzQ0Y1GgIfFp1tv9DKtQRVhLHrMKygMvK8vCiZm1/vI21WooudIVhGTtAnusoSJ
	8vYPuy6q14TbSncHbuxc+EnrhpVjDZuDfISB4qiqWUT5LpIz6F1lBnjF9Ii3oCwQIahBK2
	AaSxzWw1o7Gwi4afm4thQAP64kWCwUc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ogmafgDZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-667cde0fc88so10035a12.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773933590; cv=none;
        d=google.com; s=arc-20240605;
        b=ZXC+kHGFBWHP6Lm6sY3Sy4irynTkdRlO0niVgTzFLBU8h5+K0QaANpjcIyy27Xs8GO
         HTVW33xq2fctXPvH5w1tCY4VL4SrKpoSBz/HNpqPxo6T6N8gB8whBrbaZERzJ5j1L47E
         /hUhO/gAgfW6jq5sTCQDl8kk7hEO229epXDnSqTZ3R0nbZ0539BCRrsSWaP0cep51K9Z
         5prNvqHbuf2zHgZq3O5EORtQRZMRdk/mq00qomThQxSb11hMEiI6eMjK3C42QE1s0mw+
         vek/4POQHmnmfFKPHxxVtbntcL9/XvYWD0jn+hq9FWO0c2TA+tzvzPXgZET1kGe8hDVV
         z2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OfH8Q5Td26D2zz2vaWeEEQdnUyXBLu9cQNzXDyggGWs=;
        fh=p0UcX7OCidcZabev8oorK4bZpZE2sYXUs5B5FMtJS5E=;
        b=VfBoQzfXMGCGQ3hU8INs0gyUjmKY5uT11zscO7brsO+R1uqns20Fj2fieJ3Qkk2brm
         haD52HquJLvCDlsxpppE1KYCHyKb0170uprufQY931bKSG8xfS6TS2bQSCJ7DeVM+Atm
         u3hf2NbNK2Y3ogi2Jp696j/hGVfiT5mlpeHz2cd9HSHvc+o3zGYfCm8rWKnHqaJJKx9B
         7ZSOYQyhSE5NeZGdAzo5o6q/7zR3z5XG1zNs9+QcDQGS+sXJia3lC6ZYucviBgDzi+NM
         oZamnLk1Cv85ywqqA18lNQHEFW3ONpxltd+kAk5a+BEutCjyJozJYGz25CBiZEhRUf61
         h5qQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773933590; x=1774538390; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfH8Q5Td26D2zz2vaWeEEQdnUyXBLu9cQNzXDyggGWs=;
        b=ogmafgDZCkaKRz05Dbsqb0OZ5Qg++vaZju50cw6Gcq45NLaYMrtp/H2K+7jvrQuAsE
         aK2mjByKMMMEjprqjfLu5qmNmg2D7myY6A2WiGHbp126zAH5rlP/uL9wfbtgmQ19wU2h
         ks49hwaehEW8RUhaJFpS7r3p7jCx20AOfwLZY2NW2NhfwRLtd3mwEWt6lomJJsMHtijZ
         y7k/INquDcRihRPDZ6JLSiQ7uaxwRkK4ejpPLdOYuc/RBUb1cfMQWGBPfGKJTP9zsLWm
         WVR48FMpncZKJLxPUNgpjF8yEL7dcpX+N2BJ3wRwT/RnHljJem8CKCQa5EbNCzW5drJX
         fjcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773933590; x=1774538390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OfH8Q5Td26D2zz2vaWeEEQdnUyXBLu9cQNzXDyggGWs=;
        b=ULu0ktW4GAiAoLbMkO7MzPweOwLbfNAHb+oJsJI05Y9K6TIFnFL6VSBA+pchMGRO4S
         2ZV7kQ7F2fx8u6xWeQt1DDiE3tYkIUJQYwHbBbvvpUManbqdZgcnHGDG3Ol3Vp5I+nwo
         R4Wt6nXQoFqFkybhEV/CLFw0cuGEIa6AtSIl/s/dl9eIqjHwaz3T+n8wKMjN8Dke+tEY
         d52rgsRXLJOMTnbQMfDTO2PfS1W66Kolw6n6sK169PtPGo7FDf5Ag40KZ45aXp5v8e5w
         cSdPrur10HoMtzCA0POy/U5pAqfFAOlFsvG3XRKMsk0Bv2JbFgRlNsNhHFN19iFIqQcw
         sYAg==
X-Forwarded-Encrypted: i=1; AJvYcCXHHwQ+CVHIRYWK5QaLW+J4joOXrEXtkET3IFJmY4uc8IQm2MBwmUDlVc2WaybsgQOVBz8jEUBFOg==@kvack.org
X-Gm-Message-State: AOJu0Yy+XnmRZv5OI434Cm19ad6oXJ85kN2bvleTHycZOtKyw7WQk2o0
	KA427T+P7vSBmmIWPPBRVUr0ZXdhOB45n1urc4zE8gZrTWivsISl1Mge3Dp9nki8pATTI9BhTgO
	zyPNlyR1nYD34rJKgbSvAnVOKfC0jZ2/9dQVF+/QQ
X-Gm-Gg: ATEYQzwJQYhuDPfA3oL0ORx3TMKFGibaLWWOLrp3L+r4WbEmwqsaQI79XhghEQEmAhN
	2dePT4THsEFkCSqDJ9Xo+J6BjzK8YbG08Vw9sDbH4yilytgNyAiOR+L1qGzyuRD2UYc5Q2SeD+1
	2xVciS2RefL5otvIzkYGAk/M/mUHMzqIVdtqol+Fq04Fd2geYbm8HVvx7wLpEfzKF0XD9/h+QUP
	SNca8IBiKcILdSEwOyyyj5fBN2+0/X4Fh/OBAWQ+6uhoPoWcxBFtpEwpdoFb/R2nn+hl8fol91o
	lm0Uy0l+Q4buwMUqji7saZF54uNln9ztfcGn
X-Received: by 2002:a05:6402:46c5:b0:665:d39:4b18 with SMTP id
 4fb4d7f45d1cf-66852d6c8abmr48783a12.8.1773933589136; Thu, 19 Mar 2026
 08:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
 <CAJuCfpFXuHg4KPY27pqMC-xV5y9ZY2W72_R8_rxO0DvrJ=_yvw@mail.gmail.com>
 <CAJuCfpE5qZmi43EeZiRcy78pD6YvJb5n_xnoUJfwEjomowu0=A@mail.gmail.com>
 <8cdad898-b306-40fe-a367-efe7147f83b9@lucifer.local> <CAJuCfpHXqtxZr5s84jCcz513a2pgMeDoobsLBJH9pSON49cM+w@mail.gmail.com>
In-Reply-To: <CAJuCfpHXqtxZr5s84jCcz513a2pgMeDoobsLBJH9pSON49cM+w@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 08:19:35 -0700
X-Gm-Features: AaiRm51bFJ7jnCWExjTkTJWtl61x7cY-2jhtQRDi8xxndWDLsjo0Sko90eA6oXU
Message-ID: <CAJuCfpG4F7r=AMTBRkazFeQsnKocu9OPFyV2TsQccLQc=oLwNA@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] staging: vme_user: replace deprecated mmap hook
 with mmap_prepare
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: e6ef1yg7y993hd6e4zsbre967sqfkrjh
X-Rspamd-Queue-Id: 30B3F20003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773933590-820166
X-HE-Meta: U2FsdGVkX19kVeUb/LygueeGaQFnDsNCyIW068orNSHISA9jnIZmKifDN1k1Jy2Pzhnl7pW6M8+tvVE7m5SWy0ogDP7XyICWxliuoXqDZR9SYmCIWLU22OdAEDZYjRpVBHHWwlAaOGV8b7mU1hrOnsbaq3FlGFmaa8F/HV9mL57ExNLi0ltcWaB2MkKYE+/q+fXZcJCdKeHRyQsHPbjTV8pC/bX7uVdEZ5/K+S8iYoEfkOBkCVhkiL61OFFBDHbQCvocGi4VoT6vs4M1tD3uLLY/tarxqHT9CoQNwygCqZu09QpRwiJcpMpo/cJjj/A0udlHrfrfjXQUnSgGV4AxvVo5a4qEfnUOxQWtY7bvl88erye4ovE8ckLMj2JsshOwMRwkBbFdnTk7ttPQScI2mENY5WvjDRc4IqKKIyxjShDMpE2nVVlhn03AiFFnfdYoJnb0LvljSRRyzvcq1oFrio6fkRXX09nrbDA62+2YP+KcwjOA/GYATwE6y8mZBWGaO24daMvY3Bz7TGwLAdbOfb3QRXmvPk0HLIiPS4hUx9as4AiE0kJw+VbfubhvFejpaHRLcG/L9IZOKSICgeKeQ1rru9IbsHh8JMIxXqDkPKRJqH464AT5NLG/ZrOskDgcIe5wWtn0YvcATKvDWGID6Mer1hexvQJ4G866z6/EHAH7Rx3dYxkcSKx9lS5nZiDKLzZqGwNxcq2flUQKj8bnK1duQF8TbUjnwBryHmDqKP0GHOjbcnIc6VAw9tFR5jlVM/jgf4srrU7/oAekYfgDC3HlFXU3chi1ogChkwSct35XCYTfjL+9G6HR0uTzXZIRNK7PiFQU0A+eRQqhI3lHfr/5Cpxr+2srehDNSznarGeGcqiSCtnOX6bFSqDB1WP8Eawtxzx5pMqhvTTeqLTcjcIxubdNEOAhIskkEXk3X517y3lhXW0tz//kDTn85DWPkmjhbpO+aYOoc5lceFu
 aoTdQWPE
 /jLmBYcL/7LGUamyZb0z+Gf+653QKBT0Zd57JFjKP0gxsWrCtdahR4BqUzWwyDvF+F+CFQe4N1AGdqW4DzE+Z5yLohi5ot8QimHqyaQWEWdXm5vmbqT2BPpC8GVkQSMeuu4V9khoYSvA3pqEAR0N+ac5JSX1+WGgnG0GISS6MM2cwnIaSoNG2GRw03BRwG8qTQZVbPOF0Nuq3RgvE+/sOk588StJcEaGT/dQPawPwfxwCthIEEKtHSUUYGkO1QdcD3FXKkP2fd6W4Xpl8LrkXsHKBxSLl60BrAQ8QezvXACkLX1WRhTWZObhldYy0C/U+dIZ5XeX4Yr5CSqT2w4ILhxmXF5ld3NeoykAV8mUCgDU7Obcrnysu3S3a/o5e7p7ESDGn42TncWU3LWEaVMOfAhtrOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 8:19=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Mar 19, 2026 at 7:55=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@ker=
nel.org> wrote:
> >
> > On Tue, Mar 17, 2026 at 02:32:16PM -0700, Suren Baghdasaryan wrote:
> > > On Tue, Mar 17, 2026 at 2:26=E2=80=AFPM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> > > >
> > > > On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <l=
js@kernel.org> wrote:
> > > > >
> > > > > The f_op->mmap interface is deprecated, so update driver to use i=
ts
> > > > > successor, mmap_prepare.
> > > > >
> > > > > The driver previously used vm_iomap_memory(), so this change repl=
aces it
> > > > > with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> > > > >
> > > > > Functions that wrap mmap() are also converted to wrap mmap_prepar=
e()
> > > > > instead.
> > > > >
> > > > > Also update the documentation accordingly.
> > > > >
> > > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> > > > > ---
> > > > >  Documentation/driver-api/vme.rst    |  2 +-
> > > > >  drivers/staging/vme_user/vme.c      | 20 +++++------
> > > > >  drivers/staging/vme_user/vme.h      |  2 +-
> > > > >  drivers/staging/vme_user/vme_user.c | 51 +++++++++++++++++------=
------
> > > > >  4 files changed, 42 insertions(+), 33 deletions(-)
> > > > >
> > > > > diff --git a/Documentation/driver-api/vme.rst b/Documentation/dri=
ver-api/vme.rst
> > > > > index c0b475369de0..7111999abc14 100644
> > > > > --- a/Documentation/driver-api/vme.rst
> > > > > +++ b/Documentation/driver-api/vme.rst
> > > > > @@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` can be=
 used to read from and
> > > > >
> > > > >  In addition to simple reads and writes, :c:func:`vme_master_rmw`=
 is provided to
> > > > >  do a read-modify-write transaction. Parts of a VME window can al=
so be mapped
> > > > > -into user space memory using :c:func:`vme_master_mmap`.
> > > > > +into user space memory using :c:func:`vme_master_mmap_prepare`.
> > > > >
> > > > >
> > > > >  Slave windows
> > > > > diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme=
_user/vme.c
> > > > > index f10a00c05f12..7220aba7b919 100644
> > > > > --- a/drivers/staging/vme_user/vme.c
> > > > > +++ b/drivers/staging/vme_user/vme.c
> > > > > @@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_resour=
ce *resource, unsigned int mask,
> > > > >  EXPORT_SYMBOL(vme_master_rmw);
> > > > >
> > > > >  /**
> > > > > - * vme_master_mmap - Mmap region of VME master window.
> > > > > + * vme_master_mmap_prepare - Mmap region of VME master window.
> > > > >   * @resource: Pointer to VME master resource.
> > > > > - * @vma: Pointer to definition of user mapping.
> > > > > + * @desc: Pointer to descriptor of user mapping.
> > > > >   *
> > > > >   * Memory map a region of the VME master window into user space.
> > > > >   *
> > > > > @@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
> > > > >   *         resource or -EFAULT if map exceeds window size. Other=
 generic mmap
> > > > >   *         errors may also be returned.
> > > > >   */
> > > > > -int vme_master_mmap(struct vme_resource *resource, struct vm_are=
a_struct *vma)
> > > > > +int vme_master_mmap_prepare(struct vme_resource *resource,
> > > > > +                           struct vm_area_desc *desc)
> > > > >  {
> > > > > +       const unsigned long vma_size =3D vma_desc_size(desc);
> > > > >         struct vme_bridge *bridge =3D find_bridge(resource);
> > > > >         struct vme_master_resource *image;
> > > > >         phys_addr_t phys_addr;
> > > > > -       unsigned long vma_size;
> > > > >
> > > > >         if (resource->type !=3D VME_MASTER) {
> > > > >                 dev_err(bridge->parent, "Not a master resource\n"=
);
> > > > > @@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource *re=
source, struct vm_area_struct *vma)
> > > > >         }
> > > > >
> > > > >         image =3D list_entry(resource->entry, struct vme_master_r=
esource, list);
> > > > > -       phys_addr =3D image->bus_resource.start + (vma->vm_pgoff =
<< PAGE_SHIFT);
> > > > > -       vma_size =3D vma->vm_end - vma->vm_start;
> > > > > +       phys_addr =3D image->bus_resource.start + (desc->pgoff <<=
 PAGE_SHIFT);
> > > > >
> > > > >         if (phys_addr + vma_size > image->bus_resource.end + 1) {
> > > > >                 dev_err(bridge->parent, "Map size cannot exceed t=
he window size\n");
> > > > >                 return -EFAULT;
> > > > >         }
> > > > >
> > > > > -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot)=
;
> > > > > -
> > > > > -       return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma-=
>vm_start);
> > > > > +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> > > > > +       mmap_action_simple_ioremap(desc, phys_addr, vma_size);
> > > > > +       return 0;
> > > > >  }
> > > > > -EXPORT_SYMBOL(vme_master_mmap);
> > > > > +EXPORT_SYMBOL(vme_master_mmap_prepare);
> > > > >
> > > > >  /**
> > > > >   * vme_master_free - Free VME master window
> > > > > diff --git a/drivers/staging/vme_user/vme.h b/drivers/staging/vme=
_user/vme.h
> > > > > index 797e9940fdd1..b6413605ea49 100644
> > > > > --- a/drivers/staging/vme_user/vme.h
> > > > > +++ b/drivers/staging/vme_user/vme.h
> > > > > @@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resource *=
resource, void *buf, size_t count,
> > > > >  ssize_t vme_master_write(struct vme_resource *resource, void *bu=
f, size_t count, loff_t offset);
> > > > >  unsigned int vme_master_rmw(struct vme_resource *resource, unsig=
ned int mask, unsigned int compare,
> > > > >                             unsigned int swap, loff_t offset);
> > > > > -int vme_master_mmap(struct vme_resource *resource, struct vm_are=
a_struct *vma);
> > > > > +int vme_master_mmap_prepare(struct vme_resource *resource, struc=
t vm_area_desc *desc);
> > > > >  void vme_master_free(struct vme_resource *resource);
> > > > >
> > > > >  struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 r=
oute);
> > > > > diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/stagin=
g/vme_user/vme_user.c
> > > > > index d95dd7d9190a..11e25c2f6b0a 100644
> > > > > --- a/drivers/staging/vme_user/vme_user.c
> > > > > +++ b/drivers/staging/vme_user/vme_user.c
> > > > > @@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_are=
a_struct *vma)
> > > > >         kfree(vma_priv);
> > > > >  }
> > > > >
> > > > > -static const struct vm_operations_struct vme_user_vm_ops =3D {
> > > > > -       .open =3D vme_user_vm_open,
> > > > > -       .close =3D vme_user_vm_close,
> > > > > -};
> > > > > -
> > > > > -static int vme_user_master_mmap(unsigned int minor, struct vm_ar=
ea_struct *vma)
> > > > > +static int vme_user_vm_mapped(unsigned long start, unsigned long=
 end, pgoff_t pgoff,
> > > > > +                             const struct file *file, void **vm_=
private_data)
> > > > >  {
> > > > > -       int err;
> > > > > +       const unsigned int minor =3D iminor(file_inode(file));
> > > > >         struct vme_user_vma_priv *vma_priv;
> > > > >
> > > > >         mutex_lock(&image[minor].mutex);
> > > > >
> > > > > -       err =3D vme_master_mmap(image[minor].resource, vma);
> > > > > -       if (err) {
> > > > > -               mutex_unlock(&image[minor].mutex);
> > > > > -               return err;
> > > > > -       }
> > > > > -
> > > >
> > > > Ok, this changes the set of the operations performed under image[mi=
nor].mutex.
> > > > Before we had:
> > > >
> > > > mutex_lock(&image[minor].mutex);
> > > > vme_master_mmap();
> > > > <some final adjustments>
> > > > mutex_unlock(&image[minor].mutex);
> > > >
> > > > Now we have:
> > > >
> > > > mutex_lock(&image[minor].mutex);
> > > > vme_master_mmap_prepare()
> > > > mutex_unlock(&image[minor].mutex);
> > > > vm_iomap_memory();
> > > > mutex_lock(&image[minor].mutex);
> > > > vme_user_vm_mapped(); // <some final adjustments>
> > > > mutex_unlock(&image[minor].mutex);
> > > >
> > > > I think as long as image[minor] does not change while we are not
> > > > holding the mutex we should be safe, and looking at the code it see=
ms
> > > > to be the case. But I'm not familiar with this driver and might be
> > > > wrong. Worth double-checking.
> >
> > The file is pinned for the duration, the mutex is associated with the f=
ile,
> > so there's no sane world in which that could be problematic.
> >
> > Keeping in mind that we manipulate stuff on vme_user_vm_close() that
> > directly acceses image[minor] at an arbitary time.
>
> That was my understanding as well. Thanks for confirming.
>
> >
> > >
> > > A side note: if we had to hold the mutex across all those operations =
I
> > > think we would need to take the mutex in the vm_ops->mmap_prepare and
> > > add a vm_ops->map_failed hook or something along that line to drop th=
e
> > > mutex in case mmap_action_complete() fails. Not sure if we will have
> > > such cases though...
> >
> > No, I don't want to do this if it can be at all avoided. You should in
> > nearly any sane circumstance be able to defer things until the mapped h=
ook
> > anyway.
> >
> > Also a merge can happen too after an .mmap_prepare, so we'd have to hav=
e
> > some 'success' hook and I'm just not going there it'll end up open to a=
buse
> > again.
> >
> > (We do have success and error filtering hooks right now, sadly, but the=
y're
> > really for hugetlb and I plan to find a way to get rid of them).
> >
> > The mmap_prepare is meant to essentially be as stateless as possible.
>
> Yes, I also hope we won't encounter cases requiring us to keep any
> state information between the mmap_prepare and mapped stages.
>
> >
> > Anyway I don't think it's relevant here.
> >
> > >
> > > >
> > > > >         vma_priv =3D kmalloc_obj(*vma_priv);
> > > > >         if (!vma_priv) {
> > > > >                 mutex_unlock(&image[minor].mutex);
> > > > > @@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned in=
t minor, struct vm_area_struct *vma)
> > > > >
> > > > >         vma_priv->minor =3D minor;
> > > > >         refcount_set(&vma_priv->refcnt, 1);
> > > > > -       vma->vm_ops =3D &vme_user_vm_ops;
> > > > > -       vma->vm_private_data =3D vma_priv;
> > > > > -
> > > > > +       *vm_private_data =3D vma_priv;
> > > > >         image[minor].mmap_count++;
> > > > >
> > > > >         mutex_unlock(&image[minor].mutex);
> > > > > -
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > -static int vme_user_mmap(struct file *file, struct vm_area_struc=
t *vma)
> > > > > +static const struct vm_operations_struct vme_user_vm_ops =3D {
> > > > > +       .mapped =3D vme_user_vm_mapped,
> > > > > +       .open =3D vme_user_vm_open,
> > > > > +       .close =3D vme_user_vm_close,
> > > > > +};
> > > > > +
> > > > > +static int vme_user_master_mmap_prepare(unsigned int minor,
> > > > > +                                       struct vm_area_desc *desc=
)
> > > > > +{
> > > > > +       int err;
> > > > > +
> > > > > +       mutex_lock(&image[minor].mutex);
> > > > > +
> > > > > +       err =3D vme_master_mmap_prepare(image[minor].resource, de=
sc);
> > > > > +       if (!err)
> > > > > +               desc->vm_ops =3D &vme_user_vm_ops;
> > > > > +
> > > > > +       mutex_unlock(&image[minor].mutex);
> > > > > +       return err;
> > > > > +}
> > > > > +
> > > > > +static int vme_user_mmap_prepare(struct vm_area_desc *desc)
> > > > >  {
> > > > > -       unsigned int minor =3D iminor(file_inode(file));
> > > > > +       const struct file *file =3D desc->file;
> > > > > +       const unsigned int minor =3D iminor(file_inode(file));
> > > > >
> > > > >         if (type[minor] =3D=3D MASTER_MINOR)
> > > > > -               return vme_user_master_mmap(minor, vma);
> > > > > +               return vme_user_master_mmap_prepare(minor, desc);
> > > > >
> > > > >         return -ENODEV;
> > > > >  }
> > > > > @@ -498,7 +507,7 @@ static const struct file_operations vme_user_=
fops =3D {
> > > > >         .llseek =3D vme_user_llseek,
> > > > >         .unlocked_ioctl =3D vme_user_unlocked_ioctl,
> > > > >         .compat_ioctl =3D compat_ptr_ioctl,
> > > > > -       .mmap =3D vme_user_mmap,
> > > > > +       .mmap_prepare =3D vme_user_mmap_prepare,
> > > > >  };
> > > > >
> > > > >  static int vme_user_match(struct vme_dev *vdev)
> > > > > --
> > > > > 2.53.0
> > > > >
> >
> > Cheers, Lorenzo

