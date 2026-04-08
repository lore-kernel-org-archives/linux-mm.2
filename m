Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C54EE105D98D
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 09:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18FA06B0089; Wed,  8 Apr 2026 05:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167136B008C; Wed,  8 Apr 2026 05:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D216B0098; Wed,  8 Apr 2026 05:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E64726B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:27:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C45BC21E2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:27:13 +0000 (UTC)
X-FDA: 84634859946.06.8B668B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98DA5100002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:27:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0tRU8a7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775640431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5ka0MBI/NXno/qBif2caRlXP6SvU98LBqQ63GlDEUA=;
	b=ZGpBpv+uk7P6gx+77EgWo7neJ69APq/FXmT5s6LfVZTGp+gNLGvn7ZRqt4gQJ7GIn/btq8
	zGxgUaI6I1+p6ncQSBOxPpBTMgVXJeq5n4PUsLSLdBt/75Y8RFGJnZZLw9aIDjq3yFOn2H
	4S23RtUtM38K84eKSrPiYfHRkbDiDo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775640431; a=rsa-sha256;
	cv=none;
	b=k6rkXAgxY2LRUNFJNplgd9IVPylobRwAguJkGTOQwXijl/DwvPHpTvqs7naLldmNE63M72
	cpZrdcissw6an0Oo1azl8jjz38KseWtWi22EtD2tJBz+STyCkuZJaL+oHARab7TaYFc4Sw
	PX3Vr3pVWDi+5B04jg1aMHQfp6eEojc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0tRU8a7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9410E42A2B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761CFC19421
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775640430;
	bh=fgHXijjC8wwB0orWX7VexpNbX73CqRtv/Ev6hR9O/bM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=p0tRU8a7jpZKFAVG6hQN82Q9y8JgoplCEPfnZmKQcpJJrEYU07xSOR0+9xOkpVame
	 No11FMd31EaErMOYQjSJeXYNBb51QYRC81+yuxNXOxjfbjhBjeiiqFfi8jMchkNPot
	 hJWUqaUvUzRQu4aeHWbJTaJ++B77B+hE34bR7qtXN9AlusZsi6OeAZOjQK/ACWxrBl
	 onKl/tycFFNijraNYKD/KdjO0BpXOLUglXrwAIUAmfiUwd+HGTDZodLP6ri04KEApA
	 ZG3jAFDvjNWq0f9Gyb4HLkyzhhFlQpEXaXJuixi1aWsRzivg0L7T5nhfDpKRmSMYtT
	 DziAQBqxebTjw==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-649278a69c5so4695265d50.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 02:27:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUrjcVSAf/dPt5GuY0eJKq5Nz3lwDTrElNBH630FcHa5HzC0stvnt8rvRRaKUPkfIz1IKFBmdh5AA==@kvack.org
X-Gm-Message-State: AOJu0YyMDSkeLrFKUwaHwHaBQ6zIh2h900wHKX1e3ToRl29TBkctYlNt
	4+HT5pUKm8e3/4R8esI97D3LvO0vAvR4WfgcZbxn4OG+c4Ss0F3beRnnIiESFQHuWWN7jEYoM9I
	JEVS34m7JIxGuJj/ukS+bmHJmEZyuvENcQPnUK8vSWA==
X-Received: by 2002:a05:690e:4393:b0:650:335a:c31 with SMTP id
 956f58d0204a3-65048865cdfmr12394814d50.60.1775640429852; Wed, 08 Apr 2026
 02:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260328075812.11060-1-21cnbao@gmail.com> <20260328075812.11060-3-21cnbao@gmail.com>
 <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com> <adXxdLSHp2E2k6_5@MiWiFi-R3L-srv>
In-Reply-To: <adXxdLSHp2E2k6_5@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 8 Apr 2026 02:26:58 -0700
X-Gmail-Original-Message-ID: <CACePvbVwoqdOmMWkJUm=mqYQi=MgK+Q3NJu1Pxmmy9v61f4qEA@mail.gmail.com>
X-Gm-Features: AQROBzDF8Gb_q0g8T6YtNHlQ7Weuei8IYitDIUVYoCFYeYNmY7eYxhK5VBqb6bc
Message-ID: <CACePvbVwoqdOmMWkJUm=mqYQi=MgK+Q3NJu1Pxmmy9v61f4qEA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 98DA5100002
X-Stat-Signature: e8qemtdtjguzgu1dto3yuouu6i9ymygu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775640431-344247
X-HE-Meta: U2FsdGVkX18HDQiHoFTxrwaVGPCB8e9E0oXM3QgBIrQJKbodzpZwls8ZZA6L3VoS3jw3kiZvGn7tLz0fiGW/xuj4Y4qkTRKgEAnyXOefGLx0vO05hDsF6MHF04VUYVgVsPeYcZ7+aFMdyfkKcvKGRGkH44GhqOIVnwzANAxGNtIuYDOp/RJP/wP3KsIPCwmNHdblt8enxMmYo/OGirGXPph0alFAVejFbWjDXjHDyxB0SCZ7kLAMl22sG2KKfA8GP1S8YvNQtuJXs2Lz0/qQ8E+C0tNRYzHSpnCudTprphpy4GXNTPyrSNND26KsG25wHbb70bvWoJhBZor4qYkRY2+9t7qxf4100+Mh5lpRgbqWcmRKCUH3L5zHNlNHxzU5KPi1yZn1OgnZSqUTI7R6eki0tSOSbsuXIe2KF/C8I2vjKt0578hAGwVazBpzSrSqKZcQr9yM9dpSbK/ajBZN1eKiK4mqqn1PxWCs+5ZstS9UWSXDldeiitafp6IZhDnSsZINsl8Tfz0WjJUijtlbkvpDekTI0XGgyApdwBl0oecb2YUTh1TNA+yMbYcr+r52R3ooj6lxHq2AVxVX/wDQ8I3mOw0Tr2isVZu7ag+Srj7AUfUobUtVoRCoyXyLa+x6jq6wA/REjF20KlojXC5u7OI0fiWbfqxhDqA+xiCAVImbvN7fw1CwpkdNcky8lsnLxtBzGOM92fu8hPtDV4Z30UAOr9FtnG8yYkJutqcud5z8U7ZuF6NRHUByUKmEkCn9onZnn0CdQK8p1M2wCFopk4XolCqZnLiFM/FHOYwnA4WNLjVN3jxQCQUbb6UyfKSp48Uk8HPVy6QGHTAhoulqJ/QfeMe6uWS2MYVoYbERyokCb9TH80cukyckBn5Q4vP1qPCwVP2ZxJGuBMam81DhdObCh4T0Et1KFXqBjAXbVq0jjbYkunsym463eBc1j5+Xl0XhliLkbu/deI4Oq7i
 AoBNjwLf
 xbp4cO90JuGhd7w9fcw1i/vjBJe7s3HK8zpXgWl+P32E0LivmshcU//CbrpHrCh/2gpbqxSZO7KKsxqJMhuh1558EZu+RtzdrQt+KI0QZ7VyzxL4E6V8xuolh+tW5Z1Cn92/3ylkm6DuSSQX3tP5hV7+3OWYLuEKMlHfJuFcsAPU1xg25aFI1uNR5mB+vwRBBxyRqdTMiYPMu3FVfUwQ49bQ9d2rlIDRW5pD8TPlYuOwXpZFGQeRH0gWO43NbbcGmfT5jXYk2nxaKniBq+mG4pu8CR3vG80rbQSa78eBw5jafaUX9ldDWgOdTVePbMJ/ctmF8dCMyeQtZvEIugePjEyfkyT7p6hZpNmNV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 11:11=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 03/30/26 at 08:30pm, Chris Li wrote:
> ......
> > > @@ -608,6 +593,39 @@ static void swap_read_folio_bdev_async(struct fo=
lio *folio,
> > >         submit_bio(bio);
> > >  }
> > >
> > > +static const struct swap_ops bdev_fs_swap_ops =3D {
> > > +       .read_folio =3D swap_read_folio_fs,
> > > +       .write_folio =3D swap_writepage_fs,
> > > +};
> > > +
> > > +static const struct swap_ops bdev_sync_swap_ops =3D {
> > > +       .read_folio =3D swap_read_folio_bdev_sync,
> > > +       .write_folio =3D swap_writepage_bdev_sync,
> > > +};
> > > +
> > > +static const struct swap_ops bdev_async_swap_ops =3D {
> > > +       .read_folio =3D swap_read_folio_bdev_async,
> > > +       .write_folio =3D swap_writepage_bdev_async,
> > > +};
> > > +
> > > +void setup_swap_ops(struct swap_info_struct *sis)
> >
> > setup_swap_ops()` needs to return an indication of an error.
> > The error is that sis->ops is NULL or op->read_folio =3D=3D NULL or
> > op->write_folio =3D=3D NULL.
> > If there is an error, we should fail the swapon.
>
> Thanks for your comments.
>
> In the current patches, there's no chance any of these happens:
>   sis->ops is NULL or
>   op->read_folio =3D=3D NULL or
>   op->write_folio =3D=3D NULL

I am aware of that. Adding the check in setup_swap_ops() responds to
the WARN_ONCE check on op->write_folio() feedback.
In fact, we should never have a case where op->read_folio or
op->write_folio is NULL. However, I can see that other future swap ops
can be NULL. e.g. Notify swap entry free. It is hard to enforce that
some fields can be NULL and others can't. So having code safeguard it
is fine.

> Because it's a if-else logic in setup_swap_ops(), adding an error
> checking looks a little weird. I think it's worth adding the error
> checking in setup_swap_ops() later when we have new swap_ops added
> and there's potential any of above three cases could happen.

Adding the check in setup_swap_ops() is to remove the useless warning
check on the caller side of op->read_folio(). If you think the check
is not needed setup_swap_ops(), then it is not needed in
op->read_folio() either.
The WARN_ONCE() then kernel panic on reading op->read_folio does not
make sense. The check was added due to one of the feedback that what
if this call back is NULL.

I prefer to keep the `setup_swap_ops()` function responsible for the
NULL check, due to the discussion history surrounding it.
I'm also fine with adding the NULL check later. However, the NULL
check needs to be consistent across the patch series. The other NULL
check inside WARN_ONCE before the caller site op->read_folio()  and
op->write_folio() needs to be removed.

Does that make sense?

Chris

