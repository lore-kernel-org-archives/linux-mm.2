Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E5F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bMwTvmpl
Received: by kanga.kvack.org (Postfix)
	id 194726B0643; Tue, 27 Oct 2026 05:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C106B0645; Tue, 27 Oct 2026 05:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BC26B0646; Tue, 27 Oct 2026 05:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEEDA6B0643
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:01:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DA4412097B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:01:59 +0000 (UTC)
X-FDA: 85367813958.12.369C747
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 89631180008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:01:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMwTvmpl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HfAJvmr7Py4uAnd/ZvUO5cNS3CA+7rdNBTcaC+zq2g=;
	b=nc1W9p4YlycOr7e1rr9+uV7L6oCzQKtLir26yg0SIOnfgLf+EStZAo6UZAHc/YDcTj10Gg
	x2Ws+oQPzVsSYrmbKlTTy5DjRcjZA87cVsxurrEiEMOPpYMJsmZrXxEq3sQdcuwwUrr4Fm
	Nsg2kJBLaWpXjLzISGi9BaLIwguI4os=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMwTvmpl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091717;
	b=wehmzrlgZiEL3kJ/I4jfc46Las9xWE7cMkSHiTxajuDCXLoVVGPhFVuslay4EV9rq1ky9Y
	zzDnG8pmxgBR5O0X0E1VvrZRjlYbRd6bkkX82+azZFw1Naq7b5ksPEHjZ/JGuSBCCZbWLM
	6TUrq8oBV3w6NCLmyuvRB13Y3MIK+78=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF50B408AD;
	Tue, 27 Oct 2026 09:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A377C1F01825;
	Tue, 27 Oct 2026 09:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793091716;
	bh=5HfAJvmr7Py4uAnd/ZvUO5cNS3CA+7rdNBTcaC+zq2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bMwTvmpl2a3J4HHYmrBE9mt3NWyKTeD3ORLh0ZRiqAeyZcmXKA+47y3CsPp6CRHWt
	 PLhRq3adt2ViR2khWGG5GIfhhxRV3klG739jeG1pjp4CvJNkNV6nChy7vbMnbPQHmP
	 Wogu01k5BoiDB8pqVuvlk3z/Bh2vvuaBDxhWUqR6kY1wpATWson4KGCa2TkiHipc3F
	 zq77uK2T6se4xzGUbtXdL12Z0v7H5+cIAwBv9PFCl/+H+lNBBLf9ZqzjT0/dqRbc7W
	 rraJ7QK+GTgr+FEN2MllkZW0jw0Vr+JlmOahRfiuXhRTJcetNYdOfKEf6L/WpizemW
	 URqTxJVflOI6w==
Message-ID: <9620707e-59f3-4b91-87af-2b8e12fed260@kernel.org>
Date: Tue, 27 Oct 2026 10:01:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix deferred split list corruption on
 partial unmap
To: mt4022@columbia.edu, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
References: <20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89631180008
X-Stat-Signature: kyd4mn7tub6egunf7931pumqf51ang4z
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793091717-642497
X-HE-Meta: U2FsdGVkX1+8QEiAYySsmnivlRvNX9wmdT0hDCebr7hNtQjEw9aO/u3hytyZe2DiQ7KOBqvUfTpmrP1BrnpXVG1H3JhL09oIOVH1/D+wFoi9eTP8MvXSpw25jz072vucOzpQh1ijTJHHlPXvtsx7nGmGt3MBXOT02Lw5xmFbghlz/PiWQ22QSXrU8xN+bLiRUTziQ75dpRb0VY0RRx8wAaHmFbSa9XhMESyaeCPmxFd48L6PGRYnv6qx/fxf5Eer+jl/lSHwZOBGzCU8tpd983SUK9zOvoaeuzqScvU24NU2gBkyTDee/uwgVpGbCd1yDSYa1PUkNjWpqyH0QerDQOtwqOARhZjBwsIF6176eZWDgDo2T1CvFrNd5jpDh/sjfZ59Bo7ob4oFbuDDXUzMU7fpKZEqngJCDvVGZH88AWk63AmfB87/ZzLRlWbDK0P9iN8NlF9SP5Bh7Vza4fWQJGp+ai/mPxF9fz8MGOnJzMOO/IEXhVXLUqDcbPIcdsocIhb8dCMYOrFEOKyATu3XuNr9sv5MoxxOnnX/8UNpaL79hkhaniFWVfq0uxOzNCF2AsR7Iu5DRjkZxia9Gjl6mkxDxAKupTNEzUeavnZXIwpgObP4vJ+bIbvUmd4myTLCGKUDKqxGrQlo8QmffAC/j6Zd8M9tK2QqOxPrPmbDcCRMT4BIS7i1k5jvvTBaBaImU3TMkAxMXiLp4OMxQtHS1avQzYaY6RuWTwZe937zWX87d5GUU5FfkL1UWPDVYPMs4Z3+gyGkyYFxXCl02+4JehEM3XW6FMAsjPJzkjS1Get2YKr9YTyxtdGHxj2HKIxMggr/rCAkphKBLpGTK5cHhpNk0qxeV/H+p/kUH4v8FA6kuWdY/KTz+nr368kqHhyCOW6JjHjZVEyDb1C0EDalan9A1Dw93lEddFVF4/2hfabn0Hn4yq4a0WGCiHQKN0gxtx4QvcFNhzmvB40/xPT
 KohVxcwX
 xgxyU8zX+kv8yVWWLZS4Jx5m3jfg+E8DEtoDYk6o4AoqaVzTZbRkgahHUrL34s36Aj32aWdAN+r5HsXm5Hxno0k+NcMQWM+OdfS78KWWBPPCsM7pQGAtnKMtg78xFMjB5W8OP3AYTz3M80Tq86Atm09gx2ZLD+rme01mGFTwNcKzFmezg4m7y+FAj6eVu6b/cmFBmykmNBtY/YoyI3Xw48dbi00XxfRMZTS1K/0B69bT4Up0v0t2UnAYRsRhrFYKUO6CVCsrsBV53dsVBFu19VU1qzfjx0sDLsuaJZ04O+idQzLMBZSdov4PWn0qjT+a7kWwBFTiFTjVTX5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 01:22, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> When a THP is partially unmapped while the deferred split shrinker is
> scanning it, the deferred split list can end up corrupted.  With
> CONFIG_DEBUG_LIST, freeing the folio later reports:
> 
>   [  523.871401] list_del corruption. prev->next should be ffd40000005e0090, but was ffd4000000500090. (prev=ffd40000005e0090)
>   [  523.871412] WARNING: lib/list_debug.c:62 at __list_del_entry_valid_or_report+0x177/0x220, CPU#0: thpsplit/63
>   ...
>   [  523.900715] Call Trace:
>   [  523.901753]  __list_lru_del+0x5f/0x220
>   [  523.902588]  __folio_unqueue_deferred_split+0x238/0x520
>   ...
> 
> Without CONFIG_DEBUG_LIST, the list is left pointing at the folio
> after it has been freed.
> 
> Since commit fafaeceb89a5 ("mm: switch deferred split shrinker to
> list_lru"), deferred_split_scan() moves the folios it scans onto a
> private list under the list_lru lock, drops the lock, and then removes
> each folio from that list with list_del_init(), which sets
> entry->next = entry and then entry->prev = entry.  Another task may
> in the meantime partially unmap the same folio and call
> deferred_split_folio(), which queues it only if list_empty() reports
> it as not queued, and list_empty() reads only entry->next.  If that
> happens between the two stores, the folio is queued again, and the
> store to entry->prev that follows breaks the new link:
> 
>   Task A (shrinker)                     Task B (partial unmap)
>   -----------------                     ----------------------
>   list_del_init(entry)
>     entry->next = entry
>                                         deferred_split_folio()
>                                           list_empty(entry) is true
>                                           list_add_tail(entry)
>     entry->prev = entry
>     /* overwrites the prev link that
>        list_add_tail() just set */
> 
> Use list_del_init_careful() instead.  It sets entry->prev first and
> then entry->next with smp_store_release(), so once list_empty() sees
> the entry as empty, the shrinker has finished writing to it.
> 
> The reproducer repeatedly faults in THPs and partially unmaps them
> while the deferred split shrinker, run through
> /proc/sys/vm/drop_caches on the same CPU, is scanning them.  This bug
> was found and replayed using a deterministic hypervisor currently
> under development, but the non-deterministic C reproducer can
> typically trigger it in the 10-500s time range.  With the fix, nothing
> is triggered after 1800 seconds.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>


Are we now sending alterantive fixes for anything already posted? :)

https://lore.kernel.org/r/20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org

If there is a better way to handle it reply to fixes already posted.

-- 
Cheers,

David

