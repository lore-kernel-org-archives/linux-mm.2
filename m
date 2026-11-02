Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8778D606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nGRjMej1
Received: by kanga.kvack.org (Postfix)
	id 8A2C56B00EF; Mon,  2 Nov 2026 02:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853C46B05B1; Mon,  2 Nov 2026 02:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C7B6B05B2; Mon,  2 Nov 2026 02:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 452E06B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:25:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FD1FA8A1B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:27 +0000 (UTC)
X-FDA: 85389343494.15.7EED131
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69C97A0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nGRjMej1;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793604325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpzobxBA97ERHDZ10JHwpxS0fLfapgQK42Ay+O68OEA=;
	b=6NPrBRa+4aGLKZBBR3v3vPr03+GHXb98paZTzKGWiG7eIbdKvzuMCn2UwL/mZUTy2gRNow
	9S0ZSwnNIKz7Kjl9vcPzrj0GCrzpMTAM1ci/PHLVNUqYhhRBaeYQ+kYAjQWGaJGpYZroXR
	C0jL8/3wfY3zWwcssnz6jxeFw09pGHE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nGRjMej1;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793604325;
	b=DFpIFyTJdT/Q7Vhsgm/b9v80Vg40uMPZ76p7w3ovRrWK8BQe768e3/gIZgLin5T23SvRzv
	1kXi5NqLS8CAOjohe1R33vY4JfwV7eL1gDVkRBRI23/291XmTZCygPQirm28HcsicVO2UN
	uKE6mwjYa9WLlHW5TTdyl0vAdlJxfhQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793604319; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FpzobxBA97ERHDZ10JHwpxS0fLfapgQK42Ay+O68OEA=;
	b=nGRjMej1VDjnviom9WxFvndQXutI4zAe7Kodx32ER39v/tArfi7sxKcpniFiQkS+zhEguCk0pc35Fobq3y5pwrl+Y4YZHpzpDr9AtWUHx5IDRUGognlcBYE5qYA/JqANrXhssR2EGLCcjuf376b+0PeKGHUUFNZ6ZXLDacgTlJU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=66;SR=0;TI=SMTPD_---0XDv5rjy_1793604311;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDv5rjy_1793604311 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 15:25:13 +0800
Message-ID: <17e9d4c6-6ea4-4c3f-986f-a3775c591da3@linux.alibaba.com>
Date: Mon, 2 Nov 2026 15:25:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/47] mm/khugepaged: preserve dirty bits when
 collapsing PTE-mapped THPs
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-17-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-17-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 69C97A0005
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: aoo14neipy743t73di17cthw5hmffz47
X-HE-Tag: 1793604322-973320
X-HE-Meta: U2FsdGVkX19xEYeFezbk1jeXMNnyrFr38SAKz0oGiJhe3OWtqDushZzc1ER+vn7x9APWmXcnw7WvWhzhW2XKuW+htj8A25hitQy4OAhxFUaVn3TetohviOpsZzMkMc57B6FC61C/XyYM2vYqDz8+pb5Bv/1z88qaju7xLydr9DfPd4UpNvkNbqv0g4QvhLld6Fsa2ClrE6LMRewuCJf29gZulrR6FVGs+JDi8FqyIGf33bLICCvqGy/fqGLRnpVw0c8RyfmddRJ+9xed2erU+8oJSbkYvbXskKATWr0MsE1rAaP5Nr3DZgbC5ixjeD7qn6t4/Ens/GpkuU/xC2a3JBMBdQoDn1snfkZfWtf1n22NmjHLKB+LLRJZf8gm+ZFYCeIcm5FgFSWzTFzm46EfgIaU6BQNxWTArAgioTPqE2BnUfvQh2y0xBkDHc4TaanldAS5iKYWeunFcNBVcRW+mqFJsg99Euz7lBbdiLseYuJ5s84VDZ86KzJO2Lc3MhDmcpV+yhZxd1cBSMLQLO9cB3MhMxpMULkWxWco9XuldUqMLNk7M//RBCn7IevhMFUlreHDskL8kiLwCn5oVXC0K2I0hZ+t8zJEwLS9L15F6jjnw/+ZTycspNGFDn5DwcH+Maxsx6s8SXFI4pJK0p1mVg9S+c9Vl5KtaPd3udxPqlOplp0F3sHl+oE87AJtnow9NhmnYLLO/6IX1A6W4p8JvfeyIgqC3VWAOVWwe9TbwL1lQ2PsL7x1nxJC8pQN354gGGbXNme99ClF5uP99jH3NeWn7evyC87o0Tkciu0YQoN8+Znyk34PvoPq/1CgqXV9ET++bTp+eCEKQklBHxT1bM6RElvT9D3g0cf2g9eHD1FKUtcZCluWckVVguXuXFF5GovP/EbeJ7vglHRnBoeG3Hx8ZgBeveu9TfkPiv54jWBfVQbhwH0rjxMIqSL0Yuy40BDSk8KRooZRHpND1RE
 L+zpeUI0
 0CI+NW1wYVJ8hTPj92yxzFNUvC6O/uev7eBZYJZwpnph+z1U+TXKvNbI3BX882C6OUdgHp2l3TXuZA+wiLwG6eAkF4mU759LHMby9aFjeqk5Uqxy6epzL6o57CXkxtagl3DguPAUSKKaE338Oae6J06RVH2HYllFIoC6p/YEDvqCK+WUWi+VsttQjrYUEaPX1TRpJ823c1GxOSyIXu+PYPUABTdH/04ZNuOd6FcPzTluR8BaoTkqZJAWdRCxftnrGvB05ofU4BXdehc5Wp4P+PF95HXSCgc8BWz6enAQsRcWCmudsRXwEp7041blknZCm2Bgh3on7ResEQXhZoeezRBVS96tnhIg0a2/MBXe3Owt0LG8jf6nJl7IhDWSj9VF1iSPfKjbspw87DFE5kDSAk+mEhOjWB45PNWk5i0mNiE8AXs7Q4iey/YL8HL8WopulOBX2RM+L16aX6jiDjXd9NvRCnFsjo8rG4ycgpA0bD0neVkrMONhi004p1/04qrWPMf+MOGnT0gdjduw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> try_collapse_pte_mapped_thp() clears PTEs without transferring their dirty
> bits to the folio. A shmem read fault can map a clean folio writable, so
> a later store only dirties the PTE. Losing that dirty bit allows reclaim
> to discard modified data.
> 
> The assumption that regular files are read-only is also obsolete since
> commit 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse
> for writable files"). In any case, transferring PTE dirty bits to the folio
> when removing mappings (and while the folio is still mapped) is the right
> thing to do.
> 
> Use get_and_clear_ptes() to collect the dirty bits and mark the folio
> dirty before unmapping it. Update the comment.
> 
> This was reproduced with shmem using MADV_COLLAPSE followed by
> MADV_PAGEOUT.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
> Fixes: 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: adjust comment; simplify description; cover file-thp as well ]
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

