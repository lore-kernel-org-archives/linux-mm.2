Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AC56EE0AE8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE70D6B008A; Sat,  7 Feb 2026 17:05:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E666B0092; Sat,  7 Feb 2026 17:05:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1166B0093; Sat,  7 Feb 2026 17:05:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9D126B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:05:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40E638BD30
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:05:52 +0000 (UTC)
X-FDA: 84419043744.10.2DB9A82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CDA340014
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:05:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NsnqMXpW;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770501950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IiGdYsMD3Vw4PP/Hg06XL6Z3azdEQp+dskd4cyk7INg=;
	b=sNWkykuKCWkSIWUcQ8BlOakKX6QnzQX3UPulmGwcoFt+Yj6Syn3vFwaptAP4keaVeZaUb/
	7N/6lP3puMp/mlBN82PBAAQwOdh7qIPm5ZDZvx0pVJbt89I+cahe2AToZt98sPvYt2+wI4
	PE5QmevkhDEb1BNLPsHUxg+EHDJT8qY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NsnqMXpW;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770501950; a=rsa-sha256;
	cv=none;
	b=NvgFvvWbuaieIwGpJQPacdqnJzqutl6Ldi+S6N102V9jQjdwzZHXGgh7A435ZmhH6oZCvj
	x1v+Z4hnh+GGgr7kwwjlo1ArAJmr8W5bsfAwlOUKsSLT88Wo0BZAjDyYFWOnb8cu8sPF+Q
	yAdFbvrG9DKDEy1kGyw065k3RWVFO8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F1D04062A;
	Sat,  7 Feb 2026 22:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F8AC19422;
	Sat,  7 Feb 2026 22:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770501949;
	bh=uZLOOcmDPHjgS/t8oBjlwJ5VuMIYJUkjmIi0zJgswl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NsnqMXpWB3QmA+klSyyaj1wBsJ2EFa0NbC9JvMCJmyntg4A8WexCuYa++cJWmW88Y
	 jmxy1sXzIeUr8Tjay3Z08TnSORZy/Q8mVvLJiQJ18pReXFrjj7myDeDjVqsSbi+zP3
	 2fvQAz2KMe8JFL5/vduoqVVTmh3Iq+GYXn/HWfgHVQbK1TKpqCQhRhL86NY0PswiAI
	 mAYOf+9Ikd5vngGUfiMLltxwrTKpverdAausN0GEowm7j0TkE41X0hLnfWAYBK/GZJ
	 KoIMIwN8xl6BWrWTKpXZ1kWJn/UQNrv+Wdn3OTMPXjTYM05z+hQv6RDO98PsKo+AE3
	 wgudDjEWkO1nA==
Message-ID: <bd36d92d-dbf1-4818-bb31-0330c1f53577@kernel.org>
Date: Sat, 7 Feb 2026 23:05:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: Barry Song <21cnbao@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, Vernon Yang <vernon2gm@gmail.com>,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev>
 <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
 <CAGsJ_4yEfgipUe37_k5rArrYMPY_31JUKQGjRk+NNJTK9QhBWQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4yEfgipUe37_k5rArrYMPY_31JUKQGjRk+NNJTK9QhBWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: i33fusxetieweg8qe9jg7pqhx174csar
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CDA340014
X-HE-Tag: 1770501950-770918
X-HE-Meta: U2FsdGVkX1/KmKRvJ9ZhyJVU9/z4v0v/T3EXIFy9qfdUO9h0ea6jJmjBvbXa6Xs5sVGonEkU192EVtizeg9DV6YpBrdZLbGhK2zelkNwODqQ7uU6YFFUg1rGC+LBDP2OtEdhNRoBqzCW3XZXiMuwcTluXqPqECEuYCinEFVVb+8mSH55SZ4kAdui8OCNBgJ3wz20AD26DgK7FpQ0Uz5fVlUfpRT5KoU4ET0yeNhhaRE6I5FGGWUWI89Wfpk0aHznhTKHUOv7xxHkOSz4O0POjLfi4tLrp2V8pZ3CS6+jtefGumGnxrtX8bUYdp34kWVgkbfueo2ET2pROaVhnzhaZRPLCXV+GsIXR21ksQ6d1rsQT+6ZD/8Ds2RW08YvhZ85ZTXyoKWsdvzrZ64pzOZTuv/TU1xkTlSMZAP5ut34WyAcb/C2ByM5OMy8hDe/dv5o/PwiS+FeXbg+XZMkRGGAEg1eH4ao4fBvhOseUoYgMN1Rvy4RPSDG6UIRerC3kkSizmPFPGEbrfqrt3ddSsJWfFM+xS75bkmaPBv55aGyyKTapFi49fP1ORV0U++hdHli2SGd9/YGW1PhdYAkr43XIB4+xhOo015cEfU0zmX/4YRajjWswFvEqH/JLcMlg6+wHs8iPkflOMBksGHs7Z2eb34AFuT65SFnxqXu8X4RMoZi/zKowmbGIuWA1E4T5f6nBeSAIgq6lAajr3kJhLmQAsnKgfENu0hWnGC9YXH4NpxOoiK6tOi545ByEq5BPYLf0MH8R9JmKpniOc+JdbNxiQeCgDc9VJ1YLsLGcE+FOS5c3DvXgwBltSKK2NHNVPI84TugLk/0x7z8rBQePSmV999iRvu5XHdI9bXkr3jWSb7WNdq4I16NpVgft4izzaSluANTjz6m2hbePwmi+7jSMRTx8HqT6Y45j4WqZdrayvuhQqaOBNdQj/DUWigV3fnzEUGvChinzDwxUjv9yXa
 fg2gQTmY
 uda+PQlKB9FWy6eIw3x6DTd7ZFfS18PjdA485yTbQblx+R8nQ3XX+6f7EuBf2TnE9FjEe78O9S5jFNh952CcmXuPq/F9kNZJ2p32kFiSEucOAHC9irfcz3eyqHh/fO//ZfhA7cY99QqSD31uLK+dnF9Cqzclxlx5V6L2vblBjZ2nOQb4lKhcMPv70Xi5cuFZ7fblE1cIakNHL8QPJZsY5Obiithv65zH55+0BPnx8OTHRxoYyXACZM56xASFytoctAroe2FZ/dEzhG2Jcel1FHoZs+XvMmBMDdO+7Z35SqxPgzqbt4V6fJx3UuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 23:01, Barry Song wrote:
> On Sun, Feb 8, 2026 at 5:38 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 2/7/26 14:51, Lance Yang wrote:
>>>
>>>
>>>
>>> Good catch!
>>>
>>
>> Good point!
>>
>>>
>>> Right. When the VMA has VM_DROPPABLE, we would drop the lazyfree folio
>>> regardless of whether it (or the PTE) is dirty in try_to_unmap_one().
>>>
>>> So, IMHO, we could go with:
>>>
>>> cc->is_khugepaged && folio_test_lazyfree(folio) &&
>>>       (!pte_dirty(pteval) || (vma->vm_flags & VM_DROPPABLE))
>>
>> Hm. In a VM_DROPPABLE mapping all folios should be marked as lazy-free
>> (see folio_add_new_anon_rmap()).
>>
>> The new (collapse) folio will also be marked lazy (due to
>> folio_add_new_anon_rmap()) free and can just get dropped any time.
>>
>> So likely we should just not skip collapse for lazyfree folios in
>> VM_DROPPABLE mappings?
> 
> Maybe change “just not skip” to “just skip”?
> 
> If the goal is to avoid the collapse overhead for folios that are
> about to be dropped, we might consider skipping collapse for the
> entire VMA？
If there is no memory pressure in the system, why wouldn't you just want 
to collapse in a VM_DROPPABLE region?

"about to be dropped" only applies once there is actual memory pressure. 
If not, these pages stick around forever.

-- 
Cheers,

David

