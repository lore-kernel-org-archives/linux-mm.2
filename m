Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C29606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oKxKo39Y
Received: by kanga.kvack.org (Postfix)
	id D91C36B05CE; Wed, 28 Oct 2026 04:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69C06B05CF; Wed, 28 Oct 2026 04:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F226B05D0; Wed, 28 Oct 2026 04:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ECB76B05CE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:24:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98674160C31
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:24:49 +0000 (UTC)
X-FDA: 85371349098.09.4ABEFFD
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 18358180005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:24:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oKxKo39Y;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfoVrSYOIzxmSP8r27IFAd8Frmu7ylTcKW71rW773Fg=;
	b=irUU0+riLP4jxp2czLEcNQvIUUI+glNuvuZQJcJMZAO9Ti78oGmOwjnX8AfU406wMX6TZz
	oRaiwivaXeWdzFgAYYDS701WHq6as0UozL1pLVp44uECStQOZbQXWpZTF529URij31zZEA
	enhfS4dfWLXJzoMX1dfma1OOnPaBxCQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oKxKo39Y;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175886;
	b=gXiM6+O8QDUi4zJg+W6+G9IVSGEZWPqoJ7nvZbLQuWzN3ur/M9F/Z/3nZTKOSgCCoC9IPw
	g5i6PkY/jIlw97McBjWk6gW9Bcs+HCnwllDN+mFGMDD9AsZiFDmyphS1oy+xIUFLkZqWMi
	q761SwCwiAXnBHqdZZeRIxn8yPNeTfk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793175881; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nfoVrSYOIzxmSP8r27IFAd8Frmu7ylTcKW71rW773Fg=;
	b=oKxKo39YnjDecrJ9vQGt5VoDSJr5iOvdeo5dTF68P2GSUvraMmJwlYd+dqHwG1ST8U4ESsrSd6sR2qxP4vw15s2Lfn4N9GtulczSotGaEOzs7oDpySA4WoPu/Cdncu77y02zTC83CUvEhdJIWcY+5k7NanA0dseuJ82RI6lF09Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=65;SR=0;TI=SMTPD_---0XDgGDMt_1793175874;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDgGDMt_1793175874 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 16:24:37 +0800
Message-ID: <c822865f-8287-4a68-a204-d041ed85a695@linux.alibaba.com>
Date: Wed, 28 Oct 2026 16:24:34 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18358180005
X-Stat-Signature: g399n47wyngwazgehq6y3rgzgmjb8o5w
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793175884-668837
X-HE-Meta: U2FsdGVkX1+H5YF+vm1Q4lxdoqvZMUv3d7i5LNCN2cm6f53gFeC8eo7YNwUvAMtOCg5ixPsAm/oWZZvCENE1ZUB17gAvN7IeKiKvcfUlQFDWe9L1yq0cZ61oCwGHyvDh8bKUwqlQZLJ2NMLfr/xNUwy5BQ2/QHVXZcyKqDHS3PK/VcA+BXK5Cdy+SII7W4mWHC0gzi471ommaTuqDgbZpRzoeEPpvK/zDDqWre0b1eBcaHviBzbro4mdPTyzUFFOnmD7C3DB3Lro7RTlS4GTU5H46OYCemKEcqJV8MFIImtyOWLdtjtQ73qj/p3qOoZNQ3kyN1Ej6tetCBVS+cXLwO08SqXr0QGrMqozIRQEjgMLI6OW3CFtFehM7KSsG0zrjS1yIQDxFs2T435jc5i51OXTcPn4rexqsxQpNJn88skgpM3rLV8r2US3ZdL9MdJEyzbtBmQA1v6qrby0n4X1l6Im6AB979rgjj+lEYxGwlapcqFcZe64hpq3WDzENMEq3x72XIM1SnXhSV3jFSC3K9UGBQcZ+Bbqa9ulkECdsjUTQ6s72P0v1PjUGann9NMo9sjwskn7RB6nV8tgKlNSmW5z3uzGZY3uGfQ7i8LaJHC0AJUolvQhQJa1+O+lK5wPcNlbT8WnMVNzoKNmTf2FZw5EESgfAf/exemcOHmUdmc5btyT19QHMouUw963EvngoffGMFcIPNtuVmmqUzxzfw/bdg8eSsbf/9jZ43ZlkgQsAu9F7al5RvKWHxX5a/t8J2NBzd/riKiVHsVrI5V7FxsxqVS65P7rhowkqFY530amWilvHBg84K2JOL4aR4hsz+woBqiC6yWs1U1U8G8wR92kiOjOjIr41E81RC94Tq2t0pooX6gsGOmiCgWeQSvd5SKHN7g4333yufo9F+OUMnyjHLHIZP14L/wSd+psbz4IJxVYxXFU1jeQn0OYYev3FuzOPzXbbe+n2mM6V/a
 /J0XOHSf
 o/y4DJQgCPSAXMuhM+rlrtA9IWEKX8FzAeF3QJ/RupoGMGw0VvljDYTIKVSDHLjwk8vbYjeP3HobgYtdJbRAfUZm3977v+iQ095t2UD8HKs1VYTe7uQHZ1vCKPPg6fC6+Qo+9JzLy+5v6ag41S91HnEjVs5jOHXTohrudcOBpMvJr9OhzXzi8EGJyjPwas6HZhY2tzXSjdnHKTq25JNCw4iqOgRRgcS7HoivvxQ96EkIjp6vJDw7xi2is3gIf78kBMBS+ZjQuGni1O3sPfMuzxpmPcj6XcJAPjjADyk60GBf55WmnDiEme26x8htwnq3fv2EaJH6rB3Sojo2tpSLpGaaP86HuoXix5nAYLhfduPqfm0mL+Fcrdrm32DXYALerkBJ5PvDla5ow/ZCBgGExu5YxDrZzuVbuXk9tfbDv9ZfZUkZgnWpxvRq6wS7bcK6RVi201c6WsaTv28Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 7:17 AM, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> MGLRU passes stack copies of page-table entries in walk_pud_range() and
> walk_pmd_range() when walking to the next level. These copies can become
> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
> table concurrently.
> 
> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
> support page table walks"). Likely, earlier locking masked the latent
> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
> retract_page_tables() without mmap or vma lock") allowed concurrent
> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
> for MGLRU") dropped the walker's outer RCU protection.
> 
> The fix is simple, so just fix the original commit so we don't have to
> speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
> RCU-protected lookup and validation against the live PMD. Note that the PUD
> handling is required as well to handle folded page tables correctly in all
> cases.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: handle walk_pud_range() as well, clarify+simplify description,
>           adjust Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

