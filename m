Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78602C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD1B6B008C; Tue, 15 Sep 2026 22:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D7D6B0095; Tue, 15 Sep 2026 22:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CC56B009E; Tue, 15 Sep 2026 22:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C07F6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:34:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 737BA1204F2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:34:26 +0000 (UTC)
X-FDA: 85218056532.28.0C5DA50
Received: from mta0.migadu.com (out-169.mta0.migadu.com [91.218.175.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 84B64180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:34:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X0uDq3ty;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.169 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789526064;
	b=IL/ObrxdXLBLGWNaE65/k16E8G94ygh/+mbjeO8nvS4KRzhMMZZ5B4CpPAbsqfoz4UY1i9
	bosoWLiidPkag4a2ZA+MhGhLavStEXV0brClTxvgXJUNsozVycTGjF196IAWk/GCU96ZjA
	V7iQiZ0+SduwOd27tRBeW8kVuAX09d4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X0uDq3ty;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.169 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789526064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0bRwCmTolpefuw0nse2H7XhXQFIihMypMEdXle4hr8=;
	b=s3tecKZQO+vj1NV9mQEx6mNbgDQLKRa2dD7L4uM9Byf9Uz0doQlQPltAw/bq6Z87H24svS
	v1fKPvLfuTtz7eJPdkBEMrKQJpSlQ8h1QCy+gkzSR8dhbR4r8SLpQAGSiWW0D3eEo5RcFx
	SpqLaRymNFlG1nwVUy0wTyCODHZr52I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Hs8628BmLtIotljSK0JYWBNuNJKKbRI+x10DyPysmnY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526063; v=1; x=1790130863;
 b=X0uDq3tyjfjcc6QfQvDcr/90SRBbfV6B7yyrcc4ytPZ9mAf3gftiAh16p+3YlCMQQ0jBsyBM
 HpMGKYzggI2IjROZPTD/PPoxQpmyYWjSQ62AH6r4QXRYfdk5Rqvz7QyyA73ANw1KFSaHLrImX4v
 QqIYnwuUCChWksYraqJeyRqo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 4843396426b2392f;
	Wed, 16 Sep 2026 02:34:22 +0000
X-Mizu-Trace-ID: 4843396426b2392f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 07/11] mm: memcontrol: constify the reclaim protection
 helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-7-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:34:02 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <6770F941-463A-486A-990B-BF4533823434@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-7-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84B64180004
X-Rspam-User: 
X-Stat-Signature: xnjf57szq1w9czfqzif7jmj88p911ezx
X-HE-Tag: 1789526064-542668
X-HE-Meta: U2FsdGVkX19tuDMMFAbXNDU4s3N6/TJb1QZVMQjhHbgzB9PWRwcK+uYLYhwKPZjseKV32PWvDCUHuofkYaKSg/98cd9J0jNa+PslnsqwLJcplVRCx+R9yQjAIrIUMPGZE6/1Ff+qzXF7TcXo4TCzyRJVXawuE2TeFSlrn6B46hnJ+w9EXs464gvPQz8AnohGlDhWweNrNrL5Mlr8LAUpT38WwMvOvaed9l986XOZSTCda29AOzmeC7swSkSpu9jmLAgA4QPQ1sUI9f0MkpOR1XlDqhPjw6FWih9g0FpH4KxZpPlhxhIc4is2sbDe7SX1rjfu0Y35Dgc5hpeIU4ylxYlXObkYsXz64/2cxIh0DuIdz8WybgsJy5/s2ohp1vXp6Oy1+A5fWEDTDfBccJ74dMsv/+NQrI2AQdP4WXb6tFroW1zC4+rwh7JWrX+3Kfop6SuH6nWNHscxpGm7YRrCTOILuf0X7bWQOnvP0wSqTCr9H0YDfbGrq4m8R+mzu7iZscJXagOLRQH6sITZX7AnLRUpVX1Wz2sJOCUJWmfx8yNrC0GmchHius88tDAaqBaHwBZqWUHb7EmZg6O00sX/D3fZqtI4db6WAY8RAsZPhEl09+DsOBtLl6gPN2Mwphgs20asY0osznRpKJTsLp56lECf2XghkDC4Nhvf3HrdcZyGuZ063r/6p30ypYMDEeAwuEaJltglkCdWr5I3YhAsUGW/vggbUF/OPB5noDnh0mi3BvOxX0E3zqIcXF73vBcUZG7jTYhh9gjkWvBu7dJquDJ9L/ghmIvbx3sh8ljftdQHRTUKLPtEU9GP1E3hKnNqzYnlAjfxeE7JTELxzWNM9XpjH/bV+DhAKamnWesFItq6rZp7TdT/LJxMbyLUMtVTuABFe9JUMIN8NRR3Yd+5Wp3rVkc0PEvWAAZyxxOQKvz+FjM3sgxjQYAY6Jstz9wJQHpY0sY8qJqhjtXraJy
 jHyEWjdG
 EVoH7rtJ9QmFnJhbZOvMtoW9TOwfwCJ2jrVuJkbjvhvVl/xeFVcFe/YTQwPf42I/GZ1oIoBkpr2Wt0w/Z01qRQX7IxqQehYnjLRjsrA1hNfIsU6t+jMyv7QMrSnKwoD/+yp3vQpyvklhOubAwf4+PMzb+QZqsV485M7/tuC25hGGgoBJlUXAXAkOn2BwYb5U1Naz1Easmh3CODfeJWhGH0QxjDJR2NXRSlwXaR6nzJONvFOL0rboRAA+opyeZMx/aeHG1rG2gRs3VNjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_protection(), mem_cgroup_unprotected(),
> mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
> protection state. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


