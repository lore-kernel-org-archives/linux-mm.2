Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9EA6606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qUDJQ0nV
Received: by kanga.kvack.org (Postfix)
	id A82A16B03E8; Mon, 19 Oct 2026 22:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DE76B03EA; Mon, 19 Oct 2026 22:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E2C6B03EB; Mon, 19 Oct 2026 22:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3370F6B03E8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:29:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C034120845
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:29:08 +0000 (UTC)
X-FDA: 85341422376.14.2C91012
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4675A140003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:29:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUDJQ0nV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792463346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQXRxNel2NXPGE7cNmLoxbySMwttErvNQDqeGZaxUwE=;
	b=6plDxgPIaw9jRVhJ4+/9Ca2oPbfpxnRx0LIXNhTTpADuUZqpSM0Lt03sua3CxGgnRE3giM
	o6s6jO99Nm5j0K7D2z3wLnvLGT+berwEHxJlobirM0YH8MzILPjnTYxJetlaP61HNANg2Z
	JgLEoqv4jWoH4inYr6MYS8m85LEGhHk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qUDJQ0nV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792463346;
	b=VCtyk6QE1cJHIN/qP9xPxua3oYCJdkirhRHHTlzfALGWMlkjqcLjQWk/qXgaDIuphd5Fq+
	HmWwu+t4+ff6qac2RmL3Emo4dm+5FKCpSKxuyP3yqzCMsdhgzW+Zw90W5JWCejTY3deBj1
	0j9QJ9Ismczb539taRMVfPAp/vuHjzI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TQXRxNel2NXPGE7cNmLoxbySMwttErvNQDqeGZaxUwE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792463344; v=1; x=1793068144;
 b=qUDJQ0nVu66LxGsLtYCr/KVQJFS05FiWeAJBMMrJC3WaqrUDSH9uHHQvV9KYmdtuRY0+skGR
 tRK5Ibf7+XzfGK6IMfjrPeOQ6aqfvh55SY3rB+Gu7MMwMUgZaQjHoRVujLojDirG0ZKftgDcJB3
 G6RLNbf8n3EeO+FHXUWjzZ6s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d23a11d20bf69b7a;
	Tue, 20 Oct 2026 02:29:04 +0000
X-Mizu-Trace-ID: d23a11d20bf69b7a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
Date: Tue, 20 Oct 2026 10:28:44 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F1FD7E12-C456-4E0E-A604-FCFB45F125AA@linux.dev>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
To: Joanne Koong <joannelkoong@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4675A140003
X-Stat-Signature: wssy9e59oyozbcwc16eoyuryijutck9t
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792463346-817672
X-HE-Meta: U2FsdGVkX18RmMd2Uqkc1CyLu0NLUcUzIZKk0cKf118hhNOBhuOWya3l/Gtb3tjScDow00DSgGdBP/vy3sdIg5I6A9RhTYajZNwiJyDDFr3hf+8xz7BJ40FazwPk+OHNi18x/cHze3p60C8PLpNLpKdUouu2GAGTWAQPRL5yP+zBimd9uiRxO8Jty3b41jiE2Z7ys9ovxq77LQhtsgNItdjgG+01UwZB0iO986zXat5hw2FsIHQRX2boyiVKv80fxtOVhbpDUhgke7uEV9zEhsGGgHGVh9bSl2hNW2G2MRow7ARA9HGdSty/EGtIsROhzx1Pex0KxeHeBvdGAwrQ4sDoCOgKlQbj4t0QUsQU7vGc0Oh448t6pFb3OD4sK2byzKktWC+BmfRYu7i5iHsYiUy3/QnQHhZfROxc39MRfrX+MZ41znetVXhRx+luQlFiF/q8E4OyfksvAPFfqT5esgrngOSWwFnhWcuPOrd/Ge17q6uTyX+1NKleMnkCDfFWxVsUWjWCj+vBhMXD1HfHyxdFIgICf22LC3e/3rzBtfFZlFo9bG3fq+g+VtN49ys0Ddq4ThzJm7h1hGXaZQHnCCzuNtlr5qulro0EkTw5l22xAqAzOhh6XDUwiVxrxLnX33V5reLVkyrzmAub4YW0AaZ8B2Js11Y0lBeah+lTBMQPdPIsXu0+1xjmYg9Xo3dkJnMX6ew8wJykXjpzk2GvZRBlhczOKhlFLWgJ5/dejNLs12mD5kJGbJDY11Rl268crMgHqTw8zZmPYFzZW0gfYYEbxv7lke1+APJ97bJgoUHbe3j9OFEgLnj1nFRiWQLwfnDRE5m0vhvKt5/xugd2D00pH9nvOKHhcXqTptTugJXFP59MRBpDdU5lYcFkV6wnR7ddwOaGTl+onQP0CCQKPcluoaXxDfwQ5x/qhvZ46T2Yn+pJnUnl4D4psFD7EurEax3E8t7qb27NIPb9zWH
 s9pwEJRm
 R97PWoWNEScPXJBJE6tWwb7t8B0NhBxQtA0Vk0oFK3D71upWR9WmFZ0xTdht/aar7CL1KDbfj/+yAORuh/p1wlWJstyAMPwIjX4lO4UKt21fmiUG9/p5P/qJy5Kk7yciOIUDhAje7PvzkmE1r+s5bQLUOH2pXO0ylAP02EpYOu5CCIjpu+yFmD5YbZvkGIUtdfzs8nUoNuov40qJ/nXn6we0OTuQqKvMS07LUYHl6FZLIoGzyapp6ZDAvM6u0gwD38/zgja8IHpE9R3c+aq9FbLrWf2AgXDzivrH/DmnCPX/B2WCvBP6PmTY/BWz5h/+gAuGf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 20, 2026, at 07:06, Joanne Koong <joannelkoong@gmail.com> =
wrote:
>=20
> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() =
call
> folio_unqueue_deferred_split() on folios where the refcount has =
dropped
> to zero. In these paths, folio_unqueue_deferred_split() is called with
> the lruvec lock often held (move_folios_to_lru() always holds it and
> folio_batch_move_lru()/folios_put_refs() usually hold it for every =
folio
> in the batch except the first). However, it's not needed to hold the
> lruvec lock.
>=20
> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> the deferred split queue lives on folio->_deferred_list in
> deferred_split_lru. The deferred_split_lru is a list_lru with its own
> per-memcg per-node lock.
>=20
> There are already other existing callers that call
> folio_unqueue_deferred_split() without holding the lruvec lock (eg
> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
>=20
> Add folio_batch_unqueue_deferred_split() and use it in
> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> unqueue each batch of zero-refcount folios from the deferred split =
list
> after the lruvec lock is released and before
> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> critical sections, which run with IRQs disabled and are highly
> contended.
>=20
> This came out of the discussion on v2 of the mTHP shrinker series [1],
> where queueing small mTHP folios on the deferred split queue was found
> to regress Barry's fault microbenchmark. With [1] applied and
> khugepaged/max_ptes_none=3D0 so that every folio is queued, perf lock
> contention showed that the extra cost came from waiting on the lruvec
> lock in the free path.
>=20
> Test setup: 2-socket Intel Skylake, 40 cores / 80 threads, memory =
bound
> to node 0 so that all threads contend on one lruvec, with each of 80
> threads faulting in and unmapping 16 MB of anonymous memory 200 times.
> With only 16K mTHP enabled, this patch reduces the queueing cost from
> 15% runtime to noise, and lruvec lock wait time (summed across =
threads)
> drops from 491 seconds to 38 seconds. Most of the remaining contention
> moves to the deferred split list_lru lock, but runtime still drops =
back
> to the unqueued baseline. This test uses a worst-case configuration =
([1]
> is expected to only queue folios of 2M and larger).
>=20
> [1] =
https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1=
MaU9bXs99w@mail.gmail.com/
>=20
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


