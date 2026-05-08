Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF19CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 10:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B956B0140; Fri,  8 May 2026 06:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212736B0142; Fri,  8 May 2026 06:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128AC6B0143; Fri,  8 May 2026 06:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0249F6B0140
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:58:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4D9D1C160F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:58:42 +0000 (UTC)
X-FDA: 84743954484.13.C6DBA4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 00B90100002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 10:58:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRnDcjoA;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778237921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObQby00764yxZ+aMvNZotG4s44O5fwOk0zHFNI2S6No=;
	b=EOwmNNezMfQdBA7stDuSnBwKqj8p6KXB07cazhPkDvyDMNx2P+i/lyoH4/MIYXoP2BNavV
	xn6CtdmKqOeLAqK2SoYJ+JV+p4m2DqG/G68oADcFfQ+i+/OFZJkvlSPOT12zezdEv6fUhb
	wsRPnRKTwI1kWbq5BZSH9sJIADub/dI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRnDcjoA;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778237921; a=rsa-sha256;
	cv=none;
	b=6fRqXOp0eRRBJ4UCkKcROig9akqijALoABRF1brQ+wHH9skHt8rc5wu4HTBk67LFA57jYe
	JwMA4NkUPBwQGuwxfwSsWJtUJ5vmhAnb2oY46Zp/L+BDShTifq7AwlP7rUm4g79MGWran5
	nmXhC5kMfvADZes9LSGJ2w8Zd8p1M5k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B1B560052;
	Fri,  8 May 2026 10:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A2BC2BCB0;
	Fri,  8 May 2026 10:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778237920;
	bh=S59UBbH+ZLEy2OAA811fhr/mLyBXtU8vtHsvcNkbvFY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=QRnDcjoAmG5/ULzMWOY7X1jV0sSv+hOHKKEZsTR1f6QNKIQL69NBnChoUrj0Fucn6
	 7zvDZnDrD5itCv7Otgu+f0tse5KowMZFsfAA7v8hxAes/XxMioazCJYp9HN276d6P2
	 VkL8hWaUaXWW2/2IgHu1zzmdUQSvGoQqz2u+9nRef2KTnoIS/Sb/6rYgDnL2aLDuRt
	 Xo67qYI7luSkDYF1cXk98Im+oQP/goggHCqOTfuUM9MJZcOi/97ZBremb78u0j0wUy
	 Mm/qSkOZYMl0EAZHUynPW7nL8qfNvi9QJpGbeTCoU1q5mtuRWrC96JDUIkm30EllhJ
	 nbA9u4QORLDqA==
Message-ID: <36346c42-2557-431f-aef5-0f92b0828e76@kernel.org>
Date: Fri, 8 May 2026 12:58:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm: Make per-VMA locks available universally
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181955.0C443845@davehans-spike.ostc.intel.com>
 <a07231f7-c5a1-4de0-8d4a-459d5ecb5676@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a07231f7-c5a1-4de0-8d4a-459d5ecb5676@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00B90100002
X-Stat-Signature: enejoncncia6qgkni957piuqkb9aqg97
X-HE-Tag: 1778237920-840937
X-HE-Meta: U2FsdGVkX1+ZmwN97aQmfRIo5kTFYZkCLjKmD8CbpVV6jFo7eT3/E98EvASLncrHRXmGDZzkjBRTEw01PUGyeRpmNmhAyRAjEMAj80dxe8vcoG9ZAJP1qVqCAwZhV3iKm7C5F4ynbC3g57s1kyQMJqSTQ66AupuqTVCJBqd6fw2HjUa/rkZyNU+FynEE7hxD94L2ZshN54cynB5HA3f43lXgb+CqETg02amoqBMYPzKWBw4rYfgsQApSEZDZ/DXWiq3asVDKcK2aCNUCfKKzk7MiAscykcqDrZqxJal7P9IfPxLUDsOQWgR9tA0nT5sSBinwFj7JOjcYiddynm46zWTA8GsLdZgyvpQsOw127EEla0DBDl825X/Cvebis6Uz9YD5gZcGS8DWQdle05hf3k34ranonbDixkHMVUCpmpFmbvkqhyaEvt7hV5vum7dc6j3te6XSIqTeN2DApFpJ2oMaKegqnacD44MoJAyAc5ypOWmJJu69t0O2ibOyMx9Xik/VvE9T3ABo58DV3xUBuSRdtOgaeHEGhjBQ90pgjhBeUKJweGHOfaxgBvTb/+FogC+roUiY7qgJADnXKLuw9RXB7Ro+XtR6y2XSZMmESdzKxtLdM06rQsIC6M23u9m8GZgiMBOqqTA18UjIYgx9w7jsFXtTHLsAvxVWMDSYdyAGju9AJDmoyFj1juCUI+3uDpZ0y0fP39TjyhLFHhixrI0INk3q9J4rn+UBr82dgrBNq8S6yjHbsfAva7fAdnZfpUYf5v3IEXVCiY9Mri+OH/5187Xop9bfKx4JBe5QoVzbdeXAUKF7qfsfmRe/jk2eO3hVK97StNzzOmRr4R+G7VxWm/7jaADrq4l+E6X+0VTEdTsdX1a50VhhOTIZ88QlvAe9YOxMf/NhBawGO0FthR8ECZDAG2Sf7wToyOq/0qq5VDVhtHCV/2UlF+CvZcs5sX6NGWEQtDReqkvxCvM
 5zAHOgy3
 9ASon3V+y5PL5p7ke9VQ2aDXbMOpFyXpwTz4GibmjFHIYn8krzy1GicCOy1klsowZ3+xDU6heseTrpfwkGxxNcPeGkybqJR09HkOBZQLU2TpjsWflMH5ndLM0ZPIdyGp8C8Pa3rQ3yyPiaXJwqzEVejEEq0kfDGmMjcu9uz++PfH4DRhYd9Bq7QS5E8NDoEPQL6ni1lO0NcK7gErPCfGvimkVaqZHXiAwR9zW5Fa1gindt38d7guHWFd+kxOyBUqAagPt1BdGA/lXSRkfaRejrw0T0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 12:12, David Hildenbrand (Arm) wrote:
> On 4/29/26 20:19, Dave Hansen wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>>
>> The per-VMA locks have been around for several years. They've had some
>> bugs worked out of them and have seen quite wide use. However, they
>> are still only available when architectures explicitly enable them.
>> Remove the conditional compilation around the per-VMA locks, making
>> them available on all architectures and configs.
> 
> Yes, we should really just make it now just a fixed part of the kernel design.
> 
>>
>> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
>> when the architecture started using per-VMA locks in the fault
>> handler. But, contrary to the naming, the Kconfig option does not
>> really indicate whether the architecture supports per-VMA locks or
>> not. It is more of a marker for whether the architecture is likely to
>> benefit from per-VMA locks.
>>
>> To me, the most important thing side-effect of universal availability
>> is letting per-VMA locks be used in SMP=n configs. This lets us use
>> per-VMA locking in all x86 code without fallbacks.
>>
>> Overall, this just generally makes the kernel simpler. Just look at
>> the diffstat. It also opens the door to users that want to use the
>> per-VMA locks in common code. Doing *that* can bring additional
>> simplifications.
>>
>> The downside of this is adding some fields to vm_area_struct and
>> mm_struct. 
> 
> I'd assume most distributions would already enable it.
> 
> mm_struct is very likely not a problem.
> 
> On x86-64, the smallest size for vma_area_struct possible (make allnoconfig)
> seems to be 68bytes. The largest size (make allyesconfig) with lockdep and all
> that is 256bytes. Without lockdep we are at 192 bytes: independent of per-VMA locks.
> 
> I'd expect that on most 64bit configs we usually end up with 192 bytes today.
> 
> Given that our slab sizes are ...32/64/96/128/192/..., I guess we'd have to be
> lucky to jump between sizes on most configs.

As Vlastimil reminded me, the have separate slab caches, so they are better
packed. So I don't think a small increase there would really be a problem.

-- 
Cheers,

David

