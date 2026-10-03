Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A770CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 13:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70FCF6B00B3; Sat,  3 Oct 2026 09:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E71A6B00B4; Sat,  3 Oct 2026 09:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCE96B00B5; Sat,  3 Oct 2026 09:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2D46B00B3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:05:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1C954062F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 13:05:27 +0000 (UTC)
X-FDA: 85281336294.12.44A226A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C52A3A000C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 13:05:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJSITcYm;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032725;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnJdVVWq837rhBYU16aOeLIgPKf20zgYEbSDFDOxp1U=;
	b=N0kPsddqwWKVb5ud5taaU+CtWi/79lFWxDMkCDzkWocSPyWmGb8BDlqc/VLK9aQiXHgrjm
	Lkst5ZCp60vAcjQdd5OLnLP2h1isH3YADq1JNvqTplFGjtVTfn9h4GQbPGJpikR2Groy71
	E0YMOtRBlFUMW1ubXATKc5dNCMbx3Xo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032725;
	b=ixm6SIPz0sH69dvwMmKC5EUXEJz3Ew4QxaMpS+kmi1n89+zOoG4NnraCmH/zmDbYCOhbqy
	EcxtOvCbog+tKzex56ppNOmNRPezmaxfClQehkYuUYMrt+R++jtKRSaKfz39ZeDSsnFP+w
	6iX19ZHoMoAX3PoD2trKToOlOn85ujY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJSITcYm;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B449E44884;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87A6CC2BCF4;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=IJdbSdqfzsSly2joDn3fNhJSn8tjPPt0T36DegRwlxc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CJSITcYmlzgykRDtHoAMMc9rvneeMX7Im+KmUYQ+KUoIKQdI7buDMt3flwHzciOWs
	 62DN/OYaQA9N1gbFxM5wP/iIEgsK9yyfmU1cDE6g/k7QRBOXUOI/kpz6M+2sYpmrGw
	 7NVlnCURXwXh2nun9VuOVh23cQI5B9zhAZyCIiLM3RMYnjr+iHdt8PrPx2ccSvT7Il
	 mE3WbvcTbgpM8qreHKUxO5+TkqMN5XkJhJ6yOyp82qUVbnM9BtBnQ69ttfongn8SK1
	 ipBXiAO/QfSEeaFlFXrYfc5U1o2/5FjH0nKSczAk8yDy2R8/b2UwYX/43XO3eHu924
	 RZW6HAvC90Njg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF12CA5FEC;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:25 +0800
Subject: [PATCH RFC v3 14/17] mm/mglru: reparent folios from all
 generations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-14-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=1313;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=SSFKxw+1JpTaEsw62vhOq7gyElbyAMh0m4zwnBqF5GM=;
 b=q/9LD6c8gvmYPxhU9rc4D78+Qn6i7gyt4FS5TgMbJyWibJ6FDwhn5CpOgRWjUSFIXWaya3eLk
 IpKqXPrIu6BBt4SlTOlR8kUzCIcqRDOVwI9FL2gt71dDdlXy/BvzPBn
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C52A3A000C
X-Stat-Signature: rtt19y5gy7gawt9sfgscoh3mo8ywrjmm
X-Rspam-User: 
X-HE-Tag: 1791032725-580625
X-HE-Meta: U2FsdGVkX1/r0e6uSBtc53HV0k29wzROUHPKcUxWvURYbst70FDkMbRaVFrgukll7Oz9iclRyMO3+kIGpPkOD5ACfGDr96XEaDjqWPpE+HrdVJCgoh7uHdSneErX9LDUKq4RCFDSmvS/31bYIOwcZW6KMOcRZY5fxZnFIqSHVo6vFKEF6JgOVrY3OgvC0WA2aINqn2ZQeSD/maIQkBTImi77y0Lku03zFlnyZfZiYRUvr6oproPLFS0C6lvL85DSZSONXuPytkWsiWfM+2ix8IIxMRjrIWxRla9HmCU8Dsc1NKSSgZhYJiwU/wh0Q1eXVMYrp2i+agdBS4LrlXpSr/CoPpQ1JVoypk+hCWa/HROq+Ltrp7vjDjeTkUdLIHCHJcY6tJYAgkFSjsKIREbzHdW19fV5ns6Yd2xlXYjAJ9l3ErPPO20BvPn+uwbIJB8TGGj3OxD036XWcaOYRo/8yyDRYrsysQJ9dpaZYhJQiUVQLlgdr+ai2nfoLejJP5eCr2Zff/xyZGq3RrHhF+whj9mlhKVhpnNxim9SFWFIaz7xzbeiDxLxx6PQR29im+4w9gOnyy8GwS9IAuenuOUcNa32Ofz/SI8FFmXuRRAIGSwT4xaEeVyruOmjnf2ahBZ6xFwQTXaQtS1FwgNhPEj5u3dhz2Uer0LSW0jrS2rVqA18dX4WPPJTSeudXX9ZQHEltQHCOBHznv+wS7jzuDF3E+5OjzxNcXZMiH+0ghuq8Lwt270lAhQ0VAWL7yF4zinUn3YRJlEKbKL89nBtlQsUJ6zIaQwCQwbITAWp0kHbsD5mamrtIHIT5wjMOoi7ozIlHROoLWPEVIUcygXG8HsjUUzfagdLn7jYzIm8dUxRgoZ4ekHoyG05HUUMRvVkMuEFA1DaH8Cu1eirP7xWAbTXa1uquf9xkH0hlLrbLB9uHiTyVv6zWlwjSHytLm+zcNjrOkfLsNZbcM0Q8lFixvs
 8aMAeyk3
 fgcixhMdOHxSR+oEdd1IwWFsX2F7V2SXgCaME2Gy+7z3Rma1FsY58ryEpirjCqxPMmN53DPql8BfETk5LtWuXJ6EMShZdSBIiu51pT4+qBAlcoujeocg5oEWzkdMCdYwEm/bof1LppuZwLPQKP3lmXZm0tAPO86esdH70QBAUNkIXyehKVkF0qeQksR4rwNTzBEWod16A2ghg+qCIQI1EK30Wh4t/V4xhzDq9fQVCu0hKiVyn1yoGBkbIk0faZtdXGjacXRhJsfxlz0HaZr/IWb0ZCDMqN9oZO4DzxZSYL+A6oEz6F7oDgDDEIJ008hNxzsSWdUWjrBPMDYOtmyy1sudqrpJLInDUC5tYsgGJC3jCuqp1iTvU5+mZ4/MCfJjR+vXdBtOt/jStmsw/VbOpJ1zjvyRlP0pAz1vW1ACZ1xk57McdrYrYbQ9KsZjjLLCBt8mi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A lockless promotion racing with aging can reuse a generation index,
see folio_inc_lru_refs().  The retry repairs the folio flags, but
sort_folio() may have already moved the folio to the list of a
generation outside the [min_seq, max_seq] window.

__lru_gen_reparent_memcg() only splices the lists inside the child's
window, so such a folio would be left on a list of the dying memcg.
Splice the lists and move the counters of all MAX_NR_GENS generations
instead.  Those outside the window are empty in the common case.

Assisted-by: LLM
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9cc06a95d931..1bc8e5056265 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4947,7 +4947,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
-	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
+	/* Lockless promotion may leave folios outside the child's window */
+	for (i = 0; i < MAX_NR_GENS; i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
 		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 

-- 
2.55.0



