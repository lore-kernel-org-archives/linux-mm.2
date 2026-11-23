Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75887606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqxyXrb3
Received: by kanga.kvack.org (Postfix)
	id 010EF6B05BA; Mon, 23 Nov 2026 10:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03D86B05BC; Mon, 23 Nov 2026 10:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40E76B05BD; Mon, 23 Nov 2026 10:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5F236B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:01:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 313254092A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:11 +0000 (UTC)
X-FDA: 85466696742.11.DB43238
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0D5D7C0012
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqxyXrb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446069;
	b=mnc9M3bl6yeOKHcJCkIB+VSU/CzJZL7fhbNhz45Eo/D4HupJpSGPT5fZUWWSeUhR4Av5BE
	LYLiY8A+ggoC762yfIc8LDLffM6YjYPQ7RaeQZZqU5oQFnWeO4y/LLEaWxMx92gzKJ8gTI
	IXWTuxfb9IPVLpy+LI3EcUc0mb018X8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNI9jQDSnSNHPsCwqaBlID0Lh+CsRnV5aWdnjr7sqjU=;
	b=E2DYvPpLBfL0WOY7U+zE2MOwgLM2K1AaNm+o1zzBM620ii2kurUyeBORCWK3pBW69kRghh
	Ebjjnf3lZbeHEjr4EziJcWszL/5LmuDe9uMTb1RDv/WWdeLTkneiUACRKtoqLYULkXYE4e
	PaEN/P9JAe4AMsux67JDTn3rKgtR5Sc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqxyXrb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48D9442AF7;
	Mon, 23 Nov 2026 15:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB03B1F000D2;
	Mon, 23 Nov 2026 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446068;
	bh=FNI9jQDSnSNHPsCwqaBlID0Lh+CsRnV5aWdnjr7sqjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqxyXrb3kLtCUxdK3cMQroGTLUYCR2cKkrAYCpRm7uVgSg2nfIr/SM9tEXkaKvAeF
	 F1yvMRbHQJFtQ06jB9f/bsDS2k3UeWOfDJNqLWuFR9OLejvKS4HCtXDMVC2FipnjO/
	 KiPeSB+l9KRdhk/820wBQ1dHUWvqy/gOUQakf2tyodulVMFduER9wIS2xZGv9LbUzp
	 7XMwV/JuQP0hFvL67VZSxKDcJNs4y7p66Lc6MjHS1UJJ8tgxSLt2oy6uJN3CGXUD4e
	 XtQ5q0Sa491X2uNcfAP4jST0ntlzxwW8+We3fYb2VU4Y95DtY1pZdxl7Q+g87/0Jzf
	 kNIToMo9epntw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>,
	Aveline Noir <jm5905938@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH mm-hotfixes-unstable 1/3] mm/damon/stat: avoid 32-bit overflow in idle time milliseconds
Date: Mon, 23 Nov 2026 07:00:46 -0800
Message-ID: <20261123150049.81317-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123150049.81317-1-sj@kernel.org>
References: <20261123150049.81317-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D5D7C0012
X-Stat-Signature: n8sdnjsn5u1idyp4cmdyuaddtd5bfom7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795446068-932945
X-HE-Meta: U2FsdGVkX18458PUcVr39bQsfEwZIbSPRyvN2Vk2Siuub+stIf+vFpFdBtsrVvLJIHs0t9SMmo593884VaLG08xwr5NItwshcxZm8fLVv3dOqK+ICWbeohFWJfVt1HYmPLYMOenuiFh8coka1bx+Icrbag10EbUn1Enu1RRVnudWZvA4GPko5koZx7R30eLJChbrnWPsf5iAhmYsokiakIqJUcCMO+lMlt08Ml314QdI/auJLjRO7yAGTWKRJQx5Xw2N6U9joq34u33b6K/fcR/pWv2CWCMBBZOY4QUJQRRJxgpglKRGWpwkwmp+6tkOK+fUS9iePhCUKPF1EZZmNVjUoaBpO+zyN39by5SvjndN4U40QqxrpCq34cxPkmNa+f6NJyJsPoH70JKLoHCwNt4Qc6P6i3cFlNdgBjPCwe4Gfn9haXSk3QmtRZ+3idSinqMCt2dNTsZsA66J+HD1HVtGTaoRSdFQDcNv5CzIFjW/rGgEs6OXIjjxgXTsehJSj/DdIoj+myJbR3pKeTxHa+LZavgfioADpgJT3colXKH+W6TEY9pv8gpgW96o2lHoq3nC0jCq1MrlxNoj0doey/ZmdoIsNzT7ndtN6lhTShTxYOyMWW3fHe4v+uEd2Cf8wZdNEX541wKerr1RtlmVDj1ODGWP7fv0l67mwrjsQ+V3gQzF6595+ryPtRu4fkdeEFG2mMfQ5XUCxcBZ4CkcbtcQZgUW/zKYF6T+m5+TulAw4xXTze8BcSlpZnCXrlLV6mOf0AUvVwmn0rTJimr33uB3CT8ID8AxZlkTrYSwJfFBR0yxt8mM/+aSNKvXCxsl7BrAIMmsB9/R1ErFKlAoKDcwCJyKjOlG+MOoFr/yrM40ELHtuCyWHrbonrxxcQjuM3yjcbgBhIctTentAG62XeyK8+NIxKLk2kqhV70m0AzrICynMEMS5IxINMB1hIDjsMQ6z62YFf2TFjRcCpm
 IOru3DuO
 Pxc36nxwf3Ut2YDqP9wRhgnX1w0y+VIB9/r+UKzgj/K10X4HEp5w5M/siYmnV8U9U6XQxjDjzS4tqbI016uDT6YOo+N42oHnt0j3jwpLELVUnO1QnEe2OIllOHPrACuSq27IFsJAMj+NKTigD+nBMvczojFsFGC+1c7mgX2vS86Q59wmD2sPQBLv1H4Xu0Q9IKqbLXu7uMJWrZcuh/Jknafa7fwhNxbnCIpmcAMAREwk+TJ0WnXAeQ2WlNpT6JHnEsuDcH0xl+0AHsiPL/sg90JiCbogsWs2xkk2N466SJJshBsS3ysAksxOM6KCaZAdYsJfRIpZY9Udhejy+SuGtcVCHvLnfjjPDex/ODok5wEUdQIBaauE2I+ADHfBUDhkA78WAX5VQ85BQMegpwD42Qy5Z2LRJyI9Av0p7OWG+p9yK3n+gWgWDx9zeJFPddb9ORY/mR88zObe9/34kfhJEjI+psh5/gEgg6HNms69XTYVrJUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: David Carlier <devnexen@gmail.com>

On 32-bit, the region idle time in microseconds is computed in a long
before the division to milliseconds. It wraps once a region has been
idle for about 36 minutes regardless of the intervals, so the cold end
of memory_idle_ms_percentiles reports wrong values with flipped signs.

Do the multiplication in 64 bits and divide with div_s64() so the sign
of recently accessed regions is kept.

Fixes: e5d2585d9e85 ("mm/damon/stat: calculate and expose idle time percentiles")
Cc: stable@vger.kernel.org
Cc: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261117094339.30978-1-devnexen@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index e44f5bf3645cc..d90a43becaddf 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -129,8 +129,8 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 		accounted_bytes += region->ar.end - region->ar.start;
 		while (next_percentile <= accounted_bytes * 100 / total_sz)
 			memory_idle_ms_percentiles[next_percentile++] =
-				damon_stat_idletime(region) *
-				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
+				div_s64((s64)damon_stat_idletime(region) *
+				c->attrs.aggr_interval, USEC_PER_MSEC);
 	}
 	kfree(sorted_regions);
 }
-- 
2.47.3

