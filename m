Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC15CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1D38E0082; Wed, 29 Oct 2025 11:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D458E0045; Wed, 29 Oct 2025 11:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6AE68E0082; Wed, 29 Oct 2025 11:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A61708E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:01:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 591C5BB33A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:01:38 +0000 (UTC)
X-FDA: 84051465876.07.1319C03
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B71120007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:01:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PyXzHKxR;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761750096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVozCklyMGutTzUIfKa2FFHEvZ6hI3sBOk40Zf+Xv1Y=;
	b=Pbnk4UyreSTnEM8K2g5nhwCa7puAApOVFj4PRgJoj7YEhwjpxh89hdbBJ1WNJNgCBEhzyS
	YpHwEhpR+1IFWKYnzKTn1Ax3sySOMVk1DAfr+F7fE3VvVxPqoYgFzzzQvm0SCi8PWzASxa
	zUd1AVDkMJ+GN7TZXKAOiqgggP53T18=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PyXzHKxR;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761750096; a=rsa-sha256;
	cv=none;
	b=F6tNoed5MlSm0/9nw7n9EW4Sscxc1OR3vu5FMrJDrDTIZuLVVsU8jRm3YM+7E2Co+3Pycx
	i51FC41fSum48vdvpGOxyc+zZpnA8gW88CdO5je4nutR17zxtOVjZl602Yj3N1VQjWBjLT
	JADUobOcJh/FGyDZ3Rmu1FKRmqvRXGg=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4eccff716f4so384381cf.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761750096; x=1762354896; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVozCklyMGutTzUIfKa2FFHEvZ6hI3sBOk40Zf+Xv1Y=;
        b=PyXzHKxRPfd2IA5hcwe/7unbZClQ5HhTbJxLfK4dIkOdfwjz3aWzXfSDw6ljLnMKgV
         GD6/LRzJiPdPrU3Pvbt8GYetptCJxBTRz8YmgNsF2NHwufI4X3Uk0cCktW0vBWw3rZ6V
         0deiaSsvRXXvSZrxAiWXSpEkp2fIJJnaO7KDqKZtEn2VO0mSl7EQSI4Sg19Na1TTNEM5
         fYj1YpBR0mJTQuKPw5H/iMjc5fQith87/0fPgr4VstWyCFSdH+DblMTW17VwFb66IX6A
         rMMyyc4jtAya/epQ4b0JXcmSdchLcN8/Kxu3hVxWRvHmeei6fiRQt1/Tfx2TGJUBx6K+
         3Npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761750096; x=1762354896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVozCklyMGutTzUIfKa2FFHEvZ6hI3sBOk40Zf+Xv1Y=;
        b=Suz4cMhUXO9LX58ehAHfxKheCxgd70Qi+cUacTB+Kwmryt4t0N1hn03D1ukqh7x+Pa
         GRqvAMxlnMW837wVtleJwD6Nt+GplQOLz/h5t05kDmx8ty8DlotQbPAqSospdYl+tLt7
         VdPqegP9Avokns00xIxWkDp89OirhxupggaM3yT4b/RljKYLS5STkIU2tgdI+YGEOnVh
         yPbXN3sSwTH+GEIkKIT4fmNADJtw04Swc4MNqH4YZP0jLKlgVPMNhjjBU+PXgkX1NeTZ
         EaQYsM53iCmwQiB+B800hq2AYR1u3V91GwN8fHXZGFk2EqkGLG+ElNqs2wzQ+HkF+L4e
         e0ew==
X-Forwarded-Encrypted: i=1; AJvYcCU+3SCy717NT/8hNEgE3X9DiFegWtxquf70VPzBMd/PSk1LVpDrmZeG/JS8mHWFxjCVQi9NysuTWg==@kvack.org
X-Gm-Message-State: AOJu0Yxpv7uAiAkyDZOQYHVOjDV7cloZnsl9mkTMKDcYNO/1Sd0PRIFU
	tCqgBh1CJdIZt79Z4j7JFi40MIWnClvgGk44VnVWVltoz9iNcarw4ISGXmiTsCG793Klw3KYtLr
	f4RKjKyh5onhYN1ce9QL+vZKQk6dcVDyXRPCVE8Ad
X-Gm-Gg: ASbGncu1v5h/T7UDWiDoPqUVsxGiC/l7JkCFRlN22ioRCQHik3pIWM3XvCbZZQ364bj
	Nsnx7Qn8jEJ0B9DxUvZ3W2+tX7qukELbWquUrUZFu2B24CfriIXwiF3cTfKEORtHc1oXFa/6Atq
	ow2Hvs5OfcenA/8bqJ8J0XIZvAts5Yo7rAnq8N+7/9pPTRx57arN9xWLvy4ZU2mkq2tjLsJqUVq
	phNHRdXccLvo5MTBX9eV+YyJPHExVXmCAWb7o9dm3nrBkNTp5AHfzxmdt/+3sFoNZlXSIaglK95
	J8eZCFOSBIm1/LNoqFORiiYnUg==
X-Google-Smtp-Source: AGHT+IHxSXs4Ljx2jn0yoPxmLLrrHglpLBSsCQ3XrhB6BeOLssdbWHiOnV0A9SgFcrBcHzFGMl0brc5X+v5n+od5/q0=
X-Received: by 2002:a05:622a:5a97:b0:4b7:8de4:52d6 with SMTP id
 d75a77b69052e-4ed157cfd4cmr7271761cf.2.1761750092250; Wed, 29 Oct 2025
 08:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com> <aP8XMZ_DfJEvrNxL@infradead.org>
 <CAJuCfpH1Nmnvmg--T2nYQ4r25pgJhDEo=2-GAXMjWaFU5vH7LQ@mail.gmail.com>
 <aQHdG_4yk0-o0iEY@infradead.org> <CAJuCfpFPDPaQdHW3fy46fsNczyqje0W8BemHSfroeawB1-SRpQ@mail.gmail.com>
In-Reply-To: <CAJuCfpFPDPaQdHW3fy46fsNczyqje0W8BemHSfroeawB1-SRpQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 08:01:20 -0700
X-Gm-Features: AWmQ_bkezv9FLJcwU5V7m6uud2WYPkxlH3WAp5Tp7iJo098Fnr3molvTshJ4AJU
Message-ID: <CAJuCfpFg3UKs_eY8eCuqS9oMrEA9N1em4wj8da7cotd3MgBweg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Guaranteed CMA
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, willy@infradead.org, m.szyprowski@samsung.com, 
	robin.murphy@arm.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, minchan@kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B71120007
X-Stat-Signature: nbqk6rh66ou975n1nmw85d7ircj51bmn
X-Rspam-User: 
X-HE-Tag: 1761750096-234932
X-HE-Meta: U2FsdGVkX19IOxG6YIbCsfbaM37PtLIuaTdGMxuQ67so3TGJ0+nC/96qZsdWBfAld7bM0icOaz8Ivlqq/Ihi3CBscLXNBCPtt61wdNov9jch9Jr0MwXIIy9sIxMdbQnI4GQvZWwPFIFGLg5svuRdVqo+a9Utr10AKc8WUFLiPbyM2FWRt3HmjoiNhGzFqqDGG8XdCrZm3AWZdjGmDOEZxRJHJD4qMX3lGCWA/F1meU1/Roir85i8Z8AI6NzojFH2T3ZiWGoiB6nDZ+eOf8ymQ86c+/6du68WISUiqFYZjK8ximHlpIyB85PNf3GIf+hubqbuDgRb19M9MaQZb+V664dAWNjZY+Vcjq5/O1Cn8Mfvf1z48ACxlMWhUji6gceNrfLSZlRZ6Cz9OZRXEpwJBu0aVO+1PtCGbGzPOy2M1Xx6zMEeerFCntx/bUcK4NWmJMsjsHjCgocAd+JYYlbur7uDme1PaM4rq4UZ+YTfdUNAT26NjAzheQdwxzTEtvPyD7OmwfgfjT/OB4k/rEX3Rt5Fk3M2iwSEWw3xVBu7DTXJ5CANl0DOWa7cRw71h1kqZ/2RHAB9+/2uwZOB2COO0FpaJrpg0bouuAYdRGZXDWw+YFN4/TeqY90NKKipxTC2KnaUP9fj9lArtgjFtf5D5Aq0QJV1CoyfmrJlPzeJrhFQRx97R3m91vhW9GXfrxCIkznXXs6XgjtZL1oG1gIZ25WDEPtkW2R/4qW0yrSkqjedUyRI5lJct9M9FneKRqK83w7KJ0YoW6Ao8NfD35FsOuJfU1GcKYXouoeM7MEbVNzE+lMpdCGK289koyePicLSrgO/BZwJnYovrtrWKj3p4s+BH3G0pv454BxQGqNbGZQPxc8zgBrg1iwYhfQ/Luk/UaImZK2REOl2Al7JgHzE8unSYTlb5owY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 7:57=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Oct 29, 2025 at 2:23=E2=80=AFAM Christoph Hellwig <hch@infradead.=
org> wrote:
> >
> > On Mon, Oct 27, 2025 at 12:51:17PM -0700, Suren Baghdasaryan wrote:
> > > I'm guessing you missed my reply to your comment in the previous
> > > submission: https://lore.kernel.org/all/CAJuCfpFs5aKv8E96YC_pasNjH6=
=3DeukTuS2X8f=3DnBGiiuE0Nwhg@mail.gmail.com/
> > > Please check it out and follow up here or on the original thread.
> >
> > I didn't feel to comment on it.  Please don't just build abstractions
> > on top of abstractions for no reason.  If you later have to introduce
> > them add them when they are actually needed.
>
> Ok, if it makes it easier to review the code, I'll do it. So, I can:
> 1. merge cleancache code (patch 1) with the GCMA code (patch 7). This
> way all the logic will be together.
> 2. . LRU additiona (patch 2) and readahead support (patch 3) can stay
> as incremental additions to GCMA, sysfs interface (patch 4) and
> cleancache documentation (

Sorry, clicked send before finishing the reply...

Ok, if it makes it easier to review the code, I'll do it. So, I can:
1. merge cleancache code (patch 1) with the GCMA code (patch 7). This
way all the logic will be together.
2. LRU addition (patch 2) and readahead support (patch 3) can stay as
incremental additions to GCMA.
3. sysfs interface (patch 4) and cleancache documentation (patch 6)
will be excluded for now from the patchset. Moving sysfs later would
introduce UAPI changes and unnecessary headache. Documenting
cleancache separately would also not make sense;
4. Unit tests (patch 5) and GCMA integration will also be left as
separate patches.

Would that be easier to review?

>
>
> >

