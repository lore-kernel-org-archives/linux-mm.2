Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C72606A338
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ETwjozXJ
Received: by kanga.kvack.org (Postfix)
	id 1810C6B00EF; Mon,  9 Nov 2026 07:04:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132476B05B0; Mon,  9 Nov 2026 07:04:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0215F6B05B1; Mon,  9 Nov 2026 07:04:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7D0B6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:04:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A67B160659
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:04:14 +0000 (UTC)
X-FDA: 85415447628.16.A1D6EAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6322E140007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:04:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETwjozXJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WjpWwRoUxqORiuW5H8xBd+5jmlpNuL8fp0DqP1kmC84=;
	b=M5jxZ2g2ygtN6sKjg/DZzreiX+ifjLlFLDOK6kBIepylFBshR6nbRa0UwAzEOxblmHARgc
	G/tLeBJZ1hImb13qsy8ZEJrrEQZv7vYQk2auacrJdKc74x/dvwX3t62RdRTEru91GdKHIg
	DY1KeuKbgfBCMA4D7CGO/v3+x8cNpUU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ETwjozXJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225852;
	b=46jULehkIhTVt6DDNVzRsW5FLXogSybMX/mMatlP/ux9iBu/rs8GZ7n1Qj1K7ve/D1xOdK
	qoXRAE+SX8ALthHvSsfcs0J+WH29X3Lxe9hKaCDzSPRLx9aMXJ8sMU0L/Rzw/RUtqDNbct
	0gI55BvQ0+18bwZddJoWW4JfNlbKRrU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7A5140E1C;
	Mon,  9 Nov 2026 12:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA611F0089F;
	Mon,  9 Nov 2026 12:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225850;
	bh=WjpWwRoUxqORiuW5H8xBd+5jmlpNuL8fp0DqP1kmC84=;
	h=From:To:Cc:Subject:Date;
	b=ETwjozXJSSOvcdyCj2pca63oXADmvVfEFkctq61Ao83RAD/OLMfK4ujCSerswmmUC
	 7yrrrWzyxUUyROaKUdklIZlLvFq6Un3l/CFpU0GUvSk17zZw627jgxlyt0Zb1cLnrw
	 X1BEVKKCfTe4IufBNBnifE9/xTCLmUpFlwxVGULaQ6Y8ov3f3jsYFfJhGwJC5EuP1m
	 yshAEdCUITxALtPt7SUgK99yws/hv9UKS/pDwBvccgSRYzCetiq7n8/FmHFMhw7OVu
	 BNHi6LxiY+rsBPzCf88iUQhyl0BJjdIbykvSGIxzqEalKwnfhvb/a/fVHDef542/08
	 guRWu66IZ77IQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9AAC8198003A;
	Mon,  9 Nov 2026 07:04:06 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 09 Nov 2026 07:04:07 -0500
X-ME-Sender: <xms:trbxatRLoPBG1NeqH7ioJIPFldkF3zaIzKST2oagIS7LoKeDw494ug>
    <xme:trbxagINNwnSDYYW55zgX8WRGGtQUsABhIs683B7DptccrfUYs9eyG7Onc78lF0lu
    Ij59lrev_QNpryq_bRAtmKsAqF4cPVzUbcSa_xMuUm4mN-hD-otI7Q>
X-ME-Received: <xmr:trbxarWT9-sax744EaZlXii62cem9i0gq81u8oa8W1-2zG6nMaMR4g0QW3M>
X-ME-Proxy-Cause: dmFkZTEHeVVHUfqtfb1dOm5TRDKriBPa5Y3nL88tgXPkdBA7ZkCSLFFLB1zgEH9NW+5VLm
    BnGFV8AzpWanjsQgMjRDtL18fRWfmrbvT9Kq2tGBzg4BxhKbogbw/s4weXCjKe6qd3bpN+
    19tWGmXIt8/jlzlfW5T01rycYM+poyjxXPXXvUkQYbyyIhx8zEwqLRbSHzFk5BNOfeJBWw
    6Dl6gN+UoYmUlwHIklPkb8ESWEeArFhT7NLRcBXkc+cGkaj8QFVR7LTs1IsTKBSDnLo4Kg
    0Sw5chq6FO3hykb7WRjq/pROrmX7qm/w1Xuuvh5P8ajT/IOdb6norFFHtza+dsflcYBEi0
    rHd+hAfE+D3SpifmKvOcV0vpU2e2B+fG/49SFeZhLZZ/3y1Veg4VpgTa+D6sKgITEWbZ28
    OrXMDHgZucK2dnv9fp09KHyltF+ipGp2B25beRSmKMVY55TCwle4C9Nly1OKuwOVfLsxwo
    5iwKlE7K6H6xeS/ra1r74DJwxeoYQoGW1K7EylVfeMTVunyt1A5xqLpIHX2S0ZJ/nI56PA
    0hbe3pcCWwppcAAp8pHGoGkE8ylIUFsIpHMSlsmhnFi8unnwl+ive3I4kVsU+yasZ2jhcq
    aA30ViCngLwfiAk4dTU3uerJP00sHIwdzWeN4ZrT+8DqmcLNSC/P1bMSahZw
X-ME-Proxy: <xmx:trbxakgAM0RPlCx0UdziTwvAftHHjQWxkKNsDX4anSOpzz0GuV0qRw>
    <xmx:trbxanvUBG0bMZ3ZxIborj2NynTjwa75DUlEFlGlnEMsrGg8s1LpwQ>
    <xmx:trbxakzE2vpwa_nS6ssxfVBVllD97ylsl4VgTmZdp4XReaqDh4rG0Q>
    <xmx:trbxasZ-h_Pv52opcJWwwTzQXd_pU7eIZQpotN4gsiQDBz7TnepZ7w>
    <xmx:trbxajWdY0gr-VitKbxAqKwY09yE4ClbQYMp03R_4-U3auKAW62XfCji>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 07:04:05 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 0/2] mm/memory: refuse to map page cache folios that are not uptodate
Date: Mon,  9 Nov 2026 12:04:00 +0000
Message-ID: <20261109120403.82361-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6322E140007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3jf7zju4uo8x6a6478nyji84h6bfpebj
X-HE-Tag: 1794225852-742645
X-HE-Meta: U2FsdGVkX1/2qoQ+GbAzB/MkBHnx7ZjWw05p8xxPYWkhXpDZ+gfkXH0P95dVi5AsWaki9Byqb48MgXPUtbDcPPw6kIbN8yecFLdo4Y8KRvH1sbSd0LOeOKvolVkiU7iqKlyvpnYpCrToD1nsCW/MsLZSoFjHBEB7I0GoCwTJ12+Y9H4b9sPtqMu1Dzx2W3ISYAO5qiUVZVnxSzjaSdGlkkUTwg30oJHLihoV/osbhZo309F09Ry7TFUWO7yjGcjKAUgyfvitzdV1SMFHVA7XCzShLFrWTPrLsAhqr00rjgHvG9p8YCSAHFV4LPZqqK7Yh2F2Wpru6SeeBL7/r/NhTIu0GMHRpYWJo2jEgGhZ+ZyFjD51CGm9IxyT7+EPEyI/Un+l2hauAgIG1KJkIkVktxoiIwpO/a0bxj1lPUfh6AdlsAsmEf0ZLtzwW9ghPCj7os+Z83Ii0Sv6S76pCAQ869yDqsKozQE8ImzgWa0bx6qsoGmdqoJEVmtxOx4/1TkO7f3UG1QNyrnsh3AUJGKVwyXwn66NtVSj9fJ4hFEGvy5jXA7qeddiHZjqB+bC88lx5Wl+YteO873qC/PHrE9wYsrPwjLtrK7HGchiTilPRJIFDRNwyVS1Ys/YLKt8Q4IY3jkEU+LeGyal6z7d38udiy+mNgR+5jVxhyNkbVffW12u1MBOEa+4aKMG1gIHoiSQ+2BA+Y+eDnyTSi/sseR1q3gV0bNcz5Sa3Dt3a+tmLdCI9luvKP7vOfzUt7PQ3fypz0AlOczfOq1mMRFrGt0EOgCPUhrSAXYAok99k9KnHnCLjxsGOf3Yo3nWWM51tQ3TcgHHg503zVgtMOnPM+ZLo9JxIvNTsVCRYVFRe4MSqzj1jCWE/9+jxieQEOG1ObQeaIJ95vX0yfG6ODoM2wF63HfeQ0H2fZeUGP/5WAz8OMMCULx71pclX/xrDvI+HC70op1f4LrT/7XxE5a7nlN
 3Ry/O7Vs
 Uw3/ZMcaHNQkD98u2hTFVshSVIFIO4GXG6QqMNSQCrZnseWtXSM8BO3Qx/x6P2IguVF4Ope164s24iHlMuhjV3/218ndNXR5RxhddQ6iF2D0WVySBl/gWII8d8jU99Lh94Pp4u2LEZIYwvqFOAKIIWifiJY2+5xmnMDOupYfaQX6vWSrj+kt5mSE58rBqzxNW5lry9iWOZqMpd/z+n1jlcZCox0hTDmcTRv8xInbqroLCRMEvyRrVxhjUDyi1VsP/AmsmF+imdDNQX9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A page cache folio that is not uptodate holds data that was never read
in or cleared. Each path that maps page cache checks for this itself,
and a path that misses the check leaks stale memory to userspace.
MADV_COLLAPSE did exactly that with fallocated shmem THPs.

Patch 2 adds a backstop: warn and refuse the mapping in __do_fault()
and do_set_pmd().

Patch 1 fixes a race the backstop would trip over. do_shared_fault()
unlocks the folio around ->page_mkwrite(), and a writeback error can
clear PG_uptodate in that window. The fault goes on to map the folio,
and stores through the mapping can be lost when it is read in again.
Retry the fault instead.

v2:
 - New patch 1: recheck PG_uptodate after ->page_mkwrite() (Sashiko)
 - Check in __do_fault(), before the folio is unlocked, instead of in
   finish_fault()
 - WARN_ON_ONCE() without a message
 - Rebase on current mm-new

v1: https://lore.kernel.org/all/20261106144323.3634477-1-kirill@shutemov.name/

Kiryl Shutsemau (Meta) (2):
  mm/memory: recheck PG_uptodate after ->page_mkwrite()
  mm/memory: refuse to map page cache folios that are not uptodate

 mm/memory.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Range-diff against v1:
-:  ------------ > 1:  632ab50e643d mm/memory: recheck PG_uptodate after ->page_mkwrite()
1:  af1dd44c0e1b ! 2:  1e329f330c41 mm/memory: refuse to map page cache folios that are not uptodate
    @@ Commit message
         leaks stale memory silently. MADV_COLLAPSE did exactly that with
         fallocated shmem THPs until recently.
     
    -    Warn and refuse the mapping in finish_fault() and do_set_pmd().
    -    finish_fault() checks the folio ->fault() returned rather than the one
    -    it maps: for CoW, do_cow_fault() copies the page cache folio and maps
    -    the copy. do_set_pmd() covers MADV_COLLAPSE, which maps without a
    -    fault.
    +    Warn and refuse the mapping in __do_fault() and do_set_pmd().
    +
    +    __do_fault() checks the folio ->fault() returned while it is still
    +    locked. do_shared_fault() unlocks it for ->page_mkwrite(), and a
    +    writeback error can clear PG_uptodate after that; that case retries the
    +    fault instead. For CoW, __do_fault() sees the page cache folio that
    +    do_cow_fault() copies from. do_set_pmd() covers MADV_COLLAPSE, which
    +    maps without a fault.
     
         The fault gets SIGBUS, as for a folio that fails to read in.
         MADV_COLLAPSE fails and leaves the range to be faulted in.
    @@ Commit message
     
      ## mm/memory.c ##
     @@ mm/memory.c: static vm_fault_t __do_fault(struct vm_fault *vmf)
    + 	else
    + 		VM_BUG_ON_PAGE(!folio_test_locked(folio), vmf->page);
    + 
    ++	if (WARN_ON_ONCE(file_folio_not_uptodate(folio))) {
    ++		folio_unlock(folio);
    ++		folio_put(folio);
    ++		vmf->page = NULL;
    ++		return VM_FAULT_SIGBUS;
    ++	}
    ++
      	return ret;
      }
      
    -+/*
    -+ * A page cache folio that is not uptodate holds data that was never read in
    -+ * or cleared, and mapping it leaks stale memory to userspace. The callers are
    -+ * expected to check, so treat a hit as a kernel bug and refuse the mapping.
    -+ */
    -+static bool file_folio_not_uptodate(struct folio *folio)
    -+{
    -+	if (likely(folio_test_uptodate(folio)))
    -+		return false;
    -+	/* Driver pages from ->fault() never get PG_uptodate */
    -+	if (folio_test_anon(folio) || !folio->mapping)
    -+		return false;
    -+	WARN_ONCE(1, "refusing to map a page cache folio that is not uptodate\n");
    -+	return true;
    -+}
    -+
    - #ifdef CONFIG_TRANSPARENT_HUGEPAGE
    - static void deposit_prealloc_pte(struct vm_fault *vmf)
    - {
     @@ mm/memory.c: vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
      		return ret;
      	page = &folio->page;
      
    -+	if (file_folio_not_uptodate(folio))
    ++	if (WARN_ON_ONCE(file_folio_not_uptodate(folio)))
     +		return VM_FAULT_SIGBUS;
     +
      	/*
      	 * Just backoff if any subpage of a THP is corrupted otherwise
      	 * the corrupted page may mapped by PMD silently to escape the
    -@@ mm/memory.c: vm_fault_t finish_fault(struct vm_fault *vmf)
    - 	unsigned long addr;
    - 	bool needs_fallback = false;
    - 
    -+	/*
    -+	 * Check the folio ->fault() returned. For CoW that is the source of the
    -+	 * copy; DAX CoW has none.
    -+	 */
    -+	if (vmf->page) {
    -+		folio = page_folio(vmf->page);
    -+		if (file_folio_not_uptodate(folio))
    -+			return VM_FAULT_SIGBUS;
    -+	}
    -+
    - fallback:
    - 	addr = vmf->address;
    - 

base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
-- 
2.54.0


