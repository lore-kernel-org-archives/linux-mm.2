Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAEB4CCFA1E
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35EE58E000B; Mon, 10 Nov 2025 22:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FB58E0002; Mon, 10 Nov 2025 22:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225708E000B; Mon, 10 Nov 2025 22:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 123348E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:41:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9595C14039B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:41:20 +0000 (UTC)
X-FDA: 84096925920.21.FA20501
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5FC31C0009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:41:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762832479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpwvWvyN6UfYdWgwybjSKbtxfhXqKfj7yHTX5JMrzI4=;
	b=uPgN0ALxXu9MuPHvZtmPYdDAfzJTpzDsOSo+p+PMVL34qQjJvOlsSOI3lf9L+DfvnM+NWx
	k11xS++lQWb/exTXFKhQQxJwDpWD2nFilIGZNN1G4TVAhj70CTi6uMW1FfyoqNg2+4FaJy
	po4KXQ9u/c+uCU5aj/1Kqi7mOFZe0bo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762832479; a=rsa-sha256;
	cv=none;
	b=PuTiOVAfEYLAI9JVvqHINkDSjySjIH6Np7u/uXPDr7+XbLa7wlmL6z7XPycaWC8Qa8kPqs
	q55miQRXydyf7YN2ACOUdg4t9F+s4nyvHtKcdLV1dGtfcSzmUfsVbv9clIk9qeDk6jv4QO
	q7IHKU0ynUiSJB8YTFQ2kYZOrn8LQG8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FF5D2F;
	Mon, 10 Nov 2025 19:41:10 -0800 (PST)
Received: from [10.164.136.36] (unknown [10.164.136.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A34B3F63F;
	Mon, 10 Nov 2025 19:41:11 -0800 (PST)
Message-ID: <a63d5305-2266-4a60-89e5-d737ba6e2f4c@arm.com>
Date: Tue, 11 Nov 2025 09:11:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3f5f8a48-fa3b-4985-95e1-dd0ac21b5dcc@arm.com>
 <312bfcbd-d31a-40d3-8b9c-edc7b6166113@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <312bfcbd-d31a-40d3-8b9c-edc7b6166113@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D5FC31C0009
X-Stat-Signature: n8j6b7n4sbes17egs9er4xjudk8bxx44
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762832478-97603
X-HE-Meta: U2FsdGVkX1+H4syD79QYb5juun10oA0+D+SM8kCKM3YhUJpeaBlD40F/+YD1RlvOkwDplu+LBu1mggRgSHNKVV6SeyW0oGd7NDWuwaa52x0vytQvUMfe0yllKIUmn5ggz87SXvmffYtXUdjNGRWyH3a3bKK4CEi6NbSruCgOfwSXcfYTvQAl6l5UC1z/TJKKd0aGCPfW0quFjhXwQvTVNWel53PT9Tgn8kdxRUR+btIheu5BrY9hm+G6ya4hcAPn/vhb18sJaMNjMo9Udy9ZBxSReO9W5VJvGmZjnsd/V28jOJeIRICv67XUGABbUn0KHPxMWmU6PpDjl3kaZn/o2iaFyRiWDMBQoPhQLObwOHIUIXjRCE5m3YrufswO7isiR1jCwPYV+8E8YX1ppxDhHnk2mVowD0dt0sxsFQrJMTosCMwWfHgfaEdMmeZ/Hv6JvhVzHAUUOxSE0qoM9HxisAZPWSsOlca+KWgrTkqytbAYIGAxPeRU340Sx6JwOtPnbzxJ8TkGoqtJu9N7ENV6k73ihHkUuJJi5Oq0rmf6mqiG+IbEU0lgBOmU+OBGFoEgbHba0pgQMmSoi6ore5A7QlnFu+ljhOyfpuFOMEFl6AhPkf2LoGRnPUDQyb7+KsgneWSUS5HoMtlQN0Q8/71v4Oi/Macnu3kYSwGTmHgd8peEfUV/mKiDud7aPFBnUuwbH63/0ErRNkC2f1TGnexzg9iBt23sftNUlrW83mxYx7CBWkVQnBTtDSVv7DLm8R5PxxpzZyE7IhAS8dg9snN1ii/Ht7ltngPPhwXzmUms8FIawQEqV8VMP9nIaL3pGtgOuC1bu3sR0bsF1eBnnotvSoYWxAMeLYUQiBzVMXTQJYRahd0xyii5CtZk9/RSWWXE6arEFrvc1OQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/11/25 7:06 pm, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 06:54:57PM +0530, Dev Jain wrote:
>> On 10/11/25 5:31 pm, Lorenzo Stoakes wrote:
>>> ofc you are addressing this with the !cc->is_khugepaged, but feels like we'd be
>>> better off just doing it in madvise_collapse().
>> I suppose the common case is that writeback is not needed, and I don't know what
>> is the overhead of filemap_write_and_wait_range() in that case, but your
> Low.
>
>> suggestion will force that unconditional overhead and skip all the early exits
>> possible in hpage_collapse_scan_file()?
> Which are?
>
> PMD-mapped folio at start of range, scan abort, non-LRU, spurious ref count
>
> I don't think this matters.
>
> And we're trading for putting _yet more_ logic that belongs elsewhere in the
> wrong place.
>
> I mean I'd actually be pretty good with us putting it literally in madvise.c,
> but since we defer the collapse to khugepaged.c then madvise_collapse().
>
>>> I wonder also if doing I/O without getting the mmap lock again and revalidating
>>> is wise, as the state of things might have changed significantly.
>>>
>>> So maybe need a hugepage_vma_revalidate() as well?
>> The file collapse path (apart from collapse_pte_mapped_thp) is solely concerned
>> about doing the collapse in the page cache, for which information about the mm or
>> the vma is not needed, that is why no locking is required. The get_file() in
> The user has asked specifically to collapse pages in a VMA's range. Yes you can
> go check the mapping of a pinned file which you're keeping pinned during this
> operation (wise? Not sure it is).
>
> This would be the first time in this operation we are doing a _synchronous_ I/O
> operation where we sleep holding a pin.
>
> So no, I think we really do need to revalidate.
>
> 'Collapse some random file we no longer map at this address' is probably not
> great semantics, also of course, we are revalidating at each PMD anyway.
>
> Maybe even do a addr -= HPAGE_PMD_SIZE; continue + take it from the top?
>
> Maybe David has thoughts...
>
>> khugepaged_scan_mm_slot() seems to be serving the same function as maybe_unlock_mmap_for_io().
>> So I don't think this is needed?
> We're talking about the MADV_COLLAPSE case so don't understand this? I may be
> missing something here (happens a lot ;)!

My bad, meant to say madvise_collapse() -> get_file().

>
>
>>>
>>>> +
>>>>    	result = alloc_charge_folio(&new_folio, mm, cc);
>>>>    	if (result != SCAN_SUCCEED)
>>>>    		goto out;
>>>>
>>>> base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
>>>> --
>>>> 2.43.0
>>>>
>>> Thanks, Lorenzo
> Cheers, Lorenzo

