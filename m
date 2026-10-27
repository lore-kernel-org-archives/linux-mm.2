Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3892606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7+fBT3l
Received: by kanga.kvack.org (Postfix)
	id D6FA46B065D; Tue, 27 Oct 2026 05:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46B26B065F; Tue, 27 Oct 2026 05:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84B16B0660; Tue, 27 Oct 2026 05:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A65E46B065D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:37:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 310CFA09C7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:55 +0000 (UTC)
X-FDA: 85367904510.10.5E7621C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 835EE120008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7+fBT3l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793093873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rNSdhvOTHmuEN3Ml/bfsrTqF8UwvJdcqDi4DNQ6sTg=;
	b=2q6neOJqfxjMmLGLQNtOFqLzOw9yl678rKHjg7tHp5iqYcvId/pIQe0Ri9Lj2LtB6ULwL+
	EuMNw9mtxc1F5n5mkgSq280DWL2MD5zBHn350rDpv7IQyrzHS7WbdDqyZ4kWhNam7mIbl1
	RGDj8pVKo6onH7esyW6CcaLpbJhAsR4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7+fBT3l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793093873;
	b=pSBTT31csei/Nj1rceVPV7hLF3jUiIV/KERe8XbHc1VseI3cqMh7IoUXtAqAsAPE9bhcLH
	lwn9L/HDnl6TMZeDQSOBhQRSSmjVdLUYhZbhWc5rFRGud1O47HXuN9xNKoDUbDvost8K6s
	c6G+uKpbCLyXCj1C94/4TfQ4HPwKF6w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CCF042CE9;
	Tue, 27 Oct 2026 09:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490C11F01825;
	Tue, 27 Oct 2026 09:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793093872;
	bh=+rNSdhvOTHmuEN3Ml/bfsrTqF8UwvJdcqDi4DNQ6sTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U7+fBT3lehpQpFc3uJKZHtVpRgi1GtGHT6z3b8kE2S6FeF6bFDBDYsG/DhyOz1wlU
	 gkZvgV/b8GwC5hBF2vuMNqTpih+mBOGm/magVJ+5tlmYMUc8rC0HgDbxkq4C2ZdX7/
	 ykFSl8AC+Hlev3LyWJ5Ey8IgtYvUDz6NSxnqxhKKoOE4gmRJYKRD4ktRxpkFHa/N0B
	 GZx6g/C9Es4dpnIsGGa84PHZ4w1B6j/LHsH9niHHf9ry4zHK8ev9PN5ziVl0zIXEG7
	 p4yl/pvZrQHfp2KrQDErkAMPWJNescqIgRyziMHz4MrRviwMpP912C23Dpz/85S7eu
	 i5GpXe5pXwalg==
Date: Tue, 27 Oct 2026 09:37:34 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 21/46] mm/gup: fix out-of-bounds write for nr_pages == 0
 in GUP-fast
Message-ID: <auBwudfT22AZ82GB@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-21-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-21-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 835EE120008
X-Stat-Signature: e4u7tqx8p3ebj59su7pchztwaru45udq
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793093873-464671
X-HE-Meta: U2FsdGVkX1+9+TLrot6JsvrY6la/epq4TSacynBmQ+zaWPN0qJ2jwbURbjZAyA4P2O5aGr+7tTRFcwbGVZ7fcw3SSuUOLcMnjENbLZaoOJloE+Iv6I18n3hbZ64+1t5v+i554tKajdAoSUKQX/ck1PCRAfAbi2uzbEgnFtLY/zZM4NgGi+0pyX2JXh14ZCM4P6PheAdx9XUXoXUn/iiTlQLDp8xe/sRUn3FeesUpN3C6074B0rGcqVyj+vGc/Qyk2x53HJC8TtLNoFaQ02nVzQc9Ks3zfF9pHJwdn6Qwxio5+txa91ipMWiGLCKI4Nt8jwMY9TQVv0OYNxicvs5QZFDCSA7cvDzyDCIuwzSBgf0ezrAmkwEv17gwiZjB0bN3Y0p2AQ/L+DHfJClwWLbD+aKLVqLy2pGixsUbF5fUygANWLaaKzu5m/6Iu2S+Qe1Rwp8UbDF2fv3OogV76sObPH5utu4l50/WmMsA5P/VLi2d3tqbGx1c+258Cdt44j0Qb2MnThdav6cmS9jEOkz3mbnt+vEhiuAWBTxPlMOviPm/DFtWS4iU5Y4xDyfR/poGjosZaGXq5cGM041x36L1IX2vic/8HfBgwy5Sztj7IhAkQB4xTBvOyzx8Z7R6NVk6JHoibrN0H7unYrFqtngROyPa5hmAfKtJnDiIuBg/ydqufoJUfNk5R1XEFsZAtC96Xm5fX0feh9EYbHfSBMnv2mEp4ZY0bpafaM2BvK3Sy/RR6eu64AWr/JETkY/5iPv05lIoP8oljshJewOQpTwgnHEqw1PIIzATEi2Hig4nTZor1UZfdW6cGIskcUiln/IKcPBU1xV6SukAENGoi/7j3PhCEg1V9kL4kU8EAwT2K9uj8AImLpyQfMkdJovM0ibnWzRg5nMKvjamtCvqNx6c0aekRjmk3/mcD/Y8RVecF4ZXsv4hklQaHLUz1uLdgrmX3C9XJMvo6q9baoXthN3
 BpBSi8gQ
 fVb2Zw0SRNaoCNoF7ZuxtSlLXlOpbRTxLMX0XJqezJbbBgsJLtZUPQz0wYl3b0WwIZvavyFFNmGBbJyqdhqOsupb25uXIwVUv/FbhhaaqOnvdXXpETwWIhsJ9cVlwA7xeo3AzbhmX+6gK+WWZsvMB36raSijYIGDF9jIXNiObG9jh7Px9EYV+76moLN6XsXH074qwv4gqDXkVmLOl8DZDCJRYNWnIeSwKeWraqLnd53VayJcBEUJTXJsxlUKJZlXka7xdJ2ZOo/ifTjbg9msTYUoauVX3PQ8twAo4NKpGnqURmAJ9/oyj23KkhNR3erVfao2PKUhlTCTd+cN2rQIBJNaDrRbpLhw3Mg3XKalNfzGt0JWMnTtlc9yNnm2A3VU6K6HYn2H9X0BTocXA56KO1RU6IqDYrlJh+FZ9Z8cLaZGBPHcPLxgpKxgoNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:41AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
>
> With nr_pages == 0, GUP-fast still enters its page table walk and can
> write past the caller's page array. The old end <= start check caught
> empty ranges, but was replaced with an overflow check.
>
> Users such as OrangeFS can pass a zero page count derived from a
> userspace-supplied length. So let's return zero for nr_pages == 0 before
> starting the walk, just like GUP-slow.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/gup.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 47e7ae152cdf1..9906965893431 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3204,6 +3204,9 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
>  				       FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT)))
>  		return -EINVAL;
>
> +	if (unlikely(!nr_pages))
> +		return 0;
> +
>  	if (gup_flags & FOLL_PIN)
>  		mm_set_has_pinned_flag(current->mm);
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

