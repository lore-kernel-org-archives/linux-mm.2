Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C19BF8A163
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65F936B0005; Thu, 16 Apr 2026 07:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6370E6B0089; Thu, 16 Apr 2026 07:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573A86B008A; Thu, 16 Apr 2026 07:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 484236B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:42:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBB2414081B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:42:15 +0000 (UTC)
X-FDA: 84664230630.22.8A8131C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11DA8C000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:42:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bYNZeaA1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776339734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADKAlhRkOLlS9qJrCQ5+HhJJAAJlDfB07KyMtd2WdF0=;
	b=7y3xtvrYbnc1YZ2b1u5S24NKqfddB5pKAmvGaelckdALVasrJEVLK5jlyqXHr37imEw5pO
	NBqM9Qz67EhUU9g6wYq7g3hQZOh7aQqyz3Me1zhog+rpas3DFp4SjMjyiDOFsljtgKzBhz
	qdKq4KPiR5N0WiGznQBoFE2riEebres=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bYNZeaA1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776339734; a=rsa-sha256;
	cv=none;
	b=qOFaBTOz/qxgtZrRBLwA7P4VoNquRrN8tT0C5wjuqOw/uREnqjaBMnRWz/5ERRox+WMSuM
	b/A2+IWAhcJ6wZgButTGUV+xRzS664Mk4zghUsZh9IIBWjlFlPZW2CIlIbhDbZ+IDogqrK
	zriDo7uADfqBCo/dM4O3eX4mWXFt7+c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 039FA41878;
	Thu, 16 Apr 2026 11:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F174C2BCAF;
	Thu, 16 Apr 2026 11:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776339732;
	bh=45qgrqFScnEZlWgBNq5rpUzjALmjVlD3QYp2/Yd42dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bYNZeaA1ZUcDHIjq+0OqBy0LPmzNxX7Y7YB3UWtkVExrSUlrlDPM82HMre4S9yIGK
	 nlJFZA+591IuaFjBEWT+zMPNPW2rkLStOcEJZbflAN3CwD9izDbDIABtU///SjzkE4
	 B3vMVOdY52YYscNABm+7wnsN30m8y4PmkK1fJ4trJJOz0gBfnIC+U10hAXPay8VLQT
	 hKxHc1cVl1IyLq5HBUUMZHcAE78NZYr2pHiltTjFl6HE7H0gBxgqZLWXAi1MQHULuB
	 KcZvwP4OCZvhsKiNd0gRDyW1cognJw3KlimFEwpoZCsXV50WbUrcDfKprf5tuYHPwG
	 93CRwWuA3ml6Q==
Date: Thu, 16 Apr 2026 14:42:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 3/4] arch, mm: consolidate empty_zero_page
Message-ID: <aeDLDSJAwYfsj78A@kernel.org>
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-4-rppt@kernel.org>
 <20260416100221-57063053-1c9e-4450-8b0c-d9783657fa47@linutronix.de>
 <aeDBw4O655-pXiHy@kernel.org>
 <20260416131914-f20c3a56-bddb-4488-b4bd-560e52ab9416@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260416131914-f20c3a56-bddb-4488-b4bd-560e52ab9416@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 11DA8C000D
X-Stat-Signature: 8zuz8sumbizgfkmsz9wq8nyrakhab1np
X-HE-Tag: 1776339733-612362
X-HE-Meta: U2FsdGVkX1+zHFTE2KhITJLaelW0Iyrd2qzUmlZxM52V8xaOg//h6pv/41OofWiuZnlFDnh3P6Bi5WGBaIgU0k6xmw5eEl7jOr2fd6AhNAAftgbehNCKQSRAZYYWPs6M41N1JOeACV9KxwkGxlGm6HS8LvTUZap3YMw+oKKCysraj1bUaeox+oYDGzDl/Oc7M6WymgXmE9LLVeChBEop4E4dIq3tT9Yq5Sa318FjPLX8uMV1rYkh4Xa+wrhkTYRIPFla2KiP5bcKFsWDFwByc7hQCogk3ZtAR+yPkmX996/5m21UHzqwtoFolvoKFcW9Xi+FLZyJI3G421ddjpBdg5tZLRjVqsNxInaJTtWF6wzUXrhYXLJyMaMOaU/bSLq7yxXA3oeOymv0fWiMpX705ldl2JXMmwXwVRoJmn2zTbz7n1nsGfNTIwwwXRLvPjWnhaaVpLkBwA8gypWmyjbCwu1FRn0rLJiFhA6T/9Fn9/6jSP6xd7NlDa3JYU4z7zqN1Sybc7N6vIwyZ5D4yUds+ErVTQeO540nCLApyA6f+zjWNJ05O+ZHEuyoCE4d799R4YITBG4QvxTfXi4/osq8B2011BM5zkie6RPj5uME9hVM+KyD8j3KgjcfgftuAQKy0mj97Bq/2c9aAJ5f/5MRUuzbBTWYN2JLThaeFcDCM530FmFJtrhws0V7yJajWbNeKNAV1cL9ry3VAmih2eD/esQvKGtlUvRlh6uWsBz8So+V4tvVQ8Nyrr98TNyXpQK7eyoF3b1hRvsrNbK/MKhQvH831YfzWLmGCWElb/VPsqKkh8wjr3XmX5V2LwBCG+p/ByBGB3+tHh7gu98HCq4B7hWyvywQ0o6r7v25yF/YRj1JK57xcmHetuVUT88cJexkjfANpLtpPutL9Au9cE0Umr2uRJ3b5WtQpEhPiYauy9hspE26L0ecDt9HbhD2FNKTm7tSQJ8iwt5Z19SIQUs
 E0dGUpwo
 XtLjak5Pr7YKIktQhYp7bhTkD0zrSxR63jDWBvns9pKPuAFZ7H2/N1GX4SxRFDaER8gGTwpWnxyvxQAf4F1yEemgOVAwVr3hkBbPCOlQ3NAF2BQz+kPZiYKvHSspnkH2qKz1SK7Td3K4oOUyc/rm7sppMPmikL09TkYpV8kQzkFQc4BHueJTsppGIejRSWfEk5fJJAev/6+y+2vylB7AVk9A+qcMQuaQq/rMttIjzF93pWYWHxPN2SmSAZXii2famaTv/j5IpeJCEiEoSeJycQ55eUaFG7dPByvgtsT++NnEIngTOTb0IV5dw+5zRSWRWHyiQ+6UaWnvmdnvBVYrS2g6Z7iyxQkRw+9NZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 01:20:17PM +0200, Thomas Weißschuh wrote:
> On Thu, Apr 16, 2026 at 02:02:27PM +0300, Mike Rapoport wrote:
> > On Thu, Apr 16, 2026 at 10:10:06AM +0200, Thomas Weißschuh wrote:
> > > On Wed, Feb 11, 2026 at 12:31:40PM +0200, Mike Rapoport wrote:
> > > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > > 
> > > > Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> > > > ZERO_PAGE() to 4.
> > > > 
> > > > Every architecture defines empty_zero_page that way or another, but for the
> > > > most of them it is always a page aligned page in BSS and most definitions
> > > > of ZERO_PAGE do virt_to_page(empty_zero_page).
> > > > 
> > > > Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> > > > core MM and drop these definitions in architectures that do not implement
> > > > colored zero page (MIPS and s390).
> > > > 
> > > > ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> > > > inline causes severe pain in header dependencies.
> > > > 
> > > > For the most part the change is mechanical, with these being noteworthy:
> > > > 
> > > > * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
> > > >   parameters. Switching to a generic empty_zero_page removes the aliasing
> > > >   and keeps ZERO_PGE for boot parameters only
> > > > * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
> > > >   ZERO_PAGE() is kept intact.
> > > > * m68k/parisc/um: allocated empty_zero_page from memblock,
> > > >   although they do not support zero page coloring and having it in BSS
> > > >   will work fine.
> > > > * sparc64 can have empty_zero_page in BSS rather allocate it, but it
> > > >   can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
> > > >   but instead of allocating it, make mem_map_zero point to
> > > >   empty_zero_page.
> > > > * sh: used empty_zero_page for boot parameters at the very early boot.
> > > >   Rename the parameters page to boot_params_page and let sh use the generic
> > > >   empty_zero_page.
> > > 
> > > With this in mainline as commit 6215d9f4470f ("arch, mm: consolidate
> > > empty_zero_page") booting sh on QEMU is now broken.
> > > The machine hangs before any output.
> > 
> > Hmm, looks like sh does not like boot_param_page declared as unsigned char *
> > This fixes the issue for me:
> > 
> > diff --git a/arch/sh/include/asm/setup.h b/arch/sh/include/asm/setup.h
> > index 63c9efc06348..b7c4469cb61e 100644
> > --- a/arch/sh/include/asm/setup.h
> > +++ b/arch/sh/include/asm/setup.h
> > @@ -3,12 +3,13 @@
> >  #define _SH_SETUP_H
> >  
> >  #include <uapi/asm/setup.h>
> > +#include <asm/page.h>
> >  
> >  /*
> >   * This is set up by the setup-routine at boot-time
> >   */
> > -extern unsigned char *boot_params_page;
> > -#define PARAM boot_params_page
> > +extern unsigned long boot_params_page[PAGE_SIZE / sizeof(unsigned long)];
> > +#define PARAM ((unsigned char *)boot_params_page)
> >  
> >  #define MOUNT_ROOT_RDONLY (*(unsigned long *) (PARAM+0x000))
> >  #define RAMDISK_FLAGS (*(unsigned long *) (PARAM+0x004))
> 
> Seems weird but works.

Seems like it's enough to declare boot_params_page as an array, this one
also worked for me:

diff --git a/arch/sh/include/asm/setup.h b/arch/sh/include/asm/setup.h
index 63c9efc06348..8488f76b48b4 100644
--- a/arch/sh/include/asm/setup.h
+++ b/arch/sh/include/asm/setup.h
@@ -7,7 +7,7 @@
 /*
  * This is set up by the setup-routine at boot-time
  */
-extern unsigned char *boot_params_page;
+extern unsigned char boot_params_page[];
 #define PARAM boot_params_page
 
 #define MOUNT_ROOT_RDONLY (*(unsigned long *) (PARAM+0x000))
 

-- 
Sincerely yours,
Mike.

