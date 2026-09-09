Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A71C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE486B0098; Wed,  9 Sep 2026 08:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59BBF6B0099; Wed,  9 Sep 2026 08:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB976B009B; Wed,  9 Sep 2026 08:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 227366B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:49:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D4FA1C08A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:49:06 +0000 (UTC)
X-FDA: 85194203892.15.8092039
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B857040009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:49:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihpsg7zT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788958144;
	b=jrYtJn72aQkAYBoyMYXrl54R8S3cqEuP0jQ7aW3oNDlqNwLWSlKW9Trv672X57AdF41oCG
	bVtzicEai2Cl6+WUtBSnJJoCTiIdvT7qNDMdbrhjgjxkO7yG1JZeIV13F06rm/R5gCxRLV
	TJHBLMhf8bsg27rFcnRNqnk7UB94cmM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihpsg7zT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788958144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeqpL36l3dlEIn9tPEeks2LG3oiHF6m9Q3Dm+vsjlY0=;
	b=bsGpxKrf9STR/vwCOpbEcyvLQ6PJEE8ehwj5OGDJRoy7ZSZhFn2YXVUgYMKQbZSQkF79Lg
	cIwOVjNpcOjP3jWs1a8vagWWNkrRJ7/5RCfWmzLvsO0/PxlOs/QEX5b7aU12bKSMap6vAt
	XG/QQBcz6qT2PiqouuVx0HBwlVZ3YLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EE1060211;
	Wed,  9 Sep 2026 12:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA2C1F00A3A;
	Wed,  9 Sep 2026 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788958143;
	bh=UeqpL36l3dlEIn9tPEeks2LG3oiHF6m9Q3Dm+vsjlY0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ihpsg7zTtPBvi4+Os8u/1ED3tUrdC9elm20t4ZSzvBE9Bkx4e6b7G1ij7jXXses4N
	 2P5PWnIJ7hACkVVCEhrCtdfGv1nIq8YAOhgwcd+wgfkpib0lD1YcLByZ7rgA5qOppM
	 70MsqMVlNj4SfK5N/oZQ0WexzasmdicY9pWcO5mU31Q5E6d7+WH/OMoMbKv56uhqfr
	 oShcWJy2lXM7w/ywj0JU41Hr8OoM4FxpTgq7iiZEWvb4eNwcvsUgLkBwQ27HL/INuX
	 2YSSUzuIbpCilwu21fzlQsl/3MYNNg7Lzv0aymQKMIqSljSl+P2XyhINnen+7hbBrJ
	 TYkY3cgk4OjIg==
Message-ID: <83a8743b-9cbb-42a5-9ff5-718297916a76@kernel.org>
Date: Wed, 9 Sep 2026 14:48:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: Tal Zussman <tz2294@columbia.edu>
Cc: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <178889163877.1334491.3646957026033534678.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178889163877.1334491.3646957026033534678.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B857040009
X-Stat-Signature: bxaxc45orgb39t6x8nahftc81k5f85yx
X-HE-Tag: 1788958144-788488
X-HE-Meta: U2FsdGVkX19VJQ3AqUXaL7U00W1awTAbKCiqOxkGVZ3HkQM7rBkXar4ixoriiT8fuzLzcPEHcFeM3Ycq04I+t69AaKsQkBzgEAvcUtDUJDJr63twc+JFcuWaCmS45KPJxabfzaa8M48BdRg/fuZnXNItvwlnypXpb5j1mKldAK2RMu6b/anlDZXJr2TcWaX86roLK8K4s7/szJ47Ptm5LjDJn0NgCtbZCjF8atYMDsqbPVfqx2PA8Jqlm18d4hbq+n5WpqSlpEF/jdmXNcHciuqa9i5nqMLc5uAP6IJ+Ek4BsR6I5MVESyd+xhOggY7epv0ioLg7S0F0LOIlogTZBUtoTHx/CmFxswth7euVxMOr8ZyFaLsikw6EODxCeYSX9v79ia5fwtJlRstXC+sKGI4jeLzMu8S/F2QyFvDkTjdL0M4p4kNmdrmpTl06DY8Nt7C4dIpdLJikqo+EE3tRb/fhgtZtejJumsAXbLfGmliuQiz/TW+QblRkAqmoPenpf4GP5zIseMwSHOq5sTm40Mq2Gt/PJKkmDx4nBlmQT4ZhPREqZp7eKwcpZas58LV9aLAO+DrzN2TgXfOaaDjlfr6aVvFsBiG2Pubw5TMH5OabGK7TtzlH1JMsPOpMfJecI7nwAUMj05ik/BkeQ1ExAh5ni2Ch6l4t8bV2i8hnRmGo107HAtLXOaNJtvyTjxkXXqZJwe1KvyWd8QaXyVEa0vsqRPr6CmfkwfjnG71gdzmln2SacUOqCjK/bFBqUSWbZd3af7XS131LV5RG9Rg0inxysxgFZf3o9vZfH7uSE1dLcfCeRb7MCY+qJlLiTUF3m5+C/YheNL6gE+ZsN7YCmUJbhS9wMPKe7KWxN7vC0TX+jZgf9J03jM4zAj5cQYyKe681DE616uODDUAfgL9NgJLcB9ka29owemc882WSUmSInyiJjDRHcknoAVnkvFZqsgBSHTSwnLIpnPLa9qR
 qFE0Z+yi
 qmKOsEEukVt+L7zIAwcnbtXqke7K3wbrJf77wfbCGrTV4sJJl+NAsVRuUmD+UbAeJrbmSUnHq8tW1S40CMml9J+MXEEOZbjbBM21BnMdNlltJwgv61G3P8965WGwTS78EkruF8OgsZRmOzEizVq1Ubs9SVot0uxAlCxCmnEtYJoIx4ATH74pcb2f0HbCPnPRFmnWHVXAjOw8U9rZkABdH6QpWL5UI8s9NEZiPHHYXU2eLQFkVxQAYzrua3bhyFdr46kqTTxcUOOBSCSdy/wIEHEO+E/hEXACY0yFQ2ZRA593wl8Uhh1jR5VVwKMf2MFiq0962GKgTzrybCu4JhCPZhTHmKAKVV8F41jOr/OkVX+oXT1jp7qebelgx/+TH55Ple8fl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 20:20, Tal Zussman wrote:
> On 2026-09-08 17:47 +0200, David Hildenbrand (Arm) wrote:
>> On 9/8/26 04:56, Zi Yan wrote:
>>> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
>>> page->private != NULL is equivalent to checking PG_private. Change
>>> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
>>> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
>>> but it can cause confusion when PG_private is removed and
>>> page->private != NULL is used instead. Change it to initialize
>>> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
>>> semantics.
>>>
>>> It prepares for a future commit that removes PG_private.
>>>
>>> No functional change intended.
>>>
>>> Assisted-by: Claude:claude-opus-4-8
>>> Assisted-by: Codex:gpt-5
>>> To: Jaegeuk Kim <jaegeuk@kernel.org>
>>> To: Chao Yu <chao@kernel.org>
>>> Cc: linux-f2fs-devel@lists.sourceforge.net
>>> Cc: linux-kernel@vger.kernel.org
>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>> Acked-by: Chao Yu <chao@kernel.org>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  fs/f2fs/f2fs.h | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>> index 9940a6cecf1a2..2f7ab5888b078 100644
>>> --- a/fs/f2fs/f2fs.h
>>> +++ b/fs/f2fs/f2fs.h
>>> @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>>>  }									\
>>>  static inline bool page_private_##name(struct page *page) \
>>>  { \
>>> -	return PagePrivate(page) && \
>>> +	return page_private(page) && \
>>>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>>>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>  }
>>> @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>>>  }									\
>>>  static inline void set_page_private_##name(struct page *page) \
>>>  { \
>>> -	if (!PagePrivate(page)) \
>>> -		attach_page_private(page, (void *)0); \
>>> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
>>> +	if (!page_private(page)) \
>>> +		attach_page_private(page, \
>>> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>>>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>  }
>>
>> Very weird interface. Why do we even need the page-based interface still?
>>
>> $ git grep -E "(set|clear)_page_private"
>> compress.c:             clear_page_private_gcing(cc->rpages[i]);
>> compress.c:                     set_page_private_gcing(cc->rpages[i]);
>> compress.c:             clear_page_private_gcing(cic->rpages[i]);
>> f2fs.h:static inline void set_page_private_##name(struct page *page) \
>> f2fs.h:static inline void clear_page_private_##name(struct page *page) \
>>
>> Seeing code like:
>>
>> clear_page_private_gcing(cc->rpages[i]);
>> if (folio_test_writeback(page_folio(cc->rpages[i])))
>> 	end_page_writeback(cc->rpages[i]);
>>
>> Makes me wonder whether we can just use the folio helper instead?
>>
>> In f2fs_iget(), we enable large folios only when !f2fs_compressed_file(inode).
>>
>> So naive me would assume that we can just get rid of the
>> set_page_private_/clear_page_private_ stuff entirely.
>>
> 
> I have a WIP series of ~30 patches converting much of the remaining page
> users in f2fs (including the below) to folios. Still have to do some
> testing and clean it up, but hoping to send it out in the next couple of
> weeks (in the hopes of eliminating some more folio_compat.c functions by
> next cycle...)

Indeed best to wait a bit before flooding -mm even more, it's rather a lot at
this point.

In the context of this series, it would be great if you could review whether the
diff I proposed would get the job done, thanks!

-- 
Cheers,

David

