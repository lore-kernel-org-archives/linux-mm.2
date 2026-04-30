Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3B9CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764376B008A; Thu, 30 Apr 2026 13:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715496B008C; Thu, 30 Apr 2026 13:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603CA6B0092; Thu, 30 Apr 2026 13:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49B6F6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:08:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CB83120A10
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:06:56 +0000 (UTC)
X-FDA: 84715852032.04.49749F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 707604001C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:06:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/aLqins";
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777568814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjUFaS1qY1CEJctxUMvCMcTxX4DRqy0Z0sZeIlYR/u4=;
	b=AZjnqCgn+iuHugW/E33hGpzXtAG1SzCPdogYmNjrOaRTIb3LF1VWcVfthoM597K16dUMIj
	nRO8N+XPsM1ypDB/V5Kq9W2CmvD1VlLZfWn1UmthFGMy95niM7uQto2F3OeqHzzW2VGcJn
	7zD8hJkQrsfsPOj+LgGyUV98vUnVd8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777568814; a=rsa-sha256;
	cv=none;
	b=YTp+xtrCKNE9ggG12luQyywxrRDEKB+4phzcAITGZZAQ1Fjbjppz7EbUgEQ67WHb3ZjnMu
	6xee/XVrYz8yWRhlZbRNpLVAM/vstC2D78RxGuG8JB0v+BcNJNfUQgnH2b53XKM0KpMBZO
	J0ONbK4YM0Vb2CO/2vtnNAwyC4W8/60=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/aLqins";
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1828441579;
	Thu, 30 Apr 2026 17:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8DAC2BCB3;
	Thu, 30 Apr 2026 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777568813;
	bh=dPdHfPCW7ng2kSeVyDlMheharmDFRf8Ia5tgN1rIr7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E/aLqinsRaz6E+em9mmxb/ZmPZKQBFN0qzUWyMQ1WmwBpvNArlPyD2O/izyCgrhZt
	 eIXJpUB4ekDjPDZGqtXXWplC89vsNKrkO432KF7hiOdDOWgT0wQBFrIjP5dx7wxAhL
	 q+74f9XyxQvN8KdY0JZ3Fac04I5MqQ/RxFaIL/wPBDm8G/Ge3ilJTrCeacwiyGTX0t
	 KTrSXj2Mjq/KHwqqNkcbGDJTcEPN5qX1tqx64v2waZGOELXhsWRVRRMg0luurIZx/L
	 4CbIQD8kOgp35xgTgEmFcZyE5Bn2vIr6wPy+iQuaoCrMpta0JHLuKgmLuFkaOPOoYQ
	 dGcLQS5WymL1w==
Message-ID: <59b3dab5-3341-46dc-851a-419790eaf403@kernel.org>
Date: Thu, 30 Apr 2026 19:06:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Content-Language: en-US
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
 <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
 <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
 <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
 <291406b26b8badf2e565996515931d9ebe50208f.camel@linux.intel.com>
 <a1252167-63a1-481b-9f1d-2a7bae7a3b6c@kernel.org>
 <afLCwHaPZMu/dxqY@gsse-cloud1.jf.intel.com>
 <f4324084f3808b9a42b87ec27bef7fe920dde9ea.camel@linux.intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <f4324084f3808b9a42b87ec27bef7fe920dde9ea.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 707604001C
X-Stat-Signature: m45oj5cg9tgzb3u77mcoxipt4z7ygqnh
X-Rspam-User: 
X-HE-Tag: 1777568814-889681
X-HE-Meta: U2FsdGVkX19d0arGk6uWaOsXHtLZyk4NpPXSoH84+oHzlAASO6lhPzTvhmmPku0p15/ID4rwtIvQ++0dtAMg+8jq9rVZX1DQm/8RDjHah0UNHhU7x1W9KVdP0cRMX9JkmtMKFudSzBHQ6WdTEu7pPQjhnI8muG6tjfxq+xG6fTswMdpckRtXov6lHsIcjJc7aBHFya6HyJ9PxTiOpseT2kgAvFEc5x2Gq/dx/ftP6je5ga24X+bhvF+qUkxY/dHPCGfjTgbk55Ud9tqqx2JdtB6BPPeSgqhP74GqMLCdp8VQ4mdgjbXuR03LYVHHcjWl7yi9MvIeI58N1VxLEi5oz1rmS/Ti8u8O1s642mglzgWAuXvtrWBUaeJ2qbm9EWoJ1bpxYjgOVfO3JYyTk2Ef2vGvG3lRjMD98yrQeTS228tZ0wtFSiC6s7JUhZoH9aoh0amLpghnfOfQfgYheQYi8O7hyZHmECBV28luObOCCUFK1SpBOl+uwzSBHZ5LXG5/HtD07NbifOM96NlHhSSiowD6HzKQM2nN6mzrs/BFV6IJ9SerJdihNsGc3YeNgP75ikKnntp+f0xLhD9mbalq2fL8KIJY0+tZqRAxAdAprW7bUNwv1AyMoIZikxtganfa0tSLbAL0DeU+XRKYPzQPgxiEQ+z+c37s6JpaIqfKIhowxz4F4S93I+BV2pZr2UN3GySFobSpjYgX+6u6xUKOEtjmNISz5hOCZ0USEkshhlKlNH4Is1ICQJYQCk7fLYh4SNGVxT3JwSgHSrFTSG1fjvZe2uQkYKYRDCm9UMvjhugVIkuUCE0YzMDUbC00gzVzDCsp8XDBLacXqooUNEeqjZNLy3DEsyZ7/6t+/EZeOy/lTWtynMtclYesauhTt2uuy47X7//4rV93G5RrFFU11RUv2e/ogn5a1PZKZdFz1H/eWGUjFoUxutPGJih5fWw5BlehotGwpjkvZ4lA94Z
 weWQYmYg
 llhUflwzkIB8OQ5xS3iQyMFRjAC6eLmgChtvRv8RjFyEN1UjlPA34gx0dlKw8dOQ60P5fRPIgRAp0zB4+/lpl1VX1Nx8sjqYgXih0xG9m5HxjgBzGp93zrtKh1k+S31F8F+acD9+cTAepEYQWg/EslU/TZXl/L8E9wQX3Btr//cZooK29KzmhBPRY8WFmfN22t9PKO/rPgHvZ5+DbGorBDimUr6AmArSRTvbbgGmx6s95aSlcUaKSawJCf9bVO86EeumkLLQfwfmx9NyMlehNPojQ7kZiGLn/QuWi0lNcrzny5s2FtfXV6bO4m+wV3BTNM76Dz4ZCB339EPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 09:47, Thomas Hellström wrote:
> On Wed, 2026-04-29 at 19:47 -0700, Matthew Brost wrote:
>> 
>> So again, I think starting with wiring order into shrink_control and
>> this helper is a good place to start, as it fixes an immediate issue.
>> 
>> Let me know if that seems like a reasonable direction.
> 
> +1 for wiring order into shrink_control, and possibly also the priority
> as mentioned in an earlier email.
> 
> However for cgroups-aware shrinkers, The number of free memory in a
> zone might not be an indication of fragmentation-triggered reclaim at
> all, it could be the result of the cgroup hitting its memory limits.

I'm not sure I understand your concern wrt cgroups, but some hopefully
relevant (and hopefully not wrong) points:

- fragmentation is a zone-related property, not cgroup
- hitting a cgroup limit doesn't wake up kswapd nor go through the usual
reclaim/compaction paths, it's a form of direct-reclaim-only

So I believe it should be easy to recognize when your shrinker is called for
memcg shrinking and not kswapd and thus it can't be happening due to zone
fragmentation but must be due to memcg limits, and then you probably don't
need to check zone_appears_fragmented() at all.

> So I think if we can solve this with a combination of GFP flags,
> plumbed-through order and plumbed-through priority, that would be
> ideal.
> 
> Thanks,
> Thomas
> 
>> 
>> Matt
>> 
>> > 
>> > 
>> > -- 
>> > Cheers,
>> > 
>> > David


