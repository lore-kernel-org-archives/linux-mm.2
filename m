Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFF9CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDEFA6B0088; Mon, 12 Oct 2026 10:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F2A6B008A; Mon, 12 Oct 2026 10:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A570A6B008C; Mon, 12 Oct 2026 10:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC256B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:39:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0EF980EFB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:39:11 +0000 (UTC)
X-FDA: 85314231702.17.4AA0285
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 08E7280011
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:39:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iH40Umjh;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791815950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLXQQqc/egNsongSaLeSgIyZvxykFuMbEUMiXx9Ha9c=;
	b=V2hyJ3c6RlUvH50YoCYtF5uvzlrRwO57xRBYce6bUO4fl+JFoIi8KH3aH5K7ygV9hX2hmL
	KWR8ZOkmeRbJA+6xwrcZOv40FlmrhkhRhAhLjJmVBPFdHdpdWl9AN5PSOISqw0+7T9fbtL
	LPTbRimIKxOJRigfwqYb9od6qyj6foU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iH40Umjh;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791815950;
	b=D2MjaByVC3Geu1qhUlmVybMT6KJYucU7sGPDGcx8wyYhqAgpBwOBfbVb3tdHUqzqZ0JICA
	pnvNg897RD4TXSJn17DvNiH1khHGZcQWjjlj5/O+6XK5B75qGkkhObtGIBzMudRJ4UadFp
	qhvoOpxWN37Z2xAPCWE8PRIewmPYgAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03EA7601FB;
	Mon, 12 Oct 2026 14:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420671F0089B;
	Mon, 12 Oct 2026 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791815948;
	bh=FLXQQqc/egNsongSaLeSgIyZvxykFuMbEUMiXx9Ha9c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iH40UmjhTF+s0urBLJSMAboPHQ94REBmJeluZYIH8PfuE9fWIKJNObP8vQvLd4vFL
	 6RaKKQuare0++D11+YxNpKc4DYDFY/L57qzGR5L823C7CPhPDZ/3VeDH65XHWttrak
	 ok9Ud1gSP5Xazy1DayOwS/85mCH7EId1/XMTruM8o3zD9gxAXh8Wsjq4NBxlK79aR+
	 mvwCOhMN2i0+k2c+kiA7ZvIVoh/6Yo9PSJBYqfF19LPdfHRUNpWl87W3POUwR5Kj1e
	 RGibe0RF0oQHiGbtULxK3bl2ykXJsnii3mLyRQSloEvzdTDXDZITpaJfjOcXN3nPBF
	 74HObGFI2ZPdw==
Message-ID: <5a52d615-8eb0-4ed1-b63a-f9016041a23a@kernel.org>
Date: Mon, 12 Oct 2026 16:39:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
To: Zi Yan <ziy@nvidia.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Kyle Zeng <kylebot@openai.com>, stable@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
 <asy445BYRhcsGDE9@gremlin> <8B17F897-40BE-4834-8078-949DA951B46F@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8B17F897-40BE-4834-8078-949DA951B46F@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08E7280011
X-Stat-Signature: 17bu9nur6dzcr6q3yqnue55pjoxqnbfq
X-HE-Tag: 1791815949-300397
X-HE-Meta: U2FsdGVkX1+Zp2ND30fitNyM5nBr9eNfFReP8e5eJTvEpuzAOjPtp7VM6+ZrNAebuBNZfDMXe0vYLQx9Kw/YHMiL1eiYtTz6D5ATcsWpYQXpTUEqNfwnVemDUl4yxFpCL9ZDiCxZuOeuyLUj+uoCW6CWpLkic0BaVU4oPLkJHr/XCreUCh5z7dF2OX+Tigb4Fx1s7OYd9HGwrqTAelJeX6p50SubJsfC0D1/HyvL+Y235i2/Rvj+MLXy9UkCRd5u8bisp+V3aLQ/rrj/1S1RIqo16wfstHJHbaH+DvQ3MCpoupCyUZK+7pk0M/MYQ86r0IR5xDs0CibLKm9AqMdIUfTiNqlreTKB6IVxGsPpG0skF7JhaV5qopASK3yK5NjSW4Bdy9ExAyrqk9h8TNiJOvaM2B7evdlx63ND+Yx+SLCpdFDfyn1A5MwsVz+S8Uy9uonNEJW8+7aNT2InnMxKCqUz5Rn1vcCpuucUEHE65Lqd5LRxDDisc0hMg4mO2Kx+rx/Zmc1PpPny28ucs7qsIfIdd91LdKgErYz049hFeGVQ4/ywItbjeUyRY8SZCI4Ki0qv3sC6vIePZ1XkkCjNBR9X8GNYJr/JDmTsBPuDLzhVgMYfFfA6GpBDTdOiRNIAPDc8To6mNlj+BKffu+veIqCYN5jYsXCx8Aiojfg0BmK1aFTZt3s3n9mvPvtwxK1NazKluHslGDHxFPvRCgc1AfKHs68MNqxsD6NjYGTfxBlARYwc7WW7lHhgef6VKLgYSkvQFBVItK0QMvI7E3kglAauRjEDrKhPfdQSmEJamG89ZL92ayEYfWiDG5xdGO8ZasykZA9fMTgUph6mmKQ/uryp0DyxdsrFrWyRcLbGn8ES9L0ALKLn1kchk7z/YbJsgKrkWcflceX7ecPm2/pjhW4AarB2oh3kmRm+BfKTEBt0XsrHhcrnKL4QDdZr08PGE8Zbtddp9N9e5JrGDUG
 Cmi4HaNP
 zqQR1nYstG5SDv3XI4dYaXvE2VI79tnaN/OOhnoZKMPKCIOwwC+ztG0xph8Xrp9IztzdOQZATiOr9WDDnIgj1wW7wV/9c+yrTMZko1GQeAp/r+dHUZY27yuHZM4ROdZONETeo547JqH/M0yTqg270/Lk7LZ1NOBbkeTOPjtNIsEwmKhXAGFC9Q/WCtK+C0YtaK/UeQGSFp99Po9GOvPvbQt/3p7BjyuOrS7/A2aCmSHZ1uN4qldQ9qMX+cvvDgri8NUTG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>  		}
>>>
>>>  		if (!pvmw.pte) {
>>> -			if (folio_test_lazyfree(folio)) {
>>> -				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>>
>> This is the only caller of unmap_huge_pmd_locked(), making that and
>> __discard_anon_folio_pmd_locked() dead code, shouldn't we remove all of it?
>>
>> Otherwise we're leaving dead code around.
> 
> 1) it keeps the backport small, 2) I am going to restore the function and
> this reduce the code churn.
> 
> I can remove the dead code if you think that is better.

Leave it in and let's clarify that we'll restore the functionality shortly.

-- 
Cheers,

David

