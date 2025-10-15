Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E083CCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B118E000F; Wed, 15 Oct 2025 02:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CBDE8E0003; Wed, 15 Oct 2025 02:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BABF8E000F; Wed, 15 Oct 2025 02:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13FBE8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:24:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA83BC0B32
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:24:07 +0000 (UTC)
X-FDA: 83999358534.16.6A50BD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 93CF840016
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:24:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LguhYqZw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwQBkK5MP8uO9TfxRW2SxI3uyVzzdbxumNl/s7tqCKM=;
	b=PaQJQMUdE8gWYUisd6iOMW77gSh4CRWssiog+AfeWM2IwSKL4eLcuj0kZSSimVm28fC4jC
	STkh/oJq7M050eDWkhhOwf7ek7ZiB+bP2Xdvc07mPuPH7gfyMrSLqpMk+raU4yGLjl4oia
	XRllahh1mt+jQajQrbf7U5Qb3gy2ezY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LguhYqZw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509445; a=rsa-sha256;
	cv=none;
	b=SkTs4TlCCoQYTVHNKdZO/d6z4n1ksm95zHeFHTOLlGaaKINr3sDZ0SAgrPu320+qlIvcJA
	1Q3GSIcb2fLnIEOkoW7KsBLAAAmthci6icWGBSvOsi4obPkFBdXRVjW9WxMxm0h7W/3p0S
	QVWw0OylMCGKwTAVoauFv29ArcEu8s8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CB0B43E54
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09CAC4CEF8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760509444;
	bh=vRdYvfgoWDFS0wBknQPyqK9ZgMXKvMoOQ5Va/xLLKS4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LguhYqZwRs8xcLUYStqZzqNfw+jvS4EEID93a/uBMWuZKN5JEqhfSn0vsVMYT8u4k
	 9q+MbvOV7x8DdrCMRq7ptjUe7YS44d/Csl90Js3VAq87LWTS+QjJJ/5Xbhi9wQP1nH
	 UuvLXFbdtQDZgo0WuSce0puF0Tclk80DGiBsayqPznvdL92Im68xa1tbyIyep7dOOd
	 cJVCO2VJ5uyf2+CNIh0p2NhEdNlLZBjBU6aYCvInzaefQmikloFLDQMaHAaPGCGL7y
	 c5+7+SS5+dYpCV3QYJX99qvPru5xBhmj4xJFq99KktU+0u1lj4BMd/6vD2MKbZQLxA
	 i+2mvROO+MzUg==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-73f20120601so61266307b3.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:24:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXidwC6oftz7WUeQw3PtRLKiJtS2ILvXKK/YAyx6qzFXA+I/GFm3tQspxx0LhsONzHCHy0Hcfjslw==@kvack.org
X-Gm-Message-State: AOJu0YzBIg4cRYyklDX8Axc7J9lB3tKhWP4ydu1LGxpWjusVfOCOraA6
	pJktoYBJchjYG5UR+/lxDTGKcMwMP/57BEpYc5QVbxQ3Q6w6pFMrRfUSRVms5mZqh6ASKVrXWo6
	ttBS6gQXjHiFjVNKdrYUn6uWqOuq4bLlD93fAwdzcMg==
X-Google-Smtp-Source: AGHT+IH7YaLKVUlBPiTgljeSy3Amn7ax8uTeXK7IfN5VTjpHpbG+7OjmkbfZ9Z5keMh6ujzoql3d8tiDH/hJOjPD7Hc=
X-Received: by 2002:a05:690e:204e:b0:63c:f5a7:3db with SMTP id
 956f58d0204a3-63cf5a70c6emr9641238d50.55.1760509443284; Tue, 14 Oct 2025
 23:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-2-bhe@redhat.com>
 <CAGsJ_4zvtdqzvBNmQjMy0L6JAz_XpvR=rGgNC_Xdo36QVW-g4g@mail.gmail.com>
 <aO8PuhNfKOQ8SJUV@MiWiFi-R3L-srv> <CAGsJ_4yv66kW32Lr--O8qWq3gbrwF110cT7MzqMWumRabFNj1g@mail.gmail.com>
In-Reply-To: <CAGsJ_4yv66kW32Lr--O8qWq3gbrwF110cT7MzqMWumRabFNj1g@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 14 Oct 2025 23:23:52 -0700
X-Gmail-Original-Message-ID: <CACePvbVDB9-r3dTTAJ8e++1swAt9=fPRK9ex_30L=FgXBe5BpQ@mail.gmail.com>
X-Gm-Features: AS18NWA1Wk-c-j7O1QWadgXZxHJ7te0PMG50aS6YlLBPGUSi4tM0iYNP5vEfA2c
Message-ID: <CACePvbVDB9-r3dTTAJ8e++1swAt9=fPRK9ex_30L=FgXBe5BpQ@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
To: Barry Song <21cnbao@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 93CF840016
X-Rspamd-Server: rspam03
X-Stat-Signature: jqk47iumcpcqjt9dwn164jj4tknu9d51
X-HE-Tag: 1760509445-919225
X-HE-Meta: U2FsdGVkX184vg/GsVy9zp0GbZQGtIjOXPQ/jqUHRQoPLhJEc5MzEdAQ94aspiaJDpR3sgnTNSgGIgUYwtZ/PuT9/49LdGV7OOSjUU7+FuWvpQWQN/uA/JdrCmyO5Zkipqn+tn2/6CTrO0CWVzSYHoLEHQhImFGQuDYX9oqTCBQHoKRoKv9dT2PgQe0K/e8wRBQ4tBfEhbqjP7z+teMc4ev6N5tQewO278JItJqD5lUpVbspYHsw8LLTiNXtUKXEY+av7GZ8ZVOZbx+5+lHZVAh3bC/p9m5INnUDh5zRIxiNLsiD/jxFFXc+nx7C7gDXdrtLKSWzAdvvb6wbptqjBmEJMWsnJ1oKP3hEgxMwhcE0dOl8tklc8CALCQduQoOYZG5Ydr4OAjk2tIOb6IImES62I/wyBXemI7nskd/IUM8Fuiez8f6hLCkX2vL02wFTLVG5dTC7UVI0rpb/iuwtu7NNbj9LN3nh6HsGu5Fv1261RNvBTfkWHhF+kXkpBRR/xBnjwdLuAKbfr4oZ6LAq9yx0teil11CoRZLslflzu9VrUbZ85JIZoUu97p4XachQYKvJ6A5ldlD5D43XKDjQY7laT7LGBPku8Gv1kAE7/PgSH3OntZR46VHBx1hkq7rx9j7adXcbHywt74r6Z1Qs64BMKyIwSP6w0SZBVMOtUvU+0nYwHgLqdm48O2IMS9bytsZMOp2dOhN8n+3gaf+X2vCqUI+l0L3nadqDxdveLg/63N5yPwRwNu0WOsk7BH/QNEFW8f+thE2KoHVzGZC/cCOw4udiIvgRRvD9K1MnjBb3a57bF4OjIZhbTCEvHzheo7oIRzRZKmiRl8VzN/BMGoUcGaPtGJeLDAxSuSgb1ZqSlbxr+MN9L3BB8Dx36uEniwrPsuMa08tbr9AgrSz8O1UrXsHZyrnoYG43yxdP403A/hTcWu1bZdAK15byEB2wrSNzY/bmQknItJZK0/A
 8WDboBHq
 4cFJjW8xSyQwPVRzWNWLaJYe7XgOR5X6G3LygJFnUSKU48q60wZ654U2Jssi10FxcCrEnrQ55LqWGXcF/+AmlYvloE703+QZBWJMHZiRHfjG7CHmvmPkHggE3lTqQLO+8QUm1ciXam9ZifCkxilpMpvfkCB1S92WZLR/8yhM6Efouh6/A9L60nfmgIRp5JNaxx4fSPXrUwYy5TWimW6wVB9QbsL507AC1bPZKgMK9ATOW/w6BagzjeT8h7JYetkfrj/hgDT9j4N0RlveNXWbGTFOXyaioouW6m3hWBQKPTb+Uw6KEV4478JKg1sHqK0ou6kNYTUV9UeMcrVkMIO18kVnGJgor39Q1ns9jYGXWeB8LoRi7Tvu9U7G13WXyHhmDBNr7/xt4gyjmh8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 10:02=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> On Wed, Oct 15, 2025 at 11:06=E2=80=AFAM Baoquan He <bhe@redhat.com> wrot=
e:
> >
> > On 10/13/25 at 02:09pm, Barry Song wrote:
> > > > -static int swap_node(struct swap_info_struct *si)
> > > > -{
> > > > -       struct block_device *bdev;
> > > > -
> > > > -       if (si->bdev)
> > > > -               bdev =3D si->bdev;
> > > > -       else
> > > > -               bdev =3D si->swap_file->f_inode->i_sb->s_bdev;
> > > > -
> > > > -       return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
> > > > -}
> > > > -
> > >
> > > Looking at the code, it seems to have some hardware affinity awarenes=
s,
> > > as it uses the swapfile=E2=80=99s bdev=E2=80=99s node_id. Are we regr=
essing cases where
> > > each node has a closer block device?
> >
> > I had talked about this with Chris before I posted v1. We don't need to
> > worry about this because:
> >
> > 1) Kernel code rarely set disk->node_id, all disks just assign
> > NUMA_NO_NODE to it except of these:
> >
> > drivers/nvdimm/pmem.c <<pmem_attach_disk>>
> > drivers/md/dm.c <<alloc_dev>>
> >
> > For intel ssd Aaron introduced the node based si choosing is for, it
> > should be Optane which has been discontinued. It could be wrong, then
> > hope intel can help test so that we can see what impact is brought in.
> >
> > 2) The gap between disk io and memory accessing
> > Usually memory accessing is nanosecond level, while disk io is
> > microsecond level, HDD even could be at millisecond. The node affinity
> > saving nanoseconds is negligible compared to the disk's own acessing
> > speed. This includes pmem, its io is more than ten times or even more
> > than memory accessing.
>
> I agree that it=E2=80=99s fine to remove the code if the related hardware=
 is obsolete.
> I found a paper [1] showing that accessing local Optane PMEM is much fast=
er
> than accessing remote Optane PMEM (see slides 4 and 5). That might explai=
n why
> they started the project to make swapfile NUMA-aware.

Are you suggesting the swapfiel is used for PMEM devices? It sounds
very strange to back swapfile with PMEM. I am under the impression
that the original a2468cc9bfdf commit is introduced with the intel SSD
as a testing swapfile device. I just looked it up. Here is what I find
out in the commit log:

=3D=3D=3D=3D=3D=3D=3D quote =3D=3D=3D=3D=3D=3D=3D=3D
    To see the effect of the patch, a test that starts N process, each mmap
    a region of anonymous memory and then continually write to it at random
    position to trigger both swap in and out is used.

    On a 2 node Skylake EP machine with 64GiB memory, two 170GB SSD drives
    are used as swap devices with each attached to a different node, the
    result is:
=3D=3D=3D=3D=3D=3D=3D end quote =3D=3D=3D=3D=3D

> My point is that we should at least mention this in the changelog to
> honor their past contributions. But since the hardware is no longer used,
> we can remove the code to reduce complexity and stop maintaining it.

Optane was not even supported in Skylake. Commit a2468cc9bfdf has
nothing to do with Optane. The Op]tane talk in a2468cc9bfdf is just a
red herring. I fail to see why reverting a2468cc9bfdf needs to mention
Optane is obsolete.

> I see Aaron's email is no longer reachable, which is probably why we have=
n=E2=80=99t
> received any feedback from them.
>
> [1] https://www.usenix.org/system/files/osdi21_slides_wang-qing.pdf
>
> >
> > If there's a real system which owns disks belonging to NUMA nodes, we
> > can test to see if the new round robin way is better or worse then the
> > node based way.
>
> Yep. If there might be a real user in the future, we can revisit this.
> For now, I agree that we can drop the complexity.

Thank you for the alignment.

Chris

