Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD1AFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F5D6B008C; Mon, 27 Apr 2026 12:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FE86B0092; Mon, 27 Apr 2026 12:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2ED26B0093; Mon, 27 Apr 2026 12:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B100E6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:51:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 255F91B7575
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:51:36 +0000 (UTC)
X-FDA: 84704926992.05.89C7200
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 577714000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:51:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RqwlM5at;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777308694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfFTirKkeDeEyvmUEtFTz5ez3T6vQa0JXWjCpoVbz8g=;
	b=P+h/NyjEGJ2OwfyQEp7GaPgtO6DwRThRLfeTGw8Bh0FHwBMbsROMMdvnh6ZhkujvIJ2CZt
	UXpV3fgbFNbNr588NhG63Uh/dMCmuyK4zrTqImbs0IF1Q1KiJvST8KW2jgye/3m8R4vV63
	TFLp91L4DBQMLq5jXXjpIBOW8Ve6PYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777308694; a=rsa-sha256;
	cv=none;
	b=gE95P/SLsZtzINDt74gf5rGeqrqgGsszwjuK2a/jwJRsFqXItlsqWln3yMZ3ScZlLFpArh
	MDpSX8c1K+5lzfs3XddxdWn+nt85QpPAdqAp9QDw/yojwgaLUHYNPsVKgYbTZUHAZ3p5fe
	ob4zvYOA6R3m3yZO3xgQZ1Z83e3RgzY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RqwlM5at;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19BCE60138;
	Mon, 27 Apr 2026 16:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B80C19425;
	Mon, 27 Apr 2026 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777308692;
	bh=wk5Lpv1tDjcTgkb38S1GdZbUP/B9Epp7J8Jqy+D91+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RqwlM5at3f2RHg6Brtta+vAerb0epgvShvlwsNfKx2w/K9k310FWyYID6PyO5huTZ
	 jVTBtNz9RS745lmvu+vor/NrpHcdaUWapQMLhLX1Ry5v3gQr00WGje1UP+RZoAL9TB
	 MhVeQdi2R3knacXshbo7EzbUcgdva/RS0/w/UVRNQQawAk98ZIXZEo1w3pVqayacXi
	 2d+mAqBZGMnWEyVOAeTx+ZTNDrHtkIcBhbJlL2WZXiIQK816LzR9QvrJ01rHPg2cUr
	 peeHKP95rRcF3vjikvz3jv3tr/O8T5R+fHKZcjowKBGaxohplsLwwWZ6E1kWy0OAep
	 tJB0TXyhqrmIw==
Date: Mon, 27 Apr 2026 18:51:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB
 pages
Message-ID: <ae-UCVba16jg3-gR@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-44-rppt@kernel.org>
 <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
 <ae3v1cyMLbcvJtYW@kernel.org>
 <67d7b067-97a8-4600-a9a6-46f3e797ffed@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67d7b067-97a8-4600-a9a6-46f3e797ffed@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 577714000C
X-Rspamd-Server: rspam04
X-Stat-Signature: psi3ritosqnwngxdu6sgpxqhg6ouzr6o
X-HE-Tag: 1777308694-266867
X-HE-Meta: U2FsdGVkX1/AnSo7pZmzMXzrLMVocWprO16IR6YEel2st7n6BRmnUztNpuFNfoN1uTJpNhoB/JWOwahlXjrx5OfK3soTVDc6e7fcnMedgdlWW8jA8C//gqlraynWe+xBMkXN70vv1ZPb3DIrR04/QHtTeBZSmtjogiPpnFNMpW6RlxuUm/TTpHGn1NAFcTZafOvuv7RMETcmvJo4PLjcKXeVDG7Two7i1gjLD7C0a8it/KFrzZQej0ozNDlX/DUvYr0iwDXA/AdILqpQQax8ap8y1JvM5upufV3TIiPeqTW/MqSlkDbZn4E/mskxrebVip+xl6HksGI0J1sKcqNXBrPjgDfr0w2Hi7pYSmpQp0I269QNXLqbrRHIk65hJaMUfy+HWWyB0Nx5jmhCmchNogGQR3biDrQEZepDgcrpglq0sDgv1mMvgYNnbHW+Fp2EgWpHbSqyUt3phRoVAmqTiXY7mJIkWC5yJeneqhF++KRjwnKuW0YwlZcawwHN6w07l+LRTZP3nW2z7GPguE20FHBJMQYtmpJwlK1bh9XJRbiCNRWkZEX4mgv2RBktIerV+Cuspu76mt6UmugDhQSGUpzYeQRmKTgZ2wvoYG6Xg/IWUkExxDLNnbXLhaXn4Jcf3UOcrjcPVsAtMbTm8j5hEAeRHqcScoYp+1YAju2VFeb71JbPobSX/3HI48noAe0dg0v/UYOHWyymN5argyNj4UKZaItieE/T3qDMhQpuj0RhJ98Esib/U95Q5tGUNeFnuqQGSMifb8QcRkms+9FYru0wBE002NEtXDwCzLG550yjxaAujT1ZsP+ZfbP/9tqF2nlCyP4/9bH/1qdTQ34KA1pfxdQbveH2krn7PZu38UaD0vcnRyJymjJ+Kfd001X1Zzn44gdj5E2d+imhzvq5qpIppHRgy/ZJnpyMYYPaPhDaodfHZVReUrIuSOkNyd6fqupkGxC/CmXjmnnEUbH
 duKGS6es
 L2Fe3YjWa2cyuFixpsdwyOHsjUsEXhMiUdJGEP/vzggyO880Z8SAcjlilLXIFmNumw/2VyFYPRWibe4HRbu9ogX13+g8XUntC6sNQrpaMYGZvpLqKlNlds5VubKzVlKhXs78ZkhwgZN+EOc4wyBmkW+Z0GFffoZgnc2U/wSnY/HTbCbJ0VaiOJjgqmwLylNAjV7Q+O1F7JwMA0EatQ9PIEhuxX5k/aycnOFRT0TnYU2Fh6ph35n/wQs8FQkmsuLltjzI8CvFYn0TsbNSHN7NLKgQH+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 08:56:27AM -0400, Luiz Capitulino wrote:
> On 2026-04-26 06:58, Mike Rapoport wrote:
> > > And there's another issue: when running the migration test individually,
> > > private_anon_htlb gets skipped. I guess it's because the previous test
> > > is restoring the HugeTLB state:
> > 
> > It could be.
> > 
> > I pushed the updated version that has the fixes for both zombie and
> > signal issues:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=mm-selftest/v3
> > 
> > Would be great if you can test it in your setup.
> 
> This works! Both issues are fixed: the migration test completes w/o
> hanging and when I run it individually all tests run.

Thanks for confirming!
 
> One last question: should we munmap() the mappings in this test? Though
> I understand this goes beyond your series goal.

We could, but the tests _exit() anyway as a part of kselftest_harness, so
it does not really matter.

-- 
Sincerely yours,
Mike.

