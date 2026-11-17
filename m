Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6031A606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UygshCHv
Received: by kanga.kvack.org (Postfix)
	id 593366B05B1; Tue, 17 Nov 2026 05:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AC96B05B7; Tue, 17 Nov 2026 05:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8CD6B05BA; Tue, 17 Nov 2026 05:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 259846B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:16:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98517140380
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:16:24 +0000 (UTC)
X-FDA: 85444206288.08.DAAB424
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 070B7140004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:16:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UygshCHv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDYqn2zYmU/muKMWOwZRP/lmMgVBMmIpWntga6OkdHs=;
	b=Cac8VrhrnMrmT5S+QbdIT7MoPd0KOkZPamZpR7vmFML2s7qzdMW+Hp7Cxs9beTbv0oGn9+
	dd/w+lzy5qrnydSgrxiVtHO+vv2Uz2+ua9erC8J8Ht1DXdmePsZfwf+TG6hwCJL8vuM+8g
	PKCpq1OCcBalkTuXXR7qS0asn1AlFVs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UygshCHv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910583;
	b=d307jcYtbByG7MMjBnO6yte/Z0NUhIgemxpcNzFjgL0WO9s/GpnEP2LAEXbU3GSGA+wSZT
	H9O++y8aGUM8eMmcjkoXoPKJBZN7NF6VFK42fAS0JeIdBQ324hQY5w12dDBQkn8ubK/wAR
	uq6Lbr0GLyUep/gkaEN22LHtSuBuEZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 831246299F;
	Tue, 17 Nov 2026 10:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127881F000C5;
	Tue, 17 Nov 2026 10:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794910582;
	bh=xDYqn2zYmU/muKMWOwZRP/lmMgVBMmIpWntga6OkdHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UygshCHvYb0JI//oaXBOMwL1fJNJ9pPVP3LkGVS6bdBeM3Ve4cREnUxtcv8LLAZ/x
	 VcfcP1mmfCSfntA006QaldiGHIPKUNFKnXCV1y49BwMQo8/w7KmjuejXJutyY5EXWX
	 6tUFM8+8yK8/9stnEWJd9NSxT4S5m35e2WQEik+YhBMiRu3WDYvS2g9v+PYDcVtJhu
	 2C/srRWnTKNb/XrYpcWmevDcAdkhKHhhb9rETxv4dtlUJRHDLanZcejBB6YsQFZA9P
	 wOQzsVP4YB0lsu7IQkIUUbb5PPSOpAyJCS2FZm2ZeYUOUegy9TWNZhnBfrBhqaFGkD
	 vFVdMFSP7HmlA==
Date: Tue, 17 Nov 2026 11:16:10 +0100
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
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	stable@kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 04/15] mm/hugetlb: account temporary folios separately
Message-ID: <avwpak13vu83aL9U@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
X-Rspamd-Queue-Id: 070B7140004
X-Rspam-User: 
X-Stat-Signature: 53e8qhy9p865pjqfnxjo85mbsykjh4ro
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794910582-482201
X-HE-Meta: U2FsdGVkX1+CVqL5t4RsS5skGy11TbnNcccfREVN0MCdtwRvFdhKR8GCXYnmVwJLqy3YWlG8ukA9tcZ7rT2mJWikHzZVmPH8TCmqIySPnKLs/+ah4gHrv4srHZ9i8k9gjk+TYd7KDQL7drO7pVUGEjA2w/4CCmnPCf2JZT7RiTyrXCJ1b0M5X40kGOMJpLMyEJ0xW0oWzlpNFj8LwSKYWMZ1C45tJcjoEWUL5aMaqbP2ylG9iZhea/BTQmpsiFTsraJTb5lRHSA/UomNx4siiQ6QqLVoaj1Gyuu3vpmRMAd8v0C6zqOTqcsYDBM7f+vhxnhTKEYkf94r9j5R3IyyxoVXk8rFivz6TkKLrD4098N2lzpaGuhFvtqHJ0SD0NwGI6YfeMR/ZjLGQ5LgRxdAPc5CIKqNAcOROOLYJl0SeVM9Rk0/zgG82U5Ldj0RJREhG3VEfHplHiLSCqe6RHkV25orlaOUMG9pCegLtoiYIT11W5LiVi+c4Zr8Doe+fy3o099035g/tdUnxRaHxM771gwnjU3xNNaH3dFyQBw6+nTtN397PcwbgpGaggC3L83q7YMpm7VtNVSJ34VirWY0EoAgSkDMAFP71B9lrYamlXyo6f1UiSGIx8zLp7bUSWoeNvXcbKgaiEBMNiQBQdsdxzr4XCeCEL57gSOJo6LetlfGskJy02itcSARfzuTgCSPcx6CWbnkDQf6NpS+LARv274YFCqx2b7IPkmAD07/hqu1Ljhpz7va5vfdeSJA01IZ8McRYbpAKBsJbYolKVBLDhtYgYzzxehRhHxke57x8CBdRD/AKwSgttQ3bBhV/+iC8nsUw/FqcFWQYVQNruYgZ63lDpPxNdo7q4zgFc7wo1pOgPrR974t/Tct5j4BAUGjwCbT7VRwMKp92M9bZmPKCu1EpAeMmOcuM8yBXAd5TsF31+lxs2NL9Fu7jV7IbkLAiLTRL1CPVL5rRf+pEZ0
 l27y1mDh
 aK0IZk0lFsFqHTFevpjv6o5/bN3zHjuduueEg6ANrszQ5HT+fCpzMVSsarEL0+0cnPOqs9okDVil1ESSnHE14PnXcxP7J+yjiyGKmvNxI13o/PlCEMMpOuDA81J/2QgC02VXZUT84mfjriq6iOVhHBp2qBYVI/joq9eoqirpODE43hKFIVlzAfarz/a7oRpYMyNu0LAtPZYF1eoYF7kk3ol+1WpFghynOQK4wWMayqGuBx3OEJZDEER88O14oIBS3Er3eF40dmUA60n+vWmx9XeBZ+S1k02WgRfUfDyl14F6V0W6Vt9seYnRAVbj433/bX1jNDGbhFCls/yG7DebcGNLve2Cbh5A20Ki8VKE4zxzn3ovO1hki2TtXrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:25PM +0100, David Hildenbrand (Arm) wrote:
> Hugetlb migration might have to allocate a temporary folio through
> alloc_migrate_hugetlb_folio(). Such folios are currently accounted in
> "nr_huge_pages" but not in "surplus_huge_pages". persistent_huge_pages()
> can mistake them as persistent huge pages, as it merely calculates the
> difference.
> 
> If set_max_huge_pages() shrinks the pool at the wrong time, it will turn
> hugetlb folios into surplus folios until persistent_huge_pages() returns
> the desired number.
> 
> After the migration (successful or unsuccessful) either the new (temporary)
> folio or the old folio gets freed: this will reduce "nr_huge_pages" but
> not "surplus_huge_pages", to undo what was done when allocating a
> temporary folio.
> 
> This can result in having more surplus folios than actually allocated
> folios:
> 
>   HugePages_Total:       0
>   HugePages_Surp:        1
> 
> From then on persistent_huge_pages() returns garbage.
> 
> To fix it, add internal temporary counters and subtract them when
> calculating persistent pool sizes. Update persistent_huge_pages() and add
> persistent_huge_pages_node() to make the code easier to read.
> 
> Count migration targets and rejected surplus allocations as temporary.
> Transfer the per-node temporary count along with the temporary flag on
> migration, such that folio freeing will always do the right thing.
> 
> Take care of calling account_new_hugetlb_folio() only after setting the
> folios to be temporary.
> 
> For now, keep temporary folios in nr_huge_pages, so HugePages_Total and
> Hugetlb continue to include them and overcommit accounting remains
> unchanged. The new temporary counters are internal for now and are not
> exported to userspace.
> 
> Fixes: ab5ac90aecf5 ("mm, hugetlb: do not rely on overcommit limit during migration")
> Cc: stable@kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

