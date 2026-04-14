Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1C3ED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB05E6B0088; Tue, 14 Apr 2026 06:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88446B008A; Tue, 14 Apr 2026 06:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DB26B0092; Tue, 14 Apr 2026 06:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89CB86B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:20:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CF6C58B11
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:20:32 +0000 (UTC)
X-FDA: 84656767104.04.D0C6F46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4242C40002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:20:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Za1ua/c2";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0h7ODnzRoQxwwbG4YgZDOIQbuA7NP+BVAo5B7S2hcU4=;
	b=ejj7n1/BDvkR8rIW7EZYSqsERtOSHJt80Ouhw/ucv0MuFlDazQj38mXrK9irQw2YJS0IA5
	ULX8wI47UntigQHJuToLGiGE4c62P1LVBN4c/KtIp7V3b7fsMltjmNJ9huwbacOqiUOuMn
	+WoLRD687ISRp0eXlS5nRsgox/pNmQw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Za1ua/c2";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776162030; a=rsa-sha256;
	cv=none;
	b=Sx7cN1wEPqakLj0IUtIEbbDOx7mE2ORoaSf/rGxQ4T2QtVm8cJYeUtYrKhfQ3hd6jg3PSb
	ZLBFD6G21XM6g7/edx8ypDfY4kXWhCIBlcjz8WkH5ZDaG0T07oGKcU8vDF6xjHYYv9/2BV
	2v/atNSBTFxo+lIjI7QymGpUrgk/FmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FFC542DDE;
	Tue, 14 Apr 2026 10:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADE4C19425;
	Tue, 14 Apr 2026 10:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776162029;
	bh=RGgiwNNKERTEHoOTPwB9B49AuENlAfKt7sU34JQ6brg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Za1ua/c2pBc2SFfHoE9LK94I5v2vvCEqP+T0fD3yg+NZGgSkqjcAQQxDo2PuyT0Oz
	 7kSmatnHBwa1r7/ybCAH/w3+bmRIPw1+TfawF6oZs78YEU1C67uRFNC6NrS+8MJKST
	 09IcwKF/jVZTrrrd8G6cO1uwfujb/jWnDqH9tBmvTRMN4N9zXYVYfHqjTwVAFSPH+F
	 uqP1+HavbMfQufGK87I6hQNJp4AAFX4pxRtSjSbq3k/zBJjZ8CthPl/3tGhb2QAOUg
	 LKkUF/rIlqdQsvMRkME8GYw7YHGfvaO7yVdIYxOiqU8wOYc+5HQ7lO/DNl/LzqSkBw
	 syvj5qllWnvuw==
Message-ID: <45d8e6d2-66f3-4ce9-8f01-7c47cd81e4e5@kernel.org>
Date: Tue, 14 Apr 2026 12:20:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
 <ad1P-bfr_Vp6VdKf@casper.infradead.org>
 <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4242C40002
X-Stat-Signature: nkyhwcf1gn5i8hp455atf7qk6ydhaqds
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776162030-735651
X-HE-Meta: U2FsdGVkX18+LQzOZVidufFfQy6N2qRGbWG6ySIId0HtE2t7bQnSbrvABxt7hodLcLMkQgzn78sHyIvsquoX/im/IWvUY1GWvRORaAM2cuQFvbbKYuFlOOtPVvwva9jPxT53wO9lp7ynkpkVWpG8Zfa4tFuWYJx5iGXInRiljv8uAO/pp/yAAeQolJJJLdbayOdihaEOhIdvt7INWOpjUWTHF1a5SzA3uUY4tS2JKi8iizY6eJ02apCVV3Xa9pJVJj2ACM1furJ38JRz0U0yvx/UWB385W2pZYAmzyCAbRI2nwtVEudK/G1Nfrf00U5rl4dOeMTx60bg0cXh7w7qbavGEXtbGnhtGffomeFecnwFLnZFuSKWcaIvAxWcpl72mrt5S5SsQ+pwj5ErB1xVYQtBuO4ABTpQJGInCOPQElHLh9DmCqdB8uLW0Ga661FI4TOfRbT1sG76tYNQRNmCUpIycFiKHKWg0f7iuDmn1nRqIDpQnpM1PFk8nKh378bIhZu3MC9WEZ20Z2QOxQmW2e7JIuyp4rknRHpF398ISY81zCqZQv6LOY3AgWDEqm0C/UxBPYoMuPYD6zADpzzzymlj96Vwf6lMTu4rMiMk51BJgNn8beFzkvP1rGgugcidIkhfffbE8z1MatXuisMLwIQKTGr6eKwYdSs3iqsJoN5PUsAEluZvJTDuhDQQwsw54aXEHpe6CEc3CCBtYG2Ryh3WGxEPrJfaaFLbY4+q6Y4Ri4Ctys7cepu9f5QMv7aB5mAc+j5FpieuyftdTTaPji9HO65mgYy7t+9C8UwBRANeUGfTMwKW08SM8SanjOQyyqh9S4hs1WUnWbk55j47lMLM9JGgVpeRCvWi0MukIM0Gh5F99eS/gjqZ0POfVrjktY20nOyuVxpIm8LVEtnx/40tzQG822GqJ6VbI7+/dy1xnYByNPqLJiJijMc8UevaYVaLxRpdNL2bj1TpDyK
 ncYHEULH
 jgggp//fn3xtZoEWSpcJlkd61qGJwQj0EWUZP53UB0yK9CYY5M1gssMaiU96JDl4HPEu4BgTDrCkpPH/yICnIhTFpPH6VbTNYxSAROaGiD5ABx3NhXMa4Y4/BfDwyS+LyQVW2RdRxuIRZ6cmGm5Md8vrPjlnxB46Egoniwvw0Fbd5mIRe8jxCrR+Pywm3ihhWFe1JNcjT4hWou9D88h8oL2azTw1xxhVcY784UIhjlOSy9bt/KcfBZ7E5s+ptsTL+Lv0HVO5X4MQSH2pRd0ILE2tdF8xXzDkJDkSSANNhtiTq74V7Opu9CP1UDsvRW2mcGMJZEhYBtA4vMfIqKLwmK02v7mwNkj1hkEGTWIw0xNj++g4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> huge=never       Do not allocate huge pages.  This is the default.
>> huge=always      Attempt to allocate huge page every time a new page is needed.
>> huge=within_size Only allocate huge page if it will be fully within i_size.
>>                  Also respect madvise(2) hints.
>> huge=advise      Only allocate huge page if requested with madvise(2).
>>
>> so what's the difference between huge=never and huge=madvise?
> 
> I think madvise means MADV_HUGEPAGE for the region, not MADV_COLLAPSE.

Yes, most likely. The doc is quite old.

-- 
Cheers,

David

