Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF955606A330
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LOOzE1Ia
Received: by kanga.kvack.org (Postfix)
	id E577D6B0A5F; Wed, 25 Nov 2026 10:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09436B0A61; Wed, 25 Nov 2026 10:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF71A6B0A62; Wed, 25 Nov 2026 10:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9AD6B0A5F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:49:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9323C1C43CD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:37 +0000 (UTC)
X-FDA: 85474076394.08.ECC8A40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B7A3820004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOOzE1Ia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621775;
	b=dw5qDQI5c8PcoQfq0QZjxAX9HsrpjL+RlNB9cZLAbRLfJM5v8KIq7syMdXheZ8NU8PBYtB
	pKg14bfU9jL4Ce93a2pgmjuBinZNMJXPo16tZ5q7WpufWw52RFeaddClQCCnBFLtQ0Mx+s
	Qx6Ao/MiusUQPtLqrHJgrVN6/5AIQMk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwN7N2TJ/AxtSCaqTfLM9jPZ0Ogy+48kHJQgnpkXTHY=;
	b=uxl43dGJcgIHf5jide1xfap5zL1BBLA+KKJYuvELl1WAipZ6UY/83KgR14k0CKnYbpCsPE
	ngMOfSzvgGzlZ706qTXrQURVFcPFnfFJkwcGNKyxZOLLE7xvsLDL8amjkTIy1Q6Ybv7U3L
	1qJtrglOVdlXVMkwenHBWyPW6vrTOG4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LOOzE1Ia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61AC262F35;
	Wed, 25 Nov 2026 15:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BE81F00ACF;
	Wed, 25 Nov 2026 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621775;
	bh=xwN7N2TJ/AxtSCaqTfLM9jPZ0Ogy+48kHJQgnpkXTHY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LOOzE1IaHjp88Xb0pe3QCQu7CIqsf9lvB2bWUHMyrquKLsE4mk3eSefypXwCchx3/
	 EgDm9WYoe9egxS4uzllqv4tVecTYA4VGcRRpMrF6IZn9+kOnaqnGiTyRjV7ad+DIPf
	 kiRZkpUSghvkaz+DxSJ+hB7Rae8h02h/GXcc8vmDBYeLGWK4fZygL3H/I2Bdj6bkGJ
	 PagDwhj4P2FJg4JoA/yA2/SGYxaB/eZmY3/+F9aFz++Kq0PaHWKz/qGtQ3rUCGL2vn
	 zoCiluotK1PIu1HVzJVPeNyK1XVICu+74JYxil/rYHKTDWqn5RR6PbqKKTDQ5drbOj
	 C9Ap2JSXYBDKw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 25 Nov 2026 15:48:52 +0000
Subject: [PATCH v3 4/4] mm/huge_memory: only compare PFNs of huge entries
 on huge fault insert
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-huge-pfnmap-fault-races-v3-4-bbc44489341b@kernel.org>
References: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
In-Reply-To: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 "T.J. Mercier" <tjmercier@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3097; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JsUg5bNeXJ+T8vfVeKVvW7LaLcQrJO3bFcpJ22VjJ8o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLZmTPfaT6JTWB5lP5ylWZvkL14xaT58xaapXudKV8gP
 EfJy/VyRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayKZThf43eEc45337s6NKu
 8KqICTCase4gU46K+67dvwI2BukI2jH8d3qlIGQX9zWlsqs5fHu0RUjLPMtZCc/23ZmvE/zhVqU
 aFwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B7A3820004
X-Stat-Signature: yw34sfk38t95d91zyz8ir5eoiantkw8x
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795621775-196237
X-HE-Meta: U2FsdGVkX185WhSs67WowwYGEdb6cbHhtfSqifDDtDZue+UBQnndt8d/v9xYG/zMr0VzcBt+Guid1FG65orYsF1waw8yEFwu92oWwBNUuP2PCK7KovaeD3lCEwSXXQWnPJzMQPzCj5iugbYqisgzc7e2TtPH3S9CRsrUMbWUPoqMTyJFY3aKi8Jk86ActOx41HdU37/BdppxgOuugvlfYVvSSfg7okmx3zZpASJ9xSjOWSRbudSj67Q3WaM8gkrqbYCwD6UqXxg154gVC1l5oEeleb0FcFKpdmFvGGCqPuSRQqRVuKaBiGgV1EGxUtDxpPm3vPRT6q3GI8k7AJYiVSyTlVZ16gmWe0mJFM1Sfkyh26jxtcek1/Zw9KA+4QugBnfuJCLDAv0FWjLh5OFsXTwWzahi/dCPhK53IFwgXyE3PGMKHTwp+npBn4OKzMCy6ZBxRE7vzBWmlsa+RJ9Awp4gN+NcGu1YR5TxoMjq9eu1GTbesbGyjmuzq9obNluDgOJnHpLs8kP9B0UPehJ3h/AFACDbG2wig0p86covCuQF64fCQUutv1IdCkhtR5HW12acoOr5fs9D9Fdgjj8EPp7zWD8QSU7DGVk+3FDm+xtg5QsewExhH5GxhcvLXqi+ZlSval6bShhTXBeP0Jag7lmAJbtmNwQ84//PWwVSnUb8Mc10CdMqKCaj/MZiB05Ih+gxgNaFxfhdJpZBohgBBr5PPj6cm3YzU48XNT5Yg5f290gJnZ5OYoP8ZSc2pJxe1SP0Nwtedd/durxRr203IJF3i8C/LMCONkMjJ0pcfNt/E/I1sXuwRq+dCNdrwKGs3C19GpGgxJYptVN2fWyONNjCdXbVdPJXk0+2185Q56ltWnxU/7/mvQ43jYYnMsYaq/WlP7WdsJ217wwXoX27saOBGngHGfxjpLRF0/Q2wc5z91C4yJcR9GSSdtT6Gq4llowzxOM/dGleNVkEvJr
 qUV7o85f
 cjK/7luOIyf2/KxNFEpCUYTKnZ9L2T5XvLafURYa0ClTRnAqRqhUtzJm9+x1FFgAaBZ57vvPxgD+NchffSOQhoTkg9KoL9sydQydAoIoPY5K40vgOjAAxz+SqvSxCmUYI15eiqbWNV8t7rp7A9Lp3+b1lq1JKMTuqbDqqShpqYIEba/a4/Ohrp+KAedeoT1wciob+6x2PDdEcSThXeX0qLfn+GcGl7Qxle906w2p2tn7ohQT9VEZzOqeQghlfjHJu+15O7/Jgw6BT0BrjXQxgt8lLDYgg3jgsaeA8oM9g6cxcgffk4D2mEamByAYSg+rfY+mJhjwH3BTP3yjSC+MRTqEAJbJu1JWoS/MVAKBSVJRGQZkRCta3zkey1FdUCdDASaBfG9FpR9DLNyq48JNJSv322gZP32sm8w8BhQPXYOhsFaHqpC/erLzqlRV8rMNt4Rg+pjktIO+yjsqORfWMM7lHqmZO+dEGA+xE/acFJSgkqZ7+D685d/xjyqPzkYsNmnF25AUpmg4wdD/gw+egbtL0mXr6m0GiHeYgkUWPsDePj9UyvcGN4diPfkN8inADQBUfgbIPHYoGOobSzbVlNq2UyCsAo+8pwYUYCduWWxXxhWYJZWEIaGMSUK8Hjnd46Z7t++jOlsfYXFqlqZjlFH2KUQGrcLqoqXm+z5veXMnyrSdKdjHdv8PMeZEzW+tNEGWU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A driver that implements both ->fault and ->huge_fault must anticipate
concurrent use of both.

This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
concurrent with faulting, as that only holds the mmap write lock and thus
does not exclude faulting threads stabilised by VMA lock.

insert_pmd() and insert_pud() have issues with this as they both assume
that, if the page table entry being populated is not empty, it must be a
present huge entry.

This is problematic as if it is a write fault, it compares its PFN against
the one being inserted, warning if they differ, on the assumption that the
entry is a huge leaf.

Since the entry may be a page table, this is invalid and can result in
spurious warnings.

Equally, the entry might be non-present. Nothing can install such an entry
in the VMAs that reach this code today, but there is no reason to rely upon
that.

Therefore only examine the PFN if the entry is both present and huge, and
otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
at the appropriate level.

This is what already happens for a read fault, for which the existing entry
is not examined at all.

Target the commit which introduced the first driver which both mixes fault
orders and passes the write flag for the fix (since this commit, both
drm_gem_shmem and panthor are prey to this issue).

Reported-by: Eliav Farber <farbere@amazon.com>
Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..ab267ad48020 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1643,6 +1643,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/* We may have raced a fault which installed a page table. */
+		if (!pmd_present(*pmd) || !pmd_leaf(*pmd))
+			goto out_unlock;
+
 		if (write) {
 			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
@@ -1770,6 +1774,10 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/* We may have raced a fault which installed a page table. */
+		if (!pud_present(*pud) || !pud_leaf(*pud))
+			goto out_unlock;
+
 		if (write) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
 				goto out_unlock;

-- 
2.56.1


