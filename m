Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A094EF8D75B
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBEB56B0005; Thu, 16 Apr 2026 11:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F3E6B0089; Thu, 16 Apr 2026 11:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85366B008A; Thu, 16 Apr 2026 11:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 949876B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:43:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33CE1C2D7A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:43:28 +0000 (UTC)
X-FDA: 84664838496.03.2F78319
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 672E2100002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:43:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UnQoNmDq;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776354206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd3e2VDKFmhHyj8dlw1B5vVyPvKeqv4J9fz3f7RtiCM=;
	b=mtKMFrxyALcjMI8TG+wja5ROr+UDqalKbxCGMy+nSGzzHLl4zcd14w76sjFMJtN3eX/s+V
	5WSZ23IZ8nVJ6G2g7MzR2pNgAd2CZ5q1mtvKWbUNaa0AXJpaaXCdlnq7Q9hvNJFOM+R4yW
	DVHLL+ynmeHUUbdTFiU4yD72aZPs3UU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UnQoNmDq;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776354206; a=rsa-sha256;
	cv=none;
	b=f4NMCGZVTj3djqLv7uxU/P1YDMTOXJNxNunT/4IK9/Wb16cPBy7qQhGwHspXMa9CY95uuZ
	3Oqo1M/uk1woyiIbU3W2byf0z4eStohoWxbh8//xVJJhvjZT/DQbYp6sPSjPpKFqTnpZyG
	n3Q1znGqL9ZgAwWHrsIQKVJe34l/3e0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5914C60127;
	Thu, 16 Apr 2026 15:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91706C2BCAF;
	Thu, 16 Apr 2026 15:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776354205;
	bh=aCG8gGEPXzuo1QRGojUmghGuuLoszJoxEs8ppN1nF9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UnQoNmDqmM4OQ9xZI2iIfRMM2LZ+f8ZvP6JyKMv2rzL4SRId993hJU4/RZb9HMW8K
	 KLdoOhFv/hOkgKx0VIX5Z+hxsV0R9pzX5xT+epyBp5ar0AMl8GjKGiOQeE4oHZH5TQ
	 unnuTtu9QTpoIyd6fNAt4/rdStMlWIz2+Liv8RNO/mWqCIL3YqdFhkBaWoZdMoDCmS
	 fIKoMAcdpF5Yzdqf3syStgdqw8ze+El9pQEj0qrsg9FwZhVg1mOdtiPhdrC1V6///W
	 js28o+vPMnyIm2T1xIMsYIxgUdcHLXJebfj8DatOwmqTpSLp5ojbr6zaLIRMHieRac
	 Lx9TSKJTSSHqg==
Date: Thu, 16 Apr 2026 18:43:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 0/2] kho: add support for deferred struct page init
Message-ID: <aeEDlY6ZpzeqmAtJ@kernel.org>
References: <20260416110654.247398-1-mclapinski@google.com>
 <aeD5kboEdzwuR4P_@kernel.org>
 <CAAi7L5dFaxwoU5dho8sJJ41+SSwgrmXW_NjQZnn7UPzj0zoowg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5dFaxwoU5dho8sJJ41+SSwgrmXW_NjQZnn7UPzj0zoowg@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 672E2100002
X-Stat-Signature: xw1r5mut1m7jjotxrtf34yus6jh3htwa
X-Rspam-User: 
X-HE-Tag: 1776354206-152933
X-HE-Meta: U2FsdGVkX1+h//OuFvXpAji6BeDUUXi49dUl8QapM4NMPUlj8ZknPp3ykFvjZnw5YXxI/DJdjbQDYJ8qusFZqDlh38NLWp/CD3I3Cz79FzsYlMXIFavVfcHxiuoQXo/ZZYqPp3k8VKgSME+5BJo2JGuqmtQZ190WFDL9h2cVur1p9wzEu+HcqeSeRq9cud8CvBOukNgTdeVUFmnjPFW0auhT3zT4apzBtLw7pPuMmsMRX4ilKp7Hgq9YiNMS8Nt7Vv5OeOhwDQ1L0ZZ8eLHGwiWKAJRgmSXCx6VNeLA5LeWzE8nvimbL7UqWKDeDZYY2L6UJzHNGqewuy/fhwcUzC9EU55kTlWBxpu3UXmWQl8ru1hY8B7RSJRYQcprt8+Y6kIC9UHif9WYJdHppiZdYRYflPa8jTM1eDuXhr47pPG7qtSDZsFr3qNs6m+Lp4AQIv2KVxJa5P+kR4ZKm0df5/pF2TPP+9HzOy/qh3RAgmBWZWBZfQEE94sReWYoAFZlg8AC3O5thRYGzE1B9pPvYuV6vKiMQytY8n2Y1vn9Uyg90mAqW+ucvskysrE6k083NtFM9lXLZNR+qR82YjRCOq+DjN9P9sC3OTk+uqE+34xc5Jzj9qztqiWz7iIJmLw0Qs98Gq7QmyGmgeYn5qDLvKkSohtxdRnI18dmcRerjA6FFVkqsG7rdN9sWOfOwnp7cVUlH8lK9AEv9z4xj75soscFBvm/xogj66WewHuHoKyChq41rnbvMo/Cn1NEkmTwfG31rF3hVN1PPlfr7/JOmbSxYz0kTIPVeBoNgheJrP+JK+Hww13HkOKABZlCCZ3S+7Fdl0JZvu07hp1NCwsJeuEz2GyEYAYWFArfW76zq0gsxcy0zW4/8ocqsP2rLAwAmKuawe0YsRSR+qzzgiZB5+WFrDoOfi4XidsXI6QVzvPITIE6Gguh9qEsc1g8Lg+H+p8zptLoA/Bm93nugrkh
 z4TkAKhb
 G0yqskDxk9Ki/GWiZgcnf1it+Cj5qvHlSnWNj65OLrpgheIpKiWVshbpiEev4L4tRabK0fzyZ8JbSfHMzaJ7zHeT6V34UXKbQZldZlhNvVvnYk4gudK/oqp2+KKS6YHa5aqRWFITlA3bgx66U55Nbfl0x4lIZ2erX1DC1j+L7y7bzefEEG9S2HZjyaCOQQ/79my+p9cy8o5v6S38lYFztEAwcgnVIRs8E2E7hIw4jE8Cf6dTA62o+R/xfsDSVRY98bt0L9cE3Ikt8+tpGBzwiPyGYYYEh2VUBv5Zkjyh1JN6f6nBtYHqWVJQwCfl4ybsRKNRtEOKgMqJG0pFrtCamC4ID1Qfe1ElCBfgk5HrrMWTaYNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 05:23:32PM +0200, Michał Cłapiński wrote:
> On Thu, Apr 16, 2026 at 5:00 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Thu, Apr 16, 2026 at 01:06:52PM +0200, Michal Clapinski wrote:
> > > When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> > > initialization is deferred to parallel kthreads that run later in
> > > the boot process.
> > >
> > > Currently, KHO is incompatible with DEFERRED.
> > > This series fixes that incompatibility.
> > > ---
> > > v8:
> > > - moved overriding the migratetype from init_pageblock_migratetype
> > >   to callsites
> > > v7:
> > > - reimplemented the initialization of kho scratch again
> > > v6:
> > > - reimplemented the initialization of kho scratch
> > > v5:
> > > - rebased
> > > v4:
> > > - added a new commit to fix deferred init of kho scratch
> > > - switched to ulong when refering to pfn
> > > v3:
> > > - changed commit msg
> > > - don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
> > > v2:
> > > - updated a comment
> > >
> > > I took Evangelos's test code:
> > > https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
> > > and then modified it to this monster test that does 2 allocations:
> > > at core_initcall (early) and at module_init (late). Then kexec, then
> > > 2 more allocations at these points, then restore the original 2, then
> > > kexec, then restore the other 2. Basically I test preservation of early
> > > and late allocation both on cold and on warm boot.
> > > Tested it both with and without DEFERRED.
> >
> > Any chance you can clean that monster and send it as patch 3?
> 
> I fear that would delay this series somewhere into v15, which I would
> like to avoid. Can I clean it up and send it separately?

I don't mind. For this series can we add a build with deferred pages to
selftests/kho/vmtest.sh? Shouldn't be as controversial :)
 
> > There's no real difference between core_initcall() and module_init() with
> > respect to that deferred page initialization, they both run after the
> > memory map is fully initialized.
> 
> One of them runs before kho_init() and the other after. So it allowed
> me to expose the bug that I introduced in v4.
 
Ah, nice.

> > > This patch probably doesn't apply onto anything currently.
> > > It's based on mm-new with
> > > "memblock: move reserve_bootmem_range() to memblock.c and make it static"
> > > cherrypicked from rppt/memblock.
> >
> > You can base on for-next in the memblock tree:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
> 
> I tried that but that branch is missing other commits from mm-new. So
> I would have to modify my code, which would then conflict with mm-new.

Let's continue with mm-new and a cherrypicked memblock patch, it all should
be sorted out after -rc1 I hope.
 
> > > Evangelos Petrongonas (1):
> > >   kho: make preserved pages compatible with deferred struct page init
> > >
> > > Michal Clapinski (1):
> > >   kho: fix deferred initialization of scratch areas
> > >
> > >  include/linux/memblock.h           |  7 ++--
> > >  kernel/liveupdate/Kconfig          |  2 --
> > >  kernel/liveupdate/kexec_handover.c | 52 +++++++++++++++---------------
> > >  mm/memblock.c                      | 41 +++++++++++------------
> > >  mm/mm_init.c                       | 27 +++++++++++-----
> > >  5 files changed, 69 insertions(+), 60 deletions(-)
> > >
> > > --
> > > 2.54.0.rc1.555.g9c883467ad-goog
> > >
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.

