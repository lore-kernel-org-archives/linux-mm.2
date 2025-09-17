Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9911CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 22:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E558E0089; Wed, 17 Sep 2025 18:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEEC8E006B; Wed, 17 Sep 2025 18:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD49E8E0089; Wed, 17 Sep 2025 18:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABF7B8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:58:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BB881DF286
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:58:55 +0000 (UTC)
X-FDA: 83900259030.17.3E0C1F2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6287840004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:58:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aBVql2c8;
	spf=pass (imf12.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758149933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=it0hw7STF0VKiuKn78g4szyYtwsB+CgMo5LILw/Kbs0=;
	b=tfXJlnckVtY7lemeNBP+tDgLvR89cFCA5hGnMYf67njGx8VDPeEGdzeWgdJwtKzJQL8sHL
	PV4I7rNPKKMc1aSnKOIOWQfyVxNVGvXwVCcHWNCBT/V8oHI5sJ1jFCxgF0nj/wNqg4AzhA
	8mb+KVBAeg8ncJRFDSSQWsLX716wIdc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aBVql2c8;
	spf=pass (imf12.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758149933; a=rsa-sha256;
	cv=none;
	b=eaVmxGKKhr0ruwmimPsBWvfBbU1hYnx1WqkLIYBXyRpN05zZ1qKAWgmjOy8mbzbXO06z/8
	tpj/kq6O9GqM5UXzgAFto9OyNwGcCAOoJrNIM8EjFWwtaKopQh2rTjLaGu9iQpZLVuRIqX
	G6UYu9TKq5tKB2TmukL7TVaY6pM6gsU=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso438308a12.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758149932; x=1758754732; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=it0hw7STF0VKiuKn78g4szyYtwsB+CgMo5LILw/Kbs0=;
        b=aBVql2c8nkKNn8AaWDBZzZ9eFoE+VtgsOssqx9Dkr8VJvfOy0cfZJxaQr4baCug/Ef
         8ZRLLXT4Zrvsm2ol94NTiZ5VFcG+kuSHqWW5dt8k73JfUBhWRoIT/d4mGH/1yhCcdrDc
         SCuUzLQbBxwfRkBv/IaskcOM+6rQEMuCME5fq2dcCcm+88eF7RxonyfZS+uXqIkd6vOC
         Pxf3NAW0eeuTeZV7O2I8zRVYy4sJKESbuXWefKr51Bt3USHtYySNEfRmN/gMVCHH4bd0
         nPduSBttphZkHS013pOLoAf6FKroFbqfD5ewRrZTm7jleo/G+/KWQJ06w3sfp9DQHjs0
         D19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758149932; x=1758754732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=it0hw7STF0VKiuKn78g4szyYtwsB+CgMo5LILw/Kbs0=;
        b=G8T1eXxhhJvL2V6YLdy1j79wj/9/vzdCMYKnrG3MyOjAZbinhq/rJzln5N0/qfNeH5
         DoVQ6MU79LXMVYDdRwZ4E62TN4WQg8JNZ5ZnMeyIZmo4yZvrCI/+FsVluZVBhyvQa/Zn
         Ti0xVGPTtJ11he/UTK9S+E2vzIc0r4ZimS4N/xyNw79Zdt2Q7XvMyLYGb9eLwS7dimhB
         Aw7ws1gx3gyd5JZ6lUe7H9eyh9xLQJVRr+PON4Y3SmQJcinYWV2kbEgOPZ3f5bvbZ/wi
         Yr54lJcbmWlqth8rDFdHCruEm4AAiavpTF3FZz7f2XSMGuJS8ikyj8t0KI8zWKeokom4
         nKOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcY8WSjKcjTi3oGHKM4q7coPJw6EdSJBSxbv2Yjd5HKbBWE4WfYXcWTbidF9GZicM5z/0Bmwy8hg==@kvack.org
X-Gm-Message-State: AOJu0YyrMWYU/7lhKkQWJ7SBlcSFWeJ/3JrH9ihYiuH0fn+AYBIDD1+5
	xPP7AvOpbnCFunKyJs3Gomto1l7jNrsvCuxB/yyeTnatLMmsmq2ZJosccCLRvFxyRjaN7GjOLtY
	fLWibrur+TeX3KqViWHoNLBSHaeHFJY4=
X-Gm-Gg: ASbGncu7Az14fnVvsbCeTEXD2fCd0qzY6RUGCAQflTKMD7WOC0l6cymvMBNuikKHxIp
	ne7Xhq8Tye4n4FzAgV87s52TQrg1oweybd+kYihH7V2e82xCVxHP6U+mOGSanGIaj+JSNYvHja1
	yC8/p4+es4LIz8UFvHXfvk4BNFMgwHgHuVa0GUtKP/SBtUfPLPoI40Rx5dWJpYOQD27IRJ1WudD
	HCMRi/8kUMgQsFkh98wLZFxSuKB03BYtAZJ8H6Ca6NgPq3qZ9J8GxbBbw==
X-Google-Smtp-Source: AGHT+IF5Oo0BBvrA+aww1rEutWij2SvX5Gh4f+3J9obY0bllBpPQD0meffz5TJgyN0dgQ74slyUif+t8TL+R1MHOPhY=
X-Received: by 2002:a05:6402:a0c1:b0:61d:249a:43fe with SMTP id
 4fb4d7f45d1cf-62f842322cbmr3728400a12.24.1758149931621; Wed, 17 Sep 2025
 15:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV> <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
 <20250917210241.GD39973@ZenIV> <20250917214229.GF39973@ZenIV>
In-Reply-To: <20250917214229.GF39973@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 18 Sep 2025 00:58:39 +0200
X-Gm-Features: AS18NWA2xDDd90TP4hQffjy7fu0y29jV2cuqbrh0s-lIAc7yHea5fW1K7iRdEx8
Message-ID: <CAGudoHHzZ1DEEg2YHT4_+48-Y1gc7=uW_gOe3c0o6wsm7pWEXQ@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6287840004
X-Stat-Signature: qaarmqrbkpym31dqtu9ysu3qzxmdjnfr
X-HE-Tag: 1758149933-89425
X-HE-Meta: U2FsdGVkX19VabxFwKM46HBV1nX5aJpwVg7/N0Sdw3un/VFz/wXrQVtfQJW9wMVySz0cBEpZCjg2CD42UOeJE48t6SHq8mF7lRK3V9/qvqFzaBSVAjSPhK7BaCbIdF8utGsiHLyoA4Kd7p4FpcV7IqTtE+X4U63XFgDjhUk37V9y4da9PIJ7c4MolGKVtHhsubKhH7cLQ7/J5i8WRVCsGvFJMVxakAjjuRiJ43PdKdUpM75ToH9PVDIRe3+wi1+jwRI2PUp2ah+dTSTpvxiEoS6apMI8JUtgxJ6zD/zTg+/GEqoPFW1An0kx4huChLRTHYCz23U53R0vgRSSFN0q2XLTRjAqLAS6OIWYiBi791SAx0h1xjLQkd9b2kEnGnk2CkTeJSXuqNf2rXJIl4JsZdL7avdcB/8G3fIzkHRR4+JdwIq8zynK9QmuQpDiB3SCciXoL2GQWu8WB6D2Or0isgvu96Mj3AB4ItLnoF63pli7SZ9dc2+7bl85527BvVIwUuneU+7P2UWw76BFL0KXH7SFddyxuwHDvV71lpx9wvHxsLBJcXlDLNIg4+GbqTZTEgT+p/Dl/0FvZeFJjcdF9x/suOv4RYoJS4YnoJkbqbM2UtnnykoampiLnOIUIlU/JKaa2/k9bBKVXNjwDWi+JlNb5le9l4OI5ZHQlIxfeEFAmU1GPYfTC+RdLB6B+PNVWpy7RL71XRf5V+VSpQUB5aEQWfio96YK7xxnur1FvmlqWWUXz4s6IkerlzVHH/yr8YoQkVEtojuNRjvJX54aWthrUG2depjhR6/iY2o1SL36pny3aI8opq4bvXFT5xoT5b2S2CPbN6c/BJfQQqH2sIzgC2xZA1vjZvOsjouwU4FvnsxlBsWamj55gpmGF4TW9hgSkjf2acKxznWiSSYs2SFEVeIq72T5ulhdYbMoQwOu1d77alLFgbM+VfzqU4bNfr7H5x/cv+LgRlWDQT3
 SY7DhhFz
 uSYZFHNfRCChMlentSI7QiOXUwfAR+C5+L7vVymWyXTrbLtau/EOcnM3J6eQf8vadnbgLv5/MhpHUiR9UPBTmCvlJ/nTopYFHsRWRHQ6hdO0ChJrsZMVnU/l2yRSwxBCHDfgs+AHgeFE20gOXyq4sFN8VyEakxtohSkWJaDeqxHTzMju6xAdQ6m8q2DTuBEi5KrbLB2fmiRAaLXVyAtb4wb8v5Z9rraebHtZSzkFYuhgVfaqSVEo3q37DIVvLFAyb8g+el7VUgdBRtBxyaNq3CbGTjqMyHQxXvU9yOZZSnRjjqbGdzooCHli5gNUDEdePDiGy+frM1xOlXswODbvHbVCz/0cMr7ZxtthbVdOPoAqAfaS6zQxQfU5p1/B4704WGxu7V8UvCnE5+kEiGUJ1LVbKilbkcEaKrHNB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:42=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:02:41PM +0100, Al Viro wrote:
> > On Wed, Sep 17, 2025 at 10:39:22PM +0200, Mateusz Guzik wrote:
> >
> > > Linux has to have something of the sort for dentries, otherwise the
> > > current fput stuff would not be safe. I find it surprising to learn
> > > inodes are treated differently.
> >
> > If you are looking at vnode counterparts, dentries are closer to that.
> > Inodes are secondary.
> >
> > And no, it's not a "wait for references to go away" - every file holds
> > a _pair_ of references, one to mount and another to dentry.
> >
> > Additional references to mount =3D> umount() gets -EBUSY, lazy umount()
> > (with MNT_DETACH) gets the sucker removed from the mount tree, with
> > shutdown deferred (at least) until the last reference to mount goes awa=
y.
> >
> > Once the mount refcount hits zero and the damn thing gets taken apart,
> > an active reference to superblock (i.e. to filesystem instance) is
> > dropped.
> >
> > If that was not the last one (e.g. it's mounted elsewhere as well), we
> > are not waiting for anything.  If it *was* the last active ref, we
> > shut the filesystem instance down; that's _it_ - once you are into
> > ->kill_sb(), it's all over.
> >
> > Linux VFS is seriously different from Heidemann's-derived ones you'll f=
ind in
> > BSD land these days.  Different taxonomy of objects, among other things=
...
>
> FWIW, the basic overview of objects:
>
> super_block: filesystem instance.  Two refcounts (passive and active, hav=
ing
> positive active refcount counts as one passive reference).  Shutdown when
> active refcount gets to zero; freeing of in-core struct super_block - whe=
n
> passive gets there.
>
> mount: a subtree of an active filesystem.  Most of them are in mount tree=
(s),
> but they might exist on their own - e.g. pipefs one, etc.  Has a refcount=
,
> bears an active reference to fs instance (super_block) *and* a reference =
to
> a dentry belonging to that instance - root of the (sub)tree visible in
> it.  Shutdown when refcount hits zero.  Being in mount tree contributes
> to refcount; that contribution goes away when it's detached from the tree
> (on umount, normally).  Refcount is responsible for -EBUSY from non-lazy
> umount; lazy one (umount -l, umount2(path, MNT_DETACH)) dissolves the ent=
ire
> subtree that used to be mounted at that point and shuts down everything
> that had refcounts reach zero, leaving the rest until their refcounts dro=
p
> to zero too.  Shutdown drops the superblock and root dentry refs.
>
> inode & dentry: that's what vnodes map onto.  Dentry is the main object,
> inode is secondary.  Each belongs to a specific fs instance for the entir=
e
> lifetime.  Dentries form a forest; inodes are attached to some of them.
> Details are a lot more involved than anything that would fit into a short
> overview.  Both are refcounted, attaching dentry to an inode contributes
> 1 to inode's refcount.  Child dentry contributes 1 to refcount of parent.
> Shutdown does *not* happen until the dentry refcount hits zero; once it's
> zero, the normal policy is "keep it around if it's still hashed", but
> filesystem may say "no point keeping it".  Memory pressure =3D> kill the
> ones with zero refcount (and if their parents had been pinned only by
> those children, take the parents out as well, etc.).  Filesystem shutdown=
 =3D>
> kick out everything with zero refcount, complain if anything's left after
> that (shrink_dcache_for_umount() does it, so if filesystem kept anything
> pinned internally, it would better drop those before we get to that
> point).  evict_inodes() does the same to inodes.
>
> file: the usual; open IO channel, as on any Unix.  Carries a reference to
> dentry and to mount.  Shutdown happens when refcount goes to zero, normal=
ly
> delayed until return to userland, when we are on shallow stack and withou=
t
> any locks held.  Incidentally, sockets and pipes come with those as well =
-
> none of the "sockets don't have a vnode" headache.
>
> cwd (and process's root as well): a pair of mount and dentry references.

I groked most of it from my prior poking around, thanks for the write up th=
ough.

The real question though is how can a filesystem safely manage keeping
extra refs on inodes vs unmount. Per your explanation the usual safety
net does not apply. Frankly it makes igrab/iput sound very dangerous
in their own right.

