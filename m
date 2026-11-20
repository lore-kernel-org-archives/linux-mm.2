Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B60606B210
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YDOml3pb
Received: by kanga.kvack.org (Postfix)
	id 8E9A96B05BB; Fri, 20 Nov 2026 13:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A726B05BC; Fri, 20 Nov 2026 13:09:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED9C6B05BD; Fri, 20 Nov 2026 13:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 208A06B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90C8A40160
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:52 +0000 (UTC)
X-FDA: 85456285824.24.5D42E70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 64B5B120006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDOml3pb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198190;
	b=hV3IEvDYvfioELfK4X9j3oOkXZhYAISooHWHnS88Tib20FFNE7P+OIeIEf6mVQ8XSMseeB
	pTePk6pY2lv7bpd1wPURuKYn+fomQrF8A5sN7i4RNnNQ2keno16ypNHdp4GanFt0FITRSF
	ugjJ/nw0hw4hU8ZNkGI/0mLpPtDLcdg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198190;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09bgEhSy3QiJXmk+xsvyg2Evx8mn/TJLK5Z3TiEB/ao=;
	b=kWxn9xdsbHwvG55298gaO5MwnfjNuvoXnzB0BaAcITr6T/6LCWEy716JgNv7wOfeBtjmS6
	2kJBJRNYuvylSSRs80iWR2acoN+zN6XwPcdcCqStk86shSGh7GlTWQ9EBPzLG3r0mC+PF+
	i29+/wP1QL+2r+OJn8GzAYFgNprH6D0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YDOml3pb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4DB545F4C;
	Fri, 20 Nov 2026 18:09:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198189;
	b=UkRMPduBB8l2tdSINEidXhVrg2kngFUVjKHghZ2vFTaPhiO3A891yCtHyQ/eJ6CFZ6I5
	 eVJ1QqwiqqEiYJm7jXi3xJsA3ULNEnASoo06Rngh1KQ+umqU3YNkmy1CQavw+VHNucSIy
	 StLX8thLaVIEyA05VjDla2rLs32cW3BBfDpjrNJ2Qnph1M++V7vHYWPMSyaWr0g/NsQyj
	 zoLu3eWSpfuNa/AQfkXc2z8z2lPnHHy24Yg4miUYTov4pV07ZZsbYle4feEGYu7e6Deuj
	 1Ta7v5lt4e2lzxvNC0TTAj2jmPml4xZ0HWQOvmG32HQ8famKGVRhxM0NMwD7GQfUnTA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198189;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=09bgEhSy3QiJXmk+xsvyg2Evx8mn/TJLK5Z3TiEB/ao=;
	b=1T8IxDtgrQ+fB3AruIiQ3GiahRU4mqELd/FfbrVcjJI0leSz7SL/3O3vvFxtWTQJRXc1
	 7VwqXUcxHLP7axzztVrhHYKZ18gLUeeNWas1EJ+i91D6SoG2A8VH3NDtyod4jWyqoUUzk
	 C9PHtovtYlVwC9TEiIx8Hn9ZQaLkGj/j7Cn9l6qnaZQJqyYSKIQN31IXXJNB7usTrO/hH
	 j7QgwExFXA1J8fDeqTyrLWXx7VgxkQaCUg6+1PzQWiNa+eczBuFKW1lqt2RhZs5TDnUSK
	 /vXD+jy1xNVlU6WoJJS9xnNDZdNJuGaX26YNdsZMZ6JGxC4Na2Z7Q8GJNpxJ9rg/7cA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 351421F000D1;
	Fri, 20 Nov 2026 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198189;
	bh=09bgEhSy3QiJXmk+xsvyg2Evx8mn/TJLK5Z3TiEB/ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YDOml3pbppDdUknQMjpkjRzEWY3YGTDBeSOYum5MncfFCeUhAFtv3Vd8ceEGr/KLv
	 d2yjfNTA+c2ZtPKi+AIAyJdEtts/gHfW9LcwEgugZaB9S7ET3pghgmS9SR2cK4Osdr
	 2LfVOuFRw6MthblcmWHDm+pAe8c2DkynJVfYs+GqQ+Rh5RL28hqHBPB1k0zjN2huKh
	 QMCzcL+dk3KuurqdlE0xQ37Pn6/t0EfZ5hSqAFa7Gv1T80UeWt7Z6jte07mN1Q2GkN
	 TQTNfgr0oPdMaX7r1vyDcayn7ZuMnSMq48v4hmYQvnKsC4fDLBtOM9qyva2z+DFTh0
	 FFNtUSAe7+wfg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EDA364B8E1;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:59 -0500
Subject: [PATCH 08/60] mm/migrate: reject move_pages() destinations outside
 common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-8-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=835;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=pP22b8YF19lh+xtqINC6tvfU3jfkWVAhKO3xXxkME4Q=;
 b=zIyXXPWBVmQkXDlYvC5h4ZDvLmW7Fv9UoBLS9vJ/Pz9f2a+rQQr2z64NdVHxlPNBrL4P3HD5y
 CL9ctZIadC8AcBeiIq1b1GZsIOfZ0Hg0mQWqGbUkGaNZffKMPxNdRDC
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1qhayupbmspajixa9wwx67iquyqqxu8q
X-Rspamd-Queue-Id: 64B5B120006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795198190-739949
X-HE-Meta: U2FsdGVkX1/9gv5V4JfLNimt2Z8w/zMVPvacdeI8srq+htBJctYkbV+VRvzRAjIfESFyPqQ+3phg023GqPCAyVC1ukxcBWfcflM1i0cEsZcOR50nTtf8/ciTrJeG2KLNBBTvte2GB2mfLfuork0HR53fvwQg+daF04L9Xx6KAR1LX7GSsNLco8hwT0DzhKnG4QCtHC6MSBjFaHLQKpW27Wg+WF4CNlXt3KasSg+JQWPpQYBmy64OGvrDdXwYeIO8dvcgkumM4lt+9FmVD29Jx8gQpev98hY1uNRUo0k2lrLuCCkdfi0pzxVzcM8JwXKmdBpUpltiy9RZUTmb76fORoM1BpzLRIpOl1hry9jl8jidKg2QLb1FAw/m/0RhIjXmg8VR+qT7i4bOecR3JbaxprPzlH9FACtF5DWLr3xZdTKdSIaqcS5uDkK+Owsrm9LFrqjeHUD+4ed1DYVKaPbKIMr8tR0/uzoXuThtUmeWw3+wdjBpN5XvU2bYTAeEXe9N3WR4UqrS3UQRjc65BpzmVQcTJkBU7nSQRnQn2JP24I4hpHJfD2ENDSqSVq8o8WvKt9FzMvBBsgV1EPNh5VJrpCvHx2tBjB2JSTdbp3I5ETiv/mlVYe4czjRCAbOLB2yiKeREU/IlMUhb3bgSWioSX0N/y17w5kWxAaFmJDqnHJXvsEH11rebF2Giih4W6ff31Sjlgl9vpTfnuMs0kmJFwgxx8bXyKoCrHzZ3PdOg8JWoQZZ0vQhFAW8vpyWXPTDNoXPr3Q1eKzJ6CQhm0l7sYypUEYz+qhHgN0rgcc1EgR3+Gbey8nQOGWa5GWDrn4GKo08dVGIINTbU14VZohzWfNB00YH3TTyJ17J7rlEv3dY1g90a8PYVJm1Ntn27IGlr9VphCd4FoJpDsl3hVRNV21WdyPpDwhJC14guQEQzPkyKOk3s9ZiGKGqEzKSBe34jNWC46MTus+5lYB9Snl/
 r5uxz7zy
 EC6ZyExPr4cx0fcogmT4DSxJVRMpKNqlNiJwelok1ZfPXNAWtsy1UZyOahd5rAHZDZrD6mZ8dloVOK9E6mp8tgNC3MIjvlq1f5ey8mTgpR4cubFpMi0C5IPz3v+NsnrhL7BkdKyEhg5LUPSwI0p8JqGqu+LaY0jF5p6fk/gJRySsKw6IxLC2aoURmj2EsQzR6UTVIqsMguH218O3Y+9jqzJQVgyQsCwsIKXKUivdd9RKv+Ul+pcC8t0h+vUZ8xksOhBzeilPR2QkuusjWETb8MeEEyG/o/+1BJ/6fPP15ebvWoKz/9jsgNURyncKhgfQfGledqN07qZzJdt+EIaXlxP3KcTTGrjVLFRK70Y/GN0wNxxpFoU09o5dF4ZG2YH7HQjY3qbia2Tx/u3muUc/USgNRn4WVTrBkwg/ESiaqIoq4ZM7J6chnWawUGicNxWuXysvSdL7lO63AZxl42CXWMotMcZ8oJG9O+BwPfLkvthTxUU3STrsgwAgw+ubLN9AOzdJOxmc34ezab/lr+9KDRa3dY3ufEGIVc0m/YI6R5N0NlNY2KRuqo2h3pWZ+yu9C4l+oF/RQo+hE3o0Kz3H4FMuvtfsLWVqSQqLRI5tpxZjYZFPbCPzVfakCQNYCcNdEfnIhpKz/CdR8/M410mQnzN87C+gDtGnwTfEIWn7yBZTz4TYLjdIvhyYDnPL4en5JFrLbBNNeVRxD7sd8NOCR5nA7jOGXJllRy+zH5GXWCIOAJwOSFaqSrU4Kvc0vtuiReL357vWb6X7RJq16RX75LBwPoZRX3d9u1uLRuyUwiGGq+Xp2ExmKWTrOirI/i0tvJMDQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

move_pages(2) places user memory on a node the caller picks. As with
memory policies, the destination should be general purpose memory.

Reject a destination outside N_MEMORY_COMMON with -ENODEV, exactly
the same as a node without memory is rejected today.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 65869b8acec5..208788b130fa 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2411,7 +2411,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		err = -ENODEV;
 		if (node < 0 || node >= MAX_NUMNODES)
 			goto out_flush;
-		if (!node_state(node, N_MEMORY))
+		if (!node_state(node, N_MEMORY_COMMON))
 			goto out_flush;
 
 		err = -EACCES;

-- 
2.56.1



