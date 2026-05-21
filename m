Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B35CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 02:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3066B0088; Wed, 20 May 2026 22:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C943C6B008A; Wed, 20 May 2026 22:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82BC6B008C; Wed, 20 May 2026 22:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A48C76B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:47:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14CB8A04D5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:47:01 +0000 (UTC)
X-FDA: 84789889842.09.3F055E6
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 056A3C0006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:46:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fIiKlDWM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779331619;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWU1AGiWGGW7xe8FojAwk5LW5vZls8NTawItwlIVvnA=;
	b=TWuLvWw3Frya0U0zzJrYkWHfIUsaVUFhbNnfkLGInBBmze7bPy8sq3NWe0y9DkZHS+WlpJ
	7H0T7eTo1Yoo9w3KfXtn2adWX7FyxC67iw/QRCZhiBovZvwohDNR5vgMnDgMkXMfErwJ9D
	21fmQAxNXlfe2YAXYaDb1+hpKBhPS8s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779331619; a=rsa-sha256;
	cv=none;
	b=0wnrtaCifAA1DuFp7mLO6AL9ggsI4E/rBAIkuKvM3tLEXuoj4Q3fZwxBEW3sxaBBU2SUq7
	dpi+AkJh7S6mJ3rSMKNxV5NWTvC3DLMKhrL+aP2kCWqJFr3v8zcYgunFW5ObaeNyOjqaQ7
	eQE+n2sWJZh5g8hz2kborumN9NcoMYQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fIiKlDWM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67c4aaf76ecso9319344a12.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 19:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779331617; x=1779936417; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWU1AGiWGGW7xe8FojAwk5LW5vZls8NTawItwlIVvnA=;
        b=fIiKlDWMucyiJoHco8sHJEkPnIdgxfkt44uzivZ95ZBieMmsiK1Tw/rEMtLgBCF+LM
         upudGBtlq/F48c94ZZR9snYflkR3doPeFEwhUtLTXtPlg3jDsnrmpH95gbeh/lbtfi2A
         Hn7N+ATSoLGYzwcwQ+CSs0zNiO7QO9e1YqlPuBlG4AkmcofkLikXAMWQMytQlytzyrBd
         fwXQirZGc2385e8XZZbxtM6Dhmi8gA3afVP39Yv0mffuzN09YP778gi7BQqkg2EH+DYJ
         QxHpp+ws7XYZldPoupTH8MZMM29jwFYbfhKkCYdx9vnVTjkRZl1cWws7THU1Q1qxa65r
         O9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779331617; x=1779936417;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RWU1AGiWGGW7xe8FojAwk5LW5vZls8NTawItwlIVvnA=;
        b=jd4q5KwEknSfjjK1MlMu86OWvApsjOxi92HMzrPStm2GU1HHWZCTs+7m1dzuyUN4oi
         4/tm5RRUa82NSj2zmqSTl65ycD0IZ6Zd0p5YSuRRvYFchd0Vd6YOpq1S2mu2s/RaDNgh
         uvr8rX9ggACEiVoa471f7aztJfJ5a8fKE4oHJjmKoFSY/xS4qiC4mVlDyKu2oxni7lo/
         7aU9ERr0TejwBBDibgqQyh4LBaqLpWWB7pbPi0Ss37soMO6mL7e6EgJ7+ZPc6L76SYWN
         jMizZQcSyPGbHSynEPvdMtOsC+4YWpkOpfB7ZVJxfjvYieaIpqdgY5heBX0+HoqUf+3X
         QvoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Eq7cMEuEQF7ymGm3OcUq4PnY6xw96h0OQqjKrP8vC0H78vfwYhyxnKPTTNJ4tCpAXJnfuf6siBQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5r7FiibrHOVxIs4dhxq9Bx1hwcApmKg+F0OOIe1aQxX7tyv7l
	0CT15vnhNglm1+AgIFqRvhH/7BTCMLxEhkNCyGTkR3Bo3reVtVystYgF
X-Gm-Gg: Acq92OGyR8xggzOYgvIPHNi5IKwSttZ8XGN9jit/hW6SN6sUJlHnlqCbcLVYB6crDBb
	zCIhFVqt0YkkaWR+qsCkZJVsuUmu2E5oHTzTFG2IJ+yqgR00S5hPTxp8AlbiMl1Zsp9m6VqqufZ
	XX16elH4O1fiqmPpdRG57LJY/rybAcb+MidZPOrkD639NMG2m5YqqxFBPv0llaKMxVdZrTKpYzh
	MccfZFVmQw3cXMlV9AJpI4TsxDrlaRxEsRxLdJeqoCebEmzzDWLMFAvmtSabNGX2hDo0fYJlwh/
	Csa1uSFBDtf9ZIeQjbp3nYdXXNyoF5J8635rfaNcY7Nf8N3fbr/DCzzfLPoHsdgfOW2SorcRVwz
	yEFBAs4yBhbz+Lu0HpYTiSF1fKJSwSJxdR9RdZtImrupSOlrUE8Th4Bfp/Tk9xZbJmmoMEmnZcU
	ago/hK68Sbvkch3A/tspDSkXMMEpRprfxi
X-Received: by 2002:a17:907:3cca:b0:bcc:3dd8:58da with SMTP id a640c23a62f3a-bdc14a6a24cmr41586066b.27.1779331616952;
        Wed, 20 May 2026 19:46:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4e21b1esm939875966b.44.2026.05.20.19.46.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2026 19:46:55 -0700 (PDT)
Date: Thu, 21 May 2026 02:46:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
	akpm@linux-foundation.org, anshuman.khandual@arm.com,
	apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jack@suse.cz, jackmanb@google.com, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com,
	pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
	rdunlap@infradead.org, richard.weiyang@gmail.com,
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org,
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com,
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <20260521024654.2a7teoe665porz76@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-12-npache@redhat.com>
 <8f9834db-8981-4eb1-ae46-94908943da3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f9834db-8981-4eb1-ae46-94908943da3d@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 056A3C0006
X-Stat-Signature: qrmdtx3rdnswjqxjiwk75tafaewfjeq3
X-Rspam-User: 
X-HE-Tag: 1779331618-859834
X-HE-Meta: U2FsdGVkX18ZU7xZM9KZDbLgOGcVh6o0AibRnhEnvs/lc9CgU22BTu8jYw00JxTcx1TAD0isQjTP53VZeqTfs8sZj7BW9weDZr9oWFJU9y7Zr56JH1Zz0F83UlezGwq2h7cdVEUK1N57pArURccIUec55T6YuTom32v8OVAWwmJ0mcG7/pK4vnICiXJ6jNZ+T6YUiNGgqrVAKt2IIGDiVhSW1zuG9WIkhd2aEHxP2W7s8Xxm+3NpZXb0XSX18zdboE4Hg8mzzehuW8maT2bh4u8d+nghFkA3YbcR4a2rnqMXUUKC4oYIFXxfS2kOf7dcCHKa8m50UAUUXbA1XTK8NmUn4r3lNwMC9h9hGG/WFMoUN69g3D3bJSMxIOX1zE71+yZVZeT2gKUvxK5Rz3oMMeeoXRrGRENs6PQ/L9Fpk2iQIDIpCGyrBY5T1mILKHTXweV2Fl6Y2HSK8+6WQDEzvLjxRvMxW5XnQrSeZ9XN3k6zjndaJqsBJ51RBkuZjyw1BBRtE8QKjxJcXiciEqn/h4MivQKiavcMriWZREJoyqFX1/jWnKIEBACey/mdY+gOgLHLLWPjWtr14DhU+AAou+5pz/DyFH1QQEx5o3A29dK+LJlM44c1rx5k9ZAbh2tKlLPTqwtLqnbLWRCR2/IaDNi1XjtUgnQn6uglmjaeMJPM2P/lnayGtED1F3EPitsz3wVGS0oiKRddEJk9FcrchCmIPCIPDQLrhHCP3VsKKxGmn2yEdsJsNT4xzY+iOUIehpxHnnGZXKdPiVEMoHBigaWEvA/eLVVkEL9WelorsiXF8lCoqOGpWvRsXyJg12zV2FShpBhfUDxroFKsbxLVBDNMq+GJc5okDcGPKQJ2LIGTme/PFrPf7nfPRKQFOSBC/KsickeXAwFFLAsFyXkt7EqkPks7h7BthvKVRmHAdAT+sYLsLEDyEgYSrAXQkRq5TdRN8rglKLIhWPUDeiT
 pbrypenI
 vRyw6AsJMS99dXlCKdw3XnPFt1037PG4q5tFvnx8XeML0BatYvZkytcLpmPQC3K1jlgxr6bnNzrR194AXNXdDPeqbu52XnkDnlYxIggbRyYTINVbpA0/MbTmLywj7iS9XbjwppuH8/YIT/Mu1auVhkhX+mk6QiGtltwQ6+hZ2Fsq/KjYJ80rqdG/tDuD60gAhlyo9JfPNAWptG3oHWl9T2F3bPZ9SIO5bm/vrIPsPXXMX+IhN4y6umuCrpY5hefDqQdgsw12iBG2O6OePmoTtF2A4BufstmNgwGNX9m/sG+Y6zxLYumK71Wl7vgJh/6jixS1gHwtes63IiyS0wb65VDD2lmoXnH9DqC6Km0phek9u3wiZjJOhCW+JMjom6IUcoSxgaG8OqsJi8DgWLAwgAs+mVUvZd8SsffYhRexGaFhBwvaB57j7Z03fihbXe+iDQPaxZD1zsKLaWuJl/Q5O+4emN3nk2GGpuL6gHNDz80byqvVueuVTLQkxcr9TwrhOpTcHyQvtvq2x8hcxwKhN24F5GW9tCc5SaLX7Kvtuh1Af1NMjz0qn6ZYp9ZTK3ENVxnPMlZLsCbLWzy2JNZ8WKreWaiM+qcGTreg58eLuMKW8CKiRyoTVX8FBo6e4lS+c+HIxESPlkvHU0XIS6W+GWAd+Dqe5JhPMDM7B1L/2uN9PxnVfLdt1Xvz+h4CSTlNjbM9p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 10:36:15AM +0800, Vernon Yang wrote:
>On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
>> Enable khugepaged to collapse to mTHP orders. This patch implements the
>> main scanning logic using a bitmap to track occupied pages and a stack
>> structure that allows us to find optimal collapse sizes.
>>
>> Previous to this patch, PMD collapse had 3 main phases, a light weight
>> scanning phase (mmap_read_lock) that determines a potential PMD
>> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
>> phase (mmap_write_lock).
>>
>> To enabled mTHP collapse we make the following changes:
>>
>> During PMD scan phase, track occupied pages in a bitmap. When mTHP
>> orders are enabled, we remove the restriction of max_ptes_none during the
>> scan phase to avoid missing potential mTHP collapse candidates. Once we
>> have scanned the full PMD range and updated the bitmap to track occupied
>> pages, we use the bitmap to find the optimal mTHP size.
>>
>> Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
>> and determine the best eligible order for the collapse. A stack structure
>> is used instead of traditional recursion to manage the search. This also
>> prevents a traditional recursive approach when the kernel stack struct is
>> limited. The algorithm recursively splits the bitmap into smaller chunks to
>> find the highest order mTHPs that satisfy the collapse criteria. We start
>> by attempting the PMD order, then moved on the consecutively lower orders
>> (mTHP collapse). The stack maintains a pair of variables (offset, order),
>> indicating the number of PTEs from the start of the PMD, and the order of
>> the potential collapse candidate.
>>
>> The algorithm for consuming the bitmap works as such:
>>     1) push (0, HPAGE_PMD_ORDER) onto the stack
>>     2) pop the stack
>>     3) check if the number of set bits in that (offset,order) pair
>>        statisfy the max_ptes_none threshold for that order
>>     4) if yes, attempt collapse
>>     5) if no (or collapse fails), push two new stack items representing
>>        the left and right halves of the current bitmap range, at the
>>        next lower order
>>     6) repeat at step (2) until stack is empty.
>>
>> Below is a diagram representing the algorithm and stack items:
>>
>>                             offset   mid_offset
>>                             |        |
>>                             |        |
>>                             v        v
>>           ____________________________________
>>          |          PTE Page Table            |
>>          --------------------------------------
>> 			    <-------><------->
>>                              order-1  order-1
>>
>> mTHP collapses reject regions containing swapped out or shared pages.
>> This is because adding new entries can lead to new none pages, and these
>> may lead to constant promotion into a higher order mTHP. A similar
>> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
>> introducing at least 2x the number of pages, and on a future scan will
>> satisfy the promotion condition once again. This issue is prevented via
>> the collapse_max_ptes_none() function which imposes the max_ptes_none
>> restrictions above.
>>
>> We currently only support mTHP collapse for max_ptes_none values of 0
>> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>>
>>     - max_ptes_none=0: Never introduce new empty pages during collapse
>>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>>       available mTHP order
>>
>> Any other max_ptes_none value will emit a warning and skip mTHP collapse
>> attempts. There should be no behavior change for PMD collapse.
>>
>> Once we determine what mTHP sizes fits best in that PMD range a collapse
>> is attempted. A minimum collapse order of 2 is used as this is the lowest
>> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>>
>> Currently madv_collapse is not supported and will only attempt PMD
>> collapse.
>>
>> We can also remove the check for is_khugepaged inside the PMD scan as
>> the collapse_max_ptes_none() function handles this logic now.
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>  mm/khugepaged.c | 182 +++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 174 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 3492b135d667..39bf7ea8a6e8 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -100,6 +100,30 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>>
>>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>>
>> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
>> +/*
>> + * mthp_collapse() does an iterative DFS over a binary tree, from
>> + * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
>> + * size needed for a DFS on a binary tree is height + 1, where
>> + * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
>> + *
>> + * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
>> + * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
>> + */
>> +#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
>> +
>> +/*
>> + * Defines a range of PTE entries in a PTE page table which are being
>> + * considered for mTHP collapse.
>> + *
>> + * @offset: the offset of the first PTE entry in a PMD range.
>> + * @order: the order of the PTE entries being considered for collapse.
>> + */
>> +struct mthp_range {
>> +	u16 offset;
>> +	u8 order;
>> +};
>> +
>>  struct collapse_control {
>>  	bool is_khugepaged;
>>
>> @@ -111,6 +135,12 @@ struct collapse_control {
>>
>>  	/* nodemask for allocation fallback */
>>  	nodemask_t alloc_nmask;
>> +
>> +	/* Each bit represents a single occupied (!none/zero) page. */
>> +	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
>> +	/* A mask of the current range being considered for mTHP collapse. */
>> +	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
>> +	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
>>  };
>>
>>  /**
>> @@ -1404,20 +1434,140 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>>  	return result;
>>  }
>>
>> +static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
>> +				     u16 offset, u8 order)
>> +{
>> +	const int size = *stack_size;
>> +	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
>> +
>> +	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
>> +	stack->order = order;
>> +	stack->offset = offset;
>> +	(*stack_size)++;
>> +}
>> +
>> +static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
>> +						 int *stack_size)
>> +{
>> +	const int size = *stack_size;
>> +
>> +	VM_WARN_ON_ONCE(size <= 0);
>> +	(*stack_size)--;
>> +	return cc->mthp_bitmap_stack[size - 1];
>> +}
>> +
>> +static unsigned int collapse_mthp_count_present(struct collapse_control *cc,
>> +						u16 offset, unsigned int nr_ptes)
>> +{
>> +	bitmap_zero(cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
>> +	bitmap_set(cc->mthp_bitmap_mask, offset, nr_ptes);
>> +	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
>> +}
>> +
>> +/*
>> + * mthp_collapse() consumes the bitmap that is generated during
>> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
>> + *
>> + * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
>> + * A stack structure cc->mthp_bitmap_stack is used to check different regions
>> + * of the bitmap for collapse eligibility. The stack maintains a pair of
>> + * variables (offset, order), indicating the number of PTEs from the start of
>> + * the PMD, and the order of the potential collapse candidate respectively. We
>> + * start at the PMD order and check if it is eligible for collapse; if not, we
>> + * add two entries to the stack at a lower order to represent the left and right
>> + * halves of the PTE page table we are examining.
>> + *
>> + *                         offset       mid_offset
>> + *                         |         |
>> + *                         |         |
>> + *                         v         v
>> + *      --------------------------------------
>> + *      |          cc->mthp_bitmap            |
>> + *      --------------------------------------
>> + *                         <-------><------->
>> + *                          order-1  order-1
>> + *
>> + * For each of these, we determine how many PTE entries are occupied in the
>> + * range of PTE entries we propose to collapse, then we compare this to a
>> + * threshold number of PTE entries which would need to be occupied for a
>> + * collapse to be permitted at that order (accounting for max_ptes_none).
>> + *
>> + * If a collapse is permitted, we attempt to collapse the PTE range into a
>> + * mTHP.
>> + */
>> +static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>> +		int referenced, int unmapped, struct collapse_control *cc,
>> +		unsigned long enabled_orders)
>> +{
>> +	unsigned int nr_occupied_ptes, nr_ptes;
>> +	int max_ptes_none, collapsed = 0, stack_size = 0;
>> +	unsigned long collapse_address;
>> +	struct mthp_range range;
>> +	u16 offset;
>> +	u8 order;
>> +
>> +	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
>> +
>> +	while (stack_size) {
>> +		range = collapse_mthp_stack_pop(cc, &stack_size);
>> +		order = range.order;
>> +		offset = range.offset;
>> +		nr_ptes = 1UL << order;
>> +
>> +		if (!test_bit(order, &enabled_orders))
>> +			goto next_order;
>> +
>> +		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>> +
>> +		if (max_ptes_none < 0)
>> +			return collapsed;
>> +
>> +		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
>> +							       nr_ptes);
>> +
>> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>> +			int ret;
>> +
>> +			collapse_address = address + offset * PAGE_SIZE;
>> +			ret = collapse_huge_page(mm, collapse_address, referenced,
>> +						 unmapped, cc, order);
>> +			if (ret == SCAN_SUCCEED) {
>> +				collapsed += nr_ptes;
>> +				continue;
>> +			}
>> +		}
>> +
>> +next_order:
>> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
>
>Hi Nico, thank you very much for your contributions to this series.
>
>I found a minor issue, for MADV_COLLAPSE, if collapse_huge_page() fails
>for some reason (e.g. allocate folio), it goes to next_order and
>continues splitting to the next small order. However, enabled_orders
>only supports HPAGE_PMD_ORDER, so it keeps runing the split operations
>without any effective work until KHUGEPAGED_MIN_MTHP_ORDER is reached
>before exiting. For khugepaged, e.g. setting only 2MB to always, also
>same phenomenon.

Yes, but it does no actual work since it is checked after pop up.

>
>This does not affect the overall functionality of mthp collapse, just
>redundant.
>
>The redundant operations can be easily skipped with the following
>modification. If I miss some thing, please let me know. Thanks!
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 1a25af3d6d0f..fa407cce525c 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1574,7 +1574,7 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> 		}
>
> next_order:
>-		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
>+		if ((BIT(order) - 1) & enabled_orders) {
> 			const u8 next_order = order - 1;
> 			const u16 mid_offset = offset + (nr_ptes / 2);
>

This would stop the iteration if there are other lower enabled order, right?

>Cheers,
>Vernon

-- 
Wei Yang
Help you, Help me

