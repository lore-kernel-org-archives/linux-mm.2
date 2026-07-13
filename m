Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 020A6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E4C6B008A; Mon, 13 Jul 2026 01:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB476B008C; Mon, 13 Jul 2026 01:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F226D6B0092; Mon, 13 Jul 2026 01:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7D946B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:01:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F8A816A025
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:12 +0000 (UTC)
X-FDA: 84982554384.12.8DF8946
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A92980006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IJAmj6Or;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783918871;
	b=wumtM28owBCk6+O65DAuoaXN5IrqA6JHb7easziCTGmxpUnPvj3qdnFt01RQq6VTTYbXTF
	HB5ax+LblQWuoLR1DNY29Xp7KAQdKRgBCm2z6pozc8RKwDUVyZBZIpo9Jo5SWq5ozt08qA
	ESRM5wz4Grb3XJoUoeV6/bZGxvj+yWA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IJAmj6Or;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4QJWzzlMWk0pzjrh/kIUBFqv7MkDgdeVbg+oJnEmxQ=;
	b=NV7CpK/E8oIKToEGSC512rPTPpJXa0iBowRl6SkMqOj5/VTiIEIRdyf6ys2//AumjKWNy4
	NoqEpKz4LlG90ZQxeBTzlNhDoCJAuQBQmg5vK0iEM1Dar+ypWTPJ2EvQl617LUleTgEmB8
	aQIP+8JahkjFsn0+ieGeErwN/9RlD0E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 855A1497;
	Sun, 12 Jul 2026 22:01:05 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 85BE03F93E;
	Sun, 12 Jul 2026 22:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783918869; bh=f9Tys1Cvm6yJflSHdH0xqAExQOs6Nr0MHrCE80JqbDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJAmj6OreHuA8GCVfOWOXpQ+RGDdi9qE1KRh3Oz/kBGduz6kKMYeTYffG8IxuCqEf
	 NjBd2C1fNlzbeFWFMxY4kVhB6a5ESW7piA6AG5gkuv5/wbRaJyHwUxC88+bMCSwLaM
	 zBGptXblrb5E7gQvPqfkkCIYAdg9HpciPjjAklhA=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 1/5] mm/rmap: convert page -> folio for hwpoison checks
Date: Mon, 13 Jul 2026 05:00:44 +0000
Message-ID: <20260713050050.1017741-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713050050.1017741-1-dev.jain@arm.com>
References: <20260713050050.1017741-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9A92980006
X-Rspam-User: 
X-Stat-Signature: i86r7o6a9g163m8mmuwomhn4cx6wutcj
X-Rspamd-Server: rspam03
X-HE-Tag: 1783918870-478026
X-HE-Meta: U2FsdGVkX18M8vebYYyygngNPS5OdULSnKcJmW1MOZMRfMeoLry9iJi8LxTidFJpBtnxGs7hAuA/PDUMmRDzjcaGLp0vudfjWS0jATFY9sPoyu5PU6ak1Y09shxdpHY8cSlmiiYHecqeTgmbOHg5bOGKa+4RbfSCGw89u12Z0o+S2a7x9FWmu/ITHej60dfZ/5UDC2OJglnUjdNCt4QP1ah7x6aZ/lrBXdf98u1ig6pM0M2zCPcJ7kl9QLiKA1k4cL6sps8HVxOxr7/gyFmse4KmHT/0EvKWZ/vNGsZBoR+pbYzqvcrowOIIi1++pJt6fq+o9dO8Fea6TSxg63ohGWDJ4ugBta09764MLj9ffoL0cyoJ4mjE5HdDE7pQBzz5MGZAAhQYD/OseSH7K4z4rDRXgL6kTThGwnzCDq0PlzQowhPvIY1itEfMw7o6ozaV9/bExN4Zbp6zv7kp6P2xyt+3WbtHXIHZUZ/SiTG10rvJlKo/U6minaeZjwfEbOgVIQeBG0hWT87VgM0IVoWXl7ozMKEi9Si51x5IB8Ig6fMc69lsV/FeJJ9EJAhV9TQfxRUyX/7UsjINWmSJ2tFl4FJVPHWrw8MnB6d+j/9ncfB59selwJ9csppxVR1XzfER49aCBGmyr2fh6Ya2TBTIj5Em2XZkxYmXVsrNAOS4XmlxTWLt5ZxHGVdMT6Kax1oZRk/JtCQ6AOJlBqzS3BQ0qE1PJC3XRbvWEAhGh8ooTnG2fsW3XuV7VCItxuiCeeXEjzOFamS9U4zMMqt3s/6YMglo35YDjpvNpQ2mWaVhMrW/Vt1JxpMpJKiFFlMt5Jff/B/yXHZR/ThR2TzJ+cy4w/XqjJVuLwS75Du0UWFpLExNGfus297xowjY+a6REUwtYjKIeds1SmO/CZZKidJQFzt8OtqjCyh8IezTqXirk8JFVid8Bj5J93QtsMpad2zbt8Z51NcvIx9fPxmsnym
 0hccK7cf
 761Pbq0mq9AdWHBU6NgqNy/HMtY5WI79BrxP5+Vq2UV4E87rX+RUBU0OTekv9W1gOh8LFJ6yz3G2R29sk8Q9jnt7WeP2Y/eSWwammYOa/+lGbFSox2+JoWyOmqA+XaDTtN2KglpcBb/G69fiVkFJcPt+THs11X65bMeM9Jx2nwi6oua8NHTdSOXb+OeCxTZyS0WrFKb0TJCLKRPZqy/FRKZXongM0VN2I9/1TVgTNU7phtOi0nH95SRxFoO5evSpw35+3wAHM6LjDw88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_unmap() receives hugetlb folios only from the hwpoison path.
hugetlb_update_hwpoison() sets the hugetlb folio's head-page
hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
the head PFN, so the previous PageHWPoison(subpage) check happened to
work for hugetlb.

For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
folios before calling try_to_unmap(). Hence it is always the case that
if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
marked with the poison bit.

Therefore, convert the poisoned subpage checks to folio_test_hwpoison().

No functional change intended, except that, while at it,
convert VM_BUG_* to VM_WARN_*.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 26166a6b8cb9b..2b74668f356d6 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			bool anon = folio_test_anon(folio);
 
 			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
+			 * The try_to_unmap() is only passed a hugetlb folio
+			 * in the case where the hugetlb folio contains a
+			 * poisoned page.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		/*
+		 * With TTU_HWPOISON, we only expect small folios or hugetlb
+		 * folios here for now.
+		 */
+		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-- 
2.43.0


