Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498F5606A320
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 08:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClYhZINu
Received: by kanga.kvack.org (Postfix)
	id EB13B6B00EF; Sat, 31 Oct 2026 04:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61CE6B05B1; Sat, 31 Oct 2026 04:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50F56B05B2; Sat, 31 Oct 2026 04:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF54E6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:30:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6B2A1A08AF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:30:33 +0000 (UTC)
X-FDA: 85382249946.19.CFC7E7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C07D20008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:30:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClYhZINu;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793435432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spOkjFwUciiGe8KT5cGcnRY9XKTmmpVqexi2Bqbn5rE=;
	b=M8+8qA8aQE1KwlFEmpYHJCD/YetksAKWZBH+X5SdXVLLPvYBBp2THS1I/fh4qMs3h1vEHT
	SeWvVUc4DTXiDHgw5OvpYlyZTgk3y35ZUmfKwBdvYdnfskCky0ao4FKkdRwiq8XMld84ei
	15E343E6nZYj8b6Af2SjPehIIrKFdL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793435432;
	b=A4FSvC0/jwaL2qTvcZPBnWPQ3uv6nReTBeZCuvJmD2+5Fvm2v4LVLwI/VJrKdNtgWj9rDB
	tOPh8tH/cx3W5naMePUToiA6UrAIymRwVQD1HVU9IQyWFvhn48cB3/PgCpJAV5cTEd4xqQ
	kjX48EgNKH+bDPfbZA/XBRhZM6uJiP0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClYhZINu;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3794A43E82;
	Sat, 31 Oct 2026 08:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696971F000C1;
	Sat, 31 Oct 2026 08:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793435430;
	bh=spOkjFwUciiGe8KT5cGcnRY9XKTmmpVqexi2Bqbn5rE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ClYhZINuPfuJiCYUEiyjdoHCU1/pBjA7GVM9j2SeiGDzci4dMAGdJ0eCc40y3FS9t
	 ry3lCiIUMkYLn/4zL4h0VeFCKcjed7KvgGvNx658bJjBX1SkHzjew5tEYISor60cYs
	 I/8uYB9Fr/6D0BYURX7zpb2fyO/QgJ/sAK3/VNHt1YU/0bEdTiGcO27fM5Rj+GbtUt
	 JNilErJdupO4B518oLxkbdx9j9zvaZo8Bo3h8JtuZs+vHjCJOJgBmb9k6JTfIS1hZ7
	 wuw3f7GiXkAB83BJgZjkL+W3IbsXxFIpvCPJbtrwSk4MvbM3G0yLrgQ93hv6TaO7Br
	 oKyJmcrLqdxGg==
Date: Sat, 31 Oct 2026 10:30:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Byungchul Park <byungchul@sk.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Dave Chinner <david@fromorbit.com>,
	David Rientjes <rientjes@google.com>,
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Gregory Price <gourry@gourry.net>, Hao Li <hao.li@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Message-ID: <auWnELXh960kTdfs@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C07D20008
X-Stat-Signature: drzwgjmyu9dh8f1pzkkkj7q9bn3b4pxg
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793435431-968413
X-HE-Meta: U2FsdGVkX19JKjOGtwaEoe265hWX2B4Ae8WdNCKAec1XPf08omM6vU77s20z1OECHK22w+I75D6WBshCgiEIMQiiFbS0+V1W0aCyqSF5flV+8OI2Gfxu+NKHw1B472oCjmgoQXFfVlTeBnd5cl5luBNL/9NJ2yWPabYRdokVDQAfqXu+Awt2w2SDn4l2UQqwHLAEU1PnQaXsKID1C/X6FIzqim2KEff6qG8rvps1G/ItEXlbvDV6v4P7ELde9wGr+xetIrGTtT/ZiK/VIylBON49UeQQdPxpZTU1rjT7tCBP1YOUTZ1foeK2DPujmyA173BJtNySoiEGY/zcyf8UZCFaIlYOftJy6MwOdFSyFgEoTfqkPeszLG5+HU3Io1RGTWuBDtfPcs1nYjn8WSf66vJoIWpzZ2WgvmUXU5jTURC77MIC8gu3cPBYHx92yMQQk11OdqqMugHK85OVUPccdx4S+0Miq4toUB2bsTJpWjLQZA0m+eZp2INnXC+uO0ImMtMCLFHEAqoJ8fF99bi3xWeLo0IivWNBd1EOypjAiipQOXjumOCiVyF7kheg1KpeRd+eshXpmqUWbLMJ66uIQe1NBcbqPtyLubrr1tx0SxEmwKVl6O0NIO3ZMGUVwW29Eq1Y/WCwf5IMkShPzN5fl8Je/zi7t/YkOYrHJA3byEO6j1pIQySzNco18kXAVz17AicD9LDYzHvUWWxiqn9tMOVv55jIu2S30cY2gd+InnIRhBRTvUpg8FLPTuLB3UYEsjBJ/vSanC7YXm9Y5gl4N4LLk+XZgq2zhg4J9DmG2a50s3oLw715l22MmpzuyCS296eUh5B4j7JZX/Lvn44uHaulpXCIdHeHz5DTYoB8bm+altnpJ7nVjFkweNwSwQesSBbRhE49DEdfc3lp64UB8IosZRCTtuLpT7+mUrL4AtfrTUxsjBtAk4/zj7pWI8TDEUEO0KYnKy1rl23tEki
 WnsOwKRj
 OWUPhXqjGOgCqt/XXKUIEy6gcyuwjxmoEQ/YwkZVuUGCnp2LUU/OnxZGyq7pOldora6rLLBjgQu89UOtKKC40V0fDDyItIdpN/8OVhqg8SCrCoN9Lo/q1qPZl15v+CL1ruRM+tlQU9G+Jy0L7lYqjBQ2FxBtUTvxqcIKICd9WR6+j3cu1VDm48uWvj7beT3ezAgBosV6sC9WtXZKbd0xJuPvZn5/elu/Do0fOURt2CAKnfWY76NlLtBf2BLaWIR8T5gRc4vw+G1LVh8uNLa4bDhjvbbIRFXKniBF6EbXua+vz3DfkmMslO7v9ImfMX+dP6Z7tu7XT5hDnAIZS6s6oROBdRuG75evYhilq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:34:24PM +0100, David Hildenbrand (Arm) wrote:
> Hi,
> 
> several MM updates:
> 
> Make Zi Yan a THP maintainer (thanks for all your hard work over
> the years and thanks for taking on this responsibility), and perform some
> MM MAINTAINERS cleanups.
> 
> Then, start the next step of the transition from Andrew's MM tree to
> separate component trees that all get integrated into the mm-next
> integration tree.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (7):
>       MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
>       MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
>       MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
>       MAINTAINERS: sort entries in MM sections
>       MAINTAINERS: add missing files to MM component sections
>       MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
>       MAINTAINERS: route more MM changes through mm/core.git
> 
>  MAINTAINERS | 165 ++++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 105 insertions(+), 60 deletions(-)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
> 
> change-id: 20261029-maintainers-e2699bff7521
> 
> --
> 
> Cheers,
> 
> David
> 

-- 
Sincerely yours,
Mike.

