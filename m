Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FEDCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3AED6B008C; Wed, 13 May 2026 05:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12CD6B0092; Wed, 13 May 2026 05:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950B76B0093; Wed, 13 May 2026 05:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 824866B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:40:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 423D18D98E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:40:21 +0000 (UTC)
X-FDA: 84761901042.18.D061B48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B6EDC0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:40:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STfxvOfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAtC9l77W0bPuQMW0/WWijaFhrPnbBjPlx5TjNTS8LI=;
	b=X+eSKtbb3Suo5qs0qVnphRFeOIzO+VShhmqVFi64+XiPeTvBPPIZ9j3QTq19BOlsajez/j
	4dz2zkTb6LBLIybpJF06Mz5uEmKUrrN7lc9OKjwB38o5CDCx5rk6f6R16mWbyHjdXBbZKi
	DBWG7NziF633SDgcDGYebPWX2ZoKjI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778665219; a=rsa-sha256;
	cv=none;
	b=iJvQ9LjjoW8lPPURhGT3W9GZ+kgS436gMWulfLXbh1lzVYsfNs+MBK/x1+ivYVfgecUExJ
	qa6gvKSDSJGexYMscH+CVZEblPgy0Ec8YAZ2MmdlIO3PW6zxzXxVLCv5xGguAyUO/Z0Ysg
	ui1nY878lYxX1zd4xQJKzHMeIjWBT88=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STfxvOfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67C1641688;
	Wed, 13 May 2026 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3809AC2BCB7;
	Wed, 13 May 2026 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778665218;
	bh=RAtC9l77W0bPuQMW0/WWijaFhrPnbBjPlx5TjNTS8LI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STfxvOfL7bMTQyT0SRP2hq8Xadf6JEvMES4RqVeENsMr0rTC0vJ2wfK0lHoP7s6tj
	 fj5MQwqOqJwq+nZeAHXaXi1YO3AfQOZvoS8DRcdLq1rRF1lee497+o3EMUKIj10Ihv
	 n7/XZrWulEwDEcpi6q7K43a5CGhGhqLlR6L1b3EDVqx1Vr1f+PXzb3dusMjnn+P6Fo
	 sDybYcIEytf1/4xZdAQhjM4cD3PheKReEjFIrdNS/lkWSHZ3QVNz1SiOYkZcVGGjjy
	 +koUxLQzprvyvcuxOReiJ7YASk+RuGTKFK5iplDfgbHXAksOA95huS+YinY1xYwXeo
	 HEQtO6vOAU+xA==
Date: Wed, 13 May 2026 10:40:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, ranxiaokai627@163.com, 
	hughd@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn, 
	"leitao@debian.org >> Breno Leitao" <leitao@debian.org>
Subject: Re: [PATCH 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agRG30FxrwP90l9_@lucifer>
References: <20260512120557.49995-1-ranxiaokai627@163.com>
 <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
 <agQ9FXDr_5ybD7AR@lucifer>
 <e80c7f34-40c1-4854-8f3a-2461022f86cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e80c7f34-40c1-4854-8f3a-2461022f86cc@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B6EDC0005
X-Stat-Signature: y854jgs35xfzx56rnqcip6mp3s5q6js5
X-Rspam-User: 
X-HE-Tag: 1778665219-257910
X-HE-Meta: U2FsdGVkX1/SphqaelLkQ0JFqjgZhpK45WHEY14U4nv/PH7r06H0iOaf0CmQ7zL1W/p992wo3v0Y6CowZEPXW1oWvqeOlT+vTYUFZFDrPC7WIsvZ9hXNUtKgXMJt0pNl8vXA57ztrRKFfiQUG+vi4iP8bnsXfIuEyHOt2Qk4vXQtMy8rx2iiC2alHYS9wI7zezaPuX49/PU88xYlkZUGfHoYb9OO4N4DDDjkmXldYRPnF4r4CtZsHLeMSrFtXPUvBc454hSR9ie/N6e5u62nvpNerRMV40GW1Kou0l3UdQYSZPOBIZBi7KiDmZcCqnt/K+KKOMod2kS0vC7UXyojioC4SFc24OyZ4KhZU5TcgABQ6fRbOO7FSlSGiEVjDddKB9rwjXZ9BLmxGn7Js1wVnWjTwmK0qprHfVd8wZcEHSGIu/8i3I8id+dccJOtJp8MfVZ/5fsamt4FwZqavPxPgVwE1wdd2H8JMj3P+c9ltvvIbLdbx7esERWf9tnYvtsheO2KuGMXgc1iM/UX1oNvN9hMrMINxpBio5sBKZDdPjbeh6m0fOjK1kf6zaEZOVgbrsXS7D9EvG3jT0yNA9RA92UxSLEhp1Gq4shcPrPaSE00TuDxfK0T6bUy4o4ikG2xy/3IkWpQbewsXcw1r8JKM/6Sm0ad6LfcHL/forJL2883pJKMYYD4o9sYvNv0PohZIkTit4iddg+Gre08JlSO7j5on6mN1Z/S9dQd0vCwKFKh/VqCgx2Ywdfvh0uks8w2n4Dult4obmEzQzOlxfV9gweUcWMzpwkWqGOOcbHcr5XG1AwYYKJaGRZVdt8ZCSbdxPtj5qgTffEzCHRonsLmL4gjlrA9WVcz8qzZN8V1Ld5iOUGoukSLik5MFkQTbyblvkcy3cLego9GyGk/PQKZqTlXmRi+Zo5KomZ0T81VorGI1upCV9qI4sGKSnePdyeYH9jT2bMJ+ob1bSZD2HL
 c1KK8/uL
 ZNeRtDu3AzvrwSBDfEHkK7eQjiosPppGRsTZ7dPvYlgpAMneCVO/Kx6D4NoQr1xVvFMZmoUhLGMBmn0flwjV0qku/BwNzSVMACvL+S5pdCJdz2n5+80D2BLgcr6GrT1XZkH5v85cCZH5t2YU+g0YKqc6OJRtRenELWbVjFd2+NjLKU9z+EcTOT62uaTf77KAt1Rj3UcHJBYNeWcyvhnfztGfnTabUIFqBMiT2ZkCBzdutWje+3id5HQ+AHLaAdXdHS8jyxrYGXucPVgU4r1JMMR5lqpRbLgj2fcHnjdadzUOvCOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:38:21AM +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 11:03, Lorenzo Stoakes wrote:
> > +cc David also!
> >
> > Unfortunately we put some hugetlb logic in mm/shmem.c too which makes
> > get_maintainers.pl not do the right thing.
> >
> > I wonder if we should add mm/shmem.c to the THP section _also_ just to cover
> > this off?
>
> I'd rather not. Too much noise :)

Haha fair enough... maybe we should move this stuff to huge_memory.c or
something, but not sure if that makes sense.

Not a _hugely_ big deal though tbh!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

