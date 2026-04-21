Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ADE8F327C9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCCA6B008A; Tue, 21 Apr 2026 05:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294436B008C; Tue, 21 Apr 2026 05:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA236B0092; Tue, 21 Apr 2026 05:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3D36B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:02:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 473441A0C41
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:02:52 +0000 (UTC)
X-FDA: 84681972984.29.81DA226
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1C33A180005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:02:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AR0qSbNi;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776762170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1tUMNKsUka20XG67YhLFUj+hBxuaCOCgy+TNZlHY/s=;
	b=MNxHdfvTlMFEBkpcXV2kdd9B0JKFvrGHIM18jN936Ibh/hZ5fWJpVMEOfyQ3AhsMf5vQTl
	erX/UZLhGOBh+PkZsr8+5G5i/agSJ1s+b4tBxocPrtlSyAwoMzJ6+aGzceOp7S8LSxPj2E
	e412q7662Yg8OW311UXZ0hyHot1CLy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776762170; a=rsa-sha256;
	cv=none;
	b=3ben4H5Cg5GEBzbb2XQSerzwG92daf0mv4LcXEow3ooDobuE773v87kSyCLlIuno5tYWZU
	VnPyZSzlkNdyXoM8o/Hsg/NRrrh73xYwE5LvjvEp5RqdGKJTLhCOrFm9PA2ibFP1rj0r2D
	eG8QjbbfdhleIXgj+HTgrtW0ULWMz9I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AR0qSbNi;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d7146cd1cso268729f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776762168; x=1777366968; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D1tUMNKsUka20XG67YhLFUj+hBxuaCOCgy+TNZlHY/s=;
        b=AR0qSbNizmtgmL6apM3NNXJBhIc3NKlyKcVaeuOk4SGFQM7u1udBSs5OXbs1s448Uh
         EEvp7xvAWHCZhvRIz9i0dXL9/moXRjfKIULF14XkUwy//BInZnkIe9yV+7WJGUFaP0Ml
         /b5Lrxk2Aj68nFoUsLlBySQJqSYltrkz0A6eGvUgUCG8qYggd+0gkEHR6gBTmjlXPlVT
         iUFAf2X3uRfw7dh8rXPjNYKdSXjATX5LH0pTXqaY3jBr9owoXzWxVeWt0Hsv/pq9rc8c
         Hd5XMzrIICexjL1hZ8FInFGyWy9J50XIOxNU6tudEDkPQnbLHDt+T3wd+Q3DK9AbY/dq
         70ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776762168; x=1777366968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1tUMNKsUka20XG67YhLFUj+hBxuaCOCgy+TNZlHY/s=;
        b=C6uigJOLQ8KjHShndjzlwBKxQsdRC9LfmGtrOa5TjwcL5nfMfSAoWWObY9OrGn1Qdk
         cogFkM0xUO0szvyEi8pSxSmhH66dl4rvOK35BCUp//OAweQ1eYG2BVzv/oAT7tkxhGMU
         g1CIOxc1qMsS3+9pmVWuzl3Pi4HaHABoq+yMM38/wn97ls7L/fCWStBjmPFBCYmGCSHy
         pXqPOjw9Q9B2jMCIN3rE0YZLVWd0fnp1IqnELLvgU7Q6/be/PAu8aHJMm0q9K2o6Zo2x
         y5SFxZOggq8lIISspQ4Zvow23jtzpurS9HKG3AQTvLx2WCpwf5svPyW0j/I/ONUijSMv
         as0w==
X-Forwarded-Encrypted: i=1; AFNElJ+rPN/IS6ArCoPbw4a2Bl5MRFVzHP6XN3VCqS4YeSVZdhThzPbxjyESfzit+h2ovI/dABjwsmWW2Q==@kvack.org
X-Gm-Message-State: AOJu0YwZASBcSjtHrGyprVXj1DZM3QA6itU9AwU/v5HwD6JZ8eIw/2SS
	s/nZw3ufw/YdyZBVH2J2tgsKFGIhmBkJgu9NzLa9gZCIZyQpg2suDWbt7cEztUsnALo=
X-Gm-Gg: AeBDietKNR2iV27bZU+mbluipTO33RPaPwe//HRDgAb3erwyKiyZ4HzzIJ2V37DhKNd
	vtmr+DAYcV1CdhZFjhYJeJM8h/k80+giylyfh5I0Mjyu0pnFpDuAvPOaidxGJhNP53g3MsqhCtl
	hp2Oehvj3+/995Qn48HdfUy2SzuVLYXvX56j8K0v7XsjfA6ESDeWjzUjyIX5d/MKvp6j+HVw1VH
	J22Kpv3wyj+92TZP/ynigkpDFFZVV39WYbfsPeDsq2CqAMLR+3ehaTbTnWPVrCV+MP7QvXcWmGk
	J0ba+6veFC8uMRbtyeNdjtBQg9UgRA8vDGTrsF0uoe0vSGKy3a89pmWfYncdUNUgHwEqYADQe+4
	tDbhSTAREV1bpS8H/S0ovIohio2J9fXycFWf2vioLwNaxkExd7AQVGLkkFSip0AlZkL4FIzdMAi
	/B5nqo3nxprue4ucXNlemSkF8dKXypGw9NgflhdXFJy8Ah4p3UcX7NlgDix0ZQhPBnHn20
X-Received: by 2002:a05:600c:4746:b0:488:ac4b:59d1 with SMTP id 5b1f17b1804b1-488fb7ab49cmr115940905e9.8.1776762168051;
        Tue, 21 Apr 2026 02:02:48 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891c08faffsm269654935e9.1.2026.04.21.02.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 02:02:47 -0700 (PDT)
Message-ID: <1f50ce04-20e6-46a0-9d8a-00a5f7a74967@suse.com>
Date: Tue, 21 Apr 2026 11:02:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Content-Language: en-US
To: Dave Chinner <dgc@kernel.org>, Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, alisaidi@amazon.com, blakgeof@amazon.com,
 abuehaze@amazon.de, dipietro.salvatore@gmail.com, willy@infradead.org,
 stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Ritesh Harjani (IBM)"
 <ritesh.list@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20260403193535.9970-1-dipiets@amazon.it>
 <20260403193535.9970-2-dipiets@amazon.it> <adLlrSZ5oRAa_Hfd@dread>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <adLlrSZ5oRAa_Hfd@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1C33A180005
X-Rspamd-Server: rspam07
X-Stat-Signature: zckcaf5ixkzp5gpktpkahgpa3x89ha4d
X-Rspam-User: 
X-HE-Tag: 1776762169-170653
X-HE-Meta: U2FsdGVkX18KsKIbj0zyyBi57GRCW08TPUgvgjztkNt2c0toiKJq+dyFY3OsDYYmKoCNuZyi1bgl+uUBqLoQ4I8cfByR6UW0Y1Rovzc/L2mGmJKTgkMfXXno25BI1baOx+NqOMtn+IABE7B8lhhMjiaqHsoeQeF6ginix0sWekLTwuVTsq5esxDePI+OTrp1j89cJQ+Y3UYIZY+Y+v+rT00tsHJdJhUiCYkDkd7VmdksWt6NEKSjx6OxpRvWKxI2l3CDdRtuj9D6Lf5Du0FSfqHlv9uQnA7bckXWjZy9RvyEeyqOz0gpJh2YYW12q1CAmhBWNnTqZjsi5Y8pRKPnzm5SMIjNFqUkXi7EFjpMywVG8LBkruB/hgb1nbiQa1cRw4AXtGi8ihrw4JGfWCqP7zW076HrGFpWEoYzeUqFxSUgzUw93R7KyxBFgTFK3Mi8nmKkBM4VaPXUhyN+YZ3dV7vj8F7iRw/4OKLoiHxDXe5SFXG+JszTnCR1CRBYHzKLtOG5QsNSvweWtaicuCg+Zg0hCDe6FJ+7J10L5l04xNvrTSzqEXe+LrkVT/9RlU2jI3nLrj66f8lJqprP3g5f5L5P78IOMqgCDGSAkbdhiNDDkQBbNC/u1UnVXSLrnKqT+goRYJppQYWME1NuemmhA2wOpQFPnsTRP9I7noyLJ15wscZvLE22dk+XvnR1yic9fQ5UTglMWDpvyVSM+8UffRl1EZVjCfwH/6RZrBqAhd/u9eLMwLvUllztFTyFgnqmmOgro6cUZYxV8/qoWDXZkpwysYTfdayVEkvA0pyyIwaGQwOuj/mBqhvb4V7TCQxcZ8E1LbxbZljDCW9W8xT1aUySmomVj18mhUc2//Wu+9EVKMa0UBG1vU/VyApKfC+5h1JW9K+R5ni0w3Vz32rcxP24MIy0ZyCl9ZEnb9uvJ4rpfF3qZyBbTUcb7jUpn38r2TUbCStQi6sdxPYM8XN
 MHePSxxz
 1UB7PixwqSS7zIOXN/WnezmrdjCIC8pNHInURdo22GR/BZPcu47AhxlKgwcJPiVprIUvcy+l6bt6zaRpr9LBJi7oGq1jCOj+ADnaVyAmyhtkajvph+iQIb+R5amP8rz/8ts7vJo2bh1tNuDq0ZOtGbPuL9DF2eP53uBDbWrhGMITEEukmTS9wMg4Su6BfwXTdhYNGrx+NFsIW67zpLo/D5sh5ToODD9I6zjtdgTuqk8P+xSRPgK0rDBahCAN3B4uNT1JUpSAsD70IXFFklRjrVXqmtUdB70kyP9cA51XG282lwvK1KcmFUJcrv1C9Px4gTQFcO8UNoAPE/s5AQ21B+gkzwkn1KTCeiad0xjXE7XCrEp1JzVvwdTNzSBfBwrKwNueqXyjjU8fJ+c+ed8gFy6D0AiHatEPQqgYBqzI4eA6FSZ0uJyD881NMrGw14FrA5E+OBk3kg7fN3DhEDU+gI+hopzMtYTYzgBEXAR10VCtSnA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/6/26 00:43, Dave Chinner wrote:
> On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the buffered write
>> path. When memory is fragmented, each failed allocation triggers
>> compaction and drain_all_pages() via __alloc_pages_slowpath(),
>> causing a 0.75x throughput drop on pgbench (simple-update) with 
>> 1024 clients on a 96-vCPU arm64 system.
>> 
>> Strip __GFP_DIRECT_RECLAIM from folio allocations in
>> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
>> making them purely opportunistic.
>> 
>> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>

BTW, backporting perf regressions fixes to 6.6, when they are only reported
at the time 7.0 is released, might be too risky. There will likely be a
different workload that will regress as a result, no matter what we do.

>> ---
>>  fs/iomap/buffered-io.c | 15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 92a831cf4bf1..cb843d54b4d9 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -715,6 +715,7 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
>>  struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
>>  {
>>  	fgf_t fgp = FGP_WRITEBEGIN | FGP_NOFS;
>> +	gfp_t gfp;
>>  
>>  	if (iter->flags & IOMAP_NOWAIT)
>>  		fgp |= FGP_NOWAIT;
>> @@ -722,8 +723,20 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
>>  		fgp |= FGP_DONTCACHE;
>>  	fgp |= fgf_set_order(len);
>>  
>> +	gfp = mapping_gfp_mask(iter->inode->i_mapping);
>> +
>> +	/*
>> +	 * If the folio order hint exceeds PAGE_ALLOC_COSTLY_ORDER,
>> +	 * strip __GFP_DIRECT_RECLAIM to make the allocation purely
>> +	 * opportunistic.  This avoids compaction + drain_all_pages()
>> +	 * in __alloc_pages_slowpath() that devastate throughput
>> +	 * on large systems during buffered writes.
>> +	 */
>> +	if (FGF_GET_ORDER(fgp) > PAGE_ALLOC_COSTLY_ORDER)
>> +		gfp &= ~__GFP_DIRECT_RECLAIM;
> 
> Adding these "gfp &= ~__GFP_DIRECT_RECLAIM" hacks everywhere
> we need to do high order folio allocation is getting out of hand.
> 
> Compaction improves long term system performance, so we don't really
> just want to turn it off whenever we have demand for high order
> folios.
> 
> We should be doing is getting rid of compaction out of the direct
> reclaim path - it is -clearly- way too costly for hot paths that use
> large allocations, especially those with fallbacks to smaller
> allocations or vmalloc.
> 
> Instead, memory reclaim should kick background compaction and let it
> do the work. If the allocation path really, really needs high order
> allocation to succeed, then it can direct the allocation to retry
> until it succeeds and the allocator itself can wait for background
> compaction to make progress.
> 
> For code that has fallbacks to smaller allocations, then there is no
> need to wait for compaction - we can attempt fast smaller allocations
> and continue that way until an allocation succeeds....

So, should we do a LSF/MM session?

But I think in any case, the page allocator needs to know which allocations
do have the fallback. __GFP_NORETRY exists for this. Here it wasn't tried at
all, in v2 [1] it was, but not alone. I'd start from __GFP_NORETRY alone,
and then we can look at tweaking what it does if it's currently insufficient.

We could have a helper to encapsulate this "turn this allocation to a
lightweight fallbackable one", which would add __GFP_NORETRY. It probably
already exists somewhere but not gfp.h. But I'm not sure we can simply
change GFP_KERNEL to start failing more for non-costly orders. We've
discussed that a lot in the past :)

[1] https://lore.kernel.org/all/20260420161404.642-1-dipiets@amazon.it/

> -Dave.


