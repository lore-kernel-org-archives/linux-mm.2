Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C24109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCDA76B008A; Wed, 25 Mar 2026 10:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA55B6B0092; Wed, 25 Mar 2026 10:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB8C6B0093; Wed, 25 Mar 2026 10:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 997276B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:46:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4AAA1160777
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:46:20 +0000 (UTC)
X-FDA: 84584860920.29.93C7971
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf29.hostedemail.com (Postfix) with ESMTP id E96E8120011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:46:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=XBp6zgmM;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf29.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hw9c4hUeyMKCxopsXvXeiExdgL8nvV2dVxV/is4+Q3Y=;
	b=kM97Qid3ywNazyHGXrzb3MrUTgg/fUjdbQ0ymzOmuP5xKsvIymnP7Uem7N5ri8XUN/XEwz
	oeossEinD7SDZGhF34vmzlajhyggkz6vetKUYR5OjvDaYuFaj1TgO3u+ddCI3MdS5vM1YV
	aVF+Vhh+dYpjWN1660lhtbUNyRSLjZ8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774449978; a=rsa-sha256;
	cv=pass;
	b=5VD6+YxnIcqbNK7nu09xbqlb4hwc8Dfl4pE/m24NDDe6YTR100V77jHac0MIysaB+is6N7
	uHuv4ZfAS25mgvNlAA/Az9ms0IZIFb3XLHobucXG0mUdA+FSNT6Mhk0NvbV0WpGQ+ZDDzB
	DL+pYPTDjMiG7xYMoWfFUHnRUg4B2B0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=XBp6zgmM;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf29.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1774449955; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=JFgNXkOR6J8/gVvuDEmxq1aA/+WTJqT3aeG6SQ0mkh1AuMESL9nDZxcdoQHM4XudwahnDV7c5NTX+sY2IEBzoPmi4iy9/NuTyy9Y21uxXjXzQ1ZS6u/Qi2bILp03tcT7EeZ7JkpkLM/zr3bjQH+dKFZfu9EWaeWUUjXRTqWo2jc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774449955; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=hw9c4hUeyMKCxopsXvXeiExdgL8nvV2dVxV/is4+Q3Y=; 
	b=b+ebHK1hBAXn74jodUbT1eptuUUdmL6AQlqGiynRJC1AF9JtwG43BPK1b0G+rETTF5ziGs9RUFZglqz+1TKJTf6iZEj857DR9Tq6B0twwKWGKI9JMxxmUgbDVc6bSGcwXdSo0FaEarX5mJFz4mtyZuoL7ve3roIizcDe2DMgS2w=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774449955;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=hw9c4hUeyMKCxopsXvXeiExdgL8nvV2dVxV/is4+Q3Y=;
	b=XBp6zgmMb2dtiNG/YtFleov32Xi01NMUFNYcntdl6XOvXacaxSbEtb13PCoFwibC
	R6lB8ogCimbmgg3QegyzNkYKuwPYDsj5ITh7zWv+pmZYh9J+vo8qoZMZGuc2s/GMsyy
	BG09e5hq7Txcvpiv/wSfHo8AbtCL1b7H7ucbNy8Y=
Received: by mx.zoho.in with SMTPS id 1774449952819743.5779202678423;
	Wed, 25 Mar 2026 20:15:52 +0530 (IST)
Message-ID: <6c622c69-cd88-401e-a891-6fae56cab8a8@zohomail.in>
Date: Wed, 25 Mar 2026 20:15:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
To: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: E96E8120011
X-Stat-Signature: gphctz4gck8bgzr935o9rgwu13ga5bsn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774449977-103171
X-HE-Meta: U2FsdGVkX1/S3bMVoY3FfalKr+o2/7GW+yavLbfljRDyc5sdQYsAcGXclhUwqdq+GmL8bh7F5h5t5b62rWdbBHd2y9uRmcn3BqdnmG6XNdn/62hJopvAmwL4MMsW4ph6z6piu0mWVvP+kaNsD3d8BNLKIwsEf5sDdzIxuEMhM2lVpLMcTcvd3K/nTgxphV1nvHy5zUTHg88/cXF/eGE3uH0MRRdpkEk8LJXD+ZPMHoaZmd9ZKuBGMAsBp//6kxtdRHCuWao626Y6UZ2cbrjFYwATti4h3YD1xDpa5UT1vKLojdB+7kuCqnZl2T0vPVzy3cuk5WdHmnR9fnOve5dPDg5NzK5z7xfQpwHJUHIi1kwjG4nj/15OdPkLQn1GMCzxuJJV3MhxVoRrFkhWrF1bK1p/RRkG6uY9P0wJ+tA1sz4HDGLJbYQVoUqtJWPtv1mtV7TMErv34nvdeZvC28uPG4Z2t6QkMQsTLhcf3bf2cfi4J0XzbZg8KglHpt4hDrcpxIlbHrFg2mFZFUXybor9OHPJdmEGGvEv+N+hMlsxzY7W4bPYV+D79jUcFoWANz5zJwf+xNgRcqyGWjBUw1GyRFU1vRn8FBgEwpV/IqjN5wD8PlDl17mJc+I2LOeEhmNZu+v59SAO2H/ftfDJLCPvYWU+6qdo9fiQSNPYT+rUGTJKVUmZPf6Vee9ESaJug+njOtyPrjE0pkiCbwoi8yx6RvLWK4ZY3kprjBAuaeNxFQ3Z9+7Nd1RH9YiXWTJOcaCKXqt1a+YjKLuaa+M2NK1fv7hiyeoN0VlcJnp/43G9wS4VUfNxhSZy2kWkgGAsqpK9Q9l7S3J+BrJJqWEttJKV0V+e0gxITMTTYrE+NSead5dcX8Ypfdf7Qae0GOCtOwHgawZDWLH8q0atPIQY2uDrZk7zyBBg28WjwqERWJrWIRy1VBoOlohgPnwA/9F7PBGo0furQ1wqxQpeY66qnmL
 esjoMOnH
 ELu9+AHkVKvIlQhRfIkuTRh25OEBQMlYQCsulRVfDAID8CsT/C+84+wt5PflD3tSxI2vvB1WcYdmmVNa7ECXv/XOLwtG64wEn7FS8NbspJftuWBfnpbu/PlCn0DucroFCpmC+GFVjXjcgP57+svyFAAv+bNvhDJHXcChm1Gf008Ha3s5MdHPkEFzvz36M8HYy7RaF29pxazjcqaT90RHcddiftiJqyOjd7lWhLOZYWiVbuQqdqOQjbnL1BBykqzfbeqZWgCMzSTyuPf0fozl++dC69U8VLD7wjKQ5UNl2dLe3JXfJattKIlotXy6pXgWRyHijIvjrU3wiDl9yG4LD1kQdjNWyo6j9z8mhD4vPh9oOCGPFxWZcT17WCz5DuqsNQIOmf+pFdo+qnWf5PmCT9i86+yHNMyMXqaUaKWXLI5NX4eDT8Lulrs8LuV6yiTZL2N7T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/03/26 15:30, Shivam Kalra via B4 Relay wrote:
> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.
> 
> Problem:
> When vrealloc() shrinks an allocation, it updates bookkeeping
> (requested_size, KASAN shadow) but does not free the underlying physical
> pages. This wastes memory for the lifetime of the allocation.
> 
> Solution:
> - Patch 1: Extracts a vm_area_free_pages(vm, start_idx, end_idx) helper
>   from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
>   accounting. Freed page pointers are set to NULL to prevent stale
>   references.
> - Patch 2: Fixes the grow-in-place path to check vm->nr_pages instead
>   of get_vm_area_size(), which reflects the virtual reservation and does
>   not change on shrink. This is a prerequisite for shrinking.
> - Patch 3: Zeros newly exposed memory on vrealloc() grow if __GFP_ZERO
>   is requested, preventing stale data leaks from previously shrunk regions.
> - Patch 4: Protects /proc/vmallocinfo readers with READ_ONCE() to safely
>   handle concurrent decreases to vm->nr_pages and NULL page pointers.
> - Patch 5: Uses the helper to free tail pages when vrealloc() shrinks
>   across a page boundary. Skips huge page allocations, VM_FLUSH_RESET_PERMS,
>   and VM_USERMAP. Updates Kmemleak tracking of the allocation.
> - Patch 6: Adds a vrealloc test case to lib/test_vmalloc that exercises
>   grow-realloc, shrink-across-boundary, shrink-within-page, and
>   grow-in-place paths.
> 
> The virtual address reservation is kept intact to preserve the range
> for potential future grow-in-place support.
> A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
> performs explicit vrealloc() shrinks for memory reclamation.
> 
> Tested:
> - KASAN KUnit (vmalloc_oob passes)
> - lib/test_vmalloc stress tests (3/3, 1M iterations each)
> - checkpatch, sparse, W=1, allmodconfig, coccicheck clean
> 
> [1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
> Changes in v7:
> - Fix NULL pointer dereference in shrink path (Sashiko)
> - Acquire vn->busy.lock when updating vm->nr_pages to synchronize 
>   with concurrent readers (Uladzislau Rezki)
> - Use READ_ONCE in vmalloc_dump_obj (Sashiko)
> - Skip shrink path on GFP_NIO or GFP_NOFS. (Sashiko)
> - Fix Overflow issue for large allocations. (Sashiko)
> - Use vrealloc instead of vmalloc in vrealloc test.  
> - Link to v6: https://lore.kernel.org/r/20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in
> 
> Changes in v6:
> - Fix VM_USERMAP crash by explicitly bypassing early in the shrink path if the flag is set.(Sashiko)
> - Fix Kmemleak scanner panic by calling kmemleak_free_part() to update tracking on shrink.(Sashiko)
> - Fix /proc/vmallocinfo race condition by protecting vm->nr_pages access with 
>   READ_ONCE()/WRITE_ONCE() for concurrent readers.(Sashiko)
> - Fix stale data leak on grow-after-shrink by enforcing mandatory zeroing of the newly exposed memory.(Sashiko)
> - Fix memory leaks in vrealloc_test() by using a temporary pointer to preserve and 
>   free the original allocation upon failure.(Sashiko)
> - Rename vmalloc_free_pages parameters from start/end to start_idx/end_idx for better clarity.(Uladzislau Rezki)
> - Link to v5: https://lore.kernel.org/r/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in
> - Link to Sashiko: https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265%40zohomail.in
> 
> Changes in v5:
> - Skip vrealloc shrink for VM_FLUSH_RESET_PERMS (Uladzislau Rezki)
> - Link to v4: https://lore.kernel.org/r/20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in
> 
> Changes in v4:
> - Rename vmalloc_free_pages() to vm_area_free_pages() to align with
>   vm_area_alloc_pages() (Uladzislau Rezki)
> - NULL out freed vm->pages[] entries to prevent stale pointers (Alice Ryhl)
> - Remove redundant if (vm->nr_pages) guard in vfree() (Uladzislau Rezki)
> - Add vrealloc test case to lib/test_vmalloc (new patch 3/3)
> - Link to v3: https://lore.kernel.org/r/20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in
> 
> Changes in v3:
> - Restore the comment.
> - Rebase to the latest mm-new 
> - Link to v2: https://lore.kernel.org/r/20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in
> 
> Changes in v2:
> - Updated the base-commit to mm-new
> - Fix conflicts after rebase
> - Ran `clang-format` on the changes made
> - Use a single `kasan_vrealloc` (Alice Ryhl)
> - Link to v1: https://lore.kernel.org/r/20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in
> 
> ---
> Shivam Kalra (6):
>       mm/vmalloc: extract vm_area_free_pages() helper from vfree()
>       mm/vmalloc: fix vrealloc() grow-in-place check
>       mm/vmalloc: zero newly exposed memory on vrealloc() grow
>       mm/vmalloc: use READ_ONCE() for vmalloc nr_pages status readers
>       mm/vmalloc: free unused pages on vrealloc() shrink
>       lib/test_vmalloc: add vrealloc test case
> 
>  lib/test_vmalloc.c |  62 +++++++++++++++++++++++
>  mm/vmalloc.c       | 143 ++++++++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 175 insertions(+), 30 deletions(-)
> ---
> base-commit: 02b045682c74be16c7d1501563f02b0e92d42cdb
> change-id: 20260302-vmalloc-shrink-04b2fa688a14
> 
> Best regards,
Hi everyone,

While waiting for feedback on v7, I looked into the issues raised by
Sashiko AI and Alice's comment. I plan to send a v8 in some time to
address them, but I would appreciate any additional review on v7
before I spin a new version.

Proposed changes for v8:
1. [Patch 2/6] Rephrase the commit message. As Alice pointed out, this
is a preparatory
   refactor to support shrinking rather than an active bug fix (since
without the shrink
   patch, both size checks currently yield the same value).

2. [Patch 5/6] Strip the KASAN tag from the pointer before calling
[addr_to_node() using
   kasan_reset_tag(p). Sashiko correctly identified that a tagged
pointer will cause the
   modulo division in addr_to_node_id() to return the wrong node index,
leading to the
wrong lock being acquired and breaking synchronization with
 concurrent readers.

(Note: Sashiko also raised concerns about the `memset`, but that is
pre-existing code and I do not intend to modify its behavior in this
patch series).

Please let me know your thoughts or if there's anything else I should
include in v8.

Thanks,
Shivam

