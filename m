Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18821606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nWCnlAlR
Received: by kanga.kvack.org (Postfix)
	id 1DA0A6B05B4; Mon, 23 Nov 2026 15:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189026B05B5; Mon, 23 Nov 2026 15:46:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B6B6B05B6; Mon, 23 Nov 2026 15:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C67686B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:46:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C50B809BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:46:15 +0000 (UTC)
X-FDA: 85467566310.17.95879F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5619E80006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:46:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWCnlAlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795466773;
	b=K/KsYRLOJuMHLlNl6psvdykjg+pJF5seYhOWSTRNo1osPWdSNYe7tDiln24AlJl2jekPUb
	KzAewFhAaT6ukjkgmnLzJhEWJbVhSMvni68z8MxgEG+feOeNSbz6ofw+3FQ0z8p6cyMzFI
	rbjl6kM/ld+IO3YPNnM95jSbBVqK0FI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795466773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iE5vwZ52FCrf/Yf1bfaqRjLKYFiqG7NiHPUuhaY2RUE=;
	b=IJ0vc7SIESVW1fjILioeaHmOJNiejeHL08ckZaggBD3HfSHvIgo4Pot3YeMs9MVlZmCO3K
	/9Y07o/KJ2UxsxNG8B4VKvx15xIpuOcsWCMgtjsfaK13HjntHOoi9UAEIKwvUn/yOzI4CI
	xT9hB4MhTGUaKjpLksWWtaUXDSh0hEs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWCnlAlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B4F442A8D;
	Mon, 23 Nov 2026 20:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0B51F000C6;
	Mon, 23 Nov 2026 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795466771;
	bh=iE5vwZ52FCrf/Yf1bfaqRjLKYFiqG7NiHPUuhaY2RUE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nWCnlAlRSrYcmt1N3LrIiGlo7ITb22rQ0nLhDggE4JyA9gyFUmf0xEchJxTiQf81h
	 ZKeHd/THIZR+7txgcGVcMCSAdaw132w0xi+hd0jYuZ3RA5RkRL7eoWiC950+y75oMa
	 QffL8s8c9SZLIB9S0vLf2qfARj514d/3iDOTf9YHKBBxPgRFW6QTLTPwC46ftjXX7m
	 TvtnSOoBgL+pZXB2nslP3BBlw6ZsrvQP10v6dgDRmrFPDkMpKoY6iOBwZc6REEg6ml
	 bgEROSIxRGuzgZF5K2OTXwczXczOKpb6tBNBnblx/tvLEm8L5/feIq+gMu22x8Niwu
	 sbBMzLhbCKpug==
Message-ID: <a590ab03-da4b-413b-aca4-1072c0669d2a@kernel.org>
Date: Mon, 23 Nov 2026 21:45:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/migrate: allocate destination folios before
 locking a batch
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-2-83c56185b0fb@kernel.org>
 <DN2RK7R9T87V.1DLJWTHIM19Y5@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DN2RK7R9T87V.1DLJWTHIM19Y5@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1spue6he43diqaxeo38wgnp4bydtw6wk
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 5619E80006
X-Rspamd-Server: rspam03
X-HE-Tag: 1795466773-951187
X-HE-Meta: U2FsdGVkX1+z0slPHJHQx7G97ULt7rhHHtWY6/pWhYrGXxDsX7uNAwo0BCUDDuvDzl5VVJQdGA89bBs19IHLBFIjohkHAp9tdmvf/oYGRpqM4vObPpf/aFbgpe+iTT86PslOkq8ioBzhJ/QDPNvrSKQtrdVlNTJbXzJxTbrd+YA9qyPsB8y/0kazhcmX4GrevcWzlyXpajXLE8ASFHGuo5g90FLvazozDAooGPDS/XVD2s9b6h4CIjS3ZaoUIl1L1x28rKaCc2Xg57kxOGWCXMo07Q29q5skbPL5+VIQI+Imkpn4T83uylPD+/q0miUu2NvOhoS7LiUAnvn1axqBj18hhXZXzS0LY+NuVKfw27ak+LuAYEQUqkVItjyF6foy1bkgs8oh4Sm6kJDEd2b/T0L/16fmK9OLLzMjQxrD3NMe3azAPf+TwqIQQZOE+4m7u923qNoZa3DrWEU1wiBXJ3B6oDLJ1A01msiXTDOER5qbvCQQg5yhiV2fiXFbT9vlqU0BYjYZQZ1kT0vzkoPpyNq5g5mP1LtpheM2fBp2UJVdfOXmrTbkdjotNXSE7qGOXVhvTmjlxBpkAIb6H7qhmxdC/x/YXmIFRvgYmXGQ7zEMNeHZiOo/D6gaSNfQGxBjC2jivNIR5VEfHhOzShmawQVfiUbyfEXnV+KWsKwMaRZy/7gu+ERVDGf/OzRDnw7jgXK5ZMlJpojuRlEFUvvUHxRQzXYdbomdeGMccu/F4Jdkf+UMkcg3e81Dg6KJ0Gb1klw84tUwtBJCSK5xg4LT2sAJDKkebqYjSh63eN0oOEcoy5BDRbMQWn+jDndXGDiPyQcwPXe5p7QqRoPiQPoOGjY9d6AMr7EzpFPXxQbCXYhqZxNc0liygGVXAnx8MMmsTr+CQiHczCzIw6NaSLUtnu1OCcPHS7Inq/tg9pjdom+mm1E2O4RMrB1Wtn66fxaE+2ncuiGPbHdHDPT7xDu
 cF2gY6W1
 mfmw0W3q0WbVZwPO4fcVdZOkE6lIeyfo/QZ53+dZPVDIUq+YMRHo3c3dI8jT8s9HVMTtWL2BlhHbT7JA3SpXtRNntl89KQlT5KsQ34qr+os1+1ffbBJ4ch9GJ7JDu3VrPB03dzCh3pQGhktFKUJkaq+RNv42pVTi7AodWj+3Z4O/t4T/G+XEJb86kwPhhoKcnAbHw2HI25KRzzcSmrejWaAVYmDXeCutL4pjAN0FA6R9+9yneyhe8MlmD0EvnPFitPqS1xQ4nRgZTDRQc4IYQW39l/ANMbSMKOlI0wMjXPJv/ri2XVnbv9iwpI7pkiXi6qekkFfAH0aJFUYTHbAxOnreOyVvdE7IVwSYaEoHttqBfPffSoQx6q7wFFDSnYFdslvgAuTqquzraRP+xZ2WWNuXR7z4T6sLfsFx3PnC2DrCiAIEbOv4H9NUQjwgM7z5VI+dEXp5CRwwWbbLLcWxNo0lbYCMdy4nEvkPK7x6Y+Rivn9l0vTK7DgY5875aBEJx1h4MCBALUD0E0KAOrmMpsUF4pGAhRcfGVoIeOmNoq3mtgTjulv2ur9L6i1JbqEM6+a02737BkcywgNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 18:24, Zi Yan wrote:
> On Sun Nov 22, 2026 at 7:42 AM EST, David Hildenbrand (Arm) wrote:
>> Migration locks folios without holding a reference on their inode.
>> migrate_pages_batch() keeps a whole batch locked while allocating the
>> destinations of the next folios. If such an allocation ends up in direct
>> reclaim with __GFP_FS, reclaim can evict an inode through the dcache
>> shrinker, and wait in truncate_inode_pages_final() for a folio that we
>> hold locked:
>>
>>     migrate_pages_batch()
>>       migrate_folio_unmap(A)
>>         folio_trylock(A)
>>       migrate_folio_unmap(B)
>>         get_new_folio()
>>           try_to_free_pages()
>>             super_cache_scan()
>>               prune_dcache_sb()
>>                 iput_final()
>>                   evict()
>>                     truncate_inode_pages_final()
>>                       folio_lock(A)
>>
>> This requires that nothing else holds a reference on the inode, and can
>> be triggered most easily with FUSE, which evicts inodes on the last
>> reference.
>>
>> Consequently, allocations under the folio lock are dangerous if we
>> cannot prevent that scenario through an inode reference; and we want to
>> avoid grabbing inode references, because we might then drop the last
>> one, and would have to evict the inode from migration context, ideally
>> without holding any folio locks.
>>
>> Allocating in a NOFS scope would be one option, but it would have rather
>> bad side effects, such as direct compaction not migrating file folios
>> and the OOM killer not being invoked.
>>
>> So let's fix it by allocating all destination folios of a batch before
>> locking any source folio. Now, we no longer allocate destination folios
>> while holding folio locks, which also avoids holding these locks during
>> direct reclaim or compaction for these allocations: an improvement on
>> its own.
>>
>> We keep the destination folio of a folio that we have to retry, instead
>> of freeing it and allocating a new one. If we would have to allocate
>> while already holding folio locks, which can happen when retrying a
>> failed split for longterm pinning, we leave the folio to the synchronous
>> fallback in migrate_pages_sync() instead, which migrates folios one by
>> one.
>>
>> Note that nfs_migrate_folio() still writes back the folio while holding
>> its lock in MIGRATE_SYNC mode, which allocates memory. As NFS only
>> evicts stale or unlinked inodes on the last reference, this is unlikely
>> to deadlock; this must be sorted out in NFS code independently.
>>
>> This has medium urgency.
>>
>> Fixes: 5dfab109d519 ("migrate_pages: batch _unmap and _move")
>> Cc: stable@vger.kernel.org
>> Reported-by: Chris Mason <mason@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/migrate.c | 134 ++++++++++++++++++++++++++++++++++++++++++-----------------
>>  1 file changed, 97 insertions(+), 37 deletions(-)
>>
> 
> <snip>
> 
>> +			/* Remember the source folio until we unmap it. */
>> +			dst->private = folio;
> 
> Clever to use ->private, but I wonder if we want a new field name, like
> we added migrate_info, to clarify its use.
> 
> In addition, it will be great to keep migration info for each pair of
> src and dst in an array of structs to avoid the ->private being used for
> different things at different migration phases, but allocating such an
> arrary will cause headaches. So this patch is probably the best we can
> get.

Right, this is something for stable that doesn't get to wild, but we should
clean it up further on top.

Thanks!

-- 
Cheers,

David

