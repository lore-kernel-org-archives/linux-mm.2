Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73971FAD3E1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 00:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5FF86B0005; Wed, 22 Apr 2026 20:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10566B008A; Wed, 22 Apr 2026 20:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4DEF6B008C; Wed, 22 Apr 2026 20:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A92F86B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:33:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 415F0C1962
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:33:47 +0000 (UTC)
X-FDA: 84687947694.26.D16F7C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 677641C0012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:33:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EoLLOiFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776904425; a=rsa-sha256;
	cv=none;
	b=SL+f+38LqRWTcWNHP7zMV3ksqAsFNo9cOP0aznquapFdXLk3Gufr3qRxTyFUTISitoOBmt
	6qTNIFUqW8h1AxHoEkqHzYJKit9eCo0nndv+JFIV1nx2ako0m6NxVNbIlnEJAIqCNOiyaA
	RRhv4aXWIEC1/uYeVFpQTmpB+hYSmQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EoLLOiFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776904425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9ByRW/TEk5BA31HnKFkkSQprxzrSKMeADXzDfxa3f0=;
	b=1KuRsYJkw3vstKuqbsoL01C+8jtmqw0xpEDiR/Pgv/5sGGvRoyIcVPp/v31s/QM1jkZsDv
	sC3kqGGPaRnyDBLYHV62dyzoQVfafwJn0YgXc7XKX7Ma8yCik+5s8uz+Rh7CG1gHlhuAOg
	UqBgBvnppmCRvVWbSFp5Z6YfDm1JwmM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A59676183D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E05C2BCB9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776904424;
	bh=YFcpm1Q2IEqSIizxpG40qUfklzA44nCTjWRmWInHJ50=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EoLLOiFASH/63sE64eVfVLIOEbfRV96kbmC4VrUvH4yMEVwrEiw8yUQIKLqOLgAaN
	 Nu24G1HjVtlW+Cg/8hC6iR8C9K/nJnI4Ryajt7KHdG+FS3DUcsp9LloBqXPub6SfB9
	 3kFFEvWSepb2VAMhcBYIhvCMC8K9j8suP/O+K8PeYNoG94fJUn1Ep0OtuHX3Rx+Ewz
	 Q7KQ6m8nTdqHe/82OlojK/owwTEdUan56EGhFZIieFqfosN9Ah/J9m3kN91ZVJiJxz
	 N48yREmPDAsOrE2ifOrW9dFWQWdwuLoxmAUZGkkvS1t5J8A1zQmvJ3yB3p16PqZ/5B
	 /pi2xHiYpzWqw==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6501d242e3fso5903556d50.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 17:33:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YxASYWwhDUNK9xzTW+rMRuM+jvjShhMS2MEm0Yp7gLVl0tF+osm
	R86lny0y4p/bnkL2f1eLgxB6F/tbrGQfGXd2MPKHJnWBDDYVlTa4LM1FL1WLqGcjev8KFFtL00/
	cHm65wvEWClQQCn92pRf6fKBcD7qzq68qVqv05TPZ2A==
X-Received: by 2002:a05:690e:408a:b0:654:2882:42ae with SMTP id
 956f58d0204a3-654288245cbmr14523945d50.25.1776904423511; Wed, 22 Apr 2026
 17:33:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
 <20260417033951.1111038-3-baoquan.he@linux.dev> <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
 <aego1T9d6PVudYqj@MiWiFi-R3L-srv>
In-Reply-To: <aego1T9d6PVudYqj@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 22 Apr 2026 17:33:32 -0700
X-Gmail-Original-Message-ID: <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
X-Gm-Features: AQROBzCXNkRuswSYg5pgaKJzL8SCIfc5cKXNShZru9-WLK9_BID2HRgzyPIHEpw
Message-ID: <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 677641C0012
X-Rspamd-Server: rspam12
X-Stat-Signature: e5bp3ca37gehp4amag5i6zjee38ma5b5
X-Rspam-User: 
X-HE-Tag: 1776904425-28454
X-HE-Meta: U2FsdGVkX1++2i9fRmwPQMs/VxE4q6a88HAlhanMU5ArVx0q0lMr83r/B2g3yY19mKeLxWaUhZbabr0+2e3Rc02N8P7NTciD5PMsLzlGNmAlWlYCqlbIgjxXxcmWRLdw7o4/h2D4uh2Lzov/fmh9NWtXUPvG+tgMTR0VE185hU0oWRQgPNcfnmJsU4U2LBKY1cS2dGjbRYFj45IolzAMSNwdXSDs3Lee2GU792f5mCawFvhEP5qGvZbkGvauHji1ETkQ63zkgSAFemjRWPHiDnh7c+17oGqO4JWMTV6di+bx1uotta87MHij3y25bm0WwbQiifV8G+HqBpySuplrf08PPJpW8hsYR4LYbyibMT30r51lIoB6R73kYPVxNU4bitUVVSjOEnxeN/Su55QPj5kk7/vBCubt+vTDZrYWg6Z0iA9yEebgfnmV4f85i4FDcHu7DT7/4Bmgs9m3t32nYJLmRYV4r2mGK6PdgDfiivW6azvpPNFUp76neRpCOqsWofsh3UFGKAVnxyzSX4uj0vscNzDJ297h6zzJ6cbAKqzATGd2ecYqMUPWf4iwTnqX+OdW2ZRpyEFdo6uDD4JCPnXKIoaeHe9vRRiVwpzBUZGrLjNmtr0ql+hqd8Quanche9/uosZSgGhdikLmLwO83h7dMqxjixVWfZ/sxk2Q2tQp6uFAxsJaAb1wgCM0a+SHVY6cI5mEaOyVyQ4tw7STD1owy8dHy4no8KPSI6HRahnRpmg+hmg6V2xPaUQGZIiTQOfrSpXiIu47k4BHv3VS36ZtIZ3EbbePjNW5M1mJy0ULIh8pYaenK5t9gbub6hIZ5nB8FISImk982roVnZyO3jXaixeMl+QcY+obvbTPSFZRaDHhtZoYfmwd/GPUdiyRqW77FIjZKgFzy9nd4FanspP2E7JInyt/7PluK7j3NmZHyDVwUUjt5FllEZRFGnjLK8nK1/48yIFK0uWuQAs
 5qDG5c58
 fY8oMgm+x2c5+r8zGHk771o9edFh6fS06gJESNJSq/7m1RsTs44Jk+NpCMaN+jQY9fgqUcPkQ67t7ofMllyJBZ5w/DZtbmF4XzlrOhg1VSkHYCrm2F/YBdiguEp4q1TjHOx76NxDlcm3xlfCTQiMJfDMLV9rtnzQqXsDV2zSoW9xpa0l4a0wBpZ9FarXLfOkNWDbGpW6IdgAeqoHfDDNwOSIUpqxI1li6h0+/YM0og1ohM7HhI+9c9mm8mzt6OWFA1GSReCMl0ytSPWrKqllf52sFkZTCheExHwkoydAbQTC+SbEA6P85E8n2x8kOvOmgiO1oNMSkHYzmjWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 6:48=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 04/17/26 at 07:30pm, Chris Li wrote:
> > On Thu, Apr 16, 2026 at 8:40=E2=80=AFPM Baoquan He <baoquan.he@linux.de=
v> wrote:
> ...snip...
> > > +int init_swap_ops(struct swap_info_struct *sis)
> > > +{
> > > +       /*
> > > +        * ->flags can be updated non-atomically, but that will
> > > +        * never affect SWP_FS_OPS, so the data_race is safe.
> > > +        */
> > > +       if (data_race(sis->flags & SWP_FS_OPS))
> > > +               sis->ops =3D &bdev_fs_swap_ops;
> > > +       /*
> > > +        * ->flags can be updated non-atomically, but that will
> > > +        * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> > > +        */
> > > +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > > +               sis->ops =3D &bdev_sync_swap_ops;
> > > +       else
> > > +               sis->ops =3D &bdev_async_swap_ops;
> > > +
> > > +       if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_fo=
lio)
> > > +               return -1;
> > Nitpick:
> >
> > For int type error return, you should use  -EINVAL or some thing with
> > error code. If you don't care about error code, change the return type
> > to bool instead.
>
> Thanks for careful reviewing, returning -EINVAL looks better, I will
> change like that and repost.

You don't have to repost it as a new series. You can post one small
incremental update for the -EINVAL change and ask Andrew to fold it
in.

Hi Andrew,

I think this swap ops series can be merge to mm-unstable with the
review. Keep in mind that Baoquan might have a very minor follow up
patch relate to -EINAL error code.

Chris

