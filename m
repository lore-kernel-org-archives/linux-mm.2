Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F76606BA94
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnXLdq3k
Received: by kanga.kvack.org (Postfix)
	id C9D226B07A4; Tue, 27 Oct 2026 11:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74056B07A5; Tue, 27 Oct 2026 11:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A306B07A6; Tue, 27 Oct 2026 11:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 966C46B07A4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:00:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1832C0A26
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:00:21 +0000 (UTC)
X-FDA: 85368717042.10.1563886
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F562A000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:00:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnXLdq3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qp+fSXor3rJtw8hGRhqYEuRFppHYbzFfezBhq/ClTY8=;
	b=IvrtI8CbxAWez5PZUijT1H6o+0refr0lal5knhK278q70et3Q1qpQXe/Zp2+nFPXAsaQE7
	6Xzo8lidHMu+fryF/u9uM4465T3NkfhAZ0qTFD3o3pV7aDH0ZowAOVorr88+G3SSlnyQuL
	+5O3b8UuPGYawigpraD+5d9pDifX4Ec=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnXLdq3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113220;
	b=tmwCdt84cRVKP2lxskXw5WSLk+DKDy1GTwODql5oEZLrgEYJp+609PIlTifFmFZvdCTZyT
	ITqJtnw1Po11kX+U/SSCe5RevsA1WLCuakXgOFxMYmB9XgdaMjHpd/8YKbc5wvdkrFvURx
	kMAhnHKtRFzis21smq6dHOfVayzeiVU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EB4140AA7;
	Tue, 27 Oct 2026 15:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0151F01825;
	Tue, 27 Oct 2026 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793113219;
	bh=qp+fSXor3rJtw8hGRhqYEuRFppHYbzFfezBhq/ClTY8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UnXLdq3klaC+tZ2+JX6PBI45P7W7nF48+f9ADm70UzXvPsh4+dY2WhOicztPbMw7F
	 SARjt9Oczq92TzB6tsLTcFdVUo5032qKNP4oINRE/Q8ajIBJ3KPA69x6ct5ZyaPihb
	 dzmgq7TcIx1PWaY/d5t1JPP1sQw/8RZHDucCg/R/QFCmyDP2NXPW+F6S6AUKz2W+3t
	 Dpk7PNOGHdNngY66tF6fRyZEMJsZsML0o3pMjD/NKndJzXXBZJwiuvk6Lr6JNZpq0X
	 Vrc6vg4zteKiAqZrKEoQENifIVt/YUhXNNs100l6gLc3ci49cX4el5JejC4ULazFv4
	 Ph+fkkfmpEbLw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Qi Zheng
 <qi.zheng@linux.dev>,  Shakeel Butt <shakeel.butt@linux.dev>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Kairui Song <kasong@tencent.com>,  Barry Song
 <baohua@kernel.org>,  Axel Rasmussen <axelrasmussen@google.com>,  Yuanchu
 Xie <yuanchu@google.com>,  Wei Xu <weixugc@google.com>,  Baoquan He
 <baoquan.he@linux.dev>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  "Liam R. Howlett" <liam@infradead.org>,  Vlastimil Babka
 <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  Kees Cook
 <kees@kernel.org>,  Peter Zijlstra <peterz@infradead.org>,  Jann Horn
 <jannh@google.com>,  Pedro Falcato <pfalcato@suse.de>,  Hugh Dickins
 <hughd@google.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Jan Kara <jack@suse.cz>,  Zi Yan <ziy@nvidia.com>,
  Lance Yang <lance.yang@linux.dev>,  Rik van Riel <riel@surriel.com>,
  Harry Yoo <harry@kernel.org>,  Alistair Popple <apopple@nvidia.com>,
  Nico Pache <nico.pache@linux.dev>,  Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>,  Usama Arif <usama.arif@linux.dev>,  Kiryl
 Shutsemau <kas@kernel.org>,  Matthew Brost <matthew.brost@intel.com>,
  John Hubbard <jhubbard@nvidia.com>,  Peter Xu <peterx@redhat.com>,  Will
 Deacon <will@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
  Nick Piggin <npiggin@gmail.com>,  Oscar Salvador <osalvador@suse.de>,
  Minchan Kim <minchan@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
  Xu Xin <xu.xin@linux.dev>,  Chengming Zhou <chengming.zhou@linux.dev>,
  Chris Li <chrisl@kernel.org>,  Kemeng Shi <shikemeng@huaweicloud.com>,
  Nhat Pham <nphamcs@gmail.com>,  Youngjun Park <youngjun.park@lge.com>,
  Gregory Price <gourry@gourry.net>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Ying Huang
 <ying.huang@linux.alibaba.com>,  Jason Gunthorpe <jgg@ziepe.ca>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-fsdevel@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-cxl@vger.kernel.org,  Chris Mason
 <mason@kernel.org>,  stable@vger.kernel.org
Subject: Re: [PATCH 20/46] mm/gup: fix clearing folios in memfd_pin_folios()
In-Reply-To: <20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org> (David
	Hildenbrand's message of "Tue, 27 Oct 2026 00:17:40 +0100")
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	<20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Date: Tue, 27 Oct 2026 16:00:08 +0100
Message-ID: <2vxzbj8fp4sn.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3F562A000E
X-Stat-Signature: 1rcbbmy6auai6jgqqtmu4cnee44csdp6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793113220-238676
X-HE-Meta: U2FsdGVkX1/YhyZ1lE9xFqNOLI/jb0rLURYoCovs6B7oyWEzLAkS0wkIfSvkZz21w0aixf3bV7DpgLcHpk3E9Ntogi2LEW4ImzUKBITEEF/XomdoRhUi6cQsanSVcMI+5zOYGvChzExySBbTBvJdSa3vi7R92zGiCXKBpf6RavjaGdvb7hXH6DA7LeaEMrwZ7i0kGD5c1u7SFdmsSKKebmLcyvCUV/0uFl61wGaHiYKnNDVRg767GfbXoW7XPNffJQzIxSKl1hDJ5yx6NDyjcptZ43KSQ877JkGj1FMoANEQpCkjBeD4AbSydIGIYNynNUBjKaa0yq6GbgTtcIZZq7cY3ugOFCz4tT43d4dp1ZsZ0cmBt+v/kQk1ltLc1+zmlvtpwOKhY+2YwPHSR3Ke0uSqwLjKj71eZAHMtLPcfFgUNpVupPrrBwN4homO08KVBr5mbIqtegUxLL8gV/nAdiH5ZtUgirJN9B7eLysUtKUjyzme1TYihDaeoYe0u9KH2A6PYK7NmDI169EH0LBOkgdYRqN080p5rkflChIjUBhE4R8TpTi/Y6gtqTRj7IQOFQVjJvaUaK6jSFbbj1ErvVdlYno/n8poJqzYvn3DZfyybs944P5fmKoWM9OICa3UtKQ/UAqGxTWGsu9NUwMZHErB2UrKWjyWglAO5odM5GiBoE8l2mhBp0c6bR7SXebDtsTE/1zRzk77Sqkb8m7CXAtshqG27y9yB9Jf/tqt/YqYjgH1WZ3wZ3i3oq2YREYvbvIEKvnlfWtOHu/2Z5eelwCk8w12bneIPY5vbbFaVYK/Rihf47geEf+HDY37xyTt6IjMm12r1h2pE/0wnh2nXyLHYpYcUAFgUFS0r+F4r8BqHqogi6N5FG7qHQYyW5Idrs30K0OKWU/JR/3t84OU7IuKWYgJ8ol9ekoIMToZSkb9zzuRf2012XplyRt+0q7HVO8l2nZaBAa5YmoR+vQ
 w2tsxTcf
 3hv2fwq/1/WKMoIF48BIAIFWMwM9qrbjlJ5GQUkcVRRlFwJlYSXo8vaT+1KNBg8zLe+ecvOe0Otw5iYFecDcXKwxi3evDbePvGM+B8/MdPuvxKhwqulW1mVBedFfli9Kq26JWdJTr3IzCeP4reb02Ma3Z3YH9lVCnZY4GHP+s+0C3odEfmoOJ+i+RppXZq1OWe/fn9nDhA2saJS+YolNxAzjW6IgKI1HetTLlb6jlODOHTT0ZskTvQdM5ZbiyShaibQWAA5H7nas4OvMA8XGtSZLGHZQopYoar1OeK0Giz3x+ib7BGz/5hM5Zuv7o78m6pxXzHAnxUAe2+0+F8FaT3cWUzRRZ486ciUM/U11v/iq5Ujo2N32UPscCrqbtAvnq1G0DGkOnBFTo0hA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:

> From: Chris Mason <mason@kernel.org>
>
> memfd_pin_folios() pins folios obtained directly from the page cache
> without checking whether they are uptodate. However, shmem fallocate()
> can leave newly allocated folios uncleared and not uptodate. Callers
> such as udmabuf can then expose uninitialized memory to userspace.
>
> Clear non-uptodate folios and mark them uptodate under the folio lock
> before returning them to the caller.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description and comment ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/gup.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index efc9aa2654625..47e7ae152cdf1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3516,6 +3516,20 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
>  					goto err;
>  				}
>  
> +				/*
> +				 * fallocate() can leave folios in the
> +				 * page cache that were never cleared.
> +				 */
> +				if (!folio_test_uptodate(folio)) {
> +					folio_lock(folio);
> +					if (!folio_test_uptodate(folio)) {
> +						folio_zero_range(folio, 0, folio_size(folio));
> +						flush_dcache_folio(folio);
> +						folio_mark_uptodate(folio);
> +					}
> +					folio_unlock(folio);
> +				}
> +

Nit: this logic is repeated in a couple places in shmem.c and in
memfd_luo.c. Perhaps it deserves a helper?

Anyway, sounds like an important fix so don't make my nitpick stop you
from landing this if you don't want to bother.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

>  				if (nr_folios == 0)
>  					*offset = offset_in_folio(folio, start);

-- 
Regards,
Pratyush Yadav

