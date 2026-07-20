Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC40AC44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 01:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B564E6B008A; Sun, 19 Jul 2026 21:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE09F6B008C; Sun, 19 Jul 2026 21:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6766B0092; Sun, 19 Jul 2026 21:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3336B008A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 21:41:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3446120745
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:41:41 +0000 (UTC)
X-FDA: 85007453202.11.9BF5E06
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E036C0008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:41:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iCMNUkUf;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784511699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+0AGqwHLeIrrds4xiDUsGuVUjee2WmZWQHT4y4URdc=;
	b=V0Zikd18SflASr0L6tJoOv8V2XXXthQVjd75PTRzQeGv5OmGMGBpT9yRvFoVoEirsXntld
	oSqPEJ4vYRqKtkgCRt5fSJ0/SL0koTu1ArV0YTKL1k2Ef89Nnci4/yp27u8iqn1qRPrtKT
	nDxla4x6E3eB7fcU08al5VSmkl51HLA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iCMNUkUf;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784511699;
	b=z5d6xYUSWlLpNZqDcJLwHaElGL8BfWRkWHQmyxnQae4SU2KZelu/vKZl/K2Z0slwCtdzdj
	+Q8+17SOBHyGMpvztJh6z774siReYabKPeyp5ANFYxXv1idK0Q32XkyvstjS9vGfGj5LV4
	yXNo+LpBgRmgPI40pG/q2UaY39Mzc3o=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784511695; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=R+0AGqwHLeIrrds4xiDUsGuVUjee2WmZWQHT4y4URdc=;
	b=iCMNUkUfDAdqLC91M47a2QeZaAOf70XbcYtUfhB5J99NlEwdeF4coJaAM/TUw8lCgjIrvmYL9bZ9PDUxir67GVIvTLpjChuzzmYRgxI4IQjS9Uwk+7BgvMRmdWKVymcBjZqkQAbRBsDsF8EcNNYy97iQXXSerb2qWZjxXzES2SU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X7N2CD2_1784511691;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7N2CD2_1784511691 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 09:41:33 +0800
Message-ID: <a7f55437-88b8-4ea1-90e9-ab0f3f42ca2c@linux.alibaba.com>
Date: Mon, 20 Jul 2026 09:41:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm: mglru: promote mapped executable folios after
 first usage
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 mhocko@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1784268206.git.baolin.wang@linux.alibaba.com>
 <7db4d1975cf04e3e48157f98bdf398565ee189a4.1784268206.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7CkuWfPfrMe9jPypW4zibHG-nFCmH26xR7u0Z6zhOvQpA@mail.gmail.com>
 <eb395442-0aad-428a-a5ac-9072d2d89060@linux.alibaba.com>
In-Reply-To: <eb395442-0aad-428a-a5ac-9072d2d89060@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: smk5p3ioxa38qd5teifymc1ggwnd7w8m
X-Rspamd-Queue-Id: 2E036C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784511697-719490
X-HE-Meta: U2FsdGVkX1/9+wPyh0N/zFq0jLZEb4ddftVUzEsXEXGc/4hXKaUoOGUvSVmtD138mu2jBsANHtgH0Ps09tkpwsk/Q5tK/pOgdo1YziwlgupinUNoBeRZfj6nQkOtonpwXe77cp+7ozE/NjaW+wGimwqILRAMcQAZMLdbgPUNBuu8kTjUq+2diCYLH77O1VUiSkXsvRBrTGPOpOHO2ZOs+ndQIRrmbBmLGZdup2zK/SAcu1lwoRL6enSeb/K2xrjNwZwl7DAV7ecBJUYvhXrsIO7oTdajzanKBIRkhDfpNAKign8LfCds8rHIx1opxnXFup6zPOa/l9ilADQgm03F4A8vrAneNswc1E4VFjrhgOAGBKO8m3mD8o/VzaX1OdoaQuprg2DRt1OD0m4lrj9fdyQVo7Anvdb/wAcBNDLleUFBEm9PG6Ar6e+/wX7iqrBScI0c+FWQXUZyNxcPsJl42qL+7rOScwTmieYs89HDT5pJsUxbDWJqqjGcYw6jl6lr3WY9F2kmMHcthWgixQOI8JrwV5hJIh8HjtGyNHup8sXm3k10QK0eR8B5Sfp1MwVNLWSIQbEz9dTSHYEAlAfYtXH7KIiVd0/Kx41A8u+BYrcWT5TbYnc4Emk4gwTqjXDl/8oPGdmJN7hWOdNPo8dW557HpjzkIT/yguIEZ5yQPNjrrCx1gojflUIet/9QKWYvES956GS2eyNb1HrHNRWQMKJqhFcBOiEwYuHnKyU7+DjLHuJvu/EP/wWK9z5F5i+HXvgtByeeQvBxJFXlSO6qJjZWV3RaiTL5detmNCJo0sCzTdlqabft38OlGV32xVEpP1q9dTFdnGG9Y2KViFeXWVAqPkbFOe+0l2cfSVD4uPPtwSNsC8eWQybecj5N0DxNSmEVMW7LvW4oG1USrZfPWV8jOEJ41Sa/5lXUNXaCUhQl5UK5ArHEc7vx/ba1wwGYULA0nRPhEqsjgYTI5xA
 GxkNu0i0
 alV7ubBKJ1GLwPtiuAXxsPzgCuSnSzcd9dVSccD9oR/0bpy1my8prIH4ufQ2BRUV+taaN7GErxXrlo7QbRcAoJQ7J9B/mVNPeb46TkxVa5sheqNlmdqtNG9vJsnqfeSiCJa16yNI7XjRlHE/1vlzpsnFxpecnjzsqeXIpv+NM4pWKbZ/D2UuBCT1l3GBL23z+FIU24vTNIq/RrqtScYwL9aPLcyLq69f4oqNqVE6qJd2X/8ZY2yFlp0cE+dOTghNtqHBTkezbIFc4xtth5oQFQRoRlI1NaBlOE7Ml4PT88kZbQguVfPRkODH6pcE/bVGndBpo08L3LbCdXoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/19/26 9:45 AM, Baolin Wang wrote:
> 
> 
> On 7/19/26 3:23 AM, Kairui Song wrote:
>> On Fri, Jul 17, 2026 at 6:06 PM Baolin Wang
>> <baolin.wang@linux.alibaba.com> wrote:
>>>
>>> Classical LRU protects mapped executable file folios through commit
>>> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
>>> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
>>> after first usage"), giving executable code a better chance to stay in
>>> memory, avoiding IO thrashing and improving workload performance.
>>>
>>> However, MGLRU's protection of mapped executable file folios is less
>>> reliable. Although shrink_folio_list() checks references, the access 
>>> flag
>>> of mapped executable file folios may have already been checked and
>>> cleared by lru_gen_look_around() or walk_mm(). Additionally,
>>> folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
>>> flag for mapped executable file folios, which causes shrink_folio_list()
>>> to ignore the first usage of these mapped executable file folios and
>>> reclaim them easily.
>>>
>>> Follow the classical LRU's logic, promoting mapped executable file 
>>> folios
>>> after their first usage in folio_update_gen() and lru_gen_set_refs(),
>>> giving executable code a better chance to stay in memory.
>>>
>>> On my 32-core Arm machine, with the memcg limit set to 2G, running
>>> 'make -j32' to build kernel showed some improvement in sys time.
>>>
>>> base                    patched
>>> 9248.543s               7861.579s
>>>
>>> While we are at it, introduce a new helper to check mapped executable
>>> file folios.
>>>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   mm/vmscan.c | 47 +++++++++++++++++++++++++++++++----------------
>>>   1 file changed, 31 insertions(+), 16 deletions(-)
>>
>> Hi Baolin, thanks for the update, looks good to me with two nit picks:
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index de62899c108d..1040bf9f96e8 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -268,6 +268,12 @@ static int sc_swappiness(struct scan_control 
>>> *sc, struct mem_cgroup *memcg)
>>>   }
>>>   #endif
>>>
>>> +static inline bool is_exec_file_folio(const struct folio *folio,
>>> +               const vma_flags_t *vma_flags)
>>> +{
>>> +       return vma_flags_test(vma_flags, VMA_EXEC_BIT) && 
>>> folio_is_file_lru(folio);
>>> +}
>>> +
>>>   static void set_task_reclaim_state(struct task_struct *task,
>>>                                     struct reclaim_state *rs)
>>>   {
>>> @@ -835,11 +841,15 @@ enum folio_references {
>>>    * with PG_active set. In contrast, the aging (page table walk) 
>>> path uses
>>>    * folio_update_gen().
>>>    */
>>> -static bool lru_gen_set_refs(struct folio *folio)
>>> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t 
>>> *vma_flags)
>>>   {
>>>          /* see the comment on LRU_REFS_FLAGS */
>>>          if (!folio_test_referenced(folio) && ! 
>>> folio_test_workingset(folio)) {
>>>                  set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 
>>> BIT(PG_referenced));
>>> +               /* Activate file-backed executable folios after first 
>>> usage. */
>>> +               if (is_exec_file_folio(folio, vma_flags))
>>> +                       return true;
>>> +

[snip]

> Additionally, I think Barry's earlier patch[2] also has an issue: when 
> lru_gen_set_refs() returns true to promote the folio, we should also 
> clear LRU_REFS_FLAGS, rather than calling folio_mark_accessed(). So in 
> my opinion, when we call folio_mark_accessed(), we should return false 
> and should not promote the folio, so the logic shoule be:
> 
> static bool lru_gen_set_refs(struct folio *folio)
> {
>      /* see the comment on LRU_REFS_FLAGS */
>      if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>          set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
>          return false;
>      }
> 
>      /* Promote on second access */
>      if (folio_lru_refs(folio) > 1) {
>          set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, 
> BIT(PG_workingset));
>          return true;
>      }
> 
>      folio_mark_accessed(folio);
>      return false;
> }
> 
> What do you think? I'd like to send a fix first to correct the logic here.
I tested this fix for Barry's patch and see some performance regression. 
I'll think more about how to fix it.

