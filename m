Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0741606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bVK4sRRn
Received: by kanga.kvack.org (Postfix)
	id 977146B05C0; Mon, 16 Nov 2026 13:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9270A6B05C1; Mon, 16 Nov 2026 13:30:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816846B05C2; Mon, 16 Nov 2026 13:30:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 439EE6B05C0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:30:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83A4840258
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:53 +0000 (UTC)
X-FDA: 85441823586.27.FA21E97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BDB1440008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVK4sRRn;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853851;
	b=Lns9AiY0waa3xBSiYWHEY3b9y9o3ABUtHiEkzAAouJ/5+It2nYU1R7ULcOe/dwJSi5KsFb
	fof13U0LGHMEKfhQ/2DmspYR4wgPON6IdJHEpxe3cF6WMSGGSlj1PcDX94OvMFAQ7ZjWSw
	dY5dgTd8w2QU56aBaBPbt2O1AYAILeM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVK4sRRn;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o6PYS21e1qzhPD+clr29kXL1Odn23CBKU4MGaHVrsFk=;
	b=WeBQM1yKj9iRBftfwbH+AHDNNtVs4TA1HBx4GPqv+12v60+9sVvhXu9jTUh/GcX5uo5bNn
	KuM/VUzXK3RxMEW0oSwEWKZe312eDCaPi0VXutu6MBxwjGmvPnaYdmONNGMS5WUpO9rC1E
	YMN00+EfTMZHEV73762iIlGqSHrVnDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 126D641B41;
	Mon, 16 Nov 2026 18:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98A51F000D1;
	Mon, 16 Nov 2026 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853851;
	bh=o6PYS21e1qzhPD+clr29kXL1Odn23CBKU4MGaHVrsFk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bVK4sRRnGn+L+J2Am0Z/tsuoc8SgVowIBYkVQm+LzF9nmHc2edHX+oQ6uI12gLwRD
	 fDqrkuaf+3EWHrMC8xRooDVX5Cp2Fo3kzJ5na/pV83SKF8S4+AptniblU/hbrSWrFo
	 5iunhxjtSw2c31epVCKDoYcRq+WTWcBuT5j6nFAratLxghlFEgushz+NXMKyJSqRIq
	 nt2euhGTGf9IcmJvQvz0oxrnt+ZYiUz77iQ2aU7jLIquJeSgmVQjCI6xzExnfuJevm
	 1u+xtI7bqBDbuh5qEXtVqAbvY2IFij4n7rn3r+N0G4h6DcGRnooL2bDlWwHvtjD59h
	 9NbiReDdEkCNQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:28 +0100
Subject: [PATCH v2 07/15] hugetlbfs: fix unmapping folios from private VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@kernel.org, 
 Daehyeon Ko <4ncienth@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1733; i=david@kernel.org;
 h=from:subject:message-id; bh=vYFnAW6yKXJXOaiP5JOgGjPOTzuMx6UkG09rimRGfuw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3foBZu0rNgZ68DGdFE4v/EIe8m+yd92OXkUF/vvP
 qAQLXGlo5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgImoGjEyXKz8wH4i7cplmQn3
 U+fL3ry+w8Nlp1zhAw0zoznJqVd/3Gb4X53v+VnyXOnTieENTn0SE78qfIpRk2GMffPUXG7a7bY
 JrAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 6un66qifa784k5f9odjhrnwyoa65a1gc
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDB1440008
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794853851-666180
X-HE-Meta: U2FsdGVkX19UhTcn35wsZ8KtGVJFXHCI9Wd3T9cq1kL6yJG2VBw4icSUycGC6ukE1tK1CI8MtNdG0u3e4STXQzvP9GIARD77w9q41dDu1Dt7o4MNBviZdDVkCihglO2ybhY+50bUPD+REPSkhHP1Kk8Ag6ubWBMozRWz3vJXgUK9OPvsDZOE5Dcg1bocKa2HZdDh6rMpsaDvsjUtsKv4cjxGldUM+oytWJ9T2y/Y7sc38dXneWTgg5uQJSayxfKRj/kKBqy7/B+wpsGzC9yrIAl7ZpeGGcX7lLBTzMR23RKHUVMXOTkSSqA5DubHrex6wZ16t5MSbOx6mmLU4zEGBPw7bQyx6QOgdFdaMOJZeHH2GXpobrhnlybUV2NKAgb95PrZFvKbGd5vynIyO9MxS5G20I43RjXDsSVtWE/K6TBti3W6Q7wnFvF9GfHZwxErtm9hmFq7SPtWdzQvPz76ZLfd+6YJsXK5A7a/bu1dXSCNa/uOPUP1ybO6gUazzXNRAueWsuzHJ4lW3LauIXY5ckMriSDrF+LfXyCBfRyW6bhVsLQIB4ArDwOnn8/de0aW7s7io2KKTglPm/XVH7sC+SvrywlZ4OfEyPX4QLr1m8SPYjhuLl2dM/FAaH8z9FLzmhOqSJIdO/nTJ1Cn/oQKZJiGgcJRebvKt0d+uFJbNgLkmAJ7xXUa7W59y8eFtvFJ0be0+K4gkJ+Tm7zmEHijBqP5vA0N4XPPLi0lS9hmM6CMpJoxMjr9SB7tydEmDcafjuD7uiKGrXorlMJvoxNCnRXYi5bQduQcp/JSCXeg0951jEbn/eaJZsHM3JaU9J0noLAfUfmsukfZxib49zaNq6YwD13uCtNGIBUSx/U6aDGhY8Hsk3J0QtKs0nUlliYsUK/IuhTzjv00v2HTDJ/zPJ6rRu0ZnSzwLOFlU3bSAPn8jrO4yyHh0+McfWrtx3rlT6LaIX242ex27AwWym/
 8rCSCofP
 Nk+khEBHAb/vXehDAwqL3BMH6dwrrpklIbNSZIVeyS25GXcDl5j7J3FqWMqCLGpl6t3H7CGuY5YlrvLUqypwyVkQekPBzj/3J8UVDriNN/bGtCDNpekLXH0r0jwUpcqB1tTAyqsdFPY4TVOHO0q+v/fTwUnLHUUUMpfPthp8bnsGJLac0dIF1nJRlfdjJFFl57fi91tf8V09NTtRgBTx6D/lqu7ncGTWnQDUFr4I+LLbSgn/pl+KqBkoiUA/k1ac4j9onurn6J1oZDY5mgvIOjFQepgSPx35q/DC5k9gLR5c//VkZ0B+/9Xs3LlVGg5j9//hMYNB+EGIkKSewnBgtGGN9yLvu1AqcR31Ri1VbX0ploI1/+Eid5ofiAwIt52b+dc5OxNuu1caZWevMFqys+8hLaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

hugetlb_unmap_file_folio() assumes vm_private_data points to a struct
hugetlb_vma_lock when hugetlb_vma_trylock_write() fails. Since hugetlb VMA
locking was extended to private VMAs, this can also happen when
vm_private_data contains a resv_map pointer; treating it as a
hugetlb_vma_lock corrupts memory and can cause crashes or hangs.

Only take the VMA lock when a shareable lock exists, as additional locking
is only needed for PMD table sharing. The fault mutex and i_mmap_rwsem
already provide the required protection for private VMAs.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Cc: stable@kernel.org
Tested-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: simplify description and comment ]
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9f502a456cdb0..1d0c35e639e80 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -401,6 +401,16 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 		if (!hugetlb_vma_maps_pfn(vma, v_start, pfn))
 			continue;
 
+		/*
+		 * We only need additional VMA locking here for PMD table
+		 * sharing, which synchronizes on the shareable lock.
+		 */
+		if (!__vma_shareable_lock(vma)) {
+			unmap_hugepage_range(vma, v_start, v_end, NULL,
+					     ZAP_FLAG_DROP_MARKER);
+			continue;
+		}
+
 		if (!hugetlb_vma_trylock_write(vma)) {
 			vma_lock = vma->vm_private_data;
 			/*

-- 
2.56.1


