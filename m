Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63215C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 23:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1189F6B007B; Thu, 23 Jul 2026 19:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9FC6B0088; Thu, 23 Jul 2026 19:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F243C6B008A; Thu, 23 Jul 2026 19:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C17246B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:09:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34241120202
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:09:46 +0000 (UTC)
X-FDA: 85021585572.26.0655A26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 03BB140008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:09:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VAfxbPLn;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784848184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSN/SqdoXxpvwrgxo5RrG0Q0/V1H/881uQTbRe6xvH4=;
	b=h1grKkWwAxnUJhTm4Ht7BbZO6bm8CsQiryyXRqHkg2nVcYCIut1MLZDkearWls8WprQHbh
	fgAOtP+EnKCTfjPXdrqFgBGkh+RvX2PkSV6DzxBYDUGSyRD/khePM9piMnqE2qR5pjsdHv
	ncQSQS4SeqeWEkJiWYgZduCuCG5nQUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784848184;
	b=ZtmLtIDiAy09AvDQeViOR1vbmR2uG26MK2BvdcP7+L1d5595aB5KLLpV83u+ZKRWnMfgMr
	0TE4Mvv4WC4roy5ufovTOqorSwXC8L4YWVPPvmT9aOiUfoErSwqLh8VjkX7KhvUI7N1Z2P
	PduOQ36sEi6duGEi2UOIsOAE0ydzGIU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VAfxbPLn;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 393A3600AD;
	Thu, 23 Jul 2026 23:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1F71F000E9;
	Thu, 23 Jul 2026 23:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784848182;
	bh=tSN/SqdoXxpvwrgxo5RrG0Q0/V1H/881uQTbRe6xvH4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VAfxbPLnI8mckxMSf/u+ozV3DQM6crMakIuBMasclDZbuPk2ITUn00ztbvn6zYyEe
	 4cXrtXZqlVW62quaQKeDmFUiZXg2qQ8g/qPVFA6k2mrzfcUDy71ZL7hFHbkGFfX3Em
	 5+gTAQG42pFiy3o5kl/1NFLhtZjgQ2IIOQWwVH/s=
Date: Thu, 23 Jul 2026 16:09:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>, Mark Brown
 <broonie@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 linux-next@vger.kernel.org
Subject: Re: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-Id: <20260723160942.b58b065d771401aba117bc77@linux-foundation.org>
In-Reply-To: <20260723212724.GA999236@ax162>
References: <20260722225605.GA1910198@ax162>
	<amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
	<20260723212724.GA999236@ax162>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03BB140008
X-Stat-Signature: 6i4wbuw1ry8ergdhb6bhf68jmi4z5ady
X-HE-Tag: 1784848183-485958
X-HE-Meta: U2FsdGVkX1/VpXjpfj0Nvp4eKpRupy97xJEjTQCpOxS+ZBUEkrXGguh/Jnma73iJqyIlRHS6celBRpHwH48a8aMAJRIE1/v94sXX3/p9+EVNeyvhs6zIQewvvV5vt6WbQImzLQEIXSi0VER/aLDUZLq9oPtxHJlD5veSLIhyFwSMLREZBfELdmjPq2iwQSV0WKhc0ecKNx69iaUDFCqjga99XFx4rJMD/Q+PAaDba8Grb/LNyxF5CGIhp0wLSK6NI74bdxGnAw4zlp0ar5oJsDPdq8pMmiw0PL/1rkyzTr+IH5/rZ3/SOxRxKMJOoN9iYVO/30tfWBiMuT1P7SjnP6LeP+KM24omp/6wusfsWFvfFwX1scoOoYXinEEzPXGKRy5MYHpqQVzUBsYQl96dy/hYxRwzgAOI5lmOU9ObaQz17dZ5gr7mtl36guVfBkxW0oTGuPCaUo5KwuU6LPIw1BRwK/KTiskZz3gIexYSBhp1l2FsoLNd9GeWybcckTxHR6TqkehsNS8TWL9ii5n+2v9hWdum2vciOpKlcWRfG6xB51la7tigN4wYbRq236SgleLljCQShKvzfl2gacA5zUvLIclMGn22irGISKQzy6uKQ4wojLLV2MOorTqy+tSThX8zdjTDUsLllX9yell5qanJYMEl+ecowcACDJ+g03OgpBx/pifYo+nvutSlVldqOyIMthrs616jFlv2oYT9NF9NZatCSTWlfA4Tio+iiwi13Gho/hTMqLW+sE2jbUx7UYzpu9NX0vM/LjFSYe96a6eK+0cOSCr6ttQaKcR8GvL+1+41ehpZ8p01j8fUQSMDG6S7UtZs3To0eei5i4BBwSboM/HhjczEtrdNsRRdD0pLunuprEK7SoeX2BtwHXaYrq/PASq+7rtdXTF0pwN+0+uTb5npKTpF9P8PHZTzG/lHfk9lYnwVbJq4zvjj2F8rtmrxk10UIfspnbNSTsG
 7V4oaFKT
 8h17LlYxwG4zJrmoF4gqNv2ZZAzhGOg/cJ7SrZS7hnR4jUan1VQGcb4Gn7WgTEm4czIZ4urIkLKlmLmXVNJzRbaCDch1jRyK0vz9YmiK7BmFt0NgE2wQyKPZHxtsduXBHk7ZrnFNXGJAhpBI0LHhd4a+V05NYCTOrAHt+eG/mEURAcGF6LIcwTD4ZrLN/XM3GtJ2V4syFT7YuPSHfX8DEe110rnb9NoUa1woUgd4UmgwnqjXLHFUpdMVHqE/pozeRKYnBHsppXvHwMRVUom/3x02M0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 14:27:24 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> > So the drm_pagemap.c code could be:
> > 
> > -#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> > +#if IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES)
> > #define DRM_PAGEMAP_PMD_ORDER        HPAGE_PMD_ORDER
> > #else
> > #define DRM_PAGEMAP_PMD_ORDER        (-1)
> 
> Ah yeah, I probably should have looked at the bigger picture there.
> 
> > This Kconfig has been around since 2024:
> > git format-patch -1 b979db1611a63
> > 
> > Would it be better for everyone for me to change this in the DRM branches?
> 
> I believe that would render this conflict moot and seems like the
> correct thing to do anyways but you could wait for input from the mm
> folks.

I'm fine the drm people changing things ;)

Otherwise I can disable "mm: rename ARCH_ENABLE_THP_MIGRATION to
ARCH_HAS_PMD_SOFTLEAVES" for now and fix&reintroduce it into mm.git
after drm-misc has merge into Linus.  Or something like that.


