Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAEE606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lCWhJkXx
Received: by kanga.kvack.org (Postfix)
	id 1484A6B05C9; Tue, 17 Nov 2026 05:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120356B05CA; Tue, 17 Nov 2026 05:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037F86B05CB; Tue, 17 Nov 2026 05:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D05486B05C9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:13:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60AF7140377
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:13:22 +0000 (UTC)
X-FDA: 85444198644.13.9774FE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B61391C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:13:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCWhJkXx;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjegpoisEbZi471m0jCHyTug5TPNI/ZEHYUEeklKtvE=;
	b=3adLaWf7E6MK1PCVRQnLMRT7YOVBEL8YYEbRuFjEemFAz38vC4f1vAPhrBFwfc+Pnmp2Aw
	jdt+IL60+k/xLdTssgEG0l5gGe5cuqR97QCFgREWq5j472Miv69mBacyoIRWypZlgHVfzB
	wKG6bU8txtfUdyaReRcJ/4KNGiBKqfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910400;
	b=yrPMzOP5/+2a9blWOcHcJ0Bu12K89jsiPR2YRKdt/Tw+iPd7h+YOwgS8M/BQtxbAfvL4Ju
	wwPKFiZ0S7rMvDvE6cRF0Vly8afSDIGvrgTmkYFKrvab3/gLFeYvpCB8LNKR8F9dVCvOi+
	aSjGkiHWJtcSMF7ww/l8j+L2NbUtoKw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCWhJkXx;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F25642B76;
	Tue, 17 Nov 2026 10:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4161F000C4;
	Tue, 17 Nov 2026 10:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794910399;
	bh=bjegpoisEbZi471m0jCHyTug5TPNI/ZEHYUEeklKtvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lCWhJkXxe0cd+l/aKM456yX2OjBqh13wZLpZEuhQM2jbS+ys2teSairW1BLSqz39H
	 P4f1JlzNK1bP5fmVazLr6E5YpPmsAcCQWyZ+aMjk3YRRoY9x2c1kd2Xy11NmZPQZZ/
	 nBLIKujMVtHAYFMKk4FRiUcSm4e9uJ2iths/rBov6xl3NUUlHEfIktYnFJkS1dsS63
	 HpxgCf6kyYS8Gexowd2VVgg8+fLYPehQU6LUGZLe8sajy32NEX0nTKUuHyLs93tyxk
	 991CZ2XvEZcZiNJbKxs96PsQHM3YRz2jd1+SL1g1rShIJFNzja9UdHZSDWpX+4v+Rj
	 U++7nPWw4FK5g==
Date: Tue, 17 Nov 2026 11:13:07 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 03/15] mm/hugetlb: preserve reservations when
 shrinking on HIGHMEM
Message-ID: <avwos-qF9ADmdHIT@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-3-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-3-4dd9e94ea9ac@kernel.org>
X-Stat-Signature: aouibqp9g8j5z8zwtzksm5oa6oneakcy
X-Rspam-User: 
X-Rspamd-Queue-Id: B61391C0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794910400-272712
X-HE-Meta: U2FsdGVkX1/dadQjDlroy3yAI2rgVcZRrWoQwL1puBFMlSVhRCXukssbve6daaNNKjMwcz4Y6EMVTKia524K5v3n3l2ayQhAxFB9OvfTM9sPpGQmYOPcgc1nxMNOiV6BGoqPayrxGvRi1DDKRoYcndjbcGqofrILeLpFCzFujJ7tnsixJQcbZdk8z9sK9ShJjdKm60xnIwo2G3AicucTeC43dgbw+wMFNBPTVHNFFsfLXsyk+9b3ZxlXNdmnIshwug4Yuiv9eBhrBBin8bJRtqDXESvSYEYS+N+DnY9Ltu1KiMpaOI6Ynu7NgrYFjfJ6KbGYjRBcZeWjORJvoxAcGeYu2XlIQhwJcMJQW4VozNCEa1oOrAgjhA31BZ39t5GW8l6qsM7ezlP60ya44YMocHKVwXBTSORuEYXrFIJ+qIEG+1r2GjCU6HfkIQxYYsY2ci41QYpuqS9df9Z9+OXUjbs33Ew/KTGhqcQjn00URZ4ddmz9gGOw2+U1b6sF9qhVoi7ymJV018ikMun9fNJayfd2fqUjjx55CptXOkmcF7SxHWTOn6HNavNv+N82rA3EGzWa5Wb5O9veM+htm5EvpBF5oNchL2MrpEb5JEqdbRWvBR3+m9Tdk7heWxB2ZYXohqhAM26bAzDfKsZqYavLF7dT9f4pLuLoSatJ1LWGQ9SZgVGtPwqvJd9IryTzrSyc/1GPrC3pFPJy9CzyzioSu+8XSVsFWgtW9XIPNpCs/guV33vHAfNDclYM5fgNUpepWuzBCGUb8HPxTDowg5Yk5JVajoVuLeLNsEFakwBiLEHxt2A/xB2dz3FZhlmrVUPFBzOSS5kKGMTOxf+lcKGoVV7F8sfsJh2YkHOy1lzO3r8U14WsSunS61/dr/MFGoo7gHlvHyzT328bruRPTaKuqws3JUXFb6wb8B5oXGRoAYmcs5Y1g1md6Ne9NCkR8p5MKJZeNjZ/8xSyF86aPY2
 O8WZRrUv
 SSCTwttMKvHQMjk7C9rWuFOZOux35GfEok9BUHgooT82LcZw+Pm+OA/HF6n7pNAkryUa2KFeuRmPU+be9R4WHf1SRMmjMdkupFyb5oU2BTWRRE/dOKCzjvrtT34Ycj998Sv0n+Oek0rJCOoHAllSgtKLsE2TUZee+bQRt6eBqKHd6TUsoWZt8oY5FzAXL6nUiIE4jcFXUQYuCZ6FKmZU97M9pEtVgyVR5bf/CSOffHJUudlpnNvSUh0W0/7szWfgLKbRqZpfsZ9ZwCThwm1joa2+91qmlxlNgo+obNbPXEz400KyIRL4TiTn/sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:24PM +0100, David Hildenbrand (Arm) wrote:
> try_to_free_low() drops the hugetlb_lock while freeing lowmem folios.
> set_max_huge_pages() then resumes freeing folios using the
> min_count computed before that unlock. Reservations created in between
> can consequently lose their backing.
> 
> Collect lowmem folios on the caller's existing page_list instead. Keep
> the hugetlb_lock held through both selection passes, and free the combined
> list at the caller's existing unlock point.
> 
> Likely not stable-worthy.
> 
> Fixes: 1121828a0c21 ("hugetlb: call update_and_free_page without hugetlb_lock")
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

