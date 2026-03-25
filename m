Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A0F1109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29756B009E; Wed, 25 Mar 2026 10:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C286B009F; Wed, 25 Mar 2026 10:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54A36B00A0; Wed, 25 Mar 2026 10:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B423A6B009E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:58:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D4618C4A0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:47 +0000 (UTC)
X-FDA: 84584892294.18.21B7756
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C48FD120004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qVbsLwkG;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eO11bQx7sjhbWBYTR5ThY1PJIGNvBjQog7Wuvh14JpM=;
	b=pAc4Y58g7oKBlMXYQb/Tq4Rbc9FSuEG7wYMReLu/m2yXGW2QUp8FtbXjSA+g2DG8B6xrhx
	xwc8oBtWM7QMAD9pXiIN8pi4q09Bbn6xFAVX2CN9/m2f+iYAbjQD56gILBHhk2ikrdQFk2
	LVoLoWngmzDLxtfVs+WvUGwIVPJWLf4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qVbsLwkG;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450725; a=rsa-sha256;
	cv=none;
	b=XzQyXcuwOSGFP5EVW7SAJwmsDSjKFizFrGEy5gWuSjevgLdahOQ6JzrKbn18DPsTVwprIE
	ONxtRybZjAz5WgOV3lbkS5AHmh/wnonmMZEACnl6aG05N3mAhVqAm2wAvTRqTpD1po/pGu
	BI2s7F/zafFLWZXxsp3wtgXhalGlxA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4856D600AC;
	Wed, 25 Mar 2026 14:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0453EC116C6;
	Wed, 25 Mar 2026 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450725;
	bh=dMcR2tX4bnCEJoOrr+QTNvL7UiCnZ4AW/utzbNb95Xs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qVbsLwkGch7h/7HSMmGtaC3uNnBXdDP2+NYlx+NZvoOzV75V0RgnusAq9j7F+EQ8c
	 UNqKNUwrfsqhcVbtnWBDbLku4fdFZKeHU6foHHcc7cONdL9uzvG9d3nh85PVEsnmpq
	 Itt+ye8x4DFvGucFINKbdXeDEg/YV29W4Hr0Te3CJboNNQ3LgxGQq0v7XolbmHQUtR
	 Vc5ZNeA2AYpdOr7fvj0pS39bCUy1HOTsr3NiT3fDgtAf0A0VGFJGSR+DCHcR5a1Agk
	 c3BYc/1MYVCxQJ9w5vin0G1Tu3d2wi7vL/Al3Z/IDutB7v4fg6qnf2a3OeCtH51FbJ
	 zXd2cojMJVA+Q==
Message-ID: <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
Date: Wed, 25 Mar 2026 15:58:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C48FD120004
X-Stat-Signature: cddfx6bjdjbrwxe4pe5rzkschqp6bsos
X-Rspamd-Server: rspam06
X-HE-Tag: 1774450725-700129
X-HE-Meta: U2FsdGVkX18budLee4HUz2nmGFKPtDwQqafc6strrDlLsXdohl934PHi382j7yviH6L5eUn1Y9TSy/RqvKRPuHReqfTEpMGw4XbhR67LwncSPuKjH7xvTQnKp7ja+Nwvm4FwvMLYc3GD6K3R1coKZt4/vHc1AzjHhxVR1GTgBLGPBg+h8uX7RD0T1KSrsGj86/o4eBI2uxqLL6oP2V8qOZ3jdSOQTlkE74eH009IFAzJxPtPeGVTxVwiMRgFOLatipr9aPWpucxYWMbBlR032zxcLmZjG5eyS0rn5AdiC6hWdXQItLYyMeysNK1kCahuP3r7RCBSLNNAKB4os26uiaSFhO4KU2FsruwOZnPBkch+TaMYB7ibS+8brsRceePi1zqiJDA+LFn2bOaq10gSi69ocK1/kuMQ7piFPvQQM9X++uXt5VrFWIDSElvKpG+zUgr+yFVSxvxabe6Tn3PMqnV/1XSqgzNLo0CF1LoOntHBSsJmY+pTUXzS5aWr4j7KOgvYNI7IPSF4Ntn8+gYTWQxFYDSp9T4Ea7LImkPo+Wk/w3//CYB/a1jPRd+hz5mIDXbusA0djtyOOrb+1t5swcNtjQuG+tFa3pLbDxHSrRmchMedCebki2x36M889cE3RAeqMp25+ksqFV0Msb0e+Tx2nJ1xjc0uyI73m9hBXdEeyfD7n/4sx0yNJLD+a8FrhM84R1L5e4J2l5FpAzdwAkhEr2XTfi4N1RWYr8xzHi8wpAkPiILDrgKCWlp3wYMDgI2EZM6UtzUSsqE/sqosOAujnJAYurZGd8bmNh24IdTqyXsX4z/nH2ZGvTZl0QNsIZRvwsJAN+5h6jbse51wZlF/J/WUnGfptsj0/1V4g4/hXUpmP6XGAzQkoCVhjqsW+GewSyJhRla58wKTx8b/h2G2xV8IPQFp4UuVqhWAtDiITgQ0yFywCiC7d2SwWpLR0lefdcLTV/iwNjrJXvw
 HvgKfDoU
 F/ipqLewaSXB2teDG+k1Gz4WfEi53XnV7LpXcdaJQ7Rvh4vRqYVoSsjgMOYVak+JKLG1L9tKcilRicOTF2yabymIb1+uqhOenan0Uw1Mr7jPymB0z6vKlyHn7JhKOknAdjNPLWVjJ17YQY3V3Sw4JyALH5Vt53Hr8ILXCGWZmdVnNzHcg/+xlpyRceSZnT+DrmQpidvp5NJjM8ezqGwG84ywpNE/Kh04BDqmZwN4/SYTM/BlY1BeJWSHTeu2w2H/7+ppIPwn9EdhV0KZa5jqlCggX1lfogD+9kyBs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 15:36, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/16/26 07:25, Baolin Wang wrote:
>>>
>>>
>>>
>>> Sure. However, after investigating RISC‑V and x86, I found that
>>> ptep_clear_flush_young() does not flush the TLB on these architectures:
>>>
>>> int ptep_clear_flush_young(struct vm_area_struct *vma,
>>>                unsigned long address, pte_t *ptep)
>>> {
>>>     /*
>>>      * On x86 CPUs, clearing the accessed bit without a TLB flush
>>>      * doesn't cause data corruption. [ It could cause incorrect
>>>      * page aging and the (mistaken) reclaim of hot pages, but the
>>>      * chance of that should be relatively low. ]
>>>      *
>>>      * So as a performance optimization don't flush the TLB when
>>>      * clearing the accessed bit, it will eventually be flushed by
>>>      * a context switch or a VM operation anyway. [ In the rare
>>>      * event of it not getting flushed for a long time the delay
>>>      * shouldn't really matter because there's no real memory
>>>      * pressure for swapout to react to. ]
>>>      */
>>>     return ptep_test_and_clear_young(vma, address, ptep);
>>> }
>>
>> You'd probably want an arch helper then, that tells you whether
>> a flush_tlb_range() after ptep_test_and_clear_young() is required.
>>
>> Or some special flush_tlb_range() helper.
>>
>> I agree that it requires more work.
> 
> Sorry unclear here - does the series need more work or does a follow up patch
> need more work?

Follow up!

-- 
Cheers,

David

