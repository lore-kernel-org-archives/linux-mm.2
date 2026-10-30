Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43394606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OMv7mkSB
Received: by kanga.kvack.org (Postfix)
	id 51FB16B05B4; Thu, 29 Oct 2026 20:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1316B05B5; Thu, 29 Oct 2026 20:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399446B05B6; Thu, 29 Oct 2026 20:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F29726B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:20:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F5DC1C3DF0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:20:16 +0000 (UTC)
X-FDA: 85377385632.19.F0DFF70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1E404000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:20:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMv7mkSB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793319614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUNDzrcBQCofjPtOZhO0zF/6BwtiodHnLN9kfJEdKls=;
	b=3zG9pt66doxivxfl6vglMKotz674xOxYaHrZpVj9K0n96H0V7hdlwxQzpTF5/7L3UlXbKS
	UTqz/uiO80SX1QGvOecGzG4GTOFR9NFHZGeAbTWIhUtqm0ZuGUUQ9nyy+vDFhM8yqoehIr
	VFjfjUQIYxsZfhPznkgs/2GS9dTvMHI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMv7mkSB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793319614;
	b=oLkIknw3flmI4AAkC76dSr1xYWErZ/ZBLPIyYzX/TKl4JcdQimGGo9bYrvPLSjXfSiZ4rC
	NXmfUJpVHeJwKnIpMkG0AhQw4Is56n3GUMDrKHVvF3K497cTMLePf93JKUbr4NgcOSej5u
	pMZ/XpXrSEfOzkZ9hh/shGsNC4cyIlc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7569943923;
	Fri, 30 Oct 2026 00:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E86C1F000C1;
	Fri, 30 Oct 2026 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793319613;
	bh=gUNDzrcBQCofjPtOZhO0zF/6BwtiodHnLN9kfJEdKls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMv7mkSB943eqjxfOdTCTqRn8rnHCaFZTrdaPeB0aIFCob3E3fqLF62qDpAEPjHQA
	 B3xh+10xm0pLuUYynSQpI6Nhgsdy13RCNCEvL/EsGdSb7FWvxPCUQBVJ/KVoki3Q3j
	 A7o8d2rcIlBgQP9lheaOYTIDrvi9q3rsoE+zz/ApHV8bjiyRYYLLaUYBuhT5JdA0R1
	 w7mbCA1lQdx5BakPTjA+ZD87OkbCVKcnrx9v8R9+8bKdOhFqSO1ssMBMBUYRkSn/Kv
	 BpHEmrr7LDOBQR8TBi9SkI1IJdsaRv8CC3SznbrHhfqdDWrNhiMX7QP/0o/p/4lUxU
	 b2bHyvWufwEuQ==
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
	stable@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking PUD and PMD tables
Date: Thu, 29 Oct 2026 17:20:03 -0700
Message-ID: <20261030002004.154595-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029-fixes_core-v2-1-a64ce7f83abb@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1E404000B
X-Stat-Signature: dxxwxffdz9619dnxotkj7m1oy7ushw8u
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793319614-863317
X-HE-Meta: U2FsdGVkX197J2R6wOq/i8PAGKJohuFILH/h3KGsYAXGypWn21NRbhu2QkMGoD1LAAXRY98eiZIetN4niAFql8jagbQqO486Qw8TO0Bh4QykYPUrTC16er6ywQ+hd2RF34gK0Y4ilsgSh9EP+HQLSeq7BezwN6yu/g/yI8aq/nOvOFqj2FhXVP1PbKLZcqVUgmOB+qrJv0QV3oku9R0JkKYJ0Ha8Zv+ET+0tygjyhIkjm8XidcmDtdHPWTMldCvAJUyPxMx+oexYRlkyUUU/S9tcsOsbPB+T8HLdCnOGdFj97+WsPJlEamKLt13jpzIVFPqmCBCqKQgIJtIy/pcGYJziVbf1jAEv/H9A2p87EdLn/SBpvk/QaBANXF6HbBtlinAHa2p9MBuwr3Kew5KvrvfNxab4wDfQ3/vU+42xlLh1CDmlNEK2ArZosCnH4YvPdNisQdHRWmMdWEheIWrmUptTqvRIyQPr13YJ6MZ40BbO/iOM3Aad5UVDDaiBydfhzZwcnAtI2Ade4G1TZU20gf+SpptY26uPtQ21oP+ZTjml06EMTCLCbOJBxob2+Sk2Sr+HO8z5jAt7C/dTJ8Bt4g1iTnAgrxw2uBvd0+ZDf2m46k58fZaz0mC+QwHMppapqYDEnw+ln6F8lB3feMVmB8dZOpJ1812ltT3dn8umU9ndx4kucAOK4x6w/A7iV3QxHXoKa+rQ0d1GBmpxpF/TyL9hFDJg9SJ6F6nqQvmc3jPK4o5VmFBCT8awR8Wp9iPLBb806pY+WziP0XS/bDSoP09j9flDPmtl7/SGCESOR7QEnvfOqT9pQaHknHjXGbPI798t12Qf9JBqBauCv8trfSZOEo3fthXTEgWnUXRvukYNqFL5InMLb0qrsxNTGVrYFbhJqbGF7o00DljoseneD4xPE8bDmugRjTI2mv5MDfByPIng74BnheId4rg5SKpiQTIcj3PwpvPeNaDTJax
 CafQG2BV
 2OMA5XwhwHvsSHIniJVJO3OPAOwWXItD6BOdl0eDCqF6yT6Q1R1Elkxgo0rpsEHfkf/40kCrjZPG+duYB/qHR7cOporZLIj4wqTqjKlhVwkJK7hnoHSwnh03BtYO+dWEWm1pIQ8ctqS0vqvRa6HyuQWay8LQdx6qQ1AUmBPei+4FqHaI8hFeps/jljqKVLtx0Gbc5WRU1wU7WxEMz5f5hs6TPwXOM6mI+9d29xvCXieVYpZZubQUqxbO1V1o8hIwuBkSomvesZ/M7MR/Skdk3qWMKitrQcFRMmSs0RJMYhjTvGpehr6NZMKpSIJbWq7zvPXWvKs4oTvDFo/s29dJysYBqm1hpHqilQ4Vz1sMW721DBe7opRyED5PW2tP+ZSPj8aCqU+Y0TXRkD5kFvgOk4WG3axmZBOg0MuDgoRaEJTsOwLBBMkpd7slYgnsb/ttv+JWoiplCntA0ZO2mE6IoaTN+8EzvVdvdE4KpAilYOCKl7mGOenClKWRhzZPZFsfzZQFXNu1NkCfT7qTFDM/Qv7P5e9Goup/o2iu6agb05H1uXfhNfrP1026Tmf4tgQU/O0eiYp3yi2mEm8ZmFtSxVv2ymSoMlkueeQPDv+pgVvYuroM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
But I can show there are already quite a number of recipients, so I'm just
noting here.

- Brian Geffon <bgeffon@google.com>
- Oleksandr Natalenko <oleksandr@natalenko.name>
- Steven Barrett <steven@liquorix.net>
- Yu Zhao <yuzhao@google.com>

On Thu, 29 Oct 2026 21:32:56 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> From: Josef Bacik <josef@toxicpanda.com>
> 
> MGLRU passes stack copies of page-table entries in walk_pud_range() and
> walk_pmd_range() when walking to the next level. These copies can become
> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
> table concurrently.
> 
> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
> support page table walks"). Likely, earlier locking masked the latent
> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
> retract_page_tables() without mmap or vma lock") allowed concurrent
> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
> for MGLRU") dropped the walker's outer RCU protection.
> 
> The fix is simple, so just fix the original commit so we don't have to
> speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
> RCU-protected lookup and validation against the live PMD. Note that the PUD
> handling is required as well to handle folded page tables correctly in all
> cases.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> [ david: handle walk_pud_range() as well, clarify+simplify description,
>          adjust Fixes: ]

Looks all good to me.

> 
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

