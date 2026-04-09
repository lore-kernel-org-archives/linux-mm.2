Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7947DE98FD6
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44876B0092; Thu,  9 Apr 2026 05:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5586B0093; Thu,  9 Apr 2026 05:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C266B0095; Thu,  9 Apr 2026 05:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B270A6B0092
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:37:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4AB5B1606A6
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:37:19 +0000 (UTC)
X-FDA: 84638514198.08.60F990F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C26F80010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:37:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XPkMRWPz;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775727437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhq9Zd4vB7ULAYBj4Ike1ZRzIyFgFq5FpJnEEuJDHDQ=;
	b=l24kFjDVbqXyPb0JKlkJCOjRYlnqir1j4UWZ+7Mt1gBlRxItSMx034p+hNemPFjX6sVXZd
	BrNNyKgKHYtVsSf0HLqfibc3p1br5W5dBrb5izBz7GEUUF+tTgLl5Dep8wbaJbGBMb4K+d
	/if3CO8Ya6nQUcBdqSnLJI6Z+7+D/Nc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XPkMRWPz;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775727437; a=rsa-sha256;
	cv=none;
	b=KfZikFNBZcYYdFiXcZcds+CubBfyaC3KK5Oawx4Oqyhsw2DxB7oxwJB0BsaD1857FPm4F4
	7IhQ5Ua0BG0Ol4OYtqAfRWoBk2orr2cFj02GlT+QpHyMhNgL7LIrWvN7MaXuuYuYNUIqjy
	lq0eK2EXGSd3UsJKzk4Xvb4Zm6S2aE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CACCF600CB;
	Thu,  9 Apr 2026 09:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4F1C4CEF7;
	Thu,  9 Apr 2026 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775727436;
	bh=8cYAlzO7S50sLkj8aMzBDcYX3LlVqIA3ZJpm1p+BBjA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XPkMRWPzKndUdWW0Tvg+MS0bDZYX40MnzKGYhZGFwdjr1/LLTVPwvqg0KiaKKDgeK
	 2wvVHsSiwQ7OQR6CroHP3dhgmxVFFJFqlqr30cPlAjtpdPAlZE1Of9vuknCdi1B9AI
	 /IgOLtbqPmLKLrnBfV1oWtICCIBaPJdHVqm3blN8VX+cT9AaJi5wx3a0BaAb+X8r7Z
	 Dv9fQk6YngQobS6xXdsW+hc+Q8uc7qVRS/Erux2faipZ8UtX4+MLOZ5LlKV82ASTCQ
	 YpTwp/RA1DFJGO/qlhsWS8io/FgjmOGlxHBs3vdAaAWC46mPZT9j6j3lvNLa0jh9s5
	 aw8hin45iKgNA==
Message-ID: <015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org>
Date: Thu, 9 Apr 2026 11:37:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
 michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer> <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
 <addoN3ur7GtiKOFf@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <addoN3ur7GtiKOFf@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9aa7999nyg4mddrhekwkmpnrs7ka3tki
X-Rspamd-Queue-Id: 8C26F80010
X-Rspamd-Server: rspam09
X-HE-Tag: 1775727437-333653
X-HE-Meta: U2FsdGVkX1/GqbJtQHRDvCQKvWN3ujusAqp/FI3NjlPoF/m3XhCh8w1RsZh9MVyA1JIP/bDWkPdKIkBQwYYajxZ89LYC0Fj8xhDo6B2Lx9UjDqMpUwk2YCugqIjz5LHWCfS87aw4IbJ3e4u4yX0OhA9s68BUQqA8vTsVj7Hl4+r0HFO79n8uuWEAx3KIL6mPbNR0p3Kil2gNwFPuzttvUry7fdm+WWZ+Jk+66g/WN3XrsdCU+qIf21vE5Vyqge9whsv45W+Rjz2D6BPXDLDq+YyIIv+By04bMH7SLbiWZxFxM8gPP6Od7S5UqeGrI9U7I8aIVTYL7sn1FpU9hRamI7PjldSTcrUyHYGrGcgUI8CGjZRxcgMOkj83pvGPzC4jUjEk/gpwphbpusClDmUE/9t2EKaBY99cpYcyBH/yBJcbWK0z97CpvhZmpStW/H6aVPoAsITtWNNXZe/DL0qt8F3DL8pEe6kgf2Oz51GHgHuTYhOazm8od++k5gWzuExSxtAnB7BQ+FQGfzMerK8Z5h7XuSzmZwr7QSD/RGwRHsUDZNm7bwQsUxXWMA/wNG+NIvYBP58Lsgzb46rSRXHkdAw0kHw/D3Ghq2nshCjFYIqbNpI+dp7VwxWK0r6aPR3ob4upzbDfWfKPbbfYrurMmwC4YWwB5j3AQIC3PfLhXihxSBXvXwY80vbtc0slncT1OjFX1i20Cotvq9sA01r6DhbSFS6+DNgCCcszyHAAvoxaFhfIKUErB9iDCou7BU/LWyPQ/rw/6RkNxpwg9b0OPl7ttUyrZHBWQjvrdgZrwV/h6Na7qhSQwp51T24J/xKeeqeB5massFQYX3mg5SYxbuqVKh1LGUiro9rXVEytsQwCxeD/GWipEfgvDXXIr9m1QHqbE+6uPRJc8vkQD8i66Uaff10u8xKUcpjsH6bTdkZ2GJyXbzqDAwQIvqm4KcALgTjLcj24BnUk90QKQyk
 JEJjDMgM
 X20nHieYMBl4DQOT57Gd22jcwk/z0EumBIMw6Wpn3QrFEydYvNlNMrxZOShd0bwkpIJHYDyTV0AFpXy9JYYwsLxxRCVy7RzJkgD1gDlZuNukTejm3UBePQQH6u1j8ZeavvHsh5y5rrGLK1gJ7RcAxwkRxfoUm6c5ftvVXfZ7dzZt/hN56gUKofSZcodvqUZ2OLnKS3jlRxhBJhihkRMS0J454fdvlo/46bKbhB/xp3W4vI8j96Y+4GOrzz75F1mc6m72F107kUnCHULlC+bliyws1x32evnlTmPUvoHhz+sMc+1Pxfq7yLmlkMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 11:18, Lorenzo Stoakes wrote:
> On Wed, Apr 08, 2026 at 02:57:10PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/7/26 11:36, Lorenzo Stoakes (Oracle) wrote:
>>>
>>> Hmm yeah, we mark them unmergeable but don't update the VMA flags (since using
>>> &dummy), so they can just be merged later right?
>>>
>>> And then the:
>>>
>>> void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>> {
>>> 	...
>>> 		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
>>> 		...
>>> 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
>>> 					       pgoff, pgoff) {
>>> 			...
>>> 		}
>>> 	...
>>> }
>>>
>>> Would _assume_ that folio->pgoff == addr >> PAGE_SHIFT, which will no longer be
>>> the case here?
>>
>> I'm wondering whether we could figure the pgoff out, somehow, so we
>> wouldn't have to store it elsewhere.
>>
>> What we need is essentially what __folio_set_anon() would have done for
>> the original folio we replaced.
>>
>> 	folio->index = linear_page_index(vma, address);
>>
>> Could we obtain that from the anon_vma assigned to our rmap_item?
>>
>> pgoff_t pgoff;
>>
>> pgoff = (rmap_item->address - anon_vma->vma->vm_start) >> PAGE_SHIFT;
>> pgoff += anon_vma->vma->vm_pgoff;
> 
> anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
> 'related' VMAs.

Right, anon_vma_chain has. Dammit.

> 
> And we're already looking at what might be covered by the anon_vma by
> invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
> ULONG_MAX).
> 
>>
>> It would be the same adjustment everywhere we look in child processes,
>> because the moment they would mremap() would be where we would have
>> unshared.
>>
>> Just a thought after reading avc_start_pgoff ...
> 
> One interesting thing here is in the anon_vma_interval_tree_foreach() loop
> we check:
> 
> if (addr < vma->vm_start || addr >= vma->vm_end)
> 	continue;
> 
> Which is the same as saying 'hey we are ignoring remaps'.
> 
> But... if _we_ got remapped previously (the unsharing is only temporary),
> then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
> and would still not be able to figure out the correct pgoff after sharing.
> 
> I wonder if we could just store the pgoff in the rmap_item though?

That's what I said elsewhere and what I was trying to avoid here.

It's 64bytes, and adding a new item will increase it to 96 bytes IIUC.

-- 
Cheers,

David

