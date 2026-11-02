Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62461606A33C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=V1EM6m4s
Received: by kanga.kvack.org (Postfix)
	id 57BFF6B05B4; Mon,  2 Nov 2026 02:57:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553B36B05B6; Mon,  2 Nov 2026 02:57:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442E46B05B7; Mon,  2 Nov 2026 02:57:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13AA46B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:57:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FBEB40C8A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:57:45 +0000 (UTC)
X-FDA: 85389424890.22.2C01774
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9D36520008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:57:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V1EM6m4s;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793606263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urqOGiWM43pGOIAX+SQ1xyGmHp8O9dptxy/AFX4SmjE=;
	b=FfgcTXYrUb8ukcfAOTMN/hgH7RXXgsBSdLBhVE11nrr6kCzEYbE/sMqsROFef++f1e0Com
	gEanhMRwAPW2sxoaVoiM9ALXBfEoVOw2s7osmwSyJx+RJOeo+6DUsMHyuS9N4r0uLaEZDc
	DqrSX/IQwRHqRD6Ku0MtwVbpZWA9/gY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V1EM6m4s;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793606263;
	b=QzlvYIjNskw8H4NmoT0nba57dWKQqwG/dmH1GbkEqR4JwDC7jr3vkBNR7Ajx3VzIsnvnt+
	NMHVeShz5ZaM+G7qMLtNZKFiXDi+PjHFKenySVYXrl+0kzXIlKZArgUS7AkRm0+DT04u/M
	1DNiSbrqaAFTWjTy2RXtiRzTc1Nph5c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793606257; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=urqOGiWM43pGOIAX+SQ1xyGmHp8O9dptxy/AFX4SmjE=;
	b=V1EM6m4scoqX75j2za+JXFx2Ku5Nj/07cP9clvy39Dvxz3cRD3ZM/bgTG1z72CTZwmfh1LdEflXKr63H6ibxYHx7BFaItm+5ki2bHhVSXGJDvD7X3QWqi3Xko7qVtm/TgHewQycVYudFAa6IbTELTiFs8nbYgx1kSigeiHejiEg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=66;SR=0;TI=SMTPD_---0XDwJ4wk_1793606252;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDwJ4wk_1793606252 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 15:57:34 +0800
Message-ID: <902b1dd5-f002-4ba8-b6d7-6bf59d07f1d7@linux.alibaba.com>
Date: Mon, 2 Nov 2026 15:57:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/47] mm/huge_memory: fix truncate racing with PMD
 zapping
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
 <20261031-fixes_core-v3-13-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-13-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D36520008
X-Rspam-User: 
X-Stat-Signature: bzpjbymn6cg4e9gcn9jeyxgmf36gnrdm
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793606261-260140
X-HE-Meta: U2FsdGVkX19kYhNHzfmRzmMEFvrS0bkYQgpR76uKUvXh9aNCmS+K65Sh+C+iZlpoA9rqnDbPQQCNxBq9rrJB/2RxKPHR4fE5Ztwp0K9Ytc+r2p2oP+SVI9X8ihxsRCLl/Gwd4ctp0Vce+aiSTrWpu6D9U2LC+au7x9PHfdGkNUSoBrqJJETX2ZmFJZxYWa/G0Ypn7i/nVviGbfXq6TrnkAVrQnWgGrKLsC6MztnLu9NLlQDvKqn4ZuKPw4Fvx2n+g62PUk9iWG4ALdTxiD3RjPK8POKINGRlnKnj54r0p8gUs981emtYDn+UGQmHBHt4ZG7a0Z1GUYcLfc4Dh1nGWw45sLl3IIPNRTA2Z59IDZavng4vkiszDNkA4G6ieF1YyvG62EY0K/wHuyloqfntvOKPZss+Kv6XhL4RIGbEfsJlcrLfz2vbTMBlWt0tRX94NqkFbHB5zEwsZNZEy3HrDhBBhpTujxjdnlb0TI5Oh5ned0brvG3BaVelCH0wzfcSCIPc0YqsFNjZIdkQprv22EPJxkYPnvVt/w1xttwEBQzl8/Ix9eYpvOyXp0sy+mQ9YjEiAZv3wtVgKVjP9sxkM90C7+p9r5J2zHKbcI2XMCoMflm7dUA49aR02yot+7RD2Yp54oKAyGtbd+MpcnwHr7MYtJU1FBd/B37CD92YFILyoT2RcMZv/4v0XDq/KQxIXwcUQEDfR+sPvVoMFf2NHCXSbAQb6k0ze+EGNIP3EQwHkXzOj/1dH/bqyJ/aqodKA1/iaH/WxDKvr29lrn2a2ejk3Lb8/S1RIMfWy3vG57slxLReEjTqM9f4HhViqB8F6EIIaYf9ML2Rwe9eqnvaRBU7jj9UbeTLO5wGFqx+YMyJxEl/T0tqq6Sie+/e4IXjbykqy2wGYxd2NtunhQmtZpz2NsIRVDs2YwHWXGB9wWmO2CnaQlBalNTnHkmcLOg712oC+AJ8c6o1z9U2L9t
 I1tct1Wv
 SN4XIc96Z2ehr7Wt+l70uIEdOi1F0P82imi3GVCv3mEUKWclH2WdLW5Frx1SkFFd8s7chiG+CJc2Oq9rIMJ4GluYVbG8ovlXNWubdRfWtWAs4orJKvnYCwHArFAbILd+hu7FnO0obIRMnVjx+et/ua2a2WnuhmhGdMIqjbWqEY9/dtcpwTkHlYQwkbV0Qt+4Yq8reMsFghDgjv8PGRBG/7LVbcGyO4DYFJQ7P57Qohg55ZfyXYsNsFqibRRMkDppWVyEnFSScMW7MYIOMv05jk8cHk+hlKAOp6HVT1r4g5prpTrcvFkr/vNMDaEFtt/0igOhFdJlZyLufSLMhUH4MzLHpGI3rxjh6gBgWt+JoxVOexaaKYkNNoQBSG0sP14IKoGv5zqrizFUIjasxeE1aR1I/H1rK/Mx1pwawD2S5XMJgDphFwzcYlPj7RdZUDc7+IaJbt7U1UnVbKZtwMuXVaD0jcqbsTYXF5a2fom7Dz7+ajbYvTnrUk9mXWOqI7O03S4OjmCYxX3XvWdmWT2esmGX/4HtKKgj8ZSETrY4t+E5JmQLe6UOamXur1A==
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
> zap_huge_pmd_folio() removes the rmap before calling folio_mark_dirty().
> If this was the last mapping, truncation can skip unmapping the folio
> and proceed without waiting for the PMD lock, racing with dirtying.
> 
> ifs_set_range_dirty() can oops if MADV_DONTNEED races with
> ftruncate() on XFS, when we get the folio set dirty after it was found
> to not be mapped anymore.
> 
> Move folio_mark_dirty() and folio_mark_accessed() before rmap removal,
> matching the PTE zap path. This keeps the folio mapped while updating
> its state, so truncation must wait for the page table lock.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: fe6cf984939d ("mm/huge_memory: transfer the pmd dirty bit to the folio on zap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comment and description ]
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

I checked the memory ordering issues, and it looks like the implicit 
barriers provided by the fully ordered atomic operations already ensure 
the required ordering. So LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

