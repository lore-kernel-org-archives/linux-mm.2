Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33B89CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949608E0012; Tue, 16 Sep 2025 11:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9998E0002; Tue, 16 Sep 2025 11:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E88B8E0012; Tue, 16 Sep 2025 11:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 671D08E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:26:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D1941DCC5D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:26:56 +0000 (UTC)
X-FDA: 83895491232.03.A6ECEFD
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 110A44000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:26:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=OzPiwvq+;
	spf=pass (imf27.hostedemail.com: domain of paul@paul-moore.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758036414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCQn1+qgmwmQoE79zxmLidjuTy26gWnilkFHndViNWU=;
	b=e2XCPGW/FXQmiJWEUKg1XViprJVuvZ/alP9o5INi75YW8/FLhKAGEj9sa2SRvgqcgAtl+n
	UMfJCCBc3oh85c3BxjpFEQw5T7rSPWpZAVE5uEwcMfk5Dxqi/6GctijqtRwH/cnVGeyt1f
	dhqgVMoJrWBde2NnWgbMTCwuZMMZvJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758036414; a=rsa-sha256;
	cv=none;
	b=Mc6T/PvyICR2vyzNFq3LLZMHysLcV/mGZT8vuDstfEl/C4ne/Mtx9X/ub83BLBOyfmZUwC
	rqNMo6Scy9vcp4tKWLgtJJcQ8Y3zkdMqx+fv/cJCoho2RZOtbYUR1h8CPkhHwzQf7YopFK
	7yx49vhN39je10tTet8xOxcFbkbpATg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=OzPiwvq+;
	spf=pass (imf27.hostedemail.com: domain of paul@paul-moore.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-30cce5cb708so3561356fac.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1758036412; x=1758641212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aCQn1+qgmwmQoE79zxmLidjuTy26gWnilkFHndViNWU=;
        b=OzPiwvq+CfpXKIiSHFXWrymJXk+5FK1bpNotUMSj+dySw8jVFLSzP+Kou7BbFAKO81
         AJpMgsWpt/LCwa8w2e/5oqJrugTG5EjN7htaO6z8maLxx9DkuxxBsJcW7qjCCNf1+AjV
         CTk9nm2LLkkkmmcuRMczNDM64wYzME/QmIVn/aO8F1DbwU2cxk74QLqGPLDQ9cTveypo
         PySiiMVLE1Eks8j6FB++PCGVTNi4fKQEGdXHnaC8O4Q9lnEJAEcmbhF/GqdI+qBPMgnu
         wwlbVMuDsjsa7dKghbk3v6DOyA9kn5o7ZfD35C/4KhFVk95UDnav0BJsCTvt+rNmbLGf
         lEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758036412; x=1758641212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aCQn1+qgmwmQoE79zxmLidjuTy26gWnilkFHndViNWU=;
        b=bMF6l75VafyoueahJPIPVWv9Z8RrjLpZikxIWVZSvmKQ/bDTTZa+dWHDw1IfqqaweD
         tkhHrU1O2ae4tNIGlYe1Db2pdJOBS3YQvgAjs11uUoByDgitF5/DtAJM9+KBRsTbey49
         8m700Bv92Bgy6inTcDvTAnLpmxt9hefueVDCvqQIu9wuzTzoF+PbXzTqoz5T8P7MaJ/G
         mv7dwLxeHZmcL3FtZb9km4r+hNzHxPxFquRLSmEDHIrNd7zNR7pD7/f84zL4ZjDv19EY
         b3aQc6ysZptRaAzoLV6GqsUCV21MjiCP9CHDQKJ0hAm7quNimVg3b5xoLp2maDgxTQXp
         /Hig==
X-Forwarded-Encrypted: i=1; AJvYcCUUNeHBLWStQTdFPKVFMBXJJbOE1eNnGiIDEVnxxwHjTAAixKuLPrtTyDhLuPCVrvQjNoI/UUHZDw==@kvack.org
X-Gm-Message-State: AOJu0YyoEEji2qh6tZoxzYEJs5SQ520nrxEhpj9SCKMKCdkktcUx0G82
	6u8ps4dnwysR/nUYTT1c+6snnqQ4OzXTlGDHGhv4F0sXUScCkYK46HU1CqT3yJ5IXX5RW9rCZGA
	W6JQb1XptslwzIpmA0BmGhsIRGEklUEQUGEnXPHw1
X-Gm-Gg: ASbGncss4ZRaKNIO+22mXlamam0ERKI7X15oYoc38tntvhSejJds9pSMORM5BeY9qBT
	0kWaXB7Yem87P7ze1PC3jEJiCgDstlIWlcj/J0XGyk5Wh9CU0xHUCZJsbnQnNzGo7o2NjWR5g+u
	f5ZfiiY33Iyi5WJ5gjJbUEzBM8sieDByNsAl/zsUIg+eReSFdve97A9CpnanmbGE9pvYyR0w2IX
	5S4RuM=
X-Google-Smtp-Source: AGHT+IEHQRX/QKtURM3ZBFKblim/ENLeZ5c+QD7UiDxNTE8WpHlGzNMOx/Q1hdBXqdyzU+cMTKCcGQ1RSf0ttX8oRA8=
X-Received: by 2002:a05:6870:70a7:b0:31d:8b26:f600 with SMTP id
 586e51a60fabf-32e54a8475emr6916168fac.20.1758036411638; Tue, 16 Sep 2025
 08:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250826031824.1227551-1-tweek@google.com> <6afc91a9f5caef96b2ca335b6d143670@paul-moore.com>
 <92255d5e-7e0a-6ca3-3169-114ae7f6247f@google.com>
In-Reply-To: <92255d5e-7e0a-6ca3-3169-114ae7f6247f@google.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 16 Sep 2025 11:26:38 -0400
X-Gm-Features: AS18NWCuUiv9oyKOG1eHUS0O1Z1zJo100aKng26KHQ-sy3cd16UuRWkNtSHwhJw
Message-ID: <CAHC9VhQejS05C8AExkh32GidBdzXjauKPP6T_3eSGZDEwfwDuA@mail.gmail.com>
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
To: Hugh Dickins <hughd@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b1t9tgk7eyuoewwzdht1jx69mibfj3wm
X-Rspamd-Queue-Id: 110A44000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758036412-493357
X-HE-Meta: U2FsdGVkX19f1M6ZMCcDSKiYF76PFkNugqkeXFOa6dOre0XOAnef87vWXI1z60EGY2/wtMGNG36VFZCjK7cpah8uZJ/vhembY9Bs4uEa9NAiPxyP37sdxyX4JZ+NcAkqTsM2QnVc4KhsrwPPEf0KKoq4NSWz4iptduNfh9UML+mDEg4j/OcPHSb/YhuTBeNhTmIeEri0RuBQS4IDDkJaCbCy2q2v+ZHNzqsf5vuH1YnFZt5Wzsk/Nuo92mlwc2SBulAfpcKaUIU8F7aCqONwT+LAYjUJvGhYwYnGVuuQA+rrpWLeP13Hvyol9tlZ7RmotCig87yvO8y+SDXDMmF8ypILgeNolVCzNmVWMc2VbJOfXvxKzuJAEIzwmMrnlJSDlX9xTBOc15rZdO6SWAEXcljotq/g7lKg/iOAEy6rumtupxxtN8vjtVPRw5Yv4vuEb+AgWz6Ir16VrMwHcOx/EzF8fuqxPV/N7V5S7sc/RAEuFHc/f/+IVjM3MI0w6ITzbTetxjLmYsl6X7tZJqkKQfNHdgO+SDg3MDg20RSlr64mYCSMMTnHsBsQ7hWP/cz2p5cM10Mc3+7GoNzoq9j1IwW7Kka8YnH9YegMaIwCMVugoqmgVq5i5tursOKdoTvpZ8n23Lv10m2WMSciZjglAMZLM5H5CgKEicucPO2l6Xd/ubM7g6R+hnaVYE4C9QwenvPSOBsg+VK345UqjqZoKqO6KE/QpMGggMO/qCuBDPUFezslKINPjS64wHLv/W5Yepo5JBgAwA/d9Txer4M95qKv6fy8kShKTKnAv4psDlWhexzW3+clwb8Sh3CoUfAIdWlFs16IrFjBRXxGru2+i0HDlsiyLLRH05mEwZS2u5WlRHkUCQa2HsXJpOvoST7hEqwZLAOpbRSfAplp4NLRBTG+gee7P+lNvGUxOHilTsf6GSf6eGC41utG7DzL8Pz2BI4f/numP6UTLji35uU
 VLnV9Pk9
 UzPspDTfmz56ILWvOz8tvvUlwKMNuziaL8/ZwVCXlEvlu3mBe1dovg3WG2mXGVTf55La7G2XRgN6748e8dXCA8OqddpjWQwcrASoAxMclx/Qbq23IwsyJ78dME2Et6TR5IiaRBSnGq/wJu8IC2aX2aUrZ0T2K75R3P7U03HdRkOyj8j9mguCMOMU1Mw64pSslrm729gYMI3R1qrS1PQVShYyLCXe+UefVEnFyBnbtnosvdOdve1Jotvcsj3PGsYHMJSDuzyIYVlT/sn7BLq8ei538AXk+FvzH9MqwJvOLZor/P7qLY8hcb5JSNuqy0bXgTg7HuDB4IezMfAf9IXTcaS+H1j1AuZMuBMV+ZYUr1HIHZttY2gS/WIUUdOhVUa3XTMfVEIRwyUjOpXdGfzcBece8cQGlbQ5mYxzLbEoryB/IRliZwD29Z61hoXItrG7PjeR1WDIOfY8EVh3Y1gv3uG2v560AjUtsNROeeXGsRe+8B6yAyZgViNorAdsnqouDFLyJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 1:07=E2=80=AFAM Hugh Dickins <hughd@google.com> wro=
te:
> On Wed, 3 Sep 2025, Paul Moore wrote:
> > On Aug 25, 2025 "=3D?UTF-8?q?Thi=3DC3=3DA9baud=3D20Weksteen?=3D" <tweek=
@google.com> wrote:
> > >
> > > Prior to this change, no security hooks were called at the creation o=
f a
> > > memfd file. It means that, for SELinux as an example, it will receive
> > > the default type of the filesystem that backs the in-memory inode. In
> > > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it wil=
l
> > > be hugetlbfs. Both can be considered implementation details of memfd.
> > >
> > > It also means that it is not possible to differentiate between a file
> > > coming from memfd_create and a file coming from a standard tmpfs moun=
t
> > > point.
> > >
> > > Additionally, no permission is validated at creation, which differs f=
rom
> > > the similar memfd_secret syscall.
> > >
> > > Call security_inode_init_security_anon during creation. This ensures
> > > that the file is setup similarly to other anonymous inodes. On SELinu=
x,
> > > it means that the file will receive the security context of its task.
> > >
> > > The ability to limit fexecve on memfd has been of interest to avoid
> > > potential pitfalls where /proc/self/exe or similar would be executed
> > > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > > similarly to the file class. These access vectors may not make sense =
for
> > > the existing "anon_inode" class. Therefore, define and assign a new
> > > class "memfd_file" to support such access vectors.
> > >
> > > Guard these changes behind a new policy capability named "memfd_class=
".
> > >
> > > [1] https://crbug.com/1305267
> > > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google=
.com/
> > >
> > > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> > > Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > > Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

...

> > Hugh, Baolin, and shmem/mm folks, are you okay with the changes above? =
If
> > so it would be nice to get an ACK from one of you.
>
> So far as I can tell, seems okay to me:
> Acked-by: Hugh Dickins <hughd@google.com>
>
> If I'd responded earlier (sorry), I would have asked for it just to use
> &QSTR("[memfd]") directly in the call, rather than indirecting through
> unnecessary #define MEMFD_ANON_NAME "[memfd]"; never mind, that's all.
>
> Please do take this, along with the rest, through your security tree:
> mm.git contains no conflicting change to mm/memfd.c at present.

Thanks Hugh, it turns out we ended up having a discussion on the
SELinux side (proper return values for error conditions) and I'm going
to hold off on this until after the upcoming merge window to give time
for that discussion to run its course.  The good news is that gives
Thi=C3=A9baud an opportunity to do the qstr fixup you wanted.

Thi=C3=A9baud, are you okay with making the change Hugh has requested?

--=20
paul-moore.com

