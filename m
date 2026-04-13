Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D757E9380B
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 02:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381666B0089; Sun, 12 Apr 2026 22:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332596B008A; Sun, 12 Apr 2026 22:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247896B0092; Sun, 12 Apr 2026 22:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 148236B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:13:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7673160C2D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:13:00 +0000 (UTC)
X-FDA: 84651909720.15.99A5F1B
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf23.hostedemail.com (Postfix) with ESMTP id A5ED3140002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:12:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rZeqxnsY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776046378; a=rsa-sha256;
	cv=none;
	b=nf4N1wiyq/DGtZrUZlM6f80/YelwDkwWA+BU/sW1nbKGpVYYvZabCvnuHY+yvcl72ieg8L
	qLXRGx728AvJ/SpqwrYd9DW2oCdtqR9pF2cakyl4s0fQ26GwiFMejgw0J28/oZVKmIpHlJ
	OGVPQMpPb7R4EIRk3MwfxhskZO0Vf78=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rZeqxnsY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776046378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mOVr44wQzndVa4TlbZYdCC8zORfyUnCSx5nJZGBsXvg=;
	b=M/j4Nb2hS41EsfDeZg1BI8f5R0sxZT4CC1iM/DoFlJqPd0UWCwZwSUzNkbt/DTmd5nxP5N
	1NvT4k2EduJNXvuGVvfngyfSUrGjLc08dlgj1iymZPigXexyPw+20loqiSOUmt+wdsvykB
	/hNgj0nR89/6gR6M8lfF6fol6thVb34=
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so3603677a91.2
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776046377; x=1776651177; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mOVr44wQzndVa4TlbZYdCC8zORfyUnCSx5nJZGBsXvg=;
        b=rZeqxnsYeS3hg8Nmx9ueEk16OqndTD87Hh32zvtrE4thTGTqDEFApRo+m4wpqSXtCk
         rotS9eNuauUy+stxArFZzXpmRB5RaolfAEI7FIDqeo0u9thgZRL/iaSy4lfHLKq7r990
         ihGpsesy5Yci0oALLT5nNd3995tUL/NELFEci9JJgBeQkGAFiRkqAQv8yJrIiYqAx2yw
         bj7r83XSvyOAM2ZHqwTLilu5TwFQu6nToOkpMOfs4KdM+HsM1RAGBEbrnO/knn41iAwd
         ZqdLFSk0cXhnKIHdDdWqBsWDem7qBQNyZhTNQAnV26PSsYZzrSLSDA6/XowNHgvCMgu5
         9mZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776046377; x=1776651177;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOVr44wQzndVa4TlbZYdCC8zORfyUnCSx5nJZGBsXvg=;
        b=FULSnn3mrQznNzPz10U7sgk/WiLxzMSwmy+sn+d+ie1jJG6hGDKfPqZGyk4rrCnQIC
         RVgRh8YtVSUexIeIWBi8fSlLLNp5xa0r5VwWkypi4J+miP53X8nt1bdNgRYMcxUZt+bN
         u4VkuJtQDNUXlQN1nX6BTvwnJPXAPinygs3cScX5EB/KyaUFNKOb+ixzFYW/ywIEpga3
         b9fKS5JoIBZVfS/YW8xaHx5JN3tdSoYGiE7j20fs1bwc8lfjQJOeSooASW6FYp9EiE1h
         44hXf0Hq5oZDSe7D5KZBUGFS7oJxFYXT4ChxhmxoNdarfvp+hJswV1qrcL7ah/+MjASH
         FmsQ==
X-Gm-Message-State: AOJu0YxAuZ9+xLl5FH3k8NtuctkC02sjK8Nv5zPOYiIDnGkP/1YR3pUN
	UCxeN1x0oOnSkMlEM/h7H7Gt/z5oElaEO8uceqjxDYDU/Kpe20n9s0Qs
X-Gm-Gg: AeBDies09Y8/QqzCjs5g9+j9PqPHNvAHL8f0BQNrvNvhkwBMP3TJwxo5WdgIsDdkNt2
	o0/X1LntFbjNGm0nFLvEdzInYJXUS3pyuJtesAAie6MrraUfE1jxF0qlRoHMmtyOCnL3Kd3vBoA
	L0VwmPbchCbfjSwtpqV54JdQBuZVllzRRl3Qox5WF0WVAvgXcPAv/pBofm62e6/eUnso8FT2Y9a
	ysEvIi3df/dczuJovfFyTlEkEIkGedkdeXALnDtpvQxvwC2zThG4dghGVriLLStYK9AGYPVLiAw
	dXxDBpPM8j5pzAASiFwd/LBC8Qr9/u4nngGMgrBrsDtcKhwJzDbztRL6Xtf5ujgTwc1bybQPKGE
	CEIE4twVjgBNFIJFo1X2QInaVmyZmt/tQlpF+4VhcEksyJmOO4hEyBY5+wbLp9iXCIvrdZkEPk4
	wHALQc8DkQh5XfAraXhaotmavNXE1LfXifl1kCkCniQSUNWxVMtgI=
X-Received: by 2002:a17:90b:1d8a:b0:35e:3e86:e2d3 with SMTP id 98e67ed59e1d1-35e42777a47mr12188588a91.10.1776046377293;
        Sun, 12 Apr 2026 19:12:57 -0700 (PDT)
Received: from SH-PF5NDYD6.Hygon.cn ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fb88b8730sm452023a91.4.2026.04.12.19.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 19:12:56 -0700 (PDT)
From: Ke Zhao <ke.zhao.kernel@gmail.com>
Date: Mon, 13 Apr 2026 10:12:40 +0800
Subject: [PATCH v2] mm, KMSAN: Add missing shadow memory initialization in
 special allocation paths
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-fix-kmsan-v2-1-9cc8a53c36c7@gmail.com>
X-B4-Tracking: v=1; b=H4sIABdR3GkC/03MTQ7CIBCG4as0sxYD07/gynuYLihO24kCBkyja
 bi72Lhw+c58eTZIFJkSnKoNIq2cOPgSeKjALsbPJPhaGlBiJ2tsxcQvcXPJeEGo1dS3aHSjoew
 fkcpzty5D6YXTM8T3Tq/qe/0ptfxTViWUIG27Hk0zahrPszN8P9rgYMg5fwAVOuE8ogAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ke Zhao <ke.zhao.kernel@gmail.com>, 
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776046373; l=2266;
 i=ke.zhao.kernel@gmail.com; s=20260325; h=from:subject:message-id;
 bh=2E1kNHkocp6W6ZcbC2Z72lH7get3s1sxDhZSsK9tVHM=;
 b=2RYYLUeCe3WeGtfHt22cHlkJDNrqDJwFo5GvbAYJiQFnWSwll16I32oyjLxtk9wv/X5ct7Pjh
 VZ6mpbi5mzXBE7aa19CzhFSB9dzk3MiQ09HJ/AHUd8i2S6LwylmvYpm
X-Developer-Key: i=ke.zhao.kernel@gmail.com; a=ed25519;
 pk=t0w8oqPLx0EV3Oq8QAh4yW+oVJxOabTNVP1OEbkzWIA=
X-Stat-Signature: 31kja4ae769tegzdy57jkag1bpfcg8dt
X-Rspamd-Queue-Id: A5ED3140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776046378-667322
X-HE-Meta: U2FsdGVkX1/0G+53rrDPJywsjax+InUUZAwDxTeCD133i4MT9lBMUJeKz6dD8UqW/HLBz46ec+3U3+KRd4X39VyAsUwG/X5R24fSEzFQ5bT89GHQJqZcy6Pc5R7BMt6K/cxfqr7o47fZLcbIqiSrc45aA4N5WQ8ctxBLEuXLDTHpaeqYVG1uGWdeD2iAtFtl6wjpah1UuiGbPIzGmM93DY2/a9tquh969Tc6PR6WFvEWd9NudflZHY0hdd69hnC0i3ngUWLMQfNGD+SZ0oZI+sZCxUYpck7Gl8wUNXUQqv//cIW+mj0lmonzLTWvR+iYwz93UElt0vRkV2sa+r4zf2SEcObSrFW5oy0yVQnxXWQql+m/H7WW/0R0QJ+YPoA76ovJJqTCbLprTMe1JER9cjXWtmvbzgbeaGZFW+xdDf32ukGix5ar+ZwmBpzT1f/yIcTzHYoBAdP3C/rdMUke0BmIlEfteitm+PLkzf4XUCOjFc5fXmtXi1zXXYIJ1njywktMP0UD8hFQyGRS5ebuRs/50vS7pVHyC3Wz1bExzjWtLzfpDCC7+9mK48d2I8NpQc9TXxPv05UAvWexLeF94ePCZzA5X7qaZvnURyzC3d0lVzyFOd8Un9TqGPBldOerGNSU4d5yY3Xwhi6A0lEp55FLhGNGgU+ybQ0JfF4T21LoZvECgr9z0Z+0mvFiSpduIMgZos02njkysZ4Acb8F7mfj03l6wMk/VWXjn54XaciIt/QO8OGQX/tW2mm2veK1NJ/2iisidGMywIGrGrkQQBC0ZpAtp2oiH1Wk3Kdwt4tI3QmKQCTakrIGkJSlhSusgxFu47mk2bh1y1WsXKh/YARuHmGIv4dAzeZ5ki16s9PP/E1Yb1UEWOEwCDJOW5QO6yn9tLdHtTT9Vmx1T8FKEjEcaClgEiV/2a6BW18p1a+yhArkApAWTn1N9itGhziybKxOxlcqkVVXy5DZaWr
 Ggxfna6W
 K7fCsuYAulz2auSJFYAszRULAHByY2d45xkAYRcqQzLj0okzuQdzVLLBgdJmp4leFas2qoLIYs4yIjwsdEuiC0medriJPtFhazTv5WId0wW1K3SxCT0J8mk+L1C1b2qg7yK2U1zyC5cROrsLF1nK3E0XPpGEmmZHPbM5P1WL/yzsjqGlVu1trzVEn66b1idek5hyvHhJKuaF/NCoThzszPBlzrhxlK1M5GGxJDMHZVwaVq9ZvKRczNhgemJXHrNBKeZ0sofDCBLwwzS6ULu6EU7B5y50HTuQWDbtppKdCjwhPqH4AmbwoiGmQoHcsbZ60sk/WszCMjELhd1C+zlr7JUtNda7SLU1AJI04xS7V8jgFMlNrOUcuQfLb7RopkjsJMn7pWY+SeNMznHsum6WrU9bHFuN0YEdyJx+VrLaOUqf3aFyKWMcK0d7AKUxTyNv4GsLfsCvHjH1CnrvFCxZdZJfvF1hYrnExzPucUeIqpwZ5dtPysY+RpZe51cDp/RgaHU0pZhPqsldfQ0kZKtCkfC3vV+22eakxxf6mrkFZXs+1oWCVDW7cu/tAXpTw5PrGFdVCzgyOMKtikd5W8Eo+jJBtMf+2arNbLuJdqsmZDG+TYaPH0xndbakmj9URpVT0xOXCXn9bDhr/JsUWe4FhRUeLk1c610dIY1r+O2CHf33KL5q2dWy8ei1gtWVFYO3Ys+U43oFbeLCAiSfTQ5VOAh4HDtKpK12yEyFR0hcEaXTEVJTZmjplsLyFRksMeYACJ6LM6G/NHjiXfw7l8R7+OSpTCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some page allocation paths that call post_alloc_hook() but skip
kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
Although there is no reproducer for this issue, this patch should
be able to fix it by explicitly calling kmsan_alloc_page()
after they successfully get new pages.

Reported-by: syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34

Signed-off-by: Ke Zhao <ke.zhao.kernel@gmail.com>
---
Changes in v2:
- Use correct variable in alloc_contig_frozen_range_noprof() 
- Remove trace_mm_page_alloc() in alloc_contig_frozen_range_noprof()
  since we does not trace it in the above branch, suggested by Vlastimil Babka
- Link to v1: https://lore.kernel.org/r/20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com
---
 mm/page_alloc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..e08678b9e9cd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 		prep_new_page(page, 0, gfp, 0);
 		set_page_refcounted(page);
+
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp);
+
 		page_array[nr_populated++] = page;
 	}
 
@@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
+			/*
+			 * Initialize KMSAN state right after post_alloc_hook().
+			 * This prepares the pages for subsequent outer callers
+			 * that might free sub-pages after the split.
+			 */
+			kmsan_alloc_page(page, order, gfp_mask);
 			if (!order)
 				continue;
 
@@ -7117,6 +7127,8 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
+
+		kmsan_alloc_page(head, order, gfp_mask);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",

---
base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
change-id: 20260325-fix-kmsan-e291f752a949

Best regards,
-- 
Ke Zhao <ke.zhao.kernel@gmail.com>


