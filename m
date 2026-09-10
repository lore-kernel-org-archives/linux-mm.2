Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE92C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D206B0092; Thu, 10 Sep 2026 04:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0C76B0093; Thu, 10 Sep 2026 04:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B0E6B0095; Thu, 10 Sep 2026 04:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4BF6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:43:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A72EC0406
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:43:36 +0000 (UTC)
X-FDA: 85197214032.05.64346C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED5DF40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:43:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byq2LKLh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byq2LKLh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789029815;
	b=DSdVB7BBF7+cspv1owx3ydUoiUjOGrLmPJZF8qTRgAxcnnt+siWua9jM0JXSBG+e6QcS8D
	FGoUPltp2Soi3/a1QCu6AGeHQym0qjSGDvrybHQUbspSX5sQwCZ0MykS2r18wPecVihNOo
	4x2qPZn3rZ3UYVB01VCaBW9ZXKONRpE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789029814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isEbLjZPk/dWe3bh3R3NrHmu/Mf2w2fxrs7ayu2qcdw=;
	b=psD4z3uXTRqrdgL19UMLYMNF2g7vDJJwcKzqcv9WbqgM3jCoSCX8L/0sdg2Kpwwsq2LM9C
	UIDlSS5SX4dFFh2ZWx11t8rkRh7u+/5YCoq9ZiYubnvjzT3XGVFmbR+eWJZu1SXRxE3Q45
	7U53/S75Zx1gfal5N7Wo+9pLYffjT2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 302A2601F1;
	Thu, 10 Sep 2026 08:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E2E1F000FF;
	Thu, 10 Sep 2026 08:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789029813;
	bh=isEbLjZPk/dWe3bh3R3NrHmu/Mf2w2fxrs7ayu2qcdw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=byq2LKLh5wTPUorRM31M4sIDve1usn/sR9AsugS+bvOrGQ0q2EKGgRVXELonBPepU
	 Gn/ViuRSmp4XQJIJwRhWXFWkxkPKm2DGlFogH16zZxZ4iQ+ZT657K+3xZK25i/81Ba
	 /x9+5v5YgJ/Ss1CNrGmD1seqX2AeaYn3Rr6m+Y3DTYKPFs/q+eB8Z4G12iJU0ttEVS
	 FO3rPrBkfjpUK1Xapvv8Y6OhQTd8GKz4pDNUe7SJmYLqM0XOoH+1pPTyY8r0Qp7xJI
	 usAbolvU3Qop8LaA1p6AQexHn/SCerYpxEyDLJh0l50wTRBXHITBGPYo166RCBroFP
	 bfg4rcYtiE2Qw==
Message-ID: <d700c4ea-b54e-4195-b124-3c89177ee49e@kernel.org>
Date: Thu, 10 Sep 2026 16:43:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <7e11c56d-05e6-48f0-b5b8-b4a0e18ddc1d@kernel.org>
 <520b6aca-b515-4720-977f-1adb484f2e08@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <520b6aca-b515-4720-977f-1adb484f2e08@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ED5DF40006
X-Stat-Signature: 3c6s6qryph1z7eywio4jwzwtnj3iaiz6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789029814-400641
X-HE-Meta: U2FsdGVkX19rSP3gwKPYmx/tCRQB3r3vZ/HCQ1G/To6N0yDqZOCYAfHp9ojM65nLe/sN+N4qDPKVvFAVO0u9wF/LpOVn39JQiJHBp12fW5XHAFxrY/naTf0N/jf2NiFyhUow1apakCOkknRJnzglC/Qxvn0ESRbGgv2jZWqicMsIb8uXqKQedY4nHI1RDq6AxeFWPHoHhjIQ073pgmJj/TiitY3ReYLbQuyVjOWvHPcyiMQrMLPx58ZdWNiJc9jjurTMrwT+zui3vcjigkGkXtgkSAtmY/FMZAYk1KAneQnfy1CoFz9XZUIFvJhjPSzpD/28Y5qjnylJXOQ42I6GaCxBdXPQ/bqAynjn37klDWHl9z5ycksexywLLkugFJh7AfQcclGItAfBnBw8gBHFTxHV1ICtXVkrbwL+ubhUZZCdTSP+EFNdza/jOLXd52LDZyhD0YV3fIsunWMKLGm4ljhVibsoyqFzgiOCAr1y8EXjj0izMkIqE047mIoyuhV27Avix6QfwRw8X/8F2eCadJZJldizhWj4F3gp5tptOyd/iywLGox/uf2zgfOpQ+stGDWUVnDSvLBmBo5NH7Jl/fJP6yu7LJZeDGU+8v7SnSSVpBFr6AFBeseJ3CIxvP0ijwCBgAHDyIGYSkjBHBeLBaRc7dC5FJ7TlHtQqeayjoGbrDn5iTOvD5FiXXq97Dc0SCSJE3Ym74uIcM0uJ4A17v2Vr1AU+zbENPIWMDQp2UB6b7Z9LnIE18XGIPIe7EUk/A6bVm2lTMP/Krf00goUgvQ4jJNAAu1dO5CtVrmYBYI4btyyBzXcI2jgkRuJHavcHRioJrKoSX+MH7Mg2GE/6UqTfkHw2+N34gGvf/1VcKdZOITu8NtRmseLhrtg7Bkgu3tH5eLcKXaLhsx9Vz02hqIMqInY+HPB25xpwtJP0pZov2LfKUXLNoLn98JL2cccxV5+q1jrrgb6l0/pjQV
 2fofIL6o
 7NXtOo3iGCLY4x+JhzJ+R/L51s+K9ip1CUmBEqzMPgibdfbvWk+sCkyt/fJg/4pX1jE085+Ttx+d7OEdoviqvOoPbdu59fW4hAnMuAKuPFnOSiJnaY1m0Hfy2ngFy58E5saG0bOnjLhq4Dpv8XgHdvfGV6WRFIVb8z6qOWZblT0zwSAmk9qgX+jz3mSfM7L1dneJJO+osAlCrlWv0TChyXQXWyrR1QB1/A8olROOxtyrrkHsuS7wIcV32P7YVW8W+SMgw5914HLHutRWxGZubZzMXSmmqHvARXe+FbYWw1j8RCVxqD92rPFfVBehn5M6wjARxsLOZQe/gz4yNOYWR6S5aMi8xEmiyXvBaCW0Ow8H+6/9P13++YhzzUQktEXnFnB9V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 15:34, David Hildenbrand (Arm) wrote:
> On 9/10/26 04:41, Chao Yu wrote:
>> On 9/8/26 23:47, David Hildenbrand (Arm) wrote:
>>> On 9/8/26 04:56, Zi Yan wrote:
>>>> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
>>>> page->private != NULL is equivalent to checking PG_private. Change
>>>> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
>>>> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
>>>> but it can cause confusion when PG_private is removed and
>>>> page->private != NULL is used instead. Change it to initialize
>>>> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
>>>> semantics.
>>>>
>>>> It prepares for a future commit that removes PG_private.
>>>>
>>>> No functional change intended.
>>>>
>>>> Assisted-by: Claude:claude-opus-4-8
>>>> Assisted-by: Codex:gpt-5
>>>> To: Jaegeuk Kim <jaegeuk@kernel.org>
>>>> To: Chao Yu <chao@kernel.org>
>>>> Cc: linux-f2fs-devel@lists.sourceforge.net
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>>> Acked-by: Chao Yu <chao@kernel.org>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>  fs/f2fs/f2fs.h | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>>> index 9940a6cecf1a2..2f7ab5888b078 100644
>>>> --- a/fs/f2fs/f2fs.h
>>>> +++ b/fs/f2fs/f2fs.h
>>>> @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>>>>  }									\
>>>>  static inline bool page_private_##name(struct page *page) \
>>>>  { \
>>>> -	return PagePrivate(page) && \
>>>> +	return page_private(page) && \
>>>>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>>>>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>>  }
>>>> @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>>>>  }									\
>>>>  static inline void set_page_private_##name(struct page *page) \
>>>>  { \
>>>> -	if (!PagePrivate(page)) \
>>>> -		attach_page_private(page, (void *)0); \
>>>> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
>>>> +	if (!page_private(page)) \
>>>> +		attach_page_private(page, \
>>>> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>>>>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>>  }
>>>
>>> Very weird interface. Why do we even need the page-based interface still?
>>>
>>> $ git grep -E "(set|clear)_page_private"
>>> compress.c:             clear_page_private_gcing(cc->rpages[i]);
>>> compress.c:                     set_page_private_gcing(cc->rpages[i]);
>>> compress.c:             clear_page_private_gcing(cic->rpages[i]);
>>> f2fs.h:static inline void set_page_private_##name(struct page *page) \
>>> f2fs.h:static inline void clear_page_private_##name(struct page *page) \
>>>
>>> Seeing code like:
>>>
>>> clear_page_private_gcing(cc->rpages[i]);
>>> if (folio_test_writeback(page_folio(cc->rpages[i])))
>>> 	end_page_writeback(cc->rpages[i]);
>>>
>>> Makes me wonder whether we can just use the folio helper instead?
>>>
>>> In f2fs_iget(), we enable large folios only when !f2fs_compressed_file(inode).
>>>
>>> So naive me would assume that we can just get rid of the
>>> set_page_private_/clear_page_private_ stuff entirely.
>>
>> David,
>>
>> Thanks for the patch, at a glance, it seems fine, can you please send
>> a formal patch? then we can apply to dev-test for test.
> 
> I'm hoping Zi will drag that along as part of this patch set. Is this fine or do

Oh, I see.

> you want it sent as a complete standalone patch (will make merging Zi's series
> slightly more complicated :) ).

I think sending as a separated patch based on Zi Yan's patch is fine, since the
purpose of this patch is a little different from Zi's one.

Note that: ("f2fs: stop using PG_private") has been merged in
https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/log/?h=dev-test,

Thanks,

