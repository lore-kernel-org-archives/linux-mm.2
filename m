Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A9F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eg77k85J
Received: by kanga.kvack.org (Postfix)
	id 0E4EB6B05B7; Tue, 10 Nov 2026 17:53:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBB96B05B8; Tue, 10 Nov 2026 17:53:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001756B05B9; Tue, 10 Nov 2026 17:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE12C6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:53:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44F00A732D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:29 +0000 (UTC)
X-FDA: 85420712538.06.37BF666
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5580BA0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eg77k85J;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351207;
	b=KSgc/ODb4I83f9TlPp4lPlf55yK1LwGyH1HVzyUI9P9euIQ0wPsbWrZPNywZExYN0QU6It
	x9+wannv1xSpZ/3DvO17zHSASc15K4em8LYI52BtsPdKHnrOse6qSFQJSCfoBhV0kgIyuk
	EcnPEhZYn1cpQC7lYK70wjcrrbGh46s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbpNJXzYoqPd4VfqV9VFB8azfuYpEDyQvQ4rjCYOYeg=;
	b=QJuJa5Cqrpukl8GeF8Bdrvu9vZ4DoqKOwTs+N/pRO33aTtuzCSxtVSdGODDF4qFbOXtpgw
	orE/Ju4fqqx5p9k0AU9snTdpzGnbdtd4E8XHEuzys56VDjn5alrreH4MHPa6zAwWKPrGE1
	caHrzZq6bH9U/KQyVYkwb+D9PD9am8w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eg77k85J;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B060B1D34;
	Tue, 10 Nov 2026 14:53:23 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87C6D3F85F;
	Tue, 10 Nov 2026 14:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794351206; bh=km9gKyPNIEGHowwbPNAwa8hxGTvimZnmSsS4JYV4E0w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eg77k85Jdy0+R16HKJh9Lw6CgTedDXPN5B/c/9QnFId7wsvE4FclWxbYLQvd3ybje
	 u6xtwEDg0GQdaBTIHac/ZHyGCKYvZvuZqt/cI12SfuyhLaSKejsqjPSY+ghPYgabc2
	 TdyGJYgyH1CssbFRkK5hmDp1SSU3KF+XhRNfmiAY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 10 Nov 2026 22:52:56 +0000
Subject: [PATCH v4 6/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refactor_gup_fast-v4-6-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
In-Reply-To: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7028; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=km9gKyPNIEGHowwbPNAwa8hxGTvimZnmSsS4JYV4E0w=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq86BU67PUYgzIaGvlXWmCR42RxyK2ZX6Tz05Wz
 QEq16IwK2eJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavOgVAAKCRBt1cPRWsUx
 M7kzC/9dOSoDeMINM4IeowxVidTgidaBqPtBNywryTkYP8YvLFcq0nk//vvMBMmuY3l4NGAPYc2
 zIS/2L7dyjEKiirwdWzVLPT8M86NqRwZ15nf5ufrBtDg59TkDDn+Y+CtudSCu7aXeto3ZUAErG9
 SGiC9s2RTa0QaLqkOCue03D8cnisMk0/IIPgs1tt/Yt1JM68l8j1SZ2SaveW20zjjyypEbkoiZt
 WcPbQjuU2mvfqEBA4b5OcKZtCkRoIjM+Gq/DVm7HxMDiDVwkzA/SdeqDmGrR4owCdHZ8Syf48Cm
 oBuqKx7ECAXJ7zqnhnWOAU84g9P/uhId1eZvXGgwbpGV3p7+N+Beec7nuhEmjHObNuP3pLGEcme
 kduut8e9HR988nZhvPsWxFPUb9opwzvFCVEDnQbMEapX70k3O8Ly8gDXPvQYyYwoNFn6yROJ09+
 BYNEmLzMGSrvJtrtRtAJ0EA0viYbOZxdcAkRP7TJks8CjnMETpxJy2hEAG0ea0aAauXtw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: 5580BA0004
X-Rspamd-Server: rspam12
X-Stat-Signature: xhkocuff5uf8h8jbqgaepz8cr4wpy4cu
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794351207-971025
X-HE-Meta: U2FsdGVkX1/e0SpyCfX09knukBWYPpcugFvWbkVh2AgPvV3dPj+LtvsW6fnCZHJSqhoBnAPzVQO55oOk9CKVZGXDXoFAan4rIqGxhyl5wY9CzJt9mpVQijytL7V8hNiI4mRzPNxy0jynia4xcREraLfQVCW4YThNkJaPJNes1utlCyNrURPVX7cjhPMlRcgifR1j9LakVEbrPqf3RFPrbUxC9yWcwerAE47ZMKvH9hwiXwAkMSZask8CeR1nw2nLAc1HSQ8gOgb2nOASkjqVpfTqdihCsjXmWbK0CAog0NGXfz2K6bAmepIYDaK6cwq/NvIgXtCNcy3s0VwQj+A9OSFrrXGc6oXVIu57sMTnfwTMfY4co1iBu68banCoyTSiqHjMLq/fsjb/AB++zj1DmovwqDXmUYyzZ+yzHhwl2FEZ3cUi0JwJbhZahjJppGsubyCl0Jcy6MQ2lSfWq/rDHVhuaLLYlEZr9c9sMAJFxVbuli8lgISg9mv75Oibk5U9Iz6YF7vBArIWoZdWwWfo+o/afP7t4Jjqu3chHTHQaOkVM8taOKZZQ56znkJE1XZ7CErEOdgBJtJ0lUfozWnf6XZHKj9HXrI+gWbAqjw4qSt5ncgqdrJM+0hDYIWezSNO1H/U5itPXknerY2z0SvIkgHnuTh/QB6Yr5WaE2eeWkrvqjSvErf7pSmD6xVUcPXPKnWFgb1Dhmkf3bpW5sx24JGy7aifMoniMLOoN4QPGdb3rV4gb9V2/uy8frx4j+CSR2JWiZcUCAarIASacBTob+qPnL3T8PTFw++Ab+WIfmBjchXzj8fgnYPbNNFWoywUx9MxN3k4InVJLlek7wkvA43keHVtjiFVHrKvFhhWItPXz9dKJNZpqwU90qKDZj3gxGbRaY5zvyuUoppSFRpDeyo9cMtYBFhuqNUZqk+51dD0BbIADIxQ76itdEa25LxNfXfE639dtELdF0aOJPP
 tk//45+h
 xW/Bk3t+Dzs5IgS67QGWkzytePpi9tLztoN4FXc4BMythW4BiaMwXW3x0sgODZk4DwYhYHjuBh4t97fXbRDMRG8aj3qBQo9buape+sRmU9A3QfyooriVuMmAosaTY+G6Sg9LUV31A0Ju0ASlcKxC618yfRpuJViC6qX5JF6xpq76+3AUqCwkqA0/S285JNh+4PzlMZ4JLDk6SANxENzZ99Ka+IBEQta1dEpM53paPpONWYhPMnOldDNBZ/+OAzltKsaSEuPSWGUGYiP8z/CpzWqXWKUpnpgAR5ntMmQqeVC6fuOp/Odgb4kt0xaATiUnoZ/PeBY2UPum3Xxr/94ms23j5IJ/L9b7Pv86zw6UVz3KT6/ShEZE0BUhK4X+PW1vxRCCdzJtz0VDkmPaMx9bntNnufRxidzOLpVVmbuPO86/8SZW3krEjg6m79DQqmL7ZeuzCzGOUtgLeszS0VFhPbgmMyL+CxvPF5V1bmHgcIIz7E36ZWFHtKnMT4NERgLLjhAlMZIca9+phbEuU+VfpndWPBBAxcKqE2YqaWoBtraLiaTDlY0wfnFcmDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
atomic, a full barrier and a node stat update for FOLL_PIN), a
gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
pays sixteen of each and a PTE-mapped 2 MB THP pays 512.

The users are the hot ones: iov_iter_extract_user_pages() pins every
O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
buffers through it, and so does RDMA memory registration.
With mTHP those buffers are PTE-mapped large folios.

After the head page has been grabbed and verified as before, extend the
run to the following PTEs that map the next pages of the same folio
with the same protection bits, take the remaining references for the
run with try_grab_folio(), and fill pages[] from the run.
The PTEs of the run are read while the reference on the folio is held,
so the folio can neither be collapsed, freed nor split underneath the scan.
A read-only run of an anonymous folio stops at the first page
that gup_must_unshare() rejects, so the per-page exclusivity guarantee for
FOLL_PIN is kept.

folio_pte_batch_flags() does the scan.  It reads the entries with
ptep_get(), which is not safe without the page table lock on
CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
site, so the other callers do not change.

The order-0 path keeps its instruction sequence.  The folio flags are
tested before folio_set_referenced() on purpose: a load of the flags
right after that locked instruction cost about 25% on order-0 pages in
the gup_test benchmark below, and reading them first brings that path
back to the baseline.

gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
per call, median of 15 runs, two baseline boots / one patched boot, on
an x86-64 VM:

                       get_user_pages_fast()   pin_user_pages_fast()
                       before       after      before       after
  4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
  64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
  1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
  2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
  2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us

fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
buffer in 64 kB mTHP, median of 15 five-second runs:

  bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
  bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
  bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s

IORING_REGISTER_BUFFERS of 1 GB, median of 15:

  64 kB mTHP           6179/5998 us  ->  1599 us
  1 MB mTHP            5790/5801 us  ->   893 us
  4 kB pages           7173/6741 us  ->  6763 us

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Co-developed-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c | 65 +++++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8ef41353afe8..b0a0019de80a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2936,7 +2936,8 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages)
 {
-	unsigned long nr_pages = 0;
+	unsigned long nr_pages = 0, nr_batch;
+	struct folio *folio = NULL;
 	pte_t *ptep, *ptem;
 
 	ptem = ptep = pte_offset_map(&pmd, addr);
@@ -2945,7 +2946,9 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 	do {
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
-		struct folio *folio;
+		unsigned long i;
+
+		nr_batch = 1;
 
 		/*
 		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
@@ -2955,13 +2958,13 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		 * permissions.
 		 */
 		if (pte_protnone(pte))
-			goto pte_unmap;
+			goto out;
 
 		if (!pte_access_permitted(pte, flags & FOLL_WRITE))
-			goto pte_unmap;
+			goto out;
 
 		if (pte_special(pte))
-			goto pte_unmap;
+			goto out;
 
 		/* If it's not marked as special it must have a valid memmap. */
 		VM_WARN_ON_ONCE(!pfn_valid(pte_pfn(pte)));
@@ -2969,7 +2972,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 
 		folio = try_grab_folio_fast(page, 1, flags);
 		if (!folio)
-			goto pte_unmap;
+			goto out;
 
 		/*
 		 * Recheck the PTE after grabbing the folio to detect concurrent
@@ -2980,19 +2983,25 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		 * would not detect that we are walking a detached page table.
 		 */
 		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
-		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
+		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep))))
+			goto out;
 
-		if (!gup_fast_folio_allowed(folio, flags)) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
+		if (!gup_fast_folio_allowed(folio, flags))
+			goto out;
 
-		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
+		if (folio_test_large(folio))
+			/*
+			 * The reference acquired above keeps the folio stable
+			 * for the following checks.
+			 */
+			nr_batch = folio_pte_batch_flags(folio, NULL, ptep, &pte,
+							 (end - addr) >> PAGE_SHIFT,
+							 FPB_LOCKLESS | FPB_RESPECT_WRITE);
+
+		if (!pte_write(pte)) {
+			nr_batch = gup_pages_not_requiring_unshare(NULL, flags, folio, page, nr_batch);
+			if (!nr_batch)
+				goto out;
 		}
 
 		/*
@@ -3001,16 +3010,22 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		 * see Documentation/core-api/pin_user_pages.rst for
 		 * details.
 		 */
-		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
+		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio))
+			goto out;
+
+		if (nr_batch > 1 && try_grab_folio(folio, nr_batch - 1, flags))
+			nr_batch = 1;
+
 		folio_set_referenced(folio);
-		pages[nr_pages] = page;
-		nr_pages++;
-	} while (ptep++, addr += PAGE_SIZE, addr != end);
+		for (i = 0; i < nr_batch; i++)
+			pages[nr_pages + i] = page + i;
+		nr_pages += nr_batch;
+		folio = NULL;
+	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
 
-pte_unmap:
+out:
+	if (folio)
+		gup_put_folio(folio, 1, flags);
 	pte_unmap(ptem);
 	return nr_pages;
 }

-- 
2.43.0


