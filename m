Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A05CC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1134B6B06AB; Fri, 14 Aug 2026 08:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C46B6B06AC; Fri, 14 Aug 2026 08:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5056B06AD; Fri, 14 Aug 2026 08:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C364A6B06AB
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:44:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 497601C16D5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:44:53 +0000 (UTC)
X-FDA: 85099844466.13.9C16715
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A24BC0005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:44:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z7TtbqDq;
	spf=pass (imf28.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786711491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVL8QQveaA14mGW2dIQPVe+Wbaf5USv9xkXEwll8c7c=;
	b=LKEs2QJSWaHDNhUE4fXi8DAmgGHC70y1+Y8s8ZYDvzFEbYT1j+EhJYnj6PlWe1vqkqLhIs
	Kg/lFyy2ZVa/GU/21uO0yUaNm4grfsJCupKURHN3GIGhUfkT9s4CVIenAyjI8kXb7cAgHY
	WcHikcaT8YO4ryYdHBxbnvMZAup5xo4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786711491;
	b=8MbWUtSVcZQRGmGMTGyBFTrwDypFC2nCAVbApH8gLnE2hTFB0KmF81xxOYU/eYb0oWSUGZ
	vTJ6I/4TnIGB279OHnPXTk6GgkG8JebV1d3GWo48uYdVBMp2xyhgCAyW7TJhuHBlEwqLWg
	daIlNeCy9RwMU9cA8y+yrVgHLmcgTQI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z7TtbqDq;
	spf=pass (imf28.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84eb992a881so610022b3a.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786711490; x=1787316290; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uVL8QQveaA14mGW2dIQPVe+Wbaf5USv9xkXEwll8c7c=;
        b=Z7TtbqDqCWy7BBUt/a46gia9pLxnSVOTr1wx0zuqCcACTXMfqKCBlfchcrGhU6iQ43
         5V0/y1+WuqdA8ArSujfgV3ZQrfRfhR56kb1w37KAEiantFr30Sp9rwshrkIlTBk3927n
         pNqrBJE3Q9XSpsoG38OQaP34T9OIpzxHaZ0FTBDlydTueR33iedWApcVnK96MWwac5dm
         FYbJPHT2NS67dyImCmR/ukK2WoV3pKg6/KsfIGhOy0ODutfTU7aeLhP6aaU57geMflN0
         +KbEkwXMC0hitzRlgMYK+UfZW+a6U5hLcUl/0PL7CKK9OYp+LIsg18Ee6KdeSCLjFkIY
         MdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786711490; x=1787316290;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uVL8QQveaA14mGW2dIQPVe+Wbaf5USv9xkXEwll8c7c=;
        b=gYjG/W6vnIuKeAa/kVAe1fFLgk4wv+scq84efR1c4eO0w9njY6b8JB0CjH5PTXVmTQ
         Sgt9j1PIYyMC7mT9O/+Q/s8xJwLdBVxsxEa4HBugSFEJGEaWW7Ono/Vqno5FFEs6yQfH
         kntvFApf15xSykpkah1jjZ1oH9R29nF9OyEAuBO2RIlPUiYQ7b0J9spOF1pp6B7E3VW6
         K4Gr/iEFGnq/OESlYI5ntyKfDreskoOs6l2KZJJKb/jYXdDj8HLAncleDK3UmXcCPNfm
         BEHOSg55QsL/GCNfV2aH13ALhuENxRsABKvfw6KGYijw6ZO6+ujkJUh5BKMTghycAfSR
         6lsw==
X-Gm-Message-State: AOJu0YyHx0U2OIm6s0oVx+/rUmWpitLErPkf54vLv5VkKJtmVBpodiPE
	RnmNZ9CYgyPUxd73FtLi2pQG7fWZ/k6J7G3SqW9O20/XBIVT3j3OMKC9
X-Gm-Gg: AR+sD12Ug1Zc6gs+tSEoox9vSA+XG+j4/jsJkslv6lnYt/TGttYc6sX8nPvNHdJqfaj
	fzb2NUGsI3ATOUCm9Nc/wNP0xL+aq5Kj7YedN5fBHoshhb1EZ+YmzdvACFLX3n7xIQBZOmb3Nhh
	9wftXeZW7QHI9JZZu4svb7yBZ1PBx4vQ27XDnMzSpT6bDYzapuq+1w0bDsYx6dX28l1ddWMvoWt
	CFllJeZuLAy2E8h2ua3xUsdVsA1+BdWoXgTK+nia6frs1EUlwo9QceftOwfdi8QLblvXMc5Lv4W
	jjKyWAotb7NcXkcJR5ytJxllYAveVYKgjVKkt7ATNkaBTXl/zsCkLRfBRpaLrLf+h2MlKEg/v2P
	oe8erYBqDA03cAard7pmgfPEM+NoqZKe+QV912cZOk8HswBMKKg24168wC3U3Jb4UrwGnsnB4/i
	geNmuyO/rVoMezVRdZHlJTfr3l/E6UA5bfHEYrUJUmmLg9pv5/5Js7FLxj3L9Bn0dHAExoNUtKL
	ruFsNJBcuA60IahphWO8GGwXebgEAKkLKpEcR8bWK2HviXxf5wnwNWSpfzn8EKHm4vBWs1R/coX
	AI9mHA==
X-Received: by 2002:a05:6a00:3981:b0:848:2eac:bfb2 with SMTP id d2e1a72fcca58-84fde004804mr5805806b3a.13.1786711490219;
        Fri, 14 Aug 2026 05:44:50 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d266e36sm399011b3a.55.2026.08.14.05.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 05:44:49 -0700 (PDT)
Date: Fri, 14 Aug 2026 21:44:45 +0900
Message-ID: <m24igwrhvm.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: pfalcato@suse.de
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 4/6] selftests: fix build errors on alpine linux
In-Reply-To: <an7eC0oBvfjB6g54@pedro-suse.lan>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-5-thehajime@gmail.com>
	<an7eC0oBvfjB6g54@pedro-suse.lan>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: u7gboi3bdfc98grjgmp1qeba18ew5xx6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A24BC0005
X-HE-Tag: 1786711491-779356
X-HE-Meta: U2FsdGVkX183r082Oct4oMJIkPRScmOMA67oHlSt+OHY9pAawZ781rBHsy3rYq8LvL8YJd/pyX2f4ouY/PBThDyhlaRgFNJdwHYPlg/j7RykROg4HffelF62bMndIVLWiWLo2TD1p7r9OIAs0vV1rn0m3o3trbWXe2/h2op1PBJtpUasJ3P/bIYTJMOUirFvRmalOWWGRCW+wg6L9yssyRe8alTqkhICSPKvjy6Wc9B+RgRB1Xdr/l8Kn5YHGUyuHrBAaMkUQtIpq2qVHKXNjBatUCH50ZJCF+SeTsY6NtOrh2KKJxBnuwCR2jmImQ0tCPuY9AmZcvUV6JThXN3XwY2Q2qE0Nc80Qvd58E7l32jAo/lpWCwBSEMimylKO/qB37G7bLBqZtL9Be6nzfTIBau2G+EahZfc4zR125iqZw2uF0MaY0WD2rW+88XQIC8oOoXLk3BuvKgycRY9SvJY0/tV1mOJ+p16zdv2bGd8vQbtcZRHgCePdeXk/xnckTQORTgGuYtpkEPsbZVVquU5fHSt8N0luZH515Zbd4BBs9+y2wVwsYT3G3dX6WsAKas1fQE1aeCar//O968FwH5cZKEA8RS0MueLg3MaqMcpagxkT4mCX1dqWyW8iSxdGofLa4HuGpvfY4jCfwo+Ze/UYtJS3pfPuPpupclwqnPxJ7KEs2rgR4L77vddF+lNPKZCXOBbx+iIAgUtjH0df/cwF0xTuyz0D16i+ypyAPyXKQ8+IxlTC1rFyTY5KpFQaLXDcz5Z5zbK5mYJgz22FlzSBNbxgR9iDKAtzlRRnqIBrVzmmWX8S+7K1EoJhOWgiRjg3uOwojtIVW/h8dZSdZNRcPIH1XEEK4t7UUhbopou/yqV6bDp9/ZVBEPxNoblq7CkCWS+B50axZpYVv0MUzYiHfMAfTP4Asc0kPEv8/U5xvIhNb3GxbHwaQf2LgXDS/4SD+7xVdUQyZN8R6/QyL7
 QMmhrBwA
 HIC9GJhfXbvvK3Ju1xLGTrhQNRXZTCLYXX+BfdaScNsh46x2HMbtkj/WtQBwwxB20xQmL67FzKUCAU6BCEoLhOS5F3RBVkjMLHOUzUdsJIvv1w/hrHIptKFuOXWi/f4tQcyTx2+2AzNZrMQNrVKAdzGqqlNIexQLREVxZXwjpYLqKGVcdobPK1lLNkrAGe7XkiX+G/jeHmQulQuhkF9awR9hBY7ndWyeybLeUEkZhkPxSSQNKqJeHxhazJ0AhY4LLvz+1Pt/B0axtSZsXX8pRQBjQo2xvPkgGqiFnIbwwD7zjmK2OZS1mRuN7KFWFzp0Ql8ISq0BYZvGwuBT4uqzBA28G5a48Tc7WpapV4zOCuju0RFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Pedro,

thank you for the review and looking at the patch.

On Fri, 14 Aug 2026 18:34:21 +0900,
Pedro Falcato wrote:
> 
> /me puts on his libc hat

thanks, this is really a good news to me.

> > diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
> > index ae18c491ae53..ac21bf3d802e 100644
> > --- a/tools/testing/selftests/kselftest.h
> > +++ b/tools/testing/selftests/kselftest.h
> > @@ -58,6 +58,7 @@
> >  #include <string.h>
> >  #include <stdio.h>
> >  #include <sys/utsname.h>
> > +#include <stdint.h>
> >  #endif
> >  
> >  #ifndef ARRAY_SIZE
> > @@ -81,6 +82,48 @@
> >  #endif
> >  #endif /* end arch */
> >  
> > +#if !defined(NOLIBC) && !defined(__GLIBC__)
> > +#ifdef __LP64__
> > +typedef int64_t __fsword_t;
> > +#else
> > +typedef int32_t __fsword_t;
> > +#endif
> 
> The code should not be using __fsword_t. Per statfs(2):
> 
>        The __fsword_t type used for various fields in the statfs
>        structure definition is a glibc internal type, not intended for
>        public use.  This leaves the programmer in a bit of a conundrum
>        when trying to copy or compare these fields to local variables in
>        a program.  Using unsigned int for such variables suffices on most
>        systems.
> 
> and indeed if you look at musl's statvfs definition:
> struct statvfs {
> 	/* ... */
> 	unsigned int f_type;
> 	/* ... */
> };
> 
> so it should be perfectly cromulent to use unsigned int here. Or use an
> actual usable interface :)

thanks, I will drop this chunk and propose to update mm/gup_longterm.c
to address the issue with musl.

> > +
> > +/*
> > + * for a workaround to avoid struct conflict under
> > + * musl-libc (<sys/prctl.h> v.s. <linux/prctl.h>)
> > + */
> > +#include <sys/prctl.h>
> > +#ifndef _LINUX_PRCTL_H
> > +#define _LINUX_PRCTL_H
> > +#endif
> > +
> > +#ifndef PR_SET_MDWE
> > +#define PR_SET_MDWE 65
> > +#endif
> > +
> > +#ifndef PR_MDWE_REFUSE_EXEC_GAIN
> > +#define PR_MDWE_REFUSE_EXEC_GAIN (1UL << 0)
> > +#endif
> > +
> > +#ifndef PR_MDWE_NO_INHERIT
> > +#define PR_MDWE_NO_INHERIT (1UL << 1)
> > +#endif
> > +
> > +#ifndef PR_GET_MDWE
> > +#define PR_GET_MDWE 66
> > +#endif
> > +
> > +#ifndef PR_SET_MEMORY_MERGE
> > +#define PR_SET_MEMORY_MERGE 67
> > +#endif
> > +
> > +#ifndef PR_GET_MEMORY_MERGE
> > +#define PR_GET_MEMORY_MERGE 68
> > +#endif
> > +
> > +#endif
> 
> This looks fine. It's the same old problem with musl and kernel headers.

noted with thanks.

> >  /* define kselftest exit codes */
> >  #define KSFT_PASS  0
> >  #define KSFT_FAIL  1
> > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> > index f02cc8a2e4ae..2cc819006424 100644
> > --- a/tools/testing/selftests/lib.mk
> > +++ b/tools/testing/selftests/lib.mk
> > @@ -197,7 +197,7 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
> >  	$(CLEAN)
> >  
> >  # Build with _GNU_SOURCE by default
> > -CFLAGS += -D_GNU_SOURCE=
> > +CFLAGS += -D_GNU_SOURCE= -D_LARGEFILE64_SOURCE
> 
> What needs this?

this is a leftover chunk of patch not for TARGETS=mm, but
TARGETS=drivers/dma-buf, which generates the following errors.

udmabuf.c:137:9: error: unknown type name 'off64_t'; did you mean 'off_t'?
  137 |         off64_t size;

I will drop this chunk from this patch as the patch is only focusing
on TARGETS=mm.

> >  
> >  # Additional include paths needed by kselftest.h and local headers
> >  CFLAGS += -I${top_srcdir}/tools/testing/selftests
> > diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
> > index fb4600570e13..aee6be530ccb 100644
> > --- a/tools/testing/selftests/mm/hugetlb_dio.c
> > +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> > @@ -22,12 +22,9 @@
> >  #include "kselftest.h"
> >  #include "hugepage_settings.h"
> >  
> > -#ifndef STATX_DIOALIGN
> > -#define STATX_DIOALIGN		0x00002000U
> > -#endif
> 
> Why doesn't this fallback work?

I thought that if this macro isn't defined, it's not available in the
underlying kernel, but that's very idiot modification given that the
libc headers is not up-to-date but the kernel is supporting this, this
ifndef should help.

I will look for another approach to address the situation of musl, and
revert this for the original purpose.

> > -
> >  static int get_dio_alignment(int fd)
> >  {
> > +#ifdef STATX_DIOALIGN
> >  	struct statx stx;
> >  	int ret;
> >  
> > @@ -43,6 +40,9 @@ static int get_dio_alignment(int fd)
> >  		return 1;
> >  
> >  	return stx.stx_dio_offset_align;
> > +#else
> > +	return -1;
> > +#endif
> >  }
> >  
> >  static bool check_dio_alignment(unsigned int start_off,
> > diff --git a/tools/testing/selftests/mm/mdwe_test.c b/tools/testing/selftests/mm/mdwe_test.c
> > index 647779653da0..031c79ed067e 100644
> > --- a/tools/testing/selftests/mm/mdwe_test.c
> > +++ b/tools/testing/selftests/mm/mdwe_test.c
> > @@ -1,5 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  
> > +#include "kselftest_harness.h"
> > +
> >  #ifdef __aarch64__
> >  #include <asm/hwcap.h>
> >  #endif
> > @@ -14,8 +16,6 @@
> >  #include <sys/wait.h>
> >  #include <unistd.h>
> >  
> > -#include "kselftest_harness.h"
> > -
> >  #ifndef __aarch64__
> >  # define PROT_BTI	0
> >  #endif
> > -- 
> > 2.43.0
> > 
> > 
> 
> Honestly, I'm surprised you needed so few hacks for this! But if I am to
> guess, there are certainly much more problematic selftests out there.

Currently I only tested with `TARGETS=mm` and didn't look carefully to
other tests.  I will look more into running other tests on alpine
(with CONFIG_MMU enabled) first, then will see !MMU environment with
investigating if those are meaningful to test on nommu.

anyway, (again) thanks for the review.

-- Hajime

