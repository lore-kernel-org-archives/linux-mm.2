Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B10CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 17:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600AD8E002E; Sat,  8 Nov 2025 12:18:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B40C8E0003; Sat,  8 Nov 2025 12:18:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477F78E002E; Sat,  8 Nov 2025 12:18:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2DAD68E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 12:18:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C79B012CF98
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:18:20 +0000 (UTC)
X-FDA: 84088098360.21.FC08393
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 36DFA4000D
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:18:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pXLXLja8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762622299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1ox1tcE76ocNBNQ+mqc5W1J16kccLa0tGni3/pfhvE=;
	b=Nf/shY/dESLgnIzxgSMdE5eYjgzjioUnT71nfPyYyS1KAyDmXaXafniUzvDHGNT0XLIOp3
	6Ny5m03dMESAKPagb4gTco1SJooPDoSiF2pO3OTk0uQaenQYOUcRqs16eTkubmqQS1zyUR
	1SXj83aZc95959C2C4pciVgMs+w+XLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762622299; a=rsa-sha256;
	cv=none;
	b=yYwRMbIKcQSk9VXRLQUx1TIqft2aB4R7puAe67M8GDpi27q+OTo5Dz7dr3L91N16EIPcvK
	VwhJTT/zApxIKHjDXBJqnLHaCsL//QjLfSf3YYZg/wkCRO9018qlW+hz/LeIeh5isFVMF7
	UwZA6lsjS8/37fJ8N/hhUt/nzzI8QEg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pXLXLja8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE8EA40463;
	Sat,  8 Nov 2025 17:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D797C4CEF5;
	Sat,  8 Nov 2025 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762622297;
	bh=pESYDLXfcVD/iJn0c7wNfoZTyYhd+yM9sA3cQbI6Gww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXLXLja8D++3i+AfHiCU6NWWnKCTqEseSjb6R01Wd2qFTmLAUkW07+K3qAkLAB/iO
	 58twgr3qbPV7bJw2Xlx8je9ohYkBOStMy56jhmQ9FOSppxGZWilCo/StGKN5tm0P61
	 b1KRhblheTCEPQheRpoPPNKS+0o7Bp0uMRP+JxSsg6XvaByUie79tO9Vq/JnxBAmGN
	 bRE3xmzZzdcNNdy2RVe2gI/se+/RKNc4bbk9TorBN9r5WaJCOkqffGrFhlZRQNVbLe
	 KQYfPymH7R+7yeKssxlH529Od2FBgCcEzgK73afUL4OeUfCq0h8ZUMuFtRudOFqqWU
	 nQWLuajG/ch7w==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Chris Li <chrisl@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH v2 10/16] mm: replace pmd_to_swp_entry() with softleaf_from_pmd()
Date: Sat,  8 Nov 2025 09:18:08 -0800
Message-ID: <20251108171808.77373-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <093e438c240272d081548222900a5c3b205e9a5d.1762621568.git.lorenzo.stoakes@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7f8y9539czsp34zwt7dgw7tjggaaoynh
X-Rspam-User: 
X-Rspamd-Queue-Id: 36DFA4000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1762622298-400498
X-HE-Meta: U2FsdGVkX1/DGfpd84vJJB5hRFCq/gdJB9JwJHGxQwyrrho240J4Eh52VxbY8ez5XUwvA4bzfT1rgFKtGS79vjXUq6gXA/hSHmb9v8aaBS2qfcRgzfjymv9b5djoI09ouc+yJQ0EzRbm7SOtn66vDdVlJlhLVYrGzGTMYuQju7oqmPygtcyQHRlYuZXIXbvbb394NLyxUFK85Rp4dxZxslDP0Swwnw1aIup3eNP+GBga5Xv2wyffR8c7Oo/rZs03snXGuKjsaI8X89Xt/k+/9xyLeX3evqBbocVMeAzAyZvuqfmbT0T946XxsHi9OnRVVm27x6ju2aPol+HSQtEUn2q9NlK1+VQKRL1kFVcm3uGF4pudEyzphReG6vHlEH4qvR133atS0wn5WPyjR2+3BS1ZzcZANm0K96FPRXfaKyAi562QguyrDPkR5VBl2ww8EZtFxreIpzGDtgWZkfsKoKM16fBul5wwI+x+0gIZTzGDPGIEk2VK5IL75xcwoxqzYIBHJltMEueetGoSvr5DSS8Dg8z2ULIe0LCABswSOKPpKt3zDX03iNWR789F4HxydYCVeDpyPbKh+iFwaNuISwxyofGoCM9yF9TYDArnCMeRIwhpJyEs9VLZ1g32faTijrts3AmOLtOAjzQ2UuYY9I6TQqLXDWQoyk0RJ4nuefOMN02c/ZT4KqiXsO+aG2FqVqFrj7kY7NIY/kl1zzmcwV6haq5HRnsVvzPO6shN6iI7juHSSfbq20xMVvonkDQZsxkV+zxseUOYFx2psAUv6pkU4UgX6s+MIqoDBKDgR1RGpFcmGuZ7jLSiC5BsgHgg1+38OCh0y8aJkYdYO21od/F/29nFglNrcLEr2HS4BYpMf2vxiSNVMmv9Pox9eTYOq5PTXlQLEqNFKmhZvS55Usy5ayCLPse36GWe95UFR9lGrstvC6YLDKZcfSV3nz0pdKAaqMANWtbb4Gtql7/
 lIWJT/IW
 TyGmC0iSkCoCZmCCbh+umdmYx1+UvoPXGe2ohfxRCQ7bBH+sB+gbJdLr4M8vqkgKXFcpzr1JkJXXU0YqIJDso+rtlsB6qXgFaR0YPimIIGoiBWf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  8 Nov 2025 17:08:24 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Introduce softleaf_from_pmd() to do the equivalent operation for PMDs that
> softleaf_from_pte() fulfils, and cascade changes through code base
> accordingly, introducing helpers as necessary.
> 
> We are then able to eliminate pmd_to_swp_entry(), is_pmd_migration_entry(),
> is_pmd_device_private_entry() and is_pmd_non_present_folio_entry().
> 
> This further establishes the use of leaf operations throughout the code
> base and further establishes the foundations for eliminating is_swap_pmd().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  fs/proc/task_mmu.c      |  27 +++--
>  include/linux/leafops.h | 220 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/migrate.h |   2 +-
>  include/linux/swapops.h | 100 ------------------
>  mm/damon/ops-common.c   |   6 +-
>  mm/filemap.c            |   6 +-
>  mm/hmm.c                |  16 +--
>  mm/huge_memory.c        |  98 +++++++++---------
>  mm/khugepaged.c         |   4 +-
>  mm/madvise.c            |   2 +-
>  mm/memory.c             |   4 +-
>  mm/mempolicy.c          |   4 +-
>  mm/migrate.c            |  20 ++--
>  mm/migrate_device.c     |  14 +--
>  mm/page_table_check.c   |  16 +--
>  mm/page_vma_mapped.c    |  15 +--
>  mm/pagewalk.c           |   8 +-
>  mm/rmap.c               |   4 +-
>  18 files changed, 343 insertions(+), 223 deletions(-)
[...]

> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 971df8a16ba4..a218d9922234 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -11,7 +11,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
> -#include <linux/swapops.h>
> +#include <linux/leafops.h>
>  
>  #include "../internal.h"
>  #include "ops-common.h"
> @@ -51,7 +51,7 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
>  	if (likely(pte_present(pteval)))
>  		pfn = pte_pfn(pteval);
>  	else
> -		pfn = swp_offset_pfn(pte_to_swp_entry(pteval));
> +		pfn = softleaf_to_pfn(softleaf_from_pte(pteval));
>  
>  	folio = damon_get_folio(pfn);
>  	if (!folio)
> @@ -83,7 +83,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
>  	if (likely(pmd_present(pmdval)))
>  		pfn = pmd_pfn(pmdval);
>  	else
> -		pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
> +		pfn = softleaf_to_pfn(softleaf_from_pmd(pmdval));
>  
>  	folio = damon_get_folio(pfn);
>  	if (!folio)

I'll try to take a time to review the whole series.  But, for now, for this
DAMON part change,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

