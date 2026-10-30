Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05A9606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BHb4rT89
Received: by kanga.kvack.org (Postfix)
	id BEE636B00EF; Fri, 30 Oct 2026 07:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F436B05B1; Fri, 30 Oct 2026 07:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5B96B05B2; Fri, 30 Oct 2026 07:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 807E16B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:33:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AB248060B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:33:20 +0000 (UTC)
X-FDA: 85379081760.12.BA4BDF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DB2B91C0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:33:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHb4rT89;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793359998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kc1nYy3NbBrATEnmu304kSXCIcQUyPU78cqEyUeTLQk=;
	b=Az0tb8r0TrLRdfqO+PpVCKqRoE3zFq2V5rLoep9Wr6IumTBYEtCAMB7QToogtvlGx9YH1z
	e36Wfn+3znkLK93hXgrNaNhDIpKGtEErJwhp+B8vwoIZ/R4Ykt/362xO4Nc3NGajd1H3a1
	I3tI0qoAckSa7vdKZvx+qxKSvy2a1/U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHb4rT89;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793359998;
	b=iotTd4RXl8Rqta0z+ASU0A9k81hZ5cMzJCx8NwuHqrEVgA+aXSCzsPfU71GcDJpN94l8a3
	wOv9ibWpDNodmfrQj1cx55Z6GR1FVw8Siv1+zz4u66GVDVsNNjH9DOvPjJVn4PPFfk4Li8
	PpRUh1SrIz0MkORMHZP99KNrUTmiTP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EAF2601EE;
	Fri, 30 Oct 2026 11:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A5A1F000C1;
	Fri, 30 Oct 2026 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793359998;
	bh=kc1nYy3NbBrATEnmu304kSXCIcQUyPU78cqEyUeTLQk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BHb4rT89dXjX/iZaObEefV3p90/w7FDU1AnmrNDjsWGet3bMCVuHxPhhh8maCSV/h
	 zHFPhZNhQ+icw2cAAzLgVil3nTxqrp8v/shvpU7wgx9O2HOr6scmGto/DwnEx43YLR
	 U8QuxRoob6poB0ebRlGoVLdYs4EXRG/OEIcmFg9nLjCoFcmkfPK+kLiNtyRR5jFfK/
	 kPdRH7C4xmDmfWvUUGNc6QJpyNgV5aZiZ4d9NVAt97UVbCogRFpjqWS63JZdadrQNq
	 Et9wov2jU3Uf8UCr6K6rvisW1XibSsetO8Dm61vUCe5/c67aIiNMH6e+Dl8WkmU+fi
	 vUl1VbxFRwh2Q==
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
  linux-arch@vger.kernel.org,  linux-cxl@vger.kernel.org,
  stable@vger.kernel.org,  Chris Mason <mason@kernel.org>
Subject: Re: [PATCH v2 03/47] mm/memfd: check for real shmem inodes before
 accessing shmem state
In-Reply-To: <20261029-fixes_core-v2-3-a64ce7f83abb@kernel.org> (David
	Hildenbrand's message of "Thu, 29 Oct 2026 21:32:58 +0100")
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
	<20261029-fixes_core-v2-3-a64ce7f83abb@kernel.org>
Date: Fri, 30 Oct 2026 12:33:06 +0100
Message-ID: <2vxzmrrvmnil.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: DB2B91C0004
X-Rspam-User: 
X-Stat-Signature: s5ng6u6tzmhjjwbnhqox88ordjqgq1xw
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793359998-685042
X-HE-Meta: U2FsdGVkX18YstoQfgOm5bvKKb1X5ZPxC0SO4BPFqAKQaNCyhExIAKGKoGaHexQqUZ+O12pLtP+mbbUwFBY8kMCaoQ7iMMqd8S5TWI0yWeUXVqLEUTZXxDLtKFvGRItyYx8+r8xeZpZlDNMEpKb2oBySfxKdMbtzwas1LrhyQ8dFFaAHYcKIcCVD8OUxgcjLn52LG7b78uwBpt4KUuNcCxK6yVJtJcZqD/c52MGKevC+qvP0okPvPxtHpCR3Tpt+X1AhHixzxsiCBmOFjkp5FQi4nk9Aiu702ZiCXf0ZlcYRvoc4AmUM0IgwmkH27jgNOm2dQGNU73xe53oCHIRRkb7NnuC4zYudIsWM59kco2N4cTz9U4m0mmKPaHKAznuw0p9pBltKD+wEf5UWSgPZQMX/SFf6WDCjU/D70lNmhf49al2HbB7eLX3AEEkL0frRYXTb7+7wcv2QXdaKjoE7UL1kATS1DqiPQoWqbRvVqzLceNH8zQ6Q0HB3aiHx0GmsOX/W5P2PEPYmysU0HqzlyckeOlHu5vJHR+DQ8PlduIEChG3EN+jw/4AFp1YJNMToIxZLQ/l2+SlWsWkA8zU6NNnVqnKmrSil8XcRJQui+EgFpf43rzlFom2BKhSo0fvmC0AuoEt17EzTdqzX/dEgaP/3oDhiBFRl1ZLa0sEi+h5VoIqg7VNSgAjDlRgnHdVPDosqS79+yb1JpXiNHCOpYi54h3DZMvDevysDsTJ/mTEnDCGJyrNeVdFuICKIriJTVeenxPjLyz9VG7M8OBZtBJvCYY1pCHLxQZagasJodzjhWBNm2XDd/0SIVKZKH3DgZVm1C2J4inFwQffkTJD3BjLFrM/sqRLLAjrm6LCOQ3cWMqQr/SFi6u+TENhX1HTQ/NNcdvc4M0e5rxDfoj1+kg8o2cZ8wPzLk5kEzOP/94mfcWCrP4/PL3P1vP2+O2PW+2Ody/k/KHg8ghS4o0P
 6+72Acmn
 kjW24ESJZuZf0YnpTfS6KRqsCMOAWqpGyysjQtkdPeDH8W35NG4LeV3NnJ3camSDq/JiDQa4gIzRD68yZE934hH2F8RItB25zyXxP3NKCymDY9uAPdvy9ZkuQ2cdMsJUy3RFoxGoJAAWWsjAwapC1uDfV/gi/XnctdmqrOk/ZG1T3e8bSXp4ThiweNy0Ie+o30YGp5NzSkE/15WTLzHqtH53JdI86uY5lShvjqiQ6AhVatfgoQiYy2jnmrkf+f5NIb/bUQ9amC2kcKZMU2vKIACNLVJwGzLoQSl/oIvdgB/5+P8veojIisZUHhV4MBLSCrK7NfdBOzjQ1UQGPq9AeH2UgLCUSka5bLzSbspzg48CHjcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Thu, Oct 29 2026, David Hildenbrand (Arm) wrote:

> shmem_file() only checks a file's backing mapping. That mapping can belong
> to another file, as with a Coda file backed by a tmpfs container after
> mmap(). It does not establish that file_inode(file) is a shmem inode.
>
> Seal handling and memfd preservation use this check before accessing
> shmem inode state, so they can access an inode of the wrong type.
>
> Add file_inode_is_shmem() to check the inode's file operations in both
> paths. This identifies regular shmem inodes, including those used by
> memfds and ordinary tmpfs files, independently of wrapper file operations.
>
> Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Maybe you missed my email on v1 [0], so here's another try:

Why not update shmem_file() to do this check instead? Having a
shmem_file() that might not always return the right result on a file
seems like a landmine.

For example, you missed check_memfd_seals() in udmabuf or
memfd_pin_folios() in gup. Both want to only look at "proper" shmem
files, and should not do any work on a Coda file with a shmem mapping.
Plus, someone later down the line might use shmem_file() without knowing
this subtle problem, and we probably would miss it in review.

For callers that only care about the mapping should then use
shmem_mapping(). I am not sure if there are any. Perhaps that would be
collapse_file()? But TBH I don't really understand khugepaged all that
much. All other callers of shmem_file() seem to care about the actual
inode.

[0] https://lore.kernel.org/all/2vxzh5i7p5nl.fsf@kernel.org/

> ---
>  include/linux/shmem_fs.h | 6 ++++++
>  mm/memfd.c               | 8 +++++---
>  mm/memfd_luo.c           | 2 +-
>  mm/shmem.c               | 5 +++++
>  4 files changed, 17 insertions(+), 4 deletions(-)
[...]

-- 
Regards,
Pratyush Yadav

