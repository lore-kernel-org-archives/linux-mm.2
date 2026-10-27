Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4466606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c65rOCZf
Received: by kanga.kvack.org (Postfix)
	id A18096B05B7; Mon, 26 Oct 2026 23:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C84E6B05C5; Mon, 26 Oct 2026 23:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B73B6B05D3; Mon, 26 Oct 2026 23:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 675476B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:05:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0A311208EB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:05:36 +0000 (UTC)
X-FDA: 85366915872.06.FE3600D
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5D8451C0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:05:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c65rOCZf;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793070335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2fYp0D+kux7GkOrzGv4DxJUQ1pHehCh6wWsm9VP8mw=;
	b=nrrXAlFrXLNTxcng5rKOqWpdLmbgUxNTgf0LNHCTCSbHqu+PUt6UHVhCWJY0lUv/gIX0tv
	rFXorxXIfE1MpULCwupNT2GN+oIs+kEUch4rb5rWnhyi2zgmCNJKu2dmjbZhDvxAYzI3vN
	iwQ9f8QZrAV+j/5Q13hoRlbHTE1RBZ4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c65rOCZf;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793070335;
	b=mQQvk8QO6iBKNONVCV9fZAANHLklnK+z1wFlV4VxKOmr5s1i6x/yoY3peWSVT4Vl2fIyHs
	OkcZcTEUKzcHr9hff8ufGFaUsIa/3d6b3bbo4ItWvV5miY/IIIS+do9dLldiJUfnthInFA
	AekZrVRG/WvTBFt7IaTKlmqpF4cNsIc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PpgTbepyGCQbdry0Tl9jwBnnjb4CaWXJ3ss5elRPGCc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793070330; v=1; x=1793675130;
 b=c65rOCZf1Vlq0GQPAQmQqm5wf83ltLhRtUxYonNAqk4jRy4mWveQ6FYHE0z2KgSx0vBBuhwh
 I5BSaMM8kbNm5zMj9kh6fIQDiuHKd5Weox4bLMD3rtVDFQIbo7eTm65U5091811U3kGr9K6AGAx
 2ioEyZte5hznqL0+wFow5F8A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9170fb527649b4ac;
	Tue, 27 Oct 2026 03:05:20 +0000
X-Mizu-Trace-ID: 9170fb527649b4ac
X-Migadu-Flow: FLOW_OUT
Message-ID: <62dfb28c-1078-440e-ba23-9068f4958570@linux.dev>
Date: Tue, 27 Oct 2026 11:05:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
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
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D8451C0002
X-Stat-Signature: juumxzgin68h8zq1ojzhu6b75hxo1uwx
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793070333-259194
X-HE-Meta: U2FsdGVkX1/fp4878hagdAJ0IqCPz6ySdYoynvcPE/KJ2EGH8CebdBXTn4A65uv2WGpAeNoqdnQyS77FGWOywOm3XnUvRliMNHifEXWvYOL283f2MvbGA7VKJ5XNMX9ItSYLqleabBKhISN9XafrNXTa3lCxboqTNppDROkP2OEMLiazxMQjzIBlK+EZYw3AWx2bUXPr20HXavF8SVQ5M9gd2erzPXI5gmFc8TuWdwSGizd0FD2or8fObOZ2d2z7qq6idd03U22N2CyHrtXgRQ8sWmAbX7Sy0QU0UQgeFxGckpzOOWnZxPtb9BsmYQnnXe12yhN2gguQrzLgHnrz5HIOBUYIlm0+bQ4zv1iXC4bM5PFnTt9UCnxujGl1VBRr84XQqOtH2DNLMU4vf8C7ngTrCbIiJlwllayFMe6Jv3GRX5xvE716hXVCPP90ZIgQBtT0xp0R/d0FEY9fbM4Vsn+G2Mb5FAJ0n/Rji2V5VxAoLIzo/yXdAAG0UkKvyb5AGYWoosyV/Ija326iLcbfrOQ3V6s3VGsFJ9h3SV6wpVjptcA8d76o5EcMEyv0O6/Iefm6Nrcedoti2TzzuqLITfDIHKSpn/LpvEiTwpXtzG5hFkyr5oVmjrLscPOrelt4QyPg4jZ/g8Md5CObwfOH20x9+I6ejOJSK0JkM2+3FzorIeJC8fJq5LKVPncXAeX9QyjnehB3NFKocV3O9uqqQAP2QfYTY/SuEtOxyuVIRI95Mu+vYmCWKyfzfNi2piZ7bEMfhKvxob7ftF2f1Nm+Se+riqlQSosIF+vDs77MeimdZmEPKyWXhEWbjPl76VMWuBkR/m9iuq4yGM/oa7/XA68pF3AdGq5gVmjVM6gfBnW+pbpGMoEf9k3DD3F76E7VT5W+zExciFJQamQ41cgOOXowUNmx1v0hgs3oXniGC4QRxTF5ly/r/Y3TtHR+FVjjyRctDImeRR2G8gwWx5X
 SckppSdc
 y0QwJsCEbT6SKi6G65/hfkionws53QqR0rDpyc2O+RksYT7tz+2B2Y2tMt4xjy5egFWpivu/K5P2JGF5hpiq+UP+RT+wQGcIXe1/Zv5mDKvxHH6CZ/FgrPSfbAtKbVh//FfweyaEd7IgcIdzdExIEIwm8QI+t9nImUFlb9SpmQkK4f+asBLG6mznVQm0PqCBE7nmrhQjv5tXSLJwMkTOpLl36fhb2csCO4HB0kbcAdClfu88igoOnLUSP8dJDLJzcxqmeugh5WbYyw6H1Cv5ImKzDFb1olAxYwV03arsk5FdOz03uRi3zVmqEWnvXAwMSCjPseuHzKgaQ5v7mX7KTl+EC4GpCtENjJ7vO4aoyhBWvJfhk6aOccuHobdzc93B2TqJKRkRaQSf9qK8qBtELhayRl2y0i/laxES11yhPw4VzU/ZGTIGQ2T5h3Q==
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
>   mm/vmscan.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


