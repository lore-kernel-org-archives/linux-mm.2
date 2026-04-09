Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845B6E98FDC
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A466B0005; Thu,  9 Apr 2026 05:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A9A6B0088; Thu,  9 Apr 2026 05:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708DB6B0093; Thu,  9 Apr 2026 05:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF356B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:41:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11769596E4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:41:54 +0000 (UTC)
X-FDA: 84638525748.27.E0D770E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C2FB4000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:41:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpdlWVOz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775727712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgCibSxuPoPLvCu7SqgvDn1zE0622I04U8SJUoVP1Eo=;
	b=Qt9pprIkQH9FkcZLV+C30uyPbXifkw3Jwdc1qexrB4LTXPr0hmSDREhMQg9yAttFa66GV1
	SQmewz7rFfKY8DGoRuDIG/CSpV8TgInGyn56i6IyoCmrVkEo12N3XC7P8be5okF6kkYS0V
	WaBDLkwX7IEnMvIT2NAI0BM3KLPK1KI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775727712; a=rsa-sha256;
	cv=none;
	b=53sp4MbhuiwCaUQdBNejIEW04/T2HlNjSErO5LZ48FSF8SP//r8TJJQ0s/hoZxWNC3s5x1
	4x2uYflA+++bRx+OqIyhzB2TwxN1YciG6bCftN7Ej0HDfXYjJZgIoPXYP7AsY8bluC5pFU
	f82y9EYrCEvaJiFjmFPHNs8SZSWYMXM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CpdlWVOz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6083F44448;
	Thu,  9 Apr 2026 09:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ACAC4CEF7;
	Thu,  9 Apr 2026 09:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775727711;
	bh=9OROoV0rWGe0sK3wBROT37WhokeK5lFEn2PwBB2BcG8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=CpdlWVOzX+elKep7Zbvhs6TzH27OkUDp245LGTRynhswGWCoBwmNL4vqlzB8dBsUH
	 touwC30voN4iDgJjfzzJiherfnqelApY1d7oGWMqiGUsPiH1EYfq0Xu2BoPeeLbXIi
	 EviFYCrrl5tJ8x+37mxe51x1xx/mKC9AaRveaDwRunYcS9cZfEIUellOaLLKeXKBST
	 0RV1Sc77RXZiz0QdnHqOJHbuDokRqEHV8U77MUp2zEmbcxKlJhIH7+FOTSTAdkzsdv
	 Bi9PseMN7xC3itkBKy8BylIPMPkCJU9EdROqmMYUgqCYA9UJohN0z7RAupDUWI5n8A
	 TUebnjf4vZIQg==
Message-ID: <d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org>
Date: Thu, 9 Apr 2026 11:41:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
 michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer> <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
 <addoN3ur7GtiKOFf@lucifer> <015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C2FB4000F
X-Stat-Signature: ak7hjzu95kmj6ikakhq5of48jog58gyp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775727712-649984
X-HE-Meta: U2FsdGVkX19NIxMXwzkAEv3I2X4q5iY49dwS1qgewBIBlo4WhdaaYQzReFX3S/t0JzXZtksgivxBkltON/lInTz+X31kuxj25yDkz+4R5cBG19n0fveRSRhepa4pE9OBftFsnVAQNQiwEywIht9uCM5KYgn1L+X/CHmuGMgsOdfJ9X9zWWrjBA+/SZ2MAinx3Zc0uLbwcGblLD0ahQ6y5jDWt8zj6mww3vB+NnJSog/bxpcd2jN60eeK73SpG97NKG/GeDIv5LEX/5kjxzgDhZwTWpg3GNisjwRvEpxv6wGXO3sBmHrZRq1+eYHlbJRAynQmP9Vo77hdAqlKEzKFI0IwhO18jTRdPt2hF0j+IpTAU79j0Fctx9bfJ6HWJBwcOlDHN+F9H9bOBalbUSkuL3+Gvak4u+c6L2Xpiw9RcRbwp1znCdypr2F0QL5PnvvdihoAIgEdYR2zbGbtxsmrda25m+Xirg0j0DGTOk0F205013rQclSKTaesJjG/J+5axsVh3bHfoeP8sg+QjtMyg9juDgjoBXQorxYCfSmH0ANbtHtCxE9dD8PjlmekxPwAJKLvjrjTXwaWwiE4RMzWg/VNKqn2QnxFYq/OqfHpAgUKuk36A93m6ek9KFrBdfxdUoCVsl6JD0mn21vvo3JHqt3sW0KujPnAzEGZ1go4k13jQZ7uMmSr+qk6oCTiGHaDSo+Arb2smYzFSqOIW29e2EATSzsXEfz7I1EMHQT4fz6HcI3fdblhoBcIOCQO3BerGXs5gO5Ly6CeGGke5FrAMD5175yUAIqrgK4dNr3X0j+ZfOgxkwcseaYaevZY0698DY6jiZLPPYwKQcZLuZoeYaLlplJu+vR6ZvqcqA0nUC1L79fzqqGQvPsR0I1F76oMV4rKEaPj5v8Ghz5neslvF/UAI65MqfSHkjK3Q/Q+eAZnHwxusAIfUTtFhLelZzqBP1p8VVS3pwLeTCXPCWW
 mP/n24ir
 JUco5TrVtmYAuU/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 11:37, David Hildenbrand (Arm) wrote:
> On 4/9/26 11:18, Lorenzo Stoakes wrote:
>> On Wed, Apr 08, 2026 at 02:57:10PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> I'm wondering whether we could figure the pgoff out, somehow, so we
>>> wouldn't have to store it elsewhere.
>>>
>>> What we need is essentially what __folio_set_anon() would have done for
>>> the original folio we replaced.
>>>
>>> 	folio->index = linear_page_index(vma, address);
>>>
>>> Could we obtain that from the anon_vma assigned to our rmap_item?
>>>
>>> pgoff_t pgoff;
>>>
>>> pgoff = (rmap_item->address - anon_vma->vma->vm_start) >> PAGE_SHIFT;
>>> pgoff += anon_vma->vma->vm_pgoff;
>>
>> anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
>> 'related' VMAs.
> 
> Right, anon_vma_chain has. Dammit.
> 
>>
>> And we're already looking at what might be covered by the anon_vma by
>> invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
>> ULONG_MAX).
>>
>>>
>>> It would be the same adjustment everywhere we look in child processes,
>>> because the moment they would mremap() would be where we would have
>>> unshared.
>>>
>>> Just a thought after reading avc_start_pgoff ...
>>
>> One interesting thing here is in the anon_vma_interval_tree_foreach() loop
>> we check:
>>
>> if (addr < vma->vm_start || addr >= vma->vm_end)
>> 	continue;
>>
>> Which is the same as saying 'hey we are ignoring remaps'.
>>
>> But... if _we_ got remapped previously (the unsharing is only temporary),
>> then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
>> and would still not be able to figure out the correct pgoff after sharing.
>>
>> I wonder if we could just store the pgoff in the rmap_item though?
> 
> That's what I said elsewhere and what I was trying to avoid here.
> 
> It's 64bytes, and adding a new item will increase it to 96 bytes IIUC.

As we're using a dedicate kmem cache it might "only" add 8 bytes, not
sure. Still an undesired increase given that we need that for each entry
in the stable/unstable tree.

-- 
Cheers,

David

