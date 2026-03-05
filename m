Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A1EEFCE53
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 00:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6946B0005; Wed,  4 Mar 2026 19:18:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A196B0088; Wed,  4 Mar 2026 19:18:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CA76B0089; Wed,  4 Mar 2026 19:18:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 519AA6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:18:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D93FA1A06F7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:18:48 +0000 (UTC)
X-FDA: 84510098736.13.5F16EBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D31D91A0012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:18:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vK4xwT8o;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772669927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7AUWogukWLXr/ReheH8TJDUTaxQkeoJTSyRIXlt17I=;
	b=OcUENN7LT1xZJEYevx+C2NlbZiBHuWuAO+0I3Jt6fwfAivdY7PzHxO/yL8PAIKNzKNq5lC
	oEJe83ajAhQ1uTh3FMTMQ0JOxv27jNbTJN2M16uIQa+TVkiUlBWT9jlizTp79SPYvBLkAA
	ek544cg65oOzT66eWP6xpIqemicBx7I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vK4xwT8o;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772669927; a=rsa-sha256;
	cv=none;
	b=VK3RONCgzDWqk/gLKzxam3HKqxOtExmFpqHYlDer0yABgv/K+Q0ESNR9gDv7aYh/UyIxuW
	R1Ua8edp6vUpCApUclw8y7+NsqL+R/M7VhU1xmLPIpwWc7Oe2k27OD7W+TbVp1wRiy++K4
	CniV4Bnu5pPvN4q6XTr2IT2VxV3Ve/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D6044473B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C19FC2BCC6
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772669925;
	bh=GjdElT5AcZfytgoGbVIxtcG8IOmcqOEZiw3Vz/wJrjA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vK4xwT8o1cx8LuEPzA+zJUkQ9D/6tKwPsqCZ/KC4dygPdMQR/sHdEEI3p6uCNFljX
	 2V06M6bgOv/iy+6wWNuGoMvMc9x/mXfSW2p5Sr1aIOZ0CF2efqQbehRhfYateWZmhT
	 qhI3BTxyG9yjuz4ZWnKBzEJJRzu2+xoBgQ720GvgBl/n6Y+wDrZjNxaC2P8+tSk07p
	 y01OogeoEw5msaLaRaOsC9tvqnv4DX9zEQwX7MY/jHPCQgMFSx0zOdS6FiLx1x/Yes
	 JS0sITlcTOLCsEXeeLE9NLhftSJ2shxcGzxP0xhOBoCBYJdvaPzAJR0D3VqKxwe5Wh
	 A2YrXwH144K0g==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-660fb578f8eso2154232a12.0
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 16:18:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW8vcFDS1bA0573nTMDEvS2WskaPjd+hcZU9c/DiyiIumEhdMsrn8zRT/wQmvaiecShPq+cnEHN0Q==@kvack.org
X-Gm-Message-State: AOJu0YwwRPI3KAAxhG8vCoeS3f92JKUeteqpObVfZLvbI2pFZ0ylZqHk
	v/terapoLS7wWJLN/KbuJD1w/mcHiO5wqNPQRG0EKDHlZ4ZE1Jbu2ZtW09QdKFn3UwGJ5cagcsR
	qgcYiNfo7ugqtB3zR+QzDartgUHnUwCE=
X-Received: by 2002:a17:907:3da1:b0:b88:7568:26d5 with SMTP id
 a640c23a62f3a-b93f13b772amr255810066b.27.1772669923954; Wed, 04 Mar 2026
 16:18:43 -0800 (PST)
MIME-Version: 1.0
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev> <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
 <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev> <46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
 <22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev> <vfmyb3pp2gatdrqa2uimw44pxioreo7zc373zn7buvdfzhejew@ndhaa4yl3bvh>
 <20260304140307.f51a33f77f6ddc1dfc0cf476@linux-foundation.org>
In-Reply-To: <20260304140307.f51a33f77f6ddc1dfc0cf476@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 16:18:32 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP9VseSaEO6to9rcRW_TZ6E6Qk4ZQgj49g9bQOAdjgQvQ@mail.gmail.com>
X-Gm-Features: AaiRm516Oe_1QYwFsS8hjIc6T-4dgjb-_Q4aKlr8O9HklowPRK7Y8a1pQV4Wayk
Message-ID: <CAO9r8zP9VseSaEO6to9rcRW_TZ6E6Qk4ZQgj49g9bQOAdjgQvQ@mail.gmail.com>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D31D91A0012
X-Rspamd-Server: rspam07
X-Stat-Signature: kbcjaizqgkfscp8jim3sxet79z4c3wn9
X-Rspam-User: 
X-HE-Tag: 1772669926-606865
X-HE-Meta: U2FsdGVkX1+q0G5GsYBOyiZZ1+fYR7a2CKXbdntNlPceoESea6eESQ4t2vwE2ERZRXHJdgLV/CMlvp7xysQ9QAfQsMtQW7Gwc7On00m9SEBVDgGO6/o6bF2KvvIT2fBWdcAm5educyXD4PpkDuDdKzG3ZapGDPe/CWLIz9iSV8mSQBiVOmbf2rKiJUB2bvM6olbcWUS202cj9sqFezdh7sszQMGaZpIZvfWOUhcgb4+7xamTWC78vyXwK/9DaMKkIxp+nClIZd6IQ0+sOp74kw43HIxX2xF/qMSt0oZVjFOul3rSMhEPKIlOjiQxMUgF2affF19VnWm+oPYXOCTceUNp2gnLJNByMxK1pFTvkorrxlT3lbhNgb/JQB106F8rXG+7bed0hJefI0/AY7eR/20xP6j3BHqS3wObWde/t/zkY95njD3ilFPzLd94d53iQclrBIavIT8Z3aJIl0UKW5pofKYElOjtJSwxDeCIZ3fTulmlwmI0+8LirFyHlOyxt0Q9YEW77ig7lz1qgBESGym00p6QvV+MvKYpIr9+yL0vKGWi4kKwqrwzpwj7fL8Xe+xukJ4VbHtVw0p6qHR1QbwwrMFdKBz5cA72D+lOJtAEPLr1XuiB9m8wY5JG6O+t25gr2JZ/fQ08nZ0gTbf+O0IyOekorK2/hqGK4HMZQmEkFR9y05Kf2pH7lsN5uXISju65n2iGARap5Lb4tHr+pjMrnHgW6MA6ZZnhv2GnN92HGWHha4Y4Ofda27KR6hzN9xjVWwUW05jxNjEUiFyEa0LfppK35OLo4Y5l90M6/11kDOVl/nAjeQtMfGaXEwYmkYuRMzjYMkNjpxUa1CnE7kmdtJ2dbGqfK0vPnZpw1iR3dM2Z++sD5245qYN8kme3PryMnUfNlWfDBs1kkbzuJBwTsLSs0nJELybp78w5b2zBGlURSmi7B0x3WCmmMyYWz4V0JI74L3iKcwCdtCU
 bbRGP5D7
 sd0QX8iiLKLDhR8qmLIrssObmoyoM/k7sIWkdfxYNHskmWtUCFbEDkkIq6wM+6oz1ttBnRQwwwcIM/T/gX3Ad22si4SY+O5w5LfteaFt4YYZpqUj8a5hQ4qXdm5/p35a7tMrQUDwX7UtwpXtRQOw7w7JeRnhCXltF666SWo31zFQPjJekB3s7itefli5242VyXQGcqIJoCJhRhO+PnuY/uSFzWzDYr2SR1H23tz0YoVUts3e4890KsDqfTyqFRniZ8G5LJtwcMwstNo71m4b/Yw0DuYC9bfdJToDalgXTzQJX+CXku3wUzMAouZQZxqDL8P9zRE299ClFsSmjGVpP7MAdnsnRUYEF1BTJlgy6T4ewV+7eo7++Ug0/oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 2:03=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed, 4 Mar 2026 13:57:41 +0000 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > > > What about this (untested), it should apply on top of 'mm: memcontr=
ol:
> > > > eliminate the problem of dying memory cgroup for LRU folios' in mm-=
new,
> > > > so maybe it needs to be broken down across different patches:
> > > >
> > >
> > > I applied  and tested it, so the final updated patches is as follows,
> > > If there are no problems, I will send out the official patches.
> >
> > If I am not mistaken, Andrew prefers fixups to what he already has in
> > mm-new (Andrew, please correct me if I am wrong).
>
> Yes, if the changes are reasonably small and the code has already
> undergone significant review.
>
> Although the mm-new branch is quite speculative/early so I guess this
> is less important there.
>
> Adding a sprinkle of -fix patches can be a pain all round, so nowadays
> if someone sends a replacement series I'll generate and send a
> what-you-changed-since-last-time diff.  So
>
> - we can check that the diff matches the changelogged updates
> - reviewers don't have to re-review everything
> - the author can eyeball it and think "yup, I meant to change that".
>
> I believe this series is due for quite a few updates so a full v6
> resend series would be appropriate.  I'll generate the
> how-you-changed-mm.git email from that.

Thanks for chiming in. Qi, if you send a new version, I think
separating refactoring (and moving, if needed) mod_memcg_state() and
mod_memcg_lruvec_state() into a separate patch will make things easier
to review.

