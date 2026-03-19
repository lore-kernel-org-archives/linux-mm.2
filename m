Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2672E1090220
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6873A6B04C3; Thu, 19 Mar 2026 09:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65EDC6B04C4; Thu, 19 Mar 2026 09:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C126B04C5; Thu, 19 Mar 2026 09:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49F186B04C3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:33:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01AD61B81AE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:33:46 +0000 (UTC)
X-FDA: 84562905294.25.18AD52D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BBC210000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:33:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vBWCl3aS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773927225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0Z27ac0n560xbn6Sj3oUMsFiW/QLmzjDZsplSJgxV8=;
	b=1OyXShsrXzsWwwQ8OdHyHuDU/xKLndMdA7LCx2PlvrbX4cilF8wwTD+glLv0Q5V7cviMVD
	J/Z/sNxtPRplnUoN1+uA8YWLyfokHAm+MbOl5fM1qJmhkzoFNcSp5MtmE6viX/0UYJ2X6T
	RYwbpNJ3/ARVafIzsE8m0jc4CoY9ZcU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vBWCl3aS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773927225; a=rsa-sha256;
	cv=none;
	b=JiIgEW4LG3wcThcwsUAVb0+ulKPeDbsHlbEkklQEY+LaRd8rfV0XrkETnuePPeeZeBmerV
	JYTNKtgeLeLSavbqleRmSlsFypVBF5NyV4K1QTCMJupvkvAOmTg7q56g6BAA/jEfZHto9R
	omIMLkqEFox/UJCDhvJlOvvTYgZOxfU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8FB84427B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9331FC2BCB1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773927223;
	bh=Dm5NKjKvqYl+3avboOzUu7vWJxbH+jX5bwpvt7ZbXmc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vBWCl3aSlRIt9q6Ez7UQVnyLA2tz01gTMvyrUfBQUTXeb8Eyu53iq24c8yLKzqzRL
	 qgW5hTvsTHYDjO7lU8liynoYG+bS5C1bhJlWzaHcT4bsrUwMzn+jLKcznFNElKELwE
	 Zd89QfmUjywogG+p5ZTFAxkO8MT0POs9JTZnqjyBRLXusP87oY7fB0nZ2tatMqhCZf
	 w3DwRcZtJ6zpDal/KDbyxVGqNi4RGIDll1QVnGGS0J8gE6VX8cFEh8ZsCvLkkNaPOa
	 AbvPxfM/74lR2f4MFmO+BvDXxHhMOvziuqozyzlH1Wp6TN8mS3bWYjkPE9uxoxfPtB
	 Xx3VubDVDYfUA==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-67934c83063so377312eaf.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:33:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUAUh0N5oqa7Gzc6+BnvbKfKVWRc1IGqdf0NK+0SBFmj/F/cB907lmDorYBwnV0vscL/vbSCbi2kA==@kvack.org
X-Gm-Message-State: AOJu0YwbTF8aJwyT+pfNveeQVKuimkE2FZfUxkKoZVFC8AcaU9IkruDk
	Yq+PIDkrzby6qVGWgafcS6mpLMHHD5mCIbKZ03UzV3D/qP+jF7XLkDPSmk00f9z8hvUOCq+51i9
	ojdsvbPdmcmctgZyeUudyNXTmnHW4Cyk=
X-Received: by 2002:a05:6820:2014:b0:67b:c368:135a with SMTP id
 006d021491bc7-67c0dabccf0mr5608217eaf.19.1773927222682; Thu, 19 Mar 2026
 06:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260317181318.2517015-1-youngjun.park@lge.com>
In-Reply-To: <20260317181318.2517015-1-youngjun.park@lge.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 19 Mar 2026 14:33:30 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0iOh46gM9YVFnvN6bYcG5_kcqASqS+38brRg2BWAtOOzw@mail.gmail.com>
X-Gm-Features: AaiRm52jELOb6Ko_0-wwNDTuvZw8N5aHWBrJf9TOBTOkGixQcbO_z3u4Hjo8Jhc
Message-ID: <CAJZ5v0iOh46gM9YVFnvN6bYcG5_kcqASqS+38brRg2BWAtOOzw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BBC210000E
X-Stat-Signature: 7uesfonjypcqppdcf398f9rqkd49t3e6
X-Rspam-User: 
X-HE-Tag: 1773927224-70340
X-HE-Meta: U2FsdGVkX18jnTu/pgmcEHAYkK0/tHKsHjndp6KOvkxUwyrty3OTT29PLmIPy8ExN8Lq8gm7gaUMgyzXsk7oTRfArN31GIdttUlHSqlfyukvJtqg3yCPLyv8VtTpT6I8tJZK5F2Xq3R/lJ9xbYMKRpqH8VMjSVCZpWRn0ttZAjRVoac/djEcWuCtfo63CkTkEaJsV1MEaeXd02ub0aAqvhkh3Qgbgbtqwhf57afQkug8MqbJ/G3MHJU0g94o8Xq5QF2JT6NqjREuxZoZVnddufK0/bTAv/9XqZscJoCdCWPqEn+Iy2mnX1dZxtb3N26MvJuLlmvUzzgJnZyA9ri1n5msTsMwewide5NdT0dwPIjHLJoPgb+ZoWYmhr0I7cCORBjEIf+nOz7W1DDTL6GBmYszguYe1vo+MBkRsamoHUiVzGOHJmmzY8/2xSdSfFWYr967AUsZwj052+WnyagwJStEfJ5PfWAVDBeeY1NsmaQdrI/UkuAoBijKzHhGke48Ub2CUKUgd4XDg+n1ttWsWSkBqgWKlI2jkdUDD/u37XbMuY1BctuwPBE4qgENbnc8H085IJBVk5MPnPnih98mMMpJwHBGydUHAwtoq67DeqPdiiKRenWRr7oRjxezKNiHvTA7wqxyHuCmbkgsxMmtu6dEKIqiTxp6fbL2D/l+gdrFsgRsBmhL7Idcuog87O/MQEuMLJTQ83s9vlb0Hg+tehxvMZgNIgoYYzmrPxWtMoFjiJaUR7lmk5wDNu5Xf7au9EQYvIM89KKef7QSSc/KHyVRUEGHvvuA6sc7G6tR8le+92Q07dgqvLZPsyZGosrZ6Kmi6tO/s3OGQWD64At6Zb7AcRcGQrWy8t6zvwsJQOP83//DWWxVHQGCFcYm5SxtHitfQv7EExA5SUMLc1lxugXPuLAdhRU2Qtn05+yeZhwjxhioA5bwvwTxGXnG1OJY4oD9skxxMa12NA0gEco
 o2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 7:13=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> Currently, in the uswsusp path, only the swap type value is retrieved at
> lookup time without holding a reference. If swapoff races after the type
> is acquired, subsequent slot allocations operate on a stale swap device.
>
> Additionally, grabbing and releasing the swap device reference on every
> slot allocation is inefficient across the entire hibernation swap path.
>
> This patch series addresses these issues:
> - Patch 1: Fixes the swapoff race in uswsusp by holding the swap device
>   reference from the point the swap device is looked up.
> - Patch 2: Removes the overhead of per-slot reference counting in alloc/f=
ree
>   paths and cleans up the redundant SWP_WRITEOK check.
> - Patch 3: Fixes a spurious WARNING in the uswsusp GFP mask restore path.
>   (Founded during uswsusp test)
>
> Links:
> RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.a=
rif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
> RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngju=
n.park@lge.com/
> RFC v3: https://lore.kernel.org/linux-mm/20260312112511.3596781-1-youngju=
n.park@lge.com/
>
> Testing:
> - Hibernate/resume via sysfs
>   (echo reboot > /sys/power/disk && echo disk > /sys/power/state)
> - Hibernate with suspend via sysfs
>   (echo suspend > /sys/power/disk && echo disk > /sys/power/state)
> - Hibernate/resume via uswsusp (suspend-utils s2disk/resume on QEMU)
>   - Verified swap I/O works correctly after resume.
>   - Verified swapoff succeeds after snapshot resume completes.
>   - Verified pm_restore_gfp_mask() WARNING no longer triggers (Patch 3).
> - swapoff during active uswsusp session:
>   - Verified swapoff blocks while uswsusp holds swap reference.
>   - Verified swapoff can be cancelled by signal (e.g. Ctrl+C).
>   - Verified swapoff succeeds after uswsusp process terminates.
>
> Changelog:
> rfc v3 -> v4:
>  - Introduced get/find/put_hibernation_swap_type() helpers per Kairui's
>    feedback. find_ for lookup-only, get/put for reference management.
>  - Switched to swap_type_to_info() and added type < 0 check per
>    Kairui's suggestion.
>  - Fixed get_hibernation_swap_type() return when ref =3D=3D false (Review=
d by Kairui)
>  - Made swapoff wait interruptible to prevent hang when uswsusp
>    holds a swap reference.
>  - Fixed spurious WARN_ON in pm_restore_gfp_mask() by introducing
>    pm_restore_gfp_mask_safe() (Patch 3).
>  - Updated commit messages and added comments for clarity.
>  - Rebased onto latest mm-new tree.
>
>  Note: Kairui suggested adding WARN on NULL in put_hibernation_swap_type(=
),
>  but kept silent return instead, as type can legitimately be -1 when
>  snapshot_open() fails to find a matching swap device. swap_type_to_info(=
)
>  returns NULL for type < 0, so the cleanup path stays simple.
>
> rfc v2 -> rfc v3:
>  - Split into 2 patches per Chris Li's feedback.
>  - Simplified by not holding reference in normal hibernation path
>    per Chris Li's suggestion.
>  - Removed redundant SWP_WRITEOK check.
>  - Rebased onto f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b.
>
> rfc v1 -> rfc v2:
>  - Squashed into single patch per Usama Arif's feedback.
>
> Youngjun Park (3):
>   mm/swap, PM: hibernate: fix swapoff race in uswsusp by getting swap
>     reference
>   mm/swap: remove redundant swap device reference in alloc/free
>   PM: hibernate: fix spurious GFP mask WARNING in uswsusp path
>
>  include/linux/suspend.h |   1 +
>  include/linux/swap.h    |   4 +-
>  kernel/power/main.c     |   7 ++
>  kernel/power/swap.c     |   2 +-
>  kernel/power/user.c     |  19 +++--
>  mm/swapfile.c           | 154 +++++++++++++++++++++++++++-------------
>  6 files changed, 132 insertions(+), 55 deletions(-)
>
> --

Which kernel version does this series apply to?

It doesn't apply for me on top of 7.0-rc4, so please consider rebasing.

