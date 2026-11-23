Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A63606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LG/i+4eL
Received: by kanga.kvack.org (Postfix)
	id E6CE56B05B5; Mon, 23 Nov 2026 03:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E447A6B05B9; Mon, 23 Nov 2026 03:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A546B05BA; Mon, 23 Nov 2026 03:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3D4E6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:20:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49F684082E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:20:11 +0000 (UTC)
X-FDA: 85465686222.16.9C4C915
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB964C000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:20:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="LG/i+4eL";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795422008;
	b=NTHut3XzatLgngoTQT6jHpstuvAkxhluejuwPfYWKY9SW5SXFo9oqAaopFrzIdJ2ACmhKo
	R7cmVdVwGEpCpC9Y+HbGvH0mJsI1RmCH9N+b/5ZXw1UJmhmQDDHDE1Ka2NcnfZnuLh2fRQ
	4k0kFnxmTf8mCil3AXy9/92/nGbp+7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795422008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyCfuyIRnFb0vjbdiNcIJQQQT5nFp9YD6UGELLn0Xrk=;
	b=I6PRXApV2oP2TjdM1MB3RA+znzqQMIuW+Ap0iftnUMUuqfw/oW1Ithld0J6/BFYSf7AoCI
	dQf1kgTsl08DttmpCionpqreh1+02vuhJBpL8uzNWmibBaNj/pm2M36U8r6A4vua8NPGEj
	lprq/bpALeseX3GesTUo/ori6WJvZZo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="LG/i+4eL";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795421998; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YyCfuyIRnFb0vjbdiNcIJQQQT5nFp9YD6UGELLn0Xrk=;
	b=LG/i+4eLIv9mR1miWY9+/Xze809kksW31GpkDjfGJCbWIMpqhUnbQgt4lPBjWry/rJDgEiNClv9kdeNVrpCuvqo9KIMdMUaDqwpsLxNulOhh8YF93sD1jthrV0VLyzAehEdZEC2rMoXXBID/QqZW8D/UtZ/cjE7Hh/ybRBbiWxI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0XFFKHO-_1795421993;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFFKHO-_1795421993 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 16:19:56 +0800
Message-ID: <1ced7dbc-6ea3-4d2e-9388-755965765130@linux.alibaba.com>
Date: Mon, 23 Nov 2026 16:19:52 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
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
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6dojyh7bthbaiuxtjbyd3rmcukd76dr3
X-Rspam-User:
X-Rspamd-Queue-Id: DB964C000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795422006-869340
X-HE-Meta: U2FsdGVkX1/Jxxjpm1VRO/KeiaILK9i+2KlCe5jmNxNcCaJMbfN22boBXngElqmIFfJn6v5VUPJU9WoyffYJ1qOQqo6Fedxe+iACV6oIoFWl2nGg+3T4h4i8LuSrIlkFrU4jMjTQQmWk80ACcMn80I73fYow+vQZuGYVvontlIlcLF1wDySgbOEpb1dL4gSPGFs9BvqeuIZWTu6GKWk5XHLr9CdCGuX2L8l1AY0g7Htx82GiQTmM7PiQAExwT2EWBS0TB7U3QtCyhN9ilJPmyB13/8otJG0xRuHcWeKG3Wgd1S1LKGw+PVV/QTgllcyPNAlJmzyT7+Wo67W+VgubMMnXxM4h+JrxoG91gZuhENdGHlwG8nxTS+Y6Y8uSo8Y48zAGGnN7mm2uRg2uTKKs+I14yK3J3DFEDru07RJH4V0VcwTZStYx4mcq6FIMoh1PQrNu5NFdPixfEamXfWy7VRXRHiU6XahQD15tjRPVtllap0SX2LkXGyk+jTO4PK5xSJZEKnV+A/DuWda9T/EJHZjH67HCFZtpHghaY43Z5QN3Ul7S36gAJ2zU97icxkHhYc5k4Ruu4r99Rm0Y0LE8JMaDrILI63jRuvvtlQIbK3Fz5nvQoO5Em1r+43EwgjQfBjvH541kBeLAALV/IhJgTC5TMezyWl4vAKg8RS2aObDM1SgGHorpCYA/iV8HUgpjrA2TCbRDAjC7uDm+3Woc+SVyysAMpZkz9CKS6RZMhGeTWvCwoO6KAtgmYyDTw/cXJ9aBjO/SnyiVzGbgQMlP6AMZIEVZavMFestimsJPrWn1GLEf6MXXTQA6Am9Td/WcNCH/+jLckPkXMH/0kySyhjX9Wi52ZC6Yto4thwNxJztXntYk6dx2XmYSjDCbGqWCXAoKEsWSetvlxpMb7YMQkCtnBstJqwWTHfRDB1oW4UFi4jGzso9GZGvkUhEVSf7rlwtMvIzprVt6fMptxDL
 MFPZ0k4S
 0QjTto8GyOY9VvoIw3cTZX3T0xRjiQLXdcDpD4qJNYbc19O3gOQ4v8038dZqLtEQbW5lG/EGht4fT1qAATUwwKQPjLp/eAF9tYhdDWxQN/wYC5a5QlO1bPfZJYffBHnO1H+0BoJDAT0ZO1z/rYt6Pm5zhq3sDoaIHgBglrWIbMJM3jXF2ITZ65Xq1AieqO9BBYcri5mRZ1dxt7kMvSF7bMdKxROGK1LCxeO80jIJ0QiN/Cs3JJmAscLOXKndu5nnMOhvYCMvtqZIBbvBYvW+aUkg2hjhoCza7L85WcEnacDAxxSwkWxHj+oD/ssRLzvkHQaZnDXdLM2T8iwdO5+jBS7SZrFbS2vVcTgwmJdc4vG2nal1UjGeQQJSUSZtCcBcWLuNoSIDitnhj5KGaAlmKcguy79DgSahh0srkAAiM+47vTqqLYjOvyM4PuQRnhRnceKpFIzTCag0XkC4hcV918CpAncuK7LXZqya5D52VW7LnsM8f+xcwRgtlkcZ5p1lS6dSjOBYkXzU+Xecx7G5X0Zw4HVQQIMfE1UkGMCSgreag0juBFEm4lSiY+Qf1RaajEyPte7La0FA8UbVA/cRx9DW1hA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/22/26 8:42 PM, David Hildenbrand (Arm) wrote:
> Various callers (migration, memory-failure, s390_wiggle_split_folio) split
> locked folios without holding a reference on the folio's inode.
> 
> Splitting a file folio might allocate memory for the xarray and call
> filemap_release_folio(). If either ends up in direct reclaim with
> __GFP_FS, reclaim can evict the inode through the dcache shrinker, and
> wait in truncate_inode_pages_final() for the folio that we hold locked:
> 
>      try_split_folio()
>        folio_lock(A)
>        split_folio_to_list(A)
>          xas_split_alloc()
>            try_to_free_pages()
>              super_cache_scan()
>                prune_dcache_sb()
>                  iput_final()
>                    evict()
>                      truncate_inode_pages_final()
>                        folio_lock(A)
> 
> This requires that nothing else holds a reference on the inode, and can
> be triggered most easily with FUSE, which evicts inodes on the last
> reference.
> 
> Further, xas_split_alloc() charges the XArray nodes to the memcg, and on
> cgroup v1, memcg reclaim waits for file folios under writeback if
> __GFP_FS is set. That can deadlock if writeback waits for a folio lock
> that we hold, for example with ext4.
> 
> Let's fix it by splitting folios in a NOFS scope, so callers don't have
> to care. A NOFS scope also covers allocations that filesystems make with
> their own gfp flags, for example in filemap_release_folio().
> 
> On NFS, splitting folios with pending writes or ongoing writes to
> fscache might now fail slightly more often, until these writes have
> completed. On netfs, only folios that are being written to fscache are
> affected. All fairly irrelevant.
> 
> This has medium urgency.
> 
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()")
> Fixes: 789763523fb4 ("xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Make sense.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

