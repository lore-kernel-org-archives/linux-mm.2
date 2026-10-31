Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FA8606A321
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=msdHDOcK
Received: by kanga.kvack.org (Postfix)
	id DD2446B05B5; Fri, 30 Oct 2026 20:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA3A6B05B6; Fri, 30 Oct 2026 20:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98F76B05B7; Fri, 30 Oct 2026 20:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE6CD6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:43:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 389024090D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:43:35 +0000 (UTC)
X-FDA: 85381073190.19.D8973ED
Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 24EF980007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:43:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=msdHDOcK;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407413;
	b=LjYFusMrsQ4qGSQmLsZLEYa+Ti9qXA5tTYMv6uWpS8ti9M479Zo8xT3odQKMYGpokgFQC7
	I2kU3NA8ZLRmj8RZ13bPt+2YhrV4tzku245GaYGFdLHNFDWX450YH0dRt893swi+p3DLT5
	v8+CuhnrIIA48bK818yMNVdH++mcwqI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=msdHDOcK;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcsvWI0Wp94jtSX1XbU0q9DSWkp9MXum6AodoX2HZek=;
	b=lp2bnW5qV+NzBPaFBGo/G41hGLsm5XcPjXOMqAH7Ecd2WXl6hs0Ih3SvlJpC7utyz2evHJ
	Xqujb+D5BX8WOtAc7stbKQs8qARmd7OC/0YuA4qcKwZD1658GwFa7DF+VqV+jgBmVLIg0C
	RYTgy1vnBUceiYI8FUIVantrcDL9i2c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GcsvWI0Wp94jtSX1XbU0q9DSWkp9MXum6AodoX2HZek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407411; v=1; x=1794012211;
 b=msdHDOcKXUZXeMgjI2ScsWQZ64pO42RvFaX5gOMfg3YmamTmcuMFDjfhKMpF6FMVa1Bz+USZ
 czeUjKOe2gPfVXn+8WHmcVsI+mt+tRQfUiXBMGodxYFz14KowcbJmwXkREhOAiIhVgkPsC/mizT
 f645KIKLDDezBeqGXT1aDwpk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 72c000753756bb73;
	Sat, 31 Oct 2026 00:43:31 +0000
X-Mizu-Trace-ID: 72c000753756bb73
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 6/7] MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030-maintainers-v1-6-97278f8a5f54@kernel.org>
Date: Sat, 31 Oct 2026 08:43:03 +0800
Cc: Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>,
 Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>,
 Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>,
 Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>,
 Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>,
 Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <755C6FD5-84CB-4091-9AA7-929CA04B065F@linux.dev>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <20261030-maintainers-v1-6-97278f8a5f54@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Queue-Id: 24EF980007
X-Stat-Signature: b4adtofhpx3gfpohmiu37n9eho7pc1a6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793407412-369217
X-HE-Meta: U2FsdGVkX180xuVyfDzbYzt2UKydo6kZsRg9+B7PFJr7NmQJOwmXWYsID+9llPWUzrPoHZnZESc0z7ziVEmdkgHCWa41suWNxBWlHgbk33N0gHrhNM3CYU1FDcQUFQUh8Z+1HDxdOQDv+syP7OUsI2sTzQ3c+Ocp3LjuMXo+TJK1qOlagPXhfe9WWXDjB+aLmcUgIrVli9DFksAfURu2s5f5320/bkA0BwiITruEjasz1X81+yvqNsjY6RxCTH6LVnQwZ4CeexO53WJwZoIihoe9KMizw3QYT78CGHPl2U4N4iaTIfolS852LYNZ8sPpKshk/khr8qnnfFrwOB7ROW1XVSRBek6UBVIbyjaheJswn2H0zih+cCm7yTY2OGuTN32/0VNqP1rrWMZ0CRm6RmgzV1b4ZFPZ7f62aj0KCPM+Th4y0F7DOfp3ACkEXMcuQ4RhrotlkYyIgMEe+z06o1R5MA94ii3uBiZWDe1AZp2I2zeEk2P8QlFFFgiddsQxvhvfcHX+PFa0zylKXgsH4ZDAeqM/crirltyRsLJv+juolX01fmbkLe9GimU8x+xFPtYV79yEjtNAFKmzojgNjhfq1FJmN8oZixcVUpv22a5a0Jwd2v279jUtHlravPyV6aOgTi7lNMqdmezCrCzB+whiIK9XFsV0suT1lviIBfXZ/8VAvYznB0hUEu0dS1Bh2SB7MVWPNQewG2/BLw6Pz2MEhT/RB8rgnBvMFhaSG+t1waT3+d8Vi66nAp/WR8vy1O6E4CTe6NG8r9ilvifyh7mn682aFyKbbFrtF6ywk5/GfihQaPb+TacXClgzmvC/cAvLUwMNIjXh53udogJu8FstLjaAEw+02DAxijet6LjxYJB/yGLzdlyAaaESEoAP52wIvc8gVUCwGvbtwOtZ7hSzKGcxqlni3UdbiKRgatgp5aSpyCv3TX38O/4bHqnc7Cvih0s0b8oXIi21r+p
 10iAfUFM
 NdqEUhqk7JZe5qExgf9WzrZcLVIpTYoJLFmko9+yZDqRGWUhnwbAB/Ol4g6GGuilXdxjoT/dPZtzv3Kpo3oEC/+Fy1emdQDPxoAvpO4VcJKPi4Ph8ntQdUlKHH2FCrDMHy3xFH//U+lWQDdvevDJYaPk2XjVVU6hxJy0mCI977G+R/4tMWHwFvVW9KDtubxxmR/kNxxK8e6chfsAF5HAAFN/SPQMZwD7/Qi74WeMUqd6a6SmjLZ44/ncbTEPKvgDRiKEU53PDK7YnGmPeRSugBYPU5ymSlf9GdB470aMwiEqajFFzCrTWvd0OQZmGYETQ3mCn/UUWCT5OYVXAWBncJb3wvwJSg0Joa7YVW8k50IB/NwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 05:34, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> Prefix "MEMORY HOT(UN)PLUG" with "MEMORY MANAGEMENT" and put it into =
the
> right spot in the MM component section list.
>=20
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>\

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


