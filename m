Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FD7C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729FB6B00DC; Wed, 12 Aug 2026 09:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAD06B0277; Wed, 12 Aug 2026 09:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA4F6B0278; Wed, 12 Aug 2026 09:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38C076B00DC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:32:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFAB9403E9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:32:26 +0000 (UTC)
X-FDA: 85092706692.14.6D0ED73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0F0AC14000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:32:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+fVn7I2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4IWlDkd+77n3V2z4PXcxdrv9KIM4SUUHLTK6y+6PZs=;
	b=OQGOqRbuVC6pb5gBLsPN4JaMqQZRhr2j6QQYQ3tLMqiCV8NmtcPl9twob8dmSFb/yKTuIo
	oKevXx+npl6lbmzWPkZQfPF3KH3UK7m1G2mFuGN1RXNWG31wAl9RUOqa48QfoYhhNF/mqe
	vLtVf24gYNDURL29ykwJWEb4yr9pJro=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+fVn7I2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541545;
	b=A53T8QpjT1/E9OqmcK2+zBvRAvYdwKHVz1Jv5be+U+y/1IIvSRZICUMZmVfem9zS1t2x1P
	u6JIcgN5yxZtB6Jm5yAZ/vk5KaDi8sb8eLINeEvKzexWZs6o5+IHz+v84DqYnYIMRoCd/W
	yIMqQWsPRQcQPbK9XpPx+QfXhH/TAVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38CFD4074D;
	Wed, 12 Aug 2026 13:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FEC1F000E9;
	Wed, 12 Aug 2026 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786541544;
	bh=t4IWlDkd+77n3V2z4PXcxdrv9KIM4SUUHLTK6y+6PZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O+fVn7I2aaHjOzHULCyhdWUyayJ+FUZbi+ggmMtF/iqbnxhrkG2XMe6O9Hf51BgtG
	 wQZJ/3mUUb9AZ7YNr0eBvAWfArvP1xh3/SHtcHontQsjajOpvFhSrPilhNPLGFUKsX
	 MJGZ5NS1bA6GPF7iVkiFItUgkgF2+qch+zrIubKsDIOIRkbvNPv+nXbn++7G4z9/bI
	 96Pk9ET8aMlcd2GvploYKDJkaM3XBq/1WNt13AXTyJQGCi1cDFOXTATLQBzRepfTUt
	 ZSvhnbxRiUOE4gqwrVmrtZw0Og/9uNcf2oZ8sDJAyywF+TRc9YLwCzjmgG9TZcpCka
	 FRyjCGm6cpGGg==
Date: Wed, 12 Aug 2026 16:32:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, linmiaohe@huawei.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	nao.horiguchi@gmail.com, liam@infradead.org, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, gourry@gourry.net,
	tony.luck@intel.com, bp@alien8.de, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, liaohua4@huawei.com,
	lilinjie8@huawei.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <anx13IlH6PMxhaSL@kernel.org>
References: <20260812091644.224299-1-xieyuanbin1@huawei.com>
 <anxOypktGGq_9PZw@kernel.org>
 <anxQuhNh8rTUYqpN@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anxQuhNh8rTUYqpN@lucifer>
X-Rspamd-Queue-Id: 0F0AC14000B
X-Stat-Signature: upezwrzphem79cefq3q3m98ng8zktryi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786541544-879876
X-HE-Meta: U2FsdGVkX1+fMm+3aimqZN5a8rLy5c5PpO3+7kAifLFeqhIT6h74A/fX6OkVSoWAiS7zSmlroHEUYCFw8wb61BLaVSW/Buryi6G7WLFj7PGE7qpiNvcJxr5PM+i5+2JsJC8QPXl0CQCeOK2GGaehNxJPJKfoQMm90Hdk0Dp10WUo8eJqcDORn4CSRsZh8zbrdbpX9vkJa3oLPxsxdqc6bhE55kmsnT1naTjwdnvIXhSxETlv516/Pu0YTgUJLAzi4KN7RjydFBnVNvxvHEhxFCnf4y0pu47fNXAlgdKUs5h1kg067KKtyeDhBGFG87vwGMZQIztU6N2CM/nAXHrHVNmbCU8QUO8SJjGsLqzJM7Rh70rBNgMlQrSXbTbP6aN8vB0eetfsnNU9ZUmOn0iV3tJYlhdnkb8XK4R8lqmdci5139E14Gpv7jfpl8TuudejrM06aFLO39F/ciymm4JBZBjGiKUgcg8c9eDmN0X+ocMxdal7RlqGCpBNesoAomKPIIc9JqwdAAYNtbjfMuY1S7eJ1BlJbEJYgb4scm5ZlB7lgIo13XA/SALxWCNtOOONxwNqURZsLnsqMUfly04XsIwrs0ZXstq1+8VvW4gLBNUXAr8ZOOpDgdDbE6//n7kawATbgi4/AyPOmrHNFCbk6Wnz4pHRW0bgElyUciedqSPI4wq9/lDBxVrQq5w0xdzeDePIID6RmWKhYsKdWuNSHsECDCn/KTZMpXwkd1ajQpZ/GI/MB6gpE4t9OxL7CmLUKpqr2Z6a/fFogPqmI57kVB5AXVyibcPEJVu+NCCR2vsua5y++8TLh3nX4/APLHSLdRATArXilIu9KG8g14w65KAE/fsH1nz9jPvZXPR6SM6gQkXjhJ8HEL+3CCkwkZCoeiJs1/nwBQ6jMxJkTT3n0+X8KxGOvgN7DmXZn7V7QGlymv1HkaCnkfswoGE3gRzXlBv0fUlJCbxgAv5w0uj
 Ev1aeSvf
 RDI40oudu0r+Vflbb3Upa9pRaM5T19nWU3cxVZBoo/K7CqjPhq/s59MnL3RhluMf1O1d0vrKn7dGCBHezxt2ZZCIo30AsP+ff83LyUHziQ7UMIWhlFi32Y1HVZfspfFYOCypwkOK5OKMUqefCCXs40kvISiA9AnsYCA18m5Fh5Et0e5tZtpkJL55BTj1qpzhww1iueL9YJlg16bIJTOeaQWsD+l/eULN5JJcYQNc4tVBDpnxKdsf4Xsaxn53UVQPWfKglqWKJpPt3LK/n6wY0b5SGzmZVJAptGnjs4f1kqQN5n++OODS12qC5XpEWFtoSLbj+yffodDID/jQKA9rOehXLV3st+sRh4i6XATLCVnBovcE+jCraaqWEPMNM76KJzSi6ynm4v/1Ts2WmoKA9qAhTbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 11:55:03AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 12, 2026 at 01:45:30PM +0300, Mike Rapoport wrote:
> > Hi,
> >
> > On Wed, Aug 12, 2026 at 05:16:44PM +0800, Xie Yuanbin wrote:
> > > Currently, memory-failure can be enabled without migration. However,
> > > migration cannot be selected by user when memory-failure is enabled.
> > >
> > > Migration is very useful for soft_offline_page(), which may be triggered
> > > by correctable memory errors. Most of the anonymous or file-mapping
> > > faulty pages can be migrated to other healthy pages.
> > >
> > > Allow user to select MIGRATION if MEMORY_FAILURE is enabled.
> > > Also, select MIGRATION by default if MEMORY_FAILURE is enabled.
> >
> > Do we want to make users decide if they need MIGRATION when MEMORY_FAILURE
> > is enabled?
> >
> > Just make MEMORY_FAILURE select MIGRATION.
> 
> NO.
> 
> Explain first why the hell one of the other options that selection migration
> can't be enabled.

Think small systems ;-P
 
> Changing configs just to support a weirdo no to compaction but yes to doing soft
> offline for debugging or whatever isn't really convincing unless a real world,
> sensible use case can be stated.
> 
> The kernel isn't there to allow you to have broken configs.
> 
> >
> > > Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> > > ---
> > >  mm/Kconfig | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/Kconfig b/mm/Kconfig
> > > index 8a24c130d008..b4c217383b51 100644
> > > --- a/mm/Kconfig
> > > +++ b/mm/Kconfig
> > > @@ -682,7 +682,8 @@ config NUMA_MIGRATION
> > >  	  demotion for memory tiering.
> > >
> > >  config MIGRATION
> > > -	bool
> > > +	bool "Enable page migration" if MEMORY_FAILURE
> > > +	default y if MEMORY_FAILURE
> > >  	depends on MMU
> > >
> > >  config DEVICE_MIGRATION
> > > --
> > > 2.55.0
> > >
> >
> > --
> > Sincerely yours,
> > Mike.
> 
> --
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

