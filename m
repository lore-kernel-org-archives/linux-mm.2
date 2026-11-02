Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E65D606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eSia+FWG
Received: by kanga.kvack.org (Postfix)
	id 371836B05B3; Mon,  2 Nov 2026 01:01:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3483B6B05B4; Mon,  2 Nov 2026 01:01:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285566B05B5; Mon,  2 Nov 2026 01:01:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4A46B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:01:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5E9B40C47
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:01:36 +0000 (UTC)
X-FDA: 85389132192.10.581ACFE
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id C86D21C0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:01:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eSia+FWG;
	spf=pass (imf20.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793599294;
	b=bXnatSGIuPRlX4hnIaIG0KDV7ejcW1LdOU3VPFh/opmYZw23eKBOO+7Km6FdttCjZrsY2a
	suJ40wKFY9wsj5f+gbfukh9SYyjUy1hQtkBM2Shc5jIUFMcglOo+WiTPc8xpnfzyCbJ6WE
	mAtW/1kzdZ5TaB7JWIBzdqXet00LASw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eSia+FWG;
	spf=pass (imf20.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793599294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSkr4xPSOMpmzvdQfZBF00qXeylEmPR38zvgW8C7IJ8=;
	b=UMwBmYG2PWOeg52Bcpqd7PIuVC8bIHlTCqRossjMMG1ladBlpj3HsG81Lu9QNsFFyMxtKe
	ss96cxvkmai/+IAR8oS4/8RzebPEtiLFFlgQQhNP3iNH1WbpJMDS54psPra3fSCC3K3L2m
	Tpq1rjNx7P+RsZEkwGXVrImg+ph0XrQ=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso4642595eec.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 22:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793599293; x=1794204093; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YSkr4xPSOMpmzvdQfZBF00qXeylEmPR38zvgW8C7IJ8=;
        b=eSia+FWG3YEq8akIV+EvjGOp1m2xgBN4CAnaUB9WPakOsJdRS/DJzIL+oXdXe+HZdc
         gu2Ph9ajcbbQFMkyVMlAtNzHMe6PFuW/lwFQm1QxI2w506Fu1jMjbxUq/c25wnnPoRGL
         yldmz9B4005MRwPWyv/2JUKiDh+UyxdBgAgoCYgJsGcAYgVYbDVVm/veeQPRIUxtChSd
         6EHi4bZjmorzc76PoeImjpmk3+WNzR93VbBucrfX7EZ2nOJdvHcYDUsTW74rudaz5dOj
         YKuOesqhwjXkJLcm41xS2+ked3/yOXK1FTh8arNlCphy3809Ci4MYvNY4weHUgo7Vtko
         85HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793599293; x=1794204093;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YSkr4xPSOMpmzvdQfZBF00qXeylEmPR38zvgW8C7IJ8=;
        b=zW3LvYE33sQen+D/eJqAsHh4xt83ZZff7NzH2JMwS/Byr5UMfAAZdkRLdglVs/Cx+G
         1MlCHCaMIFd5qlFG/uF81llnwO/DXOkQiZUgS4ejBUuT2S1fF6wvs0JH2kvwvZvU/auh
         0l/Faqna67sb1Khi+rip1ciVe0CY4XIA4l2JW8r2LFPqrIpYK60aYAOUQfEuF5X7DwdP
         zhvffqOawkNP4JAq4nRsAci/Gi/EhGxciPAnF5DkZFwn840wfMG5i8CuEhJa4tTnl5nV
         f91dFdEDkJG5+/L3O2KGECdU/68uqNaD7MumIBnBUKXIkBZgffBWM/BA2YovYL8UbYan
         ZDng==
X-Gm-Message-State: APuU4Z+C5UpNElUrQ0b7hMSsyDKXbuZTZdJLVlsqr4spTyCii4UpZmyn
	B7eG3wS6/5fwClCABgSS0neKQYDx91BwYwdG9BvZxYot0jOmXCKgB6h7
X-Gm-Gg: AYBFou3dhlvTk6rwHPOnUIbVKSm+8D89a6MyaKNYl0beSDxi522SRMkggRAvtH3AnVa
	tzJqlBn+WilThy7DyJ4J/sb5RMFho82hfu3heSzC/C/I5eIedt8beYe0cus8z3plyTgEPdETN3S
	TsRYA0QPtsuN9EuLtY5XWs39EiG2xcNWiIB9MoX51s8JdMYUUGgooSZow8P+0b/cxPIqpL5PMe0
	KW/7A7t2etPPY1N4eH6KpLlNoHvUmdTsDtCA0Vy5wFne6K0oR/I0x0tQvhRCm+6LUkPBUT7nE+a
	pJD0ojyLfUBi65wxb7tbhtK8d4d/O11OBz21WoNVLwr4PB75YYGMkLXfPYRqKvnFzfI2kpSGgB5
	maoaz/m108ggF5ypwRJRnFCg8YBss8tq8MqLeYD3NpjCq3B54tvfYAPcLLzNvPhHpehx7yRIq78
	XK9gQ0ma4V44IMtR7H8P5J25cb7DhLXqLNsUBRm5MKPj5shwKrdlElssJ2vjz+0ioau+LhPQHV8
	iXczh+/Q62GQf8arW0Mj2Fx2UY+C2ggZF5pbW3NFWt9bxFg8VoAAFQIoqUY9oSBNkAHTnbWPieD
	U9F5rkvUzmnkZ4cetV+jikhj
X-Received: by 2002:a05:693c:4154:10b0:369:f4d7:19fc with SMTP id 5a478bee46e88-36a424988abmr16343588eec.41.1793599292932;
        Sun, 01 Nov 2026 22:01:32 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm28755363eec.4.2026.11.01.22.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:01:32 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 02 Nov 2026 01:01:08 -0500
Subject: [PATCH v2 2/2] mm/compaction: defer failed async direct compaction
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-bug-mm-thp-async-compact-defer-v2-2-b407e974db54@gmail.com>
References: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
In-Reply-To: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: C86D21C0007
X-Stat-Signature: 59zaepb61rbpz9hk7o4pk48ngesstkrm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793599294-414260
X-HE-Meta: U2FsdGVkX19Rivi4GhBmQQQxP8IDM0f9skOX6sSCWxFQUvvbciOdVi8+tiVfdiWLuppwDybVasVKqtCyIxLXGV+9n7LF3MCKtxVXWh+MvpAMNCINV1lwXBfgR41OllIHVys2i/byiyvhIpRZJne19DmoTNgeHbq0NOZDVmpGNIHUSCvQ5b14JYrxPR24FuaK7Ieby3yI0gpCcgKYxZQMnALd3orOpS5gITjTw8hbArG/buM5go9qDy/D+DxfGM5j2CFBVubx1CxHEYegobb8P6pKp/q34G13suq3uv9P0d5gQUr0F0nJjDAcxhKBMmjt7xWCAvtX7uAQKtZGrrektl4097xm0dzeIWb8E8CX0gpnSeQHzFYonedSFrbf5gSCWeaS0uKQmb3xP51YfX47vlcnfZ7hH4SZPVaT5WsLthFbQBw5C62mGX6lpXvgRXS8JhrWb75cgFU+15GLKGGTCAoEfxRvcf45FYS0nSBrU3WLOmSGdKdh/jOKy6EU8qLx6s7x8KdqXesc+14roX8dzwO3aSCL8iS+xcUHUgu5Tm3VxyWEakDp/l35SBhnLkddSBPhEwfaPlxq5k9fCMxZw7uMICoNro8oLrh79ct/TRSf0ahGlTfR22ZCys2VTIIEjKi3+EGmHXMq16nA3cPPjv7z5zhZebAftRyMLJw+wyvfkjKOHFjcV8RjiQ3khN4U1EIvH84NjtXI80g2agGH9hivDupQa0QEJF97Kpvf6bDOuTbQ78qkd6JB3APMCFZYXm0zCKvRIXUx4zIZE/PRoQGEG8N/XRqVhRITgGhUJ1UTwxRymTUFC98OlQVWtRKCmJpbfykyQZXPBltt1xACVWbq6fbbYM/7H624xMEpYIHmwv/qgkFeQo4399VMgglJcbl5ElmQeXplY3WIdQyYyo7z98dyhhowYM6OsEahGr12u5ihjuixSYoM0xBIuryvDKg6jj0/6PY2KzHz2Gp
 eaknC593
 iJV48RjrBBK2ivD7Zo7rmkCkz6b/8l9J/f5mOKDpkrU1cfu2wW3ILLwWbUh9sKt1ixKF33Vl2AXfqseY/vmynE9fav41+pssIJFw1WfmTnWCHVo+2yD6LYjCJ1whj0Aj8KfsIdxR/BAcxWSmfz75yGZt5Be0XM9KdHCV+Tyz3NMJkTtmBkQAPBrLjGuqyESqIJ+nHM4f/gD2ZlufWZKcEP6/wxeYqGi8ERldOtRGUAZ86W66D3SnkonM8F40Dp7DBt65exiK5KNV5yZT2opWx1yP7kjsYD6Ch5L15R+5nYmhfdwPzUSsZBoRaBQS0y2HJDWaMmShTz88my7++iqoL6feqQ81WB6Yj2/f8OLlUTaR6MzRJ7AWm4YkYerL4MCmBhWDWOmiqQf8yDvgVFgIwAjKwDlz9dkGsApDKUM7V0Y2gJqdkqcHr6HgckZLi0j5LrU2KeuoC89omD/OfFZL5+x3eNzgkOGhEbQV+KVd1RjRF4ELPn/JysWYI5U3Nl0TDECDd3T1uWD4XLcNdr0k8CLuRbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A THP fault on a MADV_HUGEPAGE VMA first tries the local node only,
with __GFP_THISNODE | __GFP_NORETRY, and runs a single round of async
direct compaction there before falling back to other nodes. A failed
async run is never deferred.

When the local node has plenty of free memory but no free pageblock,
and what sits between the free pages can't be migrated, such as memory
long-term pinned for RDMA, each of these faults scans the zone again
and fails before falling back.

Defer the async state when an async run fails, and check it before
further async runs. Sync compaction keeps deferring on its own state,
and a successful compaction or allocation resets both. Reset the
pageblock skip hints only from sync compaction, as async relies on
them.

Populating a 4 GiB MADV_HUGEPAGE buffer from node 0 of a two-node VM,
with node 0 (24 GiB) fragmented by long-term pinning every other page,
median of 3 runs on each of two boots per kernel:

                          before              after
  direct compactions      649 / 1473          9 / 41
  time in compaction      118.6 / 264.2 ms    2.6 / 5.1 ms
  population time         531 / 504 ms        390 / 261 ms
  THPs on node 0          1399 / 575          1478 / 727

With movable memory in place of the pins, compaction still succeeds
and both kernels get all 2048 THPs on node 0.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/compaction.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index e7a450b2be757..390171370b046 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2600,9 +2600,12 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
-	 * is about to be retried after being deferred.
+	 * is about to be retried after being deferred. Leave this to sync
+	 * compaction: async compaction relies on the skip hints, and clearing
+	 * them on its retries would rescan the whole zone each time.
 	 */
-	if (compaction_restarting(cc->zone, cc->order))
+	if (cc->mode != MIGRATE_ASYNC &&
+	    compaction_restarting(cc->zone, cc->order))
 		__reset_isolation_suitable(cc->zone);
 
 	/*
@@ -2858,8 +2861,10 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 
-		if (prio > MIN_COMPACT_PRIORITY
-					&& compaction_deferred(zone, order, true)) {
+		if (prio > MIN_COMPACT_PRIORITY &&
+		    (compaction_deferred(zone, order, true) ||
+		     (prio == COMPACT_PRIO_ASYNC &&
+		      compaction_deferred(zone, order, false)))) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
 		}
@@ -2890,14 +2895,17 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			break;
 		}
 
-		if (prio != COMPACT_PRIO_ASYNC && (status == COMPACT_COMPLETE ||
-					status == COMPACT_PARTIAL_SKIPPED))
+		if (status == COMPACT_COMPLETE ||
+		    status == COMPACT_PARTIAL_SKIPPED)
 			/*
 			 * We think that allocation won't succeed in this zone
 			 * so we defer compaction there. If it ends up
-			 * succeeding after all, it will be reset.
+			 * succeeding after all, it will be reset. Let a failed
+			 * async run defer only further async runs, as sync
+			 * compaction may succeed on pageblocks it skipped.
 			 */
-			defer_compaction(zone, order, true);
+			defer_compaction(zone, order,
+					 prio != COMPACT_PRIO_ASYNC);
 
 		/*
 		 * We might have stopped compacting due to need_resched() in

-- 
2.43.0


