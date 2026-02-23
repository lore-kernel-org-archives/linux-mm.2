Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92497EF5865
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 04:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3BA6B0088; Sun, 22 Feb 2026 23:40:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961EC6B0089; Sun, 22 Feb 2026 23:40:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DF66B008A; Sun, 22 Feb 2026 23:40:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 72F406B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:40:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F1D45B282
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:40:50 +0000 (UTC)
X-FDA: 84474471060.14.CE0D3BE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BC6E40003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:40:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771821648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S9ZFDeiM6NdQcCiJ+nraBcHIfL8WQvsSeV0CrSVAofE=;
	b=egUvg86V/esGABcH3rrff7pobuTQY3zYXKFV7+LxZ4vHp155gdyyfCASgsCaoX65c0dyP8
	W8JH9x/COHjF3HMUegjCsV9IlZ6fOya8UjpM/kniMGPp09c9pH4myrIEIcUjBYsgmegleK
	RsrmGYDB/eBzlQMwfVMgQA1Nyxbp1YE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771821649; a=rsa-sha256;
	cv=none;
	b=7k7snpkiuoLvHedASaLJljEfPHMFe+2g4tefUSC8N/nYK1PooKhpkcKYA4902PUVG4y264
	rgdZFqYrJcjhEpWkS/ijlmdfX97cuzzvpaRPcPXptJYNNT4YSrIcmHIJBeglCAObQQ+zhz
	f3KW4Hbn3/nDuaLaKB/N9NeZHsCg4ws=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A03D339;
	Sun, 22 Feb 2026 20:40:41 -0800 (PST)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 118753F59E;
	Sun, 22 Feb 2026 20:40:43 -0800 (PST)
Message-ID: <a0b4febb-d803-4c18-9211-7286d682d705@arm.com>
Date: Mon, 23 Feb 2026 10:10:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] khugepaged: convert redundant check to WARN_ON
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260219054827.4111334-1-dev.jain@arm.com>
 <20260219143327.7693e4b1474a337821e4c637@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260219143327.7693e4b1474a337821e4c637@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BC6E40003
X-Stat-Signature: ykh9dsn4cizwr4b3bp7a1f1asjwhxqza
X-Rspam-User: 
X-HE-Tag: 1771821648-656226
X-HE-Meta: U2FsdGVkX1/0gdHgpIFwQm1wnrGSHwPj7QMeYf3WNuu3gHKR36Lwh13+J3wbqnhwpp/VHHcenJoPfDBIwuLIf1a+bRMb7H/YOxee51SF5Ff2uoqgp/ZUrkp0CFWUPSTCO4scRSu6uHrax7l4kE9Ow0ausB4Ym9Ihusk0GcXOLGm1kc9SXLW6U7VzmCUDAmZojQsu1UPbJX6TYb8AVFEbPIMfLy8zMyfnm4NByrTOgR6eI4tK2QyET5NEQCmaj1/LcdxQaoTiGZC6ZRCCiRaTaF9+AReSyBwXqeSFnUAwPDXhkSgKh+8O8CoSIuuLZwEtJl3xFXM/Pgq+Sa5+zTPwM3xWcvWozcC3AsasT1TlBCgDsk0FelsspfYTMfebHTgALwSoxl9Z0KZ93qsd9bldhUa1w4VD/kzBxsd13mXNG6WLVLo+X7KliZ8Qypwoe5BplmnkMVfzBrOnvasBWHXsJMOhw1rRgczHLAxLETGHLhbh5qj02FgvuOZ/ogioqN80OQLzDZF3v3dCJA2RvUZmbAwbz5HrXWgLqRpl3AhLmnBMaPD6cgXfhj+rAUv6+a4Sm6OD/6Ux0EjhdIz2rcfrU7EVM7P6DNFA8QWjTBRPZqDvfp2ZpCpoJ+mo6sr1Sn4W/sFFUG/TnI4lmA3/OvETnf7W1wpOEbBitmrlCXxmWtFUOekEk1UIIB+gMynGYLJPg3XBuqZe7HeSZ3kF/7TSbzDOxCnuKmeMzuY7JqNUmxdZmvPnUBuDWIXahtP3PiBG9vLn4QC6mPNo80CeclCqwVcGL70InAwegRlMPDWVbhmwy+O3yBU6p46BJL0U30WGAUcW7240cGXrz9C5jY+Gfokr/pNFdlfSdVvPyMCYugfVl+Et4IpJAhGJsQiUU/rHaUIrdgdWGRiVIb5Lidx8TtCT2Z7CnPff18tiVZI783kkAewCWSMhVeBNxxaL4DOlXzpY3nj667o7gPfZ/HL
 QYo3SOiZ
 5KJudjkDsnxYq48nF9Lj10JJmFK9Ux970gJmefXBePMmDJ2puMS6hNS377dC5vSUNyYqlARkykgPd4iRAcZjpgV4Twl4MrR3NamTExwX6ikTHEkoyOSgwmse3uVfFsBpES5ppw3YdckH0DDt/TwX6rGG+wiuGhpUwT6fO7k+AquYhQpBhO0yiAehDiiATYxInCz0zzI0DkM2dMQz+7USdzvK75WptRV5nW3g/tCfxdGozIivgedgw+Is+Tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20/02/26 4:03 am, Andrew Morton wrote:
> On Thu, 19 Feb 2026 11:18:27 +0530 Dev Jain <dev.jain@arm.com> wrote:
>
>> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
>>
>> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
>> iterate on the xarray, have the invariant that
>> start <= folio->index < start + HPAGE_PMD_NR ... (i)
>> A folio is always naturally aligned in the pagecache, therefore
>> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
>> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
>> offsets in the VMA are aligned to the order,
>> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
>>
>> Combining (i), (ii) and (iii), the claim is proven.
>>
>> Therefore, convert this to a VM_WARN_ON.
>>
>> ...
>>
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2000,8 +2000,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>  		 * we locked the first folio, then a THP might be there already.
>>  		 * This will be discovered on the first iteration.
>>  		 */
>> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
>> -		    folio->index == start) {
>> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>> +			VM_WARN_ON(folio->index != start);
> It's a bad sad to remove unneeded code by retaining that code and
> adding even more code.
>
> Perhaps add a comment reminding us to remove this altogether at a later
> date?

But then shouldn't I remove it just now :) try_collapse_pte_mapped_thp is
anways going to bail out if such a bug occurs, so nothing goes wrong. In
short this check is actually useless, apart from the fact that this lets
us spot a bug (which I doubt won't be figured out by other code paths already).


