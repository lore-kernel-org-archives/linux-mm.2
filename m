Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE9F1090229
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713196B04C5; Thu, 19 Mar 2026 09:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C37B6B04C6; Thu, 19 Mar 2026 09:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D93C6B04C7; Thu, 19 Mar 2026 09:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D71C6B04C5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:48:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01CE58C002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:48:37 +0000 (UTC)
X-FDA: 84562942716.01.2C31434
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id BEB21120013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:48:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773928116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PFWCZvyUxPlavBCxJvDrd9taUS59xAE/Ne4yxr6gg4M=;
	b=YajKHKkHvl7ajMboWCKnCWwFL3NTlhZmWm02c/DBQAUL5HWHPexb4vdSxH0Op/9USYPHQJ
	6njHbNs5T9zl+YV7CD+slwhnB27cd4MEIZMmr/SiLiXZvrTQyBftqG76X2iPMGsZGYRyca
	S/yUDZ9u0gev+CpScprEhQS1LKuhqmk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773928116; a=rsa-sha256;
	cv=none;
	b=PoT2RJtKQNQ6lrX8LibSHFZwKuGLGorbez1mf99haZO/UfFCM890sh2YXqXtk8jjwhBSCl
	mqV3P0XVsSpWlIixpYm63dS287YQGt2zCZx8/dh6FjGpQTvIwewM1HC++jsXGXnx1t6mt0
	gGa2ErdePHVq4M0xfpgawwuK+MLD74E=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 19 Mar 2026 22:48:30 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 19 Mar 2026 22:48:30 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-ID: <abv+rjgyArqZ2uym@yjaykim-PowerEdge-T330>
References: <20260317181318.2517015-1-youngjun.park@lge.com>
 <CAJZ5v0iOh46gM9YVFnvN6bYcG5_kcqASqS+38brRg2BWAtOOzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0iOh46gM9YVFnvN6bYcG5_kcqASqS+38brRg2BWAtOOzw@mail.gmail.com>
X-Stat-Signature: dbj1em79f8mtt1coo8q4zpd9mbqq3cty
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BEB21120013
X-HE-Tag: 1773928114-296446
X-HE-Meta: U2FsdGVkX18xecPZdM2y3ZFrFl0/LmiQLUvw4mpIs5LVF0FZg1Y2cHUCk5OWifW1iqM/CVDWXmWjydfKmYPyffDgC/LxNc6zXJDk7NGs1KtFfi5yQs49Ke45jkRjeIaXIUTPWFe7KpZ/BoO4y7jo08V7+vcPrSnoecXUYQJXOIJdWaeCR4jiRn25KQrecaQqU7sF6miiEQLy9H7tWbpA0G62bnCdIos0xxO4+GCPztc8M8my/rsZ+ZzB4Qc6TgsgPL+dlkHxwi0C3cYwzsOrdjCwRE63+0T6DjWCio3F1mxwptF7bufzsXYBhB2xg9LKU/T+LnyeAycocJBD2H5tUDuoMdDk4F0Hn0wmdSYXZK3gL72eWy8zaZww54WOUVeUR4iGBymIoUq5vacQg0ZKaZm+sZ3BQD2QmUcUahVg2+x0loZ6UnHy2XPJllZDubxrGWbKspxrLjB1SlW2uNpODMsGkBeKYpWZ8LIHxmAvacPJce27Yv9zbL6IOPefoxUMsZxGJqZ+/0UxgDfSJnsCUizOuSQfREULpqyppL3kNnxDmq0uso9ThOZQ895xNLR4CVNQbpo8BXD9nATtkJSMnK4GBs+fsWg2uzN/qan8AJpcFzw3ZhC1V8Ng6lUlI+DDO0iN9ANJj9c2znaB0iiA1UIWqZ/3HxNXUyVM1b64rHmIAanwnn37F/Pl8NaB//O7pLhIu6cx4aBmww5dQIwPkEUaHosE+OHiqfFGi4UBiAiwcNE1WeHkxDIOG4KByeuTIHxgB/ZawM02JSpMnnDjorX/zytg3BFnhAC1IOasL4yt629OijhSyN7BGRWGRmt0MH6EMMpmVbIr83I2esYb1sFsm+Pzgz2WMFytbW2gZKFrUf4Yh48KEYrOAhpH77MX67dxQX6nYIdfVSg8zrbh/vzQoMX887CT7hTakaT/uwcvcgHzg2lyvtpITtIT+92h61U/8U1kxrX/RMQo4Ma
 oyehRRdb
 unprIZHhb/ZMOR/xMCpvYTu3E13ZHKZDrbJZX070kAKSTEWKl5i+1oYmPYrAcFwUDBGvQSRG89aBDL6PrJn4vHSrDPJJZMEPm2jNuel/KlPuIzWA2rMoKwIjxwX41/ZRA//CCLDnvk6YPT7KFMzdW8P1lmSnNDTrdJbz+V6Dl3iELdCs3nFbK8VwUj0Sgd86j0QVAm6mLxHcwF7YsgQkDhSUtOSZsgqWjsWX/haeJPreQV0OMWYLMSxHgO2hixWw2VCUrlvS3lMjhxmWf5Vzk7gsyKvHX0OL0RzbF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 02:33:30PM +0100, Rafael J. Wysocki wrote:
> On Tue, Mar 17, 2026 at 7:13 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > Currently, in the uswsusp path, only the swap type value is retrieved at
> > lookup time without holding a reference. If swapoff races after the type
> > is acquired, subsequent slot allocations operate on a stale swap device.
> >
> > Additionally, grabbing and releasing the swap device reference on every
> > slot allocation is inefficient across the entire hibernation swap path.
> >
> > This patch series addresses these issues:
> > - Patch 1: Fixes the swapoff race in uswsusp by holding the swap device
> >   reference from the point the swap device is looked up.
> > - Patch 2: Removes the overhead of per-slot reference counting in alloc/free
> >   paths and cleans up the redundant SWP_WRITEOK check.
> > - Patch 3: Fixes a spurious WARNING in the uswsusp GFP mask restore path.
> >   (Founded during uswsusp test)
> >
> > Links:
> > RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
> > RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngjun.park@lge.com/
> > RFC v3: https://lore.kernel.org/linux-mm/20260312112511.3596781-1-youngjun.park@lge.com/
> >
> > Testing:
> > - Hibernate/resume via sysfs
> >   (echo reboot > /sys/power/disk && echo disk > /sys/power/state)
> > - Hibernate with suspend via sysfs
> >   (echo suspend > /sys/power/disk && echo disk > /sys/power/state)
> > - Hibernate/resume via uswsusp (suspend-utils s2disk/resume on QEMU)
> >   - Verified swap I/O works correctly after resume.
> >   - Verified swapoff succeeds after snapshot resume completes.
> >   - Verified pm_restore_gfp_mask() WARNING no longer triggers (Patch 3).
> > - swapoff during active uswsusp session:
> >   - Verified swapoff blocks while uswsusp holds swap reference.
> >   - Verified swapoff can be cancelled by signal (e.g. Ctrl+C).
> >   - Verified swapoff succeeds after uswsusp process terminates.
> >
> > Changelog:
> > rfc v3 -> v4:
> >  - Introduced get/find/put_hibernation_swap_type() helpers per Kairui's
> >    feedback. find_ for lookup-only, get/put for reference management.
> >  - Switched to swap_type_to_info() and added type < 0 check per
> >    Kairui's suggestion.
> >  - Fixed get_hibernation_swap_type() return when ref == false (Reviewd by Kairui)
> >  - Made swapoff wait interruptible to prevent hang when uswsusp
> >    holds a swap reference.
> >  - Fixed spurious WARN_ON in pm_restore_gfp_mask() by introducing
> >    pm_restore_gfp_mask_safe() (Patch 3).
> >  - Updated commit messages and added comments for clarity.
> >  - Rebased onto latest mm-new tree.
> >
> >  Note: Kairui suggested adding WARN on NULL in put_hibernation_swap_type(),
> >  but kept silent return instead, as type can legitimately be -1 when
> >  snapshot_open() fails to find a matching swap device. swap_type_to_info()
> >  returns NULL for type < 0, so the cleanup path stays simple.
> >
> > rfc v2 -> rfc v3:
> >  - Split into 2 patches per Chris Li's feedback.
> >  - Simplified by not holding reference in normal hibernation path
> >    per Chris Li's suggestion.
> >  - Removed redundant SWP_WRITEOK check.
> >  - Rebased onto f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b.
> >
> > rfc v1 -> rfc v2:
> >  - Squashed into single patch per Usama Arif's feedback.
> >
> > Youngjun Park (3):
> >   mm/swap, PM: hibernate: fix swapoff race in uswsusp by getting swap
> >     reference
> >   mm/swap: remove redundant swap device reference in alloc/free
> >   PM: hibernate: fix spurious GFP mask WARNING in uswsusp path
> >
> >  include/linux/suspend.h |   1 +
> >  include/linux/swap.h    |   4 +-
> >  kernel/power/main.c     |   7 ++
> >  kernel/power/swap.c     |   2 +-
> >  kernel/power/user.c     |  19 +++--
> >  mm/swapfile.c           | 154 +++++++++++++++++++++++++++-------------
> >  6 files changed, 132 insertions(+), 55 deletions(-)
> >
> > --
> 
> Which kernel version does this series apply to?
> 
> It doesn't apply for me on top of 7.0-rc4, so please consider rebasing.

It is based on mm-new 
I will soon rebase on the top of 7.0-rc4 with build & test.

Best regards,
Youngjun Park



