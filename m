Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C2D1073CBF
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221306B0005; Wed,  8 Apr 2026 10:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D21E6B0089; Wed,  8 Apr 2026 10:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A256B0092; Wed,  8 Apr 2026 10:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C34D66B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:06:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C35A13853A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:06:58 +0000 (UTC)
X-FDA: 84635564916.15.190B0FE
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 969CB14001F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:06:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UyqjWcO8;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775657216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNYg7x7Syglbc8DiB7vhJcupdEbs7o3a4KhHFIj6l3s=;
	b=CJoaiICWYXWuDApAbrGDLxzXirK8n8DA7VtbKYU8A1JfkFPkwnfthonpSuVdT1g+danVtP
	S4XOkdxnM2UvvRQwkKwrGKnzlITNJxOWXc1HjojeFC46XCJBcfur3O47FqgW25pDVX03rF
	w+MC5uYD3VN5rJUvONpI7A3vTxtca4w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UyqjWcO8;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775657216; a=rsa-sha256;
	cv=none;
	b=oQF1wZUehP7TVm/rZWa1S3MFBVXCd4lsdV9KLY2JKWEvidsUNPhI2S7zXnexSPl+pCXbNC
	qZFLw41BrKSbrr9QNsPjPnw7K3Dz9SB2twv3RhAAF5yJI7zkqii8cc3n12IGBscmm/8+kE
	VC0cnJVZyaafS6l/xRuvoSYxaFkKnOE=
Date: Wed, 8 Apr 2026 22:06:35 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775657213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dNYg7x7Syglbc8DiB7vhJcupdEbs7o3a4KhHFIj6l3s=;
	b=UyqjWcO8sD0zcp1FHl6Q93dzyFcGLnyxufBJJvMs3khFmRZ5BHJvfFv05eQ4wb6jSg+url
	zJjs2GoPEt04oMCcvqi2fv75qeBKlrq+ckw2mCM09bxT2k4LNIHRSAF67Z1hG4A7ajFVy+
	+FNCLXqiqK+FGuPtQ1B7Hgmn+xpfr8g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
Message-ID: <y5oqhhbecurzrj755sujnqyny6ohmyd4uhslrrigdgpq6shf52@nr5gp7bpit3g>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <abE6uqdzMUv8k0mU@fedora>
 <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
 <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7e4ea66-49cc-4996-a638-25f6cb08a42d@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 969CB14001F
X-Stat-Signature: oqc8wcofonzuhayeh8krt8srjhepden7
X-Rspamd-Server: rspam06
X-HE-Tag: 1775657215-520239
X-HE-Meta: U2FsdGVkX1+V0UZJFuUvOw3FW5cMS3iP9l3thU7akxcI3rqeRH07jRFD2X4xprgUEJXfL7yFS5xlMF5IzECSScI8Lb13SXyHfi2zYj2VG82wlVgxdq/2Iy1ngDLv0nTMzKAMM13Uv05a46IyWRFllMy8jrRM9z8Dva1pqSKnrWXe2WXMZkxk1SWsbgAI6GF+SMtUsAArt1MT0JXzCxU6iM+a4zWAkKUsfRogDfi/UI30dF38ukzxgLpFJsDV4pPmYzXpaihtbl/iyic4Xj4YyXW5xnh1wycZ5lBeaD3nREEP4pF+KPISADe7P8xfqlSnuNQSziT+0alOyabjQDLqqCTQCj6dufoonLlsy9MN4AVLQJ8K6wH5S8RId9GH/ccRYDVbga4ivnBpln2FD+F8BuLNO1Y44FE1trYVKAEtzniFZoJmIE2lvOL7uzc1waIVyvspRPFaLKxoebjOoPfPBNzRv7lalZjvlvLBhu4B0gCqox9m615MCj0F9BeED1EzWQ4VQ7jkG0FgUfzFoDK4zBr3gFcs95w3jtqP0QD1oMn/GB0w2LFFRloaVAJxnkeSLjM6Xj/xvvk9CuuXaby5tL1HmRTfra6zG5nSX7yYbXOJQCU7qxtUPoWaWQD8L8VsPyzO+3Kj+Zq3/NZTZkHS8TNjLXcETOy/bcyqId/WsOOys6zNl5KVeOE4GTxJUSYD3g3kKu4UllnFbqlZVLv+losuLAKsHqRlf82B1jc8ywnFdDxkstNT3mc+x+5Wac+fGLhb2hqBE3fDawmR5cFwqNFoKUdhSjH2y1MKc3vsG3ZVjpQ/lSBKcdsUsShQOqbP2nm7xBF+qHW6lRDX2x5NF/KJh+ycxcW8o4ZWhFkPq+F5mN4LyMDE8xcvOd5CeJuxXiVniE84i08x9y2bFKXcLA7Mf+W1+AiCymmkXWmdLawY9Mx8Gom2n0aiOQBWwbhzY3QIOkEdtbIgMEazjwE
 nDqo9MWX
 N7covFnu42CY43yzL/kQrf/kFiFRFkNlO28qWbpu6YwN2eh8cklKzKrx+ybFxChqLyJ5bnhqOYBkdnkLVZaVWUEAtYWkjn2qGQKvls3gPCRCSc/fM+vNSOdzeHRAXlL/B80naBcpdDY+Zb2H1La8355sOm6LbHaSpSi8+RUqHP0K1P/pgY5EPp1/1POKGpiMWdQOAT24S2v9shumBCEq/e2lS0Di+DYYIKeAaD7gXaLHT3f2D34tdpz1fnHfaJ5IgA/xsNfLoW2EMHw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 02:04:54PM +0100, Jon Hunter wrote:
> Hi Vlastimil,
> 
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
> 
> I have also observed a performance regresssion for Linux v7.0-rc for some
> graphics related tests we run. I bisected to ...
> 
> # first bad commit: [e47c897a29491ade20b27612fdd3107c39a07357] slab: add
> sheaves to most caches

Hi, Jon

Thanks for the reporting.
This first bad commit is surprising. In theory, this commit seems couldn't hurt
performance.
Could you possibly manually switch commits to verify this bad commit again,
without using git bisect?

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
> 
> If there are any more patches available I will be happy to test.
> 
> Thanks!
> Jon
> 
> -- 
> nvpublic

-- 
Thanks,
Hao

