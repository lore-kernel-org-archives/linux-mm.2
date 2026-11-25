Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94770606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahK8ELcL
Received: by kanga.kvack.org (Postfix)
	id 8902D6B0AF5; Wed, 25 Nov 2026 17:34:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867D46B0AF7; Wed, 25 Nov 2026 17:34:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D606B0AF8; Wed, 25 Nov 2026 17:34:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB896B0AF5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:34:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D077C160171
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:34:01 +0000 (UTC)
X-FDA: 85475095482.27.FF6FA61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0DF5714000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:33:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahK8ELcL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646040;
	b=bpYFQxOsty9wPLP1VCQas6+tYZ6nrwLweYZBsesyfAPlK44h66g9hGrbNL/oQa5dUFdeTI
	9hScMvE+TqdMmtBdN2GRshDea50IdCy9nZeI90IPJ3v9WFagKsWaW4QCslj1Z+q7o1tZp6
	lq/arhwg6zutvhouQedbqzwN8Pz0V7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=He20RWMnQEfWNCCjTnuFJzGYdzo97eyhNCvvU93SJYw=;
	b=ml0IpTxr7Mju6Hj0bbNoPzx9MJs75Y9INwcGm+9h5M+4PuGfComhcHEvvdLdCTlm0F/CLc
	lR/q5iGREieczkUn0kCi8alHTbYVGQ+cQzER8b31E50buaFEZ5Z33fGmhS3j59VgJInmJ2
	iA6flWB3towWOkgKMC1r0y+eCBGmsPo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahK8ELcL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A4B643085;
	Wed, 25 Nov 2026 22:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2D51F000C0;
	Wed, 25 Nov 2026 22:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646038;
	bh=He20RWMnQEfWNCCjTnuFJzGYdzo97eyhNCvvU93SJYw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ahK8ELcLkFb6vhynAAkR+XAD0pRhnkOpCP9l2RPpNRNuRZg3bHUGplidaID/6tCT3
	 85TtdL/rN00U2qWrlx3w8v3WO1a28OwRWopl7PUuoyw9FHI/s+OXGB9oncb4k2gKKE
	 0sSKwEstEQlISK2bJhRvBEC6QKWbsKBzMh8iOXAZ3zQaWyN55pgwfWQ+xsjxx8Awrp
	 sKXPIUX3/ufMnpCJGA6yClocXINcWSUlgYxIIG34sHi2rcc9X4SikXyfwRI7dfM2UN
	 DBn9seKPscn6Pz1yANZe6zemGHHxnKZHQZEEBrQ7LS8VmvS89o1b+Kcu/KNlL9prH7
	 /UomkEFte94Tg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:00 +0100
Subject: [PATCH 02/21] mm/hugetlb: fix truncated copy result in UFFDIO_COPY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-2-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1560; i=david@kernel.org;
 h=from:subject:message-id; bh=IM9Jn0PMIC7KdrlMfsHaSFMWAt4HGC1aolUW6gtZvro=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk5Rjdi+VyA5cFPbUoF87MlvvUGnL/k96RRznmXPXL
 3pv839RRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABPJ+sHIsMnEy/jx6ccHVTxW
 7W7d8c5AS3n3vmjtVL9v6R1JKzOZGxgZTl5KXXnrwdue1sjQSBeLw7c9BUoerNDonj8reHKSXLo
 zOwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DF5714000C
X-Rspam-User:
X-Stat-Signature: fhacodw869syi1kzmiyk5ugyo6yk9ao7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646039-862359
X-HE-Meta: U2FsdGVkX18Z5IhZMdsLUf+WkYpe+BprtyUt7RUJJfUZVK1mVuNabwdepE8QkakdbqEgPLVOobsI4IIdOUeSzP0WSYSlpckBcv7XAc8LLcheMF4CntvmCPgkdbEc3Uxr3l/CD/GafNmfDeBo95s3GcFUF5vyMYlRlXJOcl5MAVAhfiLRlYYG2Cj3r/+eZ7FLIpaqIhA91Eud41n0Bz80v5E8scf3L+Jj/0ZI6gIXj6e24yByUeoWxxpYo+6pgc373myRjeAdeWMG/vNMbgqNyF83wtt0OmSDiy2lgGzIl/p2yi8RzprNEIEUgNG+8ibwuU5q4hvo3OU3DY3kfbkdSMYYHVI7Luxsh/7+k0mQZt0zTc2xANYmNoNm8429bzNZMWgO40nAHMtpC0EXWXX//Wa+0srBcc+l4JcGXAbpEmqeZ7D2giGHM15LVY8xwYEl7SdpCSXmkOkkwF4nm13zDhAiSjEyI3dwTN3VBJbekpmLxbubqIHVAaNv/+zhZ5qqIGTlJqpVi7UwGeyX0aFvXthOPLNoXGenKXKh+/S6iULUYcUyncTawul5c9sNkVQLPDIicHm9HsqHlzDPRwfWlro6k8xE4VWN6MUJW+GtkAznB2m1JgfBsoxYeM7VPnobrh5czdjE2hks65sGM63qdHE3kw/ay76/36d+acM9e13A4ieIGcWwQ3CcbAXxE6yXJJeI/r5GlKCDygdgM1Qq3QjsOVoPrLrxeUvmDrgz7mOvl5RqxhYwNZA/12CsQz0ni7j3fzxDjDq9EnnhdOjgn48I2SCByEr5HB1k7wn8a8OPL37kn2UUZ4r0YBNWvagx41iPormKogh/jqIi/62P/cXmhQJzpztcxsqBGgVY79HZIkfT8K5vwGMXFbVK4dfHATL2aoN4Slg3XlCkAbmBqjcqzWbiA7UX0/0YllirU2JoTqU9M+G7i8yofFZIwHJrZUdvs0KRSQBrYcSRz2y
 cJXRBYUx
 uh8eVImyJpm+shXSr7KtToCwrPrgYswzcijO0r6GiHEahbsOabp/kugzPdIPk9B4sggv31FsfWcacQNrWGA6yYCjYIR+sZZDfc9YRNw8b4gOeAhVspjGdDWbvjApuma0KJwxKyIoUhZoTw6XcsZFTM+y0EvorZxwwA7xER6ZzSimA/uRHlLPfZJtFWOFdRpnSdhWljq68xIV1gGfMRhJvWbZEfOO6bkETdHXygjtA2C3Y4aeEMIoQX/7xj1KuCQAMeHjv2VmGV/CCT32+eAlBJ0T0SmNssMbaY9QaokR2HcROcveq4jG2JyKetDAP82fIFRGOQr0aDKVnITQr/rQFmAuiwpTGHeQgW27fy9bbjey8O4Dc7RFCjFiZn65Us0ka7WqTDOab0eqkyHrbWVVgGgpLGWIc80mlJD1tGYLGf9QtfvXfbwrcImD8cE66aL43THU2TG5twbzIyl/C0INfY7lGkUaMS0519w72flkAe21jH3DnVrBH7/e3fW+2H23b/jqDkaeEkixfAw+/yXdh53Dl15hu+gWmNrM3pGCzRQD9WnYIdx/MwgtGHhPsk2AHwXHrzfjWy/msRaNKZRxZgR/wRbwZpeTJViHYQSH26ASuXO22zX4LpTpHUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Folios that span more bytes than can fit into an unsigned integer (e.g.,
16 GiB folios on arm64) are problematic with UFFDIO_COPY: the result
from copy_folio_from_user() can be truncated, possibly indicating
success instead of an error.

We will then continue with the folio that has stale data, and make it
accessible to user space.

For example, if copy_folio_from_user() fails such that the number of
bytes not copied is a multiple of 4 GiB, we'll get an effective ret ==
0.

Let's fix it by simply testing the return value directly.

This has medium urgency, as it's an information leak.

Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: cleanup code and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f46c85fc0cd0b..d57964914e18a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6568,11 +6568,8 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		ret = copy_folio_from_user(folio, (const void __user *) src_addr,
-					   false);
-
 		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
+		if (unlikely(copy_folio_from_user(folio, (const void __user *)src_addr, false))) {
 			ret = -ENOENT;
 			/* Free the allocated folio which may have
 			 * consumed a reservation.

-- 
2.56.1


