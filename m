Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E30606A335
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2cip6gm
Received: by kanga.kvack.org (Postfix)
	id 236E56B05B8; Sun, 15 Nov 2026 16:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7BD6B05B9; Sun, 15 Nov 2026 16:00:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1249C6B05BA; Sun, 15 Nov 2026 16:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBB126B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:00:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E1004082B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:00:08 +0000 (UTC)
X-FDA: 85438570896.25.1022C55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B34912000D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:00:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2cip6gm;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794776406;
	b=XYdD+DtAru+J3+LsxrzCsiYTuXI6oS1kbWPbqgQuEqTUKFtj6Rqf5saKdy6nhUtWrU3m0D
	RaDahR4kJ1uQBZanDH/Y7AjhR+hEVXdWoqybyDDjFSPqA3lCqyUdU8yZjYz5ZW9kK6wOOI
	wm8uo7/tSs5wJRYInpKeSiq33fTr89s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2cip6gm;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794776406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeV6YEX2bH1ZNj9o0DW+0ahAYdvJN/jsXTtdRU8/9AI=;
	b=Sj1IL4tgGl5GmqCYDTJ6uvhfVeCY9/abvD44fmlwWaKtKNYcoXVf0ikNoRxqRKygF96QJz
	gxy95gIhmNgtUq4BE5FqesOgbRT+wbZihZ+E0ffEM9aomqh3U1T6pH6vh74gViAAMzY5jN
	T4dh9ucJ0YfRR5HQJkG8cF6m/3gVlBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2FB444F11;
	Sun, 15 Nov 2026 21:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B013D1F000C9;
	Sun, 15 Nov 2026 21:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776405;
	bh=LeV6YEX2bH1ZNj9o0DW+0ahAYdvJN/jsXTtdRU8/9AI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T2cip6gm8gB5h95y1ybRRsuA+GQPaDaTHCotw5DYJinkceb7agyh9YzpHtd/ZEFQb
	 m2LT8aDhL4DfNsxEZNB9+VGr+mEgYXQdLRGIo8WCwWeZuj5gGy2RjGH9U6KEFJX417
	 /JxhVXOHxbIt1IMPriPNrf0/4Qyw0v4mzLZ7z0Mg58Y2UCXk7U7pgSFCDgzsxQ9kTC
	 U8m2Fdyz1h8vxmjkgh+hOD/1cK7MT52qmKyujfXFv+UDn/JVUOruPqpLYtU5MMCNGH
	 CSMCTJEhIzT8RMee8Cuy8IF9YrQHecKhSHE0j3z4hBVvgBARrEygKu0+QcQKpInfF7
	 Wa5ztp6frLqxg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sun, 15 Nov 2026 20:58:22 +0000
Subject: [PATCH 3/3] mm/huge_memory: only compare PFNs of huge entries on
 huge fault insert
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
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
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2744; i=ljs@kernel.org;
 h=from:subject:message-id; bh=WviD5NyuI8opANfsL1TGM2rHrGogh6uBq1tLgREc0rU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ+yTrZHDqktpfZQmBWYV1LwAvx+w+yrrsrn5JO1fm76
 //3l7++dpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAim6wZGdb/XdPJ9UmSpWa7
 UvJV+YwdybaGkhE9SxhW7+ZdZGaxU5iR4cner53/r/R9P5FSLKSasu3KK1HNtJWbjjuvnHTj3wG
 xrZwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: yhcbnytokumnua387pygjqcw1brmmpo7
X-Rspamd-Queue-Id: 7B34912000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794776406-647635
X-HE-Meta: U2FsdGVkX1/KcJXPLgcN2ZoVT//1sXwLSvmHCSy/iOqyFrZNNl29o0ZvRzgc69VtUJfA0jDiWdj/hBxglklZqTnyMtP0La8cYML3Xe4S9AMFRqGtGYDzWqjkiLf4iufaaROy+qZP259qua1mSztUfVsOJAe8532ZlWqC2GbETz0QvD2pFhgg1RtjrsFSaSfBBd4LXVCsK2ti8fqlgHkgre+H/fXGVayeHrmJZftXqsvTryYPaHITa6PCn0TkF3heQhFe4wFHph5gNzw3a7ZHaE36Ld+UilD+dM13pYTmBxKwJ6c+UW5WwK1AO4y9AfXFimai4rMA4wlb/bgUndfk1f556l4j4jocr38iDF8KEAXLYgKwr7xRAL7onGnl0rM7YqewUqhwIfahIooaogh5aw2ZXq42AEUf3WLClH4vof94Pw6RDyVK4EZXJ90XTg7dAWwmlI/7+112aRmtBPSJwL0IoCbPjD7oigrvgvvZHgWgIn/QFHqEO7hbegTiPFEZs/O0Q5w0R9sn6Y8RCPxVzhYd99ULMaLayKZ8VyxFnKR09DDaYhZwLanq7gmj8XimaLg74lF6PqqQ/hpFA/zeJlJgaEwwBaYo96d6EjkURxl5l7tDonsmhEO1S5AWjLyLGpUJJNc7lfPPGyPVTkW3EV7Ab+O+lwH8+Sr4xH6HQ0V5RiSSoeC0KUeIHw1HWRgzzdIhtiQAe7VEV+oWJIM/6qHOGUU0pa4/YEwbYNISkb921B4Ei5mrthcFfbuR/DYLvf5C2TgUiFHA3silqVXv1V51B3HacHqSvElkFTLBvmPlUMicGePWhVBUUzod9dwj1xOTku3Jk9ViNgXrr7qCs0j5dCI/0qdD18yE3P4BQZIMgi2h0+9HGPf+3SR4IJiKnmFD6EDJvLz2WEOS/70MsCZJLjVQyaxmqzFpc5qiVT1XJ3Zt/z5R0V7nl9z999/CA8vmuD0ZsHijwoXuanL
 zBTZn1Bg
 0bn5imeJp0JDh+IhfHSkFWJQic/AhwaJA87gVAa9eWVJ0c3ykCSt1COlJQvD/Yna1eiAyK+T87D/LyLIo2oxQt81fM/5cxiCWPTwRvkMKzceXd39Gw5KODzCVOwqQvfyduhlMDu72t1HhP2GiWuOaGO8jUgIwSdUrhIahltIfEm+kYiajI/tP5+BNHp0VjJrbuLSlfNJiJEJqFNOuDBrrptljNiW8DF2q/dliYHsJOAUrJ8kIek/gbBkrP/0IzQ7wilh811Sx+vmkTc7xpb+rKXwmJw01RI4UEhosbZf0IuODc+q2BG2CfJAq3ROJgSUpyzJE
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
that, if the page table entry being populated is not empty, it must a
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
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..da632c3e834b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1643,6 +1643,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/* We may have raced a fault which installed a page table. */
+		if (!pmd_present(*pmd) || !pmd_trans_huge(*pmd))
+			goto out_unlock;
+
 		if (write) {
 			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
@@ -1770,6 +1774,10 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/* We may have raced a fault which installed a page table. */
+		if (!pud_present(*pud) || !pud_trans_huge(*pud))
+			goto out_unlock;
+
 		if (write) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
 				goto out_unlock;

-- 
2.56.1


