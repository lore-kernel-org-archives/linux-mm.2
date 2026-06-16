Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345B4CD98E6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2C96B00B7; Tue, 16 Jun 2026 16:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53906B00B8; Tue, 16 Jun 2026 16:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90F36B00B9; Tue, 16 Jun 2026 16:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A38036B00B7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:52:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C59812023F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:52:51 +0000 (UTC)
X-FDA: 84886974942.06.63AB2AC
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id E35A01C000D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:52:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ry8HaRcc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfwGTdd6S5lmSlSd7PKEAPV3soyypH9jTQJVVAS/V4Y=;
	b=kj+tP0LCIKgnrTtikx3r7dXhaOAlEnTBn/MjNkxn6R3wYE4/dz1DHFRw1RtDyykGioyG/J
	HngKoLEjPD9BBponVDAh0C2k5PbnFdQKevWsHCYEgX6qiiEyQso9NkETG6EpRL8Wg+b6lv
	Z1kYQk/ScBPGPm0k5LNHpbXhTB99x2k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ry8HaRcc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643169;
	b=Kf2M3AeybiAj6dmxrj0lbaKBZ0vX496HQbQVTO3y5jhoQgKke5XUNllGlWlhDtDx3CaMF9
	ORp3Du+SSnZl8+uEw1hnnRCmqOOx5y5Aikl79vEOlb/m5KiiPblt0LYFfbn67sN4ooRdlp
	aYhvpYXbjpkfPtQIhuChc+uFNXcwt7A=
Message-ID: <73cf2b7c-2423-4b96-b98b-a1946e9f952a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781640024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfwGTdd6S5lmSlSd7PKEAPV3soyypH9jTQJVVAS/V4Y=;
	b=Ry8HaRccx8uCSYv92/cGzHTZFdmCuqHJqRUsfN+GZB+yQT4/7xQ9rMyh1nSPRgF3XJaHX9
	8vpd1K6ox2MpP8dPRBTmuzez8iEWeFYLlfqRpI02iKIhM8ys8VPB+WjnfUckHxbbNk0R1Q
	VekE6tkVbBEl+du88qFRzcl54hOr74Y=
Date: Tue, 16 Jun 2026 13:00:13 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
To: Frank van der Linden <fvdl@google.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, usama.arif@linux.dev, kirill@shutemov.name,
 willy@infradead.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
 <CAPTztWYuYA3qBTQrnRVH2W5yxyBZt4OM7Ws3vUxmRGNriOeVEQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <CAPTztWYuYA3qBTQrnRVH2W5yxyBZt4OM7Ws3vUxmRGNriOeVEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E35A01C000D
X-Rspam-User: 
X-Stat-Signature: r9ntrpmacks8oikd9f1nkrxrygh4sh95
X-Rspamd-Server: rspam09
X-HE-Tag: 1781643168-388345
X-HE-Meta: U2FsdGVkX1/BN8321v5g5kBawcLA/AoIB6aaArM7faD6ANo1rJUomkKliS0diSUiRXI97y3jULsc+bNXWXoOleliVmPRdRvZozppHGbMlF70CefS3RiYfcm2Wzlh9AcxVZT+APBfI/bUcWzY4KwCO7KSWrP8AnX95kcAYYSE0QidsbqzDIi99Jy+cWZHy1IXusF+OooD70AR3vOy0om3chdQ+0MP2FjEMrZlyhZmRQbBASvrnEj57wPc4nPxoaMb3XW8Q9Tz8rYBsgqX2BClDSddZ5humFtBLkcEx0bTp0MIMGidH1YnVRj21FH8mqFSTPmkmBAJo4/Hbr4hVAZnO+Ra5LOI9nNgmfdBx0sBPw8Zn8aEfsNYrX3OivG3aSviJ7NXJA70iKhEJsAwJA0ASkQ2YGl8RzB7OhhzD5zfw2IY8m/eaAAH27/6flUSuNG2LWDtqOepSz4oXR6S2K5kFcw/dXPiosUWxRiY7rYVt5VhF0XSYUFd76AMlS4I7Vbn4Par5DqvSeN/L2G51pBgRjFppECEuM88jVVaL9O9daZGPY8W57BSCOx9TcipNXjTbgKWinq23OXTifIZ769ZGOrNgA/Yc+rCcSUFoEdycy6KDOrJCmcsgitKahKeqiaUpmXM8xQupSsoBAScys2FMi2YoFDS0l/9GIiSTi5QxAGD1/whDyNpOEqBRIcou00HWJA5C//r6bV49EjCddz5yUaLdItG4mSDLxS9Mf0847vO25kkyfHjDWJrIjNYk0dEga4D6BAxXMT13WrAyOsx8CSnaDHJEorSwV3s6TzzuO6Jge9oiw/BQhFg1Run6wJp9iCgNDQuopNlD4ulCC/gR4bmWuy3y4GxTmBciVI3y1KvWUihd8kyex2zjg/EFqkC4XhAPDZ5cQgncw4Z/YB1Wu8Jize4Rv5WqGUgqX8B2/W5FCVqtIixiQ2vuQ2k3WtITmbwf4gqzORhOSCT0FJ
 534aGS6y
 R42riVqQ4SGAcKydUkpOTFVQ+/VjS4ott3SkNIbPXs23bBCU3ghkGZ4hZMm+t2kaCMofSJaVcGiR4eD3oOPI6KxaNy8m+R4mnGaJs/Q4fZ2nz+7kS+0U2CA6Qg8UhY0/OIhrY8D7fJhnf00JfMeRGwuCXYO+sE1xD7OQDdnGdy+YxWf/x/eDppItLDxR74insqn3gZtIqH+eFxnVMqTQfsIN/FtVtyS1gZke0nSv7u7b01ETbZeGxuzvR34unxtO22vpGRTkPcOQfjz8IrIri0TMjT34bfwV9nExGX6L6REYV9/Sgbr4cp9aoMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 10:09 AM, Frank van der Linden wrote:
> On Mon, May 18, 2026 at 6:25 PM JP Kobryn (Meta) <jp.kobryn@linux.dev> wrote:
>>
>> We're seeing a pattern in production where 2MB THP order-9 allocations are
>> failing due to fragmentation and triggering reclaim on systems with plenty
>> of free memory. Over time, the success rate of these THP allocations do not
>> increase at all.
>>
>> Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on compaction_suitable()
>> indicated the given zone had sufficient free pages for order-9 allocations,
>> yet they were going unused. Drilling down into the zone and inspecting
>> /proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
>> zone's HighAtomic bucket (while zero were present in Movable). THP is
>> unable to draw blocks from HighAtomic since that bucket is not in the
>> fallback list.
>>
>> The heuristic for reserving pageblocks in HighAtomic is that any atomic
>> allocation greater than order-0 will result in the full pageblock being
>> captured. This means that an order-1 atomic allocation will over-reserve by
>> 256x, a full 512 pageblock.
>>
>> Gate the reservation on order. Skip for allocations at or below
>> PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
>> reserving entire pageblocks, and significantly helps when THP is in use on
>> a fragmented but otherwise healthy system.
>>
>> Testing was performed using an A/B instagram workload receiving prod
>> traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
>> several gains:
>>
>> Unpatched
>> HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
>>   ...all order-9 blocks in HighAtomic
>> THP success rate: 1-6%
>> Compaction success rate: 0-2%
>> pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
>> Atomic order-4+ allocations: 0
>>
>> Patched
>> HighAtomic pageblocks per host: 1
>> THP success rate: 44-78%
>> Compaction success rate: 24-47%
>> pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
>> Atomic order-4+ allocations: 0
>>
>> Note that for this workload all atomic allocations were order 0-3
>> originating from the network stack, btrfs, and scheduler.
>>
>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> 
> Was this issue reproduced with a tree that does not have your patch,
> but includes b480cbb07102 ("mm/page_alloc: don't increase highatomic
> reserve after pcp alloc") ? The symptoms here seem the same.
> 

No it was not, but thanks for sharing this. I could see this patch
helping a situation like this. See this patch [0] for an update on the
buddy side.

[0] https://lore.kernel.org/all/20260616191420.52556-1-jp.kobryn@linux.dev/


