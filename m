Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BD1606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WIhFuaoR
Received: by kanga.kvack.org (Postfix)
	id 351946B05B2; Wed, 18 Nov 2026 08:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328CE6B05BD; Wed, 18 Nov 2026 08:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2669F6B05BE; Wed, 18 Nov 2026 08:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E46D6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:44:10 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9348DA82DA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:44:09 +0000 (UTC)
X-FDA: 85448358618.20.3BEF368
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0673C40008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:44:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WIhFuaoR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7muLzDvY71Op61wz/dzqvbrdFL+H8lMJhwiD/Ishso=;
	b=cXQppw713a07zhtT2R+kfdRSQSbizhFIdSN5nF3kM1V839HsG4aqp9zAlIrIHYAMH4475Y
	tofM/mJ0FF9qBAIXXAEG0ghOqn15iIBhxu/zhyKjplWqPPaQlmSU1ilTzwZeqfZaGCGnlo
	dI43R3YACYX8pri4lCm98M05Da04Q8Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795009448;
	b=D3NzoqgAW5AO7wRfEMunIQRL6dLPR3zl4S+oHhQnlevYuMFMkr6GhuMHhV4jhbp8EbCbrH
	F/sUf8AcU5FJ9ZXDPKG5u3edSlsBJEKBqempMk9DUd52NHQurLDMG8uUdzBtjM+aHwMUt1
	+JVPvBpl9RHc66ya21wJsp78KUDOSII=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WIhFuaoR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CD996057A;
	Wed, 18 Nov 2026 13:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A001F000C4;
	Wed, 18 Nov 2026 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009447;
	bh=i7muLzDvY71Op61wz/dzqvbrdFL+H8lMJhwiD/Ishso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WIhFuaoR0sVGQ4CGc810tZgfErcle3/jziLI10fXcW2UoIYclG/UxL+Mh0UOq5x5Q
	 Yb7cq0GQYKV1LZv4Qz0S+Yv7Ms+8UyIrjyuy1eInXqTtpYi57PQOVn2F/0DlQit2Bx
	 UGrZ8VrN5+UmI3I7qqiV5gljE+AivMOLxZJzVVYNoPC1viCfumE42QkoHBuqpu+2+X
	 kLhdnBeaizi9RnLUZoDfmf5tW/poinJNe6rkyQzzngyrS8DllVODDpEpXg39DZE1Du
	 PRwv/P3FQtnT5OS3LkSrGgn2L1Y+RH1hPz5IReplZQYVUtzt3KLGTn8kwOlENgWYgi
	 oPysx/jPTL8aQ==
Date: Wed, 18 Nov 2026 15:43:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/7] mm/page_ext: always use vmalloc for section page
 extensions
Message-ID: <av2rneuRc94nGid-@kernel.org>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117120627.50601-4-songmuchun@bytedance.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0673C40008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ddumpjb1qc8g4dos11jrfa88knws1pzz
X-Rspam-User: 
X-HE-Tag: 1795009447-501571
X-HE-Meta: U2FsdGVkX1+XVgUldttubWtQvLxvLSbuScjfjAnI+0o30sAjNhdMUvRD8x+619oLmMi2VBCUTsArIK1JKas2ZPr0RZqk0jdUtBht60QJTL1j8oQ1LfKoVAValNOePpXew5VXAJkxWM4fqlqCMycu57Ion5TdaLEhRnBks56aSTeJZvHmHEwfKs6BRDeW0JHQDn0c4am4GtMNpvsA8VE59ORLU3nxqB/jbum1PEKSrBv8m4K97TVYBhSmRhSK6SvrPp8ALjvgqgeTKbxqrhm1hx8zxFE5jgEMppQnkUZ4sx2WgFd/XuZsld4k8K4dqBT+YuCm8vynYwrS4oKJXqxN565mlWViJ0P1SXQlns/PjzCTvYxqzldGh+6vy6eDStRBxaJsq7Unp1ghihcqHt3VSVoZw9C6pFeS5yL/xvVbK+3Z5//87+I8VE8Tin1TGdGhBo+nDjl+F2FHkcSdY7qTOiSVTN5hqA1Pq+UTGKYYCug0TbGlcwNUZ5+ekVnKHOAQ/5cfzWhBMMDwdQfUg6Kdp1L0xiaUtojFpTTEIAqRdrjMitSnXbzG20NkfD1sgs6Zces+tCg+CqdwebsmInH0rEQbWQmUYwzox5CnYb1IdWiJzB95nkjXaVy8Fiwward8s9WyIC09SUDX1w5LjZbrfmgUo0rtDyMR/lkQMkTD3jc6XgurVaKM+xGl837bPMfzi/ZxraPGNbfd4Z089W1MkiamnSDWEB6Zh7SDEjNr7Oe7dAkbEOOXCcS6MX5sO/kGPGq4NZjtCARdaWhhZQvkxNz9lNc3l+j4arA+UtIbO0WhsC2YqNBt2Fs1fUfdIA68EJBvSV3xHL24fWLouaCwH8gIzanEyxHcqul0BuAkppCumHVD8Wy9S1ZNzUc7h4tdEDqM4Ta9aX1AS3kggepGLn17b7Z2sQeUv+3Ht7XWujbFMDdAfZ5yC6RF2aFkLJaYjDeXk6WI0MiFm1Gb4T9
 JSJnYFu9
 o/MFaNiTzxmT/IPJFz3eXObXtoyYCyL/jDRV8AJ+JKeGQehha5vB/2tIS8oHfnuzGwanVj+B+qCtt6YNk0+xES9huPqXIMrL0IkJQcVPxaO3cPulTWdKhARd9IQS2n1Px+c/3eF+kXR4x2Zg761TafQWXf+lVMq9SqV0rvKAB+dHvkwB5lygG8dAN8SishdQ8iWiPULylDCCQCDDEdr+NrABlcxJQkU567ec0z+pncWrKIie/fulZt84ynqqXXJUAj3GiMG5WuFCllj0pOyd2iWCJBlYR9B8FfB8GHZiZ+n56Ve0b53DomhZf3L24kSVIcAQLgDsEkpNrdrDMWEhtB6JaxLISW3kkMT/G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 08:06:23PM +0800, Muchun Song wrote:
> SPARSEMEM currently tries to allocate each section's page extensions
> from the buddy allocator before falling back to vmalloc.  Boot-time
> section allocation happens after vmalloc is available, and memory
> hotplug allocations do not require physically contiguous backing.
> 
> Use vzalloc_node() directly and remove the buddy-specific allocation,
> free, and kmemleak bookkeeping.  This leaves one runtime backing type
> and lets a later change add memblock as the distinct boot-time path
> to simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - Add a preparatory cleanup that always uses vmalloc for SPARSEMEM
>   section page extensions (suggested by Mike Rapoport)
> ---
>  mm/page_ext.c | 21 +++------------------
>  1 file changed, 3 insertions(+), 18 deletions(-)

-- 
Sincerely yours,
Mike.

