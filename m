Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 556EEC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 11:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2DD6B007B; Wed, 22 Jul 2026 07:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CF46B0088; Wed, 22 Jul 2026 07:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE076B008A; Wed, 22 Jul 2026 07:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A220E6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:31:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 335FE80145
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:04 +0000 (UTC)
X-FDA: 85016196048.08.4057F08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9CA2D40003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WZE6F3/0";
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784719862;
	b=8ShuKHHZsRY97FuRKqylT1pVG0VZZywUqDFmL6seQPvV48N8QJwVk0pYeDJmwvWqdtquJf
	axzbiEm8Xl7NiwJ21fGUxj8bFudrh4mpPCkEdgGZ2Kh4/11eo9FIsoUVykuOTfZRdor2Xq
	Qxts1ANCrd3XPp4MUrNPmoqqh6JGG5A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WZE6F3/0";
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784719862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+shRNGBj5Owp+uVGh3Xp8g/6GJInc0RvJCbh8LgO5Wo=;
	b=Kl9iY8bHqphNqWZY1urHh6oFeowKgly9RoHShopbHK7Obl4Dya4/ZiK9E0n2+LCZ54513e
	fyfX/IcmxGCuvV/WjtXZGCho2o26Yh4fwfXHl57du3QELfk0CuL+hcFD0W06gx4MvJJwxv
	KpWUpV7nsQeDJrnuqTYa5QseMs+9F7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D764F60A68;
	Wed, 22 Jul 2026 11:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EB21F000E9;
	Wed, 22 Jul 2026 11:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784719861;
	bh=+shRNGBj5Owp+uVGh3Xp8g/6GJInc0RvJCbh8LgO5Wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WZE6F3/01WTp/lAinJIxVK6/EsQhlrlX2KXOvzmSPlCZqP8jC5mFOR0S8xfvNvboG
	 bvasr1TP8hjB5AKJ2yqL620A8IOPAWztB0M6uRSv5QN6CUgciyncyHEhgwi5D87xGv
	 PV/LGb1KTBP6eWTCnPLpjbDOoM0A1PJyS8tRhaZDzNC2J6HSWvu9iY3kO94VT9XvX1
	 Zt6lJADr2o4/DNqbr7uW2s/Vk7eXpIeKf/PtMXaulg+1AHZMXQ6EIpYnrjX72DzBd/
	 UBzORVJqLtDpVMjV6m0bbfxLf9DHK8ynfE2gZUS9G4kWfPODKlapdihYaC6gzCx7+8
	 PZfGzSNPazBfQ==
Date: Wed, 22 Jul 2026 12:30:52 +0100
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
	david@kernel.org, liam@infradead.org, Dev Jain <dev.jain@arm.com>,
	catalin.marinas@arm.com, kernel-team@android.com, riel@surriel.com,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, apopple@nvidia.com,
	rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
	nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
	pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
	jpoimboe@kernel.org, linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v3 0/6] Fix incorrect access of hugetlb pte entries
Message-ID: <amCp7L1AxoeDH1Yg@willie-the-truck>
References: <20260703114202.365553-1-dev.jain@arm.com>
 <178464737122.1305746.12295190523058911270.b4-ty@kernel.org>
 <20260721133636.df1a012df895054d3fd34a2e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721133636.df1a012df895054d3fd34a2e@linux-foundation.org>
X-Stat-Signature: jtm7onq4b977eyx68qkfyxi9s8rnzjd5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9CA2D40003
X-Rspam-User: 
X-HE-Tag: 1784719862-315928
X-HE-Meta: U2FsdGVkX18luEwwW89aVK5EUIWDj48vkW7hrZz30wLA6BSAIfri9ZoVkC9L59P+3NOsUMWGxdrBhRtWatahwqonoMigczgczzE+fBR14dvYOPCFx4WbtKhMf1AJ4zj2tUdUWIO3fZVkLke2Ho4b4AMyDJe1hotSrP5c0BSDdRBH0LTxmFDcn3vEh+s+UZRHe8lwEDsycVpvaJGr0heaKMuPupibMkL3A13dJIKv3dLoEzE4rxo+ZJhTYSl7MY+Uvv+upAGEvkO5UoV3VIPskyu3679pKsWFxpKW/1WtWza4QsU8Iu4dVt/lCk1NQJ/W1XtmEU0WrA18QskqMBjsv/rEVkZfmfVd7YhP/orTiorz4ddbNF7WBIL5hOeQ4R1ZxnaP0kRbaxay/bMSAqVqO6x0BJbCb6NcMkUEBHzigK4UWUyABmfVnMuyDR2cZtGYBBvsxtm7I44CZ6Y0V+nMWsC8v0HvbM0xJ2feq2sVFintX2a1vTL9egH47cbteTW94YJr9gtwZa/n3u4qEUNthWqScaQ7Fu75QZ7RjMRzqgfSP00KtRXtjDlq+X5jcF2VDxRkSCNRS4LRKyyyh4PVfJ7KIemDwJ4968qOdkn+ghIK5mLIJuSlUNyud6ajBBbzICZVtpq/rtxRtBsiwDOIiPkQoGPMlCaOixALixqM1Kg8OL2+pfIVH5aWVTPQhHOkwC15/p4YDRPiBj8vvS6VIwafZNmOgCv15MHeDVamt7ysCUuf4YVmMMuA1k4FD6kGvxMN2ICSvO87YS0IqVECB8q6oqb/DK7zXq4QY9qqE84JugSu2fbXygYkSEHbxq3QQ/pNQHkmhGfRJ9vWJGPGUCtnb9FWJnsnHn0pISkpmsfgbmZhqysE0t/KMX9u5wXZ3CVATpcAf6YwI1BupIJUDAvNFnOC7ERb5F9r8RQkctQIT0XL85pDo8bQNwaZta8uYowilibZHzElBr/l1um
 Dwf+E1kg
 5zI6B/YeemFHN7vhtxjkBv3ftsNZ5Hl4S8aWqhT4o9i889Fu2oKX/9yXatCUfK6Bn/JlQhd+LqD0yOR57C0/r+krl4Eabf5Esx62HmzexpjCwBwH/nwSKn7ZqoUjG8mVy9fsWko+Geletz28GrXETE5WrXooxl8C41EbZpLFRgMSugNizPzkX4Fiyq3e5cQlKHBRfl8uQ/sY2F25Pg4284P+mxRU/+ADylqcFajBXS6EibxwnfZLOMtNfhTSyS1nfjNG8DlzlXsTT0Fm7nmcT0Y0560Wkz/JlUHsDx4ZPrfd+U8ZurfQMEJIqIywWhFWUgPf2nRoruaNms2Bt5OFCelfwnfCQPd1ShK8f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:36:36PM -0700, Andrew Morton wrote:
> On Tue, 21 Jul 2026 18:18:38 +0100 Will Deacon <will@kernel.org> wrote:
> 
> > On Fri, 03 Jul 2026 11:41:53 +0000, Dev Jain wrote:
> > > There are various places which use ptep_get() to get the pte entry
> > > corresponding to a hugetlb folio. Some arches (like s390) have special
> > > handling to compute the pteval, so they provide huge_ptep_get(). Use this
> > > helper consistently.
> > > 
> > > Additionally, some code paths may provide huge_ptep_get with an unaligned
> > > address. This is a problem on arm64 (I checked other arches and it looks
> > > fine for them), which is fixed in patch 1. The fix is made to be
> > > to huge_ptep_get() - that is wider churn and we can do that later.
> > > 
> > > [...]
> > 
> > Applied first patch to arm64 (for-next/fixes), thanks!
> > 
> > [1/6] arm64: make huge_ptep_get handled unaligned addresses
> >       https://git.kernel.org/arm64/c/9175a8c7cfe88
> > 
> > I'm hoping Andrew can drop this from the mm tree to avoid a duplicate,
> > but I didn't hear back yet and I'd like to land the fix.
> 
> I can redo Dev's series to omit [1/6].  The patches apply that way, but
> there might be build-time or runtime issues running the other patches
> without [1/6] present, haven't looked.
> 
> Also, review indicates that the changelog requires updating
> (https://lore.kernel.org/all/2b9d60a2-8698-46b0-80ae-b8747a66a85b@kernel.org/)
> and I believe that Dev plans to do that.

There's been no update for two weeks, so I wouldn't hold your breath!

> IOW, it would be better to carry this in mm.git with your ack.
> 
> Do you plan to upstream this in 7.2-rcX?  If so then I can hang onto
> this patch until it appears in mainline.  Or something.

Yes, I'd like to get this (just this first patch!) in for -rc5 so I
picked it into the arm64 fixes branch.

Will

