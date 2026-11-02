Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC868606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GJ1by412
Received: by kanga.kvack.org (Postfix)
	id E2C776B05B2; Mon,  2 Nov 2026 01:08:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC756B05B8; Mon,  2 Nov 2026 01:08:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4656B05B9; Mon,  2 Nov 2026 01:08:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6D9B6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:08:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 215AD40C4E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:08:26 +0000 (UTC)
X-FDA: 85389149412.17.7F5C5E5
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9925220003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:08:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GJ1by412;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793599702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBHoVDgYosEEjwFENvnqm8RfVk+ydgr5qWMoLpA4mck=;
	b=ITUBa/LOi4hEClzV3gGCT2ktPX3Dw+cq/PZIZHoBEf17g6Zrs4GsDHB8/TqxszZb1JCBe/
	ihmxEW8BTckFLVT/QPO44/dNf66Noi43wKU3JZIDPHrSD2KZSUSWbvCE5liAv3PbhRyk5n
	vfur3NjFJASos7dnHZGvDEGy+MQyx30=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GJ1by412;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793599702;
	b=b3wut/yqqZbIePGAcdZULOvPiO+GGtLJYw181x+1+pK+ulpgD8z4WTQ8AVBO1/heabgV97
	BdqCq7duQM4OmuSAdUmHVvvZCJZ8+0RsGBISP5Wtc6kDAJWw2cxnMFgfoUCCA1/C5DnpA+
	AoqkgYZ3+gpiq4vyZdUvjeq4uX9u3vk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793599698; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hBHoVDgYosEEjwFENvnqm8RfVk+ydgr5qWMoLpA4mck=;
	b=GJ1by412moRZ6W4++R7MQlnF8bfdOd5lXuKNlwjM4rOoHQ7ujW9WzOulGfOAuZ5p9qjZp9m8wJ2NOJJK/vil+aNodwGljl3Bou6qSff38F1hhM0aSJS53jpA14O7/n4QNuTe8dJbZHN5PHACs32okRyLYFrjsChh9Emt6TWwAhw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=66;SR=0;TI=SMTPD_---0XDuTEnB_1793599690;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDuTEnB_1793599690 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 14:08:12 +0800
Message-ID: <dda009fe-abda-4745-810c-da02d8440b3c@linux.alibaba.com>
Date: Mon, 2 Nov 2026 14:08:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/47] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-9-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-9-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9925220003
X-Stat-Signature: gebaz15jiusqzr11xwhyj9byewmkd1ee
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793599702-808965
X-HE-Meta: U2FsdGVkX1/35LNuV/hBoq0YPEViBw+5LJKRAlTShIZZYHIE2HufpTD5MNFTah4oJz9/ZDNUKMDZ2mM6MARPRcWmpu0Ja9OIzAzR1HGQFZF9spUfoa+EpwvFi8o4FzIHV/nNAVIu6VPMECk2nCqfskLBayCYJ/jJ4kJEfNc6ec6qJDx6Dpq6LhBvLL7LkXfV1P+uOYXZt4D+s5nLN49xOpXZStcV08J0jbEQtMwPcJ6wKaiXBUD6T4yTHtG3TQI52I5GItV7BWBWf5Mzt+fVsBqGKEDFCVpfrcp/SuEfKRlhX3iH3kQm/cnZ2kaNg1OBIcGc0gI9RJ38/38hbHkMjdBKdPcBm/CNhxdn2dXfTbF7JstXNXhnsW+f0dol7ZBsb7s8IXM9ky986n7vYqAsAFohmMH4ibDxb4273mCweoto2GC/KKooKqGwSYt27bqLgX4NixgC6x+FD4LWMLOqo0iv+6JWlxl4OND8X9bqeQjDW36cFKtz8m2HrP5iiqKreACOduWGF5VfYF//A8A+nX69eS8VjwtfIURSkLI1RucPcAbteDjeKi0TBbQeoapynl2zGvjWQnm8L+15F1k8m0yCue9xFj9Zf03tk8EBnsuPAXX5l6tlrs2dxCDnMLtk6go/UORTw0TZM8o30TKzbZiAwPZ9TgkUbmPFjGdb7vccyDkYMNmp/wEpwZNjYRIE4Dw/NFz/2x3GC4W8t7rdz1gwAkE0R0rjVxniVAo4MiuXph2vQ4BXRvvQB4JvrKCiQSovWkRsp6RI7FicOCLx0Ucujb1eExV5V7BnzAxS3MpvxR+EZ3T1OPnHYJlI4ldwbL4Lt31vXPuSb6TVcG/0WniiVDtKILbsAzohGUhNcw1JbkUS7tTpiEp2NHNNvdJaNqztZf6YGdkL4Dw2jHJeZvUNDcIOHvxeLAq2m709YoBvdzVGdfRSVpjHX17PvMIiByzbMsLH2IfxYPfjeFn
 TXcpJ5bg
 fegPlxh3Pmi7fbSb32RYf43e8qDSvZ9O/S6nbUuuWZhaQKbe+ig1uXTzFa8U579isi/cdKEF3UjEtKr2Ixbh/Gadqa7QaiL5bpF1mQoxvv/x1AeHU866FYJdaLcEu2GLUQP6Z6QMo3Q0862c/QLXZRgZ0usMkzaOxgEyvfyrkxnV2pSl5mk2G8faGnUOWITxtXQ6LLgAltozTqYD61xvbt+KzS8PgZG/0ilTh3J95/Z07+s6R3ZwZqRUCiRtfSjElE3H4F6hABQ3pZbvfg9bj6VczP7q2Lr0/b5Ya6/7F0bpaZT4s2ysFok4vxq7ldS3ETcNMdsTEil4x00Z3CvJc7qIQf325a0+QLmRBpLvBX5M6cQ5sEoyh+8xkBsV7Ejsd6GoUMiIqoNqRTCA+HIkemPs5KONwOMwOowtQTKXmVwbs3s3bxGhd9JTm4l7OYdDszElBNeDN98BFSCoRflE/aYLBusBNPuKD4c0wSqcP3QUcFXPKiKmqRAdb/gWAWi8NoL1qdgFOE631LBwPRZnfCht8FokzOgl16CteetQrugBymDEdf1FZfVwM/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
> page_vma_mapped_walk() can return non-present device-exclusive entries,
> but folio_referenced_one() passes them to PTE young-bit accessors that
> require present PTEs.
> 
> We must neither call clear_flush_young_ptes_notify() nor
> folio_pte_batch() with non-present entries. For example, clearing the
> young bit on non-present PTEs can corrupt the entry: on arm64
> PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
> entry into an ordinary swap entry.
> 
> folio_pte_batch() will VM_WARN_ON_FOLIO.
> 
> Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
> treat these entries as old from the CPU's perspective and obtain their
> young state through the MMU notifier.
> 
> Skip PTE batching and MGLRU look-around for non-present entries, and
> don't modify non-present PTEs.
> 
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

