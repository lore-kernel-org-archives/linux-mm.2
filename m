Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23EC606A33C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EPxw2AhN
Received: by kanga.kvack.org (Postfix)
	id 0D5756B05B0; Thu, 26 Nov 2026 22:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F706B05B1; Thu, 26 Nov 2026 22:33:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68D76B05B2; Thu, 26 Nov 2026 22:33:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 777E86B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:33:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F41FF1201B6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:33:14 +0000 (UTC)
X-FDA: 85479478308.25.96CFD2F
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA847C0007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:33:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EPxw2AhN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795750393;
	b=vWTvQLuw/sTrWH/A4w+qjBKYNpyiPYRP0/i3SSx1XAKO8KQ8/YhJZry8ajxFTV4jZdma0k
	nJsfrr43qmFe7ZeYPfjtgb7YnFtyXdsClViQg6TY22eAr5rlKyuLkjhuINnu1LZIpjWTmR
	XETxVz5qqEem8Qf4F62RLopoHBW7yWo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795750393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvS6PwiM0MwyaI9Q71Y3huXKWpS6mVFDFJuvxq1GyR4=;
	b=re4YvmoNJRkB0R1gKJHJckb2i2qdABB5txBl5sVS3ne24q5F2JXV3uoOiSll8R4oDALswj
	peMsZAM3X+0Lc1hsW3UXrJn/iNajPnGJiEyFEsTa+6iyq9r67fvHgYxk+xWWCcHklgHYOC
	FaoEfJRzxxfsVHCZEhrlKDkbFtGfD7U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EPxw2AhN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QgYTOSCJMTPUU6uzHqdiUg0E/5P+/jUuCCDzWFkkxHg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795750391; v=1; x=1796355191;
 b=EPxw2AhNdbJIC+8feQPq8mhUICuksjI4V0dBiwPN7x1IbnPSR7+Hj5/utFFhJ7FLnY22X1B+
 azJdB37bgmsa0VNTm905Ix9WUPS9TPeBkEEnbJ2DUPGJI46z2T3XuZmye/KVUF462rdMS5Nao9E
 RjvzdiYxCf2zl2ClE4U1NlTc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 83cf2f4b8b8eda50;
	Fri, 27 Nov 2026 03:33:11 +0000
X-Mizu-Trace-ID: 83cf2f4b8b8eda50
X-Migadu-Flow: FLOW_OUT
Message-ID: <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev>
Date: Fri, 27 Nov 2026 11:32:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
 <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
 <awa30hwg6x82REoo@KASONG-MC4>
 <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
 <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
 <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA847C0007
X-Stat-Signature: nryuwoyreua9su6bo1z1e3jtdhnjjicb
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795750392-607980
X-HE-Meta: U2FsdGVkX1/NmZVgOqlQgHbSh2c8nkxCQSmqFVw4c5OxQD54gA0E3PkODG+lM9tGToO0+in1Vgq2ghjk68Qu440GYeBSiDfAm+OD7OKKnuvbJUJvCArVWRBpXJbrTejvSjgeTwc/IX7tfs5LjHNy5/6F0NTQaD+yDB31N7MjG39/ZS2P85wrLM9uU4Zt+QqNW/6ywgkEH87Fi1t498ZYW05iVREdS73L6VyXECtpXCXmLJyMNFfPITlLWOb248Dd/egNL1HvUNSMY1LXP33L4DUlMbnJYiPK/GfVQdEc7BmyB394yEAJEiqY8yETF53iKNUZLauy5JfC7m4ebQrZ+5VhacsLR4QQ+yGz+j4QgKcIaF2Zd3iHsvxt7QxKXvDv5r1r9EO6p3knDgrJaBoN8+9Zvedi3VdFxiSjpb5GX0hbbhf4otXs2B/CXLhDAgDDhvGzzP4A7PoKdXcSEeIevFPoLgVKdOyc5jM1BZNOcU/ZjjvrIDNVS7dMu08isos96CUu+fvof7rK6NSvC5hQ35yMp+87sG1a9VJ2kwsRk55qYoMd0g8nHKaAOdoa+4NaFFS66ER6j77Ie/Hwze6y9ugiZ/VZvofHvW5HIb+58TJ87fhqRMTB3lbgBdyamCzMjtqY9ced6VT4UlCi+r0/9Ejgd+h1cAeNMP1m6rSgdibtD0YFZ+mnjCIGdbch669gIP+ZQNlZCdN/wvjgZkSPVHovm+l9Xfk9etfLYRCYyPvttt/ATEomnngZAoZm8gx1e4PXJMpGFoZ9S2dXxH/T9EdN7hl2UGERVYwiLfRsGu4mw8qmQ73MF9g5mVTq1N8XaNPNQDaordtCzJJkjivvKRIcltkIVYqFolW+ZgnIpmfF/P3WhIDFpCcoHJPzyr/4VBEc6fzvuGQFIXN7RRkIkeR5FvHRta3y3YG/1J4PEGESp/TfhL8HtmvRS29baJG9iM2Ooyx8UmAqR/LzOus
 M9COGYDb
 R/g7nSDUHQTnYtYwmSfrITl7IhRj6lczxXLzSoaucd9aA2duWqIzABkVniyaaxDKrXBRuNJwzbyyGly42qmw8EaIuUZFDYaaWnR7H4fPOcG83a9EDNfI6BdPdf4URlE/T8x73yEvCFj4/7q7tJwoYq+8hzTyN7jZy1AukdFpVfmZJLIJiQL3xx1geRWfnFoQJ0Og+6cKBtv/aJR/np4ShAqxHnyf8IsBKXxgVOY6dyg41LFOwnx9Sg83zhjeaGT4WT3LqGNAl3yqG9OOA209C52LFn8ihBepQD3mJWwddcMYdfnyNINFBx94jYvObarJDwP+L0qSbkxKSL1brTrW1TptWJnCQno4G2cOC+h2/wOihs2g36m0HKLpg+DCmtdccBDtE00IYSZMvmuBLWAAr8QB6CB/Q07CsfWv+cHfGJXX9yhyXtgyVscgfq+4dO7Ygzw3JsdOlKKmOkrEKW+2j+lh1FeWbZFzi1pVBpqBcPjhYavBkutRLnWafzHm1dLDFHHfz5aDEyKhroWX30sseFOMiEHm9Vdc77mM0hmGEpze4957s8D52XvX9eAH804orPB4p9ivIaPcme8j8YGJLt2Jr/wVm8uJ2Niat2xNKCeq34SIRd67Dzpud4As96UYkIyoVuNSzLm6w/4Q+x5GyOdKJ3SNKD+9iUlgiqBCcVgMeFEvpGGa0aoZ7Ix2k5BolJPL/1uoKgoEYfXs4jXiX6mM8gAXy1DOHEGR/DPQvKoIXAakEOcCQ03M2qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/27/2026 10:20 AM, Kairui Song wrote:
> On Fri, Nov 27, 2026 at 10:01 AM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Fri, Nov 27, 2026 at 9:48 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>
>>> On 11/25/2026 8:36 PM, Kairui Song wrote:
>>>>> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
>>>>>> From: Kairui Song<kasong@tencent.com>
>>>>>>
>>>>>> Pure code shuffle, no behavior change.
>>>>>>
>>>>>> Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
>>>>>> Without MGLRU the extra bits are never set, so they are inert. Move the
>>>>>> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
>>>>>> unifying the API for checking folio referenced and workingset status.
>>>>>>
>>>>>> folio_migrate_lru_refs() now migrates the complete refs count,
>>>>>> including PG_workingset (bit 1 of the encoding), bitwise identical to
>>>>>> the direct copy dropped from folio_migrate_flags().
>>>>>>
>>>>>> lru_set_refs_flags() skips the nonexistent mask bits when
>>>>>> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
>>>>>> !CONFIG_LRU_GEN builds.
>>>>>>
>>>>>> Tested-by: Zhao Zhenzhuo<zhaozhengzhuo@uniontech.com>
>>>>>> Reviewed-by: Kunwu Chan<kunwu.chan@gmail.com>
>>>>>> Tested-by: Andrew Morton<akpm@linux-foundation.org>
>>>>>> Signed-off-by: Kairui Song<kasong@tencent.com>
>>>>>> ---
>>>>>>    include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
>>>>> I'm starting to feel like all of these mglru/reclaim thingies should go into a
>>>>> dedicated helper.
>>>> Hi David
>>>>
>>>> I saw your comment on other patches too, about the header mm_inline.h,
>>>> about ~690 / 860 lines of code in it is for MGLRU / CLRU only. The
>>>> rest ~200 are for VMA / TLB / MMU.
>>>>
>>>>> Can you do that as a prio cleanup in this series, so we don't have to mess with
>>>>> mm_inline.h in later patches anymore?
>>>> Perhaps we can instead move the non LRU helpers in it?
>>>> These helpers:
>>>>
>>>>     - anon_vma_name_get
>>>>     - anon_vma_name_put
>>>>     - anon_vma_name_reuse
>>>>     - dup_anon_vma_name
>>>>     - free_anon_vma_name
>>>>     - anon_vma_name_eq
>>>>     - pfnmap_track_ctx_release
>>>>     - init_tlb_flush_pending
>>>>     - inc_tlb_flush_pending
>>>>     - dec_tlb_flush_pending
>>>>     - mm_tlb_flush_pending
>>>>     - mm_tlb_flush_nested
>>>>     - copy_pte_marker
>>>>     - num_pages_contiguous
>>>>
>>>> All other helper in mm_inline.h are for LRU. So we rename mm_inline.h
>>>> to mm_lru.h?
>>>
>>> Moving the VMA/TLB helpers out looks good to me as a first step.
>>>
>>> For the LRU part, there is already mm/vmscan.h, added by "mm/vmscan:
>>> move struct scan_control to a dedicated header" in mm-new. Most LRU
>>> helpers are only used inside mm/, e.g. lruvec_add_folio(),
>>> lruvec_add_folio_tail(), lru_gen_add_folio() and the refs encoding
>>> helpers, so they could move there instead of staying in a public
>>> header. Barry also suggested moving lruvec_add_folio() and friends
>>> to mm/vmscan.h in another thread.
>>>
>>> A few are used outside mm/ and need to stay public:
>>> folio_lru_list() in include/trace/events/pagemap.h, and
>>> folio_test_workingset() in fs/btrfs and fs/erofs after patch 16. So
>>> maybe keep a small public header for those, and move the rest to
>>> mm/vmscan.h, or to a separate mm/mglru.h if it gets too large, as
>>> David mentioned.
>>>
>>> I can help with the mm/vmscan.h part if that works for you.
>>
>> Good idea! Maybe you can send a series to do that which I'll rebase on
>> top of. Feel free to take the first renaming patch too since they
>> should all be zero-feature-change :-D
>>
>> But please help keep some helpers in a public helper so when we are
>> able to get rid of folio_*_referenced and folio_*_workingset, there
>> wron't be some strange header inclusion issues. FS users quite often
>> need to call them, especially the folio refs related ones.
>>
>> (Considering MGLRU even used to try to completely ignore anon reclaim
>> at swappiness 200 about a year ago, maybe that isn't too much of a
>> problem, but it's still a problem).
> 
> Sorry my mistake, I meant file reclaim, got it wrong in the opposite way :P

Thinking about it more, the header move is not urgent, while this
series has been iterated for a long time and fixes real problems, e.g.
the swappiness 200 regression you mentioned. Making it depend on a
code shuffle would only delay it.

So if David doesn't object, I would suggest landing MGLRU-FG first,
and doing the mm_inline.h split as a follow-up on top of it. That also
avoids rebasing this large series onto a moving header. I am happy to
work on the follow-up then, keeping the folio refs helpers in a public
header for the fs users as you said.

David, would that work for you?

-- 
Best regards
Ridong


