Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C31E7E0D9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5D36B0096; Mon,  9 Feb 2026 14:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553156B00A4; Mon,  9 Feb 2026 14:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435506B00A6; Mon,  9 Feb 2026 14:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 309976B0096
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:45:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBFB61B29F2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:45:12 +0000 (UTC)
X-FDA: 84425946864.30.68A3ED6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 505F640010
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:45:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AYqSbQO9;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770666311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anRiDqZ1I1FkFHpEALKWyjVB65Kl7NV4v7lHDof6Khg=;
	b=QwVdDfZvf6r2DipG3jFMiWwbG+I0LO0TdH27dAPpzGwhCaYru3YKCFN9NSAnImNWUjxHx2
	Y4k796PAyeIPLTArGhBrUN7nrWX7GO6rXonq5KxMc5MDwpq2hoGcjE/SepzFNfJdONnEss
	1JiZbT8n3sE7rXezqW7mSU15nWZLnRY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AYqSbQO9;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770666311; a=rsa-sha256;
	cv=none;
	b=Jqb4KqcBKPp4tUwOR0s+GXtlyPVUWdoXJn7oM7kumOhU2i5KExHkocvV8tDdabd/XKjw7n
	L1napop4cfPAerb8akqWfXJ9lYuhUBMSZMSpcCQzAKvfN77mciiQNxjuFusYLpfsd/IT1y
	DDvCahPnBYqzJlRgQArj5/mh/4DdR1w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BFA0D600CB;
	Mon,  9 Feb 2026 19:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EECC116C6;
	Mon,  9 Feb 2026 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770666310;
	bh=1qU5/+CfNMmruXov119kn67QShisKpaOmbmaQuSvV9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AYqSbQO9SsD0PTRC2TIpIFdHQQB9bhI3th75y2dTSqrRStFPbjkueqYtrJUfGwIYp
	 ERgQa79fBLPPuomyN7RPX1i04FpqdpK+SRtiN7+b5r9g2JsMWEBWqWN8foFmiQah2O
	 JPuSy4yj2UPmlNlHy5lCLc0wuoRGsga9T9OJxif9qq6ubosSyCCFjL4TmSTyI1aeqA
	 T1ZZ5oFqvVL34Pid2ZnNd0XLRMRTmQuO1UWvXONw19FReuRxWaymShqM+/bCRlh4vQ
	 7MCX78Sk7PhEdb3wqfvmCgMoGnZWP9sUEr28tldBUEha+i+Ffq/XHaHIlTda3hh5MP
	 5FUu7lO8/T6Gg==
Message-ID: <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
Date: Mon, 9 Feb 2026 20:45:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5x9wuzxz7konwic9m6ikop37xhuw9oxh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 505F640010
X-HE-Tag: 1770666311-266932
X-HE-Meta: U2FsdGVkX18dk3mUw4U2XTxjYqrMdXTDPvRXqdtK3REgdIgNk09s6QQ4Uvj9jjvIlfa2zXD+sWdn7nN4IQlG8FT28oQQsyJzhGz1TBC2pTiaFBhuplSgjNgJS74mKV2AUCbq2hb5v9SmUzaLFi2zqFEFYAEEBj9cceWhNlhi9EacgkrEu5YzElb4g6EX6mfqwbcx3CI7iBeU1iNrXugtIsHFeygFrnq6auHkWWkdhp6MXsBG04mV7aWogEuoVyeG+mYa1xcd0uKZKsKoREIgGKa2pG7STGUYRWxq19cBU3DRSD+63SWAtv2X3walStz8c/Pp7jGfURuj5wdVUaECYZIOd77VQrXZQSMlXQqkWJS34R8299qBIBNlU7cV5FwA6YUYy++IwOmX8gIgkBS6Xqh5isqf38L4vnLTSyR/pk1cZRZos3z/hxUsxZrHKYmltZhJkk3Ep3/kXMDxp3w7znWGjl9ynj1ztxRaz6KXFPx2q5Ch+LiiW5jDPNb/SeVjVwfwRJaYd3/2zpLcJmDRfEZSPWLJHZwI1XOqsKHekttLJDIK8RlbqwhYr+G/omXKQF5Lqzqc+RsZ+rA+IbUNBGTOVaRhF2nugapCsDT3KxZQZXAtLAHpM65XyKFzRRvPuaNP38mbD0mEkmBKGt8Hf2FBbVFB6q2/b8ilVcShibYVSbSDoSl92TSTYPXCA/BtCIEf0scsnx8SZQ8m3EwhjJzms49PhZZNgoLT10fBnFTOZm9WAPr2FdTOkzBnNInfCze4c7QkbzhJ5OMKninFOA0rMd5bSN8QdJsE8/ALPp5bbpcEZ+BOwNfXPpqPMQq56XaMR5jPKRYVmkGyFj1safg0XKGXNWWBq+b7K67U850mhD1Hrvg/B3Pc/LZHHlDHiDlR7DZlxsC71jp+YcsJY40myMU1kdf0B3CGJlDJMIYUupql6BbIj0fw72u14QlliXOpvPbq0DhifEH292n
 Lp0p65Eh
 W8Tt+Eu+jyHfoXr/4cOXuyeZu1iQfXQcKm/Pu1JFcjiHTMUA09BaNHss9AoWKE/yrYW8G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 19:22, Ackerley Tng wrote:
> Deepanshu Kartikey <kartikey406@gmail.com> writes:
> 
>> On Mon, Feb 9, 2026 at 4:12 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>>
>>> On second thought, why do we pass the
>>>
>>>          !inode_is_open_for_write(inode)
>>>
>>> in file_thp_enabled()?
>>>
>>> Isn't that the main problem for these memfd things?
>>>
>>> Maybe a get_write_access() is missing somewhere?
>>>
>>
>> Hi David,
>>
>> Thanks for the suggestion. I looked into the get_write_access() path.
>>
>> Both guest_memfd and secretmem use alloc_file_pseudo() which skips
>> calling get_write_access(), so i_writecount stays 0. That's why
>> file_thp_enabled() sees them as read-only files.
>>
>> We could add get_write_access() after alloc_file_pseudo() in both, but
>> I think that would be a hack rather than a proper fix:
>>
>> - i_writecount has a specific semantic: tracking how many fds have the
>> file open for writing. We'd be bumping it just to influence
>> file_thp_enabled() behavior.
>>
> 
> I agree re-using i_writecount feels odd since it is abusing the idea of
> being written to. I might have misunderstood the full context of
> i_writecount though.

i_writecount means "the file is open with write access" IIUC. So one can 
mmap(PROT_WRITE) it etc.

And that's kind of the thing: the virtual file is open with write 
access. That's why I am still wondering whether mimicking that is 
actually the right fix.

> 
>> - It doesn't express the actual intent. The real issue is that
>> CONFIG_READ_ONLY_THP_FOR_FS was never meant for pseudo-filesystem
>> backed files.
>>
>> I think the AS_NO_READ_ONLY_THP_FOR_FS flag you suggested earlier is
>> the cleaner approach. It is explicit, has no side effects, and is easy
>> to rip out when CONFIG_READ_ONLY_THP_FOR_FS goes away.
>>
> 
> I was considering other address space flags and I think the best might
> be to make khugepaged respect AS_FOLIO_ORDER_MAX and have somewhere in
> __vma_thp_allowable_orders() check the maximum allowed order for the
> address space.

The thing is that CONFIG_READ_ONLY_THP_FOR_FS explicitly bypasses these 
folio order checks. Changing it would degrade filesystems that do not 
support large folios yet. IOW, it would be similar to ripping out 
CONFIG_READ_ONLY_THP_FOR_FS. Which we plan for one of the next releases :)

> 
> khugepaged is about consolidating memory to huge pages, so if the
> address space doesn't allow a larger folio order, then khugepaged should
> not operate on that memory.
> 
> The other options are
> 
> + AS_UNEVICTABLE: Sounds like khugepaged should respect AS_UNEVICTABLE,
>    but IIUC evictability is more closely related to swapping and
>    khugepaged might operate on swappable memory?
Right, it does not really make sense

> + AS_INACCESSIBLE: This is only used by guest_memfd, and is mostly used
>    to block migration. khugepaged kind of migrates the memory contents
>    too, but someday we want guest_memfd to support migration, and at that
>    time we would still want to block khugepaged, so I don't think we want
>    to reuse a flag that couples khugepaged to migration.

It could be used at least for the time being and to fix the issue.

-- 
Cheers,

David

