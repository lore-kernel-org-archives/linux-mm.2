Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BDB606A324
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 09:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AMolvZzC
Received: by kanga.kvack.org (Postfix)
	id E294B6B0461; Tue, 20 Oct 2026 05:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA5C6B0462; Tue, 20 Oct 2026 05:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA9D6B0463; Tue, 20 Oct 2026 05:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADA646B0461
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:26:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E2A1C08A4
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:26:29 +0000 (UTC)
X-FDA: 85342474098.24.8C2AFF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BF2EA0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:26:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMolvZzC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792488387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0+lfnK2ji54QWZAyRSEpc2tj9spaFX2qA6M89XNIoo=;
	b=ZRjxQWmVQkAkokODQfbkE+8JFxOjiD4j4gS5sAXYZtiGH0zQk6EETX+qgFgjzdzZYFLJ2B
	3Jt6a2FBwyY9TzCxidcJ/ZTFgLXgKRcIBwWrzACH5nTCgUjMkTH8uI7Y+MYrLF6hSOqv18
	xvrLdG9s2/tb3QPbIITpmkSKBhLbqJ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMolvZzC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792488387;
	b=LceHq2pD3meB8X6s+oLqY5cRINhcWt7udCO9lCUacaJrShGq1Jc92qbAjwXkgSr9ottph4
	8qBCZ+m0SmaFjfXj6Fd/ORA2i/aw84ZOEq++PdjbtJ3Mx5fTpYnVybF2hqdUse44a1dr/Y
	zwFYU1EoBN0/H5+idYIXVFP95fvE95M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D47543EE9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDF41F01579
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792488386;
	bh=J0+lfnK2ji54QWZAyRSEpc2tj9spaFX2qA6M89XNIoo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AMolvZzCrE9FsqFbw4SGb9M4ZedXBvrlRBX0i+zw80ff5AI24lfl4sF8vfA1Ppbvj
	 xXdC3K7lSP+DaIoj2HeRQZ7bv7l3w6AFluyqRstiSX4orni9afwayKb8V7asA7FTTj
	 78w90EpeTQdHCeRLzNTbaTlyHx+kBB7ril6YFiYb5fcjgsbvQa1SolunQHgBBYlBPk
	 iN68dMvlow/UtqwN5bc0IY5Ipu+FRt9aTWFr2tl1BppAMR+l4RT7dNTDoe5OVPIKfg
	 fCmCkOs+oIsSPaia1EzF2YJEbd9mtCeRE15/kxVMWMeaUbZEesOLqhrCZlC4c2KEFI
	 qvYy9oQ3teAfg==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f079a63b8so276474985a.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:26:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzGaRa6+a/Y9uJtMI5VNeaRHYiNO4OTk+059RGswNe9TIXSqh///eDSCJiD81aTM1SWVl7O8vlWFw==@kvack.org
X-Gm-Message-State: AFq9FYKaicldspaEmtS+/MN6o4JZoc5mWg0JGnGpbB810sXXcawBSTkF
	86X8XMUjU4PmmlEvGuX2d7f/eb2k9xCKJqUsV3BkJ+vmKWnXglled6ZceLbAyR5/8XeOyhcZPs6
	jbgsD+010Pwz9eccDJ3sbrFnRVAqpUjM=
X-Received: by 2002:a05:620a:408c:b0:93c:c162:125b with SMTP id
 af79cd13be357-93f29d1a770mr1721438885a.39.1792488385421; Tue, 20 Oct 2026
 02:26:25 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 17:26:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xdZY2v=syWaGKFiJghE5TO5tR_4sk2-kmMdTy6SprRxg@mail.gmail.com>
X-Gm-Features: AclHuK_kJOmr_OMPMizx5puB1D5dVZqP8QzAhDuMdwUBYuNlpiHafiyq-2_jg6A
Message-ID: <CAGsJ_4xdZY2v=syWaGKFiJghE5TO5tR_4sk2-kmMdTy6SprRxg@mail.gmail.com>
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec lock
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BF2EA0003
X-Stat-Signature: 6yp1w7wp1jrp9q4ftft56ukq4kw5gorn
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792488387-218062
X-HE-Meta: U2FsdGVkX1/sJsghoz6PGNxSX2azRDCeoUPtX9zbIedu3rHzkxX0cMWUHNZnmDRUifa6FovwLvarAtNqM9UH+1+0Mlpdy4h7Q+EQMIDKDHOTnQ56lOPz6TEM2fwj+rtNA20jQBxOekgt4uk8TC8ykusMgJQmOceOOEH/Yyo0tkRq1re7aIgS/lBdrQJHeMsJp/zHzd8WPsgfKPvnr5ZZzij1qrNwKx+Xiw5sosmkfguX2eJNS68zs379nZww3rGLO1avbcdU6HLASUsULuSmLn86pYDJBO6CHJwMnoCphlsV3E83w88/UXnVYQrzrxev/5/+5cHNIH1dQfA4nuLqQtWwJl1M0Yr+aWxwSpT0BV51cr4kdlJ8wSdwBLoqNb0pxKifZ5dhK3ySslS4UmbG1teWFfD+irBdSLYHVUN7y46eCdaNmi2QXgaMtyufj/pOgsnkmjdgM4s98hrlsNbiFRcAlx1bgHocIz9eluLzLWoa626iRGoqizUfqzyr1MkP/vV0wbQ9oHl/5C+CwCg5erJ6RBJr3PC71werKAhOCuRp0ylCM5Nm59fUyph3ekFZcvBluReVgIB/ZFQwRCkbaRy3M0034Gyrz/jWgPvfk4lxfhZR53RDZnRrfX4pWC6CfQk9h8jgOIUcCNg1Bxlf4d9UWowwl/iMNpHEVHVG7pUWhsaKT12hEKllFD6GHR4LTLPv+nicoHJTU5734HCWb8jWPqAMEFZCXzZ/uWoHcGREYuctHI8dEAJJOCADmqk/pxiK8z8rp7y+lgcG25MqdXPkDXL95T87R4MrlYPaGsH2qEUzhN1CRGWVFeE1fvFtmVP+dg8Y+fGxRY1QFEK4BxQ1jYbfL/eZXK668sonwzs1gB95JqrdFhPwtjw4F/AojF2mXCuvMxdwRZwsZHFBCvUT6AoFYiKSBkVT4hNQsQOk3XwONCltl5pBLlFfbk4pi5odEWyEJxqW2mN9UGY
 DbKvCp1F
 slePdFMtta6PD8wsZivsbZ9enqE/xg6LtJxKRMyuOK9oLz3Wm8ktTTZgeNhc/6uZI1pcPbAGlm790Pdr5U5M8dvVmv5o/bJlvhUfN3zFFnjkG+8/hT8n+tOjtK9fBy2fkHTVCc1J6YopH4xUvZo6i1AnNmM4eBUowtnlLkTBTApzuGcJZYt5wpBsl3WDrTP7cESnJsZOZnlfBfzQ34TcXKa1sEei/MJMuOReooj02Y8DhAPmf0haRNacGirkqPwYw0OBxiuFdKlTKMXS7f9lG2rkIzZPf5TwGGWaEPFgnSGTzBSVGV0LcPp2TydmZfehq1iugCn5WOB5vFio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 7:07=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> folio_unqueue_deferred_split() on folios where the refcount has dropped
> to zero. In these paths, folio_unqueue_deferred_split() is called with
> the lruvec lock often held (move_folios_to_lru() always holds it and
> folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
> in the batch except the first). However, it's not needed to hold the
> lruvec lock.
>
> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> the deferred split queue lives on folio->_deferred_list in
> deferred_split_lru. The deferred_split_lru is a list_lru with its own
> per-memcg per-node lock.
>
> There are already other existing callers that call
> folio_unqueue_deferred_split() without holding the lruvec lock (eg
> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
>
> Add folio_batch_unqueue_deferred_split() and use it in
> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> unqueue each batch of zero-refcount folios from the deferred split list
> after the lruvec lock is released and before
> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> critical sections, which run with IRQs disabled and are highly
> contended.
>
> This came out of the discussion on v2 of the mTHP shrinker series [1],
> where queueing small mTHP folios on the deferred split queue was found
> to regress Barry's fault microbenchmark. With [1] applied and
> khugepaged/max_ptes_none=3D0 so that every folio is queued, perf lock
> contention showed that the extra cost came from waiting on the lruvec
> lock in the free path.
>
> Test setup: 2-socket Intel Skylake, 40 cores / 80 threads, memory bound
> to node 0 so that all threads contend on one lruvec, with each of 80
> threads faulting in and unmapping 16 MB of anonymous memory 200 times.
> With only 16K mTHP enabled, this patch reduces the queueing cost from
> 15% runtime to noise, and lruvec lock wait time (summed across threads)
> drops from 491 seconds to 38 seconds. Most of the remaining contention
> moves to the deferred split list_lru lock, but runtime still drops back
> to the unqueued baseline. This test uses a worst-case configuration ([1]
> is expected to only queue folios of 2M and larger).
>
> [1] https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+=
te8G1MaU9bXs99w@mail.gmail.com/
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

