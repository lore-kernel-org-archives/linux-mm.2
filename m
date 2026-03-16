Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D928DF506D7
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C016B02B0; Mon, 16 Mar 2026 10:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A236B02B2; Mon, 16 Mar 2026 10:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3460A6B02B3; Mon, 16 Mar 2026 10:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23E3E6B02B0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:15:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8299160274
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:15:27 +0000 (UTC)
X-FDA: 84552123894.07.C3DDCA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EC8BB18000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:15:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BowH4afH;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773670526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fl8JvjgcLDK4j+UfwfT33Rdw6sd0dXM6mZ1n3xvVCkY=;
	b=OGuxnsXqP4/w2xXzgpcDMezm0kvqRS/xhX8MXknzPI28DkQYjNA8Ma3TP9tdqE+9S6Zoi/
	mIQnIu6cZbCh4a1B8fE4C2s2fZyJVw+8VUYY52OrV036X5Mm6wVyTXSTqIaFJx6fccWZ59
	6h8yYPG5EX6Mt3KwAfdsq0rH1AwE+6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773670526; a=rsa-sha256;
	cv=none;
	b=YFhthQ8RZHwWVmdeTzLp5MTFrMsXsfiA/fDHliBsF3Xjl94UeHmSWjU5R+dyEvgClH40mq
	JilFxOgE80K/2NfgMn55XYVHvV9RXmLPQ/hGnB1tBgxCAyv1PM7ZK7Rb0bEOX6oTOvTwk6
	npokDSnTECUNtU8OfF03pWrIrVuo1lU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BowH4afH;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFAAB43C59;
	Mon, 16 Mar 2026 14:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672A1C19421;
	Mon, 16 Mar 2026 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773670524;
	bh=AMYLIbC0XsyIeE592yVqLMzFEBrfw2qSx6eHBAsjStk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BowH4afH8xNOvUvPXoGnX3QiYu8G73nqHWtCjBoZU+TFzL04LqlcQ1DpKNBrWW3FZ
	 +QX4rLlHxR8sluW7mz9nTROilho5xtAEMDGtkUjYE8UicGlscjLRmfWhUjdjoyvy0h
	 t4w8HKjV0QGMecNN40YAKUHsKE9rLtQGt6JspdvvYpstALRuhCUTjCTljy4MNEDoQT
	 oVDVC2Ymws8d8S97UvIvVqQ0YJCKNcfOG23HdZNoUk3z+yrYp367/8xA5lpl/H0Hos
	 g5XFzt2ffsv8ex0HQ3AFCpSv+PwNvKGJ+fVx9kQUco0SG9bhb13I7h9CngzrwMTuv+
	 QwRj/MDzncpYQ==
Message-ID: <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
Date: Mon, 16 Mar 2026 15:15:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC8BB18000E
X-Stat-Signature: yrtika9jwooaj87ryib7eqhypqq4qpdj
X-HE-Tag: 1773670525-345283
X-HE-Meta: U2FsdGVkX18QV3LJ+k3X7ufEkqwKStDJY/y3DYgyd/mORwRNF/SljkcbvG45u3d5pe0/vQzzMpus8nVSejEYES7uTnSKiFsFlvBgJaodRs5FZjGoBw8n0AOThw4RsQnK6kZVJssu2kgjEY7bh3otm4gfGuN79CsX6XZuYWtKvddGRYZikEK+0DObvTNlpFJaYSZR466GLqDUk0snk0ZEPsK02iVBNhx4ZFKzanQ448EbEv75SMe2h7K0/6sLjdy7D2XY3IvvbGNpbMrT4d9/g8/PnEMnGhNU8N3DbyPWsHSv8A2YljgCgLZ7/vSxDiT7zaAIAMrrxLMk721M50P7/sIaRMOyFppF+Njk217/eqt1bRNoOt14zj9zuzyU8TK0bBqKxrJTXtJ/Ae9ceuhu9YSoDC4zqikMlse1/6ZM+a48ebI6DpoKRIjc7WCoGp+bn5vmtfd2NSmJpJycdYTcHSo7E3CMOXXkGbesQTduuKg5fnwM5u32fPL6MzalQepX7g3A5Rqatpb2yt0xHJVE+v/Hjq6J1vYIJckmJYB86cm2BviJTqFNGGHDgBaSz7sFdqDkoxIupVLvquEs5w/VO+Ry0fo3gjWbGykkjcF1tGCHTy5DGyIuJOqCkBIg26KEcxgIippiWo9h2e0ZdvSmng6nzEnOaA1gATjdrMcVkeCVfjX41RdqIxYJuUJT75vZoEzFkdK2JS2B3kogXxlFcp0Xb677GYy5CVHZ9QHD0dOOeEios+Vq25okkwYJU4zWmmU0rSF0oEY8hDaa6rZ4S0vIBxHWxbeoW9ROE+f/QmXRaxEp0Il+zVRo2o0gdEpDLaHwvDZil42RO4FkH5Y53cOMEUmcmmbag+AcrDMrbd9PxnkkdtusMTYuB11crXucJqWruaa0lb+DE5OWMxGp1KKlr0DE8pAsdXk6kfShBpBBDn2GhHjQ9yGfljh+mVDkTGv6Q2aasQkw/CS407X
 roRb6S7y
 uMRJdf4yvMjD49eKM7G62MKiCmUs7qkqbWcCTK2S7Vr3xE8wiPDTgVfiAqaCb9M8u9aD5eEXs5YrBrv4nXV0KzyzBilcaq2QnB5dJ2bWB3rQDeMKgof5FQ3KyzFSgFaJ/AA2aT2/XfHzRqBJNJzqswY33q9QR1SIxYOr6N0/yhPuwbV6kbAY9LeLaXCr3CgDjwqZJkvH2V9nIvO9glT+GzVyQ5+UYHW5B3Pb473M31Sk4pgLlWbsCZ4OBZ68JPcHL5ybvv+FFkSzIhVVTAXVd9B19xyAQSiUXCVk6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 07:25, Baolin Wang wrote:
> 
> 
> On 3/10/26 4:17 PM, David Hildenbrand (Arm) wrote:
>> On 3/10/26 02:37, Baolin Wang wrote:
>>>
>>>
>>>
>>> I understand your point. I’m concerned that I can’t test this patch on
>>> every architecture to validate the benefits. Anyway, let me try this on
>>> my X86 machine first.
>>
>> In any case, please make that a follow-up patch :)
> 
> Sure. However, after investigating RISC‑V and x86, I found that
> ptep_clear_flush_young() does not flush the TLB on these architectures:
> 
> int ptep_clear_flush_young(struct vm_area_struct *vma,
>                unsigned long address, pte_t *ptep)
> {
>     /*
>      * On x86 CPUs, clearing the accessed bit without a TLB flush
>      * doesn't cause data corruption. [ It could cause incorrect
>      * page aging and the (mistaken) reclaim of hot pages, but the
>      * chance of that should be relatively low. ]
>      *
>      * So as a performance optimization don't flush the TLB when
>      * clearing the accessed bit, it will eventually be flushed by
>      * a context switch or a VM operation anyway. [ In the rare
>      * event of it not getting flushed for a long time the delay
>      * shouldn't really matter because there's no real memory
>      * pressure for swapout to react to. ]
>      */
>     return ptep_test_and_clear_young(vma, address, ptep);
> }

You'd probably want an arch helper then, that tells you whether
a flush_tlb_range() after ptep_test_and_clear_young() is required.

Or some special flush_tlb_range() helper.

I agree that it requires more work.

-- 
Cheers,

David

