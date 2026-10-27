Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A30606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HHwNQOuK
Received: by kanga.kvack.org (Postfix)
	id CEE166B05C6; Mon, 26 Oct 2026 22:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C774C6B05C7; Mon, 26 Oct 2026 22:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18326B05C8; Mon, 26 Oct 2026 22:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78A406B05C6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:57:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6E9A4090C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:10 +0000 (UTC)
X-FDA: 85366894620.07.20096CB
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf26.hostedemail.com (Postfix) with ESMTP id 66751140009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HHwNQOuK;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069828;
	b=0JBV9bfHucHU+MhhFRTAr7E0IjUBQF6KnSzLEu6o6gz7T9xvTo9aCzFiZeFaJGN34Z28RU
	35ZEiUlfEE4ZiKAN3UDZsV8+8AA+UQqjtbcujtfNfH7BbN8+VyR/EHryh1MecPlfEB31Dx
	PrDcQlIKERifR7cGgp2lcnvTnj/Iaoo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HHwNQOuK;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPpFQvIKlQfp6jAqMmu68M10eR0+vq5Ptuld/Xq2ZNY=;
	b=dTN9scS+7qdzQVNTKRQMua0jAkz+eWftlPdclfKXipEDyu0JWQvHHAW5WA1HJ3lZurGvdQ
	gTQj78x27/ntfCKUrrxzQ/PAqrd+8P6iat9KM65GtTKvxGaPWPXPE73eNVF8I9kvtq1dnn
	+yfDduKndKQ2ktg1LymCgoEvtSYhAGE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793069824; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jPpFQvIKlQfp6jAqMmu68M10eR0+vq5Ptuld/Xq2ZNY=;
	b=HHwNQOuKI7DcEtOC+CtQ9yFDh1zXRWwJinIXyrJM9lxfds+O4aIAqXc/f8BxzkijY7qc1FGHp1aJfamB1Y0yJntaTOydKnzHn9C2JvlQ7Vmdj7WeJh+A4n2N0L3hsgjCbFWhXEX3aT77QgsIerpzswt7uGgfZh/SXlC/7brRto0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0XDcPjNv_1793069821;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDcPjNv_1793069821 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 10:57:03 +0800
Message-ID: <611de2c8-ed05-4830-a43b-8c2c6bd0ae6e@linux.alibaba.com>
Date: Tue, 27 Oct 2026 10:57:00 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] mm/mempolicy: charge shared policy nodes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 66751140009
X-Stat-Signature: dh4ukgr6fm7xwymzjojzz8ogr67x31s3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793069827-705603
X-HE-Meta: U2FsdGVkX1+mC3uIitz9hsz9prN8LLt9WhvDIt/2jVY45M05k6ZPfSskiBBwCa1wOyV0Myk4as/hjGdCMFFpd1TP3Zw/ecMcqaj+VnTjtoqsZqijec8bJgDn/RZcp4IgNtsCHES0Upk/p57uiq9kYBVQO8sa5E8znp7A84Ax2NiqhIURFjP+nyNzafv2QNmLu/TGPQvgxxqWGUxJuQM9xhvsVF5a3L8OUiEXUSI0U+4d7UnysTpQvEU4osgkwqQF3e8mU1zUs5EC77j83hNupdshf/P1rr/NaWZ+lLFbYeTb9DJSUPPzrNYIfoS5lNC0PEiAOPjPXI93PLX7wMysVd+VJvqg/zMQLYR3hZ/EVG8a5kNcEEzGwg0ITE0MUuqrdoB5ac32ecD0B2Kofl959bPWMmgwNBHn0TlKuKppD+STv0fZp9cLtDPbthNv5yOzXhXKW3CCWNb9MK1V6vo4PL1ryBlXtxEz7cVT2cJULUOuCQ+n7FjhD7kAFtusjXirjX65EHUiSHjvWwXdZiVKo5UZ20g1p1pRkgPhS81id0SsqaZq+NP2AgPpQIf7P85nuDSnsJM0Hg2ui/cozaxLDwiz4HDzBWW44Wb9E4cVsRoNGiq3+7oyuhIVSGQ3ZDrVyRuKSL/f8oMFhmeAJfRp62mpWxR75ePwMtuZLQai4Sq4Qz3qYcd9hUV+nlhyDjCaE5Pv+ZSRo2tI+VJmXgAHkA9Fjh/9LavBEMiObx+hA/L+oZ2tpU0uOW1Xdn/HqnKGriK9+xSdjE7cf0lM/PLucVCosy7VPM3lbnClnGHTmXfh6GjP1L3iwLhZ97WoGUdxnIt4ibtyj1kfFhE29Y6M7QU09agfc6NkBGDYfqWsHCU++UCGOxqHjZPqQ6DRQpSsJ9l30Ee2mxtDy32C1A/BAMvfSO77NjvwCxZgntiZQ/EEcZOmgd9aBxpN8nOaK4VSzb5hcpsmSB62P00ch+o
 5SeAZ3c+
 t95gvqS8Mnazt2v+7DL4jqOOpUu4Ovf/2lqM+L1onbTuHnB4aQncdQQb8Q3s+1i9ubvAP6rfKhQtLaGl/IePljHPZxZoMfhIaC3ZZt27+fpPAHYRhFayZua/+TutTmM2/BIxmVSiTb/tQBx7wQei3UnUfo2XIQU6oCBgZ2fDCVf3XZKm73TSYLPa/d8ffzUhjqhTymVjQk/egwYRkFBGr8L5/TNJGkYBHJxXJGomUKxcps8kVRTVkfEzC7RnP3LsDG8cEZU/txi07pGClJOyw8F9hx40jatoN9zhxUrb8OqXr15RbR+6J2wgQ9P4LZJxBsNyxco2rLbDlG+s1sdab1c4twNU+Bl0ApkbY8Kmplu7xA1GG0tDWbTtrQnEKiwz2JWp3uWDMts5ID24m13TiHc7vGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Any local user can bypass memory.max with mbind() on a tmpfs file, and
> allocate unbounded kernel memory.
> 
> mbind() sets a NUMA memory policy for a range of a mapping. If the
> mapping is of a shmem and friends, the kernel also stores the policy on
> the inode, in a tree with one entry per range of the file.
> 
> Each mbind() on a single page of a mapping can add one shared policy node
> (struct sp_node) and one struct mempolicy to that tree. They outlive the
> mapping and stay around until the inode is destroyed. The tree is not
> bounded by the file size, so the file can be empty.
> 
> Memory that user space can allocate must be charged to a memory cgroup. A
> slab cache does that for all of its objects if it is created with
> SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
> structs without SLAB_ACCOUNT, so they are not charged to any cgroup.
> 
> Reproduced with mbind() on single pages of an empty tmpfs file, from a
> cgroup with memory.max=8M: the global OOM killer killed tasks owned by
> root, and the machine panicked.
> 
> Fix this by creating both caches with SLAB_ACCOUNT. This change implies
> that mbind() can now fail when running into memcg limits. Further,
> the policy_cache also serves task and VMA policies, so they are
> similarly accounted now.
> 
> Note that per-file limits are not really helpful, as the user could
> simply use many files; having limits per user is tricky as well.
> 
> Fix generated by an LLM and submitted by Chris Mason in private.
> 
> Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: smaller description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

