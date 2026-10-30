Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3323B606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bck9LEQ0
Received: by kanga.kvack.org (Postfix)
	id E3CF26B00EF; Thu, 29 Oct 2026 20:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE356B05B1; Thu, 29 Oct 2026 20:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB55A6B05B2; Thu, 29 Oct 2026 20:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3CC6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:57:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D8B51C3D2B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:57:38 +0000 (UTC)
X-FDA: 85377479796.29.3A32CFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 81A151C0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:57:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bck9LEQ0;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793321856;
	b=ZVc95OPmGph/546Qm61RFEbdMjIlM++5cDPLAR9dFBYC18VAguURvwefB1ipOy6PJhBgS4
	FlBxzVshW0FJYWu4K2otFijOyU+wmMwmD7w11X5siNbzO3AO4AxSdzmKkk3106idZ6R1ck
	NCS4z9eT+dwd3SfF/9RUNEyw+mMQRLU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bck9LEQ0;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793321856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6bpDqyFL1t6pXSfv5Po8tZyxphIeTUYr2/GTeN0+Ow=;
	b=GHRqSO9Tc6M8mhXyD5Q31KxpttSk7V6NQ66RrllxrPpwE8JSjtVYhOPbWaVvdfg6hZYC7c
	ncKbNCfNByzapYH+43e7FF8xCvHPvV2Zn7CuC+qjAZuCttCa6GYPAHZtSsWvtHISYyn2L9
	Zm2UcI+ko8pH4x0qCY9AEq2Cibrd9NY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9CEE60267;
	Fri, 30 Oct 2026 00:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5070C1F000C1;
	Fri, 30 Oct 2026 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793321855;
	bh=M6bpDqyFL1t6pXSfv5Po8tZyxphIeTUYr2/GTeN0+Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bck9LEQ0UPt4LikhQsWdEDa6SKxVHXgeqY8QxTgswXVFtiDdPukVSUu4n9MbVtYs5
	 9bJB0UhYlqNoSAncXFJ2j1+NWPJNqcsDIAUWHsMxFaaWRhN5euG3twTUKMEQOkhMHq
	 kCqRFz7lMFFHp8ifCqslKWbUlluFBnrNX2Gsx1QQZJ1my3+Qiqa83Vi4wtVn+wWcXY
	 yr12zqlMfd4YaoyLMi/eCnYBn6ROMiu9tbRatmj2MhIT5+dvt+dbydBKyR+FVLJc9O
	 dqXK/TupCXUvbOJG5GZZZVlCKD/5zJ1rV6kAoCfn2B0Pn4nRrmkZIvQ909w4V4Nmjy
	 P8zEJJwppvlEQ==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 27/47] mm/mmu_gather: fix flushing ranges with 4 GiB or larger
Date: Thu, 29 Oct 2026 17:57:25 -0700
Message-ID: <20261030005726.155279-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029-fixes_core-v2-27-a64ce7f83abb@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 81A151C0004
X-Stat-Signature: r316s1ht49g3ebk9xu1cspjd9i6uhzxr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793321856-807333
X-HE-Meta: U2FsdGVkX18oq9VAWY/fqGE3GYThU1W3CPU+OOlfXS5bAfwhvnj3SwX9uhgqpaIVGU2z/sDci7z/NsDkDnL/tVx/3dHu74JFlX6sa0C46/3+t5siFujfZzU7WFTfjgYeQ9GEaEDeMn2WBoaFW1iqttwBs/fxAsijbIDq6wkqX87J9iw5M0xyvJzLEutzC/Opg6h3gMuc/qpCdmVBU+FWRvO60Wq5BPw3sOFSY/pjv/TtqBuM0gkjrtS326xZtVfpZiiQOEePYzDoHDR1EXKCkqAzZiGQnhvSciRKaDHUW/rt22HNbERa6OJTdKN6YiE2kthRxGRtIyZKiKfsuA5CWzTn0AYiQb4g9ZQvGX3uPoPpWwBRHCHnO9fF0eP70CfpnefLTJuK4kzZ6Hh1bUsJx/P2uNtZvhWSBRiLmG9mj8vQPocq8GCT/U2i5lQURhS7yQu3lI+z6xucyVYjuCNOZyXtLucvqszdbQm+uFxwtyghU6qwznG5DJafgbI6W3wa1/yaJtci/6UludCXlDHTkqZ9l2lNjD9y4JiqwToCmSqcADNNnxSDLdct7Fya4s/dbp0shnUS6vwtViEmuq8o5I5M4nF4tatnJtY43VdT0e10tM964FdylLuTZLc0qWeoQ+bXs+FyL8vg5T7RtKKk7RxQJlHWWMl1Un+rEzPLmACF9MG9UE2MKoi8FFkKG5cj/KSYg/M+5wS8uJuM9ZThjDQgiO+q6QPOosSsNee88weF840ZLTfSUAvplaeG4XjU6p7J2+GMpjlV01IWLoHqU+8eiF220RZSG33WpnTQ9pryJ9piYmYrWhnG9D4qJkzb9Bvm4XFfqh3lgsk1D/qqizd2wYkduvnKNl8v0qPZehurB7AEeRasQ2Wq9jk9g2FGRFcKG1sTRuHynKn7TBhAqwsMoutlK5FrcM9mF4El5nj8VA4ZjdOoeCs9j14wX4RBtMlrexV8ROPMYaNxqz+
 yoe4quIS
 BYhievuU3r1ayrE7XmuPxj+6ZTg9cNFOjjQCLN7kf4voCC0P8J6f5LcHe6s3YsFq7ZzM0yyKjYZqhoJ/HberNQYqMKyQXSWVY8WycZWQ0eB084gNqzXZqi0UGdqrfCThGaZXwV2BFAIYm7GiRAvLXq2Bx9pwG6uaDSLbZjxTU3EpF7vExM1lkAKOqOyS+42UlVjrngrTyZ02J71Orau86MND9QQW6AHciEcjtrDJF8CZM+u/OaG1cGRudisO6Nq3oFgJTI1KNCdLF0KNBbtlrDgPm5HGlSRUxaHQ+sRzoWq6Gz/ZwBY40DCONFrUzYNHpYiChVXFYqOTt7LwXgneAE40gfAxniQ/9Tnnr/L2T6gYQNc7QY21wKFAmg2aKKFp7azPOT2Wqhr8PYZlceuEsZtyUMXjmh8eQPsrh3zZyX8bqdMM3uDIAMkyIQCLUeKBDu0e1OfAdDrFTeLSc5XKB+9G2kQH9HyKmuEZ6x3q/22V+4T7lHRi7dMreaDO8o1iEGL7sxgRgqLs34iOoEehqFNK4IGC+UYHYHHcdkP6W1giALlDaz7/OHAYr8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 21:33:22 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> From: Josef Bacik <josef@toxicpanda.com>
> 
> __tlb_adjust_range() takes the size of the range which has to be flushed
> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
> and pass an unsigned long. Consequently, a range that is 4 GiB or larger
> gets truncated, possibly to 0.
> 
> On arm64 with hugetlb, a 64k kernel can have 16 GiB hugetlb folios
> mapped contiguously at the PMD level and flush them when unmapping, and a
> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
> at least these two scenarios are affected.
> 
> Fix it by flushing the proper range instead of the truncated one by
> properly using "unsigned long" for range_size.

Makes sense to me.

> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: use two-tab indent, simplify description ]

It seems the convention [1] is to put the above modification note right before
the last S-o-b: of David.  Maybe you forgot moving it after adding R-b: and
T-b: from great reviewers?

> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>

[1] https://docs.kernel.org/maintainer/modifying-patches.html


Thanks,
SJ

[...]

