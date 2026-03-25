Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C896109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD656B0005; Wed, 25 Mar 2026 11:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5066B0089; Wed, 25 Mar 2026 11:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAFD6B008A; Wed, 25 Mar 2026 11:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6EB6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:24:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8E31C301C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:24:38 +0000 (UTC)
X-FDA: 84584957436.14.7DA8A40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5FE99160002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:24:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTjsV3ov;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452277; a=rsa-sha256;
	cv=none;
	b=tdahy/AjDRbXe4tjyl42EMxrNI9y8K7ml3ApPBN4OMUcSMU23uznRy7gfgbJMDiztc31gC
	yg6rvmXQWpmJ8OcG07qJh/G/HBBp6so1U7dsK/sUfdn/GXe2AdJidr7wSuypBht2yYecGL
	vvbpsoy2Sso2kbG27bTAAgxqc3rZdYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YaUeAKnhHDMNsqZXAzh8AyTj+RoVDiVN7DAspZky3c=;
	b=tnjFdsQzCdgiDgHOLbL00R0W8xCJyLmMy3MM32ValsaQaom9kBx+XJ6NAUwkCnBF4BPEVX
	pM5XlhcnZPRGkSAYoCc4rYgArqvxCgF5CLVJQVryJW5AlA4s3xXqHywGs5vIAffh2PU3Oq
	dat7/pflXvppGi7NkXalbZEzo6MW+KI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTjsV3ov;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFD36600AC;
	Wed, 25 Mar 2026 15:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0577C4CEF7;
	Wed, 25 Mar 2026 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452276;
	bh=CvCkYeIxBeSF+4kW5iTX2aH4Uo4OeNuvaWXY2mOVVBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GTjsV3ovCtsUP2jZmJD6YZaU0o0OAnZ6CziIpQB1w4USl4W7v34PUQ1DT38XlTfXo
	 OR+gmanvcUo2BbtCZuAthZug4MsT8QcoMwLM645HBJEqQea2MJrcqBjRUT6mJfGPnh
	 7aKjQHBohQ3mo0VLR2B7iSnn/tsl13efatj/F6v1keotNVjp5gx6f9sDeeXFVCNQDB
	 ZQEcG40hyaLOSFoUxu+kK7HjRWQUrH+JS2oErULOLhXDrYwk2A0Nv3ZRkGUdU0UIw4
	 I1EOtRgzBRdE3aDKKlBBepStxOMLbRYb9fz1SrJ7BZeVbzpfPqTbWgdkDxAoddGEr7
	 aKD86SauNu9ZA==
Message-ID: <90361397-395d-446b-b1a5-580efe23bb70@kernel.org>
Date: Wed, 25 Mar 2026 16:24:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
To: Peter Zijlstra <peterz@infradead.org>, Eric Dumazet <edumazet@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Hao-Yu Yang <naup96721@gmail.com>,
 mingo@redhat.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20260313124756.52461-1-naup96721@gmail.com> <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx>
 <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
 <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org>
 <20260325151445.GH3738010@noisy.programming.kicks-ass.net>
 <CANn89iLnJv9_HRV1vuURFM5uVA-y4SqBsBRD24kSJe7UmBtXSQ@mail.gmail.com>
 <20260325152206.GH3738786@noisy.programming.kicks-ass.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260325152206.GH3738786@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FE99160002
X-Stat-Signature: 8h8pko8ny9mnawcp7b3fiqgqw8g7z3j3
X-HE-Tag: 1774452277-761861
X-HE-Meta: U2FsdGVkX1880LC5y9T5rs656ryDeRP+hBOe0os+WwPv+v+Xqv9VT/FsdjPSmtachQpp2ShZzHXnUzTakGaAUOL8OwtEHtp187ehLK5KcoPOEIIcQ3YzGSTdwPuTGHJtuKFsVKsUDVSECwdz+/6gTckwSBwA2oBBG12btwZP0A+kxhCwTC6WbReCxRwwKpRCRUGcZIQF+OiL5aFoL/pZD7czx3BnuV4gadzRwcEJGHCj4hX1+u4LyE2AVhuWShMdnymTt36njQVDIbWpt4FlssOtPDJK5coqAT/RtpAj2JS2vvXQssXEMefibEComTxzImV1ngEXab77Qh/8njwjkcGVdXSQ6mrKc851d6U/TuwyarUd4SidcZ0GL4TjPaSiA5kgqNojWdQGPvVi48YMExKbHjdMf04MCU0mhpzzeHiTE7hfXzSsFZJxduMuJN5OAarMLSDCUDsKcdbi3Z5Hu8o6hN2o6BOuPIRkcqyYpB0IOE19G4UdFSJ7D7Tk04vI2eqlXL2xp6sTaNpMrprw6Lc2wAHDKNE+aqYOAFLTqVXpGNYQxedCU82RUXjeITq8icxpG47mjZEWsEAxpCyj0uzBACujHh+e6WtdawORgB08QqbYBsbPwTWlNJuoTF/P6q4Wc8mUkUXNlYBZCOoWMxgLMY1HpW/jve2Ba45BqcgHkXR6I1FVyOLQi1rIAom7TZMOlKJlVd0PK2KAPphfyFJP7dQBjJsZ90i6PLN2NaZw5nbKlP1S7B6kz+nGvHUTgCAk8fzOxEtBVBwLZxVWfgXZOGPCEFYcK0Q+LnkT6AZ6nltGhG6YFae5WjFuc+6cm8Af0YtpPmmKaIkqvpoDEmSjBraUg5nO8/YRyldtojzPk476KFdU1mpQ+mg3SNYkI6jtwx6fxH1SRdcDAbL89kL0lGOWiGsK5gbc3s5PrqK329z95NkMoFd/21W//IWUBtQLe9PMKFpjLfXq6Mx
 6D98zjub
 Kpc9A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 16:22, Peter Zijlstra wrote:
> On Wed, Mar 25, 2026 at 08:19:24AM -0700, Eric Dumazet wrote:
>> On Wed, Mar 25, 2026 at 8:14 AM Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>>
>>> Bah, at that point we might as well RCU the thing like so, I suppose.
>>>
>>> --- a/mm/mempolicy.c
>>> +++ b/mm/mempolicy.c
>>> @@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
>>>         }
>>>
>>>         old = vma->vm_policy;
>>> -       vma->vm_policy = new; /* protected by mmap_lock */
>>> +       rcu_assign_pointer(vma->vm_policy, new); /* protected by mmap_lock */
>>>         mpol_put(old);
>>>
>>>         return 0;
>>> diff --git a/kernel/futex/core.c b/kernel/futex/core.c
>>> index 4bacf5565368..6336a80e3dca 100644
>>> --- a/kernel/futex/core.c
>>> +++ b/kernel/futex/core.c
>>> @@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm_struct *mm, unsigned long addr)
>>>         if (!vma)
>>>                 return FUTEX_NO_NODE;
>>>
>>> -       mpol = vma_policy(vma);
>>> +       mpol = rcu_dereference_raw(vma->vm_policy);
>>>         if (!mpol)
>>>                 return FUTEX_NO_NODE;
>>
>> Yes, but sparse will bite :)
> 
> Oh gawd, yes, and then people will go 'fix' it and it'll turn into an
> unholy mess.
> 
>> READ_ONCE()/WRITE_ONCE() on these two locations seems acceptable.
> 
> Fair enough. Like so then..
> 
> --- a/kernel/futex/core.c
> +++ b/kernel/futex/core.c
> @@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm
>  	if (!vma)
>  		return FUTEX_NO_NODE;
>  
> -	mpol = vma_policy(vma);
> +	mpol = READ_ONCE(vma->vm_policy);
>  	if (!mpol)
>  		return FUTEX_NO_NODE;
>  
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
>  	}
>  
>  	old = vma->vm_policy;
> -	vma->vm_policy = new; /* protected by mmap_lock */
> +	WRITE_ONCE(vma->vm_policy, new); /* protected by mmap_lock */
>  	mpol_put(old);
>  
>  	return 0;

LGTM, feel free to add my

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

