Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C3AEE209D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251B06B0005; Fri,  6 Feb 2026 08:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21BDD6B0089; Fri,  6 Feb 2026 08:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E6D6B0092; Fri,  6 Feb 2026 08:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE0516B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:01:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9AA01A0120
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:01:04 +0000 (UTC)
X-FDA: 84414042048.19.E8642C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1B6A120023
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:01:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1TvsrKu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770382862; a=rsa-sha256;
	cv=none;
	b=b19l/qUDde7YyJYCLLlCcazxzA4sFoxaeFl7EYZUXjHG+eeo5p0qdoPLzoipHVsQWZchQR
	1XrBL5Ber+a5uIXx27ZI++gDH7ti0Rz2aWS5ISVS963uEui4pq/ac6ubGxtnZD97r6NnwR
	d11po3tnzWQuDs9jaBQK76kmz54lrVQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1TvsrKu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770382862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDB7SpH1D7FRzaEdNx4gEkY2tTWXwP938N6PHRW4uqk=;
	b=RxHkl08vkKRAivf0Ll71RELwTglFpSAIP0Dd3Fy5h6FeN8Pwx9kAHLabEozvv4crMcC4Iv
	79XGT5b8v6V2odhAj284f1l0hap4rqXzRgpZSE8KTQybqUQQ0MRIpRNCiu81p3mi4ry0vE
	uxDoJ4jJwVwKwyxJbkWI31r0GdMiKtw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C455D41755;
	Fri,  6 Feb 2026 13:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DA8C19421;
	Fri,  6 Feb 2026 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770382861;
	bh=xmLMB+sdewOcCxQz83Kl8Xqpk9X80TVAUBfSvRJdhE0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k1TvsrKuDX4ULVsLQHNN3r/U8zVYERr11gg7p18nkto5s8l6xgrLSFvCABym1KroS
	 hSf545ZUDsS066b1eoRVkxNPo/nUhLdax068IyipdGdOYA1qK7o0sa4aiyKHZGLyN8
	 VpM4K/08ZLkKx94jn2snGBs8p6TTyrI4Tg2v8dwGxrRkPLr6HUMByBgqEgnRhso2Lh
	 zvqVcuvOTtkXZe6QFp1lR/+3ounkJZscyMNEyNwVDhLuIj67yp+r6BVp+7XNjnJOdU
	 VwunTYuNceAdcWO5mtMYEPOwEm89jqsbaAGEuKrDJI+hmYCZKvtUmOnmB24N/3Jp+x
	 W1t9upOlirA9A==
Message-ID: <2bf497eb-47b0-4eb9-a66e-607c82c36c20@kernel.org>
Date: Fri, 6 Feb 2026 14:00:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] mm/memory hotplug: Fix zone->contiguous always false
 when hotplug
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260130160635.2671167-1-tianyou.li@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260130160635.2671167-1-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C1B6A120023
X-Stat-Signature: bc7f9ez66nxtdqas43iik6nxnbzcha44
X-HE-Tag: 1770382862-147491
X-HE-Meta: U2FsdGVkX1+mz16kxlpA1R5DXuLM2YA7QLqsNj+A25u5boSXwHenCDQNOtKg6q7BzqqS7MboqItxNzuL1FtgWmvpuZTsNV9exzOT2ZV3J84fz5kEuPP23idAzw6LFQ3Ff1bCH0F++a4ff4IgsFmYfGO8iPHKDEOt0NELecLOmv4aSRvxzi/6D3BLyJgxf4IGJeGjIH2ZmlHg2oxzNue1zqZd8nsN0xfBr7lJYJb/ZIkJS5PygDnrTzZb5uBJrjrIDqjTAP8vAoFdtUlu9CcAVBRWJE3dCI6VJHvFbvaTtuP+Zbv/vRz/o0iOQK6TNmbMQjaz0UHIVACG7rngKLFh1M4Fc+2kxzqazPmsVZI8geD1ac+FFHKlQCbEamPyH70/DXxwWGxvA5HFQMxDwb/14RPGAfhMMy1hlkAqbPRSvRSn9zT29NWV7W6MLEFfowLIh+Nd+6QM9frrhqdo2TwGIpgsFhnyenUzWx6ckR+G0EfDnXlS/UT0crzQySJiv0IXab7YeGZdlzRE3XOnlb1IZKqL4bM1OORHypkdFKYUWKt3bTfSD03ZAUXxQXQD4ph0lt9/4D2xQ/GjxqrZh+c1Pbc0QXU4qImY/fr3dfXJxiUC7TEPdp6tbbWHx2+NUNHn8ahhZhqXT/WdQiKA50IrujHwy1CVsjS2CGKPCwf0MtyKifQ8IrSMhSPjZyPu7crmmXy9RqLkHQaNp/BR1fNRS4Sk89esVbFs2pKUImxkHOouZ9NOcAq8jXeq7KWM4HumHv0G+HbGHorQ5vMTL4+/51XDSC4XKOZnAFC5ijlMr6OW25b2OiIjZF3EkQRW49IEt64X+EPazw+BxF2DAfaCEdoA9BT+uB9wrQdbUEi+FT0xico+5KfPo/GUPd4lZrjrzEf6M4dOLsbJr5Rqip3MjFhuhV16jlgsW6wOMUxqAiZbOFN4F/K945Blc2UYYZNj1oreV9kfKif4hmSRBHz
 //uybbbA
 +pHRV+K2vWuR8Dp2YSKUlWbZZ8B3Xmx40/Z72TSLYiwK7S69BZK/br7g6B35tDvrz1gAUZ8V4fW+NAwNmCqHODZDOUnclVqseKmbTwBApyB1DEcr7omelkL7XVhaOlrBe45NEcfjm9i9SghjxPKfU8ScR2i2dNXJRTloqoUaNuTgToMFShMN33eChzDrJw4DwQcOrzTvK7rwu81QQBwcz7x594n7mM/LzOEw9NOR9TMuN/QPGCNa5xBZgk07adirJlyoPm+b3g/RkLOw1N5uOQ9xCuNvIctyZEskj9ZgmX1/dzvB6GdOWDxt2OdcUW5s6i54GQO0l1E6DV61nsuuamaMqO0WSFLaWp1r//Zza2yJJ4OQnWjcCxdNhG3j3IN+mj60mbE5inUTq4SJh9/Ifkr2/3be6zclyyLqaUwtMncx0mYqNLsNODCawwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/26 17:06, Tianyou Li wrote:
> From: Yuan Liu <yuan1.liu@intel.com>
> 
> set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
> pageblocks that either do not exist (hole) or that do not belong
> to the same zone.
> 
> __pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
> effectively always returning NULL for memory ranges that were not
> onlined yet. So when called on a range-to-be-onlined, it indicates
> a memory hole to set_zone_contiguous().
> 
> Consequently, the set_zone_contiguous() call in move_pfn_range_to_zone(),
> which happens early during memory onlining, will never detect a
> zone as being contiguous. Bad: the fast path relies on the zone
> contiguous state may skipped.
> 
> To fix the issue, move the set_zone_contiguous() call to a later
> stage in memory onlining, where pfn_to_online_page() will succeed:
> after we mark the memory sections to be online.
> 
> Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated to have holes")
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> 


I assume this one is to be ignored :)

-- 
Cheers,

David

