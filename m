Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5A2606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tK8FPKJ7
Received: by kanga.kvack.org (Postfix)
	id 7792C6B05B1; Wed, 28 Oct 2026 04:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751886B05B2; Wed, 28 Oct 2026 04:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640056B05BC; Wed, 28 Oct 2026 04:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7836B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:26:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7584A89E0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:26:25 +0000 (UTC)
X-FDA: 85371353130.19.310FA40
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id E40A9180008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:26:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tK8FPKJ7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqxvUOYEnw6epSxNJkOsH/iPXoP3tG6fnt6qx+16CDI=;
	b=iNT+lv0hPK2d+FD6d+o5gSxeC/qXy1xXR1G99DyOCaYcM4QgwFg1V/gBw7iT7Ljc3wmkyQ
	RmXsSXiLzcvq1PQa8Eeysecui5ib8tdZG5+AAbLiETX99KqtUusGN1jfTcQGMfksV5zPub
	299Pai5aBJZPCEAr1kK+OSF9LUnoOQ8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tK8FPKJ7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175984;
	b=WG6Z49bjC6hoI+UQ7CuFc5MZNomCWWze3MAe2H7ht0P5VRnF9IWtfTKxGdCkYcWbhkvTSN
	SpZTkHXaMewYHPZoMZfaJy3mnMkVcN3X31Ea5hh6F3YmcaoC/DnrBWUTNAhS+IeyvEjNTT
	gVGY7ykUo4xzQSeBqp1uDunXqCIvfnQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6ECF2175D;
	Wed, 28 Oct 2026 01:26:19 -0700 (PDT)
Received: from [10.163.164.200] (unknown [10.163.164.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FA7C3F7B4;
	Wed, 28 Oct 2026 01:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793175982; bh=/EbjTDVkdW0F57Y0gRKQi9v+oLhQOt+D3xEeKM70nII=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tK8FPKJ775LMj/HKo8mObMmx6qKh5HiYiCirC0X5N+Uj94ZXLcgBO0gJmsuhWRb4A
	 Le1KG8SJsaJkW/YAWbL9G7bsI6/KPkhwkETh7gUgwJbaEDX8Eg/t78/F2JU1nNSeDl
	 jDJpfCYMNVh0lVMDuVYpKwlU4CCZEtAy7DaSDSSM=
Message-ID: <50f426ea-7477-4fb4-a520-0d7fe4b84c37@arm.com>
Date: Wed, 28 Oct 2026 13:55:59 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/46] mm/huge_memory: fix zapping migration entries for
 device-private THPs
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-14-6f74bec9a5bb@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261027-fixes_core-v1-14-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E40A9180008
X-Stat-Signature: ka3ojkh8eoaf1ziinnhg3hasbwyr6hqg
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793175983-175384
X-HE-Meta: U2FsdGVkX18BgvyvXWfhdt3lpEMq2aOL+CIxPxwvPMnFP9i2pjNgHT5h0pn/jZ++8gJWVRn8ynMN3RbpCzE2R5KPQCBjdQZ5xm7CoKMP4aGhvX0e8OAaVMH2Z198JAYrM3T8rx0YFDKGwCRPG1QUm/Rgo+9C3ysVG7viufwrjK/qp+iK+F2Hr/Qh2Qvl7ld/k673Bi1dpmWF56tPM9ookbH4ZXXTRB1ub+d+rFhAmWjuHMSt6IqO5xjQEMYtVXsbjG3KlXzyju5ryW+d9vzwJBaoekt2uXvHUuY0+gerB+Aiw2TY5//kFeej6+uigvNm90KbpU4LFHnLHEkWvhZaX8PGCvbBbBx3TWWMwhUXOlWWtVr8rkPslCGSaGIi8azoXlORNLt1jpc5YEFKmHiUzS21YL5bQFrxLXun57dOiyAzvxETAjovBLIoXUAbN+NhC3wgSueL4M/ZfeCAjkzfl5QGqKQmVmyvm8R0AY56neApTC72Z8jES2Q3mApaC+tPTeMUPsFiAV13BgHkW7HhDf9/I7wutN+GDDv5tppbPak+C+WbeL22o89iLL27V0JEPkcmJeOIZk5mNdW+GrrzRaJ2ld8k20R4xno0r5QB2jc+Tp6z+Mng2SKLYV6mdOnd4k5NVgvZlPm+xOa6Jr7QWvtSv/eKqIOOw9MJPFLUl7gYjq+bnyayXOUNRIp4JMsHK3bMo9n0YBnaj9nKXHwOfwSP+g5mkEb0k9Ap6ee4gSXTu0WZJQCBGxueKexozszMjPzv5RSwFeURlpndNtgKT28BkV3EenfqgeHLZeQrKmUgg7M43Wv2Zx40kR1Ja7+mkM2Gtye25ZQY0JWhoQPP1u3ipI5TGIv6lyBNWxJUUEPHmIKhBwlaOW5iIhNNFj3OgiPy3l5LK38T3nNBY9tgKyuObPwf6CrFIiq2NedWCBnhf40rkTO/CKoXk0o0VYig5j1t/cVMQ7e5PPE7tla
 s+B+vXbX
 t38/A2XafznCzut6XQti6ioD+6WQAhSSS0V5nT9uK5gaMcB3/+F5bMJFkmeV8EIalvkcpx1nNxotzrcy3zTpFSHFPv8fUnR5USZtyLKdPaZKKd1vyuFHyHF2Kc2+tcD4X3yQG1ip/yjveTajO4cmo3pWHgdFh1NwjaTiiHmBTNfKhlhnkqlSicuyFznZ4Aohcz+G6rwyxT54iXpPgpifKxSt7u8EeR0Z8dlPRkT5l/inxK7O5obzUvQbs2e0/F2r2TXiJvjZDo8VMl1udKyRpvhHvjwkhGH/R1zZy52LePWKt8+Ke4dx+BYKjlvLkhAxrefZPT9LmRd1cilk0DAXq968MbanlfkM2+Xm7iT/QmFwmh1pWkYYb1PdrKwDTwDNqnmaXd8/GEZhqOyQX0K1RZ2Wvl/I9MAwbDCCnXBSf19ZQyBqjMzJdxBr/Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 27/10/26 4:47 am, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A PMD migration entry can refer to a device-private folio.
> zap_huge_pmd_folio() checks the folio type instead of the entry type,
> so it treats such a migration entry as a device-private entry.
> 
> Installing the migration entry already removed the reverse mapping and
> dropped the mapping reference. Zapping it must not repeat those
> operations. Concurrent MADV_DONTNEED during migration back to system
> memory can trigger this.
> 
> Check the PMD entry type using pmd_is_device_private_entry().
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Matches zap_nonpresent_ptes.

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index eda020dd6e33f..1b50cc2b35351 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2493,7 +2493,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>  static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>  		pmd_t pmdval, struct folio *folio, bool is_present)
>  {
> -	const bool is_device_private = folio_is_device_private(folio);
> +	const bool is_device_private = !is_present && pmd_is_device_private_entry(pmdval);
>  
>  	/* Transfer young+dirty while the folio is still mapped. */
>  	if (is_present && !folio_test_anon(folio)) {
> 


