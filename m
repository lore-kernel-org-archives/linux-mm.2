Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFA8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C293A6B00A1; Fri, 10 Jul 2026 06:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA2B6B00A3; Fri, 10 Jul 2026 06:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17456B00A4; Fri, 10 Jul 2026 06:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969886B00A1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:56:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22A8B140384
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:32 +0000 (UTC)
X-FDA: 84972563424.13.96A6349
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 635AF40008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bmuMWEqB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJFhjNRrGWhFd4/UKA3CK1oa3jEQdlfP2tw+6VJV9xw=;
	b=psoxOHitTgCWyXRDuJ4LahocwVqWSYWwml0etfhVjz8czWMSN+8ZNf+pzmwLm9lzSG5AK0
	tpKNP2rGrYmNmINXY5LzJHdCQlLlyVpPgCX7mt0bmkkONRSn6YJh27VRomNoo2fLtQCHzX
	a71PUxqnndxVJCbudO4mSS1q4sBLXPo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bmuMWEqB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680990;
	b=NgweGSHad21ToaDAkYlH2ouM+6LFySqW1Qxs8hWtjRL//EtOmZG3WKg2YHfq8LfDSWMDif
	Q3r5i8z90kuDGRCrtNKBIKyd92jsuwWRAeCUPsAyZ2ZAZg5hZivWqouMtLbqATEed/0bfT
	AIfcJjukaYg3OwMYGnN34mKrcvMb+A8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783680989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wJFhjNRrGWhFd4/UKA3CK1oa3jEQdlfP2tw+6VJV9xw=;
	b=bmuMWEqByFKDrkHgq9LDQ6o45YZlph9ybTzEW8i06SsYucuVvujsPEGBhDUpbjqtdhsKfL
	jhwH5WR8sqYPFgztSmKHzp0vKZBjKMZpxrZHRBlZp3njKcJL/ax8+eKpsEOYAEIe0qumbn
	AFi3rsYxug8QgbCe+Ffc0PToTIGkSeM=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Cc: sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/3] mm/mempolicy: skip non-present PMDs when queueing folios
Date: Fri, 10 Jul 2026 03:55:21 -0700
Message-ID: <20260710105557.1987433-2-usama.arif@linux.dev>
In-Reply-To: <20260710105557.1987433-1-usama.arif@linux.dev>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 635AF40008
X-Stat-Signature: rhj37auczseswbi7hkade3hgdoy4gbiy
X-Rspam-User: 
X-HE-Tag: 1783680990-424704
X-HE-Meta: U2FsdGVkX19VbiPL8fJ84neXwOdv3srtEMVjvrR9qbMAxi+kEUg+/dZwEuKjV4HhvbO3TTOS6ort2DHHgppaTZuUD7tbOPX27h+oHR8q7sdVUIXpBQZgyFjHN87Z7nAr9w4QmBNdHuzr8QzVZ4b2b6SLVfaI6ffztDFz7aU5wmcEWUnPf3kUHYULHE0pQ3o4xtTpDUn/gMs6VaOR54sm2qG1LG62WU/MJ5GJ851aMiqQr6oV9zcYnU2cEjHUKRKhF2Gfps/RyQ2PXYDeSrOOSeEL3ZTCiSVPtA9wIWBI+odyPBGBriFsRPWlJISVlLzhAOKuGjUi682xwHDlDAvhO9j+NHQ0dBbJJKjSK4AnpsjAPCnxbU95X+LuAC7sTB/N9E1y9OlhsuD7ENOzHQy8lspVcd8uPBHoE3MvI1lWH+sGFbReVXBZGhC6ovTfyE6+4AK4N4pyAefohBgtVGd8dgKUKdDax6CLyDLnD3K59wXvAokchEy/ktEsDSvOTJfykf4biWzJo0NC6lmFnwXcZPHqcXC55SpruPgFvDm75M8dC668XoFR5QpOGc1rZdOonomqqOFGJihW9zFc/WTninCDucJzPF/9eT2G5X+6ohJNBxtyH5+3N3mMduF2tW9Dfmcchv12b2BJ6ZgYr5Yjn8nKsMbtgpw8ACGArFPavLO/JmuBDtQ4ikdSDFODPpzxuKH86s6IQcgfSi20+uj77vk9zj1Q1qCvU3WMnOUxweSs9AI8DlMFLAsd5cHDyDk5gKCjGt+Pc35CZ5hZDcAwNxptqguTDyB2bo4H+J/aIeQzgwWRLrDpLKXcHnJTWJCAf9XQaY6gGsmjpJwwDdrmU6kKT10Nyqk8JBThqwS2gZQqERkiA8RhyFMkfS/R4nEYGD7RTZh6PTPedMVjkyw+1+Fkxqdra05wJcF/i4PsS7MlpkiL0pjDlLeihV3Yy3cFsR7hJVvqq35CHL49dYt
 UZ9CyWoO
 XIZAqtV/hUuiWBFKQwzFJHA0zGPUhjg5bb2Z/nHKLJiO6iPNfYsJTBTf8aD2a8XQ8QQZBw+4AtOqgrgR05GcAU9q83w+WWJDMHcKGqUhSk7GvZyfh5biEmFYbKY1xvXgGrGVGWk/2D1GuVUDzB6bS8MoW46Fns1tVyL0vMUBjrMqHcBbRtJr96TFRurkN8VLWm/8vDEFFjccdht3NDRavVbfHNTAPdi9Sy5jCWB4v5ukV5YtNT1DtfQamJB8EhfQWc8/RoWJlGCz8HfjWmO/aBMbfX7M1aSm6d4ZMiyef9Asy9aw9WcxN8nl1Bvy5tXbzd07t1L0yCxbv5uaw62q1I3VVvq6VuNbH6rQMRTPYtS1bdz0nsZGanhaBSsSxEmirRKdHRhBxsTenoBYXx+wVPcf9xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for any non-present, non-none PMD
softleaf. Passing such a PMD to pmd_folio() treats the softleaf encoding
as a hardware PFN and can return a bogus folio pointer.

Mirror queue_folios_pte_range(): handle non-present entries before
looking up a folio. Keep migration entries counted as failures, but skip
other non-present PMDs such as device-private entries.

Potential trigger: an HMM-based GPU driver migrates an anonymous THP
folio to device memory via migrate_vma_pages(), leaving a device-private
PMD. Userspace then calls mbind(), migrate_pages() or
set_mempolicy_home_node() on that range.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mempolicy.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 914f81863db5..69a00a324ef5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -654,12 +654,14 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
+	pmd_t pmdval = pmdp_get(pmd);
 
-	if (unlikely(pmd_is_migration_entry(*pmd))) {
-		qp->nr_failed++;
+	if (unlikely(!pmd_present(pmdval))) {
+		if (pmd_is_migration_entry(pmdval))
+			qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(*pmd);
+	folio = pmd_folio(pmdval);
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
-- 
2.53.0-Meta


