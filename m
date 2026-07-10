Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6ABC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2BDF6B0088; Thu,  9 Jul 2026 20:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03996B008A; Thu,  9 Jul 2026 20:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A403D6B008C; Thu,  9 Jul 2026 20:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1686B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA3D4169311
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
X-FDA: 84970969440.22.1675B92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 507FB40004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:23:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDSeZlvP;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmfZTk/ZQOqnVMZqrheWjYkpxjXzlgMLoos2A38U/W4=;
	b=WWdI34jAruOSChduzBDutudKdefGRovM4sPEPYrhaISm6gsVws/gHag1DscSR+CEGLtoW9
	WMFcOGQgWM3/tUQ7eg+pOSLcwwPjIMwPw+yZoPml+p2NtLfuqFbtEFT5Tk4037B1+kF/G4
	aVU/uthq85eVeWoOnv0axa3zzEY+5rw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDSeZlvP;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643039;
	b=nRC5BItROIkNx+ebAeEZkgN4UHQSxZIaW8qHhnpllIvFXf45VrYQZb2P93kjdnQbjXi5rA
	jNLMymf+HAswUL/36GgS1LNJx4t7NBdIENeqMbCswi1ZNx+1CXlfmmFPAq0vBivrRISSN6
	RVk9G5tk4vGfrvJOFMZ2Q+Xp2jRVufs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE1E561387;
	Fri, 10 Jul 2026 00:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E1A1F00A3D;
	Fri, 10 Jul 2026 00:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643038;
	bh=YmfZTk/ZQOqnVMZqrheWjYkpxjXzlgMLoos2A38U/W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDSeZlvP5bHHzrY9RsxTybFnEaDxTHC2K1IKsQ/7vcQQpkoUc6BnaJQHNbkgzY78/
	 0AbJMjuSIaECN3qkL/eaCvjuNboRYhwkwXi6AVQkANWnyL4ugoRDSPo6INRETzYrU/
	 BE0SLuuRm/320dBmKR96epkQzR8KIbGI7ng8kZabv+3JXkdcz1BPZS06ONfCQ2dsHi
	 A2/TdtftgL0Bk1+q2bue37otzDiQjoxhquRlkbxa13/RHyQWvGZ4BUNtf0Lzoc7js1
	 U08rdf+6nbZ92uvPnv6L2r0Tu3qYXJUkptYzBHibZaU8NXpvKCm7h2h7gMSukEX1QA
	 OiHtoKz1khxVw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 01/19] mm/damon/core: introduce damon_probe->weight
Date: Thu,  9 Jul 2026 17:23:27 -0700
Message-ID: <20260710002349.111414-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 507FB40004
X-Stat-Signature: axaswkjfo3nc3wt6bt7cw6bdjbg87c3i
X-HE-Tag: 1783643039-159715
X-HE-Meta: U2FsdGVkX1+zr1d519MMYuJXE3mLdv4GTQ3tQm3vwyibMG0N/HIZa1Fag08+XAkaKHwWCYX/Tpk4gEKatm52idszApNWSdGKBkmSLvf0PEvCTrSDe6yIKRJflUopzvCAXEzD/sLyjvdabG1MV7AkdWfKXVOIVP+aNbrDPZaLEeE1RTNNQKCjq1AYYE4JsET4K72QhKyMaLhoOoBkOuA6BfDu7rjvqiftpHe3u28ztZshk04a7jtjiV+5goqdlZVJTsi6dL1bVGNyI0cHK2yE5gBLwZOZm8BFY8RZbGKLg8FSRODRTRU7iYkiSUZIzqlC2eX8NSPWCO/tuKgoy5jWl0f5jJ07OrfCC3CFbruYSoFWLxgVTNdH7CdUm/CSgQxSAGJKDx++VQMqIFTIJ8BWu0Tj5j3zODj7kGxfwrre2XDFnz18gTWKi8F0Wgu4zXbncn++yjXEe/U9SVbzOy/xfdStt7YOHrLISK3jIEZRWnbpzjn60s8YwUf8ZsNgjtEF4E8q+2Wvi+JnqtwLViQ0aQph5f587QkuFAg5pgeUH7ddmzt/dbdpg6tbU7eIdZ4ERYeRTATW19Y9/GtJgb9wuUWEwCYb3sNQHxzyjKrBGj1CpChE150UFVY/dbWUM+vnr9UQgGfG9KtSctxIJCzFdn2aveOHFWffrXAoSIzXHQXWUirwxMNkTkIwYBP3wzCEu4MrM8GBcG0l8FPUY1+T3fC+HNPRQaTqYtb8uxJxu7eJOdIgAdO6NfKizfAF0o4ikSvicR5Kv8KmY4PXEjWTGFfG0hz9p3vSLauxfqBhMZTFeJr57uryuKo9UqL6xtXhxcfs57bXPMUnySlCowhBfiuCneKAReRgzQBpaFQM1KhWHAeLzmq97MKGevfeIpi1uziG1cgtyHD3pTW02Nf6RWDpg229j1GhSALTUoWBf73vWWhcsp7PZa9C8sO1YoOHoL8/BitZw2aLjahNvYX
 j+0BqPuo
 5ar5XYvGqsCa0TD3hw/rKBKQuPeLErB/e2ftKFPHzM3ZVLZBDLoE1OtQvGrSc6AqLWzhsMgXJAwsgaGbLZsyz2YQcEEEseTg5wM+RFHokwlws+T79au/6c22ie5si5BXut1P2jrCKOlYWy2klzoy/d8t05bO0QvpUVh31qUyL2cN6yOL/lLRAfO2/3X4Z0WauzBxQ5g3wCOubd5x00CbX62joC0olKJHWyAwr9x+8jZfmFG9MXRO27h6ILD0nwjAbDjFU8FpcgJY2NSp8SYQHlgJrBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new field, weight to damon_probe struct.  The field is used to
specify the degree of the API caller's interest to the data attribute
of the probe.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 63f596957c1f1..d8251c83e6e55 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -760,10 +760,12 @@ struct damon_filter {
 /**
  * struct damon_probe - Data region attribute probe.
  *
+ * @weight:	Relative priority of the attribute for this probe.
  * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	unsigned int weight;
 	struct list_head filters;
 	struct list_head list;
 };
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 11473aa1f70f4..327398fa4ee56 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -166,6 +166,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	p->weight = 0;
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -1658,6 +1659,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	damon_for_each_probe_safe(dst_probe, next, dst) {
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
+			dst_probe->weight = src_probe->weight;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1674,6 +1676,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		if (!new_probe)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
+		new_probe->weight = src_probe->weight;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

