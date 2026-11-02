Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3903C606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yW+qkEsl
Received: by kanga.kvack.org (Postfix)
	id 4B7046B05CD; Mon,  2 Nov 2026 17:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467E76B05CE; Mon,  2 Nov 2026 17:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EB86B05CF; Mon,  2 Nov 2026 17:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 084276B05CD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:56:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 912A5402B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:56:06 +0000 (UTC)
X-FDA: 85391688732.15.4CFA2E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C3C2A1C0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:56:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yW+qkEsl;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660165;
	b=We9G83TIi8r82a0nzIv9S/inIzFMn2ENzMLZwakHPV5dYDxKTpFyKNhShCMGn5tP7Kz4Nx
	qIypRJ5s/x3ko2KgHbQYOZ5qC9qO7J9ku5eKTRpDXoHQjVolK5LvRff03dTLt6oW8SEXih
	iO5lODZk6xk+nDLWl4sCfgMwdwj7cBE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yW+qkEsl;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tjywhpg4haa7M6XUPEdo07mUb7ffrhUZvgkBemX0i2U=;
	b=R77TFM194xYpdpVHMdLyzNJeNt9xggVE+hnO5VsC+69NCfaNl5F+pZAiaGxyMWbSYoFxQY
	b66nSbjJMxb6BEbm9mHtcdqM6MWKLXta1UxiX821LrTGNStXlQ/O3r3hkjxS3Z8uEGIbcZ
	HhPJ3jtgb5QewGIstgMYxfWPcTAXtS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98B32407D1;
	Mon,  2 Nov 2026 22:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E259B1F00A16;
	Mon,  2 Nov 2026 22:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793660163;
	bh=Tjywhpg4haa7M6XUPEdo07mUb7ffrhUZvgkBemX0i2U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yW+qkEslEALOo0D43uyXiR43/P08AtDgKt4P6xisCXzYiAWwHoC2m40quCecPKQ2M
	 SLJ+/sQFebV9fTCt3ibRoVZe4VcOa8KDZL71wttYVQ3k02xY+gGYz0bCoxw9ryvF/z
	 CNqy25uXiZjYlUdwcHh4kSKHgBfNayQHOKnZesWU=
Date: Mon, 2 Nov 2026 14:56:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <baohua@kernel.org>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>, hannes@cmpxchg.org,
 david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yuzhao@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apais@microsoft.com,
 rlmenge@gmail.com, Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH v2 1/2] mm: multi-gen LRU: use mem_cgroup_lruvec() in
 get_lruvec()
Message-Id: <20261102145602.44f2836b6aef7d8e2cd14562@linux-foundation.org>
In-Reply-To: <CAGsJ_4zVpHAGM=Sz8J+5PFv3H54CyVdpcp6cpVK+rQ5f82Q1EQ@mail.gmail.com>
References: <20261026202313.63122-1-sidchintamaneni@gmail.com>
	<20261026202313.63122-2-sidchintamaneni@gmail.com>
	<CAGsJ_4zVpHAGM=Sz8J+5PFv3H54CyVdpcp6cpVK+rQ5f82Q1EQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ywskdt8ifhbduoj7broxoit61e7sfean
X-Rspamd-Queue-Id: C3C2A1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793660164-913210
X-HE-Meta: U2FsdGVkX18PmUxByClOgsZo/elV6eB8Pmtt8NJbQIpJ3Rvx02dIGyn5cNLBwWvUAzqdI4Nt1pDiayCu8nrU5tGX7GTBjTVnhpNZiRgVMeq6IbfSDxBaxUaAS8mfVAVkccLfOQ3Xcvd+MYphPQqUyHsZIyOpLTOLCLQs9oU64XUulK/xVCNcm4MoYnm80z2rg64i2U4jfmAAD+Bwb32dFmPpkARspkjyZG1TORJuaY+xOx/afHsHRypicjvV6tDVwy/VyZ9k4rlmrjvUDdLoqa0i5Su58mBs3Pp8WsgAfLaKHrRZef5M7uosuAweGlU9ovCrDvhscwZCIXtSv2ZUTT5bFabK/F6jY29kSjO+W5+NioixYAQYwWmD5WZiLsgFbaXTkYSlgP4uRk1Xj34UyBHryhQzxD043aKICUorrsPHSFWgwB4/6ACsf2SbzRaRaA7tyij3lz/aTZe+xkKnu0+0AqsQbcJqVTiI+quXz3I/ICNRsSLK+Ae22AIbY1TA5V7g4Oho9pMUTS1Ss3mi7oXhGV0JUnv/5RecHCNO3vUFPy78L6MK3M7k6+1/O0rLw1ozy18IPXlDAHXnBCZyIfEyUu+pGfPh8hvQyFuqEP1gFpXLAsD7XUym5+P4qGnHAnlHsl3Nx+6jhcfIC70QL12eVdTQYd1xN2C8X8GLuCQnlQFnlAazrLJr6OlS7L7Dhrog56Q5Z2s8ZguSQ6vmPwJdceipNtEb/I4/4ALbjPvhBLwCwHqWIcmp5MgBALGsM5Dzobn2qNGaCARakw54c+OPm7OyOREcU6cU/TXEhbH6oJseJdnGx4r3IFOU2+75YOWOLVlvd8KllRIADqlqNqKdX7nGDQO/7j+QvzazycSF6cyIA1Pvdpub8sWLVsGpw02hIXvVj57hlMveR9BO28issztbMrC9Usxex9w98UdS7ik0zf/WvRIZ81QXV7teuX8/wZxU7rQsyzxEQ9M
 Qkb2FX2p
 hLYf+jliEepcn4tLWNh6gdZHGrrvRby8Yw1a+5vJLshTZz5BDXkRGK+c06weV00n37mt0MUmUoXkrfeeMWErfV1mSlXK/VYQpLHK1xEzURpM5ruGFhOQj4OHwAW1SbR8wUJdNQU+Al9Jft7aP3rE4Lm6tLtqJrfudPbIeh7EhQ7EMRv0yyPK93G9yNxEtMU3AASY0P08tHLj111PYnucDGs5buCrTXdyB6WmHk0EUMMxZ/IVI+GOEfNszV2UcyLVfmU/1hoxeSYvGG9wNIORtPwdZQ8MDE3JgM4NIIcLeIcr4o+Gu3Q8dKla7yM9fHFJfcVRHGhnHIXZRnQZfhJ+wvMnOf0RfQg1YbEQi8ECRzgFEOlQgIbhUU3L1NrpbGP3iUyfsvfglQF8GfNlRRb4pdmhyRI4JyiuLFG3RmCH6gG06JKoBNF1zn2EWQBxsu6isEQYkdXlVl6n5vKukP28uFODUK9skx5jQCnJqSlSZF/EuJl0MZsCixdmHBk1w1TaydTr10LXlbwiQ66hOUKGbjCTihEeWLT/Lt788s1+Z/FH/lOdAVhdb0BSi3YQQKCsQvNpJXc42oqNzusw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 06:51:19 +0800 Barry Song <baohua@kernel.org> wrote:

> On Tue, Oct 27, 2026 at 4:23 AM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> > Andrew Morton noted that get_lruvec() has the same pattern as
> > lru_gen_shrink_node(): when memcg is disabled on the command line
> > (cgroup_disable=memory), it returns &pgdat->__lruvec directly instead of
> > going through mem_cgroup_lruvec(), which initializes lruvec->pgdat.
> >
> > In practice all callers of get_lruvec() run after kswapd_init() has
> > already initialized pgdat->__lruvec.pgdat on every N_MEMORY node, so
> > this is not a runtime bug. Have get_lruvec() delegate to
> > mem_cgroup_lruvec() directly.
> 
> Somehow, I feel this changelog is a bit weird. The earlier
> description doesn't really justify the final sentence:
> "Have get_lruvec() delegate to mem_cgroup_lruvec() directly."
> 
> Can we change it to the below?
> 
> The patch was initially developed to address a possible NULL
> reference [1].
> 
> Andrew Morton reported that get_lruvec() has the same problem as
> lru_gen_shrink_node(): when memcg is disabled on the command line
> (cgroup_disable=memory), it returns &pgdat->__lruvec directly and so
> bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
> interface calls get_lruvec(), then dereferences the pgdat pointer in
> lru_gen_seq_show() and other paths, so these can hit the same NULL
> dereference.
> 
> In practice, we found that this cannot happen, as all callers of
> get_lruvec() run after kswapd_init() has initialized
> pgdat->__lruvec.pgdat on every N_MEMORY node. Therefore, this
> is not a runtime bug.
> 
> However, it would still be good to clean up get_lruvec() by
> removing the MGLRU-specific code and having it delegate
> directly to mem_cgroup_lruvec().
> 
> [1] https://lore.kernel.org/linux-mm/20261017050928.128582-2-sidchintamaneni@gmail.com/

Thanks, I locally made that change.


From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: mm: multi-gen LRU: use mem_cgroup_lruvec() in get_lruvec()
Date: Mon, 26 Oct 2026 20:23:12 +0000

Patch series "mm: multi-gen LRU: replace get_lruvec() with
mem_cgroup_lruvec()", v2.

This series cleans up MGLRU's get_lruvec() helper in mm/vmscan.c.

Patch 1 updates get_lruvec() to delegate to mem_cgroup_lruvec() rather
than returning &pgdat->__lruvec directly when memcg is disabled on the
kernel command line.

Patch 2 removes get_lruvec() completely and replaces all 15 call sites
with mem_cgroup_lruvec().


This patch (of 2):

The patch was initially developed to address a possible NULL reference
[1].

Andrew Morton reported that get_lruvec() has the same problem as
lru_gen_shrink_node(): when memcg is disabled on the command line
(cgroup_disable=memory), it returns &pgdat->__lruvec directly and so
bypasses the initialization of lruvec->pgdat.  The MGLRU debugfs interface
calls get_lruvec(), then dereferences the pgdat pointer in
lru_gen_seq_show() and other paths, so these can hit the same NULL
dereference.

In practice, we found that this cannot happen, as all callers of
get_lruvec() run after kswapd_init() has initialized pgdat->__lruvec.pgdat
on every N_MEMORY node.  Therefore, this is not a runtime bug.

However, it would still be good to clean up get_lruvec() by removing the
MGLRU-specific code and having it delegate directly to
mem_cgroup_lruvec().

Link: https://lore.kernel.org/20261026202313.63122-1-sidchintamaneni@gmail.com
Link: https://lore.kernel.org/20261026202313.63122-2-sidchintamaneni@gmail.com
Link: https://lore.kernel.org/linux-mm/20261017050928.128582-2-sidchintamaneni@gmail.com/ [1]
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <apais@microsoft.com>
Cc: <rlmenge@gmail.com>
---

 mm/vmscan.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-use-mem_cgroup_lruvec-in-get_lruvec
+++ a/mm/vmscan.c
@@ -2866,20 +2866,9 @@ static struct lruvec *get_lruvec(struct
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 
-#ifdef CONFIG_MEMCG
-	if (memcg) {
-		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
+	VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
 
-		/* see the comment in mem_cgroup_lruvec() */
-		if (!lruvec->pgdat)
-			lruvec->pgdat = pgdat;
-
-		return lruvec;
-	}
-#endif
-	VM_WARN_ON_ONCE(!mem_cgroup_disabled());
-
-	return &pgdat->__lruvec;
+	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
_


