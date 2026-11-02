Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD431606A332
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gyAh8T7O
Received: by kanga.kvack.org (Postfix)
	id CF9856B05B2; Mon,  2 Nov 2026 07:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAACF6B05B3; Mon,  2 Nov 2026 07:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73186B05B4; Mon,  2 Nov 2026 07:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 961F56B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:32:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38ABF120CC1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:32:26 +0000 (UTC)
X-FDA: 85390117092.07.E74E482
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86A7210000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:32:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gyAh8T7O;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uJi7vbsm+UXiwdS8CU4SHzxGBAn/qkTD6YcNjfIfjQ=;
	b=w8dnwwk4KvQrEmzypQO1euP1ndtv8Cr6ZjZMXF8fQQXjkdqAdZxQrJgmJXYvvRzLAY4oWj
	IPm2Pt5FZnw/xo4XZU2iGrvZ5z0+VZnoej4TZz9f+50MeEOLyO6f84fyBFGlxjzmIcbKBq
	aMcNyuUQL5roZLKWsFqq2a3pzDBG9yU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622744;
	b=5ojVj1hv6uoha69cdWVfc5omYYaZXooRhGdMJIg2rGmWPZE98ONoawDKAKEAFTWkeAV0Dx
	WfBHttRss9MfUd85rJ5hJGF9XaGYdlj17IvBfNfpudPmHdk9b6YkY7uItn8blSShzLs9In
	nFmU6Xt+n/gzZAcxrwTCKI86FzEKWnM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gyAh8T7O;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD9CE602C5;
	Mon,  2 Nov 2026 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F351F00A17;
	Mon,  2 Nov 2026 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793622743;
	bh=7uJi7vbsm+UXiwdS8CU4SHzxGBAn/qkTD6YcNjfIfjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gyAh8T7ORX22epTMSRWFxR6WRFA4zhOB1WCIITKcxdyx61OylLTtdxb/dr9lmzv4d
	 cuikthVJo5Icn3Gr8nNmY1lPUSuUR1No4jBHe3d6q/pqne2ZsLxlvRGVo84GuBDelg
	 1j9C/ufHKlAIkiMuhXfSrTcNOrceZPShIbQ74YXpMXqlW0Ki9ABS9zgYKibWGpd0Ko
	 Ewj/p8HSVEvLkJ0OrGoJkGBizdMfI8DGeu1GWFyJWY9Sdyc/+Q7hKLRJWAfeebVuxA
	 UljKd2nn3SkKOmszOlMHz4Gdq5m2JjNyPPSz0O/y1wnYkYxt4Xlad5WCu/VoqrQcxP
	 uWqlBmF6LrsOA==
Message-ID: <4adcc07a-2df9-4d5b-8b0f-6734e336182e@kernel.org>
Date: Mon, 2 Nov 2026 13:32:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
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
 Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>,
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
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
 <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
 <1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org> <auhw4mBAqzKU_-DE@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auhw4mBAqzKU_-DE@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86A7210000B
X-Stat-Signature: ee96y8qxd9zqi7ti9unej1uhgjb6y1zs
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793622744-386045
X-HE-Meta: U2FsdGVkX1+/a2C/LyJJ6SOr21Y+xnRmyWHUGwYsq0yM1HBQvN2ix4xXStGCF5jtjq30uSDGMSDv8w2/JO1vdYcEhenVdb2eHs3FJa8U6QEYxX/bBA4b2vF6mdlXoyR9hmVHPzbjifqJYKEjjh8dU0KjJsLS5kwtYtBaCq3m3ig/E2WaxuXyxvcA6XV7wx+R3PXoeS4IA+2LhzMj2LPACVgWE2rG45g7OuOw6Jp8bGxJB08tZBbh+PLWkMOLdAKpYtChCooLnvdQO6f2lC/djKse1f264HEuSIiKL8zQkjcXCqIwwVcbVEX5Oc1/sMHqosiqNayrOUCf9alLh/3fMIO1IuHg3C1uWTgRTs5Ej/1wON9P6hUPK8d+hB8xbOzzXlGfiB/cNowoESQNTkDLRrKyQCCMTcNx7AU0dzD15SX1lzG15oJ8gRizWTgnJAeRfkJm7uql7c6w4fWJXrUfqGzg2Pq6qiyvmmuP6lLIGoiogfNAG9CUPo9Klpvy/SN4HKw87hJzmLXAbRC+QSWvQ4iO07crquJzgTgMSXdz2PIq/Uyd8pP23eRg/heVeHymvDMvMbeQ7VCBuEC3FQt0VmYYz1sqgpqoSf93PdMu4zBPQNB2TVtIljnSP8kCvgroKJP41vilwxUcISqvyzwY49FcLr6I/iR2qndjOs/ok5KgLlYs7uQd/oeVqv/TP7Sw2SH1T6VZTIttoydrQXpg0qDmI1rb/XbaCx2SX4jtjct7TtP9IoaS/kJSGm4C5xf2JH31LDJ42Jv/Nzkvqn9z8u05p/6SdRn2XOv409G84WGWxomvWMKVc9rgU5P4eOc+6I8JkAfq9fUex3Ppi1C/qbK3nkKuEMbrSe6wEsqZsoY5aINSJPjX2lmBxtmnZTQMFRtbuavtMo/TeTvcgbitwuP+wPFLOI1sU2yVNRaqrC/YmTIk3U/U+PKxbwboHOyR6tqOMWzM+gXP1RqwXre
 UZRMvfKh
 eHdgUrVsx1xWcVB44GP631OQPLPVWTY2NUbcoCbZSiuumr1ZfDK+PotUfpYsPWM/Dh1346PFYotVY+2RvZrjx57UNymPQeKJZ3coTxzITZjw88oUYDVntLRzgzymlnb8W50xDWaaD5C2ZDks7ykluE9UuWUc7Z/cTEo3SB9sonYo3m/0RK1nVLvAkv4F55ShYSfivBvE+VVTcpVqMKk8ta3Wu/KFV4zTYmzVojfm0fldr6eWnDzeY4ZCnk9/uLZrS9TYhD/HyogaWadwU7UlyZhdOKK0pkclj3hMOxS27kgYmczL4gDJW3WOxj0D4Z062IOBNTizJNaPVjGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 12:17, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 02, 2026 at 07:47:46AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/1/26 21:30, Andrew Morton wrote:
>>> After that I need to have it whack away at selftests, shudder.
>>
>> I am not convinced yet that we want that for all tests, which is why I left it
>> out. There is too much churn that's not really relevant for a component
>> maintainer POV.
>>
>> I was rather thinking that maybe we'd want a MM selftest component (likely for
>> the later MISC maintainer) that picks up the usual selftest churn. Component
>> maintainers really only have to be CCed on functional things.
> 
> Hmm, but some of these tests are establishing important invariants. I wouldn't
> want somebody fundamentally changing what the guard region tests do for
> instance.
> 
> On the one hand the churn (especially now) is annoying, on the other hand I can
> just ignore mail I don't care about.

Well, as a listed maintainer you'd be expected to pick up these things.

So I'd much rather have a dedicated selftest maintainer that takes care of these
things.

OFC we can still add these tests cases to the relevant sections; we just have to
figure out who will pick up most simple changes.

-- 
Cheers,

David

