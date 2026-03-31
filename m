Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DAF10F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D98F6B0099; Tue, 31 Mar 2026 12:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AA46B009B; Tue, 31 Mar 2026 12:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7B06B009D; Tue, 31 Mar 2026 12:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1F06B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:10:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3806B7D6B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:43 +0000 (UTC)
X-FDA: 84606846366.22.ACE90A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF6804000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WbyW5WFT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774973442; a=rsa-sha256;
	cv=none;
	b=ZgVEE/+/aOgNOWo/liRGL5qYDBaBTEAp8v4Xh6oq0u/nIUuG8bSqXCHGZUazpJI6J2NVey
	pOILb1wqQpR10au0cj+pUjSlninJDhS3szOzJztg+ATcOlKE1tZ+s7Cpzjx62VHosyWmfy
	6nGyL0jMu7Ku6H+L0JVcUVfiTkNf5QM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WbyW5WFT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774973442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpJzRi/dfXt3MjyImNXLRlCw/h5u6Pv3WS5qqFf2fWE=;
	b=Nz8Vgrw0Ub73cC7XOhaJG7oxfCNUqOAnVHfYnIwrKC09tu2typUgFazzQ31ge+DB7wRdlI
	QpiRbocOg2jpCIvtlKu6Xeld4LLPRo56HNuUdLtYdYqnYZAHzKVZzLDHMue0YAJxhNZopD
	1zVr+m/HAgN3SHFSye78ZSeVZGFOnKQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1D8E44010
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FB2C2BCB6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774973440;
	bh=F6Dn6HjDyhVOjbwalA7j6o20tmUhnC1lY7ExPGaI+z8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WbyW5WFTQBj7luC9mh6/1p3a55iauMAjvSqcXjnUztxl1emAOdXdVdoH13oVKZqiV
	 EJkYqjrOEhUCNokcnLpwwkHQuxHugKaOHeMFiTdnxs+gy81OnoYtoUqVOG1YwNP5SI
	 aGcGmt0ywuc5CauPG21h8q3mzVxkOeSmYRTNu5auM0DSsVdIqO11vKLWN2qu4CpR9J
	 idD4MsjqfWk303Xcw54t+THjDslRh6JmdJ0VOl+xSCslWvEfguxUENVihdu5L0Wk/8
	 iIFcjQQFBv6eZZg2DIX8y3FiXI+dqgYZhw/hlNF6Oa4pwQ8m+c3HpPmBlQpeiRA3Pk
	 rW7fkgCscrKIw==
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64eee7b83cfso6682694d50.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:10:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV0ns92zHngXXJhIaXEZqxyGBwBfN1P3N8DHuaMIUwU5PybYIO68MJeQ1CQ6LBizvTYrmUkexKcSg==@kvack.org
X-Gm-Message-State: AOJu0YwKqwClNL/+eKLfhOuCLVKvvyEws5e88PNUWGuoczsMamEsOWja
	Qv3MMX47cWni/ZiPYt8S9ikEZ/ztH0yPQVWJOJk1N3K4Zbwggevm8mzhtkxDbAV0tMhhHprF+xM
	CD8X1gnvzI7EIENO0p9F53cspyPQCoiMlQ75q5ADAow==
X-Received: by 2002:a53:b178:0:b0:649:ae70:a19 with SMTP id
 956f58d0204a3-64ff741c8camr12486731d50.55.1774973439949; Tue, 31 Mar 2026
 09:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260328075812.11060-1-21cnbao@gmail.com> <20260328075812.11060-3-21cnbao@gmail.com>
 <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com> <CAGsJ_4x97xHVHCtXi7v9wgbjRpOO-LaC=SsNsYQ5tJf5_Wc5FA@mail.gmail.com>
In-Reply-To: <CAGsJ_4x97xHVHCtXi7v9wgbjRpOO-LaC=SsNsYQ5tJf5_Wc5FA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 31 Mar 2026 09:10:27 -0700
X-Gmail-Original-Message-ID: <CACePvbX_uaGizMFOsRHh8MgqW1yJjrS1qXnADLzFq=9pV553kQ@mail.gmail.com>
X-Gm-Features: AQROBzDADBpMPFNTSA2SWfdQ-XZfri3rtWtqBweKR4gswYd3-nteGrFm1vLJY8E
Message-ID: <CACePvbX_uaGizMFOsRHh8MgqW1yJjrS1qXnADLzFq=9pV553kQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, bhe@redhat.com, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CF6804000E
X-Stat-Signature: d77qpyrtmi8dczkgggh1kaa9hii85jqb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774973441-965601
X-HE-Meta: U2FsdGVkX1+ybNnUXtmRlMhA0CmLGGpUklnrSvS6eXqGIfDYsdte2Z19lJqTfoeExPhB4vbOOkYCGmU+XQSdOCcDL+K0xamNU+2hKqO/Jy0zAleLK0I4tz7ZKZ4CK1Pqad7YloehHaC11BwiEXcH9fjZGbv3j7JNQFGoMhmUKuZoEDCEpr45T3yx+TGo3914is7Y7gmYSyZdknWCxN3T9COKR1uATfX68DwnGUcX5RBIPt4mlZAoRpCeP5yCkCJohcOZQxmt3VGBvO6MdwYKdWWTxXlewG/8vcNX30M6ZFpFde9xr2jK/oCu81JV9J4Bz6dX9uu29uTGKFaKD43kAgWt773SP12V5r53VW5VhsoMlyRO21NfwsYeo9JHC7tjFCAeG6Iy6AP1UkmlXr9kd3nZ1UlKZvtLDuC5HGJVqHfzYQGB5jzUWETA8Bxq4gBvxAEwRhZrglh8VeC+DQ9yoburTAXNUuOlq+KitTKLKGl8wCsLOdVLUxKTAvTcEEUBaTkRMf+OyoV1fAoKK/vKxgAHDD8BkRMJzhOvhykg7RD7Ct1fumvI2QI34ftF5vzRwBzWlxDpb0HwBbHx8eO3EoysNRS1jIuvkAxT5nhab3mC7+lJaL4PzqnZVdKRrdVOe6eG7jkh7Ql9/VIDKcuQnrZuNHXbz/XxND5CUn3Nt6MZWCXnXhtB1zN3rIm444XC414igxxCyXDrN+Ij+DCYJcF++Ftp21oGvKctMeC9Y5gj2pLkTIOU+njC97ocmxzbIU/gniHGn6pzLdQnimaVWJyLgwUItJ7JHwxNBWjjlsaMEC/EqvFBmvZef1UUGQVd5iqVRfhDG7j/gdGj3RW9/eUJLO5PWdHTySaS883e/RX9+VSCOzabfKqiox3KMqiRUdOKAVyje3PLOAOQ1q9SycUo/gL2WwClUTqeUc4RVtpzMSikQsAv8YhPsYMpzZn1BQtQmf0uAboKerXcvCT
 WFODbogd
 IcOaC3D4yXQXftnPRIg46vbt+BjEgo77vPNkGIjuwKjEij+nmkzKrPWhA+kKsZysiaHz7rrZrS0BxWWxuqaQ0zuI8ORGs5dTEswm9R8iI56Rzd0oChl2rt13S3lbufKqabyW4v47vkMtydTvoxSd/1dwF/EaTLMbwRpy3MW7daGZ3DfrBX+Ol0em6Ll+1yJ0x7dGDkvhkfi/us5Nopw4r0TH3yoK8+wrguyibhkF3Bi0Diynw6t/olyuXcVeQvEZbWxQoxK8/86F4SL2NrhqT0HHGiNdExQ+0AOU/kngomlGv0Y2XAEPbqcY3QvjKumqVYJpgZaJ0Z05FetHYKd2VjlLV7JXakVnUUBZzdqoBIjl+faVjH5WTDWbmXIz414Wdr2NDkGx+0IHRgfKyHDrdMARwZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 2:22=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Mar 31, 2026 at 4:31=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Sat, Mar 28, 2026 at 12:58=E2=80=AFAM Barry Song <21cnbao@gmail.com>=
 wrote:
> > >
> > > From: Baoquan He <bhe@redhat.com>
> > >
> > > This simplifies codes and makes logic clearer. And also makes later a=
ny
> > > new swap device type being added easier to handle.
> > >
> > > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > > and bdev_async, and only operations read_folio and write_folio are
> > > included. In the future, there could be more swap device types added
> > > and more appropriate opeations adapted into swap_ops.
> >
> > Should add that there is no functional change expected from this patch.
>
> Sounds good to me.

Ack

>
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
> Right now there is no possibility for any of the ops (read_folio or
> write_folio) to be NULL, so I was using VM_WARN_ON as an assertion
> to catch bugs in kernel code.

Ack. Someone might register a new swap_ops later that introduces a
NULL swap_write_folio. The check is for catching that.

>
> That said, I agree we can return an error earlier instead of letting
> swapon fail later.
>
> I think it may still make sense to keep a VM_WARN_ON in
> setup_swap_ops() before returning -EINVAL or a similar error?

Sure. We can just print  pr_err() rather than VM_WARN_ON.  VM_WARN_ON
is nop when VM debug is disabled. It is a kernel swap code bug on the
swapon path, so the back trace portion of the warning is not very
valuable. A normal error print will suffice. Because the swapon
failed, the user will notice this error.

Chris

