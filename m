Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D427C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9304F6B0095; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E07F6B0099; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824A06B0098; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F50F6B0098
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF4044036C
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:08 +0000 (UTC)
X-FDA: 85053404016.27.FF0E288
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 355671C0009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAzyu0co;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	b=JYsOLKVAm1YqA5Jt65FrtfxbK0mXzRS5kiQuD3X9t6FWnR1Wvp0F4OzVrSV0jmm3lJ+fCV
	EI2uTSTThumNrIVrPjUxnnYhCzf0+4QxBLPEmXMH+nwiRcO0lzEaKI6OBav5E7SSkbDS+K
	SbVqDGwdQ9Yy+dgUIXrDJoT8zbRnI98=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAzyu0co;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605767;
	b=GvY22YQ3ZFCk199xagzPHlndvg2lbZnqQ+a2GZ2ibZweM3G8W/l2YMgrxdHLoCI5qVSFRM
	/47stPTXccvRnQjXKG6Pgrx/SZMK2ZviFoYZLq2zqdGpPq3937gbExm1i2xlTr+1CBl05w
	8CKPz1ahpEzXa7JGD09RhKhlvHtn1YU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0F9341658;
	Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEBF1F00ADE;
	Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605765;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAzyu0cofgTIbETEzsvvZxvktgzPaOr38ohWe+pSywBKNnruYBRn80Ts4aPf2VJjs
	 0C+v4MzKnZoWjO1+ZtLDQp0OZduK3ZJltgJjKmPml2Be47S83ErTYXSBht/ywD5sdB
	 3srSC9tF7QdPk32ebtnVGojvHAsJi0L/wIuMk5hyKMu7VViWMQsjd6dJxIg4St86PV
	 qgGsSzfHCOKtiSekrKn1XcasvSIEZ1+GqdWxHv10lzNoGdV0mjyPtCskFFAvlnRGmD
	 pVsDF6gBalSNqIr7A+meMOum8IW/bqqjOTI5EceRtpFkZqPa65f+a4NwxjqAislL7k
	 Zh8w7+K2PbSyQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/9] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Sat,  1 Aug 2026 10:35:47 -0700
Message-ID: <20260801173554.94710-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 355671C0009
X-Stat-Signature: gpnjqhntt6piqd5h7qkgajxbscyzhshd
X-HE-Tag: 1785605767-299887
X-HE-Meta: U2FsdGVkX1/smQGwc/wPjHz47bW6wr9yvd1PdSBNpmcsvBkmEh42p4tqXukMLGzzU4o2pgmEtJul6SOzYCBdCpJFYhJF7F6EuXfAzX8qhdE+jyTKN3evn6DmzhCIZIiDqOREzW1ra3crF8+1oJ5Mkoh7lhMHw2oYwj6QPB3uXoDctjPCrkkwKDSo5jqo22c/NGZaDm2cxToVkAC1031ixTl2xJMMYa2hxsWvd2y5g31BJqH0M0UPys+OwNiNv905kLfDtxu5OHeuZywxpL+peal3XBhTLdmr1LCZp1IryAT09Qf1195ppmcAKlNVphpvu4loKOZ3pirozT4TvkUh5MZt5ZEzkFrqfB3aSOXh/t5pTSW6GppHof0EzcW75QbROkNim3GB9zbbC0PAyIcKLLVEb/ID9AX/PBWvLZPNHY44akE+4sW5Qs1FnKQperMpHyXtxORcd3YfTeMih4zhk/El9K/4vzeULI9iZlna4f/Ue8tRRs/CnM6NPnpuPFS1zkW+prd5R7Y33fEv6SqpJq+5BL3MsgSAPMs+oUGKQVDqH5LlrWZoThE/pju6xKD2E7boNJlPuLqG9UQycIBPPb3Fni7IUJFjT795Au9lJVnhGLw348EON4LD9MNOYQESPd8jTMym7h5GMP40/1Ef9av+aQa+/CO6bcOXMUxuZSFd3KlA/D/xUv8DcCySW4D4FaW60PuaxIVQYNHQeVICC3BSCJz6YKA3Jib+iXM4U/0tTPeXwkwLcObKLclqyyeeYU80iHoq9F2bngPBTdeqhMcopg68M7IaGVgLNbG2oRAH6HLY2GMlexa8Gb7r6yrxwc1wnzx1pq0lK2zC0yAAUtexdBWM4wI+8J0+qZVgEtVbDuxoiWCKoSF54eeu0LaT9KcAzlLBKRkRH04wuc0i2JqwGlNBJbS5ZKGtdzWyHXKlkE6Ve05uqy/JUDyAp4mSHH/kGLhu+GSSBU4UTIq
 HklBmGNi
 P7ma75STi6XqWCD80oD+K7A/IkG0Wrv4XOdW/4Rs2q5ImU6RTd0fTF/lzeqSSmsK0g41GuaPICE0MdItGDnbZw4tn3mOTJtuUlLWq2DAxX/ngIe3BoQuHAxhxQByuuxWLT16jhZNo9AyOkEYBsCpa7w39nGaUNoewCG03W7f6EBNQdAbi0Xm+SymUlCOswN1ofMivTxc0xSEOL4jdpUco4ULKSfz6atHKuxLWEjBDlnH9O3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few functions for applying DAMOS actions including pageout,
lru_[de]prio and migrate_{hot,cold} in DAMON physical address space
operation set (paddr) collect folios of the given region by getting the
folios of region-internal addresses.  Then, those functions apply the
action to the collected folios at once.  The collection starts from the
region start address and advances the address by the size of the folio
of the address until it goes out of the region.  If the start address is
in the middle of a large folio, and if the next folios are small, some
of the next folios could be skipped.  Fix the issue by advancing the
address to exactly the start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org

Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2ab7b3842701e..9ddd1ec8202b7 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -264,7 +264,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -302,7 +302,7 @@ static inline unsigned long damon_pa_de_activate(
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
@@ -350,7 +350,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
-- 
2.47.3

