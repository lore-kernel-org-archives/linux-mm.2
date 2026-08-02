Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A61FC55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7966B009D; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497AB6B009F; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339236B009E; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFFF6B009B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15853804BE
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:44 +0000 (UTC)
X-FDA: 85056857928.28.D1AA7E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8351720006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L0eYjzrx;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688002;
	b=ym+BWzVMK5IllcXU9PNrZ1VnzJ2s7c4cg9XEDsXXC6yrEs8D76HWjO9EekwZtj8boAHcub
	K+aWGd7TRUunnnnjG+EK5gk2v/SbbWTK8h0lMgVl90JjO4eT/Hp50ed3D3pkSXb1jvtA+9
	7Jd0EmK8S61ySO/dRgbsewiKevmJFJU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L0eYjzrx;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	b=DaQZhiUVA4QO0kukMDIVtVaN/zI1FfhIxlxjT1B3nTzuYRnshUJyOoa3+7Od8WsbuCEABV
	PIQ0OuS8fN6wxV71ZKyjGCHDIhefObEkfChdljfkZvCbECQMd7R1PEifVlZ6dg2aMm+0Y8
	KS1WQXiYlMr4kuJ7kE/v8IS4Ac2fyOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DEB560DEC;
	Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951841F00AC4;
	Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688001;
	bh=l4DJBfV8Ln2wiu4MTHaklCvhtPpo+9nKnYvuVasq3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0eYjzrxKQgFu++2Z1fBClKpatsUoHdYaOJZBYub+Nw5sxEri0fzDzGtBDsgDsKWg
	 s54N8ydwKySGmQlCi8y6ZqdqP9gtxY7dtM04MtvffC8Eo3YL/q6Mu1QdgeiRsqvNvj
	 JwDM6oTaIGTwvhgPZ+F1dmdWn6vtzSIsMCfP92J0F4Ph6lGHDkpRw3rHBdrwZhTMSA
	 bA9HOfaWSXQq2H0mXX6cMc+u4jRH3wsvqDlpT67rfKJRZ25Mxdt0O60W0L1/iNUK7d
	 4ABzC9WYhyyguy7cIQoAxBRy8vYloDUn8EOtCJL41puoOrQvEBJaf26Rd3ot8jUptZ
	 oCqj8NAvfe/Qw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 4/9] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Sun,  2 Aug 2026 09:26:25 -0700
Message-ID: <20260802162631.90304-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4mndb45f4iqmbyjrrz6u8fuwcy6w4o6h
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8351720006
X-Rspam-User: 
X-HE-Tag: 1785688002-395129
X-HE-Meta: U2FsdGVkX19x2EsPCffBgWiBxhYUVY3yPdHKlN3hq1Et84DShApz3FJS7zjaMXumQaoXRYgQWg63QGRqy/zMldpje61ym9aVq7O67BVFlPaKZzQHjmibkMEWqrIRcn26jQ1ogXMUuxtjUTKE0uxkmApqxSRiS1lAKszIjVT+7CbmGL7TLYsZtrxzu5rzL5CGOq6P5I9GruNNki4a4oCjb3Z1ZfSHmeS53grcRDFygLP1v/NvEj4PZvbHViqTrWQd+tYBOW+UgVNKefIEswbng9Vz1jc2FVWFSbYx840bPzoDDK6wnTJaDVdrzAgKIJYlc/p4wT2B36GpQsAYPXEInioNKwJzqZN33hZ2c63W/oWzI0Lzh1yM+QS4mtPXXLCODHgp/wLLQr1ZmKCQQyZllgPCoUd9IY9AjoJRGVn9pcy3rDNQ8ryVeipL7vv6Z1CHtL4/YMnbC9FJaU4uRWHCuBWpB33p0g6WWaWb24pQDpILSvm1LU0gik1WutYNekxk9/7LQaV/tBXaiXEkdRo8aJZVBz0s7r3v4JDPRBFj1Sp0iP8jvn1pOJ3X42qPXv+zT1nyDvOQ+62sK1O/jtETb7BgaVVeABzHOk05mj13o5IUWs5N2vMB5oImIHx30ZozbnvCh5eyMuIC1fF7OaJPtNfosfiOjErXvDk0ps1PQKdLjngbAbuCw97NHqzLs+SSPgEUtcdNcRwPZKPEf7+2lb+FrFQLMcqVexGZfhFuV8QGBJDEhPdI7FFmWiD9nPstK9MrQM5WPJBU6nZQW+YiK34d5vTjApSGluFTPU1ADEcKp7p7MsxsNKml79AKzwTSel71b1PBLRC6ophDkckqYBK74Lc60FAKERSJj0NCwixfxJKHkG+hTcrAUNCikYOdaZr6QZ42xFM+VLDABts8/0lzRCF7bnMhtjaskUGimAAuqnVHnUe6rWOD1I0O7Zi3Q6cad+ISkd0B+EQPjAj
 uZ8Xk6lP
 SXEoWIJ71Wa8hDq+Zdj1jyr3F4FLnTc2UBVJOLr6Ct4HfWEQFMmP4X+o3NrsvGBPzFSlStCckMD4cPmKKyV9u/tsGpzuCz4tUKKnDYvmSSnxE9wwVcuOYJ5/ZJaEvtvXK3y5dBX5O3FeEuYJXyYarhV3jfhp+TwiFrBBhJx7XBSNXHM2PW8yeULB0UyoQ3HZ3gH0NK/mKHo6Bn5OiZj8o/iKhFx/9iqbr2mYrT1mCaONJBSQ=
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

