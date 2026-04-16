Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747C5F8A157
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7CD6B0005; Thu, 16 Apr 2026 07:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2791D6B0089; Thu, 16 Apr 2026 07:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F3D6B008A; Thu, 16 Apr 2026 07:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02B8A6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:02:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43594B7E4D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:02:38 +0000 (UTC)
X-FDA: 84664130796.22.016F9A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 84C371C000E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:02:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g/lvgYMq";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776337356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSOJ7fp16/HzLzUNRxULVnij3qirHW0INLIB+g7KEG0=;
	b=AAeatbjaBJDbM3yb2OVR95GzPJlMg9L3v9DYTXZ8dCX9k5kC8MAJK1Qf2fvd+ImpLUyrxi
	YGCsPTaOVkFlQX7BhroNsXX4H+Jn8eFlNCAJvnf0cM+DNYDb/U9vNTBL4LJQa4X+uIxsgQ
	NFr2RzWTiM+E2IPDSA6nlXdfx9AVbhs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g/lvgYMq";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776337356; a=rsa-sha256;
	cv=none;
	b=jI+9t9HlTkt1AuL6D3M+miiV+A4BE7pNiaYxPJvDD/NwFE4aPAVozs+OHFc8guoDgfOya/
	ee94HVxe6RhGGGJCx30U735HY2Kg7W04s2/vgsHgkdix/3wkMiy3EkH+jsTOWjjhS/GP19
	MjUyA/GZB9zou6ETPHbLfgkgd3VHU8o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DCD0460127;
	Thu, 16 Apr 2026 11:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF43BC2BCAF;
	Thu, 16 Apr 2026 11:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776337355;
	bh=46lfpU4rVAhipbkBh+dqyHYerEK6axXIuEa3SsVYybY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g/lvgYMqhxgbdZTndBZsA+ofc5/WHdXHktUB69Po+cR1Gl88XowUpJhrnwSZEv2Z0
	 EFOUK6NK9bhmP95sehwR1ihfpVS6ev2LtISPmLK5hA4U3NAhUC1OSNZXj0GqV6z5Fj
	 wkfqAEUDqhuinGIVoCdtZ3rqhyAtDrA5xsNWXq7Z8fs3lq1c9y1xdFrC+kYc6iV+cC
	 gejIMgh02Vs+vC3DyeQGvoWICUtOz2Fi9zeyrdAQb5KRV4m9RgzTJZ8uSfiM8EVDCY
	 EH6prm0nfwKyFqGeSKs1L4h8rUPgkSrwcMAKQ80s8v+O7wWsN9R+oo6RYtXuFaZuHg
	 aPuaT1qjRVkBA==
Date: Thu, 16 Apr 2026 14:02:27 +0300
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
Message-ID: <aeDBw4O655-pXiHy@kernel.org>
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-4-rppt@kernel.org>
 <20260416100221-57063053-1c9e-4450-8b0c-d9783657fa47@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260416100221-57063053-1c9e-4450-8b0c-d9783657fa47@linutronix.de>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84C371C000E
X-Stat-Signature: 6r6wsokrsi119whctipcfaggeyhcbm1t
X-Rspam-User: 
X-HE-Tag: 1776337356-842140
X-HE-Meta: U2FsdGVkX19BgoU+gr0FW+TmI8ccqFzqC05/t2i1Ry7oHIm7cx7pKjRnYy20FAiFgbw5Mj5LthYfJKu0U8rKNrYAwK4Y2u2zoVqXkOlk4ULv2NUDgSDOWKZUJ7Yr6LJsVoYK+xrb6t/jI+aGYH82AeZYtSoNrDzlc7c5rNhvxNp57dft9h5lmd7qsGl/P3INYmXfn9TzkWwh/HfiOgSqiXTNwSvVamCDGgSHpNNbJEUl7+LxzTnpuA2qpomRG3F53aR5DjWX+VXu33Bj29nozBU66TuFKS5v0EZdLizyo/odxwNUYiFfgomUYA7bnkd2LRrIRYkGVcvR5jAgsEcLObOY5yu6ZKTPmgf4yABNDAN+2VgzlDs1FTocgbSomAxW0f6QRZDk4y5kl5eXF3LHfyO4iJxw6cz+lkfOcsR9kP/zNLDO0x+M7neQ8JN1Ye6BXSZjcfB0SXy8NH9ifQUdI+QEhiv7K6xwejixDlOsKHv2TIm9PpvA780GeiY91SgA2EUcTVlLAQDK8QZ97jOpALepKx+ygviEFKzHHtnSbl6k65VqO92cyHjKUcyFm3H9IkI2fJIq993U5spw9qpbKUOwQT8P7mB9RVREhqxWS+jAoPZB6FYI+Gx0eBscuQ9XetaNKZO9KBDcDWtiZ2N7nA4zk7Vjh84Gl3YQrgZpNJyXXi4i7l5NcOfZ076xnsx4PI49aO94REqpf8lD+VoofT9LHt/8nG4fVCRKFGS2/5S45qtqjPhBVqAgWahDW4On4sZJktLanviHDQ/9LM1D7uqAM/PgfKyudgq45hDA5uDCjLWhjuf8xwFW2pg6UumiHSIcYHqMDnTaeXw2tNh8krF+jus3w+n64GYmabRofo5hNqlu2cSBrsrKZdXwdlqny+uboSxEl/WqCExJrlXI5cNZD+w7KNXLZVCc+AAvp3I4c16o92ekYBgZZ3DcOEpdMhs25FuvOLD2jBlcupM
 tIRUDaj4
 vumrGMPLDsUxz2/wxg6nH5g5qkVkTxGQYI5WmIx5AyU87RcHFTHeNBLOEjrlscwL/dpq8VaEx9GiWDCOnmq9Hy+idnmDqibQrSfqTBZTMDQ7KLJvyu9kUEsJ4SnhB39e7GaZ1JZ3sL9D3DCHfycXbtE5qk9IkBhOWlWEgf6lzseIY6S3181n8TBWYXNGG75XJruZNnObqE7ty/IFwVo7JhJBJiQx+H6OBxj1O1P/Og+wpybH+yMubb7V8NgiTu12NhcK1kKQeT8Gb+AZV+mcHmf07hCegLDYI0bfgN3JGRIFwKPJ9RxCxdxdLGIp/fQlEbIqiFVaiMS5TF9cnOOcd2NHfI/krTKRr1BVN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 10:10:06AM +0200, Thomas Weißschuh wrote:
> Hi Mike,
> 
> On Wed, Feb 11, 2026 at 12:31:40PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> > ZERO_PAGE() to 4.
> > 
> > Every architecture defines empty_zero_page that way or another, but for the
> > most of them it is always a page aligned page in BSS and most definitions
> > of ZERO_PAGE do virt_to_page(empty_zero_page).
> > 
> > Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> > core MM and drop these definitions in architectures that do not implement
> > colored zero page (MIPS and s390).
> > 
> > ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> > inline causes severe pain in header dependencies.
> > 
> > For the most part the change is mechanical, with these being noteworthy:
> > 
> > * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
> >   parameters. Switching to a generic empty_zero_page removes the aliasing
> >   and keeps ZERO_PGE for boot parameters only
> > * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
> >   ZERO_PAGE() is kept intact.
> > * m68k/parisc/um: allocated empty_zero_page from memblock,
> >   although they do not support zero page coloring and having it in BSS
> >   will work fine.
> > * sparc64 can have empty_zero_page in BSS rather allocate it, but it
> >   can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
> >   but instead of allocating it, make mem_map_zero point to
> >   empty_zero_page.
> > * sh: used empty_zero_page for boot parameters at the very early boot.
> >   Rename the parameters page to boot_params_page and let sh use the generic
> >   empty_zero_page.
> 
> With this in mainline as commit 6215d9f4470f ("arch, mm: consolidate
> empty_zero_page") booting sh on QEMU is now broken.
> The machine hangs before any output.

Hmm, looks like sh does not like boot_param_page declared as unsigned char *
This fixes the issue for me:

diff --git a/arch/sh/include/asm/setup.h b/arch/sh/include/asm/setup.h
index 63c9efc06348..b7c4469cb61e 100644
--- a/arch/sh/include/asm/setup.h
+++ b/arch/sh/include/asm/setup.h
@@ -3,12 +3,13 @@
 #define _SH_SETUP_H
 
 #include <uapi/asm/setup.h>
+#include <asm/page.h>
 
 /*
  * This is set up by the setup-routine at boot-time
  */
-extern unsigned char *boot_params_page;
-#define PARAM boot_params_page
+extern unsigned long boot_params_page[PAGE_SIZE / sizeof(unsigned long)];
+#define PARAM ((unsigned char *)boot_params_page)
 
 #define MOUNT_ROOT_RDONLY (*(unsigned long *) (PARAM+0x000))
 #define RAMDISK_FLAGS (*(unsigned long *) (PARAM+0x004))
 
> Reproducer:
> ./tools/testing/kunit/kunit.py run --arch sh --cross_compile sh4-linux- --raw_output=all example
> 
> > * hexagon: had an amusing comment about empty_zero_page
> > 
> > 	/* A handy thing to have if one has the RAM. Declared in head.S */
> > 
> >   that unfortunately had to go :)
> 
> (...)
> 
> 
> Thomas

-- 
Sincerely yours,
Mike.

