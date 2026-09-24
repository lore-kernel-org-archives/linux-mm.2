Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82001C9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 02:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B26A6B0088; Wed, 23 Sep 2026 22:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563B76B008C; Wed, 23 Sep 2026 22:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478B76B0095; Wed, 23 Sep 2026 22:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8386B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:39:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16C9316018D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:39:50 +0000 (UTC)
X-FDA: 85247100540.17.4767D5D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4457E100002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:39:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W9dvdB6P;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790217588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAL3zinmg72nAILl47EIjpKFCkkRuTmOSr/ESWJ7J9U=;
	b=vDTDv7B4g/sTfi98wSkyHt77XcxYDAsbMbreR1LGl3hlGNqge4HYeqWuauu8tOlMozVzcL
	6EahRWGbdbPQd9rR5khX1n0M4GPC4eFYZAoImUv/g3LkRvwPN5VvTMYLeSrm/RUvAQywf5
	2Y+DpZ1akIQas8qGVz5sfUHRqLp8HiY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W9dvdB6P;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790217588;
	b=8aak4b8K+3KTaN8PV+90NVly4FLr5nBtlDxZOLfodjqz8xjaJKFMSlb4e5vFB+B9ua+ONG
	Ce1x9c+YgYTxdBxxemdowKmpvHwg9QdWOJKj6twmejNLIIb77I7YOPD0+fwnKLz/ptbB57
	zev79OG6qVxctkJOwy6aBxtgxydFgs8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEBC2152B;
	Wed, 23 Sep 2026 19:39:43 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A45A03F632;
	Wed, 23 Sep 2026 19:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790217587; bh=3UySuy0edx/w4nroYpQEQ/Z+8cXRxme0G3UIaaNXRho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9dvdB6PABoqEIc2TG5SXEtkYgDlLcfCsAH2A8xTJ28MzEOSL4kQT4Tb/RV9o82mx
	 aNNlThhvY2jILwuUGc3V91j6OsfekK3GSDWmL8XPWS5k8Lq0sYDWsjq4m+wApM8zDa
	 NWD2ARF5LdcFQMCBAUWEEEdhzl8+cvE02LDRQwCU=
Date: Thu, 24 Sep 2026 08:09:43 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Mark Rtland <mark.rtland@arm.com>, 
	linx-arm-kernel@lists.infradead.org, linx-kernel@vger.kernel.org, kasan-dev@googlegrops.com
Subject: Re: [PATCH V2 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Message-ID: <tqe22ttrsw7wy5m7wk3u6gv4e2kdj5jrqnvoay5omugin52lbt@2pybz3ov237b>
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
 <20260922061638.3967467-2-anshuman.khandual@arm.com>
 <212067fe-1b16-4b87-87a7-4ce50847eb24@arm.com>
 <m72rpspdg5cv7xptent4tglgd25zehx462nfmcx5uyjwi2ag7p@bc6hvhosgtfb>
 <bce043cc-0f69-4297-8f31-92dcfbc0061d@arm.com>
 <7dn5t2m2fzuwxj2anuycz245hnctqc5mgaj5vdx7ybfql7arwv@6ac363txw3ff>
 <e852a2db-c15a-4e9f-b92e-ffd5740498cc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e852a2db-c15a-4e9f-b92e-ffd5740498cc@arm.com>
X-Stat-Signature: 6m3a7fm3bauoyohuns3tzzdxwd7brup8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4457E100002
X-HE-Tag: 1790217588-550066
X-HE-Meta: U2FsdGVkX19Ys9KWYcdYL2odiMjDaFyhMmcPkmwib9w8XuswI3pNqeGclKM/0ZV8rFa9WKfelRnqxYCDHixhnL84I1pwqTcslXePVidOF5A9K7p/ZtlmwCH2I9mpEqwpNnJfmDA4d4j7Lrva/lytaksxrZgyoT6gE+iOLUS5T2GHopLeBWvKFEj3GFOXmAAx4tr9I33zS1do3cfw4ou2ftBjd/WiycF9WLjlrNkwQ5gN7NIUIaCZAp9ka5cPF4BsMAybr9MW12qlGeEOsv9jOQvJ0RltDrW8wnT824KD8Ks3761baM7Is+hp1QneXMJSfwqcIF8tGn8TwNGTS5hka/JbqueQ2UHhmxv3Gh3QqRbJPTc/fO1Sd7hmUpKN3ykty6VatxwGlmujt4OxNCBTkJQtFuwJmrn/pzNDhhLHOVc/n3mmED8ia4xmEqmkom123elXoCs7LC+u54PAG1XYTQ0TTuOQgJaP5+/G5fKNZVftp6NFCfx/1OWqkWBy3ZHBVDXG0Qbf3GmVXOSyHF1duV3khpR9wZv0CbUuLVPMP3AQ4GYtqudxicvdTiCAxpa5VXtrx7MZ0QMjN7/pDTIs+0HEIK6X/Y3+UER/ApXZ9RwP+IwX1vXsAmV9YrHnStdyYVbEbEjxUczm3L0dqpwuDtv4hnmT04cquOFye5+kgowoRSAnFYdslo9DfXZtaIq5PCPIQxBkuGxKmEy+MVYqAfJ5bEEOGwTe1ylPNeHREFgeyFjpPyQfc+MWUbETTLBI5dgKCx4A3PHpDDejv1PC52WkmrZ6TKCiQnfelMCVO0q1L9krkBUyrcmS8j9hLFM0kO+tewquTEEbFNLKEevIgm1ZfsaEFYEJXnneNSypI91n3WyEi7E9YC+aDFjKc+h7ST+7cLdFoGyv3v4ugSV7lWLngxiEGYkF9QkeGCI2isOsMpUI4YCT56xTEBgbU9LPESE/YWnyCu9d2UUXbFJ
 ADaEyl58
 TiUjsqTp+OPOWKd7HUXXjfUFJzus8J57qkev5lUqX+Zu8yn5u9rJYqqYh9TbJlg3dzuRZnzoegZq1Memch1cO+YB8Vn8SSuslOPHs8fo/3qKJ/rrCTCFx0Q6OqY1D1zbwRHFbxFPVTADpf6dDpPXjp2uYT1GuQ66B23lguUJyeONWWSnavt0oJ8wred7VHWaZs8hysH0r9byM+0wOQZ0g8gXrVYtIlY0VHQ0jFgn5ROFlChiMnZNfutfE3Dhbmgq22Mh2doNccWA6somMJRFfkUTDWLefzBywso/7Oli8yvXzMzvPvMomDfxUOgpiBTsjGhFi+w9XAYxrIqcoomW3qHQj4MifHaoEV5d5QjuM6IlyCvNwk8VjCFk6uxt4uNUpX1cI5J4azGczg+7Pa1A+zWQgvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 01:50:34PM +0100, Ryan Roberts wrote:
> On 23/09/2026 13:22, Anshuman Khandual wrote:
> > On Wed, Sep 23, 2026 at 12:31:42PM +0100, Ryan Roberts wrote:
> >> On 23/09/2026 12:01, Anshuman Khandual wrote:
> >>> On Wed, Sep 23, 2026 at 09:32:17AM +0100, Ryan Roberts wrote:
> >>>> On 22/09/2026 07:16, Anshuman Khandual wrote:
> >>>>> Replace READ_ONCE() with pmdp_get() for PMD accesses in preparation for
> >>>>> supporting both D64 and D128 translation table formats.
> >>>>>
> >>>>> READ_ONCE() cannot currently be used for 128-bit page table entries on
> >>>>> arm64 because it does not provide the required 128-bit single-copy
> >>>>> atomicity, causing builds to fail for accesses wider than 64 bits.
> >>>>>
> >>>>> Although LDP/STP provide the required atomicity when FEAT_LSE is
> >>>>> available (as required by FEAT_D128), extending READ_ONCE() to support
> >>>>> 128-bit accesses is undesirable. READ_ONCE() is a general-purpose API,
> >>>>> so doing so could encourage other 128-bit users that would either fail
> >>>>> to build in configurations without D128 support or, if D128 becomes a
> >>>>> runtime option, silently permit tearing on systems without the required
> >>>>> hardware support.
> >>>>>
> >>>>> Instead, standardize PMD accesses on the existing page-table helpers.
> >>>>> These can be overridden on arm64 to provide 128-bit single-copy
> >>>>> atomicity when required. No functional change intended.
> >>>>
> >>>> I notice you have an unconverted READ_ONCE(*pmdp) in
> >>>> pmdp_test_and_clear_young(). Is that intentional?
> >>>
> >>> Converting the above READ_ONCE() instances as pmdp_get() cuases a build
> >>> failure as pmpd_get() which is defined in generic pgtable header is not
> >>> visible inside platform specific pgtable header, even with a forward
> >>> declaration.
> 
> I was wondering why the forward declaration doesn't work, but looks like some c
> files include asm/pgtable.h directly, which explains it. Let's assume there are
> good reasons and unpicking it so that only linux/pgtable.h includes
> asm/pgtable.h is not practical.

Agreed.

> 
> >>>
> >>> In D128 V2 series these conversions were performed later in the series,
> >>> when platform specific pxdp_get() overrides were added via ptval_get(). 
> >>>
> >>> But to avoid this, we could just move pmdp_test_and_clear_young() inside
> >>> arch/arm64/mm/mmu.c file instead. Folding in the following change builds.
> >>
> >> I'm not sure if/how this might affect performance? Probably not significant
> >> since they are for higher levels, so not called as frequently as pte helpers.
> > 
> > Right, should not have much performance impact.
> > 
> >>
> >> Another option would be to implement arm64-specific pxdp_get() helpers in
> >> asm/pgtable.h to override the generic versions?
> > 
> > For now those will still be based on READ_ONCE() just like the default ones.
> > Although trying to drop similar redundancies from other platforms :)
> > 
> > https://lore.kernel.org/linux-mm/20260923043226.331880-1-anshuman.khandual@arm.com/
> > 
> > But given D128 is going to define pxdp_get() anyway it might make sense to
> > define them now and withdraw the above series :) Seems like s390 platform
> > also has similar situation.
> 
> Given the desired end state is that arm64 defines it's own pxdp_get() helpers, I
> think the best approach is just to define them now (as READ_ONCE()).

Sure, will do that.

> 
> Thanks,
> Ryan
> 
> 

