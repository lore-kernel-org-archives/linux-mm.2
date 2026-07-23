Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8394FC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 21:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFCA6B0088; Thu, 23 Jul 2026 17:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1006B008A; Thu, 23 Jul 2026 17:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA306B008C; Thu, 23 Jul 2026 17:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F409E6B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:27:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70885A01D4
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:27:31 +0000 (UTC)
X-FDA: 85021327902.20.2CE05B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id DF0BC40003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:27:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ay2F9Grl;
	spf=pass (imf27.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784842049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUfWlxIB863kcySC1ByZPwzpGUvhrXH4mfz+j0Cwkso=;
	b=QhdlBXbUXih1zcsDGI8ZOho2q9nYkeaJ48U0L0T561hGQDOioEQ6Q0vzpV01Tc59xL9E7c
	31tBnLsDss5e2PC/+v6bt9i3QPz2OXvY/WHO7z9dcXgqa+P7JAwv2d9h02G3pvTwh9+Le8
	AdBkh4uk4oPpKCZH7cNeUfUUC1SdebE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ay2F9Grl;
	spf=pass (imf27.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784842049;
	b=ZYy1h6LAn+fiqg9slH4A7xc0MVEr8MXR/F6S4IUIdy0vnmrXRxL/7XKyswCj9BE1pfjylW
	vozaXgU+AoRnpODRAd6MBsOfRw3VvUCGhD6165LNbG/1jnltfR2tXXo6P3MbCqrSKs6iRT
	2VqP+9zRHvElM4JtmVStj+gP90tiAZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E46B600AD;
	Thu, 23 Jul 2026 21:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007D81F000E9;
	Thu, 23 Jul 2026 21:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784842049;
	bh=AUfWlxIB863kcySC1ByZPwzpGUvhrXH4mfz+j0Cwkso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ay2F9Grle9jiAXSao0E8ftufzBgOuPw8cg9e8lbBkO8ZBND6rbnOhAAX5l3rxCzGC
	 nYGG6CUjZiQYh53aIKBeemLraVF3FjL7nLenA6LE+mMG8L9NX6sWIGFrvHimjfE6yK
	 gnQ2jd9vD5mpOyWrMZDGAH4ZnqESrGdn+l5hkbAFmwZ2TM3Aa0I2Y0ks/vVYbaGbCl
	 A7wEmMFEnjhCjo6PP6roVGsf0nfS10QW7L9dP9Xdei5T9AWZqfSJMm+jGikpDFdPHH
	 NXOGldMWZJv77IR/7hCGfcN7Y97nSqXojDl99vPKmQhAKH38jAf6aVSw1zxFavSLM4
	 GprCvkcgiItWQ==
Date: Thu, 23 Jul 2026 14:27:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Mark Brown <broonie@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org
Subject: Re: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-ID: <20260723212724.GA999236@ax162>
References: <20260722225605.GA1910198@ax162>
 <amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
X-Rspamd-Queue-Id: DF0BC40003
X-Rspam-User: 
X-Stat-Signature: emctpzuccqeyahq1nprh8dm18a9mfasy
X-Rspamd-Server: rspam04
X-HE-Tag: 1784842049-947227
X-HE-Meta: U2FsdGVkX19itsIw/Epat19yYHIiW59UpoLdbmT6nA3dElw0My8PqPJ/t5cOIoxYY9Ob55th/zwWBKLxOshv2IMTX16iHZ962tVaZ8S8YnTqkrfomkJ67IJkZg36yu8jeHuETvoJmD+uP8d35d9O3STZesEpkJb6onTijED2WultTXjHkzI4ZUqB8js+LROMrQiob3NsRxXNIdNgEx6oxBk1dWh5NlqmiepdI2Qt2h58Ifj8j9XhwvUFC43c5I8djU6E9AP5uPM5YDWqYul6kw/DW96WZcivgVSlXPZnnhng+5kzXAFp7oWA1wgz+Bkevncu3wjCtRP0PFOeGZTB1x1KDMAVj0Vqzrf1AjSL9O6VeiiA1uFRzjlgwtrREIRcBrG5wVa9aybkzI56UJ0cltx7Al3AJWOxV9xweW2X2b3CPM/D6+nSDnPzb4WV66/OiZ5oltmLzBJ53SCjc4j/GIIWbkvK0hUp7o0M5wWmJz9Sbp0PkYCBMDe6fDOIVYoy/grnHn+lNxLVUWwkPaKhKxxb9F+CmlOBIsU59Vb5n2z8WK2ZTkNvXlaL+czy7XfcKZd9OZO35CB2/jWQ9G4WZtFYaedjgTQM9lWzOXTl45tKOY/69Vi77JDZkdCvB9nPkPbt/jQKYh6TcziWwVPb32WAH9RqrLdbosehs5UilhgJsP5saVI+v+IZz8HHAnVymUux6quqyJgyOQ4i0ZaXuexX6rbLGt1O+qy/0Plb0gH/Id3poHPK7kngxJzoG09UkWYq62tVY67c+L8J01Ic6z6YwFCCZn0jIDh6xVaJpNBoIbROf+pMWt6UHIzRgK3XvoWnZDNsu2JYvrdMb7hfnmp6e97LT+Yi0KkeYCkaMYAX82Vwd3ClqijY4VsIhu7mBYrMhtDy0bu8QCKI63GfTTawZ3m87VtAEO0jr5OO1OKAUwx3wiwGothcPy1hXJqk1zCVLXtLVkc0DM8quw9
 Z4BOrvkR
 pX+aofU0DpQhCQzO2Hto6Q31Om3PtIaNKqwj58af/bBgJxzaQND7erzQ1X9PrKM6dIOZ+X30Myf/ZjvR+bLe9xcd7vxTH9hSqCkigBIRnZBlb3gU36q2iFejE2UxY16k5bOu+Md5oP0fTHp60cW2OOdMcJFoJRrYwAo/fPUwde9Ab7kXaXO2IeS2Ylm10jsVYJ9JByMq4v47lcaXfZ0iGuw9B6P5UtR2yCDpH7+FUwMlanHeZeH7ddSFeE2l5r0K/MwrU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 04:15:49PM -0700, Matthew Brost wrote:
> On Wed, Jul 22, 2026 at 03:56:05PM -0700, Nathan Chancellor wrote:
> > Hi Mark and drm and mm folks,
> > 
> 
> Typically to get drm_pagemap.c to compile on various configs this is
> what is needed:
> 
> 109 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
> 110 #define HPAGE_PMD_SHIFT PMD_SHIFT
> 111 #define HPAGE_PUD_SHIFT PUD_SHIFT
> 112 #else
> 113 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
> 114 #define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
> 115 #endif
> 
> So the drm_pagemap.c code could be:
> 
> -#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> +#if IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES)
> #define DRM_PAGEMAP_PMD_ORDER        HPAGE_PMD_ORDER
> #else
> #define DRM_PAGEMAP_PMD_ORDER        (-1)

Ah yeah, I probably should have looked at the bigger picture there.

> This Kconfig has been around since 2024:
> git format-patch -1 b979db1611a63
> 
> Would it be better for everyone for me to change this in the DRM branches?

I believe that would render this conflict moot and seems like the
correct thing to do anyways but you could wait for input from the mm
folks.

> > There is a semantic conflict between commit 04b177544a04 ("drm/pagemap:
> > Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION") in the
> > drm-misc-fixes tree and commit 0b6b1bb28482 ("mm: rename
> > ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES"), resulting in a
> > lone instance of CONFIG_ARCH_ENABLE_THP_MIGRATION with no way to define
> > it.
> > 
> >   $ git grep ARCH_ENABLE_THP_MIGRATION
> >   Next/merge.log:Merging drm-misc-fixes/for-linux-next-fixes (04b177544a040 drm/pagemap: Guard HPAGE_PMD_ORDER use with CONFIG_ARCH_ENABLE_THP_MIGRATION)
> >   drivers/gpu/drm/drm_pagemap.c:#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> > 
> > This results in an objtool warning (or error with CONFIG_OBJTOOL_WERROR)
> > when building with clang because NR_PAGES(order) results in 1U << -1,
> > which causes clang to stop generating code for
> > drm_pagemap_migrate_to_devmem() when encountering unconditional
> > undefined behavior.
> > 
> >   drivers/gpu/drm/drm_gpusvm_helper.o: error: objtool: drm_pagemap_migrate_to_devmem() falls through to next function drm_pagemap_zdd_alloc()
> > 
> > Mark, could please apply the following diff to the -mm merge to avoid
> > this? Obviously, there will need to be further coordination for
> > resolving this upstream when the time comes but it is only an issue in
> > -next currently.
> > 
> > diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
> > index 4a794544b7dc..f00c27edbfb9 100644
> > --- a/drivers/gpu/drm/drm_pagemap.c
> > +++ b/drivers/gpu/drm/drm_pagemap.c
> > @@ -12,7 +12,7 @@
> >  #include <drm/drm_pagemap_util.h>
> >  #include <drm/drm_print.h>
> >  
> > -#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> > +#if IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES)
> >  #define DRM_PAGEMAP_PMD_ORDER	HPAGE_PMD_ORDER
> >  #else
> >  #define DRM_PAGEMAP_PMD_ORDER	(-1)
> > -- 
> > Cheers,
> > Nathan

-- 
Cheers,
Nathan

