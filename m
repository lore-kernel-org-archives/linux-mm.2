Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B9DD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 02:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9032C6B0006; Sun, 14 Dec 2025 21:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3736B0007; Sun, 14 Dec 2025 21:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA596B0008; Sun, 14 Dec 2025 21:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64D8E6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 21:47:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFBC3BE1C4
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:47:25 +0000 (UTC)
X-FDA: 84220169250.05.89746D9
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9EAD18000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:47:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=txPuJ4wi;
	spf=pass (imf06.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765766844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SsK2LlEM6AO7cxB11oqchdkwM94BwPWhmjYk01c6W/w=;
	b=23Xj7+VGiK4dWCuzZSGFWX9hAOqFdb2mScv6i57clwh+Hvit+cu0NYvEkofsA5Hp30umdl
	0SAVPdpLfwXEDw+3KNGU/LRYLQTlVedNBtcWV+zCve6SrydFw1m8rnGC6vvJlZ1TlVp4X+
	xMXB4rg8vkZFKG08Mmp+G4Z06jMyNC8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=txPuJ4wi;
	spf=pass (imf06.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765766844; a=rsa-sha256;
	cv=none;
	b=QujxnzPKJe6OKK6VjwwX5OimbEw7ijtXtNZEpClYUIuLszGBxr8yY4ap2MnIzMzWKHWgnH
	K73DaXS9GuCwdd5fS4Wd/ey6UXllxZaCDVwLsE4vUwbUdrAwoczRLfUiLjejRlPfggOQ5W
	12EQT3jbeiXcMcBaBXEmusY/jzEsjro=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765766840; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=SsK2LlEM6AO7cxB11oqchdkwM94BwPWhmjYk01c6W/w=;
	b=txPuJ4wiwvPRpL3Y/N0ETOEY3v4ST2JxxaeP3R2UkSp+z9u67KulOIwvffzbLf6lOZb3OVR14KC5b958KwJPVMJIQcCQoc7i9HYSkxQS3ejmrf9yD3ei5WChmdHNtx+K8kXqMIJY9axsxabFAGgfXClfLDWYF/JGrwDezDuV/Ns=
Received: from localhost.localdomain(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WulYEH3_1765766827 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Dec 2025 10:47:18 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Weilin Tong <tongweilin@linux.alibaba.com>
Subject: [PATCH] mm/shmem: add mTHP swpout fallback statistics in shmem_writeout()
Date: Mon, 15 Dec 2025 10:46:32 +0800
Message-ID: <20251215024632.250149-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E9EAD18000B
X-Stat-Signature: hta951d3zg3ynspm1exjw3ej8abz8hb1
X-Rspam-User: 
X-HE-Tag: 1765766842-85585
X-HE-Meta: U2FsdGVkX1/ondmBL0ylXn4AAwYoOMANRixonUicoybhzffkDFiQiM2BXXBPLR4VRDugq7DnFN5tE6bvhND8k8qxAXrGcTtFpVhRmb2KzTO1kpi9cl2gSA2pzPekq96mkThik69ac8A+VpaPWVvq59IlR04UNhKw6ZwCVUVh6d96yhLvD2O2G7PV4zOnpjFkNApsAR4d4rkjqQKZ3hfeSiTMcB9OujLWtyAau/KgyLXlCQZ/uLDcjnyGBZtZiqrdidU592+r+XNrsSxZwVgf7TpV35igiUNYTEuuYag3UikC/pZ3tUjXSue/c73WapZCCrLK8ksjw+Vo+xisE5AlEodBTzjEmOrYYoMb/yIqtympak2pFPq97GtZlTJs+tK3tmH/BqeDj3Ot6U3/YtWHL7EG3bssNqEz909lKC4860KEev4bBcGsVctDyzuM4KR20YpMx4+GagImrp2L/N1qBq9zf+m/QvaqDw3mVSFHLYXRUAW/aQwxnBxwHJv9EhD6E6dSDeZQKoEt72YJ3wLyeVXiaVRKKZyippmxgJqoYkfKTH6iY6nL3hEV21gv1ruYYngcqDRibkkJtqsa/mnhVkqRYPTrKBBB+pVdOSOw5EOWsU0HDei9di2mCHAVrhBtcU9HpcqhHlCJz3rzRKO9Mwx8Xn+lHSFy38PQ7RhVY29K4Wrm4uEw5zzsCjd24+4xCrIIsIYNIeVgh2vSbyL4KdIX9Nd4jr88lgZiOALayT8e4Let0zx2/a0j2NTybi2sScTbnULqRYJ3RrR28Mh/adhLY24abmHOrb+p2TFvy+BL2ZzsST1gpw23/Jyjsi4KvqE4AtBlTTJCSGx5TCCFxRwhe9dt5/pcA69xuzcZonQSUUQxMzoHTZgGG7oZ2ECsf/ldaaUUYQRoVLYNZHbGYZtdwZa2LKe3RDu2g6H0xO/nPsw+IL638gbN/cL74lxDpWdhHep/+WJy5VYyeyE
 Y9WWrG/H
 UyadHlb9jmvF/5qHOt7plUqdiIKPc8Om96x7WZPiAoPxfjbnzLRblp4mtvocwvgB2wpMOTcdK//jzZANvCanRTvrQRVQg461N8osvqnsvL6APDQpGl8ZABXFd051FH2cKKLshH4L3FYbtxco2rxZIDkHgOifLiwABjWRyy1BnfJv2ZTfj+pci55d2CIsJz+Bjf8fYGcM0aKuX3G8Y/x5+y+HUtELHiT2jxKOky6a7shcpzT9Q0/riX1qiEMokjBrNy35kSLUPF+eprML6a7VUQzowsARWeDlzfKQMFP9PJx2BiCIfl0t1IPDtUbtIsJBken8TsmPs9HjBEt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, when shmem mTHPs are split and swapped out via shmem_writeout(),
there are no unified statistics to trace these mTHP swpout fallback events.
This makes it difficult to analyze the prevalence of mTHP splitting and
fallback during swap operations, which is important for memory diagnostics.

Here we add statistics counting for mTHP fallback to small pages
when splitting and swapping out in shmem_writeout().

Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3f194c9842a8..aa624c447358 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	}
 
 	if (split) {
+		int order;
+
 try_split:
+		order = folio_order(folio);
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
 		if (split_folio_to_list(folio, folio_list))
 			goto redirty;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (order >= HPAGE_PMD_ORDER) {
+			count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
+			count_vm_event(THP_SWPOUT_FALLBACK);
+		}
+#endif
+		count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
+
 		folio_clear_dirty(folio);
 	}
 
-- 
2.43.7


