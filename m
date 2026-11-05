Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C206606D812
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0DIaiXs
Received: by kanga.kvack.org (Postfix)
	id 5449F6B05B0; Thu,  5 Nov 2026 15:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5716B05B1; Thu,  5 Nov 2026 15:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3AD6B05B3; Thu,  5 Nov 2026 15:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 117596B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:57:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F907A0BD8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:57:43 +0000 (UTC)
X-FDA: 85402276806.13.A5056EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D1487180004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:57:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0DIaiXs;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793912262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4tsSLRB5gzfbm60hazvMjfmtsNOihBj3aVcJyFcSU5I=;
	b=mtwiwjwXj8Nmzwbqslps7dcz7Dmzlg9CSXf+/96sPgie1MKx19P4B0jckr8yJkxs47W0Pe
	0aDefMAsjWt6w6j0Ta7q8IoeiUDxPFYPoKVMJYITlIb6AtQeiRHroEq6gFilj19z25XT5a
	nTvaK1iJVbggfgp5VN10YuDytp+axfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793912262;
	b=Ds6PUCtYqR2iAxHj0+7MrQ8BBFD1T78FNkNSb0LPNnaLjGxKIiVqKQRq7PIHiYoKRDC3mZ
	7sDK5q1wX4vygyrPJHi/SVwgQDSZ+9dSBkoWcrHEIMmOGHlEeLlcLMTzfCuVciHIhWtAlT
	5rByu+fqZrIZe75bOCuAWg0nG8Djs+o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0DIaiXs;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E3DD4021F;
	Thu,  5 Nov 2026 20:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80FB1F0089F;
	Thu,  5 Nov 2026 20:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912260;
	bh=4tsSLRB5gzfbm60hazvMjfmtsNOihBj3aVcJyFcSU5I=;
	h=From:Subject:Date:To:Cc;
	b=Z0DIaiXsUmWzQfQ9HDnbc+qP2Qnd5GefCCcd5FFyl5iVMrBdP0Eg8Z/iefj7EhGpn
	 A8SnCabIIagHrfVz7DzHZ/cJvzP1LBVknLshV9aRPelX410Hu5gG+xsn7Jo0naJfgg
	 SmG9hAZ9V5YFaExqPOALfmks693VH29I2oAJamTqI3+bV7z+GvnsUOs4sgC7EGvvzF
	 MWBahPlXSzabs1l39Ir/uDgcAPcRWsJ9RK+twF9F9Zc+JURU+Rhwz+68syzXnAjM/G
	 A1ecqN31Bm+2RmCocOPD2gkYHMmAZbxdpKy/VxY1BIg/hPzurPfs9SRQcOXpOO5coA
	 HfptOwX7QG6pQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 0/3] mm/khugepaged: bound mmap_lock hold time when
 walking an mm's VMAs
Date: Thu, 05 Nov 2026 20:57:21 +0000
Message-Id: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNQQ6CMBBFr0Jm7ZhphSquvIdhMcJYGkghLRIJ4
 e5WXLt8L/nvrxAlOIlwzVYIMrvoBp9AHzKoW/ZW0DWJQZM2inSJXfuyMrKVBnuexNcLPt0bc8r
 LojFGuCBI4zFI0nv4XiVuXZyGsOw/s/raX1LR6V9yVkjIdOaHMlxfDN06CV764xAsVNu2fQAz9
 69uvQAAAA==
X-Change-ID: 20261029-khugepaged-latency-fix-40495d66ea50
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3240; i=ljs@kernel.org;
 h=from:subject:message-id; bh=kHSJ0UoFhXYW+BFBk23Iz4n2tUrJtVkgq2eIr5BK5Hw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevD3wMO6HrvNO3yn5WXbuM978jpkRma2gE2PzuXfOD
 B63w5IuHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIVSzDP3PO45qnNWd5HBLi
 XcW0ut7InXdNmdf8B8xCNu/Mfuqs+8jwT/GO9sL07Lntz/UYLblXzzHW/XBv/3W+ilnMP1N2Hdh
 8kBUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1487180004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: epxzhbpu8eznzbxcn73es5e46cybr1xg
X-Rspam-User: 
X-HE-Tag: 1793912261-23669
X-HE-Meta: U2FsdGVkX19gbb2JKeJpstR/sb2mzH4fS7QYxaJ8QMt+AoHHH/WR7vrifHQUN/E8g3ZABry2xDx/fGo+gOjRYrxpvmmgslPmqrvSRIXhb2LadJ1pQIwBRch8bkvanG8u5b191YEPQY1KdesvMva6y6zmY96/MaO8ArVaN0Zmg8hLDYk4/8/tFevIyNSdUAPwKBjogxr5be7OgfheJWAi3251PSbsANiv9Wus9FVECZyQp7sN4hzoR/uYza/0xant0v/tJ3bRkLFAKPnsTZPSXG8LEZsdVyxL6SOYfiTRu4qaN8XgzOikDjdqD0KXclca2WFfqY9GU/zsy9LImM3oOwIxpafFQ0+WJH5GvDGFyYtC5FTwRGWEQobkX+L5iLDCXi6QXj/wlCIBJ2xreneTSHPmZJW8Y5DAr+HdV4zVkC2vwkSf8ilPhd+tO1BImn5ewiDaHdTH+VKuHtHmg1lJ4JEy9faxkDdmNFcGNSYUckN1YQE/eMQFw59WiS4up8t9BIW53DIgSePVykdeBSQioOaUiBrwSNRc3yDgnKE9ZDHs20JLmyemq9vMDWAGAwJmy6DOZeWWMxootTanSMkjSGv+muVyJLEn5n8Po9Znsyy5DOuQsmsPMAhhvdmnJiTCm9ik2jRKffFm7U0U4393buq0ZBwUgnFkf6D04UXm+/r9K4QplrawkROi3Zsq46JJrA1Io2xp5AmpeIRCqOGadkrMcX0G/R7ddSzhDrrc/X28Gz28pKAD/s+BWJembM9Aoa4KooqXgqrf5DlACz2AGP/d9cnKKf922X/f0B89hKQW2Pb6YCr+3i+qWr7Ru2/YEw0z03+1KAY1PlMQAgJVXMLza5B1qt7KirGQYpytBZOMbxz7GuCK541JrmCSaRWfEuPBnE9IZrvHsRvsnM1DMvdQJkV+6Bvkrb1GcGMHR/b2c222K9ylkZG3Y5hQf3AzFfIQ8KnT+3xYzj+vdda
 uztuJa7E
 F7nTGKWKY7Z1KtEE1QKXTxTX7EwB4md/I0sP/XCZpEeaSBqT+wQRkMEndRacOynIL0Qhzx4JYA0BJ1WT2NE3zAgQ7Ye0rh0bacmUCwibxily/sagNYUZUsDnDpaNnL1aJtkzIsoRnlgdx3pW17RiqJ9HDMbBCRAipR62DouhaiEMtT25OTaZEhqAWO7VGWfNycrNfKQHOG0bZDSbhf7yMIpPUJy4bgVdpI/isN553ZJkHhTWtnJvCcUBmW3NRHvrzzQlkeiqeYkp90vwbUQ+4UNZMSB4h5XuCJnuJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series introduces a couple small changes to khugepaged to improve its
behaviour both in the face of mm->mmap_lock contention and to reduce that
lock contention when possible.

Looking at the first change - if the mmap lock is contended, an attempted
mmap trylock in collapse_scan_mm_slot() will result in the scan being
aborted wherever it happens to be, and when next the mm is processed it
starts from the beginning again.

If an mm has a lot of ineligible VMAs and is undergoing significant
mmap_lock contention, collapsing the eligible VMAs there can take a very
long time.

Patch 2 of the series fixes this (patch 1 is a prerequisite) by keeping
track of where khugepaged was in the mm before aborting the scan.

This issue was noticed during some work in which an mm was instantiated
with a large number of small VMAs under significant mmap_lock contention,
during which collapse was observed to take 10.8s. With this patch applied
it took 3.6s to collapse the same mm.

Finally, patch 3 uses this to have khugepaged release + reacquire the mmap
read lock if it is contended after walking a large number of VMAs.

This was also observed as part of the previously mentioned work in the form
of mmap lock stalls, which patch 3 resolves. The reader stealing the lock
back from a queued writer on re-acquisition is addressed separately by the
rwsem change at [0].

Importantly, none of the changes introduces any regressions for khugepaged
anywhere. It is all upside, and implemented conservatively.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Removed mmap_lock_nosteal patch (was 3/5) and sent a general rwsem patch
  separately, as per Peter.
* Removed what was previously 4/5 as with 3/5 gone it was no longer
  necessary.
* Put 2/3 commit message on a diet, as per David.
* Updated 3/3 to count every VMA rather than only skipped ones as per David.
* Updated 3/3 to use a sensibly calculated maximum VMA scan count renamed to
  KHUGEPAGED_MAX_VMA_SCAN_BATCH as per David.
* Updated 3/3 to only release the mmap lock if it is contended.
* Updated 3/3 to resume from the per-mm cursor after re-acquiring the lock
  rather than the now stale VMA.
* Updated 3/3 to treat a VMA whose aligned end wraps the address space as
  the last in the mm, as per Lance.
* Fixed 3/3 KHUGEPAGED_MAX_VMA_SCAN_BATCH to derive from the pages_to_scan
  budget passed to collapse_scan_mm_slot().

v1:
https://lore.kernel.org/r/20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org

[0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/

---
Lorenzo Stoakes (ARM) (3):
      Revert "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
      mm/khugepaged: scan mm's more efficiently under mmap_lock contention
      mm/khugepaged: release contended mmap read lock after scanning enough VMAs

 mm/khugepaged.c | 120 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 84 insertions(+), 36 deletions(-)
---
base-commit: 34f88a114888c9dba49e45f2b0c2a3e83c4c871c
change-id: 20261029-khugepaged-latency-fix-40495d66ea50

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


