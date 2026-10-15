Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D537DCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA416B0088; Thu, 15 Oct 2026 09:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9536C6B008A; Thu, 15 Oct 2026 09:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B056B008C; Thu, 15 Oct 2026 09:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C23B6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:17:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2AE4409BA
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:17:27 +0000 (UTC)
X-FDA: 85324912134.19.AD073A7
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86FB9C000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:17:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NmKIkLDn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792070245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64fsrmqYqAM2LRJrklTlJo+mQUspAPPQxg/iuLq8TSY=;
	b=li7KgrJ/efVlhtACajXqMYB+TW3NqgpsbCuILa9D3NB33ey2atmQB0wxjlGwd8o/t0dI/m
	3OEtpMrGHKVyBh1zB2SApOri7OR2P5R1ffZCaOyHlABoZoB0QpolRxQwFy2c9AerSycoPP
	B9okdltN3O6LCbY0lQU/2cpuR4wi39k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NmKIkLDn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792070245;
	b=W0ALHYcqzu7fDDSb52HZPMUXRlBjzXqE1ZwptNEST2AUG4PrkwmaKbobCsdP92A933IVDn
	1bIhv5EgWoqdTfTI7zJ8IaNmu9fBctuqBHKQWj2uNZeZL7L/8eYRiiGY+B/SoNhDv5iat1
	cB6Ryg2FpTju3C2HlSnP3NjuWLLD1bc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hqinzRPIxuUU4bOrqaFfByb0krG+U3rhEL4mgvlQiR4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792070243; v=1; x=1792675043;
 b=NmKIkLDnZDG2y73ti8vR3cwK5ietiaVKNZrQ9S4T2DlcrrhmpqONXF4JHNPiCWBVEev94Xyd
 CQDgP4w/0Qb8ueVlt+VqJeszL7cXupOShs5XJ5f1C54peQlYjKf6XD0+9LjJ8GGbcp5lA9gqMRo
 HqHhlwYf7Rr6oNhM09S47f6c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f603c4a714d74cfa;
	Thu, 15 Oct 2026 13:17:23 +0000
X-Mizu-Trace-ID: f603c4a714d74cfa
X-Migadu-Flow: FLOW_OUT
Message-ID: <a36e9e99-f7c8-4aac-bc05-8a042cd9f438@linux.dev>
Date: Thu, 15 Oct 2026 21:17:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Jan Kara
 <jack@suse.cz>, Hugh Dickins <hughd@google.com>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
 <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
 <aqbvFtlXd3Jdnfbm@gremlin> <1fe4027a-6ad8-42a1-9943-cb3b8aad3fb6@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1fe4027a-6ad8-42a1-9943-cb3b8aad3fb6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e7anmsy3jj3gquxmkzfidwfc9f4frbug
X-Rspam-User: 
X-Rspamd-Queue-Id: 86FB9C000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1792070245-917376
X-HE-Meta: U2FsdGVkX19iohksx4hToyzXuy2VjB0c+LnPJFMrdpDDmlPDIz7ie4xkoU4T7EHhtXs36UP5o0FFotWg8jolzhZTr4KxNUx0weyzZyb+r0Frct3k50kYRLKugiYbSh6KsAmV+xBs6DRr0457ZFArMqoBXAYWR9DgYj/y+hz/bmGwLTUpoQLorf0XFoZVKlgRfw1qFtPBnw8GZyq+LmYcfHa5DyyxZ2S4VgIgGJ4sXOyFcJAEBu91RA7glxVI7p3YmRgygc9x+kOVZNKLlFyXHFdUrfssBHmf3SEwCsQHeRquni2mjqdJEKhdG4dZdX9Aegjm55a5eMuyyqHIMlgLdY+oq6Sv94sEH2zxbYJW3C24sMFyBcOmqaqEyk2qIv4fZ2EOYXBHdoAJA32DU1nQQAx26RNtdaBmHu+WmMpD2KGNJO5uV5KZpn+kygvI96JKN+f1bKHcVA6YFt47e+Ej7E6rSfDv3huoD1FLefIhDkUzfRqIKiz8umWFfnyTL7ruoGIE67v5rqCFcnYT08Xdx22a3HrTBkhTgfaYIiaWPjW231+ybQOXOCHxaMn8hy/V1MNNPZXkYhysGm5yxbmCo4kBXC41yyV58dmO4so40oAKhJBcFzmzLJEy305GyCbEgyZJsZamiG4WgBDEA/9txsTAnTuqi9wsJdYobhJ6l9AXdcqQsuoLZZZNORStGENNPDRfOfXsq6MVxM3mM9tWWv90h9dYNgqDkwi9PqNUXIfXHCPNdo1arzUGgF2qBxN/1tI6BJFc0kGxyrhSaiMC4GCV562nFzd6HFE0e3IV4+lbUfv0YH01WViTzyolEnwz3UO91Z7bgaFkHZ43vNM8rPr4PAgdmww3hAlfd8bBIVE/9hG94mTOrRdM8SSQ/TbnKwA0kAnsjrIfU60b3bOrqKy2x0W+dyZOwkggJahzpUYItLhu6t5RBu3QW2a2GTxGMtDW1FM8xTCeCwF0iZo
 tOISZfAV
 R03yaM5GOlLLFex3oRD4F5W3TwZ4tic2+pBPmvaqf7f2aRQO3C5+e82qeH5rPS3DFCKMF0Luta4NfYpGxX7JjRa1rbiEkp87zD+4+PNK6OPYR7+Sa9iB8LPXRXwJudmOOd6x7NlZSC9DfHWnkdGR4GTUSBlkkC1X4fdTBrqq4/9sp/M3iBlGy559wDkjepLJfHUCy6KLkGJvzm5n2jWRrDabLW1bL8YAnAm1R/LcwiOT2WS0zL9JHL3JEPhGeWU0P8R6C9/Ggqtms7m1TZaTMShPpt2mvAAR6eeRAy1QjBbpLK99jCYApJWw2kALoXo4glcobo7N36hY+q5xtgbyLBT5SGM7qO0jZZOWyH4P9/exoeGPe1cDJrku4YQks7gh9tCsQVW3fvsQK60uUH8WgJwsWKMsTTuBfwEOAtaFpnTOhmnl0C+S8gbm/8lAEwyo24P2NhdnweDHoRrvY7VJ+Onodvn7b5vfdM9tQmdYvWoCIHvPolzvsJFMHmCWsxK6aXJNuyRJ/5GdsjnwV+TSp7X3a1LWQmeG4wIFbTc6Vgia0CQYyesHDKgkO1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/15 20:26, David Hildenbrand (Arm) wrote:
> On 9/13/26 20:48, Lorenzo Stoakes (ARM) wrote:
>> (Nguyen - do not send v2 in reply to v1, look across mm and see how things are
>> done here).
>>
>> somebody who has a
>>
>> On Sun, Sep 13, 2026 at 11:17:00AM -0700, Andrew Morton wrote:
>>> On Sun, 13 Sep 2026 23:36:44 +0700 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com> wrote:
>>>
>>>> collapse_file() calls page_cache_sync_readahead() to fault in missing
>>>> pages before collapsing them into a THP. That helper takes
>>>> mapping->invalidate_lock itself for the duration of the call, then
>>>> drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
>>>> takes invalidate_lock and then waits on each page's folio lock while
>>>> holding it. If collapse_file() has already locked one of those folios
>>>> by the time truncate reaches it, and then tries to acquire
>>>> invalidate_lock again (e.g. on the first readahead call, since
>>>> invalidate_lock is not yet held at that point), the two paths can
>>>> deadlock/hang on each other's lock: truncate blocked on the folio lock
>>>> collapse holds, and collapse blocked waiting for invalidate_lock that
>>>> truncate holds.
>>>>
>>>> Reproducing this over ~150,000 collapse iterations with truncate
>>>> racing concurrently reliably hits hung_task: blocked tasks within
>>>> about 20 seconds on an unpatched kernel.
>>>>
>>>> Fix it by taking invalidate_lock_shared once for the whole scan, after
>>>> alloc_charge_folio() succeeds and before locking any folio, and using
>>>> page_cache_ra_unbounded() directly in the readahead call site instead
>>>> of page_cache_sync_readahead(), since the latter would try to retake
>>>> the lock we already hold. page_cache_ra_unbounded() does not clamp to
>>>> EOF like the helper it replaces, so clamp the requested range
>>>> explicitly.
>>>>
>>>> 730633f0b7f9 added invalidate_lock acquisition around readahead but
>>>> missed collapse_file(), which already locks pages while calling
>>>> readahead; later filesystem conversions made the deadlock reachable by
>>>> taking invalidate_lock before waiting on page locks during truncate.
>>>>
>>>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>>>> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
>>>
>>> (You forgot to cc the original author)
>>
>> Also a change log, and that mm doesn't like sending a respin in-reply-to a
>> previous version. Which is all consistent with somebody using e.g. openclaw to
>> pepper generated patches across the kernel...
>>
>>>
>>> Five years.
>>>
>>> I wonder why this hasn't been discovered by lockdep, AI, syzbot or any
>>> other of the tools we've been using for so long.
>>>
>>> Thanks for doing all this.
>>
>> See https://lore.kernel.org/linux-mm/aqbtfms0_2ULBIT7@gremlin/
>>
>> I am not really entirely happy with somebody who has sent a flurry of patches
>> across disparate subsystems with no previous track record being in charge of a
>> potentially backported fix.
>>
>> It's David's decision but I think this fix should be taken over by somebody
>> else.
> 
> So what's the status of this? Any volunteers? Otherwise I'll polish this up.

I can take this over if no one else volunteers :D


