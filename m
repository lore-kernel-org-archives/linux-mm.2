Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C87CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1CAD6B0088; Fri, 19 Jun 2026 04:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CCDC6B008A; Fri, 19 Jun 2026 04:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4156B008C; Fri, 19 Jun 2026 04:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 689926B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:01:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D06BD1C2338
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:01:06 +0000 (UTC)
X-FDA: 84895916532.10.DC8F8D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 100372000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:01:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UhGel73b;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781856065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ftbjs1r49TGSpHSfjI/+zcb2PtQ5xV2RKg9B5mDhpo=;
	b=fXyH+yXqg9WzlTLJcax6Uu3yjlScZaYtL9KfVeq4LuWuKZr5UN1OY+oJqgt3MA4A1HyRhh
	TFir0DLRHxVnQUnaFWUUL4pwNks/boOvdt5Or51exM3VevfGwACc1aZrYUJnH8ZXAq4fMc
	ENY8eCxxnw8QkGXwjuzAw/M6BSjFS5I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UhGel73b;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781856065;
	b=jfrVcW6wBypaR0b2p9WhflKWShaB8FgQdulKqQFD9jmXUIz8sgc2UVvE4+DPFfi6upc4xx
	zSXKABTv7Fpf6HdJurYOLcq9D/wr2f62foRiYVoT3SKTp1oexjS4OiYGoAfqY23uMpkSam
	z+RE+ZP+VcZDUDVttkfwX+tn0AaLDB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 815AE601E1;
	Fri, 19 Jun 2026 08:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E101F000E9;
	Fri, 19 Jun 2026 08:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781856064;
	bh=3ftbjs1r49TGSpHSfjI/+zcb2PtQ5xV2RKg9B5mDhpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UhGel73birqVS59+C/A/qJF4ZvqB42EErURgteqbJNSQRXzEVENe709aQPdpLkuJW
	 z07gPHtgAOJzq6xD3TMihyzzzcbEGjz7diSII+m+3a+yP9fs+0mUNK9gUokGaaCLPG
	 sKBZqfv8NtQVI6vudwTGAvX6nB/pAhLAFe1hhhwXLKHT57Lgu4F5otfyODoNdaaL+1
	 L5xGcCnR0Reo7J0SD0fok0oQZBNellpmARMZSRkxKlYzGAeVQ8qePzTKOlw01MF+zX
	 3KNqHgni83JwQXPw5ATx5MwSrC+gCWrlFSyYDUbWjaIfjqEkXypKHGu+66a+AUz5v2
	 s+O2Gk31XHQ2g==
Message-ID: <3149fcee-eded-49b0-baf4-ab69c27ff063@kernel.org>
Date: Fri, 19 Jun 2026 10:00:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
To: Luiz Capitulino <luizcap@redhat.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
 <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
 <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 100372000B
X-Stat-Signature: y9byztjbh7i9qtpogyzni473cfg5xhi9
X-Rspam-User: 
X-HE-Tag: 1781856064-274244
X-HE-Meta: U2FsdGVkX19MIDqKcA9jf6+DWdcsGjbvxAniToFj5EeLYO1yINbqdwE/p0tLW+k8uJTDB4xmhFoaVjj4jiS3iGLbeBElYGHROlAcM993WSYXpBFfkh6seaE8thhwF1vhwxRfm2K4TMr2FuQ73o6Qj+dvsEqWEW0xIMbAfYH5w0ZYKl63xb+R55SwCUEzpTsoVKQQ9JGWWw4+QiJ5FYQXwPbDBRmTkWllbIOhSr24ENV4mMXNVl6Kb9RFDAAC4OSNoT7yb98HNMbzihuQZnxYU3EabAfPjxzoV12RA2ij17l34S18h/G7w+p5I+/ju+b9wKf2gW3HsYpKaumcJClCGm84JXxia6xmM2b2o4dZJ0CHJBtFPlh3va0z7tg2JpakhhRwUE8peR+eOpCMj/iltaW6cOzo+5higkdXBNsuwTBncWuWBaxdXe+godT5DfcoSXa/K6FWuQ0zqoQ4cxSEheQ0jhkaX+HNje4+9nwlCE/q7ARhM57kenq8RrTia4jKx3hoYFQJxYqP8Mx5XrQbRRCqVo52Gj2NN6m/CB5qwPBdcq29WL7/b7BKwdXbKCwwLIdxBidk+Xwes96bW7wOelyzcBrRLUHGPGDlFJcRi77LrXZKdwRIM+zU1bkwbjWW7ZLxkKngC19kvo3vMqBi9HN+HDVjoGberl51ZRfhc6YrqiF6ey07n+AbUrFGQu93cXR8lFMVzGsTo5TeUIPPz2j9u4NlsovEjHcSTnPJTLvBqe1uQZwsK2JITsciut7YU481bUYI8ESxT7xjwajYDdCwx9Sf2CLaZsO1WEZ803jZv5hZ9LSysaM3cGs7OmTf8LFJGYxZaeL+H4VNQMcNfIcDVEszvKdSDZKlXq8OlN8SwJrOlHjtr2NNbsxULOOpzhOI2uSuDHp3k8FTbEcpW4ODlnH3yQJ1G9rNCT/OhQtw131CPeLFScJ9kFR+Ri3Zeldlw99N3p++0HRdn1p
 a+8IYBo1
 gUWRvPPQCbaCZ2wmw4hFu4EcJjJTtqEAaeOgNHFNV4r/2WltxoT2998SXJ7PRY5ytHoEi0Q7vlt72m9zYA0+n/H0yk842NuxdU8JlP0C1+S7+CwkXzkT6NIbP7Af/sDONRYGPnP04++VRIHMjXMuY9TidlqGUQOVCw/lo3rblMP3SFqosL5Q9jvc4NGGEYnpRdBqGtkIW5OgaJi8PQB7MzjLgjajWvzN/O7I77YtwpW9hq6sTNFV5lHTU++Glv4XPIFl81xAeza+e7oCRhwFKY+iVYfIJcPGvu7LfnC6x8QZ1KgNQP8tct7m6+IUaGVPHosbufrD+LfVG4t/3Ki8hdoaKkfYRK5zneMXe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 04:38, Luiz Capitulino wrote:
> On 2026-06-18 05:04, David Hildenbrand (Arm) wrote:
>> On 6/17/26 17:09, Ketan wrote:
>>> The page_ext iteration API do not validate if the PFN still
>>> belongs to a valid section while advancing the iterator.
>>>
>>> When dynamically adding memory in hotplug path, it can lead
>>> to a NULL pointer dereference during page_ext_lookup at the
>>> boundary of the last valid section.
>>>
>>> [   14.555124][  T846] Call trace:
>>> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
>>> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
>>> [   14.555129][  T846]   +0x11c/0x260
>>> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
>>> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
>>> [   14.571206][  T846]  generic_online_page+0x14/0x24
>>> [   14.597782][  T846]  online_pages+0x178/0x30c
>>> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
>>> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
>>> [   14.597789][  T846]  device_online+0x88/0xb0
>>> [   14.597791][  T846]  online_memory_block+0x30/0x40
>>> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
>>> [   14.597794][  T846]  add_memory_resource+0x280/0x298
>>> [   14.656161][  T846]  add_memory+0x60/0x98
>>
>> So, we do allocate the page_ext in memory_notify(MEM_GOING_ONLINE) -> ...
>> page_ext_callback() -> online_page_ext().
>>
>> Which makes sure that all page_ext is actually allocated (for the full section).
>>
>> So when we later end up in generic_online_page(), the page_ext should be there
>> and the memory section should be valid.
>>
>>
>> How can online_pages(), which onlines memory part of present memory sections,
>> online (free) memory that suddenly does not belong to a present memory section?
>>
>> Something doesn't make sense here.
> 
> Ketan, would you please share the full OOPs message and maybe tell us
> how you reproduce this issue?

Ah, I think I figured it out.

for_each_page_ext() does a "__page_ext = page_ext_iter_next(&__iter)" and the end.

That is the real problem and should be spelled out in the patch description.

Likely we should just handle that in the iterator, looking up page-ext for something
that doesn't exist is weird.


From ce41607a4e4c1d872b6d3050da2e24d41a30d822 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 19 Jun 2026 09:58:46 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/page_ext.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 61e876e255e8..468c074582e1 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -112,6 +112,7 @@ static inline struct page_ext *page_ext_next(struct page_ext *curr)
 
 struct page_ext_iter {
 	unsigned long index;
+	unsigned long pgcount;
 	unsigned long start_pfn;
 	struct page_ext *page_ext;
 };
@@ -120,15 +121,19 @@ struct page_ext_iter {
  * page_ext_iter_begin() - Prepare for iterating through page extensions.
  * @iter: page extension iterator.
  * @pfn: PFN of the page we're interested in.
+ * @pgcount: number of page_ext entries to iterate
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no page_ext exists for this page.
  */
 static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
-						unsigned long pfn)
+		unsigned long pfn, unsigned long pgcount)
 {
+	VM_WARN_ON_ONCE(!pgcount);
+
 	iter->index = 0;
+	iter->pgcount = pgcount;
 	iter->start_pfn = pfn;
 	iter->page_ext = page_ext_lookup(pfn);
 
@@ -149,8 +154,9 @@ static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
 
 	if (WARN_ON_ONCE(!iter->page_ext))
 		return NULL;
+	if (++iter->index >= iter->pgcount)
+		return NULL;
 
-	iter->index++;
 	pfn = iter->start_pfn + iter->index;
 
 	if (page_ext_iter_next_fast_possible(pfn))
@@ -183,9 +189,9 @@ static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *ite
  * IMPORTANT: must be called with RCU read lock taken.
  */
 #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
-	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
-		__page_ext && __iter.index < __pgcount;          \
-		__page_ext = page_ext_iter_next(&__iter))
+	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount);\
+	     __page_ext; \
+	     __page_ext = page_ext_iter_next(&__iter))
 
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;
-- 
2.43.0


-- 
Cheers,

David

