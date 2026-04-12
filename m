Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 320D8E937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3F16B0093; Sun, 12 Apr 2026 15:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783996B0095; Sun, 12 Apr 2026 15:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672976B0096; Sun, 12 Apr 2026 15:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51BCA6B0093
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD0FBB8061
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:13 +0000 (UTC)
X-FDA: 84650819106.15.72A8DB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 16A3F40008
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hj3K/4X0";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hj3K/4X0";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020412; a=rsa-sha256;
	cv=none;
	b=DLBZ9QXVl09sC2UAwSFS/V8ajNLems41t501mx7cCgpOhSFTTINVvBoHhZMUsoAIdWr7SJ
	2Grsy8Y54dtlkVgAR/FRB+Pg6Uynh2opa5DspKuZ9WpAQmxr73ZbbA71r4b/kf+tJIW0dc
	ZU/lEvqFF1DGGu5hHtQdCjlW8njfQ6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUm3hEH8brcHyB0Y363K8a6988+/Fs27xFlKxxqLHzU=;
	b=Ryrkb0OsRWDceHDFm322Z5EUM9gJgj1MzXVgfVTc2Tx2VT92PP8piyW6ajhbmiB1eEh4ur
	S3/YaxDWBByne8fBYZ+wYEcCX12ZUDXggC28llTs4xmhZycrcNeUSyhWM9vmTJo3j1MJQ8
	Tcz/ZeXaWudT3ngJ7mV4eqcMkhZ2vFg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5AB444599;
	Sun, 12 Apr 2026 19:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E8AC19425;
	Sun, 12 Apr 2026 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020410;
	bh=aaFn5rBZ2ZBLI8uD6bytE2KuPrplmji55gqtSf/LxAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Hj3K/4X0vU+on1n2LepoMzRKUFfJqrsBx5yY9WIyn1Af+4VW86ETEyZstM7vdxJvg
	 sDvByFawl9+gYSm6q8VGfBw60vGF6aur+wgNVP4fcJaM3NIxYHhakhip/or5KwJgAA
	 PddqinQ4VbtPzYynvYYeGtLHPwoRc05tb+kN6E06fTtlFuX8GJOm+5UKCKNHrSS6It
	 zen2aZptohFS3fGReE66+0tsEtgT3zdlqynwmSzN00OpuM2SQYzjGkIEOgt2twvQcH
	 5z1BxmIwm/yMviTrgTCc2p5Bu4hQdKzzWnboZLrMZYoNw+DVI7wYv83kzCAZd6IDeY
	 r3R93oF7d8X1Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:33 +0200
Subject: [PATCH RFC 02/13] fs/proc/task_mmu: remove CONFIG_PAGE_MAPCOUNT
 handling for "mapmax"
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-2-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16A3F40008
X-Stat-Signature: yrtf1aay8fy8ic8nxy6rn1nkg1zxmhhi
X-Rspam-User: 
X-HE-Tag: 1776020411-608837
X-HE-Meta: U2FsdGVkX19wxAsjoyaeu+A7/o7ibWtyucyjTAmgM9DrX75mjgJEi2oObB+7O/syijF+6Ziu5KepWDL71NC9Rww/1SgDjy/9MgnfQvrAvx/wJhAM1q5L1PRns1Faa6t4anlUbZdheHHCxNQHDDmNjnT+swebFSxS+lvYNgiFRv/xDEwWxzS8FHHxxTD0rH39pN8ulhA3iw8XyAJfY9QuhcEOoiqI2jVwW2ZqzRCwAQl7Lx3slzn/rB/+GsuhdRydZbrsyQhQk8va/MY9C+EXluhuNfSbVrQnZb+xZcxGycOrgztg39AAQy7jzlFPnWaWRqpcEwIKE7ffQ6QRjlWFu1S3L+o9R8Zw4bcU5TYsuJcfCGBS3SrcG3zafcwj5bTgcZHFL4jJKkhlb0VrdpC7SEu/6+3uAhJd+g1i0xiRAFoWI53h5c1MfTcC26Tup06jiUPUvYNolUhFLLFA1T+x53AklO2AF+YBb0mYEjzwaXmIB0Ci6iMm886lkt3wYyZpJuimX1Z6ZdfyYyHrjFT4w9DNX8uNnYMwOCaRp3JHjxe8M9CUycN39nJW3nczZZEYcBE0rOW3PPYdU8zKRLuquEV5X1a5S92+eaO/ReIiPjBPWzOm7EY4TSfrop9npoEXG7Vky3ID91JicRAVm6U8eVQ5UaZpMgn1v1rhtf4Gfh5QixTJ6qr6/sn2w0Km6JWU6FY3N0AYIcMzJGL7VDq8Jl58D8HBxtOHCzMxNQJXxit8TDmszb0zu1SkAMchHNzi9qoMDWWnCXMCQxw1GO7EcnvYdVgS4Afrzq+waRbtoX+r1/aK+pKDbKQNxhqnLNqmVVSwnkrD7jQ0olPfULBpjJa4SFgW1O2WSadUy6IDFjgwq1AkjO91VsKaOAYHxnH58LLuXxnXuKYQ4PJnWWyVKaHtILptm9oTFmnJjxmbVTXdrwJKcdFLvoQTl0rNlbpqof+MnK3fY/CGT560juG
 74gwQFxq
 Zatwb28K0CKLZtnQmmdGqYBUMl3nQlAe5Z/uUVZM3wjYMxGk0fo8uU5qDBcdb+ismyGUVprqQNemKX90azuiD915y9tCv88bCZ2eNbTNP9vpVSdoAi+hflEoiJgEHpm3t6OMFvko6GdtzX2otzYI0SMjsAlnaS8w+RZwQnXBk0FuVpOPjSF/Jj85z/kZRTFG58khgexILcOfhPMiKXVATGnlvyRloz1XehZIkYxquTv3dt6WAUe9AlUSjEqvkNuujns83djn4ducNd2SIhbwnZpZtwlVTt6FnIkBW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for removing CONFIG_PAGE_MAPCOUNT, let's always use a
folio's average page mapcount instead of the precise page mapcount when
calculating "mapmax".

Update the doc to state that this behavior no longer depends on the
kernel config. While at it, make it clearer what "mapmax" actually
expresses.

For small folios, or large folios that are mostly fully-mapped, there is
no change at all.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/filesystems/proc.rst |  8 ++++----
 fs/proc/task_mmu.c                 | 11 +++--------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 628364b0f69f..1224dc73e089 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -699,10 +699,10 @@ Where:
 node locality page counters (N0 == node0, N1 == node1, ...) and the kernel page
 size, in KB, that is backing the mapping up.
 
-Note that some kernel configurations do not track the precise number of times
-a page part of a larger allocation (e.g., THP) is mapped. In these
-configurations, "mapmax" might corresponds to the average number of mappings
-per page in such a larger allocation instead.
+"mapmax" is the maximum page mapcount of any page in the mapping, i.e.,
+the highest sharing level observed. For pages that are part of larger
+allocations (e.g., THP), it is derived from the average mapcount per page
+in the allocation, since precise per-page mapcounts are not available.
 
 1.2 Kernel data
 ---------------
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..ad0989d101ab 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3137,12 +3137,7 @@ static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
 			unsigned long nr_pages)
 {
 	struct folio *folio = page_folio(page);
-	int count;
-
-	if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-		count = folio_precise_page_mapcount(folio, page);
-	else
-		count = folio_average_page_mapcount(folio);
+	const int mapcount = folio_average_page_mapcount(folio);
 
 	md->pages += nr_pages;
 	if (pte_dirty || folio_test_dirty(folio))
@@ -3160,8 +3155,8 @@ static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
 	if (folio_test_anon(folio))
 		md->anon += nr_pages;
 
-	if (count > md->mapcount_max)
-		md->mapcount_max = count;
+	if (mapcount > md->mapcount_max)
+		md->mapcount_max = mapcount;
 
 	md->node[folio_nid(folio)] += nr_pages;
 }

-- 
2.43.0


