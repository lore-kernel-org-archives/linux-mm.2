Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB62C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24906B009D; Thu, 10 Sep 2026 11:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA8A6B009E; Thu, 10 Sep 2026 11:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10C06B009F; Thu, 10 Sep 2026 11:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F66F6B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:20:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37CD64050B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:20:46 +0000 (UTC)
X-FDA: 85198214892.23.86F4070
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AAFCC000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:20:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULpp5wXv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789053644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8HbD8dWhuAegusLFvJUvIIHTzWI/tlvAmsxEnzmne8=;
	b=A7aKe4+A3PzRbRWw0z2WxiAcA53aY0Cy09XTWAtpgLx9TLP2ADDJLe3f+88GJeHfJICMHX
	XbSY3oI5gzYGKP7oRCubR/RS2rEUDUuVymWiKzpyQ0lWazyOdO7eKXutrm+4I5bgltzvXW
	wO87eVOeR9Tt1+a37CpGuSW8h7f+uE4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789053644;
	b=o9yPEKhogP9uWy68d0cGA9Rlqcng0dYq947B3g/wMGyHCqoD5368RLAJEMjZoE2+MSbDS3
	W8Ae8M+RwphlLUCU6OxBkP7fTCzrsFLAmYvK20GHpCaJNuL7P5o3ArvilaAg1yoN+J+y6T
	x96hwUHtgBjGyb03Ga29jA7sPE5jPig=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULpp5wXv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8566441193;
	Thu, 10 Sep 2026 15:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C2D1F0089A;
	Thu, 10 Sep 2026 15:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053643;
	bh=X8HbD8dWhuAegusLFvJUvIIHTzWI/tlvAmsxEnzmne8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ULpp5wXvxp8ruE57XvePuaLSKpdR7mxuUjLjxkrt7nNUZoiUjrr2PR0YB9NpSsuIK
	 ONixgaWNK79QglC6EK/DegLv3O4sZdwc5ba0lFt46T0yI2LeoUMMN9GGWXzSOnqiU8
	 Ll6/fP4rzePhgEcCjIAgGL+hPcVrzqSKDefkSz9mPc4tFXzMDYQ+cI2+VXm1lFsgHJ
	 eJqc4zlSMfKpsqnGVhfS0vKEV2f9aiKHiYK5yOBHcjBHCy6SFT/ARfmkPQaf5vd2Tk
	 1/ENCyCLUKRQRFB2x/McgPoHxywk+tA3COwfNhOShqfG56WYq6nonqulNdwEmfudVt
	 nDNADHVg4tODg==
Message-ID: <cc9eeb0b-e4bb-437c-bca4-981d6d595ef0@kernel.org>
Date: Thu, 10 Sep 2026 17:20:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/5] mm: Make per-VMA locks available universally
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
 Liam.Howlett@oracle.com, ljs@kernel.org, willy@infradead.org,
 shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
 aliceryhl@google.com, arve@android.com, cmllamas@google.com,
 christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
 davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260831203056.838265-1-surenb@google.com>
 <20260831203056.838265-2-surenb@google.com>
 <a4d74575-65d5-46cf-bd2d-dcabf2543811@kernel.org>
 <CAJuCfpEFmf0V0OuAkEPSpzYA-WScAjmNg2b6CJg7Z3WH9h6Qdg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpEFmf0V0OuAkEPSpzYA-WScAjmNg2b6CJg7Z3WH9h6Qdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5AAFCC000D
X-Stat-Signature: x33uau9zuba1tjb3nkmbzjugptumm6za
X-HE-Tag: 1789053644-55609
X-HE-Meta: U2FsdGVkX18yKnP9CI46qX4HeE9Ih2BaBKjNmPOSkZJSJ18it6Wkkb1+dJ0qZdejS10ewLTu9VISJ6paJkF4AwTmDEDkLM1/PQDEliidt2QdGNR9OWftoQZsDovvhFoMilQOdfkmWNYDRFheB8SLCXd89TtJptoIjkKkn0SOemO7zsqjT++BzrXxWZ0HY6Q/8RhNgxtvL4Qu7T9ZiWd/tIjDOix4L1kaziPhp3m2YgYAK249nAI5WeNqNAQmZ94imlTC4/J7uxkool3VqFoI9beOBmY44Jyo/8DjVZUk32+PGBCMB60F7DF3CBvbjRd41/9amQiIMdYbgPr9LhAEsdMe0xCyK5MSMoIsTnlKl9mCIiGKCaJLJ7mGMSVR3Q49S9g/9heqq9BfGdFLJAN3ZFmSsDJhad3nSraoTfpyB/QI72odnxIyzf3LYWgxxJ9IS09asx74MP4Qj03iL5UXLlYjndQKMuwwEpAIbfI/VGJNg+2RNk35jE9k2nJulM7uxaxyp0ioZ84TgerWr+YfIhY1rlySWxU2cYBH5SQdE6fMkX8gtOcw6JexW/zr4nXEtogSS73MZZYxzf3LvlhYTRhmCr55bgZa4V0ugW1Foe+uWz5oWBkOMvF6T9je95+t1CY4rBBZ5oBrGWBFik2z8w9/Jsd8hsVDmh/svrp23LeGhZMChwbwlhsArTAWOZmJ2K3KbPkzshXS5rW8XqleBFttEW30JTtpUrF0L1luNaERnw3shxZE8fgXj/klr0GXootzcvYD4ftg+J09lTh5D9qt2lNO5N0Iqm6KInCRqwykhUerniUqPoCk7EIPWZxeSPgNSqFexDM/odfAmhiX1IQ29NAfG65+1osQIamcTHE8MZa+FwvZAqIprE4YEFZeTAYiWRn/szs763y5oJz+zLTMtCISsOaezCwnql9tumfuQKD2aJcz5l/+0gbWJmTYUZkedYOuYkxby7auNgA
 LfveyNE+
 LnjjIm914t4mXf3jrmFneHnBar/sCIPaAOGhhZ3LrDI9LEujz3aqyxSu1Z4dUEmvHJvjNFDJ8IINTDpJORE6kPpFuek3auCwao3Y7lwNkzjshM7tSqPDqUYRi3tgJNhPVh6OzDRjko9mJHjk5yhOJqxyKaQ6qCkSuNt6zNF8KYcAv4K48ztIc95njzqDhd9ttnoBH1+G/AOITbU0up2BYfA4rT73MuUjqs5TAIyknAa7h1PGsHdFXqnRknaBOPwmrg8xtpS0YNUMTAK4oXEFE9AOf3ev3XagA68EyhQ2nmgLf6ImF6XActi5TTT9SJsUPoFJPerkOKRJSx1ALhBmW+zWCleHE8iZrszVZ7f9wHd5GSn1S+vtK9bGg9mjLt1+04skxcnYqHNq3srY4NT00DH0YjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 16:50, Suren Baghdasaryan wrote:
> On Thu, Sep 10, 2026 at 3:09 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 8/31/26 22:30, Suren Baghdasaryan wrote:
>>> From: Dave Hansen <dave.hansen@linux.intel.com>
>>>
>>> The per-VMA locks have been around for several years. They've had some
>>> bugs worked out of them and have seen quite wide use. However, they
>>> are still only available when architectures explicitly enable them.
>>> Remove the conditional compilation around the per-VMA locks, making
>>> them available on all architectures and configs.
>>>
>>> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
>>> when the architecture started using per-VMA locks in the fault
>>> handler. But, contrary to the naming, the Kconfig option does not
>>> really indicate whether the architecture supports per-VMA locks or
>>> not. It is more of a marker for whether the architecture is likely to
>>> benefit from per-VMA locks.
>>>
>>> To me, the most important thing side-effect of universal availability
>>> is letting per-VMA locks be used in SMP=n configs. This lets us use
>>> per-VMA locking in all x86 code without fallbacks.
>>>
>>> Overall, this just generally makes the kernel simpler. Just look at
>>> the diffstat. It also opens the door to users that want to use the
>>> per-VMA locks in common code. Doing *that* brings additional
>>> simplifications.
>>>
>>> The downside of this is adding some fields to vm_area_struct and
>>> mm_struct. There are likely ways to optimize this, especially for
>>> things like SMP=n configs. For now, do the simplest thing: use the
>>> same implementation everywhere.
>>>
>>> == Considerations for NOMMU config ==
>>
>> Echoing what I commented on v6 after v7 was already sent (not realizing there
>> was a v7 after my inbox got flooded)
>>
>> Maybe the NOMMU "support" could have been had in a separate prep patch (where a
>> lot of the description below could have been moved), making the patch itself
>> just mostly a removal of code.
> 
> Yeah, that would make reviewing indeed easier. I guess current
> structure is the result of me adding NOMMU pieces to the pre-existing
> patchset. I don't think it's worth refactoring but I can do that if
> you insist.

I won't insist, it was just commenting because it would cleanly separate the
NOMMU oddity from just unlocking it in common code and removing the leftovers :)

-- 
Cheers,

David

