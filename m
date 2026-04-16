Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B32F88092
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21C76B0005; Thu, 16 Apr 2026 03:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2836B0089; Thu, 16 Apr 2026 03:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1C46B008A; Thu, 16 Apr 2026 03:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B69B6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:15:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36BACE4751
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:15:30 +0000 (UTC)
X-FDA: 84663558420.06.586E452
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6223F2000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:15:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rXz2Je5d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776323728; a=rsa-sha256;
	cv=none;
	b=mHRm03X1rM6lXi80QrdUNbPwUeH0C9HqFP6UDJ/DhFhjuN/6ZKNA/9w28ws6A/NK5BUDh9
	B9mYIlWVWEWjbn4bglYCnolpk7r8BuH5ns/UmvkRtlaSOxaQ41RMxNJnE/+YKLr9ScMbZd
	IlU68X0ghvd1rBpzGJBTk57zLRMkBL8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rXz2Je5d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776323728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mNIvSUIVKDUnQ5G0PA0CUvX294O0ipoJJUTFwwtVwM=;
	b=Pe1sdby/tY1j1HCzus0ZdPSvoWK1hyg2XjLBF/v7qEjxqxHfebVeRFE6Shq6JacV2xc8NE
	UhtgMHfxlOvHQOt9MffiFarqwhCB8ypLfc0M5IgTYulYALDc6eASqAGZuIrbudlPtPKt5i
	HQP24LOQ3vNF0/gr7Rm91GB1tN3KgeQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6F8F60126;
	Thu, 16 Apr 2026 07:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796B4C2BCAF;
	Thu, 16 Apr 2026 07:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776323727;
	bh=B7pQLuMTV7OzMld6R3PvIrferBs+xTuioGsbXveGCz4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rXz2Je5d+2JJ2rgst3dHJKj/SSpuBlkLafEfiM6DTI0iew+qwqdW2RUH4kTPe2OfV
	 NuMAedt9WPc6PamjvIcGeGs5FsAbpCvwN+z4GzMdvI7jn5p0vN8v+8TbieYkzFiBIi
	 mhHnQ9ulOcTLqsIuExrCiL3QPX2wkAQfTrTEM+6WDVgWn9CXZ9zUdBPLwxhS6hkKdE
	 hlLJofyy6du/7/YMgD2y/fB3Ah9hO3GzJS1giz6LWTxU1NWxw4LgFxzLe44smD7xMH
	 vsu7WTF3WpCsYl5fFJ2k4jksCrQgCCdPX3hoKZ0McvLOBtuLoIdXNuBc6FLiH7lojB
	 ixXZDSWaFNehw==
Message-ID: <fa03804e-625f-4152-a119-389282d97902@kernel.org>
Date: Thu, 16 Apr 2026 09:15:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <20260416022351.llek76h5cik3nese@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260416022351.llek76h5cik3nese@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: nxetak7xum4m41ewigakh9nhmxczq6nu
X-Rspam-User: 
X-Rspamd-Queue-Id: 6223F2000B
X-HE-Tag: 1776323728-792020
X-HE-Meta: U2FsdGVkX19oohkSYeozFDOa/wdA/AHCD9F+n0hP66UwY2na5/UrAGJhymlDwnKHF4Q0vV5eF8xE6We89yIJKw6cOjFbhLDxpDf79NDyANSnfM2KJHlBS4+BPTNoQh7468U6wJcyD6d5vsV1aWQ9SUBHCkwSLjCOtrdE4D+OkcJw1RhNu3qAQc6Kp9g98wK8kk+ymufNFoN1CeEN3miIOPX9pgkm9lmvSqF9QFrKYdPDhK+Mlmu6P2eMv7r72QP1M/PpdOwcbworIhhaxqNDWlCUSP7NkBAKMTwd1bZjAmwP+iJ3SupA19LqlnW6dA3JyhjAG1slYx3St3LEb7oCqoGqgb+vanKXUmpafGI9QqwN9fNTgnNjHUZOYOLGFoPBPZc9pELyTwbuGmh7iJsVXhyQsVk537b09fMuRx6/x+5MhQ8dpozE0eC+S84WP+ZSnAmGtFkvoiWyVba3p+MxFGS186G9QFKh/Lw7e/gw5rmsPt6fXS+4GwVVt5aoqIsMC3+kz3ZJcZcfnRP2GS2dxcuJkmxvAyvrf/mcVYpicgEZtFXFN1TACwQ07uYk0W8TbagV+a3/QnhnBqJqY32f448k08eLnOVtNJCsOq8e41RMEsUsVmD13zwWLfH+7rWqpqCMo7GOprmIIjckrYVB0Fm05ET+exT2lsOUBTuciKmVDA6tWcRGnv/sbQH4WNlQiP2QK4qL3h4fDXizkG7egJPXjVYol/2mx83/Fzv6aUzy2aLsInEL+s9DKVSLFcmLuHGRInePFmBP7UyqQrZV2wgB06gxDusYdscKoX0Ljjbx2d6yklaHeGSUs143zhOWaCHDrzQBqnxwfd8izRXvmPzgr7sjd01YnCtdszmoVxc5+9S+CrZw176HNakFl3U/zjITUfSWGhEBwGUQfFkwVC7TzsN1d5xG/urCCV11isfVhIg2SA1iNgZavGSbzwiFmG0LXBFU5Y8w3ObyuRs
 A0rzkOE5
 MaSJpu7tMDp/O2Aojub6SwnzJtlOQCGx5e+vwtxU0Uqnuy60KZ84N/NI3h1W5Ebas9QAiiP5S1ZeT2nHagTzMuNpTvYaKn3Yh0OtIT7CCrM+/fozIHEJARlZco1GjuVOPtxlrxv3D4ZCKtf0hADtJ39l1ZKcAJnufY6eIrUakEX3mo8aF1IZwvEWRoOiVGdsepcMkWFc4wdkrySXw3o7pRpFhXZBHwpXnrbE7j2ol5kmc01SKGeCbliH21qiTvkjTjCGU+NiBWxq/5Tu+tnVT61lsQ14o8eMQdSoQufGFJOKNi/9rmYM9IYJpvDlTDE25+EWXG+/drkMmv8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 04:23, Wei Yang wrote:
> On Tue, Apr 07, 2026 at 11:16:15PM -0400, Yuan Liu wrote:
> [...]
>>
>> /*
>> @@ -956,9 +957,22 @@ static void __init memmap_init_zone_range(struct zone *zone,
>> 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>> 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>> 			  false);
>> +	zone->pages_with_online_memmap += end_pfn - start_pfn;
>>
>> -	if (*hole_pfn < start_pfn)
>> -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>> +	if (*hole_pfn < start_pfn) {
>> +		unsigned long pgcnt;
>> +
>> +		if (*hole_pfn < zone_start_pfn) {
>> +			init_unavailable_range(*hole_pfn, zone_start_pfn,
>> +					       zone_id, nid);
> 
> One question here:
> 
> init_unavailable_range(zone_id)
>   __init_single_page(zone_id)
>     set_page_links(zone_id)
>       set_page_zone(page, zone_id)
> 
> [hole_pfn, zone_start_pfn) doesn't belong to this zone. Would this be
> a problem?
> 
> But it seems we have already done this for a long time.

Right, we just want "some" node/zone for holes that are indicated as
having an online memmap.

-- 
Cheers,

David

