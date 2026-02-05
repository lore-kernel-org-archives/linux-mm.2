Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C04CEEC1EA7
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3377C6B0005; Thu,  5 Feb 2026 06:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB276B0096; Thu,  5 Feb 2026 06:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217786B0098; Thu,  5 Feb 2026 06:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10C906B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:58:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7141C1B27D8
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:58:49 +0000 (UTC)
X-FDA: 84410256378.24.767CF76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B5B8AA0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:58:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XhP7ik1L;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770292727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmmdvIwhybDhFqBs6aJZscFp02FRbghf0sarFdacbp4=;
	b=1NJRLB5X5TjhqIolOMWYokijcIaaunF94HYrGIa5HP+lSrf9mpYwAC3jlzWVryPdzYnOdO
	EiIL+gH3arR7t/ZZajziIPdST+UUqVWbMnzxEB3rA8+Y9dmwtDsOx9HlG2/p8a8o4CbdWG
	r2R+9zva/nB3VGBAIRhNfkkhH096auQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XhP7ik1L;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770292727; a=rsa-sha256;
	cv=none;
	b=t8c7M5rNtA15KgPj154kfzZ9PNMKrBMILeHZtPdau8R52BuXCdmn7SXS1w9zkeKPjRl4Ht
	b7JYfpLD1tLCId6ABTgcuew2+60oRoWavpTcxE3pNeS+1Cbk4f3ZkVgpP2Md3tx+DkLUy8
	7mVnH26jOnAJgKqmLEDNFATA37bXCCk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 192EC6013B;
	Thu,  5 Feb 2026 11:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D731FC16AAE;
	Thu,  5 Feb 2026 11:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770292726;
	bh=GDq3H3vjByLJ3Ey0kNEDQ9d9kRtQLl25iHAO3wBE/5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XhP7ik1LXXfjNBnyfS22rv87pd9aNzA7BcYBKsfG9RyitOwBNzkdha7F1F7HZtWZr
	 RKBCmDD51vVC22UoKfyH6wrLbffbTfdiC0gTQD1JCJbEACzWG3TJwKQG/VkBznINwu
	 /ZA4R3A3YI4nncmqbyPAzJA02dOTh2cDW8EN8Ao7jJ3aA77B5XeVNy/ovVk5CZ8w8X
	 e1Y+tNsNKXvgMZKwU9kCYPB4yfbIR1uDWadA8KUph+ddThGFdlkvOYT/Qwb5KlwwBB
	 0Jwoq95Os8O3bf9Vk7HiDT6jtCWjHqVHLE0NxlQQrPerNxMnNkhUWXvnE8Ti5NvXpy
	 eGcEwZJrSTb6A==
Message-ID: <8deb6010-3abd-48dd-8b77-40dbf2d48c65@kernel.org>
Date: Thu, 5 Feb 2026 12:58:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 02/17] mm: Change the interface of prep_compound_tail()
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-3-kas@kernel.org>
 <a61bc0a8-cf5a-418a-aeb4-96553b87f043@kernel.org>
 <aYR-YULI3lBtl9y_@thinkstation>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYR-YULI3lBtl9y_@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ahk5jrppd8k3qfwgawu41f9i3cyrou5n
X-Rspamd-Queue-Id: B5B8AA0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770292727-493567
X-HE-Meta: U2FsdGVkX1+/NNI/EoiM6ha58fr8V9hYGAjJPdfD7zNNyoyvn42lrxp0lcsS8q3frMA5oAV4rlN0TGhj4DY1VtBkZugi1UQl3OxvrugpdMXho9dJZ4N0cHSgadshwPLLJByVoAQLswR79tSqBWQ08NVk4DiT6LS3OIOvgZloJMXH3Cxw92kUuXp1JU+xBuZZ0DS/cz3QVfhxNliKTxL0kGSlBRymLOOWSi4m4OHtMX5HaTb7MitW82huv0875ZewJWqfhbpWvAZsCiICzg3SYZmUMg6HtzS0dp1W0QdfT00m29r9c0ALST7qDFswnM4HtOgdu81zyjvVqVZMIbnQ8XNIYZmOZVWFtCwMzj5xxZg9yDEe/KExdUsxO2n5UQcWPfS1hHmHLa2IUkRxJ17pnSBbPEUDyxatn60iO/DJu88XxbUIehWftL8LHtxdJ7bQFMKiVOI26Ysp4VdNoDlS8kCjHbMZoXZ5fYASp8LTkLnCV8jKjKyrLnGLHoyRUq6F3zTSdayBBo0aFa65d9mDHhKZ4V+BeKg+tGwMdWe5OviqkeCu0PI2UqraAcaVNOvb0xWdgv33XaM/5l8nq/8cpVUuwo7v0o/kkSg7mxG6QZy/IJ+3Y0STyrbZZaOTbQ2CNGO41KHxEgJ+TGSejqZBWNLpdxcrnWbBECUHSZzkW++THO86Y09Cm9N1q5Na2lT88UkZpiO3/Hf7G18qEViSQLQhCYYtG88b1bLUsHVHy+42slQqT9t7A+AVuHdz2S+sC8XWlE+A96+2OYHiEwTD2NWgtoEf31YnjM0JO1o+kUdLvTUJYEnGe25NUHZyiUGOeRvAkILiw563G6O+8D8sDOUrJpXEK39vmPRIiyzsmYkB5pNdSqp2a2RugDNBq7FEx11feyTPoQI+r1PYuFkhgBCI7cDn+/vJAlG/UnzEcnl1ZIGc0QRTxpplB7d8oADrNUkSD4dvVhHDLPyZVfR
 f/wxuaya
 uRLJZF+guUWSoT7tkF+mi+tpYSF8Ma+hNojKPdezydRgtjiBMkSkNxWNgy44RqoBSJH5K+yv0HWaCEOMczAydZUnZy2ckRvN7Wdhj4VUJjEA2S3sdTGibbxh6LhRStLggklsAJFmRvmW0xm39J3foe0g3JPYOaKxyspZIYtNDB2mkabflKQyco4zzEmw62wfVai7oGGwKwOQ4cMS1HqGc/jaMLtrOYtPpvMAvwy2fFBx6f72HK81Mbwtxz1Gzeh76Sra0WnV5qfMyXO8IG8dSEjHx4tNHBrgsqkPaO1za8kBo9vazhKKng88VjMPWD9PkqJ6a06Bvy30KJTpIr4nFPL1xdJq5FK7n7qo2u9wVxnBmc2VdyzyBDoDPjmmnhC0sCktl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 12:35, Kiryl Shutsemau wrote:
> On Wed, Feb 04, 2026 at 05:14:12PM +0100, David Hildenbrand (arm) wrote:
>> On 2/2/26 16:56, Kiryl Shutsemau wrote:
>>> Instead of passing down the head page and tail page index, pass the tail
>>> and head pages directly, as well as the order of the compound page.
>>>
>>> This is a preparation for changing how the head position is encoded in
>>> the tail page.
>>>
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> Reviewed-by: Muchun Song <muchun.song@linux.dev>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    include/linux/page-flags.h |  4 +++-
>>>    mm/hugetlb.c               |  8 +++++---
>>>    mm/internal.h              | 12 ++++++------
>>>    mm/mm_init.c               |  2 +-
>>>    mm/page_alloc.c            |  2 +-
>>>    5 files changed, 16 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>> index f7a0e4af0c73..8a3694369e15 100644
>>> --- a/include/linux/page-flags.h
>>> +++ b/include/linux/page-flags.h
>>> @@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
>>>    	return folio_test_head(folio);
>>>    }
>>> -static __always_inline void set_compound_head(struct page *page, struct page *head)
>>> +static __always_inline void set_compound_head(struct page *page,
>>> +					      const struct page *head,
>>> +					      unsigned int order)
>>
>> Two tab indents please on second+ parameter list whenever you touch code.
> 
> Do we have this coding style preference written down somewhere?

Good question. I assume not. But it's what we do in MM :)

> 
> -tip tree wants the opposite. Documentation/process/maintainer-tip.rst:
> 
> 	When splitting function declarations or function calls, then please align
> 	the first argument in the second line with the first argument in the first
> 	line::
> 
> I want the editor to do The Right Thing™ without my brain involvement.
> Having different coding styles in different corners of the kernel makes
> it hard.

Yeah, but unavoidable. :)

-- 
Cheers,

David

