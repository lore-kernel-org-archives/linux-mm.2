Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2CB6C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1FC56B00B6; Fri,  3 Jul 2026 05:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7316B00B9; Fri,  3 Jul 2026 05:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6BB6B00BA; Fri,  3 Jul 2026 05:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 637DF6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:21:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E30428E3B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:21:05 +0000 (UTC)
X-FDA: 84946921290.08.B4028C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 36F2A160005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:21:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=er20X6E4;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070464;
	b=OOCXl/hclKuBgZNUgqAxRev6PiqqfHdmO5yUwUyQ+EI2Ar7cERyAHOqkeh5UiYctxk2gea
	ro+MjtRcZIuKHP2t3M7CFsVZso84vupOBmgCRanmB1Hdy92LCJgkQUOhDnUMAIW+DHpdWY
	mJd/M1aaqjp9TxJ+NYjjFqsmnX0kivo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRHs68uZvA9um2gm65aY4M4ReG5L7r5Gco47C8yFhfw=;
	b=wiop+6+SPPR19zJRjeyXnyiM1oPRdwt0Xu5+thK2MHtBFRV9+LQ4qYZcRML7FDIrXgkQDH
	eP8wDl+2L30H73mKe89d2Wxe5ilWWsxmf+SzhQFxjw1P3cyiEmgeLzFfILHh3goqyIwbfc
	lnh4A79WnDiKenXbjEa+kyCCZL1J6DY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=er20X6E4;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A819B60121;
	Fri,  3 Jul 2026 09:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97931F000E9;
	Fri,  3 Jul 2026 09:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783070463;
	bh=LRHs68uZvA9um2gm65aY4M4ReG5L7r5Gco47C8yFhfw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=er20X6E4CCctj3eE7ZkCYz1M034Z/dOeLXhhW4SXSHRXrNAdk8ORvRd78IdzAbnlx
	 1XwS/Sj4Qy41VCSnWZTXn/Ueyhi9Hkl3GhMZyM02Pf2XRW4AoSTrJv/HwmO3VIFhpy
	 H3E9Rxi9sFJ0olWtSmlvlQkcSPXm/DiXePmcUSydvdHxi2IOPNM2VvUO+xmofYmgaG
	 KOBXjNOGM7D4+q538hTKSTBVko3mqvABUa1ZQvMRGWR03r2nnoKNTz6I+m27A6wdZN
	 J7hUAsQXmzayViW3Mv1ZEg2RwRb/9a6JbeIudqEvgrciOYFi/iOHW6gWmPUAqtm8Ly
	 2Ksvsni8s0uIw==
Message-ID: <474e7222-7589-4e8b-8a3c-f85ec2335f19@kernel.org>
Date: Fri, 3 Jul 2026 11:20:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
To: Lance Yang <lance.yang@linux.dev>
Cc: pfalcato@suse.de, akpm@linux-foundation.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 willy@infradead.org, song@kernel.org, ehagberg@janestreet.com,
 ziy@nvidia.com, gleventhal@janestreet.com
References: <e924bed9-4c46-4fe3-b6cd-7c77fd9e25c8@kernel.org>
 <20260703090232.26261-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703090232.26261-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 36F2A160005
X-Stat-Signature: ihahrk7be61543buia1a5mzt8wz4q44a
X-HE-Tag: 1783070464-519418
X-HE-Meta: U2FsdGVkX1/ui06C4nnWcJxhAzU2/uGYL/EEj/dyLO3K9vWh1gST0+Bov9aiv+xEU4VebUF/5dmEsfuucaqrb3NVVPgQ+Qe3GLxT2fUeoW2W4tieJgE5mt4ojuYXDrHL5VItqKmO3OYGC5BLu9NVvrd6bT2KY3bawoFAdzart0oXn7yAEDdprJ/R7I3RKL1ASnqx8YG4KjpXAE5qdWbulhWRADLt7fCPq0klMjWpq0tStdp9/Q5A3UINwHt7No1iHANrFxSnFWVFLEXZsVTKEhQBFQZtCQZcrfwWT5l3YYeQuYuHPpvXOwBV2kWYVLE9nj7tjehFO0KLaZLcbju8Xqm6e+AWAyUpsQFoWDz8Y7kRbKReclKXCkMk/jfrL19KcQQI5Nyy/WVTssviGRZA0ERCMTgDNSKLGcgAfIMsL/AqOvfN9cdeOHMjL6D+gv0/dUhPyct45AFCsiyIvavkh6lat+Dgjw7WI/n8qWir52YGmy5Fx/bG9nb8JvL1lT6PpF/1zOcxP/vYtsylH5l8f3W6Ua/t1FABT5wi18Nh2t6mntHn4q4Ner8A4C1JhsEuawzgo/UaENv8HB5KhPdQpB4HE07loOr0dBXwhSx7IDRZ+pwR5DjwQuo63QDiNRvgJVf44UXxbXw+kch4iveLTPYsiyuhLxPgzyiO/ZYJA+WjzF9OsQEJMqt4NfDA0YuEy2dCxsspn0PycI6VDc3BBQkN61G1Jxyrjjc+F8bpd2y7nhb0ngSVJc7riNF+Xr5I7mpF15+CTMW8HQtt03rn3oukBJ/mkzlrFsapz6qhLuT5CjWGtcFMF3ijB+SZUNg9dj7/eOq6Lw4MVsAyfIItcxkmSkrZXLWn6mC+vBUxB/DOLrZJ/VwGRzXQsvKf4T6SVGx/+b40D9OsB1Gu7Q+D/x6DukysBRBFkLOQvHzXN1MjFL0U75DCZ8ncb8vPVyFa3vqEZOItcdg/vluveO3
 LyfEGzQI
 eYE9xYpbaU/gvYt15Ch0JlYzbWwlxZPw3LMkV/ddxs9n+tBh4zhrp42qRoC3y3lMm2cbBnP4XJU7sRwAOWuB5oQQa306/EouW4MuQXg8CKJdWaLzie1eUCEYPgdGjCPFbfShGlbNlEMvZm5IZG1toiyMVD6fQOYP7lNE2soF+en60ZQbE6yr6MyLpelCfokWn5asqFrkrmei8+aryKMEt1S+2BDtOG5TgGSANRkhVu9v80KVNHbwgQAvmYqgKdccaL1EY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 11:02, Lance Yang wrote:
> 
> On Fri, Jul 03, 2026 at 10:55:42AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/2/26 18:54, Pedro Falcato wrote:
>>> As-is, khugepaged and writable-file opening exclude each other. A file
>>> cannot be open writeable and have THPs (because the filesystem is not aware
>>> of them). khugepaged will never collapse file pages for files that are
>>> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
>>> particular file is dropped. This is fine because nothing could've been
>>> dirtied.
>>>
>>> However, there is an edge-case: collapse_file() might not be able to
>>> coexist with concurrent writers, but it can coexist with dirty folios
>>> (from previous writers). Therefore, the following can happen:
>>>
>>> open(file, O_RDWR)
>>> write(file)
>>> close(file)
>>
>> Okay, folios are dirty.
>>
>>> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
>>
>> collapse_file() has
>>
>> 	if (!is_shmem && (folio_test_dirty(folio) ||
>> 			  folio_test_writeback(folio))) {
>> 		...
>> 		result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>> 		goto out_unlock;
>> 	}
>>
>> Making us abort collapse.
>>
>> What am I missing?
> 
> Hmm ... dirty folios can be outside the range being collapsed ...
> 
> For example:
> 
>   write/dirty:      [6M, 8M)
>   MADV_COLLAPSE:    [0M, 2M)
> 
> collapse_file() only checks the folios in the collapse range, so the
> dirty/writeback check passes for [0M, 2M). But after that, for the old
> READ_ONLY_THP_FOR_FS case, nr_thps gets bumped for the mapping.

Ahh, so it's unrelated folios, thanks for clarifying that.

("some non-dirty range" documents that)

All makes sense to me, thanks!

-- 
Cheers,

David

