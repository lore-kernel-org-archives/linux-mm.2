Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBE6CD98F0
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 01:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839B66B0088; Sun, 21 Jun 2026 21:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9326B008A; Sun, 21 Jun 2026 21:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF7D6B008C; Sun, 21 Jun 2026 21:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43DE26B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:59:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B373F1A0550
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:58:59 +0000 (UTC)
X-FDA: 84905890398.19.F72822A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB82E40005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:58:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxFaFZSm;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782093538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qpRzlSyLktZxcLZDCE/8RBM2MX99p//TZMgpKeEF9c=;
	b=voUoDVLE6KBTZ3JVNUluOTXRnZ4ffGyZ38tCBsl/mjKwZ52raHsuBMbkVWtl507d+gUKCX
	+L0HY6BbyM37+BkfsIPDteg+SEsmVDzPji7XI4pOexWi5ms6DG2W2A/6og/CGTZTcSUW72
	mgG04HuVeVw9FruYgGxAYqp41i3IjrU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782093538;
	b=2if2DXAMxqSyemKAd2i5WRVKMg+9Dgiu9EAW8UhMRp58MQAJX63tsvK/rIaxgY15AqG93t
	mWpROcmKCNdXuYGzkTePLLT2E+DjDdIeGeD4loObAAGKj6SXKjOavOyuHVr9C/S9fQA1Un
	JmC/cE8xhGZZ1ATbI/HMPyLdJXoOpP4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxFaFZSm;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <267e070f-adc2-4f42-b528-746f852d9ef4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782093535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0qpRzlSyLktZxcLZDCE/8RBM2MX99p//TZMgpKeEF9c=;
	b=NxFaFZSmEW+ZWMeELNcIGCdhQ61H6KXKppMDcfRpFas7ME15wP+WUEtZZQoKET/vfzZHJM
	T4aMhPb8ktKruOCy6L+uoJ7VUXfLkbV3gpbyN6nq+y+oAc8YqFniPixLSLsy3WzjQKg4NR
	VyI6gSHfcIUoVL1ANtxXoVvryXQrYd8=
Date: Mon, 22 Jun 2026 09:58:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
To: Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org>
 <CAJuCfpG48TmvaiaRvnL-NXKU6nn55D3bks2DgzAc0URsZhAxqA@mail.gmail.com>
 <DJBHRVM65A11.1OL2M9MXN56H@linux.dev>
 <45fcc57a-ec8d-46d6-9c28-065d001c081f@linux.dev>
 <DJD0AGHTWYRN.1YWG5MDH87WVO@linux.dev>
 <CAJuCfpGtymV=Tmsvs8Z-oF6pi7mD54mRiZNZtpF3UpYwBL7Uig@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGtymV=Tmsvs8Z-oF6pi7mD54mRiZNZtpF3UpYwBL7Uig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kmbbmap3xh1bkyyr4smaokkhfkd83sdp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB82E40005
X-HE-Tag: 1782093537-456778
X-HE-Meta: U2FsdGVkX182Q9ZtrNuG42o8jAfhS99Q2OPaSl20anbfdRWeOz+BS0MygoMmtmPIwNlgrvEc6it7YeholY6JAxo9fRG2RFZWJyVzHU3fhBhN8FQeX7Im+lIJknF2vWHkulppN3RK1IOgb+8VKB2/Mm8d7e67ezJ1Ok4cHIieE85buF34mutBeCSoSzvbej3dpWJRreUMNFEPtnM36OH5bqKpDDbSYGxm+vcGXC3gqKBNKDz7BVwdaM2SOa+m/s+j9hw7baJyTwm6+aAAb1iNo+OXlqrVDVW2GRoYBkQIfEC7nMVvBCE+FtDyXeJgR9OPgjgaQUVxiPn1MOZy9a3ynbG1Zx1kJAciO9tydloCKGNcPPb8GVgXlY5NtzKO3E7c3YIJ7+eHYH2KIu9RXSO/le6wSAcpPk2amrDYWxbeZc9SjPd65LXGsLOOGo1PdCpnny7eI96ptnhoO7z7kywvLP3Z+9hRofo9EMAN8oskKIoibZ28vE308sDu2ZaTvFssukL7DX5Xb3gZOvqkU+lU7Mfwys2klS8FC2szvG6chgd4+GV/AKoQhsRyuxIJP4YBmpGpWUYIlKBjdvvxuoAT/WLPvV2OwfmlWKXSHEX7uNL3JxdMZ9SVX8JHUrzEn8PEsYRlHUpuCOwkiZs9Z9rzxFF6i77CCiFgXWXv8xOET559IM8KKF859sbWzOtmmdtCR2MZ+LNnQxAUiPlynfEnVNC4GMWb+/MftXP3UYdYHm7fNcXIyZFEuMNgBtYrM5R2j+9ftl9thmS75LvREkCvVxQ+A8BMq6wZIxkV1bHT75PlOWrGYDlb0GMzzq0sHTw0vCDuvufmYyz5yExd4IcIWcklinzMOG9Ihai/xmE3jZ89ag7BHaCSYS6VgcWJKzSibsfO3LssDjEG+1kpn5VKfGkcnhY48ad7yLBLRCMxPCAxqipodmoy51jN+rTt0/j9aoNmH1uAc92K6HwgNpe
 Wv5reSP4
 APpcrLmToA9Jh0dLarMI97edktIWqGPrdDJwUglGw9VGu+cV9i2HwyvvS4ai9PGaWQBWZXczf3qFQOF/h3LekB9FTK1ZSPDgLR8y50ha0M7eMacy+vyJS8qKEaVuSNAmR3HUHEIZP4msU3w5YnG0ZBLGUYS4OvAxDw79ynEwdcokZiA5LzL8kG/n4Wzy3gKUPSWNdniPQvtxejB/NFJZe57YoLVdItkasKc5AZhx9xhbSCh1Zc9ydOagOWzD479ln05AbgbaJM+Xi01SVqPW2v8j1fjZKPBxWDhiyJMfSjfHwTJR6MncKhvRTm+6dHoXrDLBaYxQm8xIamujgb2cVNGP47v1ZRwRlJQIOPkfz8Tt0XzjSxPo4xtj+rDVYuCRzh/7FttMaOZOarFMHgfbdAVu5ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/20 02:08, Suren Baghdasaryan wrote:
> On Fri, Jun 19, 2026 at 4:57 AM Brendan Jackman
> <brendan.jackman@linux.dev> wrote:
>> On Thu Jun 18, 2026 at 2:22 AM UTC, Hao Ge wrote:
>>> On 2026/6/18 01:14, Brendan Jackman wrote:
>>>> On Wed Jun 17, 2026 at 4:49 PM UTC, Suren Baghdasaryan wrote:
>>>>> On Wed, Jun 17, 2026 at 9:39 AM Vlastimil Babka (SUSE)
>>>>> <vbabka@kernel.org> wrote:
>>>>>> +Cc Alexei
>>>>>>
>>>>>> On 6/17/26 17:29, Brendan Jackman wrote:
>>>>>>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
>>>>>> It's not, it's ALLOC_TRYLOCK! Thanks for proving that we need to rename it
>>>>>> to ALLOC_NOLOCK:
>>>>>>
>>>>>> https://lore.kernel.org/all/DJ9QPTO2WXNB.10E88ZHWRDHB0@gmail.com/
>>>>>>
>>>>>> So you just won the job to do the rename :) I think it should be done before
>>>>>> this patch, so that the new usages and other _trylock names introduced here
>>>>>> can be done as _nolock outright.
>>>> Ack. I'll aim to send that tomorrow once Sashiko has caught up.
>>>>
>>>>>>> main entry point function is significantly different from the normal
>>>>>>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>>>>>>>
>>>>>>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>>>>>>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
>>>>>>> exposed to mm/) and then turn the nolock variant into a thin wrapper
>>>>>>> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
>>>>>>> how some of the wrappers in gfp.h do).
>>>>>>>
>>>>>>> Rationale that this doesn't change anything:
>>>>>>>
>>>>>>> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>>>>>>>      the new alloc_order_allowed(), alloc_trylock_allowed() and
>>>>>>>      gfp_trylock.
>>>>>>>
>>>>>>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>>>>>>      previously in the nolock variant:
>>>>>>>
>>>>>>>      a. Application of gfp_allowed_mask; this only affects early boot, and
>>>>>>>         only flags that affect the slowpath get changed here.
>>>>>>>
>>>>>>>      b. Application of current_gfp_context() - also only affects the
>>>>>>>         slowpath
>>>>>>>
>>>>>>> 3. The slowpath itself: this is now just explicitly skipped under
>>>>>>>      !ALLOC_TRYLOCK.
>>>>>> I'll have to ponder it more closely.
>>>>>>
>>>>>>> Ulterior motive: adding an alloc_flags arg to the allocator's
>>>>>>> mm-internal entrypoint can later be used to do more allocation
>>>>>>> customisation without needing to create new GFP flags.
>>>>>> Ack.
>>>>> I think this change might also help us in removing __GFP_NO_CODETAG
>>>> Nice, this actually looks trivial? I can probably just tack it onto the
>>>> v2 for this patch/series.
>>>>
>>>>> introduced in [1] and being the only user of __GFP_NO_OBJ_EXT once
>>>>> Vlastimil's patchset removing other __GFP_NO_OBJ_EXT users lands.
>>>>> CC'ing Hao as he is brainstorming ways to remove __GFP_NO_CODETAG, and
>>>>> this might be the answer.
>>>
>>> Hi Brendan, Suren,
>>>
>>> Thanks for CC'ing me, Suren. This is indeed a viable approach
>>>
>>> and I believe it brings us one step closer to removing
>>>
>>> __GFP_NO_CODETAG entirely.
>>>
>>>
>>> Brendan, I'd actually put together a rough local implementation
>>>
>>> earlier with mostly the same core idea as yours, and this change
>>>
>>> would indeed be minimal based on your patch.
>>>
>>> Thanks a lot for being interested in tacking this into your v2 patch series.
>> Oh, I just took a look and it's a bit more fiddly than I thought because
>> alloc_tag.c is actually in lib/ not mm/.

Hi Suren and Bredan


> One option is to move alloc_tag.c into mm/ (while keeping more generic
> codetag.c in lib/). From a quick look, that seems doable and probably
> the easiest approach.
>
>> How did you tackle that, can you share your implementation? It would be
>> nice if we can avoid exposing alloc_flags in gfp.h.

First, I introduced the ALLOC_NO_CODETAG flag as shown below:

@@ -1478,6 +1480,7 @@ unsigned int reclaim_clean_pages_from_list(struct 
zone *zone,
  #define ALLOC_HIGHATOMIC       0x200 /* Allows access to 
MIGRATE_HIGHATOMIC */
  #define ALLOC_TRYLOCK          0x400 /* Only use spin_trylock in 
allocation path */
  #define ALLOC_KSWAPD           0x800 /* allow waking of kswapd, 
__GFP_KSWAPD_RECLAIM set */
+#define ALLOC_NO_CODETAG       0x1000 /* skip codetag tracking for this 
allocation */


Then, mirroring __alloc_pages_noprof, we wrapped a helper function named 
alloc_pages_noprof_notag.


@@ -5252,13 +5335,25 @@ struct page *__alloc_pages_noprof(gfp_t gfp, 
unsigned int order,
  {
         struct page *page;

-       page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, 
nodemask);
+       page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, 
nodemask, 0);
         if (page)
                 set_page_refcounted(page);
         return page;
  }
  EXPORT_SYMBOL(__alloc_pages_noprof);

+struct page *alloc_pages_noprof_notag(gfp_t gfp, unsigned int order)
+{
+       struct page *page;
+
+       page = __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL,
+                                          ALLOC_NO_CODETAG);
+       if (page)
+               set_page_refcounted(page);
+       return page;
+}
+EXPORT_SYMBOL_GPL(alloc_pages_noprof_notag);


Lastly, we exported this function in gfp.h as shown below:


diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 51ef13ed756e..ac6e837ac8c0 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -234,6 +234,9 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, 
unsigned int order, int preferred_
                 nodemask_t *nodemask);
  #define __folio_alloc(...) alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))

+struct page *alloc_pages_noprof_notag(gfp_t gfp, unsigned int order);
+#define alloc_pages_notag(...) 
alloc_hooks(alloc_pages_noprof_notag(__VA_ARGS__))


Hope this information helps you.


Thanks

Best Regards

Hao



