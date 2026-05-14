Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18270CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 03:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6EF6B0088; Wed, 13 May 2026 23:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F4C6B008A; Wed, 13 May 2026 23:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4B96B008C; Wed, 13 May 2026 23:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2997C6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 23:10:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6987160640
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:10:15 +0000 (UTC)
X-FDA: 84764546790.13.BA20907
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9DAF11C0009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:10:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G+SmZb0V;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778728213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlbDhq6aISwbZIxdN2UdK6Cpe+bP5kOge+A9i5gYUKM=;
	b=bdeKDS0zgYconH0preW8UPbdiVZTod5KwlrjFoBuw1f+U1oik4PzS7P4HMQoCiaBfzHj8o
	H81rFN/tN/fk93y4PhfMEDKhTgUQ+C0wgMnL9IrGSeT239wXHdGqgNwppDnk6cdqrFO/IO
	Gv+jqFhemXiDZQqXzViP3k1bjmwLYkE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G+SmZb0V;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778728213; a=rsa-sha256;
	cv=none;
	b=rwEp9Z9ulAqTjyc7a9W+iDMuJhGDaAD0JLmsbM31UyweGma+KEPzoJn67FjCSNf+pe/NOK
	Gk8y3e7BxJN9AxoE9VqjOwpOGIYeyRbHcb2xzDmCbZzkk+rW+BFk8Bet4aFhlhKs6wAz1/
	A1sVGQZy9ZQPxvG4h3G07z3+nsVFS2Y=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so11419292a12.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 20:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778728212; x=1779333012; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TlbDhq6aISwbZIxdN2UdK6Cpe+bP5kOge+A9i5gYUKM=;
        b=G+SmZb0VotRhPq5b8q477QEbgsgpzWQBOVS8RfaISRPOEvD4oT1lAj2fnLPBxgpkVF
         Mb7/pflYm1XDQw+L+PlSa/Cy0i83Bw4SQiBB3krDsMLgsi6M63gtqqu6hBH4mgWasVR0
         b710AjwCiNjU7kFeTx7CnEHenp5Bj40eLrZqemK9UfKzDZKGqJmNpWlafsN2afWYDcJ9
         4retnPwTuKO9HTJyl1NwQW1Kfl3jLl/wXyJC9DLY9DKcg+tx2gxoSD4opS+B+7UwFRW1
         iH7t4zVLBgV81S3J6GuORAQ58lmhBGyWTa6rgsL5YjFzRfJMpm54U4UWfIanWefZOQmT
         Wlow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778728212; x=1779333012;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TlbDhq6aISwbZIxdN2UdK6Cpe+bP5kOge+A9i5gYUKM=;
        b=Cw3zWdMmuH+nKojl0mAWddFoRbu6Hx5i079FjcBPAKXtIXiDU0QuTkt8YQ+8a8QOKw
         2ClgHmLWaTP85omPMNv/ieLacWjsZ1qYisZOjDFO5rxV1kiut6fpx/QQSf8mKuEWNR+G
         xCPuggkrnSXgrZkniymKnjuX16TRKbYSutsb1FwLMj8EWg3CX7jAtSWnSSvtCJDPo1tl
         DnBjdjXvmPm+5JpT/xOSJeP9sPskr2W7+rzw/v1XjyTjvVMVC5LyYOeqnlOpxgXQjxZ3
         q/kqcwJAXMM8LMDtDUYy8jKLLYyeZFp9sLZboxa8qVZxbqyZbHWH1OprQUlpfdL0jDbU
         ae9w==
X-Forwarded-Encrypted: i=1; AFNElJ8h7oewbKyQUGcOoanN3lxlAuwbHDbbrLRqvwUg7mOSQHzKdJSbNow5yBIxWM32J2xoYfwCDTTbqg==@kvack.org
X-Gm-Message-State: AOJu0YxOIJevIpq83wi97Au0nDIDAXzqVkoAz7XZvpDPp1MaBUSYka0L
	bJYUEXj2olaT87s6PODk8K9aVRpB3lGDaPCKXhxD0feLZ3W9M3COcUqO
X-Gm-Gg: Acq92OG69+r29CjxZg1FduFZDPQLOLybZ/YC13kgd9+R6Nv5AP4JLWfZmrOzrrc8QjX
	8/yqgFaqfDg4nnx7lU8aKiPc5rwgYvx7H70o3D9zkADh41Mhoo/MB9Ru3OlknG1zQNfgspeuqHh
	EDxdOhF3MFmsMukapz724IdoN1NmPK4pxh1Naz/l9okrsoL0sszRzp/ZnhXPd2p7i4ae1Ku9pzi
	+zUokqHRsayino0/ea1ntIHoRl31Q2QUwDSKhQcZiUMDoCjVNJIQyKKuT/IvIRB5LWarU0LUEAn
	GtZi0SbDuf2JbnNnEsPvsTuIOWfqIbgZA2uG/pUq4FFdXLu/VNRjptk+b5jd3I4627rlBCDZK4N
	9rZNJxdwP+/RKQP+ypR2vlz1RFqmXg6Rx8Y1/HAUXkK6SORN2FTGqKd/o4vUp+1MBT8rxnzPgQK
	vBtNDkHvq1ON+EOmNMZxHYIA==
X-Received: by 2002:a05:6402:4584:b0:674:6c1f:e8d2 with SMTP id 4fb4d7f45d1cf-6830b5021b7mr1031042a12.15.1778728211703;
        Wed, 13 May 2026 20:10:11 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68311670a00sm268141a12.20.2026.05.13.20.10.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 May 2026 20:10:10 -0700 (PDT)
Date: Thu, 14 May 2026 03:10:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
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
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com,
	raquini@redhat.com, rdunlap@infradead.org,
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
	sunnanyong@huawei.com, surenb@google.com,
	thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 04/14] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
Message-ID: <20260514031009.f66cgop3ctgiqxz3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260511185817.686831-5-npache@redhat.com>
 <20260512074202.10253-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512074202.10253-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DAF11C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: bhrfamqhs6g7z5raxswnphia6kjkbta6
X-HE-Tag: 1778728213-872687
X-HE-Meta: U2FsdGVkX1+JSZTz/K4lFRBZYSbyyY+fJfrcZJWSjiUTJhMv4Jgc/f24658GRh+tQJ80g1yhggJ+9TfBZ+tODIv1lS7BWsyX8/vTOu0cdpnEhbi0ULV0IiqXiL9YkODcu90hc1OuLcLm0PTnwTV0R1NH6yL3eeX/W9iYD644PupJSTkoMzxSPvvkm1BGeYATNZnW4xotoaHTpFQ+Wsr5nzJmhnTw1GQvqQXyXeKdAMSBAYMWFRV8jTeeD3OrHvNnYtQ6LYRicWtVVJMryd90DS1E8tQziTShC/NjOFXowmZ1vCbuZHQYSjdMx/QcD57KmzXX+cLed5huB5xPJLpI67Ll5Mev/XlFQRSkxJYOEGd3CL59a2ilN6edUJwzNlGUgMMtawsUUcbQ8qp06lqCD7eqlmssQRuWIwgBK4snI3Lx4CgqH2+FsqfcAqMvcjO5DrpHE30UBk2GQJn7qtBbOKeIviqScqYRTgnZn78nG/NbcION+VNyc/7VQxHauWi8KM16vbMsxEX2xGWYiL20BSjiCfQTCHLQkv0nXyp2qdKiDpwa9rHtoRDXU6ofm9mva1t0tnP/6ea0VASfx4QCq46iCb9eueKG28Ic0+Hqfo2A9Hxdb5N7Q12t55a6qErprq2Yr80QhJBXc1xd19V2HNl44dYRlGk58XqRmGFesqRHPlxmSAULLPtEH66hB8Grt+vPNSi+dyjlTBQKY75BVfNHHzbG49kZrk5UxjcrcaFTffl1fDqy3xW8Lnbiv9Dwm+d8OZVgXPja83sn9RjhUeJJ8eEgF6oHtFEUW0gL8M64mZDTj/P8EVFltiob6OlebHhlQ+mK/lynrxMWOGfAC2sLbcqGk044D8cY6DBD7TgGPg2r0yJljXgw787A1SZt+axQEcUwKij1gHEzY/vLIZtwf9yCDu7XfUDW4I88y66PufuLaLpo1t5DUKYijUh3PxwiYW0Gr4O6rrFpKNa
 H0BWZypa
 dsoSP/zQ/A4boJVhxmYXNCKarewaPpNUAW1ACjaR/w/C9dx5cOJCzPWY7OWUA+y0kkHoypeX3o2COfYGrP1B3XQVQUuyAvbQ+zA6K8ahLXoWtXjGste4DIh3PqV+SpGBbBqq8laPfokBMZK1jNBS72wyau4KFOyA33XSYXmq05+dJeDNF9ElsKesTkqRK6O9UCAkZy/+nL8mtGcYmlwRZ+LEiPw4qXBbEInqRKHdL1p4wkzy0B2p8IT189Wa4qg46uFUaAHwvkS6m3Pz/byZQ7YzJGEzW27ZB9WmXGeTB7JFSt3xQODvqjUkJL+j0xg5iP2DBFePFg917KF+H5At9L3T2wX2xJgl4z+9WzW71Dg7A9bn7Njt3GzIl3/prqhpHCtB+IsE8eqNvPdldSxcpmRp+nL9ZrlYJY0hS0C/oZdfA53Z31O7ADf6p1+1DA4FFhCB5J8Zu1GjFzO8R82BKfFtrVmu+nb2b6b8yVtiXokBXr7/6o2fPTmPzWWEJ0p9nxcNcjXEYFreOTNZbGAdGP8XoeHd6GFdAZwSgGvU1Gnj46/itw6G15/Zy+cG8A1xrkDbpIfmfnoxf6xlqwNl5+tUfFlOkkM5F4JHYfqtp1bKV/o4SJuCqoAuiAKp5+2Rdt/dijJ1aa9wi761PxABtlTUYMOUQk3Re6LEjoc6Voib+6GqRzGJ/pcYNx3YQNxsIZo7dS5tFp1RvK2c2eLEKv87fJeyLKC77m6BghrRz+AEaWUB0MoGBv8LdCTH4PfVyyi1chHTvqpyfRj12y0CZm5Ka3YdWIbMUDxMKTJn3/ZEl9IrtT57XADqnTr634IH7p87+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 03:42:02PM +0800, Lance Yang wrote:
>
>On Mon, May 11, 2026 at 12:58:04PM -0600, Nico Pache wrote:
>>generalize the order of the __collapse_huge_page_* and collapse_max_*
>>functions to support future mTHP collapse.
>>
>>The current mechanism for determining collapse with the
>>khugepaged_max_ptes_none value is not designed with mTHP in mind. This
>>raises a key design issue: if we support user defined max_pte_none values
>>(even those scaled by order), a collapse of a lower order can introduces
>>an feedback loop, or "creep", when max_ptes_none is set to a value greater
>>than HPAGE_PMD_NR / 2. [1]
>>
>>With this configuration, a successful collapse to order N will populate
>>enough pages to satisfy the collapse condition on order N+1 on the next
>>scan. This leads to unnecessary work and memory churn.
>>
>>To fix this issue introduce a helper function that will limit mTHP
>>collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
>>This effectively supports two modes: [2]
>>
>>- max_ptes_none=0: never collapses if it encounters an empty PTE or a PTE
>>  that maps the shared zeropage. Consequently, no memory bloat.
>>- max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>>  available mTHP order.
>>
>>This removes the possiblilty of "creep", while not modifying any uAPI
>>expectations. A warning will be emitted if any non-supported
>>max_ptes_none value is configured with mTHP enabled.
>>
>>mTHP collapse will not honor the khugepaged_max_ptes_shared or
>>khugepaged_max_ptes_swap parameters, and will fail if it encounters a
>>shared or swapped entry.
>>
>>No functional changes in this patch; however it defines future behavior
>>for mTHP collapse.
>>
>>[1] - https://lore.kernel.org/all/e46ab3ab-a3d7-4fb7-9970-d0704bd5d05a@arm.com
>>[2] - https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat.com
>>
>>Co-developed-by: Dev Jain <dev.jain@arm.com>
>>Signed-off-by: Dev Jain <dev.jain@arm.com>
>>Signed-off-by: Nico Pache <npache@redhat.com>
>>---
>> include/trace/events/huge_memory.h |   3 +-
>> mm/khugepaged.c                    | 117 ++++++++++++++++++++---------
>> 2 files changed, 85 insertions(+), 35 deletions(-)
>>
>>diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
>>index bcdc57eea270..443e0bd13fdb 100644
>>--- a/include/trace/events/huge_memory.h
>>+++ b/include/trace/events/huge_memory.h
>>@@ -39,7 +39,8 @@
>> 	EM( SCAN_STORE_FAILED,		"store_failed")			\
>> 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
>> 	EM( SCAN_PAGE_FILLED,		"page_filled")			\
>>-	EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
>>+	EM(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")	\
>>+	EMe(SCAN_INVALID_PTES_NONE,	"invalid_ptes_none")
>> 
>> #undef EM
>> #undef EMe
>>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>index f68853b3caa7..27465161fa6d 100644
>>--- a/mm/khugepaged.c
>>+++ b/mm/khugepaged.c
>>@@ -61,6 +61,7 @@ enum scan_result {
>> 	SCAN_COPY_MC,
>> 	SCAN_PAGE_FILLED,
>> 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>>+	SCAN_INVALID_PTES_NONE,
>> };
>> 
>> #define CREATE_TRACE_POINTS
>>@@ -353,37 +354,60 @@ static bool pte_none_or_zero(pte_t pte)
>>  * PTEs for the given collapse operation.
>>  * @cc: The collapse control struct
>>  * @vma: The vma to check for userfaultfd
>>+ * @order: The folio order being collapsed to
>>  *
>>  * Return: Maximum number of none-page or zero-page PTEs allowed for the
>>  * collapse operation.
>>  */
>>-static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
>>-		struct vm_area_struct *vma)
>>+static int collapse_max_ptes_none(struct collapse_control *cc,
>>+		struct vm_area_struct *vma, unsigned int order)
>> {
>>+	unsigned int max_ptes_none = khugepaged_max_ptes_none;
>> 	// If the vma is userfaultfd-armed, allow no none-page or zero-page PTEs.
>
>One thing I still want to call out: kernel code usually uses C-style
>comments :)
>
>> 	if (vma && userfaultfd_armed(vma))
>> 		return 0;
>> 	// for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
>> 	if (!cc->is_khugepaged)
>> 		return HPAGE_PMD_NR;
>>-	// For all other cases repect the user defined maximum.
>>-	return khugepaged_max_ptes_none;
>>+	// for PMD collapse, respect the user defined maximum.
>>+	if (is_pmd_order(order))
>>+		return max_ptes_none;
>>+	/* Zero/non-present collapse disabled. */
>>+	if (!max_ptes_none)
>>+		return 0;
>>+	// for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
>>+	// scale the maximum number of PTEs to the order of the collapse.
>>+	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
>>+		return (1 << order) - 1;
>>+
>>+	// We currently only support max_ptes_none values of 0 or KHUGEPAGED_MAX_PTES_LIMIT.
>>+	// Emit a warning and return -EINVAL.
>>+	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %u\n",
>>+		      KHUGEPAGED_MAX_PTES_LIMIT);
>
>Maybe fallback to 0 instead, as David suggested earlier?
>

It looks reasonable to fallback to 0.

But as the updated Document says in patch 14:

  For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. Any other
  value will emit a warning and no mTHP collapse will be attempted.

This is why it does like this now.

    mthp_collapse()
        max_ptes_none = collapse_max_ptes_none();
        if (max_ptes_none < 0)
            return collapsed;

>max_ptes_none is mostly legacy PMD THP behavior. mTHP is new, and any
>intermediate value in (0, KHUGEPAGED_MAX_PTES_LIMIT) would implicitly
>disable it :(
>

So it depends on what we want to do here :-)

For me, I would vote for fallback to 0.

>Treating those values as 0 feels like the least surprising behavior,
>IMHO. It also gives mTHP a cleaner staring point, rather than carry over
>all the old PMD knob semantics :)
>
>Otherwise, LGTM!
>Reviewed-by: Lance Yang <lance.yang@linux.dev>
>
>>+	return -EINVAL;

-- 
Wei Yang
Help you, Help me

