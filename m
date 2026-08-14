Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EEFC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC536B0658; Fri, 14 Aug 2026 04:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D946B0659; Fri, 14 Aug 2026 04:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7773F6B065A; Fri, 14 Aug 2026 04:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 519026B0658
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:30:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C895B1403D7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:30:54 +0000 (UTC)
X-FDA: 85099204428.16.C117D65
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id E98EE80003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:30:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HNVrXq85;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786696253;
	b=qWJF0LV6mHxhRYpuS0qlwzXyxBVn0sNoM5lwPzJHUApowC2KTIDXrJmFXDilsKcbjz2AWN
	TtsOvX5NAblg7RIqq/V8pi1EPb9kTSBCBY4SkoynRPErBHXjaJocJMxfxgfoLg1CcGYJOp
	Hge63IbSPcpnD3EFq8GRwFniwjunoVU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HNVrXq85;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786696253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U7hXadlTsmfu1w7IwtOEGxiT9suiSAxwHVGfz88KKmo=;
	b=tlz3A5bhiP9vl97lHFoNiciDzkIReBnMBG+gUvcyFjo17XReorLQnsEkLr3zzO+Hwl9nT6
	zEe97Jen8A/q3cGlS9p1C8Y396Br0kw3N+tthcL61UpkDgfKJwyeCcoiU/JgIKMEPDCVxy
	fx5oDlUOnk/N8XdsNUakpc/x6h3yAGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=U7
	hXadlTsmfu1w7IwtOEGxiT9suiSAxwHVGfz88KKmo=; b=HNVrXq85autWHmgg+G
	z5lnFIohYGRpmjRTUQ6u1tSGLSWWhRJXZ0y3CpKLBruX4QZLTNIhadSRDPnWMlIl
	6cBLlmQjaOdLm2If/ctaBPfhn/f/8hsaG20JBgXTwow0NIxWFImtN8AK56NH+JPB
	vdyOKEtSvmAhiR2cPKl3xE2e0=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAn8v4n0n5qL0vyLA--.16890S2;
	Fri, 14 Aug 2026 16:30:32 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/hugetlb: keep max_huge_pages when dissolving surplus folios
Date: Fri, 14 Aug 2026 16:30:27 +0800
Message-ID: <20260814083027.1419487-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAn8v4n0n5qL0vyLA--.16890S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4xJw43KFWrCrW7CryxAFb_yoW8Xw4fpr
	y7Wan8u3yUXryv9F18tF1jy3W5GrWUWrW0yFyxKrW3A3W3J3srKF9xXw15tayvvr4fJF4x
	urWqqFZ0gF1agw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5EfOUUUUU=
X-Originating-IP: [240e:46d:1800:11e5:54aa:27ed:61cd:c0f8]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3Aj48Wp+0ih44QAA3q
X-Rspamd-Queue-Id: E98EE80003
X-Rspam-User: 
X-Stat-Signature: 7o1yqq3rma4icdos4hw1zdycq1k7e4mb
X-Rspamd-Server: rspam06
X-HE-Tag: 1786696251-619049
X-HE-Meta: U2FsdGVkX18eEsn4hgHZC7J86d7Z6uttSy+roieu4fYLeLUwGcuKCQAWZiB2VYZUDx9Bzx9cIwHcr8SPpJefoJWhmc3/6UiMLN8sfOUpr05KwHV7T+bLyDr4w3STwOSLdckINan2fz6V5doO3+LTWXLjGeJE96NJbnpUpTaTyWQA2c9wXxEtDHT8uMYqnwrCXfukf9VpSwt7N5NoYZnGr7k/TOntUYMOh5XLw+GAYQH/OznWYOgBHH5MhU1KIN6jP0c/k77bq8epH9ZvYRMgL+w8Wo4/mUhaP6xGd2CfyxgLhVxVGD4CmlVTMNfRfr+rZAGJteIBxz6Ul250fqt5RpPobdPB94pJMNrSzjLk/5sjQXvEyIhX8wBKxwjuM0c+X9J26RZCWinpXC8VqZ8ajqVK1d4ZFgJaKeYgsx4OirVtsjEscJQ/7eeSH9Cb/XJ7d7jcbptSgPbjQsLtiYOaPZqnbaWk1mZMQh33rL0KUgkdBbM5GXmvYJppHKe7F3Vy/CDCFhvN5LbVhqtxU7GqWRcPjgXlYS3e+4Vmuo0wOLzTfzHP5sk/DeKPi4/LAQgrUJfWYp4ckJBawS8Ixm1G4FCWltHVZvI6reVoVg4s0TmWXbAa6avQs2E37lOsbaDym2ccAsbYxfprgfqjwhsu/5GsUYGT81L5FOrYuRb37gRma2ScjN1+iK4mKOKH1m/93KseNdYUsLPs6V6WdCCdC4H9OolO8/VXGBzp+kzZlnBXjd22rtVNSws7W8ftfjUnhBfsGhYZi23FWEt8XvHtJAfcOsfYnM1U7Kt5qLVDeVcApkt1hGNmayX3V4DCUaVfWUZcZiItyCtJ0bIcYkByBWYMNpuNRq7OzbDsaldEgn4vQvLEnyHdXp3hpWCOkMwvWO8f3Vt6lPNb4qMjxlF9qgi3yi3N/QuWZdS+RA5x0ALaL/1EVp+S/3XjJ71mL3keV0TZaf+eDA2W0SZtu61
 O/Doemhp
 hmG8JdJMpWaFa2P1aYZm4h0NaVkb3hBp/RqX3SythIzeNOEQ7HoGMslpgCJEB6V/kHwpMZYJrGTl+tGF77thi2L3Otd+MaN1+4/G2SJvkV6a88sisRnCLEs6WbDI829ta1uwSNpu1u4tNkGPZtHyU4bV07y0td2ar+LB31Xxe3ElTztNL6MJ029oP7ez0+yC1KOBrQJKw4Rsaul+mozNGxRmxfse8VJMXAs8SXkilr1SdJZ5pBHIqQDBUQBXN38W1teOqVe6eI5OmDBEmt3KnKYNP//0iOTm9k12HgJRAysJzmCSmS+D47Ilvspl9Xw08tYc2btgbNp/lt1/ebWKapIf4lew+h1x2OT+DG8uzVBE3++E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

dissolve_free_hugetlb_folio() can remove a free folio as surplus when
its node has surplus pages.  In that case remove_hugetlb_folio()
decrements both nr_huge_pages and surplus_huge_pages, leaving the
persistent pool size unchanged.

Updating max_huge_pages as if a persistent folio had been removed can
therefore corrupt the persistent pool target and underflow it when
max_huge_pages is zero.  Keep max_huge_pages unchanged for surplus
folios, including the vmemmap restoration rollback path.

Fixes: cb402bbdabca ("mm/hugetlb: fix surplus pages in dissolve_free_huge_page()")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/hugetlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e93c4d2456aa..2239e2566a52 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2002,7 +2002,8 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 		if (h->surplus_huge_pages_node[folio_nid(folio)])
 			adjust_surplus = true;
 		remove_hugetlb_folio(h, folio, adjust_surplus);
-		h->max_huge_pages--;
+		if (!adjust_surplus)
+			h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
 		/*
@@ -2022,7 +2023,8 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, adjust_surplus);
-				h->max_huge_pages++;
+				if (!adjust_surplus)
+					h->max_huge_pages++;
 				goto out;
 			}
 		} else {
-- 
2.43.0


