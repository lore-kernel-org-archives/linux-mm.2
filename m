Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C52F606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 01:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TCaOj5o/
Received: by kanga.kvack.org (Postfix)
	id DACEA6B05B2; Thu, 26 Nov 2026 20:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CEF6B05B3; Thu, 26 Nov 2026 20:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25F46B05B4; Thu, 26 Nov 2026 20:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 545316B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:48:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEDC91C1C32
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:48:36 +0000 (UTC)
X-FDA: 85479214632.21.9D258E1
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0B2BD20002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:48:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TCaOj5o/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795744115;
	b=Gz56O7tiQ3/yawsj+lrbDYBIy8qdsJgpUov2Vk3+Jw9ySD5bYt3IxHZvfg1QPlBlWAN+m+
	afYP4tgnsw/yCc2nBJUFvdECeCTHrVtQTSZOYKI55wYlE+lt2iLowcDnZYCjM/V/HpIDui
	w89vIDWJDQVzojKZSVB9gIOhPwSb3co=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795744115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTJQdyhxcBsW+3THmacQX4CnuREPTh1k/3kUlckbS3I=;
	b=w741+U/owI36ZRJUHXf21Rsy3h4HCDjuzl1ldnV38F07vxwyZfINi4Yqxa/ejNOsTKcj6o
	Z9xZtaTEX1eiqAf8k4CNc0WPBRZxpXCr2CgyrYWHQYC39ABRz+Cubt7EVhRnmxCEU8ASXd
	OFCi2GFMz06IGOQ9hUfko4X6CsDJY5I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TCaOj5o/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q9H1ZM4mU9UmY5HM2f6Dg/Q5kejbxPRjAjPA/4aeIW4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795744107; v=1; x=1796348907;
 b=TCaOj5o/ONLCFGtz9AFc48YIUnEwVWCMqt6sPwX3DB+kYbmLj2SoXMbp81Vzc3tPVY2krBab
 dRHyR4fkY4a0EVdajOtoxCfL72tO64NBNDNRTibA2RwvWDBM5JylYkSwNDtx9EPaxZf+zDqbDLJ
 VWXf86hIhGlOPZqICGt4N1U4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b8479f5f7f50d961;
	Fri, 27 Nov 2026 01:48:27 +0000
X-Mizu-Trace-ID: b8479f5f7f50d961
X-Migadu-Flow: FLOW_OUT
Message-ID: <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
Date: Fri, 27 Nov 2026 09:48:13 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org,
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
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <awa30hwg6x82REoo@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 43s8dfqg59oq1bxkeuzh6m414razdb4d
X-Rspamd-Queue-Id: 0B2BD20002
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795744112-272656
X-HE-Meta: U2FsdGVkX1+tWJVC/RWlmzLBNBtJRkqwecY/Gi1UfNQDxPlViUjaJyKoQ3jS/2LuEQTe7wFzys5+w1q/XpiZ4/lpeFnglz8upL8//BLcKcPgdVhVmsXKK6uBPi81GB7yb4jpJdJ5NyzbLiyFBMK6pfeppIPflXSN1hdhC2x+Vx2GaJ/b4eJzMPm2qV7/uimKTCEQNsFYScUn59J2nSoYoJJIRhU+OzsxrNgZkXkb7j+ICKp1CZO+VznCargqaHuAAzyRtULS5NrcF/pCTVVP1vtfLNJcrmxUZS/V2JZYbDDdpPCmAa9TW3fq1ep2QUh5WSyivR8Hr+/CTpXT7qnX1b5pJH+Ktd0DTAJGShkX1eFMcz8XqIhALOEBgflMaWDkSGnIEHogbKGPLOnkg0nVpGxXOUNSVoTnNKwtGU20P2DchlahOhtXUL71XQUGIvHxYj/zt3KW8VtTjuTWqbjIvyf2qX1EON7Ub+0Qqutll/hlN9rO3phXd99CuNsD24wPhjR+j7ZoWxdYmKC8BPxPLECyicqgLQo3B2VoOvxSWzmnj74jIbaAbNejh2q7P/sn1y2wutRrBsOym2Ww1ZhyHdHcssuCCnp/JYa3F3NlqNw8exEENALzMb/fmAwa09GCjobaZIF9+t9pXuZmO62EhGs6meDbG7I0F5PUmX0X4ZPShyDD8S4jB5DMwX7tDJ+xXnn9F9xgk9zEviztck/Z0cEf11W3Bf7BE+M8wIuiKx/tVESKcXiGGcq4ZqiS+swx9mjcln5B2psgtFhjDzTyfTMPfwarp+epIoMrN9Fx3802ZbiSRrcXcULwcJnWy91dxdII/bNSZ1lqtdBJH2x65ZzUmTT1gzdpZrqSduYd5MwggnPMJimeTeXCwhy63k1bdA+cbLR8jc0rl3xghTbHe+tZwKqtxD+hFW/ck5Y8xIKXpPYofVfv9auXCUpdA7Q+he1NRmkDDtOa2QrPdr1
 ZNONm+cU
 VagQ0qOYBy50WYRD/6jJk/d45bQwMCRC+a8u9psNKtMMj80kvR5O04dDfWI2t+xhQv6jhr9eyR5aagFTbJkse+XBPqSXeTki5M/N3i7DlY5rpxoHMgZtw7uj1TkR6FWbNH2r3NxYyC55gp5r5iepNs/Zwe4QBdI5mCEm6D0wdfCZG4EQa64T4B81L1bUY35HHpNLgoGP5mB4f7k7tMOiDmBNCe7sAKlukDBgtaz5Nx2O/XC38r8GlW0C/GuePP3drsjIIH7dqrKajoK8Nmaun3365Fg0CbPTr2/1vDSHcs0PnqY9pHtXJ9vgq7pYhvSquVf3je8Osmp5IhuRZ8TJNc9xiRedK3rLbX4LqbhYLC6Y8BiCkWaw8G3RrVl/Rwy7KOR83v/v/JyopbCcNTmOXnqQaFINvX20GuGIhzIllYAGO8MaljWn4Wzj2EPU3fFEDGc7Te3/vHSdwBnAcnU/4+3M2L8tS/PBfysSfgkpsw35WHrla13I5OzkvzJ8/Idru+4XPLWm/3muvN5V2Hu/Z6ahhZYdPD6bcQebgRzAkPNnswhRjjYAwvqAmqqq11+FDUwbct5OUC7/CbkSicjl96itNaNuK9/qMKPkyXwhqK8GYU4pmOYJvDm5FSm75lo9mIHBe8Wfc1xNE/9WXGwTrs15w5hEy+H9YLOdstYm31KS0bsO/dtik/41ITceUeaTO/4lbaosyu0UdoRw9Sggr2fQDL77yM3PUGo2a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/25/2026 8:36 PM, Kairui Song wrote:
>> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song<kasong@tencent.com>
>>>
>>> Pure code shuffle, no behavior change.
>>>
>>> Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
>>> Without MGLRU the extra bits are never set, so they are inert. Move the
>>> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
>>> unifying the API for checking folio referenced and workingset status.
>>>
>>> folio_migrate_lru_refs() now migrates the complete refs count,
>>> including PG_workingset (bit 1 of the encoding), bitwise identical to
>>> the direct copy dropped from folio_migrate_flags().
>>>
>>> lru_set_refs_flags() skips the nonexistent mask bits when
>>> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
>>> !CONFIG_LRU_GEN builds.
>>>
>>> Tested-by: Zhao Zhenzhuo<zhaozhengzhuo@uniontech.com>
>>> Reviewed-by: Kunwu Chan<kunwu.chan@gmail.com>
>>> Tested-by: Andrew Morton<akpm@linux-foundation.org>
>>> Signed-off-by: Kairui Song<kasong@tencent.com>
>>> ---
>>>   include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
>> I'm starting to feel like all of these mglru/reclaim thingies should go into a
>> dedicated helper.
> Hi David
> 
> I saw your comment on other patches too, about the header mm_inline.h,
> about ~690 / 860 lines of code in it is for MGLRU / CLRU only. The
> rest ~200 are for VMA / TLB / MMU.
> 
>> Can you do that as a prio cleanup in this series, so we don't have to mess with
>> mm_inline.h in later patches anymore?
> Perhaps we can instead move the non LRU helpers in it?
> These helpers:
> 
>    - anon_vma_name_get
>    - anon_vma_name_put
>    - anon_vma_name_reuse
>    - dup_anon_vma_name
>    - free_anon_vma_name
>    - anon_vma_name_eq
>    - pfnmap_track_ctx_release
>    - init_tlb_flush_pending
>    - inc_tlb_flush_pending
>    - dec_tlb_flush_pending
>    - mm_tlb_flush_pending
>    - mm_tlb_flush_nested
>    - copy_pte_marker
>    - num_pages_contiguous
> 
> All other helper in mm_inline.h are for LRU. So we rename mm_inline.h
> to mm_lru.h?

Moving the VMA/TLB helpers out looks good to me as a first step.

For the LRU part, there is already mm/vmscan.h, added by "mm/vmscan:
move struct scan_control to a dedicated header" in mm-new. Most LRU
helpers are only used inside mm/, e.g. lruvec_add_folio(),
lruvec_add_folio_tail(), lru_gen_add_folio() and the refs encoding
helpers, so they could move there instead of staying in a public
header. Barry also suggested moving lruvec_add_folio() and friends
to mm/vmscan.h in another thread.

A few are used outside mm/ and need to stay public:
folio_lru_list() in include/trace/events/pagemap.h, and
folio_test_workingset() in fs/btrfs and fs/erofs after patch 16. So
maybe keep a small public header for those, and move the rest to
mm/vmscan.h, or to a separate mm/mglru.h if it gets too large, as
David mentioned.

I can help with the mm/vmscan.h part if that works for you.

-- 
Best regards
Ridong


