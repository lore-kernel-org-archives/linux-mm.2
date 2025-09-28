Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAFBCAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 03:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0FB8E0003; Sat, 27 Sep 2025 23:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071028E0001; Sat, 27 Sep 2025 23:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1D88E0003; Sat, 27 Sep 2025 23:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D190F8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 23:30:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 741D1160918
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 03:30:40 +0000 (UTC)
X-FDA: 83937231840.28.4896088
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id C6419140002
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 03:30:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jQEw/GiJ";
	spf=pass (imf09.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759030238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uc+wUhbU+vmG0ftABvHU3C8zcXwYiUUCuPWSOJpwaX8=;
	b=PZeNs6tLsISdvpMa3IDZAZLtGGmPUCXS/fzRfxSg3orjDMe+OnO6NIxSdMwPcsW9KlTHiV
	dbi7yAt8M9gZzdClWgYNBIloJWa8sBUOx3HH6SkmjEwXqwpr0kV9PCSYfPf9yOtfRhd1p6
	5eJA021ScCcY3BtcrkCk45dd7yeWlzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759030238; a=rsa-sha256;
	cv=none;
	b=lXjHWVy91FFlHhycR+ujHh8ZDeIvPFx2mzksm4aE4rwPbSjFzS76HGKyJf8eraz+8Ycy1p
	LKWrL7y+IOVLEQkOlABjRcuPxAfwT08a8BoHiCd00bdzYg5tNfD2MZWe0R0Lf/qYw7deiC
	bqBpdqZYvXXCs+dIpfCEcfXF5firmTM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jQEw/GiJ";
	spf=pass (imf09.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759030238; x=1790566238;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=efex/veyeyHUIjB317uonW+jJImDaYnL9AF1S7tnYRg=;
  b=jQEw/GiJfGUL54+j8LQsCjH+2VqPoUe/ohEAwH1g8XK4xreTyjHxjeJC
   ZHZoTCCBq+FKWSGvhs4CwV7QHj4JMBfqNgPCJcnPvXIWCqZKiHmHQanCf
   CASbeynoELbD6OtjGIYolwhZcuy/+DhGoyl5U4EkkuRWCoHtrRIJwvQ5g
   eWFPAyk3xBFTFV4G6AClNNZlbD98eMj9PBKeUNPXmDqj7ZotWQT6pbj1Q
   1cMweWyvNa0wS32gA19ju3+Px0ZamUqMnHMbtWtF7rcLWpanzXABvQPCn
   kQ65ZBiEiDbUF0yxxb84998kFbs9BgRQSWfCKZ3EwvGlSIS7liAQU+fsb
   g==;
X-CSE-ConnectionGUID: o1dsjG3OSUmaR/VxKusLtQ==
X-CSE-MsgGUID: Iy6FtU3+TMmGumrlZDbahQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11566"; a="72746034"
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="72746034"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 20:30:37 -0700
X-CSE-ConnectionGUID: l/u2KvzMR9+wXNAuLlX67w==
X-CSE-MsgGUID: Ka5geKoCRUSNNPNu6ilsLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="201609059"
Received: from qiuxu-clx.sh.intel.com ([10.239.53.109])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 20:30:32 -0700
From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	linmiaohe@huawei.com,
	tony.luck@intel.com
Cc: qiuxu.zhuo@intel.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	nao.horiguchi@gmail.com,
	farrah.chen@intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH 1/1] mm: prevent poison consumption when splitting THP
Date: Sun, 28 Sep 2025 11:28:42 +0800
Message-ID: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6419140002
X-Stat-Signature: ra64gy1zy53qaqcgoztjj98t8qt7mgq5
X-Rspam-User: 
X-HE-Tag: 1759030237-298567
X-HE-Meta: U2FsdGVkX1/n1n1J/qC1AWJ2zkuNtCJRhTfAMZTpu1bMh9geLI7RIATG7KZamXWrZB7xDLTletGQFUTFw5Amb8irrZ+cgCYhcCRUBMRemtMtVFeJ4cisxSxc6Im9Am+B5SJCmkO3Ops9nd7Yfur0haxTGckghpDGZ3H9WjxkVGGlWNkDC9rpVVjh2/4XxwkztlPfc3/mu/2D6ewnBJ9nhpxrCGEyr3KdgRZdEKDxdWa+QAwtZqgsALY+XTeuA3qzEs8FgaWd8g44vjf+dlLoULye6VGWDxPLS591XymvX8Xbl1zC/crS3I0Oh+kskuHxlHH3iTx7sqRQCni3KdSfoORQzfTBrr1CXe2I6NDMZnG2bFSEgHqbyaleoKpHJZYSm5kb/q3jLXO6Ws2a75GjCN76oDWD6kf4VSI+IDH3UARCAL+8sCC/fh4DGrzZg1p0mfwWcFDZ/vnw2NR28OsV/6TtG/Kgc5ij6SePib97CdMKj4Gmvr6buJS0XLTl34YLtZLzJI4zz3bvrIYU98dnI9Tbsg8VFIcvMTEE1FwvmeoJfRwDsfNLg3J+5pLSg7oG1rdp8vpnUW9ZTTOwNQThsDC0MjZbAzkLqyaT8a6VGeqBMSPNo7Ts1trscVHeYYVRvi7knsFefy8PZSBtHIrw3NIVs83OiBDRAJGc8dslN909MnwDcnfNA+0LCgZg5vt/v6WBZJQl0Z8wUOYybC2UE5RkQJzH7bY+IzobLDwwEEy34AjNRAqO3wTZIuXZyYh46Pp2Q0sOxkwvJ2gxbHoUw/JKJspdD3Ns8JR1iwN6vwhDfvPZVp8jQKC0w+YgA/d3KAPuH0YefgME+WrNZSWnxmp3jsZbFdo+5PmFpre3TuHEnna2b9rhZ8u31cYgMLnyCniEMAxboVwz/crbJwWmJQ7HmPgsG1C6OxII3iPY40nEme3ojVsy0heILQkwRy1um0z8gGZFuS5l26Ec+Gf
 553X0/Y4
 xwKpEc/Ij6YYVfnfPe4969xVfOwVxyQ+9W3qCz8O3fH88A1pZ+m/WgcJ3EOAlLKERlcl1jmIYATXgtbldFyThu/HPR1Dq6GPx+nteJLge3989KrN1Ehs7cw9nruNRQWP9KOPFSNTMdwrzZyyxG3Xyf92V+Lb+z1z8aHqLv0BSJJLM8WrCmy00kvWBEOZ8K0Zq7RgldtNrJIn7P2IgJ8UF4sFfLpzGHI0y3k8n0RKe8zUyMebJ19oWjfDQAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andrew Zaborowski <andrew.zaborowski@intel.com>

When performing memory error injection on a THP (Transparent Huge Page)
mapped to userspace on an x86 server, the kernel panics with the following
trace. The expected behavior is to terminate the affected process instead
of panicking the kernel, as the x86 Machine Check code can recover from an
in-userspace #MC.

  mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
  mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
  mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
  mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
  mce: [Hardware Error]: Run the above through 'mcelog --ascii'
  mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
  Kernel panic - not syncing: Fatal local machine check

The root cause of this panic is that handling a memory failure triggered by
an in-userspace #MC necessitates splitting the THP. The splitting process
employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
reads the sub-pages of the THP to identify zero-filled pages. However,
reading the sub-pages results in a second in-kernel #MC, occurring before
the initial memory_failure() completes, ultimately leading to a kernel
panic. See the kernel panic call trace on the two #MCs.

  First Machine Check occurs // [1]
    memory_failure()         // [2]
      try_to_split_thp_page()
        split_huge_page()
          split_huge_page_to_list_to_order()
            __folio_split()  // [3]
              remap_page()
                remove_migration_ptes()
                  remove_migration_pte()
                    try_to_map_unused_to_zeropage()
                      memchr_inv()                   // [4]
                        Second Machine Check occurs  // [5]
                          Kernel panic

[1] Triggered by accessing a hardware-poisoned THP in userspace, which is
    typically recoverable by terminating the affected process.

[2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().

[3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().

[4] Re-access sub-pages of the hw-poisoned THP in the kernel.

[5] Triggered in-kernel, leading to a panic kernel.

In Step[2], memory_failure() sets the has_hwpoisoned flag on the THP,
right before calling try_to_split_thp_page(). Fix this panic by not
passing the RMP_USE_SHARED_ZEROPAGE flag to remap_page() in Step[3]
if the THP has the has_hwpoisoned flag set. This prevents access to
sub-pages of the poisoned THP for zero-page identification, avoiding
a second in-kernel #MC that would cause kernel panic.

[ Qiuxu: Re-worte the commit message. ]

Reported-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
---
 mm/huge_memory.c    | 3 ++-
 mm/memory-failure.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..1568f0308b90 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3588,6 +3588,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct list_head *list, bool uniform_split)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	bool has_hwpoisoned = folio_test_has_hwpoisoned(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3858,7 +3859,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon)
+	if (!ret && is_anon && !has_hwpoisoned)
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 	remap_page(folio, 1 << order, remap_flags);
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index df6ee59527dd..3ba6fd4079ab 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2351,8 +2351,10 @@ int memory_failure(unsigned long pfn, int flags)
 		 * otherwise it may race with THP split.
 		 * And the flag can't be set in get_hwpoison_page() since
 		 * it is called by soft offline too and it is just called
-		 * for !MF_COUNT_INCREASED.  So here seems to be the best
-		 * place.
+		 * for !MF_COUNT_INCREASED.
+		 * It also tells split_huge_page() to not bother using
+		 * the shared zeropage -- the all-zeros check would
+		 * consume the poison.  So here seems to be the best place.
 		 *
 		 * Don't need care about the above error handling paths for
 		 * get_hwpoison_page() since they handle either free page
-- 
2.43.0


