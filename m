Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DB0606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HEX1DhI/
Received: by kanga.kvack.org (Postfix)
	id 7C2096B05C8; Thu, 29 Oct 2026 11:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772446B05CB; Thu, 29 Oct 2026 11:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639F06B05CC; Thu, 29 Oct 2026 11:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9476B05C8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:40:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCD981C3B5F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:40:24 +0000 (UTC)
X-FDA: 85376075568.28.1696123
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 001FB18000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:40:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HEX1DhI/";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793288423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYZCc2lNTUYj2t2pu6YWJRD5XfL+7XVbwTmCwIjHH9M=;
	b=HD3lxGSybWhqbOy131rG5fhaChH9dPjRpalViDSZ9TSRSCw/4/lJM1QRjPvbTeCSIDlR1u
	3qAmI8d3RM32W0yC9u1DFI+KulT4mde8+nNPgJv+BqAcC2mjWEczHV1CAvWWQqusP38clF
	ZRqQG217d5KFq11+Yd0EddI4/OMoT28=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HEX1DhI/";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793288423;
	b=ZK6GeCdwZRIhHLkNXfDzFQ5Mjzlt7RSUGSdFHlK0mo48yL/C9OyUufvC84lLJfc3rK6V0w
	odte43K/bWBOZDZL7mb/lK2TaEp6qE+UetPUQMxNM36qDiM7/CejjggcESiT+sI3+poF49
	4vt/dF1l8bUPFhxfXoE5aDN6fGHLY9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0302A40AE6;
	Thu, 29 Oct 2026 15:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499621F01825;
	Thu, 29 Oct 2026 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793288421;
	bh=dYZCc2lNTUYj2t2pu6YWJRD5XfL+7XVbwTmCwIjHH9M=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=HEX1DhI/2X9DdajitxhgBddyoyv6FilOfCQpBtJ2ki6f9+zZe3m32dX/laOZm+NZo
	 3+VL/GiUGc80vUKeQiNpy6rLscll7ooEz/oJamgMcs95z6H+FVJQg+52LWBiQT1ZCx
	 B9pxDJe4nQgtjxOWTILlUSTrEi2JyqBWO1I7gYZgjRXXO4yRuTE8lvOm+XgdNCMIDE
	 eb3G/knwjTXKSL2d4wyVlA0FBRRSDCVk8B2OABs84uw416YI5ZzgLVFhsSp4M7PYYh
	 yvucyVCRSRnO1+W+WGDTO/DlXwK9M4Gd0oL8Iez7I1bLu5UTiPlfESH9LjxdMY4Zdz
	 hoQaZEWRjMyTQ==
Message-ID: <e796dace-06c6-43b8-83f0-594e7f1e7380@kernel.org>
Date: Thu, 29 Oct 2026 16:35:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 42/46] mm/huge_memory: split huge PUDs when adjusting VMA
 boundaries
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-42-6f74bec9a5bb@kernel.org>
 <auMxQPze5cOvGbCe@thinkstation>
 <9f4128a4-85fc-4f4b-ac41-b9d348f56e37@kernel.org>
 <auNYPPlCnLdN88t_@thinkstation>
 <d5d077fe-4695-453a-a2cd-40ef30abd61d@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d5d077fe-4695-453a-a2cd-40ef30abd61d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 001FB18000A
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: eou19phuq9noijut8f7rnpth1gmh3wmx
X-HE-Tag: 1793288422-575036
X-HE-Meta: U2FsdGVkX18C44XAKIQelXiuzREnX+7o3KVzE+tegnPWebWWiJZ6TeL5OT0lZKHvFBU0Fu9OglX1UmCa4cDg281YCOuskQcwnrGrpJtdSsqowf9sjCIBBqWYEiexLMEeHpxd72EPO23RODLdbn/4Tk09echoGVW0NDi/ilTL2yzf7Ifr/oX3SMooOp7l1DLMaftnJ8LmnMNBQ2JySLWTUnFD8+cYeYwyZ3q3x5oPDOjLMVLyjvFmRPm7zfEuj0TCc4cG7O/Am7nmfjbn5XsXOVvGHOTieuLI2jbPcMugiJI/GCj7NEveaCVlmHIqEwN/lnkXw6GMJt9EfXrjK8ITraczgfmWnUrFClsl21wffGRjbfH0wwS9QFQsNavERilEofGAn8BYGPHvD2qzZhjOmIC9Tj781hhUXOa72zo9jtpOc0EyOTLqzHtYk+ZcGY3PzABZIeWgF3Wgk82FqXkyhOsdkYuaofo3CGRfxtLsh3KPPLl1SYX0Rco1T+PjXyhG3sd3S66ntPiKo4iETR9/AWmyUPV6kGgUBi8LJu3tchZd6/k/oGcASwpiH+gNR5nAH5o5JL4vqpQkLOjU60bVdEkSIHO9B9PK5corZugE8iDcH/9RCQFBNhRfxP/8Bb0VWrmo9AKE/ZjR63A2ghifjT/6HRwnq4BdZl05tUv4N0mqc+ycbTzSmLclZpv8spCsdANK+FLOx9lW40LC13WEzHqBVxka5ZtgwZ+3P7urQf0Lp2Vwz2p+AWqk/zxKJcLEdfnbuj1ftGErEafJVzvJUEPCz3ZX6Bn1Jg/yvcoLevFFuAicn/U5/L+65wH+Et5h0DWEMjB0TTAU5GJuJdOLodg/B1TSRq4rjAaTdI0RTKuO7iCttV460VYiL1rB8tm26JqPRqX/5VcKi+oBoh/4UuqwgtXtvC8d4JrgGzFN2HGxOCPz+Tfxq592EJdz4jl+0iIO9jqNptkOGAArhm9
 ZNPXY10j
 Yzj6kmqy2wuqrwnA/kkdBNnGuPLeXx09dy7GiBQUqW72qXCoyRcIZHjpaN2F3FxBiQz7ivO0xEwQ228MsXFAByqEW8XF14SddS3chQWsEcJkmeWcBN3VZC26tlLq4CPWLj2GZwvLcu2da07HnTTuAyxLYTTmjw7Vhd+pDqqJpxflDda9GjbeeQTbg2eRw2pDUYWQLz+l1Rf4xLdQ/Jl/C9qfgBERMdUgQ3jDcgf97DLQ9jFzM9++PZF75lB6NR5h+qC9G1n8PKhlG4projg6+LFt5pH5w7jOk2XnGjVeoexlMU+RgZeYiljch47ENb7/JYLVDb3yy+QWFRgdHZ6SA9FgfBmOv4eCsQcAWgkn8jAE9nWl4w1+1/iXzXWXbCYYf9tcb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 15:40, David Hildenbrand (Arm) wrote:
> On 10/29/26 15:31, Kiryl Shutsemau wrote:
>> On Thu, Oct 29, 2026 at 03:24:29PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> __split_huge_pud() must split a leave. Either by zapping it (what we do right
>>> now) or by populating page tables (as in Usama's PoC).
>>
>> No, meant the situation when pud_leaf() is true, but split_pud is false,
>> so __split_huge_pud() is never hit. pud_present() is true so we proceed
>> to pmd_offset()
> 
> Oh, yeah, I can add a WARN_ON_ONCE() for that, it would be a bug in the software.

Ah, or I can just drop the split_pud check. Let me do that.

+static void split_huge_leaf(struct vm_area_struct *vma,
+               unsigned long address)
+{
+       const bool split_pud = pud_split_required(vma, address);
+       const bool split_pmd = pmd_split_required(vma, address);
+       pgd_t *pgd;
+       p4d_t *p4d;
+       pud_t *pud;
+       pmd_t *pmd;
+
+       /*
+        * mmap, VMA and rmap write locks protect the walk; the split helpers
+        * take the page table locks.
+        */
+       if (!split_pud && !split_pmd)
+               return;
+
+       pgd = pgd_offset(vma->vm_mm, address);
+       if (!pgd_present(*pgd))
+               return;
+
+       p4d = p4d_offset(pgd, address);
+       if (!p4d_present(*p4d))
+               return;
+
+       pud = pud_offset(p4d, address);
+       if (pud_leaf(*pud))
+               __split_huge_pud(vma, pud, address);
+       if (!split_pmd || !pud_present(*pud))
+               return;
+
+       pmd = pmd_offset(pud, address);
+       __split_huge_pmd(vma, pmd, address, false);
 }

-- 
Cheers,

David

