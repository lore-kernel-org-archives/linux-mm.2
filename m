Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FEF10A1E63
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3205E6B0088; Thu, 26 Mar 2026 14:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D18B6B0089; Thu, 26 Mar 2026 14:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0026B008A; Thu, 26 Mar 2026 14:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2BB6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:37:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6C351604B8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:37:22 +0000 (UTC)
X-FDA: 84589071924.18.DA861EC
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF5E0A001C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:37:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZxWjtvTV;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774550240; a=rsa-sha256;
	cv=none;
	b=HQIV2uoZZeVz1H2p88XK9OFJZMblo9cGGEe1q2Q7Bb2QJdIPV6eHgBuwGBYsHYUJivEbAW
	IyjkjfYHSWnJ5aKM3tbB8IMhQNH39Lq6YcpAq4Uvcs+1pECWiGwKDD+W4Z9g41Vk4ohjGA
	eWh7xjvIOYmu9fIBlgNEMfir27j3usg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774550240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNnO5uEjZAJK+6dtDEzqReuQwWCmolqZu6o6OpWgRS8=;
	b=FO0Ib1EoRHWL7xQPIvTq9Fmqgo112jN/ilff0KUUPNI/gisfzJhkLUxOX4ZaDUQUlngNkH
	Am+sIPaVui2+DckItjMjekBhd830zbUsYiTpjv3F8Phw0xvNX6krgG5AN97MOppuuV7/2/
	ByAjlYCLVXhG7Zgtvf9XGH2XL3cWOjw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZxWjtvTV;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cd78a4ce8dso188021085a.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774550240; x=1775155040; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mNnO5uEjZAJK+6dtDEzqReuQwWCmolqZu6o6OpWgRS8=;
        b=ZxWjtvTVQM7Nt9fYCDveRCqbhdiCb82cPpcush6Ut9xyF/dwq5Bgq9TPOLUiR8nGon
         BxCnsq/T2Isu1EZDzreGgpdIuJVgK1u9rTFovMhNkPEE3GRJvG4cLU0xDT4BY/Ch4Tr4
         Q8SYabhAJU6NXnR5NlgePi8EVZKVsXZxNU9nT9ZQT7m5/CaDlN0+T9v3vEHgVqalT5Dg
         dSOmMAqTlQ49/q/YgGc5CFeStfiSJ0d4y9CJLL3UxvjsEDM0a5dX4GHEvRqmUo9Im/YO
         v0393kAAoARN/rFGATO6HtgVPD97i05GhJXNrX8X0Cl2ypx/6CsFFmcddDB2g/33WZlK
         elXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774550240; x=1775155040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNnO5uEjZAJK+6dtDEzqReuQwWCmolqZu6o6OpWgRS8=;
        b=NWlKWdPW7Wvx0xBVfn2nrzn+eufxxUljD+qnkLMotE5mxJNxeP6/GsMQx15MijW8Uu
         AMP950eqz9Hg+rJXFmh2Berd6/69fGYACyZ75wXlA83tznrbCdRjkVQB+7byDDH3J4xi
         wRH/A9NjEM1MYXd3+M1RxsnvgotyuPOE8V+iYdhiDlAkb1InpJHOxooQKyCCkXVGRXMM
         pRmwGJf8toenA7y5VFRvMJ7CmPh5wg/+ybS7ImwCM2vBy7B7KAMxN0dyxwU9HNWyXehf
         WWMGbRGWa1n9Rr4Y/FfL68Dn+3gCPmJsweltNzqL9I++0jTdkh8VZ3LnKIJ6RsJFX4X9
         BWuA==
X-Gm-Message-State: AOJu0YwBXTB68Ye+zHb/AWHmn9IsZEDqdZV+jdhlzxvAyf8h1wHOaEvG
	/rbHpT2PVS0o8R7BFqDToItGuiQ+24UmfFKbFiBlOPGxAgmDuTheyE2shWGt+uLGbeY7bOYLiNj
	Vesi3
X-Gm-Gg: ATEYQzx2BpAJC5dGOQ4tQPElNtvtTxP2ai4VBZnR9hojaTx+Ysp7neX8/UghyfiCiev
	JRBXjoH8XfVCxNKFnD/HKbzR+fhzvbjG5WrjITVoJ/CuSUWPGMrmoK5dJkbFOhzCXMgfU7aemm2
	OI0OLl01b3+onYjBp1YMIbOOYpChTnrDR/+hGJw+pj6EruNcNXZCNou+Ow2OE+YczXz/HrvDntZ
	iNtlPhZqZ1LEn/4WZP05/P7/OPtSw+rn7eXN/hIP7A2EPMyot7rOdqUFfgx1UqnBbuSKieWtCOp
	6CuG0N6IzEGcpMDlCnG5cTodWpmQ2I5C4O91LGPOEhFOM8CAFVRrcQIGrNjtT/0B23/Abp9yR3D
	LESSVJyCvRxUa6uQW+69W5Q6kXxuIIkUTTzNiZmDW0MByre2JK6hDTjk6YSs6qSIvcFWVKKasHu
	38pMegkfHjUxlQe++FJ1cs39Sj0JJSewg=
X-Received: by 2002:a05:620a:f10:b0:8cd:b7ec:7adb with SMTP id af79cd13be357-8d001072b95mr1231136085a.60.1774550239805;
        Thu, 26 Mar 2026 11:37:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::2:e5e8])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e3a2340sm321348485a.6.2026.03.26.11.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 11:37:19 -0700 (PDT)
Date: Thu, 26 Mar 2026 13:37:17 -0500
From: Gregory Price <gourry@gourry.net>
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, baolin.wang@linux.alibaba.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Message-ID: <acV83cdc9ZfNk8Xh@gourry-fedora-PF4VCD3F>
References: <20260326162611.693539-1-gourry@gourry.net>
 <jm5rmcwiauy2fn6fvj6cjowiu2dudjndhhlcd2tm275ibmos5i@dwxwchbs24ko>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jm5rmcwiauy2fn6fvj6cjowiu2dudjndhhlcd2tm275ibmos5i@dwxwchbs24ko>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF5E0A001C
X-Stat-Signature: 1hkp8dkjf8o1hzsrs69wbm6j9a7gt8x1
X-HE-Tag: 1774550240-80447
X-HE-Meta: U2FsdGVkX1+QlyWs3m+y2fX5Dpsh5zCdr5lYWBW5AsXsuGOTaqBaQ7N+08H1m1a07pcb8g9qURxgCbNGPwdTbNVJw3lBblXJztYLGqyahjs3mArlBduHqVImRreTLQI2x99dBc7LqxGpGeWe35dSFY6eG0VyhI4kXGHpuVHOvUouPrNPUkEgqmr64dH34PXbRa1sx+14R1zVP6WgoFO3D7D5VAZF6A1dHdHv9iAZDF1PnoslTbGWAWXY2rWhOj0sFRT7Afk8wPCHh7betZ/JNSo896n0/+/rhQWej9fc6I8f60IPylHnH7YJdcl3z09GTMaI+ggWPBmjz19n6dS9W3afP6Vlx8bIIpvUX3Fvkz3SPklatN5aBCnfhoXE7M6Hkp7b1jgN/3W4CKAaYSS1kWdKAGAeh7rSzsOurYpaZClPYw7f4IqbBUIU8j9ZZO6u4VBEyZIk6uShCPGgQ51wThdvD5FnGLPt53etBhvkRypTkzvqSEPa28VOQg3hDJ/jva1L82wS//4V9G+Amxtq45w8PW1jF6VK/dZ5GeLVFCDqP2s2tjmLcppnmvYo+xY/XvHL5fcjNYLwt6tgDA+5b2nOVq2h2cad7nIG4UWXm7CcMiS249v/GgM+ro/aMKLCI4a/PEkmcSOrBm5ZVIi+hWeX8MSO5Tvk4DZVd5E8jeyguf03YuLciZYfIyV23QoBhkW62wnWjJuQw54M2dLZglE5Eeo0L7uJJI87wsv47AWvasOR6Sh9xquJQu5dDjqglCfbtVW07xkCB3cm/Oxhelytdm3LhXav789dys5mlLGPKEzaZYzGCETUSQDqgd73fMBrc9Eo+xVNZWd8eUa1cruX1LXMHVnTCYDMpzIy3HCBQIVFgAy1pfqo5ZXTn7Pe+hqtfbUetISLLUzJKeo+RRsUtT2ZcxJ3WKCz6/llh6gyXTFNQh/95TuarTuUhZzKEw2eitUUigccy6i02Xq
 x7FFqCsC
 VANGybr7VumyENw8+hPdlV/B88rpap/FZDuu4L0KOVjm2d+IbRZYcSBmMzUrfquPf0eCIeK6eOflna7twh3Ee4bM7E/bnsUuWIl5hnnIOXVrcHBDMhGYmLc31frFvnBB/FJzh6k38GiukMX9j9m5Oq5/+Gx4qTARz8SUOzEnFhvJEMFWWpDW7s65jmGuCjo/NbfDRcAlxIuYCJSxvrCyDm9nGLY8lrlmpwm3vJ/fNfJ3xX+WT49JTmaxoGbsIriYzA6clXBkUoIY3uJ1NI8tuE0ZtnHVokbdLdfIti6ylIppdf6P013Nz8emXxg0a96G1DlLMExRvEK+2nKQqrkJb0onVJlBRvuuAViTUvJSa3fkGGrxTD3DLYh1VY7bDq0U1WgcrCGMxzWxdF/bRNfRH0fdXYk2zmG7xepwLtklCeZziv/IaMk7cQaBMVyIBZfdGWiF8olCQHArcm+Bi5aW6030RK9Zflv4I49P42fAOmn6nmGBDj95wWd8/7but1kF6wJRZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 05:07:42PM +0000, Pedro Falcato wrote:
> > Two races allow PTEs to be re-installed for a folio that fallocate
> > is about to remove from page cache:
> 
> Hmm, I don't see how your patch fixes anything.
> 

after looking at your comments below i realized race 2 actually requires
the fork as well, which means they're both essentially variations of the
same race, so hopefully i can simplify the change log.

> >   fallocate              fault-around           fork
> >   --------               ------------           ----
> >   set i_private
> >   unmap_mapping_range()
> >   # zaps PTEs
> >                        filemap_map_pages()
> >                         # re-maps folio!
> >                                               dup_mmap()
> >                                               # child VMA
> >                                               # in tree
> >   shmem_undo_range()
> >     lock folio
> >     unmap_mapping_folio()
                  ^^^ i_mmap_lock_read held, iterates VMAs
> 	spin_lock(ptl);
                  ^^^ child VMA's PTL
> >     # child VMA:
> >     #   no PTE, skip
> 	spin_unlock(ptl);
                    ^^^ child VMA done, iterator moves on
		        it will not re-visit the child.

> >                                             copy_page_range()
>                                                spin_lock(dst_ptl);
                                                   ^ Child PTL
> 					       spin_lock(src_ptl);
                                                   ^ Parent PTL
> 						/* does not copy PTE. either
> 						 * we find a zapped PTE, or unmap_mapping_folio()
> 						 * finds two mappings instead of one. */

At this point, unmap_mapping_folio only processed the child VMA
(no PTE, skip). The parent PTE *has not* been zapped.

copy_page_range() acquires src_ptl (parent) and reads a present PTE,
and boom copies it to child.

When it reaches the parent VMA next, it zaps the parent PTE,
but the child PTE (just installed) survives.  

> > 
> > Fix both races with invalidate_lock.
> > 
> 
> I don't see what you're seeing? Note that both map_pages and fault()
> take the folio lock (map_pages does a trylock) to exclude against truncate
> as well.
> 

The folio lock serializes map_pages/fault against truncate - but the
race isn't between those two. It's between truncate's unmap walk and
fork's copy_page_range - and copy_page_range doesn't take folio lock.

The easiest way to deal with this is to prevent these fork-inserted PTEs
from existing rather than try to make copy_page_range aware of
truncation (it already holds the PTL when it finds the PTE, so you can't
take the folio lock unless you drop/reacquire the PTL).

~Gregory

