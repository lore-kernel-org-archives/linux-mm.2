Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E87606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRGdLTAs
Received: by kanga.kvack.org (Postfix)
	id 9249A6B05B2; Wed, 18 Nov 2026 04:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBF96B05B3; Wed, 18 Nov 2026 04:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAF66B05B4; Wed, 18 Nov 2026 04:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF776B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:02:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE0D2806AB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:02:51 +0000 (UTC)
X-FDA: 85447649742.27.DCFEB24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 44140140010
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:02:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRGdLTAs;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794992570;
	b=2ydcV4Deto+oR3YXK7NE26g6Tjk+OyyY1y3xebtlXR8zwdoQrnX100IwYE0wtAXkVb7YAt
	GAtDFmwhKsS4kuJjoFQKPXe+mOEdu+9zEs52dUwUOYkWSJ8QXm4ND2NtvU0jhrYCzhbbeB
	Bkv4avEZAdOYD4238xaRifVqCsjD60E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRGdLTAs;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794992570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLn6fncZGa4fgL+fOqpgq5YRYTggYFIcZ3+38mE0Nvc=;
	b=BH9SFdQk02bBgtgVqmXhqrvxs3tJKfby0AzQqhblL3FJK+ZS7Hde0YAFx3+u7wswhEAOWQ
	bB0ZhQrh6ZweivHdsmL/3AoUDEe3ECUYnfdY5NA0jeHtop4J+sNvpFEv9iNqkcjVZarjdF
	6j7lpyl7xMnOVMqOj12hrbDQuYW5O3M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4275D437D9;
	Wed, 18 Nov 2026 09:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA511F000C5;
	Wed, 18 Nov 2026 09:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992569;
	bh=pLn6fncZGa4fgL+fOqpgq5YRYTggYFIcZ3+38mE0Nvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JRGdLTAsXBvvBhLBMNip+PBzFeCWDHNGjtE/29dINX+9MVgmhVBLES9E+pEgXct03
	 EaY9TvK82FuPptmwjz5VrUCPSr+2JAdhpavzvKdMddAWW3XiiJkmTW4yxfYTFqrE4s
	 llB+3lnJvZm6LHLGcjo+pQ0tetlRwHocyPblj+j3nThU/CjmJ/zmDUfGDxnCMo2R16
	 ByEQjpAM4b4jvbfCpeb7+b9bdmuTsTgxEbGSutaNgNz+SAjG9Bc4/NiSb5P9tlV7Yc
	 vqjdaNvm0Bg16bzvsTMwBHAw2pVe6rUiiZpVj+Fd4v4PtQuJ8Jwy7v5d+MplCUwp5P
	 Py3LGm7/SaKLw==
Date: Wed, 18 Nov 2026 10:02:36 +0100
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
	stable@kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH v2 06/15] mm/hugetlb: fix mremap() racing with page
 migration
Message-ID: <av1prAuFVxsdBsIP@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 44140140010
X-Stat-Signature: e8i1e1h8uc4rjoo81u7ncrf6hbhrcgds
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794992570-616243
X-HE-Meta: U2FsdGVkX1+EUQgB6d1qFT9nvx4/yzsh1Jv7eOPYIewMzj6Y3/vhQb8Ykgd3trWwkwaIqg0U/S7cFeopzalPHudojI0HsMxKjenTHzJb3y95m6F8LV9wFRtQ8zHTTxOxOfAsIxbjEsDrH7St7pKaESwj2KoWtMxAejMfE/0SGIsAYVjC6QgpuFSauicv/TbFDaHZwSWasMjv6IiYoxifgqbUrzpBJHjfChE3Xt8K9ml6QfsgELzeYzJOE6R2uLKaSBdJZL0aNh3dQqh0ZuERldECuVPDn4x0DqNyF7p82IJ1paz/geGetDhvx7Jubv3p4ThAf/VSjYJet8iW9OpPbl0UGN/FiUJzk9qMik+itxS9XPWLK8m/w7gIRgVSUCnUqpLT/YqVWXF1BqJyIzPQWmL9YQ0OvRTMvW9u6DfS5COE0Q6hGiMyD1PM1KNNQpnmmNWhsrXD0Koah5nBd+ngbGJp1RFzzdR8TNvtpJxVEuYwSfIILJ0Xg+i3T77lSIJnA7PElOn7c/yemuKT5mFTIH9Wgnmi+10Q54qDLQG+nk1DNZ3aNpyC4cMcd0pQfWWAVZo0bWuqrfbgYrBI5l7/DlZVnSW/7Bt7BDKymG6E5CUCVAZdjWhiWbaaOh/KhJ7k1EWOGWrAkLhq6WRl/opcwSKFjH+SkXb0VhHLBuf+GaGollP8yVWxi0F8tlAGUb4IZKYSe66bVByl/kLJ+qjlz3qcgqBS1LK0q68HSd2EBT56xNLXW5XsKL0YBRtGf06gRPGyQ+LVlW8hyAbvRV4CuKgAvivzvKzRG8uyhslYOpk4AEtE3JmDjNn+U4pXJUuxJQKU5GR0j5o5Gc9K8ak77npc3o0boi1qoYBHNT1APq4Sg6MFQcEpePR8pOOJcr/WSkYOibva83LlGl+JYy7KpEDlGQJNbB4ntJm6WMfVd0lBmzJeCUe37GHRFl2LqBaEVEc87fu4vje5MI1rSBo
 Q5SYk/Cl
 kHf+s088S2JpKAYYwtvSMOpXGQJUYvdajEO5l4tpMjQezJPbf22vpC0mNotNBVehEYbBr/5II5EBJL0LW/YQ+k3bL3TjigW4jd+lun9hFrTVfn4AGiU6sJ1pgGm9PZFbVuavTG8Yr6Jhio1Rvlfko6KEN2nx/qU5gq6/DcuqzJlmnm8ukbcp4ou6N9sgjUrzeOjmROMcSl2OV36F3xdiGoRwfpsuguOcd8+3EzuaCcrltm35vnNjrKoRJr9qo61qKdAQc5ZS4B/Iq7LuVzHH52yyOuzpoMZw5nHLXD94tDR2gZx/6039oy2/G3ekvxhGR+MqiYGEYRgBc8ggBuopGhBBp0rsLPenESJDt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:27PM +0100, David Hildenbrand (Arm) wrote:
> Migration of anon hugetlb folios walks the anon_vma, so the file's
> i_mmap_rwsem does not serialize it against move_hugetlb_page_tables().
> 
> There are various issues with that. Most importantly, move_huge_pte()
> releases both page table locks before the TLB is flushed. Migration can
> then find the destination entry and finish migration, reusing the old
> folio while the TLB still has entries cached.
> 
> Hold the anon_vma write lock across the move and the final TLB flush.
> This also prevents concurrent rmap walks from missing entries moved
> during rollback.
> 
> When we must allocate a destination page table, flush the TLB before
> dropping the anon_vma lock, then reacquire it after allocation.
> 
> Dropping the lock only works around lockdep: hugetlb folios are not
> reclaimed or migrated by allocation compaction, but their anon_vmas
> share the lock class used by ordinary anonymous memory. Having a
> separate lock class for hugetlb's anon_vma (like already done for
> i_mmap_rwsem via hugetlbfs_i_mmap_rwsem_key) requires more thought.
> 
> There is a concern that this can block page migration of anonymous
> folios quite a while ... which is not really different to what happens
> to page-cache folios today. If ever a problem, we can temporarily
> release the lock.
> 
> So let's keep it simple for now.
> 
> It is a shame that hugetlb has to implement everything core-mm implements
> in a different way that just screams for problems.
> 
> Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
> Cc: stable@kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

