Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70409606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U4WktlZd
Received: by kanga.kvack.org (Postfix)
	id 777886B05BE; Tue, 10 Nov 2026 12:19:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7298F6B05C0; Tue, 10 Nov 2026 12:19:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6175B6B05C2; Tue, 10 Nov 2026 12:19:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B54A6B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:19:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAAAE1609CB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:24 +0000 (UTC)
X-FDA: 85419870648.28.2232469
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC81340004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4WktlZd;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zbj2//T84I89RHJJWMcBH8ord+kaFBlmckmGd9rh3BE=;
	b=3vE8LIgaqT87nkeMfi5fC4hBjgkix0YpfzjGbAv0tHe1cVLVQxrGuHgDN+bEz37AQCAGx1
	25U9VRK6jh3dZd9fGiUFCjFL527QiQ/6glAcMcYdp2uJbyIrMvICpZJJ+CVMFH/JClFMia
	6titQa2kF19gbh2MXNuoXeAkcvXT5YY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794331163;
	b=V97IyPjZ+lN2d1+07Gg66JhNKdeNlp5EUUclFoRWRYrltNo2KQs95xR0YZ/6DaoGK5ck+A
	rWWSOvgdVjiAEBs3TwTH9igoBK7M9wCRjqUrXyWps0of4udJ13eq/+Bc2RYpSjXi2J4jDY
	lj1kPMSgkuSeeebwLwQAQahvkgozsss=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4WktlZd;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C94C841883;
	Tue, 10 Nov 2026 17:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ED51F008A5;
	Tue, 10 Nov 2026 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794331161;
	bh=zbj2//T84I89RHJJWMcBH8ord+kaFBlmckmGd9rh3BE=;
	h=From:Subject:Date:To:Cc;
	b=U4WktlZdYCYdRsuEkyoJvtLa+HHPN/UpP5smyZy5n8ffm0cLHbR4uWHPH51o9JKtR
	 mtT+wQHrPPOdJPPWwRpxXS+43t+hx8TZJtIF8JVrQdSI6gJJ+vd5y9LJ5xrv1MLYck
	 24RFrVIgPhDinv3GEHan2JfzxfD5jPqflf4JHWqdth/sFHLYg3opwxo3Jxr4Q0mHy+
	 TZHl6SdiZRhGJ6AaiJ3jRhF8VkrMznyuxldIDGgnqSpCX5f6TBlhs/kHDJf06I1FWj
	 rqeQfdRteqqhAvpIqlnrBfo49KG1MDg4L1kBenp6kzRNqf3zjMFmpSpvMK8ZS3mm2Q
	 xBzIN2sbGhOjw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v3 0/3] mm/khugepaged: bound mmap_lock hold time when
 walking an mm's VMAs
Date: Tue, 10 Nov 2026 17:19:10 +0000
Message-Id: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XNQQ6DIBCF4asY1qUZEKm66j2aLlBHJBo0YEmN8
 e5Fu2kXLv+XzDcr8egMelImK3EYjDejjZFeElJ3ymqkpolNOHDJgBe0714aJ6WxoYOa0dYLbc2
 bChBF1kiJKgMSjyeHcT7gxzN2Z/w8uuX4E9i+fkkG6RkZGAWq4KYqJlWdS7j36CwO19FpspuB/
 zrZqcOjI9JcVFWLQoL8c7Zt+wBn4xH3BQEAAA==
X-Change-ID: 20261029-khugepaged-latency-fix-40495d66ea50
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3543; i=ljs@kernel.org;
 h=from:subject:message-id; bh=frmUoMWw/pesiZEDvVRHRiCCGgqcEy/Ev4fY2Sa4j3w=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+Bwl9cG78PWfppZNfGibtOJbe1y/gvrYx1yBGyClN4
 P6eS9ZPOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARs8UM/2y9aqa/KXJ93mLY
 zb7k6gvJuyfsDOv6Nl+qOioeX6orms3IsH9pmrl7ZWSXzT7PlAn3X69ZsOWhid6yjGfHgpk+2we
 qMQIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: fbogamwksg8aa78swebxc5i871b8ye5j
X-Rspamd-Queue-Id: DC81340004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794331162-806881
X-HE-Meta: U2FsdGVkX1/uZiXdNXPLGf24Ct04eATbBm90ydEUGUvnBv2XpcjaFYYesHUGhUtL+qTQmJxa547MlU8RLptchzfVF2C98lgn7TUEywuVFGaUCCQiwhAYDtlsS8Zar6ZJGCC5ZLR8u7n8CwdQqMbAyQQJv8ENY+bBQAaRHV9N6amZnZdZUK21YLrj+bSF4R3GWM6QSU4U09xwoGSh08RnPBsjM8o31O1QeGqYRPqC0F760CweGulwNz03rdsO3bdCHAo71IRpiU7YhLBPdHzekvWQ8Awqt1rWjTF8YTtxiLO0Pvbsq1LvjaQKcExqaxDUM1szC6Q/PAyUBEHKchBFiRmy4PFWl4ex5mJO/IoeBh8uE8dIc9F+WmiT16HFjg5bU6aebOY4fEB86z9dVVgLt4szhED+uYTdYlKbuRz0YRiPMdN07+g3CbUZMcjyluklG6cOLYFicAkrrVAqZBScd2Avi1Nx9Sd9d6JjHOE30xZ8xThL51AmK1GS22b565+eaa3Zx8bo+ZAhZkFewrUFbOVXTTvPnWuIqOys23gB+OUHr1O4lB6lbb1bDoe2xwq3Sf+2Nxz+2vCckFFhcj8u6NBcmfLeUPPnt4IqcQttGvt4xUQHE+tlxD5vPDC/zMmMYAiMw9rdaxCX+Q6mVm40sLIU/U+WeK1fWljagvz6U+IJGiW16iYwsWjmlewYT1D+0u/S6/IALtSyvKxpo0z1Lgo8Wqd3eK2KlUAWG3tIyif2S3WyXCKzQ4lI3h49GBo9tLrMj1cPmHglgWEeNdDl/i/3Vt3IkXGr21RmNzP53exONDkrvM7s5OvUBETWKEK1N6s4iQ2fNzAwySaKcE0VJ6RM9aJ/ZRAWuXZwYU7xxMKm/xsQvttWBR5ViPt3Oe5f64+f1cCdy3+2Q2B/VN5mg7MlN8bEAkpKUG7J1LirQfOaLb6sN9S0OIiAsK7MquaAwXLwo7ikGFProUiLMLW
 UFX63yS7
 5Q/cdZJoLF5AuWpUAwttGQq8YMngZwtBbyxdGsbb5pTOlbnZ0JQCj5TxSyyBZYs5huNI/Tq6MpWSacsRIUKb4IH+cTxnbhQcwjzgUd6qmpNwOT517VcFMO114UVjGZVHJxuDjJlK/HCigjcmqU2ZBJVMNXMV9PiM2GzpUI4Osc+DrVUYudbmJXzeETk8tqcVZCZXC9vZT8/JPmnJgjlp7vaGX98rWfRKHcCPNF8i8h+QL+D6Mc+UClAD1UHrLRvJ4/QKqBenBMasT/sipgrpELBXwKXG0jNean1RN
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
v3:
* Moved hunk from 3/3 to 2/3 as per Baolin.
* Switched to using a declared KHUGEPAGED_MAX_VMA_SCAN_BATCH constant, as
  per David.
* Updated commit message to reflect this, and added link to rwsem patch.

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
https://lore.kernel.org/r/20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org

v1:
https://lore.kernel.org/r/20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org

[0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/

---
Lorenzo Stoakes (ARM) (3):
      Revert "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
      mm/khugepaged: scan mm's more efficiently under mmap_lock contention
      mm/khugepaged: release contended mmap read lock after scanning enough VMAs

 mm/khugepaged.c | 121 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 36 deletions(-)
---
base-commit: 34f88a114888c9dba49e45f2b0c2a3e83c4c871c
change-id: 20261029-khugepaged-latency-fix-40495d66ea50

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


