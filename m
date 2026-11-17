Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054BD606A88E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=kLRKax7Q
Received: by kanga.kvack.org (Postfix)
	id 29A816B00EF; Tue, 17 Nov 2026 08:57:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272036B05B1; Tue, 17 Nov 2026 08:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188286B05B6; Tue, 17 Nov 2026 08:57:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC9D86B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:57:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F7C38048A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:57:32 +0000 (UTC)
X-FDA: 85444763544.30.01A33C0
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5589812000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:57:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=kLRKax7Q;
	spf=pass (imf29.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794923850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fEuhClmaJB9i6FXWuXFxHEVU2l5a2ORvSS+UOcUmAQg=;
	b=ITD28EQ1lSpkpOVaZ9gFlfjhGFx5QF2GmzRLkTvGnK8LVQEa1GuNKtcm8VbUp4qsAD0cSt
	tTcojAtX3/TI/ra6dDC6ryKudQa+t+P2xPIYrBBi+vHVeHv0/YYEcXj1WzW1dkPVGPLbJM
	IJhzG9r7IiQoVR8Pg0YL0gtakQXFvl0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794923850;
	b=Zixk6ICZncBPIYgLs2A5ss0CfTWaCr0KstAIuEIejTmIJt5WtrGyWnkvWlQE/T5e2Ba5fS
	vxUVzGKIUNgGhHNpzHwLL8R2DsYr/69vjgi4R/28ntlo2mY8vVJgQYPslSOpgBtCKuQFjv
	94sI9217/FTzZFl7GrTPbZ7ujbjSTPw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=kLRKax7Q;
	spf=pass (imf29.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
Received: from [127.0.1.1] (cpc89244-aztw30-2-0-cust6594.18-1.cable.virginm.net [86.31.185.195])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1C34A15B2;
	Tue, 17 Nov 2026 14:54:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1794923700;
	bh=SGdF8nfS37ls6JI/8WVlvHSMe1DjBMEx5/IrVzLhb5w=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=kLRKax7Qdo2KFM3LRtNj1wG6mRam6bxjFgr5dCY7LNwEAE1gDePOPuSKuLCdROShE
	 mDwtbAi6e5MZMtd83tcyjjfIV9fF1MrkMF8gYJzpcRzRD2SnOGUK+FEnsvfWt8wrCF
	 xBePtEZipHyK/7oo6aczGgDw1CKchbKhlg6G3Aoo=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()
From: Alen Karnil <alen.karnil@ideasonboard.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Ackerley Tng <ackerleytng@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Binbin Wu <binbin.wu@linux.intel.com>, 
 Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Christoph Lameter <cl@gentwo.org>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Rik van Riel <riel@surriel.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Date: Tue, 17 Nov 2026 13:57:16 +0000
Message-Id: <179492383658.1554713.9260140415931487684.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=713;
 i=alen.karnil@ideasonboard.com; h=from:subject:message-id;
 bh=SGdF8nfS37ls6JI/8WVlvHSMe1DjBMEx5/IrVzLhb5w=;
 b=owGbwMvMwCUWeK6p+sMV/3mMp9WSGLL+xDr0pdpNea1+QsDbv6z1/MembZb8+62j3efM//qG6
 59XmMr1jlIWBjEuBlkxRZYvh2SmL7VZEXZBM4QTZg4rE8gQBi5OAZhIMzfDbxbtTzlN+op2wge3
 BJtvdVutoaIlusZ26wbjRV/WT/rNHsfwP59xlbfJTeOzJaf7RQxdTF7Pmz3P4c+RKskibv3ZKyR
 aGQA=
X-Developer-Key: i=alen.karnil@ideasonboard.com; a=openpgp;
 fpr=F4C21C97A53CA856D029540951CE827BF0D44F9E
X-Stat-Signature: tq9pf9c718nm8mmzfujbizjjest543eq
X-Rspam-User: 
X-Rspamd-Queue-Id: 5589812000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794923850-30826
X-HE-Meta: U2FsdGVkX1+X1tZAEWhRvbo0CpRK3kMcCMgpmCiunylCa0n8Jb4QBZF/JHNbI8slJB5L9G2t+efZH6FNA0C+oq6xymYzHJ9/oTFYxL25kc70Tq5jI0vd8St/TmgJndJhOkwT1GgoHg+QSNfXMaFyrJsT+eBDxPy0xq0T+jd7DpuhrsrGf0V3rnYF9Svg8Hv2j/cJMk9A30BCL10YfR9xC7FiQTFaQjyRLqSJGmVyvW1N6GLEol4b4KtDLCPA07UHLdhlUmMmzNSPchPZiK+sl2wl9NCjiH7KOLbzMfkPeH+4JJ2UYug0Y0cql2Sq0Y9X9wxF7fglbWxLrOfKRbCmpOizLKBNEbTfq3DwBqJsGZ9pOi5lReZxfIRX8IIAbepVjRGGurE5PfF0gMINX57dpy8tppCXzVdukTjiXR7Bg+ZQBTbYlV/Fgwg3MvoVCoNMKgTdBd67hsZKaBb202l6Ec+82C67WYKgkQxUVutMgeVhd/txDRP+oBiT9MERzNJdKh4E9CwrlhpVGDiXofmOA4tkiioNHOWngNr6ylU3ycCAyNkHePA7xGgphHu0GaqSyV2drvZFGNGgQ/hIAUQb1PblFVNa+fL6Ij4yZm/awKpsosXF9sz3SWkDqq9XQeLh1wldwrpOWC9Z0rWXy8ROM3HqQ+cR2SkdED3fSgGlY8DivS/GArFDcQ3yWPsDUFzrzG8kosvKpeOv1GpjLCII/R33fP4/ecvnB7WutcyvWddv/2tRbicHrav1dkmf5ZQw5oqcoxpb0M/xRMjyW8LsNF/tQweNucqslABp193HrO+Oh4jnT5uHojIaEWcSCtCwG1kfcWJU4gytLbhp3IReduSJnVyccVrzVt8r925LIZMkPSy2lofOSjVq6oo/p+72Yhx2RcoExu/KaEEJjq95gfaQK2j1yCqdckJhOXxaipHuHF/w42M6EbIluGOpzLF2ByR/mtxeOjn1rMNL66U
 I0OKxCUs
 ydB1Xaghfo8qRLppSWAMB4FOevFALib6V0TR0jq4Ecl0vHSQTiIpQHhP3PDlK1CR+u8X8FeiTq/WCbTEtjgnnKDrfjstUmTBmJdnwxqpPBXsZChWyI5u4HTwlQsD7IPoXCTHjQp7PbeF5vFUTsUZ3EZ67HKG3Xf23KorqsQo+VQqZ4PhutOKB5i9VZ5oI+Lpkv2TpyRiUyPibZpYUQ/UENYGRFPnO0Xyd+nz9Ey23pUW1Klw6eXKn4cD/wOU8xo0UE9XeXoxcE9EM54loa/+VqWm7ihIyfX0IgvwNoCOeu3NACxBrXxMFa0DzKBIeov6pG9o/2ISJ4vjWWVHdxQz3Y7CIo8AeHLJqTh2Iuv97VQyh7J7nCMq7iXzTw4/SvRNeOkwbPEIkmPDK7AHvv0qpE+bmpLASO0IQ3LAZVS+7+EgvqfpiRglRQaifFu1Wq1ekr5RtogBcChL+s0D+DkMQaCLql1qvEOQq4FdYDBr6ewuphlBH8vGsNmi/sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 09 Sep 2026 02:39:08 -0700, Hugh Dickins <hughd@google.com> wrote:
> mm/fbatch: drain lru_add_drain() and _all()
> 
> [PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()
> 
> This series was prompted by lru_add_drain_all() appearing in watchdog
> backtraces: not to blame, but blocked on an unresponsive CPU to run
> its workqueue. lru_add_drain_all() is a heavyweight operation, which
> we often hope to avoid by a much lighter lru_add_drain(); but even
> those local drains can aggravate the lruvec lock contention which
> per-cpu fbatches are intended to ease.
> 
> [...]

Tested-by: Alen Karnil <alen.karnil@ideasonboard.com>

-- 
Alen Karnil <alen.karnil@ideasonboard.com>

