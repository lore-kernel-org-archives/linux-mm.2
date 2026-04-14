Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C44ED7B8F
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D906B0093; Tue, 14 Apr 2026 05:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4256D6B0098; Tue, 14 Apr 2026 05:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315696B0099; Tue, 14 Apr 2026 05:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 207106B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:06:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4DADE369A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:06:31 +0000 (UTC)
X-FDA: 84656580582.20.2D95E7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1425340008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:06:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WEKOe/7Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776157590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qa3dBvQh6k007AMYT038sYzKM9OcZbFz9y7K9qGrQBQ=;
	b=en7Y1aKeS1ti67uaT667BpeM7AeuXhXTJorQN+ipXe/eeZZB6U+6oSzextwx9cbmRCgEqO
	fyfv8rfaYo41YMuPhyVWzWxX74LIKZUe/oSX4WDWHE9C+lVXhQ/Aj3m0Cpfv7tU8Ooifwy
	7MYo99AyzrivAY4jyhvfoaQ+EfcktxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776157590; a=rsa-sha256;
	cv=none;
	b=dbjktWTt6oLcf2dfblFgjJuYVb6NYIFDcdrReR/WjQKfYvO2lybM2kzmWqHOXbR0k/V41r
	BePs1Hpt6SCoZ3tWeRP5qR1TLnL2ocGslqFxkmRX9eh2Aw3DCeMSDT6jK3PiZdZk+P6yId
	YS+mJR75wCcvXTjkV664bxkpw7EX3ZQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WEKOe/7Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C95F6011F;
	Tue, 14 Apr 2026 09:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CBFC2BCB4;
	Tue, 14 Apr 2026 09:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776157589;
	bh=0HFC6LCOCRUWWKTQwlg+7vyB5B5S9zxAroCeUQNKVzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WEKOe/7Q4DyG+Sd0Uopd1VpE9hHy2EIMoKq1irldHH+xBpWvdSJssIybd7Vy9jHgc
	 8K2BoBZef1SgIOoxgFAsZVB9gR+04RauyXozQmJcMCJAJja+tF+vozv8xh7fbp3sOG
	 jV0eh7ApHl/s1PDIsjsCS5I98FxGNh/lxVw9ViZydRdaenFkiuD6FCSgv1a89fxfpW
	 a6KKEKTu6BhIP64FlymRJNOQsWXFCiW6qYmbsk70lxatU6M6+8FXQj61KecuQqjsID
	 EzOs7h9P1x5HU5Xz1Hq8Ngs7NH1IOkA6XnO6iu3SLxmUPkaEtkpc/ow8gvMnVR8iCH
	 LnN8QqPpZ891g==
Message-ID: <ccb1f5ef-20d0-4720-8904-f6af52b896c7@kernel.org>
Date: Tue, 14 Apr 2026 11:06:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
 <20260413180303-mutt-send-email-mst@kernel.org>
 <20260413184022-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413184022-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1425340008
X-Stat-Signature: juyqz4pinnmt45jsmnnau58dee9ozfgo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776157589-78417
X-HE-Meta: U2FsdGVkX1/3mo5OsgDEJw1wtXv33G3X22BJbZwkHHNdryqa9yREet1XXP9TiRD+U3jvjnteO0Lov0SQD1WzPF65LVERco6DHjyAyVAK3+ft7LmI1CNqfds8CsXYgldVG65l7pECkgV/PZb3ylIYMy8k5rQK6Bext6W3lshFntTbdBp4E3hA+BK4BAnBlhvxUGTn/ro8DGZdAoN+QjZMaw/VXg+1OlB+4y9v0dw1YoIGv8Tv2uM3qC1r16qVhWhikfZZOZEvKcS+ZvlaLs+5J0fgCWMP9E9pVg3zcjDS0b9lOBr8msKfLMOx6pEZYdgMeP6Cvcx5EhGPCXPrJ71dts7HSFysY1PRl8XCWQU/7LFc3Q4FkkeUJbZJZq2ddMmHdnWWGYk53pCEHr45IbVq4OCXi/tiM0sfWYLqhFdNKvnrhmKN9dZ5ZMnVNZzgvzLieyI0j25Gt36rXDBmqlh6fLEoQdYHSZDZiFHKO5Ov5+OxBjZwLgqqX2s3QF8fzPtZVs7Q9EEmKyOCjnPG2j2M4PFOw60/6mgvtH9wR3mFrqBJYUvIP9Z5sqJMc3MJH/p4hphddxWJ3elHlFpgp4Abzlxm0UmA+RDYGVFPyTLsuVPwMWaV1uT5xoNbi1lCBnUvoV/NF8QySl6+1LDgEMhVvkd0hZ4w+tABR5BVOkSEz16zPp4Ey5bbLYLTjMIpKFyluSVZoium7dhTARvNFVz818VdDB5Up2KWQRl3L60PsBJNwWPwIznAdYVkZlL9m18lUJ5dsGQdrXY03QXj3hoQwFpeX9W8P020XdB+tlXWDmGyloAHOyB/mG7LGPTYvhSAMMRdILELFxEJRiwKuE+ZAEPibXanDszpptQnFrzGjmhqALI2nVCA7eOlVjm2hy0Jz++kEeEo+gK71de8J/2XDEoh4vkpaspCVGgAgmR9FnAwAIf+DF+MU2fZcBlfP683MMg0WmSHK1awF1osJ5k
 JHUpMlh2
 zAPm7McVm+HRso6wBhkPuOKlZYszz8z5eLEnM9LwOCYyTIJxhK5Sg6CRv3D840nZfE8q92fdTZG4JljQtbKHi/cFCYeCOPFJwSOhd7X1hBVDj5KgqsG0F+cl+GibK14C+70UB2F/gMOHsu43qISI7s8LgGmCUDBBjFL60Tj4aqdBCKr+NracGiAV1CCowbt0X+7Ni7LhEqLERJzFS7gJEs+8mxPuMvAOUy1dwi1xKgV2Rpav6UNtTjwywYFCEX3fq9ixPcPxCL4k/uJOTqha4RE6BKjfQm1BuoH2CZd1O1ofRpRWRfGFS0/kMTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 01:43, Michael S. Tsirkin wrote:
> On Mon, Apr 13, 2026 at 06:06:14PM -0400, Michael S. Tsirkin wrote:
>> On Mon, Apr 13, 2026 at 11:05:40AM +0200, David Hildenbrand (Arm) wrote:
>>
>> ...
>>
>>> (2) Use a dedicated allocation interface for user pages in the buddy.
>>>
>>> I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.
>>>
>>> It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
>>> all that.
>>>
>>>
>>> For example, vma_alloc_folio() already gets passed the address in.
>>>
>>> Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
>>> folio_alloc_noprof() use a buddy interface that can handle it.
>>>
>>> Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
>>> do what folio_zero_user() does, and only if really required.
>>>
>>> The whole user_alloc_needs_zeroing() could go away and you could just handle the
>>> pre-zeroed optimization internally.
>>
>> I looked at this a bit, and I think the issue is that the buddy
>> allocator doesn't do the arch-specific cache handling.
>> So allocating it is a fundamentally different thing from GFP_ZERO which
>> is "zero a kernel address range".
>>
>> So I don't get how you want to do it.
> 

Saw your new mails just now.

> Oh, wait, do you mean we thread the userspace address through all the allocation calls?
> Like the below? This is on top of my patches, on top of mm it will be
> a tiny bit smaller.  I can rebase no problem.
> 
> But: isn't it a bit overkill for something that is, in the end, virtualization specific?
> It's all mechanical threading through of user_addr, but should we miss
> one place, and suddenly you get weird corruption on esoteric arches
> since we will get memset instead of folio_zero_user.
> 
> Worth it?

See my other mail, we'd be forwarding it only for
vma_alloc_folio_noprof(), where we call a _user specific interface.

Then we can get rid of the user_alloc_needs_zeroing() hack and just do
the right thing in page_alloc.c

-- 
Cheers,

David

