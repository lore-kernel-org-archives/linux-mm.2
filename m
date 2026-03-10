Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3118FCC9D6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E36C6B008A; Tue, 10 Mar 2026 04:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2915C6B008C; Tue, 10 Mar 2026 04:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169656B0092; Tue, 10 Mar 2026 04:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 064316B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:25:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7014B13ABEF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:25:27 +0000 (UTC)
X-FDA: 84529469094.27.856D34B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8A94C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:25:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r32POjOe;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773131125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHJq4KelLjAoOh+51saulXchJMVfwghNW75QUv1kWjU=;
	b=fagPs9BowxgwQmG/2Qctb3OAE/Xsz+lrIkRS6oh2f3HbownWIj6ylOdJOm5HxlEtOJb8dr
	aEruXoXX2FSUHmYvY178z0vfq6fNTKu4HcCZTDpYJh2P1tDYVJkHy2jffQDoTn7vh14rxI
	ZbbI+MtGhxabW5An2eNwDg3OG2gynpc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r32POjOe;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773131125; a=rsa-sha256;
	cv=none;
	b=2YNbUVVoWlsTYDAdSUqi5AeMQNZnVvuSa/85y+WKQzbOkOpOtk3eJcIGiC3supsZkUzvTO
	MyYnTJDhn9xoQWsJ9a1pbbk1lCXhX2pSC7OEePpLgeKut4b6ou07lNa+P6mwDSIakdwynb
	lfguED3p/4t7VqjTryoLeNS0krANLYo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F1CB600AE;
	Tue, 10 Mar 2026 08:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D579C19423;
	Tue, 10 Mar 2026 08:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773131124;
	bh=3mkGCn1+SE6g3BjC4GosyHZuWAmHGngGuk1f3nEWOZ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r32POjOe0rj5ODQJl17XFaTxfn1KO5JF0+dr/nQ2Tts2YH6vMre+CwtuFtH9oLRly
	 txV0zmknTNme8X1zFgHE5PI8KxGEUm7MF+f/hUgyQY4lZRPeaYduZYjhGrAhoK4UMJ
	 c/sby567r6k8FCJUZ39iOUgKz025M/doaL3azCvfxB2zfn5wX//lTfzns+wItUMmPe
	 8/mTfv0nKphrYrvkB8NQHEA4HrS+/ppFbhIbUY4CDL8X9zn0lZknEQHQ+vECXKdv3o
	 tDhLowMijFdMDdw2ZIw/QiX2hAyHw5EOvnLO1BWMZIER8TazRL/2mztEtxkDjrL+7W
	 JRFLa/BMc5TdQ==
Message-ID: <4becce7a-af3e-4f29-a233-71d90f653daa@kernel.org>
Date: Tue, 10 Mar 2026 09:25:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prevent droppable mappings from being locked
To: anthony.yznaga@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
 Jason@zx2c4.com
References: <20260306204550.8405-1-anthony.yznaga@oracle.com>
 <7c1db5ef-2457-46ff-ab20-dd4090570fb6@kernel.org>
 <7c4a45c3-298a-4a72-b551-ec687898b4f3@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7c4a45c3-298a-4a72-b551-ec687898b4f3@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8A94C0005
X-Stat-Signature: 3hke33k7htjx61asuwif5fpa7ygwrugj
X-Rspam-User: 
X-HE-Tag: 1773131125-330065
X-HE-Meta: U2FsdGVkX19DZ66DTR6o8QBCYHw1nziawW4QuvFn8xNlydxh6X8Qydj4/VrXth3vsPuBYzYmPpm2iFcmFDwViQolT+hfdTrxXAWodHS20hS2P6qfY37uUM7OIIsyWBiTIaI9SXQs4oB1Zp4v3uIm+j+0THCv0cYzV5QCDqz2286V1TwD9E8nD+OFMuAKjujI3AbgsuuO16JWlLIcuyGdDA4i/+HSmlkE7y1fIfZ2/p10R5QDNKB0uWyc2yIyMxN2qpsdFc404Eb8HYbKO5eAKm3s2oNAYFqtYcB9Ln5QUvEDOnaCk3cCSpivCTgBulTOLQ7kQkial4nhM+RQhy8fJLe69MCBiu9UK22yWnYsB9uel6OKrzUN7v4BVXOICqLVeiLwvfOAFSkGgxiXsO2e+BEB78CpnmMIqpD8pXJojRC+XAyS/4GAXHulkSFEOOioCTCTsT+ssGM6TNXD1g/5hws8ANMSah32g+GdtVrGDTP45ztcN/PCR5iTDsM/oL3u/ChTc9PKvzxJmwMT5uPR+Ts5n7dmKX0lH/Ty3kH3+lCGLblufE1zG6vVpHDSd/K9NYIBhWcB3YWYnOnBg5LD64aPlLkhuUxrd+lmqdIgCPOslaeCeJ2g+UgWKi9P9MNFwtFCftZckjlRPl0RZ3LlDK5VoDkHIhJEyEJcMLpG9HtIJRVUGHHkSlGhb61ciJ5mKtfxHrssCUQebzv2+rzBrNe5R92V7iSjKD2BOfyubldl7FAYbMsOWKLEgFz13tMlx/fb6KeV2AGKwrCbz2HfBNNzRY8xe9C621yhfaJzUHcOi2Q4T/Duk0Kl9L6Qk0HTBCqs8xFvEiGsTCOPDGERy5GNxeDa+RlGGzhTwIojl3++hL6C348qDnIYPjoGX9U8/UhF8WBR6nH+61sPWJgwRd/eQLXNTmtndsRMr3D3DTrosIuiVXELl6MIpGbvDCP4cn21MCRRYNumFmm2ULg
 R7nWP6va
 5ZEgWs47ugeHH7Z4yJRa5/FP1pBNKusnT2KjUp4juk11NUZ+/yKWh/8UEoDIVwywXvUrzobO+6CNUj2I0v56EPf/a0mJ6AwDuaewhXHY4bC5uEt5E4sOKJ3KagnyKc89Gvab7vh9GzwWkWX6prg6I3EvtTL3eunfeYHm1Mm8cPCcKE5k0Z5u7jyn6r4m/wPRZ8IPChsfw1l66vUlU6HkFl0reC7v9lrwhQgKChBLYXhCXLJd5RbwBDwZoOVreFI45o1P7vXcZn9bsIraPBfIyfnpYbCOvgf6UxUlfJODd/Mq3GKuJBWotEfy9k9fx1jQw1sPFlyzYrMMPEQjH4FiZJiKA+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 03:04, anthony.yznaga@oracle.com wrote:
> 
> On 3/9/26 7:15 AM, David Hildenbrand (Arm) wrote:
>> On 3/6/26 21:45, Anthony Yznaga wrote:
>>> Mappings created with MAP_DROPPABLE cannot be locked via mlock() due
>>> to the check in mlock_fixup(). However, they will be locked indirectly
>>> if they are created after mlockall(MCL_FUTURE).
>>>
>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always
>>> lazily freeable mappings")
>>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
>>> ---
>>>   include/linux/mm.h | 3 +++
>>>   mm/mlock.c         | 4 ++--
>>>   mm/vma.c           | 2 +-
>>>   3 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 5be3d8a8f806..bb830574d112 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -574,6 +574,9 @@ enum {
>>>   /* This mask represents all the VMA flag bits used by mlock */
>>>   #define VM_LOCKED_MASK    (VM_LOCKED | VM_LOCKONFAULT)
>>>   +/* This mask prevents VMAs from being mlock'd */
>>> +#define VM_NO_MLOCK_MASK    (VM_SPECIAL | VM_DROPPABLE)
>> Instead of adding that, could we cleanup further by doing something
>> like the following?
>>
>> The usage of "vma->vm_mm" must be double checked,
> 
> This sent me down an interesting rabbit hole since gate_vma->vm_mm is
> initialized to NULL. I can't see how the gate VMA could ever be passed
> to mlock_fixup() or __mmap_complete() if it's not part of the VMA tree
> of an mm and is not mapped through mmap. 

Right, gate_vma() would be shared across all processes.

Wouldn't code like the following be questionable as well?

fs/coredump.c:  if (vma == get_gate_vma(vma->vm_mm))
mm/vmscan.c:    if (vma == get_gate_vma(vma->vm_mm))


I mean, that cannot possibly be true unless I am missing something.

There are a couple of other
> places in the kernel that assume the gate VMA may be encountered when
> iterating VMAs, too. Am I missing something? Happy to clean these up if
> it makes sense.

Yes, please look into that. As an alternative, we could maybe pass
current->mm to get_gate_vma() ... but it'd be best to just clean that up.

-- 
Cheers,

David

