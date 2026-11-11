Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92427606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBODQap9
Received: by kanga.kvack.org (Postfix)
	id A1D986B05C9; Wed, 11 Nov 2026 13:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEA26B05D5; Wed, 11 Nov 2026 13:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDC36B05D6; Wed, 11 Nov 2026 13:24:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6288E6B05C9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:24:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E74511C31D7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:24:56 +0000 (UTC)
X-FDA: 85423664592.15.2A04D43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E21B4C000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:24:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBODQap9;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794421495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AH3G4Ld/Cw2YgMeAy/KmwdAu0nKPOp5SWLznGtNiRM8=;
	b=OYYfuPhFBbuEm32QcNRB7mvWeE+TCYWBr+GMcfGZuTyZEWnL1iAwe7jGfVuOVLz2/HGNrG
	e5t6o8NL1syBJuF5K7X/tLqHYYLxA2h8EGsuYvR50BUFRv5Sz3d25HfSgdOI7vVIZnX8gm
	W4EDCjdClKrS81kj+lDt9a55RIzKSWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794421495;
	b=2RMLaiq1vMXW/WHP9SUSjXqDA+jrMw5EROCsAMa1N1QBAeIoPg00+XUCCffskKqsQFWyBw
	vLl/H/7B8wYZf4QM52Qeg8vm1hcGj7q5IZ9rcFaPekAWJ1hXLi5tcodOaRNrB0IT+5sVXT
	Mry/QE+yt4oaBsBYUfvPztHSShTTC7M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBODQap9;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2210045836;
	Wed, 11 Nov 2026 18:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0986D1F00A07;
	Wed, 11 Nov 2026 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794421494;
	bh=AH3G4Ld/Cw2YgMeAy/KmwdAu0nKPOp5SWLznGtNiRM8=;
	h=From:To:Cc:Subject:Date;
	b=aBODQap9Whfj8W2pMoHX8qEUEl0vwV6jfWDgC/N7NLqQkhX99X7SA7VEe8ul6+gkj
	 jQeRl06i9VN4MxVr0balWW5uM0GfC3fA+y/yzdSRshEGn+ZTlMmagNuC6HdpAy2l8f
	 7DcAPWCQ5uhrMT/G8lkDIqG3o+0Y4s7GWKNmFXL2O+XA10jWHwbgrlU1tTgkr0QMrg
	 wCaONfkUrZYOLbsAdn2O2Rco52HJSKozuzlDzutgnWKr1Q26mEfzxSffD3I9fkR3My
	 oHKWv4RSP2vZZiuPxYoiRgd/POF6+6SVCPwe8t4rV2R9//71T2hxg/8zza8DPp6iBs
	 6JQ59wW99+HhA==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2D70B198003A;
	Wed, 11 Nov 2026 13:24:49 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 11 Nov 2026 13:24:50 -0500
X-ME-Sender: <xms:8LL0ahgMC1sdqltW2Qo3f0WrT3MZ--3w2nI1U9MuKGqsoB3f8wN9eQ>
    <xme:8LL0avYBGHhtPvOReDD3bYzTf5BnOozVpAswS2KAuAPHR69TDO7qfk8iPXKmMPbVq
    sYPy-woYcNVcnKj4KXbm5aJxZEqXt3AR1PD1iF2ASgBp310lSWnmCjV>
X-ME-Received: <xmr:8LL0apkXw6bL8ewsmZAqDvkZ5_s2ijQFQkolTjm5HTtDw_5FakQDWxTF46Y>
X-ME-Proxy-Cause: dmFkZTG2wF4Dcbvhh7gz8ExlXKwNmF/VlJm9jIhvBywTJn4RMzX60KMrFIt260tiGp3huV
    9loRqotF8zi7MdcgMxVqASC12iSUZLWUGDdCWc9jof5PS1StOs6DX3KySpf23UHeCSfyyG
    E5DWQfJRHn46Jdw2Th1Vk0cLz0xJsVv7gt9a/Au7ONtW2Yq3ff74pd/XkKxGiJ/ik5TogK
    UDNtQajjfl+Pp9mSMi05yIt+KwLx/h972BRj/zMDCbhijKgzvjTsL9I0o1vS5bDIPKQLqb
    r+IuBJHBy4S53FF5o0bRQse+zPwebOp5sbw1Oqv3bRoexrLIuj1sw2XO10iVxqypbt4cDx
    EWj9i5/lWdJIBZRe7s8Yyz8BykkURsWo471Qx48Bx8wPKiKqjtDqdofxT8Qm0LFgrWbHvB
    SNMLnQWTltAC6Lzzjw5wuFOsaECoQxtoqdTrWG7mNJAWU9zpscPr4a03UYnigCJHNd5CeG
    CbIDaERAAbxRYBn9o66xgZ1GoDFNFzGz1QFrs4o/lCA12Ls6E4Nt0vcF66Y/Bob1HwuxC8
    tI69DRgQAnD/OrkW+/PVE2iaLSYOV8Ms3gTUG8djydzX+puuokedYPb7Hq7Wldzygm1dWQ
    xAQJvih+ljNWUNAcmgjO1l1jQ8bNfyBEYZuBOqXVQdSlBUf2R5FVbQwUxuEw
X-ME-Proxy: <xmx:8LL0alwAifPlbgw1trr7V5-hkxLfzXtYFLUvvY6_flQbJg3_cuESpw>
    <xmx:8LL0av_UJMOuM9gr7u5epFKeLP8ZtjxuXgxpHy8EKThUcK7tYpxb2w>
    <xmx:8LL0aoCUoVhow7ddQF0-izevA-QRLVwf0C5blCDSMLeQS3vtbEEMHQ>
    <xmx:8LL0aurcLIg-kluuma3o9aAfH0gugxHXlkXoTb12W0QPlbH7zsXDAg>
    <xmx:8LL0aokKkSYlX_7tltQzCEV4H5NhoTdRgh_8qWKkpnVARBzW8STPJ7N1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 13:24:48 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3] mm/memory: refuse to map page cache folios that are not uptodate
Date: Wed, 11 Nov 2026 18:24:43 +0000
Message-ID: <20261111182445.656620-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: mg59kztxoksezqyq11u6u3rczshh6odn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E21B4C000A
X-Rspam-User: 
X-HE-Tag: 1794421494-89527
X-HE-Meta: U2FsdGVkX1/LJXd20LpNY1/fNGn4m1PVHKTts0vsvgjm6ez77Yz7MdV6sTp6jGSqgEU7UBgiXCJE/dizWAMJ7hy+BHzH2kHxQ6HYcd/7noCPxc4KbVe9A1pDL+SRe2QBYwkbmyH1zXKUvU2S6dSQdKTdxT/aMRjrHTOxCknjw2JDHajCMLow/HgN4D52r/zZQi/T0ebdvxHHzZZADcDv+7GoEO++iCyH7nSqQKhqMJSgSg7vfQOj1fwbmfBugnKWZOdcsrj07yuuiAP9As8N0elk2iMkSornpadNHA3QmJ4xBtTA3KMPWZT9RIHzV7w3TOti/DLzQhurwBB/KJMfl60wjrfJ4KjCvi6lRlCI9zliGFdd+LKwZ+rZ86tqFKsMqmlPkQlEXreDOZsh3+jBUj/nCkSkTGE7lsVmXpYACXsTqAeS2wI+2EkXg5ytxjoUgl2u11qWqGB6DBWOMf76bJp5n+Yj0s+QmyMEnqs7iEUR4e+Cwnq+BvAOxplPcRWwFspqagnXDHf2BhFpFJqYXow3th8qiVgT9AfhkiPPkoi4ySKu7YAIcyutbnUrdnTnVRNx7U26xQ5DpORRnauHIkdLD7l6sg/jRvSH8X/Vj+N4u5rRNbuE27mYoER1N6ssVMiJKvSDSlxV1YcsgzFDNtbbXMnrnFDIYv7nCNfAXdT8ilwmwdDldoQrNdmdO+oDCLoZOn6xjY/xxDJbCWcEkrtu7DU3lU/5LWW9uojthUmVehfyXx9DbG9qKNzRAOIvvU8hNwc3A14uoEjng8hGPwakUHl0dCQaWcuI+w7XluNuGlF94fKebMBBegwno12fMpzg/KeWYUcbpxlMCXi5pGCPsFknUplBO8LK3AAWvJogntBIQWfO5Tc+K+kPBvjx6uaAhpcCeVebieeJrfMEh3T7l1aX72QAFah7n/1GVZOsiKg+GFgDvp0jxm+YsUhDqHYXHubg8d6Tx1Nia+Z
 Mw1bKeBY
 IDk7KYesDkLdOCfme9aIvWpTROaU5UWyKNuv2tHn+aMrUpd6ZkoiMQ+yzM4kuFr9BpullLt1Lm88GEr3eL+fZJIagXfEad6YfKa8PAL/EW0gJJasI3tyhbLFWtMYIYwYdDDmxWpdfzcbGDhzzyf2JAKdTIGMb5E7JeC0zIM3wTl+fpLi2Ne+4UC7aWWwTZsL+BYZLyWMtrblY/6CZ2EKQ5eseYdjjKaUIFCdqNvhZJNC0J3zbMpiyBlMDiEu+PGY7Kt3JT2H61DXrXUwl0WWK8vqvLffaiuN+pkS5rnDUyle/80g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A page cache folio that is not uptodate holds data that was never read
in or cleared. shmem fallocate(2), for one, adds such folios and clears
them only on first use. Mapping one hands userspace whatever the memory
held before.

Each path that maps page cache checks for this itself: fault-around in
next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
Nothing in the mapping code does, so a caller that misses the check
leaks stale memory silently. MADV_COLLAPSE did exactly that with
fallocated shmem THPs until recently.

Warn and refuse the mapping in __do_fault() and do_set_pmd().

__do_fault() checks the folio ->fault() returned while it is still
locked. For CoW, that is the page cache folio that do_cow_fault()
copies from. do_set_pmd() covers MADV_COLLAPSE, which maps without a
fault.

do_shared_fault() then unlocks the folio for ->page_mkwrite(). A
filesystem that clears PG_uptodate on a folio in the page cache is
buggy, so that window gets no check of its own.

The fault gets SIGBUS, as for a folio that fails to read in.
MADV_COLLAPSE fails and leaves the range to be faulted in.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
v3:
 - Drop "mm/memory: recheck PG_uptodate after ->page_mkwrite()": a
   filesystem that clears PG_uptodate on a cached folio is buggy (Matthew)
 - Move file_folio_not_uptodate() into this patch, assert it never sees
   an anon folio, reword its comment and drop likely() (Lorenzo)
 - Rebase on mm/core.git for-next, which has the MADV_COLLAPSE fix

v2: https://lore.kernel.org/all/20261109120403.82361-1-kas@kernel.org/
v1: https://lore.kernel.org/all/20261106144323.3634477-1-kirill@shutemov.name/

 mm/memory.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index fcc7ea2a00d1..c79c1c6f6141 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5641,6 +5641,22 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	return VM_FAULT_OOM;
 }
 
+/*
+ * A page cache folio that is not uptodate holds data that was never read in
+ * or cleared, and mapping it leaks stale memory to userspace.
+ */
+static bool file_folio_not_uptodate(struct folio *folio)
+{
+	VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
+	if (folio_test_uptodate(folio))
+		return false;
+	/*
+	 * ->fault() can also return driver memory that is not in the page
+	 * cache. It never gets PG_uptodate.
+	 */
+	return folio->mapping;
+}
+
 /*
  * Either the VMA lock or the mmap_lock must have been held on entry
  * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
@@ -5700,6 +5716,13 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	else
 		VM_BUG_ON_PAGE(!folio_test_locked(folio), vmf->page);
 
+	if (WARN_ON_ONCE(file_folio_not_uptodate(folio))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		vmf->page = NULL;
+		return VM_FAULT_SIGBUS;
+	}
+
 	return ret;
 }
 
@@ -5745,6 +5768,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 		return ret;
 	page = &folio->page;
 
+	if (WARN_ON_ONCE(file_folio_not_uptodate(folio)))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * Just backoff if any subpage of a THP is corrupted otherwise
 	 * the corrupted page may mapped by PMD silently to escape the

Range-diff against v2:
1:  632ab50e643d < -:  ------------ mm/memory: recheck PG_uptodate after ->page_mkwrite()
2:  1e329f330c41 ! 1:  50ea9bc46c05 mm/memory: refuse to map page cache folios that are not uptodate
    @@ Commit message
         Warn and refuse the mapping in __do_fault() and do_set_pmd().
     
         __do_fault() checks the folio ->fault() returned while it is still
    -    locked. do_shared_fault() unlocks it for ->page_mkwrite(), and a
    -    writeback error can clear PG_uptodate after that; that case retries the
    -    fault instead. For CoW, __do_fault() sees the page cache folio that
    -    do_cow_fault() copies from. do_set_pmd() covers MADV_COLLAPSE, which
    -    maps without a fault.
    +    locked. For CoW, that is the page cache folio that do_cow_fault()
    +    copies from. do_set_pmd() covers MADV_COLLAPSE, which maps without a
    +    fault.
    +
    +    do_shared_fault() then unlocks the folio for ->page_mkwrite(). A
    +    filesystem that clears PG_uptodate on a folio in the page cache is
    +    buggy, so that window gets no check of its own.
     
         The fault gets SIGBUS, as for a folio that fails to read in.
         MADV_COLLAPSE fails and leaves the range to be faulted in.
    @@ Commit message
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## mm/memory.c ##
    +@@ mm/memory.c: static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
    + 	return VM_FAULT_OOM;
    + }
    + 
    ++/*
    ++ * A page cache folio that is not uptodate holds data that was never read in
    ++ * or cleared, and mapping it leaks stale memory to userspace.
    ++ */
    ++static bool file_folio_not_uptodate(struct folio *folio)
    ++{
    ++	VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
    ++	if (folio_test_uptodate(folio))
    ++		return false;
    ++	/*
    ++	 * ->fault() can also return driver memory that is not in the page
    ++	 * cache. It never gets PG_uptodate.
    ++	 */
    ++	return folio->mapping;
    ++}
    ++
    + /*
    +  * Either the VMA lock or the mmap_lock must have been held on entry
    +  * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
     @@ mm/memory.c: static vm_fault_t __do_fault(struct vm_fault *vmf)
      	else
      		VM_BUG_ON_PAGE(!folio_test_locked(folio), vmf->page);

base-commit: 8d21e3d3faf19f461f6d0380fe8a1f5bdba97f25
-- 
2.54.0


