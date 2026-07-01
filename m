Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56396C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A6C6B00A9; Wed,  1 Jul 2026 07:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB076B00AB; Wed,  1 Jul 2026 07:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4336B00AC; Wed,  1 Jul 2026 07:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6E26B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:02:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 110868D16B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:02:20 +0000 (UTC)
X-FDA: 84939918840.22.2CA0054
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF33F40018
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:02:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DnLpWiCR;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782903738;
	b=BY/GooM2WjhkRvNECiFaFrUwW/uQ40wWd7R2xoyBCIB/k8KbPXUK4ooyZKDRJQ3X+EnZU7
	XDiW5nSrThmhiypjuUKttSObt8iMS6VMru/bW7MJpRRsVAhQzNKqYl4uXy9mzZOzyXpBC1
	6XQOujiJexLe4L/jK0IiUWf/Z7Dc5Ls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782903738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPH4Wbb7vWkYcWnzq9COp5K4O/xDtmN6JFyEAuy/kZk=;
	b=tkRAvCVF10HQNfyNmm2uDnSQSj3AdvxXEwedYzhDIK/aDswMfA001pG7fh269FDQT53zb/
	QMCjWE/YP+ATvgYGjgkKZXcWV0xfk0HG8n/nsiwvQlPp3on+hiu9FQVqx9j3PRlav24pmS
	+zwkXu25AdRgqGkbhWdtH5Mybpnvl10=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DnLpWiCR;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782903735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPH4Wbb7vWkYcWnzq9COp5K4O/xDtmN6JFyEAuy/kZk=;
	b=DnLpWiCRptxj5i70Y8eh9ciGLCcAqKuUl5ayokBW5ylbwAM2KSyWzZScryyL45l7BA5tSw
	94sJfycwMoc7XqkRtLVkKbOBa1wGFdpG8aXwKjLK27d/L3R6kEh3n6ffroucsddg8LZBS5
	sWcw7oK9C+o0o6RtwPG9wcu06pucbgM=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	ziy@nvidia.com
Cc: vbabka@kernel.org,
	akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: add page->private check back in __split_folio_to_order()
Date: Wed,  1 Jul 2026 19:01:51 +0800
Message-Id: <20260701110151.77453-1-lance.yang@linux.dev>
In-Reply-To: <98cf3340-1a2f-4d50-8410-6e9d6d3a5308@kernel.org>
References: <98cf3340-1a2f-4d50-8410-6e9d6d3a5308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qy8jpgpothrqeqzyaomjpodn7hnmiwzg
X-Rspam-User: 
X-Rspamd-Queue-Id: CF33F40018
X-Rspamd-Server: rspam02
X-HE-Tag: 1782903737-148118
X-HE-Meta: U2FsdGVkX18UOhXJWHYODqH5hgAKrK8LRlrEiixr4OcIDIoKLr9gea/uBloHs018OPtyVcycu6/EpuzzgslpolZCU4cITPwhxlpGmGDKgs92PD3u1qjrNzrIzrw0HaInEnl/uJo4eUosdJG8+xS/5pwdx4NdEExHho4ih5pgh3mxGw5feGEdxyDIayO7RYVI+esAMZOHNyudJCY0HVuq5bhnx+qwt/Dk2CcIxcrVGJfVUwjOVYLAwaW3ZJVnGhIh+Z87Rjdf5rQUUBq93qeLP22esGfiCpqPLeGpn+qbxHTcJd7Gzsr47lCPZKnC3q8bXnEpGk+Ywajgv5/UHuaXiBFPb6ldS2iiWHWmpx/UFWSDXw6+/b2XKGmoT+gs/6zl1cSeVaEfQfoBmS+Ff92nHLfgZrC0ROm6NMihQawAj3DG1AxDJHut7q5Xt7zKnXgd4BdIXIM94p3ricmiTCBThKxbfRXgc7nxydzCkaZYSAM9d1jVTaKQPQLOgCcX/B6T11Rfk8LNNkadK96S6Y25ZvzEgoKdcUpb3i/8vXauY35SrlI3iMKBK1t859um2j4IFXEnS7YNtWimeTOupu4Uy+khkoQryVYr6JgCHgf2pZGfP+zQxQty/WoPpt/I+zsM2g3UmuAg/5JtM6l1cm4dTZbUWYj7sJWHbG2nSjakDpwC9dXVmCZ/Omx32MT+RpzsY/XpeyRSH8m/B615AzntNwg0XpOw63viJ6xxy2UY/6u9/66S8ZgsCGBw2z+Mb4LHDI2WDqvGkbh2wq7jvABUPhATgT5uxImHe5PKXOmTG8WyCGdKAcInaw81syGvoHiRVMOZZ5D9VqMkdltVQFp1ZrMg6fLj6V6HWFS53B5ITAn+sMEwTAYb9aOHBIGTzLEKeqxwoyxVpmGuF7OiNP4UMc94fta7VLt0VTNtp9sd22M3RwGQ5T42yV77cEUYElE+4ZZea5V5qYpL9Qa065G
 NavuPuSy
 qlxL7XSfilBXKcq+g7AacerYl9IRykX0j/nE6npaWqYKmN3F0N0u6YBBsn3QcUNQJ3OGX9izG1Blm0/9vSl0WYg+iygE/aJU4rIgcblMlQJYuMPFDm9SMZxLwxIlWw4h8Oc5RAiwVEIX4BJcINmeuniQtXua8Hi3TaimTHX1ZLxA0N8d8v+ianbrAmspxu+dDRjOOCe7kZSQxV9kCw0y60KUxXdazB+eNffzZR+Z5HNWrxvhl8lgDImtx7+5o1SPgX8uFcOE1uY0Vw6IBRICPzoDBjS7N5CbaeHQ+5Vyzm5dkIaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jul 01, 2026 at 10:56:47AM +0200, David Hildenbrand (Arm) wrote:
>On 6/29/26 16:39, Vlastimil Babka (SUSE) wrote:
>> On 6/29/26 04:56, Zi Yan wrote:
>
>s/add/readd/
>
>>> page->private should not be set in tail pages. Commit 4265d67e405a
>>> ("mm/migrate_device: add THP splitting during migration") removed it
>>> without a proper reason. Add it back.
>
>You can link to the discussion where we clarified that this was not intentional.

Probably this one?

https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/

>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/huge_memory.c | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 2bccb0a53a0a..037d67fbec6e 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3594,6 +3594,16 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>  		new_folio->mapping = folio->mapping;
>>>  		new_folio->index = folio->index + i;
>>>  
>>> +		/*
>>> +		 * page->private should not be set in tail pages. Fix up and warn once
>>> +		 * if private is unexpectedly set. Do it before swap.val assignment
>>> +		 * since private overlaps with swap.val.
>>> +		 */
>>> +		if (unlikely(new_folio->private)) {
>>> +			VM_WARN_ON_ONCE_PAGE(true, new_head);
>>> +			new_folio->private = NULL;
>>> +		}
>> 
>> The unconditional warning means this is not expected to happen. In that case
>> it's odd to check and fixup always, but only warn with CONFIG_DEBUG_VM.
>> 
>> If we are reasonably sure the current code is OK, and only want to catch new
>> mistakes in development, we could just VM_WARN_ON_ONCE_PAGE() without fixup.
>> 
>> If we are paranoid, leave it as it is, but drop the "VM_" ?
>
>Agreed, either "if (WARN_ON_ONCE(new_folio->private))" + fixup, or no fixup.
>
>I'd prefer VM_WARN_ON_ONCE_PAGE().
>
>(I was only able to trigger this once while testing my own patches)

Looking at the history a bit, that check has been around for a while :)

b653db77350c ("mm: Clear page->private when splitting or migrating a
page") first started clearing tail page->private during THP split:

static void __split_huge_page_tail(struct page *head, int tail,
		struct lruvec *lruvec, struct list_head *list)
{
	struct page *page_tail = head + tail;

	...
	page_tail->private = 0;
	...
}

That was too broad for THP swapcache, tail page->private still carried
swap_entry_t there ...

71e2d666ef85 ("mm/huge_memory: do not clobber swp_entry_t during THP
split") kept that swapcache exception, and made that tail page check
explict:

static void __split_huge_page_tail(struct page *head, int tail,
		struct lruvec *lruvec, struct list_head *list)
{
	struct page *page_tail = head + tail;

	...

	/*
	 * page->private should not be set in tail pages with the exception
	 * of swap cache pages that store the swp_entry_t in tail pages.
	 * Fix up and warn once if private is unexpectedly set.
	 */
	if (!folio_test_swapcache(page_folio(head))) {
		VM_WARN_ON_ONCE_PAGE(page_tail->private != 0, head);
		page_tail->private = 0;
	}
	...
}


5aae9265ee1a ("mm: prep_compound_tail() clear page->private") followd
the same rule. Changelog says the warning had already caught real
non-zero tail page-private values:

"
    Change that warning to dump page_tail (which also dumps head), instead of
    just the head: so far we have seen dead000000000122, dead000000000003,
    dead000000000001 or 0000000000000002 in the raw output for tail private.
"

So prep_compound_tail() clears tail page->private for tail pages:

static void prep_compound_tail(struct page *head, int tail_idx)
{
	struct page *p = head + tail_idx;

	...
	set_page_private(p, 0);
}

cfeed8ffe55b ("mm/swap: stop using page->private on tail pages for
THP_SWAP") stopped keeping THP swap entries in tail page->privata.

So split code started warning and clearing old tail page->private before
setting the swap entry:

static void __split_huge_page_tail(struct page *head, int tail,
		struct lruvec *lruvec, struct list_head *list)
{
	struct page *page_tail = head + tail;

	...

	/*
	 * page->private should not be set in tail pages. Fix up and warn once
	 * if private is unexpectedly set.
	 */
	if (unlikely(page_tail->private)) {
		VM_WARN_ON_ONCE_PAGE(true, page_tail);
		page_tail->private = 0;
	}
	if (PageSwapCache(head))
		set_page_private(page_tail, (unsigned long)head->private + tail);
	...
}

00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for
folio_split()") added the same check to __split_folio_to_order():

static void __split_folio_to_order(struct folio *folio, int old_order,
		int new_order)
{
		...

		/*
		 * page->private should not be set in tail pages. Fix up and warn once
		 * if private is unexpectedly set.
		 */
		if (unlikely(new_folio->private)) {
			VM_WARN_ON_ONCE_PAGE(true, new_head);
			new_folio->private = NULL;
		}

		if (folio_test_swapcache(folio))
			new_folio->swap.val = folio->swap.val + i;
		...
}

4265d67e405a ("mm/migrate_device: add THP splitting during migration")
removed that check ... Worth noting, David pointed out in the thread that
the check had caught bugs before. Guess nobody really noticed at the time.

https://lore.kernel.org/all/76750d20-cdfe-41bb-a228-9b3f171675ec@kernel.org/

So adding it back makes sense to me. Just in case it's useful later, feel
free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

