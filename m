Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E55606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/1x+Z8S
Received: by kanga.kvack.org (Postfix)
	id A2A2F6B05B3; Sun, 15 Nov 2026 23:26:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA5D6B05B4; Sun, 15 Nov 2026 23:26:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA396B05B6; Sun, 15 Nov 2026 23:26:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2766B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:26:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEE0F140857
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:26:07 +0000 (UTC)
X-FDA: 85439694774.21.CB1070F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1B2F8100003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:26:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/1x+Z8S";
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794803166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LkyRBu/5B33gc+px/Ls1cEcSKMTU4Ac1+7qctKCFxg=;
	b=wnKRORS9RvNDGaPFVE7He8QDjeFRyMMx197YEke4CRCsYZtrArQTXBoVx9dkMzjg0z6MhZ
	c0V97VtWJs0mA9mjCd+wCufnaDxk2Y9zRdC+WljI+DQ/in+4RkLWi/ulHzMYKRyPP+NiSb
	9x9uiJqXlg14NmNDNNyYKQByv0CIIiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794803166;
	b=RDh70BXpupwhBAGMWkONYCeMPXF8qsL5mtBcHLlpvL2GFMno11S4DgXJOqt8HCZoG9JVpy
	UA6TcJF7w7G0Swxu2bE+2pQkvpEyJG1QsDHHSC5XL1b/w7/L6CtJpF5eNLCw8miuaos/gn
	Xa5y9AJsjBA8FweXowMNDioddk148ME=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/1x+Z8S";
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A7C160D58;
	Mon, 16 Nov 2026 04:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E431F000C4;
	Mon, 16 Nov 2026 04:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794803165;
	bh=/LkyRBu/5B33gc+px/Ls1cEcSKMTU4Ac1+7qctKCFxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/1x+Z8SBTzvYebmgDsdMGRRD7fx6+3XftHMitJYDWsBlYqWfRxM6cF8I3PnAoj4c
	 nQEnQWNkCipsScimqgjX9baO6PjZqnM4GCGFYkizDvtrUThXVPXVOpayXLqDW4MEI8
	 /7fC142hGrzkcvcuw59vsOkSHj1mMhmrspDmvmD3xIv2LT7JgXq5B2G4TzK+N5nCFA
	 JTQbkgTArK9TRwD14Uc7sIbnBpUT0tv7/jTEBStmjPhoAjURAQV5IzvcHM61R2CGvo
	 KwAq9P8suIO1Yxk/Cfe5C7fSdSOV0U9vM3+N5C6S1OsRYL5CjJWCzh4x+Ow49LwDkI
	 PZ+1ccBQEu20w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: ryncsn@gmail.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	sidchintamaneni@gmail.com,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn
Subject: Re: [PATCH v9 10/16] mm/mglru: Run aging when pages are rare outside the youngest gen
Date: Mon, 16 Nov 2026 12:25:56 +0800
Message-Id: <20261116042556.42111-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com>
References: <CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7zue6kho1jizg7p7skdgzzb9g7ab7m5p
X-Rspamd-Queue-Id: 1B2F8100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794803165-68321
X-HE-Meta: U2FsdGVkX1/5TEWTrGAox/u/yszPd/sQ36mZW0Txl4p+GJrp0olLf/OIor4pt2zPY2s0n4iS6C557NtR0YaXDK05pVha9Yvll9eymkqXrO8VBYItsfJFMSaS7LdqB+eeDTUh/NpWVHt0juynUyfH6SrMBmb5jlM6oX+oj4nGsgdk3oay/vM9A8srjbvhBMmgcyxPBbQByZzHwgoeMqLqy4dq/dK1bwx8MqIz0RXue0/uvzC8qjRz/j/5gRSPIHJhbvUpt1vyXI0dIvRJU3r9DBYg5ROQKr8TjjPtqzxZ65sM40h/TObysoRJqqOOVDTj+eQl/PwzayFsBN3V7LhB5MyT/APJ/EpsPwUl1PjDZL5LiyerpiRNwcFjqoq52mR8MPTCiH4FfaPpVqI/t/hEdMILPIfRS836KGOvAnGRXsBcCc6Yc8Tdc3w0V2257A8OQnHwLw7qupOwA4E4Ieqpj8xe4oN95mGn2d/A2dBX+7rKrt5QZjlSUS3YQl6mICRuyWUPz7EiNXBI+3zo8OfVKXHwFx2ccudvoROiLFTYhNYU1AkWu000yWB5Xvwrnx3sRmfJ7MhyQ/2r6XVxf2Qv5BNnRV+XDv1AL5YB26VlkIkwt0eJYNQu5vRtTpR+h0t9QkK1Owkt821SU1h0ZN+nSvIL2qYF5v9fIOEcqdY2QefX52KzpvH3BowO0CY3ZZxVBrsmGkL00/H7TWvJb5Jj4huF+7AD+Pw1w4p9QAu3xTkABjNBZdM/xlrfPHAlJMpVgWAsDxEFn+GrH9UrU/lHguHUHWbJDqHNl5WPOnfT17BGlU05WmQ68PnFEaefO3X71onC/hy5ucJykf86DTA+nFLtnYwklYnU2IAP3rKIo04R0VjwxwKfCXGn7406SpJCoZpyYez4iu/kcvN/rzCr+qBJcQeJOjsYCIbrCJnngA9U8pbpDOwlYVfo0vsYdDmO2X+8c3bfygMN4CzNlb3
 tkopydix
 K/+Rhz1+27RrvXiHBZz9159mlHb4t1L7juhY2MaehJydwhKJQ7xMXryQPQo8hCXysEMTnB6gFg3hrA4Zfqfhf3neuVytm4zEYEAhUmOW4OEHPcPSKlYmNvTiBYHZ7AbeJ2AmbM+MXgdDDiOd51IB96kkH1GBEXVMsBQK3m32ljAewtvzetA5MZdYdjTFfFBZIhR2BNxxQTU59n4YqObw+3VN2UDV3ZZGD0yX78s+f5QpWmwMzNEdYyF6YFQUoAfgEJnbuaEEnn3RmhdeORf/wJL5DOkEmlMhsr40lJReOyMPUPypoZnlI2FG6+NFdXwR9Udrg00zO05C5fyASGJv/pz9Li09kJQgfKIJe5Q8727ePssC+a6izgYFqoaqqB5gX84Xj4Pi0vlLWZHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 11:55 PM Kairui Song <ryncsn@gmail.com> wrote:
[...]
>
> A little nit: with the rounding above, I think we don't need youngest
> / old as an array, just an accumulative value seems enough now? But
> feel free to ignore this so we can avoid more update noise in this
> series.

Makes sense to me!

I guess Andrew could help squash the cleanup below into the patch?

From 972664cf8d40449899b54ee3c7abe6d1a9f72271 Mon Sep 17 00:00:00 2001
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Mon, 16 Nov 2026 11:48:44 +0800
Subject: [PATCH] 
 cleanup-mm-mglru-Run-aging-when-pages-are-rare-outside-the-youngest-gen

As suggested by Kairui[1], we don't need youngest and old as
array. just an accumulative value should be enough.

No functional change.

[1] https://lore.kernel.org/linux-mm/CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com/

Suggested-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7acc9acad985..b97dc3103b25 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5086,8 +5086,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 		int swappiness)
 {
-	unsigned long youngest[ANON_AND_FILE] = {0}, old[ANON_AND_FILE] = {0};
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long youngest = 0, old = 0;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 	int type;
@@ -5107,14 +5107,13 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
+		youngest += lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
+			old += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
-	return youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
-	       (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS;
+	return youngest > old * MAX_NR_GENS;
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-- 
2.39.3 (Apple Git-146)

> > +       return youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
> > +              (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS;

>
> Reviewed-by: Kairui Song <kasong@tencent.com>

Thanks!

