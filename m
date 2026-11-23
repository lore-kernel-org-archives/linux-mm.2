Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98F1606A335
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=msRudmS1
Received: by kanga.kvack.org (Postfix)
	id 99D836B05B1; Mon, 23 Nov 2026 15:45:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928186B05B3; Mon, 23 Nov 2026 15:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7ED6B05B4; Mon, 23 Nov 2026 15:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 325816B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:45:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BA9AA0A1C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:45:01 +0000 (UTC)
X-FDA: 85467563202.26.0E1F51A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7A1916000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:44:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msRudmS1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795466699;
	b=TAqVC6i1BfyiBCCjNj/jfXvXRbCDk0wqvTzjAFwbsf28R/j+acORAV+aR09WUqDcfU2pM4
	eG7E4zRiAjOB6TkR4hhdLvhhu7qk7z5U3kFM6CvboX5dnEr+kYMAI2yYfhBFxFyuQcloeZ
	axGWNTgfRpxH5uyQxqzayjCwu33iBlo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795466699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+OCxwI9lwKAuuqKZI6U557wp+tJEVNdQ059Xmhr2uw=;
	b=CrfKQCUW7VXG1wufygTzbODqpl2NyUInezdGl6nbU9R6zTvR+ueNEw9iroW5yKC2NQQ+Ev
	NhbTNAC5zgbppnsiMkKMQuNBUBfLpt4WWBZ9SdimfraUuMzqufdyNQVXWd2v54Hgn/sK32
	dazOSjHaYAIIXOMBZ7A6FQ2rQ/He+Ps=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msRudmS1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B9C46243F;
	Mon, 23 Nov 2026 20:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7D71F000C4;
	Mon, 23 Nov 2026 20:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795466698;
	bh=Y+OCxwI9lwKAuuqKZI6U557wp+tJEVNdQ059Xmhr2uw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=msRudmS1+Jot4KjLYg1anHYSSlhnwYw8ctVrwkYkz0l4hAZ5g8NYT56kSS+Rlqd8b
	 fDm2jo1E06w/mxDg/E4WZw7U/ZSZwOvYUgiRyyKy/sV/NXo9vcAEACVnHARFy/gJFS
	 fAmBUuIx/oodveQtWtpXlmvFKfzbDaF63gkY+nqcdiD9POMATbk1UlVzPeH4Ftptuv
	 bWhL8rbNOB3SA3ek+c9ITMyIXdgVcjcx/4fsjM579SchHtTJEafWXe5xbT/i+SBkTp
	 QRBeTdwt2sHLmPO7/Hy4XBwphKFi+/prPjY9ANW12/QzIukjcagVrlli0k8KPkYQbU
	 yYJ/XpcgFIKsA==
Message-ID: <2cb3ddae-9ece-4d91-afcd-9adc3251fa35@kernel.org>
Date: Mon, 23 Nov 2026 21:44:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
To: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
 <awSgk1VTUsiVQOAT@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awSgk1VTUsiVQOAT@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: xu6jeg94mm8jmf5ez1otgpxd684ouosr
X-Rspamd-Queue-Id: B7A1916000D
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795466699-645782
X-HE-Meta: U2FsdGVkX1/S5m2AQeq28p2YrcVDB7NPIOZBQMJr4s8lEC15ULFNRZTcvKZS+ccntCIDun7+UJdW5TQ6IYxt81BdCXde7/af6riKVyfhIB/yOcR/qmCaicXq4qjmqAR0AkxBN6vPBeQUsLi/itsyO3Jx0GHAdmGJgdpr9r4mJOpJQ18TTHWCucXNHnNkFra496ASfYBu6p3+lFhCZNJKk35kgMUpwC5tbFih9StkHil2Rt6uTsbQcLTosyAD/YsJzLR6wDqUn+4d4Y4kBz3UUTmsGsaL7g4MY73fpCUX5NbVxECPZ3rp4bxMjFxpIXyj2ymqJx/qfQ3lQn1VI+BL3uULs8eQTI/GRAylO5IKdgwv4jxqeMYTk/W5ats5s0XsZGNiqs2CL3QFoWofrhU8xQIE73SaYbrC58hQEO0CaKdFwkugYYbcVuTCvfGUkiLIqj4sBZ+MEqNSwQozFqMUguIlgTXUzclwRAWlHBgnVMjt/1ZtwP43IIELMbm3MsiGo7tjjcx4sghRSs+6pc/lzF5cUrHySNSJQfvAvtNGWQZnLtMx2yw4JfWyVd/qq9R4eKv8EGo92IJBBvSGsgvprsWccKK3Zz26QGzFchi3NsbO3QO0/30AYbR8cFYKoxX+8b0RT11243EtOS6URVMigl2v8vfEgYx1fKpEPONzYXQBsn2yPgGZELDdlT1hwKHcEHp8Ed54nBiZyTWYQzdKNorU+7T2zLxyeQZDu2KEIhDBbc2wQV32iPI+MwK3zrERM18jbWKImOD8WyDT9Xan9h6Co3jeWO2jwQAEsh53rCceORmYjdURClAMGC1tUhVpfSSI36xzP0AU7RKjBrhhUVeb9CNkm9lT/LavCZorFUy76HDMcnWXGDzz/mZ2usou1wyaMOSDtiP2MJO3t9JPbVUWj7t+W03UmIjYmnv4CFk+tfd828KxP5kfNplgyWRAKrEFM84YnxAgqxE70Y+
 Z02MR3u7
 7Sc9YGe5lgB1rtSoTV3YxkU2k0RbV8yqvY/oANcouVUx9z2QkpmrH3udl/frCWv3KNuxta3S4DNZd4q5ZAqePlBuNms3yRJ4tNeutF5qsRQIGF+TXRt6u8ntnAO6ovytyMwsTLY535oC0LXA6+jy7Gj/tmyVEu4OPalXaCQqVGRQlyfndZNaTLg3+zgMwONHm8OHKhbuL6MNXgvdSgK6lhvau7Q/ojY430cuhjj9JKh0Gd/ejGcl9G77IiIe9154JPMNH5wooC5o9zO6tNDmbjv0w1pUM+tt/EWUTiI5FlpheHj5+rEJAc0qMTAqKk3Gbmhm+d4UQ/EiFMwifdZ+hUL308TTccGKGSffaNtriAIk4weOYWindLsjxUxSjmi/Z3sl9CCbbGExgr0HeVo81aUFVAjbNsSnZjFFTyY6gio6lezQ/+l5e8tHfhzS4DYfjQELPRfWLvJH09aB8iPd64hOtYxypSyW/8J6PGMh6WDX6WHVFbFX5uAbDePuM+7VWiSFMgECI1voRFXZ3or/vecZqd90vR9L1zDpvf2Xdxv1sL3gMfB6rAQQk27T0RvEB8FKEGUco54AFSUdagGrT0JmmtCDvF5ODxwh2+LQLogixMslb8t5d6X/WdfsQ97XZfaMw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 21:22, Matthew Wilcox wrote:
> On Sun, Nov 22, 2026 at 01:42:17PM +0100, David Hildenbrand (Arm) wrote:
>> Various callers (migration, memory-failure, s390_wiggle_split_folio) split
>> locked folios without holding a reference on the folio's inode.
>>
>> Splitting a file folio might allocate memory for the xarray and call
>> filemap_release_folio(). If either ends up in direct reclaim with
>> __GFP_FS, reclaim can evict the inode through the dcache shrinker, and
>> wait in truncate_inode_pages_final() for the folio that we hold locked:
>>
>>     try_split_folio()
>>       folio_lock(A)
>>       split_folio_to_list(A)
>>         xas_split_alloc()
>>           try_to_free_pages()
>>             super_cache_scan()
>>               prune_dcache_sb()
>>                 iput_final()
>>                   evict()
>>                     truncate_inode_pages_final()
>>                       folio_lock(A)
> 
> The "holding a reference to the inode" piece is a red herring.  We can
> deadlock even without it (although maybe the AI can't see it).  If we
> don't remove __GFP_FS, we can hit this path:
> 
>   folio_lock(A)
>   kmalloc
>     alloc_pages
>       try_to_compact_pages
> 	compact_zone_order
> 	  compact_zone(MIGRATE_SYNC_LIGHT)
> 	    migrate_pages
> 	      migrate_pages_sync
> 		migrate_pages_batch
> 		  try_split_folio
> 		    folio_lock(A)

Quite nasty, thanks for these details. I was aware that memcg v1 would run into
deadlocks whenever we would perform a charged allocation, but sync compaction
triggering it is even worse.

> 
> See this discussion:
> https://lore.kernel.org/all/20200214065504.GK31689@dhcp22.suse.cz/
> which led to patch f2c817bed58d in June 2020.

Thanks for the pointer.

> 
> So yes, anywhere we're allocating memory with a file folio locked, we
> should enter nofs scope.  Perhaps we can teach the AI that rule?

I have a couple of reports here regarding memcg v1 deadlocks, so it's not
completely aware of the issues yet.

We should document the rules of what you can or can't do while holding the folio
lock somewhere, yes!

-- 
Cheers,

David

