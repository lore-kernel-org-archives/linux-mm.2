Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A752C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093606B008C; Wed,  2 Sep 2026 01:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043F96B0092; Wed,  2 Sep 2026 01:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAAB6B0095; Wed,  2 Sep 2026 01:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C53FE6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:29:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D04491C25AE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:29:11 +0000 (UTC)
X-FDA: 85167693702.17.04EC5EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 46F601C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:29:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/dOHZYr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788326950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbloG71Ug3SvdXr7VKnegfG6pXruTE4fT8uwaWdzeco=;
	b=D0XW7hyiZiMHsgqH89+za+N1KHdu1/mQxSKeDN4bUMoE2iS9nVAfwTY9BXeIvJsyArc53P
	Mwtix3h6eXMkSqsBeejgezMmYTRuCymFeCQwrfcIZBDpmlNOWIOcQ0WiegZl65dg/YShl0
	y5jPmTxQi0fhPdtopc0egMaKkFdliak=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788326950;
	b=cAZpc5ampdjL9RNvoDtka7qrvUeHBtO+mYvA92N1ksCJhNlW25/qYggvW5wtUXOyKbBIgE
	Y8msJgzxMCCysUnZimHhryXInohmJeJUTIJUOmQ+skd6LUm0LzAbXDD/XsFdio30LRPF/z
	t/XYRC1l5yxXcNsVuD9KMMpIrS90K3M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/dOHZYr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F2AB600C8;
	Wed,  2 Sep 2026 05:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C871F000E9;
	Wed,  2 Sep 2026 05:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788326949;
	bh=PbloG71Ug3SvdXr7VKnegfG6pXruTE4fT8uwaWdzeco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/dOHZYrveo4S+nfA1TZXALfefOYlXQGFcxB7Qp4/Zk9IrcG7a6Aq0u9G8h2btvPu
	 I0QuHwo16oZk0XPRDbauasteyo/2gRPLqnYsLjxl0IYEcXANwBcVK2Mm1KpRSYytyU
	 wyRpn5RDeUZXHkZy/k+vFAn1OnZfVTwX1PnCo9Y7F+0ANC4+AurINfu+Ea0rdKL9m4
	 dJ8ADD6XpkKksoyDslfPV9H4yrphc0pF1COFe+8iQ4E95R6oKyoSp+nUthWR+92STj
	 Zb82PyOooHKUJh7RNb/fEG6Ue7NCvqqVuj0whKowcvBoP3AbGSfamDaQqpeOT6qOP4
	 NsapQ8/B74tsg==
From: SJ Park <sj@kernel.org>
To: Krishna Iyer <kiyer@crusoe.ai>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm/damon: support access monitoring of hugetlb-backed memory
Date: Tue,  1 Sep 2026 22:29:01 -0700
Message-ID: <20260902052902.93608-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902025700.17975-1-kiyer@crusoe.ai>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46F601C0002
X-Stat-Signature: 531atjwno38o39teqc3qi44onhyzxnxh
X-Rspam-User: 
X-HE-Tag: 1788326950-210950
X-HE-Meta: U2FsdGVkX1/ZwXHm5UJRUg+l11wIq+wQoQTuhH3pbAbFwjPZBm8c4SaaCQsieb+c4qhvGgZy5yMQnQzgXabLzZOtFESkJuoD7buBw4o+saNTsLaAfuaMwugRZ1QVjrpCrLPQi/YIrdkIvPdbQGIT/XJPOmggdQ3iGshifKOltk4jLDrsXegGojN9S8uxLlUNIFtLR+Ag5KCmKyFFABXQFAJi8VsQB5V8YdF5l6SkKx5uOdHkMdkDrCnuMtqipBjK0J3Upq57JWyXaqShMStoieWwWHGsYnzsOulRBCt8yTWmXP7FLy4OKO5Q9Ad3TYTOY6y0xamVk/UKpNXPEfQqKNiasxHY+MEoiqxfdaoNa+s9X+oZVqPq+mWs2RQNWScsYxnU2mvN3FbwIRZiseec8unMsU9d4AbGYu/4VmTm5YjzVeBARTufAmqRQ2UjgHWiG0Krqkgehi5PCoX6Fws72bEvL5urEgil59iqF17fRPaGgQ32uI8i/XvGzfN6+NiouJ4IAVC5fJpwUdgYXIokSc9fR+zkfTvBDFHtWK07arBHKTcDVbr28jQLfPXt7wWfXkwLi1WRdd+Gw9LWf0KjVZz8UQe/9IDyXo2aHay9ybTwoyFrrgvd2+LmgghnUL0iv0Fq7l0Hd9NUj9/aYv9dFb2Ghru/vaBir7jH/kWi6GZJ4UdRGkzjxAT/apKgZ+4b2tR1uLvnMXIZ52MzjXVKWtiX6qklBKm0vRo3PkzYCnM2e2R3CABdv6YurbCi0xOim2MGlnzk9g0DavqMEiZzxkl/AAxDTevCX+FDeDMUpYnxeIVLqjpO8NhYx8srucQ05c1QvSCwL9Crdp4Rpp9pokulHb6oG1gad+vZJ58x1+93vNWyLSjkEVkaSTBKp6PnDpnbqXNdWzP5bBiekPlmmnnGGEdltm2o963RLUxFiL871iGniDuDvlPjN8isy7YIQZn9+WixbVT+2kjtYlR
 Xbt9BBBD
 DreuTNEC5pPEDQ1j+0HnbdXPrpsfcnw5Zwgv8AMhI/+QcI1gyGufpueqTfxlaMpZRzhfeZcyyflTAMNscEXtQFtzSdc+J+ESt3QTY9vGEtm2jAkujBuNuIi+XywIxLjtFcuC3ixLuL/IMedv9LCx7+LeW9ccRidALMWKfsu+yji8LwQtXJnc4scKxjaloH9bQwbKlSKUByJa0v6qSjUD4w+7OhruRiEdcRE95GRr5/FXh2hRF9dVrjWTEA75OsfjSdAA3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 19:56:57 -0700 Krishna Iyer <kiyer@crusoe.ai> wrote:

> On virtualization hosts, most system memory is often backed by
> hugetlbfs.  On our production hosts, for example, ~95% of RAM is 1 GiB
> hugetlb pages backing guest memory.  DAMON's physical address space
> monitoring is blind to such memory: every access check starts at
> damon_get_folio(), which rejects folios that are not on the LRU lists,
> and hugetlb folios are managed outside of the LRU by design.  As a
> result, all hugetlb-backed memory is silently reported as never
> accessed.  In testing on a 1 TiB host, an hour of 4-thread random
> access over 842 GiB inside a guest was statistically indistinguishable
> from an idle host.
> 
> The first patch moves damon_hugetlb_mkold() from vaddr to ops-common
> as a preparation.  The second patch teaches the folio mkold/young rmap
> walkers to handle hugetlb folios, aging the huge PTE and notifying
> secondary MMUs across the whole huge page size; the secondary MMU
> notification is what surfaces guest-side (e.g., KVM/EPT) accessed
> bits.  The third patch adds damon_get_monitor_folio() and uses it from
> the paddr monitoring primitives only.  DAMOS action appliers such as
> DAMON_RECLAIM and DAMON_LRU_SORT keep the LRU-only lookup and are
> behaviorally unchanged.
> 
> This series is the first half of an earlier six-patch series [1],
> split out as SJ suggested [2].  The second half (the 'aging_flush'
> TLB-flush-assisted aging) is deferred: we will gather more
> quantitative data on the gap it addresses, including the workload-side
> impact of the flushes and the working set measurement details SJ asked
> about, and post it separately once the data is in hand, aligned with
> the ongoing monitoring preparation actions work.
> 
> Per Documentation/process/generated-content.rst, this series was
> developed with the assistance of an AI coding assistant (Anthropic
> Claude, via Claude Code).  The assistant helped draft the code and
> changelogs, and applied the v1 review feedback.  All changes were
> reviewed by the human submitter, who takes full responsibility for the
> contribution.
> 
> The series as posted here was regression-tested on its base commit
> with a full x86_64 kernel build (no W=1 warnings in mm/damon), the
> DAMON kunit suite (41/41 passing) and the DAMON selftests (15/15
> passing) on a kernel booted with virtme-ng.

Looks good to me, thank you for this series Krishna!

With the comment modification I commented to the patch 3, I applied this series
to damon/next [1] tree.  Unless you raise other opinions or Andrew picks this
into mm.git with the comment modification, I will repost the version in my tree
as the next version of this series with the comment modification soon (up to ~1
week later).  If you have a different opinion for the comment modification, it
seems I forgot doing that or you cannot wait for my action, please feel free to
let me know or post the next version on your own.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

