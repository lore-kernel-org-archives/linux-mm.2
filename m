Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF41CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 06:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE02E6B0088; Sun, 18 Oct 2026 02:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91746B008C; Sun, 18 Oct 2026 02:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6F96B0092; Sun, 18 Oct 2026 02:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC5A96B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:16:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 348A240484
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:16:41 +0000 (UTC)
X-FDA: 85334738202.10.E5D0542
Received: from mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0082D120007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:16:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svOFuxEq;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792304199;
	b=2Ck+IR7uXDM4eAFG0C6K5TO7PhVnkRRP0CUjQOi9nw0VZDWRGiRE+5lE6Y657rX+Vt19+H
	qipn2vhsAuY3gZljfg7JZMTcobMBg4qL36gdlgkVOfABtg36gMJs2YaCTBBZbK9C7pcmCD
	yKAoTgHEmRZj4aWoovgziektIlyMpVQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svOFuxEq;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792304199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APlrRZOJFR9cUjMoEjPxwlvYOWuC2+es2fBySPBRQQY=;
	b=ln1vr4coLJprZ/MydqxiQQ/FcRkPRs86MuYWlIp7sMMdGr5GRSIRcKHyipgsW2/euif6ax
	T7FpbfaKMW4ukjllGtBwl9wHT4+OHYuzqtNBrnH7Ux7XlhBZEvkKqYji1J/s2G6zgz7kIB
	MaR4rF1HFc6VPWEo7c/XqfGfFAITWis=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B7Gw/wiYK21i/cMa7GU1UmN3hJqv1WC6YvEMSTJM0Ps=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792304197; v=1; x=1792908997;
 b=svOFuxEqWf6TmVMdnsN1mZk98lR9tnesVti+KOrfgctxjpv8rBn12cxqNLDbHUyl+Rttw4Uy
 YA4lWw/9Qjlf9VWwziulrNT54f2eRyGnVA5cK41UhvKt5+6gNMuOUrAYCEmwdCUj8EoAzdj5nSU
 kH4lQrOX8B0Qk2jckfVlZGRU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8a974899a536c980;
	Sun, 18 Oct 2026 06:16:37 +0000
X-Mizu-Trace-ID: 8a974899a536c980
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mm/hugetlb: fix use-after-free of a new anon folio
Date: Sun, 18 Oct 2026 14:16:32 +0800
Message-ID: <20261018061632.14622-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-2-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-2-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0082D120007
X-Rspam-User: 
X-Stat-Signature: nnhe18ssnw6berdkxdekebzga5tkzffw
X-HE-Tag: 1792304198-887000
X-HE-Meta: U2FsdGVkX1+9tz5G6mcHvxPWZFDzV8XYV+iwKBMRNT6TTJ9A1Arz5Gfzq4LpUOcdcNo3/zzwQZuW3XD/EotP3w7vgGegwGX75h3XnZryogkEMvWvUSVMm8jk9qiuVSwNCTboSMUUeEFpaWOZ6SXea8tRDICXmlRbHYO4ZkDp5TmsUF4vIhHWa+gQgSFzl23yKa/r/LZRD1sTA8NXfrK1Mt++DO23QACzdb+vYJGjGE+/LoYszbiDgaPaQJIMqnRqxORdUz3H7vg5ejeD4sTSv7cWAWLnF6Nn7eXsR/R/fZJtcabmcyI+cFx8m3tI37GitL2aSjdJC6jPYlE/OV8lVWFyJTlEw5xQEVFqrOqeSqK6a1DZ535SvChwQZAVdDZp5Er/xn2EQWW00cqkxoHdyDX5U1rEUonoZMVnuB/LTJyUJ7X81/L79YcRNfd7LX6kfol9EJq7xTHm0j8isUD+JVd3+8ZfzplyiMiC0zRP+4DgBeFZ5e64Wr48ELX2/4NoA9NyQ1In/Rv/siTN30UKkbqi4k9kuC/3LEpoIrqTarQOgDit+JRdmceRp8oqlRKbF2nJ/Yr0pS/Ry3jU5MFqOh2jQ00vwTrTKjenu5zE387KwWMWRpi5l5PjYR8Qgm9dx5iVVsfX2OGCoDgA63iXy6w4q6w4nuIwjpGOUWgk+Dl66eN5babr1WwSRDL9cunhj6hwqKRmvpW5UwqZ+qtcDQgBlPRuN0aAPQRX/jy5VZav4SSN+yzebORcsTBVnESCTw/S+avbl0XWGcN18sgNbKh7My7kXOdXWHj1O7pT+iwj+aaDFwRiQvfoMEvsEXra4cT7qJGxjCv4RSWnp8Hsk6qKRw5I4KBq+DNftgrtyD1OYd8jDklFxMTfFmaYUQXM09vDgLOyyWiSqY06j9ngdcexEfwKcytI1iXMFAgMOKVkS4/RcK9MSXa9YQWuAAOBusAfQqNHKYWc7oxFEwQ
 RBxr2HMI
 AunRioGCBLIkPfJRbdniMLcaffkVoxd4V2OSHpZE3AKHJ4KCdUGQV638MB37nfOewhW9AMNuaYhO9NWbcvfTwJoDpUgligiQ22L/mDupMXo0S/80L1Cy6IqQr39Defpyq/DzORPtL5U6cPidx/L4DC3UAgMsQjHhVWKLYcgZ+zbTAMgWx60IcxewcdAXSZhVCwPFJTk2svuz/rkDHeHtTd3OIIFZ4f092TaM0QCO5n6NufKFakkfNMGTYHQ83q9l567r6GE7hcngQ6DH5n0YbFlkk7gSF8TsxRZfXU13l1WuSbuW1FRlDHTq3AKknBnltcTGYnyDV33urCFioDG9wqX8KHQ1uWKZq/1dYM59IfUHNaCJHRCTT6yZUCi1cTovf53UwCbs8kt/9WIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:08PM +0200, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>For a fault in a private mapping with nothing in the page cache,
>hugetlb_no_page() allocates a folio, locks it and maps it.  The folio has
>one reference, which belongs to the page table entry from then on.  After
>dropping the page table lock the function still sets the migratable flag
>of the folio and unlocks it.
>
>Whoever zaps the entry in between frees the folio.  The fault holds the
>fault mutex and the lock of the vma.  MADV_DONTNEED and the first unmap of
>a hole punch, hugetlb_vmdelete_list(), do not take the fault mutex, and a
>private vma only has a lock if it owns a reservation map: not with
>MAP_NORESERVE, and not in the child after fork().
>
>Then the flag is set in, and folio_unlock() is called on, a folio that is
>free or has a new owner.  A surplus page goes back to the page allocator
>while it is locked:
>
>  BUG: Bad page state in process init  pfn:108e00
>  flags: 0x200000000000059(locked|uptodate|dirty|head|node=0|zone=2)
>  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
>
>A page of the pool can be given to the next user, of any file, who locks
>it and loses the lock to the late folio_unlock():
>
>  kernel BUG at mm/filemap.c:1532!
>   hugetlb_no_page+0x111b/0x23e0
>   hugetlb_fault+0x3a9/0x14a0
>
>An unprivileged process is enough: threads that write to a MAP_PRIVATE |
>MAP_NORESERVE hugetlb mapping, threads that call MADV_DONTNEED on it, and
>one that takes the freed pages for another file.
>
>Until commit 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more
>pmd sharing synchronization") the fault held i_mmap_rwsem for reading,
>which everybody who zaps takes for writing.  The lock that commit
>bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs") gave
>to private vmas closed the window again, but only for those with a
>reservation map.
>
>Be done with the folio before the page table lock is dropped, as
>hugetlb_wp() is with its copy.  The function already unlocks page cache
>folios under that lock.
>
>Original fix generated by an LLM and sent in private by Josef.
>
>Fixes: 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd sharing synchronization")
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>[ david: simplify+move comment ]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice work! Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

