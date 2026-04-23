Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259C7F589CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0A66B0092; Thu, 23 Apr 2026 09:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882036B0093; Thu, 23 Apr 2026 09:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797DB6B0095; Thu, 23 Apr 2026 09:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 696B36B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:00:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 140ED120183
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:00:50 +0000 (UTC)
X-FDA: 84689830260.05.4EA7E70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0459C8001F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:00:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkwlU+VT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776949248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUqzWoc8DlOcAtFs+f3SokTm8THv/V6h3BwKOlOu3d0=;
	b=V2SM5ewA9W9jO0hfT/0PkgBK8Jlr9bJipcOT/JcILBUjvqFOU0vRKnrcsJVdvEzdw4zt87
	bNE+TASqWoTQ6Clb7+oarR0PjmtAXjeGzgK8hpPUXei++psAqoRq2frGTPjfgcb4YfQ/iD
	4ev4HlGbBP18RzHx8Mz08a0BfFHb5Hs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkwlU+VT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776949248; a=rsa-sha256;
	cv=none;
	b=nHmwON4QKMUAW0SsJsYhf3vTjh9agZi9Hbq5oKqTKbhgX1MSrRg5QwZO+LQ9qppUPb2Rxp
	M1OtdNb17PGq7Iwr6TsgmZoa4p72vi4kAAjuP6tDLKgG5n683hkfl5pmglBfBORdZSsCjE
	csoEUMrzppu9WWjLGy0q7q7eDoMwG+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C81560132;
	Thu, 23 Apr 2026 13:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D20C2BCAF;
	Thu, 23 Apr 2026 13:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776949247;
	bh=jMWsIhaVRBlToE55+8Oeeq5aDuLS3n8Yq9bOM/6UQeU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=HkwlU+VTF2GZq0Mo3BmGUtRyD+ABo6lL5nb6wpNZBoDZBz9pyOjQtrVKVYc15+UTY
	 uc/EMl/z3olOl/7n+KiI2RseEXpEuTzl9aF04Gz5Zfp83spptVD3udHETvzYr/1uBN
	 SivqnzQX6MS4luWWHjYEGa+E7j7oTplqX1pO/akiEunEjuI5+SwF6oUotuRJzYHlZf
	 2xR65jFxPKCyoVr2H6/ZY1bZir0b3wBC8/f3fDarzrIJxoU4sl6JwN3my7LV/1WJNl
	 4pvTJV9JDEAdAlNswrfWD/bSgXQLVcaY6kyOidERdS+ijzzhMhNRFF+kXbh4g/VUMw
	 mR4kRS4ReR+Pw==
Message-ID: <fff4048d-8fad-4a63-b1d4-688ec3608fe8@kernel.org>
Date: Thu, 23 Apr 2026 15:00:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <2026042334-acutely-unadorned-e05c@gregkh>
 <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0459C8001F
X-Stat-Signature: 7aos3kdzqo3t39aq8zjm3opr4juzh58k
X-Rspam-User: 
X-HE-Tag: 1776949247-159795
X-HE-Meta: U2FsdGVkX1+bmsrhWjR2W7BPGp2uZof1A3BWp7rAnbH01vWwIfRh0Ts1YtK89FJBDr6/zZ4RaUTJ7hW+cQ6QUFdcUF5400ywexSHVpeV3QnCjB//LPEOLmRyIQITXMDKr/s6vIaeU3c82cCfj6ZbcWo7Yal3ec8Os/mDG9FGWZCPCmYjoonSMKrJnDTTiXbKGdWRv5srdOCrfyoOCjmQVD0hYnor7Xubed2XacUcr+RL+W6EpKq5crhqqw2/GFP+k1ReQc5ENlWACB8LXar+tjRXAR8nMnrwT3rI/5li7jbKCa1uhaa4opO7ruDildfkPklZxQGqx+vrX0VZKWX7BVhqAOYk2akDn3svSO+iLMtRQPfxmQWSnA0++CN4kZsuZ/1iyicx/AL3d2mvUbskjyKZDSbMk++Eh87/eCtswqrui1ySIVRppHJICXR+h/16DAAOAUfVDszHrDgUA2xdJrLUKIjkG1H6bqCu01IVR0DvCde2Qbqv2zdvg44a4i+VaZSH2hHCeUPVIim/9Wwi9Dcj3Er2iq9+WK6EWvEGqytR6iap9BmlwsSeY+GbgQ11K2gj/xAyl6bM9JFmH2X0ga7lOWEZ8dRo6ha4U8IWIngqSqsYqc8cRYE/y+4NRecW1+T2Qg7/Tig0sFF+fk0sqVJvAKCSxLw1RVFsaGVoDFR7yxl1FsfdmAPErUV2Z9zb+ElnRex7hXYtwscjMTeeNP/CgdGPrCEItQlGzCLKtJckecNR0of8vl50vP4B5Q2emoBA8eZUmnqxb230R+OU0wJDtfUnoI3/JlSFou6bBQuMvnWo3BeXhn07EV4QdPIZNVQgKXp2gh54g315Zq/me8W0yichP/uC4gd12MTO7ADpY0UgCmyuPamuhjtkEDSfpJIWDJv5BNb7taS/EAnSf6PDZ5xcGJUQNihGGoT0SwQi48pp3PkhP2w3uLqYMM2sfSeeYxRqNxNqYIHJY6s
 smFu4yjM
 hkg07vGLRuO58IkAplXLMJ/XbwlUphf03Ia7jwyUSi7lFrQaadnOBXjSh2z/nIL7jB0ENljigE7gPBxoCLvKt31k9UTMNL/aNzcnXYzW2Tt38XGcFMo4x8+gVslm3Rb56Eb3NACWgGdxIhZcDvbra1mbWPcEEDAbg9I/HsaidHaftJTAGgfrgyWGxKcDR3w+IvC22DFnueTosZAX21oV9Wq7FxdY6Jv8kl1c+tj+lvYpScIcTKQGvxw+wTeGKggk4s2z2Zgf3GO0F//8z0B7IGALVYy5F7p4JbUPQDJA8V9sVjrKQ9k2IsRpANew01KRekLJbT8ieiY+Xa7hKNqsAyGZXkz/W4MfNiRD2rsCv7WvhxorHkIMqYO3+cDyposaIWurPgelf0uoFfD+2R+6r8VDoKW207YSBIsj3MQ9+EYY14RJYz+slLoVN+CBtvWmt7nP0efCn7xHpOi2B46w5sAgX92YfxvPlWGbchiD8X7aLqgPYvOQ5YpNUUpcZZVVHwRUQHFrvtVp+/PChtJOySBLB+e8pkjp6jnkRio3bgO7JI9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 14:47, David Hildenbrand (Arm) wrote:
> On 4/23/26 14:31, Greg Kroah-Hartman wrote:
>> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
>> get_page() reference for each page regardless of foll_flags:
>> 	if (pages[i])
>> 		get_page(pages[i]);
>>
>> This is reached from pin_user_pages*() with FOLL_PIN set.
>> unpin_user_page() is shared between MMU and NOMMU configurations and
>> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
>> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
>>
>> This means that pin adds 1, and then unpin will subtract 1024.
>>
>> If a user maps a page (refcount 1), registers it 1023 times as an
>> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
>> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
>> the page is freed and returned to the buddy allocator.  The remaining
>> 1022 unpins write into whatever was reallocated, and the user's VMA
>> still maps the freed page (NOMMU has no MMU to invalidate it).
>> Reallocating the page for an io_uring pbuf_ring then lets userspace
>> corrupt the new owner's data through the stale mapping.
>>
>> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
>> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
>> symmetric.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: John Hubbard <jhubbard@nvidia.com>
>> Cc: Peter Xu <peterx@redhat.com>
>> Reported-by: Anthropic
>> Assisted-by: gkh_clanker_t1000
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>> My first foray into -mm, eeek!
> 
> Oh, nommu ... what a great use of our time.
> 
> I was briefly wondering if we want to add a Fixes: ... but then, this was likely
> broken for years and nobody cared so far in practice.
> 
>>
>> Anyway, this was a crazy report sent to me, and I knocked up this
>> change, and I have a reproducer if people need/want to see that as well
>> (it's for nommu systems, so be wary of it.)
> 
> [...]
> 
>> -				get_page(pages[i]);
>> +			if (pages[i]) {
>> +				/*
>> +				 * pin_user_pages*() arrives here with FOLL_PIN
>> +				 * set; unpin_user_page() (which is not
>> +				 * !CONFIG_MMU-specific) calls
>> +				 * gup_put_folio(..., FOLL_PIN) which subtracts
>> +				 * GUP_PIN_COUNTING_BIAS (1024).  A bare
>> +				 * get_page() here adds only 1, so 1023 pins on
>> +				 * a fresh page bring refcount to 1024 and a
>> +				 * single unpin then frees it out from under the
>> +				 * remaining 1022 pins and any live VMA
>> +				 * mappings. Use the same grab path as the MMU
>> +				 * implementation so pin and unpin are
>> +				 * symmetric.
>> +				 */
> 
> Yeah, drop all that. Especially the hardcoded 1024/1022 is just screaming for
> trouble longterm.
> 
> It just follows what we do everywhere else (e.g., follow_page_pte()).
> 
> 
>> +				if (try_grab_folio(page_folio(pages[i]), 1,
>> +						   foll_flags)) {
>> +					pages[i] = NULL;
>> +					break;
>> +				}
>> +			}
> 
> If it fails on the first iteration, we return -EFAULT instead of -ENOMEM.
> 
> I know, I know, nobody cares. But if we touch it, we might just want to return
> the error we get from try_grab_folio().
> 


BTW, looking into this, I am not sure if continuing on !pages[i] is a sane thing
to do.

IIRC, we are not supposed to return NULL-page pointer from this function.

We support it in unpin_user_pages() only for internal purposes.
unpin_user_pages_dirty_lock() does not support/expect that.

That should likely be an -EFAULT (if the first page).

-- 
Cheers,

David

