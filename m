Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE83606D853
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXzWu4HH
Received: by kanga.kvack.org (Postfix)
	id 891126B05B9; Tue, 17 Nov 2026 13:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868CA6B05BA; Tue, 17 Nov 2026 13:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EB76B05BB; Tue, 17 Nov 2026 13:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51A786B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:32:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB64DC0558
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:32:14 +0000 (UTC)
X-FDA: 85445455788.08.F80084B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDACD1C0007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:32:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXzWu4HH;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794940333;
	b=hOhyfMZGXGIVU6tRzpYqJU/WksX3tj7HPQ8BsfWO246daSakU7vEU7tesyqx2CBWIiuPpE
	F6Fs+Tc3IayTBDAn0/M98DY1RPYr0AlEOp4fQkVUN2hOk0U9rn7zzbpEl1kYfqoqzh3Opz
	cSTZ/WxRxNa+MvDaxpaJZKbilIF9lDA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXzWu4HH;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794940333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvX28kMT2JOA9V7LVP/iYVU7syU20+iC1OkNeLZAOFU=;
	b=Sj1FTqo94/pDKs+8M7mj6qttvAQmst88ENMnfrYNWATNH2yMS6XSP7RztZtexfGizNsfC5
	c1bxMMAgocptooNxHaL3o4d0vYSaM3arsgXzTp2Wd0g4/+5hdbNFnebe4CRWrPA2zwU1lV
	nEgVJ2IsbOGPmdEZJnDlIabsKU2B0gc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AAF84055B;
	Tue, 17 Nov 2026 18:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02FB1F000C5;
	Tue, 17 Nov 2026 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794940332;
	bh=PvX28kMT2JOA9V7LVP/iYVU7syU20+iC1OkNeLZAOFU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WXzWu4HHGGKFkosG2W8m6TAHTJeu74jnTyk2/2eKhQg1x9D8yzJWRciKHxxA+cCFD
	 Y7/lTodu9vRLqwSXbHmwavH3ssPx1sgiilTASBf7tKG1G5/RghKa/Q2E+hKFqRZiK1
	 MwnvoPqjW1b6AavB2L0Vdqs4x6Nwo2viI+99EDD0sBbrmEF/XsKyrjhVmoEd0x9jqJ
	 5rcZaB6GM3lJYBZWlocxMaTSvYCeaWjrT2tgiSWLtfAqPqSJi5es0pxiB2o5vFSzo7
	 zBJhtMW5o0nLayEAXtz+92oXMu7Y/mIp9hBMACC6Qi0JC9r6QOnohqeRZBp/42oQ9/
	 5jyf7STTal2zA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 17 Nov 2026 18:31:35 +0000
Subject: [PATCH v2 4/4] mm/huge_memory: only compare PFNs of huge entries
 on huge fault insert
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-huge-pfnmap-fault-races-v2-4-276007e73bcb@kernel.org>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
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
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2957; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ud05cZZbfU6vNs2buNKiOFsC3ukoxS/P1Cwl2+ETDnM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL+zO3+/e6r2kKtptUaGvku6tWvbmjM/1lsznKn7vwDq
 zWnlKZv6ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEvmgyMixU4NGxtEqvr/np
 rH10b7LnT5YF6az6CzftvFJltbdOuZqR4WbgijzGru3PFr3dNVdkVs78w0+l+o/V/it5V+pwQyv
 xNyMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDACD1C0007
X-Stat-Signature: 3q4buxb48giisk4u9hfkbfq6q46dugfq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794940332-973648
X-HE-Meta: U2FsdGVkX1/YyBL9TIOtpdYwek3pSr+XcsfRE59Dsm+pEhlf3S/eYtVxzpa+++FArcLptLILpKfRsCBcD92lKb99G2pIpqxe00m5TTJhjvJOyj8ztGrxVwH4EcnG40rkA5qUTxnGbp04kEopU/2MovDDZDRWNv0ALIM30U0M+bwCFb8YOdzvCbXS26bc0iiNCmoG5YG+SLi/3DWQxAkDFEJvb7E+hmZq6fDeLtWj+19b/dwNuJ4o5825pJUaFpvNsmCYpU5RNpplI3w4dxPyW3WfYSPlKj6rqOjR9jV0UGnpzHcV2llaLwXumA8MkU4WrZuzW7QcQU1YHHIP+NhVWIwztRrg7u+5sSpJTXE4GXgxh3Nc0vrGT2jn8gHQhFteuoRxzsTfQfQwkQjwLLkVxevMT+AF2d35tE0aniVlL/GzoxdsZ0tweE7+gidCqQ1kQAGXW0dnCv0OO8hRZdqHqeOhYxbawzEfl48hn5UdjZyqybhHQ74GIDV4wEVMfipvBXX4TUKPKDGn2hXXXCQ26autSB9kTPIB6LQfNQ153SW6eDEBkLpDZcRx6kgIQAwcGnY5yVSRgyCB7j8XPEvpZo0jEdKrWttrjy7JnMU4WgXLSQyex9ojbK7sHt9aRPkCOA0HqVnZ6hjfELL//So1EpeHLadDJY3y3OAmRh2jeuqc+8WvdAFLOfsSr2czz33FSbTjNW2d21Ql+OYjgCcgQ19KXGHsmKMEpJ3OYmfM+m9RXZQdNKR8YiBfe4vWf3eWEEof5bI0UVnVa+rhKZZlKrT1GYczz3Ncdqs2pIGgGK6iUAr9sQdjdJfZL7fWZsA6SFywKCruidDMbv2B/zHWzLP4mB90IpJ3hcJvOKtMldoLwK6fSrK7BDRkmGZC4211p6bYIdDhnSktDqwWfGa60EmtumKP524itq2pijMHykzrbJHIeIapzRfAgIoyXBDjjTNOQesiGhcdEPsGUOh
 0dMkr651
 FXbSSOFXNutCkrd74mdbdkXtn3r3R3lk2B+72Pp2Kkbx5Y/oXmrndlprMdlZgl0rj4BDFSr1RjID4xM23jxEedI/r26UaYQSKVkVBKbZ2wBOu6ZZBeURWyk2RMicKz8h73g6iA1a3r0OFs9DwobMfhPCLbL2QgWwaMfNpKaNgZ9Pq3rbDJHmNq+eI18DirUncpIkHWpyz/bTkhy8oe8yISGE4+ihSdl+4YI+MFWbV5XkahzQ8JLr3VV9QkMCL2kTJj4A/nlw5USNTo3gfaVt2wZSv89OABUhjXPOTlsRiIH+y0hBp0IsVA4JYxJhknVSMpz5wwGuUjmLcx/uJe5li5RZaUB8IppP4XhpqdW94vcFKWBiSYQCbUEQVfVXTH55mZNiV/h1P7Iat/hFu5VyOLlIGzA==
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
2.56.0


