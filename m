Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12B2FCD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546296B00D3; Mon, 11 May 2026 08:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D9F6B00D4; Mon, 11 May 2026 08:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433BF6B00D5; Mon, 11 May 2026 08:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3154C6B00D3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:18:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA6D0120701
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:18:19 +0000 (UTC)
X-FDA: 84755041518.29.AA9F3C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0BB3D40012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:18:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glGQBqNc;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uojsk8DmYy7lYdI2sT3LVy0gMh2JQxUAsldmpwLs/Vs=;
	b=5WKd23lY22FS/HAk9k9XjAZhgH67Wt+SFR5o8rimkykz++HSfTsfDYUMwFOqAbm3R5+PiJ
	vOjGuZXiOxxQkWzn5NdLGNp7iMsJW+eUEC7LiAlDQ2jYO2iAiNNvhKDrqB9JwhN/z7AO6n
	Nsc0+tRiKHWftCoyiVLsX3Ug+DsM33c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=glGQBqNc;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501898; a=rsa-sha256;
	cv=none;
	b=fRpT/2Ll3VWEuSPNuC0T8jc9Ng2GG/fRN893nXleXtae7BrQkWBwu5zOoLPXyKD14dy3pr
	l1AJ9Pha0M9UUSrKLvUWa1+Se5+yRej9ywFEmwBk39uavV3Us6I30r03EiYD8oE4VG4Q66
	JhltGVXKk7kgV9Z7n5EYxPX7uo+VXRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66CFC60120;
	Mon, 11 May 2026 12:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715CBC2BCB0;
	Mon, 11 May 2026 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778501897;
	bh=yMjdymx8FHBrtj18YslQ/stGshcK0q1TjQd5LI7LL8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=glGQBqNc1KRIJY+4eXYuyo4x8xsdMn7qscU1jXE+LdfRxl8N3+y7ch4kG0XZEC13w
	 Rst3Ki2cfX5RVngCHsPWS3TxlWdiwjCqWw+mxwEzj76Ld9oGrEEE8izN+Qlfp09h6k
	 GQ6fflH7jVvzFIHnmKXBit/AboWC0MKEQ9gPQ1sRrS2y4uRLI8NqMbhvYFWTGM/Iih
	 G8dYr0EG5rZhZ1lvCP0hlskJ7cRHzE+lxy37XUjT538hZGp+rif9cejL7L5Uvjxmmn
	 Fw15ZFguBcITOg3hc+tfABh/s03IszofdxDKfTadhI+XvKL1DGOGrxGHDxhg1QUZVw
	 Sb6pbD0NFEMfg==
Message-ID: <b0abfdd5-b72a-4f62-8e0f-b6140d3e5fc7@kernel.org>
Date: Mon, 11 May 2026 14:18:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] userfaultfd: ensure mremap_userfaultfd_fail()
 releases mmap_changing
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260501145433.156211-1-rppt@kernel.org>
 <20260501145433.156211-2-rppt@kernel.org>
 <3a04ae6a-049f-4d3d-b5c9-e60e86be8e5a@kernel.org>
 <agGz5J6EKskMk26F@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agGz5J6EKskMk26F@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b7b1h1rbsfru3zm3xe44g4c11kqzen8g
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0BB3D40012
X-Rspam-User: 
X-HE-Tag: 1778501897-634272
X-HE-Meta: U2FsdGVkX1+qkzHX8Jj1JY31BPlzB6smIJiJGWqdVdaxpK/81n3vKA+g1T5w75V+9HE4NPkXRCV3UjDMUVDijonLQ7ZLK7eMmrv/FrdWybpL3wOPQfzFAcnCtTWBRTzAX78hf2N57qBAbc5eFP8fKLIBh5928dK2EgPg1/BQqjF88qW+lII/ariz0zOMtivb1CRCEthreQxXQAlesr6rwP0ypy9VSjhCL/UIr44Y487O3yz1Le75QMpt2jptZU0hb8YagL9RXB1u1sThBoqmi1PcSu05A3MhpnnA5WM4f+0JTnkdKeQ+PCyUuNcCM0aI2cP9Lx37R8P7rxSWx8bELUIz1k8+p7Svso9pR6mZb0yJJELvehP1Z51Bmff1/e2SXTMc2VC8c41VsWjjqFH+7VtiyTuLnk3eMos5ytV0qcMfpJh8k1HKEisnCDNB+Enmag8ySezq7Kptq+HLfBr8UAL+qRzSlx0JB47Nyc8ov+F+9leoE2LEfG5MhOb7BPttF0dxT/k17FmpiUHFtGeLfugc+gub8WxOi6Kmkn/4RkO5QJL5xBuHzmOt07YXuS1yxSs3/GAPm6zc2LOg2BPCQkZKPlGiQmYllEpYPE0EUV4D5UiavREp9QzjJYToMbPT5iqi76A1nb5UATJG+J63zRM9fk8JI1ZHyTHd4zJcW4f9NJE2hXY/c3f7X0vCfeJ3FQHiHJyIHuOmutrCgPk2QjWwWT/fnzGcclOyM3vGUqQtSnD389AXNXvvICC8F83o3LgZZqhdSPQyj7j/PdDPBzfJ5EIuX0n6OOX5loAYCpohnvYaFvc+xpvmtk8ChmY6NNDkoRer64BqRaOcf381cJyNPPpw0t3tZzVOvJfWNev1Yq6AJaKN89TCvSDIxVq3zo4i6nUAScbIYhsGBHDZdC6xxTUXFbCXQtcYy6hiJJ48p9n4P+BHewuUfLs6fJ+qnbe6KbwO14az9IUxG/p
 KBJYcT57
 W5sTEMJm6mEGz5REaxb41L3fv0LZxefqhD7MvoXjq5dsfxf366wa1R4QemrJ5ZJTCY0Vtpcip2+m6HPs7+YgHtU0zJuUdwzt9TWt1oG37tHUv1YYfJ4b+h3qKl0U3vdgWIq5lBu0zNIAL7rbwGzh7KPVq45msoTtUtoTisln7aMPKDVp0NfzLuEsVSXmQtQbGSIV+cGRYYE7SbxuuudYIMz2gAuAUcO+vpO1bjeeca52toGUbkuy6IUnVJ8g781NUtva3kjYccMg6qNf9OndQp/FzJ0EA6gVZ4YwsDOWrpFA3H49j924r9Eniqa2Tz5bAfueLUNvQ/P5pD/j6FqK/rlG10wXfYFFTjBt9IWu75nUWmhsbBPIWS5I8ca0YWdqzeyuc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 12:48, Mike Rapoport wrote:
> On Mon, May 11, 2026 at 11:15:34AM +0200, David Hildenbrand (Arm) wrote:
>> On 5/1/26 16:54, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> Sashiko says:
>>>
>>>   mremap_userfaultfd_prep() increments ctx->mmap_changing to stall
>>>   concurrent operations, but mremap_userfaultfd_fail() does not
>>>   decrement it before dropping the context reference.
>>>
>>> If an mremap operation fails, ctx->mmap_changing remains elevated. This
>>> will causes subsequent userfaultfd operations like a UFFDIO_COPY to fail
>>> with -EAGAIN.
>>>
>>
>> Sounds like we should CC stable?
> 
> Yes.
>  
>>> Decrement ctx->mmap_changing in mremap_userfaultfd_fail().
>>>
>>> Link: https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
>>> Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  fs/userfaultfd.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
>>> index 4b53dc4a3266..ef963a58f1a1 100644
>>> --- a/fs/userfaultfd.c
>>> +++ b/fs/userfaultfd.c
>>> @@ -786,6 +786,7 @@ void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
>>>  	if (!ctx)
>>>  		return;
>>>  
>>> +	atomic_dec(&ctx->mmap_changing);
>>
>> I'll note that other users have a
>>
>> 	VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);
>>
>> In there. Likely we should do the same?
> 
> Yeah, we could.
In any case

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

