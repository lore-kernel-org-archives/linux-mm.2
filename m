Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BABDC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8016B0095; Mon,  3 Aug 2026 11:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7ED6B009B; Mon,  3 Aug 2026 11:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497576B009D; Mon,  3 Aug 2026 11:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 111D36B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:18:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A65F40740
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:18:09 +0000 (UTC)
X-FDA: 85060313898.09.E2EB44B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C9A3B20007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:18:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVC83b50;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785770287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBs90xPnuu0V4vajTYaXqT/VGt0KiwQg3a93xm5Yebg=;
	b=2lyfo+qwoefZalqRuFGKrVB1d9MpyNM8Usgxrg8R3u/DarnfD1AS4CJjXwT9KvyhIF6+9d
	nsupr/2ZNWHxhi3Pl977BuZy4kiNgQoKRB9nIWZyUoCd8/D67wUyZyuXKOwSyei8bwbBuL
	VKaCX8tjTcVdi0ZB2H1tJ8/OsTBq2LA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785770287;
	b=8O1IxGxZMpBD363i9yGPmRHzJKhb0cpjq3yTP8YeU0BPXIlQlcwQwtHEdyXQe/7xJYOobh
	k6JakqXlfc37w/KviOZQCs0lW8lQ9fCW9p7O0pP94qg02ETC4v4aMOrpaHQD3UIhg9OVAQ
	43bLc4T03iuTAR0xS7bkNgaUSqZWwwI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVC83b50;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0159242DDF;
	Mon,  3 Aug 2026 15:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370291F000E9;
	Mon,  3 Aug 2026 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785770286;
	bh=IBs90xPnuu0V4vajTYaXqT/VGt0KiwQg3a93xm5Yebg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FVC83b50kI9fTgdOqjSt0kDMiYCj/7+sPjR1D4ltQlsM5JqgXGLHiqA+sTdxfUykW
	 utGrVdpgSobAFwfjuGjPOa6a8rKOJBlYKACGKVb7ZvKG3ktxfJbmL6WTpUdLX9H9b4
	 /oBX76rNcPEsARP31BVj2gDbh2fYzgX2OB4VQMTUwjitUnWdO36LRb94iB2kWEwwJ8
	 1n8ysI1hdpKmjOkXc73kYthtoJ12Qaq/4U82hqEzXXFgumMGTeHlLokAKPRherE8Uk
	 wP30lvOKLLiDtINvFwaDBGm9GzOJv6p1xJE9eJj85Zh5T59JVzMQqO4HjkFeCyg7mu
	 SFAeUbpvmF0nw==
Message-ID: <f556ae97-efaf-4e7e-b4f0-0f90087c8555@kernel.org>
Date: Mon, 3 Aug 2026 17:18:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/3] mm, drm: ensure .fault() does not have to be
 followed by .pfn_mkwrite() for write faults
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, bcm-kernel-feedback-list@broadcom.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <8d94897f-0f56-4ecf-bcc8-50bffd6750b2@kernel.org>
 <58fc5ce1-b6f5-48df-bd3b-054443c60cdf@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <58fc5ce1-b6f5-48df-bd3b-054443c60cdf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9A3B20007
X-Stat-Signature: e79j7ydf9acdy4rarc4opystr5zwtzkg
X-Rspam-User: 
X-HE-Tag: 1785770287-764431
X-HE-Meta: U2FsdGVkX1+xr5FrEtLZ5/rDETJJhM2nC0FLbFaENyuY6XeXI94O4oWpgCTDA0p+FWYcWqNTcpe8bjQwCKqzkw/jw+ULG9MgmBxKB9QVKlwJKuXAJMDYelr8mX+WZ2x6E9n6FCLVtDGUqUSKCtppfC2nE8PnqQq9Ercw944X2ttkRipqUVvP0MfKN/d6rmrVccs3NrZrxsdckP+VK6DGlmere1t3t5BGa7JE0BUahozinawIr/mnoTMTar0tL0eWFtxekK/C/uiTsC5reNgmc/GDy7j+03Peusq5KxXoDNsigUeHV/qjiRXfxdgkrVm66Lev4MOP7j9Pccx+WbXUMkYdpljNeRx5f4B9BuCsymvuwS9Wn2ZHuYrDQDi97y1LGyw302BlL3Gj68fBRQ/NehrjkMqMYVOCg259KHtaBLGs4H2Dp0h66R+/dEdc+j7h1xsRRxKFZWS2OAIKkDslsTf1Da+GqfJmc4AIMfGP+VbqBWYnKohlJTAQx6al6VXBZSB8ENj40UfMRsa7olK9aY8sWUgNc9R5W3rmTSPp13zUhoh18lSLWEa7QHrLPlvn0oJgoCLAy2bHketiqFsrfQnjw7rFRGEHMPbpj+p/TLkWFSBrDYRYmt6FP7OSM6BNhCwbsgNlBa9XbdPh3fw4OWfwqyefhLr7KmBKPBxnJ+erMIMf8mRTw/fsNQ1czFi22PjjHGcNN39bFN79i9nOfK86AHktxdWeo4gK74WtjvbBbEwHKotcuGdlkSbio+PBNP8ykDCTrrSTqdXlZt9u61tFyrHO4qQMpJdivLZWhEep3uF9fnAnOtHpx419HWRfpku98rM04Lc6aEwg3GabW092FpInyrisQm70EQPa/tr7TSOmu0S42AngwESyvRYT8Ig0TEPRW6fRR3ZBw9AqyJq8ZQ8FRb7+MgoMd3v+hGA+qQBC5KhdrHRMSTpNHgpjgiJx3m5ZXMdTuraEWM5
 MgS1BzIH
 RclWuFt9Q3an7A/E1YWSwYwe79yA7a5nS7P4VkkDkkThS7nybMMMlNMMow+QVL3C6vBnD1JOQGUtdH1/gPESM0BHws8DBT9DeEsevNjPQz4LPsLm7yZb93CMEvzvtWpdT34mdtFHvNuyVB2YP7AAavSFr6QGpa6KEEXAtn9VOZT7Fcw4AUpknCXTnZ0KXj4QUZK3bV3rWe65j3jx3+vGyxRFpjj1opUtgO64QuvClJPoLm051c2JlcIc2HE8P3o1ylD1pz5uxGuMvWJjD8s1A+JaZ+HsWU0w12jE04b1Dgj918yCs0SONqnWCacRMOIYPxpOYV5xErBTrrLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 16:19, Paolo Bonzini wrote:
> On 8/3/26 13:54, David Hildenbrand (Arm) wrote:
>> On 7/31/26 18:43, Paolo Bonzini wrote:
>>> Warning - DRM parts (i.e. most of the patches) untested; I have Cc'd
>>> the reporter to help with testing these patches.
>>>
>>> Right now, users of .pfn_mkwrite() have no way to create a PTE
>>> that has gone through maybe_mkwrite().  Because vma_set_page_prot()
>>> will have cleared the writable PTE bit, users of fixup_user_fault()
>>> will see a read-only PTE and have no clue that the page needs
>>> a *second* fault to reach its final status.
>>>
>>> Handling this in fixup_user_fault() is problematic: the information
>>> about the presence of *_mkwrite is only recorded in vma->vm_page_prot,
>>> which is an opaque pgprot_t, therefore only follow_pfnmap_start()
>>> knows how to retrieve it.
>>
>> How is mprotect() supposed to work in that case?
> 
> Hi David,

Hi!

> 
> not sure what you are worried about specifically, but fixup_user_fault() catches !VM_WRITE VMAs and returns early (see vma_permits_fault()).

That part is clear, I was wondering about the following:

mprotect(PROT_READ)

followed by

mprotect(PROT_READ | PROT_WRITE)

You'd similarly end up without the writable bit in the PTE, and apparently there is not really a way
to recover from this.

Maybe that's just ok (just sounded odd :) ).

> 
> Also, do_wp_page() has the comment:
> 
>         /*
>          * Shared mapping: we are guaranteed to have VM_WRITE and
>          * FAULT_FLAG_WRITE set at this point.
>          */
> 
> before the call to wp_pfn_shared() which is where .pfn_mkwrite() is called.
> 
> Let me know if this was not what you were asking.
> 
> Thanks for the review of patch 1---I mentioned here in the cover letter that the name was temporary and I'll take your suggestion.  I can either use EXPORT_SYMBOL_GPL or switch to inlines, but not
> both because the existing functions like vmf_insert_pfn_prot() need to stay non-GPL-only.
> 
> Anyhow, now that the series has a Tested-by I'll clean up everything, and repost later this week.

Thanks!

-- 
Cheers,

David

