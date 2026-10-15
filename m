Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B863ECC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665D16B0088; Thu, 15 Oct 2026 04:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6168C6B008A; Thu, 15 Oct 2026 04:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E276B008C; Thu, 15 Oct 2026 04:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31A9E6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:16:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA5B714091D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:16:38 +0000 (UTC)
X-FDA: 85324154076.10.DA87EB7
Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0FB9720006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:16:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WRZgdt90;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792052196;
	b=qRIj6Mj/moXvS9MFracsw/IrSjk8WN2OHsmENp5kufSVuL0IL902Fyds8ariKGxC204GrD
	O/X87xrwbMMB0Q2TkwI3vjMY2h1yZ1pmStwI4milIzqnW/dVXBugmCb8gDjjqna72dPj9b
	XCdWxPWIJt26/i7ez2OgWYkuG388Uos=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WRZgdt90;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792052196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAn6DVgRdW5208osiJaq+1CZYYHO1h7smP5XUSMjjwI=;
	b=kOxUtMBuVuwfESyPL9sKrAiAY5kI+NGBXdhr8WwP2y/52WZyK32JMpHDSJHwN5Y6jrc91e
	e8ZGYLMgY/cKsKdy8T5FN3LYHNxeoPU3Si+n0Bqqfi4iLuCJIdpR8NrVcP9Mlhvz5aUhhI
	hoKloo0qiAOKjQYbx5R1kqGYIL8H9c4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5OCQHy6Vii8nQbNIXcF5hqJKTP56Pm4uayTxNm1ZzNo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792052192; v=1; x=1792656992;
 b=WRZgdt90fDwpWyl7tmiVZ7rq5QxJxsurRK5MRaEXlJV4Mx9UXMnBHRDGtsA2Ncos5itOtc6y
 p1Dv7yOi7rEGEME67/T22v66GstJTQ77DAwJOx+sGFq7Na2JPlvsKDg0nxEQHAIEnZ+OlwfS+FM
 qheEXSHhVBPxveBH2gtBpb4I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7213910b432bc55e;
	Thu, 15 Oct 2026 08:16:31 +0000
X-Mizu-Trace-ID: 7213910b432bc55e
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	linmiaohe@huawei.com,
	lokeshgidra@google.com,
	liam@infradead.org,
	kylebot@openai.com,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: only allocate anon_vma in CoW mappings
Date: Thu, 15 Oct 2026 16:16:25 +0800
Message-ID: <20261015081625.4974-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
References: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FB9720006
X-Stat-Signature: tnwh5m4kyxoupyozswmub8bxyu5kzky7
X-HE-Tag: 1792052194-107680
X-HE-Meta: U2FsdGVkX19GjqjP+1yJTLJe1WL2Sc5GXOsrmBj9C0jP2s2wg52fvLLBcupH8Jz9DJKH/Z9K2WfCbPdjQvFEOCCTAA022lzi7+U+edn5ivAiQ1x/8M/UhwIeuKljzzHXxF07jXzPoVb37pqApwTEFDROwpE6WmEnTqBa7H1zMx+IOBjQSbHY/Io0Kkh4JSqrKLpB209cadNyHiHKgrsSLDPSck61cI6tCKFegXe7LIzeqcT7m9H5vTJJwpsTDNbcx3KbebnTxWfdLNVANAqV3pVKxe1Km5Y0L4lel1L218ZyTNN2mBxOlep/+bbi4NDZo1NhJmhK8nSfYYyl+zd1i+WJ/ubSr0oyo8b0dIBXQFNwU3oig5PNJJC8oRu/OrPgR/xjmG8PYO/HT0mr3m/BTzc/jIvM/pH75ilBi4dPH8ntbyGD9glfpkRTu0nURsZgjHNVb9uPS2Y8R/0tezf5S7LBo7ht0DL6yUkdNxOCbobAEioBKcwWAZ4hmPrwoRiuIN1z2byv4/6aEbYzZtvJUVHuEzfz5tzdo8X3amcBpttDPDj7exJSv1+LKgtJsXO2CiHWSzdX8ap0uSslg7UX0cF5eiQuec7H0SU2/05vjXsYn3Dsu23qcucgMI7qd793a2ld9mvU6Z4zCct8xxJIo25UaM2dL1Xwzndzv/BqwkefHl18pYU81Ns8ITp7jXJbjnKgRG52LXrHVy8Uu3gLOzFQbOisVhTOUkd4PEkLOd2AyrN49I4i9tZ/GPHplKtyMR2D1kHUqnmJO6hBUwU2ljffhmThwGuVQtEaiPUsTCGzWt6Nq82j8gtAwPhNsCbaPtETRdXoBISWg2K8EEymr7shkt83budU3CoUUzr4DYqwEporiegsYmLxybaSMQqCrtlXdybwRb/KbnKTtHWGht+HBtIfQRFJbN7leotnHTJoQWq5I6KIM52cD4pZmL3OHohwIK4gm/9giEjmfWD
 8Hqq0w3j
 ft0b78yVbTo392pSjFrzbfn9GaT/sAQAoytpp9CGE3y6qzviVl64j+DWc+Hu8IkEAAk4V2rfsT8LJ9jB/M8PfYsMJQaTMWBZXxI2vJG8Mu8FTLpZ2UP0tZzEENKd8w+/uVBMSK5FQYxZC7/RfwMlUkwLKd4T6XW79VnMbh0khCG7wZY++11hFirHr/Uj/Ek25KN4eyJELIGd+m+AUt+XbAJDMMgRaGGgwiJXTz6LRdWYDhBA68HJrR32HmXbltRCWTSxJQs3l9R26rl4TypiqPENYUQ5IBXpF8o2mv+p+JJCFMaiQSDuRciv4UXVwlxQ8GVu6cKEDiZ9SIy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 01:53:11PM +0200, David Hildenbrand (Arm) wrote:
>find_vma_and_prepare_anon() can end up allocating an anon_vma in VMAs that
>are not CoW mappings, which is wrong.
>
>If we have a MAP_SHARED R/O file mapped, we lack VM_SHARED (but do have
>VM_MAYSHARE) and lack VM_MAYWRITE.
>
>While uffd later rejects such mappings (uffd registration requires
>VM_MAYWRITE, see comment in validate_dst_vma) find_vma_and_prepare_anon()
>still wrongly allocates an anon vma before it validates the vma.
>
>This in turn later confuses copy_page_range()->vma_needs_copy() such
>that we end up calling copy_hugetlb_page_range() with ranges that
>actually do not contain *any* per-pagetable information that would
>require copying, which is the basis for PMD-table sharing in the first
>place.
>
>copy_hugetlb_page_range() should not have to worry about shared
>PMD tables at all: it doesn't make any sense to copy page tables that are
>shared, as they can be fully recreated later. Ending up in the function
>with shareable page tables is the real issue.
>
>If a destination PMD table is shared in copy_hugetlb_page_range(), it
>might get concurrently unshared as we are not holding relevant
>locks, resulting in us using a page table that is no longer mapped and
>possibly freed after calling:
>
>	dst_pte = huge_pte_alloc(dst, dst_vma, addr, sz);
>
>To fix it, do not allocate an anon_vma in non-CoW mappings and add a
>safety guard to copy_hugetlb_page_range(), making sure that we never
>end up messing with shared PMD tables in there.
>
>Before commit 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd
>operations") we would always validate the VMA before allocating an
>anon_vma, and consequently never wrongly allocate an anon_vma.
>
>As uffd_lock_vma() is part of the same lookup machinery and
>also contains a misleading VM_SHARED check, change that one as well
>directly for consistency.
>
>A follow-up cleanup will stop taking the hugetlb_vma_lock_read(src_vma)
>lock in copy_hugetlb_page_range() entirely. Further, the usage of
>VM_SHARED in userfaultfd code should be cleaned up later to focus on
>CoW vs. non-CoW mappings.
>
>Reported-by: Kyle Zeng <kylebot@openai.com>
>Fixes: 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd operations")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Tested-by: Lance Yang <lance.yang@linux.dev>

