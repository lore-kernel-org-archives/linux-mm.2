Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92D7CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD726B0005; Tue,  9 Jun 2026 10:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAD06B0088; Tue,  9 Jun 2026 10:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1F26B0098; Tue,  9 Jun 2026 10:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F167C6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:14:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9D138FBDE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:14:52 +0000 (UTC)
X-FDA: 84860570424.11.D1D74E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18E4120007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:14:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TvN2nY/l";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJ4VVCk8b3uVlpBKEcearz96XlwdmJj00YBRDzReuoI=;
	b=FTa1yHnOzDel/G4c3Uvb6psjDI7sMr4HjHn7C0m10lDszZBR7Khpz7XZry65ikMQvR13GA
	QwAIvrr4ax2c5qUeUVXsXNtwWx78NQp7SQuSc7zrMS+Al40T+ElGs6tvof2OB+7qAoaen5
	/Mx0lhZCTRcZuMC1kDCBrsig6Sz5Rt8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TvN2nY/l";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014491;
	b=EtDH54wcjcDZ89ea34HzzVvkHjTlRDrlbEUNnEJW0Z5fucLvjYU/xC5cgCoVzUZLtMJRpV
	qsLJVA9hb9jbvuJfTXw2RquczkzZckv0IoOdrjC5+xMO/7hPYFlWZvX6MsJYHi3x7HJQHA
	6EUzfR7+syAooznimAN1jwN5FhdR8+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B65B400BA;
	Tue,  9 Jun 2026 14:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EF11F00893;
	Tue,  9 Jun 2026 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014490;
	bh=mJ4VVCk8b3uVlpBKEcearz96XlwdmJj00YBRDzReuoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TvN2nY/ls2OFvcWdWp3WS+jzCQIy55YVd10EicT/K15ZWj69VXwsbypjG9msithuY
	 bi7iADq5nTY7FZASSHGqHh7zr0V7zq5jb0U4+FsOQo0bi7HSPqi0aqC+jQm0wh/B2y
	 n6jc7rOELuwhOQWL+Q/DMhtyJOd/A03BdwMDqyhQ87PlxrSRksCG2sw5IaFyFPMm09
	 U6rMLQNoAJKucdYU/B1GNCQPiwYJtA/pUVY2uOB/e4ONZyR4PyFMNCudapSh3d3CBY
	 MFp+AuFW2hAPWBEpUSNlnQLpVevD6AVaQ2+oHHjMb+focdiQ/ZWMaG3PX8LPiA6i+D
	 E6wL8W4+0oj1g==
Date: Tue, 9 Jun 2026 15:14:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: npache@redhat.com, david@kernel.org, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, usamaarif642@gmail.com, yuzhao@google.com, 
	aarcange@redhat.com, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, wang.yaxin@zte.com.cn
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
Message-ID: <aigfvl-pfW2nWawb@lucifer>
References: <CAA1CXcAsx3cU6HNea1MgLocGReoGoFQaq3NBFd-NUeOW8nJjmQ@mail.gmail.com>
 <20260609214947060zpq8Z6jdYop1TceXXcLoQ@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609214947060zpq8Z6jdYop1TceXXcLoQ@zte.com.cn>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18E4120007
X-Stat-Signature: ziqdk6nryug1ot787rmyonfkqf543g3q
X-Rspam-User: 
X-HE-Tag: 1781014490-569970
X-HE-Meta: U2FsdGVkX19NrKK4rmPv2hgVODy6MEOpPansRQUNPNrFMiDlrh7tStt/3Fhi+g4hqT6r7aRwCCQ1x1uO0nJlCS2NHMU6ThVN7KOv5vvrvXioHLLzlVjzl5kaPTAvacQ8U32dGt2p4vAPXxzZXHUy8TIkr7bZ1RRrlPZutrHAr0iZ5kWvuxzJQ2dekO1hWZduG2/cpDqbint0fo4HWoDhwA7u2GWAboy3R/TSeKgpmNR+G63SP8gmn/wgTPwqF8QZ9fj/RzOZLgc9ggqKI2XyONpXrbX9ljM3zqKc2i3VN4ed/avevGaqqAUnERIS3DdGv8E7EcHghfz8ZGObb7KHDZ+xP8wHFkgJQRsr+M5SdDeQoTr65T05+5Vc3meNqwkq8FTIsGvBtZRDrDoIRpjxdDvj62CUGd/8hFMoN0DKO0t2/QxUbmNc4kCRIgod0UUJeVS+2UBF/4y4lVWkNPSd80NpSJ2tOxzI3dGTRMmK/G3ZBWIpqu6p7KWRqrGK6b9mLRhTRaSZB3pidtedQW71U+TOEvzdYf01STKVu7AKNldz9o7fgcxN+WdEHWSB4IH/iI52V40B4Sy4lp8E4bccsYxh3Yq2oztegFnDhx8zSwOPhGM+2rq8wbPxAKED+nSFnh7B/q+PAjS0SHhJtjtuqE0nIb+rO0idyrVx/gKsqTbPqwVLseLVrBCNk1Ct+MDavgE752N4Vs4YkVlNqBomP0YRf0chuX/ipNfvrX1zr9VBnheF90jYPgOQgHUF5eepvzIHW1m5LNcA4PCxlxRtrMDgNuIl4Q42ACIFvmpaoU0dPGnAPUvdhh8KLDOqFMc5v1/JMRneCifsHNrZBLzwe0IAVaDPQkJOOXP4067HigWFKRI/+jf7qh+EKyBtXtyIikb5bEvfbuNlu4JLGRa83uRigHc/l867dMhyK0ru5jhIl8GcZNC90Bj9ev5GTbjQsBbdJ42IojLeqGYqGE+
 W+qbTGNe
 MCGPxkPYTfPMS363yYBaZqX92a+4GaTa9pmQl/Qhynl6/ooUWC1Jb0Tp/xxKGotK6kfTs8SEYqfe4urhvoA40ORvQIEo3KRsZ35Y9UsZJ+GLJJduuKMhXjX/ZMLGMBg6uwAgzLwXPzteXBYaaeumzRik0ja79DSIpFp1fKmkxBzNwn2rNpM2vQJRgmOfrWTMIHGtndC/FjOT5CQGvkQWSt1pj7sJZ0HzXDBUKyqk621YEohl6n01Z6IUwL+dODiRskd1mYaRO3OFqomvqiFcsGTEWtXrrjM/sT3txCtplOn6ritjUJV6yvclm/tSx+Qln02+z44aVM6LjQqKD7IAmXwOZs2xN/piKphvSdq5frjMYohsxl6OkuD6uIKhXdmSf3oJa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 09:49:47PM +0800, xu.xin16@zte.com.cn wrote:
> > > >AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
> > > >a huge page (which may contain many zero pages). If KSM is enabled and part of
> > > >that huge page is mergeable, it can easily be split by KSM, rendering THP's
> > > >efforts futile.
> > > >
> > > >Therefore, in our actual production environment, we typically avoid making the
> > > >same region both KSM mergeable and THP always.
> > >
> > > Right, some setups may choose to avoid using KSM and THP always on the
> > > same region. But that is not something the kernel can assume :)
> > >
> > > David noted in the RFC that QEMU may use both MADV_HUGEPAGE and
> > > MADV_MERGEABLE, while KSM can be enabled later system-wide.
> > >
> > > And I think Nico means something different from KSM spliting THPs in
> > > general.
> > >
> > > KSM has been able to split THP before. the new part from b1f202060afe is
> > > that a KSM-triggered split can also remap zero-filled subpages to the
> > > shared zeropage, outside KSM's own use_zero_pages/pages_to_scan controls.
> > >
> > > Maybe the changelog could spell that out :)
> >
> > Yeah maybe I didnt properly explain that :p
> >
> > After some thought I still think the alternative approach i mentioned
> > in the RFC may be better.
> >
> > ie) prevent the zero-page merging that results from KSM splitting a
> > folio. The check we add here is more general and will skip this
> > zero-page merging with all MERGEABLE mappings, not just those causing
> > the issue (the KSM splitting). The result is that even migrations, etc
> > that are also MERGEABLE will be skipped needlessly.
> >
> > If we use this approach we also don't need the first patch of the series.
>
> Yeah, That's also what I want to suggest.

I guess I'll hold off on review until the new version is posted then.

This feels like something we should have worked out in the RFC though?

Thanks, Lorenzo

