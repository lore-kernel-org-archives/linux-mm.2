Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28F9606A330
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aeyY2b0U
Received: by kanga.kvack.org (Postfix)
	id 4F4B86B05B4; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5336B05B5; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E14B6B05B6; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD9A6B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:51:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B8AE804F7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:56 +0000 (UTC)
X-FDA: 85412997432.17.24052A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E4BC4140006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeyY2b0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167515;
	b=TDnL61wag5pF7QO5twq/wsPsfYuqvqYcCtYoPyRO8cO7NiXNmSZWH2aY8jYo0RaYgIP9Yh
	PiMt8pHTvAjmmFLZNicvYa6vy+JRrga0K+s6g3dlcWgo+zq/uycSX6avo55Xkktll1W0Ci
	4M0E5hplEG1J7rBumeFHBpprMjVOEis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPf2icVK/e9KPEuHFkG431PIxwdSKi/zxFeSHw01Gc8=;
	b=Q8nmGqGxtANJR1wQICDqWu/hzZt5pDKeGng/idcg1FevQe0DmnapPnqOmreiVTnDOzMlK4
	/pcGm6i8bVqHeEInQen6IK2ivnYyGCfQ+llnBC3RXMxnhHpfml2gCbZSJFpN6Cu2PsgxmV
	BDSwB/YGnfS3WKCRLBxXlr7fP1naRSI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeyY2b0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C87A612E4;
	Sun,  8 Nov 2026 19:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E021B1F008A3;
	Sun,  8 Nov 2026 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167514;
	bh=WPf2icVK/e9KPEuHFkG431PIxwdSKi/zxFeSHw01Gc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeyY2b0U+pVvzfaEu7crV5Q638Y6kIWS973xwV4XFRmGvJloYgfALxwwnftPYNWAz
	 d8EGZM2evKBPjgNjn+aTz898OjjvLMz4E4arzIekSwelFlp+F85rrR5bQjgO8xz2WU
	 VpJwSR6o8QzW3XZRNuzZ6aM7S0t4z4tfj1noDvDNZ9gClfV1oV+3VnVWQCNXwlzNTL
	 PmZp/8LSUaHpTFdX4jBqrovLJyIdObNTZJB4o4kFCi/jzVFA3IK77vOJYz0iRHthlw
	 fLcS/12S41EFbZzTGYkspxL+zkyDiQKRkvhMD2mF3cVIpua/bpcJHokGTdr0NO5wUI
	 qC1tPjt1wMLSg==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 2/5] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Sun,  8 Nov 2026 11:51:41 -0800
Message-ID: <20261108195145.115792-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108195145.115792-1-sj@kernel.org>
References: <20261108195145.115792-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4BC4140006
X-Rspamd-Server: rspam12
X-Stat-Signature: n7dcns8mcygoih7q9iuftwcuyrqgan3w
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794167514-703753
X-HE-Meta: U2FsdGVkX18tYRb6k+G1e24zs8RRJislQ19F4c92SeSASm6iJDaJ15R9tlUfbgZIRyoJ554BjFlvqx2MICQ7pOwFP7m6H8dm4qjZhq6JjkxpkXC3HqFEj4R++SDsfoib4I6IqW6npe2k8UBS0wk36lPcmJ0H6PbvKsJwJjiKhBKIkQ+vcN+x5ESoGmA+kKfSGC//UhBKR8fNK6vscLKChC+3+Wwa9tsm2NLjFC5MCoLzLesPkLyt54+p7PnsixgRTS83Dlk2t87tmI1IJvqnFc0yvCvpw75ogHUHqG3EtzMBSv6+4o3+9xc1bDURfNolCDeMbSDZO0VEXRt9rqs0N/z6SBeMreEiKe43IYb3WpPWm2tncQkOSOA+vzxAuGE0WmgciJSUc4X57tpNFKFalPb78c3jlUivBfcVFFXMCYruVXylU5HI3r/U9i+pqpBHoJbQatnqapSyIw6j6TaWdtGMLV3xfwxKF7v6GvAaysOtDeIghy2wHRzyguQ0vz7aWmHDp/XavEoa8Mmb6EzlyodZ3WHUjVYZIlpUAYBZpu1fpWEZ9FsndaknSTuzI53BwUIR+vi+H1aaglvKP//w+GtozCswd9W0K3Xf+/Xum9yMfKVCl1f2A1fUZ+eZt43UOSVP6ZP6c5ISoemcpBE02CWj460d1kK7/DB3l/P4h0fYWrwAuJuvFP9wcLupDJbMILISktU3MXa3EbNQ7LAi2CXimA/Ktk0Ywnz0RaTLWBy5mtJYvp4h/IBALgb7JmtksCGQtB/Ieiatw60YSWqNtUuwWdj9edERMlyARxJjQGyrXPlCbhH+wxfrWJ4gGD1PAGqoXRtJ4zI+t1iMQybVNJCIhXVO3v6dW4mDC5RRARs6jWgO2QGJw9EEQ/Krbx51aGuE9XcJtGHaA8ZdYuA1jzv0dfn10FVLvC0sqlHyZhLpLQQMiKvo2j2mkq0UDqvVeuDFU9OFhjCXLOy7EoR
 bfBxfGVD
 bbhSji9L0k4JwCaMfvuSG0OIeTz9zPOQIeCTpoRkPD1K68oGhBub24XZE49p/92iJjM3QgzccJt91IPaz7rFY16rW7RPODHCBIH8FDu28DliaZrLkxEEa4lFBqr85uhTe4HVGAUsR3OAWCRRY+O47106iEbhK+ihoIhWNGAqapPQFjthhCdoNWlhPioQayV1wdRbWzjYQAt/sHW/LYhC+cojvcwaWs9BE+5BdHUQyr6Lern513KRKxgruZMOw2DapExJXJgJTXuPgpUNqpKIULiBBZyE7rvFObgkwQvOO9gy341Gf2+YrPuOgyrTeyS70IfrvBuYZcYBFUaADEECq9vo040T2LWGlmOZDqd0SNi6X7PRifGEQMtvlfKP8ybZGpPkLx9VpooMtbuOBncktp8qjfDMfWL2FbCCe5x0hhxyqsWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A few functions for applying DAMOS actions including pageout, lru_[de]prio
and migrate_{hot,cold} in DAMON physical address space operation set
(paddr) collect folios of the given region by getting the folios of
region-internal addresses.  Then, those functions apply the action to the
collected folios at once.  The collection starts from the region start
address and advances the address by the size of the folio of the address
until it goes out of the region.  If the start address is in the middle of
a large folio, and if the next folios are small, some of the next folios
could be skipped.  Fix the issue by advancing the address to exactly the
start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-4-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.15.x
(cherry picked from commit 1613ac9edf385c35f171a25610e2706a7e6afad6)
---
 mm/damon/paddr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index a6b1de97b1e8a..6bac269cd679e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -273,7 +273,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -306,7 +306,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
@@ -483,7 +483,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s)
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);
-- 
2.47.3

