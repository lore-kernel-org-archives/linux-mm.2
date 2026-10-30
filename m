Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE02C606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fg02mM+P
Received: by kanga.kvack.org (Postfix)
	id 0B4AA6B05B3; Fri, 30 Oct 2026 08:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D156B05B4; Fri, 30 Oct 2026 08:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDAB6B05B6; Fri, 30 Oct 2026 08:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C65626B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:30:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C64F7406AA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:30:03 +0000 (UTC)
X-FDA: 85379224686.11.F106866
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 210FC14000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:30:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fg02mM+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793363402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hu2ezbFXEyhvzPYipLaNmuX98BEqOJW5J/R/m8RSLb0=;
	b=CS62BzH+qgq1P2ojVLH/NTM0fUz6XMEdlPttX7bEhHULRLbljY5/6UhRWe9T1VTlD5tHae
	wx3Ma0DC5Eat2yF/zU4dB/7MzHVOBvyzmwHiJQnn+N8lm0EgFVf2hBM2OeeNU2CXsnHh4t
	WdmaXHvlrya2+KRYdl6ElB7OjW4FElU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fg02mM+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793363402;
	b=WY2+jBBs6Cv6TRF62PsRtnHn+rJDrsFe2SB3RyDgEuAft1ghUyezTdv4x8mC41HUCjffCJ
	MR2CehYgRGbqeCDSa02AMMmqbkgp71/L+PioqgL1pi9OHDdKeMEy2n528kQ2QMFV0Nw7jz
	DgMJaglQx9Yodwd0GD8NDCfqyydQnic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94CE0605C6;
	Fri, 30 Oct 2026 12:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAFB1F0093A;
	Fri, 30 Oct 2026 12:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793363401;
	bh=hu2ezbFXEyhvzPYipLaNmuX98BEqOJW5J/R/m8RSLb0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Fg02mM+PuPWrmf4vwct0jXlFZMeQuDiAYwpOteG7E7NWa+rawXxJHLQ+rxU4Iu/5z
	 dHaD/qCLNflG2BY/40J/PeIywGZto9P+aeKoiWOq/eodjFYgtozCCQFl3rLGILjOiV
	 3HHfhk/RO/H/KYZNcFXeCCK+EfX/j9cvHdm/z+qHK5mDR1L5VK045z+oAJrsEXFCaP
	 KeX4rkPy3RyQL3Si1NZqQBPwfcJQWAokQKDGDXyXdbxJOr6KUgY3agb0Xxb8NCVo0B
	 P0j1yAnu8mVQI+43vEWX38ucFx0bgxYGgKKtDx2aBrcL4oT+myqJLRltwHCl+UthTe
	 L8U/RBFarIVow==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@kernel.org>,  Qi Zheng <qi.zheng@linux.dev>,
  Shakeel Butt <shakeel.butt@linux.dev>,  Lorenzo Stoakes <ljs@kernel.org>,
  Kairui Song <kasong@tencent.com>,  Barry Song <baohua@kernel.org>,  Axel
 Rasmussen <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,
  Wei Xu <weixugc@google.com>,  Baoquan He <baoquan.he@linux.dev>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Kees Cook <kees@kernel.org>,  Peter Zijlstra
 <peterz@infradead.org>,  Jann Horn <jannh@google.com>,  Pedro Falcato
 <pfalcato@suse.de>,  Hugh Dickins <hughd@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  "Matthew Wilcox (Oracle)"
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
In-Reply-To: <297adf4c-1792-4dff-a7c8-2694dc2b1446@kernel.org> (David
	Hildenbrand's message of "Fri, 30 Oct 2026 13:06:45 +0100")
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
	<20261029-fixes_core-v2-3-a64ce7f83abb@kernel.org>
	<2vxzmrrvmnil.fsf@kernel.org>
	<297adf4c-1792-4dff-a7c8-2694dc2b1446@kernel.org>
Date: Fri, 30 Oct 2026 13:29:50 +0100
Message-ID: <2vxzik2jmkw1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 210FC14000B
X-Stat-Signature: rh9by9co9xk8xu7ph965pt74ui4t6kd8
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793363401-137203
X-HE-Meta: U2FsdGVkX18P0F22J70asBk5/RBlEPHP6F/cefE55kC8Sl++QK8FH2aW20o8Fprc547Q6o6aQ7Tsa8qZqtvzIDW18gLraEflwZfKo4up2kiKAwr6kNpUPjNJWk+AdTKs3DISygMqbGbMInKnuJi+F1HOFHs8Ig66YqydHNpNfNImK7v0V3KL/16M9BTXOlrxYV9nluHvXvP6YU/MJsQACm5fDB1mhT8z25r8qBISinENQNm3KgQOGMCiYgrHZ6MGL6BI6UtqPFNydzVhq8RPplXPUXLY0BQnTVJbGLD9Y8gi+185gaqY/YUef7xCOUeLEdshDj3CwvvjC1qrnL3Xule5rrMvtaptUB5kepGcsSlu49fqarC+agZpcDkf/lhcSVFMrVg1Y8EtoL4Dv0Mg8JY4OvNKmTQSU4XIAh4P6aSGZn7nCO/q1VZIt/jj0zA5EBJgUHO2nzEa4isqdclI2G6Ejk6/hs5pMIMcTG3dyzAzqam1XBmcsIFt2xp7faILUtdkCe/rGHFmRgVx6RcbOSwHk2t4UOlNctrLZl62vsC72cNiSbk4bmBAbF2JMlqng2xDXlkFGniKB9GkV8NJd4YeOlCInm4E9wfPuWbuQ57cqyvy2p7HxsJXoL5bPyeV5A2VjUpJ1UYGw37dfCE+dO8rjgGxshc5TPYIBUKYC4d/RItijrtKIC8Av7rX0nl8SqU2TEDj2Out9lFYfgDvR/0/pskvcWmUPDyzxzFhde4oRHxXeYd8sRgxw9sLIvcC9vvChgDCImP08ajC43eMZm3Fh81LlPtrCOwkuXEkKZAOjYUrcKQzZ4crQZWWdcStxgXeCCsHFsm/FpLNdX/iU/5ISqlITDLHJA6HVhQSwqSNRWE9QDveMZ9bjyDgYom+VdSEXR8YK/MzLZMEp1IBToFfkMKLRpY3cd7WhN82UB5SQBL0Wpa9J+tuSxW+XddqfbG7E4PC8wwDqbq0Mj/
 aFgsrGxO
 acR5U4+uvnWhQghBfIxxi0lzoeUG8duuXN2E4L1YO9fGmVo3KNzqZeW96//GikO13tFGn3Ct+hV8K9nzeRG+Koqti6wiKIKwfv1M6SpVOjrGbczDUEwLzYF5RakX8vHR3VVH7Enn1ABpm0AkhgX33EoL2gHkIaXjTxmu9tR9Z7zezpNQmEvGECIWJ0LzZzLLVJhD7BczapHXyKr26IwhXJCTMLM50R3Q9idF+J2vcUqPI2XOd2GrqwAokKqE6w7SfUPYlEO/6VMUkNNiB5Yl1GrJeNUFgLQwRrEm/BZXH1ZY3/UNhxVvEDi5qNhOQ85n30CpK9ofgX96pnda9+aCIOsJ9gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30 2026, David Hildenbrand (Arm) wrote:

> On 10/30/26 12:33, Pratyush Yadav wrote:
>> Hi David,
>> 
>> On Thu, Oct 29 2026, David Hildenbrand (Arm) wrote:
[...]
>> Both want to only look at "proper" shmem
>> files, and should not do any work on a Coda file with a shmem mapping.
>> Plus, someone later down the line might use shmem_file() without knowing
>> this subtle problem, and we probably would miss it in review.
>> 
>> For callers that only care about the mapping should then use
>> shmem_mapping(). I am not sure if there are any. Perhaps that would be
>> collapse_file()? But TBH I don't really understand khugepaged all that
>> much. All other callers of shmem_file() seem to care about the actual
>> inode.
>
> Looks like collapse_file() would then use shmem_mapping() for the time
> being. God this is confusing.

Yes...

>
> What about the following replacement:
>
>
> From 6e3c4f92a651e36ed1ae8d7659d2ca08543fa430 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Sat, 24 Oct 2026 21:08:33 +0200
> Subject: [PATCH] mm/shmem: make shmem_file() check the file's inode
>
> shmem_file() only checks if file->f_mapping is a shmem mapping. This
> mapping can belong to another file, however, as with a Coda file backed
> by a tmpfs container after mmap().
>
> So it does not guarantee that the file inode is an actual shmem inode.
>
> Seal handling and memfd preservation use this check before accessing
> shmem inode state, so they can access an inode of the wrong type.
>
> Let's make shmem_file() check the inode's file operations instead, to
> identify shmem inodes reliably. This will identify regular shmem inodes,
> including memfds and ordinary tmpfs files, independently of wrapper file
> operations.
>
> Use shmem_mapping() in collapse_file() instead to not change the behavior
> of collapse_file(): it operates on the page cache and uses mapping->host
> for shmem inode operations. Focusing on the file does not seem relevant.
>
> Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Looks great, thanks!

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

