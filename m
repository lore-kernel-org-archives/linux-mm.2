Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2BD10F9943
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19AA6B008A; Wed,  8 Apr 2026 10:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1956B0098; Wed,  8 Apr 2026 10:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C077F6B0099; Wed,  8 Apr 2026 10:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADADC6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:31:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7940D13796B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:31:21 +0000 (UTC)
X-FDA: 84635626362.03.2FF7CB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C11B21C0006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:31:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XjWKjNin;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775658679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC0XtrYswKseJTlBpZ+hQi3bMWdfGfUCa1N4CUd/TbI=;
	b=v3v1p1anptskUywoTx27zwchyXQC6t21fyN8YUOUIjP81HQHBOAv/MT4tG4kPWy5NlBsgS
	2mUHlRO2Kn9yhZ9BOFmVDvsh3Zn8+pr0XkPcpqdoG7qGJOyq/UkOPYDBVG7nFIbn1FC4oi
	EZqZ9sKCuiwNFkUQB6xM01KCSRtfleU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XjWKjNin;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775658679; a=rsa-sha256;
	cv=none;
	b=Ien22YWoh5hHoOnYQJ9EiXdKjibYA+fRjBVaj9UCWpo5PeXmcoQKaPISghEbwSDzjEnBq9
	nR6CdKR4y0zTC/fYrotG/zc5UvvtuxmLBqkFk41i93j9yPUh9gqRSVibu1YgKTMAkVM5cU
	8rhKKht9kPaDvIqd0bvevxYnHx728XI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFA7C42B18;
	Wed,  8 Apr 2026 14:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE9C19421;
	Wed,  8 Apr 2026 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775658678;
	bh=rp82Q+HbL0irHGo0AxK6OBmxsXzUT57NdgiG+MbUIxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XjWKjNinK6NPSf8ibRKFX5mh4vW3bLqveebZfgse5j0hRMlZys3BBhEdi5sPKHb+r
	 8l0c5xMGBxbv/v/QBqPLDGh6BQ5DLedpD3iBrNwsCypK/HJGGEU0VmoEjJ+c42Hiyl
	 jXykW59a5WIkIEa+6NF0Y6KPHuM3CE0mTKPXj+XM3ykjQYbS6KknDtcqLYL4p6sQXZ
	 /KBqv4pFfjnyB+rU3fqAt5w6XV7DC5mDWODYZE4RR5ttznVxyI2aSinjKwKmyWDk6C
	 9qPKmZk28iMey2lW95rMdai9hbdtCKeaMm09R5LzMs617FXP9X4zIy41rb6dh2ztPH
	 2q3ND2KXB8TLw==
Date: Wed, 8 Apr 2026 23:31:16 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
Message-ID: <adZmtJ0rPgj7OQrc@hyeyoo>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <abE6uqdzMUv8k0mU@fedora>
 <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
 <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: x9cb5ibnnwqrd6pwgcsobgxmadpk451p
X-Rspamd-Queue-Id: C11B21C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1775658679-162249
X-HE-Meta: U2FsdGVkX1+0oaUV215SkbHEN1/BnlfUduTRMnyLmBeBiwVPQ7j8twtcc+aXwES/JBGj+Vd8q+7ARsHSsluLAQsoslisKzXUlUVMkiLg4zdFCcljlUew3uGQeqb4pP5Pld7qQHROY2Yr1mGkhTt8zTZaLqYTH3HC/0BXWshxPB6iwd4y00bId/FE0tTA43mfPgx9vyZ+iM+bPEfNzIcCuPY/lR2fuovPY/14AKnsy1cjVFe6PN86YmLOXJgfBuUPZ8Dks856xwJj17llHksYemD49wAvIJcs8wPJK3YPSslpLqsvueVOwn2cnNP2tGPNrDaz071bIphkF0HvUOe35hGW422SxQyxwXGXC0oYoeo4+w1IArSg6VCiZAo9UKlf8FsMZosX4qX8w8gIamm6+w0jpRfqiQtM2dygnDIuEx6aiT2XL4E7ZQSb4jK0qIvTfH+l91qTrN41Fth+Vh3FjHTT3YBYnA/F86BUgVhxwp1BUXFSR5b/c++PqbgIrPTfNqOHgmXYOsV8CQy29RQ2eY0yozAlLXWrB9MdWcSuhw9Rkgem2Lg4X/DmV2eVrW4/Fgxkuww6FRvGs8LfVefNdjqrNxY6rR24IWy/bXzy300xEPw7/HRibkSwM5doJufRucAF1iwW4Q+TxDDIctFclgph8A9B/GT8nOZfdUUUp0L7og1FVReEU9i73MPAxIpfubW6NPbSQevUW1MFuXa6fbzMdLftETEK5Y0GJI3zW9Oz/J88EPBTyL3T7Qxdg7cbJuU6aCP1/2Wc+XJHGD7mGeYIbdHeOKaadyo4yNs2uarY6N4qVaclXF4OuGXn9/d1Z44EKFuuKjLiSBmg5lWr9M85J2aCa4ZodyQG8Bj4CAejM+HVFGKF8k+i6O55dU0KdO6BRX6GUniR60iXqwnMEhV20ZoCzQ/OJy/8Bdi8Wq8nd0YhlFe0JZeakwIHik3AsFReRPtGYUonl8xJbzC
 lmlBKlQu
 phzTJbhRC1zkcgA8Xr3r0dY9yln/oUdm5YTVoV1ZxQW9JaaDO8Yln6+YllUTiX+rNI9AJnj7Nhz2shqfmN82Xe18pvioinTJe0BEcnSHBiSbgKZoQOJvQ0+EZRAINqD9an6AhbFiKArXMtn+lE78KKF6Bj6rlCYLuXrNBJRZeoWnhCurqQWgScMcDiwrNREZlN/gW8H2ojqEjXaDQ0tcwJAMkv0CWWcA2J23dYSyGGLej9hZVkjK3qxQ4IOH8AA376FSY37yY5d/9tOY509WAiVLO7evaW65x6t/B6Vtv9Ug7JawCm9BXStSrCNFUBXK3o67z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 02:04:54PM +0100, Jon Hunter wrote:
> Hi Vlastimil,

Hi Jon,

> On 11/03/2026 17:22, Vlastimil Babka (SUSE) wrote:
> > On 3/11/26 10:49, Ming Lei wrote:
> > > On Wed, Mar 11, 2026 at 09:25:54AM +0100, Vlastimil Babka (SUSE) wrote:
> > > > This is the draft patch from [1] turned into a proper series with
> > > > incremental changes. It's based on v7.0-rc3. It's too intrusive for a
> > > > 7.0 hotfix, so we'll only be able to fix/reduce the regression in 7.1. I
> > > > hope it's acceptable given it's a non-standard configuration, 7.0 is not
> > > > a LTS, and it's a perf regression, not functionality.
> > > > 
> > > > Ming can you please retest this on top of v7.0-rc3, which already has
> > > > fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not
> > > > allowed"). Separate data point for v7.0-rc3 could be also useful.
> > > > 
> > > > [1] https://lore.kernel.org/all/c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org/
> > > > 
> > > > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > > > ---
> > > > Vlastimil Babka (SUSE) (3):
> > > >        slab: decouple pointer to barn from kmem_cache_node
> > > >        slab: create barns for online memoryless nodes
> > > >        slab: free remote objects to sheaves on memoryless nodes
> > > 
> > > Hi Vlastimil and Guys,
> > > 
> > > I re-run the test case used in https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
> > > 
> > > - v6.19-rc5: 34M
> > > 
> > > - 815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next: 13M
> > > 
> > > - v7.0-rc3: 13M
> > 
> > Thanks, that's in line with your previous testing of "mm/slab: allow sheaf
> > refill if blocking is not allowed" making no difference here. At least we
> > just learned it helps other benchmarks :)
> > 
> > > - v7.0-rc3 + the three patches: 24M
> > 
> > OK. So now it might be really the total per-cpu caching capacity difference.
> 
> I have also observed a performance regresssion for Linux v7.0-rc for some
> graphics related tests we run. I bisected to ...
> 
> # first bad commit: [e47c897a29491ade20b27612fdd3107c39a07357] slab: add
> sheaves to most caches
> 
> I came across Ming's report and hence, found this series. I have also tested
> the 3 patches in this series and it did appear to help with one test, but
> overall I am still seeing a ~25% performance regression (the tests are
> taking about 25% longer to run). I am not the owner or author of these
> specific tests and I have not dived into see exactly what is taking longer,
> but I just know they are taking longer to run.
> 
> Anyway, I have not seen any recent updates on this, and so I am not sure if
> there are any other updates or what the current status of this is?

As far as I remember we didn't get to fully recovering the performance
yet. Interestingly even when most of allocations go through the fastpath
it didn't fully recover [1].

[1] https://lore.kernel.org/all/abI9DKxuwl_4Gasj@hyeyoo

I was suspecting it's probably because of:
  - false sharing on something (sheaves, obj metadata, etc.), or
  - suboptimal NUMA placement, or
  - something outside slab involved

But I don't have enough data to back up any of these theories yet.

> If there are any more patches available I will be happy to test.

Thanks!

Before diving deeper, could you please share the NUMA topology from
`numactl -H` on your machine?

It's probably a NUMA machine? (and hopefully not memoryless ones!)

-- 
Cheers,
Harry / Hyeonggon

