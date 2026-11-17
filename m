Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933BF606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YehFc1te
Received: by kanga.kvack.org (Postfix)
	id AA2DD6B05B5; Tue, 17 Nov 2026 10:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53C56B05B6; Tue, 17 Nov 2026 10:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B886B05B7; Tue, 17 Nov 2026 10:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4CC6B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:58:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C643880503
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:49 +0000 (UTC)
X-FDA: 85445069178.02.7D1FF4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DE7718000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YehFc1te;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931128;
	b=rLWT3KTNeUuc3IGyijrlxOEBGcCojUjibkgSyxkg+kdTWClItmZUkISWfFnVrHoTFHJX4t
	5rQjNRRN7AfG4AUEFBrxkwSL5gPIjemPyQHej99k0HGRd6CTGZ3hzrVgkc1RvLyU3XUKsD
	zIeDvdJfcdWBurtMaAdZhP21Eiy/wYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YehFc1te;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GI4ugfB0NhERLBcfl6RxPS7mnQ8nFflwnbD21DK5LkY=;
	b=iSanyJGMWZD4ja3MZAnImxmZ1bQKUa12RBSkcb/9yzv716S9kZ7iUehUp4BEAJeGDsaTbh
	1lkO35bBbZwXU0pIgsg6CTJtCC3LvBSV/g4YslNbcvFG8LHdrHJ/cELU/dPRex6+k9lT+i
	dtRG6u24sBj6goE2WfkS/4jYYd6KYm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6E6460F97;
	Tue, 17 Nov 2026 15:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0424A1F000C5;
	Tue, 17 Nov 2026 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931127;
	bh=GI4ugfB0NhERLBcfl6RxPS7mnQ8nFflwnbD21DK5LkY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YehFc1teF7lgykIn6zq9Yqg92QRiGkaofJEJhHVhBokkAX8uW89aySOAkjns0nV9T
	 Vx9Tu2PAgGPFSEcwtuEHfiiw+2q84OhVlQzZjITWfm08mwB/PI6xPajjoQvcEpZQ00
	 v/xG6IZFc4JdjN1P0EYGBEqi1kELFgmHm136qTFfIl9vHeMig+UMckDUTCRO9xjTD7
	 //34LXR+3xB/loSMa8AiKDJxUgESpU+DH8AZXhL+vfhVDfMJ5yHin2KQ9cQ23GCJDr
	 tuM3cfl+q5Irlta/6AcUL4JT/AcGX2kgKORTrTLj3UBNpmqkSTdZD1mQNC8bfU78E3
	 DQ/G7eoeSZ2kg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 17:58:33 +0200
Subject: [PATCH 2/3] mm/memory: replace uffd-wp markers in
 insert_page_into_pte_locked()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-2-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DE7718000E
X-Stat-Signature: 67ch1oc9gpg3haeftsks495r8cokh3zb
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794931127-23391
X-HE-Meta: U2FsdGVkX18J1dzL3YKxFS8expEDcabeUwFpSGIA8bOgKfUaDl0dMbkLgy/SHuvzw+V/NQRNUZaCwzFGYQlsGN+Cqgti/9+irS1uJuGBSJIr92Vr2uRyRAg2pHqMs7cY5LdLUOXovZ+sQ5t0bUgdwoQVNEVVs9I43snHUarNQW8tq/exvMXg/uIMwZ4ESX9llxTFmJoq3aES+WcZix7pgRgB6Q4BdsyIUGgz/Cl8DCCFJnvbhOEFvh/WuxH4maXE6aZHyUFIOgTFyh5OjJ3xU/bi72sBb1maqo0Re/U6yEf2wTkk/IM30Ub+g+KYnB4eDTSY0JYe8k2DHF6wbuI+EYYorpCcGmo39Y2lZjR1NFepIPdcD0lsyRFa3fQYrKuNg9/leQgyFNM/BN3VItizVVD76NKnYLoiOFecaesl7BGcd+dXKkgE18cD65Au4vxoMHnS/tQwllYBWyqlqMEFUEw7jSBZy22pbFGRRYccRmYGw9J6cTLbn4/bwvkkFu6JBAxYZSQTc/MZkdpgYCmJfy0M6pgincvSu7RJpC5w6jxXVungRSZHSboDWBgmyk6j3gfGSpxpAJ36ctvYL7uYVBQmpRTL26g1Oct9hQW3fGv7NH53dWTUxOQO3/aoZeGuwo+qtiD+ZfvyGESH5366wJUXnHZw6n9tZGfNd2ul6kYR6Te0dxp53TbGeI/NeFqV1vjHbysy3XbbblC+0RCNY+DafxY9KlutYvqrvBbYro/Wy/BlTTJzVpq/vg3gWV2GlYum8S3QWPa69S7Jr9oQWuQVSGcWQ5STJKoWIXzhObb9x1xI0Zpzcvw5vOBPMHPPT+QADOndf6Obdt2uFEWTW51G2CjCggJF5xGunXDtheKY9nqf0z0HRzSUEiySRXU/2Vv2yW1cvGGq3x8zz+kFc0tZgUqdl9gc9Bw9GwYpgFKfTcuEtfGQoiFCJuIHTNlUHICdtCT2jcEHiJ021is
 5BBsi969
 zpEThP/75lUvmXjFUdzGOR2S/4cZhG79K9VKFb73zJW0KUqD76MPyMCt7Lg4AEUlgWoFZLl2eBXS6vbzOc8F1L/3mw4Fk+owlje3y+nkoAso7uObWBDl+zm/88toudNGJUgHbjRr/YkQz1Z5/nT214QYEteLwsu9iJsvAHjb7zAhW3pkGeoxN6lpTkVS9v/HNht5gfM4txCX76y4DZ4xnWguxhBwqdCOPVHH+X67NcD6uTfGXYU+RbTZbMFm4etBPasz02A3Glk2aj1dGq7k78GMRlQPFMm/cpXJB98ou6Bopgmg3E4016ZI8JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With UFFD_FEATURE_WP_ASYNC userfaultfd write protection can be enabled
for DAX mappings. Write protecting an empty PTE in such a mapping installs
a uffd-wp PTE marker, and so does zapping a write-protected PTE.

A fault on such a PTE gets to the DAX fault handler via do_pte_missing(),
which eventually calls insert_page_into_pte_locked():

  handle_pte_marker()
    pte_marker_handle_uffd_wp()
      do_pte_missing()
        ext4_dax_huge_fault() -> dax_iomap_fault() -> dax_fault_iter()
          vmf_insert_page_mkwrite()
            insert_page_into_pte_locked()

But insert_page_into_pte_locked() treats the marker as an existing entry.

On a read fault it returns -EBUSY, the marker stays in place and the
access refaults forever.

On a write fault it extracts a PFN from the marker and fails the fault
with SIGBUS:

  WARNING: mm/memory.c:2486 at insert_page_into_pte_locked+0x401/0x410, CPU#1: repro/151
  RIP: 0010:insert_page_into_pte_locked+0x401/0x410
  Call Trace:
   <TASK>
   insert_page+0x6f/0xc0
   vmf_insert_page_mkwrite+0x31/0x60
   dax_fault_iter+0x3be/0x5f0
   dax_iomap_pte_fault+0x1b8/0x390
   ext4_dax_huge_fault+0x1a4/0x2f0
   __do_fault+0x34/0xc0
   do_fault+0x179/0x610
   __handle_mm_fault+0x943/0x1250
   handle_mm_fault+0xb4/0x290
   do_user_addr_fault+0x15f/0x730
   exc_page_fault+0x83/0x190
   asm_exc_page_fault+0x26/0x30

Replace uffd-wp markers with the new PTE and keep the page
write-protected by setting the uffd-wp bit in it, like set_pte_range()
does for other file mappings.

Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
Reported-by: Jingyi Sun <1045704958@qq.com>
Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index f927f2241e40..66ad58429967 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2452,8 +2452,9 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 {
 	struct folio *folio = page_folio(page);
 	pte_t pteval = ptep_get(pte);
+	bool uffd_wp_marker = pte_is_uffd_wp_marker(pteval);
 
-	if (pte_none(pteval)) {
+	if (pte_none(pteval) || uffd_wp_marker) {
 		pteval = mk_pte(page, prot);
 		if (unlikely(is_zero_folio(folio))) {
 			pteval = pte_mkspecial(pteval);
@@ -2467,6 +2468,8 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 			inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
 			folio_add_file_rmap_pte(folio, page, vma);
 		}
+		if (uffd_wp_marker && userfaultfd_wp(vma))
+			pteval = pte_mkuffd(pteval);
 		set_pte_at(vma->vm_mm, addr, pte, pteval);
 		return 0;
 	}

-- 
2.53.0


