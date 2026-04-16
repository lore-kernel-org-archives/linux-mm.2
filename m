Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720E8F8A15D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2286B0005; Thu, 16 Apr 2026 07:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83146B0089; Thu, 16 Apr 2026 07:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971B36B008A; Thu, 16 Apr 2026 07:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82AEE6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:20:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1232413BAEC
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:20:24 +0000 (UTC)
X-FDA: 84664175568.18.ACFD2F2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0234F20008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:20:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=G3lhoHOX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+rrM0Y92;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776338422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LExLVuqyhTOkOVamJWb5O1XClOyZrMPwBLip8u5VI/0=;
	b=usEc4OO6Uk6YsFLLVMU7pto6JAwweyBH1DKw9uE5PvzsJvRmuPhLTo3CM88vFYCU+HrLBz
	Qq09VPXn53Cu3Ff6/IiHoeLEZWrxSy4nhdpGrkacVw2I9lcu0cPUc1DwIDBF8QriOMLgPB
	QqzmbyRD9d2muqyWLNiAxPdrnr5wHSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776338422; a=rsa-sha256;
	cv=none;
	b=gpvya/A3M5li/XLTSxTOGq/Q6mRpfKCj/IWlMS2vzxy0l3yuJZ4dVnjprbS1VFTfQd4lWt
	PiLeRhIrSAZPXtGQCoEf+2p+88Tu5LM/PxcqRaqWbmgvee8PyxzbyWqCVMLVGqgBMCBzSB
	iS0b4OLUWu8yyP52vX4XMaWOyIE1UFw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=G3lhoHOX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+rrM0Y92;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Thu, 16 Apr 2026 13:20:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1776338419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LExLVuqyhTOkOVamJWb5O1XClOyZrMPwBLip8u5VI/0=;
	b=G3lhoHOXFvu2XsLZqqBxwQ2aeouAExJvErpcyfstcq93MsKzpwePMU43HG/7Smdqh2eVLN
	S9N0K2FkueMkGcd2PERsiyQKO973JEAOFgg0oAlBvsDzprr7kLa5a9NM+XMCfcTefBennr
	qmIiOoQP7NijCTGdGX1eEkTKFFS605R06xRjKM4Ou+SBXlgyIDE2W6F2moUTXWs0IrLDEw
	3V8kbH62mWMw2sY2Bd1pCZeayUAgH9h2gSPC6EyZ1hZqZPiKgYlv5atGvLdCBOhKtkLxiR
	DQfbyjqaHZWOXZ3Vj3+tmppceARSYceRRMmN5egMKyq15GfPaaOgHJlfSCndJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1776338419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LExLVuqyhTOkOVamJWb5O1XClOyZrMPwBLip8u5VI/0=;
	b=+rrM0Y92oFfTPzNxgkddAmr7KUd99MKZNko+I6bymlTxZFuEns7sCvL5+MrFsVvu0tp1pB
	Pc2kkXE0TvQ5xTAQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Mike Rapoport <rppt@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 3/4] arch, mm: consolidate empty_zero_page
Message-ID: <20260416131914-f20c3a56-bddb-4488-b4bd-560e52ab9416@linutronix.de>
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-4-rppt@kernel.org>
 <20260416100221-57063053-1c9e-4450-8b0c-d9783657fa47@linutronix.de>
 <aeDBw4O655-pXiHy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeDBw4O655-pXiHy@kernel.org>
X-Stat-Signature: ihqtpj7eb3bpg879jshymirxzyaod3h3
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0234F20008
X-Rspam-User: 
X-HE-Tag: 1776338421-556699
X-HE-Meta: U2FsdGVkX1+po8OkwRP3kn58fxqkdxq9PBWRupE4JMBfJNmwA9OXOZlDGYza28htiEjVOHujg6D7xg63NsjvXIU5aXOFSKBgokOg5wT8SmJ1QHw7OVrmZVvlHJ4KwXg9C+XaS2GJjlKWtdFEVwrWMVW0u7jLEQIPEfXH8ubdkNzeNowT49PjgQ22IlLIB58VPOuRyqqvLgRJOE4JKZXJquB0VgHsiMrlor+IS7qOqclqaW0uBOA4aFvhsD1T/UbZwLAugukT+n1YUvDbBZE6FD8H0AXrSjqa0tl+tJlioJ+SfkjFq4COMjLHeBxXyuaYkQ+cWShrAg+ycoPWaPRBTwS0iyEsC2tpkJmSInJZpx/5N+VlfRhj+FPB1s7yk4R3UJHxSdouS/9xNyIMnGKjuSGtBadNen9U+b05h0dssBRLHx5z6ou+Vaj6QWZpDBJLIXXaGm9/OBU4aEtFbZ0d5LtmwOLlGOJlg8X61mJZ9BjozLc6nwPpafd2scJO6qwU1LTsmOmh6EOK6igiaPK9cA76/J6o8llddpvDRpk+7kukCnD/lhBww0GSWTUTvorAzDEE6PVDGbVnCtkWkXU/Wbbt7rKZ2b31s+EGh1juWYXeHC7wL+zFzmIg8HV4bAxZg1lCY2tZHUmQFQKh2U+z+q/kR4X7NSh0ep4yj8zmnrCTvvNochZLFrebOVzW8nVnt1ZAJGgPLv5H0K1+3TdGyywLu8qzDbpYsaZQQZZP/diltCwZE/ZGJd8LTy4nszgJBsJnWITnuqL8KgVMyq4rXhhkVGfNlHE+EWRcWWdIzKygmy+k4mjWl21KY0ZakL6Uj9rHes3LatH+X1T05q8DNMAgO/P4xonQQ7by0Mfypo5MCXu1Xw2Pn+QpWbMazSwhPxc9Kys/QlB1WzldZRUkxVgMfSHc7mrcjKDnY0YbpZl6EDzuo9UAY+5BBxO2mgj+Yjj4dPhZnNuEyy+LBjg
 GkXB0MOY
 LYexRoMWCbEv7qfDc8ZDTKx7PPF7engl49kFRBsMDzWQl2ZNRZQ1IXpISN0VN6EQlE1dCH4J/6XBUO2FJNxIlHjjGSnFFREh9QOfgFroML/HmnsjCxhvjBAQajF3J6IJ+SnIuMRhL5EBSXScDdN/rphjyAoONjeAJ5tSAd2BM3EryraaGt3JAxoVvlfn7IbGUreI0EUloZnfylEI0ws9Z1KNyOQZUBc+2RjnT5PcRmftJofZk3Hny3L4AoiZ6BU2koMpjC5ktV9Cu9gE7sdWBhLswn5d7Oa+CVtbiEyNY8KzGV69O/0LMoqZwPEIN8rLZIMs9Mka77lgusua3zIUNtQyPnR9zjWe0JCx0lcQ3DwV+pLpuhBoz+FAaGK2mL3l7eDjCAeMkA3weCh5AKN+4euMH6z6xy64W3FrvrCFzfP8JovK/W4hjLIZvGoSCIw9MF2RpseZJJUokqgizaMtU8TIO/vzIF/j3vx6YOPbDQD6KbVkrkfyY2S5CkRZrcwo0Y8dvXaOWP9C9kzvWeu35gnX3NDwsdWSuc27S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 02:02:27PM +0300, Mike Rapoport wrote:
> On Thu, Apr 16, 2026 at 10:10:06AM +0200, Thomas Weiﬂschuh wrote:
> > On Wed, Feb 11, 2026 at 12:31:40PM +0200, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> > > ZERO_PAGE() to 4.
> > > 
> > > Every architecture defines empty_zero_page that way or another, but for the
> > > most of them it is always a page aligned page in BSS and most definitions
> > > of ZERO_PAGE do virt_to_page(empty_zero_page).
> > > 
> > > Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> > > core MM and drop these definitions in architectures that do not implement
> > > colored zero page (MIPS and s390).
> > > 
> > > ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> > > inline causes severe pain in header dependencies.
> > > 
> > > For the most part the change is mechanical, with these being noteworthy:
> > > 
> > > * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
> > >   parameters. Switching to a generic empty_zero_page removes the aliasing
> > >   and keeps ZERO_PGE for boot parameters only
> > > * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
> > >   ZERO_PAGE() is kept intact.
> > > * m68k/parisc/um: allocated empty_zero_page from memblock,
> > >   although they do not support zero page coloring and having it in BSS
> > >   will work fine.
> > > * sparc64 can have empty_zero_page in BSS rather allocate it, but it
> > >   can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
> > >   but instead of allocating it, make mem_map_zero point to
> > >   empty_zero_page.
> > > * sh: used empty_zero_page for boot parameters at the very early boot.
> > >   Rename the parameters page to boot_params_page and let sh use the generic
> > >   empty_zero_page.
> > 
> > With this in mainline as commit 6215d9f4470f ("arch, mm: consolidate
> > empty_zero_page") booting sh on QEMU is now broken.
> > The machine hangs before any output.
> 
> Hmm, looks like sh does not like boot_param_page declared as unsigned char *
> This fixes the issue for me:
> 
> diff --git a/arch/sh/include/asm/setup.h b/arch/sh/include/asm/setup.h
> index 63c9efc06348..b7c4469cb61e 100644
> --- a/arch/sh/include/asm/setup.h
> +++ b/arch/sh/include/asm/setup.h
> @@ -3,12 +3,13 @@
>  #define _SH_SETUP_H
>  
>  #include <uapi/asm/setup.h>
> +#include <asm/page.h>
>  
>  /*
>   * This is set up by the setup-routine at boot-time
>   */
> -extern unsigned char *boot_params_page;
> -#define PARAM boot_params_page
> +extern unsigned long boot_params_page[PAGE_SIZE / sizeof(unsigned long)];
> +#define PARAM ((unsigned char *)boot_params_page)
>  
>  #define MOUNT_ROOT_RDONLY (*(unsigned long *) (PARAM+0x000))
>  #define RAMDISK_FLAGS (*(unsigned long *) (PARAM+0x004))

Seems weird but works.

Tested-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

Thanks!

> > Reproducer:
> > ./tools/testing/kunit/kunit.py run --arch sh --cross_compile sh4-linux- --raw_output=all example
> > 
> > > * hexagon: had an amusing comment about empty_zero_page
> > > 
> > > 	/* A handy thing to have if one has the RAM. Declared in head.S */
> > > 
> > >   that unfortunately had to go :)
> > 
> > (...)

