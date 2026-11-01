Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86018606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 13:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I9CBx1JY
Received: by kanga.kvack.org (Postfix)
	id 9113D6B05B2; Sun,  1 Nov 2026 08:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0BA6B05B3; Sun,  1 Nov 2026 08:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789746B05B4; Sun,  1 Nov 2026 08:34:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA816B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:34:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E942B140A3F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:34:20 +0000 (UTC)
X-FDA: 85386644280.09.D9C40B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44E8B100007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:34:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9CBx1JY;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793540059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/M6qExOqb8XUv7eLyLKqlaymjQ0+DJvQLr/zZahSjc=;
	b=6FVc1ShHnJqEIEjxzBLFzKR60DYjjbKLjUH0vAccLRdDJ0nleoPgGtgqlGUb7GwxkCm+El
	SnWy577WYHx5z0YHgr7wpcrYbrHjPQBiVEwybOMgEddQ2pMTwkVmDT/u6vMiXuFOVwXhAW
	rX/O3ipQcBVHLHMm9BBnZex6vqTFELQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793540059;
	b=rlSJmZHrodSZUuPCy0SSG3cZ7vrPFmilbowXQ24S4iyCRuCt11t3dQ8NLJsj1/9q+tBgqv
	l0d/MlzUMOhGpwG0UBl0vFm0iMm03PqgZAzeKGXiHgp7wL50iUnUat8kGQZUAcsKx1GUQ6
	qQJrU1oS3zhteBavn51ORlDNPToU640=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9CBx1JY;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97C15600E2;
	Sun,  1 Nov 2026 13:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CE21F000C1;
	Sun,  1 Nov 2026 13:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793540057;
	bh=s/M6qExOqb8XUv7eLyLKqlaymjQ0+DJvQLr/zZahSjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I9CBx1JYEjs9/UXI8aT2gPnNgV50yJJNmccMkykQlEmIU9HbZHN8WMgpII6pIFEZ8
	 EhuSbpkt0taDVCd4kvJwNK/n9bHP715GJQ7t50VGO5CRMpUogqCxsELVqjeVmOxHHm
	 KugpLQ3q0TppvGTZ5u8gVvy4JjbgdAIT7USq6/+cxZKkDRp1l/oT/PvTYJQFOAxRqF
	 8fNGkbPqi6EhbfRHATOCFIF8M18rQEk1RaIhhPZgW7HVO+YyrflPcu4CFF5afWwirN
	 /R0qYUkvRWIAEqgRrbOFagp5Qcab7bqLdltDB0ipKN575KPcYJy1MiIsVyEYck++1O
	 uzsubjwkGfrwQ==
Message-ID: <1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
Date: Sun, 1 Nov 2026 14:33:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
To: Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 44E8B100007
X-Stat-Signature: 6jirw5zk3b8hpefkruk86t9p5rpghix3
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793540059-606363
X-HE-Meta: U2FsdGVkX1/i4b803EdP9vbVZH4AuPhOWI3aW2eqM4LKLWcp9ktUVYVoewCVStzre9MN+lcBXaLs2WYJCa2FRpaMLbEXAnadZPckxVYRssLZ9VYyaoopouwzoc9WKr28n+B/yi/mxXoPkn7R7W1VMpRJVBmCmsYmSRMgPuj90PpL1IR35fTtCnmBgV+v0OwbQ3+ekiIonCaEi6PyPNky+J5ibLnPzJ/5jJMUcoKu4UXc6u7+kvwRl3WhwkFpCq6TStRgJ9vui6GRr5q5tyGXMepSnC8xhNHQJWeCh1ULbWYQPkrfCxtloaqWRAz5f8L9IxEGr4Lfpplmot7d8rLdhRHGbiQHo8gfJjda22c/vLtlGNWnVZdQCdjw0mSpxGoS96mdhbwhgJlb1bC3gjVZ/hTJ+YuVJqGpgDSQvxiKAYCvDp5TKiEboMBdJFYO93FSX+52WvUmLGFwr1h5TT9pF3AoL7uaTgFm4BnIivHrwgbERv2YeC8bsvzpjNZ2DxrFeZXBvfBJUkQfeQnlwJxYi26gOeJnPNEH4yY/WjjpR1/MY37jlce0U3sg9K71TlfUHw7CJlgKCUIMtWjNjwqXFXCP8yyVos8z7jysFeONTZFn05jsvTtiUMme6TSXCIc+y4Kt7hZ2OUlBKLCSIbLxu/TZQdZh6QqnFz0YSPd3rswsNhrjj1keHVUU8IuDdgTsdUuFvPrl5q7EDWmtqHH3dXW70vlAlZXKOKtHWADf4t8W7MyFBMTLYx5v0fM+oENPZzHlSYSDlSN6nybnYl7mMMYhhnowTHV35B5nAmhTtl2Yi0a9Do0tTEEwN+FQdnKJUtnNjN+8Bq1/IRo7Lc+y3k1yBo1kMqZ/4ekoOtfeudGLXImSSoDiC6gs0WsNXIQuhYS/Z2p0YiJ5lqrVjSwZeq9MEA7jrDBzLYOiLz3mrUS9U6dECMxHgvTNlCx4omNuS61L86aqjRmt7iJtXK0
 iIaZnShm
 lifCiJXllETA8dDBbAi8nNshaySQWKmRHMWdKvyGXAk2zaX++S0ZAkq9F+lVUKM7NDPbpg6WYjmSTg49MABWD0lEGxkJ32x0938LZ5mTBDBPJNye72AydPKVXbI7QBUILW5o+EDxwUsKHUWBinlOW2JTXNXa4p91Xw0OMMHk9Hw6NTjrkN5sydOgTGckyCWg/WXyZksfDU1fZ0T41U9nQFIztrlJo1ygImgo5nimR/ZFAWmXWmlfnmMQZP1I2gPcKYCtMJo4gSRy+zObihwG2/n4d/8deDm6KRThUwNFpczAKjUek2XXJCXKhQhqPARIJSd5A7rw2oDjJBSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 22:34, David Hildenbrand (Arm) wrote:
> Hi,
> 
> several MM updates:
> 

@Andrew, should I pick these or do you want to route them through your tree?

-- 
Cheers,

David

