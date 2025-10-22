Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD21CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7848E0003; Wed, 22 Oct 2025 06:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467AF8E0002; Wed, 22 Oct 2025 06:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DE58E0003; Wed, 22 Oct 2025 06:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24D138E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:17:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACC0511AC94
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:17:11 +0000 (UTC)
X-FDA: 84025347462.14.79B8843
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 261BD40007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:17:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761128230; a=rsa-sha256;
	cv=none;
	b=qjkgkk7c1Te6BukQvvSUZjvl1FBEi/cgqCSduv5Bv9Q5FBym6ux0A7Icjppt+KfxstJ70u
	5WRxNTmyWxOM0WZOghryZ092OV4uYHvlgBfM+ckkucPhj1bXoMzbEOoRUGnJKQ8JFSpOEP
	nkgK3exoW2tvsGgQro+s82MnHxX3flU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761128230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pI26jSth5x23OnT0HfNt5MS3pgHyg9GaYt+i3VjOcys=;
	b=pAXI262OSKzcuOuR40E1IJpznWWFrDPT8LGNQJIbG15F+gG4VOs7Uf80aFB3ziaCxQmmS1
	fFM5OpMGBKzgkiadY8J3LbqcbnMT+2QqhC/z/mhVOEt0sPoYphk36uvsoxVHchld/ekT2p
	owTg9DkURtQk6eC9w7d5kdGIfGgDYkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA4C044E96;
	Wed, 22 Oct 2025 10:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102F0C4CEF5;
	Wed, 22 Oct 2025 10:17:06 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org,
	Yang Shi <shy828301@gmail.com>,
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2] arm64: mte: Do not warn if the page is already tagged in copy_highpage()
Date: Wed, 22 Oct 2025 11:09:14 +0100
Message-ID: <20251022101704.4015055-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kfyi8jkkr6ikcnxrxajmyq5e3eztyb85
X-Rspamd-Queue-Id: 261BD40007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761128229-912371
X-HE-Meta: U2FsdGVkX1/s33SOZeGGxj/0sQnrV17fVXdS4WY1Jv9nsnmH+8OcLH/PMwck/f+7w+R+Hnk0EIpsmXQ9wydooZIvx+vp5/DNzihlHsEAQmAH2B/JErTTCyymlYRt36Y5qtkjPiwhGUN6yfsL725VK3CyJxKz49LCrVNLkwOKVKXQQIYjaJtZdWWNTbNH5pafdnZgkx5Q2dGb1SAamEHzeOXFqCCsczOqbEpDxOnM3g0hRnM/0I/lNpxOBiy4tpojcMmYqBtMju29Qw2WwtLLD8AW+b+FBgnRoEKJzqH7gueu7S0qmJSuPjs6bnFHDU5q5uuIOhAslOti3eAx0QxjUFq254dM+Bb4vbxpASFjadCukIuLsm9xohKH8nOqbSOlVEn3O4YnXZ8E/irUMiEXS5i4kBNG2RqAdBq6A/WF9ElQ8T3Ud4vaP3+3ZE03Y+Hz08/9G5kJdyKEJpydFsKEjI5W/kiYOXR8Ji7fxHPdPqfGtFmcicKe+Nq7ipI/6yBXq1SXhZiPx0Q8c34Dp/rNtaJhtWX7CefDWX+3WR/SjU3uFPAh6s60UZpMxh8Qw9NQiHt03KLrKgBUXicJrc1oGITsZfmFmrzXFVR4B7byFkTv9LcE2tsamWjTjYesbj0vCoPi5LV4iYPanRnxcVLFDJ+eqlgLDu6C0wIYrNm0bbOjg35XYD8Mb6vrWKSb7ojwgG1ucooW5S2Nenh54MjyUAqDDtyRYMVPzQiewtZv54iKaX7hR+l3ARi2Oe0XfpF3wdoomykknjwTymNr5HVEP4GbqUqAphx5fdxEFr24Z5y4Iewj3sYAv7rXtFOC5SJf/R043N9joacT+HmLXSta4miPoNTnOu61sEz80LW02LcwfUKyXgvaWQifgU90TTwTyDg+v6X242xYuBtnkpuZoe4/sI2ibZydWNobRiviemNhTfNruNT/ejiGuP2BC1zk7tHM6CpApM6W1cKoRHi
 WizdgGW6
 T+hGK1uHL0tskzJbg3s7R7Lyiqd+EE+6XwvOcY/N0HjrKA8fJ+L6+9D2bLSi+g1I4ydXlEeBJxaJJG+mV01NL7c5QD6OQx+wlMmQ4bi77Q7Ambh3/P0zzikOPhKTNHY6cWGFKLkKvtjhNqBp14d6zwnYWEcI+TKObfk/eZL8OCH+CefC311F3oQosoG3FG0pWaHAVUHuVfSKnSPQFaZTHMgOGQHYUlz6gUzX7ktXEnUvDrNWaaVgClWm7swnDfN35HqYEODa+/YacCItC40RhDu6UN3BxWEC6jGCJ1A7YS/JWnxUv9ElRt/vL75zXdeOjUClTfKMfSbDpSUbtEpsz6wQodR3AU/S9JC4tiM+rB7jxqIqsUUjQc+Pv8bN+QUMRBZgf4lt3o3eL6X91Gmokitm6YTqH2iY/eo40byKLmhRNN/p5EDdKJmcM8rbeNUZXGfJDxxmE6TTkXD/UqzL2rBAWI1rXKRI9gvHeplH4gRICzPMlECyWVTl++wvYmm21a3EZvxbhDDwWDsr2jB8X3XB8bwh+Maif2EhBAQBm36RvXTWy47OgdcidZlaPtNS5D2MZz3mMIvUtxVe9lYg1hlFRj/B4i502WqhtHlWy1oeWD0Ot4R6S6DLcH2O53z+vvrn1sc5BKc61cK9PxcXwFjSNpUXkNQEcwoV4u308H07kKXmUHNWRQfIBgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The arm64 copy_highpage() assumes that the destination page is newly
allocated and not MTE-tagged (PG_mte_tagged unset) and warns
accordingly. However, following commit 060913999d7a ("mm: migrate:
support poisoned recover from migrate folio"), folio_mc_copy() is called
before __folio_migrate_mapping(). If the latter fails (-EAGAIN), the
copy will be done again to the same destination page. Since
copy_highpage() already set the PG_mte_tagged flag, this second copy
will warn.

Replace the WARN_ON_ONCE(page already tagged) in the arm64
copy_highpage() with a comment.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.com
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org> # 6.12.x
---

v2:
- Also remove the WARN_ON_ONCE for hugetlb pages
- Drop a double-underscore in the commit log

 arch/arm64/mm/copypage.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index a86c897017df..cd5912ba617b 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -35,7 +35,7 @@ void copy_highpage(struct page *to, struct page *from)
 		    from != folio_page(src, 0))
 			return;
 
-		WARN_ON_ONCE(!folio_try_hugetlb_mte_tagging(dst));
+		folio_try_hugetlb_mte_tagging(dst);
 
 		/*
 		 * Populate tags for all subpages.
@@ -51,8 +51,13 @@ void copy_highpage(struct page *to, struct page *from)
 		}
 		folio_set_hugetlb_mte_tagged(dst);
 	} else if (page_mte_tagged(from)) {
-		/* It's a new page, shouldn't have been tagged yet */
-		WARN_ON_ONCE(!try_page_mte_tagging(to));
+		/*
+		 * Most of the time it's a new page that shouldn't have been
+		 * tagged yet. However, folio migration can end up reusing the
+		 * same page without untagging it. Ignore the warning if the
+		 * page is already tagged.
+		 */
+		try_page_mte_tagging(to);
 
 		mte_copy_page_tags(kto, kfrom);
 		set_page_mte_tagged(to);

