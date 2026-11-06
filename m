Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FCE606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SP14kqgH
Received: by kanga.kvack.org (Postfix)
	id 956596B05B1; Fri,  6 Nov 2026 04:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907086B05B2; Fri,  6 Nov 2026 04:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C046B05B3; Fri,  6 Nov 2026 04:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 665D36B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:11:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D4EB40D67
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:11:52 +0000 (UTC)
X-FDA: 85404126864.27.1BBB072
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3067540002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:11:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SP14kqgH;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793956310;
	b=cQk8ZfhM0m2nBEcR3wYP4sziPU6GAmV7jTcA+uutRLGVUK1qjm6K+b/xr+k+2iybh+Aqoh
	OpdnaFSygH99s6j+7heE2bS9L0vEO0/xWnjTr4aHVyj6votLu7JqUi7IwVtMLYB6pCQXIh
	2nTrIoBWghYYf6AzNe0QLu2TlzyyStg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SP14kqgH;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793956310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKi4F1XkSqKNw3b7+Ng4uXx+ZMXFkYDoN/Pwc1tdXyw=;
	b=EqA/6Swc3wn8UpP5S5xX4RoKWtY7VpOCHA0QpMxmBA85YKur4Teb8ybQqOI1gqZei8qK/5
	EyAqv8qG1wZz6uwiSk8eIArK6s8EuYspGimJRyovLALXQ6A4eTJ5d4LveFi5YTe5jHLO2f
	AO0Et1zT4gZN1rwbyGGZjpGcOPo4DNk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RB9jCfeGXFtAeNZRCJe7qF1HA2DzPZCiRtQ6f8rlwO8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793956308; v=1; x=1794561108;
 b=SP14kqgHZegobLguKceMWVRaaEf3xj0wYia2VHIJv7nrvC8v/x1oCpRu272qEx3kMDDC6SEE
 DlL0PmcvKPbKwAj+xL2YncyuVQl1aPxY6vKPhNcd0sk3NnzrIjyjhtFA8ayH6u8Qep1tmr357io
 IqEHRdCNdAzL3+8AVKpJKnLM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a5d8b693a372ae24;
	Fri, 06 Nov 2026 09:11:48 +0000
X-Mizu-Trace-ID: a5d8b693a372ae24
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	hannes@cmpxchg.org,
	songliubraving@fb.com,
	riel@surriel.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	joro@8bytes.org,
	robin.murphy@arm.com,
	steven.sistare@oracle.com,
	jhubbard@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	iommu@lists.linux.dev,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
Date: Fri,  6 Nov 2026 17:11:39 +0800
Message-ID: <20261106091139.67845-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3067540002
X-Stat-Signature: wrhjradmy5x85zczshx7c5qd13ot6xyn
X-Rspam-User: 
X-HE-Tag: 1793956310-974338
X-HE-Meta: U2FsdGVkX1/5GwW7jzNDRPRfoi1RNWQ36phunenBSKTT2nbxVMgkg1JgqoP/g6Lbl5hzyf6rl37PCYFj/+TRKvgLAUveI//0AKdoVvtBRCJuVXjG2bo532SXXNBZMdzH9ZQrqE5SQV+10PGqazzGgOET8LWyiT5umztr0Q0XlOGnggZ7lftj4Jtk3dfdZrlp34vy0P1461HE9EzWqT9XfEnA7fmOUmlBDvSZC/zFKcclLDqHZ0fhm8Kxaxgy+Z80hSahPKfvWSDtiLXLp6jYMJi6KJYXaKy4Zh1lLmAyhYxrVgRpIkMVUBPitjjpS7zIu9Bk2j6E6Hx/Vo5GO1Sb90t9TMBFZbud9Yg6dfsKegPFW2Ap1J/GOR6NsvNqye5RP4jygwBLCoQXfraxHgYH0WDBbAJ1TIHRXb/GA9xIR0Sc5M7SETR5VKlz2Dc5uNksPqbDoSoJXOf/7wY5BGuSyPbGb32VZyecriCEpXkLQmKETJrLyh2+TM2jclxf0/e8NW51Vv0+YMo2XwfuYeoPa/wNPWD32L3vTlfg/UpDLo/SJTC+rKC47523oKusTqKV/B6MZTGOrOjhXyjdEAutru38OnFVKL+jmsk7bF2u/PImT1Pf0QKWht3Vo7ePBQj+vrEiYIVaJqmFP1h89s8xbwqwiSDD0PI65W7YseImLRptbygqIF47uSITy/OwFE3yE6f9nvCL1iThUXffqqfBpwVggdvFzHyqm20zcoONDA+203Fy3tCrP6h8lugQhs2u9FfRvahbTc5iGC7MxeIjeIDRRXVcNalX82hz1YVT+adnnYp2YEnVXXgvahSoe92pOBom+F2SYGv5BMiGx/Jxq33P6yw/C4SzzYlJS9YlXNQZaBuv18afHFQmVYRtWpEqyIaWywrAXEvh76mh+YQxSqLF5E7rICFkqiBV7crJ9LeJ9qzHF7QW3E+3Y1ns15nP7KzslBnrMH0qOyokg7h
 +882tvpw
 +h3B/XMFN81cMPjcwFuJ17QjgAOfB4nH7fycdGqlaIWYfqhIPswBnItmNutvzovEs2hJvc6zy0d0BkpwCj3cGXUVpX9oE5D5NDlc/0g6T7sf78EWohNRBCy07SNxz+qBbiYsdthBYoYA7bHPpmrGo+4l/yKh/0Oao/UliojqZdDCnJsQ7ooLn/tEwowVHI1+OLsWsc8pjzRs4EQAVaE8Urx6cyCSNcXbsueZpYXC43DhP79s2qH364mXvXCtlM9RMeCZXF10uJfcytu/0MIjLdhj5e8Ft4bAoirAty6a+SeZZkUmsA51422X+CA+vGk20dIDy+1BJM8AZYQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 02:10:10PM +0100, David Hildenbrand (Arm) wrote:
>With large file folios, overflowing the folio mapcount and refcount
>became possible. For anon folios it is currently not really an issue:
>each large anon folio can only be mapped once into a process.
>
>That's not really big news, but it's about time that we do something
>about it because some modern technology might find ways to abuse it :)
>
>One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
>refcounting"), however, file thp support was added later.
>
>File folios can be mapped multiple times into the same process, allowing
>for processes to hold many references to the same folio.
>
>As a short-term solution, let's introduce two folio refcount limits:
>one for ordinary consumers and one for admins. Leave some headroom
>before the refcount goes negative, which we really don't want (having
>the mapcount go negative is also not expected).
>
>Start reporting SIGBUS if we run into limits. When restoring mappings
>from migration entries, instead zap the pte/pmd entry. We allow for
>slightly exceeding the limit to keep things simpler.
>
>This is far from ideal, but better than all easy alternatives we can
>backport comfortably. For now it fixes the big problem: letting
>the refcount (+mapcount) go negative and cause trouble.
>
>This is only a temporary fix, we'll follow up with something better.
>
>While the refcount checks are not required for order 0 folios, let's
>just add them for consistency: each folio_add_file_rmap*() and
>folio_dup_file_rmap*() needs a prior check.
>
>Also, just document -EHWPOISON for copy_present_ptes() while at it.
>
>Reported-by: Chris Mason <mason@kernel.org>
>Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> include/linux/mm.h | 33 +++++++++++++++++++++++++++++++++
> mm/filemap.c       |  6 ++++++
> mm/huge_memory.c   | 24 ++++++++++++++++++++++--
> mm/memory.c        | 23 ++++++++++++++++++++---
> mm/migrate.c       | 11 +++++++++++
> mm/userfaultfd.c   |  4 ++++
> 6 files changed, 96 insertions(+), 5 deletions(-)

Nice work! I just went through all folio_add_file_rmap*() and
folio_dup_file_rmap*() callers, including callers of set_pte_range().

All covered, looks good to me1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

